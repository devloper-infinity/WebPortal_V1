using ClosedXML.Excel;
using DocumentFormat.OpenXml.Office2010.Excel;
using ICSharpCode.SharpZipLib.Zip;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
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
        static DataTable dtSummary;
        static DataTable dtRecords;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.Equals(Request.QueryString["uploadVerifyBillingAttachment"], "1", StringComparison.OrdinalIgnoreCase))
            {
                UploadVerifyBillingAttachment();
                return;
            }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (string.Equals(Request.QueryString["uploadVerifyBillingAttachment"], "1", StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            base.Render(writer);
        }

        private void UploadVerifyBillingAttachment()
        {
            Response.Clear();
            Response.ContentType = "application/json";
            JavaScriptSerializer serializer = new JavaScriptSerializer();

            try
            {
                int project;
                int orderId;
                string billingPeriod = (Request.Form["BillingPeriod"] ?? string.Empty).Trim();
                HttpPostedFile uploadedFile = Request.Files["vrbil_attachment"];

                if (!int.TryParse(Request.Form["Project"], out project) || project <= 0)
                {
                    WriteAttachmentUploadResult(serializer, false, "Please select a valid project.", string.Empty, string.Empty);
                    return;
                }

                if (string.IsNullOrWhiteSpace(billingPeriod))
                {
                    WriteAttachmentUploadResult(serializer, false, "Please select a valid billing period.", string.Empty, string.Empty);
                    return;
                }

                if (!int.TryParse(Request.Form["OrderID"], out orderId) || orderId <= 0)
                {
                    WriteAttachmentUploadResult(serializer, false, "Please select a valid order.", string.Empty, string.Empty);
                    return;
                }

                if (uploadedFile == null || uploadedFile.ContentLength <= 0)
                {
                    WriteAttachmentUploadResult(serializer, false, "Please select a file to upload.", string.Empty, string.Empty);
                    return;
                }

                string uploadedDocumentName = SafePathSegment(Path.GetFileName(uploadedFile.FileName));
                if (string.IsNullOrWhiteSpace(uploadedDocumentName) ||
                    !string.Equals(Path.GetExtension(uploadedDocumentName), ".msg", StringComparison.OrdinalIgnoreCase))
                {
                    WriteAttachmentUploadResult(serializer, false, "Only .msg files are allowed.", string.Empty, string.Empty);
                    return;
                }

                string rootFolder = Path.GetFullPath(Server.MapPath("~/OSTAttachment"));
                if (!Directory.Exists(rootFolder))
                {
                    WriteAttachmentUploadResult(serializer, false, "The OSTAttachment root folder is not available.", string.Empty, string.Empty);
                    return;
                }

                string dateFolderName = DateTime.Now.ToString("dd-MMM-yyyy");
                string projectFolderName = SafePathSegment(project.ToString());
                string billingPeriodFolderName = SafePathSegment(billingPeriod);
                string orderFolderName = SafePathSegment(orderId.ToString());

                string dateFolder = EnsureFolder(rootFolder, dateFolderName);
                string projectFolder = EnsureFolder(dateFolder, projectFolderName);
                string billingPeriodFolder = EnsureFolder(projectFolder, billingPeriodFolderName);
                string orderFolder = EnsureFolder(billingPeriodFolder, orderFolderName);
                string physicalFilePath = Path.GetFullPath(Path.Combine(orderFolder, uploadedDocumentName));

                if (!physicalFilePath.StartsWith(rootFolder + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase))
                {
                    WriteAttachmentUploadResult(serializer, false, "Invalid attachment path.", string.Empty, string.Empty);
                    return;
                }

                uploadedFile.SaveAs(physicalFilePath);

                string attachmentPath = "~/OSTAttachment/" + dateFolderName + "/" + projectFolderName + "/" +
                    billingPeriodFolderName + "/" + orderFolderName + "/" + uploadedDocumentName;

                WriteAttachmentUploadResult(serializer, true, string.Empty, attachmentPath, uploadedDocumentName);
            }
            catch (Exception ex)
            {
                WriteAttachmentUploadResult(serializer, false, "Unable to upload attachment. " + ex.Message, string.Empty, string.Empty);
            }
        }

        private static string EnsureFolder(string parentFolder, string folderName)
        {
            string folder = Path.Combine(parentFolder, folderName);
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            return folder;
        }

        private static string SafePathSegment(string value)
        {
            string segment = (value ?? string.Empty).Trim();
            foreach (char invalidCharacter in Path.GetInvalidFileNameChars())
            {
                segment = segment.Replace(invalidCharacter, '_');
            }

            return segment.Trim().Trim('.');
        }

        private void WriteAttachmentUploadResult(JavaScriptSerializer serializer, bool success, string message, string attachmentPath, string fileName)
        {
            Response.Write(serializer.Serialize(new
            {
                Success = success,
                Message = message,
                AttachmentPath = attachmentPath,
                FileName = fileName
            }));
            Context.ApplicationInstance.CompleteRequest();
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
            dtSummary = dt1;

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
            dtRecords = dt1;
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
        public static int AddRemark_VerifyBilling(int Project, string BillingPeriod, int OrderID, string OrderCost, string Remark, bool IsMailInput, decimal CostDiff, string EmailInput, string AttachmentPath)
        {
            int returnValue =  new bllOST().UpdateBillingRemark(OrderID, Remark, OrderCost);

            if (IsMailInput == true)
            {
                Hashtable htDetails = new Hashtable();
                htDetails["Project"] = Project;
                htDetails["BillingPeriod"] = BillingPeriod;
                htDetails["OrderID"] = OrderID;
                htDetails["CostDiff"] = CostDiff;
                htDetails["EmailNote"] = EmailInput;
                htDetails["AttachmentPath"] = AttachmentPath ?? string.Empty;

                int ReturnValue = new bllOST().InsertCostEmailDetails(htDetails);
            }

            return returnValue;
        }


        [WebMethod]
        public static int SendToAccounts(int ProjectID, string ProjectNo, string BillingPeriod, string Remark)
        {
            int returnValue = 0;

            DataTable dt = new bllOST().GetOrdersForSentToAccounts(ProjectNo, BillingPeriod, Remark);
            DataTable costEmailDetails = new bllOST().GetCostEmailDetails(ProjectID, BillingPeriod);
            DataTable dt_Email = BuildCostApprovalData(dtRecords, costEmailDetails);

            // returnValue = SendClientBillingOrdersTyping(dtRecords, dtSummary, dtRecords, dt_Email, costEmailDetails, "735", "Search Typing", "01-Aug-2026 ~ 15-Aug-2026");

            returnValue = SendClientBillingOrdersTyping(dt, dtSummary, dtRecords, dt_Email, costEmailDetails, ProjectNo, "Search Typing", BillingPeriod);

            return returnValue;
        }

        #region Email

        public static int SendClientBillingOrdersTyping(DataTable dt, DataTable dtSummaryForEmail, DataTable dtRecordsForExcel, DataTable dtEmailForExcel, DataTable costEmailDetails, string ProjectName, string ProjectType, string BillingPeriod)
        {
            StringBuilder htmlBody = new StringBuilder();
            bool ISend;

            string subject = string.Empty;
            string attachmentPath = string.Empty;
            string zipAttachmentPath = string.Empty;

            //string toAddress = "anita@infinity-data.com";
            //string toCC = "p.patil@infinityinternationals.us," + EmployeeInfo.Current.OfficialEmailID;
            //string toBcc = "b.shubhangi@infinityinternationals.us";

            string toAddress = "b.shubhangi@infinityinternationals.us";
            string toCC = "b.shubhangi@infinityinternationals.us";
            string toBcc = "b.shubhangi@infinityinternationals.us";

            try
            {
                if (dt == null || dt.Rows.Count == 0)
                {
                    return 0;
                }

                subject = string.Format("{0} {1} - Billing Details - {2}", ProjectName, ProjectType, BillingPeriod);

                htmlBody.Append(
                    @"<div style='display:none;max-height:0;overflow:hidden;color:transparent;'>
                        Search billing details are ready for review.
                      </div>
                      <table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='width:100%;table-layout:fixed;background-color:#eef2f7;'>
                        <tr>
                          <td width='70%' align='left' valign='top' style='width:70%;padding:0;'>
                            <table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' align='left' style='width:100%;background-color:#ffffff;border:0;'>
                              <tr><td style='height:5px;background-color:#10b981;font-size:0;line-height:0;'>&nbsp;</td></tr>
                              <tr>
                                <td style='padding:14px 24px;background-color:#112044;'>
                                  <table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0'>
                                    <tr>
                                      <td style='color:#ffffff;font-family:Segoe UI,Arial,sans-serif;font-size:17px;font-weight:700;'>INFINITY <span style='color:#5eead4;'>IPS</span></td>
                                      <td align='right'><span style='display:inline-block;padding:6px 10px;border:1px solid #38517f;border-radius:20px;color:#dbeafe;font-family:Segoe UI,Arial,sans-serif;font-size:10px;font-weight:700;letter-spacing:.7px;'>SEARCH BILLING</span></td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>");

                htmlBody.AppendFormat(
                    @"<tr>
                        <td style='padding:19px 25px;background-color:#0f766e;'>
                          <table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0'>
                            <tr>
                              <td valign='middle' style='padding-right:20px;'>
                                <div style='margin:0 0 5px;color:#ccfbf1;font-family:Segoe UI,Arial,sans-serif;font-size:9px;font-weight:700;letter-spacing:.9px;text-transform:uppercase;'>Billing workspace notification</div>
                                <div style='margin:0;color:#ffffff;font-family:Segoe UI,Arial,sans-serif;font-size:23px;font-weight:750;line-height:1.2;'>Search Billing Details Summary</div>
                                <div style='margin-top:7px;color:#d5f5ef;font-family:Segoe UI,Arial,sans-serif;font-size:12px;line-height:1.4;'>{0} &nbsp;&bull;&nbsp; {1}</div>
                              </td>
                              <td width='230' align='right' valign='middle'>
                                <table role='presentation' cellpadding='0' cellspacing='0' border='0' align='right'>
                                  <tr><td style='padding:8px 12px;background-color:#ffffff;border-radius:8px;color:#0f5f59;font-family:Segoe UI,Arial,sans-serif;font-size:11px;font-weight:700;white-space:nowrap;'>&#128197;&nbsp; {2}</td></tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td style='padding:26px 30px 8px;'>
                          <div style='color:#172033;font-family:Segoe UI,Arial,sans-serif;font-size:16px;font-weight:700;'>Hello Accounts Team,</div>
                          <div style='margin-top:8px;color:#526174;font-family:Segoe UI,Arial,sans-serif;font-size:13px;line-height:1.65;'>The billing summary for <strong style='color:#172033;'>{0}</strong> has been generated through the Online Search Tracking workspace. Please review the overview below and use the attached workbook for complete billing details.</div>
                        </td>
                      </tr>",
                    System.Web.HttpUtility.HtmlEncode(ProjectName),
                    System.Web.HttpUtility.HtmlEncode(ProjectType),
                    System.Web.HttpUtility.HtmlEncode(BillingPeriod));

                if (dtSummaryForEmail != null && dtSummaryForEmail.Rows.Count > 0)
                {
                    AppendBillingSummaryTable(htmlBody, dtSummaryForEmail, ProjectName, ProjectType, BillingPeriod);
                }

                htmlBody.Append(
                    @"<tr>
                        <td style='padding:14px 30px 24px;'>
                          <table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='background-color:#f0fdfa;border:1px solid #99f6e4;border-radius:10px;'>
                            <tr>
                              <td width='52' align='center' style='padding:15px 0 15px 15px;color:#0f766e;font-family:Segoe UI Symbol,Arial,sans-serif;font-size:23px;'>&#128206;</td>
                              <td style='padding:14px 12px;'>
                                <div style='color:#115e59;font-family:Segoe UI,Arial,sans-serif;font-size:12px;font-weight:700;'>Detailed billing workbook attached</div>
                                <div style='margin-top:3px;color:#52716d;font-family:Segoe UI,Arial,sans-serif;font-size:10px;line-height:1.5;'>Open the Excel attachment to review the complete order-level billing information.</div>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>");

                AppendEmailFooter(htmlBody);

                // The workbook uses the existing billing records for Sheet 1 and the
                // matched cost approval details for Sheet 2. dt remains the existing
                // Send-To-Accounts validation/result set above.
                attachmentPath = CreateBillingExcelAttachment(dtRecordsForExcel, dtEmailForExcel, ProjectName, BillingPeriod);
                zipAttachmentPath = CreateCostEmailAttachmentsZip(costEmailDetails, ProjectName, BillingPeriod);

                string strPassword = new bllMaster().GetPassword("ackdata");

                ISend = sendMailForOnlineTracking(toAddress, toCC, toBcc, subject, attachmentPath, zipAttachmentPath, htmlBody, strPassword);
            }
            finally
            {
                // Remove the temporary Excel file after the email is sent.
                DeleteTemporaryFile(attachmentPath);
                DeleteTemporaryFile(zipAttachmentPath);
            }

            if (ISend == true)
                return 1;
            else
                return 0;
        }

        public static bool sendMailForOnlineTracking(string ToAddress, string ToCC, string ToBCC, string Subject, string Path, string ZipPath, StringBuilder htmlBody, string Pwd)
        {
            MailMessage mail = null;
            SmtpClient client = null;
            try
            {
                String Body = htmlBody.ToString();
                StringBuilder template = new StringBuilder();
                template.Append("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /></head><body style=\"margin:0;padding:0;background-color:#eef2f7;\">");
                //template.Append("<img src=\"http://www.infinity-data.com/images/TemplateHeader.png\" /><br />");
                template.Append(Body);
                //template.Append("<br /><img src=\"http://www.infinity-data.com/images/TemplateFooter.png\" />");
                template.Append("</body></html>");
                mail = new MailMessage();
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
                    at.Name = Subject + " All Orders" + ".xlsx";
                    mail.Attachments.Add(at);
                }

                if (!string.IsNullOrWhiteSpace(ZipPath) && File.Exists(ZipPath))
                {
                    Attachment zipAttachment = new Attachment(ZipPath);
                    zipAttachment.Name = Subject + " Cost Approval Attachments.zip";
                    mail.Attachments.Add(zipAttachment);
                }

                mail.Priority = System.Net.Mail.MailPriority.High;
                client = new SmtpClient();
                client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", Pwd);

                client.Host = "smtp.office365.com";  //Gmail works on Server Secured Layer
                client.Port = 587;
                client.EnableSsl = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;


                client.EnableSsl = true;
                client.Send(mail);
                htmlBody.Remove(0, htmlBody.Length);
                return true;
            }
            catch (Exception ex)
            {
                //lblError.Text = ex.ToString();
                return false;
            }
            finally
            {
                if (mail != null)
                {
                    mail.Dispose();
                }

                if (client != null)
                {
                    client.Dispose();
                }
            }
        }

        private static string CreateBillingExcelAttachment(DataTable dtRecordsForExcel, DataTable dtEmailForExcel, string projectName, string billingPeriod)
        {
            if (dtRecordsForExcel == null)
            {
                throw new ArgumentNullException("dtRecordsForExcel");
            }

            string safeProjectName = GetSafeFileName(projectName);
            string safeBillingPeriod = GetSafeFileName(billingPeriod);

            string fileName = string.Format("{0}_Billing_Details_{1}_{2}.xlsx", safeProjectName, safeBillingPeriod, DateTime.Now.ToString("yyyyMMdd_HHmmss"));

            string folderPath = Path.Combine(Path.GetTempPath(), "ClientBillingAttachments");

            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }

            string filePath = Path.Combine(folderPath, fileName);

            DataTable excelTable = dtRecordsForExcel.Copy();

            if (string.IsNullOrWhiteSpace(excelTable.TableName))
            {
                excelTable.TableName = "Billing Details";
            }

            using (XLWorkbook workbook = new XLWorkbook())
            {
                const int tableHeaderRow = 7;
                int columnCount = Math.Max(excelTable.Columns.Count, 1);
                int lastDataRow = tableHeaderRow + excelTable.Rows.Count;
                IXLWorksheet worksheet = workbook.Worksheets.Add("Billing Details");

                worksheet.ShowGridLines = false;
                worksheet.TabColor = XLColor.FromHtml("#0F766E");
                worksheet.Style.Font.FontName = "Segoe UI";
                worksheet.Style.Font.FontSize = 10;

                // Branded workbook heading.
                IXLRange brandRange = worksheet.Range(1, 1, 1, columnCount);
                brandRange.Merge();
                brandRange.Value = "INFINITY IPS  |  SEARCH BILLING";
                brandRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#102247");
                brandRange.Style.Font.FontColor = XLColor.White;
                brandRange.Style.Font.Bold = true;
                brandRange.Style.Font.FontSize = 12;
                brandRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                brandRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                worksheet.Row(1).Height = 26;

                IXLRange titleRange = worksheet.Range(2, 1, 2, columnCount);
                titleRange.Merge();
                titleRange.Value = "Search Billing Details";
                titleRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#148277");
                titleRange.Style.Font.FontColor = XLColor.White;
                titleRange.Style.Font.Bold = true;
                titleRange.Style.Font.FontSize = 18;
                titleRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                titleRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                worksheet.Row(2).Height = 34;

                IXLRange subtitleRange = worksheet.Range(3, 1, 3, columnCount);
                subtitleRange.Merge();
                subtitleRange.Value = string.Format("Project: {0}    |    Billing period: {1}", projectName, billingPeriod);
                subtitleRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#148277");
                subtitleRange.Style.Font.FontColor = XLColor.FromHtml("#D7FFF8");
                subtitleRange.Style.Font.FontSize = 10;
                subtitleRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                worksheet.Row(3).Height = 22;

                IXLRange accentRange = worksheet.Range(4, 1, 4, columnCount);
                accentRange.Merge();
                accentRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#34D399");
                worksheet.Row(4).Height = 4;

                IXLRange summaryRange = worksheet.Range(5, 1, 5, columnCount);
                summaryRange.Merge();
                summaryRange.Value = string.Format("SELECTED BILLING RECORDS: {0}     •     GENERATED: {1}", excelTable.Rows.Count, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"));
                summaryRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#ECFDF5");
                summaryRange.Style.Font.FontColor = XLColor.FromHtml("#115E59");
                summaryRange.Style.Font.Bold = true;
                summaryRange.Style.Font.FontSize = 10;
                summaryRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                worksheet.Row(5).Height = 25;
                worksheet.Row(6).Height = 8;

                IXLTable billingTable = worksheet.Cell(tableHeaderRow, 1).InsertTable(excelTable, "BillingDetailsTable", true);
                billingTable.Theme = XLTableTheme.TableStyleMedium2;
                billingTable.ShowAutoFilter = true;
                billingTable.ShowRowStripes = true;

                IXLRange headerRange = worksheet.Range(tableHeaderRow, 1, tableHeaderRow, columnCount);
                headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#1F4E78");
                headerRange.Style.Font.FontColor = XLColor.White;
                headerRange.Style.Font.Bold = true;
                headerRange.Style.Font.FontSize = 10;
                headerRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                headerRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                headerRange.Style.Alignment.WrapText = true;
                headerRange.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                headerRange.Style.Border.BottomBorderColor = XLColor.FromHtml("#34D399");
                worksheet.Row(tableHeaderRow).Height = 30;

                if (excelTable.Rows.Count > 0)
                {
                    IXLRange dataRange = worksheet.Range(tableHeaderRow + 1, 1, lastDataRow, columnCount);
                    dataRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                    dataRange.Style.Border.BottomBorder = XLBorderStyleValues.Hair;
                    dataRange.Style.Border.BottomBorderColor = XLColor.FromHtml("#D7E1EA");

                    for (int rowNumber = tableHeaderRow + 1; rowNumber <= lastDataRow; rowNumber++)
                    {
                        worksheet.Row(rowNumber).Height = 21;
                    }
                }

                worksheet.SheetView.FreezeRows(tableHeaderRow);
                worksheet.SheetView.FreezeColumns(Math.Min(2, columnCount));
                worksheet.Columns(1, columnCount).AdjustToContents(tableHeaderRow, lastDataRow);

                for (int columnNumber = 1; columnNumber <= columnCount; columnNumber++)
                {
                    IXLColumn column = worksheet.Column(columnNumber);
                    string columnName = excelTable.Columns[columnNumber - 1].ColumnName;
                    double maximumWidth = columnName.IndexOf("Address", StringComparison.OrdinalIgnoreCase) >= 0 ? 48 : 28;

                    if (column.Width < 11)
                    {
                        column.Width = 11;
                    }
                    else if (column.Width > maximumWidth)
                    {
                        column.Width = maximumWidth;
                    }

                    if (columnName.IndexOf("Date", StringComparison.OrdinalIgnoreCase) >= 0 &&
                        excelTable.Columns[columnNumber - 1].DataType == typeof(DateTime))
                    {
                        worksheet.Column(columnNumber).Style.DateFormat.Format = "dd-MMM-yyyy";
                    }
                }

                worksheet.PageSetup.PageOrientation = XLPageOrientation.Landscape;
                worksheet.PageSetup.FitToPages(1, 0);
                worksheet.PageSetup.Margins.Top = 0.35;
                worksheet.PageSetup.Margins.Bottom = 0.35;
                worksheet.PageSetup.Margins.Left = 0.25;
                worksheet.PageSetup.Margins.Right = 0.25;

                AddCostApprovalWorksheet(workbook, dtEmailForExcel);
                workbook.SaveAs(filePath);
            }

            return filePath;
        }

        private static DataTable BuildCostApprovalData(DataTable dtRecordsForExcel, DataTable costEmailDetails)
        {
            DataTable approvalTable = new DataTable("Cost Approval Details");
            approvalTable.Columns.Add("Sr #", typeof(int));
            approvalTable.Columns.Add("Order No");
            approvalTable.Columns.Add("State");
            approvalTable.Columns.Add("County");
            approvalTable.Columns.Add("Received Date");
            approvalTable.Columns.Add("Online Offline");
            approvalTable.Columns.Add("Abstractor Search Cost");
            approvalTable.Columns.Add("Abstractor Copy Cost");
            approvalTable.Columns.Add("Cost paid for Independent Abstractor");
            approvalTable.Columns.Add("Amount Approved from Client");
            approvalTable.Columns.Add("Approval Email Content/Remark");

            Dictionary<string, DataRow> reportRowsByOrderId = new Dictionary<string, DataRow>(StringComparer.OrdinalIgnoreCase);
            if (dtRecordsForExcel != null)
            {
                foreach (DataRow reportRow in dtRecordsForExcel.Rows)
                {
                    string orderId = GetDataRowValue(reportRow, "OrderID");
                    if (!string.IsNullOrWhiteSpace(orderId) && !reportRowsByOrderId.ContainsKey(orderId))
                    {
                        reportRowsByOrderId.Add(orderId, reportRow);
                    }
                }
            }

            if (costEmailDetails != null)
            {
                int serialNumber = 1;
                foreach (DataRow costRow in costEmailDetails.Rows)
                {
                    string orderId = GetDataRowValue(costRow, "OrderID");
                    DataRow reportRow;
                    reportRowsByOrderId.TryGetValue(orderId, out reportRow);

                    DataRow approvalRow = approvalTable.NewRow();
                    approvalRow["Sr #"] = serialNumber++;
                    string orderNumber = GetDataRowValue(reportRow, "ClientOrderNo", "OrderNo");
                    approvalRow["Order No"] = string.IsNullOrWhiteSpace(orderNumber) ? orderId : orderNumber;
                    approvalRow["State"] = GetDataRowValue(reportRow, "State");
                    approvalRow["County"] = GetDataRowValue(reportRow, "County");
                    approvalRow["Received Date"] = GetDataRowValue(reportRow, "OrderDate", "ReceivedDate");
                    approvalRow["Online Offline"] = GetDataRowValue(reportRow, "OnOffLine", "OnlineOffline");
                    approvalRow["Abstractor Search Cost"] = GetDataRowValue(reportRow, "AbstractorSearchCost");
                    approvalRow["Abstractor Copy Cost"] = GetDataRowValue(reportRow, "AbstractorCopyCostCost", "AbstractorCopyCost");
                    approvalRow["Cost paid for Independent Abstractor"] = GetDataRowValue(reportRow, "Abstractorpaid", "AbstractorPaid");
                    approvalRow["Amount Approved from Client"] = GetDataRowValue(costRow, "CostDiff");
                    approvalRow["Approval Email Content/Remark"] = GetDataRowValue(costRow, "EmailInput", "EmailNote");
                    approvalTable.Rows.Add(approvalRow);
                }
            }

            return approvalTable;
        }

        private static void AddCostApprovalWorksheet(XLWorkbook workbook, DataTable dtEmailForExcel)
        {
            DataTable approvalTable = dtEmailForExcel ?? BuildCostApprovalData(null, null);

            IXLWorksheet worksheet = workbook.Worksheets.Add("Cost Approval Details");
            worksheet.ShowGridLines = false;
            worksheet.TabColor = XLColor.FromHtml("#2563EB");
            worksheet.Style.Font.FontName = "Segoe UI";
            worksheet.Style.Font.FontSize = 10;

            if (approvalTable.Rows.Count > 0)
            {
                IXLTable approvalExcelTable = worksheet.Cell(1, 1).InsertTable(approvalTable, "CostApprovalDetailsTable", true);
                approvalExcelTable.Theme = XLTableTheme.TableStyleMedium2;
                approvalExcelTable.ShowAutoFilter = true;
                approvalExcelTable.ShowRowStripes = true;
            }
            else
            {
                for (int columnIndex = 0; columnIndex < approvalTable.Columns.Count; columnIndex++)
                {
                    worksheet.Cell(1, columnIndex + 1).Value = approvalTable.Columns[columnIndex].ColumnName;
                }
            }

            IXLRange headerRange = worksheet.Range(1, 1, 1, approvalTable.Columns.Count);
            headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#D9E2F3");
            headerRange.Style.Font.FontColor = XLColor.Black;
            headerRange.Style.Font.Bold = true;
            headerRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            headerRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
            headerRange.Style.Alignment.WrapText = true;
            headerRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            headerRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            worksheet.Row(1).Height = 34;

            int lastRow = Math.Max(approvalTable.Rows.Count + 1, 1);
            IXLRange usedRange = worksheet.Range(1, 1, lastRow, approvalTable.Columns.Count);
            usedRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            usedRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            usedRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

            worksheet.SheetView.FreezeRows(1);
            worksheet.Columns(1, approvalTable.Columns.Count).AdjustToContents();
            for (int columnNumber = 1; columnNumber <= approvalTable.Columns.Count; columnNumber++)
            {
                IXLColumn column = worksheet.Column(columnNumber);
                double maximumWidth = columnNumber == 11 ? 80 : 28;
                if (column.Width < 10) column.Width = 10;
                if (column.Width > maximumWidth) column.Width = maximumWidth;
            }

            worksheet.Column(11).Style.Alignment.WrapText = true;
            worksheet.PageSetup.PageOrientation = XLPageOrientation.Landscape;
            worksheet.PageSetup.FitToPages(1, 0);
        }

        private static string GetDataRowValue(DataRow row, params string[] columnNames)
        {
            if (row == null || row.Table == null)
            {
                return string.Empty;
            }

            foreach (string columnName in columnNames)
            {
                DataColumn column = row.Table.Columns.Cast<DataColumn>()
                    .FirstOrDefault(item => string.Equals(item.ColumnName, columnName, StringComparison.OrdinalIgnoreCase));
                if (column != null && row[column] != DBNull.Value)
                {
                    return Convert.ToString(row[column]);
                }
            }

            return string.Empty;
        }

        private static string CreateCostEmailAttachmentsZip(DataTable costEmailDetails, string projectName, string billingPeriod)
        {
            if (costEmailDetails == null || costEmailDetails.Rows.Count == 0 ||
                !costEmailDetails.Columns.Contains("AttachmentPath"))
            {
                return string.Empty;
            }

            List<KeyValuePair<string, string>> attachmentFiles = GetValidCostEmailAttachmentFiles(costEmailDetails);
            if (attachmentFiles.Count == 0)
            {
                return string.Empty;
            }

            string folderPath = Path.Combine(Path.GetTempPath(), "ClientBillingAttachments");
            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }

            string zipPath = Path.Combine(folderPath, string.Format("{0}_Cost_Approval_Attachments_{1}_{2}.zip",
                GetSafeFileName(projectName), GetSafeFileName(billingPeriod), DateTime.Now.ToString("yyyyMMdd_HHmmss")));

            try
            {
                int addedFileCount = 0;
                using (FileStream zipFileStream = File.Create(zipPath))
                using (ZipOutputStream zipStream = new ZipOutputStream(zipFileStream))
                {
                    zipStream.SetLevel(6);
                    HashSet<string> entryNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                    byte[] buffer = new byte[81920];

                    foreach (KeyValuePair<string, string> attachmentFile in attachmentFiles)
                    {
                        bool entryOpened = false;
                        try
                        {
                            string entryName = GetUniqueZipEntryName(entryNames, attachmentFile.Key, Path.GetFileName(attachmentFile.Value));
                            ZipEntry entry = new ZipEntry(entryName);
                            entry.DateTime = File.GetLastWriteTime(attachmentFile.Value);

                            using (FileStream input = File.OpenRead(attachmentFile.Value))
                            {
                                zipStream.PutNextEntry(entry);
                                entryOpened = true;
                                int bytesRead;
                                while ((bytesRead = input.Read(buffer, 0, buffer.Length)) > 0)
                                {
                                    zipStream.Write(buffer, 0, bytesRead);
                                }
                            }

                            zipStream.CloseEntry();
                            entryOpened = false;
                            addedFileCount++;
                        }
                        catch
                        {
                            // A missing, locked, or unreadable attachment must not stop the email.
                            if (entryOpened)
                            {
                                try { zipStream.CloseEntry(); }
                                catch { }
                            }
                        }
                    }

                    zipStream.Finish();
                }

                if (addedFileCount > 0)
                {
                    return zipPath;
                }

                DeleteTemporaryFile(zipPath);
                return string.Empty;
            }
            catch
            {
                DeleteTemporaryFile(zipPath);
                return string.Empty;
            }
        }

        private static List<KeyValuePair<string, string>> GetValidCostEmailAttachmentFiles(DataTable costEmailDetails)
        {
            List<KeyValuePair<string, string>> files = new List<KeyValuePair<string, string>>();
            HashSet<string> physicalPaths = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            string rootFolder = Path.GetFullPath(HttpContext.Current.Server.MapPath("~/OSTAttachment"));

            foreach (DataRow row in costEmailDetails.Rows)
            {
                string storedPath = GetDataRowValue(row, "AttachmentPath").Trim();
                string orderId = GetDataRowValue(row, "OrderID");
                if (string.IsNullOrWhiteSpace(storedPath))
                {
                    continue;
                }

                try
                {
                    string physicalPath = ResolveCostEmailAttachmentPath(storedPath);
                    if (string.IsNullOrWhiteSpace(physicalPath) ||
                        !physicalPath.StartsWith(rootFolder + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase))
                    {
                        continue;
                    }

                    if (File.Exists(physicalPath) && physicalPaths.Add(physicalPath))
                    {
                        files.Add(new KeyValuePair<string, string>(orderId, physicalPath));
                    }
                    else if (Directory.Exists(physicalPath))
                    {
                        foreach (string file in Directory.GetFiles(physicalPath, "*", SearchOption.TopDirectoryOnly))
                        {
                            string fullFilePath = Path.GetFullPath(file);
                            if (physicalPaths.Add(fullFilePath))
                            {
                                files.Add(new KeyValuePair<string, string>(orderId, fullFilePath));
                            }
                        }
                    }
                }
                catch
                {
                    // Ignore malformed or unavailable paths and continue with remaining files.
                }
            }

            return files;
        }

        private static string ResolveCostEmailAttachmentPath(string storedPath)
        {
            string normalizedPath = HttpUtility.UrlDecode(storedPath ?? string.Empty).Trim().Trim('"').Replace('/', '\\');
            if (normalizedPath.StartsWith("~\\", StringComparison.OrdinalIgnoreCase))
            {
                return Path.GetFullPath(HttpContext.Current.Server.MapPath(normalizedPath));
            }

            if (Path.IsPathRooted(normalizedPath))
            {
                return Path.GetFullPath(normalizedPath);
            }

            normalizedPath = normalizedPath.TrimStart('\\');
            return Path.GetFullPath(HttpContext.Current.Server.MapPath("~/" + normalizedPath.Replace('\\', '/')));
        }

        private static string GetUniqueZipEntryName(HashSet<string> entryNames, string orderId, string fileName)
        {
            string safeOrderId = GetSafeFileName(string.IsNullOrWhiteSpace(orderId) ? "UnknownOrder" : orderId);
            string safeFileName = GetSafeFileName(fileName);
            string entryName = safeOrderId + "/" + safeFileName;
            int duplicateNumber = 2;

            while (!entryNames.Add(entryName))
            {
                string baseName = Path.GetFileNameWithoutExtension(safeFileName);
                string extension = Path.GetExtension(safeFileName);
                entryName = safeOrderId + "/" + baseName + "_" + duplicateNumber++ + extension;
            }

            return entryName;
        }

        private static void AppendBillingSummaryTable(StringBuilder htmlBody, DataTable dt2, string projectName, string projectType, string billingPeriod)
        {
            foreach (DataRow row in dt2.Rows)
            {
                htmlBody.AppendFormat(
                    @"<tr>
                        <td style='padding:18px 25px 6px;'>
                          <table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0'>
                            <tr>
                              <td style='padding:0 5px 9px;color:#172033;font-family:Segoe UI,Arial,sans-serif;font-size:14px;font-weight:700;'>Billing overview</td>
                              <td align='right' style='padding:0 5px 9px;color:#64748b;font-family:Segoe UI,Arial,sans-serif;font-size:10px;'>{0}</td>
                            </tr>
                          </table>
                          <table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='table-layout:fixed;'>
                            <tr>",
                    System.Web.HttpUtility.HtmlEncode(GetBillingValue(row, "BillingPeriod")));

                AppendBillingMetricCard(htmlBody, "Received", GetBillingValue(row, "Received"), "#2563eb", "#eff6ff");
                AppendBillingMetricCard(htmlBody, "Dispatched", GetBillingValue(row, "Dispatch"), "#059669", "#ecfdf5");
                AppendBillingMetricCard(htmlBody, "Cancelled", GetBillingValue(row, "Cancel"), "#dc2626", "#fef2f2");
                AppendBillingMetricCard(htmlBody, "On Hold", GetBillingValue(row, "Hold"), "#d97706", "#fffbeb");

                htmlBody.Append("</tr><tr>");

                AppendBillingMetricCard(htmlBody, "Pending Search", GetBillingValue(row, "Pending"), "#7c3aed", "#f5f3ff");
                AppendBillingMetricCard(htmlBody, "Pending Typing", GetBillingValue(row, "Typing"), "#0891b2", "#ecfeff");
                AppendBillingMetricCard(htmlBody, "Pending Tax", GetBillingValue(row, "Tax"), "#be185d", "#fdf2f8");
                htmlBody.Append("<td width='25%' style='padding:5px;'>&nbsp;</td>");

                htmlBody.Append("</tr></table></td></tr>");
            }
        }

        private static void AppendBillingMetricCard(StringBuilder htmlBody, string label, string value, string accentColor, string backgroundColor)
        {
            htmlBody.AppendFormat(
                @"<td width='25%' valign='top' style='padding:5px;'>
                    <table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0' style='background-color:{3};border:1px solid #e2e8f0;border-left:4px solid {2};border-radius:9px;'>
                      <tr><td style='padding:13px 11px;'>
                        <div style='color:#64748b;font-family:Segoe UI,Arial,sans-serif;font-size:9px;font-weight:700;letter-spacing:.3px;text-transform:uppercase;'>{0}</div>
                        <div style='margin-top:5px;color:#172033;font-family:Segoe UI,Arial,sans-serif;font-size:20px;font-weight:750;line-height:1;'>{1}</div>
                      </td></tr>
                    </table>
                  </td>",
                System.Web.HttpUtility.HtmlEncode(label),
                System.Web.HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(value) ? "0" : value),
                accentColor,
                backgroundColor);
        }

        private static string GetBillingValue(DataRow row, string columnName)
        {
            if (row != null && row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value)
            {
                return Convert.ToString(row[columnName]);
            }

            return string.Empty;
        }

        private static void AppendEmailFooter(StringBuilder htmlBody)
        {
            htmlBody.Append(
                @"<tr>
                    <td style='padding:22px 30px;background-color:#f8fafc;border-top:1px solid #e2e8f0;'>
                      <table role='presentation' width='100%' cellpadding='0' cellspacing='0' border='0'>
                        <tr>
                          <td valign='top'>
                            <div style='color:#172033;font-family:Segoe UI,Arial,sans-serif;font-size:12px;font-weight:700;'>Thanks,<br />Infinity IPS Team</div>
                            <div style='margin-top:5px;color:#64748b;font-family:Segoe UI,Arial,sans-serif;font-size:9px;'>Online Search Tracking &amp; Billing Workspace</div>
                          </td>
                          <td align='right' valign='top'><span style='display:inline-block;padding:6px 9px;background-color:#e8f7f2;border-radius:12px;color:#0f766e;font-family:Segoe UI,Arial,sans-serif;font-size:9px;font-weight:700;'>AUTOMATED NOTIFICATION</span></td>
                        </tr>
                      </table>
                      <div style='margin-top:18px;padding-top:14px;border-top:1px solid #dbe4ee;color:#8591a3;font-family:Segoe UI,Arial,sans-serif;font-size:8px;line-height:1.55;'>
                        <strong style='color:#64748b;'>CONFIDENTIALITY NOTICE:</strong> This message may contain confidential or privileged information. If you are not the intended recipient, please notify the sender and permanently delete this message. This email was generated automatically from the ERP portal; please do not reply.
                      </div>
                    </td>
                  </tr>
                </table>
              </td>
              <td width='30%' valign='top' style='width:30%;padding:0;background-color:#eef2f7;'>&nbsp;</td>
            </tr>
          </table>"
            );
        }

        private static string GetSafeFileName(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                return "Billing";
            }

            foreach (char invalidCharacter in Path.GetInvalidFileNameChars())
            {
                value = value.Replace(invalidCharacter, '_');
            }

            return value.Trim().Replace(" ", "_");
        }

        private static void DeleteTemporaryFile(string filePath)
        {
            if (string.IsNullOrWhiteSpace(filePath))
            {
                return;
            }

            try
            {
                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }
            }
            catch
            {
                // Do not fail the email process only because temporary-file
                // cleanup was unsuccessful. Log this exception if required.
            }
        }

        #endregion
    }
}
