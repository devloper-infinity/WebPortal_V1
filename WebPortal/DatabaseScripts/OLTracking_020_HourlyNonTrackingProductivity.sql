/* Manual duration entry for non-Tracking-Sheet hourly processes. Safe to rerun. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF COL_LENGTH('dbo.OLTracking_Assignment','ManualDurationMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_Assignment ADD ManualDurationMinutes int NULL;
GO

IF OBJECT_ID('dbo.OLTracking_HourlyProductivityEntry','U') IS NULL
CREATE TABLE dbo.OLTracking_HourlyProductivityEntry
(
    HourlyEntryID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_HourlyProductivityEntry PRIMARY KEY,
    ProjectID int NOT NULL,DealNumber nvarchar(150) NOT NULL,ProcessID int NOT NULL,UserID int NOT NULL,
    DurationMinutes int NOT NULL,EntryDate datetime NOT NULL CONSTRAINT DF_OLTracking_HourlyProductivityEntry_Date DEFAULT(GETDATE()),
    AddedBy int NOT NULL,
    CONSTRAINT CK_OLTracking_HourlyProductivityEntry_Duration CHECK(DurationMinutes BETWEEN 1 AND 1440)
);
GO

IF OBJECT_ID('dbo.OLTracking_SubmitHourlyProductivity','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_SubmitHourlyProductivity AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_SubmitHourlyProductivity
    @ProjectID int,@ProcessID int,@DealNumber nvarchar(150),@DurationMinutes int,@UserID int
AS
BEGIN
    SET NOCOUNT ON;
    SET @DealNumber=LTRIM(RTRIM(ISNULL(@DealNumber,'')));
    IF @ProjectID<=0 OR @ProcessID<=0 OR @DealNumber='' THROW 50100,'Project, Deal and Process are required.',1;
    IF @DurationMinutes<1 OR @DurationMinutes>1440 THROW 50144,'Duration must be between 00:01 and 24:00.',1;
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) effective
        INNER JOIN dbo.OLTracking_ProcessFlow projectFlow ON projectFlow.ProjectID=@ProjectID
            AND projectFlow.ProcessID=effective.ProcessID AND projectFlow.IsActive=1
        WHERE effective.ProcessID=@ProcessID AND projectFlow.IsTrackingSheetProcess=0
          AND effective.ProductivityType=N'Hourly Productivity'
    ) THROW 50145,'Manual hours are available only for a non-Tracking-Sheet Hourly Productivity process.',1;

    INSERT dbo.OLTracking_HourlyProductivityEntry(ProjectID,DealNumber,ProcessID,UserID,DurationMinutes,AddedBy)
    VALUES(@ProjectID,@DealNumber,@ProcessID,@UserID,@DurationMinutes,@UserID);
    SELECT CONVERT(bigint,SCOPE_IDENTITY()) HourlyEntryID;
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
            ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldTATSeconds,
            CASE WHEN a.TotalTATSeconds IS NOT NULL THEN a.TotalTATSeconds ELSE
              CASE WHEN DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END)<0 THEN 0
                   ELSE DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END) END END TotalTATSeconds,
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
            N'Hourly Productivity',0,0,CONVERT(bigint,h.DurationMinutes)*60,N'No Feedback'
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
            WHEN ProductivityType=N'Loan Based Productivity' AND AssignmentStatus='Completed' THEN 100 ELSE 0 END) ProductivityPercent
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
        AssignmentID bigint,ProjectID int,ProjectName nvarchar(200),ProcessID int,ProcessName nvarchar(200),UserID int,UserName nvarchar(200),LoanNumber nvarchar(200),DealNumber nvarchar(150),AssignmentStatus varchar(20),AssignedDate datetime,StartedDate datetime,CompletedDate datetime,LastRemark nvarchar(1000),ManualDurationMinutes int,ProductivityType nvarchar(40),ExpectedCompletionMinutes int,HoldTATSeconds bigint,TotalTATSeconds bigint,FeedbackStatus nvarchar(50),TargetDisplay nvarchar(50),ProductivityPercent decimal(10,2)
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

IF OBJECT_ID('dbo.OLTracking_GetUserDailyStatus','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetUserDailyStatus AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetUserDailyStatus @UserID int,@ProcessID int=0,@FromDate date=NULL,@ToDate date=NULL
AS
BEGIN
    SET NOCOUNT ON; SET @FromDate=ISNULL(@FromDate,CAST(GETDATE() AS date)); SET @ToDate=ISNULL(@ToDate,@FromDate);
    ;WITH Daily AS
    (
    SELECT a.AssignmentID,a.ProjectID,a.ProcessID,f.ProcessName,i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber,
        a.AssignmentStatus,a.AssignedDate,a.StartedDate,a.CompletedDate,a.LastRemark,
        ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldTATSeconds,
        CASE WHEN a.TotalTATSeconds IS NOT NULL THEN a.TotalTATSeconds WHEN a.AssignedDate IS NULL THEN NULL
             ELSE CASE WHEN DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END)<0 THEN 0
                       ELSE DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END) END END TotalTATSeconds,
        a.ManualDurationMinutes,ISNULL(f.ProductivityType,N'Loan Based Productivity') ProductivityType
    FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID
    WHERE a.UserID=@UserID AND (@ProcessID=0 OR a.ProcessID=@ProcessID)
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

IF OBJECT_ID('dbo.OLTracking_GetHourlyProduction','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetHourlyProduction AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetHourlyProduction @ProjectID int,@ReportDate date,@DealNumber nvarchar(150)=NULL
AS
BEGIN
    SET NOCOUNT ON; SET @ReportDate=ISNULL(@ReportDate,CAST(GETDATE() AS date));
    DECLARE @Start datetime=DATEADD(hour,10,CAST(@ReportDate AS datetime));
    ;WITH Production AS
    (
        SELECT ISNULL(i.DealNumber,'') DealNumber,a.ProcessID,ISNULL(a.CompletedDate,a.AssignedDate) ProductionDate,
               a.ManualDurationMinutes
        FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
        WHERE a.ProjectID=@ProjectID AND a.AssignmentStatus='Completed'
          AND ISNULL(a.CompletedDate,a.AssignedDate)>=@Start AND ISNULL(a.CompletedDate,a.AssignedDate)<DATEADD(hour,24,@Start)
        UNION ALL
        SELECT h.DealNumber,h.ProcessID,h.EntryDate,h.DurationMinutes
        FROM dbo.OLTracking_HourlyProductivityEntry h
        WHERE h.ProjectID=@ProjectID AND h.EntryDate>=@Start AND h.EntryDate<DATEADD(hour,24,@Start)
    )
    SELECT ISNULL(a.DealNumber,'') DealNumber,f.ProcessID,f.ProcessName,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,0,@Start) AND a.ProductionDate<DATEADD(hour,2,@Start) THEN 1 ELSE 0 END) H10AM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,2,@Start) AND a.ProductionDate<DATEADD(hour,4,@Start) THEN 1 ELSE 0 END) H12PM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,4,@Start) AND a.ProductionDate<DATEADD(hour,6,@Start) THEN 1 ELSE 0 END) H02PM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,6,@Start) AND a.ProductionDate<DATEADD(hour,8,@Start) THEN 1 ELSE 0 END) H04PM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,8,@Start) AND a.ProductionDate<DATEADD(hour,10,@Start) THEN 1 ELSE 0 END) H06PM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,10,@Start) AND a.ProductionDate<DATEADD(hour,12,@Start) THEN 1 ELSE 0 END) H08PM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,12,@Start) AND a.ProductionDate<DATEADD(hour,14,@Start) THEN 1 ELSE 0 END) H10PM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,14,@Start) AND a.ProductionDate<DATEADD(hour,16,@Start) THEN 1 ELSE 0 END) H12AM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,16,@Start) AND a.ProductionDate<DATEADD(hour,18,@Start) THEN 1 ELSE 0 END) H02AM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,18,@Start) AND a.ProductionDate<DATEADD(hour,20,@Start) THEN 1 ELSE 0 END) H04AM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,20,@Start) AND a.ProductionDate<DATEADD(hour,22,@Start) THEN 1 ELSE 0 END) H06AM,
      SUM(CASE WHEN a.ProductionDate>=DATEADD(hour,22,@Start) AND a.ProductionDate<DATEADD(hour,24,@Start) THEN 1 ELSE 0 END) H08AM,
      COUNT(1) TotalCompleted,SUM(ISNULL(a.ManualDurationMinutes,0)) TotalDurationMinutes
    FROM Production a JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=@ProjectID AND f.ProcessID=a.ProcessID
    WHERE NULLIF(@DealNumber,'') IS NULL OR a.DealNumber=@DealNumber
    GROUP BY a.DealNumber,f.ProcessID,f.ProcessName ORDER BY a.DealNumber,f.ProcessName;
END;
GO
