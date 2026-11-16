using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code
{
    public sealed class TeamMeetingRepository
    {
        private SqlConnection Open() { var c = new SqlConnection(SQLHelper.ConnectionString); c.Open(); return c; }
        private static void Add(SqlCommand c, string n, SqlDbType t, object v) { var p = c.Parameters.Add(n, t); p.Value = v ?? DBNull.Value; }
        private static DataSet Set(SqlCommand c) { using (var a = new SqlDataAdapter(c)) { var d = new DataSet(); a.Fill(d); return d; } }
        private static DataTable Table(SqlCommand c) { using (var a = new SqlDataAdapter(c)) { var t = new DataTable(); a.Fill(t); return t; } }
        private static SqlCommand Procedure(SqlConnection cn, string name) { return new SqlCommand(name, cn) { CommandType = CommandType.StoredProcedure, CommandTimeout = 120 }; }

        public DataTable Permissions(int employeeId)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetPermissions")) { Add(c, "@EmployeeID", SqlDbType.Int, employeeId); return Table(c); }
        }

        public DataSet Lookup(int employeeId)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetLookup")) { Add(c, "@EmployeeID", SqlDbType.Int, employeeId); return Set(c); }
        }

        public DataTable Teams(int employeeId, bool includeInactive)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetTeams")) { Add(c, "@EmployeeID", SqlDbType.Int, employeeId); Add(c, "@IncludeInactive", SqlDbType.Bit, includeInactive); return Table(c); }
        }

        public DataSet Team(int employeeId, int teamId)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetTeam")) { Add(c, "@EmployeeID", SqlDbType.Int, employeeId); Add(c, "@TeamID", SqlDbType.Int, teamId); return Set(c); }
        }

        public int SaveTeam(int employeeId, int teamId, string teamName, int projectId, string description, int? managerId, bool active, IEnumerable<int> employees)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_SaveTeam"))
            {
                Add(c, "@EmployeeID", SqlDbType.Int, employeeId); Add(c, "@TeamID", SqlDbType.Int, teamId); Add(c, "@TeamName", SqlDbType.NVarChar, teamName);
                Add(c, "@ProjectID", SqlDbType.Int, projectId); Add(c, "@Description", SqlDbType.NVarChar, description); Add(c, "@ManagerEmployeeID", SqlDbType.Int, managerId);
                Add(c, "@IsActive", SqlDbType.Bit, active); var p = c.Parameters.Add("@Employees", SqlDbType.Structured); p.TypeName = "dbo.team_EmployeeList"; p.Value = EmployeeTable(employees);
                return Convert.ToInt32(c.ExecuteScalar());
            }
        }

        public DataSet AttendanceCandidates(int employeeId, IEnumerable<int> teams)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetAttendanceCandidates")) { Add(c, "@EmployeeID", SqlDbType.Int, employeeId); var p = c.Parameters.Add("@Teams", SqlDbType.Structured); p.TypeName = "dbo.team_IntList"; p.Value = IntTable(teams); return Set(c); }
        }

        public long SaveMeeting(int employeeId, MeetingInput v)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_SaveMeeting"))
            {
                Add(c, "@EmployeeID", SqlDbType.Int, employeeId); Add(c, "@MeetingID", SqlDbType.BigInt, v.MeetingID); Add(c, "@HostEmployeeID", SqlDbType.Int, v.HostEmployeeID);
                Add(c, "@MeetingType", SqlDbType.VarChar, v.MeetingType); Add(c, "@MeetingDate", SqlDbType.Date, v.MeetingDate); Add(c, "@MeetingTime", SqlDbType.Time, v.MeetingTime);
                Add(c, "@MeetingChannel", SqlDbType.VarChar, v.MeetingChannel); Add(c, "@OtherChannel", SqlDbType.NVarChar, v.OtherChannel); Add(c, "@Agenda", SqlDbType.NVarChar, v.Agenda);
                Add(c, "@Conclusion", SqlDbType.NVarChar, v.Conclusion); Add(c, "@RowVersion", SqlDbType.Binary, v.RowVersion);
                var teams = c.Parameters.Add("@Teams", SqlDbType.Structured); teams.TypeName = "dbo.team_IntList"; teams.Value = IntTable(v.TeamIDs);
                var attendance = c.Parameters.Add("@Attendance", SqlDbType.Structured); attendance.TypeName = "dbo.team_AttendanceList"; attendance.Value = AttendanceTable(v.Attendance);
                var actions = c.Parameters.Add("@Actions", SqlDbType.Structured); actions.TypeName = "dbo.team_ActionItemList"; actions.Value = ActionTable(v.ActionItems);
                return Convert.ToInt64(c.ExecuteScalar());
            }
        }

        public DataSet Meeting(int employeeId, long meetingId, bool edit)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetMeeting")) { Add(c, "@EmployeeID", SqlDbType.Int, employeeId); Add(c, "@MeetingID", SqlDbType.BigInt, meetingId); Add(c, "@ForEdit", SqlDbType.Bit, edit); return Set(c); }
        }

        public DataSet MeetingEmail(long meetingId)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetMeetingEmail")) { Add(c, "@MeetingID", SqlDbType.BigInt, meetingId); return Set(c); }
        }

        public DataTable Notifications(int employeeId)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetNotifications")) { Add(c, "@EmployeeID", SqlDbType.BigInt, employeeId); return Table(c); }
        }

        public void MarkNotificationRead(int employeeId, long notificationId)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_MarkNotificationRead")) { Add(c, "@EmployeeID", SqlDbType.BigInt, employeeId); Add(c, "@NotificationID", SqlDbType.BigInt, notificationId); c.ExecuteNonQuery(); }
        }

        public DataTable Report(int employeeId, DateTime? from, DateTime? to, string type, int hostId, int teamId)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetMeetingReport"))
            { Add(c, "@EmployeeID", SqlDbType.Int, employeeId); Add(c, "@FromDate", SqlDbType.Date, from); Add(c, "@ToDate", SqlDbType.Date, to); Add(c, "@MeetingType", SqlDbType.VarChar, type); Add(c, "@HostEmployeeID", SqlDbType.Int, hostId); Add(c, "@TeamID", SqlDbType.Int, teamId); return Table(c); }
        }

        public DataTable ActionItems(int employeeId, string status, int assignedTo)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetActionItems")) { Add(c, "@EmployeeID", SqlDbType.Int, employeeId); Add(c, "@Status", SqlDbType.VarChar, status); Add(c, "@AssignedTo", SqlDbType.Int, assignedTo); return Table(c); }
        }

        public void UpdateAction(int employeeId, long actionItemId, string status, string remarks, byte[] rowVersion)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_UpdateActionItem")) { Add(c, "@EmployeeID", SqlDbType.Int, employeeId); Add(c, "@ActionItemID", SqlDbType.BigInt, actionItemId); Add(c, "@Status", SqlDbType.VarChar, status); Add(c, "@Remarks", SqlDbType.NVarChar, remarks); Add(c, "@RowVersion", SqlDbType.Binary, rowVersion); c.ExecuteNonQuery(); }
        }

        public DataTable ActionHistory(int employeeId, long actionItemId)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetActionHistory")) { Add(c, "@EmployeeID", SqlDbType.BigInt, employeeId); Add(c, "@ActionItemID", SqlDbType.BigInt, actionItemId); return Table(c); }
        }

        public DataSet ActionUpdateEmail(long actionItemId)
        {
            using (var cn = Open()) using (var c = Procedure(cn, "team_GetActionUpdateEmail")) { Add(c, "@ActionItemID", SqlDbType.BigInt, actionItemId); return Set(c); }
        }

        private static DataTable IntTable(IEnumerable<int> values) { var t = new DataTable(); t.Columns.Add("ID", typeof(int)); if (values != null) foreach (var x in values) t.Rows.Add(x); return t; }
        private static DataTable EmployeeTable(IEnumerable<int> values) { var t = new DataTable(); t.Columns.Add("ID", typeof(long)); if (values != null) foreach (var x in values) t.Rows.Add(Convert.ToInt64(x)); return t; }
        private static DataTable AttendanceTable(IEnumerable<AttendanceInput> values) { var t = new DataTable(); t.Columns.Add("EmployeeID", typeof(long)); t.Columns.Add("AttendanceStatus", typeof(string)); if (values != null) foreach (var x in values) t.Rows.Add(Convert.ToInt64(x.EmployeeID), x.Status); return t; }
        private static DataTable ActionTable(IEnumerable<ActionInput> values) { var t = new DataTable(); t.Columns.Add("ActionItemID", typeof(long)); t.Columns.Add("Description", typeof(string)); t.Columns.Add("AssignedTo", typeof(long)); t.Columns.Add("DueDate", typeof(DateTime)); t.Columns.Add("Status", typeof(string)); t.Columns.Add("Remarks", typeof(string)); if (values != null) foreach (var x in values) t.Rows.Add(x.ActionItemID, x.Description, Convert.ToInt64(x.AssignedTo), x.DueDate.HasValue ? (object)x.DueDate.Value : DBNull.Value, x.Status, x.Remarks); return t; }
    }

    public sealed class MeetingInput { public long MeetingID { get; set; } public int HostEmployeeID { get; set; } public string MeetingType { get; set; } public DateTime MeetingDate { get; set; } public TimeSpan MeetingTime { get; set; } public string MeetingChannel { get; set; } public string OtherChannel { get; set; } public string Agenda { get; set; } public string Conclusion { get; set; } public byte[] RowVersion { get; set; } public List<int> TeamIDs { get; set; } public List<AttendanceInput> Attendance { get; set; } public List<ActionInput> ActionItems { get; set; } }
    public sealed class AttendanceInput { public int EmployeeID { get; set; } public string Status { get; set; } }
    public sealed class ActionInput { public long ActionItemID { get; set; } public string Description { get; set; } public int AssignedTo { get; set; } public DateTime? DueDate { get; set; } public string Status { get; set; } public string Remarks { get; set; } }
}
