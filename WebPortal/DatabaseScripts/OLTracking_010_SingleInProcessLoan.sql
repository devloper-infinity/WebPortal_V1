/* Allow only one In Process loan per user. Safe to run repeatedly. */
IF OBJECT_ID('dbo.OLTracking_StartLoan','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_StartLoan AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_StartLoan
    @AssignmentID bigint,
    @UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @LockResult int,@LockResource nvarchar(255)=N'OLTracking_InProcess_User_'+CONVERT(nvarchar(20),@UserID);
        EXEC @LockResult=sys.sp_getapplock @Resource=@LockResource,@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
        IF @LockResult<0 THROW 50132,'Unable to verify the active loan. Please try again.',1;
        IF NOT EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
                      WHERE AssignmentID=@AssignmentID AND UserID=@UserID AND IsCurrent=1 AND AssignmentStatus='Pending')
            THROW 50120,'Pending assignment was not found.',1;
        IF EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
                  WHERE UserID=@UserID AND IsCurrent=1 AND AssignmentStatus='In Process')
            THROW 50132,'Another loan is already in process.',1;

        UPDATE dbo.OLTracking_Assignment
           SET AssignmentStatus='In Process',StartedDate=ISNULL(StartedDate,GETDATE()),UpdatedBy=@UserID,UpdatedDate=GETDATE()
         WHERE AssignmentID=@AssignmentID;
        INSERT dbo.OLTracking_StatusHistory(AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
        VALUES(@AssignmentID,'Pending','In Process','Work started',@UserID);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK TRANSACTION; THROW; END CATCH
END;
GO

IF OBJECT_ID('dbo.OLTracking_ResumeLoan','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.OLTracking_ResumeLoan AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.OLTracking_ResumeLoan
    @AssignmentID bigint,
    @UserID int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @ItemID bigint,@ProcessID int,@Now datetime=GETDATE(),@HoldStart datetime,@HoldSeconds bigint,
                @LockResult int,@LockResource nvarchar(255)=N'OLTracking_InProcess_User_'+CONVERT(nvarchar(20),@UserID);
        EXEC @LockResult=sys.sp_getapplock @Resource=@LockResource,@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
        IF @LockResult<0 THROW 50132,'Unable to verify the active loan. Please try again.',1;

        SELECT @ItemID=a.ItemID,@ProcessID=a.ProcessID
        FROM dbo.OLTracking_Assignment a WITH(UPDLOCK,HOLDLOCK)
        WHERE a.AssignmentID=@AssignmentID AND a.UserID=@UserID AND a.IsCurrent=1 AND a.AssignmentStatus='Hold';
        IF @ItemID IS NULL THROW 50125,'Held assignment was not found.',1;
        IF EXISTS(SELECT 1 FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
                  WHERE UserID=@UserID AND IsCurrent=1 AND AssignmentStatus='In Process')
            THROW 50132,'Another loan is already in process.',1;

        SELECT TOP 1 @HoldStart=HoldStartDate FROM dbo.OLTracking_HoldPeriod WITH(UPDLOCK,HOLDLOCK)
        WHERE AssignmentID=@AssignmentID AND ResumeDate IS NULL ORDER BY HoldPeriodID DESC;
        IF @HoldStart IS NULL SELECT @HoldStart=HoldDate FROM dbo.OLTracking_Assignment WHERE AssignmentID=@AssignmentID;
        SET @HoldSeconds=CASE WHEN @HoldStart IS NULL THEN 0 ELSE DATEDIFF(second,@HoldStart,@Now) END;
        UPDATE dbo.OLTracking_HoldPeriod SET ResumeDate=@Now,HoldSeconds=@HoldSeconds,ResumedBy=@UserID
        WHERE AssignmentID=@AssignmentID AND ResumeDate IS NULL;
        UPDATE dbo.OLTracking_Assignment SET AssignmentStatus='In Process',StartedDate=ISNULL(StartedDate,@Now),HoldDate=NULL,
            HoldTATSeconds=ISNULL(HoldTATSeconds,0)+@HoldSeconds,LastRemark='Resumed',UpdatedBy=@UserID,UpdatedDate=@Now
        WHERE AssignmentID=@AssignmentID;
        UPDATE dbo.OLTracking_Item SET ItemStatus='Allocated',CurrentProcessID=@ProcessID,UpdatedBy=@UserID,UpdatedDate=@Now WHERE ItemID=@ItemID;
        INSERT dbo.OLTracking_StatusHistory(AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
        VALUES(@AssignmentID,'Hold','In Process','Resumed',@UserID);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK TRANSACTION; THROW; END CATCH
END;
GO

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.OLTracking_Assignment') AND name='UX_OLTracking_Assignment_OneInProcessPerUser')
   AND NOT EXISTS
   (
       SELECT UserID FROM dbo.OLTracking_Assignment
       WHERE IsCurrent=1 AND AssignmentStatus='In Process'
       GROUP BY UserID HAVING COUNT(1)>1
   )
BEGIN
    CREATE UNIQUE INDEX UX_OLTracking_Assignment_OneInProcessPerUser
        ON dbo.OLTracking_Assignment(UserID)
        WHERE IsCurrent=1 AND AssignmentStatus='In Process';
END;
GO
