using System;
using System.Collections.Generic;
using System;
using System.Web;
using System.Data;
using System.IO;
using System.Linq;
using WebPortal.App_Code.BLL;
using System.Linq.Expressions;

namespace WebPortal.Handler
{
    /// <summary>
    /// Summary description for Download
    /// </summary>
    public class Download : IHttpHandler
    {
        string filePath = string.Empty;

        public void ProcessRequest(HttpContext context)
        {
            if (context.Request.QueryString["CommentID"] != null)
            {
                int id = Convert.ToInt32(context.Request.QueryString["CommentID"]);

                DataTable dt = new bllMaster().GetEmployeeCommentByID(id);

                if (dt.Rows.Count > 0)
                {
                    string attachment = Convert.ToString(dt.Rows[0]["Attachment"]);

                    string filePath = attachment; 

                    if (File.Exists(filePath))
                    {
                        string fileName = Path.GetFileName(filePath);

                        context.Response.Clear();
                        context.Response.ContentType = MimeMapping.GetMimeMapping(fileName);
                        context.Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
                        context.Response.TransmitFile(filePath);
                        context.Response.Flush();
                        context.ApplicationInstance.CompleteRequest();
                    }
                }
            }

            try
            {

                if (context.Request.QueryString["HrInvoicePath"] != null)
                {
                    filePath = Convert.ToString(context.Request.QueryString["HrInvoicePath"]);

                    //filePath = "InvoiceDocuments\\12345\\ThanksGivingDay.jpg";

                    if (!string.IsNullOrEmpty(filePath))
                    {
                        string path = context.Server.MapPath("~/") + filePath;

                        if (File.Exists(path))
                        {
                            context.Response.Clear();
                            context.Response.ContentType = "application/octet-stream";
                            context.Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(path));
                            context.Response.TransmitFile(path);
                            context.Response.End();
                        }
                    }
                }
            }
            catch (Exception ex)
            { }
        }


        public bool IsReusable
        {
            get { return false; }
        }
    }
}