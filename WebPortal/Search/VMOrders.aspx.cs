using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Search
{
    public partial class VMOrders : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string action = Request.QueryString["action"];
            if (string.IsNullOrWhiteSpace(action)) return;

            try
            {
                if (action.Equals("download", StringComparison.OrdinalIgnoreCase))
                    DownloadAttachment(Request.QueryString["path"]);
                else if (action.Equals("allocate", StringComparison.OrdinalIgnoreCase))
                    WriteJson(AllocateOrder());
                else if (action.Equals("import", StringComparison.OrdinalIgnoreCase))
                    WriteJson(ImportOrders());
                else if (action.Equals("completeQueue", StringComparison.OrdinalIgnoreCase))
                    WriteJson(CompleteQueueProcess());
                else
                    WriteJson(Result(false, "Invalid VM order action."));
            }
            catch (Exception ex)
            {
                WriteJson(Result(false, ex.Message));
            }
        }

        private void DownloadAttachment(string relativePath)
        {
            if (string.IsNullOrWhiteSpace(relativePath))
                throw new InvalidOperationException("Attachment path is missing.");

            string normalized = relativePath.Replace('/', '\\');
            if (!normalized.StartsWith("~\\OSTAttachment\\", StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException("Invalid attachment path.");

            string root = Path.GetFullPath(Server.MapPath("~/OSTAttachment"));
            string filePath = Path.GetFullPath(Server.MapPath(normalized));
            if (!filePath.StartsWith(root + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase) ||
                !File.Exists(filePath))
                throw new FileNotFoundException("Attachment was not found.");

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition",
                "attachment; filename=\"" + Path.GetFileName(filePath).Replace("\"", string.Empty) + "\"");
            Response.TransmitFile(filePath);
            Response.Flush();
            Context.ApplicationInstance.CompleteRequest();
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (!string.IsNullOrWhiteSpace(Request.QueryString["action"])) return;
            base.Render(writer);
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetBootstrap()
        {
            int userId = CurrentUserId();
            bllOST ost = new bllOST();
            return new
            {
                CurrentUserId = userId,
                IsPM = new bllVendors().CheckIfPMVM(userId) == 1,
                Projects = Rows(ost.GetAllProject(userId)),
                Abstractors = Rows(ost.GetAllAbsRegistration()),
                AllocationOrders = Rows(ost.ViewSearchOrderForVM(userId))
            };
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetAllocationContext(int orderId)
        {
            if (orderId <= 0) throw new ArgumentException("Select a valid order.");
            bllOST ost = new bllOST();

            DataTable order = ost.GetAbstractorCoverageDetails(orderId);

            if (order == null || order.Rows.Count == 0) throw new InvalidOperationException("The selected order was not found.");

            string project = Value(order.Rows[0], "ProjectNumber");
            string product = Value(order.Rows[0], "ProductType");
            return new
            {
                Order = First(order),
                Documents = Rows(ost.GetAllDocAndProductRelatedToProject(project, product))
            };
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetAbstractorCoverage(int orderId)
        {
            if (orderId <= 0) throw new ArgumentException("Select a valid order.");
            return Rows(new bllOST().GetAbstractorCoverageDetails(orderId));
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetQueueOrders(string fromDate, string toDate, string project, string view)
        {
            DateTime from = ParseDate(fromDate);
            DateTime to = ParseDate(toDate);
            if (from > to) throw new ArgumentException("From Date should be less than or equal to To Date.");

            int userId = CurrentUserId();
            bllVendors vendors = new bllVendors();
            bool isPm = vendors.CheckIfPMVM(userId) == 1;
            string selectedView = (view ?? string.Empty).Trim();
            DataTable table;

            if (selectedView.Equals("allProjects", StringComparison.OrdinalIgnoreCase))
            {
                if (!isPm) throw new InvalidOperationException("Only a VM Project Manager can view all projects.");
                table = GetAllProjectQueue();
            }
            else if (selectedView.Equals("all", StringComparison.OrdinalIgnoreCase))
            {
                if (!isPm) throw new InvalidOperationException("Only a VM Project Manager can view all orders.");
                if (string.IsNullOrWhiteSpace(project) || project.Equals("Select", StringComparison.OrdinalIgnoreCase))
                    throw new ArgumentException("Please select project.");
                table = vendors.GetAllInfinityOrderTraking_VM(
                    from.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                    to.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture), project);
            }
            else
            {
                Hashtable parameters = new Hashtable();
                parameters["FromDate"] = from.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                parameters["ToDate"] = to.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                parameters["ProjectNumber"] = string.IsNullOrWhiteSpace(project) ? "All" : project;
                parameters["UserId"] = userId;
                table = vendors.GetMyOrders_VM(parameters);
            }

            AddTaskAssignedId(table, vendors);
            return Rows(table);
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetQueueDetail(int orderId, string detailType)
        {
            if (orderId <= 0) throw new ArgumentException("Select a valid order.");
            bllVendors vendors = new bllVendors();
            DataTable table;
            switch ((detailType ?? string.Empty).Trim().ToLowerInvariant())
            {
                case "attachments": table = vendors.GetOrderDetailsProcesswise(orderId); break;
                case "checklist": table = vendors.BindOrderCheckList(orderId); break;
                case "history": table = vendors.GetAllOrderHistory(orderId); break;
                case "costing": table = vendors.GetAllorderCosing(orderId); break;
                case "feedback": table = vendors.BindOrderFeedback(orderId); break;
                case "tax": table = vendors.BindTaxDetails(orderId); break;
                default: throw new ArgumentException("Invalid order detail type.");
            }
            return Rows(table);
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetCommentData(int orderId)
        {
            bllVendors vendors = new bllVendors();
            DataTable order = vendors.GetOrderByID_VM(orderId);
            Dictionary<string, object> first = First(order);
            return new
            {
                OrderNo = Pick(first, "ClientOrderNo", "OrderNumber"),
                OrderDate = Pick(first, "OrderDate", "Orderdate"),
                VM = Pick(first, "VM", "VMName"),
                Abstractor = Pick(first, "Abstractor", "AbstractorName"),
                Comments = Rows(vendors.GetAllCommentOrderwise_VM(orderId))
            };
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> SaveComment(int orderId, string type, string comment)
        {
            if (orderId <= 0) throw new ArgumentException("Select a valid order.");
            if (string.IsNullOrWhiteSpace(comment)) throw new ArgumentException("Please enter comment.");
            Hashtable values = new Hashtable();
            values["OrderId"] = orderId;
            values["Type"] = string.IsNullOrWhiteSpace(type) ? "Connect With Abstractor" : type.Trim();
            values["Comment"] = comment.Trim();
            values["AddedBy"] = CurrentUserId();
            bllVendors vendors = new bllVendors();
            if (vendors.InsertFollowUp(values) <= 0) throw new InvalidOperationException("Comment was not saved.");
            return Rows(vendors.GetAllCommentOrderwise_VM(orderId));
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetQueueProcessContext(int orderId)
        {
            if (orderId <= 0) throw new ArgumentException("Select a valid order.");
            bllOST ost = new bllOST();
            DataTable current = ost.GetCurrentProcessOfUserPM(orderId);
            Dictionary<string, object> context = First(current);
            int processId = IntValue(context, "Processid", "ProcessId", "TaskProcessid");
            DataTable tasks = processId > 0 ? ost.GetOrdersOnProcess(orderId, processId) : new DataTable();
            return new { Context = context, Tasks = Rows(tasks) };
        }

        public class OrderDetailsDto
        {
            public string OrderId { get; set; }
            public string TaskId { get; set; }
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

            public static ApiResult Ok(string message)
            {
                return new ApiResult { Success = true, Message = message };
            }

            public static ApiResult Fail(string message)
            {
                return new ApiResult { Success = false, Message = message };
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static OrderDetailsDto GetOrderDetails(string orderId)
        {
            int parsedOrderId;
            if (!int.TryParse(orderId, out parsedOrderId) || parsedOrderId <= 0)
                return null;

            DataTable table = new bllOST().GetOrderByID_VM(parsedOrderId);
            if (table == null || table.Rows.Count == 0) return null;

            DataRow row = table.Rows[0];
            string inputPath = GetColumnValue(row, "UploadedFile", "InputFile", "FilePath", "Attachment");
            return new OrderDetailsDto
            {
                OrderId = orderId,
                TaskId = GetColumnValue(row, "VMTaskId", "TaskId"),
                ProjectNumber = GetColumnValue(row, "ProjectNumber"),
                OrderNo = GetColumnValue(row, "ClientOrderNo", "OrderNo"),
                OrderDate = GetColumnValue(row, "Orderdate", "OrderDate"),
                Process = GetColumnValue(row, "Process"),
                VM = GetColumnValue(row, "VM"),
                Vendor = GetColumnValue(row, "Abstractor", "Vendor"),
                HasInputFile = !string.IsNullOrWhiteSpace(inputPath),
                InputFileName = string.IsNullOrWhiteSpace(inputPath) ? string.Empty : Path.GetFileName(inputPath)
            };
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<VendorDto> GetVendors()
        {
            DataTable table = new bllVendors().BindChangeOrderStatus("Vendor");
            List<VendorDto> result = new List<VendorDto>();
            if (table == null) return result;

            foreach (DataRow row in table.Rows)
            {
                result.Add(new VendorDto
                {
                    EmployeeID = Convert.ToString(row["EmployeeID"]),
                    FullName = Convert.ToString(row["FullName"])
                });
            }
            return result;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResult GetInputFile(string orderId)
        {
            int parsedOrderId;
            if (!int.TryParse(orderId, out parsedOrderId) || parsedOrderId <= 0)
                return ApiResult.Fail("Select a valid order.");

            try
            {
                DataTable table = new bllVendors().GetOrderByID_VM(parsedOrderId);
                if (table == null || table.Rows.Count == 0)
                    return ApiResult.Fail("Order details were not found.");

                string path = GetColumnValue(table.Rows[0], "UploadedFile", "InputFile", "FilePath", "Attachment");
                if (string.IsNullOrWhiteSpace(path))
                    return ApiResult.Fail("Input file is not available.");

                string physicalPath = path;
                if (path.StartsWith("~") || path.StartsWith("/"))
                    physicalPath = HttpContext.Current.Server.MapPath(path.Replace("\\", "/"));

                if (!File.Exists(physicalPath))
                    return ApiResult.Fail("Input file was not found on the server.");

                return new ApiResult
                {
                    Success = true,
                    Message = "File prepared successfully.",
                    FileName = Path.GetFileName(physicalPath),
                    ContentType = MimeMapping.GetMimeMapping(physicalPath),
                    FileBase64 = Convert.ToBase64String(File.ReadAllBytes(physicalPath))
                };
            }
            catch (Exception ex)
            {
                return ApiResult.Fail("Unable to download input file. " + ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResult CompleteOrder(CompleteOrderRequest request)
        {
            if (request == null) return ApiResult.Fail("Invalid request.");

            try
            {
                if (string.IsNullOrWhiteSpace(request.OrderNo))
                    return ApiResult.Fail("Order number is required.");
                if (string.IsNullOrWhiteSpace(request.FileName) || string.IsNullOrWhiteSpace(request.FileBase64))
                    return ApiResult.Fail("Please select the completed file.");
                if (Path.GetFileName(request.FileName).IndexOf(request.OrderNo, StringComparison.OrdinalIgnoreCase) < 0)
                    return ApiResult.Fail("Order number and attachment filename must match.");

                int addedBy = CurrentUserId();
                byte[] file = Convert.FromBase64String(request.FileBase64);
                string safeFileName = Path.GetFileName(request.FileName);
                string folder = HttpContext.Current.Server.MapPath(
                    "~/Vendor/VM/" + DateTime.Now.ToString("dd-MMM-yyyy") + "/" + SafeName(request.OrderNo) + "/");
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
                if (statusResult <= 0)
                    return ApiResult.Fail("Unable to update the order status.");

                Hashtable fileUpdate = new Hashtable();
                fileUpdate["OrderID"] = request.OrderNo;
                fileUpdate["CompleteFile"] = file;
                if (tracking.UpdateTaskStatusAbstractorFile(fileUpdate, file.Length) <= 0)
                    return ApiResult.Fail("Unable to save the completed file.");

                int completeResult = request.ProjectNumber == "736-002"
                    ? CompleteAllocateOrderToVendorInTrackingSheet(
                        request.ProjectNumber, request.OrderNo, request.OrderDate, addedBy, request.Process)
                    : tracking.CompleteAllocateOrderToVendorInTrackingSheet(
                        request.ProjectNumber, request.OrderNo, request.OrderDate, addedBy);
                if (completeResult <= 0)
                    return ApiResult.Fail("Unable to complete the order in the tracking sheet.");

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
            catch (Exception ex)
            {
                return ApiResult.Fail("Unable to complete the order. " + ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResult ChangeOrderStatus(ChangeStatusRequest request)
        {
            if (request == null) return ApiResult.Fail("Invalid request.");
            if (string.IsNullOrWhiteSpace(request.NewVendorId))
                return ApiResult.Fail("Please select the new vendor.");

            try
            {
                int addedBy = CurrentUserId();
                bllVendors tracking = new bllVendors();
                Hashtable values = new Hashtable();
                values["ProjectNumber"] = request.ProjectNumber;
                values["OrderNumber"] = request.OrderNumber;
                values["TaskAssignIdAbs"] = request.NewVendorId;
                values["Remark"] = request.Remark ?? string.Empty;
                values["AddedBy"] = addedBy;

                int inserted = tracking.InsertChangeOrderStatus(values);
                if (inserted <= 0)
                    return ApiResult.Fail("Unable to change the order status.");

                values["OrderDate"] = request.OrderDate;
                values["Process"] = request.Process;
                values["VM"] = request.VM;
                values["Vendor"] = request.CurrentVendor;
                values["NewVendor"] = request.NewVendorName;

                int completed = tracking.CompleteAllocateOrderToVendorInTrackingSheet(
                    request.ProjectNumber, request.OrderNumber, request.OrderDate, addedBy);
                if (completed <= 0)
                    return ApiResult.Fail("Status was saved, but the existing allocation could not be completed.");

                return ApiResult.Ok("Order status updated successfully.");
            }
            catch (Exception ex)
            {
                return ApiResult.Fail("Unable to update order status. " + ex.Message);
            }
        }

        private static int CompleteAllocateOrderToVendorInTrackingSheet(
            string project, string orderNo, string orderDate, int updatedBy, string process)
        {
            using (SqlCommand command = SQLHelper.GetCommand(
                CommandType.StoredProcedure, "WBT_usp_CompleteAllocateOrderToVendorInTrackingSheet_1"))
            {
                SQLHelper.AddParamToSQLCmd(command, "@ProjectNumber", SqlDbType.NVarChar, 200,
                    ParameterDirection.Input, project);
                SQLHelper.AddParamToSQLCmd(command, "@OrderNumber", SqlDbType.NVarChar, 4000,
                    ParameterDirection.Input, orderNo);
                SQLHelper.AddParamToSQLCmd(command, "@OrderDate", SqlDbType.NVarChar, 200,
                    ParameterDirection.Input, orderDate);
                SQLHelper.AddParamToSQLCmd(command, "@UpdatedBy", SqlDbType.BigInt, 0,
                    ParameterDirection.Input, updatedBy);
                SQLHelper.AddParamToSQLCmd(command, "@Process", SqlDbType.NVarChar, 4000,
                    ParameterDirection.Input, process);
                SQLHelper.AddParamToSQLCmd(command, "@ReturnValue", SqlDbType.BigInt, 0,
                    ParameterDirection.ReturnValue, null);
                SQLHelper.ExecuteNonQueryCmd(command);
                return Convert.ToInt32(command.Parameters["@ReturnValue"].Value);
            }
        }

        private static int UpdateTaskStatusDateForAbstractor(string orderId, string remark, int addedBy)
        {
            using (SqlCommand command = SQLHelper.GetCommand(
                CommandType.StoredProcedure, "usp_Vendor_UpdateTaskStatusDateForAbstractor_1"))
            {
                SQLHelper.AddParamToSQLCmd(command, "@OrderID", SqlDbType.NVarChar, 4000,
                    ParameterDirection.Input, orderId);
                SQLHelper.AddParamToSQLCmd(command, "@Remark", SqlDbType.NVarChar, 4000,
                    ParameterDirection.Input, remark ?? string.Empty);
                SQLHelper.AddParamToSQLCmd(command, "@AddedBy", SqlDbType.Int, 0,
                    ParameterDirection.Input, addedBy);
                SQLHelper.AddParamToSQLCmd(command, "@ReturnValue", SqlDbType.BigInt, 0,
                    ParameterDirection.ReturnValue, null);
                SQLHelper.ExecuteNonQueryCmd(command);
                return Convert.ToInt32(command.Parameters["@ReturnValue"].Value);
            }
        }

        private static string GetColumnValue(DataRow row, params string[] names)
        {
            foreach (string name in names)
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value)
                    return Convert.ToString(row[name]);
            return string.Empty;
        }

        private static string SafeName(string value)
        {
            foreach (char character in Path.GetInvalidFileNameChars())
                value = value.Replace(character, '_');
            return value;
        }

        private VmResult AllocateOrder()
        {
            int orderId = FormInt("orderId");
            string mode = (Request.Form["mode"] ?? string.Empty).Trim();
            int addedBy = CurrentUserId();

            if (orderId <= 0)
                return Result(false, "Select a valid order.");

            if (mode != "Offline" && mode != "Partial")
                return Result(false, "Select an allocation mode.");

            bllOST ost = new bllOST();
            DataTable orderTable = ost.GetOrderByID_VM(orderId);

            if (orderTable.Rows.Count == 0)
                return Result(false, "The selected order was not found.");

            DataRow order = orderTable.Rows[0];
            string product = Value(order, "ProductType");
            string clientOrderNo = Value(order, "ClientOrderNo");
            string searchCost = MoneyText(Request.Form["searchCost"]);
            string copyCost = MoneyText(Request.Form["copyCost"]);
            string total = MoneyText(Request.Form["total"]);
            int inserted = 0;
            string allocatedTo = string.Empty;

            if (mode == "Offline")
            {
                int abstractorId = FormInt("abstractorId");
                if (abstractorId <= 0) return Result(false, "Please select company name.");
                inserted += InsertAbstractorTask(ost, orderId, product, "Offline", 0, abstractorId,
                    Request.Form["deliveryMethod"] ?? string.Empty, Digits(Request.Form["eta"]), searchCost, copyCost, total, addedBy);
                allocatedTo = Request.Form["abstractorName"] ?? string.Empty;
            }
            else
            {
                int abstractor1 = FormInt("abstractor1");
                int abstractor2 = FormInt("abstractor2");

                int[] docs1 = CsvInts(Request.Form["docs1"]);
                int[] docs2 = CsvInts(Request.Form["docs2"]);
                int[] docs3 = CsvInts(Request.Form["docs3"]);

                if (docs1.Length + docs2.Length + docs3.Length == 0)
                    return Result(false, "Please select at least one document.");

                if (docs1.Length > 0 && abstractor1 <= 0)
                    return Result(false, "Please select Searcher 1.");

                if (docs2.Length > 0 && abstractor2 <= 0)
                    return Result(false, "Please select Searcher 2.");

                foreach (int doc in docs1)
                    inserted += InsertAbstractorTask(ost, orderId, product, "Partial", doc, abstractor1, string.Empty, Digits(Request.Form["eta1"]), searchCost, copyCost, total, addedBy);

                foreach (int doc in docs2)
                    inserted += InsertAbstractorTask(ost, orderId, product, "Partial", doc, abstractor2, string.Empty, Digits(Request.Form["eta2"]), searchCost, copyCost, total, addedBy);

                foreach (int doc in docs3)
                    inserted += InsertAbstractorTask(ost, orderId, product, "Partial", doc, 0, string.Empty, string.Empty, searchCost, copyCost, total, addedBy);
            }

            if (inserted <= 0)
                return Result(false, "Order allocation was not saved.");

            SaveOptionalAttachment(ost, orderId, 1, addedBy, "VM Order Allocation");
            string comment = mode == "Offline" ? "Order Allocate to " + allocatedTo + " Abstractor" : "Order Allocated to Abstractor.";

            ost.InsertCommentOrder(orderId, 0, "Auto", comment, addedBy);

            if (mode == "Offline")
                TrySendAllocationMail(order, allocatedTo);

            return Result(true, "Order allocated successfully.", inserted);
        }

        private static int InsertAbstractorTask(bllOST ost, int orderId, string product, string mode, int docId, int abstractorId, string emailType, string eta, string searchCost, string copyCost, string total, int addedBy)
        {
            Hashtable values = new Hashtable();
            values["Orderid"] = orderId;
            values["ProductType"] = product;
            values["TaskTemplateid"] = 0;
            values["Docid"] = docId;
            values["TaskAssignedId"] = abstractorId;
            values["TaskProcessid"] = 1;
            values["OnOffLine"] = mode;
            values["EmailType"] = emailType;
            values["ETATime"] = eta;
            values["AddedBy"] = addedBy;
            values["SeachCost"] = searchCost;
            values["CopyCost"] = copyCost;
            values["Total"] = total;
            return ost.InsertOrderTaskForAbstractor(values) > 0 ? 1 : 0;
        }

        private VmResult ImportOrders()
        {
            HttpPostedFile file = Request.Files.Count > 0 ? Request.Files[0] : null;
            if (file == null || file.ContentLength == 0) return Result(false, "Please choose Excel file.");
            string extension = Path.GetExtension(file.FileName).ToLowerInvariant();
            if (extension != ".xls" && extension != ".xlsx") return Result(false, "Only .xls and .xlsx files are allowed.");

            string folder = Server.MapPath("~/TempFiles/VMImport/");
            Directory.CreateDirectory(folder);
            string savedPath = Path.Combine(folder, Guid.NewGuid().ToString("N") + extension);
            file.SaveAs(savedPath);
            List<Dictionary<string, object>> results = new List<Dictionary<string, object>>();
            int imported = 0;

            try
            {
                string connection = extension == ".xlsx"
                    ? "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + savedPath + ";Extended Properties=\"Excel 12.0;HDR=YES;IMEX=1\""
                    : "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + savedPath + ";Extended Properties=\"Excel 8.0;HDR=YES;IMEX=1\"";
                DataTable source = new DataTable();
                using (OleDbConnection excel = new OleDbConnection(connection))
                using (OleDbDataAdapter adapter = new OleDbDataAdapter("SELECT * FROM [Sheet1$]", excel))
                    adapter.Fill(source);

                string[] expected = { "ProjectNumber", "OrderNumber", "OrderDate", "ProductType", "OnOffline", "Abstractor" };
                if (source.Columns.Count < expected.Length || expected.Where((name, index) => source.Columns[index].ColumnName != name).Any())
                    return new VmResult { Success = false, Message = "Invalid Excel format. Use the provided VM template.", Rows = results };

                foreach (DataRow row in source.Rows)
                {
                    string project = Convert.ToString(row["ProjectNumber"]).Trim();
                    string orderNo = Convert.ToString(row["OrderNumber"]).Trim();
                    string abstractor = Convert.ToString(row["Abstractor"]).Trim();
                    Dictionary<string, object> resultRow = RowCopy(row);
                    if (project.Length == 0 || orderNo.Length == 0)
                    {
                        resultRow["Status"] = "Not Imported";
                        resultRow["Message"] = "Project Number and Order Number are required.";
                    }
                    else
                    {
                        int abstractorId = GetAbstractorId(abstractor);
                        if (abstractorId <= 0)
                        {
                            resultRow["Status"] = "Not Imported";
                            resultRow["Message"] = "Abstractor profile was not found.";
                        }
                        else
                        {
                            int returnValue = InsertImportedOrder(project, orderNo, Convert.ToDateTime(row["OrderDate"]).ToString("dd-MMM-yyyy"),
                                Convert.ToString(row["ProductType"]).Trim(), Convert.ToString(row["OnOffline"]).Trim(), abstractorId, CurrentUserId());
                            resultRow["Status"] = returnValue > 0 ? "Imported" : "Not Imported";
                            resultRow["Message"] = returnValue > 0 ? string.Empty : "Database operation did not insert the order.";
                            if (returnValue > 0) imported++;
                        }
                    }
                    results.Add(resultRow);
                }
            }
            finally
            {
                try { File.Delete(savedPath); } catch { }
            }

            return new VmResult { Success = imported > 0, Message = imported + " order(s) imported successfully.", ReturnValue = imported, Rows = results };
        }

        private VmResult CompleteQueueProcess()
        {
            int orderId = FormInt("orderId");
            int processId = FormInt("processId");
            int assignedUserId = FormInt("assignedUserId");
            string action = Request.Form["actionStatus"] ?? "Complete";
            string remark = (Request.Form["remark"] ?? string.Empty).Trim();
            int[] taskIds = CsvInts(Request.Form["taskIds"]);
            HttpPostedFile file = Request.Files.Count > 0 ? Request.Files[0] : null;
            if (orderId <= 0 || processId <= 0 || taskIds.Length == 0) return Result(false, "Select a valid process and at least one task.");
            if ((action == "Hold" || action == "Cancel") && remark.Length == 0) return Result(false, "Please enter task remark.");
            if (action == "Cancel" && string.IsNullOrWhiteSpace(Request.Form["cancelReason"])) return Result(false, "Please enter cancellation reason.");
            if (file == null || file.ContentLength <= 0) return Result(false, "Please choose completion attachment.");

            bool tax = FormBool("taxCalling");
            bool audit = FormBool("audit");
            bool offline = FormBool("offline");
            if (tax && audit) return Result(false, "It should be either Tax Calling or Audit Process.");

            bllOST ost = new bllOST();
            int taskStatus = action == "Cancel" ? 5 : action == "Hold" ? 4 : 2;
            int updated = 0;
            foreach (int taskId in taskIds)
            {
                Hashtable task = new Hashtable();
                task["TaskId"] = taskId; task["TaskStatus"] = taskStatus; task["TaskAssignedId"] = 0;
                task["Remark"] = CurrentUserId() + ":" + remark;
                task["TaxProcess"] = tax && (processId == 1 || processId == 2 || processId == 11) ? 1 : 0;
                task["AuditProcess"] = processId == 2 && audit ? 1 : 0;
                task["OfflineProcess"] = (processId == 2 || processId == 11) && offline ? 1 : 0;
                if (ost.UpdateTaskStatusAndDate(task) > 0) updated++;
            }
            if (updated == 0) return Result(false, "No task row was updated.");

            string processName = Request.Form["processName"] ?? "Process";
            string folder = "~\\OSTAttachment\\" + SafeSegment(processName) + "\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + orderId;
            Directory.CreateDirectory(Server.MapPath(folder));
            string fileName = Path.GetFileName(file.FileName);
            file.SaveAs(Path.Combine(Server.MapPath(folder), fileName));
            Hashtable attachment = new Hashtable();
            attachment["OrderId"] = orderId; attachment["Process"] = processId; attachment["DocId"] = taskStatus;
            attachment["Path"] = folder + "\\" + fileName; attachment["PathFrom"] = "Process Completed"; attachment["AddedBy"] = CurrentUserId();
            ost.InsertOrderAttachment(attachment);
            ost.InsertCommentOrder(orderId, processId, "Auto", processName + " Process Completed By VM Login", CurrentUserId());

            if (taskStatus == 4) ost.InsertCommentOrder(orderId, processId, "Auto", "Order is on Hold By VM Login", CurrentUserId());
            if (taskStatus == 5)
            {
                Hashtable cancel = new Hashtable();
                cancel["OrderID"] = orderId; cancel["Status"] = "Approve";
                cancel["Reason"] = CurrentUserId() + "," + (Request.Form["cancelledBy"] ?? string.Empty) + "," + (Request.Form["cancelReason"] ?? string.Empty);
                ost.CancelOrder(cancel);
                ost.InsertCommentOrder(orderId, processId, "Auto", "Order is Cancelled by VM", CurrentUserId());
            }
            if (FormBool("dispatch") && (processId == 2 || processId == 11 || processId == 5))
            {
                Hashtable dispatch = new Hashtable();
                dispatch["OrderId"] = orderId; dispatch["TaskTemplateid"] = 0;
                dispatch["TaskAssignedId"] = assignedUserId > 0 ? assignedUserId : CurrentUserId();
                dispatch["Remark"] = remark; dispatch["AdddedBy"] = CurrentUserId();
                if (ost.DispatchOrderTask(dispatch) > 0) ost.InsertCommentOrder(orderId, 6, "Auto", "Order is Dispatched by VM Login", CurrentUserId());
            }
            if (FormBool("noFeedback") && (processId == 2 || processId == 11 || processId == 5))
            {
                Hashtable feedback = new Hashtable();
                feedback["OrderNo"] = Request.Form["clientOrderNo"] ?? string.Empty;
                feedback["ProjectName"] = Request.Form["projectNumber"] ?? string.Empty;
                feedback["ProcessName"] = processName; feedback["AddedBy"] = CurrentUserId(); feedback["OrderId"] = orderId;
                ost.FeedBackOrders(feedback);
            }
            return Result(true, "Process updated successfully.", updated);
        }

        private void SaveOptionalAttachment(bllOST ost, int orderId, int processId, int addedBy, string pathFrom)
        {
            HttpPostedFile file = Request.Files.Count > 0 ? Request.Files[0] : null;
            if (file == null || file.ContentLength <= 0) return;
            string folder = "~\\OSTAttachment\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + orderId;
            Directory.CreateDirectory(Server.MapPath(folder));
            string name = Path.GetFileName(file.FileName);
            file.SaveAs(Path.Combine(Server.MapPath(folder), name));
            Hashtable values = new Hashtable();
            values["OrderId"] = orderId; values["Process"] = processId; values["DocId"] = 0;
            values["Path"] = folder + "\\" + name; values["PathFrom"] = pathFrom; values["AddedBy"] = addedBy;
            ost.InsertOrderAttachment(values);
        }

        private static DataTable GetAllProjectQueue()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetInfinityOrders_VM_AllProject");
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        private static int GetAbstractorId(string name)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetAbstractorProfileByName");
            SQLHelper.AddParamToSQLCmd(cmd, "@AbstractorName", SqlDbType.NVarChar, 1000, ParameterDirection.Input, name);
            DataTable table = SQLHelper.ExecuteDataTableCmd(cmd);
            return table.Rows.Count > 0 ? Convert.ToInt32(table.Rows[0]["AbstractorID"]) : 0;
        }

        private static int InsertImportedOrder(string project, string orderNo, string orderDate, string product, string onOffline, int abstractor, int addedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_InsertVMOrderBulkImport");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", SqlDbType.NVarChar, 4000, ParameterDirection.Input, project);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, orderDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", SqlDbType.NVarChar, 4000, ParameterDirection.Input, orderNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@productType", SqlDbType.NVarChar, 4000, ParameterDirection.Input, product);
            SQLHelper.AddParamToSQLCmd(cmd, "@OnOffline", SqlDbType.NVarChar, 4000, ParameterDirection.Input, onOffline);
            SQLHelper.AddParamToSQLCmd(cmd, "@Abstractor", SqlDbType.Int, 0, ParameterDirection.Input, abstractor);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBY", SqlDbType.Int, 0, ParameterDirection.Input, addedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int result = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return result;
        }

        private static void AddTaskAssignedId(DataTable table, bllVendors vendors)
        {
            if (table == null) return;
            if (!table.Columns.Contains("TaskAssignedId")) table.Columns.Add("TaskAssignedId", typeof(int));
            foreach (DataRow row in table.Rows)
            {
                int orderId = IntValue(RowCopy(row), "OrderId", "OrderID", "TaskId");
                if (orderId <= 0) continue;
                DataTable current = vendors.GetUserofCurrentProcess(orderId);
                if (current.Rows.Count > 0 && current.Columns.Contains("TaskAssignedId"))
                    row["TaskAssignedId"] = Convert.ToInt32(current.Rows[0]["TaskAssignedId"]);
            }
        }

        private static DateTime ParseDate(string text)
        {
            DateTime value;
            string[] formats = { "yyyy-MM-dd", "dd-MMM-yyyy", "dd/MM/yyyy", "MM/dd/yyyy" };
            if (!DateTime.TryParseExact(text, formats, CultureInfo.InvariantCulture, DateTimeStyles.AllowWhiteSpaces, out value))
                throw new ArgumentException("Please enter a valid date.");
            return value;
        }

        private static List<Dictionary<string, object>> Rows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow row in table.Rows) rows.Add(RowCopy(row));
            return rows;
        }

        private static Dictionary<string, object> RowCopy(DataRow row)
        {
            Dictionary<string, object> result = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
            foreach (DataColumn column in row.Table.Columns) result[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
            return result;
        }

        private static Dictionary<string, object> First(DataTable table)
        {
            return table != null && table.Rows.Count > 0 ? RowCopy(table.Rows[0]) : new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
        }

        private static object Pick(Dictionary<string, object> row, params string[] names)
        {
            foreach (string name in names) if (row.ContainsKey(name) && row[name] != null) return row[name];
            return string.Empty;
        }

        private static int IntValue(Dictionary<string, object> row, params string[] names)
        {
            int result;
            foreach (string name in names)
                if (row.ContainsKey(name) && int.TryParse(Convert.ToString(row[name]), out result)) return result;
            return 0;
        }

        private static string Value(DataRow row, string column)
        {
            return row.Table.Columns.Contains(column) && row[column] != DBNull.Value ? Convert.ToString(row[column]) : string.Empty;
        }

        private static int CurrentUserId()
        {
            int id;
            if (!int.TryParse(HttpContext.Current.User.Identity.Name, out id)) throw new InvalidOperationException("The current employee login is invalid.");
            return id;
        }

        private int FormInt(string name)
        {
            int value;
            return int.TryParse(Request.Form[name], out value) ? value : 0;
        }

        private bool FormBool(string name)
        {
            bool value;
            return bool.TryParse(Request.Form[name], out value) && value;
        }

        private static int[] CsvInts(string text)
        {
            return (text ?? string.Empty).Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(delegate (string item) { int value; return int.TryParse(item, out value) ? value : 0; })
                .Where(value => value > 0).Distinct().ToArray();
        }

        private static string Digits(string text)
        {
            string value = new string((text ?? string.Empty).Where(char.IsDigit).ToArray());
            return value;
        }

        private static string MoneyText(string text)
        {
            decimal value;
            return decimal.TryParse((text ?? string.Empty).Replace("$", string.Empty).Replace(",", string.Empty), NumberStyles.Any, CultureInfo.InvariantCulture, out value)
                ? value.ToString("0.00", CultureInfo.InvariantCulture) : "0.00";
        }

        private static string SafeSegment(string text)
        {
            string value = string.IsNullOrWhiteSpace(text) ? "Process" : text.Trim();
            foreach (char character in Path.GetInvalidFileNameChars()) value = value.Replace(character, '_');
            return value;
        }

        private static void TrySendAllocationMail(DataRow order, string abstractor)
        {
            try
            {
                string orderNo = Value(order, "ClientOrderNo");
                StringBuilder body = new StringBuilder();
                body.Append("<p><b>Dear " + HttpUtility.HtmlEncode(abstractor) + ",</b></p>");
                body.Append("<p>New order has been assigned '" + HttpUtility.HtmlEncode(orderNo) + "'.</p>");
                body.Append("<table border='1' cellpadding='5' cellspacing='0'>");
                body.Append("<tr><td>Project #</td><td>" + HttpUtility.HtmlEncode(Value(order, "ProjectNumber")) + "</td></tr>");
                body.Append("<tr><td>Order #</td><td>" + HttpUtility.HtmlEncode(orderNo) + "</td></tr>");
                body.Append("<tr><td>Order Date</td><td>" + HttpUtility.HtmlEncode(Value(order, "OrderDate")) + "</td></tr>");
                body.Append("<tr><td>Process</td><td>Search</td></tr></table><p>Thanks,<br/>Infinity ERP</p>");
                MailMessage message = new MailMessage();
                message.From = new MailAddress("ack@infinityinternationals.us", "Orders");
                message.To.Add("josh@infinityinternationals.us,shaun@infinityinternationals.us,n.prasad@infinityinternationals.us");
                message.Subject = "A new Order(" + orderNo + ") has been assigned to Abstractor : " + abstractor;
                message.Body = body.ToString();
                message.IsBodyHtml = true;
                using (SmtpClient client = new SmtpClient()) client.Send(message);
            }
            catch
            {
                // Allocation remains successful when the notification service is unavailable, as in the ERP workflow.
            }
        }

        private void WriteJson(VmResult result)
        {
            Response.Clear();
            Response.ContentType = "application/json";
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            Response.Write(serializer.Serialize(result));
            Context.ApplicationInstance.CompleteRequest();
        }

        private static VmResult Result(bool success, string message, int returnValue = 0)
        {
            return new VmResult { Success = success, Message = message, ReturnValue = returnValue, Rows = new List<Dictionary<string, object>>() };
        }

        public class VmResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public int ReturnValue { get; set; }
            public List<Dictionary<string, object>> Rows { get; set; }
        }
    }
}
