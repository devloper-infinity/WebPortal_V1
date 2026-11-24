using System;
using System.Data;
using System.Web.Services;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.TrackingSheet
{
    public partial class ProcessFlowConfiguration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool allowed = HasContextAccess();
            processDealTab.Visible = allowed; processDealFlowPanel.Visible = allowed;
        }
        [WebMethod] public static string GetProjects() { return OLTrackingWeb.Json(new bllOLTracking().GetProjects()); }
        [WebMethod] public static string GetProcesses(int projectId) { return OLTrackingWeb.Json(new bllOLTracking().GetProcesses(projectId)); }
        [WebMethod] public static string GetFlow(int projectId) { return OLTrackingWeb.Json(new bllOLTracking().GetProcessFlow(projectId)); }
        [WebMethod] public static string GetDeals(int projectId) { return OLTrackingWeb.Json(new bllOLTracking().GetSourceDeals(projectId, OLTrackingWeb.UserId)); }
        [WebMethod] public static string GetCanopyProjects() { RequireContextAccess(); return OLTrackingWeb.Json(new bllOLTracking().GetCanopyProjects()); }
        [WebMethod] public static string GetContextDealFlow(int projectId, string configurationProcess, string dealNumber) { RequireContextAccess(); ValidateContextProject(projectId); ValidateContext(configurationProcess); return OLTrackingWeb.Json(new bllOLTracking().GetProcessDealFlow(projectId, configurationProcess, dealNumber)); }
        [WebMethod] public static string GetDealFlow(int projectId, string dealNumber) { return OLTrackingWeb.Json(new bllOLTracking().GetDealProcessFlow(projectId, dealNumber)); }
        [WebMethod] public static string SaveFlow(int projectId, int processId, string processName, int stageNo, bool isMandatory, bool feedbackRequired, bool isFinalProcess, bool isTrackingSheetProcess, string productivityType, int expectedCompletionMinutes, int? minCompletionMinutes, int? maxCompletionMinutes, int[] eligibleAfterProcessIds, int[] feedbackAgainstProcessIds)
        { ValidateConfiguration(productivityType, minCompletionMinutes, maxCompletionMinutes); new bllOLTracking().SaveProcessFlow(projectId, processId, processName, stageNo, isMandatory, feedbackRequired, isFinalProcess, isTrackingSheetProcess, productivityType, expectedCompletionMinutes, minCompletionMinutes, maxCompletionMinutes, eligibleAfterProcessIds, feedbackAgainstProcessIds, OLTrackingWeb.UserId); return OLTrackingWeb.Ok(true); }
        [WebMethod] public static string RemoveFlow(int projectId, int processId)
        { return OLTrackingWeb.Ok(new bllOLTracking().RemoveProcessFlow(projectId, processId, OLTrackingWeb.UserId)); }
        [WebMethod] public static string SaveDealFlow(int projectId, string dealNumber, int processId, string processName, int stageNo, bool isMandatory, bool feedbackRequired, bool isFinalProcess, string productivityType, int expectedCompletionMinutes, int? minCompletionMinutes, int? maxCompletionMinutes, bool isOutOfScope)
        {
            ValidateConfiguration(productivityType, minCompletionMinutes, maxCompletionMinutes);
            bllOLTracking tracking = new bllOLTracking();
            DataTable existingFlow = tracking.GetDealProcessFlow(projectId, dealNumber);
            System.Collections.Generic.HashSet<int> existingProcessIds = new System.Collections.Generic.HashSet<int>();
            foreach (DataRow row in existingFlow.Rows) existingProcessIds.Add(Convert.ToInt32(row["ProcessID"]));

            foreach (DataRow projectRow in tracking.GetProcessFlow(projectId).Rows)
            {
                int projectProcessId = Convert.ToInt32(projectRow["ProcessID"]);
                if (projectProcessId == processId || existingProcessIds.Contains(projectProcessId)) continue;
                tracking.SaveDealProcessFlow(projectId, dealNumber, projectProcessId, Convert.ToString(projectRow["ProcessName"]),
                    Convert.ToInt32(projectRow["StageNo"]), Convert.ToBoolean(projectRow["IsMandatory"]),
                    Convert.ToBoolean(projectRow["FeedbackRequiredOnComplete"]), Convert.ToBoolean(projectRow["IsFinalProcess"]),
                    Convert.ToString(projectRow["ProductivityType"]), Convert.ToInt32(projectRow["ExpectedCompletionMinutes"]),
                    projectRow["MinCompletionMinutes"] == DBNull.Value ? (int?)null : Convert.ToInt32(projectRow["MinCompletionMinutes"]),
                    projectRow["MaxCompletionMinutes"] == DBNull.Value ? (int?)null : Convert.ToInt32(projectRow["MaxCompletionMinutes"]),
                    false,
                    OLTrackingWeb.UserId);
            }

            tracking.SaveDealProcessFlow(projectId, dealNumber, processId, processName, stageNo, isMandatory,
                feedbackRequired, isFinalProcess, productivityType, expectedCompletionMinutes, minCompletionMinutes, maxCompletionMinutes, isOutOfScope, OLTrackingWeb.UserId);
            return OLTrackingWeb.Ok(true);
        }
        [WebMethod] public static string RemoveDealFlow(int projectId, string dealNumber, int processId)
        { return OLTrackingWeb.Ok(new bllOLTracking().RemoveDealProcessFlow(projectId, dealNumber, processId, OLTrackingWeb.UserId)); }
        [WebMethod] public static string SaveContextDealFlow(int projectId, string configurationProcess, string dealNumber, int processId, string processName, int stageNo, bool isMandatory, bool feedbackRequired, bool isFinalProcess, string productivityType, int expectedCompletionMinutes, int? minCompletionMinutes, int? maxCompletionMinutes, bool isOutOfScope)
        { RequireContextAccess(); ValidateContextProject(projectId); ValidateContext(configurationProcess); ValidateConfiguration(productivityType, minCompletionMinutes, maxCompletionMinutes); new bllOLTracking().SaveProcessDealFlow(projectId, configurationProcess, dealNumber, processId, processName, stageNo, isMandatory, feedbackRequired, isFinalProcess, productivityType, expectedCompletionMinutes, minCompletionMinutes, maxCompletionMinutes, isOutOfScope, OLTrackingWeb.UserId); return OLTrackingWeb.Ok(true); }
        [WebMethod] public static string RemoveContextDealFlow(int projectId, string configurationProcess, string dealNumber, int processId)
        { RequireContextAccess(); ValidateContextProject(projectId); ValidateContext(configurationProcess); return OLTrackingWeb.Ok(new bllOLTracking().RemoveProcessDealFlow(projectId, configurationProcess, dealNumber, processId, OLTrackingWeb.UserId)); }
        private static void RequireContextAccess() { if (!HasContextAccess()) throw new UnauthorizedAccessException("Credit manager access is required."); }
        private static bool HasContextAccess()
        {
            EmployeeInfo employee = EmployeeInfo.Current;
            string manager = (employee.IsPM ?? string.Empty).Trim();
            return string.Equals((employee.SubDomain ?? string.Empty).Trim(), "Credit", StringComparison.OrdinalIgnoreCase)
                && (manager == "1" || manager.Equals("true", StringComparison.OrdinalIgnoreCase) || manager.Equals("yes", StringComparison.OrdinalIgnoreCase) || manager.Equals("y", StringComparison.OrdinalIgnoreCase));
        }
        private static void ValidateContextProject(int projectId) { if (!new bllOLTracking().IsCanopyProject(projectId)) throw new UnauthorizedAccessException("Only Canopy projects are allowed."); }
        private static void ValidateContext(string value) { if (value != "Pre Close Review" && value != "Post Close Review") throw new ArgumentException("Invalid process selection."); }
        private static void ValidateConfiguration(string productivityType, int? minCompletionMinutes, int? maxCompletionMinutes)
        {
            if (productivityType != "Hourly Productivity" && productivityType != "Loan Based Productivity") throw new ArgumentException("Please select a valid Productivity Type.");
            if (minCompletionMinutes < 0 || maxCompletionMinutes < 0) throw new ArgumentException("Min and Max Completion Minutes must be 0 or greater.");
            if (minCompletionMinutes.HasValue && maxCompletionMinutes.HasValue && maxCompletionMinutes.Value < minCompletionMinutes.Value)
                throw new ArgumentException("Maximum completion time cannot be less than the minimum completion time.");
        }
    }
}
