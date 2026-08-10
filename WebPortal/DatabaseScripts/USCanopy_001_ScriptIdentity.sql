SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION;

IF COL_LENGTH('dbo.USLoanProductionTrack', 'Script') IS NULL
BEGIN
    ALTER TABLE dbo.USLoanProductionTrack
        ADD Script nvarchar(500) NULL;
END;

IF COL_LENGTH('dbo.OnShoreFeedbacks', 'Script') IS NULL
BEGIN
    ALTER TABLE dbo.OnShoreFeedbacks
        ADD Script nvarchar(500) NULL;
END;

IF COL_LENGTH('dbo.OnShoreFeedbacks_ATRReview', 'Script') IS NULL
BEGIN
    ALTER TABLE dbo.OnShoreFeedbacks_ATRReview
        ADD Script nvarchar(500) NULL;
END;

COMMIT TRANSACTION;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.USLoanProductionTrack')
      AND name = 'IX_USLoanProductionTrack_CanopyStatus'
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_USLoanProductionTrack_CanopyStatus
        ON dbo.USLoanProductionTrack (ProductionTrackID DESC)
        INCLUDE (ProjectNumber, DealNo, LoanNo, ProcessID, [Process], Script,
                 [Status], EmployeeID, StartDatetime, EndDatetime, AddedDate)
        WHERE SourcePage = 'CanopySearch';
END;

/*
    Backfill only Canopy production rows.  Global Search rows intentionally keep
    an empty Script so their existing Loan/Process behavior remains unchanged.
*/
UPDATE production
SET production.Script = script.ScriptName
FROM dbo.USLoanProductionTrack production
OUTER APPLY
(
    SELECT TOP (1) NULLIF(LTRIM(RTRIM(tracking.Temp4)), '') AS ScriptName
    FROM dbo.OrderData orders
    INNER JOIN dbo.Project project
        ON project.ProjectID = orders.ProjectID
    INNER JOIN Underwriting.dbo.WBT_TrackingSheet tracking
        ON tracking.ProjectId = orders.ProjectID
       AND tracking.Temp1 = orders.DealNo
       AND tracking.Temp2 = orders.LoanNo
    WHERE orders.DealNo = production.DealNo
      AND orders.LoanNo = production.LoanNo
      AND project.ProjectName = production.ProjectNumber
      AND NULLIF(LTRIM(RTRIM(tracking.Temp4)), '') IS NOT NULL
    ORDER BY orders.OrderDate DESC
) script
WHERE ISNULL(production.SourcePage, '') = 'CanopySearch'
  AND NULLIF(LTRIM(RTRIM(production.Script)), '') IS NULL
  AND script.ScriptName IS NOT NULL;

/* Existing Canopy feedback rows are mapped through their exact project/deal/loan. */
UPDATE feedback
SET feedback.Script = script.ScriptName
FROM dbo.OnShoreFeedbacks feedback
OUTER APPLY
(
    SELECT TOP (1) NULLIF(LTRIM(RTRIM(tracking.Temp4)), '') AS ScriptName
    FROM dbo.OrderData orders
    INNER JOIN Underwriting.dbo.WBT_TrackingSheet tracking
        ON tracking.ProjectId = orders.ProjectID
       AND tracking.Temp1 = orders.DealNo
       AND tracking.Temp2 = orders.LoanNo
    WHERE orders.ProjectID = feedback.ProjectID
      AND orders.DealNo = feedback.DealNo
      AND orders.LoanNo = feedback.LoanNo
      AND NULLIF(LTRIM(RTRIM(tracking.Temp4)), '') IS NOT NULL
    ORDER BY orders.OrderDate DESC
) script
WHERE NULLIF(LTRIM(RTRIM(feedback.Script)), '') IS NULL
  AND script.ScriptName IS NOT NULL;

UPDATE feedback
SET feedback.Script = script.ScriptName
FROM dbo.OnShoreFeedbacks_ATRReview feedback
OUTER APPLY
(
    SELECT TOP (1) NULLIF(LTRIM(RTRIM(tracking.Temp4)), '') AS ScriptName
    FROM dbo.OrderData orders
    INNER JOIN Underwriting.dbo.WBT_TrackingSheet tracking
        ON tracking.ProjectId = orders.ProjectID
       AND tracking.Temp1 = orders.DealNo
       AND tracking.Temp2 = orders.LoanNo
    WHERE orders.ProjectID = feedback.ProjectID
      AND orders.DealNo = feedback.DealNo
      AND orders.LoanNo = feedback.LoanNo
      AND NULLIF(LTRIM(RTRIM(tracking.Temp4)), '') IS NOT NULL
    ORDER BY orders.OrderDate DESC
) script
WHERE NULLIF(LTRIM(RTRIM(feedback.Script)), '') IS NULL
  AND script.ScriptName IS NOT NULL;

COMMIT TRANSACTION;
GO
