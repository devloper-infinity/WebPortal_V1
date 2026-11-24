/* Show Activity Master names in the Supervisor Inspection completed-task list. */
ALTER PROCEDURE dbo.usp_HK_GetLookups @EmployeeID int AS
BEGIN
 SET NOCOUNT ON;
 SELECT f.FloorID,f.FloorName,f.BranchID FROM dbo.HK_FloorMaster f WHERE f.IsActive=1 ORDER BY f.FloorNumber;
 SELECT StaffID,StaffName FROM dbo.HK_StaffMaster WHERE IsActive=1 ORDER BY StaffName;
 SELECT VendorID,VendorName FROM dbo.HK_VendorMaster WHERE IsActive=1 ORDER BY VendorName;
 SELECT ActivityID,ActivityName FROM dbo.HK_ActivityMaster WHERE IsActive=1 ORDER BY ActivityName;
 SELECT aa.AssignmentID,a.ActivityName FROM dbo.HK_ActivityAssignment aa JOIN dbo.HK_ActivityMaster a ON a.ActivityID=aa.ActivityID WHERE aa.IsActive=1 AND a.IsActive=1 ORDER BY aa.AssignmentID;
 SELECT ConsumableID,ItemName FROM dbo.HK_ConsumableMaster WHERE IsActive=1 ORDER BY ItemName;
END
GO
