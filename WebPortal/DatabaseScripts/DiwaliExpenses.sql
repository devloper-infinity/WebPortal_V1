SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.DiwaliExpenseImport','U') IS NULL
BEGIN
    CREATE TABLE dbo.DiwaliExpenseImport
    (
        ExpenseYear int NOT NULL CONSTRAINT PK_DiwaliExpenseImport PRIMARY KEY,
        SourceFileName nvarchar(260) NOT NULL,
        ImportedBy int NULL,
        ImportedOn datetime NOT NULL CONSTRAINT DF_DiwaliExpenseImport_ImportedOn DEFAULT(GETDATE())
    );
END;
GO

IF OBJECT_ID('dbo.DiwaliExpenseSummary','U') IS NULL
BEGIN
    CREATE TABLE dbo.DiwaliExpenseSummary
    (
        DiwaliExpenseSummaryID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_DiwaliExpenseSummary PRIMARY KEY,
        ExpenseYear int NOT NULL,
        SerialNo int NULL,
        Particular nvarchar(500) NOT NULL,
        Amount decimal(18,2) NOT NULL,
        Remark nvarchar(2000) NULL,
        SortOrder int NOT NULL,
        CONSTRAINT FK_DiwaliExpenseSummary_Import FOREIGN KEY(ExpenseYear) REFERENCES dbo.DiwaliExpenseImport(ExpenseYear) ON DELETE CASCADE
    );
END;
GO

IF OBJECT_ID('dbo.DiwaliExpenseDetail','U') IS NULL
BEGIN
    CREATE TABLE dbo.DiwaliExpenseDetail
    (
        DiwaliExpenseDetailID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_DiwaliExpenseDetail PRIMARY KEY,
        ExpenseYear int NOT NULL,
        Category nvarchar(50) NOT NULL,
        SerialNo int NULL,
        ExpenseDate date NULL,
        Particular nvarchar(1000) NULL,
        Location nvarchar(250) NULL,
        Quantity decimal(18,2) NULL,
        Rate decimal(18,2) NULL,
        Amount decimal(18,2) NOT NULL CONSTRAINT DF_DiwaliExpenseDetail_Amount DEFAULT(0),
        EmployeeCode nvarchar(25) NULL,
        EmployeeName nvarchar(250) NULL,
        Branch nvarchar(100) NULL,
        SweetBoxStatus nvarchar(100) NULL,
        GiftStatus nvarchar(100) NULL,
        SilverCoinStatus nvarchar(100) NULL,
        Remark nvarchar(2000) NULL,
        SortOrder int NOT NULL,
        CONSTRAINT FK_DiwaliExpenseDetail_Import FOREIGN KEY(ExpenseYear) REFERENCES dbo.DiwaliExpenseImport(ExpenseYear) ON DELETE CASCADE
    );
    CREATE INDEX IX_DiwaliExpenseDetail_YearCategory ON dbo.DiwaliExpenseDetail(ExpenseYear,Category,SortOrder);
END;
GO

IF OBJECT_ID('dbo.usp_ImportDiwaliExpense','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ImportDiwaliExpense;
GO

CREATE PROCEDURE dbo.usp_ImportDiwaliExpense
    @Year int,
    @AddedBy int = NULL,
    @SourceFileName nvarchar(260),
    @Payload xml
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @Year NOT BETWEEN 2000 AND 2100
    BEGIN
        RAISERROR('Invalid expense year.',16,1);
        RETURN;
    END;
    IF @Payload IS NULL
    BEGIN
        RAISERROR('Import payload is required.',16,1);
        RETURN;
    END;

    BEGIN TRANSACTION;
    DELETE FROM dbo.DiwaliExpenseImport WHERE ExpenseYear=@Year;
    INSERT dbo.DiwaliExpenseImport(ExpenseYear,SourceFileName,ImportedBy) VALUES(@Year,@SourceFileName,@AddedBy);

    INSERT dbo.DiwaliExpenseSummary(ExpenseYear,SerialNo,Particular,Amount,Remark,SortOrder)
    SELECT @Year, CONVERT(int,NULLIF(N.value('@SerialNo','nvarchar(20)'),'')), N.value('@Particular','nvarchar(500)'),
           CONVERT(decimal(18,2),N.value('@Amount','nvarchar(50)')), NULLIF(N.value('@Remark','nvarchar(2000)'),''),
           CONVERT(int,N.value('@SortOrder','nvarchar(20)'))
    FROM @Payload.nodes('/DiwaliExpense/Summary/Row') T(N);

    INSERT dbo.DiwaliExpenseDetail(ExpenseYear,Category,SerialNo,ExpenseDate,Particular,Location,Quantity,Rate,Amount,EmployeeCode,EmployeeName,Branch,SweetBoxStatus,GiftStatus,SilverCoinStatus,Remark,SortOrder)
    SELECT @Year, N.value('@Category','nvarchar(50)'), CONVERT(int,NULLIF(N.value('@SerialNo','nvarchar(20)'),'')),
           CONVERT(date,NULLIF(N.value('@ExpenseDate','nvarchar(20)'),'')), NULLIF(N.value('@Particular','nvarchar(1000)'),''),
           NULLIF(N.value('@Location','nvarchar(250)'),''), CONVERT(decimal(18,2),NULLIF(N.value('@Quantity','nvarchar(50)'),'')),
           CONVERT(decimal(18,2),NULLIF(N.value('@Rate','nvarchar(50)'),'')), COALESCE(CONVERT(decimal(18,2),NULLIF(N.value('@Amount','nvarchar(50)'),'')),0),
           NULLIF(N.value('@EmployeeCode','nvarchar(25)'),''), NULLIF(N.value('@EmployeeName','nvarchar(250)'),''),
           NULLIF(N.value('@Branch','nvarchar(100)'),''), NULLIF(N.value('@SweetBoxStatus','nvarchar(100)'),''),
           NULLIF(N.value('@GiftStatus','nvarchar(100)'),''), NULLIF(N.value('@SilverCoinStatus','nvarchar(100)'),''),
           NULLIF(N.value('@Remark','nvarchar(2000)'),''), CONVERT(int,N.value('@SortOrder','nvarchar(20)'))
    FROM @Payload.nodes('/DiwaliExpense/Items/Row') T(N);
    COMMIT TRANSACTION;
END;
GO

IF OBJECT_ID('dbo.usp_GetDiwaliExpense','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetDiwaliExpense;
GO

CREATE PROCEDURE dbo.usp_GetDiwaliExpense @Year int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ExpenseYear
    FROM
    (
        SELECT ExpenseYear FROM dbo.DiwaliExpenseImport
        UNION
        SELECT 2023
    ) Y
    ORDER BY ExpenseYear DESC;

    IF @Year = 2023
    BEGIN
        SELECT CONVERT(nvarchar(250),CASE WHEN Br.BranchName IS NULL THEN 'HM Madam & CM Sir' ELSE Br.BranchName END) AS Branch,
               SUM(CASE WHEN B.Type1 IS NOT NULL THEN 1 ELSE 0 END) + SUM(CASE WHEN B.Type2 IS NOT NULL THEN 1 ELSE 0 END) AS SweetCount
        INTO #Sweet2023
        FROM dbo.BonusMaster B
        LEFT JOIN dbo.EmployeeInfo E ON E.Code=B.Code
        LEFT JOIN dbo.Branch Br ON Br.BranchID=E.WorkingBranch
        WHERE B.Year=@Year AND E.WorkingBranch IN (0,2,3,8)
        GROUP BY Br.BranchName;

        INSERT #Sweet2023(Branch,SweetCount) VALUES
            ('Legal Distribution',5),
            ('1 Extra & 1 of Vinay Sahu - 2 Silver Handed to Parikh Sir',0),
            ('HK-Security-Others',0);

        SELECT CONVERT(nvarchar(250),CASE WHEN Br.BranchName IS NULL THEN 'HM Madam & CM Sir' ELSE Br.BranchName END) AS Branch,
               SUM(CASE WHEN B.SilverCoin IS NOT NULL THEN 1 ELSE 0 END) AS SilverCount
        INTO #Silver2023
        FROM dbo.BonusMaster B
        LEFT JOIN dbo.EmployeeInfo E ON E.Code=B.Code
        LEFT JOIN dbo.Branch Br ON Br.BranchID=E.WorkingBranch
        WHERE B.Year=@Year AND E.WorkingBranch IN (0,2,3,8)
        GROUP BY Br.BranchName;

        INSERT #Silver2023(Branch,SilverCount) VALUES
            ('Legal Distribution',0),
            ('1 Extra & 1 of Vinay Sahu - 2 Silver Handed to Parikh Sir',1),
            ('HK-Security-Others',0);

        SELECT CONVERT(nvarchar(250),CASE WHEN Br.BranchName IS NULL THEN 'HM Madam & CM Sir' ELSE Br.BranchName END) AS Branch,
               SUM(CASE WHEN B.Type3 IS NOT NULL THEN 1 ELSE 0 END) AS GiftCount
        INTO #Gift2023
        FROM dbo.BonusMaster B
        LEFT JOIN dbo.EmployeeInfo E ON E.Code=B.Code
        LEFT JOIN dbo.Branch Br ON Br.BranchID=E.WorkingBranch
        WHERE B.Year=@Year AND E.WorkingBranch IN (0,2,3,8)
        GROUP BY Br.BranchName;

        INSERT #Gift2023(Branch,GiftCount) VALUES
            ('Legal Distribution',0),
            ('1 Extra & 1 of Vinay Sahu - 2 Silver Handed to Parikh Sir',0),
            ('HK-Security-Others',37);

        DECLARE @SweetQuantity int, @SilverQuantity int, @GiftQuantity int, @GiftAmount decimal(18,2);
        SELECT @SweetQuantity=SUM(S.SweetCount), @SilverQuantity=SUM(V.SilverCount), @GiftQuantity=SUM(G.GiftCount)
        FROM #Sweet2023 S INNER JOIN #Silver2023 V ON V.Branch=S.Branch INNER JOIN #Gift2023 G ON G.Branch=S.Branch;
        SET @GiftAmount=(@SweetQuantity*500)+(@SilverQuantity*394)+(@GiftQuantity*130);

        SELECT SerialNo,Particular,Amount,Remark
        FROM
        (
            SELECT 1 AS SerialNo,'Sweets 50k & Silver Coins 15K (Sum A)' AS Particular,@GiftAmount AS Amount,CAST(NULL AS nvarchar(2000)) AS Remark
            UNION ALL SELECT 2,'Lunch Plates (Sum B)',18000,NULL
            UNION ALL SELECT 3,'Decoration - 3 Office',3500,NULL
            UNION ALL SELECT 4,'Laxmi Pooja Dakshina 2500 + Material 2000',4500,NULL
            UNION ALL SELECT 5,'Grand Total',@GiftAmount+26000,NULL
        ) Summary2023
        ORDER BY SerialNo;

        SELECT Category,SerialNo,ExpenseDate,Particular,Location,Quantity,Rate,Amount,EmployeeCode,EmployeeName,Branch,SweetBoxStatus,GiftStatus,SilverCoinStatus,Remark
        FROM
        (
            SELECT 'Distribution Summary' AS Category,CAST(NULL AS int) AS SerialNo,CAST(NULL AS date) AS ExpenseDate,
                   X.Particular,S.Branch AS Location,CONVERT(decimal(18,2),X.Quantity) AS Quantity,CONVERT(decimal(18,2),X.Rate) AS Rate,
                   CONVERT(decimal(18,2),X.Quantity*X.Rate) AS Amount,CAST(NULL AS nvarchar(25)) AS EmployeeCode,
                   CAST(NULL AS nvarchar(250)) AS EmployeeName,CAST(NULL AS nvarchar(100)) AS Branch,
                   CAST(NULL AS nvarchar(100)) AS SweetBoxStatus,CAST(NULL AS nvarchar(100)) AS GiftStatus,
                   CAST(NULL AS nvarchar(100)) AS SilverCoinStatus,CAST(NULL AS nvarchar(2000)) AS Remark,1 AS CategoryOrder
            FROM #Sweet2023 S
            INNER JOIN #Silver2023 V ON V.Branch=S.Branch
            INNER JOIN #Gift2023 G ON G.Branch=S.Branch
            CROSS APPLY
            (
                SELECT 'Sweets' AS Particular,S.SweetCount AS Quantity,500 AS Rate
                UNION ALL SELECT 'Silver Coins',V.SilverCount,394
                UNION ALL SELECT 'Gifts',G.GiftCount,130
            ) X

            UNION ALL

            SELECT 'Employee Distribution',ROW_NUMBER() OVER(ORDER BY B.Code),CAST(NULL AS date),CAST(NULL AS nvarchar(1000)),
                   CAST(NULL AS nvarchar(250)),CAST(NULL AS decimal(18,2)),CAST(NULL AS decimal(18,2)),CAST(0 AS decimal(18,2)),
                   B.Code,E.FirstName+' '+E.LastName,Br.BranchName,
                   CASE WHEN B.Type1 IS NOT NULL OR B.Type2 IS NOT NULL THEN 'Given' ELSE NULL END,
                   CASE WHEN B.Type3 IS NOT NULL THEN 'Given' ELSE NULL END,
                   CASE WHEN B.SilverCoin IS NOT NULL THEN 'Given' ELSE NULL END,
                   CASE WHEN B.isApproved=1 THEN 'Approved' ELSE 'Pending' END,2
            FROM dbo.BonusMaster B
            INNER JOIN dbo.EmployeeInfo E ON E.Code=B.Code
            LEFT JOIN dbo.Branch Br ON Br.BranchID=E.WorkingBranch
            WHERE B.Year=@Year AND E.WorkingBranch IN (2,3,8)
              AND (B.IsDelete=0 OR B.IsDelete IS NULL)
              AND (B.Type1 IS NOT NULL OR B.Type2 IS NOT NULL OR B.Type3 IS NOT NULL OR B.SilverCoin IS NOT NULL)
        ) Detail2023
        ORDER BY CategoryOrder,Location,Particular,EmployeeCode;

        DROP TABLE #Sweet2023;
        DROP TABLE #Silver2023;
        DROP TABLE #Gift2023;
        RETURN;
    END;

    SELECT SerialNo,Particular,Amount,Remark FROM dbo.DiwaliExpenseSummary WHERE ExpenseYear=@Year ORDER BY SortOrder,DiwaliExpenseSummaryID;
    SELECT Category,SerialNo,ExpenseDate,Particular,Location,Quantity,Rate,Amount,EmployeeCode,EmployeeName,Branch,SweetBoxStatus,GiftStatus,SilverCoinStatus,Remark
    FROM dbo.DiwaliExpenseDetail WHERE ExpenseYear=@Year ORDER BY CASE Category WHEN 'General Expense' THEN 1 WHEN 'Food Arrangement' THEN 2 WHEN 'Sweet Boxes' THEN 3 WHEN 'Silver Coins' THEN 4 WHEN 'Senior Gifts' THEN 5 ELSE 6 END,SortOrder,DiwaliExpenseDetailID;
END;
GO
