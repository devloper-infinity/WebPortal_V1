using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class EmployeeVerificationForm : System.Web.UI.Page
    {
        private const string VerificationUploadPathKey = "EmployeeVerificationUploadPath";
        private const string VerificationUploadNameKey = "EmployeeVerificationUploadName";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Files.Count == 0)
            {
                return;
            }

            HttpPostedFile file = Request.Files["ExEmpForm_attachment"] ?? Request.Files[0];
            if (file == null || file.ContentLength == 0)
            {
                return;
            }

            string originalFileName = Path.GetFileName(file.FileName);
            string tempFolder = Server.MapPath(@"~\TempFiles");
            Directory.CreateDirectory(tempFolder);

            string tempFileName = Guid.NewGuid().ToString("N") + Path.GetExtension(originalFileName);
            string tempFilePath = Path.Combine(tempFolder, tempFileName);
            file.SaveAs(tempFilePath);

            Session[VerificationUploadPathKey] = tempFilePath;
            Session[VerificationUploadNameKey] = originalFileName;
        }

        [WebMethod]
        public static string BindExistingInformation(int EmployeeID)
        {
            DataTable dt1 = new bllMaster().GetEmployeeVerificationData(EmployeeID);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetUserName(int EmployeeID)
        {
            DataTable dt1 = new bllLogin().GetUserInformation(EmployeeID);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod(EnableSession = true)]
        public static int InsertVerificationInformation(int EmployeeID, string CandidateName, string EmployeeCode, string Salary, string CompanyName, string EmployeePeriod, string Designation, string ReportingManagerName,
            string ReportingManagerDesignation, string ReportingManagerContact, string HRName, string HRContact, string ReasonforLeaving, string ExitFormality, string Eligibilitytorehire, string VerifiedBy, string ReceiverEmail, string DutiesAndResponsibilitiesl)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            string attachmentPath = "";

            htParam["EmployeeID"] = EmployeeID;
            htParam["CandidateName"] = CandidateName;
            htParam["EmployeeCode"] = EmployeeCode;
            htParam["Salary"] = Salary;
            htParam["CompanyName"] = CompanyName;
            htParam["EmploymentPeriod"] = EmployeePeriod;
            htParam["LastDesignation"] = Designation;
            htParam["ReportingPersonName"] = ReportingManagerName;
            htParam["ReportingPersonDesignation"] = ReportingManagerDesignation;
            htParam["ReportingPersonContact"] = ReportingManagerContact;
            htParam["ReasonForLiving"] = ReasonforLeaving;
            htParam["PendingExitFormalities"] = ExitFormality;
            htParam["EligibilityToRehire"] = Eligibilitytorehire;
            htParam["VerifiedBy"] = VerifiedBy;
            htParam["HRName"] = HRName;
            htParam["VerifiedFromName"] = HRName;
            htParam["HRContact"] = HRContact;
            htParam["DutiesAndResponsibilitiesl"] = DutiesAndResponsibilitiesl;

            HttpSessionState session = HttpContext.Current.Session;
            string uploadedFilePath = Convert.ToString(session[VerificationUploadPathKey]);
            string uploadedFileName = Path.GetFileName(Convert.ToString(session[VerificationUploadNameKey]));

            if (!string.IsNullOrWhiteSpace(uploadedFilePath))
            {
                if (!File.Exists(uploadedFilePath))
                {
                    throw new FileNotFoundException("The uploaded attachment could not be found. Please select the file again.");
                }

                string folderPath = HttpContext.Current.Server.MapPath(@"~\EmployeeDocuments\EmploymentVerification");
                string employeeFolder = Path.Combine(folderPath, Convert.ToString(EmployeeID));
                Directory.CreateDirectory(employeeFolder);

                string storedFileName = Guid.NewGuid().ToString("N") + "_" + uploadedFileName;
                attachmentPath = Path.Combine(employeeFolder, storedFileName);
                File.Copy(uploadedFilePath, attachmentPath, false);
                htParam.Add("Attachment", attachmentPath);
            }
            else
            {
                htParam.Add("Attachment", "");
            }

            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = 10;// new bllMaster().InsertEmployeePreVerificationInfo(htParam);
           
            if (returnvalue > 0)
            {
                session.Remove(VerificationUploadPathKey);
                session.Remove(VerificationUploadNameKey);
                try
                {
                    if (!string.IsNullOrWhiteSpace(uploadedFilePath) && File.Exists(uploadedFilePath))
                    {
                        File.Delete(uploadedFilePath);
                    }
                }
                catch (IOException) { }
                catch (UnauthorizedAccessException) { }

                int returnemil = 0;
                try
                {
                    returnemil = SendVerificationEmailInternal(EmployeeID, CandidateName, EmployeeCode, Salary, CompanyName, EmployeePeriod, Designation, ReportingManagerName, ReportingManagerDesignation, ReportingManagerContact, HRName, HRContact, ReasonforLeaving, ExitFormality, Eligibilitytorehire, VerifiedBy, ReceiverEmail, attachmentPath);
                }
                catch (Exception) { }

                if (returnemil > 0)
                {
                    int VerificationID = new bllMaster().GetVerificationIDFromEmployeeID(EmployeeID);
                    if (VerificationID > 0)
                    {
                        Hashtable htVerify = new Hashtable();
                        htVerify.Add("VerificationID", Convert.ToInt32(VerificationID));
                        htVerify.Add("SenderID", ReceiverEmail);
                        htVerify.Add("MailSendBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        int ReturnValue = new bllMaster().InsertEmployeeVerificationEmailDetails(htVerify);
                    }
                }
            }
            return returnvalue;
        }

        [WebMethod]
        public static int SendVerificationEmail(int EmployeeID, string CandidateName, string EmployeeCode, string Salary, string CompanyName, string EmployeePeriod, string Designation, string ReportingManagerName,
            string ReportingManagerDesignation, string ReportingManagerContact, string HRName, string HRContact, string ReasonforLeaving, string ExitFormality, string Eligibilitytorehire, string VerifiedBy, string ReceiverEmail)
        {
            return SendVerificationEmailInternal(EmployeeID, CandidateName, EmployeeCode, Salary, CompanyName, EmployeePeriod, Designation, ReportingManagerName,
                ReportingManagerDesignation, ReportingManagerContact, HRName, HRContact, ReasonforLeaving, ExitFormality, Eligibilitytorehire, VerifiedBy, ReceiverEmail, "");
        }

        private static int SendVerificationEmailInternal(int EmployeeID, string CandidateName, string EmployeeCode, string Salary, string CompanyName, string EmployeePeriod, string Designation, string ReportingManagerName,
            string ReportingManagerDesignation, string ReportingManagerContact, string HRName, string HRContact, string ReasonforLeaving, string ExitFormality, string Eligibilitytorehire, string VerifiedBy, string ReceiverEmail, string attachmentPath)
        {
            int returnvalue = 0;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            head.Append("<!DOCTYPE html><html><head>" +
                "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />" +
                "<meta name=\"x-apple-disable-message-reformatting\" />" +
                "<title>Employment Verification Request</title>" +
                "<style type=\"text/css\">" +
                "body,table,td,p,a{font-family:Arial,Helvetica,sans-serif;}" +
                "table,td{mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;}" +
                "@media only screen and (max-width:680px){" +
                ".email-container{width:100% !important;}" +
                ".mobile-padding{padding-left:20px !important;padding-right:20px !important;}" +
                ".verification-cell{padding:10px 8px !important;font-size:11px !important;}" +
                ".email-title{font-size:24px !important;line-height:30px !important;}" +
                "}" +
                "</style></head>" +
                "<body style=\"margin:0;padding:0;background-color:#eef2f7;color:#1f2937;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;\">" +
                "<div style=\"display:none;font-size:1px;color:#eef2f7;line-height:1px;max-height:0;max-width:0;opacity:0;overflow:hidden;mso-hide:all;\">" +
                "Employment verification request for " + Convert.ToString(CandidateName) + "." +
                "</div>");

            body.Append("<table role=\"presentation\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"width:100%;background-color:#eef2f7;\">" +
                "<tr><td align=\"center\" style=\"padding:32px 12px;\">" +
                "<!--[if mso]><table role=\"presentation\" width=\"680\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><td><![endif]-->" +
                "<table role=\"presentation\" class=\"email-container\" width=\"680\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"width:100%;max-width:680px;background-color:#ffffff;border:1px solid #dbe3ee;\">" +
                "<tr><td style=\"height:6px;background-color:#22b8cf;font-size:0;line-height:0;\">&nbsp;</td></tr>" +
                "<tr><td class=\"mobile-padding\" style=\"padding:34px 38px 30px;background-color:#123a63;\">" +
                "<table role=\"presentation\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">" +
                "<tr><td style=\"padding:0 0 16px;color:#a9dded;font-size:11px;font-weight:bold;line-height:16px;letter-spacing:1.4px;text-transform:uppercase;\">Infinity Data Technologies Pvt. Ltd.</td></tr>" +
                "<tr><td class=\"email-title\" style=\"padding:0;color:#ffffff;font-size:28px;font-weight:bold;line-height:34px;\">Employment Verification Request</td></tr>" +
                "<tr><td style=\"padding:12px 0 0;color:#d6e4f0;font-size:14px;line-height:21px;\">Previous employment details for <strong style=\"color:#ffffff;\">" + Convert.ToString(CandidateName) + "</strong></td></tr>" +
                "</table></td></tr>" +
                "<tr><td class=\"mobile-padding\" style=\"padding:34px 38px 12px;\">" +
                "<p style=\"margin:0 0 18px;color:#172033;font-size:15px;font-weight:bold;line-height:23px;\">Dear HR Team,</p>" +
                "<p style=\"margin:0 0 16px;color:#4b5563;font-size:14px;line-height:23px;\">Greetings from <strong style=\"color:#172033;\">Infinity Data Technologies Pvt. Ltd.</strong> We hope you are doing well.</p>" +
                "<p style=\"margin:0 0 16px;color:#4b5563;font-size:14px;line-height:23px;\">As part of our joining process, we carry out a reference check with a candidate's previous employer. Your former employee <strong style=\"color:#172033;\">\"" + Convert.ToString(CandidateName) + "\"</strong> has provided the information listed below.</p>" +
                "<table role=\"presentation\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"width:100%;margin:24px 0;background-color:#eff8fc;border-left:4px solid #22b8cf;\">" +
                "<tr><td style=\"padding:18px 20px;\">" +
                "<p style=\"margin:0 0 5px;color:#123a63;font-size:13px;font-weight:bold;line-height:19px;text-transform:uppercase;letter-spacing:.5px;\">Action requested</p>" +
                "<p style=\"margin:0;color:#40566d;font-size:13px;line-height:21px;\">Please verify the details and enter your remarks in the <strong>Details Provided By Company</strong> column. Your response will help us complete the candidate's onboarding process.</p>" +
                "</td></tr></table>" +
                "</td></tr>" +
                "<tr><td class=\"mobile-padding\" style=\"padding:14px 38px 34px;\">" +
                "<table role=\"presentation\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"width:100%;border:1px solid #cfd9e5;table-layout:fixed;\">" +
                "<tr>" +
                "<td class=\"verification-cell\" width=\"34%\" valign=\"middle\" style=\"padding:13px 11px;background-color:#123a63;border-right:1px solid #315a80;color:#ffffff;font-size:12px;font-weight:bold;line-height:17px;text-align:left;\">Particulars</td>" +
                "<td class=\"verification-cell\" width=\"33%\" valign=\"middle\" style=\"padding:13px 11px;background-color:#123a63;border-right:1px solid #315a80;color:#ffffff;font-size:12px;font-weight:bold;line-height:17px;text-align:left;\">Details Provided By Candidate</td>" +
                "<td class=\"verification-cell\" width=\"33%\" valign=\"middle\" style=\"padding:13px 11px;background-color:#123a63;color:#ffffff;font-size:12px;font-weight:bold;line-height:17px;text-align:left;\">Details Provided By Company</td>" +
                "</tr>");

            AppendVerificationRow(body, "Name of Organization:", Convert.ToString(CompanyName));
            AppendVerificationRow(body, "Employee ID/Code:", Convert.ToString(EmployeeCode));
            AppendVerificationRow(body, "Designation:", Convert.ToString(Designation));
            AppendVerificationRow(body, "Period of Employment:", Convert.ToString(EmployeePeriod));
            AppendVerificationRow(body, "Salary:", Convert.ToString(Salary));
            AppendVerificationRow(body, "Reporting Manager’s Name:", Convert.ToString(ReportingManagerName));
            AppendVerificationRow(body, "Reporting Manager’s Designation:", Convert.ToString(ReportingManagerDesignation));
            AppendVerificationRow(body, "Contact No. &amp; E-Mail - Reporting Manager:", Convert.ToString(ReportingManagerContact));
            AppendVerificationRow(body, "Name of HR:", Convert.ToString(HRName));
            AppendVerificationRow(body, "Contact No. &amp; E-Mail - HR:", Convert.ToString(HRContact));
            AppendVerificationRow(body, "Reason for Leaving the Organization:", Convert.ToString(ReasonforLeaving));
            AppendVerificationRow(body, "Any Exit Formalities Pending (YES/NO):", Convert.ToString(ExitFormality));
            AppendVerificationRow(body, "Eligible for rehire (Based on job performance)<br />(If No, please Specify Reason):", Convert.ToString(Eligibilitytorehire));
            AppendVerificationRow(body, "Verified by (Name &amp; Designation):", Convert.ToString(VerifiedBy));

            body.Append("</table>" +
                "</td></tr>" +
                "<tr><td class=\"mobile-padding\" style=\"padding:0 38px 34px;\">" +
                "<p style=\"margin:0 0 8px;color:#4b5563;font-size:14px;line-height:23px;\">It would be very helpful if you could confirm the details claimed by the candidate. Your cooperation is highly appreciated.</p>" +
                "<p style=\"margin:0 0 22px;color:#4b5563;font-size:14px;line-height:23px;\">Have a great day ahead.</p>" +
                "<p style=\"margin:0;color:#172033;font-size:14px;line-height:22px;\">Regards,<br /><strong>HR Team</strong><br />Infinity Data Technologies Pvt. Ltd.</p>" +
                "</td></tr>" +
                "<tr><td class=\"mobile-padding\" style=\"padding:20px 38px;background-color:#f5f7fa;border-top:1px solid #e1e7ef;\">" +
                "<p style=\"margin:0;color:#6b7280;font-size:11px;line-height:18px;text-align:center;\">This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</p>" +
                "</td></tr>" +
                "</table>" +
                "<!--[if mso]></td></tr></table><![endif]-->" +
                "</td></tr></table>");

            footer.Append("</body></html>");

            string Pass = new bllMaster().GetPassword("Verification");

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("verification@infinityinternationals.us", "Employment Verification", System.Text.Encoding.UTF8);
            // mail.To.Add("n.nilkanth@infinityinternationals.us,b.shubhangi@infinityinternationals.us"); //("n.nilkanth@infinityinternationals.us");
            // mail.CC.Add("n.nilkanth@infinityinternationals.us");//,b.shubhangi@infinityinternationals.us");

            ReceiverEmail = "b.shubhangi@infinityinternationals.us";

            mail.To.Add(ReceiverEmail);
            //mail.CC.Add("k.sagar@infinity-data.com,g.trupti@infinityinternationals.us");
            mail.Bcc.Add("n.nilkanth@infinity-data.com,b.shubhangi@infinityinternationals.us");
            mail.Subject = "Ex Employer Verification – Infinity Data Technologies Pvt. Ltd. – " + CandidateName;
            mail.Body = head.ToString() + body.ToString() + footer.ToString();
            mail.IsBodyHtml = true;

            if (!string.IsNullOrWhiteSpace(attachmentPath) && File.Exists(attachmentPath))
            {
                mail.Attachments.Add(new Attachment(attachmentPath));
            }

            mail.Priority = System.Net.Mail.MailPriority.High;
            SmtpClient client = new SmtpClient();
            client.Credentials = new System.Net.NetworkCredential("verification@infinityinternationals.us", Pass);
            client.Host = "smtp3.netcore.co.in";

            try
            {
                client.Send(mail);
                returnvalue = 1;
            }

            catch (Exception ex) { return 0; }

            return returnvalue;
        }

        private static void AppendVerificationRow(StringBuilder body, string label, string value)
        {
            body.Append("<tr>" +
                "<td class=\"verification-cell\" width=\"34%\" valign=\"top\" style=\"padding:12px 11px;background-color:#f7f9fc;border-top:1px solid #dbe3ec;border-right:1px solid #dbe3ec;color:#25364a;font-size:12px;font-weight:bold;line-height:18px;word-wrap:break-word;\">" + label + "</td>" +
                "<td class=\"verification-cell\" width=\"33%\" valign=\"top\" style=\"padding:12px 11px;background-color:#ffffff;border-top:1px solid #dbe3ec;border-right:1px solid #dbe3ec;color:#374151;font-size:12px;line-height:18px;word-wrap:break-word;\">" + value + " </td>" +
                "<td class=\"verification-cell\" width=\"33%\" valign=\"top\" style=\"padding:12px 11px;background-color:#ffffff;border-top:1px solid #dbe3ec;color:#6b7280;font-size:12px;font-weight:bold;line-height:18px;word-wrap:break-word;\"> - </td>" +
                "</tr>");
        }
    }
}
