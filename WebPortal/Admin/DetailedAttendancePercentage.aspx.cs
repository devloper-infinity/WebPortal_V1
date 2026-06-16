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
    public partial class DetailedAttendancePercentage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static object GetMonthwiseAttendance()
        {
            string Code = Convert.ToString(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            string FromDate = DateTime.Now.AddYears(-1).AddDays(1).ToString("dd-MMM-yyyy");
            string ToDate = DateTime.Now.ToString("dd-MMM-yyyy");
            Hashtable htParam = new Hashtable();
            htParam.Add("UserCode", Code);
            htParam.Add("FromDate", FromDate);
            htParam.Add("ToDate", ToDate);
            DataTable dt = new bllMaster().GetDetailedAttendancePercentageForDashboard(htParam); // your existing method

            List<object> rows = new List<object>();

            foreach (DataRow dr in dt.Rows)
            {
                rows.Add(new
                {
                    Code = dr["Code"],
                    Month = dr["Month"],
                    Year = dr["Year"],
                    TotalCalenderDays = dr["TotalCalenderDays"],
                    AbsentDays = dr["AbsentDays"],
                    PartialCount = dr["PartialCount"],
                    PartialDays = dr["PartialDays"],
                    TotalAbsentDays = dr["TotalAbsentDays"],
                    SalaryPresentDays = dr["SalaryPresentDays"],
                    AttendancePercOnTotalDays = dr["AttendancePercOnTotalDays"],
                    Latemarks = dr["Latemarks"],
                    RemovedLatemarks = dr["RemovedLatemarks"],
                    TotalLatemarks = dr["TotalLatemarks"]
                });
            }

            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(rows);
        }
    }
}