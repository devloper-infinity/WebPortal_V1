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
    public partial class Requisition : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static List<Domain> GetAllDomainGroups()
        {
            DataTable dtDomainGroups = new bllMaster().GetAllDomain();

            List<Domain> domains = new List<Domain>();
            domains = ConvertDataTable<Domain>(dtDomainGroups);
            return domains;
        }

        [WebMethod]
        public static List<WebPortal.App_Code.Class.RequisitionProfile> GetAllRequisitionProfiles()
        {
            DataTable dtProfiles = new bllRequisition().GetAllProfiles();

            List<WebPortal.App_Code.Class.RequisitionProfile> pro = new List<WebPortal.App_Code.Class.RequisitionProfile>();
            pro = ConvertDataTable<WebPortal.App_Code.Class.RequisitionProfile>(dtProfiles);
            return pro;
        }

        [WebMethod]
        public static List<Subdomain> GetSubdomains(int DomainGroupId)
        {
            DataTable dtProcess = new bllRequisition().GetAllSubdomains(DomainGroupId);
            List<Subdomain> subdomains = new List<Subdomain>();
            subdomains = ConvertDataTable<Subdomain>(dtProcess);
            return subdomains;
        }

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
        public static List<Shift> GetShift()
        {
            DataTable dtShift = new bllMaster().GetAllShift();

            List<Shift> shifts = new List<Shift>();
            shifts = ConvertDataTable<Shift>(dtShift);
            return shifts;
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
        public static string GetAllRequisitions()
        {
            DataTable dt1 = new bllRequisition().GetAllRecruitmentByUserID(Convert.ToInt32(HttpContext.Current.User.Identity.Name));
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
        public static string GetAllRequisitionsByRecId(int RecId)
        {
            DataTable dt1 = new bllRequisition().GetAllRecruitmentByRecID(RecId);
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
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    T item = GetItem<T>(row);
                    data.Add(item);
                }
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
        public static int ApproveRequisitions(int RecId, string SalaryRange)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("RecId", RecId);
            htParam.Add("SalaryRange", SalaryRange);
            htParam.Add("ApprovedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllRequisition().ApproveRequisition(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int InsertRequisition(int Profile, int Noofpositions, int Domain, string subdomain, int Project, int Process, int Shift, string Location, string EmploymentType, int department, string Remark, string Deadline, string Source)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("Designation", Profile);
            htParam.Add("Noofpositions", Noofpositions);
            htParam.Add("Domain", Domain);
            htParam.Add("Subdomain", subdomain);
            htParam.Add("Project", Project);
            htParam.Add("Other", "");
            htParam.Add("Process", Process);
            htParam.Add("Shift", Shift);
            htParam.Add("Location", Location);
            htParam.Add("EmployementType", EmploymentType);
            htParam.Add("Department", department);
            htParam.Add("IntiatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("SkillRequired", "");
            htParam.Add("Remark", Remark);
            htParam.Add("Deadline", Deadline);
            htParam.Add("SalaryRange", "");
            htParam.Add("Source", Source);

            returnvalue = new bllRequisition().InsertRecruitment(htParam);
           
            if (returnvalue > 0)
            {
               SendRequisitionEmail(returnvalue);
            }

            return returnvalue;
        }

        [WebMethod]
        public static int SendRequisitionEmail(int RecId)
        {
            int ReturnValue = 1;
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
            DataTable dt = new bllRequisition().GetRequisitionById_Email(RecId);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:verdana; font-size:12px; border-radius:10px;\" bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                        "<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                        "<tr><td style=\"text-align:left; font-size:11px;\" colspan=\"2\"><b>Dear HR Team,<br />New Requisition is added in system. Please find details below.<br /><br /></b></td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;\" width=\"120px\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DomainName"]) + " </td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Subdomain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Subdomain"]) + "</td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Profile:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Profile"]) + "</td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Location"]) + "</td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>No. of Positions:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Noofpositions"]) + "</td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Initiated By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["InitiatedBy"]) + "</td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Status:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["Status"]) + "</td></tr>" +
                        "<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Approved By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ApprovedBy"]) + "</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                    footer.Append("</body></html>");

                    string Pass = new bllMaster().GetPassword("ackdata");
                    string ToAddress = string.Empty;
                    string ToBCC = string.Empty;
                    string ToCC = string.Empty;

                    DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), "HrReport");
                    ToAddress = Convert.ToString(dtEmail.Rows[0]["To"]);
                    ToCC = Convert.ToString(dtEmail.Rows[0]["CC"]);
                    ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Infinity Requisitions", System.Text.Encoding.UTF8);
                    //mail.To.Add("j.rucha@infinityinternationals.us");
                    //mail.To.Add("g.trupti@infinityinternationals.us");
                    ////mail.To.Add("n.nilkanth@infinityinternationals.us");
                    //mail.Bcc.Add("n.nilkanth@infinityinternationals.us");

                    mail.To.Add(ToAddress);
                    mail.To.Add(ToCC);
                    mail.Bcc.Add(ToBCC);

                    mail.Subject = "New requisition added for position " + Convert.ToString(dt.Rows[0]["Profile"]) + ".";
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
                        ReturnValue = 1;
                        return 1;
                    }
                    catch (Exception ex) { return 0; }

                }
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int CloseRequisitions(int RecID, string ClosureRemark)
        {
            int returnvalue = 0;
            returnvalue = new bllRequisition().CloseRecruitement(RecID, ClosureRemark, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            return returnvalue;
        }
    }
}