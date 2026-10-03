ALTER PROCEDURE dbo.usp_GetAllProjectsBillingDetails
    @EmployeeID INT,
    @Month NVARCHAR(100),
    @Year INT,
    @ToDate DATE=NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MonthNo INT = CASE LOWER(LTRIM(RTRIM(@Month)))
        WHEN 'january' THEN 1 WHEN 'february' THEN 2 WHEN 'march' THEN 3
        WHEN 'april' THEN 4 WHEN 'may' THEN 5 WHEN 'june' THEN 6
        WHEN 'july' THEN 7 WHEN 'august' THEN 8 WHEN 'september' THEN 9
        WHEN 'october' THEN 10 WHEN 'november' THEN 11 WHEN 'december' THEN 12 END;
    IF @MonthNo IS NULL OR @Year NOT BETWEEN 2000 AND 9999
    BEGIN
        RAISERROR ('Invalid Month or Year.',16,1);
        RETURN;
    END;

    DECLARE @FromDate DATE=DATEFROMPARTS(@Year,@MonthNo,1), @PeriodTo DATE;
    SET @PeriodTo=EOMONTH(@FromDate);
    IF @ToDate IS NOT NULL AND @ToDate<@PeriodTo SET @PeriodTo=@ToDate;
    DECLARE @ProjectList TABLE(ID INT IDENTITY(1,1) PRIMARY KEY,ProjectID INT,ProjectName NVARCHAR(100));
    DECLARE @ForBilling INT=1,@Columns NVARCHAR(MAX),@SQL NVARCHAR(MAX),@FilterDateColumn SYSNAME,@DispatchDateColumn SYSNAME,@DispatchSelect NVARCHAR(600),@ProjectName NVARCHAR(100),@ProjectID INT;
    DECLARE @BillingCycle NVARCHAR(100),@OrderNoColumn SYSNAME,@OrderDateColumn SYSNAME,@FinalStatusColumn SYSNAME,@FreightFilter NVARCHAR(MAX),@ValuationFilter NVARCHAR(MAX),@RecordToExclusive DATETIME;

    IF @EmployeeID=8133
    BEGIN
        ;WITH LatestInvoice AS
        (
            SELECT IM.ProjectID,
                   ROW_NUMBER() OVER(PARTITION BY IM.ProjectID ORDER BY CONVERT(DATE,IM.AddedDate) DESC,IM.InvoiceID DESC) AS RN
            FROM InfinityBilling.dbo.InfinityBilling_InvoiceMaster IM
            WHERE DATEDIFF(MONTH,CONVERT(DATE,IM.AddedDate),CONVERT(DATE,GETDATE()))<=3
        )
        SELECT DISTINCT U.ProjectID,P.ProjectName
        FROM dbo.UserProjectConfiguration U
        INNER JOIN dbo.Project P ON P.ProjectID=U.ProjectID
        INNER JOIN LatestInvoice IM ON IM.ProjectID=U.ProjectID AND IM.RN=1
        WHERE U.UserID=@EmployeeID
        ORDER BY P.ProjectName;
        RETURN;
    END;

    IF @EmployeeID=9824
    BEGIN
        -- Project 681 is intentionally included directly because a new project may
        -- not yet have an InfinityBilling invoice/configuration row.
        SELECT V.ProjectID,COALESCE(NULLIF(LTRIM(RTRIM(P.ProjectName)),''),V.ProjectName) AS ProjectName
        FROM (VALUES
            (435,CAST('282-002' AS NVARCHAR(100))),
            (632,CAST('6007-002' AS NVARCHAR(100))),
            (681,CAST('6013-002' AS NVARCHAR(100)))
        ) V(ProjectID,ProjectName)
        LEFT JOIN dbo.Project P ON P.ProjectID=V.ProjectID
        ORDER BY CASE V.ProjectID WHEN 435 THEN 1 WHEN 632 THEN 2 ELSE 3 END;
        RETURN;
    END;

    IF @EmployeeID=255
    BEGIN
        ;WITH LatestInvoice AS
        (
            SELECT IM.ProjectID,ROW_NUMBER() OVER(PARTITION BY IM.ProjectID ORDER BY CONVERT(DATE,IM.AddedDate) DESC,IM.InvoiceID DESC) AS RN
            FROM InfinityBilling.dbo.InfinityBilling_InvoiceMaster IM
            INNER JOIN dbo.ClientFeedback CF ON CF.ProjectID=IM.ProjectID
            WHERE DATEDIFF(MONTH,CONVERT(DATE,IM.AddedDate),CONVERT(DATE,GETDATE()))<=3
              AND (CF.DomainId=19 OR (CF.DomainId=34 AND IM.ProjectID=613))
        )
        INSERT @ProjectList(ProjectID,ProjectName)
        SELECT DISTINCT U.ProjectID,P.ProjectName
        FROM dbo.UserProjectConfiguration U
        INNER JOIN dbo.Project P ON P.ProjectID=U.ProjectID
        INNER JOIN LatestInvoice IM ON IM.ProjectID=U.ProjectID AND IM.RN=1
        WHERE U.UserID=@EmployeeID;

        DECLARE c_commitment CURSOR LOCAL FAST_FORWARD FOR SELECT ProjectID,ProjectName FROM @ProjectList ORDER BY ID;
        OPEN c_commitment;
        FETCH NEXT FROM c_commitment INTO @ProjectID,@ProjectName;
        WHILE @@FETCH_STATUS=0
        BEGIN
            SET @Columns=NULL;
            SET @FilterDateColumn=NULL;
            SET @DispatchDateColumn=NULL;
            SET @DispatchSelect=N'';
            SELECT @FilterDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Order Date');
            IF NULLIF(@FilterDateColumn,'') IS NULL
                SELECT @FilterDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'order Date');
            IF NULLIF(@FilterDateColumn,'') IS NULL
                SELECT @FilterDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'OrderDate');
            IF NULLIF(@FilterDateColumn,'') IS NULL
                SELECT @FilterDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Received Date');
            IF NULLIF(@FilterDateColumn,'') IS NULL
                SELECT @FilterDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'ReceivedDate');
            SELECT @DispatchDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatched Date');
            IF NULLIF(@DispatchDateColumn,'') IS NULL
                SELECT @DispatchDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatch Date');
            IF NULLIF(@DispatchDateColumn,'') IS NOT NULL
                SET @DispatchSelect=N', T.'+QUOTENAME(@DispatchDateColumn)+N' AS [__DispatchDate]';

            SELECT @Columns=STUFF((SELECT ', T.'+QUOTENAME(C.ColumnName)+' AS '+QUOTENAME(D.FieldName)
                FROM dbo.WBT_DomianWiseFieldMaster D
                INNER JOIN dbo.WBT_ProjectWiseFieldMaster P ON P.FieldName=D.DomainFieldID
                INNER JOIN dbo.WBT_ColumnMapping CM ON CM.ProjectFieldID=P.ProjectFieldID AND CM.ProjectID=P.ProjectID
                INNER JOIN dbo.WBT_ColumnMaster C ON C.ColumnID=CM.CoumnID
                WHERE CM.ProjectID=@ProjectID AND CM.ForBilling=@ForBilling
                ORDER BY SequenceNo ASC FOR XML PATH(''),TYPE).value('.','NVARCHAR(MAX)'),1,2,'');

            IF NULLIF(@Columns,'') IS NOT NULL AND NULLIF(@FilterDateColumn,'') IS NOT NULL
            BEGIN
                SET @SQL=N'SELECT @ProjectName AS [Project #], @ProjectID AS [__ProjectID], '+@Columns+@DispatchSelect+N'
                    FROM Commitment.dbo.WBT_TrackingSheet T
                    WHERE T.ProjectID=@ProjectID AND T.BillingPeriod IS NULL
                    AND CASE
                            WHEN ISDATE(T.'+QUOTENAME(@FilterDateColumn)+N')=1
                            THEN CONVERT(DATE,T.'+QUOTENAME(@FilterDateColumn)+N')
                        END BETWEEN @FromDate AND @PeriodTo;';
                EXEC sys.sp_executesql @SQL,
                    N'@ProjectName NVARCHAR(100),@ProjectID INT,@FromDate DATE,@PeriodTo DATE',
                    @ProjectName=@ProjectName,@ProjectID=@ProjectID,@FromDate=@FromDate,@PeriodTo=@PeriodTo;
            END;
            FETCH NEXT FROM c_commitment INTO @ProjectID,@ProjectName;
        END;
        CLOSE c_commitment;
        DEALLOCATE c_commitment;
        RETURN;
    END;

    IF @EmployeeID=6
    BEGIN
        ;WITH LatestInvoice AS
        (
            SELECT IM.ProjectID,ROW_NUMBER() OVER(PARTITION BY IM.ProjectID ORDER BY CONVERT(DATE,IM.AddedDate) DESC,IM.InvoiceID DESC) AS RN
            FROM InfinityBilling.dbo.InfinityBilling_InvoiceMaster IM
            INNER JOIN dbo.ClientFeedback CF ON CF.ProjectID=IM.ProjectID
            WHERE DATEDIFF(MONTH,CONVERT(DATE,IM.AddedDate),CONVERT(DATE,GETDATE()))<=3
              AND CF.DomainId=2
        )
        INSERT @ProjectList(ProjectID,ProjectName)
        SELECT DISTINCT U.ProjectID,P.ProjectName
        FROM dbo.UserProjectConfiguration U
        INNER JOIN dbo.Project P ON P.ProjectID=U.ProjectID
        INNER JOIN LatestInvoice IM ON IM.ProjectID=U.ProjectID AND IM.RN=1
        WHERE U.UserID=@EmployeeID
          AND U.ProjectID NOT IN (49,333);

        DECLARE c_freight CURSOR LOCAL FAST_FORWARD FOR SELECT ProjectID,ProjectName FROM @ProjectList ORDER BY ID;
        OPEN c_freight;
        FETCH NEXT FROM c_freight INTO @ProjectID,@ProjectName;
        WHILE @@FETCH_STATUS=0
        BEGIN
            SET @Columns=NULL;
            SET @FilterDateColumn=NULL;
            SET @DispatchDateColumn=NULL;
            SET @DispatchSelect=N'';
            SET @FreightFilter=N'';
            SELECT @FilterDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Order Date');
            IF NULLIF(@FilterDateColumn,'') IS NULL
                SELECT @FilterDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'order Date');
            IF NULLIF(@FilterDateColumn,'') IS NULL
                SELECT @FilterDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'OrderDate');
            IF NULLIF(@FilterDateColumn,'') IS NULL
                SELECT @FilterDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Received Date');
            IF NULLIF(@FilterDateColumn,'') IS NULL
                SELECT @FilterDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'ReceivedDate');
            SELECT @DispatchDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatched Date');
            IF NULLIF(@DispatchDateColumn,'') IS NULL
                SELECT @DispatchDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatch Date');
            IF NULLIF(@DispatchDateColumn,'') IS NOT NULL
                SET @DispatchSelect=N', T.'+QUOTENAME(@DispatchDateColumn)+N' AS [__DispatchDate]';
            IF @ProjectID=47 AND NULLIF(@DispatchDateColumn,'') IS NOT NULL
                SET @FreightFilter=N' AND (NULLIF(LTRIM(RTRIM(CONVERT(NVARCHAR(100),T.'+QUOTENAME(@DispatchDateColumn)+N'))),'''') IS NULL OR (ISDATE(T.'+QUOTENAME(@DispatchDateColumn)+N')=1 AND CONVERT(DATE,T.'+QUOTENAME(@DispatchDateColumn)+N')<=@PeriodTo))';

            SELECT @Columns=STUFF((SELECT ', T.'+QUOTENAME(C.ColumnName)+' AS '+QUOTENAME(D.FieldName)
                FROM dbo.WBT_DomianWiseFieldMaster D
                INNER JOIN dbo.WBT_ProjectWiseFieldMaster P ON P.FieldName=D.DomainFieldID
                INNER JOIN dbo.WBT_ColumnMapping CM ON CM.ProjectFieldID=P.ProjectFieldID AND CM.ProjectID=P.ProjectID
                INNER JOIN dbo.WBT_ColumnMaster C ON C.ColumnID=CM.CoumnID
                WHERE CM.ProjectID=@ProjectID AND CM.ForBilling=@ForBilling
                ORDER BY SequenceNo ASC FOR XML PATH(''),TYPE).value('.','NVARCHAR(MAX)'),1,2,'');

            IF NULLIF(@Columns,'') IS NOT NULL AND NULLIF(@FilterDateColumn,'') IS NOT NULL
            BEGIN
                SET @SQL=N'SELECT @ProjectName AS [Project #], @ProjectID AS [__ProjectID], '+@Columns+@DispatchSelect+N'
                    FROM Commitment.dbo.WBT_TrackingSheet T
                    WHERE T.ProjectID=@ProjectID AND T.BillingPeriod IS NULL
                    AND CASE
                            WHEN ISDATE(T.'+QUOTENAME(@FilterDateColumn)+N')=1
                            THEN CONVERT(DATE,T.'+QUOTENAME(@FilterDateColumn)+N')
                        END BETWEEN @FromDate AND @PeriodTo'+@FreightFilter+N';';
                EXEC sys.sp_executesql @SQL,
                    N'@ProjectName NVARCHAR(100),@ProjectID INT,@FromDate DATE,@PeriodTo DATE',
                    @ProjectName=@ProjectName,@ProjectID=@ProjectID,@FromDate=@FromDate,@PeriodTo=@PeriodTo;
            END;
            FETCH NEXT FROM c_freight INTO @ProjectID,@ProjectName;
        END;
        CLOSE c_freight;
        DEALLOCATE c_freight;
        RETURN;
    END;

    IF @EmployeeID IN (40,318)
    BEGIN
        ;WITH LatestInvoice AS
        (
            SELECT IM.ProjectID,ROW_NUMBER() OVER(PARTITION BY IM.ProjectID ORDER BY CONVERT(DATE,IM.AddedDate) DESC,IM.InvoiceID DESC) AS RN
            FROM InfinityBilling.dbo.InfinityBilling_InvoiceMaster IM
            INNER JOIN dbo.ClientFeedback CF ON CF.ProjectID=IM.ProjectID
            WHERE DATEDIFF(MONTH,CONVERT(DATE,IM.AddedDate),CONVERT(DATE,GETDATE()))<=3
              AND CF.DomainId=4
        )
        INSERT @ProjectList(ProjectID,ProjectName)
        SELECT DISTINCT U.ProjectID,P.ProjectName
        FROM dbo.UserProjectConfiguration U
        INNER JOIN dbo.Project P ON P.ProjectID=U.ProjectID
        INNER JOIN LatestInvoice IM ON IM.ProjectID=U.ProjectID AND IM.RN=1
        WHERE U.UserID=@EmployeeID;

        DECLARE c_valuation CURSOR LOCAL FAST_FORWARD FOR SELECT ProjectID,ProjectName FROM @ProjectList ORDER BY ID;
        OPEN c_valuation;
        FETCH NEXT FROM c_valuation INTO @ProjectID,@ProjectName;
        WHILE @@FETCH_STATUS=0
        BEGIN
            SET @Columns=NULL;
            SET @DispatchDateColumn=NULL;
            SET @DispatchSelect=N'';
            SET @BillingCycle=NULL;
            SET @OrderNoColumn=NULL;
            SET @OrderDateColumn=NULL;
            SET @FinalStatusColumn=NULL;
            SET @ValuationFilter=N'';
            SET @RecordToExclusive=DATEADD(DAY,1,CONVERT(DATETIME,@PeriodTo));
            SELECT TOP 1 @BillingCycle=LTRIM(RTRIM(CF.BillingCycle))
            FROM dbo.ClientFeedback CF
            WHERE CF.ProjectId=@ProjectID AND CF.DomainId=4;
            SELECT @DispatchDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatched Date');
            IF NULLIF(@DispatchDateColumn,'') IS NULL
                SELECT @DispatchDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatch Date');
            IF NULLIF(@DispatchDateColumn,'') IS NULL
                SELECT @DispatchDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'System Delivered Time');
            IF NULLIF(@DispatchDateColumn,'') IS NOT NULL
                SET @DispatchSelect=N', T.'+QUOTENAME(@DispatchDateColumn)+N' AS [__DispatchDate]';

            IF @ProjectID=18
            BEGIN
                SELECT @OrderNoColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Order#');
                IF NULLIF(@OrderNoColumn,'') IS NULL
                    SELECT @OrderNoColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Order #');
                IF NULLIF(@OrderNoColumn,'') IS NULL
                    SELECT @OrderNoColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Order No');
                SELECT @OrderDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Order Date');
                IF NULLIF(@OrderDateColumn,'') IS NULL
                    SELECT @OrderDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'order Date');
                IF NULLIF(@OrderDateColumn,'') IS NULL
                    SELECT @OrderDateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'OrderDate');
                SELECT @FinalStatusColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Final Status');
                IF @Year=2026 AND @MonthNo=9
                    SET @RecordToExclusive=CONVERT(DATETIME,'2026-10-02T00:00:00',126);
                IF NULLIF(@OrderNoColumn,'') IS NOT NULL
                    SET @ValuationFilter=@ValuationFilter+N' AND ISNULL(CONVERT(NVARCHAR(500),T.'+QUOTENAME(@OrderNoColumn)+N'),'''') NOT LIKE ''%-Update[0-9]%''';
                IF NULLIF(@OrderDateColumn,'') IS NOT NULL
                    SET @ValuationFilter=@ValuationFilter+N' AND ISDATE(T.'+QUOTENAME(@OrderDateColumn)+N')=1 AND CONVERT(DATE,T.'+QUOTENAME(@OrderDateColumn)+N')<=EOMONTH(@FromDate)';
                IF NULLIF(@FinalStatusColumn,'') IS NOT NULL
                    SET @ValuationFilter=@ValuationFilter+N' AND ISNULL(LOWER(LTRIM(RTRIM(CONVERT(NVARCHAR(200),T.'+QUOTENAME(@FinalStatusColumn)+N')))),'''') NOT IN (''cancelled'',''canceled'')';
            END;

            SELECT @Columns=STUFF((SELECT ', T.'+QUOTENAME(C.ColumnName)+' AS '+QUOTENAME(D.FieldName)
                FROM dbo.WBT_DomianWiseFieldMaster D
                INNER JOIN dbo.WBT_ProjectWiseFieldMaster P ON P.FieldName=D.DomainFieldID
                INNER JOIN dbo.WBT_ColumnMapping CM ON CM.ProjectFieldID=P.ProjectFieldID AND CM.ProjectID=P.ProjectID
                INNER JOIN dbo.WBT_ColumnMaster C ON C.ColumnID=CM.CoumnID
                WHERE CM.ProjectID=@ProjectID AND CM.ForBilling=@ForBilling
                ORDER BY SequenceNo ASC FOR XML PATH(''),TYPE).value('.','NVARCHAR(MAX)'),1,2,'');

            IF NULLIF(@Columns,'') IS NOT NULL AND NULLIF(@DispatchDateColumn,'') IS NOT NULL
               AND LOWER(ISNULL(@BillingCycle,'')) IN ('monthly','bi-monthly','bimonthly')
            BEGIN
                SET @SQL=N'SELECT @ProjectName AS [Project #], @ProjectID AS [__ProjectID], '+@Columns+@DispatchSelect+N'
                    FROM Valuation.dbo.WBT_TrackingSheet T
                    WHERE T.ProjectID=@ProjectID AND T.BillingPeriod IS NULL
                    AND CASE
                            WHEN ISDATE(T.'+QUOTENAME(@DispatchDateColumn)+N')=1
                            THEN CONVERT(DATETIME,T.'+QUOTENAME(@DispatchDateColumn)+N')
                        END >= CONVERT(DATETIME,@FromDate)
                    AND CASE
                            WHEN ISDATE(T.'+QUOTENAME(@DispatchDateColumn)+N')=1
                            THEN CONVERT(DATETIME,T.'+QUOTENAME(@DispatchDateColumn)+N')
                        END < @RecordToExclusive'+@ValuationFilter+N';';
                EXEC sys.sp_executesql @SQL,
                    N'@ProjectName NVARCHAR(100),@ProjectID INT,@FromDate DATE,@RecordToExclusive DATETIME',
                    @ProjectName=@ProjectName,@ProjectID=@ProjectID,@FromDate=@FromDate,@RecordToExclusive=@RecordToExclusive;
            END;
            FETCH NEXT FROM c_valuation INTO @ProjectID,@ProjectName;
        END;
        CLOSE c_valuation;
        DEALLOCATE c_valuation;
        RETURN;
    END;

    IF @EmployeeID IN (277,6823)
    BEGIN
        ;WITH LatestInvoice AS
        (
            SELECT IM.ProjectID,ROW_NUMBER() OVER(PARTITION BY IM.ProjectID ORDER BY CONVERT(DATE,IM.AddedDate) DESC,IM.InvoiceID DESC) AS RN
            FROM InfinityBilling_UW.dbo.InfinityBilling_InvoiceMaster IM
            WHERE DATEDIFF(MONTH,CONVERT(DATE,IM.AddedDate),CONVERT(DATE,GETDATE()))<=3
        )
        INSERT @ProjectList(ProjectID,ProjectName)
        SELECT DISTINCT U.ProjectID,P.ProjectName
        FROM dbo.UserProjectConfiguration U
        INNER JOIN dbo.Project P ON P.ProjectID=U.ProjectID
        INNER JOIN LatestInvoice IM ON IM.ProjectID=U.ProjectID AND IM.RN=1
        WHERE (@EmployeeID=277 AND P.SubdomainID=19) OR (@EmployeeID=6823 AND P.SubdomainID=15);

        DECLARE c_pro CURSOR LOCAL FAST_FORWARD FOR SELECT ProjectID,ProjectName FROM @ProjectList ORDER BY ID;
        OPEN c_pro;
        FETCH NEXT FROM c_pro INTO @ProjectID,@ProjectName;
        WHILE @@FETCH_STATUS=0
        BEGIN
            SET @Columns=NULL;
            SET @DispatchDateColumn=NULL;
            SET @DispatchSelect=N'';
            SELECT @DispatchDateColumn=ColName FROM dbo.usf_GetColumnNameForReport(@ProjectID,'Dispatched Date');
            IF NULLIF(@DispatchDateColumn,'') IS NULL
                SELECT @DispatchDateColumn=ColName FROM dbo.usf_GetColumnNameForReport(@ProjectID,'Dispatch Date');
            IF NULLIF(@DispatchDateColumn,'') IS NOT NULL
                SET @DispatchSelect=N', T.'+QUOTENAME(@DispatchDateColumn)+N' AS [__DispatchDate]';
            SELECT @Columns=STUFF((SELECT ', T.'+QUOTENAME(C.ColumnName)+' AS '+QUOTENAME(D.FieldName)
                FROM dbo.WBT_DomianWiseFieldMaster D
                INNER JOIN dbo.WBT_ProjectWiseFieldMaster P ON P.FieldName=D.DomainFieldID
                INNER JOIN dbo.WBT_ColumnMapping CM ON CM.ProjectFieldID=P.ProjectFieldID AND CM.ProjectID=P.ProjectID
                INNER JOIN dbo.WBT_ColumnMaster C ON C.ColumnID=CM.CoumnID
                WHERE CM.ProjectID=@ProjectID AND CM.ForBilling=@ForBilling
                ORDER BY SequenceNo ASC FOR XML PATH(''),TYPE).value('.','NVARCHAR(MAX)'),1,2,'');

            IF NULLIF(@Columns,'') IS NOT NULL AND NULLIF(@DispatchDateColumn,'') IS NOT NULL
            BEGIN
                SET @SQL=N'SELECT @ProjectName AS [Project #], @ProjectID AS [__ProjectID], '+@Columns+@DispatchSelect+N'
                    FROM Underwriting.dbo.WBT_TrackingSheet T
                    WHERE T.ProjectID=@ProjectID AND T.BillingPeriod IS NULL
                    AND CASE
                            WHEN ISDATE(T.'+QUOTENAME(@DispatchDateColumn)+N')=1
                            THEN CONVERT(DATE,T.'+QUOTENAME(@DispatchDateColumn)+N')
                        END BETWEEN @FromDate AND @PeriodTo;';
                EXEC sys.sp_executesql @SQL,
                    N'@ProjectName NVARCHAR(100),@ProjectID INT,@FromDate DATE,@PeriodTo DATE',
                    @ProjectName=@ProjectName,@ProjectID=@ProjectID,@FromDate=@FromDate,@PeriodTo=@PeriodTo;
            END;
            FETCH NEXT FROM c_pro INTO @ProjectID,@ProjectName;
        END;
        CLOSE c_pro;
        DEALLOCATE c_pro;
    END;
END;
