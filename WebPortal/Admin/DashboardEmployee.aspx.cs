using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class DashboardEmployee : System.Web.UI.Page
    {
        public static string user_name;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["LoginTime"] == null)
            {
                Session["LoginTime"] = DateTime.Now.Ticks.ToString();
            }
        }


        [WebMethod]
        public static string BindInformation()
        {
            DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            user_name = Convert.ToString(dt1.Rows[0]["FirstName"]);

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetDashboardAlerts()
        {
            DataTable dt1 = new bllMaster().GetAllReadUnreradDashboardAlert();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetDashboardProjectAlerts()
        {
            DataTable dt1 = new bllMaster().GetAllOSTNotifications();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string BindExistingInformation()
        {
            DataTable dt1 = new bllMaster().GetEmployeeVerificationData(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string BindAlertDetails(int AlertId)
        {
            DataTable dt1 = new bllMaster().GetDashboardAlertById(AlertId);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string CurrentManpowerSummary(string Type)
        {
            DataTable dt1 = new bllMaster().GetCurrentManpowerSummary(Type);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string CurrentManpowerSummaryDetails(string Type, int Branch, int Domain, string Subdomain, int Criteria)
        {
            DataTable dt1 = new bllMaster().GetCurrentManpowerSummaryDetails(Type, Branch, Domain, Subdomain, Criteria);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetPendingTask()
        {
            DataTable dt1 = new bllMaster().GetAllNotificationsByUserForDashboard(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetTodayBirthdays()
        {
            DataTable dt1 = new bllMaster().GetBirthdayList();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static void SendWish(string toUserId, string message)
        {
            new bllMaster().InsertBirthdayMessage(message, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), toUserId);

            // Insert into BirthdayWishes table
        }

        [WebMethod]
        public static object CheckBirthday()
        {
            DataTable dt = new bllMaster().GetTodaysBirthday();

            if (dt.Rows.Count > 0)
            {
                return new
                {
                    IsBirthday = true,
                    Name = dt.Rows[0]["Name"].ToString()
                };
            }

            return new { IsBirthday = false };

        }

        [WebMethod]
        public static int UpdateProjectReadAlertStatus(int AlertID)
        {
            int returnvalue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("AlertID", AlertID);
            htParam.Add("EmployeeID", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().UpdateProjectAlertReadStatus(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static string InsertDashboardTour(string IsCheck)
        {
            int returnvalue = 0;
            string status = "";

            returnvalue = new bllMaster().InsertDashboardTour(IsCheck);

            if (returnvalue > 0)
                status = "completed";
            else if (returnvalue == -2)
                status = "show";
            else
                status = "error";

            return status;
        }

        [WebMethod]
        public static string GetProductiveEmployeeInsightDetails(string RangeType)
        {
            int employeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DateTime today = DateTime.Today;
            DateTime fromDate;
            DateTime toDate = today;
            string rangeMessage = "";
            string selectedRange = string.IsNullOrWhiteSpace(RangeType) ? "Last12Months" : RangeType;

            switch (selectedRange)
            {
                case "LatestIncrement":
                    if (!TryGetLatestIncrementEffectiveDate(employeeId, today, out fromDate))
                    {
                        if (!TryGetEmployeeJoiningDate(employeeId, out fromDate))
                            fromDate = today.AddYears(-1).AddDays(1);

                        rangeMessage = "No increment records found, so the report is being shown from the date of joining (" +
                            fromDate.ToString("dd-MMM-yyyy") + ").";
                    }
                    break;

                case "CurrentMonth":
                    fromDate = new DateTime(today.Year, today.Month, 26).AddMonths(-1);
                    toDate = new DateTime(today.Year, today.Month, 25);

                    if (toDate > today)
                        toDate = today;
                    break;

                default:
                    selectedRange = "Last12Months";
                    fromDate = today.AddYears(-1).AddDays(1);
                    break;
            }

            if (fromDate > toDate)
                fromDate = toDate;

            string fromDateText = fromDate.ToString("dd-MMM-yyyy");
            string toDateText = toDate.ToString("dd-MMM-yyyy");
            bllMaster master = new bllMaster();
            string code = master.GetCodeFromEmployeeId(employeeId);

            if (string.IsNullOrWhiteSpace(code))
                code = Convert.ToString(employeeId);

            DataTable productionDetails = master.GetProductiveEmployeePerformanceLast12Months(employeeId, fromDateText, toDateText);

            Hashtable htParam = new Hashtable();
            htParam.Add("UserCode", employeeId);
            htParam.Add("FromDate", fromDateText);
            htParam.Add("ToDate", toDateText);

            DataTable attendanceDetails = master.GetDetailedAttendancePercentageForDashboard(htParam);

            if (selectedRange == "CurrentMonth" && (attendanceDetails == null || attendanceDetails.Rows.Count == 0))
            {
                attendanceDetails = GetCurrentAttendanceFromSalaryDetail(code, fromDate, toDate);

                if (attendanceDetails.Rows.Count > 0)
                    rangeMessage = "Salary calculation is not completed. Attendance is calculated from infinityus.dbo.Salary_Detail.";
                else
                    rangeMessage = "Salary calculation is not completed and no Salary_Detail records were found for this period.";
            }

            Dictionary<string, object> result = new Dictionary<string, object>();
            result.Add("production", GetMonthlyProductionRows(productionDetails, 0));
            result.Add("attendance", DataTableToList(attendanceDetails));
            result.Add("selectedRange", selectedRange);
            result.Add("fromDate", fromDateText);
            result.Add("toDate", toDateText);
            result.Add("periodLabel", fromDateText + " to " + toDateText);
            result.Add("rangeMessage", rangeMessage);

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(result);
        }

        private static DataTable GetCurrentAttendanceFromSalaryDetail(string code, DateTime fromDate, DateTime toDate)
        {
            DataSet ds = new DataSet();

            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = con.CreateCommand())
            {
                cmd.CommandText = @"
SELECT WH.WorkingHours, NU.Log_Late, E.JoiningDate
FROM dbo.EmployeeInfo E
LEFT JOIN dbo.WorkingHours WH ON WH.WorkingHoursID = E.WorkingHours
LEFT JOIN infinityus.dbo.New_User NU ON NU.Code = E.Code
WHERE E.Code = @Code;

SELECT DISTINCT [Date], P_Day, Let_Mark, Remark, Hours
FROM infinityus.dbo.Salary_Detail
WHERE User_Code = @Code
  AND CAST([Date] AS DATETIME) BETWEEN @FromDate AND @ToDate
ORDER BY CAST([Date] AS DATETIME);";
                cmd.Parameters.Add("@Code", SqlDbType.NVarChar, 10).Value = code;
                cmd.Parameters.Add("@FromDate", SqlDbType.DateTime).Value = fromDate;
                cmd.Parameters.Add("@ToDate", SqlDbType.DateTime).Value = toDate;

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    con.Open();
                    da.Fill(ds);
                }
            }

            DataTable result = CreateAttendanceResultTable();

            if (ds.Tables.Count < 2 || ds.Tables[1].Rows.Count == 0)
                return result;

            DataTable employeeConfig = ds.Tables[0];
            DataTable salaryDetails = ds.Tables[1];
            DateTime calculationFromDate = fromDate;
            int requiredMinutes = 480;
            bool deductLateMarks = false;

            if (employeeConfig.Rows.Count > 0)
            {
                int configuredMinutes = ParseHoursToMinutes(Convert.ToString(employeeConfig.Rows[0]["WorkingHours"]));

                if (configuredMinutes > 0)
                    requiredMinutes = configuredMinutes;

                deductLateMarks = string.Equals(
                    Convert.ToString(employeeConfig.Rows[0]["Log_Late"]).Trim(),
                    "Allow Late Mark",
                    StringComparison.OrdinalIgnoreCase);

                DateTime joiningDate;

                if (DateTime.TryParse(Convert.ToString(employeeConfig.Rows[0]["JoiningDate"]), out joiningDate) &&
                    joiningDate.Date > calculationFromDate)
                    calculationFromDate = joiningDate.Date;
            }

            int totalCalendarDays = Math.Max(1, (toDate.Date - calculationFromDate.Date).Days + 1);
            int workingDayRecords = 0;
            int absentDays = 0;
            int partialDayCount = 0;
            int lateMarks = 0;
            int removedLateMarks = 0;
            decimal fullDays = 0;
            decimal partialPresentDays = 0;

            foreach (DataRow row in salaryDetails.Rows)
            {
                string remark = Convert.ToString(row["Remark"]).Trim();
                string lateMark = Convert.ToString(row["Let_Mark"]).Trim();

                if (lateMark == "1")
                    lateMarks++;
                else if (lateMark == "0")
                    removedLateMarks++;

                if (string.Equals(remark, "Holiday", StringComparison.OrdinalIgnoreCase))
                    continue;

                workingDayRecords++;

                if (string.Equals(remark, "Absent", StringComparison.OrdinalIgnoreCase))
                {
                    absentDays++;
                    continue;
                }

                if (IsSalaryDetailFlagSet(row["P_Day"]))
                {
                    partialDayCount++;
                    int workedMinutes = ParseHoursToMinutes(Convert.ToString(row["Hours"]));
                    partialPresentDays += Math.Min(1, TruncateDecimal((decimal)workedMinutes / requiredMinutes, 2));
                }
                else
                {
                    fullDays++;
                }
            }

            decimal partialAbsentDays = Math.Max(0, partialDayCount - partialPresentDays);
            decimal nonWorkingDays = Math.Max(0, totalCalendarDays - workingDayRecords);
            decimal lateMarkDays = deductLateMarks
                ? (lateMarks / 3) + (lateMarks % 3 == 2 ? 0.5m : 0)
                : 0;
            decimal salaryPresentDays = Math.Max(0, Math.Min(totalCalendarDays, nonWorkingDays + fullDays + partialPresentDays - lateMarkDays));
            decimal totalAbsentDays = absentDays + partialAbsentDays;
            decimal attendancePercentage = TruncateDecimal((salaryPresentDays / totalCalendarDays) * 100, 2);
            decimal workingAttendancePercentage = workingDayRecords == 0
                ? 0
                : TruncateDecimal(((fullDays + partialPresentDays) / workingDayRecords) * 100, 2);

            DataRow resultRow = result.NewRow();
            resultRow["Code"] = code;
            resultRow["Month"] = toDate.ToString("MMMM", CultureInfo.InvariantCulture);
            resultRow["Year"] = toDate.Year.ToString(CultureInfo.InvariantCulture);
            resultRow["TotalCalenderDays"] = totalCalendarDays;
            resultRow["AbsentDays"] = absentDays;
            resultRow["PartialCount"] = partialDayCount;
            resultRow["PartialDays"] = FormatDecimal(partialAbsentDays);
            resultRow["TotalAbsentDays"] = FormatDecimal(totalAbsentDays);
            resultRow["SalaryPresentDays"] = FormatDecimal(salaryPresentDays);
            resultRow["AttendancePercOnTotalDays"] = FormatDecimal(attendancePercentage);
            resultRow["Latemarks"] = lateMarks;
            resultRow["RemovedLatemarks"] = removedLateMarks;
            resultRow["TotalLatemarks"] = lateMarks + removedLateMarks;
            resultRow["TotalWorkingDays"] = workingDayRecords;
            resultRow["AbsentDaysWOWeekOff"] = absentDays;
            resultRow["TotalPartialDays"] = FormatDecimal(partialAbsentDays);
            resultRow["TotalAbsentDaysWOWeeoff"] = FormatDecimal(totalAbsentDays);
            resultRow["AttendancePercOnWorkingDays"] = FormatDecimal(workingAttendancePercentage);
            result.Rows.Add(resultRow);

            return result;
        }

        private static DataTable CreateAttendanceResultTable()
        {
            DataTable table = new DataTable();
            string[] columns =
            {
                "Code", "Month", "Year", "TotalCalenderDays", "AbsentDays", "PartialCount",
                "PartialDays", "TotalAbsentDays", "SalaryPresentDays", "AttendancePercOnTotalDays",
                "Latemarks", "RemovedLatemarks", "TotalLatemarks", "TotalWorkingDays",
                "AbsentDaysWOWeekOff", "TotalPartialDays", "TotalAbsentDaysWOWeeoff",
                "AttendancePercOnWorkingDays"
            };

            foreach (string column in columns)
                table.Columns.Add(column);

            return table;
        }

        private static bool IsSalaryDetailFlagSet(object value)
        {
            string flag = Convert.ToString(value).Trim();
            return flag == "1" || flag.Equals("true", StringComparison.OrdinalIgnoreCase) || flag.Equals("yes", StringComparison.OrdinalIgnoreCase);
        }

        private static int ParseHoursToMinutes(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return 0;

            string[] parts = value.Trim().Split(':');
            int hours;
            int minutes = 0;

            if (!int.TryParse(parts[0], out hours))
                return 0;

            if (parts.Length > 1)
                int.TryParse(parts[1], out minutes);

            return (hours * 60) + minutes;
        }

        private static decimal TruncateDecimal(decimal value, int decimalPlaces)
        {
            decimal factor = (decimal)Math.Pow(10, decimalPlaces);
            return Math.Truncate(value * factor) / factor;
        }

        private static bool TryGetLatestIncrementEffectiveDate(int employeeId, DateTime today, out DateTime effectiveDate)
        {
            effectiveDate = DateTime.MinValue;
            DataTable incrementDetails;

            try
            {
                incrementDetails = new bllSalary().GetEmployeeSalaryIncrementDetailsForLetter(employeeId);
            }
            catch
            {
                return false;
            }

            if (incrementDetails == null)
                return false;

            foreach (DataRow row in incrementDetails.Rows)
            {
                DateTime rowDate;

                if (!TryGetIncrementEffectiveDate(incrementDetails, row, out rowDate))
                    continue;

                if (rowDate <= today && rowDate > effectiveDate)
                    effectiveDate = rowDate;
            }

            return effectiveDate != DateTime.MinValue;
        }

        private static bool TryGetIncrementEffectiveDate(DataTable table, DataRow row, out DateTime effectiveDate)
        {
            effectiveDate = DateTime.MinValue;
            object dateValue = GetValue(table, row, "EffectiveDate", "IncrementDate");
            DateTime parsedDate;

            if (!string.IsNullOrWhiteSpace(Convert.ToString(dateValue)) &&
                DateTime.TryParse(Convert.ToString(dateValue), CultureInfo.InvariantCulture, DateTimeStyles.AllowWhiteSpaces, out parsedDate))
            {
                effectiveDate = new DateTime(parsedDate.Year, parsedDate.Month, 26);
                return true;
            }

            int month = GetMonthNumber(GetValue(table, row, "EffectiveMonth", "Month", "IncrementMonth"));
            int year;

            if (month > 0 &&
                int.TryParse(Convert.ToString(GetValue(table, row, "EffectiveYear", "Year", "IncrementYear")), out year))
            {
                if (year < 100)
                    year += 2000;

                effectiveDate = new DateTime(year, month, 26);
                return true;
            }

            object monthYearValue = GetValue(table, row, "IncrementMonthYear", "EffectiveMonthYear", "IncMonthYear", "MonthYear");

            if (TryParseDashboardMonth(monthYearValue, out parsedDate))
            {
                effectiveDate = new DateTime(parsedDate.Year, parsedDate.Month, 26);
                return true;
            }

            return false;
        }

        private static bool TryGetEmployeeJoiningDate(int employeeId, out DateTime joiningDate)
        {
            joiningDate = DateTime.MinValue;
            DataTable employeeDetails = new bllLogin().GetUserInformation(employeeId);

            if (employeeDetails == null || employeeDetails.Rows.Count == 0 || !employeeDetails.Columns.Contains("JoiningDate"))
                return false;

            return DateTime.TryParse(
                Convert.ToString(employeeDetails.Rows[0]["JoiningDate"]),
                CultureInfo.InvariantCulture,
                DateTimeStyles.AllowWhiteSpaces,
                out joiningDate);
        }

        [WebMethod]
        public static string GetProductionDetails(string Code, string FromDate, string ToDate)
        {
            DataTable dt = new bllMaster().GetProjectProcesswiseProductivity(Code, FromDate, ToDate);

            List<Dictionary<string, object>> rows = DataTableToList(dt);

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }


        [WebMethod]
        public static List<AnniversaryEmployee> GetTodayAnniversaries()
        {
            List<AnniversaryEmployee> list = new List<AnniversaryEmployee>();

            DataTable dt = new bllMaster().GetAllTodayAnniversaries();

            foreach (DataRow dr in dt.Rows)
            {
                list.Add(new AnniversaryEmployee
                {
                    EmployeeId = Convert.ToInt32(dr["EmployeeID"]),
                    EmpName = dr["EmpName"].ToString(),
                    DepartmentName = dr["DepartmentName"].ToString(),
                    //PhotoPath = dr["PhotoPath"].ToString(),
                    YearsCompleted = dr["YearsCompleted"].ToString()
                });
            }
            return list;
        }

        [WebMethod]
        public static List<EmpWorkAnniversary> GetEmpWorkAnniversary()
      {
            List<EmpWorkAnniversary> list = new List<EmpWorkAnniversary>();
            DataTable dt = new bllMaster().GetWorkAnniversary();

            int currentEmployeeId;
            if (!int.TryParse(HttpContext.Current.User.Identity.Name, out currentEmployeeId))
                return list;

            DataTable currentEmployee = new bllLogin().GetUserInformation(currentEmployeeId);
            if (currentEmployee == null || currentEmployee.Rows.Count == 0)
                return list;

            string currentDomain = Convert.ToString(GetValue(currentEmployee, currentEmployee.Rows[0], "Domain", "DomainID")).Trim();
            if (string.IsNullOrWhiteSpace(currentDomain))
                return list;

            foreach (DataRow dr in dt.Rows)
            {
                int anniversaryEmployeeId;
                if (!int.TryParse(Convert.ToString(GetValue(dt, dr, "EmployeeID")), out anniversaryEmployeeId))
                    continue;

                DataTable anniversaryEmployee = new bllLogin().GetUserInformation(anniversaryEmployeeId);
                if (anniversaryEmployee == null || anniversaryEmployee.Rows.Count == 0)
                    continue;

                DataRow employeeRow = anniversaryEmployee.Rows[0];
                string employeeDomain = Convert.ToString(GetValue(anniversaryEmployee, employeeRow, "Domain", "DomainID")).Trim();

                if (!string.Equals(currentDomain, employeeDomain, StringComparison.OrdinalIgnoreCase))
                    continue;

                string joiningDate = FormatAnniversaryDate(GetValue(anniversaryEmployee, employeeRow, "JoiningDate"));

                list.Add(new EmpWorkAnniversary
                {
                    EmployeeId = anniversaryEmployeeId,
                    EmpName = AnniversaryValue(dt, dr, anniversaryEmployee, employeeRow, "EmpName", "EmployeeName", "EmpFullName"),
                    Designation = AnniversaryValue(dt, dr, anniversaryEmployee, employeeRow, "DesignationName", "Designation"),
                    DepartmentName = AnniversaryValue(dt, dr, anniversaryEmployee, employeeRow, "DepartmentName", "Department"),
                    BranchName = AnniversaryValue(dt, dr, anniversaryEmployee, employeeRow, "BranchName", "Branch"),
                    DomainName = AnniversaryValue(dt, dr, anniversaryEmployee, employeeRow, "DomainName"),
                    JoiningDate = joiningDate,
                    ReportingManager = AnniversaryValue(dt, dr, anniversaryEmployee, employeeRow, "ReportingManager", "ProjectManagerName"),
                    YearsCompleted = Convert.ToString(GetValue(dt, dr, "YearsCompleted"))
                });
            }

            return list;
        }

        private static string AnniversaryValue(DataTable anniversaryTable, DataRow anniversaryRow, DataTable employeeTable, DataRow employeeRow, params string[] columnNames)
        {
            string value = Convert.ToString(GetValue(anniversaryTable, anniversaryRow, columnNames)).Trim();
            return string.IsNullOrWhiteSpace(value)
                ? Convert.ToString(GetValue(employeeTable, employeeRow, columnNames)).Trim()
                : value;
        }

        private static string FormatAnniversaryDate(object value)
        {
            DateTime date;
            return DateTime.TryParse(Convert.ToString(value), out date) ? date.ToString("dd MMM yyyy") : Convert.ToString(value);
        }

        [System.Web.Services.WebMethod]
        public static string GetProductiveDashboard()
        {
            int employeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            DateTime today = DateTime.Today;
            DateTime fromDate;
            DateTime toDate;

            if (today.Day >= 26)
            {
                fromDate = new DateTime(today.Year, today.Month, 26);
                toDate = fromDate.AddMonths(1).AddDays(-1);
            }
            else
            {
                toDate = new DateTime(today.Year, today.Month, 25);
                fromDate = toDate.AddMonths(-1).AddDays(1);
            }
            string conStr = SQLHelper.ConnectionString;

            Dictionary<string, object> result = new Dictionary<string, object>();

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("usp_GetProductiveDashboard", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmployeeID", employeeId);
                cmd.Parameters.AddWithValue("@FromDate", fromDate.ToString("dd-MMM-yyyy"));
                cmd.Parameters.AddWithValue("@ToDate", toDate.ToString("dd-MMM-yyyy"));

                con.Open();

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    result["summary"] = DataTableToList(ds.Tables[0]);
                    result["dateWise"] = DataTableToList(ds.Tables[1]);
                    result["processWise"] = DataTableToList(ds.Tables[2]);
                    result["employeeWise"] = DataTableToList(ds.Tables[3]);
                    result["qualityVsProductivity"] = DataTableToList(ds.Tables[4]);
                }
            }

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(result);
        }

        [WebMethod]
        public static string GetReportingManagerDashboard()
        {
            int managerId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            string fromDate = DateTime.Now.AddYears(-1).AddDays(1).ToString("dd-MMM-yyyy");
            string toDate = DateTime.Now.ToString("dd-MMM-yyyy");

            DataTable teamDetails = GetReportingManagerTeamDetails(managerId);
            List<Dictionary<string, object>> teamMembers = new List<Dictionary<string, object>>();
            List<Dictionary<string, object>> alerts = new List<Dictionary<string, object>>();
            Dictionary<string, DashboardReportingTrendRow> productionTrend = new Dictionary<string, DashboardReportingTrendRow>();
            Dictionary<string, DashboardReportingTrendRow> attendanceTrend = new Dictionary<string, DashboardReportingTrendRow>();
            Dictionary<string, object> kpis = new Dictionary<string, object>();
            Dictionary<string, object> result = new Dictionary<string, object>();

            bool isManager = teamDetails != null && teamDetails.Rows.Count > 0;
            result.Add("isManager", isManager);
            result.Add("period", fromDate + " to " + toDate);
            result.Add("teamMembers", teamMembers);
            result.Add("productionTrend", new List<Dictionary<string, object>>());
            result.Add("attendanceTrend", new List<Dictionary<string, object>>());
            result.Add("alerts", alerts);
            result.Add("kpis", kpis);

            if (!isManager)
            {
                JavaScriptSerializer emptySerializer = new JavaScriptSerializer();
                emptySerializer.MaxJsonLength = int.MaxValue;
                return emptySerializer.Serialize(result);
            }

            bllMaster master = new bllMaster();
            int productiveCount = 0;
            int taskBasedCount = 0;
            decimal productionPercTotal = 0;
            int productionPercCount = 0;
            decimal accuracyTotal = 0;
            int accuracyCount = 0;
            decimal attendanceTotal = 0;
            int attendanceCount = 0;
            decimal lateMarksTotal = 0;

            foreach (DataRow employeeRow in teamDetails.Rows)
            {
                string code = Convert.ToString(employeeRow["Code"]);
                string employeeMode = Convert.ToString(employeeRow["EmployeeMode"]);
                bool isProductive = IsReportingProductiveEmployee(employeeMode);
                Dictionary<string, object> member = new Dictionary<string, object>();

                member.Add("EmployeeID", employeeRow["EmployeeID"]);
                member.Add("Code", code);
                member.Add("EmployeeName", employeeRow["EmployeeName"]);
                member.Add("EmployeeMode", employeeMode);
                member.Add("MonthYear", "");
                member.Add("Production", "");
                member.Add("ProductionPerc", "");
                member.Add("Accuracy", "");
                member.Add("ProdGrade", "");
                member.Add("QAGrade", "");
                member.Add("AttendancePerc", "");
                member.Add("LateMarks", "");
                member.Add("FromDateNew", "");
                member.Add("ToDateNew", "");
                member.Add("Status", "");

                if (isProductive)
                {
                    productiveCount++;
                    DataTable productionDetails = GetReportingProductionDetails(master, fromDate, toDate, code);
                    List<Dictionary<string, object>> productionRows = GetLastTwelveMonthlyProductionRows(productionDetails);
                    Dictionary<string, object> latestProduction = GetLatestReportingRow(productionRows, true);

                    foreach (Dictionary<string, object> productionRow in productionRows)
                    {
                        AddReportingProductionTrend(productionTrend, productionRow);

                        decimal rowProductionPerc = ToDecimal(GetDictionaryValue(productionRow, "ProductionPerc"));
                        decimal rowAccuracy = ToDecimal(GetDictionaryValue(productionRow, "Accuracy"));

                        if (rowProductionPerc > 0)
                        {
                            productionPercTotal += rowProductionPerc;
                            productionPercCount++;
                        }

                        if (rowAccuracy > 0)
                        {
                            accuracyTotal += rowAccuracy;
                            accuracyCount++;
                        }
                    }

                    if (latestProduction != null)
                    {
                        member["MonthYear"] = GetDictionaryValue(latestProduction, "MonthYear");
                        member["Production"] = GetDictionaryValue(latestProduction, "Production");
                        member["ProductionPerc"] = GetDictionaryValue(latestProduction, "ProductionPerc");
                        member["Accuracy"] = GetDictionaryValue(latestProduction, "Accuracy");
                        member["ProdGrade"] = GetDictionaryValue(latestProduction, "ProdGrade");
                        member["QAGrade"] = GetDictionaryValue(latestProduction, "QAGrade");
                        member["FromDateNew"] = GetDictionaryValue(latestProduction, "FromDateNew");
                        member["ToDateNew"] = GetDictionaryValue(latestProduction, "ToDateNew");
                    }
                }
                else
                {
                    taskBasedCount++;
                }

                DataTable attendanceDetails = GetReportingAttendanceDetails(master, fromDate, toDate, code);
                List<Dictionary<string, object>> attendanceRows = DataTableToList(attendanceDetails);
                Dictionary<string, object> latestAttendance = GetLatestReportingRow(attendanceRows, false);

                foreach (Dictionary<string, object> attendanceRow in attendanceRows)
                {
                    AddReportingAttendanceTrend(attendanceTrend, attendanceRow);
                }

                if (latestAttendance != null)
                {
                    decimal attendancePerc = ToDecimal(GetDictionaryValue(latestAttendance, "AttendancePercOnTotalDays"));
                    decimal lateMarks = ToDecimal(GetDictionaryValue(latestAttendance, "TotalLatemarks"));

                    member["AttendancePerc"] = GetDictionaryValue(latestAttendance, "AttendancePercOnTotalDays");
                    member["LateMarks"] = GetDictionaryValue(latestAttendance, "TotalLatemarks");

                    if (attendancePerc > 0)
                    {
                        attendanceTotal += attendancePerc;
                        attendanceCount++;
                    }

                    lateMarksTotal += lateMarks;
                }

                ApplyReportingManagerStatus(member, alerts);
                teamMembers.Add(member);
            }

            int pendingApprovals = GetPendingReportingManagerApprovalCount(master, managerId);

            kpis.Add("TeamMembers", teamDetails.Rows.Count);
            kpis.Add("ProductiveMembers", productiveCount);
            kpis.Add("TaskBasedMembers", taskBasedCount);
            kpis.Add("AvgProductionPerc", productionPercCount == 0 ? "" : FormatDecimal(productionPercTotal / productionPercCount));
            kpis.Add("AvgAccuracyPerc", accuracyCount == 0 ? "" : FormatDecimal(accuracyTotal / accuracyCount));
            kpis.Add("AvgAttendancePerc", attendanceCount == 0 ? "" : FormatDecimal(attendanceTotal / attendanceCount));
            kpis.Add("TotalLateMarks", FormatDecimal(lateMarksTotal));
            kpis.Add("PendingApprovals", pendingApprovals);
            kpis.Add("AttentionItems", alerts.Count);

            result["productionTrend"] = BuildReportingProductionTrend(productionTrend);
            result["attendanceTrend"] = BuildReportingAttendanceTrend(attendanceTrend);

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(result);
        }

        private static List<Dictionary<string, object>> DataTableToList(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt == null)
                return rows;

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

        private static List<Dictionary<string, object>> GetLastTwelveMonthlyProductionRows(DataTable dt)
        {
            return GetMonthlyProductionRows(dt, 12);
        }

        private static List<Dictionary<string, object>> GetMonthlyProductionRows(DataTable dt, int maximumRows)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt == null)
                return rows;

            List<DashboardMonthRow> monthRows = new List<DashboardMonthRow>();
            int rowIndex = 0;

            foreach (DataRow dr in dt.Rows)
            {
                DateTime monthDate = DateTime.MinValue;
                bool hasMonthDate = TryGetMonthlyPerformanceDate(dt, dr, out monthDate);

                monthRows.Add(new DashboardMonthRow
                {
                    Row = dr,
                    MonthDate = monthDate,
                    HasMonthDate = hasMonthDate,
                    RowIndex = rowIndex
                });

                rowIndex++;
            }

            IEnumerable<DashboardMonthRow> selectedRows;

            if (monthRows.Any(x => x.HasMonthDate))
            {
                IEnumerable<DashboardMonthRow> orderedRows = monthRows
                    .Where(x => x.HasMonthDate)
                    .OrderByDescending(x => x.MonthDate)
                    .ThenByDescending(x => x.RowIndex);

                if (maximumRows > 0)
                    orderedRows = orderedRows.Take(maximumRows);

                selectedRows = orderedRows
                    .OrderBy(x => x.MonthDate)
                    .ThenBy(x => x.RowIndex);
            }
            else
            {
                selectedRows = maximumRows > 0
                    ? monthRows.Skip(Math.Max(0, monthRows.Count - maximumRows))
                    : monthRows;
            }

            foreach (DashboardMonthRow monthRow in selectedRows)
            {
                rows.Add(BuildMonthlyProductionRow(dt, monthRow.Row, monthRow.HasMonthDate ? monthRow.MonthDate : DateTime.MinValue));
            }

            return rows;
        }

        private static bool TryGetMonthlyPerformanceDate(DataTable dt, DataRow row, out DateTime monthDate)
        {
            monthDate = DateTime.MinValue;

            if (dt.Columns.Contains("Month") && dt.Columns.Contains("Year"))
            {
                int month = GetMonthNumber(row["Month"]);
                int year;

                if (int.TryParse(Convert.ToString(row["Year"]), out year) && month > 0)
                {
                    if (year < 100)
                        year += 2000;

                    monthDate = new DateTime(year, month, 1);
                    return true;
                }
            }

            object monthValue = dt.Columns.Contains("MonthYear") ? row["MonthYear"] : null;
            return TryParseDashboardMonth(monthValue, out monthDate);
        }

        private static Dictionary<string, object> BuildMonthlyProductionRow(DataTable dt, DataRow row, DateTime monthDate)
        {
            Dictionary<string, object> mappedRow = new Dictionary<string, object>();

            string monthYear = GetMonthlyProductionMonthYear(dt, row, monthDate);
            decimal production = ToDecimal(GetValue(dt, row, "LoanCount", "Production", "Production Count", "Count"));
            decimal productionPerc = ToDecimal(GetValue(dt, row, "ProdPerc", "ProductionPerc", "Production %"));
            decimal expectedProductivity = ToDecimal(GetValue(dt, row, "ExpectedProductivity"));

            if (expectedProductivity == 0 && production > 0 && productionPerc > 0)
                expectedProductivity = production / (productionPerc / 100);

            mappedRow.Add("MonthYear", monthYear);
            mappedRow.Add("Code", GetValue(dt, row, "Code"));
            mappedRow.Add("Name", GetValue(dt, row, "EmployeeName", "Name", "Employee"));
            mappedRow.Add("JoiningDate", GetValue(dt, row, "JoiningDate"));
            mappedRow.Add("Tenure", GetValue(dt, row, "TenureFromJoining", "Tenure"));
            mappedRow.Add("DaysWorked", GetValue(dt, row, "TotalWorkingDays", "DaysWorked", "Days Worked"));
            mappedRow.Add("Production", FormatDecimal(production));
            mappedRow.Add("ExpectedProductivity", expectedProductivity > 0 ? FormatDecimal(expectedProductivity) : "");
            mappedRow.Add("AvgTarget", GetValue(dt, row, "AvgTarget", "Avg Target"));
            mappedRow.Add("InternalError", GetValue(dt, row, "InternalError", "Critical"));
            mappedRow.Add("ClientError", GetValue(dt, row, "ClientError", "NonCritical"));
            mappedRow.Add("TotalError", GetValue(dt, row, "TotalError"));
            mappedRow.Add("Appreciations", GetValue(dt, row, "TotalAppreciations", "Appreciations"));
            mappedRow.Add("Warnings", GetValue(dt, row, "TotalWarnings", "Warnings"));
            mappedRow.Add("ProductionPerc", GetValue(dt, row, "ProdPerc", "ProductionPerc", "Production %"));
            mappedRow.Add("Accuracy", GetValue(dt, row, "QualityPerc", "Accuracy", "Accuracy %"));
            mappedRow.Add("Attendance", GetValue(dt, row, "AttPerc", "Attendance", "Attendance %"));
            mappedRow.Add("ProdGrade", GetValue(dt, row, "ProdGrade"));
            mappedRow.Add("QAGrade", GetValue(dt, row, "QualGrade", "QAGrade"));
            mappedRow.Add("AttendanceGrade", GetValue(dt, row, "AttnGrade", "AttendanceGrade"));
            mappedRow.Add("MonthSort", monthDate == DateTime.MinValue ? "" : monthDate.ToString("yyyy-MM"));
            mappedRow.Add("FromDateNew", GetValue(dt, row, "FromDateNew"));
            mappedRow.Add("ToDateNew", GetValue(dt, row, "ToDateNew"));
            mappedRow.Add("Critical", GetValue(dt, row, "Critical"));
            mappedRow.Add("NonCritical", GetValue(dt, row, "NonCritical"));

            return mappedRow;
        }

        private static string GetMonthlyProductionMonthYear(DataTable dt, DataRow row, DateTime monthDate)
        {
            if (dt.Columns.Contains("MonthYear"))
                return Convert.ToString(row["MonthYear"]);

            if (dt.Columns.Contains("Month") && dt.Columns.Contains("Year"))
            {
                int month = GetMonthNumber(row["Month"]);
                string year = Convert.ToString(row["Year"]);

                if (month > 0 && !string.IsNullOrWhiteSpace(year))
                    return CultureInfo.InvariantCulture.DateTimeFormat.GetAbbreviatedMonthName(month) + "-" + year;
            }

            return monthDate == DateTime.MinValue ? "" : monthDate.ToString("MMM-yyyy");
        }

        private static object GetValue(DataTable dt, DataRow row, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
            {
                if (dt.Columns.Contains(columnName))
                    return row[columnName];
            }

            return "";
        }

        private static int GetMonthNumber(object value)
        {
            string monthText = Convert.ToString(value);
            int month;

            if (int.TryParse(monthText, out month) && month >= 1 && month <= 12)
                return month;

            DateTime parsedDate;

            if (DateTime.TryParseExact(monthText, new[] { "MMM", "MMMM" }, CultureInfo.InvariantCulture, DateTimeStyles.AllowWhiteSpaces, out parsedDate) ||
                DateTime.TryParse(monthText, CultureInfo.InvariantCulture, DateTimeStyles.AllowWhiteSpaces, out parsedDate))
                return parsedDate.Month;

            return 0;
        }

        private static decimal ToDecimal(object value)
        {
            string text = Convert.ToString(value);

            if (string.IsNullOrWhiteSpace(text))
                return 0;

            decimal number;
            text = text.Replace(",", "").Replace("%", "").Trim();

            return decimal.TryParse(text, NumberStyles.Any, CultureInfo.InvariantCulture, out number) ? number : 0;
        }

        private static string FormatDecimal(decimal value)
        {
            return value == Math.Truncate(value) ? value.ToString("0", CultureInfo.InvariantCulture) : value.ToString("0.##", CultureInfo.InvariantCulture);
        }

        private static bool TryParseDashboardMonth(object value, out DateTime monthDate)
        {
            monthDate = DateTime.MinValue;
            string monthText = Convert.ToString(value);

            if (string.IsNullOrWhiteSpace(monthText))
                return false;

            monthText = monthText.Trim();
            string normalizedMonthText = monthText.Replace("/", "-").Replace(".", "-");
            string[] formats = {
                "MMM-yyyy",
                "MMMM-yyyy",
                "MMM-yy",
                "MMMM-yy",
                "MMM yyyy",
                "MMMM yyyy",
                "MM-yyyy",
                "M-yyyy",
                "yyyy-MM",
                "yyyy-M",
                "dd-MMM-yyyy",
                "dd-MMMM-yyyy",
                "dd-MM-yyyy",
                "d-M-yyyy"
            };

            DateTime parsedDate;

            if (DateTime.TryParseExact(normalizedMonthText, formats, CultureInfo.InvariantCulture, DateTimeStyles.AllowWhiteSpaces, out parsedDate) ||
                DateTime.TryParse(monthText, CultureInfo.InvariantCulture, DateTimeStyles.AllowWhiteSpaces, out parsedDate))
            {
                monthDate = new DateTime(parsedDate.Year, parsedDate.Month, 1);
                return true;
            }

            return false;
        }

        private static DataTable GetReportingManagerTeamDetails(int managerId)
        {
            DataTable dt = new DataTable();
            string query = @"
                SELECT
                    EmployeeID,
                    Code,
                    LTRIM(RTRIM(ISNULL(FirstName, '') + ' ' + ISNULL(MiddleName, '') + ' ' + ISNULL(LastName, ''))) AS EmployeeName,
                    ISNULL(DailyTaskProductivity, '') AS EmployeeMode
                FROM EmployeeInfo
                WHERE ProjectManager = @ManagerID
                    AND (IsDelete = 0 OR IsDelete IS NULL)
                ORDER BY Code";

            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@ManagerID", managerId);
                da.Fill(dt);
            }

            return dt;
        }

        private static bool IsReportingProductiveEmployee(string employeeMode)
        {
            return Convert.ToString(employeeMode).Trim().Equals("Productive", StringComparison.OrdinalIgnoreCase);
        }

        private static DataTable GetReportingProductionDetails(bllMaster master, string fromDate, string toDate, string code)
        {
            try
            {
                return master.GetUserPerformanceReport_DashboardDetails(fromDate, toDate, code);
            }
            catch
            {
                return new DataTable();
            }
        }

        private static DataTable GetReportingAttendanceDetails(bllMaster master, string fromDate, string toDate, string code)
        {
            try
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("UserCode", code);
                htParam.Add("FromDate", fromDate);
                htParam.Add("ToDate", toDate);
                return master.GetDetailedAttendancePercentageForDashboard(htParam);
            }
            catch
            {
                return new DataTable();
            }
        }

        private static int GetPendingReportingManagerApprovalCount(bllMaster master, int managerId)
        {
            int count = 0;

            try
            {
                count += SafeRowCount(master.GetAllLeavesbyPM(managerId));
            }
            catch
            {
            }

            try
            {
                count += SafeRowCount(master.GetAllAttendanceCorrectionRequestForPM(managerId));
            }
            catch
            {
            }

            return count;
        }

        private static int SafeRowCount(DataTable dt)
        {
            return dt == null ? 0 : dt.Rows.Count;
        }

        private static object GetDictionaryValue(Dictionary<string, object> row, string key)
        {
            object value;

            if (row != null && row.TryGetValue(key, out value))
                return value;

            return "";
        }

        private static Dictionary<string, object> GetLatestReportingRow(List<Dictionary<string, object>> rows, bool isProduction)
        {
            if (rows == null || rows.Count == 0)
                return null;

            return rows
                .OrderBy(x => isProduction ? GetReportingProductionMonthDate(x) : GetReportingAttendanceMonthDate(x))
                .LastOrDefault();
        }

        private static DateTime GetReportingProductionMonthDate(Dictionary<string, object> row)
        {
            DateTime monthDate;
            string monthSort = Convert.ToString(GetDictionaryValue(row, "MonthSort"));

            if (!string.IsNullOrWhiteSpace(monthSort) &&
                DateTime.TryParseExact(monthSort, "yyyy-MM", CultureInfo.InvariantCulture, DateTimeStyles.AllowWhiteSpaces, out monthDate))
                return monthDate;

            if (TryParseDashboardMonth(GetDictionaryValue(row, "MonthYear"), out monthDate))
                return monthDate;

            return DateTime.MinValue;
        }

        private static DateTime GetReportingAttendanceMonthDate(Dictionary<string, object> row)
        {
            int month = GetMonthNumber(GetDictionaryValue(row, "Month"));
            int year;

            if (int.TryParse(Convert.ToString(GetDictionaryValue(row, "Year")), out year) && month > 0)
            {
                if (year < 100)
                    year += 2000;

                return new DateTime(year, month, 1);
            }

            return DateTime.MinValue;
        }

        private static string GetReportingAttendanceMonthYear(Dictionary<string, object> row)
        {
            string month = Convert.ToString(GetDictionaryValue(row, "Month"));
            string year = Convert.ToString(GetDictionaryValue(row, "Year"));

            if (!string.IsNullOrWhiteSpace(month) && !string.IsNullOrWhiteSpace(year))
                return month + "-" + year;

            return month + year;
        }

        private static void AddReportingProductionTrend(Dictionary<string, DashboardReportingTrendRow> trendRows, Dictionary<string, object> row)
        {
            DateTime monthDate = GetReportingProductionMonthDate(row);
            string label = Convert.ToString(GetDictionaryValue(row, "MonthYear"));
            string key = monthDate == DateTime.MinValue ? label : monthDate.ToString("yyyy-MM");

            if (string.IsNullOrWhiteSpace(key))
                return;

            DashboardReportingTrendRow trendRow = GetReportingTrendRow(trendRows, key, label, monthDate);
            decimal production = ToDecimal(GetDictionaryValue(row, "Production"));
            decimal productionPerc = ToDecimal(GetDictionaryValue(row, "ProductionPerc"));
            decimal accuracy = ToDecimal(GetDictionaryValue(row, "Accuracy"));
            decimal expectedProductivity = ToDecimal(GetDictionaryValue(row, "ExpectedProductivity"));

            trendRow.Production += production;
            trendRow.ExpectedProductivity += expectedProductivity;

            if (productionPerc > 0)
            {
                trendRow.ProductionPercTotal += productionPerc;
                trendRow.ProductionPercCount++;
            }

            if (accuracy > 0)
            {
                trendRow.AccuracyTotal += accuracy;
                trendRow.AccuracyCount++;
            }
        }

        private static void AddReportingAttendanceTrend(Dictionary<string, DashboardReportingTrendRow> trendRows, Dictionary<string, object> row)
        {
            DateTime monthDate = GetReportingAttendanceMonthDate(row);
            string label = GetReportingAttendanceMonthYear(row);
            string key = monthDate == DateTime.MinValue ? label : monthDate.ToString("yyyy-MM");

            if (string.IsNullOrWhiteSpace(key))
                return;

            DashboardReportingTrendRow trendRow = GetReportingTrendRow(trendRows, key, label, monthDate);
            decimal attendancePerc = ToDecimal(GetDictionaryValue(row, "AttendancePercOnTotalDays"));

            if (attendancePerc > 0)
            {
                trendRow.AttendancePercTotal += attendancePerc;
                trendRow.AttendancePercCount++;
            }

            trendRow.AbsentDays += ToDecimal(GetDictionaryValue(row, "TotalAbsentDays"));
            trendRow.LateMarks += ToDecimal(GetDictionaryValue(row, "TotalLatemarks"));
        }

        private static DashboardReportingTrendRow GetReportingTrendRow(Dictionary<string, DashboardReportingTrendRow> trendRows, string key, string label, DateTime monthDate)
        {
            DashboardReportingTrendRow trendRow;

            if (!trendRows.TryGetValue(key, out trendRow))
            {
                trendRow = new DashboardReportingTrendRow
                {
                    MonthKey = key,
                    MonthYear = string.IsNullOrWhiteSpace(label) && monthDate != DateTime.MinValue ? monthDate.ToString("MMM-yyyy") : label,
                    MonthDate = monthDate
                };

                trendRows.Add(key, trendRow);
            }

            return trendRow;
        }

        private static List<Dictionary<string, object>> BuildReportingProductionTrend(Dictionary<string, DashboardReportingTrendRow> trendRows)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            foreach (DashboardReportingTrendRow trendRow in trendRows.Values.OrderBy(x => x.MonthDate == DateTime.MinValue ? DateTime.MaxValue : x.MonthDate).ThenBy(x => x.MonthKey))
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                row.Add("MonthYear", trendRow.MonthYear);
                row.Add("Production", FormatDecimal(trendRow.Production));
                row.Add("ExpectedProductivity", trendRow.ExpectedProductivity > 0 ? FormatDecimal(trendRow.ExpectedProductivity) : "");
                row.Add("ProductionPerc", trendRow.ProductionPercCount == 0 ? "" : FormatDecimal(trendRow.ProductionPercTotal / trendRow.ProductionPercCount));
                row.Add("Accuracy", trendRow.AccuracyCount == 0 ? "" : FormatDecimal(trendRow.AccuracyTotal / trendRow.AccuracyCount));
                rows.Add(row);
            }

            return rows;
        }

        private static List<Dictionary<string, object>> BuildReportingAttendanceTrend(Dictionary<string, DashboardReportingTrendRow> trendRows)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            foreach (DashboardReportingTrendRow trendRow in trendRows.Values.OrderBy(x => x.MonthDate == DateTime.MinValue ? DateTime.MaxValue : x.MonthDate).ThenBy(x => x.MonthKey))
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                row.Add("MonthYear", trendRow.MonthYear);
                row.Add("AttendancePerc", trendRow.AttendancePercCount == 0 ? "" : FormatDecimal(trendRow.AttendancePercTotal / trendRow.AttendancePercCount));
                row.Add("AbsentDays", FormatDecimal(trendRow.AbsentDays));
                row.Add("LateMarks", FormatDecimal(trendRow.LateMarks));
                rows.Add(row);
            }

            return rows;
        }

        private static void ApplyReportingManagerStatus(Dictionary<string, object> member, List<Dictionary<string, object>> alerts)
        {
            bool needsAttention = false;
            string code = Convert.ToString(GetDictionaryValue(member, "Code"));
            string employeeName = Convert.ToString(GetDictionaryValue(member, "EmployeeName"));
            bool isProductive = IsReportingProductiveEmployee(Convert.ToString(GetDictionaryValue(member, "EmployeeMode")));
            decimal productionPerc = ToDecimal(GetDictionaryValue(member, "ProductionPerc"));
            decimal accuracy = ToDecimal(GetDictionaryValue(member, "Accuracy"));
            decimal attendancePerc = ToDecimal(GetDictionaryValue(member, "AttendancePerc"));
            decimal lateMarks = ToDecimal(GetDictionaryValue(member, "LateMarks"));

            if (isProductive && productionPerc > 0 && productionPerc < 100)
            {
                AddReportingAlert(alerts, code, employeeName, "Productivity below target", FormatDecimal(productionPerc) + "%");
                needsAttention = true;
            }

            if (isProductive && accuracy > 0 && accuracy < 95)
            {
                AddReportingAlert(alerts, code, employeeName, "Accuracy below 95%", FormatDecimal(accuracy) + "%");
                needsAttention = true;
            }

            if (attendancePerc > 0 && attendancePerc < 95)
            {
                AddReportingAlert(alerts, code, employeeName, "Attendance below 95%", FormatDecimal(attendancePerc) + "%");
                needsAttention = true;
            }

            if (lateMarks > 0)
            {
                AddReportingAlert(alerts, code, employeeName, "Latemarks", FormatDecimal(lateMarks));
                needsAttention = true;
            }

            if (isProductive)
                member["Status"] = needsAttention ? "Needs Attention" : "On Track";
        }

        private static void AddReportingAlert(List<Dictionary<string, object>> alerts, string code, string employeeName, string issue, string value)
        {
            Dictionary<string, object> alert = new Dictionary<string, object>();
            alert.Add("Code", code);
            alert.Add("EmployeeName", employeeName);
            alert.Add("Issue", issue);
            alert.Add("Value", value);
            alerts.Add(alert);
        }

        private class DashboardMonthRow
        {
            public DataRow Row { get; set; }
            public DateTime MonthDate { get; set; }
            public bool HasMonthDate { get; set; }
            public int RowIndex { get; set; }
        }

        private class DashboardReportingTrendRow
        {
            public string MonthKey { get; set; }
            public string MonthYear { get; set; }
            public DateTime MonthDate { get; set; }
            public decimal Production { get; set; }
            public decimal ExpectedProductivity { get; set; }
            public decimal ProductionPercTotal { get; set; }
            public int ProductionPercCount { get; set; }
            public decimal AccuracyTotal { get; set; }
            public int AccuracyCount { get; set; }
            public decimal AttendancePercTotal { get; set; }
            public int AttendancePercCount { get; set; }
            public decimal AbsentDays { get; set; }
            public decimal LateMarks { get; set; }
        }

        public class AnniversaryEmployee
        {
            public int EmployeeId { get; set; }
            public string EmpName { get; set; }
            public string DepartmentName { get; set; }
            //public string PhotoPath { get; set; }
            public string YearsCompleted { get; set; }
        }

        public class EmpWorkAnniversary
        {
            public int EmployeeId { get; set; }
            public string EmpName { get; set; }
            public string Designation { get; set; }
            public string DepartmentName { get; set; }
            public string BranchName { get; set; }
            public string DomainName { get; set; }
            public string JoiningDate { get; set; }
            public string ReportingManager { get; set; }
            public string YearsCompleted { get; set; }
        }
    }
}
