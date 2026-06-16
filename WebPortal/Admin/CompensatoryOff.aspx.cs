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
    public partial class CompensatoryOff : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static int CheckIfPM()
        {
            int isPM = new bllLogin().CheckIfPM(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            return isPM;
        }

        [WebMethod]
        public static string GetAllWorkedHolidayDates(int currentUser)
        {
            DataTable dt1 = new bllMaster().GetAllWorkedHolidayDates(currentUser);
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
        public static string GetUserAllCompOff()
        {
            DataTable dt1 = new bllMaster().GetUserAllCompOff(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserCompOff_forApproval()
        {
            DataTable dt1 = new bllMaster().GetUserCompOff_forApproval(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static int InsertUserCompOff(string workedHoliday, string CompOffDate, string Remark)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("EmployeeID", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("WorkedHolidayDate", workedHoliday);
            htParam.Add("CompOffDate", CompOffDate);
            htParam.Add("Remark", Remark);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllMaster().InsertUserCompOff(htParam);

            return ReturnValue;
        }

        [WebMethod]
        public static int ApproveRejectCompOff(int CompOffID, bool IsApproved, string Remark)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("CompOffID", CompOffID);
            htParam.Add("Remark", Remark);
            htParam.Add("IsApproved", IsApproved);
            htParam.Add("ApprovedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllMaster().ApproveRejectCompOff(htParam);

            return ReturnValue;
        }

        [WebMethod]
        public static int InsertUserCompOff_byPM(int EmployeeID, string workedHoliday, string CompOffDate, string Remark)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("EmployeeID", EmployeeID);
            htParam.Add("WorkedHolidayDate", workedHoliday);
            htParam.Add("CompOffDate", CompOffDate);
            htParam.Add("Remark", Remark);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("IsApproved", true);
            htParam.Add("ApprovedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("ApprovedDate", DateTime.Now);
            htParam.Add("ApprovalRemark", Remark);

            ReturnValue = new bllMaster().InsertUserCompOff(htParam);

            return ReturnValue;
        }
    }
}