using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllSendMail
    {
        public string GetPassword(string Username)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmailPassword");
            SQLHelper.AddParamToSQLCmd(cmd, "@Username", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Username);
            string Password = (string)SQLHelper.ExecuteScalarCmd(cmd);
            return Password;
        }
        public bool sendMail(string EmailType, string Subject, StringBuilder htmlBody)
        {
            string ToAddress = string.Empty;
            string ToCC = string.Empty;
            string ToBCC = string.Empty;


            ToAddress = "n.nilkanth@infinityinternationals.us";

            String Body = htmlBody.ToString();
            StringBuilder template = new StringBuilder();
            template.Append("<html><head></head><body>");
            //template.Append("<img src=\"http://www.infinity-data.com/images/TemplateHeader.png\" /><br />");
            template.Append(Body);
            //template.Append("<br /><img src=\"http://www.infinity-data.com/images/TemplateFooter.png\" />");
            template.Append("</body></html>");
            string Pass = GetPassword("ackdata");
            MailMessage mail = new MailMessage();
            mail.To.Add(ToAddress);
            if (ToCC != "")
                mail.CC.Add(ToCC);
            if (ToBCC != "")
                mail.Bcc.Add(ToBCC);
            mail.Bcc.Add("n.nilkanth@infinityinternationals.us");

            mail.From = new MailAddress("ack@infinity-data.com", "HRMS", System.Text.Encoding.UTF8);
            mail.Subject = Subject;
            mail.SubjectEncoding = System.Text.Encoding.UTF8;
            mail.Body = template.ToString();
            mail.BodyEncoding = System.Text.Encoding.UTF8;
            mail.IsBodyHtml = true;
            mail.Priority = System.Net.Mail.MailPriority.High;
            SmtpClient client = new SmtpClient();
            client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", Pass);


            client.Host = "smtp.office365.com";  //Gmail works on Server Secured Layer
            client.Port = 587;
            client.EnableSsl = true;
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            
            try
            {
                client.Send(mail);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool SendStep1EmailForResignationWithAttachment(string EmailType, string ToAddress, string Subject, StringBuilder htmlBody, string FilePath)
        {
            string ToCC = string.Empty;
            string ToBCC = string.Empty;

            //DataTable dt = bllMaster.getEmailConfigrationInfo(EmailType);
            //try
            //{
            //    if (dt.Rows.Count > 0)
            //    {
            //        if (Convert.ToString(ToAddress) == "")
            //        {
            //            ToAddress = Convert.ToString(dt.Rows[0][3]);
            //            ToCC = Convert.ToString(dt.Rows[0][3]);
            //            ToBCC = Convert.ToString(dt.Rows[0][4]);
            //        }
            //        else
            //        {
            //            ToCC = Convert.ToString(dt.Rows[0][3]);
            //            ToBCC = Convert.ToString(dt.Rows[0][4]);
            //        }
            //    }
            //}
            //catch
            //{
            //}


            String Body = htmlBody.ToString();
            StringBuilder template = new StringBuilder();
            template.Append("<html><head></head><body>");
            template.Append("<div style = \"margin-right:20px; font-family:'Bookman Old Style'; font-size:14px; border:Solid 1px #a9d794; border-radius: 20px 20px 0px 0px; padding:20px 20px 20px 20px;\"> ");
            template.Append("<div style='background-color:#a9d794;  height:50px; vertical-align:center; text-align:center;'><span style=\"font-family:'Bookman Old Style'; font-weight:bold; font-size:28px; font-style:italic;\">Infinity IPS</span></div><hr />");
            template.Append(Body);
            template.Append("</div></div></body></html>");
            string Pass = GetPassword("ackdata");
            MailMessage mail = new MailMessage();
            mail.To.Add("n.nilkanth@infinityinternationals.us");
            //mail.To.Add(ToAddress);
            //if (ToCC != "")
            //    mail.CC.Add(ToCC);
            //if (ToBCC != "")
            //    mail.Bcc.Add(ToBCC);

            mail.Bcc.Add("n.nilkanth@infinityinternationals.us");
            if (FilePath != "")
            {
                mail.Attachments.Add(new Attachment(FilePath));
            }
            mail.From = new MailAddress("ack@infinity-data.com", "HRMS", System.Text.Encoding.UTF8);
            mail.Subject = Subject;
            mail.SubjectEncoding = System.Text.Encoding.UTF8;
            mail.Body = template.ToString();
            mail.BodyEncoding = System.Text.Encoding.UTF8;
            mail.IsBodyHtml = true;
            mail.Priority = System.Net.Mail.MailPriority.High;
            SmtpClient client = new SmtpClient();
            client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", Pass);


            client.Host = "smtp.office365.com";  //Gmail works on Server Secured Layer
            client.Port = 587;
            client.EnableSsl = true;
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            try
            {
                client.Send(mail);
                return true;
            }
            catch
            {
                return false;
            }
        }
        public void UserLeavesApprovedToUser(int LeaveID, string Code, string Status, int LoginEmployeeID)
        {
            StringBuilder htmlBody = new StringBuilder();
            StringBuilder htmlBody_Service = new StringBuilder();

            //htmlBody_Service.Append("<div style='background-color:#0077b5; width:100%; height:50px; vertical-align:center; text-align:center;'>Infinity IPS</div>");
            htmlBody_Service.Append("<div style = \"margin-right:20px; font-family:'Bookman Old Style'; font-size:14px; border:Solid 1px #a9d794; border-radius: 20px 20px 0px 0px; padding:20px 20px 20px 20px;\" > ");
            htmlBody_Service.Append("<div style='background-color:#a9d794;  height:50px; vertical-align:center; text-align:center;'><span style='font-family:''Bookman Old Style''; font-weight:bold; font-size:28px; font-style:italic;'>Infinity IPS</span></div><hr />");
            htmlBody_Service.Append("<table cellspacing='7px' cellpadding='3px' class='table' style=\"font-family:'Bookman Old Style'; font-size:14px; border-collapse: collapse;\">");
            htmlBody_Service.Append("<tr><td align=\"left\"><b>Dear Sir,</b></td></tr></table>");
            htmlBody_Service.Append("<table cellspacing='7px' cellpadding='3px' width='700px' style=\"font-family:'Bookman Old Style'; font-size:14px; padding:.625rem .625rem;\"><tr>");
            htmlBody_Service.Append("<td align=\"left\">" + "You have received auto generated notification from system.</td></tr></table><br />");
            htmlBody_Service.Append("<table border='1' cellspacing='7px' cellpadding='3px' width='700px' style=\"font-family:'Bookman Old Style'; font-size:14px; border-collapse: collapse; border-color: #31374a; border-bottom-width:1px; padding:.625rem .625rem;\"><tr>");
            htmlBody_Service.Append("<td align=\"left\" width=\"250px\">Name :<br /></td><td align=\"bottom\">BOE : Subhash Bhimrao Deshmukh<br /></td></tr>");
            htmlBody_Service.Append("<tr><td align=\"left\">Reporting Manager :<br /></td><td align=\"bottom\">VMR : Vinod Ramesh Rane<br /></td></tr>");
            htmlBody_Service.Append("<tr><td align=\"left\" >Leave Type :<br /></td><td>Other<br /></td></tr>");
            htmlBody_Service.Append("<tr><td align=\"left\">No Of Days :<br /></td><td align=\"bottom\">1<br /></td></tr>");
            htmlBody_Service.Append("<tr><td align=\"left\">From Date :<br /></td><td>24-Jan-2024<br /></td></tr>");
            htmlBody_Service.Append("<tr><td align=\"left\">To Date :<br /></td><td>24-Jan-2024<br /></td></tr>");
            htmlBody_Service.Append("<tr><td align=\"left\">Reason :<br /></td><td>I forgot to log out yesterday, so please update my log-out time for January 11, 2024<br /></td></tr>");
            htmlBody_Service.Append("<tr><td align=\"left\">Status:<br /></td><td>Approved<br /></td></tr>");
            htmlBody_Service.Append("<tr><td align=\"left\">Status Updated By :<br /></td>PPL : Prashant Mohan Patil<br /><td></td></tr>");
            htmlBody_Service.Append("<tr><td align=\"left\">Remark :<br /></td><td>User forgot to do the logout<br /></td></tr></table>");
            htmlBody_Service.Append("<br /><br /><table cellspacing='7px' cellpadding='3px' width='700px' class='table' style='font-family: ''Bookman Old Style''; font-size: 14px; border-collapse: collapse;'><tr><td align=\"left\">Thanks,<br />Infinity HRMS</td></tr></table></div></div>");

            sendMail("", "Infinity IPS - Test Email Subject", htmlBody_Service);



        }
    }
}