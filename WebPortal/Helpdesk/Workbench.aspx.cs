using System;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Helpdesk
{
    public partial class Workbench : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
        private static int EmployeeId { get { return Convert.ToInt32(HttpContext.Current.User.Identity.Name); } }

        [WebMethod]
        public static string GetQueue(string scope, string status, string priority)
        {
            return HelpdeskJson.Serialize(new bllHelpdesk().GetQueue(EmployeeId, scope, status, priority));
        }

        [WebMethod]
        public static string GetAgents()
        {
            return HelpdeskJson.Serialize(new bllHelpdesk().GetAgents(EmployeeId));
        }

        [WebMethod]
        public static int Assign(int ticketId, int agentEmployeeId)
        {
            return new bllHelpdesk().Assign(ticketId, agentEmployeeId, EmployeeId);
        }
    }
}
