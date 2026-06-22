using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    internal static class AttendanceCorrectionWebMethods
    {
        internal enum AttendanceSaveMode
        {
            SelfInsert,
            PmInsert,
            EditUpdate
        }

        internal enum AttendanceEmailMode
        {
            SelfRequest,
            PmRequest,
            Decision
        }

        internal sealed class AttendanceSaveRequest
        {
            internal AttendanceSaveMode Mode { get; set; }
            internal int RequestID { get; set; }
            internal string Code { get; set; }
            internal string IntimeParam { get; set; }
            internal string OutTimeParam { get; set; }
            internal string InDateParam { get; set; }
            internal string OutDateParam { get; set; }
            internal string TotalHoursParam { get; set; }
            internal string ReasonTypeValue { get; set; }
            internal string ReasonTypeParam { get; set; }
            internal string UserReasonParam { get; set; }
            internal string Remark { get; set; }
            internal string Status { get; set; }
            internal string Location { get; set; }
            internal string UserAttnReason { get; set; }
        }

        internal sealed class AttendanceEmailRequest
        {
            internal AttendanceEmailMode Mode { get; set; }
            internal string Code { get; set; }
            internal string InDate { get; set; }
            internal string InTime { get; set; }
            internal string OutDate { get; set; }
            internal string OutTime { get; set; }
            internal string TotalHours { get; set; }
            internal string Reason { get; set; }
            internal string Status { get; set; }
            internal string ReasonType { get; set; }
            internal string UserReason { get; set; }
        }

        internal static int CurrentUserId()
        {
            return int.Parse(HttpContext.Current.User.Identity.Name.ToString());
        }

        internal static string CurrentUserCode()
        {
            return Convert.ToString(new bllMaster().GetCodeFromEmployeeId(CurrentUserId()));
        }

        internal static string SerializeRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (table != null)
            {
                foreach (DataRow dr in table.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn col in table.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(rows);
        }

        internal static int CheckCutOffTimeValidation(string code, string addedCutOff, string inDate)
        {
            int returnvalue = 0;
            int employeeId = new bllMaster().GetEmployeeIdFromCode(code);
            DataTable dt = new bllLogin().GetUserInformation(employeeId);

            if (dt != null && dt.Rows.Count > 0)
            {
                bool isExcept = new bllLogin().GetERPCutoffTimeExceptionsByCode(code, inDate);
                if (isExcept)
                {
                    DateTime systemTime = Convert.ToDateTime(Convert.ToString(dt.Rows[0]["CutOffTime"]));
                    DateTime addedTime = Convert.ToDateTime(addedCutOff);
                    DateTime allowedTime = systemTime.AddMinutes(-30);
                    returnvalue = addedTime.TimeOfDay < allowedTime.TimeOfDay ? 0 : 1;
                }
                else
                {
                    returnvalue = 1;
                }
            }

            return returnvalue;
        }

        internal static string CalculateTotalHours(string inDateTime, string outDateTime)
        {
            return new bllMaster().CalculateTotalHoursForAttendance(inDateTime, outDateTime);
        }

        internal static string UserLoginGetTotalHours(string code, string intime, string outTime, string inDate, string outDate)
        {
            string normalizedInTime = SafeTrim(intime);
            string normalizedOutTime = SafeTrim(outTime);
            string inTimeConvention;
            string outTimeConvention;

            if (!TryNormalizeTime(ref normalizedInTime, out inTimeConvention))
                return "Please enter login  time in 12 hours format.~ ";

            if (!TryNormalizeTime(ref normalizedOutTime, out outTimeConvention))
                return "Please enter logout  time in 12 hours format.~ ";

            string hoursSpan = "";
            string workHoliday = "";
            string returnValue = "";
            DateTime inDateTimeValue = DateTime.MinValue;
            DateTime outDateTimeValue = DateTime.MinValue;

            int empID = new bllMaster().GetEmployeeIdFromCode(code);
            DataTable dt = new bllLogin().GetUserInformation(empID);
            if (dt.Rows.Count > 0)
            {
                workHoliday = Convert.ToString(dt.Rows[0]["WeeklyHolidayName"]);
            }

            string logInTime = ToLogTime(normalizedInTime, inTimeConvention);
            string logOutTime = ToLogTime(normalizedOutTime, outTimeConvention);
            string loginInDateTime = inDate + " " + logInTime;
            string logOutDateTime = outDate + " " + logOutTime;

            try
            {
                DateTime inValue = Convert.ToDateTime(loginInDateTime);
                try
                {
                    DateTime outValue = Convert.ToDateTime(logOutDateTime);

                    if (normalizedOutTime != "" && normalizedOutTime != null && outDate != "Select")
                    {
                        try
                        {
                            inDateTimeValue = Convert.ToDateTime(String.Format("{0} {1}", inDate, logInTime));

                            string timeIn12HourFormatForDisplay = inDateTimeValue.ToString("hh:mm:ss tt", CultureInfo.InvariantCulture);
                            string timeOut12HourFormatForInDate = inDateTimeValue.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);

                            if (logInTime == timeIn12HourFormatForDisplay)
                            {
                                try
                                {
                                    outDateTimeValue = Convert.ToDateTime(String.Format("{0} {1}", outDate, logOutTime));
                                    string timeOut12HourFormatForDisplay = outDateTimeValue.ToString("hh:mm:ss tt", CultureInfo.InvariantCulture);
                                    string timeOut12HourFormatForOutDate = outDateTimeValue.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);

                                    if (logOutTime == timeOut12HourFormatForDisplay)
                                    {
                                        string totalHours = CalculateTotalHours(timeOut12HourFormatForOutDate, timeOut12HourFormatForInDate);

                                        if (outDateTimeValue > inDateTimeValue)
                                        {
                                            string day = inDateTimeValue.DayOfWeek.ToString();

                                            if (workHoliday == day && totalHours != "")
                                            {
                                                hoursSpan = totalHours + "~" + "Weekly Off:" + "~" + workHoliday;
                                                returnValue = hoursSpan;
                                            }
                                            else
                                            {
                                                hoursSpan = totalHours;
                                            }
                                        }
                                        else
                                        {
                                            hoursSpan = "Please enter valid details." + "~" + " ";
                                        }
                                    }
                                    else
                                    {
                                        hoursSpan = "Please enter valid logout time in 12 hours format." + "~" + " ";
                                    }
                                }
                                catch
                                {
                                    hoursSpan = "Please enter valid logout time." + "~" + " ";
                                }
                            }
                            else
                            {
                                hoursSpan = "Please enter valid login time in 12 hours format." + "~" + " ";
                            }
                        }
                        catch
                        {
                            hoursSpan = "Please enter valid login time." + "~" + " ";
                        }
                    }
                }
                catch
                {
                    hoursSpan = "Please enter logout  time in 12 hours format." + "~" + " ";
                }
            }
            catch
            {
                hoursSpan = "Please enter login  time in 12 hours format." + "~" + " ";
            }

            int length = returnValue.Length;
            return hoursSpan;
        }

        internal static int SaveAttendanceCorrection(AttendanceSaveRequest request)
        {
            string inTimeParam = SafeTrim(request.IntimeParam);
            string outTimeParam = SafeTrim(request.OutTimeParam);
            string inDateParam = SafeTrim(request.InDateParam);
            string outDateParam = SafeTrim(request.OutDateParam);
            string inTimeConvention;
            string outTimeConvention = "";

            if (inDateParam == "" || inTimeParam == "")
                return -7;

            if (!TryNormalizeTime(ref inTimeParam, out inTimeConvention))
                return -6;

            if (outDateParam == "" && outTimeParam != "")
                return -2;

            if (outDateParam != "" && outTimeParam == "")
                return -3;

            if (outDateParam != "" && !TryNormalizeTime(ref outTimeParam, out outTimeConvention))
                return -6;

            string inTime = "";
            string outTime = "";
            string totalHours = SafeTrim(request.TotalHoursParam);
            string userReason = request.Mode == AttendanceSaveMode.EditUpdate ? SafeTrim(request.Remark) : SafeTrim(request.UserReasonParam);
            string code = SafeTrim(request.Code);

            if (request.Mode == AttendanceSaveMode.EditUpdate)
            {
                int employeeId = new bllMaster().GetEmployeeIdFromCode(code);
                DataTable user = new bllLogin().GetUserInformation(employeeId);
                if (user.Rows.Count > 0)
                {
                    code = Convert.ToString(user.Rows[0]["Code"]);
                }
            }

            CultureInfo cultureSource = new CultureInfo("en-US", false);
            CultureInfo cultureDest = new CultureInfo("de-DE", false);

            if (inDateParam != "" && inTimeParam != "" && inTimeConvention != "")
            {
                try
                {
                    DateTime logInTime = DateTime.Parse(inTimeParam + " " + inTimeConvention, cultureSource);
                    inTime = logInTime.ToString("t", cultureDest);
                    string logInDisplay = ToLogTime(inTimeParam, inTimeConvention);
                    DateTime inDateTimeDisplay = Convert.ToDateTime(String.Format("{0} {1}", inDateParam, logInDisplay));
                    string timeIn12HourFormatForDisplay = inDateTimeDisplay.ToString("hh:mm:ss tt", CultureInfo.InvariantCulture);

                    if (logInDisplay != timeIn12HourFormatForDisplay)
                        return -5;

                    if (outDateParam != "" && outTimeParam != "" && outTimeConvention != "")
                    {
                        return SaveWithOutTime(request, code, inDateParam, inTimeParam, inTimeConvention, outDateParam, outTimeParam, outTimeConvention, totalHours, userReason, inTime, cultureSource, cultureDest);
                    }

                    if ((inTime != "" && outDateParam == "" && outTimeConvention == "") || outTime != "")
                    {
                        return SaveInOnly(request, code, inDateParam, totalHours, userReason, inTime);
                    }

                    if (outDateParam == "" && outTimeParam != "" && outTimeConvention != "")
                        return -2;

                    if (outDateParam != "" && outTimeParam == "" && outTimeConvention != "")
                        return -3;

                    return -4;
                }
                catch
                {
                    return -6;
                }
            }

            return -7;
        }

        internal static int SendAttendanceCorrectionEmail(AttendanceEmailRequest request)
        {
            int returnvalue = 0;
            int employeeID = new bllMaster().GetEmployeeIdFromCode(request.Code);
            DataTable employee = new bllLogin().GetUserInformation(employeeID);
            DataTable pm = new bllMaster().ProjectManagerRelatedToDepartment(employeeID);

            if (pm == null || pm.Rows.Count == 0)
                return returnvalue;

            string inTime = Convert.ToDateTime(request.InTime).ToString("hh:mm tt");
            string outTime = !String.IsNullOrEmpty(request.OutTime) ? Convert.ToDateTime(request.OutTime).ToString("hh:mm tt") : "";
            string subject = GetEmailSubject(request);
            string locationHead = "";
            string domainHead = "";
            string primaryProject = "";
            string primaryProcess = "";

            DataTable emailInfo = new bllLogin().GetUserPmDomainLocationEmailInfo(employeeID, "Attendance Correction");
            locationHead = Convert.ToString(emailInfo.Rows[0]["LocationHeadName"]);
            domainHead = Convert.ToString(emailInfo.Rows[0]["DomainHeadName"]);
            if (locationHead == "")
                locationHead = domainHead;

            DataTable primary = new bllMaster().GetPrimaryProject(employeeID);
            if (primary != null && primary.Rows.Count > 0)
            {
                primaryProject = Convert.ToString(primary.Rows[0]["Project"]);
                primaryProcess = Convert.ToString(primary.Rows[0]["Process"]);
            }

            StringBuilder body = new StringBuilder();
            body.Append("<html><head></head><body>");
            body.Append("<table style=\"width:802px;font-family:biome; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
            body.Append(GetIntroTable(request, employee));
            body.Append("<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">");
            body.Append("<tr><td style=\"border:solid 1px Gray; width:100px!important;\" colspan=\"2\"><b>Employee Details</b></td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray; width:100px!important;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;\">" + Convert.ToString(employee.Rows[0]["CodeName"]) + "</td></tr>");
            AppendCommonEmployeeRows(body, employee, primaryProject, primaryProcess, domainHead, locationHead);
            AppendAttendanceRows(body, request, inTime, outTime);
            body.Append("<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>");
            body.Append("<tr><td style=\"text-align:left; font-size:10px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>");
            body.Append("</table></body></html>");

            string pass = new bllMaster().GetPassword("ackdata");
            using (MailMessage mail = new MailMessage())
            {
                mail.From = new MailAddress("ack@infinity-data.com", "Attendance Notification", Encoding.UTF8);

                AddRecipients(mail.To, Convert.ToString(emailInfo.Rows[0]["ToAttendance"]));
                AddRecipients(mail.CC, Convert.ToString(emailInfo.Rows[0]["CCAtt"]));
                AddRecipients(mail.Bcc, Convert.ToString(emailInfo.Rows[0]["BCC"]));
                mail.Subject = subject;
                mail.Body = body.ToString();
                mail.IsBodyHtml = true;
                mail.Priority = MailPriority.High;

                SmtpClient client = new SmtpClient();
                client.UseDefaultCredentials = false;
                client.Credentials = new NetworkCredential("ack@infinity-data.com", pass);
                client.Host = "smtp.office365.com";
                client.Port = 587;
                client.EnableSsl = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                try
                {
                    client.Send(mail);
                    return 1;
                }
                catch
                {
                    return 0;
                }
            }
        }

        private static int SaveWithOutTime(AttendanceSaveRequest request, string code, string inDateParam, string inTimeParam, string inTimeConvention, string outDateParam, string outTimeParam, string outTimeConvention, string totalHours, string userReason, string inTime, CultureInfo cultureSource, CultureInfo cultureDest)
        {
            DateTime logOutTime = DateTime.Parse(outTimeParam.Trim() + " " + outTimeConvention, cultureSource);
            string outTime = logOutTime.ToString("t", cultureDest);
            if (outDateParam == "Select" || outDateParam == "" || outTimeParam == null || outTimeParam == "" || outTimeConvention == "")
                return -1;

            DateTime inDateTime = Convert.ToDateTime(String.Format("{0} {1}", inDateParam, inTime));
            DateTime outDateTime = Convert.ToDateTime(String.Format("{0} {1}", outDateParam, outTime));

            if (outDateTime <= inDateTime)
                return -1;

            TimeSpan timeDiff = outDateTime - inDateTime;
            totalHours = Convert.ToString(timeDiff.Hours) + ":" + Convert.ToString(timeDiff.Minutes);

            Hashtable attendance = BuildAttendanceHash(request, code, inTime, outTime, inDateParam, outDateParam, userReason, true);
            int result = SaveHash(request.Mode, attendance);
            if (result > 0)
            {
                SendSaveEmail(request, code, inDateParam, inTime, outDateParam, outTime, totalHours, userReason);
            }

            return result > 0 ? result : 0;
        }

        private static int SaveInOnly(AttendanceSaveRequest request, string code, string inDateParam, string totalHours, string userReason, string inTime)
        {
            Hashtable attendance = BuildAttendanceHash(request, code, inTime, "", inDateParam, "Select", userReason, false);
            int result = SaveHash(request.Mode, attendance);
            if (result > 0)
            {
                SendSaveEmail(request, code, inDateParam, inTime, "", "", totalHours, userReason);
            }

            return result > 0 ? result : 0;
        }

        private static Hashtable BuildAttendanceHash(AttendanceSaveRequest request, string code, string inTime, string outTime, string inDate, string outDate, string userReason, bool hasOutTime)
        {
            Hashtable attendance = new Hashtable();
            attendance.Add("Code", code);

            if (request.Mode == AttendanceSaveMode.EditUpdate)
                attendance.Add("AttendanceCorrectRequestID", request.RequestID);

            attendance.Add("InTime", inTime);
            attendance.Add("OutTime", hasOutTime ? outTime : "");
            attendance.Add("BreakOutTime", "");
            attendance.Add("BreakInTime", "");
            attendance.Add("InDate", FormatSaveDate(inDate, request.Mode));
            attendance.Add("OutDate", hasOutTime ? FormatSaveDate(outDate, request.Mode) : "Select");
            attendance.Add("BreakOutDate", "");
            attendance.Add("BreakInDate", "");

            if (request.Mode == AttendanceSaveMode.SelfInsert)
            {
                attendance.Add("EntryType", "LogInLogOut");
                attendance.Add("ReasonType", request.ReasonTypeParam);
                attendance.Add("Reason", userReason);
                attendance.Add("AddedBy", CurrentUserId());
            }
            else if (request.Mode == AttendanceSaveMode.PmInsert)
            {
                attendance.Add("ReasonType", request.ReasonTypeParam);
                attendance.Add("Reason", userReason);
                attendance.Add("PrevDate", "");
                attendance.Add("IpAddress", "23.111.175.186");
                attendance.Add("ApprovedBy", CurrentUserId());
            }
            else
            {
                attendance.Add("RequestRemark", request.Remark);
                attendance.Add("IsApproved", request.Status == "Approve");
                attendance.Add("UpdationIP", request.Location);
                attendance.Add("UpdatedBy", CurrentUserId());
            }

            return attendance;
        }

        private static string FormatSaveDate(string date, AttendanceSaveMode mode)
        {
            if (mode == AttendanceSaveMode.EditUpdate || date == "Select" || date == "")
                return date;

            return Convert.ToDateTime(date).ToString("dd-MMM-yyyy");
        }

        private static int SaveHash(AttendanceSaveMode mode, Hashtable attendance)
        {
            bllMaster master = new bllMaster();
            if (mode == AttendanceSaveMode.SelfInsert)
                return master.InsertAttendanceCorrectRequest(attendance);

            if (mode == AttendanceSaveMode.PmInsert)
                return master.InsertAttendanceCorrectRequestByPM(attendance);

            return master.UpdateAttendanceCorrection(attendance);
        }

        private static void SendSaveEmail(AttendanceSaveRequest request, string code, string inDate, string inTime, string outDate, string outTime, string totalHours, string userReason)
        {

            DateTime time1 = DateTime.ParseExact(inTime, "HH:mm", System.Globalization.CultureInfo.InvariantCulture);
            DateTime time2 = DateTime.ParseExact(outTime, "HH:mm", System.Globalization.CultureInfo.InvariantCulture);


            if (request.Mode == AttendanceSaveMode.SelfInsert)
            {
                SendAttendanceCorrectionEmail(new AttendanceEmailRequest
                {
                    Mode = AttendanceEmailMode.SelfRequest,
                    Code = code,
                    InDate = inDate,
                    InTime = time1.ToString(),
                    OutDate = outDate,
                    OutTime = time2.ToString(),
                    TotalHours = totalHours,
                    Reason = userReason,
                    ReasonType = request.ReasonTypeParam
                });
            }
            else if (request.Mode == AttendanceSaveMode.PmInsert)
            {
                SendAttendanceCorrectionEmail(new AttendanceEmailRequest
                {
                    Mode = AttendanceEmailMode.PmRequest,
                    Code = code,
                    InDate = inDate,
                    InTime = time1.ToString(),
                    OutDate = outDate,
                    OutTime = time2.ToString(),
                    TotalHours = totalHours,
                    Reason = userReason,
                    ReasonType = request.ReasonTypeParam,
                    UserReason = request.UserReasonParam
                });
            }
            else
            {
                SendAttendanceCorrectionEmail(new AttendanceEmailRequest
                {
                    Mode = AttendanceEmailMode.Decision,
                    Code = code,
                    InDate = inDate,
                    InTime = time1.ToString(),
                    OutDate = outDate,
                    OutTime = time2.ToString(),
                    TotalHours = totalHours,
                    Reason = userReason,
                    Status = request.Status,
                    ReasonType = request.ReasonTypeParam,
                    UserReason = request.UserAttnReason
                });
            }
        }

        private static string GetEmailSubject(AttendanceEmailRequest request)
        {
            if (request.Mode != AttendanceEmailMode.Decision)
                return "HRMS Correction: Request - " + request.Code;

            string status = request.Status == "Approve" ? "Approval" : "Rejection";
            return "HRMS Correction: " + status + " - " + request.Code;
        }

        private static string GetIntroTable(AttendanceEmailRequest request, DataTable employee)
        {
            string firstName = Convert.ToString(employee.Rows[0]["FirstName"]);
            if (request.Mode == AttendanceEmailMode.Decision)
            {
                string status = request.Status == "Approve" ? "approved" : "rejected";
                return "<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                    "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear " + firstName + ",</b><br />Attendance correction request is " + status + " in ERP with following details.<br /><br /></td></tr></table>";
            }

            return "<table border=\"0\" style=\"width:800px;font-family:biome; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear " + firstName + ",<br />Attendance correction request is generated in ERP with following details.<br /><br /></b></td></tr></table>";
        }

        private static void AppendCommonEmployeeRows(StringBuilder body, DataTable employee, string primaryProject, string primaryProcess, string domainHead, string locationHead)
        {
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Joining Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(employee.Rows[0]["JoiningDate"]) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(employee.Rows[0]["JobType"]) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Department:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(employee.Rows[0]["DepartmentName"]) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Designation:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(employee.Rows[0]["DesignationName"]) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(employee.Rows[0]["WorkingBranchName"]) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reporting Manager:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(employee.Rows[0]["ReportingManager"]) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(employee.Rows[0]["SubDomain"]) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Project:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(primaryProject) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Process:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(primaryProcess) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Domain Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(domainHead) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location Head:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(locationHead) + "</td></tr>");
        }

        private static void AppendAttendanceRows(StringBuilder body, AttendanceEmailRequest request, string inTime, string outTime)
        {
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\" colspan=\"2\"><b>Attendance Correction Details:</b></td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(request.ReasonType) + "</td></tr>");

            if (request.Mode != AttendanceEmailMode.SelfRequest)
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(request.UserReason) + "</td></tr>");

            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>In Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(request.InDate) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>In Time:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(inTime) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Out Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(request.OutDate) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Out Time:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(outTime) + "</td></tr>");
            body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Total Hours:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(request.TotalHours) + "</td></tr>");

            if (request.Mode == AttendanceEmailMode.SelfRequest)
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(request.Reason) + "</td></tr>");
            else
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(request.Reason) + "</td></tr>");

            if (request.Mode == AttendanceEmailMode.Decision)
            {
                DataTable updatedBy = new bllLogin().GetUserInformation(CurrentUserId());
                body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Updated By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(updatedBy.Rows[0]["Code"]) + " : " + Convert.ToString(updatedBy.Rows[0]["FirstName"]) + " " + Convert.ToString(updatedBy.Rows[0]["lastName"]) + " </td></tr>");
            }
        }

        private static void AddRecipients(MailAddressCollection collection, string recipients)
        {
            if (!String.IsNullOrWhiteSpace(recipients))
                collection.Add(recipients);
        }

        private static bool TryNormalizeTime(ref string time, out string convention)
        {
            convention = "";
            time = SafeTrim(time);

            if (time.Length < 5)
                return false;

            int hour;
            if (!Int32.TryParse(time.Substring(0, 2), out hour))
                return false;

            if (hour < 12)
            {
                convention = "AM";
            }
            else if (hour == 12)
            {
                convention = "PM";
            }
            else
            {
                string hour12 = Convert.ToString(hour - 12);
                if (hour12.Length == 1)
                    hour12 = "0" + hour12;

                time = hour12 + ":" + time.Substring(3, 2);
                convention = "PM";
            }

            return true;
        }

        private static string ToLogTime(string time, string convention)
        {
            if (convention == "AM" && time.Substring(0, 2) == "00")
                return time.Replace(time.Substring(0, 2), "12") + ":00" + " " + convention;

            return time + ":00" + " " + convention;
        }

        private static string SafeTrim(string value)
        {
            return (value ?? "").Trim();
        }
    }
}
