using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;

namespace WebPortal.App_Code.Class
{
    public static class HelpdeskJson
    {
        public static string Serialize(DataTable table)
        {
            return Serializer().Serialize(ToRows(table));
        }

        public static string Serialize(DataSet dataSet)
        {
            List<object> tables = new List<object>();
            if (dataSet != null)
            {
                foreach (DataTable table in dataSet.Tables) tables.Add(ToRows(table));
            }
            return Serializer().Serialize(tables);
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                    row[column.ColumnName] = dataRow[column] == System.DBNull.Value ? null : dataRow[column];
                rows.Add(row);
            }
            return rows;
        }

        private static JavaScriptSerializer Serializer()
        {
            return new JavaScriptSerializer { MaxJsonLength = int.MaxValue };
        }
    }
}
