/* IT Helpdesk Management System - SQL Server 2016, isolated IHMS_ objects only. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO
IF OBJECT_ID('dbo.IHMS_RequestType','U') IS NULL CREATE TABLE dbo.IHMS_RequestType(
 RequestTypeID int IDENTITY PRIMARY KEY, Name nvarchar(120) NOT NULL UNIQUE, Description nvarchar(500) NULL,
 ApprovalRequired bit NOT NULL CONSTRAINT DF_IHMS_RT_Approval DEFAULT(0), IsActive bit NOT NULL CONSTRAINT DF_IHMS_RT_Active DEFAULT(1), DisplayOrder int NOT NULL DEFAULT(0),
 CreatedBy int NOT NULL, CreatedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()), ModifiedBy int NULL, ModifiedDate datetime2(0) NULL);
IF OBJECT_ID('dbo.IHMS_TicketStatus','U') IS NULL CREATE TABLE dbo.IHMS_TicketStatus(
 StatusID tinyint IDENTITY PRIMARY KEY, StatusCode varchar(30) NOT NULL UNIQUE, StatusName nvarchar(60) NOT NULL, DisplayOrder tinyint NOT NULL, IsActive bit NOT NULL DEFAULT(1));
IF OBJECT_ID('dbo.IHMS_Priority','U') IS NULL CREATE TABLE dbo.IHMS_Priority(
 PriorityID tinyint IDENTITY PRIMARY KEY, PriorityCode varchar(20) NOT NULL UNIQUE, PriorityName nvarchar(40) NOT NULL, DisplayOrder tinyint NOT NULL, IsActive bit NOT NULL DEFAULT(1));
IF OBJECT_ID('dbo.IHMS_SLA','U') IS NULL CREATE TABLE dbo.IHMS_SLA(
 SLAID int IDENTITY PRIMARY KEY, PriorityID tinyint NOT NULL UNIQUE REFERENCES dbo.IHMS_Priority(PriorityID), FirstResponseMinutes int NOT NULL CHECK(FirstResponseMinutes>0), ResolutionMinutes int NOT NULL CHECK(ResolutionMinutes>0), IsActive bit NOT NULL DEFAULT(1), CreatedBy int NOT NULL, CreatedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()), ModifiedBy int NULL, ModifiedDate datetime2(0) NULL);
IF OBJECT_ID('dbo.IHMS_Ticket','U') IS NULL CREATE TABLE dbo.IHMS_Ticket(
 TicketID bigint IDENTITY PRIMARY KEY, TicketNo varchar(20) NULL, RequestorEmployeeID int NULL, RequestorName nvarchar(150) NOT NULL, RequestorEmail nvarchar(254) NOT NULL,
 Department nvarchar(150) NULL, Location nvarchar(150) NULL, Subject nvarchar(300) NOT NULL, Description nvarchar(max) NOT NULL,
 RequestTypeID int NULL REFERENCES dbo.IHMS_RequestType(RequestTypeID), PriorityID tinyint NOT NULL REFERENCES dbo.IHMS_Priority(PriorityID), StatusID tinyint NOT NULL REFERENCES dbo.IHMS_TicketStatus(StatusID),
 AssignedToEmployeeID int NULL, Source varchar(20) NOT NULL DEFAULT('Portal'), ApprovalRequired bit NOT NULL DEFAULT(0), ApprovalStatus varchar(20) NULL,
 FirstRespondedDate datetime2(0) NULL, ResolvedDate datetime2(0) NULL, ClosedDate datetime2(0) NULL, SLADueDate datetime2(0) NULL,
 GraphMessageID nvarchar(500) NULL, InternetMessageID nvarchar(500) NULL, CreatedBy int NULL, CreatedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()), ModifiedBy int NULL, ModifiedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()), RowVersion rowversion);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='UX_IHMS_Ticket_TicketNo') CREATE UNIQUE INDEX UX_IHMS_Ticket_TicketNo ON dbo.IHMS_Ticket(TicketNo) WHERE TicketNo IS NOT NULL;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='UX_IHMS_Ticket_GraphMessageID') CREATE UNIQUE INDEX UX_IHMS_Ticket_GraphMessageID ON dbo.IHMS_Ticket(GraphMessageID) WHERE GraphMessageID IS NOT NULL;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='UX_IHMS_Ticket_InternetMessageID') CREATE UNIQUE INDEX UX_IHMS_Ticket_InternetMessageID ON dbo.IHMS_Ticket(InternetMessageID) WHERE InternetMessageID IS NOT NULL;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_IHMS_Ticket_Work') CREATE INDEX IX_IHMS_Ticket_Work ON dbo.IHMS_Ticket(StatusID,AssignedToEmployeeID,CreatedDate) INCLUDE(TicketNo,PriorityID,RequestTypeID,SLADueDate);
IF OBJECT_ID('dbo.IHMS_TicketActivity','U') IS NULL CREATE TABLE dbo.IHMS_TicketActivity(ActivityID bigint IDENTITY PRIMARY KEY, TicketID bigint NOT NULL REFERENCES dbo.IHMS_Ticket(TicketID), ActivityType varchar(40) NOT NULL, OldValue nvarchar(1000) NULL, NewValue nvarchar(1000) NULL, Details nvarchar(max) NULL, IsInternal bit NOT NULL DEFAULT(0), PerformedBy int NULL, PerformedName nvarchar(150) NULL, PerformedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()));
IF OBJECT_ID('dbo.IHMS_TicketRemark','U') IS NULL CREATE TABLE dbo.IHMS_TicketRemark(RemarkID bigint IDENTITY PRIMARY KEY,TicketID bigint NOT NULL REFERENCES dbo.IHMS_Ticket(TicketID),Remark nvarchar(max) NOT NULL,IsInternal bit NOT NULL,CreatedBy int NULL,CreatedName nvarchar(150) NULL,CreatedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()));
IF OBJECT_ID('dbo.IHMS_TicketAssignmentHistory','U') IS NULL CREATE TABLE dbo.IHMS_TicketAssignmentHistory(AssignmentID bigint IDENTITY PRIMARY KEY,TicketID bigint NOT NULL REFERENCES dbo.IHMS_Ticket(TicketID),FromEmployeeID int NULL,ToEmployeeID int NOT NULL,AssignedBy int NOT NULL,AssignedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()));
IF OBJECT_ID('dbo.IHMS_TicketApproval','U') IS NULL CREATE TABLE dbo.IHMS_TicketApproval(ApprovalID bigint IDENTITY PRIMARY KEY,TicketID bigint NOT NULL REFERENCES dbo.IHMS_Ticket(TicketID),ApproverEmployeeID int NOT NULL,ApprovalStatus varchar(20) NOT NULL DEFAULT('Pending'),RequestRemark nvarchar(1000) NULL,DecisionRemark nvarchar(2000) NULL,RequestedBy int NOT NULL,RequestedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),DecisionDate datetime2(0) NULL,CancelledBy int NULL,CancelledDate datetime2(0) NULL);
IF OBJECT_ID('dbo.IHMS_TicketAttachment','U') IS NULL CREATE TABLE dbo.IHMS_TicketAttachment(AttachmentID bigint IDENTITY PRIMARY KEY,TicketID bigint NOT NULL REFERENCES dbo.IHMS_Ticket(TicketID),RemarkID bigint NULL REFERENCES dbo.IHMS_TicketRemark(RemarkID),OriginalFileName nvarchar(260) NOT NULL,StoredFileName nvarchar(260) NOT NULL,ContentType nvarchar(150) NULL,FileSize bigint NOT NULL,StoragePath nvarchar(500) NOT NULL,IsInternal bit NOT NULL DEFAULT(0),UploadedBy int NULL,UploadedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()));
IF OBJECT_ID('dbo.IHMS_TicketEmail','U') IS NULL CREATE TABLE dbo.IHMS_TicketEmail(EmailID bigint IDENTITY PRIMARY KEY,TicketID bigint NOT NULL REFERENCES dbo.IHMS_Ticket(TicketID),Direction varchar(10) NOT NULL,GraphMessageID nvarchar(500) NULL,InternetMessageID nvarchar(500) NULL,FromAddress nvarchar(254) NULL,ToAddresses nvarchar(max) NULL,CcAddresses nvarchar(max) NULL,Subject nvarchar(500) NULL,Body nvarchar(max) NULL,SentReceivedDate datetime2(0) NOT NULL,CreatedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='UX_IHMS_Email_Graph') CREATE UNIQUE INDEX UX_IHMS_Email_Graph ON dbo.IHMS_TicketEmail(GraphMessageID) WHERE GraphMessageID IS NOT NULL;
IF OBJECT_ID('dbo.IHMS_TicketWatcher','U') IS NULL CREATE TABLE dbo.IHMS_TicketWatcher(TicketID bigint NOT NULL REFERENCES dbo.IHMS_Ticket(TicketID),EmployeeID int NOT NULL,CreatedBy int NOT NULL,CreatedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),CONSTRAINT PK_IHMS_Watcher PRIMARY KEY(TicketID,EmployeeID));
IF OBJECT_ID('dbo.IHMS_EmailQueue','U') IS NULL CREATE TABLE dbo.IHMS_EmailQueue(QueueID bigint IDENTITY PRIMARY KEY,TicketID bigint NULL REFERENCES dbo.IHMS_Ticket(TicketID),ToAddresses nvarchar(max) NOT NULL,CcAddresses nvarchar(max) NULL,Subject nvarchar(500) NOT NULL,Body nvarchar(max) NOT NULL,Status varchar(20) NOT NULL DEFAULT('Pending'),AttemptCount int NOT NULL DEFAULT(0),NextAttemptDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),LastError nvarchar(2000) NULL,CreatedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),SentDate datetime2(0) NULL);
IF OBJECT_ID('dbo.IHMS_ServiceLog','U') IS NULL CREATE TABLE dbo.IHMS_ServiceLog(LogID bigint IDENTITY PRIMARY KEY,Level varchar(10) NOT NULL,EventType varchar(50) NOT NULL,Message nvarchar(max) NOT NULL,Exception nvarchar(max) NULL,LoggedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()));
IF OBJECT_ID('dbo.IHMS_UserRole','U') IS NULL CREATE TABLE dbo.IHMS_UserRole(EmployeeID int NOT NULL,RoleCode varchar(30) NOT NULL,IsActive bit NOT NULL DEFAULT(1),GrantedBy int NOT NULL,GrantedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),CONSTRAINT PK_IHMS_UserRole PRIMARY KEY(EmployeeID,RoleCode));
GO
IF NOT EXISTS(SELECT 1 FROM dbo.IHMS_TicketStatus) INSERT dbo.IHMS_TicketStatus(StatusCode,StatusName,DisplayOrder) VALUES
('New','New',1),('Assigned','Assigned',2),('InProgress','In Progress',3),('PendingUser','Pending User',4),('PendingApproval','Pending Approval',5),('Approved','Approved',6),('Rejected','Rejected',7),('OnHold','On Hold',8),('Resolved','Resolved',9),('Closed','Closed',10),('Reopened','Reopened',11),('Cancelled','Cancelled',12);
IF NOT EXISTS(SELECT 1 FROM dbo.IHMS_Priority) INSERT dbo.IHMS_Priority(PriorityCode,PriorityName,DisplayOrder) VALUES('Low','Low',1),('Medium','Medium',2),('High','High',3),('Critical','Critical',4);
IF NOT EXISTS(SELECT 1 FROM dbo.IHMS_RequestType) INSERT dbo.IHMS_RequestType(Name,Description,ApprovalRequired,DisplayOrder,CreatedBy) VALUES('General IT Support','General hardware, software or access request',0,1,0),('Access Request','New or changed system access',1,2,0);
GO
IF OBJECT_ID('dbo.IHMS_fn_HasRole','FN') IS NOT NULL DROP FUNCTION dbo.IHMS_fn_HasRole;
GO
CREATE FUNCTION dbo.IHMS_fn_HasRole(@EmployeeID int,@RoleCode varchar(30)) RETURNS bit AS BEGIN RETURN CASE WHEN EXISTS(SELECT 1 FROM dbo.IHMS_UserRole WHERE EmployeeID=@EmployeeID AND RoleCode=@RoleCode AND IsActive=1) THEN 1 ELSE 0 END END
GO
IF OBJECT_ID('dbo.IHMS_vw_TicketSummary','V') IS NOT NULL DROP VIEW dbo.IHMS_vw_TicketSummary;
GO
CREATE VIEW dbo.IHMS_vw_TicketSummary AS SELECT t.TicketID,t.TicketNo,t.Subject,t.RequestorEmployeeID,t.RequestorName,t.RequestorEmail,t.Department,t.Location,rt.Name RequestType,p.PriorityCode,p.PriorityName,s.StatusCode,s.StatusName,t.AssignedToEmployeeID,t.Source,t.ApprovalStatus,t.CreatedDate,t.ModifiedDate,t.ResolvedDate,t.ClosedDate,t.SLADueDate,CAST(CASE WHEN t.SLADueDate<SYSDATETIME() AND s.StatusCode NOT IN('Resolved','Closed','Cancelled') THEN 1 ELSE 0 END AS bit) IsOverdue FROM dbo.IHMS_Ticket t LEFT JOIN dbo.IHMS_RequestType rt ON rt.RequestTypeID=t.RequestTypeID JOIN dbo.IHMS_Priority p ON p.PriorityID=t.PriorityID JOIN dbo.IHMS_TicketStatus s ON s.StatusID=t.StatusID;
GO
IF OBJECT_ID('dbo.IHMS_Ticket_Create','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Ticket_Create;
GO
CREATE PROCEDURE dbo.IHMS_Ticket_Create @RequestorEmployeeID int=NULL,@RequestorName nvarchar(150),@RequestorEmail nvarchar(254),@Department nvarchar(150)=NULL,@Location nvarchar(150)=NULL,@Subject nvarchar(300),@Description nvarchar(max),@RequestTypeID int=NULL,@PriorityCode varchar(20)='Medium',@Source varchar(20)='Portal',@GraphMessageID nvarchar(500)=NULL,@InternetMessageID nvarchar(500)=NULL,@CreatedBy int=NULL,@TicketID bigint OUTPUT AS
BEGIN SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN;
 IF @GraphMessageID IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.IHMS_Ticket WHERE GraphMessageID=@GraphMessageID) THROW 51000,'Duplicate Graph message.',1;
 DECLARE @PriorityID tinyint=(SELECT PriorityID FROM dbo.IHMS_Priority WHERE PriorityCode=@PriorityCode AND IsActive=1),@StatusID tinyint=(SELECT StatusID FROM dbo.IHMS_TicketStatus WHERE StatusCode='New'),@Approval bit=ISNULL((SELECT ApprovalRequired FROM dbo.IHMS_RequestType WHERE RequestTypeID=@RequestTypeID),0),@resolution int;
 IF @PriorityID IS NULL THROW 51001,'Invalid priority.',1; SELECT @resolution=ResolutionMinutes FROM dbo.IHMS_SLA WHERE PriorityID=@PriorityID AND IsActive=1;
 INSERT dbo.IHMS_Ticket(RequestorEmployeeID,RequestorName,RequestorEmail,Department,Location,Subject,Description,RequestTypeID,PriorityID,StatusID,Source,ApprovalRequired,SLADueDate,GraphMessageID,InternetMessageID,CreatedBy)
 VALUES(@RequestorEmployeeID,@RequestorName,@RequestorEmail,@Department,@Location,@Subject,@Description,@RequestTypeID,@PriorityID,@StatusID,@Source,@Approval,CASE WHEN @resolution IS NULL THEN NULL ELSE DATEADD(MINUTE,@resolution,SYSDATETIME()) END,@GraphMessageID,@InternetMessageID,@CreatedBy);
 SET @TicketID=SCOPE_IDENTITY(); DECLARE @TicketNo varchar(20)='IT-'+CONVERT(char(4),YEAR(SYSDATETIME()))+'-'+RIGHT('000000'+CONVERT(varchar(12),@TicketID),6); UPDATE dbo.IHMS_Ticket SET TicketNo=@TicketNo WHERE TicketID=@TicketID;
 INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,NewValue,Details,PerformedBy,PerformedName) VALUES(@TicketID,'Created',@TicketNo,@Subject,@CreatedBy,@RequestorName); COMMIT;
 SELECT @TicketID TicketID,@TicketNo TicketNo;
END
GO
IF OBJECT_ID('dbo.IHMS_Ticket_Get','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Ticket_Get;
GO
CREATE PROCEDURE dbo.IHMS_Ticket_Get @TicketID bigint,@EmployeeID int AS
BEGIN SET NOCOUNT ON; DECLARE @isIT bit=CASE WHEN dbo.IHMS_fn_HasRole(@EmployeeID,'ITUser')=1 OR dbo.IHMS_fn_HasRole(@EmployeeID,'ITHead')=1 OR dbo.IHMS_fn_HasRole(@EmployeeID,'HelpdeskAdmin')=1 THEN 1 ELSE 0 END;
 IF NOT EXISTS(SELECT 1 FROM dbo.IHMS_Ticket t WHERE t.TicketID=@TicketID AND (t.RequestorEmployeeID=@EmployeeID OR t.AssignedToEmployeeID=@EmployeeID OR @isIT=1 OR EXISTS(SELECT 1 FROM dbo.IHMS_TicketApproval a WHERE a.TicketID=t.TicketID AND a.ApproverEmployeeID=@EmployeeID))) THROW 51003,'Access denied.',1;
 SELECT v.*,t.Description,t.ApprovalRequired,t.FirstRespondedDate FROM dbo.IHMS_vw_TicketSummary v JOIN dbo.IHMS_Ticket t ON t.TicketID=v.TicketID WHERE v.TicketID=@TicketID;
 SELECT a.*,CASE WHEN a.IsInternal=1 THEN 'Internal' ELSE 'Public' END Visibility FROM dbo.IHMS_TicketActivity a WHERE a.TicketID=@TicketID AND (@isIT=1 OR a.IsInternal=0) ORDER BY a.PerformedDate,a.ActivityID;
 SELECT * FROM dbo.IHMS_TicketAttachment WHERE TicketID=@TicketID AND (@isIT=1 OR IsInternal=0) ORDER BY UploadedDate;
 SELECT * FROM dbo.IHMS_TicketApproval WHERE TicketID=@TicketID ORDER BY RequestedDate DESC;
END
GO
IF OBJECT_ID('dbo.IHMS_Ticket_List','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Ticket_List;
GO
CREATE PROCEDURE dbo.IHMS_Ticket_List @EmployeeID int,@Scope varchar(20)='Mine',@StatusCode varchar(30)=NULL,@TicketNo varchar(20)=NULL,@FromDate date=NULL,@ToDate date=NULL,@RequestTypeID int=NULL,@PriorityCode varchar(20)=NULL,@AssignedTo int=NULL,@Source varchar(20)=NULL,@ApprovalStatus varchar(20)=NULL AS
BEGIN SET NOCOUNT ON; DECLARE @isIT bit=CASE WHEN dbo.IHMS_fn_HasRole(@EmployeeID,'ITUser')=1 OR dbo.IHMS_fn_HasRole(@EmployeeID,'ITHead')=1 OR dbo.IHMS_fn_HasRole(@EmployeeID,'HelpdeskAdmin')=1 THEN 1 ELSE 0 END;
 SELECT v.* FROM dbo.IHMS_vw_TicketSummary v JOIN dbo.IHMS_Ticket t ON t.TicketID=v.TicketID WHERE
 ((@Scope='Own' AND t.RequestorEmployeeID=@EmployeeID) OR (@Scope='Mine' AND t.AssignedToEmployeeID=@EmployeeID) OR (@Scope='Bucket' AND t.AssignedToEmployeeID IS NULL AND @isIT=1) OR (@Scope='All' AND @isIT=1))
 AND (@StatusCode IS NULL OR @StatusCode='' OR v.StatusCode=@StatusCode) AND (@TicketNo IS NULL OR v.TicketNo LIKE '%'+@TicketNo+'%') AND (@FromDate IS NULL OR v.CreatedDate>=@FromDate) AND (@ToDate IS NULL OR v.CreatedDate<DATEADD(day,1,@ToDate)) AND (@RequestTypeID IS NULL OR t.RequestTypeID=@RequestTypeID) AND (@PriorityCode IS NULL OR v.PriorityCode=@PriorityCode) AND (@AssignedTo IS NULL OR t.AssignedToEmployeeID=@AssignedTo) AND (@Source IS NULL OR t.Source=@Source) AND (@ApprovalStatus IS NULL OR t.ApprovalStatus=@ApprovalStatus) ORDER BY v.ModifiedDate DESC;
END
GO
IF OBJECT_ID('dbo.IHMS_Ticket_Assign','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Ticket_Assign;
GO
CREATE PROCEDURE dbo.IHMS_Ticket_Assign @TicketID bigint,@ToEmployeeID int,@ByEmployeeID int AS
BEGIN SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN; DECLARE @old int,@status varchar(30); SELECT @old=AssignedToEmployeeID,@status=s.StatusCode FROM dbo.IHMS_Ticket t JOIN dbo.IHMS_TicketStatus s ON s.StatusID=t.StatusID WHERE TicketID=@TicketID;
 IF @status='PendingApproval' THROW 51004,'Ticket is locked pending approval.',1; IF dbo.IHMS_fn_HasRole(@ByEmployeeID,'ITHead')=0 AND dbo.IHMS_fn_HasRole(@ByEmployeeID,'HelpdeskAdmin')=0 AND NOT(@ToEmployeeID=@ByEmployeeID AND @old IS NULL) THROW 51003,'Assignment not authorized.',1;
 UPDATE dbo.IHMS_Ticket SET AssignedToEmployeeID=@ToEmployeeID,StatusID=CASE WHEN @status='New' THEN (SELECT StatusID FROM dbo.IHMS_TicketStatus WHERE StatusCode='Assigned') ELSE StatusID END,ModifiedBy=@ByEmployeeID,ModifiedDate=SYSDATETIME() WHERE TicketID=@TicketID;
 INSERT dbo.IHMS_TicketAssignmentHistory(TicketID,FromEmployeeID,ToEmployeeID,AssignedBy) VALUES(@TicketID,@old,@ToEmployeeID,@ByEmployeeID); INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,OldValue,NewValue,PerformedBy) VALUES(@TicketID,'Assignment',CONVERT(varchar(20),@old),CONVERT(varchar(20),@ToEmployeeID),@ByEmployeeID); COMMIT; END
GO
IF OBJECT_ID('dbo.IHMS_Ticket_ChangeType','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Ticket_ChangeType;
GO
CREATE PROCEDURE dbo.IHMS_Ticket_ChangeType @TicketID bigint,@RequestTypeID int,@EmployeeID int AS
BEGIN SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN; DECLARE @old int,@pending bit=0,@req bit; SELECT @old=RequestTypeID FROM dbo.IHMS_Ticket WHERE TicketID=@TicketID; SELECT @req=ApprovalRequired FROM dbo.IHMS_RequestType WHERE RequestTypeID=@RequestTypeID AND IsActive=1; IF @req IS NULL THROW 51005,'Invalid request type.',1; SELECT @pending=CASE WHEN EXISTS(SELECT 1 FROM dbo.IHMS_TicketApproval WHERE TicketID=@TicketID AND ApprovalStatus='Pending') THEN 1 ELSE 0 END; IF @pending=1 THROW 51004,'Ticket is locked pending approval.',1;
 UPDATE dbo.IHMS_Ticket SET RequestTypeID=@RequestTypeID,ApprovalRequired=@req,ApprovalStatus=CASE WHEN @req=0 AND ApprovalStatus IS NULL THEN NULL ELSE ApprovalStatus END,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHERE TicketID=@TicketID; INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,OldValue,NewValue,PerformedBy) VALUES(@TicketID,'RequestType',CONVERT(varchar(20),@old),CONVERT(varchar(20),@RequestTypeID),@EmployeeID); COMMIT; END
GO
IF OBJECT_ID('dbo.IHMS_Ticket_AddRemark','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Ticket_AddRemark;
GO
CREATE PROCEDURE dbo.IHMS_Ticket_AddRemark @TicketID bigint,@EmployeeID int,@EmployeeName nvarchar(150),@Remark nvarchar(max),@IsInternal bit AS
BEGIN SET NOCOUNT ON; IF EXISTS(SELECT 1 FROM dbo.IHMS_Ticket t JOIN dbo.IHMS_TicketStatus s ON s.StatusID=t.StatusID WHERE t.TicketID=@TicketID AND s.StatusCode='PendingApproval') THROW 51004,'Ticket is locked pending approval.',1; IF @IsInternal=1 AND dbo.IHMS_fn_HasRole(@EmployeeID,'ITUser')=0 AND dbo.IHMS_fn_HasRole(@EmployeeID,'ITHead')=0 AND dbo.IHMS_fn_HasRole(@EmployeeID,'HelpdeskAdmin')=0 THROW 51003,'Internal notes are IT-only.',1;
 INSERT dbo.IHMS_TicketRemark(TicketID,Remark,IsInternal,CreatedBy,CreatedName) VALUES(@TicketID,@Remark,@IsInternal,@EmployeeID,@EmployeeName); INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,Details,IsInternal,PerformedBy,PerformedName) VALUES(@TicketID,CASE WHEN @IsInternal=1 THEN 'InternalNote' ELSE 'PublicRemark' END,@Remark,@IsInternal,@EmployeeID,@EmployeeName); UPDATE dbo.IHMS_Ticket SET FirstRespondedDate=CASE WHEN FirstRespondedDate IS NULL AND @IsInternal=0 THEN SYSDATETIME() ELSE FirstRespondedDate END,ModifiedDate=SYSDATETIME(),ModifiedBy=@EmployeeID WHERE TicketID=@TicketID; END
GO
IF OBJECT_ID('dbo.IHMS_Ticket_Transition','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Ticket_Transition;
GO
CREATE PROCEDURE dbo.IHMS_Ticket_Transition @TicketID bigint,@StatusCode varchar(30),@EmployeeID int,@Remark nvarchar(2000) AS
BEGIN SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN; DECLARE @old varchar(30),@newID tinyint; SELECT @old=s.StatusCode FROM dbo.IHMS_Ticket t JOIN dbo.IHMS_TicketStatus s ON s.StatusID=t.StatusID WHERE t.TicketID=@TicketID; SELECT @newID=StatusID FROM dbo.IHMS_TicketStatus WHERE StatusCode=@StatusCode AND IsActive=1; IF @newID IS NULL THROW 51005,'Invalid status.',1; IF @old='PendingApproval' THROW 51004,'Ticket is locked pending approval.',1;
 IF NOT ((@old IN('New','Assigned','Approved','Rejected','Reopened','PendingUser','OnHold') AND @StatusCode IN('Assigned','InProgress','PendingUser','OnHold','Resolved','Cancelled')) OR (@old='InProgress' AND @StatusCode IN('PendingUser','OnHold','Resolved','Cancelled')) OR (@old='Resolved' AND @StatusCode IN('Closed','Reopened')) OR (@old='Closed' AND @StatusCode='Reopened')) THROW 51006,'Invalid status transition.',1;
 UPDATE dbo.IHMS_Ticket SET StatusID=@newID,ResolvedDate=CASE WHEN @StatusCode='Resolved' THEN SYSDATETIME() ELSE ResolvedDate END,ClosedDate=CASE WHEN @StatusCode='Closed' THEN SYSDATETIME() ELSE ClosedDate END,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHERE TicketID=@TicketID; INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,OldValue,NewValue,Details,PerformedBy) VALUES(@TicketID,'Status',@old,@StatusCode,@Remark,@EmployeeID); COMMIT; END
GO
IF OBJECT_ID('dbo.IHMS_Approval_Request','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Approval_Request;
GO
CREATE PROCEDURE dbo.IHMS_Approval_Request @TicketID bigint,@ApproverEmployeeID int,@EmployeeID int,@Remark nvarchar(1000)=NULL AS
BEGIN SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN; IF NOT EXISTS(SELECT 1 FROM dbo.IHMS_Ticket WHERE TicketID=@TicketID AND ApprovalRequired=1) THROW 51007,'Approval is not required.',1; IF EXISTS(SELECT 1 FROM dbo.IHMS_TicketApproval WHERE TicketID=@TicketID AND ApprovalStatus='Pending') THROW 51008,'Approval is already pending.',1;
 INSERT dbo.IHMS_TicketApproval(TicketID,ApproverEmployeeID,RequestRemark,RequestedBy) VALUES(@TicketID,@ApproverEmployeeID,@Remark,@EmployeeID); UPDATE dbo.IHMS_Ticket SET StatusID=(SELECT StatusID FROM dbo.IHMS_TicketStatus WHERE StatusCode='PendingApproval'),ApprovalStatus='Pending',ModifiedDate=SYSDATETIME(),ModifiedBy=@EmployeeID WHERE TicketID=@TicketID; INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,NewValue,Details,PerformedBy) VALUES(@TicketID,'ApprovalRequested',CONVERT(varchar(20),@ApproverEmployeeID),@Remark,@EmployeeID); COMMIT; END
GO
IF OBJECT_ID('dbo.IHMS_Approval_Decide','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Approval_Decide;
GO
CREATE PROCEDURE dbo.IHMS_Approval_Decide @ApprovalID bigint,@EmployeeID int,@Decision varchar(20),@Remark nvarchar(2000) AS
BEGIN SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN; IF NULLIF(LTRIM(RTRIM(@Remark)),'') IS NULL THROW 51009,'Decision remark is mandatory.',1; IF @Decision NOT IN('Approved','Rejected') THROW 51005,'Invalid decision.',1; DECLARE @ticket bigint; SELECT @ticket=TicketID FROM dbo.IHMS_TicketApproval WHERE ApprovalID=@ApprovalID AND ApproverEmployeeID=@EmployeeID AND ApprovalStatus='Pending'; IF @ticket IS NULL THROW 51003,'Approval not found or access denied.',1;
 UPDATE dbo.IHMS_TicketApproval SET ApprovalStatus=@Decision,DecisionRemark=@Remark,DecisionDate=SYSDATETIME() WHERE ApprovalID=@ApprovalID; UPDATE dbo.IHMS_Ticket SET ApprovalStatus=@Decision,StatusID=(SELECT StatusID FROM dbo.IHMS_TicketStatus WHERE StatusCode=CASE WHEN @Decision='Approved' THEN 'Approved' ELSE 'Rejected' END),ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHERE TicketID=@ticket; INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,NewValue,Details,PerformedBy) VALUES(@ticket,'ApprovalDecision',@Decision,@Remark,@EmployeeID); COMMIT; END
GO
IF OBJECT_ID('dbo.IHMS_Approval_List','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Approval_List;
GO
CREATE PROCEDURE dbo.IHMS_Approval_List @EmployeeID int,@Decision varchar(20)=NULL AS SELECT a.*,t.TicketNo,t.Subject,t.RequestorName,t.RequestorEmail,rt.Name RequestType,p.PriorityName FROM dbo.IHMS_TicketApproval a JOIN dbo.IHMS_Ticket t ON t.TicketID=a.TicketID LEFT JOIN dbo.IHMS_RequestType rt ON rt.RequestTypeID=t.RequestTypeID JOIN dbo.IHMS_Priority p ON p.PriorityID=t.PriorityID WHERE a.ApproverEmployeeID=@EmployeeID AND (@Decision IS NULL OR a.ApprovalStatus=@Decision) ORDER BY CASE WHEN a.ApprovalStatus='Pending' THEN 0 ELSE 1 END,a.RequestedDate DESC;
GO
IF OBJECT_ID('dbo.IHMS_Master_Data','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Master_Data;
GO
CREATE PROCEDURE dbo.IHMS_Master_Data @EmployeeID int AS BEGIN SET NOCOUNT ON; SELECT RequestTypeID,Name,Description,ApprovalRequired,IsActive,DisplayOrder FROM dbo.IHMS_RequestType ORDER BY DisplayOrder,Name; SELECT StatusCode,StatusName FROM dbo.IHMS_TicketStatus WHERE IsActive=1 ORDER BY DisplayOrder; SELECT PriorityCode,PriorityName FROM dbo.IHMS_Priority WHERE IsActive=1 ORDER BY DisplayOrder; SELECT RoleCode FROM dbo.IHMS_UserRole WHERE EmployeeID=@EmployeeID AND IsActive=1; SELECT s.SLAID,p.PriorityCode,p.PriorityName,s.FirstResponseMinutes,s.ResolutionMinutes,s.IsActive FROM dbo.IHMS_SLA s JOIN dbo.IHMS_Priority p ON p.PriorityID=s.PriorityID ORDER BY p.DisplayOrder; END
GO
IF OBJECT_ID('dbo.IHMS_RequestType_Save','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_RequestType_Save;
GO
CREATE PROCEDURE dbo.IHMS_RequestType_Save @RequestTypeID int=0,@Name nvarchar(120),@Description nvarchar(500)=NULL,@ApprovalRequired bit,@IsActive bit,@DisplayOrder int,@EmployeeID int AS BEGIN IF dbo.IHMS_fn_HasRole(@EmployeeID,'HelpdeskAdmin')=0 THROW 51003,'Admin role required.',1; IF @RequestTypeID=0 INSERT dbo.IHMS_RequestType(Name,Description,ApprovalRequired,IsActive,DisplayOrder,CreatedBy) VALUES(@Name,@Description,@ApprovalRequired,@IsActive,@DisplayOrder,@EmployeeID); ELSE UPDATE dbo.IHMS_RequestType SET Name=@Name,Description=@Description,ApprovalRequired=@ApprovalRequired,IsActive=@IsActive,DisplayOrder=@DisplayOrder,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHERE RequestTypeID=@RequestTypeID; END
GO
IF OBJECT_ID('dbo.IHMS_SLA_Save','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_SLA_Save;
GO
CREATE PROCEDURE dbo.IHMS_SLA_Save @PriorityCode varchar(20),@FirstResponseMinutes int,@ResolutionMinutes int,@IsActive bit,@EmployeeID int AS BEGIN IF dbo.IHMS_fn_HasRole(@EmployeeID,'HelpdeskAdmin')=0 THROW 51003,'Admin role required.',1; DECLARE @p tinyint=(SELECT PriorityID FROM dbo.IHMS_Priority WHERE PriorityCode=@PriorityCode); MERGE dbo.IHMS_SLA AS d USING(SELECT @p PriorityID)s ON d.PriorityID=s.PriorityID WHEN MATCHED THEN UPDATE SET FirstResponseMinutes=@FirstResponseMinutes,ResolutionMinutes=@ResolutionMinutes,IsActive=@IsActive,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHEN NOT MATCHED THEN INSERT(PriorityID,FirstResponseMinutes,ResolutionMinutes,IsActive,CreatedBy) VALUES(@p,@FirstResponseMinutes,@ResolutionMinutes,@IsActive,@EmployeeID); END
GO
IF OBJECT_ID('dbo.IHMS_Dashboard','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Dashboard;
GO
CREATE PROCEDURE dbo.IHMS_Dashboard @EmployeeID int AS BEGIN SET NOCOUNT ON; SELECT SUM(CASE WHEN StatusCode='New' THEN 1 ELSE 0 END) NewCount,SUM(CASE WHEN StatusCode NOT IN('Resolved','Closed','Cancelled') THEN 1 ELSE 0 END) OpenCount,SUM(CASE WHEN StatusCode='Assigned' THEN 1 ELSE 0 END) AssignedCount,SUM(CASE WHEN StatusCode='InProgress' THEN 1 ELSE 0 END) InProgressCount,SUM(CASE WHEN StatusCode='PendingUser' THEN 1 ELSE 0 END) PendingUserCount,SUM(CASE WHEN StatusCode='PendingApproval' THEN 1 ELSE 0 END) PendingApprovalCount,SUM(CASE WHEN CONVERT(date,ResolvedDate)=CONVERT(date,GETDATE()) THEN 1 ELSE 0 END) ResolvedToday,SUM(CASE WHEN CONVERT(date,ClosedDate)=CONVERT(date,GETDATE()) THEN 1 ELSE 0 END) ClosedToday,SUM(CASE WHEN IsOverdue=1 THEN 1 ELSE 0 END) OverdueCount,COUNT(*) TotalCount FROM dbo.IHMS_vw_TicketSummary; SELECT StatusName Label,COUNT(*) Value FROM dbo.IHMS_vw_TicketSummary GROUP BY StatusName; SELECT ISNULL(RequestType,'Unclassified') Label,COUNT(*) Value FROM dbo.IHMS_vw_TicketSummary GROUP BY RequestType; SELECT PriorityName Label,COUNT(*) Value FROM dbo.IHMS_vw_TicketSummary GROUP BY PriorityName; SELECT CONVERT(date,CreatedDate) [Day],COUNT(*) Created,SUM(CASE WHEN ClosedDate IS NOT NULL THEN 1 ELSE 0 END) Closed FROM dbo.IHMS_vw_TicketSummary WHERE CreatedDate>=DATEADD(day,-29,CONVERT(date,GETDATE())) GROUP BY CONVERT(date,CreatedDate) ORDER BY [Day]; END
GO
IF OBJECT_ID('dbo.IHMS_Performance','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Performance;
GO
CREATE PROCEDURE dbo.IHMS_Performance @FromDate date,@ToDate date,@EmployeeID int=NULL,@RequestTypeID int=NULL,@PriorityCode varchar(20)=NULL AS SELECT t.AssignedToEmployeeID EmployeeID,COUNT(*) Assigned,SUM(CASE WHEN s.StatusCode NOT IN('Resolved','Closed','Cancelled') THEN 1 ELSE 0 END) [Open],SUM(CASE WHEN s.StatusCode='Resolved' THEN 1 ELSE 0 END) Resolved,SUM(CASE WHEN s.StatusCode='Closed' THEN 1 ELSE 0 END) Closed,SUM(CASE WHEN t.SLADueDate<SYSDATETIME() AND s.StatusCode NOT IN('Resolved','Closed','Cancelled') THEN 1 ELSE 0 END) Overdue,SUM(CASE WHEN s.StatusCode='Reopened' THEN 1 ELSE 0 END) Reopened,AVG(CAST(DATEDIFF(minute,t.CreatedDate,t.FirstRespondedDate) AS decimal(18,2))) AvgFirstResponseMinutes,AVG(CAST(DATEDIFF(minute,t.CreatedDate,t.ResolvedDate) AS decimal(18,2))) AvgResolutionMinutes,SUM(CASE WHEN t.ResolvedDate<=t.SLADueDate THEN 1 ELSE 0 END) SLAMet,SUM(CASE WHEN t.ResolvedDate>t.SLADueDate THEN 1 ELSE 0 END) SLAMissed,CAST(100.0*SUM(CASE WHEN t.ResolvedDate<=t.SLADueDate THEN 1 ELSE 0 END)/NULLIF(SUM(CASE WHEN t.ResolvedDate IS NOT NULL AND t.SLADueDate IS NOT NULL THEN 1 ELSE 0 END),0) AS decimal(5,2)) SLAPercent FROM dbo.IHMS_Ticket t JOIN dbo.IHMS_TicketStatus s ON s.StatusID=t.StatusID JOIN dbo.IHMS_Priority p ON p.PriorityID=t.PriorityID WHERE t.CreatedDate>=@FromDate AND t.CreatedDate<DATEADD(day,1,@ToDate) AND (@EmployeeID IS NULL OR t.AssignedToEmployeeID=@EmployeeID) AND (@RequestTypeID IS NULL OR t.RequestTypeID=@RequestTypeID) AND (@PriorityCode IS NULL OR p.PriorityCode=@PriorityCode) GROUP BY t.AssignedToEmployeeID;
GO
IF OBJECT_ID('dbo.IHMS_Email_Ingest','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Email_Ingest;
GO
CREATE PROCEDURE dbo.IHMS_Email_Ingest @GraphMessageID nvarchar(500),@InternetMessageID nvarchar(500)=NULL,@FromAddress nvarchar(254),@FromName nvarchar(150),@Subject nvarchar(500),@Body nvarchar(max),@ReceivedDate datetime2(0) AS
BEGIN SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN;
 IF EXISTS(SELECT 1 FROM dbo.IHMS_TicketEmail WHERE GraphMessageID=@GraphMessageID) BEGIN SELECT TicketID,CAST(0 AS bit) IsNew,TicketNo FROM dbo.IHMS_Ticket WHERE TicketID=(SELECT TOP 1 TicketID FROM dbo.IHMS_TicketEmail WHERE GraphMessageID=@GraphMessageID); COMMIT; RETURN; END
 DECLARE @ticket bigint,@ticketNo varchar(20),@token varchar(20); SELECT TOP 1 @token=SUBSTRING(@Subject,n.number,14) FROM master..spt_values n WHERE n.type='P' AND n.number BETWEEN 1 AND LEN(@Subject)-13 AND SUBSTRING(@Subject,n.number,3)='IT-' AND SUBSTRING(@Subject,n.number+7,1)='-' ORDER BY n.number;
 SELECT @ticket=TicketID,@ticketNo=TicketNo FROM dbo.IHMS_Ticket WHERE TicketNo=@token;
 IF @ticket IS NULL BEGIN DECLARE @priority tinyint=(SELECT PriorityID FROM dbo.IHMS_Priority WHERE PriorityCode='Medium'),@status tinyint=(SELECT StatusID FROM dbo.IHMS_TicketStatus WHERE StatusCode='New'),@resolution int=(SELECT s.ResolutionMinutes FROM dbo.IHMS_SLA s WHERE s.PriorityID=(SELECT PriorityID FROM dbo.IHMS_Priority WHERE PriorityCode='Medium') AND s.IsActive=1);
  INSERT dbo.IHMS_Ticket(RequestorName,RequestorEmail,Subject,Description,PriorityID,StatusID,Source,GraphMessageID,InternetMessageID,CreatedDate,ModifiedDate,SLADueDate) VALUES(COALESCE(NULLIF(@FromName,''),@FromAddress),@FromAddress,@Subject,@Body,@priority,@status,'Email',@GraphMessageID,@InternetMessageID,@ReceivedDate,@ReceivedDate,CASE WHEN @resolution IS NULL THEN NULL ELSE DATEADD(minute,@resolution,@ReceivedDate) END); SET @ticket=SCOPE_IDENTITY(); SET @ticketNo='IT-'+CONVERT(char(4),YEAR(@ReceivedDate))+'-'+RIGHT('000000'+CONVERT(varchar(12),@ticket),6); UPDATE dbo.IHMS_Ticket SET TicketNo=@ticketNo WHERE TicketID=@ticket; INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,NewValue,Details,PerformedName,PerformedDate) VALUES(@ticket,'Created',@ticketNo,'Created from shared mailbox',@FromName,@ReceivedDate);
  INSERT dbo.IHMS_EmailQueue(TicketID,ToAddresses,Subject,Body) VALUES(@ticket,@FromAddress,'['+@ticketNo+'] '+@Subject,'Your IT request has been received.<br/><br/><b>Ticket:</b> '+@ticketNo+'<br/>Please reply with the ticket number in the subject.'); END
 ELSE BEGIN INSERT dbo.IHMS_TicketRemark(TicketID,Remark,IsInternal,CreatedName,CreatedDate) VALUES(@ticket,@Body,0,@FromName,@ReceivedDate); INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,Details,PerformedName,PerformedDate) VALUES(@ticket,'InboundEmail',@Body,@FromName,@ReceivedDate); UPDATE dbo.IHMS_Ticket SET ModifiedDate=@ReceivedDate WHERE TicketID=@ticket; END
 INSERT dbo.IHMS_TicketEmail(TicketID,Direction,GraphMessageID,InternetMessageID,FromAddress,Subject,Body,SentReceivedDate) VALUES(@ticket,'Inbound',@GraphMessageID,@InternetMessageID,@FromAddress,@Subject,@Body,@ReceivedDate); COMMIT; SELECT @ticket TicketID,CAST(CASE WHEN @token IS NULL THEN 1 ELSE 0 END AS bit) IsNew,@ticketNo TicketNo;
END
GO
IF OBJECT_ID('dbo.IHMS_EmailQueue_Claim','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_EmailQueue_Claim;
GO
CREATE PROCEDURE dbo.IHMS_EmailQueue_Claim AS BEGIN SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN; DECLARE @id bigint; SELECT TOP 1 @id=QueueID FROM dbo.IHMS_EmailQueue WITH(UPDLOCK,READPAST,ROWLOCK) WHERE Status='Pending' AND NextAttemptDate<=SYSDATETIME() ORDER BY QueueID; UPDATE dbo.IHMS_EmailQueue SET Status='Processing',AttemptCount=AttemptCount+1 WHERE QueueID=@id; SELECT * FROM dbo.IHMS_EmailQueue WHERE QueueID=@id; COMMIT; END
GO
IF OBJECT_ID('dbo.IHMS_EmailQueue_Complete','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_EmailQueue_Complete;
GO
CREATE PROCEDURE dbo.IHMS_EmailQueue_Complete @QueueID bigint,@Succeeded bit,@Error nvarchar(2000)=NULL,@GraphMessageID nvarchar(500)=NULL AS BEGIN SET NOCOUNT ON; UPDATE dbo.IHMS_EmailQueue SET Status=CASE WHEN @Succeeded=1 THEN 'Sent' WHEN AttemptCount>=5 THEN 'Failed' ELSE 'Pending' END,SentDate=CASE WHEN @Succeeded=1 THEN SYSDATETIME() ELSE NULL END,LastError=@Error,NextAttemptDate=DATEADD(minute,POWER(2,AttemptCount),SYSDATETIME()) WHERE QueueID=@QueueID; IF @Succeeded=1 INSERT dbo.IHMS_TicketEmail(TicketID,Direction,GraphMessageID,ToAddresses,CcAddresses,Subject,Body,SentReceivedDate) SELECT TicketID,'Outbound',@GraphMessageID,ToAddresses,CcAddresses,Subject,Body,SYSDATETIME() FROM dbo.IHMS_EmailQueue WHERE QueueID=@QueueID; END
GO
IF OBJECT_ID('dbo.IHMS_tr_TicketActivity_Notify','TR') IS NOT NULL DROP TRIGGER dbo.IHMS_tr_TicketActivity_Notify;
GO
CREATE TRIGGER dbo.IHMS_tr_TicketActivity_Notify ON dbo.IHMS_TicketActivity AFTER INSERT AS
BEGIN SET NOCOUNT ON;
 INSERT dbo.IHMS_EmailQueue(TicketID,ToAddresses,CcAddresses,Subject,Body)
 SELECT i.TicketID,t.RequestorEmail,
  CASE WHEN t.AssignedToEmployeeID IS NULL THEN NULL ELSE (SELECT TOP 1 OfficialEmailID FROM dbo.EmployeeInfo WHERE EmployeeID=t.AssignedToEmployeeID) END,
  '['+t.TicketNo+'] '+t.Subject,
  '<b>'+REPLACE(i.ActivityType,'InternalNote','')+'</b><br/>'+COALESCE(i.Details,'')+CASE WHEN i.NewValue IS NULL THEN '' ELSE '<br/>New value: '+i.NewValue END
 FROM inserted i JOIN dbo.IHMS_Ticket t ON t.TicketID=i.TicketID
 WHERE i.IsInternal=0 AND i.ActivityType IN('Created','Assignment','RequestType','Priority','Status','PublicRemark','ApprovalDecision','Resolved','Closed','Reopened') AND NOT(i.ActivityType='Created' AND t.Source='Email');
 INSERT dbo.IHMS_EmailQueue(TicketID,ToAddresses,Subject,Body)
 SELECT i.TicketID,(SELECT TOP 1 OfficialEmailID FROM dbo.EmployeeInfo WHERE EmployeeID=TRY_CONVERT(int,i.NewValue)),'['+t.TicketNo+'] Approval required - '+t.Subject,'A helpdesk ticket requires your decision.<br/>Ticket: '+t.TicketNo+'<br/>'+COALESCE(i.Details,'')
 FROM inserted i JOIN dbo.IHMS_Ticket t ON t.TicketID=i.TicketID WHERE i.ActivityType='ApprovalRequested';
END
GO
IF OBJECT_ID('dbo.IHMS_Ticket_ChangePriority','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Ticket_ChangePriority;
GO
CREATE PROCEDURE dbo.IHMS_Ticket_ChangePriority @TicketID bigint,@PriorityCode varchar(20),@EmployeeID int AS
BEGIN SET NOCOUNT ON; IF dbo.IHMS_fn_HasRole(@EmployeeID,'ITUser')=0 AND dbo.IHMS_fn_HasRole(@EmployeeID,'ITHead')=0 AND dbo.IHMS_fn_HasRole(@EmployeeID,'HelpdeskAdmin')=0 THROW 51003,'IT role required.',1; IF EXISTS(SELECT 1 FROM dbo.IHMS_Ticket t JOIN dbo.IHMS_TicketStatus s ON s.StatusID=t.StatusID WHERE t.TicketID=@TicketID AND s.StatusCode='PendingApproval') THROW 51004,'Ticket is locked pending approval.',1; DECLARE @new tinyint=(SELECT PriorityID FROM dbo.IHMS_Priority WHERE PriorityCode=@PriorityCode AND IsActive=1),@old varchar(20),@minutes int; SELECT @old=p.PriorityCode FROM dbo.IHMS_Ticket t JOIN dbo.IHMS_Priority p ON p.PriorityID=t.PriorityID WHERE t.TicketID=@TicketID; SELECT @minutes=ResolutionMinutes FROM dbo.IHMS_SLA WHERE PriorityID=@new AND IsActive=1; IF @new IS NULL THROW 51005,'Invalid priority.',1; UPDATE dbo.IHMS_Ticket SET PriorityID=@new,SLADueDate=CASE WHEN @minutes IS NULL THEN NULL ELSE DATEADD(minute,@minutes,CreatedDate) END,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHERE TicketID=@TicketID; INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,OldValue,NewValue,PerformedBy) VALUES(@TicketID,'Priority',@old,@PriorityCode,@EmployeeID); END
GO
IF OBJECT_ID('dbo.IHMS_Approval_Cancel','P') IS NOT NULL DROP PROCEDURE dbo.IHMS_Approval_Cancel;
GO
CREATE PROCEDURE dbo.IHMS_Approval_Cancel @ApprovalID bigint,@EmployeeID int,@Remark nvarchar(2000) AS
BEGIN SET NOCOUNT ON; IF dbo.IHMS_fn_HasRole(@EmployeeID,'ITHead')=0 AND dbo.IHMS_fn_HasRole(@EmployeeID,'HelpdeskAdmin')=0 THROW 51003,'IT Head or Helpdesk Admin role required.',1; SET XACT_ABORT ON; BEGIN TRAN; DECLARE @ticket bigint; SELECT @ticket=TicketID FROM dbo.IHMS_TicketApproval WHERE ApprovalID=@ApprovalID AND ApprovalStatus='Pending'; IF @ticket IS NULL THROW 51005,'Pending approval not found.',1; UPDATE dbo.IHMS_TicketApproval SET ApprovalStatus='Cancelled',DecisionRemark=@Remark,CancelledBy=@EmployeeID,CancelledDate=SYSDATETIME() WHERE ApprovalID=@ApprovalID; UPDATE dbo.IHMS_Ticket SET ApprovalStatus='Cancelled',StatusID=(SELECT StatusID FROM dbo.IHMS_TicketStatus WHERE StatusCode='Assigned'),ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHERE TicketID=@ticket; INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,NewValue,Details,PerformedBy) VALUES(@ticket,'ApprovalDecision','Cancelled',@Remark,@EmployeeID); COMMIT; END
GO
