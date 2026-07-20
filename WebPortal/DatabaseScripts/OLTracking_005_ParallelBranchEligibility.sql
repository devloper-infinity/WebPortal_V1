IF OBJECT_ID('dbo.OLTracking_IsLoanEligible', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_IsLoanEligible AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_IsLoanEligible
    @ProjectID int,
    @ProcessID int,
    @LoanNumber nvarchar(150)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StageNo int =
    (
        SELECT StageNo FROM dbo.OLTracking_ProcessFlow
        WHERE ProjectID = @ProjectID AND ProcessID = @ProcessID AND IsActive = 1
    );
    DECLARE @ItemID bigint =
    (
        SELECT ItemID FROM dbo.OLTracking_Item
        WHERE ProjectID = @ProjectID AND ItemNumber = @LoanNumber AND IsDeleted = 0
    );
    DECLARE @PreviousStage int;

    IF @StageNo IS NULL
    BEGIN
        SELECT CAST(0 AS bit) Eligible, 'Process is not configured in tracking flow.' Reason;
        RETURN;
    END;

    IF @ItemID IS NOT NULL AND EXISTS
    (
        SELECT 1 FROM dbo.OLTracking_Assignment
        WHERE ItemID = @ItemID AND ProcessID = @ProcessID
          AND (IsCurrent = 1 OR AssignmentStatus IN ('Completed', 'Skipped'))
    )
    BEGIN
        SELECT CAST(0 AS bit) Eligible, 'Loan is already allocated or completed for this process.' Reason;
        RETURN;
    END;

    SELECT @PreviousStage = MAX(StageNo)
    FROM dbo.OLTracking_ProcessFlow
    WHERE ProjectID = @ProjectID AND IsActive = 1 AND StageNo < @StageNo;

    IF @PreviousStage IS NULL OR NOT EXISTS
    (
        SELECT 1 FROM dbo.OLTracking_ProcessFlow
        WHERE ProjectID = @ProjectID AND IsActive = 1
          AND StageNo = @PreviousStage AND IsMandatory = 1
    )
    BEGIN
        SELECT CAST(1 AS bit) Eligible, '' Reason;
        RETURN;
    END;

    IF @ItemID IS NULL OR NOT EXISTS
    (
        SELECT 1
        FROM dbo.OLTracking_Assignment completedAssignment
        INNER JOIN dbo.OLTracking_ProcessFlow completedFlow
            ON completedFlow.ProjectID = @ProjectID
           AND completedFlow.ProcessID = completedAssignment.ProcessID
           AND completedFlow.IsActive = 1
           AND completedFlow.IsMandatory = 1
           AND completedFlow.StageNo = @PreviousStage
        WHERE completedAssignment.ItemID = @ItemID
          AND completedAssignment.AssignmentStatus IN ('Completed', 'Skipped')
    )
    BEGIN
        SELECT CAST(0 AS bit) Eligible, 'A process in the previous sequence must be completed first.' Reason;
        RETURN;
    END;

    SELECT CAST(1 AS bit) Eligible, '' Reason;
END;
GO

IF OBJECT_ID('dbo.OLTracking_AllocateLoan', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_AllocateLoan AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_AllocateLoan
    @ProjectID int,
    @ProcessID int,
    @LoanNumber nvarchar(150),
    @DealNumber nvarchar(150),
    @UserID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF
        (
            SELECT COUNT(*) FROM dbo.OLTracking_Assignment WITH (UPDLOCK, HOLDLOCK)
            WHERE UserID = @UserID AND IsCurrent = 1
              AND AssignmentStatus IN ('Pending', 'In Process')
        ) >= 2
            THROW 50110, 'You already have two pending/in-process loans. Complete or hold one before allocating another.', 1;

        DECLARE @StageNo int =
        (
            SELECT StageNo FROM dbo.OLTracking_ProcessFlow
            WHERE ProjectID = @ProjectID AND ProcessID = @ProcessID AND IsActive = 1
        );
        IF @StageNo IS NULL
            THROW 50111, 'Selected process is not configured in the tracking flow.', 1;

        DECLARE @ItemID bigint =
        (
            SELECT ItemID FROM dbo.OLTracking_Item WITH (UPDLOCK, HOLDLOCK)
            WHERE ProjectID = @ProjectID AND ItemNumber = @LoanNumber AND IsDeleted = 0
        );

        IF @ItemID IS NULL
        BEGIN
            INSERT dbo.OLTracking_Item
                (ProjectID, ItemNumber, DealNumber, CurrentProcessID, ItemStatus, AddedBy)
            VALUES
                (@ProjectID, @LoanNumber, NULLIF(@DealNumber, ''), @ProcessID, 'Pending', @UserID);
            SET @ItemID = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE dbo.OLTracking_Item
            SET DealNumber = NULLIF(@DealNumber, ''), CurrentProcessID = @ProcessID,
                UpdatedBy = @UserID, UpdatedDate = GETDATE()
            WHERE ItemID = @ItemID;
        END;

        IF EXISTS
        (
            SELECT 1 FROM dbo.OLTracking_Assignment
            WHERE ItemID = @ItemID AND ProcessID = @ProcessID
              AND (IsCurrent = 1 OR AssignmentStatus IN ('Completed', 'Skipped'))
        )
            THROW 50112, 'This loan is already allocated or completed for the selected process.', 1;

        DECLARE @PreviousStage int;
        SELECT @PreviousStage = MAX(StageNo)
        FROM dbo.OLTracking_ProcessFlow
        WHERE ProjectID = @ProjectID AND IsActive = 1 AND StageNo < @StageNo;

        IF @PreviousStage IS NOT NULL
           AND EXISTS
           (
               SELECT 1 FROM dbo.OLTracking_ProcessFlow
               WHERE ProjectID = @ProjectID AND IsActive = 1
                 AND StageNo = @PreviousStage AND IsMandatory = 1
           )
           AND NOT EXISTS
           (
               SELECT 1
               FROM dbo.OLTracking_Assignment completedAssignment
               INNER JOIN dbo.OLTracking_ProcessFlow completedFlow
                   ON completedFlow.ProjectID = @ProjectID
                  AND completedFlow.ProcessID = completedAssignment.ProcessID
                  AND completedFlow.IsActive = 1
                  AND completedFlow.IsMandatory = 1
                  AND completedFlow.StageNo = @PreviousStage
               WHERE completedAssignment.ItemID = @ItemID
                 AND completedAssignment.AssignmentStatus IN ('Completed', 'Skipped')
           )
            THROW 50113, 'A process in the previous sequence must be completed first.', 1;

        INSERT dbo.OLTracking_Assignment
            (ItemID, ProjectID, ProcessID, UserID, AssignmentStatus, AddedBy)
        VALUES
            (@ItemID, @ProjectID, @ProcessID, @UserID, 'Pending', @UserID);

        DECLARE @AssignmentID bigint = SCOPE_IDENTITY();

        UPDATE dbo.OLTracking_Item
        SET ItemStatus = 'Allocated', UpdatedBy = @UserID, UpdatedDate = GETDATE()
        WHERE ItemID = @ItemID;

        COMMIT TRANSACTION;
        SELECT @AssignmentID AssignmentID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
