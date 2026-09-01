SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

ALTER TABLE dbo.ErrorType2Master ADD CONSTRAINT FK_ErrorType2Master_ErrorType1Master FOREIGN KEY (ErrorType1ID) REFERENCES dbo.ErrorType1Master(ID);
ALTER TABLE dbo.ErrorType3Master ADD CONSTRAINT FK_ErrorType3Master_ErrorType2Master FOREIGN KEY (ErrorType2ID) REFERENCES dbo.ErrorType2Master(ID);
ALTER TABLE dbo.ErrorType5Master ADD CONSTRAINT FK_ErrorType5Master_TaxonomyMaster FOREIGN KEY (TaxonomyID) REFERENCES dbo.TaxonomyMaster(ID);
ALTER TABLE dbo.ErrorType6Master ADD CONSTRAINT FK_ErrorType6Master_ErrorType5Master FOREIGN KEY (ErrorType5ID) REFERENCES dbo.ErrorType5Master(ID);
ALTER TABLE dbo.ErrorType7Master ADD CONSTRAINT FK_ErrorType7Master_ErrorType6Master FOREIGN KEY (ErrorType6ID) REFERENCES dbo.ErrorType6Master(ID);

ALTER TABLE dbo.InfinityFeedbackErrorSelection ADD CONSTRAINT FK_IFES_ET1 FOREIGN KEY (ErrorType1ID) REFERENCES dbo.ErrorType1Master(ID);
ALTER TABLE dbo.InfinityFeedbackErrorSelection ADD CONSTRAINT FK_IFES_ET2 FOREIGN KEY (ErrorType2ID) REFERENCES dbo.ErrorType2Master(ID);
ALTER TABLE dbo.InfinityFeedbackErrorSelection ADD CONSTRAINT FK_IFES_ET3 FOREIGN KEY (ErrorType3ID) REFERENCES dbo.ErrorType3Master(ID);
ALTER TABLE dbo.InfinityFeedbackErrorSelection ADD CONSTRAINT FK_IFES_ET4 FOREIGN KEY (ErrorType4ID) REFERENCES dbo.ErrorType4Master(ID);
ALTER TABLE dbo.InfinityFeedbackErrorSelection ADD CONSTRAINT FK_IFES_ET5 FOREIGN KEY (ErrorType5ID) REFERENCES dbo.ErrorType5Master(ID);
ALTER TABLE dbo.InfinityFeedbackErrorSelection ADD CONSTRAINT FK_IFES_ET6 FOREIGN KEY (ErrorType6ID) REFERENCES dbo.ErrorType6Master(ID);
ALTER TABLE dbo.InfinityFeedbackErrorSelection ADD CONSTRAINT FK_IFES_ET7 FOREIGN KEY (ErrorType7ID) REFERENCES dbo.ErrorType7Master(ID);
ALTER TABLE dbo.InfinityFeedbackErrorSelection ADD CONSTRAINT FK_IFES_ET8 FOREIGN KEY (ErrorType8ID) REFERENCES dbo.ErrorType8Master(ID);
ALTER TABLE dbo.InfinityFeedbackErrorSelection ADD CONSTRAINT FK_IFES_ET9 FOREIGN KEY (ErrorType9ID) REFERENCES dbo.ErrorType9Master(ID);

CREATE UNIQUE NONCLUSTERED INDEX UX_TaxonomyMaster_Name ON dbo.TaxonomyMaster(Name);
CREATE UNIQUE NONCLUSTERED INDEX UX_ErrorType1Master_Name ON dbo.ErrorType1Master(Name);
CREATE UNIQUE NONCLUSTERED INDEX UX_ErrorType2Master_Parent_Name ON dbo.ErrorType2Master(ErrorType1ID, Name);
CREATE UNIQUE NONCLUSTERED INDEX UX_ErrorType3Master_Parent_Name ON dbo.ErrorType3Master(ErrorType2ID, Name);
CREATE UNIQUE NONCLUSTERED INDEX UX_ErrorType4Master_Name ON dbo.ErrorType4Master(Name);
CREATE UNIQUE NONCLUSTERED INDEX UX_ErrorType5Master_Taxonomy_Name ON dbo.ErrorType5Master(TaxonomyID, Name) WHERE TaxonomyID IS NOT NULL;
CREATE UNIQUE NONCLUSTERED INDEX UX_ErrorType5Master_Unmapped_Name ON dbo.ErrorType5Master(Name) WHERE TaxonomyID IS NULL;
CREATE UNIQUE NONCLUSTERED INDEX UX_ErrorType6Master_Parent_Name ON dbo.ErrorType6Master(ErrorType5ID, Name);
CREATE UNIQUE NONCLUSTERED INDEX UX_ErrorType7Master_Parent_Name ON dbo.ErrorType7Master(ErrorType6ID, Name);
CREATE UNIQUE NONCLUSTERED INDEX UX_ErrorType8Master_Name ON dbo.ErrorType8Master(Name);
CREATE UNIQUE NONCLUSTERED INDEX UX_ErrorType9Master_Name ON dbo.ErrorType9Master(Name);
CREATE UNIQUE NONCLUSTERED INDEX UX_IFES_FeedbackID ON dbo.InfinityFeedbackErrorSelection(FeedbackID);

CREATE NONCLUSTERED INDEX IX_ErrorType2Master_Active_Order ON dbo.ErrorType2Master(ErrorType1ID, IsActive, DisplayOrder) INCLUDE (Name);
CREATE NONCLUSTERED INDEX IX_ErrorType3Master_Active_Order ON dbo.ErrorType3Master(ErrorType2ID, IsActive, DisplayOrder) INCLUDE (Name);
CREATE NONCLUSTERED INDEX IX_ErrorType5Master_Taxonomy_Active_Order ON dbo.ErrorType5Master(TaxonomyID, IsActive, DisplayOrder) INCLUDE (Name);
CREATE NONCLUSTERED INDEX IX_ErrorType6Master_Active_Order ON dbo.ErrorType6Master(ErrorType5ID, IsActive, DisplayOrder) INCLUDE (Name);
CREATE NONCLUSTERED INDEX IX_ErrorType7Master_Active_Order ON dbo.ErrorType7Master(ErrorType6ID, IsActive, DisplayOrder) INCLUDE (Name);

COMMIT TRANSACTION;
GO

