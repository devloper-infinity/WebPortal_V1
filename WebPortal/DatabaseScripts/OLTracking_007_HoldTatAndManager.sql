/* Hold/resume TAT, manager reporting, and PM allocation. Safe to run repeatedly. */
IF COL_LENGTH('dbo.OLTracking_Assignment','HoldTATSeconds') IS NULL
    ALTER TABLE dbo.OLTracking_Assignment ADD HoldTATSeconds bigint NOT NULL CONSTRAINT DF_OLTracking_Assignment_HoldTAT DEFAULT(0) WITH VALUES;
IF COL_LENGTH('dbo.OLTracking_Assignment','TotalTATSeconds') IS NULL
    ALTER TABLE dbo.OLTracking_Assignment ADD TotalTATSeconds bigint NULL;
GO

IF OBJECT_ID('dbo.OLTracking_HoldPeriod','U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_HoldPeriod
    (
        HoldPeriodID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_HoldPeriod PRIMARY KEY,
        AssignmentID bigint NOT NULL,
        HoldStartDate datetime NOT NULL,
        ResumeDate datetime NULL,
        HoldSeconds bigint NULL,
        HoldReason nvarchar(1000) NOT NULL,
        HeldBy int NOT NULL,
        ResumedBy int NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_HoldPeriod_AddedDate DEFAULT(GETDATE()),
        CONSTRAINT FK_OLTracking_HoldPeriod_Assignment FOREIGN KEY(AssignmentID) REFERENCES dbo.OLTracking_Assignment(AssignmentID)
    );
    CREATE INDEX IX_OLTracking_HoldPeriod_Assignment ON dbo.OLTracking_HoldPeriod(AssignmentID,ResumeDate);
END;
GO

INSERT dbo.OLTracking_HoldPeriod(AssignmentID,HoldStartDate,HoldReason,HeldBy)
SELECT a.AssignmentID,a.HoldDate,ISNULL(NULLIF(a.LastRemark,''),'Hold'),a.UserID
FROM dbo.OLTracking_Assignment a
WHERE a.IsCurrent=1 AND a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL
  AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_HoldPeriod h WHERE h.AssignmentID=a.AssignmentID AND h.ResumeDate IS NULL);

UPDATE dbo.OLTracking_Assignment
SET TotalTATSeconds=CASE WHEN DATEDIFF(second,AssignedDate,CompletedDate)-ISNULL(HoldTATSeconds,0)<0 THEN 0
                         ELSE DATEDIFF(second,AssignedDate,CompletedDate)-ISNULL(HoldTATSeconds,0) END
WHERE AssignmentStatus='Completed' AND CompletedDate IS NOT NULL AND AssignedDate IS NOT NULL AND TotalTATSeconds IS NULL;
GO

IF OBJECT_ID('dbo.OLTracking_HoldLoan','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_HoldLoan AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_HoldLoan @AssignmentID bigint,@HoldReason nvarchar(1000),@UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NULLIF(LTRIM(RTRIM(@HoldReason)),'') IS NULL THROW 50126,'Hold reason is required.',1;
        DECLARE @ItemID bigint,@ProcessID int,@OldStatus varchar(20),@Now datetime=GETDATE();
        SELECT @ItemID=a.ItemID,@ProcessID=a.ProcessID,@OldStatus=a.AssignmentStatus
        FROM dbo.OLTracking_Assignment a WITH(UPDLOCK,HOLDLOCK)
        WHERE a.AssignmentID=@AssignmentID AND a.UserID=@UserID AND a.IsCurrent=1;
        IF @ItemID IS NULL THROW 50122,'Assignment was not found.',1;
        IF @OldStatus='Hold' THROW 50125,'Assignment is already on hold.',1;
        IF @OldStatus NOT IN('Pending','In Process') THROW 50122,'Assignment cannot be placed on hold.',1;

        INSERT dbo.OLTracking_HoldPeriod(AssignmentID,HoldStartDate,HoldReason,HeldBy)
        VALUES(@AssignmentID,@Now,@HoldReason,@UserID);
        UPDATE dbo.OLTracking_Assignment SET AssignmentStatus='Hold',HoldDate=@Now,LastRemark=@HoldReason,
            UpdatedBy=@UserID,UpdatedDate=@Now WHERE AssignmentID=@AssignmentID;
        UPDATE dbo.OLTracking_Item SET ItemStatus='Hold',CurrentProcessID=@ProcessID,UpdatedBy=@UserID,UpdatedDate=@Now WHERE ItemID=@ItemID;
        INSERT dbo.OLTracking_StatusHistory(AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
        VALUES(@AssignmentID,@OldStatus,'Hold',@HoldReason,@UserID);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK TRANSACTION; THROW; END CATCH
END;
GO

IF OBJECT_ID('dbo.OLTracking_ResumeLoan','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_ResumeLoan AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_ResumeLoan @AssignmentID bigint,@UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @ItemID bigint,@ProcessID int,@Now datetime=GETDATE(),@HoldStart datetime,@HoldSeconds bigint;
        SELECT @ItemID=a.ItemID,@ProcessID=a.ProcessID
        FROM dbo.OLTracking_Assignment a WITH(UPDLOCK,HOLDLOCK)
        WHERE a.AssignmentID=@AssignmentID AND a.UserID=@UserID AND a.IsCurrent=1 AND a.AssignmentStatus='Hold';
        IF @ItemID IS NULL THROW 50125,'Held assignment was not found.',1;
        IF (SELECT COUNT(1) FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
            WHERE UserID=@UserID AND IsCurrent=1 AND AssignmentStatus IN('Pending','In Process'))>=2
            THROW 50129,'Complete or hold an active order before resuming this order.',1;

        SELECT TOP 1 @HoldStart=HoldStartDate FROM dbo.OLTracking_HoldPeriod WITH(UPDLOCK,HOLDLOCK)
        WHERE AssignmentID=@AssignmentID AND ResumeDate IS NULL ORDER BY HoldPeriodID DESC;
        IF @HoldStart IS NULL SELECT @HoldStart=HoldDate FROM dbo.OLTracking_Assignment WHERE AssignmentID=@AssignmentID;
        SET @HoldSeconds=CASE WHEN @HoldStart IS NULL THEN 0 ELSE DATEDIFF(second,@HoldStart,@Now) END;
        UPDATE dbo.OLTracking_HoldPeriod SET ResumeDate=@Now,HoldSeconds=@HoldSeconds,ResumedBy=@UserID
        WHERE AssignmentID=@AssignmentID AND ResumeDate IS NULL;
        UPDATE dbo.OLTracking_Assignment SET AssignmentStatus='In Process',StartedDate=ISNULL(StartedDate,@Now),HoldDate=NULL,
            HoldTATSeconds=ISNULL(HoldTATSeconds,0)+@HoldSeconds,LastRemark='Resumed',UpdatedBy=@UserID,UpdatedDate=@Now
        WHERE AssignmentID=@AssignmentID;
        UPDATE dbo.OLTracking_Item SET ItemStatus='Allocated',CurrentProcessID=@ProcessID,UpdatedBy=@UserID,UpdatedDate=@Now WHERE ItemID=@ItemID;
        INSERT dbo.OLTracking_StatusHistory(AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
        VALUES(@AssignmentID,'Hold','In Process','Resumed',@UserID);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK TRANSACTION; THROW; END CATCH
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetTrackingQueue','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_GetTrackingQueue AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetTrackingQueue @UserID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.AssignmentID,a.ProjectID,a.ProcessID,f.ProcessName,i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber,
        a.AssignmentStatus,a.AssignedDate,a.StartedDate,a.HoldDate,a.LastRemark,f.FeedbackRequiredOnComplete,
        CAST(CASE WHEN f.IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
        ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldTATSeconds,
        CASE WHEN a.AssignedDate IS NULL THEN NULL ELSE
             CASE WHEN DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END)<0 THEN 0
                  ELSE DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END) END END TotalTATSeconds
    FROM dbo.OLTracking_Assignment a
    JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID
    WHERE a.UserID=@UserID AND a.IsCurrent=1 ORDER BY a.AssignedDate;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetUserDailyStatus','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_GetUserDailyStatus AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetUserDailyStatus @UserID int,@ProcessID int=0,@FromDate date=NULL,@ToDate date=NULL
AS
BEGIN
    SET NOCOUNT ON; SET @FromDate=ISNULL(@FromDate,CAST(GETDATE() AS date)); SET @ToDate=ISNULL(@ToDate,@FromDate);
    SELECT a.AssignmentID,a.ProjectID,a.ProcessID,f.ProcessName,i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber,
        a.AssignmentStatus,a.AssignedDate,a.StartedDate,a.CompletedDate,a.LastRemark,
        ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldTATSeconds,
        CASE WHEN a.TotalTATSeconds IS NOT NULL THEN a.TotalTATSeconds
             WHEN a.AssignedDate IS NULL THEN NULL
             ELSE CASE WHEN DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END)<0 THEN 0
                       ELSE DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END) END END TotalTATSeconds
    FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID
    WHERE a.UserID=@UserID AND (@ProcessID=0 OR a.ProcessID=@ProcessID)
      AND ((a.CompletedDate>=@FromDate AND a.CompletedDate<DATEADD(day,1,@ToDate)) OR (a.IsCurrent=1 AND a.AssignedDate<DATEADD(day,1,@ToDate)))
    ORDER BY ISNULL(a.CompletedDate,a.AssignedDate) DESC;
END;
GO

IF OBJECT_ID('dbo.OLTracking_CompleteLoan','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_CompleteLoan AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_CompleteLoan @AssignmentID bigint,@Remark nvarchar(1000),@FeedbackXml xml=NULL,@UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NULLIF(LTRIM(RTRIM(@Remark)),'') IS NULL THROW 50121,'Remark is required.',1;
        DECLARE @ItemID bigint,@ProjectID int,@ProcessID int,@OldStatus varchar(20),@FeedbackRequired bit,
                @AssignedDate datetime,@HoldSeconds bigint,@Now datetime=GETDATE(),@TotalSeconds bigint;
        SELECT @ItemID=a.ItemID,@ProjectID=a.ProjectID,@ProcessID=a.ProcessID,@OldStatus=a.AssignmentStatus,
               @AssignedDate=a.AssignedDate,@HoldSeconds=ISNULL(a.HoldTATSeconds,0),@FeedbackRequired=f.FeedbackRequiredOnComplete
        FROM dbo.OLTracking_Assignment a WITH(UPDLOCK,HOLDLOCK)
        INNER JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID AND f.IsActive=1
        WHERE a.AssignmentID=@AssignmentID AND a.UserID=@UserID AND a.IsCurrent=1;
        IF @ItemID IS NULL THROW 50122,'Assignment was not found.',1;
        IF @OldStatus='Hold' THROW 50127,'Resume the order before completing it.',1;

        IF @FeedbackXml IS NOT NULL
            INSERT dbo.OLTracking_Feedback(AssignmentID,FeedbackText,AddedBy)
            SELECT @AssignmentID,n.value('(text())[1]','nvarchar(2000)'),@UserID FROM @FeedbackXml.nodes('/feedbacks/feedback') x(n)
            WHERE NULLIF(LTRIM(RTRIM(n.value('(text())[1]','nvarchar(2000)'))),'') IS NOT NULL;
        IF @FeedbackRequired=1 AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Feedback WHERE AssignmentID=@AssignmentID AND IsDeleted=0)
            THROW 50123,'Feedback is mandatory for this process.',1;

        SET @TotalSeconds=CASE WHEN @AssignedDate IS NULL THEN 0 WHEN DATEDIFF(second,@AssignedDate,@Now)-@HoldSeconds<0 THEN 0 ELSE DATEDIFF(second,@AssignedDate,@Now)-@HoldSeconds END;
        UPDATE dbo.OLTracking_Assignment SET AssignmentStatus='Completed',CompletedDate=@Now,LastRemark=@Remark,IsCurrent=0,
            TotalTATSeconds=@TotalSeconds,UpdatedBy=@UserID,UpdatedDate=@Now WHERE AssignmentID=@AssignmentID;
        INSERT dbo.OLTracking_StatusHistory(AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
        VALUES(@AssignmentID,@OldStatus,'Completed',@Remark,@UserID);

        DECLARE @AllMandatoryDone bit=0;
        IF NOT EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFlow rf WHERE rf.ProjectID=@ProjectID AND rf.IsActive=1 AND rf.IsMandatory=1
          AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment ca WHERE ca.ItemID=@ItemID AND ca.ProcessID=rf.ProcessID AND ca.AssignmentStatus IN('Completed','Skipped')))
            SET @AllMandatoryDone=1;
        UPDATE dbo.OLTracking_Item SET ItemStatus=CASE WHEN @AllMandatoryDone=1 THEN 'Completed' ELSE 'Pending' END,
            CurrentProcessID=NULL,UpdatedBy=@UserID,UpdatedDate=@Now WHERE ItemID=@ItemID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK TRANSACTION; THROW; END CATCH
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetProjectUsers','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_GetProjectUsers AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetProjectUsers @ProjectID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT u.UserID,COALESCE(NULLIF(ec.PsuedoName,''),NULLIF(ec.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),u.UserID)) UserName,
        (SELECT COUNT(1) FROM dbo.OLTracking_Assignment a WHERE a.UserID=u.UserID AND a.IsCurrent=1 AND a.AssignmentStatus IN('Pending','In Process')) ActiveCount
    FROM dbo.UserProjectConfiguration u
    JOIN dbo.EmployeeInfo e ON e.EmployeeID=u.UserID AND ISNULL(e.IsDelete,0)=0
    OUTER APPLY(SELECT TOP 1 c.Code,c.PsuedoName FROM dbo.EmployeeConfiguration c
        WHERE c.EmployeeID=e.EmployeeID AND c.Code=e.Code AND c.DataSource='ERP' AND c.IsDelete=0 ORDER BY c.EmpConfigrationID DESC) ec
    WHERE u.ProjectID=@ProjectID ORDER BY UserName;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetEligibleLoans','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_GetEligibleLoans AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetEligibleLoans @ProjectID int,@DealNumber nvarchar(150),@ProcessID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1),@PreviousStage int;
    SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo<@StageNo;
    SELECT TOP(100) i.ItemID,i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber
    FROM dbo.OLTracking_Item i
    WHERE @StageNo IS NOT NULL AND i.ProjectID=@ProjectID AND i.IsDeleted=0 AND i.RecordSource='Import'
      AND LTRIM(RTRIM(ISNULL(i.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment a WHERE a.ItemID=i.ItemID AND a.ProcessID=@ProcessID AND (a.IsCurrent=1 OR a.AssignmentStatus IN('Completed','Skipped')))
      AND (@PreviousStage IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFlow pf WHERE pf.ProjectID=@ProjectID AND pf.IsActive=1 AND pf.StageNo=@PreviousStage AND pf.IsMandatory=1)
        OR EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment ca JOIN dbo.OLTracking_ProcessFlow cf ON cf.ProjectID=@ProjectID AND cf.ProcessID=ca.ProcessID
          AND cf.IsActive=1 AND cf.IsMandatory=1 AND cf.StageNo=@PreviousStage WHERE ca.ItemID=i.ItemID AND ca.AssignmentStatus IN('Completed','Skipped')))
    ORDER BY i.ItemID;
END;
GO

IF OBJECT_ID('dbo.OLTracking_ManagerAllocate','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_ManagerAllocate AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_ManagerAllocate @ProjectID int,@DealNumber nvarchar(150),@ProcessID int,@TargetUserID int,@LoanXml xml,@ManagerID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @Loans table(LoanNumber nvarchar(150) NOT NULL PRIMARY KEY);
        INSERT @Loans(LoanNumber) SELECT DISTINCT LTRIM(RTRIM(n.value('(text())[1]','nvarchar(150)')))
        FROM @LoanXml.nodes('/loans/loan') x(n) WHERE NULLIF(LTRIM(RTRIM(n.value('(text())[1]','nvarchar(150)'))),'') IS NOT NULL;
        DECLARE @Requested int=(SELECT COUNT(1) FROM @Loans);
        IF @Requested<1 OR @Requested>2 THROW 50130,'Select one or two orders.',1;
        IF NOT EXISTS(SELECT 1 FROM dbo.UserProjectConfiguration WHERE ProjectID=@ProjectID AND UserID=@TargetUserID)
            THROW 50131,'Selected user is not configured for this project.',1;
        IF (SELECT COUNT(1) FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK) WHERE UserID=@TargetUserID AND IsCurrent=1 AND AssignmentStatus IN('Pending','In Process'))+@Requested>2
            THROW 50110,'Selected user can have a maximum of two pending/in-process orders.',1;
        DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1),@PreviousStage int;
        IF @StageNo IS NULL THROW 50111,'Selected process is not configured.',1;
        SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo<@StageNo;
        IF (SELECT COUNT(1) FROM @Loans l JOIN dbo.OLTracking_Item i ON i.ProjectID=@ProjectID AND i.ItemNumber=l.LoanNumber AND i.IsDeleted=0 AND i.RecordSource='Import'
            WHERE LTRIM(RTRIM(ISNULL(i.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
              AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment a WHERE a.ItemID=i.ItemID AND a.ProcessID=@ProcessID AND (a.IsCurrent=1 OR a.AssignmentStatus IN('Completed','Skipped')))
              AND (@PreviousStage IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFlow pf WHERE pf.ProjectID=@ProjectID AND pf.IsActive=1 AND pf.StageNo=@PreviousStage AND pf.IsMandatory=1)
                OR EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment ca JOIN dbo.OLTracking_ProcessFlow cf ON cf.ProjectID=@ProjectID AND cf.ProcessID=ca.ProcessID AND cf.IsActive=1 AND cf.IsMandatory=1 AND cf.StageNo=@PreviousStage WHERE ca.ItemID=i.ItemID AND ca.AssignmentStatus IN('Completed','Skipped'))))<>@Requested
            THROW 50128,'One or more selected orders are no longer eligible.',1;
        INSERT dbo.OLTracking_Assignment(ItemID,ProjectID,ProcessID,UserID,AssignmentStatus,AddedBy)
        SELECT i.ItemID,@ProjectID,@ProcessID,@TargetUserID,'Pending',@ManagerID FROM @Loans l JOIN dbo.OLTracking_Item i ON i.ProjectID=@ProjectID AND i.ItemNumber=l.LoanNumber AND i.IsDeleted=0;
        UPDATE i SET ItemStatus='Allocated',CurrentProcessID=@ProcessID,UpdatedBy=@ManagerID,UpdatedDate=GETDATE()
        FROM dbo.OLTracking_Item i JOIN @Loans l ON l.LoanNumber=i.ItemNumber WHERE i.ProjectID=@ProjectID;
        COMMIT TRANSACTION; SELECT @Requested AllocatedCount;
    END TRY
    BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK TRANSACTION; THROW; END CATCH
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetManagerDetail','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_GetManagerDetail AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetManagerDetail @ProjectID int,@ProcessID int=0,@UserID int=0,@Status varchar(20)=NULL,@FromDate date=NULL,@ToDate date=NULL
AS
BEGIN
    SET NOCOUNT ON; SET @FromDate=ISNULL(@FromDate,DATEADD(day,-30,CAST(GETDATE() AS date))); SET @ToDate=ISNULL(@ToDate,CAST(GETDATE() AS date));
    SELECT a.AssignmentID,a.ProjectID,p.ProjectName,a.ProcessID,f.ProcessName,a.UserID,
        COALESCE(NULLIF(ec.PsuedoName,''),NULLIF(ec.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),a.UserID)) UserName,
        i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber,a.AssignmentStatus,a.AssignedDate,a.StartedDate,a.CompletedDate,a.LastRemark,
        ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldTATSeconds,
        CASE WHEN a.TotalTATSeconds IS NOT NULL THEN a.TotalTATSeconds ELSE
          CASE WHEN DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END)<0 THEN 0
               ELSE DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END) END END TotalTATSeconds
    FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID
    JOIN dbo.Project p ON p.ProjectID=a.ProjectID LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.UserID
    OUTER APPLY(SELECT TOP 1 c.Code,c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE c.EmployeeID=a.UserID AND c.Code=e.Code AND c.DataSource='ERP' AND c.IsDelete=0 ORDER BY c.EmpConfigrationID DESC) ec
    WHERE a.ProjectID=@ProjectID AND (@ProcessID=0 OR a.ProcessID=@ProcessID) AND (@UserID=0 OR a.UserID=@UserID)
      AND (NULLIF(@Status,'') IS NULL OR a.AssignmentStatus=@Status)
      AND ISNULL(a.CompletedDate,a.AssignedDate)>=@FromDate AND ISNULL(a.CompletedDate,a.AssignedDate)<DATEADD(day,1,@ToDate)
    ORDER BY ISNULL(a.CompletedDate,a.AssignedDate) DESC;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetManagerSummary','P') IS NULL EXEC('CREATE PROCEDURE dbo.OLTracking_GetManagerSummary AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetManagerSummary @ProjectID int,@ProcessID int=0,@UserID int=0,@FromDate date=NULL,@ToDate date=NULL
AS
BEGIN
    SET NOCOUNT ON; SET @FromDate=ISNULL(@FromDate,DATEADD(day,-30,CAST(GETDATE() AS date))); SET @ToDate=ISNULL(@ToDate,CAST(GETDATE() AS date));
    ;WITH Base AS
    (
        SELECT p.ProjectName,f.ProcessName,a.UserID,COALESCE(NULLIF(ec.PsuedoName,''),NULLIF(ec.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),a.UserID)) UserName,a.AssignmentStatus,
          ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldSeconds,
          CASE WHEN a.TotalTATSeconds IS NOT NULL THEN a.TotalTATSeconds ELSE CASE WHEN DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END)<0 THEN 0 ELSE DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END) END END TatSeconds
        FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID JOIN dbo.Project p ON p.ProjectID=a.ProjectID
        LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.UserID
        OUTER APPLY(SELECT TOP 1 c.Code,c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE c.EmployeeID=a.UserID AND c.Code=e.Code AND c.DataSource='ERP' AND c.IsDelete=0 ORDER BY c.EmpConfigrationID DESC) ec
        WHERE a.ProjectID=@ProjectID AND (@ProcessID=0 OR a.ProcessID=@ProcessID) AND (@UserID=0 OR a.UserID=@UserID)
          AND ISNULL(a.CompletedDate,a.AssignedDate)>=@FromDate AND ISNULL(a.CompletedDate,a.AssignedDate)<DATEADD(day,1,@ToDate)
    )
    SELECT ProjectName,ProcessName,UserID,UserName,COUNT(1) TotalOrders,
      SUM(CASE WHEN AssignmentStatus='Pending' THEN 1 ELSE 0 END) PendingOrders,
      SUM(CASE WHEN AssignmentStatus='In Process' THEN 1 ELSE 0 END) InProcessOrders,
      SUM(CASE WHEN AssignmentStatus='Hold' THEN 1 ELSE 0 END) HoldOrders,
      SUM(CASE WHEN AssignmentStatus='Completed' THEN 1 ELSE 0 END) CompletedOrders,
      CONVERT(bigint,AVG(CONVERT(decimal(18,2),TatSeconds))) AverageTATSeconds,SUM(HoldSeconds) TotalHoldTATSeconds
    FROM Base GROUP BY ProjectName,ProcessName,UserID,UserName ORDER BY ProjectName,ProcessName,UserName;
END;
GO
