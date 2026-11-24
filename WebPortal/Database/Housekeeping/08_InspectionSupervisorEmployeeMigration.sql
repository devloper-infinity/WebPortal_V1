/*
  Store the authenticated inspector's EmployeeInfo.EmployeeID on inspections.
  Back up the database before running.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO
IF OBJECT_ID('dbo.EmployeeInfo','U') IS NULL
    THROW 50007, 'dbo.EmployeeInfo is required for inspection supervisors.', 1;
IF OBJECT_ID('dbo.HK_Inspection','U') IS NULL
    THROW 50008, 'dbo.HK_Inspection is required for the supervisor migration.', 1;
GO
BEGIN TRANSACTION;
DECLARE @DropFK nvarchar(max)=N'';
SELECT @DropFK += N'ALTER TABLE '+QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))+N'.'+QUOTENAME(OBJECT_NAME(fk.parent_object_id))+N' DROP CONSTRAINT '+QUOTENAME(fk.name)+N';'
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id=fk.object_id
JOIN sys.columns c ON c.object_id=fkc.parent_object_id AND c.column_id=fkc.parent_column_id
WHERE fk.parent_object_id=OBJECT_ID('dbo.HK_Inspection') AND c.name='SupervisorID';
IF @DropFK<>N'' EXEC sys.sp_executesql @DropFK;

/* Preserve old links by translating HK StaffID to that staff member's employee ID. */
UPDATE inspection
SET SupervisorID=staff.EmployeeID
FROM dbo.HK_Inspection inspection
JOIN dbo.HK_StaffMaster staff ON staff.StaffID=inspection.SupervisorID
WHERE inspection.SupervisorID IS NOT NULL AND staff.EmployeeID IS NOT NULL;

IF EXISTS(SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('dbo.HK_Inspection') AND name='SupervisorID' AND TYPE_NAME(user_type_id)<>'bigint')
    ALTER TABLE dbo.HK_Inspection ALTER COLUMN SupervisorID bigint NOT NULL;

IF NOT EXISTS(SELECT 1 FROM sys.foreign_keys WHERE name='FK_HK_Inspection_SupervisorEmployee')
    ALTER TABLE dbo.HK_Inspection WITH NOCHECK ADD CONSTRAINT FK_HK_Inspection_SupervisorEmployee
        FOREIGN KEY(SupervisorID) REFERENCES dbo.EmployeeInfo(EmployeeID);
COMMIT TRANSACTION;
GO
