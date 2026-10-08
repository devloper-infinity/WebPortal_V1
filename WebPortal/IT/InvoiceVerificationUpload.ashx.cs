using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using WebPortal.App_Code.BLL;

namespace WebPortal.IT
{
    public sealed class InvoiceVerificationUpload : IHttpHandler
    {
        public bool IsReusable { get { return false; } }

        public void ProcessRequest(HttpContext context)
        {
            if (context.User == null || context.User.Identity == null || !context.User.Identity.IsAuthenticated)
            {
                context.Response.StatusCode = 401;
                WriteJson(context, new { success = false, message = "Please sign in again." });
                return;
            }

            if (string.Equals(context.Request.HttpMethod, "GET", StringComparison.OrdinalIgnoreCase) && context.Request.QueryString["DocumentID"] != null)
            {
                Download(context);
                return;
            }
            if (!string.Equals(context.Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase))
            {
                context.Response.StatusCode = 405;
                return;
            }

            string origin = context.Request.Headers["Origin"];
            if (string.IsNullOrEmpty(origin))
            {
                Uri referer;
                if (Uri.TryCreate(context.Request.Headers["Referer"], UriKind.Absolute, out referer))
                    origin = referer.GetLeftPart(UriPartial.Authority);
            }
            if (!string.Equals(origin, context.Request.Url.GetLeftPart(UriPartial.Authority), StringComparison.OrdinalIgnoreCase))
            {
                context.Response.StatusCode = 403;
                WriteJson(context, new { success = false, message = "Request rejected." });
                return;
            }
            WriteJson(context, InvoiceVerification.SaveInvoiceMonthlyRequest(context));
        }

        private static void Download(HttpContext context)
        {
            int documentID;
            if (!int.TryParse(context.Request.QueryString["DocumentID"], out documentID) || documentID <= 0)
            {
                context.Response.StatusCode = 404;
                return;
            }
            DataTable document = new bllMaster().GetInvoiceDocument(documentID);
            if (document == null || document.Rows.Count == 0) { context.Response.StatusCode = 404; return; }
            string relativePath = Convert.ToString(document.Rows[0]["StoredPath"]);
            if (!relativePath.StartsWith("InvoiceDocuments/", StringComparison.OrdinalIgnoreCase) || relativePath.Contains("..") || relativePath.Contains("\\"))
            {
                context.Response.StatusCode = 404;
                return;
            }
            string root = Path.GetFullPath(context.Server.MapPath("~/App_Data/InvoiceDocuments"));
            string path = Path.GetFullPath(Path.Combine(context.Server.MapPath("~/App_Data"), relativePath.Replace('/', Path.DirectorySeparatorChar)));
            if (!path.StartsWith(root + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase) || !File.Exists(path))
            {
                context.Response.StatusCode = 404;
                return;
            }
            string name = Path.GetFileName(Convert.ToString(document.Rows[0]["StoredFileName"]));
            context.Response.Clear();
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetNoStore();
            context.Response.ContentType = "application/octet-stream";
            context.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + name.Replace("\"", "") + "\"");
            context.Response.TransmitFile(path);
        }

        private static void WriteJson(HttpContext context, object value)
        {
            context.Response.ContentType = "application/json; charset=utf-8";
            context.Response.Write(new JavaScriptSerializer().Serialize(value));
        }
    }
}
