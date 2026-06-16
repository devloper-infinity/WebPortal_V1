using ClosedXML.Excel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
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
    public partial class SalaryIncrementDueReport : System.Web.UI.Page
    {

        static DataTable dtExport = null;
        static string exp_Month = null;


        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string GetSalaryIncrementDue(string Month)
        {
            DataTable dt1 = new bllSalary().GetSalaryIncrementDue(Month);
            exp_Month = Month;
            dtExport = dt1;

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


        protected void btn_exportSalIncDue_Click(object sender, EventArgs e)
        {
            ExportSalaryIncrementDue();
        }

        public static void ExportSalaryIncrementDue()
        {
            DataTable dt = dtExport;// your existing method

            string filename = "IncrementDueReport_" + exp_Month + ".xlsx";

            // OPTIONAL: rename columns to match your table headers
            dt.Columns["Code"].ColumnName = "Code";
            dt.Columns["NAME"].ColumnName = "Name";
            dt.Columns["DOJ"].ColumnName = "Joining Date";
            dt.Columns["Branch"].ColumnName = "Branch";
            dt.Columns["Domain"].ColumnName = "Domain";
            dt.Columns["Department"].ColumnName = "Department";
            dt.Columns["Designation"].ColumnName = "Designation";
            dt.Columns["DomainHead"].ColumnName = "Domain Head";
            dt.Columns["ReportingPM"].ColumnName = "Reporting Manager";
            dt.Columns["CurrentSalary"].ColumnName = "Current Salary";
            dt.Columns["PrevIncAmount"].ColumnName = "Previous Increment Amount";
            dt.Columns["PreviousSalary"].ColumnName = "Previous Salary";
            dt.Columns["PreviousIncMonth"].ColumnName = "Previous Increment Month";
            dt.Columns["MonthRemaining"].ColumnName = "Tenure Since Last Increment";
            dt.Columns["LastLoginDate"].ColumnName = "Latest Login Date";
            dt.Columns["CurrentStatus"].ColumnName = "Current Status";

            using (XLWorkbook wb = new XLWorkbook())
            {
                var ws = wb.Worksheets.Add("Salary Increment");

                // Add DataTable
                ws.Cell(1, 1).InsertTable(dt);

                // Styling header
                ws.Row(1).Style.Font.Bold = true;

                ws.Columns().AdjustToContents();

                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + filename);

                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    ms.WriteTo(HttpContext.Current.Response.OutputStream);
                    HttpContext.Current.Response.End();
                }
            }
        }
    }
}