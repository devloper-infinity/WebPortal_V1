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

namespace WebPortal.Admin
{
    public partial class UnderwritingTestModule : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Credit Section

        [WebMethod]
        public static int InsertQuestionSet_CRUW(string Question, string QuestionType, string Weightage, string Option1, string Option2, string Option3, string Option4, string CorrectAnswer)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("Question", Question);
            htParam.Add("QuestionType", QuestionType);
            htParam.Add("Weightage", Weightage);
            htParam.Add("Answer1", Option1);
            htParam.Add("Answer2", Option2);
            htParam.Add("Answer3", Option3);
            htParam.Add("Answer4", Option4);
            htParam.Add("CorrectAnswer", CorrectAnswer);

            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertUWQuestion(htParam);

            return returnvalue;
        }

        [WebMethod]
        public static string GetAllCredit_UWQuestions()
        {
            DataTable dt1 = new bllMaster().getAllCredit_UWQuestion();
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
        public static string GetCredit_UWQuestionPaperforcheck(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetCredit_UWCheckQuestionPaper(FromDate, ToDate);
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
        public static string GetCredit_UWCandidateForSendMail(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetCredit_UWCandidateForSendMail(FromDate, ToDate);
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

        protected void btnMail_Click(object sender, EventArgs e)
        {
            string AppIDs = Convert.ToString(Request.Form["emailappid"]);
            string[] AppIDList;
            AppIDList = AppIDs.Split(',');
            foreach (string AppID in AppIDList)
            {

                if (AppID != "")
                {
                    DataTable dt = new bllRequisition().GetApplicantInfo(Convert.ToInt32(AppID));
                    StringBuilder head = new StringBuilder();
                    StringBuilder body = new StringBuilder();
                    StringBuilder footer = new StringBuilder();
                    string ToAddress = Convert.ToString(dt.Rows[0]["EmailID"]);
                    string ToBCC = "n.nilkanth@infinityinternationals.us,g.trupti@infinityinternationals.us";
                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:Verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:22px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                        "<table border=\"0\" style=\"width:800px;font-family:Verdana; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                        "<tr><td style=\"text-align:left; font-size:12px;\"><b>Hello " + Convert.ToString(dt.Rows[0]["FirstName"]) + ",<br /><br /></b></td></tr>");
                    body.Append("<tr><td>Please <a href='http://103.139.68.133/Infinity/UWQuestionPaper.aspx?AppID=" + AppID + "'>click here </a> to take the test. Once you have completed the test, please let us know.</td></tr>");
                    body.Append("<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity</td></tr>" +
                            "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                            "</table>");
                    footer.Append("</body></html>");

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Online Test Notification", System.Text.Encoding.UTF8);
                    mail.To.Add(ToAddress);
                    mail.Bcc.Add(ToBCC);
                    mail.Subject = "Infinity IPS - Online Test Link";
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
                        Hashtable htParam = new Hashtable();
                        htParam.Add("ApplicationID", Convert.ToInt32(AppID));
                        new bllRequisition().InsertCredit_UWQUestionnaire(htParam);
                    }
                    catch { }
                }
            }
            //up1.Update();
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Test link sent successfully!');", true);
        }

        #endregion

        #region Servicing Section
        [WebMethod]
        public static string GetAllServicing_UWQuestions()
        {
            DataTable dt1 = new bllMaster().getAllServicing_UWQuestion();
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
        public static int InsertQuestionSet_SERUW(string Question, string Weightage, string Option1, string Option2, string Option3, string Option4, string CorrectAnswer)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("Question", Question);
            htParam.Add("Weightage", Weightage);
            htParam.Add("Answer1", Option1);
            htParam.Add("Answer2", Option2);
            htParam.Add("Answer3", Option3);
            htParam.Add("Answer4", Option4);
            htParam.Add("CorrectAnswer", CorrectAnswer);

            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertServicingUWQuestion(htParam);

            return returnvalue;
        }

        [WebMethod]
        public static string GetServicing_UWQuestionPaperforcheck(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().Getservicing_UWCheckQuestionPaper(FromDate, ToDate);
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
        public static string GetServicing_UWCandidateForSendMail(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetServicing_UWCandidateForSendMail(FromDate, ToDate);
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


        #endregion

        protected void btnMailSer_Click(object sender, EventArgs e)
        {
            string AppIDs = Convert.ToString(Request.Form["emailappidser"]);
            string[] AppIDList;
            AppIDList = AppIDs.Split(',');
            foreach (string AppID in AppIDList)
            {

                if (AppID != "")
                {
                    DataTable dt = new bllRequisition().GetApplicantInfo(Convert.ToInt32(AppID));
                    StringBuilder head = new StringBuilder();
                    StringBuilder body = new StringBuilder();
                    StringBuilder footer = new StringBuilder();
                    string ToAddress = Convert.ToString(dt.Rows[0]["EmailID"]);
                    string ToBCC = "n.nilkanth@infinityinternationals.us,g.trupti@infinityinternationals.us";
                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:Verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:22px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                        "<table border=\"0\" style=\"width:800px;font-family:Verdana; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                        "<tr><td style=\"text-align:left; font-size:12px;\"><b>Hello " + Convert.ToString(dt.Rows[0]["FirstName"]) + ",<br /><br /></b></td></tr>");
                    body.Append("<tr><td>Please <a href='http://103.139.68.133/Servicing/UWQuestionPaper_Servicing.aspx?AppID=" + AppID + "'>click here </a> to take the test. Once you have completed the test, please let us know.</td></tr>");
                    body.Append("<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity</td></tr>" +
                            "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                            "</table>");
                    footer.Append("</body></html>");

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Online Test Notification", System.Text.Encoding.UTF8);
                    mail.To.Add(ToAddress);
                    mail.Bcc.Add(ToBCC);
                    mail.Subject = "Infinity IPS - Online Test Link";
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
                        Hashtable htParam = new Hashtable();
                        htParam.Add("ApplicationID", Convert.ToInt32(AppID));
                        new bllRequisition().InsertCredit_UWQUestionnaire(htParam);
                    }
                    catch { }
                }
            }
            //up1.Update();
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Test link sent successfully!');", true);
        }
    }
}