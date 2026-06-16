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
    public partial class CreditCardReconiliation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string getAllInvocieHeaders(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetAllInvoiceHeaders(Month, Year);
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
        public static string getAllInvocieHeadersSummary(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetAllInvoiceHeadersSummary(Month, Year);
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
        public static string GetHeaderwiseDetails(int HeaderID)
        {
            DataTable dt1 = new bllMaster().GetHeaderwiseDetails(HeaderID);
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
        public static int InsertCCMonthlyData(int HeaderID, string Month, string Year, string Remark, string InvoiceNo, string InvoiceAmount, string Utilization)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("HeaderID", HeaderID);
            htParam.Add("Month", Month);
            htParam.Add("Year", Year);
            htParam.Add("Remark", Remark);
            htParam.Add("InvoiceNo", InvoiceNo);
            htParam.Add("InvoiceAmount", InvoiceAmount);
            htParam.Add("Attachment", "");
            htParam.Add("Utilization", Utilization);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertCCInvoiceMonthlyData(htParam);
            return returnvalue;
        }
    }
}