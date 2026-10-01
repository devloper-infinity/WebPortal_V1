/*
    Permanent memory fix for Admin/LoanLevelHistory.aspx.
    The procedure now returns two small result sets:
      1. TotalRecords
      2. The requested page only
*/
ALTER PROCEDURE dbo.usp_GetLoanLevelSecRelTracking
    @ProjectID  INT,
    @FromDate   NVARCHAR(100),
    @ToDate     NVARCHAR(100),
    @Start      INT = 0,
    @PageSize   INT = 10,
    @SearchValue NVARCHAR(200) = N'',
    @ExportAll BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SET @Start = CASE WHEN @Start < 0 THEN 0 ELSE @Start END;
    SET @PageSize = CASE WHEN @PageSize BETWEEN 1 AND 500 THEN @PageSize ELSE 10 END;
    SET @SearchValue = LTRIM(RTRIM(ISNULL(@SearchValue, N'')));

    DECLARE @cols NVARCHAR(MAX) = N'',
            @sql  NVARCHAR(MAX);

    ;WITH DistinctBilling AS
    (
        SELECT DISTINCT
            O.ProjectID,
            O.DealNo,
            O.LoanNo,
            LTRIM(RTRIM(SB.BillingPeriod)) AS BillingPeriod,
            S.DeliveredDate
        FROM dbo.OrderData O
        LEFT JOIN dbo.SecRelLoansList S
            ON S.ProjectID = O.ProjectID
           AND S.DealNo = O.DealNo
           AND S.LoanNo = O.LoanNo
        LEFT JOIN dbo.SecuritizationBilling SB
            ON SB.BillingID = S.SecuritizationID
        WHERE (@ProjectID = 0 OR O.ProjectID = @ProjectID)
          AND CAST(O.OrderDate AS DATE)
              BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
    ),
    BillingHistory AS
    (
        SELECT *,
               ROW_NUMBER() OVER
               (PARTITION BY ProjectID, DealNo, LoanNo ORDER BY BillingPeriod) AS RN
        FROM DistinctBilling
    )
    SELECT @cols = STUFF
    (
        (
            SELECT
                ',MAX(CASE WHEN RN = ' + CAST(RN AS VARCHAR(10))
                + ' THEN BillingPeriod END) AS Billing' + CAST(RN AS VARCHAR(10))
                + ',MAX(CASE WHEN RN = ' + CAST(RN AS VARCHAR(10))
                + ' THEN CONVERT(VARCHAR(12), CAST(DeliveredDate AS DATE), 101) END) AS DeliveredDate'
                + CAST(RN AS VARCHAR(10))
            FROM (SELECT DISTINCT RN FROM BillingHistory) X
            ORDER BY RN
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'),
        1, 1, ''
    );

    SET @sql = N'
    SELECT
            P.ProjectName,
            O.ProjectID,
            O.DealNo,
            O.LoanNo,
            CASE WHEN ISDATE(O.OrderDate) = 0 THEN NULL
                 ELSE CONVERT(NVARCHAR(12), CAST(O.OrderDate AS DATE), 101) END AS OrderDate,
            CASE WHEN ISDATE(O.DispatchDate) = 0 THEN NULL
                 ELSE CONVERT(NVARCHAR(12), CAST(O.DispatchDate AS DATE), 101) END AS DispatchDate
    INTO #FilteredLoans
        FROM dbo.OrderData O
        LEFT JOIN dbo.Project P ON P.ProjectID = O.ProjectID
        WHERE (@DynamicProjectID = 0 OR O.ProjectID = @DynamicProjectID)
          AND CAST(O.OrderDate AS DATE)
              BETWEEN CAST(@DynamicFromDate AS DATE) AND CAST(@DynamicToDate AS DATE)
          AND
          (
              @DynamicSearch = N''''
              OR P.ProjectName LIKE N''%'' + @DynamicSearch + N''%''
              OR CONVERT(NVARCHAR(100), O.DealNo) LIKE N''%'' + @DynamicSearch + N''%''
              OR CONVERT(NVARCHAR(100), O.LoanNo) LIKE N''%'' + @DynamicSearch + N''%''
              OR EXISTS
                 (
                     SELECT 1
                     FROM dbo.SecRelLoansList SearchLoan
                     JOIN dbo.SecuritizationBilling SearchBilling
                       ON SearchBilling.BillingID = SearchLoan.SecuritizationID
                     WHERE SearchLoan.ProjectID = O.ProjectID
                       AND SearchLoan.DealNo = O.DealNo
                       AND SearchLoan.LoanNo = O.LoanNo
                       AND SearchBilling.BillingPeriod LIKE N''%'' + @DynamicSearch + N''%''
                 )
          )
        GROUP BY P.ProjectName, O.ProjectID, O.DealNo, O.LoanNo,
                 O.OrderDate, O.DispatchDate;

    SELECT COUNT(1) AS TotalRecords FROM #FilteredLoans;

    ;WITH NumberedLoans AS
    (
        SELECT *, ROW_NUMBER() OVER (ORDER BY ProjectName, LoanNo) AS PageRowNumber
        FROM #FilteredLoans
    )
    SELECT ProjectName, ProjectID, DealNo, LoanNo, OrderDate, DispatchDate
    INTO #PageLoans
    FROM NumberedLoans
    WHERE @DynamicExportAll = 1
       OR PageRowNumber BETWEEN @DynamicStart + 1 AND @DynamicStart + @DynamicPageSize;

    ;WITH DistinctBilling AS
    (
        SELECT DISTINCT
            L.ProjectName,
            L.ProjectID,
            L.DealNo,
            L.LoanNo,
            L.OrderDate,
            L.DispatchDate,
            LTRIM(RTRIM(SB.BillingPeriod)) AS BillingPeriod,
            S.DeliveredDate
        FROM #PageLoans L
        LEFT JOIN dbo.SecRelLoansList S
            ON S.ProjectID = L.ProjectID
           AND S.DealNo = L.DealNo
           AND S.LoanNo = L.LoanNo
        LEFT JOIN dbo.SecuritizationBilling SB ON SB.BillingID = S.SecuritizationID
    ),
    BillingHistory AS
    (
        SELECT *,
               ROW_NUMBER() OVER
               (PARTITION BY ProjectID, DealNo, LoanNo ORDER BY BillingPeriod) AS RN
        FROM DistinctBilling
    )
    SELECT
        ProjectName AS [Project #],
        DealNo AS [Deal #],
        LoanNo AS [Loan #],
        OrderDate AS [Order Date],
        DispatchDate AS [Dispatch Date]'
        + CASE WHEN ISNULL(@cols, '') <> '' THEN ',' + @cols ELSE '' END + N'
    FROM BillingHistory
    GROUP BY ProjectName, ProjectID, DealNo, LoanNo, OrderDate, DispatchDate
    ORDER BY [Project #], [Loan #];';

    EXEC sys.sp_executesql
        @sql,
        N'@DynamicProjectID INT, @DynamicFromDate NVARCHAR(100),
          @DynamicToDate NVARCHAR(100), @DynamicStart INT,
          @DynamicPageSize INT, @DynamicSearch NVARCHAR(200), @DynamicExportAll BIT',
        @DynamicProjectID = @ProjectID,
        @DynamicFromDate = @FromDate,
        @DynamicToDate = @ToDate,
        @DynamicStart = @Start,
        @DynamicPageSize = @PageSize,
        @DynamicSearch = @SearchValue,
        @DynamicExportAll = @ExportAll;
END;
GO
