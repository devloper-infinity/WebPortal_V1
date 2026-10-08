using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class HRManpowerReport : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static string GetManpowerData()
        {
            DataTable table = new bllMaster().GetCurrentManpowerSummary("All") ?? new DataTable();
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow row in table.Rows)
            {
                var item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                    item[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
                rows.Add(item);
            }

            var serializer = new JavaScriptSerializer { MaxJsonLength = int.MaxValue };
            return serializer.Serialize(new { Rows = rows, GeneratedOn = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") });
        }

        [WebMethod]
        public static string GetMonthWiseManpower(string Year, int TillMonth)
        {
            int year;
            if (!int.TryParse(Year, out year)) year = DateTime.Now.Year;
            TillMonth = Math.Max(1, Math.Min(12, TillMonth));
            var result = new List<Dictionary<string, object>>();
            var master = new bllMaster();

            for (int month = 1; month <= TillMonth; month++)
            {
                string monthName = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(month);
                DataSet data = master.Getmanpower(monthName, year.ToString());
                if (data == null || data.Tables.Count == 0) continue;
                DataTable table = data.Tables[0];
                var locations = new Dictionary<string, int[]>(StringComparer.OrdinalIgnoreCase);

                foreach (DataRow row in table.Rows)
                {
                    string location = Read(row, "Branch", "BranchName", "Location");
                    if (string.IsNullOrEmpty(location)) location = "Unassigned";
                    if (!locations.ContainsKey(location)) locations[location] = new int[3];
                    string status = Read(row, "EmployeeStatus", "Status", "SubStatus").ToLowerInvariant();
                    locations[location][0]++;
                    if (status.Contains("leave")) locations[location][1]++;
                    if (status.Contains("resign") || status.Contains("left") || status.Contains("drop") || status.Contains("abscond")) locations[location][2]++;
                }

                foreach (var item in locations)
                {
                    result.Add(new Dictionary<string, object> {
                        { "Month", monthName }, { "MonthNumber", month }, { "Year", year }, { "Location", item.Key },
                        { "Total", item.Value[0] }, { "Leaves", item.Value[1] }, { "Dropout", item.Value[2] },
                        { "Attrition", item.Value[0] == 0 ? 0 : Math.Round(item.Value[2] * 100m / item.Value[0], 2) }
                    });
                }
            }

            return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(new { Rows = result });
        }

        private static string Read(DataRow row, params string[] names)
        {
            foreach (string name in names)
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value) return Convert.ToString(row[name]);
            return string.Empty;
        }
    }
}
