/* Developer hourly activity tracking - SQL Server 2016 compatible. */
SET NOCOUNT ON;
IF OBJECT_ID('dbo.SRM_DeveloperActivity','U') IS NULL
BEGIN
 CREATE TABLE dbo.SRM_DeveloperActivity(
  ActivityID bigint IDENTITY PRIMARY KEY,DeveloperID int NOT NULL,ActivityType varchar(40) NOT NULL,
  Description nvarchar(1000) NOT NULL,OwnerEmployeeID int NOT NULL,OwnerName nvarchar(150) NOT NULL,
  ActivityDate date NOT NULL,StartTime time(0) NOT NULL,EndTime time(0) NOT NULL,
  TotalMinutes AS DATEDIFF(MINUTE,StartTime,EndTime) PERSISTED,Remarks nvarchar(1000) NULL,
  CreatedDate datetime2(0) NOT NULL DEFAULT(SYSDATETIME()),CreatedBy int NOT NULL,
  ModifiedDate datetime2(0) NULL,ModifiedBy int NULL,IsDeleted bit NOT NULL DEFAULT(0),
  CONSTRAINT CK_SRM_DeveloperActivity_Time CHECK(EndTime>StartTime),
  CONSTRAINT CK_SRM_DeveloperActivity_Type CHECK(ActivityType IN('Meeting','Call/Discussion','Technical Help/Support','Technical Email/Documentation','Investigation/R&D','Other')));
 CREATE INDEX IX_SRM_DeveloperActivity_DeveloperDate ON dbo.SRM_DeveloperActivity(DeveloperID,ActivityDate,StartTime,EndTime) INCLUDE(ActivityType,TotalMinutes,IsDeleted);
END;
GO
