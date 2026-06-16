using DocumentFormat.OpenXml.Office2010.Excel;
using DocumentFormat.OpenXml.Vml.Office;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class EmployeeKYC : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string getEmployeeKYCInfo()
        {
            string Code = Convert.ToString(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString())));
            DataTable dt1 = new bllMaster().GetKYCInfoByEmployee(Code);
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
        public static string getEmployeeFamilyInfo()
        {
            DataTable dt1 = new bllMaster().GetAllFamilyInfo(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static int InsertUpdateKYCInfo(string Code, string EmpName, string Gender, string MaritalStatus, string ContactNo, string PresentAddress, string PermanentAddress, string FatherHusbandName,
            string JoiningDate, string DateOfBirth, string IFSCCode, string BankName, string AccNo, string PanCard, string AdharCard, string Qual, string PH, string PHC,
            string NomineeName, string NomineeAddress, string NomineeRelation, string NomineeDateOfBirth, string NomineeContact, string MarriageDate,
            string DocumentType, string DocumentNo, string DocExpDate)
        {
            int returnvalue = 0;

            Hashtable htKYC = new Hashtable();

            htKYC.Add("Code", Code);
            htKYC.Add("FullName", EmpName.ToUpper());
            htKYC.Add("Gender", Gender);
            htKYC.Add("MStatus", MaritalStatus);
            htKYC.Add("ContactNo", ContactNo);
            htKYC.Add("PresentAddress", PresentAddress);
            htKYC.Add("PermanentAddress", PermanentAddress);
            htKYC.Add("FahterName", FatherHusbandName.ToUpper());
            htKYC.Add("DOJ", JoiningDate);
            htKYC.Add("DOB", DateOfBirth);
            htKYC.Add("IFSCCode", IFSCCode);
            htKYC.Add("BankName", BankName);
            htKYC.Add("BankAccNO", AccNo);
            htKYC.Add("PAN", PanCard);
            htKYC.Add("AadharCardNo", AdharCard);
            htKYC.Add("Qual", Qual);
            htKYC.Add("PH", PH);
            htKYC.Add("PHC", PHC);
            htKYC.Add("Nominee", NomineeName.ToUpper());
            htKYC.Add("NAddress", NomineeAddress);
            htKYC.Add("NRelation", NomineeRelation);
            htKYC.Add("NDOB", NomineeDateOfBirth);
            htKYC.Add("NContactNo", NomineeContact);
            htKYC.Add("MarriageDate", MarriageDate);
            htKYC.Add("DocName", DocumentType);
            htKYC.Add("DocNumber", DocumentNo);
            htKYC.Add("ExpDate", DocExpDate);
            htKYC.Add("IsPan", PanCard == "" ? false : true);
            htKYC.Add("IsAadharCard", AdharCard == "" ? false : true);
            htKYC.Add("EmployeeID", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue = new bllMaster().InsertEmployeeKYC(htKYC);
            return returnvalue;
        }


        [WebMethod]
        public static int InsertFamilyInfo(string Name, string Relation, string Profession, string Age)
        {
            int ReturnValue = 0;
            try
            {
                Hashtable htFamilyInsert = new Hashtable();

                htFamilyInsert.Add("EmployeeID", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                htFamilyInsert.Add("Name", Name);
                htFamilyInsert.Add("Relation", Relation);
                htFamilyInsert.Add("Profession", Profession);
                htFamilyInsert.Add("Age", Age);
                htFamilyInsert.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                ReturnValue = new bllMaster().InsertFamilyInfo(htFamilyInsert);
            }
            catch (Exception ex)
            {
                return 0;
            }

            return ReturnValue;
        }



        [WebMethod]
        public static int DeleteFamilyInfo(int Id)
        {
            int ReturnValue = 0;
            try
            {
                ReturnValue = new bllMaster().deleteFamilyInfo(Id);
            }
            catch (Exception ex)
            {
                return 0;
            }

            return ReturnValue;
        }
    }
}