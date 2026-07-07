using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class AICopilot : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string AskAI(string question)
        {
            if (string.IsNullOrWhiteSpace(question))
            {
                return "Please type what you want to find or do in ERP.";
            }

            if (question.Length > 1000)
            {
                question = question.Substring(0, 1000);
            }

            string normalizedUserQuestion = NormalizeForSearch(question);
            if (normalizedUserQuestion.Contains("report") && ContainsSalaryTerm(normalizedUserQuestion))
            {
                string blockedAnswer = "Salary/payroll reports are not available through ERP Assistant.";
                SaveChatLog(question, blockedAnswer);
                return blockedAnswer;
            }

            List<MenuEntry> allowedMenus = BuildAllowedMenuEntries();
            string answer = TryGenerateReport(question, allowedMenus);

            if (string.IsNullOrWhiteSpace(answer))
            {
                answer = TryAnswerFromMenu(question, allowedMenus);
            }

            if (string.IsNullOrWhiteSpace(answer))
            {
                if (IsNavigationQuestion(question))
                {
                    answer = "I could not find a matching menu or report in your allowed access. Please try the exact page/report name or contact ERP admin if you need access.";
                }
                else
                {
                    answer = AIService.AskCopilot(question, BuildRelevantMenuLines(question, allowedMenus));
                }
            }

            SaveChatLog(question, answer);

            return answer;
        }

        private static List<MenuEntry> BuildAllowedMenuEntries()
        {
            List<MenuEntry> entries = new List<MenuEntry>();

            try
            {
                List<MenuService.MenuItem> menuTree = MenuService.LoadMenu();
                AppendMenuEntries(menuTree, string.Empty, entries);
            }
            catch
            {
                // The assistant can still answer general help if menu lookup fails.
            }

            return entries;
        }

        private static void AppendMenuEntries(IEnumerable<MenuService.MenuItem> menus, string parentPath, List<MenuEntry> entries)
        {
            if (menus == null)
            {
                return;
            }

            foreach (MenuService.MenuItem menu in menus)
            {
                string currentPath = string.IsNullOrWhiteSpace(parentPath)
                    ? menu.MenuName
                    : parentPath + " > " + menu.MenuName;

                if (!string.IsNullOrWhiteSpace(menu.Url) && menu.Url != "#")
                {
                    string url = NormalizeInternalUrl(menu.Url);
                    entries.Add(new MenuEntry
                    {
                        Path = currentPath,
                        Url = url,
                        IsReport = IsReportMenu(menu),
                        SearchText = NormalizeForSearch(currentPath + " " + url)
                    });
                }

                AppendMenuEntries(menu.Children, currentPath, entries);
            }
        }

        private static string TryGenerateReport(string question, List<MenuEntry> allowedMenus)
        {
            string normalizedQuestion = NormalizeForSearch(question);

            if (!IsReportGenerationQuestion(normalizedQuestion))
            {
                return null;
            }

            if (ContainsSalaryTerm(normalizedQuestion))
            {
                return "Salary/payroll reports are not available through ERP Assistant.";
            }

            ReportDefinition report = MatchReportDefinition(normalizedQuestion);

            if (report == null)
            {
                string pageAnswer = TryAnswerFromMenu(question, allowedMenus);
                if (!string.IsNullOrWhiteSpace(pageAnswer))
                {
                    return pageAnswer + "\n\nI can open this report page for you. Auto-generation is configured for Performance, Login Count, and Segment Wise Manpower reports only.";
                }

                return "I can generate approved reports only. Salary reports are blocked. For this report, I could not find an approved generator or matching report page in your access.";
            }

            if (!CanGenerateReportsForCurrentUser())
            {
                return "Report generation is disabled for users below PM level. You can still ask me to find report pages.";
            }

            if (!HasReportPageAccess(report.RequiredUrl, allowedMenus))
            {
                return "You do not have access to generate this report from ERP Assistant. Please contact ERP admin if you need access.";
            }

            ReportDateRange range;
            string dateValidation = ResolveDateRange(question, report.RequiresDate, report.MaxDateRangeDays, out range);
            if (!string.IsNullOrWhiteSpace(dateValidation))
            {
                return dateValidation;
            }

            DataTable dt = BuildReportData(report, range, normalizedQuestion);
            if (dt == null)
            {
                return "I could not generate this report right now.";
            }

            RemoveSensitiveColumns(dt);
            string reportUrl = WriteCsvReport(report.Title, dt, range);

            return BuildReportResponse(report.Title, dt, range, reportUrl);
        }

        private static bool IsReportGenerationQuestion(string normalizedQuestion)
        {
            if (string.IsNullOrWhiteSpace(normalizedQuestion))
            {
                return false;
            }

            bool hasGenerationWord = normalizedQuestion.Contains("generate")
                || normalizedQuestion.Contains("export")
                || normalizedQuestion.Contains("download")
                || normalizedQuestion.Contains("prepare")
                || normalizedQuestion.Contains("provide")
                || normalizedQuestion.Contains("give")
                || normalizedQuestion.Contains("create");

            bool hasSupportedReport = normalizedQuestion.Contains("performance")
                || normalizedQuestion.Contains("productivity")
                || normalizedQuestion.Contains("login")
                || normalizedQuestion.Contains("log in")
                || normalizedQuestion.Contains("segment")
                || normalizedQuestion.Contains("manpower")
                || normalizedQuestion.Contains("headcount")
                || normalizedQuestion.Contains("employees");

            bool navigationOnly = normalizedQuestion.StartsWith("find ")
                || normalizedQuestion.StartsWith("open ")
                || normalizedQuestion.StartsWith("where ")
                || normalizedQuestion.Contains("menu")
                || normalizedQuestion.Contains("page");

            return !navigationOnly && ((hasGenerationWord && normalizedQuestion.Contains("report")) || hasSupportedReport);
        }

        private static ReportDefinition MatchReportDefinition(string normalizedQuestion)
        {
            if (normalizedQuestion.Contains("login") || normalizedQuestion.Contains("log in"))
            {
                return new ReportDefinition
                {
                    Key = "login-count",
                    Title = "Branch Wise Login Count",
                    RequiredUrl = "/Admin/LogInDetails.aspx",
                    RequiresDate = true,
                    MaxDateRangeDays = 31
                };
            }

            if (normalizedQuestion.Contains("segment") || normalizedQuestion.Contains("manpower") ||
                normalizedQuestion.Contains("headcount") || normalizedQuestion.Contains("employees"))
            {
                return new ReportDefinition
                {
                    Key = "segment-manpower",
                    Title = "Segment Wise Employees",
                    RequiredUrl = "/Admin/Segmentwisemanpower.aspx",
                    RequiresDate = false,
                    MaxDateRangeDays = 0
                };
            }

            if (normalizedQuestion.Contains("performance") || normalizedQuestion.Contains("productivity") ||
                normalizedQuestion.Contains("quality"))
            {
                return new ReportDefinition
                {
                    Key = "performance",
                    Title = "Performance Report",
                    RequiredUrl = "/Admin/UserPerformanceReport.aspx",
                    RequiresDate = true,
                    MaxDateRangeDays = 92
                };
            }

            return null;
        }

        private static DataTable BuildReportData(ReportDefinition report, ReportDateRange range, string normalizedQuestion)
        {
            int employeeId = GetCurrentEmployeeId();
            bllMaster master = new bllMaster();

            if (report.Key == "performance")
            {
                return master.GetUserPerformanceReport(FormatReportDate(range.FromDate), FormatReportDate(range.ToDate), employeeId);
            }

            if (report.Key == "segment-manpower")
            {
                return master.GetSegmentwiseManpowerList();
            }

            if (report.Key == "login-count")
            {
                bool wantsCount = normalizedQuestion.Contains("count") ||
                    normalizedQuestion.Contains("branch") ||
                    normalizedQuestion.Contains("date wise") ||
                    normalizedQuestion.Contains("datewise");

                return BuildLoginReport(master, employeeId, range, wantsCount);
            }

            return null;
        }

        private static DataTable BuildLoginReport(bllMaster master, int employeeId, ReportDateRange range, bool aggregateCount)
        {
            string pmCode = master.GetCodeFromEmployeeId(employeeId);
            DataTable combined = null;

            for (DateTime current = range.FromDate.Date; current <= range.ToDate.Date; current = current.AddDays(1))
            {
                DataTable dt = master.ShowAllLogDetails(pmCode, FormatReportDate(current));
                if (dt == null)
                {
                    continue;
                }

                if (!dt.Columns.Contains("ReportDate"))
                {
                    dt.Columns.Add("ReportDate", typeof(string));
                }

                foreach (DataRow row in dt.Rows)
                {
                    row["ReportDate"] = FormatReportDate(current);
                }

                if (combined == null)
                {
                    combined = dt.Clone();
                }

                foreach (DataRow row in dt.Rows)
                {
                    combined.ImportRow(row);
                }
            }

            if (combined == null)
            {
                combined = new DataTable();
            }

            if (!aggregateCount)
            {
                return combined;
            }

            return BuildLoginCountTable(combined);
        }

        private static DataTable BuildLoginCountTable(DataTable source)
        {
            DataTable result = new DataTable();
            result.Columns.Add("ReportDate");
            result.Columns.Add("Branch");
            result.Columns.Add("LoginCount", typeof(int));

            if (source == null || source.Rows.Count == 0)
            {
                return result;
            }

            string branchColumn = FindColumn(source, "branch", "location", "workingbranch");
            Dictionary<string, int> counts = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);

            foreach (DataRow row in source.Rows)
            {
                string reportDate = GetCellValue(row, "ReportDate");
                string branch = string.IsNullOrWhiteSpace(branchColumn) ? "All" : GetCellValue(row, branchColumn);

                if (string.IsNullOrWhiteSpace(branch))
                {
                    branch = "Not Available";
                }

                string key = reportDate + "||" + branch;
                counts[key] = counts.ContainsKey(key) ? counts[key] + 1 : 1;
            }

            foreach (KeyValuePair<string, int> item in counts.OrderBy(x => x.Key))
            {
                string[] parts = item.Key.Split(new[] { "||" }, StringSplitOptions.None);
                DataRow row = result.NewRow();
                row["ReportDate"] = parts.Length > 0 ? parts[0] : string.Empty;
                row["Branch"] = parts.Length > 1 ? parts[1] : string.Empty;
                row["LoginCount"] = item.Value;
                result.Rows.Add(row);
            }

            return result;
        }

        private static string ResolveDateRange(string question, bool required, int maxDays, out ReportDateRange range)
        {
            range = new ReportDateRange();
            DateTime today = DateTime.Today;
            string normalized = NormalizeForSearch(question);

            if (normalized.Contains("today"))
            {
                range.FromDate = today;
                range.ToDate = today;
                return null;
            }

            if (normalized.Contains("yesterday"))
            {
                range.FromDate = today.AddDays(-1);
                range.ToDate = today.AddDays(-1);
                return null;
            }

            if (normalized.Contains("this month") || normalized.Contains("current month"))
            {
                range.FromDate = new DateTime(today.Year, today.Month, 1);
                range.ToDate = today;
                return null;
            }

            if (normalized.Contains("last month") || normalized.Contains("previous month"))
            {
                DateTime firstThisMonth = new DateTime(today.Year, today.Month, 1);
                range.FromDate = firstThisMonth.AddMonths(-1);
                range.ToDate = firstThisMonth.AddDays(-1);
                return null;
            }

            List<DateTime> dates = ExtractDates(question);
            if (dates.Count >= 2)
            {
                range.FromDate = dates[0].Date <= dates[1].Date ? dates[0].Date : dates[1].Date;
                range.ToDate = dates[0].Date <= dates[1].Date ? dates[1].Date : dates[0].Date;
            }
            else if (dates.Count == 1)
            {
                range.FromDate = dates[0].Date;
                range.ToDate = dates[0].Date;
            }
            else if (TryExtractMonth(question, out range))
            {
                // Month range was assigned.
            }
            else if (required)
            {
                return "Please mention the report period. Example: generate performance report from 01-Jul-2026 to 04-Jul-2026.";
            }
            else
            {
                range.FromDate = today;
                range.ToDate = today;
            }

            if (range.FromDate > range.ToDate)
            {
                DateTime temp = range.FromDate;
                range.FromDate = range.ToDate;
                range.ToDate = temp;
            }

            if (maxDays > 0 && (range.ToDate - range.FromDate).TotalDays + 1 > maxDays)
            {
                return "Please use a date range of " + maxDays + " days or less for this report.";
            }

            return null;
        }

        private static List<DateTime> ExtractDates(string text)
        {
            List<DateTime> dates = new List<DateTime>();
            string[] formats = new[]
            {
                "dd-MMM-yyyy", "d-MMM-yyyy", "dd-MMMM-yyyy", "d-MMMM-yyyy",
                "dd/MM/yyyy", "d/M/yyyy", "MM/dd/yyyy", "M/d/yyyy",
                "dd-MM-yyyy", "d-M-yyyy", "yyyy-MM-dd"
            };

            foreach (Match match in Regex.Matches(text, @"\b(\d{1,2}[-/ ](?:[A-Za-z]{3,9}|\d{1,2})[-/ ]\d{2,4}|\d{4}-\d{1,2}-\d{1,2})\b"))
            {
                string value = match.Value.Replace(" ", "-");
                DateTime parsed;

                if (DateTime.TryParseExact(value, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed) ||
                    DateTime.TryParse(value, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed))
                {
                    dates.Add(parsed);
                }
            }

            return dates;
        }

        private static bool TryExtractMonth(string text, out ReportDateRange range)
        {
            range = new ReportDateRange();
            Match match = Regex.Match(text, @"\b(jan|january|feb|february|mar|march|apr|april|may|jun|june|jul|july|aug|august|sep|sept|september|oct|october|nov|november|dec|december)(?:\s+(\d{4}))?\b", RegexOptions.IgnoreCase);

            if (!match.Success)
            {
                return false;
            }

            int month = MonthNumber(match.Groups[1].Value);
            int year = match.Groups[2].Success ? Convert.ToInt32(match.Groups[2].Value) : DateTime.Today.Year;

            range.FromDate = new DateTime(year, month, 1);
            range.ToDate = range.FromDate.AddMonths(1).AddDays(-1);
            return true;
        }

        private static int MonthNumber(string monthName)
        {
            string value = monthName.ToLowerInvariant();
            string[] months = { "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec" };

            for (int i = 0; i < months.Length; i++)
            {
                if (value.StartsWith(months[i], StringComparison.OrdinalIgnoreCase))
                {
                    return i + 1;
                }
            }

            return DateTime.Today.Month;
        }

        private static string WriteCsvReport(string title, DataTable dt, ReportDateRange range)
        {
            string folder = HttpContext.Current.Server.MapPath("~/ReportDocument");
            Directory.CreateDirectory(folder);

            string fileName = "AI_" + Regex.Replace(title, @"[^A-Za-z0-9]+", "_").Trim('_') + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".csv";
            string filePath = Path.Combine(folder, fileName);

            using (StreamWriter writer = new StreamWriter(filePath, false, new UTF8Encoding(true)))
            {
                writer.WriteLine(string.Join(",", dt.Columns.Cast<DataColumn>().Select(col => CsvEscape(col.ColumnName))));

                foreach (DataRow row in dt.Rows)
                {
                    writer.WriteLine(string.Join(",", dt.Columns.Cast<DataColumn>().Select(col => CsvEscape(Convert.ToString(row[col])))));
                }
            }

            return "/ReportDocument/" + fileName;
        }

        private static string BuildReportResponse(string title, DataTable dt, ReportDateRange range, string reportUrl)
        {
            StringBuilder answer = new StringBuilder();
            answer.AppendLine("Generated " + title + ".");

            if (range.HasValue)
            {
                answer.AppendLine("Period: " + FormatReportDate(range.FromDate) + " to " + FormatReportDate(range.ToDate));
            }

            answer.AppendLine("Rows: " + dt.Rows.Count);
            answer.AppendLine("Download: " + reportUrl);

            string preview = BuildPreview(dt);
            if (!string.IsNullOrWhiteSpace(preview))
            {
                answer.AppendLine();
                answer.AppendLine("Preview:");
                answer.Append(preview);
            }

            return answer.ToString();
        }

        private static string BuildPreview(DataTable dt)
        {
            if (dt == null || dt.Rows.Count == 0 || dt.Columns.Count == 0)
            {
                return string.Empty;
            }

            int columnCount = Math.Min(dt.Columns.Count, 6);
            int rowCount = Math.Min(dt.Rows.Count, 5);
            StringBuilder preview = new StringBuilder();

            preview.AppendLine(string.Join(" | ", dt.Columns.Cast<DataColumn>().Take(columnCount).Select(col => col.ColumnName)));

            for (int i = 0; i < rowCount; i++)
            {
                List<string> values = new List<string>();
                for (int j = 0; j < columnCount; j++)
                {
                    values.Add(Convert.ToString(dt.Rows[i][j]));
                }
                preview.AppendLine(string.Join(" | ", values));
            }

            return preview.ToString();
        }

        private static void RemoveSensitiveColumns(DataTable dt)
        {
            if (dt == null)
            {
                return;
            }

            for (int i = dt.Columns.Count - 1; i >= 0; i--)
            {
                string columnName = NormalizeForSearch(dt.Columns[i].ColumnName);
                if (ContainsSalaryTerm(columnName))
                {
                    dt.Columns.RemoveAt(i);
                }
            }
        }

        private static bool ContainsSalaryTerm(string normalizedText)
        {
            return normalizedText.Contains("salary")
                || normalizedText.Contains("payroll")
                || normalizedText.Contains("ctc")
                || normalizedText.Contains("compensation")
                || normalizedText.Contains("wage");
        }

        private static bool HasReportPageAccess(string reportUrl, List<MenuEntry> allowedMenus)
        {
            if (IsCurrentUserAdmin())
            {
                return true;
            }

            if (allowedMenus == null)
            {
                return false;
            }

            string normalizedReportUrl = NormalizeInternalUrl(reportUrl).ToLowerInvariant();
            return allowedMenus.Any(menu => string.Equals((menu.Url ?? string.Empty).ToLowerInvariant(), normalizedReportUrl, StringComparison.OrdinalIgnoreCase));
        }

        private static bool CanGenerateReportsForCurrentUser()
        {
            if (IsCurrentUserAdmin())
            {
                return true;
            }

            int employeeId = GetCurrentEmployeeId();
            if (employeeId > 0 && new bllMaster().CheckIfPM(employeeId) == 1)
            {
                return true;
            }

            return LoadReportSettings().AllowReportGenerationBelowPM;
        }

        private static int GetCurrentEmployeeId()
        {
            int employeeId = 0;

            if (HttpContext.Current.User != null &&
                HttpContext.Current.User.Identity != null &&
                !string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name))
            {
                int.TryParse(HttpContext.Current.User.Identity.Name, out employeeId);
            }

            return employeeId;
        }

        private static bool IsCurrentUserAdmin()
        {
            return HttpContext.Current.User != null && HttpContext.Current.User.IsInRole("Admin");
        }

        private static string FindColumn(DataTable table, params string[] containsTokens)
        {
            if (table == null)
            {
                return null;
            }

            foreach (DataColumn column in table.Columns)
            {
                string normalizedColumn = NormalizeForSearch(column.ColumnName);
                if (containsTokens.Any(token => normalizedColumn.Contains(NormalizeForSearch(token))))
                {
                    return column.ColumnName;
                }
            }

            return null;
        }

        private static string GetCellValue(DataRow row, string columnName)
        {
            if (row == null || string.IsNullOrWhiteSpace(columnName) || !row.Table.Columns.Contains(columnName))
            {
                return string.Empty;
            }

            return Convert.ToString(row[columnName]);
        }

        private static string FormatReportDate(DateTime date)
        {
            return date.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
        }

        private static string CsvEscape(string value)
        {
            value = value ?? string.Empty;
            bool mustQuote = value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r");
            value = value.Replace("\"", "\"\"");
            return mustQuote ? "\"" + value + "\"" : value;
        }

        private static string TryAnswerFromMenu(string question, List<MenuEntry> allowedMenus)
        {
            if (allowedMenus == null || allowedMenus.Count == 0)
            {
                return null;
            }

            string normalizedQuestion = NormalizeForSearch(question);
            List<string> tokens = Tokenize(question);
            bool wantsReport = normalizedQuestion.Contains("report");

            var matches = allowedMenus
                .Select(menu => new
                {
                    Menu = menu,
                    Score = ScoreMenu(menu, normalizedQuestion, tokens, wantsReport)
                })
                .Where(x => x.Score > 0)
                .OrderByDescending(x => x.Score)
                .ThenBy(x => x.Menu.Path.Length)
                .Take(5)
                .ToList();

            if (matches.Count == 0 || matches[0].Score < 10)
            {
                return null;
            }

            if (matches.Count == 1 || matches[0].Score >= matches[1].Score + 12)
            {
                return "I found this page for you:\n" + matches[0].Menu.Path + "\n" + matches[0].Menu.Url;
            }

            StringBuilder answer = new StringBuilder();
            answer.AppendLine("I found these matching pages:");

            foreach (var match in matches.Take(3))
            {
                answer.AppendLine("- " + match.Menu.Path + " : " + match.Menu.Url);
            }

            return answer.ToString();
        }

        private static int ScoreMenu(MenuEntry menu, string normalizedQuestion, List<string> tokens, bool wantsReport)
        {
            int score = 0;

            if (string.IsNullOrWhiteSpace(menu.SearchText))
            {
                return 0;
            }

            if (menu.SearchText.Contains(normalizedQuestion))
            {
                score += 40;
            }

            if (normalizedQuestion.Contains(menu.SearchText))
            {
                score += 25;
            }

            foreach (string token in tokens)
            {
                if (menu.SearchText.Contains(token))
                {
                    score += token.Length >= 6 ? 9 : 6;
                }
            }

            if (tokens.Count > 0 && tokens.All(token => menu.SearchText.Contains(token)))
            {
                score += 18;
            }

            if (wantsReport && menu.IsReport)
            {
                score += 10;
            }

            return score;
        }

        private static List<string> BuildRelevantMenuLines(string question, List<MenuEntry> allowedMenus)
        {
            if (allowedMenus == null || allowedMenus.Count == 0)
            {
                return new List<string>();
            }

            string normalizedQuestion = NormalizeForSearch(question);
            List<string> tokens = Tokenize(question);
            bool wantsReport = normalizedQuestion.Contains("report");

            return allowedMenus
                .Select(menu => new
                {
                    Menu = menu,
                    Score = ScoreMenu(menu, normalizedQuestion, tokens, wantsReport)
                })
                .OrderByDescending(x => x.Score)
                .ThenBy(x => x.Menu.Path.Length)
                .Take(25)
                .Select(x => "- " + x.Menu.Path + (x.Menu.IsReport ? " [Report]" : string.Empty) + " | " + x.Menu.Url)
                .ToList();
        }

        private static bool IsNavigationQuestion(string question)
        {
            string normalizedQuestion = NormalizeForSearch(question);

            return normalizedQuestion.Contains("find")
                || normalizedQuestion.Contains("open")
                || normalizedQuestion.Contains("show")
                || normalizedQuestion.Contains("go to")
                || normalizedQuestion.Contains("where")
                || normalizedQuestion.Contains("menu")
                || normalizedQuestion.Contains("page")
                || normalizedQuestion.Contains("report");
        }

        private static List<string> Tokenize(string text)
        {
            string normalizedText = NormalizeForSearch(text);
            HashSet<string> stopWords = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "find", "open", "show", "please", "menu", "page", "where", "how", "to",
                "the", "for", "and", "with", "give", "get", "me", "my", "go", "into"
            };

            return normalizedText
                .Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)
                .Where(token => token.Length > 1 && !stopWords.Contains(token))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();
        }

        private static string NormalizeForSearch(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
            {
                return string.Empty;
            }

            string normalized = Regex.Replace(text.ToLowerInvariant(), @"[^a-z0-9]+", " ");
            return Regex.Replace(normalized, @"\s+", " ").Trim();
        }

        private static bool IsReportMenu(MenuService.MenuItem menu)
        {
            string text = ((menu.MenuName ?? string.Empty) + " " + (menu.Url ?? string.Empty)).ToLowerInvariant();
            return text.Contains("report");
        }

        private static string NormalizeInternalUrl(string url)
        {
            if (string.IsNullOrWhiteSpace(url))
            {
                return string.Empty;
            }

            url = url.Trim();

            if (url.StartsWith("http://", StringComparison.OrdinalIgnoreCase) ||
                url.StartsWith("https://", StringComparison.OrdinalIgnoreCase) ||
                url.StartsWith("/", StringComparison.Ordinal))
            {
                return url;
            }

            if (url.StartsWith("~/", StringComparison.Ordinal))
            {
                return "/" + url.Substring(2);
            }

            while (url.StartsWith("../", StringComparison.Ordinal))
            {
                url = url.Substring(3);
            }

            if (url.IndexOf("/", StringComparison.Ordinal) >= 0)
            {
                return "/" + url;
            }

            return "/Admin/" + url;
        }

        [WebMethod]
        public static ReportSettingsDto GetReportSettings()
        {
            AIAssistantSettings settings = LoadReportSettings();
            int employeeId = GetCurrentEmployeeId();
            bool isPm = employeeId > 0 && new bllMaster().CheckIfPM(employeeId) == 1;

            return new ReportSettingsDto
            {
                AllowReportGenerationBelowPM = settings.AllowReportGenerationBelowPM,
                CanManageReports = IsCurrentUserAdmin(),
                CurrentUserIsPM = isPm,
                CurrentUserCanGenerateReports = IsCurrentUserAdmin() || isPm || settings.AllowReportGenerationBelowPM
            };
        }

        [WebMethod]
        public static ReportSettingsDto SaveReportSettings(bool allowReportGenerationBelowPM)
        {
            if (!IsCurrentUserAdmin())
            {
                throw new UnauthorizedAccessException("Only admin users can change AI report settings.");
            }

            AIAssistantSettings settings = LoadReportSettings();
            settings.AllowReportGenerationBelowPM = allowReportGenerationBelowPM;
            SaveReportSettingsFile(settings);

            return GetReportSettings();
        }

        private static AIAssistantSettings LoadReportSettings()
        {
            AIAssistantSettings settings = new AIAssistantSettings
            {
                AllowReportGenerationBelowPM = true
            };

            try
            {
                string path = GetReportSettingsPath();
                if (File.Exists(path))
                {
                    AIAssistantSettings saved = new JavaScriptSerializer().Deserialize<AIAssistantSettings>(File.ReadAllText(path));
                    if (saved != null)
                    {
                        settings = saved;
                    }
                }
            }
            catch
            {
                // Use default settings when the file is not readable.
            }

            return settings;
        }

        private static void SaveReportSettingsFile(AIAssistantSettings settings)
        {
            string path = GetReportSettingsPath();
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            File.WriteAllText(path, new JavaScriptSerializer().Serialize(settings));
        }

        private static string GetReportSettingsPath()
        {
            return HttpContext.Current.Server.MapPath("~/App_Data/AIAssistantSettings.json");
        }

        public class ReportSettingsDto
        {
            public bool AllowReportGenerationBelowPM { get; set; }
            public bool CanManageReports { get; set; }
            public bool CurrentUserIsPM { get; set; }
            public bool CurrentUserCanGenerateReports { get; set; }
        }

        private class AIAssistantSettings
        {
            public bool AllowReportGenerationBelowPM { get; set; }
        }

        private class ReportDefinition
        {
            public string Key { get; set; }
            public string Title { get; set; }
            public string RequiredUrl { get; set; }
            public bool RequiresDate { get; set; }
            public int MaxDateRangeDays { get; set; }
        }

        private class ReportDateRange
        {
            public DateTime FromDate { get; set; }
            public DateTime ToDate { get; set; }

            public bool HasValue
            {
                get { return FromDate != DateTime.MinValue && ToDate != DateTime.MinValue; }
            }
        }

        private class MenuEntry
        {
            public string Path { get; set; }
            public string Url { get; set; }
            public bool IsReport { get; set; }
            public string SearchText { get; set; }
        }

        private static void SaveChatLog(string question, string answer)
        {
            try
            {
                int employeeId = 0;

                if (HttpContext.Current.User != null &&
                    HttpContext.Current.User.Identity != null &&
                    !string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name))
                {
                    int.TryParse(HttpContext.Current.User.Identity.Name, out employeeId);
                }

                string conStr = SQLHelper.ConnectionString;

                using (SqlConnection con = new SqlConnection(conStr))
                using (SqlCommand cmd = new SqlCommand("INSERT INTO AIChatLog(EmployeeID, Question, Answer, ModuleName) VALUES(@EmployeeID, @Question, @Answer, @ModuleName)", con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeID", employeeId);
                    cmd.Parameters.AddWithValue("@Question", question);
                    cmd.Parameters.AddWithValue("@Answer", answer);
                    cmd.Parameters.AddWithValue("@ModuleName", "ERP Copilot");

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                // Do not stop AI response if log fails
            }
        }
    }
}
