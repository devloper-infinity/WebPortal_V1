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
            string NewCode = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
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

        [WebMethod]
        public static int UserLeaveEmail(string Code, int Days, string FromDate, string ToDate, string Reason, string InformType, string PaidStatus)
        {
            int returnvalue = 0;
            string To = "";
            string CC = "";
            string BCC = "";
            string contentHeader = "";
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
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

                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:verdana; font-size:11px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                    body.Append("<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear " + Convert.ToString(dt.Rows[0]["FirstName"]) + ",<br />We have approved your a Leave Request in ERP with following details.<br /><br /></b></td></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"border:solid 1px Gray; width:100px!important;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;\">" + Convert.ToString(Code) + " : " + Convert.ToString(dt.Rows[0]["FullName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["SubDomain"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Project:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PrimaryProject) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Process:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PrimaryProcess) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(DomainHead) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(LocationHead) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Leave Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString("Casual") + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>No Of Days:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Days) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>From Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToDateTime(FromDate).ToString("dd-MMM-yyyy") + "</td></tr>");
                    body.Append("<tr><td  style=\"border:solid 1px Gray;border-top:none;\"><b>To Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToDateTime(ToDate).ToString("dd-MMM-yyyy") + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Reason) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Approved By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtAdded.Rows[0]["Code"]) + " : " + Convert.ToString(dtAdded.Rows[0]["FirstName"]) + " " + Convert.ToString(dtAdded.Rows[0]["lastName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>PM Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Reason) + "</td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                    footer.Append("</body></html>");

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Leaves Notification", System.Text.Encoding.UTF8);
                    mail.To.Add(To);
                    mail.CC.Add(CC);
                    mail.Bcc.Add(BCC);
                    mail.Subject = "HRMS Leaves: Request Approved - " + Convert.ToString(Code);
                    mail.Body = head.ToString() + body.ToString() + footer.ToString();
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

            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

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

                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:biome; font-size:10px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                    body.Append("<table border=\"0\" style=\"width:800px;font-family:biome; font-size:10px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear " + Convert.ToString(dt.Rows[0]["FirstName"]) + ",<br />We have " + Status2 + " your a Leave Request in ERP with following details.<br /><br /></b></td></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"border:solid 1px Gray; width:100px!important;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;\">" + Convert.ToString(Code) + " : " + Convert.ToString(dt.Rows[0]["FullName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["SubDomain"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Project:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PrimaryProject) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Process:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PrimaryProcess) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(DomainHead) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(LocationHead) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Leave Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["LeaveType"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>No Of Days:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["ForDays"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>From Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["LeaveFrom"]) + "</td></tr>");
                    body.Append("<tr><td  style=\"border:solid 1px Gray;border-top:none;\"><b>To Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["LeaveTo"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["ReasonForLeave"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Leave Applied On:</b></td><td>" + Convert.ToDateTime(dtLeave.Rows[0]["AddedDate"]).ToString("dd-MMM-yyyy") + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Updated By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtApp.Rows[0]["Code"]) + " : " + Convert.ToString(dtApp.Rows[0]["FirstName"]) + " " + Convert.ToString(dtApp.Rows[0]["lastName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["ApprovalRemark"]) + "</td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                    footer.Append("</body></html>");

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Leaves Notification", System.Text.Encoding.UTF8);
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

            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

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

                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:biome; font-size:10px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                    body.Append("<table border=\"0\" style=\"width:800px;font-family:biome; font-size:10px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear " + Convert.ToString(dtLeave.Rows[0]["FirstName"]) + ",<br />Leave Request has been " + Status2 + " in ERP with following details.<br /><br /></b></td></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"border:solid 1px Gray; width:100px!important;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;\">" + Convert.ToString(dtLeave.Rows[0]["EmpName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["WorkingBranchName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["ReportingManager"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["SubDomain"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Project:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PrimaryProject) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Process:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PrimaryProcess) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(DomainHead) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(LocationHead) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Leave Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["LeaveType"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>No Of Days:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["ForDays"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>From Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["LeaveFrom"]) + "</td></tr>");
                    if (Status == "Cancel")
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>To Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["LeaveTo"]) + "</td></tr>");
                    else
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; background-color:yellow;\"><b>To Date:</b></td><td style=\"border:solid 1px Gray;border-top:none; background-color:yellow;\">" + Convert.ToString(dtLeave.Rows[0]["LeaveTo"]) + ", <b>(Old To Date : " + Convert.ToString(dtLeave.Rows[0]["OldLeaveTo"]) + ")</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["ReasonForLeave"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Leave Applied On:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToDateTime(dtLeave.Rows[0]["AddedDate"]).ToString("dd-MMM-yyyy") + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Updated By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["UpdatedByName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtLeave.Rows[0]["UpdateRemark"]) + "</td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                    footer.Append("</body></html>");

                    string Subject = "HRMS Leaves: Request " + Status1 + " - " + Convert.ToString(Code);
                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Leaves Notification", System.Text.Encoding.UTF8);
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