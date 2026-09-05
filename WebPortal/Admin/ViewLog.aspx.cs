using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Ajax.Utilities;

namespace WebPortal.Admin
{
    public partial class ViewLog : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string Code = Convert.ToString(Request.QueryString["Code"]);
                Year();
                ddlMonth.SelectedValue = DateTime.Now.ToString("MMMM", new CultureInfo("en-GB"));
                ddlYear.SelectedValue = Convert.ToString(DateTime.Now.Year);
                BindUserInfo(Code);
                aProposed.HRef = "ProposedSalaryReport.aspx?Code=" + Code;
            }
        }

        private void Year()
        {
            int year = DateTime.Now.Year - 6;

            ddlYear.Items.Clear();
            for (int Y = year; Y <= DateTime.Now.Year + 1; Y++)
            {
                ddlYear.Items.Add(new ListItem(Y.ToString(), Y.ToString()));
            }

            ddlYear.SelectedValue = DateTime.Now.Year.ToString();
        }


        [WebMethod]
        public static Dictionary<string, object> BindSalaryInfo(string Code, string Month, string Year)
        {
            DataTable dt = null;
            if (Month == DateTime.Now.ToString("MMMM") && Year == DateTime.Now.ToString("yyyy"))
                dt = new dalMaster().GetAllWorkingDetails(Code);
            else
                dt = new bllSalary().GetSalaryDetails_CurrentMonth(Code, Month, Year);


            Dictionary<string, object> salaryInfo = new Dictionary<string, object>();
                
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataColumn column in dt.Columns)
                {
                    object value = dt.Rows[0][column];
                    salaryInfo[column.ColumnName] = value == DBNull.Value ? "" : value;
                }
            }

            return salaryInfo;
        }


        public void BindUserInfo(string Code)
        {
            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt = new bllLogin().GetUserInformation(EmployeeID);

            if (dt != null && dt.Rows.Count > 0)
            {
                txtCode.Value = Convert.ToString(dt.Rows[0]["Code"]);
                txtName.Value = Convert.ToString(dt.Rows[0]["FullName"]);
                txtPseudoname.Value = Convert.ToString(dt.Rows[0]["PsuedoName"]);
            }
        }

        [WebMethod]
        public static string BindLogDetails(string Code, string Month, string Year)
        {
            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Convert.ToString(Code));
            DataTable dt;

            if (!string.IsNullOrWhiteSpace(Month) && !string.IsNullOrWhiteSpace(Year))
            {
                dt = new bllMaster().GetAllDailyLogs_Monthwise(EmployeeID, Month, Year);
            }
            else
            {
                dt = new bllMaster().GetAllDailyLogs(EmployeeID);
            }

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col] == DBNull.Value ? "" : dr[col]);
                    }
                    rows.Add(row);
                }
            }

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        #region OLD Code


        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    if (!IsPostBack)
        //    {
        //        string Code = Convert.ToString(Request.QueryString["Code"]);
        //        Year();
        //        ddlMonth.SelectedValue = DateTime.Now.ToString("MMMM", new CultureInfo("en-GB"));
        //        ddlYear.SelectedValue = Convert.ToString(DateTime.Now.Year);
        //        BindUserInfo(Code);
        //        BindGrid(Code);
        //        aProposed.HRef = "ProposedSalaryReport.aspx?Code=" + Code;
        //    }
        //}

        //private void Year()
        //{
        //    DateTimeFormatInfo info = DateTimeFormatInfo.GetInstance(null);
        //    int year = DateTime.Now.Year - 6;
        //    //int year = 2016;

        //    for (int Y = year; Y <= DateTime.Now.Year + 1; Y++)
        //    {
        //        ddlYear.Items.Add(new ListItem(Y.ToString(), Y.ToString()));
        //    }

        //    ddlYear.SelectedValue = DateTime.Now.Year.ToString();
        //}

        //public void BindUserInfo(string Code)
        //{
        //    int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
        //    DataTable dt = new bllLogin().GetUserInformation(EmployeeID);
        //    if (dt != null)
        //    {
        //        if (dt.Rows.Count > 0)
        //        {
        //            //lblcode1.InnerHtml = Convert.ToString(dt.Rows[0]["Code"]);
        //            //lblname1.InnerHtml = Convert.ToString(dt.Rows[0]["FullName"]);
        //            //lblPseudoname.InnerHtml = Convert.ToString(dt.Rows[0]["PsuedoName"]);

        //            txtCode.Value = Convert.ToString(dt.Rows[0]["Code"]);
        //            txtName.Value = Convert.ToString(dt.Rows[0]["FullName"]);
        //            txtPseudoname.Value = Convert.ToString(dt.Rows[0]["PsuedoName"]);
        //        }
        //    }
        //}

        //public void BindGrid(string Code)
        //{
        //    int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
        //    grdLog.DataSource = new bllMaster().GetAllDailyLogs(EmployeeID);
        //    grdLog.DataBind();
        //}

        //[WebMethod]
        //public static string BindLogDetails(string Code)
        //{
        //    int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Convert.ToString(Code));
        //    DataTable dt1 = new bllMaster().GetAllDailyLogs(EmployeeID);
        //    List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
        //    Dictionary<string, object> row;
        //    foreach (DataRow dr in dt1.Rows)
        //    {
        //        row = new Dictionary<string, object>();
        //        foreach (DataColumn col in dt1.Columns)
        //        {
        //            row.Add(col.ColumnName, dr[col]);
        //        }
        //        rows.Add(row);
        //    }
        //    JavaScriptSerializer ser = new JavaScriptSerializer();
        //    ser.MaxJsonLength = int.MaxValue;
        //    return ser.Serialize(rows);
        //}

        //protected void btnshow_Click(object sender, EventArgs e)
        //{
        //    string Code = Convert.ToString(Request.QueryString["Code"]);
        //    int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
        //    grdLog.DataSource = new bllMaster().GetAllDailyLogs_Monthwise(EmployeeID, Convert.ToString(ddlMonth.SelectedValue), Convert.ToString(ddlYear.SelectedValue));
        //    grdLog.DataBind();
        //}

        #endregion
    }
}
