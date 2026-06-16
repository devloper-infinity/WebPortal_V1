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

namespace WebPortal.Admin
{
    public partial class DashboardTest : System.Web.UI.Page
    {
        public static string user_name;
        protected void Page_Load(object sender, EventArgs e)
        {
            //user_name = "";
            //if (user_name != null)
            //{
            //    string username = user_name;
            //    DateTime today = DateTime.Now;

            //    if (today.Month == 3 && today.Day == 8)
            //    {
            //        festivalCard.Visible = true;
            //        lblGreeting.InnerText = "Hi " + user_name + ",";
            //    }
            //}

        }

        [WebMethod]
        public static string BindInformation()
        {
            DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            user_name = Convert.ToString(dt1.Rows[0]["FirstName"]);

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
        public static string GetDashboardProjectAlerts()
        {
            DataTable dt1 = new bllMaster().GetAllOSTNotifications();
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
        public static string GetTodayBirthdays()
        {
            DataTable dt1 = new bllMaster().GetBirthdayList();
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
        public static void SendWish(string toUserId, string message)
        {
            new bllMaster().InsertBirthdayMessage(message, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), toUserId);

            // Insert into BirthdayWishes table
        }

        [WebMethod]
        public static object CheckBirthday()
        {
            DataTable dt = new bllMaster().GetTodaysBirthday();

            if (dt.Rows.Count > 0)
            {
                return new
                {
                    IsBirthday = true,
                    Name = dt.Rows[0]["Name"].ToString()
                };
            }

            return new { IsBirthday = false };
        }

        [WebMethod]
        public static int UpdateProjectReadAlertStatus(int AlertID)
        {
            int returnvalue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("AlertID", AlertID);
            htParam.Add("EmployeeID", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().UpdateProjectAlertReadStatus(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static List<AnniversaryEmployee> GetTodayAnniversaries()
        {
            List<AnniversaryEmployee> list = new List<AnniversaryEmployee>();

            DataTable dt = new bllMaster().GetAllTodayAnniversaries();

            foreach (DataRow dr in dt.Rows)
            {
                list.Add(new AnniversaryEmployee
                {
                    EmployeeId = Convert.ToInt32(dr["EmployeeID"]),
                    EmpName = dr["EmpName"].ToString(),
                    DepartmentName = dr["DepartmentName"].ToString(),
                    //PhotoPath = dr["PhotoPath"].ToString(),
                    YearsCompleted = dr["YearsCompleted"].ToString()
                });
            }
            return list;
        }


        [WebMethod]
        public static List<EmpWorkAnniversary> GetEmpWorkAnniversary()
        {
            List<EmpWorkAnniversary> list = new List<EmpWorkAnniversary>();

            DataTable dt = new bllMaster().GetWorkAnniversary();

            foreach (DataRow dr in dt.Rows)
            {
                list.Add(new EmpWorkAnniversary
                {
                    EmployeeId = Convert.ToInt32(dr["EmployeeID"]),
                    EmpName = dr["EmpName"].ToString(),
                    Designation = dr["DesignationName"].ToString(),
                    //PhotoPath = dr["PhotoPath"].ToString(),
                    YearsCompleted = dr["YearsCompleted"].ToString()
                });
            }

            return list;
        }

        public class AnniversaryEmployee
        {
            public int EmployeeId { get; set; }
            public string EmpName { get; set; }
            public string DepartmentName { get; set; }
            //public string PhotoPath { get; set; }
            public string YearsCompleted { get; set; }
        }

        public class EmpWorkAnniversary
        {
            public int EmployeeId { get; set; }
            public string EmpName { get; set; }
            public string Designation { get; set; }
            //public string PhotoPath { get; set; }
            public string YearsCompleted { get; set; }
        }
    }
}