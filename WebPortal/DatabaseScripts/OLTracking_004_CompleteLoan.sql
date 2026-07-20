IF OBJECT_ID('dbo.OLTracking_CompleteLoan', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_CompleteLoan AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_CompleteLoan
    @AssignmentID bigint,
    @Remark nvarchar(1000),
    @FeedbackXml xml = NULL,
    @UserID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NULLIF(LTRIM(RTRIM(@Remark)), '') IS NULL
            THROW 50121, 'Remark is required.', 1;

        DECLARE @ItemID bigint,
                @ProjectID int,
                @ProcessID int,
                @OldStatus varchar(20),
                @FeedbackRequired bit;

        SELECT
            @ItemID = assignment.ItemID,
            @ProjectID = assignment.ProjectID,
            @ProcessID = assignment.ProcessID,
            @OldStatus = assignment.AssignmentStatus,
            @FeedbackRequired = flow.FeedbackRequiredOnComplete
        FROM dbo.OLTracking_Assignment assignment WITH (UPDLOCK, HOLDLOCK)
        INNER JOIN dbo.OLTracking_ProcessFlow flow
            ON flow.ProjectID = assignment.ProjectID
           AND flow.ProcessID = assignment.ProcessID
           AND flow.IsActive = 1
        WHERE assignment.AssignmentID = @AssignmentID
          AND assignment.UserID = @UserID
          AND assignment.IsCurrent = 1;

        IF @ItemID IS NULL
            THROW 50122, 'Assignment was not found.', 1;

        IF @FeedbackRequired = 1
           AND (@FeedbackXml IS NULL OR @FeedbackXml.exist('/feedbacks/feedback[1]') = 0)
            THROW 50123, 'Feedback is mandatory for this process.', 1;

        IF @FeedbackXml IS NOT NULL
        BEGIN
            INSERT dbo.OLTracking_Feedback (AssignmentID, FeedbackText, AddedBy)
            SELECT
                @AssignmentID,
                feedbackNode.value('(text())[1]', 'nvarchar(2000)'),
                @UserID
            FROM @FeedbackXml.nodes('/feedbacks/feedback') feedback(feedbackNode)
            WHERE NULLIF(LTRIM(RTRIM(feedbackNode.value('(text())[1]', 'nvarchar(2000)'))), '') IS NOT NULL;
        END;

        UPDATE dbo.OLTracking_Assignment
        SET AssignmentStatus = 'Completed',
            CompletedDate = GETDATE(),
            LastRemark = @Remark,
            IsCurrent = 0,
            UpdatedBy = @UserID,
            UpdatedDate = GETDATE()
        WHERE AssignmentID = @AssignmentID;

        INSERT dbo.OLTracking_StatusHistory
            (AssignmentID, OldStatus, NewStatus, Remark, ChangedBy)
        VALUES
            (@AssignmentID, @OldStatus, 'Completed', @Remark, @UserID);

        DECLARE @AllMandatoryDone bit = 0;
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.OLTracking_ProcessFlow requiredFlow
            WHERE requiredFlow.ProjectID = @ProjectID
              AND requiredFlow.IsActive = 1
              AND requiredFlow.IsMandatory = 1
              AND NOT EXISTS
              (
                  SELECT 1
                  FROM dbo.OLTracking_Assignment completedAssignment
                  WHERE completedAssignment.ItemID = @ItemID
                    AND completedAssignment.ProcessID = requiredFlow.ProcessID
                    AND completedAssignment.AssignmentStatus IN ('Completed', 'Skipped')
              )
        )
            SET @AllMandatoryDone = 1;

        UPDATE dbo.OLTracking_Item
        SET ItemStatus = CASE WHEN @AllMandatoryDone = 1 THEN 'Completed' ELSE 'Pending' END,
            CurrentProcessID = NULL,
            UpdatedBy = @UserID,
            UpdatedDate = GETDATE()
        WHERE ItemID = @ItemID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
