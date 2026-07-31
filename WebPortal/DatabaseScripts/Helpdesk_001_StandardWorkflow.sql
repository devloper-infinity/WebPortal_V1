/*
    Standard Helpdesk / ITSM workflow for WebPortal.
    Review department IDs and seed agent EmployeeIDs before production use.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.HelpdeskSlaPolicy','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskSlaPolicy
    (
        SlaPolicyID       INT IDENTITY(1,1) PRIMARY KEY,
        PolicyName        NVARCHAR(120) NOT NULL,
        PriorityCode      VARCHAR(20) NOT NULL,
        FirstResponseMins INT NOT NULL,
        ResolutionMins    INT NOT NULL,
        IsActive          BIT NOT NULL CONSTRAINT DF_HelpdeskSlaPolicy_Active DEFAULT(1),
        CONSTRAINT CK_HelpdeskSlaPolicy_Priority CHECK(PriorityCode IN('Low','Medium','High','Critical')),
        CONSTRAINT CK_HelpdeskSlaPolicy_Minutes CHECK(FirstResponseMins>0 AND ResolutionMins>=FirstResponseMins)
    );
    CREATE UNIQUE INDEX UX_HelpdeskSlaPolicy_Priority ON dbo.HelpdeskSlaPolicy(PriorityCode) WHERE IsActive=1;
END;
GO

IF OBJECT_ID('dbo.HelpdeskCategory','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskCategory
    (
        CategoryID       INT IDENTITY(1,1) PRIMARY KEY,
        CategoryName     NVARCHAR(150) NOT NULL,
        DepartmentID     INT NOT NULL,
        DepartmentName   NVARCHAR(150) NOT NULL,
        DefaultPriority  VARCHAR(20) NOT NULL CONSTRAINT DF_HelpdeskCategory_Priority DEFAULT('Medium'),
        ApprovalMode     VARCHAR(20) NOT NULL CONSTRAINT DF_HelpdeskCategory_Approval DEFAULT('None'),
        DefaultApproverID INT NULL,
        IsActive         BIT NOT NULL CONSTRAINT DF_HelpdeskCategory_Active DEFAULT(1),
        CreatedBy        INT NULL,
        CreatedOn        DATETIME2(0) NOT NULL CONSTRAINT DF_HelpdeskCategory_Created DEFAULT(SYSUTCDATETIME()),
        CONSTRAINT UQ_HelpdeskCategory UNIQUE(DepartmentID,CategoryName),
        CONSTRAINT CK_HelpdeskCategory_Priority CHECK(DefaultPriority IN('Low','Medium','High','Critical')),
        CONSTRAINT CK_HelpdeskCategory_Approval CHECK(ApprovalMode IN('None','Manager','Specific'))
    );
END;
GO

IF OBJECT_ID('dbo.HelpdeskAgent','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskAgent
    (
        AgentID      INT IDENTITY(1,1) PRIMARY KEY,
        EmployeeID   INT NOT NULL,
        DepartmentID INT NULL,
        DisplayName  NVARCHAR(150) NOT NULL,
        RoleCode     VARCHAR(20) NOT NULL,
        IsActive     BIT NOT NULL CONSTRAINT DF_HelpdeskAgent_Active DEFAULT(1),
        CreatedOn    DATETIME2(0) NOT NULL CONSTRAINT DF_HelpdeskAgent_Created DEFAULT(SYSUTCDATETIME()),
        CONSTRAINT CK_HelpdeskAgent_Role CHECK(RoleCode IN('Admin','Supervisor','Agent')),
        CONSTRAINT UQ_HelpdeskAgent UNIQUE(EmployeeID,DepartmentID)
    );
    CREATE INDEX IX_HelpdeskAgent_Department ON dbo.HelpdeskAgent(DepartmentID,IsActive);
END;
GO

IF OBJECT_ID('dbo.HelpdeskTicket','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskTicket
    (
        TicketID           INT IDENTITY(1,1) PRIMARY KEY,
        TicketNo           VARCHAR(30) NULL,
        CategoryID         INT NOT NULL,
        DepartmentID       INT NOT NULL,
        RequesterID        INT NOT NULL,
        OnBehalfOfID       INT NULL,
        ApproverID         INT NULL,
        Subject            NVARCHAR(300) NOT NULL,
        Description        NVARCHAR(MAX) NOT NULL,
        Location           NVARCHAR(150) NULL,
        AssetReference     NVARCHAR(150) NULL,
        ImpactCode         VARCHAR(20) NOT NULL,
        UrgencyCode        VARCHAR(20) NOT NULL,
        PriorityCode       VARCHAR(20) NOT NULL,
        StatusCode         VARCHAR(30) NOT NULL,
        FirstResponseDueOn DATETIME2(0) NULL,
        ResolutionDueOn    DATETIME2(0) NULL,
        FirstRespondedOn   DATETIME2(0) NULL,
        ResolvedOn         DATETIME2(0) NULL,
        ClosedOn           DATETIME2(0) NULL,
        ReopenUntil        DATETIME2(0) NULL,
        ResolutionSummary  NVARCHAR(MAX) NULL,
        CreatedOn          DATETIME2(0) NOT NULL CONSTRAINT DF_HelpdeskTicket_Created DEFAULT(SYSUTCDATETIME()),
        UpdatedOn          DATETIME2(0) NOT NULL CONSTRAINT DF_HelpdeskTicket_Updated DEFAULT(SYSUTCDATETIME()),
        RowVersion         ROWVERSION NOT NULL,
        CONSTRAINT FK_HelpdeskTicket_Category FOREIGN KEY(CategoryID) REFERENCES dbo.HelpdeskCategory(CategoryID),
        CONSTRAINT CK_HelpdeskTicket_Impact CHECK(ImpactCode IN('Individual','Team','Department','Company')),
        CONSTRAINT CK_HelpdeskTicket_Urgency CHECK(UrgencyCode IN('Low','Medium','High','Critical')),
        CONSTRAINT CK_HelpdeskTicket_Priority CHECK(PriorityCode IN('Low','Medium','High','Critical')),
        CONSTRAINT CK_HelpdeskTicket_Status CHECK(StatusCode IN
          ('New','Pending Approval','Rejected','Assigned','In Progress','Waiting for User',
           'Waiting for Vendor','Resolved','Closed','Reopened','Cancelled'))
    );
    CREATE UNIQUE INDEX UX_HelpdeskTicket_No ON dbo.HelpdeskTicket(TicketNo) WHERE TicketNo IS NOT NULL;
    CREATE INDEX IX_HelpdeskTicket_Requester ON dbo.HelpdeskTicket(RequesterID,CreatedOn DESC);
    CREATE INDEX IX_HelpdeskTicket_Queue ON dbo.HelpdeskTicket(DepartmentID,StatusCode,PriorityCode,CreatedOn);
END;
GO

IF OBJECT_ID('dbo.HelpdeskAssignment','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskAssignment
    (
        AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
        TicketID     INT NOT NULL,
        AgentEmployeeID INT NOT NULL,
        AssignedBy   INT NOT NULL,
        AssignedOn   DATETIME2(0) NOT NULL CONSTRAINT DF_HelpdeskAssignment_Assigned DEFAULT(SYSUTCDATETIME()),
        ReleasedOn   DATETIME2(0) NULL,
        IsCurrent    BIT NOT NULL CONSTRAINT DF_HelpdeskAssignment_Current DEFAULT(1),
        CONSTRAINT FK_HelpdeskAssignment_Ticket FOREIGN KEY(TicketID) REFERENCES dbo.HelpdeskTicket(TicketID)
    );
    CREATE UNIQUE INDEX UX_HelpdeskAssignment_Current ON dbo.HelpdeskAssignment(TicketID) WHERE IsCurrent=1;
    CREATE INDEX IX_HelpdeskAssignment_Agent ON dbo.HelpdeskAssignment(AgentEmployeeID,IsCurrent);
END;
GO

IF OBJECT_ID('dbo.HelpdeskMessage','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskMessage
    (
        MessageID  INT IDENTITY(1,1) PRIMARY KEY,
        TicketID   INT NOT NULL,
        MessageText NVARCHAR(MAX) NOT NULL,
        IsInternal BIT NOT NULL CONSTRAINT DF_HelpdeskMessage_Internal DEFAULT(0),
        AddedBy    INT NOT NULL,
        AddedOn    DATETIME2(0) NOT NULL CONSTRAINT DF_HelpdeskMessage_Added DEFAULT(SYSUTCDATETIME()),
        CONSTRAINT FK_HelpdeskMessage_Ticket FOREIGN KEY(TicketID) REFERENCES dbo.HelpdeskTicket(TicketID)
    );
    CREATE INDEX IX_HelpdeskMessage_Ticket ON dbo.HelpdeskMessage(TicketID,AddedOn);
END;
GO

IF OBJECT_ID('dbo.HelpdeskApproval','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskApproval
    (
        ApprovalID INT IDENTITY(1,1) PRIMARY KEY,
        TicketID   INT NOT NULL,
        ApproverID INT NOT NULL,
        DecisionCode VARCHAR(20) NOT NULL,
        DecisionComment NVARCHAR(MAX) NULL,
        DecidedOn  DATETIME2(0) NOT NULL CONSTRAINT DF_HelpdeskApproval_Decided DEFAULT(SYSUTCDATETIME()),
        CONSTRAINT FK_HelpdeskApproval_Ticket FOREIGN KEY(TicketID) REFERENCES dbo.HelpdeskTicket(TicketID),
        CONSTRAINT CK_HelpdeskApproval_Decision CHECK(DecisionCode IN('Approved','Rejected'))
    );
END;
GO

IF OBJECT_ID('dbo.HelpdeskAttachment','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskAttachment
    (
        AttachmentID INT IDENTITY(1,1) PRIMARY KEY,
        TicketID     INT NOT NULL,
        MessageID    INT NULL,
        OriginalName NVARCHAR(260) NOT NULL,
        StoredPath   NVARCHAR(1000) NOT NULL,
        ContentType  NVARCHAR(150) NULL,
        FileSize     BIGINT NULL,
        UploadedBy   INT NOT NULL,
        UploadedOn   DATETIME2(0) NOT NULL CONSTRAINT DF_HelpdeskAttachment_Uploaded DEFAULT(SYSUTCDATETIME()),
        IsActive     BIT NOT NULL CONSTRAINT DF_HelpdeskAttachment_Active DEFAULT(1),
        CONSTRAINT FK_HelpdeskAttachment_Ticket FOREIGN KEY(TicketID) REFERENCES dbo.HelpdeskTicket(TicketID),
        CONSTRAINT FK_HelpdeskAttachment_Message FOREIGN KEY(MessageID) REFERENCES dbo.HelpdeskMessage(MessageID)
    );
END;
GO

IF OBJECT_ID('dbo.HelpdeskAudit','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskAudit
    (
        AuditID     BIGINT IDENTITY(1,1) PRIMARY KEY,
        TicketID   INT NOT NULL,
        EventCode   VARCHAR(40) NOT NULL,
        OldValue    NVARCHAR(500) NULL,
        NewValue    NVARCHAR(500) NULL,
        Comment     NVARCHAR(MAX) NULL,
        PerformedBy INT NOT NULL,
        PerformedOn DATETIME2(0) NOT NULL CONSTRAINT DF_HelpdeskAudit_Performed DEFAULT(SYSUTCDATETIME()),
        CONSTRAINT FK_HelpdeskAudit_Ticket FOREIGN KEY(TicketID) REFERENCES dbo.HelpdeskTicket(TicketID)
    );
    CREATE INDEX IX_HelpdeskAudit_Ticket ON dbo.HelpdeskAudit(TicketID,PerformedOn);
END;
GO

IF NOT EXISTS(SELECT 1 FROM dbo.HelpdeskSlaPolicy)
BEGIN
    INSERT dbo.HelpdeskSlaPolicy(PolicyName,PriorityCode,FirstResponseMins,ResolutionMins)
    VALUES('Low priority','Low',480,2880),('Standard','Medium',240,1440),
          ('High priority','High',60,480),('Critical incident','Critical',15,120);
END;
GO

IF NOT EXISTS(SELECT 1 FROM dbo.HelpdeskCategory)
BEGIN
    INSERT dbo.HelpdeskCategory(CategoryName,DepartmentID,DepartmentName,DefaultPriority,ApprovalMode)
    VALUES('Hardware',7,'IT','Medium','None'),
          ('Software / Application',7,'IT','Medium','None'),
          ('Access / Permission',7,'IT','High','Manager'),
          ('Network / Internet',7,'IT','High','None'),
          ('Email',7,'IT','Medium','None'),
          ('Security Incident',7,'IT','Critical','None'),
          ('Other',7,'IT','Low','None');
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_Bootstrap @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CategoryID,CategoryName,DepartmentID,DepartmentName,DefaultPriority,ApprovalMode
    FROM dbo.HelpdeskCategory WHERE IsActive=1 ORDER BY DepartmentName,CategoryName;
    SELECT CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@EmployeeID AND IsActive=1) THEN 1 ELSE 0 END AS bit) IsAgent,
           CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@EmployeeID AND IsActive=1 AND RoleCode IN('Admin','Supervisor')) THEN 1 ELSE 0 END AS bit) CanTriage,
           CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@EmployeeID AND IsActive=1 AND RoleCode='Admin') THEN 1 ELSE 0 END AS bit) IsAdmin;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_CreateTicket
 @RequesterID INT,@OnBehalfOfID INT=NULL,@CategoryID INT,@Subject NVARCHAR(300),@Description NVARCHAR(MAX),
 @Location NVARCHAR(150)=NULL,@AssetReference NVARCHAR(150)=NULL,@ImpactCode VARCHAR(20),@UrgencyCode VARCHAR(20),
 @ManagerApproverID INT=NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DepartmentID INT,@ApprovalMode VARCHAR(20),@ApproverID INT,@Priority VARCHAR(20),
            @ResponseMins INT,@ResolutionMins INT,@TicketID INT,@Status VARCHAR(30);
    SELECT @DepartmentID=DepartmentID,@ApprovalMode=ApprovalMode,@ApproverID=DefaultApproverID,@Priority=DefaultPriority
    FROM dbo.HelpdeskCategory WHERE CategoryID=@CategoryID AND IsActive=1;
    IF @DepartmentID IS NULL OR NULLIF(LTRIM(RTRIM(@Subject)),'') IS NULL OR NULLIF(LTRIM(RTRIM(@Description)),'') IS NULL RETURN 0;
    IF @UrgencyCode='Critical' OR @ImpactCode='Company' SET @Priority='Critical';
    ELSE IF @UrgencyCode='High' OR @ImpactCode='Department' SET @Priority=CASE WHEN @Priority='Critical' THEN @Priority ELSE 'High' END;
    IF @ApprovalMode='Manager' SET @ApproverID=@ManagerApproverID;
    SET @Status=CASE WHEN @ApprovalMode='None' THEN 'New' ELSE 'Pending Approval' END;
    IF @Status='Pending Approval' AND ISNULL(@ApproverID,0)=0 RETURN -2;
    SELECT @ResponseMins=FirstResponseMins,@ResolutionMins=ResolutionMins FROM dbo.HelpdeskSlaPolicy WHERE PriorityCode=@Priority AND IsActive=1;

    INSERT dbo.HelpdeskTicket(CategoryID,DepartmentID,RequesterID,OnBehalfOfID,ApproverID,Subject,Description,
      Location,AssetReference,ImpactCode,UrgencyCode,PriorityCode,StatusCode,FirstResponseDueOn,ResolutionDueOn)
    VALUES(@CategoryID,@DepartmentID,@RequesterID,NULLIF(@OnBehalfOfID,0),@ApproverID,@Subject,@Description,
      @Location,@AssetReference,@ImpactCode,@UrgencyCode,@Priority,@Status,
      DATEADD(MINUTE,@ResponseMins,SYSUTCDATETIME()),DATEADD(MINUTE,@ResolutionMins,SYSUTCDATETIME()));
    SET @TicketID=SCOPE_IDENTITY();
    UPDATE dbo.HelpdeskTicket SET TicketNo='HD-'+CONVERT(char(8),GETDATE(),112)+'-'+RIGHT('000000'+CONVERT(varchar(6),@TicketID),6) WHERE TicketID=@TicketID;
    INSERT dbo.HelpdeskAudit(TicketID,EventCode,NewValue,PerformedBy) VALUES(@TicketID,'Created',@Status,@RequesterID);
    RETURN @TicketID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_MyTickets @EmployeeID INT,@StatusCode VARCHAR(30)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT t.TicketID,t.TicketNo,c.CategoryName,t.Subject,t.PriorityCode,t.StatusCode,t.CreatedOn,t.UpdatedOn,
      t.ResolutionDueOn,CAST(CASE WHEN t.ResolutionDueOn<SYSUTCDATETIME() AND t.StatusCode NOT IN('Resolved','Closed','Rejected','Cancelled') THEN 1 ELSE 0 END AS bit) IsOverdue
    FROM dbo.HelpdeskTicket t JOIN dbo.HelpdeskCategory c ON c.CategoryID=t.CategoryID
    WHERE (t.RequesterID=@EmployeeID OR t.OnBehalfOfID=@EmployeeID) AND (@StatusCode IS NULL OR @StatusCode='' OR t.StatusCode=@StatusCode)
    ORDER BY t.CreatedOn DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_Queue @EmployeeID INT,@Scope VARCHAR(20),@StatusCode VARCHAR(30)=NULL,@PriorityCode VARCHAR(20)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@EmployeeID AND IsActive=1) RETURN;
    SELECT t.TicketID,t.TicketNo,c.CategoryName,t.Subject,t.RequesterID,t.PriorityCode,t.StatusCode,t.CreatedOn,
      t.FirstResponseDueOn,t.ResolutionDueOn,cur.AgentEmployeeID AssignedTo,ag.DisplayName AssignedToName,
      CAST(CASE WHEN t.ResolutionDueOn<SYSUTCDATETIME() AND t.StatusCode NOT IN('Resolved','Closed','Rejected','Cancelled') THEN 1 ELSE 0 END AS bit) IsOverdue
    FROM dbo.HelpdeskTicket t JOIN dbo.HelpdeskCategory c ON c.CategoryID=t.CategoryID
    OUTER APPLY(SELECT TOP 1 AgentEmployeeID FROM dbo.HelpdeskAssignment WHERE TicketID=t.TicketID AND IsCurrent=1) cur
    LEFT JOIN dbo.HelpdeskAgent ag ON ag.EmployeeID=cur.AgentEmployeeID AND ag.IsActive=1
    WHERE EXISTS(SELECT 1 FROM dbo.HelpdeskAgent me WHERE me.EmployeeID=@EmployeeID AND me.IsActive=1 AND (me.RoleCode='Admin' OR me.DepartmentID=t.DepartmentID))
      AND (@Scope<>'Mine' OR cur.AgentEmployeeID=@EmployeeID)
      AND (@Scope<>'Unassigned' OR cur.AgentEmployeeID IS NULL)
      AND (@StatusCode IS NULL OR @StatusCode='' OR t.StatusCode=@StatusCode)
      AND (@PriorityCode IS NULL OR @PriorityCode='' OR t.PriorityCode=@PriorityCode)
    ORDER BY CASE t.PriorityCode WHEN 'Critical' THEN 1 WHEN 'High' THEN 2 WHEN 'Medium' THEN 3 ELSE 4 END,t.CreatedOn;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_Agents @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT a.EmployeeID,a.DisplayName,a.DepartmentID,a.RoleCode
    FROM dbo.HelpdeskAgent a
    WHERE a.IsActive=1 AND EXISTS(SELECT 1 FROM dbo.HelpdeskAgent me WHERE me.EmployeeID=@EmployeeID AND me.IsActive=1
      AND (me.RoleCode='Admin' OR me.DepartmentID=a.DepartmentID))
    ORDER BY a.DisplayName;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_TicketDetail @TicketID INT,@EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @IsStaff BIT=0;
    IF EXISTS(SELECT 1 FROM dbo.HelpdeskTicket t JOIN dbo.HelpdeskAgent a ON a.EmployeeID=@EmployeeID AND a.IsActive=1
      WHERE t.TicketID=@TicketID AND (a.RoleCode='Admin' OR a.DepartmentID=t.DepartmentID)) SET @IsStaff=1;
    IF NOT EXISTS(SELECT 1 FROM dbo.HelpdeskTicket t WHERE t.TicketID=@TicketID AND
      (t.RequesterID=@EmployeeID OR t.OnBehalfOfID=@EmployeeID OR t.ApproverID=@EmployeeID OR @IsStaff=1)) RETURN;

    SELECT t.*,c.CategoryName,c.DepartmentName,cur.AgentEmployeeID AssignedTo,ag.DisplayName AssignedToName,@EmployeeID CurrentEmployeeID,
      @IsStaff IsStaff,CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@EmployeeID AND IsActive=1 AND RoleCode IN('Admin','Supervisor')) THEN 1 ELSE 0 END AS bit) CanTriage
    FROM dbo.HelpdeskTicket t JOIN dbo.HelpdeskCategory c ON c.CategoryID=t.CategoryID
    OUTER APPLY(SELECT TOP 1 AgentEmployeeID FROM dbo.HelpdeskAssignment WHERE TicketID=t.TicketID AND IsCurrent=1) cur
    LEFT JOIN dbo.HelpdeskAgent ag ON ag.EmployeeID=cur.AgentEmployeeID AND ag.IsActive=1 WHERE t.TicketID=@TicketID;
    SELECT MessageID,MessageText,IsInternal,AddedBy,AddedOn FROM dbo.HelpdeskMessage
      WHERE TicketID=@TicketID AND (@IsStaff=1 OR IsInternal=0) ORDER BY AddedOn;
    SELECT EventCode,OldValue,NewValue,Comment,PerformedBy,PerformedOn FROM dbo.HelpdeskAudit
      WHERE TicketID=@TicketID ORDER BY PerformedOn;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_AddMessage @TicketID INT,@EmployeeID INT,@MessageText NVARCHAR(MAX),@IsInternal BIT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @IsStaff BIT=0,@MessageID INT;
    IF EXISTS(SELECT 1 FROM dbo.HelpdeskTicket t JOIN dbo.HelpdeskAgent a ON a.EmployeeID=@EmployeeID AND a.IsActive=1
      WHERE t.TicketID=@TicketID AND (a.RoleCode='Admin' OR a.DepartmentID=t.DepartmentID)) SET @IsStaff=1;
    IF @IsInternal=1 AND @IsStaff=0 RETURN 0;
    IF NULLIF(LTRIM(RTRIM(@MessageText)),'') IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.HelpdeskTicket t WHERE t.TicketID=@TicketID
      AND (t.RequesterID=@EmployeeID OR t.OnBehalfOfID=@EmployeeID OR @IsStaff=1)) RETURN 0;
    INSERT dbo.HelpdeskMessage(TicketID,MessageText,IsInternal,AddedBy) VALUES(@TicketID,@MessageText,@IsInternal,@EmployeeID);
    SET @MessageID=SCOPE_IDENTITY();
    IF @IsStaff=1 UPDATE dbo.HelpdeskTicket SET FirstRespondedOn=COALESCE(FirstRespondedOn,SYSUTCDATETIME()),UpdatedOn=SYSUTCDATETIME() WHERE TicketID=@TicketID;
    INSERT dbo.HelpdeskAudit(TicketID,EventCode,NewValue,PerformedBy) VALUES(@TicketID,CASE WHEN @IsInternal=1 THEN 'Internal note' ELSE 'Reply' END,CONVERT(nvarchar(30),@MessageID),@EmployeeID);
    RETURN @MessageID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_Assign @TicketID INT,@AgentEmployeeID INT,@AssignedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DepartmentID INT,@OldAgent INT;
    SELECT @DepartmentID=DepartmentID FROM dbo.HelpdeskTicket WHERE TicketID=@TicketID AND StatusCode NOT IN('Closed','Rejected','Cancelled');
    SELECT @OldAgent=AgentEmployeeID FROM dbo.HelpdeskAssignment WHERE TicketID=@TicketID AND IsCurrent=1;
    IF @DepartmentID IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@AssignedBy AND IsActive=1 AND (RoleCode='Admin' OR (RoleCode='Supervisor' AND DepartmentID=@DepartmentID)))
      OR NOT EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@AgentEmployeeID AND IsActive=1 AND (RoleCode='Admin' OR DepartmentID=@DepartmentID)) RETURN 0;
    BEGIN TRAN;
    UPDATE dbo.HelpdeskAssignment SET IsCurrent=0,ReleasedOn=SYSUTCDATETIME() WHERE TicketID=@TicketID AND IsCurrent=1;
    INSERT dbo.HelpdeskAssignment(TicketID,AgentEmployeeID,AssignedBy) VALUES(@TicketID,@AgentEmployeeID,@AssignedBy);
    UPDATE dbo.HelpdeskTicket SET StatusCode=CASE WHEN StatusCode IN('New','Reopened') THEN 'Assigned' ELSE StatusCode END,UpdatedOn=SYSUTCDATETIME() WHERE TicketID=@TicketID;
    INSERT dbo.HelpdeskAudit(TicketID,EventCode,OldValue,NewValue,PerformedBy) VALUES(@TicketID,'Assignment',CONVERT(nvarchar(20),@OldAgent),CONVERT(nvarchar(20),@AgentEmployeeID),@AssignedBy);
    COMMIT;
    RETURN @TicketID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_Transition @TicketID INT,@EmployeeID INT,@NextStatus VARCHAR(30),@Comment NVARCHAR(MAX)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Current VARCHAR(30),@RequesterID INT,@DepartmentID INT,@IsStaff BIT=0,@Allowed BIT=0;
    SELECT @Current=StatusCode,@RequesterID=RequesterID,@DepartmentID=DepartmentID FROM dbo.HelpdeskTicket WHERE TicketID=@TicketID;
    IF EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@EmployeeID AND IsActive=1 AND (RoleCode='Admin' OR DepartmentID=@DepartmentID)) SET @IsStaff=1;
    IF @IsStaff=1 AND
      ((@Current IN('New','Reopened') AND @NextStatus IN('Assigned','In Progress','Cancelled')) OR
       (@Current='Assigned' AND @NextStatus IN('In Progress','Waiting for User','Waiting for Vendor','Resolved','Cancelled')) OR
       (@Current IN('In Progress','Waiting for User','Waiting for Vendor') AND @NextStatus IN('In Progress','Waiting for User','Waiting for Vendor','Resolved','Cancelled')))
      SET @Allowed=1;
    IF @EmployeeID=@RequesterID AND @Current='Resolved' AND @NextStatus='Closed' SET @Allowed=1;
    IF @EmployeeID=@RequesterID AND @Current IN('Resolved','Closed') AND @NextStatus='Reopened'
       AND EXISTS(SELECT 1 FROM dbo.HelpdeskTicket WHERE TicketID=@TicketID AND (ReopenUntil IS NULL OR ReopenUntil>=SYSUTCDATETIME())) SET @Allowed=1;
    IF @EmployeeID=@RequesterID AND @Current IN('New','Pending Approval') AND @NextStatus='Cancelled' SET @Allowed=1;
    IF @Allowed=0 RETURN 0;
    UPDATE dbo.HelpdeskTicket SET StatusCode=@NextStatus,UpdatedOn=SYSUTCDATETIME(),
      ResolvedOn=CASE WHEN @NextStatus='Resolved' THEN SYSUTCDATETIME() ELSE ResolvedOn END,
      ClosedOn=CASE WHEN @NextStatus='Closed' THEN SYSUTCDATETIME() ELSE NULL END,
      ReopenUntil=CASE WHEN @NextStatus='Resolved' THEN DATEADD(DAY,7,SYSUTCDATETIME()) ELSE ReopenUntil END,
      ResolutionSummary=CASE WHEN @NextStatus='Resolved' THEN @Comment ELSE ResolutionSummary END
    WHERE TicketID=@TicketID;
    INSERT dbo.HelpdeskAudit(TicketID,EventCode,OldValue,NewValue,Comment,PerformedBy)
    VALUES(@TicketID,'Status',@Current,@NextStatus,@Comment,@EmployeeID);
    RETURN @TicketID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_ApprovalDecision @TicketID INT,@ApproverID INT,@Decision VARCHAR(20),@Comment NVARCHAR(MAX)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @Decision NOT IN('Approved','Rejected') OR NOT EXISTS(SELECT 1 FROM dbo.HelpdeskTicket WHERE TicketID=@TicketID AND ApproverID=@ApproverID AND StatusCode='Pending Approval') RETURN 0;
    INSERT dbo.HelpdeskApproval(TicketID,ApproverID,DecisionCode,DecisionComment) VALUES(@TicketID,@ApproverID,@Decision,@Comment);
    UPDATE dbo.HelpdeskTicket SET StatusCode=CASE WHEN @Decision='Approved' THEN 'New' ELSE 'Rejected' END,UpdatedOn=SYSUTCDATETIME() WHERE TicketID=@TicketID;
    INSERT dbo.HelpdeskAudit(TicketID,EventCode,OldValue,NewValue,Comment,PerformedBy)
    VALUES(@TicketID,'Approval','Pending Approval',@Decision,@Comment,@ApproverID);
    RETURN @TicketID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_AdminCategories @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@EmployeeID AND RoleCode='Admin' AND IsActive=1) RETURN;
    SELECT * FROM dbo.HelpdeskCategory ORDER BY DepartmentName,CategoryName;
    SELECT * FROM dbo.HelpdeskSlaPolicy ORDER BY CASE PriorityCode WHEN 'Critical' THEN 1 WHEN 'High' THEN 2 WHEN 'Medium' THEN 3 ELSE 4 END;
    SELECT * FROM dbo.HelpdeskAgent ORDER BY RoleCode,DisplayName;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_SaveCategory
 @EmployeeID INT,@CategoryID INT,@CategoryName NVARCHAR(150),@DepartmentID INT,@DepartmentName NVARCHAR(150),
 @DefaultPriority VARCHAR(20),@ApprovalMode VARCHAR(20),@DefaultApproverID INT=NULL,@IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@EmployeeID AND RoleCode='Admin' AND IsActive=1) RETURN 0;
    IF @CategoryID=0
    BEGIN
      INSERT dbo.HelpdeskCategory(CategoryName,DepartmentID,DepartmentName,DefaultPriority,ApprovalMode,DefaultApproverID,IsActive,CreatedBy)
      VALUES(@CategoryName,@DepartmentID,@DepartmentName,@DefaultPriority,@ApprovalMode,NULLIF(@DefaultApproverID,0),@IsActive,@EmployeeID);
      RETURN SCOPE_IDENTITY();
    END;
    UPDATE dbo.HelpdeskCategory SET CategoryName=@CategoryName,DepartmentID=@DepartmentID,DepartmentName=@DepartmentName,
      DefaultPriority=@DefaultPriority,ApprovalMode=@ApprovalMode,DefaultApproverID=NULLIF(@DefaultApproverID,0),IsActive=@IsActive
    WHERE CategoryID=@CategoryID;
    IF @@ROWCOUNT=0 RETURN 0;
    RETURN @CategoryID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_SaveSla
 @EmployeeID INT,@SlaPolicyID INT,@PolicyName NVARCHAR(120),@PriorityCode VARCHAR(20),
 @FirstResponseMins INT,@ResolutionMins INT,@IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@EmployeeID AND RoleCode='Admin' AND IsActive=1) RETURN 0;
    IF @SlaPolicyID=0
    BEGIN
      INSERT dbo.HelpdeskSlaPolicy(PolicyName,PriorityCode,FirstResponseMins,ResolutionMins,IsActive)
      VALUES(@PolicyName,@PriorityCode,@FirstResponseMins,@ResolutionMins,@IsActive);
      RETURN SCOPE_IDENTITY();
    END;
    UPDATE dbo.HelpdeskSlaPolicy SET PolicyName=@PolicyName,PriorityCode=@PriorityCode,
      FirstResponseMins=@FirstResponseMins,ResolutionMins=@ResolutionMins,IsActive=@IsActive WHERE SlaPolicyID=@SlaPolicyID;
    IF @@ROWCOUNT=0 RETURN 0;
    RETURN @SlaPolicyID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Helpdesk_SaveAgent
 @EmployeeID INT,@AgentID INT,@AgentEmployeeID INT,@DisplayName NVARCHAR(150),@DepartmentID INT=NULL,@RoleCode VARCHAR(20),@IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS(SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@EmployeeID AND RoleCode='Admin' AND IsActive=1) RETURN 0;
    IF @AgentID=0
    BEGIN
      INSERT dbo.HelpdeskAgent(EmployeeID,DepartmentID,DisplayName,RoleCode,IsActive)
      VALUES(@AgentEmployeeID,NULLIF(@DepartmentID,0),@DisplayName,@RoleCode,@IsActive);
      RETURN SCOPE_IDENTITY();
    END;
    UPDATE dbo.HelpdeskAgent SET EmployeeID=@AgentEmployeeID,DepartmentID=NULLIF(@DepartmentID,0),
      DisplayName=@DisplayName,RoleCode=@RoleCode,IsActive=@IsActive WHERE AgentID=@AgentID;
    IF @@ROWCOUNT=0 RETURN 0;
    RETURN @AgentID;
END;
GO

/*
Required initial configuration:
INSERT dbo.HelpdeskAgent(EmployeeID,DepartmentID,DisplayName,RoleCode)
VALUES(<admin employee id>,NULL,'Helpdesk Administrator','Admin'),
      (<IT supervisor employee id>,7,'IT Supervisor','Supervisor'),
      (<IT agent employee id>,7,'IT Agent','Agent');
*/
