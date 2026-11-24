/*
  Change schedule and assignment SupervisorID values to EmployeeInfo.EmployeeID,
  matching the Department 1 supervisor dropdown.
  Back up the database before running.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO
IF OBJECT_ID('dbo.EmployeeInfo','U') IS NULL
    THROW 50005, 'dbo.EmployeeInfo is required for the supervisor lookup.', 1;
IF OBJECT_ID('dbo.HK_ActivitySchedule','U') IS NULL OR OBJECT_ID('dbo.HK_ActivityAssignment','U') IS NULL
    THROW 50006, 'Housekeeping schedule and assignment tables are required.', 1;
GO
BEGIN TRANSACTION;
DECLARE @Table sysname,@FKSql nvarchar(max),@FKName sysname;
DECLARE @Tables TABLE(TableName sysname,ConstraintName sysname);
INSERT @Tables VALUES ('HK_ActivitySchedule','FK_HK_Schedule_SupervisorEmployee'),('HK_ActivityAssignment','FK_HK_Assignment_SupervisorEmployee');
DECLARE supervisor_cursor CURSOR LOCAL FAST_FORWARD FOR SELECT TableName,ConstraintName FROM @Tables;
OPEN supervisor_cursor;
FETCH NEXT FROM supervisor_cursor INTO @Table,@FKName;
WHILE @@FETCH_STATUS=0
BEGIN
    SET @FKSql=N'';
    SELECT @FKSql += N'ALTER TABLE '+QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))+N'.'+QUOTENAME(OBJECT_NAME(fk.parent_object_id))+N' DROP CONSTRAINT '+QUOTENAME(fk.name)+N';'
    FROM sys.foreign_keys fk
    JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id=fk.object_id
    JOIN sys.columns c ON c.object_id=fkc.parent_object_id AND c.column_id=fkc.parent_column_id
    WHERE fk.parent_object_id=OBJECT_ID(N'dbo.'+@Table) AND c.name='SupervisorID';
    IF @FKSql<>N'' EXEC sys.sp_executesql @FKSql;

    SET @FKSql=N'UPDATE target SET SupervisorID=supervisor.EmployeeID FROM dbo.'+QUOTENAME(@Table)+N' target JOIN dbo.HK_StaffMaster supervisor ON supervisor.StaffID=target.SupervisorID WHERE target.SupervisorID IS NOT NULL AND supervisor.EmployeeID IS NOT NULL;';
    EXEC sys.sp_executesql @FKSql;

    IF EXISTS(SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.'+@Table) AND name='SupervisorID' AND TYPE_NAME(user_type_id)<>'bigint')
    BEGIN
        SET @FKSql=N'ALTER TABLE dbo.'+QUOTENAME(@Table)+N' ALTER COLUMN SupervisorID bigint NULL;';
        EXEC sys.sp_executesql @FKSql;
    END;

    IF NOT EXISTS(SELECT 1 FROM sys.foreign_keys WHERE name=@FKName)
    BEGIN
        SET @FKSql=N'ALTER TABLE dbo.'+QUOTENAME(@Table)+N' WITH NOCHECK ADD CONSTRAINT '+QUOTENAME(@FKName)+N' FOREIGN KEY(SupervisorID) REFERENCES dbo.EmployeeInfo(EmployeeID);';
        EXEC sys.sp_executesql @FKSql;
    END;
    FETCH NEXT FROM supervisor_cursor INTO @Table,@FKName;
END;
CLOSE supervisor_cursor;
DEALLOCATE supervisor_cursor;
COMMIT TRANSACTION;
GO
