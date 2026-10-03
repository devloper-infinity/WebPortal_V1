SET NOCOUNT ON;

IF OBJECT_ID('dbo.CommitmentBillingReminderLog','U') IS NULL
BEGIN
    CREATE TABLE dbo.CommitmentBillingReminderLog
    (
        ID BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CommitmentBillingReminderLog PRIMARY KEY,
        EmployeeID INT NOT NULL,
        ReminderType VARCHAR(30) NOT NULL,
        BillingMonth DATE NOT NULL,
        PeriodFrom DATE NOT NULL,
        PeriodTo DATE NOT NULL,
        RunDate DATE NOT NULL,
        SentDateTime DATETIME NULL,
        ActualEmailTo NVARCHAR(500) NULL,
        SentEmailTo NVARCHAR(500) NULL,
        IsTestEmail BIT NOT NULL,
        Status VARCHAR(30) NOT NULL,
        ErrorMessage NVARCHAR(2000) NULL,
        AttachmentFileName NVARCHAR(260) NULL,
        AddedDate DATETIME NOT NULL CONSTRAINT DF_CommitmentBillingReminderLog_AddedDate DEFAULT(GETDATE()),
        CONSTRAINT UQ_CommitmentBillingReminderLog_Run UNIQUE(EmployeeID,ReminderType,BillingMonth,RunDate)
    );
END;
GO
