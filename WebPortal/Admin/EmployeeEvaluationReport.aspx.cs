using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;
using ClosedXML.Excel;

namespace WebPortal.Admin
{
    public partial class EmployeeEvaluationReport : System.Web.UI.Page
    {
        private bool exportCompleted;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["exportAll"] == "1")
            {
                ExportAllDetails();
            }
        }

        [WebMethod]
        public static string GetEvaluationData()
        {
            try
            {
                DataTable table = LoadEvaluationTable();
                return Serialize(new { Rows = ToEvaluationRows(table), Errors = new List<string>() });
            }
            catch (Exception ex)
            {
                return Serialize(new
                {
                    Rows = new List<Dictionary<string, object>>(),
                    Errors = new[] { "Employee evaluation grid: " + ex.Message }
                });
            }
        }

        private static List<Dictionary<string, object>> ToEvaluationRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow source in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                row["DPType"] = FirstColumnValue(source, new[] { "DPType", "DailyTaskProductivity", "ProductiveTask" });
                row["D_Name"] = FirstColumnValue(source, new[] { "D_Name", "DomainName", "Domain" });
                row["BranchName"] = FirstColumnValue(source, new[] { "BranchName", "Branch" });
                row["Code"] = FirstColumnValue(source, new[] { "Code" });
                row["Name"] = FirstColumnValue(source, new[] { "Name", "FullName" });
                row["JoiningDate"] = FirstColumnValue(source, new[] { "JoiningDate" });
                row["ReportingManager"] = FirstColumnValue(source, new[] { "ReportingManager" });
                row["TenureSinceLastInc"] = FirstColumnValue(source, new[] { "TenureSinceLastInc", "TenureSinceLastIncrement" });
                row["ProductionPerc"] = FirstColumnValue(source, new[] { "ProductionPerc", "ProductionPercentage" });
                row["CalculatedProductionGrade"] = FirstColumnValue(source, new[] { "CalculatedProductionGrade" });
                row["CalculatedQcPercentage"] = FirstColumnValue(source, new[] { "CalculatedQcPercentage" });
                row["CalculatedQualityGrade"] = FirstColumnValue(source, new[] { "CalculatedQualityGrade" });
                row["OnWorkingDays"] = FirstColumnValue(source, new[] { "OnWorkingDays", "AttendancePerc", "AttendancePercentage" });
                row["CalculatedAttendanceGrade"] = FirstColumnValue(source, new[] { "CalculatedAttendanceGrade" });
                row["CalculatedIncrementPercentage"] = FirstColumnValue(source, new[] { "CalculatedIncrementPercentage" });
                string[] directFields = { "IncrementPercentageByPM", "TotalAppreciations", "TotalError", "Incentive", "Salary", "IncPerc", "IncrementAmount", "SalaryAfterIncrement", "GrandTotal", "IncMonth", "Month", "Year", "ErrorPerLoan", "CriticalPerLoan", "NonCriticalPerLoan", "LoanCount", "CriticalErrorCount", "NonCriticalErrorCount" };
                foreach (string field in directFields) row[field] = FirstColumnValue(source, new[] { field });
                rows.Add(row);
            }
            return rows;
        }

        private static DataTable LoadEvaluationTable()
        {
            int userId = CurrentUserId();
            bllSalary salary = new bllSalary();
            DataTable table = salary.GetIncrementProposalSelected(userId, true);
            if (userId == 12 || userId == 7036 || userId == 5902)
            {
                AppendMissingPendingEmployees(table, salary);
            }
            HydrateEmployeeDetails(table);
            RemoveDuplicateProposalRows(table);
            AddEvaluationCounts(table);
            return table;
        }

        private static void RemoveDuplicateProposalRows(DataTable table)
        {
            if (table == null) return;
            string keyColumn = table.Columns.Contains("ProposalUwID") ? "ProposalUwID" :
                (table.Columns.Contains("CodeCounter") ? "CodeCounter" : "");
            if (string.IsNullOrEmpty(keyColumn)) return;

            HashSet<string> keys = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            List<DataRow> duplicates = new List<DataRow>();
            foreach (DataRow row in table.Rows)
            {
                string key = Convert.ToString(row[keyColumn]).Trim();
                if (!string.IsNullOrEmpty(key) && !keys.Add(key)) duplicates.Add(row);
            }
            foreach (DataRow duplicate in duplicates) table.Rows.Remove(duplicate);
        }

        private void ExportAllDetails()
        {
            DataTable evaluation = LoadEvaluationTable();
            DataSet details = GetAllUserWiseExportData();

            using (XLWorkbook workbook = new XLWorkbook())
            {
                IXLWorksheet summary = workbook.Worksheets.Add("Evaluation");
                string[] headers = { "Sr. #", "Productive Task", "Domain", "Branch", "Code", "Name", "Joining Date", "Reporting Manager", "Tenure Since Last Increment", "Production %", "Production Grade", "Qcer %", "Qcer Grade", "Attendance %", "Attendance Grade", "IncrementPercentageByPM", "Appreciation", "Disciplinary", "Incentive", "Salary", "Increment Percentage", "Increment Amount", "Salary After Increment", "Month", "Year", "Error Per Loan", "Critical Per Loan", "Non-Critical Per Loan", "LoanCount", "Critical Error Count", "Non Critical Error Count" };
                string[][] fields = {
                    new[]{""}, new[]{"DPType","DailyTaskProductivity","ProductiveTask"}, new[]{"D_Name","DomainName","Domain"}, new[]{"BranchName","Branch"}, new[]{"Code"}, new[]{"Name","FullName"}, new[]{"JoiningDate"}, new[]{"ReportingManager"}, new[]{"TenureSinceLastInc","TenureSinceLastIncrement"}, new[]{"ProductionPerc","ProductionPercentage"}, new[]{"CalculatedProductionGrade"}, new[]{"CalculatedQcPercentage"}, new[]{"CalculatedQualityGrade"}, new[]{"OnWorkingDays","AttendancePerc","AttendancePercentage"}, new[]{"CalculatedAttendanceGrade"}, new[]{"CalculatedIncrementPercentage"}, new[]{"TotalAppreciations","Appreciation"}, new[]{"TotalError","Disciplinary"}, new[]{"Incentive"}, new[]{"Salary"}, new[]{"CalculatedIncrementPercentage"}, new[]{"IncrementAmount"}, new[]{"SalaryAfterIncrement","GrandTotal"}, new[]{"IncMonth","Month"}, new[]{"Year"}, new[]{"ErrorPerLoan"}, new[]{"CriticalPerLoan"}, new[]{"NonCriticalPerLoan"}, new[]{"LoanCount"}, new[]{"CriticalErrorCount"}, new[]{"NonCriticalErrorCount"}
                };
                for (int column = 0; column < headers.Length; column++) summary.Cell(1, column + 1).Value = headers[column];
                for (int rowIndex = 0; rowIndex < evaluation.Rows.Count; rowIndex++)
                {
                    for (int column = 0; column < headers.Length; column++)
                    {
                        object cellValue = column == 0 ? (object)(rowIndex + 1) : FirstColumnValue(evaluation.Rows[rowIndex], fields[column]);
                        summary.Cell(rowIndex + 2, column + 1).Value = XLCellValue.FromObject(cellValue == DBNull.Value ? "" : cellValue);
                    }
                }
                FormatWorksheet(summary, headers.Length);

                HashSet<string> exportedCodes = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                foreach (DataRow evaluationRow in evaluation.Rows)
                {
                    string code = Convert.ToString(FirstColumnValue(evaluationRow, new[] { "Code" })).Trim();
                    if (string.IsNullOrEmpty(code) || !exportedCodes.Add(code)) continue;

                    IXLWorksheet sheet = workbook.Worksheets.Add(SafeSheetName(code));
                    sheet.Cell(1, 1).Value = code + " - User-wise details";
                    sheet.Cell(2, 1).Value = "Production data";
                    sheet.Cell(2, 10).Value = "Quality feedback";
                    DataRow[] production = details.Tables[0].Select("Code = '" + code.Replace("'", "''") + "'");
                    WriteRows(sheet, 3, 1, details.Tables[0], production, new[] { "ProjectName", "Code", "Employee", "LocationCode", "Process", "ProcessDate", "Target", "LoanCount" });
                    DataRow[] feedback = details.Tables[1].Select("EmployeeCode = '" + code.Replace("'", "''") + "'");
                    WriteRows(sheet, 3, 10, details.Tables[1], feedback, new[] { "FeedbackID", "Loan Number", "Client", "UW Name", "QC Name", "Date Reviewed", "QC Date", "Category", "Sub category", "Error Field", "Screen", "Error Type", "Finding", "Feedback Type", "Severity", "RCA", "Finding Status" });
                    FormatWorksheet(sheet, 26);
                }

                using (MemoryStream stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    byte[] bytes = stream.ToArray();
                    Response.Clear();
                    Response.BufferOutput = true;
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("Content-Disposition", "attachment; filename=Employee_Evaluation_Report_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".xlsx");
                    Response.AddHeader("Content-Length", bytes.Length.ToString(CultureInfo.InvariantCulture));
                    Response.BinaryWrite(bytes);
                    Response.Flush();
                    exportCompleted = true;
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
        }

        protected override void Render(System.Web.UI.HtmlTextWriter writer)
        {
            if (!exportCompleted)
            {
                base.Render(writer);
            }
        }

        private static DataSet GetAllUserWiseExportData()
        {
            const string query = @"
                SET NOCOUNT ON;
                ;WITH RankedDates AS
                (
                    SELECT Code, CAST(FromDate AS date) FromDate, CAST(ToDate AS date) ToDate,
                        ROW_NUMBER() OVER(PARTITION BY Code ORDER BY DateID DESC, AddedDate DESC) RowNumber
                    FROM dbo.UW_IncrementDates WITH(NOLOCK)
                ) SELECT Code,FromDate,ToDate INTO #Dates FROM RankedDates WHERE RowNumber=1;
                ;WITH RankedConfig AS
                (
                    SELECT Code,PsuedoName,LocationCode,
                        ROW_NUMBER() OVER(PARTITION BY Code ORDER BY EmpConfigrationID DESC) RowNumber
                    FROM dbo.EmployeeConfiguration WITH(NOLOCK) WHERE ISNULL(IsDelete,0)=0
                ) SELECT Code,PsuedoName,LocationCode INTO #Config FROM RankedConfig WHERE RowNumber=1;

                SELECT ISNULL(project.ProjectName,CONVERT(nvarchar(100),production.ProjectID)) ProjectName,
                    production.Code,MAX(production.Employee) Employee,ISNULL(configuration.LocationCode,'') LocationCode,
                    production.Process,REPLACE(CONVERT(varchar(9),CAST(production.EndDate AS date),6),' ','-') ProcessDate,
                    production.Target,COUNT(NULLIF(LTRIM(RTRIM(production.LoanNo)),'')) LoanCount
                FROM dbo.ProductionData production WITH(NOLOCK)
                INNER JOIN #Dates dates ON dates.Code=production.Code
                LEFT JOIN dbo.Project project WITH(NOLOCK) ON project.ProjectID=production.ProjectID
                LEFT JOIN #Config configuration ON configuration.Code=production.Code
                WHERE CAST(production.EndDate AS date) BETWEEN dates.FromDate AND dates.ToDate
                GROUP BY project.ProjectName,production.ProjectID,production.Code,configuration.LocationCode,
                    production.Process,CAST(production.EndDate AS date),production.Target;

                SELECT configuration.Code EmployeeCode,feedback.FeedbackID,feedback.[Loan Number],feedback.Client,
                    feedback.[UW Name],feedback.[QC Name],feedback.[Date Reviewed],feedback.[QC Date],feedback.Category,
                    feedback.[Sub category],feedback.[Error Field],feedback.Screen,feedback.[Error Type],feedback.Finding,
                    feedback.[Feedback Type],feedback.Severity,feedback.RCA,feedback.[Finding Status]
                FROM #Config configuration
                INNER JOIN #Dates dates ON dates.Code=configuration.Code
                INNER JOIN dbo.ImportedFeedbacks feedback WITH(NOLOCK)
                    ON UPPER(LTRIM(RTRIM(feedback.[UW Name])))=UPPER(LTRIM(RTRIM(configuration.PsuedoName)))
                    AND CAST(feedback.[QC Date] AS date) BETWEEN dates.FromDate AND dates.ToDate
                WHERE LTRIM(RTRIM(feedback.Severity)) IN('Critical','Critial','Non Critical','Non-Critical')
                    AND EXISTS
                    (
                        SELECT 1 FROM dbo.ProductionData matchedProduction WITH(NOLOCK)
                        WHERE matchedProduction.Code=configuration.Code
                            AND CAST(matchedProduction.EndDate AS date) BETWEEN dates.FromDate AND dates.ToDate
                            AND UPPER(LTRIM(RTRIM(matchedProduction.LoanNo)))=UPPER(LTRIM(RTRIM(feedback.[Loan Number])))
                    );";
            return SQLHelper.ExecuteDataSetCmd(SQLHelper.GetCommand(CommandType.Text, query), 600);
        }

        private static int WriteRows(IXLWorksheet sheet, int startRow, int startColumn, DataTable source, DataRow[] rows, string[] columns)
        {
            for (int i = 0; i < columns.Length; i++) sheet.Cell(startRow, startColumn + i).Value = columns[i];
            for (int row = 0; row < rows.Length; row++)
                for (int column = 0; column < columns.Length; column++)
                    sheet.Cell(startRow + row + 1, startColumn + column).Value = XLCellValue.FromObject(rows[row][columns[column]] == DBNull.Value ? "" : rows[row][columns[column]]);
            return startRow + rows.Length + 1;
        }

        private static void FormatWorksheet(IXLWorksheet sheet, int columnCount)
        {
            sheet.SheetView.FreezeRows(1);
            sheet.RangeUsed().Style.Font.FontName = "Arial";
            sheet.RangeUsed().Style.Font.FontSize = 9;
            sheet.Row(1).Style.Font.Bold = true;
            sheet.Row(1).Style.Fill.BackgroundColor = XLColor.FromHtml("#D9EAF7");
            sheet.Columns(1, columnCount).AdjustToContents(1, 100);
        }

        private static object FirstColumnValue(DataRow row, string[] names)
        {
            foreach (string name in names)
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value && Convert.ToString(row[name]) != "") return row[name];
            return "";
        }

        private static string SafeSheetName(string code)
        {
            string name = code;
            foreach (char invalid in new[] { ':', '\\', '/', '?', '*', '[', ']' }) name = name.Replace(invalid, '_');
            return name.Length > 31 ? name.Substring(0, 31) : name;
        }

        private static void AppendMissingPendingEmployees(DataTable table, bllSalary salary)
        {
            if (table == null) return;

            HashSet<string> existingCodes = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            if (table.Columns.Contains("Code"))
            {
                foreach (DataRow row in table.Rows)
                {
                    existingCodes.Add(Convert.ToString(row["Code"]).Trim());
                }
            }

            SqlCommand command = SQLHelper.GetCommand(CommandType.Text,
                "SELECT DISTINCT Code FROM dbo.IncrementProposal_UnderWriting WITH (NOLOCK) " +
                "WHERE FinalRemark IS NULL AND NULLIF(LTRIM(RTRIM(Code)), '') IS NOT NULL ORDER BY Code;");
            DataTable pendingCodes = SQLHelper.ExecuteDataTableCmd(command);

            foreach (DataRow pendingRow in pendingCodes.Rows)
            {
                string code = Convert.ToString(pendingRow["Code"]).Trim();
                if (existingCodes.Contains(code)) continue;

                DataTable missingRows = salary.GetIncrementProposalByCode(code, true);
                if (missingRows != null && missingRows.Rows.Count > 0)
                {
                    table.Merge(missingRows, false, MissingSchemaAction.Add);
                    existingCodes.Add(code);
                }
            }
        }

        private static void HydrateEmployeeDetails(DataTable table)
        {
            if (table == null || !table.Columns.Contains("Code")) return;
            const string query = @"
                SELECT employee.Code,
                    LTRIM(RTRIM(ISNULL(employee.FirstName,'')+' '+ISNULL(employee.MiddleName,'')+' '+ISNULL(employee.lastName,''))) AS Name,
                    branch.BranchName, 'UnderWriting' AS D_Name, employee.JoiningDate,
                    managerEmployee.Code+' : '+LTRIM(RTRIM(ISNULL(managerEmployee.FirstName,'')+' '+ISNULL(managerEmployee.lastName,''))) AS ReportingManager,
                    employee.DailyTaskProductivity AS DPType, employee.Salary,
                    CASE WHEN latestIncrement.EmployeeID IS NULL
                         THEN DATEDIFF(MONTH,CAST(employee.JoiningDate AS date),GETDATE())
                         ELSE DATEDIFF(MONTH,CAST('1-'+LEFT(latestIncrement.Month,3)+'-'+CAST(latestIncrement.Year AS nvarchar(10)) AS date),GETDATE()) END AS TenureSinceLastInc,
                    details.ProductionPerc, attendance.OnWorkingDays, details.ErrorPerLoan,
                    details.CriticalPerLoan, details.NonCriticalPerLoan,
                    details.TotalAppreciations, details.TotalError
                FROM dbo.EmployeeInfo employee WITH(NOLOCK)
                LEFT JOIN dbo.Branch branch WITH(NOLOCK) ON branch.BranchID=employee.WorkingBranch
                LEFT JOIN dbo.ProjectManager manager WITH(NOLOCK) ON manager.ProjectManagerID=employee.ProjectManager
                LEFT JOIN dbo.EmployeeInfo managerEmployee WITH(NOLOCK) ON managerEmployee.EmployeeID=manager.ProjectManagerName
                LEFT JOIN dbo.IncrementProposalDetails_UnderWrirting details WITH(NOLOCK) ON details.Code=employee.Code
                LEFT JOIN dbo.AttendancePercentageDetails attendance WITH(NOLOCK) ON attendance.Code=employee.Code
                OUTER APPLY
                (
                    SELECT TOP(1) increment.EmployeeID,increment.Month,increment.Year
                    FROM dbo.IncrementMaster increment WITH(NOLOCK)
                    WHERE increment.EmployeeID=employee.EmployeeID
                    ORDER BY increment.AddedDate DESC
                ) latestIncrement
                WHERE employee.Code IN
                    (SELECT DISTINCT Code FROM dbo.IncrementProposal_UnderWriting WITH(NOLOCK) WHERE FinalRemark IS NULL);";

            DataTable employeeDetails = SQLHelper.ExecuteDataTableCmd(SQLHelper.GetCommand(CommandType.Text, query));
            Dictionary<string, DataRow> detailsByCode = new Dictionary<string, DataRow>(StringComparer.OrdinalIgnoreCase);
            foreach (DataRow detail in employeeDetails.Rows) detailsByCode[Convert.ToString(detail["Code"]).Trim()] = detail;

            foreach (DataRow row in table.Rows)
            {
                DataRow detail;
                if (!detailsByCode.TryGetValue(Convert.ToString(row["Code"]).Trim(), out detail))
                {
                    if (!table.Columns.Contains("Name")) table.Columns.Add("Name", typeof(string));
                    if (!table.Columns.Contains("D_Name")) table.Columns.Add("D_Name", typeof(string));
                    if (row["Name"] == DBNull.Value || string.IsNullOrWhiteSpace(Convert.ToString(row["Name"]))) row["Name"] = "#N/A";
                    if (row["D_Name"] == DBNull.Value || string.IsNullOrWhiteSpace(Convert.ToString(row["D_Name"]))) row["D_Name"] = "UnderWriting";
                    continue;
                }
                string[] fields = { "Name", "BranchName", "D_Name", "JoiningDate", "ReportingManager", "DPType", "Salary", "TenureSinceLastInc", "ProductionPerc", "OnWorkingDays", "ErrorPerLoan", "CriticalPerLoan", "NonCriticalPerLoan", "TotalAppreciations", "TotalError" };
                foreach (string field in fields)
                {
                    if (!table.Columns.Contains(field)) table.Columns.Add(field, detail.Table.Columns[field].DataType);
                    if ((row[field] == DBNull.Value || string.IsNullOrWhiteSpace(Convert.ToString(row[field]))) && detail[field] != DBNull.Value) row[field] = detail[field];
                }
            }
        }

        private static void AddEvaluationCounts(DataTable table)
        {
            if (table == null) return;
            if (!table.Columns.Contains("LoanCount")) table.Columns.Add("LoanCount", typeof(int));
            if (!table.Columns.Contains("CriticalErrorCount")) table.Columns.Add("CriticalErrorCount", typeof(int));
            if (!table.Columns.Contains("NonCriticalErrorCount")) table.Columns.Add("NonCriticalErrorCount", typeof(int));
            if (!table.Columns.Contains("CalculatedQcPercentage")) table.Columns.Add("CalculatedQcPercentage", typeof(decimal));
            if (!table.Columns.Contains("CalculatedProductionGrade")) table.Columns.Add("CalculatedProductionGrade", typeof(string));
            if (!table.Columns.Contains("CalculatedQualityGrade")) table.Columns.Add("CalculatedQualityGrade", typeof(string));
            if (!table.Columns.Contains("CalculatedAttendanceGrade")) table.Columns.Add("CalculatedAttendanceGrade", typeof(string));
            if (!table.Columns.Contains("CalculatedIncrementPercentage")) table.Columns.Add("CalculatedIncrementPercentage", typeof(decimal));

            const string countQuery = @"
                ;WITH LatestDates AS
                (
                    SELECT Code, CAST(FromDate AS date) AS FromDate, CAST(ToDate AS date) AS ToDate,
                        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY DateID DESC, AddedDate DESC) AS RowNumber
                    FROM dbo.UW_IncrementDates WITH (NOLOCK)
                ),
                LatestConfiguration AS
                (
                    SELECT Code, PsuedoName,
                        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY EmpConfigrationID DESC) AS RowNumber
                    FROM dbo.EmployeeConfiguration WITH (NOLOCK)
                    WHERE ISNULL(IsDelete, 0) = 0
                ),
                ProductionCounts AS
                (
                    SELECT production.Code,
                        COUNT(NULLIF(LTRIM(RTRIM(production.LoanNo)), '')) AS LoanCount
                    FROM dbo.ProductionData production WITH (NOLOCK)
                    INNER JOIN LatestDates dates ON dates.Code = production.Code AND dates.RowNumber = 1
                    WHERE CAST(production.EndDate AS date) BETWEEN dates.FromDate AND dates.ToDate
                    GROUP BY production.Code
                ),
                FeedbackCounts AS
                (
                    SELECT configuration.Code,
                        SUM(CASE WHEN LTRIM(RTRIM(feedback.Severity)) IN ('Critical', 'Critial') THEN 1 ELSE 0 END) AS CriticalErrorCount,
                        SUM(CASE WHEN LTRIM(RTRIM(feedback.Severity)) IN ('Non Critical', 'Non-Critical') THEN 1 ELSE 0 END) AS NonCriticalErrorCount
                    FROM LatestConfiguration configuration
                    INNER JOIN LatestDates dates ON dates.Code = configuration.Code AND dates.RowNumber = 1
                    INNER JOIN dbo.ImportedFeedbacks feedback WITH (NOLOCK)
                        ON UPPER(LTRIM(RTRIM(feedback.[UW Name]))) = UPPER(LTRIM(RTRIM(configuration.PsuedoName)))
                        AND CAST(feedback.[QC Date] AS date) BETWEEN dates.FromDate AND dates.ToDate
                        AND LTRIM(RTRIM(feedback.Severity)) IN ('Critical', 'Critial', 'Non Critical', 'Non-Critical')
                    WHERE configuration.RowNumber = 1
                        AND EXISTS
                        (
                            SELECT 1
                            FROM dbo.ProductionData matchedProduction WITH (NOLOCK)
                            WHERE matchedProduction.Code = configuration.Code
                                AND CAST(matchedProduction.EndDate AS date) BETWEEN dates.FromDate AND dates.ToDate
                                AND UPPER(LTRIM(RTRIM(matchedProduction.LoanNo))) = UPPER(LTRIM(RTRIM(feedback.[Loan Number])))
                        )
                    GROUP BY configuration.Code
                )
                SELECT proposal.Code, ISNULL(production.LoanCount, 0) AS LoanCount,
                    ISNULL(feedback.CriticalErrorCount, 0) AS CriticalErrorCount,
                    ISNULL(feedback.NonCriticalErrorCount, 0) AS NonCriticalErrorCount,
                    grading.ProdFromA, grading.ProdBFrom, grading.ProdBTo, grading.ProdCFrom, grading.ProdCTo,
                    grading.QuaAFrom, grading.QuaBFrom, grading.QuaBTo, grading.QuaCFrom, grading.QuaCTo,
                    grading.AttnAFrom, grading.AttnBFrom, grading.AttnBTo, grading.AttnCFrom, grading.AttnCTo,
                    grading.ProductionA, grading.ProductionB, grading.ProductionC,
                    grading.QualityA, grading.QualityB, grading.QualityC,
                    grading.AttendanceA, grading.AttendanceB, grading.AttendanceC
                FROM (SELECT DISTINCT Code FROM dbo.IncrementProposal_UnderWriting WITH (NOLOCK) WHERE FinalRemark IS NULL) proposal
                LEFT JOIN ProductionCounts production ON production.Code = proposal.Code
                LEFT JOIN FeedbackCounts feedback ON feedback.Code = proposal.Code
                LEFT JOIN dbo.EmployeeInfo employee WITH (NOLOCK) ON employee.Code = proposal.Code
                OUTER APPLY
                (
                    SELECT TOP (1) ProdFromA, ProdBFrom, ProdBTo, ProdCFrom, ProdCTo,
                        QuaAFrom, QuaBFrom, QuaBTo, QuaCFrom, QuaCTo,
                        AttnAFrom, AttnBFrom, AttnBTo, AttnCFrom, AttnCTo,
                        ProductionA, ProductionB, ProductionC,
                        QualityA, QualityB, QualityC,
                        AttendanceA, AttendanceB, AttendanceC
                    FROM dbo.GradingMaster_UnderWriting WITH (NOLOCK)
                    WHERE Branch = employee.WorkingBranch
                    ORDER BY UWGradingID DESC
                ) grading;";

            DataTable counts = SQLHelper.ExecuteDataTableCmd(SQLHelper.GetCommand(CommandType.Text, countQuery));
            Dictionary<string, DataRow> countsByCode = new Dictionary<string, DataRow>(StringComparer.OrdinalIgnoreCase);
            foreach (DataRow countRow in counts.Rows)
            {
                countsByCode[Convert.ToString(countRow["Code"]).Trim()] = countRow;
            }

            foreach (DataRow row in table.Rows)
            {
                DataRow countRow;
                string code = table.Columns.Contains("Code") ? Convert.ToString(row["Code"]).Trim() : "";
                if (countsByCode.TryGetValue(code, out countRow))
                {
                    row["LoanCount"] = countRow["LoanCount"];
                    row["CriticalErrorCount"] = countRow["CriticalErrorCount"];
                    row["NonCriticalErrorCount"] = countRow["NonCriticalErrorCount"];
                }
                else
                {
                    row["LoanCount"] = 0;
                    row["CriticalErrorCount"] = 0;
                    row["NonCriticalErrorCount"] = 0;
                }

                decimal loanCount = Convert.ToDecimal(row["LoanCount"]);
                decimal criticalErrorCount = Convert.ToDecimal(row["CriticalErrorCount"]);
                decimal nonCriticalErrorCount = Convert.ToDecimal(row["NonCriticalErrorCount"]);
                decimal totalOpportunities = loanCount * 1000m;
                decimal missedOpportunities = (criticalErrorCount * 1000m) + nonCriticalErrorCount;
                row["CalculatedQcPercentage"] = totalOpportunities > 0
                    ? Math.Round(((totalOpportunities - missedOpportunities) / totalOpportunities) * 100m, 2)
                    : 0m;

                string dpType = Convert.ToString(FirstColumnValue(row, new[] { "DPType", "DailyTaskProductivity", "ProductiveTask" }));
                decimal productionPercentage = ParseDecimal(FirstColumnValue(row, new[] { "ProductionPerc", "ProductionPercentage" }));
                decimal attendancePercentage = ParseDecimal(FirstColumnValue(row, new[] { "OnWorkingDays", "AttendancePerc", "AttendancePercentage" }));
                decimal qualityPercentage = Convert.ToDecimal(row["CalculatedQcPercentage"]);
                if (dpType.Equals("Task", StringComparison.OrdinalIgnoreCase))
                {
                    row["CalculatedProductionGrade"] = "";
                    row["CalculatedQualityGrade"] = "";
                    row["CalculatedIncrementPercentage"] = DBNull.Value;
                }
                else if (countRow != null)
                {
                    row["CalculatedProductionGrade"] = CalculateGrade(Math.Round(productionPercentage, 0, MidpointRounding.AwayFromZero), countRow, "Prod");
                    row["CalculatedQualityGrade"] = CalculateGrade(qualityPercentage, countRow, "Qua");
                }
                if (countRow != null)
                {
                    row["CalculatedAttendanceGrade"] = CalculateGrade(Math.Round(attendancePercentage, 0, MidpointRounding.AwayFromZero), countRow, "Attn");
                }
                if (!dpType.Equals("Task", StringComparison.OrdinalIgnoreCase) && countRow != null)
                {
                    decimal productionContribution = GradeContribution(Convert.ToString(row["CalculatedProductionGrade"]), countRow, "Production");
                    decimal qualityContribution = GradeContribution(Convert.ToString(row["CalculatedQualityGrade"]), countRow, "Quality");
                    decimal attendanceContribution = GradeContribution(Convert.ToString(row["CalculatedAttendanceGrade"]), countRow, "Attendance");
                    decimal pktContribution = ParseDecimal(FirstColumnValue(row, new[] { "PKTPerc", "PKTPercentage" }));
                    decimal engContribution = ParseDecimal(FirstColumnValue(row, new[] { "ENGPerc", "ENGPercentage" }));
                    decimal flexibilityContribution = ParseDecimal(FirstColumnValue(row, new[] { "FlexibilityPerc", "FlexibilityPercentage" }));
                    row["CalculatedIncrementPercentage"] = productionContribution + qualityContribution + attendanceContribution + pktContribution + engContribution + flexibilityContribution;
                }
            }
        }

        private static decimal GradeContribution(string grade, DataRow criteria, string prefix)
        {
            if (grade != "A" && grade != "B" && grade != "C") return 0m;
            return ParseDecimal(criteria[prefix + grade]);
        }

        private static string CalculateGrade(decimal percentage, DataRow criteria, string prefix)
        {
            string fromAColumn = prefix == "Prod" ? "ProdFromA" : prefix + "AFrom";
            decimal fromA = ParseDecimal(criteria[fromAColumn]);
            decimal fromB = ParseDecimal(criteria[prefix + "BFrom"]);
            decimal toB = ParseDecimal(criteria[prefix + "BTo"]);
            decimal fromC = ParseDecimal(criteria[prefix + "CFrom"]);
            decimal toC = ParseDecimal(criteria[prefix + "CTo"]);
            if (percentage >= fromA) return "A";
            if (percentage >= fromB && percentage <= toB) return "B";
            if (percentage >= fromC && percentage <= toC) return "C";
            return "";
        }

        private static decimal ParseDecimal(object value)
        {
            decimal parsed;
            return decimal.TryParse(Convert.ToString(value), NumberStyles.Any, CultureInfo.InvariantCulture, out parsed)
                || decimal.TryParse(Convert.ToString(value), out parsed) ? parsed : 0m;
        }

        [WebMethod]
        public static string GetUserWiseData(string Code)
        {
            string code = Convert.ToString(Code).Trim();
            if (string.IsNullOrEmpty(code) || code.Length > 10)
            {
                return Serialize(new { Code = code, FromDate = "", ToDate = "", Production = new object[0], Feedback = new object[0], Errors = new[] { "A valid employee code is required." } });
            }

            const string query = @"
                SET NOCOUNT ON;
                DECLARE @FromDate date, @ToDate date;

                SELECT TOP (1)
                    @FromDate = CAST(FromDate AS date),
                    @ToDate = CAST(ToDate AS date)
                FROM dbo.UW_IncrementDates WITH (NOLOCK)
                WHERE Code = @Code
                ORDER BY DateID DESC, AddedDate DESC;

                SELECT @FromDate AS FromDate, @ToDate AS ToDate;

                SELECT
                    ISNULL(project.ProjectName, CONVERT(nvarchar(100), production.ProjectID)) AS ProjectName,
                    production.Code,
                    MAX(production.Employee) AS Employee,
                    ISNULL(configuration.LocationCode, '') AS LocationCode,
                    production.Process,
                    REPLACE(CONVERT(varchar(9), CAST(production.EndDate AS date), 6), ' ', '-') AS ProcessDate,
                    production.Target,
                    COUNT(NULLIF(LTRIM(RTRIM(production.LoanNo)), '')) AS LoanCount
                FROM dbo.ProductionData production WITH (NOLOCK)
                LEFT JOIN dbo.Project project WITH (NOLOCK) ON project.ProjectID = production.ProjectID
                OUTER APPLY
                (
                    SELECT TOP (1) LocationCode
                    FROM dbo.EmployeeConfiguration WITH (NOLOCK)
                    WHERE Code = production.Code AND ISNULL(IsDelete, 0) = 0
                    ORDER BY EmpConfigrationID DESC
                ) configuration
                WHERE production.Code = @Code
                    AND @FromDate IS NOT NULL AND @ToDate IS NOT NULL
                    AND CAST(production.EndDate AS date) BETWEEN @FromDate AND @ToDate
                GROUP BY project.ProjectName, production.ProjectID, production.Code,
                    configuration.LocationCode, production.Process,
                    CAST(production.EndDate AS date), production.Target
                ORDER BY CAST(production.EndDate AS date), project.ProjectName, production.Process;

                ;WITH EmployeePseudo AS
                (
                    SELECT TOP (1) PsuedoName
                    FROM dbo.EmployeeConfiguration WITH (NOLOCK)
                    WHERE Code = @Code
                        AND ISNULL(IsDelete, 0) = 0
                        AND NULLIF(LTRIM(RTRIM(PsuedoName)), '') IS NOT NULL
                    ORDER BY EmpConfigrationID DESC
                )
                SELECT f.FeedbackID, f.[Loan Number], f.Client, f.[UW Name], f.[QC Name],
                    f.[Date Reviewed], f.[QC Date], f.Category, f.[Sub category], f.[Error Field],
                    f.Screen, f.[Error Type], f.Finding, f.[Feedback Type], f.Severity, f.RCA,
                    f.[Finding Status]
                FROM dbo.ImportedFeedbacks f WITH (NOLOCK)
                CROSS JOIN EmployeePseudo employee
                WHERE @FromDate IS NOT NULL AND @ToDate IS NOT NULL
                    AND CAST(f.[QC Date] AS date) BETWEEN @FromDate AND @ToDate
                    AND UPPER(LTRIM(RTRIM(f.[UW Name]))) = UPPER(LTRIM(RTRIM(employee.PsuedoName)))
                    AND LTRIM(RTRIM(f.Severity)) IN ('Critical', 'Critial', 'Non Critical', 'Non-Critical')
                    AND EXISTS
                    (
                        SELECT 1
                        FROM dbo.ProductionData matchedProduction WITH (NOLOCK)
                        WHERE matchedProduction.Code = @Code
                            AND CAST(matchedProduction.EndDate AS date) BETWEEN @FromDate AND @ToDate
                            AND UPPER(LTRIM(RTRIM(matchedProduction.LoanNo))) = UPPER(LTRIM(RTRIM(f.[Loan Number])))
                    )
                ORDER BY CAST(f.[QC Date] AS date), f.FeedbackID;";

            List<string> errors = new List<string>();
            DataSet data = new DataSet();
            try
            {
                SqlCommand command = SQLHelper.GetCommand(CommandType.Text, query);
                SQLHelper.AddParamToSQLCmd(command, "@Code", SqlDbType.NVarChar, 10, ParameterDirection.Input, code);
                data = SQLHelper.ExecuteDataSetCmd(command, 180);
            }
            catch (Exception ex)
            {
                errors.Add("User-wise evaluation data: " + ex.Message);
            }

            DateTime? fromDate = null;
            DateTime? toDate = null;
            if (data.Tables.Count > 0 && data.Tables[0].Rows.Count > 0)
            {
                fromDate = AsNullableDate(data.Tables[0].Rows[0]["FromDate"]);
                toDate = AsNullableDate(data.Tables[0].Rows[0]["ToDate"]);
            }

            return Serialize(new
            {
                Code = code,
                FromDate = FormatDate(fromDate),
                ToDate = FormatDate(toDate),
                Production = data.Tables.Count > 1 ? ToRows(data.Tables[1]) : new List<Dictionary<string, object>>(),
                Feedback = data.Tables.Count > 2 ? ToRows(data.Tables[2]) : new List<Dictionary<string, object>>(),
                Errors = errors
            });
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                {
                    object value = dataRow[column];
                    row[column.ColumnName] = value == DBNull.Value ? "" : value;
                }
                rows.Add(row);
            }
            return rows;
        }

        private static DateTime? AsNullableDate(object value)
        {
            if (value == null || value == DBNull.Value) return null;
            DateTime date;
            return DateTime.TryParse(Convert.ToString(value), out date) ? (DateTime?)date : null;
        }

        private static string FormatDate(DateTime? value)
        {
            return value.HasValue ? value.Value.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) : "";
        }

        private static int CurrentUserId()
        {
            int employeeId;
            return HttpContext.Current != null && HttpContext.Current.User != null &&
                int.TryParse(HttpContext.Current.User.Identity.Name, out employeeId) ? employeeId : 0;
        }

        private static string Serialize(object value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer { MaxJsonLength = int.MaxValue };
            return serializer.Serialize(value);
        }
    }
}
