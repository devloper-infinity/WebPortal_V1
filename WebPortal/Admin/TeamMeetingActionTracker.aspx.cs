using System;
using System.Data;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class TeamMeetingActionTracker : TeamMeetingPageBase
    {
        protected void Page_Load(object sender, EventArgs e) { }
        [WebMethod(EnableSession = true)] public static string Bootstrap() { return Json(Repo.Lookup(UserID)); }
        [WebMethod(EnableSession = true)] public static string Search(string status, int assignedTo) { return Json(Repo.ActionItems(UserID, status, assignedTo)); }
        [WebMethod(EnableSession = true)] public static string Notifications() { return Json(Repo.Notifications(UserID)); }
        [WebMethod(EnableSession = true)] public static void MarkNotificationRead(long notificationId) { Repo.MarkNotificationRead(UserID, notificationId); }
        [WebMethod(EnableSession = true)] public static string History(long actionItemId) { if (actionItemId <= 0) throw new Exception("Invalid action item."); return Json(Repo.ActionHistory(UserID, actionItemId)); }
        [WebMethod(EnableSession = true)] public static bool Update(long actionItemId, string status, string remarks, string rowVersion) { if (actionItemId <= 0) throw new Exception("Invalid action item."); Repo.UpdateAction(UserID, actionItemId, status, remarks, Bytes(rowVersion)); return TrySendUpdateEmail(actionItemId); }

        private static bool TrySendUpdateEmail(long actionItemId)
        {
            try
            {
                var ds = Repo.ActionUpdateEmail(actionItemId); if (ds.Tables[0].Rows.Count == 0) return false; var a = ds.Tables[0].Rows[0];
                using (var mail = new MailMessage())
                {
                    foreach (DataRow r in ds.Tables[1].Rows) mail.To.Add(new MailAddress(Convert.ToString(r["OfficialEmailID"]))); if (mail.To.Count == 0) return false;
                    mail.From = new MailAddress("ack@infinity-data.com", "Team Meeting Notification", Encoding.UTF8); mail.Subject = "Action Item Updated - " + Convert.ToString(a["Description"]); mail.IsBodyHtml = true;
                    mail.Body = "<table width='100%' style='background:#f3f6f9;padding:24px;font-family:Arial;color:#263746'><tr><td><table width='680' align='center' style='background:#fff;border:1px solid #dbe3ec'><tr><td style='padding:22px'><h2 style='color:#173955'>Action Item Updated</h2><p><b>Action:</b> " + H(a["Description"]) + "</p><p><b>Assigned To:</b> " + H(a["AssignedToNameSnapshot"]) + "</p><p><b>Updated By:</b> " + H(a["ChangedByName"]) + "</p><p><b>Status:</b> " + H(a["Status"]) + "</p><p><b>Remarks:</b> " + H(a["Remarks"]) + "</p><p><b>Due Date:</b> " + H(a["DueDateText"]) + "</p></td></tr><tr><td style='background:#f7f9fb;padding:12px;font-size:11px;color:#738294'>This is a system-generated email. Please do not reply.</td></tr></table></td></tr></table>";
                    using (var client = new SmtpClient("smtp.office365.com", 587)) { client.Credentials = new NetworkCredential("ack@infinity-data.com", new bllSendMail().GetPassword("ackdata")); client.EnableSsl = true; ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12; client.Send(mail); }
                    return true;
                }
            }
            catch { return false; }
        }
        private static string H(object value) { return HttpUtility.HtmlEncode(Convert.ToString(value)).Replace("\r\n", "<br/>").Replace("\n", "<br/>"); }
    }
}
