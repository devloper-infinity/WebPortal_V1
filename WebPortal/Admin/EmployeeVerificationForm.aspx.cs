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
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class EmployeeVerificationForm : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static string SubPath = "";
        static string attachedFileName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = Server.MapPath(@"~\EmployeeDocuments\EmploymentVerification");
            try
            {
                HttpContext postedContext = HttpContext.Current;
                HttpPostedFile file = postedContext.Request.Files[0];

                string name = file.FileName;
                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0,
                (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;

                attachedFileName = name;
                string file_Name = name;// Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                GUIDFile = file_Name;
                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
                string filename = Convert.ToString(Request.Files["ExEmpForm_attachment"].FileName);
            }
            catch { }
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

        [WebMethod]
        public static int InsertVerificationInformation(int EmployeeID, string CandidateName, string EmployeeCode, string Salary, string CompanyName, string EmployeePeriod, string Designation, string ReportingManagerName,
            string ReportingManagerDesignation, string ReportingManagerContact, string HRName, string HRContact, string ReasonforLeaving, string ExitFormality, string Eligibilitytorehire, string VerifiedBy, string ReceiverEmail, string DutiesAndResponsibilitiesl)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            string FilePath = "";

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

            if (NewFileName != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                SubPath = FolderPath + "\\" + Convert.ToString(EmployeeID);
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                File.Copy(NewFileName, SubPath + "\\" + GUIDFile);
                htParam.Add("Attachment", SubPath + "\\" + GUIDFile);
            }
            else
            {
                htParam.Add("Attachment", "");
            }
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertEmployeePreVerificationInfo(htParam);
           
            if (returnvalue > 0)
            {
                int returnemil = SendVerificationEmail(EmployeeID, CandidateName, EmployeeCode, Salary, CompanyName, EmployeePeriod, Designation, ReportingManagerName, ReportingManagerDesignation, ReportingManagerContact, HRName, HRContact, ReasonforLeaving, ExitFormality, Eligibilitytorehire, VerifiedBy, ReceiverEmail);
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
            int returnvalue = 0;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            head.Append("<html><head></head><body>");
            body.Append("" +
                "<table border=\"0\" style=\"width:1000px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear HR Team,</b><br /><br />Greetings from “Infinity Data Technologies Pvt. Ltd. “" +
                "<br /><br />Hope you are all doing well." +
            "<br /><br />As a part of our joining process, we carry out a Reference Check of the candidate from his/her Previous Employer. " +
            "<br /><br />One of your ex-employee <b>\"" + Convert.ToString(CandidateName) + "\"</b> who worked with your esteemed organization has provided us the below mentioned details under the head \"<i>Details provided by Candidate</i> \"." +
            "<br /<br />We would request you to verify the following details and mention remarks form your end in the last column under the Head \"<i>Details Provided By Company</i>\" for end-to-end verification; which in turn helps us to on-board the candidate as soon as possible.</td></tr>" +

            "<tr><td style=\"border:solid 1px Gray; text-align:center;\"><center><b>Particulars</b></center></td><td style=\"border:solid 1px Gray; text-align:center;\"><center><b>Details Provided By Candidate</b></center></td><td style=\"border:solid 1px Gray; text-align:center;\"><center><b>Details Provided By Company</b></center></td></tr>" +

            "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Name of Organization:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(CompanyName) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Employee ID/Code:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(EmployeeCode) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Designation) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Period of Employment:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(EmployeePeriod) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Salary:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Salary) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager’s Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ReportingManagerName) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager’s Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ReportingManagerDesignation) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Contact No. & E-Mail - Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ReportingManagerContact) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name of HR:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(HRName) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Contact No. & E-Mail - HR:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(HRContact) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason for Leaving the Organization:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ReasonforLeaving) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Any Exit Formalities Pending (YES/NO):</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ExitFormality) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Eligible for rehire (Based on job performance) <br />(If No, please Specify Reason):</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Eligibilitytorehire) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Verified by (Name & Designation):</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(VerifiedBy) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +

            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"3\"><br /><br />" +
            "It would be very helpful if you can confirm the above details claimed by the candidate.<br />Your co-operation in this regard is highly appreciated.<br />Have A Great Day Ahead!!!!<br /><br />Regards,<br />HR Team <br />Infinity Data Technologies Pvt. Ltd.</td></tr>" +
            "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"3\"><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +

            "</table>");
            footer.Append("</body></html>");

            string Pass = new bllMaster().GetPassword("Verification");

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("verification@infinityinternationals.us", "Employment Verification", System.Text.Encoding.UTF8);
            // mail.To.Add("n.nilkanth@infinityinternationals.us,b.shubhangi@infinityinternationals.us"); //("n.nilkanth@infinityinternationals.us");
            // mail.CC.Add("n.nilkanth@infinityinternationals.us");//,b.shubhangi@infinityinternationals.us");
            mail.To.Add(ReceiverEmail);
            mail.CC.Add("k.sagar@infinity-data.com,j.rucha@infinityinternationals.us,g.trupti@infinityinternationals.us");
            mail.Bcc.Add("n.nilkanth@infinityinternationals.us,b.shubhangi@infinityinternationals.us");
            mail.Subject = "Ex Employer Verification – Infinity Data Technologies Pvt. Ltd. – " + CandidateName;
            mail.Body = head.ToString() + body.ToString() + footer.ToString();
            mail.IsBodyHtml = true;
            if (NewFileName != "")
            {
                mail.Attachments.Add(new Attachment(SubPath + "\\" + GUIDFile));
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
    }
}