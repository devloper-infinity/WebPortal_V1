using System;
using System.Data;
using System.Data.SqlClient;

namespace WebPortal.App_Code.DAL
{
    public sealed class dalOLTrackingImport
    {
        public DataTable GetImportFlags(int projectId)
        {
            EnsureSchema();
            using (SqlCommand command = new SqlCommand(@"
SELECT f.FieldConfigId, CONVERT(bit, CASE WHEN i.FieldConfigId IS NULL THEN 0 ELSE 1 END) AS IsForImport
FROM dbo.WBT_ProjectTrackingFieldConfig f
LEFT JOIN dbo.OLTracking_ImportFieldConfiguration i
    ON i.FieldConfigId = f.FieldConfigId AND i.IsForImport = 1
WHERE f.ProjectID = @ProjectID AND f.IsDeleted = 0;"))
            {
                command.Connection = new SqlConnection(SQLHelper.ConnectionString);
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    DataTable result = new DataTable();
                    adapter.Fill(result);
                    return result;
                }
            }
        }

        public DataTable GetImportFields(int projectId)
        {
            EnsureSchema();
            using (SqlCommand command = new SqlCommand(@"
SELECT f.FieldConfigId, f.ProjectID, f.FieldName, f.DataType, f.OptionsText,
       f.IsRequired, f.DateFormat, f.DisplayOrder
FROM dbo.WBT_ProjectTrackingFieldConfig f
INNER JOIN dbo.OLTracking_ImportFieldConfiguration i
    ON i.FieldConfigId = f.FieldConfigId AND i.IsForImport = 1
WHERE f.ProjectID = @ProjectID
  AND f.IsDeleted = 0
ORDER BY f.DisplayOrder, f.FieldConfigId;"))
            {
                command.Connection = new SqlConnection(SQLHelper.ConnectionString);
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    DataTable result = new DataTable();
                    adapter.Fill(result);
                    return result;
                }
            }
        }

        public DataTable GetBillingParameterFields(int projectId)
        {
            using (SqlCommand command = new SqlCommand(@"
SELECT f.FieldConfigId, f.ProjectID, f.FieldName, f.DataType, f.OptionsText,
       f.IsRequired, f.DateFormat, f.DisplayOrder
FROM dbo.WBT_ProjectTrackingFieldConfig f
WHERE f.ProjectID = @ProjectID
  AND f.IsDeleted = 0
  AND ISNULL(f.IsBillingField, 0) = 0
  AND ISNULL(f.IsBillingParameter, 0) = 1
ORDER BY f.DisplayOrder, f.FieldConfigId;"))
            {
                command.Connection = new SqlConnection(SQLHelper.ConnectionString);
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    DataTable result = new DataTable();
                    adapter.Fill(result);
                    return result;
                }
            }
        }

        public DataTable GetTrackingReportFields(int projectId)
        {
            using (SqlCommand command = new SqlCommand(@"
SELECT f.FieldConfigId, f.ProjectID, f.FieldName, f.DataType, f.DateFormat, f.DisplayOrder
FROM dbo.WBT_ProjectTrackingFieldConfig f
WHERE f.ProjectID = @ProjectID
  AND f.IsDeleted = 0
  AND ISNULL(f.IsBillingField, 0) = 0
ORDER BY f.DisplayOrder, f.FieldConfigId;"))
            {
                command.Connection = new SqlConnection(SQLHelper.ConnectionString);
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    DataTable result = new DataTable();
                    adapter.Fill(result);
                    return result;
                }
            }
        }

        public DataTable GetTrackingReportRows(int projectId, DateTime fromDate, DateTime toDate)
        {
            using (SqlCommand command = new SqlCommand(@"
SELECT i.ItemID,
       i.DealNumber,
       i.ItemNumber,
       d.EntryDate,
       f.FieldConfigId,
       v.FieldValue
FROM dbo.OLTracking_Item i
INNER JOIN
(
    SELECT DISTINCT ItemID, EntryDate
    FROM dbo.OLTracking_ImportBatchItem
) d ON d.ItemID = i.ItemID
LEFT JOIN dbo.OLTracking_ImportItemValue v ON v.ItemID = i.ItemID
LEFT JOIN dbo.WBT_ProjectTrackingFieldConfig f
    ON f.FieldConfigId = v.FieldConfigId
   AND f.ProjectID = @ProjectID
   AND f.IsDeleted = 0
WHERE i.ProjectID = @ProjectID
  AND i.IsDeleted = 0
  AND d.EntryDate >= @FromDate
  AND d.EntryDate <= @ToDate
ORDER BY d.EntryDate, i.ItemID, f.DisplayOrder, f.FieldConfigId;"))
            {
                command.Connection = new SqlConnection(SQLHelper.ConnectionString);
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                command.Parameters.Add("@FromDate", SqlDbType.Date).Value = fromDate.Date;
                command.Parameters.Add("@ToDate", SqlDbType.Date).Value = toDate.Date;
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    DataTable result = new DataTable();
                    adapter.Fill(result);
                    return result;
                }
            }
        }

        public DataTable GetTrackingReportProcesses(int projectId, DateTime fromDate, DateTime toDate)
        {
            using (SqlCommand command = new SqlCommand(@"
SELECT i.ItemID,d.EntryDate,flow.ProcessID,flow.ProcessName,flow.StageNo,flow.IsMandatory,flow.CanSkip,
       flow.IsFinalProcess,COALESCE(a.AssignmentStatus,'Pending') AS ProcessStatus,
       ISNULL(a.IsCurrent,0) AS IsCurrent,a.AssignedDate,a.StartedDate,a.CompletedDate,a.ManualDurationMinutes,
       CASE WHEN a.AssignmentStatus='Completed'
            THEN COALESCE(NULLIF(completedUser.UserName,''),CONVERT(nvarchar(30),a.UserID),'')
            ELSE '' END AS CompletedBy,
       COALESCE(NULLIF(completedUser.UserName,''),CONVERT(nvarchar(30),a.UserID),'') AS ProcessUser
FROM dbo.OLTracking_Item i
INNER JOIN (SELECT DISTINCT ItemID,EntryDate FROM dbo.OLTracking_ImportBatchItem) d ON d.ItemID=i.ItemID
CROSS APPLY dbo.OLTracking_EffectiveProcessFlow(i.ProjectID,i.DealNumber) flow
OUTER APPLY
(
    SELECT TOP (1) assignment.AssignmentStatus,assignment.IsCurrent,assignment.UserID,assignment.AssignedDate,
           assignment.StartedDate,assignment.CompletedDate,assignment.ManualDurationMinutes
    FROM dbo.OLTracking_Assignment assignment
    WHERE assignment.ItemID=i.ItemID AND assignment.ProcessID=flow.ProcessID
    ORDER BY assignment.AssignmentID DESC
) a
OUTER APPLY
(
    SELECT TOP (1)
           COALESCE(NULLIF(configuration.PsuedoName,''),NULLIF(configuration.Code,''),NULLIF(employee.Code,'')) UserName
    FROM dbo.EmployeeInfo employee
    OUTER APPLY
    (
        SELECT TOP (1) employeeConfiguration.Code,employeeConfiguration.PsuedoName
        FROM dbo.EmployeeConfiguration employeeConfiguration
        WHERE employeeConfiguration.EmployeeID=employee.EmployeeID
          AND employeeConfiguration.Code=employee.Code
          AND employeeConfiguration.DataSource='ERP'
          AND employeeConfiguration.IsDelete=0
        ORDER BY employeeConfiguration.EmpConfigrationID DESC
    ) configuration
    WHERE employee.EmployeeID=a.UserID
) completedUser
WHERE i.ProjectID=@ProjectID AND i.IsDeleted=0 AND d.EntryDate BETWEEN @FromDate AND @ToDate
ORDER BY d.EntryDate,i.ItemID,flow.StageNo,flow.ProcessName;"))
            {
                command.Connection = new SqlConnection(SQLHelper.ConnectionString);
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                command.Parameters.Add("@FromDate", SqlDbType.Date).Value = fromDate.Date;
                command.Parameters.Add("@ToDate", SqlDbType.Date).Value = toDate.Date;
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    DataTable result = new DataTable(); adapter.Fill(result); return result;
                }
            }
        }

        public void SaveImportFlag(int fieldConfigId, int projectId, bool isForImport, int userId)
        {
            EnsureSchema();
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
IF @IsForImport = 1
BEGIN
    MERGE dbo.OLTracking_ImportFieldConfiguration AS target
    USING (SELECT @FieldConfigId AS FieldConfigId) AS source
       ON target.FieldConfigId = source.FieldConfigId
    WHEN MATCHED THEN UPDATE SET ProjectID = @ProjectID, IsForImport = 1,
         UpdatedBy = @UserID, UpdatedDate = GETDATE()
    WHEN NOT MATCHED THEN INSERT (FieldConfigId, ProjectID, IsForImport, AddedBy, AddedDate)
         VALUES (@FieldConfigId, @ProjectID, 1, @UserID, GETDATE());
END
ELSE
BEGIN
    DELETE FROM dbo.OLTracking_ImportFieldConfiguration WHERE FieldConfigId = @FieldConfigId;
END;", connection))
            {
                command.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = fieldConfigId;
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                command.Parameters.Add("@IsForImport", SqlDbType.Bit).Value = isForImport;
                command.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        public long ImportRows(int projectId, string originalFileName, DataTable values, int userId)
        {
            EnsureSchema();
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        long batchId;
                        int totalRows = values == null ? 0 : values.DefaultView.ToTable(true, "ImportRowNumber").Rows.Count;
                        using (SqlCommand batch = new SqlCommand(@"
INSERT dbo.OLTracking_ImportBatch
    (ProjectID, OriginalFileName, TotalRows, ImportedRows, RejectedRows, ImportStatus, ImportedBy, ImportedDate)
OUTPUT INSERTED.ImportBatchId
VALUES (@ProjectID, @FileName, @TotalRows, 0, 0, 'Processing', @UserID, GETDATE());", connection, transaction))
                        {
                            batch.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                            batch.Parameters.Add("@FileName", SqlDbType.NVarChar, 260).Value = originalFileName;
                            batch.Parameters.Add("@TotalRows", SqlDbType.Int).Value = totalRows;
                            batch.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                            batchId = Convert.ToInt64(batch.ExecuteScalar());
                        }

                        System.Collections.Generic.HashSet<string> importedItemNumbers = new System.Collections.Generic.HashSet<string>(StringComparer.OrdinalIgnoreCase);
                        DataView distinctRows = new DataView(values);
                        DataTable rowNumbers = distinctRows.ToTable(true, "ImportRowNumber", "EntryDate");
                        foreach (DataRow importedRow in rowNumbers.Rows)
                        {
                            int importRowNumber = Convert.ToInt32(importedRow["ImportRowNumber"]);
                            DataRow[] rowValues = values.Select("ImportRowNumber = " + importRowNumber);
                            string itemNumber = FindIdentifierValue(rowValues, true);
                            string dealNumber = FindIdentifierValue(rowValues, false);
                            if (string.IsNullOrWhiteSpace(itemNumber))
                                throw new InvalidOperationException("Import row " + importRowNumber + " does not contain a Loan # or Order # field marked For Import.");
                            if (string.IsNullOrWhiteSpace(dealNumber))
                                throw new InvalidOperationException("Import row " + importRowNumber + " does not contain a Deal # field marked For Import.");
                            if (!importedItemNumbers.Add(itemNumber))
                                throw new InvalidOperationException("Loan/Order '" + itemNumber + "' occurs more than once in the import file.");

                            long itemId;
                            using (SqlCommand saveItem = new SqlCommand(@"
DECLARE @ItemID bigint;
SELECT @ItemID = ItemID FROM dbo.OLTracking_Item WITH (UPDLOCK, HOLDLOCK)
WHERE ProjectID = @ProjectID AND ItemNumber = @ItemNumber;
IF @ItemID IS NULL
BEGIN
    INSERT dbo.OLTracking_Item
        (ProjectID, ItemNumber, DealNumber, CurrentProcessID, ItemStatus, RecordSource, IsDeleted, AddedBy, AddedDate)
    VALUES
        (@ProjectID, @ItemNumber, @DealNumber, NULL, 'Pending', 'Import', 0, @UserID, GETDATE());
    SET @ItemID = SCOPE_IDENTITY();
END
ELSE
BEGIN
    UPDATE dbo.OLTracking_Item
    SET DealNumber = @DealNumber, RecordSource = 'Import', IsDeleted = 0,
        UpdatedBy = @UserID, UpdatedDate = GETDATE()
    WHERE ItemID = @ItemID;
END
SELECT @ItemID;", connection, transaction))
                            {
                                saveItem.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                                saveItem.Parameters.Add("@ItemNumber", SqlDbType.NVarChar, 150).Value = itemNumber;
                                saveItem.Parameters.Add("@DealNumber", SqlDbType.NVarChar, 150).Value = dealNumber;
                                saveItem.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                                itemId = Convert.ToInt64(saveItem.ExecuteScalar());
                            }

                            using (SqlCommand batchItem = new SqlCommand(@"
INSERT dbo.OLTracking_ImportBatchItem (ImportBatchId, ItemID, EntryDate, AddedDate)
VALUES (@BatchID, @ItemID, @EntryDate, GETDATE());", connection, transaction))
                            {
                                batchItem.Parameters.Add("@BatchID", SqlDbType.BigInt).Value = batchId;
                                batchItem.Parameters.Add("@ItemID", SqlDbType.BigInt).Value = itemId;
                                batchItem.Parameters.Add("@EntryDate", SqlDbType.Date).Value = Convert.ToDateTime(importedRow["EntryDate"]).Date;
                                batchItem.ExecuteNonQuery();
                            }

                            foreach (DataRow value in rowValues)
                            {
                                using (SqlCommand insertValue = new SqlCommand(@"
IF NOT EXISTS
(
    SELECT 1
    FROM dbo.WBT_ProjectTrackingFieldConfig f
    INNER JOIN dbo.OLTracking_ImportFieldConfiguration i
       ON i.FieldConfigId = f.FieldConfigId AND i.IsForImport = 1
    WHERE f.FieldConfigId = @FieldConfigId AND f.ProjectID = @ProjectID AND f.IsDeleted = 0
)
    THROW 50001, 'The import field configuration changed. Download a new template.', 1;

MERGE dbo.OLTracking_ImportItemValue AS target
USING (SELECT @ItemID AS ItemID, @FieldConfigId AS FieldConfigId) AS source
   ON target.ItemID = source.ItemID AND target.FieldConfigId = source.FieldConfigId
WHEN MATCHED THEN UPDATE SET FieldValue = @FieldValue, UpdatedBy = @UserID, UpdatedDate = GETDATE()
WHEN NOT MATCHED THEN INSERT (ItemID, FieldConfigId, FieldValue, AddedBy, AddedDate)
VALUES (@ItemID, @FieldConfigId, @FieldValue, @UserID, GETDATE());", connection, transaction))
                                {
                                    insertValue.Parameters.Add("@ItemID", SqlDbType.BigInt).Value = itemId;
                                    insertValue.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = Convert.ToInt32(value["FieldConfigId"]);
                                    insertValue.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                                    insertValue.Parameters.Add("@FieldValue", SqlDbType.NVarChar, -1).Value = Convert.ToString(value["FieldValue"]);
                                    insertValue.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                                    insertValue.ExecuteNonQuery();
                                }
                            }
                        }

                        using (SqlCommand complete = new SqlCommand(@"
UPDATE dbo.OLTracking_ImportBatch
SET ImportedRows = TotalRows, ImportStatus = 'Completed'
WHERE ImportBatchId = @BatchID;", connection, transaction))
                        {
                            complete.Parameters.Add("@BatchID", SqlDbType.BigInt).Value = batchId;
                            complete.ExecuteNonQuery();
                        }
                        transaction.Commit();
                        return batchId;
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        private static string FindIdentifierValue(DataRow[] values, bool itemNumber)
        {
            string[] names = itemNumber
                ? new[] { "loan", "loanno", "loannumber", "loanid", "order", "orderno", "ordernumber", "orderid" }
                : new[] { "deal", "dealno", "dealnumber", "dealid" };
            foreach (DataRow value in values)
            {
                string normalized = NormalizeFieldName(Convert.ToString(value["FieldName"]));
                if (Array.IndexOf(names, normalized) >= 0) return Convert.ToString(value["FieldValue"]).Trim();
            }
            foreach (DataRow value in values)
            {
                string normalized = NormalizeFieldName(Convert.ToString(value["FieldName"]));
                bool excluded = normalized.Contains("status") || normalized.Contains("date") || normalized.Contains("process") || normalized.Contains("user");
                bool matches = itemNumber
                    ? (normalized.Contains("loan") || normalized.Contains("order")) && !excluded
                    : normalized.Contains("deal") && !excluded;
                if (matches) return Convert.ToString(value["FieldValue"]).Trim();
            }
            return string.Empty;
        }

        private static string NormalizeFieldName(string value)
        {
            System.Text.StringBuilder normalized = new System.Text.StringBuilder();
            foreach (char character in (value ?? string.Empty).ToLowerInvariant())
                if (char.IsLetterOrDigit(character)) normalized.Append(character);
            return normalized.ToString();
        }

        public DataTable GetRecentImports(int userId)
        {
            EnsureSchema();
            using (SqlCommand command = new SqlCommand(@"
SELECT TOP (20) ImportBatchId, ProjectID, OriginalFileName, TotalRows, ImportedRows,
       ImportStatus, CONVERT(varchar(19), ImportedDate, 120) AS ImportedDate
FROM dbo.OLTracking_ImportBatch
WHERE ImportedBy = @UserID
ORDER BY ImportBatchId DESC;"))
            {
                command.Connection = new SqlConnection(SQLHelper.ConnectionString);
                command.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    DataTable result = new DataTable();
                    adapter.Fill(result);
                    return result;
                }
            }
        }

        private static void EnsureSchema()
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
IF OBJECT_ID('dbo.OLTracking_ImportFieldConfiguration', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ImportFieldConfiguration
    (
        FieldConfigId int NOT NULL CONSTRAINT PK_OLTracking_ImportFieldConfiguration PRIMARY KEY,
        ProjectID int NOT NULL,
        IsForImport bit NOT NULL CONSTRAINT DF_OLTracking_ImportFieldConfiguration_IsForImport DEFAULT (1),
        AddedBy int NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ImportFieldConfiguration_AddedDate DEFAULT (GETDATE()),
        UpdatedBy int NULL,
        UpdatedDate datetime NULL
    );
    CREATE INDEX IX_OLTracking_ImportFieldConfiguration_Project
        ON dbo.OLTracking_ImportFieldConfiguration(ProjectID, IsForImport, FieldConfigId);
END;

IF OBJECT_ID('dbo.OLTracking_ImportBatch', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ImportBatch
    (
        ImportBatchId bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ImportBatch PRIMARY KEY,
        ProjectID int NOT NULL,
        OriginalFileName nvarchar(260) NOT NULL,
        TotalRows int NOT NULL,
        ImportedRows int NOT NULL,
        RejectedRows int NOT NULL,
        ImportStatus varchar(20) NOT NULL,
        ErrorMessage nvarchar(2000) NULL,
        ImportedBy int NOT NULL,
        ImportedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ImportBatch_ImportedDate DEFAULT (GETDATE())
    );
    CREATE INDEX IX_OLTracking_ImportBatch_UserDate
        ON dbo.OLTracking_ImportBatch(ImportedBy, ImportedDate DESC);
END;

IF COL_LENGTH('dbo.OLTracking_Item', 'RecordSource') IS NULL
    ALTER TABLE dbo.OLTracking_Item ADD RecordSource varchar(20) NOT NULL
        CONSTRAINT DF_OLTracking_Item_RecordSource DEFAULT ('Tracking') WITH VALUES;

IF OBJECT_ID('dbo.OLTracking_ImportItemValue', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ImportItemValue
    (
        ImportItemValueID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ImportItemValue PRIMARY KEY,
        ItemID bigint NOT NULL,
        FieldConfigId int NOT NULL,
        FieldValue nvarchar(max) NULL,
        AddedBy int NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ImportItemValue_AddedDate DEFAULT (GETDATE()),
        UpdatedBy int NULL,
        UpdatedDate datetime NULL,
        CONSTRAINT FK_OLTracking_ImportItemValue_Item FOREIGN KEY (ItemID) REFERENCES dbo.OLTracking_Item(ItemID),
        CONSTRAINT UQ_OLTracking_ImportItemValue UNIQUE (ItemID, FieldConfigId)
    );
END;

IF OBJECT_ID('dbo.OLTracking_ImportBatchItem', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_ImportBatchItem
    (
        ImportBatchItemID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_ImportBatchItem PRIMARY KEY,
        ImportBatchId bigint NOT NULL,
        ItemID bigint NOT NULL,
        EntryDate date NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_ImportBatchItem_AddedDate DEFAULT (GETDATE()),
        CONSTRAINT FK_OLTracking_ImportBatchItem_Batch FOREIGN KEY (ImportBatchId) REFERENCES dbo.OLTracking_ImportBatch(ImportBatchId),
        CONSTRAINT FK_OLTracking_ImportBatchItem_Item FOREIGN KEY (ItemID) REFERENCES dbo.OLTracking_Item(ItemID),
        CONSTRAINT UQ_OLTracking_ImportBatchItem UNIQUE (ImportBatchId, ItemID)
    );
END;", connection))
            {
                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        public DataTable UpdateExistingBillingRows(int projectId, string originalFileName, DataTable values, int userId)
        {
            ValidateBillingUpdateInput(projectId, values, userId);

            DataTable result = new DataTable();
            result.Columns.Add("ImportRowNumber", typeof(int));
            result.Columns.Add("Status", typeof(string));
            result.Columns.Add("Message", typeof(string));

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        int dispatchFieldId = GetDispatchFieldId(connection, transaction, projectId);
                        if (dispatchFieldId <= 0)
                            throw new InvalidOperationException("Dispatch Date is not configured for the selected project.");

                        DataTable importRows = values.DefaultView.ToTable(true, "ImportRowNumber");
                        foreach (DataRow importRow in importRows.Rows)
                        {
                            int rowNumber = Convert.ToInt32(importRow["ImportRowNumber"]);
                            DataRow[] rowValues = values.Select("ImportRowNumber = " + rowNumber);
                            DataRow first = rowValues[0];
                            long[] itemIds = FindExistingItems(
                                connection,
                                transaction,
                                projectId,
                                Convert.ToString(first["DealNo"]),
                                Convert.ToString(first["LoanNo"]),
                                Convert.ToDateTime(first["OrderDate"]));

                            if (itemIds.Length == 0)
                            {
                                AddBillingUpdateResult(result, rowNumber, "NotFound", "Record not found.");
                                continue;
                            }
                            if (itemIds.Length > 1)
                            {
                                AddBillingUpdateResult(result, rowNumber, "Duplicate", "Duplicate database records match the supplied key fields.");
                                continue;
                            }

                            long itemId = itemIds[0];
                            if (IsBillingLocked(connection, transaction, projectId, itemId, Convert.ToDateTime(first["OrderDate"])))
                            {
                                AddBillingUpdateResult(result, rowNumber, "Locked", "The record is verified or sent to Accounts and is locked.");
                                continue;
                            }
                            UpsertItemValue(connection, transaction, itemId, dispatchFieldId,
                                Convert.ToDateTime(first["DispatchDate"]).ToString("yyyy-MM-dd"), userId);

                            foreach (DataRow value in rowValues)
                            {
                                int fieldConfigId = Convert.ToInt32(value["FieldConfigId"]);
                                if (fieldConfigId <= 0)
                                    continue;

                                EnsureActiveBillingParameter(connection, transaction, projectId, fieldConfigId);
                                UpsertItemValue(connection, transaction, itemId, fieldConfigId,
                                    Convert.ToString(value["FieldValue"]), userId);
                            }

                            AddBillingUpdateResult(result, rowNumber, "Updated", "Record updated successfully.");
                        }

                        transaction.Commit();
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }

            return result;
        }

        private static long[] FindExistingItems(SqlConnection connection, SqlTransaction transaction, int projectId,
            string dealNumber, string loanNumber, DateTime orderDate)
        {
            System.Collections.Generic.List<long> itemIds = new System.Collections.Generic.List<long>();
            using (SqlCommand command = new SqlCommand(@"
SELECT DISTINCT i.ItemID
FROM dbo.OLTracking_Item i WITH (UPDLOCK, HOLDLOCK)
INNER JOIN dbo.OLTracking_ImportBatchItem bi ON bi.ItemID = i.ItemID
WHERE i.ProjectID = @ProjectID
  AND i.IsDeleted = 0
  AND LTRIM(RTRIM(i.DealNumber)) = @DealNumber
  AND LTRIM(RTRIM(i.ItemNumber)) = @LoanNumber
  AND bi.EntryDate = @OrderDate;", connection, transaction))
            {
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                command.Parameters.Add("@DealNumber", SqlDbType.NVarChar, 150).Value = dealNumber.Trim();
                command.Parameters.Add("@LoanNumber", SqlDbType.NVarChar, 150).Value = loanNumber.Trim();
                command.Parameters.Add("@OrderDate", SqlDbType.Date).Value = orderDate.Date;
                using (SqlDataReader reader = command.ExecuteReader())
                    while (reader.Read()) itemIds.Add(reader.GetInt64(0));
            }
            return itemIds.ToArray();
        }

        private static bool IsBillingLocked(SqlConnection connection, SqlTransaction transaction, int projectId, long itemId, DateTime orderDate)
        {
            using (SqlCommand command = new SqlCommand(@"
IF OBJECT_ID('dbo.OLTracking_MonthlyBilling','U') IS NULL
    SELECT CONVERT(bit,0);
ELSE
    SELECT CONVERT(bit,CASE WHEN EXISTS
    (
        SELECT 1 FROM dbo.OLTracking_MonthlyBilling
        WHERE ProjectID=@ProjectID AND ItemID=@ItemID AND OrderDate=@OrderDate
          AND (IsVerified=1 OR IsSentToAccounts=1)
    ) THEN 1 ELSE 0 END);", connection, transaction))
            {
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                command.Parameters.Add("@ItemID", SqlDbType.BigInt).Value = itemId;
                command.Parameters.Add("@OrderDate", SqlDbType.Date).Value = orderDate.Date;
                return Convert.ToBoolean(command.ExecuteScalar());
            }
        }

        private static int GetDispatchFieldId(SqlConnection connection, SqlTransaction transaction, int projectId)
        {
            using (SqlCommand command = new SqlCommand(@"
SELECT TOP (2) FieldConfigId
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @ProjectID
  AND IsDeleted = 0
  AND ISNULL(IsBillingField, 0) = 0
  AND LOWER(REPLACE(REPLACE(REPLACE(REPLACE(FieldName, ' ', ''), '#', ''), '-', ''), '_', '')) = 'dispatchdate'
ORDER BY FieldConfigId;", connection, transaction))
            {
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                System.Collections.Generic.List<int> ids = new System.Collections.Generic.List<int>();
                using (SqlDataReader reader = command.ExecuteReader())
                    while (reader.Read()) ids.Add(reader.GetInt32(0));
                if (ids.Count > 1)
                    throw new InvalidOperationException("Duplicate Dispatch Date field configurations were found for the selected project.");
                return ids.Count == 0 ? 0 : ids[0];
            }
        }

        private static void EnsureActiveBillingParameter(SqlConnection connection, SqlTransaction transaction,
            int projectId, int fieldConfigId)
        {
            using (SqlCommand command = new SqlCommand(@"
SELECT COUNT(1)
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE FieldConfigId = @FieldConfigId
  AND ProjectID = @ProjectID
  AND IsDeleted = 0
  AND ISNULL(IsBillingField, 0) = 0
  AND ISNULL(IsBillingParameter, 0) = 1;", connection, transaction))
            {
                command.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = fieldConfigId;
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                if (Convert.ToInt32(command.ExecuteScalar()) != 1)
                    throw new InvalidOperationException("Billing parameter configuration changed. Please download a new template.");
            }
        }

        private static void UpsertItemValue(SqlConnection connection, SqlTransaction transaction, long itemId,
            int fieldConfigId, string fieldValue, int userId)
        {
            using (SqlCommand command = new SqlCommand(@"
IF EXISTS (SELECT 1 FROM dbo.OLTracking_ImportItemValue WHERE ItemID = @ItemID AND FieldConfigId = @FieldConfigId)
BEGIN
    UPDATE dbo.OLTracking_ImportItemValue
    SET FieldValue = @FieldValue, UpdatedBy = @UserID, UpdatedDate = GETDATE()
    WHERE ItemID = @ItemID AND FieldConfigId = @FieldConfigId;
END
ELSE
BEGIN
    INSERT dbo.OLTracking_ImportItemValue (ItemID, FieldConfigId, FieldValue, AddedBy, AddedDate)
    VALUES (@ItemID, @FieldConfigId, @FieldValue, @UserID, GETDATE());
END;", connection, transaction))
            {
                command.Parameters.Add("@ItemID", SqlDbType.BigInt).Value = itemId;
                command.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = fieldConfigId;
                command.Parameters.Add("@FieldValue", SqlDbType.NVarChar, -1).Value = fieldValue ?? string.Empty;
                command.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                command.ExecuteNonQuery();
            }
        }

        private static void AddBillingUpdateResult(DataTable result, int rowNumber, string status, string message)
        {
            DataRow row = result.NewRow();
            row["ImportRowNumber"] = rowNumber;
            row["Status"] = status;
            row["Message"] = message;
            result.Rows.Add(row);
        }

        private static void ValidateBillingUpdateInput(int projectId, DataTable values, int userId)
        {
            if (projectId <= 0) throw new ArgumentException("A valid project ID is required.");
            if (userId <= 0) throw new ArgumentException("A valid user ID is required.");
            if (values == null || values.Rows.Count == 0) throw new ArgumentException("No import data was provided.");

            string[] requiredColumns = { "ImportRowNumber", "ProjectID", "Project", "DealNo", "LoanNo",
                "OrderDate", "DispatchDate", "FieldConfigId", "FieldName", "FieldValue" };
            foreach (string column in requiredColumns)
                if (!values.Columns.Contains(column))
                    throw new ArgumentException("Import DataTable does not contain required column: " + column);
        }
    }


}
