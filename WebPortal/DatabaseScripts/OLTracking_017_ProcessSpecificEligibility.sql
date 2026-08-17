/* Process-specific loan eligibility for parallel and merged process branches.
   Safe to rerun. Deploy after OLTracking_015. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.OLTracking_ProcessDependency','U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ProcessDependency
    (
        DependencyID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ProcessDependency PRIMARY KEY,
        ProjectID int NOT NULL,
        ProcessID int NOT NULL,
        PredecessorProcessID int NOT NULL,
        IsActive bit NOT NULL CONSTRAINT DF_OLTracking_ProcessDependency_Active DEFAULT(1),
        AddedBy int NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ProcessDependency_Added DEFAULT(GETDATE()),
        UpdatedBy int NULL,
        UpdatedDate datetime NULL,
        CONSTRAINT UQ_OLTracking_ProcessDependency UNIQUE(ProjectID,ProcessID,PredecessorProcessID),
        CONSTRAINT CK_OLTracking_ProcessDependency_Self CHECK(ProcessID<>PredecessorProcessID)
    );
END;
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_ProcessDependency')
      AND name='IX_OLTracking_ProcessDependency_Predecessor'
)
    CREATE INDEX IX_OLTracking_ProcessDependency_Predecessor
        ON dbo.OLTracking_ProcessDependency(ProjectID,PredecessorProcessID,IsActive)
        INCLUDE(ProcessID);
GO

CREATE OR ALTER FUNCTION dbo.OLTracking_ProcessDependencyEligibility
(
    @ProjectID int,
    @ProcessID int,
    @ItemID bigint
)
RETURNS TABLE
AS RETURN
(
    SELECT
        CAST(CASE WHEN EXISTS
        (
            SELECT 1 FROM dbo.OLTracking_ProcessDependency dependency
            WHERE dependency.ProjectID=@ProjectID AND dependency.ProcessID=@ProcessID AND dependency.IsActive=1
        ) THEN 1 ELSE 0 END AS bit) HasConfiguredDependencies,
        CAST(CASE WHEN NOT EXISTS
        (
            SELECT 1
            FROM dbo.OLTracking_ProcessDependency dependency
            WHERE dependency.ProjectID=@ProjectID AND dependency.ProcessID=@ProcessID AND dependency.IsActive=1
              AND NOT EXISTS
              (
                  SELECT 1 FROM dbo.OLTracking_Assignment completed
                  WHERE completed.ItemID=@ItemID
                    AND completed.ProcessID=dependency.PredecessorProcessID
                    AND completed.AssignmentStatus='Completed'
              )
        ) THEN 1 ELSE 0 END AS bit) DependenciesSatisfied
);
GO

IF OBJECT_ID('dbo.OLTracking_BlockIneligibleAssignment','TR') IS NOT NULL
    DROP TRIGGER dbo.OLTracking_BlockIneligibleAssignment;
GO

CREATE TRIGGER dbo.OLTracking_BlockIneligibleAssignment
ON dbo.OLTracking_Assignment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS
    (
        SELECT 1
        FROM inserted assignment
        CROSS APPLY dbo.OLTracking_ProcessDependencyEligibility(assignment.ProjectID,assignment.ProcessID,assignment.ItemID) eligibility
        WHERE assignment.AssignmentStatus IN('Pending','In Process')
          AND eligibility.HasConfiguredDependencies=1
          AND eligibility.DependenciesSatisfied=0
    )
        THROW 50143,'All configured Eligible After Process(es) must be completed before this loan can be allocated.',1;
END;
GO

/* Allocation must use the same dependency-first rule as the availability query.
   Otherwise a loan can be displayed as eligible and then rejected by the legacy
   previous-sequence check. */
CREATE OR ALTER PROCEDURE dbo.OLTracking_AllocateLoan
    @ProjectID int,
    @ProcessID int,
    @LoanNumber nvarchar(150),
    @DealNumber nvarchar(150),
    @UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SET @LoanNumber=LTRIM(RTRIM(@LoanNumber));
        DECLARE @LockResult int;
        EXEC @LockResult=sys.sp_getapplock @Resource=N'OLTracking_Allocate_Global',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
        IF @LockResult<0 THROW 50112,'Unable to verify whether this loan is already allocated. Please try again.',1;

        IF (SELECT COUNT(1) FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
            WHERE UserID=@UserID AND IsCurrent=1 AND AssignmentStatus IN('Pending','In Process'))>=2
            THROW 50110,'You already have two pending/in-process loans. Complete or hold one before allocating another.',1;

        IF EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
                  WHERE LoanNumber=@LoanNumber AND ProcessID=@ProcessID AND IsCurrent=1)
            THROW 50112,'This loan and process combination is already allocated to another user.',1;

        DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE ProcessID=@ProcessID);
        IF @StageNo IS NULL THROW 50111,'Selected process is not configured in the tracking flow.',1;

        DECLARE @ItemID bigint=(SELECT TOP(1) ItemID FROM dbo.OLTracking_Item WITH(UPDLOCK,HOLDLOCK)
                                WHERE ProjectID=@ProjectID AND ItemNumber=@LoanNumber AND IsDeleted=0
                                ORDER BY ItemID);
        IF @ItemID IS NULL
        BEGIN
            INSERT dbo.OLTracking_Item(ProjectID,ItemNumber,DealNumber,CurrentProcessID,ItemStatus,AddedBy)
            VALUES(@ProjectID,@LoanNumber,NULLIF(@DealNumber,''),@ProcessID,'Pending',@UserID);
            SET @ItemID=SCOPE_IDENTITY();
        END
        ELSE
            UPDATE dbo.OLTracking_Item SET DealNumber=NULLIF(@DealNumber,''),CurrentProcessID=@ProcessID,
                UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE ItemID=@ItemID;

        IF EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment
                  WHERE ItemID=@ItemID AND ProcessID=@ProcessID
                    AND (IsCurrent=1 OR AssignmentStatus IN('Completed','Skipped')))
            THROW 50112,'This loan is already allocated or completed for the selected process.',1;

        DECLARE @HasDependencies bit,@DependenciesSatisfied bit;
        SELECT @HasDependencies=HasConfiguredDependencies,@DependenciesSatisfied=DependenciesSatisfied
        FROM dbo.OLTracking_ProcessDependencyEligibility(@ProjectID,@ProcessID,@ItemID);
        IF @HasDependencies=1 AND @DependenciesSatisfied=0
            THROW 50143,'All configured Eligible After Process(es) must be completed before this loan can be allocated.',1;

        DECLARE @PreviousStage int;
        SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE StageNo<@StageNo;
        IF @HasDependencies=0 AND @PreviousStage IS NOT NULL
           AND EXISTS(SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE StageNo=@PreviousStage AND IsMandatory=1)
           AND EXISTS
           (
               SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) flow
               WHERE flow.StageNo=@PreviousStage AND flow.IsMandatory=1
                 AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment previous
                                WHERE previous.ItemID=@ItemID AND previous.ProcessID=flow.ProcessID
                                  AND previous.AssignmentStatus IN('Completed','Skipped'))
           )
            THROW 50113,'The previous mandatory sequence is not completed for this loan.',1;

        INSERT dbo.OLTracking_Assignment(ItemID,ProjectID,ProcessID,UserID,LoanNumber,AssignmentStatus,AddedBy)
        VALUES(@ItemID,@ProjectID,@ProcessID,@UserID,@LoanNumber,'Pending',@UserID);
        DECLARE @AssignmentID bigint=SCOPE_IDENTITY();
        UPDATE dbo.OLTracking_Item SET ItemStatus='Allocated',UpdatedBy=@UserID,UpdatedDate=GETDATE() WHERE ItemID=@ItemID;
        COMMIT TRANSACTION;
        SELECT @AssignmentID AssignmentID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_ManagerAllocate
    @ProjectID int,
    @DealNumber nvarchar(150),
    @ProcessID int,
    @TargetUserID int,
    @LoanXml xml,
    @ManagerID int
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
        IF @Requested<1 OR @Requested>2 THROW 50130,'Select one or two orders.',1;
        IF NOT EXISTS(SELECT 1 FROM dbo.UserProjectConfiguration WHERE ProjectID=@ProjectID AND UserID=@TargetUserID)
            THROW 50131,'Selected user is not configured for this project.',1;
        IF (SELECT COUNT(1) FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
            WHERE UserID=@TargetUserID AND IsCurrent=1 AND AssignmentStatus IN('Pending','In Process'))+@Requested>2
            THROW 50110,'Selected user can have a maximum of two pending/in-process orders.',1;

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
              ON active.ProjectID=@ProjectID AND active.UniqueCombinationHash=selected.UniqueHash AND active.IsCurrent=1
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

CREATE OR ALTER PROCEDURE dbo.OLTracking_GetEligibleLoans
    @ProjectID int,
    @DealNumber nvarchar(150),
    @ProcessID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE ProcessID=@ProcessID),
            @PreviousStage int;
    SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber)
    WHERE StageNo<@StageNo;

    SELECT TOP(100) item.ItemID,item.ItemNumber LoanNumber,ISNULL(item.DealNumber,'') DealNumber
    FROM dbo.OLTracking_Item item
    CROSS APPLY
    (
        SELECT dbo.OLTracking_BuildUniqueCombination(@ProjectID,item.ItemID,@ProcessID) UniqueCombination
    ) identityValue
    CROSS APPLY dbo.OLTracking_ProcessDependencyEligibility(@ProjectID,@ProcessID,item.ItemID) dependencyEligibility
    WHERE @StageNo IS NOT NULL
      AND item.ProjectID=@ProjectID AND item.IsDeleted=0 AND item.RecordSource='Import'
      AND LTRIM(RTRIM(ISNULL(item.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
      AND identityValue.UniqueCombination IS NOT NULL
      AND NOT EXISTS
      (
          SELECT 1 FROM dbo.OLTracking_Assignment active
          WHERE active.ProjectID=@ProjectID AND active.IsCurrent=1
            AND active.UniqueCombinationHash=HASHBYTES('SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination))
      )
      AND NOT EXISTS
      (
          SELECT 1 FROM dbo.OLTracking_Assignment previous
          WHERE previous.ItemID=item.ItemID AND previous.ProcessID=@ProcessID
            AND previous.AssignmentStatus IN('Completed','Skipped')
      )
      AND
      (
          (dependencyEligibility.HasConfiguredDependencies=1 AND dependencyEligibility.DependenciesSatisfied=1)
          OR
          (dependencyEligibility.HasConfiguredDependencies=0 AND
           (
               @PreviousStage IS NULL
               OR NOT EXISTS
                  (
                      SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) flow
                      WHERE flow.StageNo=@PreviousStage AND flow.IsMandatory=1
                  )
               OR EXISTS
                  (
                      SELECT 1 FROM dbo.OLTracking_Assignment completed
                      INNER JOIN dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) flow
                        ON flow.ProcessID=completed.ProcessID AND flow.IsMandatory=1 AND flow.StageNo=@PreviousStage
                      WHERE completed.ItemID=item.ItemID AND completed.AssignmentStatus IN('Completed','Skipped')
                  )
           ))
      )
    ORDER BY item.ItemID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_IsLoanEligible
    @ProjectID int,
    @ProcessID int,
    @LoanNumber nvarchar(150)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ItemID bigint,@DealNumber nvarchar(150),@StageNo int,@PreviousStage int;
    SELECT TOP(1) @ItemID=ItemID,@DealNumber=ISNULL(DealNumber,'')
    FROM dbo.OLTracking_Item
    WHERE ProjectID=@ProjectID AND ItemNumber=@LoanNumber AND IsDeleted=0
    ORDER BY ItemID;
    SELECT @StageNo=StageNo FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE ProcessID=@ProcessID;

    IF @StageNo IS NULL
    BEGIN SELECT CAST(0 AS bit) Eligible,'Process is not configured in tracking flow.' Reason; RETURN; END;
    IF @ItemID IS NOT NULL AND EXISTS
    (
        SELECT 1 FROM dbo.OLTracking_Assignment
        WHERE ItemID=@ItemID AND ProcessID=@ProcessID
          AND (IsCurrent=1 OR AssignmentStatus IN('Completed','Skipped'))
    )
    BEGIN SELECT CAST(0 AS bit) Eligible,'Loan is already allocated or completed for this process.' Reason; RETURN; END;

    DECLARE @HasDependencies bit,@DependenciesSatisfied bit;
    SELECT @HasDependencies=HasConfiguredDependencies,@DependenciesSatisfied=DependenciesSatisfied
    FROM dbo.OLTracking_ProcessDependencyEligibility(@ProjectID,@ProcessID,@ItemID);
    IF @HasDependencies=1
    BEGIN
        SELECT @DependenciesSatisfied Eligible,
               CASE WHEN @DependenciesSatisfied=1 THEN '' ELSE 'All configured Eligible After Process(es) must be completed first.' END Reason;
        RETURN;
    END;

    SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE StageNo<@StageNo;
    IF @PreviousStage IS NULL OR NOT EXISTS
    (
        SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber)
        WHERE StageNo=@PreviousStage AND IsMandatory=1
    )
    BEGIN SELECT CAST(1 AS bit) Eligible,'' Reason; RETURN; END;
    IF @ItemID IS NULL OR NOT EXISTS
    (
        SELECT 1 FROM dbo.OLTracking_Assignment completed
        INNER JOIN dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) flow
          ON flow.ProcessID=completed.ProcessID AND flow.StageNo=@PreviousStage AND flow.IsMandatory=1
        WHERE completed.ItemID=@ItemID AND completed.AssignmentStatus IN('Completed','Skipped')
    )
    BEGIN SELECT CAST(0 AS bit) Eligible,'A process in the previous sequence must be completed first.' Reason; RETURN; END;
    SELECT CAST(1 AS bit) Eligible,'' Reason;
END;
GO

CREATE OR ALTER PROCEDURE dbo.OLTracking_RemoveProcessFlow
    @ProjectID int,
    @ProcessID int,
    @UserID int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @Affected int;
    BEGIN TRANSACTION;
    UPDATE dbo.OLTracking_ProcessFlow
       SET IsActive=0,UpdatedBy=@UserID,UpdatedDate=GETDATE()
     WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1;
    SET @Affected=@@ROWCOUNT;
    DELETE dbo.OLTracking_ProcessDependency
     WHERE ProjectID=@ProjectID AND (ProcessID=@ProcessID OR PredecessorProcessID=@ProcessID);
    COMMIT;
    SELECT @Affected AffectedRows;
END;
GO
