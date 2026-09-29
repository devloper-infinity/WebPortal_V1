using System;
using System.Data;
using System.Data.SqlClient;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code
{
    public sealed class PendingRemarkInput
    {
        public int ProjectID { get; set; }
        public string OrderNo { get; set; }
        public string Remark { get; set; }
    }

    public sealed class PendingDataRepository
    {
        private static SqlConnection Open()
        {
            var connection = new SqlConnection(SQLHelper.ConnectionString);
            connection.Open();
            return connection;
        }

        private static DataTable Fill(SqlCommand command)
        {
            var table = new DataTable();
            using (var adapter = new SqlDataAdapter(command)) adapter.Fill(table);
            return table;
        }

        public DataTable GetPending(int employeeId)
        {
            using (var connection = Open())
            using (var command = new SqlCommand("dbo.usp_getPendingProjects", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 180;
                command.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                return Fill(command);
            }
        }

        public bool HasPending(int employeeId)
        {
            return GetPending(employeeId).Rows.Count != 0;
        }

        public void AddRemark(int employeeId, PendingRemarkInput input)
        {
            if (input == null || input.ProjectID <= 0 || String.IsNullOrWhiteSpace(input.OrderNo))
                throw new ArgumentException("A valid project and order/loan are required.");
            string remark = (input.Remark ?? String.Empty).Trim();
            if (remark.Length < 3 || remark.Length > 1000)
                throw new ArgumentException("Remark must be between 3 and 1000 characters.");

            using (var connection = Open())
            using (var command = new SqlCommand("dbo.usp_AddPendingDataRemark", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = input.ProjectID;
                command.Parameters.Add("@OrderNo", SqlDbType.NVarChar, 100).Value = input.OrderNo.Trim();
                command.Parameters.Add("@Remark", SqlDbType.NVarChar, 1000).Value = remark;
                command.Parameters.Add("@AddedBy", SqlDbType.Int).Value = employeeId;
                command.ExecuteNonQuery();
            }
        }

        public DataTable GetHistory(int employeeId, int projectId, string orderNo)
        {
            if (projectId <= 0 || String.IsNullOrWhiteSpace(orderNo))
                throw new ArgumentException("A valid project and order/loan are required.");
            using (var connection = Open())
            using (var command = new SqlCommand("dbo.usp_GetPendingDataRemarkHistory", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                command.Parameters.Add("@OrderNo", SqlDbType.NVarChar, 100).Value = orderNo.Trim();
                return Fill(command);
            }
        }
    }
}
