using DocumentFormat.OpenXml.Bibliography;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class UserProjectNotifications : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string MainPath = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            MainPath = Server.MapPath(@"~\EmployeeDocuments\DashboardAlert");
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
            }
            catch { }
        }
        [WebMethod]
        public static string GetAllDashboardAlert()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllOSTNotifications");

            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId",
                SqlDbType.BigInt, 0, ParameterDirection.Input,
                Convert.ToInt32(HttpContext.Current.User.Identity.Name));

            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);

            return JsonConvert.SerializeObject(dt);
        }

        [WebMethod]
        public static string GetAllDomains()
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = new bllMaster().GetAllDomainGroups();
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
        public static string GetSubdomains(int DomainGroupId)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = new bllMaster().GetAllDomain_Notifications(DomainGroupId);
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
        public static string GetDomainwiseProjects(int SubdomainID)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = new bllMaster().GetAllProjects_UserNotifications(SubdomainID);
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
        public static string GetProjectwiseUsers(string ProjectName, string Subdomain)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = new bllMaster().GetAllUser_UserNotifications(ProjectName, Subdomain);
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
        public static int InsertProjectNotification(string Subject, string Message, string EffectiveDate, int DomainID, int SubdomainID, string Project, string Users)
        {
            int ReturnValue = 0;
        
            Hashtable htParam = new Hashtable();
            htParam.Add("Subject", Subject);
            htParam.Add("Message", Message);
            htParam.Add("EffectiveDate", EffectiveDate);
            htParam.Add("Domain", DomainID);
            htParam.Add("SubDomain", SubdomainID);
            htParam.Add("Project", Project);
            if (NewFileName != "")
            {
                if (!Directory.Exists(MainPath))
                {
                    Directory.CreateDirectory(MainPath);
                }

                File.Copy(NewFileName, MainPath + "\\" + GUIDFile);
                File.Delete(NewFileName);
                htParam.Add("Attachment", MainPath + "\\" + GUIDFile);
            }
            else
                htParam.Add("Attachment", "");
            htParam.Add("Users", Users);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue =  new bllMaster().InsertProjectNotifications(htParam);

            return ReturnValue;
        }
    }
}