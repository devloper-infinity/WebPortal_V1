/* Productivity configuration and Collection Comments ReQC feedback support.
   Safe to rerun. Deploy to the InfinityERP database. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF COL_LENGTH('dbo.OLTracking_ProcessFlow','ProductivityType') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD ProductivityType nvarchar(40) NOT NULL
        CONSTRAINT DF_OLTracking_ProcessFlow_Productivity DEFAULT(N'Loan Based Productivity') WITH VALUES;
IF COL_LENGTH('dbo.OLTracking_ProcessFlow','ExpectedCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD ExpectedCompletionMinutes int NULL;
GO

IF OBJECT_ID('dbo.OLTracking_DealProcessFlow','U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_DealProcessFlow
    (
        DealFlowID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_DealProcessFlow PRIMARY KEY,
        ProjectID int NOT NULL, DealNumber nvarchar(150) NOT NULL, ProcessID int NOT NULL,
        ProcessName nvarchar(200) NOT NULL, StageNo int NOT NULL, IsMandatory bit NOT NULL,
        FeedbackRequiredOnComplete bit NOT NULL CONSTRAINT DF_OLTracking_DealFlow_Feedback DEFAULT(0),
        IsFinalProcess bit NOT NULL CONSTRAINT DF_OLTracking_DealFlow_Final DEFAULT(0), IsActive bit NOT NULL CONSTRAINT DF_OLTracking_DealFlow_Active DEFAULT(1),
        AddedBy int NOT NULL, AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_DealFlow_Added DEFAULT(GETDATE()), UpdatedBy int NULL, UpdatedDate datetime NULL,
        CONSTRAINT UQ_OLTracking_DealProcessFlow UNIQUE(ProjectID,DealNumber,ProcessID)
    );
END;
IF COL_LENGTH('dbo.OLTracking_DealProcessFlow','ProductivityType') IS NULL
    ALTER TABLE dbo.OLTracking_DealProcessFlow ADD ProductivityType nvarchar(40) NOT NULL
        CONSTRAINT DF_OLTracking_DealFlow_Productivity DEFAULT(N'Loan Based Productivity') WITH VALUES;
IF COL_LENGTH('dbo.OLTracking_DealProcessFlow','ExpectedCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_DealProcessFlow ADD ExpectedCompletionMinutes int NULL;
GO

CREATE OR ALTER FUNCTION dbo.OLTracking_EffectiveProcessFlow(@ProjectID int,@DealNumber nvarchar(150))
RETURNS TABLE
AS RETURN
(
    SELECT d.ProcessID,d.ProcessName,d.StageNo,d.IsMandatory,
           CAST(CASE WHEN d.IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
           d.FeedbackRequiredOnComplete,d.IsFinalProcess,d.ProductivityType,d.ExpectedCompletionMinutes
    FROM dbo.OLTracking_DealProcessFlow d
    WHERE d.ProjectID=@ProjectID AND d.DealNumber=@DealNumber AND d.IsActive=1
    UNION ALL
    SELECT p.ProcessID,p.ProcessName,p.StageNo,p.IsMandatory,
           CAST(CASE WHEN p.IsMandatory=1 THEN 0 ELSE 1 END AS bit),
           p.FeedbackRequiredOnComplete,p.IsFinalProcess,p.ProductivityType,p.ExpectedCompletionMinutes
    FROM dbo.OLTracking_ProcessFlow p
    WHERE p.ProjectID=@ProjectID AND p.IsActive=1
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_DealProcessFlow d WHERE d.ProjectID=@ProjectID AND d.DealNumber=@DealNumber AND d.IsActive=1)
);
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_GetDealProcessFlow @ProjectID int,@DealNumber nvarchar(150)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CONVERT(int,0) FlowID,ProjectID,DealNumber,ProcessID,ProcessName,StageNo,IsMandatory,
           CAST(CASE WHEN IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
           FeedbackRequiredOnComplete,IsFinalProcess,ProductivityType,ISNULL(ExpectedCompletionMinutes,0) ExpectedCompletionMinutes,IsActive
    FROM dbo.OLTracking_DealProcessFlow
    WHERE ProjectID=@ProjectID AND DealNumber=@DealNumber AND IsActive=1
    ORDER BY StageNo,ProcessName;
END;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_SaveDealProcessFlow
    @ProjectID int,@DealNumber nvarchar(150),@ProcessID int,@ProcessName nvarchar(200),@StageNo int,
    @IsMandatory bit,@FeedbackRequiredOnComplete bit,@IsFinalProcess bit,@ProductivityType nvarchar(40),
    @ExpectedCompletionMinutes int,@UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    IF @ProductivityType NOT IN(N'Hourly Productivity',N'Loan Based Productivity') THROW 50139,'Invalid productivity type.',1;
    SET @ExpectedCompletionMinutes=NULL;
    BEGIN TRANSACTION;
    IF @IsFinalProcess=1 UPDATE dbo.OLTracking_DealProcessFlow SET IsFinalProcess=0,UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE ProjectID=@ProjectID AND DealNumber=@DealNumber AND ProcessID<>@ProcessID AND IsActive=1;
    MERGE dbo.OLTracking_DealProcessFlow AS target
    USING(SELECT @ProjectID ProjectID,@DealNumber DealNumber,@ProcessID ProcessID) AS source
       ON target.ProjectID=source.ProjectID AND target.DealNumber=source.DealNumber AND target.ProcessID=source.ProcessID
    WHEN MATCHED THEN UPDATE SET ProcessName=@ProcessName,StageNo=@StageNo,IsMandatory=@IsMandatory,FeedbackRequiredOnComplete=@FeedbackRequiredOnComplete,
         IsFinalProcess=@IsFinalProcess,ProductivityType=@ProductivityType,ExpectedCompletionMinutes=@ExpectedCompletionMinutes,IsActive=1,UpdatedBy=@UserID,UpdatedDate=GETDATE()
    WHEN NOT MATCHED THEN INSERT(ProjectID,DealNumber,ProcessID,ProcessName,StageNo,IsMandatory,FeedbackRequiredOnComplete,IsFinalProcess,ProductivityType,ExpectedCompletionMinutes,IsActive,AddedBy)
         VALUES(@ProjectID,@DealNumber,@ProcessID,@ProcessName,@StageNo,@IsMandatory,@FeedbackRequiredOnComplete,@IsFinalProcess,@ProductivityType,@ExpectedCompletionMinutes,1,@UserID);
    COMMIT;
END;
GO

IF OBJECT_ID('dbo.CollectionCommentsReQCDataField','U') IS NULL
BEGIN
    CREATE TABLE dbo.CollectionCommentsReQCDataField
    (
        DataFieldID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_CollectionCommentsReQCDataField PRIMARY KEY,
        DataField nvarchar(200) NOT NULL CONSTRAINT UQ_CollectionCommentsReQCDataField UNIQUE,
        SortOrder int NOT NULL CONSTRAINT DF_CollectionCommentsReQCDataField_Sort DEFAULT(0),
        IsActive bit NOT NULL CONSTRAINT DF_CollectionCommentsReQCDataField_Active DEFAULT(1),
        AddedDate datetime NOT NULL CONSTRAINT DF_CollectionCommentsReQCDataField_Added DEFAULT(GETDATE())
    );
END;
IF NOT EXISTS(SELECT 1 FROM dbo.CollectionCommentsReQCDataField WHERE DataField=N'No Error')
    INSERT dbo.CollectionCommentsReQCDataField(DataField,SortOrder) VALUES(N'No Error',2147483647);
GO

IF COL_LENGTH('dbo.ImportedFeedbacks_Servicing','DataField') IS NULL
    ALTER TABLE dbo.ImportedFeedbacks_Servicing ADD DataField nvarchar(200) NULL;
IF COL_LENGTH('dbo.ImportedFeedbacks_Servicing','IsError') IS NULL
    ALTER TABLE dbo.ImportedFeedbacks_Servicing ADD IsError nvarchar(3) NULL;
GO

INSERT dbo.CollectionCommentsReQCDataField(DataField,SortOrder)
SELECT DISTINCT LTRIM(RTRIM(existing.DataField)),100
FROM dbo.ImportedFeedbacks_Servicing existing
WHERE existing.Source=N'Collection Comments ReQC' AND NULLIF(LTRIM(RTRIM(existing.DataField)),'') IS NOT NULL
  AND NOT EXISTS(SELECT 1 FROM dbo.CollectionCommentsReQCDataField configured WHERE configured.DataField=LTRIM(RTRIM(existing.DataField)));
GO

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.ImportedFeedbacks_Servicing') AND name='IX_ImportedFeedbacks_Servicing_CollectionComments')
    CREATE INDEX IX_ImportedFeedbacks_Servicing_CollectionComments ON dbo.ImportedFeedbacks_Servicing(Source,AddedBy,AddedDate)
    INCLUDE([Loan Number],Client,DataField,IsError,Finding,[Finding Status]);
GO
