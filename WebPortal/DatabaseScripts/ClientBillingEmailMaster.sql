SET NOCOUNT ON;

IF OBJECT_ID('dbo.ClientBillingEmailMaster','U') IS NULL
BEGIN
    CREATE TABLE dbo.ClientBillingEmailMaster
    (
        MasterID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ClientBillingEmailMaster PRIMARY KEY,
        ProjectID INT NOT NULL,
        TOID NVARCHAR(MAX) NOT NULL,
        CCID NVARCHAR(MAX) NULL,
        BCCID NVARCHAR(MAX) NULL,
        AddedBy INT NOT NULL,
        AddedDate DATETIME NOT NULL CONSTRAINT DF_ClientBillingEmailMaster_AddedDate DEFAULT(GETDATE()),
        UdpatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        CONSTRAINT UQ_ClientBillingEmailMaster_Project UNIQUE(ProjectID)
    );
END;
GO

IF OBJECT_ID('dbo.usp_ClientBillingEmailMaster_Get','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.usp_ClientBillingEmailMaster_Get AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_ClientBillingEmailMaster_Get
AS
BEGIN
    SET NOCOUNT ON;
    SELECT M.MasterID,M.ProjectID,CASE WHEN M.ProjectID=0 THEN 'All Commitment Projects' WHEN M.ProjectID=-4 THEN 'All Valuation Projects' WHEN M.ProjectID=-19 THEN 'All Underwriting Servicing Projects' WHEN M.ProjectID=-15 THEN 'All Underwriting Credit Projects' ELSE P.ProjectName END ProjectName,M.TOID,M.CCID,M.BCCID,
           COALESCE(NULLIF(LTRIM(RTRIM(E.Code)),''),CONVERT(VARCHAR(20),COALESCE(M.UdpatedBy,M.AddedBy))) AS UpdatedBy,
           COALESCE(M.UpdatedDate,M.AddedDate) AS UpdatedDate
    FROM dbo.ClientBillingEmailMaster M
    LEFT JOIN dbo.Project P ON P.ProjectID=M.ProjectID
    LEFT JOIN dbo.EmployeeInfo E ON E.EmployeeID=COALESCE(M.UdpatedBy,M.AddedBy)
    ORDER BY CASE WHEN M.ProjectID IN (0,-4,-15,-19) THEN 0 ELSE 1 END,CASE WHEN M.ProjectID=0 THEN 'All Commitment Projects' WHEN M.ProjectID=-4 THEN 'All Valuation Projects' WHEN M.ProjectID=-19 THEN 'All Underwriting Servicing Projects' WHEN M.ProjectID=-15 THEN 'All Underwriting Credit Projects' ELSE P.ProjectName END;
END;
GO

IF OBJECT_ID('dbo.usp_ClientBillingEmailMaster_Insert','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.usp_ClientBillingEmailMaster_Insert AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_ClientBillingEmailMaster_Insert
    @ProjectID INT,@TOID NVARCHAR(MAX),@CCID NVARCHAR(MAX)=NULL,@BCCID NVARCHAR(MAX)=NULL,@AddedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;
    IF EXISTS(SELECT 1 FROM dbo.ClientBillingEmailMaster WITH(UPDLOCK,HOLDLOCK) WHERE ProjectID=@ProjectID)
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Email configuration already exists for the selected project.',16,1);
        RETURN;
    END;
    INSERT dbo.ClientBillingEmailMaster(ProjectID,TOID,CCID,BCCID,AddedBy,AddedDate)
    VALUES(@ProjectID,@TOID,NULLIF(@CCID,''),NULLIF(@BCCID,''),@AddedBy,GETDATE());
    DECLARE @MasterID INT=CONVERT(INT,SCOPE_IDENTITY());
    COMMIT TRANSACTION;
    SELECT @MasterID AS MasterID;
END;
GO

IF OBJECT_ID('dbo.usp_ClientBillingEmailMaster_Update','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.usp_ClientBillingEmailMaster_Update AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_ClientBillingEmailMaster_Update
    @MasterID INT,@ProjectID INT,@TOID NVARCHAR(MAX),@CCID NVARCHAR(MAX)=NULL,@BCCID NVARCHAR(MAX)=NULL,@UdpatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;
    IF EXISTS(SELECT 1 FROM dbo.ClientBillingEmailMaster WITH(UPDLOCK,HOLDLOCK) WHERE ProjectID=@ProjectID AND MasterID<>@MasterID)
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Email configuration already exists for the selected project.',16,1);
        RETURN;
    END;
    UPDATE dbo.ClientBillingEmailMaster
       SET ProjectID=@ProjectID,TOID=@TOID,CCID=NULLIF(@CCID,''),BCCID=NULLIF(@BCCID,''),
           UdpatedBy=@UdpatedBy,UpdatedDate=GETDATE()
     WHERE MasterID=@MasterID;
    IF @@ROWCOUNT=0
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Email configuration was not found.',16,1);
        RETURN;
    END;
    COMMIT TRANSACTION;
    SELECT @MasterID AS MasterID;
END;
GO
