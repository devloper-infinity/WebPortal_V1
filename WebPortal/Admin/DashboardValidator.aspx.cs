using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;

namespace WebPortal.Admin
{
    public partial class DashboardValidator : Page
    {
        private bool downloadSent;
        public string ErrorMessage { get; private set; }
        public string ResultHtml { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Enctype = "multipart/form-data";
            string download = Request.QueryString["download"];
            if (!string.IsNullOrWhiteSpace(download)) { DownloadResult(download); return; }
            if (!string.Equals(Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase)) return;

            string prpPath = null, dcPath = null;
            try
            {
                HttpPostedFile prp = Request.Files["dashboardReportFile"];
                HttpPostedFile dc = Request.Files["validationFile"];
                ValidateUpload(prp, "PRP Dashboard");
                ValidateUpload(dc, "Disposition & Comments Report");
                prpPath = SaveTemporaryUpload(prp);
                dcPath = SaveTemporaryUpload(dc);
                string templatePath = Server.MapPath("~/Templates/DashboardValidatorTemplate.xlsx");
                if (!File.Exists(templatePath)) throw new InvalidOperationException("The Dashboard Validator template is not available.");

                DashboardPythonRunner.Result result = DashboardPythonRunner.Generate(prpPath, dcPath, templatePath, Path.GetTempPath());
                string cleanupToken = StoreDownload(result.CleanupPath, "Dashboard Clean up");
                string validationToken = StoreDownload(result.ValidationPath, "D&C Validation Report");
                ResultHtml = BuildResultHtml(result.Issues, cleanupToken, validationToken);
            }
            catch (Exception ex) { ErrorMessage = ex.Message; }
            finally { SafeDelete(prpPath); SafeDelete(dcPath); }
        }

        private string StoreDownload(string path, string label)
        {
            string token = Guid.NewGuid().ToString("N");
            Session["DashboardValidator_" + token] = new DownloadInfo { Path = path, Label = label };
            return token;
        }

        private static void ValidateUpload(HttpPostedFile file, string label)
        {
            if (file == null || file.ContentLength <= 0) throw new InvalidOperationException(label + " is required.");
            if (!string.Equals(Path.GetExtension(file.FileName), ".xlsx", StringComparison.OrdinalIgnoreCase)) throw new InvalidOperationException(label + " must be an .xlsx file.");
            if (file.ContentLength > 50 * 1024 * 1024) throw new InvalidOperationException(label + " exceeds the 50 MB upload limit.");
        }

        private static string SaveTemporaryUpload(HttpPostedFile file)
        {
            string path = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString("N") + ".xlsx");
            file.SaveAs(path);
            return path;
        }

        private void DownloadResult(string token)
        {
            string key = "DashboardValidator_" + token;
            DownloadInfo info = Session[key] as DownloadInfo;
            if (info == null || !File.Exists(info.Path))
            {
                Response.StatusCode = 404;
                ErrorMessage = "The generated workbook is no longer available. Please generate it again.";
                return;
            }
            try
            {
                byte[] bytes = File.ReadAllBytes(info.Path);
                Response.Clear();
                Response.Buffer = true;
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition", "attachment; filename=\"" + info.Label.Replace("\"", "") + "_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".xlsx\"");
                Response.AddHeader("Content-Length", bytes.Length.ToString());
                Response.BinaryWrite(bytes);
                Response.Flush();
                downloadSent = true;
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
            finally { Session.Remove(key); SafeDelete(info.Path); }
        }

        private static string BuildResultHtml(IEnumerable<DashboardPythonRunner.IssueRow> issues, string cleanupToken, string validationToken)
        {
            var html = new StringBuilder("<section class='erp-section-card p-3 mt-4'>");
            html.Append("<div class='mb-3 d-flex flex-wrap' style='gap:10px'>")
                .Append(DownloadButton(cleanupToken, "Download Dashboard Clean up"))
                .Append(DownloadButton(validationToken, "Download D&amp;C Validation Report"))
                .Append("</div><div class='erp-table-wrap'><table id='validationResults' class='table table-bordered table-hover nowrap' style='width:100%'>")
                .Append("<thead><tr><th>Loan #</th><th>Sheet</th><th>Dashboard Finding</th><th>Result</th><th>Comment</th></tr></thead><tbody>");
            foreach (DashboardPythonRunner.IssueRow row in issues)
            {
                html.Append("<tr class='").Append(row.Result == "Manual Check" ? "table-warning" : "table-danger").Append("'><td>")
                    .Append(H(row.LoanId)).Append("</td><td>").Append(H(row.Sheet)).Append("</td><td>")
                    .Append(H(row.Finding)).Append("</td><td>").Append(H(row.Result)).Append("</td><td>")
                    .Append(H(row.Comment)).Append("</td></tr>");
            }
            return html.Append("</tbody></table></div></section>").ToString();
        }

        private static string DownloadButton(string token, string label)
        {
            return "<a class='btn btn-success' href='DashboardValidator.aspx?download=" + HttpUtility.UrlEncode(token) + "'><i class='fas fa-download'></i> " + label + "</a>";
        }
        private static string H(string value) { return HttpUtility.HtmlEncode(value ?? string.Empty); }
        protected override void Render(HtmlTextWriter writer) { if (!downloadSent) base.Render(writer); }
        private static void SafeDelete(string path) { try { if (!string.IsNullOrWhiteSpace(path) && File.Exists(path)) File.Delete(path); } catch { } }

        [Serializable]
        private sealed class DownloadInfo { public string Path { get; set; } public string Label { get; set; } }
    }
}
