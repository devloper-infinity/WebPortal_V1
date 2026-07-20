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
            dal.SyncImportedItems(projectId, userId);
            DataTable output = new DataTable(); output.Columns.Add("DealNo"); output.Columns.Add("DealNumber");
            System.Collections.Generic.HashSet<string> seen = new System.Collections.Generic.HashSet<string>(StringComparer.OrdinalIgnoreCase);
            AddDeals(output, seen, dal.GetImportedDeals(projectId));
            AddDeals(output, seen, new bllTracking().GetAllProjectDealNumberNew(projectId));
            return output;
        }
        public DataTable GetProcessFlow(int projectId) { return dal.GetProcessFlow(projectId); }
        public void SaveProcessFlow(int projectId, int processId, string processName, int stageNo, bool mandatory, bool feedback, int userId)
        { dal.SaveProcessFlow(projectId, processId, processName, stageNo, mandatory, feedback, userId); }
        public int RemoveProcessFlow(int projectId, int processId, int userId) { return dal.RemoveProcessFlow(projectId, processId, userId); }
        public DataTable GetAvailableLoan(int projectId, string dealNumber, int processId, string processName, int userId)
        {
            DataTable output = new DataTable(); output.Columns.Add("LoanNumber"); output.Columns.Add("DealNumber");
            dal.SyncImportedItems(projectId, userId);
            DataTable imported = dal.GetImportedLoans(projectId, dealNumber);
            foreach (DataRow row in imported.Rows)
            {
                string importedLoan = FirstValue(row, "LoanNumber");
                if (string.IsNullOrWhiteSpace(importedLoan) || !dal.IsLoanEligible(projectId, processId, importedLoan)) continue;
                DataRow importedItem = output.NewRow(); importedItem["LoanNumber"] = importedLoan;
                importedItem["DealNumber"] = FirstValue(row, "DealNumber", "DealNo", "Deal"); output.Rows.Add(importedItem); return output;
            }
            DataTable source = new bllTracking().GetAllOrderNoByProjectWise(projectId, dealNumber ?? string.Empty, processName ?? string.Empty, string.Empty, "Allocation");
            if (source == null) return output;
            foreach (DataRow row in source.Rows)
            {
                string loan = FirstValue(row, "LoanNumber", "LoanNo", "OrderNumber", "OrderNo", "OrderNumber1");
                if (string.IsNullOrWhiteSpace(loan)) continue;
                if (!dal.IsLoanEligible(projectId, processId, loan)) continue;
                DataRow item = output.NewRow(); item["LoanNumber"] = loan;
                item["DealNumber"] = FirstValue(row, "DealNumber", "DealNo", "Deal"); output.Rows.Add(item); break;
            }
            return output;
        }
        public int AllocateLoan(int projectId, int processId, string loanNumber, string dealNumber, int userId) { return dal.AllocateLoan(projectId, processId, loanNumber, dealNumber, userId); }
        public DataTable GetTrackingQueue(int userId) { return dal.GetTrackingQueue(userId); }
        public void StartLoan(long assignmentId, int userId) { dal.StartLoan(assignmentId, userId); }
        public void CompleteLoan(long assignmentId, string remark, string[] feedbacks, int userId) { dal.CompleteLoan(assignmentId, remark, feedbacks, userId); }
        public DataTable GetUserDailyStatus(int userId, int processId, DateTime? from, DateTime? to) { return dal.GetUserDailyStatus(userId, processId, from, to); }
        public DataTable GetUserDailyProcesses(int userId) { return dal.GetUserDailyProcesses(userId); }

        private static string FirstValue(DataRow row, params string[] names)
        {
            foreach (string name in names) if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value)
            { string value = Convert.ToString(row[name]).Trim(); if (value.Length > 0) return value; }
            return string.Empty;
        }

        private static void AddDeals(DataTable output, System.Collections.Generic.HashSet<string> seen, DataTable source)
        {
            if (source == null) return;
            foreach (DataRow row in source.Rows)
            {
                string deal = FirstValue(row, "DealNo", "DealNumber", "Deal");
                if (string.IsNullOrWhiteSpace(deal) || !seen.Add(deal)) continue;
                DataRow result = output.NewRow(); result["DealNo"] = deal; result["DealNumber"] = deal; output.Rows.Add(result);
            }
        }
    }
}
