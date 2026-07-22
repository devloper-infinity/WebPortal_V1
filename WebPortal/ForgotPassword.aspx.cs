using DocumentFormat.OpenXml.Wordprocessing;
using System;
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

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object ResetPassword(string username, string newPassword)
        {

            return "success";

            try
            {
                bllLogin bll = new bllLogin();

                // Check user exists
                DataTable dtUser = bll.GetEmployeeInfoByCode(username);

                if (dtUser.Rows.Count == 0)
                {
                    return new { status = "error", message = "User not found" };
                }

                string query = "UPDATE Login SET Password=@Password,PasswordChangedDate =@PasswordChangedDate WHERE UserName=@UserName";

                using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserName", username);
                        cmd.Parameters.AddWithValue("@Password", Encrypt(newPassword)); // ⚠️ Hash in real apps
                        cmd.Parameters.AddWithValue("@PasswordChangedDate", DateTime.Now);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                return new { status = "success" };
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


        [WebMethod]
        public static string SendOTP(string username)
        {
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

            // Store OTP in Session (or DB)
            HttpContext.Current.Session["OTP"] = otp;
            HttpContext.Current.Session["User"] = username;

            string Pass = new bllMaster().GetPassword("ackdata");

            // Send Email

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("ack@infinity-data.com", "ERP Password reset OTP", System.Text.Encoding.UTF8);
            mail.To.Add(email);
            mail.Subject = "Password Reset OTP";
            mail.Body = "Your OTP is: " + otp;
            mail.IsBodyHtml = true;
            mail.Priority = System.Net.Mail.MailPriority.High;
            SmtpClient client = new SmtpClient();
            client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", Pass);
            client.Host = "smtp.office365.com";  //Gmail works on Server Secured Layer
            client.Port = 587;
            client.EnableSsl = true;
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            try
            {
                client.Send(mail);
                return "OTP Sent";
            }
            catch { return "Error sending in email"; }
        }

        [WebMethod]
        public static string VerifyOTP(string username, string otp)
        {
            var session = HttpContext.Current.Session;

            string savedOtp = session["OTP"]?.ToString();
            DateTime? otpTime = session["OTPTime"] as DateTime?;

            if (savedOtp == null || otpTime == null)
                return "Expired";

            if ((DateTime.Now - otpTime.Value).TotalMinutes > 5)
                return "Expired";

            if (otp == savedOtp)
                return "Valid";

            return "Invalid";
        }
    }
}