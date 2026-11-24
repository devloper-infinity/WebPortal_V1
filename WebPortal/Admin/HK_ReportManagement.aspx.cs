using System.Web.Services;
using System.Web.Script.Services;

namespace WebPortal.Admin
{
    public partial class HK_ReportManagement : HK_ConsolidatedPageBase
    {
        protected override string RequiredPage { get { return "Admin/HK_ReportManagement.aspx"; } }

        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static HousekeepingDashboard.Reply LoadModule(string module, string filtersJson)
        { RequireModuleAccess(module); return HousekeepingDashboard.LoadModule(module, filtersJson); }
    }
}
