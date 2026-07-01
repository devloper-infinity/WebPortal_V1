using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class USDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static DashboardSnapshot GetDashboardSnapshot()
        {
            int employeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DateTime today = DateTime.Today;
            DateTime monthStart = new DateTime(today.Year, today.Month, 1);
            string fromDate = monthStart.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
            string toDate = today.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
            string monthName = today.ToString("MMMM", CultureInfo.InvariantCulture);
            string year = today.Year.ToString(CultureInfo.InvariantCulture);

            List<string> warnings = new List<string>();
            bllUS us = new bllUS();
            bllMaster master = new bllMaster();
            bllLogin login = new bllLogin();

            DataTable userInfo = SafeTable(() => login.GetUserInformation(employeeId), warnings, "User profile");
            DataTable pendingTasks = SafeTable(() => master.GetAllNotificationsByUserForDashboard(employeeId), warnings, "Pending tasks");
            DataTable activeLoans = SafeTable(() => us.GetLoanDetails_RemoteUW_REQC(employeeId), warnings, "Active loan queue");
            DataTable creditSummary = SafeTable(() => us.GetOverAllUserPerformance_credit_Greg(employeeId, fromDate, toDate), warnings, "Credit summary");
            DataTable servicingSummary = SafeTable(() => us.GetOverAllUserPerformance_Servicing_Greg(employeeId, fromDate, toDate), warnings, "Servicing summary");
            DataTable creditDetails = SafeTable(() => us.GetOverAllUserPerformanceDetails_Credit_Greg(employeeId, fromDate, toDate), warnings, "Credit activity");
            DataTable servicingDetails = SafeTable(() => us.GetOverAllUserPerformanceDetails_Servicing_Greg(employeeId, fromDate, toDate), warnings, "Servicing activity");
            DataTable conditionPending = SafeTable(() => us.ViewAllConditionClearingPending(), warnings, "Condition pending");
            DataTable conditionAll = SafeTable(() => us.ViewAllConditionClearing(), warnings, "Condition clearing");
            DataTable feedback = SafeTable(() => us.GetAllFeedbackByDateRange_NewFormat_Onshore(fromDate, toDate), warnings, "Onshore feedback");
            DataTable production = SafeTable(() => us.GetDatewiseOnShoreProduction_Monthly(monthName, year), warnings, "Production summary");

            int creditLoans = SumInt(creditSummary, "LoanCount", "Loan Count", "LoansReviewed", "Loans Reviewed");
            int servicingLoans = SumInt(servicingSummary, "LoanCount", "Loan Count", "LoansReviewed", "Loans Reviewed");
            if (creditLoans == 0)
            {
                creditLoans = creditDetails.Rows.Count;
            }
            if (servicingLoans == 0)
            {
                servicingLoans = servicingDetails.Rows.Count;
            }

            int productionLoans = SumInt(production, "LoansReviewed", "Loans Reviewed", "LoanCount", "Loan Count");
            if (productionLoans == 0)
            {
                productionLoans = production.Rows.Count;
            }

            List<ActivityRow> recentActivity = new List<ActivityRow>();
            AddActivityRows(recentActivity, creditDetails, "Credit", "UserPerformanceReport.aspx", 4);
            AddActivityRows(recentActivity, servicingDetails, "Servicing", "UserPerformanceReport.aspx", 4);
            AddActivityRows(recentActivity, production, "Production", "ProductionSummary.aspx", 4);

            return new DashboardSnapshot
            {
                PeriodLabel = monthStart.ToString("MMM d", CultureInfo.InvariantCulture) + " - " + today.ToString("MMM d, yyyy", CultureInfo.InvariantCulture),
                GeneratedOn = DateTime.Now.ToString("MMM d, yyyy h:mm tt", CultureInfo.InvariantCulture),
                UserInfo = FirstRow(userInfo),
                Warnings = warnings,
                Tiles = BuildTiles(pendingTasks.Rows.Count, activeLoans.Rows.Count, creditLoans + servicingLoans, conditionPending.Rows.Count, feedback.Rows.Count, productionLoans),
                ChartLabels = new List<string> { "Credit", "Servicing", "Production", "Feedback", "Conditions" },
                ChartValues = new List<int> { creditLoans, servicingLoans, productionLoans, feedback.Rows.Count, conditionAll.Rows.Count },
                PerformanceMetrics = BuildPerformanceMetrics(creditSummary, servicingSummary),
                RecentActivity = recentActivity.Take(10).ToList(),
                PendingTasks = BuildPendingRows(pendingTasks),
                ModuleGroups = BuildModuleGroups()
            };
        }

        private static DataTable SafeTable(Func<DataTable> loader, List<string> warnings, string label)
        {
            try
            {
                return loader() ?? new DataTable();
            }
            catch (Exception ex)
            {
                warnings.Add(label + " - " + ex.Message);
                return new DataTable();
            }
        }

        private static Dictionary<string, object> FirstRow(DataTable table)
        {
            if (table == null || table.Rows.Count == 0)
            {
                return new Dictionary<string, object>();
            }

            return RowToDictionary(table.Rows[0]);
        }

        private static Dictionary<string, object> RowToDictionary(DataRow row)
        {
            Dictionary<string, object> item = new Dictionary<string, object>();
            foreach (DataColumn column in row.Table.Columns)
            {
                item[column.ColumnName] = row[column] == DBNull.Value ? string.Empty : row[column];
            }
            return item;
        }

        private static List<SummaryTile> BuildTiles(int pendingTasks, int activeLoans, int monthActivity, int conditionPending, int feedbackCount, int productionLoans)
        {
            return new List<SummaryTile>
            {
                new SummaryTile { Title = "Pending Tasks", Value = pendingTasks.ToString("N0", CultureInfo.InvariantCulture), Subtitle = "Dashboard notifications", Icon = "fas fa-bell", Tone = "amber", Url = "Dashboard.aspx" },
                new SummaryTile { Title = "Active Loans", Value = activeLoans.ToString("N0", CultureInfo.InvariantCulture), Subtitle = "Assigned loan queue", Icon = "fas fa-clipboard-list", Tone = "blue", Url = "LoanDetails.aspx" },
                new SummaryTile { Title = "Month Activity", Value = monthActivity.ToString("N0", CultureInfo.InvariantCulture), Subtitle = "Credit and servicing rows", Icon = "fas fa-chart-line", Tone = "teal", Url = "UserPerformanceReport.aspx" },
                new SummaryTile { Title = "Conditions", Value = conditionPending.ToString("N0", CultureInfo.InvariantCulture), Subtitle = "Pending analysis", Icon = "fas fa-tasks", Tone = "red", Url = "ConditionAnalysis.aspx" },
                new SummaryTile { Title = "Feedback", Value = feedbackCount.ToString("N0", CultureInfo.InvariantCulture), Subtitle = "Onshore entries this month", Icon = "fas fa-comment-dots", Tone = "green", Url = "InfinityFeedbackOnshore.aspx" },
                new SummaryTile { Title = "Production", Value = productionLoans.ToString("N0", CultureInfo.InvariantCulture), Subtitle = "Loans reviewed this month", Icon = "fas fa-layer-group", Tone = "slate", Url = "ProductionSummary.aspx" }
            };
        }

        private static List<MetricCard> BuildPerformanceMetrics(DataTable creditSummary, DataTable servicingSummary)
        {
            decimal? creditProd = AverageDecimal(creditSummary, "ProdPerc", "Productivity", "ProductivityPerc");
            decimal? creditQuality = AverageDecimal(creditSummary, "QualityPerc", "Quality", "QualityPercentage");
            decimal? creditAttendance = AverageDecimal(creditSummary, "AttPerc", "Attendance", "AttendancePerc");
            decimal? servicingProd = AverageDecimal(servicingSummary, "ProdPerc", "Productivity", "ProductivityPerc");
            decimal? servicingQuality = AverageDecimal(servicingSummary, "QualityPerc", "Quality", "QualityPercentage");
            decimal? servicingAttendance = AverageDecimal(servicingSummary, "AttPerc", "Attendance", "AttendancePerc");

            return new List<MetricCard>
            {
                BuildMetric("Productivity", AverageNullable(creditProd, servicingProd), "fas fa-tachometer-alt", "green"),
                BuildMetric("Quality", AverageNullable(creditQuality, servicingQuality), "fas fa-check-circle", "blue"),
                BuildMetric("Attendance", AverageNullable(creditAttendance, servicingAttendance), "fas fa-user-clock", "amber")
            };
        }

        private static MetricCard BuildMetric(string title, decimal? value, string icon, string tone)
        {
            int percent = value.HasValue ? Convert.ToInt32(Math.Max(0, Math.Min(100, value.Value))) : 0;
            return new MetricCard
            {
                Title = title,
                Value = value.HasValue ? value.Value.ToString("0.##", CultureInfo.InvariantCulture) + "%" : "--",
                Percent = percent,
                Icon = icon,
                Tone = tone
            };
        }

        private static decimal? AverageNullable(params decimal?[] values)
        {
            List<decimal> available = values.Where(x => x.HasValue).Select(x => x.Value).ToList();
            return available.Count == 0 ? (decimal?)null : available.Average();
        }

        private static decimal? AverageDecimal(DataTable table, params string[] columns)
        {
            if (table == null || table.Rows.Count == 0)
            {
                return null;
            }

            List<decimal> values = new List<decimal>();
            foreach (DataRow row in table.Rows)
            {
                foreach (string columnName in columns)
                {
                    if (!table.Columns.Contains(columnName))
                    {
                        continue;
                    }

                    decimal parsed;
                    if (TryParseDecimal(row[columnName], out parsed))
                    {
                        values.Add(parsed);
                        break;
                    }
                }
            }

            return values.Count == 0 ? (decimal?)null : values.Average();
        }

        private static int SumInt(DataTable table, params string[] columns)
        {
            if (table == null || table.Rows.Count == 0)
            {
                return 0;
            }

            decimal total = 0;
            foreach (DataRow row in table.Rows)
            {
                foreach (string columnName in columns)
                {
                    if (!table.Columns.Contains(columnName))
                    {
                        continue;
                    }

                    decimal parsed;
                    if (TryParseDecimal(row[columnName], out parsed))
                    {
                        total += parsed;
                        break;
                    }
                }
            }

            return Convert.ToInt32(Math.Round(total, 0));
        }

        private static bool TryParseDecimal(object value, out decimal result)
        {
            result = 0;
            if (value == null || value == DBNull.Value)
            {
                return false;
            }

            string text = Convert.ToString(value, CultureInfo.InvariantCulture);
            if (string.IsNullOrWhiteSpace(text))
            {
                return false;
            }

            text = text.Replace("%", string.Empty).Replace(",", string.Empty).Trim();
            return decimal.TryParse(text, NumberStyles.Any, CultureInfo.InvariantCulture, out result)
                || decimal.TryParse(text, NumberStyles.Any, CultureInfo.CurrentCulture, out result);
        }

        private static void AddActivityRows(List<ActivityRow> target, DataTable source, string area, string url, int take)
        {
            if (source == null || source.Rows.Count == 0)
            {
                return;
            }

            foreach (DataRow row in source.Rows.Cast<DataRow>().Take(take))
            {
                target.Add(new ActivityRow
                {
                    Area = area,
                    Reference = FirstAvailable(row, "LoanNo", "LoanNumber", "OrderNumber", "DealNo", "ProjectNo", "ProjectName"),
                    Status = FirstAvailable(row, "TaskPerformed", "Status", "Process", "Review", "Finding", "Comments"),
                    ActivityDate = FirstAvailable(row, "Date", "ProductionDate", "StartTime", "StartDate", "ReviewDate", "QCDate", "OrderDate"),
                    Url = url
                });
            }
        }

        private static List<ActivityRow> BuildPendingRows(DataTable table)
        {
            List<ActivityRow> rows = new List<ActivityRow>();
            if (table == null || table.Rows.Count == 0)
            {
                return rows;
            }

            foreach (DataRow row in table.Rows.Cast<DataRow>().Take(8))
            {
                rows.Add(new ActivityRow
                {
                    Area = "Task",
                    Reference = FirstAvailable(row, "Subject", "Title", "Task", "Notification", "Message", "Description"),
                    Status = FirstAvailable(row, "Status", "Type", "Priority", "Category"),
                    ActivityDate = FirstAvailable(row, "Date", "CreatedDate", "NotificationDate", "AddedDate"),
                    Url = FirstAvailable(row, "Url", "URL", "PageUrl", "Link", "RedirectUrl")
                });
            }
            return rows;
        }

        private static string FirstAvailable(DataRow row, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
            {
                if (row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value)
                {
                    string value = Convert.ToString(row[columnName], CultureInfo.InvariantCulture);
                    if (!string.IsNullOrWhiteSpace(value))
                    {
                        return value;
                    }
                }
            }

            foreach (DataColumn column in row.Table.Columns)
            {
                if (column.ColumnName.IndexOf("id", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    continue;
                }

                string value = row[column] == DBNull.Value ? string.Empty : Convert.ToString(row[column], CultureInfo.InvariantCulture);
                if (!string.IsNullOrWhiteSpace(value))
                {
                    return value;
                }
            }

            return "-";
        }

        private static List<ModuleGroup> BuildModuleGroups()
        {
            return new List<ModuleGroup>
            {
                new ModuleGroup
                {
                    Title = "Work Queue",
                    Icon = "fas fa-briefcase",
                    Links = new List<ModuleLink>
                    {
                        new ModuleLink { Title = "Dashboard", Url = "Dashboard.aspx" },
                        new ModuleLink { Title = "Loan Details", Url = "LoanDetails.aspx" },
                        new ModuleLink { Title = "Global Search", Url = "GlobalSearch.aspx" },
                        new ModuleLink { Title = "Re-QC Utility", Url = "ReQcUtility.aspx" }
                    }
                },
                new ModuleGroup
                {
                    Title = "Feedback",
                    Icon = "fas fa-comments",
                    Links = new List<ModuleLink>
                    {
                        new ModuleLink { Title = "Add Feedback", Url = "AddFeedback.aspx" },
                        new ModuleLink { Title = "Feedback Details", Url = "FeedbackDetails.aspx" },
                        new ModuleLink { Title = "Infinity Feedback Onshore", Url = "InfinityFeedbackOnshore.aspx" }
                    }
                },
                new ModuleGroup
                {
                    Title = "Conditions",
                    Icon = "fas fa-list-check",
                    Links = new List<ModuleLink>
                    {
                        new ModuleLink { Title = "Condition Clearing", Url = "ConditionClearing.aspx" },
                        new ModuleLink { Title = "Condition Analysis", Url = "ConditionAnalysis.aspx" },
                        new ModuleLink { Title = "Condition Clearing Report", Url = "ConditionClearingReport.aspx" }
                    }
                },
                new ModuleGroup
                {
                    Title = "Reports",
                    Icon = "fas fa-file-alt",
                    Links = new List<ModuleLink>
                    {
                        new ModuleLink { Title = "Production Summary", Url = "ProductionSummary.aspx" },
                        new ModuleLink { Title = "Production Report", Url = "ProductionReport.aspx" },
                        new ModuleLink { Title = "User Performance Report", Url = "UserPerformanceReport.aspx" },
                        new ModuleLink { Title = "Credit Consolidated Report", Url = "CreditConsolidatedReport.aspx" }
                    }
                }
            };
        }

        public class DashboardSnapshot
        {
            public string PeriodLabel { get; set; }
            public string GeneratedOn { get; set; }
            public Dictionary<string, object> UserInfo { get; set; }
            public List<string> Warnings { get; set; }
            public List<SummaryTile> Tiles { get; set; }
            public List<string> ChartLabels { get; set; }
            public List<int> ChartValues { get; set; }
            public List<MetricCard> PerformanceMetrics { get; set; }
            public List<ActivityRow> RecentActivity { get; set; }
            public List<ActivityRow> PendingTasks { get; set; }
            public List<ModuleGroup> ModuleGroups { get; set; }
        }

        public class SummaryTile
        {
            public string Title { get; set; }
            public string Value { get; set; }
            public string Subtitle { get; set; }
            public string Icon { get; set; }
            public string Tone { get; set; }
            public string Url { get; set; }
        }

        public class MetricCard
        {
            public string Title { get; set; }
            public string Value { get; set; }
            public int Percent { get; set; }
            public string Icon { get; set; }
            public string Tone { get; set; }
        }

        public class ActivityRow
        {
            public string Area { get; set; }
            public string Reference { get; set; }
            public string Status { get; set; }
            public string ActivityDate { get; set; }
            public string Url { get; set; }
        }

        public class ModuleGroup
        {
            public string Title { get; set; }
            public string Icon { get; set; }
            public List<ModuleLink> Links { get; set; }
        }

        public class ModuleLink
        {
            public string Title { get; set; }
            public string Url { get; set; }
        }
    }
}
