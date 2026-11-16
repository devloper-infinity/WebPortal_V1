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
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class DownloadInvoice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllLogInOutDataForInvoice()
        {
            DataTable dt1 = new bllUS().GetAllLogInOutDataForInvoice();
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
        public static string GetUserWiseLogInOutDataForInvoice(string Code,string StartDate,string EndDate)
        {
            DataTable dt1 = new bllUS().GetUserWiseLogInOutDataForInvoice(Code, StartDate, EndDate);
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
        public static string GetAllUSLoanProductionTrack(string EmpName, string StartDate, string EndDate)
        {
            StartDate = DateTime.ParseExact(StartDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).ToString("dd-MMM-yyyy");
            EndDate = DateTime.ParseExact(EndDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).ToString("dd-MMM-yyyy");
            DataTable dt1 = new bllUS().GetAllUSLoanProductionTrack(EmpName, StartDate, EndDate);
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
        public static string GetAllNonProductiveHoursForInvoice(string Code, string StartDate, string EndDate)
        {
            StartDate = DateTime.ParseExact(StartDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).ToString("dd-MMM-yyyy");
            EndDate = DateTime.ParseExact(EndDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).ToString("dd-MMM-yyyy");
            DataTable dt1 = new bllUS().GetAllNonProductiveHoursForInvoice(Code, StartDate, EndDate);
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
        public static string GetVendorsInformation(string EmpName)
        {
           
            DataTable dt1 = new bllUS().GetVendorsInformation(EmpName);
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