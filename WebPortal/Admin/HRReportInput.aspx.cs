using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class HRReportInput : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string MainPath = "";
        static string Rating_MainPath = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            MainPath = Server.MapPath(@"~\EmployeeDocuments\SocialSiteVisits");
            Rating_MainPath = Server.MapPath(@"~\EmployeeDocuments\GlassDoor");
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
                //string filename = Convert.ToString(Request.Files["socialsite_attachment"].FileName);
            }
            catch
            {
            }

            //try
            //{
            //    HttpContext postedContext = HttpContext.Current;
            //    HttpPostedFile file = postedContext.Request.Files[0];

            //    string name = file.FileName;
            //    byte[] binaryWriteArray = new byte[file.InputStream.Length];
            //    file.InputStream.Read(binaryWriteArray, 0,
            //    (int)file.InputStream.Length);

            //    FileInfo file_Info = new FileInfo(file.FileName);
            //    string ext = file_Info.Extension;

            //    string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
            //    GUIDFile = file_Name;
            //    NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
            //    FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
            //    objfilestream.Write(binaryWriteArray, 0,
            //    binaryWriteArray.Length);
            //    objfilestream.Close();
            //    //string filename2 = Convert.ToString(Request.Files["glassrating_attachment"].FileName);
            //}
            //catch { }
        }

        [WebMethod]
        public static string GetAllSocialSiteVisitors()
        {
            Hashtable htParam = new Hashtable();
            DataTable dt1 = new bllMaster().getAllSocialVisitors(htParam);
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
        public static string GetGlassDoorRatings()
        {
            DataTable dt1 = new bllMaster().getAllGlassDoors();
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
        public static string GetGlassDoorCompetitors()
        {
            DataTable dt1 = new bllMaster().getAllGlassDoorsComp();
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
        public static string GetAllEmployees()
        {
            DataTable dt1 = new bllMaster().GetAllUsers_1();
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
        public static string GetAllCompetitors()
        {
            DataTable dt1 = new bllMaster().GetAllCompetitors();
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
        public static string GetAllGlassDoorCompetitors()
        {
            DataTable dt1 = new bllMaster().GetAllGlassDoorCompetitors();
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
        public static int InsertSocialSiteVisitors(int EmployeeID, string SocialSite, string DateVisited, string Month, string Year)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("EmployeeID", EmployeeID);
            htParam.Add("SocialSite", SocialSite);
            htParam.Add("DateVisited", Convert.ToDateTime(DateVisited).ToString("dd-MMM-yyyy"));
            htParam.Add("Month", Month);
            htParam.Add("Year", Year);

            if (NewFileName != "")
            {
                if (!Directory.Exists(MainPath))
                {
                    Directory.CreateDirectory(MainPath);
                }
                string SubPath = MainPath + "\\" + Convert.ToString(EmployeeID);
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                string UniquePath = MainPath + "\\" + Convert.ToString(EmployeeID) + "\\" + DateTime.Now.ToString("hhmmss");
                if (!Directory.Exists(UniquePath))
                {
                    Directory.CreateDirectory(UniquePath);
                }
                File.Copy(NewFileName, UniquePath + "\\" + GUIDFile);
                File.Delete(NewFileName);
                htParam.Add("Attachment", UniquePath + "\\" + GUIDFile);
            }
            else
                htParam.Add("Attachment", "");

            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertSocialSiteVisitor(htParam);
            NewFileName = "";
            return returnvalue;
        }

        [WebMethod]
        public static int InsertGlassDoorRating(string Month, string Year, string Rating)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("Month", Month);
            htParam.Add("Year", Year);
            htParam.Add("CompanyRating", Rating);
            if (NewFileName != "")
            {
                if (!Directory.Exists(Rating_MainPath))
                {
                    Directory.CreateDirectory(MainPath);
                }
                string SubPath = Rating_MainPath + "\\Infinity";
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                string UniquePath = Rating_MainPath + "\\Infinity\\" + Month + "-" + Year;
                if (!Directory.Exists(UniquePath))
                {
                    Directory.CreateDirectory(UniquePath);
                }
                File.Copy(NewFileName, UniquePath + "\\" + GUIDFile);
                File.Delete(NewFileName);
                htParam.Add("Attachment", UniquePath + "\\" + GUIDFile);
            }
            else
                htParam.Add("Attachment", "");
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertGalssdoorReview(htParam);
            NewFileName = "";
            return returnvalue;
        }

        [WebMethod]
        public static int InsertGlassDoorCompetitors(string CompanyName, string Month, string Year, string Rating)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("CompanyName", CompanyName);
            htParam.Add("Month", Month);
            htParam.Add("Year", Year);
            htParam.Add("CompanyRating", Rating);
            if (NewFileName != "")
            {
                if (!Directory.Exists(Rating_MainPath))
                {
                    Directory.CreateDirectory(MainPath);
                }
                string SubPath = Rating_MainPath + "\\Competitor";
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                string UniquePath = Rating_MainPath + "\\Competitor\\" + Month + "-" + Year;
                if (!Directory.Exists(UniquePath))
                {
                    Directory.CreateDirectory(UniquePath);
                }
                File.Copy(NewFileName, UniquePath + "\\" + GUIDFile);
                File.Delete(NewFileName);
                htParam.Add("Attachment", UniquePath + "\\" + GUIDFile);
            }
            else
                htParam.Add("Attachment", "");

            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertGalssdoorReviewComp(htParam);
            NewFileName = "";
            return returnvalue;
        }

        [WebMethod]
        public static int InsertCompetitor(string CompanyName)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            
            htParam.Add("CompanyName", CompanyName);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllMaster().InsertCompetitor(htParam);

            return ReturnValue;
        }
    }
}