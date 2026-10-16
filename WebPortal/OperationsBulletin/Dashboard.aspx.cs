using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Security;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.Class;

namespace WebPortal.OperationsBulletin
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HasOperationsAccess()) Server.Transfer("~/OperationsBulletin/AccessDenied.aspx");
        }
        private static bool HasOperationsAccess()
        {
            try
            {
                EmployeeInfo employee = EmployeeInfo.Current;
                return employee != null;
            }
            catch { return false; }
        }
        private static void EnsureOperations()
        {
            int id = BulletinSecurity.EmployeeID;
            if (!HasOperationsAccess()) throw new UnauthorizedAccessException("You do not have access to the Operations Bulletin & Document Center.");
        }
        [WebMethod] public static string GetBootstrap() { EnsureOperations(); return Json(new BulletinRepository().Bootstrap(BulletinSecurity.EmployeeID)); }
        [WebMethod] public static string GetBulletins(string from, string to, int? domainId, int? locationId, int? projectId, string category, string status) { EnsureOperations(); return Json(new BulletinRepository().Bulletins(BulletinSecurity.EmployeeID, Date(from), Date(to), domainId, locationId, projectId, category, status)); }
        [WebMethod] public static string GetFolder(long? parentFolderId) { EnsureOperations(); return Json(new BulletinRepository().Folder(BulletinSecurity.EmployeeID, parentFolderId)); }
        [WebMethod] public static long SaveFolder(string action, long? folderId, long? parentFolderId, long? destinationFolderId, string folderName) { EnsureOperations(); return new BulletinRepository().FolderSave(action, folderId, parentFolderId, destinationFolderId, folderName, BulletinSecurity.EmployeeID, HttpContext.Current.Request.UserHostAddress); }
        [WebMethod] public static void SaveRights(long folderId, int employeeId, bool? canView, bool? canUpload, bool? canCreateFolder, bool? canRenameFolder, bool? canMoveFolder, bool? canDeleteFolder, bool? canManagePermissions, bool inherit) { EnsureOperations(); new BulletinRepository().SaveRights(folderId, employeeId, canView, canUpload, canCreateFolder, canRenameFolder, canMoveFolder, canDeleteFolder, canManagePermissions, inherit, BulletinSecurity.EmployeeID); }
        [WebMethod] public static long SaveBulletin(long bulletinId, long? folderId, string title, string category, string priority, string summary, string scheduleDate, bool requireAcknowledgement, string audienceJson) { EnsureOperations(); return new BulletinRepository().SaveBulletin(bulletinId, folderId, title, category, priority, summary, Date(scheduleDate), requireAcknowledgement, audienceJson, BulletinSecurity.EmployeeID); }
        [WebMethod] public static void PublishBulletin(long bulletinId, string action) { EnsureOperations(); new BulletinRepository().Publish(bulletinId, action, BulletinSecurity.EmployeeID); }
        [WebMethod] public static void Track(long bulletinId, string action, long? documentVersionId) { EnsureOperations(); new BulletinRepository().Track(bulletinId, BulletinSecurity.EmployeeID, action, documentVersionId); }
        [WebMethod] public static string GetReport(string from, string to, int? domainId, int? locationId, int? projectId, int? employeeId) { EnsureOperations(); return Json(new BulletinRepository().Report(BulletinSecurity.EmployeeID, Date(from), Date(to), domainId, locationId, projectId, employeeId)); }
        private static DateTime? Date(string value) { DateTime d; return DateTime.TryParseExact(value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out d) ? d : (DateTime?)null; }
        private static string Json(DataTable t) { var rows = new List<Dictionary<string, object>>(); foreach (DataRow r in t.Rows) { var x = new Dictionary<string, object>(); foreach (DataColumn c in t.Columns) x[c.ColumnName] = r[c] == DBNull.Value ? null : r[c]; rows.Add(x); } return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(rows); }
        private static string Json(DataSet d) { var tables = new List<object>(); foreach (DataTable t in d.Tables) tables.Add(new JavaScriptSerializer().DeserializeObject(Json(t))); return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(tables); }
    }
}
