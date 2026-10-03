using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using WebPortal.FTE;

namespace WebPortal.App_Code
{
    public sealed class FteClientAutoBillingResult
    {
        public int ProjectID { get; set; }
        public string ProjectName { get; set; }
        public bool Success { get; set; }
        public string Message { get; set; }
        public string AttachmentFileName { get; set; }
    }

    public sealed class FteClientAutoBillingBatchResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int TotalProjects { get; set; }
        public int SentProjects { get; set; }
        public int FailedProjects { get; set; }
        public List<FteClientAutoBillingResult> Projects { get; set; }
    }

    public static class FteClientAutoBillingService
    {
        public static FteClientAutoBillingBatchResult SendAllMonthlyBilling(int month, int year, int requestedBy)
        {
            List<FteClientAutoBillingResult> results = new List<FteClientAutoBillingResult>();
            foreach (ProjectInfo project in GetConfiguredFteProjects())
            {
                FteClientAutoBillingResult result = SendMonthlyBilling(month, year, project.ProjectId, requestedBy);
                result.ProjectID = project.ProjectId;
                result.ProjectName = project.ProjectNumber;
                results.Add(result);
            }

            int sent = results.Count(item => item.Success);
            int failed = results.Count - sent;
            return new FteClientAutoBillingBatchResult
            {
                Success = results.Count > 0 && failed == 0,
                Message = results.Count == 0
                    ? "No active FTE projects with client billing email configuration were found."
                    : string.Format(CultureInfo.InvariantCulture, "Processed {0} project(s): {1} sent, {2} failed/skipped.", results.Count, sent, failed),
                TotalProjects = results.Count,
                SentProjects = sent,
                FailedProjects = failed,
                Projects = results
            };
        }

        public static FteClientAutoBillingResult SendMonthlyBilling(int month, int year, int projectId, int requestedBy)
        {
            if (projectId <= 0 || month < 1 || month > 12 || year < 2000)
                return Fail("Invalid Project, Month or Year.");

            DateTime fromDate = new DateTime(year, month, 1);
            DateTime toDate = fromDate.AddMonths(1).AddDays(-1);
            string period = fromDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) + " ~ " + toDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
            string monthText = fromDate.ToString("MMMM-yyyy", CultureInfo.InvariantCulture);
            string shortMonth = fromDate.ToString("MMM-yyyy", CultureInfo.InvariantCulture);
            int logId = 0;

            try
            {
                ProjectInfo project = GetProject(projectId);
                RecipientInfo recipients = GetRecipients(projectId);
                bool testMode = GetBooleanSetting("FTEClientBillingTestMode");
                string testEmail = Convert.ToString(ConfigurationManager.AppSettings["FTEClientBillingTestEmail"]).Trim();
                ValidateRecipients(recipients, testMode, testEmail);

                PrepareProjectBilling(projectId, period);
                logId = StartLog(projectId, period, fromDate, toDate, recipients, testMode, testEmail, requestedBy);
                if (logId <= 0)
                    return Fail("Monthly client billing was already sent for this Project and Billing Month.");

                FTEBilling.BillingReportResult report = FTEBilling.BuildBillingReport(projectId, period);
                DataTable billingData = ToDataTable(report);
                string fileName = CleanFileName(project.ProjectNumber) + "_FTE_Billing_" + shortMonth + ".xlsx";
                byte[] workbook = GenerateExcel(project, monthText, report, billingData);
                string subject = project.ProjectNumber + " FTE - Monthly Billing - " + monthText;
                if (testMode) subject = "[TEST] " + subject;
                string body = BuildEmailBody(project, monthText, report);

                SendEmail(recipients, testMode, testEmail, subject, body, fileName, workbook);
                CompleteLog(logId, "Sent", null, fileName);
                return new FteClientAutoBillingResult { Success = true, Message = "FTE client billing email sent successfully.", AttachmentFileName = fileName };
            }
            catch (Exception ex)
            {
                if (logId > 0) { try { CompleteLog(logId, "Failed", ex.ToString(), null); } catch { } }
                return Fail(ex.Message);
            }
        }

        private static ProjectInfo GetProject(int projectId)
        {
            using (SqlConnection connection = OpenConnection())
            using (SqlCommand command = new SqlCommand("SELECT ProjectID, LTRIM(RTRIM(ProjectName)) ProjectName FROM dbo.Project WHERE ProjectID=@ProjectID AND ISNULL(IsDelete,0)=0", connection))
            {
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read()) throw new InvalidOperationException("Active FTE project was not found.");
                    string name = Convert.ToString(reader["ProjectName"]).Trim();
                    reader.Close();
                    using (SqlCommand fteCommand = new SqlCommand("SELECT COUNT(1) FROM dbo.FTEUSerConfiguration WHERE ProjectID=@ProjectID", connection))
                    {
                        fteCommand.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                        if (Convert.ToInt32(fteCommand.ExecuteScalar()) == 0) throw new InvalidOperationException("Selected project is not configured as an FTE project.");
                    }
                    return new ProjectInfo { ProjectId = projectId, ProjectNumber = name, ProjectName = name, Domain = "FTE" };
                }
            }
        }

        private static List<ProjectInfo> GetConfiguredFteProjects()
        {
            List<ProjectInfo> projects = new List<ProjectInfo>();
            const string sql = @"SELECT DISTINCT P.ProjectID,LTRIM(RTRIM(P.ProjectName)) ProjectName
FROM dbo.Project P
INNER JOIN dbo.ClientBillingEmailMaster E ON E.ProjectID=P.ProjectID
WHERE ISNULL(P.IsDelete,0)=0
  AND ISNULL(P.Status,1)=1
  AND NULLIF(LTRIM(RTRIM(E.TOID)),'') IS NOT NULL
  AND EXISTS(SELECT 1 FROM dbo.FTEUSerConfiguration F WHERE F.ProjectID=P.ProjectID)
ORDER BY ProjectName";

            using (SqlConnection connection = OpenConnection())
            using (SqlCommand command = new SqlCommand(sql, connection))
            using (SqlDataReader reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    string name = Convert.ToString(reader["ProjectName"]).Trim();
                    projects.Add(new ProjectInfo { ProjectId = Convert.ToInt32(reader["ProjectID"]), ProjectNumber = name, ProjectName = name, Domain = "FTE" });
                }
            }
            return projects;
        }

        private static RecipientInfo GetRecipients(int projectId)
        {
            using (SqlConnection connection = OpenConnection())
            using (SqlCommand command = new SqlCommand("SELECT TOP 1 TOID,CCID,BCCID FROM dbo.ClientBillingEmailMaster WHERE ProjectID=@ProjectID", connection))
            {
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read()) throw new InvalidOperationException("Client billing email configuration is not available for this project.");
                    return new RecipientInfo { To = Convert.ToString(reader["TOID"]), Cc = Convert.ToString(reader["CCID"]), Bcc = Convert.ToString(reader["BCCID"]) };
                }
            }
        }

        private static void PrepareProjectBilling(int projectId, string period)
        {
            ExecuteNonQuery("dbo.usp_PrepareFTEClientMonthlyBilling", delegate(SqlCommand command)
            {
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                command.Parameters.Add("@BillingPeriod", SqlDbType.NVarChar, 1000).Value = period;
            });
        }

        private static int StartLog(int projectId, string period, DateTime from, DateTime to, RecipientInfo recipients, bool testMode, string testEmail, int requestedBy)
        {
            using (SqlConnection connection = OpenConnection())
            using (SqlCommand command = new SqlCommand("dbo.usp_StartFTEClientBillingEmail", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                command.Parameters.Add("@BillingPeriod", SqlDbType.NVarChar, 1000).Value = period;
                command.Parameters.Add("@PeriodFrom", SqlDbType.Date).Value = from;
                command.Parameters.Add("@PeriodTo", SqlDbType.Date).Value = to;
                command.Parameters.Add("@ActualTo", SqlDbType.NVarChar, -1).Value = recipients.To;
                command.Parameters.Add("@ActualCc", SqlDbType.NVarChar, -1).Value = DbValue(recipients.Cc);
                command.Parameters.Add("@ActualBcc", SqlDbType.NVarChar, -1).Value = DbValue(recipients.Bcc);
                command.Parameters.Add("@SentTo", SqlDbType.NVarChar, -1).Value = testMode ? testEmail : recipients.To;
                command.Parameters.Add("@IsTestEmail", SqlDbType.Bit).Value = testMode;
                command.Parameters.Add("@AddedBy", SqlDbType.Int).Value = requestedBy;
                object value = command.ExecuteScalar();
                return value == null || value == DBNull.Value ? 0 : Convert.ToInt32(value);
            }
        }

        private static void CompleteLog(int logId, string status, string error, string fileName)
        {
            ExecuteNonQuery("dbo.usp_CompleteFTEClientBillingEmail", delegate(SqlCommand command)
            {
                command.Parameters.Add("@LogID", SqlDbType.BigInt).Value = logId;
                command.Parameters.Add("@Status", SqlDbType.NVarChar, 30).Value = status;
                command.Parameters.Add("@ErrorMessage", SqlDbType.NVarChar, -1).Value = DbValue(error);
                command.Parameters.Add("@AttachmentFileName", SqlDbType.NVarChar, 500).Value = DbValue(fileName);
            });
        }

        private static DataTable ToDataTable(FTEBilling.BillingReportResult report)
        {
            DataTable table = new DataTable("Billing Details");
            foreach (string column in report.Columns) table.Columns.Add(column);
            foreach (Dictionary<string, object> source in report.Rows)
            {
                DataRow row = table.NewRow();
                foreach (DataColumn column in table.Columns)
                    row[column] = source.ContainsKey(column.ColumnName) ? (source[column.ColumnName] ?? DBNull.Value) : DBNull.Value;
                table.Rows.Add(row);
            }
            return table;
        }

        private static byte[] GenerateExcel(ProjectInfo project, string monthText, FTEBilling.BillingReportResult report, DataTable data)
        {
            using (XLWorkbook workbook = new XLWorkbook())
            using (MemoryStream stream = new MemoryStream())
            {
                IXLWorksheet sheet = workbook.Worksheets.Add("Billing Details");
                sheet.Cell(1, 1).Value = project.ProjectNumber + " FTE Monthly Billing - " + monthText;
                int width = Math.Max(2, data.Columns.Count);
                sheet.Range(1, 1, 1, width).Merge();
                sheet.Range(1, 1, 1, width).Style.Font.Bold = true;
                sheet.Range(1, 1, 1, width).Style.Font.FontSize = 14;
                sheet.Range(1, 1, 1, width).Style.Font.FontName = "Bahnschrift";
                sheet.Range(1, 1, 1, width).Style.Fill.SetBackgroundColor(XLColor.FromHtml("#103B62"));
                sheet.Range(1, 1, 1, width).Style.Font.SetFontColor(XLColor.White);
                int row = 3;
                foreach (FTEBilling.FteBillingSummaryItem item in report.SummaryItems)
                {
                    sheet.Cell(row, 1).Value = item.Label;
                    sheet.Cell(row, 2).Value = item.Value;
                    row++;
                }
                row++;
                if (data.Columns.Count > 0)
                {
                    sheet.Cell(row, 1).InsertTable(data, "FTEBillingData", true);
                    sheet.Range(row, 1, row, data.Columns.Count).Style.Fill.SetBackgroundColor(XLColor.FromHtml("#DCEAF7"));
                    sheet.Range(row, 1, row, data.Columns.Count).Style.Font.SetBold();
                    sheet.SheetView.FreezeRows(row);
                }
                sheet.Style.Font.FontName = "Bahnschrift";
                sheet.Style.Font.FontSize = 10;
                sheet.Columns().AdjustToContents(8, 45);
                workbook.SaveAs(stream);
                return stream.ToArray();
            }
        }

        private static string BuildEmailBody(ProjectInfo project, string monthText, FTEBilling.BillingReportResult report)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<table role='presentation' width='100%' cellspacing='0' cellpadding='0' style='background:#f3f6f9;padding:24px 0;font-family:Bahnschrift,Arial,sans-serif;color:#243447'><tr><td align='center'><table role='presentation' width='680' cellspacing='0' cellpadding='0' style='width:100%;max-width:680px;background:#fff;border:1px solid #dbe3ec;border-radius:8px;overflow:hidden'>");
            html.Append("<tr><td style='padding:22px 24px'><p style='margin:0 0 12px'>Dear Client,</p><p style='margin:0 0 18px;color:#526273'>Please find the monthly FTE billing summary below. The detailed billing data is attached for your review.</p>");
            html.Append("<table role='presentation' width='100%' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:1px solid #d8e1ea'>");
            AddBodyRow(html, "Project #", project.ProjectNumber); AddBodyRow(html, "Domain", project.Domain); AddBodyRow(html, "Billing Month", monthText);
            foreach (FTEBilling.FteBillingSummaryItem item in report.SummaryItems) AddBodyRow(html, item.Label, item.Value);
            html.Append("</table><p style='margin:20px 0 0'>Regards,<br/><strong>Infinity Data Technologies</strong></p></td></tr><tr><td style='background:#f7f9fb;border-top:1px solid #e2e8ef;padding:12px 24px;font-size:11px;color:#738294'>This is a system-generated email. Please do not reply.</td></tr></table></td></tr></table>");
            return html.ToString();
        }

        private static void AddBodyRow(StringBuilder html, string label, string value)
        {
            html.Append("<tr><td style='width:38%;background:#edf4fa;border-bottom:1px solid #d8e1ea;padding:9px 12px;font-weight:600'>").Append(System.Web.HttpUtility.HtmlEncode(label)).Append("</td><td style='border-bottom:1px solid #d8e1ea;padding:9px 12px'>").Append(System.Web.HttpUtility.HtmlEncode(value)).Append("</td></tr>");
        }

        private static void SendEmail(RecipientInfo recipients, bool testMode, string testEmail, string subject, string body, string fileName, byte[] content)
        {
            using (MailMessage mail = new MailMessage())
            {
                AddAddresses(mail.To, testMode ? testEmail : recipients.To);
                if (!testMode) { AddAddresses(mail.CC, recipients.Cc); AddAddresses(mail.Bcc, recipients.Bcc); }
                mail.From = new MailAddress("ack@infinity-data.com", "FTE Billing", Encoding.UTF8);
                mail.Subject = subject; mail.Body = body; mail.IsBodyHtml = true;
                mail.Attachments.Add(new Attachment(new MemoryStream(content), fileName, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
                using (SmtpClient client = new SmtpClient("smtp.office365.com", 587))
                {
                    client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", GetPassword());
                    client.EnableSsl = true;
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                    client.Send(mail);
                }
            }
        }

        private static string GetPassword()
        {
            using (SqlConnection connection = OpenConnection())
            using (SqlCommand command = new SqlCommand("dbo.usp_GetEmailPassword", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Username", SqlDbType.NVarChar, 100).Value = "ackdata";
                return Convert.ToString(command.ExecuteScalar());
            }
        }

        private static void ValidateRecipients(RecipientInfo recipients, bool testMode, string testEmail)
        {
            if (testMode && string.IsNullOrWhiteSpace(testEmail)) throw new InvalidOperationException("FTEClientBillingTestEmail is required while Test Mode is enabled.");
            if (!testMode && string.IsNullOrWhiteSpace(recipients.To)) throw new InvalidOperationException("TO email is not configured for this project.");
        }

        private static void AddAddresses(MailAddressCollection target, string values)
        {
            foreach (string address in Convert.ToString(values).Split(new[] { ';', ',' }, StringSplitOptions.RemoveEmptyEntries)) target.Add(address.Trim());
        }

        private static bool GetBooleanSetting(string key) { bool value; return bool.TryParse(ConfigurationManager.AppSettings[key], out value) && value; }
        private static object DbValue(string value) { return string.IsNullOrWhiteSpace(value) ? (object)DBNull.Value : value.Trim(); }
        private static string CleanFileName(string value) { foreach (char c in Path.GetInvalidFileNameChars()) value = value.Replace(c, '_'); return value; }
        private static FteClientAutoBillingResult Fail(string message) { return new FteClientAutoBillingResult { Success = false, Message = message }; }

        private static SqlConnection OpenConnection() { SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["MainCon"].ConnectionString); connection.Open(); return connection; }
        private static void ExecuteNonQuery(string procedure, Action<SqlCommand> configure)
        {
            using (SqlConnection connection = OpenConnection()) using (SqlCommand command = new SqlCommand(procedure, connection)) { command.CommandType = CommandType.StoredProcedure; configure(command); command.ExecuteNonQuery(); }
        }
        private sealed class ProjectInfo { public int ProjectId; public string ProjectNumber; public string ProjectName; public string Domain; }
        private sealed class RecipientInfo { public string To; public string Cc; public string Bcc; }
    }
}
