/* Permanent Bulk Allocation upsert behavior for every project and process.
   Existing Pending assignments may be audited and moved; active work is protected. */
CREATE OR ALTER PROCEDURE dbo.OLTracking_BulkReassignPending
    @AssignmentID bigint,
    @TargetUserID int,
    @ManagerID int,
    @CapacityLimit int=3
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @FromUserID int,@ProjectID int,@ItemID bigint,@ProcessID int,
                @AssignmentStatus varchar(20),@Remark nvarchar(1000)=N'Bulk Allocation updated pending employee';

        SELECT @FromUserID=assignment.UserID,@ProjectID=assignment.ProjectID,
               @ItemID=assignment.ItemID,@ProcessID=assignment.ProcessID,
               @AssignmentStatus=assignment.AssignmentStatus
        FROM dbo.OLTracking_Assignment assignment WITH(UPDLOCK,HOLDLOCK)
        WHERE assignment.AssignmentID=@AssignmentID AND assignment.IsCurrent=1;

        IF @FromUserID IS NULL THROW 50128,'The assignment is no longer available.',1;
        IF @FromUserID=@TargetUserID
        BEGIN
            COMMIT TRANSACTION;
            SELECT 0 ReassignedCount;
            RETURN;
        END;
        IF @AssignmentStatus<>'Pending'
            THROW 50128,'Only Pending assignments can be updated through Bulk Allocation.',1;
        IF EXISTS(SELECT 1 FROM dbo.OLTracking_LoanHold WHERE ItemID=@ItemID AND ResumedDate IS NULL)
            THROW 50160,'This loan is on manager hold and cannot be reassigned.',1;
        IF NOT EXISTS(SELECT 1 FROM dbo.UserProjectConfiguration WHERE ProjectID=@ProjectID AND UserID=@TargetUserID)
           AND dbo.OLTracking_IsCreditOnshoreEmployee(@ProjectID,@TargetUserID)=0
            THROW 50131,'Selected user is not configured for this project.',1;
        IF @CapacityLimit>0 AND
           (SELECT COUNT(1) FROM dbo.OLTracking_Assignment WITH(UPDLOCK,HOLDLOCK)
            WHERE UserID=@TargetUserID AND IsCurrent=1 AND AssignmentStatus IN('Pending','In Process'))+1>@CapacityLimit
        BEGIN
            DECLARE @CapacityMessage nvarchar(2048)=N'Selected user can have a maximum of '
                +CONVERT(nvarchar(10),@CapacityLimit)+N' pending/in-process orders.';
            THROW 50110,@CapacityMessage,1;
        END;

        INSERT dbo.OLTracking_ReallocationHistory
            (AssignmentID,FromUserID,ToUserID,AssignmentStatus,Remark,ReallocatedBy)
        VALUES
            (@AssignmentID,@FromUserID,@TargetUserID,@AssignmentStatus,@Remark,@ManagerID);

        INSERT dbo.OLTracking_StatusHistory
            (AssignmentID,OldStatus,NewStatus,Remark,ChangedBy)
        VALUES
            (@AssignmentID,@AssignmentStatus,@AssignmentStatus,N'Reallocated: '+@Remark,@ManagerID);

        UPDATE dbo.OLTracking_Assignment
        SET UserID=@TargetUserID,LastRemark=N'Reallocated: '+@Remark,
            UpdatedBy=@ManagerID,UpdatedDate=GETDATE()
        WHERE AssignmentID=@AssignmentID AND IsCurrent=1 AND AssignmentStatus='Pending';

        COMMIT TRANSACTION;
        SELECT 1 ReassignedCount;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
