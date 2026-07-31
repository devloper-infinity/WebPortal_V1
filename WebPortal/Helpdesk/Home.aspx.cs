using System;
using System.Collections;
using System.Data;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Helpdesk
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        private static int EmployeeId { get { return Convert.ToInt32(HttpContext.Current.User.Identity.Name); } }

        [WebMethod]
        public static string GetBootstrap()
        {
            return HelpdeskJson.Serialize(new bllHelpdesk().GetBootstrap(EmployeeId));
        }

        [WebMethod]
        public static string GetMyTickets(string status)
        {
            return HelpdeskJson.Serialize(new bllHelpdesk().GetMyTickets(EmployeeId, status));
        }

        [WebMethod]
        public static int CreateTicket(int categoryId, string subject, string description, string location,
            string assetReference, string impact, string urgency, int onBehalfOfId)
        {
            Hashtable values = new Hashtable();
            values["RequesterID"] = EmployeeId;
            values["OnBehalfOfID"] = onBehalfOfId;
            values["CategoryID"] = categoryId;
            values["Subject"] = subject;
            values["Description"] = description;
            values["Location"] = location;
            values["AssetReference"] = assetReference;
            values["ImpactCode"] = impact;
            values["UrgencyCode"] = urgency;
            values["ManagerApproverID"] = GetManagerId(EmployeeId);
            return new bllHelpdesk().CreateTicket(values);
        }

        private static int GetManagerId(int employeeId)
        {
            DataTable employee = new bllLogin().GetUserInformation(employeeId);
            if (employee == null || employee.Rows.Count == 0) return 0;
            string[] columns = { "ReportingManagerID", "ReportingManagerId", "ProjectManager", "ManagerID" };
            foreach (string column in columns)
            {
                if (!employee.Columns.Contains(column)) continue;
                int managerId;
                if (Int32.TryParse(Convert.ToString(employee.Rows[0][column]), out managerId)) return managerId;
            }
            return 0;
        }
    }
}
