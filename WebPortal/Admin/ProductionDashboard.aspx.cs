using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Threading;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ProductionDashboard : Page
    {
        private const int DeadlockRetryCount = 2;
        private const string ReportReadPrefix = @"
                SET NOCOUNT ON;
                SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
";

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static string GetDashboardSnapshot(string FromDate, string ToDate)
        {
            DateTime fromDate;
            DateTime toDate;
            ResolveDateRange(FromDate, ToDate, out fromDate, out toDate);

            List<string> errors = new List<string>();
            Dictionary<string, DataTable> referenceData = TryGetReferenceData(fromDate, toDate, errors);

            DataTable performanceSummary = GetNamedTable(referenceData, "PerformanceSummary");
            DataTable productionDetails = GetNamedTable(referenceData, "ProductionDetails");
            DataTable feedbackDetails = GetNamedTable(referenceData, "FeedbackDetails");

            DataTable employeeWise = BuildEmployeeWise(performanceSummary);
            DataTable dateWise = BuildDateWise(productionDetails, feedbackDetails);
            DataTable processWise = BuildProcessWise(productionDetails, feedbackDetails, AverageColumn(employeeWise, "QualityPerc"));
            DateTime latestOrderDate = TryGetLatestOrderDate(toDate, errors);
            string reportMonth = toDate.ToString("MMMM", CultureInfo.InvariantCulture);
            string reportYear = toDate.Year.ToString(CultureInfo.InvariantCulture);

            DataTable weeklyGraphicalView = TryGetTable(delegate { return GetWeeklyGraphicalViewData(); }, "Weekly graphical view data could not be loaded.", errors);
            DataTable individualPerformance = PrepareIndividualPerformance(TryGetTable(delegate { return new bllReport().GetIndividualPerformance_Credit(reportMonth, reportYear); }, "Individual performance data could not be loaded.", errors));
            DataTable monthlyProjectVolume = TryGetTable(delegate { return GetProjectVolumeByMonth(latestOrderDate); }, "Last 12 months project volume could not be loaded from OrderData.", errors);
            DataTable dailyProjectVolume = TryGetTable(delegate { return GetProjectVolumeByDay(latestOrderDate); }, "Current month daily project volume could not be loaded from OrderData.", errors);

            Dictionary<string, object> snapshot = new Dictionary<string, object>();
            snapshot.Add("FromDate", fromDate.ToString("yyyy-MM-dd"));
            snapshot.Add("ToDate", toDate.ToString("yyyy-MM-dd"));
            snapshot.Add("FromDateText", fromDate.ToString("dd-MMM-yyyy"));
            snapshot.Add("ToDateText", toDate.ToString("dd-MMM-yyyy"));
            snapshot.Add("LatestOrderDate", latestOrderDate.ToString("yyyy-MM-dd"));
            snapshot.Add("LatestOrderDateText", latestOrderDate.ToString("dd-MMM-yyyy"));
            snapshot.Add("IndividualPerformancePeriod", reportMonth + " " + reportYear);
            snapshot.Add("GeneratedOn", DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"));
            snapshot.Add("Summary", DataTableToList(performanceSummary));
            snapshot.Add("ProductionDetails", DataTableToList(productionDetails));
            snapshot.Add("FeedbackDetails", DataTableToList(feedbackDetails));
            snapshot.Add("DateWise", DataTableToList(dateWise));
            snapshot.Add("ProcessWise", DataTableToList(processWise));
            snapshot.Add("EmployeeWise", DataTableToList(employeeWise));
            snapshot.Add("QualityVsProductivity", DataTableToList(employeeWise));
            snapshot.Add("WeeklyGraphicalView", DataTableToList(weeklyGraphicalView));
            snapshot.Add("IndividualPerformance", DataTableToList(individualPerformance));
            snapshot.Add("ProjectMonthlyVolume", BuildProjectVolumeMatrix(monthlyProjectVolume, latestOrderDate, true));
            snapshot.Add("ProjectDailyVolume", BuildProjectVolumeMatrix(dailyProjectVolume, latestOrderDate, false));
            snapshot.Add("Kpis", BuildKpis(employeeWise, dateWise, processWise, feedbackDetails));
            snapshot.Add("Workbench", BuildWorkbench(employeeWise, productionDetails, feedbackDetails, processWise));
            snapshot.Add("Errors", errors);

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(snapshot);
        }

        private static Dictionary<string, DataTable> TryGetReferenceData(DateTime fromDate, DateTime toDate, List<string> errors)
        {
            Dictionary<string, DataTable> tables = new Dictionary<string, DataTable>();
            string fromDateText = fromDate.ToString("yyyy-MM-dd");
            string toDateText = toDate.ToString("yyyy-MM-dd");
            int employeeId = 0;
            int.TryParse(HttpContext.Current.User.Identity.Name, out employeeId);

            bllMaster master = new bllMaster();
            tables.Add("PerformanceSummary", TryGetTable(delegate { return master.GetUserPerformanceReport(fromDateText, toDateText, employeeId); }, "Performance summary data could not be loaded.", errors));
            tables.Add("ProductionDetails", TryGetTable(delegate { return master.GetUserPerformanceProdDetails(fromDateText, toDateText, employeeId); }, "Production detail data could not be loaded.", errors));
            tables.Add("FeedbackDetails", TryGetTable(delegate { return master.GetUserPerformanceFeedbackDetails(fromDateText, toDateText, employeeId); }, "Feedback detail data could not be loaded.", errors));

            return tables;
        }

        private static DataTable TryGetTable(Func<DataTable> tableGetter, string errorMessage, List<string> errors)
        {
            try
            {
                DataTable table = tableGetter();
                return table ?? new DataTable();
            }
            catch
            {
                errors.Add(errorMessage);
                return new DataTable();
            }
        }

        private static DataTable PrepareIndividualPerformance(DataTable table)
        {
            if (table == null)
            {
                return new DataTable();
            }

            DataTable prepared = table.Copy();
            RemoveColumnIfExists(prepared, "Salary");
            RemoveColumnIfExists(prepared, "Month");
            RemoveColumnIfExists(prepared, "TotalOpprtinities");
            RemoveColumnIfExists(prepared, "TotalOpportunities");
            RemoveColumnIfExists(prepared, "MissedOpportunities");
            return prepared;
        }

        private static void RemoveColumnIfExists(DataTable table, string columnName)
        {
            if (table != null && table.Columns.Contains(columnName))
            {
                table.Columns.Remove(columnName);
            }
        }

        private static DataTable GetWeeklyGraphicalViewData()
        {
            DataTable table = new bllReport().WeeklyGraphicalView_QCDate();
            if (HasRows(table))
            {
                return table;
            }

            dalReport report = new dalReport();
            table = report.WeeklyGraphicalView_Credit_Infinity();
            if (HasRows(table))
            {
                return table;
            }

            table = report.WeeklyGraphicalView_Credit_Canopy();
            if (HasRows(table))
            {
                return table;
            }

            table = report.WeeklyGraphicalView_Servicing_Infinity();
            return table ?? new DataTable();
        }

        private static bool HasRows(DataTable table)
        {
            return table != null && table.Rows.Count > 0;
        }

        private static DateTime TryGetLatestOrderDate(DateTime fallbackDate, List<string> errors)
        {
            try
            {
                return GetLatestOrderDate(fallbackDate);
            }
            catch
            {
                errors.Add("Latest OrderData date could not be loaded.");
                return fallbackDate.Date;
            }
        }

        private static DateTime GetLatestOrderDate(DateTime fallbackDate)
        {
            string activityDate = OrderActivityDateExpression("od");
            string sql = @"
                SELECT MAX(ActivityDate) AS LatestDate
                FROM
                (
                    SELECT " + activityDate + @" AS ActivityDate
                    FROM dbo.OrderData od WITH (NOLOCK)
                ) x
                WHERE ActivityDate IS NOT NULL
                    AND ActivityDate <= CONVERT(date, GETDATE());";

            DataTable table = ExecuteQuery(sql, null);
            if (table.Rows.Count == 0 || table.Rows[0]["LatestDate"] == DBNull.Value)
            {
                return fallbackDate.Date;
            }

            DateTime latestDate;
            return DateTime.TryParse(Convert.ToString(table.Rows[0]["LatestDate"]), out latestDate)
                ? latestDate.Date
                : fallbackDate.Date;
        }

        private static DataTable GetProjectVolumeByMonth(DateTime latestOrderDate)
        {
            DateTime monthStart = new DateTime(latestOrderDate.Year, latestOrderDate.Month, 1);
            DateTime fromDate = monthStart.AddMonths(-11);
            DateTime toDateExclusive = latestOrderDate.Date.AddDays(1);
            string activityDate = OrderActivityDateExpression("od");

            string sql = @"
                SELECT
                    ProjectName,
                    CONVERT(date, DATEADD(month, DATEDIFF(month, 0, ActivityDate), 0)) AS PeriodStart,
                    COUNT(1) AS Volume
                FROM
                (
                    SELECT
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), pr.ProjectName))), ''),
                            CASE WHEN od.ProjectID IS NULL THEN 'NA' ELSE CONVERT(nvarchar(100), od.ProjectID) END) AS ProjectName,
                        " + activityDate + @" AS ActivityDate
                    FROM dbo.OrderData od WITH (NOLOCK)
                    LEFT JOIN dbo.Project pr WITH (NOLOCK) ON pr.ProjectID = od.ProjectID
                ) src
                WHERE ActivityDate >= @FromDate
                    AND ActivityDate < @ToDateExclusive
                GROUP BY ProjectName, CONVERT(date, DATEADD(month, DATEDIFF(month, 0, ActivityDate), 0))
                ORDER BY ProjectName, PeriodStart DESC;";

            return ExecuteProjectVolumeQuery(sql, fromDate, toDateExclusive);
        }

        private static DataTable GetProjectVolumeByDay(DateTime latestOrderDate)
        {
            DateTime fromDate = new DateTime(latestOrderDate.Year, latestOrderDate.Month, 1);
            DateTime toDateExclusive = latestOrderDate.Date.AddDays(1);
            string activityDate = OrderActivityDateExpression("od");

            string sql = @"
                SELECT
                    ProjectName,
                    ActivityDate AS PeriodStart,
                    COUNT(1) AS Volume
                FROM
                (
                    SELECT
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), pr.ProjectName))), ''),
                            CASE WHEN od.ProjectID IS NULL THEN 'NA' ELSE CONVERT(nvarchar(100), od.ProjectID) END) AS ProjectName,
                        " + activityDate + @" AS ActivityDate
                    FROM dbo.OrderData od WITH (NOLOCK)
                    LEFT JOIN dbo.Project pr WITH (NOLOCK) ON pr.ProjectID = od.ProjectID
                ) src
                WHERE ActivityDate >= @FromDate
                    AND ActivityDate < @ToDateExclusive
                GROUP BY ProjectName, ActivityDate
                ORDER BY ProjectName, PeriodStart DESC;";

            return ExecuteProjectVolumeQuery(sql, fromDate, toDateExclusive);
        }

        private static DataTable ExecuteProjectVolumeQuery(string sql, DateTime fromDate, DateTime toDateExclusive)
        {
            return ExecuteQuery(sql, delegate (SqlParameterCollection parameters)
            {
                parameters.Add("@FromDate", SqlDbType.Date).Value = fromDate.Date;
                parameters.Add("@ToDateExclusive", SqlDbType.Date).Value = toDateExclusive.Date;
            });
        }

        private static Dictionary<string, object> BuildProjectVolumeMatrix(DataTable source, DateTime latestOrderDate, bool monthly)
        {
            List<Dictionary<string, string>> columns = BuildProjectVolumeColumns(latestOrderDate, monthly);
            Dictionary<string, string> validColumnKeys = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (Dictionary<string, string> column in columns)
            {
                validColumnKeys[column["Key"]] = column["Label"];
            }

            Dictionary<string, ProjectVolumeAggregate> projectMap = new Dictionary<string, ProjectVolumeAggregate>(StringComparer.OrdinalIgnoreCase);

            if (source != null)
            {
                foreach (DataRow row in source.Rows)
                {
                    string projectName = FirstText(row, "ProjectName", "ClientNo", "Project");
                    if (string.IsNullOrWhiteSpace(projectName))
                    {
                        projectName = "NA";
                    }

                    DateTime periodStart;
                    if (!TryReadDate(row, "PeriodStart", out periodStart))
                    {
                        continue;
                    }

                    string key = monthly
                        ? periodStart.ToString("yyyy-MM", CultureInfo.InvariantCulture)
                        : periodStart.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);

                    if (!validColumnKeys.ContainsKey(key))
                    {
                        continue;
                    }

                    decimal volume = FirstDecimal(row, "Volume");
                    ProjectVolumeAggregate aggregate;
                    if (!projectMap.TryGetValue(projectName, out aggregate))
                    {
                        aggregate = new ProjectVolumeAggregate();
                        aggregate.ProjectName = projectName;
                        projectMap.Add(projectName, aggregate);
                    }

                    decimal currentValue;
                    aggregate.Values.TryGetValue(key, out currentValue);
                    aggregate.Values[key] = currentValue + volume;
                    aggregate.Total += volume;
                }
            }

            List<ProjectVolumeAggregate> projects = new List<ProjectVolumeAggregate>(projectMap.Values);
            projects.Sort(delegate (ProjectVolumeAggregate left, ProjectVolumeAggregate right)
            {
                int compare = right.Total.CompareTo(left.Total);
                return compare != 0 ? compare : string.Compare(left.ProjectName, right.ProjectName, StringComparison.OrdinalIgnoreCase);
            });

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (ProjectVolumeAggregate aggregate in projects)
            {
                Dictionary<string, object> values = new Dictionary<string, object>();
                foreach (Dictionary<string, string> column in columns)
                {
                    decimal volume;
                    values[column["Key"]] = aggregate.Values.TryGetValue(column["Key"], out volume) ? volume : 0;
                }

                Dictionary<string, object> row = new Dictionary<string, object>();
                row.Add("ClientNo", aggregate.ProjectName);
                row.Add("ProjectName", aggregate.ProjectName);
                row.Add("Total", aggregate.Total);
                row.Add("Values", values);
                rows.Add(row);
            }

            Dictionary<string, object> matrix = new Dictionary<string, object>();
            matrix.Add("Columns", columns);
            matrix.Add("Rows", rows);
            matrix.Add("LatestDateText", latestOrderDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture));
            matrix.Add("PeriodText", monthly
                ? new DateTime(latestOrderDate.Year, latestOrderDate.Month, 1).AddMonths(-11).ToString("MMM-yyyy", CultureInfo.InvariantCulture) + " to " + latestOrderDate.ToString("MMM-yyyy", CultureInfo.InvariantCulture)
                : new DateTime(latestOrderDate.Year, latestOrderDate.Month, 1).ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) + " to " + latestOrderDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture));
            return matrix;
        }

        private static List<Dictionary<string, string>> BuildProjectVolumeColumns(DateTime latestOrderDate, bool monthly)
        {
            List<Dictionary<string, string>> columns = new List<Dictionary<string, string>>();

            if (monthly)
            {
                DateTime monthStart = new DateTime(latestOrderDate.Year, latestOrderDate.Month, 1);
                for (int index = 0; index < 12; index++)
                {
                    DateTime month = monthStart.AddMonths(-index);
                    columns.Add(ProjectVolumeColumn(month.ToString("yyyy-MM", CultureInfo.InvariantCulture), month.ToString("MMM-yy", CultureInfo.InvariantCulture)));
                }
            }
            else
            {
                DateTime day = latestOrderDate.Date;
                DateTime firstDay = new DateTime(day.Year, day.Month, 1);
                while (day >= firstDay)
                {
                    columns.Add(ProjectVolumeColumn(day.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture), day.ToString("dd-MMM", CultureInfo.InvariantCulture)));
                    day = day.AddDays(-1);
                }
            }

            return columns;
        }

        private static Dictionary<string, string> ProjectVolumeColumn(string key, string label)
        {
            Dictionary<string, string> column = new Dictionary<string, string>();
            column.Add("Key", key);
            column.Add("Label", label);
            return column;
        }

        private static bool TryReadDate(DataRow row, string columnName, out DateTime dateValue)
        {
            dateValue = DateTime.MinValue;

            if (row == null || row.Table == null || !row.Table.Columns.Contains(columnName) || row[columnName] == DBNull.Value)
            {
                return false;
            }

            return DateTime.TryParse(Convert.ToString(row[columnName]), out dateValue);
        }

        private static string OrderActivityDateExpression(string alias)
        {
            return "COALESCE(" + DateExpression(alias + ".ReceivedDateTime") + ", " + DateExpression(alias + ".OrderDate") + ")";
        }

        private static string DateExpression(string columnName)
        {
            string clean = "NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(4000), " + columnName + "))), '')";
            return "CONVERT(date, CASE WHEN ISDATE(" + clean + ") = 1 THEN " + clean + " ELSE NULL END)";
        }

        private static DataTable ExecuteQuery(string sql, Action<SqlParameterCollection> addParameters)
        {
            for (int attempt = 0; attempt <= DeadlockRetryCount; attempt++)
            {
                try
                {
                    DataTable table = new DataTable();
                    using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
                    using (SqlCommand command = connection.CreateCommand())
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        command.CommandType = CommandType.Text;
                        command.CommandText = ReportReadPrefix + sql;
                        command.CommandTimeout = 0;

                        if (addParameters != null)
                        {
                            addParameters(command.Parameters);
                        }

                        connection.Open();
                        adapter.Fill(table);
                    }

                    return table;
                }
                catch (SqlException ex)
                {
                    if (!IsDeadlock(ex) || attempt == DeadlockRetryCount)
                    {
                        throw;
                    }

                    Thread.Sleep(250 * (attempt + 1));
                }
            }

            return new DataTable();
        }

        private static bool IsDeadlock(SqlException exception)
        {
            foreach (SqlError error in exception.Errors)
            {
                if (error.Number == 1205)
                {
                    return true;
                }
            }

            return false;
        }

        private static DataTable BuildEmployeeWise(DataTable summary)
        {
            DataTable table = CreateEmployeeTable();
            List<EmployeeAggregate> employees = new List<EmployeeAggregate>();

            if (summary != null)
            {
                foreach (DataRow row in summary.Rows)
                {
                    EmployeeAggregate employee = new EmployeeAggregate();
                    employee.EmployeeName = FirstText(row, "EmployeeName", "Name", "Employee");
                    employee.PseudoName = FirstText(row, "Employee", "PseudoName", "Pseudoname");
                    employee.Code = FirstText(row, "Code", "EmployeeCode", "EmpCode");
                    employee.LoanCount = FirstDecimal(row, "LoanCount", "Production Count", "Production");
                    employee.ProdPerc = FirstDecimal(row, "ProdPerc", "Production %", "ProductivityPercentage");
                    employee.QualityPerc = FirstDecimal(row, "QualityPerc", "Quality %", "QualPerc");
                    employee.AttPerc = FirstDecimal(row, "AttPerc", "Attendance %", "AttendancePerc");
                    employee.ProdGrade = FirstText(row, "ProdGrade", "Production Grade");
                    employee.QualGrade = FirstText(row, "QualGrade", "Quality Grade");
                    employee.AttnGrade = FirstText(row, "AttnGrade", "Attendance Grade");
                    employee.Critical = FirstDecimal(row, "Critical", "CriticalErrorCnt", "Critical Error");
                    employee.NonCritical = FirstDecimal(row, "NonCritical", "NonCriticalErrorCnt", "Non Critical Error");
                    employee.TotalError = FirstDecimal(row, "TotalError", "TotalErrors", "Total Error");

                    if (employee.TotalError == 0)
                    {
                        employee.TotalError = employee.Critical + employee.NonCritical;
                    }

                    employees.Add(employee);
                }
            }

            employees.Sort(delegate (EmployeeAggregate left, EmployeeAggregate right)
            {
                int compare = right.ProdPerc.CompareTo(left.ProdPerc);
                return compare != 0 ? compare : right.LoanCount.CompareTo(left.LoanCount);
            });

            foreach (EmployeeAggregate employee in employees)
            {
                DataRow dataRow = table.NewRow();
                dataRow["EmployeeName"] = employee.EmployeeName;
                dataRow["PseudoName"] = employee.PseudoName;
                dataRow["Code"] = employee.Code;
                dataRow["LoanCount"] = employee.LoanCount;
                dataRow["ProdPerc"] = employee.ProdPerc;
                dataRow["QualityPerc"] = employee.QualityPerc;
                dataRow["AttPerc"] = employee.AttPerc;
                dataRow["ProdGrade"] = employee.ProdGrade;
                dataRow["QualGrade"] = employee.QualGrade;
                dataRow["AttnGrade"] = employee.AttnGrade;
                dataRow["Critical"] = employee.Critical;
                dataRow["NonCritical"] = employee.NonCritical;
                dataRow["TotalError"] = employee.TotalError;
                table.Rows.Add(dataRow);
            }

            return table;
        }

        private static DataTable BuildDateWise(DataTable productionDetails, DataTable feedbackDetails)
        {
            Dictionary<string, ProductionAggregate> aggregates = new Dictionary<string, ProductionAggregate>(StringComparer.OrdinalIgnoreCase);

            if (productionDetails != null)
            {
                foreach (DataRow row in productionDetails.Rows)
                {
                    DateTime dateValue;
                    string dateText = FirstDateText(row, out dateValue, "Process Date", "ProcessDate", "OrderDate", "StartDate", "Date");
                    ProductionAggregate aggregate = GetAggregate(aggregates, dateText, dateValue);
                    aggregate.Production += ProductionValue(row);
                    aggregate.Target += FirstDecimal(row, "Target", "DailyTarget", "Target Count");
                }
            }

            if (feedbackDetails != null)
            {
                foreach (DataRow row in feedbackDetails.Rows)
                {
                    DateTime dateValue;
                    string dateText = FirstDateText(row, out dateValue, "OrderDate", "FeedbackRecivedDate", "FeedbackReceivedDate", "AddedDate", "Process Date");
                    ProductionAggregate aggregate = GetAggregate(aggregates, dateText, dateValue);
                    aggregate.TotalError += ErrorValue(row);
                }
            }

            List<ProductionAggregate> rows = new List<ProductionAggregate>(aggregates.Values);
            rows.Sort(delegate (ProductionAggregate left, ProductionAggregate right)
            {
                return left.DateValue.CompareTo(right.DateValue);
            });

            return ToProductionTable(rows, "ProcessDate");
        }

        private static DataTable BuildProcessWise(DataTable productionDetails, DataTable feedbackDetails, decimal defaultQuality)
        {
            Dictionary<string, ProductionAggregate> aggregates = new Dictionary<string, ProductionAggregate>(StringComparer.OrdinalIgnoreCase);

            if (productionDetails != null)
            {
                foreach (DataRow row in productionDetails.Rows)
                {
                    string process = FirstText(row, "Process", "ProcessName", "Process Name");
                    if (string.IsNullOrWhiteSpace(process))
                    {
                        process = "Unassigned";
                    }

                    ProductionAggregate aggregate = GetAggregate(aggregates, process, DateTime.MaxValue);
                    aggregate.Production += ProductionValue(row);
                    aggregate.Target += FirstDecimal(row, "Target", "DailyTarget", "Target Count");
                }
            }

            if (feedbackDetails != null)
            {
                foreach (DataRow row in feedbackDetails.Rows)
                {
                    string process = FirstText(row, "ProcessName", "Process", "Process Name");
                    if (string.IsNullOrWhiteSpace(process))
                    {
                        process = "Unassigned";
                    }

                    ProductionAggregate aggregate = GetAggregate(aggregates, process, DateTime.MaxValue);
                    aggregate.TotalError += ErrorValue(row);
                }
            }

            List<ProductionAggregate> rows = new List<ProductionAggregate>(aggregates.Values);
            foreach (ProductionAggregate aggregate in rows)
            {
                if (aggregate.Production == 0 && defaultQuality > 0)
                {
                    aggregate.QualityOverride = defaultQuality;
                }
            }

            rows.Sort(delegate (ProductionAggregate left, ProductionAggregate right)
            {
                return right.Production.CompareTo(left.Production);
            });

            return ToProductionTable(rows, "Process");
        }

        private static Dictionary<string, object> BuildKpis(DataTable employeeWise, DataTable dateWise, DataTable processWise, DataTable feedbackDetails)
        {
            decimal totalEmployees = employeeWise.Rows.Count;
            decimal totalProduction = SumColumn(employeeWise, "LoanCount");
            decimal totalErrors = SumColumn(employeeWise, "TotalError");

            if (totalErrors == 0 && feedbackDetails != null)
            {
                totalErrors = feedbackDetails.Rows.Count;
            }

            decimal avgProductivity = AverageColumn(employeeWise, "ProdPerc");
            decimal avgQuality = AverageColumn(employeeWise, "QualityPerc");
            decimal avgAttendance = AverageColumn(employeeWise, "AttPerc");

            Dictionary<string, object> kpis = new Dictionary<string, object>();
            kpis.Add("TotalEmployees", totalEmployees);
            kpis.Add("TotalProduction", totalProduction);
            kpis.Add("AvgProductivity", avgProductivity);
            kpis.Add("AvgQuality", avgQuality);
            kpis.Add("AvgAttendance", avgAttendance);
            kpis.Add("TotalErrors", totalErrors);
            kpis.Add("ProductiveDays", dateWise.Rows.Count);
            kpis.Add("ProcessCount", processWise.Rows.Count);
            kpis.Add("EmployeeRows", employeeWise.Rows.Count);
            kpis.Add("BestProductivity", MaxColumn(dateWise, "ProdPerc"));
            kpis.Add("BestQuality", MaxColumn(employeeWise, "QualityPerc"));
            kpis.Add("OutputPerEmployee", totalEmployees > 0 ? Math.Round(totalProduction / totalEmployees, 1) : 0);
            kpis.Add("ErrorRate", totalProduction > 0 ? Math.Round((totalErrors / totalProduction) * 100, 2) : 0);
            kpis.Add("QualityGap", avgQuality > 0 ? Math.Round(100 - avgQuality, 1) : 0);
            return kpis;
        }

        private static List<Dictionary<string, object>> BuildWorkbench(DataTable employeeWise, DataTable productionDetails, DataTable feedbackDetails, DataTable processWise)
        {
            List<Dictionary<string, object>> workbench = new List<Dictionary<string, object>>();
            workbench.Add(ActionItem("Daily Productivity", "Capture and review production entries for active employees.", productionDetails.Rows.Count, "DailyProductivity.aspx", "fas fa-keyboard"));
            workbench.Add(ActionItem("Productivity Update", "Review production changes, targets, and remarks awaiting update.", productionDetails.Rows.Count, "ProductivityUpdate.aspx", "fas fa-edit"));
            workbench.Add(ActionItem("Production Summary", "Open the legacy production summary view for detailed review.", processWise.Rows.Count, "ProductionSummary.aspx", "fas fa-chart-bar"));
            workbench.Add(ActionItem("Performance Report", "Open the source report used for summary, production, feedback, and attendance data.", employeeWise.Rows.Count, "UserPerformanceReport.aspx", "fas fa-user-chart"));
            workbench.Add(ActionItem("Feedback Details", "Review quality feedback records connected to the selected cycle.", feedbackDetails.Rows.Count, "UserPerformanceReport.aspx", "fas fa-comments"));
            workbench.Add(ActionItem("Project Configuration", "Maintain project targets, process mappings, and production configuration.", processWise.Rows.Count, "ProjectConfiguration.aspx", "fas fa-cogs"));
            return workbench;
        }

        private static Dictionary<string, object> ActionItem(string title, string description, int count, string url, string icon)
        {
            Dictionary<string, object> item = new Dictionary<string, object>();
            item.Add("Title", title);
            item.Add("Description", description);
            item.Add("Count", count);
            item.Add("Url", url);
            item.Add("Icon", icon);
            return item;
        }

        private static DataTable ToProductionTable(List<ProductionAggregate> rows, string nameColumn)
        {
            DataTable table = new DataTable();
            table.Columns.Add(nameColumn, typeof(string));
            table.Columns.Add("LoanCount", typeof(decimal));
            table.Columns.Add("Target", typeof(decimal));
            table.Columns.Add("TotalError", typeof(decimal));
            table.Columns.Add("ProdPerc", typeof(decimal));
            table.Columns.Add("QualityPerc", typeof(decimal));

            foreach (ProductionAggregate aggregate in rows)
            {
                decimal productivity = aggregate.Target > 0 ? Math.Round((aggregate.Production / aggregate.Target) * 100, 1) : 0;
                decimal quality = aggregate.QualityOverride > 0 ? aggregate.QualityOverride : 100;

                if (aggregate.Production > 0 && aggregate.TotalError > 0)
                {
                    quality = Math.Max(0, Math.Round(100 - ((aggregate.TotalError / aggregate.Production) * 100), 1));
                }

                DataRow row = table.NewRow();
                row[nameColumn] = aggregate.Name;
                row["LoanCount"] = aggregate.Production;
                row["Target"] = aggregate.Target;
                row["TotalError"] = aggregate.TotalError;
                row["ProdPerc"] = productivity;
                row["QualityPerc"] = quality;
                table.Rows.Add(row);
            }

            return table;
        }

        private static ProductionAggregate GetAggregate(Dictionary<string, ProductionAggregate> aggregates, string key, DateTime dateValue)
        {
            if (string.IsNullOrWhiteSpace(key))
            {
                key = "Unspecified";
            }

            ProductionAggregate aggregate;
            if (!aggregates.TryGetValue(key, out aggregate))
            {
                aggregate = new ProductionAggregate();
                aggregate.Name = key;
                aggregate.DateValue = dateValue;
                aggregates.Add(key, aggregate);
            }

            if (dateValue != DateTime.MaxValue && aggregate.DateValue == DateTime.MaxValue)
            {
                aggregate.DateValue = dateValue;
            }

            return aggregate;
        }

        private static decimal ProductionValue(DataRow row)
        {
            string[] productionColumns = { "Production", "LoanCount", "Production Count", "Count" };
            foreach (string columnName in productionColumns)
            {
                if (row.Table.Columns.Contains(columnName))
                {
                    decimal value = GetDecimal(row, columnName);
                    return value > 0 ? value : 0;
                }
            }

            return 1;
        }

        private static decimal ErrorValue(DataRow row)
        {
            decimal totalError = FirstDecimal(row, "TotalError", "TotalErrors", "Total Error");
            return totalError > 0 ? totalError : 1;
        }

        private static DataTable CreateEmployeeTable()
        {
            DataTable table = new DataTable();
            table.Columns.Add("EmployeeName", typeof(string));
            table.Columns.Add("PseudoName", typeof(string));
            table.Columns.Add("Code", typeof(string));
            table.Columns.Add("LoanCount", typeof(decimal));
            table.Columns.Add("ProdPerc", typeof(decimal));
            table.Columns.Add("QualityPerc", typeof(decimal));
            table.Columns.Add("AttPerc", typeof(decimal));
            table.Columns.Add("ProdGrade", typeof(string));
            table.Columns.Add("QualGrade", typeof(string));
            table.Columns.Add("AttnGrade", typeof(string));
            table.Columns.Add("Critical", typeof(decimal));
            table.Columns.Add("NonCritical", typeof(decimal));
            table.Columns.Add("TotalError", typeof(decimal));
            return table;
        }

        private static void ResolveDateRange(string fromDateValue, string toDateValue, out DateTime fromDate, out DateTime toDate)
        {
            DateTime today = DateTime.Today;

            if (!DateTime.TryParse(fromDateValue, out fromDate) || !DateTime.TryParse(toDateValue, out toDate))
            {
                if (today.Day >= 26)
                {
                    fromDate = new DateTime(today.Year, today.Month, 26);
                    toDate = fromDate.AddMonths(1).AddDays(-1);
                }
                else
                {
                    toDate = new DateTime(today.Year, today.Month, 25);
                    fromDate = toDate.AddMonths(-1).AddDays(1);
                }
            }

            if (fromDate > toDate)
            {
                DateTime temp = fromDate;
                fromDate = toDate;
                toDate = temp;
            }
        }

        private static DataTable GetNamedTable(Dictionary<string, DataTable> tables, string name)
        {
            DataTable table;
            return tables != null && tables.TryGetValue(name, out table) && table != null ? table : new DataTable();
        }

        private static List<Dictionary<string, object>> DataTableToList(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (table == null)
            {
                return rows;
            }

            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();

                foreach (DataColumn column in table.Columns)
                {
                    row.Add(column.ColumnName, NormalizeValue(dataRow[column]));
                }

                rows.Add(row);
            }

            return rows;
        }

        private static object NormalizeValue(object value)
        {
            if (value == null || value == DBNull.Value)
            {
                return string.Empty;
            }

            if (value is DateTime)
            {
                return ((DateTime)value).ToString("dd-MMM-yyyy");
            }

            return value;
        }

        private static string FirstText(DataRow row, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
            {
                if (row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value)
                {
                    string value = Convert.ToString(row[columnName]).Trim();
                    if (!string.IsNullOrWhiteSpace(value))
                    {
                        return value;
                    }
                }
            }

            return string.Empty;
        }

        private static string FirstDateText(DataRow row, out DateTime dateValue, params string[] columnNames)
        {
            dateValue = DateTime.MaxValue;

            foreach (string columnName in columnNames)
            {
                if (!row.Table.Columns.Contains(columnName) || row[columnName] == DBNull.Value)
                {
                    continue;
                }

                DateTime parsed;
                if (DateTime.TryParse(Convert.ToString(row[columnName]), out parsed))
                {
                    dateValue = parsed;
                    return parsed.ToString("dd-MMM-yyyy");
                }

                string text = Convert.ToString(row[columnName]).Trim();
                if (!string.IsNullOrWhiteSpace(text))
                {
                    return text;
                }
            }

            return "Unscheduled";
        }

        private static decimal FirstDecimal(DataRow row, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
            {
                decimal value = GetDecimal(row, columnName);
                if (value != 0)
                {
                    return value;
                }
            }

            return 0;
        }

        private static decimal SumColumn(DataTable table, string columnName)
        {
            decimal sum = 0;

            if (table == null || !table.Columns.Contains(columnName))
            {
                return sum;
            }

            foreach (DataRow row in table.Rows)
            {
                sum += GetDecimal(row, columnName);
            }

            return sum;
        }

        private static decimal AverageColumn(DataTable table, string columnName)
        {
            decimal sum = 0;
            decimal count = 0;

            if (table == null || !table.Columns.Contains(columnName))
            {
                return 0;
            }

            foreach (DataRow row in table.Rows)
            {
                decimal value = GetDecimal(row, columnName);
                if (value > 0)
                {
                    sum += value;
                    count++;
                }
            }

            return count > 0 ? Math.Round(sum / count, 1) : 0;
        }

        private static decimal MaxColumn(DataTable table, string columnName)
        {
            decimal max = 0;

            if (table == null || !table.Columns.Contains(columnName))
            {
                return max;
            }

            foreach (DataRow row in table.Rows)
            {
                decimal value = GetDecimal(row, columnName);
                if (value > max)
                {
                    max = value;
                }
            }

            return max;
        }

        private static decimal GetDecimal(DataRow row, string columnName)
        {
            if (row == null || row.Table == null || !row.Table.Columns.Contains(columnName) || row[columnName] == DBNull.Value)
            {
                return 0;
            }

            decimal parsed;
            return decimal.TryParse(Convert.ToString(row[columnName]), out parsed) ? parsed : 0;
        }

        private class EmployeeAggregate
        {
            public string EmployeeName { get; set; }
            public string PseudoName { get; set; }
            public string Code { get; set; }
            public decimal LoanCount { get; set; }
            public decimal ProdPerc { get; set; }
            public decimal QualityPerc { get; set; }
            public decimal AttPerc { get; set; }
            public string ProdGrade { get; set; }
            public string QualGrade { get; set; }
            public string AttnGrade { get; set; }
            public decimal Critical { get; set; }
            public decimal NonCritical { get; set; }
            public decimal TotalError { get; set; }
        }

        private class ProductionAggregate
        {
            public string Name { get; set; }
            public DateTime DateValue { get; set; }
            public decimal Production { get; set; }
            public decimal Target { get; set; }
            public decimal TotalError { get; set; }
            public decimal QualityOverride { get; set; }
        }

        private class ProjectVolumeAggregate
        {
            public ProjectVolumeAggregate()
            {
                Values = new Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase);
            }

            public string ProjectName { get; set; }
            public decimal Total { get; set; }
            public Dictionary<string, decimal> Values { get; private set; }
        }
    }
}
