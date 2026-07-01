IF OBJECT_ID('dbo.USLoanProductionTrack', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.USLoanProductionTrack
    (
        ProductionTrackID BIGINT IDENTITY(1,1) NOT NULL,
        ProcessID INT NULL,
        ProjectNumber NVARCHAR(100) NULL,
        DealNo NVARCHAR(100) NOT NULL,
        LoanNo NVARCHAR(100) NOT NULL,
        OrderDate NVARCHAR(100) NULL,
        [Process] NVARCHAR(250) NULL,
        Review NVARCHAR(250) NULL,
        SourcePage NVARCHAR(50) NULL,
        StartDatetime DATETIME NULL,
        EndDatetime DATETIME NULL,
        EmployeeID INT NOT NULL,
        AddedBy INT NOT NULL,
        AddedDate DATETIME NOT NULL CONSTRAINT DF_USLoanProductionTrack_AddedDate DEFAULT (GETDATE()),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        [Status] NVARCHAR(50) NULL,
        CONSTRAINT PK_USLoanProductionTrack PRIMARY KEY CLUSTERED (ProductionTrackID)
    );

    CREATE INDEX IX_USLoanProductionTrack_Process_Employee
        ON dbo.USLoanProductionTrack (ProcessID, EmployeeID)
        INCLUDE (DealNo, LoanNo, StartDatetime, EndDatetime);

    CREATE INDEX IX_USLoanProductionTrack_Employee_AddedDate
        ON dbo.USLoanProductionTrack (EmployeeID, AddedDate);
END
GO

IF OBJECT_ID('dbo.USLoanProductionTrack', 'U') IS NOT NULL
    AND COL_LENGTH('dbo.USLoanProductionTrack', 'SourcePage') IS NULL
BEGIN
    ALTER TABLE dbo.USLoanProductionTrack
        ADD SourcePage NVARCHAR(50) NULL;
END
GO

IF OBJECT_ID('dbo.USLoanProductionTrack', 'U') IS NOT NULL
BEGIN
    UPDATE dbo.USLoanProductionTrack
    SET SourcePage = CASE
            WHEN ISNULL(ProcessID, 0) = 0 THEN 'GlobalSearch'
            ELSE 'MyTask'
        END
    WHERE SourcePage IS NULL;
END
GO

IF OBJECT_ID('dbo.USLoanProductionTrack', 'U') IS NOT NULL
    AND NOT EXISTS
    (
        SELECT 1
        FROM sys.indexes
        WHERE name = 'IX_USLoanProductionTrack_Loan_Employee'
            AND object_id = OBJECT_ID('dbo.USLoanProductionTrack')
    )
BEGIN
    CREATE INDEX IX_USLoanProductionTrack_Loan_Employee
        ON dbo.USLoanProductionTrack (EmployeeID, DealNo, LoanNo, EndDatetime)
        INCLUDE (ProcessID, StartDatetime);
END
GO
