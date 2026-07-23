using AjaxControlToolkit.HTMLEditor.ToolbarButton;
using DocumentFormat.OpenXml.Drawing.Charts;
using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using DocumentFormat.OpenXml.Spreadsheet;
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
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using DataTable = System.Data.DataTable;

namespace WebPortal.Admin
{
    public partial class Resignation : System.Web.UI.Page
    {
        bllMaster bllMaster = new bllMaster();
        static string NewFileName = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                ShowTabsByRights();
                HttpContext postedContext = HttpContext.Current;
                HttpPostedFile file = postedContext.Request.Files[0];

                string name = file.FileName;
                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0,
                (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;


                string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                NewFileName = Server.MapPath("..//Images//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
                string filename = Convert.ToString(Request.Files["fpAttachment"].FileName);
            }
            catch { }
            if (!IsPostBack)
            {
            }
            BindStep2Grid();
        }

        public void ShowTabsByRights()
        {
            int LogId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            if (LogId == 7036)
            {
                nav2.Style.Add("display", "");
                nav3.Style.Add("display", "");
                nav4.Style.Add("display", "");
                nav5.Style.Add("display", "");
            }
            else if (LogId == 12 || LogId == 216 || LogId == 285 || LogId == 9858 || LogId == 291)
            {
                nav2.Style.Add("display", "");
                nav3.Style.Add("display", "none");
                nav4.Style.Add("display", "");
                nav5.Style.Add("display", "none");
            }
            else if (LogId == 255 || LogId == 291)
            {
                nav2.Style.Add("display", "");
                nav3.Style.Add("display", "none");
                nav4.Style.Add("display", "none");
                nav5.Style.Add("display", "none");
            }
            else if (LogId == 8082 || LogId == 8938)
            {
                nav2.Style.Add("display", "none");
                nav3.Style.Add("display", "");
                nav4.Style.Add("display", "none");
                nav5.Style.Add("display", "");
            }
            else if (LogId == 9738)
            {
                nav2.Style.Add("display", "");
                nav3.Style.Add("display", "none");
                nav4.Style.Add("display", "none");
                nav5.Style.Add("display", "none");
            }
            else
            {
                nav2.Style.Add("display", "none");
                nav3.Style.Add("display", "none");
                nav4.Style.Add("display", "none");
                nav5.Style.Add("display", "none");
            }
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

        #region Step 1 - Initiate Resignation

        [WebMethod]
        public static List<Project> GetProjects()
        {
            DataTable dtProjects = new bllMaster().GetAllProject();

            List<Project> prj = new List<Project>();
            prj = ConvertDataTable<Project>(dtProjects);
            return prj;
        }

        [WebMethod]
        public static List<Process> GetProcess(int ProjectID)
        {
            DataTable dtProcess = new bllMaster().getProcess(ProjectID);
            List<Process> prc = new List<Process>();
            prc = ConvertDataTable<Process>(dtProcess);
            return prc;
        }

        [WebMethod]
        public static string GetLastWorkingDate(string FormDate, string LastWorkinDate, string ResignationType)
        {
            return new CodeGeneration().getlastdate(FormDate, LastWorkinDate, ResignationType);
        }

        [WebMethod]
        public static string GetLastLoginDate1(string Code)
        {
            return new CodeGeneration().GetLastLoginDate(Code);
        }

        [WebMethod]
        public static string getDetailsOnCheckList(string UserCode)
        {
            return new CodeGeneration().getDetailsOnCheckList(UserCode);
        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetEmployeeCodes()
        {
            int EmpId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DataTable dt = new bllLogin().GetUserInformation(EmpId);
            DataTable dtgrd = new DataTable();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt != null && dt.Rows.Count > 0)
            {
                int isPM = new bllMaster().CheckIfPM(EmpId);
                if (isPM == 1)
                {
                    dtgrd = new bllMaster().GetAllEmployeeDetailsbyPMForInitiate(EmpId);
                }
                else
                {
                    if (Convert.ToInt32(dt.Rows[0]["WorkingBranch"]) == 5 || Convert.ToInt32(dt.Rows[0]["WorkingBranch"]) == 6)
                        dtgrd = new bllMaster().GetAllEmployeeDetailsSolForInitiate();
                    else
                        dtgrd = new bllMaster().GetAllEmployeeDetailsForInitiate();
                }
            }

            if (dtgrd != null)
            {
                foreach (DataRow dr in dtgrd.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    row.Add("EmployeeID", dr["EMPID"]);
                    row.Add("Code", dr["Code"]);
                    row.Add("Name", dr["NAME"]);
                    row.Add("Text", Convert.ToString(dr["Code"]) + " : " + Convert.ToString(dr["NAME"]));
                    rows.Add(row);
                }
            }

            return rows;
        }

        [WebMethod]
        public static int InitiateResignation(int EmployeeID, string Code, string ContactNo, string Project, string Process, string ResignationType, string ResignationDate, string LastWorkingDate, string ReasonToTerminate, string Remark, string LastLoginDate, string NoOfDays)
        {
            //string filename = fpAttachment.PostedFile.FileName;
            string file = NewFileName;
            Hashtable htParam = new Hashtable();
            htParam.Add("Code", Code);
            htParam.Add("EmployeeId", EmployeeID);
            htParam.Add("ContactNo", ContactNo);
            htParam.Add("Project", Project);
            htParam.Add("Process", Process);
            htParam.Add("ResignationType", ResignationType);
            htParam.Add("ResignationDate", ResignationDate);
            if (ResignationType == "Absconding" || ResignationType == "Termination")
                htParam.Add("LastWorkingDate", LastLoginDate);
            else
                htParam.Add("LastWorkingDate", LastWorkingDate);
            htParam.Add("LastLoginDate", new CodeGeneration().GetLastLoginDate(Code));
            htParam.Add("Reasontoterminate", ReasonToTerminate);
            if (ResignationType == "Termination")
                htParam.Add("Subject", "Termination");
            else if (ResignationType == "Absconding")
                htParam.Add("Subject", "Absconding");
            else
                htParam.Add("Subject", "Resignation");
            if (file != "")
            {
                htParam.Add("Attachment", file);
            }
            else
                htParam.Add("Attachment", "");
            htParam.Add("NoofDays", NoOfDays == "" ? "0" : NoOfDays);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("Remark", PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Remark);
            htParam.Add("status", "Select");
            htParam.Add("UnitHeadRemark", "");
            htParam.Add("UnitHead", int.Parse("0"));
            int returnvalue = 0;
            returnvalue = new bllMaster().InitiateResignation(htParam);
            if (returnvalue > 0)
            {
                SendStep1Email(EmployeeID, Code, ResignationType, ResignationDate, LastWorkingDate, ReasonToTerminate, Remark, LastLoginDate, NoOfDays);
            }
            //new CodeGeneration().SendNoticePeriodMailToUnitHead(EmployeeID, htParam);
            //System.Threading.Thread.Sleep(10000);
            return returnvalue;
        }

        [WebMethod]
        public static int SendStep1Email(int EmployeeID, string Code, string ResignationType, string ResignationDate, string LastWorkingDate, string ReasonToTerminate, string Remark, string LastLoginDate, string NoOfDays)
        {
            int ReturnValue = 1;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            string LocationHeadEmail = string.Empty;
            string DomainHeadEmail = string.Empty;
            string ToAddress = string.Empty;
            string ToCC = string.Empty;
            string ToBCC = string.Empty;

            //string UnitHeadEmail = new bllMaster().GetUnitHeadEmail(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            DataTable dtInit = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtInit != null)
            {
                DataTable dt = new bllLogin().GetUserInformation(EmployeeID);
                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(EmployeeID, "Notice Period1");
                        ToAddress = Convert.ToString(dtEmail.Rows[0]["ToResignation"]);
                        ToCC = Convert.ToString(dtEmail.Rows[0]["CC"]);
                        ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                        string contentHeader = "";
                        if (ResignationType == "Immediate" || ResignationType == "Normal" || ResignationType == "Special")
                            contentHeader = "Resignation";
                        else
                            contentHeader = ResignationType;

                        head.Append("<html><head></head><body>");
                        body.Append("<table style=\"width:802px;font-family:monospace; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:monospace; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />" + Convert.ToString(contentHeader) + " of employee " + Convert.ToString(dt.Rows[0]["FullName"]) + " has been initiated.<br /><br /></b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Employee Basic Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Code) + " : " + Convert.ToString(dt.Rows[0]["FullName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + " </td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DomainName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b>Resignation Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ResignationType) + "</td></tr>");
                        if (ResignationType == "Termination")
                        {
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason to terminate:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ReasonToTerminate) + " </td></tr> ");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtInit.Rows[0]["Code"]) + " : " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " : " + Convert.ToString(Remark) + " </td></tr> ");
                        }
                        else if (ResignationType == "Absconding")
                        {
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtInit.Rows[0]["Code"]) + " : " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " : " + Convert.ToString(Remark) + " </td></tr> ");
                        }
                        else
                        {
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(ResignationDate) + " <b>To:</b> " + Convert.ToString(LastWorkingDate) + " :: <b>No of Days:</b> " + Convert.ToString(NoOfDays) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtInit.Rows[0]["Code"]) + " : " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " : " + Convert.ToString(Remark) + " </td></tr> ");
                        }
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Latest Login Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + "</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +

                        "</table>");
                        footer.Append("</body></html>");

                        string Pass = new bllMaster().GetPassword("ackdata");

                        MailMessage mail = new MailMessage();
                        mail.From = new MailAddress("ack@infinity-data.com", "HRMS", System.Text.Encoding.UTF8);
                        mail.To.Add(ToAddress);
                        mail.CC.Add(ToCC);
                        mail.Bcc.Add(ToBCC);

                        mail.Subject = "Step 1:- " + Convert.ToString(contentHeader) + " has been initiated - User " + Convert.ToString(Code);
                        mail.Body = head.ToString() + body.ToString() + footer.ToString();
                        mail.IsBodyHtml = true;

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
                            return 1;
                        }
                        catch { return 0; }
                    }
                }
            }
            return ReturnValue;
        }

        public void BindCode()
        {
            // Employee code options are now loaded by GetEmployeeCodes for the HTML select.
        }

        #endregion

        #region Step 2 - Finalise Resignation

        [WebMethod]
        public static string GetRsignedEmployeesStep2()
        {
            DataTable dt1 = new bllMaster().GetResignedEmployeesForFinalize(Convert.ToInt32(HttpContext.Current.User.Identity.Name));
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
        public static string GetFinalizedStep3()
        {
            DataTable dt1 = new bllMaster().GetAllResignedEmployees(Convert.ToInt32(HttpContext.Current.User.Identity.Name));
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

        public void BindStep2Grid()
        {
            //DataTable dt1 = bllMaster.GetResignedEmployeesForFinalize(Convert.ToInt32(HttpContext.Current.User.Identity.Name));
            //finaliseRepeater.DataSource = bllMaster.GetResignedEmployeesForFinalize(Convert.ToInt32(HttpContext.Current.User.Identity.Name));
            //finaliseRepeater.DataBind();

            JavaScriptSerializer ser = new JavaScriptSerializer();
            //ser.Serialize(dt1);
        }

        [WebMethod]
        public static int SubmitStep2(int resgnationid, string status, string unitheadremark, string attritioncategory, string resignationreceivedthrough)
        {
            int ReturnValue = 0;
            int ResignationID = resgnationid;

            DataTable dt = new bllMaster().GetResignationDetails(ResignationID);
            if (dt != null)
            {
                string Status = status;
                string UHReamrk = unitheadremark;
                string AttritionCategory = attritioncategory;
                string ResignationReceivedThrough = resignationreceivedthrough;

                Hashtable htParam = new Hashtable();
                htParam.Add("ResignationID", ResignationID);
                htParam.Add("Status", Status);
                htParam.Add("AttritionCategory", AttritionCategory);
                string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                htParam.Add("UnitHeadRemark", PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + UHReamrk);
                htParam.Add("ResignationReceivedThrough", ResignationReceivedThrough);
                htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                ReturnValue = new bllMaster().UpdateResignation(htParam);

                if (ReturnValue > 0)
                    SendStep2Email(dt, UHReamrk, Status);
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int SendStep2Email(DataTable dtResigned, string UHRemark, string Status)
        {
            int ReturnValue = 1;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
            string ResignationType = Convert.ToString(dtResigned.Rows[0]["ResignationType"]);
            string ToAddress = string.Empty;
            string ToCC = string.Empty;
            string ToBCC = string.Empty;

            DataTable dtInit = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtInit != null)
            {
                DataTable dt = new bllLogin().GetUserInformation(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]));
                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        int NoOfDays = 0;
                        string contentHeader = "";
                        string subject = "";
                        string ResignationStatus = "";

                        //if (Convert.ToInt32(dt.Rows[0]["WorkingBranch"]) == 5)
                        //    ToAddress = "hr@infinityinternationals.us,v.rohan@infinityinternationals.us";
                        //else if (Convert.ToInt32(dt.Rows[0]["WorkingBranch"]) != 5)
                        //    ToAddress = "hr@infinityinternationals.us";

                        if (Status == "Approve")
                        {
                            subject = "finalized";
                            ResignationStatus = "Approved";
                        }
                        else
                        {
                            ResignationStatus = "Rejected";
                            subject = "rejected";
                        }
                        if (ResignationType == "Immediate" || ResignationType == "Normal" || ResignationType == "Special")
                            contentHeader = "Resignation";
                        else
                            contentHeader = ResignationType;
                        head.Append("<html><head></head><body>");
                        body.Append("<table style=\"width:802px;font-family:monospace; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:monospace; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />" + Convert.ToString(contentHeader) + " of employee " + Convert.ToString(dt.Rows[0]["FullName"]) + " has been " + subject + ".<br /><br /></b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Employee Basic Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Code"]) + " : " + Convert.ToString(dt.Rows[0]["FullName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + " </td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DomainName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b>Resignation Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 1 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ResignationType) + "</td></tr>");
                        if (ResignationType == "Termination")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason to terminate:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Reasontoterminate"]) + " </td></tr> ");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else if (ResignationType == "Absconding")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dtResigned.Rows[0]["LastWorkingDate"]) - Convert.ToDateTime(dtResigned.Rows[0]["ResignationDate"])).TotalDays.ToString();
                            NoOfDays = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dtResigned.Rows[0]["ResignationDate"]) + " <b>To:</b> " + Convert.ToString(dtResigned.Rows[0]["LastWorkingDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(NoOfDays) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 2 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ResignationStatus) + " </td></tr> " +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 2 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtInit.Rows[0]["Code"]) + " : " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " : " + Convert.ToString(UHRemark) + " </td></tr> " +

                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Latest Login Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + "</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                        footer.Append("</body></html>");

                        DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]), "Notice Period");
                        ToAddress = Convert.ToString(dtEmail.Rows[0]["To"]);
                        ToCC = Convert.ToString(dtEmail.Rows[0]["CC"]);
                        ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                        string Pass = new bllMaster().GetPassword("ackdata");

                        MailMessage mail = new MailMessage();
                        mail.From = new MailAddress("ack@infinity-data.com", "HRMS", System.Text.Encoding.UTF8);
                        mail.To.Add(ToAddress);
                        mail.CC.Add(ToCC);
                        mail.Bcc.Add(ToBCC);
                        mail.Subject = "Step 2:- " + Convert.ToString(contentHeader) + " has been " + subject + " - User " + Convert.ToString(dt.Rows[0]["Code"]);
                        mail.Body = head.ToString() + body.ToString() + footer.ToString();
                        mail.IsBodyHtml = true;

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
                            return 1;
                        }
                        catch { return 0; }
                    }
                }
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int UpdateExitFormality(int ResignationID, string Remark)
        {
            int returnvalue = 0;

            DataTable dt = new bllMaster().GetResignationDetails(ResignationID);
            if (dt != null)
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("ResignationID", ResignationID);
                htParam.Add("Remark", Remark);
                htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                returnvalue = new bllMaster().UpdateExitFormalityRemark(htParam);

                if (returnvalue > 0)
                    SendExitFormalityEmail(dt, Remark);
            }
            return returnvalue;
        }

        [WebMethod]
        public static int SendExitFormalityEmail(DataTable dtResigned, string Remark)
        {
            int ReturnValue = 1;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
            string ResignationType = Convert.ToString(dtResigned.Rows[0]["ResignationType"]);
            DataTable dtInit = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtInit != null)
            {
                DataTable dt = new bllLogin().GetUserInformation(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]));
                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        int NoOfDays = 0;
                        string contentHeader = "";
                        string subject = "";
                        string ResignationStatus = "";
                        if (Convert.ToString(dtResigned.Rows[0]["Status"]) == "Accept")
                        {
                            subject = "finalized";
                            ResignationStatus = "Approved";
                        }
                        else
                        {
                            ResignationStatus = "Rejected";
                            subject = "rejected";
                        }
                        if (ResignationType == "Immediate" || ResignationType == "Normal" || ResignationType == "Special")
                            contentHeader = "Resignation";
                        else
                            contentHeader = ResignationType;
                        head.Append("<html><head></head><body>");
                        body.Append("<table style=\"width:802px;font-family:Verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:22px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:Verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />Employee " + Convert.ToString(dt.Rows[0]["FullName"]) + " has completed exit formalities.<br /><br /></b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Employee Basic Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Code"]) + " : " + Convert.ToString(dt.Rows[0]["FullName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + " </td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DomainName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b>Resignation Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 1 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ResignationType) + "</td></tr>");

                        if (ResignationType == "Termination")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason to terminate:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Reasontoterminate"]) + " </td></tr> ");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else if (ResignationType == "Absconding")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dtResigned.Rows[0]["LastWorkingDate"]) - Convert.ToDateTime(dtResigned.Rows[0]["ResignationDate"])).TotalDays.ToString();
                            NoOfDays = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dtResigned.Rows[0]["ResignationDate"]) + " <b>To:</b> " + Convert.ToString(dtResigned.Rows[0]["LastWorkingDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(NoOfDays) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 2 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ResignationStatus) + " </td></tr> " +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 2 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["UnitHeadRemark"]) + " </td></tr> " +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Latest Login Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + "</td></tr>" +

                        "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Exit Formality Details :: </b></td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Exit Formalities Completed?:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">Yes</td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Exit Formalities Completion Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Remark) + "</td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Current Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">Step 3 Pending.</td></tr>" +

                        "<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                        footer.Append("</body></html>");

                        string Pass = new bllMaster().GetPassword("ackdata");

                        MailMessage mail = new MailMessage();
                        mail.From = new MailAddress("ack@infinity-data.com", "HRMS", System.Text.Encoding.UTF8);
                        mail.To.Add("jim@infinity-data.com");
                        mail.CC.Add("hetal@infinity-data.com");
                        mail.CC.Add("hr@infinityinternationals.com");
                        mail.Bcc.Add("n.nilkanth@infinity-data.com");
                        mail.Subject = "Exit Formality:- User " + Convert.ToString(dt.Rows[0]["Code"]) + " has completed exit formalities.";
                        mail.Body = head.ToString() + body.ToString() + footer.ToString();
                        mail.IsBodyHtml = true;

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
                            return 1;
                        }
                        catch { return 0; }
                    }
                }
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int ChangeResignationType(int resgnationid, string resignationType, string resignationDate, string lastWorkingDate, string Reasontoterminate, string ReasonType, string Remark, string NoofDays)
        {
            int ReturnValue = 0;
            int ResignationID = resgnationid;
            DataTable dt = new bllMaster().GetResignationDetailsbyEmployeeID(ResignationID);
            if (dt != null)
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("ResignationId", ResignationID);
                htParam.Add("ResignationType", resignationType);
                htParam.Add("ResignationDate", resignationDate);
                htParam.Add("LastWorkingDate", lastWorkingDate);
                htParam.Add("ReasonType", ReasonType);
                htParam.Add("Reasontoterminate", Reasontoterminate);
                string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                htParam.Add("ReasonRemark", PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Remark);
                ReturnValue = new bllMaster().ChangeResignationType(htParam);
                if (ReturnValue > 0)
                    ChangeResignationTypeEmail(dt, resignationType, resignationDate, lastWorkingDate, Reasontoterminate, ReasonType, Remark, NoofDays);
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int ChangeResignationTypeEmail(DataTable dtResigned, string ResignationType, string ResignationDate, string LastWorkingDate, string Reasontoterminate, string ReasonType, string Remark, string NoOfDays)
        {
            int ReturnValue = 1;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            string ToAddress = string.Empty;
            string ToCC = string.Empty;
            string ToBCC = string.Empty;

            DataTable dtInit = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtInit != null)
            {
                DataTable dt = new bllLogin().GetUserInformation(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]));
                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {

                        int NoOfDays_1 = 0;
                        string ResignationStatus = "";
                        if (Convert.ToString(dtResigned.Rows[0]["Status"]) == "Accept")
                        {
                            ResignationStatus = "Approved";
                        }
                        else
                        {
                            ResignationStatus = "Rejected";
                        }

                        head.Append("<html><head></head><body>");
                        body.Append("<table style=\"width:802px;font-family:Verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:22px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:Verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />Resignation type of employee " + Convert.ToString(dt.Rows[0]["FullName"]) + " has been changed.<br /><br /></b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Employee Basic Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Code"]) + " : " + Convert.ToString(dt.Rows[0]["FullName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + " </td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DomainName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b>Resignation Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 1 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Convert.ToString(dtResigned.Rows[0]["ResignationType"])) + "</td></tr>");
                        if (Convert.ToString(dtResigned.Rows[0]["ResignationType"]) == "Termination")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason to terminate:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Reasontoterminate"]) + " </td></tr> ");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else if (Convert.ToString(dtResigned.Rows[0]["ResignationType"]) == "Absconding")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dtResigned.Rows[0]["LastWorkingDate"]) - Convert.ToDateTime(dtResigned.Rows[0]["ResignationDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dtResigned.Rows[0]["ResignationDate"]) + " <b>To:</b> " + Convert.ToString(dtResigned.Rows[0]["LastWorkingDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(NoOfDays_1) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 2 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ResignationStatus) + " </td></tr> " +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 2 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["UnitHeadRemark"]) + " </td></tr> " +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Latest Login Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + "</td></tr>");
                        if (Convert.ToString(dtResigned.Rows[0]["ExitFormalitiesCompleted"]) == "True")
                        {
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Exit Formality Details :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Exit Formalities Completed?:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">Yes</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Exit Formalities Completion Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["ExitFormalitiesRemark"]) + "</td></tr>");
                        }

                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Changes in Resignation :: </b></td></tr>");
                        string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (ResignationType == "Termination")
                        {
                            body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>New Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + ResignationType + "</td></tr>");
                            body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(ResignationDate) + " <b>To:</b> " + Convert.ToString(LastWorkingDate) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason to terminate:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Reasontoterminate) + " </td></tr> ");
                            body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Convert.ToString(Remark) + " </td></tr> ");
                        }
                        else if (ResignationType == "Absconding")
                        {
                            body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>New Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + ResignationType + "</td></tr>");
                            body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(ResignationDate) + " <b>To:</b> " + Convert.ToString(LastWorkingDate) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Convert.ToString(Remark) + " </td></tr> ");
                        }
                        else
                        {
                            body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>New Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + ResignationType + "</td></tr>");
                            body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(ResignationDate) + " <b>To:</b> " + Convert.ToString(LastWorkingDate) + " :: <b>No of Days:</b> " + Convert.ToString(NoOfDays) + "</td></tr>");
                            body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Convert.ToString(Remark) + " </td></tr> ");
                        }

                        body.Append("<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                        footer.Append("</body></html>");

                        string Pass = new bllMaster().GetPassword("ackdata");

                        //Change Resignation  PM, DomainHead
                        //Same as Change Resignation
                        DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]), "Change Resignation");
                        ToAddress = Convert.ToString(dtEmail.Rows[0]["ToChangeResignation"]);
                        ToCC = Convert.ToString(dtEmail.Rows[0]["CC"]);
                        ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                        MailMessage mail = new MailMessage();
                        mail.From = new MailAddress("ack@infinity-data.com", "HRMS", System.Text.Encoding.UTF8);

                        mail.To.Add(ToAddress);
                        mail.To.Add(ToCC);
                        mail.Bcc.Add(ToBCC);

                        mail.Subject = "Resignation type has been changed - User " + Convert.ToString(dt.Rows[0]["Code"]);
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
            return ReturnValue;
        }

        #endregion

        [WebMethod]
        public static string CheckNoticePeriodDates(string Type)
        {
            string returnvalue = "";
            if (Type == "Shorten")
            {

            }
            return returnvalue;
        }

        [WebMethod]
        public static int ExtendShortenResignation(int resgnationid, string resignationType, string resignationDate, string lastWorkingDate, string RevisedDate, string Remark, string NoofDays, string Type)
        {
            int ReturnValue = 0;
            string ResignationType = "";
            if (Convert.ToInt32(NoofDays) < 28)
            {
                ResignationType = "Immediate";
            }
            else if (Convert.ToInt32(NoofDays) > 31)
            {
                ResignationType = "Special";
            }
            int ResignationID = resgnationid;
            DataTable dt = new bllMaster().GetResignationDetailsbyEmployeeID(ResignationID);
            if (dt != null)
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("ResignationId", ResignationID);
                htParam.Add("ResignationType", ResignationType);
                htParam.Add("ResignationDate", resignationDate);
                htParam.Add("LastWorkingDate", lastWorkingDate);
                htParam.Add("RevisedDate", RevisedDate);
                string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                htParam.Add("Remark", PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Remark);
                ReturnValue = new bllMaster().ExtendShortenNoticePeriod(htParam);
                if (ReturnValue > 0)
                    ExtendShortenEmail(dt, resignationType, resignationDate, lastWorkingDate, RevisedDate, Remark, NoofDays, Type);
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int ExtendShortenEmail(DataTable dtResigned, string ResignationType, string ResignationDate, string LastWorkingDate, string RevisedDate, string Remark, string NoofDays, string Type)
        {
            int ReturnValue = 1;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            string EmailType = string.Empty;
            string ToAddress = string.Empty;
            string ToBCC = string.Empty;
            string ToCC = string.Empty;

            ToAddress = "hr@infinityinternationals.us";

            if (Convert.ToInt32(NoofDays) < 28)
            {
                ResignationType = "Immediate";
            }
            else if (Convert.ToInt32(NoofDays) > 31)
            {
                ResignationType = "Special";
            }
            DataTable dtInit = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtInit != null)
            {
                DataTable dt = new bllLogin().GetUserInformation(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]));
                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        int NoOfDays_1 = 0;
                        string ResignationStatus = "";
                        if (Convert.ToString(dtResigned.Rows[0]["Status"]) == "Accept")
                        {
                            ResignationStatus = "Approved";
                        }
                        else
                        {
                            ResignationStatus = "Rejected";
                        }

                        head.Append("<html><head></head><body>");
                        body.Append("<table style=\"width:802px;font-family:Verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:22px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:Verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />Notice period of employee " + Convert.ToString(dt.Rows[0]["FullName"]) + " has been " + Type + "ed.<br /><br /></b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Employee Basic Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Code"]) + " : " + Convert.ToString(dt.Rows[0]["FullName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + " </td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DomainName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b>Resignation Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 1 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Convert.ToString(dtResigned.Rows[0]["ResignationType"])) + "</td></tr>");
                        if (Convert.ToString(dtResigned.Rows[0]["ResignationType"]) == "Termination")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason to terminate:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Reasontoterminate"]) + " </td></tr> ");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else if (Convert.ToString(dtResigned.Rows[0]["ResignationType"]) == "Absconding")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dtResigned.Rows[0]["LastWorkingDate"]) - Convert.ToDateTime(dtResigned.Rows[0]["ResignationDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dtResigned.Rows[0]["ResignationDate"]) + " <b>To:</b> " + Convert.ToString(dtResigned.Rows[0]["LastWorkingDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(NoOfDays_1) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 2 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ResignationStatus) + " </td></tr> " +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 2 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["UnitHeadRemark"]) + " </td></tr> " +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Latest Login Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + "</td></tr>");

                        if (Convert.ToString(dtResigned.Rows[0]["ExitFormalitiesCompleted"]) == "True")
                        {
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Exit Formality Details :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Exit Formalities Completed?:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">Yes</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Exit Formalities Completion Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["ExitFormalitiesRemark"]) + "</td></tr>");
                        }

                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Changes in Resignation :: </b></td></tr>");
                        string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>New Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + ResignationType + "</td></tr>");
                        body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>New Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(ResignationDate) + " <b>To:</b> " + Convert.ToString(RevisedDate) + " :: <b>No of Days:</b> " + Convert.ToString(NoofDays) + "</td></tr>");
                        body.Append("<tr style=\"background-color:yellow;\"><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Convert.ToString(Remark) + " </td></tr> ");

                        body.Append("<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                        footer.Append("</body></html>");

                        //Same as Change Resignation
                        DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]), "Change Resignation");
                        ToAddress = Convert.ToString(dtEmail.Rows[0]["ToChangeResignation"]);
                        ToCC = Convert.ToString(dtEmail.Rows[0]["CC"]);
                        ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                        string Pass = new bllMaster().GetPassword("ackdata");

                        MailMessage mail = new MailMessage();
                        mail.From = new MailAddress("ack@infinity-data.com", "HRMS", System.Text.Encoding.UTF8);
                        mail.To.Add(ToAddress);
                        mail.CC.Add(ToCC);
                        mail.Bcc.Add(ToBCC);
                        mail.Subject = "Notice period has been " + Type + "ed - User " + Convert.ToString(dt.Rows[0]["Code"]);
                        mail.Body = head.ToString() + body.ToString() + footer.ToString();
                        mail.IsBodyHtml = true;

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
                            return 1;
                        }
                        catch { return 0; }
                    }
                }
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int CancelResignation(int resgnationid, string Remark)
        {
            int ReturnValue = 0;
            int ResignationID = resgnationid;
            DataTable dt = new bllMaster().GetResignationDetailsbyEmployeeID(ResignationID);
            if (dt != null)
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("ResignationId", ResignationID);
                string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                htParam.Add("Remark", PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Remark);
                ReturnValue = new bllMaster().CancelResignation(htParam);
                if (ReturnValue > 0)
                    CancelResignationEmail(dt, Remark);
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int CancelResignationEmail(DataTable dtResigned, string Remark)
        {
            int ReturnValue = 1;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            string EmailType = string.Empty;
            string ToAddress = string.Empty;
            string ToBCC = string.Empty;
            string ToCC = string.Empty;

            DataTable dtInit = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtInit != null)
            {
                DataTable dt = new bllLogin().GetUserInformation(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]));
                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        int NoOfDays_1 = 0;
                        string ResignationStatus = "";
                        if (Convert.ToString(dtResigned.Rows[0]["Status"]) == "Accept")
                        {
                            ResignationStatus = "Approved";
                        }
                        else
                        {
                            ResignationStatus = "Rejected";
                        }

                        head.Append("<html><head></head><body>");
                        body.Append("<table style=\"width:802px;font-family:Verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:22px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:Verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />Resignation of employee " + Convert.ToString(dt.Rows[0]["FullName"]) + " has been Cancelled.<br /><br /></b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Employee Basic Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Code"]) + " : " + Convert.ToString(dt.Rows[0]["FullName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + " </td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DomainName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b>Resignation Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 1 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Convert.ToString(dtResigned.Rows[0]["ResignationType"])) + "</td></tr>");
                        if (Convert.ToString(dtResigned.Rows[0]["ResignationType"]) == "Termination")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason to terminate:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Reasontoterminate"]) + " </td></tr> ");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else if (Convert.ToString(dtResigned.Rows[0]["ResignationType"]) == "Absconding")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dtResigned.Rows[0]["LastWorkingDate"]) - Convert.ToDateTime(dtResigned.Rows[0]["ResignationDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dtResigned.Rows[0]["ResignationDate"]) + " <b>To:</b> " + Convert.ToString(dtResigned.Rows[0]["LastWorkingDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(NoOfDays_1) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 2 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ResignationStatus) + " </td></tr> " +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 2 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["UnitHeadRemark"]) + " </td></tr> " +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Latest Login Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + "</td></tr>");
                        if (Convert.ToString(dtResigned.Rows[0]["ExitFormalitiesCompleted"]) == "True")
                        {
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Exit Formality Details :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Exit Formalities Completed?:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">Yes</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Exit Formalities Completion Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["ExitFormalitiesRemark"]) + "</td></tr>");
                        }

                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Resignation Cancellation Details :: </b></td></tr>");
                        string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">Cancelled</td></tr>");
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Convert.ToString(Remark) + " </td></tr> ");

                        body.Append("<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                        footer.Append("</body></html>");

                        //Same as Change Resignation

                        DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]), "Change Resignation");
                        ToAddress = Convert.ToString(dtEmail.Rows[0]["ToChangeResignation"]);
                        ToCC = Convert.ToString(dtEmail.Rows[0]["CC"]);
                        ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                        string Pass = new bllMaster().GetPassword("ackdata");

                        MailMessage mail = new MailMessage();
                        mail.From = new MailAddress("ack@infinity-data.com", "HRMS", System.Text.Encoding.UTF8);
                        mail.To.Add(ToAddress);
                        mail.CC.Add(ToCC);
                        mail.Bcc.Add(ToBCC);
                        mail.Subject = "Resignation has been cancelled - User " + Convert.ToString(dt.Rows[0]["Code"]);
                        mail.Body = head.ToString() + body.ToString() + footer.ToString();
                        mail.IsBodyHtml = true;

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
                            return 1;
                        }
                        catch { return 0; }
                    }
                }
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int DeleteUser(int ResignationId, string Remark)
        {
            int ReturnValue = 0;
            DataTable dt = new bllMaster().GetResignationDetails(ResignationId);
            if (dt != null)
            {
                string Code = new bllMaster().GetCodeFromEmployeeId(Convert.ToInt32(dt.Rows[0]["EmployeeID"]));
                string ResignationDate = Convert.ToString(dt.Rows[0]["ResignationDate"]);
                string ResignationType = Convert.ToString(dt.Rows[0]["ResignationType"]);
                string lastWorkingDate = Convert.ToString(dt.Rows[0]["LastWorkingDate"]);
                int AddedBy = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
                string DropOutDate = DateTime.Now.ToString("dd-MMM-yyyy");

                Hashtable htParam = new Hashtable();
                htParam.Add("Code", Code);
                htParam.Add("ResignationDate", ResignationDate);
                htParam.Add("Reason", Convert.ToString(dt.Rows[0]["Remark"]));
                string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                htParam.Add("HRRemark", PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Remark);
                htParam.Add("DropOutDate", DropOutDate);
                htParam.Add("ResignedType", ResignationType);
                htParam.Add("LastWorkingDate", lastWorkingDate);
                htParam.Add("DropOutBy", AddedBy);

                ReturnValue =  new bllMaster().DropOutUser(htParam);

                if (ReturnValue > 0)
                    DeleteUserEmail(dt, Remark);
            }
            return ReturnValue;
        }

        public static int DeleteUserEmail(DataTable dtResigned, string Remark)
        {
            int ReturnValue = 1;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();

            string EmailType = string.Empty;
            string ToAddress = string.Empty;
            string ToCC = string.Empty;
            string ToBCC = string.Empty;


            if (int.Parse(HttpContext.Current.User.Identity.Name.ToString()) == 255)
                EmailType = "Droup Out Employee - Solapur";
            else
                EmailType = "Droup Out Employee";


            /*--------- As per new email changes ---------- */
            //DataTable dt1 = new bllMaster().getEmailConfigrationInfo(EmailType);
            //if (dt1.Rows.Count > 0)
            //{
            //    ToAddress = dt1.Rows[0][2].ToString();
            //    ToCC = Convert.ToString(dt1.Rows[0][3]);
            //    ToBCC = Convert.ToString(dt1.Rows[0][4]);
            //}


            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]), EmailType);
            ToAddress = Convert.ToString(dtEmail.Rows[0]["To"]);
            ToCC = Convert.ToString(dtEmail.Rows[0]["CC"]);
            ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

            DataTable dtInit = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtInit != null)
            {
                DataTable dt = new bllLogin().GetUserInformation(Convert.ToInt32(dtResigned.Rows[0]["EmployeeID"]));
                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        int NoOfDays_1 = 0;
                        string ResignationStatus = "";
                        if (Convert.ToString(dtResigned.Rows[0]["Status"]) == "Accept")
                        {
                            ResignationStatus = "Approved";
                        }
                        else
                        {
                            ResignationStatus = "Rejected";
                        }

                        head.Append("<html><head></head><body>");
                        body.Append("<table style=\"width:802px;font-family:Verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:22px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:Verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />Employee " + Convert.ToString(dt.Rows[0]["FullName"]) + " has been dropped out.<br /><br /></b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Employee Basic Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Code"]) + " : " + Convert.ToString(dt.Rows[0]["FullName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Working Branch:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + " </td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DomainName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b>Resignation Details</b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 1 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Convert.ToString(dtResigned.Rows[0]["ResignationType"])) + "</td></tr>");
                        if (Convert.ToString(dtResigned.Rows[0]["ResignationType"]) == "Termination")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason to terminate:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Reasontoterminate"]) + " </td></tr> ");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else if (Convert.ToString(dtResigned.Rows[0]["ResignationType"]) == "Absconding")
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]) - Convert.ToDateTime(dt.Rows[0]["LastLoginDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " <b>To:</b> " + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(0) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        else
                        {
                            string NoOfDays1 = (Convert.ToDateTime(dtResigned.Rows[0]["LastWorkingDate"]) - Convert.ToDateTime(dtResigned.Rows[0]["ResignationDate"])).TotalDays.ToString();
                            NoOfDays_1 = Convert.ToInt32(NoOfDays1) + 1;
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Notice Period:</b></td><td style=\"border:solid 1px Gray;border-top:none;\"><b>From:</b> " + Convert.ToString(dtResigned.Rows[0]["ResignationDate"]) + " <b>To:</b> " + Convert.ToString(dtResigned.Rows[0]["LastWorkingDate"]) + " :: <b>No of Days:</b> " + Convert.ToString(NoOfDays_1) + "</td></tr>");
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 1 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["Remark"]) + " </td></tr> ");
                        }
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 2 :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Resignation Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ResignationStatus) + " </td></tr> " +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Step 2 Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["UnitHeadRemark"]) + " </td></tr> " +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Latest Login Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["LastLoginDate"]) + "</td></tr>");
                        if (Convert.ToString(dtResigned.Rows[0]["ExitFormalitiesCompleted"]) == "True")
                        {
                            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Exit Formality Details :: </b></td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Exit Formalities Completed?:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">Yes</td></tr>" +
                            "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Exit Formalities Completion Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtResigned.Rows[0]["ExitFormalitiesRemark"]) + "</td></tr>");
                        }

                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none; text-align:center;\" colspan=\"2\"><b> :: Step 3 :: </b></td></tr>");
                        string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Convert.ToString(Remark) + " </td></tr> ");

                        body.Append("<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                        footer.Append("</body></html>");

                        string Pass = new bllMaster().GetPassword("ackdata");

                        MailMessage mail = new MailMessage();
                        mail.From = new MailAddress("ack@infinity-data.com", "HRMS", System.Text.Encoding.UTF8);
                        mail.To.Add(ToAddress);
                        mail.CC.Add(ToCC);
                        mail.Bcc.Add(ToBCC);
                        mail.Subject = "Step 3:- User " + Convert.ToString(dt.Rows[0]["Code"]) + " has been dropped out.";
                        mail.Body = head.ToString() + body.ToString() + footer.ToString();
                        mail.IsBodyHtml = true;

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
                            return 1;
                        }
                        catch { return 0; }
                    }
                }
            }
            return ReturnValue;
        }

        [WebMethod]
        public static string GetDirectDropoutEmployees()
        {
            DataTable dt1 = new bllMaster().GetDirectDropoutEmployees();
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
        public static int DirectDropoutUser(int ResignationId, string Remark)
        {
            int ReturnValue = 0;

            DataTable dt = new bllMaster().GetResignationDetails(ResignationId);
            if (dt != null)
            {
                string Code = new bllMaster().GetCodeFromEmployeeId(Convert.ToInt32(dt.Rows[0]["EmployeeID"]));
                string ResignationDate = Convert.ToString(dt.Rows[0]["ResignationDate"]);
                string ResignationType = Convert.ToString(dt.Rows[0]["ResignationType"]);
                string lastWorkingDate = Convert.ToString(dt.Rows[0]["LastWorkingDate"]);
                int AddedBy = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
                string DropOutDate = DateTime.Now.ToString("dd-MMM-yyyy");

                Hashtable htParam = new Hashtable();
                htParam.Add("Code", Code);
                htParam.Add("ResignationDate", ResignationDate);
                htParam.Add("Reason", Convert.ToString(dt.Rows[0]["Remark"]));
                string PM = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                htParam.Add("HRRemark", PM + " :: " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " :: " + Remark);
                htParam.Add("DropOutDate", DropOutDate);
                htParam.Add("ResignedType", ResignationType);
                htParam.Add("LastWorkingDate", lastWorkingDate);
                htParam.Add("DropOutBy", AddedBy);

                ReturnValue = new bllMaster().DropOutUser(htParam);
            }
            return ReturnValue;
        }
    }
}
