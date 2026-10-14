using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Hosting;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object UpdatePassword(string username, string newPassword, string otp)
        {

            username = (username ?? "").Trim();
            string otpStatus = VerifyOTP(username, otp);
            if (otpStatus != "Valid")
                return new { status = "error", message = otpStatus == "Expired" ? "OTP expired. Please request a new code." : "Invalid OTP" };

            if (string.IsNullOrEmpty(newPassword) || newPassword.Length < 8 ||
                newPassword.Contains("%") ||
                !System.Text.RegularExpressions.Regex.IsMatch(newPassword, "[A-Z]") ||
                !System.Text.RegularExpressions.Regex.IsMatch(newPassword, "[a-z]") ||
                !System.Text.RegularExpressions.Regex.IsMatch(newPassword, "[0-9]") ||
                !System.Text.RegularExpressions.Regex.IsMatch(newPassword, "[^A-Za-z0-9%]"))
                return new { status = "error", message = "Password does not meet requirements" };

            try
            {
                bllLogin bll = new bllLogin();

                // Check user exists
                DataTable dtUser = bll.GetEmployeeInfoByCode(username);

                if (dtUser.Rows.Count == 0)
                {
                    return new { status = "error", message = "User not found" };
                }

                Hashtable passwordParameters = new Hashtable();
                passwordParameters["EmployeeID"] = Convert.ToInt32(dtUser.Rows[0]["EmployeeID"]);
                passwordParameters["Password"] = newPassword;

                int updateResult = new bllMaster().ForgotPassword(passwordParameters);
                if (updateResult <= 0)
                    return new { status = "error", message = "Unable to update the password for this username." };
                HttpContext.Current.Session.Remove("OTP");
                HttpContext.Current.Session.Remove("OTPTime");
                HttpContext.Current.Session.Remove("User");
                return new { status = "success", message = "Password updated successfully" };
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static string SendOTP(string username)
        {
            username = (username ?? "").Trim();
            if (username.Length == 0)
                return "Please enter username";
            string email = "";
            string otp = new Random().Next(100000, 999999).ToString();

            // Get Email from DB
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT OfficialEmailID FROM EmployeeInfo WHERE Code=@u", con);
                cmd.Parameters.AddWithValue("@u", username);
                con.Open();

                email = Convert.ToString(cmd.ExecuteScalar());
            }

           

            if (string.IsNullOrEmpty(email))
                return "Email ID not available in system";

            string Pass = new bllMaster().GetPassword("ackdata");

            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            try
            {
                HostingEnvironment.QueueBackgroundWorkItem(async cancellationToken =>
                {
                    try
                    {
                        using (MailMessage mail = new MailMessage())
                        using (SmtpClient client = new SmtpClient())
                        {
                            mail.From = new MailAddress("ack@infinity-data.com", "ERP Password reset OTP", Encoding.UTF8);
                            mail.To.Add(email);
                            mail.Subject = "Password Reset OTP";
                            mail.SubjectEncoding = Encoding.UTF8;
                            mail.Body = SelfLeavesEmailTemplate.Apply(
                                "<p style='margin:0 0 12px;color:#1e293b;font-size:14px;line-height:22px;'>Hello,</p>" +
                                "<p style='margin:0 0 20px;color:#475569;font-size:13px;line-height:21px;'>Your One-Time Password (OTP) to reset your WebPortal password is:</p>" +
                                "<table role='presentation' width='100%' cellspacing='0' cellpadding='0' border='0' style='width:100%;background-color:#f1f5f9;border:1px solid #dbe4ee;border-radius:10px;'><tr><td align='center' style='padding:18px 16px 6px;color:#64748b;font-size:10px;font-weight:700;letter-spacing:1px;text-transform:uppercase;'>ONE-TIME PASSWORD (OTP)</td></tr><tr><td align='center' style='padding:4px 16px 18px;color:#173b70;font-family:Arial,sans-serif;font-size:30px;font-weight:700;letter-spacing:7px;line-height:38px;'>" +
                                HttpUtility.HtmlEncode(otp) +
                                "</td></tr></table>" +
                                "<p style='margin:18px 0 0;color:#475569;font-size:12px;line-height:19px;'>This OTP is valid for 5 minutes and can be used only once. For your security, do not share it with anyone. If you did not request this password reset, please ignore this email.</p>",
                                "Password Reset OTP",
                                true);
                            mail.BodyEncoding = Encoding.UTF8;
                            mail.IsBodyHtml = true;
                            mail.Priority = MailPriority.High;

                            client.Credentials = new NetworkCredential("ack@infinity-data.com", Pass);
                            client.Host = "smtp.office365.com";
                            client.Port = 587;
                            client.EnableSsl = true;

                            await client.SendMailAsync(mail);
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Trace.TraceError("Forgot password OTP email failed: {0}", ex);
                    }
                });

                HttpContext.Current.Session["OTP"] = otp;
                HttpContext.Current.Session["User"] = username;
                HttpContext.Current.Session["OTPTime"] = DateTime.UtcNow;
                return "OTP Queued";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Forgot password OTP email could not be queued: {0}", ex);
                return "Unable to start email delivery. Please try again.";
            }
        }

        [WebMethod(EnableSession = true)]
        public static string VerifyOTP(string username, string otp)
        {
            var session = HttpContext.Current.Session;

            if (session == null)
                return "Expired";

            string savedOtp = session["OTP"]?.ToString();
            DateTime? otpTime = session["OTPTime"] as DateTime?;

            if (savedOtp == null || otpTime == null)
                return "Expired";

            if ((DateTime.UtcNow - otpTime.Value).TotalMinutes >= 5)
                return "Expired";

            if (string.Equals(session["User"] as string, (username ?? "").Trim(), StringComparison.OrdinalIgnoreCase) &&
                (otp ?? "").Trim() == savedOtp)
                return "Valid";

            return "Invalid";
        }
    }
}
