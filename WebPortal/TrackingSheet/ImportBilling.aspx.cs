using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.TrackingSheet
{
    public partial class ImportBilling : System.Web.UI.Page
    {
        private const string SessionPrefix = "ImportBilling_";

        [WebMethod]
        public static List<ImportBillingProject> GetProjects()
        {
            List<ImportBillingProject> result = new List<ImportBillingProject>();
            foreach (DataRow row in new bllMaster().GetAllProjectByUserRights(Convert.ToString(UserId())).Rows)
            {
                int id; string idText = FirstValue(row, "ProjectID", "ProjectId", "projectID", "ID");
                if (int.TryParse(idText, out id)) result.Add(new ImportBillingProject { ID = id, Name = FirstValue(row, "ProjectName", "ProjectNo", "Name", "Project") });
            }
            return result.OrderBy(x => x.Name).ToList();
        }

        [WebMethod]
        public static ImportBillingTemplate DownloadTemplate(int projectId)
        {
            try { return DownloadTemplateCore(projectId); }
            catch (Exception ex) { return new ImportBillingTemplate { Success = false, Message = UserMessage(ex) }; }
        }

        private static ImportBillingTemplate DownloadTemplateCore(int projectId)
        {
            string projectName = ProjectName(projectId); dalLegacyImportBilling.BillingTable config = dalLegacyImportBilling.BillingTable.For(projectName);
            if (config == null) throw new InvalidOperationException("A billing template is not configured for project " + projectName + ".");
            using (XLWorkbook workbook = new XLWorkbook())
            using (MemoryStream stream = new MemoryStream())
            {
                IXLWorksheet sheet = workbook.Worksheets.Add("Billing");
                for (int column = 0; column < config.Headers.Length; column++) sheet.Cell(1, column + 1).Value = config.Headers[column];
                IXLRange header = sheet.Range(1, 1, 1, config.Headers.Length); header.Style.Fill.BackgroundColor = XLColor.FromHtml("#117A9B"); header.Style.Font.FontColor = XLColor.White; header.Style.Font.Bold = true; header.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center; header.Style.Border.BottomBorder = XLBorderStyleValues.Thin; header.SetAutoFilter();
                sheet.Row(1).Height = 24; sheet.SheetView.FreezeRows(1); sheet.Columns(1, config.Headers.Length).AdjustToContents();
                foreach (IXLColumn column in sheet.Columns(1, config.Headers.Length)) { if (column.Width < 14) column.Width = 14; if (column.Width > 35) column.Width = 35; }
                sheet.Range(2, 1, 101, config.Headers.Length).Style.Border.BottomBorder = XLBorderStyleValues.Hair;
                workbook.Properties.Title = "Billing Template - " + projectName; workbook.Properties.Subject = "Monthly billing import template"; workbook.SaveAs(stream);
                return new ImportBillingTemplate { Success = true, FileName = "Billing_Template_" + SafeFileName(projectName) + ".xlsx", FileBase64 = Convert.ToBase64String(stream.ToArray()), Message = "The billing template for project " + projectName + " is ready." };
            }
        }

        [WebMethod(EnableSession = true)]
        public static ImportBillingGrid ImportExcel(int projectId, int billingMonth, int billingYear, string fileName, string fileBase64)
        {
            try { return ImportExcelCore(projectId, billingMonth, billingYear, fileName, fileBase64); }
            catch (Exception ex) { return FailedGrid(ex); }
        }

        private static ImportBillingGrid ImportExcelCore(int projectId, int billingMonth, int billingYear, string fileName, string fileBase64)
        {
            ValidatePeriod(projectId, billingMonth, billingYear); string projectName = ProjectName(projectId);
            string extension = Path.GetExtension(fileName ?? "").ToLowerInvariant();
            if (extension != ".xls" && extension != ".xlsx") throw new ArgumentException("Only .xls and .xlsx billing files are accepted.");
            byte[] bytes; try { bytes = Convert.FromBase64String(fileBase64 ?? ""); } catch { throw new ArgumentException("The selected Excel file is invalid."); }
            if (bytes.Length == 0 || bytes.Length > 10 * 1024 * 1024) throw new ArgumentException("Select a valid Excel file up to 10 MB.");
            dalLegacyImportBilling.BillingTable config = dalLegacyImportBilling.BillingTable.For(projectName);
            if (config == null) throw new InvalidOperationException("Billing import is not configured for project " + projectName + ".");
            DataTable rows = extension == ".xls" ? ReadLegacyExcel(bytes, config.Headers) : ReadExcel(bytes, config.Headers);
            if (rows.Rows.Count == 0) throw new InvalidOperationException("The Excel file does not contain any billing records.");
            RejectDuplicates(rows);
            string token = Guid.NewGuid().ToString("N");
            LegacyBillingImportState state = new LegacyBillingImportState { ProjectId = projectId, ProjectName = projectName, BillingMonth = billingMonth, BillingYear = billingYear, BillingPeriod = Period(billingMonth, billingYear), BillingCycle = "Monthly", Rows = rows, Verified = false };
            HttpContext.Current.Session[SessionPrefix + token] = state;
            ImportBillingGrid grid = Grid(rows); grid.Token = token; grid.Message = rows.Rows.Count + " billing record(s) imported successfully. Verify the preview before sending to Accounts."; return grid;
        }

        [WebMethod(EnableSession = true)]
        public static ImportBillingAction VerifyImport(string token)
        {
            try { return VerifyImportCore(token); }
            catch (Exception ex) { return new ImportBillingAction { Success = false, Message = UserMessage(ex) }; }
        }

        private static ImportBillingAction VerifyImportCore(string token)
        {
            LegacyBillingImportState state = State(token); state.Verified = true; HttpContext.Current.Session[SessionPrefix + token] = state;
            return new ImportBillingAction { Success = true, Count = state.Rows.Rows.Count, Message = state.Rows.Rows.Count + " billing record(s) verified successfully." };
        }

        [WebMethod(EnableSession = true)]
        public static ImportBillingAction SendToAccounts(string token)
        {
            try { return SendToAccountsCore(token); }
            catch (Exception ex) { return new ImportBillingAction { Success = false, Message = UserMessage(ex) }; }
        }

        private static ImportBillingAction SendToAccountsCore(string token)
        {
            LegacyBillingImportState state = State(token); if (!state.Verified) throw new InvalidOperationException("Verify the imported billing records before sending them to Accounts.");
            EnsureProjectAccess(state.ProjectId);
            int count = new bllLegacyImportBilling().Send(state.ProjectId, state.ProjectName, state.BillingPeriod, state.BillingCycle, UserId(), state.Rows);
            HttpContext.Current.Session.Remove(SessionPrefix + token);
            return new ImportBillingAction { Success = true, Count = count, Message = count + " billing record(s) sent to Accounts successfully." };
        }

        [WebMethod]
        public static ImportBillingGrid GetBillingHistory(int projectId, int billingMonth, int billingYear)
        {
            try { return GetBillingHistoryCore(projectId, billingMonth, billingYear); }
            catch (Exception ex) { return FailedGrid(ex); }
        }

        private static ImportBillingGrid GetBillingHistoryCore(int projectId, int billingMonth, int billingYear)
        {
            ValidatePeriod(projectId, billingMonth, billingYear); EnsureProjectAccess(projectId);
            DataTable rows = new bllLegacyImportBilling().GetHistory(projectId, Period(billingMonth, billingYear));
            ImportBillingGrid grid = Grid(rows); grid.Message = rows.Rows.Count + " billing history record(s) found."; return grid;
        }

        private static DataTable ReadExcel(byte[] bytes, string[] requiredHeaders)
        {
            try
            {
                using (MemoryStream stream = new MemoryStream(bytes))
                using (XLWorkbook workbook = new XLWorkbook(stream))
                {
                    IXLWorksheet sheet = workbook.Worksheets.FirstOrDefault(); if (sheet == null || sheet.LastRowUsed() == null) throw new ArgumentException("The workbook does not contain a readable worksheet.");
                    IXLRow headerRow = sheet.FirstRowUsed(); Dictionary<string, int> headers = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
                    foreach (IXLCell cell in headerRow.CellsUsed()) { string name = cell.GetFormattedString().Trim(); if (name.Length > 0 && !headers.ContainsKey(name)) headers.Add(name, cell.Address.ColumnNumber); }
                    List<string> missing = requiredHeaders.Where(x => !headers.ContainsKey(x)).ToList(); if (missing.Count > 0) throw new ArgumentException("Invalid or missing mandatory columns: " + string.Join(", ", missing));
                    DataTable table = new DataTable(); foreach (string header in requiredHeaders) table.Columns.Add(header, typeof(string));
                    int last = sheet.LastRowUsed().RowNumber();
                    for (int r = headerRow.RowNumber() + 1; r <= last; r++)
                    {
                        DataRow row = table.NewRow(); bool hasValue = false;
                        foreach (string header in requiredHeaders) { string value = sheet.Cell(r, headers[header]).GetFormattedString().Trim(); row[header] = value; if (value.Length > 0) hasValue = true; }
                        if (hasValue) table.Rows.Add(row);
                    }
                    return table;
                }
            }
            catch (ArgumentException) { throw; }
            catch (Exception ex) { throw new ArgumentException("Invalid Excel file format or unreadable workbook.", ex); }
        }

        private static void RejectDuplicates(DataTable rows)
        {
            HashSet<string> keys = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            for (int i = 0; i < rows.Rows.Count; i++)
            {
                string key = string.Join("\u001f", rows.Columns.Cast<DataColumn>().Select(c => Convert.ToString(rows.Rows[i][c]).Trim()));
                if (!keys.Add(key)) throw new ArgumentException("Duplicate billing record found at Excel row " + (i + 2) + ".");
            }
        }

        private static DataTable ReadLegacyExcel(byte[] bytes, string[] requiredHeaders)
        {
            string path = Path.Combine(Path.GetTempPath(), "Billing_" + Guid.NewGuid().ToString("N") + ".xls");
            try
            {
                File.WriteAllBytes(path, bytes);
                using (OleDbConnection connection = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + path + ";Extended Properties=\"Excel 8.0;HDR=YES;IMEX=1\""))
                {
                    connection.Open(); DataTable schema = connection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                    if (schema == null || schema.Rows.Count == 0) throw new ArgumentException("The workbook does not contain a readable worksheet.");
                    string sheet = Convert.ToString(schema.Rows[0]["TABLE_NAME"]);
                    using (OleDbDataAdapter adapter = new OleDbDataAdapter("SELECT * FROM [" + sheet.Replace("]", "]]" ) + "]", connection))
                    {
                        DataTable source = new DataTable(); adapter.Fill(source); return SelectRequiredColumns(source, requiredHeaders);
                    }
                }
            }
            catch (ArgumentException) { throw; }
            catch (Exception ex) { throw new ArgumentException("Invalid .xls file format or the Excel database provider is unavailable.", ex); }
            finally { try { if (File.Exists(path)) File.Delete(path); } catch { } }
        }

        private static DataTable SelectRequiredColumns(DataTable source, string[] requiredHeaders)
        {
            Dictionary<string, DataColumn> available = source.Columns.Cast<DataColumn>().ToDictionary(x => x.ColumnName.Trim(), x => x, StringComparer.OrdinalIgnoreCase);
            List<string> missing = requiredHeaders.Where(x => !available.ContainsKey(x)).ToList();
            if (missing.Count > 0) throw new ArgumentException("Invalid or missing mandatory columns: " + string.Join(", ", missing));
            DataTable result = new DataTable(); foreach (string header in requiredHeaders) result.Columns.Add(header, typeof(string));
            foreach (DataRow sourceRow in source.Rows)
            {
                DataRow row = result.NewRow(); bool hasValue = false;
                foreach (string header in requiredHeaders) { string value = sourceRow[available[header]] == DBNull.Value ? "" : Convert.ToString(sourceRow[available[header]]).Trim(); row[header] = value; if (value.Length > 0) hasValue = true; }
                if (hasValue) result.Rows.Add(row);
            }
            return result;
        }

        private static ImportBillingGrid Grid(DataTable table)
        {
            ImportBillingGrid result = new ImportBillingGrid { Success = true, Columns = table.Columns.Cast<DataColumn>().Select(x => x.ColumnName).ToList(), Rows = new List<Dictionary<string, object>>(), RowCount = table.Rows.Count };
            foreach (DataRow source in table.Rows) { Dictionary<string, object> row = new Dictionary<string, object>(); foreach (DataColumn column in table.Columns) row[column.ColumnName] = Format(source[column]); result.Rows.Add(row); } return result;
        }
        private static object Format(object value) { if (value == null || value == DBNull.Value) return ""; if (value is DateTime) return ((DateTime)value).ToString("dd-MMM-yyyy HH:mm"); return Convert.ToString(value); }
        private static ImportBillingGrid FailedGrid(Exception ex) { return new ImportBillingGrid { Success = false, Columns = new List<string>(), Rows = new List<Dictionary<string, object>>(), RowCount = 0, Message = UserMessage(ex) }; }
        private static string UserMessage(Exception ex) { Exception current = ex; while (current.InnerException != null) current = current.InnerException; return string.IsNullOrWhiteSpace(current.Message) ? "The requested billing operation could not be completed." : current.Message; }
        private static LegacyBillingImportState State(string token) { if (string.IsNullOrWhiteSpace(token)) throw new ArgumentException("Import reference is missing. Import the billing Excel again."); LegacyBillingImportState state = HttpContext.Current.Session[SessionPrefix + token] as LegacyBillingImportState; if (state == null) throw new InvalidOperationException("The imported billing preview has expired. Import the Excel file again."); return state; }
        private static string Period(int month, int year) { DateTime first = new DateTime(year, month, 1), last = first.AddMonths(1).AddDays(-1); return first.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) + " ~ " + last.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture); }
        private static string SafeFileName(string value) { return new string((value ?? "Project").Select(x => Path.GetInvalidFileNameChars().Contains(x) ? '_' : x).ToArray()); }
        private static string ProjectName(int projectId) { ImportBillingProject project = GetProjects().FirstOrDefault(x => x.ID == projectId); if (project == null) throw new UnauthorizedAccessException("You do not have access to the selected project."); return project.Name; }
        private static void EnsureProjectAccess(int projectId) { ProjectName(projectId); }
        private static void ValidatePeriod(int projectId, int month, int year) { if (projectId <= 0 || month < 1 || month > 12 || year < 2000 || year > 9999) throw new ArgumentException("Select a valid project, billing month, and billing year."); }
        private static int UserId() { int id; if (!int.TryParse(HttpContext.Current.User.Identity.Name, out id) || id <= 0) throw new InvalidOperationException("Your user session is invalid. Please sign in again."); return id; }
        private static string FirstValue(DataRow row, params string[] names) { foreach (string name in names) if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value && !string.IsNullOrWhiteSpace(Convert.ToString(row[name]))) return Convert.ToString(row[name]).Trim(); return ""; }
    }

    [Serializable] internal sealed class LegacyBillingImportState { public int ProjectId; public string ProjectName; public int BillingMonth; public int BillingYear; public string BillingPeriod; public string BillingCycle; public DataTable Rows; public bool Verified; }
    public sealed class ImportBillingProject { public int ID { get; set; } public string Name { get; set; } }
    public sealed class ImportBillingGrid { public bool Success { get; set; } public List<string> Columns { get; set; } public List<Dictionary<string, object>> Rows { get; set; } public int RowCount { get; set; } public string Token { get; set; } public string Message { get; set; } }
    public sealed class ImportBillingAction { public bool Success { get; set; } public int Count { get; set; } public string Message { get; set; } }
    public sealed class ImportBillingTemplate { public bool Success { get; set; } public string FileName { get; set; } public string FileBase64 { get; set; } public string Message { get; set; } }
}
