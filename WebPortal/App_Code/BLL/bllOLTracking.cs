using System;
using System.Data;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public sealed class bllOLTracking
    {
        private readonly dalOLTracking dal = new dalOLTracking();
        public DataTable GetProjects() { return dal.GetProjects(); }
        public DataTable GetProcesses(int projectId) { return dal.GetProcesses(projectId); }
        public DataTable GetFields(int projectId) { return dal.GetFields(projectId); }
        public int SaveField(int fieldId, int projectId, string name, string type, string dateFormat, string options, int order, bool required, bool visible, bool editable, bool unique, int userId)
        { return dal.SaveField(fieldId, projectId, name, type, dateFormat, options, order, required, visible, editable, unique, userId); }
        public int RetireField(int fieldId, int userId) { return dal.RetireField(fieldId, userId); }
        public DataSet GetProcessConfiguration(int projectId) { return dal.GetProcessConfiguration(projectId); }
        public void SaveProjectSetting(int projectId, string itemLabel, byte max, int userId)
        { dal.SaveProjectSetting(projectId, itemLabel, max, userId); }
        public void SaveProcessConfiguration(int projectId, int processId, bool canSkip, bool active, bool feedbackRequired, string prerequisiteMode, int[] sourceProcessIds, int userId)
        { dal.SaveProcessConfiguration(projectId, processId, canSkip, active, feedbackRequired, prerequisiteMode, sourceProcessIds, userId); }
        public DataTable GetDeals(int projectId) { return dal.GetDeals(projectId); }
        public DataSet GetItems(int projectId) { return dal.GetItems(projectId); }
        public long SaveItem(long itemId, int projectId, string itemNumber, string dealNumber, int? processId, System.Collections.Generic.IDictionary<int, string> values, int userId)
        { long id = dal.SaveItem(itemId, projectId, itemNumber, dealNumber, processId, userId); dal.SaveItemValues(id, values, userId); return id; }
        public DataTable GetNextItem(int projectId, string deal, int processId, int userId) { return dal.GetNextItem(projectId, deal, processId, userId); }
        public int Allocate(long itemId, int projectId, int processId, int userId) { return dal.Allocate(itemId, projectId, processId, userId); }
        public DataSet GetDashboard(int userId) { return dal.GetDashboard(userId); }
        public void UpdateStatus(long assignmentId, string status, string remark, string[] feedbacks, int userId) { dal.UpdateStatus(assignmentId, status, remark, feedbacks, userId); }
        public DataSet GetDailyStatus(int userId, int projectId, int processId, DateTime? from, DateTime? to) { return dal.GetDailyStatus(userId, projectId, processId, from, to); }
        public DataTable GetProjectsByUser(int userId) { return new bllMaster().GetAllProjectByUserRights(Convert.ToString(userId)); }
        public DataTable GetSourceDeals(int projectId, int userId)
        {
            return dal.GetImportedDeals(projectId);
        }
        public DataTable GetProcessFlow(int projectId) { return dal.GetProcessFlow(projectId); }
        public DataTable GetDealProcessFlow(int projectId, string dealNumber) { return dal.GetDealProcessFlow(projectId, dealNumber); }
        public DataTable GetEffectiveProcessFlow(int projectId, string dealNumber) { return dal.GetEffectiveProcessFlow(projectId, dealNumber); }
        public DataTable GetConfiguredProcesses(int projectId) { return dal.GetConfiguredProcesses(projectId); }
        public void SaveProcessFlow(int projectId, int processId, string processName, int stageNo, bool mandatory, bool feedback, bool isFinalProcess, bool isTrackingSheetProcess, string productivityType, int expectedCompletionMinutes, int? minCompletionMinutes, int? maxCompletionMinutes, int[] eligibleAfterProcessIds, int[] feedbackAgainstProcessIds, int userId)
        { dal.SaveProcessFlow(projectId, processId, processName, stageNo, mandatory, feedback, isFinalProcess, isTrackingSheetProcess, productivityType, expectedCompletionMinutes, minCompletionMinutes, maxCompletionMinutes, eligibleAfterProcessIds, feedbackAgainstProcessIds, userId); }
        public int RemoveProcessFlow(int projectId, int processId, int userId) { return dal.RemoveProcessFlow(projectId, processId, userId); }
        public void SaveDealProcessFlow(int projectId, string dealNumber, int processId, string processName, int stageNo, bool mandatory, bool feedback, bool isFinalProcess, string productivityType, int expectedCompletionMinutes, int? minCompletionMinutes, int? maxCompletionMinutes, bool isOutOfScope, int userId)
        { dal.SaveDealProcessFlow(projectId, dealNumber, processId, processName, stageNo, mandatory, feedback, isFinalProcess, productivityType, expectedCompletionMinutes, minCompletionMinutes, maxCompletionMinutes, isOutOfScope, userId); }
        public DataTable GetOverdueProcesses(int userId) { return dal.GetOverdueProcesses(userId); }
        public DataTable GetCompletionTimeValidation(long assignmentId, int userId) { return dal.GetCompletionTimeValidation(assignmentId, userId); }
        public int AcknowledgeOverdueProcesses(long[] assignmentIds, int userId) { return dal.AcknowledgeOverdueProcesses(assignmentIds, userId); }
        public int RemoveDealProcessFlow(int projectId, string dealNumber, int processId, int userId) { return dal.RemoveDealProcessFlow(projectId, dealNumber, processId, userId); }
        public DataTable GetAvailableLoan(int projectId, string dealNumber, int processId, string processName, int userId)
        {
            return dal.GetNextEligibleImportedLoan(projectId, dealNumber, processId);
        }
        public int AllocateLoan(int projectId, int processId, string loanNumber, string dealNumber, int userId) { return dal.AllocateLoan(projectId, processId, loanNumber, dealNumber, userId); }
        public long StartNonTrackingLoan(int projectId, int processId, string loanNumber, string dealNumber, long assignmentId, int userId)
        {
            long resolvedAssignmentId = assignmentId;
            dal.EnsureCanStartNonTrackingLoan(userId, resolvedAssignmentId);
            if (resolvedAssignmentId <= 0)
                resolvedAssignmentId = dal.AllocateLoan(projectId, processId, loanNumber, dealNumber, userId);
            if (resolvedAssignmentId <= 0)
                throw new InvalidOperationException("Unable to allocate the selected loan.");
            dal.StartLoan(resolvedAssignmentId, userId);
            return resolvedAssignmentId;
        }
        public bool IsLoanProcessCurrentlyAllocated(string loanNumber, int processId) { return dal.IsLoanProcessCurrentlyAllocated(loanNumber, processId); }
        public DataTable GetTrackingQueue(int userId) { return dal.GetTrackingQueue(userId); }
        public DataTable GetNonTrackingPendingLoans(int projectId, string dealNumber, int processId, int userId, string userName)
        { return dal.GetNonTrackingPendingLoans(projectId, dealNumber, processId, userId, userName); }
        public long SubmitHourlyProductivity(int projectId, int processId, string dealNumber, int durationMinutes, int userId)
        { return dal.SubmitHourlyProductivity(projectId, processId, dealNumber, durationMinutes, userId); }
        public void StartLoan(long assignmentId, int userId) { dal.StartLoan(assignmentId, userId); }
        public void HoldLoan(long assignmentId, string holdReason, int userId) { dal.HoldLoan(assignmentId, holdReason, userId); }
        public DataTable GetHoldReasons(bool includeInactive) { return dal.GetHoldReasons(includeInactive); }
        public bool IsActiveHoldReason(string reasonText) { return dal.IsActiveHoldReason(reasonText); }
        public int SaveHoldReason(string reasonText, int userId) { return dal.SaveHoldReason(reasonText, userId); }
        public int SetHoldReasonActive(int holdReasonId, bool isActive, int userId) { return dal.SetHoldReasonActive(holdReasonId, isActive, userId); }
        public DataTable GetLoanHoldCandidates(int projectId, string dealNumber) { return dal.GetLoanHoldCandidates(projectId, dealNumber); }
        public DataTable GetHeldLoans(int projectId, string dealNumber) { return dal.GetHeldLoans(projectId, dealNumber); }
        public int HoldLoans(int projectId, string dealNumber, long[] itemIds, string reason, int userId) { return dal.HoldLoans(projectId, dealNumber, itemIds, reason, userId); }
        public int ResumeLoans(int projectId, string dealNumber, long[] itemIds, int userId) { return dal.ResumeLoans(projectId, dealNumber, itemIds, userId); }
        public void ResumeLoan(long assignmentId, int userId) { dal.ResumeLoan(assignmentId, userId); }
        public void CompleteLoan(long assignmentId, string remark, string[] feedbacks, int userId) { dal.CompleteLoan(assignmentId, remark, feedbacks, userId); }
        public void SkipLoan(long assignmentId, string remark, int userId) { dal.SkipLoan(assignmentId, remark, userId); }
        public DataSet GetFeedbackDefaults(long assignmentId, int userId, string feedbackBy) { return dal.GetFeedbackDefaults(assignmentId, userId, feedbackBy); }
        public bool GetCompletionFeedbackRequirement(long assignmentId, int userId) { return dal.GetCompletionFeedbackRequirement(assignmentId, userId); }
        public DataTable SaveFeedback(long assignmentId, string markedTo, string errorBy, string feedbackBy, string errorType,
            int categoryId, string category, int subcategoryId, string subcategory, string severity, string errorField,
            string screen, string feedbackType, string error, string shouldBe, string remark, string dateReviewed, int userId)
        {
            return dal.SaveFeedback(assignmentId, markedTo, errorBy, feedbackBy, errorType, categoryId, category,
                subcategoryId, subcategory, severity, errorField, screen, feedbackType, error, shouldBe, remark, dateReviewed, userId);
        }
        public DataTable SaveFeedbackForTargets(long assignmentId, long[] targetAssignmentIds, string feedbackBy, string errorType,
            int categoryId, string category, int subcategoryId, string subcategory, string severity, string errorField,
            string screen, string feedbackType, string error, string shouldBe, string remark, int userId)
        {
            return dal.SaveFeedbackForTargets(assignmentId, targetAssignmentIds, feedbackBy, errorType, categoryId,
                category, subcategoryId, subcategory, severity, errorField, screen, feedbackType, error, shouldBe, remark, userId);
        }
        public DataTable GetUserDailyStatus(int userId, int processId, DateTime? from, DateTime? to) { return dal.GetUserDailyStatus(userId, processId, from, to); }
        public DataTable GetUserDailyProcesses(int userId) { return dal.GetUserDailyProcesses(userId); }
        public DataTable GetHourlyProductivityEntries(int projectId, DateTime from, DateTime to) { return dal.GetHourlyProductivityEntries(projectId, from, to); }
        public DataTable GetProjectUsers(int projectId) { return dal.GetProjectUsers(projectId); }
        public DataTable GetEligibleLoans(int projectId, string dealNumber, int processId) { return dal.GetEligibleLoans(projectId, dealNumber, processId); }
       
        public int ManagerAllocate(int projectId, string dealNumber, int processId, int targetUserId, string[] loanNumbers, int managerId)
        {
            return dal.ManagerAllocate(projectId, dealNumber, processId, targetUserId, loanNumbers, managerId);
        }
        public void ValidateManagerAllocation(int projectId, int processId, string[] loanNumbers)
        { dal.ValidateManagerAllocation(projectId, processId, loanNumbers); }

        public DataTable GetManagerDetail(int projectId, string dealNumber, int processId, int userId, string status, string productivityType, DateTime? fromDate, DateTime? toDate)
        { return dal.GetManagerDetail(projectId, dealNumber, processId, userId, status, productivityType, fromDate, toDate); }
        public DataSet GetSndManagerDashboard(int projectId, DateTime fromDate, DateTime toDate)
        { return dal.GetSndManagerDashboard(projectId, fromDate, toDate); }
        public DataTable GetManagerSummary(int projectId, string dealNumber, int processId, int userId, string productivityType, DateTime? fromDate, DateTime? toDate)
        { return dal.GetManagerSummary(projectId, dealNumber, processId, userId, productivityType, fromDate, toDate); }
        public DataTable GetDealDashboard(int projectId, string dealNumber) { return dal.GetDealDashboard(projectId, dealNumber); }
        public DataTable GetHourlyProduction(int projectId, DateTime reportDate, string dealNumber) { return dal.GetHourlyProduction(projectId, reportDate, dealNumber); }
        public DataTable GetReallocationUsers(int projectId, string dealNumber, int processId) { return dal.GetReallocationUsers(projectId, dealNumber, processId); }
        public DataTable GetReallocationOrders(int projectId, string dealNumber, int processId, int fromUserId) { return dal.GetReallocationOrders(projectId, dealNumber, processId, fromUserId); }
        public int ReallocateOrders(int projectId, int fromUserId, int toUserId, long[] assignmentIds, string remark, bool confirmInProcess, int managerId)
        { return dal.ReallocateOrders(projectId, fromUserId, toUserId, assignmentIds, remark, confirmInProcess, managerId); }

        private static string FirstValue(DataRow row, params string[] names)
        {
            foreach (string name in names) if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value)
            { string value = Convert.ToString(row[name]).Trim(); if (value.Length > 0) return value; }
            return string.Empty;
        }

    }
}
