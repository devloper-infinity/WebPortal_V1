using System.Data;
using System.Data.SqlClient;
using WebPortal.App_Code.Class;

namespace WebPortal.App_Code.DAL
{
    public class dalInfinityFeedbackRca
    {
        public DataTable GetBootstrap(long feedbackId, string subdomain)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetInfinityFeedbackRcaBootstrap");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", SqlDbType.BigInt, 0, ParameterDirection.Input, feedbackId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", SqlDbType.NVarChar, 100, ParameterDirection.Input, subdomain);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetChildren(int errorType, int parentId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetInfinityFeedbackRcaChildren");
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorType", SqlDbType.TinyInt, 0, ParameterDirection.Input, errorType);
            SQLHelper.AddParamToSQLCmd(cmd, "@ParentID", SqlDbType.Int, 0, ParameterDirection.Input, parentId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public int SaveSelections(long feedbackId, string subdomain, int[] ids, int addedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_SaveInfinityFeedbackRcaSelections");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", SqlDbType.BigInt, 0, ParameterDirection.Input, feedbackId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", SqlDbType.NVarChar, 100, ParameterDirection.Input, subdomain);
            for (int index = 0; index < 9; index++)
                SQLHelper.AddParamToSQLCmd(cmd, "@ErrorType" + (index + 1) + "ID", SqlDbType.Int, 0, ParameterDirection.Input, ids[index]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.Int, 0, ParameterDirection.Input, addedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return System.Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
        }

        public int ValidateSelections(long feedbackId, string subdomain, int[] ids)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ValidateInfinityFeedbackRcaSelections");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", SqlDbType.BigInt, 0, ParameterDirection.Input, feedbackId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", SqlDbType.NVarChar, 100, ParameterDirection.Input, subdomain);
            for (int index = 0; index < 9; index++)
                SQLHelper.AddParamToSQLCmd(cmd, "@ErrorType" + (index + 1) + "ID", SqlDbType.Int, 0, ParameterDirection.Input, ids[index]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return System.Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
        }

        public int ClearSelections(long feedbackId, string subdomain)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ClearInfinityFeedbackRcaSelections");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", SqlDbType.BigInt, 0, ParameterDirection.Input, feedbackId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", SqlDbType.NVarChar, 100, ParameterDirection.Input, subdomain);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return System.Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
        }

        public DataTable GetReportValues(string feedbackIds)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetInfinityFeedbackRcaReportValues");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackIDs", SqlDbType.NVarChar, -1, ParameterDirection.Input, feedbackIds);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetAdminList(int errorType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetErrorTypeMasterAdmin");
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorType", SqlDbType.TinyInt, 0, ParameterDirection.Input, errorType);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetAdminParents(int errorType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetErrorTypeMasterParents");
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorType", SqlDbType.TinyInt, 0, ParameterDirection.Input, errorType);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public int AddMaster(int errorType, string name, int parentId, int displayOrder, int addedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_AddErrorTypeMaster");
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorType", SqlDbType.TinyInt, 0, ParameterDirection.Input, errorType);
            SQLHelper.AddParamToSQLCmd(cmd, "@Name", SqlDbType.NVarChar, 500, ParameterDirection.Input, name);
            SQLHelper.AddParamToSQLCmd(cmd, "@ParentID", SqlDbType.Int, 0, ParameterDirection.Input, parentId > 0 ? (object)parentId : System.DBNull.Value);
            SQLHelper.AddParamToSQLCmd(cmd, "@DisplayOrder", SqlDbType.Int, 0, ParameterDirection.Input, displayOrder > 0 ? (object)displayOrder : System.DBNull.Value);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.Int, 0, ParameterDirection.Input, addedBy);
            return System.Convert.ToInt32(SQLHelper.ExecuteScalarCmd(cmd));
        }

        public int SetMasterActive(int errorType, int id, bool isActive)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_SetErrorTypeMasterActive");
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorType", SqlDbType.TinyInt, 0, ParameterDirection.Input, errorType);
            SQLHelper.AddParamToSQLCmd(cmd, "@ID", SqlDbType.Int, 0, ParameterDirection.Input, id);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsActive", SqlDbType.Bit, 0, ParameterDirection.Input, isActive);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return System.Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
        }
    }
}
