using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class FestivalWishesMaster : System.Web.UI.Page
    {
        private static string NewFileName = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            string folderPath = Server.MapPath(@"~\FestivalWishesImages");

            if (Request.Files.Count == 0)
            {
                return;
            }

            try
            {
                Directory.CreateDirectory(folderPath);

                for (int i = 0; i < HttpContext.Current.Request.Files.Count; i++)
                {
                    HttpPostedFile file = HttpContext.Current.Request.Files[i];

                    if (file == null || file.ContentLength == 0)
                    {
                        continue;
                    }

                    string fileName = Path.GetFileName(file.FileName);
                    if (string.IsNullOrWhiteSpace(fileName))
                    {
                        continue;
                    }

                    NewFileName = Path.Combine(folderPath, fileName);
                    file.SaveAs(NewFileName);
                }
            }
            catch
            {
            }
        }

        [WebMethod]
        public static string GetFestivalMaster()
        {
            DataTable dt1 = new bllMaster().GetFestivalMaster();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            foreach (DataRow dr in dt1.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
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

                int ReturnValue = new bllMaster().InsertFestiveData(htParam);

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

