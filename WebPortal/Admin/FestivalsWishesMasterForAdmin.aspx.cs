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
    public partial class FestivalsWishesMasterForAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string InsertAdminFestiveData(string Title, string Date, string Location, List<string> ImagesBase64, List<string> FileNames, string VideoBase64, string VideoName)
        {
            string msg = string.Empty;

            try
            {
                List<string> fullPaths = new List<string>();
                string folderPath = HttpContext.Current.Server.MapPath("~/FestivalWishesImagesandVideos_Admin/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }
                if (ImagesBase64 != null && ImagesBase64.Count > 0)
                {
                    for (int i = 0; i < ImagesBase64.Count; i++)
                    {
                        string imageBase64 = ImagesBase64[i];
                        string fileName = FileNames[i];

                        string base64Data = imageBase64.Substring(imageBase64.IndexOf(",") + 1);
                        byte[] fileBytes = Convert.FromBase64String(base64Data);

                        string fullPath = Path.Combine(folderPath, fileName);
                        File.WriteAllBytes(fullPath, fileBytes);
                        fullPaths.Add(fullPath);
                    }
                }

                string videoFullPath = string.Empty;
                if (!string.IsNullOrEmpty(VideoBase64))
                {
                    string videoBase64Data = VideoBase64.Substring(VideoBase64.IndexOf(",") + 1);
                    byte[] videoBytes = Convert.FromBase64String(videoBase64Data);

                    string videoFolderPath = HttpContext.Current.Server.MapPath("~/FestivalWishesImagesandVideos_Admin/");
                    if (!Directory.Exists(videoFolderPath))
                    {
                        Directory.CreateDirectory(videoFolderPath);
                    }

                    videoFullPath = Path.Combine(videoFolderPath, Path.GetFileName(VideoName));
                    File.WriteAllBytes(videoFullPath, videoBytes);
                }

                Hashtable htParam = new Hashtable();
                htParam.Add("Title", Title);
                htParam.Add("Date", Date);
                htParam.Add("ImagePath", string.Join(",", fullPaths));
                htParam.Add("VideoPath", videoFullPath);
                htParam.Add("Branch", Location);

                int addedById = 0;
                if (HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    int.TryParse(HttpContext.Current.User.Identity.Name, out addedById);
                }
                htParam.Add("AddedBy", addedById);

                int ReturnValue = new bllMaster().InsertAdminFestiveData(htParam);

                if (ReturnValue > 0)
                {
                    msg = "Data saved successfully!";
                }
                else
                {
                    msg = "Festival Name already exists! Please choose a different Festival Name.";
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
            return msg;
        }

        [WebMethod]
        public static string GetAdminFestivalMaster()
        {
            DataTable dt1 = new bllMaster().GetAdminFestivalMaster();
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
        public static string DeleteAdminFestivalData(int FestivalID)
        {
            string msg = string.Empty;

            try
            {
                int ReturnValue = new bllMaster().DeleteAdminFestivalData(FestivalID);

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

        public class FestivalModel
        {
            public string Title { get; set; }
            public List<string> Titles { get; set; } = new List<string>();
            public List<string> ImagePaths { get; set; } = new List<string>();
            public List<string> VideoPaths { get; set; } = new List<string>();
        }
        [WebMethod]
        public static FestivalModel GetPopupWishForCurrentUser(string currentDate)
        {
            FestivalModel model = new FestivalModel();
            string userLocation = string.Empty;
            try
            {
                int userId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
                DataTable dt1 = new bllLogin().GetUserInformation(userId);

                if (dt1 != null && dt1.Rows.Count > 0)
                {
                    userLocation = dt1.Rows[0]["WorkingBranchName"].ToString();
                }

                DataTable dtFestival = new bllMaster().GetAdminFestivalDataForPopUp(currentDate, userLocation);

                if (dtFestival != null && dtFestival.Rows.Count > 0)
                {
                    model.Title = dtFestival.Rows[0]["Title"].ToString();

                    foreach (DataRow row in dtFestival.Rows)
                    {
                        string rowTitle = row["Title"]?.ToString() ?? "Festival Wish";

                        string rawImgPath = row["ImagePath"]?.ToString();
                        if (!string.IsNullOrEmpty(rawImgPath))
                        {

                            string[] imgArray = rawImgPath.Split(',');
                            foreach (var img in imgArray)
                            {
                                string cleaned = img.Trim();
                                if (!string.IsNullOrEmpty(cleaned))
                                {
                                    string fileName = System.IO.Path.GetFileName(cleaned);
                                    string finalPath = "~/FestivalWishesImagesandVideos_Admin/" + fileName;
                                    string absolutePath = VirtualPathUtility.ToAbsolute(finalPath);
                                    model.ImagePaths.Add(absolutePath);
                                    model.Titles.Add(rowTitle);
                                }
                            }
                        }

                        string rawVidPath = row["VideoPath"]?.ToString();
                        if (!string.IsNullOrEmpty(rawVidPath))
                        {

                            string[] vidArray = rawVidPath.Split(',');
                            foreach (var vid in vidArray)
                            {
                                string cleaned = vid.Trim();
                                if (!string.IsNullOrEmpty(cleaned))
                                {
                                    string fileName = System.IO.Path.GetFileName(cleaned);
                                    string finalPath = "~/FestivalWishesImagesandVideos_Admin/" + fileName;
                                    string absolutePath = VirtualPathUtility.ToAbsolute(finalPath);

                                    if (!model.VideoPaths.Contains(absolutePath))
                                    {
                                        model.VideoPaths.Add(absolutePath);

                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }

            return model;
        }

        [WebMethod]
        public static string GetAdminFestivalDataForPopUp(string festivalDate, string location)
        {
            DataTable dt1 = new bllMaster().GetAdminFestivalDataForPopUp(festivalDate, location);
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
    }
}