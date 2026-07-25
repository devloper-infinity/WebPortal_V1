using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Search
{
    public partial class SearchDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string action = Request.QueryString["action"];
            if (string.IsNullOrWhiteSpace(action))
            {
                return;
            }

            try
            {
                if (action.Equals("download", StringComparison.OrdinalIgnoreCase))
                {
                    DownloadAttachment(Request.QueryString["path"]);
                    return;
                }

                if (action.Equals("uploadDocument", StringComparison.OrdinalIgnoreCase))
                {
                    WriteJson(UploadRevisedDocument());
                    return;
                }

                if (action.Equals("completePm", StringComparison.OrdinalIgnoreCase))
                {
                    WriteJson(CompletePmProcess());
                }
            }
            catch (Exception ex)
            {
                WriteJson(Result(false, ex.Message));
            }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (!string.IsNullOrWhiteSpace(Request.QueryString["action"]))
            {
                return;
            }
            base.Render(writer);
        }

        [WebMethod]
        public static string GetProjects()
        {
            return SerializeTable(new bllOST().GetAllProject(CurrentUserId()));
        }

        [WebMethod]
        public static string GetProjectProcesses(int projectId)
        {
            DataTable table = new bllOST().GetAllProcessOnProjectTemplate(projectId);
            if (table == null || table.Rows.Count == 0)
            {
                table = new bllMaster().GetAllProcess();
            }
            return SerializeTable(table);
        }

        [WebMethod]
        public static string GetAllocationUsers(string userType)
        {
            return SerializeTable(new bllOST().GetUsersOnUserType((userType ?? string.Empty).Trim()));
        }

        [WebMethod]
        public static string GetAllocationSummary(string projectNumber, int processId, int previousProcessId)
        {
            return SerializeTable(new bllOST().GetAllProcesswiseOrder_Summary(processId, CurrentUserId(), projectNumber, previousProcessId));
        }

        [WebMethod]
        public static string GetAllocationOrders(string projectNumber, int processId, int previousProcessId, string productType, string orderDate)
        {
            return SerializeTable(new bllOST().GetAllProcesswiseOrderForAllocationNew(processId, CurrentUserId(), projectNumber, previousProcessId, productType, orderDate));
        }

        [WebMethod]
        public static DashboardResult AllocateOrders(int projectId, int processId, int assignedTo, string allocateTo, List<AllocationOrder> orders)
        {
            if (projectId <= 0 || processId <= 0 || assignedTo <= 0)
            {
                return Result(false, "Select project, process and assignee.");
            }
            if (orders == null || orders.Count == 0)
            {
                return Result(false, "Select at least one order.");
            }

            bllOST ost = new bllOST();
            DataTable template = ost.GetAllProcessOnProjectTemplate(projectId);
            if (template == null || template.Rows.Count == 0)
            {
                return Result(false, "No process template is configured for the selected project.");
            }

            int templateId = GetInt(template.Rows[0], "TemplateId", "TemplateID");
            int success = 0;
            int skipped = 0;
            foreach (AllocationOrder order in orders)
            {
                if (order == null || order.OrderId <= 0)
                {
                    continue;
                }

                Hashtable task = new Hashtable();
                task["Orderid"] = order.OrderId;
                task["ProductType"] = order.ProductType ?? string.Empty;
                task["TaskTemplateid"] = templateId;
                task["Docid"] = 0;
                task["TaskAssignedId"] = assignedTo;
                task["TaskProcessid"] = processId;
                task["OnOffLine"] = "Online";
                task["AllocateTo"] = allocateTo ?? string.Empty;
                task["AddedBy"] = CurrentUserId();
                int inserted = ost.InsertOrderTask(task);
                if (inserted > 0)
                {
                    success++;
                    ost.InsertCommentOrder(order.OrderId, processId, "Auto", "Order Allocated by PM", CurrentUserId());
                }
                else
                {
                    skipped++;
                    ost.InsertCommentOrder(order.OrderId, 0, "Auto", "Order Exception Error occurred while allocating the order. Please Confirm Process Orders before orders process..!!", CurrentUserId());
                }
            }

            return new DashboardResult
            {
                Success = success > 0,
                ReturnValue = success,
                Message = success + " order(s) allocated." + (skipped > 0 ? " " + skipped + " order(s) were already allocated or in process." : string.Empty)
            };
        }

        [WebMethod]
        public static string GetOrderQueue()
        {
            return SerializeTable(new bllOST().GetAllInfinityOrderStatus_UserWiseAllocatoin());
        }

        [WebMethod]
        public static string GetPmOrders(string projectNumber)
        {
            return SerializeTable(new bllOST().GetOrdersOnProject(CurrentUserId(), projectNumber));
        }

        [WebMethod]
        public static PmOrderContext GetPmOrderContext(int orderId)
        {
            bllOST ost = new bllOST();
            DataTable current = ost.GetCurrentProcessOfUserPM(orderId);
            Dictionary<string, object> context = FirstRow(current);
            int processId = GetInt(current != null && current.Rows.Count > 0 ? current.Rows[0] : null, "Processid", "ProcessId", "TaskProcessid");
            DataTable tasks = processId > 0 ? ost.GetOrdersOnProcess(orderId, processId) : new DataTable();
            return new PmOrderContext { Context = context, Tasks = TableRows(tasks) };
        }

        [WebMethod]
        public static string GetOrderDetails(int orderId)
        {
            return SerializeTable(new bllOST().GetOrderDetailsProcesswise(orderId));
        }

        [WebMethod]
        public static string GetCallers()
        {
            return SerializeTable(new bllOST().GetAllInfinityCaller());
        }

        [WebMethod]
        public static DashboardResult UpdateIndividualTask(int taskId, string status, int assignedTo, string documentType, string assignedToName)
        {
            if (taskId <= 0 || string.IsNullOrWhiteSpace(status))
            {
                return Result(false, "Select a task and status.");
            }
            if (status.Equals("Transfer", StringComparison.OrdinalIgnoreCase) && assignedTo <= 0)
            {
                return Result(false, "Select a caller for transfer.");
            }

            Hashtable data = new Hashtable();
            data["TaskId"] = taskId;
            data["TaskStatus"] = status;
            data["TaskAssignedId"] = status.Equals("Transfer", StringComparison.OrdinalIgnoreCase) ? assignedTo : 0;
            data["Remark"] = status.Equals("Transfer", StringComparison.OrdinalIgnoreCase)
                ? (documentType ?? string.Empty) + " is Transfer to " + (assignedToName ?? string.Empty) + " for Calling Process"
                : string.Empty;
            data["TaxProcess"] = 0;
            data["AuditProcess"] = 0;
            data["OfflineProcess"] = 0;
            int result = new bllOST().UpdateTaskStatusAndDate(data);
            return Result(result > 0, result > 0 ? "Task status updated successfully." : "Task status was not updated.", result);
        }

        [WebMethod]
        public static string GetUploadOrders(string projectNumber, string orderDate)
        {
            return SerializeTable(new bllOST().GetAllInfinityOrderbyEmpAndProject_UploadDoc(CurrentUserId(), projectNumber, orderDate));
        }

        [WebMethod]
        public static string GetUploadedDocuments(int orderId)
        {
            return SerializeTable(new bllOST().GetAllUploadAndDownloadSearch(orderId.ToString()));
        }

        [WebMethod]
        public static string GetCostingReport(string projectNumber, string fromDate, string toDate)
        {
            return SerializeTable(new bllOST().TMMGetProjectWiseOrderDetailsForBilling_EditCosting(projectNumber, fromDate, toDate));
        }

        private DashboardResult UploadRevisedDocument()
        {
            HttpPostedFile file = Request.Files.Count > 0 ? Request.Files[0] : null;
            int orderId = FormInt("orderId");
            int processId = FormInt("processId");
            string orderNo = Request.Form["clientOrderNo"];
            string processName = Request.Form["processName"];
            ValidateUpload(file, orderNo);

            string folder = "~\\OSTAttachment\\" + SafeSegment(processName) + "\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + orderId;
            string physicalFolder = Server.MapPath(folder);
            Directory.CreateDirectory(physicalFolder);
            string savedName = "RevisedPackage_" + Path.GetFileName(file.FileName);
            file.SaveAs(Path.Combine(physicalFolder, savedName));
            string relativePath = folder + "\\" + savedName;

            Hashtable attachment = new Hashtable();
            attachment["OrderId"] = orderId;
            attachment["Process"] = processId;
            attachment["DocId"] = 0;
            attachment["Path"] = relativePath;
            attachment["PathFrom"] = "Process Completed";
            attachment["AddedBy"] = CurrentUserId();
            int result = new bllOST().InsertOrderAttachment(attachment);
            return Result(result > 0, result > 0 ? "Document uploaded successfully." : "Document was not uploaded.", result);
        }

        private DashboardResult CompletePmProcess()
        {
            HttpPostedFile file = Request.Files.Count > 0 ? Request.Files[0] : null;
            int orderId = FormInt("orderId");
            int processId = FormInt("processId");
            int assignedUserId = FormInt("assignedUserId");
            string orderNo = Request.Form["clientOrderNo"];
            string projectNumber = Request.Form["projectNumber"];
            string processName = Request.Form["processName"];
            string actionStatus = Request.Form["actionStatus"];
            string remark = Request.Form["remark"] ?? string.Empty;
            string taskIdsText = Request.Form["taskIds"] ?? string.Empty;
            ValidateUpload(file, orderNo);
            if ((string.Equals(actionStatus, "Cancel", StringComparison.OrdinalIgnoreCase) ||
                 string.Equals(actionStatus, "Hold", StringComparison.OrdinalIgnoreCase)) && string.IsNullOrWhiteSpace(remark))
            {
                return Result(false, "Please enter task remark.");
            }
            if (string.Equals(actionStatus, "Cancel", StringComparison.OrdinalIgnoreCase) &&
                string.IsNullOrWhiteSpace(Request.Form["cancelReason"]))
            {
                return Result(false, "Please enter cancellation reason.");
            }

            List<int> taskIds = taskIdsText.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(delegate(string item) { int id; return int.TryParse(item, out id) ? id : 0; }).Where(id => id > 0).Distinct().ToList();
            if (orderId <= 0 || processId <= 0 || taskIds.Count == 0)
            {
                return Result(false, "Select a valid order, process and at least one task.");
            }

            bllOST ost = new bllOST();
            bllMaster master = new bllMaster();
            string projectId = master.ValidateProject(projectNumber);
            if (projectId == "0")
            {
                return Result(false, "The selected project is not valid.");
            }
            string employeeCode = ost.GetCodeFromEmployeeId((assignedUserId > 0 ? assignedUserId : CurrentUserId()).ToString(), orderNo, projectNumber);
            if (master.ValidateUserProjectRights(employeeCode, projectId) == "0")
            {
                return Result(false, projectNumber + " Project is not assigned to the selected user. Please contact the Reporting Manager/Project Manager.");
            }

            int taskStatus = TaskStatus(actionStatus);
            bool taxCalling = FormBool("taxCalling");
            bool audit = FormBool("audit");
            bool offline = FormBool("offline");
            if (taxCalling && audit)
            {
                return Result(false, "Unable to complete the process. It should be either Tax Calling or Audit Process.");
            }
            int updated = 0;
            foreach (int taskId in taskIds)
            {
                Hashtable task = new Hashtable();
                task["TaskId"] = taskId;
                task["TaskStatus"] = taskStatus;
                task["TaskAssignedId"] = 0;
                task["Remark"] = CurrentUserId() + ":" + remark.Trim();
                task["TaxProcess"] = taxCalling && (processId == 1 || processId == 2 || processId == 11) ? 1 : 0;
                task["AuditProcess"] = processId == 2 && audit ? 1 : 0;
                task["OfflineProcess"] = (processId == 2 || processId == 11) && offline ? 1 : 0;
                if (ost.UpdateTaskStatusAndDate(task) > 0) { updated++; }
            }
            if (updated == 0)
            {
                return Result(false, "No task row was updated.");
            }

            string folder = "~\\OSTAttachment\\" + SafeSegment(processName) + "\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + orderId;
            string physicalFolder = Server.MapPath(folder);
            Directory.CreateDirectory(physicalFolder);
            string fileName = Path.GetFileName(file.FileName);
            file.SaveAs(Path.Combine(physicalFolder, fileName));

            Hashtable attachment = new Hashtable();
            attachment["OrderId"] = orderId; attachment["Process"] = processId; attachment["DocId"] = taskStatus;
            attachment["Path"] = folder + "\\" + fileName; attachment["PathFrom"] = "Process Completed"; attachment["AddedBy"] = CurrentUserId();
            ost.InsertOrderAttachment(attachment);
            ost.InsertCommentOrder(orderId, processId, "Auto", processName + " Process Completed By PM Login", CurrentUserId());
            if (taskStatus == 4) { ost.InsertCommentOrder(orderId, processId, "Auto", "Order is on Hold By PM Login", CurrentUserId()); }

            if (taskStatus == 5)
            {
                Hashtable cancel = new Hashtable();
                cancel["OrderID"] = orderId; cancel["Status"] = "Approve";
                cancel["Reason"] = CurrentUserId() + "," + (Request.Form["cancelledBy"] ?? string.Empty) + "," + (Request.Form["cancelReason"] ?? string.Empty);
                ost.CancelOrder(cancel);
                ost.InsertCommentOrder(orderId, processId, "Auto", "Order is Cancelled by PM", CurrentUserId());
            }

            if (FormBool("dispatch") && (processId == 2 || processId == 11 || processId == 5))
            {
                Hashtable dispatch = new Hashtable();
                dispatch["OrderId"] = orderId; dispatch["TaskTemplateid"] = 0;
                dispatch["TaskAssignedId"] = assignedUserId > 0 ? assignedUserId : CurrentUserId();
                dispatch["Remark"] = remark; dispatch["AdddedBy"] = CurrentUserId();
                if (ost.DispatchOrderTask(dispatch) > 0)
                {
                    ost.InsertCommentOrder(orderId, 6, "Auto", "Order is Dispatched by PM Login", CurrentUserId());
                }
            }

            if (FormBool("noFeedback") && (processId == 2 || processId == 11 || processId == 5))
            {
                Hashtable feedback = new Hashtable();
                feedback["OrderNo"] = orderNo; feedback["ProjectName"] = projectNumber; feedback["ProcessName"] = processName;
                feedback["AddedBy"] = CurrentUserId(); feedback["OrderId"] = orderId;
                ost.FeedBackOrders(feedback);
            }
            return Result(true, "Process completed successfully.", updated);
        }

        private void DownloadAttachment(string relativePath)
        {
            if (string.IsNullOrWhiteSpace(relativePath))
            {
                throw new InvalidOperationException("Attachment path is missing.");
            }
            string normalized = relativePath.Replace('/', '\\');
            if (!normalized.StartsWith("~\\OSTAttachment\\", StringComparison.OrdinalIgnoreCase))
            {
                throw new InvalidOperationException("Invalid attachment path.");
            }

            string root = Path.GetFullPath(Server.MapPath("~/OSTAttachment"));
            string filePath = Path.GetFullPath(Server.MapPath(normalized));
            if (!filePath.StartsWith(root + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase) || !File.Exists(filePath))
            {
                throw new FileNotFoundException("Attachment was not found.");
            }
            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition", "attachment; filename=\"" + Path.GetFileName(filePath).Replace("\"", string.Empty) + "\"");
            Response.TransmitFile(filePath);
            Response.Flush();
            Context.ApplicationInstance.CompleteRequest();
        }

        private static void ValidateUpload(HttpPostedFile file, string orderNo)
        {
            if (file == null || file.ContentLength <= 0)
            {
                throw new InvalidOperationException("Please choose file.");
            }
            string name = Path.GetFileName(file.FileName);
            if (!Path.GetFileNameWithoutExtension(name).Equals((orderNo ?? string.Empty).Trim(), StringComparison.OrdinalIgnoreCase))
            {
                throw new InvalidOperationException("The selected file name does not match with the order no.");
            }
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

        private static int TaskStatus(string status)
        {
            if (string.Equals(status, "Cancel", StringComparison.OrdinalIgnoreCase)) { return 5; }
            if (string.Equals(status, "Hold", StringComparison.OrdinalIgnoreCase)) { return 4; }
            return 2;
        }

        private static int CurrentUserId()
        {
            int id;
            if (!int.TryParse(HttpContext.Current.User.Identity.Name, out id))
            {
                throw new InvalidOperationException("The current employee login is not valid.");
            }
            return id;
        }

        private static string SafeSegment(string text)
        {
            string value = string.IsNullOrWhiteSpace(text) ? "Process" : text.Trim();
            foreach (char character in Path.GetInvalidFileNameChars()) { value = value.Replace(character, '_'); }
            return value;
        }

        private static string SerializeTable(DataTable table)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(TableRows(table));
        }

        private static List<Dictionary<string, object>> TableRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) { return rows; }
            foreach (DataRow source in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                {
                    row[column.ColumnName] = source[column] == DBNull.Value ? null : source[column];
                }
                rows.Add(row);
            }
            return rows;
        }

        private static Dictionary<string, object> FirstRow(DataTable table)
        {
            List<Dictionary<string, object>> rows = TableRows(table);
            return rows.Count > 0 ? rows[0] : new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
        }

        private static int GetInt(DataRow row, params string[] columns)
        {
            if (row == null) { return 0; }
            foreach (string column in columns)
            {
                if (row.Table.Columns.Contains(column) && row[column] != DBNull.Value)
                {
                    int value;
                    if (int.TryParse(Convert.ToString(row[column]), out value)) { return value; }
                }
            }
            return 0;
        }

        private void WriteJson(DashboardResult result)
        {
            Response.Clear();
            Response.ContentType = "application/json";
            Response.Write(new JavaScriptSerializer().Serialize(result));
            Context.ApplicationInstance.CompleteRequest();
        }

        private static DashboardResult Result(bool success, string message, int returnValue = 0)
        {
            return new DashboardResult { Success = success, Message = message, ReturnValue = returnValue };
        }

        public class AllocationOrder
        {
            public int OrderId { get; set; }
            public string ProductType { get; set; }
        }

        public class DashboardResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public int ReturnValue { get; set; }
        }

        public class PmOrderContext
        {
            public Dictionary<string, object> Context { get; set; }
            public List<Dictionary<string, object>> Tasks { get; set; }
        }
    }
}
