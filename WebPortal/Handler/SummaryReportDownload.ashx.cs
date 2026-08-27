using System;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Security;

namespace WebPortal.Handler
{
    public class SummaryReportDownload : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            if (context.User == null || context.User.Identity == null || !context.User.Identity.IsAuthenticated)
            {
                context.Response.StatusCode = 401;
                return;
            }

            try
            {
                string token = context.Request.QueryString["token"];
                byte[] protectedValue = HttpServerUtility.UrlTokenDecode(token);
                byte[] unprotectedValue = protectedValue == null ? null : MachineKey.Unprotect(protectedValue, "OSTSummaryAttachment");
                string path = unprotectedValue == null ? string.Empty : Encoding.UTF8.GetString(unprotectedValue);

                if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
                {
                    context.Response.StatusCode = 404;
                    context.Response.Write("The attachment could not be found.");
                    return;
                }

                string fileName = Path.GetFileName(path).Replace("\"", string.Empty);
                context.Response.Clear();
                context.Response.ContentType = MimeMapping.GetMimeMapping(fileName);
                context.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                context.Response.TransmitFile(path);
                context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception)
            {
                context.Response.StatusCode = 400;
                context.Response.Write("The attachment link is invalid or has expired.");
            }
        }

        public bool IsReusable { get { return false; } }
    }
}
