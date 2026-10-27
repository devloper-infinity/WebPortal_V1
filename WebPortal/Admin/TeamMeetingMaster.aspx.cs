using System;
using System.Collections.Generic;
using System.Data;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class TeamMeetingMaster : TeamMeetingPageBase
    {
        protected void Page_Load(object sender, EventArgs e) { }
        [WebMethod(EnableSession = true)] public static string Bootstrap() { return Json(Repo.Lookup(UserID)); }
        [WebMethod(EnableSession = true)] public static string Attendance(List<int> teamIds) { if (teamIds == null || teamIds.Count == 0) throw new Exception("Select at least one team."); return Json(Repo.AttendanceCandidates(UserID, teamIds)); }
        [WebMethod(EnableSession = true)] public static string Get(long meetingId) { return Json(Repo.Meeting(UserID, meetingId, true)); }
        [WebMethod(EnableSession = true)]
        public static long Save(long meetingId, int hostEmployeeId, string meetingType, List<int> teamIds, string meetingDate, string meetingTime, string meetingChannel, string otherChannel, string agenda, List<AttendanceInput> attendance, string conclusion, List<ActionInput> actionItems, string rowVersion, string testEmail)
        {
            DateTime d; TimeSpan t;
            if (!DateTime.TryParseExact(meetingDate ?? "", "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out d) || !TimeSpan.TryParse(meetingTime, out t)) throw new Exception("A valid meeting date and time are required.");
            if (hostEmployeeId <= 0 || teamIds == null || teamIds.Count == 0 || attendance == null || attendance.Count == 0 || String.IsNullOrWhiteSpace(agenda) || String.IsNullOrWhiteSpace(conclusion)) throw new Exception("Complete all mandatory fields, including team and attendance.");
            long id = Repo.SaveMeeting(UserID, new MeetingInput { MeetingID = meetingId, HostEmployeeID = hostEmployeeId, MeetingType = meetingType, TeamIDs = teamIds, MeetingDate = d, MeetingTime = t, MeetingChannel = meetingChannel, OtherChannel = otherChannel, Agenda = agenda, Attendance = attendance, Conclusion = conclusion, ActionItems = actionItems ?? new List<ActionInput>(), RowVersion = Bytes(rowVersion) });
            if (meetingId == 0) TrySendMeetingEmail(id, testEmail);
            return id;
        }

        private static void TrySendMeetingEmail(long meetingId, string testEmail)
        {
            try
            {
                var ds = Repo.MeetingEmail(meetingId); if (ds.Tables[0].Rows.Count == 0) return; var m = ds.Tables[0].Rows[0];
                using (var mail = new MailMessage())
                {
                    if (!String.IsNullOrWhiteSpace(testEmail)) mail.To.Add(new MailAddress(testEmail.Trim())); else foreach (DataRow r in ds.Tables[1].Rows) mail.To.Add(new MailAddress(Convert.ToString(r["OfficialEmailID"])));
                    if (mail.To.Count == 0) return;
                    var actions = new StringBuilder(); foreach (DataRow a in ds.Tables[2].Rows) actions.Append("<tr><td>").Append(H(a["Description"])).Append("</td><td>").Append(H(a["AssignedTo"])).Append("</td><td>").Append(H(a["DueDateText"])).Append("</td><td>").Append(H(a["Status"])).Append("</td></tr>");
                    mail.From = new MailAddress("ack@infinity-data.com", "Team Meeting Notification", Encoding.UTF8); mail.Subject = "Team Meeting - " + Convert.ToString(m["TeamNames"]) + " - " + Convert.ToString(m["MeetingDateText"]); mail.IsBodyHtml = true;
                    mail.Body = "<table width='100%' style='background:#f3f6f9;padding:24px;font-family:Arial;color:#263746'><tr><td><table width='680' align='center' style='background:#fff;border:1px solid #dbe3ec'><tr><td style='padding:22px'><h2 style='color:#173955'>Team Meeting Summary</h2><p><b>Teams:</b> " + H(m["TeamNames"]) + "</p><p><b>Host:</b> " + H(m["HostNameSnapshot"]) + "</p><p><b>Type:</b> " + H(m["MeetingType"]) + "</p><p><b>Date &amp; Time:</b> " + H(m["MeetingDateText"]) + " " + H(m["MeetingTimeText"]) + "</p><p><b>Channel:</b> " + H(m["MeetingChannel"]) + "</p><hr/><p><b>Agenda</b><br/>" + H(m["Agenda"]) + "</p><p><b>Conclusion / Outcomes</b><br/>" + H(m["Conclusion"]) + "</p>" + (actions.Length == 0 ? "" : "<h3>Action Items</h3><table width='100%' cellpadding='6' border='1' style='border-collapse:collapse'><tr><th>Description</th><th>Assigned To</th><th>Due Date</th><th>Status</th></tr>" + actions + "</table>") + "</td></tr><tr><td style='background:#f7f9fb;padding:12px;font-size:11px;color:#738294'>This is a system-generated email. Please do not reply.</td></tr></table></td></tr></table>";
                    using (var client = new SmtpClient("smtp.office365.com", 587)) { client.Credentials = new NetworkCredential("ack@infinity-data.com", new bllSendMail().GetPassword("ackdata")); client.EnableSsl = true; ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12; client.Send(mail); }
                }
            }
            catch { }
        }
        private static string H(object value) { return HttpUtility.HtmlEncode(Convert.ToString(value)).Replace("\r\n", "<br/>").Replace("\n", "<br/>"); }
    }
}
