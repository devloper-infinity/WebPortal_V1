using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;
using WebPortal.App_Code.Class;
using WebPortal.App_Code;

namespace WebPortal
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {

        }

        protected void Session_Start(object sender, EventArgs e)
        {
            
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            string IPAddr = Context.Request.ServerVariables["REMOTE_ADDR"];

            if (IPAddr == null || IPAddr.Length == 0)
            {
                return;
            }
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {
            if (HttpContext.Current.User != null)
            {
                if (HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    if (HttpContext.Current.User.Identity is FormsIdentity)
                    {
                        FormsIdentity id =
                            (FormsIdentity)HttpContext.Current.User.Identity;
                        FormsAuthenticationTicket ticket = id.Ticket;
                        string userData = ticket.UserData;
                        string[] roles = userData.Split(',');
                        HttpContext.Current.User = new System.Security.Principal.GenericPrincipal(id, roles);
                    }
                }
            }
        }

        protected void Application_AuthorizeRequest(object sender, EventArgs e)
        {
            // Pending project data is a global ERP gate; enforcing it here also covers manually-entered URLs.
            try
            {
                if (Context.User != null && Context.User.Identity.IsAuthenticated)
                {
                    int employeeId;
                    string path = Context.Request.AppRelativeCurrentExecutionFilePath ?? String.Empty;
                    string extension = VirtualPathUtility.GetExtension(path) ?? String.Empty;
                    bool publicPath = path.StartsWith("~/Admin/PendingData.aspx", StringComparison.OrdinalIgnoreCase) ||
                                      path.Equals("~/Logout.aspx", StringComparison.OrdinalIgnoreCase) ||
                                      path.Equals("~/LogoutNew.aspx", StringComparison.OrdinalIgnoreCase) ||
                                      path.Equals("~/Login.aspx", StringComparison.OrdinalIgnoreCase) ||
                                      path.Equals("~/LoginNew.aspx", StringComparison.OrdinalIgnoreCase) ||
                                      extension.Equals(".css", StringComparison.OrdinalIgnoreCase) ||
                                      extension.Equals(".js", StringComparison.OrdinalIgnoreCase) ||
                                      extension.Equals(".png", StringComparison.OrdinalIgnoreCase) ||
                                      extension.Equals(".jpg", StringComparison.OrdinalIgnoreCase) ||
                                      extension.Equals(".jpeg", StringComparison.OrdinalIgnoreCase) ||
                                      extension.Equals(".gif", StringComparison.OrdinalIgnoreCase) ||
                                      extension.Equals(".svg", StringComparison.OrdinalIgnoreCase) ||
                                      extension.Equals(".woff", StringComparison.OrdinalIgnoreCase) ||
                                      extension.Equals(".woff2", StringComparison.OrdinalIgnoreCase) ||
                                      path.EndsWith("WebResource.axd", StringComparison.OrdinalIgnoreCase) ||
                                      path.EndsWith("ScriptResource.axd", StringComparison.OrdinalIgnoreCase);
                    if (!publicPath && Int32.TryParse(Context.User.Identity.Name, out employeeId) && new PendingDataRepository().HasPending(employeeId))
                    {
                        if (Context.Request.HttpMethod.Equals("GET", StringComparison.OrdinalIgnoreCase))
                            Context.Response.Redirect("~/Admin/PendingData.aspx", false);
                        else { Context.Response.StatusCode = 403; Context.Response.TrySkipIisCustomErrors = true; }
                        Context.ApplicationInstance.CompleteRequest();
                        return;
                    }
                }
            }
            catch (System.Data.SqlClient.SqlException ex) when (ex.Number == 208 || ex.Number == 2812) { /* fail open until the deployment script is applied */ }

            // Mandatory RNR feedback is enforced centrally so direct page/API URLs cannot bypass it.
            try
            {
                if (Context.User == null || !Context.User.Identity.IsAuthenticated) return;
                int employeeId;
                if (!Int32.TryParse(Context.User.Identity.Name, out employeeId)) return;
                string path = Context.Request.AppRelativeCurrentExecutionFilePath ?? String.Empty;
                string extension = VirtualPathUtility.GetExtension(path) ?? String.Empty;
                if (path.Equals("~/Admin/RNRFeedback.aspx", StringComparison.OrdinalIgnoreCase) ||
                    path.StartsWith("~/Admin/PendingData.aspx", StringComparison.OrdinalIgnoreCase) ||
                    path.Equals("~/Logout.aspx", StringComparison.OrdinalIgnoreCase) ||
                    path.Equals("~/LogoutNew.aspx", StringComparison.OrdinalIgnoreCase) ||
                    path.Equals("~/Login.aspx", StringComparison.OrdinalIgnoreCase) ||
                    path.Equals("~/LoginNew.aspx", StringComparison.OrdinalIgnoreCase) ||
                    extension.Equals(".css", StringComparison.OrdinalIgnoreCase) ||
                    extension.Equals(".js", StringComparison.OrdinalIgnoreCase) ||
                    extension.Equals(".png", StringComparison.OrdinalIgnoreCase) ||
                    extension.Equals(".jpg", StringComparison.OrdinalIgnoreCase) ||
                    extension.Equals(".jpeg", StringComparison.OrdinalIgnoreCase) ||
                    extension.Equals(".gif", StringComparison.OrdinalIgnoreCase) ||
                    extension.Equals(".svg", StringComparison.OrdinalIgnoreCase) ||
                    extension.Equals(".woff", StringComparison.OrdinalIgnoreCase) ||
                    extension.Equals(".woff2", StringComparison.OrdinalIgnoreCase) ||
                    path.EndsWith("WebResource.axd", StringComparison.OrdinalIgnoreCase) ||
                    path.EndsWith("ScriptResource.axd", StringComparison.OrdinalIgnoreCase)) return;
                long pending = new RnrFeedbackRepository().PendingAssignment(employeeId);
                if (pending == 0) return;
                if (Context.Request.HttpMethod.Equals("GET", StringComparison.OrdinalIgnoreCase))
                    Context.Response.Redirect("~/Admin/RNRFeedback.aspx", false);
                else { Context.Response.StatusCode = 403; Context.Response.TrySkipIisCustomErrors = true; Context.Response.End(); }
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (System.Threading.ThreadAbortException) { }
            catch (System.Data.SqlClient.SqlException ex) when (ex.Number == 208) { /* schema is deployed separately; fail open until deployment */ }
        }

        protected void Application_PreRequestHandlerExecute(object sender, EventArgs e)
        {
            Page page = Context.CurrentHandler as Page;
            if (page != null)
            {
                page.PreRender += ApplyScriptVersions;
            }
        }

        private static void ApplyScriptVersions(object sender, EventArgs e)
        {
            Page page = sender as Page;
            if (page != null)
            {
                AssetVersion.ApplyTo(ScriptManager.GetCurrent(page));
            }
        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}
