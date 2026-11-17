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

            returnvalue =  new bllRequisition().InsertRecruitment(htParam);

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
            StringBuilder body = new StringBuilder();
            DataTable dt = new bllRequisition().GetRequisitionById_Email(RecId);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    DataRow requisition = dt.Rows[0];
                    body.Append("<p style=\"margin:0 0 8px;color:#0f172a;font-size:16px;font-weight:700;line-height:24px;\">Hello HR Team,</p>" +
                        "<p style=\"margin:0 0 24px;color:#475569;font-size:14px;line-height:22px;\">A new requisition has been submitted in HRMS. The key details are summarized below.</p>" +
                        "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;border:1px solid #e2e8f0;border-radius:10px;border-collapse:separate;overflow:hidden;\">" +
                        "<tr><td colspan=\"2\" style=\"padding:12px 14px;background-color:#173b70;color:#ffffff;font-size:14px;font-weight:700;line-height:20px;\">Requisition Details</td></tr>");

                    AppendRequisitionEmailDetailRow(body, "Domain", requisition["DomainName"]);
                    AppendRequisitionEmailDetailRow(body, "Subdomain", requisition["Subdomain"]);
                    AppendRequisitionEmailDetailRow(body, "Profile", requisition["Profile"]);
                    AppendRequisitionEmailDetailRow(body, "Location", requisition["Location"]);
                    AppendRequisitionEmailDetailRow(body, "Number of positions", requisition["Noofpositions"]);
                    AppendRequisitionEmailDetailRow(body, "Initiated by", requisition["InitiatedBy"]);
                    AppendRequisitionEmailDetailRow(body, "Status", requisition["Status"]);
                    AppendRequisitionEmailDetailRow(body, "Approved by", requisition["ApprovedBy"]);
                    body.Append("</table>");

                    string Pass = new bllMaster().GetPassword("ackdata");
                    string ToAddress = string.Empty;
                    string ToBCC = string.Empty;
                    string ToCC = string.Empty;

                    DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), "HrReport");
                    ToAddress = Convert.ToString(dtEmail.Rows[0]["To"]);
                    ToCC = Convert.ToString(dtEmail.Rows[0]["CC"]);
                    ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                    //ToAddress = "b.shubhangi@infinity-data.com";
                    //ToCC = "b.shubhangi@infinity-data.com";
                    //ToBCC = "b.shubhangi@infinity-data.com";

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
                    mail.Body = WebPortal.App_Code.Class.SelfLeavesEmailTemplate.Apply(
                        body.ToString(),
                        "New requisition",
                        true);
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

        private static void AppendRequisitionEmailDetailRow(StringBuilder email, string label, object value)
        {
            email.Append("<tr><td width=\"34%\" style=\"width:34%;padding:11px 14px;border-top:1px solid #e2e8f0;color:#64748b;font-size:12px;font-weight:700;line-height:19px;vertical-align:top;\">")
                .Append(HttpUtility.HtmlEncode(label))
                .Append("</td><td style=\"padding:11px 14px;border-top:1px solid #e2e8f0;color:#1e293b;font-size:13px;line-height:19px;vertical-align:top;\">")
                .Append(HttpUtility.HtmlEncode(Convert.ToString(value)))
                .Append("</td></tr>");
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
