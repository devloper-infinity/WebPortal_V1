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
    public partial class EditDailyLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllEmpOnshoreDailyLogs()
        {
            DataTable dt1 = new bllUS().GetAllEmpOnshoreDailyLogs();
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
        public static string GetOnshoreEditDailyLogsBreakInOut(string ID,string Code)
        {
            DataTable dt1 = new bllUS().GetOnshoreEditDailyLogsBreakInOut(ID, Code);
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
        public static string UpdateOnshorelogin(string InTime, string OutTime,string Code,string Date,string Remark)
        {
            try
            {

                Hashtable htOnshoreAttendance = new Hashtable();
                htOnshoreAttendance.Add("Date", Date);

                htOnshoreAttendance.Add("Code", Code);
                htOnshoreAttendance.Add("InTime", InTime);
                htOnshoreAttendance.Add("OutTime", OutTime);
                htOnshoreAttendance.Add("UpdateRemark", Remark);

                htOnshoreAttendance.Add("UpdateBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                string ReturnValue = new bllUS().UpdateOnshorelogin(htOnshoreAttendance);

                bool isSuccess = ReturnValue.Trim().Equals("Update successfully!", StringComparison.OrdinalIgnoreCase);
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
        public static string UpdateOnshoreBreakInOut(string ID,string BreakOutTime, string BreakInTime,string Code,string Remark)
        {
            try
            {

                Hashtable htOnshoreAttendance = new Hashtable();
                htOnshoreAttendance.Add("Code", Code);
                htOnshoreAttendance.Add("ID", ID);
                htOnshoreAttendance.Add("BreakOutTime", BreakOutTime);
                htOnshoreAttendance.Add("BreakInTime", BreakInTime);
                htOnshoreAttendance.Add("UpdateRemark", Remark);

                htOnshoreAttendance.Add("UpdateBy", HttpContext.Current.User.Identity.Name.ToString());

                string ReturnValue = new bllUS().UpdateOnshoreBreakInOut(htOnshoreAttendance);

                bool isSuccess = ReturnValue.Trim().Equals("Updated successfully!", StringComparison.OrdinalIgnoreCase);

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
                JavaScriptSerializer js = new JavaScriptSerializer();
                var errorResult = new
                {
                    success = false,
                    message = "Error: " + ex.Message
                };
                return js.Serialize(errorResult);
            }
        }


        [WebMethod]
        public static string DeleteUserWiseOnshoreDailyLogin(string Date, string Code)
        {
            try
            {

                Hashtable htOnshoreAttendance = new Hashtable();
                htOnshoreAttendance.Add("Code", Code);
                htOnshoreAttendance.Add("Date", Date);
                htOnshoreAttendance.Add("DeletedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                string ReturnValue = new bllUS().DeleteUserWiseOnshoreDailyLogin(htOnshoreAttendance);

                bool isSuccess = ReturnValue.Trim().Equals("Deleted successfully!", StringComparison.OrdinalIgnoreCase);

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
                JavaScriptSerializer js = new JavaScriptSerializer();
                var errorResult = new { success = false, message = "Error: " + ex.Message };
                return js.Serialize(errorResult);
            }
        }



        [WebMethod]
        public static string DeleteUserWiseOnshoreDailyBreakInOut(string BreakInOutId, string Code)
        {
            try
            {

                Hashtable htOnshoreAttendance = new Hashtable();
                htOnshoreAttendance.Add("Code", Code);
                htOnshoreAttendance.Add("BreakInOutId", BreakInOutId);
                htOnshoreAttendance.Add("DeletedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                string ReturnValue = new bllUS().DeleteUserWiseOnshoreDailyBreakInOut(htOnshoreAttendance);

                bool isSuccess = ReturnValue.Trim().Equals("Deleted successfully!", StringComparison.OrdinalIgnoreCase);

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
                JavaScriptSerializer js = new JavaScriptSerializer();
                var errorResult = new { success = false, message = "Error: " + ex.Message };
                return js.Serialize(errorResult);
            }
        }
    }
}