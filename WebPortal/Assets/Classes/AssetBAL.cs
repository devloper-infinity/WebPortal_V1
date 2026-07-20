using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.Web;

namespace WebPortal.Assets.Classes
{
    public sealed class AssetBAL
    {
        private readonly AssetDAL d = new AssetDAL();
        private readonly AssetCategoryAccessService categoryAccess = new AssetCategoryAccessService();

        private static long CurrentUserID
        {
            get
            {
                long userId;
                return HttpContext.Current != null && HttpContext.Current.User != null &&
                    long.TryParse(HttpContext.Current.User.Identity.Name, out userId) ? userId : 0;
            }
        }

        public static List<Dictionary<string, object>> Rows(DataTable table)
        {
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow row in table.Rows)
            {
                var item = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                    item[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
                rows.Add(item);
            }
            return rows;
        }

        public static object Sets(DataSet dataSet)
        {
            var result = new List<object>();
            foreach (DataTable table in dataSet.Tables)
                result.Add(Rows(table));
            return result;
        }

        public DataTable Lookup(string type, int? parentId = null) { return categoryAccess.Filter(d.Lookup(type, parentId), type, CurrentUserID); }
        public DataTable List(string type, long? id = null, int? branchId = null, string status = null, string search = null) { return categoryAccess.Filter(d.List(type, id, branchId, status, search), type, CurrentUserID); }
        public DataSet Detail(string type, long id) { categoryAccess.EnsureEntity(CurrentUserID, type, id); return categoryAccess.Filter(d.Detail(type, id), type, CurrentUserID); }
        public DataTable Report(string type, int? branchId = null, DateTime? fromDate = null, DateTime? toDate = null) { return categoryAccess.Filter(d.Report(type, branchId, fromDate, toDate), type, CurrentUserID); }
        public DataTable ImportDetail(long id) { categoryAccess.EnsureEntity(CurrentUserID, "Import", id); return categoryAccess.Filter(d.ImportDetail(id), "Import", CurrentUserID); }

        public DataTable WithAssetIds(DataTable table)
        {
            if (table == null || !table.Columns.Contains("AssetTagNumber")) return table;
            if (!table.Columns.Contains("AssetID")) table.Columns.Add("AssetID", typeof(long));

            var assets = List("Asset");
            var ids = new Dictionary<string, long>(StringComparer.OrdinalIgnoreCase);
            foreach (DataRow asset in assets.Rows)
            {
                var tag = Convert.ToString(asset["AssetTagNumber"]);
                if (!string.IsNullOrWhiteSpace(tag)) ids[tag.Trim()] = Convert.ToInt64(asset["AssetID"]);
            }
            foreach (DataRow row in table.Rows)
            {
                long assetId;
                var tag = Convert.ToString(row["AssetTagNumber"]);
                if (!string.IsNullOrWhiteSpace(tag) && ids.TryGetValue(tag.Trim(), out assetId)) row["AssetID"] = assetId;
            }
            return table;
        }

        public DataSet PurchaseOrderDetail(long id)
        {
            var detail = Detail("PurchaseOrder", id);
            var summary = List("PurchaseOrder", id);
            if (detail.Tables.Count == 0 || detail.Tables[0].Rows.Count == 0 || summary.Rows.Count == 0) return detail;

            var header = detail.Tables[0];
            foreach (DataColumn column in summary.Columns)
            {
                if (!header.Columns.Contains(column.ColumnName))
                    header.Columns.Add(column.ColumnName, column.DataType);
                header.Rows[0][column.ColumnName] = summary.Rows[0][column.ColumnName];
            }
            return detail;
        }

        public DataSet Dashboard()
        {
            var assets = List("Asset");
            var statusCounts = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            var totalAssets = 0;
            var availableAssets = 0;
            var allocatedAssets = 0;
            var maintenanceAssets = 0;

            foreach (DataRow row in assets.Rows)
            {
                totalAssets++;
                var status = Convert.ToString(row["StatusName"]);
                if (string.IsNullOrWhiteSpace(status)) status = "Unspecified";

                int currentCount;
                statusCounts.TryGetValue(status, out currentCount);
                statusCounts[status] = currentCount + 1;

                var normalized = status.ToLowerInvariant();
                if (normalized.Contains("available") || normalized.Contains("stock")) availableAssets++;
                if (normalized.Contains("allocated") || normalized.Contains("assigned") || normalized.Contains("in use")) allocatedAssets++;
                if (normalized.Contains("maintenance") || normalized.Contains("repair") || normalized.Contains("service")) maintenanceAssets++;
            }

            var summary = new DataTable("Summary");
            summary.Columns.Add("Title", typeof(string));
            summary.Columns.Add("Value", typeof(int));
            summary.Rows.Add("Total Assets", totalAssets);
            summary.Rows.Add("Available", availableAssets);
            summary.Rows.Add("Allocated", allocatedAssets);
            summary.Rows.Add("Under Maintenance", maintenanceAssets);

            var statuses = new DataTable("Statuses");
            statuses.Columns.Add("StatusName", typeof(string));
            statuses.Columns.Add("Total", typeof(int));
            foreach (var item in statusCounts)
                statuses.Rows.Add(item.Key, item.Value);

            var activity = CreateActivityTable();
            AddActivityRows(activity, List("Allocation"), "Allocation", "AllocationNumber", "AllocationDate");
            AddActivityRows(activity, List("Transfer"), "Transfer", "TransferNumber", "TransferDate");
            AddActivityRows(activity, List("Maintenance"), "Maintenance", "RequestNumber", "ComplaintDate");

            var recentActivity = activity.Clone();
            var sorted = activity.Select(string.Empty, "ActivityDate DESC");
            for (var index = 0; index < sorted.Length && index < 15; index++)
                recentActivity.ImportRow(sorted[index]);

            var result = new DataSet();
            result.Tables.Add(summary);
            result.Tables.Add(statuses);
            result.Tables.Add(recentActivity);
            return result;
        }

        private static DataTable CreateActivityTable()
        {
            var table = new DataTable("RecentActivity");
            table.Columns.Add("ActivityType", typeof(string));
            table.Columns.Add("ReferenceNumber", typeof(string));
            table.Columns.Add("AssetTagNumber", typeof(string));
            table.Columns.Add("ActivityDate", typeof(DateTime));
            table.Columns.Add("Status", typeof(string));
            return table;
        }

        private static void AddActivityRows(DataTable target, DataTable source, string activityType, string referenceColumn, string dateColumn)
        {
            if (source == null || !source.Columns.Contains(referenceColumn) || !source.Columns.Contains(dateColumn)) return;

            foreach (DataRow row in source.Rows)
            {
                object activityDate = row[dateColumn];
                if (activityDate == DBNull.Value) continue;
                target.Rows.Add(
                    activityType,
                    Convert.ToString(row[referenceColumn]),
                    source.Columns.Contains("AssetTagNumber") ? Convert.ToString(row["AssetTagNumber"]) : string.Empty,
                    Convert.ToDateTime(activityDate, CultureInfo.InvariantCulture),
                    source.Columns.Contains("Status") ? Convert.ToString(row["Status"]) : string.Empty);
            }
        }

        public long SaveMaster(string type, MasterInput input, long userId)
        {
            if (input == null || string.IsNullOrWhiteSpace(input.Name))
                throw new ArgumentException("Name is required.");
            if (string.Equals(type, "Category", StringComparison.OrdinalIgnoreCase) && input.ID > 0) categoryAccess.EnsureCategory(userId, input.ID);
            if (string.Equals(type, "Type", StringComparison.OrdinalIgnoreCase) && input.ParentID.HasValue) categoryAccess.EnsureCategory(userId, input.ParentID.Value);
            return d.SaveMaster(type, input, userId);
        }

        public long SaveAsset(AssetInput input, long userId)
        {
            if (input == null || string.IsNullOrWhiteSpace(input.AssetTagNumber) || input.AssetCategoryID <= 0 || input.AssetTypeID <= 0 || input.CurrentBranchID <= 0)
                throw new ArgumentException("Asset tag, category, type and branch are required.");
            categoryAccess.EnsureCategory(userId, input.AssetCategoryID);
            if (input.AssetID > 0) categoryAccess.EnsureEntity(userId, "Asset", input.AssetID);
            return d.SaveAsset(input, userId);
        }

        public long Save<T>(string procedure, T input, long userId)
        {
            if (input == null) throw new ArgumentNullException("input");
            ValidateInputAccess(input, userId);
            return d.SaveXml(procedure, SerializeXml(input), userId);
        }

        public void Action(string type, long id, string action, string remarks, long userId)
        {
            categoryAccess.EnsureEntity(userId, type, id);
            d.Action(type, id, action, remarks, userId);
        }

        public string TransferStatus(long transferId, long userId)
        {
            categoryAccess.EnsureEntity(userId, "Transfer", transferId);
            return d.TransferStatus(transferId);
        }

        public void NormalizeTransferDecision(long transferId, string status, long userId)
        {
            categoryAccess.EnsureEntity(userId, "Transfer", transferId);
            d.NormalizeTransferDecision(transferId, status, userId);
        }

        public void NormalizeTransferDispatch(long transferId, string conditionAtDispatch, long userId)
        {
            categoryAccess.EnsureEntity(userId, "Transfer", transferId);
            d.NormalizeTransferDispatch(transferId, conditionAtDispatch);
        }

        public void ReconcileAllocationAvailability(long allocationId, long userId)
        {
            categoryAccess.EnsureEntity(userId, "Allocation", allocationId);
            d.ReconcileAllocationAvailability(allocationId, userId);
        }

        private void ValidateInputAccess<T>(T input, long userId)
        {
            var type = input.GetType();
            var asset = type.GetProperty("AssetID");
            if (asset != null) categoryAccess.EnsureEntity(userId, "Asset", Convert.ToInt64(asset.GetValue(input, null) ?? 0));
            var allocation = type.GetProperty("AllocationID");
            if (input is ReturnInput && allocation != null) categoryAccess.EnsureEntity(userId, "Allocation", Convert.ToInt64(allocation.GetValue(input, null) ?? 0));
            var assetIdsProperty = type.GetProperty("AssetIDs");
            var assetIds = assetIdsProperty == null ? null : assetIdsProperty.GetValue(input, null) as IEnumerable;
            if (assetIds != null) foreach (var assetId in assetIds) categoryAccess.EnsureEntity(userId, "Asset", Convert.ToInt64(assetId));
            foreach (var entity in new[] { "PurchaseRequestID", "QuotationID", "PurchaseOrderID" })
            {
                var property = type.GetProperty(entity);
                if (property == null) continue;
                var value = property.GetValue(input, null);
                if (value != null) categoryAccess.EnsureEntity(userId, entity.Substring(0, entity.Length - 2), Convert.ToInt64(value));
            }
            var itemsProperty = type.GetProperty("Items");
            var items = itemsProperty == null ? null : itemsProperty.GetValue(input, null) as IEnumerable;
            if (items == null) return;
            foreach (var item in items)
            {
                if (item == null) continue;
                var category = item.GetType().GetProperty("AssetCategoryID");
                if (category == null) continue;
                var value = category.GetValue(item, null);
                if (value != null) categoryAccess.EnsureCategory(userId, Convert.ToInt32(value));
            }
        }

        private static string SerializeXml<T>(T input)
        {
            var serializer = new XmlSerializer(typeof(T));
            var namespaces = new XmlSerializerNamespaces();
            namespaces.Add(string.Empty, string.Empty);

            var settings = new XmlWriterSettings
            {
                Encoding = new UTF8Encoding(false),
                Indent = false,
                OmitXmlDeclaration = true
            };

            using (var writer = new Utf8StringWriter())
            using (var xmlWriter = XmlWriter.Create(writer, settings))
            {
                serializer.Serialize(xmlWriter, input, namespaces);
                return writer.ToString();
            }
        }

        private sealed class Utf8StringWriter : StringWriter
        {
            public override Encoding Encoding { get { return Encoding.UTF8; } }
        }
    }
}
