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
    public partial class GlobalSearch : System.Web.UI.Page
    {
        static DataSet ds = null;
        static DataTable dtOrders = null;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string getLoansForGlobalSearch()
        {
            ds = new bllUS().getLoansForGlobalSearch(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (ds != null)
            {
                dtOrders = ds.Tables[0];
                AddReQcStatus(dtOrders);
                foreach (DataRow dr in dtOrders.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dtOrders.Columns)
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

        private static void AddReQcStatus(DataTable loans)
        {
            if (loans == null) return;
            if (!loans.Columns.Contains("_ReQCStatus")) loans.Columns.Add("_ReQCStatus", typeof(string));
            if (!loans.Columns.Contains("_ReQCProcess")) loans.Columns.Add("_ReQCProcess", typeof(string));
            if (!loans.Columns.Contains("_ReQCEmployeeName")) loans.Columns.Add("_ReQCEmployeeName", typeof(string));
            if (!loans.Columns.Contains("_ReQCDate")) loans.Columns.Add("_ReQCDate", typeof(string));

            List<string> loanNumbers = loans.Rows.Cast<DataRow>().Select(x => Value(x, "Loan #", "LoanNo", "Loan No", "OrderNumber", "Order Number")).Where(x => x.Length > 0).Distinct(StringComparer.OrdinalIgnoreCase).ToList();
            DataTable statuses = new bllUS().GetGlobalSearchReQcStatuses(loanNumbers);
            Dictionary<string, DataRow> exact = new Dictionary<string, DataRow>(StringComparer.OrdinalIgnoreCase);
            Dictionary<string, List<DataRow>> byLoan = new Dictionary<string, List<DataRow>>(StringComparer.OrdinalIgnoreCase);
            foreach (DataRow status in statuses.Rows)
            {
                string loan = Convert.ToString(status["LoanNo"]).Trim(); exact[StatusKey(Convert.ToString(status["ProjectNumber"]), Convert.ToString(status["DealNo"]), loan)] = status;
                if (!byLoan.ContainsKey(loan)) byLoan[loan] = new List<DataRow>(); byLoan[loan].Add(status);
            }
            foreach (DataRow row in loans.Rows)
            {
                string project = Value(row, "Client", "ProjectNumber", "ProjectNo", "Project No", "Project #"), deal = Value(row, "Deal #", "DealNo", "Deal No"), loan = Value(row, "Loan #", "LoanNo", "Loan No", "OrderNumber", "Order Number"); DataRow status;
                if (!exact.TryGetValue(StatusKey(project, deal, loan), out status)) { List<DataRow> matches; status = byLoan.TryGetValue(loan, out matches) && matches.Count == 1 ? matches[0] : null; }
                row["_ReQCStatus"] = status == null ? "Not Assigned" : Convert.ToString(status["ReQCStatus"]);
                row["_ReQCProcess"] = status == null ? "" : Convert.ToString(status["ReQCProcess"]);
                row["_ReQCEmployeeName"] = status == null ? "" : Convert.ToString(status["ReQCEmployeeName"]);
                row["_ReQCDate"] = status == null ? "" : Convert.ToString(status["ReQCDate"]);
            }
        }

        private static string StatusKey(string project, string deal, string loan) { return (project ?? "").Trim() + "\u001f" + (deal ?? "").Trim() + "\u001f" + (loan ?? "").Trim(); }
        private static string Value(DataRow row, params string[] columns) { foreach (string column in columns) if (row.Table.Columns.Contains(column) && row[column] != DBNull.Value && !string.IsNullOrWhiteSpace(Convert.ToString(row[column]))) return Convert.ToString(row[column]).Trim(); return ""; }

        [WebMethod]
        public static int StartLoan(int ProcessID, string ProjectNumber, string DealNo, string OrderNumber, string OrderDate, string Process, string Review, string StartDatetime)
        {
            if (string.IsNullOrWhiteSpace(DealNo) || string.IsNullOrWhiteSpace(OrderNumber))
            {
                return 0;
            }

            DateTime startDateTime = DateTime.Now;


            int ReturnValue = 0;
            try
            {
                ReturnValue = SaveLoanTiming(
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
            }
            catch
            {
            }

            int trackReturnValue = SaveLoanProductionTrack(
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

            return trackReturnValue > 0 ? trackReturnValue : ReturnValue;
        }

        private static int SaveLoanTiming(string ProjectNumber, string DealNo, string OrderNumber, string Process, string Review, string StartTime, string EndTime, string ProductType, string Status)
        {
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

            return new bllUS().InsertModifyUWOrderOC22Servicing(htParam);
        }

        private static int SaveLoanProductionTrack(string Action, int ProcessID, string ProjectNumber, string DealNo, string LoanNo, string OrderDate, string Process, string Review, string StartDatetime, string EndDatetime)
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
                htParam.Add("SourcePage", "GlobalSearch");
                htParam.Add("EmployeeID", currentEmployeeId);
                htParam.Add("AddedBy", currentEmployeeId);

                return new bllUS().SaveUSLoanProductionTrack(htParam);
            }
            catch
            {
                return 0;
            }
        }

        private static string NormalizeDateTime(string value)
        {
            return string.IsNullOrWhiteSpace(value) ? "" : value.Replace("T", " ");
        }
    }
}
