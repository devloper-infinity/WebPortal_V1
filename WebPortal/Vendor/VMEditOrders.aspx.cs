using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Vendor
{
    public partial class VMEditOrders : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public class OrderDetailsDto
        {
            public string ProjectNumber { get; set; }
            public string OrderNo { get; set; }
            public string OrderDate { get; set; }
            public string Process { get; set; }
            public string VM { get; set; }
            public string Vendor { get; set; }
            public bool HasInputFile { get; set; }
            public string InputFileName { get; set; }
        }

        public class VendorDto
        {
            public string EmployeeID { get; set; }
            public string FullName { get; set; }
        }

        public class CompleteOrderRequest
        {
            public string OrderId { get; set; }
            public string OrderNo { get; set; }
            public string ProjectNumber { get; set; }
            public string OrderDate { get; set; }
            public string Process { get; set; }
            public string VendorName { get; set; }
            public string Remark { get; set; }
            public string FileName { get; set; }
            public string FileBase64 { get; set; }
        }

        public class ChangeStatusRequest
        {
            public string ProjectNumber { get; set; }
            public string OrderNumber { get; set; }
            public string OrderDate { get; set; }
            public string Process { get; set; }
            public string VM { get; set; }
            public string CurrentVendor { get; set; }
            public string NewVendorId { get; set; }
            public string NewVendorName { get; set; }
            public string Remark { get; set; }
        }

        public class ApiResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public string FileName { get; set; }
            public string ContentType { get; set; }
            public string FileBase64 { get; set; }

            public static ApiResult Ok(string message) { return new ApiResult { Success = true, Message = message }; }
            public static ApiResult Fail(string message) { return new ApiResult { Success = false, Message = message }; }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static OrderDetailsDto GetOrderDetails(string orderId)
        {
            if (string.IsNullOrWhiteSpace(orderId)) return null;
            DataTable dt = new bllVendors().GetOrderByID_VM_Popup(int.Parse(orderId));
            if (dt == null || dt.Rows.Count == 0) return null;

            DataRow row = dt.Rows[0];
            string inputPath = GetColumnValue(row, "UploadedFile", "InputFile", "FilePath", "Attachment");
            return new OrderDetailsDto
            {
                ProjectNumber = GetColumnValue(row, "ProjectNumber"),
                OrderNo = GetColumnValue(row, "OrderNo"),
                OrderDate = GetColumnValue(row, "Orderdate", "OrderDate"),
                Process = GetColumnValue(row, "Process"),
                VM = GetColumnValue(row, "VM"),
                Vendor = GetColumnValue(row, "Abstractor", "Vendor"),
                HasInputFile = !string.IsNullOrWhiteSpace(inputPath),
                InputFileName = string.IsNullOrWhiteSpace(inputPath) ? string.Empty : Path.GetFileName(inputPath)
            };
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<VendorDto> GetVendors()
        {
            DataTable dt = new bllVendors().BindChangeOrderStatus("Vendor");
            List<VendorDto> result = new List<VendorDto>();
            if (dt == null) return result;
            foreach (DataRow row in dt.Rows)
            {
                result.Add(new VendorDto
                {
                    EmployeeID = Convert.ToString(row["EmployeeID"]),
                    FullName = Convert.ToString(row["FullName"])
                });
            }
            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResult GetInputFile(string orderId)
        {
            try
            {
                DataTable dt = new bllVendors().GetOrderByID_VM(int.Parse(orderId));
                if (dt == null || dt.Rows.Count == 0) return ApiResult.Fail("Order details were not found.");

                string path = GetColumnValue(dt.Rows[0], "UploadedFile", "InputFile", "FilePath", "Attachment");
                if (string.IsNullOrWhiteSpace(path)) return ApiResult.Fail("Input file is not available.");

                string physicalPath = path;
                if (path.StartsWith("~") || path.StartsWith("/"))
                    physicalPath = HttpContext.Current.Server.MapPath(path.Replace("\\", "/"));

                if (!File.Exists(physicalPath)) return ApiResult.Fail("Input file was not found on the server.");
                return new ApiResult
                {
                    Success = true,
                    Message = "File prepared successfully.",
                    FileName = Path.GetFileName(physicalPath),
                    ContentType = MimeMapping.GetMimeMapping(physicalPath),
                    FileBase64 = Convert.ToBase64String(File.ReadAllBytes(physicalPath))
                };
            }
            catch (Exception ex) { return ApiResult.Fail("Unable to download input file. " + ex.Message); }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResult CompleteOrder(CompleteOrderRequest request)
        {
            if (request == null) return ApiResult.Fail("Invalid request.");
            try
            {
                if (string.IsNullOrWhiteSpace(request.OrderNo)) return ApiResult.Fail("Order number is required.");
                if (string.IsNullOrWhiteSpace(request.FileName) || string.IsNullOrWhiteSpace(request.FileBase64))
                    return ApiResult.Fail("Please select the completed file.");
                if (Path.GetFileName(request.FileName).IndexOf(request.OrderNo, StringComparison.OrdinalIgnoreCase) < 0)
                    return ApiResult.Fail("Order number and attachment filename must match.");

                int addedBy = Convert.ToInt32(HttpContext.Current.User.Identity.Name);
                byte[] file = Convert.FromBase64String(request.FileBase64);
                string safeFileName = Path.GetFileName(request.FileName);
                string folder = HttpContext.Current.Server.MapPath("~/Vendor/VM/" + DateTime.Now.ToString("dd-MMM-yyyy") + "/" + SafeName(request.OrderNo) + "/");
                Directory.CreateDirectory(folder);
                File.WriteAllBytes(Path.Combine(folder, safeFileName), file);

                bllVendors tracking = new bllVendors();
                Hashtable status = new Hashtable();
                status["OrderID"] = request.OrderNo;
                status["Remark"] = request.Remark ?? string.Empty;
                status["AddedBy"] = addedBy;

                int statusResult = request.ProjectNumber == "736-002"
                    ? UpdateTaskStatusDateForAbstractor(request.OrderId, request.Remark, addedBy)
                    : tracking.UpdateTaskStatusDateForAbstractor(status);
                if (statusResult <= 0) return ApiResult.Fail("Unable to update the order status.");

                Hashtable fileUpdate = new Hashtable();
                fileUpdate["OrderID"] = request.OrderNo;
                fileUpdate["CompleteFile"] = file;
                if (tracking.UpdateTaskStatusAbstractorFile(fileUpdate, file.Length) <= 0)
                    return ApiResult.Fail("Unable to save the completed file.");

                int completeResult = request.ProjectNumber == "736-002"
                    ? CompleteAllocateOrderToVendorInTrackingSheet(request.ProjectNumber, request.OrderNo, request.OrderDate, addedBy, request.Process)
                    : tracking.CompleteAllocateOrderToVendorInTrackingSheet(request.ProjectNumber, request.OrderNo, request.OrderDate, addedBy);
                if (completeResult <= 0) return ApiResult.Fail("Unable to complete the order in the tracking sheet.");

                Hashtable attachment = new Hashtable();
                attachment["ProjectNumber"] = request.ProjectNumber;
                attachment["Process"] = request.Process;
                attachment["OrderNumber"] = request.OrderNo;
                attachment["OrderDate"] = request.OrderDate;
                attachment["UserName"] = request.VendorName;
                attachment["FileExtension"] = Path.GetExtension(safeFileName);
                attachment["Remark"] = request.Remark ?? string.Empty;
                attachment["File"] = file;
                attachment["AddedBy"] = addedBy;

                if (tracking.InsertFileForOrder(attachment, file.Length) <= 0)
                    return ApiResult.Fail("Order was completed, but the attachment entry could not be saved.");

                return ApiResult.Ok("Order completed successfully.");
            }
            catch (Exception ex) { return ApiResult.Fail("Unable to complete the order. " + ex.Message); }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResult ChangeOrderStatus(ChangeStatusRequest request)
        {
            if (request == null) return ApiResult.Fail("Invalid request.");
            if (string.IsNullOrWhiteSpace(request.NewVendorId)) return ApiResult.Fail("Please select the new vendor.");
            try
            {
                int addedBy = Convert.ToInt32(HttpContext.Current.User.Identity.Name);
                bllVendors tracking = new bllVendors();
                Hashtable values = new Hashtable();
                values["ProjectNumber"] = request.ProjectNumber;
                values["OrderNumber"] = request.OrderNumber;
                values["TaskAssignIdAbs"] = request.NewVendorId;
                values["Remark"] = request.Remark ?? string.Empty;
                values["AddedBy"] = addedBy;

                int inserted = tracking.InsertChangeOrderStatus(values);
                if (inserted <= 0) return ApiResult.Fail("Unable to change the order status.");

                values["OrderDate"] = request.OrderDate;
                values["Process"] = request.Process;
                values["VM"] = request.VM;
                values["Vendor"] = request.CurrentVendor;
                values["NewVendor"] = request.NewVendorName;

                int completed = tracking.CompleteAllocateOrderToVendorInTrackingSheet(request.ProjectNumber, request.OrderNumber, request.OrderDate, addedBy);
                if (completed <= 0) return ApiResult.Fail("Status was saved, but the existing allocation could not be completed.");

                //new bll_SendMail().VendorChangeOrderStatus(values);
                return ApiResult.Ok("Order status updated successfully.");
            }
            catch (Exception ex) { return ApiResult.Fail("Unable to update order status. " + ex.Message); }
        }

        private static int CompleteAllocateOrderToVendorInTrackingSheet(string project, string orderNo, string orderDate, int updatedBy, string process)
        {
            using (SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "WBT_usp_CompleteAllocateOrderToVendorInTrackingSheet_1"))
            {
                SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", SqlDbType.NVarChar, 200, ParameterDirection.Input, project);
                SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", SqlDbType.NVarChar, 4000, ParameterDirection.Input, orderNo);
                SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", SqlDbType.NVarChar, 200, ParameterDirection.Input, orderDate);
                SQLHelper.AddParamToSQLCmd(cmd, "@UpdatedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, updatedBy);
                SQLHelper.AddParamToSQLCmd(cmd, "@Process", SqlDbType.NVarChar, 4000, ParameterDirection.Input, process);
                SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
                SQLHelper.ExecuteNonQueryCmd(cmd);
                return Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            }
        }

        private static int UpdateTaskStatusDateForAbstractor(string orderId, string remark, int addedBy)
        {
            using (SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_Vendor_UpdateTaskStatusDateForAbstractor_1"))
            {
                SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", SqlDbType.NVarChar, 4000, ParameterDirection.Input, orderId);
                SQLHelper.AddParamToSQLCmd(cmd, "@Remark", SqlDbType.NVarChar, 4000, ParameterDirection.Input, remark ?? string.Empty);
                SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.Int, 0, ParameterDirection.Input, addedBy);
                SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
                SQLHelper.ExecuteNonQueryCmd(cmd);
                return Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            }
        }

        private static string GetColumnValue(DataRow row, params string[] names)
        {
            foreach (string name in names)
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value) return Convert.ToString(row[name]);
            return string.Empty;
        }

        private static string SafeName(string value)
        {
            foreach (char c in Path.GetInvalidFileNameChars()) value = value.Replace(c, '_');
            return value;
        }
    }
}