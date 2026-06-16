using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
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

        //[WebMethod]
        //public static object GetDashboardData()
        //{
        //    int ERPExists = new bllMaster().CheckERPLoginExceptionExistance();

        //    if (ERPExists != 0)
        //    {
        //        return new
        //        {
        //            authorized = false
        //        };
        //    }

        //    DataTable dt = new bllMaster().GetAllWorkingDetailsByCode(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

        //    DataTable dtLogin = new bllMaster().GetAllEmployeeDetailsByIDsForProductivity(HttpContext.Current.User.Identity.Name.ToString());

        //    return new
        //    {
        //        authorized = true,
        //        summary = dt,
        //        login = dtLogin
        //    };
        //}



        [WebMethod]
        public static object GetDashboardData()
        {
            int ERPExists = new bllMaster().CheckERPLoginExceptionExistance();

            if (ERPExists != 0)
            {
                return new
                {
                    authorized = false
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
                login = ConvertDataTableToList(dtLogin)
            };
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

        [WebMethod]
        public static string LoginUser()
        {
            string usercode = new dalMaster()
                .GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            Hashtable htAttendance = new Hashtable();

            htAttendance.Add("Code", usercode);
            htAttendance.Add("InTime", DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss"));
            htAttendance.Add("IpAddress", HttpContext.Current.Request.UserHostAddress);
            htAttendance.Add("ApprovedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            string ReturnValue = new bllMaster().ValidateLogin(htAttendance);

            var result = new
            {
                success = ReturnValue == "You Have Successfully Logged In",
                message = ReturnValue
            };

            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(result);
        }

        [WebMethod]
        public static string LogoutUser()
        {
            string usercode = new dalMaster()
                .GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            Hashtable htAttendance = new Hashtable();
            htAttendance.Add("Code", usercode);
            htAttendance.Add("InTime", DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss"));
            htAttendance.Add("IpAddress", HttpContext.Current.Request.UserHostAddress);

            string ReturnValue = new bllMaster().ValidateLogout(htAttendance);

            bool success = false;
            string CurrentLogin = "";
            string CurrentLogout = "";
            string UptoTime = "";

            if (ReturnValue == "You Have Successfully Logged Out")
            {
                new bllMaster().AdjustHolidays(htAttendance);

                DataTable dtLogin = new bllMaster().GetAllEmployeeDetailsByIDsForProductivity(HttpContext.Current.User.Identity.Name.ToString());

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
                uptoTime = UptoTime
            };

            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(result);
        }
    }
}