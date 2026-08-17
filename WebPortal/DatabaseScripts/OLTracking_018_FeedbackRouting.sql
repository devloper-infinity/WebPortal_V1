/* Process-specific feedback routing.
   Safe to rerun. Deploy after OLTracking_017. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.OLTracking_ProcessFeedbackTarget','U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ProcessFeedbackTarget
    (
        FeedbackTargetID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ProcessFeedbackTarget PRIMARY KEY,
        ProjectID int NOT NULL,
        ProcessID int NOT NULL,
        TargetProcessID int NOT NULL,
        IsActive bit NOT NULL CONSTRAINT DF_OLTracking_ProcessFeedbackTarget_Active DEFAULT(1),
        AddedBy int NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ProcessFeedbackTarget_Added DEFAULT(GETDATE()),
        UpdatedBy int NULL,
        UpdatedDate datetime NULL,
        CONSTRAINT UQ_OLTracking_ProcessFeedbackTarget UNIQUE(ProjectID,ProcessID,TargetProcessID),
        CONSTRAINT CK_OLTracking_ProcessFeedbackTarget_Self CHECK(ProcessID<>TargetProcessID)
    );
END;
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_ProcessFeedbackTarget')
      AND name='IX_OLTracking_ProcessFeedbackTarget_Target'
)
    CREATE INDEX IX_OLTracking_ProcessFeedbackTarget_Target
        ON dbo.OLTracking_ProcessFeedbackTarget(ProjectID,TargetProcessID,IsActive)
        INCLUDE(ProcessID);
GO

IF COL_LENGTH('dbo.OLTracking_Feedback','FeedbackAgainstAssignmentID') IS NULL
    ALTER TABLE dbo.OLTracking_Feedback ADD FeedbackAgainstAssignmentID bigint NULL;
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_Feedback')
      AND name='IX_OLTracking_Feedback_AgainstAssignment'
)
    CREATE INDEX IX_OLTracking_Feedback_AgainstAssignment
        ON dbo.OLTracking_Feedback(AssignmentID,FeedbackAgainstAssignmentID,IsDeleted);
GO

IF OBJECT_ID('dbo.OLTracking_RemoveProcessFlow','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_RemoveProcessFlow AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_RemoveProcessFlow
    @ProjectID int,
    @ProcessID int,
    @UserID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @Affected int;
    BEGIN TRANSACTION;
    UPDATE dbo.OLTracking_ProcessFlow
       SET IsActive=0,UpdatedBy=@UserID,UpdatedDate=GETDATE()
     WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1;
    SET @Affected=@@ROWCOUNT;
    DELETE dbo.OLTracking_ProcessDependency
     WHERE ProjectID=@ProjectID AND (ProcessID=@ProcessID OR PredecessorProcessID=@ProcessID);
    DELETE dbo.OLTracking_ProcessFeedbackTarget
     WHERE ProjectID=@ProjectID AND (ProcessID=@ProcessID OR TargetProcessID=@ProcessID);
    COMMIT;
    SELECT @Affected AffectedRows;
END;
GO
