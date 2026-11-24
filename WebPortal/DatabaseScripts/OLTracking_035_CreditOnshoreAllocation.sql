/* Credit onshore employees can receive Bulk Allocation work without a
   UserProjectConfiguration row. They also receive capacity limit 0 from the app. */
CREATE OR ALTER FUNCTION dbo.OLTracking_IsCreditOnshoreEmployee
(
    @ProjectID int,
    @UserID int
)
RETURNS bit
AS
BEGIN
    DECLARE @Allowed bit=0;
    IF EXISTS
    (
        SELECT 1
        FROM dbo.Project project
        INNER JOIN dbo.SubDomain subdomain ON subdomain.SubdomainID=project.SubdomainID
        INNER JOIN dbo.EmployeeInfo employee ON employee.EmployeeID=@UserID
        OUTER APPLY
        (
            SELECT TOP (1) configured.PsuedoName
            FROM dbo.EmployeeConfiguration configured
            WHERE configured.EmployeeID=employee.EmployeeID AND configured.IsDelete=0
            ORDER BY configured.EmpConfigrationID DESC
        ) configuration
        WHERE project.ProjectID=@ProjectID
          AND LTRIM(RTRIM(subdomain.SubdomainName))='Credit'
          AND
          (
              LTRIM(RTRIM(CONVERT(nvarchar(20),ISNULL(employee.Company,''))))='6'
              OR LOWER(LTRIM(RTRIM(ISNULL(employee.FirstName,'')+' '+ISNULL(employee.lastName,'')))) IN
                 ('sandy willoughby','sara chullino','damon davis','jonny toves','thomas welsh')
              OR LOWER(LTRIM(RTRIM(ISNULL(configuration.PsuedoName,'')))) IN
                 ('sandy willoughby','sara chullino','damon davis','jonny toves','thomas welsh')
          )
    ) SET @Allowed=1;
    RETURN @Allowed;
END;
GO

/* Patch the installed procedures while retaining their current definitions. */
DECLARE @ProcedureName sysname,@Definition nvarchar(max),@Old nvarchar(max),@New nvarchar(max);
DECLARE procedure_cursor CURSOR LOCAL FAST_FORWARD FOR
SELECT name FROM (VALUES(N'OLTracking_ManagerAllocate'),(N'OLTracking_BulkReassignPending')) procedures(name);
OPEN procedure_cursor;
FETCH NEXT FROM procedure_cursor INTO @ProcedureName;
WHILE @@FETCH_STATUS=0
BEGIN
    SELECT @Definition=OBJECT_DEFINITION(OBJECT_ID(N'dbo.'+@ProcedureName));
    IF @Definition IS NULL THROW 50190,'Required allocation procedure was not found.',1;
    SET @Definition=REPLACE(@Definition,N'CREATE OR ALTER PROCEDURE',N'ALTER PROCEDURE');
    SET @Definition=REPLACE(@Definition,N'CREATE PROCEDURE',N'ALTER PROCEDURE');
    SET @Old=N'IF NOT EXISTS(SELECT 1 FROM dbo.UserProjectConfiguration WHERE ProjectID=@ProjectID AND UserID=@TargetUserID)';
    SET @New=@Old+N' AND dbo.OLTracking_IsCreditOnshoreEmployee(@ProjectID,@TargetUserID)=0';
    IF CHARINDEX(N'OLTracking_IsCreditOnshoreEmployee',@Definition)=0
    BEGIN
        SET @Definition=REPLACE(@Definition,@Old,@New);
        IF CHARINDEX(N'OLTracking_IsCreditOnshoreEmployee',@Definition)=0
            THROW 50191,'The installed allocation procedure could not be patched.',1;
        EXEC sys.sp_executesql @Definition;
    END;
    FETCH NEXT FROM procedure_cursor INTO @ProcedureName;
END;
CLOSE procedure_cursor;
DEALLOCATE procedure_cursor;
GO
