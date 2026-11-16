using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.Script.Serialization;
using System.Web.UI.HtmlControls;
using WebPortal.App_Code.Class;
using WebPortal.App_Code;
using WebPortal.App_Code.DAL;

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
                    path.StartsWith("~/Admin/ProjectBillingDetails.aspx", StringComparison.OrdinalIgnoreCase) ||
                    path.Equals("~/SessionKeepAlive.aspx", StringComparison.OrdinalIgnoreCase) ||
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
            catch (System.Threading.ThreadAbortException)
            {
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                if (ex.Number != 208) throw; /* schema is deployed separately; fail open until deployment */
            }
        }

        protected void Application_PreRequestHandlerExecute(object sender, EventArgs e)
        {
            Page page = Context.CurrentHandler as Page;
            if (page != null)
            {
                page.PreRender += ApplyScriptVersions;
                page.PreRender += ShowMissingChannelAlert;
                page.PreRender += AddChatWidget;
            }
        }

        private static void AddChatWidget(object sender, EventArgs e)
        {
            Page page = sender as Page; HttpContext context = HttpContext.Current;
            string chatPath = context == null ? "" : (context.Request.AppRelativeCurrentExecutionFilePath ?? "");
            if (page == null || context == null || context.User == null || !context.User.Identity.IsAuthenticated ||
                chatPath.StartsWith("~/US/", StringComparison.OrdinalIgnoreCase) ||
                chatPath.Equals("~/Chat/Chat.aspx", StringComparison.OrdinalIgnoreCase)) return;
            if (page.Header != null)
            {
                var css = new HtmlLink(); css.Href = page.ResolveUrl("~/Chat/Chat.css"); css.Attributes["rel"] = "stylesheet"; page.Header.Controls.Add(css);
                var groupCss = new HtmlLink(); groupCss.Href = page.ResolveUrl("~/Chat/ChatGroup.css"); groupCss.Attributes["rel"] = "stylesheet"; page.Header.Controls.Add(groupCss);
            }
            page.ClientScript.RegisterClientScriptInclude("InfinitySignalR", page.ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js"));
            page.ClientScript.RegisterClientScriptInclude("InfinitySignalRHubs", page.ResolveUrl("~/signalr/hubs"));
            page.ClientScript.RegisterClientScriptInclude("InfinityChat", page.ResolveUrl("~/Chat/Chat.js"));
            page.ClientScript.RegisterStartupScript(page.GetType(), "InfinityChatStart", "if(window.InfinityChat){InfinityChat.mount({full:false});}", true);
        }

        private static void ShowMissingChannelAlert(object sender, EventArgs e)
        {
            Page page = sender as Page;
            HttpContext context = HttpContext.Current;
            if (page == null || context == null || context.User == null || !context.User.Identity.IsAuthenticated ||
                !String.Equals(context.User.Identity.Name, "277", StringComparison.Ordinal) ||
                context.Session["Project561ChannelAlertChecked"] != null) return;

            context.Session["Project561ChannelAlertChecked"] = true;
            try
            {
                List<string> missing = new ChannelMasterAlertRepository().MissingChannels(561);
                if (missing.Count == 0) return;
                string message = "Project 561: The following Channel values are missing from InfinityBilling Channel Master:\n\n- " + String.Join("\n- ", missing.ToArray()) + "\n\nPlease add them to the Channel Master.";
                string serialized = new JavaScriptSerializer().Serialize(message);
                page.ClientScript.RegisterStartupScript(page.GetType(), "Project561MissingChannels", "window.setTimeout(function(){window.alert(" + serialized + ");},0);", true);
            }
            catch (SqlException)
            {
                // A notification lookup must never block ERP login.
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
