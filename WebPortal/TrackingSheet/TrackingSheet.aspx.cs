using System;
using System.Globalization;
using System.Web.Services;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;

namespace WebPortal.TrackingSheet
{
    public partial class TrackingSheetPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
        [WebMethod] public static string GetProjects() { return OLTrackingWeb.Json(new bllOLTracking().GetProjectsByUser(OLTrackingWeb.UserId)); }
        [WebMethod] public static string GetDeals(int projectId) { return OLTrackingWeb.Json(new bllOLTracking().GetSourceDeals(projectId, OLTrackingWeb.UserId)); }
        [WebMethod] public static string GetFlow(int projectId) { return OLTrackingWeb.Json(new bllOLTracking().GetProcessFlow(projectId)); }
        [WebMethod] public static string GetAvailableLoan(int projectId, string dealNumber, int processId, string processName)
        { return OLTrackingWeb.Json(new bllOLTracking().GetAvailableLoan(projectId, dealNumber, processId, processName, OLTrackingWeb.UserId)); }
        [WebMethod] public static string Allocate(int projectId, int processId, string loanNumber, string dealNumber)
        { return OLTrackingWeb.Ok(new bllOLTracking().AllocateLoan(projectId, processId, loanNumber, dealNumber, OLTrackingWeb.UserId)); }
        [WebMethod] public static string GetQueue() { return OLTrackingWeb.Json(new bllOLTracking().GetTrackingQueue(OLTrackingWeb.UserId)); }
        [WebMethod] public static string GetDailyProcesses() { return OLTrackingWeb.Json(new bllOLTracking().GetUserDailyProcesses(OLTrackingWeb.UserId)); }
        [WebMethod] public static string StartLoan(long assignmentId)
        { new bllOLTracking().StartLoan(assignmentId, OLTrackingWeb.UserId); return OLTrackingWeb.Ok(true); }
        [WebMethod] public static string CompleteLoan(long assignmentId, string remark, string[] feedbacks)
        { new bllOLTracking().CompleteLoan(assignmentId, remark, feedbacks, OLTrackingWeb.UserId); return OLTrackingWeb.Ok(true); }
        [WebMethod] public static string GetDailyStatus(int processId, string fromDate, string toDate)
        {
            DateTime parsed; DateTime? from = DateTime.TryParseExact(fromDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed) ? parsed : (DateTime?)null;
            DateTime? to = DateTime.TryParseExact(toDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed) ? parsed : (DateTime?)null;
            return OLTrackingWeb.Json(new bllOLTracking().GetUserDailyStatus(OLTrackingWeb.UserId, processId, from, to));
        }
    }
}
