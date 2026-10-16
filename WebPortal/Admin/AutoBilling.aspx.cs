using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class AutoBilling : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static string GetFilters()
        {
            EnsureAuthenticated();
            return Serialize(new { Domains = ToRows(new bllMaster().GetAllDomain()) });
        }

        [WebMethod]
        public static string GetAutoBilling(string domain, string from, string to)
        {
            EnsureAuthenticated();
            DateTime fromDate, toDate;
            if (!DateTime.TryParseExact(from, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out fromDate) ||
                !DateTime.TryParseExact(to, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out toDate) || toDate < fromDate)
                throw new ArgumentException("Invalid billing period.");

            DataSet data = ExecuteReport(domain, fromDate, toDate);
            var tables = new List<object>();
            foreach (ProjectTable item in GetProjectTables(data))
            {
                DataTable table = item.Table;
                var columns = new List<string>(); foreach (DataColumn column in table.Columns) columns.Add(column.ColumnName);
                var rows = new List<List<object>>();
                foreach (DataRow dataRow in table.Rows) { var row = new List<object>(); foreach (DataColumn column in table.Columns) row.Add(dataRow[column] == DBNull.Value ? null : dataRow[column]); rows.Add(row); }
                tables.Add(new { Project = item.Project, Columns = columns, Rows = rows });
            }
            return Serialize(tables);
        }

        private static DataSet ExecuteReport(string domain, DateTime fromDate, DateTime toDate)
        {
            var procedures = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Title", "usp_GetAutoBilledCommitmentProjects" },
                { "Valuation", "usp_GetAutoBilledValuationProjects" },
                { "Freight", "usp_GetAutoBilledFreightProjects" },
                { "FTE", "usp_Update_FTE_Procedure" },
                { "UnderwritingCredit", "usp_Update_UnderwritingCredit_Procedure" },
                { "UnderwritingServicing", "usp_Update_UnderwritingServicing_Procedure" }
            };
            string procedure;
            if (string.IsNullOrWhiteSpace(domain) || !procedures.TryGetValue(domain, out procedure))
                throw new ArgumentException("Invalid domain.");

            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, procedure);
            SQLHelper.AddParamToSQLCmd(command, "@From", SqlDbType.Date, 0, ParameterDirection.Input, fromDate.Date);
            SQLHelper.AddParamToSQLCmd(command, "@To", SqlDbType.Date, 0, ParameterDirection.Input, toDate.Date);
            DataSet data = SQLHelper.ExecuteDataSetCmd(command);
            if (data == null) throw new InvalidOperationException("Unable to retrieve auto billing data.");
            return data;
        }

        private static Dictionary<int, string> ExtractProjectMap(DataSet data)
        {
            var map = new Dictionary<int, string>();
            if (data.Tables.Count == 0) return map;
            DataTable metadata = data.Tables[data.Tables.Count - 1];
            if (!metadata.Columns.Contains("ResultSetIndex") || !metadata.Columns.Contains("Project")) return map;
            foreach (DataRow row in metadata.Rows) map[Convert.ToInt32(row["ResultSetIndex"])] = Convert.ToString(row["Project"]);
            data.Tables.Remove(metadata);
            return map;
        }

        private static List<ProjectTable> GetProjectTables(DataSet data)
        {
            Dictionary<int, string> map = ExtractProjectMap(data);
            var result = new List<ProjectTable>();
            var lookup = new Dictionary<string, ProjectTable>(StringComparer.OrdinalIgnoreCase);
            for (int i = 0; i < data.Tables.Count; i++)
            {
                DataTable table = data.Tables[i]; string mapped;
                string project = table.Rows.Count > 0 ? Convert.ToString(table.Rows[0][0]) : (map.TryGetValue(i + 1, out mapped) ? mapped : "");
                if (string.IsNullOrWhiteSpace(project)) continue;
                ProjectTable item;
                if (!lookup.TryGetValue(project, out item)) { item = new ProjectTable { Project = project, Table = table.Clone() }; lookup.Add(project, item); result.Add(item); }
                item.Table.Merge(table, true, MissingSchemaAction.Add);
            }
            return result;
        }

        private sealed class ProjectTable { public string Project { get; set; } public DataTable Table { get; set; } }

        [WebMethod]
        public static string SendAutoBilling(string domain, string from, string to, string summariesJson)
        {
            EnsureAuthenticated();
            DateTime fromDate, toDate;
            if (!DateTime.TryParseExact(from, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out fromDate) || !DateTime.TryParseExact(to, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out toDate)) throw new ArgumentException("Invalid billing period.");
            // Configure one recipient email per Domain.
            var domainEmails = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Title", "v.rohan@infinityinternationals.us;prashant.patil@infinity-data.com" },
                { "Valuation", "h.dashrath@infinityinternationals.us;s.santosh@infinityinternationals.us;prashant.patil@infinity-data.com" },
                { "Freight", "v.rohan@infinityinternationals.us;prashant.patil@infinity-data.com" },
                { "FTE", "update-fte-email@company.com" },
                { "UnderwritingCredit", "update-uw-credit-email@company.com" },
                { "UnderwritingServicing", "update-uw-servicing-email@company.com" }
            };
            // Configure optional CC recipients per Domain; separate multiple addresses with comma or semicolon.
            var domainCcEmails = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Title", "" },
                { "Valuation", "" },
                { "Freight", "" },
                { "FTE", "" },
                { "UnderwritingCredit", "" },
                { "UnderwritingServicing", "" }
            };
            string email; if (!domainEmails.TryGetValue(domain, out email)) throw new InvalidOperationException("Email is not configured for domain " + domain + ".");
            string ccEmail; domainCcEmails.TryGetValue(domain, out ccEmail);
            DataSet data = ExecuteReport(domain, fromDate, toDate);
            var summaries = new JavaScriptSerializer().Deserialize<Dictionary<string, string>>(summariesJson) ?? new Dictionary<string, string>();
            string period = fromDate.ToString("dd-MMM-yyyy") + " ~ " + toDate.ToString("dd-MMM-yyyy");
            int billingAddedBy; if (!int.TryParse(HttpContext.Current.User.Identity.Name, out billingAddedBy)) throw new InvalidOperationException("Unable to resolve Billing Added By employee.");
            int sent = 0; var failed = new List<object>();
            foreach (ProjectTable item in GetProjectTables(data))
            {
                string project = item.Project;
                DataTable table = item.Table;
                if (domain.Equals("Title", StringComparison.OrdinalIgnoreCase))
                {
                    DataRow validation = UpdateTitleProject(project, fromDate, toDate, table.Rows.Count, billingAddedBy);
                    if (validation == null || !Convert.ToBoolean(validation["Success"]))
                    {
                        failed.Add(new { Project = project, DisplayedCount = table.Rows.Count, ActualCount = validation == null ? 0 : Convert.ToInt32(validation["ActualCount"]), Reason = validation == null ? "Update validation returned no result." : Convert.ToString(validation["Reason"]) });
                        continue;
                    }
                }
                string summary;
                summaries.TryGetValue(project, out summary);
                byte[] attachment = BuildExcel(table, project);
                string body = "<style>.autobilling-summary{margin:15px 0;font-family:Bahnschrift; font-size:12px;}.autobilling-summary-title{padding:7px;background:#a9dff2;font-weight:bold;font-family:Bahnschrift; font-size:12px;}.autobilling-summary table{border-collapse:collapse; font-family:Bahnschrift; font-size:12px;}.autobilling-summary th,.autobilling-summary td{border:1px solid #333;padding:6px;text-align:center;font-family:Bahnschrift; font-size:12px;}</style><table width='100%' style='background:#f3f6f9;padding:24px;font-family:Bahnschrift; font-size:12px;color:#243447'><tr><td><table width='680' align='center' style='background:#fff;border:1px solid #dbe3ec;font-family:Bahnschrift; font-size:12px;'><tr><td style='padding:22px'><p>Dear Sir/Madam,</p><p>Please find the auto billing summary below. Detailed billing data is attached.</p>" + summary + "<p>Regards,<br/><strong>Infinity Data Technologies</strong></p></td></tr><tr><td style='background:#f7f9fb;padding:12px;font-family:Bahnschrift; font-size:10px;color:#738294'>This is a system-generated email. Please do not reply.</td></tr></table></td></tr></table>";
                using (var mail = new MailMessage()) using (var stream = new MemoryStream(attachment))
                {
                    AddRecipients(mail.To, email); AddRecipients(mail.CC, ccEmail); mail.Bcc.Add("n.nilkanth@infinity-data.com"); mail.From = new MailAddress("ack@infinity-data.com", "Auto Billing", Encoding.UTF8); mail.Subject = project + " Auto Billing - " + period; mail.Body = body; mail.IsBodyHtml = true;
                    mail.Attachments.Add(new Attachment(stream, project + "_Auto_Billing.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
                    using (var client = new SmtpClient("smtp.office365.com", 587)) { client.Credentials = new NetworkCredential("ack@infinity-data.com", new bllSendMail().GetPassword("ackdata")); client.EnableSsl = true; ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12; client.Send(mail); }
                }
                sent++;
            }
            return Serialize(new { Message = sent + " project email(s) sent successfully." + (failed.Count > 0 ? " " + failed.Count + " project(s) were not updated and no email was sent." : ""), Failed = failed });
        }

        private static DataRow UpdateTitleProject(string project, DateTime from, DateTime to, int expectedCount, int employeeId)
        {
            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UpdateAutoBilledCommitmentProject");
            SQLHelper.AddParamToSQLCmd(command, "@ProjectName", SqlDbType.NVarChar, 100, ParameterDirection.Input, project);
            SQLHelper.AddParamToSQLCmd(command, "@From", SqlDbType.Date, 0, ParameterDirection.Input, from.Date);
            SQLHelper.AddParamToSQLCmd(command, "@To", SqlDbType.Date, 0, ParameterDirection.Input, to.Date);
            SQLHelper.AddParamToSQLCmd(command, "@ExpectedCount", SqlDbType.Int, 0, ParameterDirection.Input, expectedCount);
            SQLHelper.AddParamToSQLCmd(command, "@BillingAddedBy", SqlDbType.Int, 0, ParameterDirection.Input, employeeId);
            DataTable result = SQLHelper.ExecuteDataTableCmd(command); return result == null || result.Rows.Count == 0 ? null : result.Rows[0];
        }

        private static byte[] BuildExcel(DataTable table, string project)
        {
            using (var book = new XLWorkbook()) using (var stream = new MemoryStream())
            {
                string name = project; foreach (char c in new[] { ':', '/', '\\', '?', '*', '[', ']' }) name = name.Replace(c, '_'); if (name.Length > 31) name = name.Substring(0, 31);
                var sheet = book.Worksheets.Add(table, name); sheet.Row(1).Style.Font.Bold = true; sheet.Row(1).Style.Fill.BackgroundColor = XLColor.FromHtml("#DCEAF7"); sheet.SheetView.FreezeRows(1); sheet.Columns().AdjustToContents(8, 45);
                book.SaveAs(stream); return stream.ToArray();
            }
        }

        private static void AddRecipients(MailAddressCollection recipients, string addresses)
        {
            foreach (string address in Convert.ToString(addresses).Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries))
                recipients.Add(address.Trim());
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow dataRow in table.Rows) { var row = new Dictionary<string, object>(); foreach (DataColumn column in table.Columns) row[column.ColumnName] = dataRow[column]; rows.Add(row); }
            return rows;
        }
        private static void EnsureAuthenticated() { if (HttpContext.Current.User == null || !HttpContext.Current.User.Identity.IsAuthenticated) throw new HttpException(401, "Authentication required."); }
        private static string Serialize(object value) { return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(value); }
    }
}
