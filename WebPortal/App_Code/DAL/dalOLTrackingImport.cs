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

                        DataView distinctRows = new DataView(values);
                        DataTable rowNumbers = distinctRows.ToTable(true, "ImportRowNumber", "EntryDate");
                        foreach (DataRow importedRow in rowNumbers.Rows)
                        {
                            int importRowNumber = Convert.ToInt32(importedRow["ImportRowNumber"]);
                            int trackingRowId;
                            using (SqlCommand header = new SqlCommand(@"
INSERT dbo.WBT_ProjectTrackingSheetRows (ProjectID, EntryDate, AddedBy, AddedDate, IsDeleted)
OUTPUT INSERTED.RowId
VALUES (@ProjectID, @EntryDate, @UserID, GETDATE(), 0);", connection, transaction))
                            {
                                header.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                                header.Parameters.Add("@EntryDate", SqlDbType.Date).Value = Convert.ToDateTime(importedRow["EntryDate"]).Date;
                                header.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                                trackingRowId = Convert.ToInt32(header.ExecuteScalar());
                            }

                            foreach (DataRow value in values.Select("ImportRowNumber = " + importRowNumber))
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

INSERT dbo.WBT_ProjectTrackingSheetValues (RowId, FieldConfigId, FieldValue, AddedDate)
VALUES (@RowId, @FieldConfigId, @FieldValue, GETDATE());", connection, transaction))
                                {
                                    insertValue.Parameters.Add("@RowId", SqlDbType.Int).Value = trackingRowId;
                                    insertValue.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = Convert.ToInt32(value["FieldConfigId"]);
                                    insertValue.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                                    insertValue.Parameters.Add("@FieldValue", SqlDbType.NVarChar, -1).Value = Convert.ToString(value["FieldValue"]);
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
END;", connection))
            {
                connection.Open();
                command.ExecuteNonQuery();
            }
        }
    }
}
