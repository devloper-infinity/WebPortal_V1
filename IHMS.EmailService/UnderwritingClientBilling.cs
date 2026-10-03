using ClosedXML.Excel;
using InfinityERP.UnderwritingBilling;
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
    internal sealed class UnderwritingClientBilling
    {
        readonly string cs; readonly bool creditTestMode,servicingTestMode; readonly string creditTestEmail,servicingTestEmail; readonly int runHour;
        internal UnderwritingClientBilling(string connectionString)
        {
            cs=connectionString;
            creditTestMode=String.Equals(ConfigurationManager.AppSettings["UnderwritingCreditClientBillingTestMode"],"true",StringComparison.OrdinalIgnoreCase);
            servicingTestMode=String.Equals(ConfigurationManager.AppSettings["UnderwritingServicingClientBillingTestMode"],"true",StringComparison.OrdinalIgnoreCase);
            creditTestEmail=Convert.ToString(ConfigurationManager.AppSettings["UnderwritingCreditClientBillingTestEmail"]).Trim();
            servicingTestEmail=Convert.ToString(ConfigurationManager.AppSettings["UnderwritingServicingClientBillingTestEmail"]).Trim();
            Int32.TryParse(ConfigurationManager.AppSettings["UnderwritingClientBillingRunHour"]??"7",out runHour);
        }
        internal void RunNow(DateTime now){Run(now,true,null);}
        internal void RunCreditNow(DateTime now){Run(now,true,6823);}
        internal void RunServicingNow(DateTime now){Run(now,true,277);}
        internal void RunIfDue(DateTime now){Run(now,false,null);}
        void Run(DateTime now,bool manual,int? selectedEmployeeId)
        {
            if(!manual && (now.Day!=2||now.Hour<runHour))return;
            DateTime month=new DateTime(now.Year,now.Month,1).AddMonths(-1),to=month.AddMonths(1).AddDays(-1);
            foreach(int employeeId in selectedEmployeeId.HasValue ? new[]{selectedEmployeeId.Value} : new[]{277,6823})
            {
                string domain=employeeId==277?"Servicing":"Credit";
                bool testMode=employeeId==277?servicingTestMode:creditTestMode;
                string testEmail=employeeId==277?servicingTestEmail:creditTestEmail;
                if(testMode&&String.IsNullOrWhiteSpace(testEmail))throw new ConfigurationErrorsException("Underwriting "+domain+" test email is required in Test Mode.");
                BillingValidationResult result=new UnderwritingBillingValidationService(cs).GetPendingBillingData(employeeId,month,to);
                Console.WriteLine("Underwriting {0}: {1} project(s), TestMode={2}, ManualRun={3}.",domain,result.Projects.Count,testMode,manual);
                foreach(BillingProject project in result.Projects)try{Process(employeeId,domain,month,to,project,testMode,testEmail);}catch(Exception ex){Console.Error.WriteLine("{0:u} Underwriting client billing failed for {1}: {2}\n{3}",DateTime.Now,project.ProjectName,ex.Message,ex);}
            }
        }
        void Process(int employeeId,string domain,DateTime month,DateTime toDate,BillingProject project,bool testMode,string testEmail)
        {
            Recipient recipient=RecipientFor(project.ProjectID,employeeId);
            if(!testMode&&(recipient==null||String.IsNullOrWhiteSpace(recipient.To))){Console.WriteLine("Skipped {0}: recipient configuration is missing.",project.ProjectName);return;}
            if(project.Summary==null||project.Summary.TotalLoans==0){Console.WriteLine("Skipped {0}: no loan data.",project.ProjectName);return;}
            int eligible=UpdateTracking(employeeId,project.ProjectID,month,toDate,false);
            if(eligible==0){Console.WriteLine("Skipped {0}: no eligible unbilled tracking rows.",project.ProjectName);return;}
            long log=Start(employeeId,project.ProjectID,month,toDate,recipient,testMode,testEmail);if(log==0){Console.WriteLine("Skipped {0}: already Sent or Processing.",project.ProjectName);return;}
            try
            {
                string monthText=month.ToString("MMMM-yyyy",CultureInfo.InvariantCulture),file=Clean(project.ProjectName)+"_"+domain+"_Billing_"+month.ToString("MMM-yyyy",CultureInfo.InvariantCulture)+".xlsx";
                string subject=project.ProjectName+" "+domain+" - Monthly Billing - "+monthText;if(testMode)subject="[TEST] "+subject;
                byte[] excel=Excel(project,domain,monthText);Send(recipient,subject,Body(project,domain,monthText),file,excel,testMode,testEmail);if(!testMode)UpdateTracking(employeeId,project.ProjectID,month,toDate,true);Complete(log,"Sent",null,file);
                Console.WriteLine("Sent {0} successfully. LogID={1}, loans={2}.",project.ProjectName,log,project.Summary.TotalLoans);
            }
            catch(Exception ex){try{Complete(log,"Failed",ex.ToString(),null);}catch{}throw;}
        }
        Recipient RecipientFor(int projectId,int employeeId)
        {
            int groupId=employeeId==277?-19:-15;const string sql=@"SELECT TOP 1 TOID,CCID,BCCID FROM dbo.ClientBillingEmailMaster WHERE ProjectID IN(@ProjectID,@GroupID) ORDER BY CASE WHEN ProjectID=@ProjectID THEN 0 ELSE 1 END";
            using(var c=Open())using(var q=new SqlCommand(sql,c)){q.Parameters.Add("@ProjectID",SqlDbType.Int).Value=projectId;q.Parameters.Add("@GroupID",SqlDbType.Int).Value=groupId;using(var r=q.ExecuteReader())return r.Read()?new Recipient{To=Convert.ToString(r[0]),Cc=Convert.ToString(r[1]),Bcc=Convert.ToString(r[2])}:new Recipient();}
        }
        int UpdateTracking(int employeeId,int projectId,DateTime month,DateTime toDate,bool apply)
        {
            using(var c=Open())using(var q=new SqlCommand("dbo.usp_UpdateUnderwritingClientBilling",c))
            {
                q.CommandType=CommandType.StoredProcedure;q.CommandTimeout=300;Add(q,"@EmployeeID",employeeId);Add(q,"@ProjectID",projectId);Add(q,"@BillingMonth",month);Add(q,"@PeriodTo",toDate);Add(q,"@BillingAddedBy",2);Add(q,"@ApplyChanges",apply);
                object value=q.ExecuteScalar();return value==null||value==DBNull.Value?0:Convert.ToInt32(value,CultureInfo.InvariantCulture);
            }
        }
        static byte[] Excel(BillingProject p,string domain,string month)
        {
            using(var w=new XLWorkbook())using(var m=new MemoryStream())
            {
                var s=w.Worksheets.Add("Summary");s.Cell(1,1).Value=p.ProjectName+" "+domain+" Billing - "+month;s.Range(1,1,1,5).Merge();s.Range(1,1,1,5).Style.Fill.BackgroundColor=XLColor.FromHtml("#103B62");s.Range(1,1,1,5).Style.Font.SetFontColor(XLColor.White);s.Range(1,1,1,5).Style.Font.Bold=true;
                string[] h={"Level","Project / Deal","Total Loans","Dispatched Loans","Pending Loans"};for(int i=0;i<h.Length;i++){s.Cell(2,i+1).Value=h[i];s.Cell(2,i+1).Style.Fill.BackgroundColor=XLColor.FromHtml("#DCEAF7");s.Cell(2,i+1).Style.Font.Bold=true;}
                int row=3;SummaryRow(s,row++,"Project",p.ProjectName,p.Summary);foreach(DealBillingSummary d in p.Summary.Deals)SummaryRow(s,row++,"Deal",d.DealNo,d);s.Style.Font.FontName="Bahnschrift";s.Style.Font.FontSize=10;s.Columns().AdjustToContents();
                var detail=w.Worksheets.Add("Loan Details");for(int c=0;c<p.Columns.Count;c++){detail.Cell(1,c+1).Value=p.Columns[c];detail.Cell(1,c+1).Style.Fill.BackgroundColor=XLColor.FromHtml("#DCEAF7");detail.Cell(1,c+1).Style.Font.Bold=true;}for(int r=0;r<p.Rows.Count;r++)for(int c=0;c<p.Columns.Count;c++)detail.Cell(r+2,c+1).Value=p.Rows[r][c];detail.Style.Font.FontName="Bahnschrift";detail.Style.Font.FontSize=10;detail.SheetView.FreezeRows(1);detail.Columns().AdjustToContents(8,45);w.SaveAs(m);return m.ToArray();
            }
        }
        static void SummaryRow(IXLWorksheet s,int row,string level,string name,BillingCounts c){s.Cell(row,1).Value=level;s.Cell(row,2).Value=name;s.Cell(row,3).Value=c.TotalLoans;s.Cell(row,4).Value=c.DispatchedLoans;s.Cell(row,5).Value=c.PendingLoans;}
        static string Body(BillingProject p,string domain,string month)
        {
            StringBuilder b=new StringBuilder("<table role='presentation' width='100%' cellspacing='0' cellpadding='0' style='background:#f3f6f9;padding:24px 0;font-family:Bahnschrift,Arial,sans-serif;color:#243447'><tr><td align='center'><table role='presentation' width='760' cellspacing='0' cellpadding='0' style='width:100%;max-width:760px;background:#fff;border:1px solid #dbe3ec'><tr><td style='padding:22px 24px'><p style='margin:0 0 12px'>Dear Client,</p><p style='margin:0 0 18px;color:#526273'>Please find the monthly billing summary below. Complete loan-level billing data is attached for your review.</p>");
            b.Append("<table role='presentation' width='100%' cellspacing='0' cellpadding='0' style='border-collapse:collapse;margin-bottom:18px'><tr><td style='background:#edf4fa;border:1px solid #d8e1ea;padding:9px 12px;font-weight:600'>Project #</td><td style='border:1px solid #d8e1ea;padding:9px 12px'>").Append(H(p.ProjectName)).Append("</td><td style='background:#edf4fa;border:1px solid #d8e1ea;padding:9px 12px;font-weight:600'>Domain</td><td style='border:1px solid #d8e1ea;padding:9px 12px'>").Append(H(domain)).Append("</td><td style='background:#edf4fa;border:1px solid #d8e1ea;padding:9px 12px;font-weight:600'>Billing Month</td><td style='border:1px solid #d8e1ea;padding:9px 12px'>").Append(H(month)).Append("</td></tr></table>");
            b.Append("<table role='presentation' width='100%' cellspacing='0' cellpadding='0' style='border-collapse:collapse'><tr style='background:#103b62;color:#fff'><th style='padding:9px;border:1px solid #d8e1ea;text-align:left'>Level</th><th style='padding:9px;border:1px solid #d8e1ea;text-align:left'>Project / Deal</th><th style='padding:9px;border:1px solid #d8e1ea'>Total Loans</th><th style='padding:9px;border:1px solid #d8e1ea'>Dispatched</th><th style='padding:9px;border:1px solid #d8e1ea'>Pending</th></tr>");
            BodyRow(b,"Project",p.ProjectName,p.Summary,true);foreach(DealBillingSummary d in p.Summary.Deals)BodyRow(b,"Deal",d.DealNo,d,false);
            return b.Append("</table><p style='margin:20px 0 0'>Regards,<br/><strong>Infinity Data Technologies</strong></p></td></tr><tr><td style='background:#f7f9fb;border-top:1px solid #e2e8ef;padding:12px 24px;font-size:11px;color:#738294'>This is a system-generated email. Please do not reply.</td></tr></table></td></tr></table>").ToString();
        }
        static void BodyRow(StringBuilder b,string level,string name,BillingCounts c,bool project){string bg=project?"#eaf2f8":"#ffffff";b.Append("<tr style='background:").Append(bg).Append("'><td style='border:1px solid #d8e1ea;padding:8px;font-weight:").Append(project?"700":"400").Append("'>").Append(level).Append("</td><td style='border:1px solid #d8e1ea;padding:8px'>").Append(H(name)).Append("</td><td style='border:1px solid #d8e1ea;padding:8px;text-align:center'>").Append(c.TotalLoans).Append("</td><td style='border:1px solid #d8e1ea;padding:8px;text-align:center'>").Append(c.DispatchedLoans).Append("</td><td style='border:1px solid #d8e1ea;padding:8px;text-align:center'>").Append(c.PendingLoans).Append("</td></tr>");}
        long Start(int employee,int project,DateTime month,DateTime to,Recipient r,bool testMode,string testEmail){using(var c=Open())using(var q=new SqlCommand("dbo.usp_StartUnderwritingClientBillingEmail",c)){q.CommandType=CommandType.StoredProcedure;Add(q,"@EmployeeID",employee);Add(q,"@ProjectID",project);Add(q,"@BillingMonth",month);Add(q,"@PeriodTo",to);Add(q,"@ActualTo",Db(r.To));Add(q,"@ActualCc",Db(r.Cc));Add(q,"@ActualBcc",Db(r.Bcc));Add(q,"@SentTo",testMode?testEmail:r.To);Add(q,"@IsTestEmail",testMode);object x=q.ExecuteScalar();return x==null||x==DBNull.Value?0:Convert.ToInt64(x);}}
        void Complete(long id,string status,string error,string file){using(var c=Open())using(var q=new SqlCommand("dbo.usp_CompleteUnderwritingClientBillingEmail",c)){q.CommandType=CommandType.StoredProcedure;Add(q,"@LogID",id);Add(q,"@Status",status);Add(q,"@ErrorMessage",Db(error));Add(q,"@AttachmentFileName",Db(file));q.ExecuteNonQuery();}}
        void Send(Recipient r,string subject,string body,string file,byte[] bytes,bool testMode,string testEmail){using(var mail=new MailMessage()){Addresses(mail.To,testMode?testEmail:r.To);if(!testMode){Addresses(mail.CC,r.Cc);Addresses(mail.Bcc,r.Bcc);}mail.From=new MailAddress("ack@infinity-data.com","Client Billing",Encoding.UTF8);mail.Subject=subject;mail.Body=body;mail.IsBodyHtml=true;mail.Attachments.Add(new Attachment(new MemoryStream(bytes),file,"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));using(var smtp=new SmtpClient("smtp.office365.com",587)){smtp.UseDefaultCredentials=false;smtp.Credentials=new System.Net.NetworkCredential("ack@infinity-data.com",Password());smtp.EnableSsl=true;System.Net.ServicePointManager.SecurityProtocol=System.Net.SecurityProtocolType.Tls12;smtp.Send(mail);}}}
        string Password(){using(var c=Open())using(var q=new SqlCommand("dbo.usp_GetEmailPassword",c)){q.CommandType=CommandType.StoredProcedure;Add(q,"@Username","ackdata");string x=Convert.ToString(q.ExecuteScalar());if(String.IsNullOrWhiteSpace(x))throw new InvalidOperationException("SMTP password configuration 'ackdata' was not found.");return x;}}
        SqlConnection Open(){var c=new SqlConnection(cs);c.Open();return c;}static void Add(SqlCommand q,string n,object v){q.Parameters.AddWithValue(n,v??DBNull.Value);}static object Db(string s){return String.IsNullOrWhiteSpace(s)?(object)DBNull.Value:s;}static void Addresses(MailAddressCollection c,string s){foreach(string x in(s??"").Split(new[]{';',','},StringSplitOptions.RemoveEmptyEntries))c.Add(x.Trim());}static string Clean(string s){foreach(char x in Path.GetInvalidFileNameChars())s=s.Replace(x,'_');return s;}static string H(string s){return System.Web.HttpUtility.HtmlEncode(s??"");}
        sealed class Recipient{public string To,Cc,Bcc;}
    }
}
