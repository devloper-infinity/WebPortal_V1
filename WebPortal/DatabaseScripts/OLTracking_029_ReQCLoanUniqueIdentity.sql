/* ReQC bulk allocation is loan-based. Preserve the configured project identity,
   but append ItemID for these three processes so loans in the same deal do not collide. */
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
            @Result nvarchar(2000),
            @DealNumber nvarchar(150),
            @ProcessName nvarchar(200),
            @NormalizedProcess nvarchar(200);

    SELECT @DealNumber=item.DealNumber
    FROM dbo.OLTracking_Item item
    WHERE item.ItemID=@ItemID AND item.ProjectID=@ProjectID;

    SELECT TOP (1) @ProcessName=flow.ProcessName
    FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) flow
    WHERE flow.ProcessID=@ProcessID
    ORDER BY flow.StageNo,flow.ProcessID;

    SET @NormalizedProcess=UPPER(REPLACE(REPLACE(REPLACE(
        LTRIM(RTRIM(ISNULL(@ProcessName,N''))),N' ',N''),N'-',N''),N'_',N''));

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

    SET @Result=CONVERT(nvarchar(20),@ProjectID)+ISNULL(@Parts,N'');

    IF @NormalizedProcess IN (N'COLLECTIONCOMMENTSREQC',N'PHREQC',N'DATAFIELDSREQC')
        SET @Result=@Result+N'|ITEMID='+CONVERT(nvarchar(30),@ItemID);

    RETURN @Result;
END;
GO

/* Bring existing active ReQC assignments onto the same loan-specific identity. */
UPDATE assignment
SET assignment.UniqueCombination=identityValue.UniqueCombination,
    assignment.UniqueCombinationHash=HASHBYTES('SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination)),
    assignment.UpdatedDate=GETDATE()
FROM dbo.OLTracking_Assignment assignment
JOIN dbo.OLTracking_Item item ON item.ItemID=assignment.ItemID
CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(assignment.ProjectID,item.DealNumber) flow
CROSS APPLY
(
    SELECT dbo.OLTracking_BuildUniqueCombination(
        assignment.ProjectID,assignment.ItemID,assignment.ProcessID) UniqueCombination
) identityValue
WHERE assignment.IsCurrent=1
  AND flow.ProcessID=assignment.ProcessID
  AND UPPER(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(flow.ProcessName)),' ',''),'-',''),'_',''))
      IN ('COLLECTIONCOMMENTSREQC','PHREQC','DATAFIELDSREQC');
GO
