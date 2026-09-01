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
    }
}
