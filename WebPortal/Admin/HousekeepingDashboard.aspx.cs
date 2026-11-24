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
using WebPortal.App_Code.BLL;

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
            {"Floors","HK_FloorMaster"},{"Staff","HK_StaffMaster"},
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
            // Housekeeping role-table validation was removed at the user's request.
            return "Admin";
        }
        private static bool CanWrite(string role, string module)
        {
            if (role == "Admin") return true;
            return role == "Supervisor" && new[] { "Floors", "Staff", "Vendors", "Activities", "Schedules", "Attendance", "DailyActivities", "WeeklyMonthlyActivities", "Inspections", "Complaints", "Inventory", "Consumables", "VendorPerformance" }.Contains(module);
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
                int employee = EmployeeId();
                DataTable branches = new bllMaster().GetAllBranches();
                answer["Branches"] = branches.AsEnumerable()
                    .Where(row => !branches.Columns.Contains("isDelete") || row.IsNull("isDelete") || !Convert.ToBoolean(row["isDelete"]))
                    .Select(row => new { ID = row["BranchID"], Name = Convert.ToString(row["BranchName"]) }).ToList();
                var floorBranches = new Dictionary<int, int>();
                try
                {
                    using (var c = new SqlConnection(ConnectionString)) using (var q = new SqlCommand("SELECT FloorID, BranchID FROM dbo.HK_FloorMaster WHERE BranchID IS NOT NULL", c))
                    {
                        c.Open(); using (var floorReader = q.ExecuteReader()) while (floorReader.Read()) floorBranches[Convert.ToInt32(floorReader["FloorID"])] = Convert.ToInt32(floorReader["BranchID"]);
                    }
                }
                catch { /* Older installations receive BranchID after the migration script is applied. */ }
                using (var c = new SqlConnection(ConnectionString)) using (var q = new SqlCommand("dbo.usp_HK_GetLookups", c))
                {
                    q.CommandType = CommandType.StoredProcedure; q.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employee; c.Open();
                    using (var r = q.ExecuteReader())
                    {
                        do
                        {
                            if (r.FieldCount < 2) continue;
                            string name = null;
                            switch (r.GetName(0))
                            {
                                case "FloorID": name = "Floors"; break;
                                case "StaffID": name = "Staff"; break;
                                case "VendorID": name = "Vendors"; break;
                                case "ActivityID": name = "Activities"; break;
                                case "AssignmentID": name = "Assignments"; break;
                                case "ConsumableID": name = "Consumables"; break;
                            }
                            if (name != null)
                            {
                                var values = new List<object>();
                                int branchOrdinal = -1;
                                for (int i = 0; i < r.FieldCount; i++)
                                    if (String.Equals(r.GetName(i), "BranchID", StringComparison.OrdinalIgnoreCase)) branchOrdinal = i;
                                while (r.Read())
                                {
                                    object branchId = branchOrdinal >= 0 && !r.IsDBNull(branchOrdinal) ? r.GetValue(branchOrdinal) : null;
                                    int mappedBranch;
                                    if (name == "Floors" && branchId == null && floorBranches.TryGetValue(Convert.ToInt32(r.GetValue(0)), out mappedBranch)) branchId = mappedBranch;
                                    values.Add(new { ID = r.GetValue(0), Name = Convert.ToString(r.GetValue(1)), BranchID = branchId });
                                }
                                answer[name] = values;
                            }
                            else while (r.Read()) { }
                        } while (r.NextResult());
                    }
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
            catch (SqlException ex)
            {
                string message;
                if (ex.Number == 50000) message = ex.Message;
                else if ((ex.Number == 2601 || ex.Number == 2627) && module == "Floors") message = "A floor with this number or name already exists in the selected location.";
                else if (ex.Number == 515 && module == "Floors") message = "The database needs the Branch/Floor migration before a floor can be saved. Run 04_BranchFloorMigration.sql, then retry.";
                else if (ex.Number == 547 && module == "Floors" && ex.Message.IndexOf("BuildingID", StringComparison.OrdinalIgnoreCase) >= 0) message = "The database still enforces the legacy BuildingID relationship. Back up the database, run 04_BranchFloorMigration.sql against InfinityERP, then retry.";
                else if (ex.Number == 207 || ex.Number == 2812) message = "Housekeeping database objects are outdated. Apply the current Housekeeping migration and procedure scripts, then retry.";
                else if (ex.Number == 547) message = "The selected location or related record is invalid. Refresh the page and try again.";
                else message = "Record was not saved. Check required fields and database setup.";
                return new Reply { Success = false, Message = message };
            }
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
