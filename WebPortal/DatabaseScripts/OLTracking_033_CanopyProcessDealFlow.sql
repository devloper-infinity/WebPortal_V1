/* Canopy Pre/Post Close deal-flow overrides. Existing project/deal flow is untouched. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.OLTracking_ProcessDealFlow','U') IS NULL
BEGIN
 CREATE TABLE dbo.OLTracking_ProcessDealFlow
 (
  ProcessDealFlowID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ProcessDealFlow PRIMARY KEY,
  ProjectID int NOT NULL,ConfigurationProcess nvarchar(40) NOT NULL,DealNumber nvarchar(150) NOT NULL,
  ProcessID int NOT NULL,ProcessName nvarchar(200) NOT NULL,StageNo int NOT NULL,IsMandatory bit NOT NULL,
  FeedbackRequiredOnComplete bit NOT NULL,IsFinalProcess bit NOT NULL,ProductivityType nvarchar(40) NOT NULL,
  ExpectedCompletionMinutes int NULL,MinCompletionMinutes int NULL,MaxCompletionMinutes int NULL,
  IsOutOfScope bit NOT NULL CONSTRAINT DF_OLTracking_ProcessDealFlow_OutOfScope DEFAULT(0),
  IsActive bit NOT NULL CONSTRAINT DF_OLTracking_ProcessDealFlow_Active DEFAULT(1),
  AddedBy int NOT NULL,AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ProcessDealFlow_Added DEFAULT(GETDATE()),
  UpdatedBy int NULL,UpdatedDate datetime NULL,
  CONSTRAINT UQ_OLTracking_ProcessDealFlow UNIQUE(ProjectID,ConfigurationProcess,DealNumber,ProcessID),
  CONSTRAINT CK_OLTracking_ProcessDealFlow_Context CHECK(ConfigurationProcess IN(N'Pre Close Review',N'Post Close Review')),
  CONSTRAINT CK_OLTracking_ProcessDealFlow_MinMax CHECK((MinCompletionMinutes IS NULL OR MinCompletionMinutes>=0) AND (MaxCompletionMinutes IS NULL OR MaxCompletionMinutes>=0) AND (MinCompletionMinutes IS NULL OR MaxCompletionMinutes IS NULL OR MaxCompletionMinutes>=MinCompletionMinutes))
 );
END;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_GetProcessDealFlow
 @ProjectID int,@ConfigurationProcess nvarchar(40),@DealNumber nvarchar(150)
AS
BEGIN
 SET NOCOUNT ON;
 SELECT ProcessDealFlowID FlowID,ProjectID,ConfigurationProcess,DealNumber,ProcessID,ProcessName,StageNo,IsMandatory,
  CAST(CASE WHEN IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,FeedbackRequiredOnComplete,IsFinalProcess,
  ProductivityType,ISNULL(ExpectedCompletionMinutes,0) ExpectedCompletionMinutes,MinCompletionMinutes,MaxCompletionMinutes,
  IsOutOfScope,IsActive
 FROM dbo.OLTracking_ProcessDealFlow
 WHERE ProjectID=@ProjectID AND ConfigurationProcess=@ConfigurationProcess AND DealNumber=@DealNumber AND IsActive=1
 ORDER BY StageNo,ProcessName;
END;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_SaveProcessDealFlow
 @ProjectID int,@ConfigurationProcess nvarchar(40),@DealNumber nvarchar(150),@ProcessID int,@ProcessName nvarchar(200),@StageNo int,
 @IsMandatory bit,@FeedbackRequiredOnComplete bit,@IsFinalProcess bit,@ProductivityType nvarchar(40),@ExpectedCompletionMinutes int,
 @UserID int,@MinCompletionMinutes int=NULL,@MaxCompletionMinutes int=NULL,@IsOutOfScope bit=0
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 IF NOT EXISTS(SELECT 1 FROM dbo.Project WHERE ProjectID=@ProjectID AND SubdomainID=99) THROW 50170,'Only Canopy projects are allowed.',1;
 IF @ConfigurationProcess NOT IN(N'Pre Close Review',N'Post Close Review') THROW 50171,'Invalid configuration process.',1;
 IF @ProductivityType NOT IN(N'Hourly Productivity',N'Loan Based Productivity') THROW 50139,'Invalid productivity type.',1;
 IF @StageNo<1 OR @MinCompletionMinutes<0 OR @MaxCompletionMinutes<0 OR (@MinCompletionMinutes IS NOT NULL AND @MaxCompletionMinutes IS NOT NULL AND @MaxCompletionMinutes<@MinCompletionMinutes) THROW 50152,'Invalid sequence or completion limits.',1;
 IF @IsOutOfScope=1 SELECT @IsMandatory=0,@FeedbackRequiredOnComplete=0,@IsFinalProcess=0;
 BEGIN TRANSACTION;
 IF @IsFinalProcess=1 UPDATE dbo.OLTracking_ProcessDealFlow SET IsFinalProcess=0,UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE ProjectID=@ProjectID AND ConfigurationProcess=@ConfigurationProcess AND DealNumber=@DealNumber AND ProcessID<>@ProcessID AND IsActive=1;
 MERGE dbo.OLTracking_ProcessDealFlow WITH(HOLDLOCK) target
 USING(SELECT @ProjectID ProjectID,@ConfigurationProcess ConfigurationProcess,@DealNumber DealNumber,@ProcessID ProcessID) source
 ON target.ProjectID=source.ProjectID AND target.ConfigurationProcess=source.ConfigurationProcess AND target.DealNumber=source.DealNumber AND target.ProcessID=source.ProcessID
 WHEN MATCHED THEN UPDATE SET ProcessName=@ProcessName,StageNo=@StageNo,IsMandatory=@IsMandatory,FeedbackRequiredOnComplete=@FeedbackRequiredOnComplete,IsFinalProcess=@IsFinalProcess,ProductivityType=@ProductivityType,ExpectedCompletionMinutes=NULL,MinCompletionMinutes=@MinCompletionMinutes,MaxCompletionMinutes=@MaxCompletionMinutes,IsOutOfScope=@IsOutOfScope,IsActive=1,UpdatedBy=@UserID,UpdatedDate=GETDATE()
 WHEN NOT MATCHED THEN INSERT(ProjectID,ConfigurationProcess,DealNumber,ProcessID,ProcessName,StageNo,IsMandatory,FeedbackRequiredOnComplete,IsFinalProcess,ProductivityType,ExpectedCompletionMinutes,MinCompletionMinutes,MaxCompletionMinutes,IsOutOfScope,IsActive,AddedBy)
 VALUES(@ProjectID,@ConfigurationProcess,@DealNumber,@ProcessID,@ProcessName,@StageNo,@IsMandatory,@FeedbackRequiredOnComplete,@IsFinalProcess,@ProductivityType,NULL,@MinCompletionMinutes,@MaxCompletionMinutes,@IsOutOfScope,1,@UserID);
 COMMIT;
END;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_RemoveProcessDealFlow @ProjectID int,@ConfigurationProcess nvarchar(40),@DealNumber nvarchar(150),@ProcessID int,@UserID int
AS
BEGIN
 SET NOCOUNT ON;
 UPDATE dbo.OLTracking_ProcessDealFlow SET IsActive=0,UpdatedBy=@UserID,UpdatedDate=GETDATE()
 WHERE ProjectID=@ProjectID AND ConfigurationProcess=@ConfigurationProcess AND DealNumber=@DealNumber AND ProcessID=@ProcessID AND IsActive=1;
 SELECT @@ROWCOUNT;
END;
GO

/* Execution reads the same imported Tracking Sheet values used by Manager Dashboard. */
ALTER FUNCTION dbo.OLTracking_EffectiveProcessFlow(@ProjectID int,@DealNumber nvarchar(150))
RETURNS TABLE
AS RETURN
(
 WITH Context AS
 (
  SELECT CASE WHEN COUNT(DISTINCT matched.ConfigurationProcess)=1 THEN MAX(matched.ConfigurationProcess) END ConfigurationProcess
  FROM dbo.OLTracking_Item item
  CROSS APPLY
  (
    SELECT CASE
      WHEN REPLACE(REPLACE(REPLACE(LOWER(LTRIM(RTRIM(field.FieldName))),' ',''),'-',''),'_','')='process'
        AND LTRIM(RTRIM(value.FieldValue)) IN(N'Pre Close Review',N'Post Close Review') THEN LTRIM(RTRIM(value.FieldValue))
      WHEN field.IsProcessColumn=1 AND field.DataType='Process'
        AND LTRIM(RTRIM(field.FieldName)) IN(N'Pre Close Review',N'Post Close Review')
        AND NULLIF(LTRIM(RTRIM(value.FieldValue)),N'') IS NOT NULL THEN LTRIM(RTRIM(field.FieldName)) END ConfigurationProcess
    FROM dbo.OLTracking_ImportItemValue value
    JOIN dbo.WBT_ProjectTrackingFieldConfig field ON field.FieldConfigId=value.FieldConfigId AND field.IsDeleted=0
    WHERE value.ItemID=item.ItemID
  ) matched
  WHERE item.ProjectID=@ProjectID AND item.DealNumber=@DealNumber AND item.IsDeleted=0 AND matched.ConfigurationProcess IS NOT NULL
 ), ContextRows AS
 (
  SELECT flow.* FROM dbo.OLTracking_ProcessDealFlow flow CROSS JOIN Context
  WHERE flow.ProjectID=@ProjectID AND flow.DealNumber=N'' AND flow.ConfigurationProcess=Context.ConfigurationProcess AND flow.IsActive=1
 )
 SELECT source.ProcessID,source.ProcessName,source.StageNo,source.IsMandatory,CAST(CASE WHEN source.IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,source.FeedbackRequiredOnComplete,source.IsFinalProcess,source.ProductivityType,source.ExpectedCompletionMinutes,source.MinCompletionMinutes,source.MaxCompletionMinutes
 FROM ContextRows source WHERE source.IsOutOfScope=0
 UNION ALL
 SELECT deal.ProcessID,deal.ProcessName,deal.StageNo,deal.IsMandatory,CAST(CASE WHEN deal.IsMandatory=1 THEN 0 ELSE 1 END AS bit),deal.FeedbackRequiredOnComplete,deal.IsFinalProcess,deal.ProductivityType,deal.ExpectedCompletionMinutes,deal.MinCompletionMinutes,deal.MaxCompletionMinutes
 FROM dbo.OLTracking_DealProcessFlow deal WHERE deal.ProjectID=@ProjectID AND deal.DealNumber=@DealNumber AND deal.IsActive=1 AND deal.IsOutOfScope=0
   AND NOT EXISTS(SELECT 1 FROM ContextRows contextFlow WHERE contextFlow.ProcessID=deal.ProcessID)
 UNION ALL
 SELECT project.ProcessID,project.ProcessName,project.StageNo,project.IsMandatory,CAST(CASE WHEN project.IsMandatory=1 THEN 0 ELSE 1 END AS bit),project.FeedbackRequiredOnComplete,project.IsFinalProcess,project.ProductivityType,project.ExpectedCompletionMinutes,project.MinCompletionMinutes,project.MaxCompletionMinutes
 FROM dbo.OLTracking_ProcessFlow project WHERE project.ProjectID=@ProjectID AND project.IsActive=1
   AND NOT EXISTS(SELECT 1 FROM ContextRows contextFlow WHERE contextFlow.ProcessID=project.ProcessID)
   AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_DealProcessFlow deal WHERE deal.ProjectID=@ProjectID AND deal.DealNumber=@DealNumber AND deal.IsActive=1)
);
GO
