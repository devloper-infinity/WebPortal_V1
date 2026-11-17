IF OBJECT_ID('dbo.OLTracking_SyncOnshoreCompletion', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_SyncOnshoreCompletion AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_SyncOnshoreCompletion
    @ProjectNumber nvarchar(100),
    @DealNumber nvarchar(150),
    @LoanNumber nvarchar(150),
    @ProcessName nvarchar(250),
    @UserID int,
    @StartedDate datetime = NULL,
    @CompletedDate datetime = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ProjectID int,
            @ItemID bigint,
            @ProcessID int,
            @AssignmentID bigint,
            @OldStatus varchar(20),
            @AssignedDate datetime,
            @HoldSeconds bigint,
            @TotalSeconds bigint;

    SET @ProjectID = CASE LTRIM(RTRIM(ISNULL(@ProjectNumber, '')))
        WHEN '561' THEN 70
        WHEN '70' THEN 70
        WHEN '2104' THEN 602
        WHEN '602' THEN 602
        WHEN '2128' THEN 695
        WHEN '695' THEN 695
        ELSE NULL
    END;

    IF @ProjectID IS NULL
    BEGIN
        SELECT 0;
        RETURN;
    END;

    SELECT TOP (1) @ItemID = item.ItemID
    FROM dbo.OLTracking_Item item
    WHERE item.ProjectID = @ProjectID
      AND item.IsDeleted = 0
      AND LTRIM(RTRIM(item.ItemNumber)) = LTRIM(RTRIM(ISNULL(@LoanNumber, '')))
      AND LTRIM(RTRIM(ISNULL(item.DealNumber, ''))) = LTRIM(RTRIM(ISNULL(@DealNumber, '')))
    ORDER BY item.ItemID DESC;

    IF @ItemID IS NULL
    BEGIN
        SELECT 0;
        RETURN;
    END;

    SELECT TOP (1) @ProcessID = flow.ProcessID
    FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID, @DealNumber) flow
    WHERE LTRIM(RTRIM(flow.ProcessName)) = LTRIM(RTRIM(ISNULL(@ProcessName, '')))
    ORDER BY flow.StageNo, flow.ProcessID;

    IF @ProcessID IS NULL
    BEGIN
        SELECT 0;
        RETURN;
    END;

    SET @CompletedDate = ISNULL(@CompletedDate, GETDATE());

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT TOP (1)
            @AssignmentID = assignment.AssignmentID,
            @OldStatus = assignment.AssignmentStatus,
            @AssignedDate = assignment.AssignedDate,
            @HoldSeconds = ISNULL(assignment.HoldTATSeconds, 0)
        FROM dbo.OLTracking_Assignment assignment WITH (UPDLOCK, HOLDLOCK)
        WHERE assignment.ItemID = @ItemID
          AND assignment.ProjectID = @ProjectID
          AND assignment.ProcessID = @ProcessID
        ORDER BY assignment.IsCurrent DESC, assignment.AssignmentID DESC;

        IF @AssignmentID IS NULL
        BEGIN
            COMMIT TRANSACTION;
            SELECT 0;
            RETURN;
        END;

        SET @StartedDate = COALESCE(@StartedDate, @AssignedDate);
        IF @StartedDate > @CompletedDate SET @StartedDate = @CompletedDate;
        SET @TotalSeconds = CASE
            WHEN @AssignedDate IS NULL OR DATEDIFF(second, @AssignedDate, @CompletedDate) - @HoldSeconds < 0 THEN 0
            ELSE DATEDIFF(second, @AssignedDate, @CompletedDate) - @HoldSeconds
        END;

        UPDATE dbo.OLTracking_Assignment
        SET UserID = @UserID,
            StartedDate = @StartedDate,
            CompletedDate = @CompletedDate,
            TotalTATSeconds = @TotalSeconds,
            AssignmentStatus = 'Completed',
            IsCurrent = 0,
            LastRemark = 'Completed by onshore user',
            UpdatedBy = @UserID,
            UpdatedDate = GETDATE()
        WHERE AssignmentID = @AssignmentID;

        IF ISNULL(@OldStatus, '') <> 'Completed'
        BEGIN
            INSERT dbo.OLTracking_StatusHistory
                (AssignmentID, OldStatus, NewStatus, Remark, ChangedBy)
            VALUES
                (@AssignmentID, @OldStatus, 'Completed', 'Completed by onshore user', @UserID);
        END;

        COMMIT TRANSACTION;
        SELECT 1;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
