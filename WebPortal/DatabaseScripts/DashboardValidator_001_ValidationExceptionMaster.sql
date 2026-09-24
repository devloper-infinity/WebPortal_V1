SET NOCOUNT ON;
SET XACT_ABORT ON;

IF OBJECT_ID(N'dbo.ValidationExceptionMaster', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ValidationExceptionMaster
    (
        ValidationExceptionMasterID INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_ValidationExceptionMaster PRIMARY KEY,
        SourceRowNumber INT NOT NULL,
        Section NVARCHAR(255) NOT NULL,
        ExpectedExceptionText NVARCHAR(2000) NOT NULL,
        IsActive BIT NOT NULL
            CONSTRAINT DF_ValidationExceptionMaster_IsActive DEFAULT (1),
        CreatedOn DATETIME NOT NULL
            CONSTRAINT DF_ValidationExceptionMaster_CreatedOn DEFAULT (GETDATE()),
        CONSTRAINT UQ_ValidationExceptionMaster_SourceRowNumber UNIQUE (SourceRowNumber)
    );
END;

DECLARE @Seed TABLE
(
    SourceRowNumber INT NOT NULL PRIMARY KEY,
    Section NVARCHAR(255) NOT NULL,
    ExpectedExceptionText NVARCHAR(2000) NOT NULL
);

INSERT INTO @Seed (SourceRowNumber, Section, ExpectedExceptionText)
VALUES
(2, N'Delinquent OR Unpaid Taxes', N'Title Review shows outstanding delinquent taxes'),
(3, N'Delinquent OR Unpaid Taxes', N'Delinquent Taxes'),
(4, N'Tax Lien', N'Tax Lien showing on the subject property'),
(5, N'Tax Lien', N'The property had a tax sale - property or cert was sold to 3rd party'),
(6, N'Tax Lien', N'Title Rvw shows lower lien position than loan docs'),
(7, N'Tax Lien', N'Title Review shows major title concern'),
(8, N'Tax Foreclosure?', N'Property is foreclosed and sold to 3rd party'),
(9, N'Tax Foreclosure?', N'Title Rvw shows lower lien position than loan docs'),
(10, N'Tax Foreclosure?', N'Title Review shows major title concern'),
(11, N'Tax Mortgages', N'Title Rvw shows lower lien position than loan docs'),
(12, N'Tax Mortgages', N'Title Review shows major title concern'),
(13, N'Potential for Tax Cert Investor paying taxes', N'Title Rvw shows lower lien position than loan docs'),
(14, N'Potential for Tax Cert Investor paying taxes', N'Title Review shows major title concern'),
(15, N'State Tax Lien', N'Title Review shows outstanding state tax due'),
(16, N'State Tax Lien', N'State Tax Judgment'),
(17, N'State Tax Lien', N'Active State Tax Lien Judgement.'),
(18, N'Federal Tax Lien', N'Title Review shows outstanding IRS liens'),
(19, N'Federal Tax Lien', N'IRS Lien outstanding'),
(20, N'Federal Tax Lien', N'Updated title review shows IRS / vehicle / federal / personal tax liens'),
(21, N'Subject mortgage in first position?', N'Title Rvw shows lower lien position than loan docs'),
(22, N'Subject mortgage in first position?', N'Title Review shows major title concern'),
(23, N'Subject mortgage in first position?', N'Sr Lien 1 Foreclosure started, investigate.'),
(24, N'Subject mortgage in first position?', N'Sr Lien 2 Foreclosure started, investigate.'),
(25, N'Subject mortgage in first position?', N'Lis Pendens Sr Lien 1 doesn''t list lender/servicer/seller name'),
(26, N'Subject mortgage in first position?', N'Lis Pendens Sr Lien 2 doesn''t list lender/servicer/seller name'),
(27, N'Subject mortgage in first position?', N'Missing Title evidence'),
(28, N'Subject mortgage in first position?', N'Title Rvw shows lower lien position than loan docs'),
(29, N'Subject mortgage in first position?', N'Title Review shows major title concern'),
(30, N'Subject mortgage in first position?', N'Keyword'),
(31, N'HOA Lien Exists', N'HOA/COA lien against property'),
(32, N'HOA Lien Exists', N'HOA\COA lien agaist property '),
(33, N'HOA Lien Exists', N'Title Rvw shows lower lien position than loan docs'),
(34, N'HOA Lien Exists', N'Title Review shows major title concern'),
(35, N'City Muni Assessment Lien Exists', N'Lis Pendens Sr Lien 1 doesn''t list lender/servicer/seller name'),
(36, N'City Muni Assessment Lien Exists', N'Lis Pendens Sr Lien 2 doesn''t list lender/servicer/seller name'),
(37, N'City Muni Assessment Lien Exists', N'Sr Lien 1 Foreclosure started, investigate.'),
(38, N'City Muni Assessment Lien Exists', N'Sr Lien 2 Foreclosure started, investigate.'),
(39, N'City Muni Assessment Lien Exists', N'Title reports unpaid liens'),
(40, N'City Muni Assessment Lien Exists', N'Title Review shows outstanding municipal liens'),
(41, N'City Muni Assessment Lien Exists', N'Title Rvw shows lower lien position than loan docs'),
(42, N'City Muni Assessment Lien Exists', N'Code Enforcement Lien'),
(43, N'City Muni Assessment Lien Exists', N'Municipal Lien against the property'),
(44, N'City Muni Assessment Lien Exists', N'Notice or lien against subject property'),
(45, N'City Muni Assessment Lien Exists', N'Title Rvw shows lower lien position than loan docs'),
(46, N'City Muni Assessment Lien Exists', N'Title Review shows major title concern'),
(47, N'Mobile Home Present', N'Property is Manufactured Housing'),
(48, N'Mobile Home Present', N'Subject property is a manufactured home'),
(49, N'Subject Mortgage Maturity Date', N'Origination date is later than maturity date'),
(50, N'Subject Mortgage Maturity Date', N'Loan maturity date has passed'),
(51, N'Subject Mortgage Maturity Date', N'Maturity date not available on the mortgage'),
(52, N'Subject Mortgage Maturity Date', N'Maturity date not mentioned on the mortgage document'),
(53, N'Subject Mortgage Maturity Date', N'Maturity date not available on mortgage doc'),
(54, N'Subject Mortgage Modified', N'If B has value "Y" there should be value in Col named "Modification". Col F. If Not available need to flag.');

BEGIN TRANSACTION;

UPDATE target
SET target.Section = seed.Section,
    target.ExpectedExceptionText = seed.ExpectedExceptionText,
    target.IsActive = 1
FROM dbo.ValidationExceptionMaster AS target
INNER JOIN @Seed AS seed ON seed.SourceRowNumber = target.SourceRowNumber;

INSERT INTO dbo.ValidationExceptionMaster (SourceRowNumber, Section, ExpectedExceptionText, IsActive)
SELECT seed.SourceRowNumber, seed.Section, seed.ExpectedExceptionText, 1
FROM @Seed AS seed
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.ValidationExceptionMaster AS target
    WHERE target.SourceRowNumber = seed.SourceRowNumber
);

UPDATE target
SET target.IsActive = 0
FROM dbo.ValidationExceptionMaster AS target
WHERE NOT EXISTS
(
    SELECT 1
    FROM @Seed AS seed
    WHERE seed.SourceRowNumber = target.SourceRowNumber
);

COMMIT TRANSACTION;
