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
    public partial class EditSecuritizationTracking : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetReportData()
        {
            DataTable dt1 = new bllMaster().GetReportData();
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
        public static string GetSecuritizationByID(int SecureID)
        {
            DataTable dt1 = new bllMaster().GetSecuritizationByID(SecureID);
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
        public static int UpdateSecuritizationRelLetter(int SecureID, int ProjectId, string ClientDealName, string OriginalRequestDate, int LoanCount, string TaskName, string RequestedDate, string SLADelieryDate, string ActualDeliveryDate, string Remark, string Status, string SLADeliveryDays, string RLSigned, string BillingHours, string CLientNameAddress, string RecepientNameAddress, string AgencyNameAddress)
        {
            int returnvalue = 0;

            Hashtable htParam = new Hashtable();

            htParam.Add("SecureID", SecureID);
            htParam.Add("Projectid", ProjectId);
            htParam.Add("ClientDealName", ClientDealName);
            htParam.Add("OriginalRequestDate", OriginalRequestDate);
            htParam.Add("LoanCount", LoanCount);
            htParam.Add("TaskName", TaskName);
            htParam.Add("RequestedDate", RequestedDate);
            htParam.Add("SLADeliveryDate", SLADelieryDate);
            htParam.Add("ActualDeliveredDate", ActualDeliveryDate);
            htParam.Add("Remark", Remark);
            htParam.Add("Status", Status);
            htParam.Add("SLADeliveryDays", SLADeliveryDays);
            htParam.Add("RLSigned", RLSigned);
            htParam.Add("BillingHours", BillingHours);
            htParam.Add("ClientNameAddress", CLientNameAddress);
            htParam.Add("RecipientNameAddress", RecepientNameAddress);
            htParam.Add("AgencyNameAddress", AgencyNameAddress);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue =  new bllMaster().UpdateSecuritizationRelLetter(htParam);
            return returnvalue;
        }
    }
}