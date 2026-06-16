using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class EmployeeVerificationReport : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static string SubPath = "";
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

                string file_Name = name;//Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                GUIDFile = file_Name;
                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
                string filename = Convert.ToString(Request.Files["ExEmpResend_attachment"].FileName);
            }
            catch { }
        }

        [WebMethod]
        public static string GetExEmployerVerification(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetExEmployerVerificationRecords(Month, Year);
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
        public static int InsertIsVerificationRequired(int VerificationID, string Required, string Remark)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("VerificationID", VerificationID);
            htParam.Add("BGVRequired", Required);
            htParam.Add("Remark", Remark);

            returnvalue = new bllMaster().InsertIsVerificationRequried(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int ResendVerificationEmail(int VerificationID, string Receiver)
        {
            int returnvalue = 0;
            DataTable dt = new bllMaster().GetEmployeeVerificationRecordsByVerificationID(VerificationID);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    try
                    {
                        if (NewFileName != "")
                        {
                            if (!Directory.Exists(FolderPath))
                            {
                                Directory.CreateDirectory(FolderPath);
                            }

                            SubPath = FolderPath + "\\" + Convert.ToString(dt.Rows[0]["EmployeeID"]);

                            if (!Directory.Exists(SubPath))
                            {
                                Directory.CreateDirectory(SubPath);
                            }

                            if (!File.Exists(SubPath + "\\" + GUIDFile))
                            {
                                File.Copy(NewFileName, SubPath + "\\" + GUIDFile);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        returnvalue = -1;
                        return returnvalue;
                    }

                    StringBuilder head = new StringBuilder();
                    StringBuilder body = new StringBuilder();
                    StringBuilder footer = new StringBuilder();

                    head.Append("<html><head></head><body>");
                    body.Append("" +
                        "<table border=\"0\" style=\"font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                        "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear HR Team,</b><br /><br />Greetings from “Infinity Data Technologies Pvt. Ltd. “" +
                        "<br /><br />Hope you are all doing well." +
                    "<br /><br />As a part of our joining process, we carry out a Reference Check of the candidate from his/her Previous Employer. " +
                    "<br /><br />One of your ex-employee <b>\"" + Convert.ToString(dt.Rows[0]["CandidateName"]) + "\"</b> who worked with your esteemed organization has provided us the below mentioned details under the head \"<i>Details provided by Candidate</i> \"." +
                    "<br /<br />We would request you to verify the following details and mention remarks form your end in the last column under the Head \"<i>Details Provided By Company</i>\" for end-to-end verification; which in turn helps us to on-board the candidate as soon as possible.</td></tr>" +

                    "<tr><td style=\"border:solid 1px Gray; text-align:center;\"><center><b>Particulars</b></center></td><td style=\"border:solid 1px Gray; text-align:center;\"><center><b>Details Provided By Candidate</b></center></td><td style=\"border:solid 1px Gray; text-align:center;\"><center><b>Details Provided By Company</b></center></td></tr>" +

                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b>Name of Organization:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["CompanyName"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Employee ID/Code:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["EmployeeCode"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["LastDesignation"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Period of Employment:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["EmploymentPeriod"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Salary:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Salary"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager’s Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingPersonName"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager’s Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingPersonDesignation"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Contact No. & E-Mail - Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingPersonContact"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name of HR:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["HRName"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Contact No. & E-Mail - HR:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["HRContact"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason for Leaving the Organization:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReasonforLiving"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Any Exit Formalities Pending (YES/NO):</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["PendingExitFormalities"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Eligible for rehire (Based on job performance) <br />(If No, please Specify Reason):</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["EligibilityToRehire"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Verified by (Name & Designation):</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["VerifiedBy"]) + " </td><td style=\"border:solid 1px Gray;border-top:none;\" width=\"120px\"><b> - </b></td></tr>" +

                    "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"3\"><br /><br />" +
                    "It would be very helpful if you can confirm the above details claimed by the candidate.<br />Your co-operation in this regard is highly appreciated.<br />Have A Great Day Ahead!!!!<br /><br />Regards,<br />HR Team <br />Infinity Data Technologies Pvt. Ltd.</td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"3\"><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +

                    "</table>");
                    footer.Append("</body></html>");

                    string Pass = new bllMaster().GetPassword("Verification");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("verification@infinityinternationals.us", "Employment Verification", System.Text.Encoding.UTF8);

                    //mail.To.Add("b.shubhangi@infinityinternationals.us");
                    //mail.CC.Add("n.nilkanth@infinityinternationals.us,b.shubhangi@infinityinternationals.us");

                    mail.To.Add(Receiver);
                    mail.CC.Add("k.sagar@infinity-data.com,j.rucha@infinityinternationals.us,g.trupti@infinityinternationals.us");
                    mail.Bcc.Add("n.nilkanth@infinityinternationals.us,b.shubhangi@infinityinternationals.us");

                    mail.Subject = "Ex Employer Verification – Infinity Data Technologies Pvt. Ltd. – " + Convert.ToString(dt.Rows[0]["CandidateName"]);
                    mail.Body = head.ToString() + body.ToString() + footer.ToString();
                    mail.IsBodyHtml = true;
                    if (NewFileName != "")
                    {
                        mail.Attachments.Add(new Attachment(SubPath + "\\" + GUIDFile));
                        GUIDFile = "";
                    }
                    mail.Priority = System.Net.Mail.MailPriority.High;
                    SmtpClient client = new SmtpClient();
                    client.Credentials = new System.Net.NetworkCredential("verification@infinityinternationals.us", Pass);
                    client.Host = "smtp3.netcore.co.in";
                    try
                    {
                        client.Send(mail);
                        returnvalue = 1;
                        Hashtable htVerify = new Hashtable();
                        htVerify.Add("VerificationID", Convert.ToInt32(VerificationID));
                        htVerify.Add("SenderID", Receiver);
                        htVerify.Add("MailSendBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        int ReturnValue = new bllMaster().InsertEmployeeVerificationEmailDetails(htVerify);
                        NewFileName = "";
                    }
                    catch (Exception ex) { return 0; }
                }
            }
            return returnvalue;
        }
    }
}