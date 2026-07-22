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
        public static string GetFlow(int projectId)
        {
            Access(projectId);
            return OLTrackingWeb.Json(new bllOLTracking().GetProcessFlow(projectId));
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
                int count = new bllOLTracking().ManagerAllocate(projectId, dealNumber, processId, targetUserId, loanNumbers, OLTrackingWeb.UserId);
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
            if (sql.Number == 50110 || sql.Number == 50128 || sql.Number == 50130 || sql.Number == 50131) return sql.Message;
            return "The requested allocation could not be completed. Please refresh and try again.";
        }
    }
}
