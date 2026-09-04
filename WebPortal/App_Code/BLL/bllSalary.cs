using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Office2010.Excel;
using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllSalary
    {
        dalSalary dalSalary = new dalSalary();

        public DataTable GetSalaryIncrementDue(string Month)
        {
            return dalSalary.GetSalaryIncrementDue(Month);
        }


        public DataTable GetEmployeeSalarySlip()
        {
            return dalSalary.GetEmployeeSalarySlip();
        }

        public DataTable GetAllSalaryLogs(int EmployeeID)
        {
            return dalSalary.GetAllSalaryLogs(EmployeeID);
        }

        public DataTable GetCostperLoanSummaryReport(string year, string Domain)
        {
            return dalSalary.GetCostperLoanSummaryReport(year, Domain);
        }

        public DataTable getSalaryDetails(string Code)
        {
            return dalSalary.getSalaryDetails(Code);
        }

        public DataTable GetSalaryDetails_CurrentMonth(string Code, string Month, string Year)
        {
           return dalSalary.GetSalaryDetails_CurrentMonth(Code, Month, Year);
        }

        public DataTable GetViewTDSDeclaration_OLD(string TaxYear, int EmployeeID)
        {
            return dalSalary.GetViewTDSDeclaration_OLD(TaxYear, EmployeeID);
        }
        public DataTable GetViewTDSDeclaration_NEW(string TaxYear, int EmployeeID)
        {
            return dalSalary.GetViewTDSDeclaration_NEW(TaxYear, EmployeeID);
        }

        public DataTable GetTaxSlab(int EmployeeID)
        {
            return dalSalary.GetTaxSlab(EmployeeID);
        }
        public int InsertTaxSlab(Hashtable htParam)
        {
            return dalSalary.InsertTaxSlab(htParam);
        }

        public DataTable GetViewTDSDeclaration(string TaxYear, int EmployeeID)
        {
            return dalSalary.GetViewTDSDeclaration(TaxYear, EmployeeID);
        }

        public DataTable GetAllCategory()
        {
            return dalSalary.GetAllCategory();
        }

        public DataTable GetAllDocumentNameByCategory(string Category)
        {
            return dalSalary.GetAllDocumentNameByCategory(Category);
        }

        public DataTable GetAnnexure1Data(string Salary)
        {
            return dalSalary.GetAnnexure1Data(Salary);
        }

        public DataTable GetAnnexure1Data_Analyst(string Salary, string IncentiveAmount)
        {
            return dalSalary.GetAnnexure1Data_Analyst(Salary, IncentiveAmount);
        }
        public DataTable GetAnnexure1Data_Docs(string Code, string IncentiveAmount)
        {
            return dalSalary.GetAnnexure1Data_Docs(Code, IncentiveAmount);
        }
        public DataTable GetEmployeeDetailsTransferCompany(string Code)
        {
            return dalSalary.GetEmployeeDetailsTransferCompany(Code);
        }
        public DataTable GetEmployeeSalaryIncrementDetailsForLetter(int EmployeeID)
        {
            return dalSalary.GetEmployeeSalaryIncrementDetailsForLetter(EmployeeID);

        }
        public DataTable GetDueForIncrementForStep1(int EmployeeID)
        {
            return dalSalary.GetDueForIncrementForStep1(EmployeeID);
        }
        public int InsertProposedIncrementByPM(Hashtable htParam)
        {
            return dalSalary.InsertProposedIncrementByPM(htParam);
        }

        public int InsertProposedIncrementByPM_UnderWriting(Hashtable htParam)
        {
            return dalSalary.InsertProposedIncrementByPM_UnderWriting(htParam);
        }
        public int InsertIncrementDue_Step1(Hashtable htParam)
        {
            return dalSalary.InsertIncrementDue_Step1(htParam);
        }

        public DataTable GetAllBonus(string Month, int year)
        {
            return dalSalary.GetAllBonus(Month, year);
        }

        public int InsertIncrement(Hashtable htParam)
        {
            return dalSalary.InsertIncrement(htParam);
        }

        public DataSet GetCostperLoanReport(string Month, string year, string Domain)
        {
            return dalSalary.GetCostperLoanReport(Month, year, Domain);
        }

        public DataTable GetAllIncrementDifferenceForReport(string Month, int year)
        {
            return dalSalary.GetAllIncrementDifferenceForReport(Month, year);
        }

        public int InsertBonus(Hashtable htParam)
        {
            return dalSalary.InsertBonus(htParam);
        }

        public DataTable GetESIPFDeductionReport(string Month, string year)
        {
            return dalSalary.GetESIPFDeductionReport(Month, year);
        }

        public DataTable GetTotalSalaryReport(string Code, string Period)
        {
            return dalSalary.GetTotalSalaryReport(Code, Period);
        }

        public DataTable GetTotalSalaryReport(string Period)
        {
            return dalSalary.GetTotalSalaryReport(Period);
        }

        public DataTable GetAllIncrementForReport(string Month, int year)
        {
            return dalSalary.GetAllIncrementForReport(Month, year);
        }

        public int UpdateIncentive(int ID, int Amount, int AddedBy)
        {
            return dalSalary.UpdateIncentive(ID, Amount, AddedBy);
        }

        public int DeleteIncentive(int ID, int DeletedBy)
        {
            return dalSalary.DeleteIncentive(ID, DeletedBy);
        }

        public int InsertIncentive(Hashtable htParam)
        {
            return dalSalary.InsertIncentive(htParam);
        }

        public DataTable GetAllIncentives(string Month, int year)
        {
            return dalSalary.GetAllIncentives(Month, year);
        }

        public DataTable GetAllIncentivesForReport(string Month, int year)
        {
            return dalSalary.GetAllIncentivesForReport(Month, year);
        }

        public int InsertOtherSalary(Hashtable htParam)
        {
            return dalSalary.InsertOtherSalary(htParam);
        }

        public DataTable GetAllOtherSalaryDetails(string Month, int year)
        {
            return dalSalary.GetAllOtherSalaryDetails(Month, year);
        }

        public int UpdateOtherSalary(int ID, int Amount, int AddedBy)
        {
            return dalSalary.UpdateOtherSalary(ID, Amount, AddedBy);
        }

        public int DeleteOtherSalary(int ID, int DeletedBy)
        {
            return dalSalary.DeleteOtherSalary(ID, DeletedBy);
        }

        public DataTable GetAllOtherSalaryDetails_Report(string Month, int year)
        {
            return dalSalary.GetAllOtherSalaryDetails_Report(Month, year);
        }

        //Bind Salary info to salary slip
        public DataTable GetSalaryInfoByEmployeeID(int EmployeeID, string Month, string Year)
        {
            return dalSalary.GetSalaryInfoByEmployeeID(EmployeeID, Month, Year);
        }

        public DataTable GetUserInformation(int EmployeeID, string Month, string Year)
        {
            return dalSalary.GetUserInformation(EmployeeID, Month, Year);
        }

        public DataTable GetCompanyById(int CompanyID)
        {
            return dalSalary.GetCompanyById(1);
        }

        public DataTable GetSalaryInfoByEmployeeID_NewERP(int EmployeeID, string Month, string Year)
        {
            return dalSalary.GetSalaryInfoByEmployeeID_NewERP(EmployeeID, Month, Year);
        }

        public DataTable GetRegularSalary(string Month, int year)
        {
            return dalSalary.GetRegularSalary(Month, year);
        }

        public DataTable GenerateRegularBankFormat(string Month, string Year, string BankName)
        {
            return dalSalary.GenerateRegularBankFormat(Month, Year, BankName);
        }

        public DataTable GenerateOtherSalaryBankFormat(string Month, string Year, string BankName, string Type)
        {
            return dalSalary.GenerateOtherSalaryBankFormat(Month, Year, BankName, Type);
        }

        public DataTable GetAllHoldEmployees(string Month, string Year)
        {
            return dalSalary.GetAllHoldEmployees(Month, Year);
        }

        public int InsertChequeDetails(string ChequeNo, decimal Amount, string SalMonth, string SalYear, int EmployeeId, int Addedby, string Ip)
        {
            return dalSalary.InsertChequeDetails(ChequeNo, Amount, SalMonth, SalYear, EmployeeId, Addedby, Ip);
        }

        public DataTable GetOtherThanSalaryRecords(string Month, string year, string Type)
        {
            return dalSalary.GetOtherThanSalaryRecords(Month, year, Type);
        }

        public int InsertChequeDetails_Other(string ChequeNo, decimal Amount, string SalMonth, string SalYear, int EmployeeId, int Addedby, string Ip, string Type)
        {
            return dalSalary.InsertChequeDetails_Other(ChequeNo, Amount, SalMonth, SalYear, EmployeeId, Addedby, Ip, Type);
        }

        public DataTable GetAllAdvanceEntries()
        {
            return dalSalary.GetAllAdvanceEntries();
        }

        public int InsertAdvance(Hashtable htParam)
        {
            return dalSalary.InsertAdvance( htParam);
        }

        public int UpdateAdvance(Hashtable htParam)
        {
            return dalSalary.UpdateAdvance(htParam);
        }

        public int DeleteAdvance(Hashtable htParam)
        {
            return dalSalary.DeleteAdvance(htParam);
        }


        public DataTable GetAllIncrementForApproval(int ApprovalId)
        {
            return dalSalary.GetAllIncrementForApproval(ApprovalId);
        }

        public DataTable GetIncrementHistory(string code, DateTime? fromDate, DateTime? toDate, int? fromMonth, int? fromYear, int? toMonth, int? toYear, string status)
        {
            return dalSalary.GetIncrementHistory(code, fromDate, toDate, fromMonth, fromYear, toMonth, toYear, status);
        }

        public DataTable GetIncrementSummaryFilters()
        {
            return dalSalary.GetIncrementSummaryFilters();
        }

        public DataTable GetIncrementSummary(int? fromMonth, int? fromYear, int? toMonth, int? toYear, string location, string domain, string subDomain, string status)
        {
            return dalSalary.GetIncrementSummary(fromMonth, fromYear, toMonth, toYear, location, domain, subDomain, status);
        }

        public int approveIncrement_New(int IncrementID, int ApprovedBy, string ApprovedIP, string CurrentSalary)
        {
            return dalSalary.approveIncrement_New(IncrementID, ApprovedBy, ApprovedIP, CurrentSalary);
        }

        public DataTable GetIncrementProposalSelected(int EmployeeID, bool isUnderwriting)
        {
            return dalSalary.GetIncrementProposalSelected(EmployeeID, isUnderwriting);
        }

        public DataTable GetIncrementProposalFinal(int EmployeeID)
        {
            return dalSalary.GetIncrementProposalFinal(EmployeeID);
        }

        public DataTable GetIncrementProposalByCode(string Code, bool isUnderwriting)
        {
            return dalSalary.GetIncrementProposalByCode(Code, isUnderwriting);
        }

        public DataTable GetStandardIncrementOfUser(string Code, int ProposalID, bool isUnderwriting)
        {
            return dalSalary.GetStandardIncrementOfUser(Code, ProposalID, isUnderwriting);
        }

        public DataTable GetIncrementProposalRemarkLog(string Code, int IncCounter, bool isUnderwriting)
        {
            return dalSalary.GetIncrementProposalRemarkLog(Code, IncCounter, isUnderwriting);
        }

        public DataTable GetIncrementPerformanceDocs(string Code, int IncCounter, bool isUnderwriting)
        {
            return dalSalary.GetIncrementPerformanceDocs(Code, IncCounter, isUnderwriting);
        }

        public int UploadIncrementPerformanceDoc(string Code, string FilePath, string Remark, int IncCounter)
        {
            return dalSalary.UploadIncrementPerformanceDoc(Code, FilePath, Remark, IncCounter);
        }

        public int InsertIncrementProposal(Hashtable htParam, bool isUnderwriting)
        {
            return dalSalary.InsertIncrementProposal(htParam, isUnderwriting);
        }

        public int UpdateStandardIncrement(Hashtable htParam)
        {
            return dalSalary.UpdateStandardIncrement(htParam);
        }

        public int DeleteProposedIncrement(string Code, int IncCounter, bool isUnderwriting)
        {
            return dalSalary.DeleteProposedIncrement(Code, IncCounter, isUnderwriting);
        }

        public int ProceedProposedIncrement(string Code)
        {
            return dalSalary.ProceedProposedIncrement(Code);
        }

        public int InsertIncrementFromIncProposal(int ProposalID, string AddedIP, int AddedBy, string Remark, string Code)
        {
            return dalSalary.InsertIncrementFromIncProposal(ProposalID, AddedIP, AddedBy, Remark, Code);
        }

        public int ResetIncrementRecords(int ProposalID, int AddedBy, string Code)
        {
            return dalSalary.ResetIncrementRecords(ProposalID, AddedBy, Code);
        }

    }
}
