using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;


namespace WebPortal.Accounts
{
    public partial class SalarySlipMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string GetEmployeeSalarySlip()
        {
            DataTable dt1 = new bllSalary().GetEmployeeSalarySlip();
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
        public static string GetEmployeeSalaryInfo(int EmployeeID, string Month, string Year, int CompID)
        {
            DataTable dt1 = new bllSalary().GetSalaryInfoByEmployeeID_NewERP(EmployeeID, Month, Year);

            //DataTable dt1 = new bllSalary().GetUserInformation(EmployeeID, Month, Year);
            //DataTable dt2 = new bllSalary().GetSalaryInfoByEmployeeID(EmployeeID, Month, Year);
            //DataTable dt3 = new bllSalary().GetCompanyById(CompID);
            //dt1.Merge(dt2);
            //dt1.Merge(dt3);
            //            DataTable dt3 = dt1.Merge(dt2);

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            foreach (DataRow dr in dt1.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();

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

        //[WebMethod]
        //public static string GetEmployeeSalaryInfo(int EmployeeID, string Month, string Year)
        //{
        //    DataTable dt1 = new bllSalary().GetUserInformation(EmployeeID,  Month,  Year);
        //    DataTable dt2 = new bllSalary().GetSalaryInfoByEmployeeID(EmployeeID, Month, Year);

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
    }
}