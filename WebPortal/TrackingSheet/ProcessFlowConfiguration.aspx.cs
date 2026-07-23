using System;
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
        [WebMethod] public static string SaveFlow(int projectId, int processId, string processName, int stageNo, bool isMandatory, bool feedbackRequired, bool isFinalProcess)
        { new bllOLTracking().SaveProcessFlow(projectId, processId, processName, stageNo, isMandatory, feedbackRequired, isFinalProcess, OLTrackingWeb.UserId); return OLTrackingWeb.Ok(true); }
        [WebMethod] public static string RemoveFlow(int projectId, int processId)
        { return OLTrackingWeb.Ok(new bllOLTracking().RemoveProcessFlow(projectId, processId, OLTrackingWeb.UserId)); }
    }
}
