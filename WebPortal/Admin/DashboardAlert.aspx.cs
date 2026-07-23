using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class DashboardAlert : System.Web.UI.Page
    {
        private static readonly string[] AllowedExtensions = { ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".png", ".jpg", ".jpeg", ".txt", ".zip" };

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetAlerts()
        {
            return Serialize(ExecuteTable("usp_GetAllDashboardAlert"));
        }

        [WebMethod]
        public static string GetAlertSubjects()
        {
            return Serialize(ExecuteTable("usp_GetDashboardAlertDetails"));
        }

        [WebMethod]
        public static string GetAlertReport(int alertId)
        {
            if (alertId <= 0) throw new ArgumentException("A valid alert is required.");
            return Serialize(ExecuteTable("usp_GetReasonWiseDashboardAlertDetails", "@AlertId", SqlDbType.Int, alertId));
        }

        [WebMethod]
        public static string GetBranches()
        {
            return Serialize(new bllMaster().GetAllBranches());
        }

        [WebMethod]
        public static string GetAudience(string displayTo, int branchId)
        {
            DataTable source;
            switch (displayTo)
            {
                case "All":
                    source = ExecuteTable("usp_GetAllBehalfUser");
                    break;
                case "PMAndAbove":
                    source = new bllMaster().GetAllProjectManager();
                    break;
                case "Senior":
                    source = ExecuteTable("usp_GetAllSeniorManagement");
                    break;
                case "Branch wise":
                    if (branchId <= 0) throw new ArgumentException("A valid branch is required.");
                    source = ExecuteTable("usp_GetBranchWiseUser", "@BranchID", SqlDbType.Int, branchId);
                    break;
                default:
                    throw new ArgumentException("A valid audience is required.");
            }

            var rows = source.AsEnumerable().Select(row => new
            {
                EmployeeID = Read(row, "EmployeeID"),
                Code = Read(row, "Code", "PMCode"),
                Name = BuildName(row)
            }).Where(row => !string.IsNullOrWhiteSpace(row.EmployeeID)).ToList();
            return JsonConvert.SerializeObject(rows);
        }

        [WebMethod]
        public static object SaveAlert(string subject, string message, string effectiveDate, string displayTo, string[] userIds, string attachmentName, string attachmentBase64)
        {
            try
            {
                subject = (subject ?? string.Empty).Trim();
                message = (message ?? string.Empty).Trim();
                string[] allowedAudiences = { "All", "Branch wise", "PMAndAbove", "Senior" };
                if (subject.Length == 0 || subject.Length > 250 || message.Length == 0 || message.Length > 4000)
                    return Result(false, "Enter a valid subject and message.");
                if (!allowedAudiences.Contains(displayTo))
                    return Result(false, "Select a valid audience.");

                DateTime date;
                if (!DateTime.TryParseExact(effectiveDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date))
                    return Result(false, "Select a valid effective date.");

                string users = string.Join(",", (userIds ?? new string[0])
                    .Where(id => { int parsed; return int.TryParse(id, out parsed) && parsed > 0; })
                    .Distinct());
                if (string.IsNullOrWhiteSpace(users))
                    return Result(false, "Select at least one recipient.");

                string attachmentPath = SaveAttachment(attachmentName, attachmentBase64);
                SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_InsertDashboardAlert");
                Add(cmd, "@Subject", SqlDbType.NVarChar, 4000, subject);
                Add(cmd, "@Message", SqlDbType.NVarChar, 4000, HttpUtility.HtmlEncode(message).Replace("\r\n", "<br />").Replace("\n", "<br />"));
                Add(cmd, "@Duration", SqlDbType.Int, 10, 0);
                Add(cmd, "@EffectiveDate", SqlDbType.NVarChar, 12, date.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture));
                Add(cmd, "@AddedBy", SqlDbType.Int, 10, int.Parse(HttpContext.Current.User.Identity.Name));
                Add(cmd, "@DisplayTo", SqlDbType.NVarChar, 100, displayTo);
                Add(cmd, "@Users", SqlDbType.NVarChar, 4000, users);
                Add(cmd, "@Attachment", SqlDbType.NVarChar, 4000, attachmentPath);
                SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
                SQLHelper.ExecuteNonQueryCmd(cmd);
                int returnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
                cmd.Dispose();
                return returnValue > 0 ? Result(true, "Dashboard alert saved successfully.") : Result(false, "The alert could not be saved.");
            }
            catch (Exception ex)
            {
                return Result(false, ex.Message);
            }
        }

        private static string SaveAttachment(string fileName, string base64)
        {
            if (string.IsNullOrWhiteSpace(fileName) || string.IsNullOrWhiteSpace(base64)) return string.Empty;
            string safeName = Path.GetFileName(fileName);
            string extension = Path.GetExtension(safeName).ToLowerInvariant();
            if (!AllowedExtensions.Contains(extension)) throw new InvalidOperationException("This attachment type is not allowed.");
            byte[] content;
            try { content = Convert.FromBase64String(base64); }
            catch (FormatException) { throw new InvalidOperationException("The attachment is invalid."); }
            if (content.Length > 5 * 1024 * 1024) throw new InvalidOperationException("Attachment must be 5 MB or smaller.");
            string folder = HttpContext.Current.Server.MapPath(@"~\EmployeeDocuments\DashboardAlert");
            Directory.CreateDirectory(folder);
            string path = Path.Combine(folder, Guid.NewGuid().ToString("N") + "_" + safeName);
            File.WriteAllBytes(path, content);
            return path;
        }

        private static DataTable ExecuteTable(string procedure, string parameter = null, SqlDbType type = SqlDbType.Int, object value = null)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, procedure);
            if (!string.IsNullOrEmpty(parameter)) Add(cmd, parameter, type, 0, value);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        private static void Add(SqlCommand cmd, string name, SqlDbType type, int size, object value)
        {
            SQLHelper.AddParamToSQLCmd(cmd, name, type, size, ParameterDirection.Input, value);
        }

        private static string Serialize(DataTable table)
        {
            return JsonConvert.SerializeObject(table ?? new DataTable(), new JsonSerializerSettings
            {
                DateFormatString = "dd-MMM-yyyy HH:mm"
            });
        }

        private static string Read(DataRow row, params string[] names)
        {
            foreach (string name in names)
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value) return Convert.ToString(row[name]).Trim();
            return string.Empty;
        }

        private static string BuildName(DataRow row)
        {
            string direct = Read(row, "EmpName", "PMName", "EmployeeName");
            if (!string.IsNullOrWhiteSpace(direct)) return direct;
            return string.Join(" ", new[] { Read(row, "FirstName"), Read(row, "MiddleName"), Read(row, "LastName") }.Where(x => !string.IsNullOrWhiteSpace(x)));
        }

        private static object Result(bool success, string message)
        {
            return new { Success = success, Message = message };
        }
    }
}
