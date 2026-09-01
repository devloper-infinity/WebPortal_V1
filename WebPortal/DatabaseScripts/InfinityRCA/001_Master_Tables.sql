/* SQL Server 2016. Run in InfinityERP before the remaining numbered scripts. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

CREATE TABLE dbo.TaxonomyMaster
(
    ID int NOT NULL,
    Name nvarchar(250) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_TaxonomyMaster_IsActive DEFAULT (1),
    DisplayOrder int NOT NULL,
    AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_TaxonomyMaster_AddedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_TaxonomyMaster PRIMARY KEY CLUSTERED (ID)
);

CREATE TABLE dbo.ErrorType1Master
(
    ID int NOT NULL, Name nvarchar(500) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_ErrorType1Master_IsActive DEFAULT (1),
    DisplayOrder int NOT NULL, AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_ErrorType1Master_AddedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_ErrorType1Master PRIMARY KEY CLUSTERED (ID)
);

CREATE TABLE dbo.ErrorType2Master
(
    ID int NOT NULL, ErrorType1ID int NOT NULL, Name nvarchar(500) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_ErrorType2Master_IsActive DEFAULT (1),
    DisplayOrder int NOT NULL, AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_ErrorType2Master_AddedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_ErrorType2Master PRIMARY KEY CLUSTERED (ID)
);

CREATE TABLE dbo.ErrorType3Master
(
    ID int NOT NULL, ErrorType2ID int NOT NULL, Name nvarchar(500) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_ErrorType3Master_IsActive DEFAULT (1),
    DisplayOrder int NOT NULL, AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_ErrorType3Master_AddedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_ErrorType3Master PRIMARY KEY CLUSTERED (ID)
);

CREATE TABLE dbo.ErrorType4Master
(
    ID int NOT NULL, Name nvarchar(500) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_ErrorType4Master_IsActive DEFAULT (1),
    DisplayOrder int NOT NULL, AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_ErrorType4Master_AddedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_ErrorType4Master PRIMARY KEY CLUSTERED (ID)
);

CREATE TABLE dbo.ErrorType5Master
(
    ID int NOT NULL, TaxonomyID int NULL, Name nvarchar(500) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_ErrorType5Master_IsActive DEFAULT (1),
    DisplayOrder int NOT NULL, AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_ErrorType5Master_AddedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_ErrorType5Master PRIMARY KEY CLUSTERED (ID)
);

CREATE TABLE dbo.ErrorType6Master
(
    ID int NOT NULL, ErrorType5ID int NOT NULL, Name nvarchar(500) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_ErrorType6Master_IsActive DEFAULT (1),
    DisplayOrder int NOT NULL, AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_ErrorType6Master_AddedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_ErrorType6Master PRIMARY KEY CLUSTERED (ID)
);

CREATE TABLE dbo.ErrorType7Master
(
    ID int NOT NULL, ErrorType6ID int NOT NULL, Name nvarchar(500) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_ErrorType7Master_IsActive DEFAULT (1),
    DisplayOrder int NOT NULL, AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_ErrorType7Master_AddedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_ErrorType7Master PRIMARY KEY CLUSTERED (ID)
);

CREATE TABLE dbo.ErrorType8Master
(
    ID int NOT NULL, Name nvarchar(500) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_ErrorType8Master_IsActive DEFAULT (1),
    DisplayOrder int NOT NULL, AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_ErrorType8Master_AddedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_ErrorType8Master PRIMARY KEY CLUSTERED (ID)
);

CREATE TABLE dbo.ErrorType9Master
(
    ID int NOT NULL, Name nvarchar(500) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_ErrorType9Master_IsActive DEFAULT (1),
    DisplayOrder int NOT NULL, AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_ErrorType9Master_AddedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_ErrorType9Master PRIMARY KEY CLUSTERED (ID)
);

CREATE TABLE dbo.InfinityFeedbackErrorSelection
(
    ID bigint IDENTITY(1,1) NOT NULL,
    FeedbackID bigint NOT NULL,
    ErrorType1ID int NOT NULL,
    ErrorType2ID int NOT NULL,
    ErrorType3ID int NOT NULL,
    ErrorType4ID int NOT NULL,
    ErrorType5ID int NOT NULL,
    ErrorType6ID int NOT NULL,
    ErrorType7ID int NOT NULL,
    ErrorType8ID int NOT NULL,
    ErrorType9ID int NOT NULL,
    AddedBy int NOT NULL,
    AddedDate datetime NOT NULL CONSTRAINT DF_InfinityFeedbackErrorSelection_AddedDate DEFAULT (GETDATE()),
    UpdatedBy int NULL,
    UpdatedDate datetime NULL,
    CONSTRAINT PK_InfinityFeedbackErrorSelection PRIMARY KEY CLUSTERED (ID)
);

COMMIT TRANSACTION;
GO

