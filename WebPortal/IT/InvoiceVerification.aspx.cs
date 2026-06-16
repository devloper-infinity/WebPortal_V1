using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using System.Net.Mail;
using System.Data.SqlClient;
using System.Text;


namespace WebPortal.IT
{
    public partial class InvoiceVerification : System.Web.UI.Page
    {
        static SqlConnection con = new SqlConnection("Data Source=23.111.175.186;Initial Catalog=InfinityERP;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192");
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static string SubPath = "";
        protected void Page_Load(object sender, EventArgs e)
        {

            // SendEmail_InvoiceNotification(1, "March", "2025");

            FolderPath = Server.MapPath(@"~\InvoiceDocs");
            try
            {
                NewFileName = "";
                HttpContext postedContext = HttpContext.Current;
                HttpPostedFile file = postedContext.Request.Files[0];

                string name = file.FileName;
                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0,
                (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;

                string file_Name = name.Replace(ext, "") + "_" + DateTime.Now.ToString("ddMMyyyyhhmmss") + ext;
                GUIDFile = file_Name;
                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
            }
            catch { }
        }

        [WebMethod]
        public static string getAllInvocieHeaders(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetAllInvoiceHeaders(Month, Year);
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
        public static string GetHeaderwiseDetails(int HeaderID)
        {
            DataTable dt1 = new bllMaster().GetHeaderwiseDetails(HeaderID);
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
        public static string GetHeaderwiseDetailsRevised(int HeaderID, string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetHeaderwiseDetailsRevised(HeaderID, Month, Year);
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
        public static int InsertCCMonthlyData(int HeaderID, string Month, string Year, string Remark, string InvoiceNo, string InvoiceAmount, string Utilization, string Difference)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("HeaderID", HeaderID);
            htParam.Add("Month", Month);
            htParam.Add("Year", Year);
            htParam.Add("Remark", Remark);
            htParam.Add("InvoiceNo", InvoiceNo);
            htParam.Add("InvoiceAmount", InvoiceAmount);
            if (NewFileName != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                string DatePath = FolderPath + "\\" + Month + "-" + Year;
                if (!Directory.Exists(DatePath))
                {
                    Directory.CreateDirectory(DatePath);
                }
                SubPath = DatePath + "\\" + Convert.ToString(HeaderID);
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
            htParam.Add("Utilization", Utilization);
            htParam.Add("Difference", Difference);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertCCInvoiceMonthlyData(htParam);

            if (returnvalue > 0)
            {
                SendEmail_InvoiceNotification(HeaderID, Month, Year);
            }

            return returnvalue;
        }

        [WebMethod]
        public static int InsertCCDetails(int HeaderID, string Code, string OtherUser, string EffectiveDate)
        {
            int returnvalue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("HeaderID", HeaderID);
            htParam.Add("Code", Code);
            htParam.Add("OtherUser", OtherUser);
            htParam.Add("EffectiveDate", EffectiveDate);

            returnvalue = new bllMaster().InsertCCDetails(htParam);

            return returnvalue;
        }

        [WebMethod]
        public static int InsertCCInvoiceHeaders(string Header, string Domain, string Product, string PayTo, string PaymentFreq, string CostType, string EffectiveDate, string ContQuantity, string ContPerUnitCost, string ChargeableAmt)
        {
            int returnvalue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("Header", Header);
            htParam.Add("Domain", Domain);
            htParam.Add("Product", Product);
            htParam.Add("Subscription", PaymentFreq);
            htParam.Add("CostType", CostType);
            htParam.Add("PayTo", PayTo);
            htParam.Add("EffectiveDate", EffectiveDate);
            htParam.Add("ContQuantity", ContQuantity);
            htParam.Add("ContPerUnitCost", ContPerUnitCost);
            htParam.Add("ChargeableAmt", ChargeableAmt);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue = new bllMaster().InsertCCInvoiceHeaders(htParam);

            return returnvalue;
        }

        [WebMethod]
        public static int DisabledCCHeader(int HeaderID, string Status, string DisabledRemark)
        {
            int returnvalue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("HeaderID", HeaderID);
            htParam.Add("IsDisable", Status);
            htParam.Add("DisabledRemark", DisabledRemark);
            htParam.Add("DisabledBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue = new bllMaster().DisabledCCHeader(htParam);

            return returnvalue;
        }

        [WebMethod]
        public static int RemoveCCUser(int InvID, string EffectiveDate)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("InvID", InvID);
            htParam.Add("EffectiveDate", EffectiveDate);
            returnvalue = new bllMaster().RemoveCCUser(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int SendEmail_InvoiceNotification(int HeaderID, string Month, string Year)
        {

            int returnValue = 0;
            try
            {
                string Subject = string.Empty;
                string ToAddress = string.Empty;
                string ToCC = string.Empty;
                string ToBCC = string.Empty;
                string FromMailAddress = string.Empty;
                StringBuilder head = new StringBuilder();
                StringBuilder body = new StringBuilder();
                StringBuilder footer = new StringBuilder();

                System.Text.StringBuilder htmlBody = new StringBuilder();
                DataTable dt = new bllMaster().GetAllCCInvoiceHeaders_ByHeaderID(HeaderID, Month, Year);

                if (dt.Rows.Count > 0)
                {
                    ToAddress = Convert.ToString(dt.Rows[0]["ToAddress"]);
                    ToCC = Convert.ToString(dt.Rows[0]["ToCC"]);
                    ToBCC = Convert.ToString(dt.Rows[0]["ToBCC"]);
                    FromMailAddress = Convert.ToString(dt.Rows[0]["FromMailAddress"]);

                    Subject = "IT Invoice - " + Convert.ToString(dt.Rows[0]["Header"]);

                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:biome; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                    body.Append("<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear Sir/Madam, <br />Below are Invoice details.<br /><br /></b></td></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"border:solid 1px Gray; width:100px!important;\" colspan=\"2\"><b>Employee Details</b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray; width:100px!important;\"><b>Header:</b></td><td style=\"border:solid 1px Gray;\">" + Convert.ToString(dt.Rows[0]["Header"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DomainName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Product:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Product"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Pay To:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["PayTo"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Contractual Quantity:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ContractualQuantity"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Contractual Per Unit Cost:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["PerUnit"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Chargeable Amount:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ContractualCost"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Current Quantity:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["CurrentQuantity"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Amount Charged:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ContractualCost1"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Difference:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Diff"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Remark"]) + "</td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:10px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                    footer.Append("</body></html>");
                    string Pass = new bllMaster().GetPassword("ack");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress(FromMailAddress, "Invoice Notification", System.Text.Encoding.UTF8);
                    //mail.To.Add("n.nilkanth@infinityinternationals.us");
                    mail.To.Add(ToAddress);
                    mail.CC.Add(ToCC);
                    mail.Bcc.Add(ToBCC);
                    mail.Subject = Subject;
                    mail.Body = head.ToString() + body.ToString() + footer.ToString();
                    mail.IsBodyHtml = true;
                    mail.Priority = System.Net.Mail.MailPriority.High;
                    SmtpClient client = new SmtpClient();
                    client.Credentials = new System.Net.NetworkCredential(FromMailAddress, Pass);
                    client.Host = "smtpcorp.netcore.co.in";
                    try
                    {
                        client.Send(mail);
                        return 1;
                    }
                    catch (Exception ex)
                    {
                        return 0;
                    }
                }
            }
            catch (Exception ex)
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                SqlCommand cmd1 = new SqlCommand("AddExeceptionMessage", con);
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.AddWithValue("@Message", ex.Message);
                cmd1.CommandTimeout = 0;
                cmd1.ExecuteNonQuery();
                con.Close();
            }
            return returnValue;
        }
    }
}