using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;
using WebPortal.App_Code.BLL;
using System.Collections;

namespace WebPortal.Admin
{
    public partial class ViewEmployee : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static StringBuilder filelist = new StringBuilder();

        protected void Page_Load(object sender, EventArgs e)
        {
            filelist = new StringBuilder();
            FolderPath = Server.MapPath(@"~\EmployeeDocuments");

            try
            {
                for (int i = 0; i < HttpContext.Current.Request.Files.Count; i++)
                {
                    HttpContext postedContext = HttpContext.Current;
                    HttpPostedFile file = postedContext.Request.Files[i];

                    string name = file.FileName;
                    byte[] binaryWriteArray = new byte[file.InputStream.Length];
                    file.InputStream.Read(binaryWriteArray, 0,
                    (int)file.InputStream.Length);

                    FileInfo file_Info = new FileInfo(file.FileName);
                    string ext = file_Info.Extension;

                    //string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                    // GUIDFile = file_Name;
                    NewFileName = Server.MapPath("..//TempFiles//" + file.FileName);
                    if (filelist.ToString() == "")
                        filelist.Append(NewFileName);
                    else
                        filelist.Append("," + NewFileName);
                    FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                    objfilestream.Write(binaryWriteArray, 0,
                    binaryWriteArray.Length);
                    objfilestream.Close();

                    string filename = Convert.ToString(Request.Files["uploaddocs_emp"].FileName);
                }
            }
            catch { }
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
        public static string GetAllEmployees()
        {
            DataTable dt1 = new bllMaster().GetAllEmployeeDetails();
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
        public static int uploadEmpDocuments(string Code)
        {
            int returnvalue = 0;
            StringBuilder filelisttobesave = new StringBuilder();

            if (filelist.ToString() != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                string SubPath = FolderPath + "\\" + Code;
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }

                string[] files = filelist.ToString().Split(',');

                for (int i = 0; i < files.Length; i++)
                {
                    string UniquePath = SubPath + "\\" + files[i].Substring(files[i].LastIndexOf("\\") + 1);

                    File.Copy(files[i], UniquePath);

                    Hashtable htParam = new Hashtable();
                    htParam.Add("Code", Code);
                    htParam.Add("DocumentType", "");
                    htParam.Add("DocumentPath", UniquePath);
                    htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                    returnvalue = new bllMaster().UploadEmployeeDocument(htParam);
                }
            }
            else
            {

            }

            return returnvalue;
        }
    }
}