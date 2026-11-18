/* The interactive allocation grid remains capped at 100 rows. Bulk validation
   can request the complete eligible set for its pasted loan numbers. */
ALTER PROCEDURE dbo.OLTracking_GetEligibleLoans
    @ProjectID int,
    @DealNumber nvarchar(150),
    @ProcessID int,
    @IncludeAll bit = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE ProcessID=@ProcessID),
            @PreviousStage int;
    SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE StageNo<@StageNo;

    SELECT TOP (CASE WHEN @IncludeAll=1 THEN 2147483647 ELSE 100 END)
           item.ItemID,item.ItemNumber LoanNumber,ISNULL(item.DealNumber,'') DealNumber
    FROM dbo.OLTracking_Item item
    CROSS APPLY(SELECT dbo.OLTracking_BuildUniqueCombination(@ProjectID,item.ItemID,@ProcessID) UniqueCombination) identityValue
    CROSS APPLY dbo.OLTracking_ProcessDependencyEligibility(@ProjectID,@ProcessID,item.ItemID) dependencyEligibility
    WHERE @StageNo IS NOT NULL AND item.ProjectID=@ProjectID AND item.IsDeleted=0 AND item.RecordSource='Import'
      AND LTRIM(RTRIM(ISNULL(item.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
      AND identityValue.UniqueCombination IS NOT NULL
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_LoanHold loanHold WHERE loanHold.ItemID=item.ItemID AND loanHold.ResumedDate IS NULL)
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment active WHERE active.ProjectID=@ProjectID AND active.IsCurrent=1
                     AND active.ProcessID=@ProcessID
                     AND active.UniqueCombinationHash=HASHBYTES('SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination)))
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment previous WHERE previous.ItemID=item.ItemID AND previous.ProcessID=@ProcessID
                     AND previous.AssignmentStatus IN('Completed','Skipped'))
      AND
      (
          (dependencyEligibility.HasConfiguredDependencies=1 AND dependencyEligibility.DependenciesSatisfied=1)
          OR (dependencyEligibility.HasConfiguredDependencies=0 AND
             (@PreviousStage IS NULL
              OR NOT EXISTS(SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) flow WHERE flow.StageNo=@PreviousStage AND flow.IsMandatory=1)
              OR EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment completed
                        INNER JOIN dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) flow
                          ON flow.ProcessID=completed.ProcessID AND flow.IsMandatory=1 AND flow.StageNo=@PreviousStage
                        WHERE completed.ItemID=item.ItemID AND completed.AssignmentStatus IN('Completed','Skipped'))))
      )
    ORDER BY item.ItemID;
END;
GO
