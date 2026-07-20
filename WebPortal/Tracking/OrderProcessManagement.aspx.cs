using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.DAL;

namespace WebPortal
{
    public partial class OrderProcessManagement : System.Web.UI.Page
    {
        private static string ConnectionString
        {
            get { return SQLHelper.ConnectionString; }
        }

        private static long CurrentUserID
        {
            get
            {
                long id;
                if (!long.TryParse(HttpContext.Current.User.Identity.Name, out id))
                    throw new Exception("Logged-in User ID is not available in User.Identity.Name.");
                return id;
            }
        }

        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static List<Dictionary<string, object>> GetProjects()
        {
            return ExecuteTable("usp_OPM_GetProjects", new SqlParameter("@UserID", CurrentUserID));
        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetProcesses(long projectID)
        {
            return ExecuteTable("usp_OPM_GetProcesses",
                new SqlParameter("@ProjectID", projectID),
                new SqlParameter("@UserID", CurrentUserID));
        }


        [WebMethod]
        public static List<Dictionary<string, object>> GetOrdersForAllocation(long projectID, long processID, string loanSearch)
        {
            return ExecuteTable("usp_OPM_GetOrdersForAllocation",
                new SqlParameter("@ProjectID", projectID),
                new SqlParameter("@ProcessID", processID),
                new SqlParameter("@LoanSearch", DbValue(loanSearch)));
        }

        [WebMethod]
        public static ApiResult_Track TakeOrders(string orderIDs, long projectID, long processID)
        {
            return ExecuteResult("usp_OPM_AllocateOrders",
                new SqlParameter("@OrderIDs", orderIDs),
                new SqlParameter("@ProjectID", projectID),
                new SqlParameter("@ProcessID", processID),
                new SqlParameter("@UserID", CurrentUserID));
        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetMyOrders(long? projectID, long? processID, string status, string loanSearch)
        {
            return ExecuteTable("usp_OPM_GetMyOrders",
                new SqlParameter("@UserID", CurrentUserID),
                new SqlParameter("@ProjectID", DbValue(projectID)),
                new SqlParameter("@ProcessID", DbValue(processID)),
                new SqlParameter("@Status", DbValue(status)),
                new SqlParameter("@LoanSearch", DbValue(loanSearch)));
        }

        [WebMethod]
        public static ApiResult_Track StartOrder(long orderID, long processID)
        {
            return ExecuteResult("usp_OPM_StartOrder",
                new SqlParameter("@OrderID", orderID),
                new SqlParameter("@ProcessID", processID),
                new SqlParameter("@UserID", CurrentUserID));
        }

        [WebMethod]
        public static ApiResult_Track HoldOrder(long orderID, long processID, string remarks)
        {
            return ExecuteResult("usp_OPM_HoldOrder",
                new SqlParameter("@OrderID", orderID),
                new SqlParameter("@ProcessID", processID),
                new SqlParameter("@UserID", CurrentUserID),
                new SqlParameter("@Remarks", DbValue(remarks)));
        }

        [WebMethod]
        public static ApiResult_Track CompleteOrder(long orderID, long processID, string remarks)
        {
            return ExecuteResult("usp_OPM_CompleteOrder",
                new SqlParameter("@OrderID", orderID),
                new SqlParameter("@ProcessID", processID),
                new SqlParameter("@UserID", CurrentUserID),
                new SqlParameter("@Remarks", DbValue(remarks)));
        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetReport(string fromDate, string toDate, long? projectID, long? processID, string status, string loanNo)
        {
            DateTime from;
            DateTime to;
            if (!DateTime.TryParse(fromDate, out from) || !DateTime.TryParse(toDate, out to))
                throw new Exception("Valid From Date and To Date are required.");

            return ExecuteTable("usp_OPM_GetReport",
                new SqlParameter("@FromDate", from.Date),
                new SqlParameter("@ToDate", to.Date),
                new SqlParameter("@ProjectID", DbValue(projectID)),
                new SqlParameter("@ProcessID", DbValue(processID)),
                new SqlParameter("@UserID", CurrentUserID),
                new SqlParameter("@Status", DbValue(status)),
                new SqlParameter("@LoanNo", DbValue(loanNo)));
        }

        private static object DbValue(object value)
        {
            if (value == null) return DBNull.Value;
            var text = value as string;
            if (text != null && string.IsNullOrWhiteSpace(text)) return DBNull.Value;
            return value;
        }

        private static List<Dictionary<string, object>> ExecuteTable(string procedure, params SqlParameter[] parameters)
        {
            var rows = new List<Dictionary<string, object>>();
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(procedure, con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddRange(parameters);
                con.Open();
                using (var dr = cmd.ExecuteReader()) 
                {
                    while (dr.Read())
                    {
                        var row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                        for (int i = 0; i < dr.FieldCount; i++)
                            row[dr.GetName(i)] = dr.IsDBNull(i) ? null : dr.GetValue(i);
                        rows.Add(row);
                    }
                }
            }
            return rows;
        }

        private static ApiResult_Track ExecuteResult(string procedure, params SqlParameter[] parameters)
        {
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(procedure, con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddRange(parameters);
                con.Open();
                using (var dr = cmd.ExecuteReader())
                {
                    if (!dr.Read()) return new ApiResult_Track(false, "No response returned by procedure.");
                    return new ApiResult_Track(Convert.ToBoolean(dr["IsSuccess"]), Convert.ToString(dr["Message"]));
                }
            }
        }
    }

    public class ApiResult_Track
    {
        public bool IsSuccess { get; set; }
        public string Message { get; set; }

        public ApiResult_Track() { }
        public ApiResult_Track(bool isSuccess, string message)
        {
            IsSuccess = isSuccess;
            Message = message;
        }
    }
}
