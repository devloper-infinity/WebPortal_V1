/* Corporate resources for Credit Card Reconciliation user mapping.
   Safe to re-run; this migration does not modify existing invoice calculations. */
IF OBJECT_ID(N'dbo.CCCorporateResource', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CCCorporateResource
    (
        ResourceID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CCCorporateResource PRIMARY KEY,
        ResourceName NVARCHAR(255) NOT NULL,
        ResourceType NVARCHAR(100) NOT NULL,
        AccountIdentifier NVARCHAR(255) NULL,
        ProjectID INT NOT NULL,
        DepartmentDomain NVARCHAR(255) NULL,
        Description NVARCHAR(1000) NULL,
        EffectiveFrom DATE NOT NULL,
        EffectiveTo DATE NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_CCCorporateResource_IsActive DEFAULT(1),
        Remark NVARCHAR(1000) NULL,
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME NOT NULL CONSTRAINT DF_CCCorporateResource_CreatedDate DEFAULT(GETDATE()),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        CONSTRAINT FK_CCCorporateResource_Project FOREIGN KEY(ProjectID) REFERENCES dbo.Project(ProjectID),
        CONSTRAINT CK_CCCorporateResource_Dates CHECK(EffectiveTo IS NULL OR EffectiveTo >= EffectiveFrom)
    );
END;
GO

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.CCCorporateResource') AND name=N'IX_CCCorporateResource_Project_Status')
    CREATE INDEX IX_CCCorporateResource_Project_Status ON dbo.CCCorporateResource(ProjectID, IsActive, EffectiveFrom);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.CCCorporateResource') AND name=N'UX_CCCorporateResource_Project_Name')
    CREATE UNIQUE INDEX UX_CCCorporateResource_Project_Name ON dbo.CCCorporateResource(ProjectID, ResourceName);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.CCCorporateResource') AND name=N'UX_CCCorporateResource_Project_Account')
    CREATE UNIQUE INDEX UX_CCCorporateResource_Project_Account ON dbo.CCCorporateResource(ProjectID, AccountIdentifier)
        WHERE AccountIdentifier IS NOT NULL;
GO

IF OBJECT_ID(N'dbo.CCCorporateResourceEmployee', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CCCorporateResourceEmployee
    (
        MappingID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CCCorporateResourceEmployee PRIMARY KEY,
        ResourceID INT NOT NULL,
        EmployeeCode NVARCHAR(50) NOT NULL,
        EffectiveFrom DATE NOT NULL,
        EffectiveTo DATE NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_CCCorporateResourceEmployee_IsActive DEFAULT(1),
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME NOT NULL CONSTRAINT DF_CCCorporateResourceEmployee_CreatedDate DEFAULT(GETDATE()),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        CONSTRAINT FK_CCCorporateResourceEmployee_Resource FOREIGN KEY(ResourceID) REFERENCES dbo.CCCorporateResource(ResourceID),
        CONSTRAINT CK_CCCorporateResourceEmployee_Dates CHECK(EffectiveTo IS NULL OR EffectiveTo >= EffectiveFrom)
    );
END;
GO
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.CCCorporateResourceEmployee') AND name=N'IX_CCCorporateResourceEmployee_Lookup')
    CREATE INDEX IX_CCCorporateResourceEmployee_Lookup ON dbo.CCCorporateResourceEmployee(ResourceID, EmployeeCode, EffectiveFrom, EffectiveTo);
GO

IF OBJECT_ID(N'dbo.CCCorporateResourceEmployeeHistory', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CCCorporateResourceEmployeeHistory
    (
        HistoryID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CCCorporateResourceEmployeeHistory PRIMARY KEY,
        MappingID INT NOT NULL,
        ResourceID INT NOT NULL,
        EmployeeCode NVARCHAR(50) NOT NULL,
        EffectiveFrom DATE NOT NULL,
        EffectiveTo DATE NULL,
        IsActive BIT NOT NULL,
        ChangeAction NVARCHAR(20) NOT NULL,
        ChangedBy INT NOT NULL,
        ChangedDate DATETIME NOT NULL CONSTRAINT DF_CCCorporateResourceEmployeeHistory_ChangedDate DEFAULT(GETDATE()),
        CONSTRAINT FK_CCCorporateResourceEmployeeHistory_Mapping FOREIGN KEY(MappingID) REFERENCES dbo.CCCorporateResourceEmployee(MappingID),
        CONSTRAINT FK_CCCorporateResourceEmployeeHistory_Resource FOREIGN KEY(ResourceID) REFERENCES dbo.CCCorporateResource(ResourceID)
    );
    CREATE INDEX IX_CCCorporateResourceEmployeeHistory_Mapping ON dbo.CCCorporateResourceEmployeeHistory(MappingID, ChangedDate DESC);
END;
GO

IF OBJECT_ID(N'dbo.CCCorporateResourceBilling', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CCCorporateResourceBilling
    (
        AssociationID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CCCorporateResourceBilling PRIMARY KEY,
        HeaderID INT NOT NULL,
        BillingMonth NVARCHAR(20) NOT NULL,
        BillingYear NVARCHAR(4) NOT NULL,
        ResourceID INT NOT NULL,
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME NOT NULL CONSTRAINT DF_CCCorporateResourceBilling_CreatedDate DEFAULT(GETDATE()),
        CONSTRAINT FK_CCCorporateResourceBilling_Header FOREIGN KEY(HeaderID) REFERENCES dbo.CCInvoiceHeaders(HeaderID),
        CONSTRAINT FK_CCCorporateResourceBilling_Resource FOREIGN KEY(ResourceID) REFERENCES dbo.CCCorporateResource(ResourceID),
        CONSTRAINT UQ_CCCorporateResourceBilling_Period UNIQUE(HeaderID, BillingMonth, BillingYear)
    );
END;
GO
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.CCCorporateResourceBilling') AND name=N'IX_CCCorporateResourceBilling_Resource_Period')
    CREATE INDEX IX_CCCorporateResourceBilling_Resource_Period ON dbo.CCCorporateResourceBilling(ResourceID, BillingYear, BillingMonth);
GO
