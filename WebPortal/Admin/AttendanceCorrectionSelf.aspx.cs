using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class AttendanceCorrectionSelf : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int CheckCutOffTimeValidation(string Code, string AddedCutOff, string InDate)
        {
            return AttendanceCorrectionWebMethods.CheckCutOffTimeValidation(AttendanceCorrectionWebMethods.CurrentUserCode(), AddedCutOff, InDate);
        }

        [WebMethod]
        public static string BindAttendanceReasons()
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAllStandardReasons());
        }

        [WebMethod]
        public static int getAttendanceCount()
        {
            return new bllMaster().GetAttendanceRequestCount();
        }


        [WebMethod]
        public static string GetAllAttendanceRequest()
        {
            string code = AttendanceCorrectionWebMethods.CurrentUserCode();
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAllAttendanceCorrectionRequest(code));
        }

        [WebMethod]
        public static string GetInDates()
        {
            string code = AttendanceCorrectionWebMethods.CurrentUserCode();
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAttendamceCorrectionDates(code));
        }

        [WebMethod]
        public static string GetInTime(string Date)
        {
            string code = AttendanceCorrectionWebMethods.CurrentUserCode();
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetCodeDate(code, Date));
        }

        [WebMethod]
        public static string GetInDateForLogout()
        {
            string code = AttendanceCorrectionWebMethods.CurrentUserCode();
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAlldateByAttendanceRequestLogoutDate(code));
        }

        [WebMethod]
        public static string GetOutDateForLogout()
        {
            string code = AttendanceCorrectionWebMethods.CurrentUserCode();
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetLogoutDate(code));
        }

        [WebMethod]
        public static string GetOutDateForConnectivity()
        {
            string code = AttendanceCorrectionWebMethods.CurrentUserCode();
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetDateForConnectivityIssuePM(code));
        }

        [WebMethod]
        public static string UserLoginGetTotalHours(string Intime, string OutTime, string InDate, string OutDate)
        {
            return AttendanceCorrectionWebMethods.UserLoginGetTotalHours(AttendanceCorrectionWebMethods.CurrentUserCode(), Intime, OutTime, InDate, OutDate);
        }

        [WebMethod]
        public static string CalculateTotalHours(string InDateTime, string OutDateTime)
        {
            return AttendanceCorrectionWebMethods.CalculateTotalHours(InDateTime, OutDateTime);
        }


        [WebMethod]
        public static int InsertAttendance(string IntimeParam, string OutTimeParam, string InDateParam, string OutDateParam, string TotalHoursParam, string reasontypevalue, string reasontypeParam, string userreasonParam)
        {
            return AttendanceCorrectionWebMethods.SaveAttendanceCorrection(new AttendanceCorrectionWebMethods.AttendanceSaveRequest
            {
                Mode = AttendanceCorrectionWebMethods.AttendanceSaveMode.SelfInsert,
                Code = AttendanceCorrectionWebMethods.CurrentUserCode(),
                IntimeParam = IntimeParam,
                OutTimeParam = OutTimeParam,
                InDateParam = InDateParam,
                OutDateParam = OutDateParam,
                TotalHoursParam = TotalHoursParam,
                ReasonTypeValue = reasontypevalue,
                ReasonTypeParam = reasontypeParam,
                UserReasonParam = userreasonParam
            });
        }

        [WebMethod]
        public static int SendAttendanceEmail_InOut(string Code, string InDate, string InTime, string OutDate, string OutTime, string TotalHours, string Reason, string ReasonType)
        {
            return AttendanceCorrectionWebMethods.SendAttendanceCorrectionEmail(new AttendanceCorrectionWebMethods.AttendanceEmailRequest
            {
                Mode = AttendanceCorrectionWebMethods.AttendanceEmailMode.SelfRequest,
                Code = Code,
                InDate = InDate,
                InTime = InTime,
                OutDate = OutDate,
                OutTime = OutTime,
                TotalHours = TotalHours,
                Reason = Reason,
                ReasonType = ReasonType
            });
        }

        [WebMethod]
        public static int New_InsertAttendance(string inTimeParam, string outTimeParam, string inDateParam, string outDateParam, string totalHoursParam, string reasonTypeValue, string reasonTypeParam, string userReasonParam)
        {
            try
            {
                int userId = int.Parse(HttpContext.Current.User.Identity.Name);
                var master = new bllMaster();
                var loginBLL = new bllLogin();

                string code = master.GetCodeFromEmployeeId(userId).ToString();
                DataTable userInfo = loginBLL.GetUserInformation(userId);

                if (userInfo.Rows.Count > 0)
                    code = userInfo.Rows[0]["Code"].ToString();

                // Convert times properly.
                DateTime? inDateTime = ParseDateTime(inDateParam, inTimeParam);
                DateTime? outDateTime = ParseDateTime(outDateParam, outTimeParam);

                // Convert times properly.
                DateTime time1 = DateTime.ParseExact(inTimeParam, "HH:mm", System.Globalization.CultureInfo.InvariantCulture);
                DateTime time2 = DateTime.ParseExact(outTimeParam, "HH:mm", System.Globalization.CultureInfo.InvariantCulture);

                if (inDateTime == null)
                    return -7;

                // Validate OUT > IN.
                if (outDateTime != null && outDateTime <= inDateTime)
                    return -1;

                // Calculate total hours.
                string totalHours = totalHoursParam;
                if (inDateTime != null && outDateTime != null)
                {
                    TimeSpan diff = outDateTime.Value - inDateTime.Value;
                    totalHours = $"{diff.Hours}:{diff.Minutes}";
                }



                // Prepare data.
                Hashtable ht = new Hashtable
                {
                    ["Code"] = code,
                    ["InTime"] = inDateTime?.ToString("HH:mm"),
                    ["OutTime"] = outDateTime?.ToString("HH:mm") ?? "",
                    ["InDate"] = inDateTime?.ToString("dd-MMM-yyyy"),
                    ["OutDate"] = outDateTime?.ToString("dd-MMM-yyyy") ?? "",
                    ["BreakOutTime"] = "",
                    ["BreakInTime"] = "",
                    ["BreakOutDate"] = "",
                    ["BreakInDate"] = "",
                    ["EntryType"] = "LogInLogOut",
                    ["ReasonType"] = reasonTypeParam,
                    ["Reason"] = userReasonParam,
                    ["AddedBy"] = userId
                };

                int result = 10;// master.InsertAttendanceCorrectRequest(ht);

                //// Send email if success.
                //if (result > 0)
                //{
                //   SendAttendanceEmail_InOut(code, inDateParam, ht["InTime"].ToString(), outDateParam, ht["OutTime"].ToString(), totalHoursParam, userReasonParam, reasonTypeParam);

                //  SendAttendanceEmail_InOut(code, inDateParam, time1.ToString(), outDateParam, time2.ToString(), totalHoursParam, userReasonParam, reasonTypeParam);

                //}

                return result;
            }
            catch
            {
                return -6;
            }
        }


        // Helper method for the legacy New_* WebMethods.
        private static DateTime? ParseDateTime(string date, string time)
        {
            if (string.IsNullOrWhiteSpace(date) || string.IsNullOrWhiteSpace(time))
                return null;

            DateTime result;
            if (DateTime.TryParse($"{date} {time}", out result))
                return result;

            return null;
        }


        [WebMethod]
        public static string New_UserLoginGetTotalHours(string inTime, string outTime, string inDate, string outDate)
        {
            try
            {
                // Validate input
                if (string.IsNullOrWhiteSpace(inTime) || string.IsNullOrWhiteSpace(outTime) || outDate == "Select")
                    return "Please enter valid details.~ ";

                // Get employee code & ID
                int empId = new bllMaster().GetEmployeeIdFromCode(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name)));

                // Get employee info
                DataTable dt = new bllLogin().GetUserInformation(empId);

                int workingHours = 0;
                string weeklyHoliday = "";

                if (dt.Rows.Count > 0)
                {
                    workingHours = Convert.ToInt32(dt.Rows[0]["WorkTime"]);
                    weeklyHoliday = Convert.ToString(dt.Rows[0]["WeeklyHolidayName"]);
                }

                // Parse datetime directly (NO manual AM/PM conversion needed)
                DateTime inDateTime, outDateTime;

                if (!DateTime.TryParse($"{inDate} {inTime}", out inDateTime))
                    return "Please enter valid login time.~ ";

                if (!DateTime.TryParse($"{outDate} {outTime}", out outDateTime))
                    return "Please enter valid logout time.~ ";

                // Validate logical condition
                if (outDateTime <= inDateTime)
                    return "Please enter valid details.~ ";

                // Calculate difference
                TimeSpan diff = outDateTime - inDateTime;

                string totalHours = diff.ToString(@"hh\:mm");

                // Check weekly off
                if (!string.IsNullOrEmpty(weeklyHoliday) &&
                    inDateTime.DayOfWeek.ToString().Equals(weeklyHoliday, StringComparison.OrdinalIgnoreCase))
                {
                    return $"{totalHours}~Weekly Off:~{weeklyHoliday}";
                }

                return totalHours;
            }
            catch
            {
                return "Please enter valid details.~ ";
            }
        }
    }
}
