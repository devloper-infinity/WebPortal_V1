                /* Detailed operational dashboard dataset with deal and productivity filters. */
SET NOCOUNT ON;
GO

IF COL_LENGTH('dbo.OLTracking_Assignment','ManualDurationMinutes') IS NULL
    ALTER TABLE dbo.OLTracking_Assignment ADD ManualDurationMinutes int NULL;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_GetManagerDetail
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
    )
    SELECT *,
       CASE WHEN ProductivityType=N'Hourly Productivity' THEN N'Hourly'
            ELSE N'Loan based' END TargetDisplay,
       CONVERT(decimal(10,2),CASE WHEN ProductivityType=N'Hourly Productivity' AND TotalTATSeconds>0 AND ExpectedCompletionMinutes>0 THEN ExpectedCompletionMinutes*60.0/TotalTATSeconds*100
            WHEN ProductivityType=N'Loan Based Productivity' AND AssignmentStatus='Completed' THEN 100 ELSE 0 END) ProductivityPercent
    FROM Detail ORDER BY ISNULL(CompletedDate,AssignedDate) DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_GetManagerSummary
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
