/* Productivity Type no longer requires Expected Completion Time.
   Safe to rerun. Deploy after OLTracking_018. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.OLTracking_SaveDealProcessFlow','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_SaveDealProcessFlow AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_SaveDealProcessFlow
    @ProjectID int,@DealNumber nvarchar(150),@ProcessID int,@ProcessName nvarchar(200),@StageNo int,
    @IsMandatory bit,@FeedbackRequiredOnComplete bit,@IsFinalProcess bit,@ProductivityType nvarchar(40),
    @ExpectedCompletionMinutes int,@UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    IF @ProductivityType NOT IN(N'Hourly Productivity',N'Loan Based Productivity')
        THROW 50139,'Invalid productivity type.',1;
    SET @ExpectedCompletionMinutes=NULL;
    BEGIN TRANSACTION;
    IF @IsFinalProcess=1
        UPDATE dbo.OLTracking_DealProcessFlow
           SET IsFinalProcess=0,UpdatedBy=@UserID,UpdatedDate=GETDATE()
         WHERE ProjectID=@ProjectID AND DealNumber=@DealNumber AND ProcessID<>@ProcessID AND IsActive=1;
    MERGE dbo.OLTracking_DealProcessFlow AS target
    USING(SELECT @ProjectID ProjectID,@DealNumber DealNumber,@ProcessID ProcessID) AS source
       ON target.ProjectID=source.ProjectID AND target.DealNumber=source.DealNumber AND target.ProcessID=source.ProcessID
    WHEN MATCHED THEN UPDATE SET ProcessName=@ProcessName,StageNo=@StageNo,IsMandatory=@IsMandatory,
         FeedbackRequiredOnComplete=@FeedbackRequiredOnComplete,IsFinalProcess=@IsFinalProcess,
         ProductivityType=@ProductivityType,ExpectedCompletionMinutes=NULL,IsActive=1,
         UpdatedBy=@UserID,UpdatedDate=GETDATE()
    WHEN NOT MATCHED THEN
         INSERT(ProjectID,DealNumber,ProcessID,ProcessName,StageNo,IsMandatory,FeedbackRequiredOnComplete,
                IsFinalProcess,ProductivityType,ExpectedCompletionMinutes,IsActive,AddedBy)
         VALUES(@ProjectID,@DealNumber,@ProcessID,@ProcessName,@StageNo,@IsMandatory,@FeedbackRequiredOnComplete,
                @IsFinalProcess,@ProductivityType,NULL,1,@UserID);
    COMMIT;
END;
GO
