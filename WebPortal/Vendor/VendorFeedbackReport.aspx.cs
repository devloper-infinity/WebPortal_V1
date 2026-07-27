using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Vendor
{
    public partial class VendorFeedbackReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.Equals(Request.QueryString["action"], "import", StringComparison.OrdinalIgnoreCase))
            {
                ProcessImportRequest();
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetProjects()
        {
            try
            {
                DataTable table = new bllMaster().GetAllProjectByUserRights(HttpContext.Current.User.Identity.Name);
                return ApiResponse.Ok(ToRows(table));
            }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetVendorDetails(string projectNumber, string fromDate, string toDate)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(projectNumber) || projectNumber == "Select")
                    return ApiResponse.Fail("Please select project.");

                SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetProjectWiseVendorBillingDetails");
                SQLHelper.AddParamToSQLCmd(command, "@ProjectNumber", SqlDbType.NVarChar, 4000, ParameterDirection.Input, projectNumber);
                SQLHelper.AddParamToSQLCmd(command, "@FromDate", SqlDbType.NVarChar, 100, ParameterDirection.Input, fromDate ?? string.Empty);
                SQLHelper.AddParamToSQLCmd(command, "@ToDate", SqlDbType.NVarChar, 100, ParameterDirection.Input, toDate ?? string.Empty);
                DataTable table = SQLHelper.ExecuteDataTableCmd_WBT(command);
                command.Dispose();
                return ApiResponse.Ok(ToRows(table));
            }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse UpdateVendorDetail(int compareId, string projectNumber, string vendorCode, string orderDate,
            string fileName, int records, int totalChars, int charsAfterPenalty, double accuracy)
        {
            try
            {
                if (compareId <= 0) return ApiResponse.Fail("Invalid Compare ID.");
                SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UpdateProjectWiseVendorBillingDetails");
                SQLHelper.AddParamToSQLCmd(command, "@Compareid", SqlDbType.BigInt, 0, ParameterDirection.Input, compareId);
                SQLHelper.AddParamToSQLCmd(command, "@ProjectNo", SqlDbType.NVarChar, 4000, ParameterDirection.Input, projectNumber ?? string.Empty);
                SQLHelper.AddParamToSQLCmd(command, "@VenCode", SqlDbType.NVarChar, 4000, ParameterDirection.Input, vendorCode ?? string.Empty);
                SQLHelper.AddParamToSQLCmd(command, "@Orderdate", SqlDbType.NVarChar, 100, ParameterDirection.Input, orderDate ?? string.Empty);
                SQLHelper.AddParamToSQLCmd(command, "@FileName", SqlDbType.NVarChar, 4000, ParameterDirection.Input, fileName ?? string.Empty);
                SQLHelper.AddParamToSQLCmd(command, "@Record", SqlDbType.BigInt, 0, ParameterDirection.Input, records);
                SQLHelper.AddParamToSQLCmd(command, "@TotalChar", SqlDbType.BigInt, 0, ParameterDirection.Input, totalChars);
                SQLHelper.AddParamToSQLCmd(command, "@CharAftPen", SqlDbType.BigInt, 0, ParameterDirection.Input, charsAfterPenalty);
                SQLHelper.AddParamToSQLCmd(command, "@Accuracy", SqlDbType.Float, 0, ParameterDirection.Input, accuracy);
                SQLHelper.AddParamToSQLCmd(command, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
                SQLHelper.ExecuteDataTableCmd_WBT(command);
                int result = command.Parameters["@ReturnValue"].Value == DBNull.Value ? 0 : Convert.ToInt32(command.Parameters["@ReturnValue"].Value);
                command.Dispose();
                return result > 0 ? ApiResponse.Ok(null, "Record updated successfully.") : ApiResponse.Fail("Record was not updated.");
            }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        private void ProcessImportRequest()
        {
            Response.Clear();
            Response.ContentType = "application/json";
            ApiResponse response;
            string savedFile = null;
            try
            {
                HttpPostedFile file = Request.Files["file"];
                string selectedProject = Convert.ToString(Request.Form["projectNumber"]);
                if (file == null || file.ContentLength == 0) throw new InvalidOperationException("Please select Excel file.");
                string extension = Path.GetExtension(file.FileName).ToLowerInvariant();
                if (extension != ".xls" && extension != ".xlsx") throw new InvalidOperationException("Only .xls and .xlsx files are allowed.");

                string folder = Server.MapPath("~/VendorBilling/ImportExcel/");
                if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                savedFile = Path.Combine(folder, Guid.NewGuid().ToString("N") + extension);
                file.SaveAs(savedFile);

                DataTable source = ReadExcel(savedFile, extension);
                ValidateImportColumns(source);
                DataTable added = source.Clone();
                DataTable rejected = source.Clone();
                rejected.Columns.Add("Import Error", typeof(string));

                foreach (DataRow sourceRow in source.Rows)
                {
                    try
                    {
                        string projectNumber = Text(sourceRow, "Project #");
                        string jobType = Text(sourceRow, "Job type");
                        string orderNo = Text(sourceRow, "Order #");
                        string deCode = Text(sourceRow, "DE code");
                        string imageNo = Text(sourceRow, "Image #");
                        string fieldName = Text(sourceRow, "Field Name");
                        string error = Text(sourceRow, "Error");
                        string shouldBe = Text(sourceRow, "Should be");
                        string errorType = Text(sourceRow, "Error type");
                        int records = SafeInt(Text(sourceRow, "Records"));
                        DateTime orderDate;

                        if (string.IsNullOrWhiteSpace(projectNumber)) projectNumber = selectedProject;
                        if (string.IsNullOrWhiteSpace(projectNumber) || string.IsNullOrWhiteSpace(orderNo)) throw new InvalidOperationException("Project # and Order # are required.");
                        if (!DateTime.TryParse(Convert.ToString(sourceRow["Order Date"]), out orderDate)) throw new InvalidOperationException("Invalid Order Date.");
                        if (deCode.IndexOf("PIS", StringComparison.OrdinalIgnoreCase) >= 0 || deCode.IndexOf("SOB", StringComparison.OrdinalIgnoreCase) >= 0 || deCode.IndexOf("PKR", StringComparison.OrdinalIgnoreCase) >= 0 || deCode.IndexOf("DGK", StringComparison.OrdinalIgnoreCase) >= 0)
                            throw new InvalidOperationException("DE Code contains an in-house user code.");

                        int compareId = InsertFileDetail(projectNumber, jobType, orderNo, orderDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture), deCode, records);
                        if (compareId <= 0) throw new InvalidOperationException("File detail was not inserted.");
                        if (!string.Equals(errorType, "No Error", StringComparison.OrdinalIgnoreCase))
                            InsertErrorDetail(compareId, imageNo, deCode, fieldName, error, shouldBe, errorType);
                        added.ImportRow(sourceRow);
                    }
                    catch (Exception rowEx)
                    {
                        DataRow rejectedRow = rejected.NewRow();
                        for (int i = 0; i < source.Columns.Count; i++) rejectedRow[i] = sourceRow[i];
                        rejectedRow["Import Error"] = rowEx.Message;
                        rejected.Rows.Add(rejectedRow);
                    }
                }

                response = ApiResponse.Ok(new
                {
                    TotalCount = source.Rows.Count,
                    AddedCount = added.Rows.Count,
                    RejectedCount = rejected.Rows.Count,
                    AddedRows = ToRows(added),
                    RejectedRows = ToRows(rejected)
                }, "Import completed.");
            }
            catch (Exception ex) { response = ApiResponse.Fail(ex.Message); }
            finally
            {
                try { if (!string.IsNullOrEmpty(savedFile) && File.Exists(savedFile)) File.Delete(savedFile); } catch { }
            }
            Response.Write(new JavaScriptSerializer().Serialize(response));
            Response.End();
        }

        private static DataTable ReadExcel(string path, string extension)
        {
            string connectionString = extension == ".xlsx"
                ? "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Extended Properties=\"Excel 12.0 Xml;HDR=YES;IMEX=1\";"
                : "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + path + ";Extended Properties=\"Excel 8.0;HDR=YES;IMEX=1\";";
            using (OleDbConnection connection = new OleDbConnection(connectionString))
            {
                connection.Open();
                DataTable sheets = connection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                if (sheets == null || sheets.Rows.Count == 0) throw new InvalidOperationException("Excel sheet was not found.");
                string sheetName = Convert.ToString(sheets.Rows[0]["TABLE_NAME"]);
                using (OleDbDataAdapter adapter = new OleDbDataAdapter("SELECT * FROM [" + sheetName.Replace("'", "''") + "]", connection))
                {
                    DataTable table = new DataTable();
                    adapter.Fill(table);
                    return table;
                }
            }
        }

        private static void ValidateImportColumns(DataTable table)
        {
            string[] required = { "Project #", "Job type", "Order Date", "Order #", "DE code", "Image #", "Field Name", "Error", "Should be", "Error type", "Records" };
            foreach (string name in required) if (!table.Columns.Contains(name)) throw new InvalidOperationException("Invalid Excel format. Missing column: " + name);
        }

        private static int InsertFileDetail(string projectNumber, string jobType, string orderNo, string orderDate, string vendorCode, int records)
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand("InfinityWBT_ErroGeneration_InsertFileDetail", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@ProjectNo", projectNumber);
                command.Parameters.AddWithValue("@JobType", jobType ?? string.Empty);
                command.Parameters.AddWithValue("@ShipmentNo", orderNo);
                command.Parameters.AddWithValue("@OrderDate", orderDate);
                command.Parameters.AddWithValue("@WorkContentNo", orderNo);
                command.Parameters.AddWithValue("@FileName", orderNo);
                command.Parameters.AddWithValue("@TotalChars", 0);
                command.Parameters.AddWithValue("@CharsAfterPenalty", 0);
                command.Parameters.AddWithValue("@Accuracy", 0);
                command.Parameters.AddWithValue("@Records", records);
                command.Parameters.AddWithValue("@VendorCode", vendorCode ?? string.Empty);
                command.Parameters.AddWithValue("@FileStatus", "Completed");
                command.Parameters.AddWithValue("@OwnerId", 1);
                command.Parameters.AddWithValue("@ISP", 0);
                command.Parameters.AddWithValue("@MRW", 0);
                command.Parameters.AddWithValue("@MRD", 0);
                command.Parameters.AddWithValue("@MRL", 0);
                command.Parameters.AddWithValue("@AddedBy", HttpContext.Current.User.Identity.Name);
                command.Parameters.AddWithValue("@IpAddress", HttpContext.Current.Request.UserHostAddress ?? string.Empty);
                command.Parameters.AddWithValue("@Origin", "Error Gen");
                command.Parameters.AddWithValue("@YqaCode", string.Empty);
                connection.Open();
                command.ExecuteNonQuery();
                using (SqlCommand idCommand = new SqlCommand("SELECT MAX(CompareID) FROM dbo.InfinityWBT_Billing_CompareErrors WHERE ProjectNumber=@ProjectNumber AND FileName=@FileName AND VendorCode=@VendorCode", connection))
                {
                    idCommand.Parameters.Add("@ProjectNumber", SqlDbType.NVarChar, 4000).Value = projectNumber;
                    idCommand.Parameters.Add("@FileName", SqlDbType.NVarChar, 4000).Value = orderNo;
                    idCommand.Parameters.Add("@VendorCode", SqlDbType.NVarChar, 4000).Value = vendorCode ?? string.Empty;
                    object value = idCommand.ExecuteScalar();
                    return value == null || value == DBNull.Value ? 0 : Convert.ToInt32(value);
                }
            }
        }

        private static void InsertErrorDetail(int compareId, string imageNo, string vendorCode, string fieldName, string error, string shouldBe, string mistake)
        {
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand("InfinityWBT_ErroGeneration_InsertErrorDetail", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@CompareId", compareId);
                command.Parameters.AddWithValue("@ImageNo", imageNo ?? string.Empty);
                command.Parameters.AddWithValue("@VendorCode", vendorCode ?? string.Empty);
                command.Parameters.AddWithValue("@FieldName", fieldName ?? string.Empty);
                command.Parameters.AddWithValue("@Error", error ?? string.Empty);
                command.Parameters.AddWithValue("@ShouldBe", shouldBe ?? string.Empty);
                command.Parameters.AddWithValue("@Mistake", mistake ?? string.Empty);
                command.Parameters.AddWithValue("@AddedBy", HttpContext.Current.User.Identity.Name);
                command.Parameters.AddWithValue("@Status", "Accepted");
                command.Parameters.AddWithValue("@IpAddress", HttpContext.Current.Request.UserHostAddress ?? string.Empty);
                command.Parameters.AddWithValue("@DE1OPT", string.Empty);
                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        private static string Text(DataRow row, string column) { return row.Table.Columns.Contains(column) ? Convert.ToString(row[column]).Trim() : string.Empty; }
        private static int SafeInt(string value) { int result; return int.TryParse(value, out result) ? result : 0; }
        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow row in table.Rows)
            {
                Dictionary<string, object> item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns) item[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
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