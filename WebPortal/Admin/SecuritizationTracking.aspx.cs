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
    public partial class SecuritizationTracking : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string GetAllSecuritizationData()
        {
            DataTable dt1 = new bllMaster().GetAllSecuritizationData();
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
        public static string GetAllDealsFromProjectTracking()
        {
            DataTable dt1 = new bllMaster().GetAllDealsFromProjectTracking();
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
        public static string GetUWProjects()
        {
            DataTable dt1 = new bllMaster().GetUWProjects();
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
        public static int InsertSecuritizationRelianceLetter(int ProjectId, string DealNo, string ClientName, string ClientDealName, int LoanCount, string TaskName, string RequestedDate, string SLADelieryDate, string ActualDeliveryDate, string Remark, string Status, string SLADeliveryDays, string RLSigned, string BillingHours, string CLientNameAddress, string RecepientNameAddress, string AgencyNameAddress)
        {
            int returnvalue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("Projectid", ProjectId);
            htParam.Add("DealNo", DealNo);
            htParam.Add("ClientName", ClientName);
            htParam.Add("ClientDealName", ClientDealName);
            htParam.Add("LoanCount", LoanCount);
            htParam.Add("TaskName", TaskName);
            htParam.Add("RequestedDate", RequestedDate);
            htParam.Add("SLADeliveryDate", SLADelieryDate);
            htParam.Add("SLADeliveryDays", SLADeliveryDays);
            htParam.Add("ActualDeliveredDate", ActualDeliveryDate);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("Remark", Remark);
            htParam.Add("Status", Status);
            htParam.Add("RLSigned", RLSigned);
            htParam.Add("BillingHours", BillingHours);
            htParam.Add("ClientNameAddress", CLientNameAddress);
            htParam.Add("RecipientNameAddress", RecepientNameAddress);
            htParam.Add("AgencyNameAddress", AgencyNameAddress);

            returnvalue =  new bllMaster().InsertSecuritizationRelLetter(htParam);
            return returnvalue;
        }


        [WebMethod]
        public static int InsertProjectInfo(string Project, string Company, string ContactPerson, string ContactNo, string EmailID, string Website, string Address, string Remark)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("Project", Project);
            htParam.Add("Company", Company);
            htParam.Add("ContactPerson", ContactPerson);
            htParam.Add("ContactNo", ContactNo);
            htParam.Add("EmailID", EmailID);
            htParam.Add("Website", Website);
            htParam.Add("Address", Address);
            htParam.Add("Remark", Remark);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue =  new bllMaster().InsertProjectInfo(htParam);

            return ReturnValue;
        }
    }
}