using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class AddFeedback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetLoanDetails_RemoteUW_ByID(int ProcessID)
        {
            DataTable dt1 = new bllUS().GetLoanDetails_RemoteUW_ByID(ProcessID);

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
        public static string GetUSImportedFeedback_ByUser_NewERP(string LoanNo)
        {
            DataTable dt1 = new bllUS().GetUSImportedFeedback_ByUser_NewERP(LoanNo, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

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
        public static int InsertUSImportedFeedback_NewERP(string LoanNo, string Client, string UWName, string DateReviewed, string QCDate, string Finding, string Severity, string Source, string FeedbackReceivedDate)
        {
            int ReturnValue = 0;

            string QCName = "";

            Hashtable htParam = new Hashtable();
            htParam.Add("LoanNo", LoanNo);
            htParam.Add("Client", Client);
            htParam.Add("UWName", UWName);
            htParam.Add("QCName", QCName);
            htParam.Add("DateReviewed", DateReviewed);
            htParam.Add("QCDate", QCDate);
            htParam.Add("Finding", Finding);
            htParam.Add("Severity", Severity);
            htParam.Add("Source", Source);
            htParam.Add("FeedbackReceivedDate", FeedbackReceivedDate);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllUS().InsertUSImportedFeedback_NewERP(htParam);

            return ReturnValue;
        }
    }
}