using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;

namespace WebPortal.Admin
{
    internal static class DashboardPythonRunner
    {
        internal sealed class Result
        {
            internal string CleanupPath { get; set; }
            internal string ValidationPath { get; set; }
            internal IList<IssueRow> Issues { get; set; }
        }

        internal sealed class IssueRow
        {
            internal string LoanId { get; set; }
            internal string Sheet { get; set; }
            internal string Finding { get; set; }
            internal string Result { get; set; }
            internal string Comment { get; set; }
        }

        internal static Result Generate(string prpPath, string dcPath, string templatePath, string outputDirectory)
        {
            string scriptDirectory = System.Web.Hosting.HostingEnvironment.MapPath("~/App_Data/DashboardValidator");
            if (string.IsNullOrWhiteSpace(scriptDirectory))
                throw new InvalidOperationException("Dashboard Validator script directory could not be resolved.");

            string cleanupScript = Path.Combine(scriptDirectory, "prp_to_cleanup.py");
            string validationScript = Path.Combine(scriptDirectory, "validate_dc.py");
            if (!File.Exists(cleanupScript) || !File.Exists(validationScript))
                throw new InvalidOperationException("Dashboard Validator processing scripts are not available.");

            string unique = DateTime.Now.ToString("yyyyMMdd_HHmmss") + "_" + Guid.NewGuid().ToString("N");
            string cleanupPath = Path.Combine(outputDirectory, "Dashboard_Clean_up_" + unique + ".xlsx");
            string validationPath = Path.Combine(outputDirectory, "DC_Validation_Report_" + unique + ".xlsx");

            try
            {
                RunPython(cleanupScript, prpPath, templatePath, cleanupPath);
                RunPython(validationScript, prpPath, dcPath, templatePath, validationPath);
                if (!File.Exists(cleanupPath) || !File.Exists(validationPath))
                    throw new InvalidOperationException("The processor completed without creating both output workbooks.");

                return new Result
                {
                    CleanupPath = cleanupPath,
                    ValidationPath = validationPath,
                    Issues = ReadIssues(validationPath)
                };
            }
            catch
            {
                SafeDelete(cleanupPath);
                SafeDelete(validationPath);
                throw;
            }
        }

        private static void RunPython(string script, params string[] arguments)
        {
            string python = ConfigurationManager.AppSettings["DashboardValidatorPythonExe"];
            if (string.IsNullOrWhiteSpace(python)) python = "python";

            var start = new ProcessStartInfo
            {
                FileName = python,
                Arguments = Quote(script) + " " + string.Join(" ", arguments.Select(Quote)),
                UseShellExecute = false,
                CreateNoWindow = true,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                WorkingDirectory = Path.GetDirectoryName(script)
            };
            // Ship openpyxl with the application so production does not depend on
            // packages installed into the web server's global Python environment.
            string bundledLibraries = Path.Combine(Path.GetDirectoryName(script), "pythonlibs");
            if (!Directory.Exists(bundledLibraries))
                throw new InvalidOperationException("Dashboard Validator Python libraries are not available.");
            string existingPythonPath = start.EnvironmentVariables["PYTHONPATH"];
            start.EnvironmentVariables["PYTHONPATH"] = string.IsNullOrWhiteSpace(existingPythonPath)
                ? bundledLibraries
                : bundledLibraries + Path.PathSeparator + existingPythonPath;

            var stdout = new StringBuilder();
            var stderr = new StringBuilder();
            using (var process = new Process { StartInfo = start })
            {
                process.OutputDataReceived += (s, e) => { if (e.Data != null) stdout.AppendLine(e.Data); };
                process.ErrorDataReceived += (s, e) => { if (e.Data != null) stderr.AppendLine(e.Data); };
                try { process.Start(); }
                catch (Exception ex)
                {
                    throw new InvalidOperationException("Python 3 is required on the web server. " + ex.Message, ex);
                }
                process.BeginOutputReadLine();
                process.BeginErrorReadLine();
                if (!process.WaitForExit(10 * 60 * 1000))
                {
                    try { process.Kill(); } catch { }
                    throw new InvalidOperationException("Dashboard processing exceeded the 10 minute limit.");
                }
                process.WaitForExit();
                if (process.ExitCode != 0)
                {
                    string detail = stderr.Length > 0 ? stderr.ToString() : stdout.ToString();
                    throw new InvalidOperationException("Dashboard processing failed. " + LastUsefulLine(detail));
                }
            }
        }

        private static IList<IssueRow> ReadIssues(string path)
        {
            var rows = new List<IssueRow>();
            using (var workbook = new XLWorkbook(path))
            {
                IXLWorksheet sheet = workbook.Worksheets.FirstOrDefault(x => string.Equals(x.Name, "All Issues", StringComparison.OrdinalIgnoreCase));
                if (sheet == null || sheet.LastRowUsed() == null) return rows;
                var headers = sheet.Row(1).CellsUsed().ToDictionary(x => Normalize(x.GetString()), x => x.Address.ColumnNumber);
                for (int r = 2; r <= sheet.LastRowUsed().RowNumber(); r++)
                {
                    string loan = Cell(sheet, r, headers, "investorloanid");
                    if (string.IsNullOrWhiteSpace(loan)) continue;
                    rows.Add(new IssueRow
                    {
                        LoanId = loan,
                        Sheet = Cell(sheet, r, headers, "sheet"),
                        Finding = Cell(sheet, r, headers, "dashboardfinding"),
                        Result = Cell(sheet, r, headers, "result"),
                        Comment = Cell(sheet, r, headers, "comment")
                    });
                }
            }
            return rows;
        }

        private static string Cell(IXLWorksheet sheet, int row, IDictionary<string, int> headers, string name)
        {
            int column;
            return headers.TryGetValue(name, out column) ? sheet.Cell(row, column).GetFormattedString() : string.Empty;
        }

        private static string Normalize(string value)
        {
            return new string((value ?? string.Empty).Where(char.IsLetterOrDigit).Select(char.ToLowerInvariant).ToArray());
        }

        private static string Quote(string value) { return "\"" + (value ?? string.Empty).Replace("\"", "\\\"") + "\""; }
        private static string LastUsefulLine(string value)
        {
            return (value ?? string.Empty).Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries).LastOrDefault() ?? "Unknown processing error.";
        }
        private static void SafeDelete(string path) { try { if (File.Exists(path)) File.Delete(path); } catch { } }
    }
}
