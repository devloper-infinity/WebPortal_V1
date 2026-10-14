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
            DataTable table = new bllMaster()
                .GetCurrentManpowerSummary("All") ?? new DataTable();

            DataTable employees = new DataTable();

            // Salary cycle: 26th previous month to 25th current month
            DateTime today = DateTime.Today;

            DateTime fromDate = new DateTime(
                today.Year, today.Month, 1).AddMonths(-1).AddDays(25);

            DateTime toDate = new DateTime(
                today.Year, today.Month, 25);

            using (SqlConnection connection =
                new SqlConnection(SQLHelper.ConnectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter(@"
        SELECT
            e.*,
            v.Name AS FullName,
            v.Branch AS BranchName,
            d.DepartmentName,
            dm.DomainName,
            ds.DesignationName,
            v.ReportingManager,
            dh.FirstName + ' ' + dh.LastName AS DomainHeadName,
            lh.FirstName + ' ' + lh.LastName AS LocationHeadName,
            v.ResignationDate,
            v.LastWorkingDate,
            v.Remark AS ExitRemark,
            ISNULL(ul.ApprovedLeaves, 0) AS ApprovedLeaves
        FROM dbo.EmployeeInfo e
        LEFT JOIN dbo.vw_GetEmployeeAllInfo v
            ON v.EmployeeID = e.EmployeeID
        LEFT JOIN dbo.Department d
            ON d.DepartmentID = e.Department
        LEFT JOIN dbo.Domain dm
            ON dm.DomainID = e.Domain
        LEFT JOIN dbo.Designation ds
            ON ds.DesignationID = e.Designation
        LEFT JOIN dbo.EmployeeInfo dh
            ON dh.EmployeeID = e.DomainHead
        LEFT JOIN dbo.EmployeeInfo lh
            ON lh.EmployeeID = e.LocationHead
        LEFT JOIN
        (
            SELECT
                Code,
                SUM(ForDays) AS ApprovedLeaves
            FROM dbo.UserLeaves
            WHERE IsApproved = 1
              AND cast(LeaveFrom as date) >= @FromDate
              AND cast(LeaveFrom as date) < DATEADD(DAY, 1, @ToDate)
            GROUP BY Code
        ) ul ON ul.Code = e.Code
        WHERE e.JobType IN ('Work From Home', 'Work From Office')
    ", connection))
            {
                adapter.SelectCommand.Parameters.Add(
                    "@FromDate", SqlDbType.Date).Value = fromDate;

                adapter.SelectCommand.Parameters.Add(
                    "@ToDate", SqlDbType.Date).Value = toDate;

                adapter.Fill(employees);
            }

            var serializer = new JavaScriptSerializer
            {
                MaxJsonLength = int.MaxValue
            };

            return serializer.Serialize(new
            {
                Rows = ToRows(table),
                Details = ToRows(employees),
                GeneratedOn = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt")
            });
        }

        [WebMethod]
        public static string GetDomainWiseManpower()
        {
            DateTime today = DateTime.Today;
            DateTime fromDate = new DateTime(today.Year, today.Month, 1).AddMonths(-1).AddDays(25);
            DateTime toDate = new DateTime(today.Year, today.Month, 25);
            DataTable table = new DataTable();
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter(@"
                SELECT ISNULL(b.BranchName,'Unassigned') Location,
                       ISNULL(d.DomainName,'Unassigned') Domain,
                       SUM(CASE WHEN ISNULL(e.IsDelete,0)=0 AND v.ResignationDate IS NULL AND e.JobType='Work From Home' THEN 1 ELSE 0 END) WFH,
                       SUM(CASE WHEN ISNULL(e.IsDelete,0)=0 AND v.ResignationDate IS NULL AND e.JobType='Work From Office' THEN 1 ELSE 0 END) WFO,
                       SUM(CASE WHEN ISNULL(e.IsDelete,0)=0 AND v.ResignationDate IS NULL THEN ISNULL(l.LeaveDays,0) ELSE 0 END) Leaves,
                       SUM(CASE WHEN (ISNULL(e.IsDelete,0)=1 OR v.ResignationDate IS NOT NULL) AND ISNULL(v.ResignationType,'') LIKE '%Abscond%' THEN 1 ELSE 0 END) Absconded,
                       SUM(CASE WHEN (ISNULL(e.IsDelete,0)=1 OR v.ResignationDate IS NOT NULL) AND ISNULL(v.ResignationType,'') NOT LIKE '%Abscond%' THEN 1 ELSE 0 END) Exited
                FROM dbo.EmployeeInfo e
                LEFT JOIN dbo.Branch b ON b.BranchID=e.WorkingBranch
                LEFT JOIN dbo.Domain d ON d.DomainID=e.Domain
                LEFT JOIN dbo.vw_GetEmployeeAllInfo v ON v.EmployeeID=e.EmployeeID
                LEFT JOIN (SELECT Code,SUM(ForDays) LeaveDays FROM dbo.UserLeaves
                           WHERE IsApproved=1 AND CAST(LeaveFrom AS date)>=@FromDate AND CAST(LeaveFrom AS date)<DATEADD(day,1,@ToDate)
                           GROUP BY Code) l ON l.Code=e.Code
                WHERE e.JobType IN ('Work From Home','Work From Office')
                GROUP BY ISNULL(b.BranchName,'Unassigned'),ISNULL(d.DomainName,'Unassigned')", connection))
            {
                adapter.SelectCommand.Parameters.Add("@FromDate", SqlDbType.Date).Value = fromDate;
                adapter.SelectCommand.Parameters.Add("@ToDate", SqlDbType.Date).Value = toDate;
                adapter.Fill(table);
            }
            return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(new { Rows = ToRows(table) });
        }

        [WebMethod]
        public static string GetManpowerData_OLD()
        {
            DataTable table = new bllMaster().GetCurrentManpowerSummary("All") ?? new DataTable();
            DataTable employees = new DataTable();
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter(@"
                SELECT e.*, v.Name AS FullName, v.Branch AS BranchName,
                       d.DepartmentName, dm.DomainName, ds.DesignationName,
                       v.ReportingManager, dh.FirstName+' '+dh.LastName AS DomainHeadName,
                       lh.FirstName+' '+lh.LastName AS LocationHeadName,
                       v.ResignationDate, v.LastWorkingDate, v.Remark AS ExitRemark,
                       ISNULL(ul.ApprovedLeaves,0) AS ApprovedLeaves
                FROM dbo.EmployeeInfo e
                LEFT JOIN dbo.vw_GetEmployeeAllInfo v ON v.EmployeeID=e.EmployeeID
                LEFT JOIN dbo.Department d ON d.DepartmentID=e.Department
                LEFT JOIN dbo.Domain dm ON dm.DomainID=e.Domain
                LEFT JOIN dbo.Designation ds ON ds.DesignationID=e.Designation
                LEFT JOIN dbo.EmployeeInfo dh ON dh.EmployeeID=e.DomainHead
                LEFT JOIN dbo.EmployeeInfo lh ON lh.EmployeeID=e.LocationHead
                LEFT JOIN (SELECT Code,SUM(ForDays) ApprovedLeaves FROM dbo.UserLeaves
                           WHERE IsApproved=1 AND YEAR(ApprovedDate)=YEAR(GETDATE()) AND MONTH(ApprovedDate)=MONTH(GETDATE())
                           GROUP BY Code) ul ON ul.Code=e.Code
                WHERE e.JobType IN ('Work From Home','Work From Office')", connection))
                adapter.Fill(employees);

            var serializer = new JavaScriptSerializer { MaxJsonLength = int.MaxValue };
            return serializer.Serialize(new { Rows = ToRows(table), Details = ToRows(employees), GeneratedOn = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") });
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
                Dictionary<string, int> approvedLeaves = LoadApprovedLeaves(year, month);
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
                    string code = Read(row, "Code", "EmpCode", "EmployeeCode");
                    int leaveDays;
                    if (!String.IsNullOrWhiteSpace(code) && approvedLeaves.TryGetValue(code, out leaveDays)) locations[location][1] += leaveDays;
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
                    string key = Read(row, "Code", "EmpCode", "EmployeeCode", "EmployeeID");
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

        //private static Dictionary<string, int> LoadApprovedLeaves(int year, int month)
        //{
        //    var result = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        //    using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
        //    using (SqlCommand command = new SqlCommand(@"SELECT Code,SUM(ForDays) LeaveDays FROM dbo.UserLeaves
        //        WHERE IsApproved=1 AND YEAR(ApprovedDate)=@Year AND MONTH(ApprovedDate)=@Month GROUP BY Code", connection))
        //    {
        //        command.Parameters.Add("@Year", SqlDbType.Int).Value = year;
        //        command.Parameters.Add("@Month", SqlDbType.Int).Value = month;
        //        connection.Open();
        //        using (SqlDataReader reader = command.ExecuteReader())
        //            while (reader.Read()) result[Convert.ToString(reader["Code"])] = Convert.ToInt32(reader["LeaveDays"]);
        //    }
        //    return result;
        //}
        private static Dictionary<string, int> LoadApprovedLeaves(int year, int month)
        {
            var result = new Dictionary<string, int>(
                StringComparer.OrdinalIgnoreCase);

            // Salary cycle: 26th previous month to 25th selected month
            DateTime fromDate = new DateTime(year, month, 1)
                .AddMonths(-1).AddDays(25);

            DateTime toDate = new DateTime(year, month, 25);

            using (SqlConnection connection =
                new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
        SELECT
            Code,
            SUM(ForDays) AS LeaveDays
        FROM dbo.UserLeaves
        WHERE IsApproved = 1
          AND LeaveFrom >= @FromDate
          AND LeaveFrom < DATEADD(DAY, 1, @ToDate)
        GROUP BY Code", connection))
            {
                command.Parameters.Add("@FromDate", SqlDbType.Date).Value = fromDate;
                command.Parameters.Add("@ToDate", SqlDbType.Date).Value = toDate;

                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result[Convert.ToString(reader["Code"])] =
                            Convert.ToInt32(reader["LeaveDays"]);
                    }
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
