using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using WebPortal.App_Code.DAL;

public static class FeedbackPerformanceExcelExporter
{
    public static void Download(DateTime fromDate, DateTime toDate)
    {
        DataSet ds = LoadReportData(fromDate, toDate);
        string templatePath = HttpContext.Current.Server.MapPath(
            "~/ReportTemplates/Feedback_Performance_Template.xlsx");

        if (!File.Exists(templatePath))
            throw new FileNotFoundException("Feedback report template was not found.", templatePath);

        using (var workbook = new XLWorkbook(templatePath))
        {
            string monthLong = fromDate.ToString("MMMM yyyy", CultureInfo.InvariantCulture);
            string monthShort = fromDate.ToString("MMM-yy", CultureInfo.InvariantCulture);

            BuildReviewerPerformance(workbook, ds.Tables[0], monthLong, monthShort);
            BuildQCerPerformance(workbook, ds.Tables[1], monthLong, monthShort);
            BuildExceptionSummary(workbook, ds.Tables[2], true, monthLong);
            BuildExceptionSummary(workbook, ds.Tables[3], false, monthLong);
            BuildTrendAnalysis(workbook, ds.Tables[4], ds.Tables[5], ds.Tables[6], monthLong, monthShort);

            using (var stream = new MemoryStream())
            {
                workbook.SaveAs(stream);
                HttpResponse response = HttpContext.Current.Response;
                response.Clear();
                response.Buffer = true;
                response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                response.AddHeader("Content-Disposition",
                    "attachment; filename=Feedback_Performance_" + fromDate.ToString("MMM_yyyy") + ".xlsx");
                response.BinaryWrite(stream.ToArray());
                response.Flush();
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }
    }

    public static DataSet LoadReportData(DateTime fromDate, DateTime toDate)
    {
        var ds = new DataSet();
        string cs = SQLHelper.ConnectionString;

        using (var con = new SqlConnection(cs))
        using (var cmd = new SqlCommand("dbo.usp_GetServicingFeedbackPerformanceReport", con))
        using (var da = new SqlDataAdapter(cmd))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 300;
            cmd.Parameters.Add("@FromDate", SqlDbType.Date).Value = fromDate.Date;
            cmd.Parameters.Add("@ToDate", SqlDbType.Date).Value = toDate.Date;
            da.Fill(ds);
        }

        if (ds.Tables.Count < 7)
            throw new InvalidOperationException("The report procedure must return seven result sets.");

        return ds;
    }

    private static void BuildReviewerPerformance(XLWorkbook wb, DataTable dt, string monthLong, string monthShort)
    {
        RenameSheet(wb, 1, "Reviewer Performance " + monthShort);
        var ws = wb.Worksheet(1);
        ResetSheet(ws);
        WriteTitle(ws, 1, 10, "Reviewer Performance — " + monthLong);

        string average = dt.Rows.Count == 0 ? "0.00" : ToDecimal(dt.Rows[0]["MonthlyAverage"]).ToString("0.00");
        string[] headers = { "Priority", "Reviewer", "Loan Count", "Critical Errors", "Non-Critical Errors",
            "Critical / Loan", "Non-Critical / Loan", "Total Error / Loan",
            "Ratio vs " + fromDateLabel(monthLong) + " Avg (" + average + ")", "Above Monthly Avg?" };
        WriteHeaders(ws, 2, headers);

        int row = 3;
        foreach (DataRow dr in dt.Rows)
        {
            SetCellValue(ws.Cell(row, 1), dr["Priority"]);
            SetCellValue(ws.Cell(row, 2), dr["Reviewer"]);
            SetCellValue(ws.Cell(row, 3), dr["LoanCount"]);
            SetCellValue(ws.Cell(row, 4), dr["CriticalErrors"]);
            SetCellValue(ws.Cell(row, 5), dr["NonCriticalErrors"]);

            ws.Cell(row, 6).Value = ToDecimal(dr["CriticalPerLoan"]);
            ws.Cell(row, 7).Value = ToDecimal(dr["NonCriticalPerLoan"]);
            ws.Cell(row, 8).Value = ToDecimal(dr["TotalErrorPerLoan"]);
            ws.Cell(row, 9).Value = ToDecimal(dr["RatioVsMonthlyAverage"]);
            ws.Cell(row, 10).Value = Convert.ToString(dr["AboveMonthlyAverage"]);
            row++;
        }
        StylePerformanceSheet(ws, row - 1, 10);
    }

    private static void SetCellValue(IXLCell cell, object value)
    {
        if (value == null || value == DBNull.Value)
        {
            cell.SetValue(string.Empty);
            return;
        }

        Type valueType = Nullable.GetUnderlyingType(value.GetType())
                         ?? value.GetType();

        if (valueType == typeof(DateTime))
        {
            cell.SetValue(Convert.ToDateTime(value, CultureInfo.InvariantCulture));
        }
        else if (valueType == typeof(bool))
        {
            cell.SetValue(Convert.ToBoolean(value, CultureInfo.InvariantCulture));
        }
        else if (valueType == typeof(byte) ||
                 valueType == typeof(short) ||
                 valueType == typeof(int) ||
                 valueType == typeof(long))
        {
            cell.SetValue(Convert.ToInt64(value, CultureInfo.InvariantCulture));
        }
        else if (valueType == typeof(float) ||
                 valueType == typeof(double) ||
                 valueType == typeof(decimal))
        {
            cell.SetValue(Convert.ToDecimal(value, CultureInfo.InvariantCulture));
        }
        else
        {
            string text = Convert.ToString(value, CultureInfo.InvariantCulture) ?? string.Empty;

            // Excel cells support a maximum of 32,767 characters.
            // Truncate oversized feedback summaries instead of failing the entire export.
            if (text.Length > 32767)
                text = text.Substring(0, 32767);

            cell.SetValue(text);
        }
    }

    private static void BuildQCerPerformance(XLWorkbook wb, DataTable dt, string monthLong, string monthShort)
    {
        RenameSheet(wb, 2, "QCer Performance " + monthShort);
        var ws = wb.Worksheet(2);
        ResetSheet(ws);
        WriteTitle(ws, 1, 8, "QCer Performance — " + monthLong);
        WriteHeaders(ws, 2, new[] { "Priority", "QCer", "Loan Count (Files QCed)", "ReQC Critical Errors",
            "ReQC Non-Critical Errors", "Critical / Loan", "Non-Critical / Loan", "Total Error / Loan" });

        int row = 3;
        foreach (DataRow dr in dt.Rows)
        {
            SetCellValue(ws.Cell(row, 1), dr["Priority"]);
            SetCellValue(ws.Cell(row, 2), dr["QCer"]);
            SetCellValue(ws.Cell(row, 3), dr["LoanCount"]);
            SetCellValue(ws.Cell(row, 4), dr["ReQCCriticalErrors"]);
            SetCellValue(ws.Cell(row, 5), dr["ReQCNonCriticalErrors"]);

            ws.Cell(row, 6).Value = ToDecimal(dr["CriticalPerLoan"]);
            ws.Cell(row, 7).Value = ToDecimal(dr["NonCriticalPerLoan"]);
            ws.Cell(row, 8).Value = ToDecimal(dr["TotalErrorPerLoan"]);
            row++;
        }
        StylePerformanceSheet(ws, row - 1, 8);
    }

    private static void BuildExceptionSummary(XLWorkbook wb, DataTable dt, bool reviewer, string monthLong)
    {
        int index = reviewer ? 3 : 4;
        string sheetName = reviewer ? "Reviewer Exception Summary" : "QCer Exception Summary";
        RenameSheet(wb, index, sheetName);
        var ws = wb.Worksheet(index);
        ResetSheet(ws);
        WriteTitle(ws, 1, 8, sheetName + " — " + monthLong);
        WriteHeaders(ws, 2, new[] { reviewer ? "Reviewer" : "QCer", "Total Critical Feedbacks", "Exception Missed",
            "Exception Relabeled/Moved", "Exception Downgraded", "Exception Elevated", "Other (Non-Exception)",
            "Feedback Summary (Loan#: Finding)" });

        int row = 3;
        foreach (DataRow dr in dt.Rows)
        {
            SetCellValue(
    ws.Cell(row, 1),
    dr[reviewer ? "Reviewer" : "QCer"]);

            SetCellValue(ws.Cell(row, 2), dr["TotalCriticalFeedbacks"]);
            SetCellValue(ws.Cell(row, 3), dr["ExceptionMissed"]);
            SetCellValue(ws.Cell(row, 4), dr["ExceptionRelabeledMoved"]);
            SetCellValue(ws.Cell(row, 5), dr["ExceptionDowngraded"]);
            SetCellValue(ws.Cell(row, 6), dr["ExceptionElevated"]);
            SetCellValue(ws.Cell(row, 7), dr["OtherNonException"]);
            SetCellValue(ws.Cell(row, 8), dr["FeedbackSummary"]);
            row++;
        }

        int last = Math.Max(3, row - 1);
        StyleExceptionSheet(ws, last);
    }

    private static void BuildTrendAnalysis(XLWorkbook wb, DataTable overall, DataTable reviewers,
        DataTable qcers, string monthLong, string monthShort)
    {
        RenameSheet(wb, 5, "Trend Analysis " + monthShort);
        var ws = wb.Worksheet(5);
        ResetSheet(ws);
        WriteTitle(ws, 1, 11, "Week-wise Trend Analysis — " + monthLong);

        ws.Cell(2, 1).Value = "Overall — " + monthLong + " by week";
        ws.Range(2, 1, 2, 11).Merge().Style.Font.SetBold().Font.SetFontSize(12);
        WriteHeaders(ws, 3, new[] { "Week", "Period", "Loans QCed", "Reviewer Errors (C+NC)",
            "Reviewer Error/Loan", "Reviewer vs Prior Week", "QC Misses (C+NC)", "QC Miss/Loan",
            "QC vs Prior Week", "Combined Error/Loan", "Combined vs Prior Week" });

        int row = 4;
        decimal? priorReviewer = null, priorQc = null, priorCombined = null;
        foreach (DataRow dr in overall.Rows)
        {
            decimal reviewer = ToDecimal(dr["ReviewerErrorPerLoan"]);
            decimal qc = ToDecimal(dr["QCMissPerLoan"]);
            decimal combined = ToDecimal(dr["CombinedErrorPerLoan"]);
            SetCellValue(ws.Cell(row, 1), dr["WeekName"]);

            ws.Cell(row, 2).Value =
                Convert.ToDateTime(dr["FromDate"]).ToString("MMM dd") +
                " - " +
                Convert.ToDateTime(dr["ToDate"]).ToString("MMM dd");

            SetCellValue(ws.Cell(row, 3), dr["LoansQCed"]);
            SetCellValue(ws.Cell(row, 4), dr["ReviewerErrors"]);

            ws.Cell(row, 5).Value = reviewer;
            SetTrendCell(ws.Cell(row, 6), TrendText(priorReviewer, reviewer));

            SetCellValue(ws.Cell(row, 7), dr["QCMisses"]);

            ws.Cell(row, 8).Value = qc;
            SetTrendCell(ws.Cell(row, 9), TrendText(priorQc, qc));
            ws.Cell(row, 10).Value = combined;
            SetTrendCell(ws.Cell(row, 11), TrendText(priorCombined, combined));
            priorReviewer = reviewer; priorQc = qc; priorCombined = combined;
            row++;
        }

        row++;
        WritePersonTrend(ws, ref row, reviewers, "Reviewer", "Reviewer week-wise Error/Loan (all reviewers, worst " + fromDateLabel(monthLong) + " first)", monthLong);
        row++;
        WritePersonTrend(ws, ref row, qcers, "QCer", "QCer week-wise Error/Loan (all QCers, worst " + fromDateLabel(monthLong) + " first)", monthLong);

        StyleTrendSheet(ws, row - 1);
    }

    private static void WritePersonTrend(IXLWorksheet ws, ref int row, DataTable dt, string personColumn, string sectionTitle, string monthLong)
    {
        ws.Cell(row, 1).Value = sectionTitle;
        ws.Range(row, 1, row, 8).Merge().Style.Font.SetBold().Font.SetFontSize(12);
        row++;
        WriteHeaders(ws, row, new[] { personColumn, fromDateLabel(monthLong) + " Error/Loan", "Week 1", "Week 2", "Week 3", "Week 4", "Week 5",
            fromDateLabel(monthLong) + " Trend (last vs first active week)" });
        row++;

        foreach (DataRow dr in dt.Rows)
        {
            var weeks = new List<decimal?>();
            SetCellValue(ws.Cell(row, 1), dr[personColumn]);
            SetCellValue(
                ws.Cell(row, 2),
                ToNullableDecimal(dr["MonthErrorPerLoan"]));
            for (int i = 1; i <= 5; i++)
            {
                decimal? value = ToNullableDecimal(dr["Week" + i]);
                weeks.Add(value);
                if (value.HasValue) ws.Cell(row, i + 2).Value = value.Value;
            }
            SetTrendCell(ws.Cell(row, 8), PersonTrendText(weeks));
            row++;
        }
    }

    private static void ResetSheet(IXLWorksheet ws)
    {
        // Clear template-level objects before rebuilding the worksheet.
        // Leaving old merged ranges or an old AutoFilter in place can create
        // overlapping/invalid worksheet XML and Excel will repair the file.
        foreach (var mergedRange in ws.MergedRanges.ToList())
            mergedRange.Unmerge();

        if (ws.AutoFilter.IsEnabled)
            ws.AutoFilter.Clear();

        ws.Cells().Clear(XLClearOptions.All);
        ws.SheetView.FreezeRows(2);
        ws.Style.Font.FontName = "Calibri";
        ws.Style.Font.FontSize = 10;
    }

    private static void WriteTitle(IXLWorksheet ws, int row, int columns, string title)
    {
        ws.Range(row, 1, row, columns).Merge();
        var cell = ws.Cell(row, 1);
        cell.Value = title;
        cell.Style.Fill.BackgroundColor = XLColor.FromHtml("#1F4E78");
        cell.Style.Font.Bold = true;
        cell.Style.Font.FontColor = XLColor.White;
        cell.Style.Font.FontSize = 16;
        cell.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
        cell.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
        ws.Row(row).Height = 28;
    }

    private static void WriteHeaders(IXLWorksheet ws, int row, string[] headers)
    {
        for (int i = 0; i < headers.Length; i++) ws.Cell(row, i + 1).Value = headers[i];
        var range = ws.Range(row, 1, row, headers.Length);
        range.Style.Fill.BackgroundColor = XLColor.FromHtml("#D9EAF7");
        range.Style.Font.Bold = true;
        range.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
        range.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
        range.Style.Alignment.WrapText = true;
        range.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
        range.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
        ws.Row(row).Height = 38;
    }

    private static void StylePerformanceSheet(IXLWorksheet ws, int lastRow, int lastColumn)
    {
        var data = ws.Range(3, 1, Math.Max(lastRow, 3), lastColumn);
        data.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
        data.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
        data.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
        data.Columns(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
        data.Columns(3, lastColumn).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
        if (lastColumn >= 8) ws.Range(3, 6, Math.Max(lastRow, 3), lastColumn - (lastColumn == 10 ? 1 : 0)).Style.NumberFormat.Format = "0.00";
        ws.Column(1).Width = 10; ws.Column(2).Width = 28;
        for (int c = 3; c <= lastColumn; c++) ws.Column(c).Width = 18;
        ws.RangeUsed().SetAutoFilter();
    }

    private static void StyleExceptionSheet(IXLWorksheet ws, int lastRow)
    {
        var data = ws.Range(3, 1, lastRow, 8);
        data.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
        data.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
        data.Style.Alignment.Vertical = XLAlignmentVerticalValues.Top;
        data.Style.Alignment.WrapText = true;
        ws.Column(1).Width = 28;
        for (int c = 2; c <= 7; c++) ws.Column(c).Width = 18;
        ws.Column(8).Width = 105;
        for (int r = 3; r <= lastRow; r++) ws.Row(r).AdjustToContents(20, 180);
        ws.RangeUsed().SetAutoFilter();
    }

    private static void StyleTrendSheet(IXLWorksheet ws, int lastRow)
    {
        var used = ws.Range(3, 1, Math.Max(lastRow, 3), 11);
        used.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
        used.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
        used.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
        ws.Columns(1, 1).Width = 27; ws.Column(2).Width = 21;
        for (int c = 3; c <= 11; c++) ws.Column(c).Width = 18;
        ws.Range(4, 5, Math.Max(lastRow, 4), 10).Style.NumberFormat.Format = "0.00";
    }

    private static void RenameSheet(XLWorkbook wb, int position, string name)
    {
        var ws = wb.Worksheet(position);
        string safeName = name.Length > 31 ? name.Substring(0, 31) : name;
        if (!string.Equals(ws.Name, safeName, StringComparison.OrdinalIgnoreCase)) ws.Name = safeName;
    }

    private static decimal ToDecimal(object value) => value == DBNull.Value ? 0M : Convert.ToDecimal(value);
    private static decimal? ToNullableDecimal(object value) => value == DBNull.Value || value == null ? (decimal?)null : Convert.ToDecimal(value);
    private static string fromDateLabel(string monthLong) => DateTime.ParseExact(monthLong, "MMMM yyyy", CultureInfo.InvariantCulture).ToString("MMM");

    private static string TrendText(decimal? prior, decimal current)
    {
        if (!prior.HasValue) return "—";
        if (prior.Value == 0) return current == 0 ? "— stable" : "▼ new errors";

        decimal pct = ((current - prior.Value) / prior.Value) * 100M;
        if (Math.Abs(pct) < 0.5M) return "— stable";

        // This is a quality/error report: an increase in errors is negative.
        // Therefore increase = red down arrow, decrease = green up arrow.
        return (pct > 0 ? "▼ " : "▲ ") + Math.Abs(pct).ToString("0.0") + "%";
    }

    private static string PersonTrendText(IEnumerable<decimal?> values)
    {
        var active = values.Where(x => x.HasValue).Select(x => x.Value).ToList();
        if (active.Count <= 1) return "single week";

        decimal first = active.First(), last = active.Last();
        if (first == 0 && last == 0) return "— stable";
        if (first == 0) return "▼ new errors";

        decimal pct = ((last - first) / first) * 100M;
        if (Math.Abs(pct) < 0.5M) return "— stable";

        return (pct > 0 ? "▼ " : "▲ ") + Math.Abs(pct).ToString("0") + "%";
    }

    private static void SetTrendCell(IXLCell cell, string text)
    {
        cell.Value = text;
        cell.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

        if (text.StartsWith("▼", StringComparison.Ordinal))
        {
            cell.Style.Font.FontColor = XLColor.FromHtml("#C00000");
            cell.Style.Font.Bold = true;
        }
        else if (text.StartsWith("▲", StringComparison.Ordinal))
        {
            cell.Style.Font.FontColor = XLColor.FromHtml("#008000");
            cell.Style.Font.Bold = true;
        }
        else
        {
            cell.Style.Font.FontColor = XLColor.FromHtml("#7F7F7F");
            cell.Style.Font.Bold = false;
        }
    }
}
