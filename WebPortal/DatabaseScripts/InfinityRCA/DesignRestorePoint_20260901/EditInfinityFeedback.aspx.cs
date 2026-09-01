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
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class EditInfinityFeedback : System.Web.UI.Page
    {
        protected HiddenField hdnEmployeeID;

        protected void Page_Load(object sender, EventArgs e)
        {
            hdnEmployeeID.Value = EmployeeInfo.Current.EmployeeID.ToString();
        }

        [WebMethod]
        public static string GetFeedbackDetailsByID_NewFormat(int FeedbackID, string Subdomain)
        {
            DataTable dt1 = new bllMaster().GetFeedbackDetailsByID_NewFormat(FeedbackID, Subdomain);

            List<Dictionary<string, object>> columns = new List<Dictionary<string, object>>();
            Dictionary<string, object> column;

            if (dt1 != null)
            {
                foreach (DataColumn dc in dt1.Columns)
                {
                    column = new Dictionary<string, object>();
                }
            }

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
        public static string GetCreditAndServicingFeedbackHistory(int FeedbackID, string SubDomain)
        {
            DataTable dt1 = new bllMaster().GetCreditAndServicingFeedbackHistory(FeedbackID, SubDomain);
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
        public static string GetProductionDataForUpdateFeedback_NewFormat(string LoanNo)
        {
            DataTable dt1 = new bllMaster().GetProductionDataForUpdateFeedback_NewFormat(LoanNo);

            List<Dictionary<string, object>> columns = new List<Dictionary<string, object>>();
            Dictionary<string, object> column;

            if (dt1 != null)
            {
                foreach (DataColumn dc in dt1.Columns)
                {
                    column = new Dictionary<string, object>();
                }
            }

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
        public static int UpdateInfinityImportedFeedback_NewERP(int FeedbackID, string ProdIDs, string Category, string SubCategory, string ErrorField, string Screen, string ErrorType, string Finding, string FeedbackType, string Severity, string FeedbackStatus, string RCA, string Source, string FeedbackReceivedDate, bool IsDisplayInERP, string Subdomain)
        {
            int ReturnValue = 0;

            bool requiresFeedbackStatus = string.Equals(Severity, "Critical", StringComparison.OrdinalIgnoreCase)
                || string.Equals(Severity, "Non-Critical", StringComparison.OrdinalIgnoreCase);

            if (requiresFeedbackStatus)
            {
                if (string.Equals(FeedbackStatus, "Agree", StringComparison.OrdinalIgnoreCase))
                    FeedbackStatus = "Agree";
                else if (string.Equals(FeedbackStatus, "Disagree", StringComparison.OrdinalIgnoreCase))
                    FeedbackStatus = "Disagree";
                else
                    return 0;
            }
            else
            {
                FeedbackStatus = string.Empty;
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("FeedbackID", FeedbackID);
            htParam.Add("Category", Category);
            htParam.Add("Subcategory", SubCategory);
            htParam.Add("ErrorField", ErrorField);
            htParam.Add("Screen", Screen);
            htParam.Add("ErrorType", ErrorType);
            htParam.Add("Finding", Finding);
            htParam.Add("FeedbackType", FeedbackType);
            htParam.Add("Severity", Severity);
            htParam.Add("FeedbackStatus", FeedbackStatus);
            htParam.Add("RCA", RCA);
            htParam.Add("Source", Source);
            htParam.Add("FeedbackReceivedDate", FeedbackReceivedDate);
            htParam.Add("IsDisplayInERP", IsDisplayInERP);
            htParam.Add("Subdomain", Subdomain);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllMaster().UpdateInfinityImportedFeedback_NewERP(htParam);

            if (ProdIDs != "0")
            {
                string str_split = ProdIDs.Substring(2);
                string[] IDs = str_split.Split(',');

                foreach (var sub_str in IDs)
                {
                    Hashtable htProd = new Hashtable();
                    htProd.Add("FeedbackID", FeedbackID);
                    htProd.Add("ProdID", sub_str);
                    htProd.Add("Source", Source);
                    htProd.Add("Subdomain", Subdomain);
                    htProd.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    ReturnValue = new bllMaster().InsertInfinityImportedFeedback_NewERP(htProd);
                }
            }

            return ReturnValue;
        }

        [WebMethod]
        public static int UpdateFinalRemark(int FeedbackID, string FinalStatus, string FinalRemark, string Subdomain)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("FeedbackID", FeedbackID);
            htParam.Add("FinalStatus", FinalStatus);
            htParam.Add("FinalComments", FinalRemark);
            htParam.Add("Subdomain", Subdomain);
            htParam.Add("FinalStatusUpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllMaster().UpdateFinalStatusOfImporetdFeedback(htParam);


            return ReturnValue;
        }

    }
}
