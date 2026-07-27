using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Vendor
{
    public partial class VendorBillingGeneratePeriod : System.Web.UI.Page
    {
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetInitialData()
        {
            try
            {
                bllVendors bal = new bllVendors();
                DataTable fromDateTable = bal.GetFromDate();
                string fromDate = string.Empty;
                if (fromDateTable.Rows.Count > 0 && fromDateTable.Columns.Contains("ToDate") && fromDateTable.Rows[0]["ToDate"] != DBNull.Value)
                    fromDate = Convert.ToDateTime(fromDateTable.Rows[0]["ToDate"]).AddDays(1).ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);

                DataTable pendingSummaryTable = bal.GetPQAPendingSummary();
                Dictionary<string, object> pendingSummary = BuildPendingSummary(pendingSummaryTable);

                string activeTab = Convert.ToString(HttpContext.Current.Session["Process"]);
                return ApiResponse.Ok(new
                {
                    FromDate = fromDate,
                    ActiveTab = activeTab,
                    Periods = ToRows(bal.GetPQASummary()),
                    PendingSummary = pendingSummary,
                    PendingFiles = ToRows(bal.GetPQAPendingSummaryFile())
                });
            }
            catch (Exception ex)
            {
                return ApiResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GeneratePeriod(string fromDate, string toDate)
        {
            try
            {
                DateTime parsedFromDate;
                DateTime parsedToDate;
                if (!DateTime.TryParseExact(fromDate, "dd-MMM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsedFromDate))
                    return ApiResponse.Fail("Invalid From Date.");
                if (!DateTime.TryParse(toDate, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsedToDate))
                    return ApiResponse.Fail("Invalid To Date.");
                if (parsedToDate < parsedFromDate)
                    return ApiResponse.Fail("To Date cannot be earlier than From Date.");

                long addedBy;
                if (!long.TryParse(Convert.ToString(HttpContext.Current.User.Identity.Name), out addedBy))
                    return ApiResponse.Fail("Unable to identify the logged-in user.");

                int result = new bllVendors().GenerateBillingPeriod(parsedFromDate, parsedToDate, "Pending", addedBy);
                if (result == 1) return ApiResponse.Ok(null, "Period generated successfully.");
                if (result == 2) return ApiResponse.Fail("Period cannot be generated because the previous period is pending.");
                return ApiResponse.Fail("Billing period was not generated.");
            }
            catch (Exception ex)
            {
                return ApiResponse.Fail(ex.Message);
            }
        }

        private static Dictionary<string, object> BuildPendingSummary(DataTable table)
        {
            Dictionary<string, object> result = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
            if (table == null || table.Rows.Count == 0)
                return result;

            DataRow row = table.Rows[0];
            foreach (DataColumn column in table.Columns)
                result[NormalizeKey(column.ColumnName)] = row[column] == DBNull.Value ? null : row[column];

            int totalFiles = ToInt(GetValue(row, "TotalFiles"));
            int pendingFiles = ToInt(GetValue(row, "PendingFiles"));
            result["VerifiedFiles"] = Math.Max(0, totalFiles - pendingFiles);
            result["AmountPaid"] = GetValue(row, "Amount Paid") ?? 0;
            result["PenaltyAmount"] = GetValue(row, "Penalty Amount") ?? 0;
            result["TotalCost"] = GetValue(row, "Total Cost") ?? 0;
            return result;
        }

        private static object GetValue(DataRow row, string columnName)
        {
            return row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value ? row[columnName] : null;
        }

        private static int ToInt(object value)
        {
            int number;
            return value != null && int.TryParse(Convert.ToString(value), out number) ? number : 0;
        }

        private static string NormalizeKey(string key)
        {
            return key.Replace(" ", string.Empty).Replace("/", string.Empty).Replace("-", string.Empty);
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow row in table.Rows)
            {
                Dictionary<string, object> item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                    item[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
                rows.Add(item);
            }
            return rows;
        }

        public class ApiResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public object Data { get; set; }
            public static ApiResponse Ok(object data, string message = "") { return new ApiResponse { Success = true, Message = message, Data = data }; }
            public static ApiResponse Fail(string message) { return new ApiResponse { Success = false, Message = message, Data = null }; }
        }
    }
}