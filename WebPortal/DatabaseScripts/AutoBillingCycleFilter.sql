/* Adds the UI-selected billing cycle to all non-underwriting Auto Billing reports. */
SET NOCOUNT ON;

IF OBJECT_ID('dbo.usp_GetAutoBilledFTEProjects','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.usp_GetAutoBilledFTEProjects AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_GetAutoBilledFTEProjects
    @BillingCycle nvarchar(25)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT P.ProjectID, LTRIM(RTRIM(P.ProjectName)) ProjectName
    FROM dbo.ClientFeedback CF
    INNER JOIN dbo.Project P ON P.ProjectID=CF.ProjectID
    WHERE LTRIM(RTRIM(P.ProjectName)) IN
          ('282-002','6007-002','6011','6013-002','3006','733-003','757-004','757-005','791-001')
      AND EXISTS(SELECT 1 FROM dbo.FTEConfiguration F WHERE F.ProjectID=CF.ProjectID)
      AND ISNULL(NULLIF(LOWER(LTRIM(RTRIM(CONVERT(nvarchar(50),CF.Status)))),''),'active') NOT IN ('0','false','inactive','deleted')
      AND LOWER(REPLACE(REPLACE(LTRIM(RTRIM(CF.BillingCycle)),'-',''),' ',''))=
          LOWER(REPLACE(REPLACE(LTRIM(RTRIM(@BillingCycle)),'-',''),' ',''))
    ORDER BY ProjectName;
END
GO

DECLARE @Procedures table (Name sysname);
INSERT @Procedures (Name) VALUES
('usp_GetAutoBilledCommitmentProjects'),
('usp_GetAutoBilledValuationProjects'),
('usp_GetAutoBilledFreightProjects');

DECLARE @Name sysname, @Definition nvarchar(max);
DECLARE procedures_cursor CURSOR LOCAL FAST_FORWARD FOR SELECT Name FROM @Procedures;
OPEN procedures_cursor;
FETCH NEXT FROM procedures_cursor INTO @Name;
WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @Definition = OBJECT_DEFINITION(OBJECT_ID(N'dbo.' + @Name));
    IF @Definition IS NOT NULL
    BEGIN
        SET @Definition = REPLACE(@Definition, 'CREATE PROCEDURE', 'ALTER PROCEDURE');
        SET @Definition = REPLACE(@Definition, 'CREATE procedure', 'ALTER PROCEDURE');
        SET @Definition = REPLACE(@Definition, 'create procedure', 'ALTER PROCEDURE');

        /* Remove additions made by the earlier script from inner sp_executesql declarations,
           then add the parameter only to the first @To date (the procedure signature). */
        SET @Definition = REPLACE(@Definition, ', @BillingCycle nvarchar(25)', '');
        DECLARE @ToPosition int = CHARINDEX('@To date', @Definition);
        IF @ToPosition = 0 THROW 50002, 'Auto Billing procedure signature was not found.', 1;
        SET @Definition = STUFF(@Definition, @ToPosition + LEN('@To date'), 0, ', @BillingCycle nvarchar(25)');

        /* Existing procedures use alias C for ClientFeedback. */
        SET @Definition = REPLACE(@Definition,
            'C.BillingCycle=''Bi-Monthly''',
            'LOWER(REPLACE(REPLACE(LTRIM(RTRIM(C.BillingCycle)),''-'',''''),'' '','''')) = LOWER(REPLACE(REPLACE(LTRIM(RTRIM(@BillingCycle)),''-'',''''),'' '',''''))');

        IF CHARINDEX('@BillingCycle', @Definition) = 0
           OR CHARINDEX('LTRIM(RTRIM(@BillingCycle))', @Definition) = 0
           OR CHARINDEX('BillingCycle=''Bi-Monthly''', @Definition) > 0
            THROW 50001, 'Auto Billing procedure does not match the expected definition.', 1;

        EXEC sys.sp_executesql @Definition;
    END;
    FETCH NEXT FROM procedures_cursor INTO @Name;
END;
CLOSE procedures_cursor;
DEALLOCATE procedures_cursor;
GO

/* Keep Send Auto Billing validation/update aligned with the Valuation report. */
ALTER PROCEDURE dbo.usp_UpdateAutoBilledValuationProject
 @ProjectName nvarchar(100),@From date,@To date,@ExpectedCount int,@BillingAddedBy int
AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 DECLARE @ProjectID int,@DateColumn sysname,@StatusColumn sysname,@ActualCount int=0,@UpdatedCount int=0,@Sql nvarchar(max),@BillingPeriod nvarchar(100);
 SELECT @ProjectID=P.ProjectID FROM dbo.Project P JOIN dbo.ClientFeedback C ON C.ProjectID=P.ProjectID AND C.DomainId=4 WHERE P.ProjectName=@ProjectName;
 IF @ProjectID IS NULL BEGIN SELECT CAST(0 AS bit)Success,@ProjectName ProjectName,@ExpectedCount ExpectedCount,0 ActualCount,0 UpdatedCount,'Valuation project configuration not found.'Reason;RETURN;END;
 SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatched Date');IF NULLIF(@DateColumn,'')IS NULL SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatch Date');IF NULLIF(@DateColumn,'')IS NULL SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'System Delivered Time');IF NULLIF(@DateColumn,'')IS NULL SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Delivered DateTime');
 IF @ProjectID=614 SELECT @StatusColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Final Status');
 IF NULLIF(@DateColumn,'')IS NULL BEGIN SELECT CAST(0 AS bit)Success,@ProjectName ProjectName,@ExpectedCount ExpectedCount,0 ActualCount,0 UpdatedCount,'Delivery date mapping not found.'Reason;RETURN;END;
 SET @BillingPeriod=REPLACE(CONVERT(nvarchar(11),@From,106),' ','-')+' ~ '+REPLACE(CONVERT(nvarchar(11),@To,106),' ','-');BEGIN TRANSACTION;
 SET @Sql=N'SELECT @Actual=COUNT(1) FROM Valuation.dbo.WBT_TrackingSheet T WITH(UPDLOCK,HOLDLOCK) WHERE T.ProjectID=@ProjectID AND NULLIF(LTRIM(RTRIM(T.BillingPeriod)),'''') IS NULL AND ISDATE(T.'+QUOTENAME(@DateColumn)+N')=1 AND CONVERT(date,T.'+QUOTENAME(@DateColumn)+N') BETWEEN @From AND @To'+CASE WHEN @ProjectID=614 AND NULLIF(@StatusColumn,'') IS NOT NULL THEN N' AND LOWER(LTRIM(RTRIM(CONVERT(nvarchar(100),T.'+QUOTENAME(@StatusColumn)+N')))) NOT IN (''cancelled'',''canceled'')' ELSE N'' END+N';';
 EXEC sys.sp_executesql @Sql,N'@ProjectID int,@From date,@To date,@Actual int OUTPUT',@ProjectID,@From,@To,@ActualCount OUTPUT;
 IF @ActualCount<>@ExpectedCount BEGIN ROLLBACK;SELECT CAST(0 AS bit)Success,@ProjectName ProjectName,@ExpectedCount ExpectedCount,@ActualCount ActualCount,0 UpdatedCount,'Displayed and update counts do not match.'Reason;RETURN;END;
 SET @Sql=N'UPDATE T SET IsVerify=1,BillingPeriod=@BillingPeriod,BillingAddedBy=CONVERT(nvarchar(100),@BillingAddedBy),BillingAddedDate=REPLACE(CONVERT(nvarchar(11),GETDATE(),106),'' '',''-'') FROM Valuation.dbo.WBT_TrackingSheet T WHERE T.ProjectID=@ProjectID AND NULLIF(LTRIM(RTRIM(T.BillingPeriod)),'''') IS NULL AND ISDATE(T.'+QUOTENAME(@DateColumn)+N')=1 AND CONVERT(date,T.'+QUOTENAME(@DateColumn)+N') BETWEEN @From AND @To'+CASE WHEN @ProjectID=614 AND NULLIF(@StatusColumn,'') IS NOT NULL THEN N' AND LOWER(LTRIM(RTRIM(CONVERT(nvarchar(100),T.'+QUOTENAME(@StatusColumn)+N')))) NOT IN (''cancelled'',''canceled'')' ELSE N'' END+N';SET @Updated=@@ROWCOUNT;';
 EXEC sys.sp_executesql @Sql,N'@ProjectID int,@From date,@To date,@BillingPeriod nvarchar(100),@BillingAddedBy int,@Updated int OUTPUT',@ProjectID,@From,@To,@BillingPeriod,@BillingAddedBy,@UpdatedCount OUTPUT;
 IF @UpdatedCount<>@ExpectedCount BEGIN ROLLBACK;SELECT CAST(0 AS bit)Success,@ProjectName ProjectName,@ExpectedCount ExpectedCount,@ActualCount ActualCount,@UpdatedCount UpdatedCount,'Updated count does not match displayed count.'Reason;RETURN;END;
 COMMIT;SELECT CAST(1 AS bit)Success,@ProjectName ProjectName,@ExpectedCount ExpectedCount,@ActualCount ActualCount,@UpdatedCount UpdatedCount,''Reason;
END
GO
