using Microsoft.Office.Interop.Word;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using DataTable = System.Data.DataTable;
using MailMessage = System.Net.Mail.MailMessage;

namespace WebPortal.Admin
{
    public partial class UserLeaves : System.Web.UI.Page
    {
        bllMaster bllMaster = new bllMaster();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                BindUsersForLeaves();
            }
            //  BindUserLeaves();
        }

        [WebMethod]
        public static string BindUserLeaves()
        {
            DataTable dt1 = new bllMaster().GetAllLeavesbyPM(Convert.ToInt32(HttpContext.Current.User.Identity.Name));
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
        public static int UpdateLeaveStatus(int LeaveID, string Status, string Comment)
        {
            int leaveid = LeaveID;
            string status = Status;
            bool leavestatus = status == "Approve" ? true : false;
            string comment = Comment;
            int returnvalue = new bllMaster().UpdateUserLeaves(LeaveID, leavestatus, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), comment, "");
            if (returnvalue > 0)
            {
                new bllSendMail().UserLeavesApprovedToUser(LeaveID, status, Comment, 235);
                return 1;
            }
            else
            {
                return 0;
            }
            //
        }

        [WebMethod]
        public static decimal getPendingLeaveCount(string Code)
        {
            decimal LeaveCount = new bllMaster().GetPendingLeaveCount(Code);
            return LeaveCount;
        }

        protected void ddlUserLeaves_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable dt = bllMaster.GetLeaveDetails(Convert.ToString(ddlUserLeaves.SelectedValue.Substring(0, 3)));

            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    lblTotalLeavesPM.Text = Convert.ToString(dt.Rows[0]["TotalLeaves"]);
                    lblAppliedLeavesPM.Text = Convert.ToString(dt.Rows[0]["AppliedLeaves"]);
                    lblPendingLeavesPM.Text = Convert.ToString(dt.Rows[0]["PendingLeaves"]);
                    //lblPendingLeavesLastYearPM.Text = Convert.ToString(dt.Rows[0]["LastYearPendingLeaves"]);

                }
            }

            int EmpId = bllMaster.GetEmployeeIdFromCode(Convert.ToString(ddlUserLeaves.SelectedValue.Substring(0, 3)));
            DataTable dtCheck = new bllLogin().GetUserInformation(EmpId);
            if (dtCheck.Rows.Count > 0)
            {
                string CutOffTime = Convert.ToString(dtCheck.Rows[0]["CutOffTime"]);
                if (CutOffTime != "")
                {
                    int CutOff = Convert.ToInt32(Convert.ToString(CutOffTime).Substring(0, 2));
                    if (CutOff >= 16)
                    {
                        if (Convert.ToInt32(DateTime.Now.ToString("HH")) <= 07)
                            CalendarExtender2.StartDate = DateTime.Now;
                        else
                            CalendarExtender2.StartDate = DateTime.Now.AddDays(1);
                    }
                    else
                    {
                        CalendarExtender2.StartDate = DateTime.Now.AddDays(1);
                    }
                }
            }
            if (Convert.ToString(dtCheck.Rows[0]["SubDomain"]) == "Credit" || Convert.ToString(dtCheck.Rows[0]["SubDomain"]) == "Servicing" || Convert.ToInt32(dtCheck.Rows[0]["WorkingBranch"]) == 11 || Convert.ToInt32(dtCheck.Rows[0]["WorkingBranch"]) == 3)
            {
                tblLeavesPM.Style.Add("display", "");
                trpaid.Style.Add("display", "");
                double noofmonths = DateTime.Now.Subtract(Convert.ToDateTime(dtCheck.Rows[0]["JoiningDate"])).Days / (365.25 / 12);
                if (Convert.ToInt32(noofmonths) >= 6)
                {
                    trpaid.Style.Add("display", "");
                }
                else
                {
                    trpaid.Style.Add("display", "none");
                    tblLeavesPM.Style.Add("display", "none");
                }
            }
            else
            {
                tblLeavesPM.Style.Add("display", "none");
                trpaid.Style.Add("display", "none");
            }

        }

        public void BindUsersForLeaves()
        {
            string NewCode = bllMaster.GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = bllMaster.GetAllUserByPM(NewCode);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        ddlUserLeaves.Items.Add(new ListItem(Convert.ToString(dt.Rows[i]["Code"]) + " : " + Convert.ToString(dt.Rows[i]["NAME"])));
                    }
                }
            }

            ddlUserLeaves.Items.Insert(0, new ListItem("Select"));
        }

        [WebMethod]
        public static int InsertLeave(string Code, int Days, string FromDate, string ToDate, string Reason, string InformType, string PaidStatus)
        {
            int returnvalue = 0;
            Hashtable htTeamLeaves = new Hashtable();
            htTeamLeaves.Add("Code", Code);
            htTeamLeaves.Add("ForDays", Days);
            htTeamLeaves.Add("LeaveFrom", FromDate);
            htTeamLeaves.Add("LeaveTo", ToDate);
            htTeamLeaves.Add("ReasonForLeave", Reason);
            htTeamLeaves.Add("InformType", InformType);
            htTeamLeaves.Add("ApprovedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htTeamLeaves.Add("ApprovalRemark", Reason);
            htTeamLeaves.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue = new bllMaster().InsertTeamLeavesByPM(htTeamLeaves);
            if (returnvalue > 0)
            {
                if (PaidStatus == "Paid")
                    new bllMaster().InsertPaidLeavePM(htTeamLeaves, returnvalue, PaidStatus);
                UserLeaveEmail(Code, Days, FromDate, ToDate, Reason, InformType, PaidStatus);
            }
            return returnvalue;
        }

        protected void btnUserLeaves_Click(object sender, EventArgs e)
        {
            if (txtUserToDate.Text.Trim() != "")
            {
                if (ddlPaidUnpaid.SelectedValue == "Paid")
                {
                    if (lblPendingLeavesPM.Text != "" && lblPendingLeavesPM.Text != "-")
                    {
                        if (Convert.ToDecimal(ddlUserDays.SelectedValue) > Convert.ToDecimal(lblPendingLeavesPM.Text))
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "HideLabel();", true);
                            return;
                        }
                    }
                }
                ViewState["FromDate"] = (Request.Form[txtUserFromDate.UniqueID]).Trim();
                Hashtable htTeamLeaves = new Hashtable();

                string Code = ddlUserLeaves.SelectedItem.Text;
                string usercode = Code.Substring(0, 3);
                string OffEmailID = "";
                int EmployeeId = new bllMaster().GetEmployeeIdFromCode(usercode);
                DataTable dtuser = new bllLogin().GetUserInformation(EmployeeId);

                if (dtuser.Rows.Count > 0)
                {
                    OffEmailID = null;

                    if (OffEmailID == string.Empty || OffEmailID == null || OffEmailID == "")
                        OffEmailID = "Soft-Team@infinityinternationals.us";
                    else
                        OffEmailID = Convert.ToString(dtuser.Rows[0]["OfficialEmailID"]);
                }
                else
                {
                    OffEmailID = "";
                }

                htTeamLeaves.Add("Code", usercode);
                htTeamLeaves.Add("ForDays", ddlUserDays.SelectedValue);
                htTeamLeaves.Add("LeaveFrom", (Request.Form[txtUserFromDate.UniqueID]).Trim());
                htTeamLeaves.Add("LeaveTo", (Request.Form[txtUserToDate.UniqueID]).Trim());
                htTeamLeaves.Add("ReasonForLeave", txtUserReason.Text.Trim());
                htTeamLeaves.Add("InformType", ddlUserLeaveType.SelectedValue);
                htTeamLeaves.Add("ApprovedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                htTeamLeaves.Add("ApprovalRemark", txtUserReason.Text.Trim());
                htTeamLeaves.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                int ReturnValue = bllMaster.InsertTeamLeavesByPM(htTeamLeaves);

                if (ReturnValue > 0)
                {
                    if (ddlPaidUnpaid.SelectedValue == "Paid")
                        bllMaster.InsertPaidLeavePM(htTeamLeaves, ReturnValue, Convert.ToString(ddlPaidUnpaid.SelectedValue));
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "HideLabel();", true);

                    if (OffEmailID != null || OffEmailID != "")
                    {
                        //bllSendMail.UserLeavesApprovedToPM(ReturnValue, usercode, "approved", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        //bllSendMail.UserLeavesApprovedToUser(ReturnValue, usercode, "approved", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                    }
                    else
                    {
                        //bllSendMail.UserLeavesApprovedToPM(ReturnValue, usercode, "approved", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                    }

                    ddlUserDays.SelectedIndex = 0;
                    ddlUserLeaveType.SelectedIndex = 0;
                    txtUserFromDate.Text = string.Empty;
                    txtUserToDate.Text = string.Empty;
                    txtUserReason.Text = string.Empty;
                    ddlUserLeaves.SelectedIndex = 0;
                }
                else
                {
                    txtUserFromDate.Text = Convert.ToString(ViewState["FromDate"]);
                    txtUserToDate.Text = bllMaster.GetLeavesToDate(Convert.ToString(ViewState["FromDate"]), Convert.ToInt32(ddlUserDays.SelectedValue));
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "HideLabel();", true);
                }
            }
            else
            {

                ClientScript.RegisterStartupScript(this.GetType(), "alert", "HideLabel();", true);
            }
        }

        [WebMethod]
        public static string GetLeavesToDate(string FromDate, int Days)
        {
            return new CodeGeneration().GetLeavesToDate(FromDate, Days);
        }

        [WebMethod]
        public static string GetLeaveDetails(string Code)
        {
            string xml = "";
            DataTable dt = new bllMaster().GetLeaveDetails(Convert.ToString(Code));
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    string eligible = Convert.ToString(dt.Rows[0]["Eligible"]);
                    if (eligible == "1")
                    {
                        DataSet ds = new DataSet("Leavetable");
                        ds.Tables.Add(dt);
                        xml = ds.GetXml();
                    }
                    else
                        xml = "";
                }
                else
                    xml = "";
            }
            else
                xml = "";
            return xml;
        }

        [WebMethod]
        public static List<Employee> GetAllEmployees()
        {
          string PMCode = EmployeeInfo.Current.Code;
            DataTable dtemp = new bllMaster().GetAllUserByPM(PMCode);
            List<Employee> Emp = new List<Employee>();
            Emp = ConvertDataTable<Employee>(dtemp);
            return Emp;
        }

        private static List<T> ConvertDataTable<T>(DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }

        private static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                        pro.SetValue(obj, dr[column.ColumnName], null);
                    else
                        continue;
                }
            }
            return obj;
        }


        [WebMethod]
        public static int UserLeaveEmail(string Code, int Days, string FromDate, string ToDate, string Reason, string InformType, string PaidStatus)
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
            DataTable dtAdded = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dtPM = new bllMaster().ProjectManagerRelatedToDepartment(EmployeeID);
            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(EmployeeID, "Attendance Correction");

            if (dtPM != null)
            {
                if (dtPM.Rows.Count > 0)
                {
                    To = Convert.ToString(dtEmail.Rows[0]["ToAttendance"]);
                    CC = Convert.ToString(dtEmail.Rows[0]["CCAtt"]);
                    BCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

                    head.Append("<html><head></head><body>");
                    body.Append("<table style=\"width:802px;font-family:verdana; font-size:11px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:24px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>");
                    body.Append("<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Dear " + Convert.ToString(dt.Rows[0]["FirstName"]) + ",<br />We have approved your a Leave Request in ERP with following details.<br /><br /></b></td></tr></table>" +
                            "<table border=\"0\" style=\"width:800px;font-family:verdana; font-size:11px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                            "<tr><td style=\"border:solid 1px Gray; width:100px!important;\"><b>Name:</b></td><td style=\"border:solid 1px Gray;\">" + Convert.ToString(Code) + " : " + Convert.ToString(dt.Rows[0]["FullName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Location:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["WorkingBranchName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>PM:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["ReportingManager"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Job Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dt.Rows[0]["JobType"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Leave Type:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString("Casual") + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>No Of Days:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Days) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>From Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(FromDate) + "</td></tr>");
                    body.Append("<tr><td  style=\"border:solid 1px Gray;border-top:none;\"><b>To Date:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(ToDate) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Reason:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Reason) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>Approved By:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(dtAdded.Rows[0]["Code"]) + " : " + Convert.ToString(dtAdded.Rows[0]["FirstName"]) + " " + Convert.ToString(dtAdded.Rows[0]["lastName"]) + "</td></tr>");
                    body.Append("<tr><td style=\"border:solid 1px Gray;border-top:none;\"><b>PM Remark:</b></td><td style=\"border:solid 1px Gray;border-top:none;\">" + Convert.ToString(Reason) + "</td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity IPS</td></tr>" + "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" + "</table>");
                    footer.Append("</body></html>");

                    string Pass = new bllMaster().GetPassword("ackdata");

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("ack@infinity-data.com", "Leaves Notification", System.Text.Encoding.UTF8);
                    mail.To.Add(To);
                    mail.CC.Add(CC);
                    mail.Bcc.Add(BCC);
                    mail.Subject = "HRMS Leaves: Request Approved - " + Convert.ToString(Code);
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