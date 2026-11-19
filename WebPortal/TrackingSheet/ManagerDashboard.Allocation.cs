using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Services;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;

namespace WebPortal.TrackingSheet
{
    public partial class ManagerDashboardPage : System.Web.UI.Page
    {
        [WebMethod]
        public static string GetFlow(int projectId, string dealNumber)
        {
            Access(projectId);
            return OLTrackingWeb.Json(new bllOLTracking().GetEffectiveProcessFlow(projectId, dealNumber));
        }

        [WebMethod]
        public static string GetEligibleLoans(int projectId, string dealNumber, int processId)
        {
            Access(projectId);
            return OLTrackingWeb.Json(new bllOLTracking().GetEligibleLoans(projectId, dealNumber, processId));
        }

        [WebMethod]
        public static ManagerAllocationResult AllocateOrders(int projectId, string dealNumber, int processId, int targetUserId, string[] loanNumbers)
        {
            try
            {
                Access(projectId);
                bllOLTracking tracking = new bllOLTracking();
                tracking.ValidateManagerAllocation(projectId, processId, loanNumbers);
                int count = tracking.ManagerAllocate(projectId, dealNumber, processId, targetUserId, loanNumbers, OLTrackingWeb.UserId);
                return new ManagerAllocationResult { Success = count > 0, AllocatedCount = count, Message = count + " order(s) allocated successfully." };
            }
            catch (Exception ex)
            {
                return new ManagerAllocationResult { Success = false, Message = AllocationMessage(ex) };
            }
        }

        [WebMethod]
        public static BulkAllocationResult ValidateBulkAllocations(int projectId, BulkAllocationRow[] rows)
        {
            try { Access(projectId); return PrepareBulkAllocations(projectId, rows); }
            catch (Exception ex) { return new BulkAllocationResult { Success = false, Message = AllocationMessage(ex), Rows = new List<BulkAllocationRow>() }; }
        }

        [WebMethod]
        public static BulkAllocationResult AllocateBulkOrders(int projectId, BulkAllocationRow[] rows)
        {
            try
            {
                Access(projectId);
                BulkAllocationResult result = PrepareBulkAllocations(projectId, rows);
                bllOLTracking tracking = new bllOLTracking(); int allocated = 0; int unchanged = 0;
                foreach (BulkAllocationRow row in result.Rows.Where(x => x.Status == "Valid" || x.Status == "Reassign" || x.Status == "Existing"))
                {
                    try
                    {
                        if (row.Status == "Existing")
                        {
                            row.Status = "Allocated"; row.Message = "Already allocated to this employee."; unchanged++;
                            continue;
                        }
                        if (row.Status == "Reassign")
                        {
                            int reassigned = tracking.BulkReassignPending(row.AssignmentID, row.UserID, OLTrackingWeb.UserId, BulkCapacityLimit(row.Process));
                            row.Status = reassigned > 0 ? "Allocated" : "Failed";
                            row.Message = reassigned > 0 ? "Pending assignment updated to this employee." : "Assignment was not updated.";
                            allocated += reassigned;
                            continue;
                        }
                        string[] loan = new[] { row.LoanNumber };
                        int canonicalProcessId = tracking.ResolveEffectiveProcessId(projectId, row.DealNumber, row.Process);
                        if (canonicalProcessId <= 0) throw new InvalidOperationException("Process is no longer configured for this deal.");
                        row.ProcessID = canonicalProcessId;
                        tracking.ValidateManagerAllocation(projectId, canonicalProcessId, loan);
                        int capacityLimit = BulkCapacityLimit(row.Process);
                        int count = tracking.ManagerAllocate(projectId, row.DealNumber, canonicalProcessId, row.UserID, loan, OLTrackingWeb.UserId, capacityLimit);
                        row.Status = count > 0 ? "Allocated" : "Failed"; row.Message = count > 0 ? "Allocated successfully." : "No order was allocated."; allocated += count;
                    }
                    catch (Exception ex) { row.Status = "Failed"; row.Message = AllocationMessage(ex); }
                }
                result.AllocatedCount = allocated; result.ValidCount = result.Rows.Count(x => x.Status == "Valid"); result.InvalidCount = result.Rows.Count(x => x.Status == "Invalid" || x.Status == "Failed");
                result.Success = allocated > 0 || unchanged > 0; result.Message = allocated + " order(s) allocated/reassigned, " + unchanged + " already allocated. " + result.InvalidCount + " row(s) require attention."; return result;
            }
            catch (Exception ex) { return new BulkAllocationResult { Success = false, Message = AllocationMessage(ex), Rows = new List<BulkAllocationRow>() }; }
        }

        private static BulkAllocationResult PrepareBulkAllocations(int projectId, BulkAllocationRow[] input)
        {
            List<BulkAllocationRow> rows = (input ?? new BulkAllocationRow[0]).Take(250).Select((x, i) => new BulkAllocationRow
            {
                RowNumber = i + 1, DealNumber = (x.DealNumber ?? "").Trim(), LoanNumber = (x.LoanNumber ?? "").Trim(),
                Employee = (x.Employee ?? "").Trim(), Process = (x.Process ?? "").Trim(), Status = "Invalid"
            }).ToList();
            if (rows.Count == 0) return new BulkAllocationResult { Success = false, Message = "Add at least one allocation row.", Rows = rows };

            bllOLTracking tracking = new bllOLTracking(); DataTable users = tracking.GetProjectUsers(projectId);
            Dictionary<string, DataTable> flows = new Dictionary<string, DataTable>(StringComparer.OrdinalIgnoreCase);
            Dictionary<string, HashSet<string>> eligible = new Dictionary<string, HashSet<string>>(StringComparer.OrdinalIgnoreCase);
            Dictionary<string, DataRow> existingAssignments = new Dictionary<string, DataRow>(StringComparer.OrdinalIgnoreCase);
            Dictionary<int, int> planned = new Dictionary<int, int>(); HashSet<string> duplicates = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (BulkAllocationRow row in rows)
            {
                if (row.DealNumber.Length == 0 || row.LoanNumber.Length == 0 || row.Employee.Length == 0 || row.Process.Length == 0) { row.Message = "Deal #, Loan #, Employee and Process are required."; continue; }
                DataRow user = users.AsEnumerable().FirstOrDefault(x => RowText(x, "UserName").Equals(row.Employee, StringComparison.OrdinalIgnoreCase) || RowText(x, "UserID").Equals(row.Employee, StringComparison.OrdinalIgnoreCase));
                if (user == null) { row.Message = "Employee is not configured for this project."; continue; }
                row.UserID = Convert.ToInt32(user["UserID"]); row.Employee = RowText(user, "UserName");
                DataTable flow; if (!flows.TryGetValue(row.DealNumber, out flow)) { flow = tracking.GetEffectiveProcessFlow(projectId, row.DealNumber); flows[row.DealNumber] = flow; }
                DataRow process = flow.AsEnumerable().FirstOrDefault(x => RowText(x, "ProcessName").Equals(row.Process, StringComparison.OrdinalIgnoreCase) || RowText(x, "ProcessID").Equals(row.Process, StringComparison.OrdinalIgnoreCase));
                if (process == null) { row.Message = "Process is not available for this deal."; continue; }
                row.ProcessID = Convert.ToInt32(process["ProcessID"]); row.Process = RowText(process, "ProcessName");
                string duplicateKey = row.DealNumber + "|" + row.LoanNumber + "|" + row.ProcessID;
                if (!duplicates.Add(duplicateKey)) { row.Message = "Duplicate row in this batch."; continue; }
                DataRow existing;
                if (!existingAssignments.TryGetValue(duplicateKey, out existing))
                {
                    DataTable current = tracking.GetCurrentLoanProcessAssignment(projectId, row.DealNumber, row.LoanNumber, row.ProcessID);
                    existing = current.Rows.Count == 0 ? null : current.Rows[0]; existingAssignments[duplicateKey] = existing;
                }
                if (existing != null)
                {
                    row.AssignmentID = Convert.ToInt64(existing["AssignmentID"]);
                    int existingUserId = Convert.ToInt32(existing["UserID"]);
                    string existingStatus = RowText(existing, "AssignmentStatus");
                    if (existingUserId == row.UserID)
                    {
                        row.Status = "Existing"; row.Message = "Already allocated to this employee."; continue;
                    }
                    if (!existingStatus.Equals("Pending", StringComparison.OrdinalIgnoreCase))
                    {
                        row.Message = "Loan is already " + existingStatus + " under " + RowText(existing, "UserName") + "."; continue;
                    }
                    int reassignLimit = BulkCapacityLimit(row.Process);
                    int reassignActive = user.Table.Columns.Contains("ActiveCount") && user["ActiveCount"] != DBNull.Value ? Convert.ToInt32(user["ActiveCount"]) : 0;
                    int reassignPending; planned.TryGetValue(row.UserID, out reassignPending);
                    if (reassignLimit > 0 && reassignActive + reassignPending >= reassignLimit)
                    {
                        row.Message = "Employee capacity of " + reassignLimit + " active orders would be exceeded."; continue;
                    }
                    planned[row.UserID] = reassignPending + 1; row.Status = "Reassign";
                    row.Message = "Pending assignment will move from " + RowText(existing, "UserName") + "."; continue;
                }
                string eligibilityKey = row.DealNumber + "|" + row.ProcessID; HashSet<string> loans;
                if (!eligible.TryGetValue(eligibilityKey, out loans)) { loans = new HashSet<string>(tracking.GetEligibleLoans(projectId, row.DealNumber, row.ProcessID, true).AsEnumerable().Select(x => RowText(x, "LoanNumber")), StringComparer.OrdinalIgnoreCase); eligible[eligibilityKey] = loans; }
                if (!loans.Contains(row.LoanNumber)) { row.Message = "Loan is not eligible for this deal/process."; continue; }
                int active = user.Table.Columns.Contains("ActiveCount") && user["ActiveCount"] != DBNull.Value ? Convert.ToInt32(user["ActiveCount"]) : 0;
                int pending; planned.TryGetValue(row.UserID, out pending);
                int capacityLimit = BulkCapacityLimit(row.Process);
                if (capacityLimit > 0 && active + pending >= capacityLimit)
                {
                    row.Message = "Employee capacity of " + capacityLimit + " active orders would be exceeded.";
                    continue;
                }
                planned[row.UserID] = pending + 1; row.Status = "Valid"; row.Message = "Ready to allocate.";
            }
            int valid = rows.Count(x => x.Status == "Valid" || x.Status == "Reassign" || x.Status == "Existing"), invalid = rows.Count - valid;
            return new BulkAllocationResult { Success = valid > 0, Message = valid + " valid and " + invalid + " invalid row(s).", Rows = rows, ValidCount = valid, InvalidCount = invalid };
        }

        private static string RowText(DataRow row, string column) { return row.Table.Columns.Contains(column) && row[column] != DBNull.Value ? Convert.ToString(row[column]).Trim() : string.Empty; }

        private static int BulkCapacityLimit(string processName)
        {
            string normalized = new string((processName ?? string.Empty).Where(char.IsLetterOrDigit).ToArray());
            return normalized.Equals("CollectionCommentsReQC", StringComparison.OrdinalIgnoreCase)
                || normalized.Equals("PHReQC", StringComparison.OrdinalIgnoreCase)
                || normalized.Equals("DataFieldsReQC", StringComparison.OrdinalIgnoreCase)
                ? 0
                : 3;
        }

        private static void Access(int projectId)
        {
            foreach (DataRow row in new bllOLTracking().GetProjectsByUser(OLTrackingWeb.UserId).Rows)
                if (Convert.ToInt32(row["ProjectID"]) == projectId) return;
            throw new UnauthorizedAccessException("Project access denied.");
        }

        private static string AllocationMessage(Exception ex)
        {
            SqlException sql = ex as SqlException;
            if (sql == null) return "The requested allocation could not be completed.";
            if (sql.Number == 50110 || sql.Number == 50112 || sql.Number == 50128 || sql.Number == 50130 || sql.Number == 50131 || sql.Number == 50134 || sql.Number == 50136 || sql.Number == 50143 || sql.Number == 50160) return sql.Message;
            if (sql.Number == 2601 || sql.Number == 2627) return "The configured unique-field combination is already allocated to another user.";
            return "The requested allocation could not be completed. Please refresh and try again.";
        }
    }

    public sealed class BulkAllocationRow
    {
        public int RowNumber { get; set; } public string DealNumber { get; set; } public string LoanNumber { get; set; }
        public string Employee { get; set; } public string Process { get; set; } public int UserID { get; set; } public int ProcessID { get; set; } public long AssignmentID { get; set; }
        public string Status { get; set; } public string Message { get; set; }
    }
    public sealed class BulkAllocationResult
    {
        public bool Success { get; set; } public string Message { get; set; } public int ValidCount { get; set; }
        public int InvalidCount { get; set; } public int AllocatedCount { get; set; } public List<BulkAllocationRow> Rows { get; set; }
    }
}
