using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;

namespace WebPortal.App_Code.DAL
{
    public class dalFeedback
    {
        public DataTable GetAllDomain()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllDomain");
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetAllProjectByDomainWise(int domainId, int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "WBT_usp_GetAllProjectByDomainWise");
            AddInt(cmd, "@DomainID", domainId);
            AddInt(cmd, "@EmployeeId", employeeId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetAllProjectByUserRights(string employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllProjectByUserRights");
            AddText(cmd, "@EmployeeID", employeeId, 100);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetProcess(int projectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "GetProcessBYProject");
            AddInt(cmd, "@ProjectID", projectId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetFeedbackSectionAndField()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetFeedback_SectionAndField");
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public int InsertSectionAndField(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_InsertSectionAndField");
            AddFromTable(cmd, "@DomainID", SqlDbType.BigInt, values, "DomainID", 10);
            AddFromTable(cmd, "@ProjectID", SqlDbType.BigInt, values, "ProjectID", 10);
            AddFromTable(cmd, "@Section", SqlDbType.NVarChar, values, "Section", 500);
            AddFromTable(cmd, "@Field", SqlDbType.NVarChar, values, "Field", 500);
            AddFromTable(cmd, "@Weightage", SqlDbType.NVarChar, values, "Weightage", 100);
            AddFromTable(cmd, "@AddedBy", SqlDbType.BigInt, values, "AddedBy", 10);
            return ExecuteReturnValue(cmd);
        }

        public int UpdateSectionAndField(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UpdateSectionAndField");
            AddFromTable(cmd, "@ID", SqlDbType.BigInt, values, "ID", 10);
            AddFromTable(cmd, "@Domain", SqlDbType.BigInt, values, "Domain", 10);
            AddFromTable(cmd, "@Project", SqlDbType.BigInt, values, "Project", 10);
            AddFromTable(cmd, "@Section", SqlDbType.NVarChar, values, "Section", 500);
            AddFromTable(cmd, "@Field", SqlDbType.NVarChar, values, "Field", 500);
            AddFromTable(cmd, "@Weightage", SqlDbType.NVarChar, values, "Weightage", 100);
            AddFromTable(cmd, "@UpdatedBy", SqlDbType.BigInt, values, "UpdatedBy", 10);
            return ExecuteReturnValue(cmd);
        }

        public int DeleteSectionAndField(int id, int deletedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_DeleteSectionAndField");
            AddInt(cmd, "@ID", id);
            AddInt(cmd, "@DeletedBy", deletedBy);
            return ExecuteReturnValue(cmd);
        }

        public DataTable CheckProjectIsApplicableForSectionField(int projectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_CheckProjectIsApplicableForSectionField");
            AddInt(cmd, "@ProjectID", projectId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetFieldBySection(int projectId, string section)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_Feedback_GetFieldBySection");
            AddInt(cmd, "@ProjectID", projectId);
            AddText(cmd, "@Section", section, 500);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public string ValidateProject(string project)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ValidateProject");
            AddText(cmd, "@Project", project, 100);
            return Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
        }

        public string ValidateProcess(string project, string process)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ValidateProcess");
            AddText(cmd, "@Project", project, 100);
            AddText(cmd, "@Process", process, 200);
            return Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
        }

        public string ValidateUserProjectRights(string employeeId, string projectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ValidateUserProjectRights");
            AddText(cmd, "@EmployeeId", employeeId, 100);
            AddText(cmd, "@ProjectId", projectId, 100);
            return Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
        }

        public string ValidateEmployeeCode(string code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetEmployeeInfoByCode");
            AddText(cmd, "@Code", code, 50);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt != null && dt.Rows.Count > 0 ? Convert.ToString(dt.Rows[0]["EmployeeID"]) : "0";
        }

        public string ValidateSectionAndFieldByProject(string projectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ValidateSectionAndFieldByProject");
            AddText(cmd, "@ProjectID", projectId, 100);
            return Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
        }

        public string ValidateSection(string projectId, string section)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ValidateSection");
            AddText(cmd, "@ProjectID", projectId, 100);
            AddText(cmd, "@Section", section, 500);
            return Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
        }

        public string ValidateFieldName(string projectId, string section, string fieldName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ValidateFieldName");
            AddText(cmd, "@ProjectID", projectId, 100);
            AddText(cmd, "@Section", section, 500);
            AddText(cmd, "@FieldName", fieldName, 500);
            return Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
        }

        public int CheckProjectUnderwriting(int projectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_CheckProject_Underwriting");
            AddInt(cmd, "@ProjectID", projectId);
            return ToInt(SQLHelper.ExecuteScalarCmd(cmd));
        }

        public string GetUserCodeByEmployeeID(string employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetUserInformation");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, ToInt(employeeId));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            if (dt == null || dt.Rows.Count == 0) return string.Empty;

            DataRow row = dt.Rows[0];
            return FirstString(row, "Code", "EmployeeCode", "UserCode", "PsuedoName", "PseudoName");
        }

        public DataTable ViewAllFeedbackByPMWise(string fromDate, string toDate, string employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ViewAllFeedbackByPMwise");
            AddText(cmd, "@From", fromDate, 100);
            AddText(cmd, "@To", toDate, 100);
            AddText(cmd, "@EmployeeID", employeeId, 100);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable ViewAllFeedbackByUserWise(string employeeId, string role, string fromDate, string toDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ViewAllFeedbackByUserwise");
            AddText(cmd, "@EmployeeID", employeeId, 100);
            AddText(cmd, "@Role", role, 100);
            AddText(cmd, "@From", fromDate, 100);
            AddText(cmd, "@To", toDate, 100);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable ViewAllFeedbackByClientWise(string employeeId, string fromDate, string toDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllFeedbackByClientWise");
            AddText(cmd, "@EmployeeID", employeeId, 100);
            AddText(cmd, "@From", fromDate, 100);
            AddText(cmd, "@To", toDate, 100);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable ViewFeedbackByPMWise(string employeeId, string fatal)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ViewFeedbackByPMWise");
            AddText(cmd, "@EmployeeID", employeeId, 100);
            AddText(cmd, "@Fatal", fatal, 100);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable ViewFeedbackByUserWise(string employeeId, string fatal)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ViewFeedbackByUserWise");
            AddText(cmd, "@EmployeeID", employeeId, 100);
            AddText(cmd, "@Fatal", fatal, 100);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable ViewFeedbackByOrderWise(string orderNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ViewFeedbackByOrderWise");
            AddText(cmd, "@OrderNo", orderNo, 200);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable ViewAllFeedbackByRecordWise(string feedDetailsId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ViewAllFeedbackByRecordwise");
            AddText(cmd, "@FeedDetailsId", feedDetailsId, 100);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable ViewNewOrderFeedbackByOrderWise(string employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ViewNewOrderFeedbackByOrderwise");
            AddText(cmd, "@EmployeeID", employeeId, 100);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public int DeleteFeedback(int feedDetailsId, int deletedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_DeleteFeedbak");
            AddInt(cmd, "@FeedDetailsId", feedDetailsId);
            AddInt(cmd, "@DeletedBy", deletedBy);
            return ExecuteReturnValue(cmd);
        }

        public int InsertFeedbackForNewOrder(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_InsertFeedbackForNewOrder_KRL");
            AddFromTable(cmd, "@OrderNo", SqlDbType.NVarChar, values, "OrderNo", 100);
            AddFromTable(cmd, "@DealNo", SqlDbType.NVarChar, values, "DealNo", 100);
            AddFromTable(cmd, "@OrderDate", SqlDbType.NVarChar, values, "OrderDate", 100);
            AddFromTable(cmd, "@ProjectID", SqlDbType.BigInt, values, "ProjectID", 10);
            AddFromTable(cmd, "@ProcessID", SqlDbType.BigInt, values, "ProcessID", 10);
            AddFromTable(cmd, "@ErrorDoneBy ", SqlDbType.NVarChar, values, "ErrorDoneBy", 100);
            AddFromTable(cmd, "@FeedbackGivenBy ", SqlDbType.NVarChar, values, "FeedbackGivenBy", 100);
            AddFromTable(cmd, "@AddedBy ", SqlDbType.BigInt, values, "AddedBy", 10);
            return ExecuteReturnValue(cmd);
        }

        public int AddFeedbackForNewOrder(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_AddFeedbackForNewOrder_1");
            AddFromTable(cmd, "@Feedback", SqlDbType.NVarChar, values, "Feedback", 100);
            AddFromTable(cmd, "@ErrorType", SqlDbType.NVarChar, values, "ErrorType", 10000);
            AddFromTable(cmd, "@Fatal", SqlDbType.NVarChar, values, "Fatal", 10000);
            AddFromTable(cmd, "@ErrorField", SqlDbType.NVarChar, values, "ErrorField", 10000);
            AddFromTable(cmd, "@Section", SqlDbType.NVarChar, values, "Section", 10000);
            AddFromTable(cmd, "@Field", SqlDbType.NVarChar, values, "Field", 10000);
            AddFromTable(cmd, "@Error", SqlDbType.NVarChar, values, "Error", 10000);
            AddFromTable(cmd, "@Shouldbe", SqlDbType.NVarChar, values, "Shouldbe", 10000);
            AddFromTable(cmd, "@FeedbackType", SqlDbType.NVarChar, values, "FeedbackType", 10000);
            AddFromTable(cmd, "@FeedbackRecivedDate", SqlDbType.NVarChar, values, "FeedbackRecivedDate", 10000);
            AddFromTable(cmd, "@Remark", SqlDbType.NVarChar, values, "Remark", 10000);
            AddFromTable(cmd, "@FeedbackerrorPath", SqlDbType.NVarChar, values, "FeedbackerrorPath", 10000);
            AddFromTable(cmd, "@AddedBy", SqlDbType.BigInt, values, "AddedBy", 10);
            return ExecuteReturnValue(cmd);
        }

        public int AddEDBStatusByOrderWise(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_AddEDBStatusbyOrderWise");
            AddFromTable(cmd, "@FeedDetailsId", SqlDbType.BigInt, values, "FeedDetailsId", 10);
            AddFromTable(cmd, "@EDBStatus", SqlDbType.NVarChar, values, "EDBStatus", 100);
            AddFromTable(cmd, "@EDBExplanation", SqlDbType.NVarChar, values, "EDBExplanation", 4000);
            AddFromTable(cmd, "@AddedBy", SqlDbType.BigInt, values, "AddedBy", 10);
            return ExecuteReturnValue(cmd);
        }

        public int AddPMStatusByOrderWise(Hashtable values)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_AddPMStatusbyOrderWise");
            AddFromTable(cmd, "@FeedDetailsId", SqlDbType.BigInt, values, "FeedDetailsId", 10);
            AddFromTable(cmd, "@PMStatus", SqlDbType.NVarChar, values, "PMStatus", 100);
            AddFromTable(cmd, "@PMExplanation", SqlDbType.NVarChar, values, "PMExplanation", 4000);
            AddFromTable(cmd, "@AddedBy", SqlDbType.BigInt, values, "AddedBy", 10);
            return ExecuteReturnValue(cmd);
        }

        private static int ExecuteReturnValue(SqlCommand cmd)
        {
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return ToInt(cmd.Parameters["@ReturnValue"].Value);
        }

        private static void AddInt(SqlCommand cmd, string name, int value)
        {
            SQLHelper.AddParamToSQLCmd(cmd, name, SqlDbType.BigInt, 10, ParameterDirection.Input, value);
        }

        private static void AddText(SqlCommand cmd, string name, string value, int size)
        {
            SQLHelper.AddParamToSQLCmd(cmd, name, SqlDbType.NVarChar, size, ParameterDirection.Input, Safe(value));
        }

        private static void AddFromTable(SqlCommand cmd, string parameterName, SqlDbType type, Hashtable values, string key, int size)
        {
            object value = values != null && values.ContainsKey(key) ? values[key] : null;
            SQLHelper.AddParamToSQLCmd(cmd, parameterName, type, size, ParameterDirection.Input, value ?? DBNull.Value);
        }

        private static string Safe(string value)
        {
            return value == null ? string.Empty : value.Trim();
        }

        private static int ToInt(object value)
        {
            int result;
            return value != null && int.TryParse(Convert.ToString(value), out result) ? result : 0;
        }

        private static string FirstString(DataRow row, params string[] names)
        {
            foreach (string name in names)
            {
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value)
                {
                    string value = Convert.ToString(row[name]);
                    if (!string.IsNullOrWhiteSpace(value)) return value;
                }
            }

            return string.Empty;
        }
    }
}
