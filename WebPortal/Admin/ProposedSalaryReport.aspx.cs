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
        bllSalary bllSalary = new bllSalary();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string Code = Convert.ToString(Request.QueryString["Code"]);

                if (Code == null)
                {
                    aBack.Style.Add("display", "none");
                    prp_labelCode.InnerHtml = EmployeeInfo.Current.Code;
                    prp_labelEmpID.InnerHtml = Convert.ToString(EmployeeInfo.Current.EmployeeID);

                    BindSalaryInfo(prp_labelCode.InnerHtml);
                }
                else
                {
                    aBack.Style.Add("display", "");
                    aBack.HRef = "ViewLog.aspx?Code=" + Code;
                    BindSalaryInfo(Code);
                }
            }
        }

        public void BindSalaryInfo(string Code)
        {
            DateTime today = DateTime.Now.Date;

            DateTime startDate = new DateTime(today.Year, today.Month, 23);
            DateTime endDate = new DateTime(today.Year, today.Month, 1).AddMonths(1);

            bool isEnabled = today >= startDate && today <= endDate;

            if (isEnabled)
            {
                DataTable dt = bllSalary.getSalaryDetails(Code);
                if (dt.Rows.Count > 0)
                {
                    lblFullDays.InnerHtml = Convert.ToString(dt.Rows[0]["FullDay"]);
                    lblPartialDays.InnerHtml = Convert.ToString(dt.Rows[0]["PartialDay"]);
                    lblLatemarkCount.InnerHtml = Convert.ToString(dt.Rows[0]["LateMark"]);
                    lblTotalDays.InnerHtml = Convert.ToString(dt.Rows[0]["TotalDays"]);
                    lblTotalDaysWithExtra.InnerHtml = Convert.ToString(dt.Rows[0]["TotalDaysWithExtra"]);
                    lblExtraDays.InnerHtml = Convert.ToString(dt.Rows[0]["ExtraDays"]);
                    lblExtraDaysSalary.InnerHtml = Convert.ToString(dt.Rows[0]["ExtraDaysSalary"]);
                    lblIncentive.InnerHtml = Convert.ToString(dt.Rows[0]["Incentive"]);
                }
            }
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