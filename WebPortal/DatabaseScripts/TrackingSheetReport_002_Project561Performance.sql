/* TrackingSheetReport.aspx performance support for Project 561.
   No Pre/Post Close objects or logic are changed. Safe to rerun. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Project WHERE ProjectID=561)
    THROW 50201,'Project 561 was not found. No report indexes were created.',1;
GO

/* Restrict the report's first lookup to active Project 561 items. */
IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_Item')
      AND name='IX_OLTracking_Item_Report_Project561'
)
BEGIN
    CREATE INDEX IX_OLTracking_Item_Report_Project561
        ON dbo.OLTracking_Item(ItemID)
        INCLUDE(DealNumber,ItemNumber)
        WHERE ProjectID=561 AND IsDeleted=0;
END;
GO

/* Covers the report's DISTINCT ItemID/EntryDate date-range source. */
IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_ImportBatchItem')
      AND name='IX_OLTracking_ImportBatchItem_ReportDate'
)
BEGIN
    CREATE INDEX IX_OLTracking_ImportBatchItem_ReportDate
        ON dbo.OLTracking_ImportBatchItem(EntryDate,ItemID);
END;
GO

/* Covers TOP(1) assignment resolution for every loan/process row. */
IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_Assignment')
      AND name='IX_OLTracking_Assignment_ReportItemProcess'
)
BEGIN
    CREATE INDEX IX_OLTracking_Assignment_ReportItemProcess
        ON dbo.OLTracking_Assignment(ItemID,ProcessID,IsCurrent,AssignmentID DESC)
        INCLUDE(AssignmentStatus,UserID,AssignedDate,StartedDate,CompletedDate,
                AddedDate,ManualDurationMinutes,TotalTATSeconds);
END;
GO

/* Covers the active-hold EXISTS check in the report. */
IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_LoanHold')
      AND name='IX_OLTracking_LoanHold_ReportActive'
)
BEGIN
    CREATE INDEX IX_OLTracking_LoanHold_ReportActive
        ON dbo.OLTracking_LoanHold(ItemID)
        WHERE ResumedDate IS NULL;
END;
GO
