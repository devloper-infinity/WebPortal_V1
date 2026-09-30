SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF OBJECT_ID(N'dbo.PendingDataRemark', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PendingDataRemark
    (
        PendingDataRemarkID BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PendingDataRemark PRIMARY KEY,
        EmployeeID INT NOT NULL,
        ProjectID INT NOT NULL,
        OrderNo NVARCHAR(100) NOT NULL,
        Remark NVARCHAR(1000) NOT NULL,
        AddedDate DATETIME2(0) NOT NULL CONSTRAINT DF_PendingDataRemark_AddedDate DEFAULT SYSDATETIME(),
        AddedBy INT NOT NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_PendingDataRemark_IsActive DEFAULT (1),
        ModifiedDate DATETIME2(0) NULL,
        ModifiedBy INT NULL
    );
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.PendingDataRemark') AND name=N'UX_PendingDataRemark_Active')
    CREATE UNIQUE INDEX UX_PendingDataRemark_Active ON dbo.PendingDataRemark(ProjectID, OrderNo) WHERE IsActive=1;

IF OBJECT_ID(N'dbo.usp_getPendingProjects_Core', N'P') IS NULL
BEGIN
    IF OBJECT_ID(N'dbo.usp_getPendingProjects', N'P') IS NULL
        THROW 50010, 'Deploy the existing dbo.usp_getPendingProjects before this migration.', 1;
    EXEC sys.sp_rename N'dbo.usp_getPendingProjects', N'usp_getPendingProjects_Core';
END;

COMMIT TRANSACTION;
GO
IF OBJECT_ID(N'dbo.usp_getPendingProjects', N'P') IS NULL EXEC(N'CREATE PROCEDURE dbo.usp_getPendingProjects AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_getPendingProjects @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    CREATE TABLE #Pending(ProjectID INT, ProjectName NVARCHAR(200), OrderNo NVARCHAR(100), OrderDate DATE, MissingField NVARCHAR(200));
    INSERT #Pending(ProjectID,ProjectName,OrderNo,OrderDate,MissingField)
        EXEC dbo.usp_getPendingProjects_Core @EmployeeID=@EmployeeID;
    SELECT DISTINCT p.ProjectID,p.ProjectName,p.OrderNo,p.OrderDate,p.MissingField
    FROM #Pending p
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.PendingDataRemark r
        WHERE r.ProjectID=p.ProjectID
          AND LTRIM(RTRIM(r.OrderNo))=LTRIM(RTRIM(p.OrderNo))
          AND r.IsActive=1
    )
    ORDER BY p.ProjectName,p.OrderDate,p.MissingField;
END;
GO
IF OBJECT_ID(N'dbo.usp_AddPendingDataRemark', N'P') IS NULL EXEC(N'CREATE PROCEDURE dbo.usp_AddPendingDataRemark AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_AddPendingDataRemark
    @EmployeeID INT, @ProjectID INT, @OrderNo NVARCHAR(100), @Remark NVARCHAR(1000), @AddedBy INT
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    SET @OrderNo=LTRIM(RTRIM(@OrderNo)); SET @Remark=LTRIM(RTRIM(@Remark));
    IF @EmployeeID<=0 OR @ProjectID<=0 OR NULLIF(@OrderNo,N'') IS NULL OR LEN(@Remark)<3 OR LEN(@Remark)>1000
        THROW 50011, 'Valid project, order/loan and reason are required.', 1;
    CREATE TABLE #CurrentPending(ProjectID INT, ProjectName NVARCHAR(200), OrderNo NVARCHAR(100), OrderDate DATE, MissingField NVARCHAR(200));
    INSERT #CurrentPending(ProjectID,ProjectName,OrderNo,OrderDate,MissingField)
        EXEC dbo.usp_getPendingProjects_Core @EmployeeID=@EmployeeID;
    IF NOT EXISTS (SELECT 1 FROM #CurrentPending WHERE ProjectID=@ProjectID AND OrderNo=@OrderNo)
        THROW 50013, 'This project and order/loan is no longer pending. Refresh the list.', 1;
    BEGIN TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM dbo.PendingDataRemark WITH(UPDLOCK,HOLDLOCK) WHERE ProjectID=@ProjectID AND OrderNo=@OrderNo AND IsActive=1)
        INSERT dbo.PendingDataRemark(EmployeeID,ProjectID,OrderNo,Remark,AddedBy) VALUES(@EmployeeID,@ProjectID,@OrderNo,@Remark,@AddedBy);
    ELSE
        THROW 50012, 'An active pending remark already exists for this project and order/loan.', 1;
    COMMIT TRANSACTION;
END;
GO
IF OBJECT_ID(N'dbo.usp_GetPendingDataRemarkHistory', N'P') IS NULL EXEC(N'CREATE PROCEDURE dbo.usp_GetPendingDataRemarkHistory AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_GetPendingDataRemarkHistory @EmployeeID INT, @ProjectID INT, @OrderNo NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT PendingDataRemarkID,Remark,AddedDate,AddedBy,IsActive,ModifiedDate,ModifiedBy
    FROM dbo.PendingDataRemark
    WHERE EmployeeID=@EmployeeID AND ProjectID=@ProjectID AND OrderNo=LTRIM(RTRIM(@OrderNo))
    ORDER BY AddedDate DESC,PendingDataRemarkID DESC;
END;
GO
