using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class UsersAppreciationDisplinaryAction : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetEmployeeProfile(int EmployeeID)
        {
            DataTable dt = new bllLogin().GetUserInformation(EmployeeID);
            return SerializeTable(dt);
        }

        [WebMethod]
        public static string GetActions(int EmployeeID, string Type)
        {
            DataTable dt = new bllMaster().GetAllSetAppreciationDisplinaryActionReport(Type, EmployeeID);
            return SerializeTable(dt);
        }

        [WebMethod]
        public static string GetActionDescription(int ActionID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetDescriptionByID");
            SQLHelper.AddParamToSQLCmd(cmd, "@ActionID", SqlDbType.BigInt, 0, ParameterDirection.Input, ActionID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return SerializeTable(dt);
        }

        [WebMethod]
        public static int UpdateWarningStatus(int ActionID, string WarningStatus, string Period, string Remark)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UpdateWarningStatus");
            SQLHelper.AddParamToSQLCmd(cmd, "@ActionID", SqlDbType.Int, 10, ParameterDirection.Input, ActionID);
            SQLHelper.AddParamToSQLCmd(cmd, "@WarnngStatus", SqlDbType.NVarChar, 100, ParameterDirection.Input, WarningStatus);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", SqlDbType.NVarChar, 5000, ParameterDirection.Input, string.IsNullOrWhiteSpace(Remark) ? string.Empty : Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@Period", SqlDbType.NVarChar, 5000, ParameterDirection.Input, string.IsNullOrWhiteSpace(Period) ? string.Empty : Period);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.Int, 50, ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            return Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
        }

        private static string SerializeTable(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row[col.ColumnName] = dr[col];
                    }
                    rows.Add(row);
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(rows);
        }
    }
}
