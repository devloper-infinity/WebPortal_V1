using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Xml.Linq;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ProjectEmailConfiguration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetAllProjectNo()
        {
            return SerializeTable(GetUserProjects(CurrentEmployeeId()));
        }

        [WebMethod]
        public static string GetProjectEmails(int projectId)
        {
            EnsureProjectAccess(projectId);
            SqlCommand command = CreateProjectCommand("usp_ProjectEmailConfiguration_GetByProject", projectId);
            return SerializeTable(SQLHelper.ExecuteDataTableCmd(command));
        }

        [WebMethod]
        public static string GetConfigurations()
        {
            DataTable configurations = SQLHelper.ExecuteDataTableCmd(
                SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ProjectEmailConfiguration_GetAll"));
            HashSet<int> permittedProjects = GetPermittedProjectIds();

            if (configurations != null && configurations.Columns.Contains("ProjectID"))
            {
                foreach (DataRow row in configurations.Rows.Cast<DataRow>().ToList())
                {
                    if (!permittedProjects.Contains(Convert.ToInt32(row["ProjectID"])))
                    {
                        configurations.Rows.Remove(row);
                    }
                }
            }

            return SerializeTable(configurations);
        }

        [WebMethod]
        public static ProjectEmailConfigurationResponse SaveProjectEmailConfiguration(
            int originalProjectId,
            int projectId,
            ProjectEmailItem[] emailItems)
        {
            EnsureProjectAccess(originalProjectId);
            EnsureProjectAccess(projectId);
            List<ProjectEmailItem> normalizedItems = ValidateAndNormalizeItems(emailItems, true);

            XElement emailXml = new XElement("Emails", normalizedItems.Select(CreateEmailElement));

            SqlCommand command = SQLHelper.GetCommand(
                CommandType.StoredProcedure,
                "usp_ProjectEmailConfiguration_Save");
            AddIntParameter(command, "@OriginalProjectID", originalProjectId);
            AddIntParameter(command, "@ProjectID", projectId);
            command.Parameters.Add("@Emails", SqlDbType.Xml).Value =
                emailXml.ToString(SaveOptions.DisableFormatting);
            AddIntParameter(command, "@UserID", CurrentEmployeeId());
            SQLHelper.ExecuteNonQueryCmd(command);

            return SuccessResponse(
                "Project email configuration saved successfully.",
                normalizedItems.Count);
        }

        [WebMethod]
        public static ProjectEmailConfigurationResponse SaveProjectEmailType(
            int projectId,
            string emailType,
            ProjectEmailItem[] emailItems)
        {
            EnsureProjectAccess(projectId);
            string normalizedType = NormalizeEmailType(emailType);
            List<ProjectEmailItem> normalizedItems = ValidateAndNormalizeItems(
                emailItems,
                normalizedType == "TO");

            if (normalizedItems.Any(item => item.EmailType != normalizedType))
            {
                throw new ArgumentException("Submitted email records do not match the selected email type.");
            }

            XElement emailXml = new XElement("Emails", normalizedItems.Select(CreateEmailElement));
            SqlCommand command = SQLHelper.GetCommand(
                CommandType.StoredProcedure,
                "usp_ProjectEmailConfiguration_SaveType");
            AddIntParameter(command, "@ProjectID", projectId);
            AddTextParameter(command, "@EmailType", normalizedType, 2);
            command.Parameters.Add("@Emails", SqlDbType.Xml).Value =
                emailXml.ToString(SaveOptions.DisableFormatting);
            AddIntParameter(command, "@UserID", CurrentEmployeeId());
            SQLHelper.ExecuteNonQueryCmd(command);

            return SuccessResponse(
                normalizedType + " email addresses updated successfully.",
                normalizedItems.Count);
        }

        [WebMethod]
        public static string GetProjectEmailHistory(int projectId)
        {
            EnsureProjectAccess(projectId);
            SqlCommand command = CreateProjectCommand(
                "usp_ProjectEmailConfiguration_GetHistory",
                projectId);
            return SerializeTable(SQLHelper.ExecuteDataTableCmd(command));
        }

        [WebMethod]
        public static ProjectEmailConfigurationResponse DeactivateProjectEmail(int configurationId, int projectId)
        {
            if (configurationId <= 0)
            {
                throw new ArgumentException("Invalid email configuration record.");
            }

            EnsureProjectAccess(projectId);
            SqlCommand lookupCommand = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ProjectEmailConfiguration_GetByID");
            AddIntParameter(lookupCommand, "@ConfigurationID", configurationId);
            DataTable configuration = SQLHelper.ExecuteDataTableCmd(lookupCommand);

            if (configuration == null || configuration.Rows.Count == 0 ||
                Convert.ToInt32(configuration.Rows[0]["ProjectID"]) != projectId)
            {
                throw new ArgumentException("The selected email configuration was not found for this project.");
            }

            if (configuration.Columns.Contains("IsActive") &&
                !Convert.ToBoolean(configuration.Rows[0]["IsActive"]))
            {
                return SuccessResponse("The email address is already inactive.", 0);
            }

            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ProjectEmailConfiguration_Deactivate");
            AddIntParameter(command, "@ConfigurationID", configurationId);
            AddIntParameter(command, "@UserID", CurrentEmployeeId());
            SQLHelper.ExecuteNonQueryCmd(command);

            return SuccessResponse("The email address was deactivated successfully.", 0);
        }

        private static void EnsureOriginalConfigurationAccess(int configurationId)
        {
            SqlCommand command = SQLHelper.GetCommand(
                CommandType.StoredProcedure,
                "usp_ProjectEmailConfiguration_GetByID");
            AddIntParameter(command, "@ConfigurationID", configurationId);
            DataTable configuration = SQLHelper.ExecuteDataTableCmd(command);

            if (configuration == null || configuration.Rows.Count == 0)
            {
                throw new ArgumentException("The selected email configuration was not found.");
            }

            EnsureProjectAccess(Convert.ToInt32(configuration.Rows[0]["ProjectID"]));
        }

        private static XElement CreateEmailElement(ProjectEmailItem item)
        {
            return new XElement("Email", new XAttribute("ID", item.ConfigurationId), new XAttribute("Type", item.EmailType),
                new XAttribute("Value", item.EmailAddress));
        }

        private static List<ProjectEmailItem> ValidateAndNormalizeItems(
            IEnumerable<ProjectEmailItem> emailItems,
            bool requireToEmail)
        {
            List<ProjectEmailItem> items = (emailItems ?? Enumerable.Empty<ProjectEmailItem>())
                .Where(item => item != null && !string.IsNullOrWhiteSpace(item.EmailAddress))
                .Select(item => new ProjectEmailItem
                {
                    ConfigurationId = Math.Max(0, item.ConfigurationId),
                    EmailType = NormalizeEmailType(item.EmailType),
                    EmailAddress = ValidateSingleEmail(item.EmailAddress)
                })
                .ToList();

            if (requireToEmail && !items.Any(item => item.EmailType == "TO"))
            {
                throw new ArgumentException("Please enter at least one To email address.");
            }

            foreach (string emailType in new[] { "TO", "CC" })
            {
                List<ProjectEmailItem> typedItems = items
                    .Where(item => item.EmailType == emailType)
                    .ToList();

                if (typedItems.Count > 50)
                {
                    throw new ArgumentException(
                        "A maximum of 50 " + emailType + " email addresses can be configured.");
                }

                string duplicateEmail = typedItems
                    .GroupBy(item => item.EmailAddress, StringComparer.OrdinalIgnoreCase)
                    .Where(group => group.Count() > 1)
                    .Select(group => group.Key)
                    .FirstOrDefault();

                if (!string.IsNullOrEmpty(duplicateEmail))
                {
                    throw new ArgumentException(
                        "Duplicate " + emailType + " email address found: " + duplicateEmail);
                }
            }

            if (items.Where(item => item.ConfigurationId > 0)
                .GroupBy(item => item.ConfigurationId)
                .Any(group => group.Count() > 1))
            {
                throw new ArgumentException("An email configuration record was submitted more than once.");
            }

            return items;
        }

        private static List<string> ValidateAndNormalizeEmails(
            IEnumerable<string> emailIds,
            string label,
            bool isRequired)
        {
            List<string> emails = (emailIds ?? Enumerable.Empty<string>())
                .Where(email => !string.IsNullOrWhiteSpace(email))
                .Select(email => email.Trim().ToLowerInvariant())
                .ToList();

            if (isRequired && emails.Count == 0)
            {
                throw new ArgumentException("Please enter at least one To email address.");
            }

            if (emails.Count > 50)
            {
                throw new ArgumentException("A maximum of 50 " + label + " email addresses can be configured.");
            }

            string duplicate = emails
                .GroupBy(email => email, StringComparer.OrdinalIgnoreCase)
                .Where(group => group.Count() > 1)
                .Select(group => group.Key)
                .FirstOrDefault();

            if (!string.IsNullOrEmpty(duplicate))
            {
                throw new ArgumentException("Duplicate " + label + " email address found: " + duplicate);
            }

            foreach (string email in emails)
            {
                ValidateSingleEmail(email);
            }

            return emails;
        }

        private static string ValidateSingleEmail(string emailAddress)
        {
            string email = (emailAddress ?? string.Empty).Trim().ToLowerInvariant();

            if (email.Length == 0)
            {
                throw new ArgumentException("Please enter an email address.");
            }

            MailAddress parsedAddress;

            try
            {
                parsedAddress = new MailAddress(email);
            }
            catch (FormatException)
            {
                throw new ArgumentException("Invalid email address: " + email);
            }

            if (email.Length > 254 ||
                !string.Equals(parsedAddress.Address, email, StringComparison.OrdinalIgnoreCase))
            {
                throw new ArgumentException("Invalid email address: " + email);
            }

            return email;
        }

        private static string NormalizeEmailType(string emailType)
        {
            string normalizedType = (emailType ?? string.Empty).Trim().ToUpperInvariant();

            if (normalizedType != "TO" && normalizedType != "CC")
            {
                throw new ArgumentException("Email type must be To or CC.");
            }

            return normalizedType;
        }

        private static void EnsureProjectAccess(int projectId)
        {
            if (!GetPermittedProjectIds().Contains(projectId))
            {
                throw new HttpException(403, "You do not have access to the selected project.");
            }
        }

        private static HashSet<int> GetPermittedProjectIds()
        {
            DataTable projects = GetUserProjects(CurrentEmployeeId());
            HashSet<int> projectIds = new HashSet<int>();

            if (projects != null && projects.Columns.Contains("ProjectID"))
            {
                foreach (DataRow row in projects.Rows)
                {
                    projectIds.Add(Convert.ToInt32(row["ProjectID"]));
                }
            }

            return projectIds;
        }

        private static DataTable GetUserProjects(int employeeId)
        {
            return new bllOST().GetAllProject(employeeId);
        }

        private static int CurrentEmployeeId()
        {
            int employeeId;
            string identityName = HttpContext.Current.User.Identity.Name;

            if (!int.TryParse(identityName, out employeeId))
            {
                throw new HttpException(401, "Unable to identify the logged-in user.");
            }

            return employeeId;
        }

        private static SqlCommand CreateProjectCommand(string procedureName, int projectId)
        {
            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, procedureName);
            AddIntParameter(command, "@ProjectID", projectId);
            return command;
        }

        private static void AddIntParameter(SqlCommand command, string name, int value)
        {
            SQLHelper.AddParamToSQLCmd(
                command, name, SqlDbType.Int, 0, ParameterDirection.Input, value);
        }

        private static void AddTextParameter(
            SqlCommand command,
            string name,
            string value,
            int size)
        {
            SQLHelper.AddParamToSQLCmd(
                command, name, SqlDbType.NVarChar, size, ParameterDirection.Input, value);
        }

        private static ProjectEmailConfigurationResponse SuccessResponse(string message, int count)
        {
            return new ProjectEmailConfigurationResponse
            {
                Success = true,
                Message = message,
                EmailCount = count
            };
        }

        private static string SerializeTable(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (table != null)
            {
                foreach (DataRow dataRow in table.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();

                    foreach (DataColumn column in table.Columns)
                    {
                        row.Add(column.ColumnName, dataRow[column]);
                    }

                    rows.Add(row);
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer
            {
                MaxJsonLength = int.MaxValue
            };
            return serializer.Serialize(rows);
        }

        public sealed class ProjectEmailConfigurationResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public int EmailCount { get; set; }
        }

        public sealed class ProjectEmailItem
        {
            public int ConfigurationId { get; set; }
            public string EmailType { get; set; }
            public string EmailAddress { get; set; }
        }
    }
}
