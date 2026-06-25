using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class DailyLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetDailyLogs()
        {
            DataTable dt1 = new bllMaster().GetAllDailyLogs(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static object GetDashboardData()
        {
            DateTime serverUtcNow = DateTime.UtcNow;
            DateTime serverIstNow = GetIndianStandardTime(serverUtcNow);
            int ERPExists = new bllMaster().CheckERPLoginExceptionExistance();

            if (ERPExists != 0)
            {
                return new
                {
                    authorized = false,
                    serverUtc = serverUtcNow.ToString("o", CultureInfo.InvariantCulture),
                    serverIst = serverIstNow.ToString("dd-MMM-yyyy HH:mm:ss", CultureInfo.InvariantCulture)
                };
            }

            DataTable dt = new bllMaster().GetAllWorkingDetailsByCode(
                int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            DataTable dtLogin = GetAllEmployeeDetailsByIDsForProductivity(
                HttpContext.Current.User.Identity.Name.ToString());

            return new
            {
                authorized = true,
                summary = ConvertDataTableToList(dt),
                login = ConvertDataTableToList(dtLogin),
                serverUtc = serverUtcNow.ToString("o", CultureInfo.InvariantCulture),
                serverIst = serverIstNow.ToString("dd-MMM-yyyy HH:mm:ss", CultureInfo.InvariantCulture)
            };
        }

        [WebMethod]
        public static string LoginUser()
        {
            string usercode = new dalMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            Hashtable htAttendance = new Hashtable();

            htAttendance.Add("Code", usercode);
            htAttendance.Add("InTime", GetAttendanceTimestamp());
            htAttendance.Add("IpAddress", HttpContext.Current.Request.UserHostAddress);
            htAttendance.Add("ApprovedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            string ReturnValue =  new bllMaster().ValidateLogin(htAttendance);
            //string ReturnValue = "You Have Successfully Logged In";// 

            var result = new
            {
                success = ReturnValue == "You Have Successfully Logged In",
                message = ReturnValue,
                currentIst = GetIndianStandardTime(DateTime.UtcNow).ToString("dd-MMM-yyyy HH:mm:ss", CultureInfo.InvariantCulture)
            };

            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(result);
        }

        [WebMethod]
        public static string LogoutUser()
        {
            string usercode = new dalMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            Hashtable htAttendance = new Hashtable();
            htAttendance.Add("Code", usercode);
            htAttendance.Add("InTime", GetAttendanceTimestamp());
            htAttendance.Add("IpAddress", HttpContext.Current.Request.UserHostAddress);

            string ReturnValue = new bllMaster().ValidateLogout(htAttendance);;
            //string ReturnValue = "You Have Successfully Logged Out";

            bool success = false;
            string CurrentLogin = "";
            string CurrentLogout = "";
            string UptoTime = "";

            if (ReturnValue == "You Have Successfully Logged Out")
            {
                new bllMaster().AdjustHolidays(htAttendance);

                DataTable dtLogin = GetAllEmployeeDetailsByIDsForProductivity(HttpContext.Current.User.Identity.Name.ToString());

                if (dtLogin.Rows.Count > 0)
                {
                    CurrentLogin = Convert.ToString(dtLogin.Rows[0]["CurrentLogin"]);
                    CurrentLogout = Convert.ToString(dtLogin.Rows[0]["CurrentLogOut"]);
                    UptoTime = Convert.ToString(dtLogin.Rows[0]["UptoTime"]);
                }

                success = true;
            }

            var result = new
            {
                success = success,
                message = success
                    ? "You have logged out successfully! Please check your log details to confirm."
                    : ReturnValue,
                currentLogin = CurrentLogin,
                currentLogout = CurrentLogout,
                uptoTime = UptoTime,
                currentIst = GetIndianStandardTime(DateTime.UtcNow).ToString("dd-MMM-yyyy HH:mm:ss", CultureInfo.InvariantCulture)
            };

            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(result);
        }

        public static DataTable GetAllEmployeeDetailsByIDsForProductivity(string Ids)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllEmployeeDetailsByCodes_Productivity_1]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Ids);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        private static List<Dictionary<string, object>> ConvertDataTableToList(DataTable dt)
        {
            var rows = new List<Dictionary<string, object>>();

            foreach (DataRow dr in dt.Rows)
            {
                var row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row[col.ColumnName] = dr[col];
                }
                rows.Add(row);
            }

            return rows;
        }

        private static DateTime GetIndianStandardTime(DateTime utcDateTime)
        {
            try
            {
                TimeZoneInfo indiaTimeZone = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
                return TimeZoneInfo.ConvertTimeFromUtc(DateTime.SpecifyKind(utcDateTime, DateTimeKind.Utc), indiaTimeZone);
            }
            catch (TimeZoneNotFoundException)
            {
                return utcDateTime.AddHours(5).AddMinutes(30);
            }
            catch (InvalidTimeZoneException)
            {
                return utcDateTime.AddHours(5).AddMinutes(30);
            }
        }

        private static string GetAttendanceTimestamp()
        {
            return GetIndianStandardTime(DateTime.UtcNow).ToString("MM/dd/yyyy HH:mm:ss", CultureInfo.InvariantCulture);
        }
    }
}
