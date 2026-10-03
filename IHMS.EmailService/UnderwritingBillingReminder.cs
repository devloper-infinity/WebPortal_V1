using InfinityERP.UnderwritingBilling;
using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;

namespace IHMS.EmailService
{
    internal sealed class UnderwritingBillingReminder
    {
        private readonly string connectionString;
        private readonly string mailbox;

        internal UnderwritingBillingReminder(string connectionString, string mailbox)
        { this.connectionString = connectionString; this.mailbox = mailbox; }

        internal void RunIfDue(DateTime now)
        {
            if (now.Hour < 7) return;
            foreach (string reminderType in GetReminderTypes(now.Date))
                foreach (int employeeId in new[] { 277, 6823 })
                    SendBillingReminder(employeeId, reminderType, now.Date);
        }

        internal void RunCommitmentIfDue(DateTime now)
        {
            if (now.Hour < 7) return;
            foreach (string reminderType in GetReminderTypes(now.Date))
                SendBillingReminder(255, reminderType, now.Date, true);
        }

        public BillingValidationResult GetPendingBillingData(int employeeId, DateTime billingMonth, DateTime toDate)
        { return new UnderwritingBillingValidationService(connectionString).GetPendingBillingData(employeeId, billingMonth, toDate); }

        public string BuildEmailSummary(BillingValidationResult data, string reminderType)
        { return BuildEmailSummary(data, reminderType, false); }

        private string BuildEmailSummary(BillingValidationResult data, string reminderType, bool isCommitment)
        {
            StringBuilder body = new StringBuilder();
            body.Append("<div style=\"font-family:Bahnschrift,'Segoe UI',Arial,sans-serif;font-size:12px;color:#27364b;background:#f4f7fb;padding:20px\">")
                .Append("<div style='max-width:1000px;margin:auto;background:#fff;border:1px solid #dde4ed;border-radius:8px;overflow:hidden'>")
                .Append("<div style='background:#304b70;color:#fff;padding:18px 22px'><div style='font-size:21px;font-weight:600'>").Append(isCommitment ? "Commitment Monthly Billing Status" : "Underwriting Monthly Billing Readiness").Append("</div><div style='font-size:12px;margin-top:4px;color:#dce6f3'>Infinity ERP automated billing validation</div></div>")
                .Append("<div style='padding:18px 22px'><table cellpadding='0' cellspacing='0' style='margin-bottom:16px'><tr><td style='padding-right:25px;color:#718096'>Reminder</td><td style='font-weight:600;padding-right:35px'>").Append(H(reminderType))
                .Append("</td><td style='padding-right:25px;color:#718096'>Billing Month</td><td style='font-weight:600'>").Append(data.BillingMonth.ToString("MMMM yyyy")).Append("</td></tr></table>")
                .Append("<table cellpadding='8' cellspacing='0' style='border-collapse:collapse;width:100%;font-family:Bahnschrift,Segoe UI,Arial,sans-serif;font-size:11px'><tr style='background:#eaf0f8;color:#30435d'><th style='text-align:left;border:1px solid #d8e0ea'>Project</th><th style='border:1px solid #d8e0ea'>Billing Month</th><th style='border:1px solid #d8e0ea'>Total</th><th style='border:1px solid #d8e0ea'>Dispatched</th><th style='border:1px solid #d8e0ea'>").Append(isCommitment ? "On Hold" : "Pending").Append("</th>");
            if (!isCommitment) body.Append("<th style='border:1px solid #d8e0ea'>Blank Billing Parameters</th><th style='border:1px solid #d8e0ea'>Remark Pending</th>");
            body.Append("</tr>");
            foreach (ProjectBillingSummary project in data.Summary)
            {
                body.Append("<tr><td style='border:1px solid #dfe5ec;font-weight:600'>").Append(H(project.ProjectName)).Append("</td><td style='border:1px solid #dfe5ec;text-align:center'>")
                    .Append(data.BillingMonth.ToString("MMMM yyyy")).Append("</td><td style='border:1px solid #dfe5ec;text-align:center'>").Append(project.TotalLoans)
                    .Append("</td><td style='border:1px solid #dfe5ec;text-align:center'>").Append(project.DispatchedLoans).Append("</td><td style='border:1px solid #dfe5ec;text-align:center'>")
                    .Append(project.PendingLoans).Append("</td>");
                if (!isCommitment) body.Append("<td style='border:1px solid #dfe5ec;text-align:center'>").Append(project.BlankBillingParameters)
                    .Append("</td><td style='border:1px solid #dfe5ec;text-align:center;color:#b2372e;font-weight:600'>").Append(project.RemarkPendingCount).Append("</td>");
                body.Append("</tr>");
            }
            return body.Append("</table><div style='margin-top:16px;padding:11px 13px;background:#fff7e8;border-left:4px solid #d99721'>").Append(isCommitment ? "Review the attached project worksheets for complete project details and records without a Dispatched Date." : "Review the attached project worksheets for loan-level details, missing parameters and saved remarks.").Append("</div></div></div></div>").ToString();
        }

        public byte[] GenerateExcel(BillingValidationResult data)
        { return GenerateExcel(data, false); }

        private byte[] GenerateExcel(BillingValidationResult data, bool isCommitment)
        {
            using (XLWorkbook workbook = new XLWorkbook())
            {
                workbook.Style.Font.FontName = "Bahnschrift";
                workbook.Style.Font.FontSize = 10;
                IXLWorksheet summary = workbook.Worksheets.Add("Summary");
                int summaryColumnCount = isCommitment ? 5 : 7;
                WriteTitle(summary, isCommitment ? "Commitment Monthly Billing Status" : "Underwriting Monthly Billing Readiness", "Billing Month: " + data.BillingMonth.ToString("MMMM yyyy") + " | Through: " + data.PeriodTo.ToString("dd-MMM-yyyy"), summaryColumnCount);
                string[] summaryHeaders = isCommitment
                    ? new[] { "Project", "Billing Month", "Total", "Dispatched", "On Hold" }
                    : new[] { "Project", "Billing Month", "Total Loans", "Dispatched", "Pending", "Blank Billing Parameters", "Remark Pending" };
                for (int column = 0; column < summaryHeaders.Length; column++) summary.Cell(4, column + 1).Value = summaryHeaders[column];
                int summaryRow = 5;
                foreach (ProjectBillingSummary project in data.Summary)
                {
                    summary.Cell(summaryRow, 1).Value = project.ProjectName; summary.Cell(summaryRow, 2).Value = data.BillingMonth.ToString("MMMM yyyy");
                    summary.Cell(summaryRow, 3).Value = project.TotalLoans; summary.Cell(summaryRow, 4).Value = project.DispatchedLoans;
                    summary.Cell(summaryRow, 5).Value = project.PendingLoans;
                    if (!isCommitment) { summary.Cell(summaryRow, 6).Value = project.BlankBillingParameters; summary.Cell(summaryRow, 7).Value = project.RemarkPendingCount; }
                    summaryRow++;
                }
                FormatDataSheet(summary, summaryRow - 1, summaryColumnCount);

                HashSet<string> sheetNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { "Summary" };
                foreach (BillingProject project in data.Projects)
                {
                    IXLWorksheet sheet = workbook.Worksheets.Add(UniqueSheetName(project.ProjectName, sheetNames));
                    int extraStart = project.Columns.Count + 1;
                    WriteTitle(sheet, project.ProjectName, "Monthly billing details | " + data.BillingMonth.ToString("MMMM yyyy"), project.Columns.Count + 5);
                    for (int column = 0; column < project.Columns.Count; column++) sheet.Cell(4, column + 1).Value = project.Columns[column];
                    string[] extra = isCommitment
                        ? new[] { "Missing Field", "Record Status", "Existing Remark", "Remark Added By", "Remark Date" }
                        : new[] { "Blank Parameter Name(s)", "Pending Status", "Existing Remark", "Remark Added By", "Remark Date" };
                    for (int column = 0; column < extra.Length; column++) sheet.Cell(4, extraStart + column).Value = extra[column];

                    int dealIndex = FindColumn(project.Columns, "Deal #", "Deal No");
                    int loanIndex = FindColumn(project.Columns, "Loan #", "Loan #1", "Loan No", "Loan Number", "Order #", "Order No", "Order Number");
                    Dictionary<string, BlankBillingLoan> exceptions = data.BlankLoans.Concat(data.PendingLoans)
                        .Where(x => x.ProjectID == project.ProjectID).GroupBy(x => (x.DealNo ?? "") + "|" + (x.LoanNo ?? ""), StringComparer.OrdinalIgnoreCase)
                        .ToDictionary(x => x.Key, x => x.First(), StringComparer.OrdinalIgnoreCase);
                    int rowNumber = 5;
                    foreach (List<string> row in project.Rows)
                    {
                        for (int column = 0; column < row.Count; column++) sheet.Cell(rowNumber, column + 1).Value = row[column] ?? "";
                        string deal = dealIndex >= 0 && dealIndex < row.Count ? row[dealIndex] : "";
                        string loan = loanIndex >= 0 && loanIndex < row.Count ? row[loanIndex] : "";
                        BlankBillingLoan exception; exceptions.TryGetValue((deal ?? "") + "|" + (loan ?? ""), out exception);
                        if (exception != null)
                        {
                            sheet.Cell(rowNumber, extraStart).Value = exception.BlankParameters;
                            sheet.Cell(rowNumber, extraStart + 1).Value = isCommitment ? "On Hold" : (exception.HasValidRemark ? "Remarked" : "Action Required");
                            sheet.Cell(rowNumber, extraStart + 2).Value = exception.Remark;
                            sheet.Cell(rowNumber, extraStart + 3).Value = exception.RemarkAddedBy;
                            sheet.Cell(rowNumber, extraStart + 4).Value = exception.RemarkDate;
                            if (!exception.HasValidRemark) sheet.Range(rowNumber, extraStart, rowNumber, extraStart + 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#FDE8E7");
                        }
                        else sheet.Cell(rowNumber, extraStart + 1).Value = "Complete";
                        rowNumber++;
                    }
                    FormatDataSheet(sheet, rowNumber - 1, project.Columns.Count + 5);
                }
                using (MemoryStream stream = new MemoryStream()) { workbook.SaveAs(stream); return stream.ToArray(); }
            }
        }

        public void SendBillingReminder(int employeeId, string reminderType, DateTime runDate)
        { SendBillingReminder(employeeId, reminderType, runDate, false); }

        private void SendBillingReminder(int employeeId, string reminderType, DateTime runDate, bool isCommitment)
        {
            DateTime billingMonth = runDate.Day == 1 ? new DateTime(runDate.Year, runDate.Month, 1).AddMonths(-1) : new DateTime(runDate.Year, runDate.Month, 1);
            DateTime periodTo = runDate.AddDays(-1);
            if (HasReminderAlreadySent(employeeId, reminderType, billingMonth, runDate, isCommitment)) return;
            string settingPrefix = isCommitment ? "CommitmentBillingReminder" : "BillingReminder";
            bool testMode = String.Equals(ConfigurationManager.AppSettings[settingPrefix + "TestMode"], "true", StringComparison.OrdinalIgnoreCase);
            string actualEmail = GetReminderRecipient(employeeId, false);
            string sentEmail = testMode ? (ConfigurationManager.AppSettings[settingPrefix + "TestEmail"] ?? "").Trim() : actualEmail;
            string domainName = isCommitment ? "Commitment" : "Underwriting";
            string fileName = domainName + "_Billing_" + employeeId + "_" + billingMonth.ToString("yyyy_MM") + "_" + reminderType + ".xlsx";
            long logId = StartLog(employeeId, reminderType, billingMonth, periodTo, runDate, actualEmail, sentEmail, testMode, fileName, isCommitment);
            if (logId == 0) return;
            try
            {
                if (String.IsNullOrWhiteSpace(sentEmail)) throw new InvalidOperationException(testMode ? settingPrefix + "TestEmail is required while test mode is enabled." : "No employee email address is configured.");
                BillingValidationResult data = GetPendingBillingData(employeeId, billingMonth, periodTo);
                if (isCommitment ? data.PendingLoans.Count == 0 : (!data.BlankLoans.Any(x => !x.HasValidRemark) && data.PendingLoans.Count == 0)) { FinishLog(logId, "NoPending", null, isCommitment); return; }
                string subject = (testMode ? "[TEST] " : "") + domainName + " Monthly Billing Reminder - " + billingMonth.ToString("MMMM yyyy") + " - " + reminderType;
                byte[] attachment = GenerateExcel(data, isCommitment);
                using (MailMessage mail = new MailMessage())
                using (MemoryStream attachmentStream = new MemoryStream(attachment))
                using (Attachment excelAttachment = new Attachment(attachmentStream, fileName, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                using (SmtpClient client = new SmtpClient("smtp.office365.com", 587))
                {
                    mail.From = new MailAddress(mailbox, "Infinity ERP", Encoding.UTF8);
                    mail.To.Add(sentEmail);
                    if (!testMode)
                    {
                        AddConfiguredRecipients(mail.CC, settingPrefix + "Cc");
                        AddConfiguredRecipients(mail.Bcc, settingPrefix + "Bcc");
                    }
                    mail.Subject = subject;
                    mail.SubjectEncoding = Encoding.UTF8;
                    mail.Body = BuildEmailSummary(data, reminderType, isCommitment);
                    mail.BodyEncoding = Encoding.UTF8;
                    mail.IsBodyHtml = true;
                    mail.Priority = MailPriority.High;
                    mail.Attachments.Add(excelAttachment);
                    client.Credentials = new NetworkCredential(mailbox, GetSmtpPassword());
                    client.EnableSsl = true;
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                    client.Send(mail);
                }
                FinishLog(logId, "Sent", null, isCommitment);
            }
            catch (Exception ex) { FinishLog(logId, "Error", ex.Message, isCommitment); }
        }

        public bool HasReminderAlreadySent(int employeeId, string reminderType, DateTime billingMonth, DateTime runDate)
        { return HasReminderAlreadySent(employeeId, reminderType, billingMonth, runDate, false); }

        private bool HasReminderAlreadySent(int employeeId, string reminderType, DateTime billingMonth, DateTime runDate, bool isCommitment)
        {
            string table = isCommitment ? "dbo.CommitmentBillingReminderLog" : "dbo.UnderwritingBillingReminderLog";
            using (SqlConnection connection = Open()) using (SqlCommand command = new SqlCommand("SELECT COUNT(1) FROM " + table + " WHERE EmployeeID=@E AND ReminderType=@T AND BillingMonth=@M AND RunDate=@R", connection))
            { Add(command, "@E", employeeId); Add(command, "@T", reminderType); Add(command, "@M", billingMonth); Add(command, "@R", runDate); return Convert.ToInt32(command.ExecuteScalar()) > 0; }
        }

        public string GetReminderRecipient(int employeeId, bool isTestMode)
        {
            if (isTestMode) return (ConfigurationManager.AppSettings["BillingReminderTestEmail"] ?? "").Trim();
            using (SqlConnection connection = Open()) using (SqlCommand command = new SqlCommand("SELECT COALESCE(NULLIF(LTRIM(RTRIM(OfficialEmailID)),''),NULLIF(LTRIM(RTRIM(EmailID)),'')) FROM dbo.EmployeeInfo WHERE EmployeeID=@E", connection))
            { Add(command, "@E", employeeId); return Convert.ToString(command.ExecuteScalar()).Trim(); }
        }

        private long StartLog(int employeeId, string type, DateTime month, DateTime to, DateTime run, string actual, string sent, bool test, string file, bool isCommitment)
        {
            string table = isCommitment ? "dbo.CommitmentBillingReminderLog" : "dbo.UnderwritingBillingReminderLog";
            try { using (SqlConnection c = Open()) using (SqlCommand x = new SqlCommand("INSERT " + table + "(EmployeeID,ReminderType,BillingMonth,PeriodFrom,PeriodTo,RunDate,ActualEmailTo,SentEmailTo,IsTestEmail,Status,AttachmentFileName) VALUES(@E,@T,@M,@M,@To,@R,@A,@S,@I,'Processing',@F);SELECT CAST(SCOPE_IDENTITY() AS bigint);", c))
                { Add(x,"@E",employeeId);Add(x,"@T",type);Add(x,"@M",month);Add(x,"@To",to);Add(x,"@R",run);Add(x,"@A",actual);Add(x,"@S",sent);Add(x,"@I",test);Add(x,"@F",file);return Convert.ToInt64(x.ExecuteScalar()); } }
            catch (SqlException ex) { if (ex.Number == 2601 || ex.Number == 2627) return 0; throw; }
        }
        private void FinishLog(long id, string status, string error, bool isCommitment) { string table=isCommitment?"dbo.CommitmentBillingReminderLog":"dbo.UnderwritingBillingReminderLog"; using (SqlConnection c=Open()) using(SqlCommand x=new SqlCommand("UPDATE "+table+" SET Status=@S,ErrorMessage=@E,SentDateTime=CASE WHEN @S='Sent' THEN GETDATE() ELSE SentDateTime END WHERE ID=@I",c)){Add(x,"@S",status);Add(x,"@E",error);Add(x,"@I",id);x.ExecuteNonQuery();} }
        private SqlConnection Open() { SqlConnection c = new SqlConnection(connectionString); c.Open(); return c; }
        private string GetSmtpPassword()
        {
            using (SqlConnection connection = Open())
            using (SqlCommand command = new SqlCommand("dbo.usp_GetEmailPassword", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Username", SqlDbType.NVarChar, 100).Value = "ackdata";
                string password = Convert.ToString(command.ExecuteScalar());
                if (String.IsNullOrWhiteSpace(password)) throw new InvalidOperationException("SMTP password configuration 'ackdata' was not found.");
                return password;
            }
        }
        private static void AddConfiguredRecipients(MailAddressCollection recipients, string settingName)
        {
            string configuredAddresses = ConfigurationManager.AppSettings[settingName];
            if (String.IsNullOrWhiteSpace(configuredAddresses)) return;

            foreach (string address in configuredAddresses.Split(new[] { ';', ',' }, StringSplitOptions.RemoveEmptyEntries))
            {
                string trimmedAddress = address.Trim();
                if (trimmedAddress.Length == 0) continue;
                try { recipients.Add(new MailAddress(trimmedAddress)); }
                catch (FormatException ex)
                {
                    throw new ConfigurationErrorsException("Invalid email address in App.config setting '" + settingName + "': " + trimmedAddress, ex);
                }
            }
        }
        private static void Add(SqlCommand command, string name, object value) { command.Parameters.AddWithValue(name, value ?? DBNull.Value); }
        private static void WriteTitle(IXLWorksheet sheet, string title, string subtitle, int lastColumn)
        {
            sheet.Range(1, 1, 1, lastColumn).Merge().Value = title;
            sheet.Range(1, 1, 1, lastColumn).Style.Fill.BackgroundColor = XLColor.FromHtml("#304B70");
            sheet.Range(1, 1, 1, lastColumn).Style.Font.FontColor = XLColor.White;
            sheet.Range(1, 1, 1, lastColumn).Style.Font.Bold = true;
            sheet.Range(1, 1, 1, lastColumn).Style.Font.FontName = "Bahnschrift";
            sheet.Range(1, 1, 1, lastColumn).Style.Font.FontSize = 16;
            sheet.Row(1).Height = 28;
            sheet.Range(2, 1, 2, lastColumn).Merge().Value = subtitle;
            sheet.Range(2, 1, 2, lastColumn).Style.Font.FontName = "Bahnschrift";
            sheet.Range(2, 1, 2, lastColumn).Style.Font.FontSize = 10;
            sheet.Range(2, 1, 2, lastColumn).Style.Font.FontColor = XLColor.FromHtml("#66758A");
        }

        private static void FormatDataSheet(IXLWorksheet sheet, int lastRow, int lastColumn)
        {
            IXLRange header = sheet.Range(4, 1, 4, lastColumn);
            header.Style.Fill.BackgroundColor = XLColor.FromHtml("#EAF0F8");
            header.Style.Font.Bold = true;
            header.Style.Font.FontColor = XLColor.FromHtml("#30435D");
            header.Style.Font.FontName = "Bahnschrift";
            header.Style.Font.FontSize = 10;
            header.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            header.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
            header.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            header.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            if (lastRow >= 5)
            {
                IXLRange data = sheet.Range(5, 1, lastRow, lastColumn);
                data.Style.Font.FontName = "Bahnschrift";
                data.Style.Font.FontSize = 9;
                data.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                data.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                data.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                sheet.Range(4, 1, lastRow, lastColumn).SetAutoFilter();
            }
            sheet.SheetView.FreezeRows(4);
            sheet.Columns().AdjustToContents(4, Math.Max(4, lastRow));
            foreach (IXLColumn column in sheet.ColumnsUsed()) if (column.Width > 45) column.Width = 45;
            sheet.RowsUsed().Style.Alignment.WrapText = false;
        }

        private static int FindColumn(IList<string> columns, params string[] names)
        { for (int i = 0; i < columns.Count; i++) foreach (string name in names) if (String.Equals((columns[i] ?? "").Trim(), name, StringComparison.OrdinalIgnoreCase)) return i; return -1; }

        private static string UniqueSheetName(string projectName, HashSet<string> used)
        {
            string name = String.IsNullOrWhiteSpace(projectName) ? "Project" : projectName;
            foreach (char invalid in new[] { ':', '\\', '/', '?', '*', '[', ']' }) name = name.Replace(invalid, '-');
            name = name.Length > 31 ? name.Substring(0, 31) : name;
            string candidate = name; int suffix = 2;
            while (!used.Add(candidate)) { string end = " (" + suffix++ + ")"; candidate = name.Substring(0, Math.Min(name.Length, 31 - end.Length)) + end; }
            return candidate;
        }
        private static string H(string value) { return HttpUtility.HtmlEncode(value ?? ""); }
        private static IEnumerable<string> GetReminderTypes(DateTime date)
        { if (date.DayOfWeek == DayOfWeek.Monday) yield return "Weekly"; if (date.Day == 15 || date.Day == 16) yield return "BiMonthly"; if (date.Day == 1 || date.Day == DateTime.DaysInMonth(date.Year, date.Month)) yield return "MonthEnd"; }
    }
}
