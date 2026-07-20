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
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.TrackingSheet
{
    public partial class ImportData : System.Web.UI.Page
    {
        private const string DataSheetName = "Tracking Data";
        private const string InfoSheetName = "OLTracking Template Info";
        private const string InstructionsSheetName = "Import Information";
        private const int MaximumRows = 5000;
        private const int MaximumBytes = 10 * 1024 * 1024;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindProjects();
                ShowConfiguredFields();
            }
            BindRecentImports();
        }

        protected void ddlProject_SelectedIndexChanged(object sender, EventArgs e)
        {
            ShowConfiguredFields();
        }

        protected void btnDownloadTemplate_Click(object sender, EventArgs e)
        {
            int projectId = SelectedProjectId();
            if (projectId <= 0)
            {
                ShowMessage("Please select a project.", true);
                return;
            }

            DataTable fields = new bllOLTrackingImport().GetImportFields(projectId);
            if (fields.Rows.Count == 0)
            {
                ShowMessage("No fields are marked For Import for the selected project.", true);
                return;
            }

            using (XLWorkbook workbook = new XLWorkbook())
            {
                string projectName = SelectedProjectName();
                IXLWorksheet instructions = workbook.Worksheets.Add(InstructionsSheetName);
                instructions.Cell("A1").Value = "OLTracking Import Template";
                instructions.Cell("A1").Style.Font.Bold = true;
                instructions.Cell("A1").Style.Font.FontSize = 18;
                instructions.Cell("A1").Style.Font.FontColor = XLColor.FromHtml("#117A9B");
                instructions.Cell("A3").Value = "Project";
                instructions.Cell("B3").Value = projectName;
                instructions.Cell("A4").Value = "Project ID";
                instructions.Cell("B4").Value = projectId;
                instructions.Cell("A6").Value = "Instructions";
                instructions.Cell("A6").Style.Font.Bold = true;
                instructions.Cell("A7").Value = "1. Enter data only in the Tracking Data sheet.";
                instructions.Cell("A8").Value = "2. Do not rename or reorder template columns.";
                instructions.Cell("A9").Value = "3. Select this same project on the Import Data page before uploading.";
                instructions.Cell("A10").Value = "4. Columns marked with * are mandatory.";
                instructions.Cell("A12").Value = "Configured Import Fields";
                instructions.Cell("A12").Style.Font.Bold = true;
                int instructionRow = 13;
                foreach (DataRow field in fields.Rows)
                {
                    instructions.Cell(instructionRow++, 1).Value = Convert.ToString(field["FieldName"]) + (Convert.ToBoolean(field["IsRequired"]) ? " *" : string.Empty);
                }
                instructions.Column(1).Width = 52;
                instructions.Column(2).Width = 32;

                IXLWorksheet dataSheet = workbook.Worksheets.Add(DataSheetName);
                dataSheet.Cell(1, 1).Value = "Entry Date";
                dataSheet.Cell(1, 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#117A9B");
                dataSheet.Cell(1, 1).Style.Font.FontColor = XLColor.White;

                int column = 2;
                foreach (DataRow field in fields.Rows)
                {
                    IXLCell header = dataSheet.Cell(1, column);
                    header.Value = Convert.ToString(field["FieldName"]);
                    header.Style.Fill.BackgroundColor = XLColor.FromHtml("#117A9B");
                    header.Style.Font.FontColor = XLColor.White;
                    if (Convert.ToBoolean(field["IsRequired"]))
                        header.Value = Convert.ToString(field["FieldName"]) + " *";

                    string dataType = Convert.ToString(field["DataType"]);
                    if (dataType.Equals("Date", StringComparison.OrdinalIgnoreCase) || dataType.Equals("DateTime", StringComparison.OrdinalIgnoreCase))
                        dataSheet.Column(column).Style.DateFormat.Format = DateFormatForExcel(Convert.ToString(field["DateFormat"]), dataType);
                    column++;
                }

                dataSheet.Row(1).Style.Font.Bold = true;
                dataSheet.SheetView.FreezeRows(1);
                dataSheet.Range(1, 1, 1, fields.Rows.Count + 1).SetAutoFilter();
                dataSheet.Column(1).Style.DateFormat.Format = "dd/mm/yyyy";
                dataSheet.Columns(1, fields.Rows.Count + 1).Width = 22;

                IXLWorksheet infoSheet = workbook.Worksheets.Add(InfoSheetName);
                infoSheet.Cell("A1").Value = "TemplateVersion";
                infoSheet.Cell("B1").Value = "1";
                infoSheet.Cell("A2").Value = "ProjectID";
                infoSheet.Cell("B2").Value = projectId;
                infoSheet.Cell("A3").Value = "ProjectName";
                infoSheet.Cell("B3").Value = projectName;
                infoSheet.Cell("A4").Value = "ConfigurationSignature";
                infoSheet.Cell("B4").Value = BuildSignature(projectId, fields);
                infoSheet.Visibility = XLWorksheetVisibility.VeryHidden;

                using (MemoryStream stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    string safeProject = SanitizeFileName(ddlProject.SelectedItem.Text);
                    Response.Clear();
                    Response.Buffer = true;
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;filename=OLTracking_Import_" + safeProject + ".xlsx");
                    Response.BinaryWrite(stream.ToArray());
                    Response.Flush();
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
            }
        }

        protected void btnImport_Click(object sender, EventArgs e)
        {
            int selectedProjectId = SelectedProjectId();
            if (selectedProjectId <= 0)
            {
                ShowMessage("Select the project you are importing data into before choosing the file.", true);
                return;
            }
            if (!fuImportFile.HasFile)
            {
                ShowMessage("Please select an Excel template to import.", true);
                return;
            }
            if (!Path.GetExtension(fuImportFile.FileName).Equals(".xlsx", StringComparison.OrdinalIgnoreCase))
            {
                ShowMessage("Only .xlsx files generated from this page are accepted.", true);
                return;
            }
            if (fuImportFile.PostedFile.ContentLength > MaximumBytes)
            {
                ShowMessage("The selected file exceeds the 10 MB limit.", true);
                return;
            }

            try
            {
                using (XLWorkbook workbook = new XLWorkbook(fuImportFile.PostedFile.InputStream))
                {
                    IXLWorksheet infoSheet = workbook.Worksheets.FirstOrDefault(w => w.Name.Equals(InfoSheetName, StringComparison.OrdinalIgnoreCase));
                    IXLWorksheet dataSheet = workbook.Worksheets.FirstOrDefault(w => w.Name.Equals(DataSheetName, StringComparison.OrdinalIgnoreCase));
                    if (infoSheet == null || dataSheet == null)
                        throw new InvalidOperationException("This is not a valid OLTracking import template. Please download a fresh template.");

                    int projectId;
                    if (!int.TryParse(infoSheet.Cell("B2").GetString(), out projectId) || projectId <= 0)
                        throw new InvalidOperationException("The template project identity is missing or invalid.");
                    bool hasProjectNameMetadata = infoSheet.Cell("A3").GetString().Trim().Equals("ProjectName", StringComparison.OrdinalIgnoreCase);
                    if (projectId != selectedProjectId)
                    {
                        string templateProjectName = hasProjectNameMetadata ? infoSheet.Cell("B3").GetString().Trim() : projectId.ToString();
                        throw new InvalidOperationException("Project mismatch. You selected '" + SelectedProjectName() + "', but this template belongs to '" + (string.IsNullOrWhiteSpace(templateProjectName) ? projectId.ToString() : templateProjectName) + "'. No data was imported.");
                    }

                    DataTable fields = new bllOLTrackingImport().GetImportFields(projectId);
                    if (fields.Rows.Count == 0)
                        throw new InvalidOperationException("No fields are currently marked For Import for this project.");

                    string uploadedSignature = infoSheet.Cell(hasProjectNameMetadata ? "B4" : "B3").GetString().Trim();
                    if (!uploadedSignature.Equals(BuildSignature(projectId, fields), StringComparison.OrdinalIgnoreCase))
                        throw new InvalidOperationException("Field configuration changed after this template was downloaded. Please download a new template.");

                    ValidateHeaders(dataSheet, fields);
                    List<string> errors = new List<string>();
                    DataTable values = BuildImportValues(dataSheet, fields, errors);
                    if (errors.Count > 0)
                        throw new InvalidOperationException("Import validation failed:\r\n" + string.Join("\r\n", errors.Take(20)) + (errors.Count > 20 ? "\r\n...and " + (errors.Count - 20) + " more error(s)." : string.Empty));
                    if (values.Rows.Count == 0)
                        throw new InvalidOperationException("The template does not contain any data rows.");

                    int importedRows = values.DefaultView.ToTable(true, "ImportRowNumber").Rows.Count;
                    long batchId = new bllOLTrackingImport().ImportRows(projectId, Path.GetFileName(fuImportFile.FileName), values, CurrentUserId());
                    ShowMessage(importedRows + " row(s) imported successfully into " + SelectedProjectName() + ". Batch #" + batchId + ".", false);
                    BindRecentImports();
                }
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message, true);
            }
        }

        private static DataTable BuildImportValues(IXLWorksheet sheet, DataTable fields, List<string> errors)
        {
            DataTable values = new DataTable();
            values.Columns.Add("ImportRowNumber", typeof(int));
            values.Columns.Add("EntryDate", typeof(DateTime));
            values.Columns.Add("FieldConfigId", typeof(int));
            values.Columns.Add("FieldName", typeof(string));
            values.Columns.Add("FieldValue", typeof(string));

            IXLRange usedRange = sheet.RangeUsed();
            if (usedRange == null) return values;
            int lastRow = usedRange.LastRow().RowNumber();
            if (lastRow - 1 > MaximumRows)
            {
                errors.Add("The file contains more than " + MaximumRows + " data rows.");
                return values;
            }

            int importRow = 0;
            for (int excelRow = 2; excelRow <= lastRow; excelRow++)
            {
                bool hasData = false;
                for (int c = 1; c <= fields.Rows.Count + 1; c++)
                    if (!string.IsNullOrWhiteSpace(sheet.Cell(excelRow, c).GetFormattedString())) { hasData = true; break; }
                if (!hasData) continue;

                importRow++;
                DateTime entryDate;
                if (!TryReadDate(sheet.Cell(excelRow, 1), "", out entryDate))
                {
                    errors.Add("Row " + excelRow + ": Entry Date is required and must be a valid date.");
                    continue;
                }

                for (int index = 0; index < fields.Rows.Count; index++)
                {
                    DataRow field = fields.Rows[index];
                    string raw = sheet.Cell(excelRow, index + 2).GetFormattedString().Trim();
                    string normalized;
                    string error = ValidateValue(raw, sheet.Cell(excelRow, index + 2), field, out normalized);
                    if (!string.IsNullOrEmpty(error))
                    {
                        errors.Add("Row " + excelRow + ", " + Convert.ToString(field["FieldName"]) + ": " + error);
                        continue;
                    }

                    DataRow value = values.NewRow();
                    value["ImportRowNumber"] = importRow;
                    value["EntryDate"] = entryDate.Date;
                    value["FieldConfigId"] = Convert.ToInt32(field["FieldConfigId"]);
                    value["FieldName"] = Convert.ToString(field["FieldName"]);
                    value["FieldValue"] = normalized;
                    values.Rows.Add(value);
                }
            }
            return values;
        }

        private static string ValidateValue(string raw, IXLCell cell, DataRow field, out string normalized)
        {
            normalized = raw;
            bool required = Convert.ToBoolean(field["IsRequired"]);
            if (string.IsNullOrWhiteSpace(raw))
                return required ? "a value is required." : string.Empty;

            string type = Convert.ToString(field["DataType"]);
            if (type.Equals("Number", StringComparison.OrdinalIgnoreCase))
            {
                decimal number;
                if (!decimal.TryParse(raw, NumberStyles.Any, CultureInfo.InvariantCulture, out number) &&
                    !decimal.TryParse(raw, NumberStyles.Any, CultureInfo.CurrentCulture, out number))
                    return "enter a valid number.";
                normalized = number.ToString(CultureInfo.InvariantCulture);
            }
            else if (type.Equals("Date", StringComparison.OrdinalIgnoreCase) || type.Equals("DateTime", StringComparison.OrdinalIgnoreCase))
            {
                DateTime date;
                if (!TryReadDate(cell, Convert.ToString(field["DateFormat"]), out date))
                    return "enter a valid " + type.ToLowerInvariant() + (string.IsNullOrWhiteSpace(Convert.ToString(field["DateFormat"])) ? "." : " in " + Convert.ToString(field["DateFormat"]) + " format.");
                normalized = type.Equals("Date", StringComparison.OrdinalIgnoreCase)
                    ? date.ToString("yyyy-MM-dd") : date.ToString("yyyy-MM-dd HH:mm:ss");
            }
            else if (type.Equals("Checkbox", StringComparison.OrdinalIgnoreCase))
            {
                string value = raw.ToLowerInvariant();
                if (value == "yes" || value == "true" || value == "1") normalized = "Yes";
                else if (value == "no" || value == "false" || value == "0") normalized = "No";
                else return "use Yes/No, True/False, or 1/0.";
            }
            else if (type.Equals("Dropdown", StringComparison.OrdinalIgnoreCase))
            {
                string[] options = Convert.ToString(field["OptionsText"])
                    .Split(new[] { "\r\n", "\n", "," }, StringSplitOptions.RemoveEmptyEntries)
                    .Select(x => x.Trim()).Where(x => x.Length > 0).ToArray();
                string match = options.FirstOrDefault(x => x.Equals(raw, StringComparison.OrdinalIgnoreCase));
                if (options.Length > 0 && match == null) return "value is not in the configured dropdown options.";
                if (match != null) normalized = match;
            }
            return string.Empty;
        }

        private static bool TryReadDate(IXLCell cell, string format, out DateTime value)
        {
            if (cell.TryGetValue<DateTime>(out value)) return true;
            string text = cell.GetFormattedString().Trim();
            if (!string.IsNullOrWhiteSpace(format) && DateTime.TryParseExact(text, format, CultureInfo.InvariantCulture, DateTimeStyles.None, out value)) return true;
            return DateTime.TryParse(text, CultureInfo.CurrentCulture, DateTimeStyles.None, out value) ||
                   DateTime.TryParse(text, CultureInfo.InvariantCulture, DateTimeStyles.None, out value);
        }

        private static void ValidateHeaders(IXLWorksheet sheet, DataTable fields)
        {
            if (!sheet.Cell(1, 1).GetString().Trim().Equals("Entry Date", StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException("Column 1 must be Entry Date.");
            for (int index = 0; index < fields.Rows.Count; index++)
            {
                string expected = Convert.ToString(fields.Rows[index]["FieldName"]);
                if (Convert.ToBoolean(fields.Rows[index]["IsRequired"])) expected += " *";
                string actual = sheet.Cell(1, index + 2).GetString().Trim();
                if (!actual.Equals(expected, StringComparison.OrdinalIgnoreCase))
                    throw new InvalidOperationException("Template column " + (index + 2) + " must be '" + expected + "'. Please do not rename or reorder columns.");
            }
        }

        private void BindProjects()
        {
            DataTable projects = new bllMaster().GetAllProject();
            ddlProject.Items.Clear();
            ddlProject.Items.Add(new ListItem("Select Project", ""));
            foreach (DataRow row in projects.Rows)
            {
                string id = FirstValue(row, "ProjectID", "ProjectId", "projectID", "ID");
                string name = FirstValue(row, "ProjectName", "ProjectNo", "Name", "Project");
                if (!string.IsNullOrWhiteSpace(id)) ddlProject.Items.Add(new ListItem(string.IsNullOrWhiteSpace(name) ? id : name, id));
            }
        }

        private void ShowConfiguredFields()
        {
            int projectId = SelectedProjectId();
            if (projectId <= 0)
            {
                lblConfiguredFields.Text = "Select a project to view its import fields.";
                lblImportProject.Text = "Destination project: Not selected";
                return;
            }
            lblImportProject.Text = "Destination project: " + SelectedProjectName();
            DataTable fields = new bllOLTrackingImport().GetImportFields(projectId);
            lblConfiguredFields.Text = fields.Rows.Count == 0
                ? "No fields are currently marked For Import."
                : "Template fields: " + string.Join(", ", fields.AsEnumerable().Select(r => Convert.ToString(r["FieldName"])));
        }

        private void BindRecentImports()
        {
            DataTable imports = new bllOLTrackingImport().GetRecentImports(CurrentUserId());
            DataTable projects = new bllMaster().GetAllProject();
            imports.Columns.Add("ProjectName", typeof(string));
            foreach (DataRow import in imports.Rows)
            {
                string projectId = Convert.ToString(import["ProjectID"]);
                string projectName = projectId;
                foreach (DataRow project in projects.Rows)
                {
                    if (FirstValue(project, "ProjectID", "ProjectId", "projectID", "ID") == projectId)
                    {
                        string configuredName = FirstValue(project, "ProjectName", "projectName", "ProjectNo", "Name", "Project");
                        if (!string.IsNullOrWhiteSpace(configuredName)) projectName = configuredName;
                        break;
                    }
                }
                import["ProjectName"] = projectName;
            }
            gvRecentImports.DataSource = imports;
            gvRecentImports.DataBind();
        }

        private int SelectedProjectId()
        {
            int projectId;
            return int.TryParse(ddlProject.SelectedValue, out projectId) ? projectId : 0;
        }

        private string SelectedProjectName()
        {
            return ddlProject.SelectedItem == null ? string.Empty : ddlProject.SelectedItem.Text;
        }

        private static int CurrentUserId()
        {
            int userId;
            return int.TryParse(HttpContext.Current.User.Identity.Name, out userId) ? userId : 0;
        }

        private void ShowMessage(string message, bool error)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "ol-message " + (error ? "ol-error" : "ol-success");
            lblMessage.Visible = true;
        }

        private static string BuildSignature(int projectId, DataTable fields)
        {
            StringBuilder source = new StringBuilder("OLTRACKING|1|").Append(projectId);
            foreach (DataRow field in fields.Rows)
                source.Append('|').Append(field["FieldConfigId"]).Append(':').Append(field["FieldName"]).Append(':').Append(field["DataType"]).Append(':').Append(field["IsRequired"]).Append(':').Append(field["DateFormat"]);
            using (SHA256 algorithm = SHA256.Create())
                return BitConverter.ToString(algorithm.ComputeHash(Encoding.UTF8.GetBytes(source.ToString()))).Replace("-", string.Empty);
        }

        private static string FirstValue(DataRow row, params string[] names)
        {
            foreach (string name in names)
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value && !string.IsNullOrWhiteSpace(Convert.ToString(row[name]))) return Convert.ToString(row[name]).Trim();
            return string.Empty;
        }

        private static string DateFormatForExcel(string format, string dataType)
        {
            if (dataType.Equals("DateTime", StringComparison.OrdinalIgnoreCase)) return "dd/mm/yyyy hh:mm";
            return string.IsNullOrWhiteSpace(format) ? "dd/mm/yyyy" : format.Replace("MM", "mm");
        }

        private static string SanitizeFileName(string value)
        {
            foreach (char invalid in Path.GetInvalidFileNameChars()) value = value.Replace(invalid, '_');
            return value.Replace(' ', '_');
        }
    }
}
