using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Admin
{
    public partial class ProposedSalaryReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string Code = Convert.ToString(Request.QueryString["Code"]);

                if (string.IsNullOrEmpty(Code))
                {
                    aBack.Style.Add("display", "none");
                    prp_labelCode.InnerHtml = EmployeeInfo.Current.Code;
                    prp_labelEmpID.InnerHtml = Convert.ToString(EmployeeInfo.Current.EmployeeID);
                }
                else
                {
                    aBack.Style.Add("display", "");
                    aBack.HRef = "ViewLog.aspx?Code=" + Code;
                }
            }
        }

        [WebMethod]
        public static Dictionary<string, string> BindSalaryInfo(string Code)
        {
            if (string.IsNullOrWhiteSpace(Code))
                return null;

            DateTime today = DateTime.Now.Date;

            DateTime startDate = new DateTime(today.Year, today.Month, 23);
            DateTime endDate = new DateTime(today.Year, today.Month, 1).AddMonths(1);

            bool isEnabled = today >= startDate && today <= endDate;

            if (!isEnabled)
                return null;

            DataTable dt = new bllSalary().getSalaryDetails(Code);
            if (dt.Rows.Count == 0)
                return null;

            DataRow row = dt.Rows[0];
            return new Dictionary<string, string>
            {
                { "FullDay", Convert.ToString(row["FullDay"]) },
                { "PartialDay", Convert.ToString(row["PartialDay"]) },
                { "LateMark", Convert.ToString(row["LateMark"]) },
                { "TotalDays", Convert.ToString(row["TotalDays"]) },
                { "TotalDaysWithExtra", Convert.ToString(row["TotalDaysWithExtra"]) },
                { "ExtraDays", Convert.ToString(row["ExtraDays"]) },
                { "ExtraDaysSalary", Convert.ToString(row["ExtraDaysSalary"]) },
                { "Incentive", Convert.ToString(row["Incentive"]) }
            };
        }


        [WebMethod]
        public static string GetAllSalaryLogs(string Code)
        {
            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);

            DataTable dt1 = new bllSalary().GetAllSalaryLogs(EmployeeID);

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
    }
}
