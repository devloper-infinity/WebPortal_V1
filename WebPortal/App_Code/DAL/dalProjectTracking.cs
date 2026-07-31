using System;
using System.Data;
using System.Data.SqlClient;

namespace WebPortal.App_Code.DAL
{
    public class dalProjectTracking
    {
        private static readonly ProcessChildField[] ProcessChildFields = new ProcessChildField[]
        {
            new ProcessChildField("AssignedDateTime", "Assigned Datetime", "DateTime", string.Empty),
            new ProcessChildField("StartDateTime", "Start Datetime", "DateTime", string.Empty),
            new ProcessChildField("EndDateTime", "End Datetime", "DateTime", string.Empty),
            new ProcessChildField("TAT", "TAT", "Text", string.Empty),
            new ProcessChildField("Status", "Status", "Dropdown", "Pending\r\nIn Progress\r\nCompleted\r\nHold")
        };

        private static readonly BillingSystemField[] BillingSystemFields = new BillingSystemField[]
        {
            new BillingSystemField("TrackingSheetID", "Number", 1),
            new BillingSystemField("ProjectID", "Number", 2),
            new BillingSystemField("isVerify", "Checkbox", 3),
            new BillingSystemField("VerifiedBy", "Number", 4),
            new BillingSystemField("BillingCount", "Number", 5),
            new BillingSystemField("BillingPeriod", "Text", 6),
            new BillingSystemField("BillingAddedBy", "Number", 7),
            new BillingSystemField("BillingAddedDate", "DateTime", 8)
        };

        public DataTable GetFieldConfigurations(int projectId)
        {
            EnsureTables();
            NormalizeProjectDisplayOrders(projectId);
            return GetFieldConfigurationTable(projectId, false);
        }

        public DataTable GetSheetFieldConfigurations(int projectId)
        {
            EnsureTables();
            NormalizeProjectDisplayOrders(projectId);
            return GetFieldConfigurationTable(projectId, true);
        }

        public void EnsureProjectBillingFields(int projectId, int userId)
        {
            EnsureTables();

            if (projectId <= 0)
            {
                return;
            }

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();

                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        EnsureProjectBillingFields(connection, transaction, projectId, userId);
                        transaction.Commit();
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        public int SaveFieldConfiguration(int fieldConfigId, int projectId, string fieldName, string dataType, string optionsText, bool isRequired, bool isUniqueField, bool isVisible, bool isEditable, bool isForBilling, bool isBillingParameter, int displayOrder, bool isProcessColumn, string dateFormat, int userId)
        {
            EnsureTables();

            if (IsBillingSystemFieldName(fieldName))
            {
                return -1;
            }

            bool saveAsProcess = isProcessColumn || string.Equals(dataType, "Process", StringComparison.OrdinalIgnoreCase);
            string effectiveDataType = saveAsProcess ? "Process" : dataType;
            bool effectiveRequired = saveAsProcess ? false : isRequired;
            bool effectiveVisible = saveAsProcess ? true : isVisible;
            bool effectiveEditable = saveAsProcess ? true : isEditable;
            bool effectiveForBilling = isForBilling;
            bool effectiveBillingParameter = isBillingParameter;
            string effectiveOptions = saveAsProcess ? string.Empty : optionsText;
            string effectiveDateFormat = saveAsProcess ? string.Empty : NormalizeDateFormat(effectiveDataType, dateFormat);

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();

                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        EnsureProjectBillingFields(connection, transaction, projectId, userId);
                        int effectiveDisplayOrder = displayOrder > 0 ? displayOrder : GetNextDisplayOrder(connection, transaction, projectId);

                        if (FieldNameExists(connection, transaction, projectId, fieldName, fieldConfigId))
                        {
                            transaction.Rollback();
                            return -1;
                        }

                        if (saveAsProcess && ProcessChildNameExists(connection, transaction, projectId, fieldName, fieldConfigId))
                        {
                            transaction.Rollback();
                            return -1;
                        }

                        int savedFieldConfigId = fieldConfigId > 0
                            ? UpdateFieldConfiguration(connection, transaction, fieldConfigId, projectId, fieldName, effectiveDataType, effectiveOptions, effectiveRequired, isUniqueField, effectiveVisible, effectiveEditable, effectiveForBilling, effectiveBillingParameter, effectiveDisplayOrder, saveAsProcess, effectiveDateFormat, userId)
                            : InsertFieldConfiguration(connection, transaction, projectId, fieldName, effectiveDataType, effectiveOptions, effectiveRequired, isUniqueField, effectiveVisible, effectiveEditable, effectiveForBilling, effectiveBillingParameter, effectiveDisplayOrder, saveAsProcess, effectiveDateFormat, userId);

                        if (savedFieldConfigId <= 0)
                        {
                            transaction.Rollback();
                            return 0;
                        }

                        if (saveAsProcess)
                        {
                            EnsureProcessChildFields(connection, transaction, projectId, savedFieldConfigId, fieldName, effectiveDisplayOrder, userId);
                        }
                        else
                        {
                            DeleteProcessChildFields(connection, transaction, savedFieldConfigId, userId);
                        }

                        using (SqlCommand refreshCommand = new SqlCommand(
                            @"IF OBJECT_ID('dbo.OLTracking_RefreshProjectUniqueCombinations','P') IS NOT NULL
                                  EXEC dbo.OLTracking_RefreshProjectUniqueCombinations @ProjectID;",
                            connection, transaction))
                        {
                            refreshCommand.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                            refreshCommand.ExecuteNonQuery();
                        }
                        transaction.Commit();
                        return savedFieldConfigId;
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        public int MoveFieldSequence(int projectId, int fieldConfigId, string direction, int userId)
        {
            EnsureTables();

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();

                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        RenumberFieldOrders(connection, transaction, projectId);

                        int currentOrder = GetFieldDisplayOrder(connection, transaction, projectId, fieldConfigId);
                        if (currentOrder <= 0)
                        {
                            transaction.Rollback();
                            return 0;
                        }

                        int swapFieldConfigId = GetSwapFieldConfigId(connection, transaction, projectId, currentOrder, direction);
                        if (swapFieldConfigId <= 0)
                        {
                            transaction.Rollback();
                            return 0;
                        }

                        int swapOrder = GetFieldDisplayOrder(connection, transaction, projectId, swapFieldConfigId);
                        SetFieldDisplayOrder(connection, transaction, fieldConfigId, swapOrder, userId);
                        SetFieldDisplayOrder(connection, transaction, swapFieldConfigId, currentOrder, userId);

                        transaction.Commit();
                        return 1;
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        public int UpdateGeneratedStatusOptions(int fieldConfigId, string optionsText, int userId)
        {
            EnsureTables();

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
UPDATE dbo.WBT_ProjectTrackingFieldConfig
SET OptionsText = @OptionsText,
    UpdatedBy = @UserID,
    UpdatedDate = GETDATE()
WHERE FieldConfigId = @FieldConfigId
    AND IsDeleted = 0
    AND IsSystemGenerated = 1
    AND ProcessChildType = 'Status'
    AND DataType = 'Dropdown'
    AND ISNULL(IsBillingField, 0) = 0;", connection))
            {
                cmd.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = fieldConfigId;
                cmd.Parameters.Add("@OptionsText", SqlDbType.NVarChar, -1).Value = string.IsNullOrWhiteSpace(optionsText) ? (object)DBNull.Value : optionsText.Trim();
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                connection.Open();
                return cmd.ExecuteNonQuery();
            }
        }

        public int CreateProjectConfigurationReplica(int sourceProjectId, int targetProjectId, int userId)
        {
            EnsureTables();

            if (sourceProjectId <= 0 || targetProjectId <= 0 || sourceProjectId == targetProjectId)
            {
                return 0;
            }

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();

                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        if (ProjectHasActiveFields(connection, transaction, targetProjectId))
                        {
                            transaction.Rollback();
                            return -1;
                        }

                        DataTable sourceFields = GetReplicaSourceFields(connection, transaction, sourceProjectId);
                        if (sourceFields.Rows.Count == 0)
                        {
                            transaction.Rollback();
                            return 0;
                        }

                        EnsureProjectBillingFields(connection, transaction, targetProjectId, userId);

                        int insertedRows = 0;
                        System.Collections.Generic.Dictionary<int, int> parentMap = new System.Collections.Generic.Dictionary<int, int>();

                        foreach (DataRow sourceRow in sourceFields.Rows)
                        {
                            if (sourceRow["ParentProcessFieldConfigId"] != DBNull.Value)
                            {
                                continue;
                            }

                            int oldFieldConfigId = Convert.ToInt32(sourceRow["FieldConfigId"]);
                            int newFieldConfigId = InsertReplicaField(connection, transaction, sourceRow, targetProjectId, DBNull.Value, userId);
                            parentMap.Add(oldFieldConfigId, newFieldConfigId);
                            insertedRows++;
                        }

                        foreach (DataRow sourceRow in sourceFields.Rows)
                        {
                            if (sourceRow["ParentProcessFieldConfigId"] == DBNull.Value)
                            {
                                continue;
                            }

                            int oldParentFieldConfigId = Convert.ToInt32(sourceRow["ParentProcessFieldConfigId"]);
                            if (!parentMap.ContainsKey(oldParentFieldConfigId))
                            {
                                continue;
                            }

                            InsertReplicaField(connection, transaction, sourceRow, targetProjectId, parentMap[oldParentFieldConfigId], userId);
                            insertedRows++;
                        }

                        transaction.Commit();
                        return insertedRows;
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        public int DeleteFieldConfiguration(int fieldConfigId, int userId)
        {
            EnsureTables();

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
UPDATE dbo.WBT_ProjectTrackingFieldConfig
SET IsDeleted = 1,
    UpdatedBy = @UserID,
    UpdatedDate = GETDATE()
WHERE IsDeleted = 0
    AND (FieldConfigId = @FieldConfigId OR ParentProcessFieldConfigId = @FieldConfigId);", connection))
            {
                cmd.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = fieldConfigId;
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                connection.Open();
                return cmd.ExecuteNonQuery();
            }
        }

        public DataTable GetProjectTrackingRows(int projectId, string fromDate, string toDate)
        {
            EnsureTables();

            using (SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
DECLARE @From date = CASE WHEN ISDATE(@FromDate) = 1 THEN CONVERT(date, @FromDate) ELSE NULL END;
DECLARE @To date = CASE WHEN ISDATE(@ToDate) = 1 THEN CONVERT(date, @ToDate) ELSE NULL END;

SELECT
    r.RowId,
    CONVERT(varchar(10), r.EntryDate, 23) AS EntryDate,
    v.FieldConfigId,
    v.FieldValue
FROM dbo.WBT_ProjectTrackingSheetRows r
LEFT JOIN dbo.WBT_ProjectTrackingSheetValues v ON v.RowId = r.RowId
WHERE r.ProjectID = @ProjectID
    AND r.IsDeleted = 0
    AND (@From IS NULL OR r.EntryDate >= @From)
    AND (@To IS NULL OR r.EntryDate <= @To)
ORDER BY r.EntryDate DESC, r.RowId DESC, v.FieldConfigId;"))
            {
                SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
                SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", SqlDbType.NVarChar, 30, ParameterDirection.Input, fromDate ?? string.Empty);
                SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", SqlDbType.NVarChar, 30, ParameterDirection.Input, toDate ?? string.Empty);
                return SQLHelper.ExecuteDataTableCmd(cmd);
            }
        }

        public int SaveProjectTrackingRow(int projectId, int rowId, string entryDate, DataTable values, int userId)
        {
            EnsureTables();

            DateTime parsedEntryDate;
            if (!DateTime.TryParse(entryDate, out parsedEntryDate))
            {
                parsedEntryDate = DateTime.Today;
            }

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();

                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        int savedRowId = SaveRowHeader(connection, transaction, projectId, rowId, parsedEntryDate, userId);
                        SaveValues(connection, transaction, savedRowId, values);
                        transaction.Commit();
                        return savedRowId;
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        public int DeleteProjectTrackingRow(int rowId, int userId)
        {
            EnsureTables();

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
UPDATE dbo.WBT_ProjectTrackingSheetRows
SET IsDeleted = 1,
    UpdatedBy = @UserID,
    UpdatedDate = GETDATE()
WHERE RowId = @RowId
    AND IsDeleted = 0;", connection))
            {
                cmd.Parameters.Add("@RowId", SqlDbType.Int).Value = rowId;
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                connection.Open();
                return cmd.ExecuteNonQuery();
            }
        }

        public DataTable GetReportFields(int projectId)
        {
            EnsureTables();

            using (SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
SELECT
    FieldName,
    MIN(DisplayOrder) AS DisplayOrder
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE IsDeleted = 0
    AND IsVisible = 1
    AND ISNULL(IsBillingField, 0) = 0
    AND (@ProjectID = 0 OR ProjectID = @ProjectID)
GROUP BY FieldName
ORDER BY MIN(DisplayOrder), FieldName;"))
            {
                SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
                return SQLHelper.ExecuteDataTableCmd(cmd);
            }
        }

        public DataTable GetProjectTrackingReportData(int projectId, string fromDate, string toDate)
        {
            EnsureTables();

            using (SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
DECLARE @From date = CASE WHEN ISDATE(@FromDate) = 1 THEN CONVERT(date, @FromDate) ELSE NULL END;
DECLARE @To date = CASE WHEN ISDATE(@ToDate) = 1 THEN CONVERT(date, @ToDate) ELSE NULL END;

SELECT
    r.RowId,
    r.ProjectID,
    CONVERT(varchar(10), r.EntryDate, 23) AS EntryDate,
    f.FieldName,
    v.FieldValue
FROM dbo.WBT_ProjectTrackingSheetRows r
INNER JOIN dbo.WBT_ProjectTrackingSheetValues v ON v.RowId = r.RowId
INNER JOIN dbo.WBT_ProjectTrackingFieldConfig f ON f.FieldConfigId = v.FieldConfigId
WHERE r.IsDeleted = 0
    AND f.IsDeleted = 0
    AND f.IsVisible = 1
    AND ISNULL(f.IsBillingField, 0) = 0
    AND (@ProjectID = 0 OR r.ProjectID = @ProjectID)
    AND (@From IS NULL OR r.EntryDate >= @From)
    AND (@To IS NULL OR r.EntryDate <= @To)
ORDER BY r.ProjectID, r.EntryDate DESC, r.RowId DESC, f.DisplayOrder, f.FieldConfigId;"))
            {
                SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
                SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", SqlDbType.NVarChar, 30, ParameterDirection.Input, fromDate ?? string.Empty);
                SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", SqlDbType.NVarChar, 30, ParameterDirection.Input, toDate ?? string.Empty);
                return SQLHelper.ExecuteDataTableCmd(cmd);
            }
        }

        public DataTable GetProjectTrackingSummaryData(int projectId, string fromDate, string toDate)
        {
            EnsureTables();

            using (SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
DECLARE @From date = CASE WHEN ISDATE(@FromDate) = 1 THEN CONVERT(date, @FromDate) ELSE NULL END;
DECLARE @To date = CASE WHEN ISDATE(@ToDate) = 1 THEN CONVERT(date, @ToDate) ELSE NULL END;

SELECT
    r.RowId,
    r.ProjectID,
    CONVERT(varchar(10), r.EntryDate, 23) AS EntryDate,
    f.FieldName AS ProcessName,
    v.FieldValue AS UserName
FROM dbo.WBT_ProjectTrackingSheetRows r
INNER JOIN dbo.WBT_ProjectTrackingSheetValues v ON v.RowId = r.RowId
INNER JOIN dbo.WBT_ProjectTrackingFieldConfig f ON f.FieldConfigId = v.FieldConfigId
WHERE r.IsDeleted = 0
    AND f.IsDeleted = 0
    AND f.IsVisible = 1
    AND ISNULL(f.IsBillingField, 0) = 0
    AND f.IsProcessColumn = 1
    AND f.DataType = 'Process'
    AND NULLIF(LTRIM(RTRIM(v.FieldValue)), '') IS NOT NULL
    AND (@ProjectID = 0 OR r.ProjectID = @ProjectID)
    AND (@From IS NULL OR r.EntryDate >= @From)
    AND (@To IS NULL OR r.EntryDate <= @To)
ORDER BY r.ProjectID, r.EntryDate DESC, f.DisplayOrder, f.FieldConfigId;"))
            {
                SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
                SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", SqlDbType.NVarChar, 30, ParameterDirection.Input, fromDate ?? string.Empty);
                SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", SqlDbType.NVarChar, 30, ParameterDirection.Input, toDate ?? string.Empty);
                return SQLHelper.ExecuteDataTableCmd(cmd);
            }
        }

        private static DataTable GetFieldConfigurationTable(int projectId, bool sheetOnly)
        {
            using (SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, @"
SELECT
    FieldConfigId,
    ProjectID,
    FieldName,
    DataType,
    OptionsText,
    IsRequired,
    IsUniqueField,
    IsVisible,
    IsEditable,
    IsForBilling,
    IsBillingParameter,
    DateFormat,
    DisplayOrder,
    IsProcessColumn,
    ParentProcessFieldConfigId,
    ProcessChildType,
    IsSystemGenerated,
    IsBillingField,
    CONVERT(varchar(10), AddedDate, 103) AS AddedDate1,
    CONVERT(varchar(10), UpdatedDate, 103) AS UpdatedDate1
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @ProjectID
    AND IsDeleted = 0
    AND ISNULL(IsBillingField, 0) = 0
    AND (@SheetOnly = 0 OR IsVisible = 1)
ORDER BY DisplayOrder, FieldConfigId;"))
            {
                SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
                SQLHelper.AddParamToSQLCmd(cmd, "@SheetOnly", SqlDbType.Bit, 0, ParameterDirection.Input, sheetOnly);
                return SQLHelper.ExecuteDataTableCmd(cmd);
            }
        }

        private static bool FieldNameExists(SqlConnection connection, SqlTransaction transaction, int projectId, string fieldName, int fieldConfigId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
SELECT COUNT(1)
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @ProjectID
    AND IsDeleted = 0
    AND FieldName = @FieldName
    AND FieldConfigId <> @FieldConfigId;", connection, transaction))
            {
                cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                cmd.Parameters.Add("@FieldName", SqlDbType.NVarChar, 200).Value = fieldName;
                cmd.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = fieldConfigId;
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        private static bool ProcessChildNameExists(SqlConnection connection, SqlTransaction transaction, int projectId, string processName, int parentFieldConfigId)
        {
            foreach (ProcessChildField childField in ProcessChildFields)
            {
                using (SqlCommand cmd = new SqlCommand(@"
SELECT COUNT(1)
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @ProjectID
    AND IsDeleted = 0
    AND FieldName = @FieldName
    AND ISNULL(ParentProcessFieldConfigId, 0) <> @ParentFieldConfigId;", connection, transaction))
                {
                    cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                    cmd.Parameters.Add("@FieldName", SqlDbType.NVarChar, 200).Value = processName + " " + childField.Suffix;
                    cmd.Parameters.Add("@ParentFieldConfigId", SqlDbType.Int).Value = parentFieldConfigId;

                    if (Convert.ToInt32(cmd.ExecuteScalar()) > 0)
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        private static int InsertFieldConfiguration(SqlConnection connection, SqlTransaction transaction, int projectId, string fieldName, string dataType, string optionsText, bool isRequired, bool isUniqueField, bool isVisible, bool isEditable, bool isForBilling, bool isBillingParameter, int displayOrder, bool isProcessColumn, string dateFormat, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
INSERT INTO dbo.WBT_ProjectTrackingFieldConfig
(
    ProjectID,
    FieldName,
    DataType,
    OptionsText,
    IsRequired,
    IsUniqueField,
    IsVisible,
    IsEditable,
    IsForBilling,
    IsBillingParameter,
    DateFormat,
    DisplayOrder,
    IsProcessColumn,
    IsSystemGenerated,
    IsBillingField,
    AddedBy,
    AddedDate,
    IsDeleted
)
OUTPUT INSERTED.FieldConfigId
VALUES
(
    @ProjectID,
    @FieldName,
    @DataType,
    @OptionsText,
    @IsRequired,
    @IsUniqueField,
    @IsVisible,
    @IsEditable,
    @IsForBilling,
    @IsBillingParameter,
    @DateFormat,
    @DisplayOrder,
    @IsProcessColumn,
    0,
    0,
    @UserID,
    GETDATE(),
    0
);", connection, transaction))
            {
                AddFieldParameters(cmd, 0, projectId, fieldName, dataType, optionsText, isRequired, isUniqueField, isVisible, isEditable, isForBilling, isBillingParameter, displayOrder, isProcessColumn, dateFormat, userId);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private static int UpdateFieldConfiguration(SqlConnection connection, SqlTransaction transaction, int fieldConfigId, int projectId, string fieldName, string dataType, string optionsText, bool isRequired, bool isUniqueField, bool isVisible, bool isEditable, bool isForBilling, bool isBillingParameter, int displayOrder, bool isProcessColumn, string dateFormat, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
UPDATE dbo.WBT_ProjectTrackingFieldConfig
SET FieldName = @FieldName,
    DataType = @DataType,
    OptionsText = @OptionsText,
    IsRequired = @IsRequired,
    IsUniqueField = @IsUniqueField,
    IsVisible = @IsVisible,
    IsEditable = @IsEditable,
    IsForBilling = @IsForBilling,
    IsBillingParameter = @IsBillingParameter,
    DateFormat = @DateFormat,
    DisplayOrder = @DisplayOrder,
    IsProcessColumn = @IsProcessColumn,
    ParentProcessFieldConfigId = NULL,
    ProcessChildType = NULL,
    IsSystemGenerated = 0,
    IsBillingField = 0,
    UpdatedBy = @UserID,
    UpdatedDate = GETDATE()
WHERE FieldConfigId = @FieldConfigId
    AND ProjectID = @ProjectID
    AND IsDeleted = 0;

SELECT CASE WHEN @@ROWCOUNT > 0 THEN @FieldConfigId ELSE 0 END;", connection, transaction))
            {
                AddFieldParameters(cmd, fieldConfigId, projectId, fieldName, dataType, optionsText, isRequired, isUniqueField, isVisible, isEditable, isForBilling, isBillingParameter, displayOrder, isProcessColumn, dateFormat, userId);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private static void AddFieldParameters(SqlCommand cmd, int fieldConfigId, int projectId, string fieldName, string dataType, string optionsText, bool isRequired, bool isUniqueField, bool isVisible, bool isEditable, bool isForBilling, bool isBillingParameter, int displayOrder, bool isProcessColumn, string dateFormat, int userId)
        {
            cmd.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = fieldConfigId;
            cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
            cmd.Parameters.Add("@FieldName", SqlDbType.NVarChar, 200).Value = fieldName;
            cmd.Parameters.Add("@DataType", SqlDbType.NVarChar, 30).Value = dataType;
            cmd.Parameters.Add("@OptionsText", SqlDbType.NVarChar, -1).Value = string.IsNullOrEmpty(optionsText) ? (object)DBNull.Value : optionsText;
            cmd.Parameters.Add("@IsRequired", SqlDbType.Bit).Value = isRequired;
            cmd.Parameters.Add("@IsUniqueField", SqlDbType.Bit).Value = isUniqueField;
            cmd.Parameters.Add("@IsVisible", SqlDbType.Bit).Value = isVisible;
            cmd.Parameters.Add("@IsEditable", SqlDbType.Bit).Value = isEditable;
            cmd.Parameters.Add("@IsForBilling", SqlDbType.Bit).Value = isForBilling;
            cmd.Parameters.Add("@IsBillingParameter", SqlDbType.Bit).Value = isBillingParameter;
            cmd.Parameters.Add("@DateFormat", SqlDbType.NVarChar, 30).Value = string.IsNullOrEmpty(dateFormat) ? (object)DBNull.Value : dateFormat;
            cmd.Parameters.Add("@DisplayOrder", SqlDbType.Int).Value = displayOrder;
            cmd.Parameters.Add("@IsProcessColumn", SqlDbType.Bit).Value = isProcessColumn;
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
        }

        private static bool ProjectHasActiveFields(SqlConnection connection, SqlTransaction transaction, int projectId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
SELECT COUNT(1)
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @ProjectID
    AND IsDeleted = 0
    AND ISNULL(IsBillingField, 0) = 0;", connection, transaction))
            {
                cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        private static DataTable GetReplicaSourceFields(SqlConnection connection, SqlTransaction transaction, int sourceProjectId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
SELECT
    FieldConfigId,
    FieldName,
    DataType,
    OptionsText,
    IsRequired,
    IsUniqueField,
    IsVisible,
    IsEditable,
    IsForBilling,
    IsBillingParameter,
    DateFormat,
    DisplayOrder,
    IsProcessColumn,
    ParentProcessFieldConfigId,
    ProcessChildType,
    IsSystemGenerated
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @SourceProjectID
    AND IsDeleted = 0
    AND ISNULL(IsBillingField, 0) = 0
ORDER BY DisplayOrder, FieldConfigId;", connection, transaction))
            {
                cmd.Parameters.Add("@SourceProjectID", SqlDbType.Int).Value = sourceProjectId;

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    DataTable sourceFields = new DataTable();
                    adapter.Fill(sourceFields);
                    return sourceFields;
                }
            }
        }

        private static int InsertReplicaField(SqlConnection connection, SqlTransaction transaction, DataRow sourceRow, int targetProjectId, object parentProcessFieldConfigId, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
INSERT INTO dbo.WBT_ProjectTrackingFieldConfig
(
    ProjectID,
    FieldName,
    DataType,
    OptionsText,
    IsRequired,
    IsUniqueField,
    IsVisible,
    IsEditable,
    DisplayOrder,
    IsProcessColumn,
    ParentProcessFieldConfigId,
    ProcessChildType,
    IsSystemGenerated,
    IsForBilling,
    IsBillingParameter,
    DateFormat,
    IsBillingField,
    AddedBy,
    AddedDate,
    IsDeleted
)
OUTPUT INSERTED.FieldConfigId
VALUES
(
    @ProjectID,
    @FieldName,
    @DataType,
    @OptionsText,
    @IsRequired,
    @IsUniqueField,
    @IsVisible,
    @IsEditable,
    @DisplayOrder,
    @IsProcessColumn,
    @ParentProcessFieldConfigId,
    @ProcessChildType,
    @IsSystemGenerated,
    @IsForBilling,
    @IsBillingParameter,
    @DateFormat,
    0,
    @UserID,
    GETDATE(),
    0
);", connection, transaction))
            {
                cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = targetProjectId;
                cmd.Parameters.Add("@FieldName", SqlDbType.NVarChar, 200).Value = Convert.ToString(sourceRow["FieldName"]);
                cmd.Parameters.Add("@DataType", SqlDbType.NVarChar, 30).Value = Convert.ToString(sourceRow["DataType"]);
                cmd.Parameters.Add("@OptionsText", SqlDbType.NVarChar, -1).Value = sourceRow["OptionsText"] == DBNull.Value ? (object)DBNull.Value : Convert.ToString(sourceRow["OptionsText"]);
                cmd.Parameters.Add("@IsRequired", SqlDbType.Bit).Value = Convert.ToBoolean(sourceRow["IsRequired"]);
                cmd.Parameters.Add("@IsUniqueField", SqlDbType.Bit).Value = sourceRow.Table.Columns.Contains("IsUniqueField") && sourceRow["IsUniqueField"] != DBNull.Value && Convert.ToBoolean(sourceRow["IsUniqueField"]);
                cmd.Parameters.Add("@IsVisible", SqlDbType.Bit).Value = Convert.ToBoolean(sourceRow["IsVisible"]);
                cmd.Parameters.Add("@IsEditable", SqlDbType.Bit).Value = Convert.ToBoolean(sourceRow["IsEditable"]);
                cmd.Parameters.Add("@DisplayOrder", SqlDbType.Int).Value = Convert.ToInt32(sourceRow["DisplayOrder"]);
                cmd.Parameters.Add("@IsProcessColumn", SqlDbType.Bit).Value = Convert.ToBoolean(sourceRow["IsProcessColumn"]);
                cmd.Parameters.Add("@ParentProcessFieldConfigId", SqlDbType.Int).Value = parentProcessFieldConfigId == null ? (object)DBNull.Value : parentProcessFieldConfigId;
                cmd.Parameters.Add("@ProcessChildType", SqlDbType.NVarChar, 30).Value = sourceRow["ProcessChildType"] == DBNull.Value ? (object)DBNull.Value : Convert.ToString(sourceRow["ProcessChildType"]);
                cmd.Parameters.Add("@IsSystemGenerated", SqlDbType.Bit).Value = Convert.ToBoolean(sourceRow["IsSystemGenerated"]);
                cmd.Parameters.Add("@IsForBilling", SqlDbType.Bit).Value = sourceRow.Table.Columns.Contains("IsForBilling") && sourceRow["IsForBilling"] != DBNull.Value ? Convert.ToBoolean(sourceRow["IsForBilling"]) : false;
                cmd.Parameters.Add("@IsBillingParameter", SqlDbType.Bit).Value = sourceRow.Table.Columns.Contains("IsBillingParameter") && sourceRow["IsBillingParameter"] != DBNull.Value ? Convert.ToBoolean(sourceRow["IsBillingParameter"]) : false;
                cmd.Parameters.Add("@DateFormat", SqlDbType.NVarChar, 30).Value = sourceRow.Table.Columns.Contains("DateFormat") && sourceRow["DateFormat"] != DBNull.Value ? (object)Convert.ToString(sourceRow["DateFormat"]) : DBNull.Value;
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private static void EnsureProjectBillingFields(SqlConnection connection, SqlTransaction transaction, int projectId, int userId)
        {
            foreach (BillingSystemField billingField in BillingSystemFields)
            {
                using (SqlCommand cmd = new SqlCommand(@"
IF EXISTS
(
    SELECT 1
    FROM dbo.WBT_ProjectTrackingFieldConfig
    WHERE ProjectID = @ProjectID
        AND FieldName = @FieldName
        AND IsDeleted = 0
)
BEGIN
    UPDATE dbo.WBT_ProjectTrackingFieldConfig
    SET DataType = @DataType,
        OptionsText = NULL,
        IsRequired = 0,
        IsVisible = 0,
        IsEditable = 0,
        IsForBilling = 0,
        IsBillingParameter = 0,
        DateFormat = NULL,
        DisplayOrder = @DisplayOrder,
        IsProcessColumn = 0,
        ParentProcessFieldConfigId = NULL,
        ProcessChildType = NULL,
        IsSystemGenerated = 1,
        IsBillingField = 1,
        UpdatedBy = @UserID,
        UpdatedDate = GETDATE()
    WHERE ProjectID = @ProjectID
        AND FieldName = @FieldName
        AND IsDeleted = 0;
END
ELSE
BEGIN
    INSERT INTO dbo.WBT_ProjectTrackingFieldConfig
    (
        ProjectID,
        FieldName,
        DataType,
        OptionsText,
        IsRequired,
        IsVisible,
        IsEditable,
        IsForBilling,
        IsBillingParameter,
        DateFormat,
        DisplayOrder,
        IsProcessColumn,
        ParentProcessFieldConfigId,
        ProcessChildType,
        IsSystemGenerated,
        IsBillingField,
        AddedBy,
        AddedDate,
        IsDeleted
    )
    VALUES
    (
        @ProjectID,
        @FieldName,
        @DataType,
        NULL,
        0,
        0,
        0,
        0,
        0,
        NULL,
        @DisplayOrder,
        0,
        NULL,
        NULL,
        1,
        1,
        @UserID,
        GETDATE(),
        0
    );
END;", connection, transaction))
                {
                    cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                    cmd.Parameters.Add("@FieldName", SqlDbType.NVarChar, 200).Value = billingField.FieldName;
                    cmd.Parameters.Add("@DataType", SqlDbType.NVarChar, 30).Value = billingField.DataType;
                    cmd.Parameters.Add("@DisplayOrder", SqlDbType.Int).Value = billingField.DisplayOrder;
                    cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private static bool IsBillingSystemFieldName(string fieldName)
        {
            foreach (BillingSystemField billingField in BillingSystemFields)
            {
                if (string.Equals(billingField.FieldName, fieldName, StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }
            }

            return false;
        }

        private static string NormalizeDateFormat(string dataType, string dateFormat)
        {
            if (!string.Equals(dataType, "Date", StringComparison.OrdinalIgnoreCase))
            {
                return string.Empty;
            }

            string trimmedFormat = (dateFormat ?? string.Empty).Trim();
            return string.IsNullOrEmpty(trimmedFormat) ? "dd/MM/yyyy" : trimmedFormat;
        }

        private static void EnsureProcessChildFields(SqlConnection connection, SqlTransaction transaction, int projectId, int parentFieldConfigId, string processName, int parentDisplayOrder, int userId)
        {
            int offset = 1;

            foreach (ProcessChildField childField in ProcessChildFields)
            {
                int displayOrder = parentDisplayOrder + offset;
                string childName = processName + " " + childField.Suffix;

                using (SqlCommand cmd = new SqlCommand(@"
IF EXISTS
(
    SELECT 1
    FROM dbo.WBT_ProjectTrackingFieldConfig
    WHERE ProjectID = @ProjectID
        AND ParentProcessFieldConfigId = @ParentProcessFieldConfigId
        AND ProcessChildType = @ProcessChildType
        AND IsDeleted = 0
)
BEGIN
    UPDATE dbo.WBT_ProjectTrackingFieldConfig
    SET FieldName = @FieldName,
        DataType = @DataType,
        OptionsText = CASE
            WHEN @ProcessChildType = 'Status' AND NULLIF(LTRIM(RTRIM(OptionsText)), '') IS NOT NULL THEN OptionsText
            ELSE @OptionsText
        END,
        IsRequired = 0,
        IsVisible = 1,
        IsEditable = 1,
        IsForBilling = 0,
        IsBillingParameter = 0,
        DateFormat = NULL,
        IsProcessColumn = 0,
        IsSystemGenerated = 1,
        IsBillingField = 0,
        UpdatedBy = @UserID,
        UpdatedDate = GETDATE()
    WHERE ProjectID = @ProjectID
        AND ParentProcessFieldConfigId = @ParentProcessFieldConfigId
        AND ProcessChildType = @ProcessChildType
        AND IsDeleted = 0;
END
ELSE
BEGIN
    INSERT INTO dbo.WBT_ProjectTrackingFieldConfig
    (
        ProjectID,
        FieldName,
        DataType,
        OptionsText,
        IsRequired,
        IsVisible,
        IsEditable,
        IsForBilling,
        IsBillingParameter,
        DateFormat,
        DisplayOrder,
        IsProcessColumn,
        ParentProcessFieldConfigId,
        ProcessChildType,
        IsSystemGenerated,
        IsBillingField,
        AddedBy,
        AddedDate,
        IsDeleted
    )
    VALUES
    (
        @ProjectID,
        @FieldName,
        @DataType,
        @OptionsText,
        0,
        1,
        1,
        0,
        0,
        NULL,
        @DisplayOrder,
        0,
        @ParentProcessFieldConfigId,
        @ProcessChildType,
        1,
        0,
        @UserID,
        GETDATE(),
        0
    );
END;", connection, transaction))
                {
                    cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                    cmd.Parameters.Add("@FieldName", SqlDbType.NVarChar, 200).Value = childName;
                    cmd.Parameters.Add("@DataType", SqlDbType.NVarChar, 30).Value = childField.DataType;
                    cmd.Parameters.Add("@OptionsText", SqlDbType.NVarChar, -1).Value = string.IsNullOrEmpty(childField.OptionsText) ? (object)DBNull.Value : childField.OptionsText;
                    cmd.Parameters.Add("@DisplayOrder", SqlDbType.Int).Value = displayOrder;
                    cmd.Parameters.Add("@ParentProcessFieldConfigId", SqlDbType.Int).Value = parentFieldConfigId;
                    cmd.Parameters.Add("@ProcessChildType", SqlDbType.NVarChar, 30).Value = childField.ChildType;
                    cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                    cmd.ExecuteNonQuery();
                }

                offset++;
            }
        }

        private static void DeleteProcessChildFields(SqlConnection connection, SqlTransaction transaction, int parentFieldConfigId, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
UPDATE dbo.WBT_ProjectTrackingFieldConfig
SET IsDeleted = 1,
    UpdatedBy = @UserID,
    UpdatedDate = GETDATE()
WHERE ParentProcessFieldConfigId = @ParentProcessFieldConfigId
    AND IsDeleted = 0;", connection, transaction))
            {
                cmd.Parameters.Add("@ParentProcessFieldConfigId", SqlDbType.Int).Value = parentFieldConfigId;
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                cmd.ExecuteNonQuery();
            }
        }

        private static int GetNextDisplayOrder(SqlConnection connection, SqlTransaction transaction, int projectId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
SELECT ISNULL(MAX(DisplayOrder), 0) + 1
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @ProjectID
    AND IsDeleted = 0
    AND ISNULL(IsBillingField, 0) = 0;", connection, transaction))
            {
                cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private static void RenumberFieldOrders(SqlConnection connection, SqlTransaction transaction, int projectId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
;WITH OrderedFields AS
(
    SELECT
        FieldConfigId,
        ROW_NUMBER() OVER (ORDER BY DisplayOrder, FieldConfigId) AS NewDisplayOrder
    FROM dbo.WBT_ProjectTrackingFieldConfig
    WHERE ProjectID = @ProjectID
        AND IsDeleted = 0
        AND ISNULL(IsBillingField, 0) = 0
)
UPDATE f
SET DisplayOrder = o.NewDisplayOrder
FROM dbo.WBT_ProjectTrackingFieldConfig f
INNER JOIN OrderedFields o ON o.FieldConfigId = f.FieldConfigId;", connection, transaction))
            {
                cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                cmd.ExecuteNonQuery();
            }
        }

        private static void NormalizeProjectDisplayOrders(int projectId)
        {
            if (projectId <= 0)
            {
                return;
            }

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
;WITH OrderedFields AS
(
    SELECT
        FieldConfigId,
        ROW_NUMBER() OVER (ORDER BY DisplayOrder, FieldConfigId) AS NewDisplayOrder
    FROM dbo.WBT_ProjectTrackingFieldConfig
    WHERE ProjectID = @ProjectID
        AND IsDeleted = 0
        AND ISNULL(IsBillingField, 0) = 0
)
UPDATE f
SET DisplayOrder = o.NewDisplayOrder
FROM dbo.WBT_ProjectTrackingFieldConfig f
INNER JOIN OrderedFields o ON o.FieldConfigId = f.FieldConfigId
WHERE f.DisplayOrder <> o.NewDisplayOrder;", connection))
            {
                cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                connection.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private static int GetFieldDisplayOrder(SqlConnection connection, SqlTransaction transaction, int projectId, int fieldConfigId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
SELECT ISNULL(MAX(DisplayOrder), 0)
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @ProjectID
    AND FieldConfigId = @FieldConfigId
    AND IsDeleted = 0
    AND ISNULL(IsBillingField, 0) = 0;", connection, transaction))
            {
                cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                cmd.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = fieldConfigId;
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private static int GetSwapFieldConfigId(SqlConnection connection, SqlTransaction transaction, int projectId, int currentOrder, string direction)
        {
            bool moveUp = string.Equals(direction, "up", StringComparison.OrdinalIgnoreCase);
            string sql = moveUp
                ? @"
SELECT TOP 1 FieldConfigId
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @ProjectID
    AND IsDeleted = 0
    AND ISNULL(IsBillingField, 0) = 0
    AND DisplayOrder < @CurrentOrder
ORDER BY DisplayOrder DESC, FieldConfigId DESC;"
                : @"
SELECT TOP 1 FieldConfigId
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @ProjectID
    AND IsDeleted = 0
    AND ISNULL(IsBillingField, 0) = 0
    AND DisplayOrder > @CurrentOrder
ORDER BY DisplayOrder ASC, FieldConfigId ASC;";

            using (SqlCommand cmd = new SqlCommand(sql, connection, transaction))
            {
                cmd.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                cmd.Parameters.Add("@CurrentOrder", SqlDbType.Int).Value = currentOrder;

                object value = cmd.ExecuteScalar();
                return value == null || value == DBNull.Value ? 0 : Convert.ToInt32(value);
            }
        }

        private static void SetFieldDisplayOrder(SqlConnection connection, SqlTransaction transaction, int fieldConfigId, int displayOrder, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
UPDATE dbo.WBT_ProjectTrackingFieldConfig
SET DisplayOrder = @DisplayOrder,
    UpdatedBy = @UserID,
    UpdatedDate = GETDATE()
WHERE FieldConfigId = @FieldConfigId
    AND IsDeleted = 0;", connection, transaction))
            {
                cmd.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = fieldConfigId;
                cmd.Parameters.Add("@DisplayOrder", SqlDbType.Int).Value = displayOrder;
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                cmd.ExecuteNonQuery();
            }
        }

        private static int SaveRowHeader(SqlConnection connection, SqlTransaction transaction, int projectId, int rowId, DateTime entryDate, int userId)
        {
            if (rowId > 0)
            {
                using (SqlCommand update = new SqlCommand(@"
UPDATE dbo.WBT_ProjectTrackingSheetRows
SET EntryDate = @EntryDate,
    UpdatedBy = @UserID,
    UpdatedDate = GETDATE()
WHERE RowId = @RowId
    AND ProjectID = @ProjectID
    AND IsDeleted = 0;", connection, transaction))
                {
                    update.Parameters.Add("@RowId", SqlDbType.Int).Value = rowId;
                    update.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                    update.Parameters.Add("@EntryDate", SqlDbType.Date).Value = entryDate.Date;
                    update.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;

                    if (update.ExecuteNonQuery() > 0)
                    {
                        return rowId;
                    }
                }
            }

            using (SqlCommand insert = new SqlCommand(@"
INSERT INTO dbo.WBT_ProjectTrackingSheetRows (ProjectID, EntryDate, AddedBy, AddedDate, IsDeleted)
OUTPUT INSERTED.RowId
VALUES (@ProjectID, @EntryDate, @UserID, GETDATE(), 0);", connection, transaction))
            {
                insert.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                insert.Parameters.Add("@EntryDate", SqlDbType.Date).Value = entryDate.Date;
                insert.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                return Convert.ToInt32(insert.ExecuteScalar());
            }
        }

        private static void SaveValues(SqlConnection connection, SqlTransaction transaction, int rowId, DataTable values)
        {
            if (values == null)
            {
                return;
            }

            foreach (DataRow valueRow in values.Rows)
            {
                using (SqlCommand valueCommand = new SqlCommand(@"
IF EXISTS (SELECT 1 FROM dbo.WBT_ProjectTrackingSheetValues WHERE RowId = @RowId AND FieldConfigId = @FieldConfigId)
BEGIN
    UPDATE dbo.WBT_ProjectTrackingSheetValues
    SET FieldValue = @FieldValue,
        UpdatedDate = GETDATE()
    WHERE RowId = @RowId
        AND FieldConfigId = @FieldConfigId;
END
ELSE
BEGIN
    INSERT INTO dbo.WBT_ProjectTrackingSheetValues (RowId, FieldConfigId, FieldValue, AddedDate)
    VALUES (@RowId, @FieldConfigId, @FieldValue, GETDATE());
END;", connection, transaction))
                {
                    valueCommand.Parameters.Add("@RowId", SqlDbType.Int).Value = rowId;
                    valueCommand.Parameters.Add("@FieldConfigId", SqlDbType.Int).Value = Convert.ToInt32(valueRow["FieldConfigId"]);
                    valueCommand.Parameters.Add("@FieldValue", SqlDbType.NVarChar, -1).Value = Convert.ToString(valueRow["FieldValue"]);
                    valueCommand.ExecuteNonQuery();
                }
            }
        }

        private static void EnsureTables()
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.WBT_ProjectTrackingFieldConfig
    (
        FieldConfigId int IDENTITY(1,1) NOT NULL CONSTRAINT PK_WBT_ProjectTrackingFieldConfig PRIMARY KEY,
        ProjectID int NOT NULL,
        FieldName nvarchar(200) NOT NULL,
        DataType nvarchar(30) NOT NULL,
        OptionsText nvarchar(max) NULL,
        IsRequired bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsRequired DEFAULT (0),
        IsUniqueField bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsUniqueField DEFAULT (0),
        IsVisible bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsVisible DEFAULT (1),
        IsEditable bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsEditable DEFAULT (1),
        IsForBilling bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsForBilling DEFAULT (0),
        IsBillingParameter bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsBillingParameter DEFAULT (0),
        DateFormat nvarchar(30) NULL,
        DisplayOrder int NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_DisplayOrder DEFAULT (0),
        IsProcessColumn bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsProcessColumn DEFAULT (0),
        ParentProcessFieldConfigId int NULL,
        ProcessChildType nvarchar(30) NULL,
        IsSystemGenerated bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsSystemGenerated DEFAULT (0),
        IsBillingField bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsBillingField DEFAULT (0),
        AddedBy int NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_AddedDate DEFAULT (GETDATE()),
        UpdatedBy int NULL,
        UpdatedDate datetime NULL,
        IsDeleted bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsDeleted DEFAULT (0)
    );
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NOT NULL AND COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig', 'IsProcessColumn') IS NULL
BEGIN
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig ADD IsProcessColumn bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsProcessColumn DEFAULT (0) WITH VALUES;
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NOT NULL AND COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig', 'IsUniqueField') IS NULL
BEGIN
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig ADD IsUniqueField bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsUniqueField DEFAULT (0) WITH VALUES;
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NOT NULL AND COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig', 'ParentProcessFieldConfigId') IS NULL
BEGIN
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig ADD ParentProcessFieldConfigId int NULL;
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NOT NULL AND COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig', 'ProcessChildType') IS NULL
BEGIN
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig ADD ProcessChildType nvarchar(30) NULL;
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NOT NULL AND COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig', 'IsSystemGenerated') IS NULL
BEGIN
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig ADD IsSystemGenerated bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsSystemGenerated DEFAULT (0) WITH VALUES;
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NOT NULL AND COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig', 'IsBillingField') IS NULL
BEGIN
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig ADD IsBillingField bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsBillingField DEFAULT (0) WITH VALUES;
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NOT NULL AND COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig', 'IsForBilling') IS NULL
BEGIN
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig ADD IsForBilling bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsForBilling DEFAULT (0) WITH VALUES;
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NOT NULL AND COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig', 'IsBillingParameter') IS NULL
BEGIN
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig ADD IsBillingParameter bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingFieldConfig_IsBillingParameter DEFAULT (0) WITH VALUES;
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NOT NULL AND COL_LENGTH('dbo.WBT_ProjectTrackingFieldConfig', 'DateFormat') IS NULL
BEGIN
    ALTER TABLE dbo.WBT_ProjectTrackingFieldConfig ADD DateFormat nvarchar(30) NULL;
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig', 'U') IS NOT NULL
BEGIN
    UPDATE dbo.WBT_ProjectTrackingFieldConfig
    SET IsVisible = 1,
        IsEditable = 1
    WHERE IsDeleted = 0
        AND IsProcessColumn = 1
        AND DataType = 'Process'
        AND (IsVisible = 0 OR IsEditable = 0);
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingSheetRows', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.WBT_ProjectTrackingSheetRows
    (
        RowId int IDENTITY(1,1) NOT NULL CONSTRAINT PK_WBT_ProjectTrackingSheetRows PRIMARY KEY,
        ProjectID int NOT NULL,
        EntryDate date NOT NULL,
        AddedBy int NOT NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_WBT_ProjectTrackingSheetRows_AddedDate DEFAULT (GETDATE()),
        UpdatedBy int NULL,
        UpdatedDate datetime NULL,
        IsDeleted bit NOT NULL CONSTRAINT DF_WBT_ProjectTrackingSheetRows_IsDeleted DEFAULT (0)
    );
END;

IF OBJECT_ID('dbo.WBT_ProjectTrackingSheetValues', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.WBT_ProjectTrackingSheetValues
    (
        RowValueId int IDENTITY(1,1) NOT NULL CONSTRAINT PK_WBT_ProjectTrackingSheetValues PRIMARY KEY,
        RowId int NOT NULL,
        FieldConfigId int NOT NULL,
        FieldValue nvarchar(max) NULL,
        AddedDate datetime NOT NULL CONSTRAINT DF_WBT_ProjectTrackingSheetValues_AddedDate DEFAULT (GETDATE()),
        UpdatedDate datetime NULL,
        CONSTRAINT FK_WBT_ProjectTrackingSheetValues_Rows FOREIGN KEY (RowId)
            REFERENCES dbo.WBT_ProjectTrackingSheetRows (RowId)
    );
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_WBT_ProjectTrackingFieldConfig_Project' AND object_id = OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig'))
BEGIN
    CREATE INDEX IX_WBT_ProjectTrackingFieldConfig_Project
    ON dbo.WBT_ProjectTrackingFieldConfig (ProjectID, IsDeleted, DisplayOrder);
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_WBT_ProjectTrackingFieldConfig_ParentProcess' AND object_id = OBJECT_ID('dbo.WBT_ProjectTrackingFieldConfig'))
BEGIN
    EXEC('CREATE INDEX IX_WBT_ProjectTrackingFieldConfig_ParentProcess ON dbo.WBT_ProjectTrackingFieldConfig (ParentProcessFieldConfigId, ProcessChildType, IsDeleted);');
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_WBT_ProjectTrackingSheetRows_ProjectDate' AND object_id = OBJECT_ID('dbo.WBT_ProjectTrackingSheetRows'))
BEGIN
    CREATE INDEX IX_WBT_ProjectTrackingSheetRows_ProjectDate
    ON dbo.WBT_ProjectTrackingSheetRows (ProjectID, EntryDate, IsDeleted);
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_WBT_ProjectTrackingSheetValues_RowField' AND object_id = OBJECT_ID('dbo.WBT_ProjectTrackingSheetValues'))
BEGIN
    CREATE UNIQUE INDEX UX_WBT_ProjectTrackingSheetValues_RowField
    ON dbo.WBT_ProjectTrackingSheetValues (RowId, FieldConfigId);
END;", connection))
            {
                connection.Open();
                cmd.CommandTimeout = 0;
                cmd.ExecuteNonQuery();
            }
        }

        private class ProcessChildField
        {
            public ProcessChildField(string childType, string suffix, string dataType, string optionsText)
            {
                ChildType = childType;
                Suffix = suffix;
                DataType = dataType;
                OptionsText = optionsText;
            }

            public string ChildType { get; private set; }
            public string Suffix { get; private set; }
            public string DataType { get; private set; }
            public string OptionsText { get; private set; }
        }

        private class BillingSystemField
        {
            public BillingSystemField(string fieldName, string dataType, int displayOrder)
            {
                FieldName = fieldName;
                DataType = dataType;
                DisplayOrder = displayOrder;
            }

            public string FieldName { get; private set; }
            public string DataType { get; private set; }
            public int DisplayOrder { get; private set; }
        }
    }
}
