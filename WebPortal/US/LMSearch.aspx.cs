using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class LMSearch : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static List<Dictionary<string, object>> getLoansForGlobalSearch()
        {
            int employeeId = int.Parse(HttpContext.Current.User.Identity.Name);
            DataSet dataSet = new bllUS().getLoansForGlobalSearch_Canopy_LauraMac();
            if (dataSet == null || dataSet.Tables.Count == 0)
                return new List<Dictionary<string, object>>();

            DataTable loans = dataSet.Tables[0];
            AddProcessStatus(loans, employeeId);
            DataColumn[] columns = loans.Columns.Cast<DataColumn>().ToArray();
            return loans.AsEnumerable().Select(row => columns.ToDictionary(
                column => column.ColumnName,
                column => row[column] == DBNull.Value ? null : row[column])).ToList();
        }

        private static void AddProcessStatus(DataTable loans, int employeeId)
        {
            foreach (string name in new[] { "_ProcessStatus", "_ProcessName", "_ProcessEmployeeName", "_ProcessStatusDate", "_ProcessSummary" })
                if (!loans.Columns.Contains(name)) loans.Columns.Add(name, typeof(string));
            if (!loans.Columns.Contains("_CanStart")) loans.Columns.Add("_CanStart", typeof(bool));

            DataTable statuses = new bllUS().GetLauraMacSearchProcessStatuses();
            List<DataRow> completedLoans = new List<DataRow>();
            foreach (DataRow loan in loans.Rows)
            {
                string project = Value(loan, "Client", "ProjectNumber", "ProjectNo", "Project No", "Project #");
                string number = Value(loan, "Loan #", "LoanNo", "Loan No", "OrderNumber", "Order Number");
                string script = Value(loan, "Script", "ScriptName", "Script Name");
                List<DataRow> matched = statuses.AsEnumerable()
                    .Where(row => Same(row, "ProjectNumber", project) && Same(row, "LoanNo", number))
                    .ToList();
                List<DataRow> exactScript = matched.Where(row => Same(row, "Script", script)).ToList();
                if (exactScript.Count > 0) matched = exactScript;
                matched = matched.Where(row => string.Equals(Convert.ToString(row["ProcessName"]), "Credit QC", StringComparison.OrdinalIgnoreCase)
                    || string.Equals(Convert.ToString(row["ProcessName"]), "Compliance QC", StringComparison.OrdinalIgnoreCase)).ToList();
                DataRow status = matched
                    .OrderByDescending(row => string.Equals(Convert.ToString(row["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase))
                    .ThenByDescending(row => Convert.ToString(row["ProcessStatusDate"]))
                    .FirstOrDefault();

                loan["_ProcessStatus"] = status == null ? "Not Started" : Convert.ToString(status["ProcessStatus"]);
                loan["_ProcessName"] = status == null ? "" : Convert.ToString(status["ProcessName"]);
                loan["_ProcessEmployeeName"] = status == null ? "" : Convert.ToString(status["ProcessEmployeeName"]);
                loan["_ProcessStatusDate"] = status == null ? "" : Convert.ToString(status["ProcessStatusDate"]);
                loan["_ProcessSummary"] = string.Join("||", matched
                    .GroupBy(row => Convert.ToString(row["ProcessName"]), StringComparer.OrdinalIgnoreCase)
                    .Select(group => group.OrderByDescending(row => string.Equals(Convert.ToString(row["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase))
                        .ThenByDescending(row => Convert.ToString(row["ProcessStatusDate"])).First())
                    .OrderBy(row => Convert.ToString(row["ProcessName"]))
                    .Select(row => Convert.ToString(row["ProcessName"]) + ": " + Convert.ToString(row["ProcessStatus"]) + " - "
                        + Convert.ToString(row["ProcessEmployeeName"]) + " - " + Convert.ToString(row["ProcessStatusDate"])));
                loan["_CanStart"] = status == null || !string.Equals(Convert.ToString(status["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase)
                    || Convert.ToInt32(status["ProcessEmployeeID"]) == employeeId;
                bool creditCompleted = matched.Any(row => string.Equals(Convert.ToString(row["ProcessName"]), "Credit QC", StringComparison.OrdinalIgnoreCase)
                    && string.Equals(Convert.ToString(row["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase));
                bool complianceCompleted = matched.Any(row => string.Equals(Convert.ToString(row["ProcessName"]), "Compliance QC", StringComparison.OrdinalIgnoreCase)
                    && string.Equals(Convert.ToString(row["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase));
                if (creditCompleted && complianceCompleted) completedLoans.Add(loan);
            }
            foreach (DataRow loan in completedLoans) loans.Rows.Remove(loan);
        }

        [WebMethod]
        public static int StartLoan(int ProcessID, string Client, string LoanNo, string OrderDate, string Process, string Script)
        {
            return 1;
        }

        private static bool Same(DataRow row, string column, string value)
        {
            return string.Equals(Convert.ToString(row[column]).Trim(), (value ?? "").Trim(), StringComparison.OrdinalIgnoreCase);
        }

        private static string Value(DataRow row, params string[] columns)
        {
            foreach (string column in columns)
                if (row.Table.Columns.Contains(column) && row[column] != DBNull.Value && !string.IsNullOrWhiteSpace(Convert.ToString(row[column])))
                    return Convert.ToString(row[column]).Trim();
            return "";
        }
    }
}
