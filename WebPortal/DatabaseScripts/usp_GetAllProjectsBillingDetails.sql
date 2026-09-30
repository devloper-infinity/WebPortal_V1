ALTER PROCEDURE dbo.usp_GetAllProjectsBillingDetails
    @EmployeeID INT,
    @Month NVARCHAR(100),
    @Year INT
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

    DECLARE @FromDate DATE=DATEFROMPARTS(@Year,@MonthNo,1), @ToDate DATE;
    SET @ToDate=EOMONTH(@FromDate);
    DECLARE @ProjectList TABLE(ID INT IDENTITY(1,1) PRIMARY KEY,ProjectID INT,ProjectName NVARCHAR(100));
    DECLARE @ForBilling INT=1,@Columns NVARCHAR(MAX),@SQL NVARCHAR(MAX),@DueDateColumn SYSNAME,@ProjectName NVARCHAR(100),@ProjectID INT;

    IF @EmployeeID IN (277,6823)
    BEGIN
        ;WITH LatestInvoice AS
        (
            SELECT IM.*,ROW_NUMBER() OVER(PARTITION BY IM.ProjectID ORDER BY CONVERT(DATE,IM.AddedDate) DESC,IM.InvoiceID DESC) AS RN
            FROM InfinityBilling_UW.dbo.InfinityBilling_InvoiceMaster IM
        )
        INSERT @ProjectList(ProjectID,ProjectName)
        SELECT DISTINCT U.ProjectID,P.ProjectName
        FROM dbo.UserProjectConfiguration U
        INNER JOIN dbo.Project P ON P.ProjectID=U.ProjectID
        INNER JOIN dbo.EmployeeInfo E ON E.EmployeeID=U.UserID
        INNER JOIN LatestInvoice IM ON IM.ProjectID=U.ProjectID AND IM.RN=1
        WHERE (@EmployeeID=277 AND P.SubdomainID=19) OR (@EmployeeID=6823 AND P.SubdomainID=15);

        DECLARE c_pro CURSOR LOCAL FAST_FORWARD FOR SELECT ProjectID,ProjectName FROM @ProjectList ORDER BY ID;
        OPEN c_pro;
        FETCH NEXT FROM c_pro INTO @ProjectID,@ProjectName;
        WHILE @@FETCH_STATUS=0
        BEGIN
            SET @Columns=NULL;
            SET @DueDateColumn=NULL;
            SELECT @DueDateColumn=ColName FROM dbo.usf_GetColumnNameForReport(@ProjectID,'Due Date');
            SELECT @Columns=STUFF((SELECT ', T.'+QUOTENAME(C.ColumnName)+' AS '+QUOTENAME(D.FieldName)
                FROM dbo.WBT_DomianWiseFieldMaster D
                INNER JOIN dbo.WBT_ProjectWiseFieldMaster P ON P.FieldName=D.DomainFieldID
                INNER JOIN dbo.WBT_ColumnMapping CM ON CM.ProjectFieldID=P.ProjectFieldID AND CM.ProjectID=P.ProjectID
                INNER JOIN dbo.WBT_ColumnMaster C ON C.ColumnID=CM.CoumnID
                WHERE CM.ProjectID=@ProjectID AND CM.ForBilling=@ForBilling
                ORDER BY SequenceNo ASC FOR XML PATH(''),TYPE).value('.','NVARCHAR(MAX)'),1,2,'');

            IF NULLIF(@Columns,'') IS NOT NULL AND NULLIF(@DueDateColumn,'') IS NOT NULL
            BEGIN
                SET @SQL=N'SELECT @ProjectName AS [Project #], '+@Columns+N'
                    FROM Underwriting.dbo.WBT_TrackingSheet T
                    WHERE T.ProjectID=@ProjectID AND T.BillingPeriod IS NULL
                    AND CASE
                            WHEN ISDATE(T.'+QUOTENAME(@DueDateColumn)+N')=1
                            THEN CONVERT(DATE,T.'+QUOTENAME(@DueDateColumn)+N')
                        END BETWEEN @FromDate AND @ToDate;';
                EXEC sys.sp_executesql @SQL,
                    N'@ProjectName NVARCHAR(100),@ProjectID INT,@FromDate DATE,@ToDate DATE',
                    @ProjectName=@ProjectName,@ProjectID=@ProjectID,@FromDate=@FromDate,@ToDate=@ToDate;
            END;
            FETCH NEXT FROM c_pro INTO @ProjectID,@ProjectName;
        END;
        CLOSE c_pro;
        DEALLOCATE c_pro;
    END;
END;
