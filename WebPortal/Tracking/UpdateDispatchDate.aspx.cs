using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Tracking
{
    public partial class UpdateDispatchDate : Page
    {
        private static readonly string[] ImportHeaders = { "DealNo", "LoanNo", "ProjectNo", "DispatchDate" };

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static TrackingListResponse GetProjects()
        {
            try
            {
                DataTable dt = new bllUS().GetAllProjectByUserRights_ForAddFeedback(Convert.ToString(CurrentEmployeeId()));
                return TrackingListResponse.Ok(ToRows(dt));
            }
            catch (Exception ex)
            {
                return TrackingListResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static TrackingListResponse GetDeals(int projectId)
        {
            try
            {
                DataTable dt = new bllTracking().GetAllProjectDealNumberNew(projectId);
                return TrackingListResponse.Ok(ToRows(dt));
            }
            catch (Exception ex)
            {
                return TrackingListResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static TrackingListResponse GetDispatchHistory()
        {
            try
            {
                DataTable dt = new bllTracking().GetAllDealDispatchDate();
                return TrackingListResponse.Ok(ToRows(dt));
            }
            catch (Exception ex)
            {
                return TrackingListResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static DispatchLoanResponse GetDispatchLoans(DispatchLoanRequest request)
        {
            try
            {
                if (request == null || request.ProjectId <= 0)
                    return DispatchLoanResponse.Fail("Please select Project.");
                if (string.IsNullOrWhiteSpace(request.DealNo))
                    return DispatchLoanResponse.Fail("Please select DealNo.");

                bllTracking tracking = new bllTracking();
                DispatchColumnMap map = BuildColumnMap(tracking, request.ProjectId, request.ProjectNo);
                DataTable dt = Clean(request.ProjectNo) == "561"
                    ? tracking.GetTrackingsheetLoanForDispatchDate_Servicing(Convert.ToString(request.ProjectId), request.DealNo)
                    : tracking.GetTrackingsheetLoanForDispatchDate(Convert.ToString(request.ProjectId), request.DealNo);

                DispatchLoanResponse response = BuildDynamicResponse(dt);
                response.Success = true;
                response.Message = response.Rows.Count > 0 ? "Loans loaded." : "No records found.";
                response.Meta = map;
                return response;
            }
            catch (Exception ex)
            {
                return DispatchLoanResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static DispatchSaveResponse SaveDispatchDate(DispatchSaveRequest request)
        {
            DispatchSaveResponse result = new DispatchSaveResponse();

            try
            {
                string validation = ValidateSaveRequest(request);
                if (!string.IsNullOrWhiteSpace(validation))
                    return DispatchSaveResponse.Fail(validation);

                string dispatchDate;
                if (!TryNormalizeDate(request.DispatchDate, out dispatchDate))
                    return DispatchSaveResponse.Fail("Dispatch date is not valid.");

                bllTracking tracking = new bllTracking();
                foreach (Dictionary<string, object> row in request.Rows)
                {
                    string loanNo = GetDictionaryValue(row, request.Meta.LoanColumn);
                    string dueDate = GetDictionaryValue(row, request.Meta.OrderDateColumn);
                    string creditQc = GetDictionaryValue(row, request.Meta.CreditQcColumn);
                    string complianceQc = GetDictionaryValue(row, request.Meta.ComplianceQcColumn);

                    Hashtable htParam = new Hashtable();
                    htParam.Add("ProjectNo", Clean(request.ProjectNo));
                    htParam.Add("DealNo", Clean(request.DealNo));
                    htParam.Add("DueDate", dueDate);
                    htParam.Add("DispatchDate", dispatchDate);
                    htParam.Add("LoanNo", loanNo);
                    htParam.Add("CreditQC", creditQc);
                    htParam.Add("complianceQC", complianceQc);
                    htParam.Add("AddedBy", Convert.ToString(CurrentEmployeeId()));

                    int returnValue = tracking.InsertLoanDispatchDate(htParam);
                    if (returnValue > 0)
                        result.SuccessRows++;
                    else
                        result.FailedRows++;
                }

                result.Success = result.SuccessRows > 0;
                result.Message = result.Success
                    ? "The loan has been successfully sent to the Onshore team."
                    : "No loans were sent to the Onshore team.";
                return result;
            }
            catch (Exception ex)
            {
                return DispatchSaveResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static TrackingImportResponse ImportDispatchDates(TrackingUploadRequest request)
        {
            TrackingImportResponse result = new TrackingImportResponse();

            try
            {
                if (request == null || string.IsNullOrWhiteSpace(request.FileName) || string.IsNullOrWhiteSpace(request.ContentBase64))
                    return TrackingImportResponse.Fail("Please select import file.");

                string extension = Path.GetExtension(request.FileName).ToLowerInvariant();
                if (extension != ".xls" && extension != ".xlsx" && extension != ".csv")
                    return TrackingImportResponse.Fail("Only .xls, .xlsx and .csv files are supported.");

                string filePath = SaveImportFile(request.FileName, request.ContentBase64);
                DataTable dtExcel = extension == ".csv" ? ReadCsvTable(filePath) : ReadExcelTable(filePath);

                string headerError = ValidateHeaders(dtExcel);
                if (!string.IsNullOrWhiteSpace(headerError))
                    return TrackingImportResponse.Fail(headerError);

                if (!dtExcel.Columns.Contains("ErrorMSG"))
                    dtExcel.Columns.Add("ErrorMSG");

                result.Success = true;
                result.TotalRows = dtExcel.Rows.Count;
                bllTracking tracking = new bllTracking();

                foreach (DataRow row in dtExcel.Rows)
                {
                    if (IsBlankRow(row))
                    {
                        MarkFailed(result, row, "Blank row is added.");
                        continue;
                    }

                    string error = ValidateDispatchImportRow(row);
                    string dispatchDate = "";
                    if (string.IsNullOrWhiteSpace(error) && !TryNormalizeDate(row["DispatchDate"], out dispatchDate))
                        error = "DispatchDate is not valid.";

                    if (!string.IsNullOrWhiteSpace(error))
                    {
                        MarkFailed(result, row, error);
                        continue;
                    }

                    Hashtable htParam = new Hashtable();
                    htParam.Add("ProjectNo", Clean(row["ProjectNo"]));
                    htParam.Add("DealNo", Clean(row["DealNo"]));
                    htParam.Add("DueDate", "");
                    htParam.Add("DispatchDate", dispatchDate);
                    htParam.Add("LoanNo", Clean(row["LoanNo"]));
                    htParam.Add("CreditQC", "");
                    htParam.Add("complianceQC", "");
                    htParam.Add("AddedBy", Convert.ToString(CurrentEmployeeId()));

                    int returnValue = tracking.InsertLoanDispatchDate(htParam);
                    if (returnValue > 0)
                        result.SuccessRows++;
                    else
                        MarkFailed(result, row, "Dispatch date was not updated.");
                }

                result.FailedRows = result.NotAddedRows.Count;
                result.Message = result.FailedRows == 0
                    ? "The loans have been successfully sent to the Onshore team."
                    : "Import completed with issues.";
                return result;
            }
            catch (Exception ex)
            {
                return TrackingImportResponse.Fail(ex.Message);
            }
        }

        private static DispatchColumnMap BuildColumnMap(bllTracking tracking, int projectId, string projectNo)
        {
            string orderDateColumn = tracking.getActualColumnName("order date", projectId);
            DataTable uniqueColumns = tracking.GetIsUniqueColumnForHeader(projectId);
            string dealHeader = uniqueColumns != null && uniqueColumns.Rows.Count > 0 ? Clean(uniqueColumns.Rows[0][0]) : "DealNo";
            string loanHeader = uniqueColumns != null && uniqueColumns.Rows.Count > 1 ? Clean(uniqueColumns.Rows[1][0]) : "LoanNo";

            DispatchColumnMap map = new DispatchColumnMap();
            map.OrderDateColumn = orderDateColumn;
            map.DealColumn = tracking.getActualColumnName(dealHeader, projectId);
            map.LoanColumn = tracking.getActualColumnName(loanHeader, projectId);

            if (Clean(projectNo) == "5004" || Clean(projectNo) == "583" || Clean(projectNo) == "632")
            {
                map.CreditQcColumn = tracking.getActualColumnName("Review", projectId);
                map.ComplianceQcColumn = tracking.getActualColumnName("QC", projectId);
            }
            else if (Clean(projectNo) == "561")
            {
                map.CreditQcColumn = tracking.getActualColumnName("SSQC", projectId);
                map.ComplianceQcColumn = tracking.getActualColumnName("CNC QC", projectId);
            }
            else
            {
                map.CreditQcColumn = tracking.getActualColumnName("Credit QC", projectId);
                map.ComplianceQcColumn = tracking.getActualColumnName("Compliance QC", projectId);
            }

            return map;
        }

        private static DispatchLoanResponse BuildDynamicResponse(DataTable dt)
        {
            DispatchLoanResponse response = new DispatchLoanResponse();
            if (dt == null)
                return response;

            DataRow headerRow = dt.Rows.Count > 0 ? dt.Rows[0] : null;
            foreach (DataColumn column in dt.Columns)
            {
                string title = headerRow == null ? column.ColumnName : Clean(headerRow[column]);
                if (string.IsNullOrWhiteSpace(title))
                    title = column.ColumnName;
                response.Columns.Add(new TrackingColumnInfo { Data = column.ColumnName, Title = title });
            }

            for (int i = headerRow == null ? 0 : 1; i < dt.Rows.Count; i++)
                response.Rows.Add(RowToDictionary(dt.Rows[i]));

            return response;
        }

        private static string ValidateSaveRequest(DispatchSaveRequest request)
        {
            if (request == null)
                return "Invalid save request.";
            if (request.ProjectId <= 0 || string.IsNullOrWhiteSpace(request.ProjectNo))
                return "Please select Project.";
            if (string.IsNullOrWhiteSpace(request.DealNo))
                return "Please select DealNo.";
            if (string.IsNullOrWhiteSpace(request.DispatchDate))
                return "Please select Dispatch date.";
            if (request.Meta == null)
                return "Loan column mapping is missing. Please reload loans.";
            if (request.Rows == null || request.Rows.Count == 0)
                return "Please select at least one loan.";
            return "";
        }

        private static string ValidateHeaders(DataTable dt)
        {
            if (dt == null || dt.Columns.Count < ImportHeaders.Length)
                return "Please check excel column header(s)...!!!";

            for (int i = 0; i < ImportHeaders.Length; i++)
            {
                if (!string.Equals(dt.Columns[i].ColumnName.Trim(), ImportHeaders[i], StringComparison.OrdinalIgnoreCase))
                    return "Please check excel column header(s)...!!!";
            }

            return "";
        }

        private static string ValidateDispatchImportRow(DataRow row)
        {
            if (string.IsNullOrWhiteSpace(Clean(row["DealNo"])))
                return "Deal No should not be blank...!!!";
            if (string.IsNullOrWhiteSpace(Clean(row["LoanNo"])))
                return "LoanNo should not be blank...!!!";
            if (string.IsNullOrWhiteSpace(Clean(row["ProjectNo"])))
                return "ProjectNo should not be blank...!!!";
            if (string.IsNullOrWhiteSpace(Clean(row["DispatchDate"])))
                return "DispatchDate should not be blank...!!!";
            return "";
        }

        private static void MarkFailed(TrackingImportResponse result, DataRow row, string error)
        {
            row["ErrorMSG"] = error;
            result.NotAddedRows.Add(RowToDictionary(row));
        }

        private static string SaveImportFile(string fileName, string contentBase64)
        {
            string extension = Path.GetExtension(fileName).ToLowerInvariant();
            string folder = HttpContext.Current.Server.MapPath("~/TempFiles/TrackingImports");
            if (!Directory.Exists(folder))
                Directory.CreateDirectory(folder);

            string cleanName = Path.GetFileNameWithoutExtension(fileName);
            foreach (char c in Path.GetInvalidFileNameChars())
                cleanName = cleanName.Replace(c.ToString(), "");

            string savedPath = Path.Combine(folder, cleanName + "_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + extension);
            string payload = contentBase64;
            int commaIndex = payload.IndexOf(',');
            if (commaIndex >= 0)
                payload = payload.Substring(commaIndex + 1);

            File.WriteAllBytes(savedPath, Convert.FromBase64String(payload));
            return savedPath;
        }

        private static DataTable ReadExcelTable(string filePath)
        {
            string extension = Path.GetExtension(filePath).ToLowerInvariant();
            string connection = extension == ".xls"
                ? "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties='Excel 8.0;HDR=Yes;IMEX=1';"
                : "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties='Excel 12.0;HDR=Yes;IMEX=1';";

            using (OleDbConnection con = new OleDbConnection(connection))
            {
                con.Open();
                DataTable schema = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                string sheet = "Sheet$";
                if (schema != null && schema.Rows.Count > 0)
                {
                    foreach (DataRow row in schema.Rows)
                    {
                        string name = Convert.ToString(row["TABLE_NAME"]);
                        if (name.IndexOf("FilterDatabase", StringComparison.OrdinalIgnoreCase) < 0)
                        {
                            sheet = name;
                            break;
                        }
                    }
                }

                using (OleDbDataAdapter adapter = new OleDbDataAdapter("SELECT * FROM [" + sheet + "]", con))
                {
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    return dt;
                }
            }
        }

        private static DataTable ReadCsvTable(string filePath)
        {
            DataTable dt = new DataTable();
            string[] lines = File.ReadAllLines(filePath);
            if (lines.Length == 0)
                return dt;

            List<string> headers = SplitCsvLine(lines[0]);
            foreach (string header in headers)
                dt.Columns.Add(header.Trim());

            for (int i = 1; i < lines.Length; i++)
            {
                List<string> values = SplitCsvLine(lines[i]);
                DataRow row = dt.NewRow();
                for (int c = 0; c < dt.Columns.Count; c++)
                    row[c] = c < values.Count ? values[c] : "";
                dt.Rows.Add(row);
            }

            return dt;
        }

        private static List<string> SplitCsvLine(string line)
        {
            List<string> values = new List<string>();
            bool inQuotes = false;
            System.Text.StringBuilder current = new System.Text.StringBuilder();

            for (int i = 0; i < line.Length; i++)
            {
                char ch = line[i];
                if (ch == '"')
                {
                    if (inQuotes && i + 1 < line.Length && line[i + 1] == '"')
                    {
                        current.Append('"');
                        i++;
                    }
                    else
                    {
                        inQuotes = !inQuotes;
                    }
                }
                else if (ch == ',' && !inQuotes)
                {
                    values.Add(current.ToString());
                    current.Length = 0;
                }
                else
                {
                    current.Append(ch);
                }
            }

            values.Add(current.ToString());
            return values;
        }

        private static bool TryNormalizeDate(object value, out string normalized)
        {
            normalized = "";
            if (value == null || value == DBNull.Value)
                return false;

            if (value is DateTime)
            {
                normalized = ((DateTime)value).ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
                return true;
            }

            DateTime parsed;
            string text = Clean(value);
            if (DateTime.TryParse(text, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed) ||
                DateTime.TryParse(text, CultureInfo.CurrentCulture, DateTimeStyles.None, out parsed))
            {
                normalized = parsed.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
                return true;
            }

            return false;
        }

        private static bool IsBlankRow(DataRow row)
        {
            foreach (DataColumn column in row.Table.Columns)
            {
                if (column.ColumnName == "ErrorMSG")
                    continue;
                if (!string.IsNullOrWhiteSpace(Clean(row[column])))
                    return false;
            }
            return true;
        }

        private static string GetDictionaryValue(Dictionary<string, object> row, string key)
        {
            if (row == null || string.IsNullOrWhiteSpace(key) || !row.ContainsKey(key) || row[key] == null)
                return "";
            return Convert.ToString(row[key]).Trim();
        }

        private static int CurrentEmployeeId()
        {
            try { return EmployeeInfo.Current.EmployeeID; }
            catch { return Convert.ToInt32(HttpContext.Current.User.Identity.Name); }
        }

        private static List<Dictionary<string, object>> ToRows(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (dt == null)
                return rows;

            foreach (DataRow row in dt.Rows)
                rows.Add(RowToDictionary(row));

            return rows;
        }

        private static Dictionary<string, object> RowToDictionary(DataRow row)
        {
            Dictionary<string, object> item = new Dictionary<string, object>();
            foreach (DataColumn column in row.Table.Columns)
                item[column.ColumnName] = row[column] == DBNull.Value ? "" : row[column];
            return item;
        }

        private static string Clean(object value)
        {
            return value == null || value == DBNull.Value ? "" : Convert.ToString(value).Trim();
        }
    }

    public class DispatchLoanRequest
    {
        public int ProjectId { get; set; }
        public string ProjectNo { get; set; }
        public string DealNo { get; set; }
    }

    public class DispatchSaveRequest
    {
        public int ProjectId { get; set; }
        public string ProjectNo { get; set; }
        public string DealNo { get; set; }
        public string DispatchDate { get; set; }
        public DispatchColumnMap Meta { get; set; }
        public List<Dictionary<string, object>> Rows { get; set; }
    }

    public class TrackingUploadRequest
    {
        public string FileName { get; set; }
        public string ContentBase64 { get; set; }
    }

    public class DispatchColumnMap
    {
        public string OrderDateColumn { get; set; }
        public string DealColumn { get; set; }
        public string LoanColumn { get; set; }
        public string CreditQcColumn { get; set; }
        public string ComplianceQcColumn { get; set; }
    }

    public class TrackingColumnInfo
    {
        public string Data { get; set; }
        public string Title { get; set; }
    }

    public class DispatchLoanResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public List<TrackingColumnInfo> Columns { get; set; }
        public List<Dictionary<string, object>> Rows { get; set; }
        public DispatchColumnMap Meta { get; set; }

        public DispatchLoanResponse()
        {
            Columns = new List<TrackingColumnInfo>();
            Rows = new List<Dictionary<string, object>>();
        }

        public static DispatchLoanResponse Fail(string message)
        {
            return new DispatchLoanResponse { Success = false, Message = message };
        }
    }

    public class DispatchSaveResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int SuccessRows { get; set; }
        public int FailedRows { get; set; }

        public static DispatchSaveResponse Fail(string message)
        {
            return new DispatchSaveResponse { Success = false, Message = message };
        }
    }
}