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

namespace WebPortal.US
{
    public partial class FeedbackDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetLoanDetailsbyLoanNo(string DealNo, string LoanNo)
        {
            DataTable dt1 = new bllUS().GetLoanDetailsbyLoanNo(DealNo, LoanNo);
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
        public static string GetLoggedInUser()
        {
            DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUSProcessTask(int ProjectID)
        {
            DataTable dt1 = new bllUS().GetUSProcessList(ProjectID);
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
        public static string GetATRDetails(string DealNo, string LoanNo, string Type, int ProcessID)
        {
            DataTable dt1 = new bllUS().GetATRDetailsbyLoanNo(DealNo, LoanNo, Type, ProcessID);
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
        public static int InsertOtherFeedbacks(int ProjectID, int ProcessID, string DealNo, string LoanNo, string Finding, string Severity)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", ProjectID);
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("DealNo", DealNo);
            htParam.Add("LoanNo", LoanNo);
            htParam.Add("Finding", Finding);
            htParam.Add("Severity", Severity);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllUS().InsertOnShoreUSFeedbacks(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int InsertATRFeedbacks(int ProjectID, int ProcessID, string DealNo, string LoanNo, string Reviewer, string ReviewDate, string ATRSupported,
           string ReviewFindings, string SellerDisclosedDTIIssue, string NoOfBorrowers, string HighestBorrowerIncomeType, string NoOfSEBusiness,
           string NoOfRentalProperties, string Comments)
        {
            int returnvalue = 0;
            bool isATRSupported = ATRSupported == "Yes" ? true : false;
            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", ProjectID);
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("DealNo", DealNo);
            htParam.Add("LoanNo", LoanNo);
            htParam.Add("Reviewer", Reviewer);
            htParam.Add("ReviewDate", ReviewDate);
            htParam.Add("isATRSupported", isATRSupported);
            htParam.Add("ReviewFindings", ReviewFindings);
            htParam.Add("SellerDisclosedDTIIssue", SellerDisclosedDTIIssue);
            htParam.Add("NoOfBorrowers", NoOfBorrowers);
            htParam.Add("HighestBorrowerIncomeType", HighestBorrowerIncomeType);
            htParam.Add("NoOfSEBusiness", NoOfSEBusiness);
            htParam.Add("NoOfRentalProperties", NoOfRentalProperties);
            htParam.Add("Comments", Comments);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllUS().InsertOnShoreUSATRFeedbacks(htParam);
            return returnvalue;
        }
    }
}