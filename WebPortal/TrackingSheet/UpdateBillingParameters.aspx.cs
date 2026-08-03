using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.TrackingSheet
{
    public partial class UpdateBillingParameters : System.Web.UI.Page
    {
        private const string DataSheet = "Billing Parameters", InfoSheet = "Billing Template Info";
        private static readonly string[] Headers = { "Project #", "Deal #", "Loan #", "Order Date", "Dispatch Date" };

        protected void Page_Load(object sender, EventArgs e)
        {
            string action = (Request.QueryString["action"] ?? "").ToLowerInvariant();
            if (action.Length == 0) return;
            try
            {
                int projectId;
                if (!int.TryParse(Request.QueryString["projectId"], out projectId) || projectId <= 0) throw new TemplateException("Please select a valid project.");
                if (action == "download") Download(projectId);
                else if (action == "import") WriteJson(Import(projectId), 200);
                else WriteJson(new { Success = false, Message = "Invalid request." }, 400);
            }
            catch (Exception ex) { WriteJson(new { Success = false, Message = ex.Message }, 400); }
        }

        [WebMethod]
        public static List<ProjectOption> GetProjects()
        {
            List<ProjectOption> result = new List<ProjectOption>();
            foreach (DataRow row in new bllMaster().GetAllProject().Rows)
            {
                int id; string value = FirstValue(row, "ProjectID", "ProjectId", "projectID", "ID");
                if (int.TryParse(value, out id)) result.Add(new ProjectOption { ID = id, Name = FirstValue(row, "ProjectName", "ProjectNo", "Name", "Project") });
            }
            return result;
        }

        [WebMethod]
        public static List<string> GetBillingFields(int projectId)
        {
            return BillingFields(projectId).AsEnumerable().Select(x => Convert.ToString(x["FieldName"])).ToList();
        }

        private void Download(int projectId)
        {
            string projectName = ProjectName(projectId); DataTable fields = BillingFields(projectId);
            using (XLWorkbook book = new XLWorkbook())
            {
                IXLWorksheet sheet = book.Worksheets.Add(DataSheet); int column = 1;
                foreach (string header in Headers) SetHeader(sheet.Cell(1, column++), header);
                foreach (DataRow field in fields.Rows) { SetHeader(sheet.Cell(1, column), Convert.ToString(field["FieldName"])); SetFormat(sheet.Column(column), Convert.ToString(field["DataType"]), Convert.ToString(field["DateFormat"])); column++; }
                sheet.Column(4).Style.DateFormat.Format = "dd/mm/yyyy"; sheet.Column(5).Style.DateFormat.Format = "dd/mm/yyyy";
                sheet.Row(1).Style.Font.Bold = true; sheet.SheetView.FreezeRows(1); sheet.Range(1, 1, 1, column - 1).SetAutoFilter(); sheet.Columns(1, column - 1).Width = 22;
                IXLWorksheet info = book.Worksheets.Add(InfoSheet); info.Cell("A1").Value = "TemplateVersion"; info.Cell("B1").Value = "1"; info.Cell("A2").Value = "ProjectID"; info.Cell("B2").Value = projectId; info.Cell("A3").Value = "ProjectName"; info.Cell("B3").Value = projectName; info.Cell("A4").Value = "ConfigurationSignature"; info.Cell("B4").Value = Signature(projectId, fields); info.Visibility = XLWorksheetVisibility.VeryHidden;
                using (MemoryStream stream = new MemoryStream()) { book.SaveAs(stream); WriteFile(stream.ToArray(), "Update_Billing_Parameters_" + SafeName(projectName) + ".xlsx"); }
            }
        }

        private ImportResult Import(int projectId)
        {
            HttpPostedFile file = Request.Files["file"];
            if (file == null || file.ContentLength <= 0) throw new TemplateException("Please select an Excel template.");
            if (!Path.GetExtension(file.FileName).Equals(".xlsx", StringComparison.OrdinalIgnoreCase)) throw new TemplateException("Invalid file format. Only .xlsx files are accepted.");
            if (file.ContentLength > 10 * 1024 * 1024) throw new TemplateException("The selected file exceeds the 10 MB limit.");
            string projectName = ProjectName(projectId); DataTable fields = BillingFields(projectId); XLWorkbook uploaded;
            try { uploaded = new XLWorkbook(file.InputStream); } catch { throw new TemplateException("Invalid file format. The workbook cannot be read."); }
            using (uploaded)
            {
                IXLWorksheet sheet = uploaded.Worksheets.FirstOrDefault(x => x.Name.Equals(DataSheet, StringComparison.OrdinalIgnoreCase)); IXLWorksheet info = uploaded.Worksheets.FirstOrDefault(x => x.Name.Equals(InfoSheet, StringComparison.OrdinalIgnoreCase));
                if (sheet == null || info == null) throw new TemplateException("Invalid template. Download a fresh template from this page.");
                int templateProject; if (!int.TryParse(info.Cell("B2").GetString(), out templateProject) || templateProject != projectId) throw new TemplateException("The template belongs to a different project.");
                if (!info.Cell("B4").GetString().Equals(Signature(projectId, fields), StringComparison.OrdinalIgnoreCase)) throw new TemplateException("Billing parameter configuration changed. Download a fresh template.");
                ValidateHeaders(sheet, fields); DataTable values = ReadValues(sheet, fields, projectId, projectName);
                DataTable results = new bllOLTrackingImport().UpdateExistingBillingRows(projectId, Path.GetFileName(file.FileName), values, UserId());
                int updated = results.Select("Status = 'Updated'").Length; DataRow[] missing = results.Select("Status = 'NotFound'"), duplicates = results.Select("Status = 'Duplicate'"), locked = results.Select("Status = 'Locked'");
                List<string> parts = new List<string> { updated + " record(s) updated successfully." };
                if (missing.Length > 0) parts.Add("Record not found for Excel row(s): " + string.Join(", ", missing.Select(x => Convert.ToString(x["ImportRowNumber"]))));
                if (duplicates.Length > 0) parts.Add("Duplicate database records for Excel row(s): " + string.Join(", ", duplicates.Select(x => Convert.ToString(x["ImportRowNumber"]))));
                if (locked.Length > 0) parts.Add("Verified or sent records are locked for Excel row(s): " + string.Join(", ", locked.Select(x => Convert.ToString(x["ImportRowNumber"]))));
                return new ImportResult { Success = updated > 0, HasWarnings = missing.Length + duplicates.Length + locked.Length > 0, Message = string.Join(" ", parts) };
            }
        }

        private static DataTable ReadValues(IXLWorksheet sheet, DataTable fields, int projectId, string projectName)
        {
            DataTable table = ValueTable(); IXLRange used = sheet.RangeUsed(); if (used == null || used.LastRow().RowNumber() < 2) throw new TemplateException("The template contains no data rows.");
            int last = used.LastRow().RowNumber(); if (last - 1 > 5000) throw new TemplateException("The file contains more than 5,000 rows."); HashSet<string> keys = new HashSet<string>(StringComparer.OrdinalIgnoreCase); int importRow = 0;
            for (int excelRow = 2; excelRow <= last; excelRow++)
            {
                if (!Enumerable.Range(1, fields.Rows.Count + 5).Any(c => !string.IsNullOrWhiteSpace(sheet.Cell(excelRow, c).GetFormattedString()))) continue;
                importRow++; string project = Text(sheet.Cell(excelRow, 1)), deal = Text(sheet.Cell(excelRow, 2)), loan = Text(sheet.Cell(excelRow, 3)); DateTime orderDate, dispatchDate;
                if (project.Length == 0 || deal.Length == 0 || loan.Length == 0) throw new TemplateException("Missing mandatory values at Excel row " + excelRow + ".");
                if (!project.Equals(projectName, StringComparison.OrdinalIgnoreCase) && project != projectId.ToString()) throw new TemplateException("Project # at Excel row " + excelRow + " does not match the selected project.");
                if (!ReadDate(sheet.Cell(excelRow, 4), "", out orderDate)) throw new TemplateException("Invalid Order Date at Excel row " + excelRow + ".");
                if (!ReadDate(sheet.Cell(excelRow, 5), "", out dispatchDate)) throw new TemplateException("Invalid Dispatch Date at Excel row " + excelRow + ".");
                if (!keys.Add(projectId + "|" + deal + "|" + loan + "|" + orderDate.ToString("yyyyMMdd"))) throw new TemplateException("Duplicate record in the file at Excel row " + excelRow + ".");
                if (fields.Rows.Count == 0) AddValue(table, importRow, projectId, project, deal, loan, orderDate, dispatchDate, 0, "", "");
                for (int i = 0; i < fields.Rows.Count; i++) { string normalized, error = ValidateValue(sheet.Cell(excelRow, i + 6), fields.Rows[i], out normalized); if (error.Length > 0) throw new TemplateException("Excel row " + excelRow + ", " + fields.Rows[i]["FieldName"] + ": " + error); AddValue(table, importRow, projectId, project, deal, loan, orderDate, dispatchDate, Convert.ToInt32(fields.Rows[i]["FieldConfigId"]), Convert.ToString(fields.Rows[i]["FieldName"]), normalized); }
            }
            if (table.Rows.Count == 0) throw new TemplateException("The template contains no data rows."); return table;
        }

        private static string ValidateValue(IXLCell cell, DataRow field, out string normalized)
        {
            string raw = Text(cell), type = Convert.ToString(field["DataType"]); normalized = raw; if (raw.Length == 0) return Convert.ToBoolean(field["IsRequired"]) ? "a value is required." : "";
            if (type.Equals("Number", StringComparison.OrdinalIgnoreCase)) { decimal n; if (!decimal.TryParse(raw, NumberStyles.Any, CultureInfo.InvariantCulture, out n) && !decimal.TryParse(raw, out n)) return "enter a valid number."; normalized = n.ToString(CultureInfo.InvariantCulture); }
            else if (type.Equals("Date", StringComparison.OrdinalIgnoreCase) || type.Equals("DateTime", StringComparison.OrdinalIgnoreCase)) { DateTime d; if (!ReadDate(cell, Convert.ToString(field["DateFormat"]), out d)) return "enter a valid date."; normalized = type.Equals("Date", StringComparison.OrdinalIgnoreCase) ? d.ToString("yyyy-MM-dd") : d.ToString("yyyy-MM-dd HH:mm:ss"); }
            else if (type.Equals("Checkbox", StringComparison.OrdinalIgnoreCase)) { string v = raw.ToLowerInvariant(); if (new[] { "yes", "true", "1" }.Contains(v)) normalized = "Yes"; else if (new[] { "no", "false", "0" }.Contains(v)) normalized = "No"; else return "use Yes/No, True/False, or 1/0."; }
            else if (type.Equals("Dropdown", StringComparison.OrdinalIgnoreCase)) { string[] options = Convert.ToString(field["OptionsText"]).Split(new[] { "\r\n", "\n", "," }, StringSplitOptions.RemoveEmptyEntries).Select(x => x.Trim()).ToArray(); string match = options.FirstOrDefault(x => x.Equals(raw, StringComparison.OrdinalIgnoreCase)); if (options.Length > 0 && match == null) return "value is not in the configured options."; if (match != null) normalized = match; }
            return "";
        }

        private static DataTable BillingFields(int projectId) { DataTable source = new bllOLTrackingImport().GetBillingParameterFields(projectId), result = source.Clone(); foreach (DataRow row in source.Rows) if (!Reserved(Convert.ToString(row["FieldName"]))) result.ImportRow(row); return result; }
        private static bool Reserved(string value) { string n = new string((value ?? "").ToLowerInvariant().Where(char.IsLetterOrDigit).ToArray()); return new[] { "project", "projectno", "projectnumber", "deal", "dealno", "dealnumber", "loan", "loanno", "loannumber", "orderdate", "dispatchdate" }.Contains(n); }
        private static void ValidateHeaders(IXLWorksheet sheet, DataTable fields) { for (int i = 0; i < Headers.Length; i++) if (!sheet.Cell(1, i + 1).GetString().Trim().Equals(Headers[i], StringComparison.OrdinalIgnoreCase)) throw new TemplateException("Invalid or missing mandatory column: " + Headers[i] + "."); for (int i = 0; i < fields.Rows.Count; i++) if (!sheet.Cell(1, i + 6).GetString().Trim().Equals(Convert.ToString(fields.Rows[i]["FieldName"]), StringComparison.OrdinalIgnoreCase)) throw new TemplateException("Invalid or missing billing parameter column: " + fields.Rows[i]["FieldName"] + "."); }
        private static DataTable ValueTable() { DataTable t = new DataTable(); t.Columns.Add("ImportRowNumber", typeof(int)); t.Columns.Add("ProjectID", typeof(int)); t.Columns.Add("Project"); t.Columns.Add("DealNo"); t.Columns.Add("LoanNo"); t.Columns.Add("OrderDate", typeof(DateTime)); t.Columns.Add("DispatchDate", typeof(DateTime)); t.Columns.Add("FieldConfigId", typeof(int)); t.Columns.Add("FieldName"); t.Columns.Add("FieldValue"); return t; }
        private static void AddValue(DataTable t, int rowNo, int projectId, string project, string deal, string loan, DateTime order, DateTime dispatch, int fieldId, string name, string value) { t.Rows.Add(rowNo, projectId, project, deal.Trim(), loan.Trim(), order.Date, dispatch.Date, fieldId, name, value ?? ""); }
        private static bool ReadDate(IXLCell cell, string format, out DateTime value) { if (cell.TryGetValue<DateTime>(out value)) return true; string text = Text(cell); return (!string.IsNullOrWhiteSpace(format) && DateTime.TryParseExact(text, format, CultureInfo.InvariantCulture, DateTimeStyles.None, out value)) || DateTime.TryParse(text, out value); }
        private static string Text(IXLCell cell) { return cell.GetFormattedString().Trim(); }
        private static void SetHeader(IXLCell cell, string value) { cell.Value = value; cell.Style.Fill.BackgroundColor = XLColor.FromHtml("#117A9B"); cell.Style.Font.FontColor = XLColor.White; }
        private static void SetFormat(IXLColumn c, string type, string format) { if (type.Equals("DateTime", StringComparison.OrdinalIgnoreCase)) c.Style.DateFormat.Format = "dd/mm/yyyy hh:mm"; else if (type.Equals("Date", StringComparison.OrdinalIgnoreCase)) c.Style.DateFormat.Format = string.IsNullOrWhiteSpace(format) ? "dd/mm/yyyy" : format.Replace("MM", "mm"); }
        private static string ProjectName(int id) { ProjectOption p = GetProjects().FirstOrDefault(x => x.ID == id); if (p == null) throw new TemplateException("Selected project was not found."); return p.Name; }
        private static int UserId() { int id; return int.TryParse(HttpContext.Current.User.Identity.Name, out id) ? id : 0; }
        private static string Signature(int id, DataTable fields) { StringBuilder s = new StringBuilder("BILLINGPARAMETERS|1|").Append(id); foreach (DataRow f in fields.Rows) s.Append('|').Append(f["FieldConfigId"]).Append(':').Append(f["FieldName"]).Append(':').Append(f["DataType"]).Append(':').Append(f["IsRequired"]).Append(':').Append(f["DateFormat"]); using (SHA256 a = SHA256.Create()) return BitConverter.ToString(a.ComputeHash(Encoding.UTF8.GetBytes(s.ToString()))).Replace("-", ""); }
        private static string FirstValue(DataRow row, params string[] names) { foreach (string n in names) if (row.Table.Columns.Contains(n) && row[n] != DBNull.Value && !string.IsNullOrWhiteSpace(Convert.ToString(row[n]))) return Convert.ToString(row[n]).Trim(); return ""; }
        private static string SafeName(string value) { foreach (char c in Path.GetInvalidFileNameChars()) value = value.Replace(c, '_'); return value.Replace(' ', '_'); }
        private void WriteFile(byte[] bytes, string name) { Response.Clear(); Response.ClearHeaders(); Response.BufferOutput = true; Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"; Response.AddHeader("content-disposition", "attachment;filename=" + name); Response.AddHeader("content-length", bytes.Length.ToString(CultureInfo.InvariantCulture)); Response.OutputStream.Write(bytes, 0, bytes.Length); Response.Flush(); Response.SuppressContent = true; Context.ApplicationInstance.CompleteRequest(); }
        private void WriteJson(object value, int status) { byte[] bytes = Encoding.UTF8.GetBytes(new JavaScriptSerializer().Serialize(value)); Response.Clear(); Response.ClearHeaders(); Response.StatusCode = status; Response.TrySkipIisCustomErrors = true; Response.ContentType = "application/json"; Response.AddHeader("content-length", bytes.Length.ToString(CultureInfo.InvariantCulture)); Response.OutputStream.Write(bytes, 0, bytes.Length); Response.Flush(); Response.SuppressContent = true; Context.ApplicationInstance.CompleteRequest(); }
        private sealed class TemplateException : Exception { public TemplateException(string message) : base(message) { } }
        private sealed class ImportResult { public bool Success { get; set; } public bool HasWarnings { get; set; } public string Message { get; set; } }
    }
}
