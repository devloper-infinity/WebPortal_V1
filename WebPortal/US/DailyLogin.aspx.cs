using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.US
{
    public partial class DailyLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetOnshoreDailyLogs()
        {
            DataTable dt1 = new bllUS().GetOnshoreDailyLogs(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetOnshoreDailyLogsBreakInOut(int employeeID)
        {
            DataTable dt1 = new bllUS().GetOnshoreDailyLogsBreakInOut(employeeID);
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
        public static string AddOnshorelogin(string currentTime, string clockDate)
        {
            try
            {
                string usercode = new dalMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                Hashtable htOnshoreAttendance = new Hashtable();

                htOnshoreAttendance.Add("Code", usercode);
                htOnshoreAttendance.Add("InTime", currentTime);
                htOnshoreAttendance.Add("Date", clockDate);
                htOnshoreAttendance.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                string ReturnValue = new bllUS().AddOnshorelogin(htOnshoreAttendance);

                bool isSuccess = ReturnValue.Trim().Equals("You Have Successfully Logged In!", StringComparison.OrdinalIgnoreCase);
                var result = new
                {
                    success = isSuccess,
                    message = ReturnValue
                };


                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(result);

            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string AddOnshoreLogOut(string currentOutTime, string currentDate)
        {
            try
            {
                string usercode = new dalMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name));

                Hashtable htOnshoreAttendance = new Hashtable();
                htOnshoreAttendance.Add("Code", usercode);
                htOnshoreAttendance.Add("OutTime", currentOutTime);
                htOnshoreAttendance.Add("Date", currentDate);

                string ReturnValue = new bllUS().AddOnshoreLogout(htOnshoreAttendance);

                bool isSuccess = ReturnValue == "You Have Successfully Logged Out!" || ReturnValue == "You Have Successfully Logged Out";

                var result = new
                {
                    success = isSuccess,
                    message = ReturnValue
                };

                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(result);
            }
            catch (Exception ex)
            {
                var errorResult = new
                {
                    success = false,
                    message = "Error: " + ex.Message
                };
                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(errorResult);
            }
        }

        [WebMethod]
        public static string AddOnshoreBreakIn(string BreakInTime,string breakInOutID)
        {
            try
            {
                string usercode = new dalMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name));

                Hashtable htOnshoreAttendance = new Hashtable();

                htOnshoreAttendance.Add("Code", usercode);
                htOnshoreAttendance.Add("BreakInTime", BreakInTime);
                htOnshoreAttendance.Add("BreakInOutId", breakInOutID);
                string ReturnValue = new bllUS().AddOnshoreBreakIn(htOnshoreAttendance);

                bool isSuccess = ReturnValue == "You Have Successfully Break In!" || ReturnValue == "You Have Successfully Break In";

                var result = new
                {
                    success = isSuccess,
                    message = ReturnValue
                };

                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(result);
            }
            catch (Exception ex)
            {
                var errorResult = new
                {
                    success = false,
                    message = "Error: " + ex.Message
                };
                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(errorResult);
            }
        }
        [WebMethod]
        public static string AddOnshoreBreakOut(string BreakOutTime, string BreakReason)
        {
            try
            {
                string usercode = new dalMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name));

                Hashtable htOnshoreAttendance = new Hashtable();
                htOnshoreAttendance.Add("Code", usercode);
                htOnshoreAttendance.Add("BreakOutTime", BreakOutTime);
                htOnshoreAttendance.Add("BreakReason", BreakReason);

                htOnshoreAttendance.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                string ReturnValue = new bllUS().AddOnshoreBreakOut(htOnshoreAttendance);

                bool isSuccess = ReturnValue == "You Have Successfully Break Out!" || ReturnValue == "You Have Successfully Break Out";

                var result = new
                {
                    success = isSuccess,
                    message = ReturnValue
                };

                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(result);
            }
            catch (Exception ex)
            {
                var errorResult = new
                {
                    success = false,
                    message = "Error: " + ex.Message
                };
                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(errorResult);
            }
        }
    }
}