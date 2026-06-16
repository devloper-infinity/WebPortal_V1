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
    public partial class CreditCardMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int InsertCreditCardMaster(string CardName, string CardNo, string Status, int BillingFrom, int BillingTo, string Description)
        {   
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("CardName", CardName);
            htParam.Add("CardNo", CardNo);
            htParam.Add("Status", Status);
            htParam.Add("BillingFrom", BillingFrom);
            htParam.Add("BillingTo", BillingTo);
            htParam.Add("Description", Description);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertCreditCardMaster(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static string GetAllCC_Master()
        {
            DataTable dt1 = new bllMaster().GetAllCC_Master();
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
        public static int EditCreditCardMaster(int MasterID, string CardName, string CardNo, string Status, int BillingFrom, int BillingTo, string Description)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("MasterID", MasterID);
            htParam.Add("CardName", CardName);
            htParam.Add("CardNo", CardNo);
            htParam.Add("Status", Status);
            htParam.Add("BillingFrom", BillingFrom);
            htParam.Add("BillingTo", BillingTo);
            htParam.Add("Description", Description);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().EditCreditCardMaster(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int InsertCreditCardHeaderMaster(string Header, string Status, string Description)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("Header", Header);
            htParam.Add("Status", Status);
            htParam.Add("Description", Description);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertCreditCardHeaderMaster(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int EditCreditCardHeaderMaster(int HeaderID, string Header, string Status, string Description)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("HeaderID", HeaderID);
            htParam.Add("Header", Header);
            htParam.Add("Status", Status);
            htParam.Add("Description", Description);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().EditCreditCardHeaderMaster(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static string GetCreditCardHeaderMaster()
        {
            DataTable dt1 = new bllMaster().GetAllCreditCardHeaderMaster();
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
    }
}