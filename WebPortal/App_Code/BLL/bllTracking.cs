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

        public int InsertModifyUWOrderOC22(Hashtable htParam)
        {
            return dalTracking.InsertModifyUWOrderOC22(htParam);
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

    }
}

