IF OBJECT_ID(N'dbo.NonProductiveHours', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.NonProductiveHours
    (
        NonProductiveHoursID BIGINT IDENTITY(1, 1) NOT NULL
            CONSTRAINT PK_NonProductiveHours PRIMARY KEY,
        EmployeeID INT NOT NULL,
        EntryDate DATE NOT NULL,
        DurationMinutes INT NOT NULL,
        Reason NVARCHAR(1000) NOT NULL,
        CreatedOn DATETIME NOT NULL
            CONSTRAINT DF_NonProductiveHours_CreatedOn DEFAULT (GETDATE()),
        CONSTRAINT CK_NonProductiveHours_DurationMinutes
            CHECK (DurationMinutes > 0 AND DurationMinutes <= 1439)
    );

    CREATE INDEX IX_NonProductiveHours_EmployeeID_EntryDate
        ON dbo.NonProductiveHours (EmployeeID, EntryDate DESC);
END;
