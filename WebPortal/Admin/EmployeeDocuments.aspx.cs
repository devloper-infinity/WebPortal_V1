using Microsoft.Office.Interop.Word;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;
using WebPortal.App_Code.EL;
//using DocumentFormat.OpenXml.Packaging;
//using DocumentFormat.OpenXml.Wordprocessing;
//using OpenXmlPowerTools;
//using DocumentFormat.OpenXml.Office.SpreadSheetML.Y2024.WorkbookCompatibilityVersion;
//using DocumentFormat.OpenXml;
//using Paragraph = DocumentFormat.OpenXml.Wordprocessing.Paragraph;

namespace WebPortal.Admin
{
    public partial class EmployeeDocuments : System.Web.UI.Page
    {
        static string Code;
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
            int EmployeeId = new bllMaster().GetEmployeeIdFromCode(Code);
            System.Data.DataTable dt1 = new bllLogin().GetUserInformation(EmployeeId);
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
                System.Data.DataTable dt = new bllLogin().GetUserInformation(EmployeeId);
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "OfferLetter")
                {
                    GenerateOfferLetter(dt);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "AppointmentLetter")
                {
                    System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Docs(Code, Convert.ToString(Request.Form["empdoc_incentive"]));
                    GenerateAppointmentLetter(dt, dtAnnx);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "ConfirmationLetter")
                {
                    GenerateConfirmationLetter(dt);
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
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "SalaryRivisionLetter")
                {
                    System.Data.DataTable dtEmp = new bllSalary().GetEmployeeSalaryIncrementDetailsForLetter(EmployeeId);
                    GenerateSalaryRevisionLetter(dtEmp);
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
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "EmployeeAgreementWithoutBondForExpAnalyst")
                {
                    System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Docs(Code, Convert.ToString(Request.Form["empdoc_incentive"]));
                    if (Convert.ToString(Request.Form["empdoc_subdomain_hid"]) == "Credit")
                        GenerateEmployeeAgreement_Analyst_Credit(dt, dtAnnx);
                    else
                        GenerateEmployeeAgreement_Analyst(dt, dtAnnx);
                }
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "ClientAcknowledgementLetterNew")
                {
                    GenerateClientAcknowledgementLetter(dt);
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
                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "EmployeeAgreementWithoutBondForExpAnalyst4")
                {
                    System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Docs(Code, Convert.ToString(Request.Form["empdoc_incentive"]));
                    if (Convert.ToString(Request.Form["empdoc_subdomain_hid"]) == "Credit")
                        GenerateEmployeeAgreementWithoutBond_ForExp_analyst_credit4(dt, dtAnnx);
                    else
                        GenerateEmployeeAgreementWithoutBond_ForExp_analyst4(dt, dtAnnx);
                }
                else if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "AppendixB")
                {
                    GenerateAppendixB(dt);
                }
                else if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "PF Declaration Form - 11 - 2017")
                {
                    System.Data.DataTable dtKYC = GetUserInformation_KYC(EmployeeId);
                    GeneratePFDeclarationForm_2017(dtKYC);
                }
                else if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "PF Declaration Form - 11 - 2019")
                {
                    System.Data.DataTable dtKYC = GetUserInformation_KYC(EmployeeId);
                    GeneratePFDeclarationForm_2019(dtKYC);
                }
            }
        }

        public System.Data.DataTable GetUserInformation_KYC(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUserInformation_KYC");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 50, System.Data.ParameterDirection.Input, EmployeeID);
            System.Data.DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public void GeneratePFDeclarationForm_2017(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            //Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement_1-WithoutBond.dotx");
            Object oTemplatePath;
            //Object oTemplatePath = Server.MapPath(@"~/Templates/Addendum to the Employment Agreement.dotx");
            oTemplatePath = Server.MapPath(@"~/Templates/PFForm2017.dotx");

            Application wordApp = new Application();
            Microsoft.Office.Interop.Word.Document wordDoc = new Microsoft.Office.Interop.Word.Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);


            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    // THE PROGRAMMER CAN HAVE HIS OWN IMPLEMENTATIONS HERE

                    if (fieldName == "Name")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "FatherSpouseName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCFatherSpouseName"]));
                    }
                    if (fieldName == "DateOfBirth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DateOfBirth"]));
                    }
                    if (fieldName == "Gender")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Gender"]));
                    }
                    if (fieldName == "MaritalStatus")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCMaritalStatus"]));
                    }
                    if (fieldName == "EmailID")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["EmailID"]));
                    }
                    if (fieldName == "CellNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CellNo"]));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["JoiningDate"]));
                    }
                    if (fieldName == "BankAccountNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCBankAccountNo"]));
                    }
                    if (fieldName == "IFSCCode")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCIFSCCode"]));
                    }
                    if (fieldName == "AadharNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCAadhar"]));
                    }
                    if (fieldName == "PAN")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCPAN"]));
                    }
                    if (fieldName == "UAN")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["UAN"]));
                    }
                    if (fieldName == "UANNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["UAN"]));
                    }
                    if (fieldName == "PFNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PFNo"]));
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2017.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            //tblDocs.Style.Add("display", "");
            //lblFileName.Text = "Employee Agreement_1.docx";
            //aDoc.HRef = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/Employee Agreement_1.docx");

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2017.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2017.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GeneratePFDeclarationForm_2019(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            //Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement_1-WithoutBond.dotx");
            Object oTemplatePath;
            //Object oTemplatePath = Server.MapPath(@"~/Templates/Addendum to the Employment Agreement.dotx");
            oTemplatePath = Server.MapPath(@"~/Templates/PFForm2019.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);


            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    // THE PROGRAMMER CAN HAVE HIS OWN IMPLEMENTATIONS HERE

                    if (fieldName == "Name")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "FatherSpouseName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCFatherSpouseName"]));
                    }
                    if (fieldName == "DateOfBirth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DateOfBirth"]));
                    }
                    if (fieldName == "Gender")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Gender"]));
                    }
                    if (fieldName == "MaritalStatus")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCMaritalStatus"]));
                    }
                    if (fieldName == "EmailID")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["EmailID"]));
                    }
                    if (fieldName == "CellNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CellNo"]));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["JoiningDate"]));
                    }
                    if (fieldName == "BankAccountNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCBankAccountNo"]));
                    }
                    if (fieldName == "IFSCCode")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCIFSCCode"]));
                    }
                    if (fieldName == "AadharNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCAadhar"]));
                    }
                    if (fieldName == "PAN")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["KYCPAN"]));
                    }
                    if (fieldName == "UAN")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["UAN"]));
                    }
                    if (fieldName == "PFNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PFNo"]));
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2019.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            //tblDocs.Style.Add("display", "");
            //lblFileName.Text = "Employee Agreement_1.docx";
            //aDoc.HRef = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/Employee Agreement_1.docx");

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2019.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-PF Declaration - 11 - 2019.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateEPOSHAckForm(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Acknowledgement_Form_Prevention of Sexual Harassment.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    // THE PROGRAMMER CAN HAVE HIS OWN IMPLEMENTATIONS HERE

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "EmployeeID")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["EmployeeID"]));
                    }
                    if (fieldName == "Department")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DepartmentName"]));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["JoiningDate"]));
                    }
                    if (fieldName == "AckDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(DateTime.Now.ToString("dd-MMM-yyyy"));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(DateTime.Now.ToString("dd-MMM-yyyy"));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Acknowledgement_Form_Prevention of Sexual Harassment.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            //tblDocs.Style.Add("display", "");
            //lblFileName.Text = "Employee Agreement_1.docx";
            //aDoc.HRef = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/Employee Agreement_1.docx");

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "Acknowledgement_Form_Prevention of Sexual Harassment.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "Acknowledgement_Form_Prevention of Sexual Harassment.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateEPOSHDocument(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Policy_Prevention of Sexual Harassment.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    // THE PROGRAMMER CAN HAVE HIS OWN IMPLEMENTATIONS HERE

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "EmployeeID")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["EmployeeID"]));
                    }

                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(DateTime.Now.ToString("dd-MMM-yyyy"));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Policy_Prevention of Sexual Harassment.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            //tblDocs.Style.Add("display", "");
            //lblFileName.Text = "Employee Agreement_1.docx";
            //aDoc.HRef = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/Employee Agreement_1.docx");

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Policy_Prevention of Sexual Harassment.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Policy_Prevention of Sexual Harassment.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateEmployeeAgreementWithoutBond4(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            //Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement_1-WithoutBond.dotx");
            Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement_4.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {
                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    // THE PROGRAMMER CAN HAVE HIS OWN IMPLEMENTATIONS HERE
                    if (fieldName == "Roles")
                    {
                        int EmployeeID = Convert.ToInt32(dt.Rows[0]["EmployeeID"]);
                        System.Data.DataTable dtsch = new bllMaster().getSchedule1Data(EmployeeID);
                        if (dtsch != null)
                        {
                            if (dtsch.Rows.Count > 0)
                            {
                                StringBuilder rolerespo = new StringBuilder();
                                for (int i = 0; i < dtsch.Rows.Count; i++)
                                {
                                    rolerespo.Append(Convert.ToString((i + 1) + ". " + dtsch.Rows[i]["Responsibility"]) + "\n");
                                }
                                string rol = HttpUtility.HtmlEncode(rolerespo);
                                myMergeField.Select();
                                wordApp.Selection.TypeText(rol);
                            }
                        }
                    }
                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "WorkingBranch")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BranchName"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "PerAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "OfficialEmail")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                    }
                    if (fieldName == "Pseudoname")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PsuedoName"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                    }
                    if (fieldName == "DateAppendix")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "DateNormal")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "AppointDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "DateAppendix")
                    {

                    }

                    if (fieldName == "StartDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Swapnali");
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Gender2")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "GenderSelf")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("himself");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("herself");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("he");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("she");
                        }
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }
                    if (fieldName == "BondAmount")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(BondAmount)));
                    }
                    if (fieldName == "BondAmountWord")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(BondAmount).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "SalaryInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        //int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "AgreementPeriod")
                    {
                        myMergeField.Select();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " years");
                    }
                    if (fieldName == "AgreementPeriodWithWord")
                    {
                        myMergeField.Select();
                        Num2Wrd numEng = new Num2Wrd();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " years");
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "LetterDate1")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            //tblDocs.Style.Add("display", "");
            //lblFileName.Text = "Employee Agreement_1.docx";
            //aDoc.HRef = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/Employee Agreement_1.docx");

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateEmployeeAgreementWithoutBond_ForExp_analyst4(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            Object oMissing = System.Reflection.Missing.Value;
            //Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement_1-WithoutBond.dotx");
            Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 4-Bangalore-ForAll.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);


            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    // THE PROGRAMMER CAN HAVE HIS OWN IMPLEMENTATIONS HERE
                    if (fieldName == "Roles")
                    {
                        int EmployeeID = Convert.ToInt32(dt.Rows[0]["EmployeeID"]);
                        System.Data.DataTable dtsch = new bllMaster().getSchedule1Data(EmployeeID);
                        if (dtsch != null)
                        {
                            if (dtsch.Rows.Count > 0)
                            {
                                StringBuilder rolerespo = new StringBuilder();
                                for (int i = 0; i < dtsch.Rows.Count; i++)
                                {
                                    rolerespo.Append(Convert.ToString((i + 1) + ". " + dtsch.Rows[i]["Responsibility"]) + "\n");
                                }
                                string rol = HttpUtility.HtmlEncode(rolerespo);
                                myMergeField.Select();
                                wordApp.Selection.TypeText(rol);
                            }
                        }
                    }
                    if (fieldName == "BasicDAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                    }
                    if (fieldName == "BasicDAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                    }
                    if (fieldName == "HRAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                    }
                    if (fieldName == "HRAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                    }
                    if (fieldName == "MRMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["MRMonth"]));
                        }
                    }
                    if (fieldName == "MRYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["MRYear"]));
                        }

                    }
                    if (fieldName == "TRMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TRMonth"]));
                        }

                    }
                    if (fieldName == "TRYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TRYear"]));
                        }

                    }
                    if (fieldName == "EAMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["EAMonth"]));
                        }
                    }
                    if (fieldName == "EAYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["EAYear"]));
                        }
                    }
                    if (fieldName == "HAMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HAMonth"]));
                        }
                    }
                    if (fieldName == "HAYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HAYear"]));
                        }
                    }
                    if (fieldName == "ABMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]));
                        }
                    }
                    if (fieldName == "ABYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]));
                        }
                    }
                    if (fieldName == "ESIMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ESIYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "PFMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "PFYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "GrossSalaryMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossSalaryYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "GratuityMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                    }
                    if (fieldName == "GratuityYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                    }
                    if (fieldName == "IncentiveMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                        }
                    }
                    if (fieldName == "IncentiveYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                        }
                    }
                    if (fieldName == "NightBonusMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                        }
                    }
                    if (fieldName == "NightBonusYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                        }
                    }
                    if (fieldName == "OtherBonusMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                        }
                    }
                    if (fieldName == "OtherBonusYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                        }
                    }
                    if (fieldName == "ESICompanyMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                        }
                    }
                    if (fieldName == "ESICompanyYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                        }
                    }
                    if (fieldName == "PFCompanyMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                        }
                    }
                    if (fieldName == "PFCompanyYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                        }
                    }
                    if (fieldName == "TotalContriMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                        }
                    }
                    if (fieldName == "TotalContriYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                        }
                    }
                    if (fieldName == "PTMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                        }
                    }
                    if (fieldName == "PTYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                        }
                    }
                    //if (fieldName == "PTMonth")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PTMonth"]));
                    //}
                    //if (fieldName == "PTYear")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PTYear"]));
                    //}
                    if (fieldName == "ActualESIMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ActualESIYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "ActualPFMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "ActualPFYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "TotalDeductionMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                        }
                    }
                    if (fieldName == "TotalDeductionYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                        }
                    }
                    if (fieldName == "GrossEmpMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossEmpYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "NetMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                    }
                    if (fieldName == "NetYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                    }
                    if (fieldName == "CompanyTotMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                    }
                    if (fieldName == "CompanyTotYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                    }
                    if (fieldName == "TotalCostMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                    }
                    if (fieldName == "TotalCostYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostYear"]));
                    }

                    if (fieldName == "WorkingBranch")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BranchName"]));
                    }
                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "PerAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "OfficialEmail")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                    }
                    if (fieldName == "Pseudoname")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PsuedoName"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                    }
                    if (fieldName == "DateAppendix")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "AppointDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "DateNormal")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    //if (fieldName == "AppointDate")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    //    // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    //}

                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "EmpCode")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }

                    if (fieldName == "StartDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Swapnali");
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Gender2")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "GenderSelf")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("himself");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("herself");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("he");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("she");
                        }
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }
                    if (fieldName == "BondAmount")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(BondAmount)));
                    }
                    if (fieldName == "BondAmountWord")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(BondAmount).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "SalaryInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        //int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "AgreementPeriod")
                    {
                        myMergeField.Select();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " years");
                    }
                    if (fieldName == "AgreementPeriodWithWord")
                    {
                        myMergeField.Select();
                        Num2Wrd numEng = new Num2Wrd();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " years");
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "LetterDate1")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            //tblDocs.Style.Add("display", "");
            //lblFileName.Text = "Employee Agreement_1.docx";
            //aDoc.HRef = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/Employee Agreement_1.docx");

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateEmployeeAgreementWithoutBond_ForExp_analyst_credit4(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            Object oMissing = System.Reflection.Missing.Value;
            //Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement_1-WithoutBond.dotx");
            Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 4-Bangalore.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);


            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    // THE PROGRAMMER CAN HAVE HIS OWN IMPLEMENTATIONS HERE
                    if (fieldName == "Roles")
                    {
                        int EmployeeID = Convert.ToInt32(dt.Rows[0]["EmployeeID"]);
                        System.Data.DataTable dtsch = new bllMaster().getSchedule1Data(EmployeeID);
                        if (dtsch != null)
                        {
                            if (dtsch.Rows.Count > 0)
                            {
                                StringBuilder rolerespo = new StringBuilder();
                                for (int i = 0; i < dtsch.Rows.Count; i++)
                                {
                                    rolerespo.Append(Convert.ToString((i + 1) + ". " + dtsch.Rows[i]["Responsibility"]) + "\n");
                                }
                                string rol = HttpUtility.HtmlEncode(rolerespo);
                                myMergeField.Select();
                                wordApp.Selection.TypeText(rol);
                            }
                        }
                    }
                    if (fieldName == "BasicDAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                    }
                    if (fieldName == "BasicDAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                    }
                    if (fieldName == "HRAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                    }
                    if (fieldName == "HRAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                    }
                    if (fieldName == "MRMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["MRMonth"]));
                        }
                    }
                    if (fieldName == "MRYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["MRYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["MRYear"]));
                        }

                    }
                    if (fieldName == "TRMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TRMonth"]));
                        }

                    }
                    if (fieldName == "TRYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TRYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TRYear"]));
                        }

                    }
                    if (fieldName == "EAMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["EAMonth"]));
                        }
                    }
                    if (fieldName == "EAYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["EAYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["EAYear"]));
                        }
                    }
                    if (fieldName == "HAMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HAMonth"]));
                        }
                    }
                    if (fieldName == "HAYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["HAYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HAYear"]));
                        }
                    }
                    if (fieldName == "ABMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusMonth"]));
                        }
                    }
                    if (fieldName == "ABYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["AttendanceBonusYear"]));
                        }
                    }
                    if (fieldName == "ESIMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ESIYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "PFMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "PFYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "GrossSalaryMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossSalaryYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "GratuityMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                    }
                    if (fieldName == "GratuityYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                    }
                    if (fieldName == "IncentiveMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                        }
                    }
                    if (fieldName == "IncentiveYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                        }
                    }
                    if (fieldName == "NightBonusMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                        }
                    }
                    if (fieldName == "NightBonusYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                        }
                    }
                    if (fieldName == "OtherBonusMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                        }
                    }
                    if (fieldName == "OtherBonusYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                        }
                    }
                    if (fieldName == "ESICompanyMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                        }
                    }
                    if (fieldName == "ESICompanyYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                        }
                    }
                    if (fieldName == "PFCompanyMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                        }
                    }
                    if (fieldName == "PFCompanyYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                        }
                    }
                    if (fieldName == "TotalContriMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                        }
                    }
                    if (fieldName == "TotalContriYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                        }
                    }
                    if (fieldName == "PTMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                        }
                    }
                    if (fieldName == "PTYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                        }
                    }
                    //if (fieldName == "PTMonth")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PTMonth"]));
                    //}
                    //if (fieldName == "PTYear")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PTYear"]));
                    //}
                    if (fieldName == "ActualESIMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ActualESIYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "ActualPFMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "ActualPFYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "TotalDeductionMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                        }
                    }
                    if (fieldName == "TotalDeductionYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                        }
                    }
                    if (fieldName == "GrossEmpMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossEmpYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "NetMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                    }
                    if (fieldName == "NetYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                    }
                    if (fieldName == "CompanyTotMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                    }
                    if (fieldName == "CompanyTotYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                    }
                    if (fieldName == "TotalCostMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                    }
                    if (fieldName == "TotalCostYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0"));
                        //wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostYear"]));
                    }
                    if (fieldName == "TotalCostInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dtAnnx.Rows[0]["TotalCostYear"]));
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                        //myMergeField.Select();
                        //wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostYear"]));
                    }


                    if (fieldName == "WorkingBranch")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BranchName"]));
                    }
                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "PerAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "OfficialEmail")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                    }
                    if (fieldName == "Pseudoname")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PsuedoName"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                    }
                    if (fieldName == "DateAppendix")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "AppointDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "DateNormal")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    //if (fieldName == "AppointDate")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    //    // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    //}

                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "EmpCode")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }

                    if (fieldName == "StartDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Swapnali");
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Gender2")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "GenderSelf")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("himself");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("herself");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("he");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("she");
                        }
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }
                    if (fieldName == "BondAmount")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(BondAmount)));
                    }
                    if (fieldName == "BondAmountWord")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(BondAmount).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "SalaryInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        //int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "AgreementPeriod")
                    {
                        myMergeField.Select();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " years");
                    }
                    if (fieldName == "AgreementPeriodWithWord")
                    {
                        myMergeField.Select();
                        Num2Wrd numEng = new Num2Wrd();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " years");
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "LetterDate1")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            //tblDocs.Style.Add("display", "");
            //lblFileName.Text = "Employee Agreement_1.docx";
            //aDoc.HRef = Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/Employee Agreement_1.docx");

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_4.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateAppendixB(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Appendix-B.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    // THE PROGRAMMER CAN HAVE HIS OWN IMPLEMENTATIONS HERE
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "PerAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["Code"]) + "_Appendix-B.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["Code"]) + "_Appendix-B.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["Code"]) + "_Appendix-B.docx"));
            Response.TransmitFile(path);
            Response.End();

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

        public int calculateAge(DateTime doj)
        {
            int age = (int)((DateTime.Now - doj).TotalDays / 365.242199);
            return age;
        }

        public void GenerateOfferLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Offer Letter.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "EmployeeId")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["EmployeeId"]));
                    }

                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                    }

                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("OFL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("OFL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }

                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }

                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "HRDept")
                    {
                        myMergeField.Select();
                        string Dept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                Dept = Convert.ToString(dt1.Rows[0]["DesignationName"]);
                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(Dept);
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Offer Letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Offer Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Offer Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateAppointmentLetter(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Appointment Letter.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "IncentiveLabel")
                    {
                        if (Convert.ToString(Request.Form["empdoc_subdomain_hid"]) == "Credit")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Target Potential Variable Earning");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Approx. Incentive");
                        }
                    }

                    if (fieldName == "BasicDAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                    }
                    if (fieldName == "BasicDAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                    }
                    if (fieldName == "HRAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                    }
                    if (fieldName == "HRAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                    }
                    if (fieldName == "ESIMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ESIYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "PFMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "PFYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "GrossSalaryMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossSalaryYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "GratuityMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                    }
                    if (fieldName == "GratuityYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                    }
                    if (fieldName == "IncentiveMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                        }
                    }
                    if (fieldName == "IncentiveYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                        }
                    }
                    if (fieldName == "NightBonusMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                        }
                    }
                    if (fieldName == "NightBonusYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                        }
                    }
                    if (fieldName == "OtherBonusMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                        }
                    }
                    if (fieldName == "OtherBonusYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                        }
                    }
                    if (fieldName == "ESICompanyMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                        }
                    }
                    if (fieldName == "ESICompanyYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                        }
                    }
                    if (fieldName == "PFCompanyMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                        }
                    }
                    if (fieldName == "PFCompanyYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                        }
                    }
                    if (fieldName == "TotalContriMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                        }
                    }
                    if (fieldName == "TotalContriYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                        }
                    }
                    if (fieldName == "PTMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                        }
                    }
                    if (fieldName == "PTYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                        }
                    }

                    if (fieldName == "ActualESIMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ActualESIYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "ActualPFMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "ActualPFYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "TotalDeductionMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                        }
                    }
                    if (fieldName == "TotalDeductionYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                        }
                    }
                    if (fieldName == "GrossEmpMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossEmpYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "NetMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                    }
                    if (fieldName == "NetYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                    }
                    if (fieldName == "CompanyTotMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                    }
                    if (fieldName == "CompanyTotYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                    }
                    if (fieldName == "TotalCostMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                    }
                    if (fieldName == "TotalCostYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0"));
                        //wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostYear"]));
                    }
                    if (fieldName == "TotalCostInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dtAnnx.Rows[0]["TotalCostYear"]));
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                    }

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0}  " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }

                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["New1Salary"]));
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(Salary)).Replace("Fourty", "Forty"));
                    }
                    if (fieldName == "WordSalary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(NumberToText.Convert(Convert.ToInt32(dt.Rows[0]["Salary"])));
                    }
                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }

                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "AppointmentDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "HRDept")
                    {
                        myMergeField.Select();
                        string Dept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                Dept = Convert.ToString(dt1.Rows[0]["DesignationName"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(Dept);
                    }


                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appointment Letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appointment Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appointment Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateConfirmationLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Confirmation letter1.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                    }

                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "ConfirmationDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(dt.Rows[0]["JoiningDate"]).AddMonths(6).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(dt.Rows[0]["JoiningDate"]).AddMonths(6).Day)));
                    }
                    if (fieldName == "RefNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("CF/" + Convert.ToString(dt.Rows[0]["CompanyName"]).Substring(0, 3).ToUpper() + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]));
                    }

                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "HRDept")
                    {
                        myMergeField.Select();
                        string Dept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                Dept = Convert.ToString(dt1.Rows[0]["DesignationName"]);
                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(Dept);
                    }
                }
            }

            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Confirmation Letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Confirmation Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Confirmation Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateIdemnityBond(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/IdemnityBond.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "Name")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "PermAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(dt.Rows[0]["JoiningDate"]).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(dt.Rows[0]["JoiningDate"]).Day)));
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("he");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("she");
                        }
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }

                    if (fieldName == "BondAmount")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(BondAmount)));
                    }
                    if (fieldName == "BondAmountWord")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(BondAmount).Replace("Fourty", "Forty"));
                    }
                    if (fieldName == "BondPeriod")
                    {
                        myMergeField.Select();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " years");
                    }


                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-IdemnityBond.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-IdemnityBond.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-IdemnityBond.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateAppendixA(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Appendix-A-Version1.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }


                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appendix-A.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appendix-A.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Appendix-A.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateEmployeeAgreement3(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 3-2023 ForAll.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "WorkingBranch")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BranchName"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "PerAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "OfficialEmail")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                    }
                    if (fieldName == "Pseudoname")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PsuedoName"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                    }
                    if (fieldName == "DateAppendix")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "DateNormal")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "AppointDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }

                    if (fieldName == "StartDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Swapnali");
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Gender2")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "GenderSelf")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("himself");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("herself");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("he");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("she");
                        }
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }
                    if (fieldName == "BondAmount")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(BondAmount)));
                    }
                    if (fieldName == "BondAmountWord")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(BondAmount).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "SalaryInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        //int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "AgreementPeriod")
                    {
                        myMergeField.Select();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " years");
                    }
                    if (fieldName == "AgreementPeriodWithWord")
                    {
                        myMergeField.Select();
                        Num2Wrd numEng = new Num2Wrd();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " years");
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "LetterDate1")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_3.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_3.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_3.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GeneratePromotionLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Promotion Letter.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PromoteDesignation"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["NewCompanyName"]));
                    }
                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["NewCompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));

                        if (Convert.ToString(dt.Rows[0]["PromotionEffectiveDate"]) != null && Convert.ToString(dt.Rows[0]["PromotionEffectiveDate"]) != "")

                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PromotionEffectiveDate"]));
                        else
                            wordApp.Selection.TypeText(" ");

                    }

                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "HRDept")
                    {
                        myMergeField.Select();
                        string Dept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                Dept = Convert.ToString(dt1.Rows[0]["DesignationName"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(Dept);
                    }


                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Promotion Letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Promotion Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Promotion Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateSalaryRevisionLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Salary Revision Notification.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "ExistingSalary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BeforeSalary"]));
                    }
                    if (fieldName == "IncrementedAmount")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Difference"]));
                    }
                    if (fieldName == "RevisedSalary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CurrentSalary"]));
                    }
                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();

                        if (Convert.ToString(dt.Rows[0]["EffectiveDate"]) != null && Convert.ToString(dt.Rows[0]["EffectiveDate"]) != "")

                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["EffectiveDate"]));
                        else
                            wordApp.Selection.TypeText(" ");
                    }

                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);
                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "HRDept")
                    {
                        myMergeField.Select();
                        string Dept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                Dept = Convert.ToString(dt1.Rows[0]["DesignationName"]);
                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(Dept);
                    }


                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Salary Revision Letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Salary Revision Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Salary Revision Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateAddressVerificationLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Address Verification Letter.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "Name")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }

                    if (fieldName == "PermAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }

                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }

                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }

                    if (fieldName == "First Name")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Address Verification Letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Address Verification Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Address Verification Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateAnnexure(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Annexure1.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {
                    // THE TEXT COMES IN THE FORMAT OF
                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT
                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//


                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["EmployeeName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Designation"]));
                    }
                    if (fieldName == "BasicDAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BasicDAMonth"]));
                    }
                    if (fieldName == "BasicDAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BasicDAYear"]));
                    }
                    if (fieldName == "HRAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["HRAMonth"]));
                    }
                    if (fieldName == "HRAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["HRAYear"]));
                    }
                    if (fieldName == "ESIMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dt.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ESIYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dt.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "PFMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dt.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "PFYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["PFYear"]) == "0" || Convert.ToString(dt.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "GrossSalaryMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossSalaryYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "GratuityMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["GratuityMonth"]));
                    }
                    if (fieldName == "GratuityYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["GratuityYear"]));
                    }
                    if (fieldName == "IncentiveMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dt.Rows[0]["IncentiveMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["IncentiveMonth"]));
                        }
                    }
                    if (fieldName == "IncentiveYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dt.Rows[0]["IncentiveYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["IncentiveYear"]));
                        }
                    }
                    if (fieldName == "NightBonusMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dt.Rows[0]["NightBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["NightBonusMonth"]));
                        }
                    }
                    if (fieldName == "NightBonusYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dt.Rows[0]["NightBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["NightBonusYear"]));
                        }
                    }
                    if (fieldName == "OtherBonusMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dt.Rows[0]["OtherBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OtherBonusMonth"]));
                        }
                    }
                    if (fieldName == "OtherBonusYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dt.Rows[0]["OtherBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OtherBonusYear"]));
                        }
                    }
                    if (fieldName == "ESICompanyMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dt.Rows[0]["ESICompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["ESICompanyMonth"]));
                        }
                    }
                    if (fieldName == "ESICompanyYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dt.Rows[0]["ESICompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["ESICompanyYear"]));
                        }
                    }
                    if (fieldName == "PFCompanyMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dt.Rows[0]["PFCompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PFCompanyMonth"]));
                        }
                    }
                    if (fieldName == "PFCompanyYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dt.Rows[0]["PFCompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PFCompanyYear"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dt.Rows[0]["LeaveEncashmentMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["LeaveEncashmentMonth"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dt.Rows[0]["LeaveEncashmentYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["LeaveEncashmentYear"]));
                        }
                    }
                    if (fieldName == "TotalContriMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dt.Rows[0]["TotalBMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["TotalBMonth"]));
                        }
                    }
                    if (fieldName == "TotalContriYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dt.Rows[0]["TotalBYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["TotalBYear"]));
                        }
                    }
                    if (fieldName == "PTMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dt.Rows[0]["PTMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PTMonth"]));
                        }
                    }
                    if (fieldName == "PTYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["PTYear"]) == "0" || Convert.ToString(dt.Rows[0]["PTYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PTYear"]));
                        }
                    }
                    if (fieldName == "ActualESIMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dt.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ActualESIYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dt.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "ActualPFMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dt.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "ActualPFYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["PFYear"]) == "0" || Convert.ToString(dt.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "TotalDeductionMonth")
                    {
                        if (Convert.ToString(dt.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dt.Rows[0]["TotalCMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["TotalCMonth"]));
                        }
                    }
                    if (fieldName == "TotalDeductionYear")
                    {
                        if (Convert.ToString(dt.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dt.Rows[0]["TotalCYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["TotalCYear"]));
                        }
                    }
                    if (fieldName == "GrossEmpMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossEmpYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "NetMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["NetSalaryMonth"]));
                    }
                    if (fieldName == "NetYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["NetSalaryYear"]));
                    }
                    if (fieldName == "CompanyTotMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["TotalBMonth"]));
                    }
                    if (fieldName == "CompanyTotYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["TotalBYear"]));
                    }
                    if (fieldName == "TotalCostMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["TotalCostMonth"]));
                    }
                    if (fieldName == "TotalCostYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["TotalCostYear"]));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(Salary)).Replace("Fourty", "Forty"));
                    }
                    if (fieldName == "WordSalary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(NumberToText.Convert(Convert.ToInt32(dt.Rows[0]["Salary"])));
                    }
                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "HRDept")
                    {
                        myMergeField.Select();
                        string Dept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                Dept = Convert.ToString(dt1.Rows[0]["DesignationName"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(Dept);
                    }



                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Annexure.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Annexure.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Annexure.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateAccountTransferLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/AccountTransferLetter.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["EmpFullName"]) + " (" + Convert.ToString(dt.Rows[0]["Code"]) + ") ");
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["JoiningDate"]));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["TodaysDate"]));
                    }
                    if (fieldName == "EMPCODE")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "AccountNo")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BankAccNo"]));
                    }
                    if (fieldName == "BankName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BankName"]));
                    }
                    if (fieldName == "TitleSpecification" || fieldName == "TitleSpecification1")
                    {
                        myMergeField.Select();

                        string Title = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(Convert.ToString(dt.Rows[0]["EmpTitle"]).ToLower());

                        wordApp.Selection.TypeText(Title);
                    }
                    if (fieldName == "HrName")
                    {

                        System.Data.DataTable dtEmp = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dtEmp.Rows.Count > 0)
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtEmp.Rows[0]["Title"]) + " " + Convert.ToString(dtEmp.Rows[0]["FirstName"]) + " " + Convert.ToString(dtEmp.Rows[0]["LastName"]));
                        }
                    }


                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Account Transfer Letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Account Transfer Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Account Transfer Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateRenewalAgreementLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Renewal Agreement_ Infinity.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "PerAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                    }
                    if (fieldName == "DateAppendix")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                    }
                    if (fieldName == "DateNormal")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "AppointmentDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "AgreementDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["NewAgrDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "AgreementExpDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["NewAgrExpDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }

                    if (fieldName == "OldAgreementDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["OldAgrDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "OldAgreementExpDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["OldAgrExpDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }

                    if (fieldName == "StartDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Gender2")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "GenderSelf")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("himself");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("herself");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("he");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("she");
                        }
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }
                    if (fieldName == "BondAmount")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(BondAmount)));
                    }
                    if (fieldName == "BondAmountWord")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(BondAmount).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "SalaryInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        //int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "AgreementPeriod")
                    {
                        myMergeField.Select();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " years");
                    }
                    if (fieldName == "AgreementPeriodWithWord")
                    {
                        myMergeField.Select();
                        Num2Wrd numEng = new Num2Wrd();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " years");
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "LetterDate1")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }



                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Renewal Agreement.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Renewal Agreement.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Renewal Agreement.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GeneratePseudonameAgreementLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Undertaking_Pseudo name.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "TitleName" || fieldName == "Name")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "DateFormat")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "PermanentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "FullNameRelation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["NameWithRelation"]));
                    }
                    if (fieldName == "AJBranchAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["AJBranchAddress"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["JoiningDate"]));
                    }
                    if (fieldName == "YearSalary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["YearSalary"]));
                    }
                    if (fieldName == "YearSalInWords")
                    {
                        myMergeField.Select();

                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Convert.ToInt32(dt.Rows[0]["YearSalary"])).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["TodaysDate"]));
                    }
                    if (fieldName == "Age" || fieldName == "age" || fieldName == "empage")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "AgreementDate")
                    {
                        if (Convert.ToString(dt.Rows[0]["OldAgrDate"]) != "" || Convert.ToString(dt.Rows[0]["OldAgrDate"]) != string.Empty || Convert.ToString(dt.Rows[0]["OldAgrDate"]).Length > 0)
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OldAgrDate"]));
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["JoiningDate"]));
                        }
                    }

                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("His");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Her");
                        }
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Undertaking_Pseudo Name.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Undertaking_Pseudo Name.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Undertaking_Pseudo Name.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateAddendum25(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Addendum 1.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "PerAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "OfficialEmail")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                    }
                    if (fieldName == "Pseudoname")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PsuedoName"]));
                    }
                    if (fieldName == "AgreementDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DateOfAgreement"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                    }
                    if (fieldName == "DateAppendix")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "DateNormal")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "AppointDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }

                    if (fieldName == "StartDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Swapnali");
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Gender2")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "GenderSelf")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("himself");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("herself");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("he");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("she");
                        }
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }
                    if (fieldName == "BondAmount")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(BondAmount)));
                    }
                    if (fieldName == "BondAmountWord")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(BondAmount).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "SalaryInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        //int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "AgreementPeriod")
                    {
                        myMergeField.Select();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " years");
                    }
                    if (fieldName == "AgreementPeriodWithWord")
                    {
                        myMergeField.Select();
                        Num2Wrd numEng = new Num2Wrd();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " years");
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "LetterDate1")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.5.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.5.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.5.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateAddendum2(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Addendum 2.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "PerAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "OfficialEmail")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                    }
                    if (fieldName == "Pseudoname")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PsuedoName"]));
                    }
                    if (fieldName == "AddendumDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["AddendumDate1"]));
                    }
                    if (fieldName == "AgreementDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DateOfAgreement"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                    }
                    if (fieldName == "DateAppendix")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "DateNormal")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "AppointDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }

                    if (fieldName == "StartDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Swapnali");
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Gender2")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "GenderSelf")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("himself");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("herself");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("he");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("she");
                        }
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }
                    if (fieldName == "BondAmount")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(BondAmount)));
                    }
                    if (fieldName == "BondAmountWord")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(BondAmount).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "SalaryInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        //int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "AgreementPeriod")
                    {
                        myMergeField.Select();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " years");
                    }
                    if (fieldName == "AgreementPeriodWithWord")
                    {
                        myMergeField.Select();
                        Num2Wrd numEng = new Num2Wrd();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " years");
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "LetterDate1")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Addendum_2.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateEmployeeAgreement_Analyst_Credit(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 3-Bangalore.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "BasicDAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                    }
                    if (fieldName == "BasicDAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                    }
                    if (fieldName == "HRAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                    }
                    if (fieldName == "HRAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                    }

                    if (fieldName == "ESIMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ESIYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "PFMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "PFYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "GrossSalaryMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossSalaryYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "GratuityMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                    }
                    if (fieldName == "GratuityYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                    }
                    if (fieldName == "IncentiveMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                        }
                    }
                    if (fieldName == "IncentiveYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                        }
                    }
                    if (fieldName == "NightBonusMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                        }
                    }
                    if (fieldName == "NightBonusYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                        }
                    }
                    if (fieldName == "OtherBonusMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                        }
                    }
                    if (fieldName == "OtherBonusYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                        }
                    }
                    if (fieldName == "ESICompanyMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                        }
                    }
                    if (fieldName == "ESICompanyYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                        }
                    }
                    if (fieldName == "PFCompanyMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                        }
                    }
                    if (fieldName == "PFCompanyYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                        }
                    }
                    if (fieldName == "TotalContriMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                        }
                    }
                    if (fieldName == "TotalContriYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                        }
                    }
                    if (fieldName == "PTMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                        }
                    }
                    if (fieldName == "PTYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                        }
                    }
                    //if (fieldName == "PTMonth")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PTMonth"]));
                    //}
                    //if (fieldName == "PTYear")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PTYear"]));
                    //}
                    if (fieldName == "ActualESIMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ActualESIYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "ActualPFMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "ActualPFYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "TotalDeductionMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                        }
                    }
                    if (fieldName == "TotalDeductionYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                        }
                    }
                    if (fieldName == "GrossEmpMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossEmpYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "NetMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                    }
                    if (fieldName == "NetYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                    }
                    if (fieldName == "CompanyTotMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                    }
                    if (fieldName == "CompanyTotYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                    }
                    if (fieldName == "TotalCostMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                    }
                    if (fieldName == "TotalCostYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dtAnnx.Rows[0]["TotalCostYear"]).ToString("#,##0"));
                        //wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostYear"]));
                    }
                    if (fieldName == "TotalCostInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dtAnnx.Rows[0]["TotalCostYear"]));
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                        //myMergeField.Select();
                        //wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostYear"]));
                    }


                    if (fieldName == "WorkingBranch")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BranchName"]));
                    }
                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "PerAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "OfficialEmail")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                    }
                    if (fieldName == "Pseudoname")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PsuedoName"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                    }
                    if (fieldName == "DateAppendix")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "AppointDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "DateNormal")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    //if (fieldName == "AppointDate")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    //    // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    //}

                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "EmpCode")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }

                    if (fieldName == "StartDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Swapnali");
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Gender2")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "GenderSelf")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("himself");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("herself");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("he");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("she");
                        }
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }
                    if (fieldName == "BondAmount")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(BondAmount)));
                    }
                    if (fieldName == "BondAmountWord")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(BondAmount).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "SalaryInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        //int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "AgreementPeriod")
                    {
                        myMergeField.Select();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " years");
                    }
                    if (fieldName == "AgreementPeriodWithWord")
                    {
                        myMergeField.Select();
                        Num2Wrd numEng = new Num2Wrd();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " years");
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "LetterDate1")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }


                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateEmployeeAgreement_Analyst(System.Data.DataTable dt, System.Data.DataTable dtAnnx)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Employee Agreement Version 3-Bangalore-ForAll.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "BasicDAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["BasicDAMonth"]));
                    }
                    if (fieldName == "BasicDAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["BasicDAYear"]));
                    }
                    if (fieldName == "HRAMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HRAMonth"]));
                    }
                    if (fieldName == "HRAYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["HRAYear"]));
                    }

                    if (fieldName == "ESIMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ESIYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "PFMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "PFYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "GrossSalaryMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossSalaryYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "GratuityMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GratuityMonth"]));
                    }
                    if (fieldName == "GratuityYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GratuityYear"]));
                    }
                    if (fieldName == "IncentiveMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["IncentiveMonth"]));
                        }
                    }
                    if (fieldName == "IncentiveYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["IncentiveYear"]));
                        }
                    }
                    if (fieldName == "NightBonusMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NightBonusMonth"]));
                        }
                    }
                    if (fieldName == "NightBonusYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NightBonusYear"]));
                        }
                    }
                    if (fieldName == "OtherBonusMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["OtherBonusMonth"]));
                        }
                    }
                    if (fieldName == "OtherBonusYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["OtherBonusYear"]));
                        }
                    }
                    if (fieldName == "ESICompanyMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESICompanyMonth"]));
                        }
                    }
                    if (fieldName == "ESICompanyYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESICompanyYear"]));
                        }
                    }
                    if (fieldName == "PFCompanyMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFCompanyMonth"]));
                        }
                    }
                    if (fieldName == "PFCompanyYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFCompanyYear"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentMonth"]));
                        }
                    }
                    if (fieldName == "LeaveEncashmentYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["LeaveEncashmentYear"]));
                        }
                    }
                    if (fieldName == "TotalContriMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                        }
                    }
                    if (fieldName == "TotalContriYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                        }
                    }
                    if (fieldName == "PTMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PTMonth"]));
                        }
                    }
                    if (fieldName == "PTYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PTYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PTYear"]));
                        }
                    }
                    //if (fieldName == "PTMonth")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PTMonth"]));
                    //}
                    //if (fieldName == "PTYear")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PTYear"]));
                    //}
                    if (fieldName == "ActualESIMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIMonth"]));
                        }
                    }
                    if (fieldName == "ActualESIYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["ESIYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["ESIYear"]));
                        }
                    }
                    if (fieldName == "ActualPFMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFMonth"]));
                        }
                    }
                    if (fieldName == "ActualPFYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["PFYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["PFYear"]));
                        }
                    }
                    if (fieldName == "TotalDeductionMonth")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCMonth"]));
                        }
                    }
                    if (fieldName == "TotalDeductionYear")
                    {
                        if (Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0" || Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]) == "0.00")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("N/A");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCYear"]));
                        }
                    }
                    if (fieldName == "GrossEmpMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryMonth"]));
                    }
                    if (fieldName == "GrossEmpYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["GrossSalaryYear"]));
                    }
                    if (fieldName == "NetMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NetSalaryMonth"]));
                    }
                    if (fieldName == "NetYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["NetSalaryYear"]));
                    }
                    if (fieldName == "CompanyTotMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBMonth"]));
                    }
                    if (fieldName == "CompanyTotYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalBYear"]));
                    }
                    if (fieldName == "TotalCostMonth")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostMonth"]));
                    }
                    if (fieldName == "TotalCostYear")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dtAnnx.Rows[0]["TotalCostYear"]));
                    }

                    if (fieldName == "WorkingBranch")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BranchName"]));
                    }
                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }
                    if (fieldName == "PerAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "OfficialEmail")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["OfficialEmailLetter"]));
                    }
                    if (fieldName == "Pseudoname")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PsuedoName"]));
                    }
                    if (fieldName == "SisterCompany")
                    {
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Horizon Data Systems Pvt. Ltd.");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("Infinity Data Technologies Pvt. Ltd.");
                        }
                    }
                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToInt32(dt.Rows[0]["Salary"]).ToString("#,##0"));
                    }
                    if (fieldName == "DateAppendix")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "AppointDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "JoiningDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "DateNormal")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    //if (fieldName == "AppointDate")
                    //{
                    //    myMergeField.Select();
                    //    wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    //    // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    //}

                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "EmpCode")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }

                    if (fieldName == "StartDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Swapnali");
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "Gender2")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "GenderSelf")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("himself");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("herself");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("he");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("she");
                        }
                    }
                    if (fieldName == "Representative")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mr. Sagar Kenkar");
                    }
                    if (fieldName == "BondAmount")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(BondAmount)));
                    }
                    if (fieldName == "BondAmountWord")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(BondAmount).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "SalaryInWords")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        //int BondAmount = Salary * 12;
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(numEng.ConvertMyword(Salary).Replace("Fourty", "Forty") + " Only");
                    }
                    if (fieldName == "AgreementPeriod")
                    {
                        myMergeField.Select();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " years");
                    }
                    if (fieldName == "AgreementPeriodWithWord")
                    {
                        myMergeField.Select();
                        Num2Wrd numEng = new Num2Wrd();
                        int BondPeriod = Convert.ToInt32(dt.Rows[0]["Period"]);
                        if (BondPeriod == 1)
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " year");
                        else
                            wordApp.Selection.TypeText(Convert.ToString(BondPeriod) + " (" + numEng.ConvertMyword(BondPeriod).Replace("Fourty", "Forty") + ")" + " years");
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "LetterDate1")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Employee Agreement_1.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateClientAcknowledgementLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Client-Acknowledgement LetterNew.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//
                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "EmployeeCode")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "Date")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }


                    if (fieldName == "PresentAddress")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PresentAddress"]));
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Client Acknowledgement Letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Client Acknowledgement Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Client Acknowledgement Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateJoiningChecklist(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/JoiningChecklist.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0}  " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Department")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DepartmentName"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }

                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(Salary)).Replace("Fourty", "Forty"));
                    }
                    if (fieldName == "WordSalary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(NumberToText.Convert(Convert.ToInt32(dt.Rows[0]["Salary"])));
                    }
                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }

                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "AppointmentDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "HRDept")
                    {
                        myMergeField.Select();
                        string Dept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                Dept = Convert.ToString(dt1.Rows[0]["DesignationName"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(Dept);
                    }


                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Joining Documents Checklist.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Joining Documents Checklist.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Joining Documents Checklist.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GeneratePersonalDetailsForm(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Personal Details Form.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//
                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0}  " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Department")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DepartmentName"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }

                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(Salary)).Replace("Fourty", "Forty"));
                    }
                    if (fieldName == "WordSalary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(NumberToText.Convert(Convert.ToInt32(dt.Rows[0]["Salary"])));
                    }
                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }

                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "AppointmentDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "HRDept")
                    {
                        myMergeField.Select();
                        string Dept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                Dept = Convert.ToString(dt1.Rows[0]["DesignationName"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(Dept);
                    }


                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Personal Details Form.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Personal Details Form.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Personal Details Form.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateBackgroundVerificationForm(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Background Verification Form.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0}  " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]).Replace(", ", "," + System.Environment.NewLine));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Department")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DepartmentName"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }

                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Salary")
                    {
                        myMergeField.Select();
                        int Salary = Convert.ToInt32(Convert.ToString(dt.Rows[0]["Salary"]));
                        Num2Wrd numEng = new Num2Wrd();
                        wordApp.Selection.TypeText(parseValueIntoCurrency(Convert.ToDouble(Salary)).Replace("Fourty", "Forty"));
                    }
                    if (fieldName == "WordSalary")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(NumberToText.Convert(Convert.ToInt32(dt.Rows[0]["Salary"])));
                    }
                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("APL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("APL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }

                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "AppointmentDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }
                    if (fieldName == "HRDept")
                    {
                        myMergeField.Select();
                        string Dept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                Dept = Convert.ToString(dt1.Rows[0]["DesignationName"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(Dept);
                    }


                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Background Verification Form.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Background Verification Form.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Background Verification Form.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateRelievingLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Relieving letter_Revised_1.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }

                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "FirstName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["FirstName"]));
                    }
                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "ResignationDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToString(Convert.ToDateTime(dt.Rows[0]["ResignedDate"]).ToString("MMMM, yyyy")), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).Day)));
                    }
                    if (fieldName == "LastWorkingDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToString(Convert.ToDateTime(dt.Rows[0]["LastLoginDate"]).ToString("MMMM, yyyy")), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastLoginDate"])).Day)));
                    }
                    if (fieldName == "WorkingBranch")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BranchName"]));
                    }
                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "Hrdesig")
                    {
                        myMergeField.Select();
                        string HRDept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                HRDept = Convert.ToString(dt1.Rows[0]["DesignationName"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(HRDept);
                    }
                    if (fieldName == "Reference")
                    {
                        myMergeField.Select();
                        if (Convert.ToString(dt.Rows[0]["CompanyName"]).Contains("Infinity"))
                        {
                            wordApp.Selection.TypeText("REL/INF/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                        else
                        {
                            wordApp.Selection.TypeText("REL/HOR/" + Convert.ToString(dt.Rows[0]["EmployeeId"]));
                        }
                    }
                    if (fieldName == "hihr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "AgreementDate")
                    {
                        myMergeField.Select();
                        //wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                        try
                        {
                            wordApp.Selection.TypeText(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["NewAgrDate"])).ToString("dd-MMM-yyyy"));
                        }
                        catch { }
                        // wordApp.Selection.TypeText(string.Format("{0} day of " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["AppointmentDate"])).Day)));
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Relieving letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Relieving letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Relieving letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateExperienceLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Experience letter_2.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }

                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Department")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DepartmentName"]));
                    }
                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "From")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "To")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastLoginDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastLoginDate"])).Day)));
                    }
                    if (fieldName == "HRName")
                    {
                        myMergeField.Select();
                        string AddedByName = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                AddedByName = Convert.ToString(dt1.Rows[0]["Title"]) + " " + Convert.ToString(dt1.Rows[0]["FirstName"]) + " " + Convert.ToString(dt1.Rows[0]["lastname"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(AddedByName);
                    }
                    if (fieldName == "HRDept")
                    {
                        myMergeField.Select();
                        string Dept = "";
                        System.Data.DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        if (dt1.Rows.Count > 0)
                        {
                            try
                            {
                                Dept = Convert.ToString(dt1.Rows[0]["DesignationName"]);

                            }
                            catch { }
                        }
                        wordApp.Selection.TypeText(Dept);
                    }
                    if (fieldName == "Gender")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("his");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "hihr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("him");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("her");
                        }
                    }
                    if (fieldName == "Abbr")
                    {
                        if (Convert.ToString(dt.Rows[0]["Gender"]) == "Male")
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("He");
                        }
                        else
                        {
                            myMergeField.Select();
                            wordApp.Selection.TypeText("She");
                        }
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Experience Letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Experience Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Experience Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateNoDueCertificate(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/    .dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }

                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }
                    if (fieldName == "Department")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DepartmentName"]));
                    }
                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }

                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "ResignedDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).Day)));
                    }
                    if (fieldName == "LastWorkingDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastLoginDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastLoginDate"])).Day)));
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-No Due Certificate.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-No Due Certificate.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-No Due Certificate.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateExitInterviewForm(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/ExitInterviewHorizon.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }

                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]).ToUpper());
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["JoiningDate"]));
                    }
                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }

                    if (fieldName == "ResignedDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["ResignedDate"]));
                    }
                    if (fieldName == "Department")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DepartmentName"]));
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Interview Form.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Interview Form.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Interview Form.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateUndertakingLetter(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/ExitUndertakingLetter_Underwriter.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }


                    if (fieldName == "Department")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DepartmentName"]));
                    }
                    if (fieldName == "WorkingBranch")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["BranchName"]));
                    }
                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Designation")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Age")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(calculateAge(Convert.ToDateTime(dt.Rows[0]["DateOfBirth"]))));
                    }

                    if (fieldName == "LetterDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }
                    if (fieldName == "Address")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["PermenentAddress"]));
                    }
                    if (fieldName == "CompanyName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["CompanyName"]));
                    }

                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Undertaking Letter.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Undertaking Letter.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Undertaking Letter.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateExitChecklist(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/Exit CheckList.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }

                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Desig")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Department")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DepartmentName"]));
                    }
                    if (fieldName == "CurrentDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "ResignationDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).Day)));
                    }
                    if (fieldName == "LastLoginDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastWorkingDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastWorkingDate"])).Day)));
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit CheckList.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit CheckList.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit CheckList.docx"));
            Response.TransmitFile(path);
            Response.End();

        }

        public void GenerateExitDocumentCheckist(System.Data.DataTable dt)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = Server.MapPath(@"~/Templates/ExitDocumentChecklist.dotx");

            Application wordApp = new Application();
            Document wordDoc = new Document();

            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);

            foreach (Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;
                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {

                    // THE TEXT COMES IN THE FORMAT OF

                    // MERGEFIELD  MyFieldName  \\* MERGEFORMAT

                    // THIS HAS TO BE EDITED TO GET ONLY THE FIELDNAME "MyFieldName"

                    Int32 endMerge = fieldText.IndexOf("\\");

                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = "";
                    if (endMerge != -1)
                        fieldName = fieldText.Substring(11, endMerge - 11);
                    else
                        fieldName = fieldText.Substring(11);

                    // GIVES THE FIELDNAMES AS THE USER HAD ENTERED IN .dot FILE

                    fieldName = fieldName.Trim();
                    // **** FIELD REPLACEMENT IMPLEMENTATION GOES HERE ****//

                    if (fieldName == "EmployeeName")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Title"]) + " " + Convert.ToString(dt.Rows[0]["FirstName"]) + " " + Convert.ToString(dt.Rows[0]["MiddleName"]) + " " + Convert.ToString(dt.Rows[0]["LastName"]));
                    }
                    if (fieldName == "DOJ")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["JoiningDate"])).Day)));
                    }

                    if (fieldName == "Code")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["Code"]));
                    }
                    if (fieldName == "Desig")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DesignationName"]));
                    }
                    if (fieldName == "Department")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(Convert.ToString(dt.Rows[0]["DepartmentName"]));
                    }
                    if (fieldName == "CurrentDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + DateTime.Now.ToString("MMMM, yyyy"), ToOrdinal(DateTime.Now.Day)));
                    }
                    if (fieldName == "ResignationDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["ResignedDate"])).Day)));
                    }
                    if (fieldName == "LastLoginDate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText(string.Format("{0} " + Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastWorkingDate"])).ToString("MMMM, yyyy"), ToOrdinal(Convert.ToDateTime(Convert.ToString(dt.Rows[0]["LastWorkingDate"])).Day)));
                    }
                }
            }
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"])));
            wordDoc.SaveAs(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Documents CheckList.docx"));
            wordApp.Documents.Close();
            wordApp.Application.Quit();

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Documents CheckList.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dt.Rows[0]["Code"]) + "/" + Convert.ToString(dt.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dt.Rows[0]["Code"]) + "-Exit Documents CheckList.docx"));
            Response.TransmitFile(path);
            Response.End();

        }


        protected void btn11_Click(object sender, EventArgs e)
        {
            if (Code != "")
            {
                int EmployeeId = new bllMaster().GetEmployeeIdFromCode(Code);
                System.Data.DataTable dt = new bllLogin().GetUserInformation(EmployeeId);

                if (Convert.ToString(Request.Form["empdoc_doctype_hid"]) == "AppointmentLetter")
                {
                    System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Docs(Code, Convert.ToString(Request.Form["empdoc_incentive"]));
                    //GenerateAppointmentLetter_New(dt, dtAnnx);
                }
            }
        }

    }
}
