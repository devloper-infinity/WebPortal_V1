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

            if (!string.IsNullOrWhiteSpace(Request.QueryString["download"]))
            {
                DownloadResult(Request.QueryString["download"]);
                return;
            }

            if (!string.Equals(Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase))
                return;

            string inputPath = null;
            string validationPath = null;
            string outputPath = null;

            try
            {
                HttpPostedFile report = Request.Files["dashboardReportFile"];
                HttpPostedFile validation = Request.Files["validationFile"];

                ValidateUpload(report, "Dashboard Report");
                ValidateUpload(validation, "Validation File");

                inputPath = SaveTemporaryUpload(report);
                validationPath = SaveTemporaryUpload(validation);
                outputPath = Path.Combine(Path.GetTempPath(),
                    "Dashboard_Cleaned_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + "_" + Guid.NewGuid().ToString("N") + ".xlsx");

                string templatePath = Server.MapPath("~/Templates/DashboardValidatorTemplate.xlsx");
                if (!File.Exists(templatePath))
                    throw new InvalidOperationException("The Dashboard Validator template is not available.");

                IList<DashboardValidatorEngine.Phase2ResultRow> results =
                    DashboardValidatorEngine.Generate(inputPath, validationPath, templatePath, outputPath);
                string token = Guid.NewGuid().ToString("N");
                Session["DashboardValidator_" + token] = outputPath;
                outputPath = null;
                ResultHtml = BuildResultHtml(results, token);
            }
            catch (Exception ex)
            {
                ErrorMessage = ex.Message;
            }
            finally
            {
                SafeDelete(inputPath);
                SafeDelete(validationPath);
                SafeDelete(outputPath);
            }
        }

        private static void ValidateUpload(HttpPostedFile file, string label)
        {
            if (file == null || file.ContentLength <= 0)
                throw new InvalidOperationException(label + " is required.");

            if (!string.Equals(Path.GetExtension(file.FileName), ".xlsx", StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException(label + " must be an .xlsx file.");

            const int maximumBytes = 50 * 1024 * 1024;
            if (file.ContentLength > maximumBytes)
                throw new InvalidOperationException(label + " exceeds the 50 MB upload limit.");
        }

        private static string SaveTemporaryUpload(HttpPostedFile file)
        {
            string path = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString("N") + ".xlsx");
            file.SaveAs(path);
            return path;
        }

        private void DownloadResult(string token)
        {
            string sessionKey = "DashboardValidator_" + token;
            string path = Session[sessionKey] as string;
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                Response.StatusCode = 404;
                ErrorMessage = "The generated workbook is no longer available. Please generate it again.";
                return;
            }

            byte[] bytes = File.ReadAllBytes(path);
            try
            {
                Response.Clear();
                Response.Buffer = true;
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition", "attachment; filename=Dashboard_Cleaned_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".xlsx");
                Response.AddHeader("Content-Length", bytes.Length.ToString());
                Response.BinaryWrite(bytes);
                Response.Flush();
                downloadSent = true;
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
            finally
            {
                Session.Remove(sessionKey);
                SafeDelete(path);
            }
        }

        private static string BuildResultHtml(IEnumerable<DashboardValidatorEngine.Phase2ResultRow> results, string token)
        {
            var html = new StringBuilder();
            html.Append("<section class='erp-section-card p-3 mt-4'>");
            html.Append("<div class='mb-3'><a class='btn btn-success' href='DashboardValidator.aspx?download=")
                .Append(HttpUtility.UrlEncode(token)).Append("'><i class='fas fa-download'></i> Download Excel</a></div>");
            html.Append("<div class='erp-table-wrap'><table id='validationResults' class='table table-bordered table-hover nowrap' style='width:100%'>");
            html.Append("<thead><tr><th>Loan #</th><th>Exception Header</th><th>Exception Description</th></tr></thead><tbody>");
            foreach (DashboardValidatorEngine.Phase2ResultRow row in results)
            {
                html.Append("<tr class='table-danger'><td>").Append(H(row.LoanId)).Append("</td><td>")
                    .Append(H(row.ExceptionHeader)).Append("</td><td>")
                    .Append(H(row.ExceptionDescription)).Append("</td></tr>");
            }
            html.Append("</tbody></table></div></section>");
            return html.ToString();
        }

        private static string H(string value)
        {
            return HttpUtility.HtmlEncode(value ?? string.Empty);
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (!downloadSent)
                base.Render(writer);
        }

        private static void SafeDelete(string path)
        {
            try
            {
                if (!string.IsNullOrWhiteSpace(path) && File.Exists(path))
                    File.Delete(path);
            }
            catch
            {
                // Temporary-file cleanup must not replace the processing result.
            }
        }
    }
}
