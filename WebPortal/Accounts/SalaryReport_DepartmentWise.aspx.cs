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
                DataSet previousYearDs = GetPreviousYearComparisonData(ds, fromMonth, fromYear, toMonth, toYear);
                using (XLWorkbook workbook = new XLWorkbook())
                {
                    DataTable yearSummary = ds.Tables.Count > 0 ? ds.Tables[0] : new DataTable();
                    DataTable monthSummary = ds.Tables.Count > 1 ? ds.Tables[1] : new DataTable();
                    DataTable employeeDetails = ds.Tables.Count > 2 ? ds.Tables[2] : new DataTable();
                    DataTable previousMonthSummary = previousYearDs != null && previousYearDs.Tables.Count > 1
                        ? previousYearDs.Tables[1]
                        : new DataTable();
                    DataTable previousEmployeeDetails = previousYearDs != null && previousYearDs.Tables.Count > 2
                        ? previousYearDs.Tables[2]
                        : new DataTable();
                    CreateHeadcountTrendSheet(workbook, monthSummary, employeeDetails, previousMonthSummary, previousEmployeeDetails);
                    CreateGrossSalaryTrendSheet(workbook, monthSummary, employeeDetails, previousMonthSummary, previousEmployeeDetails);
                    CreateYearOverYearSalaryDeviationSheet(workbook, employeeDetails, previousEmployeeDetails, fromMonth, fromYear, toMonth, toYear);
                    CreateDashboardDataSheet(workbook, monthSummary, employeeDetails);
                    CreateHorizontalMonthlySheet(workbook, monthSummary, employeeDetails);
                    CreateYearComparisonSheet(workbook, employeeDetails, previousEmployeeDetails, fromMonth, fromYear, toMonth, toYear);
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

        private static DataSet GetPreviousYearComparisonData(DataSet currentData, int fromMonth, int fromYear, int toMonth, int toYear)
        {
            // The review workbook asks for a like-for-like Jan-Jul 2026 vs Jan-Jul 2025 comparison.
            // Only a single-year selection can be compared cleanly to the same months of the prior year.
            if (fromYear != toYear || fromYear <= 1900)
                return null;

            int lastAvailableMonth = GetLastAvailableMonth(currentData, fromMonth, toMonth);
            if (lastAvailableMonth < fromMonth)
                lastAvailableMonth = toMonth;

            return GetSalaryData(fromMonth, fromYear - 1, lastAvailableMonth, fromYear - 1);
        }

        private static int GetLastAvailableMonth(DataSet data, int fromMonth, int requestedToMonth)
        {
            if (data == null || data.Tables.Count < 2 || data.Tables[1].Rows.Count == 0)
                return requestedToMonth;

            DataTable monthSummary = data.Tables[1];
            int maximumMonth = 0;
            foreach (DataRow row in monthSummary.Rows)
            {
                string label = monthSummary.Columns.Contains("MonthYear") ? Convert.ToString(row["MonthYear"]) : string.Empty;
                int month = GetMonthNumber(row, label);
                if (month >= fromMonth && month <= requestedToMonth)
                    maximumMonth = Math.Max(maximumMonth, month);
            }
            return maximumMonth == 0 ? requestedToMonth : maximumMonth;
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


        private static void CreateYearComparisonSheet(
            XLWorkbook workbook,
            DataTable currentEmployees,
            DataTable previousEmployees,
            int fromMonth,
            int currentYear,
            int requestedToMonth,
            int toYear)
        {
            IXLWorksheet ws = workbook.Worksheets.Add("Year Summary");
            if (currentYear != toYear)
            {
                ws.Cell(1, 1).Value = "Year-on-year comparison is available for a single-year selection.";
                return;
            }

            int toMonth = GetMaximumMonthFromEmployeeDetails(currentEmployees, requestedToMonth);
            int previousYear = currentYear - 1;
            Dictionary<string, YearDepartmentTotal> current = BuildYearDepartmentTotals(currentEmployees, currentYear, fromMonth, toMonth);
            Dictionary<string, YearDepartmentTotal> previous = BuildYearDepartmentTotals(previousEmployees, previousYear, fromMonth, toMonth);
            SortedSet<string> departments = new SortedSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (string key in current.Keys) departments.Add(key);
            foreach (string key in previous.Keys) departments.Add(key);
            string currentLabel = GetMonthRangeLabel(fromMonth, toMonth, currentYear);
            string previousLabel = GetMonthRangeLabel(fromMonth, toMonth, previousYear);
            ws.Range(1, 1, 1, 8).Merge();
            ws.Cell(1, 1).Value = "Project Manager-wise Salary & Headcount Comparison — " + currentLabel + " vs " + previousLabel;
            ws.Cell(1, 1).Style.Font.Bold = true;
            ws.Cell(1, 1).Style.Font.FontSize = 15;
            ws.Cell(1, 1).Style.Font.FontColor = XLColor.White;
            ws.Cell(1, 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#355A8A");

            string[] headers = { "Project Manager", "Department", currentLabel + " Employee Count", currentLabel + " Total Salaries", previousLabel + " Employee Count", previousLabel + " Total Salaries", "Deviation INR", "Deviation %" };
            for (int c = 0; c < headers.Length; c++) ws.Cell(3, c + 1).Value = headers[c];

            int rowNo = 4;
            foreach (string department in departments)
            {
                YearDepartmentTotal currentValue;
                YearDepartmentTotal previousValue;
                if (!current.TryGetValue(department, out currentValue)) currentValue = new YearDepartmentTotal();
                if (!previous.TryGetValue(department, out previousValue)) previousValue = new YearDepartmentTotal();
                decimal deviation = currentValue.Gross - previousValue.Gross;

                ws.Cell(rowNo, 1).Value = GetManagerFromPmDepartmentKey(department);
                ws.Cell(rowNo, 2).Value = GetDepartmentFromPmDepartmentKey(department);
                ws.Cell(rowNo, 3).Value = currentValue.Employees.Count;
                ws.Cell(rowNo, 4).Value = currentValue.Gross;
                ws.Cell(rowNo, 5).Value = previousValue.Employees.Count;
                ws.Cell(rowNo, 6).Value = previousValue.Gross;
                ws.Cell(rowNo, 7).Value = deviation;
                if (previousValue.Gross != 0M) ws.Cell(rowNo, 8).Value = deviation / previousValue.Gross;
                rowNo++;
            }

            int lastRow = Math.Max(4, rowNo - 1);
            IXLRange header = ws.Range(3, 1, 3, 8);
            header.Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
            header.Style.Font.FontColor = XLColor.White;
            header.Style.Font.Bold = true;
            header.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            ws.Range(3, 1, lastRow, 8).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            ws.Range(3, 1, lastRow, 8).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            if (lastRow >= 4)
            {
                ws.Range(4, 3, lastRow, 3).Style.NumberFormat.Format = "0";
                ws.Range(4, 4, lastRow, 4).Style.NumberFormat.Format = "#,##0.00";
                ws.Range(4, 5, lastRow, 5).Style.NumberFormat.Format = "0";
                ws.Range(4, 6, lastRow, 7).Style.NumberFormat.Format = "#,##0.00";
                ws.Range(4, 8, lastRow, 8).Style.NumberFormat.Format = "0.00%";
                ws.Range(4, 7, lastRow, 8).AddConditionalFormat().WhenGreaterThan(0).Fill.SetBackgroundColor(XLColor.FromHtml("#E2F0D9"));
                ws.Range(4, 7, lastRow, 8).AddConditionalFormat().WhenLessThan(0).Fill.SetBackgroundColor(XLColor.FromHtml("#FCE4D6"));
            }
            ws.SheetView.FreezeRows(3);
            ws.Range(3, 1, lastRow, 8).SetAutoFilter();
            ws.Columns().AdjustToContents(1, 38);
            ws.Column(1).Width = Math.Max(ws.Column(1).Width, 18);
            ws.Column(2).Width = Math.Max(ws.Column(2).Width, 30);

            ws.Cell(lastRow + 3, 1).Value = "Data availability note:";
            ws.Cell(lastRow + 3, 1).Style.Font.Bold = true;
            ws.Cell(lastRow + 3, 2).Value = "The current salary detail result contains Gross/Net Salary and Reporting Manager, but no separate numeric side-remuneration, productivity-target or accuracy-target fields. Those metrics are therefore not fabricated in this export.";
            ws.Range(lastRow + 3, 2, lastRow + 4, 8).Merge();
            ws.Cell(lastRow + 3, 2).Style.Alignment.WrapText = true;
        }

        private static int GetMaximumMonthFromEmployeeDetails(DataTable table, int fallbackMonth)
        {
            if (table == null || table.Rows.Count == 0) return fallbackMonth;
            int maximum = 0;
            foreach (DataRow row in table.Rows)
            {
                string label = GetStringValue(row, "MonthYear", "Month");
                int month = GetMonthNumber(row, label);
                maximum = Math.Max(maximum, month);
            }
            return maximum == 0 ? fallbackMonth : Math.Min(maximum, fallbackMonth);
        }

        private static string GetMonthRangeLabel(int fromMonth, int toMonth, int year)
        {
            string from = CultureInfo.InvariantCulture.DateTimeFormat.GetAbbreviatedMonthName(fromMonth);
            string to = CultureInfo.InvariantCulture.DateTimeFormat.GetAbbreviatedMonthName(toMonth);
            return from + " to " + to + " " + year.ToString(CultureInfo.InvariantCulture);
        }

        private static Dictionary<string, YearDepartmentTotal> BuildYearDepartmentTotals(DataTable table, int year, int fromMonth, int toMonth)
        {
            Dictionary<string, YearDepartmentTotal> totals = new Dictionary<string, YearDepartmentTotal>(StringComparer.OrdinalIgnoreCase);
            if (table == null || !table.Columns.Contains("Year") || !table.Columns.Contains("Department")) return totals;

            foreach (DataRow row in table.Rows)
            {
                int rowYear;
                if (!int.TryParse(Convert.ToString(row["Year"]), out rowYear) || rowYear != year) continue;
                string monthLabel = GetStringValue(row, "MonthYear", "Month");
                int month = GetMonthNumber(row, monthLabel);
                if (month < fromMonth || month > toMonth) continue;

                string department = Convert.ToString(row["Department"]).Trim();
                if (department.Length == 0) department = "(Not Assigned)";
                string manager = GetStringValue(row, "Reporting Manager", "Project Manager").Trim();
                if (manager.Length == 0) manager = "(Not Assigned)";
                string key = MakePmDepartmentKey(manager, department);

                YearDepartmentTotal total;
                if (!totals.TryGetValue(key, out total))
                {
                    total = new YearDepartmentTotal { Employees = new HashSet<string>(StringComparer.OrdinalIgnoreCase) };
                    totals[key] = total;
                }
                string employee = GetStringValue(row, "Code", "EmployeeID", "EmployeeCode", "Name");
                if (!string.IsNullOrWhiteSpace(employee)) total.Employees.Add(employee.Trim());
                total.Gross += GetDecimalValue(row, "Gross Salary", "GrossSalary", "Gross");
            }
            return totals;
        }

        private static string MakePmDepartmentKey(string manager, string department)
        {
            return (string.IsNullOrWhiteSpace(manager) ? "(Not Assigned)" : manager.Trim()) + "||" +
                   (string.IsNullOrWhiteSpace(department) ? "(Not Assigned)" : department.Trim());
        }

        private static string GetManagerFromPmDepartmentKey(string key)
        {
            if (string.IsNullOrWhiteSpace(key)) return "(Not Assigned)";
            int separator = key.IndexOf("||", StringComparison.Ordinal);
            return separator < 0 ? "(Not Assigned)" : key.Substring(0, separator);
        }

        private static string GetDepartmentFromPmDepartmentKey(string key)
        {
            if (string.IsNullOrWhiteSpace(key)) return "(Not Assigned)";
            int separator = key.IndexOf("||", StringComparison.Ordinal);
            return separator < 0 ? key : key.Substring(separator + 2);
        }

        private static string GetPmDepartmentDisplayLabel(string key)
        {
            return GetManagerFromPmDepartmentKey(key) + " - " + GetDepartmentFromPmDepartmentKey(key);
        }

        private sealed class YearDepartmentTotal
        {
            public YearDepartmentTotal() { Employees = new HashSet<string>(StringComparer.OrdinalIgnoreCase); }
            public HashSet<string> Employees { get; set; }
            public decimal Gross { get; set; }
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

        private static void CreateYearOverYearSalaryDeviationSheet(
            XLWorkbook workbook,
            DataTable currentEmployees,
            DataTable previousEmployees,
            int fromMonth,
            int currentYear,
            int requestedToMonth,
            int toYear)
        {
            IXLWorksheet ws = workbook.Worksheets.Add("Salary Deviation");
            if (currentYear != toYear)
            {
                ws.Cell(1, 1).Value = "Year-on-year salary deviation is available for a single-year selection.";
                return;
            }

            int toMonth = GetMaximumMonthFromEmployeeDetails(currentEmployees, requestedToMonth);
            int previousYear = currentYear - 1;
            Dictionary<string, YearDepartmentTotal> current = BuildYearDepartmentTotals(currentEmployees, currentYear, fromMonth, toMonth);
            Dictionary<string, YearDepartmentTotal> previous = BuildYearDepartmentTotals(previousEmployees, previousYear, fromMonth, toMonth);
            SortedSet<string> departments = new SortedSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (string department in current.Keys) departments.Add(department);
            foreach (string department in previous.Keys) departments.Add(department);

            string currentLabel = GetMonthRangeLabel(fromMonth, toMonth, currentYear);
            string previousLabel = GetMonthRangeLabel(fromMonth, toMonth, previousYear);
            ws.Range(1, 1, 1, 6).Merge();
            ws.Cell(1, 1).Value = "Project Manager-wise Salary Deviation — " + currentLabel + " minus " + previousLabel;
            ws.Cell(1, 1).Style.Font.Bold = true;
            ws.Cell(1, 1).Style.Font.FontSize = 15;
            ws.Cell(1, 1).Style.Font.FontColor = XLColor.White;
            ws.Cell(1, 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#355A8A");

            AddYearOverYearSalaryComparisonPicture(ws, current, previous, departments, currentLabel, previousLabel, "H3");

            string[] headers = { "Project Manager", "Department", currentLabel + " Total Salary", previousLabel + " Total Salary", "Deviation INR", "Deviation %" };
            for (int c = 0; c < headers.Length; c++) ws.Cell(3, c + 1).Value = headers[c];

            List<string> orderedDepartments = new List<string>(departments);
            orderedDepartments.Sort(delegate (string left, string right)
            {
                int managerCompare = StringComparer.OrdinalIgnoreCase.Compare(
                    GetManagerFromPmDepartmentKey(left),
                    GetManagerFromPmDepartmentKey(right));
                return managerCompare != 0
                    ? managerCompare
                    : StringComparer.OrdinalIgnoreCase.Compare(
                        GetDepartmentFromPmDepartmentKey(left),
                        GetDepartmentFromPmDepartmentKey(right));
            });

            int rowNo = 4;
            foreach (string department in orderedDepartments)
            {
                YearDepartmentTotal currentValue;
                YearDepartmentTotal previousValue;
                if (!current.TryGetValue(department, out currentValue)) currentValue = new YearDepartmentTotal();
                if (!previous.TryGetValue(department, out previousValue)) previousValue = new YearDepartmentTotal();
                decimal deviation = currentValue.Gross - previousValue.Gross;

                ws.Cell(rowNo, 1).Value = GetManagerFromPmDepartmentKey(department);
                ws.Cell(rowNo, 2).Value = GetDepartmentFromPmDepartmentKey(department);
                ws.Cell(rowNo, 3).Value = currentValue.Gross;
                ws.Cell(rowNo, 4).Value = previousValue.Gross;
                ws.Cell(rowNo, 5).Value = deviation;
                if (previousValue.Gross != 0M) ws.Cell(rowNo, 6).Value = deviation / previousValue.Gross;
                rowNo++;
            }

            int lastRow = Math.Max(4, rowNo - 1);
            IXLRange header = ws.Range(3, 1, 3, 6);
            header.Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
            header.Style.Font.FontColor = XLColor.White;
            header.Style.Font.Bold = true;
            header.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            ws.Range(3, 1, lastRow, 6).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            ws.Range(3, 1, lastRow, 6).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            if (lastRow >= 4)
            {
                ws.Range(4, 3, lastRow, 5).Style.NumberFormat.Format = "#,##0.00";
                ws.Range(4, 6, lastRow, 6).Style.NumberFormat.Format = "0.00%";
                ws.Range(4, 5, lastRow, 6).AddConditionalFormat().WhenGreaterThan(0).Fill.SetBackgroundColor(XLColor.FromHtml("#E2F0D9")).Font.SetFontColor(XLColor.FromHtml("#006100"));
                ws.Range(4, 5, lastRow, 6).AddConditionalFormat().WhenLessThan(0).Fill.SetBackgroundColor(XLColor.FromHtml("#FCE4D6")).Font.SetFontColor(XLColor.FromHtml("#9C0006"));
            }
            ws.SheetView.FreezeRows(3);
            ws.Range(3, 1, lastRow, 6).SetAutoFilter();
            ws.Columns().AdjustToContents(1, 36);
        }

        private static void CreateDashboardDataSheet(XLWorkbook workbook, DataTable source, DataTable employeeDetails)
        {
            IXLWorksheet ws = workbook.Worksheets.Add("Dashboard Data");
            ws.Cell(1, 1).Value = "Month";
            ws.Cell(1, 2).Value = "Location";
            ws.Cell(1, 3).Value = "Domain";
            ws.Cell(1, 4).Value = "Corrected Domain";
            ws.Cell(1, 5).Value = "Subdomain";
            ws.Cell(1, 6).Value = "Total Headcount";
            ws.Cell(1, 7).Value = "% of Total Force";
            ws.Cell(1, 8).Value = "Total Gross Salary";
            ws.Cell(1, 9).Value = "Total Net Salary";
            ws.Cell(1, 10).Value = "% of Total Salary";

            SortedDictionary<string, SalaryDashboardTotal> totals = BuildDashboardTotals(employeeDetails);
            if (totals.Count == 0)
                AddUnassignedDashboardTotals(totals, source);

            Dictionary<string, int> monthHeadcount = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            Dictionary<string, decimal> monthNet = new Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase);
            foreach (KeyValuePair<string, SalaryDashboardTotal> item in totals)
            {
                string month = item.Value.Label;
                monthHeadcount[month] = (monthHeadcount.ContainsKey(month) ? monthHeadcount[month] : 0) + item.Value.Employees.Count;
                monthNet[month] = (monthNet.ContainsKey(month) ? monthNet[month] : 0M) + item.Value.Net;
            }

            int outputRow = 2;
            foreach (KeyValuePair<string, SalaryDashboardTotal> item in totals)
            {
                SalaryDashboardTotal value = item.Value;
                int totalForce = monthHeadcount.ContainsKey(value.Label) ? monthHeadcount[value.Label] : 0;
                decimal totalSalary = monthNet.ContainsKey(value.Label) ? monthNet[value.Label] : 0M;
                ws.Cell(outputRow, 1).Value = value.Label;
                ws.Cell(outputRow, 2).Value = value.Location;
                ws.Cell(outputRow, 3).Value = value.Domain;
                ws.Cell(outputRow, 4).Value = value.CorrectedDomain;
                ws.Cell(outputRow, 5).Value = value.Subdomain;
                ws.Cell(outputRow, 6).Value = value.Employees.Count;
                ws.Cell(outputRow, 7).Value = totalForce == 0 ? 0M : (decimal)value.Employees.Count / totalForce;
                ws.Cell(outputRow, 8).Value = value.Gross;
                ws.Cell(outputRow, 9).Value = value.Net;
                ws.Cell(outputRow, 10).Value = totalSalary == 0M ? 0M : value.Net / totalSalary;
                outputRow++;
            }

            int lastRow = Math.Max(outputRow - 1, 1);
            ws.Range(1, 1, 1, 10).Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
            ws.Range(1, 1, 1, 10).Style.Font.FontColor = XLColor.White;
            ws.Range(1, 1, 1, 10).Style.Font.Bold = true;
            if (lastRow > 1)
            {
                ws.Range(2, 6, lastRow, 6).Style.NumberFormat.Format = "0";
                ws.Range(2, 7, lastRow, 7).Style.NumberFormat.Format = "0.00%";
                ws.Range(2, 8, lastRow, 9).Style.NumberFormat.Format = "#,##0.00";
                ws.Range(2, 10, lastRow, 10).Style.NumberFormat.Format = "0.00%";
            }
            ws.Range(1, 1, lastRow, 10).SetAutoFilter();
            ws.SheetView.FreezeRows(1);
            ws.Columns().AdjustToContents(1, 28);
        }

        private static SortedDictionary<string, SalaryDashboardTotal> BuildDashboardTotals(DataTable employeeDetails)
        {
            SortedDictionary<string, SalaryDashboardTotal> totals = new SortedDictionary<string, SalaryDashboardTotal>(StringComparer.OrdinalIgnoreCase);
            if (employeeDetails == null || employeeDetails.Rows.Count == 0 || !employeeDetails.Columns.Contains("Year"))
                return totals;

            foreach (DataRow row in employeeDetails.Rows)
            {
                int year;
                if (!int.TryParse(Convert.ToString(row["Year"]), out year)) continue;

                string monthLabel = GetStringValue(row, "MonthYear", "Month");
                int month = GetMonthNumber(row, monthLabel);
                if (month < 1 || month > 12) continue;

                int periodKey = year * 100 + month;
                string location = GetDimensionValue(row, "Location", "Branch", "WorkingBranch", "WorkingBranchName");
                string domain = GetDimensionValue(row, "Domain", "DomainName");
                string subdomain = GetDimensionValue(row, "Subdomain", "SubDomain", "SubdomainName", "SubDomainName");
                string correctedDomain = GetCorrectedDashboardDomain(row, domain);
                string key = periodKey.ToString("D6", CultureInfo.InvariantCulture) + "||" + location + "||" + domain + "||" + correctedDomain + "||" + subdomain;

                SalaryDashboardTotal total;
                if (!totals.TryGetValue(key, out total))
                {
                    total = new SalaryDashboardTotal
                    {
                        Label = GetShortPeriodLabel(periodKey, monthLabel),
                        Location = location,
                        Domain = domain,
                        CorrectedDomain = correctedDomain,
                        Subdomain = subdomain,
                        Employees = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
                    };
                    totals[key] = total;
                }

                string employee = GetStringValue(row, "Code", "EmployeeID", "EmployeeCode", "Name");
                if (!string.IsNullOrWhiteSpace(employee)) total.Employees.Add(employee.Trim());
                total.Gross += GetDecimalValue(row, "GrossSalary", "Gross Salary", "Gross");
                total.Net += GetDecimalValue(row, "NetSalary", "Net Salary", "Net");
            }

            return totals;
        }

        private static void AddUnassignedDashboardTotals(SortedDictionary<string, SalaryDashboardTotal> totals, DataTable source)
        {
            if (source == null || !source.Columns.Contains("Year")) return;

            foreach (DataRow row in source.Rows)
            {
                int year;
                if (!int.TryParse(Convert.ToString(row["Year"]), out year)) continue;
                string monthLabel = GetStringValue(row, "MonthYear", "Month");
                int month = GetMonthNumber(row, monthLabel);
                if (month < 1 || month > 12) continue;

                int periodKey = year * 100 + month;
                string key = periodKey.ToString("D6", CultureInfo.InvariantCulture) + "||(Not Assigned)||(Not Assigned)||(Not Assigned)";
                SalaryDashboardTotal total;
                if (!totals.TryGetValue(key, out total))
                {
                    total = new SalaryDashboardTotal
                    {
                        Label = GetShortPeriodLabel(periodKey, monthLabel),
                        Location = "(Not Assigned)",
                        Domain = "(Not Assigned)",
                        CorrectedDomain = "(Not Assigned)",
                        Subdomain = "(Not Assigned)",
                        Employees = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
                    };
                    totals[key] = total;
                }
                total.Gross += GetDecimalValue(row, "GrossSalary", "Gross Salary", "Gross");
                total.Net += GetDecimalValue(row, "NetSalary", "Net Salary", "Net");
            }
        }

        private static string GetCorrectedDashboardDomain(DataRow row, string rawDomain)
        {
            string domain = (rawDomain ?? string.Empty).Trim();
            string department = GetStringValue(row, "DepartmentName", "Department").Trim();

            // Reviewer requested the Title variants to be shown as one Title domain.
            if (domain.StartsWith("Title-", StringComparison.OrdinalIgnoreCase))
                return "Title";

            // Generic Support/Others obscures the real support function. DepartmentName is available
            // in the detail result and gives Accounts/Admin/HR/IT/Legal/etc. without inventing a mapping.
            if ((domain.Equals("Support", StringComparison.OrdinalIgnoreCase) || domain.Equals("Others", StringComparison.OrdinalIgnoreCase))
                && !string.IsNullOrWhiteSpace(department))
                return department;

            return string.IsNullOrWhiteSpace(domain) ? "(Not Assigned)" : domain;
        }

        private static string GetDimensionValue(DataRow row, params string[] columnNames)
        {
            string value = GetStringValue(row, columnNames);
            return string.IsNullOrWhiteSpace(value) ? "(Not Assigned)" : value.Trim();
        }

        private static string GetStringValue(DataRow row, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
                if (row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value)
                    return Convert.ToString(row[columnName]);
            return string.Empty;
        }

        private static decimal GetDecimalValue(DataRow row, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
                if (row.Table.Columns.Contains(columnName))
                    return ToDecimal(row[columnName]);
            return 0M;
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
            ws.Columns().AdjustToContents(1, 24);
        }

        private sealed class SalaryDashboardTotal
        {
            public string Label { get; set; }
            public string Location { get; set; }
            public string Domain { get; set; }
            public string CorrectedDomain { get; set; }
            public string Subdomain { get; set; }
            public HashSet<string> Employees { get; set; }
            public decimal Gross { get; set; }
            public decimal Net { get; set; }
        }
        private sealed class SalaryHorizontalAmount { public decimal Gross { get; set; } public decimal Net { get; set; } }

        private sealed class MonthlyExportModel
        {
            public SortedDictionary<int, string> Periods { get; set; }
            public List<string> Departments { get; set; }
            public Dictionary<string, decimal> GrossValues { get; set; }
            public Dictionary<string, int> HeadcountValues { get; set; }
            public Dictionary<string, string> DepartmentManagers { get; set; }
        }

        private sealed class DepartmentChartSeries
        {
            public string Department { get; set; }
            public List<decimal> Values { get; set; }
            public Color Color { get; set; }
        }

        private static MonthlyExportModel BuildMonthlyExportModel(DataTable monthSummary, DataTable employeeDetails)
        {
            MonthlyExportModel model = new MonthlyExportModel
            {
                Periods = new SortedDictionary<int, string>(),
                Departments = new List<string>(),
                GrossValues = new Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase),
                HeadcountValues = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase),
                DepartmentManagers = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            };

            // Keep period labels from the monthly result when available.
            if (monthSummary != null)
            {
                foreach (DataRow row in monthSummary.Rows)
                {
                    int year;
                    if (!int.TryParse(Convert.ToString(row["Year"]), out year)) continue;
                    string monthYear = GetStringValue(row, "MonthYear", "Month");
                    int month = GetMonthNumber(row, monthYear);
                    if (month < 1 || month > 12) continue;
                    model.Periods[year * 100 + month] = monthYear;
                }
            }

            SortedSet<string> pmDepartmentKeys = new SortedSet<string>(StringComparer.OrdinalIgnoreCase);
            Dictionary<string, HashSet<string>> employeeSets = new Dictionary<string, HashSet<string>>(StringComparer.OrdinalIgnoreCase);

            // PM-wise bifurcation must be calculated from employee-level data, not the department summary.
            if (employeeDetails != null && employeeDetails.Columns.Contains("Year") && employeeDetails.Columns.Contains("Department"))
            {
                foreach (DataRow row in employeeDetails.Rows)
                {
                    int year;
                    if (!int.TryParse(Convert.ToString(row["Year"]), out year)) continue;
                    string monthYear = GetStringValue(row, "MonthYear", "Month");
                    int month = GetMonthNumber(row, monthYear);
                    if (month < 1 || month > 12) continue;

                    int periodKey = year * 100 + month;
                    if (!model.Periods.ContainsKey(periodKey))
                        model.Periods[periodKey] = GetShortPeriodLabel(periodKey, monthYear);

                    string department = GetStringValue(row, "Department").Trim();
                    if (department.Length == 0) department = "(Not Assigned)";
                    string manager = GetStringValue(row, "Reporting Manager", "Project Manager").Trim();
                    if (manager.Length == 0) manager = "(Not Assigned)";
                    string pmDepartmentKey = MakePmDepartmentKey(manager, department);
                    pmDepartmentKeys.Add(pmDepartmentKey);
                    model.DepartmentManagers[pmDepartmentKey] = manager;

                    string valueKey = periodKey.ToString(CultureInfo.InvariantCulture) + "||" + pmDepartmentKey;
                    decimal existingGross;
                    model.GrossValues.TryGetValue(valueKey, out existingGross);
                    model.GrossValues[valueKey] = existingGross + GetDecimalValue(row, "GrossSalary", "Gross Salary", "Gross");

                    HashSet<string> employees;
                    if (!employeeSets.TryGetValue(valueKey, out employees))
                    {
                        employees = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                        employeeSets[valueKey] = employees;
                    }
                    string employee = GetStringValue(row, "Code", "EmployeeID", "EmployeeCode", "Name");
                    if (!string.IsNullOrWhiteSpace(employee)) employees.Add(employee.Trim());
                }
            }

            foreach (KeyValuePair<string, HashSet<string>> item in employeeSets)
                model.HeadcountValues[item.Key] = item.Value.Count;

            model.Departments.AddRange(pmDepartmentKeys);
            model.Departments.Sort(delegate (string left, string right)
            {
                int managerCompare = StringComparer.OrdinalIgnoreCase.Compare(
                    GetManagerFromPmDepartmentKey(left),
                    GetManagerFromPmDepartmentKey(right));
                return managerCompare != 0
                    ? managerCompare
                    : StringComparer.OrdinalIgnoreCase.Compare(
                        GetDepartmentFromPmDepartmentKey(left),
                        GetDepartmentFromPmDepartmentKey(right));
            });
            return model;
        }

        private static Dictionary<string, string> BuildDepartmentManagerMap(DataTable employeeDetails)
        {
            Dictionary<string, SortedSet<string>> managersByDepartment = new Dictionary<string, SortedSet<string>>(StringComparer.OrdinalIgnoreCase);
            Dictionary<string, string> result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            if (employeeDetails == null || !employeeDetails.Columns.Contains("Department") || !employeeDetails.Columns.Contains("Reporting Manager"))
                return result;

            foreach (DataRow row in employeeDetails.Rows)
            {
                string department = Convert.ToString(row["Department"]).Trim();
                string manager = Convert.ToString(row["Reporting Manager"]).Trim();
                if (department.Length == 0 || manager.Length == 0) continue;

                SortedSet<string> managers;
                if (!managersByDepartment.TryGetValue(department, out managers))
                {
                    managers = new SortedSet<string>(StringComparer.OrdinalIgnoreCase);
                    managersByDepartment[department] = managers;
                }
                managers.Add(manager);
            }

            foreach (KeyValuePair<string, SortedSet<string>> item in managersByDepartment)
                result[item.Key] = string.Join(Environment.NewLine, new List<string>(item.Value).ToArray());

            return result;
        }

        private static string GetManagerForDepartment(Dictionary<string, string> map, string department)
        {
            string manager;
            return map != null && map.TryGetValue(department ?? string.Empty, out manager) && !string.IsNullOrWhiteSpace(manager)
                ? manager
                : "(Not Assigned)";
        }

        private static MonthlyExportModel BuildComparisonMonthlyExportModel(
            DataTable currentMonthSummary,
            DataTable currentEmployeeDetails,
            DataTable previousMonthSummary,
            DataTable previousEmployeeDetails)
        {
            MonthlyExportModel current = BuildMonthlyExportModel(currentMonthSummary ?? new DataTable(), currentEmployeeDetails ?? new DataTable());
            MonthlyExportModel previous = BuildMonthlyExportModel(previousMonthSummary ?? new DataTable(), previousEmployeeDetails ?? new DataTable());
            MonthlyExportModel combined = new MonthlyExportModel
            {
                Periods = new SortedDictionary<int, string>(),
                Departments = new List<string>(),
                GrossValues = new Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase),
                HeadcountValues = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase),
                DepartmentManagers = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            };

            SortedSet<string> departments = new SortedSet<string>(StringComparer.OrdinalIgnoreCase);
            CopyMonthlyModelIntoComparison(previous, combined, departments, "Prior");
            CopyMonthlyModelIntoComparison(current, combined, departments, "Current");

            foreach (string department in departments)
            {
                combined.DepartmentManagers[department] = GetManagerFromPmDepartmentKey(department);
                combined.Departments.Add(department);
            }

            combined.Departments.Sort(delegate (string left, string right)
            {
                int managerCompare = StringComparer.OrdinalIgnoreCase.Compare(
                    GetManagerFromPmDepartmentKey(left),
                    GetManagerFromPmDepartmentKey(right));
                return managerCompare != 0
                    ? managerCompare
                    : StringComparer.OrdinalIgnoreCase.Compare(
                        GetDepartmentFromPmDepartmentKey(left),
                        GetDepartmentFromPmDepartmentKey(right));
            });
            return combined;
        }

        private static void CopyMonthlyModelIntoComparison(
            MonthlyExportModel source,
            MonthlyExportModel target,
            SortedSet<string> departments,
            string periodTag)
        {
            if (source == null) return;
            foreach (KeyValuePair<int, string> period in source.Periods)
                target.Periods[period.Key] = GetShortPeriodLabel(period.Key, period.Value) + " (" + periodTag + ")";
            foreach (string department in source.Departments) departments.Add(department);
            foreach (KeyValuePair<string, decimal> item in source.GrossValues) target.GrossValues[item.Key] = item.Value;
            foreach (KeyValuePair<string, int> item in source.HeadcountValues) target.HeadcountValues[item.Key] = item.Value;
        }

        private static void AddManagerList(SortedSet<string> managers, string managerList)
        {
            if (managers == null || string.IsNullOrWhiteSpace(managerList) || managerList == "(Not Assigned)") return;
            string[] items = managerList.Split(new[] { ",", "\r\n", "\n" }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string item in items)
            {
                string value = item.Trim();
                if (value.Length > 0) managers.Add(value);
            }
        }

        private static void CreateHeadcountTrendSheet(
            XLWorkbook workbook,
            DataTable monthSummary,
            DataTable employeeDetails,
            DataTable previousMonthSummary,
            DataTable previousEmployeeDetails)
        {
            MonthlyExportModel model = BuildComparisonMonthlyExportModel(monthSummary, employeeDetails, previousMonthSummary, previousEmployeeDetails);
            IXLWorksheet ws = workbook.Worksheets.Add("Headcount Trend");
            WriteSheetTitle(ws, "Project Manager-wise Headcount Trend — Current vs Prior Year");

            int tableStartRow = AddDepartmentAdjustedBarPicture(ws, "Project Manager-wise Headcount: Current vs Prior Year", model, ExportMetric.Headcount, "B3");
            WriteHorizontalMetricTable(ws, model, tableStartRow, ExportMetric.Headcount);
        }

        private static void CreateGrossSalaryTrendSheet(
            XLWorkbook workbook,
            DataTable monthSummary,
            DataTable employeeDetails,
            DataTable previousMonthSummary,
            DataTable previousEmployeeDetails)
        {
            MonthlyExportModel model = BuildComparisonMonthlyExportModel(monthSummary, employeeDetails, previousMonthSummary, previousEmployeeDetails);
            IXLWorksheet ws = workbook.Worksheets.Add("Gross Salary Trend");
            WriteSheetTitle(ws, "Project Manager-wise Gross Salary Trend — Current vs Prior Year");

            int tableStartRow = AddDepartmentAdjustedBarPicture(ws, "Project Manager-wise Gross Salary: Current vs Prior Year", model, ExportMetric.Gross, "B3");
            WriteHorizontalMetricTable(ws, model, tableStartRow, ExportMetric.Gross);
        }

        private static void CreateSalaryDeviationSheet(XLWorkbook workbook, DataTable monthSummary, DataTable employeeDetails)
        {
            MonthlyExportModel model = BuildMonthlyExportModel(monthSummary, employeeDetails);
            IXLWorksheet ws = workbook.Worksheets.Add("Salary Deviation");
            WriteSheetTitle(ws, "Department-wise Gross Salary Deviation");

            int tableStartRow = AddDepartmentAdjustedBarPicture(ws, "Department-wise Salary Deviation %", model, ExportMetric.Deviation, "B3");
            WriteHorizontalMetricTable(ws, model, tableStartRow, ExportMetric.Deviation);
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
            ws.Cell(startRow, 1).Value = "Project Manager";
            ws.Cell(startRow, 2).Value = "Department";
            int col = 3;
            foreach (KeyValuePair<int, string> period in model.Periods)
                ws.Cell(startRow, col++).Value = period.Value;

            int row = startRow + 1;
            foreach (string department in model.Departments)
            {
                ws.Cell(row, 1).Value = GetManagerFromPmDepartmentKey(department);
                ws.Cell(row, 2).Value = GetDepartmentFromPmDepartmentKey(department);
                col = 3;
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
                    else if (hasPrevious && previousGross != 0M)
                        ws.Cell(row, col).Value = (gross - previousGross) / previousGross;

                    previousGross = gross;
                    hasPrevious = true;
                    col++;
                }
                row++;
            }

            int lastRow = Math.Max(row - 1, startRow);
            int lastCol = Math.Max(col - 1, 2);
            IXLRange header = ws.Range(startRow, 1, startRow, lastCol);
            header.Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
            header.Style.Font.FontColor = XLColor.White;
            header.Style.Font.Bold = true;
            header.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

            IXLRange dataRange = ws.Range(startRow, 1, lastRow, lastCol);
            dataRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            dataRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            ws.Column(1).Width = 30;
            ws.Column(2).Width = 24;
            for (int c = 3; c <= lastCol; c++) ws.Column(c).Width = 15;

            if (lastRow > startRow)
            {
                if (metric == ExportMetric.Headcount)
                    ws.Range(startRow + 1, 3, lastRow, lastCol).Style.NumberFormat.Format = "0";
                else if (metric == ExportMetric.Gross)
                    ws.Range(startRow + 1, 3, lastRow, lastCol).Style.NumberFormat.Format = "#,##0.00";
                else
                {
                    IXLRange deviationRange = ws.Range(startRow + 1, 3, lastRow, lastCol);
                    deviationRange.Style.NumberFormat.Format = "0.00%";
                    deviationRange.AddConditionalFormat().WhenGreaterThan(0).Fill.SetBackgroundColor(XLColor.FromHtml("#E2F0D9")).Font.SetFontColor(XLColor.FromHtml("#006100"));
                    deviationRange.AddConditionalFormat().WhenLessThan(0).Fill.SetBackgroundColor(XLColor.FromHtml("#FCE4D6")).Font.SetFontColor(XLColor.FromHtml("#9C0006"));
                }
            }

            ws.SheetView.FreezeRows(startRow);
            ws.Range(startRow, 1, lastRow, lastCol).SetAutoFilter();
        }

        private static void AddYearOverYearSalaryComparisonPicture(
            IXLWorksheet ws,
            Dictionary<string, YearDepartmentTotal> current,
            Dictionary<string, YearDepartmentTotal> previous,
            IEnumerable<string> departments,
            string currentLabel,
            string previousLabel,
            string cellAddress)
        {
            List<string> labels = new List<string>();
            List<decimal> currentValues = new List<decimal>();
            List<decimal> previousValues = new List<decimal>();
            foreach (string department in departments)
            {
                YearDepartmentTotal currentValue;
                YearDepartmentTotal previousValue;
                if (!current.TryGetValue(department, out currentValue)) currentValue = new YearDepartmentTotal();
                if (!previous.TryGetValue(department, out previousValue)) previousValue = new YearDepartmentTotal();
                labels.Add(string.IsNullOrWhiteSpace(department) ? "(Not Assigned)" : GetPmDepartmentDisplayLabel(department));
                currentValues.Add(currentValue.Gross);
                previousValues.Add(previousValue.Gross);
            }

            using (MemoryStream image = DrawYearOverYearSalaryComparisonChart(labels, currentValues, previousValues, currentLabel, previousLabel))
            {
                ws.AddPicture(image, GetExcelPictureName("YoYCompare"))
                    .MoveTo(ws.Cell(cellAddress))
                    .WithSize(1050, 445);
            }
        }

        private static MemoryStream DrawYearOverYearSalaryComparisonChart(
            List<string> labels,
            List<decimal> currentValues,
            List<decimal> previousValues,
            string currentLabel,
            string previousLabel)
        {
            int width = Math.Max(1500, 650 + Math.Max(labels.Count, 1) * 90);
            const int height = 620;
            Bitmap bitmap = new Bitmap(width, height);
            using (Graphics g = Graphics.FromImage(bitmap))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.Clear(Color.White);
                using (Font titleFont = new Font("Arial", 16F, FontStyle.Bold))
                using (Brush titleBrush = new SolidBrush(Color.FromArgb(30, 55, 90)))
                    g.DrawString("Gross Salary Comparison — Current vs Prior Year", titleFont, titleBrush, new PointF(95F, 18F));

                Rectangle plot = new Rectangle(95, 72, width - 180, height - 205);
                DrawChartFrame(g, plot, string.Empty);
                decimal maximum = 1M;
                foreach (decimal value in currentValues) maximum = Math.Max(maximum, value);
                foreach (decimal value in previousValues) maximum = Math.Max(maximum, value);
                maximum *= 1.08M;
                DrawYAxis(g, plot, 0M, maximum, "#,##0");
                DrawRotatedDepartmentXAxis(g, plot, labels);

                int groupCount = Math.Max(labels.Count, 1);
                float groupWidth = plot.Width / (float)groupCount;
                float barWidth = Math.Max(3F, Math.Min(28F, groupWidth * 0.30F));
                Color previousColor = GetDepartmentChartColor(0);
                Color currentColor = GetDepartmentChartColor(1);
                for (int i = 0; i < labels.Count; i++)
                {
                    float center = plot.Left + groupWidth * i + groupWidth / 2F;
                    decimal prior = i < previousValues.Count ? previousValues[i] : 0M;
                    decimal current = i < currentValues.Count ? currentValues[i] : 0M;
                    float priorY = plot.Bottom - (float)(prior / maximum) * plot.Height;
                    float currentY = plot.Bottom - (float)(current / maximum) * plot.Height;
                    using (Brush priorBrush = new SolidBrush(previousColor))
                        g.FillRectangle(priorBrush, center - barWidth - 1F, priorY, barWidth, Math.Max(1F, plot.Bottom - priorY));
                    using (Brush currentBrush = new SolidBrush(currentColor))
                        g.FillRectangle(currentBrush, center + 1F, currentY, barWidth, Math.Max(1F, plot.Bottom - currentY));
                }

                using (Font legendFont = new Font("Arial", 9F, FontStyle.Bold))
                using (Brush textBrush = new SolidBrush(Color.FromArgb(55, 65, 80)))
                using (Brush priorBrush = new SolidBrush(previousColor))
                using (Brush currentBrush = new SolidBrush(currentColor))
                {
                    float x = plot.Left;
                    float y = height - 55F;
                    g.FillRectangle(priorBrush, x, y, 14F, 14F);
                    g.DrawString(previousLabel, legendFont, textBrush, x + 20F, y - 2F);
                    float nextX = x + 260F;
                    g.FillRectangle(currentBrush, nextX, y, 14F, 14F);
                    g.DrawString(currentLabel, legendFont, textBrush, nextX + 20F, y - 2F);
                }
            }

            MemoryStream stream = new MemoryStream();
            bitmap.Save(stream, ImageFormat.Png);
            bitmap.Dispose();
            stream.Position = 0;
            return stream;
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


        private static int AddDepartmentAdjustedBarPicture(
            IXLWorksheet ws,
            string title,
            MonthlyExportModel model,
            ExportMetric metric,
            string cellAddress)
        {
            List<string> departments = new List<string>();
            foreach (string department in model.Departments)
                departments.Add(string.IsNullOrWhiteSpace(department) ? "(Not Assigned)" : GetPmDepartmentDisplayLabel(department));

            List<DepartmentChartSeries> monthSeries = new List<DepartmentChartSeries>();
            int monthIndex = 0;
            foreach (KeyValuePair<int, string> period in model.Periods)
            {
                DepartmentChartSeries item = new DepartmentChartSeries
                {
                    Department = GetShortPeriodLabel(period.Key, period.Value),
                    Values = new List<decimal>(),
                    Color = GetDepartmentChartColor(monthIndex++)
                };

                foreach (string department in model.Departments)
                {
                    string key = period.Key.ToString(CultureInfo.InvariantCulture) + "||" + department;
                    decimal gross;
                    int count;
                    model.GrossValues.TryGetValue(key, out gross);
                    model.HeadcountValues.TryGetValue(key, out count);

                    if (metric == ExportMetric.Headcount)
                    {
                        item.Values.Add(count);
                    }
                    else if (metric == ExportMetric.Gross)
                    {
                        item.Values.Add(gross);
                    }
                    else
                    {
                        decimal previousGross = 0M;
                        bool hasPrevious = false;
                        foreach (KeyValuePair<int, string> previousPeriod in model.Periods)
                        {
                            string previousKey = previousPeriod.Key.ToString(CultureInfo.InvariantCulture) + "||" + department;
                            decimal value;
                            model.GrossValues.TryGetValue(previousKey, out value);
                            if (previousPeriod.Key == period.Key)
                            {
                                item.Values.Add(hasPrevious && previousGross != 0M
                                    ? ((value - previousGross) / previousGross) * 100M
                                    : 0M);
                                break;
                            }
                            previousGross = value;
                            hasPrevious = true;
                        }
                    }
                }

                monthSeries.Add(item);
            }

            int sourceWidth = Math.Max(1500, 560 + Math.Max(departments.Count, 1) * 92);
            const int sourceHeight = 620;
            int displayWidth = Math.Max(1050, (int)Math.Round(sourceWidth * 0.72D));
            int displayHeight = 445;

            using (MemoryStream image = DrawAdjustedDepartmentBarChart(title, departments, monthSeries, metric, sourceWidth, sourceHeight))
            {
                ws.AddPicture(image, GetExcelPictureName("AdjustedBar"))
                    .MoveTo(ws.Cell(cellAddress))
                    .WithSize(displayWidth, displayHeight);
            }

            return Math.Max(27, (int)Math.Ceiling(displayHeight / 20D) + 6);
        }

        private static MemoryStream DrawAdjustedDepartmentBarChart(
            string title,
            List<string> labels,
            List<DepartmentChartSeries> series,
            ExportMetric metric,
            int width,
            int height)
        {
            Bitmap bitmap = new Bitmap(width, height);
            using (Graphics g = Graphics.FromImage(bitmap))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.Clear(Color.White);

                using (Font titleFont = new Font("Arial", 16F, FontStyle.Bold))
                using (Brush titleBrush = new SolidBrush(Color.FromArgb(30, 55, 90)))
                    g.DrawString(title, titleFont, titleBrush, new PointF(95F, 18F));

                Rectangle plot = new Rectangle(95, 72, width - 390, height - 205);
                DrawChartFrame(g, plot, string.Empty);

                decimal transformedMin = 0M;
                decimal transformedMax = 0M;
                foreach (DepartmentChartSeries item in series)
                {
                    foreach (decimal actual in item.Values)
                    {
                        decimal transformed = TransformAdjustedChartValue(actual, metric);
                        transformedMin = Math.Min(transformedMin, transformed);
                        transformedMax = Math.Max(transformedMax, transformed);
                    }
                }

                if (metric == ExportMetric.Deviation)
                {
                    decimal maxAbs = Math.Max(Math.Abs(transformedMin), Math.Abs(transformedMax));
                    maxAbs = Math.Max(1M, maxAbs * 1.10M);
                    transformedMin = -maxAbs;
                    transformedMax = maxAbs;
                }
                else
                {
                    transformedMin = 0M;
                    transformedMax = Math.Max(1M, transformedMax * 1.05M);
                }

                DrawAdjustedYAxis(g, plot, transformedMin, transformedMax, metric);
                DrawRotatedDepartmentXAxis(g, plot, labels);

                float zeroY = plot.Bottom - (float)((0M - transformedMin) / (transformedMax - transformedMin)) * plot.Height;
                using (Pen zeroPen = new Pen(Color.Gray, 1.2F))
                    g.DrawLine(zeroPen, plot.Left, zeroY, plot.Right, zeroY);

                int groupCount = Math.Max(labels.Count, 1);
                int seriesCount = Math.Max(series.Count, 1);
                float groupWidth = plot.Width / (float)groupCount;
                float availableWidth = groupWidth * 0.84F;
                float barWidth = Math.Max(0.8F, Math.Min(26F, availableWidth / seriesCount));
                float renderedGroupWidth = barWidth * seriesCount;

                for (int groupIndex = 0; groupIndex < labels.Count; groupIndex++)
                {
                    float groupLeft = plot.Left + groupWidth * groupIndex + (groupWidth - renderedGroupWidth) / 2F;
                    for (int seriesIndex = 0; seriesIndex < series.Count; seriesIndex++)
                    {
                        decimal actual = groupIndex < series[seriesIndex].Values.Count ? series[seriesIndex].Values[groupIndex] : 0M;
                        decimal transformed = TransformAdjustedChartValue(actual, metric);
                        float valueY = plot.Bottom - (float)((transformed - transformedMin) / (transformedMax - transformedMin)) * plot.Height;
                        float top = Math.Min(zeroY, valueY);
                        float barHeight = Math.Max(1F, Math.Abs(zeroY - valueY));
                        float barLeft = groupLeft + seriesIndex * barWidth;
                        using (Brush brush = new SolidBrush(series[seriesIndex].Color))
                            g.FillRectangle(brush, barLeft, top, Math.Max(0.7F, barWidth - 0.6F), barHeight);
                    }
                }

                Rectangle legend = new Rectangle(width - 275, 72, 245, height - 145);
                DrawDepartmentLegend(g, legend, series);

                using (Font axisFont = new Font("Arial", 8F, FontStyle.Bold))
                using (Brush axisBrush = new SolidBrush(Color.DimGray))
                {
                    string axisTitle = metric == ExportMetric.Headcount
                        ? "Headcount (Logarithmic Scale)"
                        : metric == ExportMetric.Gross
                            ? "Gross Salary (Logarithmic Scale)"
                            : "Change % (Adjusted Scale)";
                    g.DrawString(axisTitle, axisFont, axisBrush, new PointF(8F, plot.Top + plot.Height / 2F - 7F));
                    g.DrawString("Department", axisFont, axisBrush, new PointF(plot.Left + plot.Width / 2F - 28F, height - 22F));
                }

                using (Font noteFont = new Font("Arial", 8F, FontStyle.Italic))
                using (Brush noteBrush = new SolidBrush(Color.DimGray))
                {
                    string note = metric == ExportMetric.Deviation
                        ? "Signed adjusted scale improves visibility of both positive and negative deviations."
                        : "Logarithmic scale improves visibility of departments with smaller values. Bar labels and table values remain actual values.";
                    g.DrawString(note, noteFont, noteBrush, plot.Left, height - 42F);
                }
            }

            MemoryStream stream = new MemoryStream();
            bitmap.Save(stream, ImageFormat.Png);
            bitmap.Dispose();
            stream.Position = 0;
            return stream;
        }

        private static decimal TransformAdjustedChartValue(decimal value, ExportMetric metric)
        {
            if (metric == ExportMetric.Deviation)
            {
                if (value == 0M) return 0M;
                decimal sign = value < 0M ? -1M : 1M;
                return sign * (decimal)Math.Log10(1D + (double)Math.Abs(value));
            }

            if (value <= 0M) return 0M;
            return (decimal)Math.Log10((double)value);
        }

        private static decimal RestoreAdjustedChartValue(decimal transformed, ExportMetric metric)
        {
            if (metric == ExportMetric.Deviation)
            {
                if (transformed == 0M) return 0M;
                decimal sign = transformed < 0M ? -1M : 1M;
                return sign * ((decimal)Math.Pow(10D, (double)Math.Abs(transformed)) - 1M);
            }

            return transformed <= 0M ? 1M : (decimal)Math.Pow(10D, (double)transformed);
        }

        private static void DrawAdjustedYAxis(
            Graphics g,
            Rectangle plot,
            decimal minimum,
            decimal maximum,
            ExportMetric metric)
        {
            using (Font font = new Font("Arial", 8F))
            using (Brush brush = new SolidBrush(Color.DimGray))
            using (Pen gridPen = new Pen(Color.FromArgb(225, 230, 236), 1F))
            {
                for (int i = 0; i <= 6; i++)
                {
                    decimal transformed = maximum - ((maximum - minimum) * i / 6M);
                    decimal actual = RestoreAdjustedChartValue(transformed, metric);
                    string text;
                    if (metric == ExportMetric.Deviation)
                        text = (actual > 0M ? "+" : string.Empty) + actual.ToString(Math.Abs(actual) < 10M ? "0.0" : "0", CultureInfo.InvariantCulture) + "%";
                    else if (metric == ExportMetric.Gross)
                        text = FormatCompactAxisValue(actual, true);
                    else
                        text = FormatCompactAxisValue(actual, false);

                    float y = plot.Top + plot.Height * i / 6F;
                    g.DrawLine(gridPen, plot.Left, y, plot.Right, y);
                    SizeF size = g.MeasureString(text, font);
                    g.DrawString(text, font, brush, plot.Left - size.Width - 8F, y - 7F);
                }
            }
        }

        private static string FormatCompactAxisValue(decimal value, bool currency)
        {
            decimal absolute = Math.Abs(value);
            string suffix = string.Empty;
            decimal display = value;
            if (absolute >= 10000000M) { display = value / 10000000M; suffix = "Cr"; }
            else if (absolute >= 100000M) { display = value / 100000M; suffix = "L"; }
            else if (absolute >= 1000M) { display = value / 1000M; suffix = "K"; }
            string prefix = currency ? "Rs. " : string.Empty;
            return prefix + display.ToString(Math.Abs(display) < 10M ? "0.0" : "0", CultureInfo.InvariantCulture) + suffix;
        }

        private static void DrawRotatedDepartmentXAxis(Graphics g, Rectangle plot, List<string> labels)
        {
            if (labels.Count == 0) return;
            using (Font font = new Font("Arial", labels.Count > 18 ? 6.5F : 7.5F))
            using (Brush brush = new SolidBrush(Color.DimGray))
            {
                float slot = plot.Width / (float)labels.Count;
                for (int i = 0; i < labels.Count; i++)
                {
                    float x = plot.Left + slot * i + slot / 2F;
                    GraphicsState state = g.Save();
                    g.TranslateTransform(x, plot.Bottom + 9F);
                    g.RotateTransform(-45F);
                    g.DrawString(labels[i], font, brush, new RectangleF(-8F, 0F, 145F, 18F));
                    g.Restore(state);
                }
            }
        }

        private static int AddDepartmentHeatmapPicture(
            IXLWorksheet ws,
            string title,
            MonthlyExportModel model,
            ExportMetric metric,
            string cellAddress)
        {
            List<string> labels = new List<string>();
            foreach (KeyValuePair<int, string> period in model.Periods)
                labels.Add(GetShortPeriodLabel(period.Key, period.Value));

            List<DepartmentChartSeries> series = new List<DepartmentChartSeries>();
            for (int departmentIndex = 0; departmentIndex < model.Departments.Count; departmentIndex++)
            {
                string department = model.Departments[departmentIndex];
                DepartmentChartSeries chartSeries = new DepartmentChartSeries
                {
                    Department = string.IsNullOrWhiteSpace(department) ? "(Not Assigned)" : department,
                    Values = new List<decimal>(),
                    Color = GetDepartmentChartColor(departmentIndex)
                };

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
                        chartSeries.Values.Add(count);
                    else if (metric == ExportMetric.Gross)
                        chartSeries.Values.Add(gross);
                    else
                        chartSeries.Values.Add(hasPrevious && previousGross != 0M
                            ? ((gross - previousGross) / previousGross) * 100M
                            : 0M);

                    previousGross = gross;
                    hasPrevious = true;
                }
                series.Add(chartSeries);
            }

            int sourceWidth = GetDepartmentHeatmapWidth(labels.Count);
            int sourceHeight = GetDepartmentHeatmapHeight(series.Count);
            int displayWidth = Math.Max(1000, (int)Math.Round(sourceWidth * 0.72D));
            int displayHeight = Math.Max(380, (int)Math.Round(sourceHeight * 0.72D));

            using (MemoryStream image = DrawDepartmentHeatmap(title, labels, series, metric))
            {
                ws.AddPicture(image, GetExcelPictureName("Heatmap"))
                    .MoveTo(ws.Cell(cellAddress))
                    .WithSize(displayWidth, displayHeight);
            }

            return Math.Max(24, (int)Math.Ceiling(displayHeight / 20D) + 5);
        }

        private static int GetDepartmentHeatmapWidth(int periodCount)
        {
            return Math.Max(1400, 500 + Math.Max(periodCount, 1) * 82);
        }

        private static int GetDepartmentHeatmapHeight(int departmentCount)
        {
            return Math.Max(530, 130 + Math.Max(departmentCount, 1) * 36);
        }

        private static MemoryStream DrawDepartmentHeatmap(
            string title,
            List<string> labels,
            List<DepartmentChartSeries> series,
            ExportMetric metric)
        {
            int width = GetDepartmentHeatmapWidth(labels.Count);
            int height = GetDepartmentHeatmapHeight(series.Count);
            const int left = 35;
            const int departmentWidth = 225;
            const int trendWidth = 210;
            const int headerTop = 82;
            const int headerHeight = 34;
            const int rowHeight = 36;
            int valueAreaWidth = width - left - departmentWidth - trendWidth - 25;
            float valueWidth = valueAreaWidth / (float)Math.Max(labels.Count, 1);

            Bitmap bitmap = new Bitmap(width, height);
            using (Graphics g = Graphics.FromImage(bitmap))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.Clear(Color.White);

                using (Font titleFont = new Font("Arial", 16F, FontStyle.Bold))
                using (Brush titleBrush = new SolidBrush(Color.FromArgb(30, 55, 90)))
                    g.DrawString(title, titleFont, titleBrush, new PointF(left, 18F));

                using (Font noteFont = new Font("Arial", 8F, FontStyle.Italic))
                using (Brush noteBrush = new SolidBrush(Color.DimGray))
                {
                    string note = metric == ExportMetric.Deviation
                        ? "Green = increase, red = decrease. Colour intensity is normalized per department."
                        : "Darker cells indicate higher values within that department. Exact values and compact trends are shown.";
                    g.DrawString(note, noteFont, noteBrush, new PointF(left, 52F));
                }

                RectangleF departmentHeader = new RectangleF(left, headerTop, departmentWidth, headerHeight);
                DrawHeatmapHeaderCell(g, departmentHeader, "Department", 9F);
                for (int i = 0; i < labels.Count; i++)
                {
                    RectangleF monthHeader = new RectangleF(left + departmentWidth + i * valueWidth, headerTop, valueWidth, headerHeight);
                    DrawHeatmapHeaderCell(g, monthHeader, labels[i], valueWidth < 55F ? 7F : 8F);
                }
                RectangleF trendHeader = new RectangleF(left + departmentWidth + labels.Count * valueWidth, headerTop, trendWidth, headerHeight);
                DrawHeatmapHeaderCell(g, trendHeader, "Trend", 9F);

                for (int rowIndex = 0; rowIndex < series.Count; rowIndex++)
                {
                    DepartmentChartSeries item = series[rowIndex];
                    float rowTop = headerTop + headerHeight + rowIndex * rowHeight;
                    RectangleF departmentCell = new RectangleF(left, rowTop, departmentWidth, rowHeight);
                    DrawHeatmapDepartmentCell(g, departmentCell, item.Department);

                    decimal minimum = 0M;
                    decimal maximum = 0M;
                    decimal maximumAbsolute = 0M;
                    bool hasValue = false;
                    foreach (decimal value in item.Values)
                    {
                        if (!hasValue) { minimum = value; maximum = value; hasValue = true; }
                        minimum = Math.Min(minimum, value);
                        maximum = Math.Max(maximum, value);
                        maximumAbsolute = Math.Max(maximumAbsolute, Math.Abs(value));
                    }

                    for (int valueIndex = 0; valueIndex < labels.Count; valueIndex++)
                    {
                        decimal value = valueIndex < item.Values.Count ? item.Values[valueIndex] : 0M;
                        RectangleF valueCell = new RectangleF(left + departmentWidth + valueIndex * valueWidth, rowTop, valueWidth, rowHeight);
                        Color background = GetHeatmapCellColor(value, minimum, maximum, maximumAbsolute, metric);
                        string text = FormatHeatmapValue(value, metric, valueIndex == 0 && metric == ExportMetric.Deviation);
                        DrawHeatmapValueCell(g, valueCell, text, background, valueWidth < 58F ? 7F : 8F);
                    }

                    RectangleF trendCell = new RectangleF(left + departmentWidth + labels.Count * valueWidth, rowTop, trendWidth, rowHeight);
                    DrawHeatmapTrendCell(g, trendCell, item.Values, metric);
                }
            }

            MemoryStream stream = new MemoryStream();
            bitmap.Save(stream, ImageFormat.Png);
            bitmap.Dispose();
            stream.Position = 0;
            return stream;
        }

        private static void DrawHeatmapHeaderCell(Graphics g, RectangleF cell, string text, float fontSize)
        {
            using (Brush fill = new SolidBrush(Color.FromArgb(73, 104, 143)))
            using (Pen border = new Pen(Color.FromArgb(210, 220, 231)))
            using (Font font = new Font("Arial", fontSize, FontStyle.Bold))
            using (Brush textBrush = new SolidBrush(Color.White))
            using (StringFormat format = CreateCenteredCellFormat())
            {
                g.FillRectangle(fill, cell);
                g.DrawRectangle(border, cell.X, cell.Y, cell.Width, cell.Height);
                g.DrawString(text, font, textBrush, cell, format);
            }
        }

        private static void DrawHeatmapDepartmentCell(Graphics g, RectangleF cell, string department)
        {
            using (Brush fill = new SolidBrush(Color.FromArgb(246, 248, 251)))
            using (Pen border = new Pen(Color.FromArgb(218, 225, 233)))
            using (Font font = new Font("Arial", 8.5F, FontStyle.Bold))
            using (Brush textBrush = new SolidBrush(Color.FromArgb(50, 68, 92)))
            using (StringFormat format = new StringFormat { Alignment = StringAlignment.Near, LineAlignment = StringAlignment.Center, Trimming = StringTrimming.EllipsisCharacter, FormatFlags = StringFormatFlags.NoWrap })
            {
                g.FillRectangle(fill, cell);
                g.DrawRectangle(border, cell.X, cell.Y, cell.Width, cell.Height);
                RectangleF textArea = new RectangleF(cell.X + 8F, cell.Y, cell.Width - 12F, cell.Height);
                g.DrawString(department, font, textBrush, textArea, format);
            }
        }

        private static void DrawHeatmapValueCell(Graphics g, RectangleF cell, string text, Color background, float fontSize)
        {
            using (Brush fill = new SolidBrush(background))
            using (Pen border = new Pen(Color.FromArgb(220, 226, 233)))
            using (Font font = new Font("Arial", fontSize, FontStyle.Regular))
            using (Brush textBrush = new SolidBrush(GetReadableTextColor(background)))
            using (StringFormat format = CreateCenteredCellFormat())
            {
                g.FillRectangle(fill, cell);
                g.DrawRectangle(border, cell.X, cell.Y, cell.Width, cell.Height);
                g.DrawString(text, font, textBrush, cell, format);
            }
        }

        private static void DrawHeatmapTrendCell(Graphics g, RectangleF cell, List<decimal> values, ExportMetric metric)
        {
            using (Brush fill = new SolidBrush(Color.FromArgb(250, 251, 253)))
            using (Pen border = new Pen(Color.FromArgb(218, 225, 233)))
            {
                g.FillRectangle(fill, cell);
                g.DrawRectangle(border, cell.X, cell.Y, cell.Width, cell.Height);
            }
            if (values.Count == 0) return;

            decimal minimum = values[0];
            decimal maximum = values[0];
            foreach (decimal value in values) { minimum = Math.Min(minimum, value); maximum = Math.Max(maximum, value); }
            if (metric == ExportMetric.Deviation) { minimum = Math.Min(0M, minimum); maximum = Math.Max(0M, maximum); }
            if (maximum == minimum) maximum = minimum + 1M;

            float padX = 8F;
            float padY = 6F;
            if (metric == ExportMetric.Deviation && minimum <= 0M && maximum >= 0M)
            {
                float zeroY = cell.Bottom - padY - (float)((0M - minimum) / (maximum - minimum)) * (cell.Height - padY * 2F);
                using (Pen zeroPen = new Pen(Color.FromArgb(195, 203, 213), 1F))
                    g.DrawLine(zeroPen, cell.Left + padX, zeroY, cell.Right - padX, zeroY);
            }

            PointF[] points = new PointF[values.Count];
            for (int i = 0; i < values.Count; i++)
            {
                float x = values.Count == 1 ? cell.Left + cell.Width / 2F : cell.Left + padX + i * (cell.Width - padX * 2F) / (values.Count - 1F);
                float y = cell.Bottom - padY - (float)((values[i] - minimum) / (maximum - minimum)) * (cell.Height - padY * 2F);
                points[i] = new PointF(x, y);
            }
            using (Pen linePen = new Pen(Color.FromArgb(53, 95, 140), 2F))
            using (Brush pointBrush = new SolidBrush(Color.FromArgb(53, 95, 140)))
            {
                if (points.Length > 1) g.DrawLines(linePen, points);
                foreach (PointF point in points) g.FillEllipse(pointBrush, point.X - 1.7F, point.Y - 1.7F, 3.4F, 3.4F);
            }
        }

        private static Color GetHeatmapCellColor(decimal value, decimal minimum, decimal maximum, decimal maximumAbsolute, ExportMetric metric)
        {
            if (metric == ExportMetric.Deviation)
            {
                decimal intensity = maximumAbsolute == 0M ? 0M : Math.Min(1M, Math.Abs(value) / maximumAbsolute);
                Color baseColor = value > 0M ? Color.FromArgb(40, 145, 85) : value < 0M ? Color.FromArgb(196, 65, 65) : Color.FromArgb(145, 153, 163);
                return BlendWithWhite(baseColor, 0.12M + intensity * 0.58M);
            }

            decimal range = maximum - minimum;
            decimal normalized = range == 0M ? 0.45M : Math.Max(0M, Math.Min(1M, (value - minimum) / range));
            return BlendWithWhite(Color.FromArgb(54, 112, 170), 0.12M + normalized * 0.58M);
        }

        private static Color BlendWithWhite(Color color, decimal amount)
        {
            amount = Math.Max(0M, Math.Min(1M, amount));
            int red = (int)Math.Round(255M + (color.R - 255M) * amount);
            int green = (int)Math.Round(255M + (color.G - 255M) * amount);
            int blue = (int)Math.Round(255M + (color.B - 255M) * amount);
            return Color.FromArgb(red, green, blue);
        }

        private static Color GetReadableTextColor(Color background)
        {
            double luminance = 0.299D * background.R + 0.587D * background.G + 0.114D * background.B;
            return luminance < 150D ? Color.White : Color.FromArgb(40, 52, 68);
        }

        private static string FormatHeatmapValue(decimal value, ExportMetric metric, bool firstDeviationPeriod)
        {
            if (firstDeviationPeriod) return "-";
            if (metric == ExportMetric.Deviation)
                return (value > 0M ? "+" : string.Empty) + value.ToString("0.00", CultureInfo.InvariantCulture) + "%";
            return value.ToString("#,##0", CultureInfo.InvariantCulture);
        }

        private static StringFormat CreateCenteredCellFormat()
        {
            return new StringFormat
            {
                Alignment = StringAlignment.Center,
                LineAlignment = StringAlignment.Center,
                Trimming = StringTrimming.EllipsisCharacter,
                FormatFlags = StringFormatFlags.NoWrap
            };
        }

        private static MemoryStream DrawDepartmentBarChart(
            string title,
            List<string> labels,
            List<DepartmentChartSeries> series,
            ExportMetric metric)
        {
            const int width = 1400;
            const int height = 530;
            Bitmap bitmap = new Bitmap(width, height);
            using (Graphics g = Graphics.FromImage(bitmap))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.Clear(Color.White);

                using (Font titleFont = new Font("Arial", 16F, FontStyle.Bold))
                using (Brush titleBrush = new SolidBrush(Color.FromArgb(30, 55, 90)))
                    g.DrawString(title, titleFont, titleBrush, new PointF(100F, 18F));

                List<DepartmentChartSeries> dominantSeries;
                List<DepartmentChartSeries> detailedSeries;
                SplitChartSeriesByScale(series, out dominantSeries, out detailedSeries);

                if (dominantSeries.Count > 0)
                {
                    DrawDepartmentBarPanel(g, new Rectangle(100, 82, 930, 135), labels, dominantSeries, metric,
                        "Higher scale: " + GetDepartmentSeriesLabel(dominantSeries), false);
                    DrawDepartmentBarPanel(g, new Rectangle(100, 278, 930, 185), labels, detailedSeries, metric,
                        "Detailed scale: remaining departments", true);
                }
                else
                {
                    DrawDepartmentBarPanel(g, new Rectangle(100, 72, 930, 365), labels, series, metric,
                        "All departments", true);
                }

                Rectangle legend = new Rectangle(1055, 65, 325, 410);
                DrawDepartmentLegend(g, legend, series);
                using (Font noteFont = new Font("Arial", 8F, FontStyle.Italic))
                using (Brush noteBrush = new SolidBrush(Color.DimGray))
                    g.DrawString("Bars show actual values; connecting lines highlight month-to-month trends.", noteFont, noteBrush, 100F, 505F);
            }

            MemoryStream stream = new MemoryStream();
            bitmap.Save(stream, ImageFormat.Png);
            bitmap.Dispose();
            stream.Position = 0;
            return stream;
        }

        private static void SplitChartSeriesByScale(
            List<DepartmentChartSeries> series,
            out List<DepartmentChartSeries> dominantSeries,
            out List<DepartmentChartSeries> detailedSeries)
        {
            dominantSeries = new List<DepartmentChartSeries>();
            detailedSeries = new List<DepartmentChartSeries>(series);
            if (series.Count < 2) return;

            List<DepartmentChartSeries> ordered = new List<DepartmentChartSeries>(series);
            ordered.Sort(delegate (DepartmentChartSeries left, DepartmentChartSeries right)
            {
                return GetSeriesMagnitude(right).CompareTo(GetSeriesMagnitude(left));
            });

            decimal largestRatio = 0M;
            int splitAt = 0;
            for (int i = 0; i < ordered.Count - 1; i++)
            {
                decimal current = GetSeriesMagnitude(ordered[i]);
                decimal next = GetSeriesMagnitude(ordered[i + 1]);
                if (next <= 0M) continue;
                decimal ratio = current / next;
                if (ratio > largestRatio)
                {
                    largestRatio = ratio;
                    splitAt = i + 1;
                }
            }

            // A four-times scale gap is large enough to flatten the smaller department trends.
            if (largestRatio < 4M || splitAt <= 0 || splitAt >= ordered.Count) return;

            dominantSeries = ordered.GetRange(0, splitAt);
            detailedSeries = new List<DepartmentChartSeries>();
            foreach (DepartmentChartSeries item in series)
                if (!dominantSeries.Contains(item)) detailedSeries.Add(item);
        }

        private static decimal GetSeriesMagnitude(DepartmentChartSeries series)
        {
            decimal maximum = 0M;
            foreach (decimal value in series.Values)
                maximum = Math.Max(maximum, Math.Abs(value));
            return maximum;
        }

        private static string GetDepartmentSeriesLabel(List<DepartmentChartSeries> series)
        {
            List<string> names = new List<string>();
            int visibleCount = Math.Min(series.Count, 4);
            for (int i = 0; i < visibleCount; i++) names.Add(series[i].Department);
            string label = string.Join(", ", names.ToArray());
            return series.Count > visibleCount ? label + " + " + (series.Count - visibleCount) + " more" : label;
        }

        private static void DrawDepartmentBarPanel(
            Graphics g,
            Rectangle plot,
            List<string> labels,
            List<DepartmentChartSeries> series,
            ExportMetric metric,
            string panelTitle,
            bool showXAxis)
        {
            decimal minimum = 0M;
            decimal maximum = 0M;
            foreach (DepartmentChartSeries item in series)
                foreach (decimal value in item.Values)
                {
                    maximum = Math.Max(maximum, value);
                    minimum = Math.Min(minimum, value);
                }

            if (metric == ExportMetric.Deviation)
            {
                decimal span = Math.Max(1M, maximum - minimum);
                maximum = Math.Max(1M, maximum + span * 0.08M);
                minimum = Math.Min(-1M, minimum - span * 0.08M);
            }
            else
            {
                minimum = 0M;
                maximum = Math.Max(1M, maximum * 1.08M);
            }

            DrawChartFrame(g, plot, string.Empty);
            using (Font panelFont = new Font("Arial", 9F, FontStyle.Bold))
            using (Brush panelBrush = new SolidBrush(Color.FromArgb(65, 80, 100)))
                g.DrawString(panelTitle, panelFont, panelBrush, plot.Left, plot.Top - 19F);

            string numberFormat = metric == ExportMetric.Gross ? "#,##0" : metric == ExportMetric.Deviation ? "0.0" : "0";
            DrawYAxis(g, plot, minimum, maximum, numberFormat);
            if (showXAxis) DrawGroupedXAxis(g, plot, labels);

            float zeroY = plot.Bottom - (float)((0M - minimum) / (maximum - minimum)) * plot.Height;
            using (Pen zeroPen = new Pen(Color.Gray, 1.3F))
                g.DrawLine(zeroPen, plot.Left, zeroY, plot.Right, zeroY);

            int groupCount = Math.Max(labels.Count, 1);
            int seriesCount = Math.Max(series.Count, 1);
            float groupWidth = plot.Width / (float)groupCount;
            float availableWidth = groupWidth * 0.82F;
            float barWidth = Math.Max(0.75F, Math.Min(28F, availableWidth / seriesCount));
            float renderedGroupWidth = barWidth * seriesCount;
            List<List<PointF>> trendPoints = new List<List<PointF>>();
            for (int i = 0; i < series.Count; i++) trendPoints.Add(new List<PointF>());

            for (int groupIndex = 0; groupIndex < labels.Count; groupIndex++)
            {
                float groupLeft = plot.Left + groupWidth * groupIndex + (groupWidth - renderedGroupWidth) / 2F;
                for (int seriesIndex = 0; seriesIndex < series.Count; seriesIndex++)
                {
                    decimal value = groupIndex < series[seriesIndex].Values.Count ? series[seriesIndex].Values[groupIndex] : 0M;
                    float valueY = plot.Bottom - (float)((value - minimum) / (maximum - minimum)) * plot.Height;
                    float top = Math.Min(zeroY, valueY);
                    float barHeight = Math.Max(1F, Math.Abs(zeroY - valueY));
                    float barLeft = groupLeft + seriesIndex * barWidth;
                    using (Brush brush = new SolidBrush(Color.FromArgb(165, series[seriesIndex].Color)))
                        g.FillRectangle(brush, barLeft, top, Math.Max(0.6F, barWidth - 0.4F), barHeight);
                    trendPoints[seriesIndex].Add(new PointF(barLeft + barWidth / 2F, valueY));
                }
            }

            for (int seriesIndex = 0; seriesIndex < series.Count; seriesIndex++)
            {
                PointF[] points = trendPoints[seriesIndex].ToArray();
                using (Pen trendPen = new Pen(series[seriesIndex].Color, 1.7F))
                using (Brush pointBrush = new SolidBrush(series[seriesIndex].Color))
                {
                    if (points.Length > 1) g.DrawLines(trendPen, points);
                    foreach (PointF point in points)
                        g.FillEllipse(pointBrush, point.X - 2F, point.Y - 2F, 4F, 4F);
                }
            }

            using (Font axisFont = new Font("Arial", 8F, FontStyle.Bold))
            using (Brush axisBrush = new SolidBrush(Color.DimGray))
            {
                string axisTitle = metric == ExportMetric.Headcount ? "Headcount" : metric == ExportMetric.Gross ? "Gross Salary" : "Change %";
                g.DrawString(axisTitle, axisFont, axisBrush, new PointF(13F, plot.Top + plot.Height / 2F - 7F));
                if (showXAxis) g.DrawString("Month", axisFont, axisBrush, new PointF(plot.Left + plot.Width / 2F - 18F, plot.Bottom + 39F));
            }
        }

        private static void DrawGroupedXAxis(Graphics g, Rectangle plot, List<string> labels)
        {
            if (labels.Count == 0) return;
            using (Font font = new Font("Arial", 8F))
            using (Brush brush = new SolidBrush(Color.DimGray))
            {
                float slot = plot.Width / (float)labels.Count;
                for (int i = 0; i < labels.Count; i++)
                {
                    float x = plot.Left + slot * i + slot / 2F;
                    SizeF size = g.MeasureString(labels[i], font);
                    g.DrawString(labels[i], font, brush, x - size.Width / 2F, plot.Bottom + 8F);
                }
            }
        }

        private static void DrawDepartmentLegend(Graphics g, Rectangle area, List<DepartmentChartSeries> series)
        {
            using (Font headerFont = new Font("Arial", 9F, FontStyle.Bold))
            using (Font itemFont = new Font("Arial", series.Count > 24 ? 7F : 8F))
            using (Brush textBrush = new SolidBrush(Color.FromArgb(55, 65, 80)))
            {
                g.DrawString("Department", headerFont, textBrush, area.Left, area.Top);
                int rowHeight = series.Count > 24 ? 15 : 18;
                int rowsPerColumn = Math.Max(1, (area.Height - 25) / rowHeight);
                int columnCount = Math.Max(1, (int)Math.Ceiling(series.Count / (double)rowsPerColumn));
                float columnWidth = area.Width / (float)columnCount;

                for (int i = 0; i < series.Count; i++)
                {
                    int column = i / rowsPerColumn;
                    int row = i % rowsPerColumn;
                    float x = area.Left + column * columnWidth;
                    float y = area.Top + 24F + row * rowHeight;
                    using (Brush swatch = new SolidBrush(series[i].Color))
                        g.FillRectangle(swatch, x, y + 2F, 11F, 11F);
                    g.DrawString(series[i].Department, itemFont, textBrush, new RectangleF(x + 16F, y, Math.Max(20F, columnWidth - 18F), rowHeight));
                }
            }
        }

        private static Color GetDepartmentChartColor(int index)
        {
            Color[] colors =
            {
                Color.FromArgb(70, 114, 169), Color.FromArgb(89, 161, 79), Color.FromArgb(242, 142, 43),
                Color.FromArgb(225, 87, 89), Color.FromArgb(176, 122, 161), Color.FromArgb(118, 183, 178),
                Color.FromArgb(237, 201, 72), Color.FromArgb(255, 157, 167), Color.FromArgb(156, 117, 95),
                Color.FromArgb(186, 176, 172), Color.FromArgb(52, 152, 219), Color.FromArgb(46, 204, 113),
                Color.FromArgb(155, 89, 182), Color.FromArgb(230, 126, 34), Color.FromArgb(22, 160, 133),
                Color.FromArgb(192, 57, 43), Color.FromArgb(127, 140, 141), Color.FromArgb(41, 128, 185),
                Color.FromArgb(39, 174, 96), Color.FromArgb(142, 68, 173), Color.FromArgb(211, 84, 0),
                Color.FromArgb(44, 62, 80), Color.FromArgb(241, 196, 15), Color.FromArgb(26, 188, 156)
            };
            return colors[index % colors.Length];
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
