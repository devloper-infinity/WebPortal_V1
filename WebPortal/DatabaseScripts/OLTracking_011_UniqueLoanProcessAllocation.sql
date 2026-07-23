/* Enforce one active allocation for each Loan Number + Process combination. */
IF COL_LENGTH('dbo.OLTracking_Assignment','LoanNumber') IS NULL
    ALTER TABLE dbo.OLTracking_Assignment ADD LoanNumber nvarchar(150) NULL;
GO

UPDATE assignment
SET LoanNumber=LTRIM(RTRIM(item.ItemNumber))
FROM dbo.OLTracking_Assignment assignment
INNER JOIN dbo.OLTracking_Item item ON item.ItemID=assignment.ItemID
WHERE assignment.LoanNumber IS NULL
   OR assignment.LoanNumber<>LTRIM(RTRIM(item.ItemNumber));

IF EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment WHERE LoanNumber IS NULL)
    THROW 50112,'Loan Number could not be populated for one or more assignments.',1;

ALTER TABLE dbo.OLTracking_Assignment ALTER COLUMN LoanNumber nvarchar(150) NOT NULL;
GO

IF OBJECT_ID('dbo.OLTracking_AllocateLoan','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_AllocateLoan AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_AllocateLoan
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

        DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_ProcessFlow
                              WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1);
        IF @StageNo IS NULL THROW 50111,'Selected process is not configured in the tracking flow.',1;

        DECLARE @ItemID bigint=(SELECT ItemID FROM dbo.OLTracking_Item WITH(UPDLOCK,HOLDLOCK)
                                WHERE ProjectID=@ProjectID AND ItemNumber=@LoanNumber AND IsDeleted=0);
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

        DECLARE @PreviousStage int;
        SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_ProcessFlow
        WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo<@StageNo;
        IF @PreviousStage IS NOT NULL
           AND EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo=@PreviousStage AND IsMandatory=1)
           AND EXISTS
           (
               SELECT 1 FROM dbo.OLTracking_ProcessFlow flow
               WHERE flow.ProjectID=@ProjectID AND flow.IsActive=1 AND flow.StageNo=@PreviousStage AND flow.IsMandatory=1
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
    BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK TRANSACTION; THROW; END CATCH
END;
GO

IF OBJECT_ID('dbo.OLTracking_ManagerAllocate','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_ManagerAllocate AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_ManagerAllocate
    @ProjectID int,@DealNumber nvarchar(150),@ProcessID int,@TargetUserID int,@LoanXml xml,@ManagerID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @LockResult int;
        EXEC @LockResult=sys.sp_getapplock @Resource=N'OLTracking_Allocate_Global',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
        IF @LockResult<0 THROW 50112,'Unable to verify whether the selected loans are already allocated. Please try again.',1;

        DECLARE @Loans table(LoanNumber nvarchar(150) NOT NULL PRIMARY KEY);
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
        IF EXISTS(SELECT 1 FROM @Loans selected
                  INNER JOIN dbo.OLTracking_Assignment assignment WITH(UPDLOCK,HOLDLOCK)
                     ON assignment.LoanNumber=selected.LoanNumber AND assignment.ProcessID=@ProcessID AND assignment.IsCurrent=1)
            THROW 50112,'A selected Loan Number + Process combination is already allocated to another user.',1;

        DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND ProcessID=@ProcessID AND IsActive=1),
                @PreviousStage int;
        IF @StageNo IS NULL THROW 50111,'Selected process is not configured.',1;
        SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_ProcessFlow WHERE ProjectID=@ProjectID AND IsActive=1 AND StageNo<@StageNo;
        IF (SELECT COUNT(1) FROM @Loans selected
            INNER JOIN dbo.OLTracking_Item item ON item.ProjectID=@ProjectID AND item.ItemNumber=selected.LoanNumber AND item.IsDeleted=0 AND item.RecordSource='Import'
            WHERE LTRIM(RTRIM(ISNULL(item.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
              AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment assignment
                             WHERE assignment.ItemID=item.ItemID AND assignment.ProcessID=@ProcessID
                               AND (assignment.IsCurrent=1 OR assignment.AssignmentStatus IN('Completed','Skipped')))
              AND (@PreviousStage IS NULL
                   OR NOT EXISTS(SELECT 1 FROM dbo.OLTracking_ProcessFlow previousFlow
                                 WHERE previousFlow.ProjectID=@ProjectID AND previousFlow.IsActive=1
                                   AND previousFlow.StageNo=@PreviousStage AND previousFlow.IsMandatory=1)
                   OR EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment previousAssignment
                             INNER JOIN dbo.OLTracking_ProcessFlow previousFlow
                               ON previousFlow.ProjectID=@ProjectID AND previousFlow.ProcessID=previousAssignment.ProcessID
                              AND previousFlow.IsActive=1 AND previousFlow.IsMandatory=1 AND previousFlow.StageNo=@PreviousStage
                             WHERE previousAssignment.ItemID=item.ItemID
                               AND previousAssignment.AssignmentStatus IN('Completed','Skipped'))))<>@Requested
            THROW 50128,'One or more selected orders are no longer eligible.',1;

        INSERT dbo.OLTracking_Assignment(ItemID,ProjectID,ProcessID,UserID,LoanNumber,AssignmentStatus,AddedBy)
        SELECT item.ItemID,@ProjectID,@ProcessID,@TargetUserID,selected.LoanNumber,'Pending',@ManagerID
        FROM @Loans selected
        INNER JOIN dbo.OLTracking_Item item ON item.ProjectID=@ProjectID AND item.ItemNumber=selected.LoanNumber AND item.IsDeleted=0;
        UPDATE item SET ItemStatus='Allocated',CurrentProcessID=@ProcessID,UpdatedBy=@ManagerID,UpdatedDate=GETDATE()
        FROM dbo.OLTracking_Item item INNER JOIN @Loans selected ON selected.LoanNumber=item.ItemNumber
        WHERE item.ProjectID=@ProjectID;
        COMMIT TRANSACTION;
        SELECT @Requested AllocatedCount;
    END TRY
    BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK TRANSACTION; THROW; END CATCH
END;
GO

IF EXISTS
(
    SELECT LoanNumber,ProcessID
    FROM dbo.OLTracking_Assignment
    WHERE IsCurrent=1
    GROUP BY LoanNumber,ProcessID
    HAVING COUNT(1)>1
)
    THROW 50112,'Resolve existing duplicate active Loan Number + Process assignments before creating the unique index.',1;

IF NOT EXISTS(SELECT 1 FROM sys.indexes
              WHERE object_id=OBJECT_ID('dbo.OLTracking_Assignment')
                AND name='UX_OLTracking_Assignment_LoanProcess')
    CREATE UNIQUE INDEX UX_OLTracking_Assignment_LoanProcess
        ON dbo.OLTracking_Assignment(LoanNumber,ProcessID)
        WHERE IsCurrent=1;
GO
