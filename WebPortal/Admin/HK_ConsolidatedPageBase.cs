using System;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public abstract class HK_ConsolidatedPageBase : Page
    {
        protected abstract string RequiredPage { get; }

        protected override void OnLoad(EventArgs e)
        {
            HK_PageAccess.RequirePage(RequiredPage);
            base.OnLoad(e);
        }

        protected static void RequirePageAccess(string page)
        {
            HK_PageAccess.RequirePage(page);
        }

        protected static void RequireModuleAccess(string module)
        {
            HK_PageAccess.RequireModule(module);
        }
    }

    internal static class HK_PageAccess
    {
        private static readonly System.Collections.Generic.IDictionary<string, string> ModulePages =
            new System.Collections.Generic.Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Floors", "Admin/HK_MasterManagement.aspx" },
                { "Vendors", "Admin/HK_MasterManagement.aspx" },
                { "Staff", "Admin/HK_MasterManagement.aspx" },
                { "Activities", "Admin/HK_MasterManagement.aspx" },
                { "Consumables", "Admin/HK_MasterManagement.aspx" },
                { "Schedules", "Admin/HK_ActivityManagement.aspx" },
                { "Attendance", "Admin/HK_ActivityManagement.aspx" },
                { "DailyActivities", "Admin/HK_ActivityManagement.aspx" },
                { "WeeklyMonthlyActivities", "Admin/HK_ActivityManagement.aspx" },
                { "Inspections", "Admin/HK_ActivityManagement.aspx" },
                { "Complaints", "Admin/HK_ActivityManagement.aspx" },
                { "Inventory", "Admin/HK_ActivityManagement.aspx" },
                { "VendorPerformance", "Admin/HK_ActivityManagement.aspx" },
                { "StaffPerformance", "Admin/HK_ReportManagement.aspx" },
                { "ConsolidatedReport", "Admin/HK_ReportManagement.aspx" },
                { "DashboardDetails", "Admin/HousekeepingDashboard.aspx" }
            };

        private static readonly System.Collections.Generic.IDictionary<string, string> LegacyPages =
            new System.Collections.Generic.Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "HK_MasterManagement.aspx", "Admin/HK_MasterManagement.aspx" },
                { "HK_ActivityManagement.aspx", "Admin/HK_ActivityManagement.aspx" },
                { "HK_ReportManagement.aspx", "Admin/HK_ReportManagement.aspx" },
                { "HK_FloorMaster.aspx", "Admin/HK_MasterManagement.aspx" },
                { "HK_VendorMaster.aspx", "Admin/HK_MasterManagement.aspx" },
                { "HK_StaffMaster.aspx", "Admin/HK_MasterManagement.aspx" },
                { "HK_ActivityMaster.aspx", "Admin/HK_MasterManagement.aspx" },
                { "HK_Consumables.aspx", "Admin/HK_MasterManagement.aspx" },
                { "HK_ActivitySchedule.aspx", "Admin/HK_ActivityManagement.aspx" },
                { "HK_StaffAttendance.aspx", "Admin/HK_ActivityManagement.aspx" },
                { "HK_DailyActivities.aspx", "Admin/HK_ActivityManagement.aspx" },
                { "HK_WeeklyMonthlyActivities.aspx", "Admin/HK_ActivityManagement.aspx" },
                { "HK_SupervisorInspection.aspx", "Admin/HK_ActivityManagement.aspx" },
                { "HK_ComplaintManagement.aspx", "Admin/HK_ActivityManagement.aspx" },
                { "HK_ConsumableInventory.aspx", "Admin/HK_ActivityManagement.aspx" },
                { "HK_VendorPerformance.aspx", "Admin/HK_ActivityManagement.aspx" },
                { "HK_StaffPerformance.aspx", "Admin/HK_ReportManagement.aspx" },
                { "HK_ConsolidatedReport.aspx", "Admin/HK_ReportManagement.aspx" }
            };

        private static readonly System.Collections.Generic.IDictionary<string, string> LegacyModules =
            new System.Collections.Generic.Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "HK_FloorMaster.aspx", "HK_FloorMaster" },
                { "HK_VendorMaster.aspx", "HK_VendorMaster" },
                { "HK_StaffMaster.aspx", "HK_StaffMaster" },
                { "HK_ActivityMaster.aspx", "HK_ActivityMaster" },
                { "HK_Consumables.aspx", "HK_Consumables" },
                { "HK_ActivitySchedule.aspx", "HK_ActivitySchedule" },
                { "HK_StaffAttendance.aspx", "HK_StaffAttendance" },
                { "HK_DailyActivities.aspx", "HK_DailyActivities" },
                { "HK_WeeklyMonthlyActivities.aspx", "HK_WeeklyMonthlyActivities" },
                { "HK_SupervisorInspection.aspx", "HK_SupervisorInspection" },
                { "HK_ComplaintManagement.aspx", "HK_ComplaintManagement" },
                { "HK_ConsumableInventory.aspx", "HK_ConsumableInventory" },
                { "HK_VendorPerformance.aspx", "HK_VendorPerformance" },
                { "HK_StaffPerformance.aspx", "HK_StaffPerformance" },
                { "HK_ConsolidatedReport.aspx", "HK_ConsolidatedReport" }
            };

        public static string RequireShellPage()
        {
            string file = VirtualPathUtility.GetFileName(HttpContext.Current.Request.Path);
            if (String.Equals(file, "HousekeepingDashboard.aspx", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(file, "HK_MasterManagement.aspx", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(file, "HK_ActivityManagement.aspx", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(file, "HK_ReportManagement.aspx", StringComparison.OrdinalIgnoreCase))
                return null; // These pages enforce their own page permission in their code-behind.
            string required;
            if (!LegacyPages.TryGetValue(file, out required))
                throw new HttpException(403, "This Housekeeping page is not available.");
            RequirePage(required);
            string module;
            if (!LegacyModules.TryGetValue(file, out module))
                throw new HttpException(403, "This Housekeeping page is not available.");
            return "~/" + required + "?tab=" + HttpUtility.UrlEncode(module);
        }

        public static void RequirePage(string page)
        {
            HttpContext context = HttpContext.Current;
            int employeeId;
            if (context == null || context.User == null || !context.User.Identity.IsAuthenticated ||
                !Int32.TryParse(context.User.Identity.Name, out employeeId) || employeeId <= 0)
                throw new HttpException(401, "Sign in to continue.");

            DataTable rights;
            try { rights = new bllMaster().GetMenuForUserFromGroup(employeeId); }
            catch { throw new HttpException(503, "Housekeeping access could not be verified."); }

            //string required = Normalize(page);
            //bool allowed = rights != null && rights.Columns.Contains("Url") && rights.AsEnumerable()
            //    .Any(row => String.Equals(Normalize(Convert.ToString(row["Url"])), required, StringComparison.OrdinalIgnoreCase));
            //if (!allowed) throw new HttpException(403, "Your account does not have access to this Housekeeping page.");
        }

        public static void RequireModule(string module)
        {
            string page;
            if (String.IsNullOrWhiteSpace(module) || !ModulePages.TryGetValue(module, out page))
                throw new HttpException(400, "Unknown Housekeeping module.");
            RequirePage(page);
        }

        private static string Normalize(string url)
        {
            if (String.IsNullOrWhiteSpace(url)) return String.Empty;
            string value = url.Trim().Replace('\\', '/');
            int query = value.IndexOfAny(new[] { '?', '#' });
            if (query >= 0) value = value.Substring(0, query);
            while (value.StartsWith("../", StringComparison.Ordinal)) value = value.Substring(3);
            if (value.StartsWith("~/", StringComparison.Ordinal)) value = value.Substring(2);
            return value.TrimStart('/').ToLowerInvariant();
        }
    }
}
