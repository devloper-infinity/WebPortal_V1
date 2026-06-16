using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.IT
{
    public partial class HostingMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllAssetsTypesByGroupID(int GroupID)
        {
            DataTable dt1 = new bllAsset().BindAssetType(GroupID);
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
        public static string GetAllHostingDetails()
        {
            DataTable dt1 = new bllAsset().GetAllHostingDetails();
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
        public static int InsertAssets(string Type, string DomainName, string Provider, string RenewedDate, string AdvanceRenewalDate, string ExpiryDate, string RenewelPeriod, string CostPaid, string NextRenewalCost, string AveragePerYear, string EmailID, string CreditCardNo, string CPanelLink, string WebLink, string Remark)
        {
            Hashtable htParam = new Hashtable();
            htParam.Add("Type", Type);
            htParam.Add("DomainName", DomainName);
            htParam.Add("Provider", Provider);
            htParam.Add("RenewedDate", RenewedDate);
            htParam.Add("AdvanceRenewalDate", AdvanceRenewalDate);
            htParam.Add("ExpiryDate", ExpiryDate);
            htParam.Add("RenewelPeriod", RenewelPeriod);
            htParam.Add("CostPaid", CostPaid);
            htParam.Add("NextRenewalCost", NextRenewalCost);
            htParam.Add("AveragePerYear", AveragePerYear);
            htParam.Add("EmailID", EmailID);
            htParam.Add("CreditCardNo", CreditCardNo);
            htParam.Add("CPanelLink", CPanelLink);
            htParam.Add("WebLink", WebLink);
            htParam.Add("Remark", Remark);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            int ReturnValue = new bllAsset().InsertHostingDetails(htParam);

            return ReturnValue;
        }
    }
}