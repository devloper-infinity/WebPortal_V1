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
using System.Globalization;
using System.Text.RegularExpressions;


namespace WebPortal.IT
{
    public partial class InvoiceVerification : System.Web.UI.Page
    {
        static SqlConnection con = new SqlConnection("Data Source=23.111.175.186;Initial Catalog=InfinityERP;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192");
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string getAllInvocieHeaders(string Month, string Year, string Domain)
        {
            DataTable dt1 = new bllMaster().GetAllInvoiceHeaders(Month, Year, Domain);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        object value = dr.IsNull(col) ? null : dr[col];
                        if (value is DateTime && (string.Equals(col.ColumnName, "BillingDate", StringComparison.OrdinalIgnoreCase)
                            || string.Equals(col.ColumnName, "EffectiveDate", StringComparison.OrdinalIgnoreCase)
                            || string.Equals(col.ColumnName, "DisabledDate", StringComparison.OrdinalIgnoreCase)))
                            value = ((DateTime)value).ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
                        row.Add(col.ColumnName, value);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetInvoiceDomains()
        {
            DataTable domains = new bllMaster().GetInvoiceDomains();
            List<string> values = new List<string>();
            if (domains != null)
                foreach (DataRow row in domains.Rows)
                {
                    string domain = Convert.ToString(row["DomainName"]).Trim();
                    if (domain.Length > 0) values.Add(domain);
                }
            return new JavaScriptSerializer().Serialize(values);
        }

        [WebMethod]
        public static string GetInvoiceProjects()
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (HttpContext.Current.User != null && HttpContext.Current.User.Identity.IsAuthenticated)
            {
                DataTable projects = new bllMaster().GetAllProjectByUserRights(HttpContext.Current.User.Identity.Name);
                if (projects != null && projects.Columns.Contains("ProjectID") && projects.Columns.Contains("ProjectName"))
                    foreach (DataRow row in projects.Rows)
                        rows.Add(new Dictionary<string, object> { { "ProjectID", row["ProjectID"] }, { "ProjectName", row["ProjectName"] } });
            }
            return new JavaScriptSerializer().Serialize(rows);
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
        public static int InsertCCMonthlyData(int HeaderID, string Month, string Year, string Remark, string InvoiceNo, string InvoiceAmount, string Utilization, string Difference, string CCNo, string BillingDate)
        {
            int result = SaveInvoiceRow(HeaderID, Month, Year, Remark, InvoiceNo, InvoiceAmount, Utilization, Difference, CCNo, BillingDate, ExistingInvoiceAttachment(HeaderID, Month, Year));
            if (result > 0)
                SendEmail_InvoiceNotification(HeaderID, Month, Year);
                return result;
        }

        private static string ExistingInvoiceAttachment(int headerID, string month, string year)
        {
            DataTable existing = new bllMaster().DownloadInvoice(headerID, month, year);
            if (existing == null) throw new InvalidOperationException("Unable to read the existing invoice. Please retry.");
            return existing.Rows.Count > 0 && existing.Columns.Contains("Attachment") ? Convert.ToString(existing.Rows[0]["Attachment"]) : "";
        }

        private static int SaveInvoiceRow(int HeaderID, string Month, string Year, string Remark, string InvoiceNo, string InvoiceAmount, string Utilization, string Difference, string CCNo, string BillingDate, string attachment)
        {
            if (HttpContext.Current.User == null || !HttpContext.Current.User.Identity.IsAuthenticated)
                throw new InvalidOperationException("Please sign in again.");
            DateTime date;
            if (!DateTime.TryParseExact(BillingDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date))
                throw new InvalidOperationException("Please enter a valid Billing Date.");
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("HeaderID", HeaderID);
            htParam.Add("Month", Month);
            htParam.Add("Year", Year);
            htParam.Add("Remark", Remark);
            htParam.Add("InvoiceNo", InvoiceNo);
            htParam.Add("InvoiceAmount", InvoiceAmount);
            htParam.Add("CreditCard", CCNo);
            htParam.Add("BillingDate", date);
            htParam.Add("Attachment", attachment);
            htParam.Add("Utilization", Utilization);
            htParam.Add("Difference", Difference);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertCCInvoiceMonthlyData(htParam);

            return returnvalue;
        }

        public static object SaveInvoiceMonthlyRequest(HttpContext context)
        {
            string savedPath = null;
            bool saved = false;
            try
            {
                int headerID;
                if (context.User == null || !context.User.Identity.IsAuthenticated)
                    throw new InvalidOperationException("Please sign in again.");
                if (!int.TryParse(context.Request.Form["HeaderID"], out headerID) || headerID <= 0)
                    throw new InvalidOperationException("Select a valid invoice.");
                string month = context.Request.Form["Month"] ?? "", year = context.Request.Form["Year"] ?? "";
                DateTime period, billingDate;
                if (!DateTime.TryParseExact("01 " + month + " " + year, "dd MMMM yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out period))
                    throw new InvalidOperationException("Please select a specific invoice month and year.");
                if (!DateTime.TryParseExact(context.Request.Form["BillingDate"], "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out billingDate))
                    throw new InvalidOperationException("Please enter a valid Billing Date.");
                string amount = context.Request.Form["InvoiceAmount"] ?? "";
                decimal parsedAmount;
                if (!decimal.TryParse(amount, NumberStyles.Number, CultureInfo.InvariantCulture, out parsedAmount) || parsedAmount < 0)
                    throw new InvalidOperationException("Please enter a valid invoice amount.");
                string ccNo = (context.Request.Form["CCNo"] ?? "").Trim();
                if (ccNo.Length == 0 || ccNo.Length > 100) throw new InvalidOperationException("Please select a valid credit card.");
                if (string.IsNullOrWhiteSpace(new bllMaster().GetInvoiceHeaderName(headerID)))
                    throw new InvalidOperationException("Invoice was not found.");
                string attachment = ExistingInvoiceAttachment(headerID, month, year);
                HttpPostedFile file = context.Request.Files["InvoiceFile"];
                if (file != null && !string.IsNullOrEmpty(file.FileName))
                {
                    if (file.ContentLength <= 0 || file.ContentLength > 10 * 1024 * 1024)
                        throw new InvalidOperationException("Choose a non-empty file up to 10 MB.");
                    string name = Path.GetFileName(file.FileName), extension = Path.GetExtension(name).ToLowerInvariant();
                    if (!Regex.IsMatch(extension, @"^\.(pdf|png|jpe?g|docx?|xlsx?)$"))
                        throw new InvalidOperationException("Choose a PDF, image, Word or Excel file.");
                    ValidateInvoiceFile(file, extension);
                    string baseName = Regex.Replace(Path.GetFileNameWithoutExtension(name), @"[^A-Za-z0-9_-]", "_");
                    if (baseName.Length > 80) baseName = baseName.Substring(0, 80);
                    if (baseName.Length == 0) baseName = "Invoice";
                    string relativeFolder = "InvoiceDocuments/" + period.ToString("yyyy-MM", CultureInfo.InvariantCulture) + "/" + headerID;
                    string directory = context.Server.MapPath("~/App_Data/" + relativeFolder);
                    Directory.CreateDirectory(directory);
                    string storedName = baseName + "_" + Guid.NewGuid().ToString("N") + extension;
                    savedPath = Path.Combine(directory, storedName);
                    file.SaveAs(savedPath);
                    attachment = relativeFolder + "/" + storedName;
                }
                int result = SaveInvoiceRow(headerID, month, year, context.Request.Form["Remark"], context.Request.Form["InvoiceNo"], amount,
                    context.Request.Form["Utilization"], context.Request.Form["Difference"], ccNo, billingDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture), attachment);
                if (result <= 0) throw new InvalidOperationException("Invoice was not saved. Please retry.");
                saved = true;
                SendEmail_InvoiceNotification(headerID, month, year);
                return new { success = true, message = "Invoice saved successfully." };
            }
            catch (Exception ex)
            {
                if (!saved && savedPath != null)
                {
                    try { File.Delete(savedPath); } catch { }
                }
                if (saved) return new { success = true, message = "Invoice saved successfully." };
                return new { success = false, message = ex is InvalidOperationException ? ex.Message : "Unable to save the invoice. Please contact support." };
            }
        }

        private static void ValidateInvoiceFile(HttpPostedFile file, string extension)
        {
            byte[] signature = new byte[8];
            int count = file.InputStream.Read(signature, 0, signature.Length);
            file.InputStream.Position = 0;
            bool zip = count >= 4 && signature[0] == 0x50 && signature[1] == 0x4b && signature[2] == 0x03 && signature[3] == 0x04;
            bool office = count >= 8 && signature[0] == 0xd0 && signature[1] == 0xcf && signature[2] == 0x11 && signature[3] == 0xe0 && signature[4] == 0xa1 && signature[5] == 0xb1 && signature[6] == 0x1a && signature[7] == 0xe1;
            bool valid = extension == ".pdf" && count >= 4 && signature[0] == 0x25 && signature[1] == 0x50 && signature[2] == 0x44 && signature[3] == 0x46
                || extension == ".png" && count >= 8 && signature[0] == 0x89 && signature[1] == 0x50 && signature[2] == 0x4e && signature[3] == 0x47 && signature[4] == 0x0d && signature[5] == 0x0a && signature[6] == 0x1a && signature[7] == 0x0a
                || (extension == ".jpg" || extension == ".jpeg") && count >= 3 && signature[0] == 0xff && signature[1] == 0xd8 && signature[2] == 0xff
                || (extension == ".docx" || extension == ".xlsx") && zip
                || (extension == ".doc" || extension == ".xls") && office;
            if (!valid) throw new InvalidOperationException("The selected file content does not match its file type.");
        }

        [WebMethod]
        public static int InsertCCDetails(int HeaderID, string Code, string OtherUser, string EffectiveDate)
        {
            int returnvalue = 0;

            string emailAddress = string.Empty;
            DataTable employees = new bllMaster().GetAllUsers_1();
            if (!string.Equals(Code, "Other", StringComparison.OrdinalIgnoreCase) && employees != null && employees.Columns.Contains("Code"))
            {
                DataRow employee = employees.AsEnumerable().FirstOrDefault(row => string.Equals(Convert.ToString(row["Code"]).Trim(), (Code ?? string.Empty).Trim(), StringComparison.OrdinalIgnoreCase));
                if (employee != null)
                {
                    string[] emailColumns = { "EmailAddress", "Email", "EmailID", "OfficialEmail" };
                    string emailColumn = emailColumns.FirstOrDefault(employees.Columns.Contains);
                    if (emailColumn != null && employee[emailColumn] != DBNull.Value) emailAddress = Convert.ToString(employee[emailColumn]).Trim();
                }
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("HeaderID", HeaderID);
            htParam.Add("Code", Code);
            htParam.Add("OtherUser", OtherUser);
            htParam.Add("EmailAddress", emailAddress);
            htParam.Add("EffectiveDate", EffectiveDate);

            returnvalue = new bllMaster().InsertCCDetails(htParam);

            return returnvalue;
        }

        [WebMethod]
        public static int InsertCCInvoiceHeaders(string Header, string Domain, string Product, string PayTo, string PaymentFreq, string CostType, string EffectiveDate, string ContQuantity, string ContPerUnitCost, string ChargeableAmt, string ContractualUsage)
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
            htParam.Add("ContractualUsage", ContractualUsage);
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

                    //ToAddress = "b.shubhangi@infinity-data.com";
                    //ToCC = "b.shubhangi@infinity-data.com";
                    //ToBCC = "b.shubhangi@infinity-data.com";

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
