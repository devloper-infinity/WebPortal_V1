using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Feedback
{
    public partial class ViewAllFeedbackByPMWise : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetFeedbacks(string fromDate, string toDate)
        {
            return ToRows(new bllFeedback().ViewAllFeedbackByPMWise(Safe(fromDate), Safe(toDate), CurrentEmployee()));
        }

        [WebMethod(EnableSession = true)]
        public static PMFeedbackResult DeleteFeedback(int feedDetailsId)
        {
            if (feedDetailsId <= 0)
                return PMFeedbackResult.Fail("Invalid feedback.");

            int result = new bllFeedback().DeleteFeedback(feedDetailsId, CurrentEmployeeId());
            return result > 0
                ? PMFeedbackResult.Ok("Feedback deleted successfully.")
                : PMFeedbackResult.Fail("Unable to delete feedback.");
        }

        [WebMethod(EnableSession = true)]
        public static PMFeedbackResult GetAcceptanceLink(string fatal)
        {
            string employeeId = CurrentEmployee();
            DataTable dt = new bllFeedback().ViewFeedbackByPMWise(employeeId, Safe(fatal));
            if (dt != null && dt.Rows.Count > 0)
            {
                string url = "AddFeedbackForSearchProject.aspx?EmployeeID=" + HttpUtility.UrlEncode(employeeId) +
                    "&Fatal=" + HttpUtility.UrlEncode(Safe(fatal));
                return PMFeedbackResult.Link(url);
            }

            return PMFeedbackResult.Fail("No more feedback for acceptance.");
        }

        private static string CurrentEmployee()
        {
            return Convert.ToString(HttpContext.Current.User.Identity.Name);
        }

        private static int CurrentEmployeeId()
        {
            int employeeId;
            return int.TryParse(CurrentEmployee(), out employeeId) ? employeeId : 0;
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

    public class PMFeedbackResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string Url { get; set; }

        public static PMFeedbackResult Ok(string message)
        {
            return new PMFeedbackResult { Success = true, Message = message };
        }

        public static PMFeedbackResult Link(string url)
        {
            return new PMFeedbackResult { Success = true, Url = url };
        }

        public static PMFeedbackResult Fail(string message)
        {
            return new PMFeedbackResult { Success = false, Message = message };
        }
    }
}
