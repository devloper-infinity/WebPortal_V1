using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class FunFriday : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static StringBuilder filelist = new StringBuilder();
        protected void Page_Load(object sender, EventArgs e)
        {
            filelist = new StringBuilder();
            FolderPath = Server.MapPath(@"~\BillingDocuments");
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

                    string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                    GUIDFile = file_Name;
                    NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                    if (filelist.ToString() == "")
                        filelist.Append(NewFileName);
                    else
                        filelist.Append("," + NewFileName);
                    FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                    objfilestream.Write(binaryWriteArray, 0,
                    binaryWriteArray.Length);
                    objfilestream.Close();
                    string filename = Convert.ToString(Request.Files["funfriday_attachment"].FileName);
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
        public static List<WebPortal.App_Code.Class.Branch> GetBranches()
        {
            DataTable dtBranch = null;
            dtBranch = new bllMaster().GetAllBranches();
            List<WebPortal.App_Code.Class.Branch> Bra = new List<WebPortal.App_Code.Class.Branch>();
            Bra = ConvertDataTable<WebPortal.App_Code.Class.Branch>(dtBranch);
            return Bra;

        }

        [WebMethod]
        public static string GetFunFridayData()
        {
            DataTable dt1 = new bllMaster().GetFunFriday();
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
        public static string GetFunFridaySnapsByID(int FFID)
        {
            DataTable dt1 = new bllMaster().GetFunFridaySnapsByID(FFID);
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
        public static int InsertFunFridayData(string Date, string Activity, int LocationID, string Details)
        {
            int returnvalue = 0;
            StringBuilder filelisttobesave = new StringBuilder();
            Hashtable htParam = new Hashtable();
            htParam.Add("Date", Convert.ToDateTime(Date).ToString("dd-MMM-yyyy"));
            htParam.Add("Activity", Activity);
            htParam.Add("Location", LocationID);
            htParam.Add("Details", Details);
            if (filelist.ToString() != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                string SubPath = FolderPath + "\\" + Convert.ToString(Date);
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                string UniquePath = SubPath + "\\" + DateTime.Now.ToString("hhmmss");
                if (!Directory.Exists(UniquePath))
                {
                    Directory.CreateDirectory(UniquePath);
                }

                string[] files = filelist.ToString().Split(',');
                for (int i = 0; i < files.Length; i++)
                {
                    File.Copy(files[i], UniquePath + "\\" + files[i].Substring(files[i].LastIndexOf("\\") + 1));
                    if (filelisttobesave.ToString() == "")
                        filelisttobesave.Append(UniquePath + "\\" + files[i].Substring(files[i].LastIndexOf("\\") + 1));
                    else
                        filelisttobesave.Append("," + UniquePath + "\\" + files[i].Substring(files[i].LastIndexOf("\\") + 1));
                }
                htParam.Add("Snaps", filelisttobesave);
            }
            else
            {
                htParam.Add("Snaps", "");
            }

            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertFunFriday(htParam);
            return returnvalue;
        }
    }
}