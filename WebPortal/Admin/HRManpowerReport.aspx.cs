using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class HRManpowerReport : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static string GetManpowerData()
        {
            DataTable table = new bllMaster().GetCurrentManpowerSummary("All") ?? new DataTable();
            bllMaster master = new bllMaster();
            DataSet detailData = master.Getmanpower(
                CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(DateTime.Now.Month), DateTime.Now.Year.ToString());
            DataTable detailTable = detailData != null && detailData.Tables.Count > 0 ? detailData.Tables[0] : new DataTable();
            DataTable employees = master.GetAllEmployeeDetails() ?? new DataTable();
            DataTable employeeInfo = new DataTable();
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter("SELECT * FROM dbo.EmployeeInfo", connection))
                adapter.Fill(employeeInfo);

            var serializer = new JavaScriptSerializer { MaxJsonLength = int.MaxValue };
            return serializer.Serialize(new { Rows = ToRows(table), Details = MergeEmployeeRows(employeeInfo, employees, detailTable), GeneratedOn = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") });
        }

        [WebMethod]
        public static string GetMonthWiseManpower(string Year, int TillMonth)
        {
            int year;
            if (!int.TryParse(Year, out year)) year = DateTime.Now.Year;
            TillMonth = Math.Max(1, Math.Min(12, TillMonth));
            var result = new List<Dictionary<string, object>>();
            var master = new bllMaster();
            Dictionary<string, string> jobTypes = LoadJobTypes();

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
                    if (!locations.ContainsKey(location)) locations[location] = new int[5];
                    string status = Read(row, "EmployeeStatus", "Status", "SubStatus").ToLowerInvariant();
                    locations[location][0]++;
                    if (status.Contains("leave")) locations[location][1]++;
                    if (status.Contains("resign") || status.Contains("left") || status.Contains("drop") || status.Contains("abscond")) locations[location][2]++;
                    string mode = Read(row, "JobType", "WorkMode", "WorkingMode", "WorkLocation", "AttendanceMode", "WorkType").ToLowerInvariant();
                    string employeeKey = Read(row, "EmployeeID", "Code", "EmpCode", "EmployeeCode");
                    if (String.IsNullOrWhiteSpace(mode) && !String.IsNullOrWhiteSpace(employeeKey)) jobTypes.TryGetValue(employeeKey, out mode);
                    if (mode.Contains("home") || mode == "wfh") locations[location][3]++;
                    if (mode.Contains("office") || mode == "wfo") locations[location][4]++;
                }

                foreach (var item in locations)
                {
                    result.Add(new Dictionary<string, object> {
                        { "Month", monthName }, { "MonthNumber", month }, { "Year", year }, { "Location", item.Key },
                        { "Total", item.Value[0] }, { "Leaves", item.Value[1] }, { "Dropout", item.Value[2] },
                        { "WorkFromHome", item.Value[3] }, { "WorkFromOffice", item.Value[4] },
                        { "Attrition", item.Value[0] == 0 ? 0 : Math.Round(item.Value[2] * 100m / item.Value[0], 2) }
                    });
                }
            }

            return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(new { Rows = result });
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow row in table.Rows)
            {
                var item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                    item[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
                rows.Add(item);
            }
            return rows;
        }

        private static List<Dictionary<string, object>> MergeEmployeeRows(params DataTable[] tables)
        {
            var merged = new Dictionary<string, Dictionary<string, object>>(StringComparer.OrdinalIgnoreCase);
            int fallback = 0;
            foreach (DataTable table in tables)
                foreach (DataRow row in table.Rows)
                {
                    string key = Read(row, "EmployeeID", "Code", "EmpCode", "EmployeeCode");
                    if (String.IsNullOrWhiteSpace(key)) key = "row-" + (++fallback);
                    Dictionary<string, object> item;
                    if (!merged.TryGetValue(key, out item)) merged[key] = item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                    foreach (DataColumn column in table.Columns)
                        if (row[column] != DBNull.Value && !String.IsNullOrWhiteSpace(Convert.ToString(row[column]))) item[column.ColumnName] = row[column];
                }
            return new List<Dictionary<string, object>>(merged.Values);
        }

        private static Dictionary<string, string> LoadJobTypes()
        {
            var result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand("SELECT EmployeeID, Code, JobType FROM dbo.EmployeeInfo", connection))
            {
                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                    while (reader.Read())
                    {
                        string jobType = Convert.ToString(reader["JobType"]).ToLowerInvariant();
                        string id = Convert.ToString(reader["EmployeeID"]), code = Convert.ToString(reader["Code"]);
                        if (!String.IsNullOrWhiteSpace(id)) result[id] = jobType;
                        if (!String.IsNullOrWhiteSpace(code)) result[code] = jobType;
                    }
            }
            return result;
        }

        private static string Read(DataRow row, params string[] names)
        {
            foreach (string name in names)
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value) return Convert.ToString(row[name]);
            return string.Empty;
        }
    }
}
