using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;

namespace WebPortal.App_Code
{
    internal static class OLTrackingWeb
    {
        internal static int UserId
        {
            get
            {
                int id;
                if (HttpContext.Current == null || HttpContext.Current.User == null ||
                    !int.TryParse(HttpContext.Current.User.Identity.Name, out id) || id <= 0)
                    throw new UnauthorizedAccessException("Your login session is invalid. Please sign in again.");
                return id;
            }
        }

        internal static string Json(DataTable table) { return Serialize(TableRows(table)); }

        internal static string Json(DataSet set)
        {
            Dictionary<string, object> result = new Dictionary<string, object>();
            for (int i = 0; i < set.Tables.Count; i++) result["table" + i] = TableRows(set.Tables[i]);
            return Serialize(result);
        }

        internal static string Ok(object data)
        {
            return Serialize(new Dictionary<string, object> { { "ok", true }, { "data", data } });
        }

        private static List<Dictionary<string, object>> TableRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (DataRow row in table.Rows)
            {
                Dictionary<string, object> item = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                    item[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
                rows.Add(item);
            }
            return rows;
        }

        private static string Serialize(object value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(value);
        }
    }
}
