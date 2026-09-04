using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.FTE
{
    public partial class FTEBilling : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetAllProjects()
        {
            DataTable dt = new bllMaster().GetAllProjectByUserRights(HttpContext.Current.User.Identity.Name);
            return Serialize(dt);
        }

        [WebMethod]
        public static string getBillingPeriodByProject(int Project)
        {
            return new bllTracking().getBillingPeriodByProject(Convert.ToString(Project));
        }

        [WebMethod]
        public static string GetBillingPeriod(string BillingCycle)
        {
            DataTable dt = new bllMaster().GetBilligPeriodDates(BillingCycle);
            return Serialize(dt);
        }

        [WebMethod]
        public static string GetBillingReport(int ProjectID, string BillingPeriod)
        {
            BillingReportResult result = BuildBillingReport(ProjectID, BillingPeriod);
            return SerializeObject(result);
        }



        [WebMethod]
        public static string GetExtraFteRows(int ProjectID, string BillingPeriod)
        {
            DataTable dt = GetExtraFteDetails(ProjectID, NormalizePeriod(BillingPeriod));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            foreach (DataRow row in dt.Rows)
            {
                DateTime workDate = Convert.ToDateTime(row["WorkDate"]);
                decimal hours = ToDecimal(Convert.ToString(row["Hours"]));
                rows.Add(new Dictionary<string, object>
                {
                    { "WorkDateText", workDate.ToString("dd-MMM-yyyy") },
                    { "ExtraOperatorNo", Convert.ToInt32(row["ExtraOperatorNo"]) },
                    { "Hours", FormatDecimal(hours) }
                });
            }

            return SerializeObject(rows);
        }

        [WebMethod]
        public static string SaveExtraFteRows(int ProjectID, string BillingPeriod, string DetailsJson)
        {
            BillingActionResult result = new BillingActionResult();

            try
            {
                if (ProjectID <= 0 || string.IsNullOrWhiteSpace(BillingPeriod) || string.Equals(BillingPeriod, "Select", StringComparison.OrdinalIgnoreCase))
                {
                    result.Success = false;
                    result.Message = "Please select project and billing period.";
                    return SerializeObject(result);
                }

                JavaScriptSerializer serializer = new JavaScriptSerializer();
                List<ExtraFteEntry> entries = serializer.Deserialize<List<ExtraFteEntry>>(DetailsJson ?? "[]") ?? new List<ExtraFteEntry>();
                DataTable details = BuildExtraFteSaveTable(entries);

                SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_SaveFTEBillingExtraOperators");
                SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 10, ParameterDirection.Input, ProjectID);
                SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", SqlDbType.NVarChar, 500, ParameterDirection.Input, NormalizePeriod(BillingPeriod));
                SqlParameter tvp = cmd.Parameters.AddWithValue("@Details", details);
                tvp.SqlDbType = SqlDbType.Structured;
                tvp.TypeName = "dbo.FTEBillingExtraOperatorType";
                SQLHelper.AddParamToSQLCmd(cmd, "@CreatedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, GetCurrentEmployeeId());
                SQLHelper.ExecuteNonQueryCmd(cmd);

                result.Success = true;
                result.Message = "Extra FTE hours saved successfully.";
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.Message = ex.Message;
            }

            return SerializeObject(result);
        }

        [WebMethod]
        public static string SendToAccounts(int ProjectID, string ProjectName, string BillingCycle, string BillingPeriod, string Remark)
        {
            BillingActionResult result = new BillingActionResult();

            try
            {
                if (ProjectID <= 0 || string.IsNullOrWhiteSpace(BillingPeriod) || string.Equals(BillingPeriod, "Select", StringComparison.OrdinalIgnoreCase))
                {
                    result.Success = false;
                    result.Message = "Please select project, billing cycle and billing period.";
                    return SerializeObject(result);
                }

                BillingReportResult report = BuildBillingReport(ProjectID, BillingPeriod);
                DataTable billingData = DictionaryListToDataTable(report.Rows);
                DataTable attendanceData = GetBillingAttendance(ProjectID, NormalizePeriod(BillingPeriod));

                string billingFile = WriteBillingExcelFile(ProjectName, BillingPeriod, "FTE Billing Details", billingData, IsAverageFteBillingProject(ProjectID));
                string attendanceFile = attendanceData != null && attendanceData.Rows.Count > 0
                    ? WriteBillingExcelFile(ProjectName, BillingPeriod, "FTE Billing Attendance", attendanceData, false)
                    : string.Empty;

                BillingDelayInfo delayInfo = GetBillingDelayInfo(ProjectID, BillingPeriod);
                int returnValue = UpdateBillingFlag(
                    ProjectID,
                    NormalizePeriod(BillingPeriod),
                    BillingCycle,
                    GetCurrentEmployeeId(),
                    delayInfo.ProductionBillingDate,
                    DateTime.Now.ToString("dd-MMM-yyyy HH:mm"),
                    delayInfo.IsDelay,
                    Remark,
                    "Pending");

                if (returnValue <= 0)
                {
                    result.Success = false;
                    result.Message = "Error in sending billing.";
                    return SerializeObject(result);
                }

                string subject = ProjectName + " - FTE Billing details - " + BillingPeriod;
                SendBillingMail(ProjectID, subject, BuildBillingEmailBody(ProjectName, BillingPeriod, report, billingData), billingFile, attendanceFile);

                result.Success = true;
                result.Message = "Billing sent successfully.";
                return SerializeObject(result);
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.Message = ex.Message;
                return SerializeObject(result);
            }
        }

        private static BillingReportResult BuildBillingReport(int projectID, string billingPeriod)
        {
            string normalizedPeriod = NormalizePeriod(billingPeriod);
            DataTable dt = GetBillingDetails(projectID, normalizedPeriod);
            AppendExtraFteOperatorColumns(dt, projectID, normalizedPeriod);

            BillingReportResult result = new BillingReportResult();
            result.Summary = BuildSummary(projectID, normalizedPeriod, dt);
            DataTable displayData = IsAverageFteBillingProject(projectID)
                ? BuildAverageFteBillingData(dt, projectID, normalizedPeriod)
                : dt;
            result.Rows = DataTableToDictionaryList(displayData);
            result.RecordCount = displayData == null ? 0 : displayData.Rows.Count;
            result.ReportTitle = IsAverageFteBillingProject(projectID) ? GetBillingMonthTitle(normalizedPeriod) : string.Empty;
            return result;
        }

        private static bool IsAverageFteBillingProject(int projectID)
        {
            return projectID == 203 || projectID == 400;
        }

        private static DataTable BuildAverageFteBillingData(DataTable source, int projectID, string billingPeriod)
        {
            DataTable result = new DataTable();
            result.Columns.Add("S.No");
            result.Columns.Add("Date");
            result.Columns.Add("Target Assigned");
            result.Columns.Add("Total invoices");
            result.Columns.Add("Average FTE");
            result.Columns.Add("Billed FTE");

            if (source == null || source.Rows.Count == 0) return result;

            DataTable averageData = GetAverageFteBillingDetails(projectID, billingPeriod);
            Dictionary<string, DataRow> averages = new Dictionary<string, DataRow>(StringComparer.OrdinalIgnoreCase);
            if (averageData != null)
            {
                foreach (DataRow averageRow in averageData.Rows)
                {
                    DateTime averageDate;
                    object averageDateValue = averageRow["Date"];
                    bool hasAverageDate = averageDateValue != DBNull.Value && averageDateValue is DateTime;
                    if (hasAverageDate)
                    {
                        averageDate = ((DateTime)averageDateValue).Date;
                    }
                    else
                    {
                        hasAverageDate = TryParseBillingDate(Convert.ToString(averageDateValue), out averageDate);
                    }

                    if (hasAverageDate)
                        averages[BuildAverageFteKey(averageDate, Convert.ToString(averageRow["ProcessName"]))] = averageRow;
                }
            }

            int serialNumber = 1;
            foreach (DataRow sourceRow in source.Rows)
            {
                DataRow row = result.NewRow();
                DateTime workDate;
                bool hasDate = TryParseBillingDate(GetDataRowText(sourceRow, "Date"), out workDate);
                string target = GetDataRowText(sourceRow, "AssignTarget");
                string invoices = GetDataRowText(sourceRow, "TotalInvoices");
                bool isHoliday = string.Equals(target, "Holiday", StringComparison.OrdinalIgnoreCase)
                    || string.Equals(invoices, "Holiday", StringComparison.OrdinalIgnoreCase);

                row["S.No"] = serialNumber++;
                row["Date"] = hasDate ? workDate.ToString("d-MMM-yy", CultureInfo.InvariantCulture) : GetDataRowText(sourceRow, "Date");
                row["Target Assigned"] = isHoliday ? "Holiday" : target;
                row["Total invoices"] = isHoliday ? "Holiday" : FormatBillingCount(invoices);

                DataRow averageRow;
                string key = hasDate ? BuildAverageFteKey(workDate, GetDataRowText(sourceRow, "Process")) : string.Empty;
                if (isHoliday)
                {
                    row["Average FTE"] = "Holiday";
                    row["Billed FTE"] = "Holiday";
                }
                else if (averages.TryGetValue(key, out averageRow) && averageRow["AverageFTE"] != DBNull.Value)
                {
                    decimal averageFte = Convert.ToDecimal(averageRow["AverageFTE"]);
                    row["Average FTE"] = averageFte.ToString("0.00", CultureInfo.InvariantCulture);
                    row["Billed FTE"] = Convert.ToDecimal(averageRow["BilledFTE"]).ToString("0", CultureInfo.InvariantCulture);
                }

                result.Rows.Add(row);
            }
            return result;
        }

        private static DataTable GetAverageFteBillingDetails(int projectID, string billingPeriod)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetFTEAverageBillingData");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 10, ParameterDirection.Input, projectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", SqlDbType.NVarChar, 500, ParameterDirection.Input, billingPeriod);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        private static string BuildAverageFteKey(DateTime date, string processName)
        {
            return date.ToString("yyyyMMdd", CultureInfo.InvariantCulture) + "|" + Convert.ToString(processName).Trim();
        }

        private static string GetDataRowText(DataRow row, string columnName)
        {
            return row != null && row.Table.Columns.Contains(columnName) ? Convert.ToString(row[columnName]) : string.Empty;
        }

        private static string FormatBillingCount(string value)
        {
            decimal number;
            return decimal.TryParse(value, out number) ? number.ToString("0.##", CultureInfo.InvariantCulture) : value;
        }

        private static string GetBillingMonthTitle(string billingPeriod)
        {
            string[] parts = Convert.ToString(billingPeriod).Split('~');
            DateTime fromDate;
            return parts.Length > 0 && TryParseBillingDate(parts[0], out fromDate)
                ? fromDate.ToString("MMM-yy", CultureInfo.InvariantCulture)
                : string.Empty;
        }

        private static Dictionary<string, object> BuildSummary(int projectID, string normalizedPeriod, DataTable dt)
        {
            Dictionary<string, object> summary = new Dictionary<string, object>();
            decimal billableHours = ToDecimal(GetBillableHoursFTE(projectID));
            decimal approvedFte = ToDecimal(GetApprovedFTECount(projectID));
            int rowCount = dt == null ? 0 : dt.Rows.Count;

            summary["RecordCount"] = rowCount;
            summary["BillableHours"] = billableHours == 0 ? "-" : FormatDecimal(billableHours);
            summary["AverageBilledFTE"] = "-";
            summary["WorkingHours"] = "-";
            summary["TotalFTEHours"] = "-";
            summary["InvoiceCount"] = "-";
            summary["TimeMins"] = "-";
            summary["TimeHrs"] = "-";

            if (dt == null || dt.Rows.Count == 0)
            {
                return summary;
            }

            if (projectID == 184 || projectID == 205)
            {
                List<decimal> billedFteValues = GetNumericValues(dt, "BilledFTE", true).Distinct().ToList();
                int monthCount = CountNonHolidayRows(dt, "BilledFTE");
                decimal average = billedFteValues.Count == 0 ? 0 : billedFteValues.Average();
                if (projectID == 205 && normalizedPeriod == "01-Oct-2022 ~ 31-Oct-2022")
                {
                    average = 7.22M;
                }

                decimal workingHours = billableHours * monthCount;
                summary["AverageBilledFTE"] = FormatDecimal(average, projectID == 205 ? 3 : 2);
                summary["WorkingHours"] = FormatDecimal(workingHours);
                summary["TotalFTEHours"] = FormatDecimal(Math.Round(average, 2) * workingHours);
                return summary;
            }

            if (projectID == 87)
            {
                summary["InvoiceCount"] = FormatDecimal(SumColumn(dt, "# of Invoices"));
                summary["TimeMins"] = FormatDecimal(SumColumn(dt, "Time Spent (Mins)"));
                summary["TimeHrs"] = FormatDecimal(SumColumn(dt, "Total Time Spent (Hrs)"));
                return summary;
            }

            if (IsHoursProject(projectID))
            {
                string hoursColumn = projectID == 203 || projectID == 400 ? "Auditor1 (Hours)" : "Operator1(Hours)";
                decimal workingHours = projectID == 584
                    ? SumColumn(dt, hoursColumn)
                    : billableHours * CountNonHolidayRows(dt, hoursColumn);
                decimal totalFteHours = approvedFte * workingHours;

                totalFteHours = ApplyProjectHourOverride(projectID, normalizedPeriod, totalFteHours);
                totalFteHours += GetExtraFteTotalHours(projectID, normalizedPeriod);
                summary["WorkingHours"] = FormatDecimal(workingHours);
                summary["TotalFTEHours"] = FormatDecimal(totalFteHours);
                return summary;
            }

            summary["BillableHours"] = billableHours == 0 ? "8" : FormatDecimal(billableHours);
            summary["WorkingHours"] = Convert.ToString(rowCount);
            summary["TotalFTEHours"] = "P / A / AL / HD";
            return summary;
        }

        private static bool IsHoursProject(int projectID)
        {
            return projectID == 203 || projectID == 400 || projectID == 373 || projectID == 385 || projectID == 442 || projectID == 531 || projectID == 584;
        }

        private static decimal ApplyProjectHourOverride(int projectID, string period, decimal fallback)
        {
            if (projectID == 203 && period == "01-Mar-2022 ~ 31-Mar-2022") return 738;
            if (projectID == 203 && period == "01-Sep-2022 ~ 30-Sep-2022") return 1080;
            if (projectID == 400 && period == "01-Sep-2022 ~ 30-Sep-2022") return 972;
            if (projectID == 385 && period == "01-Jul-2022 ~ 31-Jul-2022") return 1350;
            if (projectID == 385 && period == "01-Nov-2022 ~ 30-Nov-2022") return 1773;
            if (projectID == 385 && period == "01-May-2023 ~ 31-May-2023") return 2583;
            if (projectID == 385 && period == "01-Jul-2023 ~ 31-Jul-2023") return 1710;
            if (projectID == 385 && period == "01-Feb-2024 ~ 29-Feb-2024") return 621;
            if (projectID == 385 && period == "01-Jun-2024 ~ 30-Jun-2024") return 549;
            if (projectID == 385 && period == "01-Jul-2024 ~ 31-Jul-2024") return 603;
            if (projectID == 385 && period == "01-Aug-2024 ~ 31-Aug-2024") return 630;
            if (projectID == 385 && period == "01-Oct-2024 ~ 31-Oct-2024") return 657;
            if (projectID == 385 && period == "01-Nov-2024 ~ 30-Nov-2024") return 549;
            if (projectID == 385 && period == "01-Dec-2024 ~ 31-Dec-2024") return 612;
            if (projectID == 385 && period == "01-Jan-2025 ~ 31-Jan-2025") return 630;
            if (projectID == 385 && period == "01-Feb-2025 ~ 28-Feb-2025") return 576;
            if (projectID == 531 && period == "01-May-2023 ~ 31-May-2023") return 387;
            if (projectID == 531 && period == "01-Jun-2025 ~ 30-Jun-2025") return 351;
            return fallback;
        }



        private static void AppendExtraFteOperatorColumns(DataTable dt, int projectID, string billingPeriod)
        {
            if (dt == null || dt.Rows.Count == 0)
            {
                return;
            }

            DataTable extra = GetExtraFteDetails(projectID, billingPeriod);
            if (extra == null || extra.Rows.Count == 0)
            {
                return;
            }

            int maxOperator = extra.AsEnumerable().Select(r => Convert.ToInt32(r["ExtraOperatorNo"])).DefaultIfEmpty().Max();
            for (int i = 1; i <= maxOperator; i++)
            {
                string columnName = "Extra Operator " + i + " (Hours)";
                if (!dt.Columns.Contains(columnName))
                {
                    dt.Columns.Add(columnName);
                }
            }

            string dateColumn = dt.Columns.Contains("Date") ? "Date" : string.Empty;
            if (string.IsNullOrEmpty(dateColumn))
            {
                return;
            }

            foreach (DataRow billingRow in dt.Rows)
            {
                DateTime billingDate;
                if (!TryParseBillingDate(Convert.ToString(billingRow[dateColumn]), out billingDate))
                {
                    continue;
                }

                foreach (DataRow extraRow in extra.AsEnumerable().Where(r => Convert.ToDateTime(r["WorkDate"]).Date == billingDate.Date))
                {
                    int operatorNo = Convert.ToInt32(extraRow["ExtraOperatorNo"]);
                    decimal hours = ToDecimal(Convert.ToString(extraRow["Hours"]));
                    billingRow["Extra Operator " + operatorNo + " (Hours)"] = FormatHoursText(hours);
                }
            }
        }

        private static DataTable GetExtraFteDetails(int projectID, string billingPeriod)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetFTEBillingExtraOperators");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 10, ParameterDirection.Input, projectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", SqlDbType.NVarChar, 500, ParameterDirection.Input, billingPeriod);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        private static decimal GetExtraFteTotalHours(int projectID, string billingPeriod)
        {
            DataTable extra = GetExtraFteDetails(projectID, billingPeriod);
            if (extra == null || extra.Rows.Count == 0 || !extra.Columns.Contains("Hours"))
            {
                return 0;
            }

            return extra.AsEnumerable().Sum(r => ToDecimal(Convert.ToString(r["Hours"])));
        }

        private static DataTable BuildExtraFteSaveTable(List<ExtraFteEntry> entries)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("WorkDate", typeof(DateTime));
            dt.Columns.Add("ExtraOperatorNo", typeof(int));
            dt.Columns.Add("Hours", typeof(decimal));

            foreach (ExtraFteEntry entry in entries ?? new List<ExtraFteEntry>())
            {
                DateTime workDate;
                if (!TryParseBillingDate(entry.WorkDateText, out workDate))
                {
                    continue;
                }

                if (entry.ExtraOperatorNo <= 0 || entry.Hours < 0 || entry.Hours > 24)
                {
                    continue;
                }

                DataRow row = dt.NewRow();
                row["WorkDate"] = workDate.Date;
                row["ExtraOperatorNo"] = entry.ExtraOperatorNo;
                row["Hours"] = entry.Hours;
                dt.Rows.Add(row);
            }

            return dt;
        }

        private static bool TryParseBillingDate(string text, out DateTime value)
        {
            string input = Convert.ToString(text).Trim();
            string[] formats = { "dd-MMM-yyyy", "d-MMM-yyyy", "dd-MMM-yy", "d-MMM-yy", "dd/MM/yyyy", "MM/dd/yyyy" };
            return DateTime.TryParseExact(input, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out value)
                || DateTime.TryParse(input, CultureInfo.InvariantCulture, DateTimeStyles.None, out value)
                || DateTime.TryParse(input, out value);
        }

        private static string FormatHoursText(decimal hours)
        {
            int wholeHours = Convert.ToInt32(Math.Floor(hours));
            int minutes = Convert.ToInt32(Math.Round((hours - wholeHours) * 60, 0));
            return string.Format("{0:00}:{1:00}:00", wholeHours, minutes);
        }

        private static DataTable GetBillingDetails(int projectID, string billingPeriod)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetFETBillingData");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 10, ParameterDirection.Input, projectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", SqlDbType.NVarChar, 500, ParameterDirection.Input, billingPeriod);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        private static DataTable GetBillingAttendance(int projectID, string billingPeriod)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetFETBillingAttendance");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.Int, 10, ParameterDirection.Input, projectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", SqlDbType.NVarChar, 500, ParameterDirection.Input, billingPeriod);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        private static string GetBillableHoursFTE(int projectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_getBillableHours_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.BigInt, 0, ParameterDirection.Input, projectID);
            return Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
        }

        private static string GetApprovedFTECount(int projectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_getApprovedFTECount");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.BigInt, 0, ParameterDirection.Input, projectID);
            return Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
        }

        private static int GetDueDaysByProject(int projectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "WBT_usp_getDueDaysByProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", SqlDbType.NVarChar, 500, ParameterDirection.Input, Convert.ToString(projectID));
            object result = SQLHelper.ExecuteScalarCmd(cmd);
            int dueDays;
            return int.TryParse(Convert.ToString(result), out dueDays) ? dueDays : 0;
        }

        private static int UpdateBillingFlag(int projectID, string period, string billingCycle, int billingBy, string productionBillingDate, string billingDate, bool isDelay, string remark, string billingStatus)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_SendFTEBilling");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.BigInt, 0, ParameterDirection.Input, projectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", SqlDbType.NVarChar, 1000, ParameterDirection.Input, period);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingCycle", SqlDbType.NVarChar, 4000, ParameterDirection.Input, billingCycle);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingBy", SqlDbType.BigInt, 0, ParameterDirection.Input, billingBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductionBillingDate", SqlDbType.NVarChar, 1000, ParameterDirection.Input, productionBillingDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingDate", SqlDbType.NVarChar, 1000, ParameterDirection.Input, billingDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsDelay", SqlDbType.Bit, 10, ParameterDirection.Input, isDelay);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", SqlDbType.NVarChar, 4000, ParameterDirection.Input, remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingStatus", SqlDbType.NVarChar, 4000, ParameterDirection.Input, billingStatus);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
        }

        private static string WriteBillingExcelFile(string projectName, string billingPeriod, string reportName, DataTable data, bool useAverageFteLayout)
        {
            string root = HttpContext.Current.Server.MapPath("~/WBT/Billing/");
            string folder = Path.Combine(root, CleanFileName(projectName), CleanFileName(billingPeriod));
            Directory.CreateDirectory(folder);

            string fileName = CleanFileName(projectName + " - " + reportName + " - " + billingPeriod) + ".xls";
            string filePath = Path.Combine(folder, fileName);

            StringBuilder html = new StringBuilder();
            html.Append("<html><head><meta charset=\"utf-8\" /></head><body><table border=\"1\" style=\"border-collapse:collapse;\">");
            if (useAverageFteLayout)
            {
                html.Append("<tr><th colspan=\"6\" style=\"background:#d9d9d9;text-align:center;font-weight:bold;\">");
                html.Append(HttpUtility.HtmlEncode(GetBillingMonthTitle(NormalizePeriod(billingPeriod))));
                html.Append("</th></tr>");
            }
            html.Append("<thead><tr>");

            foreach (DataColumn column in data.Columns)
            {
                html.Append("<th style=\"background:#87ceeb;font-weight:bold;\">");
                html.Append(HttpUtility.HtmlEncode(column.Caption));
                html.Append("</th>");
            }

            html.Append("</tr></thead><tbody>");

            foreach (DataRow row in data.Rows)
            {
                html.Append("<tr>");
                foreach (DataColumn column in data.Columns)
                {
                    html.Append("<td>");
                    html.Append(HttpUtility.HtmlEncode(Convert.ToString(row[column])));
                    html.Append("</td>");
                }
                html.Append("</tr>");
            }

            html.Append("</tbody></table></body></html>");
            File.WriteAllText(filePath, html.ToString(), Encoding.UTF8);
            return filePath;
        }

        private static void SendBillingMail(int projectID, string subject, string body, string billingFile, string attendanceFile)
        {
            string to = "n.prasad@infinityinternationals.us";
            string cc = string.Empty;

            if (projectID == 184 || projectID == 203 || projectID == 205 || projectID == 87)
            {
                to = "m.austin@infinity-data.com";
                cc = "n.prasad@infinityinternationals.us";
            }
            else if (projectID == 123 || projectID == 354)
            {
                to = "bryan@infinityinternationals.us";
                cc = "n.prasad@infinityinternationals.us";
            }

            using (MailMessage mail = new MailMessage())
            {
                mail.To.Add(to);
                if (!string.IsNullOrWhiteSpace(cc))
                {
                    mail.CC.Add(cc);
                }

                mail.Bcc.Add("n.nilkanth@infinityinternationals.us");
                mail.From = new MailAddress("ack@infinity-data.com", "FTE Billing", Encoding.UTF8);
                mail.Subject = subject;
                mail.SubjectEncoding = Encoding.UTF8;
                mail.Body = body;
                mail.BodyEncoding = Encoding.UTF8;
                mail.IsBodyHtml = true;
                mail.Priority = MailPriority.High;

                if (!string.IsNullOrWhiteSpace(billingFile) && File.Exists(billingFile))
                {
                    mail.Attachments.Add(new Attachment(billingFile));
                }

                if (!string.IsNullOrWhiteSpace(attendanceFile) && File.Exists(attendanceFile))
                {
                    mail.Attachments.Add(new Attachment(attendanceFile));
                }

                SmtpClient client = new SmtpClient();
                client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", GetPassword("ack"));
                client.Host = "smtpcorp.netcore.co.in";
                client.Send(mail);
            }
        }

        private static string BuildBillingEmailBody(string projectName, string billingPeriod, BillingReportResult report, DataTable data)
        {
            Dictionary<string, object> summary = report.Summary ?? new Dictionary<string, object>();
            StringBuilder html = new StringBuilder();
            html.Append("<html><body>");
            html.Append("<br /><font color=\"brown\" face=\"Verdana\" size=\"2\"><b>Please collect billing details of ");
            html.Append(HttpUtility.HtmlEncode(projectName));
            html.Append(" - FTE project through ERP Software. ");
            html.Append(HttpUtility.HtmlEncode(billingPeriod));
            html.Append(".</b></font><br />");
            html.Append("<br /><table border=\"1\" bordercolor=\"Black\" style=\"border:solid 1px black;border-collapse:collapse;padding:3px;font-size:14px;\">");
            html.Append("<tr style=\"background-color:Skyblue;color:Black;\"><td colspan=\"5\"><center><b>");
            html.Append(HttpUtility.HtmlEncode(projectName));
            html.Append(" - FTE Client Billing - ");
            html.Append(HttpUtility.HtmlEncode(billingPeriod));
            html.Append("</b></center></td></tr>");
            html.Append("<tr style=\"background-color:Skyblue;color:Black;\"><td><b>Project #</b></td><td><b>Records</b></td><td><b>Billable Hours</b></td><td><b>Working Hours</b></td><td><b>Total FTE Hours</b></td></tr>");
            html.Append("<tr><td><b>");
            html.Append(HttpUtility.HtmlEncode(projectName));
            html.Append("</b></td><td><b>");
            html.Append(GetSummary(summary, "RecordCount"));
            html.Append("</b></td><td><b>");
            html.Append(GetSummary(summary, "BillableHours"));
            html.Append("</b></td><td><b>");
            html.Append(GetSummary(summary, "WorkingHours"));
            html.Append("</b></td><td><b>");
            html.Append(GetSummary(summary, "TotalFTEHours"));
            html.Append("</b></td></tr></table>");
            html.Append("<br /><br /><table width=\"650px\" style=\"font-size:13px;\"><tr><td align=\"left\">Thanks,<br />Infinity</td></tr><tr><td align=\"center\"><b>!!! This is software generated e-mail...Please do not reply. !!!</b></td></tr></table>");
            html.Append("</body></html>");
            return html.ToString();
        }

        private static BillingDelayInfo GetBillingDelayInfo(int projectID, string billingPeriod)
        {
            BillingDelayInfo info = new BillingDelayInfo();

            try
            {
                int dueDays = GetDueDaysByProject(projectID);
                string[] dates = NormalizePeriod(billingPeriod).Split('~');
                if (dates.Length == 2)
                {
                    DateTime toDate;
                    if (DateTime.TryParse(dates[1].Trim(), out toDate))
                    {
                        DateTime productionDate = toDate.AddDays(dueDays);
                        info.ProductionBillingDate = productionDate.ToString("dd-MMM-yyyy");
                        info.IsDelay = productionDate < DateTime.Now;
                    }
                }
            }
            catch
            {
                info.ProductionBillingDate = string.Empty;
                info.IsDelay = false;
            }

            return info;
        }

        private static string GetPassword(string username)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetEmailPassword");
            SQLHelper.AddParamToSQLCmd(cmd, "@Username", SqlDbType.NVarChar, 100, ParameterDirection.Input, username);
            return Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
        }

        private static string NormalizePeriod(string billingPeriod)
        {
            return Convert.ToString(billingPeriod).Replace(" to ", " ~ ").Replace("to", "~").Trim();
        }

        private static string CleanFileName(string value)
        {
            string text = string.IsNullOrWhiteSpace(value) ? "FTE Billing" : value;
            foreach (char invalid in Path.GetInvalidFileNameChars())
            {
                text = text.Replace(invalid, '_');
            }
            return text;
        }

        private static int GetCurrentEmployeeId()
        {
            int employeeId;
            return int.TryParse(HttpContext.Current.User.Identity.Name, out employeeId) ? employeeId : 0;
        }

        private static object GetSummary(Dictionary<string, object> summary, string key)
        {
            return summary != null && summary.ContainsKey(key) ? summary[key] : "-";
        }

        private static int CountNonHolidayRows(DataTable dt, string columnName)
        {
            if (dt == null || !dt.Columns.Contains(columnName))
            {
                return 0;
            }

            return dt.AsEnumerable().Count(r =>
            {
                string value = Convert.ToString(r[columnName]);
                return !string.IsNullOrWhiteSpace(value) && !string.Equals(value, "Holiday", StringComparison.OrdinalIgnoreCase);
            });
        }

        private static decimal SumColumn(DataTable dt, string columnName)
        {
            return GetNumericValues(dt, columnName, true).Sum();
        }

        private static List<decimal> GetNumericValues(DataTable dt, string columnName, bool skipHoliday)
        {
            List<decimal> values = new List<decimal>();

            if (dt == null || !dt.Columns.Contains(columnName))
            {
                return values;
            }

            foreach (DataRow row in dt.Rows)
            {
                string text = Convert.ToString(row[columnName]);
                if (skipHoliday && string.Equals(text, "Holiday", StringComparison.OrdinalIgnoreCase))
                {
                    continue;
                }

                text = text.Replace(":00:00", string.Empty);
                decimal value;
                if (decimal.TryParse(text, out value))
                {
                    values.Add(value);
                }
            }

            return values;
        }

        private static decimal ToDecimal(string text)
        {
            decimal value;
            return decimal.TryParse(Convert.ToString(text), out value) ? value : 0;
        }

        private static string FormatDecimal(decimal value, int decimals = 2)
        {
            return decimal.Round(value, decimals).ToString("0." + new string('#', decimals));
        }

        private static string Serialize(DataTable dt)
        {
            return SerializeObject(DataTableToDictionaryList(dt));
        }

        private static string SerializeObject(object value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(value);
        }

        private static List<Dictionary<string, object>> DataTableToDictionaryList(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt == null)
            {
                return rows;
            }

            foreach (DataRow dr in dt.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }

            return rows;
        }

        private static DataTable DictionaryListToDataTable(List<Dictionary<string, object>> rows)
        {
            DataTable dt = new DataTable();

            if (rows == null || rows.Count == 0)
            {
                return dt;
            }

            foreach (string key in rows[0].Keys)
            {
                dt.Columns.Add(key);
            }

            foreach (Dictionary<string, object> row in rows)
            {
                DataRow dataRow = dt.NewRow();
                foreach (string key in row.Keys)
                {
                    dataRow[key] = row[key] == null ? string.Empty : Convert.ToString(row[key]);
                }
                dt.Rows.Add(dataRow);
            }

            return dt;
        }

        private class ExtraFteEntry
        {
            public string WorkDateText { get; set; }
            public int ExtraOperatorNo { get; set; }
            public decimal Hours { get; set; }
        }

        private class BillingReportResult
        {
            public List<Dictionary<string, object>> Rows { get; set; }
            public Dictionary<string, object> Summary { get; set; }
            public int RecordCount { get; set; }
            public string ReportTitle { get; set; }
        }

        private class BillingActionResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
        }

        private class BillingDelayInfo
        {
            public string ProductionBillingDate { get; set; }
            public bool IsDelay { get; set; }
        }
    }
}
