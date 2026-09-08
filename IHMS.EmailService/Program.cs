using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
namespace IHMS.EmailService
{
    internal static class Program
    {
        static readonly HttpClient Http = new HttpClient(); static readonly JavaScriptSerializer Json = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue }; static string Mailbox = ConfigurationManager.AppSettings["SharedMailbox"], Root = ConfigurationManager.AppSettings["AttachmentRoot"];
        static void Main() { Console.CancelKeyPress += (s, e) => Environment.Exit(0); Run().GetAwaiter().GetResult(); }
        static async Task Run()
        {
            Directory.CreateDirectory(Root); for (; ; )
            {
                try
                { var token = await Token(); Http.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token); await ReadMessages(); await SendQueue(); }
                catch (Exception ex) { Log("Error", "Cycle", ex.Message, ex.ToString()); }
                Thread.Sleep(Int32.Parse(ConfigurationManager.AppSettings["PollSeconds"] ?? "30") * 1000);
            }
        }
        static async Task<string> Token() { var tenant = ConfigurationManager.AppSettings["TenantId"]; var form = new FormUrlEncodedContent(new Dictionary<string, string> { { "client_id", ConfigurationManager.AppSettings["ClientId"] }, { "client_secret", ConfigurationManager.AppSettings["ClientSecret"] }, { "scope", "https://graph.microsoft.com/.default" }, { "grant_type", "client_credentials" } }); var r = await Http.PostAsync("https://login.microsoftonline.com/" + Uri.EscapeDataString(tenant) + "/oauth2/v2.0/token", form); return Convert.ToString(Parse(await Ensure(r))["access_token"]); }
        static async Task ReadMessages()
        {
            string url = "https://graph.microsoft.com/v1.0/users/" + Uri.EscapeDataString(Mailbox) + "/mailFolders/inbox/messages?$filter=isRead%20eq%20false&$top=25&$select=id,internetMessageId,subject,body,from,receivedDateTime,hasAttachments"; while (!String.IsNullOrEmpty(url))
            {
                var root = Parse(await Ensure(await Http.GetAsync(url))); foreach (object item in (object[])root["value"])
                { var m = (Dictionary<string, object>)item; try { long ticket = Ingest(m); if (Convert.ToBoolean(m["hasAttachments"])) await Attachments(Convert.ToString(m["id"]), ticket); await Patch("https://graph.microsoft.com/v1.0/users/" + Uri.EscapeDataString(Mailbox) + "/messages/" + Uri.EscapeDataString(Convert.ToString(m["id"])), "{\"isRead\":true}"); } catch (Exception ex) { Log("Error", "Inbound", Convert.ToString(m["id"]), ex.ToString()); } }
                url = root.ContainsKey("@odata.nextLink") ? Convert.ToString(root["@odata.nextLink"]) : null;
            }
        }
        static long Ingest(Dictionary<string, object> m) { var from = (Dictionary<string, object>)((Dictionary<string, object>)m["from"])["emailAddress"]; var body = (Dictionary<string, object>)m["body"]; using (var c = Proc("IHMS_Email_Ingest")) { Add(c, "@GraphMessageID", m["id"]); Add(c, "@InternetMessageID", m["internetMessageId"]); Add(c, "@FromAddress", from["address"]); Add(c, "@FromName", from["name"]); Add(c, "@Subject", m["subject"]); Add(c, "@Body", body["content"]); Add(c, "@ReceivedDate", DateTime.Parse(Convert.ToString(m["receivedDateTime"])).ToUniversalTime()); using (var r = c.ExecuteReader()) { r.Read(); return r.GetInt64(0); } } }
        static async Task Attachments(string messageId, long ticket) { var u = "https://graph.microsoft.com/v1.0/users/" + Uri.EscapeDataString(Mailbox) + "/messages/" + Uri.EscapeDataString(messageId) + "/attachments"; var root = Parse(await Ensure(await Http.GetAsync(u))); foreach (object o in (object[])root["value"]) { var a = (Dictionary<string, object>)o; if (!a.ContainsKey("contentBytes")) continue; var name = Path.GetFileName(Convert.ToString(a["name"])); var stored = Guid.NewGuid().ToString("N") + Path.GetExtension(name); var folder = Path.Combine(Root, DateTime.UtcNow.ToString("yyyy"), DateTime.UtcNow.ToString("MM")); Directory.CreateDirectory(folder); var full = Path.Combine(folder, stored); var bytes = Convert.FromBase64String(Convert.ToString(a["contentBytes"])); File.WriteAllBytes(full, bytes); using (var c = Text("INSERT dbo.IHMS_TicketAttachment(TicketID,OriginalFileName,StoredFileName,ContentType,FileSize,StoragePath,UploadedBy) VALUES(@t,@o,@s,@c,@z,@p,NULL); INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,NewValue,PerformedName) VALUES(@t,'Attachment',@o,'Shared mailbox');")) { Add(c, "@t", ticket); Add(c, "@o", name); Add(c, "@s", stored); Add(c, "@c", a.ContainsKey("contentType") ? a["contentType"] : null); Add(c, "@z", bytes.LongLength); Add(c, "@p", full); c.ExecuteNonQuery(); } } }
        static async Task SendQueue() { for (int i = 0; i < 20; i++) { DataRow q = Claim(); if (q == null) return; try { var to = Recipients(Convert.ToString(q["ToAddresses"])); var cc = Recipients(Convert.ToString(q["CcAddresses"])); var payload = new Dictionary<string, object> { { "message", new Dictionary<string, object> { { "subject", q["Subject"] }, { "body", new Dictionary<string, object> { { "contentType", "HTML" }, { "content", q["Body"] } } }, { "toRecipients", to }, { "ccRecipients", cc } } }, { "saveToSentItems", true } }; var r = await Http.PostAsync("https://graph.microsoft.com/v1.0/users/" + Uri.EscapeDataString(Mailbox) + "/sendMail", new StringContent(Json.Serialize(payload), Encoding.UTF8, "application/json")); await Ensure(r); Complete(Convert.ToInt64(q["QueueID"]), true, null, null); } catch (Exception ex) { Complete(Convert.ToInt64(q["QueueID"]), false, ex.Message, null); } } }
        static object[] Recipients(string addresses) { var a = new List<object>(); foreach (var x in (addresses ?? "").Split(new[] { ';', ',' }, StringSplitOptions.RemoveEmptyEntries)) a.Add(new Dictionary<string, object> { { "emailAddress", new Dictionary<string, object> { { "address", x.Trim() } } } }); return a.ToArray(); }
        static DataRow Claim() { using (var c = Proc("IHMS_EmailQueue_Claim")) using (var a = new SqlDataAdapter(c)) { var t = new DataTable(); a.Fill(t); return t.Rows.Count == 0 ? null : t.Rows[0]; } }
        static void Complete(long id, bool ok, string error, string graph) { using (var c = Proc("IHMS_EmailQueue_Complete")) { Add(c, "@QueueID", id); Add(c, "@Succeeded", ok); Add(c, "@Error", error); Add(c, "@GraphMessageID", graph); c.ExecuteNonQuery(); } }
        static void Log(string level, string type, string message, string ex) { try { using (var c = Text("INSERT dbo.IHMS_ServiceLog(Level,EventType,Message,Exception) VALUES(@l,@t,@m,@e)")) { Add(c, "@l", level); Add(c, "@t", type); Add(c, "@m", message); Add(c, "@e", ex); c.ExecuteNonQuery(); } } catch { } }
        static SqlCommand Proc(string name) { var c = new SqlCommand(name, Open()) { CommandType = CommandType.StoredProcedure, CommandTimeout = 120 }; return c; }
        static SqlCommand Text(string text) { return new SqlCommand(text, Open()) { CommandTimeout = 120 }; }
        static SqlConnection Open() { var c = new SqlConnection(ConfigurationManager.ConnectionStrings["MainCon"].ConnectionString); c.Open(); return c; }
        static void Add(SqlCommand c, string n, object v) { c.Parameters.AddWithValue(n, v ?? DBNull.Value); }
        static Dictionary<string, object> Parse(string value) { return Json.Deserialize<Dictionary<string, object>>(value); }
        static async Task<string> Ensure(HttpResponseMessage r) { var s = await r.Content.ReadAsStringAsync(); if (!r.IsSuccessStatusCode) throw new InvalidOperationException(((int)r.StatusCode) + " " + s); return s; }
        static async Task Patch(string url, string json) { var req = new HttpRequestMessage(new HttpMethod("PATCH"), url) { Content = new StringContent(json, Encoding.UTF8, "application/json") }; await Ensure(await Http.SendAsync(req)); }
    }
}
