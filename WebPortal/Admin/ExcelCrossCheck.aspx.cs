using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace InfinityERP.Admin
{
    public class ExcelCrossCheck : Page
    {
        private bool ajaxRequest;
        public string MessageHtml { get; private set; } = string.Empty;
        public string ResultHtml { get; private set; } = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Enctype = "multipart/form-data";
            ajaxRequest = string.Equals(Request.QueryString["ajax"], "1", StringComparison.Ordinal);
            // Keep your existing ERP authentication/authorization check here.
            // Example only:
            // if (!User.Identity.IsAuthenticated) Response.Redirect("~/Login.aspx");

            if (Request.QueryString["download"] != null)
            {
                DownloadResult(Request.QueryString["download"]);
                return;
            }

            if (!string.Equals(Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase))
                return;

            try
            {
                CompareUploadedFiles();
            }
            catch (Exception ex)
            {
                MessageHtml = Alert("danger", HttpUtility.HtmlEncode(ex.Message));
            }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (!ajaxRequest) { base.Render(writer); return; }
            Response.ContentType = "application/json";
            writer.Write(new JavaScriptSerializer().Serialize(new { MessageHtml, ResultHtml }));
        }

        private void CompareUploadedFiles()
        {
            HttpPostedFile scienna = Request.Files["sciennaFile"];
            HttpPostedFile lauramac = Request.Files["lauramacFile"];

            ValidateUpload(scienna, "Scienna");
            ValidateUpload(lauramac, "Lauramac");

            string sTemp = SaveTemp(scienna);
            string lTemp = SaveTemp(lauramac);
            string output = null;

            try
            {
                CrossCheckResult result = ExcelCrossCheckEngine.Compare(sTemp, lTemp);

                output = Path.Combine(Path.GetTempPath(),
                    "Scienna_vs_Lauramac_CrossCheck_" + Guid.NewGuid().ToString("N") + ".xlsx");

                ExcelCrossCheckEngine.CreateOutputWorkbook(result, output);

                string token = Guid.NewGuid().ToString("N");
                Session["ExcelCrossCheck_" + token] = output;

                MessageHtml = Alert("success", "Comparison Completed");

                ResultHtml = BuildResultHtml(result, token);
            }
            finally
            {
                SafeDelete(sTemp);
                SafeDelete(lTemp);
            }
        }

        private static void ValidateUpload(HttpPostedFile file, string label)
        {
            if (file == null || file.ContentLength <= 0)
                throw new InvalidOperationException(label + " Excel file is required.");

            if (!string.Equals(Path.GetExtension(file.FileName), ".xlsx", StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException(label + " file must be .xlsx.");

            // Adjust if ERP has a different upload limit.
            const int maxBytes = 50 * 1024 * 1024;
            if (file.ContentLength > maxBytes)
                throw new InvalidOperationException(label + " file exceeds the 50 MB limit.");
        }

        private static string SaveTemp(HttpPostedFile file)
        {
            string path = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString("N") + ".xlsx");
            file.SaveAs(path);
            return path;
        }

        private void DownloadResult(string token)
        {
            if (string.IsNullOrWhiteSpace(token))
            {
                Response.StatusCode = 404;
                return;
            }

            string sessionKey = "ExcelCrossCheck_" + token;
            string path = Session[sessionKey] as string;

            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                Response.StatusCode = 404;
                Response.Write("Output file is no longer available. Please run the comparison again.");
                Response.End();
                return;
            }

            try
            {
                byte[] bytes = File.ReadAllBytes(path);
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition",
                    "attachment; filename=Scienna_vs_Lauramac_EntireScript_CrossCheck.xlsx");
                Response.AddHeader("Content-Length", bytes.Length.ToString());
                Response.BinaryWrite(bytes);
                Response.Flush();
            }
            finally
            {
                Session.Remove(sessionKey);
                SafeDelete(path);
            }

            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }

        private static string BuildResultHtml(CrossCheckResult result, string token)
        {
            var sb = new StringBuilder();
            sb.Append("<section class='erp-section-card p-3'>");
            sb.Append("<div class='ecc-stats'>");
            AddStat(sb, "Scienna fields", result.SciennaHeaderCount);
            AddStat(sb, "Lauramac fields", result.LauramacHeaderCount);
            AddStat(sb, "Common fields", result.CommonHeaderCount);
            AddStat(sb, "Scienna only", result.SciennaOnlyHeaders.Count);
            AddStat(sb, "Lauramac only", result.LauramacOnlyHeaders.Count);
            sb.Append("</div>");

            sb.Append("<div class='ecc-toolbar erp-modern-form'>");
            sb.Append("<div class='filter'><label>Status Filter</label><select id='statusFilter' class='form-control'>");
            sb.Append("<option value=''>All</option>");
            foreach (string status in result.Rows.Select(x => x.Status).Distinct().OrderBy(x => x))
            {
                sb.Append("<option value='").Append(H(status)).Append("'>").Append(H(status)).Append("</option>");
            }
            sb.Append("</select></div>");
            sb.Append("<a class='btn btn-success' href='ExcelCrossCheck.aspx?download=")
              .Append(HttpUtility.UrlEncode(token)).Append("'>Download Cross-Check Excel</a>");
            sb.Append("</div>");

            if (result.LauramacOnlyHeaders.Count > 0)
            {
                sb.Append("<p><b>Lauramac-only fields:</b> ")
                  .Append(H(string.Join(", ", result.LauramacOnlyHeaders))).Append("</p>");
            }

            sb.Append("<div class='erp-table-wrap'><table id='crossCheckTable' class='table table-bordered table-hover nowrap' style='width:100%'>");
            sb.Append("<thead><tr><th>#</th><th>Scienna Field</th><th>Scienna Value</th><th>In Lauramac?</th><th>Lauramac Value</th><th>Status</th><th>Issue Detail</th></tr></thead><tbody>");

            int n = 1;
            foreach (CrossCheckRow row in result.Rows)
            {
                sb.Append("<tr>");
                sb.Append("<td>").Append(n++).Append("</td>");
                sb.Append("<td>").Append(H(row.FieldName)).Append("</td>");
                sb.Append("<td>").Append(H(row.SciennaValue)).Append("</td>");
                sb.Append("<td>").Append(row.InLauramac ? "Yes" : "No").Append("</td>");
                sb.Append("<td>").Append(H(row.LauramacValue)).Append("</td>");
                sb.Append("<td>").Append(StatusBadge(row.Status)).Append("</td>");
                sb.Append("<td>").Append(H(row.IssueDetail)).Append("</td>");
                sb.Append("</tr>");
            }

            sb.Append("</tbody></table></div></section>");
            return sb.ToString();
        }

        private static void AddStat(StringBuilder sb, string label, int count)
        {
            sb.Append("<div class='ecc-stat'>").Append(H(label)).Append("<b>").Append(count).Append("</b></div>");
        }

        private static string StatusBadge(string status)
        {
            string css;
            switch (status)
            {
                case ExcelCrossCheckEngine.StatusMatch: css = "s-match"; break;
                case ExcelCrossCheckEngine.StatusBlank: css = "s-blank"; break;
                case ExcelCrossCheckEngine.StatusMissing: css = "s-missing"; break;
                case ExcelCrossCheckEngine.StatusNotReflecting: css = "s-notreflect"; break;
                case ExcelCrossCheckEngine.StatusExtra: css = "s-extra"; break;
                case ExcelCrossCheckEngine.StatusWrongType: css = "s-type"; break;
                case ExcelCrossCheckEngine.StatusFormat: css = "s-format"; break;
                default: css = "s-mismatch"; break;
            }

            return "<span class='badge " + css + "'>" + H(status) + "</span>";
        }

        private static string Alert(string type, string message)
        {
            return "<div class='alert alert-" + type + "'>" + message + "</div>";
        }

        private static string H(string value)
        {
            return HttpUtility.HtmlEncode(value ?? string.Empty);
        }

        private static void SafeDelete(string path)
        {
            try
            {
                if (!string.IsNullOrWhiteSpace(path) && File.Exists(path))
                    File.Delete(path);
            }
            catch { }
        }
    }
}
