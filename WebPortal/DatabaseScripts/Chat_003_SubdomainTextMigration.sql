/* Convert chat partitioning to EmployeeInfo.SubDomain's normalized NVARCHAR value.
   Preserves existing rows. Run once, then run Chat_002_LegacyCompatibility.sql. */
SET XACT_ABORT ON;
BEGIN TRAN;
IF EXISTS(SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('dbo.ChatConversation') AND name='SubdomainID' AND system_type_id=56)
BEGIN
 IF EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.ChatConversation') AND name='UX_ChatConversation_Direct') DROP INDEX UX_ChatConversation_Direct ON dbo.ChatConversation;
 IF EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.ChatConversation') AND name='IX_ChatConversation_Subdomain') DROP INDEX IX_ChatConversation_Subdomain ON dbo.ChatConversation;
 ALTER TABLE dbo.ChatConversation ALTER COLUMN SubdomainID nvarchar(100) NOT NULL;
 UPDATE c SET SubdomainID=UPPER(LTRIM(RTRIM(sd.SubDomainName)))
 FROM dbo.ChatConversation c JOIN dbo.SubDomain sd ON CONVERT(nvarchar(100),sd.SubDomainID)=c.SubdomainID;
 CREATE UNIQUE INDEX UX_ChatConversation_Direct ON dbo.ChatConversation(SubdomainID,DirectKey) WHERE ConversationType='D' AND IsActive=1;
 CREATE INDEX IX_ChatConversation_Subdomain ON dbo.ChatConversation(SubdomainID,ConversationID DESC);
END;
COMMIT;
GO
