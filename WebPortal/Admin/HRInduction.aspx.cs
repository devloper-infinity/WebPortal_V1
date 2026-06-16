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
    public partial class HRInduction : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string MainPath = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            MainPath = Server.MapPath(@"~\QuestionImage");
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
        public static string GetAllQuestions()
        {
            DataTable dt1 = new bllMaster().getAllHRQuestion();
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
        public static int InsertQuestionSet(string Question, string Weightage, string Option1, string Option2, string Option3, string Option4, string CorrectAnswer)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("Question", Question);
            htParam.Add("Weightage", Weightage);
            htParam.Add("Answer1", Option1);
            htParam.Add("Answer2", Option2);
            htParam.Add("Answer3", Option3);
            htParam.Add("Answer4", Option4);
            htParam.Add("QuestionType", "Objective");
            htParam.Add("CorrectAnswer", CorrectAnswer);
            if (NewFileName != "")
            {
                if (!Directory.Exists(MainPath))
                {
                    Directory.CreateDirectory(MainPath);
                }
                string SubPath = MainPath + "\\" + DateTime.Now.ToString("dd-MMM-yyyy");
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }

                File.Copy(NewFileName, SubPath + "\\" + GUIDFile);
                File.Delete(NewFileName);
                htParam.Add("QueAttachment", SubPath + "\\" + GUIDFile);
            }
            else
                htParam.Add("QueAttachment", "");
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
           
            returnvalue = new bllMaster().InsertHRQuestion(htParam);

            NewFileName = "";
            return returnvalue;
        }

        [WebMethod]
        public static string GetQuestionPaperforcheck(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetHRCheckQuestionPaper(Month, Year);
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
        public static string GetHRInductionReportSummary(string Month, string Year)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataSet ds = new bllMaster().GetHRCheckQuestionPaperReport(Month, Year);
            if (ds != null)
            {
                DataTable dt1 = ds.Tables[0];
                
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
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetHRInductionReportDetails(string Month, string Year)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataSet ds = new bllMaster().GetHRCheckQuestionPaperReport(Month, Year);
            if (ds != null)
            {
                DataTable dt1 = ds.Tables[1];

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
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }
    }
}