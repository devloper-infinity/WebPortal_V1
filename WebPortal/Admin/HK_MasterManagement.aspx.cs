using System.Collections.Generic;
using System.Web.Services;
using System.Web.Script.Services;
using WebPortal.Admin;

namespace WebPortal.Admin
{
    public partial class HK_MasterManagement : HK_ConsolidatedPageBase
    {
        protected override string RequiredPage { get { return "Admin/HK_MasterManagement.aspx"; } }

        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static HousekeepingDashboard.Reply LoadModule(string module, string filtersJson)
        { RequireModuleAccess(module); return HousekeepingDashboard.LoadModule(module, filtersJson); }

        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static HousekeepingDashboard.Reply SaveModule(string module, string payloadJson)
        { RequireModuleAccess(module); return HousekeepingDashboard.SaveModule(module, payloadJson); }

        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static HousekeepingDashboard.Reply DeactivateModule(string module, int id)
        { RequireModuleAccess(module); return HousekeepingDashboard.DeactivateModule(module, id); }

        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static Dictionary<string, object> LoadLookups()
        { RequirePageAccess("Admin/HK_MasterManagement.aspx"); return HousekeepingDashboard.LoadLookupsData(); }

        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetEmpsByDept(int DepartmentID)
        { RequirePageAccess("Admin/HK_MasterManagement.aspx"); return HousekeepingDashboard.GetEmpsByDeptData(DepartmentID); }
    }
}
