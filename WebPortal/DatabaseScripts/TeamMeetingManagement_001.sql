/* Team Meeting Management - SQL Server 2016. Run once against MainCon. */
SET XACT_ABORT ON;

IF TYPE_ID(N'dbo.team_IntList') IS NULL EXEC('CREATE TYPE dbo.team_IntList AS TABLE(ID int NOT NULL PRIMARY KEY)');
IF TYPE_ID(N'dbo.team_EmployeeList') IS NULL EXEC('CREATE TYPE dbo.team_EmployeeList AS TABLE(ID bigint NOT NULL PRIMARY KEY)');
IF TYPE_ID(N'dbo.team_AttendanceList') IS NULL EXEC('CREATE TYPE dbo.team_AttendanceList AS TABLE(EmployeeID bigint NOT NULL PRIMARY KEY,AttendanceStatus varchar(20) NOT NULL)');
IF TYPE_ID(N'dbo.team_ActionItemList') IS NULL EXEC('CREATE TYPE dbo.team_ActionItemList AS TABLE(ActionItemID bigint NOT NULL,Description nvarchar(1000) NOT NULL,AssignedTo bigint NOT NULL,DueDate date NULL,Status varchar(20) NOT NULL,Remarks nvarchar(1000) NULL)');

IF OBJECT_ID(N'dbo.team_Permission',N'U') IS NULL CREATE TABLE dbo.team_Permission(
 EmployeeID bigint NOT NULL CONSTRAINT PK_team_Permission PRIMARY KEY,
 CanManageTeams bit NOT NULL CONSTRAINT DF_team_Permission_Teams DEFAULT(0),CanManageMeetings bit NOT NULL CONSTRAINT DF_team_Permission_Meetings DEFAULT(0),
 CanViewAll bit NOT NULL CONSTRAINT DF_team_Permission_View DEFAULT(0),CanEditAll bit NOT NULL CONSTRAINT DF_team_Permission_Edit DEFAULT(0),CanCreateFuture bit NOT NULL CONSTRAINT DF_team_Permission_Future DEFAULT(0),
 IsActive bit NOT NULL CONSTRAINT DF_team_Permission_Active DEFAULT(1),AddedBy bigint NOT NULL,AddedDate datetime2(0) NOT NULL CONSTRAINT DF_team_Permission_Date DEFAULT(SYSDATETIME()),
 CONSTRAINT FK_team_Permission_Employee FOREIGN KEY(EmployeeID) REFERENCES dbo.EmployeeInfo(EmployeeID));

IF OBJECT_ID(N'dbo.team_Team',N'U') IS NULL CREATE TABLE dbo.team_Team(
 TeamID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_team_Team PRIMARY KEY,TeamName nvarchar(150) NOT NULL,ProjectID int NOT NULL,Description nvarchar(1000) NULL,ManagerEmployeeID bigint NULL,
 IsActive bit NOT NULL CONSTRAINT DF_team_Team_Active DEFAULT(1),CreatedBy bigint NOT NULL,CreatedDate datetime2(0) NOT NULL CONSTRAINT DF_team_Team_Created DEFAULT(SYSDATETIME()),ModifiedBy bigint NULL,ModifiedDate datetime2(0) NULL,RowVersion rowversion NOT NULL,
 CONSTRAINT FK_team_Team_Project FOREIGN KEY(ProjectID) REFERENCES dbo.Project(ProjectID),CONSTRAINT FK_team_Team_Manager FOREIGN KEY(ManagerEmployeeID) REFERENCES dbo.EmployeeInfo(EmployeeID),CONSTRAINT FK_team_Team_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES dbo.EmployeeInfo(EmployeeID));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='UX_team_Team_ActiveNameProject') CREATE UNIQUE INDEX UX_team_Team_ActiveNameProject ON dbo.team_Team(ProjectID,TeamName) WHERE IsActive=1;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_team_Team_Project') CREATE INDEX IX_team_Team_Project ON dbo.team_Team(ProjectID,IsActive);

IF OBJECT_ID(N'dbo.team_TeamEmployee',N'U') IS NULL CREATE TABLE dbo.team_TeamEmployee(
 TeamEmployeeID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_team_TeamEmployee PRIMARY KEY,TeamID int NOT NULL,EmployeeID bigint NOT NULL,IsActive bit NOT NULL CONSTRAINT DF_team_TeamEmployee_Active DEFAULT(1),EffectiveFrom datetime2(0) NOT NULL CONSTRAINT DF_team_TeamEmployee_From DEFAULT(SYSDATETIME()),EffectiveTo datetime2(0) NULL,AddedBy bigint NOT NULL,AddedDate datetime2(0) NOT NULL CONSTRAINT DF_team_TeamEmployee_Added DEFAULT(SYSDATETIME()),
 CONSTRAINT FK_team_TeamEmployee_Team FOREIGN KEY(TeamID) REFERENCES dbo.team_Team(TeamID),CONSTRAINT FK_team_TeamEmployee_Employee FOREIGN KEY(EmployeeID) REFERENCES dbo.EmployeeInfo(EmployeeID));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='UX_team_TeamEmployee_Active') CREATE UNIQUE INDEX UX_team_TeamEmployee_Active ON dbo.team_TeamEmployee(TeamID,EmployeeID) WHERE IsActive=1;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_team_TeamEmployee_Employee') CREATE INDEX IX_team_TeamEmployee_Employee ON dbo.team_TeamEmployee(EmployeeID,IsActive);

IF OBJECT_ID(N'dbo.team_Meeting',N'U') IS NULL CREATE TABLE dbo.team_Meeting(
 MeetingID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_team_Meeting PRIMARY KEY,HostEmployeeID bigint NOT NULL,HostNameSnapshot nvarchar(250) NOT NULL,MeetingType varchar(20) NOT NULL,MeetingDate date NOT NULL,MeetingTime time(0) NOT NULL,MeetingChannel varchar(20) NOT NULL,OtherChannel nvarchar(100) NULL,Agenda nvarchar(4000) NOT NULL,Conclusion nvarchar(4000) NOT NULL,
 IsActive bit NOT NULL CONSTRAINT DF_team_Meeting_Active DEFAULT(1),CreatedBy bigint NOT NULL,CreatedDate datetime2(0) NOT NULL CONSTRAINT DF_team_Meeting_Created DEFAULT(SYSDATETIME()),ModifiedBy bigint NULL,ModifiedDate datetime2(0) NULL,RowVersion rowversion NOT NULL,
 CONSTRAINT CK_team_Meeting_Type CHECK(MeetingType IN('Daily Meeting','Weekly Meeting')),CONSTRAINT CK_team_Meeting_Channel CHECK(MeetingChannel IN('Teams','In-Person','Other')),CONSTRAINT FK_team_Meeting_Host FOREIGN KEY(HostEmployeeID) REFERENCES dbo.EmployeeInfo(EmployeeID));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_team_Meeting_Date') CREATE INDEX IX_team_Meeting_Date ON dbo.team_Meeting(MeetingDate DESC,MeetingType,HostEmployeeID) INCLUDE(IsActive);

IF OBJECT_ID(N'dbo.team_MeetingTeam',N'U') IS NULL CREATE TABLE dbo.team_MeetingTeam(
 MeetingTeamID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_team_MeetingTeam PRIMARY KEY,MeetingID bigint NOT NULL,TeamID int NOT NULL,TeamNameSnapshot nvarchar(150) NOT NULL,ProjectIDSnapshot int NOT NULL,ProjectNameSnapshot nvarchar(250) NOT NULL,
 CONSTRAINT FK_team_MeetingTeam_Meeting FOREIGN KEY(MeetingID) REFERENCES dbo.team_Meeting(MeetingID),CONSTRAINT FK_team_MeetingTeam_Team FOREIGN KEY(TeamID) REFERENCES dbo.team_Team(TeamID),CONSTRAINT UQ_team_MeetingTeam UNIQUE(MeetingID,TeamID));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_team_MeetingTeam_Team') CREATE INDEX IX_team_MeetingTeam_Team ON dbo.team_MeetingTeam(TeamID,MeetingID);

IF OBJECT_ID(N'dbo.team_Attendance',N'U') IS NULL CREATE TABLE dbo.team_Attendance(
 AttendanceID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_team_Attendance PRIMARY KEY,MeetingID bigint NOT NULL,EmployeeID bigint NOT NULL,EmployeeCodeSnapshot nvarchar(50) NOT NULL,EmployeeNameSnapshot nvarchar(250) NOT NULL,AttendanceStatus varchar(20) NOT NULL,
 CONSTRAINT CK_team_Attendance_Status CHECK(AttendanceStatus IN('Present','Absent','Not Applicable')),CONSTRAINT FK_team_Attendance_Meeting FOREIGN KEY(MeetingID) REFERENCES dbo.team_Meeting(MeetingID),CONSTRAINT FK_team_Attendance_Employee FOREIGN KEY(EmployeeID) REFERENCES dbo.EmployeeInfo(EmployeeID),CONSTRAINT UQ_team_Attendance UNIQUE(MeetingID,EmployeeID));

IF OBJECT_ID(N'dbo.team_ActionItem',N'U') IS NULL CREATE TABLE dbo.team_ActionItem(
 ActionItemID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_team_ActionItem PRIMARY KEY,MeetingID bigint NOT NULL,Description nvarchar(1000) NOT NULL,AssignedTo bigint NOT NULL,AssignedToNameSnapshot nvarchar(250) NOT NULL,DueDate date NULL,Status varchar(20) NOT NULL CONSTRAINT DF_team_Action_Status DEFAULT('Open'),Remarks nvarchar(1000) NULL,IsActive bit NOT NULL CONSTRAINT DF_team_Action_Active DEFAULT(1),CreatedBy bigint NOT NULL,CreatedDate datetime2(0) NOT NULL CONSTRAINT DF_team_Action_Created DEFAULT(SYSDATETIME()),ModifiedBy bigint NULL,ModifiedDate datetime2(0) NULL,RowVersion rowversion NOT NULL,
 CONSTRAINT CK_team_Action_Status CHECK(Status IN('Open','In Progress','Completed','Cancelled')),CONSTRAINT FK_team_Action_Meeting FOREIGN KEY(MeetingID) REFERENCES dbo.team_Meeting(MeetingID),CONSTRAINT FK_team_Action_Assigned FOREIGN KEY(AssignedTo) REFERENCES dbo.EmployeeInfo(EmployeeID));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_team_Action_Assignee') CREATE INDEX IX_team_Action_Assignee ON dbo.team_ActionItem(AssignedTo,Status,DueDate) INCLUDE(MeetingID,IsActive);

IF OBJECT_ID(N'dbo.team_AuditHistory',N'U') IS NULL CREATE TABLE dbo.team_AuditHistory(
 AuditID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_team_AuditHistory PRIMARY KEY,EntityType varchar(30) NOT NULL,EntityID bigint NOT NULL,ActionName varchar(30) NOT NULL,OldValues nvarchar(max) NULL,NewValues nvarchar(max) NULL,ChangedBy bigint NOT NULL,ChangedDate datetime2(0) NOT NULL CONSTRAINT DF_team_Audit_Date DEFAULT(SYSDATETIME()));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_team_Audit_Entity') CREATE INDEX IX_team_Audit_Entity ON dbo.team_AuditHistory(EntityType,EntityID,ChangedDate DESC);
IF OBJECT_ID(N'dbo.team_Notification',N'U') IS NULL CREATE TABLE dbo.team_Notification(
 NotificationID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_team_Notification PRIMARY KEY,EmployeeID bigint NOT NULL,MeetingID bigint NOT NULL,ActionItemID bigint NULL,NotificationType varchar(30) NOT NULL,Message nvarchar(500) NOT NULL,TargetUrl nvarchar(300) NOT NULL,IsRead bit NOT NULL CONSTRAINT DF_team_Notification_Read DEFAULT(0),CreatedDate datetime2(0) NOT NULL CONSTRAINT DF_team_Notification_Date DEFAULT(SYSDATETIME()),ReadDate datetime2(0) NULL,
 CONSTRAINT FK_team_Notification_Employee FOREIGN KEY(EmployeeID) REFERENCES dbo.EmployeeInfo(EmployeeID),CONSTRAINT FK_team_Notification_Meeting FOREIGN KEY(MeetingID) REFERENCES dbo.team_Meeting(MeetingID));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_team_Notification_User') CREATE INDEX IX_team_Notification_User ON dbo.team_Notification(EmployeeID,IsRead,CreatedDate DESC);
GO

IF OBJECT_ID(N'dbo.team_GetPermissions',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetPermissions;
GO
CREATE PROCEDURE dbo.team_GetPermissions @EmployeeID bigint AS
BEGIN SET NOCOUNT ON;
 IF NOT EXISTS(SELECT 1 FROM dbo.EmployeeInfo WHERE EmployeeID=@EmployeeID AND ISNULL(IsDelete,0)=0) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 SELECT CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.EmployeeInfo staff WHERE staff.ProjectManager=e.EmployeeID AND ISNULL(staff.IsDelete,0)=0) OR ISNULL(p.CanManageTeams,0)=1 THEN 1 ELSE 0 END AS bit) CanManageTeams,
 CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.EmployeeInfo staff WHERE staff.ProjectManager=e.EmployeeID AND ISNULL(staff.IsDelete,0)=0) OR ISNULL(p.CanManageMeetings,0)=1 THEN 1 ELSE 0 END AS bit) CanManageMeetings,
 CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.EmployeeInfo staff WHERE staff.ProjectManager=e.EmployeeID AND ISNULL(staff.IsDelete,0)=0) OR ISNULL(p.CanViewAll,0)=1 THEN 1 ELSE 0 END AS bit) CanViewAll,
 CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.EmployeeInfo staff WHERE staff.ProjectManager=e.EmployeeID AND ISNULL(staff.IsDelete,0)=0) OR ISNULL(p.CanEditAll,0)=1 THEN 1 ELSE 0 END AS bit) CanEditAll,ISNULL(p.CanCreateFuture,0) CanCreateFuture
 FROM dbo.EmployeeInfo e LEFT JOIN dbo.team_Permission p ON p.EmployeeID=e.EmployeeID AND p.IsActive=1 WHERE e.EmployeeID=@EmployeeID;
END
GO

IF OBJECT_ID(N'dbo.team_GetLookup',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetLookup;
GO
CREATE PROCEDURE dbo.team_GetLookup @EmployeeID bigint AS
BEGIN SET NOCOUNT ON; DECLARE @Manage bit,@Meet bit,@All bit,@Edit bit,@Future bit; DECLARE @P table(CanManageTeams bit,CanManageMeetings bit,CanViewAll bit,CanEditAll bit,CanCreateFuture bit);INSERT @P EXEC dbo.team_GetPermissions @EmployeeID;SELECT @Manage=CanManageTeams,@Meet=CanManageMeetings,@All=CanViewAll,@Edit=CanEditAll,@Future=CanCreateFuture FROM @P;
 SELECT ProjectID,ProjectName FROM dbo.Project ORDER BY ProjectName;
 SELECT EmployeeID,Code,LTRIM(RTRIM(ISNULL(FirstName,'')+' '+ISNULL(lastName,''))) EmployeeName,Code+' : '+LTRIM(RTRIM(ISNULL(FirstName,'')+' '+ISNULL(lastName,''))) DisplayName FROM dbo.EmployeeInfo WHERE ISNULL(IsDelete,0)=0 AND Domain=9 AND LTRIM(RTRIM(SubDomain))='Servicing' ORDER BY FirstName,lastName;
 SELECT TeamID,TeamName,ProjectID FROM dbo.team_Team WHERE IsActive=1 AND (@All=1 OR @Manage=1 OR ManagerEmployeeID=@EmployeeID OR EXISTS(SELECT 1 FROM dbo.team_TeamEmployee WHERE TeamID=team_Team.TeamID AND EmployeeID=@EmployeeID AND IsActive=1)) ORDER BY TeamName;
 SELECT @Manage CanManageTeams,@Meet CanManageMeetings,@All CanViewAll,@Edit CanEditAll,@Future CanCreateFuture;
END
GO

IF OBJECT_ID(N'dbo.team_GetTeams',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetTeams;
GO
CREATE PROCEDURE dbo.team_GetTeams @EmployeeID bigint,@IncludeInactive bit=0 AS
BEGIN SET NOCOUNT ON; DECLARE @P table(CanManageTeams bit,CanManageMeetings bit,CanViewAll bit,CanEditAll bit,CanCreateFuture bit);INSERT @P EXEC dbo.team_GetPermissions @EmployeeID;IF NOT EXISTS(SELECT 1 FROM @P WHERE CanManageTeams=1) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 SELECT t.TeamID,t.TeamName,t.ProjectID,p.ProjectName,t.Description,t.ManagerEmployeeID,ISNULL(m.Code+' : '+LTRIM(RTRIM(ISNULL(m.FirstName,'')+' '+ISNULL(m.lastName,''))),'') ManagerName,t.IsActive,COUNT(te.TeamEmployeeID) EmployeeCount,t.RowVersion FROM dbo.team_Team t JOIN dbo.Project p ON p.ProjectID=t.ProjectID LEFT JOIN dbo.EmployeeInfo m ON m.EmployeeID=t.ManagerEmployeeID LEFT JOIN dbo.team_TeamEmployee te ON te.TeamID=t.TeamID AND te.IsActive=1 WHERE (@IncludeInactive=1 OR t.IsActive=1) GROUP BY t.TeamID,t.TeamName,t.ProjectID,p.ProjectName,t.Description,t.ManagerEmployeeID,m.Code,m.FirstName,m.lastName,t.IsActive,t.RowVersion ORDER BY p.ProjectName,t.TeamName;
END
GO

IF OBJECT_ID(N'dbo.team_GetTeam',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetTeam;
GO
CREATE PROCEDURE dbo.team_GetTeam @EmployeeID bigint,@TeamID int AS
BEGIN SET NOCOUNT ON; DECLARE @P table(CanManageTeams bit,CanManageMeetings bit,CanViewAll bit,CanEditAll bit,CanCreateFuture bit);INSERT @P EXEC dbo.team_GetPermissions @EmployeeID;IF NOT EXISTS(SELECT 1 FROM @P WHERE CanManageTeams=1) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 SELECT TeamID,TeamName,ProjectID,Description,ManagerEmployeeID,IsActive,RowVersion FROM dbo.team_Team WHERE TeamID=@TeamID;SELECT EmployeeID FROM dbo.team_TeamEmployee WHERE TeamID=@TeamID AND IsActive=1 ORDER BY EmployeeID;
END
GO

IF OBJECT_ID(N'dbo.team_SaveTeam',N'P') IS NOT NULL DROP PROCEDURE dbo.team_SaveTeam;
GO
CREATE PROCEDURE dbo.team_SaveTeam @EmployeeID bigint,@TeamID int,@TeamName nvarchar(150),@ProjectID int,@Description nvarchar(1000)=NULL,@ManagerEmployeeID bigint=NULL,@IsActive bit,@Employees dbo.team_EmployeeList READONLY AS
BEGIN SET NOCOUNT ON;SET XACT_ABORT ON;DECLARE @P table(CanManageTeams bit,CanManageMeetings bit,CanViewAll bit,CanEditAll bit,CanCreateFuture bit);INSERT @P EXEC dbo.team_GetPermissions @EmployeeID;IF NOT EXISTS(SELECT 1 FROM @P WHERE CanManageTeams=1) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 SET @TeamName=LTRIM(RTRIM(@TeamName));IF @TeamName='' OR NOT EXISTS(SELECT 1 FROM dbo.Project WHERE ProjectID=@ProjectID) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;IF @ManagerEmployeeID IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.EmployeeInfo WHERE EmployeeID=@ManagerEmployeeID AND ISNULL(IsDelete,0)=0) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;IF EXISTS(SELECT 1 FROM @Employees x LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=x.ID AND ISNULL(e.IsDelete,0)=0 WHERE e.EmployeeID IS NULL) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 BEGIN TRAN;IF EXISTS(SELECT 1 FROM dbo.team_Team WITH(UPDLOCK,HOLDLOCK) WHERE ProjectID=@ProjectID AND TeamName=@TeamName AND IsActive=1 AND TeamID<>@TeamID) BEGIN ROLLBACK; RAISERROR('Validation failed.',16,1); RETURN; END;
 IF @TeamID=0 BEGIN INSERT dbo.team_Team(TeamName,ProjectID,Description,ManagerEmployeeID,IsActive,CreatedBy)VALUES(@TeamName,@ProjectID,NULLIF(@Description,''),@ManagerEmployeeID,@IsActive,@EmployeeID);SET @TeamID=SCOPE_IDENTITY();END
 ELSE BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.team_Team WHERE TeamID=@TeamID) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;UPDATE dbo.team_Team SET TeamName=@TeamName,ProjectID=@ProjectID,Description=NULLIF(@Description,''),ManagerEmployeeID=@ManagerEmployeeID,IsActive=@IsActive,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHERE TeamID=@TeamID;END
 UPDATE te SET IsActive=0,EffectiveTo=SYSDATETIME() FROM dbo.team_TeamEmployee te WHERE te.TeamID=@TeamID AND te.IsActive=1 AND NOT EXISTS(SELECT 1 FROM @Employees x WHERE x.ID=te.EmployeeID);
 INSERT dbo.team_TeamEmployee(TeamID,EmployeeID,AddedBy) SELECT @TeamID,x.ID,@EmployeeID FROM @Employees x WHERE NOT EXISTS(SELECT 1 FROM dbo.team_TeamEmployee te WHERE te.TeamID=@TeamID AND te.EmployeeID=x.ID AND te.IsActive=1);
 INSERT dbo.team_AuditHistory(EntityType,EntityID,ActionName,NewValues,ChangedBy)VALUES('Team',@TeamID,CASE WHEN @TeamID=0 THEN 'Create' ELSE 'Save' END,@TeamName,@EmployeeID);COMMIT;SELECT @TeamID;END
GO

IF OBJECT_ID(N'dbo.team_GetAttendanceCandidates',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetAttendanceCandidates;
GO
CREATE PROCEDURE dbo.team_GetAttendanceCandidates @EmployeeID bigint,@Teams dbo.team_IntList READONLY AS
BEGIN SET NOCOUNT ON;IF EXISTS(SELECT 1 FROM @Teams x LEFT JOIN dbo.team_Team t ON t.TeamID=x.ID AND t.IsActive=1 WHERE t.TeamID IS NULL) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 SELECT DISTINCT e.EmployeeID,e.Code+' : '+LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))) DisplayName FROM @Teams x JOIN dbo.team_TeamEmployee te ON te.TeamID=x.ID AND te.IsActive=1 JOIN dbo.EmployeeInfo e ON e.EmployeeID=te.EmployeeID AND ISNULL(e.IsDelete,0)=0 AND e.Domain=9 AND LTRIM(RTRIM(e.SubDomain))='Servicing' ORDER BY DisplayName;END
GO

IF OBJECT_ID(N'dbo.team_SaveMeeting',N'P') IS NOT NULL DROP PROCEDURE dbo.team_SaveMeeting;
GO
CREATE PROCEDURE dbo.team_SaveMeeting
 @EmployeeID bigint,@MeetingID bigint,@HostEmployeeID bigint,@MeetingType varchar(20),@MeetingDate date,@MeetingTime time(0),@MeetingChannel varchar(20),@OtherChannel nvarchar(100)=NULL,@Agenda nvarchar(4000),@Conclusion nvarchar(4000),@RowVersion binary(8)=NULL,
 @Teams dbo.team_IntList READONLY,@Attendance dbo.team_AttendanceList READONLY,@Actions dbo.team_ActionItemList READONLY
AS
BEGIN SET NOCOUNT ON;SET XACT_ABORT ON;
 DECLARE @P table(CanManageTeams bit,CanManageMeetings bit,CanViewAll bit,CanEditAll bit,CanCreateFuture bit);DECLARE @CanManage bit,@CanEditAll bit,@CanFuture bit;INSERT @P EXEC dbo.team_GetPermissions @EmployeeID;SELECT @CanManage=CanManageMeetings,@CanEditAll=CanEditAll,@CanFuture=CanCreateFuture FROM @P;
 IF @MeetingType NOT IN('Daily Meeting','Weekly Meeting') OR @MeetingChannel NOT IN('Teams','In-Person','Other') BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF @MeetingChannel='Other' AND NULLIF(LTRIM(RTRIM(@OtherChannel)),'') IS NULL BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF NULLIF(LTRIM(RTRIM(@Agenda)),'') IS NULL OR NULLIF(LTRIM(RTRIM(@Conclusion)),'') IS NULL BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF NOT EXISTS(SELECT 1 FROM @Teams) OR NOT EXISTS(SELECT 1 FROM @Attendance) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF @MeetingDate>CAST(GETDATE() AS date) AND @CanFuture=0 BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF NOT EXISTS(SELECT 1 FROM dbo.EmployeeInfo WHERE EmployeeID=@HostEmployeeID AND ISNULL(IsDelete,0)=0) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF @CanManage=0 AND @HostEmployeeID<>@EmployeeID BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF EXISTS(SELECT 1 FROM @Teams x LEFT JOIN dbo.team_Team t ON t.TeamID=x.ID AND t.IsActive=1 WHERE t.TeamID IS NULL) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF EXISTS(SELECT 1 FROM @Attendance a LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.EmployeeID AND ISNULL(e.IsDelete,0)=0 WHERE e.EmployeeID IS NULL OR a.AttendanceStatus NOT IN('Present','Absent','Not Applicable')) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF EXISTS(SELECT 1 FROM @Actions a LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.AssignedTo AND ISNULL(e.IsDelete,0)=0 WHERE e.EmployeeID IS NULL OR NULLIF(LTRIM(RTRIM(a.Description)),'') IS NULL OR a.Status NOT IN('Open','In Progress','Completed','Cancelled')) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF EXISTS(SELECT 1 FROM @Actions a WHERE a.AssignedTo<>@HostEmployeeID AND NOT EXISTS(SELECT 1 FROM @Attendance x WHERE x.EmployeeID=a.AssignedTo)) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 BEGIN TRY BEGIN TRAN;
 IF @MeetingID=0 BEGIN
  SELECT @Agenda=LTRIM(RTRIM(@Agenda)),@Conclusion=LTRIM(RTRIM(@Conclusion));
  INSERT dbo.team_Meeting(HostEmployeeID,HostNameSnapshot,MeetingType,MeetingDate,MeetingTime,MeetingChannel,OtherChannel,Agenda,Conclusion,CreatedBy)
  SELECT @HostEmployeeID,e.Code+' : '+LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))),@MeetingType,@MeetingDate,@MeetingTime,@MeetingChannel,NULLIF(LTRIM(RTRIM(@OtherChannel)),''),@Agenda,@Conclusion,@EmployeeID FROM dbo.EmployeeInfo e WHERE e.EmployeeID=@HostEmployeeID;
  SET @MeetingID=SCOPE_IDENTITY();
 END ELSE BEGIN
  IF NOT EXISTS(SELECT 1 FROM dbo.team_Meeting m WHERE m.MeetingID=@MeetingID AND m.IsActive=1 AND m.RowVersion=@RowVersion AND (@CanEditAll=1 OR m.HostEmployeeID=@EmployeeID OR m.CreatedBy=@EmployeeID OR EXISTS(SELECT 1 FROM dbo.team_MeetingTeam mt JOIN dbo.team_Team t ON t.TeamID=mt.TeamID WHERE mt.MeetingID=m.MeetingID AND t.ManagerEmployeeID=@EmployeeID))) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
  UPDATE dbo.team_Meeting SET HostEmployeeID=@HostEmployeeID,HostNameSnapshot=e.Code+' : '+LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))),MeetingType=@MeetingType,MeetingDate=@MeetingDate,MeetingTime=@MeetingTime,MeetingChannel=@MeetingChannel,OtherChannel=NULLIF(LTRIM(RTRIM(@OtherChannel)),''),Agenda=LTRIM(RTRIM(@Agenda)),Conclusion=LTRIM(RTRIM(@Conclusion)),ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() FROM dbo.team_Meeting m JOIN dbo.EmployeeInfo e ON e.EmployeeID=@HostEmployeeID WHERE m.MeetingID=@MeetingID;
  DELETE dbo.team_MeetingTeam WHERE MeetingID=@MeetingID;DELETE dbo.team_Attendance WHERE MeetingID=@MeetingID;
  UPDATE dbo.team_ActionItem SET IsActive=0,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHERE MeetingID=@MeetingID AND IsActive=1 AND NOT EXISTS(SELECT 1 FROM @Actions a WHERE a.ActionItemID=team_ActionItem.ActionItemID);
 END
 INSERT dbo.team_MeetingTeam(MeetingID,TeamID,TeamNameSnapshot,ProjectIDSnapshot,ProjectNameSnapshot) SELECT @MeetingID,t.TeamID,t.TeamName,t.ProjectID,p.ProjectName FROM @Teams x JOIN dbo.team_Team t ON t.TeamID=x.ID JOIN dbo.Project p ON p.ProjectID=t.ProjectID;
 INSERT dbo.team_Attendance(MeetingID,EmployeeID,EmployeeCodeSnapshot,EmployeeNameSnapshot,AttendanceStatus) SELECT @MeetingID,e.EmployeeID,e.Code,e.Code+' : '+LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))),a.AttendanceStatus FROM @Attendance a JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.EmployeeID;
 UPDATE ai SET Description=LTRIM(RTRIM(a.Description)),AssignedTo=a.AssignedTo,AssignedToNameSnapshot=e.Code+' : '+LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))),DueDate=a.DueDate,Status=a.Status,Remarks=NULLIF(LTRIM(RTRIM(a.Remarks)),''),IsActive=1,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() FROM dbo.team_ActionItem ai JOIN @Actions a ON a.ActionItemID=ai.ActionItemID JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.AssignedTo WHERE ai.MeetingID=@MeetingID AND a.ActionItemID>0;
 INSERT dbo.team_ActionItem(MeetingID,Description,AssignedTo,AssignedToNameSnapshot,DueDate,Status,Remarks,CreatedBy) SELECT @MeetingID,LTRIM(RTRIM(a.Description)),a.AssignedTo,e.Code+' : '+LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))),a.DueDate,a.Status,NULLIF(LTRIM(RTRIM(a.Remarks)),''),@EmployeeID FROM @Actions a JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.AssignedTo WHERE a.ActionItemID=0;
 INSERT dbo.team_Notification(EmployeeID,MeetingID,ActionItemID,NotificationType,Message,TargetUrl)
 SELECT a.AssignedTo,@MeetingID,a.ActionItemID,'ActionAssigned','A meeting action item has been assigned to you.','TeamMeetingActionTracker.aspx' FROM dbo.team_ActionItem a WHERE a.MeetingID=@MeetingID AND a.IsActive=1 AND NOT EXISTS(SELECT 1 FROM dbo.team_Notification n WHERE n.ActionItemID=a.ActionItemID AND n.EmployeeID=a.AssignedTo AND n.NotificationType='ActionAssigned');
 INSERT dbo.team_Notification(EmployeeID,MeetingID,ActionItemID,NotificationType,Message,TargetUrl)
 SELECT DISTINCT t.ManagerEmployeeID,@MeetingID,NULL,'MeetingPM','A team meeting has been recorded for a team you manage.','TeamMeetingDetails.aspx?id='+CAST(@MeetingID AS varchar(20))+'&return=tracker' FROM dbo.team_MeetingTeam mt JOIN dbo.team_Team t ON t.TeamID=mt.TeamID WHERE mt.MeetingID=@MeetingID AND t.ManagerEmployeeID IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.team_Notification n WHERE n.MeetingID=@MeetingID AND n.EmployeeID=t.ManagerEmployeeID AND n.NotificationType='MeetingPM');
 INSERT dbo.team_AuditHistory(EntityType,EntityID,ActionName,NewValues,ChangedBy)VALUES('Meeting',@MeetingID,CASE WHEN @RowVersion IS NULL THEN 'Create' ELSE 'Update' END,'Meeting saved',@EmployeeID);
 COMMIT;SELECT @MeetingID;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK; DECLARE @ErrorMessage nvarchar(4000)=ERROR_MESSAGE(); RAISERROR(@ErrorMessage,16,1); RETURN;END CATCH
END
GO

IF OBJECT_ID(N'dbo.team_GetMeetingEmail',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetMeetingEmail;
GO
CREATE PROCEDURE dbo.team_GetMeetingEmail @MeetingID bigint AS
BEGIN SET NOCOUNT ON;
 SELECT m.MeetingID,m.HostNameSnapshot,m.MeetingType,CONVERT(varchar(11),m.MeetingDate,106) MeetingDateText,LEFT(CONVERT(varchar(8),m.MeetingTime,108),5) MeetingTimeText,m.MeetingChannel,m.OtherChannel,m.Agenda,m.Conclusion,STUFF((SELECT ', '+mt.TeamNameSnapshot FROM dbo.team_MeetingTeam mt WHERE mt.MeetingID=m.MeetingID ORDER BY mt.TeamNameSnapshot FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,2,'') TeamNames FROM dbo.team_Meeting m WHERE m.MeetingID=@MeetingID;
 SELECT DISTINCT e.OfficialEmailID FROM dbo.team_MeetingTeam mt JOIN dbo.team_TeamEmployee te ON te.TeamID=mt.TeamID AND te.IsActive=1 JOIN dbo.EmployeeInfo e ON e.EmployeeID=te.EmployeeID AND ISNULL(e.IsDelete,0)=0 WHERE mt.MeetingID=@MeetingID AND NULLIF(LTRIM(RTRIM(e.OfficialEmailID)),'') IS NOT NULL;
 SELECT a.Description,a.AssignedToNameSnapshot AssignedTo,CONVERT(varchar(11),a.DueDate,106) DueDateText,a.Status FROM dbo.team_ActionItem a WHERE a.MeetingID=@MeetingID AND a.IsActive=1 ORDER BY a.ActionItemID;
END
GO

IF OBJECT_ID(N'dbo.team_GetNotifications',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetNotifications;
GO
CREATE PROCEDURE dbo.team_GetNotifications @EmployeeID bigint AS
BEGIN SET NOCOUNT ON;SELECT TOP 25 NotificationID,MeetingID,ActionItemID,NotificationType,Message,TargetUrl,IsRead,CreatedDate FROM dbo.team_Notification WHERE EmployeeID=@EmployeeID ORDER BY IsRead,CreatedDate DESC;END
GO

IF OBJECT_ID(N'dbo.team_MarkNotificationRead',N'P') IS NOT NULL DROP PROCEDURE dbo.team_MarkNotificationRead;
GO
CREATE PROCEDURE dbo.team_MarkNotificationRead @EmployeeID bigint,@NotificationID bigint AS
BEGIN SET NOCOUNT ON;UPDATE dbo.team_Notification SET IsRead=1,ReadDate=SYSDATETIME() WHERE NotificationID=@NotificationID AND EmployeeID=@EmployeeID;END
GO

IF OBJECT_ID(N'dbo.team_GetMeeting',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetMeeting;
GO
CREATE PROCEDURE dbo.team_GetMeeting @EmployeeID bigint,@MeetingID bigint,@ForEdit bit=0 AS
BEGIN SET NOCOUNT ON;DECLARE @P table(CanManageTeams bit,CanManageMeetings bit,CanViewAll bit,CanEditAll bit,CanCreateFuture bit);DECLARE @All bit,@Edit bit;INSERT @P EXEC dbo.team_GetPermissions @EmployeeID;SELECT @All=CanViewAll,@Edit=CanEditAll FROM @P;
 IF NOT EXISTS(SELECT 1 FROM dbo.team_Meeting m WHERE m.MeetingID=@MeetingID AND m.IsActive=1 AND (@All=1 OR m.HostEmployeeID=@EmployeeID OR m.CreatedBy=@EmployeeID OR EXISTS(SELECT 1 FROM dbo.team_MeetingTeam mt JOIN dbo.team_TeamEmployee te ON te.TeamID=mt.TeamID AND te.EmployeeID=@EmployeeID WHERE mt.MeetingID=m.MeetingID) OR EXISTS(SELECT 1 FROM dbo.team_ActionItem a WHERE a.MeetingID=m.MeetingID AND a.AssignedTo=@EmployeeID))) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 IF @ForEdit=1 AND NOT EXISTS(SELECT 1 FROM dbo.team_Meeting m WHERE m.MeetingID=@MeetingID AND (@Edit=1 OR m.HostEmployeeID=@EmployeeID OR m.CreatedBy=@EmployeeID OR EXISTS(SELECT 1 FROM dbo.team_MeetingTeam mt JOIN dbo.team_Team t ON t.TeamID=mt.TeamID WHERE mt.MeetingID=m.MeetingID AND t.ManagerEmployeeID=@EmployeeID))) BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 SELECT m.MeetingID,m.HostEmployeeID,m.HostNameSnapshot HostName,m.MeetingType,CONVERT(varchar(10),m.MeetingDate,23) MeetingDateText,LEFT(CONVERT(varchar(8),m.MeetingTime,108),5) MeetingTimeText,m.MeetingChannel,m.OtherChannel,m.Agenda,m.Conclusion,CAST(N'' AS xml).value('xs:base64Binary(sql:column("m.RowVersion"))','varchar(max)') RowVersionBase64 FROM dbo.team_Meeting m WHERE m.MeetingID=@MeetingID;
 SELECT TeamID,TeamNameSnapshot TeamName,ProjectIDSnapshot,ProjectNameSnapshot ProjectName FROM dbo.team_MeetingTeam WHERE MeetingID=@MeetingID ORDER BY TeamNameSnapshot;
 SELECT EmployeeID,EmployeeNameSnapshot EmployeeName,AttendanceStatus FROM dbo.team_Attendance WHERE MeetingID=@MeetingID ORDER BY EmployeeNameSnapshot;
 SELECT a.ActionItemID,a.Description,a.AssignedTo,a.AssignedToNameSnapshot AssignedToName,CONVERT(varchar(10),a.DueDate,23) DueDateText,a.Status,a.Remarks,CAST(N'' AS xml).value('xs:base64Binary(sql:column("a.RowVersion"))','varchar(max)') RowVersionBase64 FROM dbo.team_ActionItem a WHERE a.MeetingID=@MeetingID AND a.IsActive=1 ORDER BY a.ActionItemID;
END
GO

IF OBJECT_ID(N'dbo.team_GetMeetingReport',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetMeetingReport;
GO
CREATE PROCEDURE dbo.team_GetMeetingReport @EmployeeID bigint,@FromDate date=NULL,@ToDate date=NULL,@MeetingType varchar(20)=NULL,@HostEmployeeID bigint=0,@TeamID int=0 AS
BEGIN SET NOCOUNT ON;DECLARE @P table(CanManageTeams bit,CanManageMeetings bit,CanViewAll bit,CanEditAll bit,CanCreateFuture bit);DECLARE @All bit,@Edit bit;INSERT @P EXEC dbo.team_GetPermissions @EmployeeID;SELECT @All=CanViewAll,@Edit=CanEditAll FROM @P;
 SELECT m.MeetingID,CONVERT(varchar(10),m.MeetingDate,23) MeetingDateText,LEFT(CONVERT(varchar(8),m.MeetingTime,108),5) MeetingTimeText,m.MeetingType,m.HostNameSnapshot HostName,m.MeetingChannel,m.Agenda,m.Conclusion,
 STUFF((SELECT ', '+mt.TeamNameSnapshot FROM dbo.team_MeetingTeam mt WHERE mt.MeetingID=m.MeetingID ORDER BY mt.TeamNameSnapshot FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,2,'') TeamNames,
 CAST((SELECT COUNT(1) FROM dbo.team_Attendance a WHERE a.MeetingID=m.MeetingID AND a.AttendanceStatus='Present') AS varchar(10))+' Present / '+CAST((SELECT COUNT(1) FROM dbo.team_Attendance a WHERE a.MeetingID=m.MeetingID) AS varchar(10))+' Total' AttendanceSummary,
 STUFF((SELECT '; '+a.EmployeeNameSnapshot+' - '+a.AttendanceStatus FROM dbo.team_Attendance a WHERE a.MeetingID=m.MeetingID ORDER BY a.EmployeeNameSnapshot FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,2,'') AttendanceDetails,
 STUFF((SELECT '; '+a.Description+' ['+a.AssignedToNameSnapshot+' / '+a.Status+CASE WHEN a.DueDate IS NULL THEN '' ELSE ' / Due '+CONVERT(varchar(10),a.DueDate,23) END+']' FROM dbo.team_ActionItem a WHERE a.MeetingID=m.MeetingID AND a.IsActive=1 ORDER BY a.ActionItemID FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,2,'') ActionItems,
 CAST(CASE WHEN @Edit=1 OR m.HostEmployeeID=@EmployeeID OR m.CreatedBy=@EmployeeID OR EXISTS(SELECT 1 FROM dbo.team_MeetingTeam mt JOIN dbo.team_Team t ON t.TeamID=mt.TeamID WHERE mt.MeetingID=m.MeetingID AND t.ManagerEmployeeID=@EmployeeID) THEN 1 ELSE 0 END AS bit) CanEdit
 FROM dbo.team_Meeting m WHERE m.IsActive=1 AND (@FromDate IS NULL OR m.MeetingDate>=@FromDate) AND (@ToDate IS NULL OR m.MeetingDate<=@ToDate) AND (NULLIF(@MeetingType,'') IS NULL OR m.MeetingType=@MeetingType) AND (@HostEmployeeID=0 OR m.HostEmployeeID=@HostEmployeeID) AND (@TeamID=0 OR EXISTS(SELECT 1 FROM dbo.team_MeetingTeam mt WHERE mt.MeetingID=m.MeetingID AND mt.TeamID=@TeamID))
 AND (@All=1 OR m.HostEmployeeID=@EmployeeID OR m.CreatedBy=@EmployeeID OR EXISTS(SELECT 1 FROM dbo.team_MeetingTeam mt JOIN dbo.team_TeamEmployee te ON te.TeamID=mt.TeamID AND te.EmployeeID=@EmployeeID WHERE mt.MeetingID=m.MeetingID) OR EXISTS(SELECT 1 FROM dbo.team_ActionItem a WHERE a.MeetingID=m.MeetingID AND a.AssignedTo=@EmployeeID)) ORDER BY m.MeetingDate DESC,m.MeetingTime DESC,m.MeetingID DESC;
END
GO

IF OBJECT_ID(N'dbo.team_GetActionItems',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetActionItems;
GO
CREATE PROCEDURE dbo.team_GetActionItems @EmployeeID bigint,@Status varchar(20)=NULL,@AssignedTo bigint=0 AS
BEGIN SET NOCOUNT ON;DECLARE @P table(CanManageTeams bit,CanManageMeetings bit,CanViewAll bit,CanEditAll bit,CanCreateFuture bit);DECLARE @All bit;INSERT @P EXEC dbo.team_GetPermissions @EmployeeID;SELECT @All=CanViewAll FROM @P;
 SELECT a.ActionItemID,a.MeetingID,a.Description,a.AssignedTo,a.AssignedToNameSnapshot AssignedToName,creator.Code+' : '+LTRIM(RTRIM(ISNULL(creator.FirstName,'')+' '+ISNULL(creator.lastName,''))) AssignedByName,CONVERT(varchar(10),a.DueDate,23) DueDateText,a.Status,a.Remarks,CONVERT(varchar(10),m.MeetingDate,23) MeetingDateText,STUFF((SELECT ', '+mt.TeamNameSnapshot FROM dbo.team_MeetingTeam mt WHERE mt.MeetingID=m.MeetingID ORDER BY mt.TeamNameSnapshot FOR XML PATH(''),TYPE).value('.','nvarchar(max)'),1,2,'') TeamNames,CAST(N'' AS xml).value('xs:base64Binary(sql:column("a.RowVersion"))','varchar(max)') RowVersionBase64 FROM dbo.team_ActionItem a JOIN dbo.team_Meeting m ON m.MeetingID=a.MeetingID JOIN dbo.EmployeeInfo creator ON creator.EmployeeID=a.CreatedBy WHERE a.IsActive=1 AND m.IsActive=1 AND (NULLIF(@Status,'') IS NULL OR a.Status=@Status) AND (@AssignedTo=0 OR a.AssignedTo=@AssignedTo) AND (@All=1 OR a.AssignedTo=@EmployeeID OR m.HostEmployeeID=@EmployeeID OR m.CreatedBy=@EmployeeID OR EXISTS(SELECT 1 FROM dbo.team_MeetingTeam mt JOIN dbo.team_Team t ON t.TeamID=mt.TeamID WHERE mt.MeetingID=m.MeetingID AND t.ManagerEmployeeID=@EmployeeID)) ORDER BY CASE WHEN a.Status IN('Open','In Progress') THEN 0 ELSE 1 END,a.DueDate,a.ActionItemID;
END
GO

IF OBJECT_ID(N'dbo.team_UpdateActionItem',N'P') IS NOT NULL DROP PROCEDURE dbo.team_UpdateActionItem;
GO
CREATE PROCEDURE dbo.team_UpdateActionItem @EmployeeID bigint,@ActionItemID bigint,@Status varchar(20),@Remarks nvarchar(1000)=NULL,@RowVersion binary(8) AS
BEGIN SET NOCOUNT ON;SET XACT_ABORT ON;DECLARE @P table(CanManageTeams bit,CanManageMeetings bit,CanViewAll bit,CanEditAll bit,CanCreateFuture bit);DECLARE @Edit bit,@OldStatus varchar(20),@OldRemarks nvarchar(1000);INSERT @P EXEC dbo.team_GetPermissions @EmployeeID;SELECT @Edit=CanEditAll FROM @P;IF @Status NOT IN('Open','In Progress','Completed','Cancelled') BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 SELECT @OldStatus=Status,@OldRemarks=Remarks FROM dbo.team_ActionItem WHERE ActionItemID=@ActionItemID;
 UPDATE a SET Status=@Status,Remarks=NULLIF(LTRIM(RTRIM(@Remarks)),''),ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() FROM dbo.team_ActionItem a JOIN dbo.team_Meeting m ON m.MeetingID=a.MeetingID WHERE a.ActionItemID=@ActionItemID AND a.IsActive=1 AND a.RowVersion=@RowVersion AND (@Edit=1 OR a.AssignedTo=@EmployeeID OR m.HostEmployeeID=@EmployeeID OR m.CreatedBy=@EmployeeID);IF @@ROWCOUNT=0 BEGIN RAISERROR('Validation failed.',16,1); RETURN; END;
 INSERT dbo.team_Notification(EmployeeID,MeetingID,ActionItemID,NotificationType,Message,TargetUrl)
 SELECT recipients.EmployeeID,a.MeetingID,a.ActionItemID,'ActionStatus','Action item updated by '+actor.Code+': status '+@OldStatus+' to '+@Status+CASE WHEN ISNULL(@OldRemarks,'')<>ISNULL(NULLIF(LTRIM(RTRIM(@Remarks)),''),'') THEN '; remark updated.' ELSE '.' END,'TeamMeetingActionTracker.aspx?action='+CAST(a.ActionItemID AS varchar(20)) FROM dbo.team_ActionItem a JOIN dbo.EmployeeInfo actor ON actor.EmployeeID=@EmployeeID CROSS APPLY(SELECT m.HostEmployeeID EmployeeID FROM dbo.team_Meeting m WHERE m.MeetingID=a.MeetingID UNION SELECT t.ManagerEmployeeID FROM dbo.team_MeetingTeam mt JOIN dbo.team_Team t ON t.TeamID=mt.TeamID WHERE mt.MeetingID=a.MeetingID AND t.ManagerEmployeeID IS NOT NULL) recipients WHERE a.ActionItemID=@ActionItemID AND recipients.EmployeeID<>@EmployeeID;
 INSERT dbo.team_AuditHistory(EntityType,EntityID,ActionName,OldValues,NewValues,ChangedBy)VALUES('ActionItem',@ActionItemID,'Update',N'Status: '+ISNULL(@OldStatus,'')+N' | Remark: '+ISNULL(@OldRemarks,''),N'Status: '+ISNULL(@Status,'')+N' | Remark: '+ISNULL(NULLIF(LTRIM(RTRIM(@Remarks)),''),''),@EmployeeID);
END
GO

IF OBJECT_ID(N'dbo.team_GetActionHistory',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetActionHistory;
GO
CREATE PROCEDURE dbo.team_GetActionHistory @EmployeeID bigint,@ActionItemID bigint AS
BEGIN SET NOCOUNT ON;DECLARE @P table(CanManageTeams bit,CanManageMeetings bit,CanViewAll bit,CanEditAll bit,CanCreateFuture bit);DECLARE @All bit;INSERT @P EXEC dbo.team_GetPermissions @EmployeeID;SELECT @All=CanViewAll FROM @P;
 IF NOT EXISTS(SELECT 1 FROM dbo.team_ActionItem a JOIN dbo.team_Meeting m ON m.MeetingID=a.MeetingID WHERE a.ActionItemID=@ActionItemID AND (@All=1 OR a.AssignedTo=@EmployeeID OR m.HostEmployeeID=@EmployeeID OR m.CreatedBy=@EmployeeID OR EXISTS(SELECT 1 FROM dbo.team_MeetingTeam mt JOIN dbo.team_Team t ON t.TeamID=mt.TeamID WHERE mt.MeetingID=m.MeetingID AND t.ManagerEmployeeID=@EmployeeID))) BEGIN RAISERROR('Validation failed.',16,1);RETURN;END;
 SELECT h.ActionName,h.OldValues,h.NewValues,e.Code+' : '+LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))) ChangedByName,h.ChangedDate FROM dbo.team_AuditHistory h JOIN dbo.EmployeeInfo e ON e.EmployeeID=h.ChangedBy WHERE h.EntityType='ActionItem' AND h.EntityID=@ActionItemID
 UNION ALL SELECT 'Assigned',NULL,N'Assigned to '+a.AssignedToNameSnapshot,e.Code+' : '+LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))),a.CreatedDate FROM dbo.team_ActionItem a JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.CreatedBy WHERE a.ActionItemID=@ActionItemID ORDER BY ChangedDate DESC;
END
GO

IF OBJECT_ID(N'dbo.team_GetActionUpdateEmail',N'P') IS NOT NULL DROP PROCEDURE dbo.team_GetActionUpdateEmail;
GO
CREATE PROCEDURE dbo.team_GetActionUpdateEmail @ActionItemID bigint AS
BEGIN SET NOCOUNT ON;
 SELECT a.ActionItemID,a.Description,a.Status,a.Remarks,a.AssignedToNameSnapshot,m.HostNameSnapshot,CONVERT(varchar(11),a.DueDate,106) DueDateText,CONVERT(varchar(11),m.MeetingDate,106) MeetingDateText,changer.Code+' : '+LTRIM(RTRIM(ISNULL(changer.FirstName,'')+' '+ISNULL(changer.lastName,''))) ChangedByName FROM dbo.team_ActionItem a JOIN dbo.team_Meeting m ON m.MeetingID=a.MeetingID LEFT JOIN dbo.EmployeeInfo changer ON changer.EmployeeID=a.ModifiedBy WHERE a.ActionItemID=@ActionItemID;
 SELECT DISTINCT e.OfficialEmailID FROM dbo.team_ActionItem a CROSS APPLY(SELECT m.HostEmployeeID EmployeeID FROM dbo.team_Meeting m WHERE m.MeetingID=a.MeetingID UNION SELECT t.ManagerEmployeeID FROM dbo.team_MeetingTeam mt JOIN dbo.team_Team t ON t.TeamID=mt.TeamID WHERE mt.MeetingID=a.MeetingID AND t.ManagerEmployeeID IS NOT NULL) r JOIN dbo.EmployeeInfo e ON e.EmployeeID=r.EmployeeID WHERE a.ActionItemID=@ActionItemID AND NULLIF(LTRIM(RTRIM(e.OfficialEmailID)),'') IS NOT NULL;
END
GO

/* Initial teams: manager/members can be assigned in Team Master after deployment. */
DECLARE @SeedBy bigint=(SELECT TOP(1) EmployeeID FROM dbo.EmployeeInfo WHERE ISNULL(IsDelete,0)=0 ORDER BY EmployeeID);
INSERT dbo.team_Team(TeamName,ProjectID,Description,IsActive,CreatedBy)
SELECT s.TeamName,p.ProjectID,'Initial Team Meeting Management setup',1,@SeedBy FROM (VALUES(N'561 Servicing',N'561'),(N'561 C&C',N'561'),(N'667',N'667'))s(TeamName,ProjectToken) CROSS APPLY(SELECT TOP(1) ProjectID FROM dbo.Project WHERE ProjectName LIKE s.ProjectToken+'%' ORDER BY ProjectID)p WHERE @SeedBy IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.team_Team t WHERE t.ProjectID=p.ProjectID AND t.TeamName=s.TeamName AND t.IsActive=1);
GO

