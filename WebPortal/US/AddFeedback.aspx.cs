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

        [WebMethod]
        public static int UpdateUSImportedFeedback_NewERP(int FeedbackID, string LoanNo, string Client, string Finding, string Severity)
        {
            Hashtable htParam = new Hashtable();
            htParam.Add("FeedbackID", FeedbackID);
            htParam.Add("LoanNo", LoanNo);
            htParam.Add("Client", Client);
            htParam.Add("Finding", Finding);
            htParam.Add("Severity", Severity);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            return new bllUS().UpdateUSImportedFeedback_NewERP(htParam);
        }

        [WebMethod]
        public static int DeleteUSImportedFeedback_NewERP(int FeedbackID, string LoanNo, string Client)
        {
            Hashtable htParam = new Hashtable();
            htParam.Add("FeedbackID", FeedbackID);
            htParam.Add("LoanNo", LoanNo);
            htParam.Add("Client", Client);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            return new bllUS().DeleteUSImportedFeedback_NewERP(htParam);
        }

        [WebMethod]
        public static int CompleteLoan(int ProcessID)
        {
            DataTable dt = new bllUS().GetLoanDetails_RemoteUW_ByID(ProcessID);

            if (dt == null || dt.Rows.Count == 0)
            {
                return 0;
            }

            DataRow row = dt.Rows[0];
            DateTime endDateTime = DateTime.Now;

            string ProjectNumber = GetRowValue(row, "ProjectNo", "ProjectNumber", "Client");
            string DealNo = GetRowValue(row, "DealNo");
            string LoanNo = GetRowValue(row, "LoanNo", "OrderNumber");
            string Process = GetRowValue(row, "Process");
            string Review = GetRowValue(row, "RemoteUW", "Review", "UWName");
            string StartDatetime = NormalizeDateTime(GetRowValue(row, "ReviewStartTime", "StartTime", "StartDateTime", "StartDate", "HStartDate"));
            string OrderDate = GetRowValue(row, "OrderDate");

            int ReturnValue = SaveLoanTiming(
                ProjectNumber,
                DealNo,
                LoanNo,
                Process,
                Review,
                StartDatetime,
                endDateTime.ToString("MM/dd/yyyy HH:mm:ss")
            );

            if (ReturnValue > 0)
            {
                SaveLoanProductionTrack(
                    "Complete",
                    ProcessID,
                    ProjectNumber,
                    DealNo,
                    LoanNo,
                    OrderDate,
                    Process,
                    Review,
                    StartDatetime,
                    endDateTime.ToString("yyyy-MM-dd HH:mm:ss")
                );
            }

            return ReturnValue;
        }

        private static int SaveLoanTiming(string ProjectNumber, string DealNo, string OrderNumber, string Process, string Review, string StartTime, string EndTime)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectNumber", ProjectNumber);
            htParam.Add("DealNo", DealNo);
            htParam.Add("OrderNumber", OrderNumber);
            htParam.Add("Process", Process);
            htParam.Add("Review", Review);
            htParam.Add("ReviewStartTime", StartTime);
            htParam.Add("ReviewEndTime", EndTime);
            htParam.Add("Type", "Default");
            htParam.Add("ProductType", "Complete");
            htParam.Add("Status", "Completed");
            htParam.Add("Remark", "online");
            htParam.Add("AddedBY", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllUS().InsertModifyUWOrderOC22Servicing(htParam);

            return ReturnValue;
        }

        private static void SaveLoanProductionTrack(string Action, int ProcessID, string ProjectNumber, string DealNo, string LoanNo, string OrderDate, string Process, string Review, string StartDatetime, string EndDatetime)
        {
            try
            {
                int currentEmployeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
                Hashtable htParam = new Hashtable();
                htParam.Add("Action", Action);
                htParam.Add("ProcessID", ProcessID);
                htParam.Add("ProjectNumber", ProjectNumber);
                htParam.Add("DealNo", DealNo);
                htParam.Add("LoanNo", LoanNo);
                htParam.Add("OrderDate", OrderDate);
                htParam.Add("Process", Process);
                htParam.Add("Review", Review);
                htParam.Add("StartDatetime", StartDatetime);
                htParam.Add("EndDatetime", EndDatetime);
                htParam.Add("SourcePage", "MyTask");
                htParam.Add("EmployeeID", currentEmployeeId);
                htParam.Add("AddedBy", currentEmployeeId);

                new bllUS().SaveUSLoanProductionTrack(htParam);
            }
            catch
            {
            }
        }

        private static string GetRowValue(DataRow row, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
            {
                if (row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value)
                {
                    return Convert.ToString(row[columnName]);
                }
            }

            return "";
        }

        private static string NormalizeDateTime(string value)
        {
            return string.IsNullOrWhiteSpace(value) ? "" : value.Replace("T", " ");
        }
    }
}
