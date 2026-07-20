/* Run once in the WebPortal database. Safe to re-run. */
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF COL_LENGTH('dbo.AssetCategoryMaster','CompanyID') IS NULL
    ALTER TABLE dbo.AssetCategoryMaster ADD CompanyID INT NULL;

IF OBJECT_ID('dbo.Company','U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_AssetCategoryMaster_Company')
    ALTER TABLE dbo.AssetCategoryMaster ADD CONSTRAINT FK_AssetCategoryMaster_Company FOREIGN KEY(CompanyID) REFERENCES dbo.Company(CompanyID);

IF OBJECT_ID('dbo.AssetUserCategoryAccess','U') IS NULL
BEGIN
    CREATE TABLE dbo.AssetUserCategoryAccess
    (
        AccessID BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_AssetUserCategoryAccess PRIMARY KEY,
        UserID BIGINT NOT NULL,
        AssetCategoryID INT NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_AssetUserCategoryAccess_IsActive DEFAULT(1),
        AddedBy BIGINT NULL,
        AddedDate DATETIME NOT NULL CONSTRAINT DF_AssetUserCategoryAccess_AddedDate DEFAULT(GETDATE()),
        UpdatedBy BIGINT NULL,
        UpdatedDate DATETIME NULL,
        CONSTRAINT FK_AssetUserCategoryAccess_Category FOREIGN KEY(AssetCategoryID) REFERENCES dbo.AssetCategoryMaster(AssetCategoryID)
    );
    CREATE INDEX IX_AssetUserCategoryAccess_User ON dbo.AssetUserCategoryAccess(UserID,IsActive,AssetCategoryID);
    CREATE UNIQUE INDEX UX_AssetUserCategoryAccess_UserCategory ON dbo.AssetUserCategoryAccess(UserID,AssetCategoryID) WHERE AssetCategoryID IS NOT NULL;
    CREATE UNIQUE INDEX UX_AssetUserCategoryAccess_Profile ON dbo.AssetUserCategoryAccess(UserID) WHERE AssetCategoryID IS NULL;
END;

/* Add/update the new master menu without modifying the old Asset section. */
IF EXISTS (SELECT 1 FROM dbo.MenuMaster1 WHERE MenuId=19208 AND MenuName<>'Category Access')
    RAISERROR('MenuId 19208 is already used by another menu.',16,1);
ELSE IF EXISTS (SELECT 1 FROM dbo.MenuMaster1 WHERE MenuId=19208)
    UPDATE dbo.MenuMaster1 SET MenuName='Category Access',ParentMenuId=19200,Url='../Assets/AssetCategoryAccessMaster.aspx',SectionName=NULL,SortOrder=8 WHERE MenuId=19208;
ELSE
    INSERT dbo.MenuMaster1(MenuId,MenuName,ParentMenuId,Url,SectionName,SortOrder) VALUES(19208,'Category Access',19200,'../Assets/AssetCategoryAccessMaster.aspx',NULL,8);

INSERT dbo.GroupMenuMapping(GroupId,MenuId)
SELECT parentMapping.GroupId,19208
FROM dbo.GroupMenuMapping parentMapping
WHERE parentMapping.MenuId IN (19000,19200)
  AND NOT EXISTS (SELECT 1 FROM dbo.GroupMenuMapping existing WHERE existing.GroupId=parentMapping.GroupId AND existing.MenuId=19208)
GROUP BY parentMapping.GroupId;

SELECT 'Asset category access setup completed.' Result;
