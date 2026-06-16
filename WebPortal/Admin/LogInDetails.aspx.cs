using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
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

namespace WebPortal.Admin
{
    public partial class LogInDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string BindLogGrid(string Code, string Date)
        {
            // Date = Convert.ToDateTime(Date).ToString("dd-MMM-yyyy");
            string PMCode = new bllMaster().GetCodeFromEmployeeId(Convert.ToInt32(Code));
            DataTable dt1 = new bllMaster().ShowAllLogDetails(PMCode, Date);
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
        public static int BlockUnblockLogin(string Code, string ToBeStatus, string Remark)
        {
            int returnvalue = 0;

            bool status = ToBeStatus == "Activated" ? true : false;

            returnvalue = new bllMaster().InsertEmployeeLogInHistory(Code, status, Remark, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            if (returnvalue > 0)
            {
                string AddedByName = "";

                DataTable dt = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                if (dt.Rows.Count > 0)
                {
                    try
                    {
                        AddedByName = Convert.ToString(dt.Rows[0]["Code"]);
                    }
                    catch { }
                }

                string BlockedRemark = "";

                if (ToBeStatus == "Activated")
                    BlockedRemark = new bllMaster().GetBlockedRemarkByCode(Code);

                SendBlockUnblockEmail(Code, ToBeStatus, Remark, AddedByName, BlockedRemark);
            }
            return returnvalue;
        }

        [WebMethod]
        public static int SendBlockUnblockEmail(string Code, string Status, string Remark, string AddedBy, string BlockedRemark)
        {
            int returnvalue = 0;

            int EmployeeID = Convert.ToInt32(new bllMaster().GetEmployeeIdFromCode(Code));
            DataTable dt1 = new bllMaster().EmployeeDetailsByCode(Code);

            string LocationHead = "";
            string DomainHead = "";
            string PrimaryProject = "";
            string PrimaryProcess = "";
            string Subject = string.Empty;
            string ToAddress = string.Empty;
            string ToBCC = string.Empty;
            string ToCC = string.Empty;

            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(EmployeeID, "LogInDetails");
            LocationHead = Convert.ToString(dtEmail.Rows[0]["LocationHeadName"]);
            DomainHead = Convert.ToString(dtEmail.Rows[0]["DomainHeadName"]);
            if (LocationHead == "")
                LocationHead = DomainHead;

            ToAddress = Convert.ToString(dtEmail.Rows[0]["ToLogInDetails"]);
            ToCC = Convert.ToString(dtEmail.Rows[0]["CC"]);
            ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

            DataTable dtPro = new bllMaster().GetPrimaryProject(EmployeeID);
            if (dtPro != null)
            {
                if (dtPro.Rows.Count > 0)
                {
                    PrimaryProject = Convert.ToString(dtPro.Rows[0]["Project"]);
                    PrimaryProcess = Convert.ToString(dtPro.Rows[0]["Process"]);
                }
            }

            StringBuilder htmlBody = new StringBuilder();
            StringBuilder htmlBody_Service = new StringBuilder();
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            if (dt1.Rows.Count > 0)
            {
                for (int i = 0; i < dt1.Rows.Count; i++)
                {
                    if (Status == "Blocked")
                        Subject = "disabled";
                    else
                        Subject = "enabled";

                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:biome; font-size:10px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                    body.Append("<table border =\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                    "<tr><td style=\"text-align:left; font-size:11px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />User " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt1.Rows[0]["lastName"]) + " rights has been " + Subject + ".<br /><br /></b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Employee Basic Details</b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Code:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Code).ToUpper() + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt1.Rows[i]["WorkingBranchName"]) + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt1.Rows[i]["JoiningDate"]) + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt1.Rows[i]["JobType"]) + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt1.Rows[i]["DepartmentName"]) + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt1.Rows[i]["DesignationName"]) + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt1.Rows[i]["SubDomain"]) + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Project:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PrimaryProject) + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Process:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PrimaryProcess) + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Domain Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(DomainHead) + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Location Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(LocationHead) + " </td></tr>");
                    if (BlockedRemark != "")
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Blocked Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(BlockedRemark) + " </td></tr>");

                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Status) + " </td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(AddedBy) + "::" + DateTime.Now.ToString("dd-MMM-yyyy") + "::" + Convert.ToString(Remark) + "</td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:10px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:09px; border-top:none!important;\" colspan=\"2\"><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                    "</table>");

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Profile Notifications", System.Text.Encoding.UTF8);
                    mail.To.Add(ToAddress);
                    mail.To.Add(ToCC);
                    mail.Bcc.Add(ToBCC);

                    mail.Subject = " User rights has been " + Subject + "-User " + Code;
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
                        returnvalue = 1;
                        return 1;
                    }
                    catch (Exception ex) { return 0; }

                }
            }
            return returnvalue;
        }
    }
}