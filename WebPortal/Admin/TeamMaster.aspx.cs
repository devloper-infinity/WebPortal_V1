using System;
using System.Collections.Generic;
using System.Web.Services;

namespace WebPortal.Admin
{
    public partial class TeamMaster : TeamMeetingPageBase
    {
        protected void Page_Load(object sender, EventArgs e) { }
        [WebMethod(EnableSession = true)] public static string Bootstrap() { EnsureAuthorized(); return Json(Repo.Lookup(UserID)); }
        [WebMethod(EnableSession = true)] public static string List(bool includeInactive) { return Json(Repo.Teams(UserID, includeInactive)); }
        [WebMethod(EnableSession = true)] public static string Get(int teamId) { return Json(Repo.Team(UserID, teamId)); }
        [WebMethod(EnableSession = true)] public static int Save(int teamId, string teamName, int projectId, string description, int? managerEmployeeId, bool isActive, List<int> employeeIds)
        { if (String.IsNullOrWhiteSpace(teamName) || projectId <= 0) throw new Exception("Team name and project are required."); return Repo.SaveTeam(UserID, teamId, teamName.Trim(), projectId, description, managerEmployeeId, isActive, employeeIds); }
        private static void EnsureAuthorized() { var p = Repo.Permissions(UserID); if (p.Rows.Count == 0 || !Convert.ToBoolean(p.Rows[0]["CanManageTeams"])) throw new Exception("You are not authorized to manage teams."); }
    }
}
