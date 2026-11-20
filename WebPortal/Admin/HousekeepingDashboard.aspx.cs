using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Xml.Linq;
using System.Web.UI;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class HousekeepingDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Context.User == null || !Context.User.Identity.IsAuthenticated) Response.Redirect("~/Login.aspx", true);
        }

        private static readonly Dictionary<string, string> Modules = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            {"Buildings","HK_BuildingMaster"},{"Floors","HK_FloorMaster"},{"Locations","HK_LocationMaster"},{"Staff","HK_StaffMaster"},
            {"Vendors","HK_VendorMaster"},{"Activities","HK_ActivityMaster"},{"Schedules","HK_ActivitySchedule"},{"Attendance","HK_StaffAttendance"},
            {"DailyActivities","HK_DailyActivities"},{"WeeklyMonthlyActivities","HK_WeeklyMonthlyActivities"},{"Inspections","HK_SupervisorInspection"},
            {"VendorPerformance","HK_VendorPerformance"},{"Complaints","HK_ComplaintManagement"},{"Inventory","HK_ConsumableInventory"},
            {"StaffPerformance","HK_StaffPerformance"},{"ConsolidatedReport","HK_ConsolidatedReport"},{"Consumables","HK_Consumables"},{"DashboardDetails","HousekeepingDashboard"}
        };

        public sealed class Reply { public bool Success { get; set; } public string Message { get; set; } public bool CanWrite { get; set; } public object Rows { get; set; } public object Summary { get; set; } }
        private static int EmployeeId()
        {
            var ctx = HttpContext.Current;
            if (ctx == null || ctx.User == null || !ctx.User.Identity.IsAuthenticated) throw new UnauthorizedAccessException("Sign in to continue.");
            int id;
            if (ctx.Session != null && int.TryParse(Convert.ToString(ctx.Session["EmployeeID"]), out id) && id > 0) return id;
            if (ctx.Session != null && int.TryParse(Convert.ToString(ctx.Session["UserName"]), out id) && id > 0) return id;
            if (int.TryParse(ctx.User.Identity.Name, out id) && id > 0) return id;
            throw new UnauthorizedAccessException("Your employee session has expired. Sign in again.");
        }
        private static string ConnectionString { get { return SQLHelper.ConnectionString; } }
        private static string Role(int employeeId, string module)
        {
            using (var c = new SqlConnection(ConnectionString)) using (var q = new SqlCommand("SELECT TOP 1 RoleName FROM dbo.HK_UserRole WHERE EmployeeID=@EmployeeID AND IsActive=1 AND BuildingID IS NULL AND VendorID IS NULL ORDER BY CASE RoleName WHEN 'Admin' THEN 0 WHEN 'Management' THEN 1 WHEN 'Supervisor' THEN 2 ELSE 3 END", c))
            { q.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId; c.Open(); return Convert.ToString(q.ExecuteScalar()); }
        }
        private static bool CanWrite(string role, string module)
        {
            if (role == "Admin") return true;
            return role == "Supervisor" && new[] { "Buildings", "Floors", "Locations", "Staff", "Vendors", "Activities", "Schedules", "Attendance", "DailyActivities", "WeeklyMonthlyActivities", "Inspections", "Complaints", "Inventory", "Consumables", "VendorPerformance" }.Contains(module);
        }
        private static DataTable Query(string procedure, int employeeId, string module, string filters)
        {
            using (var c = new SqlConnection(ConnectionString)) using (var q = new SqlCommand(procedure, c))
            using (var a = new SqlDataAdapter(q))
            {
                var values = new JavaScriptSerializer().Deserialize<Dictionary<string, object>>(String.IsNullOrWhiteSpace(filters) ? "{}" : filters);
                var filterXml = new XElement("Filters", values.Select(pair => new XElement(pair.Key, Convert.ToString(pair.Value, CultureInfo.InvariantCulture))));
                q.CommandType = CommandType.StoredProcedure; q.Parameters.Add("@Module", SqlDbType.VarChar, 40).Value = module;
                q.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId; q.Parameters.Add("@Filters", SqlDbType.Xml).Value = filterXml.ToString(SaveOptions.DisableFormatting);
                var t = new DataTable(); a.Fill(t); return t;
            }
        }
        private static List<Dictionary<string, object>> Rows(DataTable t)
        {
            return t.AsEnumerable().Select(r => t.Columns.Cast<DataColumn>().ToDictionary(c => c.ColumnName, c => r.IsNull(c) ? null : r[c])).ToList();
        }
        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static Reply LoadModule(string module, string filtersJson)
        {
            try
            {
                int employee = EmployeeId(); string role = Role(employee, module);
                if (String.IsNullOrEmpty(role) || !(role == "Admin" || role == "Management" || role == "Supervisor")) return new Reply { Success = false, Message = "You do not have Housekeeping access." };
                if (!Modules.ContainsKey(module)) return new Reply { Success = false, Message = "Unknown module." };
                DataTable result = Query("dbo.usp_HK_GetModuleData", employee, module, filtersJson);
                var reply = new Reply { Success = true, CanWrite = CanWrite(role, module), Rows = Rows(result), Message = "Loaded." };
                if (module == "DashboardDetails" && result.Rows.Count > 0) { reply.Summary = Rows(result).First(); reply.Rows = new List<Dictionary<string, object>>(); }
                return reply;
            }
            catch (UnauthorizedAccessException ex) { return new Reply { Success = false, Message = ex.Message }; }
            catch (Exception) { return new Reply { Success = false, Message = "Housekeeping data could not be loaded. Check that the module database scripts are installed." }; }
        }
        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static Dictionary<string, object> LoadLookups()
        {
            var answer = new Dictionary<string, object>();
            try
            {
                int employee = EmployeeId(); string role = Role(employee, "Buildings"); if (!(role == "Admin" || role == "Management" || role == "Supervisor")) return answer;
                using (var c = new SqlConnection(ConnectionString)) using (var q = new SqlCommand("dbo.usp_HK_GetLookups", c))
                {
                    q.CommandType = CommandType.StoredProcedure; q.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employee; c.Open();
                    using (var r = q.ExecuteReader()) { string[] names = { "Buildings", "Floors", "Staff", "Vendors", "Activities", "Locations", "Assignments", "Consumables" }; int index = 0; do { var values = new List<object>(); while (r.Read()) values.Add(new { ID = r.GetValue(0), Name = r.GetValue(1) }); if (index < names.Length) answer[names[index]] = values; index++; } while (r.NextResult()); }
                }
            }
            catch { }
            return answer;
        }
        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static Reply SaveModule(string module, string payloadJson)
        {
            try
            {
                int employee = EmployeeId(); string role = Role(employee, module);
                if (!CanWrite(role, module)) return new Reply { Success = false, Message = "You do not have permission to save this record." };
                if (!Modules.ContainsKey(module) || String.IsNullOrWhiteSpace(payloadJson) || payloadJson.Length > 20000) return new Reply { Success = false, Message = "Invalid request data." };
                using (var c = new SqlConnection(ConnectionString)) using (var q = new SqlCommand("dbo.usp_HK_SaveModuleData", c))
                {
                    var values = new JavaScriptSerializer().Deserialize<Dictionary<string, object>>(payloadJson);
                    var xml = new XElement("Root", values.Select(pair => new XElement(pair.Key, Convert.ToString(pair.Value, CultureInfo.InvariantCulture))));
                    q.CommandType = CommandType.StoredProcedure; q.Parameters.Add("@Module", SqlDbType.VarChar, 40).Value = module;
                    q.Parameters.Add("@Payload", SqlDbType.Xml).Value = xml.ToString(SaveOptions.DisableFormatting); q.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employee;
                    c.Open(); q.ExecuteNonQuery();
                }
                return new Reply { Success = true, Message = "Record saved." };
            }
            catch (UnauthorizedAccessException ex) { return new Reply { Success = false, Message = ex.Message }; }
            catch (Exception) { return new Reply { Success = false, Message = "Record was not saved. Check required fields and database setup." }; }
        }
        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static Reply DeactivateModule(string module, int id)
        {
            try
            {
                int employee = EmployeeId(); string role = Role(employee, module);
                if (!CanWrite(role, module)) return new Reply { Success = false, Message = "You do not have permission to update this record." };
                if (!Modules.ContainsKey(module) || id <= 0) return new Reply { Success = false, Message = "Invalid request." };
                using (var c = new SqlConnection(ConnectionString)) using (var q = new SqlCommand("dbo.usp_HK_DeactivateModuleData", c))
                { q.CommandType = CommandType.StoredProcedure; q.Parameters.Add("@Module", SqlDbType.VarChar, 40).Value = module; q.Parameters.Add("@RecordID", SqlDbType.Int).Value = id; q.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employee; c.Open(); q.ExecuteNonQuery(); }
                return new Reply { Success = true, Message = "Record deactivated." };
            }
            catch { return new Reply { Success = false, Message = "Record could not be deactivated." }; }
        }
    }
}
