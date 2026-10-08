IF OBJECT_ID(N'dbo.CCInvoiceVerificationDetails', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CCInvoiceVerificationDetails
    (
        HeaderID INT NOT NULL PRIMARY KEY,
        ActiveThrough DATE NULL,
        ProjectID INT NOT NULL,
        ModifiedBy INT NOT NULL,
        ModifiedOn DATETIME NOT NULL CONSTRAINT DF_CCInvoiceVerificationDetails_ModifiedOn DEFAULT(GETDATE())
    );
END;
GO

IF OBJECT_ID(N'dbo.CCInvoiceDocuments', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CCInvoiceDocuments
    (
        DocumentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        HeaderID INT NOT NULL,
        OriginalFileName NVARCHAR(255) NOT NULL,
        StoredFileName NVARCHAR(255) NOT NULL,
        StoredPath NVARCHAR(1000) NOT NULL,
        UploadedOn DATETIME NOT NULL CONSTRAINT DF_CCInvoiceDocuments_UploadedOn DEFAULT(GETDATE()),
        UploadedBy INT NOT NULL
    );
    CREATE INDEX IX_CCInvoiceDocuments_HeaderID_UploadedOn
        ON dbo.CCInvoiceDocuments(HeaderID, UploadedOn DESC, DocumentID DESC);
END;
GO
