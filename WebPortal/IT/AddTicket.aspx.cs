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
    public partial class AddTicket : System.Web.UI.Page
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
                file.InputStream.Read(binaryWriteArray, 0,
                (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;

                //string file_Name = name.Replace(ext, "") + "_" + DateTime.Now.ToString("ddMMyyyyhhmmss") + ext;
                //GUIDFile = file_Name ;

                NewFileName = Server.MapPath("..//TempFiles//" + file.FileName);

                if (filelist.ToString() == "")
                    filelist.Append(NewFileName);
                else
                    filelist.Append("," + NewFileName);

                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
            }
            catch { }

        }

        [WebMethod]
        public static string GetRequestOnBehalf()
        {
            DataTable dt1 = new bllMaster().GetAllEmployeeDetailsbyPMForInitiate(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetRequestRelatedTo()
        {
            DataTable dt1 = new bllAsset().GetAllRequest(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetAllRequests()
        {
            DataTable dt1 = new bllMaster().GetAllTicket(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetDepartmentForRequest(int RequestID)
        {
            DataTable dt1 = new bllAsset().GetDepartment(RequestID);
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
        public static string GetAllRemarkTicketwise(int TicketID)
        {
            DataTable dt1 = new bllAsset().GetAllRemarkTicketwise(TicketID);
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
        public static List<Department> GetDepartment()
        {
            DataTable dtdept = new bllMaster().GetAllDepartment();

            List<Department> depart = new List<Department>();
            depart = ConvertDataTable<Department>(dtdept);
            return depart;
        }

        private static List<T> ConvertDataTable<T>(DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }

        private static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                        pro.SetValue(obj, dr[column.ColumnName], null);
                    else
                        continue;
                }
            }
            return obj;
        }

        [WebMethod]
        public static int InsertTicket(string DeskNo, string Subject, string Description, string RequestOnBehalf, string Request, string Department, string Days, string Hours, string Minutes)
        {
            int ReturnValue = 0;
            string SubPath = "";

            Hashtable htTicket = new Hashtable();

            htTicket["Request"] = Request;
            htTicket["RequestOnBehalf"] = RequestOnBehalf;
            htTicket["ReportingManager"] = 0;
            htTicket["RequestBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            htTicket["DeskNo"] = DeskNo;
            htTicket["Subject"] = Subject;
            htTicket["Description"] = Description;
            htTicket["Days"] = Days;
            htTicket["Hours"] = Hours;
            htTicket["Minutes"] = Minutes;
            htTicket["Department"] = Convert.ToInt32(Department);
            htTicket["Users"] = "";
            htTicket["GroupName"] = "";

            if (filelist.ToString() != "")
            {
                htTicket["Attachment"] = FolderPath + "\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "*" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);
            }

            ReturnValue =  new bllAsset().InsertTicketForSoftware(htTicket);

            if (ReturnValue > 0)
            {
                SendTicketEmail(htTicket, ReturnValue);

                if (filelist.ToString() != "")
                {
                    SubPath = FolderPath + "\\" + DateTime.Now.ToString("dd-MMM-yyyy");
                    string UniquePath = SubPath + "\\" + ReturnValue + "\\" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);

                    if (!Directory.Exists(FolderPath))
                    {
                        Directory.CreateDirectory(FolderPath);
                    }
                    if (!Directory.Exists(SubPath))
                    {
                        Directory.CreateDirectory(SubPath);
                    }
                    string TickPath = SubPath + "\\" + ReturnValue;
                    if (!Directory.Exists(TickPath))
                    {
                        Directory.CreateDirectory(TickPath);
                    }

                    File.Copy(NewFileName, UniquePath);
                }
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int InsertRemark(int TicketId, string Remark, string NextState, string Days, string Hours, string Minutes)
        {
            int ReturnValue = 0;
            int ReturnValue_mail = 0;

            Hashtable htTicket = new Hashtable();

            htTicket["TicketId"] = TicketId;
            htTicket["NextState"] = NextState;
            htTicket["Remark"] = Remark;
            htTicket["RemarkType"] = "Assign";
            htTicket["Days"] = Days;
            htTicket["Hours"] = Hours;
            htTicket["Minutes"] = Minutes;
            htTicket["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            if (filelist.ToString() != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                string SubPath = FolderPath + "\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + TicketId;
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                string UniquePath = SubPath + "\\" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);
                File.Copy(NewFileName, UniquePath);
                htTicket["Attachment"] = UniquePath;
            }
            else
            {

            }

            ReturnValue = new bllAsset().InsertRemark(htTicket);

            if (ReturnValue > 0)
            {
                ReturnValue_mail = SendTicketEmail(htTicket, TicketId);
            }

            return ReturnValue_mail;
        }

        [WebMethod]
        public static int ReOpenTicket(int TicketId, string Status, string Remark)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam["TicketId"] = TicketId;
            htParam["Status"] = Status;
            htParam["Remark"] = Remark;
            htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            ReturnValue = new bllAsset().ReOpenTicket(htParam);

            return ReturnValue;
        }

        [WebMethod]
        public static int UpdateClosureRemark(int TicketId, string Remark)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam["TicketId"] = TicketId;
            htParam["Remark"] = Remark;
            htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            ReturnValue = new bllAsset().UpdateClosureRemark(htParam);

            return ReturnValue;
        }

        private static string BuildTicketEmailContent(DataTable ticket, string expectedTat)
        {
            DataRow row = ticket.Rows[0];
            StringBuilder email = new StringBuilder();
            email.Append("<p style=\"margin:0 0 24px;color:#0f172a;font-size:14px;font-weight:700;line-height:20px;\">Dear " + Convert.ToString(row["DepartmentName"]).Trim() + " Team,</p>" +
                "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;border:1px solid #e2e8f0;border-radius:10px;border-collapse:separate;overflow:hidden;\">");

            AppendTicketDetailRow(email, "Ticket #:", Convert.ToString(row["TicketNo"]).Trim());
            AppendTicketDetailRow(email, "Desk #:", row["DeskNo"]);
            AppendTicketDetailRow(email, "Request By:", row["Employee"]);
            AppendTicketDetailRow(email, "Working Branch:", row["WorkingBranch"]);
            AppendTicketDetailRow(email, "Reporting Manager:", Convert.ToString(row["ReportingManager"]).Trim());

            string onBehalf = Convert.ToString(row["RequestOnBehalf"]).Trim();
            if (onBehalf != "")
                AppendTicketDetailRow(email, "Request On Behalf:", onBehalf);

            AppendTicketDetailRow(email, "Request:", Convert.ToString(row["RequestB"]).Trim());
            AppendTicketDetailRow(email, "Subject:", Convert.ToString(row["Subject"]).Trim());
            AppendTicketDetailRow(email, "Posted on:", Convert.ToString(row["RequestDateTime"]).Trim());
            AppendTicketDetailRow(email, "Description:", row["Description"]);
            AppendTicketDetailRow(email, "Expected TAT:", expectedTat);
            email.Append("</table>");

            return email.ToString();
        }

        private static void AppendTicketDetailRow(StringBuilder email, string label, object value)
        {
            email.Append("<tr><td class=\"detail-label\" style=\"width:34%;padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#64748b;font-size:12px;font-weight:700;line-height:18px;vertical-align:top;\">" + label + "</td>" +
                "<td style=\"padding:11px 14px;border-bottom:1px solid #e2e8f0;color:#1e293b;font-size:13px;font-weight:600;line-height:18px;vertical-align:top;\">" + Convert.ToString(value) + "</td></tr>");
        }

        private static string GetTicketOfficialEmail(int employeeId)
        {
            DataTable employee = new bllAsset().GetOfficialMailIdOfEmployee(employeeId);
            return employee.Rows.Count > 0 ? Convert.ToString(employee.Rows[0]["OfficialEmailID"]) : "";
        }

        private static string BuildTicketCcAddresses(string reportingManagerEmail, string onBehalfEmail, DataTable requestByInfo)
        {
            string requestByEmail = "";
            string ticketCc = "";

            if (requestByInfo.Rows.Count > 0)
            {
                requestByEmail = Convert.ToString(requestByInfo.Rows[0]["OfficialEmailID"]);
                if (reportingManagerEmail == "")
                    ticketCc = onBehalfEmail + "," + requestByEmail;
                if (onBehalfEmail == "")
                    ticketCc = reportingManagerEmail + "," + requestByEmail;
                if (reportingManagerEmail != "" && onBehalfEmail != "")
                    ticketCc = reportingManagerEmail + "," + onBehalfEmail + "," + requestByEmail;
                if (requestByEmail == "")
                    ticketCc = reportingManagerEmail + "," + onBehalfEmail;
                if (onBehalfEmail == "" && requestByEmail == "")
                    ticketCc = reportingManagerEmail;
            }
            else
            {
                ticketCc = reportingManagerEmail + "," + onBehalfEmail;
                if (reportingManagerEmail == "")
                    ticketCc = onBehalfEmail;
                if (onBehalfEmail == "")
                    ticketCc = reportingManagerEmail;
                if (reportingManagerEmail != "" && onBehalfEmail != "")
                    ticketCc = reportingManagerEmail + "," + onBehalfEmail;
            }

            return ticketCc;
        }

        [WebMethod]
        public static int Core_SendTicketEmail(Hashtable htTicket, int ReturnValue) // string OffID, string GroupOffID)
        {
            int returnvalue = 0;
            string To = "";
            string CC = "";
            string BCC = "";
            string contentHeader = "";
            string Attachment = "";
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            DataTable dt = new bllAsset().GetTicketNoSendMail(ReturnValue);
            try
            {
                if (dt.Rows.Count > 0)
                {
                    //string path = HttpContext.Current.Request.Url.AbsolutePath;
                    string Subject = "";

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

                    string OnBehalf = Convert.ToString(dt.Rows[0]["RequestOnBehalf"]).Trim();
                    string ExpectedTAT = Convert.ToString(dt.Rows[0]["ExpectedTAT"]).Trim();

                    if (OnBehalf != "")
                    {
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Request On Behalf:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["RequestOnBehalf"]).Trim() + "</td></tr>");
                    }

                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Request:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["RequestB"]).Trim() + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Subject:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Subject"]).Trim() + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Posted on:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["RequestDateTime"]).Trim() + "</td></tr>");

                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Description:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Description"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Expected TAT:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ExpectedTAT) + "</td></tr>");

                    body.Append("<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:10px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                    footer.Append("</body></html>");

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
                            if (DomainHeadId == 216)
                            {
                                OfficialIdDoaminHead = Convert.ToString(DomainHead.Rows[0]["OfficialEmailID"]) + "," + "alex@infinityinternationals.us";
                            }
                            else if (DomainHeadId == 12)
                            {
                                OfficialIdDoaminHead = Convert.ToString(DomainHead.Rows[0]["OfficialEmailID"]);
                            }
                            else
                            {
                                OfficialIdDoaminHead = Convert.ToString(DomainHead.Rows[0]["OfficialEmailID"]);
                            }
                        }
                        else
                        {
                            OfficialIdDoaminHead = "";
                        }
                    }
                    catch
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

                    if (Department == 7) /*------ IT Department ------*/
                    {
                        int RequestBy1 = Convert.ToInt32(dt.Rows[0]["RequestBy"]);

                        if (RequestBy1 == 12 || RequestBy1 == 216 || RequestBy1 == 285 || RequestBy1 == 5 || RequestBy1 == 8128)
                        {
                            To = "support@infinityinternationals.us";
                            CC = TicketCC + ",hetal@infinity-data.com";
                            BCC = "p.kedar@infinityinternationals.us,n.nilkanth@infinityinternationals.us";
                            Subject = Convert.ToString(dt.Rows[0]["TicketNo"]) + " : " + Convert.ToString(dt.Rows[0]["Subject"]);
                            Attachment = Convert.ToString(htTicket["Attachment1"]).Trim();
                        }
                        else if (dt.Rows[0]["Request"].ToString() == "19" || dt.Rows[0]["Request"].ToString() == "24")
                        {
                            To = OfficialIdDoaminHead;
                            CC = "";
                            BCC = "p.kedar@infinityinternationals.us,n.nilkanth@infinityinternationals.us";
                            Subject = Convert.ToString(dt.Rows[0]["TicketNo"]) + " : " + Convert.ToString(dt.Rows[0]["Subject"]) + " : Pending for Approval";
                            Attachment = Convert.ToString(htTicket["Attachment1"]).Trim();
                        }
                        else if (dt.Rows[0]["Request"].ToString() == "39" || dt.Rows[0]["Request"].ToString() == "38" || dt.Rows[0]["Request"].ToString() == "22" || dt.Rows[0]["Request"].ToString() == "3")
                        {
                            To = OfficialIdDoaminHead + "," + OfficialId;
                            CC = "";
                            BCC = "p.kedar@infinityinternationals.us,n.nilkanth@infinityinternationals.us";
                            Subject = Convert.ToString(dt.Rows[0]["TicketNo"]) + " : " + Convert.ToString(dt.Rows[0]["Subject"]) + " : Pending for Approval";
                            Attachment = Convert.ToString(htTicket["Attachment1"]).Trim();
                        }
                        else
                        {
                            To = "support@infinityinternationals.us";
                            CC = TicketCC + ",hetal@infinity-data.com";
                            BCC = "p.kedar@infinityinternationals.us,n.nilkanth@infinityinternationals.us";
                            Subject = Convert.ToString(dt.Rows[0]["TicketNo"]) + " : " + Convert.ToString(dt.Rows[0]["Subject"]);
                            Attachment = Convert.ToString(htTicket["Attachment1"]).Trim();
                        }
                    }
                    else if (Department == 1) //--- Admin Department
                    {
                        To = "admin-dept@infinityinternationals.us";
                        CC = TicketCC + ",hetal@infinity-data.com";
                        BCC = "p.kedar@infinityinternationals.us,n.nilkanth@infinityinternationals.us";
                        Subject = Convert.ToString(dt.Rows[0]["TicketNo"]) + " : " + Convert.ToString(dt.Rows[0]["Subject"]);
                        Attachment = Convert.ToString(htTicket["Attachment1"]).Trim();
                    }
                    else if (Department == 12) //--- Software Department
                    {
                        To = "n.nilkanth@infinityinternationals.us";
                        CC = TicketCC;
                        BCC = "p.kedar@infinityinternationals.us,n.nilkanth@infinityinternationals.us";
                        Subject = Convert.ToString(dt.Rows[0]["TicketNo"]) + " : " + Convert.ToString(dt.Rows[0]["Subject"]);
                        Attachment = Convert.ToString(htTicket["Attachment1"]).Trim();
                    }
                    else if (Department == 6) //--- HR Department
                    {
                        To = "hr@infinityinternationals.us";
                        CC = TicketCC;
                        BCC = "p.kedar@infinityinternationals.us,n.nilkanth@infinityinternationals.us";
                        Subject = Convert.ToString(dt.Rows[0]["TicketNo"]) + " : " + Convert.ToString(dt.Rows[0]["Subject"]);
                        Attachment = Convert.ToString(htTicket["Attachment1"]).Trim();
                    }

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Helpdesk Notifications", System.Text.Encoding.UTF8);

                    //mail.To.Add("b.shubhangi@infinityinternationals.us");
                    try
                    {
                        To = "b.shubhangi@infinityinternationals.us";

                        if (To != "")
                            mail.To.Add(To);
                        //if (CC != "")
                        //    mail.CC.Add(CC);
                        //if (BCC != "")
                        //    mail.Bcc.Add(BCC);
                    }
                    catch (Exception ex)
                    {

                    }
                    mail.Subject = Subject;
                    mail.Body = WebPortal.App_Code.Class.SelfLeavesEmailTemplate.Apply(BuildTicketEmailContent(dt, ExpectedTAT), "Helpdesk ticket", true);
                    mail.IsBodyHtml = true;
                    if (Attachment != "")
                        mail.Attachments.Add(new Attachment(Attachment));
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
            catch (Exception ex)
            {
            }

            return returnvalue;
        }

        [WebMethod]
        public static int SendTicketEmail(Hashtable htTicket, int ReturnValue) // string OffID, string GroupOffID)
        {
            int returnvalue = 0;
            string To = "";
            string CC = "";
            string BCC = "";
            string Attachment = "";

            DataTable dt = new bllAsset().GetTicketNoSendMail(ReturnValue);
            try
            {
                if (dt.Rows.Count == 0)
                    return returnvalue;

                DataRow ticket = dt.Rows[0];
                string Subject = "";
                string ExpectedTAT = Convert.ToString(ticket["ExpectedTAT"]).Trim();
                int Department = Convert.ToInt32(ticket["Department"].ToString());
                int RequestOnBehalf = Convert.ToInt32(ticket["RequestOnBehalf1"]);
                int ReportingManager = Convert.ToInt32(ticket["ReportingManager1"]);
                string standardBcc = "p.kedar@infinityinternationals.us,n.nilkanth@infinityinternationals.us";
                string standardSubject = Convert.ToString(ticket["TicketNo"]) + " : " + Convert.ToString(ticket["Subject"]);
                string pendingApprovalSubject = standardSubject + " : Pending for Approval";
                string requestedAttachment = Convert.ToString(htTicket["Attachment1"]).Trim();

                string OfficialIdDoaminHead = "";
                try
                {
                    int DomainHeadId = Convert.ToInt32(ticket["DomainHead"]);
                    DataTable DomainHead = new bllAsset().GetOfficialMailIdOfEmployee(DomainHeadId);

                    if (DomainHead.Rows.Count > 0)
                    {
                        OfficialIdDoaminHead = Convert.ToString(DomainHead.Rows[0]["OfficialEmailID"]);
                        if (DomainHeadId == 216)
                            OfficialIdDoaminHead += ",alex@infinityinternationals.us";
                    }
                }
                catch
                {
                }

                string OfficialId = GetTicketOfficialEmail(ReportingManager);
                string OfficialId1 = GetTicketOfficialEmail(RequestOnBehalf);
                int RequestBy = Convert.ToInt32(ticket["RequestBy"]);
                DataTable dtReqBy = new bllAsset().GetOfficialMailIdOfEmployee(RequestBy);
                string TicketCC = BuildTicketCcAddresses(OfficialId, OfficialId1, dtReqBy);

                if (Department == 7) /*------ IT Department ------*/
                {
                    BCC = standardBcc;
                    Attachment = requestedAttachment;

                    if (RequestBy == 12 || RequestBy == 216 || RequestBy == 285 || RequestBy == 5 || RequestBy == 8128)
                    {
                        To = "support@infinityinternationals.us";
                        CC = TicketCC + ",hetal@infinity-data.com";
                        Subject = standardSubject;
                    }
                    else if (ticket["Request"].ToString() == "19" || ticket["Request"].ToString() == "24")
                    {
                        To = OfficialIdDoaminHead;
                        CC = "";
                        Subject = pendingApprovalSubject;
                    }
                    else if (ticket["Request"].ToString() == "39" || ticket["Request"].ToString() == "38" || ticket["Request"].ToString() == "22" || ticket["Request"].ToString() == "3")
                    {
                        To = OfficialIdDoaminHead + "," + OfficialId;
                        CC = "";
                        Subject = pendingApprovalSubject;
                    }
                    else
                    {
                        To = "support@infinityinternationals.us";
                        CC = TicketCC + ",hetal@infinity-data.com";
                        Subject = standardSubject;
                    }
                }
                else if (Department == 1) //--- Admin Department
                {
                    To = "admin-dept@infinityinternationals.us";
                    CC = TicketCC + ",hetal@infinity-data.com";
                    BCC = standardBcc;
                    Subject = standardSubject;
                    Attachment = requestedAttachment;
                }
                else if (Department == 12) //--- Software Department
                {
                    To = "n.nilkanth@infinityinternationals.us";
                    CC = TicketCC;
                    BCC = standardBcc;
                    Subject = standardSubject;
                    Attachment = requestedAttachment;
                }
                else if (Department == 6) //--- HR Department
                {
                    To = "hr@infinityinternationals.us";
                    CC = TicketCC;
                    BCC = standardBcc;
                    Subject = standardSubject;
                    Attachment = requestedAttachment;
                }

                string Pass = new bllMaster().GetPassword("ackdata");
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("ack@infinity-data.com", "Helpdesk Notifications", System.Text.Encoding.UTF8);

                //mail.To.Add("b.shubhangi@infinityinternationals.us");

                try
                {
                    if (To != "")
                        mail.To.Add(To);
                    if (CC != "")
                        mail.CC.Add(CC);
                    if (BCC != "")
                        mail.Bcc.Add(BCC);
                }
                catch (Exception ex)
                {
                }

                mail.Subject = Subject;
                mail.Body = WebPortal.App_Code.Class.SelfLeavesEmailTemplate.Apply(BuildTicketEmailContent(dt, ExpectedTAT), "Helpdesk ticket", true);
                mail.IsBodyHtml = true;
                if (Attachment != "")
                    mail.Attachments.Add(new Attachment(Attachment));
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
                catch
                {
                    return 0;
                }
            }
            catch (Exception ex)
            {
            }

            return returnvalue;
        }
    }
}
