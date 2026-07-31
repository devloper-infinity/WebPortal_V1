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
            returnvalue = new bllMaster().InsertSetAppreciationDisplinaryAction(ApprDescId, EmployeeID, Type, Title, Description, Editor, Subject, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), Period);
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


                        head.Append("<html><head></head><body>");
                        body.Append("<table style=\"width:802px;font-family:biome; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                        body.Append("<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                                "<tr><td style=\"border:solid 1px Gray; width:100px!important;\"><b>Code:</b></td><td style=\"border:solid 1px Gray;\">" + Convert.ToString(dt.Rows[0]["Code"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["lastName"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr></table>");
                        body.Append("<br />");
                        body.Append("<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear " + Convert.ToString(dt.Rows[0]["FirstName"]) + "<br /></b></td></tr></table>");
                        body.Append("<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">");
                        body.Append("<tr><td style= colspan=\"2\">" + Convert.ToString(Description) + "</td></tr>");
                        body.Append("<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />" + CurrentUserName + "  <br />" + Convert.ToString(dt.Rows[0]["CompanyName"]) + "</td></tr>" +
                            "<tr><td style=\"text-align:left; font-size:10px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                            "</table>");
                        footer.Append("</body></html>");

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
                            // client.Send(mail);
                        }
                        catch { }
                    }
                }
            }
        }
    }
}
