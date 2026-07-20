SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF COL_LENGTH('dbo.AssetsAllocation','ShiftID') IS NULL ALTER TABLE dbo.AssetsAllocation ADD ShiftID INT NULL;
IF COL_LENGTH('dbo.AssetsAllocation','ShiftName') IS NULL ALTER TABLE dbo.AssetsAllocation ADD ShiftName NVARCHAR(100) NULL;
GO
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.AssetsAllocation') AND name='UX_AssetsAllocation_ActiveAssetShift')
AND NOT EXISTS(SELECT AssetID,ShiftID FROM dbo.AssetsAllocation WHERE IsDeleted=0 AND Status='Allocated' AND ReturnDate IS NULL AND ShiftID IS NOT NULL GROUP BY AssetID,ShiftID HAVING COUNT(*)>1)
CREATE UNIQUE INDEX UX_AssetsAllocation_ActiveAssetShift ON dbo.AssetsAllocation(AssetID,ShiftID) WHERE IsDeleted=0 AND Status='Allocated' AND ReturnDate IS NULL AND ShiftID IS NOT NULL;
GO

IF OBJECT_ID('dbo.AssetEmployeeITFieldMaster','U') IS NULL
BEGIN
    CREATE TABLE dbo.AssetEmployeeITFieldMaster
    (
        FieldID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_AssetEmployeeITFieldMaster PRIMARY KEY,
        FieldLabel NVARCHAR(150) NOT NULL,
        FieldCode VARCHAR(100) NOT NULL CONSTRAINT UQ_AssetEmployeeITFieldMaster_Code UNIQUE,
        FieldType VARCHAR(20) NOT NULL CONSTRAINT CK_AssetEmployeeITFieldMaster_Type CHECK(FieldType IN('Text','YesNo','LongText')),
        DisplayOrder INT NOT NULL CONSTRAINT DF_AssetEmployeeITFieldMaster_Order DEFAULT(100),
        IsRequired BIT NOT NULL CONSTRAINT DF_AssetEmployeeITFieldMaster_Required DEFAULT(0),
        IsActive BIT NOT NULL CONSTRAINT DF_AssetEmployeeITFieldMaster_Active DEFAULT(1),
        IsSystem BIT NOT NULL CONSTRAINT DF_AssetEmployeeITFieldMaster_System DEFAULT(0),
        IsReadOnly BIT NOT NULL CONSTRAINT DF_AssetEmployeeITFieldMaster_ReadOnly DEFAULT(0),
        EmployeeInfoColumn VARCHAR(100) NULL,
        DependsOnFieldCode VARCHAR(100) NULL,
        DependsOnValue NVARCHAR(100) NULL,
        AddedBy BIGINT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_AssetEmployeeITFieldMaster_Added DEFAULT(GETDATE()),
        UpdatedBy BIGINT NULL, UpdatedDate DATETIME NULL
    );
END;
GO

IF OBJECT_ID('dbo.AssetEmployeeITValue','U') IS NULL
BEGIN
    CREATE TABLE dbo.AssetEmployeeITValue
    (
        EmployeeITValueID BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_AssetEmployeeITValue PRIMARY KEY,
        EmployeeID BIGINT NOT NULL,
        FieldID INT NOT NULL,
        FieldValue NVARCHAR(MAX) NULL,
        AddedBy BIGINT NULL, AddedDate DATETIME NOT NULL CONSTRAINT DF_AssetEmployeeITValue_Added DEFAULT(GETDATE()),
        UpdatedBy BIGINT NULL, UpdatedDate DATETIME NULL,
        CONSTRAINT FK_AssetEmployeeITValue_Field FOREIGN KEY(FieldID) REFERENCES dbo.AssetEmployeeITFieldMaster(FieldID),
        CONSTRAINT UQ_AssetEmployeeITValue_EmployeeField UNIQUE(EmployeeID,FieldID)
    );
END;
GO

MERGE dbo.AssetEmployeeITFieldMaster AS T
USING (VALUES
('Official Email ID','OFFICIAL_EMAIL','Text',10,0,1,1,1,'OfficialEmailID',NULL,NULL),
('Infinity Pseudoname','INFINITY_PSEUDONAME','Text',20,0,1,1,0,NULL,NULL,NULL),
('Canopy Pseudoname','CANOPY_PSEUDONAME','Text',30,0,1,1,0,NULL,NULL,NULL),
('Canopy Web Access','CANOPY_WEB_ACCESS','YesNo',35,0,1,1,0,NULL,NULL,NULL),
('Canopy Web URL','CANOPY_WEB_URL','Text',36,0,1,1,0,NULL,'CANOPY_WEB_ACCESS','Yes'),
('Box ID','BOX_ID','Text',40,0,1,1,0,NULL,NULL,NULL),
('Box Folders Access','BOX_FOLDERS_ACCESS','YesNo',50,0,1,1,0,NULL,NULL,NULL),
('Which Box Folders (comma separated)','BOX_FOLDERS','LongText',60,0,1,1,0,NULL,'BOX_FOLDERS_ACCESS','Yes'),
('VDI Access','VDI_ACCESS','YesNo',70,0,1,1,0,NULL,NULL,NULL)
) S(FieldLabel,FieldCode,FieldType,DisplayOrder,IsRequired,IsActive,IsSystem,IsReadOnly,EmployeeInfoColumn,DependsOnFieldCode,DependsOnValue)
ON T.FieldCode=S.FieldCode
WHEN MATCHED THEN UPDATE SET T.FieldLabel=S.FieldLabel,T.DisplayOrder=S.DisplayOrder,T.IsSystem=1,T.IsReadOnly=S.IsReadOnly,T.EmployeeInfoColumn=S.EmployeeInfoColumn,T.DependsOnFieldCode=S.DependsOnFieldCode,T.DependsOnValue=S.DependsOnValue
WHEN NOT MATCHED THEN INSERT(FieldLabel,FieldCode,FieldType,DisplayOrder,IsRequired,IsActive,IsSystem,IsReadOnly,EmployeeInfoColumn,DependsOnFieldCode,DependsOnValue)
VALUES(S.FieldLabel,S.FieldCode,S.FieldType,S.DisplayOrder,S.IsRequired,S.IsActive,S.IsSystem,S.IsReadOnly,S.EmployeeInfoColumn,S.DependsOnFieldCode,S.DependsOnValue);
GO

IF OBJECT_ID('dbo.usp_Assets_SaveEmployeeITField','P') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Assets_SaveEmployeeITField AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_Assets_SaveEmployeeITField
 @FieldID INT,@FieldLabel NVARCHAR(150),@FieldCode VARCHAR(100),@FieldType VARCHAR(20),@DisplayOrder INT,@IsRequired BIT,@IsActive BIT,
 @DependsOnFieldCode VARCHAR(100)=NULL,@DependsOnValue NVARCHAR(100)=NULL,@UserID BIGINT
AS
BEGIN
 SET NOCOUNT ON;
 SET @FieldLabel=LTRIM(RTRIM(@FieldLabel)); SET @FieldCode=UPPER(LTRIM(RTRIM(@FieldCode)));
 SET @DependsOnFieldCode=NULLIF(UPPER(LTRIM(RTRIM(@DependsOnFieldCode))),''); SET @DependsOnValue=NULLIF(LTRIM(RTRIM(@DependsOnValue)),'');
 IF ISNULL(@FieldLabel,'')='' RAISERROR('Field label is required.',16,1);
 IF ISNULL(@FieldCode,'')='' RAISERROR('Field code is required.',16,1);
 IF @FieldType NOT IN('Text','YesNo','LongText') RAISERROR('Invalid field type.',16,1);
 IF EXISTS(SELECT 1 FROM dbo.AssetEmployeeITFieldMaster WHERE FieldCode=@FieldCode AND FieldID<>ISNULL(@FieldID,0)) RAISERROR('Field code already exists.',16,1);
 IF @DependsOnFieldCode=@FieldCode RAISERROR('A field cannot depend on itself.',16,1);
 IF @DependsOnFieldCode IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.AssetEmployeeITFieldMaster WHERE FieldCode=@DependsOnFieldCode AND FieldType='YesNo' AND IsActive=1) RAISERROR('The dependency must be an active Yes / No field.',16,1);
 IF @DependsOnFieldCode IS NOT NULL AND @DependsOnValue NOT IN('Yes','No') RAISERROR('Dependency value must be Yes or No.',16,1);
 IF ISNULL(@FieldID,0)=0
 BEGIN
  INSERT dbo.AssetEmployeeITFieldMaster(FieldLabel,FieldCode,FieldType,DisplayOrder,IsRequired,IsActive,DependsOnFieldCode,DependsOnValue,AddedBy) VALUES(@FieldLabel,@FieldCode,@FieldType,@DisplayOrder,@IsRequired,@IsActive,@DependsOnFieldCode,@DependsOnValue,@UserID);
  SET @FieldID=SCOPE_IDENTITY();
 END
 ELSE
 BEGIN
  UPDATE dbo.AssetEmployeeITFieldMaster SET FieldLabel=@FieldLabel,FieldCode=CASE WHEN IsSystem=1 THEN FieldCode ELSE @FieldCode END,FieldType=CASE WHEN IsSystem=1 THEN FieldType ELSE @FieldType END,
  DisplayOrder=@DisplayOrder,IsRequired=@IsRequired,IsActive=@IsActive,DependsOnFieldCode=@DependsOnFieldCode,DependsOnValue=@DependsOnValue,UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE FieldID=@FieldID;
  IF @@ROWCOUNT=0 RAISERROR('IT field was not found.',16,1);
 END
 SELECT CONVERT(BIGINT,@FieldID);
END;
GO

IF OBJECT_ID('dbo.usp_Assets_SaveEmployeeITProfile','P') IS NULL EXEC('CREATE PROCEDURE dbo.usp_Assets_SaveEmployeeITProfile AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.usp_Assets_SaveEmployeeITProfile @Xml XML,@UserID BIGINT
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 DECLARE @EmployeeID BIGINT=@Xml.value('(/EmployeeITProfileInput/EmployeeID/text())[1]','BIGINT');
 IF NOT EXISTS(SELECT 1 FROM dbo.EmployeeInfo WHERE EmployeeID=@EmployeeID AND ISNULL(IsDelete,0)=0) RAISERROR('Employee was not found.',16,1);
 DECLARE @Values TABLE(FieldID INT PRIMARY KEY,FieldValue NVARCHAR(MAX));
 INSERT @Values(FieldID,FieldValue)
 SELECT N.value('(FieldID/text())[1]','INT'),N.value('(FieldValue/text())[1]','NVARCHAR(4000)') FROM @Xml.nodes('/EmployeeITProfileInput/Values/EmployeeITValueInput') X(N);
 IF EXISTS(SELECT 1 FROM @Values v LEFT JOIN dbo.AssetEmployeeITFieldMaster f ON f.FieldID=v.FieldID AND f.IsActive=1 WHERE f.FieldID IS NULL) RAISERROR('One or more IT fields are invalid.',16,1);
 BEGIN TRANSACTION;
 MERGE dbo.AssetEmployeeITValue T USING(SELECT @EmployeeID EmployeeID,v.FieldID,NULLIF(LTRIM(RTRIM(v.FieldValue)),'') FieldValue FROM @Values v INNER JOIN dbo.AssetEmployeeITFieldMaster f ON f.FieldID=v.FieldID AND f.IsReadOnly=0) S
 ON T.EmployeeID=S.EmployeeID AND T.FieldID=S.FieldID
 WHEN MATCHED THEN UPDATE SET T.FieldValue=S.FieldValue,T.UpdatedBy=@UserID,T.UpdatedDate=GETDATE()
 WHEN NOT MATCHED THEN INSERT(EmployeeID,FieldID,FieldValue,AddedBy) VALUES(S.EmployeeID,S.FieldID,S.FieldValue,@UserID);
 COMMIT TRANSACTION;
 SELECT CONVERT(BIGINT,@EmployeeID);
END;
GO
