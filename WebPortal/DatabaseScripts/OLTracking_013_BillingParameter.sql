SET NOCOUNT ON;
SET XACT_ABORT ON;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NULL
BEGIN
    THROW 50001, 'Table dbo.WBT_ProjectTrackingFieldConfig does not exist.', 1;
END;

IF COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig', 'IsBillingParameter') IS NULL
BEGIN
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig
        ADD IsBillingParameter bit NOT NULL
            CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsBillingParameter DEFAULT (0) WITH VALUES;
END;
