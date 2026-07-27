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
    public partial class ProjectWiseFileList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetCounts(
    string vendorCode,
    int invoiceId,
    string projectNumber)
        {
            try
            {
                bllVendors bal = new bllVendors();

                DataTable countTable =
                    bal.GetVerifyUnVerifyCount(
                        vendorCode,
                        invoiceId,
                        projectNumber);

                int verify = 0;
                int unverify = 0;

                if (countTable != null && countTable.Rows.Count > 0)
                {
                    DataRow row = countTable.Rows[0];

                    verify = ToInt(GetValueAny(
                        row,
                        "VerifyCount",
                        "VerifiedCount",
                        "VarifiedFiles",
                        "VerifiedFiles"));

                    unverify = ToInt(GetValueAny(
                        row,
                        "UnVerifyCount",
                        "UnverifiedCount",
                        "UnVarifiedFiles",
                        "UnVerifiedFiles"));
                }

                int totalFiles = verify + unverify;

                decimal calculatedCost = 0;
                int billedFiles = 0;
                int unbilledFiles = 0;
                string status = string.Empty;

                DataTable projectTable =
                    bal.GetVendorWiseProjectDetails(
                        vendorCode,
                        invoiceId);

                if (projectTable != null && projectTable.Rows.Count > 0)
                {
                    DataRow projectRow = projectTable.AsEnumerable()
                        .FirstOrDefault(r =>
                            string.Equals(
                                Convert.ToString(GetValueAny(
                                    r,
                                    "ProjectNumber",
                                    "projectnumber",
                                    "ProjectNo")),
                                projectNumber,
                                StringComparison.OrdinalIgnoreCase));

                    if (projectRow != null)
                    {
                        calculatedCost = ToDecimal(GetValueAny(
                            projectRow,
                            "Total Cost",
                            "TotalCost",
                            "CalculatedCost"));

                        billedFiles = ToInt(GetValueAny(
                            projectRow,
                            "BilledFiles",
                            "BiledFiles"));

                        unbilledFiles = ToInt(GetValueAny(
                            projectRow,
                            "UnBilledFiles",
                            "UnBiledFiles"));

                        status = Convert.ToString(GetValueAny(
                            projectRow,
                            "Status",
                            "ProjectStatus"));
                    }
                }

                return ApiResponse.Ok(new
                {
                    VendorCode = vendorCode,
                    ProjectNumber = projectNumber,

                    TotalFiles = totalFiles,
                    CompletedFiles = verify,
                    PendingFiles = unverify,

                    VerifyCount = verify,
                    UnVerifyCount = unverify,

                    CalculatedCost = calculatedCost,
                    BilledFiles = billedFiles,
                    UnBilledFiles = unbilledFiles,
                    Status = status
                });
            }
            catch (Exception ex)
            {
                return ApiResponse.Fail(ex.Message);
            }
        }

        private static object GetValueAny(
    DataRow row,
    params string[] columns)
        {
            if (row == null || row.Table == null || columns == null)
                return null;

            foreach (string column in columns)
            {
                if (row.Table.Columns.Contains(column) &&
                    row[column] != DBNull.Value)
                {
                    return row[column];
                }
            }

            return null;
        }

        private static decimal ToDecimal(object value)
        {
            decimal result;

            return value != null &&
                   decimal.TryParse(
                       Convert.ToString(value),
                       out result)
                ? result
                : 0;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetFiles(string vendorCode, int invoiceId, string projectNumber, string fileType)
        {
            try
            {
                string type = string.Equals(fileType, "Verify", StringComparison.OrdinalIgnoreCase) ? "Verify" : "UnVerify";
                DataTable table = new bllVendors().GetVerifyUnVerifyFiles(vendorCode, invoiceId, projectNumber, type);
                return ApiResponse.Ok(ToRows(table));
            }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse CompleteProject(string vendorCode, int invoiceId, string projectNumber)
        {
            try
            {
                string userId = Convert.ToString(HttpContext.Current.User.Identity.Name);
                DataTable table = new bllVendors().CompleteInCompleteFile(vendorCode, invoiceId, projectNumber, "Complete", int.Parse(userId));
                return ApiResponse.Ok(ToRows(table), "Project files completed successfully.");
            }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        private static object GetValue(DataRow row, string column)
        {
            return row.Table.Columns.Contains(column) && row[column] != DBNull.Value ? row[column] : null;
        }
        private static int ToInt(object value)
        {
            int result; return value != null && int.TryParse(Convert.ToString(value), out result) ? result : 0;
        }
        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            var rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow row in table.Rows)
            {
                var item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
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