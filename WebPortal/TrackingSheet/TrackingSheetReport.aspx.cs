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
            string projectName = GetProjects().Where(x => x.ID == projectId).Select(x => x.Name).FirstOrDefault() ?? projectId.ToString();
            return BuildResponse(source, fields, processes, projectName);
        }

        private static ReportResponse BuildResponse(DataTable source, DataTable fields, DataTable processes, string projectName)
        {
            List<string> columns = new List<string> { "Project #", "Deal #", "Loan #", "Order Date" };
            Dictionary<int, string> fieldColumns = new Dictionary<int, string>();
            foreach (DataRow field in fields.Rows)
            {
                string name = Convert.ToString(field["FieldName"]).Trim();
                if (name.Length == 0 || IsBaseField(name) || columns.Any(x => x.Equals(name, StringComparison.OrdinalIgnoreCase))) continue;
                columns.Add(name); fieldColumns[Convert.ToInt32(field["FieldConfigId"])] = name;
            }

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
                    IsCurrent = Convert.ToBoolean(process["IsCurrent"]), CompletedBy = FirstValue(process, "CompletedBy"),
                    ProcessUser = FirstValue(process, "ProcessUser")
                });
            }
            List<ReportRow> reportRows = new List<ReportRow>();
            for (int rowIndex = 0; rowIndex < rows.Count; rowIndex++)
            {
                string key = rowKeys[rowIndex]; List<ProcessView> itemProcesses; processMap.TryGetValue(key, out itemProcesses);
                itemProcesses = itemProcesses ?? new List<ProcessView>();
                if (!itemProcesses.Any(x => x.IsCurrent))
                {
                    ProcessView current = itemProcesses.Where(x => !x.Status.Equals("Completed", StringComparison.OrdinalIgnoreCase) && !x.Status.Equals("Skipped", StringComparison.OrdinalIgnoreCase)).OrderBy(x => x.Sequence).FirstOrDefault();
                    if (current != null) current.IsCurrent = true;
                }
                reportRows.Add(new ReportRow { Values = rows[rowIndex], Processes = itemProcesses });
            }
            return new ReportResponse { Columns = columns, Rows = reportRows, RowCount = reportRows.Count };
        }

        private static bool IsBaseField(string value)
        {
            string n = new string((value ?? "").ToLowerInvariant().Where(char.IsLetterOrDigit).ToArray());
            return new[] { "project", "projectno", "projectnumber", "deal", "dealno", "dealnumber", "loan", "loanno", "loannumber", "orderdate", "entrydate" }.Contains(n);
        }

        private static string FirstValue(DataRow row, params string[] names)
        {
            foreach (string name in names) if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value && !string.IsNullOrWhiteSpace(Convert.ToString(row[name]))) return Convert.ToString(row[name]).Trim();
            return string.Empty;
        }
    }

    public sealed class ProjectOption { public int ID { get; set; } public string Name { get; set; } }
    public sealed class ProcessView { public int ProcessID { get; set; } public string ProcessName { get; set; } public int Sequence { get; set; } public string Status { get; set; } public bool IsMandatory { get; set; } public bool IsFinalProcess { get; set; } public bool IsCurrent { get; set; } public string CompletedBy { get; set; } public string ProcessUser { get; set; } }
    public sealed class ReportRow { public Dictionary<string, string> Values { get; set; } public List<ProcessView> Processes { get; set; } }
    public sealed class ReportResponse { public List<string> Columns { get; set; } public List<ReportRow> Rows { get; set; } public int RowCount { get; set; } }
}
