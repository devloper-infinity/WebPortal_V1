using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ClientHolidayReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetClientHolidayReport(string HolidayFor, string Year)
        {
            int yearNo;

            if (!int.TryParse(Year, out yearNo) || yearNo < 1900 || yearNo > 2100)
            {
                return SerializeRows(new List<Dictionary<string, object>>());
            }

            DateTime fromDate = new DateTime(yearNo, 1, 1);
            DateTime toDate = fromDate.AddYears(1).AddDays(-1);

            List<Dictionary<string, object>> holidayRows = GetHolidayRows(fromDate, toDate, HolidayFor);
            List<Dictionary<string, object>> reportRows = new List<Dictionary<string, object>>();
            int srNo = 1;

            foreach (Dictionary<string, object> holidayRow in holidayRows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                row.Add("SrNo", srNo++);
                row.Add("EmployeeID", GetValue(holidayRow, "EmployeeID"));
                row.Add("HolidayDate", GetValue(holidayRow, "HolidayDate"));
                row.Add("HolidayFor", GetValue(holidayRow, "HolidayFor"));
                row.Add("AddedBy", GetValue(holidayRow, "AddedBy"));
                row.Add("AddedDate", GetValue(holidayRow, "AddedDate"));
                reportRows.Add(row);
            }

            return SerializeRows(reportRows);
        }

        private static List<Dictionary<string, object>> GetHolidayRows(DateTime fromDate, DateTime toDate, string holidayFor)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            {
                con.Open();
                HolidaySource source = FindHolidaySource(con);

                if (source == null)
                {
                    return rows;
                }

                using (SqlCommand cmd = new SqlCommand(BuildHolidayQuery(source, holidayFor), con))
                {
                    cmd.Parameters.AddWithValue("@FromDate", fromDate.Date);
                    cmd.Parameters.AddWithValue("@ToDate", toDate.Date);

                    if (!string.IsNullOrWhiteSpace(holidayFor) && !string.IsNullOrWhiteSpace(source.RemarkColumn))
                    {
                        cmd.Parameters.AddWithValue("@HolidayFor", holidayFor.Trim());
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rows = ToDictionaryRows(dt);
                    }
                }
            }

            return rows;
        }

        private static string BuildHolidayQuery(HolidaySource source, string holidayFor)
        {
            string employeeColumn = QuoteName(source.EmployeeColumn);
            string dateColumn = QuoteName(source.DateColumn);
            string employeeValue = "CASE WHEN ISNUMERIC(CONVERT(nvarchar(40), " + employeeColumn + ")) = 1 THEN CONVERT(int, " + employeeColumn + ") ELSE NULL END";
            string dateValue = "CASE WHEN ISDATE(CONVERT(nvarchar(100), " + dateColumn + ")) = 1 THEN CONVERT(date, " + dateColumn + ") ELSE NULL END";
            string remarkSelect = string.IsNullOrWhiteSpace(source.RemarkColumn) ? "''" : "ISNULL(CONVERT(nvarchar(4000), " + QuoteName(source.RemarkColumn) + "), '')";
            string addedBySelect = string.IsNullOrWhiteSpace(source.AddedByColumn) ? "''" : "ISNULL(CONVERT(nvarchar(200), " + QuoteName(source.AddedByColumn) + "), '')";
            string addedDateSelect = string.IsNullOrWhiteSpace(source.AddedDateColumn) ? "''" : "ISNULL(CONVERT(varchar(10), CASE WHEN ISDATE(CONVERT(nvarchar(100), " + QuoteName(source.AddedDateColumn) + ")) = 1 THEN CONVERT(date, " + QuoteName(source.AddedDateColumn) + ") ELSE NULL END, 120), '')";
            string holidayFilter = "";

            if (!string.IsNullOrWhiteSpace(holidayFor) && !string.IsNullOrWhiteSpace(source.RemarkColumn))
            {
                holidayFilter = " AND CONVERT(nvarchar(4000), " + QuoteName(source.RemarkColumn) + ") = @HolidayFor";
            }

            return @"
SELECT
    " + employeeValue + @" AS EmployeeID,
    CONVERT(varchar(10), " + dateValue + @", 120) AS HolidayDate,
    " + remarkSelect + @" AS HolidayFor,
    " + addedBySelect + @" AS AddedBy,
    " + addedDateSelect + @" AS AddedDate
FROM " + QuoteName(source.SchemaName) + "." + QuoteName(source.TableName) + @"
WHERE " + dateValue + @" >= @FromDate
  AND " + dateValue + @" <= @ToDate
  AND " + employeeValue + @" IS NOT NULL" + holidayFilter + @"
ORDER BY " + dateValue + @" DESC, " + employeeValue;
        }

        private static HolidaySource FindHolidaySource(SqlConnection con)
        {
            List<HolidaySourceCandidate> candidates = new List<HolidaySourceCandidate>();
            Dictionary<string, HolidaySourceCandidate> candidateByKey = new Dictionary<string, HolidaySourceCandidate>(StringComparer.OrdinalIgnoreCase);

            using (SqlCommand cmd = new SqlCommand(@"
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '%Holiday%'
  AND TABLE_NAME NOT LIKE '%Project%'
  AND TABLE_NAME NOT LIKE '%CompOff%'", con))
            {
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    foreach (DataRow dr in dt.Rows)
                    {
                        string schema = Convert.ToString(dr["TABLE_SCHEMA"]);
                        string table = Convert.ToString(dr["TABLE_NAME"]);
                        string column = Convert.ToString(dr["COLUMN_NAME"]);
                        string key = schema + "." + table;

                        if (!candidateByKey.ContainsKey(key))
                        {
                            HolidaySourceCandidate candidate = new HolidaySourceCandidate();
                            candidate.SchemaName = schema;
                            candidate.TableName = table;
                            candidateByKey.Add(key, candidate);
                            candidates.Add(candidate);
                        }

                        candidateByKey[key].Columns.Add(column);
                    }
                }
            }

            candidates.Sort(delegate (HolidaySourceCandidate left, HolidaySourceCandidate right)
            {
                return CandidateScore(left).CompareTo(CandidateScore(right));
            });

            foreach (HolidaySourceCandidate candidate in candidates)
            {
                string employeeColumn = FirstColumn(candidate, "EmployeeID", "EmpID", "UserID");
                string dateColumn = FirstColumn(candidate, "HolidayDate", "HolidayDates", "Date", "Dates", "WorkedHolidayDate", "Holiday");

                if (string.IsNullOrWhiteSpace(employeeColumn) || string.IsNullOrWhiteSpace(dateColumn))
                {
                    continue;
                }

                HolidaySource source = new HolidaySource();
                source.SchemaName = candidate.SchemaName;
                source.TableName = candidate.TableName;
                source.EmployeeColumn = employeeColumn;
                source.DateColumn = dateColumn;
                source.RemarkColumn = FirstColumn(candidate, "Remark", "HolidayName", "HolidayFor", "Description", "Reason");
                source.AddedByColumn = FirstColumn(candidate, "AddedBy", "CreatedBy", "UserID");
                source.AddedDateColumn = FirstColumn(candidate, "AddedDate", "CreatedDate", "InsertedDate");
                return source;
            }

            return null;
        }

        private static int CandidateScore(HolidaySourceCandidate candidate)
        {
            string table = candidate.TableName ?? "";

            if (table.Equals("HolidayMaster", StringComparison.OrdinalIgnoreCase))
            {
                return 0;
            }
            if (table.IndexOf("EmployeeHoliday", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return 1;
            }
            if (table.IndexOf("EmpHoliday", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return 2;
            }
            if (table.IndexOf("Worked", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return 4;
            }

            return 3;
        }

        private static string FirstColumn(HolidaySourceCandidate candidate, params string[] names)
        {
            foreach (string name in names)
            {
                if (candidate.Columns.Contains(name))
                {
                    return name;
                }
            }

            return "";
        }

        private static List<Dictionary<string, object>> ToDictionaryRows(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt == null)
            {
                return rows;
            }

            foreach (DataRow dr in dt.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col] == DBNull.Value ? "" : dr[col]);
                }
                rows.Add(row);
            }

            return rows;
        }

        private static object GetValue(Dictionary<string, object> row, string key)
        {
            if (row == null || !row.ContainsKey(key) || row[key] == DBNull.Value)
            {
                return "";
            }

            return row[key];
        }

        private static int ToInt(object value)
        {
            int result;
            if (value == null || !int.TryParse(value.ToString(), out result))
            {
                return 0;
            }

            return result;
        }

        private static string SerializeRows(List<Dictionary<string, object>> rows)
        {
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        private static string QuoteName(string name)
        {
            return "[" + (name ?? "").Replace("]", "]]") + "]";
        }

        private class HolidaySource
        {
            public string SchemaName { get; set; }
            public string TableName { get; set; }
            public string EmployeeColumn { get; set; }
            public string DateColumn { get; set; }
            public string RemarkColumn { get; set; }
            public string AddedByColumn { get; set; }
            public string AddedDateColumn { get; set; }
        }

        private class HolidaySourceCandidate
        {
            public HolidaySourceCandidate()
            {
                Columns = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            }

            public string SchemaName { get; set; }
            public string TableName { get; set; }
            public HashSet<string> Columns { get; private set; }
        }
    }
}
