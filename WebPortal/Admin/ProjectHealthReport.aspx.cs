using Newtonsoft.Json;
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
    public partial class ProjectHealthReport : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        //[WebMethod]
        //public static string GetDomainGroups()
        //{
        //    try
        //    {
        //        SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllDomainGroupByUser");
        //        SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
        //        DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
        //        //DataTable dt = new bllMaster().GetDomainsAsPerEmp(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
        //        return SerializeTable(dt);
        //    }
        //    catch
        //    {
        //        return "[]";
        //    }
        //}

        [WebMethod]
        public static string GetDomainGroups()
        {
            try
            {
                int employeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllDomainGroupByUser");
                SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", SqlDbType.Int, 10, ParameterDirection.Input, employeeId);

                DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);

                bool showAllDomains = employeeId == 285; // change to your allowed login id

                var result = new
                {
                    ShowAllDomains = showAllDomains,
                    Domains = dt
                };

                return JsonConvert.SerializeObject(result);
            }
            catch
            {
                return "{\"ShowAllDomains\":false,\"Domains\":[]}";
            }
        }

        [WebMethod]
        public static string GetProjects(int DomainGroup)
        {
            try
            {
                SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetProjectsByDomainGroup");
                SQLHelper.AddParamToSQLCmd(cmd, "@DomainGroupId", SqlDbType.Int, 10, ParameterDirection.Input, DomainGroup);
                DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
                return SerializeTable(dt);
            }
            catch
            {
                return "[]";
            }
        }

        [WebMethod]
        public static string GetReport(string FromMonth, string FromYear, string ToMonth, string ToYear, int DomainGroup, int ProjectID)
        {
            try
            {
                SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_ProjectHealthReport");
                SQLHelper.AddParamToSQLCmd(cmd, "@FromMonth", SqlDbType.NVarChar, 20, ParameterDirection.Input, FromMonth);
                SQLHelper.AddParamToSQLCmd(cmd, "@FromYear", SqlDbType.NVarChar, 20, ParameterDirection.Input, FromYear);
                SQLHelper.AddParamToSQLCmd(cmd, "@ToMonth", SqlDbType.NVarChar, 20, ParameterDirection.Input, ToMonth);
                SQLHelper.AddParamToSQLCmd(cmd, "@ToYear", SqlDbType.NVarChar, 20, ParameterDirection.Input, ToYear);
                SQLHelper.AddParamToSQLCmd(cmd, "@DomainGroup", SqlDbType.Int, 10, ParameterDirection.Input, DomainGroup);
                SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 10, ParameterDirection.Input, ProjectID);

                DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
                return SerializeTable(dt);
            }
            catch
            {
                return "[]";
            }
        }

        private static string SerializeTable(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (table != null)
            {
                foreach (DataRow dr in table.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn col in table.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
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
