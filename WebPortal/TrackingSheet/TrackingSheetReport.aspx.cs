using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.TrackingSheet
{
    public partial class TrackingSheetReport : System.Web.UI.Page
    {
        [WebMethod]
        public static List<ProjectOption> GetProjects()
        {
            List<ProjectOption> result = new List<ProjectOption>();
            foreach (DataRow row in new bllMaster().GetAllProject().Rows)
            {
                int id;
                string idText = FirstValue(row, "ProjectID", "ProjectId", "projectID", "ID");
                if (int.TryParse(idText, out id)) result.Add(new ProjectOption { ID = id, Name = FirstValue(row, "ProjectName", "ProjectNo", "Name", "Project") });
            }
            return result;
        }

        [WebMethod]
        public static ReportResponse GetReport(int projectId, string fromDate, string toDate)
        {
            DateTime from, to;
            if (projectId <= 0) throw new ArgumentException("Please select a project.");
            if (!DateTime.TryParseExact(fromDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out from) ||
                !DateTime.TryParseExact(toDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out to))
                throw new ArgumentException("Please select valid From and To Order Dates.");
            if (from > to) throw new ArgumentException("From Order Date cannot be later than To Order Date.");

            bllOLTrackingImport tracking = new bllOLTrackingImport();
            DataTable fields = tracking.GetTrackingReportFields(projectId);
            DataTable source = tracking.GetTrackingReportRows(projectId, from, to);
            DataTable processes = tracking.GetTrackingReportProcesses(projectId, from, to);
            bllOLTracking processTracking = new bllOLTracking();
            DataTable configuredProcesses = processTracking.GetConfiguredProcesses(projectId);
            DataTable hourlyEntries = processTracking.GetHourlyProductivityEntries(projectId, from, to);
            string projectName = GetProjects().Where(x => x.ID == projectId).Select(x => x.Name).FirstOrDefault() ?? projectId.ToString();
            return BuildResponse(source, fields, processes, configuredProcesses, hourlyEntries, projectName);
        }

        private static ReportResponse BuildResponse(DataTable source, DataTable fields, DataTable processes, DataTable configuredProcesses, DataTable hourlyEntries, string projectName)
        {
            List<MilestoneDefinition> milestones = ResolveMilestones(configuredProcesses);
            List<string> columns = new List<string> { "Project #", "Deal #", "Loan #", "Order Date" };
            Dictionary<int, string> fieldColumns = new Dictionary<int, string>();
            foreach (DataRow field in fields.Rows)
            {
                string name = Convert.ToString(field["FieldName"]).Trim();
                if (name.Length == 0 || IsBaseField(name) || columns.Any(x => x.Equals(name, StringComparison.OrdinalIgnoreCase))) continue;
                columns.Add(name); fieldColumns[Convert.ToInt32(field["FieldConfigId"])] = name;
            }
            if (hourlyEntries.Rows.Count > 0) columns.Add("Hours Worked");

            List<Dictionary<string, string>> rows = new List<Dictionary<string, string>>();
            List<string> rowKeys = new List<string>();
            Dictionary<string, Dictionary<string, string>> rowMap = new Dictionary<string, Dictionary<string, string>>();
            foreach (DataRow sourceRow in source.Rows)
            {
                DateTime date = Convert.ToDateTime(sourceRow["EntryDate"]).Date;
                string key = Convert.ToString(sourceRow["ItemID"]) + "|" + date.ToString("yyyyMMdd");
                Dictionary<string, string> row;
                if (!rowMap.TryGetValue(key, out row))
                {
                    row = columns.ToDictionary(x => x, x => string.Empty);
                    row["Project #"] = projectName; row["Deal #"] = Convert.ToString(sourceRow["DealNumber"]);
                    row["Loan #"] = Convert.ToString(sourceRow["ItemNumber"]); row["Order Date"] = date.ToString("dd-MMM-yyyy");
                    rowMap.Add(key, row); rows.Add(row); rowKeys.Add(key);
                }
                if (sourceRow["FieldConfigId"] != DBNull.Value)
                {
                    string column;
                    if (fieldColumns.TryGetValue(Convert.ToInt32(sourceRow["FieldConfigId"]), out column)) row[column] = Convert.ToString(sourceRow["FieldValue"]);
                }
            }
            Dictionary<string, List<ProcessView>> processMap = new Dictionary<string, List<ProcessView>>();
            foreach (DataRow process in processes.Rows)
            {
                string key = Convert.ToString(process["ItemID"]) + "|" + Convert.ToDateTime(process["EntryDate"]).ToString("yyyyMMdd");
                List<ProcessView> list;
                if (!processMap.TryGetValue(key, out list)) { list = new List<ProcessView>(); processMap[key] = list; }
                list.Add(new ProcessView
                {
                    ProcessID = Convert.ToInt32(process["ProcessID"]), ProcessName = Convert.ToString(process["ProcessName"]),
                    Sequence = Convert.ToInt32(process["StageNo"]), Status = Convert.ToString(process["ProcessStatus"]),
                    IsMandatory = Convert.ToBoolean(process["IsMandatory"]), IsFinalProcess = Convert.ToBoolean(process["IsFinalProcess"]),
                    IsCurrent = Convert.ToBoolean(process["IsCurrent"]), HasAssignment = Convert.ToBoolean(process["HasAssignment"]), IsLoanHeld = Convert.ToBoolean(process["IsLoanHeld"]), CompletedBy = FirstValue(process, "CompletedBy"),
                    ProcessUser = FirstValue(process, "ProcessUser"),
                    ManualDurationMinutes = process["ManualDurationMinutes"] == DBNull.Value ? (int?)null : Convert.ToInt32(process["ManualDurationMinutes"])
                });
            }
            List<ReportRow> reportRows = new List<ReportRow>();
            for (int rowIndex = 0; rowIndex < rows.Count; rowIndex++)
            {
                string key = rowKeys[rowIndex]; List<ProcessView> itemProcesses; processMap.TryGetValue(key, out itemProcesses);
                itemProcesses = itemProcesses ?? new List<ProcessView>();
                foreach (ProcessView process in itemProcesses) process.IsCurrent = false;
                ProcessView current = itemProcesses
                    .Where(x => StatusIs(x, "In Process"))
                    .OrderByDescending(x => x.Sequence).ThenBy(x => x.ProcessName).FirstOrDefault();
                if (current == null)
                    current = itemProcesses.Where(x => StatusIs(x, "Hold") || StatusIs(x, "On Hold"))
                        .OrderByDescending(x => x.Sequence).ThenBy(x => x.ProcessName).FirstOrDefault();
                if (current == null)
                    current = itemProcesses.Where(x => x.IsMandatory && IsPending(x))
                        .OrderBy(x => x.Sequence).ThenBy(x => x.ProcessName).FirstOrDefault();
                if (current == null)
                    current = itemProcesses.Where(IsPending)
                        .OrderBy(x => x.Sequence).ThenBy(x => x.ProcessName).FirstOrDefault();
                if (current != null) current.IsCurrent = true;
                string[] keyParts = key.Split('|');
                ReportRow reportRow = new ReportRow
                {
                    ItemID = Convert.ToInt64(keyParts[0]),
                    EntryDate = DateTime.ParseExact(keyParts[1], "yyyyMMdd", CultureInfo.InvariantCulture).ToString("yyyy-MM-dd"),
                    Values = rows[rowIndex],
                    Processes = itemProcesses
                };
                PopulateMilestoneStatus(reportRow, milestones);
                reportRows.Add(reportRow);
            }
            foreach (DataRow entry in hourlyEntries.Rows)
            {
                Dictionary<string, string> values = columns.ToDictionary(x => x, x => string.Empty);
                int minutes = Convert.ToInt32(entry["DurationMinutes"]);
                values["Project #"] = projectName; values["Deal #"] = Convert.ToString(entry["DealNumber"]);
                values["Order Date"] = Convert.ToDateTime(entry["EntryDate"]).ToString("dd-MMM-yyyy");
                values["Hours Worked"] = (minutes / 60).ToString() + ":" + (minutes % 60).ToString("00");
                reportRows.Add(new ReportRow
                {
                    Values = values,
                    Processes = new List<ProcessView> { new ProcessView { ProcessID=Convert.ToInt32(entry["ProcessID"]), ProcessName=Convert.ToString(entry["ProcessName"]), Sequence=Convert.ToInt32(entry["StageNo"]), Status="Completed", IsCurrent=false, CompletedBy=Convert.ToString(entry["UserName"]), ProcessUser=Convert.ToString(entry["UserName"]), ManualDurationMinutes=minutes } }
                });
            }
            return new ReportResponse
            {
                Columns = columns,
                Rows = reportRows,
                RowCount = reportRows.Count,
                Milestones = milestones,
                Deals = BuildDealStatus(reportRows, milestones)
            };
        }

        private static List<MilestoneDefinition> ResolveMilestones(DataTable configuredProcesses)
        {
            string[] codes = { "CNCREVIEW", "CNCQC", "SSREVIEW", "SSQC" };
            string[] labels = { "C&C Review", "C&C QC", "SS Review", "SS QC" };
            List<MilestoneDefinition> result = new List<MilestoneDefinition>();
            for (int index = 0; index < codes.Length; index++)
            {
                string code = codes[index];
                DataRow match = configuredProcesses.AsEnumerable().FirstOrDefault(row => NormalizeProcessCode(FirstValue(row, "ProcessName")) == code);
                result.Add(new MilestoneDefinition
                {
                    Code = code,
                    ProcessID = match == null ? 0 : Convert.ToInt32(match["ProcessID"]),
                    ProcessName = labels[index]
                });
            }
            return result;
        }

        private static string NormalizeProcessCode(string value)
        {
            return new string((value ?? string.Empty).ToUpperInvariant().Replace("&", "N").Where(char.IsLetterOrDigit).ToArray());
        }

        private static void PopulateMilestoneStatus(ReportRow row, List<MilestoneDefinition> milestones)
        {
            row.MilestoneStatuses = milestones.Select(definition =>
            {
                ProcessView process = definition.ProcessID <= 0 ? null : row.Processes.FirstOrDefault(item => item.ProcessID == definition.ProcessID);
                return new MilestoneStatusView
                {
                    Code = definition.Code,
                    ProcessID = definition.ProcessID,
                    ProcessName = definition.ProcessName,
                    Status = process == null ? "Pending" : NormalizeStatus(process.Status),
                    AssignedTo = process == null ? string.Empty : (process.ProcessUser ?? string.Empty)
                };
            }).ToList();
            row.CompletionPercent = row.MilestoneStatuses.Count(status => StatusEquals(status.Status, "Completed")) * 25;
        }

        private static List<DealStatusView> BuildDealStatus(List<ReportRow> reportRows, List<MilestoneDefinition> milestones)
        {
            List<ReportRow> loanRows = reportRows.Where(row => row.ItemID > 0 && !string.IsNullOrWhiteSpace(Value(row, "Loan #")))
                .GroupBy(row => row.ItemID)
                .Select(group => group.OrderByDescending(row => row.EntryDate).First())
                .ToList();
            return loanRows.GroupBy(row => Value(row, "Deal #"), StringComparer.OrdinalIgnoreCase)
                .OrderBy(group => group.Key)
                .Select(group =>
                {
                    List<ReportRow> loans = group.ToList();
                    DealStatusView deal = new DealStatusView
                    {
                        DealNumber = group.Key,
                        TotalLoans = loans.Count,
                        Assigned = loans.Count(row => row.Processes.Any(process => process.HasAssignment)),
                        InProcess = loans.Count(row => CurrentStatus(row) == "In Process"),
                        Hold = loans.Count(row => CurrentStatus(row) == "Hold" || CurrentStatus(row) == "Hold by PM"),
                        Completed = loans.Count(row => CurrentStatus(row) == "Completed"),
                        CompletionPercent = loans.Count == 0 ? 0 : Math.Round(loans.Average(row => (decimal)row.CompletionPercent), 1),
                        Loans = loans.Select(BuildDealLoan).OrderBy(loan => loan.LoanNumber).ToList()
                    };
                    deal.Pending = Math.Max(0, deal.TotalLoans - deal.Completed - deal.InProcess - deal.Hold);
                    deal.Processes = milestones.Select(definition =>
                    {
                        List<MilestoneStatusView> statuses = loans.Select(row => row.MilestoneStatuses.First(status => status.Code == definition.Code)).ToList();
                        return new DealProcessStatusView
                        {
                            Code = definition.Code,
                            ProcessID = definition.ProcessID,
                            ProcessName = definition.ProcessName,
                            Completed = statuses.Count(status => StatusEquals(status.Status, "Completed")),
                            InProcess = statuses.Count(status => StatusEquals(status.Status, "In Process")),
                            Hold = statuses.Count(status => StatusEquals(status.Status, "Hold")),
                            Pending = statuses.Count(status => StatusEquals(status.Status, "Pending"))
                        };
                    }).ToList();
                    return deal;
                }).ToList();
        }

        private static DealLoanView BuildDealLoan(ReportRow row)
        {
            ProcessView current = row.Processes.FirstOrDefault(process => process.IsCurrent);
            return new DealLoanView
            {
                LoanNumber = Value(row, "Loan #"),
                OrderDate = Value(row, "Order Date"),
                DueDate = ValueByNormalizedName(row, "duedate"),
                AssignedTo = current == null ? string.Empty : current.ProcessUser,
                CurrentProcess = current == null ? string.Empty : current.ProcessName,
                CurrentStatus = CurrentStatus(row),
                CompletionPercent = row.CompletionPercent,
                Processes = row.MilestoneStatuses
            };
        }

        private static string CurrentStatus(ReportRow row)
        {
            if (row.Processes.Any(process => process.IsLoanHeld)) return "Hold by PM";
            if (row.CompletionPercent == 100) return "Completed";
            ProcessView current = row.Processes.FirstOrDefault(process => process.IsCurrent);
            return current == null ? "Pending" : NormalizeStatus(current.Status);
        }

        private static string NormalizeStatus(string status)
        {
            if (StatusEquals(status, "Completed")) return "Completed";
            if (StatusEquals(status, "In Process")) return "In Process";
            if (StatusEquals(status, "Hold") || StatusEquals(status, "On Hold")) return "Hold";
            return "Pending";
        }

        private static bool StatusEquals(string actual, string expected)
        {
            return string.Equals(actual ?? string.Empty, expected, StringComparison.OrdinalIgnoreCase);
        }

        private static string Value(ReportRow row, string name)
        {
            string value;
            return row.Values != null && row.Values.TryGetValue(name, out value) ? value ?? string.Empty : string.Empty;
        }

        private static string ValueByNormalizedName(ReportRow row, string normalizedName)
        {
            if (row.Values == null) return string.Empty;
            KeyValuePair<string, string> match = row.Values.FirstOrDefault(value =>
                new string((value.Key ?? string.Empty).ToLowerInvariant().Where(char.IsLetterOrDigit).ToArray()) == normalizedName);
            return match.Value ?? string.Empty;
        }

        private static bool IsBaseField(string value)
        {
            string n = new string((value ?? "").ToLowerInvariant().Where(char.IsLetterOrDigit).ToArray());
            return new[] { "project", "projectno", "projectnumber", "deal", "dealno", "dealnumber", "loan", "loanno", "loannumber", "orderdate", "entrydate" }.Contains(n);
        }

        private static bool StatusIs(ProcessView process, string status)
        {
            return string.Equals(process.Status ?? string.Empty, status, StringComparison.OrdinalIgnoreCase);
        }

        private static bool IsPending(ProcessView process)
        {
            return !StatusIs(process, "Completed") && !StatusIs(process, "Skipped") &&
                   !StatusIs(process, "In Process") && !StatusIs(process, "Hold") && !StatusIs(process, "On Hold");
        }

        private static string FirstValue(DataRow row, params string[] names)
        {
            foreach (string name in names) if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value && !string.IsNullOrWhiteSpace(Convert.ToString(row[name]))) return Convert.ToString(row[name]).Trim();
            return string.Empty;
        }
    }

    public sealed class ProjectOption { public int ID { get; set; } public string Name { get; set; } }
    public sealed class ProcessView { public int ProcessID { get; set; } public string ProcessName { get; set; } public int Sequence { get; set; } public string Status { get; set; } public bool IsMandatory { get; set; } public bool IsFinalProcess { get; set; } public bool IsCurrent { get; set; } public bool HasAssignment { get; set; } public bool IsLoanHeld { get; set; } public string CompletedBy { get; set; } public string ProcessUser { get; set; } public int? ManualDurationMinutes { get; set; } }
    public sealed class MilestoneDefinition { public string Code { get; set; } public int ProcessID { get; set; } public string ProcessName { get; set; } }
    public sealed class MilestoneStatusView { public string Code { get; set; } public int ProcessID { get; set; } public string ProcessName { get; set; } public string Status { get; set; } public string AssignedTo { get; set; } }
    public sealed class ReportRow { public long ItemID { get; set; } public string EntryDate { get; set; } public int CompletionPercent { get; set; } public Dictionary<string, string> Values { get; set; } public List<ProcessView> Processes { get; set; } public List<MilestoneStatusView> MilestoneStatuses { get; set; } }
    public sealed class DealProcessStatusView { public string Code { get; set; } public int ProcessID { get; set; } public string ProcessName { get; set; } public int Completed { get; set; } public int InProcess { get; set; } public int Pending { get; set; } public int Hold { get; set; } }
    public sealed class DealLoanView { public string LoanNumber { get; set; } public string OrderDate { get; set; } public string DueDate { get; set; } public string AssignedTo { get; set; } public string CurrentProcess { get; set; } public string CurrentStatus { get; set; } public int CompletionPercent { get; set; } public List<MilestoneStatusView> Processes { get; set; } }
    public sealed class DealStatusView { public string DealNumber { get; set; } public int TotalLoans { get; set; } public int Assigned { get; set; } public int InProcess { get; set; } public int Pending { get; set; } public int Hold { get; set; } public int Completed { get; set; } public decimal CompletionPercent { get; set; } public List<DealProcessStatusView> Processes { get; set; } public List<DealLoanView> Loans { get; set; } }
    public sealed class ReportResponse { public List<string> Columns { get; set; } public List<ReportRow> Rows { get; set; } public int RowCount { get; set; } public List<MilestoneDefinition> Milestones { get; set; } public List<DealStatusView> Deals { get; set; } }
}
