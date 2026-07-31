using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;

namespace WebPortal.App_Code.DAL
{
    public class dalHelpdesk
    {
        private static SqlCommand Command(string procedure)
        {
            return SQLHelper.GetCommand(CommandType.StoredProcedure, procedure);
        }

        private static void Add(SqlCommand command, string name, SqlDbType type, object value, int size)
        {
            SqlParameter parameter = command.Parameters.Add(name, type, size);
            parameter.Value = value ?? DBNull.Value;
        }

        private static void Add(SqlCommand command, string name, SqlDbType type, object value)
        {
            SqlParameter parameter = command.Parameters.Add(name, type);
            parameter.Value = value ?? DBNull.Value;
        }

        private static object Value(Hashtable values, string key)
        {
            return values.ContainsKey(key) && values[key] != null && Convert.ToString(values[key]) != ""
                ? values[key] : DBNull.Value;
        }

        private static int ExecuteWithReturn(SqlCommand command)
        {
            SqlParameter result = command.Parameters.Add("@ReturnValue", SqlDbType.Int);
            result.Direction = ParameterDirection.ReturnValue;
            SQLHelper.ExecuteNonQueryCmd(command);
            return result.Value == DBNull.Value ? 0 : Convert.ToInt32(result.Value);
        }

        public DataSet GetBootstrap(int employeeId)
        {
            SqlCommand command = Command("usp_Helpdesk_Bootstrap");
            Add(command, "@EmployeeID", SqlDbType.Int, employeeId);
            return SQLHelper.ExecuteDataSetCmd(command);
        }

        public int CreateTicket(Hashtable values)
        {
            SqlCommand command = Command("usp_Helpdesk_CreateTicket");
            Add(command, "@RequesterID", SqlDbType.Int, Value(values, "RequesterID"));
            Add(command, "@OnBehalfOfID", SqlDbType.Int, Value(values, "OnBehalfOfID"));
            Add(command, "@CategoryID", SqlDbType.Int, Value(values, "CategoryID"));
            Add(command, "@Subject", SqlDbType.NVarChar, Value(values, "Subject"), 300);
            Add(command, "@Description", SqlDbType.NVarChar, Value(values, "Description"), -1);
            Add(command, "@Location", SqlDbType.NVarChar, Value(values, "Location"), 150);
            Add(command, "@AssetReference", SqlDbType.NVarChar, Value(values, "AssetReference"), 150);
            Add(command, "@ImpactCode", SqlDbType.VarChar, Value(values, "ImpactCode"), 20);
            Add(command, "@UrgencyCode", SqlDbType.VarChar, Value(values, "UrgencyCode"), 20);
            Add(command, "@ManagerApproverID", SqlDbType.Int, Value(values, "ManagerApproverID"));
            return ExecuteWithReturn(command);
        }

        public DataTable GetMyTickets(int employeeId, string status)
        {
            SqlCommand command = Command("usp_Helpdesk_MyTickets");
            Add(command, "@EmployeeID", SqlDbType.Int, employeeId);
            Add(command, "@StatusCode", SqlDbType.VarChar, status, 30);
            return SQLHelper.ExecuteDataTableCmd(command);
        }

        public DataTable GetQueue(int employeeId, string scope, string status, string priority)
        {
            SqlCommand command = Command("usp_Helpdesk_Queue");
            Add(command, "@EmployeeID", SqlDbType.Int, employeeId);
            Add(command, "@Scope", SqlDbType.VarChar, scope, 20);
            Add(command, "@StatusCode", SqlDbType.VarChar, status, 30);
            Add(command, "@PriorityCode", SqlDbType.VarChar, priority, 20);
            return SQLHelper.ExecuteDataTableCmd(command);
        }

        public DataTable GetAgents(int employeeId)
        {
            SqlCommand command = Command("usp_Helpdesk_Agents");
            Add(command, "@EmployeeID", SqlDbType.Int, employeeId);
            return SQLHelper.ExecuteDataTableCmd(command);
        }

        public DataSet GetTicket(int ticketId, int employeeId)
        {
            SqlCommand command = Command("usp_Helpdesk_TicketDetail");
            Add(command, "@TicketID", SqlDbType.Int, ticketId);
            Add(command, "@EmployeeID", SqlDbType.Int, employeeId);
            return SQLHelper.ExecuteDataSetCmd(command);
        }

        public int AddMessage(int ticketId, int employeeId, string message, bool isInternal)
        {
            SqlCommand command = Command("usp_Helpdesk_AddMessage");
            Add(command, "@TicketID", SqlDbType.Int, ticketId);
            Add(command, "@EmployeeID", SqlDbType.Int, employeeId);
            Add(command, "@MessageText", SqlDbType.NVarChar, message, -1);
            Add(command, "@IsInternal", SqlDbType.Bit, isInternal);
            return ExecuteWithReturn(command);
        }

        public int Assign(int ticketId, int agentEmployeeId, int assignedBy)
        {
            SqlCommand command = Command("usp_Helpdesk_Assign");
            Add(command, "@TicketID", SqlDbType.Int, ticketId);
            Add(command, "@AgentEmployeeID", SqlDbType.Int, agentEmployeeId);
            Add(command, "@AssignedBy", SqlDbType.Int, assignedBy);
            return ExecuteWithReturn(command);
        }

        public int Transition(int ticketId, int employeeId, string nextStatus, string comment)
        {
            SqlCommand command = Command("usp_Helpdesk_Transition");
            Add(command, "@TicketID", SqlDbType.Int, ticketId);
            Add(command, "@EmployeeID", SqlDbType.Int, employeeId);
            Add(command, "@NextStatus", SqlDbType.VarChar, nextStatus, 30);
            Add(command, "@Comment", SqlDbType.NVarChar, comment, -1);
            return ExecuteWithReturn(command);
        }

        public int DecideApproval(int ticketId, int approverId, string decision, string comment)
        {
            SqlCommand command = Command("usp_Helpdesk_ApprovalDecision");
            Add(command, "@TicketID", SqlDbType.Int, ticketId);
            Add(command, "@ApproverID", SqlDbType.Int, approverId);
            Add(command, "@Decision", SqlDbType.VarChar, decision, 20);
            Add(command, "@Comment", SqlDbType.NVarChar, comment, -1);
            return ExecuteWithReturn(command);
        }

        public DataSet GetAdministration(int employeeId)
        {
            SqlCommand command = Command("usp_Helpdesk_AdminCategories");
            Add(command, "@EmployeeID", SqlDbType.Int, employeeId);
            return SQLHelper.ExecuteDataSetCmd(command);
        }

        public int SaveCategory(Hashtable values)
        {
            SqlCommand command = Command("usp_Helpdesk_SaveCategory");
            Add(command, "@EmployeeID", SqlDbType.Int, Value(values, "EmployeeID"));
            Add(command, "@CategoryID", SqlDbType.Int, Value(values, "CategoryID"));
            Add(command, "@CategoryName", SqlDbType.NVarChar, Value(values, "CategoryName"), 150);
            Add(command, "@DepartmentID", SqlDbType.Int, Value(values, "DepartmentID"));
            Add(command, "@DepartmentName", SqlDbType.NVarChar, Value(values, "DepartmentName"), 150);
            Add(command, "@DefaultPriority", SqlDbType.VarChar, Value(values, "DefaultPriority"), 20);
            Add(command, "@ApprovalMode", SqlDbType.VarChar, Value(values, "ApprovalMode"), 20);
            Add(command, "@DefaultApproverID", SqlDbType.Int, Value(values, "DefaultApproverID"));
            Add(command, "@IsActive", SqlDbType.Bit, Value(values, "IsActive"));
            return ExecuteWithReturn(command);
        }

        public int SaveSla(Hashtable values)
        {
            SqlCommand command = Command("usp_Helpdesk_SaveSla");
            Add(command, "@EmployeeID", SqlDbType.Int, Value(values, "EmployeeID"));
            Add(command, "@SlaPolicyID", SqlDbType.Int, Value(values, "SlaPolicyID"));
            Add(command, "@PolicyName", SqlDbType.NVarChar, Value(values, "PolicyName"), 120);
            Add(command, "@PriorityCode", SqlDbType.VarChar, Value(values, "PriorityCode"), 20);
            Add(command, "@FirstResponseMins", SqlDbType.Int, Value(values, "FirstResponseMins"));
            Add(command, "@ResolutionMins", SqlDbType.Int, Value(values, "ResolutionMins"));
            Add(command, "@IsActive", SqlDbType.Bit, Value(values, "IsActive"));
            return ExecuteWithReturn(command);
        }

        public int SaveAgent(Hashtable values)
        {
            SqlCommand command = Command("usp_Helpdesk_SaveAgent");
            Add(command, "@EmployeeID", SqlDbType.Int, Value(values, "EmployeeID"));
            Add(command, "@AgentID", SqlDbType.Int, Value(values, "AgentID"));
            Add(command, "@AgentEmployeeID", SqlDbType.Int, Value(values, "AgentEmployeeID"));
            Add(command, "@DisplayName", SqlDbType.NVarChar, Value(values, "DisplayName"), 150);
            Add(command, "@DepartmentID", SqlDbType.Int, Value(values, "DepartmentID"));
            Add(command, "@RoleCode", SqlDbType.VarChar, Value(values, "RoleCode"), 20);
            Add(command, "@IsActive", SqlDbType.Bit, Value(values, "IsActive"));
            return ExecuteWithReturn(command);
        }
    }
}
