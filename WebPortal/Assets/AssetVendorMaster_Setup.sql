/* Adds structured Vendor Master profile and banking fields. Safe to re-run. */
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF COL_LENGTH('dbo.AssetVendorMaster','Description') IS NULL ALTER TABLE dbo.AssetVendorMaster ADD Description nvarchar(1000) NULL;
IF COL_LENGTH('dbo.AssetVendorMaster','FaxNumber') IS NULL ALTER TABLE dbo.AssetVendorMaster ADD FaxNumber nvarchar(100) NULL;
IF COL_LENGTH('dbo.AssetVendorMaster','WebsiteURL') IS NULL ALTER TABLE dbo.AssetVendorMaster ADD WebsiteURL nvarchar(500) NULL;
IF COL_LENGTH('dbo.AssetVendorMaster','AccountHolderName') IS NULL ALTER TABLE dbo.AssetVendorMaster ADD AccountHolderName nvarchar(300) NULL;
IF COL_LENGTH('dbo.AssetVendorMaster','BankName') IS NULL ALTER TABLE dbo.AssetVendorMaster ADD BankName nvarchar(300) NULL;
IF COL_LENGTH('dbo.AssetVendorMaster','BankBranchAddress') IS NULL ALTER TABLE dbo.AssetVendorMaster ADD BankBranchAddress nvarchar(1000) NULL;
IF COL_LENGTH('dbo.AssetVendorMaster','AccountType') IS NULL ALTER TABLE dbo.AssetVendorMaster ADD AccountType nvarchar(100) NULL;
IF COL_LENGTH('dbo.AssetVendorMaster','AccountNumber') IS NULL ALTER TABLE dbo.AssetVendorMaster ADD AccountNumber nvarchar(150) NULL;
IF COL_LENGTH('dbo.AssetVendorMaster','MICRCode') IS NULL ALTER TABLE dbo.AssetVendorMaster ADD MICRCode nvarchar(50) NULL;
IF COL_LENGTH('dbo.AssetVendorMaster','IFSCCode') IS NULL ALTER TABLE dbo.AssetVendorMaster ADD IFSCCode nvarchar(50) NULL;

SELECT 'Asset Vendor Master schema updated.' Result;
