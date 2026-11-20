SET NOCOUNT ON;
GO
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_ActivityAssignment') AND name='IX_HK_Assignment_Date_Status')
    CREATE INDEX IX_HK_Assignment_Date_Status ON dbo.HK_ActivityAssignment(ScheduledDate, Status) INCLUDE(BuildingID,FloorID,LocationID,StaffID,ActivityID,VendorID);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_StaffAttendance') AND name='IX_HK_Attendance_Date')
    CREATE INDEX IX_HK_Attendance_Date ON dbo.HK_StaffAttendance(AttendanceDate, StaffID) INCLUDE(AttendanceStatus,VendorID,BuildingID,FloorID);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_Complaint') AND name='IX_HK_Complaint_Status_Date')
    CREATE INDEX IX_HK_Complaint_Status_Date ON dbo.HK_Complaint(Status, ExpectedResolution) INCLUDE(BuildingID,FloorID,VendorID);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_ConsumableTransaction') AND name='IX_HK_ConsumableTxn_Item_Date')
    CREATE INDEX IX_HK_ConsumableTxn_Item_Date ON dbo.HK_ConsumableTransaction(ConsumableID, TransactionDate) INCLUDE(TransactionType,Quantity,BuildingID,FloorID);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_UserRole') AND name='IX_HK_UserRole_Employee')
    CREATE INDEX IX_HK_UserRole_Employee ON dbo.HK_UserRole(EmployeeID,IsActive) INCLUDE(RoleName,BuildingID,VendorID);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_LocationMaster') AND name='IX_HK_Location_Floor')
    CREATE INDEX IX_HK_Location_Floor ON dbo.HK_LocationMaster(BuildingID,FloorID,IsActive);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.HK_ActivitySchedule') AND name='IX_HK_Schedule_Date')
    CREATE INDEX IX_HK_Schedule_Date ON dbo.HK_ActivitySchedule(ScheduleDate,IsActive) INCLUDE(ActivityID,BuildingID,FloorID,LocationID,StaffID);
GO
