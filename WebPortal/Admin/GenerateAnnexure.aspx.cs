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
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using OpenXmlPowerTools;
using DocumentFormat.OpenXml.Office.SpreadSheetML.Y2024.WorkbookCompatibilityVersion;
using DocumentFormat.OpenXml;
using System.Data;
using Microsoft.Office.Interop.Excel;
using Microsoft.Office.Interop.Word;

namespace WebPortal.Admin
{
    public partial class GenerateAnnexure : System.Web.UI.Page
    {
        static int EmployeeID;
        Num2Wrd numEng = new Num2Wrd();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetVerificationRecords(string Type, string Salary, string IncentiveAmount)
        {
            System.Data.DataTable dt1 = null;
            if (Type == "Analyst Annexure")
                dt1 = new bllSalary().GetAnnexure1Data_Analyst(Salary, IncentiveAmount);
            else
                dt1 = new bllSalary().GetAnnexure1Data(Salary);
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

        protected void btn1_Click(object sender, EventArgs e)
        {
            string Type = Convert.ToString(Request.Form["annexure_type"]);
            string Salary = Convert.ToString(Request.Form["annexure_salary"]);
            string Amount = Convert.ToString(Request.Form["annexure_inentive"]);
            if (Type == "Analyst Annexure")
            {
                System.Data.DataTable dtAnnx = new bllSalary().GetAnnexure1Data_Analyst(Salary, Amount);
                GenerateEmployeeAgreementWithoutBond_ForExp_analyst_credit(dtAnnx);
            }
            else
            {
                System.Data.DataTable dt = new bllSalary().GetAnnexure1Data(Salary);
                GenerateAnnexure1(dt);
            }
        }

        public void GenerateEmployeeAgreementWithoutBond_ForExp_analyst_credit(System.Data.DataTable dtAnex)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/AnnexureAnalyst.dotx");
            string outputPath = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "/Annexure.docx"));
            string FileName = Convert.ToString(dtAnex.Rows[0]["Code"]) + "/" + Convert.ToString(dtAnex.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "-Annexure.docx";
            File.Copy(templatePath, outputPath, overwrite: true);

            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnex.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnex.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnex.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnex.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«MRMonth»", Convert.ToString(dtAnex.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["MRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["MRMonth"]));
                ReplacePlaceholder(body, "«MRYear»", Convert.ToString(dtAnex.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["MRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["MRYear"]));
                ReplacePlaceholder(body, "«TRMonth»", Convert.ToString(dtAnex.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["TRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["TRMonth"]));
                ReplacePlaceholder(body, "«TRYear»", Convert.ToString(dtAnex.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["TRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["TRYear"]));
                ReplacePlaceholder(body, "«EAMonth»", Convert.ToString(dtAnex.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["EAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["EAMonth"]));
                ReplacePlaceholder(body, "«EAYear»", Convert.ToString(dtAnex.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["EAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["EAYear"]));
                ReplacePlaceholder(body, "«HAMonth»", Convert.ToString(dtAnex.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["HAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["HAMonth"]));
                ReplacePlaceholder(body, "«HAYear»", Convert.ToString(dtAnex.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["HAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["HAYear"]));
                ReplacePlaceholder(body, "«ABMonth»", Convert.ToString(dtAnex.Rows[0]["AttendanceBonusMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["AttendanceBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["AttendanceBonusMonth"]));
                ReplacePlaceholder(body, "«ABYear»", Convert.ToString(dtAnex.Rows[0]["AttendanceBonusYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["AttendanceBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["AttendanceBonusYear"]));
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
                ReplacePlaceholder(body, "«TotalCostInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnex.Rows[0]["TotalCostYear"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");

                doc.MainDocumentPart.Document.Save();

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=Annexure.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "/Annexure.docx"));
            Response.TransmitFile(path);
            Response.End();
            Response.Redirect("GenerateAnnexure.aspx");
        }

        public void GenerateAnnexure1(System.Data.DataTable dtAnex)
        {
            if (!Directory.Exists(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"]))))
                Directory.CreateDirectory(Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"])));

            string templatePath = Server.MapPath(@"~/Templates/Annexure1.dotx");
            string outputPath = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "/Annexure.docx"));
            string FileName = Convert.ToString(dtAnex.Rows[0]["Code"]) + "/" + Convert.ToString(dtAnex.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "-Annexure.docx";
            File.Copy(templatePath, outputPath, overwrite: true);


            using (WordprocessingDocument doc = WordprocessingDocument.Open(outputPath, true))
            {
                #region Fields

                doc.ChangeDocumentType(WordprocessingDocumentType.Document);

                var body = doc.MainDocumentPart.Document.Body;

                ReplacePlaceholder(body, "«BasicDAMonth»", Convert.ToString(dtAnex.Rows[0]["BasicDAMonth"]));
                ReplacePlaceholder(body, "«BasicDAYear»", Convert.ToString(dtAnex.Rows[0]["BasicDAYear"]));
                ReplacePlaceholder(body, "«HRAMonth»", Convert.ToString(dtAnex.Rows[0]["HRAMonth"]));
                ReplacePlaceholder(body, "«HRAYear»", Convert.ToString(dtAnex.Rows[0]["HRAYear"]));
                ReplacePlaceholder(body, "«MRMonth»", Convert.ToString(dtAnex.Rows[0]["MRMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["MRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["MRMonth"]));
                ReplacePlaceholder(body, "«MRYear»", Convert.ToString(dtAnex.Rows[0]["MRYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["MRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["MRYear"]));
                ReplacePlaceholder(body, "«TRMonth»", Convert.ToString(dtAnex.Rows[0]["TRMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["TRMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["TRMonth"]));
                ReplacePlaceholder(body, "«TRYear»", Convert.ToString(dtAnex.Rows[0]["TRYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["TRYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["TRYear"]));
                ReplacePlaceholder(body, "«EAMonth»", Convert.ToString(dtAnex.Rows[0]["EAMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["EAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["EAMonth"]));
                ReplacePlaceholder(body, "«EAYear»", Convert.ToString(dtAnex.Rows[0]["EAYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["EAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["EAYear"]));
                ReplacePlaceholder(body, "«HAMonth»", Convert.ToString(dtAnex.Rows[0]["HAMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["HAMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["HAMonth"]));
                ReplacePlaceholder(body, "«HAYear»", Convert.ToString(dtAnex.Rows[0]["HAYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["HAYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["HAYear"]));
                ReplacePlaceholder(body, "«ABMonth»", Convert.ToString(dtAnex.Rows[0]["AttendanceBonusMonth"]) == "0" || Convert.ToString(dtAnex.Rows[0]["AttendanceBonusMonth"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["AttendanceBonusMonth"]));
                ReplacePlaceholder(body, "«ABYear»", Convert.ToString(dtAnex.Rows[0]["AttendanceBonusYear"]) == "0" || Convert.ToString(dtAnex.Rows[0]["AttendanceBonusYear"]) == "0.00" ? "N/A" : Convert.ToString(dtAnex.Rows[0]["AttendanceBonusYear"]));
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
                ReplacePlaceholder(body, "«TotalCostInWords»", Convert.ToString(numEng.ConvertMyword(Convert.ToInt32(dtAnex.Rows[0]["TotalCostYear"])).Replace("Fourty", "Forty") + " Only"));
                ReplacePlaceholder(body, "«Representative»", "Mr. Sagar Kenkar");

                doc.MainDocumentPart.Document.Save();

                #endregion
            }

            Response.ContentType = "application/msword";
            Response.AppendHeader("Content-Disposition", "attachment; filename=Annexure.docx");
            string path = (Server.MapPath(@"~/EmployeeDocuments/" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "/Annexure.docx"));
            Response.TransmitFile(path);
            Response.End();
            Response.Redirect("GenerateAnnexure.aspx");
        }

        #region Sub-Methods

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

        #endregion
    }
}