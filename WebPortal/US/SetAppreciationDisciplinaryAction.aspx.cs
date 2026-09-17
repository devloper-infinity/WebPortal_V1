using Microsoft.Office.Interop.Word;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using DataTable = System.Data.DataTable;
using MailMessage = System.Net.Mail.MailMessage;
using WebPortal.App_Code;

namespace WebPortal.Admin
{
    public partial class SetAppreciationDisciplinaryAction : System.Web.UI.Page
    {
        static string CurrentUserName;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserName = EmployeeInfo.Current.FirstName + " " + EmployeeInfo.Current.lastName;
            lbl_loginEmpID.InnerText = EmployeeInfo.Current.EmployeeID.ToString();
            hdnLoginEmpID.Value = EmployeeInfo.Current.EmployeeID.ToString();
        }

        [WebMethod]
        public static string GetAllUsers()
        {
            DataTable dt1 = new bllMaster().GetAllUsersUnderPM(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetAllAppreciationWarningsRecords()
        {
            DataTable dt1 = new bllMaster().GetAllApprerciationandWarningReport();
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
        public static string GetAllAppreciationWarningsByType(int EmployeeID, string Type)
        {
            DataTable dt1 = new bllMaster().GetAllApprerciationandWarningByType(EmployeeID, Type);


            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetUserInformation(string Code)
        {
            DataTable dt1 = new bllLogin().GetUserInformation_ByCode(Code);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetTypewiseTitle(string Type)
        {
            DataTable dt1 = new bllMaster().GetAprreciationTitle(Type);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetTypeandTitlewiseDescription(string Type, string Title)
        {
            DataTable dt1 = new bllMaster().GetAprreciationDescription(Type, Title);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static int SetAppreciationDescAction(string Code, int ApprDescId, string Editor, string Title, string Type, string Period)
        {
            int returnvalue = 0;
            string Subject = "";
            string count = "";
            string Description = "";
            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt = new bllMaster().GetAppreciationDisplinaryStatus(EmployeeID);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    if (dt.Rows.Count == 0)
                        count = "1st";
                    else if (dt.Rows.Count == 1)
                        count = "2nd";
                    else if (dt.Rows.Count == 2)
                        count = "3rd";
                    else
                        count = (dt.Rows.Count + 1) + "th";
                }
                else
                    count = "1st";
            }
            else
                count = "1st";

            if (Type == "Appreciation")
                Subject = Type + " - " + Title;
            else if (Type == "DisciplinaryAction")
                Subject = count + " Warning Letter - " + Title;
               // Subject = "1st Warning Letter - " + Title;
            else if (Type == "PerformanceImprovementPlan")
                Subject = count + " PIP - " + Title;

            string str = Editor;
            string str1 = HttpContext.Current.Server.HtmlEncode(str);
            string str2 = HttpContext.Current.Server.HtmlDecode(str);
            string s = str2;
            if (s.Contains("<p>") || s.Contains("</p>") || s.Contains(" "))
            {
                Description = s.Replace("<p>", "");
                Description = Description.Replace("</p>", " ");
                Description = Description.Replace(" ", " ");
            }
            else
            {
                Description = s;
            }
            returnvalue =  new bllMaster().InsertSetAppreciationDisplinaryAction(ApprDescId, EmployeeID, Type, Title, Description, Editor, Subject, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), Period);
            if (returnvalue > 0)
            {
                SendAppreciationEmail(Subject, EmployeeID, Description, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            }
            return returnvalue;
        }

        public static void SendAppreciationEmail(string Subject, int ReceipentID, string Description, int AddedBy)
        {
            string To = "";
            string CC = "";
            string BCC = "";
            string MailSubject = Subject;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
            string EmailType = "SetAppreciationDisplinaryAction";
            DataTable dt = new bllLogin().GetUserInformation(ReceipentID);
            DataTable dtPM = new bllMaster().ProjectManagerRelatedToDepartment(ReceipentID);
            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(ReceipentID, "SetAppreciationDisplinaryAction");

            if (dt.Rows.Count > 0)
            {
                if (dtPM != null)
                {
                    if (dtPM.Rows.Count > 0)
                    {
                        To = Convert.ToString(dtEmail.Rows[0]["ToApprDesp"]);
                        CC = Convert.ToString(dtEmail.Rows[0]["CCAtt"]);
                        BCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                        DataTable dtAdded = new bllLogin().GetUserInformation(AddedBy);
                        DataTable dtEmailConfig = new bllMaster().getEmailConfigrationInfo(EmailType);


                        head.Append("<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">" +
                            "<style>body,table,td{font-family:Arial,'Helvetica Neue',sans-serif!important;text-align:left}.email-shell{width:100%!important;max-width:680px!important}.detail-label{width:34%!important}@media only screen and (max-width:620px){.outer-pad{padding:10px!important}.content-pad{padding:20px 16px!important}.detail-label{width:38%!important}}</style>" +
                            "</head><body style=\"margin:0;padding:0;background-color:#f1f5f9;color:#1e293b;text-align:left;\">");
                        body.Append("<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;background-color:#f1f5f9;text-align:left;\"><tr><td class=\"outer-pad\" align=\"left\" style=\"padding:20px 16px;text-align:left;\">" +
                            "<table role=\"presentation\" class=\"email-shell\" width=\"680\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;max-width:680px;background-color:#ffffff;border:1px solid #e2e8f0;border-radius:16px;overflow:hidden;\">" +
                            "<tr><td bgcolor=\"#173b70\" style=\"padding:15px 24px;background-color:#173b70;border-bottom:3px solid #2f80ed;text-align:left;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;background-color:#173b70;\"><tr><td bgcolor=\"#173b70\" style=\"color:#bfdbfe;font-size:10px;font-weight:700;line-height:14px;letter-spacing:1.2px;text-transform:uppercase;mso-line-height-rule:exactly;\"></td></tr><tr><td height=\"4\" bgcolor=\"#173b70\" style=\"height:4px;font-size:0;line-height:4px;mso-line-height-rule:exactly;\">&nbsp;</td></tr><tr><td bgcolor=\"#173b70\" style=\"color:#ffffff;font-size:22px;font-weight:700;line-height:27px;mso-line-height-rule:exactly;\">" + Convert.ToString(MailSubject) + "</td></tr></table></td></tr>" +
                            "<tr><td class=\"content-pad\" style=\"padding:24px;text-align:left;\">");
                        body.Append("<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;\"><tr><td style=\"padding:0 0 8px;color:#0f172a;font-size:15px;font-weight:700;line-height:20px;\">Employee Details</td></tr></table>" +
                            "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;border:1px solid #e2e8f0;border-radius:10px;border-collapse:separate;overflow:hidden;\">" +
                            "<tr><td class=\"detail-label\" style=\"width:34%;padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#64748b;font-size:12px;font-weight:700;line-height:18px;vertical-align:top;\"><b>Code:</b></td><td style=\"padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#1e293b;font-size:13px;font-weight:600;line-height:18px;vertical-align:top;\">" + Convert.ToString(dt.Rows[0]["Code"]) + "</td></tr>");
                        body.Append("<tr><td class=\"detail-label\" style=\"width:34%;padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#64748b;font-size:12px;font-weight:700;line-height:18px;vertical-align:top;\"><b>Name:</b></td><td style=\"padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#1e293b;font-size:13px;font-weight:600;line-height:18px;vertical-align:top;\">" + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["lastName"]) + "</td></tr>");
                        body.Append("<tr><td class=\"detail-label\" style=\"width:34%;padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#64748b;font-size:12px;font-weight:700;line-height:18px;vertical-align:top;\"><b>Joining Date:</b></td><td style=\"padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#1e293b;font-size:13px;font-weight:600;line-height:18px;vertical-align:top;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>");
                        body.Append("<tr><td class=\"detail-label\" style=\"width:34%;padding:11px 14px;color:#64748b;font-size:12px;font-weight:700;line-height:18px;vertical-align:top;\"><b>Location:</b></td><td style=\"padding:11px 14px;color:#1e293b;font-size:13px;font-weight:600;line-height:18px;vertical-align:top;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr></table>");
                        body.Append("<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;\"><tr><td height=\"22\" style=\"height:22px;font-size:0;line-height:22px;\">&nbsp;</td></tr>" +
                            "<tr><td style=\"padding:0;color:#1e293b;font-size:14px;font-weight:700;line-height:21px;text-align:left;\"><b>Dear " + Convert.ToString(dt.Rows[0]["FirstName"]) + "<br /></b></td></tr>" +
                            "<tr><td height=\"14\" style=\"height:14px;font-size:0;line-height:14px;\">&nbsp;</td></tr>" +
                            "<tr><td style=\"padding:0;color:#1e293b;font-size:14px;line-height:22px;text-align:left;\">" + Convert.ToString(Description) + "</td></tr>" +
                            "<tr><td style=\"padding:26px 0 0;color:#475569;font-size:13px;line-height:20px;text-align:left;\">Thanks,<br /><strong style=\"color:#0f172a;\">" + CurrentUserName + "</strong><br />" + Convert.ToString(dt.Rows[0]["CompanyName"]) + "</td></tr></table>");
                        footer.Append("</td></tr><tr><td style=\"padding:18px 32px;background-color:#f8fafc;border-top:1px solid #e2e8f0;color:#94a3b8;font-size:11px;line-height:17px;text-align:center;\">This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                            "</table></td></tr></table></body></html>");

                        string Pass = new bllMaster().GetPassword("ackdata");

                        MailMessage mail = new MailMessage();
                        mail.From = new MailAddress("ack@infinity-data.com", "Infinity Auto Notifications", System.Text.Encoding.UTF8);
                        //mail.To.Add("n.nilkanth@infinityinternationals.us");
                        mail.To.Add(To);
                        mail.CC.Add(CC);
                        mail.Bcc.Add(BCC);
                        mail.Subject = Subject;
                        mail.Body = head.ToString() + body.ToString() + footer.ToString();
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
                        }
                        catch { }
                    }
                }
            }
        }
    }
}
