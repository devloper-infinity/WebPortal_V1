/* Bulk Allocation can supply a process-specific capacity. Existing callers retain the default limit of two. */
CREATE OR ALTER PROCEDURE dbo.OLTracking_ManagerAllocate
    @ProjectID int,
    @DealNumber nvarchar(150),
    @ProcessID int,
    @TargetUserID int,
    @LoanXml xml,
    @ManagerID int,
    @CapacityLimit int = 2
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @LockResult int;
        EXEC @LockResult=sys.sp_getapplock
            @Resource=N'OLTracking_Allocate_Global',@LockMode='Exclusive',
            @LockOwner='Transaction',@LockTimeout=10000;
        IF @LockResult<0 THROW 50112,'Unable to verify the configured unique loan combination. Please try again.',1;

        IF NOT EXISTS
        (
            SELECT 1 FROM dbo.WBT_ProjectTrackingFieldConfig
            WHERE ProjectID=@ProjectID AND IsUniqueField=1 AND IsDeleted=0
              AND ISNULL(IsSystemGenerated,0)=0 AND ISNULL(IsBillingField,0)=0
        )
            THROW 50134,'Configure at least one Unique Field for this project before allocation.',1;

        DECLARE @Loans table
        (
            LoanNumber nvarchar(150) NOT NULL PRIMARY KEY,
            ItemID bigint NULL,
            UniqueCombination nvarchar(2000) NULL,
            UniqueHash binary(32) NULL
        );
        INSERT @Loans(LoanNumber)
        SELECT DISTINCT LTRIM(RTRIM(node.value('(text())[1]','nvarchar(150)')))
        FROM @LoanXml.nodes('/loans/loan') source(node)
        WHERE NULLIF(LTRIM(RTRIM(node.value('(text())[1]','nvarchar(150)'))),'') IS NOT NULL;

        DECLARE @Requested int=(SELECT COUNT(1) FROM @Loans);
        IF @Requested<1 OR (@CapacityLimit>0 AND @Requested>@CapacityLimit)
            THROW 50130,'The selected order count exceeds the allocation limit.',1;
        IF NOT EXISTS(SELECT 1 FROM dbo.UserProjectConfiguration WHERE ProjectID=@ProjectID AND UserID=@TargetUserID)
            THROW 50131,'Selected user is not configured for this project.',1;
        IF @CapacityLimit>0 AND
           (SELECT COUNT(1) FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
            WHERE UserID=@TargetUserID AND IsCurrent=1 AND AssignmentStatus IN('Pending','In Process'))+@Requested>@CapacityLimit
        BEGIN
            DECLARE @CapacityMessage nvarchar(2048)=N'Selected user can have a maximum of '
                +CONVERT(nvarchar(10),@CapacityLimit)+N' pending/in-process orders.';
            THROW 50110,@CapacityMessage,1;
        END;

        UPDATE selected
        SET ItemID=item.ItemID,
            UniqueCombination=identityValue.UniqueCombination,
            UniqueHash=HASHBYTES('SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination))
        FROM @Loans selected
        INNER JOIN dbo.OLTracking_Item item
          ON item.ProjectID=@ProjectID AND item.ItemNumber=selected.LoanNumber
         AND item.IsDeleted=0 AND item.RecordSource='Import'
        CROSS APPLY
        (
            SELECT dbo.OLTracking_BuildUniqueCombination(@ProjectID,item.ItemID,@ProcessID) UniqueCombination
        ) identityValue
        WHERE LTRIM(RTRIM(ISNULL(item.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')));

        IF EXISTS(SELECT 1 FROM @Loans WHERE ItemID IS NULL)
            THROW 50128,'One or more selected orders are no longer eligible.',1;
        IF EXISTS(SELECT 1 FROM @Loans WHERE UniqueCombination IS NULL)
            THROW 50136,'One or more configured Unique Field values are missing for the selected loan.',1;
        IF EXISTS
        (
            SELECT 1 FROM @Loans selected
            INNER JOIN dbo.OLTracking_Assignment active WITH(UPDLOCK,HOLDLOCK)
              ON active.ProjectID=@ProjectID AND active.ProcessID=@ProcessID
             AND active.UniqueCombinationHash=selected.UniqueHash AND active.IsCurrent=1
        )
            THROW 50112,'The configured unique loan combination is already allocated to another user.',1;

        DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE ProcessID=@ProcessID),
                @PreviousStage int;
        IF @StageNo IS NULL THROW 50111,'Selected process is not configured.',1;
        SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE StageNo<@StageNo;

        IF EXISTS
        (
            SELECT 1 FROM @Loans selected
            CROSS APPLY dbo.OLTracking_ProcessDependencyEligibility(@ProjectID,@ProcessID,selected.ItemID) eligibility
            WHERE eligibility.HasConfiguredDependencies=1 AND eligibility.DependenciesSatisfied=0
        )
            THROW 50143,'All configured Eligible After Process(es) must be completed before this loan can be allocated.',1;

        IF EXISTS
        (
            SELECT 1 FROM @Loans selected
            CROSS APPLY dbo.OLTracking_ProcessDependencyEligibility(@ProjectID,@ProcessID,selected.ItemID) eligibility
            WHERE EXISTS
                  (
                      SELECT 1 FROM dbo.OLTracking_Assignment assignment
                      WHERE assignment.ItemID=selected.ItemID AND assignment.ProcessID=@ProcessID
                        AND assignment.AssignmentStatus IN('Completed','Skipped')
                  )
               OR
                  (
                      eligibility.HasConfiguredDependencies=0
                      AND @PreviousStage IS NOT NULL
                      AND EXISTS
                          (
                              SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) flow
                              WHERE flow.StageNo=@PreviousStage AND flow.IsMandatory=1
                          )
                      AND NOT EXISTS
                          (
                              SELECT 1 FROM dbo.OLTracking_Assignment completed
                              INNER JOIN dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) flow
                                ON flow.ProcessID=completed.ProcessID AND flow.IsMandatory=1 AND flow.StageNo=@PreviousStage
                              WHERE completed.ItemID=selected.ItemID AND completed.AssignmentStatus IN('Completed','Skipped')
                          )
                  )
        )
            THROW 50128,'One or more selected orders are no longer eligible.',1;

        INSERT dbo.OLTracking_Assignment
        (
            ItemID,ProjectID,ProcessID,UserID,LoanNumber,UniqueCombination,
            UniqueCombinationHash,AssignmentStatus,AddedBy
        )
        SELECT ItemID,@ProjectID,@ProcessID,@TargetUserID,LoanNumber,UniqueCombination,
               UniqueHash,'Pending',@ManagerID
        FROM @Loans;

        UPDATE item
        SET ItemStatus='Allocated',CurrentProcessID=@ProcessID,
            UpdatedBy=@ManagerID,UpdatedDate=GETDATE()
        FROM dbo.OLTracking_Item item
        INNER JOIN @Loans selected ON selected.ItemID=item.ItemID;

        COMMIT TRANSACTION;
        SELECT @Requested AllocatedCount;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
        IF ERROR_NUMBER() IN(2601,2627)
            THROW 50112,'The configured unique loan combination is already allocated to another user.',1;
        THROW;
    END CATCH
END;
GO
