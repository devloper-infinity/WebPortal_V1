using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.Tracking;

namespace WebPortal.US
{
    public partial class BulkOrderAllocation : Page
    {
        private const int AllocationProjectId = 70;
        private const string AllocationProjectName = "561";
        private const int AllocationProcessId = 2506;
        private const string AllocationProcessName = "PH RecQC";

        private static readonly string[] ImportHeaders =
        {
            "Project", "Deal #", "Loan #", "Employee"
        };

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static TrackingImportResponse ImportOrders(BulkOrderAllocationImportRequest request)
        {
            TrackingImportResponse result = new TrackingImportResponse();
            string filePath = null;

            try
            {
                if (request != null)
                {
                    request.ProjectId = AllocationProjectId;
                    request.ProjectName = AllocationProjectName;
                    request.ProcessId = AllocationProcessId;
                    request.ProcessName = AllocationProcessName;
                }

                string validation = ValidateRequest(request);
                if (!string.IsNullOrWhiteSpace(validation))
                    return TrackingImportResponse.Fail(validation);

                filePath = SaveImportFile(request.FileName, request.ContentBase64);
                string extension = Path.GetExtension(filePath).ToLowerInvariant();
                DataTable dtExcel = extension == ".csv"
                    ? ReadCsvTable(filePath)
                    : ReadExcelTable(filePath);

                string headerError = ValidateHeaders(dtExcel);
                if (!string.IsNullOrWhiteSpace(headerError))
                    return TrackingImportResponse.Fail(headerError);

                if (!dtExcel.Columns.Contains("ErrorMSG"))
                    dtExcel.Columns.Add("ErrorMSG");

                result.Success = true;
                result.Message = "Import completed.";
                result.TotalRows = 0;
                bllTracking tracking = new bllTracking();

                foreach (DataRow row in dtExcel.Rows)
                {
                    if (IsBlankRow(row))
                        continue;

                    result.TotalRows++;

                    string error = ValidateImportRow(row);
                    if (string.IsNullOrWhiteSpace(error) &&
                        !string.Equals(Clean(row["Project"]), request.ProjectName, StringComparison.OrdinalIgnoreCase))
                    {
                        error = "Project must be " + request.ProjectName + ".";
                    }

                    string orderDate = DateTime.Today.ToString("MM/dd/yyyy");

                    if (!string.IsNullOrWhiteSpace(error))
                    {
                        MarkFailed(result, row, error);
                        continue;
                    }

                    string existingStatus = tracking.GetBulkAllocationDuplicateStatus(
                        request.ProjectId,
                        Clean(row["Deal #"]),
                        Clean(row["Loan #"]),
                        Clean(row["Employee"]),
                        request.ProcessName);
                    if (!string.IsNullOrWhiteSpace(existingStatus))
                    {
                        MarkFailed(
                            result,
                            row,
                            "Duplicate allocation: this Deal #, Loan #, Employee and Process already exist.");
                        continue;
                    }

                    Hashtable parameters = BuildAllocationParams(row, request, orderDate);
                    string projectNumber = Clean(row["Project"]);
                    int returnValue = ShouldUseServicing(projectNumber)
                        ? tracking.InsertModifyUWOrderOC22Servicing(parameters)
                        : tracking.AllocateOrder_Self(parameters);

                    if (returnValue > 0)
                        result.SuccessRows++;
                    else
                        MarkFailed(result, row, "Already allocated, Please check and confirm.");
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
            finally
            {
                if (!string.IsNullOrWhiteSpace(filePath) && File.Exists(filePath))
                {
                    try { File.Delete(filePath); }
                    catch { /* Temporary-file cleanup must not hide the import result. */ }
                }
            }
        }

        [WebMethod(EnableSession = true)]
        public static TrackingListResponse GetAllocatedOrders()
        {
            try
            {
                bllTracking tracking = new bllTracking();
                DataTable table = tracking.GetBulkAllocatedOrders(
                    AllocationProjectId,
                    AllocationProcessName);

                List<Dictionary<string, object>> rows = ToAllocatedOrderRows(table);
                return TrackingListResponse.Ok(rows);
            }
            catch (Exception ex)
            {
                return TrackingListResponse.Fail(ex.Message);
            }
        }

        private static List<Dictionary<string, object>> ToAllocatedOrderRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null)
                return rows;

            int serialNumber = 1;
            foreach (DataRow row in table.Rows)
            {
                string project = FirstValue(row, "ProjectName", "ProjectNumber", "ProjectNo", "Project");
                if (string.IsNullOrWhiteSpace(project))
                    project = AllocationProjectName;
                if (!string.Equals(project, AllocationProjectName, StringComparison.OrdinalIgnoreCase))
                    continue;

                string process = FirstValue(row, "Process", "ProcessName");
                if (string.IsNullOrWhiteSpace(process))
                    process = AllocationProcessName;

                string status = FirstValue(row, "CurrentStatus", "Current Status", "Status", "OrderStatus", "Order Status", "TaskStatus");
                if (string.IsNullOrWhiteSpace(status))
                    status = "Pending";

                Dictionary<string, object> item = new Dictionary<string, object>();
                item["SrNo"] = serialNumber++;
                item["Project"] = project;
                item["DealNo"] = FirstValue(row, "DealNo", "DealNumber", "Deal #");
                item["LoanNo"] = FirstValue(row, "LoanNo", "OrderNo", "OrderNumber", "Loan #");
                item["Employee"] = FirstValue(row, "Review", "Reviewer", "ReviewName", "Employee", "EmployeeName", "PseudoName", "Pseudo Name");
                item["Process"] = process;
                item["Status"] = status;
                rows.Add(item);
            }

            return rows;
        }

        private static string ValidateRequest(BulkOrderAllocationImportRequest request)
        {
            if (request == null)
                return "Invalid import request.";
            if (request.ProjectId <= 0)
                return "Please select Project.";
            if (string.IsNullOrWhiteSpace(request.ProjectName))
                return "Project name is required.";
            if (request.ProcessId <= 0)
                return "Please select Process.";
            if (string.IsNullOrWhiteSpace(request.ProcessName))
                return "Please select Process.";
            if (string.IsNullOrWhiteSpace(request.FileName) || string.IsNullOrWhiteSpace(request.ContentBase64))
                return "Please select import file.";

            string extension = Path.GetExtension(request.FileName).ToLowerInvariant();
            if (extension != ".xls" && extension != ".xlsx" && extension != ".csv")
                return "Only .xls, .xlsx and .csv files are supported.";

            return "";
        }

        private static string ValidateHeaders(DataTable table)
        {
            if (table == null || table.Columns.Count != ImportHeaders.Length)
                return "The import file must contain exactly 4 columns: Project, Deal #, Loan #, Employee.";

            for (int i = 0; i < ImportHeaders.Length; i++)
            {
                if (!string.Equals(table.Columns[i].ColumnName.Trim(), ImportHeaders[i], StringComparison.OrdinalIgnoreCase))
                    return "The import file columns must be: Project, Deal #, Loan #, Employee.";
            }

            return "";
        }

        private static string ValidateImportRow(DataRow row)
        {
            if (string.IsNullOrWhiteSpace(Clean(row["Loan #"])))
                return "Loan # is compulsory.";
            if (string.IsNullOrWhiteSpace(Clean(row["Employee"])))
                return "Employee is compulsory.";
            if (string.IsNullOrWhiteSpace(Clean(row["Project"])))
                return "Project is compulsory.";
            if (string.IsNullOrWhiteSpace(Clean(row["Deal #"])))
                return "Deal # is compulsory.";
            return "";
        }

        private static Hashtable BuildAllocationParams(
            DataRow row,
            BulkOrderAllocationImportRequest request,
            string orderDate)
        {
            Hashtable parameters = new Hashtable();
            parameters.Add("ProjectNumber", Clean(row["Project"]));
            parameters.Add("DealNo", Clean(row["Deal #"]));
            parameters.Add("OrderNumber", Clean(row["Loan #"]));
            parameters.Add("Review", Clean(row["Employee"]));
            parameters.Add("ReviewEndTime", orderDate);
            parameters.Add("Process", Clean(request.ProcessName));
            parameters.Add("ProductType", "");
            parameters.Add("Status", "Pending");
            parameters.Add("Type", "Allocation");
            parameters.Add("Remark", "");
            parameters.Add("AddedBY", Convert.ToString(CurrentEmployeeId()));
            return parameters;
        }

        private static bool ShouldUseServicing(string projectNumber)
        {
            return projectNumber == "561" || projectNumber == "667" ||
                   projectNumber == "2088" || projectNumber == "2111";
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
            foreach (char character in Path.GetInvalidFileNameChars())
                cleanName = cleanName.Replace(character.ToString(), "");

            string savedPath = Path.Combine(
                folder,
                cleanName + "_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + extension);

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

            using (OleDbConnection connectionObject = new OleDbConnection(connection))
            {
                connectionObject.Open();
                DataTable schema = connectionObject.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
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

                using (OleDbDataAdapter adapter = new OleDbDataAdapter(
                    "SELECT * FROM [" + sheet.Replace("]", "]]" ) + "]",
                    connectionObject))
                {
                    DataTable table = new DataTable();
                    adapter.Fill(table);
                    return table;
                }
            }
        }

        private static DataTable ReadCsvTable(string filePath)
        {
            DataTable table = new DataTable();
            string[] lines = File.ReadAllLines(filePath);
            if (lines.Length == 0)
                return table;

            List<string> headers = SplitCsvLine(lines[0]);
            foreach (string header in headers)
                table.Columns.Add(header.Trim());

            for (int i = 1; i < lines.Length; i++)
            {
                List<string> values = SplitCsvLine(lines[i]);
                DataRow row = table.NewRow();
                for (int column = 0; column < table.Columns.Count; column++)
                    row[column] = column < values.Count ? values[column] : "";
                table.Rows.Add(row);
            }

            return table;
        }

        private static List<string> SplitCsvLine(string line)
        {
            List<string> values = new List<string>();
            bool inQuotes = false;
            System.Text.StringBuilder current = new System.Text.StringBuilder();

            for (int i = 0; i < line.Length; i++)
            {
                char character = line[i];
                if (character == '"')
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
                else if (character == ',' && !inQuotes)
                {
                    values.Add(current.ToString());
                    current.Length = 0;
                }
                else
                {
                    current.Append(character);
                }
            }

            values.Add(current.ToString());
            return values;
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
            try
            {
                return EmployeeInfo.Current.EmployeeID;
            }
            catch
            {
                return Convert.ToInt32(HttpContext.Current.User.Identity.Name);
            }
        }

        private static Dictionary<string, object> RowToDictionary(DataRow row)
        {
            Dictionary<string, object> item = new Dictionary<string, object>();
            foreach (DataColumn column in row.Table.Columns)
                item[column.ColumnName] = row[column] == DBNull.Value ? "" : row[column];
            return item;
        }

        private static string FirstValue(DataRow row, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
            {
                if (!row.Table.Columns.Contains(columnName))
                    continue;

                string value = Clean(row[columnName]);
                if (!string.IsNullOrWhiteSpace(value))
                    return value;
            }

            return "";
        }

        private static string Clean(object value)
        {
            return value == null || value == DBNull.Value
                ? ""
                : Convert.ToString(value).Trim();
        }
    }

    public class BulkOrderAllocationImportRequest
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public int ProcessId { get; set; }
        public string ProcessName { get; set; }
        public string FileName { get; set; }
        public string ContentBase64 { get; set; }
    }
}
