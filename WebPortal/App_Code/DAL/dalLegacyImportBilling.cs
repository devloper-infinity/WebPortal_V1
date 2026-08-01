using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace WebPortal.App_Code.DAL
{
    public sealed class dalLegacyImportBilling
    {
        public DataTable GetHistory(int projectId, string billingPeriod)
        {
            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetFreightBilledData");
            SQLHelper.AddParamToSQLCmd(command, "@projectId", SqlDbType.BigInt, 10, ParameterDirection.Input, projectId);
            SQLHelper.AddParamToSQLCmd(command, "@BillingPeriod", SqlDbType.NVarChar, 1000, ParameterDirection.Input, billingPeriod);
            return SQLHelper.ExecuteDataTableCmd_Billing(command);
        }

        public int Send(int projectId, string projectName, string billingPeriod, string billingCycle, int userId, DataTable rows)
        {
            BillingTable table = BillingTable.For(projectName);
            if (table == null) throw new InvalidOperationException("Billing import is not configured for project " + projectName + ".");
            if (rows == null || rows.Rows.Count == 0) throw new InvalidOperationException("There are no imported records to send.");
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionStringWBTBilling))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        if (table.Special712) Send712(connection, transaction, projectId, billingPeriod, userId, rows);
                        else { BulkSend(connection, transaction, table, projectId, billingPeriod, rows); InsertBillingHeader(connection, transaction, projectId, billingPeriod, billingCycle, userId); }
                        transaction.Commit(); return rows.Rows.Count;
                    }
                    catch { transaction.Rollback(); throw; }
                }
            }
        }

        private static void BulkSend(SqlConnection connection, SqlTransaction transaction, BillingTable table, int projectId, string billingPeriod, DataTable source)
        {
            DataTable rows = source.Copy();
            rows.Columns.Add("ProjectId", typeof(int)); rows.Columns.Add("IsVerify", typeof(bool)); rows.Columns.Add("BillingPeriod", typeof(string)); rows.Columns.Add("BillingAddedDate", typeof(DateTime));
            foreach (DataRow row in rows.Rows) { row["ProjectId"] = projectId; row["IsVerify"] = true; row["BillingPeriod"] = billingPeriod; row["BillingAddedDate"] = DateTime.Now; }
            using (SqlBulkCopy bulk = new SqlBulkCopy(connection, SqlBulkCopyOptions.CheckConstraints, transaction))
            {
                bulk.DestinationTableName = table.TableName; bulk.BulkCopyTimeout = 180;
                bulk.ColumnMappings.Add("ProjectId", "ProjectId"); bulk.ColumnMappings.Add("IsVerify", "IsVerify"); bulk.ColumnMappings.Add("BillingPeriod", "BillingPeriod"); bulk.ColumnMappings.Add("BillingAddedDate", "BillingAddedDate");
                foreach (KeyValuePair<string, string> map in table.Mappings) bulk.ColumnMappings.Add(map.Key, map.Value);
                bulk.WriteToServer(rows);
            }
        }

        private static void Send712(SqlConnection connection, SqlTransaction transaction, int projectId, string billingPeriod, int userId, DataTable rows)
        {
            foreach (DataRow row in rows.Rows)
            using (SqlCommand command = new SqlCommand("usp_InsertOtherBilling_712", connection, transaction))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ProjectID", SqlDbType.BigInt).Value = projectId; command.Parameters.Add("@BillingPeriod", SqlDbType.NVarChar, 1000).Value = billingPeriod; command.Parameters.Add("@AddedBy", SqlDbType.BigInt).Value = userId;
                command.Parameters.Add("@Date", SqlDbType.NVarChar, 4000).Value = Text(row, "Date"); command.Parameters.Add("@FolderName", SqlDbType.NVarChar, 4000).Value = Text(row, "Folder Name"); command.Parameters.Add("@PDFNo", SqlDbType.NVarChar, 4000).Value = Text(row, "PDF No"); command.Parameters.Add("@InvoiceNo", SqlDbType.NVarChar, 1000).Value = Text(row, "Invoice No"); command.Parameters.Add("@IS", SqlDbType.NVarChar, 4000).Value = Text(row, "International/Standard");
                SqlParameter result = command.Parameters.Add("@ReturnValue", SqlDbType.BigInt); result.Direction = ParameterDirection.ReturnValue; command.ExecuteNonQuery();
                if (result.Value == DBNull.Value || Convert.ToInt32(result.Value) <= 0) throw new InvalidOperationException("Billing could not be sent for one or more imported rows.");
            }
        }

        private static void InsertBillingHeader(SqlConnection connection, SqlTransaction transaction, int projectId, string billingPeriod, string billingCycle, int userId)
        {
            using (SqlCommand command = new SqlCommand("usp_InsertOtherBilling_Gen", connection, transaction))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ProjectID", SqlDbType.BigInt).Value = projectId; command.Parameters.Add("@BillingPeriod", SqlDbType.NVarChar, 1000).Value = billingPeriod; command.Parameters.Add("@BillingCycle", SqlDbType.NVarChar, 100).Value = billingCycle; command.Parameters.Add("@AddedBy", SqlDbType.BigInt).Value = userId;
                SqlParameter result = command.Parameters.Add("@ReturnValue", SqlDbType.BigInt); result.Direction = ParameterDirection.ReturnValue; command.ExecuteNonQuery();
                if (result.Value != DBNull.Value && Convert.ToInt32(result.Value) < 0) throw new InvalidOperationException("The billing header could not be created.");
            }
        }

        private static string Text(DataRow row, string column) { return row.Table.Columns.Contains(column) && row[column] != DBNull.Value ? Convert.ToString(row[column]).Trim() : string.Empty; }

        internal sealed class BillingTable
        {
            public string TableName; public bool Special712; public List<KeyValuePair<string, string>> Mappings = new List<KeyValuePair<string, string>>();
            public string[] Headers { get { List<string> value = new List<string>(); foreach (KeyValuePair<string, string> map in Mappings) value.Add(map.Key); return value.ToArray(); } }
            private static BillingTable T(string name, params string[] maps) { BillingTable t = new BillingTable { TableName = name }; for (int i = 0; i < maps.Length; i += 2) t.Mappings.Add(new KeyValuePair<string, string>(maps[i], maps[i + 1])); return t; }
            public static BillingTable For(string project)
            {
                switch ((project ?? "").Trim().ToUpperInvariant())
                {
                    case "712": return new BillingTable { Special712 = true, Mappings = new List<KeyValuePair<string, string>> { P("Date"), P("Folder Name"), P("PDF No"), P("Invoice No"), P("International/Standard") } };
                    case "722-001": return T("dbo.InfinityBilling_OtherBilling_722001", "Batch No", "Batch No", "Received Date", "Received Date", "Dispatched Date", "Dispatched Date", "Invoices Delivered", "Invoices Delivered", "Status", "Status");
                    case "791-002": return T("dbo.InfinityBilling_OtherBilling_791002", "File Name", "File Name", "Received Date", "Received Date", "Dispatch Date", "Dispatch Date", "Time Taken", "Time Taken");
                    case "772": return T("dbo.InfinityBilling_OtherBilling_772", "Name of Client", "Name of Client", "Infinity ship# #", "Infinity ship# #", "Received Date", "Received Date", "Dispatched Date", "Dispatched Date", "No of Records", "No of Records", "Status", "Status", "Remark", "Remark");
                    case "791": return T("dbo.InfinityBilling_OtherBilling_791", "Date", "Date", "Client Name", "Client Name", "Invoice No", "Invoice No", "SCAC", "SCAC", "International/Standard", "International/Standard");
                    case "736": return T("dbo.InfinityBilling_OtherBilling_736", "Image File Name", "Image File Name", "Received Date", "Received Date", "Dispatched Date", "Dispatched Date", "No of Invoices Delivered", "No of Invoices Delivered", "Status", "Status");
                    case "736-002": return T("dbo.InfinityBilling_OtherBilling_736002", "Image File Name", "Image File Name", "Received Date", "Received Date", "Dispatched Date", "Dispatched Date", "No of Invoices Delivered", "No of Invoices Delivered", "Status", "Status");
                    case "757-003": return T("dbo.InfinityBilling_OtherBilling_757003", "Client ID", "Client ID", "Client Name", "Client Name", "ProNumber", "ProNumber", "SCACCode", "SCACCode", "InfinityProcessDate", "InfinityProcessDate", "Invoice Type", "Invoice Type", "Process", "Process", "LoginUser", "LoginUser", "DECode", "DECode", "Status", "Status", "Remark", "Remark");
                    case "771": return T("dbo.InfinityBilling_OtherBilling_771", "Batch #", "Batch #", "Invoice #", "Invoice #", "Company Name", "Company Name", "Carrier Name", "Carrier Name", "Received Date", "Received Date", "Dispatched Date", "Dispatched Date", "No of Pages", "No of Pages", "No of Records", "No of Records", "Status", "Status", "Received Type", "Received Type", "Remarks", "Remarks");
                    case "861-007": return T("dbo.InfinityBilling_OtherBilling_861007", "SrNo", "SrNo", "ReceivedDate", "ReceivedDate", "BallotsReceived", "BallotsReceived", "BallotsDispatched", "BallotsDispatched", "BallotsCancelled", "BallotsCancelled", "DispatchedDate", "DispatchedDate");
                    case "572": return T("dbo.InfinityBilling_OtherBilling_572", "Client", "Client", "Date", "Date", "Records", "Records");
                    case "1009-003": return T("dbo.InfinityBilling_OtherBilling_1009003", "Order#", "Order#", "orderDate", "orderDate", "Process", "Process", "ProductType", "ProductType", "DispatchedDate", "DispatchedDate", "FinalStatus", "FinalStatus");
                    case "733-004": return T("dbo.InfinityBilling_OtherBilling_733004", "Date", "Date", "BatchName", "Batch Name", "Batchsheet", "Batch sheet");
                    case "694-006":
                        BillingTable search = T("dbo.InfinityBilling_OtherBilling_694006", "ReceivedDate", "ReceivedDate", "Order#", "Order#", "Online", "Online");
                        for (int i = 1; i <= 30; i++) { string source = i == 1 ? "1stSearch" : i == 2 ? "2ndSearch" : i == 3 ? "3rdSearch" : i == 23 ? "23ndSearch" : i + "thSearch"; search.Mappings.Add(new KeyValuePair<string, string>(source, "[" + source + "]")); } return search;
                    default: return null;
                }
            }
            private static KeyValuePair<string, string> P(string value) { return new KeyValuePair<string, string>(value, value); }
        }
    }
}
