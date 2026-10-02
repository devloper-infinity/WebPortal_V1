-- Agreement uploads use the existing dbo.AgreementVersionDocs table and
-- dbo.usp_InsertAgreementVersionDocs procedure. No schema changes are required.
-- This script only verifies the objects needed by the upload code.
IF OBJECT_ID('dbo.AgreementVersionDocs', 'U') IS NULL
    RAISERROR('AgreementVersionDocs table is missing.', 16, 1);
IF OBJECT_ID('dbo.usp_InsertAgreementVersionDocs', 'P') IS NULL
    RAISERROR('usp_InsertAgreementVersionDocs procedure is missing.', 16, 1);
IF OBJECT_ID('dbo.usp_InsertAgreementVersionHistory', 'P') IS NULL
    RAISERROR('usp_InsertAgreementVersionHistory procedure is missing.', 16, 1);
IF OBJECT_ID('dbo.usp_InsertAgreementTypeHistory', 'P') IS NULL
    RAISERROR('usp_InsertAgreementTypeHistory procedure is missing.', 16, 1);
