/*
  Change HK_StaffMaster.SupervisorID from a Housekeeping StaffID to the
  EmployeeInfo.EmployeeID used by GetEmpsByDept(1).
  Back up the database before running.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO
IF OBJECT_ID('dbo.EmployeeInfo','U') IS NULL
    THROW 50002, 'dbo.EmployeeInfo is required for the supervisor lookup.', 1;
IF OBJECT_ID('dbo.HK_StaffMaster','U') IS NULL
    THROW 50003, 'dbo.HK_StaffMaster is required for the supervisor migration.', 1;
IF COL_LENGTH('dbo.HK_StaffMaster','SupervisorID') IS NULL
    THROW 50004, 'dbo.HK_StaffMaster.SupervisorID is missing.', 1;
GO
BEGIN TRANSACTION;
DECLARE @DropSupervisorFK nvarchar(max)=N'';
SELECT @DropSupervisorFK += N'ALTER TABLE '+QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))+N'.'+QUOTENAME(OBJECT_NAME(fk.parent_object_id))+N' DROP CONSTRAINT '+QUOTENAME(fk.name)+N';'
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id=fk.object_id
JOIN sys.columns c ON c.object_id=fkc.parent_object_id AND c.column_id=fkc.parent_column_id
WHERE fk.parent_object_id=OBJECT_ID('dbo.HK_StaffMaster') AND c.name='SupervisorID';
IF @DropSupervisorFK<>N'' EXEC sys.sp_executesql @DropSupervisorFK;

/* Preserve legacy supervisor relationships where the old StaffID has an EmployeeID. */
UPDATE staff
SET SupervisorID=supervisor.EmployeeID
FROM dbo.HK_StaffMaster staff
JOIN dbo.HK_StaffMaster supervisor ON supervisor.StaffID=staff.SupervisorID
WHERE staff.SupervisorID IS NOT NULL AND supervisor.EmployeeID IS NOT NULL;

IF EXISTS(SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('dbo.HK_StaffMaster') AND name='SupervisorID' AND TYPE_NAME(user_type_id)<>'bigint')
    ALTER TABLE dbo.HK_StaffMaster ALTER COLUMN SupervisorID bigint NULL;

IF NOT EXISTS(SELECT 1 FROM sys.foreign_keys WHERE name='FK_HK_StaffMaster_SupervisorEmployee')
    ALTER TABLE dbo.HK_StaffMaster WITH NOCHECK ADD CONSTRAINT FK_HK_StaffMaster_SupervisorEmployee
        FOREIGN KEY(SupervisorID) REFERENCES dbo.EmployeeInfo(EmployeeID);
COMMIT TRANSACTION;
GO
