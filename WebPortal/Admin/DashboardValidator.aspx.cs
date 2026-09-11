using System;
using System.IO;
using System.Web;
using System.Web.UI;

namespace WebPortal.Admin
{
    public partial class DashboardValidator : Page
    {
        private bool downloadSent;
        public string ErrorMessage { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Enctype = "multipart/form-data";

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

                DashboardValidatorEngine.Generate(inputPath, validationPath, templatePath, outputPath);
                SendDownload(outputPath);
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

        private void SendDownload(string path)
        {
            byte[] bytes = File.ReadAllBytes(path);
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
