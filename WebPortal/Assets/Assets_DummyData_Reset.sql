/*
  DESTRUCTIVE DEMO RESET FOR THE NEW ASSET INVENTORY MODULE.
  This deletes data from the new dbo.Asset* / dbo.Assets* inventory tables and inserts linked Admin + IT samples.
  It does not touch the legacy dbo.Asset, dbo.AssetAllocation, dbo.AssetType or dbo.AssetStatus tables.
  Set @ConfirmReset=1 deliberately before execution.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @ConfirmReset BIT=0;
IF @ConfirmReset<>1 BEGIN RAISERROR('Set @ConfirmReset=1 before running this destructive demo reset.',16,1); RETURN; END;

IF OBJECT_ID('dbo.AssetUserCategoryAccess','U') IS NULL
BEGIN
    RAISERROR('Run Assets/AssetCategoryAccess_Setup.sql first.',16,1);
    RETURN;
END;

DECLARE @Branch1 INT=(SELECT TOP 1 BranchID FROM dbo.Branch WHERE ISNULL(IsDelete,0)=0 ORDER BY BranchID);
DECLARE @Branch2 INT=(SELECT TOP 1 BranchID FROM dbo.Branch WHERE ISNULL(IsDelete,0)=0 AND BranchID<>@Branch1 ORDER BY BranchID);
IF @Branch1 IS NULL SET @Branch1=1;
IF @Branch2 IS NULL SET @Branch2=@Branch1;
SET @Branch1=2
set @Branch2=5
DECLARE @AdminDept INT=(SELECT TOP 1 DepartmentID FROM dbo.Department WHERE ISNULL(IsDelete,0)=0 AND DepartmentName LIKE '%Admin%' ORDER BY DepartmentID);
DECLARE @ITDept INT=(SELECT TOP 1 DepartmentID FROM dbo.Department WHERE ISNULL(IsDelete,0)=0 AND (DepartmentName LIKE '%IT%' OR DepartmentName LIKE '%Information Tech%') ORDER BY DepartmentID);
DECLARE @AdminUser BIGINT=(SELECT TOP 1 EmployeeID FROM dbo.EmployeeInfo WHERE ISNULL(IsDelete,0)=0 AND Department=@AdminDept ORDER BY EmployeeID);
DECLARE @ITUser BIGINT=(SELECT TOP 1 EmployeeID FROM dbo.EmployeeInfo WHERE ISNULL(IsDelete,0)=0 AND Department=@ITDept ORDER BY EmployeeID);
IF @AdminUser IS NULL SET @AdminUser=(SELECT TOP 1 EmployeeID FROM dbo.EmployeeInfo WHERE ISNULL(IsDelete,0)=0 ORDER BY EmployeeID);
IF @ITUser IS NULL SET @ITUser=(SELECT TOP 1 EmployeeID FROM dbo.EmployeeInfo WHERE ISNULL(IsDelete,0)=0 AND EmployeeID<>@AdminUser ORDER BY EmployeeID);
IF @ITUser IS NULL SET @ITUser=@AdminUser;

BEGIN TRANSACTION;

DELETE dbo.AssetUserCategoryAccess;
DELETE dbo.AssetReceiptItem;
DELETE dbo.AssetReceipt;
DELETE dbo.AssetPurchaseOrderTerm;
DELETE dbo.AssetPurchaseOrderItem;
DELETE dbo.AssetPurchaseOrder;
DELETE dbo.AssetVendorQuotationItem;
DELETE dbo.AssetVendorQuotation;
DELETE dbo.AssetPurchaseRequestItem;
DELETE dbo.AssetPurchaseRequest;
DELETE dbo.AssetApprovalLog;
DELETE dbo.AssetAuditTrail;
DELETE dbo.AssetDocument;
DELETE dbo.AssetImportDetail;
DELETE dbo.AssetImportLog;
DELETE dbo.AssetDisposal;
DELETE dbo.AssetMaintenance;
DELETE dbo.AssetsTransfer;
DELETE dbo.AssetsAllocation;
DELETE dbo.AssetsMaster;
DELETE dbo.AssetModelMaster;
DELETE dbo.AssetTypeMaster;
DELETE dbo.AssetBrandMaster;
DELETE dbo.AssetStatusMaster;
DELETE dbo.AssetVendorMaster;
DELETE dbo.AssetDisposalReasonMaster;
DELETE dbo.AssetCategoryMaster;

DECLARE @Categories TABLE(Code nvarchar(30),ID int);
INSERT dbo.AssetCategoryMaster(CategoryName,CategoryCode,Description,DepreciationApplicable,DefaultUsefulLifeInMonths,IsActive,IsDeleted,AddedBy,AddedDate)
OUTPUT inserted.CategoryCode,inserted.AssetCategoryID INTO @Categories
VALUES
('IT Equipment','IT-EQP','Computers, monitors and peripherals',1,36,1,0,@ITUser,GETDATE()),
('Network Equipment','NET-EQP','Network and communication equipment',1,48,1,0,@ITUser,GETDATE()),
('Software Licenses','SOFTWARE','Software subscriptions and licences',0,12,1,0,@ITUser,GETDATE()),
('Office Furniture','FURN','Administrative furniture',1,84,1,0,@AdminUser,GETDATE()),
('Facility Equipment','FACILITY','Office facility and utility equipment',1,60,1,0,@AdminUser,GETDATE()),
('Security Equipment','SECURITY','CCTV and access-control equipment',1,60,1,0,@AdminUser,GETDATE());

DECLARE @ITCat int=(SELECT ID FROM @Categories WHERE Code='IT-EQP'),@NetCat int=(SELECT ID FROM @Categories WHERE Code='NET-EQP'),@SoftCat int=(SELECT ID FROM @Categories WHERE Code='SOFTWARE'),@FurnitureCat int=(SELECT ID FROM @Categories WHERE Code='FURN'),@FacilityCat int=(SELECT ID FROM @Categories WHERE Code='FACILITY'),@SecurityCat int=(SELECT ID FROM @Categories WHERE Code='SECURITY');
DECLARE @Types TABLE(Code nvarchar(30),ID int);
INSERT dbo.AssetTypeMaster(AssetCategoryID,AssetTypeName,TypeCode,Description,RequiresSerialNumber,RequiresAssetTag,IsConsumable,IsActive,IsDeleted,AddedBy,AddedDate)
OUTPUT inserted.TypeCode,inserted.AssetTypeID INTO @Types
VALUES
(@ITCat,'Laptop','LAPTOP','Business laptop',1,1,0,1,0,@ITUser,GETDATE()),(@ITCat,'Desktop','DESKTOP','Desktop workstation',1,1,0,1,0,@ITUser,GETDATE()),(@ITCat,'Monitor','MONITOR','LED monitor',1,1,0,1,0,@ITUser,GETDATE()),
(@NetCat,'Network Switch','SWITCH','Managed network switch',1,1,0,1,0,@ITUser,GETDATE()),(@NetCat,'Wireless Access Point','WAP','Wireless access point',1,1,0,1,0,@ITUser,GETDATE()),(@SoftCat,'Software Subscription','SUBSCRIPTION','Annual software licence',0,1,0,1,0,@ITUser,GETDATE()),
(@FurnitureCat,'Office Chair','CHAIR','Ergonomic chair',0,1,0,1,0,@AdminUser,GETDATE()),(@FurnitureCat,'Office Desk','DESK','Office work desk',0,1,0,1,0,@AdminUser,GETDATE()),(@FacilityCat,'Air Conditioner','AC','Split air conditioner',1,1,0,1,0,@AdminUser,GETDATE()),(@SecurityCat,'CCTV Camera','CCTV','IP security camera',1,1,0,1,0,@AdminUser,GETDATE());

DECLARE @Brands TABLE(Code nvarchar(30),ID int);
INSERT dbo.AssetBrandMaster(BrandName,BrandCode,Description,IsActive,IsDeleted,AddedBy,AddedDate) OUTPUT inserted.BrandCode,inserted.AssetBrandID INTO @Brands
VALUES('Dell','DELL','IT hardware',1,0,@ITUser,GETDATE()),('Cisco','CISCO','Network hardware',1,0,@ITUser,GETDATE()),('Microsoft','MSFT','Software',1,0,@ITUser,GETDATE()),('Godrej','GODREJ','Furniture and security',1,0,@AdminUser,GETDATE()),('Daikin','DAIKIN','Facility equipment',1,0,@AdminUser,GETDATE());

DECLARE @Models TABLE(Code nvarchar(30),ID int);
INSERT dbo.AssetModelMaster(AssetBrandID,AssetTypeID,ModelName,ModelCode,ModelNumber,Description,IsActive,IsDeleted,AddedBy,AddedDate)
OUTPUT inserted.ModelCode,inserted.AssetModelID INTO @Models
VALUES
((SELECT ID FROM @Brands WHERE Code='DELL'),(SELECT ID FROM @Types WHERE Code='LAPTOP'),'Latitude 5440','LAT5440','5440','14-inch business laptop',1,0,@ITUser,GETDATE()),
((SELECT ID FROM @Brands WHERE Code='DELL'),(SELECT ID FROM @Types WHERE Code='MONITOR'),'P2422H','P2422H','P2422H','24-inch monitor',1,0,@ITUser,GETDATE()),
((SELECT ID FROM @Brands WHERE Code='CISCO'),(SELECT ID FROM @Types WHERE Code='SWITCH'),'CBS350','CBS350','CBS350-24T','24-port managed switch',1,0,@ITUser,GETDATE()),
((SELECT ID FROM @Brands WHERE Code='GODREJ'),(SELECT ID FROM @Types WHERE Code='CHAIR'),'Interio Motion','MOTION','MOTION-HB','Ergonomic high-back chair',1,0,@AdminUser,GETDATE()),
((SELECT ID FROM @Brands WHERE Code='DAIKIN'),(SELECT ID FROM @Types WHERE Code='AC'),'Inverter 1.5T','DAI15','FTKM50','Inverter split AC',1,0,@AdminUser,GETDATE()),
((SELECT ID FROM @Brands WHERE Code='GODREJ'),(SELECT ID FROM @Types WHERE Code='CCTV'),'SeeThru Pro','CCTVPRO','STP-4MP','4MP IP camera',1,0,@AdminUser,GETDATE());

DECLARE @Statuses TABLE(Code nvarchar(30),ID int);
INSERT dbo.AssetStatusMaster(StatusName,StatusCode,Description,IsAvailableForAllocation,IsActive,IsDeleted,AddedBy,AddedDate) OUTPUT inserted.StatusCode,inserted.AssetStatusID INTO @Statuses
VALUES('Available','AVAILABLE','Ready for allocation',1,1,0,@AdminUser,GETDATE()),('Allocated','ALLOCATED','Assigned to a user',0,1,0,@AdminUser,GETDATE()),('Under Maintenance','MAINTENANCE','Under repair',0,1,0,@AdminUser,GETDATE()),('In Transfer','TRANSFER','Being transferred',0,1,0,@AdminUser,GETDATE()),('Disposed','DISPOSED','Disposed asset',0,1,0,@AdminUser,GETDATE());

DECLARE @Vendors TABLE(Code nvarchar(30),ID int);
INSERT dbo.AssetVendorMaster(VendorName,VendorCode,Description,ContactPerson,EmailAddress,ContactNumber,FaxNumber,WebsiteURL,Address,City,StateName,CountryName,PostalCode,GSTNumber,PANNumber,AccountHolderName,BankName,BankBranchAddress,AccountType,AccountNumber,MICRCode,IFSCCode,PaymentTerms,IsActive,IsDeleted,AddedBy,AddedDate)
OUTPUT inserted.VendorCode,inserted.VendorID INTO @Vendors
VALUES('TechSource Solutions','TECHSRC','IT hardware and support vendor','Anil Kumar','sales@techsource.demo','9000000001','080-40000001','https://techsource.demo','Demo Tech Park','Bangalore','Karnataka','India','560001','29DEMO0001A1Z1','ABCDE0001A','TechSource Solutions','Demo Bank','MG Road, Bangalore','Current','000100010001','560000001','DEMO0000001','30 days',1,0,@ITUser,GETDATE()),('OfficeWorks India','OFFWORKS','Furniture and facility vendor','Meera Shah','sales@officeworks.demo','9000000002','080-40000002','https://officeworks.demo','Demo Industrial Area','Bangalore','Karnataka','India','560002','29DEMO0002A1Z1','ABCDE0002B','OfficeWorks India','Demo Bank','Indiranagar, Bangalore','Current','000200020002','560000002','DEMO0000002','45 days',1,0,@AdminUser,GETDATE());

DECLARE @Reasons TABLE(Code nvarchar(30),ID int);
INSERT dbo.AssetDisposalReasonMaster(ReasonName,ReasonCode,Description,IsActive,IsDeleted,AddedBy,AddedDate) OUTPUT inserted.ReasonCode,inserted.DisposalReasonID INTO @Reasons
VALUES('End of Useful Life','EOL','Useful life completed',1,0,@AdminUser,GETDATE()),('Beyond Economic Repair','BER','Repair is not economical',1,0,@AdminUser,GETDATE());

DECLARE @PRIT bigint,@PRAdmin bigint;
INSERT dbo.AssetPurchaseRequest(RequestNumber,RequestDate,RequestedBy,DepartmentID,BranchID,Priority,RequiredByDate,BusinessJustification,EstimatedAmount,ApprovalStatus,Status,Remarks,IsDeleted,AddedBy,AddedDate) VALUES('APR-DEMO-IT',DATEADD(day,-30,CAST(GETDATE() AS date)),@ITUser,@ITDept,@Branch1,'High',DATEADD(day,15,CAST(GETDATE() AS date)),'Laptop refresh for IT operations',180000,'Approved','Approved','IT sample request',0,@ITUser,GETDATE()); SET @PRIT=SCOPE_IDENTITY();
INSERT dbo.AssetPurchaseRequestItem(PurchaseRequestID,AssetCategoryID,AssetTypeID,PreferredBrandID,ItemDescription,TechnicalSpecification,RequiredQuantity,EstimatedUnitCost) VALUES(@PRIT,@ITCat,(SELECT ID FROM @Types WHERE Code='LAPTOP'),(SELECT ID FROM @Brands WHERE Code='DELL'),'Dell Latitude laptops','16GB RAM, 512GB SSD',2,90000);
INSERT dbo.AssetPurchaseRequest(RequestNumber,RequestDate,RequestedBy,DepartmentID,BranchID,Priority,RequiredByDate,BusinessJustification,EstimatedAmount,ApprovalStatus,Status,Remarks,IsDeleted,AddedBy,AddedDate) VALUES('APR-DEMO-ADMIN',DATEADD(day,-28,CAST(GETDATE() AS date)),@AdminUser,@AdminDept,@Branch1,'Normal',DATEADD(day,20,CAST(GETDATE() AS date)),'Ergonomic seating replacement',36000,'Approved','Approved','Admin sample request',0,@AdminUser,GETDATE()); SET @PRAdmin=SCOPE_IDENTITY();
INSERT dbo.AssetPurchaseRequestItem(PurchaseRequestID,AssetCategoryID,AssetTypeID,PreferredBrandID,ItemDescription,TechnicalSpecification,RequiredQuantity,EstimatedUnitCost) VALUES(@PRAdmin,@FurnitureCat,(SELECT ID FROM @Types WHERE Code='CHAIR'),(SELECT ID FROM @Brands WHERE Code='GODREJ'),'Ergonomic office chairs','High back with lumbar support',3,12000);

DECLARE @QIT bigint,@QAdmin bigint;
INSERT dbo.AssetVendorQuotation(QuotationNumber,VendorID,PurchaseRequestID,QuotationDate,ValidUntilDate,DeliveryPeriod,PaymentTerms,WarrantyTerms,SubTotal,DiscountAmount,TaxAmount,TotalQuotationValue,Status,Remarks,IsSelected,SelectionReason,IsDeleted,AddedBy,AddedDate) VALUES('QUO-DEMO-IT',(SELECT ID FROM @Vendors WHERE Code='TECHSRC'),@PRIT,DATEADD(day,-25,CAST(GETDATE() AS date)),DATEADD(day,30,CAST(GETDATE() AS date)),'7 days','30 days','3 years',180000,5000,31500,206500,'Selected','Best technical match',1,'Lowest compliant quotation',0,@ITUser,GETDATE()); SET @QIT=SCOPE_IDENTITY();
INSERT dbo.AssetVendorQuotationItem(QuotationID,AssetCategoryID,AssetTypeID,AssetBrandID,AssetModelID,ItemDescription,Quantity,UnitPrice,DiscountAmount,TaxPercentage,TaxAmount,TotalAmount,WarrantyPeriod,DeliveryTime) VALUES(@QIT,@ITCat,(SELECT ID FROM @Types WHERE Code='LAPTOP'),(SELECT ID FROM @Brands WHERE Code='DELL'),(SELECT ID FROM @Models WHERE Code='LAT5440'),'Dell Latitude 5440',2,90000,5000,18,31500,206500,'3 years','7 days');
INSERT dbo.AssetVendorQuotation(QuotationNumber,VendorID,PurchaseRequestID,QuotationDate,ValidUntilDate,DeliveryPeriod,PaymentTerms,WarrantyTerms,SubTotal,DiscountAmount,TaxAmount,TotalQuotationValue,Status,Remarks,IsSelected,SelectionReason,IsDeleted,AddedBy,AddedDate) VALUES('QUO-DEMO-ADMIN',(SELECT ID FROM @Vendors WHERE Code='OFFWORKS'),@PRAdmin,DATEADD(day,-24,CAST(GETDATE() AS date)),DATEADD(day,30,CAST(GETDATE() AS date)),'10 days','45 days','1 year',36000,0,6480,42480,'Selected','Approved furniture vendor',1,'Standard approved model',0,@AdminUser,GETDATE()); SET @QAdmin=SCOPE_IDENTITY();
INSERT dbo.AssetVendorQuotationItem(QuotationID,AssetCategoryID,AssetTypeID,AssetBrandID,AssetModelID,ItemDescription,Quantity,UnitPrice,DiscountAmount,TaxPercentage,TaxAmount,TotalAmount,WarrantyPeriod,DeliveryTime) VALUES(@QAdmin,@FurnitureCat,(SELECT ID FROM @Types WHERE Code='CHAIR'),(SELECT ID FROM @Brands WHERE Code='GODREJ'),(SELECT ID FROM @Models WHERE Code='MOTION'),'Godrej Interio Motion chair',3,12000,0,18,6480,42480,'1 year','10 days');

DECLARE @POIT bigint,@POAdmin bigint,@POITItem bigint,@POAdminItem bigint;
INSERT dbo.AssetPurchaseOrder(PurchaseOrderNumber,PurchaseOrderDate,VendorID,QuotationID,PurchaseRequestID,BillingAddress,ShippingAddress,BranchID,ExpectedDeliveryDate,PaymentTerms,CurrencyCode,SubTotal,DiscountAmount,TaxAmount,FreightCharges,OtherCharges,GrandTotal,ApprovalStatus,Status,Remarks,IsDeleted,AddedBy,AddedDate) VALUES('PO-DEMO-IT',DATEADD(day,-20,CAST(GETDATE() AS date)),(SELECT ID FROM @Vendors WHERE Code='TECHSRC'),@QIT,@PRIT,'Infinity IPS','Infinity IPS - IT',@Branch1,DATEADD(day,-13,CAST(GETDATE() AS date)),'30 days','INR',180000,5000,31500,0,0,206500,'Approved','Open','IT demo PO',0,@ITUser,GETDATE()); SET @POIT=SCOPE_IDENTITY();
INSERT dbo.AssetPurchaseOrderItem(PurchaseOrderID,AssetCategoryID,AssetTypeID,AssetBrandID,AssetModelID,ItemDescription,OrderedQuantity,ReceivedQuantity,UnitPrice,DiscountAmount,TaxPercentage,TaxAmount,TotalAmount,WarrantyPeriod) VALUES(@POIT,@ITCat,(SELECT ID FROM @Types WHERE Code='LAPTOP'),(SELECT ID FROM @Brands WHERE Code='DELL'),(SELECT ID FROM @Models WHERE Code='LAT5440'),'Dell Latitude 5440',2,2,90000,5000,18,31500,206500,'3 years'); SET @POITItem=SCOPE_IDENTITY();
INSERT dbo.AssetPurchaseOrderTerm(PurchaseOrderID,TermType,TermDescription,DisplayOrder) VALUES(@POIT,'Delivery','Deliver with serial-number list and warranty documents.',1);
INSERT dbo.AssetPurchaseOrder(PurchaseOrderNumber,PurchaseOrderDate,VendorID,QuotationID,PurchaseRequestID,BillingAddress,ShippingAddress,BranchID,ExpectedDeliveryDate,PaymentTerms,CurrencyCode,SubTotal,DiscountAmount,TaxAmount,FreightCharges,OtherCharges,GrandTotal,ApprovalStatus,Status,Remarks,IsDeleted,AddedBy,AddedDate) VALUES('PO-DEMO-ADMIN',DATEADD(day,-19,CAST(GETDATE() AS date)),(SELECT ID FROM @Vendors WHERE Code='OFFWORKS'),@QAdmin,@PRAdmin,'Infinity IPS','Infinity IPS - Admin',@Branch1,DATEADD(day,-9,CAST(GETDATE() AS date)),'45 days','INR',36000,0,6480,0,0,42480,'Approved','Open','Admin demo PO',0,@AdminUser,GETDATE()); SET @POAdmin=SCOPE_IDENTITY();
INSERT dbo.AssetPurchaseOrderItem(PurchaseOrderID,AssetCategoryID,AssetTypeID,AssetBrandID,AssetModelID,ItemDescription,OrderedQuantity,ReceivedQuantity,UnitPrice,DiscountAmount,TaxPercentage,TaxAmount,TotalAmount,WarrantyPeriod) VALUES(@POAdmin,@FurnitureCat,(SELECT ID FROM @Types WHERE Code='CHAIR'),(SELECT ID FROM @Brands WHERE Code='GODREJ'),(SELECT ID FROM @Models WHERE Code='MOTION'),'Godrej Interio Motion chair',3,3,12000,0,18,6480,42480,'1 year'); SET @POAdminItem=SCOPE_IDENTITY();
INSERT dbo.AssetPurchaseOrderTerm(PurchaseOrderID,TermType,TermDescription,DisplayOrder) VALUES(@POAdmin,'Installation','Vendor will assemble furniture at site.',1);

DECLARE @ReceiptIT bigint,@ReceiptAdmin bigint;
INSERT dbo.AssetReceipt(ReceiptNumber,PurchaseOrderID,VendorID,BranchID,ReceiptDate,InvoiceNumber,InvoiceDate,DeliveryChallanNumber,Status,Remarks,ReceivedBy,IsDeleted,AddedBy,AddedDate) VALUES('GRN-DEMO-IT',@POIT,(SELECT ID FROM @Vendors WHERE Code='TECHSRC'),@Branch1,DATEADD(day,-12,CAST(GETDATE() AS date)),'INV-IT-001',DATEADD(day,-13,CAST(GETDATE() AS date)),'DC-IT-001','Received','All units accepted',@ITUser,0,@ITUser,GETDATE()); SET @ReceiptIT=SCOPE_IDENTITY();
INSERT dbo.AssetReceiptItem(ReceiptID,PurchaseOrderItemID,OrderedQuantity,PreviouslyReceivedQuantity,CurrentReceivedQuantity,RejectedQuantity,PendingQuantity,ConditionOnReceipt,SerialNumbers,Remarks) VALUES(@ReceiptIT,@POITItem,2,0,2,0,0,'Good','DLL5440-001,DLL5440-002','Verified');
INSERT dbo.AssetReceipt(ReceiptNumber,PurchaseOrderID,VendorID,BranchID,ReceiptDate,InvoiceNumber,InvoiceDate,DeliveryChallanNumber,Status,Remarks,ReceivedBy,IsDeleted,AddedBy,AddedDate) VALUES('GRN-DEMO-ADMIN',@POAdmin,(SELECT ID FROM @Vendors WHERE Code='OFFWORKS'),@Branch1,DATEADD(day,-8,CAST(GETDATE() AS date)),'INV-ADM-001',DATEADD(day,-9,CAST(GETDATE() AS date)),'DC-ADM-001','Received','Furniture accepted',@AdminUser,0,@AdminUser,GETDATE()); SET @ReceiptAdmin=SCOPE_IDENTITY();
INSERT dbo.AssetReceiptItem(ReceiptID,PurchaseOrderItemID,OrderedQuantity,PreviouslyReceivedQuantity,CurrentReceivedQuantity,RejectedQuantity,PendingQuantity,ConditionOnReceipt,SerialNumbers,Remarks) VALUES(@ReceiptAdmin,@POAdminItem,3,0,3,0,0,'Good',NULL,'Assembled');

DECLARE @Assets TABLE(Tag nvarchar(100),ID bigint);
INSERT dbo.AssetsMaster(AssetCode,AssetTagNumber,SerialNumber,HostName,AssetCategoryID,AssetTypeID,AssetBrandID,AssetModelID,AssetDescription,VendorID,PurchaseOrderID,InvoiceNumber,InvoiceDate,PurchaseDate,PurchaseValue,TaxAmount,TotalPurchaseValue,WarrantyStartDate,WarrantyEndDate,CurrentBranchID,AssetStatusID,AssetCondition,AvailableForAllocation,Processor,RAM,Storage,OperatingSystem,Remarks,IsActive,IsDeleted,AddedBy,AddedDate)
OUTPUT inserted.AssetTagNumber,inserted.AssetID INTO @Assets
VALUES
('AST-IT-001','AST-IT-0001','DLL5440-001','IT-LAP-001',@ITCat,(SELECT ID FROM @Types WHERE Code='LAPTOP'),(SELECT ID FROM @Brands WHERE Code='DELL'),(SELECT ID FROM @Models WHERE Code='LAT5440'),'IT operations laptop',(SELECT ID FROM @Vendors WHERE Code='TECHSRC'),@POIT,'INV-IT-001',DATEADD(day,-13,CAST(GETDATE() AS date)),DATEADD(day,-12,CAST(GETDATE() AS date)),90000,16200,106200,DATEADD(day,-12,CAST(GETDATE() AS date)),DATEADD(year,3,GETDATE()),@Branch1,(SELECT ID FROM @Statuses WHERE Code='ALLOCATED'),'Good',0,'Intel Core i7','16 GB','512 GB SSD','Windows 11 Pro','IT demo',1,0,@ITUser,GETDATE()),
('AST-IT-002','AST-IT-0002','DLL5440-002','IT-LAP-002',@ITCat,(SELECT ID FROM @Types WHERE Code='LAPTOP'),(SELECT ID FROM @Brands WHERE Code='DELL'),(SELECT ID FROM @Models WHERE Code='LAT5440'),'Spare IT laptop',(SELECT ID FROM @Vendors WHERE Code='TECHSRC'),@POIT,'INV-IT-001',DATEADD(day,-13,CAST(GETDATE() AS date)),DATEADD(day,-12,CAST(GETDATE() AS date)),90000,16200,106200,DATEADD(day,-12,CAST(GETDATE() AS date)),DATEADD(year,3,GETDATE()),@Branch1,(SELECT ID FROM @Statuses WHERE Code='AVAILABLE'),'Good',1,'Intel Core i7','16 GB','512 GB SSD','Windows 11 Pro','IT demo',1,0,@ITUser,GETDATE()),
('AST-IT-003','AST-IT-0003','MON-001',NULL,@ITCat,(SELECT ID FROM @Types WHERE Code='MONITOR'),(SELECT ID FROM @Brands WHERE Code='DELL'),(SELECT ID FROM @Models WHERE Code='P2422H'),'IT monitor',(SELECT ID FROM @Vendors WHERE Code='TECHSRC'),NULL,'INV-OLD-IT',DATEADD(month,-6,GETDATE()),DATEADD(month,-6,GETDATE()),15000,2700,17700,DATEADD(month,-6,GETDATE()),DATEADD(year,2,GETDATE()),@Branch1,(SELECT ID FROM @Statuses WHERE Code='MAINTENANCE'),'Fair',0,NULL,NULL,NULL,NULL,'Maintenance sample',1,0,@ITUser,GETDATE()),
('AST-NET-001','AST-NET-0001','CBS350-001','CORE-SW-01',@NetCat,(SELECT ID FROM @Types WHERE Code='SWITCH'),(SELECT ID FROM @Brands WHERE Code='CISCO'),(SELECT ID FROM @Models WHERE Code='CBS350'),'Core managed switch',(SELECT ID FROM @Vendors WHERE Code='TECHSRC'),NULL,'INV-NET-001',DATEADD(month,-10,GETDATE()),DATEADD(month,-10,GETDATE()),65000,11700,76700,DATEADD(month,-10,GETDATE()),DATEADD(year,3,GETDATE()),@Branch1,(SELECT ID FROM @Statuses WHERE Code='AVAILABLE'),'Good',1,NULL,NULL,NULL,NULL,'Network demo',1,0,@ITUser,GETDATE()),
('AST-SW-001','AST-SW-0001','M365-001',NULL,@SoftCat,(SELECT ID FROM @Types WHERE Code='SUBSCRIPTION'),(SELECT ID FROM @Brands WHERE Code='MSFT'),NULL,'Microsoft 365 annual licence',(SELECT ID FROM @Vendors WHERE Code='TECHSRC'),NULL,'INV-SW-001',GETDATE(),GETDATE(),12000,2160,14160,GETDATE(),DATEADD(year,1,GETDATE()),@Branch1,(SELECT ID FROM @Statuses WHERE Code='ALLOCATED'),'Good',0,NULL,NULL,NULL,NULL,'Software demo',1,0,@ITUser,GETDATE()),
('AST-ADM-001','AST-ADM-0001','CHAIR-001',NULL,@FurnitureCat,(SELECT ID FROM @Types WHERE Code='CHAIR'),(SELECT ID FROM @Brands WHERE Code='GODREJ'),(SELECT ID FROM @Models WHERE Code='MOTION'),'Admin office chair',(SELECT ID FROM @Vendors WHERE Code='OFFWORKS'),@POAdmin,'INV-ADM-001',DATEADD(day,-9,GETDATE()),DATEADD(day,-8,GETDATE()),12000,2160,14160,DATEADD(day,-8,GETDATE()),DATEADD(year,1,GETDATE()),@Branch1,(SELECT ID FROM @Statuses WHERE Code='ALLOCATED'),'Good',0,NULL,NULL,NULL,NULL,'Admin demo',1,0,@AdminUser,GETDATE()),
('AST-ADM-002','AST-ADM-0002','CHAIR-002',NULL,@FurnitureCat,(SELECT ID FROM @Types WHERE Code='CHAIR'),(SELECT ID FROM @Brands WHERE Code='GODREJ'),(SELECT ID FROM @Models WHERE Code='MOTION'),'Admin office chair',(SELECT ID FROM @Vendors WHERE Code='OFFWORKS'),@POAdmin,'INV-ADM-001',DATEADD(day,-9,GETDATE()),DATEADD(day,-8,GETDATE()),12000,2160,14160,DATEADD(day,-8,GETDATE()),DATEADD(year,1,GETDATE()),@Branch1,(SELECT ID FROM @Statuses WHERE Code='AVAILABLE'),'Good',1,NULL,NULL,NULL,NULL,'Admin demo',1,0,@AdminUser,GETDATE()),
('AST-ADM-003','AST-ADM-0003','CHAIR-003',NULL,@FurnitureCat,(SELECT ID FROM @Types WHERE Code='CHAIR'),(SELECT ID FROM @Brands WHERE Code='GODREJ'),(SELECT ID FROM @Models WHERE Code='MOTION'),'Admin office chair',(SELECT ID FROM @Vendors WHERE Code='OFFWORKS'),@POAdmin,'INV-ADM-001',DATEADD(day,-9,GETDATE()),DATEADD(day,-8,GETDATE()),12000,2160,14160,DATEADD(day,-8,GETDATE()),DATEADD(year,1,GETDATE()),@Branch2,(SELECT ID FROM @Statuses WHERE Code='AVAILABLE'),'Good',1,NULL,NULL,NULL,NULL,'Admin demo',1,0,@AdminUser,GETDATE()),
('AST-FAC-001','AST-FAC-0001','DAI15-001',NULL,@FacilityCat,(SELECT ID FROM @Types WHERE Code='AC'),(SELECT ID FROM @Brands WHERE Code='DAIKIN'),(SELECT ID FROM @Models WHERE Code='DAI15'),'Conference room AC',(SELECT ID FROM @Vendors WHERE Code='OFFWORKS'),NULL,'INV-FAC-001',DATEADD(year,-1,GETDATE()),DATEADD(year,-1,GETDATE()),48000,8640,56640,DATEADD(year,-1,GETDATE()),DATEADD(year,2,GETDATE()),@Branch1,(SELECT ID FROM @Statuses WHERE Code='AVAILABLE'),'Good',1,NULL,NULL,NULL,NULL,'Facility demo',1,0,@AdminUser,GETDATE()),
('AST-SEC-001','AST-SEC-0001','CCTV-001','CAM-LOBBY-01',@SecurityCat,(SELECT ID FROM @Types WHERE Code='CCTV'),(SELECT ID FROM @Brands WHERE Code='GODREJ'),(SELECT ID FROM @Models WHERE Code='CCTVPRO'),'Lobby CCTV camera',(SELECT ID FROM @Vendors WHERE Code='OFFWORKS'),NULL,'INV-SEC-001',DATEADD(month,-8,GETDATE()),DATEADD(month,-8,GETDATE()),18500,3330,21830,DATEADD(month,-8,GETDATE()),DATEADD(year,2,GETDATE()),@Branch1,(SELECT ID FROM @Statuses WHERE Code='AVAILABLE'),'Good',1,NULL,NULL,NULL,NULL,'Security demo',1,0,@AdminUser,GETDATE());

DECLARE @AllocIT bigint,@AllocAdmin bigint;
INSERT dbo.AssetsAllocation(AllocationNumber,AssetID,AllocationType,EmployeeID,DepartmentID,BranchID,AllocationDate,ExpectedReturnDate,IssuedBy,ConditionAtAllocation,AccessoriesIssued,Purpose,Status,Remarks,IsDeleted,AddedBy,AddedDate) VALUES('ALL-DEMO-IT',(SELECT ID FROM @Assets WHERE Tag='AST-IT-0001'),'Employee',@ITUser,@ITDept,@Branch1,DATEADD(day,-7,CAST(GETDATE() AS date)),DATEADD(month,12,CAST(GETDATE() AS date)),@ITUser,'Good','Charger and bag','IT operations','Active','IT allocation',0,@ITUser,GETDATE()); SET @AllocIT=SCOPE_IDENTITY();
INSERT dbo.AssetsAllocation(AllocationNumber,AssetID,AllocationType,EmployeeID,DepartmentID,BranchID,AllocationDate,ExpectedReturnDate,IssuedBy,ConditionAtAllocation,Purpose,Status,Remarks,IsDeleted,AddedBy,AddedDate) VALUES('ALL-DEMO-ADMIN',(SELECT ID FROM @Assets WHERE Tag='AST-ADM-0001'),'Employee',@AdminUser,@AdminDept,@Branch1,DATEADD(day,-6,CAST(GETDATE() AS date)),NULL,@AdminUser,'Good','Administrative workstation','Active','Admin allocation',0,@AdminUser,GETDATE()); SET @AllocAdmin=SCOPE_IDENTITY();

INSERT dbo.AssetsTransfer(TransferNumber,AssetID,TransferType,FromBranchID,ToBranchID,TransferDate,ExpectedReceiptDate,TransferReason,RequestedBy,ApprovedBy,ApprovalDate,DispatchDate,ReceiptDate,CourierName,TrackingNumber,ConditionAtDispatch,ConditionAtReceipt,Status,Remarks,IsDeleted,AddedBy,AddedDate) VALUES('TRF-DEMO-ADM',(SELECT ID FROM @Assets WHERE Tag='AST-ADM-0003'),'Branch',@Branch1,@Branch2,DATEADD(day,-5,CAST(GETDATE() AS date)),DATEADD(day,-3,CAST(GETDATE() AS date)),'New admin seating',@AdminUser,@AdminUser,DATEADD(day,-5,GETDATE()),DATEADD(day,-4,GETDATE()),DATEADD(day,-3,GETDATE()),'Internal','INT-001','Good','Good','Received','Admin transfer',0,@AdminUser,GETDATE());
INSERT dbo.AssetMaintenance(RequestNumber,AssetID,ComplaintDate,ComplaintRaisedBy,ProblemDescription,Priority,AssignedTo,VendorID,ExpectedCompletionDate,Diagnosis,RepairAction,PartsReplaced,RepairCost,ServiceCharge,TaxAmount,TotalCost,WarrantyClaimed,Status,Remarks,IsDeleted,AddedBy,AddedDate) VALUES('MNT-DEMO-IT',(SELECT ID FROM @Assets WHERE Tag='AST-IT-0003'),DATEADD(day,-4,CAST(GETDATE() AS date)),@ITUser,'Display flickering','High',@ITUser,(SELECT ID FROM @Vendors WHERE Code='TECHSRC'),DATEADD(day,3,CAST(GETDATE() AS date)),'Power board issue','Board replacement planned','Power board',2500,500,540,3540,0,'Open','IT maintenance',0,@ITUser,GETDATE());
INSERT dbo.AssetDisposal(DisposalNumber,AssetID,DisposalRequestDate,RequestedBy,DisposalReasonID,CurrentBookValue,ProposedDisposalMethod,ApprovalStatus,DisposalDate,SaleValue,BuyerName,Status,Remarks,IsDeleted,AddedBy,AddedDate) VALUES('DSP-DEMO-ADM',(SELECT ID FROM @Assets WHERE Tag='AST-FAC-0001'),DATEADD(day,-2,CAST(GETDATE() AS date)),@AdminUser,(SELECT ID FROM @Reasons WHERE Code='EOL'),10000,'Sold','Pending',NULL,0,NULL,'Pending','Admin disposal sample',0,@AdminUser,GETDATE());

DECLARE @ImportIT bigint;
INSERT dbo.AssetImportLog(FileName,TotalRecords,SuccessRecords,FailedRecords,DuplicateRecords,Status,Remarks,AddedBy,AddedDate) VALUES('IT_Asset_Import_Demo.xlsx',3,2,1,0,'Completed With Errors','Demo import batch',@ITUser,GETDATE()); SET @ImportIT=SCOPE_IDENTITY();
INSERT dbo.AssetImportDetail(ImportID,RowNumber,AssetTagNumber,SerialNumber,IsValid,ErrorMessage) VALUES(@ImportIT,2,'AST-IT-0001','DLL5440-001',1,NULL),(@ImportIT,3,'AST-NET-0001','CBS350-001',1,NULL),(@ImportIT,4,'AST-IT-BAD-01',NULL,0,'Serial number is required.');
INSERT dbo.AssetApprovalLog(TransactionType,TransactionID,ApprovalLevel,ApprovalStatus,Remarks,ApprovedBy,ApprovedDate) VALUES('PurchaseRequest',@PRIT,1,'Approved','Demo IT approval',@ITUser,GETDATE()),('PurchaseRequest',@PRAdmin,1,'Approved','Demo Admin approval',@AdminUser,GETDATE());
INSERT dbo.AssetAuditTrail(ModuleName,TransactionType,TransactionID,ActionName,NewValue,Remarks,ActionBy,ActionDate) VALUES('Asset Inventory','Asset',(SELECT ID FROM @Assets WHERE Tag='AST-IT-0001'),'Insert','Demo IT asset created','Seed data',@ITUser,GETDATE()),('Asset Inventory','Asset',(SELECT ID FROM @Assets WHERE Tag='AST-ADM-0001'),'Insert','Demo Admin asset created','Seed data',@AdminUser,GETDATE());
INSERT dbo.AssetDocument(ReferenceType,ReferenceID,DocumentType,FileName,FilePath,FileExtension,IsDeleted,UploadedBy,UploadedDate) VALUES('Asset',(SELECT ID FROM @Assets WHERE Tag='AST-IT-0001'),'Invoice','Demo_IT_Invoice.pdf','~/Assets/Demo/Demo_IT_Invoice.pdf','.pdf',0,@ITUser,GETDATE()),('Asset',(SELECT ID FROM @Assets WHERE Tag='AST-ADM-0001'),'Invoice','Demo_Admin_Invoice.pdf','~/Assets/Demo/Demo_Admin_Invoice.pdf','.pdf',0,@AdminUser,GETDATE());

/* Profile marker + selected categories. These two users are now strictly segregated. */
INSERT dbo.AssetUserCategoryAccess(UserID,AssetCategoryID,IsActive,AddedBy,AddedDate) VALUES(@ITUser,NULL,1,@ITUser,GETDATE()),(@AdminUser,NULL,1,@AdminUser,GETDATE());
INSERT dbo.AssetUserCategoryAccess(UserID,AssetCategoryID,IsActive,AddedBy,AddedDate) VALUES(@ITUser,@ITCat,1,@ITUser,GETDATE()),(@ITUser,@NetCat,1,@ITUser,GETDATE()),(@ITUser,@SoftCat,1,@ITUser,GETDATE()),(@AdminUser,@FurnitureCat,1,@AdminUser,GETDATE()),(@AdminUser,@FacilityCat,1,@AdminUser,GETDATE()),(@AdminUser,@SecurityCat,1,@AdminUser,GETDATE());

COMMIT TRANSACTION;

SELECT 'Reset completed' Result,@AdminUser AdminDemoUser,@ITUser ITDemoUser,@Branch1 PrimaryBranch,@Branch2 SecondaryBranch;
SELECT c.CategoryName,a.UserID FROM dbo.AssetUserCategoryAccess a JOIN dbo.AssetCategoryMaster c ON c.AssetCategoryID=a.AssetCategoryID ORDER BY a.UserID,c.CategoryName;
