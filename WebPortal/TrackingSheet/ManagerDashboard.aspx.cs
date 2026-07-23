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
        public static string GetProcesses(int projectId) { RequiredProject(projectId); return OLTrackingWeb.Json(Collect(projectId, delegate (bllOLTracking b, int id) { return b.GetProcessFlow(id); }, "ProcessID")); }
       
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
                SqlException sql = ex as SqlException; string message = sql != null && sql.Number >= 50110 && sql.Number <= 50136 ? sql.Message : "The selected orders could not be re-allocated.";
                return new ReallocationResult { Success = false, Message = message };
            }
        }

        [WebMethod]
        public static string GetReport(int projectId, int processId, int userId, string status, string fromDate, string toDate)
        {
            RequiredProject(projectId); DateTime? from = Date(fromDate), to = Date(toDate); bllOLTracking tracking = new bllOLTracking();
            int[] ids = ProjectIds(projectId); DataTable summary = null, detail = null;
            foreach (int id in ids)
            {
                Append(ref summary, tracking.GetManagerSummary(id, processId, userId, from, to));
                Append(ref detail, tracking.GetManagerDetail(id, processId, userId, status, from, to));
            }
            DataSet set = new DataSet(); set.Tables.Add(summary ?? new DataTable()); set.Tables.Add(detail ?? new DataTable()); return OLTrackingWeb.Json(set);
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
}
