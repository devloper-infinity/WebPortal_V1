using WebPortal.App_Code.DAL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace WebPortal.App_Code.BLL
{
    public class bllRequisition
    {
        dalRequisition dalRequisition = new dalRequisition();
        public DataTable GetAllProfiles()
        {
            return dalRequisition.GetAllProfiles();
        }

        public DataTable GetAllDomainGroups()
        {
            return dalRequisition.GetAllDomainGroups();
        }

        public DataTable GetAllSubdomains(int DomainGroupId)
        {
            return dalRequisition.GetAllSubdomains(DomainGroupId);
        }
        public DataTable GetAllSubdomainsByDomainGroup(int DomainGroupId)
        {
            return dalRequisition.GetAllSubdomainsByDomainGroup(DomainGroupId);
        }

        public DataTable GetAllprojectBySubdomainId(int SubdomainID)
        {
            return dalRequisition.GetAllprojectBySubdomainId(SubdomainID);
        }
        public DataTable GetAllRecruitmentByUserID(int EmployeeID)
        {
            return dalRequisition.GetAllRecruitmentByUserID(EmployeeID);
        }

        public DataTable GetAllRecruitmentByRecID(int RecID)
        {
            return dalRequisition.GetAllRecruitmentByRecID(RecID);
        }
        public int ApproveRequisition(Hashtable htParam)
        {
            return dalRequisition.ApproveRequisition(htParam);
        }
        public int InsertRecruitment(Hashtable htParam)
        {
            return dalRequisition.InsertRecruitment(htParam);
        }

        public int InsertInstanceAppllicationForm(Hashtable htInstAppForm)
        {
            return dalRequisition.InsertInstanceAppllicationForm(htInstAppForm);
        }

        public DataTable GetApplicantListByEmployeeId(int EmpId)
        {
            return dalRequisition.GetApplicantListByEmployeeId(EmpId);
        }

        public DataTable GetAllRequisition(string Status)
        {
            return dalRequisition.GetAllRequisition(Status);
        }

        public DataTable getApplicantListById(int AppId)
        {
            return dalRequisition.getApplicantListById(AppId);
        }

        public int InsertApplicantRemark(Hashtable htParam)
        {
            return dalRequisition.InsertApplicantRemark(htParam);
        }

        public DataTable GetApplicantRemark(int AppId)
        {
            return dalRequisition.GetApplicantRemark(AppId);
        }

        public DataTable GetAllRemarkapplicantUser(int AppId)
        {
            return dalRequisition.GetAllRemarkapplicantUser(AppId);
        }

        public DataTable GetShortlistedCandidates(int EmpId)
        {
            return dalRequisition.GetShortlistedCandidates(EmpId);
        }

        public int InsertProfile(string ProfileName, int AddedBy)
        {
            return dalRequisition.InsertProfile(ProfileName, AddedBy);
        }
        public int CloseRecruitement(int RecId, string ClosingRemark, int ClosedBy)
        {
            return dalRequisition.CloseRecruitement(RecId, ClosingRemark, ClosedBy);
        }
        public int GetFinalRemark(int AppId)
        {
            return dalRequisition.GetFinalRemark(AppId);
        }
        public int UpdateApplicantFlag(int AppId)
        {
            return dalRequisition.UpdateApplicantFlag(AppId);
        }
        public DataTable GetApplicantInfo(int AppID)
        {
            return dalRequisition.GetApplicantInfo(AppID);
        }
        public int InsertCredit_UWQUestionnaire(Hashtable htParam)
        {
            return dalRequisition.InsertCredit_UWQUestionnaire(htParam);
        }

        public DataTable GetRequisitionById_Email(int RecId)
        {
            return dalRequisition.GetRequisitionById_Email(RecId);
        }
    }
}