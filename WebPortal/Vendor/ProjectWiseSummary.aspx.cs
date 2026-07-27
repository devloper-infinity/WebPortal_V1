using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Vendor
{
    public partial class ProjectWiseSummary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetSummary(string vendorCode, int invoiceId, string status)
        {
            try
            {
                vendorCode = (vendorCode ?? string.Empty).Trim();
                if (vendorCode.Length == 0)
                    return ApiResponse.Fail("Vendor Code is required.");
                if (invoiceId <= 0)
                    return ApiResponse.Fail("Valid Invoice ID is required.");

                DataTable table = new bllVendors().GetVendorWiseProjectDetails(vendorCode, invoiceId);
                List<Dictionary<string, object>> rows = ToRows(table);

                int totalFiles = 0;
                int verifiedFiles = 0;
                int unverifiedFiles = 0;
                decimal totalCost = 0;

                if (table != null)
                {
                    foreach (DataRow row in table.Rows)
                    {
                        totalFiles += ToInt(GetValue(row, "TotalFiles"));
                        verifiedFiles += ToInt(GetValue(row, "VarifiedFiles", "VerifiedFiles"));
                        unverifiedFiles += ToInt(GetValue(row, "UnVarifiedFiles", "UnVerifiedFiles"));
                        totalCost += ToDecimal(GetValue(row, "Total Cost", "CalculatedCost", "TotalCost"));
                    }
                }

                return ApiResponse.Ok(new
                {
                    Summary = new
                    {
                        VendorCode = vendorCode,
                        NoOfProjects = table == null ? 0 : table.Rows.Count,
                        TotalFiles = totalFiles,
                        VerifiedFiles = verifiedFiles,
                        UnverifiedFiles = unverifiedFiles,
                        TotalCost = totalCost,
                        Status = status ?? string.Empty
                    },
                    Rows = rows
                });
            }
            catch (Exception ex)
            {
                return ApiResponse.Fail(ex.Message);
            }
        }

        private static object GetValue(DataRow row, params string[] names)
        {
            if (row == null || row.Table == null || names == null)
                return null;

            foreach (string name in names)
            {
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value)
                    return row[name];
            }
            return null;
        }

        private static int ToInt(object value)
        {
            int result;
            return value != null && int.TryParse(Convert.ToString(value), out result) ? result : 0;
        }

        private static decimal ToDecimal(object value)
        {
            decimal result;
            return value != null && decimal.TryParse(Convert.ToString(value), out result) ? result : 0;
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null)
                return rows;

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

            public static ApiResponse Ok(object data)
            {
                return new ApiResponse { Success = true, Message = string.Empty, Data = data };
            }

            public static ApiResponse Fail(string message)
            {
                return new ApiResponse { Success = false, Message = message, Data = null };
            }
        }
    }
}