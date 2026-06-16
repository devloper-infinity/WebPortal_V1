using System;
using System.Data;
using System.Web;
using System.Data.OleDb;
using System.IO;
using System.Web.Script.Serialization;

namespace WebPortal.Handler
{
    /// <summary>
    /// Summary description for Upload
    /// </summary>
    public class Upload : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                HttpPostedFile file = context.Request.Files[0];

                string folderPath = context.Server.MapPath("~/Uploads/");
                if (!Directory.Exists(folderPath))
                    Directory.CreateDirectory(folderPath);

                string filePath = folderPath + Path.GetFileName(file.FileName);
                file.SaveAs(filePath);

                DataTable dt = ReadExcel(filePath);

                // ✅ STORE IN SESSION
                context.Session["OtherTaskExcelData"] = dt;

                context.Response.ContentType = "application/json";
                context.Response.Write("{\"status\":\"success\"}");
            }
            catch (Exception ex)
            {
                context.Response.Write("{\"status\":\"error\",\"message\":\"" + ex.Message + "\"}");
            }
        }


        private DataTable ReadExcel(string filePath)
        {
            DataTable dt = new DataTable();

            string conStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath +
                            ";Extended Properties='Excel 12.0 Xml;HDR=YES;'";

            using (OleDbConnection con = new OleDbConnection(conStr))
            {
                con.Open();

                DataTable schema = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                string sheetName = schema.Rows[0]["TABLE_NAME"].ToString();

                using (OleDbDataAdapter da = new OleDbDataAdapter("SELECT * FROM [" + sheetName + "]", con))
                {
                    da.Fill(dt);
                }
            }

            return dt;
        }

        public bool IsReusable { get { return false; } }
    }
}