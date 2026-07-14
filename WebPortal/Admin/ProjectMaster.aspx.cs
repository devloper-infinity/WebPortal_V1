using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ProjectMaster : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static ProjectListResult GetProjects()
        {
            ProjectListResult result = new ProjectListResult { Success = true };

            try
            {
                SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllProject_ActiveInactive");
                DataTable table = SQLHelper.ExecuteDataTableCmd(command);

                if (table == null) return result;

                foreach (DataRow row in table.Rows)
                {
                    result.Rows.Add(new ProjectMasterRow
                    {
                        ProjectId = ToInt(GetValue(row, "ProjectID")),
                        DomainName = GetValue(row, "DomainName"),
                        ProjectName = GetValue(row, "ProjectName"),
                        AddedByName = GetValue(row, "AddedByName"),
                        AddedDate = GetValue(row, "AddedDate"),
                        ProjectStatus = GetStatus(row)
                    });
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.Message = "Unable to load project records. " + ex.Message;
            }

            return result;
        }

        [WebMethod(EnableSession = true)]
        public static ProjectCommandResult SaveProject(ProjectSaveRequest request)
        {
            if (request == null)
                return Fail("Invalid project request.");

            string projectName = NormalizeProjectName(request.ProjectName);
            string validation = ValidateProjectName(projectName);
            if (!string.IsNullOrWhiteSpace(validation))
                return Fail(validation);

            try
            {
                long employeeId = GetCurrentEmployeeId();
                int returnValue;

                if (request.ProjectId <= 0)
                {
                    returnValue = InsertProject(projectName, employeeId);

                    if (returnValue > 0)
                    {
                        return new ProjectCommandResult
                        {
                            Success = true,
                            Code = returnValue,
                            Message = "Project created successfully."
                        };
                    }

                    if (returnValue == -1)
                    {
                        return new ProjectCommandResult
                        {
                            Success = false,
                            Code = returnValue,
                            RequiresRestore = true,
                            Message = "This project was previously deleted. Do you want to restore it?"
                        };
                    }

                    return new ProjectCommandResult
                    {
                        Success = false,
                        Code = returnValue,
                        Message = "Project already exists."
                    };
                }

                returnValue = UpdateProject(projectName, request.ProjectId, request.IsActive, employeeId);
                return returnValue > 0
                    ? new ProjectCommandResult { Success = true, Code = returnValue, Message = "Project updated successfully." }
                    : new ProjectCommandResult { Success = false, Code = returnValue, Message = "Project already exists or could not be updated." };
            }
            catch (Exception ex)
            {
                return Fail("Unable to save project. " + ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static ProjectCommandResult RestoreProject(string projectName)
        {
            projectName = NormalizeProjectName(projectName);
            string validation = ValidateProjectName(projectName);
            if (!string.IsNullOrWhiteSpace(validation))
                return Fail(validation);

            try
            {
                int returnValue = UpdateProject(projectName, 0, true, GetCurrentEmployeeId());
                return returnValue > 0
                    ? new ProjectCommandResult { Success = true, Code = returnValue, Message = "Project restored successfully." }
                    : new ProjectCommandResult { Success = false, Code = returnValue, Message = "Unable to restore project." };
            }
            catch (Exception ex)
            {
                return Fail("Unable to restore project. " + ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static ProjectCommandResult DeleteProject(int projectId)
        {
            if (projectId <= 0)
                return Fail("Invalid project record.");

            try
            {
                SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_deleteProject");
                SQLHelper.AddParamToSQLCmd(command, "@ProjectID", SqlDbType.BigInt, 0, ParameterDirection.Input, projectId);
                SQLHelper.AddParamToSQLCmd(command, "@EmployeeID", SqlDbType.BigInt, 0, ParameterDirection.Input, GetCurrentEmployeeId());
                SQLHelper.AddParamToSQLCmd(command, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
                SQLHelper.ExecuteNonQueryCmd(command);

                int returnValue = ToInt(command.Parameters["@ReturnValue"].Value);
                command.Dispose();

                return returnValue > 0
                    ? new ProjectCommandResult { Success = true, Code = returnValue, Message = "Project deleted successfully." }
                    : new ProjectCommandResult { Success = false, Code = returnValue, Message = "Unable to delete project." };
            }
            catch (Exception ex)
            {
                return Fail("Unable to delete project. " + ex.Message);
            }
        }

        private static int InsertProject(string projectName, long employeeId)
        {
            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_InsertProject");
            SQLHelper.AddParamToSQLCmd(command, "@Project", SqlDbType.VarChar, 100, ParameterDirection.Input, projectName);
            SQLHelper.AddParamToSQLCmd(command, "@AddedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, employeeId);
            SQLHelper.AddParamToSQLCmd(command, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(command);

            int returnValue = ToInt(command.Parameters["@ReturnValue"].Value);
            command.Dispose();
            return returnValue;
        }

        private static int UpdateProject(string projectName, int projectId, bool isActive, long employeeId)
        {
            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UpdateProject");
            SQLHelper.AddParamToSQLCmd(command, "@ProjectID", SqlDbType.BigInt, 0, ParameterDirection.Input, projectId);
            SQLHelper.AddParamToSQLCmd(command, "@ProjectName", SqlDbType.VarChar, 100, ParameterDirection.Input, projectName);
            SQLHelper.AddParamToSQLCmd(command, "@Status", SqlDbType.Bit, 0, ParameterDirection.Input, isActive);
            SQLHelper.AddParamToSQLCmd(command, "@EmployeeID", SqlDbType.BigInt, 0, ParameterDirection.Input, employeeId);
            SQLHelper.AddParamToSQLCmd(command, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(command);

            int returnValue = ToInt(command.Parameters["@ReturnValue"].Value);
            command.Dispose();
            return returnValue;
        }

        private static string ValidateProjectName(string projectName)
        {
            if (string.IsNullOrWhiteSpace(projectName))
                return "Please enter Project name.";
            if (projectName.Length > 100)
                return "Project name cannot exceed 100 characters.";
            if (!Regex.IsMatch(projectName, @"^[0-9A-Za-z-]+(?: [0-9A-Za-z-]+)*$"))
                return "Use only letters, numbers, spaces, and hyphens.";
            return string.Empty;
        }

        private static string NormalizeProjectName(string value)
        {
            return Regex.Replace((value ?? string.Empty).Trim(), @"\s+", " ");
        }

        private static long GetCurrentEmployeeId()
        {
            long employeeId;
            string identity = Convert.ToString(HttpContext.Current.User.Identity.Name);
            if (long.TryParse(identity, out employeeId) && employeeId > 0)
                return employeeId;

            employeeId = EmployeeInfo.Current.EmployeeID;
            if (employeeId <= 0)
                throw new UnauthorizedAccessException("Your login session is not valid.");
            return employeeId;
        }

        private static string GetValue(DataRow row, string columnName)
        {
            if (row == null || row.Table == null) return string.Empty;

            foreach (DataColumn column in row.Table.Columns)
            {
                if (string.Equals(column.ColumnName, columnName, StringComparison.OrdinalIgnoreCase))
                    return Convert.ToString(row[column]);
            }

            return string.Empty;
        }

        private static string GetStatus(DataRow row)
        {
            string value = GetValue(row, "ProjectStatus");
            if (string.IsNullOrWhiteSpace(value)) value = GetValue(row, "Status");

            string normalized = (value ?? string.Empty).Trim();
            return string.Equals(normalized, "Active", StringComparison.OrdinalIgnoreCase)
                || string.Equals(normalized, "True", StringComparison.OrdinalIgnoreCase)
                || normalized == "1"
                ? "Active"
                : "Deactive";
        }

        private static int ToInt(object value)
        {
            int parsed;
            return int.TryParse(Convert.ToString(value), out parsed) ? parsed : 0;
        }

        private static ProjectCommandResult Fail(string message)
        {
            return new ProjectCommandResult { Success = false, Message = message };
        }
    }

    public class ProjectSaveRequest
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public bool IsActive { get; set; }
    }

    public class ProjectCommandResult
    {
        public bool Success { get; set; }
        public int Code { get; set; }
        public bool RequiresRestore { get; set; }
        public string Message { get; set; }
    }

    public class ProjectListResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public List<ProjectMasterRow> Rows { get; set; }

        public ProjectListResult()
        {
            Rows = new List<ProjectMasterRow>();
        }
    }

    public class ProjectMasterRow
    {
        public int ProjectId { get; set; }
        public string DomainName { get; set; }
        public string ProjectName { get; set; }
        public string AddedByName { get; set; }
        public string AddedDate { get; set; }
        public string ProjectStatus { get; set; }
    }
}
