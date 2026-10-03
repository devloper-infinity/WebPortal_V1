using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;

namespace InfinityERP.UnderwritingBilling
{
    public sealed class UnderwritingBillingValidationService
    {
        private readonly string connectionString;
        public UnderwritingBillingValidationService(string connectionString) { this.connectionString = connectionString; }

        public BillingValidationResult GetPendingBillingData(int employeeId, DateTime billingMonth, DateTime toDate)
        {
            EnsureUnderwritingUser(employeeId);
            DateTime month = new DateTime(billingMonth.Year, billingMonth.Month, 1);
            DateTime cutoff = toDate.Date > month.AddMonths(1).AddDays(-1) ? month.AddMonths(1).AddDays(-1) : toDate.Date;
            DataSet data = new DataSet();
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand("dbo.usp_GetAllProjectsBillingDetails", connection))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 180;
                command.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                command.Parameters.Add("@Month", SqlDbType.NVarChar, 100).Value = month.ToString("MMMM", CultureInfo.InvariantCulture);
                command.Parameters.Add("@Year", SqlDbType.Int).Value = month.Year;
                command.Parameters.Add("@ToDate", SqlDbType.Date).Value = cutoff;
                adapter.Fill(data);
            }

            Dictionary<string, RemarkInfo> remarks = LoadRemarks(data, month);
            BillingValidationResult result = new BillingValidationResult { BillingMonth = month, PeriodTo = cutoff };
            foreach (DataTable table in data.Tables)
            {
                if (table.Rows.Count == 0 || table.Columns.Count == 0) continue;
                BillingProject project = BuildProject(table, remarks, month, employeeId == 255 || employeeId == 6 || employeeId == 40 || employeeId == 318, employeeId == 6);
                result.Projects.Add(project);
                result.Summary.Add(project.Summary);
                result.BlankLoans.AddRange(project.BlankLoans);
                result.PendingLoans.AddRange(project.PendingLoans);
            }
            return result;
        }

        public bool HasBlockingPending(int employeeId, DateTime billingMonth, DateTime toDate)
        {
            BillingValidationResult result = GetPendingBillingData(employeeId, billingMonth, toDate);
            foreach (BlankBillingLoan loan in result.BlankLoans) if (!loan.HasValidRemark) return true;
            return false;
        }

        private Dictionary<string, RemarkInfo> LoadRemarks(DataSet data, DateTime billingMonth)
        {
            HashSet<int> ids = new HashSet<int>();
            foreach (DataTable table in data.Tables)
                if (table.Columns.Contains("__ProjectID")) foreach (DataRow row in table.Rows)
                    if (row["__ProjectID"] != DBNull.Value) ids.Add(Convert.ToInt32(row["__ProjectID"]));
            Dictionary<string, RemarkInfo> result = new Dictionary<string, RemarkInfo>(StringComparer.OrdinalIgnoreCase);
            if (ids.Count == 0) return result;
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = connection.CreateCommand())
            {
                StringBuilder sql = new StringBuilder("SELECT r.ProjectID,r.DealNo,r.LoanIdentifier,r.PendingSignature,r.Remark,r.AddedBy,r.AddedDate,r.UpdatedBy,r.UpdatedDate,ISNULL(e.Code,CONVERT(varchar(20),COALESCE(r.UpdatedBy,r.AddedBy))) RemarkBy FROM dbo.ProjectBillingParameterRemark r LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=COALESCE(r.UpdatedBy,r.AddedBy) WHERE r.BillingMonth=@Month AND r.ProjectID IN (");
                command.Parameters.Add("@Month", SqlDbType.Date).Value = billingMonth;
                int index = 0;
                foreach (int id in ids)
                {
                    if (index > 0) sql.Append(',');
                    string name = "@P" + index++;
                    sql.Append(name); command.Parameters.Add(name, SqlDbType.Int).Value = id;
                }
                command.CommandText = sql.Append(')').ToString(); connection.Open();
                using (SqlDataReader reader = command.ExecuteReader()) while (reader.Read())
                {
                    RemarkInfo info = new RemarkInfo
                    {
                        Signature = Convert.ToString(reader[3]), Remark = Convert.ToString(reader[4]), AddedBy = Convert.ToString(reader[9]),
                        RemarkDate = reader[8] == DBNull.Value ? Convert.ToDateTime(reader[6]) : Convert.ToDateTime(reader[8])
                    };
                    result[Key(reader.GetInt32(0), Convert.ToString(reader[1]), Convert.ToString(reader[2]))] = info;
                }
            }
            return result;
        }

        private static BillingProject BuildProject(DataTable table, Dictionary<string, RemarkInfo> remarks, DateTime billingMonth, bool isCommitment, bool useRecordQuantities)
        {
            int idIndex = Find(table, "__ProjectID"), projectIndex = Find(table, "Project #"), dealIndex = Find(table, "Deal #", "Deal No");
            int loanIndex = Find(table, "Loan #", "Loan #1", "Loan No", "Loan Number", "Order #", "Order No", "Order Number");
            int finalStatusIndex = Find(table, "Final Status");
            int hiddenDispatchIndex = Find(table, "__DispatchDate"), billingDispatchIndex = FindVisibleDispatchColumn(table);
            bool dispatchConfigured = hiddenDispatchIndex >= 0 || billingDispatchIndex >= 0;
            int projectId = idIndex >= 0 ? Convert.ToInt32(table.Rows[0][idIndex]) : 0;
            int recordCountIndex = Find(table, "No of Records", "No. of Records", "Number of Records");
            int dispatchedRecordCountIndex = Find(table, "No of Dispatched Records", "No. of Dispatched Records", "Dispatched Record", "Dispatched Records");
            int cancelledRecordCountIndex = Find(table, "Cancelled Record", "Cancelled Records", "Rejected Record", "Rejected Records");
            bool quantityMode = useRecordQuantities && (projectId == 47 || projectId == 137) && recordCountIndex >= 0 && dispatchedRecordCountIndex >= 0;
            if (quantityMode) dispatchConfigured = true;
            string projectName = Text(table.Rows[0][projectIndex >= 0 ? projectIndex : 0]);
            BillingProject project = new BillingProject { ProjectID = projectId, ProjectName = projectName };
            project.Summary = new ProjectBillingSummary { ProjectID = projectId, ProjectName = projectName };
            List<int> visible = new List<int>();
            for (int i = 0; i < table.Columns.Count; i++) if (!IsTechnicalColumn(table.Columns[i].ColumnName))
            { visible.Add(i); project.Columns.Add(table.Columns[i].ColumnName); }
            Dictionary<string, DealBillingSummary> deals = new Dictionary<string, DealBillingSummary>(StringComparer.OrdinalIgnoreCase);
            foreach (DataRow row in table.Rows)
            {
                List<string> values = new List<string>(); foreach (int i in visible) values.Add(Text(row[i])); project.Rows.Add(values);
                string deal = !isCommitment && dealIndex >= 0 ? Text(row[dealIndex]) : String.Empty;
                string loan = loanIndex >= 0 ? Text(row[loanIndex]) : String.Empty;
                string dispatch = hiddenDispatchIndex >= 0 ? Text(row[hiddenDispatchIndex]) : String.Empty;
                if (String.IsNullOrWhiteSpace(dispatch) && billingDispatchIndex >= 0) dispatch = Text(row[billingDispatchIndex]);
                int totalQuantity = quantityMode ? Quantity(row[recordCountIndex]) : 0;
                int dispatchedQuantity = quantityMode ? Quantity(row[dispatchedRecordCountIndex]) : 0;
                int cancelledQuantity = quantityMode && cancelledRecordCountIndex >= 0 ? Quantity(row[cancelledRecordCountIndex]) : 0;
                bool dispatched = quantityMode ? dispatchedQuantity + cancelledQuantity >= totalQuantity : dispatchConfigured && !String.IsNullOrWhiteSpace(dispatch);
                string finalStatus = finalStatusIndex >= 0 ? Text(row[finalStatusIndex]).Trim() : String.Empty;
                bool cancelled = !quantityMode && useRecordQuantities && (finalStatus.Equals("Cancelled", StringComparison.OrdinalIgnoreCase) || finalStatus.Equals("Canceled", StringComparison.OrdinalIgnoreCase));
                List<string> blanks = new List<string>();
                if (!isCommitment && dispatched && billingDispatchIndex >= 0) for (int i = billingDispatchIndex + 1; i < table.Columns.Count; i++)
                    if (!table.Columns[i].ColumnName.Equals("Final Status", StringComparison.OrdinalIgnoreCase) && !IsTechnicalColumn(table.Columns[i].ColumnName) && String.IsNullOrWhiteSpace(Text(row[i]))) blanks.Add(table.Columns[i].ColumnName);
                string signature = String.Join("|", blanks.ToArray());
                RemarkInfo remark; remarks.TryGetValue(Key(projectId, deal, loan), out remark);
                bool validRemark = remark != null && String.Equals(remark.Signature, signature, StringComparison.OrdinalIgnoreCase) && !String.IsNullOrWhiteSpace(remark.Remark);
                DealBillingSummary dealSummary = null;
                if (!isCommitment)
                {
                    if (!deals.TryGetValue(deal, out dealSummary)) { dealSummary = new DealBillingSummary { DealNo = deal }; deals.Add(deal, dealSummary); project.Summary.Deals.Add(dealSummary); }
                }
                if (quantityMode)
                {
                    project.Summary.TotalLoans += totalQuantity;
                    project.Summary.DispatchedLoans += dispatchedQuantity;
                    project.Summary.CancelledLoans += cancelledQuantity;
                }
                else if (useRecordQuantities)
                {
                    project.Summary.TotalLoans++;
                    if (cancelled) project.Summary.CancelledLoans++;
                    else if (dispatchConfigured && dispatched) project.Summary.DispatchedLoans++;
                    else if (dispatchConfigured) project.Summary.PendingLoans++;
                }
                else AddCounts(project.Summary, dispatchConfigured, dispatched, blanks.Count > 0, validRemark);
                if (dealSummary != null) AddCounts(dealSummary, dispatchConfigured, dispatched, blanks.Count > 0, validRemark);
                if (blanks.Count > 0) project.BlankLoans.Add(new BlankBillingLoan
                {
                    ProjectID = projectId, ProjectName = projectName, DealNo = deal, LoanNo = loan, DispatchDate = dispatch,
                    BillingMonth = billingMonth.ToString("yyyy-MM-01"), BlankParameters = String.Join(", ", blanks.ToArray()), PendingSignature = signature,
                    Remark = remark == null ? String.Empty : remark.Remark, RemarkAddedBy = remark == null ? String.Empty : remark.AddedBy,
                    RemarkDate = remark == null ? String.Empty : remark.RemarkDate.ToString("dd-MMM-yyyy HH:mm"), HasValidRemark = validRemark,
                    ParameterValues = ValuesAfterDispatch(table, row, billingDispatchIndex), RowValues = VisibleValues(table, row)
                });
                if (dispatchConfigured && !dispatched && !cancelled) project.PendingLoans.Add(new BlankBillingLoan
                {
                    ProjectID = projectId, ProjectName = projectName, DealNo = deal, LoanNo = loan, DispatchDate = dispatch,
                    BillingMonth = billingMonth.ToString("yyyy-MM-01"), BlankParameters = quantityMode ? table.Columns[dispatchedRecordCountIndex].ColumnName : (billingDispatchIndex >= 0 ? table.Columns[billingDispatchIndex].ColumnName : "Dispatched Date"), PendingSignature = "PENDING_DISPATCH",
                    Remark = remark == null ? String.Empty : remark.Remark, RemarkAddedBy = remark == null ? String.Empty : remark.AddedBy,
                    RemarkDate = remark == null ? String.Empty : remark.RemarkDate.ToString("dd-MMM-yyyy HH:mm"),
                    HasValidRemark = remark != null && String.Equals(remark.Signature, "PENDING_DISPATCH", StringComparison.OrdinalIgnoreCase) && !String.IsNullOrWhiteSpace(remark.Remark),
                    RowValues = VisibleValues(table, row)
                });
            }
            if (quantityMode) project.Summary.PendingLoans = Math.Max(0, project.Summary.TotalLoans - project.Summary.DispatchedLoans - project.Summary.CancelledLoans);
            project.Summary.Status = isCommitment
                ? (!dispatchConfigured ? "Dispatch Date Not Configured" : (project.Summary.PendingLoans > 0 ? "On Hold" : "Complete"))
                : (!dispatchConfigured ? "Dispatch Date Not Configured" : Status(project.Summary));
            foreach (DealBillingSummary deal in project.Summary.Deals) deal.Status = Status(deal);
            return project;
        }

        private static Dictionary<string, string> ValuesAfterDispatch(DataTable table, DataRow row, int dispatchIndex)
        {
            Dictionary<string, string> values = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            if (dispatchIndex >= 0) for (int i = dispatchIndex + 1; i < table.Columns.Count; i++)
                if (!table.Columns[i].ColumnName.Equals("Final Status", StringComparison.OrdinalIgnoreCase) && !IsTechnicalColumn(table.Columns[i].ColumnName)) values[table.Columns[i].ColumnName] = Text(row[i]);
            return values;
        }
        private static Dictionary<string, string> VisibleValues(DataTable table, DataRow row)
        {
            Dictionary<string, string> values = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (DataColumn column in table.Columns)
                if (!IsTechnicalColumn(column.ColumnName)) values[column.ColumnName] = Text(row[column]);
            return values;
        }
        private static void AddCounts(BillingCounts value, bool dispatchConfigured, bool dispatched, bool blank, bool remarked)
        { value.TotalLoans++; if (dispatchConfigured) { if (dispatched) value.DispatchedLoans++; else value.PendingLoans++; } if (blank) value.BlankBillingParameters++; if (blank && !remarked) value.RemarkPendingCount++; }
        private static int Quantity(object value) { decimal parsed; return Decimal.TryParse(Text(value), NumberStyles.Any, CultureInfo.InvariantCulture, out parsed) ? Math.Max(0, Convert.ToInt32(Decimal.Truncate(parsed))) : 0; }
        private static string Status(BillingCounts value) { return value.RemarkPendingCount > 0 ? "Action Required" : (value.PendingLoans > 0 ? "Pending" : "Complete"); }
        private static int Find(DataTable table, params string[] names) { for (int i = 0; i < table.Columns.Count; i++) foreach (string name in names) if (table.Columns[i].ColumnName.Trim().Equals(name, StringComparison.OrdinalIgnoreCase)) return i; return -1; }
        private static int FindVisibleDispatchColumn(DataTable table)
        {
            int best = -1, bestPopulated = -1;
            for (int i = 0; i < table.Columns.Count; i++)
            {
                if (IsTechnicalColumn(table.Columns[i].ColumnName)) continue;
                string normalized = NormalizeColumnName(table.Columns[i].ColumnName);
                if (normalized != "dispatchdate" && normalized != "dispatcheddate") continue;
                int populated = 0;
                foreach (DataRow row in table.Rows) if (!String.IsNullOrWhiteSpace(Text(row[i]))) populated++;
                if (populated > bestPopulated) { best = i; bestPopulated = populated; }
            }
            return best;
        }
        private static string NormalizeColumnName(string value)
        {
            StringBuilder normalized = new StringBuilder();
            foreach (char character in Convert.ToString(value)) if (Char.IsLetterOrDigit(character)) normalized.Append(Char.ToLowerInvariant(character));
            return normalized.ToString();
        }
        private static bool IsTechnicalColumn(string name) { return Convert.ToString(name).StartsWith("__", StringComparison.Ordinal); }
        private static string Key(int id, string deal, string loan) { return id + "|" + (deal ?? "").Trim() + "|" + (loan ?? "").Trim(); }
        private static string Text(object value) { if (value == null || value == DBNull.Value) return ""; if (value is DateTime) { DateTime d = (DateTime)value; return d.TimeOfDay == TimeSpan.Zero ? d.ToString("dd-MMM-yyyy") : d.ToString("dd-MMM-yyyy HH:mm"); } return Convert.ToString(value, CultureInfo.InvariantCulture); }
        private static void EnsureUnderwritingUser(int id) { if (id != 277 && id != 6823 && id != 255 && id != 6 && id != 40 && id != 318) throw new UnauthorizedAccessException("Billing validation is restricted to authorized users."); }
    }

    internal sealed class RemarkInfo { public string Signature, Remark, AddedBy; public DateTime RemarkDate; }
    public sealed class BillingValidationResult { public BillingValidationResult() { Projects = new List<BillingProject>(); Summary = new List<ProjectBillingSummary>(); BlankLoans = new List<BlankBillingLoan>(); PendingLoans = new List<BlankBillingLoan>(); } public DateTime BillingMonth { get; set; } public DateTime PeriodTo { get; set; } public List<BillingProject> Projects { get; set; } public List<ProjectBillingSummary> Summary { get; set; } public List<BlankBillingLoan> BlankLoans { get; set; } public List<BlankBillingLoan> PendingLoans { get; set; } }
    public sealed class BillingProject { public BillingProject() { Columns = new List<string>(); Rows = new List<List<string>>(); SummaryItems = new List<BillingSummaryItem>(); BlankLoans = new List<BlankBillingLoan>(); PendingLoans = new List<BlankBillingLoan>(); } public int ProjectID { get; set; } public string ProjectName { get; set; } public string ReportTitle { get; set; } public List<string> Columns { get; set; } public List<List<string>> Rows { get; set; } public List<BillingSummaryItem> SummaryItems { get; set; } public ProjectBillingSummary Summary { get; set; } public List<BlankBillingLoan> BlankLoans { get; set; } public List<BlankBillingLoan> PendingLoans { get; set; } }
    public sealed class BillingSummaryItem { public string Label { get; set; } public string Value { get; set; } }
    public class BillingCounts { public int TotalLoans { get; set; } public int DispatchedLoans { get; set; } public int CancelledLoans { get; set; } public int PendingLoans { get; set; } public int BlankBillingParameters { get; set; } public int RemarkPendingCount { get; set; } public string Status { get; set; } }
    public sealed class ProjectBillingSummary : BillingCounts { public ProjectBillingSummary() { Deals = new List<DealBillingSummary>(); } public int ProjectID { get; set; } public string ProjectName { get; set; } public List<DealBillingSummary> Deals { get; set; } }
    public sealed class DealBillingSummary : BillingCounts { public string DealNo { get; set; } }
    public sealed class BlankBillingLoan { public BlankBillingLoan() { ParameterValues = new Dictionary<string, string>(); RowValues = new Dictionary<string, string>(); } public int ProjectID { get; set; } public string ProjectName { get; set; } public string DealNo { get; set; } public string LoanNo { get; set; } public string DispatchDate { get; set; } public string BillingMonth { get; set; } public string BlankParameters { get; set; } public string PendingSignature { get; set; } public string Remark { get; set; } public string RemarkAddedBy { get; set; } public string RemarkDate { get; set; } public bool HasValidRemark { get; set; } public Dictionary<string, string> ParameterValues { get; set; } public Dictionary<string, string> RowValues { get; set; } }
}
