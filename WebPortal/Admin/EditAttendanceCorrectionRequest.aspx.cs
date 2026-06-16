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
    public partial class EditAttendanceCorrectionRequest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string BindEditInformation(int RequestID)
        {
            DataTable dt1 = new bllMaster().GetAttendanceCorrectionByID(RequestID);
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
        public static int UpdateAttendance_PM(int RequestID, string Code, string IntimeParam, string OutTimeParam, string InDateParam, string OutDateParam, string TotalHoursParam, string Remark, string Status, string Location, string ReasonType, string UserAttnReason)
        {
            int returnvalue = 0;
            bool blststus = Status == "Approve" ? blststus = true : blststus = false;
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
            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dtt = new bllLogin().GetUserInformation(EmployeeID);
            if (dtt.Rows.Count > 0)
            {
                Code = Convert.ToString(dtt.Rows[0]["Code"]);
                Productivity = Convert.ToString(dtt.Rows[0]["DailyTaskProductivity"]);
            }

            string login = "";
            string Logout = "";

            int loginlength = 0;
            int LogoutLength = 0;


            login = IntimeParam;
            Logout = OutTimeParam;
            UserReason = Remark;

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

                    // string LogIntime1 = login + ":00" + " " + InTimeConvention;
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
                            //Outtime1 = OutTimeParam.Trim() + " " + OutTimeConvention;

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

                                    htAttendance.Add("AttendanceCorrectRequestID", RequestID);
                                    htAttendance.Add("InTime", InTime);
                                    htAttendance.Add("OutTime", OutTime);
                                    htAttendance.Add("BreakOutTime", "");
                                    htAttendance.Add("BreakInTime", "");
                                    htAttendance.Add("InDate", InDateParam);
                                    htAttendance.Add("OutDate", OutDateParam);
                                    htAttendance.Add("BreakOutDate", "");
                                    htAttendance.Add("BreakInDate", "");
                                    //htAttendance.Add("EntryType", "LogInLogOut");
                                    htAttendance.Add("RequestRemark", Remark);
                                    htAttendance.Add("IsApproved", blststus);
                                    htAttendance.Add("UpdationIP", Location);
                                    htAttendance.Add("UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                                    returnvalue = new bllMaster().UpdateAttendanceCorrection(htAttendance);

                                    if (returnvalue > 0)
                                    {
                                        SendAttendanceEmail_InOut(Code, InDateParam, InTime, OutDateParam, OutTime, TotalHours, UserReason, Status, ReasonType, UserAttnReason);
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
                                htAttendance.Add("AttendanceCorrectRequestID", RequestID);
                                htAttendance.Add("InTime", InTime);
                                htAttendance.Add("OutTime", "");
                                htAttendance.Add("BreakOutTime", "");
                                htAttendance.Add("BreakInTime", "");
                                htAttendance.Add("InDate", InDateParam);
                                htAttendance.Add("OutDate", "Select");
                                htAttendance.Add("BreakOutDate", "");
                                htAttendance.Add("BreakInDate", "");
                                htAttendance.Add("RequestRemark", Remark);
                                htAttendance.Add("IsApproved", blststus);
                                htAttendance.Add("UpdationIP", Location);
                                htAttendance.Add("UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                                returnvalue = new bllMaster().UpdateAttendanceCorrection(htAttendance);

                                if (returnvalue > 0)
                                {
                                    SendAttendanceEmail_InOut(Code, InDateParam, InTime, "", "", TotalHours, UserReason, Status, ReasonType, UserAttnReason);
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
        public static int SendAttendanceEmail_InOut(string Code, string InDate, string InTime, string OutDate, string OutTime, string TotalHours, string Reason, string Status, string ReasonType, string UserReason)
        {
            int returnvalue = 0;
            string To = "";
            string CC = "";
            string BCC = "";
            string contentHeader = "";
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
            DataTable dtupdate = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            int EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            DataTable dt = new bllLogin().GetUserInformation(EmployeeID);
            DataTable dtPM = new bllMaster().ProjectManagerRelatedToDepartment(EmployeeID);
            InTime = Convert.ToDateTime(InTime).ToString("hh:mm tt");
            if (OutTime != "")
                OutTime = Convert.ToDateTime(OutTime).ToString("hh:mm tt");
            string Status1 = Status == "Approve" ? "Approval" : "Rejection";
            string Status2 = Status == "Approve" ? "approved" : "rejected";
            string Subject = "HRMS Correction: " + Status1 + " - " + Code;
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
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear " + Convert.ToString(dt.Rows[0]["FirstName"]) + ",</b><br />Attendance correction request is " + Status2 + " in ERP with following details.<br /><br /></td></tr></table>" +
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
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(UserReason) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>In Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(InDate) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>In Time:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(InTime) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Out Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(OutDate) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Out Time:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(OutTime) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Total Hours:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(TotalHours) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Reason) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Updated By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtupdate.Rows[0]["Code"]) + " : " + Convert.ToString(dtupdate.Rows[0]["FirstName"]) + " " + Convert.ToString(dtupdate.Rows[0]["lastName"]) + " </td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" +
                        "<tr><td style=\"text-align:left; font-size:10px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                        "</table>");
                    footer.Append("</body></html>");
                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Attendance Notification", System.Text.Encoding.UTF8);
                    //mail.To.Add("n.nilkanth@infinityinternationals.us");
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

    }
}