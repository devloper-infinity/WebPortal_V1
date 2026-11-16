using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.DAL;

namespace WebPortal.US
{
    public partial class NonProductiveHours : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static NonProductiveHoursResponse GetEntries()
        {
            int employeeId;
            if (!TryGetEmployeeId(out employeeId))
            {
                return Failure("Your Employee ID could not be identified. Please sign in again.");
            }

            try
            {
                return new NonProductiveHoursResponse
                {
                    Success = true,
                    Entries = LoadEntries(employeeId)
                };
            }
            catch (Exception)
            {
                return Failure("Entries could not be loaded. Please try again or contact the administrator.");
            }
        }

        [WebMethod]
        public static NonProductiveHoursResponse SaveEntry(string entryDate,string starttime, string endtime,string Totalduration, string reason)
        {
            int employeeId;
            if (!TryGetEmployeeId(out employeeId))
            {
                return Failure("Your Employee ID could not be identified. Please sign in again.");
            }

            DateTime parsedDate;
            if (!DateTime.TryParseExact(
                entryDate,
                "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out parsedDate))
            {
                return Failure("Please select a valid date.");
            }

            if (parsedDate.Date > DateTime.Today)
            {
                return Failure("Future dates are not allowed.");
            }

          

            reason = (reason ?? string.Empty).Trim();
            if (reason.Length == 0)
            {
                return Failure("Please enter a reason.");
            }

            if (reason.Length > 1000)
            {
                return Failure("Reason cannot exceed 1000 characters.");
            }
            const string checkSql = @"SELECT COUNT(1) FROM dbo.NonProductiveHours 
                                      WHERE EmployeeID = @EmployeeID 
                                        AND EntryDate = @EntryDate 
                                       ";
            const string insertSql = @"
INSERT INTO dbo.NonProductiveHours
    (EmployeeID, EntryDate, StartTime,EndTime,TotalDuration, Reason)
VALUES
    (@EmployeeID, @EntryDate, @StartTime,@EndTime,@TotalDuration, @Reason);";

            try
            {
                using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
                {
                    connection.Open();
                    using (SqlCommand checkCommand = new SqlCommand(checkSql, connection))
                    {
                        checkCommand.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                        checkCommand.Parameters.Add("@EntryDate", SqlDbType.Date).Value = parsedDate.Date;
                        checkCommand.Parameters.Add("@StartTime", SqlDbType.NVarChar, 12).Value = starttime;
                        checkCommand.Parameters.Add("@EndTime", SqlDbType.NVarChar, 12).Value = endtime;

                        int existingCount = (int)checkCommand.ExecuteScalar();
                        if (existingCount > 0)
                        {
                            return Failure("An entry with the same date already exists.");
                        }
                    }
                    using (SqlCommand command = new SqlCommand(insertSql, connection))
                    {
                        command.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                        command.Parameters.Add("@EntryDate", SqlDbType.Date).Value = parsedDate.Date;
                        command.Parameters.Add("@StartTime", SqlDbType.NVarChar, 12).Value = starttime;
                        command.Parameters.Add("@EndTime", SqlDbType.NVarChar, 12).Value = endtime;

                        command.Parameters.Add("@TotalDuration", SqlDbType.NVarChar, 1000).Value = Totalduration;

                        command.Parameters.Add("@Reason", SqlDbType.NVarChar, 12).Value = reason;

                       
                        command.ExecuteNonQuery();
                    }
                }
                return new NonProductiveHoursResponse
                {
                    Success = true,
                    Message = "Non-productive hours saved successfully.",
                    Entries = LoadEntries(employeeId)
                };
            }
            catch (Exception)
            {
                return Failure("The entry could not be saved. Please try again or contact the administrator.");
            }
        }

        private static List<NonProductiveHoursRow> LoadEntries(int employeeId)
        {
            const string selectSql = @"
SELECT EntryDate, StartTime,EndTime,TotalDuration, Reason, CreatedOn
FROM dbo.NonProductiveHours
WHERE EmployeeID = @EmployeeID
ORDER BY EntryDate DESC, CreatedOn DESC;";

            List<NonProductiveHoursRow> entries = new List<NonProductiveHoursRow>();
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand(selectSql, connection))
            {
                command.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        entries.Add(new NonProductiveHoursRow
                        {
                            EntryDate = Convert.ToDateTime(reader["EntryDate"], CultureInfo.InvariantCulture)
                                .ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                            StartTime = Convert.ToString(reader["StartTime"], CultureInfo.InvariantCulture),
                            EndTime = Convert.ToString(reader["EndTime"], CultureInfo.InvariantCulture),
                            TotalDuration = Convert.ToString(reader["TotalDuration"], CultureInfo.InvariantCulture),

                            Reason = Convert.ToString(reader["Reason"], CultureInfo.InvariantCulture),
                            CreatedOn = Convert.ToDateTime(reader["CreatedOn"], CultureInfo.InvariantCulture)
                                .ToString("dd-MMM-yyyy hh:mm tt", CultureInfo.InvariantCulture)
                        });
                    }
                }
            }

            return entries;
        }
        [WebMethod]
        public static NphResponse UpdateLoadEntries()
        {
            const string selectSql = @"
        SELECT NonProductiveHoursID, EntryDate, StartTime, EndTime, TotalDuration, Reason, 
               CONCAT(Code, ': ', FirstName, ' ', LastName) AS EmployeeName, CreatedOn 
        FROM dbo.NonProductiveHours nph
        INNER JOIN EmployeeInfo ef ON nph.EmployeeID = ef.EmployeeID WHERE nph.IsDeleted  IS NULL";

            try
            {
                List<NonProductiveHoursRow> entries = new List<NonProductiveHoursRow>();
                using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
                using (SqlCommand command = new SqlCommand(selectSql, connection))
                {
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            entries.Add(new NonProductiveHoursRow
                            {
                                NonProductiveHoursID = Convert.ToInt32(reader["NonProductiveHoursID"], CultureInfo.InvariantCulture),
                                EntryDate = Convert.ToDateTime(reader["EntryDate"], CultureInfo.InvariantCulture).ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                                StartTime = Convert.ToString(reader["StartTime"], CultureInfo.InvariantCulture),
                                EndTime = Convert.ToString(reader["EndTime"], CultureInfo.InvariantCulture),
                                TotalDuration = Convert.ToString(reader["TotalDuration"], CultureInfo.InvariantCulture),
                                Reason = Convert.ToString(reader["Reason"], CultureInfo.InvariantCulture),
                                EmployeeName = Convert.ToString(reader["EmployeeName"], CultureInfo.InvariantCulture),
                                CreatedOn = Convert.ToDateTime(reader["CreatedOn"], CultureInfo.InvariantCulture).ToString("dd-MMM-yyyy hh:mm tt", CultureInfo.InvariantCulture)
                            });
                        }
                    }
                }

                return new NphResponse { Success = true, Entries = entries };
            }
            catch (Exception)
            {
                return new NphResponse { Success = false, Message = "Entries could not be loaded. Please try again." };
            }
        }





        [WebMethod]
        public static NonProductiveHoursResponse UpdateEntry(int entryId, string entryDate, string starttime, string endtime, string Totalduration, string reason)
        {
            int employeeId;
            if (!TryGetEmployeeId(out employeeId))
            {
                return Failure("Your Employee ID could not be identified. Please sign in again.");
            }

            DateTime parsedDate;
            if (!DateTime.TryParseExact(entryDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsedDate))
            {
                return Failure("Please select a valid date.");
            }

            if (parsedDate.Date > DateTime.Today)
            {
                return Failure("Future dates are not allowed.");
            }

            reason = (reason ?? string.Empty).Trim();
            if (reason.Length == 0)
            {
                return Failure("Please enter a reason.");
            }

            if (reason.Length > 1000)
            {
                return Failure("Reason cannot exceed 1000 characters.");
            }

            const string insertHistorySql = @"
        INSERT INTO [InfinityERP].[dbo].[NonProductiveHoursHistory]
            ([NonProductiveHoursID], [EmployeeID], [EntryDate], [StartTime], [EndTime], [TotalDuration], [Reason], [CreatedOn], [CreatedBy])
        SELECT 
            [NonProductiveHoursID], [EmployeeID], [EntryDate], [StartTime], [EndTime], [TotalDuration], [Reason], GETDATE(), @CreatedBy
        FROM [InfinityERP].[dbo].[NonProductiveHours] 
        WHERE [NonProductiveHoursID] = @NonProductiveHoursID;";

            const string updateSql = @"
        UPDATE [InfinityERP].[dbo].[NonProductiveHours] 
        SET [EntryDate] = @EntryDate, 
            [StartTime] = @StartTime, 
            [EndTime] = @EndTime, 
            [TotalDuration] = @TotalDuration, 
            [Reason] = @Reason ,
            UpdatedOn= GETDATE(),
            UpdatedBy= @UpdatedBy
        WHERE [NonProductiveHoursID] = @NonProductiveHoursID;";

            try
            {
                using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
                {
                    connection.Open();
                    using (SqlTransaction transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            using (SqlCommand historyCmd = new SqlCommand(insertHistorySql, connection, transaction))
                            {
                                historyCmd.Parameters.Add("@NonProductiveHoursID", SqlDbType.Int).Value = entryId;
                                historyCmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = employeeId;
                                historyCmd.ExecuteNonQuery();
                            }

                            using (SqlCommand updateCmd = new SqlCommand(updateSql, connection, transaction))
                            {
                                updateCmd.Parameters.Add("@NonProductiveHoursID", SqlDbType.Int).Value = entryId;
                                updateCmd.Parameters.Add("@EntryDate", SqlDbType.Date).Value = parsedDate.Date;
                                updateCmd.Parameters.Add("@StartTime", SqlDbType.NVarChar, 12).Value = starttime;
                                updateCmd.Parameters.Add("@EndTime", SqlDbType.NVarChar, 12).Value = endtime;
                                updateCmd.Parameters.Add("@TotalDuration", SqlDbType.NVarChar, 50).Value = Totalduration;
                                updateCmd.Parameters.Add("@Reason", SqlDbType.NVarChar, 1000).Value = reason;
                                updateCmd.Parameters.Add("@UpdatedBy", SqlDbType.NVarChar, 1000).Value = employeeId;

                                updateCmd.ExecuteNonQuery();
                            }

                            transaction.Commit();
                            return new NonProductiveHoursResponse { Success = true, Message = "Entry updated successfully." };
                        }
                        catch (Exception)
                        {
                            transaction.Rollback();
                            throw;
                        }
                    }
                }
            }
            catch (Exception)
            {
                return Failure("Failed to update entry. Please try again.");
            }
        }



        [WebMethod]
        public static NonProductiveHoursResponse DeleteEntry(int entryId)
        {
            int employeeId;
            if (!TryGetEmployeeId(out employeeId))
            {
                return Failure("Your Employee ID could not be identified. Please sign in again.");
            }
            const string deleteSql = @"UPDATE [InfinityERP].[dbo].[NonProductiveHours] 
                               SET [IsDeleted] = 1 
                               WHERE [NonProductiveHoursID] = @NonProductiveHoursID;";

            try
            {
                using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
                {
                    connection.Open();
                    using (SqlCommand cmd = new SqlCommand(deleteSql, connection))
                    {
                        cmd.Parameters.Add("@NonProductiveHoursID", SqlDbType.Int).Value = entryId;

                        int rowsAffected = cmd.ExecuteNonQuery();
                        if (rowsAffected > 0)
                        {
                            return new NonProductiveHoursResponse { Success = true, Message = "Entry deleted successfully." };
                        }
                        else
                        {
                            return Failure("Record not found or already deleted.");
                        }
                    }
                }
            }
            catch (Exception)
            {
                return Failure("Failed to delete entry. Please try again.");
            }
        }




        public class NphResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public List<NonProductiveHoursRow> Entries { get; set; }
        }
        private static bool TryGetEmployeeId(out int employeeId)
        {
            employeeId = 0;
            return HttpContext.Current != null
                && HttpContext.Current.User != null
                && HttpContext.Current.User.Identity != null
                && int.TryParse(HttpContext.Current.User.Identity.Name, out employeeId)
                && employeeId > 0;
        }

        private static NonProductiveHoursResponse Failure(string message)
        {
            return new NonProductiveHoursResponse
            {
                Success = false,
                Message = message,
                Entries = new List<NonProductiveHoursRow>()
            };
        }
    }

    public class NonProductiveHoursResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public List<NonProductiveHoursRow> Entries { get; set; }
    }

    public class NonProductiveHoursRow
    {
        public int NonProductiveHoursID { get; set; }

        public string EntryDate { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }

        public string TotalDuration { get; set; }

        public string Reason { get; set; }
        public string CreatedOn { get; set; }
        public string EmployeeName { get; set; }

    }

    }
