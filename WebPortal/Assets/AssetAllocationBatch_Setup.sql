SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF COL_LENGTH('dbo.AssetsAllocation','ShiftID') IS NULL ALTER TABLE dbo.AssetsAllocation ADD ShiftID INT NULL;
IF COL_LENGTH('dbo.AssetsAllocation','ShiftName') IS NULL ALTER TABLE dbo.AssetsAllocation ADD ShiftName NVARCHAR(100) NULL;
GO
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.AssetsAllocation') AND name='UX_AssetsAllocation_ActiveAssetShift')
AND NOT EXISTS(SELECT AssetID,ShiftID FROM dbo.AssetsAllocation WHERE IsDeleted=0 AND Status='Allocated' AND ReturnDate IS NULL AND ShiftID IS NOT NULL GROUP BY AssetID,ShiftID HAVING COUNT(*)>1)
CREATE UNIQUE INDEX UX_AssetsAllocation_ActiveAssetShift ON dbo.AssetsAllocation(AssetID,ShiftID) WHERE IsDeleted=0 AND Status='Allocated' AND ReturnDate IS NULL AND ShiftID IS NOT NULL;
GO

IF OBJECT_ID(N'dbo.usp_Assets_SaveAllocationBatch', N'P') IS NULL
    EXEC(N'CREATE PROCEDURE dbo.usp_Assets_SaveAllocationBatch AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.usp_Assets_SaveAllocationBatch
    @Xml XML,
    @UserID BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EmployeeID BIGINT, @ShiftID INT, @ShiftName NVARCHAR(100), @BranchID INT, @AllocationDate DATE, @ExpectedReturnDate DATE,
            @Condition NVARCHAR(100), @Accessories NVARCHAR(500), @Purpose NVARCHAR(500),
            @Remarks NVARCHAR(1000), @AssetStatusID INT;

    SELECT @EmployeeID = N.value('(EmployeeID/text())[1]', 'BIGINT'),
           @ShiftID = N.value('(ShiftID/text())[1]', 'INT'),
           @ShiftName = N.value('(ShiftName/text())[1]', 'NVARCHAR(100)'),
           @BranchID = N.value('(BranchID/text())[1]', 'INT'),
           @AllocationDate = CONVERT(DATE, N.value('(AllocationDate/text())[1]', 'DATETIME')),
           @ExpectedReturnDate = CASE WHEN N.exist('ExpectedReturnDate/text()') = 1 THEN CONVERT(DATE, N.value('(ExpectedReturnDate/text())[1]', 'DATETIME')) END,
           @Condition = N.value('(AssetConditionAtAllocation/text())[1]', 'NVARCHAR(100)'),
           @Accessories = N.value('(AccessoriesIssued/text())[1]', 'NVARCHAR(500)'),
           @Purpose = N.value('(Purpose/text())[1]', 'NVARCHAR(500)'),
           @Remarks = N.value('(Remarks/text())[1]', 'NVARCHAR(1000)'),
           @AssetStatusID = CASE WHEN N.exist('AssetStatusID/text()') = 1 THEN N.value('(AssetStatusID/text())[1]', 'INT') END
    FROM @Xml.nodes('/AllocationBatchInput') X(N);

    DECLARE @Assets TABLE (RowNo INT IDENTITY(1,1) NOT NULL, AssetID BIGINT NOT NULL PRIMARY KEY);
    INSERT INTO @Assets (AssetID)
    SELECT DISTINCT N.value('(text())[1]', 'BIGINT')
    FROM @Xml.nodes('/AllocationBatchInput/AssetIDs/long') X(N);

    IF NOT EXISTS (SELECT 1 FROM @Assets) RAISERROR('Select at least one available asset.', 16, 1);
    IF ISNULL(@EmployeeID, 0) <= 0 RAISERROR('Employee is required.', 16, 1);
    IF ISNULL(@ShiftID, 0) NOT IN (1,2) RAISERROR('Shift must be Day or Night.', 16, 1);
    SET @ShiftName=CASE @ShiftID WHEN 1 THEN N'Day' WHEN 2 THEN N'Night' END;
    IF ISNULL(@BranchID, 0) <= 0 RAISERROR('Branch is required.', 16, 1);
    IF @AllocationDate IS NULL RAISERROR('Allocation date is required.', 16, 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.EmployeeInfo WHERE EmployeeID = @EmployeeID AND ISNULL(IsDelete, 0) = 0) RAISERROR('Selected employee is not available.', 16, 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.Branch WHERE BranchID = @BranchID AND ISNULL(IsDelete, 0) = 0) RAISERROR('Selected branch is not available.', 16, 1);
    IF @AssetStatusID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.AssetStatusMaster WHERE AssetStatusID = @AssetStatusID AND IsDeleted = 0 AND IsActive = 1) RAISERROR('Selected asset status is not active.', 16, 1);
    IF EXISTS (SELECT 1 FROM @Assets X LEFT JOIN dbo.AssetsMaster M ON M.AssetID = X.AssetID AND M.IsDeleted = 0 WHERE M.AssetID IS NULL) RAISERROR('One or more selected assets no longer exist.', 16, 1);
    IF EXISTS (SELECT 1 FROM @Assets X INNER JOIN dbo.AssetsAllocation A ON A.AssetID = X.AssetID AND (A.ShiftID=@ShiftID OR A.ShiftID IS NULL) AND A.Status = 'Allocated' AND A.ReturnDate IS NULL AND A.IsDeleted = 0) RAISERROR('One or more selected assets are already allocated in this shift. Refresh and try again.', 16, 1);

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @BatchNumber NVARCHAR(30) = REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(23), GETDATE(), 121), '-', ''), ':', ''), ' ', ''), '.', '');

        INSERT INTO dbo.AssetsAllocation
        (
            AllocationNumber, AssetID, AllocationType, EmployeeID, DepartmentID, ProjectID, ShiftID, ShiftName,
            BranchID, AllocationDate, ExpectedReturnDate, AssetConditionAtAllocation,
            AccessoriesIssued, Purpose, Status, Remarks, IsDeleted, CreatedBy, CreatedDate
        )
        SELECT N'AL-' + @BatchNumber + N'-' + RIGHT(N'000' + CONVERT(NVARCHAR(10), X.RowNo), 3),
               X.AssetID, N'Employee', @EmployeeID, NULL, NULL, @ShiftID, @ShiftName, @BranchID, @AllocationDate,
               @ExpectedReturnDate, NULLIF(@Condition, N''), NULLIF(@Accessories, N''),
               NULLIF(@Purpose, N''), N'Allocated', NULLIF(@Remarks, N''), 0, @UserID, GETDATE()
        FROM @Assets X;

        UPDATE M
           SET M.CurrentEmployeeID = @EmployeeID,
               M.CurrentDepartmentID = NULL,
               M.CurrentProjectID = NULL,
               M.CurrentBranchID = @BranchID,
               M.AvailableForAllocation = 0,
               M.LastAllocationDate = @AllocationDate,
               M.AssetStatusID = COALESCE(@AssetStatusID, M.AssetStatusID),
               M.UpdatedBy = @UserID,
               M.UpdatedDate = GETDATE()
        FROM dbo.AssetsMaster M
        INNER JOIN @Assets X ON X.AssetID = M.AssetID;

        COMMIT TRANSACTION;
        SELECT CONVERT(BIGINT, COUNT(1)) FROM @Assets;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
