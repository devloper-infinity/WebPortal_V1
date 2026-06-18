using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.FTE
{
    public partial class FTEAttendance : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetAllProjectByUserRights()
        {
            DataTable dt = new bllMaster().GetAllProjectByUserRights(HttpContext.Current.User.Identity.Name);
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetBillingCycleByProject(int ProjectID)
        {
            if (ProjectID <= 0)
            {
                return string.Empty;
            }

            return new bllTracking().getBillingPeriodByProject(Convert.ToString(ProjectID));
        }

        [WebMethod]
        public static string GetBillingPeriods(int ProjectID, string BillingCycle)
        {
            List<string> periods = BuildCurrentBillingPeriods(BillingCycle);

            if (periods.Count > 0)
            {
                return SerializeObject(periods);
            }

            DataTable dt = new bllMaster().GetBilligPeriodDates(BillingCycle);
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetFTEUsers(int ProjectID)
        {
            DataTable dt = GetFTEUsersData(ProjectID);
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetFTEAttendance(int ProjectID, string BillingPeriod, int EmployeeID)
        {
            DataTable dt = GetFTEAttendanceData(ProjectID, Convert.ToString(BillingPeriod).Replace("to", "~"), EmployeeID);
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string InsertFTEAttendance(int ProjectID, int EmployeeID, string Dates)
        {
            int requested = 0;
            int saved = 0;
            int failed = 0;

            if (ProjectID <= 0 || EmployeeID <= 0 || string.IsNullOrWhiteSpace(Dates))
            {
                return SerializeObject(new { Requested = requested, Saved = saved, Failed = failed });
            }

            string[] dateList = Dates.Split(new[] { '|' }, StringSplitOptions.RemoveEmptyEntries);
            requested = dateList.Length;

            foreach (string date in dateList)
            {
                int returnValue = InsertFTEAttendanceData(ProjectID, EmployeeID, date.Trim(), GetCurrentEmployeeId());

                if (returnValue > 0)
                {
                    saved += 1;
                }
                else
                {
                    failed += 1;
                }
            }

            return SerializeObject(new { Requested = requested, Saved = saved, Failed = failed });
        }

        private static List<string> BuildCurrentBillingPeriods(string billingCycle)
        {
            List<string> periods = new List<string>();

            if (string.IsNullOrWhiteSpace(billingCycle))
            {
                return periods;
            }

            DateTime now = DateTime.Now;

            if (now.Day < 14)
            {
                now = DateTime.Now.AddMonths(-1);
            }

            string month = now.ToString("MMM");
            string year = now.ToString("yyyy");
            DateTime startDate = new DateTime(now.Year, now.Month, 1);
            string end = startDate.AddMonths(1).AddDays(-1).ToString("dd-MMM-yyyy");

            if (string.Equals(billingCycle, "Bi-Monthly", StringComparison.OrdinalIgnoreCase))
            {
                periods.Add("01-" + month + "-" + year + " to 15-" + month + "-" + year);
                periods.Add("16-" + month + "-" + year + " to " + end);
                periods.Add("01-Dec-2021 to 15-Dec-2021");
                periods.Add("16-Dec-2021 to 31-Dec-2021");
            }
            else if (string.Equals(billingCycle, "Monthly", StringComparison.OrdinalIgnoreCase))
            {
                periods.Add("01-" + month + "-" + year + " to " + end);
                periods.Add("01-Dec-2021 to 31-Dec-2021");
            }

            return periods;
        }

        private static DataTable GetFTEUsersData(int projectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_getUserForFTEProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 10, ParameterDirection.Input, projectId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            cmd.Dispose();
            return dt;
        }

        private static DataTable GetFTEAttendanceData(int projectId, string billingPeriod, int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetDateForAttendance");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 10, ParameterDirection.Input, projectId);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", SqlDbType.NVarChar, 500, ParameterDirection.Input, billingPeriod);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            cmd.Dispose();
            return dt;
        }

        private static int InsertFTEAttendanceData(int projectId, int employeeId, string dates, int addedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_InsertFTEAttendance");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 0, ParameterDirection.Input, employeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Dates", SqlDbType.NVarChar, 100, ParameterDirection.Input, dates);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.Int, 0, ParameterDirection.Input, addedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int returnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return returnValue;
        }

        private static int GetCurrentEmployeeId()
        {
            return int.Parse(HttpContext.Current.User.Identity.Name);
        }

        private static string SerializeDataTable(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();

                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }

                    rows.Add(row);
                }
            }

            return SerializeObject(rows);
        }

        private static string SerializeObject(object value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(value);
        }
    }
}
