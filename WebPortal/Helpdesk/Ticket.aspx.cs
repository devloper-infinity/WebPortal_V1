using System;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Helpdesk
{
    public partial class Ticket : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
        private static int EmployeeId { get { return Convert.ToInt32(HttpContext.Current.User.Identity.Name); } }

        [WebMethod]
        public static string GetTicket(int ticketId)
        {
            return HelpdeskJson.Serialize(new bllHelpdesk().GetTicket(ticketId, EmployeeId));
        }

        [WebMethod]
        public static int AddMessage(int ticketId, string message, bool isInternal)
        {
            return new bllHelpdesk().AddMessage(ticketId, EmployeeId, message, isInternal);
        }

        [WebMethod]
        public static int Transition(int ticketId, string nextStatus, string comment)
        {
            return new bllHelpdesk().Transition(ticketId, EmployeeId, nextStatus, comment);
        }

        [WebMethod]
        public static int DecideApproval(int ticketId, string decision, string comment)
        {
            return new bllHelpdesk().DecideApproval(ticketId, EmployeeId, decision, comment);
        }
    }
}
