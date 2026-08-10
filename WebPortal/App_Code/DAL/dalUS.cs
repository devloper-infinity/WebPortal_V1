using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using WebPortal.App_Code.Class;

namespace WebPortal.App_Code.DAL
{
    public class dalUS
    {
        #region Get Data

        public DataTable GetUSEmployees()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSEmployees");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllUSAssets()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllUSAssets");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetLoanDetails_RemoteUW_REQC(int EmpID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLoanDetails_RemoteUW_REQC_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmpID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUSLoanProductionMyQueue(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.Text, @"
SELECT
    ProductionTrackID,
    ISNULL(ProcessID, 0) AS ProcessID,
    ISNULL(ProjectNumber, '') AS Client,
    DealNo,
    LoanNo,
    ISNULL(OrderDate, '') AS OrderDate,
    ISNULL([Process], '') AS Process,
    ISNULL(Review, '') AS Review,
    ISNULL(SourcePage, CASE WHEN ISNULL(ProcessID, 0) = 0 THEN 'GlobalSearch' ELSE 'MyTask' END) AS SourcePage,
    CONVERT(VARCHAR(19), StartDatetime, 120) AS StartDatetime,
    CASE
        WHEN StartDatetime IS NULL THEN 0
        WHEN DATEDIFF(MINUTE, StartDatetime, GETDATE()) < 0 THEN 0
        ELSE DATEDIFF(MINUTE, StartDatetime, GETDATE())
    END AS ElapsedMinutes,
    ISNULL([Status], 'Started') AS Status
FROM dbo.USLoanProductionTrack
WHERE EmployeeID = @EmployeeID
    AND EndDatetime IS NULL
ORDER BY StartDatetime DESC, ProductionTrackID DESC;");

            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLoanDetails_RemoteUW_ByID(int ProcessID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLoanDetails_RemoteUW_ByID_ForNewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProcessID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDatewiseOnShoreProduction(string Date)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDatewiseOnShoreProduction");
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Date);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDatewiseOnShoreProduction_Monthly(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDatewiseOnShoreProduction_Monthly");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetDatewiseOnShoreProduction_Monthly_Report(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDatewiseOnShoreProduction_Monthly_Report");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDatewiseOnShoreProduction_Monthly_Report_Userwise(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDatewiseOnShoreProduction_Monthly_Report_Userwise");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet getLoansForGlobalSearch(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OnShoreGetallLoans_GlobalSearch");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataSet getLoansForGlobalSearch_Canopy(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OnShoreGetallLoans_GlobalSearch_Canopy");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataTable GetCanopySearchProcessStatuses()
        {
            DataTable result = new DataTable();
            result.Columns.Add("ProjectNumber", typeof(string));
            result.Columns.Add("DealNo", typeof(string));
            result.Columns.Add("LoanNo", typeof(string));
            result.Columns.Add("ProcessName", typeof(string));
            result.Columns.Add("Script", typeof(string));
            result.Columns.Add("ProcessStatus", typeof(string));
            result.Columns.Add("ProcessEmployeeID", typeof(int));
            result.Columns.Add("ProcessEmployeeName", typeof(string));
            result.Columns.Add("ProcessStatusDate", typeof(string));

            SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
;WITH ProcessRanked AS
(
    SELECT
        ISNULL(track.ProjectNumber, '') AS ProjectNumber,
        ISNULL(track.DealNo, '') AS DealNo,
        ISNULL(track.LoanNo, '') AS LoanNo,
        ISNULL(track.[Process], '') AS ProcessName,
        ISNULL(track.Script, '') AS Script,
        CASE
            WHEN track.EndDatetime IS NOT NULL OR UPPER(ISNULL(track.[Status], '')) = 'COMPLETED' THEN 'Completed'
            ELSE 'Started'
        END AS ProcessStatus,
        ISNULL(track.EmployeeID, 0) AS ProcessEmployeeID,
        LTRIM(RTRIM(ISNULL(employee.FirstName, '') + ' ' + ISNULL(employee.LastName, ''))) AS ProcessEmployeeName,
        ISNULL(track.EndDatetime, ISNULL(track.StartDatetime, track.AddedDate)) AS ProcessStatusDate,
        ROW_NUMBER() OVER
        (
            PARTITION BY track.ProjectNumber, track.DealNo, track.LoanNo, track.[Process], track.Script
            ORDER BY
                CASE WHEN track.EndDatetime IS NOT NULL OR UPPER(ISNULL(track.[Status], '')) = 'COMPLETED' THEN 0 ELSE 1 END,
                ISNULL(track.EndDatetime, ISNULL(track.StartDatetime, track.AddedDate)) DESC,
                track.ProductionTrackID DESC
        ) AS RowNumber
    FROM dbo.USLoanProductionTrack track
    LEFT JOIN dbo.EmployeeInfo employee
        ON employee.EmployeeID = track.EmployeeID
    WHERE track.SourcePage = 'CanopySearch'
)
SELECT
    ProjectNumber,
    DealNo,
    LoanNo,
    ProcessName,
    Script,
    ProcessStatus,
    ProcessEmployeeID,
    ProcessEmployeeName,
    CONVERT(varchar(19), ProcessStatusDate, 120) AS ProcessStatusDate
FROM ProcessRanked
WHERE RowNumber = 1
OPTION (RECOMPILE);");

            DataTable current = SQLHelper.ExecuteDataTableCmd(cmd);
            foreach (DataRow row in current.Rows)
            {
                result.ImportRow(row);
            }

            return result;
        }

        public bool CanStartCanopyLoan(string DealNo, string LoanNo, string Script, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
SELECT TOP (1)
    CASE
        WHEN (track.EndDatetime IS NOT NULL OR UPPER(ISNULL(track.[Status], '')) = 'COMPLETED')
             AND ISNULL(track.EmployeeID, 0) <> @EmployeeID THEN 0
        ELSE 1
    END AS CanStart
FROM dbo.USLoanProductionTrack track
WHERE track.SourcePage = 'CanopySearch'
  AND ISNULL(track.DealNo, '') = ISNULL(@DealNo, '')
  AND ISNULL(track.LoanNo, '') = ISNULL(@LoanNo, '')
  AND ISNULL(track.Script, '') = ISNULL(@Script, '')
ORDER BY
    CASE WHEN track.EndDatetime IS NOT NULL OR UPPER(ISNULL(track.[Status], '')) = 'COMPLETED' THEN 0 ELSE 1 END,
    ISNULL(track.EndDatetime, ISNULL(track.StartDatetime, track.AddedDate)) DESC,
    track.ProductionTrackID DESC;");

            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", SqlDbType.NVarChar, 200, ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", SqlDbType.NVarChar, 200, ParameterDirection.Input, LoanNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Script", SqlDbType.NVarChar, 500, ParameterDirection.Input, Script);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 0, ParameterDirection.Input, EmployeeID);

            object value = SQLHelper.ExecuteScalarCmd(cmd);
            return value == null || value == DBNull.Value || Convert.ToInt32(value) == 1;
        }

        public DataTable GetGlobalSearchReQcStatuses(IEnumerable<string> loanNumbers)
        {
            DataTable result = new DataTable();
            result.Columns.Add("ProjectNumber", typeof(string)); result.Columns.Add("DealNo", typeof(string)); result.Columns.Add("LoanNo", typeof(string));
            result.Columns.Add("ReQCStatus", typeof(string)); result.Columns.Add("ReQCProcess", typeof(string)); result.Columns.Add("ReQCEmployeeName", typeof(string)); result.Columns.Add("ReQCDate", typeof(string));
            List<string> loans = (loanNumbers ?? Enumerable.Empty<string>()).Where(x => !string.IsNullOrWhiteSpace(x)).Select(x => x.Trim()).Distinct(StringComparer.OrdinalIgnoreCase).ToList();
            const int batchSize = 1000;
            for (int offset = 0; offset < loans.Count; offset += batchSize)
            {
                List<string> batch = loans.Skip(offset).Take(batchSize).ToList();
                SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
;WITH RequestedLoans (LoanNo) AS
(
    SELECT LoanNo
    FROM (VALUES " + string.Join(",", batch.Select((loan, index) => "(@Loan" + index + ")")) + @") requested (LoanNo)
),
ReQcSource AS
(
    SELECT
        ISNULL(track.ProjectNumber, '') AS ProjectNumber,
        ISNULL(track.DealNo, '') AS DealNo,
        ISNULL(track.LoanNo, '') AS LoanNo,
        CASE WHEN track.EndDatetime IS NULL THEN 'Assigned' ELSE 'Completed' END AS ReQCStatus,
        ISNULL(track.[Process], '') AS ReQCProcess,
        LTRIM(RTRIM(ISNULL(employee.FirstName, '') + ' ' + ISNULL(employee.LastName, ''))) AS ReQCEmployeeName,
        ISNULL(track.EndDatetime, ISNULL(track.StartDatetime, track.AddedDate)) AS ReQCDate,
        track.ProductionTrackID AS RecordID,
        0 AS SourcePriority
    FROM RequestedLoans requested
    INNER JOIN dbo.USLoanProductionTrack track
        ON track.LoanNo = requested.LoanNo
    LEFT JOIN dbo.EmployeeInfo employee
        ON employee.EmployeeID = track.EmployeeID
    WHERE UPPER(REPLACE(REPLACE(ISNULL(track.[Process], ''), '-', ''), ' ', ''))
          IN ('DATAFIELDSREQC', 'PHREQC', 'REQC')

    UNION ALL

    SELECT
        ISNULL(project.ProjectName, '') AS ProjectNumber,
        ISNULL(queue.DealNo, '') AS DealNo,
        ISNULL(queue.OrderNumber, '') AS LoanNo,
        'Assigned' AS ReQCStatus,
        ISNULL(queue.[Process], '') AS ReQCProcess,
        LTRIM(RTRIM(ISNULL(employee.FirstName, '') + ' ' + ISNULL(employee.LastName, ''))) AS ReQCEmployeeName,
        queue.AddedDate AS ReQCDate,
        queue.ProcessID AS RecordID,
        1 AS SourcePriority
    FROM RequestedLoans requested
    INNER JOIN Underwriting.dbo.WBT_TrackingsheetOrderProcessQueue queue
        ON queue.OrderNumber = requested.LoanNo
    LEFT JOIN dbo.Project project
        ON project.ProjectId = queue.ProjectId
    OUTER APPLY
    (
        SELECT TOP (1) configuration.EmployeeID
        FROM dbo.EmployeeConfiguration configuration
        WHERE configuration.Psuedoname = queue.UserCode
          AND (configuration.isDelete = 0 OR configuration.isDelete IS NULL)
        ORDER BY configuration.EmpConfigrationID DESC
    ) currentConfiguration
    LEFT JOIN dbo.EmployeeInfo employee
        ON employee.EmployeeID = currentConfiguration.EmployeeID
    WHERE UPPER(REPLACE(REPLACE(ISNULL(queue.[Process], ''), '-', ''), ' ', ''))
          IN ('DATAFIELDSREQC', 'PHREQC', 'REQC')
),
ReQcRanked AS
(
    SELECT
        ProjectNumber,
        DealNo,
        LoanNo,
        ReQCStatus,
        ReQCProcess,
        ReQCEmployeeName,
        ReQCDate,
        ROW_NUMBER() OVER
        (
            PARTITION BY ProjectNumber, DealNo, LoanNo
            ORDER BY
                CASE WHEN ReQCStatus = 'Assigned' THEN 0 ELSE 1 END,
                ReQCDate DESC,
                SourcePriority,
                RecordID DESC
        ) AS RowNumber
    FROM ReQcSource
)
SELECT
    ProjectNumber,
    DealNo,
    LoanNo,
    ReQCStatus,
    ReQCProcess,
    ReQCEmployeeName,
    CONVERT(varchar(19), ReQCDate, 120) AS ReQCDate
FROM ReQcRanked
WHERE RowNumber = 1
OPTION (RECOMPILE);");
                for (int i = 0; i < batch.Count; i++) cmd.Parameters.Add("@Loan" + i, SqlDbType.NVarChar, 200).Value = batch[i];
                DataTable current = SQLHelper.ExecuteDataTableCmd(cmd); foreach (DataRow row in current.Rows) result.ImportRow(row);
            }
            return result;
        }
public DataTable GetGlobalSearchReQcStatuses_OLD(IEnumerable<string> loanNumbers)
        {
            DataTable result = new DataTable();
            result.Columns.Add("ProjectNumber", typeof(string)); result.Columns.Add("DealNo", typeof(string)); result.Columns.Add("LoanNo", typeof(string));
            result.Columns.Add("ReQCStatus", typeof(string)); result.Columns.Add("ReQCProcess", typeof(string)); result.Columns.Add("ReQCEmployeeName", typeof(string)); result.Columns.Add("ReQCDate", typeof(string));
            List<string> loans = (loanNumbers ?? Enumerable.Empty<string>()).Where(x => !string.IsNullOrWhiteSpace(x)).Select(x => x.Trim()).Distinct(StringComparer.OrdinalIgnoreCase).ToList();
            const int batchSize = 1000;
            for (int offset = 0; offset < loans.Count; offset += batchSize)
            {
                List<string> batch = loans.Skip(offset).Take(batchSize).ToList(); StringBuilder parameters = new StringBuilder();
                for (int i = 0; i < batch.Count; i++) { if (i > 0) parameters.Append(','); parameters.Append("@Loan").Append(i); }
                SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
;WITH ReQcSource AS
(
    -- Records from USLoanProductionTrack
    SELECT
        ISNULL(track.ProjectNumber, '') AS ProjectNumber,
        ISNULL(track.DealNo, '') AS DealNo,
        ISNULL(track.LoanNo, '') AS LoanNo,
        CASE
            WHEN track.EndDatetime IS NULL THEN 'Assigned'
            ELSE 'Completed'
        END AS ReQCStatus,
        ISNULL(track.[Process], '') AS ReQCProcess,
        LTRIM(RTRIM(
            ISNULL(employee.FirstName, '') + ' ' +
            ISNULL(employee.LastName, '')
        )) AS ReQCEmployeeName,
        ISNULL(
            track.EndDatetime,
            ISNULL(track.StartDatetime, track.AddedDate)
        ) AS ReQCDate,
        track.ProductionTrackID AS RecordID,
        'USLoanProductionTrack' AS RecordSource
    FROM dbo.USLoanProductionTrack track
    LEFT JOIN dbo.EmployeeInfo employee
        ON employee.EmployeeID = track.EmployeeID
    WHERE UPPER(
              REPLACE(
                  REPLACE(ISNULL(track.[Process], ''), '-', ''),
                  ' ',
                  ''
              )
          ) IN ('DATAFIELDSREQC', 'PHREQC', 'REQC')
      AND track.LoanNo IN ('9750146988')

    UNION ALL

    -- Records from WBT_TrackingsheetOrderProcessQueue
    SELECT
        ISNULL(P.ProjectName, '') AS ProjectNumber, -- update if different
        ISNULL(queue.DealNo, '') AS DealNo,               -- update if different
        ISNULL(queue.OrderNumber, '') AS LoanNo,               -- update if different
        'Assigned' AS ReQCStatus,
        ISNULL(queue.[Process], '') AS ReQCProcess,        -- update if different
        LTRIM(RTRIM(
            ISNULL(employee.FirstName, '') + ' ' +
            ISNULL(employee.LastName, '')
        )) AS ReQCEmployeeName,
        queue.AddedDate AS ReQCDate,
        queue.ProcessID AS RecordID,                         -- update with primary key
        'WBT_TrackingsheetOrderProcessQueue' AS RecordSource
    FROM Underwriting.dbo.WBT_TrackingsheetOrderProcessQueue queue
    left join Project P on P.ProjectId=queue.ProjectId
    --select * from Underwriting.dbo.WBT_TrackingsheetOrderProcessQueue

    left join EmployeeConfiguration EC on EC.Psuedoname=queue.UserCode and EC.EmpConfigrationID=(
    select top 1 EC1.EmpConfigrationID from EmployeeConfiguration EC1 where EC1.Code=EC.Code and (EC1.isDelete=0 or EC1.isDelete is NULL))
    LEFT JOIN dbo.EmployeeInfo employee
        ON employee.EmployeeID = EC.EmployeeID          -- update if different
    WHERE UPPER(
              REPLACE(
                  REPLACE(ISNULL(queue.[Process], ''), '-', ''),
                  ' ',
                  ''
              )
          ) IN ('DATAFIELDSREQC', 'PHREQC', 'REQC')
      AND queue.OrderNumber IN ('9750146988')
),
ReQcRanked AS
(
    SELECT
        ProjectNumber,
        DealNo,
        LoanNo,
        ReQCStatus,
        ReQCProcess,
        ReQCEmployeeName,
        ReQCDate,
        RecordSource,
        ROW_NUMBER() OVER
        (
            PARTITION BY ProjectNumber, DealNo, LoanNo
            ORDER BY
                CASE
                    WHEN ReQCStatus = 'Assigned' THEN 0
                    ELSE 1
                END,
                ReQCDate DESC,
                RecordID DESC
        ) AS RowNumber
    FROM ReQcSource
)
SELECT
    ProjectNumber,
    DealNo,
    LoanNo,
    ReQCStatus,
    ReQCProcess,
    ReQCEmployeeName,
    CONVERT(varchar(19), ReQCDate, 120) AS ReQCDate,
    RecordSource
FROM ReQcRanked
WHERE RowNumber = 1;");
                for (int i = 0; i < batch.Count; i++) cmd.Parameters.Add("@Loan" + i, SqlDbType.NVarChar, 200).Value = batch[i];
                DataTable current = SQLHelper.ExecuteDataTableCmd(cmd); foreach (DataRow row in current.Rows) result.ImportRow(row);
            }
            return result;
        }
        public DataTable GetOverAllUserPerformance_credit_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformance_credit_Greg");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOverAllUserPerformance_Servicing_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformance_servicing_Greg");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOverAllUserPerformanceDetails_Credit_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformanceDetails_Credit_Greg");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetUSImportedFeedback_ByUser_NewERP(string LoanNo, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSImportedFeedback_ByUser_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, LoanNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOverAllUserPerformanceDetails_Servicing_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformanceDetails_Servicing_Greg");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLoanDetailsbyLoanNo(string DealNo, string LoanNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSLoanDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, LoanNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetLoanDetailsbyLoanNo_Canopy(string DealNo, string LoanNo, string Script)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSLoanDetails_Canopy");
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, LoanNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Script);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetATRDetailsbyLoanNo(string DealNo, string LoanNo, string Type, int ProcessID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSATRFeedbacks");
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, LoanNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ProcessID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCanopyATRDetailsbyLoanNo(string DealNo, string LoanNo, string Type, int ProcessID, string Script)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
IF @Type = 'ATR'
BEGIN
    SELECT Reviewer, ReviewDate AS [Review Date], LoanNo AS [Loan #], DealNo AS [Client Deal #],
           CASE WHEN isATRSupported = 1 THEN 'Yes' ELSE 'No' END AS [ATR Supported?],
           ReviewFindings AS [Review Findings], SellerDisclosedDTIIssue AS [Seller Disclosed DTI Issue],
           NoOfBorrowers AS [# of Borrowers], HighestBorrowerIncomeType AS [Highest BWR Income Type],
           NoOfSEBusiness AS [# of SE businesses], NoOfRentalProperties AS [# Rental Properties], Comments
    FROM dbo.OnShoreFeedbacks_ATRReview
    WHERE DealNo = @DealNo AND LoanNo = @LoanNo AND ProcessID = @ProcessID
      AND ISNULL(Script, '') = ISNULL(@Script, '');
END
ELSE
BEGIN
    SELECT DealNo AS [Deal #], LoanNo AS [Loan #], Severity, Finding
    FROM dbo.OnShoreFeedbacks
    WHERE DealNo = @DealNo AND LoanNo = @LoanNo AND ProcessID = @ProcessID
      AND ISNULL(Script, '') = ISNULL(@Script, '');
END");
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", SqlDbType.NVarChar, 100, ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", SqlDbType.NVarChar, 100, ParameterDirection.Input, LoanNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", SqlDbType.NVarChar, 100, ParameterDirection.Input, Type);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", SqlDbType.Int, 0, ParameterDirection.Input, ProcessID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Script", SqlDbType.NVarChar, 500, ParameterDirection.Input, Script);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetUSProcessList(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSProcessList");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllTempReQC1(int ReQC)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TempReQC_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@ReQC", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ReQC);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetAllTempReQC2(int ReQC)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TempReQC_2");
            SQLHelper.AddParamToSQLCmd(cmd, "@ReQC", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ReQC);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }


        #endregion

        #region Insert/Update Data

        public int InsertUSImportedFeedback_NewERP(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUSImportedFeedback_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Client", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Client"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UWName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["UWName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@QCName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["QCName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DateReviewed", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["DateReviewed"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@QCDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["QCDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackReceivedDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["FeedbackReceivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Finding", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Finding"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Severity", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Severity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Source", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Source"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int UpdateUSImportedFeedback_NewERP(Hashtable htParam)
        {
            string query = @"
                SET NOCOUNT ON;
                IF @Client = '561'
                    UPDATE ImportedFeedbacks_Servicing
                    SET Finding = @Finding, Severity = @Severity
                    WHERE FeedbackID = @FeedbackID AND [Loan Number] = @LoanNo
                      AND Client = @Client AND AddedBy = @AddedBy;
                ELSE
                    UPDATE ImportedFeedbacks
                    SET Finding = @Finding, Severity = @Severity
                    WHERE FeedbackID = @FeedbackID AND [Loan Number] = @LoanNo
                      AND Client = @Client AND AddedBy = @AddedBy;
                SET @RowsAffected = @@ROWCOUNT;";

            SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, query);
            AddFeedbackMutationParameters(cmd, htParam, true);
            SQLHelper.AddParamToSQLCmd(cmd, "@RowsAffected", SqlDbType.Int, 0, ParameterDirection.Output, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int rowsAffected = Convert.ToInt32(cmd.Parameters["@RowsAffected"].Value);
            cmd.Dispose();
            return rowsAffected;
        }

        public int DeleteUSImportedFeedback_NewERP(Hashtable htParam)
        {
            string query = @"
                SET NOCOUNT ON;
                IF @Client = '561'
                    DELETE FROM ImportedFeedbacks_Servicing
                    WHERE FeedbackID = @FeedbackID AND [Loan Number] = @LoanNo
                      AND Client = @Client AND AddedBy = @AddedBy;
                ELSE
                    DELETE FROM ImportedFeedbacks
                    WHERE FeedbackID = @FeedbackID AND [Loan Number] = @LoanNo
                      AND Client = @Client AND AddedBy = @AddedBy;
                SET @RowsAffected = @@ROWCOUNT;";

            SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, query);
            AddFeedbackMutationParameters(cmd, htParam, false);
            SQLHelper.AddParamToSQLCmd(cmd, "@RowsAffected", SqlDbType.Int, 0, ParameterDirection.Output, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int rowsAffected = Convert.ToInt32(cmd.Parameters["@RowsAffected"].Value);
            cmd.Dispose();
            return rowsAffected;
        }

        private static void AddFeedbackMutationParameters(SqlCommand cmd, Hashtable htParam, bool includeValues)
        {
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", SqlDbType.Int, 0, ParameterDirection.Input, htParam["FeedbackID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", SqlDbType.NVarChar, 5000, ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Client", SqlDbType.NVarChar, 5000, ParameterDirection.Input, htParam["Client"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["AddedBy"]);
            if (includeValues)
            {
                SQLHelper.AddParamToSQLCmd(cmd, "@Finding", SqlDbType.NVarChar, 5000, ParameterDirection.Input, htParam["Finding"]);
                SQLHelper.AddParamToSQLCmd(cmd, "@Severity", SqlDbType.NVarChar, 5000, ParameterDirection.Input, htParam["Severity"]);
            }
        }


        // ********* for underwriting database
        public int InsertModifyUWOrderOC22Servicing(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_CompleteAllocateOrderToVendorInTrackingSheet_DISP_Allocation_Servicing_RW_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["OrderNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Review", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Review"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewStartTime", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ReviewStartTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewEndTime", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ReviewEndTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProductType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBY", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["AddedBY"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd_Underwriting(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertModifyUWOrderOC22Servicing_EndTime(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_CompleteAllocateOrderToVendorInTrackingSheet_DISP_Allocation_Servicing_RW_NewERP_EndTime");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["OrderNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Review", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Review"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewStartTime", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ReviewStartTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewEndTime", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ReviewEndTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProductType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBY", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["AddedBY"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd_Underwriting(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int SaveUSLoanProductionTrack(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.Text, @"
DECLARE @StartValue DATETIME;

IF ISDATE(@StartDatetime) = 1
BEGIN
    SET @StartValue = CONVERT(DATETIME, @StartDatetime);
END
ELSE
BEGIN
    SET @StartValue = NULL;
END

DECLARE @EndValue DATETIME;

IF ISDATE(@EndDatetime) = 1
BEGIN
    SET @EndValue = CONVERT(DATETIME, @EndDatetime);
END
ELSE
BEGIN
    SET @EndValue = NULL;
END

DECLARE @TrackID BIGINT;

IF UPPER(@Action) = 'START'
BEGIN
    SELECT TOP 1 @TrackID = ProductionTrackID
    FROM dbo.USLoanProductionTrack
    WHERE EmployeeID = @EmployeeID
        AND EndDatetime IS NULL
        AND DealNo = @DealNo
        AND LoanNo = @LoanNo
        AND ISNULL(Script, '') = ISNULL(@Script, '')
        AND (
            (@ProcessID > 0 AND (ProcessID = @ProcessID OR ISNULL(ProcessID, 0) = 0))
            OR (@ProcessID <= 0 AND ISNULL(ProcessID, 0) = 0 AND ISNULL([Process], '') = ISNULL(@Process, ''))
        )
    ORDER BY
        CASE WHEN @ProcessID > 0 AND ProcessID = @ProcessID THEN 0 ELSE 1 END,
        ProductionTrackID DESC;

    IF @TrackID IS NULL
    BEGIN
        INSERT INTO dbo.USLoanProductionTrack
        (
            ProcessID, ProjectNumber, DealNo, LoanNo, OrderDate, [Process], Script, Review, SourcePage,
            StartDatetime, EndDatetime, EmployeeID, AddedBy, AddedDate, [Status]
        )
        VALUES
        (
            @ProcessID, @ProjectNumber, @DealNo, @LoanNo, @OrderDate, @Process, @Script, @Review, @SourcePage,
            @StartValue, NULL, @EmployeeID, @AddedBy, GETDATE(), 'Started'
        );
    END
    ELSE
    BEGIN
        UPDATE dbo.USLoanProductionTrack
        SET ProcessID = CASE WHEN @ProcessID > 0 THEN @ProcessID ELSE ProcessID END,
            ProjectNumber = @ProjectNumber,
            DealNo = @DealNo,
            LoanNo = @LoanNo,
            OrderDate = @OrderDate,
            [Process] = @Process,
            Script = @Script,
            Review = @Review,
            SourcePage = COALESCE(NULLIF(@SourcePage, ''), SourcePage),
            StartDatetime = COALESCE(StartDatetime, @StartValue),
            [Status] = 'Started',
            ModifiedBy = @AddedBy,
            ModifiedDate = GETDATE()
        WHERE ProductionTrackID = @TrackID;
    END
END
ELSE
BEGIN
    SELECT TOP 1 @TrackID = ProductionTrackID
    FROM dbo.USLoanProductionTrack
    WHERE EmployeeID = @EmployeeID
        AND EndDatetime IS NULL
        AND DealNo = @DealNo
        AND LoanNo = @LoanNo
        AND ISNULL(Script, '') = ISNULL(@Script, '')
        AND (
            (@ProcessID > 0 AND ProcessID = @ProcessID)
            OR (@ProcessID <= 0 AND ISNULL(ProcessID, 0) = 0 AND ISNULL([Process], '') = ISNULL(@Process, ''))
        )
    ORDER BY
        CASE WHEN @ProcessID > 0 AND ProcessID = @ProcessID THEN 0 ELSE 1 END,
        StartDatetime DESC,
        ProductionTrackID DESC;

    IF @TrackID IS NULL
    BEGIN
        INSERT INTO dbo.USLoanProductionTrack
        (
            ProcessID, ProjectNumber, DealNo, LoanNo, OrderDate, [Process], Script, Review, SourcePage,
            StartDatetime, EndDatetime, EmployeeID, AddedBy, AddedDate, [Status]
        )
        VALUES
        (
            @ProcessID, @ProjectNumber, @DealNo, @LoanNo, @OrderDate, @Process, @Script, @Review, @SourcePage,
            @StartValue, @EndValue, @EmployeeID, @AddedBy, GETDATE(), 'Completed'
        );
    END
    ELSE
    BEGIN
        UPDATE dbo.USLoanProductionTrack
        SET ProcessID = CASE WHEN @ProcessID > 0 THEN @ProcessID ELSE ProcessID END,
            ProjectNumber = @ProjectNumber,
            DealNo = @DealNo,
            LoanNo = @LoanNo,
            OrderDate = @OrderDate,
            [Process] = @Process,
            Script = @Script,
            Review = @Review,
            SourcePage = COALESCE(NULLIF(@SourcePage, ''), SourcePage),
            StartDatetime = COALESCE(StartDatetime, @StartValue),
            EndDatetime = @EndValue,
            [Status] = 'Completed',
            ModifiedBy = @AddedBy,
            ModifiedDate = GETDATE()
        WHERE ProductionTrackID = @TrackID;
    END
END

SELECT 1;");

            SQLHelper.AddParamToSQLCmd(cmd, "@Action", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, htParam["Action"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["OrderDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 250, System.Data.ParameterDirection.Input, htParam["Process"]);
            object script = htParam.ContainsKey("Script") ? htParam["Script"] : "";
            SQLHelper.AddParamToSQLCmd(cmd, "@Script", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, script);
            SQLHelper.AddParamToSQLCmd(cmd, "@Review", System.Data.SqlDbType.NVarChar, 250, System.Data.ParameterDirection.Input, htParam["Review"]);
            object sourcePage = htParam.ContainsKey("SourcePage") ? htParam["SourcePage"] : "";
            SQLHelper.AddParamToSQLCmd(cmd, "@SourcePage", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, sourcePage);
            SQLHelper.AddParamToSQLCmd(cmd, "@StartDatetime", System.Data.SqlDbType.NVarChar, 30, System.Data.ParameterDirection.Input, htParam["StartDatetime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EndDatetime", System.Data.SqlDbType.NVarChar, 30, System.Data.ParameterDirection.Input, htParam["EndDatetime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);

            object result = SQLHelper.ExecuteScalarCmd(cmd);
            cmd.Dispose();

            return result == null ? 0 : Convert.ToInt32(result);
        }

        public int InsertOnShoreUSFeedbacks(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertOnShoreUSFeedbaks");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Finding", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Finding"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Severity", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Severity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertOnShoreUSFeedbacksCanopy(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
INSERT INTO dbo.OnShoreFeedbacks
    (ProjectID, ProcessID, DealNo, LoanNo, Script, Finding, Severity, AddedBy, AddedDate, Attachment)
VALUES
    (@ProjectID, @ProcessID, @DealNo, @LoanNo, @Script, @Finding, @Severity, @AddedBy, GETDATE(), @Attachment);
SELECT CAST(SCOPE_IDENTITY() AS int);");
            AddCanopyFeedbackCommonParameters(cmd, htParam);
            SQLHelper.AddParamToSQLCmd(cmd, "@Finding", SqlDbType.NVarChar, 5000, ParameterDirection.Input, htParam["Finding"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Severity", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["Severity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", SqlDbType.NVarChar, 5000, ParameterDirection.Input, htParam["Attachment"]);
            object result = SQLHelper.ExecuteScalarCmd(cmd);
            cmd.Dispose();
            return result == null ? 0 : Convert.ToInt32(result);
        }

        public int InsertOnShoreUSATRFeedbacks(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUSATRFeedback");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reviewer", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Reviewer"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ReviewDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isATRSupported", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["isATRSupported"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewFindings", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["ReviewFindings"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SellerDisclosedDTIIssue", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["SellerDisclosedDTIIssue"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfBorrowers", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NoOfBorrowers"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@HighestBorrowerIncomeType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["HighestBorrowerIncomeType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfSEBusiness", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NoOfSEBusiness"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfRentalProperties", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NoOfRentalProperties"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Comments", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Comments"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertOnShoreUSATRFeedbacksCanopy(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
INSERT INTO dbo.OnShoreFeedbacks_ATRReview
    (ProjectID, ProcessID, DealNo, LoanNo, Script, Reviewer, ReviewDate, isATRSupported,
     ReviewFindings, SellerDisclosedDTIIssue, NoOfBorrowers, HighestBorrowerIncomeType,
     NoOfSEBusiness, NoOfRentalProperties, Comments, AddedBy, AddedDate)
VALUES
    (@ProjectID, @ProcessID, @DealNo, @LoanNo, @Script, @Reviewer, @ReviewDate, @isATRSupported,
     @ReviewFindings, @SellerDisclosedDTIIssue, @NoOfBorrowers, @HighestBorrowerIncomeType,
     @NoOfSEBusiness, @NoOfRentalProperties, @Comments, @AddedBy, GETDATE());
SELECT CAST(SCOPE_IDENTITY() AS int);");
            AddCanopyFeedbackCommonParameters(cmd, htParam);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reviewer", SqlDbType.NVarChar, 500, ParameterDirection.Input, htParam["Reviewer"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewDate", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["ReviewDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isATRSupported", SqlDbType.Bit, 0, ParameterDirection.Input, htParam["isATRSupported"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewFindings", SqlDbType.NVarChar, 5000, ParameterDirection.Input, htParam["ReviewFindings"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SellerDisclosedDTIIssue", SqlDbType.NVarChar, 5000, ParameterDirection.Input, htParam["SellerDisclosedDTIIssue"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfBorrowers", SqlDbType.Int, 0, ParameterDirection.Input, htParam["NoOfBorrowers"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@HighestBorrowerIncomeType", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["HighestBorrowerIncomeType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfSEBusiness", SqlDbType.Int, 0, ParameterDirection.Input, htParam["NoOfSEBusiness"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfRentalProperties", SqlDbType.Int, 0, ParameterDirection.Input, htParam["NoOfRentalProperties"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Comments", SqlDbType.NVarChar, 5000, ParameterDirection.Input, htParam["Comments"]);
            object result = SQLHelper.ExecuteScalarCmd(cmd);
            cmd.Dispose();
            return result == null ? 0 : Convert.ToInt32(result);
        }

        private static void AddCanopyFeedbackCommonParameters(SqlCommand cmd, Hashtable htParam)
        {
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 0, ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", SqlDbType.Int, 0, ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Script", SqlDbType.NVarChar, 500, ParameterDirection.Input, htParam["Script"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["AddedBy"]);
        }

        public int InsertOnShoreProduction(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertOnShoreProduction");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@StartTime", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["StartTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EndTime", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["EndTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TotalTime", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["TotalTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskPerformed", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["TaskPerformed"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Target", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, htParam["Target"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoansReviewed", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["LoansReviewed"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TargetvsProduction", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, htParam["TargetvsProduction"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TotalErrors", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["TotalErrors"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Critical", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["Critical"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NonCritical", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NonCritical"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncorrectErrors", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["IncorrectErrors"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorFindingRate", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, htParam["ErrorFindingRate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CostPerLoan", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, htParam["CostPerLoan"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Comments", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Comments"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }


        public int InsertUSAssets(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUSAssets");
            SQLHelper.AddParamToSQLCmd(cmd, "@User", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["User"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SerialNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["SerialNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Brand", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Brand"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IssueDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["IssueDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable DeleteAllTempReQC1()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TempReQC_11");
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        #endregion

        #region Condition Clearing


        public DataTable GetAllProjectByUserRights_ForAddFeedback(string EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[WBT_usp_GetAllProjectByUserRightsFor_OnlineTracking_ForAddFeedback]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetAllProjectByUserRights(string EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[WBT_usp_GetAllProjectByUserRightsFor_OnlineTracking]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable ViewAllConditionClearing()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_ViewAllConditionClearing]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable ViewAllConditionClearingById(int Id)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ViewAllConditionClearingbyId");
            SQLHelper.AddParamToSQLCmd(cmd, "@Id", SqlDbType.BigInt, 0, ParameterDirection.Input, Id);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetAllProjectDealNumberNew(int ProjectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllProjectDealNo_UW_new]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Projectid", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;

        }


        public DataTable GetDealFromLoan(string LoanNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_getDealNoFromLoanNo]");
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, LoanNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }



        public DataTable GetAllOrderNoByProjectWise(int ProjectID, string DealNo, string ProcessName, string Review, string Type)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProjectDealNo_OrderNo_UW");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessName", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, ProcessName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Review", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Review);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Type);


            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public int InsertConditionClearing(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_Insert_ConditionClearing");
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ProjectId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InfinityCondition", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["InfinityCondition"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientsRebuttal", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ClientsRebuttal"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReceivedDate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ReceivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewDate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ReviewDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InfinityResponse", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["InfinityResponse"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Cleared", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Cleared"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TotalTime", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["TotalTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InitialExceptionGrade", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["InitialExceptionGrade"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable ViewAllConditionClearingPending()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_ViewAllConditionClearing_Pending_NewERP]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }


        public DataTable GetAllFeedbackByDateRange_NewFormat_Onshore(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllFeedbackByDateRange_NewFormat_OnShore");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int SaveInfinityOnshoreRemark(int FeedbackID, string Client, string Remark, string RebuttalStatus, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_SaveInfinityFeedbackOnshoreRemark_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, FeedbackID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Client", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Client);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Remark); 
            SQLHelper.AddParamToSQLCmd(cmd, "@RebuttalStatus", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, RebuttalStatus);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetAllConditionClearing(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ViewAllConditionClearingReport");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UpdateConditionClearing(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_Update_ConditionClearing");
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Id", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["Id"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ProjectId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InfinityCondition", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["InfinityCondition"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientsRebuttal", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ClientsRebuttal"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReceivedDate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ReceivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewDate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ReviewDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InfinityResponse", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["InfinityResponse"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Cleared", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Cleared"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TotalTime", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["TotalTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Sdate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Sdate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Edate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Edate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FinalExceptionGrade", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["FinalExceptionGrade"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }


        #endregion

    }
}
