using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.DAL;

namespace WebPortal.Tracking
{
    public partial class ProjectProcessSequence : System.Web.UI.Page
    {
        private static string ConnectionString
        {
            get { return SQLHelper.ConnectionString; }
        }


        private static long CurrentUserID
        {
            get
            {
                long userID;
                if (!long.TryParse(HttpContext.Current.User.Identity.Name, out userID))
                    throw new Exception("Logged-in User ID is not available in User.Identity.Name.");
                return userID;
            }
        }

        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static List<Dictionary<string, object>> GetProjects()
        {
            return ExecuteTable("usp_GetAllProjectByUserRights", new SqlParameter("@EmployeeID", CurrentUserID));
        }


        [WebMethod]
        public static List<Dictionary<string, object>> GetProcesses(long projectID, long? sequenceID)
        {
            return ExecuteTable("usp_PPS_GetAvailableProcesses",
                new SqlParameter("@ProjectID", projectID),
                new SqlParameter("@ProjectProcessSequenceID", DbValue(sequenceID)));
        }

        [WebMethod]
        public static List<Dictionary<string, object>> List(long projectID)
        {
            return ExecuteTable("usp_PPS_List", new SqlParameter("@ProjectID", projectID));
        }

        [WebMethod]
        public static Dictionary<string, object> Get(long sequenceID)
        {
            var rows = ExecuteTable("usp_PPS_Get",
                new SqlParameter("@ProjectProcessSequenceID", sequenceID));
            return rows.Count == 0 ? null : rows[0];
        }

        [WebMethod]
        public static ApiResult_Track Save(SequenceInput input)
        {
            if (input == null) return new ApiResult_Track(false, "Invalid request.");

            return ExecuteResult("usp_PPS_Save",
                new SqlParameter("@ProjectProcessSequenceID", DbValue(input.ProjectProcessSequenceID)),
                new SqlParameter("@ProjectID", input.ProjectID),
                new SqlParameter("@ProcessID", input.ProcessID),
                new SqlParameter("@SequenceNo", input.SequenceNo),
                new SqlParameter("@IsMandatory", input.IsMandatory),
                new SqlParameter("@IsActive", input.IsActive),
                new SqlParameter("@UserID", CurrentUserID));
        }

        private static object DbValue(object value)
        {
            if (value == null) return DBNull.Value;
            return value;
        }

        private static List<Dictionary<string, object>> ExecuteTable(string procedure, params SqlParameter[] parameters)
        {
            var rows = new List<Dictionary<string, object>>();
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(procedure, con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                if (parameters != null && parameters.Length > 0) cmd.Parameters.AddRange(parameters);
                con.Open();
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        var row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                        for (var i = 0; i < dr.FieldCount; i++)
                            row[dr.GetName(i)] = dr.IsDBNull(i) ? null : dr.GetValue(i);
                        rows.Add(row);
                    }
                }
            }
            return rows;
        }

        private static ApiResult_Track ExecuteResult(string procedure, params SqlParameter[] parameters)
        {
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(procedure, con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddRange(parameters);
                con.Open();
                using (var dr = cmd.ExecuteReader())
                {
                    if (!dr.Read()) return new ApiResult_Track(false, "No response returned by procedure.");
                    return new ApiResult_Track(Convert.ToBoolean(dr["IsSuccess"]), Convert.ToString(dr["Message"]));
                }
            }
        }
    }

    public class SequenceInput
    {
        public long? ProjectProcessSequenceID { get; set; }
        public long ProjectID { get; set; }
        public long ProcessID { get; set; }
        public int SequenceNo { get; set; }
        public bool IsMandatory { get; set; }
        public bool IsActive { get; set; }
    }
}
