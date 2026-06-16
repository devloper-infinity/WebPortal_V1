using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class DasboardPerformanceDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [System.Web.Services.WebMethod]
        public static string GetDashboardPerformanceDetails()
        {
            DataTable dt = new bllMaster().GetDashboardPerformanceDetails(); // your existing function

            List<object> rows = new List<object>();

            foreach (DataRow dr in dt.Rows)
            {
                rows.Add(new
                {
                    MonthYear = dr["MonthYear"].ToString(),
                    Code = dr["Code"].ToString(),
                    Name = dr["Name"].ToString(),
                    JoiningDate = dr["JoiningDate"].ToString(),
                    Tenure = dr["TenureFromJoining"].ToString(),
                    DaysWorked = dr["TotalWorkingDays"].ToString(),
                    Production = dr["Production"].ToString(),
                    ExpectedProductivity = dr["ExpectedProductivity"].ToString(),
                    AvgTarget = dr["AvgTarget"].ToString(),
                    InternalError = dr["InternalError"].ToString(),
                    ClientError = dr["ClientError"].ToString(),
                    TotalError = dr["TotalError"].ToString(),
                    Appreciations = dr["TotalAppreciations"].ToString(),
                    Warnings = dr["TotalWarnings"].ToString(),
                    ProductionPerc = dr["ProductionPerc"].ToString(),
                    Accuracy = dr["Accuracy"].ToString(),
                    Attendance = dr["OnTotalDays"].ToString(),
                    ProdGrade = dr["ProdGrade"].ToString(),
                    QAGrade = dr["QAGrade"].ToString(),
                    AttendanceGrade = dr["AttendanceGrade"].ToString()
                });
            }

            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(rows);
        }
    }
}