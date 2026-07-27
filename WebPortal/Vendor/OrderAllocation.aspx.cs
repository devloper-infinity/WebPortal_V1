using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Vendor
{
    public partial class OrderAllocation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static InitialData GetInitialData()
        {
            string userId = HttpContext.Current.User.Identity.Name;
            return new InitialData
            {
                Projects = ToLookup(new bllVendors().GetprojectByPM(userId), "ProjectID", "ProjectName"),
                Users = GetUserLookup("Vendor")
            };
        }

        [WebMethod]
        public static List<LookupItem> GetUsers(string userType)
        {
            return GetUserLookup(string.IsNullOrWhiteSpace(userType) ? "Vendor" : userType.Trim());
        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetPendingOrders(string projectName)
        {
            if (string.IsNullOrWhiteSpace(projectName)) return new List<Dictionary<string, object>>();
            return ToRows(new bllVendors().GetAllProcesswiseOrder_ForAllocation(projectName.Trim()));
        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetOrders(int projectId, string projectName, string process, string orderDate)
        {
            if (projectId <= 0 || string.IsNullOrWhiteSpace(projectName) || string.IsNullOrWhiteSpace(process) || string.IsNullOrWhiteSpace(orderDate))
                return new List<Dictionary<string, object>>();

            DataTable table = projectId == 227
                ? GetOrdersForSpecialProject(projectName.Trim(), orderDate.Trim(), process.Trim())
                : new bllVendors().GetAllOrderDetaisByProjectAndOrderDate(projectName.Trim(), orderDate.Trim());

            return ToRows(table);
        }

        [WebMethod]
        public static ApiResult AllocateOrders(AllocationRequest request)
        {
            try
            {
                if (request == null) return ApiResult.Fail("Allocation details are required.");
                if (request.ProjectId <= 0 || string.IsNullOrWhiteSpace(request.ProjectName)) return ApiResult.Fail("Please select Project.");
                if (string.IsNullOrWhiteSpace(request.Process)) return ApiResult.Fail("Please select Process.");
                if (string.IsNullOrWhiteSpace(request.VendorDisplay) || request.VendorDisplay == "Select") return ApiResult.Fail("Please select Vendor/User Code.");
                if (request.Orders == null || request.Orders.Count == 0) return ApiResult.Fail("Please select at least one order.");

                int addedBy;
                if (!int.TryParse(HttpContext.Current.User.Identity.Name, out addedBy)) return ApiResult.Fail("Unable to identify logged-in user.");

                string vendorCode = ExtractVendorCode(request.VendorDisplay);
                int successCount = 0;
                List<string> errors = new List<string>();

                foreach (AllocationOrder order in request.Orders)
                {
                    if (order == null || string.IsNullOrWhiteSpace(order.OrderNo)) continue;
                    try
                    {
                        string originalOrderNo = order.OrderNo.Trim();
                        string trackingOrderNo = Regex.Replace(originalOrderNo, @"\s", "");
                        int result = request.ProjectId == 227
                            ? InsertAllocatedOrder(request.ProjectName, trackingOrderNo, vendorCode, order.OrderDate, originalOrderNo, addedBy, request.Process)
                            : new bllVendors().InsertAllocatedOrderInTrackingSheet(request.ProjectName, trackingOrderNo, vendorCode, order.OrderDate, originalOrderNo, addedBy);

                        if (result > 0)
                        {
                            successCount++;
                            CopyInputFile(request.ProjectName, originalOrderNo, order.OrderDate, trackingOrderNo, addedBy);
                        }
                        else errors.Add(originalOrderNo + ": allocation failed.");
                    }
                    catch (Exception ex)
                    {
                        errors.Add(order.OrderNo + ": " + ex.Message);
                    }
                }

                if (successCount == 0)
                    return ApiResult.Fail(errors.Count > 0 ? string.Join(" ", errors.ToArray()) : "Unable to allocate selected orders.");

                string message = successCount + " order(s) allocated successfully.";
                if (errors.Count > 0) message += " " + errors.Count + " order(s) failed.";
                return new ApiResult { Success = true, Message = message, SuccessCount = successCount, FailureCount = errors.Count };
            }
            catch (Exception ex)
            {
                return ApiResult.Fail(ex.Message);
            }
        }

        private static void CopyInputFile(string projectName, string orderNo, string orderDate, string trackingOrderNo, int addedBy)
        {
            DataTable table = new bllVendors().GetInputFile_Vendor_ERPWBT(projectName, orderNo, orderDate);
            if (table == null || table.Rows.Count == 0) return;

            string inputFile = Convert.ToString(table.Rows[0]["InputFile"]);
            if (string.IsNullOrWhiteSpace(inputFile) || !File.Exists(inputFile)) return;

            byte[] file = File.ReadAllBytes(inputFile);
            Hashtable p = new Hashtable();
            p["ProjectNumber"] = projectName;
            p["Process"] = "Order Creation";
            p["OrderNumber"] = trackingOrderNo;
            p["OrderDate"] = orderDate;
            p["UserName"] = "Admin";
            p["FileExtension"] = Path.GetExtension(inputFile);
            p["Remark"] = string.Empty;
            p["File"] = file;
            p["AddedBy"] = addedBy;
            new bllVendors().InsertFileForOrder(p, file.Length);
        }

        private static int InsertAllocatedOrder(string projectNumber, string orderNumber, string vendorCode, string orderDate, string originalOrderNumber, int addedBy, string process)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "WBT_usp_AllocateOrderToVendorInTrackingSheet_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", SqlDbType.NVarChar, 200, ParameterDirection.Input, projectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", SqlDbType.NVarChar, 4000, ParameterDirection.Input, orderNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorCode", SqlDbType.NVarChar, 100, ParameterDirection.Input, vendorCode);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", SqlDbType.NVarChar, 200, ParameterDirection.Input, orderDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@OriginalOrderNumber", SqlDbType.NVarChar, 2000, ParameterDirection.Input, originalOrderNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, addedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", SqlDbType.NVarChar, 4000, ParameterDirection.Input, process);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
        }

        private static DataTable GetOrdersForSpecialProject(string projectNumber, string orderDate, string process)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllProject_GetFilesToAssign_WBTERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", SqlDbType.NVarChar, 200, ParameterDirection.Input, projectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", SqlDbType.NVarChar, 200, ParameterDirection.Input, orderDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", SqlDbType.NVarChar, 4000, ParameterDirection.Input, process);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        private static string ExtractVendorCode(string display)
        {
            int index = display.IndexOf(":", StringComparison.Ordinal);
            return (index >= 0 ? display.Substring(0, index) : display).Trim();
        }

        private static List<LookupItem> GetUserLookup(string userType)
        {
            DataTable table = new bllOST().GetUsersOnUserType(userType);
            List<LookupItem> result = new List<LookupItem>();
            if (table == null) return result;
            foreach (DataRow row in table.Rows)
            {
                string name = JoinName(Convert.ToString(row["FirstName"]), Convert.ToString(row["MiddleName"]), Convert.ToString(row["lastName"]));
                result.Add(new LookupItem { Value = Convert.ToString(row["EmployeeID"]), Text = Convert.ToString(row["Code"]) + " : " + name });
            }
            return result;
        }

        private static string JoinName(params string[] parts)
        {
            List<string> values = new List<string>();
            foreach (string part in parts) if (!string.IsNullOrWhiteSpace(part)) values.Add(part.Trim());
            return string.Join(" ", values.ToArray());
        }

        private static List<LookupItem> ToLookup(DataTable table, string valueColumn, string textColumn)
        {
            List<LookupItem> result = new List<LookupItem>();
            if (table == null) return result;
            foreach (DataRow row in table.Rows)
                result.Add(new LookupItem { Value = Convert.ToString(row[valueColumn]), Text = Convert.ToString(row[textColumn]) });
            return result;
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow row in table.Rows)
            {
                Dictionary<string, object> item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn col in table.Columns) item[col.ColumnName] = row[col] == DBNull.Value ? null : row[col];
                rows.Add(item);
            }
            return rows;
        }

        public class InitialData { public List<LookupItem> Projects { get; set; } public List<LookupItem> Users { get; set; } }
        public class LookupItem { public string Value { get; set; } public string Text { get; set; } }
        public class AllocationRequest { public int ProjectId { get; set; } public string ProjectName { get; set; } public string Process { get; set; } public string VendorDisplay { get; set; } public List<AllocationOrder> Orders { get; set; } }
        public class AllocationOrder { public string OrderNo { get; set; } public string OrderDate { get; set; } }
        public class ApiResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public int SuccessCount { get; set; }
            public int FailureCount { get; set; }
            public static ApiResult Fail(string message) { return new ApiResult { Success = false, Message = message }; }
        }
    }
}