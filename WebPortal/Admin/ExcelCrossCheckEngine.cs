using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;

namespace InfinityERP.Admin
{
    public static class ExcelCrossCheckEngine
    {
        public const string StatusMissing = "MISSING FIELD IN LAURAMAC";
        public const string StatusWrongType = "WRONG VALUE TYPE";
        public const string StatusMismatch = "Value Mismatch";
        public const string StatusNotReflecting = "Not Reflecting in Lauramac";
        public const string StatusExtra = "Extra Value in Lauramac";
        public const string StatusFormat = "Format Difference";
        public const string StatusMatch = "Match";
        public const string StatusBlank = "Blank / NA in Both";

        private static readonly string[] PreferredRowKeys =
        {
            "Borrower First Name",
            "Borrower Last Name",
            "Property Address Street",
            "Property Postal Code"
        };

        private static readonly Dictionary<string, string> StateMap = CreateStateMap();

        public static CrossCheckResult Compare(string sciennaPath, string lauramacPath)
        {
            using (var swb = new XLWorkbook(sciennaPath))
            using (var lwb = new XLWorkbook(lauramacPath))
            {
                if (!swb.TryGetWorksheet("Full Export", out IXLWorksheet sws))
                    throw new InvalidOperationException("Scienna sheet 'Full Export' was not found.");

                if (!lwb.TryGetWorksheet("Entire Script Report", out IXLWorksheet lws))
                    throw new InvalidOperationException("Lauramac sheet 'Entire Script Report' was not found.");

                var sHeaders = ReadHeaders(sws);
                var lHeaders = ReadHeaders(lws);

                if (sHeaders.Count == 0 || lHeaders.Count == 0)
                    throw new InvalidOperationException("Header row is empty in one of the input files.");

                IXLRow lauraRow = GetSingleLauramacDataRow(lws);
                IXLRow sciennaRow = FindSciennaRow(sws, sHeaders, lHeaders, lauraRow);

                var result = new CrossCheckResult
                {
                    SciennaHeaderCount = sHeaders.Count,
                    LauramacHeaderCount = lHeaders.Count,
                    CommonHeaderCount = sHeaders.Keys.Count(lHeaders.ContainsKey),
                    SciennaOnlyHeaders = sHeaders.Keys.Where(x => !lHeaders.ContainsKey(x)).ToList(),
                    LauramacOnlyHeaders = lHeaders.Keys.Where(x => !sHeaders.ContainsKey(x)).ToList(),
                    MatchedRowDescription = BuildMatchedRowDescription(sciennaRow, sHeaders)
                };

                foreach (var sh in sHeaders.OrderBy(x => x.Value))
                {
                    string field = sh.Key;
                    string sValue = GetCellDisplay(sciennaRow.Cell(sh.Value));

                    if (!lHeaders.TryGetValue(field, out int lCol))
                    {
                        result.Rows.Add(new CrossCheckRow
                        {
                            FieldName = field,
                            SciennaValue = sValue,
                            LauramacValue = string.Empty,
                            InLauramac = false,
                            Status = StatusMissing,
                            IssueDetail = "Field not found in Lauramac Entire Script report"
                        });
                        continue;
                    }

                    string lValue = GetCellDisplay(lauraRow.Cell(lCol));
                    ComparisonDecision decision = CompareValue(field, sciennaRow.Cell(sh.Value), lauraRow.Cell(lCol), sValue, lValue);

                    result.Rows.Add(new CrossCheckRow
                    {
                        FieldName = field,
                        SciennaValue = sValue,
                        LauramacValue = lValue,
                        InLauramac = true,
                        Status = decision.Status,
                        IssueDetail = decision.Detail
                    });
                }

                return result;
            }
        }

        private static Dictionary<string, int> ReadHeaders(IXLWorksheet ws)
        {
            var headers = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            int lastCol = ws.LastColumnUsed() == null ? 0 : ws.LastColumnUsed().ColumnNumber();

            for (int col = 1; col <= lastCol; col++)
            {
                string header = ws.Cell(1, col).GetString();
                if (string.IsNullOrEmpty(header))
                    continue;

                // Exact text match, case-insensitive only. Intentionally NO Trim() here.
                if (headers.ContainsKey(header))
                    throw new InvalidOperationException("Duplicate column header detected (case-insensitive): " + header);

                headers.Add(header, col);
            }

            return headers;
        }

        private static IXLRow GetSingleLauramacDataRow(IXLWorksheet ws)
        {
            var rows = ws.RowsUsed().Where(r => r.RowNumber() > 1 && !r.IsEmpty()).ToList();
            if (rows.Count == 0)
                throw new InvalidOperationException("Lauramac file does not contain any data row.");

            if (rows.Count > 1)
                throw new InvalidOperationException("Lauramac file contains more than one data row. This page currently compares one Lauramac loan/report at a time.");

            return rows[0];
        }

        private static IXLRow FindSciennaRow(
            IXLWorksheet sws,
            Dictionary<string, int> sHeaders,
            Dictionary<string, int> lHeaders,
            IXLRow lauraRow)
        {
            var usableKeys = PreferredRowKeys
                .Where(k => sHeaders.ContainsKey(k) && lHeaders.ContainsKey(k))
                .Select(k => new
                {
                    Header = k,
                    LauraValue = NormalizeData(GetCellDisplay(lauraRow.Cell(lHeaders[k])))
                })
                .Where(x => !IsBlank(x.LauraValue))
                .ToList();

            if (usableKeys.Count < 2)
                throw new InvalidOperationException(
                    "Unable to identify the Scienna record safely. At least two same-named identifier fields are required (Borrower First Name, Borrower Last Name, Property Address Street, Property Postal Code). No differently named fields are mapped.");

            var matches = new List<IXLRow>();
            foreach (IXLRow row in sws.RowsUsed().Where(r => r.RowNumber() > 1 && !r.IsEmpty()))
            {
                bool isMatch = usableKeys.All(k =>
                    string.Equals(
                        NormalizeData(GetCellDisplay(row.Cell(sHeaders[k.Header]))),
                        k.LauraValue,
                        StringComparison.OrdinalIgnoreCase));

                if (isMatch)
                    matches.Add(row);
            }

            if (matches.Count == 0)
                throw new InvalidOperationException(
                    "No Scienna row matched the Lauramac record using the same-named identifier fields: " +
                    string.Join(", ", usableKeys.Select(x => x.Header)) + ".");

            if (matches.Count > 1)
                throw new InvalidOperationException(
                    "Multiple Scienna rows matched the Lauramac record. A unique row could not be identified using: " +
                    string.Join(", ", usableKeys.Select(x => x.Header)) + ".");

            return matches[0];
        }

        private static string BuildMatchedRowDescription(IXLRow row, Dictionary<string, int> headers)
        {
            var parts = new List<string>();
            foreach (string key in PreferredRowKeys)
            {
                if (headers.TryGetValue(key, out int col))
                {
                    string value = GetCellDisplay(row.Cell(col));
                    if (!IsBlank(value)) parts.Add(key + ": " + value);
                }
            }
            return string.Join(" | ", parts);
        }

        private static ComparisonDecision CompareValue(string field, IXLCell sCell, IXLCell lCell, string sRaw, string lRaw)
        {
            string s = NormalizeData(sRaw);
            string l = NormalizeData(lRaw);

            bool sb = IsBlank(s);
            bool lb = IsBlank(l);

            if (sb && lb)
                return D(StatusBlank, "No value on either side");

            if (!sb && lb)
                return D(StatusNotReflecting, "Scienna has \"" + sRaw + "\" (Lauramac blank / NA)");

            if (sb && !lb)
                return D(StatusExtra, "Lauramac has \"" + lRaw + "\" while Scienna is blank / NA");

            if (string.Equals(s, l, StringComparison.OrdinalIgnoreCase))
                return D(StatusMatch, "Values agree");

            if (TryDate(sCell, s, out DateTime sd) && TryDate(lCell, l, out DateTime ld))
            {
                if (sd.Date == ld.Date)
                    return D(StatusMatch, "Same date");
            }

            bool sNumber = TryDecimal(s, out decimal sn);
            bool lNumber = TryDecimal(l, out decimal ln);

            if (sNumber && lNumber)
            {
                if (sn == ln)
                    return D(StatusMatch, "Same numeric value");

                if (LooksPercentageField(field) && (NearlyEqual(sn * 100m, ln) || NearlyEqual(sn, ln * 100m)))
                    return D(StatusFormat, "Same percentage represented in a different scale");
            }

            if (TryState(s, out string ss) && TryState(l, out string ls) &&
                string.Equals(ss, ls, StringComparison.OrdinalIgnoreCase))
                return D(StatusFormat, "Same state represented in a different format");

            bool sDate = TryDate(sCell, s, out _);
            bool lDate = TryDate(lCell, l, out _);
            if ((sDate && lNumber && !sNumber) || (lDate && sNumber && !lNumber))
                return D(StatusWrongType, "Value type conflict: Scienna \"" + sRaw + "\" vs Lauramac \"" + lRaw + "\"");

            return D(StatusMismatch, "Scienna \"" + sRaw + "\" vs Lauramac \"" + lRaw + "\"");
        }

        private static string NormalizeData(string value)
        {
            return (value ?? string.Empty).Trim();
        }

        private static bool IsBlank(string value)
        {
            if (string.IsNullOrWhiteSpace(value)) return true;
            string v = value.Trim();
            return v.Equals("NA", StringComparison.OrdinalIgnoreCase)
                || v.Equals("N/A", StringComparison.OrdinalIgnoreCase)
                || v.Equals("N-A", StringComparison.OrdinalIgnoreCase)
                || v.Equals("Not Applicable", StringComparison.OrdinalIgnoreCase)
                || v.Equals("Not Available", StringComparison.OrdinalIgnoreCase)
                || v.Equals("NULL", StringComparison.OrdinalIgnoreCase);
        }

        private static string GetCellDisplay(IXLCell cell)
        {
            if (cell == null || cell.IsEmpty()) return string.Empty;
            try { return cell.GetFormattedString(); }
            catch { return cell.Value.ToString(CultureInfo.InvariantCulture); }
        }

        private static bool TryDate(IXLCell cell, string text, out DateTime value)
        {
            value = default(DateTime);
            if (cell != null && cell.TryGetValue<DateTime>(out DateTime dt))
            {
                value = dt;
                return true;
            }

            string[] formats =
            {
                "M/d/yyyy", "MM/dd/yyyy", "M-d-yyyy", "MM-dd-yyyy",
                "yyyy-MM-dd", "dd-MMM-yyyy", "d-MMM-yyyy", "MMM d, yyyy"
            };

            return DateTime.TryParseExact(text, formats, CultureInfo.InvariantCulture,
                       DateTimeStyles.None, out value)
                   || DateTime.TryParse(text, CultureInfo.InvariantCulture, DateTimeStyles.None, out value);
        }

        private static bool TryDecimal(string value, out decimal number)
        {
            string v = (value ?? string.Empty)
                .Replace("$", string.Empty)
                .Replace(",", string.Empty)
                .Replace("%", string.Empty)
                .Trim();

            return decimal.TryParse(v, NumberStyles.Any, CultureInfo.InvariantCulture, out number);
        }

        private static bool LooksPercentageField(string field)
        {
            string f = (field ?? string.Empty).ToLowerInvariant();
            return f.Contains("rate") || f.Contains("percent") || f.Contains("percentage") || f.Contains("ratio") || f.Contains("ltv") || f.Contains("dti");
        }

        private static bool NearlyEqual(decimal a, decimal b)
        {
            return Math.Abs(a - b) <= 0.00001m;
        }

        private static bool TryState(string value, out string abbreviation)
        {
            abbreviation = null;
            if (string.IsNullOrWhiteSpace(value)) return false;

            string v = value.Trim();
            if (v.Length == 2)
            {
                abbreviation = v.ToUpperInvariant();
                return StateMap.Values.Contains(abbreviation, StringComparer.OrdinalIgnoreCase);
            }

            return StateMap.TryGetValue(v, out abbreviation);
        }

        private static Dictionary<string, string> CreateStateMap()
        {
            return new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                {"Alabama","AL"},{"Alaska","AK"},{"Arizona","AZ"},{"Arkansas","AR"},{"California","CA"},
                {"Colorado","CO"},{"Connecticut","CT"},{"Delaware","DE"},{"Florida","FL"},{"Georgia","GA"},
                {"Hawaii","HI"},{"Idaho","ID"},{"Illinois","IL"},{"Indiana","IN"},{"Iowa","IA"},
                {"Kansas","KS"},{"Kentucky","KY"},{"Louisiana","LA"},{"Maine","ME"},{"Maryland","MD"},
                {"Massachusetts","MA"},{"Michigan","MI"},{"Minnesota","MN"},{"Mississippi","MS"},{"Missouri","MO"},
                {"Montana","MT"},{"Nebraska","NE"},{"Nevada","NV"},{"New Hampshire","NH"},{"New Jersey","NJ"},
                {"New Mexico","NM"},{"New York","NY"},{"North Carolina","NC"},{"North Dakota","ND"},{"Ohio","OH"},
                {"Oklahoma","OK"},{"Oregon","OR"},{"Pennsylvania","PA"},{"Rhode Island","RI"},{"South Carolina","SC"},
                {"South Dakota","SD"},{"Tennessee","TN"},{"Texas","TX"},{"Utah","UT"},{"Vermont","VT"},
                {"Virginia","VA"},{"Washington","WA"},{"West Virginia","WV"},{"Wisconsin","WI"},{"Wyoming","WY"},
                {"District of Columbia","DC"}
            };
        }

        private static ComparisonDecision D(string status, string detail)
        {
            return new ComparisonDecision { Status = status, Detail = detail };
        }

        public static void CreateOutputWorkbook(CrossCheckResult result, string outputPath)
        {
            using (var wb = new XLWorkbook())
            {
                CreateSummary(wb, result);
                CreateDetailSheet(wb, "Full Cross-Check", result.Rows);
                CreateDetailSheet(wb, "1-Missing in Lauramac", result.Rows.Where(x => x.Status == StatusMissing));
                CreateDetailSheet(wb, "2-Value Issues", result.Rows.Where(x => x.Status == StatusWrongType || x.Status == StatusMismatch || x.Status == StatusFormat));
                CreateDetailSheet(wb, "3-Not Reflecting", result.Rows.Where(x => x.Status == StatusNotReflecting));
                CreateDetailSheet(wb, "Extra in Lauramac", result.Rows.Where(x => x.Status == StatusExtra));
                wb.SaveAs(outputPath);
            }
        }

        private static void CreateSummary(XLWorkbook wb, CrossCheckResult result)
        {
            IXLWorksheet ws = wb.Worksheets.Add("Summary");
            ws.Cell("A1").Value = "Scienna vs Lauramac — Entire Script Report Cross-Check";
            ws.Range("A1:C1").Merge();
            ws.Cell("A1").Style.Font.Bold = true;
            ws.Cell("A1").Style.Font.FontSize = 16;

            ws.Cell("A2").Value = result.MatchedRowDescription +
                "  |  Scienna fields: " + result.SciennaHeaderCount.ToString("N0") +
                "  |  Lauramac fields: " + result.LauramacHeaderCount.ToString("N0") +
                "  |  Matched by field name: " + result.CommonHeaderCount.ToString("N0");
            ws.Range("A2:C2").Merge();

            ws.Cell("A4").Value = "Status";
            ws.Cell("B4").Value = "Count";
            ws.Cell("C4").Value = "Meaning";
            StyleHeader(ws.Range("A4:C4"));

            var statuses = new[]
            {
                StatusMissing, StatusWrongType, StatusMismatch, StatusNotReflecting,
                StatusExtra, StatusFormat, StatusMatch, StatusBlank
            };

            int r = 5;
            foreach (string status in statuses)
            {
                ws.Cell(r, 1).Value = status;
                ws.Cell(r, 2).Value = result.Rows.Count(x => x.Status == status);
                ws.Cell(r, 3).Value = Meaning(status);
                r++;
            }

            ws.Cell(r + 1, 1).Value = "Lauramac-only fields: " + string.Join(", ", result.LauramacOnlyHeaders);
            ws.Range(r + 1, 1, r + 1, 3).Merge();
            ws.Cell(r + 1, 1).Style.Alignment.WrapText = true;

            ws.Column(1).Width = 31;
            ws.Column(2).Width = 12;
            ws.Column(3).Width = 95;
            ws.SheetView.FreezeRows(4);
        }

        private static string Meaning(string status)
        {
            switch (status)
            {
                case StatusMissing: return "Scienna field does not exist in Lauramac by exact case-insensitive header name.";
                case StatusWrongType: return "Both contain values but their value types conflict.";
                case StatusMismatch: return "Both contain values but values genuinely differ.";
                case StatusNotReflecting: return "Scienna contains a value but Lauramac is blank / NA.";
                case StatusExtra: return "Lauramac contains a value where Scienna is blank / NA.";
                case StatusFormat: return "Same underlying value represented in a different format.";
                case StatusMatch: return "Values agree.";
                default: return "No meaningful value on either side.";
            }
        }

        private static void CreateDetailSheet(XLWorkbook wb, string name, IEnumerable<CrossCheckRow> source)
        {
            IXLWorksheet ws = wb.Worksheets.Add(name);
            string[] headers =
            {
                "#", "Scienna Field", "Scienna Value", "In Lauramac?", "Lauramac Value",
                "Status", "Issue Detail", "Existing Remark", "Lauramac Page", "Lauramac Section"
            };

            for (int i = 0; i < headers.Length; i++) ws.Cell(1, i + 1).Value = headers[i];
            StyleHeader(ws.Range(1, 1, 1, headers.Length));

            int r = 2;
            int n = 1;
            foreach (CrossCheckRow row in source)
            {
                ws.Cell(r, 1).Value = n++;
                ws.Cell(r, 2).Value = row.FieldName;
                ws.Cell(r, 3).Value = row.SciennaValue;
                ws.Cell(r, 4).Value = row.InLauramac ? "Yes" : "No";
                ws.Cell(r, 5).Value = row.LauramacValue;
                ws.Cell(r, 6).Value = row.Status;
                ws.Cell(r, 7).Value = row.IssueDetail;
                ws.Cell(r, 8).Value = row.ExistingRemark ?? string.Empty;
                ws.Cell(r, 9).Value = row.LauramacPage ?? string.Empty;
                ws.Cell(r, 10).Value = row.LauramacSection ?? string.Empty;
                r++;
            }

            if (r > 2)
                ws.Range(1, 1, r - 1, headers.Length).SetAutoFilter();

            ws.SheetView.FreezeRows(1);
            ws.Column(1).Width = 7;
            ws.Column(2).Width = 45;
            ws.Column(3).Width = 32;
            ws.Column(4).Width = 14;
            ws.Column(5).Width = 32;
            ws.Column(6).Width = 28;
            ws.Column(7).Width = 70;
            ws.Column(8).Width = 45;
            ws.Column(9).Width = 18;
            ws.Column(10).Width = 22;
            ws.RangeUsed().Style.Alignment.Vertical = XLAlignmentVerticalValues.Top;
            ws.Columns(2, 10).Style.Alignment.WrapText = true;
        }

        private static void StyleHeader(IXLRange range)
        {
            range.Style.Font.Bold = true;
            range.Style.Font.FontColor = XLColor.White;
            range.Style.Fill.BackgroundColor = XLColor.FromHtml("#1F4E78");
            range.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
        }

        private sealed class ComparisonDecision
        {
            public string Status { get; set; }
            public string Detail { get; set; }
        }
    }

    public sealed class CrossCheckResult
    {
        public CrossCheckResult()
        {
            Rows = new List<CrossCheckRow>();
            SciennaOnlyHeaders = new List<string>();
            LauramacOnlyHeaders = new List<string>();
        }

        public int SciennaHeaderCount { get; set; }
        public int LauramacHeaderCount { get; set; }
        public int CommonHeaderCount { get; set; }
        public string MatchedRowDescription { get; set; }
        public List<string> SciennaOnlyHeaders { get; set; }
        public List<string> LauramacOnlyHeaders { get; set; }
        public List<CrossCheckRow> Rows { get; private set; }
    }

    public sealed class CrossCheckRow
    {
        public string FieldName { get; set; }
        public string SciennaValue { get; set; }
        public bool InLauramac { get; set; }
        public string LauramacValue { get; set; }
        public string Status { get; set; }
        public string IssueDetail { get; set; }
        public string ExistingRemark { get; set; }
        public string LauramacPage { get; set; }
        public string LauramacSection { get; set; }
    }
}
