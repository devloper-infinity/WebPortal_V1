SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.CRM_EmailAccountSetting', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_EmailAccountSetting
    (
        EmailAccountID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        AccountName NVARCHAR(120) NOT NULL,
        FromName NVARCHAR(120) NULL,
        FromEmail NVARCHAR(200) NULL,
        ReplyToEmail NVARCHAR(200) NULL,
        SmtpHost NVARCHAR(200) NULL,
        SmtpPort INT NULL,
        SmtpUserName NVARCHAR(200) NULL,
        SmtpPassword NVARCHAR(500) NULL,
        EnableSSL BIT NOT NULL CONSTRAINT DF_CRM_EmailAccountSetting_EnableSSL DEFAULT (1),
        IsDefaultOutgoing BIT NOT NULL CONSTRAINT DF_CRM_EmailAccountSetting_DefaultOut DEFAULT (1),
        IsDefaultIncoming BIT NOT NULL CONSTRAINT DF_CRM_EmailAccountSetting_DefaultIn DEFAULT (0),
        IsEnabled BIT NOT NULL CONSTRAINT DF_CRM_EmailAccountSetting_Enabled DEFAULT (1),
        AutoSendEnabled BIT NOT NULL CONSTRAINT DF_CRM_EmailAccountSetting_AutoSend DEFAULT (0),
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_EmailAccountSetting_CreatedOn DEFAULT (GETDATE()),
        UpdatedBy INT NULL,
        UpdatedOn DATETIME NULL
    );
END
GO

IF OBJECT_ID('dbo.CRM_NotificationPreference', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_NotificationPreference
    (
        PreferenceID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        UserEmployeeID INT NOT NULL CONSTRAINT DF_CRM_NotificationPreference_User DEFAULT (0),
        InAppEnabled BIT NOT NULL CONSTRAINT DF_CRM_NotificationPreference_InApp DEFAULT (1),
        EmailEnabled BIT NOT NULL CONSTRAINT DF_CRM_NotificationPreference_Email DEFAULT (1),
        AssignmentEnabled BIT NOT NULL CONSTRAINT DF_CRM_NotificationPreference_Assignment DEFAULT (1),
        MentionEnabled BIT NOT NULL CONSTRAINT DF_CRM_NotificationPreference_Mention DEFAULT (1),
        DueActivityEnabled BIT NOT NULL CONSTRAINT DF_CRM_NotificationPreference_Due DEFAULT (1),
        OverdueSLAEnabled BIT NOT NULL CONSTRAINT DF_CRM_NotificationPreference_SLA DEFAULT (1),
        DailyDigestEnabled BIT NOT NULL CONSTRAINT DF_CRM_NotificationPreference_Digest DEFAULT (1),
        DigestTime NVARCHAR(20) NULL,
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_NotificationPreference_CreatedOn DEFAULT (GETDATE()),
        UpdatedBy INT NULL,
        UpdatedOn DATETIME NULL
    );
END
GO

IF OBJECT_ID('dbo.CRM_EmailTemplate', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_EmailTemplate
    (
        TemplateID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        TemplateName NVARCHAR(150) NOT NULL,
        TriggerEvent NVARCHAR(80) NOT NULL,
        Subject NVARCHAR(250) NOT NULL,
        BodyHtml NVARCHAR(MAX) NULL,
        IsEnabled BIT NOT NULL CONSTRAINT DF_CRM_EmailTemplate_Enabled DEFAULT (1),
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_EmailTemplate_Deleted DEFAULT (0),
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_EmailTemplate_CreatedOn DEFAULT (GETDATE()),
        UpdatedBy INT NULL,
        UpdatedOn DATETIME NULL
    );
END
GO

IF OBJECT_ID('dbo.CRM_AssignmentRule', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_AssignmentRule
    (
        RuleID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        RuleName NVARCHAR(150) NOT NULL,
        Description NVARCHAR(500) NULL,
        ApplyOn NVARCHAR(30) NOT NULL,
        ConditionField NVARCHAR(120) NULL,
        ConditionOperator NVARCHAR(40) NULL,
        ConditionValue NVARCHAR(250) NULL,
        RoutingMethod NVARCHAR(60) NOT NULL,
        UserEmployeeIDs NVARCHAR(500) NULL,
        ActiveDays NVARCHAR(120) NULL,
        Priority INT NOT NULL CONSTRAINT DF_CRM_AssignmentRule_Priority DEFAULT (1),
        IsEnabled BIT NOT NULL CONSTRAINT DF_CRM_AssignmentRule_Enabled DEFAULT (1),
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_AssignmentRule_Deleted DEFAULT (0),
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_AssignmentRule_CreatedOn DEFAULT (GETDATE()),
        UpdatedBy INT NULL,
        UpdatedOn DATETIME NULL
    );
END
GO

IF OBJECT_ID('dbo.CRM_SLAPolicy', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_SLAPolicy
    (
        SLAPolicyID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        PolicyName NVARCHAR(150) NOT NULL,
        ApplyOn NVARCHAR(30) NOT NULL,
        FirstResponseMinutes INT NOT NULL CONSTRAINT DF_CRM_SLAPolicy_First DEFAULT (60),
        FollowUpMinutes INT NOT NULL CONSTRAINT DF_CRM_SLAPolicy_Follow DEFAULT (1440),
        WorkingHourStart NVARCHAR(20) NULL,
        WorkingHourEnd NVARCHAR(20) NULL,
        IsDefault BIT NOT NULL CONSTRAINT DF_CRM_SLAPolicy_Default DEFAULT (0),
        IsEnabled BIT NOT NULL CONSTRAINT DF_CRM_SLAPolicy_Enabled DEFAULT (1),
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_SLAPolicy_Deleted DEFAULT (0),
        ConditionsText NVARCHAR(1000) NULL,
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_SLAPolicy_CreatedOn DEFAULT (GETDATE()),
        UpdatedBy INT NULL,
        UpdatedOn DATETIME NULL
    );
END
GO

IF OBJECT_ID('dbo.CRM_Notification', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_Notification
    (
        NotificationID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        UserEmployeeID INT NOT NULL CONSTRAINT DF_CRM_Notification_User DEFAULT (0),
        NotificationType NVARCHAR(80) NOT NULL,
        Title NVARCHAR(250) NOT NULL,
        Message NVARCHAR(1000) NULL,
        RelatedEntity NVARCHAR(30) NULL,
        RelatedRecordID INT NULL,
        IsRead BIT NOT NULL CONSTRAINT DF_CRM_Notification_Read DEFAULT (0),
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_Notification_Deleted DEFAULT (0),
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_Notification_CreatedOn DEFAULT (GETDATE()),
        ReadOn DATETIME NULL
    );
END
GO

IF OBJECT_ID('dbo.CRM_EmailOutbox', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_EmailOutbox
    (
        EmailOutboxID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        TemplateID INT NULL,
        RelatedEntity NVARCHAR(30) NULL,
        RelatedRecordID INT NULL,
        ToEmail NVARCHAR(500) NULL,
        CcEmail NVARCHAR(500) NULL,
        BccEmail NVARCHAR(500) NULL,
        Subject NVARCHAR(250) NOT NULL,
        BodyHtml NVARCHAR(MAX) NULL,
        Status NVARCHAR(40) NOT NULL CONSTRAINT DF_CRM_EmailOutbox_Status DEFAULT ('Queued'),
        ScheduledOn DATETIME NOT NULL CONSTRAINT DF_CRM_EmailOutbox_Scheduled DEFAULT (GETDATE()),
        SentOn DATETIME NULL,
        ErrorMessage NVARCHAR(1000) NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_EmailOutbox_Deleted DEFAULT (0),
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_EmailOutbox_CreatedOn DEFAULT (GETDATE())
    );
END
GO

IF OBJECT_ID('dbo.CRM_AutomationLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_AutomationLog
    (
        AutomationLogID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        EventName NVARCHAR(80) NOT NULL,
        RelatedEntity NVARCHAR(30) NULL,
        RelatedRecordID INT NULL,
        ResultMessage NVARCHAR(1000) NULL,
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_AutomationLog_CreatedOn DEFAULT (GETDATE())
    );
END
GO

IF OBJECT_ID('dbo.CRM_DemoSeedLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_DemoSeedLog
    (
        SeedName NVARCHAR(150) NOT NULL PRIMARY KEY,
        SeededOn DATETIME NOT NULL CONSTRAINT DF_CRM_DemoSeedLog_SeededOn DEFAULT (GETDATE())
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreLeadSource', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreLeadSource
    (
        LeadSourceID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        SourceName NVARCHAR(120) NOT NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_CoreLeadSource_Active DEFAULT (1)
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreLeadStatus', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreLeadStatus
    (
        LeadStatusID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        StatusName NVARCHAR(120) NOT NULL,
        StatusColor NVARCHAR(30) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_CRM_CoreLeadStatus_Sort DEFAULT (1),
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_CoreLeadStatus_Active DEFAULT (1)
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreDealStage', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreDealStage
    (
        DealStageID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        StageName NVARCHAR(120) NOT NULL,
        Probability INT NOT NULL CONSTRAINT DF_CRM_CoreDealStage_Probability DEFAULT (0),
        StatusColor NVARCHAR(30) NULL,
        SortOrder INT NOT NULL CONSTRAINT DF_CRM_CoreDealStage_Sort DEFAULT (1),
        IsClosed BIT NOT NULL CONSTRAINT DF_CRM_CoreDealStage_Closed DEFAULT (0),
        IsWon BIT NOT NULL CONSTRAINT DF_CRM_CoreDealStage_Won DEFAULT (0),
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_CoreDealStage_Active DEFAULT (1)
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreActivityType', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreActivityType
    (
        ActivityTypeID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ActivityTypeName NVARCHAR(120) NOT NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_CoreActivityType_Active DEFAULT (1)
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreActivityStatus', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreActivityStatus
    (
        ActivityStatusID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        StatusName NVARCHAR(120) NOT NULL,
        StatusColor NVARCHAR(30) NULL,
        IsCompleted BIT NOT NULL CONSTRAINT DF_CRM_CoreActivityStatus_Completed DEFAULT (0),
        IsActive BIT NOT NULL CONSTRAINT DF_CRM_CoreActivityStatus_Active DEFAULT (1)
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreAccount', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreAccount
    (
        AccountID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
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
        AssignedToEmployeeID INT NOT NULL CONSTRAINT DF_CRM_CoreAccount_Owner DEFAULT (0),
        Description NVARCHAR(MAX) NULL,
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_CoreAccount_CreatedOn DEFAULT (GETDATE()),
        UpdatedBy INT NULL,
        UpdatedOn DATETIME NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_CoreAccount_Deleted DEFAULT (0)
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreLead', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreLead
    (
        LeadID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
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
        AssignedToEmployeeID INT NOT NULL CONSTRAINT DF_CRM_CoreLead_Owner DEFAULT (0),
        EstimatedValue DECIMAL(18,2) NULL,
        Rating NVARCHAR(50) NULL,
        NextFollowUpDate DATE NULL,
        Description NVARCHAR(MAX) NULL,
        ConvertedAccountID INT NULL,
        ConvertedContactID INT NULL,
        ConvertedDealID INT NULL,
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_CoreLead_CreatedOn DEFAULT (GETDATE()),
        UpdatedBy INT NULL,
        UpdatedOn DATETIME NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_CoreLead_Deleted DEFAULT (0)
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreContact', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreContact
    (
        ContactID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
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
        AssignedToEmployeeID INT NOT NULL CONSTRAINT DF_CRM_CoreContact_Owner DEFAULT (0),
        Description NVARCHAR(MAX) NULL,
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_CoreContact_CreatedOn DEFAULT (GETDATE()),
        UpdatedBy INT NULL,
        UpdatedOn DATETIME NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_CoreContact_Deleted DEFAULT (0)
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreDeal', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreDeal
    (
        DealID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        DealName NVARCHAR(200) NOT NULL,
        AccountID INT NULL,
        ContactID INT NULL,
        LeadID INT NULL,
        DealStageID INT NULL,
        Amount DECIMAL(18,2) NULL,
        Probability INT NULL,
        ExpectedCloseDate DATE NULL,
        LostReason NVARCHAR(300) NULL,
        AssignedToEmployeeID INT NOT NULL CONSTRAINT DF_CRM_CoreDeal_Owner DEFAULT (0),
        Description NVARCHAR(MAX) NULL,
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_CoreDeal_CreatedOn DEFAULT (GETDATE()),
        UpdatedBy INT NULL,
        UpdatedOn DATETIME NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_CoreDeal_Deleted DEFAULT (0)
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreActivity', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreActivity
    (
        ActivityID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ActivityTypeID INT NULL,
        Subject NVARCHAR(250) NOT NULL,
        RelatedEntity NVARCHAR(30) NULL,
        RelatedRecordID INT NULL,
        ActivityStatusID INT NULL,
        Priority NVARCHAR(30) NULL,
        DueDate DATE NULL,
        StartDateTime DATETIME NULL,
        EndDateTime DATETIME NULL,
        Outcome NVARCHAR(500) NULL,
        AssignedToEmployeeID INT NOT NULL CONSTRAINT DF_CRM_CoreActivity_Owner DEFAULT (0),
        Description NVARCHAR(MAX) NULL,
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_CoreActivity_CreatedOn DEFAULT (GETDATE()),
        UpdatedBy INT NULL,
        UpdatedOn DATETIME NULL,
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_CoreActivity_Deleted DEFAULT (0)
    );
END
GO

IF OBJECT_ID('dbo.CRM_CoreNote', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CRM_CoreNote
    (
        NoteID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        RelatedEntity NVARCHAR(30) NOT NULL,
        RelatedRecordID INT NOT NULL,
        NoteTitle NVARCHAR(250) NULL,
        NoteText NVARCHAR(MAX) NULL,
        CreatedBy INT NULL,
        CreatedOn DATETIME NOT NULL CONSTRAINT DF_CRM_CoreNote_CreatedOn DEFAULT (GETDATE()),
        IsDeleted BIT NOT NULL CONSTRAINT DF_CRM_CoreNote_Deleted DEFAULT (0)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_CoreLeadSource)
BEGIN
    INSERT INTO dbo.CRM_CoreLeadSource (SourceName) VALUES
    ('Website'), ('Referral'), ('Campaign'), ('Partner'), ('Cold Call');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_CoreLeadStatus)
BEGIN
    INSERT INTO dbo.CRM_CoreLeadStatus (StatusName, StatusColor, SortOrder) VALUES
    ('New', 'amber', 1), ('Qualified', 'green', 2), ('Contacted', '', 3), ('Converted', 'green', 4), ('Lost', 'red', 5);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_CoreDealStage)
BEGIN
    INSERT INTO dbo.CRM_CoreDealStage (StageName, Probability, StatusColor, SortOrder, IsClosed, IsWon) VALUES
    ('Qualification', 20, 'amber', 1, 0, 0),
    ('Proposal', 45, 'amber', 2, 0, 0),
    ('Negotiation', 70, '', 3, 0, 0),
    ('Won', 100, 'green', 4, 1, 1),
    ('Lost', 0, 'red', 5, 1, 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_CoreActivityType)
BEGIN
    INSERT INTO dbo.CRM_CoreActivityType (ActivityTypeName) VALUES
    ('Call'), ('Email'), ('Meeting'), ('Task'), ('Demo');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_CoreActivityStatus)
BEGIN
    INSERT INTO dbo.CRM_CoreActivityStatus (StatusName, StatusColor, IsCompleted) VALUES
    ('Open', 'amber', 0), ('In Progress', '', 0), ('Completed', 'green', 1), ('Cancelled', 'red', 1), ('Overdue', 'red', 0);
END
GO

IF OBJECT_ID('dbo.CRM_Lookup_List', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Lookup_List AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Lookup_List
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT LeadSourceID, SourceName FROM dbo.CRM_CoreLeadSource WHERE IsActive = 1 ORDER BY SourceName;
    SELECT LeadStatusID, StatusName, StatusColor FROM dbo.CRM_CoreLeadStatus WHERE IsActive = 1 ORDER BY SortOrder, StatusName;
    SELECT DealStageID, StageName, Probability, StatusColor FROM dbo.CRM_CoreDealStage WHERE IsActive = 1 ORDER BY SortOrder, StageName;
    SELECT ActivityTypeID, ActivityTypeName FROM dbo.CRM_CoreActivityType WHERE IsActive = 1 ORDER BY ActivityTypeName;
    SELECT ActivityStatusID, StatusName, StatusColor, IsCompleted FROM dbo.CRM_CoreActivityStatus WHERE IsActive = 1 ORDER BY ActivityStatusID;
    SELECT AccountID, AccountName FROM dbo.CRM_CoreAccount WHERE IsDeleted = 0 ORDER BY AccountName;
    SELECT ContactID, FirstName + ' ' + LastName AS ContactName, AccountID FROM dbo.CRM_CoreContact WHERE IsDeleted = 0 ORDER BY FirstName, LastName;
    SELECT LeadID, FirstName + ' ' + LastName AS LeadName, CompanyName FROM dbo.CRM_CoreLead WHERE IsDeleted = 0 ORDER BY CreatedOn DESC;
END
GO

IF OBJECT_ID('dbo.CRM_Record_List', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Record_List AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Record_List
    @Entity NVARCHAR(30),
    @SearchText NVARCHAR(200) = '',
    @FilterValue NVARCHAR(100) = '',
    @OwnerID INT = 0,
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Search NVARCHAR(204) = '%' + ISNULL(@SearchText, '') + '%';

    IF LOWER(@Entity) = 'lead'
    BEGIN
        SELECT l.LeadID AS RecordID, l.LeadID, l.FirstName, l.LastName, l.FirstName + ' ' + l.LastName AS Name,
               l.FirstName + ' ' + l.LastName AS LeadName, l.CompanyName, l.Title, l.Email, l.Phone, l.Mobile,
               l.Website, l.City, l.State, l.Country, l.LeadSourceID, s.SourceName, l.LeadStatusID,
               st.StatusName, st.StatusColor, l.AssignedToEmployeeID,
               CASE WHEN l.AssignedToEmployeeID = 0 THEN 'Unassigned' ELSE 'Employee #' + CAST(l.AssignedToEmployeeID AS NVARCHAR(20)) END AS OwnerName,
               l.EstimatedValue, l.Rating, l.NextFollowUpDate, CONVERT(NVARCHAR(11), l.NextFollowUpDate, 106) AS FollowUpText,
               l.Description, ISNULL(l.UpdatedOn, l.CreatedOn) AS UpdatedOn
        FROM dbo.CRM_CoreLead l
        LEFT JOIN dbo.CRM_CoreLeadSource s ON s.LeadSourceID = l.LeadSourceID
        LEFT JOIN dbo.CRM_CoreLeadStatus st ON st.LeadStatusID = l.LeadStatusID
        WHERE l.IsDeleted = 0
          AND (@OwnerID = 0 OR l.AssignedToEmployeeID = @OwnerID)
          AND (ISNULL(@FilterValue, '') = '' OR CAST(l.LeadStatusID AS NVARCHAR(100)) = @FilterValue)
          AND (ISNULL(@SearchText, '') = '' OR l.FirstName LIKE @Search OR l.LastName LIKE @Search OR l.CompanyName LIKE @Search OR l.Email LIKE @Search OR l.Phone LIKE @Search)
        ORDER BY l.CreatedOn DESC;
        RETURN;
    END

    IF LOWER(@Entity) = 'account'
    BEGIN
        SELECT a.AccountID AS RecordID, a.AccountID, a.AccountName AS Name, a.AccountName, a.AccountType, a.Industry,
               a.Website, a.Phone, a.Email, a.BillingCity, a.BillingState, a.BillingCountry, a.AnnualRevenue,
               a.AssignedToEmployeeID,
               CASE WHEN a.AssignedToEmployeeID = 0 THEN 'Unassigned' ELSE 'Employee #' + CAST(a.AssignedToEmployeeID AS NVARCHAR(20)) END AS OwnerName,
               a.Description, ISNULL(a.UpdatedOn, a.CreatedOn) AS UpdatedOn
        FROM dbo.CRM_CoreAccount a
        WHERE a.IsDeleted = 0
          AND (@OwnerID = 0 OR a.AssignedToEmployeeID = @OwnerID)
          AND (ISNULL(@SearchText, '') = '' OR a.AccountName LIKE @Search OR a.Website LIKE @Search OR a.Email LIKE @Search OR a.BillingCity LIKE @Search)
        ORDER BY a.CreatedOn DESC;
        RETURN;
    END

    IF LOWER(@Entity) = 'contact'
    BEGIN
        SELECT c.ContactID AS RecordID, c.ContactID, c.AccountID, a.AccountName, c.FirstName, c.LastName,
               c.FirstName + ' ' + c.LastName AS Name, c.FirstName + ' ' + c.LastName AS ContactName,
               c.Title, c.Email, c.Phone, c.Mobile, c.Department, c.PreferredContactMethod, c.LastContactedDate,
               c.AssignedToEmployeeID,
               CASE WHEN c.AssignedToEmployeeID = 0 THEN 'Unassigned' ELSE 'Employee #' + CAST(c.AssignedToEmployeeID AS NVARCHAR(20)) END AS OwnerName,
               c.Description, ISNULL(c.UpdatedOn, c.CreatedOn) AS UpdatedOn
        FROM dbo.CRM_CoreContact c
        LEFT JOIN dbo.CRM_CoreAccount a ON a.AccountID = c.AccountID
        WHERE c.IsDeleted = 0
          AND (@OwnerID = 0 OR c.AssignedToEmployeeID = @OwnerID)
          AND (ISNULL(@SearchText, '') = '' OR c.FirstName LIKE @Search OR c.LastName LIKE @Search OR c.Email LIKE @Search OR c.Phone LIKE @Search OR a.AccountName LIKE @Search)
        ORDER BY c.CreatedOn DESC;
        RETURN;
    END

    IF LOWER(@Entity) = 'deal'
    BEGIN
        SELECT d.DealID AS RecordID, d.DealID, d.DealName AS Name, d.DealName, d.AccountID, a.AccountName,
               d.ContactID, c.FirstName + ' ' + c.LastName AS ContactName, d.LeadID, d.DealStageID,
               st.StageName, st.StatusColor, d.Amount, d.Probability, d.ExpectedCloseDate, d.LostReason,
               d.AssignedToEmployeeID,
               CASE WHEN d.AssignedToEmployeeID = 0 THEN 'Unassigned' ELSE 'Employee #' + CAST(d.AssignedToEmployeeID AS NVARCHAR(20)) END AS OwnerName,
               d.Description, ISNULL(d.UpdatedOn, d.CreatedOn) AS UpdatedOn
        FROM dbo.CRM_CoreDeal d
        LEFT JOIN dbo.CRM_CoreAccount a ON a.AccountID = d.AccountID
        LEFT JOIN dbo.CRM_CoreContact c ON c.ContactID = d.ContactID
        LEFT JOIN dbo.CRM_CoreDealStage st ON st.DealStageID = d.DealStageID
        WHERE d.IsDeleted = 0
          AND (@OwnerID = 0 OR d.AssignedToEmployeeID = @OwnerID)
          AND (ISNULL(@FilterValue, '') = '' OR CAST(d.DealStageID AS NVARCHAR(100)) = @FilterValue)
          AND (ISNULL(@SearchText, '') = '' OR d.DealName LIKE @Search OR a.AccountName LIKE @Search OR c.FirstName LIKE @Search OR c.LastName LIKE @Search)
        ORDER BY d.CreatedOn DESC;
        RETURN;
    END

    SELECT ac.ActivityID AS RecordID, ac.ActivityID, ac.Subject AS Name, ac.Subject, ac.ActivityTypeID, t.ActivityTypeName,
           ac.RelatedEntity, ac.RelatedRecordID,
           CASE
               WHEN ac.RelatedEntity = 'Lead' THEN (SELECT TOP 1 FirstName + ' ' + LastName FROM dbo.CRM_CoreLead WHERE LeadID = ac.RelatedRecordID)
               WHEN ac.RelatedEntity = 'Account' THEN (SELECT TOP 1 AccountName FROM dbo.CRM_CoreAccount WHERE AccountID = ac.RelatedRecordID)
               WHEN ac.RelatedEntity = 'Contact' THEN (SELECT TOP 1 FirstName + ' ' + LastName FROM dbo.CRM_CoreContact WHERE ContactID = ac.RelatedRecordID)
               WHEN ac.RelatedEntity = 'Deal' THEN (SELECT TOP 1 DealName FROM dbo.CRM_CoreDeal WHERE DealID = ac.RelatedRecordID)
               ELSE ac.RelatedEntity
           END AS RelatedName,
           ac.ActivityStatusID, s.StatusName, s.StatusColor, ac.Priority, ac.DueDate, ac.StartDateTime, ac.EndDateTime,
           ac.Outcome, ac.AssignedToEmployeeID,
           CASE WHEN ac.AssignedToEmployeeID = 0 THEN 'Unassigned' ELSE 'Employee #' + CAST(ac.AssignedToEmployeeID AS NVARCHAR(20)) END AS OwnerName,
           ac.Description, ISNULL(ac.UpdatedOn, ac.CreatedOn) AS UpdatedOn
    FROM dbo.CRM_CoreActivity ac
    LEFT JOIN dbo.CRM_CoreActivityType t ON t.ActivityTypeID = ac.ActivityTypeID
    LEFT JOIN dbo.CRM_CoreActivityStatus s ON s.ActivityStatusID = ac.ActivityStatusID
    WHERE ac.IsDeleted = 0
      AND (@OwnerID = 0 OR ac.AssignedToEmployeeID = @OwnerID)
      AND (ISNULL(@FilterValue, '') = '' OR CAST(ac.ActivityStatusID AS NVARCHAR(100)) = @FilterValue)
      AND (ISNULL(@SearchText, '') = '' OR ac.Subject LIKE @Search OR ac.Description LIKE @Search)
    ORDER BY ac.DueDate, ac.CreatedOn DESC;
END
GO

IF OBJECT_ID('dbo.CRM_Record_Get', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Record_Get AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Record_Get
    @Entity NVARCHAR(30),
    @RecordID INT,
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF LOWER(@Entity) = 'lead'
        SELECT * FROM dbo.CRM_CoreLead WHERE LeadID = @RecordID AND IsDeleted = 0;
    ELSE IF LOWER(@Entity) = 'account'
        SELECT * FROM dbo.CRM_CoreAccount WHERE AccountID = @RecordID AND IsDeleted = 0;
    ELSE IF LOWER(@Entity) = 'contact'
        SELECT * FROM dbo.CRM_CoreContact WHERE ContactID = @RecordID AND IsDeleted = 0;
    ELSE IF LOWER(@Entity) = 'deal'
        SELECT * FROM dbo.CRM_CoreDeal WHERE DealID = @RecordID AND IsDeleted = 0;
    ELSE
        SELECT * FROM dbo.CRM_CoreActivity WHERE ActivityID = @RecordID AND IsDeleted = 0;

    SELECT NoteID, RelatedEntity, RelatedRecordID, NoteTitle, NoteText, CreatedBy, CreatedOn
    FROM dbo.CRM_CoreNote
    WHERE IsDeleted = 0 AND RelatedEntity = @Entity AND RelatedRecordID = @RecordID
    ORDER BY CreatedOn DESC;

    SELECT ActivityID, Subject, RelatedEntity, RelatedRecordID, DueDate, Priority, Description, CreatedOn
    FROM dbo.CRM_CoreActivity
    WHERE IsDeleted = 0 AND RelatedEntity = @Entity AND RelatedRecordID = @RecordID
    ORDER BY DueDate, CreatedOn DESC;
END
GO

IF OBJECT_ID('dbo.CRM_Lead_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Lead_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Lead_Save
    @LeadID INT = 0, @FirstName NVARCHAR(100), @LastName NVARCHAR(100), @CompanyName NVARCHAR(200),
    @Title NVARCHAR(150) = '', @Email NVARCHAR(200) = '', @Phone NVARCHAR(50) = '', @Mobile NVARCHAR(50) = '',
    @Website NVARCHAR(250) = '', @City NVARCHAR(100) = '', @State NVARCHAR(100) = '', @Country NVARCHAR(100) = '',
    @LeadSourceID INT = 0, @LeadStatusID INT = 0, @AssignedToEmployeeID INT = 0, @EstimatedValue NVARCHAR(50) = '',
    @Rating NVARCHAR(50) = '', @NextFollowUpDate NVARCHAR(50) = '', @Description NVARCHAR(4000) = '', @AddedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF @LeadSourceID = 0 SELECT TOP 1 @LeadSourceID = LeadSourceID FROM dbo.CRM_CoreLeadSource ORDER BY LeadSourceID;
    IF @LeadStatusID = 0 SELECT TOP 1 @LeadStatusID = LeadStatusID FROM dbo.CRM_CoreLeadStatus ORDER BY SortOrder;

    IF @LeadID > 0 AND EXISTS (SELECT 1 FROM dbo.CRM_CoreLead WHERE LeadID = @LeadID)
        UPDATE dbo.CRM_CoreLead
        SET FirstName = @FirstName, LastName = @LastName, CompanyName = @CompanyName, Title = @Title, Email = @Email,
            Phone = @Phone, Mobile = @Mobile, Website = @Website, City = @City, State = @State, Country = @Country,
            LeadSourceID = @LeadSourceID, LeadStatusID = @LeadStatusID, AssignedToEmployeeID = @AssignedToEmployeeID,
            EstimatedValue = CASE WHEN ISNUMERIC(@EstimatedValue) = 1 THEN CONVERT(DECIMAL(18,2), @EstimatedValue) ELSE NULL END, Rating = @Rating,
            NextFollowUpDate = CASE WHEN ISDATE(@NextFollowUpDate) = 1 THEN CONVERT(DATE, @NextFollowUpDate) ELSE NULL END, Description = @Description,
            UpdatedBy = @AddedBy, UpdatedOn = GETDATE()
        WHERE LeadID = @LeadID;
    ELSE
    BEGIN
        INSERT INTO dbo.CRM_CoreLead
        (FirstName, LastName, CompanyName, Title, Email, Phone, Mobile, Website, City, State, Country, LeadSourceID,
         LeadStatusID, AssignedToEmployeeID, EstimatedValue, Rating, NextFollowUpDate, Description, CreatedBy)
        VALUES
        (@FirstName, @LastName, @CompanyName, @Title, @Email, @Phone, @Mobile, @Website, @City, @State, @Country,
         @LeadSourceID, @LeadStatusID, @AssignedToEmployeeID, CASE WHEN ISNUMERIC(@EstimatedValue) = 1 THEN CONVERT(DECIMAL(18,2), @EstimatedValue) ELSE NULL END,
         @Rating, CASE WHEN ISDATE(@NextFollowUpDate) = 1 THEN CONVERT(DATE, @NextFollowUpDate) ELSE NULL END, @Description, @AddedBy);
        SET @LeadID = SCOPE_IDENTITY();
    END
    RETURN @LeadID;
END
GO

IF OBJECT_ID('dbo.CRM_Account_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Account_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Account_Save
    @AccountID INT = 0, @AccountName NVARCHAR(200), @AccountType NVARCHAR(100) = '', @Industry NVARCHAR(150) = '',
    @Website NVARCHAR(250) = '', @Phone NVARCHAR(50) = '', @Email NVARCHAR(200) = '', @BillingCity NVARCHAR(100) = '',
    @BillingState NVARCHAR(100) = '', @BillingCountry NVARCHAR(100) = '', @AnnualRevenue NVARCHAR(50) = '',
    @AssignedToEmployeeID INT = 0, @Description NVARCHAR(4000) = '', @AddedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF @AccountID > 0 AND EXISTS (SELECT 1 FROM dbo.CRM_CoreAccount WHERE AccountID = @AccountID)
        UPDATE dbo.CRM_CoreAccount
        SET AccountName = @AccountName, AccountType = @AccountType, Industry = @Industry, Website = @Website,
            Phone = @Phone, Email = @Email, BillingCity = @BillingCity, BillingState = @BillingState,
            BillingCountry = @BillingCountry, AnnualRevenue = CASE WHEN ISNUMERIC(@AnnualRevenue) = 1 THEN CONVERT(DECIMAL(18,2), @AnnualRevenue) ELSE NULL END,
            AssignedToEmployeeID = @AssignedToEmployeeID, Description = @Description, UpdatedBy = @AddedBy,
            UpdatedOn = GETDATE()
        WHERE AccountID = @AccountID;
    ELSE
    BEGIN
        INSERT INTO dbo.CRM_CoreAccount
        (AccountName, AccountType, Industry, Website, Phone, Email, BillingCity, BillingState, BillingCountry,
         AnnualRevenue, AssignedToEmployeeID, Description, CreatedBy)
        VALUES
        (@AccountName, @AccountType, @Industry, @Website, @Phone, @Email, @BillingCity, @BillingState,
         @BillingCountry, CASE WHEN ISNUMERIC(@AnnualRevenue) = 1 THEN CONVERT(DECIMAL(18,2), @AnnualRevenue) ELSE NULL END, @AssignedToEmployeeID, @Description, @AddedBy);
        SET @AccountID = SCOPE_IDENTITY();
    END
    RETURN @AccountID;
END
GO

IF OBJECT_ID('dbo.CRM_Contact_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Contact_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Contact_Save
    @ContactID INT = 0, @AccountID INT = 0, @FirstName NVARCHAR(100), @LastName NVARCHAR(100),
    @Title NVARCHAR(150) = '', @Email NVARCHAR(200) = '', @Phone NVARCHAR(50) = '', @Mobile NVARCHAR(50) = '',
    @Department NVARCHAR(150) = '', @PreferredContactMethod NVARCHAR(50) = '', @LastContactedDate NVARCHAR(50) = '',
    @AssignedToEmployeeID INT = 0, @Description NVARCHAR(4000) = '', @AddedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF @ContactID > 0 AND EXISTS (SELECT 1 FROM dbo.CRM_CoreContact WHERE ContactID = @ContactID)
        UPDATE dbo.CRM_CoreContact
        SET AccountID = NULLIF(@AccountID, 0), FirstName = @FirstName, LastName = @LastName, Title = @Title,
            Email = @Email, Phone = @Phone, Mobile = @Mobile, Department = @Department,
            PreferredContactMethod = @PreferredContactMethod, LastContactedDate = CASE WHEN ISDATE(@LastContactedDate) = 1 THEN CONVERT(DATE, @LastContactedDate) ELSE NULL END,
            AssignedToEmployeeID = @AssignedToEmployeeID, Description = @Description, UpdatedBy = @AddedBy, UpdatedOn = GETDATE()
        WHERE ContactID = @ContactID;
    ELSE
    BEGIN
        INSERT INTO dbo.CRM_CoreContact
        (AccountID, FirstName, LastName, Title, Email, Phone, Mobile, Department, PreferredContactMethod,
         LastContactedDate, AssignedToEmployeeID, Description, CreatedBy)
        VALUES
        (NULLIF(@AccountID, 0), @FirstName, @LastName, @Title, @Email, @Phone, @Mobile, @Department,
         @PreferredContactMethod, CASE WHEN ISDATE(@LastContactedDate) = 1 THEN CONVERT(DATE, @LastContactedDate) ELSE NULL END, @AssignedToEmployeeID, @Description, @AddedBy);
        SET @ContactID = SCOPE_IDENTITY();
    END
    RETURN @ContactID;
END
GO

IF OBJECT_ID('dbo.CRM_Deal_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Deal_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Deal_Save
    @DealID INT = 0, @DealName NVARCHAR(200), @AccountID INT = 0, @ContactID INT = 0, @LeadID INT = 0,
    @DealStageID INT = 0, @Amount NVARCHAR(50) = '', @Probability NVARCHAR(50) = '', @ExpectedCloseDate NVARCHAR(50) = '',
    @LostReason NVARCHAR(300) = '', @AssignedToEmployeeID INT = 0, @Description NVARCHAR(4000) = '', @AddedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF @DealStageID = 0 SELECT TOP 1 @DealStageID = DealStageID FROM dbo.CRM_CoreDealStage ORDER BY SortOrder;

    IF @DealID > 0 AND EXISTS (SELECT 1 FROM dbo.CRM_CoreDeal WHERE DealID = @DealID)
        UPDATE dbo.CRM_CoreDeal
        SET DealName = @DealName, AccountID = NULLIF(@AccountID, 0), ContactID = NULLIF(@ContactID, 0),
            LeadID = NULLIF(@LeadID, 0), DealStageID = @DealStageID, Amount = CASE WHEN ISNUMERIC(@Amount) = 1 THEN CONVERT(DECIMAL(18,2), @Amount) ELSE NULL END,
            Probability = CASE WHEN ISNUMERIC(@Probability) = 1 THEN CONVERT(INT, @Probability) ELSE NULL END, ExpectedCloseDate = CASE WHEN ISDATE(@ExpectedCloseDate) = 1 THEN CONVERT(DATE, @ExpectedCloseDate) ELSE NULL END,
            LostReason = @LostReason, AssignedToEmployeeID = @AssignedToEmployeeID, Description = @Description,
            UpdatedBy = @AddedBy, UpdatedOn = GETDATE()
        WHERE DealID = @DealID;
    ELSE
    BEGIN
        INSERT INTO dbo.CRM_CoreDeal
        (DealName, AccountID, ContactID, LeadID, DealStageID, Amount, Probability, ExpectedCloseDate, LostReason,
         AssignedToEmployeeID, Description, CreatedBy)
        VALUES
        (@DealName, NULLIF(@AccountID, 0), NULLIF(@ContactID, 0), NULLIF(@LeadID, 0), @DealStageID,
         CASE WHEN ISNUMERIC(@Amount) = 1 THEN CONVERT(DECIMAL(18,2), @Amount) ELSE NULL END, CASE WHEN ISNUMERIC(@Probability) = 1 THEN CONVERT(INT, @Probability) ELSE NULL END,
         CASE WHEN ISDATE(@ExpectedCloseDate) = 1 THEN CONVERT(DATE, @ExpectedCloseDate) ELSE NULL END, @LostReason, @AssignedToEmployeeID, @Description, @AddedBy);
        SET @DealID = SCOPE_IDENTITY();
    END
    RETURN @DealID;
END
GO

IF OBJECT_ID('dbo.CRM_Activity_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Activity_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Activity_Save
    @ActivityID INT = 0, @ActivityTypeID INT = 0, @Subject NVARCHAR(250), @RelatedEntity NVARCHAR(30) = '',
    @RelatedRecordID INT = 0, @ActivityStatusID INT = 0, @Priority NVARCHAR(30) = '', @DueDate NVARCHAR(50) = '',
    @StartDateTime NVARCHAR(50) = '', @EndDateTime NVARCHAR(50) = '', @Outcome NVARCHAR(500) = '',
    @AssignedToEmployeeID INT = 0, @Description NVARCHAR(4000) = '', @AddedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF @ActivityTypeID = 0 SELECT TOP 1 @ActivityTypeID = ActivityTypeID FROM dbo.CRM_CoreActivityType ORDER BY ActivityTypeID;
    IF @ActivityStatusID = 0 SELECT TOP 1 @ActivityStatusID = ActivityStatusID FROM dbo.CRM_CoreActivityStatus WHERE IsCompleted = 0 ORDER BY ActivityStatusID;

    IF @ActivityID > 0 AND EXISTS (SELECT 1 FROM dbo.CRM_CoreActivity WHERE ActivityID = @ActivityID)
        UPDATE dbo.CRM_CoreActivity
        SET ActivityTypeID = @ActivityTypeID, Subject = @Subject, RelatedEntity = @RelatedEntity,
            RelatedRecordID = NULLIF(@RelatedRecordID, 0), ActivityStatusID = @ActivityStatusID, Priority = @Priority,
            DueDate = CASE WHEN ISDATE(@DueDate) = 1 THEN CONVERT(DATE, @DueDate) ELSE NULL END, StartDateTime = CASE WHEN ISDATE(@StartDateTime) = 1 THEN CONVERT(DATETIME, @StartDateTime) ELSE NULL END,
            EndDateTime = CASE WHEN ISDATE(@EndDateTime) = 1 THEN CONVERT(DATETIME, @EndDateTime) ELSE NULL END, Outcome = @Outcome,
            AssignedToEmployeeID = @AssignedToEmployeeID, Description = @Description, UpdatedBy = @AddedBy,
            UpdatedOn = GETDATE()
        WHERE ActivityID = @ActivityID;
    ELSE
    BEGIN
        INSERT INTO dbo.CRM_CoreActivity
        (ActivityTypeID, Subject, RelatedEntity, RelatedRecordID, ActivityStatusID, Priority, DueDate,
         StartDateTime, EndDateTime, Outcome, AssignedToEmployeeID, Description, CreatedBy)
        VALUES
        (@ActivityTypeID, @Subject, @RelatedEntity, NULLIF(@RelatedRecordID, 0), @ActivityStatusID, @Priority,
         CASE WHEN ISDATE(@DueDate) = 1 THEN CONVERT(DATE, @DueDate) ELSE NULL END, CASE WHEN ISDATE(@StartDateTime) = 1 THEN CONVERT(DATETIME, @StartDateTime) ELSE NULL END,
         CASE WHEN ISDATE(@EndDateTime) = 1 THEN CONVERT(DATETIME, @EndDateTime) ELSE NULL END, @Outcome, @AssignedToEmployeeID, @Description, @AddedBy);
        SET @ActivityID = SCOPE_IDENTITY();
    END
    RETURN @ActivityID;
END
GO

IF OBJECT_ID('dbo.CRM_Note_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Note_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Note_Save
    @NoteID INT = 0, @RelatedEntity NVARCHAR(30), @RelatedRecordID INT, @NoteTitle NVARCHAR(250) = '',
    @NoteText NVARCHAR(4000) = '', @AddedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.CRM_CoreNote (RelatedEntity, RelatedRecordID, NoteTitle, NoteText, CreatedBy)
    VALUES (@RelatedEntity, @RelatedRecordID, @NoteTitle, @NoteText, @AddedBy);
    RETURN SCOPE_IDENTITY();
END
GO

IF OBJECT_ID('dbo.CRM_Record_Delete', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Record_Delete AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Record_Delete
    @Entity NVARCHAR(30),
    @RecordID INT,
    @DeletedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF LOWER(@Entity) = 'lead' UPDATE dbo.CRM_CoreLead SET IsDeleted = 1, UpdatedBy = @DeletedBy, UpdatedOn = GETDATE() WHERE LeadID = @RecordID;
    ELSE IF LOWER(@Entity) = 'account' UPDATE dbo.CRM_CoreAccount SET IsDeleted = 1, UpdatedBy = @DeletedBy, UpdatedOn = GETDATE() WHERE AccountID = @RecordID;
    ELSE IF LOWER(@Entity) = 'contact' UPDATE dbo.CRM_CoreContact SET IsDeleted = 1, UpdatedBy = @DeletedBy, UpdatedOn = GETDATE() WHERE ContactID = @RecordID;
    ELSE IF LOWER(@Entity) = 'deal' UPDATE dbo.CRM_CoreDeal SET IsDeleted = 1, UpdatedBy = @DeletedBy, UpdatedOn = GETDATE() WHERE DealID = @RecordID;
    ELSE IF LOWER(@Entity) = 'activity' UPDATE dbo.CRM_CoreActivity SET IsDeleted = 1, UpdatedBy = @DeletedBy, UpdatedOn = GETDATE() WHERE ActivityID = @RecordID;
    ELSE RETURN -2;
    RETURN 1;
END
GO

IF OBJECT_ID('dbo.CRM_Lead_Convert', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Lead_Convert AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Lead_Convert
    @LeadID INT,
    @DealName NVARCHAR(200),
    @Amount NVARCHAR(50) = '',
    @ExpectedCloseDate NVARCHAR(50) = '',
    @ConvertedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AccountID INT = 0;
    DECLARE @ContactID INT = 0;
    DECLARE @DealID INT = 0;
    DECLARE @DealStageID INT = 0;
    DECLARE @ConvertedStatusID INT = 0;

    SELECT TOP 1 @DealStageID = DealStageID FROM dbo.CRM_CoreDealStage ORDER BY SortOrder;
    SELECT TOP 1 @ConvertedStatusID = LeadStatusID FROM dbo.CRM_CoreLeadStatus WHERE StatusName = 'Converted';

    INSERT INTO dbo.CRM_CoreAccount
    (AccountName, AccountType, Website, Phone, Email, BillingCity, BillingState, BillingCountry, AnnualRevenue,
     AssignedToEmployeeID, Description, CreatedBy)
    SELECT CompanyName, 'Customer', Website, Phone, Email, City, State, Country, EstimatedValue, AssignedToEmployeeID,
           Description, @ConvertedBy
    FROM dbo.CRM_CoreLead
    WHERE LeadID = @LeadID AND IsDeleted = 0;
    SET @AccountID = SCOPE_IDENTITY();

    INSERT INTO dbo.CRM_CoreContact
    (AccountID, FirstName, LastName, Title, Email, Phone, Mobile, PreferredContactMethod, AssignedToEmployeeID,
     Description, CreatedBy)
    SELECT @AccountID, FirstName, LastName, Title, Email, Phone, Mobile, 'Email', AssignedToEmployeeID,
           Description, @ConvertedBy
    FROM dbo.CRM_CoreLead
    WHERE LeadID = @LeadID AND IsDeleted = 0;
    SET @ContactID = SCOPE_IDENTITY();

    INSERT INTO dbo.CRM_CoreDeal
    (DealName, AccountID, ContactID, LeadID, DealStageID, Amount, Probability, ExpectedCloseDate, AssignedToEmployeeID,
     Description, CreatedBy)
    SELECT @DealName, @AccountID, @ContactID, LeadID, @DealStageID, CASE WHEN ISNUMERIC(@Amount) = 1 THEN CONVERT(DECIMAL(18,2), @Amount) ELSE NULL END,
           20, CASE WHEN ISDATE(@ExpectedCloseDate) = 1 THEN CONVERT(DATE, @ExpectedCloseDate) ELSE NULL END, AssignedToEmployeeID, Description, @ConvertedBy
    FROM dbo.CRM_CoreLead
    WHERE LeadID = @LeadID AND IsDeleted = 0;
    SET @DealID = SCOPE_IDENTITY();

    UPDATE dbo.CRM_CoreLead
    SET LeadStatusID = NULLIF(@ConvertedStatusID, 0), ConvertedAccountID = @AccountID, ConvertedContactID = @ContactID,
        ConvertedDealID = @DealID, UpdatedBy = @ConvertedBy, UpdatedOn = GETDATE()
    WHERE LeadID = @LeadID;

    RETURN @DealID;
END
GO

IF OBJECT_ID('dbo.CRM_Dashboard_Get', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Dashboard_Get AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Dashboard_Get
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        (SELECT COUNT(1) FROM dbo.CRM_CoreLead l LEFT JOIN dbo.CRM_CoreLeadStatus s ON s.LeadStatusID = l.LeadStatusID WHERE l.IsDeleted = 0 AND ISNULL(s.StatusName, '') <> 'Converted') AS OpenLeads,
        (SELECT COUNT(1) FROM dbo.CRM_CoreDeal d INNER JOIN dbo.CRM_CoreDealStage s ON s.DealStageID = d.DealStageID WHERE d.IsDeleted = 0 AND s.IsWon = 1 AND d.UpdatedOn >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) AS WonDeals,
        (SELECT ISNULL(SUM(ISNULL(d.Amount, 0) * ISNULL(NULLIF(d.Probability, 0), ISNULL(s.Probability, 0)) / 100.0), 0) FROM dbo.CRM_CoreDeal d LEFT JOIN dbo.CRM_CoreDealStage s ON s.DealStageID = d.DealStageID WHERE d.IsDeleted = 0 AND ISNULL(s.IsClosed, 0) = 0) AS PipelineValue,
        (SELECT COUNT(1) FROM dbo.CRM_CoreActivity a LEFT JOIN dbo.CRM_CoreActivityStatus s ON s.ActivityStatusID = a.ActivityStatusID WHERE a.IsDeleted = 0 AND ISNULL(s.IsCompleted, 0) = 0 AND (a.DueDate IS NULL OR a.DueDate <= DATEADD(DAY, 7, GETDATE()))) AS DueActivities;

    SELECT s.StageName, COUNT(d.DealID) AS DealCount,
           ISNULL(SUM(ISNULL(d.Amount, 0) * ISNULL(NULLIF(d.Probability, 0), s.Probability) / 100.0), 0) AS WeightedValue
    FROM dbo.CRM_CoreDealStage s
    LEFT JOIN dbo.CRM_CoreDeal d ON d.DealStageID = s.DealStageID AND d.IsDeleted = 0
    WHERE s.IsActive = 1 AND s.IsClosed = 0
    GROUP BY s.SortOrder, s.StageName
    ORDER BY s.SortOrder;

    SELECT TOP 8 a.Subject, COALESCE(CONVERT(NVARCHAR(11), a.DueDate, 106), 'No due date') AS DueText, s.StatusName
    FROM dbo.CRM_CoreActivity a
    LEFT JOIN dbo.CRM_CoreActivityStatus s ON s.ActivityStatusID = a.ActivityStatusID
    WHERE a.IsDeleted = 0 AND ISNULL(s.IsCompleted, 0) = 0
    ORDER BY a.DueDate, a.CreatedOn DESC;

    SELECT TOP 8 l.FirstName + ' ' + l.LastName AS LeadName, l.CompanyName, s.StatusName
    FROM dbo.CRM_CoreLead l
    LEFT JOIN dbo.CRM_CoreLeadStatus s ON s.LeadStatusID = l.LeadStatusID
    WHERE l.IsDeleted = 0
    ORDER BY l.CreatedOn DESC;

    SELECT TOP 10 'Account' AS RecordType, AccountName AS RecordName, Industry AS Subtitle,
           CASE WHEN AssignedToEmployeeID = 0 THEN 'Unassigned' ELSE 'Employee #' + CAST(AssignedToEmployeeID AS NVARCHAR(20)) END AS OwnerName,
           AccountType AS StatusName, ISNULL(UpdatedOn, CreatedOn) AS UpdatedOn
    FROM dbo.CRM_CoreAccount
    WHERE IsDeleted = 0
    ORDER BY ISNULL(UpdatedOn, CreatedOn) DESC;

    SELECT TOP 10 a.Subject, COALESCE(CONVERT(NVARCHAR(11), a.DueDate, 106), 'No due date') AS DueText, s.StatusName, s.StatusColor, a.DueDate
    FROM dbo.CRM_CoreActivity a
    LEFT JOIN dbo.CRM_CoreActivityStatus s ON s.ActivityStatusID = a.ActivityStatusID
    WHERE a.IsDeleted = 0 AND ISNULL(s.IsCompleted, 0) = 0
    ORDER BY a.DueDate, a.CreatedOn DESC;
END
GO

IF OBJECT_ID('dbo.CRM_Report_Get', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Report_Get AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Report_Get
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT s.StageName, COUNT(d.DealID) AS DealCount,
           ISNULL(SUM(ISNULL(d.Amount, 0) * ISNULL(NULLIF(d.Probability, 0), s.Probability) / 100.0), 0) AS WeightedValue
    FROM dbo.CRM_CoreDealStage s
    LEFT JOIN dbo.CRM_CoreDeal d ON d.DealStageID = s.DealStageID AND d.IsDeleted = 0
    WHERE s.IsActive = 1
    GROUP BY s.SortOrder, s.StageName
    ORDER BY s.SortOrder;

    SELECT s.StatusName, COUNT(l.LeadID) AS LeadCount, CAST(COUNT(l.LeadID) AS NVARCHAR(20)) + ' leads' AS ConversionHint
    FROM dbo.CRM_CoreLeadStatus s
    LEFT JOIN dbo.CRM_CoreLead l ON l.LeadStatusID = s.LeadStatusID AND l.IsDeleted = 0
    WHERE s.IsActive = 1
    GROUP BY s.SortOrder, s.StatusName
    ORDER BY s.SortOrder;

    SELECT CASE WHEN OwnerID = 0 THEN 'Unassigned' ELSE 'Employee #' + CAST(OwnerID AS NVARCHAR(20)) END AS OwnerName,
           SUM(OpenLeads) AS OpenLeads, SUM(OpenDeals) AS OpenDeals, SUM(DueActivities) AS DueActivities,
           SUM(OverdueActivities) AS OverdueActivities
    FROM
    (
        SELECT AssignedToEmployeeID AS OwnerID, COUNT(1) AS OpenLeads, 0 AS OpenDeals, 0 AS DueActivities, 0 AS OverdueActivities
        FROM dbo.CRM_CoreLead WHERE IsDeleted = 0 GROUP BY AssignedToEmployeeID
        UNION ALL
        SELECT AssignedToEmployeeID, 0, COUNT(1), 0, 0 FROM dbo.CRM_CoreDeal WHERE IsDeleted = 0 GROUP BY AssignedToEmployeeID
        UNION ALL
        SELECT AssignedToEmployeeID, 0, 0, COUNT(1), SUM(CASE WHEN DueDate < CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END)
        FROM dbo.CRM_CoreActivity WHERE IsDeleted = 0 GROUP BY AssignedToEmployeeID
    ) x
    GROUP BY OwnerID
    ORDER BY OwnerName;
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_DemoSeedLog WHERE SeedName = 'FrappeLikeCRM-Core-2026-07')
BEGIN
    DECLARE @SeedAccountID INT;
    DECLARE @SeedContactID INT;
    DECLARE @SeedLeadID INT;
    DECLARE @SeedDealID INT;
    DECLARE @SeedLeadSourceID INT = (SELECT TOP 1 LeadSourceID FROM dbo.CRM_CoreLeadSource ORDER BY LeadSourceID);
    DECLARE @SeedLeadStatusID INT = (SELECT TOP 1 LeadStatusID FROM dbo.CRM_CoreLeadStatus ORDER BY SortOrder);
    DECLARE @SeedDealStageID INT = (SELECT TOP 1 DealStageID FROM dbo.CRM_CoreDealStage ORDER BY SortOrder);
    DECLARE @SeedActivityTypeID INT = (SELECT TOP 1 ActivityTypeID FROM dbo.CRM_CoreActivityType ORDER BY ActivityTypeID);
    DECLARE @SeedActivityStatusID INT = (SELECT TOP 1 ActivityStatusID FROM dbo.CRM_CoreActivityStatus WHERE IsCompleted = 0 ORDER BY ActivityStatusID);

    INSERT INTO dbo.CRM_CoreAccount
    (AccountName, AccountType, Industry, Website, Phone, Email, BillingCity, BillingState, BillingCountry, AnnualRevenue, Description, CreatedBy)
    VALUES
    ('Nimbus Finserv Pvt Ltd', 'Prospect', 'Financial Services', 'https://nimbus.example.com', '+91 22 4000 1100',
     'hello@nimbus.example.com', 'Mumbai', 'Maharashtra', 'India', 85000000, 'Demo account for CRM pipeline and forecasting.', 0);
    SET @SeedAccountID = SCOPE_IDENTITY();

    INSERT INTO dbo.CRM_CoreContact
    (AccountID, FirstName, LastName, Title, Email, Phone, Mobile, Department, PreferredContactMethod, LastContactedDate, Description, CreatedBy)
    VALUES
    (@SeedAccountID, 'Aditi', 'Mehra', 'Head of Operations', 'aditi.mehra@nimbus.example.com', '+91 22 4000 1101',
     '+91 98765 43210', 'Operations', 'Email', CAST(GETDATE() AS DATE), 'Primary buyer for the demo account.', 0);
    SET @SeedContactID = SCOPE_IDENTITY();

    INSERT INTO dbo.CRM_CoreLead
    (FirstName, LastName, CompanyName, Title, Email, Phone, Mobile, Website, City, State, Country, LeadSourceID,
     LeadStatusID, EstimatedValue, Rating, NextFollowUpDate, Description, CreatedBy)
    VALUES
    ('Rohan', 'Shah', 'Orion Lending', 'Director', 'rohan.shah@orion.example.com', '+91 80 4200 2211',
     '+91 99887 77665', 'https://orion.example.com', 'Bengaluru', 'Karnataka', 'India', @SeedLeadSourceID,
     @SeedLeadStatusID, 1250000, 'Hot', DATEADD(DAY, 1, CAST(GETDATE() AS DATE)), 'Demo hot lead captured from website.', 0);
    SET @SeedLeadID = SCOPE_IDENTITY();

    INSERT INTO dbo.CRM_CoreDeal
    (DealName, AccountID, ContactID, LeadID, DealStageID, Amount, Probability, ExpectedCloseDate, Description, CreatedBy)
    VALUES
    ('Nimbus workflow automation rollout', @SeedAccountID, @SeedContactID, @SeedLeadID, @SeedDealStageID,
     2400000, 45, DATEADD(DAY, 30, CAST(GETDATE() AS DATE)), 'Demo opportunity for Kanban, forecast and email queue.', 0);
    SET @SeedDealID = SCOPE_IDENTITY();

    INSERT INTO dbo.CRM_CoreActivity
    (ActivityTypeID, Subject, RelatedEntity, RelatedRecordID, ActivityStatusID, Priority, DueDate, Description, CreatedBy)
    VALUES
    (@SeedActivityTypeID, 'Demo discovery call', 'Deal', @SeedDealID, @SeedActivityStatusID, 'High',
     DATEADD(DAY, 2, CAST(GETDATE() AS DATE)), 'Review decision process and implementation timeline.', 0);

    INSERT INTO dbo.CRM_DemoSeedLog (SeedName) VALUES ('FrappeLikeCRM-Core-2026-07');
    IF NOT EXISTS (SELECT 1 FROM dbo.CRM_DemoSeedLog WHERE SeedName = 'FrappeLikeCRM-2026-07')
        INSERT INTO dbo.CRM_DemoSeedLog (SeedName) VALUES ('FrappeLikeCRM-2026-07');
END
GO

IF OBJECT_ID('dbo.CRM_Automation_Center_Get', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Automation_Center_Get AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Automation_Center_Get
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.CRM_EmailAccountSetting WHERE IsDefaultOutgoing = 1)
    BEGIN
        SELECT TOP 1 EmailAccountID, AccountName, FromName, FromEmail, ReplyToEmail, SmtpHost, SmtpPort,
               SmtpUserName, SmtpPassword, EnableSSL, IsEnabled, AutoSendEnabled
        FROM dbo.CRM_EmailAccountSetting
        WHERE IsDefaultOutgoing = 1
        ORDER BY EmailAccountID DESC;
    END
    ELSE
    BEGIN
        SELECT 0 AS EmailAccountID, 'Default CRM Outgoing' AS AccountName, 'Infinity CRM' AS FromName,
               'crm@example.com' AS FromEmail, 'sales@example.com' AS ReplyToEmail, '' AS SmtpHost,
               587 AS SmtpPort, '' AS SmtpUserName, '' AS SmtpPassword, CAST(1 AS BIT) AS EnableSSL,
               CAST(0 AS BIT) AS IsEnabled, CAST(0 AS BIT) AS AutoSendEnabled;
    END

    IF EXISTS (SELECT 1 FROM dbo.CRM_NotificationPreference WHERE UserEmployeeID IN (0, @EmployeeID))
    BEGIN
        SELECT TOP 1 PreferenceID, UserEmployeeID, InAppEnabled, EmailEnabled, AssignmentEnabled, MentionEnabled,
               DueActivityEnabled, OverdueSLAEnabled, DailyDigestEnabled, DigestTime
        FROM dbo.CRM_NotificationPreference
        WHERE UserEmployeeID IN (0, @EmployeeID)
        ORDER BY CASE WHEN UserEmployeeID = @EmployeeID THEN 0 ELSE 1 END, PreferenceID DESC;
    END
    ELSE
    BEGIN
        SELECT 0 AS PreferenceID, 0 AS UserEmployeeID, CAST(1 AS BIT) AS InAppEnabled, CAST(1 AS BIT) AS EmailEnabled,
               CAST(1 AS BIT) AS AssignmentEnabled, CAST(1 AS BIT) AS MentionEnabled, CAST(1 AS BIT) AS DueActivityEnabled,
               CAST(1 AS BIT) AS OverdueSLAEnabled, CAST(1 AS BIT) AS DailyDigestEnabled, '09:30' AS DigestTime;
    END

    SELECT TemplateID, TemplateName, TriggerEvent, Subject, BodyHtml, IsEnabled, UpdatedOn
    FROM dbo.CRM_EmailTemplate
    WHERE IsDeleted = 0
    ORDER BY TriggerEvent, TemplateName;

    SELECT RuleID, RuleName, Description, ApplyOn, ConditionField, ConditionOperator, ConditionValue, RoutingMethod,
           UserEmployeeIDs, ActiveDays, Priority, IsEnabled, UpdatedOn
    FROM dbo.CRM_AssignmentRule
    WHERE IsDeleted = 0
    ORDER BY Priority, RuleName;

    SELECT SLAPolicyID, PolicyName, ApplyOn, FirstResponseMinutes, FollowUpMinutes, WorkingHourStart, WorkingHourEnd,
           IsDefault, IsEnabled, ConditionsText, UpdatedOn
    FROM dbo.CRM_SLAPolicy
    WHERE IsDeleted = 0
    ORDER BY ApplyOn, IsDefault DESC, PolicyName;

    SELECT TOP 30 NotificationID, UserEmployeeID, NotificationType, Title, Message, RelatedEntity, RelatedRecordID,
           IsRead, CreatedOn
    FROM dbo.CRM_Notification
    WHERE IsDeleted = 0 AND UserEmployeeID IN (0, @EmployeeID)
    ORDER BY CreatedOn DESC;

    SELECT TOP 30 EmailOutboxID, TemplateID, RelatedEntity, RelatedRecordID, ToEmail, Subject, Status, ScheduledOn,
           SentOn, ErrorMessage, CreatedOn
    FROM dbo.CRM_EmailOutbox
    WHERE IsDeleted = 0
    ORDER BY CreatedOn DESC;

    SELECT
        (SELECT COUNT(1) FROM dbo.CRM_EmailOutbox WHERE IsDeleted = 0 AND Status IN ('Queued', 'Draft')) AS QueuedEmails,
        (SELECT COUNT(1) FROM dbo.CRM_EmailOutbox WHERE IsDeleted = 0 AND Status = 'Failed') AS FailedEmails,
        (SELECT COUNT(1) FROM dbo.CRM_Notification WHERE IsDeleted = 0 AND IsRead = 0 AND UserEmployeeID IN (0, @EmployeeID)) AS UnreadNotifications,
        (SELECT COUNT(1) FROM dbo.CRM_AssignmentRule WHERE IsDeleted = 0 AND IsEnabled = 1) AS ActiveAssignmentRules,
        (SELECT COUNT(1) FROM dbo.CRM_SLAPolicy WHERE IsDeleted = 0 AND IsEnabled = 1) AS ActiveSlaPolicies,
        CASE WHEN EXISTS (SELECT 1 FROM dbo.CRM_EmailAccountSetting WHERE IsEnabled = 1 AND AutoSendEnabled = 1)
             THEN 'Enabled' ELSE 'Needs setup' END AS EmailStatus;
END
GO

IF OBJECT_ID('dbo.CRM_Notification_List', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Notification_List AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Notification_List
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 30 NotificationID, UserEmployeeID, NotificationType, Title, Message, RelatedEntity, RelatedRecordID,
           IsRead, CreatedOn
    FROM dbo.CRM_Notification
    WHERE IsDeleted = 0 AND UserEmployeeID IN (0, @EmployeeID)
    ORDER BY CreatedOn DESC;
END
GO

IF OBJECT_ID('dbo.CRM_Email_Settings_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Email_Settings_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Email_Settings_Save
    @EmailAccountID INT = 0,
    @AccountName NVARCHAR(120),
    @FromName NVARCHAR(120),
    @FromEmail NVARCHAR(200),
    @ReplyToEmail NVARCHAR(200),
    @SmtpHost NVARCHAR(200),
    @SmtpPort INT = 587,
    @SmtpUserName NVARCHAR(200),
    @SmtpPassword NVARCHAR(500),
    @EnableSSL BIT = 1,
    @IsEnabled BIT = 1,
    @AutoSendEnabled BIT = 0,
    @UpdatedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @EmailAccountID > 0 AND EXISTS (SELECT 1 FROM dbo.CRM_EmailAccountSetting WHERE EmailAccountID = @EmailAccountID)
    BEGIN
        UPDATE dbo.CRM_EmailAccountSetting
        SET AccountName = @AccountName,
            FromName = @FromName,
            FromEmail = @FromEmail,
            ReplyToEmail = @ReplyToEmail,
            SmtpHost = @SmtpHost,
            SmtpPort = @SmtpPort,
            SmtpUserName = @SmtpUserName,
            SmtpPassword = CASE WHEN ISNULL(@SmtpPassword, '') = '' THEN SmtpPassword ELSE @SmtpPassword END,
            EnableSSL = @EnableSSL,
            IsEnabled = @IsEnabled,
            AutoSendEnabled = @AutoSendEnabled,
            IsDefaultOutgoing = 1,
            UpdatedBy = @UpdatedBy,
            UpdatedOn = GETDATE()
        WHERE EmailAccountID = @EmailAccountID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.CRM_EmailAccountSetting
        (
            AccountName, FromName, FromEmail, ReplyToEmail, SmtpHost, SmtpPort, SmtpUserName, SmtpPassword,
            EnableSSL, IsEnabled, AutoSendEnabled, IsDefaultOutgoing, CreatedBy
        )
        VALUES
        (
            @AccountName, @FromName, @FromEmail, @ReplyToEmail, @SmtpHost, @SmtpPort, @SmtpUserName, @SmtpPassword,
            @EnableSSL, @IsEnabled, @AutoSendEnabled, 1, @UpdatedBy
        );
        SET @EmailAccountID = SCOPE_IDENTITY();
    END

    RETURN @EmailAccountID;
END
GO

IF OBJECT_ID('dbo.CRM_Notification_Settings_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Notification_Settings_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Notification_Settings_Save
    @PreferenceID INT = 0,
    @UserEmployeeID INT = 0,
    @InAppEnabled BIT = 1,
    @EmailEnabled BIT = 1,
    @AssignmentEnabled BIT = 1,
    @MentionEnabled BIT = 1,
    @DueActivityEnabled BIT = 1,
    @OverdueSLAEnabled BIT = 1,
    @DailyDigestEnabled BIT = 1,
    @DigestTime NVARCHAR(20) = '09:30',
    @UpdatedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @PreferenceID > 0 AND EXISTS (SELECT 1 FROM dbo.CRM_NotificationPreference WHERE PreferenceID = @PreferenceID)
    BEGIN
        UPDATE dbo.CRM_NotificationPreference
        SET UserEmployeeID = @UserEmployeeID,
            InAppEnabled = @InAppEnabled,
            EmailEnabled = @EmailEnabled,
            AssignmentEnabled = @AssignmentEnabled,
            MentionEnabled = @MentionEnabled,
            DueActivityEnabled = @DueActivityEnabled,
            OverdueSLAEnabled = @OverdueSLAEnabled,
            DailyDigestEnabled = @DailyDigestEnabled,
            DigestTime = @DigestTime,
            UpdatedBy = @UpdatedBy,
            UpdatedOn = GETDATE()
        WHERE PreferenceID = @PreferenceID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.CRM_NotificationPreference
        (
            UserEmployeeID, InAppEnabled, EmailEnabled, AssignmentEnabled, MentionEnabled, DueActivityEnabled,
            OverdueSLAEnabled, DailyDigestEnabled, DigestTime, CreatedBy
        )
        VALUES
        (
            @UserEmployeeID, @InAppEnabled, @EmailEnabled, @AssignmentEnabled, @MentionEnabled, @DueActivityEnabled,
            @OverdueSLAEnabled, @DailyDigestEnabled, @DigestTime, @UpdatedBy
        );
        SET @PreferenceID = SCOPE_IDENTITY();
    END

    RETURN @PreferenceID;
END
GO

IF OBJECT_ID('dbo.CRM_Email_Template_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Email_Template_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Email_Template_Save
    @TemplateID INT = 0,
    @TemplateName NVARCHAR(150),
    @TriggerEvent NVARCHAR(80),
    @Subject NVARCHAR(250),
    @BodyHtml NVARCHAR(MAX),
    @IsEnabled BIT = 1,
    @UpdatedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @TemplateID > 0 AND EXISTS (SELECT 1 FROM dbo.CRM_EmailTemplate WHERE TemplateID = @TemplateID)
    BEGIN
        UPDATE dbo.CRM_EmailTemplate
        SET TemplateName = @TemplateName,
            TriggerEvent = @TriggerEvent,
            Subject = @Subject,
            BodyHtml = @BodyHtml,
            IsEnabled = @IsEnabled,
            UpdatedBy = @UpdatedBy,
            UpdatedOn = GETDATE()
        WHERE TemplateID = @TemplateID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.CRM_EmailTemplate (TemplateName, TriggerEvent, Subject, BodyHtml, IsEnabled, CreatedBy)
        VALUES (@TemplateName, @TriggerEvent, @Subject, @BodyHtml, @IsEnabled, @UpdatedBy);
        SET @TemplateID = SCOPE_IDENTITY();
    END

    RETURN @TemplateID;
END
GO

IF OBJECT_ID('dbo.CRM_Assignment_Rule_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Assignment_Rule_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Assignment_Rule_Save
    @RuleID INT = 0,
    @RuleName NVARCHAR(150),
    @Description NVARCHAR(500),
    @ApplyOn NVARCHAR(30),
    @ConditionField NVARCHAR(120),
    @ConditionOperator NVARCHAR(40),
    @ConditionValue NVARCHAR(250),
    @RoutingMethod NVARCHAR(60),
    @UserEmployeeIDs NVARCHAR(500),
    @ActiveDays NVARCHAR(120),
    @Priority INT = 1,
    @IsEnabled BIT = 1,
    @UpdatedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @RuleID > 0 AND EXISTS (SELECT 1 FROM dbo.CRM_AssignmentRule WHERE RuleID = @RuleID)
    BEGIN
        UPDATE dbo.CRM_AssignmentRule
        SET RuleName = @RuleName,
            Description = @Description,
            ApplyOn = @ApplyOn,
            ConditionField = @ConditionField,
            ConditionOperator = @ConditionOperator,
            ConditionValue = @ConditionValue,
            RoutingMethod = @RoutingMethod,
            UserEmployeeIDs = @UserEmployeeIDs,
            ActiveDays = @ActiveDays,
            Priority = @Priority,
            IsEnabled = @IsEnabled,
            UpdatedBy = @UpdatedBy,
            UpdatedOn = GETDATE()
        WHERE RuleID = @RuleID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.CRM_AssignmentRule
        (
            RuleName, Description, ApplyOn, ConditionField, ConditionOperator, ConditionValue, RoutingMethod,
            UserEmployeeIDs, ActiveDays, Priority, IsEnabled, CreatedBy
        )
        VALUES
        (
            @RuleName, @Description, @ApplyOn, @ConditionField, @ConditionOperator, @ConditionValue, @RoutingMethod,
            @UserEmployeeIDs, @ActiveDays, @Priority, @IsEnabled, @UpdatedBy
        );
        SET @RuleID = SCOPE_IDENTITY();
    END

    RETURN @RuleID;
END
GO

IF OBJECT_ID('dbo.CRM_SLA_Policy_Save', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_SLA_Policy_Save AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_SLA_Policy_Save
    @SLAPolicyID INT = 0,
    @PolicyName NVARCHAR(150),
    @ApplyOn NVARCHAR(30),
    @FirstResponseMinutes INT = 60,
    @FollowUpMinutes INT = 1440,
    @WorkingHourStart NVARCHAR(20),
    @WorkingHourEnd NVARCHAR(20),
    @IsDefault BIT = 0,
    @IsEnabled BIT = 1,
    @ConditionsText NVARCHAR(1000),
    @UpdatedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @IsDefault = 1
        UPDATE dbo.CRM_SLAPolicy SET IsDefault = 0 WHERE ApplyOn = @ApplyOn;

    IF @SLAPolicyID > 0 AND EXISTS (SELECT 1 FROM dbo.CRM_SLAPolicy WHERE SLAPolicyID = @SLAPolicyID)
    BEGIN
        UPDATE dbo.CRM_SLAPolicy
        SET PolicyName = @PolicyName,
            ApplyOn = @ApplyOn,
            FirstResponseMinutes = @FirstResponseMinutes,
            FollowUpMinutes = @FollowUpMinutes,
            WorkingHourStart = @WorkingHourStart,
            WorkingHourEnd = @WorkingHourEnd,
            IsDefault = @IsDefault,
            IsEnabled = @IsEnabled,
            ConditionsText = @ConditionsText,
            UpdatedBy = @UpdatedBy,
            UpdatedOn = GETDATE()
        WHERE SLAPolicyID = @SLAPolicyID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.CRM_SLAPolicy
        (
            PolicyName, ApplyOn, FirstResponseMinutes, FollowUpMinutes, WorkingHourStart, WorkingHourEnd,
            IsDefault, IsEnabled, ConditionsText, CreatedBy
        )
        VALUES
        (
            @PolicyName, @ApplyOn, @FirstResponseMinutes, @FollowUpMinutes, @WorkingHourStart, @WorkingHourEnd,
            @IsDefault, @IsEnabled, @ConditionsText, @UpdatedBy
        );
        SET @SLAPolicyID = SCOPE_IDENTITY();
    END

    RETURN @SLAPolicyID;
END
GO

IF OBJECT_ID('dbo.CRM_Automation_Item_Delete', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Automation_Item_Delete AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Automation_Item_Delete
    @Entity NVARCHAR(30),
    @RecordID INT,
    @DeletedBy INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF LOWER(@Entity) = 'emailtemplate'
        UPDATE dbo.CRM_EmailTemplate SET IsDeleted = 1, UpdatedBy = @DeletedBy, UpdatedOn = GETDATE() WHERE TemplateID = @RecordID;
    ELSE IF LOWER(@Entity) = 'assignmentrule'
        UPDATE dbo.CRM_AssignmentRule SET IsDeleted = 1, UpdatedBy = @DeletedBy, UpdatedOn = GETDATE() WHERE RuleID = @RecordID;
    ELSE IF LOWER(@Entity) = 'slapolicy'
        UPDATE dbo.CRM_SLAPolicy SET IsDeleted = 1, UpdatedBy = @DeletedBy, UpdatedOn = GETDATE() WHERE SLAPolicyID = @RecordID;
    ELSE IF LOWER(@Entity) = 'emailoutbox'
        UPDATE dbo.CRM_EmailOutbox SET IsDeleted = 1 WHERE EmailOutboxID = @RecordID;
    ELSE IF LOWER(@Entity) = 'notification'
        UPDATE dbo.CRM_Notification SET IsDeleted = 1 WHERE NotificationID = @RecordID;
    ELSE
        RETURN -2;

    RETURN 1;
END
GO

IF OBJECT_ID('dbo.CRM_Automation_Event_Queue', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Automation_Event_Queue AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Automation_Event_Queue
    @Entity NVARCHAR(30),
    @RecordID INT = 0,
    @EventName NVARCHAR(80),
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EntityName NVARCHAR(30) = LTRIM(RTRIM(ISNULL(@Entity, '')));
    DECLARE @TriggerEvent NVARCHAR(80) = LTRIM(RTRIM(@EntityName + ' ' + ISNULL(@EventName, '')));
    DECLARE @Title NVARCHAR(250) = @TriggerEvent;
    DECLARE @RecordName NVARCHAR(250) = '';
    DECLARE @RecordRef NVARCHAR(300) = '';
    DECLARE @LeadName NVARCHAR(250) = '';
    DECLARE @ActivitySubject NVARCHAR(250) = '';
    DECLARE @Message NVARCHAR(1000);
    DECLARE @TemplateID INT = NULL;
    DECLARE @Subject NVARCHAR(250) = NULL;
    DECLARE @BodyHtml NVARCHAR(MAX) = NULL;
    DECLARE @RenderedSubject NVARCHAR(250) = NULL;
    DECLARE @RenderedBodyHtml NVARCHAR(MAX) = NULL;
    DECLARE @ToEmail NVARCHAR(500) = NULL;
    DECLARE @Status NVARCHAR(40) = 'Draft';

    IF LOWER(@EntityName) = 'lead'
    BEGIN
        SELECT TOP 1
            @LeadName = LTRIM(RTRIM(ISNULL(FirstName, '') + ' ' + ISNULL(LastName, ''))),
            @RecordName = LTRIM(RTRIM(ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')))
        FROM dbo.CRM_CoreLead
        WHERE LeadID = @RecordID;
    END
    ELSE IF LOWER(@EntityName) = 'deal'
    BEGIN
        SELECT TOP 1 @RecordName = DealName
        FROM dbo.CRM_CoreDeal
        WHERE DealID = @RecordID;
    END
    ELSE IF LOWER(@EntityName) = 'account'
    BEGIN
        SELECT TOP 1 @RecordName = AccountName
        FROM dbo.CRM_CoreAccount
        WHERE AccountID = @RecordID;
    END
    ELSE IF LOWER(@EntityName) = 'contact'
    BEGIN
        SELECT TOP 1 @RecordName = LTRIM(RTRIM(ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')))
        FROM dbo.CRM_CoreContact
        WHERE ContactID = @RecordID;
    END
    ELSE IF LOWER(@EntityName) = 'activity'
    BEGIN
        SELECT TOP 1
            @ActivitySubject = Subject,
            @RecordName = Subject
        FROM dbo.CRM_CoreActivity
        WHERE ActivityID = @RecordID;
    END

    SET @RecordName = LTRIM(RTRIM(ISNULL(@RecordName, '')));
    SET @LeadName = LTRIM(RTRIM(ISNULL(NULLIF(@LeadName, ''), @RecordName)));
    SET @ActivitySubject = LTRIM(RTRIM(ISNULL(NULLIF(@ActivitySubject, ''), @RecordName)));

    IF @EntityName <> '' AND @RecordName <> ''
        SET @RecordRef = @EntityName + ' - ' + @RecordName;
    ELSE IF @RecordName <> ''
        SET @RecordRef = @RecordName;
    ELSE
        SET @RecordRef = ISNULL(NULLIF(@EntityName, ''), 'CRM') + ' #' + CAST(ISNULL(@RecordID, 0) AS NVARCHAR(20));

    SET @Message = 'CRM automation created this alert for ' + @RecordRef + '.';

    IF EXISTS (SELECT 1 FROM dbo.CRM_NotificationPreference WHERE UserEmployeeID IN (0, @EmployeeID) AND InAppEnabled = 1)
    BEGIN
        INSERT INTO dbo.CRM_Notification
        (
            UserEmployeeID, NotificationType, Title, Message, RelatedEntity, RelatedRecordID, CreatedBy
        )
        VALUES
        (
            @EmployeeID, @TriggerEvent, @Title, @Message, @EntityName, @RecordID, @EmployeeID
        );
    END

    SELECT TOP 1
        @TemplateID = TemplateID,
        @Subject = Subject,
        @BodyHtml = BodyHtml
    FROM dbo.CRM_EmailTemplate
    WHERE IsDeleted = 0 AND IsEnabled = 1 AND TriggerEvent IN (@TriggerEvent, @EventName)
    ORDER BY TemplateID DESC;

    SELECT TOP 1
        @ToEmail = COALESCE(NULLIF(ReplyToEmail, ''), NULLIF(FromEmail, ''), 'sales@example.com'),
        @Status = CASE WHEN AutoSendEnabled = 1 AND IsEnabled = 1 THEN 'Queued' ELSE 'Draft' END
    FROM dbo.CRM_EmailAccountSetting
    WHERE IsDefaultOutgoing = 1
    ORDER BY EmailAccountID DESC;

    IF @TemplateID IS NOT NULL
    BEGIN
        SET @RenderedSubject = ISNULL(@Subject, '');
        SET @RenderedSubject = REPLACE(@RenderedSubject, '{{Entity}}', ISNULL(NULLIF(@EntityName, ''), 'CRM'));
        SET @RenderedSubject = REPLACE(@RenderedSubject, '{{RecordID}}', CAST(ISNULL(@RecordID, 0) AS NVARCHAR(20)));
        SET @RenderedSubject = REPLACE(@RenderedSubject, '{{RecordRef}}', @RecordRef);
        SET @RenderedSubject = REPLACE(@RenderedSubject, '{{RecordName}}', @RecordName);
        SET @RenderedSubject = REPLACE(@RenderedSubject, '{{LeadName}}', @LeadName);
        SET @RenderedSubject = REPLACE(@RenderedSubject, '{{Subject}}', @ActivitySubject);
        SET @RenderedSubject = REPLACE(@RenderedSubject, '{{Title}}', @Title);
        SET @RenderedSubject = REPLACE(@RenderedSubject, '{{Message}}', @Message);

        SET @RenderedBodyHtml = ISNULL(@BodyHtml, '');
        SET @RenderedBodyHtml = REPLACE(@RenderedBodyHtml, '{{Entity}}', ISNULL(NULLIF(@EntityName, ''), 'CRM'));
        SET @RenderedBodyHtml = REPLACE(@RenderedBodyHtml, '{{RecordID}}', CAST(ISNULL(@RecordID, 0) AS NVARCHAR(20)));
        SET @RenderedBodyHtml = REPLACE(@RenderedBodyHtml, '{{RecordRef}}', @RecordRef);
        SET @RenderedBodyHtml = REPLACE(@RenderedBodyHtml, '{{RecordName}}', @RecordName);
        SET @RenderedBodyHtml = REPLACE(@RenderedBodyHtml, '{{LeadName}}', @LeadName);
        SET @RenderedBodyHtml = REPLACE(@RenderedBodyHtml, '{{Subject}}', @ActivitySubject);
        SET @RenderedBodyHtml = REPLACE(@RenderedBodyHtml, '{{Title}}', @Title);
        SET @RenderedBodyHtml = REPLACE(@RenderedBodyHtml, '{{Message}}', @Message);

        INSERT INTO dbo.CRM_EmailOutbox
        (
            TemplateID, RelatedEntity, RelatedRecordID, ToEmail, Subject, BodyHtml, Status, CreatedBy
        )
        VALUES
        (
            @TemplateID, @EntityName, @RecordID, @ToEmail, @RenderedSubject, @RenderedBodyHtml,
            @Status, @EmployeeID
        );
    END

    INSERT INTO dbo.CRM_AutomationLog (EventName, RelatedEntity, RelatedRecordID, ResultMessage, CreatedBy)
    VALUES (@TriggerEvent, @Entity, @RecordID, 'Queued notification and matching email template when available.', @EmployeeID);

    RETURN 1;
END
GO

IF OBJECT_ID('dbo.CRM_Notification_MarkRead', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Notification_MarkRead AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Notification_MarkRead
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.CRM_Notification
    SET IsRead = 1,
        ReadOn = GETDATE()
    WHERE IsDeleted = 0 AND UserEmployeeID IN (0, @EmployeeID);

    RETURN 1;
END
GO

IF OBJECT_ID('dbo.CRM_Automation_RunDueJobs', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_Automation_RunDueJobs AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_Automation_RunDueJobs
    @EmployeeID INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ActivityNotifications INT;
    DECLARE @SlaNotifications INT;
    DECLARE @DigestNotifications INT;
    DECLARE @AssignmentUpdates INT;
    DECLARE @QueuedEmails INT;
    DECLARE @EmailStatus NVARCHAR(40);
    DECLARE @DefaultToEmail NVARCHAR(500);
    DECLARE @ActivityTemplateID INT;
    DECLARE @SlaTemplateID INT;
    DECLARE @DigestTemplateID INT;
    DECLARE @LeadAssignOwnerID INT;
    DECLARE @DealAssignOwnerID INT;

    SET @ActivityNotifications = 0;
    SET @SlaNotifications = 0;
    SET @DigestNotifications = 0;
    SET @AssignmentUpdates = 0;
    SET @QueuedEmails = 0;
    SET @EmailStatus = 'Draft';

    SELECT TOP 1
        @DefaultToEmail = COALESCE(NULLIF(ReplyToEmail, ''), NULLIF(FromEmail, ''), 'sales@example.com'),
        @EmailStatus = CASE WHEN IsEnabled = 1 AND AutoSendEnabled = 1 THEN 'Queued' ELSE 'Draft' END
    FROM dbo.CRM_EmailAccountSetting
    WHERE IsDefaultOutgoing = 1
    ORDER BY EmailAccountID DESC;

    SELECT TOP 1 @ActivityTemplateID = TemplateID
    FROM dbo.CRM_EmailTemplate
    WHERE IsDeleted = 0 AND IsEnabled = 1 AND TriggerEvent = 'Activity Due'
    ORDER BY TemplateID DESC;

    SELECT TOP 1 @SlaTemplateID = TemplateID
    FROM dbo.CRM_EmailTemplate
    WHERE IsDeleted = 0 AND IsEnabled = 1 AND TriggerEvent = 'SLA Breach'
    ORDER BY TemplateID DESC;

    SELECT TOP 1 @DigestTemplateID = TemplateID
    FROM dbo.CRM_EmailTemplate
    WHERE IsDeleted = 0 AND IsEnabled = 1 AND TriggerEvent = 'Daily Digest'
    ORDER BY TemplateID DESC;

    SELECT TOP 1 @LeadAssignOwnerID =
        CASE
            WHEN ISNUMERIC(LEFT(UserEmployeeIDs + ',', CHARINDEX(',', UserEmployeeIDs + ',') - 1)) = 1
            THEN CONVERT(INT, LEFT(UserEmployeeIDs + ',', CHARINDEX(',', UserEmployeeIDs + ',') - 1))
            ELSE 0
        END
    FROM dbo.CRM_AssignmentRule
    WHERE IsDeleted = 0 AND IsEnabled = 1 AND ApplyOn = 'Lead' AND ISNULL(UserEmployeeIDs, '') <> ''
    ORDER BY Priority, RuleID;

    IF ISNULL(@LeadAssignOwnerID, 0) > 0
    BEGIN
        UPDATE dbo.CRM_CoreLead
        SET AssignedToEmployeeID = @LeadAssignOwnerID,
            UpdatedBy = @EmployeeID,
            UpdatedOn = GETDATE()
        WHERE IsDeleted = 0 AND AssignedToEmployeeID = 0;
        SET @AssignmentUpdates = @AssignmentUpdates + @@ROWCOUNT;
    END

    SELECT TOP 1 @DealAssignOwnerID =
        CASE
            WHEN ISNUMERIC(LEFT(UserEmployeeIDs + ',', CHARINDEX(',', UserEmployeeIDs + ',') - 1)) = 1
            THEN CONVERT(INT, LEFT(UserEmployeeIDs + ',', CHARINDEX(',', UserEmployeeIDs + ',') - 1))
            ELSE 0
        END
    FROM dbo.CRM_AssignmentRule
    WHERE IsDeleted = 0 AND IsEnabled = 1 AND ApplyOn = 'Deal' AND ISNULL(UserEmployeeIDs, '') <> ''
    ORDER BY Priority, RuleID;

    IF ISNULL(@DealAssignOwnerID, 0) > 0
    BEGIN
        UPDATE dbo.CRM_CoreDeal
        SET AssignedToEmployeeID = @DealAssignOwnerID,
            UpdatedBy = @EmployeeID,
            UpdatedOn = GETDATE()
        WHERE IsDeleted = 0 AND AssignedToEmployeeID = 0;
        SET @AssignmentUpdates = @AssignmentUpdates + @@ROWCOUNT;
    END

    INSERT INTO dbo.CRM_Notification
    (
        UserEmployeeID, NotificationType, Title, Message, RelatedEntity, RelatedRecordID, CreatedBy
    )
    SELECT
        ISNULL(a.AssignedToEmployeeID, 0),
        'Activity Due',
        'Activity due: ' + a.Subject,
        'Activity is due on ' + COALESCE(CONVERT(NVARCHAR(11), a.DueDate, 106), 'today') + '.',
        'Activity',
        a.ActivityID,
        @EmployeeID
    FROM dbo.CRM_CoreActivity a
    LEFT JOIN dbo.CRM_CoreActivityStatus s ON s.ActivityStatusID = a.ActivityStatusID
    WHERE a.IsDeleted = 0
      AND ISNULL(s.IsCompleted, 0) = 0
      AND a.DueDate IS NOT NULL
      AND a.DueDate <= CAST(GETDATE() AS DATE)
      AND NOT EXISTS
      (
          SELECT 1
          FROM dbo.CRM_Notification n
          WHERE n.IsDeleted = 0
            AND n.NotificationType = 'Activity Due'
            AND n.RelatedEntity = 'Activity'
            AND n.RelatedRecordID = a.ActivityID
            AND DATEDIFF(DAY, n.CreatedOn, GETDATE()) = 0
      );
    SET @ActivityNotifications = @@ROWCOUNT;

    IF @ActivityTemplateID IS NOT NULL
    BEGIN
        INSERT INTO dbo.CRM_EmailOutbox
        (
            TemplateID, RelatedEntity, RelatedRecordID, ToEmail, Subject, BodyHtml, Status, CreatedBy
        )
        SELECT
            @ActivityTemplateID,
            'Activity',
            a.ActivityID,
            @DefaultToEmail,
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(t.Subject, '{{Subject}}', a.Subject), '{{Title}}', 'Activity due: ' + a.Subject), '{{Entity}}', 'Activity'), '{{RecordID}}', CAST(a.ActivityID AS NVARCHAR(20))), '{{RecordRef}}', 'Activity - ' + a.Subject),
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(t.BodyHtml, ''), '{{Subject}}', a.Subject), '{{Title}}', 'Activity due: ' + a.Subject), '{{Message}}', 'Activity is due on ' + COALESCE(CONVERT(NVARCHAR(11), a.DueDate, 106), 'today') + '.'), '{{Entity}}', 'Activity'), '{{RecordID}}', CAST(a.ActivityID AS NVARCHAR(20))), '{{RecordRef}}', 'Activity - ' + a.Subject),
            @EmailStatus,
            @EmployeeID
        FROM dbo.CRM_CoreActivity a
        INNER JOIN dbo.CRM_EmailTemplate t ON t.TemplateID = @ActivityTemplateID
        LEFT JOIN dbo.CRM_CoreActivityStatus s ON s.ActivityStatusID = a.ActivityStatusID
        WHERE a.IsDeleted = 0
          AND ISNULL(s.IsCompleted, 0) = 0
          AND a.DueDate IS NOT NULL
          AND a.DueDate <= CAST(GETDATE() AS DATE)
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.CRM_EmailOutbox o
              WHERE o.IsDeleted = 0
                AND o.TemplateID = @ActivityTemplateID
                AND o.RelatedEntity = 'Activity'
                AND o.RelatedRecordID = a.ActivityID
                AND DATEDIFF(DAY, o.CreatedOn, GETDATE()) = 0
          );
        SET @QueuedEmails = @QueuedEmails + @@ROWCOUNT;
    END

    INSERT INTO dbo.CRM_Notification
    (
        UserEmployeeID, NotificationType, Title, Message, RelatedEntity, RelatedRecordID, CreatedBy
    )
    SELECT
        ISNULL(l.AssignedToEmployeeID, 0),
        'SLA Breach',
        'Lead SLA attention required',
        'Lead ' + l.FirstName + ' ' + l.LastName + ' has crossed the configured response SLA.',
        'Lead',
        l.LeadID,
        @EmployeeID
    FROM dbo.CRM_CoreLead l
    CROSS APPLY
    (
        SELECT TOP 1 FirstResponseMinutes
        FROM dbo.CRM_SLAPolicy
        WHERE IsDeleted = 0 AND IsEnabled = 1 AND ApplyOn = 'Lead'
        ORDER BY IsDefault DESC, SLAPolicyID
    ) p
    LEFT JOIN dbo.CRM_CoreLeadStatus s ON s.LeadStatusID = l.LeadStatusID
    WHERE l.IsDeleted = 0
      AND ISNULL(s.StatusName, '') NOT IN ('Converted', 'Lost')
      AND DATEDIFF(MINUTE, l.CreatedOn, GETDATE()) >= p.FirstResponseMinutes
      AND NOT EXISTS
      (
          SELECT 1 FROM dbo.CRM_Notification n
          WHERE n.IsDeleted = 0
            AND n.NotificationType = 'SLA Breach'
            AND n.RelatedEntity = 'Lead'
            AND n.RelatedRecordID = l.LeadID
            AND DATEDIFF(DAY, n.CreatedOn, GETDATE()) = 0
      );
    SET @SlaNotifications = @@ROWCOUNT;

    INSERT INTO dbo.CRM_Notification
    (
        UserEmployeeID, NotificationType, Title, Message, RelatedEntity, RelatedRecordID, CreatedBy
    )
    SELECT
        ISNULL(d.AssignedToEmployeeID, 0),
        'SLA Breach',
        'Deal SLA attention required',
        'Deal ' + d.DealName + ' has crossed the configured follow-up SLA.',
        'Deal',
        d.DealID,
        @EmployeeID
    FROM dbo.CRM_CoreDeal d
    CROSS APPLY
    (
        SELECT TOP 1 FollowUpMinutes
        FROM dbo.CRM_SLAPolicy
        WHERE IsDeleted = 0 AND IsEnabled = 1 AND ApplyOn = 'Deal'
        ORDER BY IsDefault DESC, SLAPolicyID
    ) p
    LEFT JOIN dbo.CRM_CoreDealStage s ON s.DealStageID = d.DealStageID
    WHERE d.IsDeleted = 0
      AND ISNULL(s.IsClosed, 0) = 0
      AND DATEDIFF(MINUTE, d.CreatedOn, GETDATE()) >= p.FollowUpMinutes
      AND NOT EXISTS
      (
          SELECT 1 FROM dbo.CRM_Notification n
          WHERE n.IsDeleted = 0
            AND n.NotificationType = 'SLA Breach'
            AND n.RelatedEntity = 'Deal'
            AND n.RelatedRecordID = d.DealID
            AND DATEDIFF(DAY, n.CreatedOn, GETDATE()) = 0
      );
    SET @SlaNotifications = @SlaNotifications + @@ROWCOUNT;

    IF @SlaTemplateID IS NOT NULL
    BEGIN
        INSERT INTO dbo.CRM_EmailOutbox
        (
            TemplateID, RelatedEntity, RelatedRecordID, ToEmail, Subject, BodyHtml, Status, CreatedBy
        )
        SELECT
            @SlaTemplateID,
            n.RelatedEntity,
            n.RelatedRecordID,
            @DefaultToEmail,
            CASE
                WHEN ISNULL(t.Subject, '') IN ('', 'CRM SLA attention required') THEN n.Title
                ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(t.Subject, '{{Title}}', n.Title), '{{Message}}', n.Message), '{{Entity}}', n.RelatedEntity), '{{RecordID}}', CAST(n.RelatedRecordID AS NVARCHAR(20))), '{{RecordRef}}', n.RelatedEntity + ' #' + CAST(n.RelatedRecordID AS NVARCHAR(20)))
            END,
            CASE
                WHEN ISNULL(t.BodyHtml, '') IN ('', 'A CRM item has crossed the response target. Please review {{Entity}} #{{RecordID}}.') THEN n.Message
                ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(t.BodyHtml, ''), '{{Title}}', n.Title), '{{Message}}', n.Message), '{{Entity}}', n.RelatedEntity), '{{RecordID}}', CAST(n.RelatedRecordID AS NVARCHAR(20))), '{{RecordRef}}', n.RelatedEntity + ' #' + CAST(n.RelatedRecordID AS NVARCHAR(20)))
            END,
            @EmailStatus,
            @EmployeeID
        FROM dbo.CRM_Notification n
        INNER JOIN dbo.CRM_EmailTemplate t ON t.TemplateID = @SlaTemplateID
        WHERE n.NotificationType = 'SLA Breach'
          AND DATEDIFF(DAY, n.CreatedOn, GETDATE()) = 0
          AND NOT EXISTS
          (
              SELECT 1 FROM dbo.CRM_EmailOutbox o
              WHERE o.IsDeleted = 0
                AND o.TemplateID = @SlaTemplateID
                AND o.RelatedEntity = n.RelatedEntity
                AND o.RelatedRecordID = n.RelatedRecordID
                AND DATEDIFF(DAY, o.CreatedOn, GETDATE()) = 0
          );
        SET @QueuedEmails = @QueuedEmails + @@ROWCOUNT;
    END

    IF EXISTS
    (
        SELECT 1
        FROM dbo.CRM_NotificationPreference
        WHERE UserEmployeeID IN (0, @EmployeeID)
          AND DailyDigestEnabled = 1
          AND (ISNULL(DigestTime, '') = '' OR CONVERT(CHAR(5), GETDATE(), 108) >= LEFT(DigestTime, 5))
    )
    AND NOT EXISTS
    (
        SELECT 1
        FROM dbo.CRM_Notification
        WHERE IsDeleted = 0
          AND NotificationType = 'Daily Digest'
          AND DATEDIFF(DAY, CreatedOn, GETDATE()) = 0
    )
    BEGIN
        INSERT INTO dbo.CRM_Notification
        (
            UserEmployeeID, NotificationType, Title, Message, RelatedEntity, RelatedRecordID, CreatedBy
        )
        VALUES
        (
            @EmployeeID, 'Daily Digest', 'CRM daily digest ready',
            'CRM digest generated for leads, activities and pipeline follow-ups.', 'Digest', 0, @EmployeeID
        );
        SET @DigestNotifications = 1;

        IF @DigestTemplateID IS NOT NULL
        BEGIN
            INSERT INTO dbo.CRM_EmailOutbox
            (
                TemplateID, RelatedEntity, RelatedRecordID, ToEmail, Subject, BodyHtml, Status, CreatedBy
            )
            SELECT
                @DigestTemplateID,
                'Digest',
                0,
                @DefaultToEmail,
                t.Subject,
                ISNULL(t.BodyHtml, '') +
                    '<br/><br/>Open leads: ' + CAST((SELECT COUNT(1) FROM dbo.CRM_CoreLead WHERE IsDeleted = 0) AS NVARCHAR(20)) +
                    '<br/>Due activities: ' + CAST((SELECT COUNT(1) FROM dbo.CRM_CoreActivity WHERE IsDeleted = 0 AND DueDate <= CAST(GETDATE() AS DATE)) AS NVARCHAR(20)) +
                    '<br/>Open deals: ' + CAST((SELECT COUNT(1) FROM dbo.CRM_CoreDeal d LEFT JOIN dbo.CRM_CoreDealStage s ON s.DealStageID = d.DealStageID WHERE d.IsDeleted = 0 AND ISNULL(s.IsClosed, 0) = 0) AS NVARCHAR(20)),
                @EmailStatus,
                @EmployeeID
            FROM dbo.CRM_EmailTemplate t
            WHERE t.TemplateID = @DigestTemplateID;
            SET @QueuedEmails = @QueuedEmails + @@ROWCOUNT;
        END
    END

    SELECT
        @AssignmentUpdates AS AssignmentUpdates,
        @ActivityNotifications AS ActivityNotifications,
        @SlaNotifications AS SlaNotifications,
        @DigestNotifications AS DigestNotifications,
        @QueuedEmails AS QueuedEmails,
        @EmailStatus AS EmailStatus;

    RETURN 1;
END
GO

IF OBJECT_ID('dbo.CRM_EmailOutbox_DispatchBatch_Get', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_EmailOutbox_DispatchBatch_Get AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_EmailOutbox_DispatchBatch_Get
    @BatchSize INT = 25
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 EmailAccountID, AccountName, FromName, FromEmail, ReplyToEmail, SmtpHost, SmtpPort,
           SmtpUserName, SmtpPassword, EnableSSL, IsEnabled, AutoSendEnabled
    FROM dbo.CRM_EmailAccountSetting
    WHERE IsDefaultOutgoing = 1 AND IsEnabled = 1 AND AutoSendEnabled = 1
    ORDER BY EmailAccountID DESC;

    SELECT TOP (@BatchSize) EmailOutboxID, TemplateID, RelatedEntity, RelatedRecordID, ToEmail, CcEmail, BccEmail,
           Subject, BodyHtml, Status, ScheduledOn, CreatedOn
    FROM dbo.CRM_EmailOutbox
    WHERE IsDeleted = 0
      AND Status = 'Queued'
      AND ScheduledOn <= GETDATE()
    ORDER BY ScheduledOn, EmailOutboxID;
END
GO

IF OBJECT_ID('dbo.CRM_EmailOutbox_Status_Update', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.CRM_EmailOutbox_Status_Update AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.CRM_EmailOutbox_Status_Update
    @EmailOutboxID INT,
    @Status NVARCHAR(40),
    @ErrorMessage NVARCHAR(1000) = ''
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.CRM_EmailOutbox
    SET Status = @Status,
        SentOn = CASE WHEN @Status = 'Sent' THEN GETDATE() ELSE SentOn END,
        ErrorMessage = CASE WHEN @Status = 'Failed' THEN @ErrorMessage ELSE '' END
    WHERE EmailOutboxID = @EmailOutboxID;

    RETURN 1;
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_EmailAccountSetting WHERE AccountName = 'Demo CRM Outgoing')
BEGIN
    INSERT INTO dbo.CRM_EmailAccountSetting
    (
        AccountName, FromName, FromEmail, ReplyToEmail, SmtpHost, SmtpPort, SmtpUserName, SmtpPassword,
        EnableSSL, IsDefaultOutgoing, IsEnabled, AutoSendEnabled, CreatedBy
    )
    VALUES
    (
        'Demo CRM Outgoing', 'Infinity CRM', 'crm@example.com', 'sales@example.com', 'smtp.example.com', 587,
        'crm@example.com', '', 1, 1, 1, 0, 0
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_NotificationPreference WHERE UserEmployeeID = 0)
BEGIN
    INSERT INTO dbo.CRM_NotificationPreference
    (
        UserEmployeeID, InAppEnabled, EmailEnabled, AssignmentEnabled, MentionEnabled, DueActivityEnabled,
        OverdueSLAEnabled, DailyDigestEnabled, DigestTime, CreatedBy
    )
    VALUES (0, 1, 1, 1, 1, 1, 1, 1, '09:30', 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_EmailTemplate WHERE TemplateName = 'Lead welcome demo')
BEGIN
    INSERT INTO dbo.CRM_EmailTemplate (TemplateName, TriggerEvent, Subject, BodyHtml, IsEnabled, CreatedBy)
    VALUES
    ('Lead welcome demo', 'Lead Saved', 'Thanks for your interest in Infinity', 'Hi {{LeadName}},<br><br>Thank you for contacting us. We will connect shortly.<br><br>CRM Ref: {{RecordRef}}', 1, 0),
    ('Deal update demo', 'Deal Saved', 'Opportunity update from Infinity CRM', 'Hello,<br><br>Your opportunity has been updated in CRM. Ref: {{RecordRef}}', 1, 0),
    ('SLA reminder demo', 'SLA Breach', '{{Title}}', '{{Message}}', 1, 0);
END
GO

UPDATE dbo.CRM_EmailTemplate
SET BodyHtml = REPLACE(BodyHtml, 'CRM Ref: {{RecordID}}', 'CRM Ref: {{RecordRef}}')
WHERE TemplateName = 'Lead welcome demo'
  AND BodyHtml LIKE '%CRM Ref: {{RecordID}}%';
GO

UPDATE dbo.CRM_EmailTemplate
SET BodyHtml = REPLACE(BodyHtml, 'Ref: {{RecordID}}', 'Ref: {{RecordRef}}')
WHERE TemplateName = 'Deal update demo'
  AND BodyHtml LIKE '%Ref: {{RecordID}}%';
GO

UPDATE dbo.CRM_EmailTemplate
SET Subject = '{{Title}}',
    BodyHtml = '{{Message}}'
WHERE TemplateName = 'SLA reminder demo'
  AND Subject = 'CRM SLA attention required'
  AND BodyHtml = 'A CRM item has crossed the response target. Please review {{Entity}} #{{RecordID}}.';
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_EmailTemplate WHERE TemplateName = 'Activity due demo')
BEGIN
    INSERT INTO dbo.CRM_EmailTemplate (TemplateName, TriggerEvent, Subject, BodyHtml, IsEnabled, CreatedBy)
    VALUES ('Activity due demo', 'Activity Due', 'CRM activity due: {{Subject}}', 'Activity {{Subject}} is due for {{RecordRef}}. Please review it in CRM.', 1, 0);
END
GO

UPDATE dbo.CRM_EmailTemplate
SET BodyHtml = REPLACE(BodyHtml, '{{Entity}} #{{RecordID}}', '{{RecordRef}}')
WHERE TemplateName = 'Activity due demo'
  AND BodyHtml LIKE '%{{Entity}} #{{RecordID}}%';
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_EmailTemplate WHERE TemplateName = 'Daily digest demo')
BEGIN
    INSERT INTO dbo.CRM_EmailTemplate (TemplateName, TriggerEvent, Subject, BodyHtml, IsEnabled, CreatedBy)
    VALUES ('Daily digest demo', 'Daily Digest', 'CRM daily digest', 'Today CRM has {{LeadCount}} open leads, {{DealCount}} open deals, and {{ActivityCount}} due activities.', 1, 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_AssignmentRule WHERE RuleName = 'Demo hot lead rotation')
BEGIN
    INSERT INTO dbo.CRM_AssignmentRule
    (
        RuleName, Description, ApplyOn, ConditionField, ConditionOperator, ConditionValue, RoutingMethod,
        UserEmployeeIDs, ActiveDays, Priority, IsEnabled, CreatedBy
    )
    VALUES
    ('Demo hot lead rotation', 'Assign high intent leads evenly to the sales queue.', 'Lead', 'Rating', 'equals', 'Hot', 'Auto-rotate', '0', 'Mon,Tue,Wed,Thu,Fri', 1, 1, 0),
    ('Demo enterprise deal workload', 'Assign large deals to the owner with lowest open workload.', 'Deal', 'Amount', 'greater than', '1000000', 'Least workload', '0', 'Mon,Tue,Wed,Thu,Fri', 2, 1, 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_SLAPolicy WHERE PolicyName = 'Demo lead response SLA')
BEGIN
    INSERT INTO dbo.CRM_SLAPolicy
    (
        PolicyName, ApplyOn, FirstResponseMinutes, FollowUpMinutes, WorkingHourStart, WorkingHourEnd,
        IsDefault, IsEnabled, ConditionsText, CreatedBy
    )
    VALUES
    ('Demo lead response SLA', 'Lead', 60, 1440, '09:30', '18:30', 1, 1, 'Default SLA for new leads.', 0),
    ('Demo deal response SLA', 'Deal', 120, 2880, '09:30', '18:30', 1, 1, 'Default SLA for open deals.', 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_Notification WHERE Title = 'Demo CRM automation is ready')
BEGIN
    INSERT INTO dbo.CRM_Notification
    (
        UserEmployeeID, NotificationType, Title, Message, RelatedEntity, RelatedRecordID, CreatedBy
    )
    VALUES
    (0, 'System', 'Demo CRM automation is ready', 'Email settings, notifications, assignment rules and SLA policies have been seeded.', 'Settings', 0, 0),
    (0, 'Assignment', 'Hot lead assigned', 'Demo assignment rule routed a hot lead to the sales queue.', 'Lead', 1, 0),
    (0, 'SLA', 'Follow-up due soon', 'Demo SLA policy expects a response within the configured window.', 'Deal', 1, 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_EmailOutbox WHERE Subject = 'Demo queued CRM email')
BEGIN
    INSERT INTO dbo.CRM_EmailOutbox
    (
        TemplateID, RelatedEntity, RelatedRecordID, ToEmail, Subject, BodyHtml, Status, CreatedBy
    )
    SELECT TOP 1 TemplateID, 'Lead', 1, 'buyer@example.com', 'Demo queued CRM email',
           'This is a demo CRM email queued from automation settings.', 'Draft', 0
    FROM dbo.CRM_EmailTemplate
    WHERE TemplateName = 'Lead welcome demo';
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CRM_DemoSeedLog WHERE SeedName = 'FrappeLikeCRM-2026-07')
BEGIN
    DECLARE @AccountID INT = 0;
    DECLARE @ContactID INT = 0;
    DECLARE @LeadID INT = 0;
    DECLARE @DealID INT = 0;
    DECLARE @DemoNextFollowUpDate NVARCHAR(10) = CONVERT(NVARCHAR(10), DATEADD(DAY, 1, GETDATE()), 120);
    DECLARE @DemoExpectedCloseDate NVARCHAR(10) = CONVERT(NVARCHAR(10), DATEADD(DAY, 30, GETDATE()), 120);
    DECLARE @DemoActivityDueDate NVARCHAR(10) = CONVERT(NVARCHAR(10), DATEADD(DAY, 2, GETDATE()), 120);

    INSERT INTO dbo.CRM_DemoSeedLog (SeedName) VALUES ('FrappeLikeCRM-2026-07');

    IF OBJECT_ID('dbo.CRM_Account_Save', 'P') IS NOT NULL
    BEGIN
        EXEC @AccountID = dbo.CRM_Account_Save
            @AccountID = 0,
            @AccountName = 'Nimbus Finserv Pvt Ltd',
            @AccountType = 'Prospect',
            @Industry = 'Financial Services',
            @Website = 'https://nimbus.example.com',
            @Phone = '+91 22 4000 1100',
            @Email = 'hello@nimbus.example.com',
            @BillingCity = 'Mumbai',
            @BillingState = 'Maharashtra',
            @BillingCountry = 'India',
            @AnnualRevenue = '85000000',
            @AssignedToEmployeeID = 0,
            @Description = 'Demo account for CRM pipeline and forecasting.',
            @AddedBy = 0;
    END

    IF OBJECT_ID('dbo.CRM_Contact_Save', 'P') IS NOT NULL
    BEGIN
        EXEC @ContactID = dbo.CRM_Contact_Save
            @ContactID = 0,
            @AccountID = @AccountID,
            @FirstName = 'Aditi',
            @LastName = 'Mehra',
            @Title = 'Head of Operations',
            @Email = 'aditi.mehra@nimbus.example.com',
            @Phone = '+91 22 4000 1101',
            @Mobile = '+91 98765 43210',
            @Department = 'Operations',
            @PreferredContactMethod = 'Email',
            @LastContactedDate = '',
            @AssignedToEmployeeID = 0,
            @Description = 'Primary buyer for the demo account.',
            @AddedBy = 0;
    END

    IF OBJECT_ID('dbo.CRM_Lead_Save', 'P') IS NOT NULL
    BEGIN
        EXEC @LeadID = dbo.CRM_Lead_Save
            @LeadID = 0,
            @FirstName = 'Rohan',
            @LastName = 'Shah',
            @CompanyName = 'Orion Lending',
            @Title = 'Director',
            @Email = 'rohan.shah@orion.example.com',
            @Phone = '+91 80 4200 2211',
            @Mobile = '+91 99887 77665',
            @Website = 'https://orion.example.com',
            @City = 'Bengaluru',
            @State = 'Karnataka',
            @Country = 'India',
            @LeadSourceID = 1,
            @LeadStatusID = 1,
            @AssignedToEmployeeID = 0,
            @EstimatedValue = '1250000',
            @Rating = 'Hot',
            @NextFollowUpDate = @DemoNextFollowUpDate,
            @Description = 'Demo hot lead captured from website.',
            @AddedBy = 0;
    END

    IF OBJECT_ID('dbo.CRM_Deal_Save', 'P') IS NOT NULL
    BEGIN
        EXEC @DealID = dbo.CRM_Deal_Save
            @DealID = 0,
            @DealName = 'Nimbus workflow automation rollout',
            @AccountID = @AccountID,
            @ContactID = @ContactID,
            @LeadID = @LeadID,
            @DealStageID = 1,
            @Amount = '2400000',
            @Probability = '45',
            @ExpectedCloseDate = @DemoExpectedCloseDate,
            @LostReason = '',
            @AssignedToEmployeeID = 0,
            @Description = 'Demo opportunity for Kanban, forecast and email queue.',
            @AddedBy = 0;
    END

    IF OBJECT_ID('dbo.CRM_Activity_Save', 'P') IS NOT NULL
    BEGIN
        EXEC dbo.CRM_Activity_Save
            @ActivityID = 0,
            @ActivityTypeID = 1,
            @Subject = 'Demo discovery call',
            @RelatedEntity = 'Deal',
            @RelatedRecordID = @DealID,
            @ActivityStatusID = 1,
            @Priority = 'High',
            @DueDate = @DemoActivityDueDate,
            @StartDateTime = '',
            @EndDateTime = '',
            @Outcome = '',
            @AssignedToEmployeeID = 0,
            @Description = 'Review decision process and implementation timeline.',
            @AddedBy = 0;
    END

END
GO
