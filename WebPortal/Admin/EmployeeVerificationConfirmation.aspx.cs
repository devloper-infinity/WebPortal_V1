using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
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
    public partial class EmployeeVerificationConfirmation : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = Server.MapPath(@"~\EmployeeDocuments\EmploymentVerification");
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
                string filename = Convert.ToString(Request.Files["ExEmpConf_attachment"].FileName);
            }
            catch { }
        }

        [WebMethod]
        public static string BindExistingInformation(int EmployeeID)
        {
            DataTable dt1 = new bllMaster().GetEmployeeVerificationData(EmployeeID);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetUserName(int EmployeeID)
        {
            DataTable dt1 = new bllLogin().GetUserInformation(EmployeeID);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static int InsertVerificationConfirmation(int EmployeeID, string CandidateName, string EmployeeCode, string Salary, string CompanyName, string EmployeePeriod, string Designation, string ReportingManagerName,
    string ReportingManagerDesignation, string ReportingManagerContact, string HRName, string HRNameVer, string HRContact, string ReasonforLeaving, string ExitFormality, string Eligibilitytorehire, string VerifiedEligibilityForRehire, string VerifiedBy, string VerifiedByVer)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            string FilePath = "";

            htParam["EmployeeID"] = EmployeeID;
            htParam["VerifiedCandidateName"] = CandidateName;
            htParam["VerifiedEmployeeCode"] = EmployeeCode;
            htParam["VerifiedSalary"] = Salary;
            htParam["VerifiedCompanyName"] = CompanyName;
            htParam["VerifiedEmploymentPeriod"] = EmployeePeriod;
            htParam["VerifiedLastDesignation"] = Designation;
            htParam["VerifiedReportingPersonName"] = ReportingManagerName;
            htParam["VerifiedReportingPersonDesignation"] = ReportingManagerDesignation;
            htParam["VerifiedReportingPersonContact"] = ReportingManagerContact;
            htParam["VerifiedReasonForLiving"] = ReasonforLeaving;
            htParam["VerifiedPendingExitFormalities"] = ExitFormality;
            htParam["EligibilityForRehire"] = Eligibilitytorehire;
            htParam["VerifiedEligibilityForRehire"] = VerifiedEligibilityForRehire;
            htParam["VerifiedHRName"] = HRName;
            htParam["VerifiedFromName"] = HRName;
            htParam["VerifiedHRContact"] = HRContact;
            htParam["VerifiedBy"] = VerifiedBy;
            htParam["VerifiedByVerified"] = VerifiedByVer;

            if (NewFileName != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                string SubPath = FolderPath + "\\" + Convert.ToString(EmployeeID);
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                File.Copy(NewFileName, SubPath + "\\" + GUIDFile);
                htParam.Add("Document", SubPath + "\\" + GUIDFile);
            }
            else
            {
                htParam.Add("Document", "");
            }

            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertEmployeeVerification(htParam);

            return returnvalue;
        }
    }
}