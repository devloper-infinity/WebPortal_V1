using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net.Mail;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ClientBillingEmailMaster : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod(EnableSession = true)]
        public static ClientBillingEmailLoadResponse LoadData()
        {
            try
            {
                CurrentEmployeeID();
                ClientBillingEmailLoadResponse response = new ClientBillingEmailLoadResponse { Success = true };
                response.Projects.Add(new ClientBillingProject { ProjectID = 0, ProjectName = "All Commitment Projects" });
                response.Projects.Add(new ClientBillingProject { ProjectID = -4, ProjectName = "All Valuation Projects" });
                response.Projects.Add(new ClientBillingProject { ProjectID = -19, ProjectName = "All Underwriting Servicing Projects" });
                response.Projects.Add(new ClientBillingProject { ProjectID = -15, ProjectName = "All Underwriting Credit Projects" });
                using (SqlCommand projectCommand = SQLHelper.GetCommand(CommandType.StoredProcedure, "dbo.usp_GetAllProject"))
                {
                    DataTable projects = SQLHelper.ExecuteDataTableCmd(projectCommand);
                    foreach (DataRow row in projects.Rows)
                    {
                        if (!IsActiveProject(row)) continue;
                        int projectId = ToInt(row, "ProjectID");
                        string projectName = Value(row, "ProjectName").Trim();
                        if (projectId > 0 && projectName.Length > 0)
                            response.Projects.Add(new ClientBillingProject { ProjectID = projectId, ProjectName = projectName });
                    }
                }
                response.Projects = response.Projects.OrderBy(x => x.ProjectName, StringComparer.OrdinalIgnoreCase).ToList();

                using (SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "dbo.usp_ClientBillingEmailMaster_Get"))
                {
                    DataTable table = SQLHelper.ExecuteDataTableCmd(command);
                    foreach (DataRow row in table.Rows)
                    {
                        DateTime updatedDate;
                        DateTime.TryParse(Convert.ToString(row["UpdatedDate"], CultureInfo.InvariantCulture), out updatedDate);
                        response.Rows.Add(new ClientBillingEmailRow
                        {
                            MasterID = Convert.ToInt32(row["MasterID"], CultureInfo.InvariantCulture),
                            ProjectID = Convert.ToInt32(row["ProjectID"], CultureInfo.InvariantCulture),
                            ProjectName = Convert.ToString(row["ProjectName"], CultureInfo.InvariantCulture),
                            TOID = Convert.ToString(row["TOID"], CultureInfo.InvariantCulture),
                            CCID = Convert.ToString(row["CCID"], CultureInfo.InvariantCulture),
                            BCCID = Convert.ToString(row["BCCID"], CultureInfo.InvariantCulture),
                            UpdatedBy = Convert.ToString(row["UpdatedBy"], CultureInfo.InvariantCulture),
                            UpdatedDate = updatedDate == DateTime.MinValue ? String.Empty : updatedDate.ToString("dd-MMM-yyyy HH:mm", CultureInfo.InvariantCulture)
                        });
                    }
                }
                return response;
            }
            catch (Exception ex) { return ClientBillingEmailLoadResponse.Fail("Unable to load email configurations. " + ex.Message); }
        }

        [WebMethod(EnableSession = true)]
        public static ClientBillingEmailSaveResponse Save(ClientBillingEmailSaveRequest request)
        {
            if (request == null || (request.ProjectID < 0 && request.ProjectID != -4 && request.ProjectID != -15 && request.ProjectID != -19)) return ClientBillingEmailSaveResponse.Fail("Please select a project.");
            try
            {
                string to = NormalizeEmails(request.TOID, true, "To");
                string cc = NormalizeEmails(request.CCID, false, "CC");
                string bcc = NormalizeEmails(request.BCCID, false, "BCC");
                int employeeId = CurrentEmployeeID();
                string procedure = request.MasterID > 0 ? "dbo.usp_ClientBillingEmailMaster_Update" : "dbo.usp_ClientBillingEmailMaster_Insert";
                using (SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, procedure))
                {
                    if (request.MasterID > 0) Add(command, "@MasterID", SqlDbType.Int, request.MasterID);
                    Add(command, "@ProjectID", SqlDbType.Int, request.ProjectID);
                    Add(command, "@TOID", SqlDbType.NVarChar, to);
                    Add(command, "@CCID", SqlDbType.NVarChar, cc);
                    Add(command, "@BCCID", SqlDbType.NVarChar, bcc);
                    Add(command, request.MasterID > 0 ? "@UdpatedBy" : "@AddedBy", SqlDbType.Int, employeeId);
                    int masterId = Convert.ToInt32(SQLHelper.ExecuteScalarCmd(command), CultureInfo.InvariantCulture);
                    return new ClientBillingEmailSaveResponse
                    {
                        Success = true,
                        MasterID = masterId,
                        Message = request.MasterID > 0 ? "Email configuration updated successfully." : "Email configuration saved successfully."
                    };
                }
            }
            catch (SqlException ex) { return ClientBillingEmailSaveResponse.Fail(ex.Message); }
            catch (Exception ex) { return ClientBillingEmailSaveResponse.Fail(ex.Message); }
        }

        private static string NormalizeEmails(string value, bool required, string field)
        {
            string input = (value ?? String.Empty).Trim();
            if (input.Length == 0)
            {
                if (required) throw new ArgumentException(field + " Email ID is mandatory.");
                return String.Empty;
            }
            if (input.Contains(",")) throw new ArgumentException(field + " Email IDs must be separated using semicolons (;).");
            List<string> result = new List<string>();
            HashSet<string> unique = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (string item in input.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries))
            {
                string email = item.Trim();
                if (email.Length == 0) continue;
                MailAddress parsed;
                try { parsed = new MailAddress(email); }
                catch (FormatException) { throw new ArgumentException("Invalid " + field + " email address: " + email); }
                if (!String.Equals(parsed.Address, email, StringComparison.OrdinalIgnoreCase))
                    throw new ArgumentException("Invalid " + field + " email address: " + email);
                if (unique.Add(parsed.Address)) result.Add(parsed.Address);
            }
            if (required && result.Count == 0) throw new ArgumentException(field + " Email ID is mandatory.");
            return String.Join(";", result.ToArray());
        }

        private static bool IsActiveProject(DataRow row)
        {
            string deleted = Value(row, "IsDelete");
            if (deleted == "1" || deleted.Equals("true", StringComparison.OrdinalIgnoreCase)) return false;
            string status = Value(row, "ProjectStatus");
            if (status.Length == 0) status = Value(row, "ProjectActiveStatus");
            if (status.Length == 0) status = Value(row, "Status");
            return status.Length == 0 || status == "1" || status.Equals("true", StringComparison.OrdinalIgnoreCase) || status.Equals("active", StringComparison.OrdinalIgnoreCase);
        }

        private static int CurrentEmployeeID()
        {
            int employeeId = EmployeeInfo.Current.EmployeeID;
            if (employeeId <= 0) throw new UnauthorizedAccessException("Your login session is not valid.");
            return employeeId;
        }
        private static void Add(SqlCommand command, string name, SqlDbType type, object value)
        {
            SqlParameter parameter = command.Parameters.Add(name, type);
            if (type == SqlDbType.NVarChar) parameter.Size = -1;
            parameter.Value = value == null ? (object)DBNull.Value : value;
        }
        private static int ToInt(DataRow row, string name) { int value; return Int32.TryParse(Value(row, name), out value) ? value : 0; }
        private static string Value(DataRow row, string name)
        {
            foreach (DataColumn column in row.Table.Columns)
                if (column.ColumnName.Equals(name, StringComparison.OrdinalIgnoreCase)) return Convert.ToString(row[column], CultureInfo.InvariantCulture);
            return String.Empty;
        }
    }

    public sealed class ClientBillingEmailSaveRequest { public int MasterID { get; set; } public int ProjectID { get; set; } public string TOID { get; set; } public string CCID { get; set; } public string BCCID { get; set; } }
    public sealed class ClientBillingProject { public int ProjectID { get; set; } public string ProjectName { get; set; } }
    public sealed class ClientBillingEmailRow { public int MasterID { get; set; } public int ProjectID { get; set; } public string ProjectName { get; set; } public string TOID { get; set; } public string CCID { get; set; } public string BCCID { get; set; } public string UpdatedBy { get; set; } public string UpdatedDate { get; set; } }
    public sealed class ClientBillingEmailLoadResponse
    {
        public ClientBillingEmailLoadResponse() { Projects = new List<ClientBillingProject>(); Rows = new List<ClientBillingEmailRow>(); }
        public bool Success { get; set; } public string Message { get; set; } public List<ClientBillingProject> Projects { get; set; } public List<ClientBillingEmailRow> Rows { get; set; }
        public static ClientBillingEmailLoadResponse Fail(string message) { return new ClientBillingEmailLoadResponse { Success = false, Message = message }; }
    }
    public sealed class ClientBillingEmailSaveResponse
    {
        public bool Success { get; set; } public string Message { get; set; } public int MasterID { get; set; }
        public static ClientBillingEmailSaveResponse Fail(string message) { return new ClientBillingEmailSaveResponse { Success = false, Message = message }; }
    }
}
