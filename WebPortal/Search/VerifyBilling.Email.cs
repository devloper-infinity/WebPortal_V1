using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Search
{
    public partial class VerifyBilling
    {
        public sealed class SendToAccountsResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
        }

        private sealed class BillingEmailConfiguration
        {
            public string To { get; set; }
            public string CC { get; set; }
            public string BCC { get; set; }
            public string SelectedName { get; set; }
        }

        private sealed class BillingColumn
        {
            public BillingColumn(string header, string field)
            {
                Header = header;
                Field = field;
            }

            public string Header { get; private set; }
            public string Field { get; private set; }
        }

        private static readonly BillingColumn[] BillingExportColumns =
        {
            new BillingColumn("Sr. #", "SrNo"),
            new BillingColumn("Order No", "ClientOrderNo"),
            new BillingColumn("State", "State"),
            new BillingColumn("County", "County"),
            new BillingColumn("Received Date", "OrderDate"),
            new BillingColumn("Dispatch Date", "DeliveredDate"),
            new BillingColumn("No of Documents", "NoOfDocuments"),
            new BillingColumn("No of Pages", "NoOfPages"),
            new BillingColumn("Tax Information", "TaxInformation"),
            new BillingColumn("Taxes Calling(Y/N)", "CalledTaxes"),
            new BillingColumn("Name + Property Search cost in title plant", "PropertySearchCost"),
            new BillingColumn("Document Download Cost", "DocumentDownloadCost"),
            new BillingColumn("Total Retrieval Cost (Searching + Downloading)", "TotalRetrievalCostSearchingDownloading"),
            new BillingColumn("Property Type", "PropertyType"),
            new BillingColumn("Product Type", "ProductType"),
            new BillingColumn("Process Done", "ProcessDone"),
            new BillingColumn("Status", "ProcessStatus"),
            new BillingColumn("Online Offline", "OnOffLine"),
            new BillingColumn("Typing(Y/N)", "Typing"),
            new BillingColumn("SnippingTools(Y/N)", "SnippingTools"),
            new BillingColumn("Production Remark", "Remark"),
            new BillingColumn("Abstractor Search Cost", "AbstractorSearchCost"),
            new BillingColumn("Abstractor Copy Cost", "AbstractorCopyCostCost"),
            new BillingColumn("Cost paid for Independent Abstractor", "Abstractorpaid"),
            new BillingColumn("Abstractor Name", "AbstractorName"),
            new BillingColumn("Total Cost", "OrderCost")
        };

        [WebMethod]
        public static SendToAccountsResponse SendToAccounts(int ProjectID, string Project, string BillingCycle, string BillingPeriod, string OrderIDs)
        {
            try
            {
                if (ProjectID <= 0 || string.IsNullOrWhiteSpace(Project))
                    return Failure("Please select a project.");
                if (string.IsNullOrWhiteSpace(BillingCycle))
                    return Failure("Please select a billing cycle.");
                if (string.IsNullOrWhiteSpace(BillingPeriod))
                    return Failure("Please select a billing period.");

                HashSet<int> selectedOrderIds = ParseOrderIds(OrderIDs);
                if (selectedOrderIds.Count == 0)
                    return Failure("Please select at least one billing record.");

                string[] dates = BillingPeriod.Split('~');
                if (dates.Length != 2 || string.IsNullOrWhiteSpace(dates[0]) || string.IsNullOrWhiteSpace(dates[1]))
                    return Failure("The selected billing period is invalid.");

                string fromDate = dates[0].Trim();
                string toDate = dates[1].Trim();
                DataTable allRows = new bllOST().GetProjectWiseOrderDetailsForBilling_ForVerification(Project, fromDate, toDate);
                DataTable selectedRows = FilterSelectedRows(allRows, selectedOrderIds);

                if (selectedRows.Rows.Count == 0)
                    return Failure("The selected billing records were not found. Please refresh the grid and try again.");
                if (selectedRows.Rows.Count != selectedOrderIds.Count)
                    return Failure("One or more selected billing records are no longer available. Please refresh the grid and try again.");

                BillingEmailConfiguration emailConfiguration = GetEmailConfiguration(ProjectID, Project);
                string recipientError = ValidateRecipients(emailConfiguration);
                if (!string.IsNullOrEmpty(recipientError))
                    return Failure(recipientError);

                decimal totalAmount = selectedRows.AsEnumerable().Sum(row => DecimalValue(row, "OrderCost"));
                string selectedName = string.IsNullOrWhiteSpace(emailConfiguration.SelectedName)
                    ? Project
                    : emailConfiguration.SelectedName.Trim();
                string subject = Project + " - Search Billing Details of " + selectedName + " - " + BillingCycle;
                string attachmentName = SafeFileName(Project + "_" + selectedName + "_" + BillingCycle + "_BillingDetails.xlsx");
                string htmlBody = BuildEmailBody(selectedRows, Project, selectedName, BillingCycle, BillingPeriod, totalAmount);
                byte[] workbookBytes = BuildWorkbook(selectedRows);

                string productionBillingDate = DateTime.Today.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                new bllOST().UpdateBillingInBillingDB(
                    ProjectID,
                    BillingPeriod,
                    BillingCycle,
                    int.Parse(HttpContext.Current.User.Identity.Name),
                    productionBillingDate,
                    productionBillingDate,
                    true,
                    "",
                    "Pending");

                SendEmail(emailConfiguration, subject, htmlBody, attachmentName, workbookBytes);
                new bllOST().HoldOrdersPending(Project, fromDate, toDate);

                return new SendToAccountsResponse
                {
                    Success = true,
                    Message = "Billing details for " + selectedRows.Rows.Count + " selected record(s) were sent to Accounts successfully."
                };
            }
            catch (SmtpException ex)
            {
                return Failure("The billing email could not be sent. " + ex.Message);
            }
            catch (Exception ex)
            {
                return Failure("The billing email or Excel attachment could not be generated. " + ex.Message);
            }
        }

        private static SendToAccountsResponse Failure(string message)
        {
            return new SendToAccountsResponse { Success = false, Message = message };
        }

        private static HashSet<int> ParseOrderIds(string orderIds)
        {
            HashSet<int> result = new HashSet<int>();
            if (string.IsNullOrWhiteSpace(orderIds))
                return result;

            foreach (string value in orderIds.Split(','))
            {
                int orderId;
                if (int.TryParse(value.Trim(), out orderId) && orderId > 0)
                    result.Add(orderId);
            }
            return result;
        }

        private static DataTable FilterSelectedRows(DataTable source, HashSet<int> selectedOrderIds)
        {
            if (source == null)
                throw new InvalidOperationException("Billing data could not be loaded.");
            if (!source.Columns.Contains("OrderID"))
                throw new InvalidOperationException("Billing data does not contain OrderID.");

            DataTable selected = source.Clone();
            foreach (DataRow row in source.Rows)
            {
                int orderId;
                if (int.TryParse(Convert.ToString(row["OrderID"]), out orderId) && selectedOrderIds.Contains(orderId))
                    selected.ImportRow(row);
            }
            return selected;
        }

        private static BillingEmailConfiguration GetEmailConfiguration(int projectId, string project)
        {
            string[] keys =
            {
                "Search Billing - " + projectId,
                "Search Billing - " + project,
                "Search Billing"
            };

            DataTable table = null;
            foreach (string key in keys)
            {
                table = new bllMaster().getEmailConfigrationInfo(key);
                if (table != null && table.Rows.Count > 0)
                    break;
            }

            if (table == null || table.Rows.Count == 0)
                throw new InvalidOperationException("Email recipients are not configured for the selected project/account.");

            DataRow row = table.Rows[0];
            return new BillingEmailConfiguration
            {
                To = ConfigValue(row, new[] { "ToAddress", "To", "EmailTo", "ToEmail", "ToApprDesp" }, 2),
                CC = ConfigValue(row, new[] { "CC", "ToCC", "CCAddress", "EmailCC", "CCAtt" }, 3),
                BCC = ConfigValue(row, new[] { "BCC", "ToBCC", "BCCAddress", "EmailBCC" }, 4),
                SelectedName = ConfigValue(row, new[] { "SelectedName", "AccountName", "ClientName", "DisplayName" }, -1)
            };
        }

        private static string ConfigValue(DataRow row, IEnumerable<string> aliases, int fallbackIndex)
        {
            foreach (string alias in aliases)
            {
                DataColumn column = row.Table.Columns.Cast<DataColumn>()
                    .FirstOrDefault(item => string.Equals(item.ColumnName, alias, StringComparison.OrdinalIgnoreCase));
                if (column != null && row[column] != DBNull.Value)
                    return Convert.ToString(row[column]).Trim();
            }

            return fallbackIndex >= 0 && fallbackIndex < row.Table.Columns.Count && row[fallbackIndex] != DBNull.Value
                ? Convert.ToString(row[fallbackIndex]).Trim()
                : string.Empty;
        }

        private static string ValidateRecipients(BillingEmailConfiguration configuration)
        {
            if (configuration == null || string.IsNullOrWhiteSpace(configuration.To))
                return "A valid To email address is not configured for the selected project/account.";

            string error = ValidateAddressList(configuration.To, "To", false);
            if (!string.IsNullOrEmpty(error)) return error;
            error = ValidateAddressList(configuration.CC, "CC", true);
            if (!string.IsNullOrEmpty(error)) return error;
            return ValidateAddressList(configuration.BCC, "BCC", true);
        }

        private static string ValidateAddressList(string addresses, string label, bool allowEmpty)
        {
            if (string.IsNullOrWhiteSpace(addresses))
                return allowEmpty ? string.Empty : "A valid " + label + " email address is required.";

            foreach (string address in SplitAddresses(addresses))
            {
                try
                {
                    MailAddress parsed = new MailAddress(address);
                    if (!string.Equals(parsed.Address, address.Trim(), StringComparison.OrdinalIgnoreCase))
                        return "The configured " + label + " email address is invalid: " + address;
                }
                catch (FormatException)
                {
                    return "The configured " + label + " email address is invalid: " + address;
                }
            }
            return string.Empty;
        }

        private static IEnumerable<string> SplitAddresses(string addresses)
        {
            return (addresses ?? string.Empty)
                .Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(item => item.Trim())
                .Where(item => item.Length > 0);
        }

        private static void AddAddresses(MailAddressCollection collection, string addresses)
        {
            foreach (string address in SplitAddresses(addresses))
                collection.Add(new MailAddress(address));
        }

        private static decimal DecimalValue(DataRow row, string columnName)
        {
            if (!row.Table.Columns.Contains(columnName) || row[columnName] == DBNull.Value)
                return 0M;

            string value = Convert.ToString(row[columnName]).Replace("$", string.Empty).Replace(",", string.Empty).Trim();
            decimal amount;
            if (decimal.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out amount))
                return amount;
            return decimal.TryParse(value, NumberStyles.Any, CultureInfo.CurrentCulture, out amount) ? amount : 0M;
        }

        private static byte[] BuildWorkbook(DataTable selectedRows)
        {
            using (XLWorkbook workbook = new XLWorkbook())
            using (MemoryStream stream = new MemoryStream())
            {
                IXLWorksheet worksheet = workbook.Worksheets.Add("Billing Details");
                for (int columnIndex = 0; columnIndex < BillingExportColumns.Length; columnIndex++)
                {
                    IXLCell cell = worksheet.Cell(1, columnIndex + 1);
                    cell.Value = BillingExportColumns[columnIndex].Header;
                    cell.Style.Font.Bold = true;
                    cell.Style.Font.FontColor = XLColor.White;
                    cell.Style.Fill.BackgroundColor = XLColor.FromHtml("#0F766E");
                    cell.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                    cell.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                }

                for (int rowIndex = 0; rowIndex < selectedRows.Rows.Count; rowIndex++)
                {
                    DataRow row = selectedRows.Rows[rowIndex];
                    for (int columnIndex = 0; columnIndex < BillingExportColumns.Length; columnIndex++)
                        worksheet.Cell(rowIndex + 2, columnIndex + 1).Value = RowText(row, BillingExportColumns[columnIndex].Field);
                }

                IXLRange range = worksheet.Range(1, 1, selectedRows.Rows.Count + 1, BillingExportColumns.Length);
                range.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                range.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                range.Style.Border.OutsideBorderColor = XLColor.FromHtml("#CBD5E1");
                range.Style.Border.InsideBorderColor = XLColor.FromHtml("#E2E8F0");
                worksheet.SheetView.FreezeRows(1);
                worksheet.Columns().AdjustToContents();
                foreach (IXLColumn column in worksheet.ColumnsUsed())
                {
                    if (column.Width > 45)
                        column.Width = 45;
                }

                workbook.SaveAs(stream);
                return stream.ToArray();
            }
        }

        private static string BuildEmailBody(DataTable rows, string project, string selectedName, string billingCycle, string billingPeriod, decimal totalAmount)
        {
            StringBuilder body = new StringBuilder();
            body.Append("<!doctype html><html><head><meta name='viewport' content='width=device-width,initial-scale=1'>");
            body.Append("<style>@media only screen and (max-width:620px){.email-shell{width:100%!important}.summary-cell{display:block!important;width:auto!important}.responsive-table{display:block!important;overflow-x:auto!important}}</style></head>");
            body.Append("<body style='margin:0;padding:0;background:#f1f5f9;font-family:Segoe UI,Arial,sans-serif;color:#0f172a'>");
            body.Append("<table role='presentation' width='100%' cellspacing='0' cellpadding='0' border='0' style='background:#f1f5f9'><tr><td align='center' style='padding:24px 12px'>");
            body.Append("<table role='presentation' class='email-shell' width='760' cellspacing='0' cellpadding='0' border='0' style='width:760px;max-width:100%;background:#fff;border-radius:14px;overflow:hidden;box-shadow:0 8px 28px rgba(15,23,42,.10)'>");
            body.Append("<tr><td style='padding:28px 32px;background:#0f766e;color:#fff'><div style='font-size:13px;letter-spacing:.08em;text-transform:uppercase;opacity:.85'>Infinity ERP · Search Billing</div><div style='font-size:25px;font-weight:700;margin-top:8px'>" + Html(project) + "</div><div style='font-size:14px;margin-top:6px;opacity:.9'>Billing Cycle: " + Html(billingCycle) + "</div></td></tr>");
            body.Append("<tr><td style='padding:28px 32px 10px'><div style='font-size:22px;font-weight:700'>Search Billing Details Summary</div><div style='font-size:14px;color:#64748b;margin-top:6px'>Selected billing records ready for Accounts.</div></td></tr>");
            body.Append("<tr><td style='padding:14px 32px 24px'><table role='presentation' width='100%' cellspacing='0' cellpadding='0' style='background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px'>");
            body.Append(SummaryRow("Selected Name", selectedName, "Project", project));
            body.Append(SummaryRow("Billing Cycle", billingCycle, "Billing Period", billingPeriod));
            body.Append(SummaryRow("Selected Records", rows.Rows.Count.ToString(CultureInfo.InvariantCulture), "Total Billing Amount", totalAmount.ToString("C2", CultureInfo.GetCultureInfo("en-US"))));
            body.Append("</table></td></tr>");
            body.Append("<tr><td style='padding:0 32px 28px'><div class='responsive-table'><table width='100%' cellspacing='0' cellpadding='0' border='0' style='border-collapse:collapse;font-size:12px;min-width:700px'>");
            body.Append("<thead><tr style='background:#e6f4f1;color:#115e59'>");
            string[] headers = { "Sr. #", "Order No", "State", "County", "Received Date", "Dispatch Date", "Product Type", "Process Done", "Status", "Total Cost" };
            foreach (string header in headers)
                body.Append("<th align='left' style='padding:10px 8px;border:1px solid #cbd5e1;white-space:nowrap'>" + Html(header) + "</th>");
            body.Append("</tr></thead><tbody>");

            string[] fields = { "SrNo", "ClientOrderNo", "State", "County", "OrderDate", "DeliveredDate", "ProductType", "ProcessDone", "ProcessStatus", "OrderCost" };
            foreach (DataRow row in rows.Rows)
            {
                body.Append("<tr>");
                foreach (string field in fields)
                    body.Append("<td style='padding:9px 8px;border:1px solid #e2e8f0;vertical-align:top'>" + Html(RowText(row, field)) + "</td>");
                body.Append("</tr>");
            }

            body.Append("</tbody></table></div>");
            body.Append("<div style='margin-top:16px;padding:14px 16px;background:#ecfdf5;border-left:4px solid #10b981;border-radius:8px;font-size:14px'><strong>Total:</strong> " + totalAmount.ToString("C2", CultureInfo.GetCultureInfo("en-US")) + " across " + rows.Rows.Count + " selected record(s).</div></td></tr>");
            body.Append("<tr><td style='padding:20px 32px;background:#0f172a;color:#cbd5e1;font-size:12px;line-height:1.6'>This email was generated automatically from the Infinity ERP portal. Please do not reply to this automated message.</td></tr>");
            body.Append("</table></td></tr></table></body></html>");
            return body.ToString();
        }

        private static string SummaryRow(string firstLabel, string firstValue, string secondLabel, string secondValue)
        {
            return "<tr>"
                + "<td class='summary-cell' width='50%' style='padding:12px 14px;border-bottom:1px solid #e2e8f0'><div style='font-size:11px;text-transform:uppercase;color:#64748b'>" + Html(firstLabel) + "</div><div style='font-size:14px;font-weight:600;margin-top:4px'>" + Html(firstValue) + "</div></td>"
                + "<td class='summary-cell' width='50%' style='padding:12px 14px;border-bottom:1px solid #e2e8f0'><div style='font-size:11px;text-transform:uppercase;color:#64748b'>" + Html(secondLabel) + "</div><div style='font-size:14px;font-weight:600;margin-top:4px'>" + Html(secondValue) + "</div></td>"
                + "</tr>";
        }

        private static string RowText(DataRow row, string columnName)
        {
            return row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value
                ? Convert.ToString(row[columnName])
                : string.Empty;
        }

        private static string Html(object value)
        {
            return HttpUtility.HtmlEncode(Convert.ToString(value));
        }

        private static string SafeFileName(string fileName)
        {
            foreach (char invalidCharacter in Path.GetInvalidFileNameChars())
                fileName = fileName.Replace(invalidCharacter, '_');
            return fileName.Replace(' ', '_');
        }

        private static void SendEmail(BillingEmailConfiguration configuration, string subject, string htmlBody, string attachmentName, byte[] attachmentBytes)
        {
            string pass = new bllMaster().GetPassword("ackdata");
            if (string.IsNullOrWhiteSpace(pass))
                throw new InvalidOperationException("SMTP credentials are not configured.");

            using (MailMessage mail = new MailMessage())
            using (MemoryStream attachmentStream = new MemoryStream(attachmentBytes))
            using (Attachment attachment = new Attachment(attachmentStream, attachmentName, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
            using (SmtpClient client = new SmtpClient("smtp.office365.com", 587))
            {
                mail.From = new MailAddress("ack@infinity-data.com", "Infinity Search Billing", Encoding.UTF8);
                AddAddresses(mail.To, configuration.To);
                AddAddresses(mail.CC, configuration.CC);
                AddAddresses(mail.Bcc, configuration.BCC);
                mail.Subject = subject;
                mail.SubjectEncoding = Encoding.UTF8;
                mail.Body = htmlBody;
                mail.BodyEncoding = Encoding.UTF8;
                mail.IsBodyHtml = true;
                mail.Priority = MailPriority.High;
                mail.Attachments.Add(attachment);

                client.Credentials = new NetworkCredential("ack@infinity-data.com", pass);
                client.EnableSsl = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                client.Send(mail);
            }
        }
    }
}
