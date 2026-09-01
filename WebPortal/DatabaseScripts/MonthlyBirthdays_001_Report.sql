SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.usp_GetMonthlyBirthdays', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.usp_GetMonthlyBirthdays AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.usp_GetMonthlyBirthdays
    @Month tinyint,
    @BranchID int = 0,
    @DomainID int = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @Month NOT BETWEEN 1 AND 12
    BEGIN
        RAISERROR('Month must be between 1 and 12.', 16, 1);
        RETURN;
    END;

    SELECT
        E.Code,
        LTRIM(RTRIM(CONCAT(E.FirstName, ' ', NULLIF(E.MiddleName, ''), ' ', E.LastName))) AS [Full Name],
        Dates.JoiningDate AS [Joining Date],
        Dates.DateOfBirth AS [Date of Birth],
        B.BranchName AS Branch,
        CONCAT(RM.Code, CASE WHEN RM.Code IS NULL THEN '' ELSE ' : ' END,
               LTRIM(RTRIM(CONCAT(RM.FirstName, ' ', RM.LastName)))) AS [Reporting Manager],
        D.DomainName AS Domain,
        NULLIF(REPLACE(E.SubDomain, 'Select', ''), '') AS Subdomain,
        CASE WHEN AnyResignation.ResignationId IS NULL THEN 'On Floor'
             ELSE NoticePeriod.ResignationType END AS [Current Status],
        DAY(Dates.DateOfBirth) AS BirthDay
    FROM dbo.EmployeeInfo E
    LEFT JOIN dbo.Branch B ON B.BranchID = E.WorkingBranch
    LEFT JOIN dbo.Domain D ON D.DomainID = E.Domain
    LEFT JOIN dbo.ProjectManager PM ON PM.ProjectManagerID = E.ProjectManager
    LEFT JOIN dbo.EmployeeInfo RM ON RM.EmployeeID = PM.ProjectManagerName
    CROSS APPLY
    (
        SELECT
            CASE WHEN ISDATE(E.JoiningDate) = 1 THEN CONVERT(datetime, E.JoiningDate, 106) END AS JoiningDate,
            CASE WHEN ISDATE(E.DateOfBirth) = 1 THEN CONVERT(datetime, E.DateOfBirth, 106) END AS DateOfBirth
    ) Dates
    OUTER APPLY
    (
        SELECT TOP (1) IR.ResignationId
        FROM dbo.InitiateResignation IR
        WHERE IR.EmployeeId = E.EmployeeID
        ORDER BY IR.AddedDate DESC, IR.ResignationId DESC
    ) AnyResignation
    OUTER APPLY
    (
        SELECT TOP (1) IR.ResignationId, IR.ResignationType
        FROM dbo.InitiateResignation IR
        WHERE IR.EmployeeId = E.EmployeeID
          AND IR.status = 'Accept'
          AND IR.LastWorkingDate IS NOT NULL
          AND IR.LastWorkingDate <> ''
          AND CONVERT(datetime, IR.LastWorkingDate, 106) >= CONVERT(date, GETDATE())
        ORDER BY IR.AddedDate DESC, IR.ResignationId DESC
    ) NoticePeriod
    WHERE (E.IsDelete = 0 OR E.IsDelete IS NULL)
      AND E.Company = 1
      AND (AnyResignation.ResignationId IS NULL OR NoticePeriod.ResignationId IS NOT NULL)
      AND MONTH(Dates.DateOfBirth) = @Month
      AND (@BranchID = 0 OR E.WorkingBranch = @BranchID)
      AND (@DomainID = 0 OR E.Domain = @DomainID)
    ORDER BY DAY(Dates.DateOfBirth), [Full Name];
END;
GO
