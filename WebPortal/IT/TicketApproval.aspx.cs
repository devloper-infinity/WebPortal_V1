using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.IT
{
    public partial class TicketApproval : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static string SubPath = "";

        static StringBuilder filelist = new StringBuilder();

        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = Server.MapPath(@"~\UploadScreenShot");
            try
            {
                NewFileName = "";
                HttpContext postedContext = HttpContext.Current;
                HttpPostedFile file = postedContext.Request.Files[0];

                string name = file.FileName;
                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0, (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;

                NewFileName = Server.MapPath("..//TempFiles//" + file.FileName);

                if (filelist.ToString() == "")
                    filelist.Append(NewFileName);
                else
                    filelist.Append("," + NewFileName);

                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0, binaryWriteArray.Length);
                objfilestream.Close();
            }
            catch
            {

            }
        }

        [WebMethod]
        public static string GetAllTicketForApproval()
        {
            DataTable dt1 = new bllAsset().GetAllTicketForApproval(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetTicketForApprval(int TicketID)
        {
            DataTable dt1 = new bllAsset().GetTicketForApprval(TicketID);
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
        public static int InsertTicketApproval(int TicketID, bool Status, string ReqType, string Severity, string Priority, string Remark)
        {
            int ReturnValue = 0;
            string UniquePath = "";

            Hashtable htTicket = new Hashtable();
            htTicket["TicketID"] = TicketID;
            htTicket["RequestType"] = ReqType;
            htTicket["Severity"] = Severity;
            htTicket["Priority"] = Priority;
            htTicket["Remark"] = Remark;
            htTicket["IsApproval"] = Status;

            if (Status == true)
                htTicket["Status"] = "Approved";
            else
                htTicket["Status"] = "Rejected";

            htTicket["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            if (filelist.ToString() != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                string SubPath = FolderPath + "\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + TicketID;
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                UniquePath = SubPath + "\\" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);
                File.Copy(NewFileName, UniquePath);
            }
            htTicket["Attachment"] = UniquePath;

            ReturnValue =  new bllAsset().InsertTicketApproval(htTicket);
            if (ReturnValue > 0)
                SendMailTicketApproval(htTicket, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            return ReturnValue;
        }

        private static string BuildTicketApprovalEmailContent(DataTable ticket, Hashtable approval, string approvalAddedBy, string expectedTat)
        {
            DataRow row = ticket.Rows[0];
            StringBuilder email = new StringBuilder();
            email.Append("<p style=\"margin:0 0 24px;color:#0f172a;font-size:14px;font-weight:700;line-height:20px;\">Dear " + Convert.ToString(row["DepartmentName"]).Trim() + " Team,</p>" +
                "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;border:1px solid #e2e8f0;border-radius:10px;border-collapse:separate;overflow:hidden;\">");

            AppendTicketApprovalDetailRow(email, "Ticket #:", Convert.ToString(row["TicketNo"]).Trim());
            AppendTicketApprovalDetailRow(email, "Desk #:", row["DeskNo"]);
            AppendTicketApprovalDetailRow(email, "Request By:", row["Employee"]);
            AppendTicketApprovalDetailRow(email, "Working Branch:", row["WorkingBranch"]);
            AppendTicketApprovalDetailRow(email, "Reporting Manager:", Convert.ToString(row["ReportingManager"]).Trim());
            AppendTicketApprovalDetailRow(email, "Job Type:", row["JobType"]);
            AppendTicketApprovalDetailRow(email, "Request:", Convert.ToString(row["RequestB"]).Trim());
            AppendTicketApprovalDetailRow(email, "Subject:", Convert.ToString(row["Subject"]).Trim());
            AppendTicketApprovalDetailRow(email, "Posted on:", Convert.ToString(row["RequestDateTime"]).Trim());
            AppendTicketApprovalDetailRow(email, "Description:", Convert.ToString(row["Description"]).Trim());
            AppendTicketApprovalDetailRow(email, "Approval Status:", Convert.ToString(approval["Status"]).Trim());
            AppendTicketApprovalDetailRow(email, "Approval Added By:", approvalAddedBy);
            AppendTicketApprovalDetailRow(email, "Approval Date:", DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss"));
            AppendTicketApprovalDetailRow(email, "Expected TAT:", Convert.ToString(expectedTat).Trim().Replace("\r\n", "<br />"));
            AppendTicketApprovalDetailRow(email, "Remark:", Convert.ToString(approval["Remark"]).Trim().Replace("\r\n", "<br />"));
            email.Append("</table>");

            return email.ToString();
        }

        private static void AppendTicketApprovalDetailRow(StringBuilder email, string label, object value)
        {
            email.Append("<tr><td class=\"detail-label\" style=\"width:34%;padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#64748b;font-size:12px;font-weight:700;line-height:18px;vertical-align:top;\">" + label + "</td>" +
                "<td style=\"padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#1e293b;font-size:13px;font-weight:600;line-height:18px;vertical-align:top;\">" + Convert.ToString(value) + "</td></tr>");
        }

        [WebMethod]
        public static int SendMailTicketApproval(Hashtable htTicket, int LoginEmp)
        {
            int ReturnValue = 0;
            string path = HttpContext.Current.Request.Url.AbsolutePath;
            string Subject = "";
            string Attachment = Convert.ToString(htTicket["Attachment1"]).Trim();

            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            int TicketID = Convert.ToInt32(htTicket["TicketID"]); ;
            string ApprovalGivendBy = "";
            string ApprovalAddedBy = "";
            string ToAddress = "";
            string CC = "";

            DataTable dt = null;
            DataTable dtPm = null;
            DataTable dtEmp = null;

            try
            {
                dtEmp = new bllLogin().GetEmpInfoByEmpId(Convert.ToInt32(htTicket["AddedBy"]));
                ApprovalAddedBy = Convert.ToString(dtEmp.Rows[0]["Code"]) + " : " + Convert.ToString(dtEmp.Rows[0]["FirstName"]) + " " + Convert.ToString(dtEmp.Rows[0]["LastName"]);

                if (Convert.ToString(htTicket["Status"]) == "Pending For Approval")
                {
                    dt = new bllAsset().GetTicketNoSendMail(Convert.ToInt32(htTicket["TicketID"]));
                    dtEmp = new bllLogin().GetEmpInfoByEmpId(Convert.ToInt32(htTicket["AddedBy"]));
                    dtPm = new bllLogin().GetEmployeeInfoByCode(Convert.ToString(htTicket["DomainManager"]));
                    ToAddress = Convert.ToString(dtPm.Rows[0]["OfficialEmailID"]).Trim();
                    CC = Convert.ToString(dtEmp.Rows[0]["OfficialEmailID"]).Trim();
                }
                else
                {
                    dt = new bllAsset().GetTicketForApprval(Convert.ToInt32(htTicket["TicketID"]));
                    dtEmp = new bllLogin().GetEmpInfoByEmpId(Convert.ToInt32(htTicket["AddedBy"]));
                    ApprovalGivendBy = Convert.ToString(dtEmp.Rows[0]["Code"]) + " : " + Convert.ToString(dtEmp.Rows[0]["FirstName"]) + " " + Convert.ToString(dtEmp.Rows[0]["LastName"]);
                }

                string ExpectedTAT = Convert.ToString(dt.Rows[0]["Days"]).Trim() + "Days, " + Convert.ToString(dt.Rows[0]["Hours"]).Trim() + " Hours," + Convert.ToString(dt.Rows[0]["Minutes"]).Trim() + " Minutes";

                head.Append("<html><head></head><body>");
                body.Append("<table style=\"width:802px;font-family:verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                body.Append("<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                        "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear " + Convert.ToString(dt.Rows[0]["DepartmentName"]).Trim() + " Team,</b></td></tr></table>" +
                        "<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                        "<tr><td style=\"border:solid 1px Gray; width:100px!important;\"><b>Ticket #:</b></td><td style=\"border:solid 1px Gray;\">" + Convert.ToString(dt.Rows[0]["TicketNo"]).Trim() + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Desk #:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DeskNo"]) + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Request By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Employee"]) + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranch"]) + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]).Trim() + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Request:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["RequestB"]).Trim() + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Subject:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Subject"]).Trim() + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Posted on:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["RequestDateTime"]).Trim() + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Description:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Description"]).Trim() + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Approval Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htTicket["Status"]).Trim() + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Approval Added By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + ApprovalAddedBy + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Approval Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss") + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Expected TAT:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ExpectedTAT).Trim().Replace("\r\n", "<br />") + "</td></tr>");
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htTicket["Remark"]).Trim().Replace("\r\n", "<br />") + "</td></tr>");
                body.Append("<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                   "<tr><td style=\"text-align:left; font-size:10px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" + "</table>");
                footer.Append("</body></html>");

                string GroupOffID = string.Empty;
                string OffID = string.Empty;
                int Department = Convert.ToInt32(dt.Rows[0]["Department"].ToString());
                int RequestOnBehalf = Convert.ToInt32(dt.Rows[0]["RequestOnBehalf1"]);
                int ReportingManager = Convert.ToInt32(dt.Rows[0]["ReportingManager1"]);
                string OfficialIdDoaminHead = "";

                try
                {
                    int DomainHeadId = Convert.ToInt32(dt.Rows[0]["DomainHead"]);
                    DataTable DomainHead = new bllAsset().GetOfficialMailIdOfEmployee(DomainHeadId);

                    if (DomainHead.Rows.Count > 0)
                    {
                        OfficialIdDoaminHead = Convert.ToString(DomainHead.Rows[0]["OfficialEmailID"]);
                    }
                    else
                    {
                        OfficialIdDoaminHead = "";
                    }
                }
                catch (Exception ex)
                {

                }

                DataTable dtMgr = new bllAsset().GetOfficialMailIdOfEmployee(ReportingManager);
                string OfficialId = "";
                string OfficialId1 = "";

                if (dtMgr.Rows.Count > 0)
                {
                    OfficialId = Convert.ToString(dtMgr.Rows[0]["OfficialEmailID"]);
                }
                else
                {
                    OfficialId = "";
                }
                DataTable dtInfo = new bllAsset().GetOfficialMailIdOfEmployee(RequestOnBehalf);
                if (dtInfo.Rows.Count > 0)
                {
                    OfficialId1 = Convert.ToString(dtInfo.Rows[0]["OfficialEmailID"]);
                }
                else
                {
                    OfficialId1 = "";
                }
                string OfficialId2 = "";
                string TicketCC = "";
                int RequestBy = Convert.ToInt32(dt.Rows[0]["RequestBy"]);

                DataTable dtReqBy = new bllAsset().GetOfficialMailIdOfEmployee(RequestBy);
                if (dtReqBy.Rows.Count > 0)
                {
                    OfficialId2 = Convert.ToString(dtReqBy.Rows[0]["OfficialEmailID"]);
                    if (OfficialId == "")
                    {
                        TicketCC = OfficialId1 + "," + OfficialId2;
                    }
                    if (OfficialId1 == "")
                    {
                        TicketCC = OfficialId + "," + OfficialId2;
                    }

                    if (OfficialId != "" && OfficialId1 != "")
                    {
                        TicketCC = OfficialId + "," + OfficialId1 + "," + OfficialId2;
                    }
                    if (OfficialId2 == "")
                    {
                        TicketCC = OfficialId + "," + OfficialId1;
                    }
                    if (OfficialId1 == "" && OfficialId2 == "")
                    {
                        TicketCC = OfficialId;
                    }
                }
                else
                {
                    OfficialId2 = "";
                    TicketCC = OfficialId + "," + OfficialId1;
                    if (OfficialId == "")
                    {
                        TicketCC = OfficialId1;
                    }
                    if (OfficialId1 == "")
                    {
                        TicketCC = OfficialId;
                    }
                    if (OfficialId != "" && OfficialId1 != "")
                    {
                        TicketCC = OfficialId + "," + OfficialId1;
                    }
                }

                string Pass = new bllMaster().GetPassword("ackdata");
                string BCC = "p.kedar@infinityinternationals.us,n.nilkanth@infinityinternationals.us";
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("ack@infinity-data.com", "Helpdesk Notifications", System.Text.Encoding.UTF8);
                
                //mail.To.Add("b.shubhangi@infinityinternationals.us");

                if (OfficialIdDoaminHead != "")
                    mail.To.Add(OfficialIdDoaminHead);
                if (CC != "")
                    mail.CC.Add(TicketCC);
                if (BCC != "")
                    mail.Bcc.Add(BCC);

                mail.Subject = Subject;

                mail.Body = WebPortal.App_Code.Class.SelfLeavesEmailTemplate.Apply(
                    BuildTicketApprovalEmailContent(dt, htTicket, ApprovalAddedBy, ExpectedTAT),
                    "Ticket approval", true);

                mail.IsBodyHtml = true;
                if (Attachment != "")
                    mail.Attachments.Add(new Attachment(Attachment));

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
                    ReturnValue = 1;
                }
                catch (Exception ex)
                {
                    ReturnValue = 0;
                }
            }
            catch (Exception ex)
            {

            }
            return ReturnValue;
        }
    }
}
