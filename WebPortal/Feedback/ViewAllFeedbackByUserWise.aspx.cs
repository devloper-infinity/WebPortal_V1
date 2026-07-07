using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Feedback
{
    public partial class ViewAllFeedbackByUserWise : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetFeedbacks(string feedbackSource, string fromDate, string toDate)
        {
            bllFeedback bll = new bllFeedback();
            string employeeId = CurrentEmployee();
            if (string.Equals(Safe(feedbackSource), "Client", StringComparison.OrdinalIgnoreCase))
                return ToRows(bll.ViewAllFeedbackByClientWise(employeeId, Safe(fromDate), Safe(toDate)));

            return ToRows(bll.ViewAllFeedbackByUserWise(employeeId, CurrentRoleCode(), Safe(fromDate), Safe(toDate)));
        }

        [WebMethod(EnableSession = true)]
        public static UserFeedbackResult GetAcceptanceLink(string fatal)
        {
            string employeeId = CurrentEmployee();
            DataTable dt = new bllFeedback().ViewFeedbackByUserWise(employeeId, Safe(fatal));
            if (dt != null && dt.Rows.Count > 0)
            {
                string url = "AddFeedbackForSearchProject.aspx?User=" + HttpUtility.UrlEncode(employeeId) +
                    "&Fatal=" + HttpUtility.UrlEncode(Safe(fatal));
                return UserFeedbackResult.Link(url);
            }

            return UserFeedbackResult.Fail("No more feedback for acceptance.");
        }

        private static string CurrentRoleCode()
        {
            if (HttpContext.Current.User.IsInRole("Admin")) return "6";
            if (HttpContext.Current.User.IsInRole("Vendor")) return "4";
            return string.Empty;
        }

        private static string CurrentEmployee()
        {
            return Convert.ToString(HttpContext.Current.User.Identity.Name);
        }

        private static string Safe(string value)
        {
            return value == null ? string.Empty : value.Trim();
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;

            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                    row[column.ColumnName] = dataRow[column] == DBNull.Value ? null : dataRow[column];
                rows.Add(row);
            }

            return rows;
        }
    }

    public class UserFeedbackResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string Url { get; set; }

        public static UserFeedbackResult Link(string url)
        {
            return new UserFeedbackResult { Success = true, Url = url };
        }

        public static UserFeedbackResult Fail(string message)
        {
            return new UserFeedbackResult { Success = false, Message = message };
        }
    }
}
