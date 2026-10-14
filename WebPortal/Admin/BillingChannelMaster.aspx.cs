using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class BillingChannelMaster : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod(EnableSession = true)]
        public static BillingChannelLoadResponse GetChannels()
        {
            try
            {
                GetCurrentEmployeeID();
                BillingChannelLoadResponse response = new BillingChannelLoadResponse { Success = true };
                using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionStringUWBilling))
                using (SqlCommand command = new SqlCommand("dbo.usp_getAllChannels", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    Dictionary<int, List<BillingChannelRow>> rowsByEmployeeId = new Dictionary<int, List<BillingChannelRow>>();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            DateTime addedDate = reader["AddedDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(reader["AddedDate"], CultureInfo.InvariantCulture);
                            int addedById = reader["AddedBy"] == DBNull.Value ? 0 : Convert.ToInt32(reader["AddedBy"], CultureInfo.InvariantCulture);
                            BillingChannelRow channelRow = new BillingChannelRow
                            {
                                ChannelID = Convert.ToInt32(reader["ChannelID"], CultureInfo.InvariantCulture),
                                Channel = Convert.ToString(reader["Channel"], CultureInfo.InvariantCulture),
                                CleanLoan = Convert.ToString(reader["CleanLoan"], CultureInfo.InvariantCulture),
                                AddedBy = addedById == 0 ? String.Empty : addedById.ToString(CultureInfo.InvariantCulture),
                                AddedDate = addedDate == DateTime.MinValue ? String.Empty : addedDate.ToString("dd-MMM-yyyy HH:mm", CultureInfo.InvariantCulture)
                            };
                            response.Rows.Add(channelRow);
                            if (addedById > 0)
                            {
                                List<BillingChannelRow> employeeRows;
                                if (!rowsByEmployeeId.TryGetValue(addedById, out employeeRows))
                                {
                                    employeeRows = new List<BillingChannelRow>();
                                    rowsByEmployeeId.Add(addedById, employeeRows);
                                }
                                employeeRows.Add(channelRow);
                            }
                        }
                    }
                    PopulateEmployeeCodes(connection, rowsByEmployeeId);
                }
                return response;
            }
            catch (Exception exception)
            {
                return BillingChannelLoadResponse.Fail("Unable to load channels. " + exception.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static BillingChannelSaveResponse SaveChannel(BillingChannelSaveRequest request)
        {
            if (request == null) return BillingChannelSaveResponse.Fail("Invalid request.");
            string channel = (request.Channel ?? String.Empty).Trim();
            string cleanLoan = (request.CleanLoan ?? String.Empty).Trim();
            if (channel.Length == 0) return BillingChannelSaveResponse.Fail("Channel is required.");
            if (cleanLoan.Length == 0) return BillingChannelSaveResponse.Fail("Please select Clean Loan.");
            if (!cleanLoan.Equals("Yes", StringComparison.OrdinalIgnoreCase) && !cleanLoan.Equals("No", StringComparison.OrdinalIgnoreCase))
                return BillingChannelSaveResponse.Fail("Clean Loan must be Yes or No.");
            cleanLoan = cleanLoan.Equals("Yes", StringComparison.OrdinalIgnoreCase) ? "Yes" : "No";
            if (channel.Length > 100) return BillingChannelSaveResponse.Fail("Channel cannot exceed 100 characters.");
            if (cleanLoan.Length > 100) return BillingChannelSaveResponse.Fail("Clean Loan cannot exceed 100 characters.");

            try
            {
                int employeeId = GetCurrentEmployeeID();
                int result;
                using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionStringUWBilling))
                using (SqlCommand command = new SqlCommand("dbo.usp_InsertChannels", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    if (request.ChannelID > 0) command.Parameters.Add("@ChannelID", SqlDbType.Int).Value = request.ChannelID;
                    command.Parameters.Add("@Channel", SqlDbType.NVarChar, 100).Value = channel;
                    command.Parameters.Add("@CleanLoan", SqlDbType.NVarChar, 100).Value = cleanLoan;
                    command.Parameters.Add("@AddedBy", SqlDbType.Int).Value = employeeId;
                    SqlParameter returnValue = command.Parameters.Add("@ReturnValue", SqlDbType.Int);
                    returnValue.Direction = ParameterDirection.ReturnValue;
                    connection.Open();
                    command.ExecuteNonQuery();
                    result = Convert.ToInt32(returnValue.Value, CultureInfo.InvariantCulture);
                }
                if (result == -1) return BillingChannelSaveResponse.Fail("This Channel already exists.");
                if (result <= 0) return BillingChannelSaveResponse.Fail("The channel could not be saved.");
                return new BillingChannelSaveResponse { Success = true, ChannelID = request.ChannelID > 0 ? request.ChannelID : result, Message = request.ChannelID > 0 ? "Channel updated successfully." : "Channel added successfully." };
            }
            catch (SqlException exception)
            {
                return BillingChannelSaveResponse.Fail("Unable to save channel. " + exception.Message);
            }
            catch (Exception exception)
            {
                return BillingChannelSaveResponse.Fail(exception.Message);
            }
        }

        private static int GetCurrentEmployeeID()
        {
            int employeeId = EmployeeInfo.Current.EmployeeID;
            if (employeeId <= 0) throw new UnauthorizedAccessException("Your login session is not valid.");
            return employeeId;
        }

        private static void PopulateEmployeeCodes(SqlConnection connection, Dictionary<int, List<BillingChannelRow>> rowsByEmployeeId)
        {
            if (rowsByEmployeeId.Count == 0) return;
            using (SqlCommand command = connection.CreateCommand())
            {
                List<string> parameterNames = new List<string>();
                int parameterIndex = 0;
                foreach (int employeeId in rowsByEmployeeId.Keys)
                {
                    string parameterName = "@EmployeeID" + parameterIndex.ToString(CultureInfo.InvariantCulture);
                    parameterNames.Add(parameterName);
                    command.Parameters.Add(parameterName, SqlDbType.Int).Value = employeeId;
                    parameterIndex++;
                }
                command.CommandText = "SELECT EmployeeID, Code FROM InfinityERP.dbo.EmployeeInfo WHERE EmployeeID IN (" + String.Join(",", parameterNames.ToArray()) + ")";
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int employeeId = Convert.ToInt32(reader["EmployeeID"], CultureInfo.InvariantCulture);
                        string employeeCode = Convert.ToString(reader["Code"], CultureInfo.InvariantCulture).Trim();
                        List<BillingChannelRow> employeeRows;
                        if (employeeCode.Length == 0 || !rowsByEmployeeId.TryGetValue(employeeId, out employeeRows)) continue;
                        foreach (BillingChannelRow employeeRow in employeeRows) employeeRow.AddedBy = employeeCode;
                    }
                }
            }
        }
    }

    public sealed class BillingChannelSaveRequest
    {
        public int ChannelID { get; set; }
        public string Channel { get; set; }
        public string CleanLoan { get; set; }
    }

    public sealed class BillingChannelRow
    {
        public int ChannelID { get; set; }
        public string Channel { get; set; }
        public string CleanLoan { get; set; }
        public string AddedBy { get; set; }
        public string AddedDate { get; set; }
    }

    public sealed class BillingChannelLoadResponse
    {
        public BillingChannelLoadResponse() { Rows = new List<BillingChannelRow>(); }
        public bool Success { get; set; }
        public string Message { get; set; }
        public List<BillingChannelRow> Rows { get; set; }
        public static BillingChannelLoadResponse Fail(string message) { return new BillingChannelLoadResponse { Success = false, Message = message }; }
    }

    public sealed class BillingChannelSaveResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int ChannelID { get; set; }
        public static BillingChannelSaveResponse Fail(string message) { return new BillingChannelSaveResponse { Success = false, Message = message }; }
    }
}
