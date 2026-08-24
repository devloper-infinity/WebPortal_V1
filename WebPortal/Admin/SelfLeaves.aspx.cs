using Microsoft.Office.Interop.Word;
using System;
using System.Collections;
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
using DataTable = System.Data.DataTable;
using MailMessage = System.Net.Mail.MailMessage;

namespace WebPortal.Admin
{
    public partial class SelfLeaves : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private static int GetCurrentEmployeeId()
        {
            return int.Parse(HttpContext.Current.User.Identity.Name.ToString());
        }

        private static string GetCurrentUserCode()
        {
            return new bllMaster().GetCodeFromEmployeeId(GetCurrentEmployeeId());
        }

        private static string EncodeEmailValue(object value)
        {
            return HttpUtility.HtmlEncode(Convert.ToString(value));
        }

        private static string FormatEmailDate(string value)
        {
            DateTime date;
            return DateTime.TryParse(value, out date) ? date.ToString("dd MMM yyyy") : EncodeEmailValue(value);
        }

        private static void AppendEmailDetailRow(StringBuilder email, string label, object value)
        {
            email.AppendFormat(
                "<tr>" +
                "<td class=\"detail-label\" style=\"width:34%;padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#64748b;font-size:12px;font-weight:700;line-height:18px;vertical-align:top;\">{0}</td>" +
                "<td style=\"padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#1e293b;font-size:13px;font-weight:600;line-height:18px;vertical-align:top;\">{1}</td>" +
                "</tr>",
                EncodeEmailValue(label), EncodeEmailValue(value));
        }

        [WebMethod]
        public static string BindInformation()
        {
            DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserleavesbyCode()
        {
            DataTable dt1 = new bllMaster().GetUserLeavesbyCode(GetCurrentUserCode());
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
        public static string GetLeaveDetails()
        {
            int employeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            string code = new bllMaster().GetCodeFromEmployeeId(employeeId);
            DataTable dt1 = new bllMaster().GetLeaveDetails(code);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
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
        public static int InsertLeave(string LeaveType, int ForDays, string FromDate, string ToDate, string Reason, string PaidStatus)
        {
            int returnvalue = 0;
            int employeeId = GetCurrentEmployeeId();
            string userCode = GetCurrentUserCode();

            DataTable userInfo = new bllLogin().GetUserInformation(employeeId);
            bool paidLeaveEligible = false;
            if (userInfo != null && userInfo.Rows.Count > 0)
            {
                string domain = Convert.ToString(userInfo.Rows[0]["Domain"]);
                string workingBranch = Convert.ToString(userInfo.Rows[0]["WorkingBranch"]);
                paidLeaveEligible = domain == "9" || workingBranch == "11" || workingBranch == "3";
            }

            PaidStatus = paidLeaveEligible ? "Paid" : "Unpaid";

            if (PaidStatus == "Paid")
            {
                DataTable leaveDetails = new bllMaster().GetLeaveDetails(userCode);
                decimal pendingLeaves = 0;
                if (leaveDetails != null && leaveDetails.Rows.Count > 0)
                {
                    decimal.TryParse(Convert.ToString(leaveDetails.Rows[0]["PendingLeaves"]), out pendingLeaves);
                }

                if (pendingLeaves < ForDays)
                {
                    return -2;
                }
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("Code", userCode);
            htParam.Add("LeaveType", LeaveType);
            htParam.Add("ForDays", ForDays);
            htParam.Add("LeaveFrom", Convert.ToDateTime(FromDate).ToString("dd-MMM-yyyy"));
            htParam.Add("LeaveTo", Convert.ToDateTime(ToDate).ToString("dd-MMM-yyyy"));
            htParam.Add("ReasonForLeave", Reason);
            htParam.Add("AddedBy", employeeId);

            returnvalue =  new bllMaster().InsertLeave(htParam);

            if (returnvalue > 0)
            {
                if (PaidStatus == "Paid")
                {
                    new bllMaster().InsertPaidLeave(htParam, returnvalue);
                }
                UserLeaveEmail(userCode, ForDays, FromDate, ToDate, Reason, LeaveType, PaidStatus);
            }

            return returnvalue;
        }

        [WebMethod]
        public static int UserLeaveEmail(string Code, int Days, string FromDate, string ToDate, string Reason, string LeaveType, string PaidStatus)
        {
            int returnvalue = 0;
            string To = "";
            string CC = "";
            string BCC = "";

            StringBuilder body = new StringBuilder();
            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt = new bllLogin().GetUserInformation(EmployeeID);
            DataTable dtPM = new bllMaster().ProjectManagerRelatedToDepartment(EmployeeID);
            string LocationHead = "";
            string DomainHead = "";
            string PrimaryProject = "";
            string PrimaryProcess = "";
            string FirstName = "";

            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(EmployeeID, "Attendance Correction");
            if (dtEmail.Rows.Count > 0)
            {
                LocationHead = Convert.ToString(dtEmail.Rows[0]["LocationHeadName"]);
                DomainHead = Convert.ToString(dtEmail.Rows[0]["DomainHeadName"]);

                To = Convert.ToString(dtEmail.Rows[0]["ToAttendance"]);
                CC = Convert.ToString(dtEmail.Rows[0]["CCAtt"]);
                BCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);
                FirstName = Convert.ToString(dtEmail.Rows[0]["FirstName"]);
            }

            if (LocationHead == "")
                LocationHead = DomainHead;

            DataTable dtPro = new bllMaster().GetPrimaryProject(EmployeeID);
            if (dtPro != null)
            {
                if (dtPro.Rows.Count > 0)
                {
                    PrimaryProject = Convert.ToString(dtPro.Rows[0]["Project"]);
                    PrimaryProcess = Convert.ToString(dtPro.Rows[0]["Process"]);
                }
            }
            if (dtPM != null)
            {
                if (dtPM.Rows.Count > 0)
                {
                    string employeeName = EncodeEmailValue(Code) + " &middot; " + EncodeEmailValue(dt.Rows[0]["FullName"]);
                    string leaveType = EncodeEmailValue(LeaveType);
                    string leaveDays = EncodeEmailValue(Days) + (Days == 1 ? " day" : " days");
                    string fromDate = FormatEmailDate(FromDate);
                    string toDate = FormatEmailDate(ToDate);
                    string reason = EncodeEmailValue(Reason).Replace("\r\n", "<br />").Replace("\n", "<br />");

                    body.Append("<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">" +
                        "<style>body,table,td{font-family:Arial,'Helvetica Neue',sans-serif!important;text-align:left}@media only screen and (max-width:620px){.email-shell{width:100%!important}.outer-pad{padding:10px!important}.content-pad{padding:20px 16px!important}.summary-cell{display:block!important;width:100%!important;box-sizing:border-box!important;border-right:0!important}.summary-divider{border-top:1px solid #e2e8f0!important}.detail-label{width:38%!important}}</style>" +
                        "</head><body style=\"margin:0;padding:0;background-color:#f1f5f9;color:#1e293b;text-align:left;\">" +
                        "<div style=\"display:none;max-height:0;overflow:hidden;opacity:0;color:transparent;\">New leave request from " + employeeName + "</div>" +
                        "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;background-color:#f1f5f9;text-align:left;\"><tr><td class=\"outer-pad\" align=\"left\" style=\"padding:20px 16px;text-align:left;\">" +
                        "<table role=\"presentation\" class=\"email-shell\" width=\"680\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;max-width:680px;background-color:#ffffff;border:1px solid #e2e8f0;border-radius:16px;overflow:hidden;\">" +
                        "<tr><td bgcolor=\"#173b70\" style=\"padding:15px 24px;background-color:#173b70;border-bottom:3px solid #2f80ed;text-align:left;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;background-color:#173b70;\"><tr><td bgcolor=\"#173b70\" style=\"color:#bfdbfe;font-size:10px;font-weight:700;line-height:14px;letter-spacing:1.2px;text-transform:uppercase;mso-line-height-rule:exactly;\">INFINITY IPS &nbsp;/&nbsp; HRMS</td></tr><tr><td height=\"4\" bgcolor=\"#173b70\" style=\"height:4px;font-size:0;line-height:4px;mso-line-height-rule:exactly;\">&nbsp;</td></tr><tr><td bgcolor=\"#173b70\" style=\"color:#ffffff;font-size:22px;font-weight:700;line-height:27px;mso-line-height-rule:exactly;\">Leave request</td></tr></table></td></tr>" +
                        "<tr><td class=\"content-pad\" style=\"padding:24px;text-align:left;\">" +
                        "<p style=\"margin:0 0 8px;color:#0f172a;font-size:16px;font-weight:700;line-height:24px;\">Hello " + FirstName + ",</p>" +
                        "<p style=\"margin:0 0 24px;color:#475569;font-size:14px;line-height:22px;\">A new leave request has been submitted in HRMS. The key details are summarized below.</p>");

                    body.Append("<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;border:1px solid #cbd5e1;border-radius:10px;border-collapse:separate;overflow:hidden;\">" +
                        "<tr height=\"40\" style=\"height:40px;mso-height-source:exactly;\"><td colspan=\"2\" height=\"40\" bgcolor=\"#173b70\" style=\"height:40px;padding:0 14px;background-color:#173b70;color:#ffffff;font-size:14px;font-weight:700;line-height:40px;mso-line-height-rule:exactly;\">Leave Request Details</td></tr>" +
                        "<tr height=\"48\" style=\"height:48px;mso-height-source:exactly;\">" +
                        "<td class=\"summary-cell\" width=\"50%\" height=\"48\" valign=\"middle\" style=\"width:50%;height:48px;padding:0 14px!important;border-right:1px solid #e2e8f0;vertical-align:middle;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr><td height=\"13\" style=\"height:13px;color:#64748b;font-size:9px;font-weight:700;line-height:13px;letter-spacing:.7px;text-transform:uppercase;mso-line-height-rule:exactly;padding-left:5px;\">LEAVE TYPE</td></tr><tr><td height=\"19\" style=\"height:19px;color:#0f3d75;font-size:14px;font-weight:700;line-height:19px;mso-line-height-rule:exactly;padding-left:5px;\">" + leaveType + "</td></tr></table></td>" +
                        "<td class=\"summary-cell summary-divider\" width=\"50%\" height=\"48\" valign=\"middle\" style=\"width:50%;height:48px;padding:0 14px!important;vertical-align:middle;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr><td height=\"13\" style=\"height:13px;color:#64748b;font-size:9px;font-weight:700;line-height:13px;letter-spacing:.7px;text-transform:uppercase;mso-line-height-rule:exactly;padding-left:5px;\">DURATION</td></tr><tr><td height=\"19\" style=\"height:19px;color:#0f172a;font-size:14px;font-weight:700;line-height:19px;mso-line-height-rule:exactly;padding-left:5px;\">" + leaveDays + "</td></tr></table></td>" +
                        "</tr><tr height=\"48\" style=\"height:48px;mso-height-source:exactly;\">" +
                        "<td class=\"summary-cell summary-divider\" width=\"50%\" height=\"48\" valign=\"middle\" style=\"width:50%;height:48px;padding:0 14px!important;border-top:1px solid #e2e8f0;border-right:1px solid #e2e8f0;vertical-align:middle;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr><td height=\"13\" style=\"height:13px;color:#64748b;font-size:9px;font-weight:700;line-height:13px;letter-spacing:.7px;text-transform:uppercase;mso-line-height-rule:exactly;padding-left:5px;\">FROM DATE</td></tr><tr><td height=\"19\" style=\"height:19px;color:#0f172a;font-size:13px;font-weight:700;line-height:19px;mso-line-height-rule:exactly;padding-left:5px;\">" + fromDate + "</td></tr></table></td>" +
                        "<td class=\"summary-cell summary-divider\" width=\"50%\" height=\"48\" valign=\"middle\" style=\"width:50%;height:48px;padding:0 14px!important;border-top:1px solid #e2e8f0;vertical-align:middle;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr><td height=\"13\" style=\"height:13px;color:#64748b;font-size:9px;font-weight:700;line-height:13px;letter-spacing:.7px;text-transform:uppercase;mso-line-height-rule:exactly;padding-left:5px;\">TO DATE</td></tr><tr><td height=\"19\" style=\"height:19px;color:#0f172a;font-size:13px;font-weight:700;line-height:19px;mso-line-height-rule:exactly;padding-left:5px;\">" + toDate + "</td></tr></table></td>" +
                        "</tr></table>" +
                        "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;\"><tr><td height=\"18\" style=\"height:18px;font-size:0;line-height:18px;\">&nbsp;</td></tr><tr><td style=\"color:#0f172a;font-size:15px;font-weight:700;line-height:20px;\">Reason for Leave</td></tr><tr><td height=\"8\" style=\"height:8px;font-size:0;line-height:8px;\">&nbsp;</td></tr></table>" +
                        "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;background-color:#eff6ff;border:1px solid #bfdbfe;border-left:4px solid #2563eb;border-radius:8px;\"><tr><td style=\"padding:12px 14px;color:#1e3a5f;font-size:14px;line-height:22px;text-align:left;\">" + reason + "</td></tr></table>" +
                        "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;\"><tr><td height=\"18\" style=\"height:18px;font-size:0;line-height:18px;\">&nbsp;</td></tr><tr><td style=\"color:#0f172a;font-size:15px;font-weight:700;line-height:20px;\">Employee Information</td></tr><tr><td height=\"8\" style=\"height:8px;font-size:0;line-height:8px;\">&nbsp;</td></tr></table>" +
                        "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;border:1px solid #e2e8f0;border-radius:10px;border-collapse:separate;overflow:hidden;\">");

                    AppendEmailDetailRow(body, "Employee", Code + " · " + Convert.ToString(dt.Rows[0]["FullName"]));
                    AppendEmailDetailRow(body, "Joining date", dt.Rows[0]["JoiningDate"]);
                    AppendEmailDetailRow(body, "Job type", dt.Rows[0]["JobType"]);
                    AppendEmailDetailRow(body, "Department", dt.Rows[0]["DepartmentName"]);
                    AppendEmailDetailRow(body, "Designation", dt.Rows[0]["DesignationName"]);
                    AppendEmailDetailRow(body, "Location", dt.Rows[0]["WorkingBranchName"]);
                    AppendEmailDetailRow(body, "Reporting manager", dt.Rows[0]["ReportingManager"]);
                    AppendEmailDetailRow(body, "Domain", dt.Rows[0]["SubDomain"]);
                    AppendEmailDetailRow(body, "Project", PrimaryProject);
                    AppendEmailDetailRow(body, "Process", PrimaryProcess);
                    AppendEmailDetailRow(body, "Domain head", DomainHead);
                    AppendEmailDetailRow(body, "Location head", LocationHead);

                    body.Append("</table>" +
                        "<p style=\"margin:26px 0 0;color:#475569;font-size:13px;line-height:20px;\">Regards,<br><strong style=\"color:#0f172a;\">Infinity IPS</strong></p>" +
                        "</td></tr>" +
                        "<tr><td style=\"padding:18px 32px;background-color:#f8fafc;border-top:1px solid #e2e8f0;color:#94a3b8;font-size:11px;line-height:17px;text-align:center;\">This is an automated notification from HRMS. Please do not reply to this email.</td></tr>" +
                        "</table></td></tr></table></body></html>");

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Leaves Notification", System.Text.Encoding.UTF8);

                    //To = "b.shubhangi@infinityinternationals.us";
                    //CC = "b.shubhangi@infinityinternationals.us";
                    //BCC = "b.shubhangi@infinityinternationals.us";

                    mail.To.Add(To);
                    mail.CC.Add(CC);
                    mail.Bcc.Add(BCC);

                    mail.Subject = "HRMS Leaves: Request - " + Convert.ToString(Code);
                    mail.Body = body.ToString();
                    mail.IsBodyHtml = true;
                    mail.Priority = System.Net.Mail.MailPriority.High;
                    SmtpClient client = new SmtpClient();
                    client.UseDefaultCredentials = false;
                    client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", Pass);
                    client.Host = "smtp.office365.com";  //Gmail works on Server Secured Layer
                    client.Port = 587;
                    client.EnableSsl = true;
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                    try
                    {
                        client.Send(mail);
                        return 1;
                    }
                    catch { return 0; }
                }
            }
            return returnvalue;
        }
    }
}
