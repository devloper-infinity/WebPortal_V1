using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;

namespace WebPortal.Assets.Classes
{
    public sealed class AssetCategoryAccessService
    {
        private readonly AssetDbHelper db = new AssetDbHelper();

        private sealed class Snapshot
        {
            public bool Configured;
            public readonly Dictionary<string, HashSet<string>> Keys = new Dictionary<string, HashSet<string>>(StringComparer.OrdinalIgnoreCase);

            public void Add(string type, object value)
            {
                if (value == null || value == DBNull.Value) return;
                HashSet<string> values;
                if (!Keys.TryGetValue(type, out values)) Keys[type] = values = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                values.Add(Convert.ToString(value, CultureInfo.InvariantCulture));
            }

            public bool Contains(string type, object value)
            {
                HashSet<string> values;
                return value != null && value != DBNull.Value && Keys.TryGetValue(type, out values) &&
                    values.Contains(Convert.ToString(value, CultureInfo.InvariantCulture));
            }
        }

        private Snapshot Load(long userId)
        {
            const string sql = @"
SELECT 'Configured' KeyType, CAST(1 AS nvarchar(100)) KeyValue
WHERE EXISTS (SELECT 1 FROM dbo.AssetUserCategoryAccess WHERE UserID=@UserID AND AssetCategoryID IS NULL AND IsActive=1)
UNION ALL SELECT 'CategoryID',CONVERT(nvarchar(100),c.AssetCategoryID) FROM dbo.AssetUserCategoryAccess a JOIN dbo.AssetCategoryMaster c ON c.AssetCategoryID=a.AssetCategoryID WHERE a.UserID=@UserID AND a.IsActive=1 AND c.IsDeleted=0
UNION ALL SELECT 'CategoryName',c.CategoryName FROM dbo.AssetUserCategoryAccess a JOIN dbo.AssetCategoryMaster c ON c.AssetCategoryID=a.AssetCategoryID WHERE a.UserID=@UserID AND a.IsActive=1 AND c.IsDeleted=0
UNION ALL SELECT 'TypeID',CONVERT(nvarchar(100),t.AssetTypeID) FROM dbo.AssetTypeMaster t JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=t.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1 WHERE t.IsDeleted=0
UNION ALL SELECT 'AssetID',CONVERT(nvarchar(100),m.AssetID) FROM dbo.AssetsMaster m JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=m.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1 WHERE m.IsDeleted=0
UNION ALL SELECT 'AssetTag',m.AssetTagNumber FROM dbo.AssetsMaster m JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=m.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1 WHERE m.IsDeleted=0
UNION ALL SELECT 'AllocationID',CONVERT(nvarchar(100),x.AllocationID) FROM dbo.AssetsAllocation x JOIN dbo.AssetsMaster m ON m.AssetID=x.AssetID JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=m.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1
UNION ALL SELECT 'TransferID',CONVERT(nvarchar(100),x.TransferID) FROM dbo.AssetsTransfer x JOIN dbo.AssetsMaster m ON m.AssetID=x.AssetID JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=m.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1
UNION ALL SELECT 'MaintenanceID',CONVERT(nvarchar(100),x.MaintenanceID) FROM dbo.AssetMaintenance x JOIN dbo.AssetsMaster m ON m.AssetID=x.AssetID JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=m.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1
UNION ALL SELECT 'DisposalID',CONVERT(nvarchar(100),x.DisposalID) FROM dbo.AssetDisposal x JOIN dbo.AssetsMaster m ON m.AssetID=x.AssetID JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=m.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1
UNION ALL SELECT 'PurchaseRequestID',CONVERT(nvarchar(100),x.PurchaseRequestID) FROM dbo.AssetPurchaseRequestItem x JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=x.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1 GROUP BY x.PurchaseRequestID
UNION ALL SELECT 'QuotationID',CONVERT(nvarchar(100),x.QuotationID) FROM dbo.AssetVendorQuotationItem x JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=x.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1 GROUP BY x.QuotationID
UNION ALL SELECT 'PurchaseOrderID',CONVERT(nvarchar(100),x.PurchaseOrderID) FROM dbo.AssetPurchaseOrderItem x JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=x.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1 GROUP BY x.PurchaseOrderID
UNION ALL SELECT 'ReceiptID',CONVERT(nvarchar(100),r.ReceiptID) FROM dbo.AssetReceipt r JOIN dbo.AssetPurchaseOrderItem x ON x.PurchaseOrderID=r.PurchaseOrderID JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=x.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1 GROUP BY r.ReceiptID
UNION ALL SELECT 'ImportID',CONVERT(nvarchar(100),i.ImportID) FROM dbo.AssetImportLog i WHERE i.AddedBy=@UserID;";
            var snapshot = new Snapshot();
            try
            {
                var table = db.QueryText(sql, new SqlParameter("@UserID", userId));
                foreach (DataRow row in table.Rows)
                {
                    var type = Convert.ToString(row["KeyType"]);
                    if (type == "Configured") snapshot.Configured = true;
                    else snapshot.Add(type, row["KeyValue"]);
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number != 208) throw;
            }
            return snapshot;
        }

        public DataTable Filter(DataTable table, string hint, long userId)
        {
            if (table == null) return table;
            var access = Load(userId);
            if (!access.Configured) return table;
            var lookupKey = LookupKey(hint);
            for (var index = table.Rows.Count - 1; index >= 0; index--)
            {
                var row = table.Rows[index];
                bool? allowed = null;
                if (lookupKey != null && table.Columns.Contains("ID")) allowed = access.Contains(lookupKey, row["ID"]);
                else if (table.Columns.Contains("AssetCategoryID")) allowed = access.Contains("CategoryID", row["AssetCategoryID"]);
                else if (table.Columns.Contains("CategoryName")) allowed = access.Contains("CategoryName", row["CategoryName"]);
                else allowed = MatchEntityColumn(table, row, access);
                if (allowed == false) table.Rows.RemoveAt(index);
            }
            return table;
        }

        public DataSet Filter(DataSet set, string hint, long userId)
        {
            if (set == null) return set;
            foreach (DataTable table in set.Tables) Filter(table, hint, userId);
            return set;
        }

        private static bool? MatchEntityColumn(DataTable table, DataRow row, Snapshot access)
        {
            var columns = new[] { "AssetID", "AllocationID", "TransferID", "MaintenanceID", "DisposalID", "PurchaseRequestID", "QuotationID", "PurchaseOrderID", "ReceiptID", "ImportID" };
            foreach (var column in columns) if (table.Columns.Contains(column)) return access.Contains(column, row[column]);
            if (table.Columns.Contains("AssetTagNumber")) return access.Contains("AssetTag", row["AssetTagNumber"]);
            return null;
        }

        private static string LookupKey(string hint)
        {
            switch ((hint ?? string.Empty).ToLowerInvariant())
            {
                case "category": return "CategoryID";
                case "type": return "TypeID";
                case "asset": case "availableasset": case "availableassetbyshift": case "transferavailableasset": return "AssetID";
                case "activeallocation": case "allocation": case "return": return "AllocationID";
                case "transfer": return "TransferID";
                case "maintenance": return "MaintenanceID";
                case "disposal": return "DisposalID";
                case "purchaserequest": return "PurchaseRequestID";
                case "quotation": return "QuotationID";
                case "purchaseorder": return "PurchaseOrderID";
                case "receipt": return "ReceiptID";
                case "import": return "ImportID";
                default: return null;
            }
        }

        public void EnsureCategory(long userId, int categoryId)
        {
            var access = Load(userId);
            if (access.Configured && !access.Contains("CategoryID", categoryId)) throw new UnauthorizedAccessException("You do not have access to the selected asset category.");
        }

        public void EnsureEntity(long userId, string type, long id)
        {
            if (id <= 0) return;
            var access = Load(userId);
            var key = LookupKey(type);
            if (access.Configured && key != null && !access.Contains(key, id)) throw new UnauthorizedAccessException("You do not have access to this asset category record.");
        }

        public DataTable Users()
        {
            return db.QueryText(@"SELECT e.EmployeeID, LTRIM(RTRIM(ISNULL(e.Code,'')+' - '+ISNULL(e.FirstName,'')+' '+ISNULL(e.lastName,''))) EmployeeName, ISNULL(d.DepartmentName,'Unassigned') DepartmentName FROM dbo.EmployeeInfo e LEFT JOIN dbo.Department d ON d.DepartmentID=e.Department WHERE ISNULL(e.IsDelete,0)=0 ORDER BY d.DepartmentName,e.FirstName,e.lastName");
        }

        public DataTable UserCategories(long userId)
        {
            return db.QueryText(@"SELECT c.AssetCategoryID,c.CategoryName,c.CategoryCode,CAST(CASE WHEN a.AccessID IS NULL THEN 0 ELSE 1 END AS bit) Selected,CAST(CASE WHEN p.AccessID IS NULL THEN 0 ELSE 1 END AS bit) Configured FROM dbo.AssetCategoryMaster c LEFT JOIN dbo.AssetUserCategoryAccess a ON a.AssetCategoryID=c.AssetCategoryID AND a.UserID=@UserID AND a.IsActive=1 LEFT JOIN dbo.AssetUserCategoryAccess p ON p.UserID=@UserID AND p.AssetCategoryID IS NULL AND p.IsActive=1 WHERE c.IsDeleted=0 AND c.IsActive=1 ORDER BY c.CategoryName", new SqlParameter("@UserID", userId));
        }

        public void Save(long userId, IEnumerable<int> categoryIds, long changedBy)
        {
            var ids = (categoryIds ?? Enumerable.Empty<int>()).Distinct().ToList();
            var parameters = new List<SqlParameter> { new SqlParameter("@UserID", userId), new SqlParameter("@ChangedBy", changedBy) };
            var sql = "SET XACT_ABORT ON; BEGIN TRANSACTION; DELETE dbo.AssetUserCategoryAccess WHERE UserID=@UserID; INSERT dbo.AssetUserCategoryAccess(UserID,AssetCategoryID,IsActive,AddedBy,AddedDate) VALUES(@UserID,NULL,1,@ChangedBy,GETDATE());";
            if (ids.Count > 0)
            {
                var names = new List<string>();
                for (var index = 0; index < ids.Count; index++) { var name = "@C" + index; names.Add(name); parameters.Add(new SqlParameter(name, ids[index])); }
                sql += " INSERT dbo.AssetUserCategoryAccess(UserID,AssetCategoryID,IsActive,AddedBy,AddedDate) SELECT @UserID,AssetCategoryID,1,@ChangedBy,GETDATE() FROM dbo.AssetCategoryMaster WHERE AssetCategoryID IN (" + string.Join(",", names) + ") AND IsDeleted=0;";
            }
            sql += " COMMIT TRANSACTION;";
            db.ExecText(sql, parameters.ToArray());
        }
    }
}
