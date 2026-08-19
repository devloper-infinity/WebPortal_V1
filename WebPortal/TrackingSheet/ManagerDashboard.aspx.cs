using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.Services;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;

namespace WebPortal.TrackingSheet
{
    public partial class ManagerDashboardPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { InitializeImportData(); }
        
        [WebMethod] 
        public static string GetProjects() { return OLTrackingWeb.Json(Projects()); }
       
        [WebMethod] 
        public static string GetProcesses(int projectId) { RequiredProject(projectId); return OLTrackingWeb.Json(Collect(projectId, delegate (bllOLTracking b, int id) { return b.GetConfiguredProcesses(id); }, "ProcessID")); }
       
        [WebMethod] 
        public static string GetUsers(int projectId) { RequiredProject(projectId); return OLTrackingWeb.Json(Collect(projectId, delegate (bllOLTracking b, int id) { return b.GetProjectUsers(id); }, "UserID")); }
       
        [WebMethod]
        public static string GetDeals(int projectId) { ProjectIds(projectId); return OLTrackingWeb.Json(new bllOLTracking().GetSourceDeals(projectId, OLTrackingWeb.UserId)); }
      
        [WebMethod] 
        public static string GetDealDashboard(int projectId, string dealNumber) { ProjectIds(projectId); return OLTrackingWeb.Json(new bllOLTracking().GetDealDashboard(projectId, dealNumber)); }
      
        [WebMethod]
        public static string GetHourlyProduction(int projectId, string reportDate, string dealNumber)
        {
            ProjectIds(projectId); DateTime date; if (!DateTime.TryParseExact(reportDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date)) date = DateTime.Today;
            return OLTrackingWeb.Json(new bllOLTracking().GetHourlyProduction(projectId, date, dealNumber));
        }

        [WebMethod] 
        public static string GetReallocationUsers(int projectId, string dealNumber, int processId) { ProjectIds(projectId); return OLTrackingWeb.Json(new bllOLTracking().GetReallocationUsers(projectId, dealNumber, processId)); }
        
        [WebMethod] 
        public static string GetReallocationOrders(int projectId, string dealNumber, int processId, int fromUserId) { ProjectIds(projectId); return OLTrackingWeb.Json(new bllOLTracking().GetReallocationOrders(projectId, dealNumber, processId, fromUserId)); }

        [WebMethod]
        public static ReallocationResult ReallocateOrders(int projectId, int fromUserId, int toUserId, long[] assignmentIds, string remark, bool confirmInProcess)
        {
            try
            {
                ProjectIds(projectId); int count = new bllOLTracking().ReallocateOrders(projectId, fromUserId, toUserId, assignmentIds, remark, confirmInProcess, OLTrackingWeb.UserId);
                return new ReallocationResult { Success = count > 0, ReallocatedCount = count, Message = count + " order(s) re-allocated successfully." };
            }
            catch (Exception ex)
            {
                SqlException sql = ex as SqlException; string message = sql != null && ((sql.Number >= 50110 && sql.Number <= 50136) || sql.Number == 50160) ? sql.Message : "The selected orders could not be re-allocated.";
                return new ReallocationResult { Success = false, Message = message };
            }
        }

        [WebMethod]
        public static string GetReport(int projectId, string dealNumber, int processId, int userId, string status, string productivityType, string fromDate, string toDate)
        {
            DateTime? from = Date(fromDate), to = Date(toDate); bllOLTracking tracking = new bllOLTracking();
            int[] ids = ProjectIds(projectId); DataTable summary = null, detail = null;
            foreach (int id in ids)
            {
                Append(ref summary, tracking.GetManagerSummary(id, dealNumber, processId, userId, productivityType, from, to));
                Append(ref detail, tracking.GetManagerDetail(id, dealNumber, processId, userId, status, productivityType, from, to));
            }
            DataSet set = new DataSet(); set.Tables.Add(summary ?? new DataTable()); set.Tables.Add(detail ?? new DataTable()); return OLTrackingWeb.Json(set);
        }

        [WebMethod]
        public static string GetSndDashboard(int projectId, string fromDate, string toDate)
        {
            ProjectIds(projectId);
            DateTime? from = Date(fromDate), to = Date(toDate);
            if (!from.HasValue || !to.HasValue || from.Value.Date > to.Value.Date)
                throw new ArgumentException("Please enter a valid date range.");
            if ((to.Value.Date - from.Value.Date).TotalDays > 366)
                throw new ArgumentException("The report date range cannot exceed 366 days.");
            return OLTrackingWeb.Json(new bllOLTracking().GetSndManagerDashboard(projectId, from.Value, to.Value));
        }

        [WebMethod] public static string GetHoldReasons() { return OLTrackingWeb.Json(new bllOLTracking().GetHoldReasons(true)); }

        [WebMethod]
        public static string SaveHoldReason(string reasonText)
        {
            string reason = (reasonText ?? string.Empty).Trim();
            if (reason.Length == 0 || reason.Length > 400) throw new ArgumentException("Enter a Hold Reason up to 400 characters.");
            return OLTrackingWeb.Ok(new bllOLTracking().SaveHoldReason(reason, OLTrackingWeb.UserId));
        }

        [WebMethod]
        public static string SetHoldReasonActive(int holdReasonId, bool isActive)
        {
            if (holdReasonId <= 0) throw new ArgumentException("Select a valid Hold Reason.");
            return OLTrackingWeb.Ok(new bllOLTracking().SetHoldReasonActive(holdReasonId, isActive, OLTrackingWeb.UserId));
        }

        [WebMethod]
        public static string GetLoanHoldCandidates(int projectId, string dealNumber)
        {
            ProjectIds(projectId);
            if (string.IsNullOrWhiteSpace(dealNumber)) throw new ArgumentException("Deal # is required.");
            return OLTrackingWeb.Json(new bllOLTracking().GetLoanHoldCandidates(projectId, dealNumber.Trim()));
        }

        [WebMethod]
        public static string GetHeldLoans(int projectId, string dealNumber)
        {
            ProjectIds(projectId);
            if (string.IsNullOrWhiteSpace(dealNumber)) throw new ArgumentException("Deal # is required.");
            return OLTrackingWeb.Json(new bllOLTracking().GetHeldLoans(projectId, dealNumber.Trim()));
        }

        [WebMethod]
        public static ManagerLoanHoldResult HoldLoans(int projectId, string dealNumber, long[] itemIds, string reason)
        {
            try
            {
                ProjectIds(projectId);
                if (string.IsNullOrWhiteSpace(dealNumber)) throw new ArgumentException("Deal # is required.");
                string cleanReason = (reason ?? string.Empty).Trim();
                if (cleanReason.Length == 0 || cleanReason.Length > 1000) throw new ArgumentException("Enter a Reason up to 1000 characters.");
                int count = new bllOLTracking().HoldLoans(projectId, dealNumber.Trim(), itemIds, cleanReason, OLTrackingWeb.UserId);
                return new ManagerLoanHoldResult { Success = count > 0, AffectedCount = count, Message = count + " loan(s) placed on HOLD." };
            }
            catch (Exception exception) { return LoanHoldFailure(exception); }
        }

        [WebMethod]
        public static ManagerLoanHoldResult ResumeHeldLoans(int projectId, string dealNumber, long[] itemIds)
        {
            try
            {
                ProjectIds(projectId);
                if (string.IsNullOrWhiteSpace(dealNumber)) throw new ArgumentException("Deal # is required.");
                int count = new bllOLTracking().ResumeLoans(projectId, dealNumber.Trim(), itemIds, OLTrackingWeb.UserId);
                return new ManagerLoanHoldResult { Success = count > 0, AffectedCount = count, Message = count + " loan(s) resumed." };
            }
            catch (Exception exception) { return LoanHoldFailure(exception); }
        }

        private static ManagerLoanHoldResult LoanHoldFailure(Exception exception)
        {
            SqlException sql = exception as SqlException;
            string message = exception is ArgumentException ? exception.Message :
                sql != null && sql.Number >= 50160 && sql.Number <= 50165 ? sql.Message :
                "The loan hold action could not be completed. Please refresh and try again.";
            return new ManagerLoanHoldResult { Success = false, Message = message };
        }
    
        private delegate DataTable Loader(bllOLTracking tracking, int projectId);
     
        private static DataTable Collect(int projectId, Loader loader, string key)
        {
            bllOLTracking tracking = new bllOLTracking(); DataTable result = null;
            foreach (int id in ProjectIds(projectId)) AppendUnique(ref result, loader(tracking, id), key);
            return result ?? new DataTable();
        }
      
        private static DataTable Projects() { return new bllOLTracking().GetProjectsByUser(OLTrackingWeb.UserId); }
       
        private static void RequiredProject(int projectId) { if (projectId <= 0) throw new ArgumentException("Project # is required."); }
      
        private static int[] ProjectIds(int selected)
        {
            List<int> ids = new List<int>(); foreach (DataRow row in Projects().Rows) { int id; if (int.TryParse(Convert.ToString(row["ProjectID"]), out id)) ids.Add(id); }
            if (selected != 0) { if (!ids.Contains(selected)) throw new UnauthorizedAccessException("Project access denied."); return new[] { selected }; }
            return ids.ToArray();
        }
      
        private static DateTime? Date(string value) { DateTime parsed; return DateTime.TryParseExact(value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed) ? parsed : (DateTime?)null; }
      
        private static void Append(ref DataTable target, DataTable source) { if (target == null) target = source.Clone(); foreach (DataRow row in source.Rows) target.ImportRow(row); }
      
        private static void AppendUnique(ref DataTable target, DataTable source, string key)
        {
            if (target == null) target = source.Clone(); HashSet<string> existing = new HashSet<string>(); foreach (DataRow row in target.Rows) existing.Add(Convert.ToString(row[key]));
            foreach (DataRow row in source.Rows) if (existing.Add(Convert.ToString(row[key]))) target.ImportRow(row);
        }
    }
    public sealed class ReallocationResult { public bool Success { get; set; } public int ReallocatedCount { get; set; } public string Message { get; set; } }
    public sealed class ManagerLoanHoldResult { public bool Success { get; set; } public int AffectedCount { get; set; } public string Message { get; set; } }
}
