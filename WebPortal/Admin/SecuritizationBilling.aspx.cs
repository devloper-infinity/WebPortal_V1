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
    public partial class SecuritizationBilling : System.Web.UI.Page
    {
        static DataTable dtInfo = new DataTable();
        static int LoanCount = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (LoanCount > 0)
            {
                //secrBilling_lblNoOfLoans.InnerText = Convert.ToString(LoanCount);
            }
        }

        [WebMethod]
        public static string GetDealDetails(string DealNo)
        {
            DataSet ds = new bllMaster().GetDealDetails(DealNo);

            DataTable dt1 = ds.Tables[0];
            dtInfo = ds.Tables[1];

            GetSummaryDetails();

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
        public static string GetAllDealsFromProjectTracking_Billing()
        {
            DataTable dt1 = new bllMaster().GetAllDealsFromProjectTracking_Billing();

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
        public static string GetSummaryDetails()
        {
            DataTable dt1 = dtInfo;
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
        public static int InsertSecuritizationRelianceLetter_Billing(string BillingType, string DealNo, string ProjectID, string ClientDealName, string ProjectName, string LoanCount, string AssociateHours, string Remark)
        {
            int returnvalue = 0;

            Hashtable htParam = new Hashtable();
            string BillingPeriod = "";

            if (Convert.ToInt32(LoanCount) == 1)
                BillingPeriod = DealNo + "-" + ProjectName + "_" + ClientDealName + "_" + BillingType + "_" + LoanCount + " Loan";
            else
                BillingPeriod = DealNo + "-" + ProjectName + "_" + ClientDealName + "_" + BillingType + "_" + LoanCount + " Loans";

            htParam.Add("BillingPeriod", BillingPeriod);
            htParam.Add("ProjectId", ProjectID);
            htParam.Add("Description", BillingPeriod);
            htParam.Add("BillingType", BillingType);
            htParam.Add("LoanCount", LoanCount);

            if (BillingType == "Securitization")
                htParam.Add("NoOfHoursLoans", AssociateHours);
            else
                htParam.Add("NoOfHoursLoans", LoanCount);

            htParam.Add("AssociateRemark", Remark);
            htParam.Add("DealNo", DealNo);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue =  new bllMaster().InsertSecuritizationRelLetterBilling(htParam);
            return returnvalue;
        }
    }
}