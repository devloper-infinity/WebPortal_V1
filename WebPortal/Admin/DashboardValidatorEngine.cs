using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Data.SqlClient;
using System.Text;
using System.Text.RegularExpressions;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    internal static class DashboardValidatorEngine
    {
        internal static IList<Phase2ResultRow> Generate(string inputPath, string validationPath, string templatePath, string outputPath)
        {
            IList<Phase2ResultRow> phase2Results = null;
            try
            {
                ValidateUnprotectedXlsx(inputPath, "Dashboard Report");
                ValidateUnprotectedXlsx(validationPath, "Validation File");
                using (var inputWorkbook = new XLWorkbook(inputPath))
                using (var outputWorkbook = new XLWorkbook(templatePath))
                {
                    IXLWorksheet inputSheet = FindInputSheet(inputWorkbook);
                    SourceData source = SourceData.Read(inputSheet);
                    var phase1Matches = new List<Phase1Match>();
                    ValidateRequiredFields(source);
                    ValidateTemplate(outputWorkbook);

                    if (outputWorkbook.Worksheets.Any(x => string.Equals(x.Name, "Sheet1", StringComparison.OrdinalIgnoreCase)))
                        outputWorkbook.Worksheet("Sheet1").Delete();

                    RecreateBlankSheet(outputWorkbook, "Worksheet");
                    PopulateDelinquentTaxes(outputWorkbook.Worksheet("Delinquent Taxes"), source, phase1Matches);
                    PopulateTaxLien(outputWorkbook.Worksheet("Tax Lien"), source, phase1Matches);
                    PopulateSimple(outputWorkbook.Worksheet("State Tax"), source, "State Tax Lien", "Fail", phase1Matches);
                    PopulateSimple(outputWorkbook.Worksheet("Federal Tax"), source, "Federal Tax Lien", "Fail", phase1Matches);
                    PopulateSeniorLien(outputWorkbook.Worksheet("Senior Lien"), source, phase1Matches);
                    PopulateSimple(outputWorkbook.Worksheet("HOA"), source, "HOA Lien Exists", "Y", phase1Matches);
                    PopulateCityMunicipal(outputWorkbook.Worksheet("City-Municipal"), source, phase1Matches);
                    PopulateSimple(outputWorkbook.Worksheet("Mobile Home"), source, "Mobile Home Present", "Y", phase1Matches);
                    RecreateBlankSheet(outputWorkbook, "Title Issue");
                    PopulateMaturityDate(outputWorkbook.Worksheet("Maturity Date"), source, phase1Matches);
                    PopulateForeclosureIssues(outputWorkbook.Worksheet("FC Issues"), source, phase1Matches);
                    PopulateSimple(outputWorkbook.Worksheet("Mod Issues"), source, "Subject Mortgage Modified", "Y", phase1Matches);
                    RecreateBlankSheet(outputWorkbook, "Origination Issue");

                    CleanOutputFormatting(outputWorkbook);
                    phase2Results = GeneratePhase2(outputWorkbook, validationPath, phase1Matches);

                    outputWorkbook.SaveAs(outputPath);
                }
                return phase2Results;
            }
            catch (InvalidOperationException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Unable to generate the cleaned dashboard report. " + ex.Message, ex);
            }
        }

        private static void ValidateUnprotectedXlsx(string path, string label)
        {
            byte[] signature = new byte[4];
            using (FileStream stream = File.OpenRead(path))
            {
                if (stream.Read(signature, 0, signature.Length) != signature.Length)
                    throw new InvalidOperationException(label + " is empty or invalid.");
            }
            if (signature[0] != 0x50 || signature[1] != 0x4B)
                throw new InvalidOperationException(label + " must be an unprotected .xlsx file. Remove the Excel password and upload the file again.");
        }

        private static IXLWorksheet FindInputSheet(XLWorkbook workbook)
        {
            IXLWorksheet dashboard = workbook.Worksheets.FirstOrDefault(x => string.Equals(x.Name, "Dashboard", StringComparison.OrdinalIgnoreCase));
            if (dashboard == null)
                throw new InvalidOperationException("Dashboard Report must contain a worksheet named 'Dashboard'.");
            return dashboard;
        }

        private static void ValidateTemplate(XLWorkbook workbook)
        {
            string[] required = { "Worksheet", "Delinquent Taxes", "Tax Lien", "State Tax", "Federal Tax", "Senior Lien", "HOA", "City-Municipal", "Mobile Home", "Title Issue", "Maturity Date", "FC Issues", "Mod Issues", "Origination Issue" };
            foreach (string name in required)
                if (!workbook.Worksheets.Any(x => string.Equals(x.Name, name, StringComparison.Ordinal)))
                    throw new InvalidOperationException("Dashboard Validator template is missing worksheet '" + name + "'.");
        }

        private static void ValidateRequiredFields(SourceData source)
        {
            string[] fields = {
                "Investor Loan ID", "Delinquent OR Unpaid Taxes", "Tax Lien", "Tax Foreclosure?", "Tax Mortgages",
                "Potential for Tax Cert Investor paying taxes", "State Tax Lien", "Federal Tax Lien",
                "Subject mortgage in first position?", "Junior Mortgages Count", "Prior Lien FC Y/N",
                "Prior Lien Release Required", "HOA Lien Exists", "City Muni Assessment Lien Exists",
                "Township Search Status (Township Level)", "Township Search Pass/Fail", "Mobile Home Present",
                "Orig Date", "Subject Mortgage Maturity Date", "Subject Mortgage Foreclosed",
                "Foreclosure Filed for Subject Mortgage", "Total Lien Amount Surviving Foreclosure Before Subject",
                "Subject Mortgage Modified"
            };
            foreach (string field in fields)
                source.Require(field);
        }

        private static void RecreateBlankSheet(XLWorkbook workbook, string sheetName)
        {
            IXLWorksheet existing = workbook.Worksheet(sheetName);
            int position = existing.Position;
            existing.Delete();
            IXLWorksheet blank = workbook.Worksheets.Add(sheetName);
            blank.Position = position;
        }

        private static void PopulateDelinquentTaxes(IXLWorksheet sheet, SourceData source, ICollection<Phase1Match> phase1Matches)
        {
            ClearRows(sheet, 2, Math.Max(2, sheet.LastRowUsed().RowNumber()), 1, 9);
            List<SourceRow> rows = source.Rows.Where(x => x.EqualsValue("Delinquent OR Unpaid Taxes", "Fail")).ToList();
            TrackPhase1Matches(rows, "Delinquent OR Unpaid Taxes", phase1Matches);
            WriteRows(sheet, 1, 1, 9, rows, null);
            for (int index = 0; index < rows.Count; index++)
                sheet.Cell(index + 2, 8).FormulaA1 = "=G" + (index + 2) + "*4/100";
        }

        private static void PopulateTaxLien(IXLWorksheet sheet, SourceData source, ICollection<Phase1Match> phase1Matches)
        {
            var blocks = new List<VerticalBlock>
            {
                new VerticalBlock(1, 9, "Tax Lien", "Y"),
                new VerticalBlock(9, 16, "Tax Foreclosure?", "Y"),
                new VerticalBlock(16, 21, "Tax Mortgages", "Y"),
                new VerticalBlock(21, null, "Potential for Tax Cert Investor paying taxes", "Red Flag")
            };

            int offset = 0;
            foreach (VerticalBlock block in blocks)
            {
                int headerRow = block.HeaderRow + offset;
                int? nextHeader = block.NextHeaderRow.HasValue ? block.NextHeaderRow.Value + offset : (int?)null;
                int originalLastDataRow = nextHeader.HasValue ? nextHeader.Value - 1 : Math.Max(headerRow + 1, sheet.LastRowUsed().RowNumber());
                ClearRows(sheet, headerRow + 1, originalLastDataRow, 1, 5);

                List<SourceRow> rows = source.Rows.Where(x => x.EqualsValue(block.Field, block.ExpectedValue)).ToList();
                TrackPhase1Matches(rows, block.Field, phase1Matches);
                int capacity = originalLastDataRow - headerRow;
                if (nextHeader.HasValue && rows.Count > capacity)
                {
                    int extraRows = rows.Count - capacity;
                    sheet.Row(nextHeader.Value).InsertRowsAbove(extraRows);
                    offset += extraRows;
                }
                WriteRows(sheet, headerRow, 1, 5, rows, null);
            }
        }

        private static void PopulateSimple(IXLWorksheet sheet, SourceData source, string field, string expected, ICollection<Phase1Match> phase1Matches)
        {
            ClearRows(sheet, 2, Math.Max(2, sheet.LastRowUsed().RowNumber()), 1, sheet.LastColumnUsed().ColumnNumber());
            List<SourceRow> rows = source.Rows.Where(x => x.EqualsValue(field, expected)).ToList();
            TrackPhase1Matches(rows, field, phase1Matches);
            WriteRows(sheet, 1, 1, sheet.LastColumnUsed().ColumnNumber(), rows, null);
        }

        private static void PopulateSeniorLien(IXLWorksheet sheet, SourceData source, ICollection<Phase1Match> phase1Matches)
        {
            int lastRow = Math.Max(49, sheet.LastRowUsed().RowNumber());
            List<SourceRow> seniorRows = source.Rows.Where(x => x.EqualsValue("Subject mortgage in first position?", "Fail")).ToList();
            TrackPhase1Matches(seniorRows, "Subject mortgage in first position?", phase1Matches);
            int extraSeniorRows = Math.Max(0, seniorRows.Count - 22);
            if (extraSeniorRows > 0)
            {
                sheet.Row(24).InsertRowsAbove(extraSeniorRows);
                lastRow += extraSeniorRows;
            }
            int juniorHeaderRow = 24 + extraSeniorRows;

            ClearRows(sheet, 2, juniorHeaderRow - 1, 1, 5);
            ClearRows(sheet, juniorHeaderRow + 1, lastRow, 1, 5);
            ClearRows(sheet, 2, lastRow, 9, 10);
            ClearRows(sheet, 2, lastRow, 13, 14);

            WriteRows(sheet, 1, 1, 5, seniorRows, null);

            List<SourceRow> juniorRows = source.Rows.Where(x => x.HasPositiveNumber("Junior Mortgages Count")).ToList();
            TrackPhase1Matches(juniorRows, "Junior Mortgages Count", phase1Matches);
            sheet.Cell(juniorHeaderRow, 5).Clear(XLClearOptions.All);
            WriteRows(sheet, juniorHeaderRow, 1, 4, juniorRows, null);

            List<SourceRow> priorForeclosureRows = source.Rows.Where(x => x.EqualsValue("Prior Lien FC Y/N", "Y")).ToList();
            TrackPhase1Matches(priorForeclosureRows, "Prior Lien FC Y/N", phase1Matches);
            WriteRows(sheet, 1, 9, 10, priorForeclosureRows, null);
            List<SourceRow> releaseRows = source.Rows.Where(x => x.EqualsValue("Prior Lien Release Required", "Y")).ToList();
            TrackPhase1Matches(releaseRows, "Prior Lien Release Required", phase1Matches);
            WriteRows(sheet, 1, 13, 14, releaseRows, null);
        }

        private static void CleanOutputFormatting(XLWorkbook workbook)
        {
            string[] blankSheets = { "Worksheet", "Title Issue", "Origination Issue" };
            foreach (IXLWorksheet sheet in workbook.Worksheets)
            {
                if (blankSheets.Contains(sheet.Name, StringComparer.Ordinal))
                    continue;

                IXLRange used = sheet.RangeUsed(XLCellsUsedOptions.All);
                if (used != null)
                {
                    used.Style.Font.FontName = "Bahnschrift";
                    used.Style.Font.FontSize = 10;
                    foreach (IXLCell cell in used.Cells())
                    {
                        cell.Style.Fill.PatternType = XLFillPatternValues.None;
                        cell.Style.Fill.BackgroundColor = XLColor.NoColor;
                        cell.Style.Fill.PatternColor = XLColor.NoColor;
                    }
                }

                List<IXLCell> sectionStarts = sheet.CellsUsed(XLCellsUsedOptions.Contents)
                    .Where(x => string.Equals(Normalize(x.GetString()), Normalize("Investor Loan ID"), StringComparison.Ordinal))
                    .OrderBy(x => x.Address.RowNumber)
                    .ThenBy(x => x.Address.ColumnNumber)
                    .ToList();

                foreach (IXLCell start in sectionStarts)
                {
                    int headerRow = start.Address.RowNumber;
                    int startColumn = start.Address.ColumnNumber;
                    int nextStartColumn = sectionStarts
                        .Where(x => x.Address.RowNumber == headerRow && x.Address.ColumnNumber > startColumn)
                        .Select(x => x.Address.ColumnNumber)
                        .DefaultIfEmpty(sheet.LastColumnUsed(XLCellsUsedOptions.Contents).ColumnNumber() + 1)
                        .Min();
                    int endColumn = startColumn;
                    for (int column = startColumn; column < nextStartColumn; column++)
                        if (!sheet.Cell(headerRow, column).IsEmpty()) endColumn = column;

                    int nextHeaderRow = sectionStarts
                        .Where(x => x.Address.ColumnNumber == startColumn && x.Address.RowNumber > headerRow)
                        .Select(x => x.Address.RowNumber)
                        .DefaultIfEmpty(sheet.LastRowUsed(XLCellsUsedOptions.Contents).RowNumber() + 1)
                        .Min();
                    int lastDataRow = headerRow;
                    for (int row = headerRow + 1; row < nextHeaderRow; row++)
                    {
                        if (sheet.Cell(row, startColumn).IsEmpty()) break;
                        lastDataRow = row;
                    }

                    IXLRange section = sheet.Range(headerRow, startColumn, lastDataRow, endColumn);
                    section.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    section.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                    IXLRange headerRange = sheet.Range(headerRow, startColumn, headerRow, endColumn);
                    headerRange.Style.Fill.SetBackgroundColor(XLColor.FromHtml("#B7DEE8"));
                    headerRange.Style.Fill.PatternType = XLFillPatternValues.Solid;
                    headerRange.Style.Font.FontName = "Bahnschrift";
                    headerRange.Style.Font.FontSize = 10;
                    headerRange.Style.Font.Bold = true;
                    headerRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    headerRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                }
            }
        }

        private static void PopulateCityMunicipal(IXLWorksheet sheet, SourceData source, ICollection<Phase1Match> phase1Matches)
        {
            int lastRow = Math.Max(2, sheet.LastRowUsed().RowNumber());
            ClearRows(sheet, 2, lastRow, 1, 12);
            ClearRows(sheet, 2, lastRow, 14, 47);
            List<SourceRow> cityRows = source.Rows.Where(x => x.EqualsValue("City Muni Assessment Lien Exists", "Y")).ToList();
            TrackPhase1Matches(cityRows, "City Muni Assessment Lien Exists", phase1Matches);
            WriteRows(sheet, 1, 1, 12, cityRows, null);
            List<SourceRow> townshipRows = source.Rows.Where(x => x.EqualsValue("Township Search Status (Township Level)", "Completed") && x.EqualsValue("Township Search Pass/Fail", "Fail")).ToList();
            TrackPhase1Matches(townshipRows, "Township Search Status (Township Level)", phase1Matches);
            TrackPhase1Matches(townshipRows, "Township Search Pass/Fail", phase1Matches);
            WriteRows(sheet, 1, 14, 47, townshipRows, null);
        }

        private static void PopulateMaturityDate(IXLWorksheet sheet, SourceData source, ICollection<Phase1Match> phase1Matches)
        {
            ClearRows(sheet, 2, Math.Max(2, sheet.LastRowUsed().RowNumber()), 1, 3);
            List<SourceRow> rows = source.Rows.Where(IsMaturityIssue).ToList();
            TrackPhase1Matches(rows, "Subject Mortgage Maturity Date", phase1Matches);
            WriteRows(sheet, 1, 1, 3, rows, null);
        }

        private static bool IsMaturityIssue(SourceRow row)
        {
            if (row.IsBlank("Subject Mortgage Maturity Date"))
                return true;

            DateTime maturity;
            if (!row.TryGetDate("Subject Mortgage Maturity Date", out maturity))
                return false;
            if (maturity.Year == 1900)
                return true;

            DateTime originalDate;
            return row.TryGetDate("Orig Date", out originalDate) && maturity < originalDate.AddYears(30);
        }

        private static void PopulateForeclosureIssues(IXLWorksheet sheet, SourceData source, ICollection<Phase1Match> phase1Matches)
        {
            int lastRow = Math.Max(2, sheet.LastRowUsed().RowNumber());
            ClearRows(sheet, 2, lastRow, 1, 2);
            ClearRows(sheet, 2, lastRow, 5, 7);
            ClearRows(sheet, 2, lastRow, 11, 13);
            List<SourceRow> foreclosedRows = source.Rows.Where(x => x.EqualsValue("Subject Mortgage Foreclosed", "Fail")).ToList();
            TrackPhase1Matches(foreclosedRows, "Subject Mortgage Foreclosed", phase1Matches);
            WriteRows(sheet, 1, 1, 2, foreclosedRows, null);
            List<SourceRow> filingRows = source.Rows.Where(x => x.EqualsValue("Foreclosure Filed for Subject Mortgage", "Y")).ToList();
            TrackPhase1Matches(filingRows, "Foreclosure Filed for Subject Mortgage", phase1Matches);
            WriteRows(sheet, 1, 5, 7, filingRows, null);
            List<SourceRow> survivingLienRows = source.Rows.Where(x => x.HasAmount("Total Lien Amount Surviving Foreclosure Before Subject")).ToList();
            TrackPhase1Matches(survivingLienRows, "Total Lien Amount Surviving Foreclosure Before Subject", phase1Matches);
            WriteRows(sheet, 1, 11, 13, survivingLienRows, null);
        }

        private static void TrackPhase1Matches(IEnumerable<SourceRow> rows, string baseHeader, ICollection<Phase1Match> phase1Matches)
        {
            foreach (SourceRow row in rows)
                phase1Matches.Add(new Phase1Match(row.LoanId, baseHeader, row.GetAmounts(GetAmountFields(baseHeader))));
        }

        private static IList<Phase2ResultRow> GeneratePhase2(XLWorkbook outputWorkbook, string validationPath, IEnumerable<Phase1Match> phase1Matches)
        {
            Dictionary<string, ValidationDataRow> loanLookup;
            using (var validationWorkbook = new XLWorkbook(validationPath))
                loanLookup = BuildValidationLoanLookup(validationWorkbook);
            Dictionary<string, List<string>> exceptionMaster = LoadValidationExceptionMaster();

            if (outputWorkbook.Worksheets.Any(x => string.Equals(x.Name, "Validation", StringComparison.OrdinalIgnoreCase)))
                outputWorkbook.Worksheets.First(x => string.Equals(x.Name, "Validation", StringComparison.OrdinalIgnoreCase)).Delete();

            IXLWorksheet sheet = outputWorkbook.Worksheets.Add("Validation");
            sheet.Cell(1, 1).Value = "Loan #";
            sheet.Cell(1, 2).Value = "Exception Header";
            sheet.Cell(1, 3).Value = "Exception Description";

            int outputRow = 2;
            var results = new List<Phase2ResultRow>();
            var emittedValidations = new HashSet<string>(StringComparer.Ordinal);
            foreach (Phase1Match phase1Match in phase1Matches)
            {
                string pairKey = Normalize(phase1Match.LoanId) + "\u001f" + Normalize(phase1Match.BaseHeader);
                ValidationDataRow validationRow;
                if (!loanLookup.TryGetValue(phase1Match.LoanId.Trim(), out validationRow))
                {
                    string missingLoanKey = Normalize(phase1Match.LoanId) + "\u001fLOAN_NOT_FOUND";
                    if (emittedValidations.Add(missingLoanKey))
                        AddPhase2Failure(sheet, results, ref outputRow, phase1Match.LoanId,
                            "Loan # not found", "Loan # not found in Validation report");
                    continue;
                }

                if (string.Equals(Normalize(phase1Match.BaseHeader), Normalize("Subject Mortgage Modified"), StringComparison.Ordinal))
                {
                    if (emittedValidations.Add(pairKey + "\u001fTEXT") && string.IsNullOrWhiteSpace(validationRow.Modification))
                        AddPhase2Failure(sheet, results, ref outputRow, phase1Match.LoanId,
                            phase1Match.BaseHeader, "Modification is not present");
                    continue;
                }

                List<string> expectedTexts;
                if (exceptionMaster.TryGetValue(Normalize(phase1Match.BaseHeader), out expectedTexts)
                    && emittedValidations.Add(pairKey + "\u001fTEXT")
                    && !expectedTexts.Any(text => ContainsText(validationRow, text)))
                {
                    AddPhase2Failure(sheet, results, ref outputRow, phase1Match.LoanId,
                        phase1Match.BaseHeader,
                        GetSectionFailureMessage(phase1Match.BaseHeader));
                }

                foreach (Phase1Amount amount in phase1Match.Amounts)
                {
                    string amountKey = pairKey + "\u001fAMOUNT\u001f" + amount.Value.ToString("0.00", CultureInfo.InvariantCulture);
                    if (!emittedValidations.Add(amountKey))
                        continue;
                    if (ContainsAmount(validationRow, amount.Value))
                    {
                        AddPhase2Success(sheet, results, ref outputRow, phase1Match.LoanId,
                            phase1Match.BaseHeader, "Amount Validated");
                        continue;
                    }
                    AddPhase2Failure(sheet, results, ref outputRow, phase1Match.LoanId,
                        phase1Match.BaseHeader,
                        "Amount \"" + amount.DisplayValue + "\" not present in exception");
                }
            }

            IXLRange resultRange = sheet.Range(1, 1, Math.Max(1, outputRow - 1), 3);
            resultRange.Style.Font.FontName = "Bahnschrift";
            resultRange.Style.Font.FontSize = 10;
            resultRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            resultRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            IXLRange headerRange = sheet.Range(1, 1, 1, 3);
            headerRange.Style.Fill.SetBackgroundColor(XLColor.FromHtml("#B7DEE8"));
            headerRange.Style.Fill.PatternType = XLFillPatternValues.Solid;
            headerRange.Style.Font.Bold = true;
            sheet.Column(1).Width = 16;
            sheet.Column(2).Width = 48;
            sheet.Column(3).Width = 100;
            sheet.Column(3).Style.Alignment.WrapText = true;
            sheet.SheetView.FreezeRows(1);
            return results;
        }

        private static Dictionary<string, List<string>> LoadValidationExceptionMaster()
        {
            var result = new Dictionary<string, List<string>>(StringComparer.Ordinal);
            try
            {
                using (var connection = new SqlConnection(SQLHelper.ConnectionString))
                using (var command = new SqlCommand(
                    "SELECT Section, ExpectedExceptionText FROM dbo.ValidationExceptionMaster WHERE IsActive = 1 ORDER BY SourceRowNumber", connection))
                {
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string section = Convert.ToString(reader["Section"], CultureInfo.InvariantCulture).Trim();
                            string expectedText = Convert.ToString(reader["ExpectedExceptionText"], CultureInfo.InvariantCulture).Trim();
                            if (section.Length == 0 || expectedText.Length == 0) continue;
                            string key = Normalize(section);
                            List<string> texts;
                            if (!result.TryGetValue(key, out texts))
                            {
                                texts = new List<string>();
                                result.Add(key, texts);
                            }
                            if (!texts.Contains(expectedText, StringComparer.OrdinalIgnoreCase))
                                texts.Add(expectedText);
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                throw new InvalidOperationException("Unable to read Validation Exception Master. Run DashboardValidator_001_ValidationExceptionMaster.sql on the application database.", ex);
            }
            return result;
        }

        private static bool ContainsText(ValidationDataRow validationRow, string expectedText)
        {
            return validationRow != null && validationRow.GradeCells.Any(cell =>
                GetGradeText(cell).IndexOf(expectedText.Trim(), StringComparison.OrdinalIgnoreCase) >= 0);
        }

        private static bool ContainsAmount(ValidationDataRow validationRow, decimal expectedAmount)
        {
            if (validationRow == null) return false;
            foreach (ValidationGradeCell cell in validationRow.GradeCells)
            {
                foreach (Match match in Regex.Matches(GetGradeText(cell), @"(?<![A-Za-z0-9/-])\$?\s*\(?\d[\d,]*(?:\.\d+)?\)?(?![A-Za-z0-9/-])"))
                {
                    string token = match.Value.Replace("$", string.Empty).Replace(",", string.Empty).Trim();
                    bool negative = token.StartsWith("(", StringComparison.Ordinal) && token.EndsWith(")", StringComparison.Ordinal);
                    token = token.Replace("(", string.Empty).Replace(")", string.Empty).Trim();
                    decimal candidate;
                    if (decimal.TryParse(token, NumberStyles.Number, CultureInfo.InvariantCulture, out candidate)
                        && decimal.Round(negative ? -candidate : candidate, 2) == decimal.Round(expectedAmount, 2))
                        return true;
                }
            }
            return false;
        }

        private static string GetGradeText(ValidationGradeCell cell)
        {
            return cell.Value.IsBlank ? string.Empty : cell.Value.ToString().Trim();
        }

        private static void AddPhase2Failure(IXLWorksheet sheet, ICollection<Phase2ResultRow> results, ref int outputRow,
            string loanId, string section, string description)
        {
            sheet.Cell(outputRow, 1).Value = loanId;
            sheet.Cell(outputRow, 2).Value = section;
            sheet.Cell(outputRow, 3).Value = description;
            sheet.Range(outputRow, 1, outputRow, 3).Style.Fill.SetBackgroundColor(XLColor.FromHtml("#F4CCCC"));
            results.Add(new Phase2ResultRow(loanId, section, description, false));
            outputRow++;
        }

        private static void AddPhase2Success(IXLWorksheet sheet, ICollection<Phase2ResultRow> results, ref int outputRow,
            string loanId, string section, string description)
        {
            sheet.Cell(outputRow, 1).Value = loanId;
            sheet.Cell(outputRow, 2).Value = section;
            sheet.Cell(outputRow, 3).Value = description;
            sheet.Range(outputRow, 1, outputRow, 3).Style.Fill.SetBackgroundColor(XLColor.FromHtml("#D9EAD3"));
            results.Add(new Phase2ResultRow(loanId, section, description, true));
            outputRow++;
        }

        private static string GetSectionFailureMessage(string section)
        {
            string label = section.Trim();
            int suffix = label.IndexOf(" Lien Exists", StringComparison.OrdinalIgnoreCase);
            if (suffix > 0) label = label.Substring(0, suffix);
            return label + " exception is not present";
        }

        private static IEnumerable<string> GetAmountFields(string section)
        {
            string key = Normalize(section);
            if (key == Normalize("Delinquent OR Unpaid Taxes")) return new[] { "Delinquent Tax Amount" };
            if (key == Normalize("Tax Lien")) return new[] { "Tax Lien Amount Before Subject", "Tax Lien Amount After Subject" };
            if (key == Normalize("State Tax Lien")) return new[] { "State Tax Lien Amount Before Subject", "State Tax Lien Amount After Subject" };
            if (key == Normalize("Federal Tax Lien")) return new[] { "Federal Tax Lien Amount Before Subject", "Federal Tax Lien Amount After Subject" };
            if (key == Normalize("Subject mortgage in first position?")) return new[] { "Total Senior Mortgage Amount" };
            if (key == Normalize("Junior Mortgages Count")) return new[] { "Total Junior Mortgage Amount" };
            if (key == Normalize("HOA Lien Exists")) return new[] { "HOA Lien Amount Before Subject", "HOA Lien Amount After Subject" };
            if (key == Normalize("City Muni Assessment Lien Exists")) return new[] {
                "City Muni Assessment Lien Amount Before Subject", "City Muni Assessment Lien Amount After Subject",
                "Water Sewer  Utilities Lien Amount Before Subject", "Water Sewer Utilities Lien Amount After Subject",
                "Code Enforcement Lien amount Before", "Code Enforcement Lien amount After" };
            if (key == Normalize("Township Search Status (Township Level)")) return new[] {
                "Municipal Liens Total Amount", "Violations Total Amount", "Tax Sale Redemption Amt",
                "Total Tax Amount including Delinquent Taxes", "VPR Total Amount", "Total Amount Owed  (Water)", "Total Amount Owed (Sewer)" };
            if (key == Normalize("Total Lien Amount Surviving Foreclosure Before Subject")) return new[] {
                "Total Lien Amount Surviving Foreclosure Before Subject", "Total Lien Amount Surviving Foreclosure After Subject" };
            return Enumerable.Empty<string>();
        }

        private static Dictionary<string, ValidationDataRow> BuildValidationLoanLookup(XLWorkbook workbook)
        {
            string[] gradeHeaders = {
                "Grade 4 Exceptions (Reject / Non-curable)",
                "Grade 3 Exceptions (Conditions / Curable)",
                "Grade 2 Exceptions (Warnings)",
                "Grade 1 Exceptions (Notices / Informational)"
            };
            string[] loanHeaders = { "Loan #1", "Loan #", "Loan Number", "Loan ID", "Investor Loan ID" };

            foreach (IXLWorksheet sheet in workbook.Worksheets)
            {
                IXLRange used = sheet.RangeUsed();
                if (used == null) continue;

                int maximumHeaderRow = Math.Min(50, used.LastRow().RowNumber());
                for (int headerRow = 1; headerRow <= maximumHeaderRow; headerRow++)
                {
                    var columns = new Dictionary<string, int>(StringComparer.Ordinal);
                    var actualHeaders = new Dictionary<string, string>(StringComparer.Ordinal);
                    for (int column = 1; column <= used.LastColumn().ColumnNumber(); column++)
                    {
                        string actualHeader = sheet.Cell(headerRow, column).GetString();
                        string normalizedHeader = Normalize(actualHeader);
                        if (normalizedHeader.Length == 0 || columns.ContainsKey(normalizedHeader)) continue;
                        columns.Add(normalizedHeader, column);
                        actualHeaders.Add(normalizedHeader, actualHeader);
                    }

                    string loanHeader = loanHeaders.FirstOrDefault(x => columns.ContainsKey(Normalize(x)));
                    List<string> availableGradeHeaders = gradeHeaders
                        .Where(x => columns.ContainsKey(Normalize(x)))
                        .ToList();
                    if (loanHeader == null || availableGradeHeaders.Count == 0)
                        continue;

                    var lookup = new Dictionary<string, ValidationDataRow>(StringComparer.OrdinalIgnoreCase);
                    for (int row = headerRow + 1; row <= used.LastRow().RowNumber(); row++)
                    {
                        string loanId = sheet.Cell(row, columns[Normalize(loanHeader)]).GetString().Trim();
                        if (loanId.Length == 0) continue;
                        if (lookup.ContainsKey(loanId))
                            throw new InvalidOperationException("Validation File contains duplicate Loan # '" + loanId + "'.");

                        var gradeCells = new List<ValidationGradeCell>();
                        foreach (string gradeHeader in availableGradeHeaders)
                        {
                            string key = Normalize(gradeHeader);
                            gradeCells.Add(new ValidationGradeCell(actualHeaders[key], sheet.Cell(row, columns[key]).Value));
                        }
                        string modification = string.Empty;
                        int modificationColumn;
                        if (columns.TryGetValue(Normalize("Modification"), out modificationColumn)
                            || columns.TryGetValue(Normalize("Mod Comments"), out modificationColumn))
                            modification = sheet.Cell(row, modificationColumn).GetString().Trim();
                        lookup.Add(loanId, new ValidationDataRow(gradeCells, modification));
                    }
                    return lookup;
                }
            }

            throw new InvalidOperationException("Validation File must contain a supported Loan # column and at least one Grade exception column.");
        }

        private static void WriteRows(IXLWorksheet sheet, int headerRow, int firstColumn, int lastColumn, IList<SourceRow> rows, Action<IXLRow, SourceRow> afterWrite)
        {
            int styleRow = headerRow + 1;
            for (int index = 0; index < rows.Count; index++)
            {
                int targetRowNumber = headerRow + 1 + index;
                if (targetRowNumber != styleRow)
                {
                    for (int column = firstColumn; column <= lastColumn; column++)
                        sheet.Cell(targetRowNumber, column).Style = sheet.Cell(styleRow, column).Style;
                    sheet.Row(targetRowNumber).Height = sheet.Row(styleRow).Height;
                }

                SourceRow sourceRow = rows[index];
                for (int column = firstColumn; column <= lastColumn; column++)
                {
                    string header = sheet.Cell(headerRow, column).GetFormattedString(CultureInfo.InvariantCulture);
                    if (string.IsNullOrWhiteSpace(header))
                        continue;
                    XLCellValue value;
                    if (sourceRow.TryGetValue(header, out value))
                        sheet.Cell(targetRowNumber, column).Value = value;
                }
                if (afterWrite != null)
                    afterWrite(sheet.Row(targetRowNumber), sourceRow);
            }
        }

        private static void ClearRows(IXLWorksheet sheet, int firstRow, int lastRow, int firstColumn, int lastColumn)
        {
            if (lastRow >= firstRow)
                sheet.Range(firstRow, firstColumn, lastRow, lastColumn).Clear(XLClearOptions.Contents);
        }

        private static string Normalize(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return string.Empty;
            var result = new StringBuilder();
            bool previousSpace = false;
            foreach (char character in value.Trim())
            {
                if (char.IsWhiteSpace(character))
                {
                    if (!previousSpace) result.Append(' ');
                    previousSpace = true;
                }
                else
                {
                    result.Append(char.ToUpperInvariant(character));
                    previousSpace = false;
                }
            }
            return result.ToString();
        }

        private sealed class VerticalBlock
        {
            internal VerticalBlock(int headerRow, int? nextHeaderRow, string field, string expectedValue)
            {
                HeaderRow = headerRow;
                NextHeaderRow = nextHeaderRow;
                Field = field;
                ExpectedValue = expectedValue;
            }
            internal int HeaderRow { get; private set; }
            internal int? NextHeaderRow { get; private set; }
            internal string Field { get; private set; }
            internal string ExpectedValue { get; private set; }
        }

        private sealed class Phase1Match
        {
            internal Phase1Match(string loanId, string baseHeader, IList<Phase1Amount> amounts)
            {
                LoanId = loanId;
                BaseHeader = baseHeader;
                Amounts = amounts;
            }
            internal string LoanId { get; private set; }
            internal string BaseHeader { get; private set; }
            internal IList<Phase1Amount> Amounts { get; private set; }
        }

        private sealed class Phase1Amount
        {
            internal Phase1Amount(decimal value, string displayValue)
            {
                Value = value;
                DisplayValue = displayValue;
            }
            internal decimal Value { get; private set; }
            internal string DisplayValue { get; private set; }
        }

        internal sealed class Phase2ResultRow
        {
            internal Phase2ResultRow(string loanId, string exceptionHeader, string exceptionDescription, bool isValid)
            {
                LoanId = loanId;
                ExceptionHeader = exceptionHeader;
                ExceptionDescription = exceptionDescription;
                IsValid = isValid;
            }
            internal string LoanId { get; private set; }
            internal string ExceptionHeader { get; private set; }
            internal string ExceptionDescription { get; private set; }
            internal bool IsValid { get; private set; }
        }

        private sealed class ValidationDataRow
        {
            internal ValidationDataRow(IList<ValidationGradeCell> gradeCells, string modification)
            {
                GradeCells = gradeCells;
                Modification = modification;
            }
            internal IList<ValidationGradeCell> GradeCells { get; private set; }
            internal string Modification { get; private set; }
        }

        private sealed class ValidationGradeCell
        {
            internal ValidationGradeCell(string header, XLCellValue value)
            {
                Header = header;
                Value = value;
            }
            internal string Header { get; private set; }
            internal XLCellValue Value { get; private set; }
        }

        private sealed class SourceData
        {
            private readonly IDictionary<string, int> columns;
            internal IList<SourceRow> Rows { get; private set; }

            private SourceData(IDictionary<string, int> columns, IList<SourceRow> rows)
            {
                this.columns = columns;
                Rows = rows;
            }

            internal static SourceData Read(IXLWorksheet sheet)
            {
                IXLRange used = sheet.RangeUsed();
                if (used == null || used.RowCount() < 1)
                    throw new InvalidOperationException("The Dashboard worksheet is empty.");

                var columns = new Dictionary<string, int>(StringComparer.Ordinal);
                int lastColumn = used.LastColumn().ColumnNumber();
                for (int column = 1; column <= lastColumn; column++)
                {
                    string header = Normalize(sheet.Cell(1, column).GetString());
                    if (header.Length == 0) continue;
                    if (columns.ContainsKey(header))
                        throw new InvalidOperationException("Dashboard Report contains duplicate column '" + sheet.Cell(1, column).GetString().Trim() + "'.");
                    columns.Add(header, column);
                }

                string loanKey = Normalize("Investor Loan ID");
                if (!columns.ContainsKey(loanKey))
                    throw new InvalidOperationException("Dashboard Report is missing required column 'Investor Loan ID'.");

                var rows = new List<SourceRow>();
                var loanIds = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                int lastRow = used.LastRow().RowNumber();
                for (int rowNumber = 2; rowNumber <= lastRow; rowNumber++)
                {
                    string loanId = sheet.Cell(rowNumber, columns[loanKey]).GetString().Trim();
                    if (loanId.Length == 0) continue;
                    if (!loanIds.Add(loanId))
                        throw new InvalidOperationException("Dashboard Report contains duplicate Investor Loan ID '" + loanId + "'.");
                    rows.Add(new SourceRow(sheet, rowNumber, columns));
                }
                return new SourceData(columns, rows);
            }

            internal void Require(string field)
            {
                if (!columns.ContainsKey(Normalize(field)))
                    throw new InvalidOperationException("Dashboard Report is missing required column '" + field + "'.");
            }
        }

        private sealed class SourceRow
        {
            private readonly IXLWorksheet sheet;
            private readonly int rowNumber;
            private readonly IDictionary<string, int> columns;

            internal SourceRow(IXLWorksheet sheet, int rowNumber, IDictionary<string, int> columns)
            {
                this.sheet = sheet;
                this.rowNumber = rowNumber;
                this.columns = columns;
            }

            internal string LoanId
            {
                get { return sheet.Cell(rowNumber, columns[Normalize("Investor Loan ID")]).GetString().Trim(); }
            }

            internal bool TryGetValue(string field, out XLCellValue value)
            {
                int column;
                if (columns.TryGetValue(Normalize(field), out column))
                {
                    value = sheet.Cell(rowNumber, column).Value;
                    return true;
                }
                value = default(XLCellValue);
                return false;
            }

            internal bool EqualsValue(string field, string expected)
            {
                int column;
                return columns.TryGetValue(Normalize(field), out column)
                    && string.Equals(sheet.Cell(rowNumber, column).GetString().Trim(), expected, StringComparison.OrdinalIgnoreCase);
            }

            internal bool IsBlank(string field)
            {
                int column;
                return !columns.TryGetValue(Normalize(field), out column) || sheet.Cell(rowNumber, column).IsEmpty();
            }

            internal bool TryGetDate(string field, out DateTime value)
            {
                int column;
                if (columns.TryGetValue(Normalize(field), out column))
                {
                    IXLCell cell = sheet.Cell(rowNumber, column);
                    if (cell.TryGetValue(out value)) return true;
                    string text = cell.GetString().Trim();
                    string[] formats = { "dd-MM-yyyy", "MM-dd-yyyy", "M/d/yyyy", "MM/dd/yyyy", "yyyy-MM-dd" };
                    return DateTime.TryParseExact(text, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out value)
                        || DateTime.TryParse(text, CultureInfo.InvariantCulture, DateTimeStyles.None, out value);
                }
                value = default(DateTime);
                return false;
            }

            internal bool HasPositiveNumber(string field)
            {
                double value;
                return TryGetNumber(field, out value) && value > 0;
            }

            internal bool HasAmount(string field)
            {
                double value;
                return TryGetNumber(field, out value) && Math.Abs(value) > 0.0000001;
            }

            internal IList<Phase1Amount> GetAmounts(IEnumerable<string> fields)
            {
                var result = new List<Phase1Amount>();
                foreach (string field in fields)
                {
                    decimal value;
                    string displayValue;
                    if (TryGetAmount(field, out value, out displayValue) && value != 0
                        && !result.Any(x => x.Value == value))
                        result.Add(new Phase1Amount(value, displayValue));
                }
                return result;
            }

            private bool TryGetAmount(string field, out decimal value, out string displayValue)
            {
                int column;
                if (columns.TryGetValue(Normalize(field), out column))
                {
                    IXLCell cell = sheet.Cell(rowNumber, column);
                    double numeric;
                    if (cell.TryGetValue(out numeric))
                    {
                        value = Convert.ToDecimal(numeric, CultureInfo.InvariantCulture);
                        displayValue = value.ToString("0.##", CultureInfo.InvariantCulture);
                        return true;
                    }
                    string original = cell.GetString().Trim();
                    bool negative = original.StartsWith("(", StringComparison.Ordinal) && original.EndsWith(")", StringComparison.Ordinal);
                    string text = original.Replace("$", string.Empty).Replace(",", string.Empty).Replace("(", string.Empty).Replace(")", string.Empty).Trim();
                    if (decimal.TryParse(text, NumberStyles.Number, CultureInfo.InvariantCulture, out value))
                    {
                        if (negative) value = -value;
                        displayValue = original.Length == 0 ? value.ToString("0.##", CultureInfo.InvariantCulture) : original;
                        return true;
                    }
                }
                value = 0;
                displayValue = string.Empty;
                return false;
            }

            private bool TryGetNumber(string field, out double value)
            {
                int column;
                if (columns.TryGetValue(Normalize(field), out column))
                {
                    IXLCell cell = sheet.Cell(rowNumber, column);
                    if (cell.TryGetValue(out value)) return true;
                    string text = cell.GetString().Trim();
                    bool negative = text.StartsWith("(", StringComparison.Ordinal) && text.EndsWith(")", StringComparison.Ordinal);
                    text = text.Replace("$", string.Empty).Replace(",", string.Empty).Replace("(", string.Empty).Replace(")", string.Empty).Trim();
                    if (text == "-" || text.Length == 0) { value = 0; return false; }
                    if (double.TryParse(text, NumberStyles.Any, CultureInfo.InvariantCulture, out value))
                    {
                        if (negative) value = -value;
                        return true;
                    }
                }
                value = 0;
                return false;
            }
        }
    }
}
