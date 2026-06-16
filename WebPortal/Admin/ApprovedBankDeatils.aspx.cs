using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class ApprovedBankDeatils : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";

        protected void Page_Load(object sender, EventArgs e)
        {
           // ShowTabsByRights();

            FolderPath = Server.MapPath(@"~\BankAccDetails\");

            try
            {
                HttpContext postedContext = HttpContext.Current;
                HttpPostedFile file = postedContext.Request.Files[0];

                string name = file.FileName;
                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0,
                (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;

                string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                GUIDFile = file_Name;
                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
            }
            catch { }
        }

        [WebMethod]
        public static string GetBankDetailsforApproval()
        {
            DataTable dt1 = new bllMaster().GetBankAccDetails();
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
        public static int ApproveBankDetails(bool IsVerify, string Remark, int AccNoChangeID, string Attachment)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("IsVerify", IsVerify);
            htParam.Add("Remark", Remark);
            htParam.Add("AccNoChangeID", AccNoChangeID);
            htParam.Add("VerifiedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("Attachment", Attachment);
            returnvalue = new bllMaster().ApproveBankAccountNo(htParam);
            return returnvalue;
        }


        [WebMethod]
        public static int InsertBankAccountDetails(string Code, string BankName, string AccountNo, string IFSCCode)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();

            htParam.Add("Code", Code.Trim());
            htParam.Add("BankName", (BankName ?? string.Empty).Trim());
            htParam.Add("BankAccNo", AccountNo.Trim());
            htParam.Add("BankIFSC", IFSCCode);
            htParam.Add("UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            if (NewFileName != "")
            {
                string CodeDate = Code + "_" + DateTime.Now.ToString("ddMMyyyyHHMMSS");
                FolderPath = FolderPath + "\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + CodeDate;
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                File.Copy(NewFileName, FolderPath + "\\" + GUIDFile);
                htParam.Add("Attachment", FolderPath + "\\" + GUIDFile);
            }
            else
            {
                htParam.Add("Attachment", "");
            }

            ReturnValue = new bllMaster().InsertBankAccountNo(htParam);
            return ReturnValue;
        }

        public void ShowTabsByRights()
        {
            int LogId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            if (LogId == 7036 || LogId == 255 || LogId == 291)
                nav_ApproveAcc.Style.Add("display", "");
            else
                nav_ApproveAcc.Style.Add("display", "none");
        }
    }
}