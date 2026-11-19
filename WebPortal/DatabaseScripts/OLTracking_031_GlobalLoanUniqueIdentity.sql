/* Permanent assignment identity: configured values remain visible, while ItemID
   guarantees that one loan cannot collide with a different loan in any process. */
ALTER FUNCTION dbo.OLTracking_BuildUniqueCombination
(
    @ProjectID int,
    @ItemID bigint,
    @ProcessID int
)
RETURNS nvarchar(2000)
AS
BEGIN
    DECLARE @ConfiguredCount int,
            @PopulatedCount int,
            @Parts nvarchar(max),
            @Result nvarchar(2000);

    SELECT @ConfiguredCount=COUNT(1)
    FROM dbo.WBT_ProjectTrackingFieldConfig
    WHERE ProjectID=@ProjectID
      AND IsUniqueField=1
      AND IsDeleted=0
      AND ISNULL(IsSystemGenerated,0)=0
      AND ISNULL(IsBillingField,0)=0;

    IF ISNULL(@ConfiguredCount,0)=0 RETURN NULL;

    SELECT @PopulatedCount=COUNT(1)
    FROM dbo.WBT_ProjectTrackingFieldConfig field
    OUTER APPLY
    (
        SELECT TOP(1) NULLIF(LTRIM(RTRIM(CONVERT(nvarchar(2000),value.FieldValue))),'') FieldValue
        FROM dbo.OLTracking_ImportItemValue value
        WHERE value.ItemID=@ItemID AND value.FieldConfigId=field.FieldConfigId
    ) imported
    WHERE field.ProjectID=@ProjectID
      AND field.IsUniqueField=1
      AND field.IsDeleted=0
      AND ISNULL(field.IsSystemGenerated,0)=0
      AND ISNULL(field.IsBillingField,0)=0
      AND
      (
          (ISNULL(field.IsProcessColumn,0)=1 OR field.DataType='Process')
          OR imported.FieldValue IS NOT NULL
      );

    IF @PopulatedCount<>@ConfiguredCount RETURN NULL;

    SELECT @Parts=
    (
        SELECT
            N'|' + CONVERT(nvarchar(20),field.FieldConfigId) + N'=' +
            REPLACE(REPLACE(
                CASE WHEN ISNULL(field.IsProcessColumn,0)=1 OR field.DataType='Process'
                     THEN CONVERT(nvarchar(30),@ProcessID)
                     ELSE imported.FieldValue END,
                N'\',N'\\'),N'|',N'\|')
        FROM dbo.WBT_ProjectTrackingFieldConfig field
        OUTER APPLY
        (
            SELECT TOP(1) LTRIM(RTRIM(CONVERT(nvarchar(2000),value.FieldValue))) FieldValue
            FROM dbo.OLTracking_ImportItemValue value
            WHERE value.ItemID=@ItemID AND value.FieldConfigId=field.FieldConfigId
        ) imported
        WHERE field.ProjectID=@ProjectID
          AND field.IsUniqueField=1
          AND field.IsDeleted=0
          AND ISNULL(field.IsSystemGenerated,0)=0
          AND ISNULL(field.IsBillingField,0)=0
        ORDER BY field.DisplayOrder,field.FieldConfigId
        FOR XML PATH(''),TYPE
    ).value('.','nvarchar(max)');

    /* Reserve suffix space so ItemID can never be truncated from the identity. */
    SET @Result=LEFT(CONVERT(nvarchar(20),@ProjectID)+ISNULL(@Parts,N''),1960)
        +N'|ITEMID='+CONVERT(nvarchar(30),@ItemID);
    RETURN @Result;
END;
GO

/* Rebuild every active assignment hash using the global loan-specific identity. */
UPDATE assignment
SET assignment.UniqueCombination=identityValue.UniqueCombination,
    assignment.UniqueCombinationHash=HASHBYTES(
        'SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination)),
    assignment.UpdatedDate=GETDATE()
FROM dbo.OLTracking_Assignment assignment
CROSS APPLY
(
    SELECT dbo.OLTracking_BuildUniqueCombination(
        assignment.ProjectID,assignment.ItemID,assignment.ProcessID) UniqueCombination
) identityValue
WHERE assignment.IsCurrent=1
  AND identityValue.UniqueCombination IS NOT NULL
  AND NOT EXISTS
      (
          SELECT 1 FROM dbo.OLTracking_LoanHold loanHold
          WHERE loanHold.ItemID=assignment.ItemID AND loanHold.ResumedDate IS NULL
      );
GO

/* Remove the obsolete global loan/process index if an older deployment retained it.
   Item/process current uniqueness is already enforced by UX_OLTracking_Assignment_Current. */
IF EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_Assignment')
      AND name='UX_OLTracking_Assignment_LoanProcess'
)
    DROP INDEX UX_OLTracking_Assignment_LoanProcess ON dbo.OLTracking_Assignment;
GO
