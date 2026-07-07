using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.CRM
{
    public partial class AutomationRunner : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.ContentType = "application/json";

            if (!IsAuthorized())
            {
                Response.StatusCode = 403;
                WriteJson(new { Success = false, Message = "CRM automation runner is not authorized." });
                return;
            }

            int batchSize = GetQueryInt("batch", 25);
            bllCRM crm = new bllCRM();
            DataSet jobData = crm.RunAutomationDueJobs(CurrentEmployeeID());
            DataSet dispatchData = crm.GetAutomationDispatchBatch(batchSize);
            DispatchResult result = DispatchQueuedEmails(crm, dispatchData);

            WriteJson(new
            {
                Success = true,
                Generated = TableToRows(jobData != null && jobData.Tables.Count > 0 ? jobData.Tables[0] : null),
                EmailSent = result.Sent,
                EmailFailed = result.Failed,
                EmailSkipped = result.Skipped,
                Errors = result.Errors
            });
        }

        private DispatchResult DispatchQueuedEmails(bllCRM crm, DataSet dispatchData)
        {
            DispatchResult result = new DispatchResult();
            if (dispatchData == null || dispatchData.Tables.Count < 2 || dispatchData.Tables[0].Rows.Count == 0)
            {
                result.Skipped++;
                return result;
            }

            DataRow settings = dispatchData.Tables[0].Rows[0];
            DataTable emails = dispatchData.Tables[1];
            if (emails.Rows.Count == 0)
            {
                return result;
            }

            foreach (DataRow row in emails.Rows)
            {
                int emailOutboxId = GetInt(row, "EmailOutboxID");
                try
                {
                    crm.UpdateEmailOutboxStatus(emailOutboxId, "Sending", string.Empty);
                    SendEmail(settings, row);
                    crm.UpdateEmailOutboxStatus(emailOutboxId, "Sent", string.Empty);
                    result.Sent++;
                }
                catch (Exception ex)
                {
                    string message = ex.Message.Length > 950 ? ex.Message.Substring(0, 950) : ex.Message;
                    crm.UpdateEmailOutboxStatus(emailOutboxId, "Failed", message);
                    result.Failed++;
                    result.Errors.Add("EmailOutboxID " + emailOutboxId + ": " + message);
                }
            }

            return result;
        }

        private static void SendEmail(DataRow settings, DataRow row)
        {
            string fromEmail = GetString(settings, "FromEmail");
            string fromName = GetString(settings, "FromName");
            string smtpHost = GetString(settings, "SmtpHost");
            int smtpPort = GetInt(settings, "SmtpPort");
            string smtpUser = GetString(settings, "SmtpUserName");
            string smtpPassword = GetString(settings, "SmtpPassword");

            if (string.IsNullOrWhiteSpace(fromEmail) || string.IsNullOrWhiteSpace(smtpHost))
            {
                throw new InvalidOperationException("CRM email SMTP settings are incomplete.");
            }

            using (MailMessage mail = new MailMessage())
            {
                mail.From = string.IsNullOrWhiteSpace(fromName)
                    ? new MailAddress(fromEmail)
                    : new MailAddress(fromEmail, fromName, Encoding.UTF8);
                AddAddresses(mail.To, GetString(row, "ToEmail"));
                AddAddresses(mail.CC, GetString(row, "CcEmail"));
                AddAddresses(mail.Bcc, GetString(row, "BccEmail"));

                if (mail.To.Count == 0)
                {
                    throw new InvalidOperationException("CRM email has no recipient.");
                }

                mail.Subject = GetString(row, "Subject");
                mail.SubjectEncoding = Encoding.UTF8;
                mail.Body = GetString(row, "BodyHtml");
                mail.BodyEncoding = Encoding.UTF8;
                mail.IsBodyHtml = true;
                mail.Priority = MailPriority.Normal;

                using (SmtpClient client = new SmtpClient())
                {
                    client.Host = smtpHost;
                    client.Port = smtpPort > 0 ? smtpPort : 587;
                    client.EnableSsl = GetBool(settings, "EnableSSL");
                    if (!string.IsNullOrWhiteSpace(smtpUser))
                    {
                        client.Credentials = new NetworkCredential(smtpUser, smtpPassword);
                    }
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                    client.Send(mail);
                }
            }
        }

        private static void AddAddresses(MailAddressCollection collection, string addresses)
        {
            if (string.IsNullOrWhiteSpace(addresses))
            {
                return;
            }

            string[] parts = addresses.Replace(";", ",").Split(',');
            foreach (string part in parts)
            {
                string address = part.Trim();
                if (address.Length > 0)
                {
                    collection.Add(address);
                }
            }
        }

        private bool IsAuthorized()
        {
            string configuredKey = ConfigurationManager.AppSettings["CRM_AutomationKey"];
            if (!string.IsNullOrWhiteSpace(configuredKey) &&
                string.Equals(configuredKey, Request.QueryString["key"], StringComparison.Ordinal))
            {
                return true;
            }

            return Request.IsLocal || IsAuthenticatedUser();
        }

        private bool IsAuthenticatedUser()
        {
            return Context != null && Context.User != null && Context.User.Identity != null && Context.User.Identity.IsAuthenticated;
        }

        private int CurrentEmployeeID()
        {
            int employeeId;
            string value = Context != null && Context.User != null && Context.User.Identity != null
                ? Context.User.Identity.Name
                : string.Empty;
            return int.TryParse(value, out employeeId) ? employeeId : 0;
        }

        private int GetQueryInt(string name, int defaultValue)
        {
            int value;
            return int.TryParse(Request.QueryString[name], out value) && value > 0 ? value : defaultValue;
        }

        private void WriteJson(object value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            Response.Write(serializer.Serialize(value));
        }

        private static List<Dictionary<string, object>> TableToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null)
            {
                return rows;
            }

            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                {
                    row[column.ColumnName] = dataRow[column] == DBNull.Value ? null : dataRow[column];
                }
                rows.Add(row);
            }

            return rows;
        }

        private static string GetString(DataRow row, string columnName)
        {
            return row != null && row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value
                ? Convert.ToString(row[columnName]).Trim()
                : string.Empty;
        }

        private static int GetInt(DataRow row, string columnName)
        {
            int result;
            return int.TryParse(GetString(row, columnName), out result) ? result : 0;
        }

        private static bool GetBool(DataRow row, string columnName)
        {
            string value = GetString(row, columnName);
            return value == "1" || value.Equals("true", StringComparison.OrdinalIgnoreCase);
        }

        private class DispatchResult
        {
            public int Sent { get; set; }
            public int Failed { get; set; }
            public int Skipped { get; set; }
            public List<string> Errors { get; private set; }

            public DispatchResult()
            {
                Errors = new List<string>();
            }
        }
    }
}
