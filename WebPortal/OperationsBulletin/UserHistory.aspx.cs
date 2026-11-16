using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;

namespace WebPortal.OperationsBulletin
{
    public partial class UserHistory : Page
    {
        protected void Page_Load(object sender, EventArgs e) { if (!new BulletinRepository().HasAssignedBulletins(BulletinSecurity.EmployeeID)) Server.Transfer("~/OperationsBulletin/AccessDenied.aspx"); }
        [WebMethod] public static string GetHistory() { return Json(new BulletinRepository().AssignedBulletins(BulletinSecurity.EmployeeID)); }
        private static string Json(DataTable table) { var rows = new List<Dictionary<string, object>>(); foreach (DataRow row in table.Rows) { var item = new Dictionary<string, object>(); foreach (DataColumn column in table.Columns) item[column.ColumnName] = row[column] == DBNull.Value ? null : row[column]; rows.Add(item); } return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(rows); }
    }
}
