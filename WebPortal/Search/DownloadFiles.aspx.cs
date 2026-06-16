using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Search
{
    public partial class DownloadFiles : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["AbstractorID"] != null)
            {
                string abstDocID = Request.QueryString["AbstractorID"];

                var idList = abstDocID.Split(',').Select(int.Parse).ToList();
                try
                {
                    DataTable dt = new bllOST().GetAbstractorDocuments(idList[0]);
                    DataRow[] rows1 = dt.Select("DocumentsID  =" + idList[1]);// idList[1]);
                    string Path = Convert.ToString(rows1[0].ItemArray[4]);
                    //dd = "~/EmployeeDocuments/AbstractorDocs/1586/10063-TCM-Employee Agreement_1.docx";
                    if (dt != null)
                    {
                        if (dt.Rows.Count > 0)
                        {
                            string Attachment = Path;// Convert.ToString(dt.Rows[0]["Path"]);
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

            if (Request.QueryString["OrderIds"] != null)
            {
                string OrderPrcID = Request.QueryString["OrderIds"];

                var idList = OrderPrcID.Split(',').ToList();
                try
                {
                    DataTable dt = new bllOST().GetOrderDetailsProcesswise(Convert.ToInt32(idList[0]));
                    DataRow[] rows1 = dt.Select("ProcessId=" + Convert.ToInt32(idList[2]));// idList[1]);
                    string Attachment = "";

                    if (Convert.ToString(idList[1]) == "C")
                        Attachment = Convert.ToString(rows1[0].ItemArray[5]);
                    else if (Convert.ToString(idList[1]) == "O")
                        Attachment = Convert.ToString(rows1[0].ItemArray[6]);

                    // Attachment = "~/EmployeeDocuments/AbstractorDocs/1586/10063-TCM-Employee Agreement_1.docx";

                    if (dt.Rows.Count > 0 && dt != null)
                    {
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
                catch { }
            }

        }
    }
}