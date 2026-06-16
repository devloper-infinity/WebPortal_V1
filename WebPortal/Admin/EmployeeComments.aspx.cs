using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class EmployeeComments : System.Web.UI.Page
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

                    string file_Name = name;// Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                    GUIDFile = file_Name;
                    NewFileName = file_Name; // FolderPath + "\\" + file_Name;
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
            }
            catch { }
        }



        [WebMethod]
        public static string GetUserInformation(int EmployeeId)
        {
            System.Data.DataTable dt1 = new bllLogin().GetUserInformation(EmployeeId);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (System.Data.DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (System.Data.DataColumn col in dt1.Columns)
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
        public static string GetEmployeeComment()
        {
            DataTable dt1 = new bllMaster().GetEmployeeComment();

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
        public static string InsertEmployeeComments(int EmployeeID, string Code, string Subject, string Comment)
        {
            string msg = string.Empty;

            try
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

                string UniquePath = SubPath + "\\" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);

                File.Copy(NewFileName, UniquePath);

                Hashtable htParam = new Hashtable();
                htParam.Add("Subject", Subject);
                htParam.Add("Comment", Comment);
                htParam.Add("Attachment", UniquePath);
                htParam.Add("EmployeeID", EmployeeID);
                htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                int ReturnValue =  new bllMaster().InsertEmployeeComment(htParam);

                if (ReturnValue > 0)
                {
                    msg = "Data saved successfully!";
                }
                else
                {
                    msg = "Error saving data";
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
            return msg;
        }

    }
}