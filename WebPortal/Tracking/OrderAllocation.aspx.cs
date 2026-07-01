using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Tracking
{
    public partial class OrderAllocation : Page
    {
        private static readonly string[] ImportHeaders = { "ProjectNo", "DealNo", "Date", "LoanNo", "Pseudo Name", "Process" };

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
        public static TrackingListResponse GetProcesses(int projectId)
        {
            try
            {
                DataTable dt = new bllTracking().getProcess(projectId);
                return TrackingListResponse.Ok(ToRows(dt));
            }
            catch (Exception ex)
            {
                return TrackingListResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static TrackingImportResponse ImportOrders(OrderAllocationImportRequest request)
        {
            TrackingImportResponse result = new TrackingImportResponse();

            try
            {
                string validation = ValidateRequest(request);
                if (!string.IsNullOrWhiteSpace(validation))
                    return TrackingImportResponse.Fail(validation);

                string filePath = SaveImportFile(request.FileName, request.ContentBase64);
                string extension = Path.GetExtension(filePath).ToLowerInvariant();
                DataTable dtExcel = extension == ".csv" ? ReadCsvTable(filePath) : ReadExcelTable(filePath);

                string headerError = ValidateHeaders(dtExcel);
                if (!string.IsNullOrWhiteSpace(headerError))
                    return TrackingImportResponse.Fail(headerError);

                if (!dtExcel.Columns.Contains("ErrorMSG"))
                    dtExcel.Columns.Add("ErrorMSG");

                foreach (DataRow row in dtExcel.Rows)
                {
                    if (IsBlankRow(row))
                        continue;

                    string processInFile = Clean(row["Process"]);
                    if (!string.Equals(processInFile, Clean(request.ProcessName), StringComparison.OrdinalIgnoreCase))
                        return TrackingImportResponse.Fail("Process Not Match...!!!");
                }

                result.Success = true;
                result.Message = "Import completed.";
                result.TotalRows = dtExcel.Rows.Count;

                foreach (DataRow row in dtExcel.Rows)
                {
                    if (IsBlankRow(row))
                    {
                        MarkFailed(result, row, "Blank row is added.");
                        continue;
                    }

                    string error = ValidateImportRow(row);
                    string orderDate = "";
                    if (string.IsNullOrWhiteSpace(error) && !TryNormalizeDate(row["Date"], out orderDate))
                        error = "Date is not valid.";

                    if (string.IsNullOrWhiteSpace(error))
                    {
                        int pseudoValue = new bllTracking().GetEmployeePseudonameNew(Clean(row["Pseudo Name"]));
                        if (pseudoValue <= 0)
                            error = "PseudoNym not configured in ERP, or does not match with ERP database.";
                    }

                    if (!string.IsNullOrWhiteSpace(error))
                    {
                        MarkFailed(result, row, error);
                        continue;
                    }

                    Hashtable htParam = BuildAllocationParams(row, request, orderDate);
                    int returnValue = ShouldUseServicing(Clean(row["ProjectNo"]), request.Mode)
                        ? new bllTracking().InsertModifyUWOrderOC22Servicing(htParam)
                        : new bllTracking().InsertModifyUWOrderOC22(htParam);

                    if (returnValue > 0)
                    {
                        result.SuccessRows++;
                    }
                    else
                    {
                        MarkFailed(result, row, "Already allocated,Please check and confirm.");
                    }
                }

                result.FailedRows = result.NotAddedRows.Count;
                if (result.FailedRows == 0)
                    result.Message = "All rows imported successfully.";
                else if (result.SuccessRows == 0)
                    result.Message = "No rows were imported. Please review the issue list.";
                else
                    result.Message = "Some rows were imported. Please review the issue list.";

                return result;
            }
            catch (Exception ex)
            {
                return TrackingImportResponse.Fail(ex.Message);
            }
        }

        private static string ValidateRequest(OrderAllocationImportRequest request)
        {
            if (request == null)
                return "Invalid import request.";
            if (request.ProjectId <= 0)
                return "Please select Project.";
            if (string.IsNullOrWhiteSpace(request.ProcessName))
                return "Please select Process.";
            if (string.IsNullOrWhiteSpace(request.Mode))
                return "Please select import mode.";
            if (string.IsNullOrWhiteSpace(request.FileName) || string.IsNullOrWhiteSpace(request.ContentBase64))
                return "Please select import file.";

            string extension = Path.GetExtension(request.FileName).ToLowerInvariant();
            if (extension != ".xls" && extension != ".xlsx" && extension != ".csv")
                return "Only .xls, .xlsx and .csv files are supported.";

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

        private static string ValidateImportRow(DataRow row)
        {
            if (string.IsNullOrWhiteSpace(Clean(row["LoanNo"])))
                return "Loan # is compulsory.";
            if (string.IsNullOrWhiteSpace(Clean(row["Pseudo Name"])))
                return "Pseudo Name is compulsory.";
            if (string.IsNullOrWhiteSpace(Clean(row["ProjectNo"])))
                return "ProjectNo is compulsory.";
            if (string.IsNullOrWhiteSpace(Clean(row["DealNo"])))
                return "DealNo is compulsory.";
            if (string.IsNullOrWhiteSpace(Clean(row["Date"])))
                return "ReviewEndTime is compulsory.";
            return "";
        }

        private static Hashtable BuildAllocationParams(DataRow row, OrderAllocationImportRequest request, string orderDate)
        {
            string mode = Clean(request.Mode).ToLowerInvariant();
            string status = "Pending";
            string type = "Allocation";
            string productType = "";

            if (mode == "complete")
            {
                status = "Completed";
                type = "Complete";
                productType = "Default";
            }
            else if (mode == "reallocation")
            {
                type = "Allocation2";
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectNumber", Clean(row["ProjectNo"]));
            htParam.Add("DealNo", Clean(row["DealNo"]));
            htParam.Add("OrderNumber", Clean(row["LoanNo"]));
            htParam.Add("Review", Clean(row["Pseudo Name"]));
            htParam.Add("ReviewEndTime", orderDate);
            htParam.Add("Process", Clean(request.ProcessName));
            htParam.Add("ProductType", productType);
            htParam.Add("Status", status);
            htParam.Add("Type", type);
            htParam.Add("Remark", "");
            htParam.Add("AddedBY", Convert.ToString(CurrentEmployeeId()));
            return htParam;
        }

        private static bool ShouldUseServicing(string projectNumber, string mode)
        {
            string normalizedMode = Clean(mode).ToLowerInvariant();
            if (normalizedMode == "complete")
                return projectNumber == "561" || projectNumber == "667" || projectNumber == "2088";

            return projectNumber == "561" || projectNumber == "667" || projectNumber == "2088" || projectNumber == "2111";
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

    public class OrderAllocationImportRequest
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string ProcessName { get; set; }
        public string Mode { get; set; }
        public string FileName { get; set; }
        public string ContentBase64 { get; set; }
    }

    public class TrackingImportResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int TotalRows { get; set; }
        public int SuccessRows { get; set; }
        public int FailedRows { get; set; }
        public List<Dictionary<string, object>> NotAddedRows { get; set; }

        public TrackingImportResponse()
        {
            NotAddedRows = new List<Dictionary<string, object>>();
        }

        public static TrackingImportResponse Fail(string message)
        {
            return new TrackingImportResponse { Success = false, Message = message };
        }
    }

    public class TrackingListResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public List<Dictionary<string, object>> Rows { get; set; }

        public TrackingListResponse()
        {
            Rows = new List<Dictionary<string, object>>();
        }

        public static TrackingListResponse Ok(List<Dictionary<string, object>> rows)
        {
            return new TrackingListResponse { Success = true, Rows = rows };
        }

        public static TrackingListResponse Fail(string message)
        {
            return new TrackingListResponse { Success = false, Message = message };
        }
    }
}