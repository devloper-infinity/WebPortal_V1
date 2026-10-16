SET XACT_ABORT ON;
GO
IF OBJECT_ID('dbo.BulletinFolderMaster') IS NULL CREATE TABLE dbo.BulletinFolderMaster(
 FolderID bigint IDENTITY PRIMARY KEY,ParentFolderID bigint NULL REFERENCES dbo.BulletinFolderMaster(FolderID),FolderName nvarchar(150) NOT NULL,
 IsSystem bit NOT NULL CONSTRAINT DF_BFM_System DEFAULT 0,IsDeleted bit NOT NULL CONSTRAINT DF_BFM_Delete DEFAULT 0,
 CreatedBy int NOT NULL,CreatedDate datetime2(0) NOT NULL CONSTRAINT DF_BFM_Date DEFAULT SYSDATETIME(),ModifiedBy int NULL,ModifiedDate datetime2(0) NULL,
 RowVersion rowversion,CONSTRAINT UQ_BFM_Name UNIQUE(ParentFolderID,FolderName,IsDeleted));
GO
IF OBJECT_ID('dbo.BulletinMaster') IS NULL CREATE TABLE dbo.BulletinMaster(
 BulletinID bigint IDENTITY PRIMARY KEY,FolderID bigint NULL REFERENCES dbo.BulletinFolderMaster(FolderID),Title nvarchar(250) NOT NULL,Category nvarchar(80) NOT NULL,
 Priority varchar(20) NOT NULL,Summary nvarchar(2000) NOT NULL,PublishStatus varchar(20) NOT NULL,PublishDate datetime2(0) NULL,ScheduleDate datetime2(0) NULL,
 IsAcknowledgementRequired bit NOT NULL DEFAULT 0,IsArchived bit NOT NULL DEFAULT 0,PublishedBy int NULL,CreatedBy int NOT NULL,CreatedDate datetime2(0) NOT NULL DEFAULT SYSDATETIME(),
 ModifiedBy int NULL,ModifiedDate datetime2(0) NULL,IsDeleted bit NOT NULL DEFAULT 0,RowVersion rowversion,
 CONSTRAINT CK_BM_Priority CHECK(Priority IN('Normal','Important','Critical')),CONSTRAINT CK_BM_Status CHECK(PublishStatus IN('Draft','Scheduled','Published','Archived')));
GO
IF OBJECT_ID('dbo.BulletinDocuments') IS NULL CREATE TABLE dbo.BulletinDocuments(
 DocumentID bigint IDENTITY PRIMARY KEY,BulletinID bigint NULL REFERENCES dbo.BulletinMaster(BulletinID),FolderID bigint NOT NULL REFERENCES dbo.BulletinFolderMaster(FolderID),
 DisplayName nvarchar(255) NOT NULL,CurrentVersionID bigint NULL,IsDeleted bit NOT NULL DEFAULT 0,CreatedBy int NOT NULL,CreatedDate datetime2(0) NOT NULL DEFAULT SYSDATETIME());
GO
IF OBJECT_ID('dbo.BulletinDocumentVersions') IS NULL CREATE TABLE dbo.BulletinDocumentVersions(
 DocumentVersionID bigint IDENTITY PRIMARY KEY,DocumentID bigint NOT NULL REFERENCES dbo.BulletinDocuments(DocumentID),VersionNo int NOT NULL,
 OriginalFileName nvarchar(255) NOT NULL,StoredFileName varchar(80) NOT NULL,PdfStoredFileName varchar(80) NULL,ContentType varchar(150) NOT NULL,FileSize bigint NOT NULL,
 Sha256 varchar(64) NOT NULL,UploadedBy int NOT NULL,UploadedDate datetime2(0) NOT NULL DEFAULT SYSDATETIME(),IsDeleted bit NOT NULL DEFAULT 0,
 CONSTRAINT UQ_BDV_Version UNIQUE(DocumentID,VersionNo));
GO
IF NOT EXISTS(SELECT 1 FROM sys.foreign_keys WHERE name='FK_BD_CurrentVersion') ALTER TABLE dbo.BulletinDocuments ADD CONSTRAINT FK_BD_CurrentVersion FOREIGN KEY(CurrentVersionID) REFERENCES dbo.BulletinDocumentVersions(DocumentVersionID);
GO
IF OBJECT_ID('dbo.BulletinAudience') IS NULL CREATE TABLE dbo.BulletinAudience(
 AudienceID bigint IDENTITY PRIMARY KEY,BulletinID bigint NOT NULL REFERENCES dbo.BulletinMaster(BulletinID),AudienceType varchar(20) NOT NULL,
 DomainID int NULL,LocationID int NULL,ProjectID int NULL,EmployeeID int NULL,ResolvedEmployeeID int NULL,ResolvedDate datetime2(0) NULL,
 CONSTRAINT CK_BA_Type CHECK(AudienceType IN('AllOperations','Domain','Location','Project','Employee')));
GO
IF OBJECT_ID('dbo.BulletinUserTracking') IS NULL CREATE TABLE dbo.BulletinUserTracking(
 TrackingID bigint IDENTITY PRIMARY KEY,BulletinID bigint NOT NULL REFERENCES dbo.BulletinMaster(BulletinID),EmployeeID int NOT NULL,
 FirstViewedDateTime datetime2(0) NULL,LastViewedDateTime datetime2(0) NULL,ReadDateTime datetime2(0) NULL,AcknowledgedDateTime datetime2(0) NULL,
 DocumentVersionID bigint NULL REFERENCES dbo.BulletinDocumentVersions(DocumentVersionID),Status varchar(20) NOT NULL DEFAULT 'Unread',LastPopupDateTime datetime2(0) NULL,
 CONSTRAINT UQ_BUT UNIQUE(BulletinID,EmployeeID),CONSTRAINT CK_BUT_Status CHECK(Status IN('Unread','Viewed','Read','Acknowledged')));
GO
IF OBJECT_ID('dbo.BulletinFolderRights') IS NULL CREATE TABLE dbo.BulletinFolderRights(
 FolderRightID bigint IDENTITY PRIMARY KEY,FolderID bigint NOT NULL REFERENCES dbo.BulletinFolderMaster(FolderID),EmployeeID int NOT NULL,InheritToChildren bit NOT NULL DEFAULT 1,
 CanView bit NULL,CanUpload bit NULL,CanCreateFolder bit NULL,CanRenameFolder bit NULL,CanMoveFolder bit NULL,CanDeleteFolder bit NULL,CanManagePermissions bit NULL,
 IsDeleted bit NOT NULL DEFAULT 0,GrantedBy int NOT NULL,GrantedDate datetime2(0) NOT NULL DEFAULT SYSDATETIME(),ModifiedBy int NULL,ModifiedDate datetime2(0) NULL,
 CONSTRAINT UQ_BFR UNIQUE(FolderID,EmployeeID));
GO
IF OBJECT_ID('dbo.BulletinAuditLog') IS NULL CREATE TABLE dbo.BulletinAuditLog(
 AuditID bigint IDENTITY PRIMARY KEY,EntityType varchar(30) NOT NULL,EntityID bigint NOT NULL,ActionName varchar(50) NOT NULL,OldValues nvarchar(max) NULL,NewValues nvarchar(max) NULL,
 EmployeeID int NOT NULL,ActionDate datetime2(0) NOT NULL DEFAULT SYSDATETIME(),IPAddress varchar(50) NULL);
GO
IF OBJECT_ID('dbo.BulletinTeamMaster') IS NULL CREATE TABLE dbo.BulletinTeamMaster(
 TeamID int IDENTITY PRIMARY KEY,TeamName nvarchar(150) NOT NULL,DomainID int NOT NULL,SubDomainID int NOT NULL,LocationID int NULL,ProjectID int NULL,
 IsDeleted bit NOT NULL DEFAULT 0,CreatedBy int NOT NULL,CreatedDate datetime2(0) NOT NULL DEFAULT SYSDATETIME(),ModifiedBy int NULL,ModifiedDate datetime2(0) NULL,
 CONSTRAINT UQ_BulletinTeam_Name UNIQUE(TeamName,IsDeleted));
GO
IF OBJECT_ID('dbo.BulletinTeamMember') IS NULL CREATE TABLE dbo.BulletinTeamMember(TeamMemberID bigint IDENTITY PRIMARY KEY,TeamID int NOT NULL REFERENCES dbo.BulletinTeamMaster(TeamID),EmployeeID int NOT NULL,IsDeleted bit NOT NULL DEFAULT 0,CreatedBy int NOT NULL,CreatedDate datetime2(0) NOT NULL DEFAULT SYSDATETIME(),CONSTRAINT UQ_BulletinTeamMember UNIQUE(TeamID,EmployeeID));
GO
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.BulletinMaster')AND name='IX_BM_Publish')CREATE INDEX IX_BM_Publish ON dbo.BulletinMaster(PublishStatus,PublishDate,IsDeleted);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.BulletinAudience')AND name='IX_BA_Resolved')CREATE INDEX IX_BA_Resolved ON dbo.BulletinAudience(ResolvedEmployeeID,BulletinID) WHERE ResolvedEmployeeID IS NOT NULL;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.BulletinUserTracking')AND name='IX_BUT_Employee')CREATE INDEX IX_BUT_Employee ON dbo.BulletinUserTracking(EmployeeID,Status,BulletinID);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.BulletinFolderMaster')AND name='IX_BFM_Parent')CREATE INDEX IX_BFM_Parent ON dbo.BulletinFolderMaster(ParentFolderID,IsDeleted);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.BulletinDocuments')AND name='IX_BD_Folder')CREATE INDEX IX_BD_Folder ON dbo.BulletinDocuments(FolderID,IsDeleted);
GO
IF OBJECT_ID('dbo.ufn_BulletinFolderRights') IS NULL EXEC('CREATE FUNCTION dbo.ufn_BulletinFolderRights(@FolderID bigint,@EmployeeID int) RETURNS TABLE AS RETURN SELECT CAST(0 AS bit) CanView');
GO
ALTER FUNCTION dbo.ufn_BulletinFolderRights(@FolderID bigint,@EmployeeID int)
RETURNS TABLE AS RETURN
WITH P AS(SELECT FolderID,ParentFolderID,0 Lvl FROM dbo.BulletinFolderMaster WHERE FolderID=@FolderID UNION ALL SELECT f.FolderID,f.ParentFolderID,p.Lvl+1 FROM dbo.BulletinFolderMaster f JOIN P ON p.ParentFolderID=f.FolderID),
R AS(SELECT TOP(1) r.* FROM P JOIN dbo.BulletinFolderRights r ON r.FolderID=P.FolderID AND r.EmployeeID=@EmployeeID AND r.IsDeleted=0 WHERE P.Lvl=0 OR r.InheritToChildren=1 ORDER BY P.Lvl)
SELECT CAST(ISNULL(CanView,0) AS bit)CanView,CAST(ISNULL(CanUpload,0) AS bit)CanUpload,CAST(ISNULL(CanCreateFolder,0) AS bit)CanCreateFolder,CAST(ISNULL(CanRenameFolder,0) AS bit)CanRenameFolder,CAST(ISNULL(CanMoveFolder,0) AS bit)CanMoveFolder,CAST(ISNULL(CanDeleteFolder,0) AS bit)CanDeleteFolder,CAST(ISNULL(CanManagePermissions,0) AS bit)CanManagePermissions FROM R;
GO
IF OBJECT_ID('dbo.usp_Bulletin_Bootstrap') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_Bootstrap AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_Bootstrap @EmployeeID int AS
BEGIN SET NOCOUNT ON;
 SELECT TOP(1) e.EmployeeID,e.Department,e.Domain,e.WorkingBranch,e.Project,CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.BulletinFolderRights r WHERE r.EmployeeID=@EmployeeID AND r.CanManagePermissions=1 AND r.IsDeleted=0) THEN 1 ELSE 0 END AS bit) IsAdmin,CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.EmployeeInfo x WHERE x.ProjectManager=@EmployeeID AND ISNULL(x.IsDelete,0)=0)THEN 1 ELSE 0 END AS bit)IsManager FROM dbo.EmployeeInfo e WHERE e.EmployeeID=@EmployeeID AND ISNULL(e.IsDelete,0)=0;
 SELECT DomainID,DomainName FROM dbo.Domain WHERE ISNULL(IsDelete,0)=0 ORDER BY DomainName;
 SELECT BranchID,BranchName FROM dbo.Branch WHERE ISNULL(IsDelete,0)=0 ORDER BY BranchName;
 SELECT ProjectID,ProjectName FROM dbo.Project WHERE ISNULL(IsDelete,0)=0 ORDER BY ProjectName;
 SELECT EmployeeID,Code+' - '+LTRIM(RTRIM(ISNULL(FirstName,'')+' '+ISNULL(lastName,''))) EmployeeName FROM dbo.EmployeeInfo WHERE ISNULL(IsDelete,0)=0 ORDER BY FirstName,lastName;
END
GO
IF OBJECT_ID('dbo.usp_Bulletin_FolderList') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_FolderList AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_FolderList @EmployeeID int,@ParentFolderID bigint=NULL AS
BEGIN SET NOCOUNT ON;
 SELECT f.FolderID,f.ParentFolderID,f.FolderName,f.CreatedDate,r.* FROM dbo.BulletinFolderMaster f CROSS APPLY dbo.ufn_BulletinFolderRights(f.FolderID,@EmployeeID)r WHERE f.IsDeleted=0 AND r.CanView=1 AND ((@ParentFolderID IS NULL AND f.ParentFolderID IS NULL) OR f.ParentFolderID=@ParentFolderID) ORDER BY f.FolderName;
 SELECT d.DocumentID,d.FolderID,d.DisplayName,d.CurrentVersionID,v.VersionNo,v.OriginalFileName,v.ContentType,v.FileSize,v.UploadedDate FROM dbo.BulletinDocuments d JOIN dbo.BulletinDocumentVersions v ON v.DocumentVersionID=d.CurrentVersionID CROSS APPLY dbo.ufn_BulletinFolderRights(d.FolderID,@EmployeeID)r WHERE d.IsDeleted=0 AND v.IsDeleted=0 AND r.CanView=1 AND d.FolderID=@ParentFolderID ORDER BY d.DisplayName;
END
GO
IF OBJECT_ID('dbo.usp_Bulletin_FolderSave') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_FolderSave AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_FolderSave @Action varchar(20),@FolderID bigint=NULL,@ParentFolderID bigint=NULL,@DestinationFolderID bigint=NULL,@FolderName nvarchar(150)=NULL,@EmployeeID int,@IPAddress varchar(50)=NULL AS
BEGIN SET XACT_ABORT ON;BEGIN TRAN;
 DECLARE @Right bit=0,@Old nvarchar(max);IF @Action='Create'AND @ParentFolderID IS NULL AND EXISTS(SELECT 1 FROM dbo.BulletinFolderRights WHERE EmployeeID=@EmployeeID AND CanManagePermissions=1 AND IsDeleted=0)SET @Right=1;ELSE SELECT @Right=CASE @Action WHEN 'Create' THEN CanCreateFolder WHEN 'Rename' THEN CanRenameFolder WHEN 'Move' THEN CanMoveFolder WHEN 'Delete' THEN CanDeleteFolder WHEN 'Recover' THEN CanDeleteFolder ELSE 0 END FROM dbo.ufn_BulletinFolderRights(ISNULL(@FolderID,@ParentFolderID),@EmployeeID);
 IF @Right<>1 THROW 51000,'Folder permission denied.',1;
 IF @Action='Create' BEGIN INSERT dbo.BulletinFolderMaster(ParentFolderID,FolderName,CreatedBy)VALUES(@ParentFolderID,@FolderName,@EmployeeID);SET @FolderID=SCOPE_IDENTITY();IF @ParentFolderID IS NULL INSERT dbo.BulletinFolderRights(FolderID,EmployeeID,CanView,CanUpload,CanCreateFolder,CanRenameFolder,CanMoveFolder,CanDeleteFolder,CanManagePermissions,InheritToChildren,GrantedBy)VALUES(@FolderID,@EmployeeID,1,1,1,1,1,1,1,1,@EmployeeID);END
 ELSE IF @Action='Rename' UPDATE dbo.BulletinFolderMaster SET FolderName=@FolderName,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHERE FolderID=@FolderID AND IsDeleted=0;
 ELSE IF @Action='Move' BEGIN DECLARE @InvalidMove bit=0;WITH X AS(SELECT FolderID,ParentFolderID FROM dbo.BulletinFolderMaster WHERE FolderID=@DestinationFolderID UNION ALL SELECT f.FolderID,f.ParentFolderID FROM dbo.BulletinFolderMaster f JOIN X ON f.FolderID=X.ParentFolderID)SELECT @InvalidMove=1 FROM X WHERE FolderID=@FolderID;IF @FolderID=@DestinationFolderID OR @InvalidMove=1 THROW 51001,'Cannot move a folder into itself or its descendant.',1;IF NOT EXISTS(SELECT 1 FROM dbo.ufn_BulletinFolderRights(@DestinationFolderID,@EmployeeID)WHERE CanCreateFolder=1)THROW 51000,'Destination permission denied.',1;UPDATE dbo.BulletinFolderMaster SET ParentFolderID=@DestinationFolderID,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME()WHERE FolderID=@FolderID AND IsDeleted=0;END
 ELSE IF @Action IN('Delete','Recover') BEGIN;WITH X AS(SELECT FolderID FROM dbo.BulletinFolderMaster WHERE FolderID=@FolderID UNION ALL SELECT f.FolderID FROM dbo.BulletinFolderMaster f JOIN X ON f.ParentFolderID=X.FolderID)UPDATE f SET IsDeleted=CASE WHEN @Action='Delete'THEN 1 ELSE 0 END,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() FROM dbo.BulletinFolderMaster f JOIN X ON X.FolderID=f.FolderID;WITH X AS(SELECT FolderID FROM dbo.BulletinFolderMaster WHERE FolderID=@FolderID UNION ALL SELECT f.FolderID FROM dbo.BulletinFolderMaster f JOIN X ON f.ParentFolderID=X.FolderID)UPDATE d SET IsDeleted=CASE WHEN @Action='Delete'THEN 1 ELSE 0 END FROM dbo.BulletinDocuments d JOIN X ON X.FolderID=d.FolderID;END
 INSERT dbo.BulletinAuditLog(EntityType,EntityID,ActionName,NewValues,EmployeeID,IPAddress)VALUES('Folder',@FolderID,@Action,@FolderName,@EmployeeID,@IPAddress);COMMIT;SELECT @FolderID FolderID;
END
GO
IF OBJECT_ID('dbo.usp_Bulletin_RightsSave') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_RightsSave AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_RightsSave @FolderID bigint,@TargetEmployeeID int,@CanView bit=NULL,@CanUpload bit=NULL,@CanCreateFolder bit=NULL,@CanRenameFolder bit=NULL,@CanMoveFolder bit=NULL,@CanDeleteFolder bit=NULL,@CanManagePermissions bit=NULL,@Inherit bit=1,@EmployeeID int AS
BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.ufn_BulletinFolderRights(@FolderID,@EmployeeID)WHERE CanManagePermissions=1)THROW 51000,'Permission management denied.',1;
 MERGE dbo.BulletinFolderRights t USING(SELECT @FolderID FolderID,@TargetEmployeeID EmployeeID)s ON t.FolderID=s.FolderID AND t.EmployeeID=s.EmployeeID WHEN MATCHED THEN UPDATE SET CanView=@CanView,CanUpload=@CanUpload,CanCreateFolder=@CanCreateFolder,CanRenameFolder=@CanRenameFolder,CanMoveFolder=@CanMoveFolder,CanDeleteFolder=@CanDeleteFolder,CanManagePermissions=@CanManagePermissions,InheritToChildren=@Inherit,IsDeleted=0,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME() WHEN NOT MATCHED THEN INSERT(FolderID,EmployeeID,CanView,CanUpload,CanCreateFolder,CanRenameFolder,CanMoveFolder,CanDeleteFolder,CanManagePermissions,InheritToChildren,GrantedBy)VALUES(@FolderID,@TargetEmployeeID,@CanView,@CanUpload,@CanCreateFolder,@CanRenameFolder,@CanMoveFolder,@CanDeleteFolder,@CanManagePermissions,@Inherit,@EmployeeID);
 INSERT dbo.BulletinAuditLog(EntityType,EntityID,ActionName,NewValues,EmployeeID)VALUES('FolderRight',@FolderID,'Grant/Override',CONVERT(varchar(20),@TargetEmployeeID),@EmployeeID);END
GO
IF OBJECT_ID('dbo.usp_Bulletin_List') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_List AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_List @EmployeeID int,@From date=NULL,@To date=NULL,@DomainID int=NULL,@LocationID int=NULL,@ProjectID int=NULL,@Category nvarchar(80)=NULL,@Status varchar(20)=NULL AS
BEGIN SET NOCOUNT ON;SELECT b.BulletinID,b.Title,b.Category,b.Priority,b.Summary,b.PublishDate,b.ScheduleDate,b.PublishStatus,b.IsAcknowledgementRequired,e.Code PublishedBy,ISNULL(t.Status,b.PublishStatus)Status,t.ReadDateTime,t.AcknowledgedDateTime,d.DocumentID,d.CurrentVersionID,d.DisplayName Attachment,CAST(CASE WHEN b.CreatedBy=@EmployeeID THEN 1 ELSE 0 END AS bit)CanEdit,CAST(CASE WHEN t.TrackingID IS NULL THEN 0 ELSE 1 END AS bit)IsTargeted FROM dbo.BulletinMaster b LEFT JOIN dbo.BulletinUserTracking t ON t.BulletinID=b.BulletinID AND t.EmployeeID=@EmployeeID LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=b.PublishedBy LEFT JOIN dbo.BulletinDocuments d ON d.BulletinID=b.BulletinID AND d.IsDeleted=0 WHERE b.IsDeleted=0 AND(t.TrackingID IS NOT NULL OR b.CreatedBy=@EmployeeID)AND(@From IS NULL OR CAST(ISNULL(b.PublishDate,b.CreatedDate)AS date)>=@From)AND(@To IS NULL OR CAST(ISNULL(b.PublishDate,b.CreatedDate)AS date)<=@To)AND(@Category IS NULL OR b.Category=@Category)AND(@Status IS NULL OR(@Status='Important'AND b.Priority IN('Important','Critical'))OR(@Status='Archived'AND b.PublishStatus='Archived')OR(@Status NOT IN('Important','Archived')AND ISNULL(t.Status,b.PublishStatus)=@Status))AND EXISTS(SELECT 1 FROM dbo.EmployeeInfo me WHERE me.EmployeeID=@EmployeeID AND(@DomainID IS NULL OR me.Domain=@DomainID)AND(@LocationID IS NULL OR me.WorkingBranch=@LocationID)AND(@ProjectID IS NULL OR me.Project=@ProjectID))ORDER BY CASE b.Priority WHEN'Critical'THEN 1 WHEN'Important'THEN 2 ELSE 3 END,ISNULL(b.PublishDate,b.CreatedDate)DESC;END
GO
IF OBJECT_ID('dbo.usp_Bulletin_Track') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_Track AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_Track @BulletinID bigint,@EmployeeID int,@Action varchar(20),@DocumentVersionID bigint=NULL AS
BEGIN SET XACT_ABORT ON;BEGIN TRAN;IF NOT EXISTS(SELECT 1 FROM dbo.BulletinUserTracking WITH(UPDLOCK,HOLDLOCK)WHERE BulletinID=@BulletinID AND EmployeeID=@EmployeeID)AND NOT EXISTS(SELECT 1 FROM dbo.BulletinMaster WHERE BulletinID=@BulletinID AND CreatedBy=@EmployeeID AND IsDeleted=0)THROW 51000,'Bulletin access denied.',1;
 UPDATE dbo.BulletinUserTracking SET FirstViewedDateTime=CASE WHEN @Action='View' AND FirstViewedDateTime IS NULL THEN SYSDATETIME()ELSE FirstViewedDateTime END,LastViewedDateTime=CASE WHEN @Action='View'THEN SYSDATETIME()ELSE LastViewedDateTime END,ReadDateTime=CASE WHEN @Action='Read'THEN ISNULL(ReadDateTime,SYSDATETIME())ELSE ReadDateTime END,AcknowledgedDateTime=CASE WHEN @Action='Acknowledge'THEN ISNULL(AcknowledgedDateTime,SYSDATETIME())ELSE AcknowledgedDateTime END,DocumentVersionID=ISNULL(@DocumentVersionID,DocumentVersionID),Status=CASE WHEN @Action='Acknowledge'THEN'Acknowledged'WHEN @Action='Read'AND Status<>'Acknowledged'THEN'Read'WHEN @Action='View'AND Status='Unread'THEN'Viewed'ELSE Status END WHERE BulletinID=@BulletinID AND EmployeeID=@EmployeeID;COMMIT;END
GO
IF OBJECT_ID('dbo.usp_Bulletin_Save') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_Save AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_Save @BulletinID bigint=0,@FolderID bigint=NULL,@Title nvarchar(250),@Category nvarchar(80),@Priority varchar(20),@Summary nvarchar(2000),@ScheduleDate datetime2(0)=NULL,@RequireAcknowledgement bit,@AudienceXml xml,@EmployeeID int AS
BEGIN SET XACT_ABORT ON;BEGIN TRAN;IF NOT EXISTS(SELECT 1 FROM dbo.EmployeeInfo e WHERE e.EmployeeID=@EmployeeID AND ISNULL(e.IsDelete,0)=0 AND(EXISTS(SELECT 1 FROM dbo.EmployeeInfo x WHERE x.ProjectManager=@EmployeeID AND ISNULL(x.IsDelete,0)=0)OR EXISTS(SELECT 1 FROM dbo.BulletinFolderRights r WHERE r.EmployeeID=@EmployeeID AND r.CanManagePermissions=1 AND r.IsDeleted=0)))THROW 51000,'Manager permission required.',1;
 IF @BulletinID=0 BEGIN INSERT dbo.BulletinMaster(FolderID,Title,Category,Priority,Summary,PublishStatus,ScheduleDate,IsAcknowledgementRequired,CreatedBy)VALUES(@FolderID,@Title,@Category,@Priority,@Summary,'Draft',@ScheduleDate,@RequireAcknowledgement,@EmployeeID);SET @BulletinID=SCOPE_IDENTITY();END ELSE UPDATE dbo.BulletinMaster SET FolderID=@FolderID,Title=@Title,Category=@Category,Priority=@Priority,Summary=@Summary,ScheduleDate=@ScheduleDate,IsAcknowledgementRequired=@RequireAcknowledgement,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME()WHERE BulletinID=@BulletinID AND IsDeleted=0 AND PublishStatus IN('Draft','Scheduled');
 DELETE dbo.BulletinAudience WHERE BulletinID=@BulletinID AND ResolvedEmployeeID IS NULL;DECLARE @Type varchar(20)=@AudienceXml.value('(/audience/@type)[1]','varchar(20)');IF @Type='AllOperations'INSERT dbo.BulletinAudience(BulletinID,AudienceType)VALUES(@BulletinID,@Type);ELSE INSERT dbo.BulletinAudience(BulletinID,AudienceType,DomainID,LocationID,ProjectID,EmployeeID)SELECT @BulletinID,@Type,CASE WHEN @Type='Domain'THEN CONVERT(int,N.value('.','varchar(20)'))END,CASE WHEN @Type='Location'THEN CONVERT(int,N.value('.','varchar(20)'))END,CASE WHEN @Type='Project'THEN CONVERT(int,N.value('.','varchar(20)'))END,CASE WHEN @Type='Employee'THEN CONVERT(int,N.value('.','varchar(20)'))END FROM @AudienceXml.nodes('/audience/value')X(N);
 INSERT dbo.BulletinAuditLog(EntityType,EntityID,ActionName,EmployeeID)VALUES('Bulletin',@BulletinID,'Save',@EmployeeID);COMMIT;SELECT @BulletinID BulletinID;END
GO
IF OBJECT_ID('dbo.usp_Bulletin_Publish') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_Publish AS SELECT 1');
GO
IF OBJECT_ID('dbo.usp_Bulletin_DiscardDraft') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_DiscardDraft AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_DiscardDraft @BulletinID bigint,@EmployeeID int AS BEGIN SET XACT_ABORT ON;BEGIN TRAN;IF NOT EXISTS(SELECT 1 FROM dbo.BulletinMaster WHERE BulletinID=@BulletinID AND CreatedBy=@EmployeeID AND PublishStatus IN('Draft','Scheduled'))THROW 51000,'Draft cannot be removed.',1;UPDATE dbo.BulletinMaster SET IsDeleted=1,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME()WHERE BulletinID=@BulletinID;UPDATE dbo.BulletinDocuments SET IsDeleted=1 WHERE BulletinID=@BulletinID;INSERT dbo.BulletinAuditLog(EntityType,EntityID,ActionName,EmployeeID)VALUES('Bulletin',@BulletinID,'DiscardFailedCreation',@EmployeeID);COMMIT;END
GO
ALTER PROCEDURE dbo.usp_Bulletin_Publish @BulletinID bigint,@Action varchar(20),@EmployeeID int AS
BEGIN SET XACT_ABORT ON;BEGIN TRAN;IF @Action='Archive'BEGIN UPDATE dbo.BulletinMaster SET PublishStatus='Archived',IsArchived=1,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME()WHERE BulletinID=@BulletinID AND(CreatedBy=@EmployeeID OR EXISTS(SELECT 1 FROM dbo.BulletinFolderRights WHERE EmployeeID=@EmployeeID AND CanManagePermissions=1 AND IsDeleted=0));IF @@ROWCOUNT=0 THROW 51000,'Archive permission denied.',1;COMMIT;RETURN;END
 DECLARE @PublishDate datetime2(0)=CASE WHEN @Action='Schedule'THEN(SELECT ScheduleDate FROM dbo.BulletinMaster WHERE BulletinID=@BulletinID)ELSE SYSDATETIME()END,@Folder bigint=(SELECT FolderID FROM dbo.BulletinMaster WHERE BulletinID=@BulletinID),@Root bigint,@Month bigint,@MonthName varchar(30);IF @Folder IS NULL BEGIN SELECT TOP(1)@Root=FolderID FROM dbo.BulletinFolderMaster WHERE ParentFolderID IS NULL AND FolderName='Operations Documents'AND IsDeleted=0;IF @Root IS NOT NULL BEGIN SET @MonthName=DATENAME(month,@PublishDate)+'-'+CONVERT(varchar(4),YEAR(@PublishDate));SELECT @Month=FolderID FROM dbo.BulletinFolderMaster WHERE ParentFolderID=@Root AND FolderName=@MonthName AND IsDeleted=0;IF @Month IS NULL BEGIN INSERT dbo.BulletinFolderMaster(ParentFolderID,FolderName,IsSystem,CreatedBy)VALUES(@Root,@MonthName,1,@EmployeeID);SET @Month=SCOPE_IDENTITY();END;SET @Folder=@Month;END END
 UPDATE dbo.BulletinMaster SET FolderID=@Folder,PublishStatus=CASE WHEN @Action='Schedule'THEN'Scheduled'ELSE'Published'END,PublishDate=@PublishDate,PublishedBy=@EmployeeID WHERE BulletinID=@BulletinID AND IsDeleted=0;DELETE dbo.BulletinAudience WHERE BulletinID=@BulletinID AND ResolvedEmployeeID IS NOT NULL;
 ;WITH T AS(SELECT DISTINCT e.EmployeeID FROM dbo.BulletinAudience a CROSS JOIN dbo.EmployeeInfo e JOIN dbo.Department dep ON dep.DepartmentID=e.Department WHERE a.BulletinID=@BulletinID AND a.ResolvedEmployeeID IS NULL AND ISNULL(e.IsDelete,0)=0 AND((a.AudienceType='AllOperations'AND LTRIM(RTRIM(dep.DepartmentName))IN('Loan Processing','Production'))OR(a.AudienceType='Domain'AND e.Domain=a.DomainID)OR(a.AudienceType='Location'AND e.WorkingBranch=a.LocationID)OR(a.AudienceType='Project'AND e.Project=a.ProjectID)OR(a.AudienceType='Employee'AND e.EmployeeID=a.EmployeeID)))INSERT dbo.BulletinAudience(BulletinID,AudienceType,ResolvedEmployeeID,ResolvedDate)SELECT @BulletinID,'Employee',EmployeeID,SYSDATETIME()FROM T;
 MERGE dbo.BulletinUserTracking t USING(SELECT DISTINCT @BulletinID BulletinID,ResolvedEmployeeID EmployeeID FROM dbo.BulletinAudience WHERE BulletinID=@BulletinID AND ResolvedEmployeeID IS NOT NULL)s ON t.BulletinID=s.BulletinID AND t.EmployeeID=s.EmployeeID WHEN NOT MATCHED THEN INSERT(BulletinID,EmployeeID,Status)VALUES(s.BulletinID,s.EmployeeID,'Unread');INSERT dbo.BulletinAuditLog(EntityType,EntityID,ActionName,EmployeeID)VALUES('Bulletin',@BulletinID,@Action,@EmployeeID);COMMIT;END
GO
IF OBJECT_ID('dbo.usp_Bulletin_PublishDue') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_PublishDue AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_PublishDue AS
BEGIN DECLARE @ID bigint,@User int;DECLARE c CURSOR LOCAL FAST_FORWARD FOR SELECT BulletinID,CreatedBy FROM dbo.BulletinMaster WHERE PublishStatus='Scheduled'AND ScheduleDate<=SYSDATETIME()AND IsDeleted=0;OPEN c;FETCH NEXT FROM c INTO @ID,@User;WHILE @@FETCH_STATUS=0 BEGIN EXEC dbo.usp_Bulletin_Publish @BulletinID=@ID,@Action='Publish',@EmployeeID=@User;FETCH NEXT FROM c INTO @ID,@User;END;CLOSE c;DEALLOCATE c;END
GO
IF OBJECT_ID('dbo.usp_Bulletin_DocumentSave') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_DocumentSave AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_DocumentSave @FolderID bigint,@BulletinID bigint=NULL,@DocumentID bigint=NULL,@OriginalFileName nvarchar(255),@StoredFileName varchar(80),@PdfStoredFileName varchar(80)=NULL,@ContentType varchar(150),@FileSize bigint,@Sha256 varchar(64),@EmployeeID int AS
BEGIN SET XACT_ABORT ON;BEGIN TRAN;IF NOT EXISTS(SELECT 1 FROM dbo.ufn_BulletinFolderRights(@FolderID,@EmployeeID)WHERE CanUpload=1)THROW 51000,'Upload permission denied.',1;IF @DocumentID IS NULL BEGIN DECLARE @Now datetime2(0)=DATEADD(minute,330,SYSUTCDATETIME()),@Month bigint,@Name varchar(30);SET @Name=DATENAME(month,@Now)+'-'+CONVERT(varchar(4),YEAR(@Now));SELECT @Month=FolderID FROM dbo.BulletinFolderMaster WITH(UPDLOCK,HOLDLOCK)WHERE ParentFolderID=@FolderID AND FolderName=@Name AND IsDeleted=0;IF @Month IS NULL BEGIN INSERT dbo.BulletinFolderMaster(ParentFolderID,FolderName,IsSystem,CreatedBy)VALUES(@FolderID,@Name,1,@EmployeeID);SET @Month=SCOPE_IDENTITY();END;SET @FolderID=@Month;INSERT dbo.BulletinDocuments(BulletinID,FolderID,DisplayName,CreatedBy)VALUES(@BulletinID,@FolderID,@OriginalFileName,@EmployeeID);SET @DocumentID=SCOPE_IDENTITY();END ELSE IF NOT EXISTS(SELECT 1 FROM dbo.BulletinDocuments WHERE DocumentID=@DocumentID AND FolderID=@FolderID AND IsDeleted=0)THROW 51001,'Document not found.',1;DECLARE @Version int=ISNULL((SELECT MAX(VersionNo)FROM dbo.BulletinDocumentVersions WITH(UPDLOCK,HOLDLOCK)WHERE DocumentID=@DocumentID),0)+1,@VersionID bigint;INSERT dbo.BulletinDocumentVersions(DocumentID,VersionNo,OriginalFileName,StoredFileName,PdfStoredFileName,ContentType,FileSize,Sha256,UploadedBy)VALUES(@DocumentID,@Version,@OriginalFileName,@StoredFileName,@PdfStoredFileName,@ContentType,@FileSize,@Sha256,@EmployeeID);SET @VersionID=SCOPE_IDENTITY();UPDATE dbo.BulletinDocuments SET CurrentVersionID=@VersionID,DisplayName=@OriginalFileName WHERE DocumentID=@DocumentID;INSERT dbo.BulletinAuditLog(EntityType,EntityID,ActionName,EmployeeID)VALUES('Document',@DocumentID,'UploadVersion',@EmployeeID);COMMIT;SELECT @VersionID DocumentVersionID;END
GO
IF OBJECT_ID('dbo.usp_Bulletin_Report') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_Report AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_Report @EmployeeID int,@From date=NULL,@To date=NULL,@DomainID int=NULL,@LocationID int=NULL,@ProjectID int=NULL,@TargetEmployeeID int=NULL AS
BEGIN
 SET NOCOUNT ON;
 IF NOT EXISTS(SELECT 1 FROM dbo.BulletinFolderRights WHERE EmployeeID=@EmployeeID AND CanManagePermissions=1 AND IsDeleted=0)THROW 51000,'Report access denied.',1;
 SELECT b.BulletinID,b.Title,b.PublishDate,COUNT(*)TargetedCount,
  SUM(CASE WHEN t.Status='Unread'THEN 1 ELSE 0 END)UnreadCount,
  SUM(CASE WHEN t.Status='Viewed'THEN 1 ELSE 0 END)ViewedCount,
  SUM(CASE WHEN t.Status IN('Read','Acknowledged')THEN 1 ELSE 0 END)ReadCount,
  SUM(CASE WHEN t.Status='Acknowledged'THEN 1 ELSE 0 END)AcknowledgedCount
 FROM dbo.BulletinUserTracking t JOIN dbo.BulletinMaster b ON b.BulletinID=t.BulletinID JOIN dbo.EmployeeInfo e ON e.EmployeeID=t.EmployeeID
 WHERE b.IsDeleted=0 AND(@From IS NULL OR CAST(b.PublishDate AS date)>=@From)AND(@To IS NULL OR CAST(b.PublishDate AS date)<=@To)AND(@DomainID IS NULL OR e.Domain=@DomainID)AND(@LocationID IS NULL OR e.WorkingBranch=@LocationID)AND(@ProjectID IS NULL OR e.Project=@ProjectID)AND(@TargetEmployeeID IS NULL OR e.EmployeeID=@TargetEmployeeID)
 GROUP BY b.BulletinID,b.Title,b.PublishDate ORDER BY b.PublishDate DESC,b.Title;
 SELECT t.BulletinID,e.EmployeeID,e.Code,LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,'')))EmployeeName,d.DomainName,br.BranchName,p.ProjectName,t.Status,t.FirstViewedDateTime,t.LastViewedDateTime,t.ReadDateTime,t.AcknowledgedDateTime
 FROM dbo.BulletinUserTracking t JOIN dbo.BulletinMaster b ON b.BulletinID=t.BulletinID JOIN dbo.EmployeeInfo e ON e.EmployeeID=t.EmployeeID LEFT JOIN dbo.Domain d ON d.DomainID=e.Domain LEFT JOIN dbo.Branch br ON br.BranchID=e.WorkingBranch LEFT JOIN dbo.Project p ON p.ProjectID=e.Project
 WHERE b.IsDeleted=0 AND(@From IS NULL OR CAST(b.PublishDate AS date)>=@From)AND(@To IS NULL OR CAST(b.PublishDate AS date)<=@To)AND(@DomainID IS NULL OR e.Domain=@DomainID)AND(@LocationID IS NULL OR e.WorkingBranch=@LocationID)AND(@ProjectID IS NULL OR e.Project=@ProjectID)AND(@TargetEmployeeID IS NULL OR e.EmployeeID=@TargetEmployeeID)
 ORDER BY t.BulletinID,e.Code;
END
GO
IF OBJECT_ID('dbo.usp_Bulletin_Initialize') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_Initialize AS SELECT 1');
GO
IF OBJECT_ID('dbo.usp_Bulletin_TeamSetup') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_TeamSetup AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_TeamSetup @EmployeeID int AS
BEGIN SET NOCOUNT ON;
 SELECT t.TeamID,t.TeamName,t.DomainID,t.SubDomainID,t.LocationID,t.ProjectID,d.DomainName,s.SubdomainName,ISNULL(b.BranchName,'All Locations')LocationName,ISNULL(p.ProjectName,'')ProjectName,(SELECT COUNT(*)FROM dbo.BulletinTeamMember m WHERE m.TeamID=t.TeamID AND m.IsDeleted=0)MemberCount FROM dbo.BulletinTeamMaster t JOIN dbo.Domain d ON d.DomainID=t.DomainID JOIN dbo.SubDomain s ON s.SubDomainID=t.SubDomainID LEFT JOIN dbo.Branch b ON b.BranchID=t.LocationID LEFT JOIN dbo.Project p ON p.ProjectID=t.ProjectID WHERE t.IsDeleted=0 ORDER BY t.TeamName;
 SELECT DISTINCT d.DomainID,d.DomainName FROM dbo.Domain d JOIN dbo.EmployeeInfo e ON e.Domain=d.DomainID JOIN dbo.Project p ON p.ProjectID=e.Project WHERE p.SubdomainID=19 AND ISNULL(e.IsDelete,0)=0 ORDER BY d.DomainName;
 SELECT SubDomainID,SubdomainName FROM dbo.SubDomain WHERE SubDomainID=19;
 SELECT BranchID,BranchName FROM dbo.Branch WHERE ISNULL(IsDelete,0)=0 ORDER BY BranchName;
 SELECT ProjectID,ProjectName FROM dbo.Project WHERE SubdomainID=19 ORDER BY ProjectName;
 ;WITH F AS(
  SELECT f.FolderID,f.ParentFolderID,f.FolderName,0 FolderLevel,CAST(f.FolderName AS nvarchar(max))FolderPath FROM dbo.BulletinFolderMaster f WHERE f.IsDeleted=0 AND f.IsSystem=0 AND(f.ParentFolderID IS NULL OR EXISTS(SELECT 1 FROM dbo.BulletinFolderMaster p WHERE p.FolderID=f.ParentFolderID AND p.IsSystem=1))
  UNION ALL SELECT c.FolderID,c.ParentFolderID,c.FolderName,F.FolderLevel+1,CAST(F.FolderPath+N' / '+c.FolderName AS nvarchar(max)) FROM dbo.BulletinFolderMaster c JOIN F ON c.ParentFolderID=F.FolderID WHERE c.IsDeleted=0 AND c.IsSystem=0
 )SELECT F.FolderID,F.ParentFolderID,F.FolderName,F.FolderLevel,F.FolderPath FROM F CROSS APPLY dbo.ufn_BulletinFolderRights(F.FolderID,@EmployeeID)r WHERE r.CanUpload=1 ORDER BY F.FolderPath OPTION(MAXRECURSION 100);
 SELECT m.TeamID,e.EmployeeID,e.Code+' : '+LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,'')))EmployeeName FROM dbo.BulletinTeamMember m JOIN dbo.EmployeeInfo e ON e.EmployeeID=m.EmployeeID WHERE m.IsDeleted=0 ORDER BY e.Code;
END
GO
IF OBJECT_ID('dbo.usp_Bulletin_ProjectUsers') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_ProjectUsers AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_ProjectUsers @ProjectID int,@LocationID int=NULL AS BEGIN SELECT DISTINCT e.EmployeeID,e.Code+' : '+LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,'')))EmployeeName FROM dbo.UserProjectConfiguration u JOIN dbo.EmployeeInfo e ON e.EmployeeID=u.UserID WHERE u.ProjectID=@ProjectID AND ISNULL(e.IsDelete,0)=0 AND(@LocationID IS NULL OR e.WorkingBranch=@LocationID)ORDER BY EmployeeName;END
GO
IF OBJECT_ID('dbo.usp_Bulletin_TeamSave') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_TeamSave AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_TeamSave @Action varchar(10)='Save',@TeamID int=0,@TeamName nvarchar(150)=NULL,@DomainID int=NULL,@SubDomainID int=NULL,@LocationID int=NULL,@ProjectID int=NULL,@MembersXml xml=NULL,@EmployeeID int AS
BEGIN SET XACT_ABORT ON;BEGIN TRAN;
 IF NOT EXISTS(SELECT 1 FROM dbo.BulletinFolderRights WHERE EmployeeID=@EmployeeID AND CanManagePermissions=1 AND IsDeleted=0)THROW 51000,'Team management permission denied.',1;
 IF @Action='Delete'BEGIN UPDATE dbo.BulletinTeamMaster SET IsDeleted=1,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME()WHERE TeamID=@TeamID;UPDATE dbo.BulletinTeamMember SET IsDeleted=1 WHERE TeamID=@TeamID;INSERT dbo.BulletinAuditLog(EntityType,EntityID,ActionName,EmployeeID)VALUES('Team',@TeamID,'Delete',@EmployeeID);COMMIT;RETURN;END
 IF @SubDomainID<>19 OR @ProjectID IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Project WHERE ProjectID=@ProjectID AND SubdomainID=19)THROW 51000,'Select a valid Underwriting-Servicing project.',1;
 IF @TeamID=0 BEGIN INSERT dbo.BulletinTeamMaster(TeamName,DomainID,SubDomainID,LocationID,ProjectID,CreatedBy)VALUES(@TeamName,@DomainID,@SubDomainID,@LocationID,@ProjectID,@EmployeeID);SET @TeamID=SCOPE_IDENTITY();END
 ELSE UPDATE dbo.BulletinTeamMaster SET TeamName=@TeamName,DomainID=@DomainID,SubDomainID=@SubDomainID,LocationID=@LocationID,ProjectID=@ProjectID,ModifiedBy=@EmployeeID,ModifiedDate=SYSDATETIME()WHERE TeamID=@TeamID AND IsDeleted=0;
 UPDATE dbo.BulletinTeamMember SET IsDeleted=1 WHERE TeamID=@TeamID;MERGE dbo.BulletinTeamMember t USING(SELECT DISTINCT @TeamID TeamID,n.value('.','int')EmployeeID FROM @MembersXml.nodes('/members/id')x(n) JOIN dbo.UserProjectConfiguration u ON u.UserID=n.value('.','int')AND u.ProjectID=@ProjectID JOIN dbo.EmployeeInfo e ON e.EmployeeID=u.UserID AND ISNULL(e.IsDelete,0)=0 AND(@LocationID IS NULL OR e.WorkingBranch=@LocationID))s ON t.TeamID=s.TeamID AND t.EmployeeID=s.EmployeeID WHEN MATCHED THEN UPDATE SET IsDeleted=0 WHEN NOT MATCHED THEN INSERT(TeamID,EmployeeID,CreatedBy)VALUES(s.TeamID,s.EmployeeID,@EmployeeID);
 INSERT dbo.BulletinAuditLog(EntityType,EntityID,ActionName,NewValues,EmployeeID)VALUES('Team',@TeamID,'Save',@TeamName,@EmployeeID);COMMIT;SELECT @TeamID TeamID;
END
GO
IF OBJECT_ID('dbo.usp_Bulletin_TeamEmployees') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Bulletin_TeamEmployees AS SELECT 1');
GO
ALTER PROCEDURE dbo.usp_Bulletin_TeamEmployees @TeamIDsXml xml AS
BEGIN SELECT DISTINCT m.EmployeeID FROM @TeamIDsXml.nodes('/teams/id')x(n) JOIN dbo.BulletinTeamMaster t ON t.TeamID=x.n.value('.','int')AND t.IsDeleted=0 JOIN dbo.BulletinTeamMember m ON m.TeamID=t.TeamID AND m.IsDeleted=0;END
GO
ALTER PROCEDURE dbo.usp_Bulletin_Initialize @AdminEmployeeID int AS
BEGIN SET XACT_ABORT ON;BEGIN TRAN;DECLARE @Root bigint=(SELECT TOP(1)FolderID FROM dbo.BulletinFolderMaster WHERE ParentFolderID IS NULL AND FolderName='Operations Documents'AND IsDeleted=0);IF @Root IS NULL BEGIN INSERT dbo.BulletinFolderMaster(ParentFolderID,FolderName,IsSystem,CreatedBy)VALUES(NULL,'Operations Documents',1,@AdminEmployeeID);SET @Root=SCOPE_IDENTITY();END;MERGE dbo.BulletinFolderRights t USING(SELECT @Root FolderID,@AdminEmployeeID EmployeeID)s ON t.FolderID=s.FolderID AND t.EmployeeID=s.EmployeeID WHEN MATCHED THEN UPDATE SET CanView=1,CanUpload=1,CanCreateFolder=1,CanRenameFolder=1,CanMoveFolder=1,CanDeleteFolder=1,CanManagePermissions=1,InheritToChildren=1,IsDeleted=0 WHEN NOT MATCHED THEN INSERT(FolderID,EmployeeID,CanView,CanUpload,CanCreateFolder,CanRenameFolder,CanMoveFolder,CanDeleteFolder,CanManagePermissions,InheritToChildren,GrantedBy)VALUES(@Root,@AdminEmployeeID,1,1,1,1,1,1,1,1,@AdminEmployeeID);COMMIT;SELECT @Root RootFolderID;END
GO
-- Menu: run after choosing the Operations parent MenuId/group IDs.
-- EXEC dbo.usp_Bulletin_Initialize @AdminEmployeeID=<ADMIN_EMPLOYEE_ID>;
-- EXEC dbo.InsertMenu_1 @MenuName='Operations Bulletin',@ParentMenuId=<OPERATIONS_PARENT_ID>,@Url='../OperationsBulletin/Dashboard.aspx';
-- Assign the created MenuId through the existing group-menu administration page.
