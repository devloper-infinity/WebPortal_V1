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
    internal sealed class ValuationClientAutoBilling
    {
        readonly string cs; readonly bool testMode; readonly string testEmail; readonly int runHour;
        internal ValuationClientAutoBilling(string connectionString)
        {
            cs=connectionString;
            testMode=String.Equals(ConfigurationManager.AppSettings["ValuationClientBillingTestMode"],"true",StringComparison.OrdinalIgnoreCase);
            testEmail=Convert.ToString(ConfigurationManager.AppSettings["ValuationClientBillingTestEmail"]).Trim();
            Int32.TryParse(ConfigurationManager.AppSettings["ValuationClientBillingRunHour"]??"7",out runHour);
        }
        internal void RunNow(DateTime now){Run(now,true);} internal void RunIfDue(DateTime now){Run(now,false);}
        void Run(DateTime now,bool manual)
        {
            if(!manual && (now.Hour<runHour || (now.Day!=2 && now.Day!=16))) return;
            if(testMode && String.IsNullOrWhiteSpace(testEmail)) throw new ConfigurationErrorsException("ValuationClientBillingTestEmail is required in Test Mode.");
            int runDay=now.Day==16?16:1; DateTime month=runDay==16?new DateTime(now.Year,now.Month,1):new DateTime(now.Year,now.Month,1).AddMonths(-1);
            List<Project> projects=LoadProjects(month,runDay);
            Console.WriteLine("Valuation client billing: {0} configured project(s). TestMode={1}, ManualRun={2}.",projects.Count,testMode,manual);
            foreach(Project p in projects) try{Process(p);}catch(Exception ex){Console.Error.WriteLine("{0:u} Valuation billing failed for {1}: {2}\n{3}",DateTime.Now,p.Name,ex.Message,ex);}
        }
        List<Project> LoadProjects(DateTime month,int runDay)
        {
            var list=new List<Project>(); const string sql=@"SELECT DISTINCT P.ProjectID,LTRIM(RTRIM(P.ProjectName)) ProjectName,LTRIM(RTRIM(CF.BillingCycle)) BillingCycle,E.TOID,E.CCID,E.BCCID
FROM dbo.ClientFeedback CF INNER JOIN dbo.Project P ON P.ProjectID=CF.ProjectId
INNER JOIN dbo.UserProjectConfiguration U ON U.ProjectID=P.ProjectID AND U.UserID IN(40,318)
OUTER APPLY(SELECT TOP 1 M.TOID,M.CCID,M.BCCID FROM dbo.ClientBillingEmailMaster M WHERE M.ProjectID IN(P.ProjectID,-4) ORDER BY CASE WHEN M.ProjectID=P.ProjectID THEN 0 ELSE 1 END)E
WHERE CF.DomainId=4 AND ISNULL(NULLIF(LOWER(LTRIM(RTRIM(CONVERT(nvarchar(50),CF.Status)))),''),'active') NOT IN('0','false','inactive','deleted')
AND ISNULL(P.IsDelete,0)=0 AND ISNULL(P.Status,1)=1
AND (@RequireRecipient=0 OR NULLIF(LTRIM(RTRIM(E.TOID)),'') IS NOT NULL)
AND EXISTS(SELECT 1 FROM InfinityBilling.dbo.InfinityBilling_InvoiceMaster IM WHERE IM.ProjectID=P.ProjectID AND DATEDIFF(MONTH,CONVERT(date,IM.AddedDate),CONVERT(date,GETDATE()))<=3)
AND (EXISTS(SELECT 1 FROM dbo.usf_GetColumnNameForReport_NonDD(P.ProjectID,'Dispatched Date') X WHERE NULLIF(X.ColName,'') IS NOT NULL)
 OR EXISTS(SELECT 1 FROM dbo.usf_GetColumnNameForReport_NonDD(P.ProjectID,'Dispatch Date') X WHERE NULLIF(X.ColName,'') IS NOT NULL)
 OR EXISTS(SELECT 1 FROM dbo.usf_GetColumnNameForReport_NonDD(P.ProjectID,'System Delivered Time') X WHERE NULLIF(X.ColName,'') IS NOT NULL))
AND ((@RunDay=16 AND LOWER(REPLACE(REPLACE(CF.BillingCycle,'-',''),' ',''))='bimonthly') OR (@RunDay=1 AND LOWER(REPLACE(REPLACE(CF.BillingCycle,'-',''),' ','')) IN('monthly','bimonthly'))) ORDER BY ProjectName";
            using(var c=Open())using(var q=new SqlCommand(sql,c)){q.Parameters.Add("@RunDay",SqlDbType.Int).Value=runDay;q.Parameters.Add("@RequireRecipient",SqlDbType.Bit).Value=!testMode;using(var r=q.ExecuteReader())while(r.Read()){string cycle=Convert.ToString(r["BillingCycle"]);bool bi=Normalize(cycle)=="bimonthly";DateTime from=runDay==16?month:(bi?month.AddDays(15):month);DateTime to=month.AddMonths(1).AddDays(-1);list.Add(new Project{Id=Convert.ToInt32(r["ProjectID"]),Name=Convert.ToString(r["ProjectName"]),Cycle=cycle,From=from,ToDate=to,To=Convert.ToString(r["TOID"]),Cc=Convert.ToString(r["CCID"]),Bcc=Convert.ToString(r["BCCID"])});}}return list;
        }
        void Process(Project p)
        {
            string period=p.From.ToString("dd-MMM-yyyy",CultureInfo.InvariantCulture)+" ~ "+p.ToDate.ToString("dd-MMM-yyyy",CultureInfo.InvariantCulture);
            DataSet ds=Data(p,period,false);if(ds.Tables.Count<2||ds.Tables[0].Rows.Count==0||Convert.ToInt32(ds.Tables[0].Rows[0]["TotalOrders"])==0){Console.WriteLine("Skipped {0}: no eligible orders for {1}.",p.Name,period);return;}
            long log=Start(p,period);if(log==0){Console.WriteLine("Skipped {0}: already Sent or Processing.",p.Name);return;}
            try{DataRow s=ds.Tables[0].Rows[0];string file=Clean(p.Name)+"_Valuation_Billing_"+p.From.ToString("dd-MMM-yyyy")+"_to_"+p.ToDate.ToString("dd-MMM-yyyy")+".xlsx";byte[] excel=Excel(p,period,s,ds.Tables[1]);string subject=p.Name+" Valuation - Client Billing - "+period;if(testMode)subject="[TEST] "+subject;Send(p,subject,Body(p,period,s),file,excel);if(!testMode)Data(p,period,true);Complete(log,"Sent",null,file);Console.WriteLine("Sent {0} successfully. LogID={1}, orders={2}.",p.Name,log,s["TotalOrders"]);}catch(Exception ex){try{Complete(log,"Failed",ex.ToString(),null);}catch{}throw;}
        }
        DataSet Data(Project p,string period,bool apply){using(var c=Open())using(var q=new SqlCommand("dbo.usp_ProcessValuationClientBilling",c))using(var a=new SqlDataAdapter(q)){q.CommandType=CommandType.StoredProcedure;q.CommandTimeout=300;Add(q,"@ProjectID",p.Id);Add(q,"@PeriodFrom",p.From);Add(q,"@PeriodTo",p.ToDate);Add(q,"@BillingPeriod",period);Add(q,"@BillingAddedBy",2);Add(q,"@ApplyChanges",apply);var d=new DataSet();a.Fill(d);return d;}}
        long Start(Project p,string period){using(var c=Open())using(var q=new SqlCommand("dbo.usp_StartValuationClientBillingEmail",c)){q.CommandType=CommandType.StoredProcedure;Add(q,"@ProjectID",p.Id);Add(q,"@BillingPeriod",period);Add(q,"@PeriodFrom",p.From);Add(q,"@PeriodTo",p.ToDate);Add(q,"@ActualTo",p.To);Add(q,"@ActualCc",Db(p.Cc));Add(q,"@ActualBcc",Db(p.Bcc));Add(q,"@SentTo",testMode?testEmail:p.To);Add(q,"@IsTestEmail",testMode);object x=q.ExecuteScalar();return x==null||x==DBNull.Value?0:Convert.ToInt64(x);}}
        void Complete(long id,string status,string error,string file){using(var c=Open())using(var q=new SqlCommand("dbo.usp_CompleteValuationClientBillingEmail",c)){q.CommandType=CommandType.StoredProcedure;Add(q,"@LogID",id);Add(q,"@Status",status);Add(q,"@ErrorMessage",Db(error));Add(q,"@AttachmentFileName",Db(file));q.ExecuteNonQuery();}}
        static byte[] Excel(Project p,string period,DataRow s,DataTable details){using(var w=new XLWorkbook())using(var m=new MemoryStream()){var sh=w.Worksheets.Add("Summary");sh.Cell(1,1).Value=p.Name+" Valuation Billing - "+period;sh.Range(1,1,1,5).Merge();string[] h={"Project#","Domain","Total Orders","Dispatched","On Hold"};for(int i=0;i<h.Length;i++)sh.Cell(2,i+1).Value=h[i];sh.Cell(3,1).Value=p.Name;sh.Cell(3,2).Value="Valuation";sh.Cell(3,3).Value=Convert.ToInt32(s["TotalOrders"]);sh.Cell(3,4).Value=Convert.ToInt32(s["Dispatched"]);sh.Cell(3,5).Value=Convert.ToInt32(s["OnHold"]);sh.Range(1,1,2,5).Style.Fill.BackgroundColor=XLColor.FromHtml("#9BD5EA");sh.RangeUsed().Style.Font.FontName="Bahnschrift";sh.Columns().AdjustToContents();var d=w.Worksheets.Add("Billing Details");d.Cell(1,1).InsertTable(details,"ValuationBillingDetails",true);d.Style.Font.FontName="Bahnschrift";d.Style.Font.FontSize=10;d.Columns().AdjustToContents(8,45);w.SaveAs(m);return m.ToArray();}}
        static string Body(Project p,string period,DataRow s)
        {
            string[] labels={"Project #","Domain","Billing Period","Total Orders","Dispatched","On Hold"};
            object[] values={p.Name,"Valuation",period,s["TotalOrders"],s["Dispatched"],s["OnHold"]};
            StringBuilder b=new StringBuilder("<table role='presentation' width='100%' cellspacing='0' cellpadding='0' style='background:#f3f6f9;padding:24px 0;font-family:Bahnschrift,Arial,sans-serif;color:#243447'><tr><td align='center'><table role='presentation' width='680' cellspacing='0' cellpadding='0' style='width:100%;max-width:680px;background:#ffffff;border:1px solid #dbe3ec;border-radius:8px;overflow:hidden'>");
            b.Append("<tr><td style='padding:22px 24px'><p style='margin:0 0 12px'>Dear Client,</p><p style='margin:0 0 18px;color:#526273'>Please find the Valuation billing summary below. The detailed billing data is attached for your review.</p><table role='presentation' width='100%' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:1px solid #d8e1ea'>");
            for(int i=0;i<labels.Length;i++)b.Append("<tr><td style='width:38%;background:#edf4fa;border-bottom:1px solid #d8e1ea;padding:9px 12px;font-weight:600'>").Append(H(labels[i])).Append("</td><td style='border-bottom:1px solid #d8e1ea;padding:9px 12px'>").Append(H(Convert.ToString(values[i],CultureInfo.InvariantCulture))).Append("</td></tr>");
            return b.Append("</table><p style='margin:20px 0 0'>Regards,<br/><strong>Infinity Data Technologies</strong></p></td></tr><tr><td style='background:#f7f9fb;border-top:1px solid #e2e8ef;padding:12px 24px;font-size:11px;color:#738294'>This is a system-generated email. Please do not reply.</td></tr></table></td></tr></table>").ToString();
        }
        void Send(Project p,string subject,string body,string file,byte[] bytes){using(var mail=new MailMessage()){Addresses(mail.To,testMode?testEmail:p.To);if(!testMode){Addresses(mail.CC,p.Cc);Addresses(mail.Bcc,p.Bcc);}mail.From=new MailAddress("ack@infinity-data.com","Client Billing",Encoding.UTF8);mail.Subject=subject;mail.Body=body;mail.IsBodyHtml=true;mail.Attachments.Add(new Attachment(new MemoryStream(bytes),file,"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));using(var smtp=new SmtpClient("smtp.office365.com",587)){smtp.UseDefaultCredentials=false;smtp.Credentials=new System.Net.NetworkCredential("ack@infinity-data.com",Password());smtp.EnableSsl=true;System.Net.ServicePointManager.SecurityProtocol=System.Net.SecurityProtocolType.Tls12;smtp.Send(mail);}}}
        string Password(){using(var c=Open())using(var q=new SqlCommand("dbo.usp_GetEmailPassword",c)){q.CommandType=CommandType.StoredProcedure;Add(q,"@Username","ackdata");string value=Convert.ToString(q.ExecuteScalar());if(String.IsNullOrWhiteSpace(value))throw new InvalidOperationException("SMTP password configuration 'ackdata' was not found.");return value;}}
        SqlConnection Open(){var c=new SqlConnection(cs);c.Open();return c;} static void Add(SqlCommand q,string n,object v){q.Parameters.AddWithValue(n,v??DBNull.Value);}static object Db(string s){return String.IsNullOrWhiteSpace(s)?(object)DBNull.Value:s;}static string Normalize(string s){return(s??"").ToLowerInvariant().Replace("-","").Replace(" ","");}static string Clean(string s){foreach(char x in Path.GetInvalidFileNameChars())s=s.Replace(x,'_');return s;}static string H(string s){return System.Web.HttpUtility.HtmlEncode(s??"");}static void Addresses(MailAddressCollection c,string s){foreach(string x in(s??"").Split(new[]{';',','},StringSplitOptions.RemoveEmptyEntries))c.Add(x.Trim());}
        sealed class Project{public int Id;public string Name,Cycle,To,Cc,Bcc;public DateTime From,ToDate;}
    }
}
