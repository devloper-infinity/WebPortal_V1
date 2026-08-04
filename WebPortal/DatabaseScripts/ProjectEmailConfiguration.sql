SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.ProjectEmailConfiguration', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ProjectEmailConfiguration
    (
        ProjectEmailConfigurationID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_ProjectEmailConfiguration PRIMARY KEY,
        ProjectID int NOT NULL,
        EmailType nvarchar(2) NOT NULL,
        EmailID nvarchar(254) NOT NULL,
        IsActive bit NOT NULL CONSTRAINT DF_ProjectEmailConfiguration_IsActive DEFAULT (1),
        AddedBy int NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_ProjectEmailConfiguration_AddedDate DEFAULT (GETDATE()),
        UpdatedBy int NULL,
        UpdatedDate datetime NULL
    );
END;
GO

IF COL_LENGTH('dbo.ProjectEmailConfiguration', 'EmailType') IS NULL
BEGIN
    ALTER TABLE dbo.ProjectEmailConfiguration
        ADD EmailType nvarchar(2) NOT NULL
            CONSTRAINT DF_ProjectEmailConfiguration_EmailType DEFAULT ('TO') WITH VALUES;
END;
GO

IF OBJECT_ID('dbo.ProjectEmailConfigurationHistory', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ProjectEmailConfigurationHistory
    (
        ProjectEmailConfigurationHistoryID bigint IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_ProjectEmailConfigurationHistory PRIMARY KEY,
        ProjectID int NOT NULL,
        ProjectEmailConfigurationID int NOT NULL,
        EmailType nvarchar(2) NOT NULL,
        PreviousEmailAddress nvarchar(254) NULL,
        NewEmailAddress nvarchar(254) NULL,
        ActionType nvarchar(12) NOT NULL,
        ChangedBy int NOT NULL,
        ChangedDateTime datetime NOT NULL
            CONSTRAINT DF_ProjectEmailConfigurationHistory_ChangedDateTime DEFAULT (GETDATE()),
        PreviousStatus bit NULL,
        NewStatus bit NULL
    );

    CREATE INDEX IX_ProjectEmailConfigurationHistory_Project
        ON dbo.ProjectEmailConfigurationHistory(ProjectID, ChangedDateTime DESC);
    CREATE INDEX IX_ProjectEmailConfigurationHistory_Record
        ON dbo.ProjectEmailConfigurationHistory(ProjectEmailConfigurationID, ChangedDateTime DESC);
END;
GO

-- Establish an auditable baseline for configurations created before history tracking was introduced.
INSERT INTO dbo.ProjectEmailConfigurationHistory
    (ProjectID, ProjectEmailConfigurationID, EmailType, PreviousEmailAddress,
     NewEmailAddress, ActionType, ChangedBy, ChangedDateTime, PreviousStatus, NewStatus)
SELECT e.ProjectID,
       e.ProjectEmailConfigurationID,
       e.EmailType,
       NULL,
       e.EmailID,
       'Insert',
       e.AddedBy,
       e.AddedDate,
       NULL,
       1
FROM dbo.ProjectEmailConfiguration e
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.ProjectEmailConfigurationHistory h
    WHERE h.ProjectEmailConfigurationID = e.ProjectEmailConfigurationID
);
GO

INSERT INTO dbo.ProjectEmailConfigurationHistory
    (ProjectID, ProjectEmailConfigurationID, EmailType, PreviousEmailAddress,
     NewEmailAddress, ActionType, ChangedBy, ChangedDateTime, PreviousStatus, NewStatus)
SELECT e.ProjectID,
       e.ProjectEmailConfigurationID,
       e.EmailType,
       e.EmailID,
       NULL,
       'Deactivate',
       COALESCE(e.UpdatedBy, e.AddedBy),
       COALESCE(e.UpdatedDate, e.AddedDate),
       1,
       0
FROM dbo.ProjectEmailConfiguration e
WHERE e.IsActive = 0
  AND NOT EXISTS
  (
      SELECT 1 FROM dbo.ProjectEmailConfigurationHistory h
      WHERE h.ProjectEmailConfigurationID = e.ProjectEmailConfigurationID
        AND h.ActionType = 'Deactivate'
        AND h.NewStatus = 0
  );
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.ProjectEmailConfiguration') AND name = 'UX_ProjectEmailConfiguration_Project_Email')
    DROP INDEX UX_ProjectEmailConfiguration_Project_Email ON dbo.ProjectEmailConfiguration;
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.ProjectEmailConfiguration') AND name = 'UX_ProjectEmailConfiguration_Project_Type_Email')
    DROP INDEX UX_ProjectEmailConfiguration_Project_Type_Email ON dbo.ProjectEmailConfiguration;
GO
CREATE UNIQUE INDEX UX_ProjectEmailConfiguration_Project_Type_Email
    ON dbo.ProjectEmailConfiguration(ProjectID, EmailType, EmailID)
    WHERE IsActive = 1;
GO

IF OBJECT_ID('dbo.usp_ProjectEmailConfiguration_GetByProject', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_ProjectEmailConfiguration_GetByProject;
GO
CREATE PROCEDURE dbo.usp_ProjectEmailConfiguration_GetByProject @ProjectID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ProjectEmailConfigurationID, ProjectID, EmailType, EmailID, AddedBy, AddedDate, UpdatedBy, UpdatedDate
    FROM dbo.ProjectEmailConfiguration
    WHERE ProjectID = @ProjectID AND IsActive = 1
    ORDER BY CASE EmailType WHEN 'TO' THEN 1 ELSE 2 END, EmailID;
END;
GO

IF OBJECT_ID('dbo.usp_ProjectEmailConfiguration_GetAll', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_ProjectEmailConfiguration_GetAll;
GO
CREATE PROCEDURE dbo.usp_ProjectEmailConfiguration_GetAll
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ProjectEmailConfigurationID, ProjectID, EmailType, EmailID, AddedBy, AddedDate, UpdatedBy, UpdatedDate
    FROM dbo.ProjectEmailConfiguration
    WHERE IsActive = 1
    ORDER BY ProjectID, CASE EmailType WHEN 'TO' THEN 1 ELSE 2 END, EmailID;
END;
GO

IF OBJECT_ID('dbo.usp_ProjectEmailConfiguration_GetByID', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_ProjectEmailConfiguration_GetByID;
GO
CREATE PROCEDURE dbo.usp_ProjectEmailConfiguration_GetByID @ConfigurationID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ProjectEmailConfigurationID, ProjectID, EmailType, EmailID, IsActive
    FROM dbo.ProjectEmailConfiguration
    WHERE ProjectEmailConfigurationID = @ConfigurationID;
END;
GO

IF OBJECT_ID('dbo.usp_ProjectEmailConfiguration_GetHistory', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_ProjectEmailConfiguration_GetHistory;
GO
CREATE PROCEDURE dbo.usp_ProjectEmailConfiguration_GetHistory @ProjectID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ProjectEmailConfigurationHistoryID,
           ProjectID,
           ProjectEmailConfigurationID,
           EmailType,
           PreviousEmailAddress,
           NewEmailAddress,
           ActionType,
           ChangedBy,
           ChangedDateTime,
           PreviousStatus,
           NewStatus
    FROM dbo.ProjectEmailConfigurationHistory
    WHERE ProjectID = @ProjectID
    ORDER BY ChangedDateTime DESC, ProjectEmailConfigurationHistoryID DESC;
END;
GO

IF OBJECT_ID('dbo.usp_ProjectEmailConfiguration_Deactivate', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_ProjectEmailConfiguration_Deactivate;
GO
CREATE PROCEDURE dbo.usp_ProjectEmailConfiguration_Deactivate
    @ConfigurationID int,
    @UserID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ProjectID int,
            @EmailType nvarchar(2),
            @EmailID nvarchar(254),
            @ChangedDate datetime = GETDATE();

    SELECT @ProjectID = ProjectID,
           @EmailType = EmailType,
           @EmailID = EmailID
    FROM dbo.ProjectEmailConfiguration
    WHERE ProjectEmailConfigurationID = @ConfigurationID
      AND IsActive = 1;

    IF @ProjectID IS NULL
        THROW 50010, 'The selected email configuration is not active or was not found.', 1;

    IF @EmailType = 'TO'
       AND (SELECT COUNT(1)
            FROM dbo.ProjectEmailConfiguration
            WHERE ProjectID = @ProjectID AND EmailType = 'TO' AND IsActive = 1) <= 1
        THROW 50011, 'At least one To email address must remain active for the project.', 1;

    BEGIN TRANSACTION;

    INSERT INTO dbo.ProjectEmailConfigurationHistory
        (ProjectID, ProjectEmailConfigurationID, EmailType, PreviousEmailAddress,
         NewEmailAddress, ActionType, ChangedBy, ChangedDateTime, PreviousStatus, NewStatus)
    VALUES
        (@ProjectID, @ConfigurationID, @EmailType, @EmailID,
         NULL, 'Deactivate', @UserID, @ChangedDate, 1, 0);

    UPDATE dbo.ProjectEmailConfiguration
       SET IsActive = 0,
           UpdatedBy = @UserID,
           UpdatedDate = @ChangedDate
    WHERE ProjectEmailConfigurationID = @ConfigurationID
      AND IsActive = 1;

    IF @@ROWCOUNT = 0
        THROW 50012, 'The selected email configuration could not be deactivated.', 1;

    COMMIT TRANSACTION;
END;
GO

IF OBJECT_ID('dbo.usp_ProjectEmailConfiguration_Save', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_ProjectEmailConfiguration_Save;
GO
CREATE PROCEDURE dbo.usp_ProjectEmailConfiguration_Save
    @OriginalProjectID int,
    @ProjectID int,
    @Emails xml,
    @UserID int,
    @RestrictEmailType nvarchar(2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ChangedDate datetime = GETDATE();
    SET @RestrictEmailType = NULLIF(UPPER(LTRIM(RTRIM(@RestrictEmailType))), '');

    IF @RestrictEmailType IS NOT NULL AND @RestrictEmailType NOT IN ('TO','CC')
        THROW 50000, 'Email type must be To or CC.', 1;

    DECLARE @Submitted TABLE
    (
        ConfigurationID int NOT NULL,
        EmailType nvarchar(2) NOT NULL,
        EmailID nvarchar(254) NOT NULL,
        UNIQUE (EmailType, EmailID)
    );

    INSERT INTO @Submitted(ConfigurationID, EmailType, EmailID)
    SELECT EmailNode.value('@ID', 'int'),
           UPPER(LTRIM(RTRIM(EmailNode.value('@Type', 'nvarchar(2)')))),
           LOWER(LTRIM(RTRIM(EmailNode.value('@Value', 'nvarchar(254)'))))
    FROM @Emails.nodes('/Emails/Email') AS EmailData(EmailNode)
    WHERE UPPER(LTRIM(RTRIM(EmailNode.value('@Type', 'nvarchar(2)')))) IN ('TO','CC')
      AND LTRIM(RTRIM(EmailNode.value('@Value', 'nvarchar(254)'))) <> '';

    IF @RestrictEmailType IS NOT NULL
       AND EXISTS (SELECT 1 FROM @Submitted WHERE EmailType <> @RestrictEmailType)
        THROW 50004, 'Submitted email records do not match the selected email type.', 1;

    IF (@RestrictEmailType IS NULL OR @RestrictEmailType = 'TO')
       AND NOT EXISTS (SELECT 1 FROM @Submitted WHERE EmailType = 'TO')
        THROW 50001, 'At least one To email address is required.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM @Submitted s
        LEFT JOIN dbo.ProjectEmailConfiguration e
          ON e.ProjectEmailConfigurationID = s.ConfigurationID
         AND e.ProjectID = @OriginalProjectID
         AND e.IsActive = 1
        WHERE s.ConfigurationID > 0 AND e.ProjectEmailConfigurationID IS NULL
    )
        THROW 50002, 'One or more email configuration records are invalid or no longer active.', 1;

    BEGIN TRANSACTION;

    DECLARE @Deactivated TABLE
    (
        ConfigurationID int PRIMARY KEY,
        ProjectID int NOT NULL,
        EmailType nvarchar(2) NOT NULL,
        EmailID nvarchar(254) NOT NULL
    );

    INSERT INTO @Deactivated(ConfigurationID, ProjectID, EmailType, EmailID)
    SELECT e.ProjectEmailConfigurationID, e.ProjectID, e.EmailType, e.EmailID
    FROM dbo.ProjectEmailConfiguration e
    WHERE e.ProjectID = @OriginalProjectID
      AND e.IsActive = 1
      AND (@RestrictEmailType IS NULL OR e.EmailType = @RestrictEmailType)
      AND NOT EXISTS
          (SELECT 1 FROM @Submitted s WHERE s.ConfigurationID = e.ProjectEmailConfigurationID);

    INSERT INTO dbo.ProjectEmailConfigurationHistory
        (ProjectID, ProjectEmailConfigurationID, EmailType, PreviousEmailAddress,
         NewEmailAddress, ActionType, ChangedBy, ChangedDateTime, PreviousStatus, NewStatus)
    SELECT ProjectID, ConfigurationID, EmailType, EmailID,
           NULL, 'Deactivate', @UserID, @ChangedDate, 1, 0
    FROM @Deactivated;

    UPDATE e
       SET IsActive = 0,
           UpdatedBy = @UserID,
           UpdatedDate = @ChangedDate
    FROM dbo.ProjectEmailConfiguration e
    JOIN @Deactivated d ON d.ConfigurationID = e.ProjectEmailConfigurationID;

    IF EXISTS
    (
        SELECT 1
        FROM @Submitted s
        JOIN dbo.ProjectEmailConfiguration e
          ON e.ProjectID = @ProjectID
         AND e.EmailType = s.EmailType
         AND e.EmailID = s.EmailID
         AND e.IsActive = 1
         AND e.ProjectEmailConfigurationID <> s.ConfigurationID
        WHERE NOT EXISTS
              (SELECT 1 FROM @Submitted moving WHERE moving.ConfigurationID = e.ProjectEmailConfigurationID)
    )
        THROW 50003, 'An email address is already active for the selected project and email type.', 1;

    DECLARE @Changed TABLE
    (
        ConfigurationID int PRIMARY KEY,
        PreviousEmailType nvarchar(2) NOT NULL,
        PreviousEmailID nvarchar(254) NOT NULL,
        NewEmailType nvarchar(2) NOT NULL,
        NewEmailID nvarchar(254) NOT NULL
    );

    INSERT INTO @Changed
        (ConfigurationID, PreviousEmailType, PreviousEmailID, NewEmailType, NewEmailID)
    SELECT e.ProjectEmailConfigurationID, e.EmailType, e.EmailID, s.EmailType, s.EmailID
    FROM dbo.ProjectEmailConfiguration e
    JOIN @Submitted s ON s.ConfigurationID = e.ProjectEmailConfigurationID
    WHERE s.ConfigurationID > 0
      AND (e.ProjectID <> @ProjectID OR e.EmailType <> s.EmailType OR e.EmailID <> s.EmailID);

    INSERT INTO dbo.ProjectEmailConfigurationHistory
        (ProjectID, ProjectEmailConfigurationID, EmailType, PreviousEmailAddress,
         NewEmailAddress, ActionType, ChangedBy, ChangedDateTime, PreviousStatus, NewStatus)
    SELECT @ProjectID, ConfigurationID, NewEmailType, PreviousEmailID,
           NewEmailID, 'Update', @UserID, @ChangedDate, 1, 1
    FROM @Changed;

    UPDATE e
       SET ProjectID = @ProjectID,
           EmailType = c.NewEmailType,
           EmailID = c.NewEmailID,
           UpdatedBy = @UserID,
           UpdatedDate = @ChangedDate
    FROM dbo.ProjectEmailConfiguration e
    JOIN @Changed c ON c.ConfigurationID = e.ProjectEmailConfigurationID;

    DECLARE @EmailType nvarchar(2), @EmailID nvarchar(254), @ConfigurationID int;
    DECLARE NewEmailCursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT EmailType, EmailID FROM @Submitted WHERE ConfigurationID = 0;

    OPEN NewEmailCursor;
    FETCH NEXT FROM NewEmailCursor INTO @EmailType, @EmailID;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ConfigurationID = NULL;
        SELECT TOP (1) @ConfigurationID = ProjectEmailConfigurationID
        FROM dbo.ProjectEmailConfiguration
        WHERE ProjectID = @ProjectID
          AND EmailType = @EmailType
          AND EmailID = @EmailID
          AND IsActive = 0
        ORDER BY ProjectEmailConfigurationID DESC;

        IF @ConfigurationID IS NOT NULL
        BEGIN
            UPDATE dbo.ProjectEmailConfiguration
               SET IsActive = 1,
                   UpdatedBy = @UserID,
                   UpdatedDate = @ChangedDate
            WHERE ProjectEmailConfigurationID = @ConfigurationID;

            INSERT INTO dbo.ProjectEmailConfigurationHistory
                (ProjectID, ProjectEmailConfigurationID, EmailType, PreviousEmailAddress,
                 NewEmailAddress, ActionType, ChangedBy, ChangedDateTime, PreviousStatus, NewStatus)
            VALUES
                (@ProjectID, @ConfigurationID, @EmailType, @EmailID,
                 @EmailID, 'Activate', @UserID, @ChangedDate, 0, 1);
        END
        ELSE
        BEGIN
            INSERT INTO dbo.ProjectEmailConfiguration
                (ProjectID, EmailType, EmailID, IsActive, AddedBy, AddedDate)
            VALUES (@ProjectID, @EmailType, @EmailID, 1, @UserID, @ChangedDate);

            SET @ConfigurationID = CONVERT(int, SCOPE_IDENTITY());

            INSERT INTO dbo.ProjectEmailConfigurationHistory
                (ProjectID, ProjectEmailConfigurationID, EmailType, PreviousEmailAddress,
                 NewEmailAddress, ActionType, ChangedBy, ChangedDateTime, PreviousStatus, NewStatus)
            VALUES
                (@ProjectID, @ConfigurationID, @EmailType, NULL,
                 @EmailID, 'Insert', @UserID, @ChangedDate, NULL, 1);
        END;

        FETCH NEXT FROM NewEmailCursor INTO @EmailType, @EmailID;
    END;
    CLOSE NewEmailCursor;
    DEALLOCATE NewEmailCursor;

    COMMIT TRANSACTION;
END;
GO

IF OBJECT_ID('dbo.usp_ProjectEmailConfiguration_SaveType', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_ProjectEmailConfiguration_SaveType;
GO
CREATE PROCEDURE dbo.usp_ProjectEmailConfiguration_SaveType
    @ProjectID int,
    @EmailType nvarchar(2),
    @Emails xml,
    @UserID int
AS
BEGIN
    SET NOCOUNT ON;
    EXEC dbo.usp_ProjectEmailConfiguration_Save
         @OriginalProjectID = @ProjectID,
         @ProjectID = @ProjectID,
         @Emails = @Emails,
         @UserID = @UserID,
         @RestrictEmailType = @EmailType;
END;
GO
