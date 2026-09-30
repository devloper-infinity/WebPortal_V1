using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.Services;
using System.Web.UI.WebControls;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ProjectBillingDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                for (int month = 1; month <= 12; month++)
                {
                    string name = CultureInfo.InvariantCulture.DateTimeFormat.GetMonthName(month);
                    ddlMonth.Items.Add(new ListItem(name, name));
                }
                ddlMonth.SelectedValue = DateTime.Today.ToString("MMMM", CultureInfo.InvariantCulture);

                int currentYear = DateTime.Today.Year;
                for (int year = currentYear + 1; year >= currentYear - 10; year--)
                    ddlYear.Items.Add(new ListItem(year.ToString(CultureInfo.InvariantCulture), year.ToString(CultureInfo.InvariantCulture)));
                ddlYear.SelectedValue = currentYear.ToString(CultureInfo.InvariantCulture);
            }
        }

        [WebMethod(EnableSession = true)]
        public static BillingDetailsResponse GetBillingDetails(string month, int year)
        {
            try
            {
                DateTime parsedMonth;
                if (!DateTime.TryParseExact(month, "MMMM", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsedMonth))
                    return BillingDetailsResponse.Failure("Please select a valid Month.");
                if (year < 2000 || year > DateTime.Today.Year + 1)
                    return BillingDetailsResponse.Failure("Please select a valid Year.");

                string normalizedMonth = CultureInfo.InvariantCulture.DateTimeFormat.GetMonthName(parsedMonth.Month);
                int employeeId = EmployeeInfo.Current.EmployeeID;
                DataSet dataSet = new DataSet();

                using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
                using (SqlCommand command = new SqlCommand("usp_GetAllProjectsBillingDetails", connection))
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandTimeout = 180;
                    command.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                    command.Parameters.Add("@Month", SqlDbType.NVarChar, 100).Value = normalizedMonth;
                    command.Parameters.Add("@Year", SqlDbType.Int).Value = year;
                    adapter.Fill(dataSet);
                }

                BillingDetailsResponse response = new BillingDetailsResponse { Success = true, Message = string.Empty };
                foreach (DataTable table in dataSet.Tables)
                {
                    if (table.Rows.Count == 0 || table.Columns.Count == 0)
                        continue;

                    BillingProjectTable project = new BillingProjectTable
                    {
                        ProjectName = Convert.ToString(table.Rows[0][0], CultureInfo.InvariantCulture)
                    };
                    foreach (DataColumn column in table.Columns)
                        project.Columns.Add(column.ColumnName);
                    foreach (DataRow row in table.Rows)
                    {
                        List<string> values = new List<string>();
                        foreach (DataColumn column in table.Columns)
                            values.Add(FormatValue(row[column]));
                        project.Rows.Add(values);
                    }
                    response.Projects.Add(project);
                }

                if (response.Projects.Count == 0)
                    response.Message = "No billing records found for selected Month and Year.";
                return response;
            }
            catch (Exception)
            {
                return BillingDetailsResponse.Failure("Unable to fetch billing details. Please try again or contact the administrator.");
            }
        }

        private static string FormatValue(object value)
        {
            if (value == null || value == DBNull.Value) return string.Empty;
            if (value is DateTime)
            {
                DateTime date = (DateTime)value;
                return date.TimeOfDay == TimeSpan.Zero
                    ? date.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture)
                    : date.ToString("dd-MMM-yyyy HH:mm", CultureInfo.InvariantCulture);
            }
            return Convert.ToString(value, CultureInfo.InvariantCulture);
        }
    }

    public class BillingDetailsResponse
    {
        public BillingDetailsResponse() { Projects = new List<BillingProjectTable>(); }
        public bool Success { get; set; }
        public string Message { get; set; }
        public List<BillingProjectTable> Projects { get; set; }
        public static BillingDetailsResponse Failure(string message) { return new BillingDetailsResponse { Success = false, Message = message }; }
    }

    public class BillingProjectTable
    {
        public BillingProjectTable() { Columns = new List<string>(); Rows = new List<List<string>>(); }
        public string ProjectName { get; set; }
        public List<string> Columns { get; set; }
        public List<List<string>> Rows { get; set; }
    }
}
