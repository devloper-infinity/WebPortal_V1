/* Manager-controlled loan-level holds.
   An active loan hold freezes every process assignment for the loan until resumed.
   Safe to rerun. Deploy after OLTracking_022. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('dbo.OLTracking_LoanHold','U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_LoanHold
    (
        LoanHoldID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_LoanHold PRIMARY KEY,
        ItemID bigint NOT NULL,
        ProjectID int NOT NULL,
        DealNumber nvarchar(150) NULL,
        Reason nvarchar(1000) NOT NULL,
        HeldBy int NOT NULL,
        HeldDate datetime NOT NULL CONSTRAINT DF_OLTracking_LoanHold_HeldDate DEFAULT(GETDATE()),
        ResumedBy int NULL,
        ResumedDate datetime NULL,
        CONSTRAINT FK_OLTracking_LoanHold_Item FOREIGN KEY(ItemID) REFERENCES dbo.OLTracking_Item(ItemID)
    );
END;
GO

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.OLTracking_LoanHold') AND name='UX_OLTracking_LoanHold_ActiveItem')
    CREATE UNIQUE INDEX UX_OLTracking_LoanHold_ActiveItem
        ON dbo.OLTracking_LoanHold(ItemID) WHERE ResumedDate IS NULL;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.OLTracking_LoanHold') AND name='IX_OLTracking_LoanHold_Filter')
    CREATE INDEX IX_OLTracking_LoanHold_Filter
        ON dbo.OLTracking_LoanHold(ProjectID,DealNumber,ResumedDate) INCLUDE(ItemID,HeldDate,HeldBy);
GO

IF OBJECT_ID('dbo.OLTracking_Assignment_BlockActiveLoanHold','TR') IS NULL
    EXEC('CREATE TRIGGER dbo.OLTracking_Assignment_BlockActiveLoanHold ON dbo.OLTracking_Assignment AFTER INSERT AS BEGIN SET NOCOUNT ON; END');
GO

ALTER TRIGGER dbo.OLTracking_Assignment_BlockActiveLoanHold
ON dbo.OLTracking_Assignment
AFTER INSERT,UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS
    (
        SELECT 1 FROM inserted changed
        JOIN dbo.OLTracking_LoanHold loanHold ON loanHold.ItemID=changed.ItemID
        WHERE loanHold.ResumedDate IS NULL
    )
        THROW 50160,'This loan is on manager hold and cannot enter or change a process until it is resumed.',1;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetLoanHoldCandidates','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetLoanHoldCandidates AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetLoanHoldCandidates
    @ProjectID int,@DealNumber nvarchar(150)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT item.ItemID,item.ItemNumber LoanNumber,ISNULL(item.DealNumber,N'') DealNumber,
        ISNULL(item.ItemStatus,N'Pending') LoanStatus,item.AddedDate,
        currentWork.ProcessName,currentWork.UserName,currentWork.AssignmentStatus
    FROM dbo.OLTracking_Item item
    OUTER APPLY
    (
        SELECT TOP(1) flow.ProcessName,
            COALESCE(NULLIF(configuration.PsuedoName,N''),NULLIF(configuration.Code,N''),
                     NULLIF(employee.Code,N''),CONVERT(nvarchar(30),assignment.UserID)) UserName,
            assignment.AssignmentStatus
        FROM dbo.OLTracking_Assignment assignment
        LEFT JOIN dbo.OLTracking_ProcessFlow flow ON flow.ProjectID=assignment.ProjectID
             AND flow.ProcessID=assignment.ProcessID AND flow.IsActive=1
        LEFT JOIN dbo.EmployeeInfo employee ON employee.EmployeeID=assignment.UserID
        OUTER APPLY
        (
            SELECT TOP(1) configured.Code,configured.PsuedoName
            FROM dbo.EmployeeConfiguration configured
            WHERE configured.EmployeeID=assignment.UserID AND configured.IsDelete=0
            ORDER BY configured.EmpConfigrationID DESC
        ) configuration
        WHERE assignment.ItemID=item.ItemID AND assignment.IsCurrent=1
        ORDER BY CASE assignment.AssignmentStatus WHEN 'In Process' THEN 0 WHEN 'Hold' THEN 1 ELSE 2 END,
                 assignment.AssignmentID DESC
    ) currentWork
    WHERE item.ProjectID=@ProjectID AND item.IsDeleted=0
      AND LTRIM(RTRIM(ISNULL(item.DealNumber,N'')))=LTRIM(RTRIM(ISNULL(@DealNumber,N'')))
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_LoanHold activeHold
                     WHERE activeHold.ItemID=item.ItemID AND activeHold.ResumedDate IS NULL)
    ORDER BY item.ItemID;
END;
GO

IF OBJECT_ID('dbo.OLTracking_GetHeldLoans','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_GetHeldLoans AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_GetHeldLoans
    @ProjectID int,@DealNumber nvarchar(150)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT loanHold.LoanHoldID,item.ItemID,item.ItemNumber LoanNumber,ISNULL(item.DealNumber,N'') DealNumber,
        loanHold.Reason,loanHold.HeldDate,
        COALESCE(NULLIF(configuration.PsuedoName,N''),NULLIF(configuration.Code,N''),
                 NULLIF(employee.Code,N''),CONVERT(nvarchar(30),loanHold.HeldBy)) HeldByName,
        currentWork.ProcessName,currentWork.UserName,currentWork.AssignmentStatus
    FROM dbo.OLTracking_LoanHold loanHold
    JOIN dbo.OLTracking_Item item ON item.ItemID=loanHold.ItemID AND item.IsDeleted=0
    LEFT JOIN dbo.EmployeeInfo employee ON employee.EmployeeID=loanHold.HeldBy
    OUTER APPLY
    (
        SELECT TOP(1) configured.Code,configured.PsuedoName
        FROM dbo.EmployeeConfiguration configured
        WHERE configured.EmployeeID=loanHold.HeldBy AND configured.IsDelete=0
        ORDER BY configured.EmpConfigrationID DESC
    ) configuration
    OUTER APPLY
    (
        SELECT TOP(1) flow.ProcessName,
            COALESCE(NULLIF(processorConfig.PsuedoName,N''),NULLIF(processorConfig.Code,N''),
                     NULLIF(processor.Code,N''),CONVERT(nvarchar(30),assignment.UserID)) UserName,
            assignment.AssignmentStatus
        FROM dbo.OLTracking_Assignment assignment
        LEFT JOIN dbo.OLTracking_ProcessFlow flow ON flow.ProjectID=assignment.ProjectID
             AND flow.ProcessID=assignment.ProcessID AND flow.IsActive=1
        LEFT JOIN dbo.EmployeeInfo processor ON processor.EmployeeID=assignment.UserID
        OUTER APPLY
        (
            SELECT TOP(1) configured.Code,configured.PsuedoName
            FROM dbo.EmployeeConfiguration configured
            WHERE configured.EmployeeID=assignment.UserID AND configured.IsDelete=0
            ORDER BY configured.EmpConfigrationID DESC
        ) processorConfig
        WHERE assignment.ItemID=item.ItemID AND assignment.IsCurrent=1
        ORDER BY CASE assignment.AssignmentStatus WHEN 'In Process' THEN 0 WHEN 'Hold' THEN 1 ELSE 2 END,
                 assignment.AssignmentID DESC
    ) currentWork
    WHERE loanHold.ProjectID=@ProjectID AND loanHold.ResumedDate IS NULL
      AND LTRIM(RTRIM(ISNULL(loanHold.DealNumber,N'')))=LTRIM(RTRIM(ISNULL(@DealNumber,N'')))
    ORDER BY loanHold.HeldDate DESC,loanHold.LoanHoldID DESC;
END;
GO

IF OBJECT_ID('dbo.OLTracking_HoldLoans','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_HoldLoans AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_HoldLoans
    @ProjectID int,@DealNumber nvarchar(150),@ItemXml xml,@Reason nvarchar(1000),@UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    SET @Reason=LTRIM(RTRIM(@Reason));
    IF NULLIF(@Reason,N'') IS NULL THROW 50161,'Reason is required.',1;
    DECLARE @Items table(ItemID bigint PRIMARY KEY);
    INSERT @Items(ItemID)
    SELECT DISTINCT node.value('(text())[1]','bigint')
    FROM @ItemXml.nodes('/items/item') source(node)
    WHERE node.value('(text())[1]','bigint')>0;
    DECLARE @Requested int=(SELECT COUNT(1) FROM @Items);
    IF @Requested<1 THROW 50162,'Select at least one loan.',1;
    IF EXISTS
    (
        SELECT 1 FROM @Items selected
        LEFT JOIN dbo.OLTracking_Item item ON item.ItemID=selected.ItemID
          AND item.ProjectID=@ProjectID AND item.IsDeleted=0
          AND LTRIM(RTRIM(ISNULL(item.DealNumber,N'')))=LTRIM(RTRIM(ISNULL(@DealNumber,N'')))
        WHERE item.ItemID IS NULL
    ) THROW 50163,'One or more selected loans are no longer available for this Project and Deal.',1;
    BEGIN TRANSACTION;
    INSERT dbo.OLTracking_LoanHold(ItemID,ProjectID,DealNumber,Reason,HeldBy)
    SELECT item.ItemID,item.ProjectID,item.DealNumber,@Reason,@UserID
    FROM @Items selected JOIN dbo.OLTracking_Item item WITH(UPDLOCK,HOLDLOCK) ON item.ItemID=selected.ItemID
    WHERE NOT EXISTS(SELECT 1 FROM dbo.OLTracking_LoanHold activeHold WITH(UPDLOCK,HOLDLOCK)
                     WHERE activeHold.ItemID=item.ItemID AND activeHold.ResumedDate IS NULL);
    DECLARE @Affected int=@@ROWCOUNT;
    IF @Affected<>@Requested THROW 50164,'One or more selected loans are already held. Refresh and try again.',1;
    COMMIT;
    SELECT @Affected AffectedRows;
END;
GO

IF OBJECT_ID('dbo.OLTracking_ResumeLoans','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_ResumeLoans AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.OLTracking_ResumeLoans
    @ProjectID int,@DealNumber nvarchar(150),@ItemXml xml,@UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    DECLARE @Items table(ItemID bigint PRIMARY KEY);
    INSERT @Items(ItemID)
    SELECT DISTINCT node.value('(text())[1]','bigint')
    FROM @ItemXml.nodes('/items/item') source(node)
    WHERE node.value('(text())[1]','bigint')>0;
    DECLARE @Requested int=(SELECT COUNT(1) FROM @Items);
    IF @Requested<1 THROW 50162,'Select at least one held loan.',1;
    BEGIN TRANSACTION;
    UPDATE loanHold SET ResumedBy=@UserID,ResumedDate=GETDATE()
    FROM dbo.OLTracking_LoanHold loanHold WITH(UPDLOCK,HOLDLOCK)
    JOIN @Items selected ON selected.ItemID=loanHold.ItemID
    WHERE loanHold.ProjectID=@ProjectID AND loanHold.ResumedDate IS NULL
      AND LTRIM(RTRIM(ISNULL(loanHold.DealNumber,N'')))=LTRIM(RTRIM(ISNULL(@DealNumber,N'')));
    DECLARE @Affected int=@@ROWCOUNT;
    IF @Affected<>@Requested THROW 50165,'One or more selected loans are no longer held. Refresh and try again.',1;
    COMMIT;
    SELECT @Affected AffectedRows;
END;
GO

/* User queue: active manager-held loans are intentionally invisible. */
ALTER PROCEDURE dbo.OLTracking_GetTrackingQueue @UserID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.AssignmentID,a.ProjectID,a.ProcessID,flow.ProcessName,i.ItemNumber LoanNumber,ISNULL(i.DealNumber,'') DealNumber,
        a.AssignmentStatus,a.AssignedDate,a.StartedDate,a.HoldDate,a.LastRemark,flow.FeedbackRequiredOnComplete,
        CAST(CASE WHEN flow.IsMandatory=1 THEN 0 ELSE 1 END AS bit) CanSkip,
        ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END HoldTATSeconds,
        CASE WHEN a.AssignedDate IS NULL THEN NULL ELSE
             CASE WHEN DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END)<0 THEN 0
                  ELSE DATEDIFF(second,a.AssignedDate,GETDATE())-(ISNULL(a.HoldTATSeconds,0)+CASE WHEN a.AssignmentStatus='Hold' AND a.HoldDate IS NOT NULL THEN DATEDIFF(second,a.HoldDate,GETDATE()) ELSE 0 END) END END TotalTATSeconds
    FROM dbo.OLTracking_Assignment a
    JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID
    CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(a.ProjectID,i.DealNumber) flow
    WHERE a.UserID=@UserID AND a.IsCurrent=1 AND flow.ProcessID=a.ProcessID
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_LoanHold loanHold
                     WHERE loanHold.ItemID=i.ItemID AND loanHold.ResumedDate IS NULL)
    ORDER BY a.AssignedDate;
END;
GO

/* Manager allocation list: held loans never appear as eligible. */
ALTER PROCEDURE dbo.OLTracking_GetEligibleLoans
    @ProjectID int,@DealNumber nvarchar(150),@ProcessID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StageNo int=(SELECT StageNo FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE ProcessID=@ProcessID),
            @PreviousStage int;
    SELECT @PreviousStage=MAX(StageNo) FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE StageNo<@StageNo;
    SELECT TOP(100) item.ItemID,item.ItemNumber LoanNumber,ISNULL(item.DealNumber,'') DealNumber
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

ALTER PROCEDURE dbo.OLTracking_ValidateManagerAllocation @ProjectID int,@ProcessID int,@LoanXml xml
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS(SELECT 1 FROM dbo.WBT_ProjectTrackingFieldConfig WHERE ProjectID=@ProjectID AND IsUniqueField=1 AND IsDeleted=0
                  AND ISNULL(IsSystemGenerated,0)=0 AND ISNULL(IsBillingField,0)=0)
        THROW 50134,'Configure at least one Unique Field for this project before allocation.',1;
    DECLARE @Selected table(ItemID bigint PRIMARY KEY,UniqueCombination nvarchar(2000),UniqueHash binary(32));
    INSERT @Selected
    SELECT item.ItemID,value.UniqueCombination,HASHBYTES('SHA2_256',CONVERT(varbinary(max),value.UniqueCombination))
    FROM(SELECT DISTINCT LTRIM(RTRIM(n.value('(text())[1]','nvarchar(150)'))) LoanNumber FROM @LoanXml.nodes('/loans/loan') x(n)) selected
    JOIN dbo.OLTracking_Item item ON item.ProjectID=@ProjectID AND item.ItemNumber=selected.LoanNumber AND item.IsDeleted=0
    CROSS APPLY(SELECT dbo.OLTracking_BuildUniqueCombination(@ProjectID,item.ItemID,@ProcessID) UniqueCombination)value
    WHERE EXISTS(SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,item.DealNumber) WHERE ProcessID=@ProcessID);
    IF (SELECT COUNT(1) FROM @Selected)<>(SELECT COUNT(DISTINCT LTRIM(RTRIM(n.value('(text())[1]','nvarchar(150)')))) FROM @LoanXml.nodes('/loans/loan') x(n))
        THROW 50128,'One or more selected orders are not applicable to this deal process flow.',1;
    IF EXISTS(SELECT 1 FROM @Selected selected JOIN dbo.OLTracking_LoanHold loanHold ON loanHold.ItemID=selected.ItemID WHERE loanHold.ResumedDate IS NULL)
        THROW 50160,'One or more selected loans are on manager hold.',1;
    IF EXISTS(SELECT 1 FROM @Selected WHERE UniqueCombination IS NULL) THROW 50136,'One or more configured Unique Field values are missing for the selected loan.',1;
    IF EXISTS(SELECT 1 FROM @Selected s JOIN dbo.OLTracking_Assignment a ON a.ProjectID=@ProjectID AND a.ProcessID=@ProcessID AND a.UniqueCombinationHash=s.UniqueHash AND a.IsCurrent=1)
        THROW 50112,'The configured unique loan combination is already allocated to another user.',1;
END;
GO

ALTER PROCEDURE dbo.OLTracking_GetReallocationOrders @ProjectID int,@DealNumber nvarchar(150),@ProcessID int,@FromUserID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.AssignmentID,p.ProjectName,i.DealNumber,flow.ProcessName,i.ItemNumber LoanNumber,
           COALESCE(NULLIF(ec.PsuedoName,''),NULLIF(ec.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),a.UserID)) UserName,
           a.AssignmentStatus,a.LastRemark,a.AssignedDate
    FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID JOIN dbo.Project p ON p.ProjectID=a.ProjectID
    LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.UserID
    OUTER APPLY(SELECT TOP 1 c.Code,c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE c.EmployeeID=a.UserID AND c.Code=e.Code AND c.DataSource='ERP' AND c.IsDelete=0 ORDER BY c.EmpConfigrationID DESC) ec
    CROSS APPLY(SELECT * FROM dbo.OLTracking_EffectiveProcessFlow(a.ProjectID,i.DealNumber) f WHERE f.ProcessID=a.ProcessID) flow
    WHERE a.ProjectID=@ProjectID AND a.ProcessID=@ProcessID AND a.UserID=@FromUserID AND a.IsCurrent=1
      AND a.AssignmentStatus IN('Pending','In Process','Hold') AND LTRIM(RTRIM(ISNULL(i.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_LoanHold loanHold WHERE loanHold.ItemID=i.ItemID AND loanHold.ResumedDate IS NULL)
    ORDER BY a.AssignedDate;
END;
GO

ALTER PROCEDURE dbo.OLTracking_GetReallocationUsers @ProjectID int,@DealNumber nvarchar(150),@ProcessID int
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS(SELECT 1 FROM dbo.OLTracking_EffectiveProcessFlow(@ProjectID,@DealNumber) WHERE ProcessID=@ProcessID) RETURN;
    SELECT DISTINCT a.UserID,COALESCE(NULLIF(ec.PsuedoName,''),NULLIF(ec.Code,''),NULLIF(e.Code,''),CONVERT(nvarchar(30),a.UserID)) UserName
    FROM dbo.OLTracking_Assignment a JOIN dbo.OLTracking_Item i ON i.ItemID=a.ItemID LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.UserID
    OUTER APPLY(SELECT TOP 1 c.Code,c.PsuedoName FROM dbo.EmployeeConfiguration c WHERE c.EmployeeID=a.UserID AND c.Code=e.Code AND c.DataSource='ERP' AND c.IsDelete=0 ORDER BY c.EmpConfigrationID DESC) ec
    WHERE a.ProjectID=@ProjectID AND a.ProcessID=@ProcessID AND a.IsCurrent=1 AND a.AssignmentStatus IN('Pending','In Process','Hold')
      AND LTRIM(RTRIM(ISNULL(i.DealNumber,'')))=LTRIM(RTRIM(ISNULL(@DealNumber,'')))
      AND NOT EXISTS(SELECT 1 FROM dbo.OLTracking_LoanHold loanHold WHERE loanHold.ItemID=i.ItemID AND loanHold.ResumedDate IS NULL)
    ORDER BY UserName;
END;
GO
