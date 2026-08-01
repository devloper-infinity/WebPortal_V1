using System;
using System.Data;
using System.Data.SqlClient;

namespace WebPortal.App_Code.DAL
{
    public sealed class dalOLMonthlyBilling
    {
        public DataTable GetFields(int projectId)
        {
            EnsureSchema();
            using (SqlCommand command = new SqlCommand(@"
SELECT FieldConfigId, FieldName, DataType, DateFormat, DisplayOrder
FROM dbo.WBT_ProjectTrackingFieldConfig
WHERE ProjectID = @ProjectID AND IsDeleted = 0 AND ISNULL(IsBillingField, 0) = 0
  AND (ISNULL(IsForBilling, 0) = 1 OR ISNULL(IsBillingParameter, 0) = 1)
ORDER BY DisplayOrder, FieldConfigId;"))
            {
                command.Connection = new SqlConnection(SQLHelper.ConnectionString);
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                using (SqlDataAdapter adapter = new SqlDataAdapter(command)) { DataTable table = new DataTable(); adapter.Fill(table); return table; }
            }
        }

        public DataTable GetRows(int projectId, int month, int year, bool sentHistory)
        {
            EnsureSchema();
            string historyClause = sentHistory ? "AND ISNULL(m.IsSentToAccounts, 0) = 1" : string.Empty;
            using (SqlCommand command = new SqlCommand(@"
;WITH DispatchRecords AS
(
    SELECT i.ItemID, i.ProjectID, i.DealNumber, i.ItemNumber, batchDates.EntryDate,
           CASE
               WHEN ISDATE(NULLIF(LTRIM(RTRIM(dispatchValue.FieldValue)), '')) = 1
               THEN CONVERT(datetime, NULLIF(LTRIM(RTRIM(dispatchValue.FieldValue)), ''))
               ELSE NULL
           END AS DispatchDate
    FROM dbo.OLTracking_Item i
    INNER JOIN (SELECT DISTINCT ItemID, EntryDate FROM dbo.OLTracking_ImportBatchItem) batchDates ON batchDates.ItemID = i.ItemID
    INNER JOIN dbo.WBT_ProjectTrackingFieldConfig dispatchField
        ON dispatchField.ProjectID = i.ProjectID AND dispatchField.IsDeleted = 0
       AND ISNULL(dispatchField.IsBillingField, 0) = 0
       AND LOWER(REPLACE(REPLACE(REPLACE(REPLACE(dispatchField.FieldName, ' ', ''), '#', ''), '-', ''), '_', '')) = 'dispatchdate'
    INNER JOIN dbo.OLTracking_ImportItemValue dispatchValue
        ON dispatchValue.ItemID = i.ItemID AND dispatchValue.FieldConfigId = dispatchField.FieldConfigId
    WHERE i.ProjectID = @ProjectID AND i.IsDeleted = 0
)
SELECT d.ItemID, d.DealNumber, d.ItemNumber, d.EntryDate, d.DispatchDate,
       field.FieldConfigId, value.FieldValue,
       CONVERT(bit, ISNULL(m.IsVerified, 0)) AS IsVerified,
       LTRIM(RTRIM(ISNULL(verifiedUser.FirstName, '') + ' ' + ISNULL(verifiedUser.LastName, ''))) AS VerifiedBy,
       m.VerifiedDate,
       CONVERT(bit, ISNULL(m.IsSentToAccounts, 0)) AS IsSentToAccounts,
       LTRIM(RTRIM(ISNULL(sentUser.FirstName, '') + ' ' + ISNULL(sentUser.LastName, ''))) AS SentToAccountsBy,
       m.SentToAccountsDate
FROM DispatchRecords d
LEFT JOIN dbo.OLTracking_MonthlyBilling m
    ON m.ProjectID = d.ProjectID AND m.ItemID = d.ItemID AND m.OrderDate = d.EntryDate
   AND m.BillingMonth = @BillingMonth AND m.BillingYear = @BillingYear
LEFT JOIN dbo.EmployeeInfo verifiedUser ON verifiedUser.EmployeeID = m.VerifiedBy
LEFT JOIN dbo.EmployeeInfo sentUser ON sentUser.EmployeeID = m.SentToAccountsBy
LEFT JOIN dbo.OLTracking_ImportItemValue value ON value.ItemID = d.ItemID
LEFT JOIN dbo.WBT_ProjectTrackingFieldConfig field
    ON field.FieldConfigId = value.FieldConfigId AND field.ProjectID = d.ProjectID
   AND field.IsDeleted = 0 AND ISNULL(field.IsBillingField, 0) = 0
   AND (ISNULL(field.IsForBilling, 0) = 1 OR ISNULL(field.IsBillingParameter, 0) = 1)
WHERE d.DispatchDate IS NOT NULL
  AND MONTH(d.DispatchDate) = @BillingMonth AND YEAR(d.DispatchDate) = @BillingYear
  " + historyClause + @"
ORDER BY d.DispatchDate, d.ItemID, d.EntryDate, field.DisplayOrder, field.FieldConfigId;"))
            {
                command.Connection = new SqlConnection(SQLHelper.ConnectionString);
                AddPeriodParameters(command, projectId, month, year);
                using (SqlDataAdapter adapter = new SqlDataAdapter(command)) { DataTable table = new DataTable(); adapter.Fill(table); return table; }
            }
        }

        public int Verify(int projectId, int month, int year, DataTable selections, int userId)
        {
            ValidatePeriod(projectId, month, year, userId);
            if (selections == null || selections.Rows.Count == 0) throw new InvalidOperationException("Select at least one record to verify.");
            EnsureSchema(); int verified = 0;
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        foreach (DataRow row in selections.Rows)
                        {
                            long itemId = Convert.ToInt64(row["ItemID"]); DateTime orderDate = Convert.ToDateTime(row["OrderDate"]).Date;
                            EnsureRecordInPeriod(connection, transaction, projectId, itemId, orderDate, month, year);
                            using (SqlCommand command = new SqlCommand(@"
MERGE dbo.OLTracking_MonthlyBilling WITH (HOLDLOCK) AS target
USING (SELECT @ProjectID ProjectID, @ItemID ItemID, @OrderDate OrderDate, @BillingMonth BillingMonth, @BillingYear BillingYear) source
ON target.ProjectID = source.ProjectID AND target.ItemID = source.ItemID AND target.OrderDate = source.OrderDate
AND target.BillingMonth = source.BillingMonth AND target.BillingYear = source.BillingYear
WHEN MATCHED AND target.IsSentToAccounts = 0 AND target.IsVerified = 0 THEN
    UPDATE SET IsVerified = 1, VerifiedBy = @UserID, VerifiedDate = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (ProjectID, ItemID, OrderDate, BillingMonth, BillingYear, IsVerified, VerifiedBy, VerifiedDate, IsSentToAccounts, AddedBy, AddedDate)
    VALUES (@ProjectID, @ItemID, @OrderDate, @BillingMonth, @BillingYear, 1, @UserID, GETDATE(), 0, @UserID, GETDATE());
SELECT @@ROWCOUNT;", connection, transaction))
                            {
                                AddActionParameters(command, projectId, itemId, orderDate, month, year, userId);
                                verified += Convert.ToInt32(command.ExecuteScalar());
                            }
                        }
                        transaction.Commit(); return verified;
                    }
                    catch { transaction.Rollback(); throw; }
                }
            }
        }

        public int SendToAccounts(int projectId, int month, int year, int userId)
        {
            ValidatePeriod(projectId, month, year, userId); EnsureSchema();
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
UPDATE dbo.OLTracking_MonthlyBilling
SET IsSentToAccounts = 1, SentToAccountsBy = @UserID, SentToAccountsDate = GETDATE()
WHERE ProjectID = @ProjectID AND BillingMonth = @BillingMonth AND BillingYear = @BillingYear
  AND IsVerified = 1 AND IsSentToAccounts = 0;", connection))
            {
                AddPeriodParameters(command, projectId, month, year); command.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                connection.Open(); int count = command.ExecuteNonQuery();
                if (count == 0) throw new InvalidOperationException("There are no verified records pending for Accounts in this billing period.");
                return count;
            }
        }

        private static void EnsureRecordInPeriod(SqlConnection connection, SqlTransaction transaction, int projectId, long itemId, DateTime orderDate, int month, int year)
        {
            using (SqlCommand command = new SqlCommand(@"
IF EXISTS
(
    SELECT 1 FROM dbo.OLTracking_MonthlyBilling
    WHERE ProjectID=@ProjectID AND ItemID=@ItemID AND OrderDate=@OrderDate
      AND BillingMonth=@BillingMonth AND BillingYear=@BillingYear AND IsSentToAccounts=1
)
BEGIN
    RAISERROR('A selected record has already been sent to Accounts.', 16, 1);
    RETURN;
END;
IF NOT EXISTS
(
    SELECT 1
    FROM dbo.OLTracking_Item i
    INNER JOIN dbo.OLTracking_ImportBatchItem bi ON bi.ItemID=i.ItemID AND bi.EntryDate=@OrderDate
    INNER JOIN dbo.WBT_ProjectTrackingFieldConfig f ON f.ProjectID=i.ProjectID AND f.IsDeleted=0
      AND LOWER(REPLACE(REPLACE(REPLACE(REPLACE(f.FieldName,' ',''),'#',''),'-',''),'_',''))='dispatchdate'
    INNER JOIN dbo.OLTracking_ImportItemValue v ON v.ItemID=i.ItemID AND v.FieldConfigId=f.FieldConfigId
    WHERE i.ProjectID=@ProjectID AND i.ItemID=@ItemID AND i.IsDeleted=0
      AND MONTH(CASE WHEN ISDATE(NULLIF(LTRIM(RTRIM(v.FieldValue)),''))=1
                     THEN CONVERT(datetime,NULLIF(LTRIM(RTRIM(v.FieldValue)),'')) ELSE NULL END)=@BillingMonth
      AND YEAR(CASE WHEN ISDATE(NULLIF(LTRIM(RTRIM(v.FieldValue)),''))=1
                    THEN CONVERT(datetime,NULLIF(LTRIM(RTRIM(v.FieldValue)),'')) ELSE NULL END)=@BillingYear
)
BEGIN
    RAISERROR('A selected record is no longer valid for this billing period.', 16, 1);
    RETURN;
END;", connection, transaction))
            {
                AddActionParameters(command, projectId, itemId, orderDate, month, year, 0); command.Parameters.Remove(command.Parameters["@UserID"]); command.ExecuteNonQuery();
            }
        }

        private static void AddPeriodParameters(SqlCommand command, int projectId, int month, int year)
        {
            command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
            command.Parameters.Add("@BillingMonth", SqlDbType.TinyInt).Value = month;
            command.Parameters.Add("@BillingYear", SqlDbType.SmallInt).Value = year;
        }
        private static void AddActionParameters(SqlCommand command, int projectId, long itemId, DateTime orderDate, int month, int year, int userId)
        {
            AddPeriodParameters(command, projectId, month, year); command.Parameters.Add("@ItemID", SqlDbType.BigInt).Value = itemId;
            command.Parameters.Add("@OrderDate", SqlDbType.Date).Value = orderDate; command.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
        }
        private static void ValidatePeriod(int projectId, int month, int year, int userId)
        {
            if (projectId <= 0 || month < 1 || month > 12 || year < 2000 || year > 9999) throw new ArgumentException("Select a valid project, billing month, and billing year.");
            if (userId <= 0) throw new InvalidOperationException("Your user session is invalid. Please sign in again.");
        }

        private static void EnsureSchema()
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
IF OBJECT_ID('dbo.OLTracking_MonthlyBilling','U') IS NULL
BEGIN
    CREATE TABLE dbo.OLTracking_MonthlyBilling
    (
        MonthlyBillingID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OLTracking_MonthlyBilling PRIMARY KEY,
        ProjectID int NOT NULL, ItemID bigint NOT NULL, OrderDate date NOT NULL,
        BillingMonth tinyint NOT NULL, BillingYear smallint NOT NULL,
        IsVerified bit NOT NULL CONSTRAINT DF_OLTracking_MonthlyBilling_IsVerified DEFAULT(0),
        VerifiedBy int NULL, VerifiedDate datetime NULL,
        IsSentToAccounts bit NOT NULL CONSTRAINT DF_OLTracking_MonthlyBilling_IsSent DEFAULT(0),
        SentToAccountsBy int NULL, SentToAccountsDate datetime NULL,
        AddedBy int NOT NULL, AddedDate datetime NOT NULL CONSTRAINT DF_OLTracking_MonthlyBilling_AddedDate DEFAULT(GETDATE()),
        CONSTRAINT FK_OLTracking_MonthlyBilling_Item FOREIGN KEY(ItemID) REFERENCES dbo.OLTracking_Item(ItemID),
        CONSTRAINT UQ_OLTracking_MonthlyBilling_Record UNIQUE(ProjectID,ItemID,OrderDate,BillingMonth,BillingYear),
        CONSTRAINT CK_OLTracking_MonthlyBilling_Month CHECK(BillingMonth BETWEEN 1 AND 12)
    );
    CREATE INDEX IX_OLTracking_MonthlyBilling_Period ON dbo.OLTracking_MonthlyBilling(ProjectID,BillingYear,BillingMonth,IsSentToAccounts,IsVerified);
END;", connection))
            { connection.Open(); command.ExecuteNonQuery(); }
        }
    }
}
