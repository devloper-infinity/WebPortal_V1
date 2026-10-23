using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Security;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

namespace WebPortal.OperationsBulletin
{
    internal static class BulletinSecurity
    {
        internal static int EmployeeID
        {
            get { int id; if (HttpContext.Current.User == null || !HttpContext.Current.User.Identity.IsAuthenticated || !int.TryParse(HttpContext.Current.User.Identity.Name, out id)) throw new SecurityException("Authentication required."); return id; }
        }
        internal static string StorageRoot
        {
            get { string configured = ConfigurationManager.AppSettings["OperationsBulletinStoragePath"]; string root = string.IsNullOrWhiteSpace(configured) ? HttpContext.Current.Server.MapPath("~/App_Data/OperationsBulletin") : configured; Directory.CreateDirectory(root); return Path.GetFullPath(root); }
        }
        internal static string SafePath(string stored)
        {
            if (string.IsNullOrWhiteSpace(stored) || stored.IndexOfAny(Path.GetInvalidFileNameChars()) >= 0 || stored != Path.GetFileName(stored)) throw new SecurityException("Invalid file reference.");
            string path = Path.GetFullPath(Path.Combine(StorageRoot, stored)); if (!path.StartsWith(StorageRoot, StringComparison.OrdinalIgnoreCase)) throw new SecurityException("Invalid file path."); return path;
        }
    }

    internal sealed class BulletinRepository
    {
        private SqlConnection Open() { var c = new SqlConnection(ConfigurationManager.ConnectionStrings["MainCon"].ConnectionString); c.Open(); return c; }
        private static void Add(SqlCommand c, string n, object v) { c.Parameters.AddWithValue(n, v ?? DBNull.Value); }
        private DataSet Set(string procedure, params SqlParameter[] parameters) { using (var c = Open()) using (var cmd = new SqlCommand(procedure, c)) using (var a = new SqlDataAdapter(cmd)) { cmd.CommandType = CommandType.StoredProcedure; cmd.Parameters.AddRange(parameters); var d = new DataSet(); a.Fill(d); return d; } }
        private DataTable Table(string procedure, params SqlParameter[] parameters) { DataSet d = Set(procedure, parameters); return d.Tables.Count == 0 ? new DataTable() : d.Tables[0]; }
        private static SqlParameter P(string n, object v) { return new SqlParameter(n, v ?? DBNull.Value); }

        internal DataSet Bootstrap(int user) { return Set("dbo.usp_Bulletin_Bootstrap", P("@EmployeeID", user)); }
        internal DataSet TeamSetup(int user) { return Set("dbo.usp_Bulletin_TeamSetup", P("@EmployeeID", user)); }
        internal DataTable ProjectUsers(int project, int? location) { return Table("dbo.usp_Bulletin_ProjectUsers", P("@ProjectID", project), P("@LocationID", location)); }
        internal int SaveTeam(string action, int id, string name, int? domain, int? subdomain, int? location, int? project, IEnumerable<int> members, int user) { var xml = new StringBuilder("<members>"); foreach (int member in members ?? Enumerable.Empty<int>()) xml.Append("<id>").Append(member).Append("</id>"); xml.Append("</members>"); DataTable t = Table("dbo.usp_Bulletin_TeamSave", P("@Action", action), P("@TeamID", id), P("@TeamName", name), P("@DomainID", domain), P("@SubDomainID", subdomain), P("@LocationID", location), P("@ProjectID", project), P("@MembersXml", xml.ToString()), P("@EmployeeID", user)); return t.Rows.Count == 0 ? id : Convert.ToInt32(t.Rows[0][0]); }
        internal DataTable Bulletins(int user, DateTime? from, DateTime? to, int? domain, int? location, int? project, string category, string status) { Table("dbo.usp_Bulletin_PublishDue"); return Table("dbo.usp_Bulletin_List", P("@EmployeeID", user), P("@From", from), P("@To", to), P("@DomainID", domain), P("@LocationID", location), P("@ProjectID", project), P("@Category", Empty(category)), P("@Status", Empty(status))); }
        internal DataTable AssignedBulletins(int user) { DataTable source = Bulletins(user, null, null, null, null, null, null, null), result = source.Clone(); foreach (DataRow row in source.Rows) if (Convert.ToBoolean(row["IsTargeted"])) result.ImportRow(row); return result; }
        internal bool HasAssignedBulletins(int user) { using (var c = Open()) using (var cmd = new SqlCommand("SELECT CASE WHEN EXISTS(SELECT 1 FROM dbo.BulletinUserTracking WHERE EmployeeID=@E) THEN 1 ELSE 0 END", c)) { Add(cmd, "@E", user); return Convert.ToBoolean(cmd.ExecuteScalar()); } }
        internal DataSet Folder(int user, long? parent) { return Set("dbo.usp_Bulletin_FolderList", P("@EmployeeID", user), P("@ParentFolderID", parent)); }
        internal long FolderSave(string action, long? id, long? parent, long? destination, string name, int user, string ip) { DataTable t = Table("dbo.usp_Bulletin_FolderSave", P("@Action", action), P("@FolderID", id), P("@ParentFolderID", parent), P("@DestinationFolderID", destination), P("@FolderName", Empty(name)), P("@EmployeeID", user), P("@IPAddress", ip)); return Convert.ToInt64(t.Rows[0][0]); }
        internal void SaveRights(long folder, int target, bool? view, bool? upload, bool? create, bool? rename, bool? move, bool? delete, bool? manage, bool inherit, int user) { Table("dbo.usp_Bulletin_RightsSave", P("@FolderID", folder), P("@TargetEmployeeID", target), P("@CanView", view), P("@CanUpload", upload), P("@CanCreateFolder", create), P("@CanRenameFolder", rename), P("@CanMoveFolder", move), P("@CanDeleteFolder", delete), P("@CanManagePermissions", manage), P("@Inherit", inherit), P("@EmployeeID", user)); }
        internal void Track(long bulletin, int user, string action, long? version) { Table("dbo.usp_Bulletin_Track", P("@BulletinID", bulletin), P("@EmployeeID", user), P("@Action", action), P("@DocumentVersionID", version)); }
        internal DataSet Report(int user, DateTime? from, DateTime? to, int? domain, int? location, int? project, int? employee) { return Set("dbo.usp_Bulletin_Report", P("@EmployeeID", user), P("@From", from), P("@To", to), P("@DomainID", domain), P("@LocationID", location), P("@ProjectID", project), P("@TargetEmployeeID", employee)); }
        internal long SaveBulletin(long id, long? folder, string title, string category, string priority, string summary, DateTime? schedule, bool ack, string audienceJson, int user) { AudiencePayload a = new JavaScriptSerializer().Deserialize<AudiencePayload>(audienceJson) ?? new AudiencePayload(); if (a.type == "Team") { var teams = new StringBuilder("<teams>"); foreach (string value in a.values ?? new List<string>()) teams.Append("<id>").Append(System.Security.SecurityElement.Escape(value)).Append("</id>"); teams.Append("</teams>"); DataTable members = Table("dbo.usp_Bulletin_TeamEmployees", P("@TeamIDsXml", teams.ToString())); a.type = "Employee"; a.values = members.AsEnumerable().Select(r => Convert.ToString(r["EmployeeID"])).ToList(); } var xml = new StringBuilder("<audience type=\"").Append(System.Security.SecurityElement.Escape(a.type ?? "")).Append("\">"); foreach (string value in a.values ?? new List<string>()) xml.Append("<value>").Append(System.Security.SecurityElement.Escape(value)).Append("</value>"); xml.Append("</audience>"); DataTable t = Table("dbo.usp_Bulletin_Save", P("@BulletinID", id), P("@FolderID", folder), P("@Title", title), P("@Category", category), P("@Priority", priority), P("@Summary", summary), P("@ScheduleDate", schedule), P("@RequireAcknowledgement", ack), P("@AudienceXml", xml.ToString()), P("@EmployeeID", user)); return Convert.ToInt64(t.Rows[0][0]); }
        internal void Publish(long id, string action, int user) { Table("dbo.usp_Bulletin_Publish", P("@BulletinID", id), P("@Action", action), P("@EmployeeID", user)); }
        internal void DiscardDraft(long id, int user) { Table("dbo.usp_Bulletin_DiscardDraft", P("@BulletinID", id), P("@EmployeeID", user)); }

        internal DataRow AuthorizedVersion(long version, int user)
        {
            using (var c = Open()) using (var cmd = new SqlCommand(@"SELECT TOP(1)v.*,d.BulletinID,d.FolderID FROM dbo.BulletinDocumentVersions v JOIN dbo.BulletinDocuments d ON d.DocumentID=v.DocumentID OUTER APPLY dbo.ufn_BulletinFolderRights(d.FolderID,@E)r WHERE v.DocumentVersionID=@V AND v.IsDeleted=0 AND d.IsDeleted=0 AND ((d.BulletinID IS NULL AND r.CanView=1) OR EXISTS(SELECT 1 FROM dbo.BulletinUserTracking t WHERE t.BulletinID=d.BulletinID AND t.EmployeeID=@E) OR EXISTS(SELECT 1 FROM dbo.BulletinMaster b WHERE b.BulletinID=d.BulletinID AND b.CreatedBy=@E AND b.IsDeleted=0))", c))
            { Add(cmd, "@E", user); Add(cmd, "@V", version); using (var a = new SqlDataAdapter(cmd)) { var t = new DataTable(); a.Fill(t); if (t.Rows.Count == 0) throw new SecurityException("Document access denied."); return t.Rows[0]; } }
        }

        internal long SaveUpload(long folder, long? bulletin, long? document, string original, string stored, string pdfStored, string contentType, long size, string hash, int user)
        {
            DataTable t = Table("dbo.usp_Bulletin_DocumentSave", P("@FolderID", folder), P("@BulletinID", bulletin), P("@DocumentID", document), P("@OriginalFileName", original), P("@StoredFileName", stored), P("@PdfStoredFileName", Empty(pdfStored)), P("@ContentType", contentType), P("@FileSize", size), P("@Sha256", hash), P("@EmployeeID", user)); return Convert.ToInt64(t.Rows[0][0]);
        }
        internal static string Hash(string path) { using (var sha = SHA256.Create()) using (var s = File.OpenRead(path)) return BitConverter.ToString(sha.ComputeHash(s)).Replace("-", ""); }
        private static object Empty(string value) { return string.IsNullOrWhiteSpace(value) ? (object)DBNull.Value : value.Trim(); }
        private sealed class AudiencePayload { public string type { get; set; } public List<string> values { get; set; } }
    }
}
