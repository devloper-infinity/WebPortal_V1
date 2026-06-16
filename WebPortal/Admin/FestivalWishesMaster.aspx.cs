using AjaxControlToolkit.HTMLEditor.Popups;
using DocumentFormat.OpenXml.Drawing.Diagrams;
using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class FestivalWishesMaster : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static StringBuilder filelist = new StringBuilder();

        protected void Page_Load(object sender, EventArgs e)
        {
            filelist = new StringBuilder();
            FolderPath = Server.MapPath(@"~\FestivalWishesImages");
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
                    NewFileName = FolderPath + "\\" + file_Name;
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
        public static string GetFestivalMaster()
        {
            DataTable dt1 = new bllMaster().GetFestivalMaster();

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
        public static string InsertFestiveData(string Title, string StartDate, string Location, string Department, string Designation, string User, string Gender)
        {
            string msg = string.Empty;

            try
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("Title", Title);
                htParam.Add("StartDate", StartDate);
                htParam.Add("Remark", "");
                htParam.Add("ImagePath", NewFileName);
                htParam.Add("MessageHtml", "");
                htParam.Add("EndDate", "");
                htParam.Add("IsPopup", true);
                htParam.Add("IsActive", true);

                htParam.Add("Branch", Location);
                htParam.Add("Department", Department);
                htParam.Add("Designation", Designation);
                htParam.Add("Users", User);
                htParam.Add("Gender", Gender);

                htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                int ReturnValue =  new bllMaster().InsertFestiveData(htParam);

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

        [WebMethod]
        public static string DeleteFestivalImages(int FestivalID)
        {
            string msg = string.Empty;

            try
            {
                int ReturnValue = new bllMaster().DeleteFestivalImages(FestivalID, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                if (ReturnValue > 0)
                {
                    msg = "Record deleted successfully!";
                }
                else
                {
                    msg = "Error deleting record";
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