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
        public static NonProductiveHoursResponse SaveEntry(
            string entryDate,
            int hours,
            int minutes,
            string reason)
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

            if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59)
            {
                return Failure("Please select a valid duration.");
            }

            int durationMinutes = (hours * 60) + minutes;
            if (durationMinutes <= 0)
            {
                return Failure("Duration must be greater than 00:00.");
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

            const string insertSql = @"
INSERT INTO dbo.NonProductiveHours
    (EmployeeID, EntryDate, DurationMinutes, Reason)
VALUES
    (@EmployeeID, @EntryDate, @DurationMinutes, @Reason);";

            try
            {
                using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
                using (SqlCommand command = new SqlCommand(insertSql, connection))
                {
                    command.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                    command.Parameters.Add("@EntryDate", SqlDbType.Date).Value = parsedDate.Date;
                    command.Parameters.Add("@DurationMinutes", SqlDbType.Int).Value = durationMinutes;
                    command.Parameters.Add("@Reason", SqlDbType.NVarChar, 1000).Value = reason;

                    connection.Open();
                    command.ExecuteNonQuery();
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
SELECT EntryDate, DurationMinutes, Reason, CreatedOn
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
                        int durationMinutes = Convert.ToInt32(reader["DurationMinutes"], CultureInfo.InvariantCulture);
                        entries.Add(new NonProductiveHoursRow
                        {
                            EntryDate = Convert.ToDateTime(reader["EntryDate"], CultureInfo.InvariantCulture)
                                .ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                            Duration = (durationMinutes / 60).ToString(CultureInfo.InvariantCulture)
                                + ":" + (durationMinutes % 60).ToString("00", CultureInfo.InvariantCulture),
                            Reason = Convert.ToString(reader["Reason"], CultureInfo.InvariantCulture),
                            CreatedOn = Convert.ToDateTime(reader["CreatedOn"], CultureInfo.InvariantCulture)
                                .ToString("dd-MMM-yyyy hh:mm tt", CultureInfo.InvariantCulture)
                        });
                    }
                }
            }

            return entries;
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
        public string EntryDate { get; set; }
        public string Duration { get; set; }
        public string Reason { get; set; }
        public string CreatedOn { get; set; }
    }
}
