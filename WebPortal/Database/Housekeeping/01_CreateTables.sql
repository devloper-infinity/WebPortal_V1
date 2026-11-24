/* Housekeeping module schema. Safe to rerun; never drops production data. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.HK_UserRole','U') IS NULL CREATE TABLE dbo.HK_UserRole
(
    UserRoleID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    EmployeeID INT NOT NULL,
    RoleName VARCHAR(30) NOT NULL,
    BranchID INT NULL REFERENCES dbo.Branch(BranchID),
    VendorID INT NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_HK_UserRole_Active DEFAULT(1),
    AddedBy INT NOT NULL,
    AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_UserRole_Added DEFAULT(GETDATE())
);
GO

IF OBJECT_ID('dbo.HK_FloorMaster','U') IS NULL CREATE TABLE dbo.HK_FloorMaster
(
    FloorID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BranchID INT NOT NULL REFERENCES dbo.Branch(BranchID),
    FloorNumber INT NOT NULL, FloorName NVARCHAR(100) NOT NULL, Description NVARCHAR(500) NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_HK_Floor_Active DEFAULT(1),
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_Floor_Added DEFAULT(GETDATE()),
    UpdatedBy INT NULL, UpdatedDate DATETIME NULL,
    CONSTRAINT UQ_HK_Floor_Number UNIQUE(BranchID, FloorNumber),
    CONSTRAINT UQ_HK_Floor_Name UNIQUE(BranchID, FloorName)
);
GO
IF OBJECT_ID('dbo.HK_VendorMaster','U') IS NULL CREATE TABLE dbo.HK_VendorMaster
(
    VendorID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    VendorName NVARCHAR(200) NOT NULL UNIQUE, ContactPerson NVARCHAR(150) NULL,
    ContactNumber VARCHAR(30) NULL, Email VARCHAR(254) NULL,
    ContractStartDate DATE NULL, ContractEndDate DATE NULL, ContractedManpower INT NOT NULL CONSTRAINT DF_HK_Vendor_Manpower DEFAULT(0),
    SLARequirements NVARCHAR(2000) NULL, MonthlyContractCost DECIMAL(18,2) NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_HK_Vendor_Active DEFAULT(1),
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_Vendor_Added DEFAULT(GETDATE()),
    UpdatedBy INT NULL, UpdatedDate DATETIME NULL
);
GO
IF OBJECT_ID('dbo.HK_StaffMaster','U') IS NULL CREATE TABLE dbo.HK_StaffMaster
(
    StaffID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    StaffCode VARCHAR(40) NOT NULL UNIQUE, StaffName NVARCHAR(150) NOT NULL,
    EmployeeID INT NULL, MobileNumber VARCHAR(30) NULL,
    StaffType VARCHAR(10) NOT NULL CONSTRAINT CK_HK_Staff_Type CHECK(StaffType IN('Internal','Vendor')),
    VendorID INT NULL REFERENCES dbo.HK_VendorMaster(VendorID),
    BranchID INT NULL REFERENCES dbo.Branch(BranchID),
    FloorID INT NULL REFERENCES dbo.HK_FloorMaster(FloorID),
    SupervisorID BIGINT NULL REFERENCES dbo.EmployeeInfo(EmployeeID), ShiftName NVARCHAR(50) NULL, JoiningDate DATE NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_HK_Staff_Active DEFAULT(1),
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_Staff_Added DEFAULT(GETDATE()),
    UpdatedBy INT NULL, UpdatedDate DATETIME NULL,
    CONSTRAINT CK_HK_Staff_Vendor CHECK((StaffType='Vendor' AND VendorID IS NOT NULL) OR StaffType='Internal')
);
GO
IF OBJECT_ID('dbo.HK_ActivityMaster','U') IS NULL CREATE TABLE dbo.HK_ActivityMaster
(
    ActivityID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ActivityName NVARCHAR(150) NOT NULL UNIQUE, ActivityCategory NVARCHAR(80) NOT NULL,
    Description NVARCHAR(1000) NULL, Frequency VARCHAR(10) NOT NULL CHECK(Frequency IN('Daily','Weekly','Monthly')),
    EstimatedMinutes SMALLINT NULL, Priority VARCHAR(10) NOT NULL CONSTRAINT DF_HK_Activity_Priority DEFAULT('Medium'),
    RequiresInspection BIT NOT NULL CONSTRAINT DF_HK_Activity_Inspection DEFAULT(0),
    RequiresPhoto BIT NOT NULL CONSTRAINT DF_HK_Activity_Photo DEFAULT(0),
    IsActive BIT NOT NULL CONSTRAINT DF_HK_Activity_Active DEFAULT(1),
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_Activity_Added DEFAULT(GETDATE()),
    UpdatedBy INT NULL, UpdatedDate DATETIME NULL
);
GO
IF OBJECT_ID('dbo.HK_ActivitySchedule','U') IS NULL CREATE TABLE dbo.HK_ActivitySchedule
(
    ScheduleID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ActivityID INT NOT NULL REFERENCES dbo.HK_ActivityMaster(ActivityID),
    BranchID INT NOT NULL REFERENCES dbo.Branch(BranchID),
    FloorID INT NOT NULL REFERENCES dbo.HK_FloorMaster(FloorID),
    StaffID INT NOT NULL REFERENCES dbo.HK_StaffMaster(StaffID),
    SupervisorID BIGINT NULL REFERENCES dbo.EmployeeInfo(EmployeeID),
    ScheduleDate DATE NOT NULL, StartTime TIME NULL, EndTime TIME NULL,
    Frequency VARCHAR(10) NOT NULL CHECK(Frequency IN('Daily','Weekly','Monthly')),
    Priority VARCHAR(10) NOT NULL CONSTRAINT DF_HK_Schedule_Priority DEFAULT('Medium'),
    IsActive BIT NOT NULL CONSTRAINT DF_HK_Schedule_Active DEFAULT(1),
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_Schedule_Added DEFAULT(GETDATE()),
    UpdatedBy INT NULL, UpdatedDate DATETIME NULL,
    CONSTRAINT UQ_HK_Schedule UNIQUE(ActivityID, FloorID, StaffID, ScheduleDate, StartTime)
);
GO
IF OBJECT_ID('dbo.HK_ActivityAssignment','U') IS NULL CREATE TABLE dbo.HK_ActivityAssignment
(
    AssignmentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ScheduleID INT NOT NULL REFERENCES dbo.HK_ActivitySchedule(ScheduleID),
    ActivityID INT NOT NULL REFERENCES dbo.HK_ActivityMaster(ActivityID),
    BranchID INT NOT NULL REFERENCES dbo.Branch(BranchID),
    FloorID INT NOT NULL REFERENCES dbo.HK_FloorMaster(FloorID),
    StaffID INT NOT NULL REFERENCES dbo.HK_StaffMaster(StaffID),
    VendorID INT NULL REFERENCES dbo.HK_VendorMaster(VendorID),
    SupervisorID BIGINT NULL REFERENCES dbo.EmployeeInfo(EmployeeID),
    ScheduledDate DATE NOT NULL, ScheduledStart TIME NULL, ScheduledEnd TIME NULL,
    ActualStart DATETIME NULL, ActualEnd DATETIME NULL,
    Status VARCHAR(20) NOT NULL CONSTRAINT DF_HK_Assignment_Status DEFAULT('Pending')
       CHECK(Status IN('Pending','In Progress','Completed','Verified','Rejected','Rework Required')),
    Remarks NVARCHAR(2000) NULL, IsActive BIT NOT NULL CONSTRAINT DF_HK_Assignment_Active DEFAULT(1),
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_Assignment_Added DEFAULT(GETDATE()),
    UpdatedBy INT NULL, UpdatedDate DATETIME NULL,
    CONSTRAINT UQ_HK_Assignment UNIQUE(ScheduleID, FloorID, StaffID, ScheduledDate)
);
GO
IF OBJECT_ID('dbo.HK_ActivityLog','U') IS NULL CREATE TABLE dbo.HK_ActivityLog
(
    ActivityLogID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    AssignmentID INT NOT NULL REFERENCES dbo.HK_ActivityAssignment(AssignmentID),
    OldStatus VARCHAR(20) NULL, NewStatus VARCHAR(20) NOT NULL,
    Remarks NVARCHAR(2000) NULL, ChangedBy INT NOT NULL,
    ChangedDate DATETIME NOT NULL CONSTRAINT DF_HK_ActivityLog_Date DEFAULT(GETDATE())
);
GO
IF OBJECT_ID('dbo.HK_StaffAttendance','U') IS NULL CREATE TABLE dbo.HK_StaffAttendance
(
    AttendanceID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    StaffID INT NOT NULL REFERENCES dbo.HK_StaffMaster(StaffID),
    AttendanceDate DATE NOT NULL, VendorID INT NULL REFERENCES dbo.HK_VendorMaster(VendorID),
    BranchID INT NULL REFERENCES dbo.Branch(BranchID), FloorID INT NULL REFERENCES dbo.HK_FloorMaster(FloorID),
    ShiftName NVARCHAR(50) NULL, LoginTime DATETIME NULL, LogoutTime DATETIME NULL,
    WorkingHours DECIMAL(6,2) NULL, AttendanceStatus VARCHAR(15) NOT NULL,
    IsLate BIT NOT NULL CONSTRAINT DF_HK_Att_Late DEFAULT(0), IsEarlyDeparture BIT NOT NULL CONSTRAINT DF_HK_Att_Early DEFAULT(0),
    OvertimeHours DECIMAL(6,2) NOT NULL CONSTRAINT DF_HK_Att_OT DEFAULT(0), Remarks NVARCHAR(1000) NULL,
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_Att_Added DEFAULT(GETDATE()),
    UpdatedBy INT NULL, UpdatedDate DATETIME NULL,
    CONSTRAINT CK_HK_Att_Status CHECK(AttendanceStatus IN('Present','Absent','Half-Day','Leave','Weekly Off')),
    CONSTRAINT UQ_HK_Attendance UNIQUE(StaffID, AttendanceDate, ShiftName)
);
GO
IF OBJECT_ID('dbo.HK_Inspection','U') IS NULL CREATE TABLE dbo.HK_Inspection
(
    InspectionID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    AssignmentID INT NOT NULL REFERENCES dbo.HK_ActivityAssignment(AssignmentID),
    InspectionDate DATETIME NOT NULL CONSTRAINT DF_HK_Inspection_Date DEFAULT(GETDATE()),
    StaffID INT NOT NULL REFERENCES dbo.HK_StaffMaster(StaffID),
    SupervisorID BIGINT NOT NULL REFERENCES dbo.EmployeeInfo(EmployeeID),
    CleanlinessRating TINYINT NOT NULL CHECK(CleanlinessRating BETWEEN 1 AND 5),
    QualityRating TINYINT NOT NULL CHECK(QualityRating BETWEEN 1 AND 5),
    Remarks NVARCHAR(2000) NULL, InspectionStatus VARCHAR(12) NOT NULL CHECK(InspectionStatus IN('Approved','Rejected')),
    ReworkRequired BIT NOT NULL CONSTRAINT DF_HK_Inspection_Rework DEFAULT(0),
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_Inspection_Added DEFAULT(GETDATE())
);
GO
IF OBJECT_ID('dbo.HK_Complaint','U') IS NULL CREATE TABLE dbo.HK_Complaint
(
    ComplaintID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ComplaintNo AS ('HKC-' + CONVERT(VARCHAR(20), ComplaintID)) PERSISTED,
    ComplaintDate DATETIME NOT NULL CONSTRAINT DF_HK_Complaint_Date DEFAULT(GETDATE()),
    BranchID INT NOT NULL REFERENCES dbo.Branch(BranchID),
    FloorID INT NULL REFERENCES dbo.HK_FloorMaster(FloorID),
    Category NVARCHAR(80) NOT NULL, Description NVARCHAR(2000) NOT NULL,
    Priority VARCHAR(10) NOT NULL, AssignedStaffID INT NULL REFERENCES dbo.HK_StaffMaster(StaffID),
    VendorID INT NULL REFERENCES dbo.HK_VendorMaster(VendorID), ExpectedResolution DATETIME NULL,
    ActualResolution DATETIME NULL, Status VARCHAR(15) NOT NULL CONSTRAINT DF_HK_Complaint_Status DEFAULT('Open')
      CHECK(Status IN('Open','Assigned','In Progress','Resolved','Closed','Reopened')),
    ResolutionRemarks NVARCHAR(2000) NULL, ClosedBy INT NULL, ClosedDate DATETIME NULL,
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_Complaint_Added DEFAULT(GETDATE()),
    UpdatedBy INT NULL, UpdatedDate DATETIME NULL
);
GO
IF OBJECT_ID('dbo.HK_VendorEvaluation','U') IS NULL CREATE TABLE dbo.HK_VendorEvaluation
(
    EvaluationID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    VendorID INT NOT NULL REFERENCES dbo.HK_VendorMaster(VendorID), EvaluationYear SMALLINT NOT NULL, EvaluationMonth TINYINT NOT NULL CHECK(EvaluationMonth BETWEEN 1 AND 12),
    ManpowerScore DECIMAL(5,2) NOT NULL, CompletionScore DECIMAL(5,2) NOT NULL,
    QualityScore DECIMAL(5,2) NOT NULL, SlaScore DECIMAL(5,2) NOT NULL, ComplaintScore DECIMAL(5,2) NOT NULL,
    OverallScore DECIMAL(5,2) NOT NULL, Rating VARCHAR(12) NOT NULL,
    Remarks NVARCHAR(2000) NULL, AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_VendorEval_Added DEFAULT(GETDATE()),
    CONSTRAINT UQ_HK_VendorEvaluation UNIQUE(VendorID, EvaluationYear, EvaluationMonth)
);
GO
IF OBJECT_ID('dbo.HK_ConsumableMaster','U') IS NULL CREATE TABLE dbo.HK_ConsumableMaster
(
    ConsumableID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ItemCode VARCHAR(40) NOT NULL UNIQUE, ItemName NVARCHAR(150) NOT NULL,
    UnitOfMeasure NVARCHAR(30) NOT NULL, MinimumStock DECIMAL(12,2) NOT NULL CONSTRAINT DF_HK_Consumable_Min DEFAULT(0),
    IsActive BIT NOT NULL CONSTRAINT DF_HK_Consumable_Active DEFAULT(1),
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_Consumable_Added DEFAULT(GETDATE()),
    UpdatedBy INT NULL, UpdatedDate DATETIME NULL
);
GO
IF OBJECT_ID('dbo.HK_ConsumableTransaction','U') IS NULL CREATE TABLE dbo.HK_ConsumableTransaction
(
    TransactionID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ConsumableID INT NOT NULL REFERENCES dbo.HK_ConsumableMaster(ConsumableID),
    TransactionDate DATETIME NOT NULL CONSTRAINT DF_HK_ConsumableTxn_Date DEFAULT(GETDATE()),
    TransactionType VARCHAR(6) NOT NULL CHECK(TransactionType IN('In','Out')),
    Quantity DECIMAL(12,2) NOT NULL CHECK(Quantity > 0), VendorID INT NULL REFERENCES dbo.HK_VendorMaster(VendorID),
    StaffID INT NULL REFERENCES dbo.HK_StaffMaster(StaffID), BranchID INT NULL REFERENCES dbo.Branch(BranchID),
    FloorID INT NULL REFERENCES dbo.HK_FloorMaster(FloorID), Remarks NVARCHAR(1000) NULL,
    AddedBy INT NOT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_HK_ConsumableTxn_Added DEFAULT(GETDATE())
);
GO
IF OBJECT_ID('dbo.HK_AuditLog','U') IS NULL CREATE TABLE dbo.HK_AuditLog
(
    AuditID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    EntityName VARCHAR(50) NOT NULL, EntityID BIGINT NULL, ActionName VARCHAR(20) NOT NULL,
    OldValues NVARCHAR(MAX) NULL, NewValues NVARCHAR(MAX) NULL,
    PerformedBy INT NOT NULL, PerformedDate DATETIME NOT NULL CONSTRAINT DF_HK_Audit_Date DEFAULT(GETDATE())
);
GO
IF OBJECT_ID('dbo.HK_StaffPerformance','U') IS NULL CREATE TABLE dbo.HK_StaffPerformance
(
    PerformanceID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    StaffID INT NOT NULL REFERENCES dbo.HK_StaffMaster(StaffID), PeriodStart DATE NOT NULL, PeriodEnd DATE NOT NULL,
    AssignedTasks INT NOT NULL, CompletedTasks INT NOT NULL, OnTimeTasks INT NOT NULL,
    PendingTasks INT NOT NULL, RejectedTasks INT NOT NULL, ReworkCount INT NOT NULL,
    AttendancePercent DECIMAL(5,2) NOT NULL, InspectionRating DECIMAL(5,2) NOT NULL, OverallScore DECIMAL(5,2) NOT NULL,
    CalculatedDate DATETIME NOT NULL CONSTRAINT DF_HK_StaffPerf_Date DEFAULT(GETDATE()),
    CONSTRAINT UQ_HK_StaffPerformance UNIQUE(StaffID, PeriodStart, PeriodEnd)
);
GO

