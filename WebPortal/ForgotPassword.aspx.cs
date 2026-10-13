using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Hosting;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
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
                passwordParameters["Password"] = Encrypt(newPassword);

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

        public static string Encrypt(string clearText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = Convert.ToBase64String(ms.ToArray());
                }
            }

            return clearText;
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
                            mail.Body = "Your OTP is: " + otp;
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
