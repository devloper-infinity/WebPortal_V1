using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Configuration;
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
using WebPortal.FTE;
using InfinityERP.UnderwritingBilling;

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
        public static string GetAutoBilling(string domain, string billingCycle, string from, string to)
        {
            EnsureAuthenticated();
            DateTime fromDate, toDate;
            if (!DateTime.TryParseExact(from, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out fromDate) ||
                !DateTime.TryParseExact(to, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out toDate) || toDate < fromDate)
                throw new ArgumentException("Invalid billing period.");

            DataSet data = ExecuteReport(domain, billingCycle, fromDate, toDate);
            var tables = new List<object>();
            foreach (ProjectTable item in GetProjectTables(data))
            {
                DataTable table = item.Table;
                var columns = new List<string>(); foreach (DataColumn column in table.Columns) columns.Add(column.ColumnName);
                var rows = new List<List<object>>();
                foreach (DataRow dataRow in table.Rows) { var row = new List<object>(); foreach (DataColumn column in table.Columns) row.Add(dataRow[column] == DBNull.Value ? null : dataRow[column]); rows.Add(row); }
                tables.Add(new { Project = item.Project, Columns = columns, Rows = rows, Summary = item.Summary });
            }
            return Serialize(tables);
        }

        private static DataSet ExecuteReport(string domain, string billingCycle, DateTime fromDate, DateTime toDate)
        {
            if (domain.StartsWith("Underwriting", StringComparison.OrdinalIgnoreCase))
                return ExecuteUnderwritingReport(domain, billingCycle, fromDate, toDate);
            if (string.Equals(domain, "FTE", StringComparison.OrdinalIgnoreCase))
                return ExecuteFteReport(billingCycle, fromDate, toDate);

            var procedures = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Title", "usp_GetAutoBilledCommitmentProjects" },
                { "Valuation", "usp_GetAutoBilledValuationProjects" },
                { "Freight", "usp_GetAutoBilledFreightProjects" }
            };
            string procedure;
            if (string.IsNullOrWhiteSpace(domain) || !procedures.TryGetValue(domain, out procedure))
                throw new ArgumentException("Invalid domain.");

            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, procedure);
            SQLHelper.AddParamToSQLCmd(command, "@From", SqlDbType.Date, 0, ParameterDirection.Input, fromDate.Date);
            SQLHelper.AddParamToSQLCmd(command, "@To", SqlDbType.Date, 0, ParameterDirection.Input, toDate.Date);
            if (!domain.StartsWith("Underwriting", StringComparison.OrdinalIgnoreCase))
            {
                if (billingCycle != "Monthly" && billingCycle != "Bi-Monthly" && billingCycle != "Dealwise") throw new ArgumentException("Invalid billing cycle.");
                SQLHelper.AddParamToSQLCmd(command, "@BillingCycle", SqlDbType.NVarChar, 25, ParameterDirection.Input, billingCycle);
            }
            DataSet data = SQLHelper.ExecuteDataSetCmd(command);
            if (data == null) throw new InvalidOperationException("Unable to retrieve auto billing data.");
            if (domain.Equals("Valuation", StringComparison.OrdinalIgnoreCase)) ExcludeCancelled6006(data);
            return data;
        }

        private static void ExcludeCancelled6006(DataSet data)
        {
            foreach (DataTable table in data.Tables)
            {
                if (table.Rows.Count == 0 || table.Columns.Count == 0 ||
                    !string.Equals(Convert.ToString(table.Rows[0][0]).Trim(), "6006", StringComparison.OrdinalIgnoreCase)) continue;

                DataColumn statusColumn = null;
                foreach (DataColumn column in table.Columns)
                    if (column.ColumnName.Replace(" ", "").Equals("FinalStatus", StringComparison.OrdinalIgnoreCase)) { statusColumn = column; break; }
                if (statusColumn == null) continue;

                for (int index = table.Rows.Count - 1; index >= 0; index--)
                {
                    string status = Convert.ToString(table.Rows[index][statusColumn]).Trim();
                    if (status.Equals("Cancelled", StringComparison.OrdinalIgnoreCase) || status.Equals("Canceled", StringComparison.OrdinalIgnoreCase))
                        table.Rows.RemoveAt(index);
                }
            }
        }

        private static DataSet ExecuteUnderwritingReport(string domain, string billingCycle, DateTime fromDate, DateTime toDate)
        {
            if (!string.Equals(billingCycle, "Monthly", StringComparison.OrdinalIgnoreCase))
                throw new ArgumentException("Underwriting billing is available only for the Monthly billing option.");

            int employeeId;
            if (domain.Equals("UnderwritingCredit", StringComparison.OrdinalIgnoreCase)) employeeId = 6823;
            else if (domain.Equals("UnderwritingServicing", StringComparison.OrdinalIgnoreCase)) employeeId = 277;
            else throw new ArgumentException("Invalid Underwriting domain.");
            var service = new UnderwritingBillingValidationService(ConfigurationManager.ConnectionStrings["MainCon"].ConnectionString);
            BillingValidationResult report = service.GetPendingBillingData(employeeId, fromDate, toDate);
            DataSet data = new DataSet();
            DataTable metadata = new DataTable("ProjectMap");
            metadata.Columns.Add("ResultSetIndex", typeof(int));
            metadata.Columns.Add("Project", typeof(string));
            metadata.Columns.Add("SummaryJson", typeof(string));

            foreach (BillingProject project in report.Projects)
            {
                DataTable table = new DataTable(project.ProjectName);
                table.Columns.Add("Project #", typeof(object));
                foreach (string column in project.Columns)
                    if (!table.Columns.Contains(column)) table.Columns.Add(column, typeof(object));

                foreach (List<string> sourceRow in project.Rows)
                {
                    DataRow row = table.NewRow();
                    row["Project #"] = project.ProjectName;
                    for (int i = 0; i < project.Columns.Count && i < sourceRow.Count; i++)
                        if (!project.Columns[i].Equals("Project #", StringComparison.OrdinalIgnoreCase)) row[project.Columns[i]] = sourceRow[i] ?? "";
                    table.Rows.Add(row);
                }

                data.Tables.Add(table);
                metadata.Rows.Add(data.Tables.Count, project.ProjectName, Serialize(project.Summary));
            }
            data.Tables.Add(metadata);
            return data;
        }

        private static DataSet ExecuteFteReport(string billingCycle, DateTime fromDate, DateTime toDate)
        {
            if (billingCycle != "Monthly" && billingCycle != "Bi-Monthly" && billingCycle != "Dealwise")
                throw new ArgumentException("Invalid billing cycle.");

            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAutoBilledFTEProjects");
            SQLHelper.AddParamToSQLCmd(command, "@BillingCycle", SqlDbType.NVarChar, 25, ParameterDirection.Input, billingCycle);
            DataTable projects = SQLHelper.ExecuteDataTableCmd(command);
            if (projects == null) throw new InvalidOperationException("Unable to retrieve FTE projects.");

            string period = fromDate.ToString("dd-MMM-yyyy") + " ~ " + toDate.ToString("dd-MMM-yyyy");
            DataSet data = new DataSet();
            DataTable metadata = new DataTable("ProjectMap");
            metadata.Columns.Add("ResultSetIndex", typeof(int));
            metadata.Columns.Add("Project", typeof(string));
            metadata.Columns.Add("SummaryJson", typeof(string));

            foreach (DataRow projectRow in projects.Rows)
            {
                int projectId = Convert.ToInt32(projectRow["ProjectID"]);
                string projectName = Convert.ToString(projectRow["ProjectName"]);
                FTEBilling.BillingReportResult report = FTEBilling.BuildBillingReport(projectId, period);
                DataTable table = new DataTable(projectName);
                table.Columns.Add("Project #", typeof(object));
                foreach (string column in report.Columns)
                    if (!table.Columns.Contains(column)) table.Columns.Add(column, typeof(object));

                foreach (Dictionary<string, object> sourceRow in report.Rows)
                {
                    DataRow row = table.NewRow();
                    row["Project #"] = projectName;
                    foreach (KeyValuePair<string, object> value in sourceRow)
                        if (table.Columns.Contains(value.Key)) row[value.Key] = value.Value ?? DBNull.Value;
                    table.Rows.Add(row);
                }

                data.Tables.Add(table);
                metadata.Rows.Add(data.Tables.Count, projectName, Serialize(report.Summary));
            }
            data.Tables.Add(metadata);
            return data;
        }

        private static Dictionary<int, ProjectMetadata> ExtractProjectMap(DataSet data)
        {
            var map = new Dictionary<int, ProjectMetadata>();
            if (data.Tables.Count == 0) return map;
            DataTable metadata = data.Tables[data.Tables.Count - 1];
            if (!metadata.Columns.Contains("ResultSetIndex") || !metadata.Columns.Contains("Project")) return map;
            foreach (DataRow row in metadata.Rows)
            {
                var item = new ProjectMetadata { Project = Convert.ToString(row["Project"]) };
                if (metadata.Columns.Contains("SummaryJson") && row["SummaryJson"] != DBNull.Value)
                    item.Summary = new JavaScriptSerializer().Deserialize<Dictionary<string, object>>(Convert.ToString(row["SummaryJson"]));
                map[Convert.ToInt32(row["ResultSetIndex"])] = item;
            }
            data.Tables.Remove(metadata);
            return map;
        }

        private static List<ProjectTable> GetProjectTables(DataSet data)
        {
            Dictionary<int, ProjectMetadata> map = ExtractProjectMap(data);
            var result = new List<ProjectTable>();
            var lookup = new Dictionary<string, ProjectTable>(StringComparer.OrdinalIgnoreCase);
            for (int i = 0; i < data.Tables.Count; i++)
            {
                DataTable table = data.Tables[i]; ProjectMetadata mapped;
                map.TryGetValue(i + 1, out mapped);
                string project = table.Rows.Count > 0 ? Convert.ToString(table.Rows[0][0]) : (mapped == null ? "" : mapped.Project);
                if (string.IsNullOrWhiteSpace(project)) continue;
                ProjectTable item;
                if (!lookup.TryGetValue(project, out item)) { item = new ProjectTable { Project = project, Table = table.Clone(), Summary = mapped == null ? null : mapped.Summary }; lookup.Add(project, item); result.Add(item); }
                item.Table.Merge(table, true, MissingSchemaAction.Add);
            }
            return result;
        }

        private sealed class ProjectMetadata { public string Project { get; set; } public Dictionary<string, object> Summary { get; set; } }
        private sealed class ProjectTable { public string Project { get; set; } public DataTable Table { get; set; } public Dictionary<string, object> Summary { get; set; } }

        [WebMethod]
        public static string ExportAutoBilling(string domain, string billingCycle, string from, string to, string project)
        {
            EnsureAuthenticated();
            DateTime fromDate, toDate;
            if (!DateTime.TryParseExact(from, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out fromDate) ||
                !DateTime.TryParseExact(to, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out toDate) || toDate < fromDate)
                throw new ArgumentException("Invalid billing period.");

            ProjectTable selected = GetProjectTables(ExecuteReport(domain, billingCycle, fromDate, toDate))
                .Find(item => string.Equals(item.Project, project, StringComparison.OrdinalIgnoreCase));
            if (selected == null) throw new InvalidOperationException("Project billing data was not found.");

            string safeProject = project;
            foreach (char c in Path.GetInvalidFileNameChars()) safeProject = safeProject.Replace(c, '_');
            return Serialize(new
            {
                FileName = safeProject + "-Billing Details-" + fromDate.ToString("dd-MMM-yyyy") + "-" + toDate.ToString("dd-MMM-yyyy") + ".xlsx",
                Content = Convert.ToBase64String(BuildExcel(selected.Table, project))
            });
        }

        [WebMethod]
        public static string SendAutoBilling(string domain, string billingCycle, string from, string to, string summariesJson)
        {
            EnsureAuthenticated();
            DateTime fromDate, toDate;
            if (!DateTime.TryParseExact(from, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out fromDate) || !DateTime.TryParseExact(to, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out toDate)) throw new ArgumentException("Invalid billing period.");
            // Configure one recipient email per Domain.
            var domainEmails = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Title", "anita@infinity-data.com" },
                { "Valuation", "anita@infinity-data.com" },
                { "Freight", "anita@infinity-data.com" },
                { "FTE", "anita@infinity-data.com" },
                { "UnderwritingCredit", "anita@infinity-data.com" },
                { "UnderwritingServicing", "anita@infinity-data.com" }
            };
            // Configure optional CC recipients per Domain; separate multiple addresses with comma or semicolon.
            var domainCcEmails = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Title", "v.rohan@infinityinternationals.us;prashant.patil@infinity-data.com" },
                { "Valuation", "h.dashrath@infinityinternationals.us;s.santosh@infinityinternationals.us;prashant.patil@infinity-data.com" },
                { "Freight", "v.rohan@infinityinternationals.us;prashant.patil@infinity-data.com" },
                { "FTE", "" },
                { "UnderwritingCredit", "Austin.Keith@infinity-data.com;s.chandrakant@infinity-data.com" },
                { "UnderwritingServicing", "t.philemon@infinity-data.com;s.chandrakant@infinity-data.com" }
            };
            string email; if (!domainEmails.TryGetValue(domain, out email)) throw new InvalidOperationException("Email is not configured for domain " + domain + ".");
            string ccEmail;
            domainCcEmails.TryGetValue(domain, out ccEmail);
            DataSet data = ExecuteReport(domain, billingCycle, fromDate, toDate);
            var summaries = new JavaScriptSerializer().Deserialize<Dictionary<string, string>>(summariesJson) ?? new Dictionary<string, string>();
            string period = fromDate.ToString("dd-MMM-yyyy") + " ~ " + toDate.ToString("dd-MMM-yyyy");
            int billingAddedBy; if (!int.TryParse(HttpContext.Current.User.Identity.Name, out billingAddedBy)) throw new InvalidOperationException("Unable to resolve Billing Added By employee.");
            int sent = 0; var failed = new List<object>();
            foreach (ProjectTable item in GetProjectTables(data))
            {
                string project = item.Project;
                DataTable table = item.Table;
                bool validateUpdate = (domain.Equals("Title", StringComparison.OrdinalIgnoreCase) && project != "364-005") || domain.Equals("Valuation", StringComparison.OrdinalIgnoreCase) || domain.Equals("Freight", StringComparison.OrdinalIgnoreCase) || domain.StartsWith("Underwriting", StringComparison.OrdinalIgnoreCase);
                if (validateUpdate)
                {
                    DataRow validation = UpdateBillingProject(domain, project, fromDate, toDate, table.Rows.Count, billingAddedBy);
                    if (validation == null || !Convert.ToBoolean(validation["Success"]))
                    {
                        failed.Add(new { Project = project, DisplayedCount = table.Rows.Count, ActualCount = validation == null ? 0 : Convert.ToInt32(validation["ActualCount"]), Reason = validation == null ? "Update validation returned no result." : Convert.ToString(validation["Reason"]) });
                        continue;
                    }
                }
                string summary;
                summaries.TryGetValue(project, out summary);
                byte[] attachment = BuildExcel(table, project);
                string body = BuildAutoBillingEmailBody(domain, project, fromDate, summary);
                using (var mail = new MailMessage()) using (var stream = new MemoryStream(attachment))
                {
                    AddRecipients(mail.To, email);
                    AddRecipients(mail.CC, ccEmail);
                    mail.Bcc.Add("n.nilkanth@infinity-data.com");
                    bool isFreight733 = domain.Equals("Freight", StringComparison.OrdinalIgnoreCase) && project == "733-002";
                    mail.From = new MailAddress("ack@infinity-data.com", "Auto Billing", Encoding.UTF8); mail.Subject = isFreight733 ? project + "-Client Billing - " + period + " ( Freight )" : project + " Auto Billing - " + period; mail.Body = body; mail.IsBodyHtml = true;
                    string attachmentName = isFreight733 ? project + "_Freight_Billing_" + fromDate.ToString("dd-MMM-yyyy") + "_to_" + toDate.ToString("dd-MMM-yyyy") + ".xlsx" : project + "-Billing Details-" + period.Replace("~", "-") + ".xlsx";
                    mail.Attachments.Add(new Attachment(stream, attachmentName, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
                    using (var client = new SmtpClient("smtp.office365.com", 587)) { client.Credentials = new NetworkCredential("ack@infinity-data.com", new bllSendMail().GetPassword("ackdata")); client.EnableSsl = true; ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12; client.Send(mail); }
                }
                sent++;
            }
            return Serialize(new { Message = sent + " project email(s) sent successfully." + (failed.Count > 0 ? " " + failed.Count + " project(s) were not updated and no email was sent." : ""), Failed = failed });
        }

        private static DataRow UpdateBillingProject(string domain, string project, DateTime from, DateTime to, int expectedCount, int employeeId)
        {
            if (domain.StartsWith("Underwriting", StringComparison.OrdinalIgnoreCase))
                return UpdateUnderwritingBillingProject(domain, project, from, to, expectedCount, employeeId);

            var procedures = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase) { { "Title", "usp_UpdateAutoBilledCommitmentProject" }, { "Valuation", "usp_UpdateAutoBilledValuationProject" }, { "Freight", "usp_UpdateAutoBilledFreightProject" } };
            string procedure; if (!procedures.TryGetValue(domain, out procedure)) throw new InvalidOperationException("Billing update procedure is not configured for " + domain + ".");
            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, procedure);
            SQLHelper.AddParamToSQLCmd(command, "@ProjectName", SqlDbType.NVarChar, 100, ParameterDirection.Input, project);
            SQLHelper.AddParamToSQLCmd(command, "@From", SqlDbType.Date, 0, ParameterDirection.Input, from.Date);
            SQLHelper.AddParamToSQLCmd(command, "@To", SqlDbType.Date, 0, ParameterDirection.Input, to.Date);
            SQLHelper.AddParamToSQLCmd(command, "@ExpectedCount", SqlDbType.Int, 0, ParameterDirection.Input, expectedCount);
            SQLHelper.AddParamToSQLCmd(command, "@BillingAddedBy", SqlDbType.Int, 0, ParameterDirection.Input, employeeId);
            DataTable result = SQLHelper.ExecuteDataTableCmd(command); return result == null || result.Rows.Count == 0 ? null : result.Rows[0];
        }

        private static DataRow UpdateUnderwritingBillingProject(string domain, string project, DateTime from, DateTime to, int expectedCount, int billingAddedBy)
        {
            int underwritingEmployeeId = domain.Equals("UnderwritingCredit", StringComparison.OrdinalIgnoreCase) ? 6823 : 277;
            SqlCommand projectCommand = SQLHelper.GetCommand(CommandType.Text, "SELECT TOP 1 ProjectID FROM dbo.Project WHERE LTRIM(RTRIM(ProjectName))=LTRIM(RTRIM(@ProjectName)) AND SubdomainID=@SubdomainID");
            SQLHelper.AddParamToSQLCmd(projectCommand, "@ProjectName", SqlDbType.NVarChar, 100, ParameterDirection.Input, project);
            SQLHelper.AddParamToSQLCmd(projectCommand, "@SubdomainID", SqlDbType.Int, 0, ParameterDirection.Input, underwritingEmployeeId == 6823 ? 15 : 19);
            DataTable projectResult = SQLHelper.ExecuteDataTableCmd(projectCommand);
            if (projectResult == null || projectResult.Rows.Count == 0)
                return BillingUpdateResult(project, expectedCount, 0, 0, false, "Underwriting project configuration not found.");

            int projectId = Convert.ToInt32(projectResult.Rows[0]["ProjectID"]);
            DataTable validation = ExecuteUnderwritingBillingUpdate(underwritingEmployeeId, projectId, from, to, billingAddedBy, false);
            int actualCount = validation == null || validation.Rows.Count == 0 ? 0 : Convert.ToInt32(validation.Rows[0]["EligibleRecords"]);
            if (actualCount != expectedCount)
                return BillingUpdateResult(project, expectedCount, actualCount, 0, false, "Displayed and update counts do not match.");

            DataTable updated = ExecuteUnderwritingBillingUpdate(underwritingEmployeeId, projectId, from, to, billingAddedBy, true);
            int updatedCount = updated == null || updated.Rows.Count == 0 ? 0 : Convert.ToInt32(updated.Rows[0]["EligibleRecords"]);
            return BillingUpdateResult(project, expectedCount, actualCount, updatedCount, updatedCount == expectedCount, updatedCount == expectedCount ? "" : "Updated count does not match displayed count.");
        }

        private static DataTable ExecuteUnderwritingBillingUpdate(int underwritingEmployeeId, int projectId, DateTime from, DateTime to, int billingAddedBy, bool applyChanges)
        {
            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UpdateUnderwritingClientBilling");
            SQLHelper.AddParamToSQLCmd(command, "@EmployeeID", SqlDbType.Int, 0, ParameterDirection.Input, underwritingEmployeeId);
            SQLHelper.AddParamToSQLCmd(command, "@ProjectID", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
            SQLHelper.AddParamToSQLCmd(command, "@BillingMonth", SqlDbType.Date, 0, ParameterDirection.Input, from.Date);
            SQLHelper.AddParamToSQLCmd(command, "@PeriodTo", SqlDbType.Date, 0, ParameterDirection.Input, to.Date);
            SQLHelper.AddParamToSQLCmd(command, "@BillingAddedBy", SqlDbType.Int, 0, ParameterDirection.Input, billingAddedBy);
            SQLHelper.AddParamToSQLCmd(command, "@ApplyChanges", SqlDbType.Bit, 0, ParameterDirection.Input, applyChanges);
            return SQLHelper.ExecuteDataTableCmd(command);
        }

        private static DataRow BillingUpdateResult(string project, int expectedCount, int actualCount, int updatedCount, bool success, string reason)
        {
            DataTable result = new DataTable();
            result.Columns.Add("Success", typeof(bool)); result.Columns.Add("ProjectName", typeof(string)); result.Columns.Add("ExpectedCount", typeof(int));
            result.Columns.Add("ActualCount", typeof(int)); result.Columns.Add("UpdatedCount", typeof(int)); result.Columns.Add("Reason", typeof(string));
            result.Rows.Add(success, project, expectedCount, actualCount, updatedCount, reason);
            return result.Rows[0];
        }

        private static string BuildAutoBillingEmailBody(string domain, string project, DateTime fromDate, string summary)
        {
            string content;
            if (domain.Equals("FTE", StringComparison.OrdinalIgnoreCase))
            {
                bool hasSummary = project == "6007-002" || project == "757-004" || project == "757-005";
                content = hasSummary
                    ? "<p>Dear Sir/Madam,</p><p>Please find the monthly FTE billing details below.</p>" + Convert.ToString(summary) + "<p>Detailed billing data is attached for your review.</p><p>Regards,<br/>Infinity Data Technologies</p>"
                    : "<p>Dear Sir/Madam,</p><p>Please find attached <strong>" + HttpUtility.HtmlEncode(project) + "</strong> billing for the month of <strong>" + fromDate.ToString("MMMM-yyyy") + "</strong>.</p><p>Regards,<br/><strong>Infinity Data Technologies</strong></p>";
            }
            else if (domain.Equals("Freight", StringComparison.OrdinalIgnoreCase) && project == "733-002")
            {
                content = "<p>Dear Client,</p><p>Please find the Freight billing summary below.</p>" + Convert.ToString(summary) + "<p>Detailed billing data is attached for your review.</p><p>Regards,<br/><strong>Infinity Data Technologies</strong></p>";
            }
            else
            {
                content = "<p>Dear Sir/Madam,</p><p>Please find the auto billing summary below. Detailed billing data is attached.</p>" + Convert.ToString(summary) + "<p>Regards,<br/><strong>Infinity Data Technologies</strong></p>";
            }

            return "<style>.autobilling-summary{margin:15px 0;font-family:Bahnschrift;font-size:12px}.autobilling-summary table{border-collapse:collapse}.autobilling-summary th,.autobilling-summary td{border:1px solid #333;padding:7px;text-align:center}.freight-733-summary .autobilling-summary-title{padding:7px;background:#a9dff2;font-weight:bold}.freight-733-summary th{background:#a9dff2}.fte-item-summary thead th{background:#143f66;color:#fff}.fte-item-summary tbody th{background:#f7f9fc;text-align:left}.fte-item-summary tbody td{text-align:left}.fte-invoice-summary thead th{background:#d9d9d9;color:#111}</style><table width='100%' style='background:#f3f6f9;padding:24px;font-family:Bahnschrift;font-size:12px;color:#243447'><tr><td><table width='680' align='center' style='background:#fff;border:1px solid #dbe3ec'><tr><td style='padding:22px'>" + content + "</td></tr><tr><td style='background:#f7f9fb;padding:12px;font-size:10px;color:#738294'>This is a system-generated email. Please do not reply.</td></tr></table></td></tr></table>";
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
