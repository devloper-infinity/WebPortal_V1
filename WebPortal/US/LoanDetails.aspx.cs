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
    public partial class LoanDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetLoanDetails_RemoteUW_REQC()
        {
            DataTable dt1 = new bllUS().GetLoanDetails_RemoteUW_REQC(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

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
        public static int StartLoan(int ProcessID, string ProjectNumber, string DealNo, string OrderNumber, string OrderDate, string Process, string Review)
        {
            DateTime startDateTime = DateTime.Now;
            int ReturnValue = SaveLoanTiming(
                ProjectNumber,
                DealNo,
                OrderNumber,
                Process,
                Review,
                startDateTime.ToString("MM/dd/yyyy HH:mm:ss"),
                "",
                "Start",
                "Pending"
            );

            if (ReturnValue > 0)
            {
                SaveLoanProductionTrack(
                    "Start",
                    ProcessID,
                    ProjectNumber,
                    DealNo,
                    OrderNumber,
                    OrderDate,
                    Process,
                    Review,
                    startDateTime.ToString("yyyy-MM-dd HH:mm:ss"),
                    ""
                );
            }

            return ReturnValue;
        }

        [WebMethod]
        public static int InsertModifyUWOrderOC22Servicing(string ProjectNumber, string DealNo, string OrderNumber, string Process, string Review, string StartTime, string EndTime)
        {
            return SaveLoanTiming(
                ProjectNumber,
                DealNo,
                OrderNumber,
                Process,
                Review,
                NormalizeDateTime(StartTime),
                NormalizeDateTime(EndTime),
                "Complete",
                "Completed"
            );
        }

        private static int SaveLoanTiming(string ProjectNumber, string DealNo, string OrderNumber, string Process, string Review, string StartTime, string EndTime, string ProductType, string Status)
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
            htParam.Add("ProductType", ProductType);
            htParam.Add("Status", Status);
            htParam.Add("Remark", "online");
            htParam.Add("AddedBY", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue =  new bllUS().InsertModifyUWOrderOC22Servicing(htParam);

            return ReturnValue;
        }

        private static string NormalizeDateTime(string value)
        {
            return string.IsNullOrWhiteSpace(value) ? "" : value.Replace("T", " ");
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
                htParam.Add("EmployeeID", currentEmployeeId);
                htParam.Add("AddedBy", currentEmployeeId);

                new bllUS().SaveUSLoanProductionTrack(htParam);
            }
            catch
            {
            }
        }

    }
}
