using DocumentFormat.OpenXml.Office2016.Excel;
using ICSharpCode.SharpZipLib.Zip;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class DownloadFiles : System.Web.UI.Page
    {

        public DownloadFiles()
        {
            this.Load += Page_Load;
            Console.WriteLine("Test");
        }

        protected void Page_Load(object sender, EventArgs e)
        {



            Console.WriteLine("Test");


            if (Request.QueryString["ChangeID"] != null)
            {
                try
                {
                    DataTable dt = new bllMaster().GetBankAttachmentByID(Convert.ToInt32(Request.QueryString["ChangeID"]));
                    if (dt != null)
                    {
                        if (dt.Rows.Count > 0)
                        {
                            string Attachment = Convert.ToString(dt.Rows[0]["Attachment"]);
                          //  Attachment = "D:\\Nilkanth\\15-Nov-2025\\WebPortal\\WebPortal\\BankAccDetails\\28-May-2026\\UEY_280520260605SS\\5fd12627-503e-4fb7-b59a-1a0950aa73dd_2852026.pdf";

                            if (Attachment != "")
                            {
                                Attachment = Server.MapPath(Attachment);
                                Response.ContentType = "application/octet-stream";
                                Response.AppendHeader("Content-Disposition", "attachment;filename=" + Attachment.Substring(Attachment.LastIndexOf("\\") + 1));
                                Response.TransmitFile(Attachment);
                                Response.End();
                            }
                        }
                    }
                }
                catch { }
            }

            //if (Request.QueryString["ChangeID"] != null)
            //{
            //    try
            //    {
            //        //DataTable dt = new bllMaster().GetBankAttachmentByID(Convert.ToInt32(Request.QueryString["ChangeID"]));

            //        //if (dt != null && dt.Rows.Count > 0)
            //        //{
            //        //    string attachment = Convert.ToString(dt.Rows[0]["Attachment"]);

            //        //    if (!string.IsNullOrWhiteSpace(attachment) && System.IO.File.Exists(attachment))
            //        //    {
            //        //        string fileName = System.IO.Path.GetFileName(attachment);
            //        //        string ext = System.IO.Path.GetExtension(attachment).ToLowerInvariant();

            //        //        string contentType = GetContentType(ext);

            //        //        Response.Clear();
            //        //        Response.ContentType = contentType;
            //        //        Response.AddHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
            //        //        Response.TransmitFile(attachment);
            //        //        Response.Flush();
            //        //        HttpContext.Current.ApplicationInstance.CompleteRequest();
            //        //    }
            //        //}
            //    }
            //    catch
            //    {
            //        Response.StatusCode = 500;
            //    }
            //}

            if (Request.QueryString["HeaderID"] != null)
            {
                try
                {
                    string Month = Convert.ToString(Request.QueryString["Month"]);
                    string Year = Convert.ToString(Request.QueryString["Year"]);
                    DataTable dt = new bllMaster().DownloadInvoice(Convert.ToInt32(Request.QueryString["HeaderID"]), Month, Year);
                    if (dt != null)
                    {
                        if (dt.Rows.Count > 0)
                        {
                            string Attachment = Convert.ToString(dt.Rows[0]["Attachment"]);
                            if (Attachment != "")
                            {
                                //Attachment = Server.MapPath(Attachment);
                                Response.ContentType = "application/octet-stream";
                                Response.AppendHeader("Content-Disposition", "attachment;filename=" + Attachment.Substring(Attachment.LastIndexOf("\\") + 1));
                                Response.TransmitFile(Attachment);
                                Response.End();
                            }
                        }
                    }
                }
                catch { }
            }

            if (Request.QueryString["VisitorID"] != null)
            {
                try
                {
                    DataTable dt = new bllMaster().GetSocialSiteVisitorByID(Convert.ToInt32(Request.QueryString["VisitorID"]));
                    if (dt != null)
                    {
                        if (dt.Rows.Count > 0)
                        {
                            string Attachment = Convert.ToString(dt.Rows[0]["Attachment"]);
                            if (Attachment != "")
                            {
                                //Attachment = Server.MapPath(Attachment);
                                Response.ContentType = "application/octet-stream";
                                // Response.AppendHeader("Content-Disposition", "attachment;filename=" + Attachment.Substring(Attachment.LastIndexOf("\\") + 1));
                                Response.AppendHeader("Content-Disposition", "attachment;filename=" + Path.GetFileName(Attachment));

                                // Response.TransmitFile(Attachment);
                                Response.WriteFile(Attachment);
                                // Response.Flush();
                                Response.End();
                            }
                        }
                    }
                }
                catch (Exception ex)
                { }
            }

            if (Request.QueryString["ExEmpDocPath"] != null)
            {
                try
                {
                    string Attachment = Convert.ToString(Request.QueryString["ExEmpDocPath"]);

                    if (Attachment != "")
                    {
                        //Attachment = Server.MapPath(Attachment);
                        Response.ContentType = "application/octet-stream";
                        // Response.AppendHeader("Content-Disposition", "attachment;filename=" + Attachment.Substring(Attachment.LastIndexOf("\\") + 1));
                        Response.AppendHeader("Content-Disposition", "attachment;filename=" + Path.GetFileName(Attachment));
                        Response.TransmitFile(Attachment);
                        //Response.WriteFile(Attachment);
                        //Response.Flush();
                        Response.End();
                    }
                }
                catch (Exception ex)
                { }
            }

            if (Request.QueryString["Code"] != null)
            {
                string code = Convert.ToString(Request.QueryString["Code"]);
                string ZipFilePath = Server.MapPath(@"~/EmployeeDocuments/" + code);

                ZipOutputStream ZipOs = new ZipOutputStream(File.Create(ZipFilePath + "" + code + ".Zip"));
                string newZipFilePath = ZipFilePath + "" + code + ".zip";
                ZipOs.SetLevel(5);
                System.Data.DataTable dt = new bllMaster().GetEmpAllDocsForZip(code);
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i <= dt.Rows.Count - 1; i++)
                    {
                        try
                        {
                            string documentpath = Convert.ToString(dt.Rows[i]["DocumentPath"]);
                            string documenttype = Convert.ToString(dt.Rows[i]["DocumentType"]);
                            string lblFileName = documentpath.Substring(documentpath.LastIndexOf('\\') + 1);
                            FileStream fs;

                            fs = new FileStream(documentpath, FileMode.Open);
                            Byte[] buffer = new Byte[fs.Length];
                            fs.Read(buffer, 0, buffer.Length);
                            fs.Close();
                            fs = null;

                            ZipEntry zipEntry = new ZipEntry(lblFileName);
                            ZipOs.PutNextEntry(zipEntry);
                            ZipOs.Write(buffer, 0, buffer.Length);
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                }
                ZipOs.Finish();
                ZipOs.Close();
                Response.ContentType = "application/octet-stream";
                string file = code.Replace(" ", "_") + ".zip";
                Response.AddHeader("Content-Disposition", "attachment; filename=" + file);
                Response.WriteFile(newZipFilePath, false);
                Response.End();
                Response.Flush();
            }

            if (Request.QueryString["HrInvoicePath"] != null)
            {
                string filePath = Convert.ToString(Request.QueryString["HrInvoicePath"]); // Already physical path
                                                                                          //if (context.Request.QueryString["EmpComments"] != null)
                                                                                          //    filePath = Convert.ToString(context.Request.QueryString["EmpComments"]); // Already physical path

                if (!string.IsNullOrEmpty(filePath))
                {
                    string path = Server.MapPath("~/") + filePath;

                    if (File.Exists(path))
                    {
                        Response.Clear();
                        Response.ContentType = "application/octet-stream";
                        Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(path));
                        Response.TransmitFile(path);
                        Response.End();
                    }
                }
            }

            if (Request.QueryString["FilePath"] != null)
            {
                string filePath = Request.QueryString["FilePath"];

                string fullPath = Server.MapPath("~/" + filePath);

                if (File.Exists(fullPath))
                {
                    Response.Clear();
                    Response.ContentType = "application/octet-stream";
                    Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(fullPath));
                    Response.WriteFile(fullPath);
                    Response.End();
                }
            }


            if (Request.QueryString["CommentID"] != null)
            {
                int id = Convert.ToInt32(Request.QueryString["CommentID"]);

                DataTable dt = new bllMaster().GetEmployeeCommentByID(id);

                if (dt.Rows.Count > 0)
                {
                    string Attachment = Convert.ToString(dt.Rows[0]["Attachment"]);
                    if (Attachment != "")
                    {
                        Response.ContentType = "application/octet-stream";
                        Response.AppendHeader("Content-Disposition", "attachment;filename=" + Path.GetFileName(Attachment));
                        Response.WriteFile(Attachment);
                        Response.End();
                    }
                }
            }
            else
            {
                Response.Redirect("~/Admin/EmployeeComments.aspx");
            }
        }



        private string GetContentType(string ext)
        {
            switch (ext)
            {
                case ".pdf": return "application/pdf";
                case ".jpg":
                case ".jpeg": return "image/jpeg";
                case ".png": return "image/png";
                case ".gif": return "image/gif";
                case ".txt": return "text/plain";
                case ".html":
                case ".htm": return "text/html";
                case ".doc": return "application/msword";
                case ".docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                case ".xls": return "application/vnd.ms-excel";
                case ".xlsx": return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                default: return "application/octet-stream";
            }
        }

        public void ProcessRequest(HttpContext context)
        {
            string fileName = context.Request.QueryString["fileName"];

            if (string.IsNullOrEmpty(fileName))
                return;

            fileName = Path.GetFileName(fileName);

            string folderPath = @"D:\Nilkanth\15-Nov-2025\WebPortal\WebPortal\UploadScreenShot\17-Dec-2025\01\";
            string fullPath = Path.Combine(folderPath, fileName);

            if (!File.Exists(fullPath))
            {
                context.Response.StatusCode = 404;
                return;
            }

            context.Response.Clear();
            context.Response.ContentType = "application/octet-stream";
            context.Response.AddHeader(
                "Content-Disposition",
                "attachment; filename=" + fileName
            );

            context.Response.TransmitFile(fullPath);
            context.Response.End();
        }

        public bool IsReusable => false;
    }
}

