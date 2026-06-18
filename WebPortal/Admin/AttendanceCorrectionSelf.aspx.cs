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
            int returnvalue = 0;
            DataTable dt = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    bool IsExcept = new bllLogin().GetERPCutoffTimeExceptionsByCode(Convert.ToString(dt.Rows[0]["Code"]), InDate);

                    if (IsExcept == true)
                    {
                        string SystemCutoff = Convert.ToString(dt.Rows[0]["CutOffTime"]);
                        DateTime systemTime = Convert.ToDateTime(SystemCutoff);
                        DateTime addedTime = Convert.ToDateTime(AddedCutOff);
                        DateTime NTimeVleue = systemTime.AddMinutes(-30);

                        if (addedTime.TimeOfDay < NTimeVleue.TimeOfDay)
                        {
                            returnvalue = 0;
                        }
                        else
                        {
                            returnvalue = 1;
                        }
                    }
                    else
                    {
                        returnvalue = 1;
                    }
                }
            }
            return returnvalue;
        }


        [WebMethod]
        public static string BindAttendanceReasons()
        {
            DataTable dt1 = new bllMaster().GetAllStandardReasons();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static int getAttendanceCount()
        {
            int returnvalue = 0;
            returnvalue = new bllMaster().GetAttendanceRequestCount();
            return returnvalue;
        }


        [WebMethod]
        public static string GetAllAttendanceRequest()
        {
            string Code = Convert.ToString(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString())));
            DataTable dt1 = new bllMaster().GetAllAttendanceCorrectionRequest(Code);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetInDates()
        {
            string Code = Convert.ToString(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString())));
            DataTable dt1 = new bllMaster().GetAttendamceCorrectionDates(Code);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }


        [WebMethod]
        public static string GetInTime(string Date)
        {
            string Code = Convert.ToString(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString())));
            DataTable dt1 = new bllMaster().GetCodeDate(Code, Date);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }


        [WebMethod]
        public static string GetInDateForLogout()
        {
            string Code = Convert.ToString(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString())));
            DataTable dt1 = new bllMaster().GetAlldateByAttendanceRequestLogoutDate(Code);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }


        [WebMethod]
        public static string GetOutDateForLogout()
        {
            string Code = Convert.ToString(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString())));
            DataTable dt1 = new bllMaster().GetLogoutDate(Code);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }


        [WebMethod]
        public static string GetOutDateForConnectivity()
        {
            string Code = Convert.ToString(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString())));
            DataTable dt1 = new bllMaster().GetDateForConnectivityIssuePM(Code);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }


        [WebMethod]
        public static string UserLoginGetTotalHours(string Intime, string OutTime, string InDate, string OutDate)
        {
            string Code = Convert.ToString(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString())));
            string InTimeConvention = "";
            string OutTimeConvention = "";
            if (Convert.ToInt32(Intime.Substring(0, 2)) < 12)
                InTimeConvention = "AM";
            else if (Convert.ToInt32(Intime.Substring(0, 2)) == 12)
                InTimeConvention = "PM";
            else
            {
                string changein = Convert.ToString((Convert.ToInt32(Intime.Substring(0, 2)) - 12)).Length == 1 ? "0" + (Convert.ToInt32(Intime.Substring(0, 2)) - 12) + ":" + Intime.Substring(3, 2) : (Convert.ToInt32(Intime.Substring(0, 2)) - 12) + ":" + Intime.Substring(3, 2);
                Intime = changein;
                InTimeConvention = "PM";
            }
            if (Convert.ToInt32(OutTime.Substring(0, 2)) < 12)
                OutTimeConvention = "AM";
            else if (Convert.ToInt32(OutTime.Substring(0, 2)) == 12)
                OutTimeConvention = "PM";
            else
            {
                string changeout = Convert.ToString((Convert.ToInt32(OutTime.Substring(0, 2)) - 12)).Length == 1 ? "0" + (Convert.ToInt32(OutTime.Substring(0, 2)) - 12) + ":" + OutTime.Substring(3, 2) : (Convert.ToInt32(OutTime.Substring(0, 2)) - 12) + ":" + OutTime.Substring(3, 2);
                OutTime = changeout;
                OutTimeConvention = "PM";
            }

            string HoursSpan = "";
            string login = Intime;
            string Logout = OutTime;
            string WorkHoliday = "";
            string LogOutTime = "";
            string LogIntime = "";
            string LogOutDateTime = "";
            string LoginInDateTime = "";
            int workingHours = 0;
            DateTime InDateTime = DateTime.MinValue;
            DateTime OutDateTime = DateTime.MinValue;
            string Returnvalue = "";
            string Total = "";

            int empID = new bllMaster().GetEmployeeIdFromCode(Code);

            DataTable dt = new bllLogin().GetUserInformation(empID);
            if (dt.Rows.Count > 0)
            {
                workingHours = Convert.ToInt32(dt.Rows[0]["WorkTime"]);
                WorkHoliday = Convert.ToString(dt.Rows[0]["WeeklyHolidayName"]);
            }

            if (InTimeConvention == "AM" && Intime.Substring(0, 2) == "00")
                LogIntime = Intime.Replace(Intime.Substring(0, 2), "12") + ":00" + " " + InTimeConvention;
            else
                LogIntime = Intime + ":00" + " " + InTimeConvention;
            LoginInDateTime = InDate + " " + LogIntime;
            if (OutTimeConvention == "AM" && OutTime.Substring(0, 2) == "00")
                LogOutTime = OutTime.Replace(OutTime.Substring(0, 2), "12") + ":00" + " " + OutTimeConvention;
            else
                LogOutTime = OutTime + ":00" + " " + OutTimeConvention;
            LogOutDateTime = OutDate + " " + LogOutTime;

            try
            {
                DateTime IN = Convert.ToDateTime(LoginInDateTime);
                try
                {
                    DateTime Out = Convert.ToDateTime(LogOutDateTime);

                    int Inhr = IN.Hour;
                    int Outhr = Out.Hour;

                    if (OutTime != "" && OutTime != null && OutDate != "Select")
                    {
                        try
                        {
                            InDateTime = Convert.ToDateTime(String.Format("{0} {1}", (InDate), (LogIntime)));

                            string timeIn12HourFormatForDisplay = InDateTime.ToString("hh:mm:ss tt", CultureInfo.InvariantCulture);
                            string timeOut12HourFormatForInDate = InDateTime.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);

                            if (LogIntime == timeIn12HourFormatForDisplay)
                            {
                                try
                                {
                                    OutDateTime = Convert.ToDateTime(String.Format("{0} {1}", (OutDate), (LogOutTime)));

                                    string timeOut12HourFormatForDisplay = OutDateTime.ToString("hh:mm:ss tt", CultureInfo.InvariantCulture);

                                    string timeOut12HourFormatForOutDate = OutDateTime.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);

                                    if (LogOutTime == timeOut12HourFormatForDisplay)
                                    {
                                        var hr = OutDateTime.Subtract(InDateTime).TotalHours;

                                        string TotalHours = CalculateTotalHours(timeOut12HourFormatForOutDate, timeOut12HourFormatForInDate);

                                        //if (hr < 24.01)
                                        //{
                                        if (OutDateTime > InDateTime)
                                        {
                                            TimeSpan timeDiff = OutDateTime - InDateTime;
                                            //   string diff = Convert.ToString(timeDiff).Substring(0, 5);

                                            int Daysdiff = timeDiff.Days;
                                            int hourdiff = timeDiff.Hours;
                                            int Mindiff = timeDiff.Minutes;
                                            string Diff = Convert.ToString(timeDiff).Substring(0, 5);
                                            Total = TotalHours;
                                            Total = Diff;
                                            string Day = InDateTime.DayOfWeek.ToString();

                                            if (WorkHoliday == Day && TotalHours != "")
                                            {
                                                HoursSpan = TotalHours + "~" + "Weekly Off:" + "~" + WorkHoliday;
                                                Returnvalue = HoursSpan;
                                            }
                                            else
                                            {
                                                HoursSpan = TotalHours;
                                            }
                                        }
                                        else
                                        {
                                            HoursSpan = "Please enter valid details." + "~" + " ";
                                        }
                                    }
                                    else
                                    {
                                        HoursSpan = "Please enter valid logout time in 12 hours format." + "~" + " ";
                                    }
                                }
                                catch (Exception ex)
                                {
                                    string msg = ex.Message;
                                    HoursSpan = "Please enter valid logout time." + "~" + " ";
                                }
                            }
                            else
                            {
                                HoursSpan = "Please enter valid login time in 12 hours format." + "~" + " ";
                            }
                        }

                        catch (Exception ex)
                        {
                            string msg = ex.Message;
                            HoursSpan = "Please enter valid login time." + "~" + " ";
                        }
                    }
                    else
                    {

                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;
                    HoursSpan = "Please enter logout  time in 12 hours format." + "~" + " ";
                }
            }
            catch (Exception ex)
            {
                string msg = ex.Message;
                HoursSpan = "Please enter login  time in 12 hours format." + "~" + " ";
            }
            int l = Returnvalue.Length;
            return HoursSpan;
        }


        [WebMethod]
        public static string CalculateTotalHours(string InDateTime, string OutDateTime)
        {
            return new bllMaster().CalculateTotalHoursForAttendance(InDateTime, OutDateTime); //
        }


        [WebMethod]
        public static int InsertAttendance(string IntimeParam, string OutTimeParam, string InDateParam, string OutDateParam, string TotalHoursParam, string reasontypevalue, string reasontypeParam, string userreasonParam)
        {
            int returnvalue = 0;
            string Code = Convert.ToString(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString())));
            string InTimeConvention = "";
            string OutTimeConvention = "";
            if (Convert.ToInt32(IntimeParam.Substring(0, 2)) < 12)
                InTimeConvention = "AM";
            else if (Convert.ToInt32(IntimeParam.Substring(0, 2)) == 12)
                InTimeConvention = "PM";
            else
            {
                string changein = Convert.ToString((Convert.ToInt32(IntimeParam.Substring(0, 2)) - 12)).Length == 1 ? "0" + (Convert.ToInt32(IntimeParam.Substring(0, 2)) - 12) + ":" + IntimeParam.Substring(3, 2) : (Convert.ToInt32(IntimeParam.Substring(0, 2)) - 12) + ":" + IntimeParam.Substring(3, 2);
                IntimeParam = changein;
                InTimeConvention = "PM";
            }
            if (OutDateParam != "")
            {
                if (Convert.ToInt32(OutTimeParam.Substring(0, 2)) < 12)
                    OutTimeConvention = "AM";
                else if (Convert.ToInt32(OutTimeParam.Substring(0, 2)) == 12)
                    OutTimeConvention = "PM";
                else
                {
                    string changeout = Convert.ToString((Convert.ToInt32(OutTimeParam.Substring(0, 2)) - 12)).Length == 1 ? "0" + (Convert.ToInt32(OutTimeParam.Substring(0, 2)) - 12) + ":" + OutTimeParam.Substring(3, 2) : (Convert.ToInt32(OutTimeParam.Substring(0, 2)) - 12) + ":" + OutTimeParam.Substring(3, 2);
                    OutTimeParam = changeout;
                    OutTimeConvention = "PM";
                }
            }
            Hashtable htAttendance = new Hashtable();
            htAttendance.Add("Code", Code);
            string InTime = "";
            string OutTime = "";
            string newLogin = "";
            string newLogout = "";
            int workingHours = 0;
            string OffEmailID = "";
            string Intime1 = "";
            string Outtime1 = "";
            string InDate1 = InDateParam;
            string OutDate1 = "";
            string UserReason = "";
            string TotalHours = "";
            string Productivity = "";
            DataTable dtt = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dtt.Rows.Count > 0)
            {
                Code = Convert.ToString(dtt.Rows[0]["Code"]);
                Productivity = Convert.ToString(dtt.Rows[0]["DailyTaskProductivity"]);
            }

            string login = "";
            string Logout = "";

            int loginlength = 0;
            int LogoutLength = 0;

            if (reasontypevalue == "2")
            {
                login = IntimeParam;
                //  login = (Request.Form[txtInTime.UniqueID]).Trim();
                //InTimeConvention = hdInTimeConvention.Value;
                Logout = OutTimeParam;
                UserReason = userreasonParam;
                loginlength = login.Length;
                LogoutLength = Logout.Length;
                TotalHours = TotalHoursParam;
                if (loginlength > 5 || LogoutLength > 5)
                {
                    newLogin = login.Substring(0, 2) + ":" + login.Substring(2, 4);
                    newLogout = Logout.Substring(1, 2) + ":" + Logout.Substring(2, 3);

                    newLogin = (OutTimeParam).Trim();
                    newLogout = OutTimeParam.Trim();
                }
                else
                {
                    newLogin = IntimeParam;
                    newLogout = OutTimeParam.Trim();
                }
            }
            else
            {
                login = IntimeParam;
                Logout = OutTimeParam;
                UserReason = userreasonParam;

                loginlength = login.Length;
                LogoutLength = Logout.Length;

                if (loginlength > 5 || LogoutLength > 5)
                {
                    newLogin = login.Substring(0, 2) + ":" + login.Substring(2, 4);
                    newLogout = Logout.Substring(1, 2) + ":" + Logout.Substring(2, 3);

                    newLogin = IntimeParam.Trim();
                    newLogout = OutTimeParam.Trim();
                }
                else
                {
                    newLogin = IntimeParam.Trim();
                    newLogout = OutTimeParam.Trim();
                }
            }

            DataTable dt = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (dt.Rows.Count > 0)
            {
                if (OffEmailID != string.Empty && OffEmailID == null && OffEmailID == "")
                    OffEmailID = Convert.ToString(dt.Rows[0]["OfficialEmailID"]);
                else
                    OffEmailID = "k.sagar@infinity-data.com";

            }

            var cultureSource = new CultureInfo("en-US", false);
            var cultureDest = new CultureInfo("de-DE", false);

            TotalHours = TotalHoursParam;
            //---------- In Time ----------//
            if (InDateParam != "" && login != "" && InTimeConvention != "")
            {
                Intime1 = login + " " + InTimeConvention;

                var InSource = login + " " + InTimeConvention;
                try
                {
                    var LogIntime = DateTime.Parse(InSource, cultureSource);
                    InTime = LogIntime.ToString("t", cultureDest);
                    string LogIntime1 = "";

                    if (InTimeConvention == "AM" && login.Substring(0, 2) == "00")
                        LogIntime1 = login.Replace(login.Substring(0, 2), "12") + ":00" + " " + InTimeConvention;
                    else
                        LogIntime1 = login + ":00" + " " + InTimeConvention;

                    DateTime InDateTime1 = Convert.ToDateTime(String.Format("{0} {1}", (InDate1), (LogIntime1)));
                    string timeIn12HourFormatForDisplay = InDateTime1.ToString("hh:mm:ss tt", CultureInfo.InvariantCulture);

                    if (LogIntime1 == timeIn12HourFormatForDisplay)
                    {
                        //---------- Out Time ----------//
                        if (OutDateParam != "" && newLogout != "" && OutTimeConvention != "")
                        {

                            #region IN-OUT
                            var OutSource = OutTimeParam.Trim() + " " + OutTimeConvention;
                            var LogOutTime = DateTime.Parse(OutSource, cultureSource);
                            OutTime = LogOutTime.ToString("t", cultureDest);
                            OutDate1 = OutDateParam;
                            if (OutTimeConvention == "AM" && OutTimeParam.Substring(0, 2) == "00")
                                Outtime1 = OutTimeParam.Replace(OutTimeParam.Substring(0, 2), "12") + ":00" + " " + OutTimeConvention;
                            else
                                Outtime1 = OutTimeParam + ":00" + " " + OutTimeConvention;

                            // Outtime1 = OutTimeParam.Trim() + " " + OutTimeConvention;

                            if (OutDate1 != "Select" && OutDateParam != "" && LogOutTime != null && OutTimeParam != null && OutTimeParam != "" && OutTimeConvention != "")
                            {
                                DateTime InDateTime = Convert.ToDateTime(String.Format("{0} {1}", (InDate1), (InTime)));
                                DateTime OutDateTime = Convert.ToDateTime(String.Format("{0} {1}", (OutDate1), (OutTime)));

                                if (OutDateTime > InDateTime)
                                {
                                    TimeSpan timeDiff = OutDateTime - InDateTime;
                                    int HH = 0;
                                    int Daysdiff = timeDiff.Days;
                                    int hourdiff = timeDiff.Hours;
                                    int Mindiff = timeDiff.Minutes;

                                    TotalHours = Convert.ToString(hourdiff) + ":" + Convert.ToString(Mindiff);

                                    var hrdiff = OutDateTime.Subtract(InDateTime).TotalHours;

                                    htAttendance.Add("InTime", InTime);
                                    htAttendance.Add("OutTime", OutTime);
                                    htAttendance.Add("BreakOutTime", "");
                                    htAttendance.Add("BreakInTime", "");
                                    htAttendance.Add("InDate", Convert.ToDateTime(InDateParam).ToString("dd-MMM-yyyy"));
                                    htAttendance.Add("OutDate", Convert.ToDateTime(OutDateParam).ToString("dd-MMM-yyyy"));
                                    htAttendance.Add("BreakOutDate", "");
                                    htAttendance.Add("BreakInDate", "");
                                    htAttendance.Add("ReasonType", reasontypeParam);
                                    htAttendance.Add("EntryType", "LogInLogOut");
                                    htAttendance.Add("Reason", UserReason);
                                    htAttendance.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                                    returnvalue = new bllMaster().InsertAttendanceCorrectRequest(htAttendance);

                                    if (returnvalue > 0)
                                    {
                                          SendAttendanceEmail_InOut(Code, InDateParam, InTime, OutDateParam, OutTime, TotalHours, UserReason, reasontypeParam);
                                    }
                                    else
                                    {
                                        returnvalue = 0;
                                    }
                                }
                                else
                                {
                                    returnvalue = -1;
                                }
                            }
                            else
                            {
                                returnvalue = -1;

                            }
                            #endregion
                        }
                        else
                        {
                            #region IN
                            if (InTime != "" && OutDateParam == "" && OutTimeConvention == "" || OutTime != "")//|| BreakInTime != "" || BreakOutTime != "")
                            {
                                htAttendance.Add("InTime", InTime);
                                htAttendance.Add("OutTime", "");
                                htAttendance.Add("BreakOutTime", "");
                                htAttendance.Add("BreakInTime", "");
                                htAttendance.Add("InDate", Convert.ToDateTime(InDateParam).ToString("dd-MMM-yyyy"));
                                htAttendance.Add("OutDate", "Select");
                                htAttendance.Add("BreakOutDate", "");
                                htAttendance.Add("BreakInDate", "");
                                htAttendance.Add("EntryType", "LogInLogOut");
                                htAttendance.Add("ReasonType", reasontypeParam);
                                htAttendance.Add("Reason", UserReason);
                                htAttendance.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                                returnvalue =  new bllMaster().InsertAttendanceCorrectRequest(htAttendance);

                                if (returnvalue > 0)
                                {
                                    SendAttendanceEmail_InOut(Code, InDateParam, InTime, "", "", TotalHours, UserReason, reasontypeParam);
                                }
                                else
                                {
                                    returnvalue = 0;
                                }
                            }
                            else if (OutDateParam == "" && OutTimeParam != "" && OutTimeConvention != "")
                            {
                                returnvalue = -2;
                            }
                            else if (OutDateParam != "" && OutTimeParam == "" && OutTimeConvention != "")
                            {
                                returnvalue = -3;

                            }
                            else
                            {
                                returnvalue = -4;
                            }

                            #endregion
                        }
                    }
                    else
                    {
                        returnvalue = -5;
                    }
                }
                catch (Exception ex)
                {
                    returnvalue = -6;
                }
            }
            else
            {
                returnvalue = -7;
            }
            return returnvalue;
        }


        [WebMethod]
        public static int SendAttendanceEmail_InOut(string Code, string InDate, string InTime, string OutDate, string OutTime, string TotalHours, string Reason, string ReasonType)
        {
            int returnvalue = 0;
            string To = "";
            string CC = "";
            string BCC = "";
            string contentHeader = "";
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt = new bllLogin().GetUserInformation(EmployeeID);
            DataTable dtPM = new bllMaster().ProjectManagerRelatedToDepartment(EmployeeID);
            InTime = Convert.ToDateTime(InTime).ToString("hh:mm tt");
            if (OutTime != "")
                OutTime = Convert.ToDateTime(OutTime).ToString("hh:mm tt");
            string Subject = "HRMS Correction: Request - " + Code;
            string LocationHead = "";
            string DomainHead = "";
            string PrimaryProject = "";
            string PrimaryProcess = "";
            string DomainEmailID = "";

            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(EmployeeID, "Attendance Correction");
            LocationHead = Convert.ToString(dtEmail.Rows[0]["LocationHeadName"]);
            DomainHead = Convert.ToString(dtEmail.Rows[0]["DomainHeadName"]);
            if (LocationHead == "")
                LocationHead = DomainHead;

            DataTable dtPro = new bllMaster().GetPrimaryProject(EmployeeID);
            if (dtPro != null)
            {
                if (dtPro.Rows.Count > 0)
                {
                    PrimaryProject = Convert.ToString(dtPro.Rows[0]["Project"]);
                    PrimaryProcess = Convert.ToString(dtPro.Rows[0]["Process"]);
                }
            }

            if (dtPM != null)
            {
                if (dtPM.Rows.Count > 0)
                {
                    To = Convert.ToString(dtEmail.Rows[0]["ToAttendance"]);
                    CC = Convert.ToString(dtEmail.Rows[0]["CCAtt"]);
                    BCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:biome; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                    body.Append("<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear " + Convert.ToString(dt.Rows[0]["FirstName"]) + ",<br />Attendance correction request is generated in ERP with following details.<br /><br /></b></td></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"border:solid 1px Gray; width:100px!important;\" colspan=\"2\"><b>Employee Details</b></td></tr>" +
                    "<tr><td style=\"border:solid 1px Gray; width:100px!important;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;\">" + Convert.ToString(dt.Rows[0]["CodeName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JoiningDate"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DepartmentName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["DesignationName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["SubDomain"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Project:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PrimaryProject) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Process:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(PrimaryProcess) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(DomainHead) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(LocationHead) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\" colspan=\"2\"><b>Attendance Correction Details:</b></td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ReasonType) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>In Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(InDate) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>In Time:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(InTime) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Out Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(OutDate) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Out Time:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(OutTime) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Total Hours:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(TotalHours) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Reason) + "</td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:10px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                    footer.Append("</body></html>");
                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Attendance Notification", System.Text.Encoding.UTF8);

                    mail.To.Add(To);
                    mail.CC.Add(CC);
                    mail.Bcc.Add(BCC);
                    mail.Subject = Subject;
                    mail.Body = head.ToString() + body.ToString() + footer.ToString();
                    mail.IsBodyHtml = true;

                    mail.Priority = System.Net.Mail.MailPriority.High;
                    SmtpClient client = new SmtpClient();
                    client.UseDefaultCredentials = false;
                    client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", Pass);
                    client.Host = "smtp.office365.com";  //Gmail works on Server Secured Layer
                    client.Port = 587;
                    client.EnableSsl = true;
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                    try
                    {
                        client.Send(mail);
                        return 1;
                    }
                    catch { return 0; }
                }
            }

            return returnvalue;
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

                // 👉 Convert times properly
                DateTime? inDateTime = ParseDateTime(inDateParam, inTimeParam);
                DateTime? outDateTime = ParseDateTime(outDateParam, outTimeParam);

                // 👉 Convert times properly
                DateTime time1 = DateTime.ParseExact(inTimeParam, "HH:mm", System.Globalization.CultureInfo.InvariantCulture);
                DateTime time2 = DateTime.ParseExact(outTimeParam, "HH:mm", System.Globalization.CultureInfo.InvariantCulture);

                if (inDateTime == null)
                    return -7;

                // 👉 Validate OUT > IN
                if (outDateTime != null && outDateTime <= inDateTime)
                    return -1;

                // 👉 Calculate total hours
                string totalHours = totalHoursParam;
                if (inDateTime != null && outDateTime != null)
                {
                    TimeSpan diff = outDateTime.Value - inDateTime.Value;
                    totalHours = $"{diff.Hours}:{diff.Minutes}";
                }



                // 👉 Prepare data
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

                //// 👉 Send email if success
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


        // ✅ Helper Method (Reusable & Clean)
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
