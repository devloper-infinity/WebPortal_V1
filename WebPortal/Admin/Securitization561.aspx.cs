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
    public partial class Securitization561 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int InsertBillingData(int ProjectId, string BillingPeriod, string Description, int Type, string DealNo, int LoanCount)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", ProjectId);
            htParam.Add("Description", Convert.ToString(Description));
            htParam.Add("BillingPeriod", BillingPeriod);
            htParam.Add("BllingAddedDate", DateTime.Now.ToString("dd-MMM-yyyy"));
            htParam.Add("DealNo", DealNo);
            if (Type == 1 || Type == 2 || Type == 3 || Type == 7)
                htParam.Add("NoOfLoans", LoanCount);
            else
                htParam.Add("NoofHours", LoanCount);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertSecuritizationRelLetterBilling_Revised(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static string GetDealDetails(string DealNo)
        {
            DataSet dS = new bllMaster().GetDealDetails(DealNo);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (dS != null)
            {
                DataTable dt1 = dS.Tables[1];
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
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }
        [WebMethod]
        public static string GetDealData(int ProjectId, string DealNo)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            DataTable dt1 = new bllMaster().GetRevisedBilling(ProjectId, DealNo);
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
        public static int SetToAccounts(string BillingIDs)
        {
            int returnvalue = 0;
            string[] BillIDs = BillingIDs.Split(',');
            foreach (string BillingID in BillIDs)
            {
                returnvalue = new bllMaster().UpdateBillingRevised(Convert.ToInt32(BillingID));
            }
            return returnvalue;
        }

    }
}