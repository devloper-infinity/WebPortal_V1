using System;
using System.Data;
using System.Data.SqlClient;

namespace WebPortal.Assets.Classes
{
    public sealed class AssetDAL
    {
        private readonly AssetDbHelper db = new AssetDbHelper();

        private static SqlParameter P(string name, object value)
        {
            return new SqlParameter(name, value ?? DBNull.Value);
        }

        public DataTable Lookup(string type, int? parentId = null)
        {
            if (string.Equals(type, "Company", StringComparison.OrdinalIgnoreCase))
                return db.QueryText("SELECT CompanyID ID,CompanyName Name FROM dbo.Company WHERE ISNULL(IsDelete,0)=0 ORDER BY CompanyName");
            if (string.Equals(type, "Employee", StringComparison.OrdinalIgnoreCase))
                return db.QueryText("SELECT EmployeeID ID,LTRIM(RTRIM(ISNULL(Code,'')+' - '+ISNULL(FirstName,'')+' '+ISNULL(lastName,''))) Name FROM dbo.EmployeeInfo WHERE ISNULL(IsDelete,0)=0 ORDER BY Code,FirstName,lastName");
            if (string.Equals(type, "Shift", StringComparison.OrdinalIgnoreCase))
            {
                var shifts = db.Query("usp_GetAllShift");
                if (shifts.Columns.Contains("ShiftID")) shifts.Columns["ShiftID"].ColumnName = "ID";
                if (shifts.Columns.Contains("ShiftTime")) shifts.Columns["ShiftTime"].ColumnName = "Name";
                return shifts;
            }
            if (string.Equals(type, "AvailableAssetByShift", StringComparison.OrdinalIgnoreCase))
                return db.QueryText(@"SELECT m.AssetID ID,
LTRIM(RTRIM(ISNULL(m.AssetTagNumber,'')+' - '+ISNULL(t.AssetTypeName,'')+
CASE WHEN ISNULL(m.SerialNumber,'')='' THEN '' ELSE ' - S/N: '+m.SerialNumber END+
CASE WHEN ISNULL(m.AssetDescription,'')='' THEN '' ELSE ' - '+m.AssetDescription END)) Name
FROM dbo.AssetsMaster m
INNER JOIN dbo.AssetTypeMaster t ON t.AssetTypeID=m.AssetTypeID
WHERE m.IsDeleted=0
AND (ISNULL(m.AvailableForAllocation,0)=1 OR EXISTS(SELECT 1 FROM dbo.AssetsAllocation aa WHERE aa.AssetID=m.AssetID AND aa.Status='Allocated' AND aa.ReturnDate IS NULL AND aa.IsDeleted=0))
AND NOT EXISTS(SELECT 1 FROM dbo.AssetsAllocation a WHERE a.AssetID=m.AssetID AND (a.ShiftID=@ShiftID OR a.ShiftID IS NULL) AND a.Status='Allocated' AND a.ReturnDate IS NULL AND a.IsDeleted=0)
ORDER BY m.AssetTagNumber", P("@ShiftID", parentId));
            if (string.Equals(type, "TransferAvailableAsset", StringComparison.OrdinalIgnoreCase))
                return db.QueryText(@"SELECT m.AssetID ID,m.CurrentBranchID BranchID,
LTRIM(RTRIM(ISNULL(t.AssetTypeName,'Unknown Type')+' - '+ISNULL(NULLIF(m.SerialNumber,''),'No Serial')+' - '+ISNULL(NULLIF(m.Barcode,''),'No Barcode'))) Name
FROM dbo.AssetsMaster m INNER JOIN dbo.AssetTypeMaster t ON t.AssetTypeID=m.AssetTypeID
WHERE m.IsDeleted=0 AND ISNULL(m.AvailableForAllocation,0)=1
ORDER BY t.AssetTypeName,m.SerialNumber,m.Barcode");
            if (string.Equals(type, "ActiveAllocation", StringComparison.OrdinalIgnoreCase))
                return db.QueryText(@"SELECT a.AllocationID ID,LTRIM(RTRIM(ISNULL(m.AssetTagNumber,'')+' - '+ISNULL(e.Code,'')+' '+ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,'')+' - '+ISNULL(a.ShiftName,'Legacy / Not Set'))) Name
FROM dbo.AssetsAllocation a INNER JOIN dbo.AssetsMaster m ON m.AssetID=a.AssetID LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.EmployeeID
WHERE a.IsDeleted=0 AND a.Status='Allocated' AND a.ReturnDate IS NULL ORDER BY m.AssetTagNumber,a.ShiftName");
            return db.Query("usp_Assets_Lookup", P("@Type", type), P("@ParentID", parentId));
        }

        public DataTable List(string type, long? id = null, int? branchId = null, string status = null, string search = null)
        {
            if (string.Equals(type, "Category", StringComparison.OrdinalIgnoreCase))
                return db.QueryText("SELECT c.AssetCategoryID ID,c.CompanyID,co.CompanyName,c.CategoryName Name,c.CategoryCode Code,c.Description,c.DepreciationApplicable,c.DefaultUsefulLifeInMonths,c.IsActive FROM dbo.AssetCategoryMaster c LEFT JOIN dbo.Company co ON co.CompanyID=c.CompanyID WHERE c.IsDeleted=0 AND (@ID IS NULL OR c.AssetCategoryID=@ID) ORDER BY co.CompanyName,c.CategoryName", P("@ID", id));
            if (string.Equals(type, "Type", StringComparison.OrdinalIgnoreCase))
                return db.QueryText("SELECT t.AssetTypeID ID,t.AssetCategoryID ParentID,c.CategoryName,t.AssetTypeName Name,t.TypeCode Code,t.Description,t.RequiresSerialNumber,t.RequiresAssetTag,t.IsConsumable,t.IsActive FROM dbo.AssetTypeMaster t INNER JOIN dbo.AssetCategoryMaster c ON c.AssetCategoryID=t.AssetCategoryID WHERE t.IsDeleted=0 AND (@ID IS NULL OR t.AssetTypeID=@ID) ORDER BY c.CategoryName,t.AssetTypeName", P("@ID", id));
            if (string.Equals(type, "Brand", StringComparison.OrdinalIgnoreCase))
                return db.QueryText("SELECT AssetBrandID ID,BrandName Name,BrandCode Code,Description,IsActive FROM dbo.AssetBrandMaster WHERE IsDeleted=0 AND (@ID IS NULL OR AssetBrandID=@ID) ORDER BY BrandName", P("@ID", id));
            if (string.Equals(type, "Status", StringComparison.OrdinalIgnoreCase))
                return db.QueryText("SELECT AssetStatusID ID,StatusName Name,StatusCode Code,Description,IsAvailableForAllocation,IsActive FROM dbo.AssetStatusMaster WHERE IsDeleted=0 AND (@ID IS NULL OR AssetStatusID=@ID) ORDER BY StatusName", P("@ID", id));
            if (string.Equals(type, "DisposalReason", StringComparison.OrdinalIgnoreCase))
                return db.QueryText("SELECT DisposalReasonID ID,ReasonName Name,ReasonCode Code,Description,IsActive FROM dbo.AssetDisposalReasonMaster WHERE IsDeleted=0 AND (@ID IS NULL OR DisposalReasonID=@ID) ORDER BY ReasonName", P("@ID", id));
            if (string.Equals(type, "Vendor", StringComparison.OrdinalIgnoreCase))
                return db.QueryText("SELECT VendorID ID,VendorName Name,VendorCode Code,Description,ContactPerson,ContactNumber PhoneNumber,EmailAddress,GSTNumber,PANNumber,FaxNumber,WebsiteURL,AccountHolderName,BankName,BankBranchAddress,AccountType,AccountNumber,MICRCode,IFSCCode,Address,IsActive FROM dbo.AssetVendorMaster WHERE IsDeleted=0 AND (@ID IS NULL OR VendorID=@ID) ORDER BY VendorName", P("@ID", id));
            if (string.Equals(type, "Allocation", StringComparison.OrdinalIgnoreCase))
                return db.QueryText("SELECT a.AllocationID,a.AllocationNumber,a.AssetID,m.AssetTagNumber,t.AssetTypeName,a.AllocationType,a.EmployeeID,LTRIM(RTRIM(ISNULL(e.Code,'')+' - '+ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))) EmployeeName,a.ShiftID,ISNULL(a.ShiftName,'Legacy / Not Set') ShiftName,b.BranchName,a.AllocationDate,a.ExpectedReturnDate,a.Status AllocationStatus,s.StatusName AssetStatusName FROM dbo.AssetsAllocation a INNER JOIN dbo.AssetsMaster m ON m.AssetID=a.AssetID INNER JOIN dbo.AssetTypeMaster t ON t.AssetTypeID=m.AssetTypeID LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.EmployeeID LEFT JOIN dbo.Branch b ON b.BranchID=a.BranchID LEFT JOIN dbo.AssetStatusMaster s ON s.AssetStatusID=m.AssetStatusID WHERE a.IsDeleted=0 AND (@ID IS NULL OR a.AllocationID=@ID) AND (@Status IS NULL OR a.Status=@Status) ORDER BY a.AllocationDate DESC,a.AllocationID DESC", P("@ID", id), P("@Status", status));
            if (string.Equals(type, "Transfer", StringComparison.OrdinalIgnoreCase))
                return db.QueryText(@"SELECT x.TransferID,x.TransferNumber,x.AssetID,m.AssetTagNumber,t.AssetTypeName,
x.FromBranchID,fb.BranchName FromBranchName,x.ToBranchID,tb.BranchName ToBranchName,x.TransferDate,x.ExpectedReceiptDate,
x.TransferReason,x.RequestedBy,x.ApprovedBy,x.ApprovalDate,x.DispatchDate,x.ReceiptDate,x.CourierName,x.TrackingNumber,
x.ConditionAtDispatch,x.ConditionAtReceipt,x.Status TransferStatus,x.Remarks
FROM dbo.AssetsTransfer x INNER JOIN dbo.AssetsMaster m ON m.AssetID=x.AssetID
INNER JOIN dbo.AssetTypeMaster t ON t.AssetTypeID=m.AssetTypeID LEFT JOIN dbo.Branch fb ON fb.BranchID=x.FromBranchID LEFT JOIN dbo.Branch tb ON tb.BranchID=x.ToBranchID
WHERE x.IsDeleted=0 AND (@ID IS NULL OR x.TransferID=@ID) AND (@Status IS NULL OR x.Status=@Status)
ORDER BY x.TransferDate DESC,x.TransferID DESC", P("@ID", id), P("@Status", status));
            return db.Query("usp_Assets_PageList", P("@Type", type), P("@ID", id), P("@BranchID", branchId), P("@Status", status), P("@Search", search));
        }

        public DataSet Detail(string type, long id)
        {
            return db.QuerySet("usp_Assets_Detail", P("@Type", type), P("@ID", id));
        }

        public string TransferStatus(long transferId)
        {
            var table = db.QueryText("SELECT Status FROM dbo.AssetsTransfer WHERE TransferID=@TransferID AND IsDeleted=0", P("@TransferID", transferId));
            return table.Rows.Count == 0 ? string.Empty : Convert.ToString(table.Rows[0]["Status"]);
        }

        public void NormalizeTransferDecision(long transferId, string status, long userId)
        {
            db.ExecText(@"UPDATE dbo.AssetsTransfer SET Status=@Status,
ApprovedBy=CASE WHEN @Status='Approved' THEN COALESCE(ApprovedBy,@UserID) ELSE ApprovedBy END,
ApprovalDate=CASE WHEN @Status='Approved' THEN COALESCE(ApprovalDate,GETDATE()) ELSE ApprovalDate END
WHERE TransferID=@TransferID AND IsDeleted=0", P("@Status", status), P("@UserID", userId), P("@TransferID", transferId));
        }

        public void NormalizeTransferDispatch(long transferId, string conditionAtDispatch)
        {
            db.ExecText(@"UPDATE dbo.AssetsTransfer SET Status='Dispatched',
DispatchDate=COALESCE(DispatchDate,GETDATE()),
ConditionAtDispatch=COALESCE(NULLIF(@ConditionAtDispatch,''),ConditionAtDispatch)
WHERE TransferID=@TransferID AND IsDeleted=0",
                P("@ConditionAtDispatch", conditionAtDispatch), P("@TransferID", transferId));
        }

        public DataTable ImportDetail(long id)
        {
            return db.QueryText("SELECT ImportDetailID,ImportID,RowNumber,AssetTagNumber,SerialNumber,IsValid,ErrorMessage FROM dbo.AssetImportDetail WHERE ImportID=@ID ORDER BY RowNumber,ImportDetailID", P("@ID", id));
        }

        public long SaveMaster(string type, MasterInput x, long userId)
        {
            var isVendor = string.Equals(type, "Vendor", StringComparison.OrdinalIgnoreCase);
            var id = Convert.ToInt64(db.Scalar("usp_Assets_SaveMaster",
                P("@MasterType", type), P("@ID", x.ID), P("@ParentID", x.ParentID), P("@Name", x.Name),
                P("@Code", x.Code), P("@Description", isVendor ? x.Address : x.Description), P("@IsActive", x.IsActive),
                P("@Flag1", x.Flag1), P("@Flag2", x.Flag2), P("@Flag3", x.Flag3), P("@Number1", x.Number1),
                P("@Extra1", isVendor ? x.ContactPerson : x.Extra1), P("@Extra2", isVendor ? x.EmailAddress : x.Extra2), P("@Extra3", isVendor ? x.PhoneNumber : x.Extra3), P("@Extra4", x.Extra4),
                P("@UserID", userId)));
            if (string.Equals(type, "Category", StringComparison.OrdinalIgnoreCase))
                db.ExecText("UPDATE dbo.AssetCategoryMaster SET CompanyID=@CompanyID WHERE AssetCategoryID=@ID", P("@CompanyID", x.CompanyID), P("@ID", id));
            if (isVendor)
                db.ExecText("UPDATE dbo.AssetVendorMaster SET Description=@Description,Address=@Address,ContactPerson=@ContactPerson,ContactNumber=@PhoneNumber,EmailAddress=@EmailAddress,GSTNumber=@GSTNumber,PANNumber=@PANNumber,FaxNumber=@FaxNumber,WebsiteURL=@WebsiteURL,AccountHolderName=@AccountHolderName,BankName=@BankName,BankBranchAddress=@BankBranchAddress,AccountType=@AccountType,AccountNumber=@AccountNumber,MICRCode=@MICRCode,IFSCCode=@IFSCCode WHERE VendorID=@ID",
                    P("@Description", x.Description), P("@Address", x.Address), P("@ContactPerson", x.ContactPerson), P("@PhoneNumber", x.PhoneNumber), P("@EmailAddress", x.EmailAddress), P("@GSTNumber", x.GSTNumber), P("@PANNumber", x.PANNumber), P("@FaxNumber", x.FaxNumber), P("@WebsiteURL", x.WebsiteURL), P("@AccountHolderName", x.AccountHolderName), P("@BankName", x.BankName), P("@BankBranchAddress", x.BankBranchAddress), P("@AccountType", x.AccountType), P("@AccountNumber", x.AccountNumber), P("@MICRCode", x.MICRCode), P("@IFSCCode", x.IFSCCode), P("@ID", id));
            return id;
        }

        public long SaveAsset(AssetInput x, long userId)
        {
            return Convert.ToInt64(db.Scalar("usp_Assets_SaveAsset",
                P("@AssetID", x.AssetID), P("@AssetCode", x.AssetCode), P("@AssetTagNumber", x.AssetTagNumber),
                P("@Barcode", x.Barcode), P("@QRCode", x.QRCode), P("@SerialNumber", x.SerialNumber),
                P("@IMEINumber", x.IMEINumber), P("@HostName", x.HostName), P("@AssetCategoryID", x.AssetCategoryID),
                P("@AssetTypeID", x.AssetTypeID), P("@AssetBrandID", x.AssetBrandID), P("@AssetModelID", x.AssetModelID),
                P("@AssetDescription", x.AssetDescription), P("@VendorID", x.VendorID), P("@InvoiceNumber", x.InvoiceNumber),
                P("@InvoiceDate", x.InvoiceDate), P("@PurchaseDate", x.PurchaseDate), P("@PurchaseValue", x.PurchaseValue),
                P("@WarrantyStartDate", x.WarrantyStartDate), P("@WarrantyEndDate", x.WarrantyEndDate),
                P("@CurrentBranchID", x.CurrentBranchID), P("@AssetStatusID", x.AssetStatusID),
                P("@AssetCondition", x.AssetCondition), P("@Processor", x.Processor), P("@RAM", x.RAM),
                P("@Storage", x.Storage), P("@OperatingSystem", x.OperatingSystem), P("@IPAddress", x.IPAddress),
                P("@MACAddress", x.MACAddress), P("@Accessories", x.Accessories), P("@Remarks", x.Remarks),
                P("@UserID", userId)));
        }

        public long SaveXml(string procedure, string xml, long userId)
        {
            var xmlParameter = new SqlParameter("@Xml", SqlDbType.Xml) { Value = string.IsNullOrWhiteSpace(xml) ? (object)DBNull.Value : xml };
            return Convert.ToInt64(db.Scalar(procedure, xmlParameter, P("@UserID", userId)));
        }

        public void Action(string type, long id, string action, string remarks, long userId)
        {
            db.Exec("usp_Assets_Action", P("@Type", type), P("@ID", id), P("@Action", action), P("@Remarks", remarks), P("@UserID", userId));
        }

        public DataTable Report(string type, int? branchId, DateTime? fromDate, DateTime? toDate)
        {
            if (string.Equals(type, "EmployeeAsset", StringComparison.OrdinalIgnoreCase))
                return db.QueryText(@"SELECT a.AllocationID,a.AssetID,a.EmployeeID,LTRIM(RTRIM(ISNULL(e.Code,'')+' - '+ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))) EmployeeName,
m.AssetTagNumber,t.AssetTypeName,br.BrandName,mo.ModelName,a.ShiftName,a.AllocationDate,a.ExpectedReturnDate,ast.StatusName AllocationStatus,b.BranchName
FROM dbo.AssetsAllocation a INNER JOIN dbo.AssetsMaster m ON m.AssetID=a.AssetID
INNER JOIN dbo.AssetTypeMaster t ON t.AssetTypeID=m.AssetTypeID Left Outer Join dbo.AssetStatusMaster ast ON ast.AssetStatusID=m.AssetStatusID LEFT JOIN dbo.AssetBrandMaster br ON br.AssetBrandID=m.AssetBrandID
LEFT JOIN dbo.AssetModelMaster mo ON mo.AssetModelID=m.AssetModelID LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.EmployeeID LEFT JOIN dbo.Branch b ON b.BranchID=a.BranchID
WHERE a.IsDeleted=0 AND (@BranchID IS NULL OR a.BranchID=@BranchID) AND (@FromDate IS NULL OR a.AllocationDate>=@FromDate) AND (@ToDate IS NULL OR a.AllocationDate<DATEADD(day,1,@ToDate))
ORDER BY e.Code,a.AllocationDate DESC", P("@BranchID", branchId), P("@FromDate", fromDate), P("@ToDate", toDate));
            if (string.Equals(type, "AllocationHistory", StringComparison.OrdinalIgnoreCase))
                return db.QueryText(@"SELECT a.AllocationID,a.AllocationNumber,a.AssetID,m.AssetTagNumber,a.EmployeeID,LTRIM(RTRIM(ISNULL(e.Code,'')+' - '+ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))) EmployeeName,
a.AllocationType,ISNULL(a.ShiftName,'Legacy / Not Set') ShiftName,b.BranchName,a.AllocationDate,a.ExpectedReturnDate,a.ReturnDate,a.Status AllocationStatus
FROM dbo.AssetsAllocation a INNER JOIN dbo.AssetsMaster m ON m.AssetID=a.AssetID LEFT JOIN dbo.EmployeeInfo e ON e.EmployeeID=a.EmployeeID LEFT JOIN dbo.Branch b ON b.BranchID=a.BranchID
WHERE a.IsDeleted=0 AND (@BranchID IS NULL OR a.BranchID=@BranchID) AND (@FromDate IS NULL OR a.AllocationDate>=@FromDate) AND (@ToDate IS NULL OR a.AllocationDate<DATEADD(day,1,@ToDate))
ORDER BY a.AllocationDate DESC,a.AllocationID DESC", P("@BranchID", branchId), P("@FromDate", fromDate), P("@ToDate", toDate));
            return db.Query("usp_Assets_Report", P("@Type", type), P("@BranchID", branchId), P("@FromDate", fromDate), P("@ToDate", toDate));
        }

        public void ReconcileAllocationAvailability(long allocationId, long userId)
        {
            db.ExecText(@"DECLARE @AssetID BIGINT=(SELECT AssetID FROM dbo.AssetsAllocation WHERE AllocationID=@AllocationID);
UPDATE m SET AvailableForAllocation=CASE WHEN EXISTS(SELECT 1 FROM dbo.AssetsAllocation a WHERE a.AssetID=m.AssetID AND a.Status='Allocated' AND a.ReturnDate IS NULL AND a.IsDeleted=0) THEN 0 ELSE 1 END,
CurrentEmployeeID=(SELECT TOP 1 a.EmployeeID FROM dbo.AssetsAllocation a WHERE a.AssetID=m.AssetID AND a.Status='Allocated' AND a.ReturnDate IS NULL AND a.IsDeleted=0 ORDER BY a.AllocationID DESC),UpdatedBy=@UserID,UpdatedDate=GETDATE()
FROM dbo.AssetsMaster m WHERE m.AssetID=@AssetID;", P("@AllocationID", allocationId), P("@UserID", userId));
        }
    }
}
