using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class DomainHealthReport : Page
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
        public static string GetSubdomains(int DomainId)
        {
            try
            {
                SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllSubdomains");
                SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", SqlDbType.Int, 10, ParameterDirection.Input, DomainId);
                DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
                return SerializeTable(dt);
            }
            catch
            {
                return "[]";
            }
        }

        [WebMethod]
        public static string GetReport(string FromMonth, string FromYear, string ToMonth, string ToYear, int DomainGroup, int SubdomainGroup)
        {
            try
            {
                SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_DomainHealthReport");
                SQLHelper.AddParamToSQLCmd(cmd, "@FromMonth", SqlDbType.NVarChar, 20, ParameterDirection.Input, FromMonth);
                SQLHelper.AddParamToSQLCmd(cmd, "@FromYear", SqlDbType.NVarChar, 20, ParameterDirection.Input, FromYear);
                SQLHelper.AddParamToSQLCmd(cmd, "@ToMonth", SqlDbType.NVarChar, 20, ParameterDirection.Input, ToMonth);
                SQLHelper.AddParamToSQLCmd(cmd, "@ToYear", SqlDbType.NVarChar, 20, ParameterDirection.Input, ToYear);
                SQLHelper.AddParamToSQLCmd(cmd, "@DomainGroup", SqlDbType.Int, 10, ParameterDirection.Input, DomainGroup);
                SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", SqlDbType.Int, 10, ParameterDirection.Input, SubdomainGroup);

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
