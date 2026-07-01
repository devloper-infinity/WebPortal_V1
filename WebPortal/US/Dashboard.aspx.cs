using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string BindInformation()
        {
            DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetDashboardAlerts()
        {
            DataTable dt1 = new bllMaster().GetAllReadUnreradDashboardAlert();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string BindExistingInformation()
        {
            DataTable dt1 = new bllMaster().GetEmployeeVerificationData(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string BindAlertDetails(int AlertId)
        {
            DataTable dt1 = new bllMaster().GetDashboardAlertById(AlertId);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string CurrentManpowerSummary(string Type)
        {
            DataTable dt1 = new bllMaster().GetCurrentManpowerSummary(Type);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string CurrentManpowerSummaryDetails(string Type, int Branch, int Domain, string Subdomain, int Criteria)
        {
            DataTable dt1 = new bllMaster().GetCurrentManpowerSummaryDetails(Type, Branch, Domain, Subdomain, Criteria);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetPendingTask()
        {
            DataTable dt1 = new bllMaster().GetAllNotificationsByUserForDashboard(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static QueueDashboardSnapshot GetMyQueueDashboard()
        {
            int employeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DataTable queue = new bllUS().GetUSLoanProductionMyQueue(employeeId);
            List<Dictionary<string, object>> rows = TableToRows(queue);
            int oldestMinutes = 0;

            foreach (Dictionary<string, object> row in rows)
            {
                int elapsed;
                if (int.TryParse(Convert.ToString(row["ElapsedMinutes"], System.Globalization.CultureInfo.InvariantCulture), out elapsed)
                    && elapsed > oldestMinutes)
                {
                    oldestMinutes = elapsed;
                }
            }

            return new QueueDashboardSnapshot
            {
                GeneratedOn = DateTime.Now.ToString("MMM d, yyyy h:mm tt", System.Globalization.CultureInfo.InvariantCulture),
                QueueCount = rows.Count,
                LatestStarted = rows.Count > 0 ? Convert.ToString(rows[0]["StartDatetime"], System.Globalization.CultureInfo.InvariantCulture) : "-",
                OldestElapsed = FormatElapsed(oldestMinutes),
                Rows = rows
            };
        }

        private static List<Dictionary<string, object>> TableToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null)
            {
                return rows;
            }

            foreach (DataRow dr in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in table.Columns)
                {
                    row.Add(col.ColumnName, dr[col] == DBNull.Value ? string.Empty : dr[col]);
                }
                rows.Add(row);
            }

            return rows;
        }

        private static string FormatElapsed(int minutes)
        {
            if (minutes < 60)
            {
                return minutes.ToString(System.Globalization.CultureInfo.InvariantCulture) + " min";
            }

            int hours = minutes / 60;
            int remainingMinutes = minutes % 60;
            return hours.ToString(System.Globalization.CultureInfo.InvariantCulture) + " hr "
                + remainingMinutes.ToString(System.Globalization.CultureInfo.InvariantCulture) + " min";
        }

        public class QueueDashboardSnapshot
        {
            public string GeneratedOn { get; set; }
            public int QueueCount { get; set; }
            public string LatestStarted { get; set; }
            public string OldestElapsed { get; set; }
            public List<Dictionary<string, object>> Rows { get; set; }
        }
    }
}
