using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Production
{
    public partial class ProjectTrackingReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetProjects()
        {
            return SerializeDataTable(new bllMaster().GetAllProject());
        }

        [WebMethod]
        public static string GetReportFields(int projectId)
        {
            return SerializeDataTable(new bllProjectTracking().GetReportFields(projectId));
        }

        [WebMethod]
        public static string GenerateReport(int projectId, string reportMode, string fromDate, string toDate, string reportMonth, List<string> selectedColumns, List<string> summaryGroupBy)
        {
            List<string> columns = CleanSelectedColumns(selectedColumns);
            List<string> summaryGroups = CleanSummaryGroups(summaryGroupBy);
            TrackingReportResult result = new TrackingReportResult();
            result.Columns = new List<string>();
            result.Rows = new List<Dictionary<string, object>>();
            result.SummaryColumns = BuildSummaryColumns(summaryGroups);
            result.SummaryRows = new List<Dictionary<string, object>>();

            result.Columns.Add("Project");
            result.Columns.Add("Entry Date");
            result.Columns.AddRange(columns);

            if (columns.Count == 0)
            {
                return SerializeObject(result);
            }

            ApplyReportDateRange(reportMode, reportMonth, ref fromDate, ref toDate);

            bllProjectTracking tracking = new bllProjectTracking();
            DataTable reportData = tracking.GetProjectTrackingReportData(projectId, fromDate, toDate);
            DataTable summaryData = tracking.GetProjectTrackingSummaryData(projectId, fromDate, toDate);
            Dictionary<int, string> projectNames = GetProjectNames();
            HashSet<string> selectedColumnSet = new HashSet<string>(columns, StringComparer.OrdinalIgnoreCase);
            Dictionary<string, string> selectedColumnMap = GetSelectedColumnMap(columns);
            Dictionary<string, Dictionary<string, object>> rowsByKey = new Dictionary<string, Dictionary<string, object>>();

            foreach (DataRow dataRow in reportData.Rows)
            {
                string fieldName = Convert.ToString(dataRow["FieldName"]);

                if (!selectedColumnSet.Contains(fieldName))
                {
                    continue;
                }

                int rowId = Convert.ToInt32(dataRow["RowId"]);
                int dataProjectId = Convert.ToInt32(dataRow["ProjectID"]);
                string rowKey = dataProjectId + "_" + rowId;

                if (!rowsByKey.ContainsKey(rowKey))
                {
                    Dictionary<string, object> reportRow = CreateReportRow(dataProjectId, Convert.ToString(dataRow["EntryDate"]), columns, projectNames);
                    rowsByKey.Add(rowKey, reportRow);
                    result.Rows.Add(reportRow);
                }

                rowsByKey[rowKey][selectedColumnMap[fieldName]] = Convert.ToString(dataRow["FieldValue"]);
            }

            result.SummaryRows = BuildSummaryRows(summaryData, summaryGroups);

            return SerializeObject(result);
        }

        private static List<Dictionary<string, object>> BuildSummaryRows(DataTable summaryData, List<string> summaryGroups)
        {
            List<SummaryBucket> buckets = new List<SummaryBucket>();
            Dictionary<string, SummaryBucket> bucketByKey = new Dictionary<string, SummaryBucket>(StringComparer.OrdinalIgnoreCase);

            if (summaryData == null)
            {
                return new List<Dictionary<string, object>>();
            }

            foreach (DataRow dataRow in summaryData.Rows)
            {
                int rowId = Convert.ToInt32(dataRow["RowId"]);
                Dictionary<string, string> values = GetSummaryValues(dataRow);
                string key = BuildSummaryKey(summaryGroups, values);

                if (!bucketByKey.ContainsKey(key))
                {
                    SummaryBucket bucket = new SummaryBucket();
                    bucket.Values = values;
                    bucket.RowIds = new HashSet<int>();
                    bucketByKey.Add(key, bucket);
                    buckets.Add(bucket);
                }

                bucketByKey[key].RowIds.Add(rowId);
            }

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            foreach (SummaryBucket bucket in buckets)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();

                foreach (string group in summaryGroups)
                {
                    row.Add(GetSummaryColumnName(group), bucket.Values.ContainsKey(group) ? bucket.Values[group] : string.Empty);
                }

                row.Add("Loan Count", bucket.RowIds.Count);
                rows.Add(row);
            }

            return rows;
        }

        private static Dictionary<string, string> GetSummaryValues(DataRow dataRow)
        {
            Dictionary<string, string> values = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            values.Add("User", Convert.ToString(dataRow["UserName"]));
            values.Add("Date", Convert.ToString(dataRow["EntryDate"]));
            values.Add("Process", Convert.ToString(dataRow["ProcessName"]));
            return values;
        }

        private static string BuildSummaryKey(List<string> summaryGroups, Dictionary<string, string> values)
        {
            if (summaryGroups.Count == 0)
            {
                return "All";
            }

            List<string> keyParts = new List<string>();

            foreach (string group in summaryGroups)
            {
                keyParts.Add(values.ContainsKey(group) ? values[group] : string.Empty);
            }

            return string.Join("|", keyParts.ToArray());
        }

        private static List<string> BuildSummaryColumns(List<string> summaryGroups)
        {
            List<string> columns = new List<string>();

            foreach (string group in summaryGroups)
            {
                columns.Add(GetSummaryColumnName(group));
            }

            columns.Add("Loan Count");
            return columns;
        }

        private static string GetSummaryColumnName(string group)
        {
            if (string.Equals(group, "Date", StringComparison.OrdinalIgnoreCase))
            {
                return "Entry Date";
            }

            return group;
        }

        private static Dictionary<string, string> GetSelectedColumnMap(List<string> columns)
        {
            Dictionary<string, string> selectedColumnMap = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

            foreach (string column in columns)
            {
                selectedColumnMap[column] = column;
            }

            return selectedColumnMap;
        }

        private static Dictionary<string, object> CreateReportRow(int projectId, string entryDate, List<string> columns, Dictionary<int, string> projectNames)
        {
            Dictionary<string, object> reportRow = new Dictionary<string, object>();
            string projectName = projectNames.ContainsKey(projectId) ? projectNames[projectId] : Convert.ToString(projectId);

            reportRow.Add("Project", projectName);
            reportRow.Add("Entry Date", entryDate);

            foreach (string column in columns)
            {
                reportRow[column] = string.Empty;
            }

            return reportRow;
        }

        private static List<string> CleanSelectedColumns(List<string> selectedColumns)
        {
            List<string> columns = new List<string>();
            HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            if (selectedColumns == null)
            {
                return columns;
            }

            foreach (string selectedColumn in selectedColumns)
            {
                string column = (selectedColumn ?? string.Empty).Trim();

                if (column.Length > 0 && !seen.Contains(column))
                {
                    columns.Add(column);
                    seen.Add(column);
                }
            }

            return columns;
        }

        private static List<string> CleanSummaryGroups(List<string> summaryGroupBy)
        {
            List<string> groups = new List<string>();
            HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            if (summaryGroupBy == null)
            {
                return groups;
            }

            foreach (string groupValue in summaryGroupBy)
            {
                string group = (groupValue ?? string.Empty).Trim();

                if (IsValidSummaryGroup(group) && !seen.Contains(group))
                {
                    groups.Add(group);
                    seen.Add(group);
                }
            }

            return groups;
        }

        private static bool IsValidSummaryGroup(string group)
        {
            return string.Equals(group, "User", StringComparison.OrdinalIgnoreCase)
                || string.Equals(group, "Date", StringComparison.OrdinalIgnoreCase)
                || string.Equals(group, "Process", StringComparison.OrdinalIgnoreCase);
        }

        private static void ApplyReportDateRange(string reportMode, string reportMonth, ref string fromDate, ref string toDate)
        {
            if (!string.Equals(reportMode, "MonthWise", StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            DateTime monthDate;
            if (!DateTime.TryParse((reportMonth ?? string.Empty) + "-01", out monthDate))
            {
                monthDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
            }

            DateTime firstDate = new DateTime(monthDate.Year, monthDate.Month, 1);
            DateTime lastDate = firstDate.AddMonths(1).AddDays(-1);

            fromDate = firstDate.ToString("yyyy-MM-dd");
            toDate = lastDate.ToString("yyyy-MM-dd");
        }

        private static Dictionary<int, string> GetProjectNames()
        {
            Dictionary<int, string> projectNames = new Dictionary<int, string>();
            DataTable projects = new bllMaster().GetAllProject();

            if (projects == null)
            {
                return projectNames;
            }

            foreach (DataRow row in projects.Rows)
            {
                int projectId = GetInt(row, "ProjectID", "ProjectId");
                string projectName = GetString(row, "ProjectName");

                if (projectId > 0 && !projectNames.ContainsKey(projectId))
                {
                    projectNames.Add(projectId, projectName);
                }
            }

            return projectNames;
        }

        private static int GetInt(DataRow row, string primaryColumn, string fallbackColumn)
        {
            if (row.Table.Columns.Contains(primaryColumn) && row[primaryColumn] != DBNull.Value)
            {
                return Convert.ToInt32(row[primaryColumn]);
            }

            if (row.Table.Columns.Contains(fallbackColumn) && row[fallbackColumn] != DBNull.Value)
            {
                return Convert.ToInt32(row[fallbackColumn]);
            }

            return 0;
        }

        private static string GetString(DataRow row, string columnName)
        {
            if (row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value)
            {
                return Convert.ToString(row[columnName]);
            }

            return string.Empty;
        }

        private static string SerializeDataTable(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }

            return SerializeObject(rows);
        }

        private static string SerializeObject(object value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(value);
        }
    }

    public class TrackingReportResult
    {
        public List<string> Columns { get; set; }
        public List<Dictionary<string, object>> Rows { get; set; }
        public List<string> SummaryColumns { get; set; }
        public List<Dictionary<string, object>> SummaryRows { get; set; }
    }

    public class SummaryBucket
    {
        public Dictionary<string, string> Values { get; set; }
        public HashSet<int> RowIds { get; set; }
    }
}
