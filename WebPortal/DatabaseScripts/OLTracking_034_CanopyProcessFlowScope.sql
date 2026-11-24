/* Restrict Pre/Post Close resolution to Canopy projects only.
   Prevents unrelated projects (including 561) from scanning configured import values. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

ALTER FUNCTION dbo.OLTracking_EffectiveProcessFlow(@ProjectID int,@DealNumber nvarchar(150))
RETURNS TABLE
AS RETURN
(
 WITH Context AS
 (
  SELECT CASE WHEN COUNT(DISTINCT matched.ConfigurationProcess)=1 THEN MAX(matched.ConfigurationProcess) END ConfigurationProcess
  FROM dbo.Project canopy
  JOIN dbo.OLTracking_Item item ON item.ProjectID=canopy.ProjectID
  CROSS APPLY
  (
    SELECT CASE
      WHEN REPLACE(REPLACE(REPLACE(LOWER(LTRIM(RTRIM(field.FieldName))),' ',''),'-',''),'_','')='process'
        AND LTRIM(RTRIM(value.FieldValue)) IN(N'Pre Close Review',N'Post Close Review') THEN LTRIM(RTRIM(value.FieldValue))
      WHEN field.IsProcessColumn=1 AND field.DataType='Process'
        AND LTRIM(RTRIM(field.FieldName)) IN(N'Pre Close Review',N'Post Close Review')
        AND NULLIF(LTRIM(RTRIM(value.FieldValue)),N'') IS NOT NULL THEN LTRIM(RTRIM(field.FieldName)) END ConfigurationProcess
    FROM dbo.OLTracking_ImportItemValue value
    JOIN dbo.WBT_ProjectTrackingFieldConfig field ON field.FieldConfigId=value.FieldConfigId AND field.IsDeleted=0
    WHERE value.ItemID=item.ItemID
  ) matched
  WHERE canopy.ProjectID=@ProjectID AND canopy.SubdomainID=99
    AND item.DealNumber=@DealNumber AND item.IsDeleted=0 AND matched.ConfigurationProcess IS NOT NULL
 ), ContextRows AS
 (
  SELECT flow.* FROM dbo.OLTracking_ProcessDealFlow flow CROSS JOIN Context
  WHERE flow.ProjectID=@ProjectID AND flow.DealNumber=N''
    AND flow.ConfigurationProcess=Context.ConfigurationProcess AND flow.IsActive=1
 )
 SELECT source.ProcessID,source.ProcessName,source.StageNo,source.IsMandatory,
        CAST(CASE WHEN source.IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
        source.FeedbackRequiredOnComplete,source.IsFinalProcess,source.ProductivityType,
        source.ExpectedCompletionMinutes,source.MinCompletionMinutes,source.MaxCompletionMinutes
 FROM ContextRows source WHERE source.IsOutOfScope=0
 UNION ALL
 SELECT deal.ProcessID,deal.ProcessName,deal.StageNo,deal.IsMandatory,
        CAST(CASE WHEN deal.IsMandatory=1 THEN 0 ELSE 1 END AS bit),
        deal.FeedbackRequiredOnComplete,deal.IsFinalProcess,deal.ProductivityType,
        deal.ExpectedCompletionMinutes,deal.MinCompletionMinutes,deal.MaxCompletionMinutes
 FROM dbo.OLTracking_DealProcessFlow deal
 WHERE deal.ProjectID=@ProjectID AND deal.DealNumber=@DealNumber AND deal.IsActive=1 AND deal.IsOutOfScope=0
   AND NOT EXISTS(SELECT 1 FROM ContextRows contextFlow WHERE contextFlow.ProcessID=deal.ProcessID)
 UNION ALL
 SELECT project.ProcessID,project.ProcessName,project.StageNo,project.IsMandatory,
        CAST(CASE WHEN project.IsMandatory=1 THEN 0 ELSE 1 END AS bit),
        project.FeedbackRequiredOnComplete,project.IsFinalProcess,project.ProductivityType,
        project.ExpectedCompletionMinutes,project.MinCompletionMinutes,project.MaxCompletionMinutes
 FROM dbo.OLTracking_ProcessFlow project
 WHERE project.ProjectID=@ProjectID AND project.IsActive=1
   AND NOT EXISTS(SELECT 1 FROM ContextRows contextFlow WHERE contextFlow.ProcessID=project.ProcessID)
   AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_DealProcessFlow deal
                  WHERE deal.ProjectID=@ProjectID AND deal.DealNumber=@DealNumber AND deal.IsActive=1)
);
GO
