using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using DocumentFormat.OpenXml.Spreadsheet;
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
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using DataTable = System.Data.DataTable;
using MailMessage = System.Net.Mail.MailMessage;

namespace WebPortal.Admin
{
    public partial class EmployeeLeaves : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Get Data
        [WebMethod]
        public static string BindUsers()
        {
            string NewCode = EmployeeInfo.Current.Code; // new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt1 = new bllMaster().GetAllUserByPM(NewCode);
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
            int EmployeeID = EmployeeInfo.Current.EmployeeID; //new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt1 = new bllLogin().GetUserInformation(EmployeeID);
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
        public static string GetLeaveDetails(string Code)
        {
            DataTable dt1 = new bllMaster().GetLeaveDetails(Code);
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
        public static string GetLeavesToDate_Emp(string FromDate, int Days)
        {
            return new CodeGeneration().GetLeavesToDate(FromDate, Days);
        }

        [WebMethod]
        public static string BindUserLeaves()
        {
            DataTable dt1 = new bllMaster().GetAllLeavesbyPM(Convert.ToInt32(HttpContext.Current.User.Identity.Name));
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
        public static decimal getPendingLeaveCount(string Code)
        {
            decimal LeaveCount = new bllMaster().GetPendingLeaveCount(Code);
            return LeaveCount;
        }

        #endregion

        [WebMethod]
        public static int InsertLeave(string Code, int Days, string FromDate, string ToDate, string Reason, string InformType, string PaidStatus)
        {
            int returnvalue = 0;

            Hashtable htTeamLeaves = new Hashtable();
            htTeamLeaves.Add("Code", Code);
            htTeamLeaves.Add("ForDays", Days);
            htTeamLeaves.Add("LeaveFrom", Convert.ToDateTime(FromDate).ToString("dd-MMM-yyyy"));
            htTeamLeaves.Add("LeaveTo", Convert.ToDateTime(ToDate).ToString("dd-MMM-yyyy"));
            htTeamLeaves.Add("ReasonForLeave", Reason);
            htTeamLeaves.Add("InformType", InformType);
            htTeamLeaves.Add("ApprovedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htTeamLeaves.Add("ApprovalRemark", Reason);
            htTeamLeaves.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue = new bllMaster().InsertTeamLeavesByPM(htTeamLeaves);

            if (returnvalue > 0)
            {
                if (PaidStatus == "Paid")
                {
                    new bllMaster().InsertPaidLeavePM(htTeamLeaves, returnvalue, PaidStatus);
                }
                UserLeaveEmail(Code, Days, FromDate, ToDate, Reason, InformType, PaidStatus);
            }
            return returnvalue;
        }

        [WebMethod]
        public static int UpdateLeaveStatus(int LeaveID, string Code, string Status, string PaidStatus, string Comment)
        {
            int leaveid = LeaveID;
            string status = Status;
            bool leavestatus = status == "Approve" ? true : false;
            string comment = Comment;

            int returnvalue = new bllMaster().UpdateUserLeaves(LeaveID, leavestatus, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), comment, PaidStatus);

            if (returnvalue > 0)
            {
                UserLeaveApprovalRejectionEmail(LeaveID, Code, status, Comment, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                return 1;
            }
            else
            {
                return 0;
            }
        }

        [WebMethod]
        public static int ExtendShortenLeaves(int LeaveID, string Code, string LeaveStatus, string FromDate, string ToDate, int Days, string Remark)
        {
            int returnvalue = 0;

            Hashtable htExtend = new Hashtable();
            htExtend.Add("LeaveID", LeaveID);
            htExtend.Add("LeaveStatus", LeaveStatus);
            htExtend.Add("FromDate", FromDate);
            htExtend.Add("ToDate", ToDate);
            htExtend.Add("Days", Days);
            htExtend.Add("Remark", Remark);
            htExtend.Add("UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue = new bllMaster().UpdateEmployeeLeaves(htExtend);

            if (returnvalue > 0)
            {
                ExtendShortenLeaveEmail(LeaveID, Code, LeaveStatus, Remark, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            }
            return returnvalue;
        }

        #region Email

        private static void AppendLeaveEmailStart(StringBuilder email, string recipientName, string message)
        {
            email.Append("<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">" +
                "<style>body,table,td{font-family:Arial,'Helvetica Neue',sans-serif!important;text-align:left}@media only screen and (max-width:620px){.email-shell{width:100%!important}.outer-pad{padding:10px!important}.content-pad{padding:20px 16px!important}.summary-cell{display:block!important;width:100%!important;box-sizing:border-box!important;border-right:0!important}.summary-divider{border-top:1px solid #e2e8f0!important}.detail-label{width:38%!important}}</style>" +
                "</head><body style=\"margin:0;padding:0;background-color:#f1f5f9;color:#1e293b;text-align:left;\">" +
                "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;background-color:#f1f5f9;text-align:left;\"><tr><td class=\"outer-pad\" align=\"left\" style=\"padding:20px 16px;text-align:left;\">" +
                "<table role=\"presentation\" class=\"email-shell\" width=\"680\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;max-width:680px;background-color:#ffffff;border:1px solid #e2e8f0;border-radius:16px;overflow:hidden;\">" +
                "<tr><td bgcolor=\"#173b70\" style=\"padding:15px 24px;background-color:#173b70;border-bottom:3px solid #2f80ed;text-align:left;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;background-color:#173b70;\"><tr><td bgcolor=\"#173b70\" style=\"color:#bfdbfe;font-size:10px;font-weight:700;line-height:14px;letter-spacing:1.2px;text-transform:uppercase;mso-line-height-rule:exactly;\">INFINITY IPS &nbsp;/&nbsp; HRMS</td></tr><tr><td height=\"4\" bgcolor=\"#173b70\" style=\"height:4px;font-size:0;line-height:4px;mso-line-height-rule:exactly;\">&nbsp;</td></tr><tr><td bgcolor=\"#173b70\" style=\"color:#ffffff;font-size:22px;font-weight:700;line-height:27px;mso-line-height-rule:exactly;\">Leave request</td></tr></table></td></tr>" +
                "<tr><td class=\"content-pad\" style=\"padding:24px;text-align:left;\">" +
                "<p style=\"margin:0 0 24px;color:#0f172a;font-size:14px;font-weight:700;line-height:22px;\">Dear " + recipientName + ",<br />" + message + "<br /><br /></p>");
        }

        private static void AppendLeaveSummary(StringBuilder email, string leaveType, string days, string fromDate, string toDate, bool highlightToDate)
        {
            string toDateBackground = highlightToDate ? "background-color:#fffbeb;" : "";

            email.Append("<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;border:1px solid #cbd5e1;border-radius:10px;border-collapse:separate;overflow:hidden;\">" +
                "<tr height=\"40\" style=\"height:40px;mso-height-source:exactly;\"><td colspan=\"2\" height=\"40\" bgcolor=\"#173b70\" style=\"height:40px;padding:0 14px;background-color:#173b70;color:#ffffff;font-size:14px;font-weight:700;line-height:40px;mso-line-height-rule:exactly;\">Leave Request Details</td></tr>" +
                "<tr height=\"48\" style=\"height:48px;mso-height-source:exactly;\">" +
                "<td class=\"summary-cell\" width=\"50%\" height=\"48\" valign=\"middle\" style=\"width:50%;height:48px;padding:0 14px!important;border-right:1px solid #e2e8f0;vertical-align:middle;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr><td height=\"13\" style=\"height:13px;color:#64748b;font-size:9px;font-weight:700;line-height:13px;letter-spacing:.7px;text-transform:uppercase;mso-line-height-rule:exactly;padding-left:5px;\">Leave Type:</td></tr><tr><td height=\"19\" style=\"height:19px;color:#0f3d75;font-size:14px;font-weight:700;line-height:19px;mso-line-height-rule:exactly;padding-left:5px;\">" + leaveType + "</td></tr></table></td>" +
                "<td class=\"summary-cell summary-divider\" width=\"50%\" height=\"48\" valign=\"middle\" style=\"width:50%;height:48px;padding:0 14px!important;vertical-align:middle;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr><td height=\"13\" style=\"height:13px;color:#64748b;font-size:9px;font-weight:700;line-height:13px;letter-spacing:.7px;text-transform:uppercase;mso-line-height-rule:exactly;padding-left:5px;\">No Of Days:</td></tr><tr><td height=\"19\" style=\"height:19px;color:#0f172a;font-size:14px;font-weight:700;line-height:19px;mso-line-height-rule:exactly;padding-left:5px;\">" + days + "</td></tr></table></td>" +
                "</tr><tr height=\"48\" style=\"height:48px;mso-height-source:exactly;\">" +
                "<td class=\"summary-cell summary-divider\" width=\"50%\" height=\"48\" valign=\"middle\" style=\"width:50%;height:48px;padding:0 14px!important;border-top:1px solid #e2e8f0;border-right:1px solid #e2e8f0;vertical-align:middle;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr><td height=\"13\" style=\"height:13px;color:#64748b;font-size:9px;font-weight:700;line-height:13px;letter-spacing:.7px;text-transform:uppercase;mso-line-height-rule:exactly;padding-left:5px;\">From Date:</td></tr><tr><td height=\"19\" style=\"height:19px;color:#0f172a;font-size:13px;font-weight:700;line-height:19px;mso-line-height-rule:exactly;padding-left:5px;\">" + fromDate + "</td></tr></table></td>" +
                "<td class=\"summary-cell summary-divider\" width=\"50%\" height=\"48\" valign=\"middle\" style=\"width:50%;height:48px;padding:0 14px!important;border-top:1px solid #e2e8f0;vertical-align:middle;padding-left:5px;" + toDateBackground + "\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"" + toDateBackground + "\"><tr><td height=\"13\" style=\"height:13px;color:#64748b;font-size:9px;font-weight:700;line-height:13px;letter-spacing:.7px;text-transform:uppercase;mso-line-height-rule:exactly;padding-left:5px;" + toDateBackground + "\">To Date:</td></tr><tr><td height=\"19\" style=\"height:19px;color:#0f172a;font-size:13px;font-weight:700;line-height:19px;mso-line-height-rule:exactly;padding-left:5px;" + toDateBackground + "\">" + toDate + "</td></tr></table></td>" +
                "</tr></table>");
        }

        private static void AppendEmailSectionHeading(StringBuilder email, string heading)
        {
            email.Append("<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;\"><tr><td height=\"18\" style=\"height:18px;font-size:0;line-height:18px;\">&nbsp;</td></tr><tr><td style=\"color:#0f172a;font-size:15px;font-weight:700;line-height:20px;\">" + heading + "</td></tr><tr><td height=\"8\" style=\"height:8px;font-size:0;line-height:8px;\">&nbsp;</td></tr></table>");
        }

        private static void AppendLeaveReason(StringBuilder email, string reason)
        {
            AppendEmailSectionHeading(email, "Reason:");
            email.Append("<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;background-color:#eff6ff;border:1px solid #bfdbfe;border-left:4px solid #2563eb;border-radius:8px;\"><tr><td style=\"padding:12px 14px;color:#1e3a5f;font-size:14px;line-height:22px;text-align:left;\">" + reason + "</td></tr></table>");
        }

        private static void AppendEmployeeDetailsStart(StringBuilder email)
        {
            AppendEmailSectionHeading(email, "Employee Information");
            email.Append("<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;border:1px solid #e2e8f0;border-radius:10px;border-collapse:separate;overflow:hidden;\">");
        }

        private static void AppendEmployeeDetailRow(StringBuilder email, string label, object value)
        {
            email.Append("<tr><td class=\"detail-label\" style=\"width:34%;padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#64748b;font-size:12px;font-weight:700;line-height:18px;vertical-align:top;\">" + label + "</td>" +
                "<td style=\"padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#1e293b;font-size:13px;font-weight:600;line-height:18px;vertical-align:top;\">" + Convert.ToString(value) + "</td></tr>");
        }

        private static void AppendLeaveEmailEnd(StringBuilder email)
        {
            email.Append("</table>" +
                "<p style=\"margin:26px 0 0;color:#475569;font-size:13px;line-height:20px;\">Regards,<br><strong style=\"color:#0f172a;\">Infinity IPS</strong></p>" +
                "</td></tr>" +
                "<tr><td style=\"padding:18px 32px;background-color:#f8fafc;border-top:1px solid #e2e8f0;color:#94a3b8;font-size:11px;line-height:17px;text-align:center;\">This is an automated notification from HRMS. Please do not reply to this email.</td></tr>" +
                "</table></td></tr></table></body></html>");
        }

        [WebMethod]
        public static int UserLeaveEmail(string Code, int Days, string FromDate, string ToDate, string Reason, string InformType, string PaidStatus)
        {
            int returnvalue = 0;
            string To = "";
            string CC = "";
            string BCC = "";
            string contentHeader = "";
            StringBuilder body = new StringBuilder();
            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt = new bllLogin().GetUserInformation(EmployeeID);
            DataTable dtAdded = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dtPM = new bllMaster().ProjectManagerRelatedToDepartment(EmployeeID);
            string LocationHead = "";
            string DomainHead = "";
            string PrimaryProject = "";
            string PrimaryProcess = "";
            string DomainEmailID = "";

            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(EmployeeID, "Attendance Correction");
            LocationHead = Convert.ToString(dtEmail.Rows[0]["LocationHeadName"]);
            DomainHead = Convert.ToString(dtEmail.Rows[0]["DomainHeadName"]);
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
                    To = Convert.ToString(dtEmail.Rows[0]["ToAttendance"]);
                    CC = Convert.ToString(dtEmail.Rows[0]["CCAtt"]);
                    BCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                    AppendLeaveEmailStart(body, Convert.ToString(dt.Rows[0]["FirstName"]), "We have approved your a Leave Request in ERP with following details.");
                    AppendLeaveSummary(body, Convert.ToString("Casual"), Convert.ToString(Days), Convert.ToDateTime(FromDate).ToString("dd-MMM-yyyy"), Convert.ToDateTime(ToDate).ToString("dd-MMM-yyyy"), false);
                    AppendLeaveReason(body, Convert.ToString(Reason));
                    AppendEmployeeDetailsStart(body);
                    AppendEmployeeDetailRow(body, "Name:", Convert.ToString(Code) + " : " + Convert.ToString(dt.Rows[0]["FullName"]));
                    AppendEmployeeDetailRow(body, "Joining Date:", dt.Rows[0]["JoiningDate"]);
                    AppendEmployeeDetailRow(body, "Job Type:", dt.Rows[0]["JobType"]);
                    AppendEmployeeDetailRow(body, "Department:", dt.Rows[0]["DepartmentName"]);
                    AppendEmployeeDetailRow(body, "Designation:", dt.Rows[0]["DesignationName"]);
                    AppendEmployeeDetailRow(body, "Location:", dt.Rows[0]["WorkingBranchName"]);
                    AppendEmployeeDetailRow(body, "Reporting Manager:", dt.Rows[0]["ReportingManager"]);
                    AppendEmployeeDetailRow(body, "Domain:", dt.Rows[0]["SubDomain"]);
                    AppendEmployeeDetailRow(body, "Project:", PrimaryProject);
                    AppendEmployeeDetailRow(body, "Process:", PrimaryProcess);
                    AppendEmployeeDetailRow(body, "Domain Head:", DomainHead);
                    AppendEmployeeDetailRow(body, "Location Head:", LocationHead);
                    AppendEmployeeDetailRow(body, "Approved By:", Convert.ToString(dtAdded.Rows[0]["Code"]) + " : " + Convert.ToString(dtAdded.Rows[0]["FirstName"]) + " " + Convert.ToString(dtAdded.Rows[0]["lastName"]));
                    AppendEmployeeDetailRow(body, "PM Remark:", Reason);
                    AppendLeaveEmailEnd(body);

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Leaves Notification", System.Text.Encoding.UTF8);
                    mail.To.Add(To);
                    mail.CC.Add(CC);
                    mail.Bcc.Add(BCC);
                    mail.Subject = "HRMS Leaves: Request Approved - " + Convert.ToString(Code);
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

        [WebMethod]
        public static int UserLeaveApprovalRejectionEmail(int LeaveID, string Code, string Status, string Comment, int AddedBy)
        {
            int returnvalue = 0;

            string To = "";
            string CC = "";
            string BCC = "";
            string Status1 = "";
            string Status2 = "";
            string DomainHead = "";
            string LocationHead = "";
            string PrimaryProject = "";
            string PrimaryProcess = "";

            StringBuilder body = new StringBuilder();

            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt = new bllLogin().GetUserInformation(EmployeeID);
            DataTable dtAdded = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dtPM = new bllMaster().ProjectManagerRelatedToDepartment(EmployeeID);
            DataTable dtApp = new bllLogin().GetUserInformation(AddedBy);
            DataTable dtLeave = new bllMaster().GetLeaveDetailsByID(LeaveID);

            if (Status == "Approve")
                Status1 = "Approved";
            else
                Status1 = "Rejected";

            if (Status == "Approve")
                Status2 = "approved";
            else
                Status2 = "rejected";

            string Subject = "HRMS Leaves: Request " + Status1 + " - " + Convert.ToString(Code);

            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(EmployeeID, "Attendance Correction");
            LocationHead = Convert.ToString(dtEmail.Rows[0]["LocationHeadName"]);
            DomainHead = Convert.ToString(dtEmail.Rows[0]["DomainHeadName"]);

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
                    To = Convert.ToString(dtEmail.Rows[0]["ToAttendance"]);
                    CC = Convert.ToString(dtEmail.Rows[0]["CCAtt"]);
                    BCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                    AppendLeaveEmailStart(body, Convert.ToString(dt.Rows[0]["FirstName"]), "We have " + Status2 + " your a Leave Request in ERP with following details.");
                    AppendLeaveSummary(body, Convert.ToString(dtLeave.Rows[0]["LeaveType"]), Convert.ToString(dtLeave.Rows[0]["ForDays"]), Convert.ToString(dtLeave.Rows[0]["LeaveFrom"]), Convert.ToString(dtLeave.Rows[0]["LeaveTo"]), false);
                    AppendLeaveReason(body, Convert.ToString(dtLeave.Rows[0]["ReasonForLeave"]));
                    AppendEmployeeDetailsStart(body);
                    AppendEmployeeDetailRow(body, "Name:", Convert.ToString(Code) + " : " + Convert.ToString(dt.Rows[0]["FullName"]));
                    AppendEmployeeDetailRow(body, "Joining Date:", dt.Rows[0]["JoiningDate"]);
                    AppendEmployeeDetailRow(body, "Job Type:", dt.Rows[0]["JobType"]);
                    AppendEmployeeDetailRow(body, "Department:", dt.Rows[0]["DepartmentName"]);
                    AppendEmployeeDetailRow(body, "Designation:", dt.Rows[0]["DesignationName"]);
                    AppendEmployeeDetailRow(body, "Location:", dt.Rows[0]["WorkingBranchName"]);
                    AppendEmployeeDetailRow(body, "Reporting Manager:", dt.Rows[0]["ReportingManager"]);
                    AppendEmployeeDetailRow(body, "Domain:", dt.Rows[0]["SubDomain"]);
                    AppendEmployeeDetailRow(body, "Project:", PrimaryProject);
                    AppendEmployeeDetailRow(body, "Process:", PrimaryProcess);
                    AppendEmployeeDetailRow(body, "Domain Head:", DomainHead);
                    AppendEmployeeDetailRow(body, "Location Head:", LocationHead);
                    AppendEmployeeDetailRow(body, "Leave Applied On:", Convert.ToDateTime(dtLeave.Rows[0]["AddedDate"]).ToString("dd-MMM-yyyy"));
                    AppendEmployeeDetailRow(body, "Updated By:", Convert.ToString(dtApp.Rows[0]["Code"]) + " : " + Convert.ToString(dtApp.Rows[0]["FirstName"]) + " " + Convert.ToString(dtApp.Rows[0]["lastName"]));
                    AppendEmployeeDetailRow(body, "Remark:", dtLeave.Rows[0]["ApprovalRemark"]);
                    AppendLeaveEmailEnd(body);

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Leaves Notification", System.Text.Encoding.UTF8);
                    mail.To.Add(To);
                    mail.CC.Add(CC);
                    mail.Bcc.Add(BCC);
                    mail.Subject = Subject;
                    mail.Body = body.ToString();
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
                        return 1;
                    }
                    catch { return 0; }
                }
            }
            return returnvalue;
        }

        [WebMethod]
        public static int ExtendShortenLeaveEmail(int LeaveID, string Code, string Status, string Comment, int AddedBy)
        {
            int returnvalue = 0;
            string To = "";
            string CC = "";
            string BCC = "";
            string Status1 = "";
            string Status2 = "";
            string LocationHead = "";
            string DomainHead = "";
            string PrimaryProject = "";
            string PrimaryProcess = "";

            StringBuilder body = new StringBuilder();

            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt = new bllLogin().GetUserInformation(EmployeeID);
            DataTable dtAdded = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dtPM = new bllMaster().ProjectManagerRelatedToDepartment(EmployeeID);
            DataTable dtLeave = new bllMaster().GetExtendedAndShortenLeavesDetails(LeaveID);

            if (Status == "Extend")
                Status1 = "Extended";
            else if (Status == "Cancel")
                Status1 = "Cancelled";
            else
                Status1 = "Shortened";

            if (Status == "Extend")
                Status2 = "extended";
            else if (Status == "Cancel")
                Status2 = "cancelled";
            else
                Status2 = "shortened";

            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(EmployeeID, "Attendance Correction");
            LocationHead = Convert.ToString(dtEmail.Rows[0]["LocationHeadName"]);
            DomainHead = Convert.ToString(dtEmail.Rows[0]["DomainHeadName"]);
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
                    To = Convert.ToString(dtEmail.Rows[0]["ToAttendance"]);
                    CC = Convert.ToString(dtEmail.Rows[0]["CCAtt"]);
                    BCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                    AppendLeaveEmailStart(body, Convert.ToString(dtLeave.Rows[0]["FirstName"]), "Leave Request has been " + Status2 + " in ERP with following details.");
                    if (Status == "Cancel")
                        AppendLeaveSummary(body, Convert.ToString(dtLeave.Rows[0]["LeaveType"]), Convert.ToString(dtLeave.Rows[0]["ForDays"]), Convert.ToString(dtLeave.Rows[0]["LeaveFrom"]), Convert.ToString(dtLeave.Rows[0]["LeaveTo"]), false);
                    else
                        AppendLeaveSummary(body, Convert.ToString(dtLeave.Rows[0]["LeaveType"]), Convert.ToString(dtLeave.Rows[0]["ForDays"]), Convert.ToString(dtLeave.Rows[0]["LeaveFrom"]), Convert.ToString(dtLeave.Rows[0]["LeaveTo"]) + ", <b>(Old To Date : " + Convert.ToString(dtLeave.Rows[0]["OldLeaveTo"]) + ")</b>", true);
                    AppendLeaveReason(body, Convert.ToString(dtLeave.Rows[0]["ReasonForLeave"]));
                    AppendEmployeeDetailsStart(body);
                    AppendEmployeeDetailRow(body, "Name:", dtLeave.Rows[0]["EmpName"]);
                    AppendEmployeeDetailRow(body, "Location:", dtLeave.Rows[0]["WorkingBranchName"]);
                    AppendEmployeeDetailRow(body, "Reporting Manager:", dtLeave.Rows[0]["ReportingManager"]);
                    AppendEmployeeDetailRow(body, "Job Type:", dt.Rows[0]["JobType"]);
                    AppendEmployeeDetailRow(body, "Domain:", dtLeave.Rows[0]["SubDomain"]);
                    AppendEmployeeDetailRow(body, "Project:", PrimaryProject);
                    AppendEmployeeDetailRow(body, "Process:", PrimaryProcess);
                    AppendEmployeeDetailRow(body, "Domain Head:", DomainHead);
                    AppendEmployeeDetailRow(body, "Location Head:", LocationHead);
                    AppendEmployeeDetailRow(body, "Leave Applied On:", Convert.ToDateTime(dtLeave.Rows[0]["AddedDate"]).ToString("dd-MMM-yyyy"));
                    AppendEmployeeDetailRow(body, "Updated By:", dtLeave.Rows[0]["UpdatedByName"]);
                    AppendEmployeeDetailRow(body, "Remark:", dtLeave.Rows[0]["UpdateRemark"]);
                    AppendLeaveEmailEnd(body);

                    string Subject = "HRMS Leaves: Request " + Status1 + " - " + Convert.ToString(Code);
                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Leaves Notification", System.Text.Encoding.UTF8);
                    mail.To.Add(To);
                    mail.CC.Add(CC);
                    mail.Bcc.Add(BCC);
                    mail.Subject = Subject;
                    mail.Body = body.ToString();
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
                        return 1;
                    }
                    catch { return 0; }
                }
            }
            return returnvalue;
        }

        #endregion
    }
}
