using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;

namespace WebPortal.App_Code.DAL
{
    public class dalCRM
    {
        public DataSet GetDashboard(int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Dashboard_Get");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            return SQLHelper.ExecuteDataSetCmd(cmd);
        }

        public DataSet GetReports(int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Report_Get");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            return SQLHelper.ExecuteDataSetCmd(cmd);
        }

        public DataSet GetLookups(int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Lookup_List");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            return SQLHelper.ExecuteDataSetCmd(cmd);
        }

        public DataSet GetAutomationCenter(int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Automation_Center_Get");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            return SQLHelper.ExecuteDataSetCmd(cmd);
        }

        public DataSet GetNotifications(int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Notification_List");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            return SQLHelper.ExecuteDataSetCmd(cmd);
        }

        public DataTable GetRecords(string entity, string searchText, string filterValue, int ownerId, int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Record_List");
            SQLHelper.AddParamToSQLCmd(cmd, "@Entity", SqlDbType.NVarChar, 30, ParameterDirection.Input, SafeString(entity));
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchText", SqlDbType.NVarChar, 200, ParameterDirection.Input, SafeString(searchText));
            SQLHelper.AddParamToSQLCmd(cmd, "@FilterValue", SqlDbType.NVarChar, 100, ParameterDirection.Input, SafeString(filterValue));
            SQLHelper.AddParamToSQLCmd(cmd, "@OwnerID", SqlDbType.Int, 10, ParameterDirection.Input, ownerId);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataSet GetRecord(string entity, int recordId, int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Record_Get");
            SQLHelper.AddParamToSQLCmd(cmd, "@Entity", SqlDbType.NVarChar, 30, ParameterDirection.Input, SafeString(entity));
            SQLHelper.AddParamToSQLCmd(cmd, "@RecordID", SqlDbType.Int, 10, ParameterDirection.Input, recordId);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            return SQLHelper.ExecuteDataSetCmd(cmd);
        }

        public int SaveLead(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Lead_Save");
            AddInt(cmd, "@LeadID", values, "LeadID");
            AddText(cmd, "@FirstName", values, "FirstName", 100);
            AddText(cmd, "@LastName", values, "LastName", 100);
            AddText(cmd, "@CompanyName", values, "CompanyName", 200);
            AddText(cmd, "@Title", values, "Title", 150);
            AddText(cmd, "@Email", values, "Email", 200);
            AddText(cmd, "@Phone", values, "Phone", 50);
            AddText(cmd, "@Mobile", values, "Mobile", 50);
            AddText(cmd, "@Website", values, "Website", 250);
            AddText(cmd, "@City", values, "City", 100);
            AddText(cmd, "@State", values, "State", 100);
            AddText(cmd, "@Country", values, "Country", 100);
            AddInt(cmd, "@LeadSourceID", values, "LeadSourceID");
            AddInt(cmd, "@LeadStatusID", values, "LeadStatusID");
            AddInt(cmd, "@AssignedToEmployeeID", values, "AssignedToEmployeeID");
            AddText(cmd, "@EstimatedValue", values, "EstimatedValue", 50);
            AddText(cmd, "@Rating", values, "Rating", 50);
            AddText(cmd, "@NextFollowUpDate", values, "NextFollowUpDate", 50);
            AddText(cmd, "@Description", values, "Description", 4000);
            AddInt(cmd, "@AddedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int SaveAccount(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Account_Save");
            AddInt(cmd, "@AccountID", values, "AccountID");
            AddText(cmd, "@AccountName", values, "AccountName", 200);
            AddText(cmd, "@AccountType", values, "AccountType", 100);
            AddText(cmd, "@Industry", values, "Industry", 150);
            AddText(cmd, "@Website", values, "Website", 250);
            AddText(cmd, "@Phone", values, "Phone", 50);
            AddText(cmd, "@Email", values, "Email", 200);
            AddText(cmd, "@BillingCity", values, "BillingCity", 100);
            AddText(cmd, "@BillingState", values, "BillingState", 100);
            AddText(cmd, "@BillingCountry", values, "BillingCountry", 100);
            AddText(cmd, "@AnnualRevenue", values, "AnnualRevenue", 50);
            AddInt(cmd, "@AssignedToEmployeeID", values, "AssignedToEmployeeID");
            AddText(cmd, "@Description", values, "Description", 4000);
            AddInt(cmd, "@AddedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int SaveContact(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Contact_Save");
            AddInt(cmd, "@ContactID", values, "ContactID");
            AddInt(cmd, "@AccountID", values, "AccountID");
            AddText(cmd, "@FirstName", values, "FirstName", 100);
            AddText(cmd, "@LastName", values, "LastName", 100);
            AddText(cmd, "@Title", values, "Title", 150);
            AddText(cmd, "@Email", values, "Email", 200);
            AddText(cmd, "@Phone", values, "Phone", 50);
            AddText(cmd, "@Mobile", values, "Mobile", 50);
            AddText(cmd, "@Department", values, "Department", 150);
            AddText(cmd, "@PreferredContactMethod", values, "PreferredContactMethod", 50);
            AddText(cmd, "@LastContactedDate", values, "LastContactedDate", 50);
            AddInt(cmd, "@AssignedToEmployeeID", values, "AssignedToEmployeeID");
            AddText(cmd, "@Description", values, "Description", 4000);
            AddInt(cmd, "@AddedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int SaveDeal(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Deal_Save");
            AddInt(cmd, "@DealID", values, "DealID");
            AddText(cmd, "@DealName", values, "DealName", 200);
            AddInt(cmd, "@AccountID", values, "AccountID");
            AddInt(cmd, "@ContactID", values, "ContactID");
            AddInt(cmd, "@LeadID", values, "LeadID");
            AddInt(cmd, "@DealStageID", values, "DealStageID");
            AddText(cmd, "@Amount", values, "Amount", 50);
            AddText(cmd, "@Probability", values, "Probability", 50);
            AddText(cmd, "@ExpectedCloseDate", values, "ExpectedCloseDate", 50);
            AddText(cmd, "@LostReason", values, "LostReason", 300);
            AddInt(cmd, "@AssignedToEmployeeID", values, "AssignedToEmployeeID");
            AddText(cmd, "@Description", values, "Description", 4000);
            AddInt(cmd, "@AddedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int SaveActivity(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Activity_Save");
            AddInt(cmd, "@ActivityID", values, "ActivityID");
            AddInt(cmd, "@ActivityTypeID", values, "ActivityTypeID");
            AddText(cmd, "@Subject", values, "Subject", 250);
            AddText(cmd, "@RelatedEntity", values, "RelatedEntity", 30);
            AddInt(cmd, "@RelatedRecordID", values, "RelatedRecordID");
            AddInt(cmd, "@ActivityStatusID", values, "ActivityStatusID");
            AddText(cmd, "@Priority", values, "Priority", 30);
            AddText(cmd, "@DueDate", values, "DueDate", 50);
            AddText(cmd, "@StartDateTime", values, "StartDateTime", 50);
            AddText(cmd, "@EndDateTime", values, "EndDateTime", 50);
            AddText(cmd, "@Outcome", values, "Outcome", 500);
            AddInt(cmd, "@AssignedToEmployeeID", values, "AssignedToEmployeeID");
            AddText(cmd, "@Description", values, "Description", 4000);
            AddInt(cmd, "@AddedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int SaveNote(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Note_Save");
            AddInt(cmd, "@NoteID", values, "NoteID");
            AddText(cmd, "@RelatedEntity", values, "RelatedEntity", 30);
            AddInt(cmd, "@RelatedRecordID", values, "RelatedRecordID");
            AddText(cmd, "@NoteTitle", values, "NoteTitle", 250);
            AddText(cmd, "@NoteText", values, "NoteText", 4000);
            AddInt(cmd, "@AddedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int SaveEmailSettings(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Email_Settings_Save");
            AddInt(cmd, "@EmailAccountID", values, "EmailAccountID");
            AddText(cmd, "@AccountName", values, "AccountName", 120);
            AddText(cmd, "@FromName", values, "FromName", 120);
            AddText(cmd, "@FromEmail", values, "FromEmail", 200);
            AddText(cmd, "@ReplyToEmail", values, "ReplyToEmail", 200);
            AddText(cmd, "@SmtpHost", values, "SmtpHost", 200);
            AddInt(cmd, "@SmtpPort", values, "SmtpPort");
            AddText(cmd, "@SmtpUserName", values, "SmtpUserName", 200);
            AddText(cmd, "@SmtpPassword", values, "SmtpPassword", 500);
            AddBit(cmd, "@EnableSSL", values, "EnableSSL");
            AddBit(cmd, "@IsEnabled", values, "IsEnabled");
            AddBit(cmd, "@AutoSendEnabled", values, "AutoSendEnabled");
            AddInt(cmd, "@UpdatedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int SaveNotificationSettings(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Notification_Settings_Save");
            AddInt(cmd, "@PreferenceID", values, "PreferenceID");
            AddInt(cmd, "@UserEmployeeID", values, "UserEmployeeID");
            AddBit(cmd, "@InAppEnabled", values, "InAppEnabled");
            AddBit(cmd, "@EmailEnabled", values, "EmailEnabled");
            AddBit(cmd, "@AssignmentEnabled", values, "AssignmentEnabled");
            AddBit(cmd, "@MentionEnabled", values, "MentionEnabled");
            AddBit(cmd, "@DueActivityEnabled", values, "DueActivityEnabled");
            AddBit(cmd, "@OverdueSLAEnabled", values, "OverdueSLAEnabled");
            AddBit(cmd, "@DailyDigestEnabled", values, "DailyDigestEnabled");
            AddText(cmd, "@DigestTime", values, "DigestTime", 20);
            AddInt(cmd, "@UpdatedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int SaveEmailTemplate(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Email_Template_Save");
            AddInt(cmd, "@TemplateID", values, "TemplateID");
            AddText(cmd, "@TemplateName", values, "TemplateName", 150);
            AddText(cmd, "@TriggerEvent", values, "TriggerEvent", 80);
            AddText(cmd, "@Subject", values, "Subject", 250);
            AddText(cmd, "@BodyHtml", values, "BodyHtml", 4000);
            AddBit(cmd, "@IsEnabled", values, "IsEnabled");
            AddInt(cmd, "@UpdatedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int SaveAssignmentRule(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Assignment_Rule_Save");
            AddInt(cmd, "@RuleID", values, "RuleID");
            AddText(cmd, "@RuleName", values, "RuleName", 150);
            AddText(cmd, "@Description", values, "Description", 500);
            AddText(cmd, "@ApplyOn", values, "ApplyOn", 30);
            AddText(cmd, "@ConditionField", values, "ConditionField", 120);
            AddText(cmd, "@ConditionOperator", values, "ConditionOperator", 40);
            AddText(cmd, "@ConditionValue", values, "ConditionValue", 250);
            AddText(cmd, "@RoutingMethod", values, "RoutingMethod", 60);
            AddText(cmd, "@UserEmployeeIDs", values, "UserEmployeeIDs", 500);
            AddText(cmd, "@ActiveDays", values, "ActiveDays", 120);
            AddInt(cmd, "@Priority", values, "Priority");
            AddBit(cmd, "@IsEnabled", values, "IsEnabled");
            AddInt(cmd, "@UpdatedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int SaveSlaPolicy(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_SLA_Policy_Save");
            AddInt(cmd, "@SLAPolicyID", values, "SLAPolicyID");
            AddText(cmd, "@PolicyName", values, "PolicyName", 150);
            AddText(cmd, "@ApplyOn", values, "ApplyOn", 30);
            AddInt(cmd, "@FirstResponseMinutes", values, "FirstResponseMinutes");
            AddInt(cmd, "@FollowUpMinutes", values, "FollowUpMinutes");
            AddText(cmd, "@WorkingHourStart", values, "WorkingHourStart", 20);
            AddText(cmd, "@WorkingHourEnd", values, "WorkingHourEnd", 20);
            AddBit(cmd, "@IsDefault", values, "IsDefault");
            AddBit(cmd, "@IsEnabled", values, "IsEnabled");
            AddText(cmd, "@ConditionsText", values, "ConditionsText", 1000);
            AddInt(cmd, "@UpdatedBy", values, "AddedBy");
            return ExecuteReturnValue(cmd);
        }

        public int DeleteRecord(string entity, int recordId, int deletedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Record_Delete");
            SQLHelper.AddParamToSQLCmd(cmd, "@Entity", SqlDbType.NVarChar, 30, ParameterDirection.Input, SafeString(entity));
            SQLHelper.AddParamToSQLCmd(cmd, "@RecordID", SqlDbType.Int, 10, ParameterDirection.Input, recordId);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeletedBy", SqlDbType.Int, 10, ParameterDirection.Input, deletedBy);
            return ExecuteReturnValue(cmd);
        }

        public int ConvertLead(int leadId, string dealName, string amount, string closeDate, int convertedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Lead_Convert");
            SQLHelper.AddParamToSQLCmd(cmd, "@LeadID", SqlDbType.Int, 10, ParameterDirection.Input, leadId);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealName", SqlDbType.NVarChar, 200, ParameterDirection.Input, SafeString(dealName));
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", SqlDbType.NVarChar, 50, ParameterDirection.Input, SafeString(amount));
            SQLHelper.AddParamToSQLCmd(cmd, "@ExpectedCloseDate", SqlDbType.NVarChar, 50, ParameterDirection.Input, SafeString(closeDate));
            SQLHelper.AddParamToSQLCmd(cmd, "@ConvertedBy", SqlDbType.Int, 10, ParameterDirection.Input, convertedBy);
            return ExecuteReturnValue(cmd);
        }

        public int DeleteAutomationItem(string entity, int recordId, int deletedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Automation_Item_Delete");
            SQLHelper.AddParamToSQLCmd(cmd, "@Entity", SqlDbType.NVarChar, 30, ParameterDirection.Input, SafeString(entity));
            SQLHelper.AddParamToSQLCmd(cmd, "@RecordID", SqlDbType.Int, 10, ParameterDirection.Input, recordId);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeletedBy", SqlDbType.Int, 10, ParameterDirection.Input, deletedBy);
            return ExecuteReturnValue(cmd);
        }

        public int QueueAutomationEvent(string entity, int recordId, string eventName, int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Automation_Event_Queue");
            SQLHelper.AddParamToSQLCmd(cmd, "@Entity", SqlDbType.NVarChar, 30, ParameterDirection.Input, SafeString(entity));
            SQLHelper.AddParamToSQLCmd(cmd, "@RecordID", SqlDbType.Int, 10, ParameterDirection.Input, recordId);
            SQLHelper.AddParamToSQLCmd(cmd, "@EventName", SqlDbType.NVarChar, 80, ParameterDirection.Input, SafeString(eventName));
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            return ExecuteReturnValue(cmd);
        }

        public int MarkNotificationsRead(int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Notification_MarkRead");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            return ExecuteReturnValue(cmd);
        }

        public DataSet RunAutomationDueJobs(int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_Automation_RunDueJobs");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);
            return SQLHelper.ExecuteDataSetCmd(cmd);
        }

        public DataSet GetAutomationDispatchBatch(int batchSize)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_EmailOutbox_DispatchBatch_Get");
            SQLHelper.AddParamToSQLCmd(cmd, "@BatchSize", SqlDbType.Int, 10, ParameterDirection.Input, batchSize);
            return SQLHelper.ExecuteDataSetCmd(cmd);
        }

        public int UpdateEmailOutboxStatus(int emailOutboxId, string status, string errorMessage)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "CRM_EmailOutbox_Status_Update");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailOutboxID", SqlDbType.Int, 10, ParameterDirection.Input, emailOutboxId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", SqlDbType.NVarChar, 40, ParameterDirection.Input, SafeString(status));
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorMessage", SqlDbType.NVarChar, 1000, ParameterDirection.Input, SafeString(errorMessage));
            return ExecuteReturnValue(cmd);
        }

        private static void AddText(SqlCommand cmd, string parameterName, Hashtable values, string key, int size)
        {
            SQLHelper.AddParamToSQLCmd(cmd, parameterName, SqlDbType.NVarChar, size, ParameterDirection.Input, GetString(values, key));
        }

        private static void AddInt(SqlCommand cmd, string parameterName, Hashtable values, string key)
        {
            SQLHelper.AddParamToSQLCmd(cmd, parameterName, SqlDbType.Int, 10, ParameterDirection.Input, GetInt(values, key));
        }

        private static void AddBit(SqlCommand cmd, string parameterName, Hashtable values, string key)
        {
            SQLHelper.AddParamToSQLCmd(cmd, parameterName, SqlDbType.Bit, 1, ParameterDirection.Input, GetBool(values, key));
        }

        private static int ExecuteReturnValue(SqlCommand cmd)
        {
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int returnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return returnValue;
        }

        private static string GetString(Hashtable values, string key)
        {
            if (values == null || !values.ContainsKey(key) || values[key] == null)
            {
                return string.Empty;
            }

            return Convert.ToString(values[key]).Trim();
        }

        private static int GetInt(Hashtable values, string key)
        {
            int parsedValue;
            return int.TryParse(GetString(values, key), out parsedValue) ? parsedValue : 0;
        }

        private static bool GetBool(Hashtable values, string key)
        {
            string value = GetString(values, key);
            return value == "1" || value.Equals("true", StringComparison.OrdinalIgnoreCase) || value.Equals("yes", StringComparison.OrdinalIgnoreCase) || value.Equals("on", StringComparison.OrdinalIgnoreCase);
        }

        private static string SafeString(string value)
        {
            return (value ?? string.Empty).Trim();
        }
    }
}
