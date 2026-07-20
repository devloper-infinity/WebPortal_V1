using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;
using WebPortal.Tracking;

namespace WebPortal.App_Code.BLL
{
    public class bllTracking
    {
        dalTracking dalTracking = new dalTracking();



        public DataTable GetProjectandDatewiseTrackingSheetData(int ProjectID, string FromDate, string ToDate)
        {
            return dalTracking.GetProjectandDatewiseTrackingSheetData(ProjectID, FromDate, ToDate);
        }


        public DataTable GetFTEDetails()
        {
            return dalTracking.GetFTEDetails();
        }


        public int InsertFTEDetails(Hashtable htParam)
        {
            return InsertFTEDetails(htParam);
        }

        public string getBillingPeriodByProject(string Project)
        {
            return dalTracking.getBillingPeriodByProject(Project);
        }

        public DataTable GetAllFieldbyDomain(int DomainID)
        {
            return dalTracking.GetAllFieldbyDomain(DomainID);
        }

        public int DeleteFieldByDomain(int ID, int DeletedBy)
        {
            return dalTracking.DeleteFieldByDomain(ID, DeletedBy);
        }


        public int UpdateDomainWiseField(Hashtable htParam)
        {
            return dalTracking.UpdateDomainWiseField(htParam);
        }


        public int InsertDomainWiseField(Hashtable htParam)
        {
            return dalTracking.InsertDomainWiseField(htParam);
        }

        public int ValidateAutoColumn(int DomainID, string FieldName)
        {
            return dalTracking.ValidateAutoColumn(DomainID, FieldName);
        }

        public DataTable GetAllDomainByConfigureField()
        {
            return dalTracking.GetAllDomainByConfigureField();
        }


        public DataTable GetAllProjectByDomainWise(int DomainId, int EmployeeId)
        {
            return dalTracking.GetAllProjectByDomainWise(DomainId, EmployeeId);
        }

        public DataTable GetFieldNameForProjectConfig(int DomainID, int ProjectID)
        {
            return dalTracking.GetFieldNameForProjectConfig(DomainID, ProjectID);
        }

        public DataTable GetSequenceNoByProject(int ProjectID)
        {
            return dalTracking.GetSequenceNoByProject(ProjectID);
        }


        public DataTable getAllColumnMappingDetails(int EmployeeId)
        {
            return dalTracking.getAllColumnMappingDetails(EmployeeId);
        }

        public int InsertNewColumn(int AddedBy)
        {
            return dalTracking.InsertNewColumn(AddedBy);
        }


        public int InsertColumnMapping(Hashtable htParam)
        {
            return dalTracking.InsertColumnMapping(htParam);
        }

        public string CheckIsAutoColumnByID(int ProjectFieldID)
        {
            return dalTracking.CheckIsAutoColumnByID(ProjectFieldID);
        }

        public DataTable GetAllTrackingSheetsColumnsbyProject(int ProjectFieldId)
        {
            return dalTracking.GetAllTrackingSheetsColumnsbyProject(ProjectFieldId);
        }

        public DataTable GetAllDomainByConfigureField(int ProjectFieldId)
        {
            return dalTracking.GetAllDomainByConfigureField(ProjectFieldId);
        }

        public string CheckIsNameColumn(string FieldName)
        {
            return dalTracking.CheckIsNameColumn(FieldName);
        }

        public int ValidateAutoColumnbyProjectConfiguration(int DomainID, int ProjectID, string FieldName)
        {
            return dalTracking.ValidateAutoColumnbyProjectConfiguration(DomainID, ProjectID, FieldName);
        }

        public int InsertProjectWiseField(Hashtable htParam)
        {
            return dalTracking.InsertProjectWiseField(htParam);
        }

        public string GetDomainFiledId(string FieldName, int DomainID)
        {
            return dalTracking.GetDomainFiledId(FieldName, DomainID);
        }

        public int UpdateDomainAndProjectWiseField(Hashtable htParam)
        {
            return dalTracking.UpdateDomainAndProjectWiseField(htParam);
        }

        public int DeleteFieldByDomainAndProject(int ID, int DeletedBy)
        {
            return dalTracking.DeleteFieldByDomainAndProject(ID, DeletedBy);
        }

        public DataTable GetAllFieldByProjectAndDomain(int DomainID, int EmployeeId)
        {
            return dalTracking.GetAllFieldByProjectAndDomain(DomainID, EmployeeId);
        }

        public DataTable GetAllProjectByDefineField(int EmployeeId)
        {
            return dalTracking.GetAllProjectByDefineField(EmployeeId);
        }

        public DataTable GetAllColumnByProject(int ProjectID)
        {
            return dalTracking.GetAllColumnByProject(ProjectID);
        }

        public DataTable GetAllFieldNameByProject(int ProjectID)
        {
            return dalTracking.GetAllFieldNameByProject(ProjectID);
        }

        public DataTable GetProcessDetails(string UserName)
        {
            return dalTracking.GetProcessDetails(UserName);
        }

        public int ValidateUserProcessTAT(Hashtable htParam)
        {
            return dalTracking.ValidateUserProcessTAT(htParam);
        }

        public DataTable GetAllProjectDealNo_OrderNo_UW_Process(string ProcessName, string Reviewer, string Type)
        {
            return dalTracking.GetAllProjectDealNo_OrderNo_UW_Process(ProcessName, Reviewer, Type);
        }

        public DataTable GetProcessDetailsForFeedbackUser(string UserName, string FromDate, string ToDate)
        {
            return dalTracking.GetProcessDetailsForFeedbackUser(UserName, FromDate, ToDate);
        }

        public DataTable GetAllProjectFeedbackinERP(int ProjectId, string OrderNo, string Process, string FeedbackBy)
        {
            return dalTracking.GetAllProjectFeedbackinERP(ProjectId, OrderNo, Process, FeedbackBy);
        }

        public DataTable GetAllProjectFeedbackinERP_Servicing(int ProjectId, string OrderNo, string Process, string FeedbackBy)
        {
            return dalTracking.GetAllProjectFeedbackinERP_Servicing(ProjectId, OrderNo, Process, FeedbackBy);
        }

        public int AllocateOrder_Self_OLD(Hashtable htParam)
        {
            return dalTracking.AllocateOrder_Self_OLD(htParam);
        }

        public int AllocateOrder_Self(Hashtable htParam)
        {
            return dalTracking.AllocateOrder_Self(htParam);
        }

        public int UpdateLoanStatus(Hashtable htParam)
        {
            return dalTracking.UpdateLoanStatus(htParam);
        }

        public int InsertModifyUWOrderOC22Servicing(Hashtable htParam)
        {
            return dalTracking.InsertModifyUWOrderOC22Servicing(htParam);
        }


        public int InsertFeedbackForNewOrderUnderwritingByTracking(Hashtable htParam)
        {
            return dalTracking.InsertFeedbackForNewOrderUnderwritingByTracking(htParam);

        }

        public int AddFeedbackForNewOrder(Hashtable htParam)
        {
            return dalTracking.AddFeedbackForNewOrder(htParam);
        }


        public DataTable getProcess(int ProjectID)
        {
            return dalTracking.getProcess(ProjectID);
        }

        public DataTable GetProcessByProjectAndSequence(int ProjectID)
        {
            return dalTracking.GetProcessByProjectAndSequence(ProjectID);
        }

        public DataTable GetAllcatedLoansByUser(int UserID)
        {
            return dalTracking.GetAllcatedLoansByUser(UserID);
        }

        public DataTable GetAllProjectDealNumberNew(int ProjectId)
        {
            return dalTracking.GetAllProjectDealNumberNew(ProjectId);
        }

        public DataTable GetAllOrderNoByProjectWise(int ProjectID, string DealNo, string ProcessName, string Review, string Type)
        {
            return dalTracking.GetAllOrderNoByProjectWise(ProjectID, DealNo, ProcessName, Review, Type);
        }

        public DataTable GetBulkAllocatedOrders(int projectId, string processName)
        {
            return dalTracking.GetBulkAllocatedOrders(projectId, processName);
        }

        public string GetBulkAllocationDuplicateStatus(
            int projectId,
            string dealNo,
            string loanNo,
            string userCode,
            string processName)
        {
            return dalTracking.GetBulkAllocationDuplicateStatus(
                projectId,
                dealNo,
                loanNo,
                userCode,
                processName);
        }

        public DataTable GetAllDealDispatchDate()
        {
            return dalTracking.GetAllDealDispatchDate();
        }

        public int InsertLoanDispatchDate(Hashtable htParam)
        {
            return dalTracking.InsertLoanDispatchDate(htParam);
        }

        public string getActualColumnName(string HeaderName, int ProjectID)
        {
            return dalTracking.getActualColumnName(HeaderName, ProjectID);
        }

        public DataTable GetIsUniqueColumnForHeader(int ProjectID)
        {
            return dalTracking.GetIsUniqueColumnForHeader(ProjectID);
        }

        public DataTable GetTrackingsheetLoanForDispatchDate(string ProjectID, string DealNumber)
        {
            return dalTracking.GetTrackingsheetLoanForDispatchDate(ProjectID, DealNumber);
        }

        public DataTable GetTrackingsheetLoanForDispatchDate_Servicing(string ProjectID, string DealNumber)
        {
            return dalTracking.GetTrackingsheetLoanForDispatchDate_Servicing(ProjectID, DealNumber);
        }

        public DataTable GetLoanDetailsByProcessID(int ProcessID)
        {
            return dalTracking.GetLoanDetailsByProcessID(ProcessID);
        }

        public int GetEmployeePseudonameNew(string Code)
        {
            return dalTracking.GetEmployeePseudonameNew(Code);
        }

        public DataTable GetProcessDetailsForFeedbackUserNew(string UserName, string DealNo, string Status)
        {
            return dalTracking.GetProcessDetailsForFeedbackUserNew(UserName, DealNo, Status);
        }

        public DataTable GetProcessDashbordDealPending(string DealNo, string Process)
        {
            return dalTracking.GetProcessDashbordDealPending(DealNo, Process);
        }

        public DataTable GetProcessDetailsForFeedbackUserCompleted_New(string UserName, string DealNo, string Status)
        {
            return dalTracking.GetProcessDetailsForFeedbackUserCompleted_New(UserName, DealNo, Status);
        }

        public DataTable GetProcessDetailsForFeedbackUserCompleted(string UserName, string ToDate, string Code)
        {
            return dalTracking.GetProcessDetailsForFeedbackUserCompleted(UserName, ToDate, Code);
        }

        public int InsertImportedFeedback_Credit(Hashtable htParam)
        {
            return dalTracking.InsertImportedFeedback_Credit(htParam);
        }
        public int InsertImportedFeedback_Servicing(Hashtable htParam)
        {
            return dalTracking.InsertImportedFeedback_Servicing(htParam);
        }
    }
}
