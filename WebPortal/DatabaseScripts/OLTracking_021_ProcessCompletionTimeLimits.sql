/* Optional process completion-time limits and overdue acknowledgement.
   Safe to rerun. Deploy after OLTracking_020. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF COL_LENGTH('dbo.OLTracking_ProcessFlow','MinCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD MinCompletionMinutes int NULL;
IF COL_LENGTH('dbo.OLTracking_ProcessFlow','MaxCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD MaxCompletionMinutes int NULL;
IF COL_LENGTH('dbo.OLTracking_DealProcessFlow','MinCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_DealProcessFlow ADD MinCompletionMinutes int NULL;
IF COL_LENGTH('dbo.OLTracking_DealProcessFlow','MaxCompletionMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_DealProcessFlow ADD MaxCompletionMinutes int NULL;
IF COL_LENGTH('dbo.OLTracking_Assignment','MaxTimeAcknowledgedDate') IS NULL
    ALTER TABLE dbo.OLTracking_Assignment ADD MaxTimeAcknowledgedDate datetime NULL;
GO

IF OBJECT_ID('dbo.CK_OLTracking_ProcessFlow_CompletionMinutes','C') IS NULL
    ALTER TABLE dbo.OLTracking_ProcessFlow ADD CONSTRAINT CK_OLTracking_ProcessFlow_CompletionMinutes CHECK
    ((MinCompletionMinutes IS NULL OR MinCompletionMinutes>=0) AND (MaxCompletionMinutes IS NULL OR MaxCompletionMinutes>=0)
     AND (MinCompletionMinutes IS NULL OR MaxCompletionMinutes IS NULL OR MaxCompletionMinutes>=MinCompletionMinutes));
IF OBJECT_ID('dbo.CK_OLTracking_DealFlow_CompletionMinutes','C') IS NULL
    ALTER TABLE dbo.OLTracking_DealProcessFlow ADD CONSTRAINT CK_OLTracking_DealFlow_CompletionMinutes CHECK
    ((MinCompletionMinutes IS NULL OR MinCompletionMinutes>=0) AND (MaxCompletionMinutes IS NULL OR MaxCompletionMinutes>=0)
     AND (MinCompletionMinutes IS NULL OR MaxCompletionMinutes IS NULL OR MaxCompletionMinutes>=MinCompletionMinutes));
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
    WHERE d.ProjectID=@ProjectID AND d.DealNumber=@DealNumber AND d.IsActive=1
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
           ISNULL(ExpectedCompletionMinutes,0) ExpectedCompletionMinutes,MinCompletionMinutes,MaxCompletionMinutes,IsActive
    FROM dbo.OLTracking_DealProcessFlow
    WHERE ProjectID=@ProjectID AND DealNumber=@DealNumber AND IsActive=1
    ORDER BY StageNo,ProcessName;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetManagerDetail','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetManagerDetail AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetManagerDetail
    @ProjectID int,@DealNumber nvarchar(150)=NULL,@ProcessID int=0,@UserID int=0,
    @Status varchar(20)=NULL,@FromDate date=NULL,@ToDate date=NULL,@ProductivityType nvarchar(40)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @FromDate=ISNULL(@FromDate,DATEADD(day,-30,CONVERT(date,GETDATE())));
    SET @ToDate=ISNULL(@ToDate,CONVERT(date,GETDATE()));
    ;WITH Detail AS
    (
        SELECT a.AssignmentID,a.ProjectID,p.ProjectName,a.ProcessID,flow.ProcessName,a.UserID,
            COALESCE(NULLIF(ec.PsuedoName,''),NULLIF(ec.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),a.UserID)) UserName,
            i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber,a.AssignmentStatus,a.AssignedDate,a.StartedDate,a.CompletedDate,a.LastRemark,a.ManualDurationMinutes,
            ISNULL(flow.ProductivityType,N'Loan Based Productivity') ProductivityType,ISNULL(flow.ExpectedCompletionMinutes,0) ExpectedCompletionMinutes,
            flow.MinCompletionMinutes,flow.MaxCompletionMinutes,
            ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldTATSeconds,
            CASE WHEN a.TotalTATSeconds IS NOT NULL THEN a.TotalTATSeconds ELSE
              CASE WHEN DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END)<0 THEN 0
                   ELSE DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END) END END TotalTATSeconds,
            CASE WHEN a.StartedDate IS NULL THEN NULL ELSE CONVERT(int,(CASE WHEN DATEDIFF(second,a.StartedDate,ISNULL(a.CompletedDate,CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN a.HoldDate ELSE GETDATE() END))-ISNULL(a.HoldTATSeconds,0)<0 THEN 0 ELSE DATEDIFF(second,a.StartedDate,ISNULL(a.CompletedDate,CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN a.HoldDate ELSE GETDATE() END))-ISNULL(a.HoldTATSeconds,0) END)/60) END ActualProcessingMinutes,
            CASE WHEN feedback.FeedbackCount>0 THEN 'Feedback Added' ELSE 'No Feedback' END FeedbackStatus
        FROM dbo.OLTracking_Assignment a
        INNER JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
        CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(a.ProjectID,i.DealNumber) flow
        INNER JOIN dbo.Project p ON p.ProjectID=a.ProjectID
        LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.UserID
        OUTER APPLY(SELECT TOP 1 c.Code,c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE c.EmployeeID=a.UserID AND c.IsDelete=0 ORDER BY c.EmpConfigrationID DESC) ec
        OUTER APPLY(SELECT COUNT(1) FeedbackCount FROM dbo.OLTracking_Feedback f WHERE f.AssignmentID=a.AssignmentID AND ISNULL(f.IsDeleted,0)=0) feedback
        WHERE flow.ProcessID=a.ProcessID AND a.ProjectID=@ProjectID
          AND (NULLIF(@DealNumber,'') IS NULL OR i.DealNumber=@DealNumber)
          AND (@ProcessID=0 OR a.ProcessID=@ProcessID) AND (@UserID=0 OR a.UserID=@UserID)
          AND (NULLIF(@Status,'') IS NULL OR a.AssignmentStatus=@Status)
          AND (NULLIF(@ProductivityType,'') IS NULL OR flow.ProductivityType=@ProductivityType)
          AND ISNULL(a.CompletedDate,a.AssignedDate)>=@FromDate AND ISNULL(a.CompletedDate,a.AssignedDate)<DATEADD(day,1,@ToDate)
        UNION ALL
        SELECT -h.HourlyEntryID,h.ProjectID,p.ProjectName,h.ProcessID,flow.ProcessName,h.UserID,
            COALESCE(NULLIF(ec.PsuedoName,''),NULLIF(ec.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),h.UserID)),
            N'',h.DealNumber,'Completed',h.EntryDate,NULL,NULL,N'Hourly productivity submitted',h.DurationMinutes,
            N'Hourly Productivity',0,NULL,NULL,0,CONVERT(bigint,h.DurationMinutes)*60,h.DurationMinutes,N'No Feedback'
        FROM dbo.OLTracking_HourlyProductivityEntry h
        CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(h.ProjectID,h.DealNumber) flow
        INNER JOIN dbo.Project p ON p.ProjectID=h.ProjectID
        LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=h.UserID
        OUTER APPLY(SELECT TOP 1 c.Code,c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE c.EmployeeID=h.UserID AND c.IsDelete=0 ORDER BY c.EmpConfigrationID DESC) ec
        WHERE flow.ProcessID=h.ProcessID AND h.ProjectID=@ProjectID
          AND (NULLIF(@DealNumber,'') IS NULL OR h.DealNumber=@DealNumber)
          AND (@ProcessID=0 OR h.ProcessID=@ProcessID) AND (@UserID=0 OR h.UserID=@UserID)
          AND (NULLIF(@Status,'') IS NULL OR @Status='Completed')
          AND (NULLIF(@ProductivityType,'') IS NULL OR @ProductivityType=N'Hourly Productivity')
          AND h.EntryDate>=@FromDate AND h.EntryDate<DATEADD(day,1,@ToDate)
    )
    SELECT *,CASE WHEN ProductivityType=N'Hourly Productivity' THEN N'Hourly' ELSE N'Loan based' END TargetDisplay,
       CONVERT(decimal(10,2),CASE WHEN ProductivityType=N'Hourly Productivity' AND TotalTATSeconds>0 AND ExpectedCompletionMinutes>0 THEN ExpectedCompletionMinutes*60.0/TotalTATSeconds*100
            WHEN ProductivityType=N'Loan Based Productivity' AND AssignmentStatus='Completed' THEN 100 ELSE 0 END) ProductivityPercent,
       CASE WHEN MinCompletionMinutes IS NULL AND MaxCompletionMinutes IS NULL THEN N'Not Configured'
            WHEN ActualProcessingMinutes IS NULL THEN N'Not Started'
            WHEN MinCompletionMinutes IS NOT NULL AND ActualProcessingMinutes<MinCompletionMinutes THEN N'Below Minimum'
            WHEN MaxCompletionMinutes IS NOT NULL AND ActualProcessingMinutes>=MaxCompletionMinutes THEN N'Max Exceeded'
            ELSE N'Within Limit' END CompletionTimeStatus
    FROM Detail ORDER BY ISNULL(CompletedDate,AssignedDate) DESC;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetManagerSummary','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetManagerSummary AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetManagerSummary
    @ProjectID int,@DealNumber nvarchar(150)=NULL,@ProcessID int=0,@UserID int=0,
    @FromDate date=NULL,@ToDate date=NULL,@ProductivityType nvarchar(40)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Detail TABLE
    (
        AssignmentID bigint,ProjectID int,ProjectName nvarchar(200),ProcessID int,ProcessName nvarchar(200),UserID int,UserName nvarchar(200),LoanNumber nvarchar(200),DealNumber nvarchar(150),AssignmentStatus varchar(20),AssignedDate datetime,StartedDate datetime,CompletedDate datetime,LastRemark nvarchar(1000),ManualDurationMinutes int,ProductivityType nvarchar(40),ExpectedCompletionMinutes int,MinCompletionMinutes int,MaxCompletionMinutes int,HoldTATSeconds bigint,TotalTATSeconds bigint,ActualProcessingMinutes int,FeedbackStatus nvarchar(50),TargetDisplay nvarchar(50),ProductivityPercent decimal(10,2),CompletionTimeStatus nvarchar(30)
    );
    INSERT @Detail EXEC dbo.OLTracking_GetManagerDetail @ProjectID,@DealNumber,@ProcessID,@UserID,NULL,@FromDate,@ToDate,@ProductivityType;
    SELECT ProjectName,ProcessName,UserID,UserName,COUNT(1) TotalOrders,
      SUM(CASE WHEN AssignmentStatus='Pending' THEN 1 ELSE 0 END) PendingOrders,
      SUM(CASE WHEN AssignmentStatus='In Process' THEN 1 ELSE 0 END) InProcessOrders,
      SUM(CASE WHEN AssignmentStatus='Hold' THEN 1 ELSE 0 END) HoldOrders,
      SUM(CASE WHEN AssignmentStatus='Completed' THEN 1 ELSE 0 END) CompletedOrders,
      CONVERT(bigint,AVG(CONVERT(decimal(18,2),TotalTATSeconds))) AverageTATSeconds,SUM(HoldTATSeconds) TotalHoldTATSeconds
    FROM @Detail GROUP BY ProjectName,ProcessName,UserID,UserName ORDER BY ProjectName,ProcessName,UserName;
END;
GO

IF OBJECT_ID('dbo.OLTracking_SaveDealProcessFlow','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_SaveDealProcessFlow AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_SaveDealProcessFlow
    @ProjectID int,@DealNumber nvarchar(150),@ProcessID int,@ProcessName nvarchar(200),@StageNo int,
    @IsMandatory bit,@FeedbackRequiredOnComplete bit,@IsFinalProcess bit,@ProductivityType nvarchar(40),
    @ExpectedCompletionMinutes int,@UserID int,@MinCompletionMinutes int=NULL,@MaxCompletionMinutes int=NULL
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    IF @ProductivityType NOT IN(N'Hourly Productivity',N'Loan Based Productivity') THROW 50139,'Invalid productivity type.',1;
    IF @MinCompletionMinutes<0 OR @MaxCompletionMinutes<0 THROW 50151,'Completion minutes must be zero or greater.',1;
    IF @MinCompletionMinutes IS NOT NULL AND @MaxCompletionMinutes IS NOT NULL AND @MaxCompletionMinutes<@MinCompletionMinutes
        THROW 50152,'Maximum completion time cannot be less than the minimum completion time.',1;
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
         MaxCompletionMinutes=@MaxCompletionMinutes,IsActive=1,UpdatedBy=@UserID,UpdatedDate=GETDATE()
    WHEN NOT MATCHED THEN INSERT(ProjectID,DealNumber,ProcessID,ProcessName,StageNo,IsMandatory,FeedbackRequiredOnComplete,
         IsFinalProcess,ProductivityType,ExpectedCompletionMinutes,MinCompletionMinutes,MaxCompletionMinutes,IsActive,AddedBy)
         VALUES(@ProjectID,@DealNumber,@ProcessID,@ProcessName,@StageNo,@IsMandatory,@FeedbackRequiredOnComplete,
         @IsFinalProcess,@ProductivityType,NULL,@MinCompletionMinutes,@MaxCompletionMinutes,1,@UserID);
    COMMIT;
END;
GO
