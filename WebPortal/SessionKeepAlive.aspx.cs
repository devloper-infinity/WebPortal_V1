using System;
using System.Globalization;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace WebPortal
{
    public partial class SessionKeepAlive : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.ContentType = "application/json";
            Response.TrySkipIisCustomErrors = true;

            if (!string.Equals(Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase))
            {
                WriteError(405, "method_not_allowed");
                return;
            }

            bool hadSessionCookie = Request.Cookies["ASP.NET_SessionId"] != null;
            if (!Request.IsAuthenticated || (Session.IsNewSession && hadSessionCookie))
            {
                FormsAuthentication.SignOut();
                WriteError(401, "session_expired");
                return;
            }

            Session["WebPortalSessionKeepAliveUtc"] = DateTime.UtcNow;

            string json = string.Format(
                CultureInfo.InvariantCulture,
                "{{\"authenticated\":true,\"timeoutSeconds\":{0},\"serverUtc\":\"{1}\"}}",
                Session.Timeout * 60,
                DateTime.UtcNow.ToString("o", CultureInfo.InvariantCulture));

            Response.StatusCode = 200;
            Response.Write(json);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void WriteError(int statusCode, string errorCode)
        {
            Response.StatusCode = statusCode;
            Response.SuppressFormsAuthenticationRedirect = true;
            Response.Write("{\"authenticated\":false,\"error\":\"" + errorCode + "\"}");
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
