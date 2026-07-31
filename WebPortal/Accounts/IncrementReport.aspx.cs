using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
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
    public partial class IncrementReport : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string MainPath = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            MainPath = Server.MapPath(@"~\EmployeeDocuments");
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
                GUIDFile = file_Name;
                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
                //string filename = Convert.ToString(Request.Files["socialsite_attachment"].FileName);
            }
            catch
            {
            }
        }

        [WebMethod]
        public static string GetMnthlyIncrements(string Month, int Year)
        {
            DataTable dt1 = new bllSalary().GetAllIncrementForReport(Month, Year);
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
        public static string GetAllIncrementDifference(string Month, int Year)
        {
            DataTable dt1 = new bllSalary().GetAllIncrementDifferenceForReport(Month, Year);
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
        public static string GetAllCodes()
        {
            DataTable dt1 = new bllMaster().GetAllCode();
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
        public static string GetUserInfo(string Code)
        {
            int EmloyeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt1 = new bllLogin().GetUserInformation(EmloyeeID);
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
        public static int InsertIncrement(string Code, string EffectiveMonth, int EffectiveYear, int CurrentSalary, int IncrementedAmount, string Remark, string isAttBonus, int AttBonusAmount, string isRetentionBonus, int RetentionBonus, string RetentionPeriod, string RetentionMonth, string RetentionYear, string NextDueMonth, int NextDueYear)
        {
            int returnvalue = 0;
            decimal Perc = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("Code", Code);
            htParam.Add("Month", EffectiveMonth);
            htParam.Add("Year", EffectiveYear);
            htParam.Add("CurrentSalary", IncrementedAmount);
            string DiffAmount = Convert.ToString(IncrementedAmount - CurrentSalary);
            htParam.Add("Amount", Convert.ToString(DiffAmount));
            htParam.Add("Remark", Remark);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("AddedIP", "23.111.175.186");
            htParam.Add("ApprovalOf", 8128);
            if (isAttBonus == "Yes")
            {
                htParam.Add("AttendanBonusType", isAttBonus);
                htParam.Add("AttendanBonus", AttBonusAmount);
            }
            else
            {
                htParam.Add("AttendanBonusType", isAttBonus);
                htParam.Add("AttendanBonus", Convert.ToInt32(0));
            }
            htParam.Add("QualityBonus", Convert.ToInt32(0));
            htParam.Add("IsRetentionBonusApplicable", isRetentionBonus == "Yes" ? true : false);
            htParam.Add("RetentionBonus", Convert.ToString(RetentionBonus) == "" ? 0 : RetentionBonus);
            htParam.Add("RetentionBonusPeriod", RetentionPeriod);
            htParam.Add("RetentionBonusMonth", RetentionMonth);
            htParam.Add("RetentionBonusYear", RetentionYear);
            if (NewFileName != "")
            {
                if (!Directory.Exists(MainPath))
                {
                    Directory.CreateDirectory(MainPath);
                }
                string SubPath = MainPath + "\\" + Code;
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                string UniquePath = MainPath + "\\" + Code + "\\" + "Confidential";
                if (!Directory.Exists(UniquePath))
                {
                    Directory.CreateDirectory(UniquePath);
                }
                File.Copy(NewFileName, UniquePath + "\\" + GUIDFile);
                File.Delete(NewFileName);
                htParam.Add("Attachment", UniquePath + "\\" + GUIDFile);
            }
            else
                htParam.Add("Attachment", "");

            htParam.Add("NextDueMonth", NextDueMonth);
            htParam.Add("NextDueYear", NextDueYear);
            string AddedByName = "";
            DataTable dtAddedBy = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtAddedBy.Rows.Count > 0)
            {
                AddedByName = Convert.ToString(dtAddedBy.Rows[0]["Code"]) + " : " + Convert.ToString(dtAddedBy.Rows[0]["FirstName"]) + " " + Convert.ToString(dtAddedBy.Rows[0]["MiddleName"]) + " " + Convert.ToString(dtAddedBy.Rows[0]["LastName"]);
            }
            htParam.Add("AddedByName", AddedByName);
            Perc = Convert.ToDecimal(DiffAmount) / Convert.ToDecimal(CurrentSalary);
            Perc = Math.Round(Perc * 100, 2);
            htParam.Add("Percentage", Convert.ToDecimal(Perc));
            returnvalue = new bllSalary().InsertIncrement(htParam);
            if (returnvalue > 1)
            {
                SendIncrementEmail(Code, htParam);
            }
            return returnvalue;
        }

        [WebMethod]
        public static int SendIncrementEmail(string Code, Hashtable htParam)
        {
            int returnvalue = 0;
            string To = "";
            string CC = "";
            string BCC = "";
            string contentHeader = "";
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt = new bllLogin().GetUserInformation(EmployeeID);

            string Subject = "Increment added for user " + Code;
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    DataTable dt1 = new bllMaster().getEmailConfigrationInfo("Increment Other");
                    if (dt1.Rows.Count > 0)
                    {
                        //To = dt1.Rows[0][2].ToString();
                        //CC = Convert.ToString(dt1.Rows[0][3]);
                        //BCC = Convert.ToString(dt1.Rows[0][4]);
                        To = "n.nilkanth@infinityinternationals.us";
                        BCC = "n.nilkanth@infinityinternationals.us";
                        head.Append("<html><head></head><body>");
                        body.Append("<table style=\"width:802px;font-family:biome; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                        body.Append("<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                                "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />Increment of amount Rs. " + htParam["Amount"] + " has been added for " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["lastName"]) + " for " + htParam["Month"] + " " + htParam["Year"] + "<br /><br /></b></td></tr></table>" +
                                "<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                                "<tr><td style=\"border:solid 1px Gray; width:100px!important;\" colspan=\"2\"><b>Employee Details</b></td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray; width:100px!important;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;\">" + Convert.ToString(dt.Rows[0]["CodeName"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["SubDomain"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\" colspan=\"2\"><b>Increment Details:</b></td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Salary Before Increment:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Salary"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Increment Percentage:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["Percentage"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Salary After Increment:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["CurrentSalary"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Next Increment Due Month-Year:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["NextDueMonth"]) + " - " + Convert.ToString(htParam["NextDueYear"]) + "</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Increment Added By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(htParam["AddedByName"]) + "</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                            "<tr><td style=\"text-align:left; font-size:10px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                            "</table>");
                        footer.Append("</body></html>");
                        string Pass = new bllMaster().GetPassword("ackdata");

                        MailMessage mail = new MailMessage();
                        mail.From = new MailAddress("ack@infinity-data.com", "Increment Notification", System.Text.Encoding.UTF8);
                        //mail.To.Add("n.nilkanth@infinityinternationals.us");
                        mail.To.Add(To);
                        if (CC != "")
                            mail.CC.Add(CC);
                        if (BCC != "")
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
                            client.Send(mail);
                            return 1;
                        }
                        catch { return 0; }
                    }
                }
            }

            return returnvalue;
        }

        [WebMethod]
        public static string GetIncrementApprovalList()
        {
            try
            {
                bllSalary obj = new bllSalary();

                DataTable dt = obj.GetAllIncrementForApproval(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            catch (Exception ex)
            {
                return "[]";
            }
        }

        [WebMethod]
        public static string GetIncrementHistory(string Code, string FromDate, string ToDate, int FromMonth, int FromYear, int ToMonth, int ToYear, string Status)
        {
            try
            {
                DateTime parsedDate;
                DateTime? fromDateValue = DateTime.TryParseExact(
                    FromDate,
                    "yyyy-MM-dd",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out parsedDate)
                    ? parsedDate
                    : (DateTime?)null;

                DateTime? toDateValue = DateTime.TryParseExact(
                    ToDate,
                    "yyyy-MM-dd",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out parsedDate)
                    ? parsedDate
                    : (DateTime?)null;

                DataTable dt = new bllSalary().GetIncrementHistory(
                    Code ?? string.Empty,
                    fromDateValue,
                    toDateValue,
                    FromMonth > 0 ? (int?)FromMonth : null,
                    FromYear > 0 ? (int?)FromYear : null,
                    ToMonth > 0 ? (int?)ToMonth : null,
                    ToYear > 0 ? (int?)ToYear : null,
                    Status ?? string.Empty);

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            catch
            {
                return "[]";
            }
        }

        [WebMethod]
        public static string GetIncrementSummaryFilters()
        {
            try
            {
                DataTable dt = new bllSalary().GetIncrementSummaryFilters();
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            catch
            {
                return "[]";
            }
        }

        [WebMethod]
        public static string GetIncrementSummary(int FromMonth, int FromYear, int ToMonth, int ToYear, string Location, string Domain, string SubDomain, string Status)
        {
            try
            {
                DataTable dt = new bllSalary().GetIncrementSummary(
                    FromMonth > 0 ? (int?)FromMonth : null,
                    FromYear > 0 ? (int?)FromYear : null,
                    ToMonth > 0 ? (int?)ToMonth : null,
                    ToYear > 0 ? (int?)ToYear : null,
                    Location ?? string.Empty,
                    Domain ?? string.Empty,
                    SubDomain ?? string.Empty,
                    Status ?? string.Empty);

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            catch
            {
                return "[]";
            }
        }

        [WebMethod]
        public static ResponseMessage ApproveIncrements(List<IncrementApprovalModel> increments)
        {
            ResponseMessage response = new ResponseMessage();

            try
            {
                if (increments == null || increments.Count == 0)
                {
                    response.Status = 0;
                    response.Message = "Please select at least one employee.";

                    return response;
                }

                bllSalary obj = new bllSalary();

                int ApprovedBy = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                string IP = GetIPAddress();

                foreach (var item in increments)
                {
                    obj.approveIncrement_New(item.IncrementID, ApprovedBy, IP, item.CurrentSalary);
                }

                response.Status = 1;
                response.Message = "Increment approved successfully!";
            }
            catch (Exception ex)
            {
                response.Status = 0;
                response.Message = ex.Message;
            }

            return response;
        }
        public static string GetIPAddress()
        {
            string ipAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (string.IsNullOrEmpty(ipAddress))
            {
                ipAddress = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            }

            return ipAddress;
        }
        public class IncrementApprovalModel
        {
            public int IncrementID { get; set; }

            public string CurrentSalary { get; set; }
        }

        public class ResponseMessage
        {
            public int Status { get; set; }

            public string Message { get; set; }
        }

    }
}
