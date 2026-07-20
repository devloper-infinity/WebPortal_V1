/*
    New Asset Inventory menu for MenuMaster1.
    The existing Service Desk / Asset Masters menu (9000 series) is not changed.
    Change @GroupId if this module should initially be assigned to another access group.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @GroupId INT = 5;

DECLARE @Menus TABLE
(
    MenuId INT PRIMARY KEY,
    MenuName VARCHAR(200),
    ParentMenuId INT,
    Url VARCHAR(500),
    SectionName VARCHAR(200),
    SortOrder INT
);

INSERT @Menus (MenuId, MenuName, ParentMenuId, Url, SectionName, SortOrder)
VALUES
(19000,'Asset Inventory',0,NULL,NULL,17),
(19100,'Workspace',19000,NULL,'Workspace',1),
(19101,'Asset Dashboard',19100,'../Assets/AssetDashboard.aspx',NULL,1),
(19102,'Register Asset',19100,'../Assets/AddAsset.aspx',NULL,2),
(19103,'Asset Register',19100,'../Assets/ViewAssets.aspx',NULL,3),
(19104,'Import Assets',19100,'../Assets/ImportAssets.aspx',NULL,4),
(19200,'Masters',19000,NULL,'Masters',2),
(19201,'Asset Category',19200,'../Assets/AssetCategoryMaster.aspx',NULL,1),
(19202,'Asset Type',19200,'../Assets/AssetTypeMaster.aspx',NULL,2),
(19203,'Asset Brand',19200,'../Assets/AssetBrandMaster.aspx',NULL,3),
(19204,'Asset Model',19200,'../Assets/AssetModelMaster.aspx',NULL,4),
(19205,'Asset Status',19200,'../Assets/AssetStatusMaster.aspx',NULL,5),
(19206,'Vendor Master',19200,'../Assets/VendorMaster.aspx',NULL,6),
(19207,'Disposal Reason',19200,'../Assets/DisposalReasonMaster.aspx',NULL,7),
(19208,'Category Access',19200,'../Assets/AssetCategoryAccessMaster.aspx',NULL,8),
(19209,'Employee IT Fields',19200,'../Assets/EmployeeITFieldMaster.aspx',NULL,9),
(19300,'Procurement',19000,NULL,'Procurement',3),
(19301,'Purchase Request',19300,'../Assets/AssetPurchaseRequest.aspx',NULL,1),
(19302,'Purchase Request Approval',19300,'../Assets/PurchaseRequestApproval.aspx',NULL,2),
(19303,'Vendor Quotations',19300,'../Assets/VendorQuotation.aspx',NULL,3),
(19304,'Quotation Comparison',19300,'../Assets/QuotationComparison.aspx',NULL,4),
(19305,'Create Purchase Order',19300,'../Assets/PurchaseOrder.aspx',NULL,5),
(19306,'View Purchase Orders',19300,'../Assets/ViewPurchaseOrders.aspx',NULL,6),
(19307,'Asset Receipt',19300,'../Assets/AssetReceipt.aspx',NULL,7),
(19400,'Inventory Operations',19000,NULL,'Inventory Operations',4),
(19401,'Asset Allocation',19400,'../Assets/AssetAllocation.aspx',NULL,1),
(19402,'Asset Return',19400,'../Assets/AssetReturn.aspx',NULL,2),
(19403,'Asset Transfer',19400,'../Assets/AssetTransfer.aspx',NULL,3),
(19404,'Transfer Approval',19400,'../Assets/TransferApproval.aspx',NULL,4),
(19405,'Transfer Receipt',19400,'../Assets/TransferReceipt.aspx',NULL,5),
(19406,'Asset Maintenance',19400,'../Assets/AssetMaintenance.aspx',NULL,6),
(19407,'Asset Disposal',19400,'../Assets/AssetDisposal.aspx',NULL,7),
(19408,'Disposal Approval',19400,'../Assets/DisposalApproval.aspx',NULL,8),
(19409,'Employee IT Details',19400,'../Assets/EmployeeITDetails.aspx',NULL,9),
(19500,'Reports',19000,NULL,'Reports',5),
(19501,'Asset Stock Report',19500,'../Assets/AssetStockReport.aspx',NULL,1),
(19502,'Employee Asset Report',19500,'../Assets/EmployeeAssetReport.aspx',NULL,2),
(19503,'Location-wise Asset Report',19500,'../Assets/LocationWiseAssetReport.aspx',NULL,3),
(19504,'Warranty Expiry Report',19500,'../Assets/WarrantyExpiryReport.aspx',NULL,4),
(19505,'Asset Purchase Report',19500,'../Assets/AssetPurchaseReport.aspx',NULL,5),
(19506,'Asset Disposal Report',19500,'../Assets/AssetDisposalReport.aspx',NULL,6),
(19507,'Maintenance Cost Report',19500,'../Assets/MaintenanceCostReport.aspx',NULL,7),
(19508,'Allocation History',19500,'../Assets/AssetAllocationHistory.aspx',NULL,8),
(19509,'Transfer History',19500,'../Assets/AssetTransferHistory.aspx',NULL,9),
(19510,'Maintenance History',19500,'../Assets/AssetMaintenanceHistory.aspx',NULL,10);

BEGIN TRANSACTION;

IF EXISTS
(
    SELECT 1
    FROM @Menus source
    INNER JOIN dbo.MenuMaster1 target ON target.MenuId = source.MenuId
    WHERE target.MenuName <> source.MenuName
)
    THROW 50001, 'One or more 19000-series MenuIds are already used by another menu.', 1;

UPDATE target
SET target.MenuName = source.MenuName,
    target.ParentMenuId = source.ParentMenuId,
    target.Url = source.Url,
    target.SectionName = source.SectionName,
    target.SortOrder = source.SortOrder
FROM dbo.MenuMaster1 target
INNER JOIN @Menus source ON source.MenuId = target.MenuId;

INSERT dbo.MenuMaster1 (MenuId, MenuName, ParentMenuId, Url, SectionName, SortOrder)
SELECT source.MenuId, source.MenuName, source.ParentMenuId, source.Url, source.SectionName, source.SortOrder
FROM @Menus source
WHERE NOT EXISTS (SELECT 1 FROM dbo.MenuMaster1 target WHERE target.MenuId = source.MenuId);

IF @GroupId IS NOT NULL
BEGIN
    INSERT dbo.GroupMenuMapping (GroupId, MenuId)
    SELECT @GroupId, source.MenuId
    FROM @Menus source
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.GroupMenuMapping mapping
        WHERE mapping.GroupId = @GroupId AND mapping.MenuId = source.MenuId
    );
END;

COMMIT TRANSACTION;

SELECT MenuId, MenuName, ParentMenuId, Url, SectionName, SortOrder
FROM dbo.MenuMaster1
WHERE MenuId BETWEEN 19000 AND 19999
ORDER BY ParentMenuId, SortOrder, MenuId;
