using WebPortal.App_Code.BLL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Services;

namespace WebPortal.App_Code
{
    /// <summary>
    /// Summary description for CodeGeneration
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class CodeGeneration : System.Web.Services.WebService
    {

        bllMaster bllMaster = new bllMaster();

        // bllSalary bllSalary = new bllSalary();
        //dalMaster dalMaster = new dalMaster();

        public string getLogDates(string Code, string Date)
        {
            string logDetails = "";
            string RemainingTotalHours = "";
            DataTable dts = bllMaster.GetEmployeeExtraHours(Code);

            DateTime InDate = Convert.ToDateTime(Date);
            string ToDaysDate = DateTime.Now.ToString("dd-MMM-yyyy");
            TimeSpan difference = Convert.ToDateTime(ToDaysDate) - InDate;
            var days = difference.TotalDays;
            int DaysNo = Convert.ToInt32(days);

            if (DaysNo < 5)
            {
                #region Calculation
                if (dts.Rows.Count > 0)
                {
                    RemainingTotalHours = Convert.ToString(dts.Rows[0]["RemainingTotalHours"]);
                }

                DataTable dt = bllMaster.GetCodeDate(Code, Date);

                try
                {
                    if (dt.Rows.Count > 0)
                    {
                        string InTime = Convert.ToString(dt.Rows[0]["InTime"]);
                        string OutTime = Convert.ToString(dt.Rows[0]["OutTime"]);
                        string ActualInTime = "";
                        string ActualOutTime = "";

                        if (InTime != null && InTime != "")
                        {
                            try
                            {
                                string[] Inhours = InTime.Split(' ');

                                if (Inhours[1] != null)
                                {
                                    string[] Inhour = Inhours[1].Split(':');
                                    int inlen = Inhour[0].Length;

                                    if (inlen == 1)
                                    {
                                        ActualInTime = "0" + Inhour[0] + ":" + Inhour[1];
                                    }
                                    else
                                    {
                                        ActualInTime = Convert.ToString(dt.Rows[0]["InTime"]);
                                    }
                                }
                                else
                                {
                                    ActualInTime = Convert.ToString(dt.Rows[0]["InTime"]);
                                }
                            }
                            catch (Exception)
                            {
                                ActualInTime = Convert.ToString(dt.Rows[0]["InTime"]);
                            }
                        }


                        if (OutTime != null && OutTime != "")
                        {
                            string[] Outhours = OutTime.Split(' ');

                            try
                            {
                                if (Outhours[1] != null)
                                {
                                    string[] Outhour = Outhours[1].Split(':');
                                    int Outlen = Outhour[0].Length;

                                    if (Outlen == 1)
                                    {
                                        ActualOutTime = "0" + Outhour[0] + ":" + Outhour[1];
                                    }
                                    else
                                    {
                                        ActualOutTime = Convert.ToString(dt.Rows[0]["OutTime"]);
                                    }
                                }
                                else
                                {
                                    ActualOutTime = Convert.ToString(dt.Rows[0]["OutTime"]);
                                }
                            }
                            catch (Exception)
                            {
                                ActualOutTime = Convert.ToString(dt.Rows[0]["OutTime"]);
                            }
                        }

                        if (dt.Rows.Count > 0)
                        {
                            logDetails = ActualInTime + "~" + Convert.ToString(dt.Rows[0]["OutDate"]) + "~" + ActualOutTime + "~" + Convert.ToString(dt.Rows[0]["IN1"]) + "~" + Convert.ToString(dt.Rows[0]["Out1"]) + "~" + Convert.ToString(dt.Rows[0]["TotalHours"]) + "~" + Convert.ToString(dt.Rows[0]["ShiftHours"]) + "~" + Convert.ToString(dt.Rows[0]["ReqHrs"]) + "~" + RemainingTotalHours + "~" + Convert.ToString(dt.Rows[0]["Remark"]);//Convert.ToString(dt.Rows[0]["AfterAdjTotalHrs"]);
                        }
                        else
                        {
                            logDetails = "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "~";
                        }
                    }
                    else
                    {
                        logDetails = "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "~";
                    }
                }
                catch (Exception)
                {

                    logDetails = "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "~";

                }


                #endregion
            }
            else
            {
                logDetails = "Time Exceed";
            }

            return logDetails;
        }

        public string CalculateTotalHoursForAttendance(string OutDateTime, string InDateTime)
        {
            string TotalHours = "";
            string TH = bllMaster.CalculateTotalHoursForAttendance(OutDateTime, InDateTime);
            string hours = "";
            string minutes = "";
            try
            {
                string[] THrs = TH.Split(':');

                string Hrs = THrs[0];
                string Min = THrs[1];

                if (Hrs != null && Hrs != "")
                {
                    int HrLen = Hrs.Length;


                    if (HrLen == 1)
                    {
                        hours = "0" + Hrs;
                    }
                    else
                    {
                        hours = Hrs;
                    }
                }
                else
                {
                    TotalHours = TH;
                }

                if (Min != null && Min != "")
                {
                    int mnLen = Min.Length;


                    if (mnLen == 1)
                    {
                        minutes = "0" + Min;
                    }
                    else
                    {
                        minutes = Min;
                    }

                }
                else
                {
                    TotalHours = TH;
                }

                TotalHours = hours + ":" + minutes;

            }
            catch (Exception)
            {

                TotalHours = TH;
            }
            return TotalHours;
        }
        public string GetLeavesToDate(string FromDate, int Days)
        {
            string ToDate = bllMaster.GetLeavesToDate(FromDate, Days);
            return ToDate;
        }

        public string getPaidLeaveDetails(string Code)
        {
            string LeaveDetails = "";
            return LeaveDetails;
        }
        public string getlastdate(string FormDate, string LastWorkinDate, string ResignationType)
        {
            string LastLoginDate = string.Empty;
            DataTable dt = bllMaster.GetLastWorkingDate(FormDate, LastWorkinDate, ResignationType);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    LastLoginDate = Convert.ToString(dt.Rows[0]["LastWorkingDate"]) + "~" + Convert.ToString(dt.Rows[0]["NoOfDays"]);
                }
            }
            return LastLoginDate;
        }

        public string GetLastLoginDate(string Code)
        {
            return new bllMaster().GetLastLoginDate(Code);
        }

        public string getDetailsOnCheckList(string UserCode)
        {
            string CheckList = "";
            DataTable dt = bllMaster.GetAllDetailsOnCheckListForNewJoining(UserCode);
            if (dt.Rows.Count > 0)
            {
                CheckList = Convert.ToString(dt.Rows[0]["EmployeeName"]) + "~" + Convert.ToDateTime(dt.Rows[0]["JoiningDate"]).ToString("dd-MMM-yyyy") + "~" + Convert.ToString(dt.Rows[0]["Designation"]) + "~" + Convert.ToString(dt.Rows[0]["Department"] + "~" + Convert.ToString(dt.Rows[0]["CompanyName"]) + "~" + Convert.ToString(dt.Rows[0]["BranchName"]) + "~" + Convert.ToString(dt.Rows[0]["DomainName"]) + "~" + Convert.ToString(dt.Rows[0]["ReportingManager"]));
            }
            return CheckList;
        }

        public void SendNoticePeriodMailToUnitHead(int EmployeeId, Hashtable htParam)
        {
            StringBuilder htmlBody = new StringBuilder();
            DataTable dt = new bllLogin().GetUserInformation(EmployeeId);
            if (dt.Rows.Count > 0)
            {
                int i = 0;
                htmlBody.Append("<table width=\"700px\" style=\"font-family:'Bookman Old Style'; font-size:13px; border-collapse: collapse;\"><tr><td align=\"left\"><b>Dear Sir/Madam,</b></td></tr><tr>");
                htmlBody.Append("<td align=\"left\">" + Convert.ToString(htParam["Subject"]) + " of employee " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["lastName"]) + " has been initiated.</td></tr></table><br />");
                htmlBody.Append("<table border='1' cellspacing='7px' cellpadding='3px' width='700px' style=\"font-family:'Bookman Old Style'; font-size:13px; border-collapse: collapse; border-color: #31374a; border-bottom-width:1px; padding:.625rem .625rem;\" width=\"auto\"><tr><td colspan=\"2\"><center><b>HR Dept</b></center></td></tr>");
                htmlBody.Append("<tr><td align=\"right\" width=\"auto\"><b>Company:</b></td><td align=\"left\"><b>" + Convert.ToString(dt.Rows[i]["CompanyName"]) + "</b></td></tr><tr><td align=\"right\" width=\"180px\"><b>Working Branch:</b></td><td align=\"left\"><b>" + Convert.ToString(dt.Rows[i]["WorkingBranchName"]) + "</b></td></tr><tr><td align=\"right\" width=\"180px\"><b>Code:</b></td><td align=\"left\"><b>" + Convert.ToString(htParam["Code"]) + "</b></td>");
                htmlBody.Append("</tr><tr><td align=\"right\"><b>Date of birth:</b> </td><td align=\"left\">" + Convert.ToDateTime(dt.Rows[i]["DateOfBirth"]).ToString("dd-MMM-yyyy") + " </td>");
                htmlBody.Append("</tr><tr><td align=\"right\"><b>Date of joining :</b> </td><td align=\"left\">" + Convert.ToDateTime(dt.Rows[i]["JoiningDate"]).ToString("dd-MMM-yyyy") + "</td></tr><tr><td align=\"right\"><b>Department :</b> </td><td align=\"left\">" + Convert.ToString(dt.Rows[i]["DepartmentName"]) + "</td></tr>");
                htmlBody.Append("<tr><td align=\"right\"><b>Designation :</b> </td><td align=\"left\">" + Convert.ToString(dt.Rows[i]["DesignationName"]) + "</td></tr>");
                if (Convert.ToString(htParam["ResignationDate"]) == "")
                {
                    if (Convert.ToString(htParam["Subject"]) == "Termination")
                    {
                        htmlBody.Append("<tr><td align=\"right\"><b>Reporting PM :</b> </td><td align=\"left\">" + Convert.ToString(dt.Rows[i]["ReportingManager"]) + "</td></tr><tr><td colspan=\"2\" height=\"40px\" border=\"0\">.</td></tr><tr><td align=\"right\"><b>Resignation Type:</b> </td><td align=\"left\">" + Convert.ToString(htParam["ResignationType"]) + "</td></tr><tr><td align=\"right\"><b>Termination Reasons:</b> </td><td align=\"left\">" + Convert.ToString(htParam["Reasontoterminate"]) + "</td></tr><tr><td align=\"right\"><b>PM Remark:</b> </td><td align=\"left\">" + Convert.ToString(htParam["Remark"]) + "</td></tr><tr><td align=\"right\"><b>Latest Login Date:</b> </td><td align=\"left\">" + Convert.ToDateTime(htParam["LastLoginDate"]).ToString("dd-MMM-yyyy") + " </td></tr>");

                    }
                    else
                    {
                        htmlBody.Append("<tr><td align=\"right\"><b>Reporting PM :</b> </td><td align=\"left\">" + Convert.ToString(dt.Rows[i]["ReportingManager"]) + "</td></tr><tr><td colspan=\"2\" height=\"40px\" border=\"0\">.</td></tr><tr><td align=\"right\"><b>Resignation Type:</b> </td><td align=\"left\">" + Convert.ToString(htParam["ResignationType"]) + "</td></tr><tr><td align=\"right\"><b>PM Remark:</b> </td><td align=\"left\">" + Convert.ToString(htParam["Remark"]) + "</td></tr><tr><td align=\"right\"><b>Latest Login Date:</b> </td><td align=\"left\">" + Convert.ToDateTime(htParam["LastLoginDate"]).ToString("dd-MMM-yyyy") + " </td></tr>");
                    }
                }
                else
                {
                    htmlBody.Append("<tr><td align=\"right\"><b>Reporting PM :</b> </td><td align=\"left\">" + Convert.ToString(dt.Rows[i]["ReportingManager"]) + "</td></tr><tr><td colspan=\"2\" height=\"40px\" border=\"0\">.</td></tr><tr><td align=\"right\"><b>Resignation Type:</b> </td><td align=\"left\">" + Convert.ToString(htParam["ResignationType"]) + "</td></tr><tr><td align=\"right\"><b>PM Remark:</b> </td><td align=\"left\">" + Convert.ToString(htParam["Remark"]) + "</td></tr><tr><td align=\"right\"><b>Notice Period</b> </td><td align=\"left\"> <b>From:-</b> " + Convert.ToDateTime(htParam["ResignationDate"]).ToString("dd-MMM-yyyy") + " <b>To:-</b> " + Convert.ToDateTime(htParam["LastWorkingDate"]).ToString("dd-MMM-yyyy") + "</td></tr><tr><td align=\"right\"><b>No of Days:</b> </td><td align=\"left\">" + Convert.ToString(htParam["NoofDays"]) + " </td></tr><tr><td align=\"right\"><b>Latest Login Date:</b> </td><td align=\"left\">" + Convert.ToDateTime(htParam["LastLoginDate"]).ToString("dd-MMM-yyyy") + " </td></tr>");
                }
                //htmlBody.Append("<tr><td align=\"right\"><b>No of Days:</b> </td><td align=\"left\">" + Convert.ToString(htParam["NoofDays"]) + " </td></tr>");
                htmlBody.Append("</table>");
                htmlBody.Append("<br /><br /><table width=\"700px\"><tr><td align=\"left\">Thanks,<br />HR Department</td></tr><tr><td align=\"center\"><b>!!! This is software generated e-mail...Please do not reply. !!!</td></tr></table>");
                //string UnitHeadEmail = new bllMaster().GetUnitHeadEmail(Convert.ToInt32(htParam["AddedBy"]));
                string UnitHeadEmail = "";
                new bllSendMail().SendStep1EmailForResignationWithAttachment("Notice Period1", UnitHeadEmail, "Step 1:- " + Convert.ToString(htParam["Subject"]) + " has been initiated-User " + Convert.ToString(htParam["Code"]), htmlBody, Convert.ToString(htParam["Attachment"]));
            }
        }

        public string core_GenerateCode_New(string FirstName, string MiddleName, string lastName, string EmployeeType)
        {
            string functionReturnValue = null;
            string txtLName = lastName;
            string txtMName = MiddleName;
            string txtFName = FirstName;
            string FirstGlobal = "abcdefghijklmnopqrstuvwxyz";

            string code = null;
            int i = 0;
            int j = 0;
            int k = 0;

            if (EmployeeType == "Employee")
            {

                //Check for Blanks. Disallow blanks..
                //FirstName For Each Char
                for (i = 0; i < txtFName.Length; i++)
                {
                    if (!string.IsNullOrEmpty(txtMName))
                    {
                        //MiddleName For Each Char
                        for (j = 0; j < txtMName.Length; j++)
                        {
                            //LastName For Each Char
                            for (k = 0; k < txtLName.Length; k++)
                            {
                                code = txtFName.Substring(i, 1) + txtMName.Substring(j, 1) + txtLName.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    i = txtFName.Length + 1;
                                    j = txtMName.Length + 1;
                                    k = txtLName.Length + 1;
                                }
                            }
                        }
                    }
                    else
                    {
                        //LastName For Each Char
                        for (k = 0; k < txtLName.Length; k++)
                        {
                            //Repeat FirstName Character Twice
                            code = txtLName.Substring(k, 1) + txtLName.Substring(k, 1) + txtLName.Substring(k, 1);
                            if (bllMaster.CodeExists(code) != 1)
                            {
                                //i = txtFName.Length + 1;
                                //j = txtMName.Length + 1;
                                k = txtLName.Length + 1;
                            }
                        }
                    }
                }
                if (bllMaster.CodeExists(code) == 1)
                {
                    //FirstName For Each Char
                    for (i = 0; i < txtFName.Length; i++)
                    {
                        if (!string.IsNullOrEmpty(txtMName))
                        {
                            //MiddleName For Each Char
                            for (j = 0; j < txtMName.Length; j++)
                            {
                                //LastName For Each Char
                                for (k = 0; k < txtLName.Length; k++)
                                {
                                    code = txtMName.Substring(j, 1) + txtFName.Substring(i, 1) + txtLName.Substring(k, 1);
                                    if (bllMaster.CodeExists(code) != 1)
                                    {
                                        i = txtFName.Length + 1;
                                        j = txtMName.Length + 1;
                                        k = txtLName.Length + 1;
                                    }
                                }
                            }
                        }
                        else
                        {
                            //LastName For Each Char
                            for (k = 0; k < txtMName.Length; k++)
                            {
                                //Repeat LastName Character Twice
                                code = txtMName.Substring(k, 1) + txtMName.Substring(k, 1) + txtMName.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    //i = txtFName.Length + 1;
                                    //j = txtMName.Length + 1;
                                    k = txtMName.Length + 1;
                                }
                            }
                        }
                    }
                }
                if (bllMaster.CodeExists(code) == 1)
                {
                    //LastName For Each Char
                    for (i = 0; i < txtLName.Length; i++)
                    {
                        if (!string.IsNullOrEmpty(txtMName))
                        {
                            //MiddleName For Each Char
                            for (j = 0; j < txtMName.Length; j++)
                            {
                                //FirstName For Each Char
                                for (k = 0; k < txtFName.Length; k++)
                                {
                                    code = txtLName.Substring(i, 1) + txtMName.Substring(j, 1) + txtFName.Substring(k, 1);
                                    if (bllMaster.CodeExists(code) != 1)
                                    {
                                        i = txtLName.Length + 1;
                                        j = txtMName.Length + 1;
                                        k = txtFName.Length + 1;
                                    }
                                }
                            }
                        }
                        else
                        {
                            for (k = 0; k < txtFName.Length; k++)
                            {
                                //Repeat LastName Character Twice
                                code = txtFName.Substring(k, 1) + txtFName.Substring(k, 1) + txtFName.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    //i = txtFName.Length + 1;
                                    //j = txtMName.Length + 1;
                                    k = txtFName.Length + 1;
                                }
                            }
                        }
                    }
                }
                if (bllMaster.CodeExists(code) == 1)
                {
                    //LastName For Each Char
                    for (i = 0; i < txtLName.Length; i++)
                    {
                        if (!string.IsNullOrEmpty(txtMName))
                        {
                            //MiddleName For Each Char
                            for (j = 0; j < txtMName.Length; j++)
                            {
                                //FirstName For Each Char
                                for (k = 0; k < txtFName.Length; k++)
                                {
                                    code = txtMName.Substring(j, 1) + txtLName.Substring(i, 1) + txtFName.Substring(k, 1);
                                    if (bllMaster.CodeExists(code) != 1)
                                    {
                                        i = txtLName.Length + 1;
                                        j = txtMName.Length + 1;
                                        k = txtFName.Length + 1;
                                    }
                                }
                            }
                        }
                        else
                        {
                            for (k = 0; k < txtLName.Length; k++)
                            {
                                //Repeat FirstName Character Twice
                                code = txtLName.Substring(k, 1) + txtLName.Substring(k, 1) + txtLName.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    //i = txtFName.Length + 1;
                                    //j = txtMName.Length + 1;
                                    k = txtLName.Length + 1;
                                }
                            }
                        }
                    }
                }

                if (bllMaster.CodeExists(code) == 1)
                {
                    //LastName For Each Char
                    for (i = 0; i < FirstGlobal.Length; i++)
                    {
                        //MiddleName For Each Char
                        for (j = 0; j < FirstGlobal.Length; j++)
                        {
                            //FirstName For Each Char
                            for (k = 0; k < FirstGlobal.Length; k++)
                            {
                                code = FirstGlobal.Substring(j, 1) + FirstGlobal.Substring(i, 1) + FirstGlobal.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    i = FirstGlobal.Length + 1;
                                    j = FirstGlobal.Length + 1;
                                    k = FirstGlobal.Length + 1;
                                }
                            }
                        }
                    }
                }
                if (bllMaster.CodeExists(code) == 1)
                {
                    //LastName For Each Char
                    for (i = 0; i < FirstGlobal.Length; i++)
                    {
                        //MiddleName For Each Char
                        for (j = FirstGlobal.Length - 1; j > 0; j--)
                        {
                            //FirstName For Each Char
                            for (k = 0; k < FirstGlobal.Length; k++)
                            {
                                code = FirstGlobal.Substring(j, 1) + FirstGlobal.Substring(i, 1) + FirstGlobal.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    i = FirstGlobal.Length + 1;
                                    j = 0;
                                    k = FirstGlobal.Length + 1;
                                }
                            }
                        }
                    }
                }
                if (bllMaster.CodeExists(code) != 1)
                {
                    functionReturnValue = code;
                }
                else
                {
                    functionReturnValue = "";
                    //Interaction.MsgBox("System Is Unable To Generate Code...", MsgBoxStyle.OkOnly + MsgBoxStyle.Critical, "Code Generator");
                }
                // return functionReturnValue;
            }
            else if (EmployeeType == "Consultant")
            {

                //Check for Blanks. Disallow blanks..
                //FirstName For Each Char
                for (i = 1; i <= 9; i++)
                {
                    //MiddleName For Each Char
                    for (j = 0; j < txtFName.Length; j++)
                    {
                        //LastName For Each Char
                        for (k = 0; k < txtLName.Length; k++)
                        {
                            code = i + txtFName.Substring(j, 1) + txtLName.Substring(k, 1);
                            if (bllMaster.CodeExists(code) != 1)
                            {
                                i = 9 + 1;
                                j = txtFName.Length + 1;
                                k = txtLName.Length + 1;
                            }
                        }
                    }
                }
                if (bllMaster.CodeExists(code) == 1)
                {
                    for (i = 1; i <= 9; i++)
                    {
                        //MiddleName For Each Char
                        for (j = 0; j < txtFName.Length; j++)
                        {
                            //LastName For Each Char
                            for (k = 0; k < txtLName.Length; k++)
                            {
                                code = i + txtFName.Substring(j, 1) + txtLName.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    i = 9 + 1;
                                    j = txtFName.Length + 1;
                                    k = txtLName.Length + 1;
                                }
                            }
                        }
                    }
                }
                if (bllMaster.CodeExists(code) == 1)
                {
                    for (i = 1; i <= 9; i++)
                    {
                        //MiddleName For Each Char
                        for (j = 0; j < txtMName.Length; j++)
                        {
                            //LastName For Each Char
                            for (k = 0; k < txtLName.Length; k++)
                            {
                                code = i + txtMName.Substring(j, 1) + txtLName.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    i = 9 + 1;
                                    j = txtMName.Length + 1;
                                    k = txtLName.Length + 1;
                                }
                            }
                        }
                    }
                }
                if (bllMaster.CodeExists(code) == 1)
                {
                    for (i = 1; i <= 9; i++)
                    {
                        //MiddleName For Each Char
                        for (j = 0; j < txtMName.Length; j++)
                        {
                            //LastName For Each Char
                            for (k = 0; k < txtFName.Length; k++)
                            {
                                code = i + txtMName.Substring(j, 1) + txtFName.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    i = 9 + 1;
                                    j = txtMName.Length + 1;
                                    k = txtFName.Length + 1;
                                }
                            }
                        }
                    }
                }
                if (bllMaster.CodeExists(code) == 1)
                {
                    for (i = 1; i <= 9; i++)
                    {
                        //MiddleName For Each Char
                        for (j = 0; j < txtLName.Length; j++)
                        {
                            //LastName For Each Char
                            for (k = 0; k < txtFName.Length; k++)
                            {
                                code = i + txtLName.Substring(j, 1) + txtFName.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    i = 9 + 1;
                                    j = txtLName.Length + 1;
                                    k = txtFName.Length + 1;
                                }
                            }
                        }
                    }
                }
                if (bllMaster.CodeExists(code) == 1)
                {
                    for (i = 0; i <= 9; i++)
                    {
                        //MiddleName For Each Char
                        for (j = 0; j < txtLName.Length; j++)
                        {
                            //LastName For Each Char
                            for (k = 0; k < txtMName.Length; k++)
                            {
                                code = i + txtLName.Substring(j, 1) + txtFName.Substring(k, 1);
                                if (bllMaster.CodeExists(code) != 1)
                                {
                                    i = 9 + 1;
                                    j = txtLName.Length + 1;
                                    k = txtMName.Length + 1;
                                }
                            }
                        }
                    }
                }

                if (bllMaster.CodeExists(code) != 1)
                {
                    functionReturnValue = code;
                }
                else
                {
                    functionReturnValue = "";
                    //Interaction.MsgBox("System Is Unable To Generate Code...", MsgBoxStyle.OkOnly + MsgBoxStyle.Critical, "Code Generator");
                }

            }
            return functionReturnValue;
        }

        public string getCutoffTime(string Shift)
        {
            string cutoffTimne = bllMaster.GetCutOffTime(Shift);
            return cutoffTimne;

        }

        public string getLogDatesForTimeExceed(string Code, string Date, int EmpID)
        {
            string logDetails = "";
            string RemainingTotalHours = "";
            DataTable dts = bllMaster.GetEmployeeExtraHours(Code);

            DateTime InDate = Convert.ToDateTime(Date);
            string ToDaysDate = DateTime.Now.ToString("dd-MMM-yyyy");
            TimeSpan difference = Convert.ToDateTime(ToDaysDate) - InDate;
            var days = difference.TotalDays;
            int DaysNo = Convert.ToInt32(days);

            //if (DaysNo >= 11 && (EmpID != 12 && EmpID != 165 && EmpID != 199 && EmpID != 285))
            //{
            #region Calculation
            if (dts.Rows.Count > 0)
                RemainingTotalHours = Convert.ToString(dts.Rows[0]["RemainingTotalHours"]);
            else
                RemainingTotalHours = "00:00";

            DataTable dt = bllMaster.GetCodeDate(Code, Date);

            try
            {
                if (dt.Rows.Count > 0)
                {
                    string InTime = Convert.ToString(dt.Rows[0]["InTime"]);
                    string OutTime = Convert.ToString(dt.Rows[0]["OutTime"]);
                    string ActualInTime = "";
                    string ActualOutTime = "";

                    if (InTime != null && InTime != "")
                    {
                        try
                        {
                            string[] Inhours = InTime.Split(' ');

                            if (Inhours[1] != null)
                            {
                                string[] Inhour = Inhours[1].Split(':');
                                int inlen = Inhour[0].Length;

                                if (inlen == 1)
                                {
                                    ActualInTime = "0" + Inhour[0] + ":" + Inhour[1];
                                }
                                else
                                {
                                    ActualInTime = Convert.ToString(dt.Rows[0]["InTime"]);
                                }
                            }
                            else
                            {
                                ActualInTime = Convert.ToString(dt.Rows[0]["InTime"]);
                            }
                        }
                        catch (Exception)
                        {
                            ActualInTime = Convert.ToString(dt.Rows[0]["InTime"]);
                        }
                    }


                    if (OutTime != null && OutTime != "")
                    {
                        string[] Outhours = OutTime.Split(' ');

                        try
                        {
                            if (Outhours[1] != null)
                            {
                                string[] Outhour = Outhours[1].Split(':');
                                int Outlen = Outhour[0].Length;

                                if (Outlen == 1)
                                {
                                    ActualOutTime = "0" + Outhour[0] + ":" + Outhour[1];
                                }
                                else
                                {
                                    ActualOutTime = Convert.ToString(dt.Rows[0]["OutTime"]);
                                }
                            }
                            else
                            {
                                ActualOutTime = Convert.ToString(dt.Rows[0]["OutTime"]);
                            }
                        }
                        catch (Exception)
                        {
                            ActualOutTime = Convert.ToString(dt.Rows[0]["OutTime"]);
                        }
                    }

                    if (dt.Rows.Count > 0)
                    {
                        logDetails = ActualInTime + "~" + Convert.ToString(dt.Rows[0]["OutDate"]) + "~" + ActualOutTime + "~" + Convert.ToString(dt.Rows[0]["IN1"]) + "~" + Convert.ToString(dt.Rows[0]["Out1"]) + "~" + Convert.ToString(dt.Rows[0]["TotalHours"]) + "~" + Convert.ToString(dt.Rows[0]["ShiftHours"]) + "~" + Convert.ToString(dt.Rows[0]["ReqHrs"]) + "~" + RemainingTotalHours + "~" + DaysNo;//Convert.ToString(dt.Rows[0]["AfterAdjTotalHrs"]);
                    }
                    else
                    {
                        logDetails = "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~";
                    }
                }
                else
                {
                    logDetails = "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~";
                }
            }
            catch (Exception)
            {
                logDetails = "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~" + "" + "~";
            }


            #endregion
            //}
            //else
            //{
            //    logDetails = "Time Exceed";
            //}
            return logDetails;
        }

        #region Code Generation

        public string GenerateCode_New(string firstName, string middleName, string lastName, string employeeType)
        {
            firstName = firstName ?? "";
            middleName = middleName ?? "";
            lastName = lastName ?? "";

            IEnumerable<string> candidates = Enumerable.Empty<string>();

            if (employeeType == "Employee")
            {
                candidates = GetEmployeeCodes(firstName, middleName, lastName);
            }
            else if (employeeType == "Consultant")
            {
                candidates = GetConsultantCodes(firstName, middleName, lastName);
            }

            HashSet<string> existingCodes = new bllMaster().GetAllExistingCodes();

            foreach (string code in candidates)
            {
                if (!existingCodes.Contains(code))
                {
                    return code;
                }
            }

            return "";
        }

        private IEnumerable<string> GetEmployeeCodes(string first, string middle, string last)
        {
            const string letters = "abcdefghijklmnopqrstuvwxyz";

            if (!string.IsNullOrEmpty(middle))
            {
                foreach (var code in Combine(first, middle, last)) yield return code;
                foreach (var code in Combine(middle, first, last)) yield return code;
                foreach (var code in Combine(last, middle, first)) yield return code;
                foreach (var code in Combine(middle, last, first)) yield return code;
            }
            else
            {
                foreach (char c in last) yield return $"{c}{c}{c}";
                foreach (char c in first) yield return $"{c}{c}{c}";
            }
            foreach (var code in Combine(letters, letters, letters)) yield return code;
            for
                (int i = 0; i < letters.Length; i++)
            {
                for (int j = letters.Length - 1; j >= 0; j--)
                {
                    for (int k = 0; k < letters.Length; k++)
                    {
                        yield return $"{letters[j]}{letters[i]}{letters[k]}";
                    }
                }
            }
        }

        private IEnumerable<string> GetConsultantCodes(string first, string middle, string last)
        {
            foreach (var code in CombineWithDigit(first, last)) yield return code;
            foreach (var code in CombineWithDigit(first, last)) yield return code;

            if (!string.IsNullOrEmpty(middle))
            {
                foreach (var code in CombineWithDigit(middle, last)) yield return code;
                foreach (var code in CombineWithDigit(middle, first)) yield return code;
                foreach (var code in CombineWithDigit(last, first)) yield return code;
                foreach (var code in CombineWithDigitFromZero(last, middle)) yield return code;
            }
            else
            {
                foreach (var code in CombineWithDigit(last, first)) yield return code;
            }
        }

        //private IEnumerable<string> GetEmployeeCodes(string first, string middle, string last)
        //{
        //    const string letters = "abcdefghijklmnopqrstuvwxyz";

        //    if (!string.IsNullOrEmpty(middle))
        //    {
        //        foreach (var code in Combine(first, middle, last)) yield return code;
        //        foreach (var code in Combine(middle, first, last)) yield return code;
        //        foreach (var code in Combine(last, middle, first)) yield return code;
        //        foreach (var code in Combine(middle, last, first)) yield return code;
        //    }
        //    else
        //    {
        //        foreach (char c in last) yield return $"{c}{c}{c}";
        //        foreach (char c in first) yield return $"{c}{c}{c}";
        //    }

        //    foreach (var code in Combine(letters, letters, letters))
        //        yield return code;

        //    for (int i = 0; i < letters.Length; i++)
        //    {
        //        for (int j = letters.Length - 1; j >= 0; j--)
        //        {
        //            for (int k = 0; k < letters.Length; k++)
        //            {
        //                yield return $"{letters[j]}{letters[i]}{letters[k]}";
        //            }
        //        }
        //    }
        //}

        //private IEnumerable<string> GetConsultantCodes(string first, string middle, string last)
        //{
        //    foreach (var code in CombineWithDigit(first, last)) yield return code;
        //    foreach (var code in CombineWithDigit(first, last)) yield return code; // kept to preserve original order

        //    if (!string.IsNullOrEmpty(middle))
        //    {
        //        foreach (var code in CombineWithDigit(middle, last)) yield return code;
        //        foreach (var code in CombineWithDigit(middle, first)) yield return code;
        //        foreach (var code in CombineWithDigit(last, first)) yield return code;
        //        foreach (var code in CombineWithDigitFromZero(last, middle)) yield return code;
        //    }
        //    else
        //    {
        //        foreach (var code in CombineWithDigit(last, first)) yield return code;
        //    }
        //}

        private IEnumerable<string> Combine(string a, string b, string c)
        {
            foreach (char x in a)
                foreach (char y in b)
                    foreach (char z in c)
                        yield return $"{x}{y}{z}";
        }

        private IEnumerable<string> CombineWithDigit(string a, string b)
        {
            for (int i = 1; i <= 9; i++)
                foreach (char x in a)
                    foreach (char y in b)
                        yield return $"{i}{x}{y}";
        }

        private IEnumerable<string> CombineWithDigitFromZero(string a, string b)
        {
            for (int i = 0; i <= 9; i++)
                foreach (char x in a)
                    foreach (char y in b)
                        yield return $"{i}{x}{y}";
        }

        [WebMethod]
        public string genrateCode_Vendor(string FirstName, string MiddleName, string lastName, string EmployeeType)
        {

            string functionReturnValue = null;
            string txtLName = lastName;
            string txtMName = MiddleName;
            string txtFName = FirstName;
            string FirstGlobal = "abcdefghijklmnopqrstuvwxyz";

            string code = null;
            int i = 0;
            int j = 0;
            int k = 0;
            int l = 0;

            //FirstName For Each Char
            for (i = 0; i < txtFName.Length; i++)
            {
                if (!string.IsNullOrEmpty(txtMName))
                {
                    //MiddleName For Each Char
                    for (j = 0; j < txtMName.Length; j++)
                    {
                        //LastName For Each Char
                        for (k = 0; k < txtLName.Length; k++)
                        {
                            if (EmployeeType == "Admin")
                            {
                                for (l = 1; l <= 1; l++)
                                {
                                    //code = txtFName.Substring(i, 1) + txtMName.Substring(j, 1) + txtLName.Substring(k, 1) + l;
                                    code = txtFName.Substring(j, 1) + txtLName.Substring(k, 1) + l;
                                    if (new bllTracking().CodeExists(code) != 1)
                                    {
                                        l = 1 + 1;
                                        //i = txtFName.Length + 1;
                                        j = txtMName.Length + 1;
                                        k = txtLName.Length + 1;
                                    }
                                }
                            }
                            else
                            {
                                for (l = 2; l < 9; l++)
                                {
                                    //code = txtFName.Substring(i, 1) + txtMName.Substring(j, 1) + txtLName.Substring(k, 1) + l;
                                    code = txtFName.Substring(j, 1) + txtLName.Substring(k, 1) + l;
                                    if (new bllTracking().CodeExists(code) != 1)
                                    {
                                        l = 9 + 1;
                                        //i = txtFName.Length + 1;
                                        j = txtMName.Length + 1;
                                        k = txtLName.Length + 1;
                                    }
                                }
                            }

                        }
                    }
                }
                else
                {
                    //LastName For Each Char
                    for (k = 0; k < txtLName.Length; k++)
                    {
                        //Repeat FirstName Character Twice
                        // code = txtLName.Substring(k, 1) + txtLName.Substring(k, 1) + txtLName.Substring(k, 1);
                        code = txtLName.Substring(k, 1) + txtLName.Substring(k, 1);
                        if (new bllTracking().CodeExists(code) != 1)
                        {
                            //i = txtFName.Length + 1;
                            //j = txtMName.Length + 1;
                            k = txtLName.Length + 1;
                        }
                    }
                }
            }
            if (new bllTracking().CodeExists(code) == 1)
            {
                //FirstName For Each Char
                for (i = 0; i < txtFName.Length; i++)
                {
                    if (!string.IsNullOrEmpty(txtMName))
                    {
                        //MiddleName For Each Char
                        for (j = 0; j < txtMName.Length; j++)
                        {
                            //LastName For Each Char
                            for (k = 0; k < txtLName.Length; k++)
                            {
                                if (EmployeeType == "Admin")
                                {
                                    for (l = 1; l <= 1; l++)
                                    {
                                        /// code = txtMName.Substring(j, 1) + txtFName.Substring(i, 1) + txtLName.Substring(k, 1) + l;
                                        code = txtFName.Substring(i, 1) + txtLName.Substring(k, 1) + l;
                                        if (new bllTracking().CodeExists(code) != 1)
                                        {
                                            l = 1 + 1;
                                            i = txtFName.Length + 1;
                                            //  j = txtMName.Length + 1;
                                            k = txtLName.Length + 1;
                                        }
                                    }
                                }
                                else
                                {
                                    for (l = 2; l < 9; l++)
                                    {
                                        //code = txtMName.Substring(j, 1) + txtFName.Substring(i, 1) + txtLName.Substring(k, 1) + l;
                                        code = txtFName.Substring(i, 1) + txtLName.Substring(k, 1) + l;
                                        if (new bllTracking().CodeExists(code) != 1)
                                        {
                                            l = 9 + 1;
                                            i = txtFName.Length + 1;
                                            // j = txtMName.Length + 1;
                                            k = txtLName.Length + 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        //LastName For Each Char
                        for (k = 0; k < txtMName.Length; k++)
                        {
                            //Repeat LastName Character Twice
                            //code = txtMName.Substring(k, 1) + txtMName.Substring(k, 1) + txtMName.Substring(k, 1);
                            code = txtMName.Substring(k, 1) + txtMName.Substring(k, 1);
                            if (new bllTracking().CodeExists(code) != 1)
                            {
                                //i = txtFName.Length + 1;
                                //j = txtMName.Length + 1;
                                k = txtMName.Length + 1;
                            }
                        }
                    }
                }
            }
            if (new bllTracking().CodeExists(code) == 1)
            {
                //LastName For Each Char
                for (i = 0; i < txtLName.Length; i++)
                {
                    if (!string.IsNullOrEmpty(txtMName))
                    {
                        //MiddleName For Each Char
                        for (j = 0; j < txtMName.Length; j++)
                        {
                            //FirstName For Each Char
                            for (k = 0; k < txtFName.Length; k++)
                            {
                                if (EmployeeType == "Admin")
                                {
                                    for (l = 1; l <= 1; l++)
                                    {
                                        // code = txtLName.Substring(i, 1) + txtMName.Substring(j, 1) + txtFName.Substring(k, 1) + l;
                                        code = txtLName.Substring(i, 1) + txtFName.Substring(k, 1) + l;
                                        if (new bllTracking().CodeExists(code) != 1)
                                        {
                                            l = 1 + 1;
                                            i = txtLName.Length + 1;
                                            //j = txtMName.Length + 1;
                                            k = txtFName.Length + 1;
                                        }
                                    }
                                }
                                else
                                {
                                    for (l = 2; l < 9; l++)
                                    {
                                        // code = txtLName.Substring(i, 1) + txtMName.Substring(j, 1) + txtFName.Substring(k, 1) + l;
                                        code = txtLName.Substring(i, 1) + txtFName.Substring(k, 1) + l;
                                        if (new bllTracking().CodeExists(code) != 1)
                                        {
                                            l = 9 + 1;
                                            i = txtLName.Length + 1;
                                            // j = txtMName.Length + 1;
                                            k = txtFName.Length + 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        for (k = 0; k < txtFName.Length; k++)
                        {
                            //Repeat LastName Character Twice
                            //code = txtFName.Substring(k, 1) + txtFName.Substring(k, 1) + txtFName.Substring(k, 1);

                            code = txtFName.Substring(k, 1) + txtFName.Substring(k, 1);

                            if (new bllTracking().CodeExists(code) != 1)
                            {
                                //i = txtFName.Length + 1;
                                //j = txtMName.Length + 1;
                                k = txtFName.Length + 1;
                            }
                        }
                    }
                }
            }
            if (new bllTracking().CodeExists(code) == 1)
            {
                //LastName For Each Char
                for (i = 0; i < txtLName.Length; i++)
                {
                    if (!string.IsNullOrEmpty(txtMName))
                    {
                        //MiddleName For Each Char
                        for (j = 0; j < txtMName.Length; j++)
                        {
                            //FirstName For Each Char
                            for (k = 0; k < txtFName.Length; k++)
                            {
                                if (EmployeeType == "Admin")
                                {
                                    for (l = 1; l <= 1; l++)
                                    {
                                        //code = txtMName.Substring(j, 1) + txtLName.Substring(i, 1) + txtFName.Substring(k, 1) + l;
                                        code = txtLName.Substring(j, 1) + txtFName.Substring(k, 1) + l;

                                        if (new bllTracking().CodeExists(code) != 1)
                                        {
                                            l = 1 + 1;
                                            // i = txtLName.Length + 1;
                                            j = txtMName.Length + 1;
                                            k = txtFName.Length + 1;
                                        }
                                    }
                                }
                                else
                                {
                                    for (l = 2; l < 9; l++)
                                    {
                                        // code = txtMName.Substring(j, 1) + txtLName.Substring(i, 1) + txtFName.Substring(k, 1) + l;
                                        code = txtLName.Substring(j, 1) + txtFName.Substring(k, 1) + l;
                                        if (new bllTracking().CodeExists(code) != 1)
                                        {
                                            l = 9 + 1;
                                            // i = txtLName.Length + 1;
                                            j = txtMName.Length + 1;
                                            k = txtFName.Length + 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        for (k = 0; k < txtLName.Length; k++)
                        {
                            //Repeat FirstName Character Twice
                            code = txtLName.Substring(k, 1) + txtLName.Substring(k, 1);
                            if (new bllTracking().CodeExists(code) != 1)
                            {
                                //i = txtFName.Length + 1;
                                //j = txtMName.Length + 1;
                                k = txtLName.Length + 1;
                            }
                        }
                    }
                }
            }

            if (new bllTracking().CodeExists(code) == 1)
            {
                //LastName For Each Char
                for (i = 0; i < FirstGlobal.Length; i++)
                {
                    //MiddleName For Each Char
                    for (j = 0; j < FirstGlobal.Length; j++)
                    {
                        //FirstName For Each Char
                        for (k = 0; k < FirstGlobal.Length; k++)
                        {
                            if (EmployeeType == "Admin")
                            {
                                for (l = 1; l <= 1; l++)
                                {
                                    //code = FirstGlobal.Substring(j, 1) + FirstGlobal.Substring(i, 1) + FirstGlobal.Substring(k, 1) + l;
                                    code = FirstGlobal.Substring(j, 1) + FirstGlobal.Substring(k, 1) + l;
                                    if (new bllTracking().CodeExists(code) != 1)
                                    {
                                        l = 1 + 1;
                                        i = FirstGlobal.Length + 1;
                                        // j = FirstGlobal.Length + 1;
                                        k = FirstGlobal.Length + 1;
                                    }
                                }
                            }
                            else
                            {
                                for (l = 2; l < 9; l++)
                                {
                                    // code = FirstGlobal.Substring(j, 1) + FirstGlobal.Substring(i, 1) + FirstGlobal.Substring(k, 1) + l;

                                    code = FirstGlobal.Substring(j, 1) + FirstGlobal.Substring(k, 1) + l;
                                    if (new bllTracking().CodeExists(code) != 1)
                                    {
                                        l = 9 + 1;
                                        i = FirstGlobal.Length + 1;
                                        // j = FirstGlobal.Length + 1;
                                        k = FirstGlobal.Length + 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (new bllTracking().CodeExists(code) == 1)
            {
                //LastName For Each Char
                for (i = 0; i < FirstGlobal.Length; i++)
                {
                    //MiddleName For Each Char
                    for (j = FirstGlobal.Length - 1; j > 0; j--)
                    {
                        //FirstName For Each Char
                        for (k = 0; k < FirstGlobal.Length; k++)
                        {
                            if (EmployeeType == "Admin")
                            {
                                for (l = 1; l <= 1; l++)
                                {
                                    // code = FirstGlobal.Substring(j, 1) + FirstGlobal.Substring(i, 1) + FirstGlobal.Substring(k, 1) + l;
                                    code = FirstGlobal.Substring(i, 1) + FirstGlobal.Substring(k, 1) + l;

                                    if (new bllTracking().CodeExists(code) != 1)
                                    {
                                        l = 1 + 1;
                                        i = FirstGlobal.Length + 1;
                                        //j = 0;
                                        k = FirstGlobal.Length + 1;
                                    }
                                }
                            }
                            else
                            {
                                for (l = 2; l < 9; l++)
                                {
                                    // code = FirstGlobal.Substring(j, 1) + FirstGlobal.Substring(i, 1) + FirstGlobal.Substring(k, 1) + l;
                                    code = FirstGlobal.Substring(i, 1) + FirstGlobal.Substring(k, 1) + l;

                                    if (new bllTracking().CodeExists(code) != 1)
                                    {
                                        l = 9 + 1;
                                        i = FirstGlobal.Length + 1;
                                        // j = 0;
                                        k = FirstGlobal.Length + 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (new bllTracking().CodeExists(code) != 1)
            {
                functionReturnValue = code;
            }
            else
            {
                functionReturnValue = "";
            }
            return functionReturnValue;
        }

        #endregion

        public string CheckUserExist(string Code)
        {
            int ReturnValue = new bllVendors().CheckUserExist(Code);
            return Convert.ToString(ReturnValue);
        }

    }
}
