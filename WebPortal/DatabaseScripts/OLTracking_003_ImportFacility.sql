SET NOCOUNT ON;
SET XACT_ABORT ON;

IF OBJECT_ID('dbo.OLTracking_ImportFieldConfiguration', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ImportFieldConfiguration
    (
        FieldConfigId int NOT NULL CONSTRAINT PK_OLTracking_ImportFieldConfiguration PRIMARY KEY,
        ProjectID int NOT NULL,
        IsForImport bit NOT NULL CONSTRAINT DF_OLTracking_ImportFieldConfiguration_IsForImport DEFAULT (1),
        AddedBy int NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ImportFieldConfiguration_AddedDate DEFAULT (GETDATE()),
        UpdatedBy int NULL,
        UpdatedDate datetime NULL
    );
END;

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.OLTracking_ImportFieldConfiguration')
      AND name = 'IX_OLTracking_ImportFieldConfiguration_Project'
)
BEGIN
    CREATE INDEX IX_OLTracking_ImportFieldConfiguration_Project
        ON dbo.OLTracking_ImportFieldConfiguration(ProjectID, IsForImport, FieldConfigId);
END;

IF OBJECT_ID('dbo.OLTracking_ImportBatch', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ImportBatch
    (
        ImportBatchId bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ImportBatch PRIMARY KEY,
        ProjectID int NOT NULL,
        OriginalFileName nvarchar(260) NOT NULL,
        TotalRows int NOT NULL,
        ImportedRows int NOT NULL,
        RejectedRows int NOT NULL,
        ImportStatus varchar(20) NOT NULL,
        ErrorMessage nvarchar(2000) NULL,
        ImportedBy int NOT NULL,
        ImportedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ImportBatch_ImportedDate DEFAULT (GETDATE())
    );
END;

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.OLTracking_ImportBatch')
      AND name = 'IX_OLTracking_ImportBatch_UserDate'
)
BEGIN
    CREATE INDEX IX_OLTracking_ImportBatch_UserDate
        ON dbo.OLTracking_ImportBatch(ImportedBy, ImportedDate DESC);
END;

IF COL_LENGTH('dbo.OLTracking_Item', 'RecordSource') IS NULL
BEGIN
    ALTER TABLE dbo.OLTracking_Item ADD RecordSource varchar(20) NOT NULL
        CONSTRAINT DF_OLTracking_Item_RecordSource DEFAULT ('Tracking') WITH VALUES;
END;

IF OBJECT_ID('dbo.OLTracking_ImportItemValue', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ImportItemValue
    (
        ImportItemValueID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ImportItemValue PRIMARY KEY,
        ItemID bigint NOT NULL,
        FieldConfigId int NOT NULL,
        FieldValue nvarchar(max) NULL,
        AddedBy int NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ImportItemValue_AddedDate DEFAULT (GETDATE()),
        UpdatedBy int NULL,
        UpdatedDate datetime NULL,
        CONSTRAINT FK_OLTracking_ImportItemValue_Item FOREIGN KEY (ItemID) REFERENCES dbo.OLTracking_Item(ItemID),
        CONSTRAINT UQ_OLTracking_ImportItemValue UNIQUE (ItemID, FieldConfigId)
    );
END;

IF OBJECT_ID('dbo.OLTracking_ImportBatchItem', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ImportBatchItem
    (
        ImportBatchItemID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ImportBatchItem PRIMARY KEY,
        ImportBatchId bigint NOT NULL,
        ItemID bigint NOT NULL,
        EntryDate date NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ImportBatchItem_AddedDate DEFAULT (GETDATE()),
        CONSTRAINT FK_OLTracking_ImportBatchItem_Batch FOREIGN KEY (ImportBatchId) REFERENCES dbo.OLTracking_ImportBatch(ImportBatchId),
        CONSTRAINT FK_OLTracking_ImportBatchItem_Item FOREIGN KEY (ItemID) REFERENCES dbo.OLTracking_Item(ItemID),
        CONSTRAINT UQ_OLTracking_ImportBatchItem UNIQUE (ImportBatchId, ItemID)
    );
END;

PRINT 'OLTracking import facility objects are ready.';
