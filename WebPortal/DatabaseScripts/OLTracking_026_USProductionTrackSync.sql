/* Historical/on-demand synchronization from USLoanProductionTrack into OLTracking.
   Preview first with @PreviewOnly=1. Existing assignments are updated and missing
   completed assignments are inserted only when the tracker loan and process exist. */
IF OBJECT_ID('dbo.OLTracking_SyncUSLoanProductionTrack', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_SyncUSLoanProductionTrack AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_SyncUSLoanProductionTrack
    @FromDate date = NULL,
    @ToDate date = NULL,
    @ProcessName nvarchar(250) = NULL,
    @PreviewOnly bit = 1
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @FromDate IS NOT NULL AND @ToDate IS NOT NULL AND @FromDate > @ToDate
        THROW 50261, 'From date cannot be later than To date.', 1;

    CREATE TABLE #Matches
    (
        MatchID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
        AssignmentID bigint NULL,
        ItemID bigint NOT NULL,
        ProjectID int NOT NULL,
        ProjectNumber nvarchar(100) NOT NULL,
        DealNumber nvarchar(150) NOT NULL,
        LoanNumber nvarchar(150) NOT NULL,
        ProcessID int NOT NULL,
        ProcessName nvarchar(250) NOT NULL,
        UserID int NOT NULL,
        AssignedDate datetime NOT NULL,
        StartedDate datetime NULL,
        CompletedDate datetime NOT NULL,
        TotalTATSeconds bigint NOT NULL,
        OldStatus varchar(20) NULL,
        WasExisting bit NOT NULL,
        ProductionTrackID bigint NOT NULL
    );

    ;WITH SourceRows AS
    (
        SELECT
            track.ProductionTrackID,
            CASE LTRIM(RTRIM(ISNULL(track.ProjectNumber, '')))
                WHEN '561' THEN 70
                WHEN '2104' THEN 602
            END ProjectID,
            LTRIM(RTRIM(track.ProjectNumber)) ProjectNumber,
            LTRIM(RTRIM(track.DealNo)) DealNumber,
            LTRIM(RTRIM(track.LoanNo)) LoanNumber,
            LTRIM(RTRIM(track.[Process])) ProcessName,
            track.EmployeeID UserID,
            COALESCE(track.AddedDate, track.StartDatetime, track.EndDatetime) AssignedDate,
            track.StartDatetime StartedDate,
            track.EndDatetime CompletedDate,
            ROW_NUMBER() OVER
            (
                PARTITION BY LTRIM(RTRIM(track.ProjectNumber)), LTRIM(RTRIM(track.DealNo)),
                             LTRIM(RTRIM(track.LoanNo)),
                             UPPER(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(track.[Process])), ' ', ''), '-', ''), '_', ''))
                ORDER BY track.EndDatetime DESC, track.ProductionTrackID DESC
            ) RowNumber
        FROM dbo.USLoanProductionTrack track
        WHERE LTRIM(RTRIM(ISNULL(track.ProjectNumber, ''))) IN ('561', '2104')
          AND NULLIF(LTRIM(RTRIM(ISNULL(track.DealNo, ''))), '') IS NOT NULL
          AND NULLIF(LTRIM(RTRIM(ISNULL(track.LoanNo, ''))), '') IS NOT NULL
          AND NULLIF(LTRIM(RTRIM(ISNULL(track.[Process], ''))), '') IS NOT NULL
          AND
          (
              @ProcessName IS NULL
              OR UPPER(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(track.[Process])), ' ', ''), '-', ''), '_', ''))
                 = UPPER(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(@ProcessName)), ' ', ''), '-', ''), '_', ''))
          )
          AND ISNULL(track.EmployeeID, 0) > 0
          AND track.EndDatetime IS NOT NULL
          AND (UPPER(LTRIM(RTRIM(ISNULL(track.[Status], '')))) = 'COMPLETED' OR track.EndDatetime IS NOT NULL)
          AND (@FromDate IS NULL OR CONVERT(date, track.EndDatetime) >= @FromDate)
          AND (@ToDate IS NULL OR CONVERT(date, track.EndDatetime) <= @ToDate)
    )
    INSERT #Matches
    (
        AssignmentID, ItemID, ProjectID, ProjectNumber, DealNumber, LoanNumber,
        ProcessID, ProcessName, UserID, AssignedDate, StartedDate,
        CompletedDate, TotalTATSeconds, OldStatus, WasExisting, ProductionTrackID
    )
    SELECT
        assignment.AssignmentID,
        item.ItemID,
        source.ProjectID,
        source.ProjectNumber,
        source.DealNumber,
        source.LoanNumber,
        flow.ProcessID,
        flow.ProcessName,
        source.UserID,
        source.AssignedDate,
        CASE WHEN source.StartedDate > source.CompletedDate THEN source.CompletedDate
             ELSE COALESCE(source.StartedDate, source.AssignedDate) END,
        source.CompletedDate,
        CASE WHEN DATEDIFF(second, source.AssignedDate, source.CompletedDate) < 0 THEN 0
             ELSE CONVERT(bigint, DATEDIFF(second, source.AssignedDate, source.CompletedDate)) END,
        assignment.AssignmentStatus,
        CONVERT(bit, CASE WHEN assignment.AssignmentID IS NULL THEN 0 ELSE 1 END),
        source.ProductionTrackID
    FROM SourceRows source
    JOIN dbo.OLTracking_Item item
      ON item.ProjectID = source.ProjectID
     AND item.IsDeleted = 0
     AND LTRIM(RTRIM(item.DealNumber)) = source.DealNumber
     AND LTRIM(RTRIM(item.ItemNumber)) = source.LoanNumber
     AND NOT EXISTS
         (
             SELECT 1
             FROM dbo.OLTracking_LoanHold loanHold
             WHERE loanHold.ItemID=item.ItemID
               AND loanHold.ResumedDate IS NULL
         )
    CROSS APPLY
    (
        SELECT TOP (1) effective.ProcessID, effective.ProcessName
        FROM dbo.OLTracking_EffectiveProcessFlow(source.ProjectID, source.DealNumber) effective
        WHERE UPPER(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(effective.ProcessName)), ' ', ''), '-', ''), '_', ''))
              = UPPER(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(source.ProcessName)), ' ', ''), '-', ''), '_', ''))
        ORDER BY effective.StageNo, effective.ProcessID
    ) flow
    OUTER APPLY
    (
        SELECT TOP (1) existing.AssignmentID, existing.AssignmentStatus
        FROM dbo.OLTracking_Assignment existing
        WHERE existing.ItemID = item.ItemID
          AND existing.ProjectID = source.ProjectID
          AND existing.ProcessID = flow.ProcessID
        ORDER BY existing.IsCurrent DESC, existing.AssignmentID DESC
    ) assignment
    WHERE source.RowNumber = 1;

    IF @PreviewOnly = 1
    BEGIN
        SELECT ProjectNumber, ProjectID, DealNumber, LoanNumber, ProcessName,
               UserID, AssignedDate, StartedDate, CompletedDate,
               TotalTATSeconds, CASE WHEN WasExisting=1 THEN 'Update' ELSE 'Insert' END MappingAction,
               OldStatus, ProductionTrackID, AssignmentID
        FROM #Matches
        ORDER BY ProjectID, DealNumber, LoanNumber, ProcessName;

        SELECT COUNT(*) MatchedLoans,
               SUM(CASE WHEN WasExisting=1 THEN 1 ELSE 0 END) ExistingAssignmentsToUpdate,
               SUM(CASE WHEN WasExisting=0 THEN 1 ELSE 0 END) MissingAssignmentsToInsert,
               COUNT(DISTINCT UserID) OnshoreUsers,
               MIN(CompletedDate) EarliestCompletion,
               MAX(CompletedDate) LatestCompletion
        FROM #Matches;
        RETURN;
    END;

    DECLARE @LockResult int;
    EXEC @LockResult = sys.sp_getapplock
        @Resource = N'OLTracking_SyncUSLoanProductionTrack',
        @LockMode = N'Exclusive',
        @LockOwner = N'Session',
        @LockTimeout = 0;
    IF @LockResult < 0 THROW 50262, 'US production-track synchronization is already running.', 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT dbo.OLTracking_Assignment
        (
            ItemID, ProjectID, ProcessID, UserID, LoanNumber,
            AssignmentStatus, AssignedDate, StartedDate, CompletedDate,
            TotalTATSeconds, LastRemark, IsCurrent,
            AddedBy, AddedDate, UpdatedBy, UpdatedDate
        )
        SELECT
            source.ItemID, source.ProjectID, source.ProcessID, source.UserID, source.LoanNumber,
            'Completed', source.AssignedDate, source.StartedDate, source.CompletedDate,
            source.TotalTATSeconds, 'Mapped from USLoanProductionTrack', 0,
            source.UserID, source.AssignedDate, source.UserID, GETDATE()
        FROM #Matches source
        WHERE source.WasExisting=0;

        UPDATE source
        SET source.AssignmentID=inserted.AssignmentID,
            source.OldStatus=NULL
        FROM #Matches source
        CROSS APPLY
        (
            SELECT TOP (1) assignment.AssignmentID
            FROM dbo.OLTracking_Assignment assignment
            WHERE assignment.ItemID=source.ItemID
              AND assignment.ProjectID=source.ProjectID
              AND assignment.ProcessID=source.ProcessID
              AND assignment.UserID=source.UserID
              AND assignment.AssignmentStatus='Completed'
              AND assignment.CompletedDate=source.CompletedDate
            ORDER BY assignment.AssignmentID DESC
        ) inserted
        WHERE source.WasExisting=0;

        UPDATE assignment
        SET assignment.UserID = source.UserID,
            assignment.AssignedDate = source.AssignedDate,
            assignment.StartedDate = source.StartedDate,
            assignment.CompletedDate = source.CompletedDate,
            assignment.TotalTATSeconds = source.TotalTATSeconds,
            assignment.AssignmentStatus = 'Completed',
            assignment.IsCurrent = 0,
            assignment.LastRemark = 'Mapped from USLoanProductionTrack',
            assignment.UpdatedBy = source.UserID,
            assignment.UpdatedDate = GETDATE()
        FROM dbo.OLTracking_Assignment assignment
        JOIN #Matches source ON source.AssignmentID = assignment.AssignmentID;

        INSERT dbo.OLTracking_StatusHistory
            (AssignmentID, OldStatus, NewStatus, Remark, ChangedBy)
        SELECT source.AssignmentID, source.OldStatus, 'Completed',
               'Mapped from USLoanProductionTrack', source.UserID
        FROM #Matches source
        WHERE source.WasExisting=0 OR ISNULL(source.OldStatus,'') <> 'Completed';

        COMMIT TRANSACTION;
        EXEC sys.sp_releaseapplock
            @Resource = N'OLTracking_SyncUSLoanProductionTrack',
            @LockOwner = N'Session';

        SELECT COUNT(*) SynchronizedAssignments,
               SUM(CASE WHEN WasExisting=1 THEN 1 ELSE 0 END) UpdatedAssignments,
               SUM(CASE WHEN WasExisting=0 THEN 1 ELSE 0 END) InsertedAssignments,
               COUNT(DISTINCT UserID) OnshoreUsers,
               MIN(CompletedDate) EarliestCompletion,
               MAX(CompletedDate) LatestCompletion
        FROM #Matches;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        EXEC sys.sp_releaseapplock
            @Resource = N'OLTracking_SyncUSLoanProductionTrack',
            @LockOwner = N'Session';
        THROW;
    END CATCH;
END;
GO
