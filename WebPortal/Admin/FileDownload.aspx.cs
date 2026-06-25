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
    public partial class FileDownload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.QueryString["ChangeID"] != null)
            {
                DataTable dt = new bllMaster().GetBankAttachmentByID(Convert.ToInt32(Request.QueryString["ChangeID"]));
                string attachment = Convert.ToString(dt.Rows[0]["Attachment"]);

                if (!string.IsNullOrWhiteSpace(attachment))
                {
                    attachment = attachment.Replace("\\", "/");

                    if (!attachment.StartsWith("~/"))
                        attachment = "~/" + attachment.TrimStart('/');

                    string filePath = Server.MapPath(attachment);

                    if (File.Exists(filePath))
                    {
                        string fileName = Path.GetFileName(filePath);

                        Response.Clear();
                        Response.ContentType = "application/octet-stream";
                        Response.AppendHeader(
                            "Content-Disposition",
                            "attachment; filename=\"" + fileName + "\""
                        );

                        Response.TransmitFile(filePath);
                        Response.Flush();
                        HttpContext.Current.ApplicationInstance.CompleteRequest();
                    }
                    else
                    {
                        Response.Write("File not found: " + filePath);
                    }
                }

                //try
                //{
                //    DataTable dt = new bllMaster().GetBankAttachmentByID(Convert.ToInt32(Request.QueryString["ChangeID"]));
                //    if (dt != null)
                //    {
                //        if (dt.Rows.Count > 0)
                //        {
                //            string Attachment = Convert.ToString(dt.Rows[0]["Attachment"]);

                //            if (Attachment != "")
                //            {
                //                Attachment = Server.MapPath(Attachment);
                //                Response.ContentType = "application/octet-stream";
                //                Response.AppendHeader("Content-Disposition", "attachment;filename=" + Attachment.Substring(Attachment.LastIndexOf("\\") + 1));
                //                Response.TransmitFile(Attachment);
                //                Response.End();
                //            }
                //        }
                //    }
                //}
                //catch { }
            }
        }
    }
}