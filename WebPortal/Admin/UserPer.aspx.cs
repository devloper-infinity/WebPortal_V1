using ClosedXML.Excel;
using Spire.Xls;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class UserPer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static object GetHRUserData(string type, string tab, string FromDate, string EndDate)
        {
            try
            {
                DataTable dt = new DataTable();

                // 👉 Call your BLL based on tab
                if (type == "nondd")
                {
                    if (tab == "summary")
                        dt = new bllMaster().GetUserPerformanceReport_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    else if (tab == "production")
                        dt = new bllMaster().GetUserPerformanceProdDetails_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    else if (tab == "feedback")
                        dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    else if (tab == "attendance")
                        //   dt = new bllMaster().GetUserPerformanceAttendanceDetails_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        dt = new bllMaster().GetUserPerformanceAttendanceDetails(FromDate, EndDate, 7171);// int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                }

                else if (type == "credit")
                {
                    if (tab == "summary")
                        dt = new bllMaster().GetUserPerformanceReport_HR_Credit(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    else if (tab == "production")
                        dt = new bllMaster().GetUserPerformanceProdDetails_HR_Credit(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    else if (tab == "feedback")
                        dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Credit(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    else if (tab == "attendance")
                        //  dt = new bllMaster().GetUserPerformanceAttendanceDetails_HR_Credit(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        dt = new bllMaster().GetUserPerformanceAttendanceDetails(FromDate, EndDate, 7171);// int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                }

                else if (type == "servicing")
                {
                    if (tab == "summary")
                        dt = new bllMaster().GetUserPerformanceReport_HR_Servicing(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    else if (tab == "production")
                        dt = new bllMaster().GetUserPerformanceProdDetails_HR_Servicing(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    else if (tab == "feedback")
                        dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Servicing(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    else if (tab == "attendance")
                        dt = new bllMaster().GetUserPerformanceAttendanceDetails(FromDate, EndDate, 7171);// int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                                                                                                          // dt = new bllMaster().GetUserPerformanceAttendanceDetails_HR_Servicing(FromDate, EndDate, 7171);// int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                }

                List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
                Dictionary<string, object> row;
                foreach (DataRow dr in dt.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
                JavaScriptSerializer ser = new JavaScriptSerializer();
                ser.MaxJsonLength = int.MaxValue;
                return ser.Serialize(rows);
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }
        }

    }
}