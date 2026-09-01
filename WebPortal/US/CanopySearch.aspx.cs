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
    public partial class CanopySearch : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static List<Dictionary<string, object>> getLoansForGlobalSearch()
        {
            int currentEmployeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DataSet dataSet = new bllUS().getLoansForGlobalSearch_Canopy(currentEmployeeId);
            if (dataSet == null || dataSet.Tables.Count == 0)
            {
                return new List<Dictionary<string, object>>();
            }

            DataTable orders = dataSet.Tables[0];
            AddProcessStatus(orders, currentEmployeeId);

            DataColumn[] columns = orders.Columns.Cast<DataColumn>().ToArray();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>(orders.Rows.Count);
            foreach (DataRow dataRow in orders.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>(columns.Length);
                foreach (DataColumn column in columns)
                {
                    row.Add(column.ColumnName, dataRow[column]);
                }
                rows.Add(row);
            }

            return rows;
        }

        private static void AddProcessStatus(DataTable loans, int currentEmployeeId)
        {
            if (loans == null) return;

            if (!loans.Columns.Contains("_ProcessStatus")) loans.Columns.Add("_ProcessStatus", typeof(string));
            if (!loans.Columns.Contains("_ProcessName")) loans.Columns.Add("_ProcessName", typeof(string));
            if (!loans.Columns.Contains("_ProcessEmployeeName")) loans.Columns.Add("_ProcessEmployeeName", typeof(string));
            if (!loans.Columns.Contains("_ProcessEmployeeID")) loans.Columns.Add("_ProcessEmployeeID", typeof(int));
            if (!loans.Columns.Contains("_ProcessStatusDate")) loans.Columns.Add("_ProcessStatusDate", typeof(string));
            if (!loans.Columns.Contains("_CanStart")) loans.Columns.Add("_CanStart", typeof(bool));

            DataTable statuses = new bllUS().GetCanopySearchProcessStatuses();
            Dictionary<string, DataRow> exact = new Dictionary<string, DataRow>(StringComparer.OrdinalIgnoreCase);
            Dictionary<string, DataRow> byDealLoanScript = new Dictionary<string, DataRow>(StringComparer.OrdinalIgnoreCase);
            HashSet<string> completedQc = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            HashSet<string> occupiedQc = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            foreach (DataRow status in statuses.Rows)
            {
                string loan = Convert.ToString(status["LoanNo"]).Trim();
                string script = Convert.ToString(status["Script"]).Trim();
                SetBestStatus(exact, StatusKey(Convert.ToString(status["ProjectNumber"]), Convert.ToString(status["DealNo"]), loan, script), status);
                SetBestStatus(byDealLoanScript, DealLoanScriptKey(Convert.ToString(status["DealNo"]), loan, script), status);
                string process = Convert.ToString(status["ProcessName"]).Trim();
                if (string.Equals(Convert.ToString(status["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase)
                    && (string.Equals(process, "Credit QC", StringComparison.OrdinalIgnoreCase)
                        || string.Equals(process, "Compliance QC", StringComparison.OrdinalIgnoreCase)))
                {
                    completedQc.Add(StatusKey(Convert.ToString(status["ProjectNumber"]), Convert.ToString(status["DealNo"]), loan, script) + "\u001f" + process);
                    completedQc.Add(DealLoanScriptKey(Convert.ToString(status["DealNo"]), loan, script) + "\u001f" + process);
                }
                if (string.Equals(process, "Credit QC", StringComparison.OrdinalIgnoreCase)
                    || string.Equals(process, "Compliance QC", StringComparison.OrdinalIgnoreCase))
                {
                    occupiedQc.Add(StatusKey(Convert.ToString(status["ProjectNumber"]), Convert.ToString(status["DealNo"]), loan, script) + "\u001f" + process);
                    occupiedQc.Add(DealLoanScriptKey(Convert.ToString(status["DealNo"]), loan, script) + "\u001f" + process);
                }
            }

            List<DataRow> completedLoans = new List<DataRow>();
            foreach (DataRow row in loans.Rows)
            {
                string project = Value(row, "Client", "ProjectNumber", "ProjectNo", "Project No", "Project #");
                string deal = Value(row, "Deal #", "DealNo", "Deal No");
                string loan = Value(row, "Loan #", "LoanNo", "Loan No", "OrderNumber", "Order Number");
                string script = Value(row, "Script", "ScriptName", "Script Name");
                DataRow status;

                if (!exact.TryGetValue(StatusKey(project, deal, loan, script), out status))
                {
                    byDealLoanScript.TryGetValue(DealLoanScriptKey(deal, loan, script), out status);
                }

                row["_ProcessStatus"] = status == null ? "Not Started" : Convert.ToString(status["ProcessStatus"]);
                row["_ProcessName"] = status == null ? "" : Convert.ToString(status["ProcessName"]);
                row["_ProcessEmployeeName"] = status == null ? "" : Convert.ToString(status["ProcessEmployeeName"]);
                int processEmployeeId = status == null ? 0 : Convert.ToInt32(status["ProcessEmployeeID"]);
                row["_ProcessEmployeeID"] = processEmployeeId;
                row["_ProcessStatusDate"] = status == null ? "" : Convert.ToString(status["ProcessStatusDate"]);
                bool isCompleted = status != null && string.Equals(Convert.ToString(status["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase);
                row["_CanStart"] = !isCompleted || processEmployeeId == currentEmployeeId;

                string exactKey = StatusKey(project, deal, loan, script) + "\u001f";
                string fallbackKey = DealLoanScriptKey(deal, loan, script) + "\u001f";
                bool creditCompleted = completedQc.Contains(exactKey + "Credit QC") || completedQc.Contains(fallbackKey + "Credit QC");
                bool complianceCompleted = completedQc.Contains(exactKey + "Compliance QC") || completedQc.Contains(fallbackKey + "Compliance QC");
                bool creditOccupied = occupiedQc.Contains(exactKey + "Credit QC") || occupiedQc.Contains(fallbackKey + "Credit QC");
                bool complianceOccupied = occupiedQc.Contains(exactKey + "Compliance QC") || occupiedQc.Contains(fallbackKey + "Compliance QC");
                if (creditOccupied && complianceOccupied) row["_CanStart"] = false;
                if (creditCompleted && complianceCompleted) completedLoans.Add(row);
            }

            foreach (DataRow row in completedLoans) loans.Rows.Remove(row);
        }

        private static void SetBestStatus(Dictionary<string, DataRow> lookup, string key, DataRow candidate)
        {
            DataRow current;
            if (!lookup.TryGetValue(key, out current) || IsBetterStatus(candidate, current))
            {
                lookup[key] = candidate;
            }
        }

        private static bool IsBetterStatus(DataRow candidate, DataRow current)
        {
            bool candidateCompleted = string.Equals(Convert.ToString(candidate["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase);
            bool currentCompleted = string.Equals(Convert.ToString(current["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase);
            if (candidateCompleted != currentCompleted) return candidateCompleted;
            return string.Compare(Convert.ToString(candidate["ProcessStatusDate"]), Convert.ToString(current["ProcessStatusDate"]), StringComparison.OrdinalIgnoreCase) > 0;
        }

        private static string StatusKey(string project, string deal, string loan, string script) { return (project ?? "").Trim() + "\u001f" + (deal ?? "").Trim() + "\u001f" + (loan ?? "").Trim() + "\u001f" + (script ?? "").Trim(); }
        private static string DealLoanScriptKey(string deal, string loan, string script) { return (deal ?? "").Trim() + "\u001f" + (loan ?? "").Trim() + "\u001f" + (script ?? "").Trim(); }
        private static string Value(DataRow row, params string[] columns) { foreach (string column in columns) if (row.Table.Columns.Contains(column) && row[column] != DBNull.Value && !string.IsNullOrWhiteSpace(Convert.ToString(row[column]))) return Convert.ToString(row[column]).Trim(); return ""; }

        [WebMethod]
        public static int StartLoan(int ProcessID, string ProjectNumber, string DealNo, string OrderNumber, string OrderDate, string Process, string Review, string StartDatetime, string Script)
        {
            if (string.IsNullOrWhiteSpace(DealNo) || string.IsNullOrWhiteSpace(OrderNumber))
            {
                return 0;
            }

            int currentEmployeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            if (!new bllUS().CanStartCanopyLoan(DealNo, OrderNumber, Script, currentEmployeeId))
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
                Script,
                Review,
                startDateTime.ToString("yyyy-MM-ddTHH:mm:ss"),
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

        private static int SaveLoanProductionTrack(string Action, int ProcessID, string ProjectNumber, string DealNo, string LoanNo, string OrderDate, string Process, string Script, string Review, string StartDatetime, string EndDatetime)
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
                htParam.Add("Script", Script);
                htParam.Add("Review", Review);
                htParam.Add("StartDatetime", StartDatetime);
                htParam.Add("EndDatetime", EndDatetime);
                htParam.Add("SourcePage", "CanopySearch");
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
