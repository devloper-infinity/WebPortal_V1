/* CRM module for WebPortal
   Apply this script on the MainCon database.
   Employee references use the existing employee/login tables by EmployeeID only.
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.CRM_LeadSource', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_LeadSource
    (
        LeadSourceID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_LeadSource PRIMARY KEY,
        SourceName NVARCHAR(100) NOT NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_CRM_LeadSource_SortOrder DEFAULT(0),
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_LeadSource_IsActive DEFAULT(1)
    );
END
GO

IF OBJECT_ID('dbo.CRM_LeadStatus', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_LeadStatus
    (
        LeadStatusID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_LeadStatus PRIMARY KEY,
        StatusName NVARCHAR(100) NOT NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_CRM_LeadStatus_SortOrder DEFAULT(0),
        IsConverted BIT NOT NULL CONSTRAINT DF_CRM_LeadStatus_IsConverted DEFAULT(0),
        IsClosed BIT NOT NULL CONSTRAINT DF_CRM_LeadStatus_IsClosed DEFAULT(0),
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_LeadStatus_IsActive DEFAULT(1)
    );
END
GO

IF OBJECT_ID('dbo.CRM_DealStage', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_DealStage
    (
        DealStageID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_DealStage PRIMARY KEY,
        StageName NVARCHAR(100) NOT NULL,
        Probability DECIMAL(5,2) NOT NULL CONSTRAINT DF_CRM_DealStage_Probability DEFAULT(0),
        SortOrder INT NOT NULL CONSTRAINT DF_CRM_DealStage_SortOrder DEFAULT(0),
        IsWon BIT NOT NULL CONSTRAINT DF_CRM_DealStage_IsWon DEFAULT(0),
        IsLost BIT NOT NULL CONSTRAINT DF_CRM_DealStage_IsLost DEFAULT(0),
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_DealStage_IsActive DEFAULT(1)
    );
END
GO

IF OBJECT_ID('dbo.CRM_ActivityType', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_ActivityType
    (
        ActivityTypeID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_ActivityType PRIMARY KEY,
        ActivityTypeName NVARCHAR(100) NOT NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_CRM_ActivityType_SortOrder DEFAULT(0),
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_ActivityType_IsActive DEFAULT(1)
    );
END
GO

IF OBJECT_ID('dbo.CRM_ActivityStatus', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_ActivityStatus
    (
        ActivityStatusID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_ActivityStatus PRIMARY KEY,
        StatusName NVARCHAR(100) NOT NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_CRM_ActivityStatus_SortOrder DEFAULT(0),
        IsCompleted BIT NOT NULL CONSTRAINT DF_CRM_ActivityStatus_IsCompleted DEFAULT(0),
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_ActivityStatus_IsActive DEFAULT(1)
    );
END
GO

IF OBJECT_ID('dbo.CRM_Account', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Account
    (
        AccountID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_Account PRIMARY KEY,
        AccountName NVARCHAR(200) NOT NULL,
        AccountType NVARCHAR(100) NULL,
        Industry NVARCHAR(150) NULL,
        Website NVARCHAR(250) NULL,
        Phone NVARCHAR(50) NULL,
        Email NVARCHAR(200) NULL,
        BillingCity NVARCHAR(100) NULL,
        BillingState NVARCHAR(100) NULL,
        BillingCountry NVARCHAR(100) NULL,
        AnnualRevenue DECIMAL(18,2) NULL,
        AssignedToEmployeeID INT NULL,
        Description NVARCHAR(MAX) NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_Account_IsDeleted DEFAULT(0),
        CreatedBy INT NOT NULL,
        CreatedOn DATETIME2(0) NOT NULL CONSTRAINT DF_CRM_Account_CreatedOn DEFAULT(SYSDATETIME()),
        ModifiedBy INT NULL,
        ModifiedOn DATETIME2(0) NULL
    );
END
GO

IF OBJECT_ID('dbo.CRM_Contact', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Contact
    (
        ContactID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_Contact PRIMARY KEY,
        AccountID INT NULL,
        FirstName NVARCHAR(100) NOT NULL,
        LastName NVARCHAR(100) NOT NULL,
        Title NVARCHAR(150) NULL,
        Email NVARCHAR(200) NULL,
        Phone NVARCHAR(50) NULL,
        Mobile NVARCHAR(50) NULL,
        Department NVARCHAR(150) NULL,
        PreferredContactMethod NVARCHAR(50) NULL,
        LastContactedDate DATE NULL,
        AssignedToEmployeeID INT NULL,
        Description NVARCHAR(MAX) NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_Contact_IsDeleted DEFAULT(0),
        CreatedBy INT NOT NULL,
        CreatedOn DATETIME2(0) NOT NULL CONSTRAINT DF_CRM_Contact_CreatedOn DEFAULT(SYSDATETIME()),
        ModifiedBy INT NULL,
        ModifiedOn DATETIME2(0) NULL,
        CONSTRAINT FK_CRM_Contact_Account FOREIGN KEY(AccountID) REFERENCES dbo.CRM_Account(AccountID)
    );
END
GO

IF OBJECT_ID('dbo.CRM_Lead', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Lead
    (
        LeadID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_Lead PRIMARY KEY,
        FirstName NVARCHAR(100) NOT NULL,
        LastName NVARCHAR(100) NOT NULL,
        CompanyName NVARCHAR(200) NOT NULL,
        Title NVARCHAR(150) NULL,
        Email NVARCHAR(200) NULL,
        Phone NVARCHAR(50) NULL,
        Mobile NVARCHAR(50) NULL,
        Website NVARCHAR(250) NULL,
        City NVARCHAR(100) NULL,
        State NVARCHAR(100) NULL,
        Country NVARCHAR(100) NULL,
        LeadSourceID INT NULL,
        LeadStatusID INT NULL,
        AssignedToEmployeeID INT NULL,
        EstimatedValue DECIMAL(18,2) NULL,
        Rating NVARCHAR(50) NULL,
        NextFollowUpDate DATE NULL,
        Description NVARCHAR(MAX) NULL,
        ConvertedAccountID INT NULL,
        ConvertedContactID INT NULL,
        ConvertedDealID INT NULL,
        ConvertedBy INT NULL,
        ConvertedOn DATETIME2(0) NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_Lead_IsDeleted DEFAULT(0),
        CreatedBy INT NOT NULL,
        CreatedOn DATETIME2(0) NOT NULL CONSTRAINT DF_CRM_Lead_CreatedOn DEFAULT(SYSDATETIME()),
        ModifiedBy INT NULL,
        ModifiedOn DATETIME2(0) NULL,
        CONSTRAINT FK_CRM_Lead_Source FOREIGN KEY(LeadSourceID) REFERENCES dbo.CRM_LeadSource(LeadSourceID),
        CONSTRAINT FK_CRM_Lead_Status FOREIGN KEY(LeadStatusID) REFERENCES dbo.CRM_LeadStatus(LeadStatusID)
    );
END
GO

IF OBJECT_ID('dbo.CRM_Deal', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Deal
    (
        DealID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_Deal PRIMARY KEY,
        DealName NVARCHAR(200) NOT NULL,
        AccountID INT NULL,
        ContactID INT NULL,
        LeadID INT NULL,
        DealStageID INT NULL,
        Amount DECIMAL(18,2) NULL,
        Probability DECIMAL(5,2) NULL,
        ExpectedCloseDate DATE NULL,
        LostReason NVARCHAR(300) NULL,
        AssignedToEmployeeID INT NULL,
        Description NVARCHAR(MAX) NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_Deal_IsDeleted DEFAULT(0),
        CreatedBy INT NOT NULL,
        CreatedOn DATETIME2(0) NOT NULL CONSTRAINT DF_CRM_Deal_CreatedOn DEFAULT(SYSDATETIME()),
        ModifiedBy INT NULL,
        ModifiedOn DATETIME2(0) NULL,
        CONSTRAINT FK_CRM_Deal_Account FOREIGN KEY(AccountID) REFERENCES dbo.CRM_Account(AccountID),
        CONSTRAINT FK_CRM_Deal_Contact FOREIGN KEY(ContactID) REFERENCES dbo.CRM_Contact(ContactID),
        CONSTRAINT FK_CRM_Deal_Lead FOREIGN KEY(LeadID) REFERENCES dbo.CRM_Lead(LeadID),
        CONSTRAINT FK_CRM_Deal_Stage FOREIGN KEY(DealStageID) REFERENCES dbo.CRM_DealStage(DealStageID)
    );
END
GO

IF OBJECT_ID('dbo.CRM_Activity', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Activity
    (
        ActivityID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_Activity PRIMARY KEY,
        ActivityTypeID INT NULL,
        Subject NVARCHAR(250) NOT NULL,
        RelatedEntity NVARCHAR(30) NULL,
        RelatedRecordID INT NULL,
        ActivityStatusID INT NULL,
        Priority NVARCHAR(30) NULL,
        DueDate DATE NULL,
        StartDateTime DATETIME2(0) NULL,
        EndDateTime DATETIME2(0) NULL,
        Outcome NVARCHAR(500) NULL,
        AssignedToEmployeeID INT NULL,
        Description NVARCHAR(MAX) NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_Activity_IsDeleted DEFAULT(0),
        CreatedBy INT NOT NULL,
        CreatedOn DATETIME2(0) NOT NULL CONSTRAINT DF_CRM_Activity_CreatedOn DEFAULT(SYSDATETIME()),
        ModifiedBy INT NULL,
        ModifiedOn DATETIME2(0) NULL,
        CONSTRAINT FK_CRM_Activity_Type FOREIGN KEY(ActivityTypeID) REFERENCES dbo.CRM_ActivityType(ActivityTypeID),
        CONSTRAINT FK_CRM_Activity_Status FOREIGN KEY(ActivityStatusID) REFERENCES dbo.CRM_ActivityStatus(ActivityStatusID)
    );
END
GO

IF OBJECT_ID('dbo.CRM_Note', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Note
    (
        NoteID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_Note PRIMARY KEY,
        RelatedEntity NVARCHAR(30) NOT NULL,
        RelatedRecordID INT NOT NULL,
        NoteTitle NVARCHAR(250) NULL,
        NoteText NVARCHAR(MAX) NOT NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_Note_IsDeleted DEFAULT(0),
        CreatedBy INT NOT NULL,
        CreatedOn DATETIME2(0) NOT NULL CONSTRAINT DF_CRM_Note_CreatedOn DEFAULT(SYSDATETIME()),
        ModifiedBy INT NULL,
        ModifiedOn DATETIME2(0) NULL
    );
END
GO

IF OBJECT_ID('dbo.CRM_Attachment', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Attachment
    (
        AttachmentID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_Attachment PRIMARY KEY,
        RelatedEntity NVARCHAR(30) NOT NULL,
        RelatedRecordID INT NOT NULL,
        FileName NVARCHAR(260) NOT NULL,
        FilePath NVARCHAR(500) NOT NULL,
        ContentType NVARCHAR(100) NULL,
        FileSizeBytes BIGINT NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_Attachment_IsDeleted DEFAULT(0),
        CreatedBy INT NOT NULL,
        CreatedOn DATETIME2(0) NOT NULL CONSTRAINT DF_CRM_Attachment_CreatedOn DEFAULT(SYSDATETIME())
    );
END
GO

IF OBJECT_ID('dbo.CRM_Campaign', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Campaign
    (
        CampaignID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_Campaign PRIMARY KEY,
        CampaignName NVARCHAR(200) NOT NULL,
        CampaignType NVARCHAR(100) NULL,
        StartDate DATE NULL,
        EndDate DATE NULL,
        Budget DECIMAL(18,2) NULL,
        ExpectedRevenue DECIMAL(18,2) NULL,
        Status NVARCHAR(50) NULL,
        AssignedToEmployeeID INT NULL,
        Description NVARCHAR(MAX) NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_Campaign_IsDeleted DEFAULT(0),
        CreatedBy INT NOT NULL,
        CreatedOn DATETIME2(0) NOT NULL CONSTRAINT DF_CRM_Campaign_CreatedOn DEFAULT(SYSDATETIME())
    );
END
GO

IF OBJECT_ID('dbo.CRM_Product', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Product
    (
        ProductID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_Product PRIMARY KEY,
        ProductName NVARCHAR(200) NOT NULL,
        SKU NVARCHAR(100) NULL,
        UnitPrice DECIMAL(18,2) NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_Product_IsActive DEFAULT(1),
        Description NVARCHAR(MAX) NULL,
        CreatedBy INT NOT NULL,
        CreatedOn DATETIME2(0) NOT NULL CONSTRAINT DF_CRM_Product_CreatedOn DEFAULT(SYSDATETIME())
    );
END
GO

IF OBJECT_ID('dbo.CRM_Quote', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Quote
    (
        QuoteID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_Quote PRIMARY KEY,
        QuoteNo NVARCHAR(50) NOT NULL,
        DealID INT NULL,
        AccountID INT NULL,
        ContactID INT NULL,
        QuoteDate DATE NOT NULL CONSTRAINT DF_CRM_Quote_QuoteDate DEFAULT(CONVERT(DATE, GETDATE())),
        ValidUntil DATE NULL,
        SubTotal DECIMAL(18,2) NOT NULL CONSTRAINT DF_CRM_Quote_SubTotal DEFAULT(0),
        DiscountAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_CRM_Quote_Discount DEFAULT(0),
        TaxAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_CRM_Quote_Tax DEFAULT(0),
        GrandTotal DECIMAL(18,2) NOT NULL CONSTRAINT DF_CRM_Quote_Total DEFAULT(0),
        Status NVARCHAR(50) NULL,
        CreatedBy INT NOT NULL,
        CreatedOn DATETIME2(0) NOT NULL CONSTRAINT DF_CRM_Quote_CreatedOn DEFAULT(SYSDATETIME()),
        CONSTRAINT FK_CRM_Quote_Deal FOREIGN KEY(DealID) REFERENCES dbo.CRM_Deal(DealID)
    );
END
GO

IF OBJECT_ID('dbo.CRM_QuoteLine', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_QuoteLine
    (
        QuoteLineID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CRM_QuoteLine PRIMARY KEY,
        QuoteID INT NOT NULL,
        ProductID INT NULL,
        Description NVARCHAR(500) NULL,
        Quantity DECIMAL(18,2) NOT NULL CONSTRAINT DF_CRM_QuoteLine_Quantity DEFAULT(1),
        UnitPrice DECIMAL(18,2) NOT NULL CONSTRAINT DF_CRM_QuoteLine_UnitPrice DEFAULT(0),
        LineTotal DECIMAL(18,2) NOT NULL CONSTRAINT DF_CRM_QuoteLine_Total DEFAULT(0),
        CONSTRAINT FK_CRM_QuoteLine_Quote FOREIGN KEY(QuoteID) REFERENCES dbo.CRM_Quote(QuoteID),
        CONSTRAINT FK_CRM_QuoteLine_Product FOREIGN KEY(ProductID) REFERENCES dbo.CRM_Product(ProductID)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_LeadSource WHERE SourceName = 'Website') INSERT dbo.CRM_LeadSource(SourceName, SortOrder) VALUES('Website', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_LeadSource WHERE SourceName = 'Referral') INSERT dbo.CRM_LeadSource(SourceName, SortOrder) VALUES('Referral', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_LeadSource WHERE SourceName = 'Email Campaign') INSERT dbo.CRM_LeadSource(SourceName, SortOrder) VALUES('Email Campaign', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_LeadSource WHERE SourceName = 'Cold Call') INSERT dbo.CRM_LeadSource(SourceName, SortOrder) VALUES('Cold Call', 4);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_LeadSource WHERE SourceName = 'Social Media') INSERT dbo.CRM_LeadSource(SourceName, SortOrder) VALUES('Social Media', 5);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_LeadStatus WHERE StatusName = 'New') INSERT dbo.CRM_LeadStatus(StatusName, SortOrder) VALUES('New', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_LeadStatus WHERE StatusName = 'Contacted') INSERT dbo.CRM_LeadStatus(StatusName, SortOrder) VALUES('Contacted', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_LeadStatus WHERE StatusName = 'Qualified') INSERT dbo.CRM_LeadStatus(StatusName, SortOrder) VALUES('Qualified', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_LeadStatus WHERE StatusName = 'Converted') INSERT dbo.CRM_LeadStatus(StatusName, SortOrder, IsConverted, IsClosed) VALUES('Converted', 4, 1, 1);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_LeadStatus WHERE StatusName = 'Lost') INSERT dbo.CRM_LeadStatus(StatusName, SortOrder, IsClosed) VALUES('Lost', 5, 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_DealStage WHERE StageName = 'Qualification') INSERT dbo.CRM_DealStage(StageName, Probability, SortOrder) VALUES('Qualification', 10, 1);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_DealStage WHERE StageName = 'Needs Analysis') INSERT dbo.CRM_DealStage(StageName, Probability, SortOrder) VALUES('Needs Analysis', 25, 2);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_DealStage WHERE StageName = 'Proposal') INSERT dbo.CRM_DealStage(StageName, Probability, SortOrder) VALUES('Proposal', 50, 3);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_DealStage WHERE StageName = 'Negotiation') INSERT dbo.CRM_DealStage(StageName, Probability, SortOrder) VALUES('Negotiation', 75, 4);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_DealStage WHERE StageName = 'Closed Won') INSERT dbo.CRM_DealStage(StageName, Probability, SortOrder, IsWon) VALUES('Closed Won', 100, 5, 1);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_DealStage WHERE StageName = 'Closed Lost') INSERT dbo.CRM_DealStage(StageName, Probability, SortOrder, IsLost) VALUES('Closed Lost', 0, 6, 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_ActivityType WHERE ActivityTypeName = 'Task') INSERT dbo.CRM_ActivityType(ActivityTypeName, SortOrder) VALUES('Task', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_ActivityType WHERE ActivityTypeName = 'Call') INSERT dbo.CRM_ActivityType(ActivityTypeName, SortOrder) VALUES('Call', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_ActivityType WHERE ActivityTypeName = 'Meeting') INSERT dbo.CRM_ActivityType(ActivityTypeName, SortOrder) VALUES('Meeting', 3);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_ActivityType WHERE ActivityTypeName = 'Email') INSERT dbo.CRM_ActivityType(ActivityTypeName, SortOrder) VALUES('Email', 4);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_ActivityStatus WHERE StatusName = 'Open') INSERT dbo.CRM_ActivityStatus(StatusName, SortOrder) VALUES('Open', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_ActivityStatus WHERE StatusName = 'In Progress') INSERT dbo.CRM_ActivityStatus(StatusName, SortOrder) VALUES('In Progress', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_ActivityStatus WHERE StatusName = 'Completed') INSERT dbo.CRM_ActivityStatus(StatusName, SortOrder, IsCompleted) VALUES('Completed', 3, 1);
IF NOT EXISTS (SELECT 1 FROM dbo.CRM_ActivityStatus WHERE StatusName = 'Cancelled') INSERT dbo.CRM_ActivityStatus(StatusName, SortOrder, IsCompleted) VALUES('Cancelled', 4, 1);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CRM_Lead_AssignedStatus' AND object_id = OBJECT_ID('dbo.CRM_Lead'))
    CREATE INDEX IX_CRM_Lead_AssignedStatus ON dbo.CRM_Lead(AssignedToEmployeeID, LeadStatusID, IsDeleted);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CRM_Deal_AssignedStage' AND object_id = OBJECT_ID('dbo.CRM_Deal'))
    CREATE INDEX IX_CRM_Deal_AssignedStage ON dbo.CRM_Deal(AssignedToEmployeeID, DealStageID, IsDeleted);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CRM_Activity_Due' AND object_id = OBJECT_ID('dbo.CRM_Activity'))
    CREATE INDEX IX_CRM_Activity_Due ON dbo.CRM_Activity(AssignedToEmployeeID, DueDate, ActivityStatusID, IsDeleted);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CRM_Note_Related' AND object_id = OBJECT_ID('dbo.CRM_Note'))
    CREATE INDEX IX_CRM_Note_Related ON dbo.CRM_Note(RelatedEntity, RelatedRecordID, IsDeleted);
GO

IF OBJECT_ID('dbo.CRM_Lookup_List', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Lookup_List
GO
CREATE PROCEDURE dbo.CRM_Lookup_List
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT LeadSourceID, SourceName FROM dbo.CRM_LeadSource WHERE IsActive = 1 ORDER BY SortOrder, SourceName;
    SELECT LeadStatusID, StatusName, IsConverted, IsClosed FROM dbo.CRM_LeadStatus WHERE IsActive = 1 ORDER BY SortOrder, StatusName;
    SELECT DealStageID, StageName, Probability, IsWon, IsLost FROM dbo.CRM_DealStage WHERE IsActive = 1 ORDER BY SortOrder, StageName;
    SELECT ActivityTypeID, ActivityTypeName FROM dbo.CRM_ActivityType WHERE IsActive = 1 ORDER BY SortOrder, ActivityTypeName;
    SELECT ActivityStatusID, StatusName, IsCompleted FROM dbo.CRM_ActivityStatus WHERE IsActive = 1 ORDER BY SortOrder, StatusName;
    SELECT AccountID, AccountName FROM dbo.CRM_Account WHERE IsDeleted = 0 ORDER BY AccountName;
    SELECT ContactID, LTRIM(RTRIM(FirstName + ' ' + LastName)) AS ContactName, AccountID FROM dbo.CRM_Contact WHERE IsDeleted = 0 ORDER BY FirstName, LastName;
    SELECT LeadID, LTRIM(RTRIM(FirstName + ' ' + LastName)) + ' - ' + CompanyName AS LeadName FROM dbo.CRM_Lead WHERE IsDeleted = 0 AND ConvertedDealID IS NULL ORDER BY CreatedOn DESC;
END
GO

IF OBJECT_ID('dbo.CRM_Dashboard_Get', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Dashboard_Get
GO
CREATE PROCEDURE dbo.CRM_Dashboard_Get
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        OpenLeads = (SELECT COUNT(1) FROM dbo.CRM_Lead l LEFT JOIN dbo.CRM_LeadStatus s ON l.LeadStatusID = s.LeadStatusID WHERE l.IsDeleted = 0 AND ISNULL(s.IsClosed, 0) = 0),
        WonDeals = (SELECT COUNT(1) FROM dbo.CRM_Deal d INNER JOIN dbo.CRM_DealStage s ON d.DealStageID = s.DealStageID WHERE d.IsDeleted = 0 AND s.IsWon = 1 AND MONTH(ISNULL(d.ModifiedOn, d.CreatedOn)) = MONTH(GETDATE()) AND YEAR(ISNULL(d.ModifiedOn, d.CreatedOn)) = YEAR(GETDATE())),
        PipelineValue = (SELECT ISNULL(SUM(ISNULL(d.Amount,0) * ISNULL(ISNULL(d.Probability, s.Probability), 0) / 100), 0) FROM dbo.CRM_Deal d LEFT JOIN dbo.CRM_DealStage s ON d.DealStageID = s.DealStageID WHERE d.IsDeleted = 0 AND ISNULL(s.IsWon, 0) = 0 AND ISNULL(s.IsLost, 0) = 0),
        DueActivities = (SELECT COUNT(1) FROM dbo.CRM_Activity a LEFT JOIN dbo.CRM_ActivityStatus s ON a.ActivityStatusID = s.ActivityStatusID WHERE a.IsDeleted = 0 AND ISNULL(s.IsCompleted, 0) = 0 AND a.DueDate <= DATEADD(DAY, 1, CONVERT(DATE, GETDATE())));

    SELECT s.StageName, COUNT(d.DealID) AS DealCount, ISNULL(SUM(ISNULL(d.Amount,0)),0) AS Amount,
           ISNULL(SUM(ISNULL(d.Amount,0) * ISNULL(ISNULL(d.Probability, s.Probability), 0) / 100), 0) AS WeightedValue
    FROM dbo.CRM_DealStage s
    LEFT JOIN dbo.CRM_Deal d ON d.DealStageID = s.DealStageID AND d.IsDeleted = 0
    WHERE s.IsActive = 1 AND s.IsWon = 0 AND s.IsLost = 0
    GROUP BY s.StageName, s.SortOrder
    ORDER BY s.SortOrder;

    SELECT TOP 8 a.ActivityID, a.Subject, t.ActivityTypeName, st.StatusName,
           CONVERT(NVARCHAR(20), a.DueDate, 106) AS DueText, a.DueDate,
           'Employee #' + CONVERT(NVARCHAR(20), ISNULL(a.AssignedToEmployeeID, 0)) AS OwnerName
    FROM dbo.CRM_Activity a
    LEFT JOIN dbo.CRM_ActivityType t ON a.ActivityTypeID = t.ActivityTypeID
    LEFT JOIN dbo.CRM_ActivityStatus st ON a.ActivityStatusID = st.ActivityStatusID
    WHERE a.IsDeleted = 0 AND ISNULL(st.IsCompleted, 0) = 0
    ORDER BY CASE WHEN a.DueDate IS NULL THEN 1 ELSE 0 END, a.DueDate, a.ActivityID DESC;

    SELECT TOP 8 l.LeadID, LTRIM(RTRIM(l.FirstName + ' ' + l.LastName)) AS LeadName, l.CompanyName, s.StatusName
    FROM dbo.CRM_Lead l
    LEFT JOIN dbo.CRM_LeadStatus s ON l.LeadStatusID = s.LeadStatusID
    WHERE l.IsDeleted = 0
    ORDER BY l.CreatedOn DESC;

    SELECT TOP 12 *
    FROM
    (
        SELECT 'Lead' AS RecordType, LTRIM(RTRIM(l.FirstName + ' ' + l.LastName)) AS RecordName, l.CompanyName AS Subtitle,
               'Employee #' + CONVERT(NVARCHAR(20), ISNULL(l.AssignedToEmployeeID, 0)) AS OwnerName, s.StatusName, ISNULL(l.ModifiedOn, l.CreatedOn) AS UpdatedOn
        FROM dbo.CRM_Lead l LEFT JOIN dbo.CRM_LeadStatus s ON l.LeadStatusID = s.LeadStatusID WHERE l.IsDeleted = 0
        UNION ALL
        SELECT 'Account', a.AccountName, a.Industry, 'Employee #' + CONVERT(NVARCHAR(20), ISNULL(a.AssignedToEmployeeID, 0)), a.AccountType, ISNULL(a.ModifiedOn, a.CreatedOn)
        FROM dbo.CRM_Account a WHERE a.IsDeleted = 0
        UNION ALL
        SELECT 'Deal', d.DealName, ac.AccountName, 'Employee #' + CONVERT(NVARCHAR(20), ISNULL(d.AssignedToEmployeeID, 0)), s.StageName, ISNULL(d.ModifiedOn, d.CreatedOn)
        FROM dbo.CRM_Deal d LEFT JOIN dbo.CRM_Account ac ON d.AccountID = ac.AccountID LEFT JOIN dbo.CRM_DealStage s ON d.DealStageID = s.DealStageID WHERE d.IsDeleted = 0
    ) x
    ORDER BY x.UpdatedOn DESC;

    SELECT TOP 20 a.ActivityID, a.Subject, st.StatusName, a.DueDate,
           CONVERT(NVARCHAR(20), a.DueDate, 106) AS DueText,
           CASE WHEN a.DueDate < CONVERT(DATE, GETDATE()) THEN 'red' ELSE 'amber' END AS StatusColor
    FROM dbo.CRM_Activity a
    LEFT JOIN dbo.CRM_ActivityStatus st ON a.ActivityStatusID = st.ActivityStatusID
    WHERE a.IsDeleted = 0 AND ISNULL(st.IsCompleted, 0) = 0 AND a.DueDate <= DATEADD(DAY, 7, CONVERT(DATE, GETDATE()))
    ORDER BY a.DueDate, a.ActivityID DESC;
END
GO

IF OBJECT_ID('dbo.CRM_RelatedName', 'FN') IS NOT NULL DROP FUNCTION dbo.CRM_RelatedName
GO
IF OBJECT_ID('dbo.CRM_ToInt', 'FN') IS NOT NULL DROP FUNCTION dbo.CRM_ToInt
GO
CREATE FUNCTION dbo.CRM_ToInt
(
    @Value NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;
    IF ISNUMERIC(NULLIF(@Value, '')) = 1
        SET @Result = CONVERT(INT, CONVERT(DECIMAL(18,0), @Value));
    RETURN @Result;
END
GO

IF OBJECT_ID('dbo.CRM_ToDecimal', 'FN') IS NOT NULL DROP FUNCTION dbo.CRM_ToDecimal
GO
CREATE FUNCTION dbo.CRM_ToDecimal
(
    @Value NVARCHAR(100)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Result DECIMAL(18,2);
    IF ISNUMERIC(NULLIF(@Value, '')) = 1
        SET @Result = CONVERT(DECIMAL(18,2), @Value);
    RETURN @Result;
END
GO

IF OBJECT_ID('dbo.CRM_ToDate', 'FN') IS NOT NULL DROP FUNCTION dbo.CRM_ToDate
GO
CREATE FUNCTION dbo.CRM_ToDate
(
    @Value NVARCHAR(100)
)
RETURNS DATE
AS
BEGIN
    DECLARE @Result DATE;
    IF ISDATE(NULLIF(@Value, '')) = 1
        SET @Result = CONVERT(DATE, @Value);
    RETURN @Result;
END
GO

IF OBJECT_ID('dbo.CRM_ToDateTime', 'FN') IS NOT NULL DROP FUNCTION dbo.CRM_ToDateTime
GO
CREATE FUNCTION dbo.CRM_ToDateTime
(
    @Value NVARCHAR(100)
)
RETURNS DATETIME2(0)
AS
BEGIN
    DECLARE @Result DATETIME2(0);
    IF ISDATE(NULLIF(@Value, '')) = 1
        SET @Result = CONVERT(DATETIME2(0), @Value);
    RETURN @Result;
END
GO

CREATE FUNCTION dbo.CRM_RelatedName
(
    @Entity NVARCHAR(30),
    @RecordID INT
)
RETURNS NVARCHAR(300)
AS
BEGIN
    DECLARE @Name NVARCHAR(300);

    IF @Entity = 'Lead' SELECT @Name = LTRIM(RTRIM(FirstName + ' ' + LastName)) + ' - ' + CompanyName FROM dbo.CRM_Lead WHERE LeadID = @RecordID;
    IF @Entity = 'Account' SELECT @Name = AccountName FROM dbo.CRM_Account WHERE AccountID = @RecordID;
    IF @Entity = 'Contact' SELECT @Name = LTRIM(RTRIM(FirstName + ' ' + LastName)) FROM dbo.CRM_Contact WHERE ContactID = @RecordID;
    IF @Entity = 'Deal' SELECT @Name = DealName FROM dbo.CRM_Deal WHERE DealID = @RecordID;

    RETURN ISNULL(@Name, @Entity + ' #' + CONVERT(NVARCHAR(20), ISNULL(@RecordID, 0)));
END
GO

IF OBJECT_ID('dbo.CRM_Record_List', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Record_List
GO
CREATE PROCEDURE dbo.CRM_Record_List
    @Entity NVARCHAR(30),
    @SearchText NVARCHAR(200) = '',
    @FilterValue NVARCHAR(100) = '',
    @OwnerID INT = 0,
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @FilterID INT = dbo.CRM_ToInt(@FilterValue);

    IF @Entity = 'Lead'
    BEGIN
        SELECT l.LeadID AS RecordID, l.LeadID, LTRIM(RTRIM(l.FirstName + ' ' + l.LastName)) AS Name, LTRIM(RTRIM(l.FirstName + ' ' + l.LastName)) AS LeadName,
               l.FirstName, l.LastName, l.CompanyName, l.Title, l.Email, l.Phone, l.Mobile, l.Website, l.City, l.State, l.Country,
               l.LeadSourceID, src.SourceName, l.LeadStatusID, st.StatusName,
               l.AssignedToEmployeeID, 'Employee #' + CONVERT(NVARCHAR(20), ISNULL(l.AssignedToEmployeeID, 0)) AS OwnerName,
               l.EstimatedValue, l.Rating, l.NextFollowUpDate, l.Description, ISNULL(l.ModifiedOn, l.CreatedOn) AS UpdatedOn,
               CASE WHEN st.IsConverted = 1 THEN 'green' WHEN st.IsClosed = 1 THEN 'red' WHEN st.StatusName = 'New' THEN 'amber' ELSE '' END AS StatusColor
        FROM dbo.CRM_Lead l
        LEFT JOIN dbo.CRM_LeadSource src ON l.LeadSourceID = src.LeadSourceID
        LEFT JOIN dbo.CRM_LeadStatus st ON l.LeadStatusID = st.LeadStatusID
        WHERE l.IsDeleted = 0
          AND (@FilterID IS NULL OR l.LeadStatusID = @FilterID)
          AND (@OwnerID = 0 OR l.AssignedToEmployeeID = @OwnerID)
          AND (@SearchText = '' OR l.FirstName LIKE '%' + @SearchText + '%' OR l.LastName LIKE '%' + @SearchText + '%' OR l.CompanyName LIKE '%' + @SearchText + '%' OR l.Email LIKE '%' + @SearchText + '%' OR l.Phone LIKE '%' + @SearchText + '%')
        ORDER BY ISNULL(l.ModifiedOn, l.CreatedOn) DESC;
        RETURN;
    END

    IF @Entity = 'Account'
    BEGIN
        SELECT a.AccountID AS RecordID, a.AccountID, a.AccountName AS Name, a.AccountName, a.AccountType, a.Industry, a.Website, a.Phone, a.Email,
               a.BillingCity, a.BillingState, a.BillingCountry, a.AnnualRevenue, a.AssignedToEmployeeID,
               'Employee #' + CONVERT(NVARCHAR(20), ISNULL(a.AssignedToEmployeeID, 0)) AS OwnerName, a.Description, ISNULL(a.ModifiedOn, a.CreatedOn) AS UpdatedOn
        FROM dbo.CRM_Account a
        WHERE a.IsDeleted = 0
          AND (@FilterValue = '' OR a.AccountType = @FilterValue)
          AND (@OwnerID = 0 OR a.AssignedToEmployeeID = @OwnerID)
          AND (@SearchText = '' OR a.AccountName LIKE '%' + @SearchText + '%' OR a.Website LIKE '%' + @SearchText + '%' OR a.Email LIKE '%' + @SearchText + '%' OR a.BillingCity LIKE '%' + @SearchText + '%')
        ORDER BY ISNULL(a.ModifiedOn, a.CreatedOn) DESC;
        RETURN;
    END

    IF @Entity = 'Contact'
    BEGIN
        SELECT c.ContactID AS RecordID, c.ContactID, LTRIM(RTRIM(c.FirstName + ' ' + c.LastName)) AS Name, LTRIM(RTRIM(c.FirstName + ' ' + c.LastName)) AS ContactName,
               c.AccountID, a.AccountName, c.FirstName, c.LastName, c.Title, c.Email, c.Phone, c.Mobile, c.Department, c.PreferredContactMethod, c.LastContactedDate,
               c.AssignedToEmployeeID, 'Employee #' + CONVERT(NVARCHAR(20), ISNULL(c.AssignedToEmployeeID, 0)) AS OwnerName, c.Description, ISNULL(c.ModifiedOn, c.CreatedOn) AS UpdatedOn
        FROM dbo.CRM_Contact c
        LEFT JOIN dbo.CRM_Account a ON c.AccountID = a.AccountID
        WHERE c.IsDeleted = 0
          AND (@FilterValue = '' OR c.Title = @FilterValue)
          AND (@OwnerID = 0 OR c.AssignedToEmployeeID = @OwnerID)
          AND (@SearchText = '' OR c.FirstName LIKE '%' + @SearchText + '%' OR c.LastName LIKE '%' + @SearchText + '%' OR a.AccountName LIKE '%' + @SearchText + '%' OR c.Email LIKE '%' + @SearchText + '%' OR c.Phone LIKE '%' + @SearchText + '%')
        ORDER BY ISNULL(c.ModifiedOn, c.CreatedOn) DESC;
        RETURN;
    END

    IF @Entity = 'Deal'
    BEGIN
        SELECT d.DealID AS RecordID, d.DealID, d.DealName AS Name, d.DealName, d.AccountID, a.AccountName, d.ContactID,
               LTRIM(RTRIM(c.FirstName + ' ' + c.LastName)) AS ContactName, d.LeadID, d.DealStageID, st.StageName, d.Amount,
               ISNULL(d.Probability, st.Probability) AS Probability, d.ExpectedCloseDate, d.LostReason, d.AssignedToEmployeeID,
               'Employee #' + CONVERT(NVARCHAR(20), ISNULL(d.AssignedToEmployeeID, 0)) AS OwnerName, d.Description, ISNULL(d.ModifiedOn, d.CreatedOn) AS UpdatedOn,
               CASE WHEN st.IsWon = 1 THEN 'green' WHEN st.IsLost = 1 THEN 'red' WHEN st.StageName = 'Proposal' THEN 'amber' ELSE '' END AS StatusColor
        FROM dbo.CRM_Deal d
        LEFT JOIN dbo.CRM_Account a ON d.AccountID = a.AccountID
        LEFT JOIN dbo.CRM_Contact c ON d.ContactID = c.ContactID
        LEFT JOIN dbo.CRM_DealStage st ON d.DealStageID = st.DealStageID
        WHERE d.IsDeleted = 0
          AND (@FilterID IS NULL OR d.DealStageID = @FilterID)
          AND (@OwnerID = 0 OR d.AssignedToEmployeeID = @OwnerID)
          AND (@SearchText = '' OR d.DealName LIKE '%' + @SearchText + '%' OR a.AccountName LIKE '%' + @SearchText + '%' OR c.FirstName LIKE '%' + @SearchText + '%' OR c.LastName LIKE '%' + @SearchText + '%')
        ORDER BY ISNULL(d.ModifiedOn, d.CreatedOn) DESC;
        RETURN;
    END

    IF @Entity = 'Activity'
    BEGIN
        SELECT a.ActivityID AS RecordID, a.ActivityID, a.Subject AS Name, a.Subject, a.ActivityTypeID, t.ActivityTypeName,
               a.RelatedEntity, a.RelatedRecordID, dbo.CRM_RelatedName(a.RelatedEntity, a.RelatedRecordID) AS RelatedName,
               a.ActivityStatusID, st.StatusName, a.Priority, a.DueDate, a.StartDateTime, a.EndDateTime, a.Outcome,
               a.AssignedToEmployeeID, 'Employee #' + CONVERT(NVARCHAR(20), ISNULL(a.AssignedToEmployeeID, 0)) AS OwnerName, a.Description, ISNULL(a.ModifiedOn, a.CreatedOn) AS UpdatedOn,
               CASE WHEN ISNULL(st.IsCompleted, 0) = 1 THEN 'green' WHEN a.DueDate < CONVERT(DATE, GETDATE()) THEN 'red' ELSE 'amber' END AS StatusColor
        FROM dbo.CRM_Activity a
        LEFT JOIN dbo.CRM_ActivityType t ON a.ActivityTypeID = t.ActivityTypeID
        LEFT JOIN dbo.CRM_ActivityStatus st ON a.ActivityStatusID = st.ActivityStatusID
        WHERE a.IsDeleted = 0
          AND (@FilterID IS NULL OR a.ActivityStatusID = @FilterID)
          AND (@OwnerID = 0 OR a.AssignedToEmployeeID = @OwnerID)
          AND (@SearchText = '' OR a.Subject LIKE '%' + @SearchText + '%' OR a.Description LIKE '%' + @SearchText + '%' OR a.Outcome LIKE '%' + @SearchText + '%')
        ORDER BY CASE WHEN ISNULL(st.IsCompleted, 0) = 1 THEN 1 ELSE 0 END, a.DueDate, a.ActivityID DESC;
        RETURN;
    END
END
GO

IF OBJECT_ID('dbo.CRM_Record_Get', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Record_Get
GO
CREATE PROCEDURE dbo.CRM_Record_Get
    @Entity NVARCHAR(30),
    @RecordID INT,
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @Entity = 'Lead'
        SELECT * FROM dbo.CRM_Lead WHERE LeadID = @RecordID AND IsDeleted = 0;
    ELSE IF @Entity = 'Account'
        SELECT * FROM dbo.CRM_Account WHERE AccountID = @RecordID AND IsDeleted = 0;
    ELSE IF @Entity = 'Contact'
        SELECT * FROM dbo.CRM_Contact WHERE ContactID = @RecordID AND IsDeleted = 0;
    ELSE IF @Entity = 'Deal'
        SELECT * FROM dbo.CRM_Deal WHERE DealID = @RecordID AND IsDeleted = 0;
    ELSE IF @Entity = 'Activity'
        SELECT * FROM dbo.CRM_Activity WHERE ActivityID = @RecordID AND IsDeleted = 0;

    SELECT NoteID, NoteTitle, NoteText, CreatedBy, CreatedOn
    FROM dbo.CRM_Note
    WHERE RelatedEntity = @Entity AND RelatedRecordID = @RecordID AND IsDeleted = 0
    ORDER BY CreatedOn DESC;

    SELECT ActivityID, Subject, DueDate, ActivityStatusID, Description
    FROM dbo.CRM_Activity
    WHERE RelatedEntity = @Entity AND RelatedRecordID = @RecordID AND IsDeleted = 0
    ORDER BY DueDate DESC, ActivityID DESC;
END
GO

IF OBJECT_ID('dbo.CRM_Lead_Save', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Lead_Save
GO
CREATE PROCEDURE dbo.CRM_Lead_Save
    @LeadID INT = 0,
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @CompanyName NVARCHAR(200),
    @Title NVARCHAR(150) = '',
    @Email NVARCHAR(200) = '',
    @Phone NVARCHAR(50) = '',
    @Mobile NVARCHAR(50) = '',
    @Website NVARCHAR(250) = '',
    @City NVARCHAR(100) = '',
    @State NVARCHAR(100) = '',
    @Country NVARCHAR(100) = '',
    @LeadSourceID INT = 0,
    @LeadStatusID INT = 0,
    @AssignedToEmployeeID INT = 0,
    @EstimatedValue NVARCHAR(50) = '',
    @Rating NVARCHAR(50) = '',
    @NextFollowUpDate NVARCHAR(50) = '',
    @Description NVARCHAR(MAX) = '',
    @AddedBy INT,
    @ReturnValue BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF @LeadStatusID = 0 SELECT TOP 1 @LeadStatusID = LeadStatusID FROM dbo.CRM_LeadStatus WHERE IsActive = 1 ORDER BY SortOrder;
    IF @LeadSourceID = 0 SET @LeadSourceID = NULL;
    IF @AssignedToEmployeeID = 0 SET @AssignedToEmployeeID = @AddedBy;

    IF @LeadID = 0
    BEGIN
        INSERT dbo.CRM_Lead(FirstName, LastName, CompanyName, Title, Email, Phone, Mobile, Website, City, State, Country, LeadSourceID, LeadStatusID, AssignedToEmployeeID, EstimatedValue, Rating, NextFollowUpDate, Description, CreatedBy)
        VALUES(@FirstName, @LastName, @CompanyName, @Title, @Email, @Phone, @Mobile, @Website, @City, @State, @Country, @LeadSourceID, @LeadStatusID, @AssignedToEmployeeID, dbo.CRM_ToDecimal(@EstimatedValue), @Rating, dbo.CRM_ToDate(@NextFollowUpDate), @Description, @AddedBy);
        SET @ReturnValue = SCOPE_IDENTITY();
        RETURN;
    END

    UPDATE dbo.CRM_Lead
    SET FirstName = @FirstName, LastName = @LastName, CompanyName = @CompanyName, Title = @Title, Email = @Email, Phone = @Phone, Mobile = @Mobile,
        Website = @Website, City = @City, State = @State, Country = @Country, LeadSourceID = @LeadSourceID, LeadStatusID = @LeadStatusID,
        AssignedToEmployeeID = @AssignedToEmployeeID, EstimatedValue = dbo.CRM_ToDecimal(@EstimatedValue), Rating = @Rating,
        NextFollowUpDate = dbo.CRM_ToDate(@NextFollowUpDate), Description = @Description, ModifiedBy = @AddedBy, ModifiedOn = SYSDATETIME()
    WHERE LeadID = @LeadID AND IsDeleted = 0;
    SET @ReturnValue = @LeadID;
END
GO

IF OBJECT_ID('dbo.CRM_Account_Save', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Account_Save
GO
CREATE PROCEDURE dbo.CRM_Account_Save
    @AccountID INT = 0,
    @AccountName NVARCHAR(200),
    @AccountType NVARCHAR(100) = '',
    @Industry NVARCHAR(150) = '',
    @Website NVARCHAR(250) = '',
    @Phone NVARCHAR(50) = '',
    @Email NVARCHAR(200) = '',
    @BillingCity NVARCHAR(100) = '',
    @BillingState NVARCHAR(100) = '',
    @BillingCountry NVARCHAR(100) = '',
    @AnnualRevenue NVARCHAR(50) = '',
    @AssignedToEmployeeID INT = 0,
    @Description NVARCHAR(MAX) = '',
    @AddedBy INT,
    @ReturnValue BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF @AssignedToEmployeeID = 0 SET @AssignedToEmployeeID = @AddedBy;

    IF @AccountID = 0
    BEGIN
        INSERT dbo.CRM_Account(AccountName, AccountType, Industry, Website, Phone, Email, BillingCity, BillingState, BillingCountry, AnnualRevenue, AssignedToEmployeeID, Description, CreatedBy)
        VALUES(@AccountName, @AccountType, @Industry, @Website, @Phone, @Email, @BillingCity, @BillingState, @BillingCountry, dbo.CRM_ToDecimal(@AnnualRevenue), @AssignedToEmployeeID, @Description, @AddedBy);
        SET @ReturnValue = SCOPE_IDENTITY();
        RETURN;
    END

    UPDATE dbo.CRM_Account
    SET AccountName = @AccountName, AccountType = @AccountType, Industry = @Industry, Website = @Website, Phone = @Phone, Email = @Email,
        BillingCity = @BillingCity, BillingState = @BillingState, BillingCountry = @BillingCountry, AnnualRevenue = dbo.CRM_ToDecimal(@AnnualRevenue),
        AssignedToEmployeeID = @AssignedToEmployeeID, Description = @Description, ModifiedBy = @AddedBy, ModifiedOn = SYSDATETIME()
    WHERE AccountID = @AccountID AND IsDeleted = 0;
    SET @ReturnValue = @AccountID;
END
GO

IF OBJECT_ID('dbo.CRM_Contact_Save', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Contact_Save
GO
CREATE PROCEDURE dbo.CRM_Contact_Save
    @ContactID INT = 0,
    @AccountID INT = 0,
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Title NVARCHAR(150) = '',
    @Email NVARCHAR(200) = '',
    @Phone NVARCHAR(50) = '',
    @Mobile NVARCHAR(50) = '',
    @Department NVARCHAR(150) = '',
    @PreferredContactMethod NVARCHAR(50) = '',
    @LastContactedDate NVARCHAR(50) = '',
    @AssignedToEmployeeID INT = 0,
    @Description NVARCHAR(MAX) = '',
    @AddedBy INT,
    @ReturnValue BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF @AccountID = 0 SET @AccountID = NULL;
    IF @AssignedToEmployeeID = 0 SET @AssignedToEmployeeID = @AddedBy;

    IF @ContactID = 0
    BEGIN
        INSERT dbo.CRM_Contact(AccountID, FirstName, LastName, Title, Email, Phone, Mobile, Department, PreferredContactMethod, LastContactedDate, AssignedToEmployeeID, Description, CreatedBy)
        VALUES(@AccountID, @FirstName, @LastName, @Title, @Email, @Phone, @Mobile, @Department, @PreferredContactMethod, dbo.CRM_ToDate(@LastContactedDate), @AssignedToEmployeeID, @Description, @AddedBy);
        SET @ReturnValue = SCOPE_IDENTITY();
        RETURN;
    END

    UPDATE dbo.CRM_Contact
    SET AccountID = @AccountID, FirstName = @FirstName, LastName = @LastName, Title = @Title, Email = @Email, Phone = @Phone, Mobile = @Mobile,
        Department = @Department, PreferredContactMethod = @PreferredContactMethod, LastContactedDate = dbo.CRM_ToDate(@LastContactedDate),
        AssignedToEmployeeID = @AssignedToEmployeeID, Description = @Description, ModifiedBy = @AddedBy, ModifiedOn = SYSDATETIME()
    WHERE ContactID = @ContactID AND IsDeleted = 0;
    SET @ReturnValue = @ContactID;
END
GO

IF OBJECT_ID('dbo.CRM_Deal_Save', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Deal_Save
GO
CREATE PROCEDURE dbo.CRM_Deal_Save
    @DealID INT = 0,
    @DealName NVARCHAR(200),
    @AccountID INT = 0,
    @ContactID INT = 0,
    @LeadID INT = 0,
    @DealStageID INT = 0,
    @Amount NVARCHAR(50) = '',
    @Probability NVARCHAR(50) = '',
    @ExpectedCloseDate NVARCHAR(50) = '',
    @LostReason NVARCHAR(300) = '',
    @AssignedToEmployeeID INT = 0,
    @Description NVARCHAR(MAX) = '',
    @AddedBy INT,
    @ReturnValue BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF @AccountID = 0 SET @AccountID = NULL;
    IF @ContactID = 0 SET @ContactID = NULL;
    IF @LeadID = 0 SET @LeadID = NULL;
    IF @DealStageID = 0 SELECT TOP 1 @DealStageID = DealStageID FROM dbo.CRM_DealStage WHERE IsActive = 1 ORDER BY SortOrder;
    IF @AssignedToEmployeeID = 0 SET @AssignedToEmployeeID = @AddedBy;

    IF @DealID = 0
    BEGIN
        INSERT dbo.CRM_Deal(DealName, AccountID, ContactID, LeadID, DealStageID, Amount, Probability, ExpectedCloseDate, LostReason, AssignedToEmployeeID, Description, CreatedBy)
        VALUES(@DealName, @AccountID, @ContactID, @LeadID, @DealStageID, dbo.CRM_ToDecimal(@Amount), dbo.CRM_ToDecimal(@Probability), dbo.CRM_ToDate(@ExpectedCloseDate), @LostReason, @AssignedToEmployeeID, @Description, @AddedBy);
        SET @ReturnValue = SCOPE_IDENTITY();
        RETURN;
    END

    UPDATE dbo.CRM_Deal
    SET DealName = @DealName, AccountID = @AccountID, ContactID = @ContactID, LeadID = @LeadID, DealStageID = @DealStageID,
        Amount = dbo.CRM_ToDecimal(@Amount), Probability = dbo.CRM_ToDecimal(@Probability),
        ExpectedCloseDate = dbo.CRM_ToDate(@ExpectedCloseDate), LostReason = @LostReason, AssignedToEmployeeID = @AssignedToEmployeeID,
        Description = @Description, ModifiedBy = @AddedBy, ModifiedOn = SYSDATETIME()
    WHERE DealID = @DealID AND IsDeleted = 0;
    SET @ReturnValue = @DealID;
END
GO

IF OBJECT_ID('dbo.CRM_Activity_Save', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Activity_Save
GO
CREATE PROCEDURE dbo.CRM_Activity_Save
    @ActivityID INT = 0,
    @ActivityTypeID INT = 0,
    @Subject NVARCHAR(250),
    @RelatedEntity NVARCHAR(30) = '',
    @RelatedRecordID INT = 0,
    @ActivityStatusID INT = 0,
    @Priority NVARCHAR(30) = '',
    @DueDate NVARCHAR(50) = '',
    @StartDateTime NVARCHAR(50) = '',
    @EndDateTime NVARCHAR(50) = '',
    @Outcome NVARCHAR(500) = '',
    @AssignedToEmployeeID INT = 0,
    @Description NVARCHAR(MAX) = '',
    @AddedBy INT,
    @ReturnValue BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF @ActivityTypeID = 0 SELECT TOP 1 @ActivityTypeID = ActivityTypeID FROM dbo.CRM_ActivityType WHERE IsActive = 1 ORDER BY SortOrder;
    IF @ActivityStatusID = 0 SELECT TOP 1 @ActivityStatusID = ActivityStatusID FROM dbo.CRM_ActivityStatus WHERE IsActive = 1 ORDER BY SortOrder;
    IF @AssignedToEmployeeID = 0 SET @AssignedToEmployeeID = @AddedBy;
    IF @RelatedRecordID = 0 SET @RelatedRecordID = NULL;

    IF @ActivityID = 0
    BEGIN
        INSERT dbo.CRM_Activity(ActivityTypeID, Subject, RelatedEntity, RelatedRecordID, ActivityStatusID, Priority, DueDate, StartDateTime, EndDateTime, Outcome, AssignedToEmployeeID, Description, CreatedBy)
        VALUES(@ActivityTypeID, @Subject, @RelatedEntity, @RelatedRecordID, @ActivityStatusID, @Priority, dbo.CRM_ToDate(@DueDate), dbo.CRM_ToDateTime(@StartDateTime), dbo.CRM_ToDateTime(@EndDateTime), @Outcome, @AssignedToEmployeeID, @Description, @AddedBy);
        SET @ReturnValue = SCOPE_IDENTITY();
        RETURN;
    END

    UPDATE dbo.CRM_Activity
    SET ActivityTypeID = @ActivityTypeID, Subject = @Subject, RelatedEntity = @RelatedEntity, RelatedRecordID = @RelatedRecordID,
        ActivityStatusID = @ActivityStatusID, Priority = @Priority, DueDate = dbo.CRM_ToDate(@DueDate),
        StartDateTime = dbo.CRM_ToDateTime(@StartDateTime), EndDateTime = dbo.CRM_ToDateTime(@EndDateTime),
        Outcome = @Outcome, AssignedToEmployeeID = @AssignedToEmployeeID, Description = @Description, ModifiedBy = @AddedBy, ModifiedOn = SYSDATETIME()
    WHERE ActivityID = @ActivityID AND IsDeleted = 0;
    SET @ReturnValue = @ActivityID;
END
GO

IF OBJECT_ID('dbo.CRM_Note_Save', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Note_Save
GO
CREATE PROCEDURE dbo.CRM_Note_Save
    @NoteID INT = 0,
    @RelatedEntity NVARCHAR(30),
    @RelatedRecordID INT,
    @NoteTitle NVARCHAR(250) = '',
    @NoteText NVARCHAR(MAX),
    @AddedBy INT,
    @ReturnValue BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @NoteID = 0
    BEGIN
        INSERT dbo.CRM_Note(RelatedEntity, RelatedRecordID, NoteTitle, NoteText, CreatedBy)
        VALUES(@RelatedEntity, @RelatedRecordID, @NoteTitle, @NoteText, @AddedBy);
        SET @ReturnValue = SCOPE_IDENTITY();
        RETURN;
    END

    UPDATE dbo.CRM_Note
    SET NoteTitle = @NoteTitle, NoteText = @NoteText, ModifiedBy = @AddedBy, ModifiedOn = SYSDATETIME()
    WHERE NoteID = @NoteID AND IsDeleted = 0;
    SET @ReturnValue = @NoteID;
END
GO

IF OBJECT_ID('dbo.CRM_Record_Delete', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Record_Delete
GO
CREATE PROCEDURE dbo.CRM_Record_Delete
    @Entity NVARCHAR(30),
    @RecordID INT,
    @DeletedBy INT,
    @ReturnValue BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ReturnValue = -1;

    IF @Entity = 'Lead' UPDATE dbo.CRM_Lead SET IsDeleted = 1, ModifiedBy = @DeletedBy, ModifiedOn = SYSDATETIME() WHERE LeadID = @RecordID;
    IF @Entity = 'Account' UPDATE dbo.CRM_Account SET IsDeleted = 1, ModifiedBy = @DeletedBy, ModifiedOn = SYSDATETIME() WHERE AccountID = @RecordID;
    IF @Entity = 'Contact' UPDATE dbo.CRM_Contact SET IsDeleted = 1, ModifiedBy = @DeletedBy, ModifiedOn = SYSDATETIME() WHERE ContactID = @RecordID;
    IF @Entity = 'Deal' UPDATE dbo.CRM_Deal SET IsDeleted = 1, ModifiedBy = @DeletedBy, ModifiedOn = SYSDATETIME() WHERE DealID = @RecordID;
    IF @Entity = 'Activity' UPDATE dbo.CRM_Activity SET IsDeleted = 1, ModifiedBy = @DeletedBy, ModifiedOn = SYSDATETIME() WHERE ActivityID = @RecordID;
    IF @Entity = 'Note' UPDATE dbo.CRM_Note SET IsDeleted = 1, ModifiedBy = @DeletedBy, ModifiedOn = SYSDATETIME() WHERE NoteID = @RecordID;

    IF @@ROWCOUNT > 0 SET @ReturnValue = @RecordID;
END
GO

IF OBJECT_ID('dbo.CRM_Lead_Convert', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Lead_Convert
GO
CREATE PROCEDURE dbo.CRM_Lead_Convert
    @LeadID INT,
    @DealName NVARCHAR(200),
    @Amount NVARCHAR(50) = '',
    @ExpectedCloseDate NVARCHAR(50) = '',
    @ConvertedBy INT,
    @ReturnValue BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AccountID INT, @ContactID INT, @DealID INT, @ConvertedStatusID INT, @StageID INT;
    DECLARE @FirstName NVARCHAR(100), @LastName NVARCHAR(100), @CompanyName NVARCHAR(200), @Email NVARCHAR(200), @Phone NVARCHAR(50), @Mobile NVARCHAR(50), @OwnerID INT, @Description NVARCHAR(MAX);

    SELECT @FirstName = FirstName, @LastName = LastName, @CompanyName = CompanyName, @Email = Email, @Phone = Phone, @Mobile = Mobile,
           @OwnerID = ISNULL(AssignedToEmployeeID, @ConvertedBy), @Description = Description
    FROM dbo.CRM_Lead
    WHERE LeadID = @LeadID AND IsDeleted = 0;

    IF @FirstName IS NULL
    BEGIN
        SET @ReturnValue = -1;
        RETURN;
    END

    SELECT @ConvertedStatusID = LeadStatusID FROM dbo.CRM_LeadStatus WHERE IsConverted = 1 AND IsActive = 1;
    SELECT TOP 1 @StageID = DealStageID FROM dbo.CRM_DealStage WHERE IsActive = 1 AND IsWon = 0 AND IsLost = 0 ORDER BY SortOrder;

    SELECT TOP 1 @AccountID = AccountID FROM dbo.CRM_Account WHERE AccountName = @CompanyName AND IsDeleted = 0;
    IF @AccountID IS NULL
    BEGIN
        INSERT dbo.CRM_Account(AccountName, AccountType, Phone, Email, AssignedToEmployeeID, Description, CreatedBy)
        VALUES(@CompanyName, 'Prospect', @Phone, @Email, @OwnerID, @Description, @ConvertedBy);
        SET @AccountID = SCOPE_IDENTITY();
    END

    INSERT dbo.CRM_Contact(AccountID, FirstName, LastName, Email, Phone, Mobile, AssignedToEmployeeID, Description, CreatedBy)
    VALUES(@AccountID, @FirstName, @LastName, @Email, @Phone, @Mobile, @OwnerID, @Description, @ConvertedBy);
    SET @ContactID = SCOPE_IDENTITY();

    INSERT dbo.CRM_Deal(DealName, AccountID, ContactID, LeadID, DealStageID, Amount, ExpectedCloseDate, AssignedToEmployeeID, Description, CreatedBy)
    VALUES(@DealName, @AccountID, @ContactID, @LeadID, @StageID, dbo.CRM_ToDecimal(@Amount), dbo.CRM_ToDate(@ExpectedCloseDate), @OwnerID, @Description, @ConvertedBy);
    SET @DealID = SCOPE_IDENTITY();

    UPDATE dbo.CRM_Lead
    SET LeadStatusID = @ConvertedStatusID, ConvertedAccountID = @AccountID, ConvertedContactID = @ContactID, ConvertedDealID = @DealID,
        ConvertedBy = @ConvertedBy, ConvertedOn = SYSDATETIME(), ModifiedBy = @ConvertedBy, ModifiedOn = SYSDATETIME()
    WHERE LeadID = @LeadID;

    SET @ReturnValue = @DealID;
END
GO

IF OBJECT_ID('dbo.CRM_Report_Get', 'P') IS NOT NULL DROP PROCEDURE dbo.CRM_Report_Get
GO
CREATE PROCEDURE dbo.CRM_Report_Get
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT s.StageName, COUNT(d.DealID) AS DealCount,
           ISNULL(SUM(ISNULL(d.Amount,0) * ISNULL(ISNULL(d.Probability, s.Probability), 0) / 100), 0) AS WeightedValue
    FROM dbo.CRM_DealStage s
    LEFT JOIN dbo.CRM_Deal d ON d.DealStageID = s.DealStageID AND d.IsDeleted = 0
    WHERE s.IsActive = 1
    GROUP BY s.StageName, s.SortOrder
    ORDER BY s.SortOrder;

    SELECT s.StatusName, COUNT(l.LeadID) AS LeadCount,
           CASE WHEN s.IsConverted = 1 THEN 'Converted leads' WHEN s.IsClosed = 1 THEN 'Closed leads' ELSE 'Active leads' END AS ConversionHint
    FROM dbo.CRM_LeadStatus s
    LEFT JOIN dbo.CRM_Lead l ON l.LeadStatusID = s.LeadStatusID AND l.IsDeleted = 0
    WHERE s.IsActive = 1
    GROUP BY s.StatusName, s.SortOrder, s.IsConverted, s.IsClosed
    ORDER BY s.SortOrder;

    SELECT OwnerName = 'Employee #' + CONVERT(NVARCHAR(20), x.OwnerID),
           SUM(x.OpenLeads) AS OpenLeads,
           SUM(x.OpenDeals) AS OpenDeals,
           SUM(x.DueActivities) AS DueActivities,
           SUM(x.OverdueActivities) AS OverdueActivities
    FROM
    (
        SELECT ISNULL(l.AssignedToEmployeeID, 0) AS OwnerID, COUNT(1) AS OpenLeads, 0 AS OpenDeals, 0 AS DueActivities, 0 AS OverdueActivities
        FROM dbo.CRM_Lead l LEFT JOIN dbo.CRM_LeadStatus s ON l.LeadStatusID = s.LeadStatusID
        WHERE l.IsDeleted = 0 AND ISNULL(s.IsClosed,0) = 0
        GROUP BY ISNULL(l.AssignedToEmployeeID, 0)
        UNION ALL
        SELECT ISNULL(d.AssignedToEmployeeID, 0), 0, COUNT(1), 0, 0
        FROM dbo.CRM_Deal d LEFT JOIN dbo.CRM_DealStage s ON d.DealStageID = s.DealStageID
        WHERE d.IsDeleted = 0 AND ISNULL(s.IsWon,0) = 0 AND ISNULL(s.IsLost,0) = 0
        GROUP BY ISNULL(d.AssignedToEmployeeID, 0)
        UNION ALL
        SELECT ISNULL(a.AssignedToEmployeeID, 0), 0, 0,
               SUM(CASE WHEN a.DueDate <= DATEADD(DAY, 1, CONVERT(DATE, GETDATE())) THEN 1 ELSE 0 END),
               SUM(CASE WHEN a.DueDate < CONVERT(DATE, GETDATE()) THEN 1 ELSE 0 END)
        FROM dbo.CRM_Activity a LEFT JOIN dbo.CRM_ActivityStatus s ON a.ActivityStatusID = s.ActivityStatusID
        WHERE a.IsDeleted = 0 AND ISNULL(s.IsCompleted,0) = 0
        GROUP BY ISNULL(a.AssignedToEmployeeID, 0)
    ) x
    GROUP BY x.OwnerID
    ORDER BY SUM(x.OverdueActivities) DESC, SUM(x.DueActivities) DESC;
END
GO
