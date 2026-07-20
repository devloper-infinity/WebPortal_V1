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

            returnvalue = new bllMaster().InsertLeave(htParam);

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

            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(EmployeeID, "Attendance Correction");
            if (dtEmail.Rows.Count > 0)
            {
                LocationHead = Convert.ToString(dtEmail.Rows[0]["LocationHeadName"]);
                DomainHead = Convert.ToString(dtEmail.Rows[0]["DomainHeadName"]);

                To = Convert.ToString(dtEmail.Rows[0]["ToAttendance"]);
                CC = Convert.ToString(dtEmail.Rows[0]["CCAtt"]);
                BCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);
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
                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:verdana; font-size:11px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                    body.Append("<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear User,<br />You have recieved a Leave Request in ERP with following details:<br /><br /></b></td></tr></table>" +
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
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Leave Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(LeaveType) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Paid / Unpaid:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PaidStatus) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>No Of Days:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Days) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>From Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(FromDate) + "</td></tr>");
                    body.Append("<tr><td  style=\"border:solid 1px Gray;border-top:none;\"><b>To Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ToDate) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Reason) + "</td></tr>");
                    body.Append("<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                    footer.Append("</body></html>");

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Leaves Notification", System.Text.Encoding.UTF8);

                    mail.To.Add(To);
                    mail.CC.Add(CC);
                    mail.Bcc.Add(BCC);

                    mail.Subject = "HRMS Leaves: Request - " + Convert.ToString(Code);
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
    }
}
