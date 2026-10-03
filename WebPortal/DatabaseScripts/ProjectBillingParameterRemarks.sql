SET NOCOUNT ON;

IF OBJECT_ID('dbo.ProjectBillingParameterRemark','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProjectBillingParameterRemark
    (
        ProjectBillingParameterRemarkID INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_ProjectBillingParameterRemark PRIMARY KEY,
        ProjectID INT NOT NULL,
        DealNo NVARCHAR(200) NOT NULL,
        LoanIdentifier NVARCHAR(200) NOT NULL,
        BillingMonth DATE NOT NULL,
        PendingSignature NVARCHAR(2000) NOT NULL,
        Remark NVARCHAR(1000) NOT NULL,
        AddedBy INT NOT NULL,
        AddedDate DATETIME NOT NULL
            CONSTRAINT DF_ProjectBillingParameterRemark_AddedDate DEFAULT(GETDATE()),
        UpdatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        CONSTRAINT UQ_ProjectBillingParameterRemark_Context
            UNIQUE(ProjectID,DealNo,LoanIdentifier,BillingMonth)
    );

    CREATE INDEX IX_ProjectBillingParameterRemark_ProjectDeal
        ON dbo.ProjectBillingParameterRemark(ProjectID,DealNo)
        INCLUDE(LoanIdentifier,Remark);
END;
GO

IF COL_LENGTH('dbo.ProjectBillingParameterRemark','BillingMonth') IS NULL
    ALTER TABLE dbo.ProjectBillingParameterRemark ADD BillingMonth DATE NULL;
IF COL_LENGTH('dbo.ProjectBillingParameterRemark','PendingSignature') IS NULL
    ALTER TABLE dbo.ProjectBillingParameterRemark ADD PendingSignature NVARCHAR(2000) NULL;
GO
UPDATE dbo.ProjectBillingParameterRemark SET BillingMonth=DATEFROMPARTS(YEAR(AddedDate),MONTH(AddedDate),1) WHERE BillingMonth IS NULL;
UPDATE dbo.ProjectBillingParameterRemark SET PendingSignature=N'' WHERE PendingSignature IS NULL;
ALTER TABLE dbo.ProjectBillingParameterRemark ALTER COLUMN BillingMonth DATE NOT NULL;
ALTER TABLE dbo.ProjectBillingParameterRemark ALTER COLUMN PendingSignature NVARCHAR(2000) NOT NULL;
GO
IF EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.ProjectBillingParameterRemark') AND name='UQ_ProjectBillingParameterRemark_Context')
    ALTER TABLE dbo.ProjectBillingParameterRemark DROP CONSTRAINT UQ_ProjectBillingParameterRemark_Context;
ALTER TABLE dbo.ProjectBillingParameterRemark ADD CONSTRAINT UQ_ProjectBillingParameterRemark_Context UNIQUE(ProjectID,DealNo,LoanIdentifier,BillingMonth);
GO

IF OBJECT_ID('dbo.usp_SaveProjectBillingRemarks','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.usp_SaveProjectBillingRemarks AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.usp_SaveProjectBillingRemarks
    @EmployeeID INT,
    @ProjectID INT,
    @DealNo NVARCHAR(200),
    @BillingMonth DATE,
    @Remark NVARCHAR(1000),
    @LoansXml XML
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @DealNo=LTRIM(RTRIM(ISNULL(@DealNo,'')));
    SET @Remark=LTRIM(RTRIM(ISNULL(@Remark,'')));

    IF @Remark=''
    BEGIN
        RAISERROR('Remark is mandatory.',16,1);
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Project P
        WHERE P.ProjectID=@ProjectID
          AND ((@EmployeeID=277 AND P.SubdomainID=19)
            OR (@EmployeeID=6823 AND P.SubdomainID=15))
    )
    BEGIN
        RAISERROR('You are not authorized to update remarks for this project.',16,1);
        RETURN;
    END;

    DECLARE @Loans TABLE(LoanIdentifier NVARCHAR(200) NOT NULL PRIMARY KEY,PendingSignature NVARCHAR(2000) NOT NULL);
    INSERT @Loans(LoanIdentifier,PendingSignature)
    SELECT LTRIM(RTRIM(N.value('@LoanNo','nvarchar(200)'))),MAX(N.value('@Signature','nvarchar(2000)'))
    FROM @LoansXml.nodes('/Loans/Loan') X(N)
    WHERE LTRIM(RTRIM(N.value('@LoanNo','nvarchar(200)')))<>''
    GROUP BY LTRIM(RTRIM(N.value('@LoanNo','nvarchar(200)')));

    IF NOT EXISTS(SELECT 1 FROM @Loans)
    BEGIN
        RAISERROR('No valid loans were selected.',16,1);
        RETURN;
    END;

    MERGE dbo.ProjectBillingParameterRemark WITH(HOLDLOCK) AS T
    USING @Loans AS S
      ON T.ProjectID=@ProjectID
     AND T.DealNo=@DealNo
     AND T.LoanIdentifier=S.LoanIdentifier
     AND T.BillingMonth=@BillingMonth
    WHEN MATCHED THEN
        UPDATE SET PendingSignature=S.PendingSignature,Remark=@Remark,UpdatedBy=@EmployeeID,UpdatedDate=GETDATE()
    WHEN NOT MATCHED THEN
        INSERT(ProjectID,DealNo,LoanIdentifier,BillingMonth,PendingSignature,Remark,AddedBy,AddedDate)
        VALUES(@ProjectID,@DealNo,S.LoanIdentifier,@BillingMonth,S.PendingSignature,@Remark,@EmployeeID,GETDATE());

    SELECT @@ROWCOUNT AS SavedCount;
END;
GO
