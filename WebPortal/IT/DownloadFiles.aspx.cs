using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.IT
{
    public partial class DownloadFiles : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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

            if (Request.QueryString["fileName"] != null)
            {
                //    string fileName = Request.QueryString["fileName"];

                //    if (string.IsNullOrEmpty(fileName))
                //        return;

                //    fileName = Path.GetFileName(fileName);

                //    string folderPath = @"D:\Nilkanth\15-Nov-2025\WebPortal\WebPortal\UploadScreenShot\17-Dec-2025\01\";
                //    string fullPath = Path.Combine(folderPath, fileName);

                //    if (!File.Exists(fullPath))
                //    {
                //        Response.StatusCode = 404;
                //        return;
                //    }

                //    Response.Clear();
                //    Response.ContentType = "application/octet-stream";
                //    Response.AddHeader(
                //        "Content-Disposition",
                //        "attachment; filename=" + fileName
                //    );

                //    Response.TransmitFile(fullPath);
                //    Response.End();
            }

            if (Request.QueryString["TicketID"] != null)
            {
                try
                {
                    int ticketId = Convert.ToInt32(Request.QueryString["TicketID"]);
                    DataTable dt = new bllAsset().ViewRequestTicket(ticketId);
                    if (dt != null)
                    {
                        if (dt.Rows.Count > 0)
                        {
                            string Attachment = Convert.ToString(dt.Rows[0]["Attachment"]);
                            if (Attachment != "")
                            {
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

        }
    }
}