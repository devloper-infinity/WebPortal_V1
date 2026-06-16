using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Web;
using System.Collections;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;
using WebPortal.App_Code.EL;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using OpenXmlPowerTools;
using DocumentFormat.OpenXml.Office.SpreadSheetML.Y2024.WorkbookCompatibilityVersion;
using DocumentFormat.OpenXml;
using Paragraph = DocumentFormat.OpenXml.Wordprocessing.Paragraph;

namespace WebPortal.Admin
{
    public partial class GenerateEmpDocs : System.Web.UI.Page
    {
        static string Code;
        static int EmployeeID;
        static string login_Emp;
        static string login_Desg;

        Num2Wrd numEng = new Num2Wrd();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Convert.ToString(Request.QueryString["Exists"]) != "" && Convert.ToString(Request.QueryString["Exists"]) != null)
            {
                Code = Convert.ToString(Request.QueryString["Exists"]);
            }
            else if (Convert.ToString(Request.QueryString["Dropout"]) != "" && Convert.ToString(Request.QueryString["Dropout"]) != null)
            {
                Code = Convert.ToString(Request.QueryString["Dropout"]);
            }
            if (Code != "")
            {
                int EmployeeId = new bllMaster().GetEmployeeIdFromCode(Code);
            }
        }

        [WebMethod]
        public static string GetUserInformation()
        {
            EmployeeID = new bllMaster().GetEmployeeIdFromCode(Code);
            System.Data.DataTable dt1 = new bllLogin().GetUserInformation(EmployeeID);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (System.Data.DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (System.Data.DataColumn col in dt1.Columns)
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
        public static string GetDropoutInformation()
        {
            int EmployeeId = new bllMaster().GetEmployeeIdFromCode(Code);
            System.Data.DataTable dt1 = new bllMaster().GetDropOutinfo(EmployeeId);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (System.Data.DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (System.Data.DataColumn col in dt1.Columns)
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

        protected void btn1_Click(object sender, EventArgs e)
        {
            if (Code != "")
            {
                int EmployeeId = new bllMaster().GetEmployeeIdFromCode(Code);

                if (Convert.ToString(Request.Form["empdoc_appdate_hid"]) != "" || Convert.ToString(Request.Form["empdoc_appdate_hid"]) != null || Convert.ToString(Request.Form["empdoc_appdate_hid"]) != string.Empty)
                {
                    Hashtable htparam = new Hashtable();
                    htparam["EmpId"] = EmployeeId;
                    htparam["AppointMentDate"] = Convert.ToString(Request.Form["empdoc_appdate_hid"]);
                    htparam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
                    int result = new bllMaster().InsertEmpAppointmentDate(htparam);
                }

                System.Data.DataTable dt = new bllLogin().GetUserInformation(EmployeeId);

                System.Data.DataTable dtlogin = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                login_Emp = Convert.ToString(dtlogin.Rows[0]["Title"]) + " " + Convert.ToString(dtlogin.Rows[0]["FirstName"]) + " " + Convert.ToString(dtlogin.Rows[0]["lastname"]);
                login_Desg = Convert.ToString(dtlogin.Rows[0]["DesignationName"]);


                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "OfferLetter")
                {
                    GenerateOfferLetter(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "AppointmentLetter")
                {
                    System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Docs(Code, Convert.ToString(Request.Form["empdoc_incentive"]));
                    GenerateAppointmentLetter(dt, dtAnnx);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "SalaryRivisionLetter")
                {
                    System.Data.DataTable dtEmp = new bllSalary().GetEmployeeSalaryIncrementDetailsForLetter(EmployeeId);
                    GenerateSalaryRevisionLetter(dtEmp);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "ConfirmationLetter")
                {
                    GenerateConfirmationLetter(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "ClientAcknowledgementLetterNew")
                {
                    GenerateClientAcknowledgementLetter(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "IdemnityBond")
                {
                    GenerateIdemnityBond(dt);
                }

                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "AppendixA")
                {
                    GenerateAppendixA(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "EmployeeAgreementWithoutBond")
                {
                    GenerateEmployeeAgreement3(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "PromotionLetter")
                {
                    System.Data.DataTable dtEmp = new bllSalary().GetEmployeeDetailsTransferCompany(Code);
                    GeneratePromotionLetter(dtEmp);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "AddressVerificationLetter")
                {
                    GenerateAddressVerificationLetter(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "Annexure")
                {
                    System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Docs(Code, "");
                    GenerateAnnexure(dtAnnx);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "Account Transfer Letter")
                {
                    string BankName = Convert.ToString(dt.Rows[0]["BankName"]);
                    string BankAccNo = Convert.ToString(dt.Rows[0]["BankAccNo"]);
                    if (BankName != "" && BankAccNo != "")
                        GenerateAccountTransferLetter(dt);
                    else
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please update bank details in ERP.');", true);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "Renewal Agreement")
                {
                    GenerateRenewalAgreementLetter(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "Psuedo Name")
                {
                    GeneratePseudonameAgreementLetter(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "Addendum to the Employment Agreement")
                {
                    GenerateAddendum25(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "Addendum to the Employment Agreement - 2")
                {
                    GenerateAddendum2(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "JoiningDocumentsChecklist")
                {
                    GenerateJoiningChecklist(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "PersonalDetailsForm")
                {
                    GeneratePersonalDetailsForm(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "BackgroundVerificationForm")
                {
                    GenerateBackgroundVerificationForm(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "Relievingletter")
                {
                    GenerateRelievingLetter(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "Experienceletter")
                {
                    GenerateExperienceLetter(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "NoDueCertificate")
                {
                    GenerateNoDueCertificate(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "ExitInterviewForm")
                {
                    GenerateExitInterviewForm(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "UnderTakingLetterUnderwriter")
                {
                    GenerateUndertakingLetter(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "ExitChecklist")
                {
                    GenerateExitChecklist(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "ExitDocumentsChecklist")
                {
                    GenerateExitDocumentCheckist(dt);
                }
                else if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "POSH Policy - Acknowledgement Form")
                {
                    GenerateEPOSHAckForm(dt);
                }
                else if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "POSH Policy Document")
                {
                    GenerateEPOSHDocument(dt);
                }
                else if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "EmployeeAgreementWithoutBond4")
                {
                    GenerateEmployeeAgreementWithoutBond4(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "EmployeeAgreementWithoutBondForExpAnalyst")
                {
                    System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Docs(Code, Convert.ToString(Request.Form["empdoc_incentive"]));
                    if (Convert.ToString(Request.Form["empdoc_subdomain_hid"]) == "Credit")
                        GenerateEmployeeAgreement_Analyst_Credit(dt, dtAnnx);
                    else
                        GenerateEmployeeAgreement_Analyst(dt, dtAnnx);
                }

                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "EmployeeAgreementWithoutBondForExpAnalyst4")
                {
                    System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Docs(Code, Convert.ToString(Request.Form["empdoc_incentive"]));
                    if (Convert.ToString(Request.Form["empdoc_subdomain_hid"]) == "Credit")
                        GenerateEmployeeAgreementWithoutBond_ForExp_analyst_credit4(dt, dtAnnx);
                    else
                        GenerateEmployeeAgreementWithoutBond_ForExp_analyst4(dt, dtAnnx);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "EmployeeAgreement5")
                {
                    System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Docs(Code, Convert.ToString(Request.Form["EmployeeAgreement5"]));
                    GenerateEmployeeAgreement_5(dt, dtAnnx);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "EmployeeAgreementWithoutBondForExpAnalyst5")
                {
                    System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Docs(Code, Convert.ToString(Request.Form["empdoc_incentive"]));
                    if (Convert.ToString(Request.Form["empdoc_subdomain_hid"]) == "Credit")
                        GenerateEmployeeAgreementWithoutBond_ForExp_analyst_credit5(dt, dtAnnx);
                    else
                        GenerateEmployeeAgreementWithoutBond_ForExp_analyst5(dt, dtAnnx);
                }

                else if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "AppendixB")
                {
                    GenerateAppendixB(dt);
                }
                else if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "PF Declaration Form - 11 - 2017")
                {
                    System.Data.DataTable dtKYC = new bllMaster().GetUserInformation_KYC(EmployeeId);
                    GeneratePFDeclarationForm_2017(dtKYC);
                }
                else if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "PF Declaration Form - 11 - 2019")
                {
                    System.Data.DataTable dtKYC = new bllMaster().GetUserInformation_KYC(EmployeeId);
                    GeneratePFDeclarationForm_2019(dtKYC);
                }
            }
        }

        public void GenerateOfferLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Offer Letter.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Offer Letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Offer Letter.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«EmployeeId»", Convert.ToString(dt.Rows[0]["EmployeeId"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«HRDept»", login_Desg);

                #endregion
            }

            //Response.ContentType = "application/msword";
            //Response.AppendHeader("Content-Disposition", "attachment; filename=" + FileName);
            //Response.TransmitFile(outputPath);
            //Response.End();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Offer Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Offer Letter.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateConfirmationLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Confirmation letter1.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Confirmation Letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Confirmation Letter.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«ConfirmationDate»", string.Format("{0} " + Convert.ToDateTime(dt.Rows[0]["JoiningDate"]).AddMonths(6).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(dt.Rows[0]["JoiningDate"]).AddMonths(6).Day)));
                ReplacePlaceholder(body, "«RefNo»", "CF/" + Convert.ToString(dt.Rows[0]["CompanyName"]).Substring(0, 3).ToUpper() + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]));
                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«HRDept»", login_Desg);

                #endregion
            }


            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Confirmation Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Confirmation Letter.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateSalaryRevisionLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Salary Revision Notification.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Salary Revision Letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Salary Revision Letter.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«Roles»", "");
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«ExistingSalary»", Convert.ToString(dt.Rows[0]["BeforeSalary"]));
                ReplacePlaceholder(body, "«IncrementedAmount»", Convert.ToString(dt.Rows[0]["Difference"]));
                ReplacePlaceholder(body, "«RevisedSalary»", Convert.ToString(dt.Rows[0]["CurrentSalary"]));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));

                if (Convert.ToString(dt.Rows[0]["EffectiveDate"]) != null && Convert.ToString(dt.Rows[0]["EffectiveDate"]) != "")
                    ReplacePlaceholder(body, "«LetterDate»", Convert.ToString(dt.Rows[0]["EffectiveDate"]));
                else
                    ReplacePlaceholder(body, "«LetterDate»", " ");

                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«HRDept»", login_Desg);

                doc.MainDocumentPart.Document.Save();

                #endregion
            }


            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Salary Revision Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Salary Revision Letter.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateIdemnityBond(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/IdemnityBond.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-IdemnityBond.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-IdemnityBond.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«Name»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«PermAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«BondAmount»", parseValueIntoCurrency(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12));
                ReplacePlaceholder(body, "«BondAmountWord»", numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty"));
                ReplacePlaceholder(body, "«BondPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-IdemnityBond.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-IdemnityBond.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateEmployeeAgreementWithoutBond_ForExp_analyst4(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 4-Bangalore-ForAll.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«MRMonth»", Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRMonth"]));
                ReplacePlaceholder(body, "«MRYear»", Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRYear"]));
                ReplacePlaceholder(body, "«TRMonth»", Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRMonth"]));
                ReplacePlaceholder(body, "«TRYear»", Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRYear"]));
                ReplacePlaceholder(body, "«EAMonth»", Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAMonth"]));
                ReplacePlaceholder(body, "«EAYear»", Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAYear"]));
                ReplacePlaceholder(body, "«HAMonth»", Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAMonth"]));
                ReplacePlaceholder(body, "«HAYear»", Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAYear"]));
                ReplacePlaceholder(body, "«ABMonth»", Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]));
                ReplacePlaceholder(body, "«ABYear»", Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]));
                ReplacePlaceholder(body, "«ESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«PFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«PFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«GrossSalaryMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossSalaryYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«GratuityMonth»", Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                ReplacePlaceholder(body, "«GratuityYear»", Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                ReplacePlaceholder(body, "«IncentiveMonth»", Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                ReplacePlaceholder(body, "«IncentiveYear»", Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                ReplacePlaceholder(body, "«NightBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                ReplacePlaceholder(body, "«NightBonusYear»", Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                ReplacePlaceholder(body, "«OtherBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                ReplacePlaceholder(body, "«OtherBonusYear»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                ReplacePlaceholder(body, "«ESICompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                ReplacePlaceholder(body, "«ESICompanyYear»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                ReplacePlaceholder(body, "«PFCompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                ReplacePlaceholder(body, "«PFCompanyYear»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                ReplacePlaceholder(body, "«LeaveEncashmentMonth»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                ReplacePlaceholder(body, "«LeaveEncashmentYear»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                ReplacePlaceholder(body, "«TotalContriMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«TotalContriYear»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«PTMonth»", Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                ReplacePlaceholder(body, "«PTYear»", Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                ReplacePlaceholder(body, "«ActualESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ActualESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«ActualPFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«ActualPFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionYear»", Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                ReplacePlaceholder(body, "«GrossEmpMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossEmpYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«NetMonth»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                ReplacePlaceholder(body, "«NetYear»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                ReplacePlaceholder(body, "«CompanyTotMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«CompanyTotYear»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«TotalCostMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                ReplacePlaceholder(body, "«TotalCostYear»", Convert.ToString(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0")));

                ReplacePlaceholder(body, "«Roles»", "");
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«EmpCode»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));

                doc.MainDocumentPart.Document.Save();

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateEmployeeAgreement_Analyst_Credit(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 3-Bangalore.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«MRMonth»", Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRMonth"]));
                ReplacePlaceholder(body, "«MRYear»", Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRYear"]));
                ReplacePlaceholder(body, "«TRMonth»", Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRMonth"]));
                ReplacePlaceholder(body, "«TRYear»", Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRYear"]));
                ReplacePlaceholder(body, "«EAMonth»", Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAMonth"]));
                ReplacePlaceholder(body, "«EAYear»", Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAYear"]));
                ReplacePlaceholder(body, "«HAMonth»", Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAMonth"]));
                ReplacePlaceholder(body, "«HAYear»", Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAYear"]));
                ReplacePlaceholder(body, "«ABMonth»", Convert.ToString(dtAnnx.Rows[0]["ABMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ABMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ABMonth"]));
                ReplacePlaceholder(body, "«ABYear»", Convert.ToString(dtAnnx.Rows[0]["ABYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ABYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ABYear"]));
                ReplacePlaceholder(body, "«ESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«PFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«PFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«GrossSalaryMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossSalaryYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«GratuityMonth»", Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                ReplacePlaceholder(body, "«GratuityYear»", Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                ReplacePlaceholder(body, "«IncentiveMonth»", Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                ReplacePlaceholder(body, "«IncentiveYear»", Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                ReplacePlaceholder(body, "«NightBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                ReplacePlaceholder(body, "«NightBonusYear»", Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                ReplacePlaceholder(body, "«OtherBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                ReplacePlaceholder(body, "«OtherBonusYear»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                ReplacePlaceholder(body, "«ESICompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                ReplacePlaceholder(body, "«ESICompanyYear»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                ReplacePlaceholder(body, "«PFCompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                ReplacePlaceholder(body, "«PFCompanyYear»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                ReplacePlaceholder(body, "«LeaveEncashmentMonth»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                ReplacePlaceholder(body, "«LeaveEncashmentYear»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                ReplacePlaceholder(body, "«TotalContriMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«TotalContriYear»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«PTMonth»", Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                ReplacePlaceholder(body, "«PTYear»", Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                ReplacePlaceholder(body, "«ActualESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ActualESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«ActualPFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«ActualPFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionYear»", Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                ReplacePlaceholder(body, "«GrossEmpMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossEmpYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«NetMonth»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                ReplacePlaceholder(body, "«NetYear»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                ReplacePlaceholder(body, "«CompanyTotMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«CompanyTotYear»", Convert.ToString(dtAnnx.Rows[0]["CompanyTotYear"]));
                ReplacePlaceholder(body, "«TotalCostMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                ReplacePlaceholder(body, "«TotalCostYear»", Convert.ToString(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0")));
                ReplacePlaceholder(body, "«TotalCostInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"])).Replace("Fourty", "Forty") + " Only"));

                ReplacePlaceholder(body, "«Roles»", "");
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«EmpCode»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));

                doc.MainDocumentPart.Document.Save();
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateEmployeeAgreement_Analyst(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 3-Bangalore-ForAll.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«MRMonth»", Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRMonth"]));
                ReplacePlaceholder(body, "«MRYear»", Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRYear"]));
                ReplacePlaceholder(body, "«TRMonth»", Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRMonth"]));
                ReplacePlaceholder(body, "«TRYear»", Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRYear"]));
                ReplacePlaceholder(body, "«EAMonth»", Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAMonth"]));
                ReplacePlaceholder(body, "«EAYear»", Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAYear"]));
                ReplacePlaceholder(body, "«HAMonth»", Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAMonth"]));
                ReplacePlaceholder(body, "«HAYear»", Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAYear"]));
                ReplacePlaceholder(body, "«ABMonth»", Convert.ToString(dtAnnx.Rows[0]["ABMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ABMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ABMonth"]));
                ReplacePlaceholder(body, "«ABYear»", Convert.ToString(dtAnnx.Rows[0]["ABYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ABYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ABYear"]));
                ReplacePlaceholder(body, "«ESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«PFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«PFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«GrossSalaryMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossSalaryYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«GratuityMonth»", Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                ReplacePlaceholder(body, "«GratuityYear»", Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                ReplacePlaceholder(body, "«IncentiveMonth»", Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                ReplacePlaceholder(body, "«IncentiveYear»", Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                ReplacePlaceholder(body, "«NightBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                ReplacePlaceholder(body, "«NightBonusYear»", Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                ReplacePlaceholder(body, "«OtherBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                ReplacePlaceholder(body, "«OtherBonusYear»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                ReplacePlaceholder(body, "«ESICompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                ReplacePlaceholder(body, "«ESICompanyYear»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                ReplacePlaceholder(body, "«PFCompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                ReplacePlaceholder(body, "«PFCompanyYear»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                ReplacePlaceholder(body, "«LeaveEncashmentMonth»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                ReplacePlaceholder(body, "«LeaveEncashmentYear»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                ReplacePlaceholder(body, "«TotalContriMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«TotalContriYear»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«PTMonth»", Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                ReplacePlaceholder(body, "«PTYear»", Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                ReplacePlaceholder(body, "«ActualESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ActualESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«ActualPFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«ActualPFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionYear»", Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                ReplacePlaceholder(body, "«GrossEmpMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossEmpYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«NetMonth»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                ReplacePlaceholder(body, "«NetYear»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                ReplacePlaceholder(body, "«CompanyTotMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«CompanyTotYear»", Convert.ToString(dtAnnx.Rows[0]["CompanyTotYear"]));
                ReplacePlaceholder(body, "«TotalCostMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                ReplacePlaceholder(body, "«TotalCostYear»", Convert.ToString(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0")));
                ReplacePlaceholder(body, "«TotalCostInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"])).Replace("Fourty", "Forty") + " Only"));

                ReplacePlaceholder(body, "«Roles»", "");
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«EmpCode»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));

                doc.MainDocumentPart.Document.Save();
            }


            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateEmployeeAgreementWithoutBond_ForExp_analyst_credit4(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 4-Bangalore.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;


                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«MRMonth»", Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRMonth"]));
                ReplacePlaceholder(body, "«MRYear»", Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRYear"]));
                ReplacePlaceholder(body, "«TRMonth»", Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRMonth"]));
                ReplacePlaceholder(body, "«TRYear»", Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRYear"]));
                ReplacePlaceholder(body, "«EAMonth»", Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAMonth"]));
                ReplacePlaceholder(body, "«EAYear»", Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAYear"]));
                ReplacePlaceholder(body, "«HAMonth»", Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAMonth"]));
                ReplacePlaceholder(body, "«HAYear»", Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAYear"]));
                ReplacePlaceholder(body, "«ABMonth»", Convert.ToString(dtAnnx.Rows[0]["ABMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ABMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ABMonth"]));
                ReplacePlaceholder(body, "«ABYear»", Convert.ToString(dtAnnx.Rows[0]["ABYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ABYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ABYear"]));
                ReplacePlaceholder(body, "«ESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«PFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«PFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«GrossSalaryMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossSalaryYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«GratuityMonth»", Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                ReplacePlaceholder(body, "«GratuityYear»", Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                ReplacePlaceholder(body, "«IncentiveMonth»", Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                ReplacePlaceholder(body, "«IncentiveYear»", Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                ReplacePlaceholder(body, "«NightBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                ReplacePlaceholder(body, "«NightBonusYear»", Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                ReplacePlaceholder(body, "«OtherBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                ReplacePlaceholder(body, "«OtherBonusYear»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                ReplacePlaceholder(body, "«ESICompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                ReplacePlaceholder(body, "«ESICompanyYear»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                ReplacePlaceholder(body, "«PFCompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                ReplacePlaceholder(body, "«PFCompanyYear»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                ReplacePlaceholder(body, "«LeaveEncashmentMonth»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                ReplacePlaceholder(body, "«LeaveEncashmentYear»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                ReplacePlaceholder(body, "«TotalContriMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«TotalContriYear»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«PTMonth»", Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                ReplacePlaceholder(body, "«PTYear»", Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                ReplacePlaceholder(body, "«ActualESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ActualESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«ActualPFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«ActualPFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionYear»", Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                ReplacePlaceholder(body, "«GrossEmpMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossEmpYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«NetMonth»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                ReplacePlaceholder(body, "«NetYear»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                ReplacePlaceholder(body, "«CompanyTotMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«CompanyTotYear»", Convert.ToString(dtAnnx.Rows[0]["CompanyTotYear"]));
                ReplacePlaceholder(body, "«TotalCostMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                ReplacePlaceholder(body, "«TotalCostYear»", Convert.ToString(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0")));
                ReplacePlaceholder(body, "«TotalCostInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"])).Replace("Fourty", "Forty") + " Only"));

                ReplacePlaceholder(body, "«Roles»", "");
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«EmpCode»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));

                doc.MainDocumentPart.Document.Save();
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateEmployeeAgreementWithoutBond4(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            // Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Employee Agreement_4.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                #region Fields

                // Replace placeholders while keeping formatting
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«EmployeeCode»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«Roles»", "");
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));

                doc.MainDocumentPart.Document.Save();

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateClientAcknowledgementLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Client-Acknowledgement LetterNew.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Client Acknowledgement Letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Client Acknowledgement Letter.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                // Replace placeholders while keeping formatting
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«EmployeeCode»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));

                doc.MainDocumentPart.Document.Save();

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Client Acknowledgement Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Client Acknowledgement Letter.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateAppointmentLetter(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Appointment Letter.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appointment Letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appointment Letter.docx";

            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«ESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«PFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«PFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«GrossSalaryMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossSalaryYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«GratuityMonth»", Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                ReplacePlaceholder(body, "«GratuityYear»", Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                ReplacePlaceholder(body, "«IncentiveMonth»", Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                ReplacePlaceholder(body, "«IncentiveYear»", Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                ReplacePlaceholder(body, "«NightBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                ReplacePlaceholder(body, "«NightBonusYear»", Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                ReplacePlaceholder(body, "«OtherBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                ReplacePlaceholder(body, "«OtherBonusYear»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                ReplacePlaceholder(body, "«ESICompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                ReplacePlaceholder(body, "«ESICompanyYear»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                ReplacePlaceholder(body, "«PFCompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                ReplacePlaceholder(body, "«PFCompanyYear»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                ReplacePlaceholder(body, "«LeaveEncashmentMonth»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                ReplacePlaceholder(body, "«LeaveEncashmentYear»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                ReplacePlaceholder(body, "«TotalContriMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«TotalContriYear»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«PTMonth»", Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                ReplacePlaceholder(body, "«PTYear»", Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                ReplacePlaceholder(body, "«ActualESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ActualESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«ActualPFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«ActualPFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionYear»", Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                ReplacePlaceholder(body, "«GrossEmpMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossEmpYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«NetMonth»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                ReplacePlaceholder(body, "«NetYear»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                ReplacePlaceholder(body, "«CompanyTotMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«CompanyTotYear»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«TotalCostMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                ReplacePlaceholder(body, "«TotalCostYear»", Convert.ToString(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0")));
                ReplacePlaceholder(body, "«TotalCostInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"])).Replace("Fourty", "Forty") + " Only"));

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Salary»", parseValueIntoCurrency(Convert.ToDouble(dt.Rows[0]["New1Salary"])).Replace("Fourty", "Forty"));
                ReplacePlaceholder(body, "«WordSalary»", Convert.ToString(NumberToText.Convert(Convert.ToInt32(dt.Rows[0]["New1Salary"]))) + " ");
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«AppointmentDate»", Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("dd-MMM-yyyy"));
                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«HRDept»", login_Desg);

                doc.MainDocumentPart.Document.Save();

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appointment Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appointment Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateAppendixA(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Appendix-A-Version1.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appendix-A.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appendix-A.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                // Replace placeholders while keeping formatting
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");

                doc.MainDocumentPart.Document.Save();

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appendix-A.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appendix-A.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateEmployeeAgreement3(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 3-2023 ForAll.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_3.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_3.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                // Replace placeholders while keeping formatting

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));

                doc.MainDocumentPart.Document.Save();

                #endregion
            }


            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_3.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_3.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GeneratePromotionLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Promotion Letter.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Promotion Letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Promotion Letter.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["NewCompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["NewCompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));

                if (Convert.ToString(dt.Rows[0]["PromotionEffectiveDate"]) != null && Convert.ToString(dt.Rows[0]["PromotionEffectiveDate"]) != "")
                    ReplacePlaceholder(body, "«LetterDate»", Convert.ToString(dt.Rows[0]["PromotionEffectiveDate"]));
                else
                    ReplacePlaceholder(body, "«LetterDate»", " ");

                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«HRDept»", login_Desg);

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Promotion Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Promotion Letter.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateAddressVerificationLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Address Verification Letter.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Address Verification Letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Address Verification Letter.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«Name»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«PermAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                ReplacePlaceholder(body, "«First Name»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Address Verification Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Address Verification Letter.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateAnnexure(System.Data.DataTable dtAnex)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Annexure1.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "/" + Convert.ToString(dtAnex.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "-Annexure.docx");
            string FileName = Convert.ToString(dtAnex.Rows[0]["Code"]) + "/" + Convert.ToString(dtAnex.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "-Annexure.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dtAnex.Rows[0]["EmployeeName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dtAnex.Rows[0]["Designation"]));
                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnex.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnex.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnex.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnex.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«ABMonth»", Convert.ToString(dtAnex.Rows[0]["ABMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["ABMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["ABMonth"]));
                ReplacePlaceholder(body, "«ABYear»", Convert.ToString(dtAnex.Rows[0]["ABYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["ABYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["ABYear"]));
                ReplacePlaceholder(body, "«ESIMonth»", Convert.ToString(dtAnex.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ESIYear»", Convert.ToString(dtAnex.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«PFMonth»", Convert.ToString(dtAnex.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«PFYear»", Convert.ToString(dtAnex.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«GrossSalaryMonth»", Convert.ToString(dtAnex.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossSalaryYear»", Convert.ToString(dtAnex.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«GratuityMonth»", Convert.ToString(dtAnex.Rows[0]["GratuityMonth"]));
                ReplacePlaceholder(body, "«GratuityYear»", Convert.ToString(dtAnex.Rows[0]["GratuityYear"]));
                ReplacePlaceholder(body, "«IncentiveMonth»", Convert.ToString(dtAnex.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["IncentiveMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["IncentiveMonth"]));
                ReplacePlaceholder(body, "«IncentiveYear»", Convert.ToString(dtAnex.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["IncentiveYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["IncentiveYear"]));
                ReplacePlaceholder(body, "«NightBonusMonth»", Convert.ToString(dtAnex.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["NightBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["NightBonusMonth"]));
                ReplacePlaceholder(body, "«NightBonusYear»", Convert.ToString(dtAnex.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["NightBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["NightBonusYear"]));
                ReplacePlaceholder(body, "«OtherBonusMonth»", Convert.ToString(dtAnex.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["OtherBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["OtherBonusMonth"]));
                ReplacePlaceholder(body, "«OtherBonusYear»", Convert.ToString(dtAnex.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["OtherBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["OtherBonusYear"]));
                ReplacePlaceholder(body, "«ESICompanyMonth»", Convert.ToString(dtAnex.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["ESICompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["ESICompanyMonth"]));
                ReplacePlaceholder(body, "«ESICompanyYear»", Convert.ToString(dtAnex.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["ESICompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["ESICompanyYear"]));
                ReplacePlaceholder(body, "«PFCompanyMonth»", Convert.ToString(dtAnex.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["PFCompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["PFCompanyMonth"]));
                ReplacePlaceholder(body, "«PFCompanyYear»", Convert.ToString(dtAnex.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["PFCompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["PFCompanyYear"]));
                ReplacePlaceholder(body, "«LeaveEncashmentMonth»", Convert.ToString(dtAnex.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["LeaveEncashmentMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["LeaveEncashmentMonth"]));
                ReplacePlaceholder(body, "«LeaveEncashmentYear»", Convert.ToString(dtAnex.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["LeaveEncashmentYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["LeaveEncashmentYear"]));
                ReplacePlaceholder(body, "«TotalContriMonth»", Convert.ToString(dtAnex.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["TotalBMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«TotalContriYear»", Convert.ToString(dtAnex.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["TotalBYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«PTMonth»", Convert.ToString(dtAnex.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["PTMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["PTMonth"]));
                ReplacePlaceholder(body, "«PTYear»", Convert.ToString(dtAnex.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["PTYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["PTYear"]));
                ReplacePlaceholder(body, "«ActualESIMonth»", Convert.ToString(dtAnex.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ActualESIYear»", Convert.ToString(dtAnex.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«ActualPFYear»", Convert.ToString(dtAnex.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«ActualPFMonth»", Convert.ToString(dtAnex.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionMonth»", Convert.ToString(dtAnex.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["TotalCMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["TotalCMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionYear»", Convert.ToString(dtAnex.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["TotalCYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["TotalCYear"]));
                ReplacePlaceholder(body, "«GrossEmpMonth»", Convert.ToString(dtAnex.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossEmpYear»", Convert.ToString(dtAnex.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«NetMonth»", Convert.ToString(dtAnex.Rows[0]["NetSalaryMonth"]));
                ReplacePlaceholder(body, "«NetYear»", Convert.ToString(dtAnex.Rows[0]["NetSalaryYear"]));
                ReplacePlaceholder(body, "«CompanyTotMonth»", Convert.ToString(dtAnex.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«CompanyTotYear»", Convert.ToString(dtAnex.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«TotalCostMonth»", Convert.ToString(dtAnex.Rows[0]["TotalCostMonth"]));
                ReplacePlaceholder(body, "«TotalCostYear»", Convert.ToString(Convert.ToInt32(dtAnex.Rows[0]["TotalCostYear"]).ToString("#,##0")));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dtAnex.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dtAnex.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dtAnex.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dtAnex.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«WordSalary»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnex.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dtAnex.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dtAnex.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dtAnex.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dtAnex.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dtAnex.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dtAnex.Rows[0]["EmployeeId"]));
                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«HRDept»", login_Desg);

                //ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dtAnex.Rows[0]["PermenentAddress"]));
                //ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dtAnex.Rows[0]["PresentAddress"]));
                //ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dtAnex.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dtAnex.Rows[0]["Period"]) + " years");
                //ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dtAnex.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dtAnex.Rows[0]["AppointmentDate"])).Day)));
                //ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dtAnex.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dtAnex.Rows[0]["JoiningDate"])).Day)));
                //ReplacePlaceholder(body, "«Gender»", Convert.ToString(dtAnex.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                //ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnex.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                //ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dtAnex.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dtAnex.Rows[0]["Period"]) + " years");
                //ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dtAnex.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                //ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dtAnex.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                //ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dtAnex.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");

                doc.MainDocumentPart.Document.Save();

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dtAnex.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "-Annexure.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "/" + Convert.ToString(dtAnex.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "-Annexure.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateAccountTransferLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/AccountTransferLetter.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Account Transfer Letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Account Transfer Letter.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«EmpCode»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«AccountNo»", Convert.ToString(dt.Rows[0]["BankAccNo"]));
                ReplacePlaceholder(body, "«BankName»", Convert.ToString(dt.Rows[0]["BankName"]));
                ReplacePlaceholder(body, "«TitleSpecification»", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(Convert.ToString(dt.Rows[0]["EmpTitle"]).ToLower()));
                ReplacePlaceholder(body, "«TitleSpecification1»", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(Convert.ToString(dt.Rows[0]["EmpTitle"]).ToLower()));
                ReplacePlaceholder(body, "«HrName»", login_Emp);

                #endregion
            }


            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Account Transfer Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Account Transfer Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateRenewalAgreementLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Employee Renewal Agreement_ Infinity.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Renewal Agreement.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Renewal Agreement.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("dd-MMM-yyyy"));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«AppointmentDate»", Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("dd-MMM-yyyy"));
                try
                {
                    ReplacePlaceholder(body, "«AgreementDate»", Convert.ToDateTime(Convert.ToString(dt.Rows[0]["NewAgrDate"])).ToString("dd-MMM-yyyy"));
                    ReplacePlaceholder(body, "«AgreementExpDate»", Convert.ToDateTime(Convert.ToString(dt.Rows[0]["NewAgrExpDate"])).ToString("dd-MMM-yyyy"));
                    ReplacePlaceholder(body, "«OldAgreementDate»", Convert.ToDateTime(Convert.ToString(dt.Rows[0]["OldAgrDate"])).ToString("dd-MMM-yyyy"));
                    ReplacePlaceholder(body, "«OldAgreementExpDate»", Convert.ToDateTime(Convert.ToString(dt.Rows[0]["OldAgreementExpDate"])).ToString("dd-MMM-yyyy"));
                }
                catch { }
                ReplacePlaceholder(body, "«StartDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Renewal Agreement.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Renewal Agreement.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GeneratePseudonameAgreementLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Employee Undertaking_Pseudo name.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Undertaking_Pseudo Name.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Undertaking_Pseudo Name.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                string AgrDate = "";

                if (Convert.ToString(dt.Rows[0]["OldAgrDate"]) != "" || Convert.ToString(dt.Rows[0]["OldAgrDate"]) != string.Empty || Convert.ToString(dt.Rows[0]["OldAgrDate"]).Length > 0)
                    AgrDate = Convert.ToString(dt.Rows[0]["OldAgrDate"]);
                else
                    AgrDate = Convert.ToString(dt.Rows[0]["JoiningDate"]);

                ReplacePlaceholder(body, "«TitleName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«Name»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«DATEFORMAT»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«PermanentAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«FullNameRelation»", Convert.ToString(dt.Rows[0]["NameWithRelation"]));
                ReplacePlaceholder(body, "«AJBranchAddress»", Convert.ToString(dt.Rows[0]["AJBranchAddress"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«JoiningDate»", Convert.ToString(dt.Rows[0]["JoiningDate"]));
                ReplacePlaceholder(body, "«YearSalary»", Convert.ToString(dt.Rows[0]["YearSalary"]));
                ReplacePlaceholder(body, "«YearSalInWords»", numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["YearSalary"])).Replace("Fourty", "Forty") + " Only");
                ReplacePlaceholder(body, "«LetterDate»", Convert.ToString(dt.Rows[0]["TodaysDate"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«empage»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«AgreementDate»", AgrDate);
                ReplacePlaceholder(body, "«Psuedoname»", Convert.ToString(dt.Rows[0]["Psuedoname"]));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Undertaking_Pseudo Name.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Undertaking_Pseudo Name.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateAddendum25(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Addendum 1.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.5.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.5.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«AgreementDate»", Convert.ToString(dt.Rows[0]["DateOfAgreement"]));
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.5.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.5.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateAddendum2(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Addendum 2.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«AddendumDate»", Convert.ToString(dt.Rows[0]["AddendumDate1"]));
                ReplacePlaceholder(body, "«AgreementDate»", Convert.ToString(dt.Rows[0]["DateOfAgreement"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateJoiningChecklist(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/JoiningChecklist.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Joining Documents Checklist.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Joining Documents Checklist.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Department»", Convert.ToString(dt.Rows[0]["DepartmentName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«WordSalary»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«HRDept»", login_Desg);

                #endregion
            }


            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Joining Documents Checklist.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Joining Documents Checklist.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GeneratePersonalDetailsForm(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Personal Details Form.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Personal Details Form.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Personal Details Form.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Department»", Convert.ToString(dt.Rows[0]["DepartmentName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«WordSalary»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«HRDept»", login_Desg);

                #endregion
            }


            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Personal Details Form.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Personal Details Form.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateBackgroundVerificationForm(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Background Verification Form.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Background Verification Form.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Background Verification Form.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Department»", Convert.ToString(dt.Rows[0]["DepartmentName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«WordSalary»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«HRDept»", login_Desg);

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Background Verification Form.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Background Verification Form.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateAppendixB(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Appendix-B.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "_Appendix-B.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "_Appendix-B.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM yyyy"), ToOrdinal(DateTime.Now.Day)));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["Code"]) + "_Appendix-B.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "_Appendix-B.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateEPOSHAckForm(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Acknowledgement_Form_Prevention of Sexual Harassment.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Acknowledgement_Form_Prevention of Sexual Harassment.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Acknowledgement_Form_Prevention of Sexual Harassment.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«EmployeeID»", Convert.ToString(dt.Rows[0]["EmployeeID"]));
                ReplacePlaceholder(body, "«Department»", Convert.ToString(dt.Rows[0]["DepartmentName"]));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AckDate»", DateTime.Now.ToString("dd-MMM-yyyy"));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«LetterDate»", DateTime.Now.ToString("dd-MMM-yyyy"));
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Acknowledgement_Form_Prevention of Sexual Harassment.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Acknowledgement_Form_Prevention of Sexual Harassment.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateEPOSHDocument(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Policy_Prevention of Sexual Harassment.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Policy_Prevention of Sexual Harassment.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Policy_Prevention of Sexual Harassment.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«EmployeeID»", Convert.ToString(dt.Rows[0]["EmployeeID"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«LetterDate»", DateTime.Now.ToString("dd-MMM-yyyy"));
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Policy_Prevention of Sexual Harassment.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Policy_Prevention of Sexual Harassment.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GeneratePFDeclarationForm_2017(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/PFForm2017.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2017.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2017.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«Name»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«FatherSpouseName»", Convert.ToString(dt.Rows[0]["KYCFatherSpouseName"]));
                ReplacePlaceholder(body, "«DateOfBirth»", Convert.ToString(dt.Rows[0]["DateOfBirth"]));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]));
                ReplacePlaceholder(body, "«MaritalStatus»", Convert.ToString(dt.Rows[0]["KYCMaritalStatus"]));
                ReplacePlaceholder(body, "«EmailID»", Convert.ToString(dt.Rows[0]["EmailID"]));
                ReplacePlaceholder(body, "«CellNo»", Convert.ToString(dt.Rows[0]["CellNo"]));
                ReplacePlaceholder(body, "«DOJ»", Convert.ToString(dt.Rows[0]["JoiningDate"]));
                ReplacePlaceholder(body, "«BankAccountNo»", Convert.ToString(dt.Rows[0]["KYCBankAccountNo"]));
                ReplacePlaceholder(body, "«IFSCCode»", Convert.ToString(dt.Rows[0]["KYCIFSCCode"]));
                ReplacePlaceholder(body, "«AadharNo»", Convert.ToString(dt.Rows[0]["KYCAadhar"]));
                ReplacePlaceholder(body, "«PAN»", Convert.ToString(dt.Rows[0]["KYCPAN"]));
                ReplacePlaceholder(body, "«UAN»", Convert.ToString(dt.Rows[0]["UAN"]));
                ReplacePlaceholder(body, "«UANNo»", Convert.ToString(dt.Rows[0]["UAN"]));
                ReplacePlaceholder(body, "«PFNo»", Convert.ToString(dt.Rows[0]["PFNo"]));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2017.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2017.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GeneratePFDeclarationForm_2019(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/PFForm2019.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2019.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2019.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«Name»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«FatherSpouseName»", Convert.ToString(dt.Rows[0]["KYCFatherSpouseName"]));
                ReplacePlaceholder(body, "«DateOfBirth»", Convert.ToString(dt.Rows[0]["DateOfBirth"]));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]));
                ReplacePlaceholder(body, "«MaritalStatus»", Convert.ToString(dt.Rows[0]["KYCMaritalStatus"]));
                ReplacePlaceholder(body, "«EmailID»", Convert.ToString(dt.Rows[0]["EmailID"]));
                ReplacePlaceholder(body, "«CellNo»", Convert.ToString(dt.Rows[0]["CellNo"]));
                ReplacePlaceholder(body, "«DOJ»", Convert.ToString(dt.Rows[0]["JoiningDate"]));
                ReplacePlaceholder(body, "«BankAccountNo»", Convert.ToString(dt.Rows[0]["KYCBankAccountNo"]));
                ReplacePlaceholder(body, "«IFSCCode»", Convert.ToString(dt.Rows[0]["KYCIFSCCode"]));
                ReplacePlaceholder(body, "«AadharNo»", Convert.ToString(dt.Rows[0]["KYCAadhar"]));
                ReplacePlaceholder(body, "«PAN»", Convert.ToString(dt.Rows[0]["KYCPAN"]));
                ReplacePlaceholder(body, "«UAN»", Convert.ToString(dt.Rows[0]["UAN"]));
                ReplacePlaceholder(body, "«PFNo»", Convert.ToString(dt.Rows[0]["PFNo"]));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2019.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2019.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateRelievingLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Relieving letter_Revised_1.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Relieving letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Relieving letter.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«ResignationDate»", string.Format("{0} " + Convert.ToString(Convert.ToDateTime(dt.Rows[0]["ResignedDate"]).ToString("MMMM, yyyy")), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).Day)));
                ReplacePlaceholder(body, "«LastWorkingDate»", string.Format("{0} " + Convert.ToString(Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]).ToString("MMMM, yyyy")), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastLoginDate"])).Day)));
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«Hrdesig»", login_Desg);
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                ReplacePlaceholder(body, "«hihr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«AgreementDate»", Convert.ToDateTime(Convert.ToString(dt.Rows[0]["NewAgrDate"])).ToString("dd-MMM-yyyy"));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Relieving letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Relieving letter.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateExperienceLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Experience letter_2.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Experience Letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Experience Letter.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Department»", Convert.ToString(dt.Rows[0]["DepartmentName"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«From»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«To»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastLoginDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastLoginDate"])).Day)));
                ReplacePlaceholder(body, "«HRName»", login_Emp);
                ReplacePlaceholder(body, "«HRDept»", login_Desg);
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«hihr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Experience Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Experience Letter.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateNoDueCertificate(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/NoDueCertificate.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-No Due Certificate.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-No Due Certificate.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Department»", Convert.ToString(dt.Rows[0]["DepartmentName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«ResignedDate»", string.Format("{0} " + Convert.ToString(Convert.ToDateTime(dt.Rows[0]["ResignedDate"]).ToString("MMMM, yyyy")), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).Day)));
                ReplacePlaceholder(body, "«LastWorkingDate»", string.Format("{0} " + Convert.ToString(Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]).ToString("MMMM, yyyy")), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastLoginDate"])).Day)));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-No Due Certificate.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-No Due Certificate.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateUndertakingLetter(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/ExitUndertakingLetter_Underwriter.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Undertaking Letter.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Undertaking Letter.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«Department»", Convert.ToString(dt.Rows[0]["DepartmentName"]));
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Address»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Undertaking Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Undertaking Letter.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateExitInterviewForm(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/ExitInterviewHorizon.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Interview Form.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Interview Form.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«ResignedDate»", string.Format("{0} " + Convert.ToString(Convert.ToDateTime(dt.Rows[0]["ResignedDate"]).ToString("MMMM, yyyy")), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).Day)));
                ReplacePlaceholder(body, "«Department»", Convert.ToString(dt.Rows[0]["DepartmentName"]));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Interview Form.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Interview Form.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateExitChecklist(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Exit CheckList.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit CheckList.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit CheckList.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Desig»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Department»", Convert.ToString(dt.Rows[0]["DepartmentName"]));
                ReplacePlaceholder(body, "«CurrentDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«ResignationDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).Day)));
                ReplacePlaceholder(body, "«LastLoginDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastWorkingDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastWorkingDate"])).Day)));

                #endregion
            }
            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit CheckList.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit CheckList.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateExitDocumentCheckist(System.Data.DataTable dt)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/ExitDocumentChecklist.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Documents CheckList.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Documents CheckList.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«DOJ»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Code»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Desig»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Department»", Convert.ToString(dt.Rows[0]["DepartmentName"]));
                ReplacePlaceholder(body, "«CurrentDate»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«ResignationDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).Day)));
                ReplacePlaceholder(body, "«LastLoginDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastWorkingDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastWorkingDate"])).Day)));

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Documents CheckList.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Documents CheckList.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateEmployeeAgreement_5(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Employee Agreement_5.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«MRMonth»", Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRMonth"]));
                ReplacePlaceholder(body, "«MRYear»", Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRYear"]));
                ReplacePlaceholder(body, "«TRMonth»", Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRMonth"]));
                ReplacePlaceholder(body, "«TRYear»", Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRYear"]));
                ReplacePlaceholder(body, "«EAMonth»", Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAMonth"]));
                ReplacePlaceholder(body, "«EAYear»", Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAYear"]));
                ReplacePlaceholder(body, "«HAMonth»", Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAMonth"]));
                ReplacePlaceholder(body, "«HAYear»", Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAYear"]));
                ReplacePlaceholder(body, "«ABMonth»", Convert.ToString(dtAnnx.Rows[0]["ABMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ABMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ABMonth"]));
                ReplacePlaceholder(body, "«ABYear»", Convert.ToString(dtAnnx.Rows[0]["ABYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ABYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ABYear"]));
                ReplacePlaceholder(body, "«ESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«PFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«PFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«GrossSalaryMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossSalaryYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«GratuityMonth»", Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                ReplacePlaceholder(body, "«GratuityYear»", Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                ReplacePlaceholder(body, "«IncentiveMonth»", Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                ReplacePlaceholder(body, "«IncentiveYear»", Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                ReplacePlaceholder(body, "«NightBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                ReplacePlaceholder(body, "«NightBonusYear»", Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                ReplacePlaceholder(body, "«OtherBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                ReplacePlaceholder(body, "«OtherBonusYear»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                ReplacePlaceholder(body, "«ESICompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                ReplacePlaceholder(body, "«ESICompanyYear»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                ReplacePlaceholder(body, "«PFCompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                ReplacePlaceholder(body, "«PFCompanyYear»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                ReplacePlaceholder(body, "«LeaveEncashmentMonth»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                ReplacePlaceholder(body, "«LeaveEncashmentYear»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                ReplacePlaceholder(body, "«TotalContriMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«TotalContriYear»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«PTMonth»", Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                ReplacePlaceholder(body, "«PTYear»", Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                ReplacePlaceholder(body, "«ActualESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ActualESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«ActualPFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«ActualPFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionYear»", Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                ReplacePlaceholder(body, "«GrossEmpMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossEmpYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«NetMonth»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                ReplacePlaceholder(body, "«NetYear»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                ReplacePlaceholder(body, "«CompanyTotMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«CompanyTotYear»", Convert.ToString(dtAnnx.Rows[0]["CompanyTotYear"]));
                ReplacePlaceholder(body, "«TotalCostMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                ReplacePlaceholder(body, "«TotalCostYear»", Convert.ToString(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0")));
                ReplacePlaceholder(body, "«TotalCostInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"])).Replace("Fourty", "Forty") + " Only"));

                ReplacePlaceholder(body, "«Roles»", "");
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«EmpCode»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));

                doc.MainDocumentPart.Document.Save();
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateEmployeeAgreementWithoutBond_ForExp_analyst_credit5(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            Num2Wrd numEng = new Num2Wrd();

            string templatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 5-Banglore.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«MRMonth»", Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRMonth"]));
                ReplacePlaceholder(body, "«MRYear»", Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRYear"]));
                ReplacePlaceholder(body, "«TRMonth»", Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRMonth"]));
                ReplacePlaceholder(body, "«TRYear»", Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRYear"]));
                ReplacePlaceholder(body, "«EAMonth»", Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAMonth"]));
                ReplacePlaceholder(body, "«EAYear»", Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAYear"]));
                ReplacePlaceholder(body, "«HAMonth»", Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAMonth"]));
                ReplacePlaceholder(body, "«HAYear»", Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAYear"]));
                ReplacePlaceholder(body, "«ABMonth»", Convert.ToString(dtAnnx.Rows[0]["ABMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ABMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ABMonth"]));
                ReplacePlaceholder(body, "«ABYear»", Convert.ToString(dtAnnx.Rows[0]["ABYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ABYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ABYear"]));
                ReplacePlaceholder(body, "«ESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«PFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«PFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«GrossSalaryMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossSalaryYear1»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«GratuityMonth»", Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                ReplacePlaceholder(body, "«GratuityYear»", Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                ReplacePlaceholder(body, "«IncentiveMonth»", Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                ReplacePlaceholder(body, "«IncentiveYear»", Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                ReplacePlaceholder(body, "«NightBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                ReplacePlaceholder(body, "«NightBonusYear»", Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                ReplacePlaceholder(body, "«OtherBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                ReplacePlaceholder(body, "«OtherBonusYear»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                ReplacePlaceholder(body, "«ESICompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                ReplacePlaceholder(body, "«ESICompanyYear»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                ReplacePlaceholder(body, "«PFCompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                ReplacePlaceholder(body, "«PFCompanyYear»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                ReplacePlaceholder(body, "«LeaveEncashmentMonth»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                ReplacePlaceholder(body, "«LeaveEncashmentYear»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                ReplacePlaceholder(body, "«TotalContriMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«TotalContriYear1»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«PTMonth»", Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                ReplacePlaceholder(body, "«PTYear»", Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                ReplacePlaceholder(body, "«ActualESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ActualESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«ActualPFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«ActualPFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionYear1»", Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                ReplacePlaceholder(body, "«GrossEmpMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossEmpYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«NetMonth»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                ReplacePlaceholder(body, "«NetYear»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                ReplacePlaceholder(body, "«CompanyTotMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«CompanyTotYear»", Convert.ToString(dtAnnx.Rows[0]["CompanyTotYear"]));
                ReplacePlaceholder(body, "«TotalCostMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                ReplacePlaceholder(body, "«TotalCostYear1»", Convert.ToString(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0")));
                ReplacePlaceholder(body, "«TotalCostInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"])).Replace("Fourty", "Forty") + " Only"));

                ReplacePlaceholder(body, "«Roles»", "");
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«EmpCode»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));

                doc.MainDocumentPart.Document.Save();
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx"));
            Response.TransmitFile(path);
            Response.End();
        }

        public void GenerateEmployeeAgreementWithoutBond_ForExp_analyst5(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 5-Banglore-ForAll.dotx");
            string outputPath = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx");
            string FileName = Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«MRMonth»", Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRMonth"]));
                ReplacePlaceholder(body, "«MRYear»", Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["MRYear"]));
                ReplacePlaceholder(body, "«TRMonth»", Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRMonth"]));
                ReplacePlaceholder(body, "«TRYear»", Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TRYear"]));
                ReplacePlaceholder(body, "«EAMonth»", Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAMonth"]));
                ReplacePlaceholder(body, "«EAYear»", Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["EAYear"]));
                ReplacePlaceholder(body, "«HAMonth»", Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAMonth"]));
                ReplacePlaceholder(body, "«HAYear»", Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["HAYear"]));
                ReplacePlaceholder(body, "«ABMonth»", Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]));
                ReplacePlaceholder(body, "«ABYear»", Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]));
                ReplacePlaceholder(body, "«ESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«PFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«PFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«GrossSalaryMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossSalaryYear1»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«GratuityMonth»", Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                ReplacePlaceholder(body, "«GratuityYear»", Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                ReplacePlaceholder(body, "«IncentiveMonth»", Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                ReplacePlaceholder(body, "«IncentiveYear»", Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                ReplacePlaceholder(body, "«NightBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                ReplacePlaceholder(body, "«NightBonusYear»", Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                ReplacePlaceholder(body, "«OtherBonusMonth»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                ReplacePlaceholder(body, "«OtherBonusYear»", Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                ReplacePlaceholder(body, "«ESICompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                ReplacePlaceholder(body, "«ESICompanyYear»", Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                ReplacePlaceholder(body, "«PFCompanyMonth»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                ReplacePlaceholder(body, "«PFCompanyYear»", Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                ReplacePlaceholder(body, "«LeaveEncashmentMonth»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                ReplacePlaceholder(body, "«LeaveEncashmentYear»", Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                ReplacePlaceholder(body, "«TotalContriMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«TotalContriYear1»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«PTMonth»", Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                ReplacePlaceholder(body, "«PTYear»", Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                ReplacePlaceholder(body, "«ActualESIMonth»", Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                ReplacePlaceholder(body, "«ActualESIYear»", Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                ReplacePlaceholder(body, "«ActualPFYear»", Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                ReplacePlaceholder(body, "«ActualPFMonth»", Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                ReplacePlaceholder(body, "«TotalDeductionYear1»", Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                ReplacePlaceholder(body, "«GrossEmpMonth»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                ReplacePlaceholder(body, "«GrossEmpYear»", Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                ReplacePlaceholder(body, "«NetMonth»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                ReplacePlaceholder(body, "«NetYear»", Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                ReplacePlaceholder(body, "«CompanyTotMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                ReplacePlaceholder(body, "«CompanyTotYear»", Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                ReplacePlaceholder(body, "«TotalCostMonth»", Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                ReplacePlaceholder(body, "«TotalCostYear1»", Convert.ToString(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0")));
                ReplacePlaceholder(body, "«TotalCostInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"])).Replace("Fourty", "Forty") + " Only"));

                ReplacePlaceholder(body, "«Roles»", "");
                ReplacePlaceholder(body, "«EmployeeName»", Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                ReplacePlaceholder(body, "«WorkingBranch»", Convert.ToString(dt.Rows[0]["BranchName"]));
                ReplacePlaceholder(body, "«FirstName»", Convert.ToString(dt.Rows[0]["FirstName"]));
                ReplacePlaceholder(body, "«Age»", Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                ReplacePlaceholder(body, "«PerAddress»", Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                ReplacePlaceholder(body, "«OfficialEmail»", Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                ReplacePlaceholder(body, "«Pseudoname»", Convert.ToString(dt.Rows[0]["PsuedoName"]));
                ReplacePlaceholder(body, "«SisterCompany»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "Horizon Data Systems Pvt. Ltd." : "Infinity Data Technologies Pvt. Ltd.");
                ReplacePlaceholder(body, "«PresentAddress»", Convert.ToString(dt.Rows[0]["PresentAddress"]));
                ReplacePlaceholder(body, "«CompanyName»", Convert.ToString(dt.Rows[0]["CompanyName"]));
                ReplacePlaceholder(body, "«Designation»", Convert.ToString(dt.Rows[0]["DesignationName"]));
                ReplacePlaceholder(body, "«Salary»", Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                ReplacePlaceholder(body, "«DateAppendix»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«AppointDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Date»", string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                ReplacePlaceholder(body, "«JoiningDate»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«DateNormal»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«Gender»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "his" : "her");
                ReplacePlaceholder(body, "«EmpCode»", Convert.ToString(dt.Rows[0]["Code"]));
                ReplacePlaceholder(body, "«Gender2»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "him" : "her");
                ReplacePlaceholder(body, "«GenderSelf»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "himself" : "herself");
                ReplacePlaceholder(body, "«Abbr»", Convert.ToString(dt.Rows[0]["Gender"]) == "Male" ? "he" : "she");
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");
                ReplacePlaceholder(body, "«BondAmount»", Convert.ToString(parseValueIntoCurrency(Convert.ToDouble(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12))));
                ReplacePlaceholder(body, "«BondAmountWord»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"]) * 12).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«AgreementPeriod»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 year" : Convert.ToString(dt.Rows[0]["Period"]) + " years");
                ReplacePlaceholder(body, "«AgreementPeriodWithWord»", Convert.ToInt32(dt.Rows[0]["Period"]) == 1 ? "1 (One) year" : Convert.ToString(dt.Rows[0]["Period"]) + " (" + numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Period"])) + ") years");
                ReplacePlaceholder(body, "«SalaryInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["Salary"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«LetterDate»", string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                ReplacePlaceholder(body, "«LetterDate1»", string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                ReplacePlaceholder(body, "«Reference»", Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity") ? "APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]) : "APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));

                doc.MainDocumentPart.Document.Save();

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_5.docx"));
            Response.TransmitFile(path);
            Response.End();
        }


        #region Sub-Methods

        private void ReplacePlaceholder(OpenXmlElement parent, string placeholder, string newValue)
        {
            var textNodes = parent.Descendants<Text>().ToList();

            for (int i = 0; i < textNodes.Count; i++)
            {
                // Try to match placeholder that might be split across nodes
                if (IsSplitPlaceholderAt(textNodes, i, placeholder, out int endIndex))
                {
                    // Build the replacement text for special placeholders
                    string replacement = "";
                    if (placeholder == "«Roles»")
                    {
                        string rol = "";
                        System.Data.DataTable dtsch = new bllMaster().getSchedule1Data(EmployeeID);
                        if (dtsch != null)
                        {
                            if (dtsch.Rows.Count > 0)
                            {
                                StringBuilder rolerespo = new StringBuilder();
                                for (int i1 = 0; i1 < dtsch.Rows.Count; i1++)
                                {
                                    rolerespo.Append(Convert.ToString((i1 + 1) + ". " + dtsch.Rows[i1]["Responsibility"]) + "\n");
                                }
                                rol = HttpUtility.HtmlEncode(rolerespo);
                            }
                        }
                        replacement = rol;
                    }
                    //else if (placeholder == "«SalaryInWords»")
                    //{
                    //    replacement = ConvertSalaryToWords(newValue);
                    //}
                    else
                    {
                        replacement = newValue;
                    }
                    // Replace first node text with replacement
                    textNodes[i].Text = replacement;

                    // Clear all following nodes that were part of the placeholder
                    for (int j = i + 1; j <= endIndex; j++)
                    {
                        textNodes[j].Text = string.Empty;
                    }

                    i = endIndex; // Skip processed nodes
                }
                else if (textNodes[i].Text.Contains(placeholder))
                {
                    // If placeholder is contained within a single node (not split)
                    if (placeholder == "«Roles»")
                    {
                        string rol = "";
                        System.Data.DataTable dtsch = new bllMaster().getSchedule1Data(EmployeeID);
                        if (dtsch != null)
                        {
                            if (dtsch.Rows.Count > 0)
                            {
                                StringBuilder rolerespo = new StringBuilder();
                                for (int i1 = 0; i1 < dtsch.Rows.Count; i1++)
                                {
                                    rolerespo.Append(Convert.ToString((i1 + 1) + ". " + dtsch.Rows[i1]["Responsibility"]) + "\n");
                                }
                                rol = HttpUtility.HtmlEncode(rolerespo);
                            }
                        }
                        textNodes[i].Text = textNodes[i].Text.Replace(placeholder, rol);
                    }
                    else
                    {
                        textNodes[i].Text = textNodes[i].Text.Replace(placeholder, newValue);
                    }
                }
            }
        }

        // Helper method to check if placeholder exists starting at index i spanning multiple nodes
        private bool IsSplitPlaceholderAt(List<Text> nodes, int startIndex, string placeholder, out int endIndex)
        {
            endIndex = startIndex;
            StringBuilder sb = new StringBuilder();
            for (int j = startIndex; j < nodes.Count; j++)
            {
                sb.Append(nodes[j].Text);
                if (sb.Length > placeholder.Length)
                    break;

                if (sb.ToString() == placeholder)
                {
                    endIndex = j;
                    return true;
                }
            }
            return false;
        }

        public int calculateAge(DateTime doj)
        {
            int age = (int)((DateTime.Now - doj).TotalDays / 365.242199);
            return age;
        }

        public static string ToOrdinal(int number)
        {
            switch (number % 100)
            {
                case 11:
                case 12:
                case 13:
                    return number.ToString() + "th";
            }

            switch (number % 10)
            {
                case 1:
                    return number.ToString() + "st";
                case 2:
                    return number.ToString() + "nd";
                case 3:
                    return number.ToString() + "rd";
                default:
                    return number.ToString() + "th";
            }
        }

        public string parseValueIntoCurrency(double number)
        {
            // set currency format
            //Thread.CurrentThread.CurrentCulture = new CultureInfo("en-IN");
            string curCulture = Thread.CurrentThread.CurrentCulture.ToString();
            System.Globalization.NumberFormatInfo currencyFormat = new
                System.Globalization.CultureInfo(curCulture).NumberFormat;

            currencyFormat.CurrencyNegativePattern = 1;

            return number.ToString("c", currencyFormat).Replace(".00", "").Replace("$", "");
        }

        #endregion
    }
}