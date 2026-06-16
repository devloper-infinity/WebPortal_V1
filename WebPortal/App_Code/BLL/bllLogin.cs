using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllLogin
    {
        dalLogin dalLogin = new dalLogin();

        public int CheckIfPM(int EmployeeId)
        {
            return dalLogin.CheckIfPM(EmployeeId);
        }

        public DataTable GetEligibleIps()
        {
            return dalLogin.GetEligibleIps();
        }

        public int InsertErpLogHistory(string Code, string ErpType, string IPAddress, string UserType)
        {
            return dalLogin.InsertErpLogHistory(Code, ErpType, IPAddress, UserType);
        }

        public string Encrypt(string clearText)
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

        public string Decrypt(string cipherText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }

        public int ValidateUser(string Username, string Password)
        {
            return dalLogin.ValidateUser(Username, Password);
        }

        public DataTable GetUserById(int EmployeeID, string Username, string Password)
        {
            return dalLogin.GetUserById(EmployeeID, Username, Password);
        }
        public int CheckAVSnapExistance()
        {
            return dalLogin.CheckAVSnapExistance();
        }

        public int CheckVaccneInfoExistance()
        {
            return dalLogin.CheckVaccneInfoExistance();
        }

        public int CheckVaccneCertificateExistance()
        {
            return dalLogin.CheckVaccneCertificateExistance();
        }

        public int CheckHRQuesionnaire()
        {
            return dalLogin.CheckHRQuesionnaire();
        }

        public int CheckExistanceofKYC()
        {
            return dalLogin.CheckExistanceofKYC();

        }

        public bool GetERPCutoffTimeExceptionsByCode(string Code, string Date)
        {
            return dalLogin.GetERPCutoffTimeExceptionsByCode(Code, Date);
        }

        public DataTable GetUserInformation_ByCode(string Code)
        {
            return dalLogin.GetUserInformation_ByCode(Code);

        }
        public DataTable GetUserInformation(int EmployeeID)
        {
            return dalLogin.GetUserInformation(EmployeeID);
        }

        public DataTable GetUserPmDomainLocationEmailInfo(int EmployeeID, string EmailType)
        {
            return dalLogin.GetUserPmDomainLocationEmailInfo(EmployeeID,  EmailType);
        }

        public int UpdateLastLoginDate(int EmployeeID)
        {
            return dalLogin.UpdateLastLoginDate(EmployeeID);
        }

        public DataTable GetEmpInfoByEmpId(int EmployeeID)
        {
            return dalLogin.GetEmpInfoByEmpId(EmployeeID);
        }

        public DataTable GetEmployeeInfoByCode(string Code)
        {
            return dalLogin.GetEmployeeInfoByCode(Code);
        }
    }
}