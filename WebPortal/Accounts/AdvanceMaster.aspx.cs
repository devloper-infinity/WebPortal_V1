using DocumentFormat.OpenXml.Office2010.Excel;
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

namespace WebPortal.Accounts
{
    public partial class AdvanceMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string GetAllAdvanceEntries()
        {
            DataTable dt1 = new bllSalary().GetAllAdvanceEntries();
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
        public static int InsertAdvance(string Code, string Month, string Year, string AdvanceAmt, string Installment, string Remark, bool DoNotDeduct)
        {
            Hashtable htParam = new Hashtable();
            htParam.Add("Code", Code);
            htParam.Add("Month", Month);
            htParam.Add("Year", Year);
            htParam.Add("AdvanceAmount", Convert.ToDecimal(AdvanceAmt));
            htParam.Add("installment", Convert.ToDecimal(Installment));
            htParam.Add("Balance", Convert.ToDecimal(AdvanceAmt));
            htParam.Add("Remark", Remark);
            htParam.Add("Status", "Running");
            htParam.Add("DoNotDeduct", DoNotDeduct);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            int ReturnValue = new bllSalary().InsertAdvance(htParam);

            return ReturnValue;
        }

        [WebMethod]
        public static int DeleteAdvance(int AdvanceID)
        {
            Hashtable htParam = new Hashtable();
            htParam.Add("AdvanceId", AdvanceID);
            int DeletedBy = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            int ReturnValue = new bllSalary().DeleteAdvance(htParam);

            return ReturnValue;
        }


        [WebMethod]
        public static int UpdateAdvance(int AdvanceID, string Installment, string Remark)
        {
            Hashtable htParam = new Hashtable();
            htParam.Add("AdvanceId", AdvanceID);
            htParam.Add("installment", Installment);
            htParam.Add("Remark", Remark);

            int ReturnValue = new bllSalary().UpdateAdvance(htParam);

            return ReturnValue;
        }
    }
}