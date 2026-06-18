using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using DocumentFormat.OpenXml.Spreadsheet;
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
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Admin
{
    public partial class AttendanceCorrectionpm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int CheckCutOffTimeValidation(string Code, string AddedCutOff, string InDate)
        {
            return AttendanceCorrectionWebMethods.CheckCutOffTimeValidation(Code, AddedCutOff, InDate);
        }

        [WebMethod]
        public static string GteAllUsers()
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAllUsersUnderPM(AttendanceCorrectionWebMethods.CurrentUserId()));
        }

        [WebMethod]
        public static string GetLoggedInUser()
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllLogin().GetUserInformation(AttendanceCorrectionWebMethods.CurrentUserId()));
        }

        [WebMethod]
        public static bool GetERPCutoffTimeExceptionsByCode(string Code, string Date)
        {
            return new bllLogin().GetERPCutoffTimeExceptionsByCode(Code, Date);
        }

        [WebMethod]
        public static string BindAttendanceReasons()
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAllStandardReasonsForPM());
        }

        [WebMethod]
        public static int getAttendanceCount(string Code)
        {
            return new bllMaster().GetAttendanceRequestCount(Code);
        }

        [WebMethod]
        public static string GetAllAttendanceRequest()
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAllAttendanceCorrectionRequestForPM(AttendanceCorrectionWebMethods.CurrentUserId()));
        }

        [WebMethod]
        public static string GetInDates(string Code)
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAttendamceCorrectionDates(Code));
        }

        [WebMethod]
        public static string GetInDateForLogout(string Code)
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAlldateByAttendanceRequestLogoutDate(Code));
        }

        [WebMethod]
        public static string GetOutDateForLogout(string Code)
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetLogoutDate(Code));
        }

        [WebMethod]
        public static string GetOutDateForConnectivity(string Code)
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetDateForConnectivityIssuePM(Code));
        }

        [WebMethod]
        public static string GetInTime(string Date, string Code)
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetCodeDate(Code, Date));
        }

        [WebMethod]
        public static string GetAllDateForDelete(string Code)
        {
            return AttendanceCorrectionWebMethods.SerializeRows(new bllMaster().GetAllDateForAttendance(Code));
        }

        [WebMethod]
        public static string UserLoginGetTotalHours_PM(string Code, string Intime, string OutTime, string InDate, string OutDate)
        {
            return AttendanceCorrectionWebMethods.UserLoginGetTotalHours(Code, Intime, OutTime, InDate, OutDate);
        }

        [WebMethod]
        public static string CalculateTotalHours(string InDateTime, string OutDateTime)
        {
            return AttendanceCorrectionWebMethods.CalculateTotalHours(InDateTime, OutDateTime);
        }

        [WebMethod]
        public static int InsertAttendance_PM(string Code, string IntimeParam, string OutTimeParam, string InDateParam, string OutDateParam, string TotalHoursParam, string reasontypevalue, string reasontypeParam, string userreasonParam)
        {
            return AttendanceCorrectionWebMethods.SaveAttendanceCorrection(new AttendanceCorrectionWebMethods.AttendanceSaveRequest
            {
                Mode = AttendanceCorrectionWebMethods.AttendanceSaveMode.PmInsert,
                Code = Code,
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
        public static int SendAttendanceEmail_InOut(string Code, string InDate, string InTime, string OutDate, string OutTime, string TotalHours, string Reason, string ReasonType, string UserReason)
        {
            return AttendanceCorrectionWebMethods.SendAttendanceCorrectionEmail(new AttendanceCorrectionWebMethods.AttendanceEmailRequest
            {
                Mode = AttendanceCorrectionWebMethods.AttendanceEmailMode.PmRequest,
                Code = Code,
                InDate = InDate,
                InTime = InTime,
                OutDate = OutDate,
                OutTime = OutTime,
                TotalHours = TotalHours,
                Reason = Reason,
                ReasonType = ReasonType,
                UserReason = UserReason
            });
        }

        [WebMethod]
        public static string GetLogDatesForTimeExceed(string Code, string Date)
        {
            return new CodeGeneration().getLogDatesForTimeExceed(Code, Date, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
        }
    }
}
