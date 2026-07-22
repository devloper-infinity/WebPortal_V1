/* Manager deal/hourly tabs and audited order reallocation. Safe to run repeatedly. */
IF OBJECT_ID('dbo.OLTracking_ReallocationHistory','U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ReallocationHistory
    (
        ReallocationID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ReallocationHistory PRIMARY KEY,
        AssignmentID bigint NOT NULL,
        FromUserID int NOT NULL,
        ToUserID int NOT NULL,
        AssignmentStatus varchar(20) NOT NULL,
        Remark nvarchar(1000) NOT NULL,
        ReallocatedBy int NOT NULL,
        ReallocatedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ReallocationHistory_Date DEFAULT(GETDATE()),
        CONSTRAINT FK_OLTracking_ReallocationHistory_Assignment FOREIGN KEY(AssignmentID) REFERENCES dbo.OLTracking_Assignment(AssignmentID)
    );
    CREATE INDEX IX_OLTracking_ReallocationHistory_Assignment ON dbo.OLTracking_ReallocationHistory(AssignmentID,ReallocatedDate);
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetDealDashboard','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_GetDealDashboard AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetDealDashboard @ProjectID int,@DealNumber nvarchar(150)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.ProjectName,ISNULL(i.DealNumber,'') DealNumber,f.ProcessID,f.ProcessName,
        COUNT(DISTINCT i.ItemID) DealCount,MIN(i.AddedDate) ReceivedDate,CAST(NULL AS datetime) DueDate,
        SUM(CASE WHEN a.AssignmentStatus='Pending' THEN 1 ELSE 0 END) PendingOrders,
        SUM(CASE WHEN a.AssignmentStatus='Completed' THEN 1 ELSE 0 END) CompletedOrders,
        SUM(CASE WHEN a.AssignmentStatus='Hold' THEN 1 ELSE 0 END) HoldOrders,
        SUM(CASE WHEN a.AssignmentStatus='Skipped' THEN 1 ELSE 0 END) SkippedOrders,
        SUM(CASE WHEN a.AssignmentStatus='In Process' AND CAST(ISNULL(a.StartedDate,a.AssignedDate) AS date)=CAST(GETDATE() AS date) THEN 1 ELSE 0 END) TodayInProcess,
        SUM(CASE WHEN a.AssignmentStatus='Completed' AND CAST(a.CompletedDate AS date)=CAST(GETDATE() AS date) THEN 1 ELSE 0 END) TodayCompleted,
        SUM(CASE WHEN a.AssignmentStatus='Hold' AND CAST(a.HoldDate AS date)=CAST(GETDATE() AS date) THEN 1 ELSE 0 END) TodayHold
    FROM dbo.OLTracking_Assignment a
    JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID
    JOIN dbo.Project p ON p.ProjectID=a.ProjectID
    WHERE a.ProjectID=@ProjectID AND (NULLIF(@DealNumber,'') IS NULL OR i.DealNumber=@DealNumber)
    GROUP BY p.ProjectName,i.DealNumber,f.ProcessID,f.ProcessName
    ORDER BY i.DealNumber,f.ProcessName;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetHourlyProduction','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_GetHourlyProduction AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetHourlyProduction @ProjectID int,@ReportDate date,@DealNumber nvarchar(150)=NULL
AS
BEGIN
    SET NOCOUNT ON; SET @ReportDate=ISNULL(@ReportDate,CAST(GETDATE() AS date));
    DECLARE @Start datetime=DATEADD(hour,10,CAST(@ReportDate AS datetime));
    SELECT ISNULL(i.DealNumber,'') DealNumber,f.ProcessID,f.ProcessName,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,0,@Start) AND a.CompletedDate<DATEADD(hour,2,@Start) THEN 1 ELSE 0 END) H10AM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,2,@Start) AND a.CompletedDate<DATEADD(hour,4,@Start) THEN 1 ELSE 0 END) H12PM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,4,@Start) AND a.CompletedDate<DATEADD(hour,6,@Start) THEN 1 ELSE 0 END) H02PM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,6,@Start) AND a.CompletedDate<DATEADD(hour,8,@Start) THEN 1 ELSE 0 END) H04PM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,8,@Start) AND a.CompletedDate<DATEADD(hour,10,@Start) THEN 1 ELSE 0 END) H06PM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,10,@Start) AND a.CompletedDate<DATEADD(hour,12,@Start) THEN 1 ELSE 0 END) H08PM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,12,@Start) AND a.CompletedDate<DATEADD(hour,14,@Start) THEN 1 ELSE 0 END) H10PM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,14,@Start) AND a.CompletedDate<DATEADD(hour,16,@Start) THEN 1 ELSE 0 END) H12AM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,16,@Start) AND a.CompletedDate<DATEADD(hour,18,@Start) THEN 1 ELSE 0 END) H02AM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,18,@Start) AND a.CompletedDate<DATEADD(hour,20,@Start) THEN 1 ELSE 0 END) H04AM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,20,@Start) AND a.CompletedDate<DATEADD(hour,22,@Start) THEN 1 ELSE 0 END) H06AM,
      SUM(CASE WHEN a.CompletedDate>=DATEADD(hour,22,@Start) AND a.CompletedDate<DATEADD(hour,24,@Start) THEN 1 ELSE 0 END) H08AM,
      COUNT(1) TotalCompleted
    FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID
    WHERE a.ProjectID=@ProjectID AND a.AssignmentStatus='Completed' AND a.CompletedDate>=@Start AND a.CompletedDate<DATEADD(hour,24,@Start)
      AND (NULLIF(@DealNumber,'') IS NULL OR i.DealNumber=@DealNumber)
    GROUP BY i.DealNumber,f.ProcessID,f.ProcessName ORDER BY i.DealNumber,f.ProcessName;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetReallocationUsers','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_GetReallocationUsers AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetReallocationUsers @ProjectID int,@DealNumber nvarchar(150),@ProcessID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT a.UserID,COALESCE(NULLIF(ec.PsuedoName,''),NULLIF(ec.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),a.UserID)) UserName
    FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.UserID
    OUTER APPLY(SELECT TOP 1 c.Code,c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE c.EmployeeID=a.UserID AND c.Code=e.Code AND c.DataSource='ERP' AND c.IsDelete=0 ORDER BY c.EmpConfigrationID DESC) ec
    WHERE a.ProjectID=@ProjectID AND a.ProcessID=@ProcessID AND a.IsCurrent=1 AND a.AssignmentStatus IN('Pending','In Process','Hold')
      AND i.DealNumber=@DealNumber ORDER BY UserName;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetReallocationOrders','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_GetReallocationOrders AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetReallocationOrders @ProjectID int,@DealNumber nvarchar(150),@ProcessID int,@FromUserID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.AssignmentID,p.ProjectName,ISNULL(i.DealNumber,'') DealNumber,i.ItemNumber LoanNumber,f.ProcessName,a.UserID,
      COALESCE(NULLIF(ec.PsuedoName,''),NULLIF(ec.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),a.UserID)) UserName,
      a.AssignmentStatus,a.LastRemark,a.AssignedDate,
      ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldTATSeconds
    FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID JOIN dbo.Project p ON p.ProjectID=a.ProjectID
    LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.UserID
    OUTER APPLY(SELECT TOP 1 c.Code,c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE c.EmployeeID=a.UserID AND c.Code=e.Code AND c.DataSource='ERP' AND c.IsDelete=0 ORDER BY c.EmpConfigrationID DESC) ec
    WHERE a.ProjectID=@ProjectID AND a.ProcessID=@ProcessID AND a.UserID=@FromUserID AND a.IsCurrent=1
      AND a.AssignmentStatus IN('Pending','In Process','Hold') AND i.DealNumber=@DealNumber ORDER BY a.AssignedDate;
END;
GO

IF OBJECT_ID('dbo.OLTracking_ReallocateOrders','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_ReallocateOrders AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_ReallocateOrders @ProjectID int,@FromUserID int,@ToUserID int,@AssignmentXml xml,@Remark nvarchar(1000),@ManagerID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF @FromUserID=@ToUserID THROW 50132,'Current user and new user must be different.',1;
        IF NULLIF(LTRIM(RTRIM(@Remark)),'') IS NULL THROW 50133,'Reallocation remark is required.',1;
        IF NOT EXISTS(SELECT 1 FROM dbo.UserProjectConfiguration WHERE ProjectID=@ProjectID AND UserID=@ToUserID)
            THROW 50131,'Selected new user is not configured for this project.',1;
        DECLARE @Assignments table(AssignmentID bigint NOT NULL PRIMARY KEY);
        INSERT @Assignments SELECT DISTINCT n.value('(text())[1]','bigint') FROM @AssignmentXml.nodes('/assignments/assignment') x(n);
        DECLARE @Requested int=(SELECT COUNT(1) FROM @Assignments);
        IF @Requested<1 OR @Requested>2 THROW 50130,'Select one or two orders.',1;
        IF (SELECT COUNT(1) FROM @Assignments s JOIN dbo.OLTracking_Assignment a ON a.AssignmentID=s.AssignmentID
            WHERE a.ProjectID=@ProjectID AND a.UserID=@FromUserID AND a.IsCurrent=1 AND a.AssignmentStatus IN('Pending','In Process','Hold'))<>@Requested
            THROW 50128,'One or more selected orders are no longer available for reallocation.',1;
        DECLARE @ActiveSelected int=(SELECT COUNT(1) FROM @Assignments s JOIN dbo.OLTracking_Assignment a ON a.AssignmentID=s.AssignmentID WHERE a.AssignmentStatus IN('Pending','In Process'));
        IF (SELECT COUNT(1) FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK) WHERE UserID=@ToUserID AND IsCurrent=1 AND AssignmentStatus IN('Pending','In Process'))+@ActiveSelected>2
            THROW 50110,'Selected new user can have a maximum of two pending/in-process orders.',1;

        INSERT dbo.OLTracking_ReallocationHistory(AssignmentID,FromUserID,ToUserID,AssignmentStatus,Remark,ReallocatedBy)
        SELECT a.AssignmentID,@FromUserID,@ToUserID,a.AssignmentStatus,@Remark,@ManagerID
        FROM @Assignments s JOIN dbo.OLTracking_Assignment a ON a.AssignmentID=s.AssignmentID;
        INSERT dbo.OLTracking_StatusHistory(AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
        SELECT a.AssignmentID,a.AssignmentStatus,a.AssignmentStatus,'Reallocated: '+@Remark,@ManagerID
        FROM @Assignments s JOIN dbo.OLTracking_Assignment a ON a.AssignmentID=s.AssignmentID;
        UPDATE a SET UserID=@ToUserID,LastRemark='Reallocated: '+@Remark,UpdatedBy=@ManagerID,UpdatedDate=GETDATE()
        FROM dbo.OLTracking_Assignment a JOIN @Assignments s ON s.AssignmentID=a.AssignmentID;
        COMMIT TRANSACTION; SELECT @Requested ReallocatedCount;
    END TRY
    BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK TRANSACTION; THROW; END CATCH
END;
GO
