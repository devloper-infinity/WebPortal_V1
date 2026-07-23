/* Persist one active final process per project. Safe to run repeatedly. */
IF COL_LENGTH('dbo.OLTracking_ProcessFlow','IsFinalProcess') IS NULL
BEGIN
    ALTER TABLE dbo.OLTracking_ProcessFlow
        ADD IsFinalProcess bit NOT NULL
            CONSTRAINT DF_OLTracking_ProcessFlow_Final DEFAULT(0) WITH VALUES;
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_ProcessFlow')
      AND name='UX_OLTracking_ProcessFlow_Final'
)
BEGIN
    CREATE UNIQUE INDEX UX_OLTracking_ProcessFlow_Final
        ON dbo.OLTracking_ProcessFlow(ProjectID)
        WHERE IsFinalProcess=1 AND IsActive=1;
END;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_GetProcessFlow
    @ProjectID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT FlowID,ProjectID,ProcessID,ProcessName,StageNo,IsMandatory,
           CAST(CASE WHEN IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
           FeedbackRequiredOnComplete,IsFinalProcess,IsActive
    FROM dbo.OLTracking_ProcessFlow
    WHERE ProjectID=@ProjectID AND IsActive=1
    ORDER BY StageNo,ProcessName;
END;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_SaveProcessFlow
    @ProjectID int,
    @ProcessID int,
    @ProcessName nvarchar(200),
    @StageNo int,
    @IsMandatory bit,
    @FeedbackRequiredOnComplete bit,
    @UserID int,
    @IsFinalProcess bit=0
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @ProjectID<=0 OR @ProcessID<=0 THROW 50100,'Project and process are required.',1;
    IF @StageNo<=0 THROW 50101,'Sequence must be greater than zero.',1;
    IF NULLIF(LTRIM(RTRIM(@ProcessName)),'') IS NULL THROW 50102,'Process name is required.',1;

    BEGIN TRANSACTION;
    IF @IsFinalProcess=1
        UPDATE dbo.OLTracking_ProcessFlow
           SET IsFinalProcess=0,UpdatedBy=@UserID,UpdatedDate=GETDATE()
         WHERE ProjectID=@ProjectID AND ProcessID<>@ProcessID AND IsActive=1 AND IsFinalProcess=1;

    MERGE dbo.OLTracking_ProcessFlow AS T
    USING(SELECT @ProjectID ProjectID,@ProcessID ProcessID) S
       ON T.ProjectID=S.ProjectID AND T.ProcessID=S.ProcessID
    WHEN MATCHED THEN
        UPDATE SET ProcessName=LTRIM(RTRIM(@ProcessName)),StageNo=@StageNo,IsMandatory=@IsMandatory,
                   FeedbackRequiredOnComplete=@FeedbackRequiredOnComplete,IsFinalProcess=@IsFinalProcess,
                   IsActive=1,UpdatedBy=@UserID,UpdatedDate=GETDATE()
    WHEN NOT MATCHED THEN
        INSERT(ProjectID,ProcessID,ProcessName,StageNo,IsMandatory,FeedbackRequiredOnComplete,IsFinalProcess,AddedBy)
        VALUES(@ProjectID,@ProcessID,LTRIM(RTRIM(@ProcessName)),@StageNo,@IsMandatory,
               @FeedbackRequiredOnComplete,@IsFinalProcess,@UserID);
    COMMIT TRANSACTION;
END;
GO
