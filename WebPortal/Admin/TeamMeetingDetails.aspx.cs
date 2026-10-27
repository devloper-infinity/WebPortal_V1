using System;
using System.Web.Services;

namespace WebPortal.Admin
{
    public partial class TeamMeetingDetails : TeamMeetingPageBase
    {
        protected void Page_Load(object sender, EventArgs e) { }
        [WebMethod(EnableSession = true)] public static string Get(long meetingId) { if (meetingId <= 0) throw new Exception("Invalid meeting."); return Json(Repo.Meeting(UserID, meetingId, false)); }
    }
}
