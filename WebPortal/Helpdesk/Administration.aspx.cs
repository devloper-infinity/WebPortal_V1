using System;
using System.Collections;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Helpdesk
{
    public partial class Administration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
        private static int EmployeeId { get { return Convert.ToInt32(HttpContext.Current.User.Identity.Name); } }

        [WebMethod]
        public static string GetConfiguration()
        {
            return HelpdeskJson.Serialize(new bllHelpdesk().GetAdministration(EmployeeId));
        }

        [WebMethod]
        public static int SaveCategory(int categoryId, string categoryName, int departmentId, string departmentName,
            string defaultPriority, string approvalMode, int defaultApproverId, bool isActive)
        {
            Hashtable values = new Hashtable {
                {"EmployeeID",EmployeeId},{"CategoryID",categoryId},{"CategoryName",categoryName},
                {"DepartmentID",departmentId},{"DepartmentName",departmentName},{"DefaultPriority",defaultPriority},
                {"ApprovalMode",approvalMode},{"DefaultApproverID",defaultApproverId},{"IsActive",isActive}
            };
            return new bllHelpdesk().SaveCategory(values);
        }

        [WebMethod]
        public static int SaveSla(int slaPolicyId, string policyName, string priorityCode,
            int firstResponseMins, int resolutionMins, bool isActive)
        {
            Hashtable values = new Hashtable {
                {"EmployeeID",EmployeeId},{"SlaPolicyID",slaPolicyId},{"PolicyName",policyName},
                {"PriorityCode",priorityCode},{"FirstResponseMins",firstResponseMins},
                {"ResolutionMins",resolutionMins},{"IsActive",isActive}
            };
            return new bllHelpdesk().SaveSla(values);
        }

        [WebMethod]
        public static int SaveAgent(int agentId, int agentEmployeeId, string displayName,
            int departmentId, string roleCode, bool isActive)
        {
            Hashtable values = new Hashtable {
                {"EmployeeID",EmployeeId},{"AgentID",agentId},{"AgentEmployeeID",agentEmployeeId},
                {"DisplayName",displayName},{"DepartmentID",departmentId},{"RoleCode",roleCode},{"IsActive",isActive}
            };
            return new bllHelpdesk().SaveAgent(values);
        }
    }
}
