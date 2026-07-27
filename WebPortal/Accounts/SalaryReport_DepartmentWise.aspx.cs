using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.DAL;

namespace WebPortal.Reports
{
    public partial class SalaryReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["export"] == "1")
                ExportSalaryReport();
        }

        [WebMethod]
        public static SalaryReportResponse GetSalaryReport(int fromMonth, int fromYear, int toMonth, int toYear)
        {
            try
            {
                string validationMessage = ValidatePeriod(fromMonth, fromYear, toMonth, toYear);
                if (!string.IsNullOrEmpty(validationMessage))
                    return SalaryReportResponse.Fail(validationMessage);

                DataSet ds = GetSalaryData(fromMonth, fromYear, toMonth, toYear);

                return new SalaryReportResponse
                {
                    Success = true,
                    Message = "",
                    YearSummary = ds.Tables.Count > 0 ? ToRows(ds.Tables[0]) : new List<Dictionary<string, object>>(),
                    MonthDetails = ds.Tables.Count > 1 ? ToRows(ds.Tables[1]) : new List<Dictionary<string, object>>(),
                    EmployeeDetails = ds.Tables.Count > 2 ? ToRows(ds.Tables[2]) : new List<Dictionary<string, object>>()
                };
            }
            catch (Exception ex)
            {
                return SalaryReportResponse.Fail(ex.Message);
            }
        }

        private void ExportSalaryReport()
        {
            int fromMonth, fromYear, toMonth, toYear;

            if (!int.TryParse(Request.QueryString["fromMonth"], out fromMonth) ||
                !int.TryParse(Request.QueryString["fromYear"], out fromYear) ||
                !int.TryParse(Request.QueryString["toMonth"], out toMonth) ||
                !int.TryParse(Request.QueryString["toYear"], out toYear))
            {
                ShowExportError("Please select a valid From Month-Year and To Month-Year.");
                return;
            }

            string validationMessage = ValidatePeriod(fromMonth, fromYear, toMonth, toYear);
            if (!string.IsNullOrEmpty(validationMessage))
            {
                ShowExportError(validationMessage);
                return;
            }

            try
            {
                DataSet ds = GetSalaryData(fromMonth, fromYear, toMonth, toYear);
                using (XLWorkbook workbook = new XLWorkbook())
                {
                    DataTable yearSummary = ds.Tables.Count > 0 ? ds.Tables[0] : new DataTable();
                    DataTable monthSummary = ds.Tables.Count > 1 ? ds.Tables[1] : new DataTable();
                    DataTable employeeDetails = ds.Tables.Count > 2 ? ds.Tables[2] : new DataTable();
                    CreateHeadcountTrendSheet(workbook, monthSummary, employeeDetails);
                    CreateGrossSalaryTrendSheet(workbook, monthSummary, employeeDetails);
                    CreateSalaryDeviationSheet(workbook, monthSummary, employeeDetails);
                    CreateDashboardDataSheet(workbook, monthSummary, employeeDetails);
                    CreateHorizontalMonthlySheet(workbook, monthSummary, employeeDetails);
                    CreateYearSummarySheet(workbook, yearSummary, employeeDetails);
                    CreateMonthSummarySheet(workbook, monthSummary, employeeDetails);
                    CreateEmployeeDetailsSheet(workbook, employeeDetails);

                    string fileName = string.Format("SalaryReport_{0}_{1}_to_{2}_{3}.xlsx",
                        CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(fromMonth), fromYear,
                        CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(toMonth), toYear);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        workbook.SaveAs(stream);
                        byte[] bytes = stream.ToArray();
                        Response.Clear();
                        Response.Buffer = true;
                        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                        Response.AddHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                        Response.AddHeader("Content-Length", bytes.Length.ToString(CultureInfo.InvariantCulture));
                        Response.BinaryWrite(bytes);
                        Response.Flush();
                        HttpContext.Current.ApplicationInstance.CompleteRequest();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowExportError("Unable to export report: " + ex.Message);
            }
        }
        private void ExportSalaryReport_OLD()
        {
            int fromMonth;
            int fromYear;
            int toMonth;
            int toYear;

            if (!int.TryParse(Request.QueryString["fromMonth"], out fromMonth) ||
                !int.TryParse(Request.QueryString["fromYear"], out fromYear) ||
                !int.TryParse(Request.QueryString["toMonth"], out toMonth) ||
                !int.TryParse(Request.QueryString["toYear"], out toYear))
            {
                ShowExportError(
                    "Please select a valid From Month-Year and To Month-Year.");
                return;
            }

            string validationMessage = ValidatePeriod(
                fromMonth,
                fromYear,
                toMonth,
                toYear);

            if (!string.IsNullOrEmpty(validationMessage))
            {
                ShowExportError(validationMessage);
                return;
            }

            try
            {
                DataSet ds = GetSalaryData(
                    fromMonth,
                    fromYear,
                    toMonth,
                    toYear);

                DataTable yearSummary =
                    ds.Tables.Count > 0
                        ? ds.Tables[0]
                        : new DataTable();

                DataTable monthSummary =
                    ds.Tables.Count > 1
                        ? ds.Tables[1]
                        : new DataTable();

                DataTable employeeDetails =
                    ds.Tables.Count > 2
                        ? ds.Tables[2]
                        : new DataTable();

                string templatePath = Server.MapPath(
                    "~/ReportTemplates/SalaryReportTemplate.xlsx");

                if (!File.Exists(templatePath))
                {
                    ShowExportError(
                        "Excel template was not found at: " + templatePath);
                    return;
                }

                using (XLWorkbook workbook = new XLWorkbook(templatePath))
                {
                    PopulateHeadcountTrendSheet(
                        workbook,
                        monthSummary,
                        employeeDetails);

                    PopulateGrossSalaryTrendSheet(
                        workbook,
                        monthSummary,
                        employeeDetails);

                    PopulateSalaryDeviationSheet(
                        workbook,
                        monthSummary,
                        employeeDetails);

                    // Remove previously generated data sheets from the template,
                    // if they exist.
                    DeleteWorksheetIfExists(workbook, "Gross Year Summary");
                    DeleteWorksheetIfExists(workbook, "Year Summary");
                    DeleteWorksheetIfExists(workbook, "Month Summary");
                    DeleteWorksheetIfExists(workbook, "Employee Details");

                    CreateGrossYearSummarySheet(
                        workbook,
                        yearSummary,
                        employeeDetails);

                    CreateYearSummarySheet(
                        workbook,
                        yearSummary,
                        employeeDetails);

                    CreateMonthSummarySheet(
                        workbook,
                        monthSummary,
                        employeeDetails);

                    CreateEmployeeDetailsSheet(
                        workbook,
                        employeeDetails);

                    string fileName = string.Format(
                        CultureInfo.InvariantCulture,
                        "SalaryReport_{0}_{1}_to_{2}_{3}.xlsx",
                        CultureInfo.CurrentCulture.DateTimeFormat
                            .GetAbbreviatedMonthName(fromMonth),
                        fromYear,
                        CultureInfo.CurrentCulture.DateTimeFormat
                            .GetAbbreviatedMonthName(toMonth),
                        toYear);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        workbook.SaveAs(stream);

                        byte[] bytes = stream.ToArray();

                        Response.Clear();
                        Response.Buffer = true;
                        Response.ContentType =
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                        Response.AddHeader(
                            "Content-Disposition",
                            "attachment; filename=\"" + fileName + "\"");

                        Response.AddHeader(
                            "Content-Length",
                            bytes.Length.ToString(
                                CultureInfo.InvariantCulture));

                        Response.BinaryWrite(bytes);
                        Response.Flush();

                        HttpContext.Current.ApplicationInstance
                            .CompleteRequest();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowExportError(
                    "Unable to export report: " + ex.Message);
            }
        }
        private static void PopulateHeadcountTrendSheet(
    XLWorkbook workbook,
    DataTable monthSummary,
    DataTable employeeDetails)
        {
            const string sheetName = "Headcount Trend";

            IXLWorksheet ws = GetRequiredTemplateWorksheet(
                workbook,
                sheetName);

            MonthlyExportModel model = BuildMonthlyExportModel(
                monthSummary,
                employeeDetails);

            PrepareTemplateChartSheet(
                ws,
                "Department-wise Headcount Trend");

            int chartDataRow = 4;

            foreach (KeyValuePair<int, string> period in model.Periods)
            {
                int totalHeadcount = 0;

                foreach (string department in model.Departments)
                {
                    string key =
                        period.Key.ToString(
                            CultureInfo.InvariantCulture) +
                        "||" +
                        department;

                    int count;

                    model.HeadcountValues.TryGetValue(
                        key,
                        out count);

                    totalHeadcount += count;
                }

                ws.Cell(chartDataRow, 1).Value =
                    GetShortPeriodLabel(period.Key, period.Value);

                ws.Cell(chartDataRow, 2).Value =
                    totalHeadcount;

                chartDataRow++;
            }

            ws.Range("B4:B63")
                .Style.NumberFormat.Format = "0";

            WriteHorizontalMetricTable(
                ws,
                model,
                24,
                ExportMetric.Headcount);
        }
        private static void PopulateGrossSalaryTrendSheet(
    XLWorkbook workbook,
    DataTable monthSummary,
    DataTable employeeDetails)
        {
            const string sheetName = "Gross Salary Trend";

            IXLWorksheet ws = GetRequiredTemplateWorksheet(
                workbook,
                sheetName);

            MonthlyExportModel model = BuildMonthlyExportModel(
                monthSummary,
                employeeDetails);

            PrepareTemplateChartSheet(
                ws,
                "Department-wise Gross Salary Trend");

            int chartDataRow = 4;

            foreach (KeyValuePair<int, string> period in model.Periods)
            {
                decimal totalGross = 0M;

                foreach (string department in model.Departments)
                {
                    string key =
                        period.Key.ToString(
                            CultureInfo.InvariantCulture) +
                        "||" +
                        department;

                    decimal gross;

                    model.GrossValues.TryGetValue(
                        key,
                        out gross);

                    totalGross += gross;
                }

                ws.Cell(chartDataRow, 1).Value =
                    GetShortPeriodLabel(period.Key, period.Value);

                ws.Cell(chartDataRow, 2).Value =
                    totalGross;

                chartDataRow++;
            }

            ws.Range("B4:B63")
                .Style.NumberFormat.Format = "#,##0.00";

            WriteHorizontalMetricTable(
                ws,
                model,
                24,
                ExportMetric.Gross);
        }
        private static void PopulateSalaryDeviationSheet(
    XLWorkbook workbook,
    DataTable monthSummary,
    DataTable employeeDetails)
        {
            const string sheetName = "Salary Deviation";

            IXLWorksheet ws = GetRequiredTemplateWorksheet(
                workbook,
                sheetName);

            MonthlyExportModel model = BuildMonthlyExportModel(
                monthSummary,
                employeeDetails);

            PrepareTemplateChartSheet(
                ws,
                "Department-wise Gross Salary Deviation");

            int chartDataRow = 4;
            decimal previousTotal = 0M;
            bool hasPrevious = false;

            foreach (KeyValuePair<int, string> period in model.Periods)
            {
                decimal currentTotal = 0M;

                foreach (string department in model.Departments)
                {
                    string key =
                        period.Key.ToString(
                            CultureInfo.InvariantCulture) +
                        "||" +
                        department;

                    decimal gross;

                    model.GrossValues.TryGetValue(
                        key,
                        out gross);

                    currentTotal += gross;
                }

                decimal deviation = 0M;

                if (hasPrevious && previousTotal != 0M)
                {
                    deviation =
                        (currentTotal - previousTotal) /
                        previousTotal;
                }

                ws.Cell(chartDataRow, 1).Value =
                    GetShortPeriodLabel(period.Key, period.Value);

                /*
                 * Store percentage as a decimal fraction:
                 * 0.025 means 2.50%.
                 */
                ws.Cell(chartDataRow, 2).Value =
                    deviation;

                previousTotal = currentTotal;
                hasPrevious = true;
                chartDataRow++;
            }

            IXLRange chartValues = ws.Range("B4:B63");

            chartValues.Style.NumberFormat.Format =
                "0.00%";

            chartValues
                .AddConditionalFormat()
                .WhenGreaterThan(0)
                .Fill
                .SetBackgroundColor(
                    XLColor.FromHtml("#E2F0D9"))
                .Font
                .SetFontColor(
                    XLColor.FromHtml("#006100"));

            chartValues
                .AddConditionalFormat()
                .WhenLessThan(0)
                .Fill
                .SetBackgroundColor(
                    XLColor.FromHtml("#FCE4D6"))
                .Font
                .SetFontColor(
                    XLColor.FromHtml("#9C0006"));

            WriteHorizontalMetricTable(
                ws,
                model,
                24,
                ExportMetric.Deviation);
        }

        private static IXLWorksheet GetRequiredTemplateWorksheet(
    XLWorkbook workbook,
    string sheetName)
        {
            IXLWorksheet worksheet;

            if (!workbook.Worksheets.TryGetWorksheet(
                    sheetName,
                    out worksheet))
            {
                throw new InvalidOperationException(
                    "The worksheet '" +
                    sheetName +
                    "' was not found in the Excel template.");
            }

            return worksheet;
        }

        private static void PrepareTemplateChartSheet(
            IXLWorksheet ws,
            string title)
        {
            /*
             * Only clear cell values.
             * Do not delete the worksheet, rows, columns, or chart.
             */
            ws.Range("A1:B63")
                .Clear(XLClearOptions.Contents);

            /*
             * Clear the previous horizontal table.
             * Increase AZ200 if the report may contain more columns/rows.
             */
            ws.Range("A24:AZ200")
                .Clear(XLClearOptions.Contents);

            ws.Cell("A1").Value = title;

            ws.Cell("A1").Style.Font.Bold = true;
            ws.Cell("A1").Style.Font.FontSize = 16;
            ws.Cell("A1").Style.Font.FontColor = XLColor.White;
            ws.Cell("A1").Style.Fill.BackgroundColor =
                XLColor.FromHtml("#355A8A");

            ws.Range("A1:B1").Merge();

            ws.Cell("A3").Value = "Month";
            ws.Cell("B3").Value = "Value";

            IXLRange header = ws.Range("A3:B3");

            header.Style.Font.Bold = true;
            header.Style.Font.FontColor = XLColor.White;
            header.Style.Fill.BackgroundColor =
                XLColor.FromHtml("#5A78A8");

            header.Style.Alignment.Horizontal =
                XLAlignmentHorizontalValues.Center;

            ws.Column(1).Width = 16;
            ws.Column(2).Width = 18;
        }

        private static void DeleteWorksheetIfExists(
            XLWorkbook workbook,
            string worksheetName)
        {
            IXLWorksheet worksheet;

            if (workbook.Worksheets.TryGetWorksheet(
                    worksheetName,
                    out worksheet))
            {
                worksheet.Delete();
            }
        }
        private static string GetShortPeriodLabel(
    int periodKey,
    string fallbackLabel)
        {
            int year = periodKey / 100;
            int month = periodKey % 100;

            if (month >= 1 && month <= 12)
            {
                return new DateTime(year, month, 1)
                    .ToString(
                        "MMM-yy",
                        CultureInfo.InvariantCulture);
            }

            return fallbackLabel;
        }

        private static DataSet GetSalaryData(int fromMonth, int fromYear, int toMonth, int toYear)
        {
            DataSet ds = new DataSet();

            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.usp_GetSalaryReportwithSummary", con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 300;
                cmd.Parameters.Add("@FromMonth", SqlDbType.Int).Value = fromMonth;
                cmd.Parameters.Add("@FromYear", SqlDbType.Int).Value = fromYear;
                cmd.Parameters.Add("@ToMonth", SqlDbType.Int).Value = toMonth;
                cmd.Parameters.Add("@ToYear", SqlDbType.Int).Value = toYear;
                da.Fill(ds);
            }

            return ds;
        }

        private static string ValidatePeriod(int fromMonth, int fromYear, int toMonth, int toYear)
        {
            if (fromMonth < 1 || fromMonth > 12 || toMonth < 1 || toMonth > 12)
                return "Invalid month selection.";

            if (fromYear < 1900 || toYear < 1900)
                return "Invalid year selection.";

            DateTime fromDate = new DateTime(fromYear, fromMonth, 1);
            DateTime toDate = new DateTime(toYear, toMonth, 1);
            return fromDate > toDate ? "From Month-Year cannot be greater than To Month-Year." : string.Empty;
        }


        private static void CreateGrossYearSummarySheet(XLWorkbook workbook, DataTable source, DataTable employeeDetails)
        {
            CreateGrossYearSheet(workbook, "Gross Year Summary", source, employeeDetails);
        }

        private static void CreateYearSummarySheet(XLWorkbook workbook, DataTable source, DataTable employeeDetails)
        {
            CreateGrossYearSheet(workbook, "Year Summary", source, employeeDetails);
        }

        private static void CreateGrossYearSheet(XLWorkbook workbook, string sheetName, DataTable source, DataTable employeeDetails)
        {
            IXLWorksheet ws = workbook.Worksheets.Add(sheetName);
            ws.SheetView.FreezeRows(3);
            if (source.Rows.Count == 0 || !source.Columns.Contains("Year")) { ws.Cell(1, 1).Value = "No data available"; return; }

            Dictionary<string, HashSet<string>> counts = BuildEmployeeCountMap(employeeDetails, false);
            List<string> departments = GetDepartments(source);
            List<DataRow> yearRows = new List<DataRow>();
            foreach (DataRow row in source.Rows) yearRows.Add(row);
            yearRows.Sort((x, y) => Convert.ToInt32(y["Year"]).CompareTo(Convert.ToInt32(x["Year"])));

            int column = 1;
            for (int yearIndex = 0; yearIndex < yearRows.Count; yearIndex++)
            {
                DataRow current = yearRows[yearIndex];
                DataRow previous = yearIndex < yearRows.Count - 1 ? yearRows[yearIndex + 1] : null;
                int year = Convert.ToInt32(current["Year"]);
                int yearStart = column;
                foreach (string department in departments)
                {
                    ws.Range(2, column, 2, column + 2).Merge();
                    ws.Cell(2, column).Value = department;
                    ws.Cell(3, column).Value = "Employee Count";
                    ws.Cell(3, column + 1).Value = "Gross";
                    ws.Cell(3, column + 2).Value = "Gross Dev %";
                    decimal gross = GetRowDecimal(current, department + " - Gross");
                    decimal previousGross = previous == null ? 0 : GetRowDecimal(previous, department + " - Gross");
                    ws.Cell(4, column).Value = GetEmployeeCount(counts, year.ToString(CultureInfo.InvariantCulture), department);
                    ws.Cell(4, column + 1).Value = gross;
                    if (previous != null && previousGross != 0) ws.Cell(4, column + 2).Value = (gross - previousGross) / previousGross;
                    column += 3;
                }
                ws.Range(1, yearStart, 1, column - 1).Merge();
                ws.Cell(1, yearStart).Value = year;
            }
            StyleGrossOnlySummarySheet(ws, column - 1, 4);
        }

        private static List<string> GetDepartments(DataTable source)
        {
            List<string> departments = new List<string>(); const string suffix = " - Gross";
            foreach (DataColumn column in source.Columns)
                if (column.ColumnName.EndsWith(suffix, StringComparison.OrdinalIgnoreCase))
                    departments.Add(column.ColumnName.Substring(0, column.ColumnName.Length - suffix.Length));
            departments.Sort(StringComparer.OrdinalIgnoreCase); return departments;
        }



        private static decimal GetRowDecimal(DataRow row, string columnName)
        {
            return row.Table.Columns.Contains(columnName) ? ToDecimal(row[columnName]) : 0;
        }



        private static void CreateMonthSummarySheet(XLWorkbook workbook, DataTable source, DataTable employeeDetails)
        {
            IXLWorksheet ws = workbook.Worksheets.Add("Month Summary"); ws.SheetView.FreezeRows(3);
            if (source.Rows.Count == 0) { ws.Cell(1, 1).Value = "No data available"; return; }
            Dictionary<string, HashSet<string>> counts = BuildEmployeeCountMap(employeeDetails, true);
            List<SalaryPeriod> periods = new List<SalaryPeriod>();
            List<string> departments = new List<string>();
            Dictionary<int, Dictionary<string, SalaryAmount>> values = new Dictionary<int, Dictionary<string, SalaryAmount>>();
            foreach (DataRow row in source.Rows)
            {
                int year = Convert.ToInt32(row["Year"]); string monthYear = Convert.ToString(row["MonthYear"]);
                int month = GetMonthNumber(row, monthYear); int key = year * 100 + month; string department = Convert.ToString(row["Department"]);
                if (!values.ContainsKey(key)) { values[key] = new Dictionary<string, SalaryAmount>(StringComparer.OrdinalIgnoreCase); periods.Add(new SalaryPeriod { Key = key, Label = monthYear }); }
                if (!departments.Contains(department)) departments.Add(department);
                values[key][department] = new SalaryAmount { Gross = ToDecimal(row["GrossSalary"]) };
            }
            periods.Sort((x, y) => y.Key.CompareTo(x.Key)); departments.Sort(StringComparer.OrdinalIgnoreCase);
            int column = 1;
            for (int periodIndex = 0; periodIndex < periods.Count; periodIndex++)
            {
                SalaryPeriod period = periods[periodIndex]; Dictionary<string, SalaryAmount> current = values[period.Key];
                Dictionary<string, SalaryAmount> previous = periodIndex < periods.Count - 1 ? values[periods[periodIndex + 1].Key] : null; int periodStart = column;
                foreach (string department in departments)
                {
                    ws.Range(2, column, 2, column + 2).Merge(); ws.Cell(2, column).Value = department;
                    ws.Cell(3, column).Value = "Employee Count"; ws.Cell(3, column + 1).Value = "Gross"; ws.Cell(3, column + 2).Value = "Gross Dev %";
                    SalaryAmount currentAmount; SalaryAmount previousAmount;
                    if (!current.TryGetValue(department, out currentAmount)) currentAmount = new SalaryAmount();
                    if (previous == null || !previous.TryGetValue(department, out previousAmount)) previousAmount = null;
                    ws.Cell(4, column).Value = GetEmployeeCount(counts, period.Key.ToString(CultureInfo.InvariantCulture), department);
                    ws.Cell(4, column + 1).Value = currentAmount.Gross;
                    if (previousAmount != null && previousAmount.Gross != 0) ws.Cell(4, column + 2).Value = (currentAmount.Gross - previousAmount.Gross) / previousAmount.Gross;
                    column += 3;
                }
                ws.Range(1, periodStart, 1, column - 1).Merge(); ws.Cell(1, periodStart).Value = period.Label;
            }
            StyleGrossOnlySummarySheet(ws, column - 1, 4);
        }

        private static Dictionary<string, HashSet<string>> BuildEmployeeCountMap(DataTable table, bool monthWise)
        {
            Dictionary<string, HashSet<string>> map = new Dictionary<string, HashSet<string>>(StringComparer.OrdinalIgnoreCase);
            if (table == null || !table.Columns.Contains("Year") || !table.Columns.Contains("Department")) return map;
            foreach (DataRow row in table.Rows)
            {
                string year = Convert.ToString(row["Year"]);
                string department = Convert.ToString(row["Department"]);
                string employee = table.Columns.Contains("Code") ? Convert.ToString(row["Code"]) : Convert.ToString(row["Name"]);
                string period = year;
                if (monthWise)
                {
                    int month = 0;
                    if (table.Columns.Contains("MonthNumber")) int.TryParse(Convert.ToString(row["MonthNumber"]), out month);
                    if (month == 0 && table.Columns.Contains("Month"))
                    {
                        DateTime parsed;
                        if (DateTime.TryParse(Convert.ToString(row["Month"]) + " 1, " + year, out parsed)) month = parsed.Month;
                    }
                    period = (Convert.ToInt32(year) * 100 + month).ToString(CultureInfo.InvariantCulture);
                }
                string key = period + "||" + department;
                HashSet<string> set;
                if (!map.TryGetValue(key, out set)) { set = new HashSet<string>(StringComparer.OrdinalIgnoreCase); map[key] = set; }
                if (!string.IsNullOrWhiteSpace(employee)) set.Add(employee);
            }
            return map;
        }

        private static int GetEmployeeCount(Dictionary<string, HashSet<string>> map, string period, string department)
        {
            HashSet<string> set;
            return map.TryGetValue(period + "||" + department, out set) ? set.Count : 0;
        }

        private static int GetMonthNumber(DataRow row, string monthYear)
        {
            string[] possibleColumns = { "MonthNumber", "MonthNo", "Month" };
            foreach (string column in possibleColumns)
                if (row.Table.Columns.Contains(column)) { int numericMonth; if (int.TryParse(Convert.ToString(row[column]), out numericMonth) && numericMonth >= 1 && numericMonth <= 12) return numericMonth; }
            DateTime parsed; string[] formats = { "MMMM-yyyy", "MMM-yyyy", "MMMM yyyy", "MMM yyyy" };
            if (DateTime.TryParseExact(monthYear, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed)) return parsed.Month;
            if (DateTime.TryParse(monthYear, out parsed)) return parsed.Month; return 0;
        }

        private static void StyleGrossOnlySummarySheet(IXLWorksheet ws, int lastColumn, int dataRow)
        {
            if (lastColumn <= 0) return;
            IXLRange range = ws.Range(1, 1, dataRow, lastColumn);
            range.Style.Border.OutsideBorder = XLBorderStyleValues.Thin; range.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            ws.Range(1, 1, 3, lastColumn).Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
            ws.Range(1, 1, 3, lastColumn).Style.Font.FontColor = XLColor.White; ws.Range(1, 1, 3, lastColumn).Style.Font.Bold = true;
            ws.Range(1, 1, 3, lastColumn).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            ws.Range(1, 1, 3, lastColumn).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
            for (int col = 1; col <= lastColumn; col += 3)
            {
                ws.Cell(dataRow, col).Style.NumberFormat.Format = "0";
                ws.Cell(dataRow, col + 1).Style.NumberFormat.Format = "#,##0.00";
                ws.Cell(dataRow, col + 2).Style.NumberFormat.Format = "0.00%";
            }
            ws.Columns().AdjustToContents(1, 24);
        }

        private sealed class SalaryPeriod { public int Key { get; set; } public string Label { get; set; } }
        private sealed class SalaryAmount { public decimal Gross { get; set; } }

        private static void CreateDashboardDataSheet(XLWorkbook workbook, DataTable source, DataTable employeeDetails)
        {
            IXLWorksheet ws = workbook.Worksheets.Add("Dashboard Data");
            ws.Cell(1, 1).Value = "Month";
            ws.Cell(1, 2).Value = "Total Headcount";
            ws.Cell(1, 3).Value = "Total Gross Salary";
            ws.Cell(1, 4).Value = "Total Net Salary";

            Dictionary<string, HashSet<string>> counts = BuildEmployeeCountMap(employeeDetails, true);
            SortedDictionary<int, SalaryDashboardTotal> totals = new SortedDictionary<int, SalaryDashboardTotal>();
            foreach (DataRow row in source.Rows)
            {
                int year = Convert.ToInt32(row["Year"]);
                string monthYear = Convert.ToString(row["MonthYear"]);
                int month = GetMonthNumber(row, monthYear);
                int key = year * 100 + month;
                SalaryDashboardTotal total;
                if (!totals.TryGetValue(key, out total))
                {
                    total = new SalaryDashboardTotal { Label = monthYear };
                    totals[key] = total;
                }
                total.Gross += ToDecimal(row["GrossSalary"]);
                if (source.Columns.Contains("NetSalary")) total.Net += ToDecimal(row["NetSalary"]);
            }

            int outputRow = 2;
            foreach (KeyValuePair<int, SalaryDashboardTotal> item in totals)
            {
                int headcount = 0;
                string prefix = item.Key.ToString(CultureInfo.InvariantCulture) + "||";
                foreach (KeyValuePair<string, HashSet<string>> count in counts)
                    if (count.Key.StartsWith(prefix, StringComparison.OrdinalIgnoreCase)) headcount += count.Value.Count;

                ws.Cell(outputRow, 1).Value = item.Value.Label;
                ws.Cell(outputRow, 2).Value = headcount;
                ws.Cell(outputRow, 3).Value = item.Value.Gross;
                ws.Cell(outputRow, 4).Value = item.Value.Net;
                outputRow++;
            }

            int lastRow = Math.Max(outputRow - 1, 1);
            ws.Range(1, 1, 1, 4).Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
            ws.Range(1, 1, 1, 4).Style.Font.FontColor = XLColor.White;
            ws.Range(1, 1, 1, 4).Style.Font.Bold = true;
            ws.Range(2, 3, lastRow, 4).Style.NumberFormat.Format = "#,##0.00";
            ws.Range(1, 1, lastRow, 4).SetAutoFilter();
            ws.SheetView.FreezeRows(1);
            ws.Columns().AdjustToContents(1, 24);
        }

        private static void CreateHorizontalMonthlySheet(XLWorkbook workbook, DataTable source, DataTable employeeDetails)
        {
            IXLWorksheet ws = workbook.Worksheets.Add("Monthly Horizontal");
            if (source.Rows.Count == 0)
            {
                ws.Cell(1, 1).Value = "No data available";
                return;
            }

            Dictionary<string, HashSet<string>> counts = BuildEmployeeCountMap(employeeDetails, true);
            SortedDictionary<int, string> periods = new SortedDictionary<int, string>();
            SortedSet<string> departments = new SortedSet<string>(StringComparer.OrdinalIgnoreCase);
            Dictionary<string, SalaryHorizontalAmount> values = new Dictionary<string, SalaryHorizontalAmount>(StringComparer.OrdinalIgnoreCase);

            foreach (DataRow row in source.Rows)
            {
                int year = Convert.ToInt32(row["Year"]);
                string monthYear = Convert.ToString(row["MonthYear"]);
                int month = GetMonthNumber(row, monthYear);
                int periodKey = year * 100 + month;
                string department = Convert.ToString(row["Department"]);
                periods[periodKey] = monthYear;
                departments.Add(department);
                values[periodKey.ToString(CultureInfo.InvariantCulture) + "||" + department] = new SalaryHorizontalAmount
                {
                    Gross = ToDecimal(row["GrossSalary"]),
                    Net = source.Columns.Contains("NetSalary") ? ToDecimal(row["NetSalary"]) : 0M
                };
            }

            ws.Range(1, 1, 2, 1).Merge();
            ws.Cell(1, 1).Value = "Department";
            int column = 2;
            foreach (KeyValuePair<int, string> period in periods)
            {
                ws.Range(1, column, 1, column + 2).Merge();
                ws.Cell(1, column).Value = period.Value;
                ws.Cell(2, column).Value = "Headcount";
                ws.Cell(2, column + 1).Value = "Gross Salary";
                ws.Cell(2, column + 2).Value = "Deviation %";
                column += 3;
            }

            int rowNo = 3;
            foreach (string department in departments)
            {
                ws.Cell(rowNo, 1).Value = department;
                column = 2;
                decimal previousGross = 0M;
                bool hasPrevious = false;
                foreach (KeyValuePair<int, string> period in periods)
                {
                    string key = period.Key.ToString(CultureInfo.InvariantCulture) + "||" + department;
                    SalaryHorizontalAmount amount;
                    if (!values.TryGetValue(key, out amount)) amount = new SalaryHorizontalAmount();
                    ws.Cell(rowNo, column).Value = GetEmployeeCount(counts, period.Key.ToString(CultureInfo.InvariantCulture), department);
                    ws.Cell(rowNo, column + 1).Value = amount.Gross;
                    if (hasPrevious && previousGross != 0M) ws.Cell(rowNo, column + 2).Value = (amount.Gross - previousGross) / previousGross;
                    previousGross = amount.Gross;
                    hasPrevious = true;
                    column += 3;
                }
                rowNo++;
            }

            int lastColumn = column - 1;
            int lastRow = rowNo - 1;
            ws.Range(1, 1, 2, lastColumn).Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
            ws.Range(1, 1, 2, lastColumn).Style.Font.FontColor = XLColor.White;
            ws.Range(1, 1, 2, lastColumn).Style.Font.Bold = true;
            ws.Range(1, 1, 2, lastColumn).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            ws.Range(1, 1, lastRow, lastColumn).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            ws.Range(1, 1, lastRow, lastColumn).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            for (int c = 2; c <= lastColumn; c += 3)
            {
                ws.Range(3, c, lastRow, c).Style.NumberFormat.Format = "0";
                ws.Range(3, c + 1, lastRow, c + 1).Style.NumberFormat.Format = "#,##0.00";
                ws.Range(3, c + 2, lastRow, c + 2).Style.NumberFormat.Format = "0.00%";
            }
            ws.SheetView.FreezeRows(2);
            ws.SheetView.FreezeColumns(1);
            ws.Columns().AdjustToContents(1, 24);
        }

        private sealed class SalaryDashboardTotal { public string Label { get; set; } public decimal Gross { get; set; } public decimal Net { get; set; } }
        private sealed class SalaryHorizontalAmount { public decimal Gross { get; set; } public decimal Net { get; set; } }

        private sealed class MonthlyExportModel
        {
            public SortedDictionary<int, string> Periods { get; set; }
            public List<string> Departments { get; set; }
            public Dictionary<string, decimal> GrossValues { get; set; }
            public Dictionary<string, int> HeadcountValues { get; set; }
        }

        private static MonthlyExportModel BuildMonthlyExportModel(DataTable monthSummary, DataTable employeeDetails)
        {
            MonthlyExportModel model = new MonthlyExportModel
            {
                Periods = new SortedDictionary<int, string>(),
                Departments = new List<string>(),
                GrossValues = new Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase),
                HeadcountValues = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase)
            };

            SortedSet<string> departmentSet = new SortedSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (DataRow row in monthSummary.Rows)
            {
                int year = Convert.ToInt32(row["Year"]);
                string monthYear = Convert.ToString(row["MonthYear"]);
                int month = GetMonthNumber(row, monthYear);
                int periodKey = year * 100 + month;
                string department = Convert.ToString(row["Department"]);

                model.Periods[periodKey] = monthYear;
                departmentSet.Add(department);
                model.GrossValues[periodKey.ToString(CultureInfo.InvariantCulture) + "||" + department] =
                    ToDecimal(row["GrossSalary"]);
            }

            Dictionary<string, HashSet<string>> countMap = BuildEmployeeCountMap(employeeDetails, true);
            foreach (KeyValuePair<string, HashSet<string>> item in countMap)
                model.HeadcountValues[item.Key] = item.Value.Count;

            model.Departments.AddRange(departmentSet);
            return model;
        }

        private static void CreateHeadcountTrendSheet(XLWorkbook workbook, DataTable monthSummary, DataTable employeeDetails)
        {
            MonthlyExportModel model = BuildMonthlyExportModel(monthSummary, employeeDetails);
            IXLWorksheet ws = workbook.Worksheets.Add("Headcount Trend");
            WriteSheetTitle(ws, "Department-wise Headcount Trend");

            List<string> labels = new List<string>();
            List<decimal> totals = new List<decimal>();
            foreach (KeyValuePair<int, string> period in model.Periods)
            {
                labels.Add(period.Value);
                int total = 0;
                foreach (string department in model.Departments)
                {
                    int count;
                    model.HeadcountValues.TryGetValue(period.Key.ToString(CultureInfo.InvariantCulture) + "||" + department, out count);
                    total += count;
                }
                totals.Add(total);
            }

            AddLineChartPicture(ws, "Headcount Trend", labels, totals, false, "B3");
            WriteHorizontalMetricTable(ws, model, 24, ExportMetric.Headcount);
        }

        private static void CreateGrossSalaryTrendSheet(XLWorkbook workbook, DataTable monthSummary, DataTable employeeDetails)
        {
            MonthlyExportModel model = BuildMonthlyExportModel(monthSummary, employeeDetails);
            IXLWorksheet ws = workbook.Worksheets.Add("Gross Salary Trend");
            WriteSheetTitle(ws, "Department-wise Gross Salary Trend");

            List<string> labels = new List<string>();
            List<decimal> totals = new List<decimal>();
            foreach (KeyValuePair<int, string> period in model.Periods)
            {
                labels.Add(period.Value);
                decimal total = 0M;
                foreach (string department in model.Departments)
                {
                    decimal gross;
                    model.GrossValues.TryGetValue(period.Key.ToString(CultureInfo.InvariantCulture) + "||" + department, out gross);
                    total += gross;
                }
                totals.Add(total);
            }

            AddLineChartPicture(ws, "Gross Salary Trend", labels, totals, true, "B3");
            WriteHorizontalMetricTable(ws, model, 24, ExportMetric.Gross);
        }

        private static void CreateSalaryDeviationSheet(XLWorkbook workbook, DataTable monthSummary, DataTable employeeDetails)
        {
            MonthlyExportModel model = BuildMonthlyExportModel(monthSummary, employeeDetails);
            IXLWorksheet ws = workbook.Worksheets.Add("Salary Deviation");
            WriteSheetTitle(ws, "Department-wise Gross Salary Deviation");

            List<string> labels = new List<string>();
            List<decimal> deviations = new List<decimal>();
            decimal previousTotal = 0M;
            bool hasPrevious = false;

            foreach (KeyValuePair<int, string> period in model.Periods)
            {
                labels.Add(period.Value);
                decimal total = 0M;
                foreach (string department in model.Departments)
                {
                    decimal gross;
                    model.GrossValues.TryGetValue(period.Key.ToString(CultureInfo.InvariantCulture) + "||" + department, out gross);
                    total += gross;
                }

                deviations.Add(hasPrevious && previousTotal != 0M
                    ? ((total - previousTotal) / previousTotal) * 100M
                    : 0M);
                previousTotal = total;
                hasPrevious = true;
            }

            AddColumnChartPicture(ws, "Salary Deviation %", labels, deviations, "B3");
            WriteHorizontalMetricTable(ws, model, 24, ExportMetric.Deviation);
        }

        private enum ExportMetric
        {
            Headcount,
            Gross,
            Deviation
        }

        private static void WriteSheetTitle(IXLWorksheet ws, string title)
        {
            ws.Range(1, 1, 1, 10).Merge();
            ws.Cell(1, 1).Value = title;
            ws.Cell(1, 1).Style.Font.Bold = true;
            ws.Cell(1, 1).Style.Font.FontSize = 16;
            ws.Cell(1, 1).Style.Font.FontColor = XLColor.White;
            ws.Cell(1, 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#355A8A");
            ws.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            ws.Row(1).Height = 25;
        }

        private static void WriteHorizontalMetricTable(IXLWorksheet ws, MonthlyExportModel model, int startRow, ExportMetric metric)
        {
            ws.Cell(startRow, 1).Value = "Department";
            int col = 2;
            foreach (KeyValuePair<int, string> period in model.Periods)
                ws.Cell(startRow, col++).Value = period.Value;

            int row = startRow + 1;
            foreach (string department in model.Departments)
            {
                ws.Cell(row, 1).Value = department;
                col = 2;
                decimal previousGross = 0M;
                bool hasPrevious = false;

                foreach (KeyValuePair<int, string> period in model.Periods)
                {
                    string key = period.Key.ToString(CultureInfo.InvariantCulture) + "||" + department;
                    decimal gross;
                    int count;
                    model.GrossValues.TryGetValue(key, out gross);
                    model.HeadcountValues.TryGetValue(key, out count);

                    if (metric == ExportMetric.Headcount)
                        ws.Cell(row, col).Value = count;
                    else if (metric == ExportMetric.Gross)
                        ws.Cell(row, col).Value = gross;
                    else
                    {
                        if (hasPrevious && previousGross != 0M)
                            ws.Cell(row, col).Value = (gross - previousGross) / previousGross;
                    }

                    previousGross = gross;
                    hasPrevious = true;
                    col++;
                }
                row++;
            }

            int lastRow = Math.Max(row - 1, startRow);
            int lastCol = Math.Max(col - 1, 1);
            IXLRange header = ws.Range(startRow, 1, startRow, lastCol);
            header.Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
            header.Style.Font.FontColor = XLColor.White;
            header.Style.Font.Bold = true;
            header.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

            IXLRange dataRange = ws.Range(startRow, 1, lastRow, lastCol);
            dataRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            dataRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            ws.Column(1).Width = 24;
            for (int c = 2; c <= lastCol; c++) ws.Column(c).Width = 15;

            if (metric == ExportMetric.Headcount)
                ws.Range(startRow + 1, 2, lastRow, lastCol).Style.NumberFormat.Format = "0";
            else if (metric == ExportMetric.Gross)
                ws.Range(startRow + 1, 2, lastRow, lastCol).Style.NumberFormat.Format = "#,##0.00";
            else
            {
                IXLRange deviationRange = ws.Range(startRow + 1, 2, lastRow, lastCol);
                deviationRange.Style.NumberFormat.Format = "0.00%";
                deviationRange.AddConditionalFormat().WhenGreaterThan(0).Fill.SetBackgroundColor(XLColor.FromHtml("#E2F0D9")).Font.SetFontColor(XLColor.FromHtml("#006100"));
                deviationRange.AddConditionalFormat().WhenLessThan(0).Fill.SetBackgroundColor(XLColor.FromHtml("#FCE4D6")).Font.SetFontColor(XLColor.FromHtml("#9C0006"));
            }

            ws.SheetView.FreezeRows(startRow);
            ws.SheetView.FreezeColumns(1);
            ws.Range(startRow, 1, lastRow, lastCol).SetAutoFilter();
        }

        private static void AddLineChartPicture(
      IXLWorksheet ws,
      string title,
      List<string> labels,
      List<decimal> values,
      bool currency,
      string cellAddress)
        {
            using (MemoryStream image = DrawLineChart(title, labels, values, currency))
            {
                string pictureName = GetExcelPictureName("Line");

                ws.AddPicture(image, pictureName)
                  .MoveTo(ws.Cell(cellAddress))
                  .WithSize(1000, 380);
            }
        }

        private static void AddColumnChartPicture(
            IXLWorksheet ws,
            string title,
            List<string> labels,
            List<decimal> values,
            string cellAddress)
        {
            using (MemoryStream image = DrawColumnChart(title, labels, values))
            {
                string pictureName = GetExcelPictureName("Column");

                ws.AddPicture(image, pictureName)
                  .MoveTo(ws.Cell(cellAddress))
                  .WithSize(1000, 380);
            }
        }

        private static string GetExcelPictureName(string prefix)
        {
            // Excel picture names must not exceed 31 characters.
            string uniquePart = Guid.NewGuid().ToString("N").Substring(0, 12);

            string name = prefix + "_" + uniquePart;

            return name.Length > 31
                ? name.Substring(0, 31)
                : name;
        }

        private static MemoryStream DrawLineChart(string title, List<string> labels, List<decimal> values, bool currency)
        {
            const int width = 1200;
            const int height = 450;
            Bitmap bitmap = new Bitmap(width, height);
            using (Graphics g = Graphics.FromImage(bitmap))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.Clear(Color.White);
                Rectangle plot = new Rectangle(90, 65, width - 140, height - 145);
                DrawChartFrame(g, plot, title);

                decimal max = values.Count == 0 ? 1M : Math.Max(1M, MaxDecimal(values));
                decimal min = values.Count == 0 ? 0M : Math.Min(0M, MinDecimal(values));
                if (max == min) max = min + 1M;
                DrawYAxis(g, plot, min, max, currency ? "#,##0" : "0");
                DrawXAxis(g, plot, labels);

                if (values.Count > 0)
                {
                    PointF[] points = new PointF[values.Count];
                    for (int i = 0; i < values.Count; i++)
                    {
                        float x = values.Count == 1 ? plot.Left + plot.Width / 2F : plot.Left + (plot.Width * i / (float)(values.Count - 1));
                        float y = plot.Bottom - (float)((values[i] - min) / (max - min)) * plot.Height;
                        points[i] = new PointF(x, y);
                    }
                    using (Pen linePen = new Pen(Color.FromArgb(53, 90, 138), 3F))
                    {
                        if (points.Length > 1) g.DrawLines(linePen, points);
                    }
                    foreach (PointF point in points)
                    {
                        using (Brush b = new SolidBrush(Color.FromArgb(53, 90, 138)))
                            g.FillEllipse(b, point.X - 5, point.Y - 5, 10, 10);
                    }
                }
            }

            MemoryStream stream = new MemoryStream();
            bitmap.Save(stream, ImageFormat.Png);
            bitmap.Dispose();
            stream.Position = 0;
            return stream;
        }

        private static MemoryStream DrawColumnChart(string title, List<string> labels, List<decimal> values)
        {
            const int width = 1200;
            const int height = 450;
            Bitmap bitmap = new Bitmap(width, height);
            using (Graphics g = Graphics.FromImage(bitmap))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.Clear(Color.White);
                Rectangle plot = new Rectangle(90, 65, width - 140, height - 145);
                DrawChartFrame(g, plot, title);

                decimal max = values.Count == 0 ? 1M : Math.Max(1M, MaxDecimal(values));
                decimal min = values.Count == 0 ? -1M : Math.Min(-1M, MinDecimal(values));
                DrawYAxis(g, plot, min, max, "0.0");
                DrawXAxis(g, plot, labels);

                float zeroY = plot.Bottom - (float)((0M - min) / (max - min)) * plot.Height;
                using (Pen zeroPen = new Pen(Color.Gray, 1.5F)) g.DrawLine(zeroPen, plot.Left, zeroY, plot.Right, zeroY);
                float slot = values.Count == 0 ? plot.Width : plot.Width / (float)values.Count;
                float barWidth = Math.Max(10F, slot * 0.58F);

                for (int i = 0; i < values.Count; i++)
                {
                    float x = plot.Left + slot * i + (slot - barWidth) / 2F;
                    float valueY = plot.Bottom - (float)((values[i] - min) / (max - min)) * plot.Height;
                    float top = Math.Min(zeroY, valueY);
                    float barHeight = Math.Abs(zeroY - valueY);
                    Color color = values[i] >= 0M ? Color.FromArgb(112, 173, 71) : Color.FromArgb(192, 80, 77);
                    using (Brush b = new SolidBrush(color)) g.FillRectangle(b, x, top, barWidth, Math.Max(1F, barHeight));
                }
            }

            MemoryStream stream = new MemoryStream();
            bitmap.Save(stream, ImageFormat.Png);
            bitmap.Dispose();
            stream.Position = 0;
            return stream;
        }

        private static void DrawChartFrame(Graphics g, Rectangle plot, string title)
        {
            using (Font titleFont = new Font("Arial", 16F, FontStyle.Bold))
            using (Brush titleBrush = new SolidBrush(Color.FromArgb(30, 55, 90)))
                g.DrawString(title, titleFont, titleBrush, new PointF(plot.Left, 20));

            using (Pen gridPen = new Pen(Color.FromArgb(225, 230, 236), 1F))
                for (int i = 0; i <= 5; i++)
                {
                    float y = plot.Top + plot.Height * i / 5F;
                    g.DrawLine(gridPen, plot.Left, y, plot.Right, y);
                }
            using (Pen borderPen = new Pen(Color.FromArgb(150, 160, 170), 1F))
                g.DrawRectangle(borderPen, plot);
        }

        private static void DrawYAxis(Graphics g, Rectangle plot, decimal min, decimal max, string format)
        {
            using (Font font = new Font("Arial", 9F))
            using (Brush brush = new SolidBrush(Color.DimGray))
            {
                for (int i = 0; i <= 5; i++)
                {
                    decimal value = max - ((max - min) * i / 5M);
                    string text = value.ToString(format, CultureInfo.InvariantCulture);
                    float y = plot.Top + plot.Height * i / 5F - 7F;
                    SizeF size = g.MeasureString(text, font);
                    g.DrawString(text, font, brush, plot.Left - size.Width - 8F, y);
                }
            }
        }

        private static void DrawXAxis(Graphics g, Rectangle plot, List<string> labels)
        {
            if (labels.Count == 0) return;
            using (Font font = new Font("Arial", 8F))
            using (Brush brush = new SolidBrush(Color.DimGray))
            {
                for (int i = 0; i < labels.Count; i++)
                {
                    float x = labels.Count == 1 ? plot.Left + plot.Width / 2F : plot.Left + plot.Width * i / (float)(labels.Count - 1);
                    string label = labels[i];
                    SizeF size = g.MeasureString(label, font);
                    g.DrawString(label, font, brush, x - size.Width / 2F, plot.Bottom + 8F);
                }
            }
        }

        private static decimal MaxDecimal(List<decimal> values)
        {
            decimal max = values[0];
            for (int i = 1; i < values.Count; i++) if (values[i] > max) max = values[i];
            return max;
        }

        private static decimal MinDecimal(List<decimal> values)
        {
            decimal min = values[0];
            for (int i = 1; i < values.Count; i++) if (values[i] < min) min = values[i];
            return min;
        }

        private static void CreateEmployeeDetailsSheet(XLWorkbook workbook, DataTable table)
        {
            IXLWorksheet ws = workbook.Worksheets.Add("Employee Details");

            if (table.Columns.Count == 0)
            {
                ws.Cell(1, 1).Value = "No data available";
                return;
            }

            for (int col = 0; col < table.Columns.Count; col++)
                ws.Cell(1, col + 1).Value = table.Columns[col].ColumnName;

            WriteDataRows(ws, table, 2, 1);

            int lastRow = table.Rows.Count + 1;
            int lastColumn = table.Columns.Count;
            IXLRange usedRange = ws.Range(1, 1, lastRow, lastColumn);
            usedRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            usedRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            ws.Range(1, 1, 1, lastColumn).Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
            ws.Range(1, 1, 1, lastColumn).Style.Font.FontColor = XLColor.White;
            ws.Range(1, 1, 1, lastColumn).Style.Font.Bold = true;
            ws.Range(1, 1, 1, lastColumn).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            ws.Range(1, 1, lastRow, lastColumn).SetAutoFilter();
            ws.SheetView.FreezeRows(1);
            ws.SheetView.FreezeColumns(3);

            ApplyAmountFormatByColumnName(ws, table, lastRow);
            ws.Columns().AdjustToContents(1, 40);
        }

        private static void WriteDataRows(IXLWorksheet ws, DataTable table, int startRow, int startColumn)
        {
            for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
            {
                for (int columnIndex = 0; columnIndex < table.Columns.Count; columnIndex++)
                {
                    object value = table.Rows[rowIndex][columnIndex];
                    IXLCell cell = ws.Cell(startRow + rowIndex, startColumn + columnIndex);

                    if (value == DBNull.Value || value == null)
                        cell.Value = string.Empty;
                    else if (value is DateTime)
                    {
                        cell.Value = (DateTime)value;
                        cell.Style.DateFormat.Format = "dd-MMM-yyyy";
                    }
                    else if (IsNumericType(value.GetType()))
                        cell.Value = Convert.ToDecimal(value, CultureInfo.InvariantCulture);
                    else
                        cell.Value = Convert.ToString(value);
                }
            }
        }

        private static void StyleSummarySheet(IXLWorksheet ws, int headerRows, int lastColumn, int lastRow)
        {
            IXLRange usedRange = ws.Range(1, 1, Math.Max(lastRow, headerRows), Math.Max(lastColumn, 1));
            usedRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            usedRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

            IXLRange header = ws.Range(1, 1, headerRows, lastColumn);
            header.Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
            header.Style.Font.FontColor = XLColor.White;
            header.Style.Font.Bold = true;
            header.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            header.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
            header.Style.Alignment.WrapText = true;

            if (lastRow > headerRows && lastColumn > 1)
                ws.Range(headerRows + 1, 2, lastRow, lastColumn).Style.NumberFormat.Format = "#,##0.00";

            ws.Columns().AdjustToContents(1, 30);
            ws.Column(1).Width = Math.Max(ws.Column(1).Width, 12);
        }

        private static void ApplyAmountFormatByColumnName(IXLWorksheet ws, DataTable table, int lastRow)
        {
            for (int col = 0; col < table.Columns.Count; col++)
            {
                string name = table.Columns[col].ColumnName;
                if (name.IndexOf("Salary", StringComparison.OrdinalIgnoreCase) >= 0 ||
                    name.EndsWith("Gross", StringComparison.OrdinalIgnoreCase) ||
                    name.EndsWith("Net", StringComparison.OrdinalIgnoreCase))
                {
                    ws.Range(2, col + 1, lastRow, col + 1).Style.NumberFormat.Format = "#,##0.00";
                }
            }
        }

        private static decimal ToDecimal(object value)
        {
            if (value == null || value == DBNull.Value)
                return 0M;

            decimal result;
            return decimal.TryParse(Convert.ToString(value), out result) ? result : 0M;
        }

        private static bool IsNumericType(Type type)
        {
            return type == typeof(byte) || type == typeof(short) || type == typeof(int) ||
                   type == typeof(long) || type == typeof(float) || type == typeof(double) ||
                   type == typeof(decimal) || type == typeof(sbyte) || type == typeof(ushort) ||
                   type == typeof(uint) || type == typeof(ulong);
        }

        private void ShowExportError(string message)
        {
            string safeMessage = HttpUtility.JavaScriptStringEncode(message);
            ClientScript.RegisterStartupScript(GetType(), "SalaryExportError", "alert('" + safeMessage + "');", true);
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (DataRow row in table.Rows)
            {
                Dictionary<string, object> item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                    item[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
                rows.Add(item);
            }
            return rows;
        }
    }

    public class SalaryReportResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public List<Dictionary<string, object>> YearSummary { get; set; }
        public List<Dictionary<string, object>> MonthDetails { get; set; }
        public List<Dictionary<string, object>> EmployeeDetails { get; set; }

        public static SalaryReportResponse Fail(string message)
        {
            return new SalaryReportResponse
            {
                Success = false,
                Message = message,
                YearSummary = new List<Dictionary<string, object>>(),
                MonthDetails = new List<Dictionary<string, object>>(),
                EmployeeDetails = new List<Dictionary<string, object>>()
            };
        }
    }
}
