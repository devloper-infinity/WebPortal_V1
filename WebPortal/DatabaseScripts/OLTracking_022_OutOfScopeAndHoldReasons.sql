/* Deal-level Out of Scope processes and centrally managed Hold Reasons.
   Safe to rerun. Deploy after OLTracking_021. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF COL_LENGTH('dbo.OLTracking_DealProcessFlow','IsOutOfScope') IS NULL
    ALTER TABLE dbo.OLTracking_DealProcessFlow ADD IsOutOfScope bit NOT NULL
        CONSTRAINT DF_OLTracking_DealFlow_OutOfScope DEFAULT(0) WITH VALUES;
GO

IF OBJECT_ID('dbo.OLTracking_HoldReason','U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_HoldReason
    (
        HoldReasonID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_HoldReason PRIMARY KEY,
        ReasonText nvarchar(400) NOT NULL,
        IsActive bit NOT NULL CONSTRAINT DF_OLTracking_HoldReason_Active DEFAULT(1),
        AddedBy int NOT NULL,AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_HoldReason_Added DEFAULT(GETDATE()),
        UpdatedBy int NULL,UpdatedDate datetime NULL,
        CONSTRAINT UQ_OLTracking_HoldReason_Text UNIQUE(ReasonText)
    );
END;
GO

MERGE dbo.OLTracking_HoldReason AS target
USING
(
    SELECT N'PDF Issue' ReasonText UNION ALL
    SELECT N'Audit Worksheet Not available in Box' UNION ALL
    SELECT N'Partially Review in Scienna' UNION ALL
    SELECT N'Wrongly pulled in ERP' UNION ALL
    SELECT N'Miscellaneous - Any other issue with comments'
) source ON target.ReasonText=source.ReasonText
WHEN NOT MATCHED THEN INSERT(ReasonText,IsActive,AddedBy) VALUES(source.ReasonText,1,0);
GO

ALTER FUNCTION dbo.OLTracking_EffectiveProcessFlow(@ProjectID int,@DealNumber nvarchar(150))
RETURNS TABLE
AS RETURN
(
    SELECT d.ProcessID,d.ProcessName,d.StageNo,d.IsMandatory,
           CAST(CASE WHEN d.IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
           d.FeedbackRequiredOnComplete,d.IsFinalProcess,d.ProductivityType,d.ExpectedCompletionMinutes,
           d.MinCompletionMinutes,d.MaxCompletionMinutes
    FROM dbo.OLTracking_DealProcessFlow d
    WHERE d.ProjectID=@ProjectID AND d.DealNumber=@DealNumber AND d.IsActive=1 AND d.IsOutOfScope=0
    UNION ALL
    SELECT p.ProcessID,p.ProcessName,p.StageNo,p.IsMandatory,
           CAST(CASE WHEN p.IsMandatory=1 THEN 0 ELSE 1 END AS bit),
           p.FeedbackRequiredOnComplete,p.IsFinalProcess,p.ProductivityType,p.ExpectedCompletionMinutes,
           p.MinCompletionMinutes,p.MaxCompletionMinutes
    FROM dbo.OLTracking_ProcessFlow p
    WHERE p.ProjectID=@ProjectID AND p.IsActive=1
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_DealProcessFlow d WHERE d.ProjectID=@ProjectID AND d.DealNumber=@DealNumber AND d.IsActive=1)
);
GO

ALTER FUNCTION dbo.OLTracking_ProcessDependencyEligibility(@ProjectID int,@ProcessID int,@ItemID bigint)
RETURNS TABLE
AS RETURN
(
    SELECT
      CAST(CASE WHEN EXISTS
      (
          SELECT 1 FROM dbo.OLTracking_ProcessDependency dependency
          JOIN dbo.OLTracking_Item item ON item.ItemID=@ItemID AND item.ProjectID=@ProjectID
          CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(@ProjectID,item.DealNumber) predecessor
          WHERE dependency.ProjectID=@ProjectID AND dependency.ProcessID=@ProcessID AND dependency.IsActive=1
            AND predecessor.ProcessID=dependency.PredecessorProcessID
      ) THEN 1 ELSE 0 END AS bit) HasConfiguredDependencies,
      CAST(CASE WHEN NOT EXISTS
      (
          SELECT 1 FROM dbo.OLTracking_ProcessDependency dependency
          JOIN dbo.OLTracking_Item item ON item.ItemID=@ItemID AND item.ProjectID=@ProjectID
          CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(@ProjectID,item.DealNumber) predecessor
          WHERE dependency.ProjectID=@ProjectID AND dependency.ProcessID=@ProcessID AND dependency.IsActive=1
            AND predecessor.ProcessID=dependency.PredecessorProcessID
            AND NOT EXISTS
            (
                SELECT 1 FROM dbo.OLTracking_Assignment completed
                WHERE completed.ItemID=@ItemID AND completed.ProcessID=dependency.PredecessorProcessID
                  AND completed.AssignmentStatus='Completed'
            )
      ) THEN 1 ELSE 0 END AS bit) DependenciesSatisfied
);
GO

IF OBJECT_ID('dbo.OLTracking_GetDealProcessFlow','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetDealProcessFlow AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetDealProcessFlow @ProjectID int,@DealNumber nvarchar(150)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CONVERT(int,0) FlowID,ProjectID,DealNumber,ProcessID,ProcessName,StageNo,IsMandatory,
           CAST(CASE WHEN IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
           FeedbackRequiredOnComplete,IsFinalProcess,ProductivityType,
           ISNULL(ExpectedCompletionMinutes,0) ExpectedCompletionMinutes,MinCompletionMinutes,MaxCompletionMinutes,
           IsOutOfScope,IsActive
    FROM dbo.OLTracking_DealProcessFlow
    WHERE ProjectID=@ProjectID AND DealNumber=@DealNumber AND IsActive=1
    ORDER BY StageNo,ProcessName;
END;
GO

IF OBJECT_ID('dbo.OLTracking_SaveDealProcessFlow','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_SaveDealProcessFlow AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_SaveDealProcessFlow
    @ProjectID int,@DealNumber nvarchar(150),@ProcessID int,@ProcessName nvarchar(200),@StageNo int,
    @IsMandatory bit,@FeedbackRequiredOnComplete bit,@IsFinalProcess bit,@ProductivityType nvarchar(40),
    @ExpectedCompletionMinutes int,@UserID int,@MinCompletionMinutes int=NULL,@MaxCompletionMinutes int=NULL,
    @IsOutOfScope bit=0
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    IF @ProductivityType NOT IN(N'Hourly Productivity',N'Loan Based Productivity') THROW 50139,'Invalid productivity type.',1;
    IF @MinCompletionMinutes<0 OR @MaxCompletionMinutes<0 THROW 50151,'Completion minutes must be zero or greater.',1;
    IF @MinCompletionMinutes IS NOT NULL AND @MaxCompletionMinutes IS NOT NULL AND @MaxCompletionMinutes<@MinCompletionMinutes
        THROW 50152,'Maximum completion time cannot be less than the minimum completion time.',1;
    IF @IsOutOfScope=1 SELECT @IsMandatory=0,@FeedbackRequiredOnComplete=0,@IsFinalProcess=0;
    SET @ExpectedCompletionMinutes=NULL;
    BEGIN TRANSACTION;
    IF @IsFinalProcess=1 UPDATE dbo.OLTracking_DealProcessFlow SET IsFinalProcess=0,UpdatedBy=@UserID,UpdatedDate=GETDATE()
      WHERE ProjectID=@ProjectID AND DealNumber=@DealNumber AND ProcessID<>@ProcessID AND IsActive=1;
    MERGE dbo.OLTracking_DealProcessFlow AS target
    USING(SELECT @ProjectID ProjectID,@DealNumber DealNumber,@ProcessID ProcessID) AS source
       ON target.ProjectID=source.ProjectID AND target.DealNumber=source.DealNumber AND target.ProcessID=source.ProcessID
    WHEN MATCHED THEN UPDATE SET ProcessName=@ProcessName,StageNo=@StageNo,IsMandatory=@IsMandatory,
         FeedbackRequiredOnComplete=@FeedbackRequiredOnComplete,IsFinalProcess=@IsFinalProcess,
         ProductivityType=@ProductivityType,ExpectedCompletionMinutes=NULL,MinCompletionMinutes=@MinCompletionMinutes,
         MaxCompletionMinutes=@MaxCompletionMinutes,IsOutOfScope=@IsOutOfScope,IsActive=1,UpdatedBy=@UserID,UpdatedDate=GETDATE()
    WHEN NOT MATCHED THEN INSERT(ProjectID,DealNumber,ProcessID,ProcessName,StageNo,IsMandatory,FeedbackRequiredOnComplete,
         IsFinalProcess,ProductivityType,ExpectedCompletionMinutes,MinCompletionMinutes,MaxCompletionMinutes,IsOutOfScope,IsActive,AddedBy)
         VALUES(@ProjectID,@DealNumber,@ProcessID,@ProcessName,@StageNo,@IsMandatory,@FeedbackRequiredOnComplete,
         @IsFinalProcess,@ProductivityType,NULL,@MinCompletionMinutes,@MaxCompletionMinutes,@IsOutOfScope,1,@UserID);
    COMMIT;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetTrackingQueue','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetTrackingQueue AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetTrackingQueue @UserID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.AssignmentID,a.ProjectID,a.ProcessID,flow.ProcessName,i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber,
        a.AssignmentStatus,a.AssignedDate,a.StartedDate,a.HoldDate,a.LastRemark,flow.FeedbackRequiredOnComplete,
        CAST(CASE WHEN flow.IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
        ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldTATSeconds,
        CASE WHEN a.AssignedDate IS NULL THEN NULL ELSE
             CASE WHEN DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END)<0 THEN 0
                  ELSE DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END) END END TotalTATSeconds
    FROM dbo.OLTracking_Assignment a
    JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(a.ProjectID,i.DealNumber) flow
    WHERE a.UserID=@UserID AND a.IsCurrent=1 AND flow.ProcessID=a.ProcessID
    ORDER BY a.AssignedDate;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetUserDailyStatus','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetUserDailyStatus AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetUserDailyStatus @UserID int,@ProcessID int=0,@FromDate date=NULL,@ToDate date=NULL
AS
BEGIN
    SET NOCOUNT ON; SET @FromDate=ISNULL(@FromDate,CAST(GETDATE() AS date)); SET @ToDate=ISNULL(@ToDate,@FromDate);
    ;WITH Daily AS
    (
    SELECT a.AssignmentID,a.ProjectID,a.ProcessID,flow.ProcessName,i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber,
        a.AssignmentStatus,a.AssignedDate,a.StartedDate,a.CompletedDate,a.LastRemark,
        ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldTATSeconds,
        CASE WHEN a.TotalTATSeconds IS NOT NULL THEN a.TotalTATSeconds WHEN a.AssignedDate IS NULL THEN NULL
             ELSE CASE WHEN DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END)<0 THEN 0
                       ELSE DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END) END END TotalTATSeconds,
        a.ManualDurationMinutes,ISNULL(flow.ProductivityType,N'Loan Based Productivity') ProductivityType
    FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(a.ProjectID,i.DealNumber) flow
    WHERE flow.ProcessID=a.ProcessID AND a.UserID=@UserID AND (@ProcessID=0 OR a.ProcessID=@ProcessID)
      AND ((a.ManualDurationMinutes IS NOT NULL AND a.AssignedDate>=@FromDate AND a.AssignedDate<DATEADD(day,1,@ToDate))
        OR (a.CompletedDate>=@FromDate AND a.CompletedDate<DATEADD(day,1,@ToDate))
        OR (a.IsCurrent=1 AND a.AssignedDate<DATEADD(day,1,@ToDate)))
    UNION ALL
    SELECT -h.HourlyEntryID,h.ProjectID,h.ProcessID,flow.ProcessName,N'',h.DealNumber,
        'Completed',h.EntryDate,NULL,NULL,N'Hourly productivity submitted',0,
        CONVERT(bigint,h.DurationMinutes)*60,h.DurationMinutes,N'Hourly Productivity'
    FROM dbo.OLTracking_HourlyProductivityEntry h
    CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(h.ProjectID,h.DealNumber) flow
    WHERE flow.ProcessID=h.ProcessID AND h.UserID=@UserID AND (@ProcessID=0 OR h.ProcessID=@ProcessID)
      AND h.EntryDate>=@FromDate AND h.EntryDate<DATEADD(day,1,@ToDate)
    )
    SELECT * FROM Daily ORDER BY AssignedDate DESC;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetUserDailyProcesses','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetUserDailyProcesses AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetUserDailyProcesses @UserID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT assignment.ProcessID,flow.ProcessName
    FROM dbo.OLTracking_Assignment assignment
    JOIN dbo.OLTracking_Item item ON item.ItemID=assignment.ItemID
    CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(assignment.ProjectID,item.DealNumber) flow
    WHERE assignment.UserID=@UserID AND flow.ProcessID=assignment.ProcessID
    ORDER BY flow.ProcessName;
END;
GO

ALTER PROCEDURE dbo.OLTracking_HoldLoan @AssignmentID bigint,@HoldReason nvarchar(1000),@UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    IF NOT EXISTS(SELECT 1 FROM dbo.OLTracking_HoldReason WHERE IsActive=1 AND ReasonText=LTRIM(RTRIM(@HoldReason)))
        THROW 50126,'Please select an active Hold Reason.',1;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @Now datetime=GETDATE(),@OldStatus varchar(20),@ItemID bigint,@ProcessID int;
        SELECT @ItemID=ItemID,@ProcessID=ProcessID,@OldStatus=AssignmentStatus FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
        WHERE AssignmentID=@AssignmentID AND UserID=@UserID AND IsCurrent=1;
        IF @ItemID IS NULL THROW 50122,'Assignment was not found.',1;
        IF @OldStatus NOT IN('Pending','In Process') THROW 50127,'Only Pending or In Process loans can be placed on hold.',1;
        INSERT dbo.OLTracking_HoldPeriod(AssignmentID,HoldStartDate,HoldReason,HeldBy)
        VALUES(@AssignmentID,@Now,LTRIM(RTRIM(@HoldReason)),@UserID);
        UPDATE dbo.OLTracking_Assignment SET AssignmentStatus='Hold',HoldDate=@Now,LastRemark=LTRIM(RTRIM(@HoldReason)),
            UpdatedBy=@UserID,UpdatedDate=@Now WHERE AssignmentID=@AssignmentID;
        UPDATE dbo.OLTracking_Item SET ItemStatus='Hold',CurrentProcessID=@ProcessID,UpdatedBy=@UserID,UpdatedDate=@Now
        WHERE ItemID=@ItemID;
        INSERT dbo.OLTracking_StatusHistory(AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
        VALUES(@AssignmentID,@OldStatus,'Hold',LTRIM(RTRIM(@HoldReason)),@UserID);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH
END;
GO
