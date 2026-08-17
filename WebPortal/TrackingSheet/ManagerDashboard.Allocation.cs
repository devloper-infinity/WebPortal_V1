using System;
using System.Data;
using System.Data.SqlClient;
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
            if (sql.Number == 50110 || sql.Number == 50112 || sql.Number == 50128 || sql.Number == 50130 || sql.Number == 50131 || sql.Number == 50134 || sql.Number == 50136 || sql.Number == 50143) return sql.Message;
            if (sql.Number == 2601 || sql.Number == 2627) return "The configured unique-field combination is already allocated to another user.";
            return "The requested allocation could not be completed. Please refresh and try again.";
        }
    }
}
