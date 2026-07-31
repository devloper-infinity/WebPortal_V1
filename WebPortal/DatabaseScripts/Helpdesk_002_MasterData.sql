/*
    Standard Helpdesk master data
    Safe to run repeatedly. Existing customized descriptions remain unchanged.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.HelpdeskStatusMaster','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskStatusMaster
    (
        StatusCode       VARCHAR(30) NOT NULL PRIMARY KEY,
        StatusName       NVARCHAR(80) NOT NULL,
        SortOrder        INT NOT NULL,
        StatusGroup      VARCHAR(20) NOT NULL,
        IsRequesterState BIT NOT NULL DEFAULT(0),
        IsTerminal       BIT NOT NULL DEFAULT(0),
        IsActive         BIT NOT NULL DEFAULT(1)
    );
END;
GO

MERGE dbo.HelpdeskStatusMaster AS target
USING (VALUES
 ('New','New',10,'Open',1,0,1),
 ('Pending Approval','Pending Approval',20,'Approval',1,0,1),
 ('Rejected','Rejected',30,'Closed',1,1,1),
 ('Assigned','Assigned',40,'Open',0,0,1),
 ('In Progress','In Progress',50,'Open',0,0,1),
 ('Waiting for User','Waiting for User',60,'Waiting',1,0,1),
 ('Waiting for Vendor','Waiting for Vendor',70,'Waiting',0,0,1),
 ('Resolved','Resolved - Awaiting Confirmation',80,'Resolved',1,0,1),
 ('Closed','Closed',90,'Closed',1,1,1),
 ('Reopened','Reopened',100,'Open',1,0,1),
 ('Cancelled','Cancelled',110,'Closed',1,1,1)
) source(StatusCode,StatusName,SortOrder,StatusGroup,IsRequesterState,IsTerminal,IsActive)
ON target.StatusCode=source.StatusCode
WHEN NOT MATCHED THEN
 INSERT(StatusCode,StatusName,SortOrder,StatusGroup,IsRequesterState,IsTerminal,IsActive)
 VALUES(source.StatusCode,source.StatusName,source.SortOrder,source.StatusGroup,source.IsRequesterState,source.IsTerminal,source.IsActive);
GO

IF OBJECT_ID('dbo.HelpdeskPriorityMaster','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskPriorityMaster
    (
        PriorityCode VARCHAR(20) NOT NULL PRIMARY KEY,
        PriorityName NVARCHAR(50) NOT NULL,
        SortOrder    INT NOT NULL,
        ColourHex    CHAR(7) NOT NULL,
        IsActive     BIT NOT NULL DEFAULT(1)
    );
END;
GO

MERGE dbo.HelpdeskPriorityMaster AS target
USING (VALUES
 ('Critical','Critical',1,'#C33B3B',1),
 ('High','High',2,'#B86A00',1),
 ('Medium','Medium',3,'#246BFD',1),
 ('Low','Low',4,'#66758A',1)
) source(PriorityCode,PriorityName,SortOrder,ColourHex,IsActive)
ON target.PriorityCode=source.PriorityCode
WHEN NOT MATCHED THEN INSERT VALUES(source.PriorityCode,source.PriorityName,source.SortOrder,source.ColourHex,source.IsActive);
GO

IF OBJECT_ID('dbo.HelpdeskImpactMaster','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskImpactMaster
    (
        ImpactCode VARCHAR(20) NOT NULL PRIMARY KEY,
        ImpactName NVARCHAR(80) NOT NULL,
        Weight     INT NOT NULL,
        SortOrder  INT NOT NULL,
        IsActive   BIT NOT NULL DEFAULT(1)
    );
END;
GO

MERGE dbo.HelpdeskImpactMaster AS target
USING (VALUES
 ('Individual','Single user',1,1,1),
 ('Team','Multiple users / team',2,2,1),
 ('Department','Entire department',3,3,1),
 ('Company','Company-wide',4,4,1)
) source(ImpactCode,ImpactName,Weight,SortOrder,IsActive)
ON target.ImpactCode=source.ImpactCode
WHEN NOT MATCHED THEN INSERT VALUES(source.ImpactCode,source.ImpactName,source.Weight,source.SortOrder,source.IsActive);
GO

IF OBJECT_ID('dbo.HelpdeskUrgencyMaster','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskUrgencyMaster
    (
        UrgencyCode VARCHAR(20) NOT NULL PRIMARY KEY,
        UrgencyName NVARCHAR(80) NOT NULL,
        Weight      INT NOT NULL,
        SortOrder   INT NOT NULL,
        IsActive    BIT NOT NULL DEFAULT(1)
    );
END;
GO

MERGE dbo.HelpdeskUrgencyMaster AS target
USING (VALUES
 ('Low','Work can continue',1,1,1),
 ('Medium','Work is degraded',2,2,1),
 ('High','Work is significantly blocked',3,3,1),
 ('Critical','Complete outage or security incident',4,4,1)
) source(UrgencyCode,UrgencyName,Weight,SortOrder,IsActive)
ON target.UrgencyCode=source.UrgencyCode
WHEN NOT MATCHED THEN INSERT VALUES(source.UrgencyCode,source.UrgencyName,source.Weight,source.SortOrder,source.IsActive);
GO

IF OBJECT_ID('dbo.HelpdeskRoleMaster','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskRoleMaster
    (
        RoleCode VARCHAR(20) NOT NULL PRIMARY KEY,
        RoleName NVARCHAR(80) NOT NULL,
        CanTriage BIT NOT NULL,
        CanConfigure BIT NOT NULL,
        SortOrder INT NOT NULL,
        IsActive BIT NOT NULL DEFAULT(1)
    );
END;
GO

MERGE dbo.HelpdeskRoleMaster AS target
USING (VALUES
 ('Agent','IT Agent',0,0,3,1),
 ('Supervisor','IT Supervisor',1,0,2,1),
 ('Admin','Helpdesk Administrator',1,1,1,1)
) source(RoleCode,RoleName,CanTriage,CanConfigure,SortOrder,IsActive)
ON target.RoleCode=source.RoleCode
WHEN NOT MATCHED THEN INSERT VALUES(source.RoleCode,source.RoleName,source.CanTriage,source.CanConfigure,source.SortOrder,source.IsActive);
GO

IF OBJECT_ID('dbo.HelpdeskApprovalModeMaster','U') IS NULL
BEGIN
    CREATE TABLE dbo.HelpdeskApprovalModeMaster
    (
        ApprovalMode VARCHAR(20) NOT NULL PRIMARY KEY,
        ApprovalName NVARCHAR(80) NOT NULL,
        SortOrder INT NOT NULL,
        IsActive BIT NOT NULL DEFAULT(1)
    );
END;
GO

MERGE dbo.HelpdeskApprovalModeMaster AS target
USING (VALUES
 ('None','No approval required',1,1),
 ('Manager','Requester reporting manager',2,1),
 ('Specific','Configured approver',3,1)
) source(ApprovalMode,ApprovalName,SortOrder,IsActive)
ON target.ApprovalMode=source.ApprovalMode
WHEN NOT MATCHED THEN INSERT VALUES(source.ApprovalMode,source.ApprovalName,source.SortOrder,source.IsActive);
GO

/* SLA master data */
MERGE dbo.HelpdeskSlaPolicy AS target
USING (VALUES
 ('Critical Incident SLA','Critical',15,120,1),
 ('High Priority SLA','High',60,480,1),
 ('Standard SLA','Medium',240,1440,1),
 ('Low Priority SLA','Low',480,2880,1)
) source(PolicyName,PriorityCode,FirstResponseMins,ResolutionMins,IsActive)
ON target.PriorityCode=source.PriorityCode AND target.IsActive=1
WHEN NOT MATCHED THEN
 INSERT(PolicyName,PriorityCode,FirstResponseMins,ResolutionMins,IsActive)
 VALUES(source.PolicyName,source.PriorityCode,source.FirstResponseMins,source.ResolutionMins,source.IsActive);
GO

/* IT category master data. DepartmentID 7 follows the existing ticket module. */
MERGE dbo.HelpdeskCategory AS target
USING (VALUES
 ('Hardware',7,'IT','Medium','None',CAST(NULL AS INT),1),
 ('Software / Application',7,'IT','Medium','None',CAST(NULL AS INT),1),
 ('Access / Permission',7,'IT','High','Manager',CAST(NULL AS INT),1),
 ('Network / Internet',7,'IT','High','None',CAST(NULL AS INT),1),
 ('Email / Microsoft 365',7,'IT','Medium','None',CAST(NULL AS INT),1),
 ('Information Security Incident',7,'IT','Critical','None',CAST(NULL AS INT),1),
 ('New Employee Setup',7,'IT','Medium','Manager',CAST(NULL AS INT),1),
 ('Employee Exit / Access Removal',7,'IT','High','Manager',CAST(NULL AS INT),1),
 ('Printer / Peripheral',7,'IT','Low','None',CAST(NULL AS INT),1),
 ('Other IT Request',7,'IT','Low','None',CAST(NULL AS INT),1)
) source(CategoryName,DepartmentID,DepartmentName,DefaultPriority,ApprovalMode,DefaultApproverID,IsActive)
ON target.DepartmentID=source.DepartmentID AND target.CategoryName=source.CategoryName
WHEN NOT MATCHED THEN
 INSERT(CategoryName,DepartmentID,DepartmentName,DefaultPriority,ApprovalMode,DefaultApproverID,IsActive)
 VALUES(source.CategoryName,source.DepartmentID,source.DepartmentName,source.DefaultPriority,source.ApprovalMode,source.DefaultApproverID,source.IsActive);
GO

/*
    Configure real employees before using IT Workbench.
    Replace NULL values; the block intentionally does nothing until configured.
*/
DECLARE @HelpdeskAdminEmployeeID INT = NULL;
DECLARE @ITSupervisorEmployeeID INT = NULL;
DECLARE @ITAgentEmployeeID INT = NULL;

IF @HelpdeskAdminEmployeeID IS NOT NULL AND NOT EXISTS
   (SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@HelpdeskAdminEmployeeID AND DepartmentID IS NULL)
    INSERT dbo.HelpdeskAgent(EmployeeID,DepartmentID,DisplayName,RoleCode)
    VALUES(@HelpdeskAdminEmployeeID,NULL,'Helpdesk Administrator','Admin');

IF @ITSupervisorEmployeeID IS NOT NULL AND NOT EXISTS
   (SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@ITSupervisorEmployeeID AND DepartmentID=7)
    INSERT dbo.HelpdeskAgent(EmployeeID,DepartmentID,DisplayName,RoleCode)
    VALUES(@ITSupervisorEmployeeID,7,'IT Supervisor','Supervisor');

IF @ITAgentEmployeeID IS NOT NULL AND NOT EXISTS
   (SELECT 1 FROM dbo.HelpdeskAgent WHERE EmployeeID=@ITAgentEmployeeID AND DepartmentID=7)
    INSERT dbo.HelpdeskAgent(EmployeeID,DepartmentID,DisplayName,RoleCode)
    VALUES(@ITAgentEmployeeID,7,'IT Agent','Agent');
GO
