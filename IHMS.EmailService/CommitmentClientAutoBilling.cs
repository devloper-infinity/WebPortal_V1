using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Net.Mail;
using System.Text;

namespace IHMS.EmailService
{
    internal sealed class CommitmentClientAutoBilling
    {
        private readonly string connectionString;
        private readonly bool testMode;
        private readonly string testEmail;
        private readonly int runHour;
        private readonly bool forceRun;

        internal CommitmentClientAutoBilling(string connectionString)
        {
            this.connectionString = connectionString;
            testMode = String.Equals(ConfigurationManager.AppSettings["CommitmentClientBillingTestMode"], "true", StringComparison.OrdinalIgnoreCase);
            testEmail = Convert.ToString(ConfigurationManager.AppSettings["CommitmentClientBillingTestEmail"]).Trim();
            Int32.TryParse(ConfigurationManager.AppSettings["CommitmentClientBillingRunHour"] ?? "7", out runHour);
            forceRun = String.Equals(ConfigurationManager.AppSettings["CommitmentClientBillingForceRun"], "true", StringComparison.OrdinalIgnoreCase);
        }

        internal void RunIfDue(DateTime now)
        {
            Run(now, false, null);
        }

        internal void RunNow(DateTime now)
        {
            // Manual Commitment batch: Commitment Typing (19) plus the approved
            // Domain 34 projects. Freight (2) has its own explicit command.
            Run(now, true, -1);
        }

        internal void RunFreightNow(DateTime now)
        {
            Run(now, true, 2);
        }

        private void Run(DateTime now, bool manualRun, int? domainId)
        {
            Console.WriteLine("{0:yyyy-MM-dd HH:mm:ss zzz} Commitment schedule evaluation: day={1}, hour={2}, configured hour={3}.", now, now.Day, now.Hour, runHour);
            if (!manualRun && !forceRun && now.Hour < runHour) { Console.WriteLine("Commitment client billing skipped: scheduled hour has not been reached."); return; }
            if (!manualRun && !forceRun && now.Day != 2 && now.Day != 16) { Console.WriteLine("Commitment client billing skipped: today is not the 2nd or 16th."); return; }
            if (testMode && String.IsNullOrWhiteSpace(testEmail)) throw new ConfigurationErrorsException("CommitmentClientBillingTestEmail is required while Test Mode is enabled.");

            int billingRunDay = now.Day == 16 ? 16 : 1;
            List<ProjectRecipient> candidates = new List<ProjectRecipient>(GetDueProjects(now, billingRunDay, domainId));
            List<ProjectRecipient> projects = candidates.FindAll(HasCompletedOrders);
            Console.WriteLine("{0} client billing: {1} processable project(s) found from {2} configured candidate(s). TestMode={3}, ForceRun={4}, ManualRun={5}.", domainId == 2 ? "Freight" : "Commitment", projects.Count, candidates.Count, testMode, forceRun, manualRun);
            foreach (ProjectRecipient project in projects)
            {
                try { Console.WriteLine("Processing {0} ({1}), {2:dd-MMM-yyyy} ~ {3:dd-MMM-yyyy}...", project.ProjectName, project.BillingCycle, project.From, project.ToDate); ProcessProject(project); }
                catch (Exception ex) { Console.Error.WriteLine("{0:u} Commitment client billing failed for {1}: {2}\n{3}", DateTime.Now, project.ProjectName, ex.Message, ex); }
            }
        }

        private IEnumerable<ProjectRecipient> GetDueProjects(DateTime now, int billingRunDay, int? domainId)
        {
            List<ProjectRecipient> projects = new List<ProjectRecipient>();
            const string sql = @"SELECT DISTINCT P.ProjectID,LTRIM(RTRIM(P.ProjectName)) ProjectName,LTRIM(RTRIM(CF.BillingCycle)) BillingCycle,CASE WHEN CF.DomainId=2 THEN 'Freight' ELSE 'Commitment Typing' END BillingType,E.TOID,E.CCID,E.BCCID
FROM dbo.ClientFeedback CF
INNER JOIN dbo.Project P ON P.ProjectID=CF.ProjectId
INNER JOIN dbo.UserProjectConfiguration U ON U.ProjectID=P.ProjectID AND U.UserID=CASE WHEN CF.DomainId=2 THEN 6 ELSE 255 END
OUTER APPLY(SELECT TOP 1 M.TOID,M.CCID,M.BCCID FROM dbo.ClientBillingEmailMaster M WHERE M.ProjectID=0) E
WHERE CF.DomainId IN (2,19,34)
AND (@DomainId IS NULL OR (@DomainId=-1 AND CF.DomainId IN (19,34)) OR CF.DomainId=@DomainId)
AND NOT (CF.DomainId=2 AND P.ProjectID IN (49,333))
AND ISNULL(NULLIF(LOWER(LTRIM(RTRIM(CONVERT(nvarchar(50),CF.Status)))),''),'active') NOT IN ('0','false','inactive','deleted')
AND ISNULL(P.IsDelete,0)=0 AND ISNULL(P.Status,1)=1
AND EXISTS(SELECT 1 FROM InfinityBilling.dbo.InfinityBilling_InvoiceMaster IM WHERE IM.ProjectID=P.ProjectID AND DATEDIFF(MONTH,CONVERT(date,IM.AddedDate),CONVERT(date,GETDATE()))<=3)
AND (CF.DomainId<>34 OR EXISTS
    (SELECT 1 FROM Commitment.dbo.WBT_TrackingSheet T
     WHERE T.ProjectID=P.ProjectID AND LTRIM(RTRIM(T.BillingPeriod))=@FirstHalfPeriod))
AND NULLIF(LTRIM(RTRIM(E.TOID)),'') IS NOT NULL
AND ((@RunDay=16 AND LOWER(REPLACE(REPLACE(CF.BillingCycle,'-',''),' ',''))='bimonthly')
 OR (@RunDay=1 AND LOWER(REPLACE(REPLACE(CF.BillingCycle,'-',''),' ','')) IN ('monthly','bimonthly')))
ORDER BY ProjectName";
            using (SqlConnection connection = Open())
            using (SqlCommand command = new SqlCommand(sql, connection))
            {
                DateTime firstHalfMonth = billingRunDay == 16
                    ? new DateTime(now.Year, now.Month, 1)
                    : new DateTime(now.Year, now.Month, 1).AddMonths(-1);
                string firstHalfPeriod = firstHalfMonth.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture)
                    + " ~ " + new DateTime(firstHalfMonth.Year, firstHalfMonth.Month, 15).ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                command.Parameters.Add("@RunDay", SqlDbType.Int).Value = billingRunDay;
                command.Parameters.Add("@DomainId", SqlDbType.Int).Value = domainId.HasValue ? (object)domainId.Value : DBNull.Value;
                command.Parameters.Add("@FirstHalfPeriod", SqlDbType.NVarChar, 1000).Value = firstHalfPeriod;
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string cycle = Convert.ToString(reader["BillingCycle"]).Trim();
                        DateTime from, to;
                        bool biMonthly = NormalizeCycle(cycle) == "bimonthly";
                        if (billingRunDay == 16) { from = new DateTime(now.Year, now.Month, 1); to = new DateTime(now.Year, now.Month, 15); }
                        else
                        {
                            DateTime previous = new DateTime(now.Year, now.Month, 1).AddMonths(-1);
                            from = biMonthly ? new DateTime(previous.Year, previous.Month, 16) : previous;
                            to = previous.AddMonths(1).AddDays(-1);
                        }
                        projects.Add(new ProjectRecipient
                        {
                            ProjectID = Convert.ToInt32(reader["ProjectID"]), ProjectName = Convert.ToString(reader["ProjectName"]), BillingCycle = cycle, BillingType = Convert.ToString(reader["BillingType"]),
                            To = Convert.ToString(reader["TOID"]), Cc = Convert.ToString(reader["CCID"]), Bcc = Convert.ToString(reader["BCCID"]), From = from, ToDate = to
                        });
                    }
                }
            }
            return projects;
        }

        private bool HasCompletedOrders(ProjectRecipient project)
        {
            string period = project.From.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) + " ~ " + project.ToDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
            const string sql = @"DECLARE @DateColumn sysname,@StatusColumn sysname,@Sql nvarchar(max),@Count int;
IF @ProjectID IN (47,137)
BEGIN
 SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Order Date');
 IF NULLIF(@DateColumn,'') IS NULL SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'order Date');
END
ELSE
BEGIN
 SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatched Date');
 IF NULLIF(@DateColumn,'') IS NULL SELECT @DateColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Dispatch Date');
END;
SELECT @StatusColumn=ColName FROM dbo.usf_GetColumnNameForReport_NonDD(@ProjectID,'Final Status');
IF NULLIF(@DateColumn,'') IS NULL OR NULLIF(@StatusColumn,'') IS NULL BEGIN SELECT 0; RETURN; END;
SET @Sql=N'SELECT @Count=COUNT(1) FROM Commitment.dbo.WBT_TrackingSheet T WHERE T.ProjectID=@ProjectID
AND LOWER(LTRIM(RTRIM(CONVERT(nvarchar(max),T.'+QUOTENAME(@StatusColumn)+N'))))=''completed''
AND (T.BillingPeriod=@BillingPeriod OR (NULLIF(LTRIM(RTRIM(T.BillingPeriod)),'''') IS NULL AND ISDATE(T.'+QUOTENAME(@DateColumn)+N')=1 AND CONVERT(date,T.'+QUOTENAME(@DateColumn)+N') BETWEEN @From AND @To));';
EXEC sys.sp_executesql @Sql,N'@ProjectID int,@BillingPeriod nvarchar(1000),@From date,@To date,@Count int OUTPUT',@ProjectID,@BillingPeriod,@From,@To,@Count OUTPUT;
SELECT ISNULL(@Count,0);";
            using (SqlConnection connection = Open())
            using (SqlCommand command = new SqlCommand(sql, connection))
            {
                command.CommandTimeout = 120;
                // 711 stores one aggregate row for 58+ orders.  On the second-half
                // run, include any still-unbilled row from the same month, while
                // retaining the 16th-to-month-end BillingPeriod on the email/update.
                DateTime eligibilityFrom = project.ProjectID == 137
                    ? new DateTime(project.From.Year, project.From.Month, 1)
                    : project.From;
                Add(command, "@ProjectID", project.ProjectID); Add(command, "@BillingPeriod", period); Add(command, "@From", eligibilityFrom); Add(command, "@To", project.ToDate);
                return Convert.ToInt32(command.ExecuteScalar()) > 0;
            }
        }

        private void ProcessProject(ProjectRecipient project)
        {
            string period = project.From.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) + " ~ " + project.ToDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
            long logId = StartLog(project, period);
            if (logId == 0) { Console.WriteLine("Skipped {0}: this {1} billing email is already Sent or Processing.", project.ProjectName, testMode ? "test" : "production"); return; }
            try
            {
                DataSet data = ProcessBillingData(project, period, false);
                if (data.Tables.Count < 2 || data.Tables[0].Rows.Count == 0) throw new InvalidOperationException("Commitment billing procedure did not return the expected summary and detail data.");
                DataRow summary = data.Tables[0].Rows[0];
                if (Convert.ToInt32(summary["TotalOrders"]) == 0)
                {
                    CompleteLog(logId, "NoData", null, null);
                    Console.WriteLine("Skipped {0}: no completed, unbilled orders were found for {1}.", project.ProjectName, period);
                    return;
                }
                string fileName = CleanFileName(project.ProjectName) + "_" + CleanFileName(project.BillingType) + "_Billing_" + project.From.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) + "_to_" + project.ToDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) + ".xlsx";
                byte[] excel = GenerateExcel(project, period, summary, data.Tables[1]);
                string subject = project.ProjectName + "-Client Billing - " + period + " ( " + project.BillingType + " )";
                if (testMode) subject = "[TEST] " + subject;
                Send(project, subject, BuildBody(project, period, summary), fileName, excel);
                if (!testMode) ProcessBillingData(project, period, true);
                CompleteLog(logId, "Sent", null, fileName);
                Console.WriteLine("Sent {0} successfully. LogID={1}, attachment={2}.", project.ProjectName, logId, fileName);
            }
            catch (Exception ex)
            {
                try { CompleteLog(logId, "Failed", ex.ToString(), null); } catch { }
                throw;
            }
        }

        private DataSet ProcessBillingData(ProjectRecipient project, string period, bool applyChanges)
        {
            using (SqlConnection connection = Open())
            using (SqlCommand command = new SqlCommand("dbo.usp_ProcessCommitmentClientBilling", connection))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                command.CommandType = CommandType.StoredProcedure; command.CommandTimeout = 300;
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = project.ProjectID;
                command.Parameters.Add("@PeriodFrom", SqlDbType.Date).Value = project.From;
                command.Parameters.Add("@PeriodTo", SqlDbType.Date).Value = project.ToDate;
                command.Parameters.Add("@BillingPeriod", SqlDbType.NVarChar, 1000).Value = period;
                command.Parameters.Add("@BillingAddedBy", SqlDbType.Int).Value = 2;
                command.Parameters.Add("@ApplyChanges", SqlDbType.Bit).Value = applyChanges;
                DataSet data = new DataSet(); adapter.Fill(data); return data;
            }
        }

        private long StartLog(ProjectRecipient project, string period)
        {
            using (SqlConnection connection = Open())
            using (SqlCommand command = new SqlCommand("dbo.usp_StartCommitmentClientBillingEmail", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                Add(command,"@ProjectID",project.ProjectID); Add(command,"@BillingPeriod",period); Add(command,"@PeriodFrom",project.From); Add(command,"@PeriodTo",project.ToDate); Add(command,"@BillingCycle",project.BillingCycle);
                Add(command,"@ActualTo",project.To); Add(command,"@ActualCc",Db(project.Cc)); Add(command,"@ActualBcc",Db(project.Bcc)); Add(command,"@SentTo",testMode?testEmail:project.To); Add(command,"@IsTestEmail",testMode);
                object value=command.ExecuteScalar(); return value==null||value==DBNull.Value?0:Convert.ToInt64(value);
            }
        }

        private void CompleteLog(long id,string status,string error,string file)
        {
            using(SqlConnection connection=Open()) using(SqlCommand command=new SqlCommand("dbo.usp_CompleteCommitmentClientBillingEmail",connection))
            { command.CommandType=CommandType.StoredProcedure;Add(command,"@LogID",id);Add(command,"@Status",status);Add(command,"@ErrorMessage",Db(error));Add(command,"@AttachmentFileName",Db(file));command.ExecuteNonQuery(); }
        }

        private static byte[] GenerateExcel(ProjectRecipient project,string period,DataRow summary,DataTable details)
        {
            using(XLWorkbook workbook=new XLWorkbook()) using(MemoryStream stream=new MemoryStream())
            {
                IXLWorksheet sheet=workbook.Worksheets.Add("Summary");
                sheet.Cell(1,1).Value=project.ProjectName+"-Client Billing - "+period+" ( "+project.BillingType+" )";
                sheet.Range(1,1,1,6).Merge(); sheet.Range(1,1,1,6).Style.Fill.BackgroundColor=XLColor.FromHtml("#9BD5EA"); sheet.Range(1,1,1,6).Style.Font.Bold=true;
                string[] headers={"Project#","Type","Total Orders","Dispatched","Cancelled","On Hold"};
                for(int i=0;i<headers.Length;i++){sheet.Cell(2,i+1).Value=headers[i];sheet.Cell(2,i+1).Style.Fill.BackgroundColor=XLColor.FromHtml("#9BD5EA");sheet.Cell(2,i+1).Style.Font.Bold=true;}
                sheet.Cell(3,1).Value=project.ProjectName;sheet.Cell(3,2).Value=project.BillingType;sheet.Cell(3,3).Value=Convert.ToInt32(summary["TotalOrders"]);sheet.Cell(3,4).Value=Convert.ToInt32(summary["Dispatched"]);sheet.Cell(3,5).Value=Convert.ToInt32(summary["Cancelled"]);sheet.Cell(3,6).Value=Convert.ToInt32(summary["OnHold"]);
                sheet.RangeUsed().Style.Border.OutsideBorder=XLBorderStyleValues.Thin;sheet.RangeUsed().Style.Border.InsideBorder=XLBorderStyleValues.Thin;sheet.Style.Font.FontName="Bahnschrift";sheet.Style.Font.FontSize=10;sheet.Columns().AdjustToContents();
                IXLWorksheet detail=workbook.Worksheets.Add("Billing Details"); if(details.Columns.Count>0) detail.Cell(1,1).InsertTable(details,"CommitmentBillingDetails",true);detail.Style.Font.FontName="Bahnschrift";detail.Style.Font.FontSize=10;detail.SheetView.FreezeRows(1);detail.Columns().AdjustToContents(8,45);
                workbook.SaveAs(stream);return stream.ToArray();
            }
        }

        private static string BuildBody(ProjectRecipient project,string period,DataRow summary)
        {
            string[] labels={"Project #","Domain","Billing Period","Total Orders","Dispatched","Cancelled","On Hold"};
            object[] values={project.ProjectName,project.BillingType,period,summary["TotalOrders"],summary["Dispatched"],summary["Cancelled"],summary["OnHold"]};
            StringBuilder body=new StringBuilder("<table role='presentation' width='100%' cellspacing='0' cellpadding='0' style='background:#f3f6f9;padding:24px 0;font-family:Bahnschrift,Arial,sans-serif;color:#243447'><tr><td align='center'><table role='presentation' width='680' cellspacing='0' cellpadding='0' style='width:100%;max-width:680px;background:#fff;border:1px solid #dbe3ec;border-radius:8px;overflow:hidden'>");
            body.Append("<tr><td style='padding:22px 24px'><p style='margin:0 0 12px'>Dear Client,</p><p style='margin:0 0 18px;color:#526273'>Please find the billing summary below. The detailed billing data is attached for your review.</p><table role='presentation' width='100%' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:1px solid #d8e1ea'>");
            for(int i=0;i<labels.Length;i++)body.Append("<tr><td style='width:38%;background:#edf4fa;border-bottom:1px solid #d8e1ea;padding:9px 12px;font-weight:600'>").Append(H(labels[i])).Append("</td><td style='border-bottom:1px solid #d8e1ea;padding:9px 12px'>").Append(H(Convert.ToString(values[i]))).Append("</td></tr>");
            return body.Append("</table><p style='margin:20px 0 0'>Regards,<br/><strong>Infinity Data Technologies</strong></p></td></tr><tr><td style='background:#f7f9fb;border-top:1px solid #e2e8ef;padding:12px 24px;font-size:11px;color:#738294'>This is a system-generated email. Please do not reply.</td></tr></table></td></tr></table>").ToString();
        }

        private void Send(ProjectRecipient project,string subject,string body,string fileName,byte[] excel)
        {
            using(MailMessage mail=new MailMessage())
            {
                Addresses(mail.To,testMode?testEmail:project.To);if(!testMode){Addresses(mail.CC,project.Cc);Addresses(mail.Bcc,project.Bcc);}mail.From=new MailAddress("ack@infinity-data.com","Client Billing",Encoding.UTF8);mail.Subject=subject;mail.Body=body;mail.IsBodyHtml=true;
                mail.Attachments.Add(new Attachment(new MemoryStream(excel),fileName,"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
                using(SmtpClient client=new SmtpClient("smtp.office365.com",587))
                {
                    client.UseDefaultCredentials=false;
                    client.Credentials=new System.Net.NetworkCredential("ack@infinity-data.com",Password());
                    client.EnableSsl=true;
                    System.Net.ServicePointManager.SecurityProtocol=System.Net.SecurityProtocolType.Tls12;
                    client.Send(mail);
                }
            }
        }

        private string Password(){using(SqlConnection c=Open())using(SqlCommand x=new SqlCommand("dbo.usp_GetEmailPassword",c)){x.CommandType=CommandType.StoredProcedure;Add(x,"@Username","ackdata");string password=Convert.ToString(x.ExecuteScalar());if(String.IsNullOrWhiteSpace(password))throw new InvalidOperationException("SMTP password configuration 'ackdata' was not found.");return password;}}
        private SqlConnection Open(){SqlConnection c=new SqlConnection(connectionString);c.Open();return c;}
        private static void Add(SqlCommand c,string n,object v){c.Parameters.AddWithValue(n,v??DBNull.Value);}
        private static object Db(string v){return String.IsNullOrWhiteSpace(v)?(object)DBNull.Value:v.Trim();}
        private static void Addresses(MailAddressCollection target,string value){foreach(string item in Convert.ToString(value).Split(new[]{';',','},StringSplitOptions.RemoveEmptyEntries))target.Add(item.Trim());}
        private static string NormalizeCycle(string value){return Convert.ToString(value).Replace("-","").Replace(" ","").ToLowerInvariant();}
        private static string CleanFileName(string value){foreach(char c in Path.GetInvalidFileNameChars())value=value.Replace(c,'_');return value;}
        private static string H(string value){return System.Web.HttpUtility.HtmlEncode(value);}
        private sealed class ProjectRecipient{public int ProjectID;public string ProjectName,BillingCycle,BillingType,To,Cc,Bcc;public DateTime From,ToDate;}
    }
}
