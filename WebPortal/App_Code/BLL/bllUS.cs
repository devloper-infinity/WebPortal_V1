using DocumentFormat.OpenXml.Office2010.Excel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllUS
    {
        dalUS dalUS = new dalUS();

        #region Get Data


        public DataTable GetUSEmployees()
        {
            return dalUS.GetUSEmployees();
        }

        public DataTable GetAllUSAssets()
        {
            return dalUS.GetAllUSAssets();
        }

        public DataTable GetLoanDetails_RemoteUW_REQC(int EmpID)
        {
            return dalUS.GetLoanDetails_RemoteUW_REQC(EmpID);
        }

        public DataTable GetUSLoanProductionMyQueue(int EmployeeID)
        {
            return dalUS.GetUSLoanProductionMyQueue(EmployeeID);
        }

        public DataTable GetDatewiseOnShoreProduction(string Date)
        {
            return dalUS.GetDatewiseOnShoreProduction(Date);
        }

        public DataTable GetDatewiseOnShoreProduction_Monthly(string Month, string Year)
        {
            return dalUS.GetDatewiseOnShoreProduction_Monthly(Month, Year);
        }

        public DataTable GetDatewiseOnShoreProduction_Monthly_Report(string Month, string Year)
        {
            return dalUS.GetDatewiseOnShoreProduction_Monthly_Report(Month, Year);
        }
        public DataTable GetDatewiseOnShoreProduction_Monthly_Report_Userwise(string Month, string Year)
        {
            return dalUS.GetDatewiseOnShoreProduction_Monthly_Report_Userwise(Month, Year);
        }

        public DataTable GetLoanDetails_RemoteUW_ByID(int ProcessID)
        {
            return dalUS.GetLoanDetails_RemoteUW_ByID(ProcessID);
        }

        public DataTable GetOverAllUserPerformance_credit_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            return dalUS.GetOverAllUserPerformance_credit_Greg(EmployeeID, FromDate, ToDate);
        }

        public DataTable GetOverAllUserPerformance_Servicing_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            return dalUS.GetOverAllUserPerformance_Servicing_Greg(EmployeeID, FromDate, ToDate);
        }

        public DataTable GetOverAllUserPerformanceDetails_Credit_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            return dalUS.GetOverAllUserPerformanceDetails_Credit_Greg(EmployeeID, FromDate, ToDate);
        }

        public DataTable GetOverAllUserPerformanceDetails_Servicing_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            return dalUS.GetOverAllUserPerformanceDetails_Servicing_Greg(EmployeeID, FromDate, ToDate);
        }

        public DataTable GetUSImportedFeedback_ByUser_NewERP(string LoanNo, int EmployeeID)
        {
            return dalUS.GetUSImportedFeedback_ByUser_NewERP(LoanNo, @EmployeeID);
        }

        public DataSet getLoansForGlobalSearch(int EmployeeID)
        {
            return dalUS.getLoansForGlobalSearch(EmployeeID);
        }

        public DataTable GetLoanDetailsbyLoanNo(string DealNo, string LoanNo)
        {
            return dalUS.GetLoanDetailsbyLoanNo(DealNo, LoanNo);
        }

        public DataTable GetATRDetailsbyLoanNo(string DealNo, string LoanNo, string Type, int ProcessID)
        {
            return dalUS.GetATRDetailsbyLoanNo(DealNo, LoanNo, Type, ProcessID);
        }

        public DataTable GetAllProjectByUserRights(string EmployeeID)
        {
            return dalUS.GetAllProjectByUserRights(EmployeeID);
        }

        public DataTable GetUSProcessList(int ProjectID)
        {
            return dalUS.GetUSProcessList(ProjectID);
        }

        public DataTable GetAllTempReQC1(int ReQC)
        {
            return dalUS.GetAllTempReQC1(ReQC);
        }

        public DataTable GetAllTempReQC2(int ReQC)
        {
            return dalUS.GetAllTempReQC2(ReQC);
        }

        #endregion

        #region Insert/Update Data

        public int InsertUSImportedFeedback_NewERP(Hashtable htParam)
        {
            return dalUS.InsertUSImportedFeedback_NewERP(htParam);
        }

        public int InsertModifyUWOrderOC22Servicing(Hashtable htParam)
        {
            return dalUS.InsertModifyUWOrderOC22Servicing(htParam);
        }

        public int SaveUSLoanProductionTrack(Hashtable htParam)
        {
            return dalUS.SaveUSLoanProductionTrack(htParam);
        }

        public int InsertOnShoreUSFeedbacks(Hashtable htParam)
        {
            return dalUS.InsertOnShoreUSFeedbacks(htParam);
        }

        public int InsertOnShoreUSATRFeedbacks(Hashtable htParam)
        {
            return dalUS.InsertOnShoreUSATRFeedbacks(htParam);
        }
        public int InsertOnShoreProduction(Hashtable htParam)
        {
            return dalUS.InsertOnShoreProduction(htParam);
        }

        public DataTable DeleteAllTempReQC1()
        {
            return dalUS.DeleteAllTempReQC1();
        }

        public int InsertUSAssets(Hashtable htParam)
        {
            return dalUS.InsertUSAssets(htParam);
        }

        #endregion


        #region Condition Clearing

        public DataTable GetAllProjectByUserRights_ForAddFeedback(string EmployeeID)
        {
            return dalUS.GetAllProjectByUserRights_ForAddFeedback(EmployeeID);
        }

        public DataTable ViewAllConditionClearing()
        {
            return dalUS.ViewAllConditionClearing();
        }

        public DataTable ViewAllConditionClearingById(int Id)
        {
            return dalUS.ViewAllConditionClearingById(Id);
        }

        public DataTable GetAllProjectDealNumberNew(int ProjectId)
        {
            return dalUS.GetAllProjectDealNumberNew(ProjectId);
        }

        public DataTable GetAllOrderNoByProjectWise(int ProjectID, string DealNo, string ProcessName, string Review, string Type)
        {
            return dalUS.GetAllOrderNoByProjectWise(ProjectID, DealNo, ProcessName, Review, Type);
        }

        public int InsertConditionClearing(Hashtable htParam)
        {
            return dalUS.InsertConditionClearing(htParam);
        }

        public DataTable ViewAllConditionClearingPending()
        {
            return dalUS.ViewAllConditionClearingPending();
        }

        public DataTable GetAllFeedbackByDateRange_NewFormat_Onshore(string FromDate, string ToDate)
        {
            return dalUS.GetAllFeedbackByDateRange_NewFormat_Onshore(FromDate, ToDate);
        }

        public int SaveInfinityOnshoreRemark(int FeedbackID, string Remark, int AddedBy)
        {
            return dalUS.SaveInfinityOnshoreRemark(FeedbackID, Remark, AddedBy);
        }

        public DataTable GetAllConditionClearing(string FromDate, string ToDate)
        {
            return dalUS.GetAllConditionClearing(FromDate, ToDate);
        }

        public int UpdateConditionClearing(Hashtable htParam)
        {
            return dalUS.UpdateConditionClearing(htParam);
        }
        #endregion

    }
}
