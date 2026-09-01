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
        private static readonly string[] ImportHeaders =
        {
            "Project", "Deal #", "Loan #", "Employee", "Process"
        };

        private static readonly string[] AllowedProcessNames =
        {
            "PH ReQC", "ATR Review"
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
                bllMaster master = new bllMaster();
                Dictionary<string, int> projectIds = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
                Dictionary<string, DataTable> projectProcesses = new Dictionary<string, DataTable>(StringComparer.OrdinalIgnoreCase);
                HashSet<string> allocationKeys = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                List<ValidatedAllocationRow> validRows = new List<ValidatedAllocationRow>();

                foreach (DataRow row in dtExcel.Rows)
                {
                    if (IsBlankRow(row))
                        continue;

                    result.TotalRows++;

                    string error = ValidateImportRow(row);
                    string projectNumber = Clean(row["Project"]);
                    string processName = CanonicalProcessName(Clean(row["Process"]));
                    int projectId = 0;
                    int processId = 0;

                    if (string.IsNullOrWhiteSpace(error) && string.IsNullOrWhiteSpace(processName))
                        error = "Process must be PH ReQC or ATR Review.";

                    if (string.IsNullOrWhiteSpace(error))
                    {
                        projectId = ResolveProjectId(master, projectIds, projectNumber);
                        if (projectId <= 0)
                            error = "Project # does not exist in ERP.";
                    }

                    if (string.IsNullOrWhiteSpace(error))
                    {
                        processId = ResolveProcessId(tracking, projectProcesses, projectId, processName);
                        if (processId <= 0)
                            error = "Process '" + processName + "' is not configured for project " + projectNumber + ".";
                    }

                    if (string.IsNullOrWhiteSpace(error) &&
                        !tracking.BulkAllocationOrderExists(
                            projectId,
                            Clean(row["Deal #"]),
                            Clean(row["Loan #"])))
                    {
                        error = "Deal # and Loan # combination does not match Tracking Sheet for the specified project.";
                    }

                    string allocationKey = projectId + "|" + Clean(row["Deal #"]) + "|" +
                        Clean(row["Loan #"]) + "|" + Clean(row["Employee"]) + "|" + processName;
                    if (string.IsNullOrWhiteSpace(error) && !allocationKeys.Add(allocationKey))
                        error = "Duplicate row in the uploaded file.";

                    if (!string.IsNullOrWhiteSpace(error))
                    {
                        MarkFailed(result, row, error);
                        continue;
                    }

                    string existingStatus = tracking.GetBulkAllocationDuplicateStatus(
                        projectId,
                        Clean(row["Deal #"]),
                        Clean(row["Loan #"]),
                        Clean(row["Employee"]),
                        processName);
                    if (!string.IsNullOrWhiteSpace(existingStatus))
                    {
                        MarkFailed(
                            result,
                            row,
                            "Duplicate allocation: this Deal #, Loan #, Employee and Process already exist.");
                        continue;
                    }

                    validRows.Add(new ValidatedAllocationRow(row, projectId, processId, processName));
                }

                result.FailedRows = result.NotAddedRows.Count;
                if (result.FailedRows > 0)
                {
                    result.Message = "No rows were imported. Correct all validation errors and upload the file again.";
                    return result;
                }

                string orderDate = DateTime.Today.ToString("MM/dd/yyyy");
                foreach (ValidatedAllocationRow validRow in validRows)
                {
                    DataRow row = validRow.Row;

                    Hashtable parameters = BuildAllocationParams(
                        row,
                        validRow.ProjectId,
                        validRow.ProcessId,
                        validRow.ProcessName,
                        orderDate);
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
                DataTable table = tracking.GetBulkAllocatedOrders();

                List<Dictionary<string, object>> rows = ToAllocatedOrderRows(table);
                return TrackingListResponse.Ok(rows);
            }
            catch (Exception ex)
            {
                return TrackingListResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static List<string> GetBulkAllocationEmployees()
        {
            DataTable table = new bllTracking().GetBulkAllocationEmployees();
            List<string> employees = new List<string>();
            foreach (DataRow row in table.Rows)
                employees.Add(Clean(row["Employee"]));
            return employees;
        }

        [WebMethod(EnableSession = true)]
        public static TrackingListResponse GetBulkAllocationLoanStatus(string employee, string fromDate, string toDate)
        {
            DateTime from;
            DateTime to;
            if (!DateTime.TryParseExact(fromDate, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out from)
                || !DateTime.TryParseExact(toDate, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out to)
                || from > to)
                return TrackingListResponse.Fail("Please select a valid date range.");

            DataTable table = new bllTracking().GetBulkAllocationLoanStatus((employee ?? "").Trim(), from, to);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (DataRow row in table.Rows)
                rows.Add(RowToDictionary(row));
            return TrackingListResponse.Ok(rows);
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

                string process = FirstValue(row, "Process", "ProcessName");

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
                return "The import file must contain exactly 5 columns: Project, Deal #, Loan #, Employee, Process.";

            for (int i = 0; i < ImportHeaders.Length; i++)
            {
                if (!string.Equals(table.Columns[i].ColumnName.Trim(), ImportHeaders[i], StringComparison.OrdinalIgnoreCase))
                    return "The import file columns must be: Project, Deal #, Loan #, Employee, Process.";
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
            if (string.IsNullOrWhiteSpace(Clean(row["Process"])))
                return "Process is compulsory.";
            return "";
        }

        private static Hashtable BuildAllocationParams(
            DataRow row,
            int projectId,
            int processId,
            string processName,
            string orderDate)
        {
            Hashtable parameters = new Hashtable();
            parameters.Add("ProjectNumber", Clean(row["Project"]));
            parameters.Add("DealNo", Clean(row["Deal #"]));
            parameters.Add("OrderNumber", Clean(row["Loan #"]));
            parameters.Add("Review", Clean(row["Employee"]));
            parameters.Add("ReviewEndTime", orderDate);
            parameters.Add("Process", processName);
            parameters.Add("ProductType", "");
            parameters.Add("Status", "Pending");
            parameters.Add("Type", "Allocation");
            parameters.Add("Remark", "");
            parameters.Add("AddedBY", Convert.ToString(CurrentEmployeeId()));
            parameters.Add("ProjectID", projectId);
            parameters.Add("ProcessID", processId);
            parameters.Add("PrevID", 0);
            parameters.Add("TrackingSheetID", 0);
            parameters.Add("LoanNo", Clean(row["Loan #"]));
            parameters.Add("AllocationStatus", "Pending");
            parameters.Add("PseudoName", Clean(row["Employee"]));
            parameters.Add("UserID", CurrentEmployeeId());
            return parameters;
        }

        private static string CanonicalProcessName(string processName)
        {
            foreach (string allowedProcessName in AllowedProcessNames)
            {
                if (string.Equals(processName, allowedProcessName, StringComparison.OrdinalIgnoreCase))
                    return allowedProcessName;
            }
            return "";
        }

        private static int ResolveProjectId(
            bllMaster master,
            Dictionary<string, int> projectIds,
            string projectNumber)
        {
            int projectId;
            if (projectIds.TryGetValue(projectNumber, out projectId))
                return projectId;

            try { projectId = master.GetprojectId(projectNumber); }
            catch { projectId = 0; }
            projectIds[projectNumber] = projectId;
            return projectId;
        }

        private static int ResolveProcessId(
            bllTracking tracking,
            Dictionary<string, DataTable> projectProcesses,
            int projectId,
            string processName)
        {
            string projectKey = Convert.ToString(projectId);
            DataTable processes;
            if (!projectProcesses.TryGetValue(projectKey, out processes))
            {
                processes = new bllMaster().getProcess(projectId);
                projectProcesses[projectKey] = processes;
            }

            if (processes == null)
                return 0;

            foreach (DataRow process in processes.Rows)
            {
                if (!string.Equals(
                    FirstValue(process, "ProcessName", "Process"),
                    processName,
                    StringComparison.OrdinalIgnoreCase))
                    continue;

                int processId;
                return int.TryParse(FirstValue(process, "ProcessID", "ProcessId"), out processId)
                    ? processId
                    : 0;
            }
            return 0;
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

        private sealed class ValidatedAllocationRow
        {
            public DataRow Row { get; private set; }
            public int ProjectId { get; private set; }
            public int ProcessId { get; private set; }
            public string ProcessName { get; private set; }

            public ValidatedAllocationRow(DataRow row, int projectId, int processId, string processName)
            {
                Row = row;
                ProjectId = projectId;
                ProcessId = processId;
                ProcessName = processName;
            }
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
