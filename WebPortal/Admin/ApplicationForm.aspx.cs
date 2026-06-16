using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebPortal.Admin
{
    public partial class ApplicationForm : System.Web.UI.Page
    {
        static string NewFileName = "";
        protected void Page_Load(object sender, EventArgs e)
        {

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
                if (!Directory.Exists(Server.MapPath(@"~/Resumes/" + DateTime.Now.ToString("dd-MMM-yyyy"))))
                {
                    Directory.CreateDirectory(Server.MapPath(@"~/Resumes/" + DateTime.Now.ToString("dd-MMM-yyyy")));
                }
                NewFileName = Server.MapPath("..//Resumes//" + DateTime.Now.ToString("dd-MMM-yyyy") + "//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
                string filename = Convert.ToString(Request.Files["attachment"].FileName);
            }
            catch { }
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
        public static List<WebPortal.App_Code.Class.RequisitionProfile> GetRequisitionProfiles()
        {
            DataTable dtProfiles = new bllRequisition().GetAllProfiles();

            List<WebPortal.App_Code.Class.RequisitionProfile> prj = new List<WebPortal.App_Code.Class.RequisitionProfile>();
            prj = ConvertDataTable<WebPortal.App_Code.Class.RequisitionProfile>(dtProfiles);
            return prj;
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
        public static List<Subdomain> GetSubdomains()
        {
            DataTable dtProcess = new bllMaster().GetSubdomains();
            List<Subdomain> subdomains = new List<Subdomain>();
            subdomains = ConvertDataTable<Subdomain>(dtProcess);
            return subdomains;
        }

        [WebMethod]
        public static int InsertInstantApplication(int Profile, string Location, string Source, string Title, string Firstname, string Middlename, string Lastname, string Gender, string Contact, string Birthdate, string Email, string Presentaddress, string Presentpincode, string Permanentaddress, string Permanentpincode, int Domain, string Subdomain, string remark)
        {
            int returnvalue = 0;
            string file = NewFileName;
            Hashtable htParam = new Hashtable();
            Hashtable htInstAppForm = new Hashtable();

            htInstAppForm["PositionApplied"] = Profile;
            htInstAppForm["Location"] = Location;
            htInstAppForm["Source"] = Source;
            htInstAppForm["Title"] = Title;
            htInstAppForm["LastName"] = Lastname.ToUpper();
            htInstAppForm["FirstName"] = Firstname.ToUpper();
            htInstAppForm["MiddleName"] = Middlename.ToUpper();
            htInstAppForm["Gender"] = Gender;
            htInstAppForm["CellPhoneNo"] = Contact;
            htInstAppForm["PresentAddress"] = Presentaddress;
            htInstAppForm["PreAddPinCode"] = Presentpincode;
            htInstAppForm["PermanentAddress"] = Permanentaddress;
            htInstAppForm["PermenentAddPinCode"] = Permanentpincode;
            htInstAppForm["Domain"] = Domain;
            htInstAppForm["SubDomain"] = Subdomain;
            htInstAppForm["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            htInstAppForm["DateOfBirth"] = Birthdate;
            htInstAppForm["EmailID"] = Email;
            htInstAppForm["Remark"] = remark;
            htInstAppForm["Resume"] = file;

            int ReturnValue =  new bllRequisition().InsertInstanceAppllicationForm(htInstAppForm);
            return ReturnValue;
        }
    }
}