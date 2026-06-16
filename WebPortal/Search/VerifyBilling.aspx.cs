using DocumentFormat.OpenXml.Office2010.Excel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Search
{
    public partial class VerifyBilling : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllProjectNo()
        {
            DataTable dt1 = new bllOST().GetAllProject(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetProjectBillingCycle(string ProjectId)
        {
            DataTable dt1 = new bllOST().getBillingPeriodByProject(ProjectId);
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
        public static string getBillingPeriod()
        {
            DataTable dt1 = new bllOST().getBillingPeriod();
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
        public static string GetDataForSummary(string ProjectNo, string FromDate, string ToDate)
        {
            DataTable dt1 = new bllOST().GetSummaryProjectWise_Date(ProjectNo, FromDate, ToDate);
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
        public static string GetDataForBilling(string ProjectNo, string FromDate, string ToDate)
        {
            DataTable dt1 = new bllOST().GetProjectWiseOrderDetailsForBilling_ForVerification(ProjectNo, FromDate, ToDate);
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
        public static int VerifyOrders(string OrderIDs, string Project, string Remark)
        {
            int returnValue = 0;

            string[] arr_OrderiDS = OrderIDs.Split(',');

            foreach (string orderId in arr_OrderiDS)
            {
                string id = orderId.Trim(); // remove spaces if any

                returnValue = new bllOST().VerifyOstOrdersForBilling(Convert.ToInt32(id), Project, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), Remark);
            }

            return returnValue;
        }


        [WebMethod]
        public static int SendToAccounts(int ProjectID, string Project, string BillingCycle, string BillingPeriod)
        {
            int returnValue = 0;

            string[] dates = BillingPeriod.Split('~');
            string FromDate = dates[0].Trim();
            string ToDate = dates[1].Trim();

            string ProductionBillingDate = Convert.ToDateTime(DateTime.Now.Date).ToString("dd-MMM-yyyy");

            returnValue = new bllOST().UpdateBillingInBillingDB(ProjectID, BillingPeriod, BillingCycle, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), ProductionBillingDate, ProductionBillingDate, true, "", "Pending");

            DataTable dt = new bllOST().GetProjectWiseOrderDetailsForBilling_ForVerification_Bill(Project, FromDate, ToDate);

            DataTable dt2 = null;// (DataTable)Session["dtReport"];

            if (dt.Rows.Count > 0)
            {
                SendClientBillingOrdersTyping(dt, dt2, Project, "Search-Typing", "0", "0", "0", "0", "0", "0", "0", "0", "0", BillingPeriod, 0, "");
            }

            returnValue = new bllOST().HoldOrdersPending(Project, FromDate, ToDate);
            return returnValue;
        }

        [WebMethod]
        public static int AddRemark_VerifyBilling(int OrderID, string OrderCost, string Remark)
        {
            int returnValue = new bllOST().UpdateBillingRemark(OrderID, Remark, OrderCost);

            return returnValue;
        }


        public static void SendClientBillingOrdersTyping(DataTable dt, DataTable dt2, string ProjectName, string ProjectType, string TotalCount, string Dispatched_Count, string NotToBilledCount, string Cancelled_Count, string Pending_Count, string Weekday_Count, string WeekendCount, string Infinity_ChecklistCount, string ClientCount, string BillingDatePeriod, int domainID, string EmailNote)
        {
            StringBuilder htmlBody = new StringBuilder();
            string Subject;
            DateTime dtime = DateTime.Today;
            string day = dtime.DayOfWeek.ToString();
            string Path = "";
            string ToAddress = "a.phillip@infinityinternationals.us,e.mike@infinityinternationals.us,C.Eva@infinityinternationals.us";
            string ToCC = "n.prasad@infinityinternationals.us";
            string ToBcc = "p.kedar@infinityinternationals.us,n.nilkanth@infinityinternationals.us";

            #region dtmain Datatable

            try
            {

                if (dt.Rows.Count > 0)
                {
                    DataColumnCollection dcCollection = dt.Columns;
                    //Export Data into EXCEL Sheet
                    Microsoft.Office.Interop.Excel.Application ExcelAppTrack = new Microsoft.Office.Interop.Excel.Application();
                    ExcelAppTrack.Application.Workbooks.Add(Type.Missing);
                    //ExcelApp.Cells.CopyFromRecordset(objRS);
                    Microsoft.Office.Interop.Excel.Range xlRange;
                    Microsoft.Office.Interop.Excel.Sheets xlSheets = null;
                    Microsoft.Office.Interop.Excel.Worksheet xlSheet = null;
                    Microsoft.Office.Interop.Excel.Workbook xlWorkbook = ExcelAppTrack.ActiveWorkbook;
                    xlSheets = (Microsoft.Office.Interop.Excel.Sheets)xlWorkbook.Sheets;
                    xlSheet = (Microsoft.Office.Interop.Excel.Worksheet)xlSheets[1];
                    xlRange = xlSheet.UsedRange;

                    for (int j = 1; j < dt.Columns.Count + 1; j++)
                    {
                        ExcelAppTrack.Cells[1, j] = dcCollection[j - 1].ToString();

                        ExcelAppTrack.ActiveWorkbook.InactiveListBorderVisible = true;

                        //((Microsoft.Office.Interop.Excel.Range)ExcelAppTrack.Cells[1, j]).Interior.Color = ColorTranslator.ToOle(Color.SkyBlue);

                        //((Microsoft.Office.Interop.Excel.Range)ExcelAppTrack.Cells[1, j]).Font.Bold = FontStyle.Bold;
                        (((Microsoft.Office.Interop.Excel.Range)ExcelAppTrack.Cells[1, j])).VerticalAlignment = VerticalAlign.Middle;
                        (((Microsoft.Office.Interop.Excel.Range)ExcelAppTrack.Cells[1, j])).HorizontalAlignment = HorizontalAlign.Center;
                        ((Microsoft.Office.Interop.Excel.Range)ExcelAppTrack.Cells[1, j]).Borders.Color = BorderStyle.Solid;
                    }
                    for (int i = 1; i < dt.Rows.Count + 1; i++)
                    {
                        int Count = 0;
                        Count = i + 1;
                        for (int j = 1; j < dt.Columns.Count + 1; j++)
                        {
                            ExcelAppTrack.Cells[Count, j] = dt.Rows[i - 1][j - 1].ToString();
                            ((Microsoft.Office.Interop.Excel.Range)ExcelAppTrack.Cells[Count, j]).Borders.Color = BorderStyle.Solid;
                            (((Microsoft.Office.Interop.Excel.Range)ExcelAppTrack.Cells[1, j])).EntireColumn.AutoFit();
                        }
                    }

                    try
                    {
                        // string ServerPath = Server.MapPath(@"~/WBT/Billing/" + ProjectName + "/" + BillingDatePeriod + "/" + DateTime.Now.ToString("MMddyyyy") + "/");
                        ////ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + ServerPath + "')", true);
                        //if (!Directory.Exists(Server.MapPath(@"~/WBT/Billing/" + ProjectName + "/" + BillingDatePeriod + "/" + DateTime.Now.ToString("MMddyyyy") + "/")))
                        //{
                        //    Directory.CreateDirectory(Server.MapPath(@"~/WBT/Billing/" + ProjectName + "/" + BillingDatePeriod + "/" + DateTime.Now.ToString("MMddyyyy") + "/"));
                        //}
                    }
                    catch (Exception ex)
                    {
                        //dvError.Style.Add("display", "");
                        //dvError.Visible = true;
                        //lblError.Text = ex.ToString();
                    }
                    Subject = ProjectName + ' ' + ProjectType + "-Billing details-" + BillingDatePeriod;

                    //Path = targetPath + "\\" + Subject + ".xls";

                    //  Path = Server.MapPath(@"~/WBT/Billing/" + ProjectName + "/" + BillingDatePeriod + "/" + DateTime.Now.ToString("MMddyyyy") + "/") + Subject + ".xls";
                    ExcelAppTrack.ActiveWorkbook.SaveCopyAs(Path);
                    ExcelAppTrack.ActiveWorkbook.Saved = true;

                    ExcelAppTrack.Quit();

                    if (dt.Rows.Count > 0)
                    {
                        Subject = ProjectName + ' ' + ProjectType + "-Billing details-" + BillingDatePeriod;

                        htmlBody.Append("<br /><font color=brown face=Verdana size=2 ><b>Please collect billing details of " + ProjectName + "- project through Online Search Tracking (OST) Software.." + BillingDatePeriod + ".</b></font><br />");

                        if (dt2.Rows.Count > 0)
                        {
                            htmlBody.Append("<br /><table border=\"1\" bordercolor='Black' style='border:solid 1px black;border-collapse:collapse;padding:3px; font-size:14px;'><tr style='background-color:Skyblue; color:Black;'><td colspan=6><center><b>" + ProjectName + "-Client Billing - " + BillingDatePeriod + " ( " + ProjectType + " ) </b></center></td></tr>");
                            htmlBody.Append("<tr style='background-color:Skyblue; color:Black;'><td><center><b>Billing Period</b></center></td><td><center><b>Received Orders</b></center></td><td><center><b>Dispatched</b></center></td><td><center><b>Cancelled</b></center></td><td><center><b>OnHold</b></center></td><td><center><b>Pending Search</b></center></td></tr>");
                            for (int i = 0; i < dt2.Rows.Count; i++)
                            {
                                htmlBody.Append("<tr style='background-color:White; color:black;'><td><center><b>" + Convert.ToString(dt2.Rows[i]["BillingPeriod"]) + "</b></center></td><td><center><b>" + Convert.ToString(dt2.Rows[i]["Received"]) + "</b></center></td><td><center><b>" + Convert.ToString(dt2.Rows[i]["Dispatch"]) + "</b></center></td><td><center><b>" + Convert.ToString(dt2.Rows[i]["Cancel"]) + "</b></center></td><td><center><b>" + Convert.ToString(dt2.Rows[i]["Hold"]) + "</b></center></td><td><center><b>" + Convert.ToString(dt2.Rows[i]["Previous"]) + "</b></center></td></tr>");
                            }
                        }
                        htmlBody.Append("</table>");
                        htmlBody.Append("<br /><br /><table width=\"650px\" style='font-size:13px;'><tr><td align=\"left\">Thanks,<br />Infinity </td></tr> <tr> <br /><td align=\"center\"><b>!!! This is software generated e-mail...Please do not reply. !!!</td></tr></table>");
                        htmlBody.Append("<table width=\"600px\" style='font-size:10px;'><tr><td align=\"left\"></td></tr> <tr> <br /><td align=\"center\"><b>" + "***********************************************************************************************************************************************************************************************" + "</td></tr></table>");
                        htmlBody.Append("<table width=\"600px\" style='font-size:10px;'><tr><td align=\"left\">" + "<b>CONFIDENTIALITY INFORMATION AND DISCLAIMER</b>" + "</td></tr> <tr> <br /><td align=\"center\"><b></td></tr></table>");
                        htmlBody.Append("<table width=\"600px\" style='font-size:12px;'><tr><td align=\"left\">" + "This message contains information which may be confidential and privileged. Unless you are the addressee (or authorized to receive for the addressee), you may not use copy or disclose to anyone the message or any information contained in the message. If you have received the message in error, please advise the sender by reply e-mail and delete the message. Thank you." + "</td></tr><tr><td align=\"center\"><b></td></tr></table>");
                        htmlBody.Append("<table width=\"600px\" style='font-size:10px;'><tr><td align=\"left\">" + "***********************************************************************************************************************************************************************************************" + " </td></tr> <tr> <br /><td align=\"center\"><b></td></tr></table>");

                        string strPassword = new bllMaster().GetPassword("ackdata");

                        //   sendMailForOnlineTracking(ToAddress, ToCC, ToBcc, Subject, Path, htmlBody, strPassword);
                    }

                }
            }
            catch (Exception)
            {

                throw;
            }

            #endregion
        }

        public bool sendMailForOnlineTracking(string ToAddress, string ToCC, string ToBCC, string Subject, string Path, StringBuilder htmlBody, string PWD)
        {
            try
            {
                String Body = htmlBody.ToString();
                StringBuilder template = new StringBuilder();
                template.Append("<html><head></head><body>");
                //template.Append("<img src=\"http://www.infinity-data.com/images/TemplateHeader.png\" /><br />");
                template.Append(Body);
                //template.Append("<br /><img src=\"http://www.infinity-data.com/images/TemplateFooter.png\" />");
                template.Append("</body></html>");
                MailMessage mail = new MailMessage();
                mail.To.Add(ToAddress);
                if (ToCC != "")
                    mail.CC.Add(ToCC);
                if (ToBCC != "")
                    mail.Bcc.Add(ToBCC);
                mail.From = new MailAddress("ack@infinity-data.com", "Online Search Billing", System.Text.Encoding.UTF8);
                mail.Subject = Subject;
                mail.SubjectEncoding = System.Text.Encoding.UTF8;
                mail.Body = template.ToString();
                mail.BodyEncoding = System.Text.Encoding.UTF8;
                mail.IsBodyHtml = true;

                if (Path != "")
                {
                    Attachment at = new Attachment(Path);
                    at.Name = Subject + " All Orders" + ".xls";
                    mail.Attachments.Add(at);
                }

                mail.Priority = System.Net.Mail.MailPriority.High;
                SmtpClient client = new SmtpClient();
                client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", PWD);

                client.Host = "smtp.office365.com";  //Gmail works on Server Secured Layer
                client.Port = 587;
                client.EnableSsl = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;


                //client.EnableSsl = true;
                client.Send(mail);
                htmlBody.Remove(0, htmlBody.Length);
                return true;
            }
            catch (Exception ex)
            {
                //lblError.Text = ex.ToString();
                return false;
            }
        }
    }
}