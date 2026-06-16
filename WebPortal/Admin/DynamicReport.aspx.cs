using ClosedXML.Excel;
using Spire.Xls;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{

    public partial class DynamicReport : System.Web.UI.Page
    {

        private static readonly string ConnString = "Data Source=23.111.175.186;Initial Catalog=InfinityERP;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192";
        private static readonly string TableName = "dbo.EmployeeInfo";
        private static string NormalizedQuery = @"select * from usp_GetOnFloorEmployees";
        static Workbook book = new Workbook();
        static Worksheet sheet;
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static string GetFiltersList()
        {
            DataTable dt1 = new bllMaster().GetFiltersList();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetGroupByList()
        {
            DataTable dt1 = new bllMaster().GetGroupByList();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetColumnsList()
        {
            var metadata = new List<object>
            {
                new { Label = "Employee ID", ColumnName = "EmployeeID" },
                new { Label = "Code", ColumnName = "Code" },
                new { Label = "Name", ColumnName = "Name" },
                new { Label = "Shift", ColumnName = "Shift" },
                new { Label = "CutOff Time", ColumnName = "CutOffTime" },
                new { Label = "Pseudoname", ColumnName = "PseudoName" },
                new { Label = "Salary", ColumnName = "Salary", IsNumeric = true },
                new { Label = "Joining Date", ColumnName = "Joining_Date" },
                new { Label = "Domain", ColumnName = "Domain" },
                new { Label = "Subdomain", ColumnName = "SubDomain" },
                new { Label = "Department", ColumnName = "Department" },
                new { Label = "Branch", ColumnName = "Branch" },
                new { Label = "Designation", ColumnName = "Designation" },
                new { Label = "Official Email ID", ColumnName = "OfficialEmailID" },
                new { Label = "Reporting Manager", ColumnName = "ReportingManager" },
                new { Label = "Domain Head", ColumnName = "DomainHead" },
                new { Label = "Location Head", ColumnName = "LocationHead" },
                new { Label = "Tenure", ColumnName = "Tenure" },
                new { Label = "Tenure In Month", ColumnName = "TenureInMonth", IsNumeric = true },
                new { Label = "Segment", ColumnName = "Segment" },
                new { Label = "Current Status", ColumnName = "Current_Status" },
                new { Label = "Resignation Date", ColumnName = "Resignation_Date" },
            new { Label = "Latest Login Date", ColumnName = "Latest_Login_Date" }};

            return new JavaScriptSerializer().Serialize(metadata);
        }

        // ================= GET REPORT DATA =================

        [WebMethod]
        public static string GetReportData12(string Columns, string Filters, string GroupBy, string AggregateColumn, string AggregateFunc, List<string> GroupLevels, List<string> Summaries)
        {
            // Deserialize filter list
            List<FilterRule> filterList = new JavaScriptSerializer()
                .Deserialize<List<FilterRule>>(Filters);

            // Build WHERE clause
            string whereClause = BuildWhereClause(filterList);

            // 1) DETAILS (always full rows)
            string detailSql = BuildDetailSql(whereClause);
            List<Dictionary<string, object>> details = ExecuteDataTable(detailSql);

            // 2) SUMMARIES (only if user selected GroupBy levels)
            List<Dictionary<string, object>> summaryRows = new List<Dictionary<string, object>>();

            string[] grpCols = (GroupLevels != null)
                ? GroupLevels.Where(g => !string.IsNullOrWhiteSpace(g)).ToArray()
                : new string[0];

            if (grpCols.Length > 0)
            {
                string summarySql = BuildSummarySql(grpCols, whereClause);
                summaryRows = ExecuteDataTable(summarySql);
            }

            var result = new
            {
                details = details,
                summaries = summaryRows,
                groupCols = grpCols
            };

            return new JavaScriptSerializer().Serialize(result);
        }
        [WebMethod]
        public static string GetReportData(string Columns, string Filters, string GroupBy, string AggregateColumn, string AggregateFunc, List<string> GroupLevels, List<string> Summaries)
        {
            List<FilterRule> filterList = new JavaScriptSerializer().Deserialize<List<FilterRule>>(Filters);
            string whereClause = BuildWhereClause(filterList);

            // 1) DETAILS (full employee records)
            string detailSql = BuildDetailSql(whereClause);
            List<Dictionary<string, object>> details = ExecuteDataTable(detailSql);

            // 2) SUMMARIES (grouped data with COUNT, SUM)
            List<Dictionary<string, object>> summaryRows = new List<Dictionary<string, object>>();
            string[] grpCols = (GroupLevels != null) ? GroupLevels.Where(g => !string.IsNullOrWhiteSpace(g)).ToArray() : new string[0];

            if (grpCols.Length > 0)
            {
                string summarySql = BuildSummarySql(grpCols, whereClause);
                summaryRows = ExecuteDataTable(summarySql);
            }

            var result = new
            {
                details = details,
                summaries = summaryRows,
                groupCols = grpCols
            };

            return new JavaScriptSerializer().Serialize(result);
        }

        private static string BuildDetailSql(string where)
        {
            return @"select * from usp_GetOnFloorEmployees 
                        " + where + @"
                        ORDER BY EmployeeID ASC";
        }

        private static string BuildSummarySql(string[] groupCols, string where)
        {
            string grpCols = string.Join(",", groupCols.Select(c => "[" + c + "]"));
            // grpCols = grpCols + ",EmployeeID";
            return @"
            SELECT 
                " + grpCols + @",
                COUNT(*) AS GroupCount,
                SUM(Salary) AS GroupSalarySum
            FROM usp_GetOnFloorEmployees
            " + where + @"
            GROUP BY " + grpCols + @"
            ORDER BY " + grpCols;
        }
        private static List<Dictionary<string, object>> ExecuteDataTable(string sql)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                conn.Open();

                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        Dictionary<string, object> row = new Dictionary<string, object>();

                        for (int i = 0; i < rdr.FieldCount; i++)
                        {
                            row.Add(rdr.GetName(i), rdr.IsDBNull(i) ? null : rdr.GetValue(i));
                        }

                        rows.Add(row);
                    }
                }
            }

            return rows;
        }

        // ================= SQL BUILDER ==================
        private static string BuildSql(string Columns, string GroupBy, string where, string AggColumn, string AggFunc)
        {
            string baseQuery = $"({NormalizedQuery}) AS base";

            // Wrap identifiers safely
            Func<string, string> wrap = x => "[" + x.Trim().Trim('[', ']') + "]";

            // Aggregate
            if (!string.IsNullOrEmpty(AggColumn) && !string.IsNullOrEmpty(AggFunc))
            {
                string select;
                if (!string.IsNullOrEmpty(GroupBy))
                {
                    var grp = string.Join(",", GroupBy.Split(',').Select(g => wrap(g)));
                    select = grp + $", {AggFunc}({wrap(AggColumn)}) AS [{AggFunc}_{AggColumn.Replace(" ", "_")}]";
                    return $"SELECT {select} FROM {baseQuery} {where} GROUP BY {grp}";
                }
                else
                {
                    select = $"{AggFunc}({wrap(AggColumn)}) AS [{AggFunc}_{AggColumn.Replace(" ", "_")}]";
                    return $"SELECT {select} FROM {baseQuery} {where}";
                }
            }

            // GroupBy
            if (!string.IsNullOrEmpty(GroupBy))
            {
                var grp = string.Join(",", GroupBy.Split(',').Select(g => wrap(g)));
                return $"SELECT {grp}, COUNT(*) AS Count FROM {baseQuery} {where} GROUP BY {grp}";
            }

            // Normal Select
            string selectColumns = "*";
            if (!string.IsNullOrEmpty(Columns))
            {
                selectColumns = string.Join(",", Columns.Split(',').Select(c => wrap(c)));
            }

            return $"SELECT {selectColumns} FROM {baseQuery} {where}";
        }
        private static string BuildWhereClause(List<FilterRule> filters)
        {
            if (filters == null || filters.Count == 0)
                return "";

            List<string> conditions = new List<string>();

            foreach (var f in filters)
            {
                string col = "[" + f.Column.Replace(" ", "_") + "]";

                switch (f.Operator)
                {
                    case "LIKE":
                        conditions.Add($"{col} LIKE '%{f.Value1.Replace("'", "''")}%'");
                        break;

                    case "BETWEEN":
                        switch (col)
                        {
                            case "[Joining_Date]":
                            case "[Last_Working_Date]":
                            case "[Latest_Login_Date]":
                                conditions.Add($"{col} BETWEEN cast('{f.Value1.Replace("'", "''")}' as date) AND cast('{f.Value2.Replace("'", "''")}' as date)");
                                break;
                            default:
                                conditions.Add($"{col} BETWEEN '{f.Value1.Replace("'", "''")}' AND '{f.Value2.Replace("'", "''")}'");
                                break;
                        }
                        break;

                    case "IN":
                        string cleaned = string.Join("','", f.Value1
                                .Split(',').Select(v => v.Trim().Replace("'", "''")));
                        conditions.Add($"{col} IN ('{cleaned}')");
                        break;

                    default:
                        conditions.Add($"{col} {f.Operator} '{f.Value1.Replace("'", "''")}'");
                        break;
                }
            }

            return " WHERE " + string.Join(" AND ", conditions);
        }


        #region Helpers

        private static string[] SplitCsv(string csv)
        {
            if (string.IsNullOrWhiteSpace(csv)) return new string[0];
            var arr = csv.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < arr.Length; i++) arr[i] = arr[i].Trim();
            return arr;
        }

        private static List<string> GetAllowedColumns()
        {
            var list = new List<string>();
            using (var conn = new SqlConnection(ConnString))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = @"
                SELECT COLUMN_NAME
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = PARSENAME(@table, 2) AND TABLE_NAME = PARSENAME(@table,1)";
                cmd.Parameters.AddWithValue("@table", TableName);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read()) list.Add(rdr.GetString(0));
                }
            }
            return list;
        }

        private static string[] FilterAllowed(string[] requested, List<string> allowed)
        {
            if (requested == null || requested.Length == 0) return new string[0];
            var outList = new List<string>();
            foreach (var r in requested)
            {
                if (string.IsNullOrWhiteSpace(r)) continue;
                // case-insensitive match
                foreach (var a in allowed)
                {
                    if (string.Equals(a, r, StringComparison.OrdinalIgnoreCase))
                    {
                        outList.Add(a); // use the allowed column name exactly
                        break;
                    }
                }
            }
            return outList.ToArray();
        }

        private static string BuildSql(string[] cols, string[] filters, string[] groups)
        {
            // If nothing selected at all -> return top 500 rows of table
            if ((cols == null || cols.Length == 0) && (groups == null || groups.Length == 0))
            {
                return $"SELECT TOP (500) * FROM {TableName}";
            }

            // If group by requested -> build GROUP BY query (simple COUNT aggregate)
            if (groups != null && groups.Length > 0)
            {
                // SELECT groupCols, COUNT(*) AS [Count]
                string groupCols = string.Join(", ", WrapCols(groups));
                return $"SELECT {groupCols}, COUNT(*) AS [Count] FROM {TableName} GROUP BY {groupCols} ORDER BY {groupCols}";
            }
            else
            {
                // No grouping: select the requested columns + any requested filters (treated as included columns)
                var finalCols = new List<string>();
                if (cols != null && cols.Length > 0) finalCols.AddRange(cols);
                if (filters != null && filters.Length > 0)
                {
                    // include filter columns if not already present
                    foreach (var f in filters) if (!finalCols.Contains(f)) finalCols.Add(f);
                }

                if (finalCols.Count == 0)
                {
                    return $"SELECT TOP (500) * FROM {TableName}";
                }

                string selectList = string.Join(", ", WrapCols(finalCols.ToArray()));
                return $"SELECT {selectList} FROM {TableName}";
            }
        }

        // wrap column names with brackets to be safe
        private static string[] WrapCols(string[] cols)
        {
            var outp = new string[cols.Length];
            for (int i = 0; i < cols.Length; i++)
            {
                outp[i] = "[" + cols[i].Replace("]", "]]") + "]";
            }
            return outp;
        }

        [WebMethod]
        public static string SaveTemplate1(string TemplateName, string FiltersJson)
        {
            string Code = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(
                @"INSERT INTO ReportTemplates(TemplateName, FiltersJson, CreatedBy, RequestedBy,CreatedOn) 
          VALUES(@name, @json, @user, @reqby, GETDATE())", conn))
            {
                cmd.Parameters.AddWithValue("@name", TemplateName);
                cmd.Parameters.AddWithValue("@json", FiltersJson);
                cmd.Parameters.AddWithValue("@user", Code); // or dynamic user ID
                cmd.Parameters.AddWithValue("@reqby", Code); // or dynamic user ID

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            return "OK";
        }

        [WebMethod]
        public static int SaveTemplate(int TemplateID, string TemplateName, string FiltersJson)
        {
            string user = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                conn.Open();

                if (TemplateID == 0)
                {
                    // NEW TEMPLATE
                    using (SqlCommand cmd = new SqlCommand(@"
                INSERT INTO ReportTemplates 
                (TemplateName, FiltersJson, RequestedBy, CreatedBy, CreatedOn)
                OUTPUT INSERTED.TemplateID
                VALUES (@Name, @Json, @User, @User, GETDATE())", conn))
                    {
                        cmd.Parameters.AddWithValue("@Name", TemplateName);
                        cmd.Parameters.AddWithValue("@Json", FiltersJson);
                        cmd.Parameters.AddWithValue("@User", user);

                        return (int)cmd.ExecuteScalar();
                    }
                }
                else
                {
                    // UPDATE EXISTING TEMPLATE
                    using (SqlCommand cmd = new SqlCommand(@"
                UPDATE ReportTemplates
                SET TemplateName=@Name,
                    FiltersJson=@Json,
                    LastAccessedOn=GETDATE(),
                    LastAccessedBy=@User
                WHERE TemplateID=@ID;

                SELECT @ID;", conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", TemplateID);
                        cmd.Parameters.AddWithValue("@Name", TemplateName);
                        cmd.Parameters.AddWithValue("@Json", FiltersJson);
                        cmd.Parameters.AddWithValue("@User", user);

                        return (int)cmd.ExecuteScalar();
                    }
                }
            }
        }


        [WebMethod]
        public static string GetAllTemplates()
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT 
            TemplateID,
            TemplateName,
            CreatedOn,
            ISNULL(LastAccessedOn, '1900-01-01') AS LastAccessedOn, RequestedBy, LastAccessedBy
        FROM ReportTemplates
        ORDER BY LastAccessedOn DESC", conn))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                da.Fill(dt);
            }

            return new JavaScriptSerializer().Serialize(
              dt.AsEnumerable().Select(r => new
              {
                  TemplateID = r["TemplateID"],
                  TemplateName = r["TemplateName"],
                  CreatedOn = r["CreatedOn"],
                  LastAccessedOn = r["LastAccessedOn"],
                  RequestedBy = r["RequestedBy"],
                  CreatedBy = r["RequestedBy"],
                  LastAccessedBy = r["LastAccessedBy"]
              }).ToList()
          );
        }


        [WebMethod]
        public static string GetTemplates()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlDataAdapter da = new SqlDataAdapter(
                "SELECT TemplateID, TemplateName FROM ReportTemplates ORDER BY CreatedOn DESC", conn))
            {
                da.Fill(dt);
            }

            return new JavaScriptSerializer().Serialize(
                dt.AsEnumerable().Select(r => new
                {
                    TemplateID = r["TemplateID"],
                    TemplateName = r["TemplateName"]
                }).ToList()
            );
        }
        [WebMethod]
        public static string GetTemplateData(int TemplateID)
        {
            string json = "";
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT FiltersJson FROM ReportTemplates WHERE TemplateID=@id", conn))
            {
                cmd.Parameters.AddWithValue("@id", TemplateID);
                conn.Open();
                json = (string)cmd.ExecuteScalar();
            }
            return json;
        }
        [WebMethod]
        public static string DeleteTemplate(int TemplateID)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(
                "DELETE FROM ReportTemplates WHERE TemplateID=@id", conn))
            {
                cmd.Parameters.AddWithValue("@id", TemplateID);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            return "OK";
        }

        [WebMethod]
        public static string UpdateTemplate(int TemplateID, string TemplateName, string FiltersJson)
        {
            try
            {
            string user = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                using (SqlConnection conn = new SqlConnection(ConnString))
                using (SqlCommand cmd = new SqlCommand(@"
            UPDATE ReportTemplates
            SET TemplateName = @name,
                FiltersJson = @json,
                CreatedOn = GETDATE(),
                    LastAccessedBy=@User
            WHERE TemplateID = @id
        ", conn))
                {
                    cmd.Parameters.AddWithValue("@id", TemplateID);
                    cmd.Parameters.AddWithValue("@name", TemplateName);
                    cmd.Parameters.AddWithValue("@json", FiltersJson);
                    cmd.Parameters.AddWithValue("@User", user);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                return "OK";
            }
            catch (Exception ex)
            {
                return "ERROR: " + ex.Message;
            }
        }

        [WebMethod]
        public static void UpdateTemplateLastAccessed(int TemplateID)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(@"
        UPDATE ReportTemplates 
        SET LastAccessedOn = GETDATE()
        WHERE TemplateID = @id", conn))
            {
                cmd.Parameters.AddWithValue("@id", TemplateID);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        [WebMethod]
        public static string DownloadTemplateFormat(int TemplateID)
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT TemplateName, FiltersJson, CreatedOn, LastAccessedOn
        FROM ReportTemplates
        WHERE TemplateID = @id", conn))
            {
                cmd.Parameters.AddWithValue("@id", TemplateID);

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }

            if (dt.Rows.Count == 0)
                return "";

            string templateName = dt.Rows[0]["TemplateName"].ToString();
            string filtersJson = dt.Rows[0]["FiltersJson"].ToString();

            // Deserialize filters using JavaScriptSerializer
            var serializer = new JavaScriptSerializer();

            List<FilterRule> filters = new List<FilterRule>();

            try
            {
                // NEW FORMAT: { "Filters": [...], "Columns": [...] }
                TemplateWrapper wrapper = serializer.Deserialize<TemplateWrapper>(filtersJson);
                if (wrapper.Filters != null)
                    filters = wrapper.Filters;
            }
            catch
            {
                // OLD FORMAT: [ { Column, Operator, Value1, Value2 }, ... ]
                filters = serializer.Deserialize<List<FilterRule>>(filtersJson);
            }

            // Prepare export table
            DataTable dtExport = new DataTable();
            dtExport.Columns.Add("Column");
            dtExport.Columns.Add("Operator");
            dtExport.Columns.Add("Value1");
            dtExport.Columns.Add("Value2");

            foreach (var f in filters)
            {
                dtExport.Rows.Add(f.Column, f.Operator, f.Value1, f.Value2);
            }

            // Create Excel download folder
            string folderPath = HttpContext.Current.Server.MapPath("~/ReportDocument/");
            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            string fileName = "Template_" + TemplateID + ".xlsx";
            string filePath = Path.Combine(folderPath, fileName);

            // Create Excel using ClosedXML
            using (var wb = new ClosedXML.Excel.XLWorkbook())
            {
                var ws = wb.Worksheets.Add("Template Filters");

                ws.Cell(1, 1).Value = "Template Name";
                ws.Cell(1, 2).Value = templateName;

                ws.Cell(2, 1).Value = "Template ID";
                ws.Cell(2, 2).Value = TemplateID;

                ws.Cell(3, 1).Value = "Created On";
                ws.Cell(3, 2).Value = dt.Rows[0]["CreatedOn"].ToString();

                ws.Cell(4, 1).Value = "Last Accessed";
                ws.Cell(4, 2).Value = dt.Rows[0]["LastAccessedOn"].ToString();

                ws.Cell(6, 1).InsertTable(dtExport);

                wb.SaveAs(filePath);
            }

            return "/ReportDocument/" + fileName;
        }

        [WebMethod]
        public static string DownloadTemplateActualData(int TemplateID)
        {
            string templateName = "";
            string filtersJson = "";

            //save last accessed
            string Code = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            //string user = HttpContext.Current.User.Identity.Name;

            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(@"
    UPDATE ReportTemplates 
    SET LastAccessedOn = GETDATE(), LastAccessedBy = @User
    WHERE TemplateID = @id", conn))
            {
                cmd.Parameters.AddWithValue("@User", Code);
                cmd.Parameters.AddWithValue("@id", TemplateID);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // 1. Load template
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT TemplateName, FiltersJson FROM ReportTemplates WHERE TemplateID=@id", conn))
            {
                cmd.Parameters.AddWithValue("@id", TemplateID);
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        templateName = r["TemplateName"].ToString();
                        filtersJson = r["FiltersJson"].ToString();
                    }
                }
            }

            if (string.IsNullOrWhiteSpace(filtersJson))
                return "";

            // 2. Deserialize filters
            var serializer = new JavaScriptSerializer();
            List<FilterRule> filters;

            try
            {
                // New format { Filters:[], Columns:[] }
                TemplateWrapper wrapper = serializer.Deserialize<TemplateWrapper>(filtersJson);
                filters = wrapper.Filters ?? new List<FilterRule>();
            }
            catch
            {
                // Old format: direct filter array
                filters = serializer.Deserialize<List<FilterRule>>(filtersJson);
            }

            // 3. Build WHERE clause using your existing logic
            string whereClause = BuildWhereClause(filters);

            // 4. Build detail SQL using your existing method
            string sql = BuildDetailSql(whereClause);

            // 5. Execute SQL and get report table
            DataTable dt = ExecuteDataTableForExcel(sql);

            // 6. Export using ClosedXML
            string folder = HttpContext.Current.Server.MapPath("~/ReportDocument/");
            if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);

            string fileName = $"{templateName}.xlsx";
            string filePath = Path.Combine(folder, fileName);
            book = new Workbook();
            book.DefaultFontSize = 9;
            book.DefaultFontName = "biome";

            int rowcount = 0;
            int colcount = 0;

            sheet = book.Worksheets.Add(templateName);
            sheet.InsertDataTable(dt, true, 1, 1);
            string Col = GetColumnName_Static(dt.Columns.Count - 1);
            CellRange range = sheet.Range["A1:" + Col + "1"];
            HeaderFormat_Static(range);
            range = sheet.Range["A1:" + Col + (dt.Rows.Count + 1)];
            AllBorder_Static(range);
            ContentCenter_Static(range);
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();

            if (File.Exists(filePath))
            {
                try
                {
                    File.Delete(filePath);
                }
                catch { }
            }

            book.SaveToFile(filePath, ExcelVersion.Version2010);

            int sheetIndexToDelete = 1;
            using (var workbook = new XLWorkbook(filePath))
            {
                // Check if index is within bounds
                if (sheetIndexToDelete >= 0 && sheetIndexToDelete < workbook.Worksheets.Count)
                {
                    var worksheet = workbook.Worksheet(1);
                    workbook.Worksheets.Delete(worksheet.Name);
                    worksheet = workbook.Worksheet(1);
                    workbook.Worksheets.Delete(worksheet.Name);
                    worksheet = workbook.Worksheet(1);
                    workbook.Worksheets.Delete(worksheet.Name);
                    worksheet = workbook.Worksheet(2);
                    workbook.Worksheets.Delete(worksheet.Name);
                }
                else
                {

                }

                // Save the updated workbook
                workbook.SaveAs(filePath);

            }
            //using (var wb = new ClosedXML.Excel.XLWorkbook())
            //{
            //    var ws = wb.Worksheets.Add("Report Data");
            //    ws.Cell(1, 1).InsertTable(dt);

            //    wb.SaveAs(filePath);
            //}

            return "/ReportDocument/" + fileName;
        }

        private static DataTable ExecuteDataTableForExcel(string sql)
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                da.Fill(dt);
            }

            return dt;
        }

        static string GetColumnName_Static(int index)
        {
            const string letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

            var value = "";

            if (index >= letters.Length)
                value += letters[index / letters.Length - 1];

            value += letters[index % letters.Length];

            return value;
        }
        public static void HeaderFormat_Static(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Color = Color.FromArgb(113, 147, 209);
            range.Style.Font.Color = Color.White;
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.IsBold = true;
        }
        public static void AllBorder_Static(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }
        public static void ContentCenter_Static(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
        }
        public static void DashboardHeader_Static(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.Size = 12;
            range.Style.Font.IsBold = true;
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }
        public static void DashboardContent_Static(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.Size = 10;
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }







        #endregion

        public class FilterRule
        {
            public string Column { get; set; }
            public string Operator { get; set; }
            public string Value1 { get; set; }
            public string Value2 { get; set; }
        }

        public class TemplateWrapper
        {
            public List<FilterRule> Filters { get; set; }
            public List<string> Columns { get; set; }
        }
    }
}