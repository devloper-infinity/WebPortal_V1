using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ManagementVolumeReport : Page
    {
        private const int ProjectPerformanceRowLimit = 1500;
        private const int ProjectDatewiseRowLimit = 5000;
        private const int UserQualityRowLimit = 3000;
        private const int CostDetailRowLimit = 2500;
        private const int LoanDetailsRowLimit = 2500;
        private const int DeadlockRetryCount = 2;
        private const string ReportReadPrefix = @"
                SET NOCOUNT ON;
                SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
";

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetFilterOptions()
        {
            if (!HasManagementAccess())
            {
                return Serialize(new { HasAccess = false });
            }

            DataTable statuses = ExecuteQuery(@"
                SELECT TOP 500 Value, Value AS Text
                FROM
                (
                    SELECT DISTINCT NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), FinalStatus))), '') AS Value
                    FROM dbo.OrderData WITH (NOLOCK)
                ) x
                WHERE Value IS NOT NULL
                ORDER BY Value", null);

            return Serialize(new
            {
                HasAccess = true,
                Statuses = ToRows(statuses)
            });
        }

        [WebMethod]
        public static string RunDashboard(string FromDate, string ToDate, string Status)
        {
            if (!HasManagementAccess())
            {
                return Serialize(new { HasAccess = false });
            }

            ReportRange range = NormalizeRange(FromDate, ToDate);
            ReportFilters filters = new ReportFilters(range.FromDate, range.ToDate, Status);

            DataSet data = GetDashboardData(filters);
            DataTable summary = GetTable(data, 0);
            DataTable daily = GetTable(data, 1);
            DataTable users = GetTable(data, 2);
            DataTable statuses = GetTable(data, 3);
            DataTable processes = GetTable(data, 4);

            return Serialize(new
            {
                HasAccess = true,
                GeneratedOn = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt", CultureInfo.InvariantCulture),
                Period = range.FromDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) + " to " + range.ToDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                Summary = BuildSummaryCards(summary),
                DailySummary = ToRows(daily),
                UserProduction = ToRows(users),
                StatusSummary = ToRows(statuses),
                ProcessSummary = ToRows(processes)
            });
        }

        [WebMethod]
        public static string RunLoanDetails(string FromDate, string ToDate, string Status)
        {
            if (!HasManagementAccess())
            {
                return Serialize(new { HasAccess = false });
            }

            ReportRange range = NormalizeRange(FromDate, ToDate);
            ReportFilters filters = new ReportFilters(range.FromDate, range.ToDate, Status);

            return Serialize(new
            {
                HasAccess = true,
                Rows = ToRows(GetLoanDetails(filters))
            });
        }

        [WebMethod]
        public static string RunProjectPerformance(string FromDate, string ToDate, string Status)
        {
            if (!HasManagementAccess())
            {
                return Serialize(new { HasAccess = false });
            }

            ReportRange range = NormalizeRange(FromDate, ToDate);
            ReportFilters filters = new ReportFilters(range.FromDate, range.ToDate, Status);

            return Serialize(new
            {
                HasAccess = true,
                Rows = ToRows(GetProjectPerformance(filters))
            });
        }

        [WebMethod]
        public static string RunProjectDatewiseVolumeDetails(string FromDate, string ToDate, string Status)
        {
            if (!HasManagementAccess())
            {
                return Serialize(new { HasAccess = false });
            }

            ReportRange range = NormalizeRange(FromDate, ToDate);
            ReportFilters filters = new ReportFilters(range.FromDate, range.ToDate, Status);

            return Serialize(new
            {
                HasAccess = true,
                Rows = ToRows(GetProjectDatewiseVolumeDetails(filters))
            });
        }

        [WebMethod]
        public static string RunUserQualityReport(string FromDate, string ToDate, string Status)
        {
            if (!HasManagementAccess())
            {
                return Serialize(new { HasAccess = false });
            }

            ReportRange range = NormalizeRange(FromDate, ToDate);
            ReportFilters filters = new ReportFilters(range.FromDate, range.ToDate, Status);

            return Serialize(new
            {
                HasAccess = true,
                Rows = ToRows(GetUserQualityReport(filters))
            });
        }

        [WebMethod]
        public static string RunCostPerLoanReport(string FromDate, string ToDate, string Status)
        {
            if (!HasManagementAccess())
            {
                return Serialize(new { HasAccess = false });
            }

            ReportRange range = NormalizeRange(FromDate, ToDate);
            ReportFilters filters = new ReportFilters(range.FromDate, range.ToDate, Status);
            DataSet data = GetCostPerLoanData(filters);

            return Serialize(new
            {
                HasAccess = true,
                UserRows = ToRows(GetTable(data, 0)),
                ProcessRows = ToRows(GetTable(data, 1)),
                DetailRows = ToRows(GetTable(data, 2))
            });
        }

        [WebMethod]
        public static string RunCustomReport(string FromDate, string ToDate, string Status, string GroupBy)
        {
            if (!HasManagementAccess())
            {
                return Serialize(new { HasAccess = false });
            }

            ReportRange range = NormalizeRange(FromDate, ToDate);
            ReportFilters filters = new ReportFilters(range.FromDate, range.ToDate, Status);
            CustomGroup group = GetCustomGroup(GroupBy);
            DataTable rows = GetCustomReport(filters, group);

            return Serialize(new
            {
                HasAccess = true,
                Title = group.Title,
                Rows = ToRows(rows)
            });
        }

        private static DataSet GetDashboardData(ReportFilters filters)
        {
            string orderDate = DateExpression("od.OrderDate");
            string receivedDate = DateExpression("od.ReceivedDateTime");
            string dispatchDate = DateExpression("od.DispatchDate");
            string productionOrderDate = DateExpression("pd.OrderDate");
            string productionEndDate = DateExpression("pd.EndDate");
            string productionDispatchDate = DateExpression("pd.DispatchDate");
            string productionStartDateTime = DateTimeExpression("pd.StartDate");
            string productionEndDateTime = DateTimeExpression("pd.EndDate");

            string sql = @"
                SET NOCOUNT ON;

                ;WITH E1(N) AS
                (
                    SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
                    UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
                ),
                E2(N) AS (SELECT 1 FROM E1 a CROSS JOIN E1 b),
                E4(N) AS (SELECT 1 FROM E2 a CROSS JOIN E2 b),
                Nums(N) AS
                (
                    SELECT TOP (DATEDIFF(day, @FromDate, @ToDate) + 1)
                        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1
                    FROM E4
                )
                SELECT DATEADD(day, N, @FromDate) AS CalendarDate
                INTO #Dates
                FROM Nums;

                SELECT *
                INTO #OrderBase
                FROM
                (
                    SELECT
                        od.OrderID,
                        od.ProjectID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.DealNo))), '') AS DealNo,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.LoanNo))), '') AS LoanNo,
                        COALESCE(" + receivedDate + @", " + orderDate + @") AS ReceivedDate,
                        " + dispatchDate + @" AS DispatchDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.FinalStatus))), ''), '') AS FinalStatus
                    FROM dbo.OrderData od WITH (NOLOCK)
                ) o
                WHERE (@Status = '' OR ISNULL(o.FinalStatus, '') = @Status)
                    AND
                    (
                        o.ReceivedDate BETWEEN @FromDate AND @ToDate
                        OR o.DispatchDate BETWEEN @FromDate AND @ToDate
                    );

                SELECT *
                INTO #ProductionBase
                FROM
                (
                    SELECT
                        pd.ProdID,
                        pd.ProjectID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.DealNo))), '') AS DealNo,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.LoanNo))), '') AS LoanNo,
                        " + productionOrderDate + @" AS OrderDate,
                        " + productionEndDate + @" AS ProductionDate,
                        " + productionStartDateTime + @" AS ProcessStartDate,
                        " + productionEndDateTime + @" AS ProcessEndDate,
                        " + productionDispatchDate + @" AS DispatchDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.FinalStatus))), ''), '') AS FinalStatus,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.Code))), '') AS Code,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), pd.Employee))), '') AS Employee,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.Process))), '') AS Process,
                        pd.Target AS Target
                    FROM dbo.ProductionData pd WITH (NOLOCK)
                ) p
                WHERE p.ProductionDate BETWEEN @FromDate AND @ToDate
                    AND (@Status = '' OR ISNULL(p.FinalStatus, '') = @Status);

                CREATE CLUSTERED INDEX IX_Dates_CalendarDate ON #Dates(CalendarDate);
                CREATE NONCLUSTERED INDEX IX_OrderBase_ReceivedDate ON #OrderBase(ReceivedDate);
                CREATE NONCLUSTERED INDEX IX_OrderBase_DispatchDate ON #OrderBase(DispatchDate);
                CREATE NONCLUSTERED INDEX IX_OrderBase_LoanNo ON #OrderBase(LoanNo);
                CREATE NONCLUSTERED INDEX IX_ProductionBase_ProductionDate ON #ProductionBase(ProductionDate);
                CREATE NONCLUSTERED INDEX IX_ProductionBase_LoanNo ON #ProductionBase(LoanNo);

                SELECT
                    ISNULL(SUM(CASE WHEN ReceivedDate BETWEEN @FromDate AND @ToDate THEN 1 ELSE 0 END), 0) AS ReceivedVolume,
                    (SELECT COUNT(NULLIF(LoanNo, '')) FROM #ProductionBase) AS ProductionCount,
                    COUNT(DISTINCT CASE WHEN ReceivedDate BETWEEN @FromDate AND @ToDate THEN NULLIF(LoanNo, '') END) AS UniqueReceivedLoans,
                    ISNULL(SUM(CASE WHEN DispatchDate BETWEEN @FromDate AND @ToDate THEN 1 ELSE 0 END), 0) AS DispatchedVolume,
                    ISNULL(SUM(CASE WHEN ReceivedDate BETWEEN @FromDate AND @ToDate AND (DispatchDate IS NULL OR DispatchDate > @ToDate) THEN 1 ELSE 0 END), 0) AS LoansInProcess,
                    (SELECT COUNT(DISTINCT NULLIF(Code, '')) FROM #ProductionBase) AS ActiveUsers
                FROM #OrderBase;

                ;WITH Received AS
                (
                    SELECT ReceivedDate AS ReportDate,
                        COUNT(*) AS ReceivedVolume,
                        COUNT(DISTINCT NULLIF(LoanNo, '')) AS UniqueLoans
                    FROM #OrderBase
                    WHERE ReceivedDate BETWEEN @FromDate AND @ToDate
                    GROUP BY ReceivedDate
                ),
                Production AS
                (
                    SELECT ProductionDate AS ReportDate,
                        COUNT(NULLIF(LoanNo, '')) AS ProductionCount,
                        COUNT(DISTINCT NULLIF(Code, '')) AS ActiveUsers
                    FROM #ProductionBase
                    GROUP BY ProductionDate
                ),
                Dispatched AS
                (
                    SELECT DispatchDate AS ReportDate,
                        COUNT(*) AS DispatchedVolume
                    FROM #OrderBase
                    WHERE DispatchDate BETWEEN @FromDate AND @ToDate
                    GROUP BY DispatchDate
                )
                SELECT
                    d.CalendarDate AS ReportDate,
                    ISNULL(r.ReceivedVolume, 0) AS ReceivedVolume,
                    ISNULL(p.ProductionCount, 0) AS ProductionCount,
                    ISNULL(ds.DispatchedVolume, 0) AS DispatchedVolume,
                    ISNULL(wip.LoansInProcess, 0) AS LoansInProcess,
                    ISNULL(r.UniqueLoans, 0) AS UniqueReceivedLoans,
                    ISNULL(p.ActiveUsers, 0) AS ActiveUsers,
                    CAST(CASE WHEN ISNULL(r.ReceivedVolume, 0) > 0
                        THEN (CAST(ISNULL(ds.DispatchedVolume, 0) AS decimal(18, 2)) / CAST(r.ReceivedVolume AS decimal(18, 2))) * 100
                        ELSE 0 END AS decimal(18, 2)) AS DispatchPct
                FROM #Dates d
                LEFT JOIN Received r ON r.ReportDate = d.CalendarDate
                LEFT JOIN Production p ON p.ReportDate = d.CalendarDate
                LEFT JOIN Dispatched ds ON ds.ReportDate = d.CalendarDate
                OUTER APPLY
                (
                    SELECT COUNT(*) AS LoansInProcess
                    FROM #OrderBase o
                    WHERE o.ReceivedDate BETWEEN @FromDate AND d.CalendarDate
                        AND (o.DispatchDate IS NULL OR o.DispatchDate > d.CalendarDate)
                ) wip
                ORDER BY d.CalendarDate;

                ;WITH ProductionStage AS
                (
                    SELECT
                        Code,
                        Employee,
                        Process,
                        ProductionDate,
                        ISNULL(Target, 0) AS Target,
                        COUNT(NULLIF(LoanNo, '')) AS LoanCount,
                        CAST(CASE WHEN ISNULL(Target, 0) > 0
                            THEN (CAST(COUNT(NULLIF(LoanNo, '')) AS decimal(18, 2)) / CAST(ISNULL(Target, 0) AS decimal(18, 2))) * 100
                            ELSE 0 END AS decimal(18, 2)) AS ProdPerc
                    FROM #ProductionBase
                    GROUP BY Code, Employee, Process, ProductionDate, ISNULL(Target, 0)
                ),
                UserDaily AS
                (
                    SELECT
                        Code,
                        Employee,
                        ProductionDate,
                        SUM(LoanCount) AS LoanCount,
                        SUM(ProdPerc) AS ProdPerc
                    FROM ProductionStage
                    GROUP BY Code, Employee, ProductionDate
                )
                SELECT
                    ISNULL(Code, '') AS Code,
                    ISNULL(Employee, '') AS Employee,
                    SUM(LoanCount) AS ProductionCount,
                    COUNT(DISTINCT ProductionDate) AS WorkingDays,
                    CAST(CASE WHEN COUNT(DISTINCT ProductionDate) > 0
                        THEN CAST(SUM(LoanCount) AS decimal(18, 2)) / CAST(COUNT(DISTINCT ProductionDate) AS decimal(18, 2))
                        ELSE 0 END AS decimal(18, 2)) AS AvgPerDay,
                    CAST(AVG(ProdPerc) AS decimal(18, 2)) AS ProductionPct,
                    MIN(ProductionDate) AS FirstProductionDate,
                    MAX(ProductionDate) AS LastProductionDate
                FROM UserDaily
                GROUP BY Code, Employee
                ORDER BY ProductionCount DESC, Employee;

                SELECT
                    ISNULL(NULLIF(FinalStatus, ''), 'Blank') AS FinalStatus,
                    SUM(CASE WHEN ReceivedDate BETWEEN @FromDate AND @ToDate THEN 1 ELSE 0 END) AS ReceivedVolume,
                    SUM(CASE WHEN DispatchDate BETWEEN @FromDate AND @ToDate THEN 1 ELSE 0 END) AS DispatchedVolume,
                    SUM(CASE WHEN ReceivedDate BETWEEN @FromDate AND @ToDate AND (DispatchDate IS NULL OR DispatchDate > @ToDate) THEN 1 ELSE 0 END) AS LoansInProcess,
                    COUNT(DISTINCT NULLIF(LoanNo, '')) AS UniqueLoans
                FROM #OrderBase
                GROUP BY ISNULL(NULLIF(FinalStatus, ''), 'Blank')
                ORDER BY ReceivedVolume DESC, LoansInProcess DESC;

                SELECT
                    ISNULL(NULLIF(Process, ''), 'Blank') AS Process,
                    COUNT(NULLIF(LoanNo, '')) AS ProductionCount,
                    COUNT(DISTINCT NULLIF(LoanNo, '')) AS UniqueLoans,
                    COUNT(DISTINCT NULLIF(Code, '')) AS ActiveUsers,
                    CAST(AVG(CAST(ISNULL(Target, 0) AS decimal(18, 2))) AS decimal(18, 2)) AS AvgTarget,
                    COUNT(CASE WHEN ProcessStartDate IS NOT NULL AND ProcessEndDate IS NOT NULL AND ProcessEndDate >= ProcessStartDate THEN 1 END) AS CompletedForTAT,
                    CAST(AVG(CASE WHEN ProcessStartDate IS NOT NULL AND ProcessEndDate IS NOT NULL AND ProcessEndDate >= ProcessStartDate
                        THEN CAST(DATEDIFF(minute, ProcessStartDate, ProcessEndDate) AS decimal(18, 2)) END) / 60.0 AS decimal(18, 2)) AS AvgProcessTATHours,
                    CAST(AVG(CASE WHEN ProcessStartDate IS NOT NULL AND ProcessEndDate IS NOT NULL AND ProcessEndDate >= ProcessStartDate
                        THEN CAST(DATEDIFF(minute, ProcessStartDate, ProcessEndDate) AS decimal(18, 2)) END) / 1440.0 AS decimal(18, 2)) AS AvgProcessTATDays,
                    MIN(ProductionDate) AS FirstProductionDate,
                    MAX(ProductionDate) AS LastProductionDate
                FROM #ProductionBase
                GROUP BY ISNULL(NULLIF(Process, ''), 'Blank')
                ORDER BY ProductionCount DESC, Process;";

            return ExecuteReportDataSet(sql, filters);
        }

        private static DataTable GetSummary(ReportFilters filters)
        {
            string sql = BuildBaseCte() + @"
                SELECT
                    (SELECT COUNT(*) FROM OrderBase WHERE ReceivedDate BETWEEN @FromDate AND @ToDate) AS ReceivedVolume,
                    (SELECT COUNT(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), LoanNo))), '')) FROM ProductionBase) AS ProductionCount,
                    (SELECT COUNT(DISTINCT NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), LoanNo))), '')) FROM OrderBase WHERE ReceivedDate BETWEEN @FromDate AND @ToDate) AS UniqueReceivedLoans,
                    (SELECT COUNT(*) FROM OrderBase WHERE DispatchDate BETWEEN @FromDate AND @ToDate) AS DispatchedVolume,
                    (SELECT COUNT(*) FROM OrderBase WHERE ReceivedDate BETWEEN @FromDate AND @ToDate AND (DispatchDate IS NULL OR DispatchDate > @ToDate)) AS LoansInProcess,
                    (SELECT COUNT(DISTINCT NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), Code))), '')) FROM ProductionBase) AS ActiveUsers,
                    (SELECT CAST(AVG(CAST(DailyVolume AS decimal(18, 2))) AS decimal(18, 2))
                        FROM
                        (
                            SELECT d.CalendarDate, COUNT(o.OrderID) AS DailyVolume
                            FROM Dates d
                            LEFT JOIN OrderBase o ON o.ReceivedDate = d.CalendarDate
                            GROUP BY d.CalendarDate
                        ) x) AS AvgDailyVolume,
                    (SELECT CAST(AVG(CAST(DailyProduction AS decimal(18, 2))) AS decimal(18, 2))
                        FROM
                        (
                            SELECT d.CalendarDate, COUNT(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), p.LoanNo))), '')) AS DailyProduction
                            FROM Dates d
                            LEFT JOIN ProductionBase p ON p.ProductionDate = d.CalendarDate
                            GROUP BY d.CalendarDate
                        ) x) AS AvgDailyProduction";

            return ExecuteReportQuery(sql, filters);
        }

        private static DataTable GetDailySummary(ReportFilters filters)
        {
            string sql = BuildBaseCte() + @"
                SELECT
                    d.CalendarDate AS ReportDate,
                    ISNULL(received.ReceivedVolume, 0) AS ReceivedVolume,
                    ISNULL(production.ProductionCount, 0) AS ProductionCount,
                    ISNULL(dispatched.DispatchedVolume, 0) AS DispatchedVolume,
                    ISNULL(inprocess.LoansInProcess, 0) AS LoansInProcess,
                    ISNULL(received.UniqueLoans, 0) AS UniqueReceivedLoans,
                    ISNULL(production.ActiveUsers, 0) AS ActiveUsers,
                    CAST(CASE WHEN ISNULL(received.ReceivedVolume, 0) > 0
                        THEN (CAST(ISNULL(dispatched.DispatchedVolume, 0) AS decimal(18, 2)) / CAST(received.ReceivedVolume AS decimal(18, 2))) * 100
                        ELSE 0 END AS decimal(18, 2)) AS DispatchPct
                FROM Dates d
                OUTER APPLY
                (
                    SELECT COUNT(*) AS ReceivedVolume,
                        COUNT(DISTINCT NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), LoanNo))), '')) AS UniqueLoans
                    FROM OrderBase
                    WHERE ReceivedDate = d.CalendarDate
                ) received
                OUTER APPLY
                (
                    SELECT COUNT(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), LoanNo))), '')) AS ProductionCount,
                        COUNT(DISTINCT NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), Code))), '')) AS ActiveUsers
                    FROM ProductionBase
                    WHERE ProductionDate = d.CalendarDate
                ) production
                OUTER APPLY
                (
                    SELECT COUNT(*) AS DispatchedVolume
                    FROM OrderBase
                    WHERE DispatchDate = d.CalendarDate
                ) dispatched
                OUTER APPLY
                (
                    SELECT COUNT(*) AS LoansInProcess
                    FROM OrderBase
                    WHERE ReceivedDate BETWEEN @FromDate AND d.CalendarDate
                        AND (DispatchDate IS NULL OR DispatchDate > d.CalendarDate)
                ) inprocess
                ORDER BY d.CalendarDate";

            return ExecuteReportQuery(sql, filters);
        }

        private static DataTable GetUserProduction(ReportFilters filters)
        {
            string sql = BuildBaseCte() + @"
                , ProductionStage AS
                (
                    SELECT
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), Code))), '') AS Code,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), Employee))), '') AS Employee,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), Process))), '') AS Process,
                        ProductionDate,
                        ISNULL(Target, 0) AS Target,
                        COUNT(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), LoanNo))), '')) AS LoanCount,
                        CAST(CASE WHEN ISNULL(Target, 0) > 0
                            THEN (CAST(COUNT(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), LoanNo))), '')) AS decimal(18, 2)) / CAST(ISNULL(Target, 0) AS decimal(18, 2))) * 100
                            ELSE 0 END AS decimal(18, 2)) AS ProdPerc
                    FROM ProductionBase
                    WHERE ProductionDate BETWEEN @FromDate AND @ToDate
                    GROUP BY
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), Code))), ''),
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), Employee))), ''),
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), Process))), ''),
                        ProductionDate,
                        ISNULL(Target, 0)
                ),
                UserDaily AS
                (
                    SELECT
                        Code,
                        Employee,
                        ProductionDate,
                        SUM(LoanCount) AS LoanCount,
                        SUM(ProdPerc) AS ProdPerc
                    FROM ProductionStage
                    GROUP BY Code, Employee, ProductionDate
                )
                SELECT
                    ISNULL(Code, '') AS Code,
                    ISNULL(Employee, '') AS Employee,
                    SUM(LoanCount) AS ProductionCount,
                    COUNT(DISTINCT ProductionDate) AS WorkingDays,
                    CAST(CASE WHEN COUNT(DISTINCT ProductionDate) > 0
                        THEN CAST(SUM(LoanCount) AS decimal(18, 2)) / CAST(COUNT(DISTINCT ProductionDate) AS decimal(18, 2))
                        ELSE 0 END AS decimal(18, 2)) AS AvgPerDay,
                    CAST(AVG(ProdPerc) AS decimal(18, 2)) AS ProductionPct,
                    MIN(ProductionDate) AS FirstProductionDate,
                    MAX(ProductionDate) AS LastProductionDate
                FROM UserDaily
                GROUP BY Code, Employee
                ORDER BY ProductionCount DESC, Employee";

            return ExecuteReportQuery(sql, filters);
        }

        private static DataTable GetStatusSummary(ReportFilters filters)
        {
            string sql = BuildBaseCte() + @"
                SELECT
                    ISNULL(NULLIF(FinalStatus, ''), 'Blank') AS FinalStatus,
                    SUM(CASE WHEN ReceivedDate BETWEEN @FromDate AND @ToDate THEN 1 ELSE 0 END) AS ReceivedVolume,
                    SUM(CASE WHEN DispatchDate BETWEEN @FromDate AND @ToDate THEN 1 ELSE 0 END) AS DispatchedVolume,
                    SUM(CASE WHEN ReceivedDate BETWEEN @FromDate AND @ToDate AND (DispatchDate IS NULL OR DispatchDate > @ToDate) THEN 1 ELSE 0 END) AS LoansInProcess,
                    COUNT(DISTINCT NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), LoanNo))), '')) AS UniqueLoans
                FROM OrderBase
                WHERE ReceivedDate BETWEEN @FromDate AND @ToDate
                    OR DispatchDate BETWEEN @FromDate AND @ToDate
                    OR (ReceivedDate BETWEEN @FromDate AND @ToDate AND (DispatchDate IS NULL OR DispatchDate > @ToDate))
                GROUP BY ISNULL(NULLIF(FinalStatus, ''), 'Blank')
                ORDER BY ReceivedVolume DESC, LoansInProcess DESC";

            return ExecuteReportQuery(sql, filters);
        }

        private static DataTable GetProcessSummary(ReportFilters filters)
        {
            string sql = BuildBaseCte() + @"
                SELECT
                    ISNULL(NULLIF(Process, ''), 'Blank') AS Process,
                    COUNT(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), LoanNo))), '')) AS ProductionCount,
                    COUNT(DISTINCT NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), LoanNo))), '')) AS UniqueLoans,
                    COUNT(DISTINCT NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), Code))), '')) AS ActiveUsers,
                    CAST(AVG(CAST(ISNULL(Target, 0) AS decimal(18, 2))) AS decimal(18, 2)) AS AvgTarget,
                    COUNT(CASE WHEN ProcessStartDate IS NOT NULL AND ProcessEndDate IS NOT NULL AND ProcessEndDate >= ProcessStartDate THEN 1 END) AS CompletedForTAT,
                    CAST(AVG(CASE WHEN ProcessStartDate IS NOT NULL AND ProcessEndDate IS NOT NULL AND ProcessEndDate >= ProcessStartDate
                        THEN CAST(DATEDIFF(minute, ProcessStartDate, ProcessEndDate) AS decimal(18, 2)) END) / 60.0 AS decimal(18, 2)) AS AvgProcessTATHours,
                    CAST(AVG(CASE WHEN ProcessStartDate IS NOT NULL AND ProcessEndDate IS NOT NULL AND ProcessEndDate >= ProcessStartDate
                        THEN CAST(DATEDIFF(minute, ProcessStartDate, ProcessEndDate) AS decimal(18, 2)) END) / 1440.0 AS decimal(18, 2)) AS AvgProcessTATDays,
                    MIN(ProductionDate) AS FirstProductionDate,
                    MAX(ProductionDate) AS LastProductionDate
                FROM ProductionBase
                GROUP BY ISNULL(NULLIF(Process, ''), 'Blank')
                ORDER BY ProductionCount DESC, Process";

            return ExecuteReportQuery(sql, filters);
        }

        private static DataTable GetProjectPerformance(ReportFilters filters)
        {
            string orderDate = DateExpression("od.OrderDate");
            string receivedDate = DateExpression("od.ReceivedDateTime");
            string dispatchDate = DateExpression("od.DispatchDate");
            string productionOrderDate = DateExpression("pd.OrderDate");
            string productionEndDate = DateExpression("pd.EndDate");
            string productionStartDateTime = DateTimeExpression("pd.StartDate");
            string productionEndDateTime = DateTimeExpression("pd.EndDate");

            string sql = @"
                SET NOCOUNT ON;

                SELECT *
                INTO #OrderBase
                FROM
                (
                    SELECT
                        od.OrderID,
                        od.ProjectID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.DealNo))), '') AS DealNo,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.LoanNo))), '') AS LoanNo,
                        COALESCE(" + receivedDate + @", " + orderDate + @") AS ReceivedDate,
                        " + dispatchDate + @" AS DispatchDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.FinalStatus))), ''), '') AS FinalStatus
                    FROM dbo.OrderData od WITH (NOLOCK)
                ) o
                WHERE (@Status = '' OR ISNULL(o.FinalStatus, '') = @Status)
                    AND
                    (
                        o.ReceivedDate BETWEEN @FromDate AND @ToDate
                        OR o.DispatchDate BETWEEN @FromDate AND @ToDate
                    );

                SELECT *
                INTO #ProductionBase
                FROM
                (
                    SELECT
                        pd.ProdID,
                        pd.ProjectID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.DealNo))), '') AS DealNo,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.LoanNo))), '') AS LoanNo,
                        " + productionOrderDate + @" AS OrderDate,
                        " + productionEndDate + @" AS ProductionDate,
                        " + productionStartDateTime + @" AS ProcessStartDate,
                        " + productionEndDateTime + @" AS ProcessEndDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.FinalStatus))), ''), '') AS FinalStatus,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.Code))), '') AS Code,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), pd.Employee))), '') AS Employee,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.Process))), '') AS Process,
                        pd.Target AS Target
                    FROM dbo.ProductionData pd WITH (NOLOCK)
                ) p
                WHERE p.ProductionDate BETWEEN @FromDate AND @ToDate
                    AND (@Status = '' OR ISNULL(p.FinalStatus, '') = @Status);

                CREATE NONCLUSTERED INDEX IX_MvrProjectOrderProject ON #OrderBase(ProjectID);
                CREATE NONCLUSTERED INDEX IX_MvrProjectOrderLoan ON #OrderBase(LoanNo);
                CREATE NONCLUSTERED INDEX IX_MvrProjectProductionProject ON #ProductionBase(ProjectID);
                CREATE NONCLUSTERED INDEX IX_MvrProjectProductionLoan ON #ProductionBase(LoanNo);

                ;WITH OrderProject AS
                (
                    SELECT
                        ISNULL(CONVERT(nvarchar(50), ProjectID), 'Blank') AS ProjectKey,
                        MIN(ProjectID) AS ProjectID,
                        SUM(CASE WHEN ReceivedDate BETWEEN @FromDate AND @ToDate THEN 1 ELSE 0 END) AS ReceivedVolume,
                        SUM(CASE WHEN DispatchDate BETWEEN @FromDate AND @ToDate THEN 1 ELSE 0 END) AS DeliveredVolume,
                        SUM(CASE WHEN ReceivedDate BETWEEN @FromDate AND @ToDate AND (DispatchDate IS NULL OR DispatchDate > @ToDate) THEN 1 ELSE 0 END) AS LoansInProcess,
                        COUNT(DISTINCT CASE WHEN ReceivedDate BETWEEN @FromDate AND @ToDate THEN NULLIF(LoanNo, '') END) AS UniqueReceivedLoans,
                        CAST(AVG(CASE WHEN ReceivedDate IS NOT NULL AND DispatchDate IS NOT NULL AND DispatchDate >= ReceivedDate
                            THEN CAST(DATEDIFF(day, ReceivedDate, DispatchDate) AS decimal(18, 2)) END) AS decimal(18, 2)) AS ActualTATDays
                    FROM #OrderBase
                    GROUP BY ISNULL(CONVERT(nvarchar(50), ProjectID), 'Blank')
                ),
                ProductionProject AS
                (
                    SELECT
                        ISNULL(CONVERT(nvarchar(50), ProjectID), 'Blank') AS ProjectKey,
                        MIN(ProjectID) AS ProjectID,
                        COUNT(NULLIF(LoanNo, '')) AS ProductionCount,
                        COUNT(DISTINCT NULLIF(LoanNo, '')) AS ProducedLoans,
                        COUNT(DISTINCT NULLIF(Code, '')) AS ActiveUsers,
                        CAST(AVG(CAST(ISNULL(Target, 0) AS decimal(18, 2))) AS decimal(18, 2)) AS AvgTarget,
                        CAST(AVG(CASE WHEN ProcessStartDate IS NOT NULL AND ProcessEndDate IS NOT NULL AND ProcessEndDate >= ProcessStartDate
                            THEN CAST(DATEDIFF(minute, ProcessStartDate, ProcessEndDate) AS decimal(18, 2)) END) / 60.0 AS decimal(18, 2)) AS AvgProcessTATHours
                    FROM #ProductionBase
                    GROUP BY ISNULL(CONVERT(nvarchar(50), ProjectID), 'Blank')
                ),
                WipUsers AS
                (
                    SELECT
                        ISNULL(CONVERT(nvarchar(50), o.ProjectID), 'Blank') AS ProjectKey,
                        COUNT(DISTINCT NULLIF(p.Code, '')) AS CurrentWorkingUsers
                    FROM #OrderBase o
                    LEFT JOIN #ProductionBase p ON p.LoanNo = o.LoanNo
                    WHERE o.ReceivedDate BETWEEN @FromDate AND @ToDate
                        AND (o.DispatchDate IS NULL OR o.DispatchDate > @ToDate)
                    GROUP BY ISNULL(CONVERT(nvarchar(50), o.ProjectID), 'Blank')
                )
                SELECT TOP (" + ProjectPerformanceRowLimit + @")
                    COALESCE(o.ProjectKey, p.ProjectKey, w.ProjectKey) AS ProjectID,
                    ISNULL(pr.ProjectName, CASE WHEN COALESCE(o.ProjectKey, p.ProjectKey, w.ProjectKey) = 'Blank' THEN 'Blank' ELSE 'Project ' + COALESCE(o.ProjectKey, p.ProjectKey, w.ProjectKey) END) AS ProjectName,
                    ISNULL(o.ReceivedVolume, 0) AS ReceivedVolume,
                    ISNULL(o.DeliveredVolume, 0) AS DeliveredVolume,
                    ISNULL(o.LoansInProcess, 0) AS LoansInProcess,
                    ISNULL(w.CurrentWorkingUsers, 0) AS CurrentWorkingUsers,
                    ISNULL(p.ProductionCount, 0) AS ProductionCount,
                    ISNULL(p.ProducedLoans, 0) AS ProducedLoans,
                    ISNULL(p.ActiveUsers, 0) AS ActiveUsers,
                    ISNULL(o.UniqueReceivedLoans, 0) AS UniqueReceivedLoans,
                    ISNULL(p.AvgTarget, 0) AS AvgTarget,
                    ISNULL(o.ActualTATDays, 0) AS ActualTATDays,
                    ISNULL(p.AvgProcessTATHours, 0) AS AvgProcessTATHours,
                    CAST(CASE WHEN ISNULL(o.ReceivedVolume, 0) > 0
                        THEN (CAST(ISNULL(o.DeliveredVolume, 0) AS decimal(18, 2)) / CAST(o.ReceivedVolume AS decimal(18, 2))) * 100
                        ELSE 0 END AS decimal(18, 2)) AS DeliveredPct
                FROM OrderProject o
                FULL OUTER JOIN ProductionProject p ON p.ProjectKey = o.ProjectKey
                FULL OUTER JOIN WipUsers w ON w.ProjectKey = COALESCE(o.ProjectKey, p.ProjectKey)
                LEFT JOIN dbo.Project pr WITH (NOLOCK) ON pr.ProjectID = COALESCE(o.ProjectID, p.ProjectID)
                ORDER BY ReceivedVolume DESC, ProductionCount DESC, ProjectName;

                DROP TABLE #ProductionBase;
                DROP TABLE #OrderBase;";

            return ExecuteReportQuery(sql, filters);
        }

        private static DataTable GetProjectDatewiseVolumeDetails(ReportFilters filters)
        {
            string orderDate = DateExpression("od.OrderDate");
            string receivedDate = DateExpression("od.ReceivedDateTime");
            string dispatchDate = DateExpression("od.DispatchDate");
            string productionEndDate = DateExpression("pd.EndDate");

            string sql = @"
                SET NOCOUNT ON;

                SELECT *
                INTO #OrderBase
                FROM
                (
                    SELECT
                        od.OrderID,
                        od.ProjectID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.DealNo))), '') AS DealNo,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.LoanNo))), '') AS LoanNo,
                        COALESCE(" + receivedDate + @", " + orderDate + @") AS ReceivedDate,
                        " + dispatchDate + @" AS DispatchDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.FinalStatus))), ''), '') AS FinalStatus
                    FROM dbo.OrderData od WITH (NOLOCK)
                ) o
                WHERE (@Status = '' OR ISNULL(o.FinalStatus, '') = @Status)
                    AND
                    (
                        o.ReceivedDate BETWEEN @FromDate AND @ToDate
                        OR o.DispatchDate BETWEEN @FromDate AND @ToDate
                    );

                SELECT *
                INTO #ProductionBase
                FROM
                (
                    SELECT
                        pd.ProdID,
                        pd.ProjectID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.LoanNo))), '') AS LoanNo,
                        " + productionEndDate + @" AS ProductionDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.FinalStatus))), ''), '') AS FinalStatus,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.Code))), '') AS Code
                    FROM dbo.ProductionData pd WITH (NOLOCK)
                ) p
                WHERE p.ProductionDate BETWEEN @FromDate AND @ToDate
                    AND (@Status = '' OR ISNULL(p.FinalStatus, '') = @Status);

                CREATE NONCLUSTERED INDEX IX_MvrProjectDateOrderProjectDate ON #OrderBase(ProjectID, ReceivedDate, DispatchDate);
                CREATE NONCLUSTERED INDEX IX_MvrProjectDateOrderLoan ON #OrderBase(ProjectID, LoanNo);
                CREATE NONCLUSTERED INDEX IX_MvrProjectDateProductionProjectDate ON #ProductionBase(ProjectID, ProductionDate);
                CREATE NONCLUSTERED INDEX IX_MvrProjectDateProductionLoan ON #ProductionBase(ProjectID, LoanNo);

                ;WITH ActivityProjects AS
                (
                    SELECT ProjectID, ReceivedDate AS ReportDate FROM #OrderBase WHERE ReceivedDate BETWEEN @FromDate AND @ToDate
                    UNION
                    SELECT ProjectID, DispatchDate AS ReportDate FROM #OrderBase WHERE DispatchDate BETWEEN @FromDate AND @ToDate
                    UNION
                    SELECT ProjectID, ProductionDate AS ReportDate FROM #ProductionBase WHERE ProductionDate BETWEEN @FromDate AND @ToDate
                ),
                ProjectDates AS
                (
                    SELECT DISTINCT ProjectID, ReportDate
                    FROM ActivityProjects
                    WHERE ReportDate IS NOT NULL
                ),
                Received AS
                (
                    SELECT
                        ProjectID,
                        ReceivedDate AS ReportDate,
                        COUNT(*) AS ReceivedVolume,
                        COUNT(DISTINCT NULLIF(LoanNo, '')) AS UniqueReceivedLoans
                    FROM #OrderBase
                    WHERE ReceivedDate BETWEEN @FromDate AND @ToDate
                    GROUP BY ProjectID, ReceivedDate
                ),
                Production AS
                (
                    SELECT
                        ProjectID,
                        ProductionDate AS ReportDate,
                        COUNT(NULLIF(LoanNo, '')) AS ProductionCount,
                        COUNT(DISTINCT NULLIF(LoanNo, '')) AS ProducedLoans,
                        COUNT(DISTINCT NULLIF(Code, '')) AS ActiveUsers
                    FROM #ProductionBase
                    WHERE ProductionDate BETWEEN @FromDate AND @ToDate
                    GROUP BY ProjectID, ProductionDate
                ),
                Dispatched AS
                (
                    SELECT
                        ProjectID,
                        DispatchDate AS ReportDate,
                        COUNT(*) AS DispatchedVolume
                    FROM #OrderBase
                    WHERE DispatchDate BETWEEN @FromDate AND @ToDate
                    GROUP BY ProjectID, DispatchDate
                )
                SELECT TOP (" + ProjectDatewiseRowLimit + @")
                    ISNULL(pr.ProjectName, CASE WHEN pd.ProjectID IS NULL THEN 'Blank' ELSE 'Project ' + CONVERT(nvarchar(50), pd.ProjectID) END) AS ProjectName,
                    pd.ReportDate,
                    ISNULL(r.ReceivedVolume, 0) AS ReceivedVolume,
                    ISNULL(p.ProductionCount, 0) AS ProductionCount,
                    ISNULL(d.DispatchedVolume, 0) AS DispatchedVolume,
                    ISNULL(wip.LoansInProcess, 0) AS LoansInProcess,
                    ISNULL(r.UniqueReceivedLoans, 0) AS UniqueReceivedLoans,
                    ISNULL(p.ProducedLoans, 0) AS ProducedLoans,
                    ISNULL(p.ActiveUsers, 0) AS ActiveUsers,
                    CAST(CASE WHEN ISNULL(r.ReceivedVolume, 0) > 0
                        THEN (CAST(ISNULL(d.DispatchedVolume, 0) AS decimal(18, 2)) / CAST(r.ReceivedVolume AS decimal(18, 2))) * 100
                        ELSE 0 END AS decimal(18, 2)) AS DispatchPct
                FROM ProjectDates pd
                LEFT JOIN Received r ON ((r.ProjectID = pd.ProjectID) OR (r.ProjectID IS NULL AND pd.ProjectID IS NULL)) AND r.ReportDate = pd.ReportDate
                LEFT JOIN Production p ON ((p.ProjectID = pd.ProjectID) OR (p.ProjectID IS NULL AND pd.ProjectID IS NULL)) AND p.ReportDate = pd.ReportDate
                LEFT JOIN Dispatched d ON ((d.ProjectID = pd.ProjectID) OR (d.ProjectID IS NULL AND pd.ProjectID IS NULL)) AND d.ReportDate = pd.ReportDate
                OUTER APPLY
                (
                    SELECT COUNT(*) AS LoansInProcess
                    FROM #OrderBase o
                    WHERE ((o.ProjectID = pd.ProjectID) OR (o.ProjectID IS NULL AND pd.ProjectID IS NULL))
                        AND o.ReceivedDate BETWEEN @FromDate AND pd.ReportDate
                        AND (o.DispatchDate IS NULL OR o.DispatchDate > pd.ReportDate)
                ) wip
                LEFT JOIN dbo.Project pr WITH (NOLOCK) ON pr.ProjectID = pd.ProjectID
                ORDER BY ProjectName, pd.ReportDate;

                DROP TABLE #ProductionBase;
                DROP TABLE #OrderBase;";

            return ExecuteReportQuery(sql, filters);
        }

        private static DataTable GetUserQualityReport(ReportFilters filters)
        {
            string feedbackDate = DateExpression("F.AddedDate");
            string productionEndDate = DateExpression("pd.EndDate");
            string sql = @"
                SET NOCOUNT ON;

                SELECT *
                INTO #ProductionBase
                FROM
                (
                    SELECT
                        pd.ProjectID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.DealNo))), '') AS DealNo,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.LoanNo))), '') AS LoanNo,
                        " + productionEndDate + @" AS ProductionDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.FinalStatus))), ''), '') AS FinalStatus,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.Code))), '') AS Code,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), pd.Employee))), '') AS Employee,
                        pd.Target AS Target
                    FROM dbo.ProductionData pd WITH (NOLOCK)
                ) p
                WHERE p.ProductionDate BETWEEN @FromDate AND @ToDate
                    AND (@Status = '' OR ISNULL(p.FinalStatus, '') = @Status);

                CREATE NONCLUSTERED INDEX IX_MvrQualityProductionUser ON #ProductionBase(Code, ProjectID);
                CREATE NONCLUSTERED INDEX IX_MvrQualityProductionLoan ON #ProductionBase(LoanNo, DealNo);
                CREATE NONCLUSTERED INDEX IX_MvrQualityProductionEmployee ON #ProductionBase(Employee);

                SELECT
                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), F.DealNo))), '') AS DealNo,
                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), F.OrderNo))), '') AS OrderNo,
                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), F.ErrorDoneBY))), '') AS ErrorDoneBy,
                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), FD.Fatal))), '') AS Severity
                INTO #FeedbackRows
                FROM dbo.InfinityWBT_Feedback F WITH (NOLOCK)
                INNER JOIN dbo.InfinityFeedback_Details FD WITH (NOLOCK) ON FD.Feedback = F.Feedback
                WHERE " + feedbackDate + @" BETWEEN @FromDate AND @ToDate;

                CREATE NONCLUSTERED INDEX IX_MvrQualityFeedbackOrder ON #FeedbackRows(ErrorDoneBy, OrderNo);
                CREATE NONCLUSTERED INDEX IX_MvrQualityFeedbackDeal ON #FeedbackRows(ErrorDoneBy, DealNo);
                CREATE NONCLUSTERED INDEX IX_MvrQualityFeedbackByOrder ON #FeedbackRows(OrderNo, ErrorDoneBy);
                CREATE NONCLUSTERED INDEX IX_MvrQualityFeedbackByDeal ON #FeedbackRows(DealNo, ErrorDoneBy);

                SELECT DISTINCT ProjectID, Code, Employee, LoanNo, DealNo
                INTO #ProductionLoans
                FROM #ProductionBase
                WHERE Code IS NOT NULL;

                CREATE NONCLUSTERED INDEX IX_MvrQualityProductionLoanEmployee ON #ProductionLoans(Employee, LoanNo);
                CREATE NONCLUSTERED INDEX IX_MvrQualityProductionLoanCode ON #ProductionLoans(Code, LoanNo);
                CREATE NONCLUSTERED INDEX IX_MvrQualityProductionDealEmployee ON #ProductionLoans(Employee, DealNo);
                CREATE NONCLUSTERED INDEX IX_MvrQualityProductionDealCode ON #ProductionLoans(Code, DealNo);

                ;WITH ProductionStage AS
                (
                    SELECT
                        ProjectID,
                        Code,
                        Employee,
                        ProductionDate,
                        ISNULL(Target, 0) AS Target,
                        COUNT(NULLIF(LoanNo, '')) AS LoanCount,
                        CAST(CASE WHEN ISNULL(Target, 0) > 0
                            THEN (CAST(COUNT(NULLIF(LoanNo, '')) AS decimal(18, 2)) / CAST(ISNULL(Target, 0) AS decimal(18, 2))) * 100
                            ELSE 0 END AS decimal(18, 2)) AS ProdPerc
                    FROM #ProductionBase
                    GROUP BY ProjectID, Code, Employee, ProductionDate, ISNULL(Target, 0)
                ),
                UserDaily AS
                (
                    SELECT
                        ProjectID,
                        Code,
                        Employee,
                        ProductionDate,
                        SUM(LoanCount) AS LoanCount,
                        CAST(AVG(CAST(Target AS decimal(18, 2))) AS decimal(18, 2)) AS AvgTarget,
                        SUM(ProdPerc) AS ProdPerc
                    FROM ProductionStage
                    GROUP BY ProjectID, Code, Employee, ProductionDate
                ),
                UserProject AS
                (
                    SELECT
                        ProjectID,
                        Code,
                        Employee,
                        SUM(LoanCount) AS LoanCount,
                        COUNT(DISTINCT ProductionDate) AS WorkedDays,
                        CAST(AVG(AvgTarget) AS decimal(18, 2)) AS AvgTarget,
                        CAST(AVG(ProdPerc) AS decimal(18, 2)) AS ProductionPct
                    FROM UserDaily
                    GROUP BY ProjectID, Code, Employee
                ),
                Errors AS
                (
                    SELECT
                        p.ProjectID,
                        p.Code,
                        SUM(case WHEN f.Severity = 'Critical' THEN 1 ELSE 0 END) AS CriticalErrors,
                        SUM(CASE WHEN f.Severity = 'Non-Critical' THEN 1 ELSE 0 END) AS NonCriticalErrors,
                        SUM(case WHEN f.Severity = 'Critical' THEN 1
                            WHEN f.Severity = 'Non-Critical' THEN 1 ELSE 0 END) AS TotalErrors
                    FROM #ProductionLoans p
                    LEFT JOIN dbo.EmployeeInfo E WITH (NOLOCK) ON E.Code = p.Code
                    LEFT JOIN #FeedbackRows f ON (f.ErrorDoneBy = p.Employee OR f.ErrorDoneBy = p.Code)
                        AND (f.OrderNo = p.LoanNo OR f.DealNo = p.DealNo)
                    GROUP BY p.ProjectID, p.Code
                ),
                AttendanceMonths AS
                (
                    SELECT DISTINCT
                        Code,
                        DATENAME(month, CASE WHEN DATEPART(day, ProductionDate) > 25 THEN DATEADD(month, 1, ProductionDate) ELSE ProductionDate END) AS SalaryMonth,
                        DATEPART(year, CASE WHEN DATEPART(day, ProductionDate) > 25 THEN DATEADD(month, 1, ProductionDate) ELSE ProductionDate END) AS SalaryYear
                    FROM #ProductionBase
                    WHERE Code IS NOT NULL
                ),
                Attendance AS
                (
                    SELECT
                        am.Code,
                        CAST(AVG(CASE WHEN ISNULL(I.NetDays, 0) > 0
                            THEN (CAST(ISNULL(I.TotalDaysWithExtra, 0) AS decimal(18, 2)) / CAST(I.NetDays AS decimal(18, 2))) * 100
                            ELSE NULL END) AS decimal(18, 2)) AS AttendancePct
                    FROM AttendanceMonths am
                    LEFT JOIN dbo.EmployeeInfo E WITH (NOLOCK) ON E.Code = am.Code
                    LEFT JOIN dbo.InfinitySalary I WITH (NOLOCK) ON I.EmployeeID = E.EmployeeID
                        AND I.Month = am.SalaryMonth
                        AND CONVERT(nvarchar(20), I.Year) = CONVERT(nvarchar(20), am.SalaryYear)
                    GROUP BY am.Code
                )
                SELECT TOP (" + UserQualityRowLimit + @")
                    ISNULL(CONVERT(nvarchar(50), up.ProjectID), 'Blank') AS ProjectID,
                    ISNULL(pr.ProjectName, CASE WHEN up.ProjectID IS NULL THEN 'Blank' ELSE 'Project ' + CONVERT(nvarchar(50), up.ProjectID) END) AS ProjectName,
                    ISNULL(up.Code, '') AS Code,
                    ISNULL(up.Employee, '') AS Employee,
                    ISNULL(E.SubDomain, '') AS SubDomain,
                    up.LoanCount,
                    up.WorkedDays,
                    up.AvgTarget,
                    up.ProductionPct,
                    ISNULL(er.CriticalErrors, 0) AS CriticalErrors,
                    ISNULL(er.NonCriticalErrors, 0) AS NonCriticalErrors,
                    ISNULL(er.TotalErrors, 0) AS TotalErrors,
                    CAST(CASE WHEN up.LoanCount > 0
                        THEN
                            (
                                (CAST(up.LoanCount AS decimal(18, 2)) * CASE WHEN E.SubDomain IN ('Credit', 'Servicing') THEN 1300 ELSE 1 END)
                                - CAST(ISNULL(er.TotalErrors, 0) AS decimal(18, 2))
                            )
                            / NULLIF(CAST(up.LoanCount AS decimal(18, 2)) * CASE WHEN E.SubDomain IN ('Credit', 'Servicing') THEN 1300 ELSE 1 END, 0) * 100
                        ELSE 0 END AS decimal(18, 2)) AS QualityPct,
                    ISNULL(att.AttendancePct, 0) AS AttendancePct,
                    CASE WHEN G.ProdFromA IS NULL THEN ''
                        WHEN up.ProductionPct >= CAST(G.ProdFromA AS decimal(18, 2)) THEN 'A'
                        WHEN up.ProductionPct >= CAST(G.ProdBFrom AS decimal(18, 2)) THEN 'B'
                        WHEN up.ProductionPct >= CAST(G.ProdCFrom AS decimal(18, 2)) THEN 'C'
                        ELSE 'D' END AS ProductionGrade,
                    CASE WHEN G.QuaAFrom IS NULL THEN ''
                        WHEN (CASE WHEN up.LoanCount > 0 THEN
                            (
                                (CAST(up.LoanCount AS decimal(18, 2)) * CASE WHEN E.SubDomain IN ('Credit', 'Servicing') THEN 1300 ELSE 1 END)
                                - CAST(ISNULL(er.TotalErrors, 0) AS decimal(18, 2))
                            )
                            / NULLIF(CAST(up.LoanCount AS decimal(18, 2)) * CASE WHEN E.SubDomain IN ('Credit', 'Servicing') THEN 1300 ELSE 1 END, 0) * 100
                        ELSE 0 END) >= CAST(G.QuaAFrom AS decimal(18, 2)) THEN 'A'
                        WHEN (CASE WHEN up.LoanCount > 0 THEN
                            (
                                (CAST(up.LoanCount AS decimal(18, 2)) * CASE WHEN E.SubDomain IN ('Credit', 'Servicing') THEN 1300 ELSE 1 END)
                                - CAST(ISNULL(er.TotalErrors, 0) AS decimal(18, 2))
                            )
                            / NULLIF(CAST(up.LoanCount AS decimal(18, 2)) * CASE WHEN E.SubDomain IN ('Credit', 'Servicing') THEN 1300 ELSE 1 END, 0) * 100
                        ELSE 0 END) >= CAST(G.QuaBFrom AS decimal(18, 2)) THEN 'B'
                        WHEN (CASE WHEN up.LoanCount > 0 THEN
                            (
                                (CAST(up.LoanCount AS decimal(18, 2)) * CASE WHEN E.SubDomain IN ('Credit', 'Servicing') THEN 1300 ELSE 1 END)
                                - CAST(ISNULL(er.TotalErrors, 0) AS decimal(18, 2))
                            )
                            / NULLIF(CAST(up.LoanCount AS decimal(18, 2)) * CASE WHEN E.SubDomain IN ('Credit', 'Servicing') THEN 1300 ELSE 1 END, 0) * 100
                        ELSE 0 END) >= CAST(G.QuaCFrom AS decimal(18, 2)) THEN 'C'
                        ELSE 'D' END AS QualityGrade,
                    CASE WHEN G.AttnAFrom IS NULL THEN ''
                        WHEN ISNULL(att.AttendancePct, 0) >= CAST(G.AttnAFrom AS decimal(18, 2)) THEN 'A'
                        WHEN ISNULL(att.AttendancePct, 0) >= CAST(G.AttnBFrom AS decimal(18, 2)) THEN 'B'
                        WHEN ISNULL(att.AttendancePct, 0) >= CAST(G.AttnCFrom AS decimal(18, 2)) THEN 'C'
                        ELSE 'D' END AS AttendanceGrade
                FROM UserProject up
                LEFT JOIN dbo.Project pr WITH (NOLOCK) ON pr.ProjectID = up.ProjectID
                LEFT JOIN dbo.EmployeeInfo E WITH (NOLOCK) ON E.Code = up.Code
                LEFT JOIN Errors er ON er.ProjectID = up.ProjectID AND er.Code = up.Code
                LEFT JOIN Attendance att ON att.Code = up.Code
                OUTER APPLY (SELECT TOP 1 * FROM dbo.GradingMaster_Underwriting WITH (NOLOCK) WHERE Branch = 2) G
                ORDER BY up.LoanCount DESC, up.Employee, ProjectName;

                DROP TABLE #FeedbackRows;
                DROP TABLE #ProductionLoans;
                DROP TABLE #ProductionBase;";

            return ExecuteReportQuery(sql, filters);
        }

        private static DataSet GetCostPerLoanData(ReportFilters filters)
        {
            string productionEndDate = DateExpression("pd.EndDate");
            string logDate = DateExpression("ul.[Date]");

            string sql = @"
                SET NOCOUNT ON;

                SELECT
                    pd.ProdID,
                    pd.ProjectID,
                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.LoanNo))), '') AS LoanNo,
                    " + productionEndDate + @" AS ProductionDate,
                    ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.FinalStatus))), ''), '') AS FinalStatus,
                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.Code))), '') AS Code,
                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), pd.Employee))), '') AS Employee,
                    ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.Process))), ''), 'Blank') AS Process,
                    ISNULL(pd.Target, 0) AS Target
                INTO #ProductionBase
                FROM dbo.ProductionData pd WITH (NOLOCK)
                WHERE " + productionEndDate + @" BETWEEN @FromDate AND @ToDate
                    AND (@Status = '' OR ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.FinalStatus))), ''), '') = @Status);

                CREATE NONCLUSTERED INDEX IX_MvrCostProductionCode ON #ProductionBase(Code);
                CREATE NONCLUSTERED INDEX IX_MvrCostProductionProcess ON #ProductionBase(Process);

                SELECT
                    NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), ul.User_Code))), '') AS Code,
                    " + logDate + @" AS LogDate,
                    CASE WHEN SUM(CASE WHEN CHARINDEX(':', ISNULL(CONVERT(nvarchar(50), ul.Total_hrs), '')) > 0
                        AND ISNUMERIC(PARSENAME(REPLACE(CONVERT(nvarchar(50), ul.Total_hrs), ':', '.'), 2)) = 1
                        AND ISNUMERIC(PARSENAME(REPLACE(CONVERT(nvarchar(50), ul.Total_hrs), ':', '.'), 1)) = 1
                        THEN
                            (CAST(PARSENAME(REPLACE(CONVERT(nvarchar(50), ul.Total_hrs), ':', '.'), 2) AS int) * 60)
                            + CAST(PARSENAME(REPLACE(CONVERT(nvarchar(50), ul.Total_hrs), ':', '.'), 1) AS int)
                        ELSE 0 END) > 555 THEN 555
                        ELSE SUM(CASE WHEN CHARINDEX(':', ISNULL(CONVERT(nvarchar(50), ul.Total_hrs), '')) > 0
                            AND ISNUMERIC(PARSENAME(REPLACE(CONVERT(nvarchar(50), ul.Total_hrs), ':', '.'), 2)) = 1
                            AND ISNUMERIC(PARSENAME(REPLACE(CONVERT(nvarchar(50), ul.Total_hrs), ':', '.'), 1)) = 1
                            THEN
                                (CAST(PARSENAME(REPLACE(CONVERT(nvarchar(50), ul.Total_hrs), ':', '.'), 2) AS int) * 60)
                                + CAST(PARSENAME(REPLACE(CONVERT(nvarchar(50), ul.Total_hrs), ':', '.'), 1) AS int)
                            ELSE 0 END)
                        END AS TotalMinutes
                INTO #LogDays
                FROM dbo.vw_UserLOgs ul WITH (NOLOCK)
                WHERE " + logDate + @" BETWEEN @FromDate AND @ToDate
                    AND ISNULL(ul.Remark, '') NOT IN ('Absent', 'Holiday')
                GROUP BY NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), ul.User_Code))), ''), " + logDate + @";

                SELECT
                    Code,
                    COUNT(LogDate) AS ProductiveDays,
                    SUM(TotalMinutes) AS TotalMinutes
                INTO #Logs
                FROM #LogDays
                GROUP BY Code;

                CREATE NONCLUSTERED INDEX IX_MvrCostLogsCode ON #Logs(Code);

                SELECT
                    Code,
                    Employee,
                    ProjectID,
                    Process,
                    ProductionDate,
                    Target,
                    COUNT(NULLIF(LoanNo, '')) AS LoanCount,
                    CAST(CASE WHEN Target > 0
                        THEN (CAST(COUNT(NULLIF(LoanNo, '')) AS decimal(18, 2)) / CAST(Target AS decimal(18, 2))) * 100
                        ELSE 0 END AS decimal(18, 2)) AS ProductionPct
                INTO #S1
                FROM #ProductionBase
                WHERE Code IS NOT NULL
                GROUP BY Code, Employee, ProjectID, Process, ProductionDate, Target;

                CREATE NONCLUSTERED INDEX IX_MvrCostS1Code ON #S1(Code);

                SELECT
                    s.Code,
                    s.Employee,
                    s.ProjectID,
                    s.Process,
                    SUM(s.LoanCount) AS LoanCount,
                    CAST(AVG(CAST(s.Target AS decimal(18, 2))) AS decimal(18, 2)) AS AvgTarget,
                    CAST(AVG(s.ProductionPct) AS decimal(18, 2)) AS ProductionPctByTarget,
                    CASE WHEN ISNULL(MAX(l.ProductiveDays), 0) > 0 THEN MAX(l.ProductiveDays) ELSE COUNT(DISTINCT s.ProductionDate) END AS ProductiveDays,
                    ISNULL(MAX(l.TotalMinutes), 0) AS TotalMinutes
                INTO #S2
                FROM #S1 s
                LEFT JOIN #Logs l ON l.Code = s.Code
                GROUP BY s.Code, s.Employee, s.ProjectID, s.Process;

                DELETE FROM #S2 WHERE ISNULL(AvgTarget, 0) <= 0 OR ISNULL(LoanCount, 0) <= 0;

                SELECT
                    *,
                    CAST(AvgTarget * ProductiveDays AS decimal(18, 2)) AS MonthlyTarget,
                    CAST(CASE WHEN AvgTarget * ProductiveDays > 0
                        THEN CAST(TotalMinutes AS decimal(18, 4)) / CAST(AvgTarget * ProductiveDays AS decimal(18, 4))
                        ELSE 0 END AS decimal(18, 4)) AS TargetMinutesPerLoan
                INTO #S3
                FROM #S2;

                SELECT
                    *,
                    CAST(TargetMinutesPerLoan * LoanCount AS decimal(18, 4)) AS TimeTakenMinutes
                INTO #S4
                FROM #S3;

                SELECT
                    *,
                    CAST(SUM(TimeTakenMinutes) OVER (PARTITION BY Code) AS decimal(18, 4)) AS TotalTimeTakenMinutes
                INTO #S5
                FROM #S4;

                SELECT
                    *,
                    CAST(CASE WHEN TotalTimeTakenMinutes > 0 THEN TimeTakenMinutes / TotalTimeTakenMinutes ELSE 0 END AS decimal(18, 4)) AS Weightage,
                    CAST(CASE WHEN TotalTimeTakenMinutes > 0 THEN (TimeTakenMinutes / TotalTimeTakenMinutes) * TotalMinutes ELSE 0 END AS decimal(18, 2)) AS AdjustedTimeMinutes
                INTO #S6
                FROM #S5;

                SELECT
                    ISNULL(CONVERT(nvarchar(50), s.ProjectID), 'Blank') AS ProjectID,
                    ISNULL(pr.ProjectName, CASE WHEN s.ProjectID IS NULL THEN 'Blank' ELSE 'Project ' + CONVERT(nvarchar(50), s.ProjectID) END) AS ProjectName,
                    s.Code,
                    ISNULL(s.Employee, '') AS Employee,
                    s.Process,
                    s.LoanCount,
                    s.ProductiveDays,
                    s.TotalMinutes,
                    CAST(s.TotalMinutes / 60.0 AS decimal(18, 2)) AS TotalHours,
                    s.AvgTarget,
                    s.MonthlyTarget,
                    s.TargetMinutesPerLoan,
                    s.TimeTakenMinutes,
                    CAST(s.Weightage * 100 AS decimal(18, 2)) AS WeightagePct,
                    s.AdjustedTimeMinutes,
                    CAST(CASE WHEN s.TotalMinutes > 0 THEN (s.AdjustedTimeMinutes / CAST(s.TotalMinutes AS decimal(18, 2))) * 100 ELSE 0 END AS decimal(18, 2)) AS ProductionPctByTimeSpent,
                    s.ProductionPctByTarget,
                    CAST(COALESCE(I.ProfileSalary, E.Salary, 0) AS decimal(18, 2)) AS Salary,
                    CAST(CASE WHEN s.LoanCount > 0
                        THEN ((CAST(COALESCE(I.ProfileSalary, E.Salary, 0) AS decimal(18, 2)) / CAST(s.LoanCount AS decimal(18, 2))) * s.ProductionPctByTarget) / 100
                        ELSE 0 END AS decimal(18, 2)) AS CostPerLoanByTarget,
                    CAST(CASE WHEN s.LoanCount > 0
                        THEN ((CAST(COALESCE(I.ProfileSalary, E.Salary, 0) AS decimal(18, 2)) / CAST(s.LoanCount AS decimal(18, 2))) *
                            CAST(CASE WHEN s.TotalMinutes > 0 THEN (s.AdjustedTimeMinutes / CAST(s.TotalMinutes AS decimal(18, 2))) * 100 ELSE 0 END AS decimal(18, 2))) / 100
                        ELSE 0 END AS decimal(18, 2)) AS CostPerLoanByTimeSpent
                INTO #CostRows
                FROM #S6 s
                LEFT JOIN dbo.Project pr WITH (NOLOCK) ON pr.ProjectID = s.ProjectID
                LEFT JOIN dbo.EmployeeInfo E WITH (NOLOCK) ON E.Code = s.Code
                LEFT JOIN dbo.InfinitySalary I WITH (NOLOCK) ON I.EmployeeID = E.EmployeeID
                    AND I.Month = DATENAME(month, @ToDate)
                    AND CONVERT(nvarchar(20), I.Year) = CONVERT(nvarchar(20), DATEPART(year, @ToDate));

                SELECT
                    Code,
                    Employee,
                    SUM(LoanCount) AS LoanCount,
                    COUNT(DISTINCT Process) AS ProcessCount,
                    MAX(ProductiveDays) AS WorkedDays,
                    MAX(TotalHours) AS TotalHours,
                    CAST(AVG(ProductionPctByTarget) AS decimal(18, 2)) AS AvgProductionPctByTarget,
                    CAST(AVG(ProductionPctByTimeSpent) AS decimal(18, 2)) AS AvgProductionPctByTimeSpent,
                    MAX(Salary) AS Salary,
                    CAST(CASE WHEN SUM(LoanCount) > 0 THEN SUM(CostPerLoanByTarget * LoanCount) / SUM(LoanCount) ELSE 0 END AS decimal(18, 2)) AS CostPerLoanByTarget,
                    CAST(CASE WHEN SUM(LoanCount) > 0 THEN SUM(CostPerLoanByTimeSpent * LoanCount) / SUM(LoanCount) ELSE 0 END AS decimal(18, 2)) AS CostPerLoanByTimeSpent
                FROM #CostRows
                GROUP BY Code, Employee
                ORDER BY CostPerLoanByTimeSpent DESC, LoanCount DESC;

                SELECT
                    Process,
                    SUM(LoanCount) AS LoanCount,
                    COUNT(DISTINCT Code) AS UserCount,
                    CAST(AVG(AvgTarget) AS decimal(18, 2)) AS AvgTarget,
                    CAST(AVG(ProductionPctByTarget) AS decimal(18, 2)) AS AvgProductionPctByTarget,
                    CAST(AVG(ProductionPctByTimeSpent) AS decimal(18, 2)) AS AvgProductionPctByTimeSpent,
                    CAST(SUM(AdjustedTimeMinutes) / 60.0 AS decimal(18, 2)) AS AdjustedHours,
                    CAST(CASE WHEN SUM(LoanCount) > 0 THEN SUM(CostPerLoanByTarget * LoanCount) / SUM(LoanCount) ELSE 0 END AS decimal(18, 2)) AS CostPerLoanByTarget,
                    CAST(CASE WHEN SUM(LoanCount) > 0 THEN SUM(CostPerLoanByTimeSpent * LoanCount) / SUM(LoanCount) ELSE 0 END AS decimal(18, 2)) AS CostPerLoanByTimeSpent
                FROM #CostRows
                GROUP BY Process
                ORDER BY LoanCount DESC, Process;

                SELECT TOP (" + CostDetailRowLimit + @") *
                FROM #CostRows
                ORDER BY Code, Process, ProjectName;

                DROP TABLE #CostRows;
                DROP TABLE #S6;
                DROP TABLE #S5;
                DROP TABLE #S4;
                DROP TABLE #S3;
                DROP TABLE #S2;
                DROP TABLE #S1;
                DROP TABLE #Logs;
                DROP TABLE #LogDays;
                DROP TABLE #ProductionBase;";

            return ExecuteReportDataSet(sql, filters);
        }

        private static DataTable GetLoanDetails(ReportFilters filters)
        {
            string orderDate = DateExpression("od.OrderDate");
            string receivedDate = DateExpression("od.ReceivedDateTime");
            string dispatchDate = DateExpression("od.DispatchDate");
            string productionEndDate = DateExpression("pd.EndDate");

            string sql = @"
                SET NOCOUNT ON;

                SELECT *
                INTO #OrderBase
                FROM
                (
                    SELECT
                        od.OrderID,
                        od.ProjectID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.DealNo))), '') AS DealNo,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.LoanNo))), '') AS LoanNo,
                        COALESCE(" + receivedDate + @", " + orderDate + @") AS ReceivedDate,
                        " + dispatchDate + @" AS DispatchDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), od.FinalStatus))), ''), '') AS FinalStatus
                    FROM dbo.OrderData od WITH (NOLOCK)
                ) o
                WHERE (@Status = '' OR ISNULL(o.FinalStatus, '') = @Status)
                    AND
                    (
                        o.ReceivedDate BETWEEN @FromDate AND @ToDate
                        OR o.DispatchDate BETWEEN @FromDate AND @ToDate
                    );

                SELECT *
                INTO #ProductionBase
                FROM
                (
                    SELECT
                        pd.ProdID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.LoanNo))), '') AS LoanNo,
                        " + productionEndDate + @" AS ProductionDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.FinalStatus))), ''), '') AS FinalStatus,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(200), pd.Employee))), '') AS Employee,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(100), pd.Process))), '') AS Process
                    FROM dbo.ProductionData pd WITH (NOLOCK)
                ) p
                WHERE p.ProductionDate BETWEEN @FromDate AND @ToDate
                    AND (@Status = '' OR ISNULL(p.FinalStatus, '') = @Status);

                CREATE NONCLUSTERED INDEX IX_MvrLoanOrderReceived ON #OrderBase(ReceivedDate);
                CREATE NONCLUSTERED INDEX IX_MvrLoanOrderDispatch ON #OrderBase(DispatchDate);
                CREATE NONCLUSTERED INDEX IX_MvrLoanOrderLoan ON #OrderBase(LoanNo);
                CREATE NONCLUSTERED INDEX IX_MvrLoanProductionLoan ON #ProductionBase(LoanNo, ProductionDate, ProdID);

                ;WITH ProductionRollup AS
                (
                    SELECT
                        LoanNo,
                        COUNT(NULLIF(LoanNo, '')) AS ProductionCount,
                        MAX(ProductionDate) AS LastProductionDate
                    FROM #ProductionBase
                    GROUP BY LoanNo
                ),
                LastProduction AS
                (
                    SELECT LoanNo, Process, Employee
                    FROM
                    (
                        SELECT
                            LoanNo,
                            Process,
                            Employee,
                            ROW_NUMBER() OVER (PARTITION BY LoanNo ORDER BY ProductionDate DESC, ProdID DESC) AS RowNo
                        FROM #ProductionBase
                        WHERE LoanNo IS NOT NULL
                    ) x
                    WHERE RowNo = 1
                )
                SELECT TOP (" + LoanDetailsRowLimit + @")
                    o.ProjectID,
                    o.DealNo,
                    o.LoanNo,
                    o.ReceivedDate,
                    o.DispatchDate,
                    o.FinalStatus,
                    CASE WHEN o.DispatchDate IS NULL OR o.DispatchDate > @ToDate THEN 'In Process' ELSE 'Dispatched' END AS FlowStatus,
                    DATEDIFF(day, o.ReceivedDate, ISNULL(o.DispatchDate, @ToDate)) AS AgeDays,
                    ISNULL(pr.ProductionCount, 0) AS ProductionCount,
                    pr.LastProductionDate,
                    lp.Process AS LastProcess,
                    lp.Employee AS LastEmployee
                FROM #OrderBase o
                LEFT JOIN ProductionRollup pr ON pr.LoanNo = o.LoanNo
                LEFT JOIN LastProduction lp ON lp.LoanNo = o.LoanNo
                ORDER BY o.ReceivedDate DESC, o.OrderID DESC;

                DROP TABLE #ProductionBase;
                DROP TABLE #OrderBase;";

            return ExecuteReportQuery(sql, filters);
        }

        private static DataTable GetCustomReport(ReportFilters filters, CustomGroup group)
        {
            string sql = BuildBaseCte() + @"
                , ReportRows AS
                (
                    SELECT
                        o.ReceivedDate AS ActivityDate,
                        o.FinalStatus,
                        o.ProjectID,
                        o.DealNo,
                        o.LoanNo,
                        CAST(NULL AS nvarchar(500)) AS Code,
                        CAST(NULL AS nvarchar(500)) AS Employee,
                        CAST(NULL AS nvarchar(500)) AS Process,
                        1 AS ReceivedVolume,
                        0 AS ProductionCount,
                        CASE WHEN o.DispatchDate BETWEEN @FromDate AND @ToDate THEN 1 ELSE 0 END AS DispatchedVolume,
                        CASE WHEN o.ReceivedDate BETWEEN @FromDate AND @ToDate AND (o.DispatchDate IS NULL OR o.DispatchDate > @ToDate) THEN 1 ELSE 0 END AS LoansInProcess
                    FROM OrderBase o
                    WHERE o.ReceivedDate BETWEEN @FromDate AND @ToDate
                        OR o.DispatchDate BETWEEN @FromDate AND @ToDate
                        OR (o.ReceivedDate BETWEEN @FromDate AND @ToDate AND (o.DispatchDate IS NULL OR o.DispatchDate > @ToDate))
                    UNION ALL
                    SELECT
                        p.ProductionDate AS ActivityDate,
                        p.FinalStatus,
                        p.ProjectID,
                        p.DealNo,
                        p.LoanNo,
                        p.Code,
                        p.Employee,
                        p.Process,
                        0 AS ReceivedVolume,
                        1 AS ProductionCount,
                        0 AS DispatchedVolume,
                        0 AS LoansInProcess
                    FROM ProductionBase p
                )
                SELECT
                    " + group.Expression + @" AS [" + group.ColumnName + @"],
                    SUM(ReceivedVolume) AS ReceivedVolume,
                    SUM(ProductionCount) AS ProductionCount,
                    SUM(DispatchedVolume) AS DispatchedVolume,
                    SUM(LoansInProcess) AS LoansInProcess,
                    COUNT(DISTINCT NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), LoanNo))), '')) AS UniqueLoans,
                    COUNT(DISTINCT NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), Code))), '')) AS ActiveUsers
                FROM ReportRows
                GROUP BY " + group.Expression + @"
                ORDER BY MIN(ActivityDate), " + group.Expression;

            return ExecuteReportQuery(sql, filters);
        }

        private static string BuildBaseCte()
        {
            string orderDate = DateExpression("od.OrderDate");
            string receivedDate = DateExpression("od.ReceivedDateTime");
            string dispatchDate = DateExpression("od.DispatchDate");
            string productionOrderDate = DateExpression("pd.OrderDate");
            string productionEndDate = DateExpression("pd.EndDate");
            string productionDispatchDate = DateExpression("pd.DispatchDate");
            string productionStartDateTime = DateTimeExpression("pd.StartDate");
            string productionEndDateTime = DateTimeExpression("pd.EndDate");

            return @"
                ;WITH OrderRaw AS
                (
                    SELECT
                        od.OrderID,
                        od.ProjectID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), od.DealNo))), '') AS DealNo,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), od.LoanNo))), '') AS LoanNo,
                        COALESCE(" + receivedDate + @", " + orderDate + @") AS ReceivedDate,
                        " + dispatchDate + @" AS DispatchDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), od.FinalStatus))), ''), '') AS FinalStatus
                    FROM dbo.OrderData od WITH (NOLOCK)
                ),
                OrderBase AS
                (
                    SELECT *
                    FROM OrderRaw
                    WHERE (@Status = '' OR ISNULL(FinalStatus, '') = @Status)
                        AND
                        (
                            ReceivedDate BETWEEN @FromDate AND @ToDate
                            OR DispatchDate BETWEEN @FromDate AND @ToDate
                        )
                ),
                ProductionRaw AS
                (
                    SELECT
                        pd.ProdID,
                        pd.ProjectID,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), pd.DealNo))), '') AS DealNo,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), pd.LoanNo))), '') AS LoanNo,
                        " + productionOrderDate + @" AS OrderDate,
                        " + productionEndDate + @" AS ProductionDate,
                        " + productionStartDateTime + @" AS ProcessStartDate,
                        " + productionEndDateTime + @" AS ProcessEndDate,
                        " + productionDispatchDate + @" AS DispatchDate,
                        ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), pd.FinalStatus))), ''), '') AS FinalStatus,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), pd.Code))), '') AS Code,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), pd.Employee))), '') AS Employee,
                        NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(500), pd.Process))), '') AS Process,
                        pd.Target AS Target
                    FROM dbo.ProductionData pd WITH (NOLOCK)
                ),
                ProductionBase AS
                (
                    SELECT *
                    FROM ProductionRaw p
                    WHERE p.ProductionDate BETWEEN @FromDate AND @ToDate
                        AND (@Status = '' OR ISNULL(p.FinalStatus, '') = @Status)
                ),
                E1(N) AS
                (
                    SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
                    UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
                ),
                E2(N) AS (SELECT 1 FROM E1 a CROSS JOIN E1 b),
                E4(N) AS (SELECT 1 FROM E2 a CROSS JOIN E2 b),
                Nums(N) AS
                (
                    SELECT TOP (DATEDIFF(day, @FromDate, @ToDate) + 1)
                        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1
                    FROM E4
                ),
                Dates AS
                (
                    SELECT DATEADD(day, N, @FromDate) AS CalendarDate
                    FROM Nums
                )";
        }

        private static string DateExpression(string columnName)
        {
            string clean = "NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(4000), " + columnName + "))), '')";
            return "CONVERT(date, CASE WHEN ISDATE(" + clean + ") = 1 THEN " + clean + " ELSE NULL END)";
        }

        private static string DateTimeExpression(string columnName)
        {
            string clean = "NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(4000), " + columnName + "))), '')";
            return "CONVERT(datetime, CASE WHEN ISDATE(" + clean + ") = 1 THEN " + clean + " ELSE NULL END)";
        }

        private static DataTable ExecuteReportQuery(string sql, ReportFilters filters)
        {
            return ExecuteQuery(sql, delegate (SqlParameterCollection parameters)
            {
                parameters.Add("@FromDate", SqlDbType.Date).Value = filters.FromDate;
                parameters.Add("@ToDate", SqlDbType.Date).Value = filters.ToDate;
                parameters.Add("@Status", SqlDbType.NVarChar, 500).Value = filters.Status;
            });
        }

        private static DataSet ExecuteReportDataSet(string sql, ReportFilters filters)
        {
            return ExecuteDataSet(sql, delegate (SqlParameterCollection parameters)
            {
                parameters.Add("@FromDate", SqlDbType.Date).Value = filters.FromDate;
                parameters.Add("@ToDate", SqlDbType.Date).Value = filters.ToDate;
                parameters.Add("@Status", SqlDbType.NVarChar, 500).Value = filters.Status;
            });
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

        private static DataSet ExecuteDataSet(string sql, Action<SqlParameterCollection> addParameters)
        {
            for (int attempt = 0; attempt <= DeadlockRetryCount; attempt++)
            {
                try
                {
                    DataSet data = new DataSet();
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
                        adapter.Fill(data);
                    }

                    return data;
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

            return new DataSet();
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

        private static DataTable GetTable(DataSet data, int index)
        {
            return data != null && data.Tables.Count > index ? data.Tables[index] : new DataTable();
        }

        private static ReportRange NormalizeRange(string fromDate, string toDate)
        {
            DateTime from = ParseDate(fromDate, new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1));
            DateTime to = ParseDate(toDate, DateTime.Today);

            if (from > to)
            {
                DateTime swap = from;
                from = to;
                to = swap;
            }

            return new ReportRange(from, to);
        }

        private static DateTime ParseDate(string value, DateTime fallback)
        {
            DateTime parsed;
            if (DateTime.TryParse(value, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed))
            {
                return parsed.Date;
            }

            return fallback.Date;
        }

        private static string NormalizeFilter(string value)
        {
            return Convert.ToString(value ?? "").Trim();
        }

        private static List<object> BuildSummaryCards(DataTable summary)
        {
            DataRow row = summary != null && summary.Rows.Count > 0 ? summary.Rows[0] : null;
            decimal received = row == null ? 0 : ToDecimal(row["ReceivedVolume"]);
            decimal production = row == null ? 0 : ToDecimal(row["ProductionCount"]);
            decimal dispatched = row == null ? 0 : ToDecimal(row["DispatchedVolume"]);
            decimal inProcess = row == null ? 0 : ToDecimal(row["LoansInProcess"]);
            decimal dispatchPct = received > 0 ? (dispatched / received) * 100 : 0;
            decimal productionCoverage = received > 0 ? (production / received) * 100 : 0;

            return new List<object>
            {
                new { Label = "Received Volume", Value = FormatNumber(received), Color = "gray" },
                new { Label = "Daily Production", Value = FormatNumber(production), Color = "green" },
                new { Label = "Dispatched", Value = FormatNumber(dispatched), Color = "orange" },
                new { Label = "Loans In Process", Value = FormatNumber(inProcess), Color = "red" },
                new { Label = "Unique Received Loans", Value = FormatNumber(row == null ? 0 : ToDecimal(row["UniqueReceivedLoans"])), Color = "teal" },
                new { Label = "Active Users", Value = FormatNumber(row == null ? 0 : ToDecimal(row["ActiveUsers"])), Color = "gray" },
                new { Label = "Dispatch %", Value = FormatNumber(dispatchPct) + "%", Color = "orange" },
                new { Label = "Production Coverage %", Value = FormatNumber(productionCoverage) + "%", Color = "green" }
            };
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null)
            {
                return rows;
            }

            foreach (DataRow dr in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in table.Columns)
                {
                    row[col.ColumnName] = FormatValue(dr[col]);
                }
                rows.Add(row);
            }

            return rows;
        }

        private static object FormatValue(object value)
        {
            if (value == null || value == DBNull.Value)
            {
                return "";
            }

            if (value is DateTime)
            {
                return ((DateTime)value).ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
            }

            if (value is decimal || value is double || value is float)
            {
                return FormatNumber(ToDecimal(value));
            }

            return value;
        }

        private static decimal ToDecimal(object value)
        {
            if (value == null || value == DBNull.Value)
            {
                return 0;
            }

            decimal number;
            string text = Convert.ToString(value).Replace(",", "").Replace("%", "").Trim();
            return decimal.TryParse(text, NumberStyles.Any, CultureInfo.InvariantCulture, out number) ? number : 0;
        }

        private static string FormatNumber(decimal value)
        {
            return value == Math.Truncate(value)
                ? value.ToString("0", CultureInfo.InvariantCulture)
                : value.ToString("0.##", CultureInfo.InvariantCulture);
        }

        private static CustomGroup GetCustomGroup(string groupBy)
        {
            switch (NormalizeFilter(groupBy).ToLowerInvariant())
            {
                case "finalstatus":
                    return new CustomGroup("FinalStatus", "Final Status Analysis", "ISNULL(NULLIF(FinalStatus, ''), 'Blank')");
                case "projectid":
                    return new CustomGroup("ProjectID", "Project Analysis", "ISNULL(CONVERT(nvarchar(50), ProjectID), 'Blank')");
                case "dealno":
                    return new CustomGroup("DealNo", "Deal Analysis", "ISNULL(NULLIF(DealNo, ''), 'Blank')");
                case "user":
                    return new CustomGroup("User", "User Analysis", "ISNULL(NULLIF(Code, ''), 'Blank') + CASE WHEN NULLIF(Employee, '') IS NULL THEN '' ELSE ' - ' + Employee END");
                case "process":
                    return new CustomGroup("Process", "Process Analysis", "ISNULL(NULLIF(Process, ''), 'Blank')");
                default:
                    return new CustomGroup("ReportDate", "Report Date Analysis", "ActivityDate");
            }
        }

        private static bool HasManagementAccess()
        {
            string configuredUsers = Convert.ToString(ConfigurationManager.AppSettings["ManagementVolumeReportUsers"]);
            if (string.IsNullOrWhiteSpace(configuredUsers) || configuredUsers.Equals("All", StringComparison.OrdinalIgnoreCase))
            {
                return true;
            }

            int employeeId = GetCurrentEmployeeId();
            return configuredUsers
                .Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(x => x.Trim())
                .Any(x => x == employeeId.ToString(CultureInfo.InvariantCulture));
        }

        private static int GetCurrentEmployeeId()
        {
            int employeeId;
            return int.TryParse(HttpContext.Current.User.Identity.Name, out employeeId) ? employeeId : 0;
        }

        private static string Serialize(object value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(value);
        }

        private class ReportRange
        {
            public ReportRange(DateTime fromDate, DateTime toDate)
            {
                FromDate = fromDate;
                ToDate = toDate;
            }

            public DateTime FromDate { get; private set; }
            public DateTime ToDate { get; private set; }
        }

        private class ReportFilters
        {
            public ReportFilters(DateTime fromDate, DateTime toDate, string status)
            {
                FromDate = fromDate;
                ToDate = toDate;
                Status = NormalizeFilter(status);
            }

            public DateTime FromDate { get; private set; }
            public DateTime ToDate { get; private set; }
            public string Status { get; private set; }
        }

        private class CustomGroup
        {
            public CustomGroup(string columnName, string title, string expression)
            {
                ColumnName = columnName;
                Title = title;
                Expression = expression;
            }

            public string ColumnName { get; private set; }
            public string Title { get; private set; }
            public string Expression { get; private set; }
        }
    }
}
