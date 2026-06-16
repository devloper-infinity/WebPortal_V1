using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
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

namespace WebPortal.Admin
{
    public partial class AddApplicantRemark : System.Web.UI.Page
    {
        static string UrlType = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            string AppId = Convert.ToString(Request.QueryString["AppId"]);
            string shortlistremark = Convert.ToString(Request.QueryString["ShortlistedRemark"]);
            string InResult = Convert.ToString(Request.QueryString["InResult"]);
            if (!IsPostBack)
            {
                if (Convert.ToString(AppId) != "" && AppId != null)
                {
                    BindGrid(int.Parse(AppId));
                    UrlType = "AppId";
                }
                else if (Convert.ToString(shortlistremark) != "" && shortlistremark != null)
                {
                    BindGrid(int.Parse(shortlistremark));
                    UrlType = "ShortlistedRemark";
                }
                else if (Convert.ToString(InResult) != "" && InResult != null)
                {
                    BindGrid(int.Parse(InResult));
                    UrlType = "InResult";
                }
            }
        }

        public void BindGrid(int AppId)
        {
            grdRemark.DataSource = new bllRequisition().GetApplicantRemark(AppId);
            grdRemark.DataBind();
        }

        [WebMethod]
        public static string GetApplicantDetails(int AppId)
        {
            DataTable dt1 = new bllRequisition().getApplicantListById(AppId);
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
        public static List<Domain> GetAllDomains()
        {
            DataTable dtdomain = new bllMaster().GetAllDomain();
            List<Domain> domains = new List<Domain>();
            domains = ConvertDataTable<Domain>(dtdomain);
            return domains;
        }
        [WebMethod]
        public static List<Department> GetDepartment()
        {
            DataTable dtdept = new bllMaster().GetAllDepartment();

            List<Department> depart = new List<Department>();
            depart = ConvertDataTable<Department>(dtdept);
            return depart;
        }

        [WebMethod]
        public static List<Designation> GetDesignation()
        {
            DataTable dtdesg = new bllMaster().GetAllDesignation();

            List<Designation> desg = new List<Designation>();
            desg = ConvertDataTable<Designation>(dtdesg);
            return desg;
        }

        [WebMethod]
        public static List<WebPortal.App_Code.Class.Requisition> GetAllRequisitions()
        {
            DataTable dtRec = new bllRequisition().GetAllRequisition("OpenRemark");
            List<WebPortal.App_Code.Class.Requisition> Rec = new List<WebPortal.App_Code.Class.Requisition>();
            Rec = ConvertDataTable<WebPortal.App_Code.Class.Requisition>(dtRec);
            return Rec;

        }

        [WebMethod]
        public static List<WebPortal.App_Code.Class.Branch> GetBranches()
        {
            DataTable dtBranch = new bllMaster().GetAllBranches();
            List<WebPortal.App_Code.Class.Branch> Bra = new List<WebPortal.App_Code.Class.Branch>();
            Bra = ConvertDataTable<WebPortal.App_Code.Class.Branch>(dtBranch);
            return Bra;
        }

        [WebMethod]
        public static List<WebPortal.App_Code.Class.ProjectManager> GetProjectManagers()
        {
            DataTable dtPM = new bllMaster().GetAllProjectManager();
            List<WebPortal.App_Code.Class.ProjectManager> PM = new List<WebPortal.App_Code.Class.ProjectManager>();
            PM = ConvertDataTable<WebPortal.App_Code.Class.ProjectManager>(dtPM);
            return PM;

        }

        [WebMethod]
        public static List<Shift> GetShift()
        {
            DataTable dtShift = new bllMaster().GetAllShift();

            List<Shift> shifts = new List<Shift>();
            shifts = ConvertDataTable<Shift>(dtShift);
            return shifts;
        }

        [WebMethod]
        public static int InsertApplicantRemark1(int AppId, string Remark, int Domain, string Process, string Status, string Intdate, string Inttime, int Interviewer, string Method, string Location, string Currentsalary, string Expectedsalary, string Finalsalary)
        {
            int returnvalue = 0;
            return returnvalue;
        }

        [WebMethod]
        public static int InsertApplicantRemark(int AppId, string Remark, int Domain, string Process, string Status, string Intdate, string Inttime, int Interviewer, string Method, string Location, string Currentsalary, string Expectedsalary, string Finalsalary, string Expjoiningdate, int Department, int Designation, int Reportingmanager, int Shift, string Cutofftime, string Otherremark, int RequisitionID, string Requisition, string Name, string PositionApplied, string DepartmentName, string DesignationName, string ManagerName)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("ApplicationId", Convert.ToInt32(AppId));
            htParam.Add("Remark", Remark);
            htParam.Add("Domain", Domain);
            htParam.Add("Process", Process);
            htParam.Add("Status", Status);
            if (Status == "Proceed For Next Round")
            {
                htParam.Add("InterviewDate", Intdate);
                htParam.Add("InterviewTime", Inttime);
                htParam.Add("Interviewer", Interviewer);
                htParam.Add("InterviewMethod", Method);
                htParam.Add("InterviewLocation", Location);
                htParam.Add("CurrentSalary", Currentsalary);
                htParam.Add("ExpectedSalary", Expectedsalary);
            }
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("FinalSalary", Finalsalary);

            htParam.Add("ExpJoiningDate", Expjoiningdate);
            htParam.Add("Department", Department);
            htParam.Add("Designation", Designation);
            htParam.Add("ReportingManager", Reportingmanager);
            htParam.Add("Shift", Shift);
            htParam.Add("CutOffTime", Cutofftime);
            htParam.Add("OtherRemark", Otherremark);
            if (RequisitionID > 0)

                if (Requisition == "Other")
                {
                    RequisitionID = 0;
                    htParam.Add("RequisitionID", RequisitionID);
                }
                else
                {
                    htParam.Add("RequisitionID", RequisitionID);
                }
            else
                htParam.Add("RequisitionID", 0);
            if (UrlType == "InResult" && Status == "Selected")
                htParam.Add("IsResult", Convert.ToBoolean("True"));
            else
                htParam.Add("IsResult", Convert.ToBoolean("False"));

            returnvalue = new bllRequisition().InsertApplicantRemark(htParam);
            if (returnvalue > 0)
            {
                if (Status == "Proceed For Next Round" || (Status == "Selected" && UrlType == "ShortlistedRemark"))
                {
                    SendInterviewEmail(AppId, Remark, Domain, Process, Status, Intdate, Inttime, Interviewer, Method, Location, Currentsalary, Expectedsalary, Finalsalary, Expjoiningdate, Department, Designation, Reportingmanager, Shift, Cutofftime, Otherremark, RequisitionID, Requisition, Name, PositionApplied, DepartmentName, DesignationName, ManagerName);
                }
            }
            return returnvalue;
        }


        [WebMethod]
        public static int SendInterviewEmail(int AppId, string Remark, int Domain, string Process, string Status, string Intdate, string Inttime, int Interviewer, string Method, string Location, string Currentsalary, string Expectedsalary, string Finalsalary, string Expjoiningdate, int Department, int Designation, int Reportingmanager, int Shift, string Cutofftime, string Otherremark, int RequisitionID, string Requisition, string Name, string PositionApplied, string DepartmentName, string DesignationName, string ManagerName)
        {
            int ReturnValue = 1;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
            string AddedByName = "";

            DataTable dtInit = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtInit != null)
            {
                if (dtInit.Rows.Count > 0)
                {
                    AddedByName = Convert.ToString(dtInit.Rows[0]["Code"]) + " : " + Convert.ToString(dtInit.Rows[0]["FirstName"]) + " " + Convert.ToString(dtInit.Rows[0]["lastName"]);
                }
            }

            head.Append("<html><head></head><body>");
            body.Append("<table style=\"width:802px;font-family:monospace; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
            if (Status == "Proceed For Next Round")
            {
                body.Append("<table border=\"0\" style=\"width:800px;font-family:monospace; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                "<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />An Interview has been scheduled. Please find information below for your reference.<br /><br /></b></td></tr>" +
                "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Candidate Details</b></td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Application ID:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(AppId) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Candidate Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Name) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Position Applied:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PositionApplied) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Interview Date & Time:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Intdate) + " " + Convert.ToString(Inttime) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Interview Method:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Method) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Interview Location:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Location) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Current Salary:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Currentsalary) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Expected Salary:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Expectedsalary) + "</td></tr></table>");
            }
            else
            {
                body.Append("<table border=\"0\" style=\"width:800px;font-family:monospace; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                "<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><b>Dear Sir/Madam,<br />Applicant " + Convert.ToString(Name) + " has been selected for position <b>" + Convert.ToString(PositionApplied) + "</b>.<br /><br /></b></td></tr>" +
                "<tr><td style=\"border:solid 1px Gray; text-align:center;\" colspan=\"2\"><b>Applicant Details</b></td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Applicant Name:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Name) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(DepartmentName) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(DesignationName) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ManagerName) + " " + Convert.ToString(Inttime) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Expected joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToDateTime(Expjoiningdate).ToString("dd-MMM-yyyy") + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Final Salary:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Finalsalary) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Otherremark) + "</td></tr>" +
                "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark Added By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(AddedByName) + "</td></tr></table>");
            }

            body.Append("<table border=\"0\" style=\"width:800px;font-family:monospace; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\"><tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
             "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
             "</table>");
            footer.Append("</body></html>");

            string Pass = new bllMaster().GetPassword("ackdata");

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("ack@infinity-data.com", "Interview Notifications", System.Text.Encoding.UTF8);
            mail.To.Add("n.nilkanth@infinityinternationals.us");
            mail.Subject = "Interview scheduled for Application ID: " + Convert.ToString(AppId);
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
                //client.Send(mail);
                return 1;
            } 
            catch { return 0; }
            return ReturnValue;
        }
    }
}