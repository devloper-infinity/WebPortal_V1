/* Simple Software Request & Task Tracker - SQL Server 2016 */
SET NOCOUNT ON;
SET XACT_ABORT ON;
/* Remove foreign keys owned by, or referencing, the previous SRM schema. */
DECLARE @DropForeignKeys nvarchar(max)=N'';
SELECT @DropForeignKeys=@DropForeignKeys+
 N'ALTER TABLE '+QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))+N'.'+QUOTENAME(OBJECT_NAME(fk.parent_object_id))+
 N' DROP CONSTRAINT '+QUOTENAME(fk.name)+N';'+CHAR(13)+CHAR(10)
FROM sys.foreign_keys fk
WHERE OBJECT_NAME(fk.parent_object_id) LIKE N'SRM[_]%'
   OR OBJECT_NAME(fk.referenced_object_id) LIKE N'SRM[_]%';
IF LEN(@DropForeignKeys)>0 EXEC sys.sp_executesql @DropForeignKeys;

DECLARE @DropTables nvarchar(max)=N'';
SELECT @DropTables=@DropTables+N'DROP TABLE '+QUOTENAME(SCHEMA_NAME(schema_id))+N'.'+QUOTENAME(name)+N';'+CHAR(13)+CHAR(10)
FROM sys.tables WHERE name LIKE N'SRM[_]%';
IF LEN(@DropTables)>0 EXEC sys.sp_executesql @DropTables;

DECLARE @DropViews nvarchar(max)=N'';
SELECT @DropViews=@DropViews+N'DROP VIEW '+QUOTENAME(SCHEMA_NAME(schema_id))+N'.'+QUOTENAME(name)+N';'+CHAR(13)+CHAR(10)
FROM sys.views WHERE name LIKE N'SRM[_]%';
IF LEN(@DropViews)>0 EXEC sys.sp_executesql @DropViews;

DECLARE @DropSynonyms nvarchar(max)=N'';
SELECT @DropSynonyms=@DropSynonyms+N'DROP SYNONYM '+QUOTENAME(SCHEMA_NAME(schema_id))+N'.'+QUOTENAME(name)+N';'+CHAR(13)+CHAR(10)
FROM sys.synonyms WHERE name LIKE N'SRM[_]%';
IF LEN(@DropSynonyms)>0 EXEC sys.sp_executesql @DropSynonyms;
GO

CREATE TABLE dbo.SRM_RequestType(RequestTypeID int IDENTITY PRIMARY KEY,RequestTypeName nvarchar(60) NOT NULL UNIQUE,IsActive bit NOT NULL DEFAULT(1));
CREATE TABLE dbo.SRM_Application(ApplicationID int IDENTITY PRIMARY KEY,ApplicationName nvarchar(100) NOT NULL UNIQUE,IsBusinessCritical bit NOT NULL DEFAULT(0),IsActive bit NOT NULL DEFAULT(1));
CREATE TABLE dbo.SRM_Module(ModuleID int IDENTITY PRIMARY KEY,ApplicationID int NOT NULL REFERENCES dbo.SRM_Application(ApplicationID),ModuleName nvarchar(100) NOT NULL,IsBusinessCritical bit NOT NULL DEFAULT(0),IsActive bit NOT NULL DEFAULT(1),UNIQUE(ApplicationID,ModuleName));
CREATE TABLE dbo.SRM_Priority(PriorityCode varchar(20) PRIMARY KEY,PriorityName nvarchar(30) NOT NULL,SortOrder tinyint NOT NULL,IsActive bit NOT NULL DEFAULT(1));
CREATE TABLE dbo.SRM_Status(StatusCode varchar(30) PRIMARY KEY,StatusName nvarchar(50) NOT NULL,SortOrder tinyint NOT NULL,IsClosed bit NOT NULL DEFAULT(0),IsActive bit NOT NULL DEFAULT(1));
CREATE TABLE dbo.SRM_Request(RequestID bigint IDENTITY PRIMARY KEY,RequestNo varchar(25) NULL UNIQUE,RequestDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),RequestedBy int NULL,RequestOwnerCode varchar(30) NULL,RequestedByName nvarchar(150) NOT NULL,Department nvarchar(150) NULL,RequestTypeID int NOT NULL REFERENCES dbo.SRM_RequestType(RequestTypeID),ApplicationID int NOT NULL REFERENCES dbo.SRM_Application(ApplicationID),ModuleID int NULL REFERENCES dbo.SRM_Module(ModuleID),Title nvarchar(250) NOT NULL,Description nvarchar(max) NOT NULL,BusinessJustification nvarchar(max) NOT NULL,RequestedPriority varchar(20) NOT NULL REFERENCES dbo.SRM_Priority(PriorityCode),RequiredByDate date NULL,AssignedDeveloperID int NULL,AssignedDeveloperName nvarchar(150) NULL,FinalPriority varchar(20) NULL REFERENCES dbo.SRM_Priority(PriorityCode),StatusCode varchar(30) NOT NULL REFERENCES dbo.SRM_Status(StatusCode) DEFAULT('New'),ExpectedStartDate date NULL,ExpectedCompletionDate date NULL,ActualCompletionDate date NULL,LatestUpdate nvarchar(max) NULL,HoldReason nvarchar(500) NULL,UpdatedBy int NULL,UpdatedOn datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),IsDeleted bit NOT NULL DEFAULT(0));
CREATE INDEX IX_SRM_Request_Queue ON dbo.SRM_Request(IsDeleted,StatusCode,FinalPriority,ExpectedCompletionDate,UpdatedOn);
CREATE INDEX IX_SRM_Request_User ON dbo.SRM_Request(RequestedBy,RequestDate DESC);
CREATE INDEX IX_SRM_Request_Filter ON dbo.SRM_Request(ApplicationID,ModuleID,AssignedDeveloperID);
CREATE TABLE dbo.SRM_History(HistoryID bigint IDENTITY PRIMARY KEY,RequestID bigint NOT NULL REFERENCES dbo.SRM_Request(RequestID),FieldName nvarchar(60) NOT NULL,OldValue nvarchar(max) NULL,NewValue nvarchar(max) NULL,Remarks nvarchar(max) NULL,ChangedBy int NOT NULL,ChangedOn datetime2(0) NOT NULL DEFAULT(SYSDATETIME()));
CREATE INDEX IX_SRM_History_Request ON dbo.SRM_History(RequestID,ChangedOn DESC);
CREATE TABLE dbo.SRM_Attachment(AttachmentID bigint IDENTITY PRIMARY KEY,RequestID bigint NOT NULL REFERENCES dbo.SRM_Request(RequestID),OriginalFileName nvarchar(255) NOT NULL,StoredFileName nvarchar(255) NOT NULL,ContentType nvarchar(100) NULL,FileSize bigint NOT NULL,UploadedBy int NOT NULL,UploadedOn datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),IsActive bit NOT NULL DEFAULT(1));
GO

INSERT dbo.SRM_RequestType(RequestTypeName) VALUES(N'New Requirement'),(N'Change'),(N'Bug'),(N'Enhancement'),(N'Support'),(N'Other');
INSERT dbo.SRM_Priority VALUES('Critical',N'Critical',1,1),('High',N'High',2,1),('Medium',N'Medium',3,1),('Low',N'Low',4,1);
INSERT dbo.SRM_Status VALUES('New',N'New',1,0,1),('Under Review',N'Under Review',2,0,1),('Approved',N'Approved',3,0,1),('Assigned',N'Assigned',4,0,1),('In Progress',N'In Progress',5,0,1),('On Hold',N'On Hold',6,0,1),('Testing',N'Testing',7,0,1),('Completed',N'Completed',8,1,1),('Rejected',N'Rejected',9,1,1),('Cancelled',N'Cancelled',10,1,1);
INSERT dbo.SRM_Application(ApplicationName,IsBusinessCritical) VALUES(N'Infinity ERP',0),N'Client Billing',1),N'AP Billing',1),N'Salary Module',1);
DECLARE @ERP int=(SELECT ApplicationID FROM dbo.SRM_Application WHERE ApplicationName=N'Infinity ERP');
INSERT dbo.SRM_Module(ApplicationID,ModuleName,IsBusinessCritical) VALUES(@ERP,N'Accounts',0),(@ERP,N'Human Resources',0),(@ERP,N'IT',0),(@ERP,N'Production',0),(@ERP,N'Reports',0),(@ERP,N'Tracking Sheet',0);
GO
