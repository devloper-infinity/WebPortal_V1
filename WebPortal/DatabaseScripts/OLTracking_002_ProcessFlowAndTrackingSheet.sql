/* Stage-based OLTracking process flow and three-tab Tracking Sheet.
   Self-contained and safe to rerun. Existing WBT configuration/data objects are not changed. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.OLTracking_Item','U') IS NULL
CREATE TABLE dbo.OLTracking_Item(
 ItemID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_Item PRIMARY KEY,
 ProjectID int NOT NULL,ItemNumber nvarchar(150) NOT NULL,DealNumber nvarchar(150) NULL,
 CurrentProcessID int NULL,ItemStatus varchar(20) NOT NULL CONSTRAINT DF_OLTracking_Item_Status DEFAULT('Pending'),
 IsDeleted bit NOT NULL CONSTRAINT DF_OLTracking_Item_Delete DEFAULT(0),
 AddedBy int NOT NULL,AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_Item_AD DEFAULT(GETDATE()),
 UpdatedBy int NULL,UpdatedDate datetime NULL,
 CONSTRAINT UQ_OLTracking_Item UNIQUE(ProjectID,ItemNumber),
 CONSTRAINT CK_OLTracking_Item_Status CHECK(ItemStatus IN ('Pending','Allocated','In Process','Hold','Completed'))
);
GO

IF OBJECT_ID('dbo.OLTracking_Assignment','U') IS NULL
CREATE TABLE dbo.OLTracking_Assignment(
 AssignmentID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_Assignment PRIMARY KEY,
 ItemID bigint NOT NULL,ProjectID int NOT NULL,ProcessID int NOT NULL,UserID int NOT NULL,
 AssignmentStatus varchar(20) NOT NULL CONSTRAINT DF_OLTracking_Assignment_Status DEFAULT('Pending'),
 AssignedDate datetime NOT NULL CONSTRAINT DF_OLTracking_Assignment_Date DEFAULT(GETDATE()),
 StartedDate datetime NULL,CompletedDate datetime NULL,HoldDate datetime NULL,LastRemark nvarchar(1000) NULL,
 IsCurrent bit NOT NULL CONSTRAINT DF_OLTracking_Assignment_Current DEFAULT(1),
 AddedBy int NOT NULL,AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_Assignment_AD DEFAULT(GETDATE()),
 UpdatedBy int NULL,UpdatedDate datetime NULL,
 CONSTRAINT FK_OLTracking_Assignment_Item FOREIGN KEY(ItemID) REFERENCES dbo.OLTracking_Item(ItemID),
 CONSTRAINT CK_OLTracking_Assignment_Status CHECK(AssignmentStatus IN ('Pending','In Process','Hold','Completed','Skipped'))
);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.OLTracking_Assignment') AND name='IX_OLTracking_Assignment_UserQueue')
 CREATE INDEX IX_OLTracking_Assignment_UserQueue ON dbo.OLTracking_Assignment(UserID,IsCurrent,AssignmentStatus,AssignedDate);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.OLTracking_Assignment') AND name='UX_OLTracking_Assignment_Current')
 CREATE UNIQUE INDEX UX_OLTracking_Assignment_Current ON dbo.OLTracking_Assignment(ItemID,ProcessID) WHERE IsCurrent=1;
GO

IF OBJECT_ID('dbo.OLTracking_StatusHistory','U') IS NULL
CREATE TABLE dbo.OLTracking_StatusHistory(
 StatusHistoryID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_StatusHistory PRIMARY KEY,
 AssignmentID bigint NOT NULL,OldStatus varchar(20) NULL,NewStatus varchar(20) NOT NULL,
 Remark nvarchar(1000) NOT NULL,ChangedBy int NOT NULL,ChangedDate datetime NOT NULL CONSTRAINT DF_OLTracking_StatusHistory_Date DEFAULT(GETDATE()),
 CONSTRAINT FK_OLTracking_StatusHistory_Assignment FOREIGN KEY(AssignmentID) REFERENCES dbo.OLTracking_Assignment(AssignmentID)
);
GO

IF OBJECT_ID('dbo.OLTracking_Feedback','U') IS NULL
CREATE TABLE dbo.OLTracking_Feedback(
 FeedbackID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_Feedback PRIMARY KEY,
 AssignmentID bigint NOT NULL,FeedbackText nvarchar(2000) NOT NULL,
 AddedBy int NOT NULL,AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_Feedback_Date DEFAULT(GETDATE()),
 IsDeleted bit NOT NULL CONSTRAINT DF_OLTracking_Feedback_Delete DEFAULT(0),
 CONSTRAINT FK_OLTracking_Feedback_Assignment FOREIGN KEY(AssignmentID) REFERENCES dbo.OLTracking_Assignment(AssignmentID)
);
GO

IF OBJECT_ID('dbo.OLTracking_ProcessFlow','U') IS NULL
CREATE TABLE dbo.OLTracking_ProcessFlow(
 FlowID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ProcessFlow PRIMARY KEY,
 ProjectID int NOT NULL,
 ProcessID int NOT NULL,
 ProcessName nvarchar(200) NOT NULL,
 StageNo int NOT NULL,
 IsMandatory bit NOT NULL CONSTRAINT DF_OLTracking_ProcessFlow_Mandatory DEFAULT(1),
 FeedbackRequiredOnComplete bit NOT NULL CONSTRAINT DF_OLTracking_ProcessFlow_Feedback DEFAULT(0),
 IsActive bit NOT NULL CONSTRAINT DF_OLTracking_ProcessFlow_Active DEFAULT(1),
 AddedBy int NOT NULL,
 AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ProcessFlow_AD DEFAULT(GETDATE()),
 UpdatedBy int NULL,
 UpdatedDate datetime NULL,
 CONSTRAINT UQ_OLTracking_ProcessFlow UNIQUE(ProjectID,ProcessID),
 CONSTRAINT CK_OLTracking_ProcessFlow_Stage CHECK(StageNo>0)
);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.OLTracking_ProcessFlow') AND name='IX_OLTracking_ProcessFlow_ProjectStage')
 CREATE INDEX IX_OLTracking_ProcessFlow_ProjectStage ON dbo.OLTracking_ProcessFlow(ProjectID,IsActive,StageNo,ProcessID);
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_GetProcessFlow @ProjectID int AS
BEGIN
 SET NOCOUNT ON;
 SELECT FlowID,ProjectID,ProcessID,ProcessName,StageNo,IsMandatory,
        CAST(CASE WHEN IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
        FeedbackRequiredOnComplete,IsActive
 FROM dbo.OLTracking_ProcessFlow
 WHERE ProjectID=@ProjectID AND IsActive=1
 ORDER BY StageNo,ProcessName;
END
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_SaveProcessFlow
 @ProjectID int,@ProcessID int,@ProcessName nvarchar(200),@StageNo int,
 @IsMandatory bit,@FeedbackRequiredOnComplete bit,@UserID int
AS
BEGIN
 SET NOCOUNT ON;
 IF @ProjectID<=0 OR @ProcessID<=0 THROW 50100,'Project and process are required.',1;
 IF @StageNo<=0 THROW 50101,'Sequence must be greater than zero.',1;
 IF NULLIF(LTRIM(RTRIM(@ProcessName)),'') IS NULL THROW 50102,'Process name is required.',1;
 MERGE dbo.OLTracking_ProcessFlow AS T
 USING(SELECT @ProjectID ProjectID,@ProcessID ProcessID) S
 ON T.ProjectID=S.ProjectID AND T.ProcessID=S.ProcessID
 WHEN MATCHED THEN UPDATE SET ProcessName=LTRIM(RTRIM(@ProcessName)),StageNo=@StageNo,IsMandatory=@IsMandatory,
  FeedbackRequiredOnComplete=@FeedbackRequiredOnComplete,IsActive=1,UpdatedBy=@UserID,UpdatedDate=GETDATE()
 WHEN NOT MATCHED THEN INSERT(ProjectID,ProcessID,ProcessName,StageNo,IsMandatory,FeedbackRequiredOnComplete,AddedBy)
  VALUES(@ProjectID,@ProcessID,LTRIM(RTRIM(@ProcessName)),@StageNo,@IsMandatory,@FeedbackRequiredOnComplete,@UserID);
END
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_RemoveProcessFlow @ProjectID int,@ProcessID int,@UserID int AS
BEGIN
 SET NOCOUNT ON;
 UPDATE dbo.OLTracking_ProcessFlow SET IsActive=0,UpdatedBy=@UserID,UpdatedDate=GETDATE()
 WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1;
 SELECT @@ROWCOUNT RowsAffected;
END
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_IsLoanEligible
 @ProjectID int,@ProcessID int,@LoanNumber nvarchar(150)
AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1);
 DECLARE @ItemID bigint=(SELECT ItemID FROM dbo.OLTracking_Item WHERE ProjectID=@ProjectID AND ItemNumber=@LoanNumber AND IsDeleted=0);
 DECLARE @PreviousStage int;
 IF @StageNo IS NULL BEGIN SELECT CAST(0 AS bit) Eligible,'Process is not configured in tracking flow.' Reason; RETURN; END;
 IF @ItemID IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment WHERE ItemID=@ItemID AND ProcessID=@ProcessID AND (IsCurrent=1 OR AssignmentStatus IN ('Completed','Skipped')))
 BEGIN SELECT CAST(0 AS bit) Eligible,'Loan is already allocated or completed for this process.' Reason; RETURN; END;
 SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo<@StageNo;
 IF @PreviousStage IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo=@PreviousStage AND IsMandatory=1)
 BEGIN SELECT CAST(1 AS bit) Eligible,'' Reason; RETURN; END;
 IF @ItemID IS NULL BEGIN SELECT CAST(0 AS bit) Eligible,'Previous mandatory sequence is not completed.' Reason; RETURN; END;
 IF EXISTS(
  SELECT 1 FROM dbo.OLTracking_ProcessFlow f
  WHERE f.ProjectID=@ProjectID AND f.IsActive=1 AND f.StageNo=@PreviousStage AND f.IsMandatory=1
  AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment a WHERE a.ItemID=@ItemID AND a.ProcessID=f.ProcessID AND a.AssignmentStatus IN ('Completed','Skipped'))
 ) BEGIN SELECT CAST(0 AS bit) Eligible,'Previous mandatory sequence is not completed.' Reason; RETURN; END;
 SELECT CAST(1 AS bit) Eligible,'' Reason;
END
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_AllocateLoan
 @ProjectID int,@ProcessID int,@LoanNumber nvarchar(150),@DealNumber nvarchar(150),@UserID int
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN;
 IF (SELECT COUNT(*) FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
     WHERE UserID=@UserID AND IsCurrent=1 AND AssignmentStatus IN ('Pending','In Process'))>=2
 BEGIN ROLLBACK; THROW 50110,'You already have two pending/in-process loans. Complete or hold one before allocating another.',1; END;
 DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1);
 IF @StageNo IS NULL BEGIN ROLLBACK; THROW 50111,'Selected process is not configured in the tracking flow.',1; END;
 DECLARE @ItemID bigint=(SELECT ItemID FROM dbo.OLTracking_Item WITH(UPDLOCK,HOLDLOCK) WHERE ProjectID=@ProjectID AND ItemNumber=@LoanNumber AND IsDeleted=0);
 IF @ItemID IS NULL BEGIN
  INSERT dbo.OLTracking_Item(ProjectID,ItemNumber,DealNumber,CurrentProcessID,ItemStatus,AddedBy)
  VALUES(@ProjectID,@LoanNumber,NULLIF(@DealNumber,''),@ProcessID,'Pending',@UserID); SET @ItemID=SCOPE_IDENTITY();
 END ELSE UPDATE dbo.OLTracking_Item SET DealNumber=NULLIF(@DealNumber,''),CurrentProcessID=@ProcessID,UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE ItemID=@ItemID;
 IF EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment WHERE ItemID=@ItemID AND ProcessID=@ProcessID AND (IsCurrent=1 OR AssignmentStatus IN ('Completed','Skipped')))
 BEGIN ROLLBACK; THROW 50112,'This loan is already allocated or completed for the selected process.',1; END;
 DECLARE @PreviousStage int;
 SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo<@StageNo;
 IF @PreviousStage IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo=@PreviousStage AND IsMandatory=1)
 AND EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFlow f WHERE f.ProjectID=@ProjectID AND f.IsActive=1 AND f.StageNo=@PreviousStage AND f.IsMandatory=1
  AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment a WHERE a.ItemID=@ItemID AND a.ProcessID=f.ProcessID AND a.AssignmentStatus IN ('Completed','Skipped')))
 BEGIN ROLLBACK; THROW 50113,'The previous mandatory sequence is not completed for this loan.',1; END;
 INSERT dbo.OLTracking_Assignment(ItemID,ProjectID,ProcessID,UserID,AssignmentStatus,AddedBy)
 VALUES(@ItemID,@ProjectID,@ProcessID,@UserID,'Pending',@UserID);
 UPDATE dbo.OLTracking_Item SET ItemStatus='Allocated',UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE ItemID=@ItemID;
 COMMIT; SELECT SCOPE_IDENTITY() AssignmentID;
END
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_GetTrackingQueue @UserID int AS
BEGIN
 SET NOCOUNT ON;
 SELECT a.AssignmentID,a.ProjectID,a.ProcessID,f.ProcessName,i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber,
 a.AssignmentStatus,a.AssignedDate,a.StartedDate,a.HoldDate,a.LastRemark,f.FeedbackRequiredOnComplete,
 CAST(CASE WHEN f.IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip
 FROM dbo.OLTracking_Assignment a
 JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
 JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID
 WHERE a.UserID=@UserID AND a.IsCurrent=1
 ORDER BY a.AssignedDate;
END
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_StartLoan @AssignmentID bigint,@UserID int AS
BEGIN
 SET NOCOUNT ON;
 UPDATE dbo.OLTracking_Assignment SET AssignmentStatus='In Process',StartedDate=ISNULL(StartedDate,GETDATE()),UpdatedBy=@UserID,UpdatedDate=GETDATE()
 WHERE AssignmentID=@AssignmentID AND UserID=@UserID AND IsCurrent=1 AND AssignmentStatus='Pending';
 IF @@ROWCOUNT=0 THROW 50120,'Pending assignment was not found.',1;
 INSERT dbo.OLTracking_StatusHistory(AssignmentID,OldStatus,NewStatus,Remark,ChangedBy) VALUES(@AssignmentID,'Pending','In Process','Work started',@UserID);
END
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_CompleteLoan
 @AssignmentID bigint,@Remark nvarchar(1000),@FeedbackXml xml=NULL,@UserID int
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN;
 IF NULLIF(LTRIM(RTRIM(@Remark)),'') IS NULL BEGIN ROLLBACK; THROW 50121,'Remark is required.',1; END;
 DECLARE @ItemID bigint,@ProjectID int,@ProcessID int,@OldStatus varchar(20),@FeedbackRequired bit;
 SELECT @ItemID=a.ItemID,@ProjectID=a.ProjectID,@ProcessID=a.ProcessID,@OldStatus=a.AssignmentStatus,
        @FeedbackRequired=f.FeedbackRequiredOnComplete
 FROM dbo.OLTracking_Assignment a WITH(UPDLOCK,HOLDLOCK)
 JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID
 WHERE a.AssignmentID=@AssignmentID AND a.UserID=@UserID AND a.IsCurrent=1;
 IF @ItemID IS NULL BEGIN ROLLBACK; THROW 50122,'Assignment was not found.',1; END;
 IF @FeedbackRequired=1 AND (@FeedbackXml IS NULL OR @FeedbackXml.exist('/feedbacks/feedback[normalize-space(.) != ""]')=0)
 BEGIN ROLLBACK; THROW 50123,'Feedback is mandatory for this process.',1; END;
 IF @FeedbackXml IS NOT NULL INSERT dbo.OLTracking_Feedback(AssignmentID,FeedbackText,AddedBy)
 SELECT @AssignmentID,N.value('(text())[1]','nvarchar(2000)'),@UserID FROM @FeedbackXml.nodes('/feedbacks/feedback') F(N)
 WHERE NULLIF(LTRIM(RTRIM(N.value('(text())[1]','nvarchar(2000)'))),'') IS NOT NULL;
 UPDATE dbo.OLTracking_Assignment SET AssignmentStatus='Completed',CompletedDate=GETDATE(),LastRemark=@Remark,
 IsCurrent=0,UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE AssignmentID=@AssignmentID;
 INSERT dbo.OLTracking_StatusHistory(AssignmentID,OldStatus,NewStatus,Remark,ChangedBy) VALUES(@AssignmentID,@OldStatus,'Completed',@Remark,@UserID);
 DECLARE @AllMandatoryDone bit=0;
 IF NOT EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFlow f WHERE f.ProjectID=@ProjectID AND f.IsActive=1 AND f.IsMandatory=1
  AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment a WHERE a.ItemID=@ItemID AND a.ProcessID=f.ProcessID AND a.AssignmentStatus IN ('Completed','Skipped')))
  SET @AllMandatoryDone=1;
 UPDATE dbo.OLTracking_Item SET ItemStatus=CASE WHEN @AllMandatoryDone=1 THEN 'Completed' ELSE 'Pending' END,
 CurrentProcessID=NULL,UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE ItemID=@ItemID;
 COMMIT;
END
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_GetUserDailyStatus
 @UserID int,@ProcessID int=0,@FromDate date=NULL,@ToDate date=NULL
AS
BEGIN
 SET NOCOUNT ON;
 SET @FromDate=ISNULL(@FromDate,CAST(GETDATE() AS date)); SET @ToDate=ISNULL(@ToDate,@FromDate);
 SELECT a.AssignmentID,a.ProjectID,a.ProcessID,f.ProcessName,i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber,
 a.AssignmentStatus,a.AssignedDate,a.StartedDate,a.CompletedDate,a.LastRemark
 FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
 JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID
 WHERE a.UserID=@UserID AND (@ProcessID=0 OR a.ProcessID=@ProcessID)
 AND ((a.CompletedDate>=@FromDate AND a.CompletedDate<DATEADD(day,1,@ToDate))
   OR (a.IsCurrent=1 AND a.AssignedDate<DATEADD(day,1,@ToDate)))
 ORDER BY ISNULL(a.CompletedDate,a.AssignedDate) DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_GetUserDailyProcesses @UserID int AS
BEGIN
 SET NOCOUNT ON;
 SELECT DISTINCT a.ProcessID,f.ProcessName FROM dbo.OLTracking_Assignment a
 JOIN dbo.OLTracking_ProcessFlow f ON f.ProjectID=a.ProjectID AND f.ProcessID=a.ProcessID
 WHERE a.UserID=@UserID ORDER BY f.ProcessName;
END
GO
