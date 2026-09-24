/*
    Creates a consolidated version of the existing monthly Summary procedure.
    The source procedure remains unchanged. Its body is reused so employee access,
    hierarchy, domain/subdomain, date and grading-source logic stay identical.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @SourceDefinition nvarchar(max) =
    OBJECT_DEFINITION(OBJECT_ID(N'dbo.usp_GetOverAllUserPerformance_WithTrainingandPractice'));

IF @SourceDefinition IS NULL
    THROW 50000, 'Source procedure dbo.usp_GetOverAllUserPerformance_WithTrainingandPractice was not found.', 1;

DECLARE @OldProcedureName nvarchar(256) = N'usp_GetOverAllUserPerformance_WithTrainingandPractice';
DECLARE @NewProcedureName nvarchar(256) = N'usp_GetOverAllUserPerformance_Consolidated';
DECLARE @OldFinalSelect nvarchar(max) = N'select * from #All';
DECLARE @NewFinalSelect nvarchar(max) = N'
SELECT
    Code,
    MAX(EmployeeName) AS EmployeeName,
    MAX(Employee) AS Employee,
    MAX(Subdomain) AS Subdomain,
    SUM(LoanCount) AS LoanCount,
    SUM(TrainingProduction) AS TrainingProduction,
    SUM(PracticeProduction) AS PracticeProduction,
    CAST(AVG(CAST(ProdPerc AS decimal(18,4))) AS decimal(18,2)) AS ProdPerc,
    CAST(AVG(CAST(QualityPerc AS decimal(18,4))) AS decimal(18,2)) AS QualityPerc,
    CAST(AVG(CAST(AttPerc AS decimal(18,4))) AS decimal(18,2)) AS AttPerc
INTO #Consolidated
FROM #All
GROUP BY Code;

SELECT
    C.Code,
    C.EmployeeName,
    C.Employee,
    C.LoanCount,
    C.TrainingProduction,
    C.PracticeProduction,
    C.ProdPerc,
    C.QualityPerc,
    C.AttPerc,
    CASE WHEN C.ProdPerc >= CAST(CASE WHEN C.Subdomain IN (''Credit'',''Servicing'',''Securitization'') THEN GU.ProdFromA ELSE G.ProdFromA END AS decimal(18,2)) THEN ''A''
         WHEN C.ProdPerc >= CAST(CASE WHEN C.Subdomain IN (''Credit'',''Servicing'',''Securitization'') THEN GU.ProdBFrom ELSE G.ProdBFrom END AS decimal(18,2)) THEN ''B''
         WHEN C.ProdPerc >= CAST(CASE WHEN C.Subdomain IN (''Credit'',''Servicing'',''Securitization'') THEN GU.ProdCFrom ELSE G.ProdCFrom END AS decimal(18,2)) THEN ''C''
         ELSE CAST(C.ProdPerc AS nvarchar(100)) END AS ProdGrade,
    CASE WHEN C.QualityPerc >= CAST(CASE WHEN C.Subdomain IN (''Credit'',''Servicing'',''Securitization'') THEN GU.QuaAFrom ELSE G.QuaAFrom END AS decimal(18,2)) THEN ''A''
         WHEN C.QualityPerc >= CAST(CASE WHEN C.Subdomain IN (''Credit'',''Servicing'',''Securitization'') THEN GU.QuaBFrom ELSE G.QuaBFrom END AS decimal(18,2)) THEN ''B''
         WHEN C.QualityPerc >= CAST(CASE WHEN C.Subdomain IN (''Credit'',''Servicing'',''Securitization'') THEN GU.QuaCFrom ELSE G.QuaCFrom END AS decimal(18,2)) THEN ''C''
         ELSE CAST(C.QualityPerc AS nvarchar(100)) END AS QualGrade,
    CASE WHEN C.AttPerc >= CAST(CASE WHEN C.Subdomain IN (''Credit'',''Servicing'',''Securitization'') THEN GU.AttnAFrom ELSE G.AttnAFrom END AS decimal(18,2)) THEN ''A''
         WHEN C.AttPerc >= CAST(CASE WHEN C.Subdomain IN (''Credit'',''Servicing'',''Securitization'') THEN GU.AttnBFrom ELSE G.AttnBFrom END AS decimal(18,2)) THEN ''B''
         WHEN C.AttPerc >= CAST(CASE WHEN C.Subdomain IN (''Credit'',''Servicing'',''Securitization'') THEN GU.AttnCFrom ELSE G.AttnCFrom END AS decimal(18,2)) THEN ''C''
         ELSE CAST(C.AttPerc AS nvarchar(100)) END AS AttnGrade
FROM #Consolidated C
LEFT JOIN GradingMaster_Underwriting GU
    ON GU.Branch = 2 AND C.Subdomain IN (''Credit'',''Servicing'',''Securitization'')
LEFT JOIN GradingMaster G
    ON G.Branch = 2 AND C.Subdomain NOT IN (''Credit'',''Servicing'',''Securitization'');

DROP TABLE #Consolidated;';

DECLARE @ReverseFinalSelectPosition int = CHARINDEX(REVERSE(@OldFinalSelect), REVERSE(@SourceDefinition));

IF @ReverseFinalSelectPosition = 0
    THROW 50001, 'The source procedure final SELECT marker was not found.', 1;

DECLARE @FinalSelectPosition int =
    LEN(@SourceDefinition) - @ReverseFinalSelectPosition - LEN(@OldFinalSelect) + 2;

SET @SourceDefinition = STUFF(
    @SourceDefinition,
    @FinalSelectPosition,
    LEN(@OldFinalSelect),
    @NewFinalSelect);
SET @SourceDefinition = STUFF(
    @SourceDefinition,
    CHARINDEX(@OldProcedureName, @SourceDefinition),
    LEN(@OldProcedureName),
    @NewProcedureName);

IF OBJECT_ID(N'dbo.usp_GetOverAllUserPerformance_Consolidated', N'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetOverAllUserPerformance_Consolidated;

EXEC sys.sp_executesql @SourceDefinition;
