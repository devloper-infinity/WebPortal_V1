using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using System.Text;
using System.IO;

namespace WebPortal.Admin
{
    public partial class RewardAndRecognition : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static StringBuilder filelist = new StringBuilder();

        protected void Page_Load(object sender, EventArgs e)
        {
            filelist = new StringBuilder();

            FolderPath = Server.MapPath(@"~\EmployeeDocuments\Reward");
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
                    string filename = Convert.ToString(Request.Files["RewardRecg_attachment"].FileName);
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
            DataTable dt1 = new bllMaster().GetAllEmployeeForAttendancePercentage();
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
        public static string GetGridData()
        {
            DataTable dt1 = new bllMaster().GetRnR();
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
        public static string GetAllRnRSnaps()
        {
            DataTable dt1 = new bllMaster().GetAllRnRSnaps();
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
        public static int InsertRewardDetails(string Year, string Quarter, string FinalStatus, string Employees)
        {
            int returnvalue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("Year", Year);
            htParam.Add("Quarter", Quarter);
            htParam.Add("FinalStatus", FinalStatus);
            htParam.Add("Employees", Employees);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue =  new bllMaster().InsertRnR(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int InsertRnRSnaps(string Year, string Quarter, int Location, string LocationName)
        {
            int ReturnValue = 0;
            StringBuilder filelisttobesave = new StringBuilder();

            Hashtable htParam = new Hashtable();
            htParam.Add("Year", Year);
            htParam.Add("Quarter", Quarter);
            htParam.Add("FinalStatus", "Pending");
            htParam.Add("Location", Location);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            if (filelist.ToString() != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }

                string SubPath = FolderPath + "\\" + Year;
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }

                string UniquePath = SubPath + "\\" + Quarter;
                if (!Directory.Exists(UniquePath))
                {
                    Directory.CreateDirectory(UniquePath);
                }
                string LocationPath = UniquePath + "\\" + LocationName;

                if (!Directory.Exists(LocationPath))
                {
                    Directory.CreateDirectory(LocationPath);
                }

                string[] files = filelist.ToString().Split(',');

                for (int i = 0; i < files.Length; i++)
                {
                    File.Copy(files[i], LocationPath + "\\" + files[i].Substring(files[i].LastIndexOf("\\") + 1));
                    if (filelisttobesave.ToString() == "")
                        filelisttobesave.Append(LocationPath + "\\" + files[i].Substring(files[i].LastIndexOf("\\") + 1));
                    else
                        filelisttobesave.Append("," + LocationPath + "\\" + files[i].Substring(files[i].LastIndexOf("\\") + 1));
                }
                htParam.Add("Snaps", filelisttobesave);
            }
            else
            {
                htParam.Add("Snaps", "");
            }

            ReturnValue = new bllMaster().InsertRnRSnaps(htParam);
            return ReturnValue;
        }
    }
}