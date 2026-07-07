using System.Collections;
using System.Data;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllFeedback
    {
        private readonly dalFeedback dalFeedback = new dalFeedback();

        public DataTable GetAllDomain()
        {
            return dalFeedback.GetAllDomain();
        }

        public DataTable GetAllProjectByDomainWise(int domainId, int employeeId)
        {
            return dalFeedback.GetAllProjectByDomainWise(domainId, employeeId);
        }

        public DataTable GetAllProjectByUserRights(string employeeId)
        {
            return dalFeedback.GetAllProjectByUserRights(employeeId);
        }

        public DataTable GetProcess(int projectId)
        {
            return dalFeedback.GetProcess(projectId);
        }

        public DataTable GetFeedbackSectionAndField()
        {
            return dalFeedback.GetFeedbackSectionAndField();
        }

        public int InsertSectionAndField(Hashtable values)
        {
            return dalFeedback.InsertSectionAndField(values);
        }

        public int UpdateSectionAndField(Hashtable values)
        {
            return dalFeedback.UpdateSectionAndField(values);
        }

        public int DeleteSectionAndField(int id, int deletedBy)
        {
            return dalFeedback.DeleteSectionAndField(id, deletedBy);
        }

        public DataTable CheckProjectIsApplicableForSectionField(int projectId)
        {
            return dalFeedback.CheckProjectIsApplicableForSectionField(projectId);
        }

        public DataTable GetFieldBySection(int projectId, string section)
        {
            return dalFeedback.GetFieldBySection(projectId, section);
        }

        public string ValidateProject(string project)
        {
            return dalFeedback.ValidateProject(project);
        }

        public string ValidateProcess(string project, string process)
        {
            return dalFeedback.ValidateProcess(project, process);
        }

        public string ValidateUserProjectRights(string employeeId, string projectId)
        {
            return dalFeedback.ValidateUserProjectRights(employeeId, projectId);
        }

        public string ValidateEmployeeCode(string code)
        {
            return dalFeedback.ValidateEmployeeCode(code);
        }

        public string ValidateSectionAndFieldByProject(string projectId)
        {
            return dalFeedback.ValidateSectionAndFieldByProject(projectId);
        }

        public string ValidateSection(string projectId, string section)
        {
            return dalFeedback.ValidateSection(projectId, section);
        }

        public string ValidateFieldName(string projectId, string section, string fieldName)
        {
            return dalFeedback.ValidateFieldName(projectId, section, fieldName);
        }

        public int CheckProjectUnderwriting(int projectId)
        {
            return dalFeedback.CheckProjectUnderwriting(projectId);
        }

        public string GetUserCodeByEmployeeID(string employeeId)
        {
            return dalFeedback.GetUserCodeByEmployeeID(employeeId);
        }

        public DataTable ViewAllFeedbackByPMWise(string fromDate, string toDate, string employeeId)
        {
            return dalFeedback.ViewAllFeedbackByPMWise(fromDate, toDate, employeeId);
        }

        public DataTable ViewAllFeedbackByUserWise(string employeeId, string role, string fromDate, string toDate)
        {
            return dalFeedback.ViewAllFeedbackByUserWise(employeeId, role, fromDate, toDate);
        }

        public DataTable ViewAllFeedbackByClientWise(string employeeId, string fromDate, string toDate)
        {
            return dalFeedback.ViewAllFeedbackByClientWise(employeeId, fromDate, toDate);
        }

        public DataTable ViewFeedbackByPMWise(string employeeId, string fatal)
        {
            return dalFeedback.ViewFeedbackByPMWise(employeeId, fatal);
        }

        public DataTable ViewFeedbackByUserWise(string employeeId, string fatal)
        {
            return dalFeedback.ViewFeedbackByUserWise(employeeId, fatal);
        }

        public DataTable ViewFeedbackByOrderWise(string orderNo)
        {
            return dalFeedback.ViewFeedbackByOrderWise(orderNo);
        }

        public DataTable ViewAllFeedbackByRecordWise(string feedDetailsId)
        {
            return dalFeedback.ViewAllFeedbackByRecordWise(feedDetailsId);
        }

        public DataTable ViewNewOrderFeedbackByOrderWise(string employeeId)
        {
            return dalFeedback.ViewNewOrderFeedbackByOrderWise(employeeId);
        }

        public int DeleteFeedback(int feedDetailsId, int deletedBy)
        {
            return dalFeedback.DeleteFeedback(feedDetailsId, deletedBy);
        }

        public int InsertFeedbackForNewOrder(Hashtable values)
        {
            return dalFeedback.InsertFeedbackForNewOrder(values);
        }

        public int AddFeedbackForNewOrder(Hashtable values)
        {
            return dalFeedback.AddFeedbackForNewOrder(values);
        }

        public int AddEDBStatusByOrderWise(Hashtable values)
        {
            return dalFeedback.AddEDBStatusByOrderWise(values);
        }

        public int AddPMStatusByOrderWise(Hashtable values)
        {
            return dalFeedback.AddPMStatusByOrderWise(values);
        }
    }
}
