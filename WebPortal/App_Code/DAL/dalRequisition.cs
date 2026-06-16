using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WebPortal.App_Code.DAL
{
    public class dalRequisition
    {
        public DataTable GetAllProfiles()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProfiles");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllDomainGroups()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getAllDomainGroups_Revised");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllSubdomains(int DomainGroupId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetSubdomainByDomainGroupId");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainGroupId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DomainGroupId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllSubdomainsByDomainGroup(int DomainGroupId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllSubDomain_Group_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DomainGroupId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllprojectBySubdomainId(int SubdomainID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProjectsBySubdomainId");
            SQLHelper.AddParamToSQLCmd(cmd, "@SubdomainID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, SubdomainID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllRecruitmentByUserID(int EmployeeID)
        {

            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getAllRecruitmentsByUser");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllRecruitmentByRecID(int RecID)
        {

            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getAllRecruitmentsByRecId");
            SQLHelper.AddParamToSQLCmd(cmd, "@RecId", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, RecID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int ApproveRequisition(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ApproveRecruitment");
            SQLHelper.AddParamToSQLCmd(cmd, "@RecId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["RecId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalaryRange", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["SalaryRange"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["ApprovedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertRecruitment(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertRecruitment");
            SQLHelper.AddParamToSQLCmd(cmd, "@Designation", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Designation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Noofpositions", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Noofpositions"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Domain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Subdomain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Other", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Other"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Shift", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Shift"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Location", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Location"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployementType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["EmployementType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Department", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Department"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Deadline", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, htParam["Deadline"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IntiatedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["IntiatedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SkillRequired", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["SkillRequired"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalaryRange", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["SalaryRange"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Source", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Source"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertInstanceAppllicationForm(Hashtable htInstAppForm)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertInstanceAppllicationForm");
            SQLHelper.AddParamToSQLCmd(cmd, "@PositionApplied", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htInstAppForm["PositionApplied"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Location", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htInstAppForm["Location"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Source", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htInstAppForm["Source"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Title", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htInstAppForm["Title"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LastName", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htInstAppForm["LastName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Firstname", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htInstAppForm["FirstName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MiddleName", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htInstAppForm["MiddleName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Gender", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, htInstAppForm["Gender"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CellPhoneNo", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, htInstAppForm["CellPhoneNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DateOfBirth", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htInstAppForm["DateOfBirth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htInstAppForm["EmailID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, htInstAppForm["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PresentAddress", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, htInstAppForm["PresentAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PreAddPinCode", System.Data.SqlDbType.NVarChar, 6, System.Data.ParameterDirection.Input, htInstAppForm["PreAddPinCode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PermanentAddress", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, htInstAppForm["PermanentAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PermenentAddPinCode", System.Data.SqlDbType.NVarChar, 6, System.Data.ParameterDirection.Input, htInstAppForm["PermenentAddPinCode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Resume", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htInstAppForm["Resume"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htInstAppForm["Domain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SubDomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htInstAppForm["SubDomain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htInstAppForm["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            try
            {
                SQLHelper.ExecuteNonQueryCmd(cmd);
            }
            catch (Exception)
            {

            }
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetApplicantListByEmployeeId(int EmpId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ViewAllApplicants");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, EmpId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllRequisition(string Status)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_RequisitionForCreateProfile");
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, Status);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getApplicantListById(int AppId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetApplicantListByApplicationId");
            SQLHelper.AddParamToSQLCmd(cmd, "@AppId", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, AppId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertApplicantRemark(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertApplicantRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@ApplicationId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["ApplicationId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InterviewMethod", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["InterviewMethod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InterviewLocation", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["InterviewLocation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CurrentSalary", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["CurrentSalary"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ExpectedSalary", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ExpectedSalary"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InterviewDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["InterviewDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InterviewTime", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["InterviewTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Interviewer", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Interviewer"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FinalSalary", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["FinalSalary"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@ExpJoiningDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ExpJoiningDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Department", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Department"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Designation", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Designation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReportingManager", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ReportingManager"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Shift", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Shift"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CutOffTime", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["CutOffTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OtherRemark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OtherRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsResult", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["IsResult"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["Domain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RequisitionID", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["RequisitionID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetApplicantRemark(int AppId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getApplicantRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@ApplicationId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, AppId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllRemarkapplicantUser(int AppId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Get_All_Remark_applicant_User");
            SQLHelper.AddParamToSQLCmd(cmd, "@AppId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, AppId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetShortlistedCandidates(int EmpId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetShortlistedCandidates");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, EmpId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int InsertProfile(string ProfileName, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_insertProfile");
            SQLHelper.AddParamToSQLCmd(cmd, "@Profile", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, ProfileName);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int CloseRecruitement(int RecId, string ClosingRemark, int ClosedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_closeRequirement");
            SQLHelper.AddParamToSQLCmd(cmd, "@RecId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, RecId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClosingRemark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, ClosingRemark);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClosedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ClosedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int GetFinalRemark(int AppId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetFinalSalary");
            SQLHelper.AddParamToSQLCmd(cmd, "@AppId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AppId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int UpdateApplicantFlag(int AppId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_updateApplicantFlag");
            SQLHelper.AddParamToSQLCmd(cmd, "@AppId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, AppId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }
        public DataTable GetApplicantInfo(int AppID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetApplicantInfobyId]");//usp_GetApplicantInfobyId_ForInternal
            SQLHelper.AddParamToSQLCmd(cmd, "@AppID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, AppID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int InsertCredit_UWQUestionnaire(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUWQiestionnaire");
            SQLHelper.AddParamToSQLCmd(cmd, "@ApplicationID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ApplicationID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetRequisitionById_Email(int RecId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetRequisitionDetailsByIDForEmail");
            SQLHelper.AddParamToSQLCmd(cmd, "@RecId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, RecId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }



    }
}