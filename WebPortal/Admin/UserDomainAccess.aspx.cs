using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.DAL;
using System.Web.Script.Serialization;

namespace WebPortal.Admin
{
    public partial class UserDomainAccess : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private static string SerializeTable(DataTable dt)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, object>> rows =
                new System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, object>>();

            foreach (DataRow dr in dt.Rows)
            {
                System.Collections.Generic.Dictionary<string, object> row =
                    new System.Collections.Generic.Dictionary<string, object>();

                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }

                rows.Add(row);
            }

            return serializer.Serialize(rows);
        }

        private static int CurrentUserId()
        {
            int userId = 0;

            if (HttpContext.Current.User != null &&
                HttpContext.Current.User.Identity != null &&
                !string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name))
            {
                int.TryParse(HttpContext.Current.User.Identity.Name, out userId);
            }

            return userId;
        }

        [WebMethod]
        public static string GetEmployees()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UserDomainAccess_GetEmployees");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return SerializeTable(dt);
        }

        [WebMethod]
        public static string GetDomains()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UserDomainAccess_GetDomains");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return SerializeTable(dt);
        }

        [WebMethod]
        public static string GetAssignedDomains(int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UserDomainAccess_GetAssigned");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 0, ParameterDirection.Input, employeeId);

            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return SerializeTable(dt);
        }

        [WebMethod]
        public static string SaveAccess(int employeeId, int domainId)
        {
            int addedBy = CurrentUserId();

            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UserDomainAccess_Save");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 0, ParameterDirection.Input, employeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", SqlDbType.Int, 0, ParameterDirection.Input, domainId);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.Int, 0, ParameterDirection.Input, addedBy);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            return "Domain assigned successfully.";
        }

        [WebMethod]
        public static string SaveMultipleAccess(int employeeId, int[] domainIds)
        {
            int addedBy = CurrentUserId();

            foreach (int domainId in domainIds)
            {
                SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UserDomainAccess_Save");

                SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 0, ParameterDirection.Input, employeeId);
                SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", SqlDbType.Int, 0, ParameterDirection.Input, domainId);
                SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.Int, 0, ParameterDirection.Input, addedBy);

                SQLHelper.ExecuteNonQueryCmd(cmd);
            }

            return "Selected domains assigned successfully.";
        }

        [WebMethod]
        public static string DeleteAccess(int accessId)
        {
            int updatedBy = CurrentUserId();

            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UserDomainAccess_Delete");
            SQLHelper.AddParamToSQLCmd(cmd, "@AccessID", SqlDbType.Int, 0, ParameterDirection.Input, accessId);
            SQLHelper.AddParamToSQLCmd(cmd, "@UpdatedBy", SqlDbType.Int, 0, ParameterDirection.Input, updatedBy);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            return "Domain access removed successfully.";
        }
    }
}