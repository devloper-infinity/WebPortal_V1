using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.TrackingSheet
{
    public partial class MonthlyBilling : System.Web.UI.Page
    {
        [WebMethod]
        public static List<MonthlyProjectOption> GetProjects()
        {
            List<MonthlyProjectOption> result = new List<MonthlyProjectOption>();
            foreach (DataRow row in new bllMaster().GetAllProject().Rows)
            {
                int id; string value = FirstValue(row, "ProjectID", "ProjectId", "projectID", "ID");
                if (int.TryParse(value, out id)) result.Add(new MonthlyProjectOption { ID = id, Name = FirstValue(row, "ProjectName", "ProjectNo", "Name", "Project") });
            }
            return result;
        }

        [WebMethod]
        public static MonthlyBillingResponse GetBillingRecords(int projectId, int billingMonth, int billingYear, bool history)
        {
            ValidatePeriod(projectId, billingMonth, billingYear);
            bllOLMonthlyBilling billing = new bllOLMonthlyBilling();
            DataTable fields = billing.GetFields(projectId), source = billing.GetRows(projectId, billingMonth, billingYear, history);
            string projectName = GetProjects().Where(x => x.ID == projectId).Select(x => x.Name).FirstOrDefault() ?? projectId.ToString();
            return BuildResponse(source, fields, projectName, history);
        }

        [WebMethod]
        public static BillingActionResponse VerifyRecords(int projectId, int billingMonth, int billingYear, List<MonthlyBillingSelection> records)
        {
            ValidatePeriod(projectId, billingMonth, billingYear);
            if (records == null || records.Count == 0) throw new ArgumentException("Select at least one record to verify.");
            DataTable selections = new DataTable(); selections.Columns.Add("ItemID", typeof(long)); selections.Columns.Add("OrderDate", typeof(DateTime));
            foreach (MonthlyBillingSelection record in records)
            {
                DateTime date; if (record.ItemID <= 0 || !DateTime.TryParseExact(record.OrderDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date)) throw new ArgumentException("A selected billing record is invalid.");
                selections.Rows.Add(record.ItemID, date.Date);
            }
            int count = new bllOLMonthlyBilling().Verify(projectId, billingMonth, billingYear, selections, UserId());
            return new BillingActionResponse { Success = true, Count = count, Message = count + " record(s) verified and locked successfully." };
        }

        [WebMethod]
        public static BillingActionResponse SendToAccounts(int projectId, int billingMonth, int billingYear)
        {
            ValidatePeriod(projectId, billingMonth, billingYear);
            int count = new bllOLMonthlyBilling().SendToAccounts(projectId, billingMonth, billingYear, UserId());
            return new BillingActionResponse { Success = true, Count = count, Message = count + " verified record(s) sent to Accounts successfully." };
        }

        private static MonthlyBillingResponse BuildResponse(DataTable source, DataTable fields, string projectName, bool history)
        {
            List<string> columns = new List<string> { "Project #", "Deal #", "Loan #", "Order Date", "Dispatch Date" };
            Dictionary<int, string> fieldColumns = new Dictionary<int, string>();
            foreach (DataRow field in fields.Rows)
            {
                string name = Convert.ToString(field["FieldName"]).Trim();
                if (name.Length == 0 || Reserved(name) || columns.Any(x => x.Equals(name, StringComparison.OrdinalIgnoreCase))) continue;
                columns.Add(name); fieldColumns[Convert.ToInt32(field["FieldConfigId"])] = name;
            }
            columns.Add("Verification Status"); columns.Add("Verified By"); columns.Add("Verified Date");
            columns.Add("Accounts Status"); columns.Add("Sent By"); columns.Add("Sent Date");

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, Dictionary<string, object>> map = new Dictionary<string, Dictionary<string, object>>();
            foreach (DataRow sourceRow in source.Rows)
            {
                DateTime orderDate = Convert.ToDateTime(sourceRow["EntryDate"]).Date;
                string key = Convert.ToString(sourceRow["ItemID"]) + "|" + orderDate.ToString("yyyyMMdd"); Dictionary<string, object> row;
                if (!map.TryGetValue(key, out row))
                {
                    bool verified = Convert.ToBoolean(sourceRow["IsVerified"]), sent = Convert.ToBoolean(sourceRow["IsSentToAccounts"]);
                    row = columns.ToDictionary(x => x, x => (object)string.Empty);
                    row["Project #"] = projectName; row["Deal #"] = Convert.ToString(sourceRow["DealNumber"]); row["Loan #"] = Convert.ToString(sourceRow["ItemNumber"]);
                    row["Order Date"] = orderDate.ToString("dd-MMM-yyyy"); row["Dispatch Date"] = Convert.ToDateTime(sourceRow["DispatchDate"]).ToString("dd-MMM-yyyy");
                    row["Verification Status"] = verified ? "Verified" : "Pending"; row["Verified By"] = sourceRow["VerifiedBy"] == DBNull.Value ? "" : Convert.ToString(sourceRow["VerifiedBy"]); row["Verified Date"] = FormatDateTime(sourceRow["VerifiedDate"]);
                    row["Accounts Status"] = sent ? "Sent" : "Pending"; row["Sent By"] = sourceRow["SentToAccountsBy"] == DBNull.Value ? "" : Convert.ToString(sourceRow["SentToAccountsBy"]); row["Sent Date"] = FormatDateTime(sourceRow["SentToAccountsDate"]);
                    row["_ItemID"] = Convert.ToInt64(sourceRow["ItemID"]); row["_OrderDate"] = orderDate.ToString("yyyy-MM-dd"); row["_CanVerify"] = !verified && !sent;
                    map.Add(key, row); rows.Add(row);
                }
                if (sourceRow["FieldConfigId"] != DBNull.Value) { string column; if (fieldColumns.TryGetValue(Convert.ToInt32(sourceRow["FieldConfigId"]), out column)) row[column] = Convert.ToString(sourceRow["FieldValue"]); }
            }
            return new MonthlyBillingResponse { Columns = columns, Rows = rows, RowCount = rows.Count, CanSendToAccounts = !history && rows.Any(x => Convert.ToString(x["Verification Status"]) == "Verified" && Convert.ToString(x["Accounts Status"]) != "Sent") };
        }

        private static string FormatDateTime(object value) { return value == DBNull.Value ? "" : Convert.ToDateTime(value).ToString("dd-MMM-yyyy HH:mm"); }
        private static bool Reserved(string value) { string n = new string((value ?? "").ToLowerInvariant().Where(char.IsLetterOrDigit).ToArray()); return new[] { "project", "projectno", "projectnumber", "deal", "dealno", "dealnumber", "loan", "loanno", "loannumber", "orderdate", "entrydate", "dispatchdate" }.Contains(n); }
        private static void ValidatePeriod(int projectId, int month, int year) { if (projectId <= 0 || month < 1 || month > 12 || year < 2000 || year > 9999) throw new ArgumentException("Select a valid project, billing month, and billing year."); }
        private static int UserId() { int id; if (!int.TryParse(HttpContext.Current.User.Identity.Name, out id) || id <= 0) throw new InvalidOperationException("Your user session is invalid. Please sign in again."); return id; }
        private static string FirstValue(DataRow row, params string[] names) { foreach (string name in names) if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value && !string.IsNullOrWhiteSpace(Convert.ToString(row[name]))) return Convert.ToString(row[name]).Trim(); return ""; }
    }

    public sealed class MonthlyProjectOption { public int ID { get; set; } public string Name { get; set; } }
    public sealed class MonthlyBillingSelection { public long ItemID { get; set; } public string OrderDate { get; set; } }
    public sealed class MonthlyBillingResponse { public List<string> Columns { get; set; } public List<Dictionary<string, object>> Rows { get; set; } public int RowCount { get; set; } public bool CanSendToAccounts { get; set; } }
    public sealed class BillingActionResponse { public bool Success { get; set; } public int Count { get; set; } public string Message { get; set; } }
}
