using System;
using System.Data;
using System.Web.Services;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;

namespace WebPortal.TrackingSheet
{
    public partial class ProcessFlowConfiguration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
        [WebMethod] public static string GetProjects() { return OLTrackingWeb.Json(new bllOLTracking().GetProjects()); }
        [WebMethod] public static string GetProcesses(int projectId) { return OLTrackingWeb.Json(new bllOLTracking().GetProcesses(projectId)); }
        [WebMethod] public static string GetFlow(int projectId) { return OLTrackingWeb.Json(new bllOLTracking().GetProcessFlow(projectId)); }
        [WebMethod] public static string GetDeals(int projectId) { return OLTrackingWeb.Json(new bllOLTracking().GetSourceDeals(projectId, OLTrackingWeb.UserId)); }
        [WebMethod] public static string GetDealFlow(int projectId, string dealNumber) { return OLTrackingWeb.Json(new bllOLTracking().GetDealProcessFlow(projectId, dealNumber)); }
        [WebMethod] public static string SaveFlow(int projectId, int processId, string processName, int stageNo, bool isMandatory, bool feedbackRequired, bool isFinalProcess, bool isTrackingSheetProcess, string productivityType, int expectedCompletionMinutes, int[] eligibleAfterProcessIds, int[] feedbackAgainstProcessIds)
        { ValidateProductivity(productivityType, expectedCompletionMinutes); new bllOLTracking().SaveProcessFlow(projectId, processId, processName, stageNo, isMandatory, feedbackRequired, isFinalProcess, isTrackingSheetProcess, productivityType, expectedCompletionMinutes, eligibleAfterProcessIds, feedbackAgainstProcessIds, OLTrackingWeb.UserId); return OLTrackingWeb.Ok(true); }
        [WebMethod] public static string RemoveFlow(int projectId, int processId)
        { return OLTrackingWeb.Ok(new bllOLTracking().RemoveProcessFlow(projectId, processId, OLTrackingWeb.UserId)); }
        [WebMethod] public static string SaveDealFlow(int projectId, string dealNumber, int processId, string processName, int stageNo, bool isMandatory, bool feedbackRequired, bool isFinalProcess, string productivityType, int expectedCompletionMinutes)
        {
            ValidateProductivity(productivityType, expectedCompletionMinutes);
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
                    OLTrackingWeb.UserId);
            }

            tracking.SaveDealProcessFlow(projectId, dealNumber, processId, processName, stageNo, isMandatory,
                feedbackRequired, isFinalProcess, productivityType, expectedCompletionMinutes, OLTrackingWeb.UserId);
            return OLTrackingWeb.Ok(true);
        }
        [WebMethod] public static string RemoveDealFlow(int projectId, string dealNumber, int processId)
        { return OLTrackingWeb.Ok(new bllOLTracking().RemoveDealProcessFlow(projectId, dealNumber, processId, OLTrackingWeb.UserId)); }
        private static void ValidateProductivity(string productivityType, int expectedCompletionMinutes)
        {
            if (productivityType != "Hourly Productivity" && productivityType != "Loan Based Productivity") throw new ArgumentException("Please select a valid Productivity Type.");
        }
    }
}
