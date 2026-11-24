/*
  Upgrade existing Housekeeping installations to Branch -> Floor.
  Keeps legacy Building/Location tables and columns intact for data retention.
  Before running: back up the database and manually map BranchID values for existing
  records. No Building-to-Branch mapping is inferred because the relationship is
  business-specific.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO
IF OBJECT_ID('dbo.Branch','U') IS NULL
    THROW 50001, 'dbo.Branch is required before the Housekeeping migration.', 1;
GO
DECLARE @Tables TABLE(TableName sysname PRIMARY KEY);
INSERT @Tables(TableName) VALUES
 ('HK_UserRole'),('HK_FloorMaster'),('HK_StaffMaster'),('HK_ActivitySchedule'),
 ('HK_ActivityAssignment'),('HK_StaffAttendance'),('HK_Complaint'),('HK_ConsumableTransaction');
DECLARE @Table sysname,@SQL nvarchar(max);
DECLARE table_cursor CURSOR LOCAL FAST_FORWARD FOR SELECT TableName FROM @Tables;
OPEN table_cursor; FETCH NEXT FROM table_cursor INTO @Table;
WHILE @@FETCH_STATUS=0
BEGIN
    IF OBJECT_ID(N'dbo.'+@Table,'U') IS NOT NULL AND COL_LENGTH(N'dbo.'+@Table,N'BranchID') IS NULL
    BEGIN
        SET @SQL=N'ALTER TABLE dbo.'+QUOTENAME(@Table)+N' ADD BranchID int NULL;';
        EXEC sys.sp_executesql @SQL;
    END;
    FETCH NEXT FROM table_cursor INTO @Table;
END;
CLOSE table_cursor; DEALLOCATE table_cursor;
GO
/* Release only Housekeeping foreign keys that point to the removed masters.
   The old columns/tables and their values remain available for manual migration. */
DECLARE @DropFK nvarchar(max)=N'';
SELECT @DropFK += N'ALTER TABLE '+QUOTENAME(OBJECT_SCHEMA_NAME(f.parent_object_id))+N'.'+QUOTENAME(OBJECT_NAME(f.parent_object_id))+N' DROP CONSTRAINT '+QUOTENAME(f.name)+N';'
FROM sys.foreign_keys f
JOIN sys.tables parent ON parent.object_id=f.parent_object_id
JOIN sys.tables referenced ON referenced.object_id=f.referenced_object_id
WHERE parent.name LIKE 'HK[_]%' AND referenced.name IN ('HK_BuildingMaster','HK_LocationMaster');
IF @DropFK<>N'' EXEC sys.sp_executesql @DropFK;
GO
/* Remove only uniqueness constraints tied to the retired columns. */
DECLARE @LegacyUQ nvarchar(max)=N'';
SELECT @LegacyUQ += N'ALTER TABLE '+QUOTENAME(OBJECT_SCHEMA_NAME(k.parent_object_id))+N'.'+QUOTENAME(OBJECT_NAME(k.parent_object_id))+N' DROP CONSTRAINT '+QUOTENAME(k.name)+N';'
FROM sys.key_constraints k
WHERE k.type='UQ' AND OBJECT_NAME(k.parent_object_id) IN('HK_FloorMaster','HK_ActivitySchedule','HK_ActivityAssignment')
  AND EXISTS(SELECT 1 FROM sys.index_columns ic JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id WHERE ic.object_id=k.parent_object_id AND ic.index_id=k.unique_index_id AND c.name IN('BuildingID','LocationID'));
IF @LegacyUQ<>N'' EXEC sys.sp_executesql @LegacyUQ;
GO
/* Make legacy required fields optional so new Branch/Floor rows need not populate them. */
DECLARE @Legacy TABLE(TableName sysname,ColumnName sysname,TypeName sysname,MaxLength smallint,PrecisionValue tinyint,ScaleValue tinyint);
INSERT @Legacy VALUES
 ('HK_UserRole','BuildingID','int',4,10,0),('HK_FloorMaster','BuildingID','int',4,10,0),('HK_StaffMaster','BuildingID','int',4,10,0),
 ('HK_ActivitySchedule','BuildingID','int',4,10,0),
 ('HK_ActivitySchedule','LocationID','int',4,10,0),('HK_ActivityAssignment','BuildingID','int',4,10,0),
 ('HK_ActivityAssignment','LocationID','int',4,10,0),('HK_StaffAttendance','BuildingID','int',4,10,0),
 ('HK_Complaint','BuildingID','int',4,10,0),('HK_ConsumableTransaction','BuildingID','int',4,10,0);
DECLARE @T sysname,@C sysname,@Type sysname,@Len smallint,@Prec tinyint,@Scale tinyint,@Cmd nvarchar(max);
DECLARE legacy_cursor CURSOR LOCAL FAST_FORWARD FOR SELECT TableName,ColumnName,TypeName,MaxLength,PrecisionValue,ScaleValue FROM @Legacy;
OPEN legacy_cursor; FETCH NEXT FROM legacy_cursor INTO @T,@C,@Type,@Len,@Prec,@Scale;
WHILE @@FETCH_STATUS=0
BEGIN
    IF OBJECT_ID(N'dbo.'+@T,'U') IS NOT NULL AND COL_LENGTH(N'dbo.'+@T,@C) IS NOT NULL
       AND EXISTS(SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.'+@T) AND name=@C AND is_nullable=0)
    BEGIN
        SET @Cmd=N'ALTER TABLE dbo.'+QUOTENAME(@T)+N' ALTER COLUMN '+QUOTENAME(@C)+N' '+@Type+N' NULL;';
        EXEC sys.sp_executesql @Cmd;
    END;
    FETCH NEXT FROM legacy_cursor INTO @T,@C,@Type,@Len,@Prec,@Scale;
END;
CLOSE legacy_cursor; DEALLOCATE legacy_cursor;
GO
/* Add new Branch foreign keys only when the referenced tables are present. */
DECLARE @FKs TABLE(TableName sysname,ConstraintName sysname);
INSERT @FKs VALUES ('HK_UserRole','FK_HK_UserRole_Branch'),('HK_FloorMaster','FK_HK_FloorMaster_Branch'),
 ('HK_StaffMaster','FK_HK_StaffMaster_Branch'),('HK_ActivitySchedule','FK_HK_ActivitySchedule_Branch'),
 ('HK_ActivityAssignment','FK_HK_ActivityAssignment_Branch'),('HK_StaffAttendance','FK_HK_StaffAttendance_Branch'),
 ('HK_Complaint','FK_HK_Complaint_Branch'),('HK_ConsumableTransaction','FK_HK_ConsumableTransaction_Branch');
DECLARE @FT sysname,@FC sysname,@FKSql nvarchar(max);
DECLARE fk_cursor CURSOR LOCAL FAST_FORWARD FOR SELECT TableName,ConstraintName FROM @FKs;
OPEN fk_cursor; FETCH NEXT FROM fk_cursor INTO @FT,@FC;
WHILE @@FETCH_STATUS=0
BEGIN
    IF OBJECT_ID(N'dbo.'+@FT,'U') IS NOT NULL AND COL_LENGTH(N'dbo.'+@FT,N'BranchID') IS NOT NULL
       AND NOT EXISTS(SELECT 1 FROM sys.foreign_keys WHERE name=@FC)
    BEGIN
        SET @FKSql=N'ALTER TABLE dbo.'+QUOTENAME(@FT)+N' WITH NOCHECK ADD CONSTRAINT '+QUOTENAME(@FC)+N' FOREIGN KEY(BranchID) REFERENCES dbo.Branch(BranchID);';
        EXEC sys.sp_executesql @FKSql;
    END;
    FETCH NEXT FROM fk_cursor INTO @FT,@FC;
END;
CLOSE fk_cursor; DEALLOCATE fk_cursor;
GO
IF OBJECT_ID('dbo.HK_FloorMaster','U') IS NOT NULL
BEGIN
 IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_FloorMaster') AND name='UX_HK_Floor_Branch_Number')
  CREATE UNIQUE INDEX UX_HK_Floor_Branch_Number ON dbo.HK_FloorMaster(BranchID,FloorNumber) WHERE BranchID IS NOT NULL;
 IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_FloorMaster') AND name='UX_HK_Floor_Branch_Name')
  CREATE UNIQUE INDEX UX_HK_Floor_Branch_Name ON dbo.HK_FloorMaster(BranchID,FloorName) WHERE BranchID IS NOT NULL;
END;
IF OBJECT_ID('dbo.HK_ActivitySchedule','U') IS NOT NULL
 AND NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_ActivitySchedule') AND name='UX_HK_Schedule_Branch_Floor')
 CREATE UNIQUE INDEX UX_HK_Schedule_Branch_Floor ON dbo.HK_ActivitySchedule(ActivityID,FloorID,StaffID,ScheduleDate,StartTime) WHERE BranchID IS NOT NULL;
IF OBJECT_ID('dbo.HK_ActivityAssignment','U') IS NOT NULL
 AND NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_ActivityAssignment') AND name='UX_HK_Assignment_Branch_Floor')
 CREATE UNIQUE INDEX UX_HK_Assignment_Branch_Floor ON dbo.HK_ActivityAssignment(ScheduleID,FloorID,StaffID,ScheduledDate) WHERE BranchID IS NOT NULL;
GO
/* Rebuild module indexes so their INCLUDE columns match the BranchID schema. */
DECLARE @IndexNames TABLE(TableName sysname,IndexName sysname);
INSERT @IndexNames VALUES ('HK_ActivityAssignment','IX_HK_Assignment_Date_Status'),('HK_StaffAttendance','IX_HK_Attendance_Date'),
 ('HK_Complaint','IX_HK_Complaint_Status_Date'),('HK_ConsumableTransaction','IX_HK_ConsumableTxn_Item_Date'),
 ('HK_UserRole','IX_HK_UserRole_Employee'),('HK_ActivitySchedule','IX_HK_Schedule_Date');
DECLARE @IndexTable sysname,@IndexName sysname,@IndexSql nvarchar(500);
DECLARE index_cursor CURSOR LOCAL FAST_FORWARD FOR SELECT TableName,IndexName FROM @IndexNames;
OPEN index_cursor; FETCH NEXT FROM index_cursor INTO @IndexTable,@IndexName;
WHILE @@FETCH_STATUS=0
BEGIN
 IF OBJECT_ID(N'dbo.'+@IndexTable,'U') IS NOT NULL AND EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.'+@IndexTable) AND name=@IndexName)
 BEGIN SET @IndexSql=N'DROP INDEX '+QUOTENAME(@IndexName)+N' ON dbo.'+QUOTENAME(@IndexTable)+N';'; EXEC sys.sp_executesql @IndexSql; END;
 FETCH NEXT FROM index_cursor INTO @IndexTable,@IndexName;
END;
CLOSE index_cursor; DEALLOCATE index_cursor;
GO
