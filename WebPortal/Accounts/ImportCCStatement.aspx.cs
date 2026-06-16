using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
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

namespace WebPortal.Accounts
{
    public partial class ImportCCStatement : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = Server.MapPath(@"~\Statements");
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


                string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
                string filename = Convert.ToString(Request.Files["import_attach"].FileName);
            }
            catch { }
        }

        [WebMethod]
        public static int VerifyAndImport(string Month, string Year)
        {
            //           string Month = Convert.ToString(HttpContext.Current.Request.Form["hr_month"]);
            int returnvalue = 0;
            if (!Directory.Exists(FolderPath))
            {
                Directory.CreateDirectory(FolderPath);
            }
            string SubPath = FolderPath + "\\" + Convert.ToString(DateTime.Now.ToString("dd-MMM-yyyy"));
            if (!Directory.Exists(SubPath))
            {
                Directory.CreateDirectory(SubPath);
            }
            string UniquePath = SubPath + "\\" + DateTime.Now.ToString("hhmmss");
            if (!Directory.Exists(UniquePath))
            {
                Directory.CreateDirectory(UniquePath);
            }
            string FileName = UniquePath + "\\" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);
            File.Copy(NewFileName, FileName);
            string Extn = FileName.Substring(FileName.LastIndexOf(".") + 1);
            string ConExcel;
            if (Extn == "xls" | Extn == "xlsx")
            {
                if (Extn.Contains("xlsx"))
                {
                    ConExcel = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + FileName + "; Extended Properties=\"Excel 12.0;HDR=YES;IMEX=1\"";
                }
                else
                {
                    ConExcel = "Provider=Microsoft.Jet.OLEDB.4.0;" + "Data Source=" + FileName + "; Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\"";
                }
                DataSet dsExcel = new DataSet();
                DataTable Dt = new DataTable("[Sheet1$]");
                using (OleDbConnection myExcelConnection = new OleDbConnection(ConExcel))
                {
                    //myExcelConnection.Open();

                    string sqlExcel = "";
                    sqlExcel = "Select * from [Sheet1$]";
                    OleDbDataAdapter daExcel = new OleDbDataAdapter(sqlExcel, myExcelConnection);
                    daExcel.Fill(dsExcel);
                    daExcel.Dispose();
                    Dt = dsExcel.Tables[0];
                    if (myExcelConnection.State == ConnectionState.Open)
                    {
                        myExcelConnection.Close();
                    }
                }
                if (Dt != null)
                {
                    if (Dt.Rows.Count > 0)
                    {
                        for (int i = 0; i < Dt.Rows.Count; i++)
                        {
                            string Description = Convert.ToString(Dt.Rows[i]["Description"]);
                            decimal Amount = Convert.ToDecimal(Dt.Rows[i]["Amount"]);
                            string CardNumber = Convert.ToString(Dt.Rows[i]["CardNumber"]);
                            string TransactionDate = Convert.ToString(Dt.Rows[i]["TransactionDate"]);
                            int returnv = new bllMaster().GetCCInvoiceImportDetails(Month, Year, Description, Amount, CardNumber, TransactionDate);
                        }
                    }
                }
                returnvalue = 1;
            }
            return returnvalue;
        }

        [WebMethod]
        public static string GetCCDataForVerification(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetCCDataForVerification(Month, Year);
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
        public static int SendEmailToConcernDepartment(int EmployeeID, string VerIDs, string Month, string Year)
        {
            int returnvalue = 0;
            string ToAddress = string.Empty;
            if(EmployeeID == 209)
            {
                ToAddress = "mdk@infinity-data.com";
            }
            if (EmployeeID == 9852)
            {
                ToAddress = "y.raphael@infinity-data.com";
            }

            string[] Veridlist = VerIDs.Split(',');
            if (Veridlist.Length > 0)
            {
                StringBuilder emailbody = new StringBuilder();
                emailbody.Append("<html><head></head><body><table border=\"0\" style=\"width:800px;font-family:'Aptos Narrow'; font-size:13px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">");
                emailbody.Append("<tr><td colspan=\"4\">Hello Team,<br /><br />Please explain the purpose of the charges listed below.</td></tr></table>");
                emailbody.Append("<table border=\"1\" style=\"width:800px;font-family:'Aptos Narrow'; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\"><tr><th>Date</th><th>Transations</th><th>CC Name</th><th>Amount</th><th>System Remark</th></tr>");
                for (int i = 0; i < Veridlist.Length; i++)
                {
                    if (Convert.ToString(Veridlist[i]) != "")
                    {
                        DataTable dt = new bllMaster().GetStatementDetailsByID(Convert.ToInt32(Veridlist[i]), Month, Year);
                        if (dt != null)
                        {
                            if (dt.Rows.Count > 0)
                            {
                                string Header = Convert.ToString(dt.Rows[0]["StatementHeader"]);
                                string Amount = Convert.ToString(dt.Rows[0]["StatementAmount"]);
                                string TransactionDate = Convert.ToString(dt.Rows[0]["Date1"]);
                                string CardNumber = Convert.ToString(dt.Rows[0]["CardNumber"]);
                                string SystemRemark = Convert.ToString(dt.Rows[0]["SystemRemark"]);

                                emailbody.Append("<tr>");
                                emailbody.Append("<td>" + TransactionDate + "</td><td>" + Header + "</td><td>" + CardNumber + "</td><td>" + Amount + "</td><td>" + SystemRemark + "</td>");
                                emailbody.Append("</tr>");
                            }
                        }
                    }
                }
                emailbody.Append("</table><table border=\"0\" style=\"width:800px;font-family:'Aptos Narrow'; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\"><tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                 "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                 "</table>");
                emailbody.Append("</body></html>");
                Hashtable htParam = new Hashtable();
                htParam.Add("Employee", EmployeeID);
                htParam.Add("Body", emailbody.ToString());

                string Pass = new bllMaster().GetPassword("ackdata");

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("ack@infinity-data.com", "CC Notifications", System.Text.Encoding.UTF8);
                mail.To.Add(ToAddress);
                mail.CC.Add("anita@infinty-data.com");
                mail.Bcc.Add("n.nilkanth@infinityinternationals.us");
                mail.Subject = "CC Explaination - " + Month + "-" + Year;
                mail.Body = emailbody.ToString();
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
                }
                catch { }
            }
            return 1;
        }

        [WebMethod]
        public static int InsertAccountsRemark(int VerID, string Remark,string PaidDate, string Month, string Year)
        {
            int returnvalue = 0;
            returnvalue = new bllMaster().InsertAccountRemarkforCC(VerID, Remark, PaidDate, Month, Year);
            return returnvalue;
        }

        [WebMethod]
        public static int FinalVerifyStatement(string Month, string Year)
        {
            int returnvalue = 0;
            returnvalue = new bllMaster().FinalVerifyCCStatement(Month, Year);
            return returnvalue;
        }
    }
}