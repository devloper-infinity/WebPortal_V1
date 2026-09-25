using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.Services;
using WebPortal.App_Code;

namespace WebPortal.Admin
{
    public partial class RNRReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            RnrSecurity.RequireHr();
            if (Request.QueryString["export"] == "1") Export();
        }

        private static List<Dictionary<string, object>> Rows(DataTable table)
        {
            return table.Rows.Cast<DataRow>().Select(row => table.Columns.Cast<DataColumn>()
                .ToDictionary(column => column.ColumnName, column => row[column] == DBNull.Value ? null : row[column])).ToList();
        }

        private static DateTime? Date(string value)
        {
            DateTime date;
            return DateTime.TryParse(value, out date) ? date : (DateTime?)null;
        }

        [WebMethod]
        public static object Lookups()
        {
            RnrSecurity.RequireHr();
            var repository = new RnrFeedbackRepository();
            var data = repository.GetAdminData();
            return new
            {
                Questionnaires = Rows(data.Tables[0]), Domains = Rows(data.Tables[1]),
                Locations = Rows(data.Tables[2]), Departments = Rows(data.Tables[3]), Years = Rows(repository.ReportYears())
            };
        }

        [WebMethod]
        public static object Report(int questionnaire, string domain, int location, int department, int employee, string status, int year, int quarter, string from, string to)
        {
            RnrSecurity.RequireHr();
            var data = new RnrFeedbackRepository().Report(questionnaire, domain, location, department, employee, status, year, quarter, Date(from), Date(to));
            return new { Rows = Rows(data.Tables[0]), Counts = Rows(data.Tables[1]).FirstOrDefault() };
        }

        [WebMethod]
        public static object Details(int questionnaire, string domain, int location, int department, int employee, string status, int year, int quarter, string from, string to)
        {
            RnrSecurity.RequireHr();
            var repository = new RnrFeedbackRepository();
            var report = repository.Report(questionnaire, domain, location, department, employee, status, year, quarter, Date(from), Date(to));
            var answers = repository.ReportAnswers(questionnaire, domain, location, department, employee, status, year, quarter, Date(from), Date(to));
            return new { Employees = Rows(report.Tables[0]), Answers = Rows(answers) };
        }

        [WebMethod]
        public static object Answers(long assignmentId)
        {
            RnrSecurity.RequireHr();
            return Rows(new RnrFeedbackRepository().Answers(assignmentId));
        }

        private void Export()
        {
            int questionnaire = Int(Request["questionnaire"]), location = Int(Request["location"]), department = Int(Request["department"]);
            int employee = Int(Request["employee"]), year = Int(Request["year"]), quarter = Int(Request["quarter"]);
            string domain = Request["domain"], status = Request["status"];
            DateTime? from = Date(Request["from"]), to = Date(Request["to"]);
            var repository = new RnrFeedbackRepository();
            var report = repository.Report(questionnaire, domain, location, department, employee, status, year, quarter, from, to);

            using (var workbook = new XLWorkbook())
            {
                if (String.Equals(Request["view"], "details", StringComparison.OrdinalIgnoreCase))
                {
                    var answers = repository.ReportAnswers(questionnaire, domain, location, department, employee, status, year, quarter, from, to);
                    BuildDetailsWorkbook(workbook, report.Tables[0], answers);
                }
                else
                {
                    var sheet = workbook.Worksheets.Add(report.Tables[0], "Summary");
                    sheet.Row(1).Style.Font.Bold = true;
                    sheet.Row(1).Style.Fill.BackgroundColor = XLColor.FromHtml("#173B7A");
                    sheet.Row(1).Style.Font.FontColor = XLColor.White;
                    sheet.Columns().AdjustToContents(8, 45);
                }
                SendWorkbook(workbook);
            }
        }

        private static void BuildDetailsWorkbook(XLWorkbook workbook, DataTable employees, DataTable answers)
        {
            var usedNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (var departmentGroup in employees.AsEnumerable().GroupBy(row => Convert.ToString(row["Department"])))
            {
                var sheet = workbook.Worksheets.Add(UniqueSheetName(departmentGroup.Key, usedNames));
                sheet.ShowGridLines = false;
                int outputRow = 1;
                foreach (DataRow employee in departmentGroup)
                {
                    long assignmentId = Convert.ToInt64(employee["AssignmentID"]);
                    var employeeAnswers = answers.AsEnumerable().Where(row => Convert.ToInt64(row["AssignmentID"]) == assignmentId)
                        .OrderBy(row => Convert.ToInt32(row["SortOrder"])).ToList();
                    var title = sheet.Range(outputRow, 1, outputRow, 2);
                    title.Merge();
                    title.Value = Convert.ToString(employee["EmployeeID"]) + " : " + Convert.ToString(employee["EmployeeName"]);
                    title.Style.Font.Bold = true;
                    title.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    title.Style.Fill.BackgroundColor = XLColor.FromHtml("#D9E8FB");
                    title.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    sheet.Cell(outputRow, 3).Value = Convert.ToString(employee["Status"]);
                    sheet.Cell(outputRow, 3).Style.Font.Bold = true;
                    sheet.Cell(outputRow, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                    sheet.Cell(outputRow, 3).Style.Fill.BackgroundColor = Convert.ToString(employee["Status"]) == "Completed" ? XLColor.FromHtml("#DFF4E5") : XLColor.FromHtml("#FFF2CC");
                    sheet.Cell(outputRow, 3).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    outputRow++;
                    var metadata = sheet.Range(outputRow, 1, outputRow, 3);
                    metadata.Merge();
                    metadata.Value = Convert.ToString(employee["Questionnaire"]) + " | " + Convert.ToString(employee["SurveyYear"]) + " | " + Convert.ToString(employee["Quarter"]) + " | " + Convert.ToString(employee["DomainName"]) + " | " + Convert.ToString(employee["Location"]);
                    metadata.Style.Font.FontColor = XLColor.FromHtml("#617080");
                    metadata.Style.Fill.BackgroundColor = XLColor.FromHtml("#EAF3FF");
                    metadata.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    outputRow++;
                    sheet.Cell(outputRow, 1).Value = "Sr. #";
                    sheet.Cell(outputRow, 2).Value = "Question";
                    sheet.Cell(outputRow, 3).Value = "Answer";
                    var header = sheet.Range(outputRow, 1, outputRow, 3);
                    header.Style.Font.Bold = true;
                    header.Style.Fill.BackgroundColor = XLColor.FromHtml("#173B7A");
                    header.Style.Font.FontColor = XLColor.White;
                    header.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                    header.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    outputRow++;
                    if (employeeAnswers.Count == 0)
                    {
                        sheet.Cell(outputRow, 1).Value = 1;
                        sheet.Cell(outputRow, 2).Value = "Submission status";
                        sheet.Cell(outputRow, 3).Value = Convert.ToString(employee["Status"]);
                        ApplyDetailRowStyle(sheet, outputRow++);
                    }
                    else foreach (DataRow answer in employeeAnswers)
                    {
                        sheet.Cell(outputRow, 1).Value = Convert.ToInt32(answer["SortOrder"]);
                        sheet.Cell(outputRow, 2).Value = Convert.ToString(answer["QuestionText"]);
                        sheet.Cell(outputRow, 3).Value = CleanAnswer(answer["Answer"]);
                        ApplyDetailRowStyle(sheet, outputRow++);
                    }
                    outputRow++;
                }
                sheet.Column(1).Width = 8;
                sheet.Column(2).Width = 55;
                sheet.Column(3).Width = 45;
                sheet.Columns(2, 3).Style.Alignment.WrapText = true;
            }
            if (!workbook.Worksheets.Any()) workbook.Worksheets.Add("Details").Cell("A1").Value = "No records found for the selected filters.";
        }

        private static void ApplyDetailRowStyle(IXLWorksheet sheet, int row)
        {
            var range = sheet.Range(row, 1, row, 3);
            range.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            range.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            range.Style.Alignment.Vertical = XLAlignmentVerticalValues.Top;
        }

        private static string CleanAnswer(object value)
        {
            string answer = Convert.ToString(value).Trim();
            return answer == "—" || answer.StartsWith("â€”", StringComparison.Ordinal) ? String.Empty : answer;
        }

        private static string UniqueSheetName(string value, HashSet<string> used)
        {
            string name = String.IsNullOrWhiteSpace(value) ? "Unassigned" : value;
            foreach (char character in "[]:*?/\\") name = name.Replace(character.ToString(), "");
            if (name.Length > 31) name = name.Substring(0, 31);
            string baseName = String.IsNullOrWhiteSpace(name) ? "Department" : name;
            int suffix = 2;
            while (used.Contains(name))
            {
                string addition = " " + suffix++;
                name = baseName.Substring(0, Math.Min(baseName.Length, 31 - addition.Length)) + addition;
            }
            used.Add(name);
            return name;
        }

        private void SendWorkbook(XLWorkbook workbook)
        {
            using (var stream = new MemoryStream())
            {
                workbook.SaveAs(stream);
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition", "attachment; filename=RNR-Feedback-Report.xlsx");
                Response.BinaryWrite(stream.ToArray());
                Response.End();
            }
        }

        private static int Int(string value)
        {
            int number;
            return Int32.TryParse(value, out number) ? number : 0;
        }
    }
}
