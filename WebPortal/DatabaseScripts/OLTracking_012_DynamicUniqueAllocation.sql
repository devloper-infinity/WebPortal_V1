/*
    Dynamic project-specific allocation identity and transactional reallocation.
    Run after OLTracking_011. Safe to run repeatedly.
*/
IF COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig','IsUniqueField') IS NULL
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig
        ADD IsUniqueField bit NOT NULL
            CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsUniqueField DEFAULT(0) WITH VALUES;
GO

IF COL_LENGTH('dbo.OLTracking_Assignment','LoanNumber') IS NULL
    ALTER TABLE dbo.OLTracking_Assignment ADD LoanNumber nvarchar(150) NULL;
IF COL_LENGTH('dbo.OLTracking_Assignment','UniqueCombination') IS NULL
    ALTER TABLE dbo.OLTracking_Assignment ADD UniqueCombination nvarchar(2000) NULL;
IF COL_LENGTH('dbo.OLTracking_Assignment','UniqueCombinationHash') IS NULL
    ALTER TABLE dbo.OLTracking_Assignment ADD UniqueCombinationHash binary(32) NULL;
GO

UPDATE assignment
SET LoanNumber=LTRIM(RTRIM(item.ItemNumber))
FROM dbo.OLTracking_Assignment assignment
INNER JOIN dbo.OLTracking_Item item ON item.ItemID=assignment.ItemID
WHERE assignment.LoanNumber IS NULL;
GO

IF OBJECT_ID('dbo.OLTracking_BuildUniqueCombination','FN') IS NULL
    EXEC('CREATE FUNCTION dbo.OLTracking_BuildUniqueCombination(@ProjectID int,@ItemID bigint,@ProcessID int)
          RETURNS nvarchar(2000) AS BEGIN RETURN NULL END');
GO

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

    SET @Result=CONVERT(nvarchar(20),@ProjectID)+ISNULL(@Parts,N'');
    RETURN @Result;
END;
GO

/* The original assignment remains as the immutable activity owner; IsCurrent=0
   removes it from the live queue after this snapshot is written. */
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','NewAssignmentID') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD NewAssignmentID bigint NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','ProjectID') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD ProjectID int NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','ItemID') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD ItemID bigint NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','ProcessID') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD ProcessID int NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','LoanNumber') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD LoanNumber nvarchar(150) NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','UniqueCombination') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD UniqueCombination nvarchar(2000) NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','UniqueCombinationHash') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD UniqueCombinationHash binary(32) NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','AssignedDate') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD AssignedDate datetime NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','StartedDate') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD StartedDate datetime NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','CompletedDate') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD CompletedDate datetime NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','HoldDate') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD HoldDate datetime NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','HoldTATSeconds') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD HoldTATSeconds bigint NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','TotalTATSeconds') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD TotalTATSeconds bigint NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','PreviousRemark') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD PreviousRemark nvarchar(1000) NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','OriginalAddedBy') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD OriginalAddedBy int NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','OriginalAddedDate') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD OriginalAddedDate datetime NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','OriginalUpdatedBy') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD OriginalUpdatedBy int NULL;
IF COL_LENGTH('dbo.OLTracking_ReallocationHistory','OriginalUpdatedDate') IS NULL
    ALTER TABLE dbo.OLTracking_ReallocationHistory ADD OriginalUpdatedDate datetime NULL;
GO

IF OBJECT_ID('dbo.OLTracking_ReallocateOrders','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_ReallocateOrders AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_ReallocateOrders
    @ProjectID int,
    @FromUserID int,
    @ToUserID int,
    @AssignmentXml xml,
    @Remark nvarchar(1000),
    @ManagerID int,
    @ConfirmInProcess bit=0
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @LockResult int;
        EXEC @LockResult=sys.sp_getapplock
            @Resource=N'OLTracking_Allocate_Global',@LockMode='Exclusive',
            @LockOwner='Transaction',@LockTimeout=10000;
        IF @LockResult<0
            THROW 50112,'Unable to verify the configured unique loan combination. Please try again.',1;

        IF @FromUserID=@ToUserID
            THROW 50132,'Current user and new user must be different.',1;
        IF NULLIF(LTRIM(RTRIM(@Remark)),'') IS NULL
            THROW 50133,'Reallocation remark is required.',1;
        IF NOT EXISTS
        (
            SELECT 1 FROM dbo.UserProjectConfiguration
            WHERE ProjectID=@ProjectID AND UserID=@ToUserID
        )
            THROW 50131,'Selected new user is not configured for this project.',1;
        IF NOT EXISTS
        (
            SELECT 1 FROM dbo.WBT_ProjectTrackingFieldConfig
            WHERE ProjectID=@ProjectID AND IsUniqueField=1 AND IsDeleted=0
              AND ISNULL(IsSystemGenerated,0)=0 AND ISNULL(IsBillingField,0)=0
        )
            THROW 50134,'Configure at least one Unique Field for this project before reallocation.',1;

        DECLARE @Assignments table(AssignmentID bigint NOT NULL PRIMARY KEY);
        INSERT @Assignments(AssignmentID)
        SELECT DISTINCT node.value('(text())[1]','bigint')
        FROM @AssignmentXml.nodes('/assignments/assignment') source(node);

        DECLARE @Requested int=(SELECT COUNT(1) FROM @Assignments);
        IF @Requested<1 OR @Requested>2
            THROW 50130,'Select one or two orders.',1;
        IF
        (
            SELECT COUNT(1)
            FROM @Assignments selected
            INNER JOIN dbo.OLTracking_Assignment assignment WITH(UPDLOCK,HOLDLOCK)
              ON assignment.AssignmentID=selected.AssignmentID
            WHERE assignment.ProjectID=@ProjectID
              AND assignment.UserID=@FromUserID
              AND assignment.IsCurrent=1
              AND assignment.AssignmentStatus IN('Pending','In Process','Hold')
        )<>@Requested
            THROW 50128,'One or more selected orders are no longer available for reallocation.',1;

        IF @ConfirmInProcess=0 AND EXISTS
        (
            SELECT 1 FROM @Assignments selected
            INNER JOIN dbo.OLTracking_Assignment assignment
              ON assignment.AssignmentID=selected.AssignmentID
            WHERE assignment.AssignmentStatus='In Process'
        )
            THROW 50135,'Are you sure you want to reallocate this loan? This loan is currently In-Process.',1;

        IF
        (
            SELECT COUNT(1) FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
            WHERE UserID=@ToUserID AND IsCurrent=1
              AND AssignmentStatus IN('Pending','In Process')
        )+@Requested>2
            THROW 50110,'Selected new user can have a maximum of two pending/in-process orders.',1;

        UPDATE assignment
        SET UniqueCombination=identityValue.UniqueCombination,
            UniqueCombinationHash=HASHBYTES(
                'SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination))
        FROM dbo.OLTracking_Assignment assignment
        INNER JOIN @Assignments selected ON selected.AssignmentID=assignment.AssignmentID
        CROSS APPLY
        (
            SELECT dbo.OLTracking_BuildUniqueCombination(
                assignment.ProjectID,assignment.ItemID,assignment.ProcessID) UniqueCombination
        ) identityValue
        WHERE assignment.UniqueCombination IS NULL
           OR assignment.UniqueCombinationHash IS NULL;

        IF EXISTS
        (
            SELECT 1 FROM @Assignments selected
            INNER JOIN dbo.OLTracking_Assignment assignment
              ON assignment.AssignmentID=selected.AssignmentID
            WHERE assignment.UniqueCombination IS NULL
               OR assignment.UniqueCombinationHash IS NULL
        )
            THROW 50136,'One or more configured Unique Field values are missing for the selected loan.',1;

        DECLARE @AssignmentID bigint,
                @HistoryID bigint,
                @NewAssignmentID bigint,
                @ItemID bigint,
                @ProcessID int,
                @LoanNumber nvarchar(150),
                @UniqueCombination nvarchar(2000),
                @UniqueHash binary(32),
                @OldStatus varchar(20);

        DECLARE assignment_cursor CURSOR LOCAL FAST_FORWARD FOR
            SELECT assignment.AssignmentID,assignment.ItemID,assignment.ProcessID,
                   assignment.LoanNumber,assignment.UniqueCombination,
                   assignment.UniqueCombinationHash,assignment.AssignmentStatus
            FROM @Assignments selected
            INNER JOIN dbo.OLTracking_Assignment assignment
              ON assignment.AssignmentID=selected.AssignmentID
            ORDER BY assignment.AssignmentID;

        OPEN assignment_cursor;
        FETCH NEXT FROM assignment_cursor INTO
            @AssignmentID,@ItemID,@ProcessID,@LoanNumber,
            @UniqueCombination,@UniqueHash,@OldStatus;

        WHILE @@FETCH_STATUS=0
        BEGIN
            /* History is saved first. Related status/hold/feedback activity remains
               attached to this original assignment. */
            INSERT dbo.OLTracking_ReallocationHistory
            (
                AssignmentID,FromUserID,ToUserID,AssignmentStatus,Remark,
                ReallocatedBy,ProjectID,ItemID,ProcessID,LoanNumber,
                UniqueCombination,UniqueCombinationHash,AssignedDate,StartedDate,
                CompletedDate,HoldDate,HoldTATSeconds,TotalTATSeconds,
                PreviousRemark,OriginalAddedBy,OriginalAddedDate,
                OriginalUpdatedBy,OriginalUpdatedDate
            )
            SELECT
                AssignmentID,UserID,@ToUserID,AssignmentStatus,@Remark,
                @ManagerID,ProjectID,ItemID,ProcessID,LoanNumber,
                UniqueCombination,UniqueCombinationHash,AssignedDate,StartedDate,
                CompletedDate,HoldDate,HoldTATSeconds,TotalTATSeconds,
                LastRemark,AddedBy,AddedDate,UpdatedBy,UpdatedDate
            FROM dbo.OLTracking_Assignment
            WHERE AssignmentID=@AssignmentID;
            SET @HistoryID=SCOPE_IDENTITY();

            INSERT dbo.OLTracking_StatusHistory
                (AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
            VALUES
                (@AssignmentID,@OldStatus,@OldStatus,'Reallocated: '+@Remark,@ManagerID);

            /* Logical removal from the current queue happens only after history succeeds. */
            UPDATE dbo.OLTracking_Assignment
            SET IsCurrent=0,LastRemark='Reallocated: '+@Remark,
                UpdatedBy=@ManagerID,UpdatedDate=GETDATE()
            WHERE AssignmentID=@AssignmentID AND IsCurrent=1;

            INSERT dbo.OLTracking_Assignment
            (
                ItemID,ProjectID,ProcessID,UserID,LoanNumber,
                UniqueCombination,UniqueCombinationHash,
                AssignmentStatus,LastRemark,AddedBy
            )
            VALUES
            (
                @ItemID,@ProjectID,@ProcessID,@ToUserID,@LoanNumber,
                @UniqueCombination,@UniqueHash,
                'Pending','Reallocated: '+@Remark,@ManagerID
            );
            SET @NewAssignmentID=SCOPE_IDENTITY();

            UPDATE dbo.OLTracking_ReallocationHistory
            SET NewAssignmentID=@NewAssignmentID
            WHERE ReallocationID=@HistoryID;

            INSERT dbo.OLTracking_StatusHistory
                (AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
            VALUES
                (@NewAssignmentID,NULL,'Pending','Reallocated: '+@Remark,@ManagerID);

            UPDATE dbo.OLTracking_Item
            SET ItemStatus='Allocated',CurrentProcessID=@ProcessID,
                UpdatedBy=@ManagerID,UpdatedDate=GETDATE()
            WHERE ItemID=@ItemID;

            FETCH NEXT FROM assignment_cursor INTO
                @AssignmentID,@ItemID,@ProcessID,@LoanNumber,
                @UniqueCombination,@UniqueHash,@OldStatus;
        END;

        CLOSE assignment_cursor;
        DEALLOCATE assignment_cursor;

        COMMIT TRANSACTION;
        SELECT @Requested ReallocatedCount;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local','assignment_cursor')>=0 CLOSE assignment_cursor;
        IF CURSOR_STATUS('local','assignment_cursor')>-3 DEALLOCATE assignment_cursor;
        IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
        IF ERROR_NUMBER() IN(2601,2627)
            THROW 50112,'The configured unique loan combination is already allocated to another user.',1;
        THROW;
    END CATCH
END;
GO

UPDATE assignment
SET UniqueCombination=identityValue.UniqueCombination,
    UniqueCombinationHash=HASHBYTES('SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination))
FROM dbo.OLTracking_Assignment assignment
CROSS APPLY
(
    SELECT dbo.OLTracking_BuildUniqueCombination(
        assignment.ProjectID,assignment.ItemID,assignment.ProcessID) UniqueCombination
) identityValue
WHERE identityValue.UniqueCombination IS NOT NULL
  AND
  (
      assignment.UniqueCombination IS NULL
      OR assignment.UniqueCombination<>identityValue.UniqueCombination
      OR assignment.UniqueCombinationHash IS NULL
  );
GO

IF EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_Assignment')
      AND name='UX_OLTracking_Assignment_LoanProcess'
)
    DROP INDEX UX_OLTracking_Assignment_LoanProcess ON dbo.OLTracking_Assignment;
GO

IF EXISTS
(
    SELECT ProjectID,UniqueCombinationHash
    FROM dbo.OLTracking_Assignment
    WHERE IsCurrent=1 AND UniqueCombinationHash IS NOT NULL
    GROUP BY ProjectID,UniqueCombinationHash
    HAVING COUNT(1)>1
)
    THROW 50112,'Resolve existing duplicate active configured unique combinations before creating the unique index.',1;
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID('dbo.OLTracking_Assignment')
      AND name='UX_OLTracking_Assignment_DynamicUnique'
)
    CREATE UNIQUE INDEX UX_OLTracking_Assignment_DynamicUnique
        ON dbo.OLTracking_Assignment(ProjectID,UniqueCombinationHash)
        WHERE IsCurrent=1 AND UniqueCombinationHash IS NOT NULL;
GO

IF OBJECT_ID('dbo.OLTracking_ValidateManagerAllocation','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_ValidateManagerAllocation AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_ValidateManagerAllocation
    @ProjectID int,
    @ProcessID int,
    @LoanXml xml
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1 FROM dbo.WBT_ProjectTrackingFieldConfig
        WHERE ProjectID=@ProjectID AND IsUniqueField=1 AND IsDeleted=0
          AND ISNULL(IsSystemGenerated,0)=0 AND ISNULL(IsBillingField,0)=0
    )
        THROW 50134,'Configure at least one Unique Field for this project before allocation.',1;

    DECLARE @Selected table(ItemID bigint NOT NULL PRIMARY KEY,UniqueCombination nvarchar(2000) NULL,UniqueHash binary(32) NULL);
    INSERT @Selected(ItemID,UniqueCombination,UniqueHash)
    SELECT item.ItemID,identityValue.UniqueCombination,
           HASHBYTES('SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination))
    FROM
    (
        SELECT DISTINCT LTRIM(RTRIM(node.value('(text())[1]','nvarchar(150)'))) LoanNumber
        FROM @LoanXml.nodes('/loans/loan') source(node)
        WHERE NULLIF(LTRIM(RTRIM(node.value('(text())[1]','nvarchar(150)'))),'') IS NOT NULL
    ) selected
    INNER JOIN dbo.OLTracking_Item item
      ON item.ProjectID=@ProjectID AND item.ItemNumber=selected.LoanNumber AND item.IsDeleted=0
    CROSS APPLY
    (
        SELECT dbo.OLTracking_BuildUniqueCombination(@ProjectID,item.ItemID,@ProcessID) UniqueCombination
    ) identityValue;

    IF EXISTS(SELECT 1 FROM @Selected WHERE UniqueCombination IS NULL)
        THROW 50136,'One or more configured Unique Field values are missing for the selected loan.',1;

    IF EXISTS
    (
        SELECT 1
        FROM @Selected selected
        INNER JOIN dbo.OLTracking_Assignment assignment
          ON assignment.ProjectID=@ProjectID
         AND assignment.UniqueCombinationHash=selected.UniqueHash
         AND assignment.IsCurrent=1
    )
        THROW 50112,'The configured unique loan combination is already allocated to another user.',1;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetEligibleLoans','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetEligibleLoans AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_GetEligibleLoans
    @ProjectID int,
    @DealNumber nvarchar(150),
    @ProcessID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_ProcessFlow
                          WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1),
            @PreviousStage int;
    SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_ProcessFlow
    WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo<@StageNo;

    SELECT TOP(100) item.ItemID,item.ItemNumber LoanNumber,ISNULL(item.DealNumber,'') DealNumber
    FROM dbo.OLTracking_Item item
    CROSS APPLY
    (
        SELECT dbo.OLTracking_BuildUniqueCombination(@ProjectID,item.ItemID,@ProcessID) UniqueCombination
    ) identityValue
    WHERE @StageNo IS NOT NULL
      AND item.ProjectID=@ProjectID AND item.IsDeleted=0 AND item.RecordSource='Import'
      AND LTRIM(RTRIM(ISNULL(item.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
      AND identityValue.UniqueCombination IS NOT NULL
      AND NOT EXISTS
      (
          SELECT 1 FROM dbo.OLTracking_Assignment active
          WHERE active.ProjectID=@ProjectID AND active.IsCurrent=1
            AND active.UniqueCombinationHash=
                HASHBYTES('SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination))
      )
      AND NOT EXISTS
      (
          SELECT 1 FROM dbo.OLTracking_Assignment previous
          WHERE previous.ItemID=item.ItemID AND previous.ProcessID=@ProcessID
            AND previous.AssignmentStatus IN('Completed','Skipped')
      )
      AND
      (
          @PreviousStage IS NULL
          OR NOT EXISTS
             (
                 SELECT 1 FROM dbo.OLTracking_ProcessFlow flow
                 WHERE flow.ProjectID=@ProjectID AND flow.IsActive=1
                   AND flow.StageNo=@PreviousStage AND flow.IsMandatory=1
             )
          OR EXISTS
             (
                 SELECT 1 FROM dbo.OLTracking_Assignment completed
                 INNER JOIN dbo.OLTracking_ProcessFlow flow
                   ON flow.ProjectID=@ProjectID AND flow.ProcessID=completed.ProcessID
                  AND flow.IsActive=1 AND flow.IsMandatory=1 AND flow.StageNo=@PreviousStage
                 WHERE completed.ItemID=item.ItemID
                   AND completed.AssignmentStatus IN('Completed','Skipped')
             )
      )
    ORDER BY item.ItemID;
END;
GO

IF OBJECT_ID('dbo.OLTracking_ManagerAllocate','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_ManagerAllocate AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_ManagerAllocate
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
        IF @LockResult<0
            THROW 50112,'Unable to verify the configured unique loan combination. Please try again.',1;

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
              ON active.ProjectID=@ProjectID
             AND active.UniqueCombinationHash=selected.UniqueHash
             AND active.IsCurrent=1
        )
            THROW 50112,'The configured unique loan combination is already allocated to another user.',1;

        DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_ProcessFlow
                              WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1),
                @PreviousStage int;
        IF @StageNo IS NULL THROW 50111,'Selected process is not configured.',1;
        SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_ProcessFlow
        WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo<@StageNo;

        IF EXISTS
        (
            SELECT 1 FROM @Loans selected
            WHERE EXISTS
                  (
                      SELECT 1 FROM dbo.OLTracking_Assignment assignment
                      WHERE assignment.ItemID=selected.ItemID AND assignment.ProcessID=@ProcessID
                        AND assignment.AssignmentStatus IN('Completed','Skipped')
                  )
               OR
                  (
                      @PreviousStage IS NOT NULL
                      AND EXISTS
                          (
                              SELECT 1 FROM dbo.OLTracking_ProcessFlow flow
                              WHERE flow.ProjectID=@ProjectID AND flow.IsActive=1
                                AND flow.StageNo=@PreviousStage AND flow.IsMandatory=1
                          )
                      AND NOT EXISTS
                          (
                              SELECT 1 FROM dbo.OLTracking_Assignment completed
                              INNER JOIN dbo.OLTracking_ProcessFlow flow
                                ON flow.ProjectID=@ProjectID AND flow.ProcessID=completed.ProcessID
                               AND flow.IsActive=1 AND flow.IsMandatory=1 AND flow.StageNo=@PreviousStage
                              WHERE completed.ItemID=selected.ItemID
                                AND completed.AssignmentStatus IN('Completed','Skipped')
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

IF OBJECT_ID('dbo.OLTracking_RefreshProjectUniqueCombinations','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_RefreshProjectUniqueCombinations AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_RefreshProjectUniqueCombinations
    @ProjectID int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LockResult int;
    EXEC @LockResult=sys.sp_getapplock
        @Resource=N'OLTracking_Allocate_Global',@LockMode='Exclusive',
        @LockOwner='Transaction',@LockTimeout=10000;
    IF @LockResult<0
        THROW 50112,'Unable to refresh configured unique loan combinations. Please try again.',1;

    IF NOT EXISTS
    (
        SELECT 1 FROM dbo.WBT_ProjectTrackingFieldConfig
        WHERE ProjectID=@ProjectID AND IsUniqueField=1 AND IsDeleted=0
          AND ISNULL(IsSystemGenerated,0)=0 AND ISNULL(IsBillingField,0)=0
    )
    BEGIN
        UPDATE dbo.OLTracking_Assignment
        SET UniqueCombination=NULL,UniqueCombinationHash=NULL
        WHERE ProjectID=@ProjectID AND IsCurrent=1;
        RETURN;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.OLTracking_Assignment assignment
        WHERE assignment.ProjectID=@ProjectID AND assignment.IsCurrent=1
          AND dbo.OLTracking_BuildUniqueCombination(
                assignment.ProjectID,assignment.ItemID,assignment.ProcessID) IS NULL
    )
        THROW 50136,'A configured Unique Field value is missing on one or more active loans.',1;

    UPDATE assignment
    SET UniqueCombination=identityValue.UniqueCombination,
        UniqueCombinationHash=HASHBYTES(
            'SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination))
    FROM dbo.OLTracking_Assignment assignment
    CROSS APPLY
    (
        SELECT dbo.OLTracking_BuildUniqueCombination(
            assignment.ProjectID,assignment.ItemID,assignment.ProcessID) UniqueCombination
    ) identityValue
    WHERE assignment.ProjectID=@ProjectID AND assignment.IsCurrent=1;
END;
GO

IF OBJECT_ID('dbo.OLTracking_Assignment_ApplyDynamicUnique','TR') IS NULL
    EXEC('CREATE TRIGGER dbo.OLTracking_Assignment_ApplyDynamicUnique ON dbo.OLTracking_Assignment AFTER INSERT AS BEGIN SET NOCOUNT ON; END');
GO

ALTER TRIGGER dbo.OLTracking_Assignment_ApplyDynamicUnique
ON dbo.OLTracking_Assignment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1 FROM inserted row
        WHERE row.IsCurrent=1
          AND NOT EXISTS
          (
              SELECT 1 FROM dbo.WBT_ProjectTrackingFieldConfig field
              WHERE field.ProjectID=row.ProjectID AND field.IsUniqueField=1
                AND field.IsDeleted=0 AND ISNULL(field.IsSystemGenerated,0)=0
                AND ISNULL(field.IsBillingField,0)=0
          )
    )
        THROW 50134,'Configure at least one Unique Field for this project before allocation.',1;

    UPDATE assignment
    SET UniqueCombination=identityValue.UniqueCombination,
        UniqueCombinationHash=HASHBYTES(
            'SHA2_256',CONVERT(varbinary(max),identityValue.UniqueCombination))
    FROM dbo.OLTracking_Assignment assignment
    INNER JOIN inserted row ON row.AssignmentID=assignment.AssignmentID
    CROSS APPLY
    (
        SELECT dbo.OLTracking_BuildUniqueCombination(
            assignment.ProjectID,assignment.ItemID,assignment.ProcessID) UniqueCombination
    ) identityValue
    WHERE assignment.IsCurrent=1;

    IF EXISTS
    (
        SELECT 1 FROM inserted row
        INNER JOIN dbo.OLTracking_Assignment assignment
          ON assignment.AssignmentID=row.AssignmentID
        WHERE assignment.IsCurrent=1
          AND (assignment.UniqueCombination IS NULL OR assignment.UniqueCombinationHash IS NULL)
    )
        THROW 50136,'One or more configured Unique Field values are missing for the allocated loan.',1;
END;
GO

