using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Tracking
{
    public partial class TodaySatus : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static TrackingListResponse GetProjects()
        {
            try
            {
                DataTable dt = new bllTracking().GetAllProjectByUserRights_ForAddFeedback(Convert.ToString(CurrentEmployeeId()));
                return TrackingListResponse.Ok(ToRows(dt));
            }
            catch (Exception ex)
            {
                return TrackingListResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static TrackingListResponse GetProcesses(int projectId)
        {
            try
            {
                DataTable dt = new bllTracking().getProcess(projectId);
                return TrackingListResponse.Ok(ToRows(dt));
            }
            catch (Exception ex)
            {
                return TrackingListResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static TrackingListResponse GetTodayStatus(TodayStatusRequest request)
        {
            try
            {
                if (request == null)
                    request = new TodayStatusRequest();

                bllTracking tracking = new bllTracking();
                string status = Clean(request.Status);
                string process = Clean(request.Process);
                string dealNo = Clean(request.DealNo);
                string fromDate = Clean(request.FromDate);
                string toDate = Clean(request.ToDate);
                string currentCode = CurrentUserCode();
                DataTable dt;

                if (string.Equals(status, "DPending", StringComparison.OrdinalIgnoreCase))
                {
                    if (string.IsNullOrWhiteSpace(process) || string.IsNullOrWhiteSpace(dealNo))
                        return TrackingListResponse.Fail("Please enter Process and Deal No for Dashboard Pending.");

                    dt = tracking.GetProcessDashbordDealPending(dealNo, process);
                }
                else if (!string.IsNullOrWhiteSpace(process) && !string.IsNullOrWhiteSpace(dealNo))
                {
                    if (string.Equals(status, "Completed", StringComparison.OrdinalIgnoreCase))
                        dt = tracking.GetProcessDetailsForFeedbackUserCompleted_New(process, dealNo, "Completed");
                    else
                        dt = tracking.GetProcessDetailsForFeedbackUserNew(process, dealNo, string.IsNullOrWhiteSpace(status) ? "Pending" : status);
                }
                else if (string.Equals(status, "Completed", StringComparison.OrdinalIgnoreCase))
                {
                    dt = tracking.GetProcessDetailsForFeedbackUserCompleted(fromDate, toDate, currentCode);
                }
                else
                {
                    dt = tracking.GetProcessDetailsForFeedbackUser(currentCode, fromDate, toDate);
                }

                return TrackingListResponse.Ok(ToRows(dt));
            }
            catch (Exception ex)
            {
                return TrackingListResponse.Fail(ex.Message);
            }
        }

        private static int CurrentEmployeeId()
        {
            try { return EmployeeInfo.Current.EmployeeID; }
            catch { return Convert.ToInt32(HttpContext.Current.User.Identity.Name); }
        }

        private static string CurrentUserCode()
        {
            try { return EmployeeInfo.Current.Code; }
            catch { return Convert.ToString(HttpContext.Current.User.Identity.Name); }
        }

        private static List<Dictionary<string, object>> ToRows(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (dt == null)
                return rows;

            foreach (DataRow row in dt.Rows)
            {
                Dictionary<string, object> item = new Dictionary<string, object>();
                foreach (DataColumn column in dt.Columns)
                    item[column.ColumnName] = row[column] == DBNull.Value ? "" : row[column];
                rows.Add(item);
            }

            return rows;
        }

        private static string Clean(object value)
        {
            return value == null || value == DBNull.Value ? "" : Convert.ToString(value).Trim();
        }
    }

    public class TodayStatusRequest
    {
        public string Status { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public int ProjectId { get; set; }
        public string Process { get; set; }
        public string DealNo { get; set; }
    }
}