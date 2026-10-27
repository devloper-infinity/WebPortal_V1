using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using WebPortal.App_Code;

namespace WebPortal.Admin
{
    public abstract class TeamMeetingPageBase : Page
    {
        protected static int UserID { get { int id; if (!int.TryParse(HttpContext.Current.User.Identity.Name, out id) || id <= 0) throw new HttpException(401, "Authentication is required."); return id; } }
        protected static string Json(DataTable t) { var rows = new List<Dictionary<string, object>>(); foreach (DataRow r in t.Rows) { var x = new Dictionary<string, object>(); foreach (DataColumn c in t.Columns) x[c.ColumnName] = r[c] == DBNull.Value ? null : r[c]; rows.Add(x); } return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(rows); }
        protected static string Json(DataSet s) { var x = new Dictionary<string, object>(); for (var i = 0; i < s.Tables.Count; i++) x["Table" + i] = new JavaScriptSerializer().DeserializeObject(Json(s.Tables[i])); return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(x); }
        protected static DateTime? Date(string value) { DateTime v; return DateTime.TryParseExact(value ?? "", "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out v) ? v : (DateTime?)null; }
        protected static byte[] Bytes(string value) { return String.IsNullOrWhiteSpace(value) ? null : Convert.FromBase64String(value); }
        protected static TeamMeetingRepository Repo { get { return new TeamMeetingRepository(); } }
    }
}
