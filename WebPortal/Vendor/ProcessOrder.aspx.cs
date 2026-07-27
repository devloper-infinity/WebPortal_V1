using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Vendor
{
    public partial class ProcessOrder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetInitialData()
        {
            try
            {
                int userId = CurrentUserId();
                DataTable dt = new bllTracking().GetAllInfinityOrderbyEmp(userId);
                var orders = new List<LookupItem>();
                foreach (DataRow row in dt.Rows)
                {
                    orders.Add(new LookupItem
                    {
                        Value = Convert.ToString(row["OrderID"]),
                        Text = Convert.ToString(row["ProjectNumber"]) + " : " + Convert.ToString(row["ClientOrderNo"])
                    });
                }
                return ApiResponse.Ok(new { Orders = orders });
            }
            catch (Exception ex)
            {
                return ApiResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetOrderData(int orderId)
        {
            try
            {
                int userId = CurrentUserId();
                var bll = new bllOST();
                DataTable current = bll.GetCurrentProcessOfUser(orderId, userId);
                if (current.Rows.Count == 0)
                    return ApiResponse.Fail("Current process was not found for the selected order.");

                int processId = Convert.ToInt32(current.Rows[0]["Processid"]);
                string processName = GetColumnValue(current.Rows[0], "ProcessName", "Process");
                if (String.IsNullOrWhiteSpace(processName))
                {
                    DataTable processes = bll.GetAllProcess();
                    DataRow match = processes.AsEnumerable().FirstOrDefault(r => Convert.ToString(r["Processid"]) == processId.ToString());
                    if (match != null) processName = Convert.ToString(match["ProcessName"]);
                }

                DataTable tasks = bll.GetOrdersOnProcessForUser(orderId, userId, processId);
                DataTable history = bll.GetOrderDetailsProcesswise(orderId);
                string remark = GetColumnValue(current.Rows[0], "Remark");

                return ApiResponse.Ok(new
                {
                    ProcessId = processId,
                    ProcessName = processName,
                    Remark = remark,
                    Tasks = ToRows(tasks),
                    History = ToRows(history)
                });
            }
            catch (Exception ex)
            {
                return ApiResponse.Fail(ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse CompleteProcess(ProcessInput input)
        {
            try
            {
                if (input == null) return ApiResponse.Fail("Invalid request.");
                if (input.OrderId <= 0) return ApiResponse.Fail("Please select an order.");
                if (input.ProcessId <= 0) return ApiResponse.Fail("Current process is not available.");
                if (input.Tasks == null || input.Tasks.Count == 0) return ApiResponse.Fail("Please select at least one task.");
                if (String.IsNullOrWhiteSpace(input.FileName) || String.IsNullOrWhiteSpace(input.FileBase64)) return ApiResponse.Fail("Please choose an attachment.");

                string action = (input.Action ?? "complete").Trim().ToLowerInvariant();
                if ((action == "cancel" || action == "hold" || action == "partial") && String.IsNullOrWhiteSpace(input.Remark))
                    return ApiResponse.Fail("Please enter a remark.");

                string clientOrderNo = input.Tasks.Select(t => t.ClientOrderNo).FirstOrDefault(x => !String.IsNullOrWhiteSpace(x)) ?? String.Empty;
                string fileBaseName = Path.GetFileNameWithoutExtension(input.FileName);
                if (!String.Equals(clientOrderNo.Trim(), fileBaseName.Trim(), StringComparison.OrdinalIgnoreCase))
                    return ApiResponse.Fail("The selected file name does not match the Order No.");

                int userId = CurrentUserId();
                var bll = new bllOST();
                int statusId = StatusFromAction(action);
                int updated = 0;

                foreach (ProcessTaskInput task in input.Tasks)
                {
                    string projectCode = Convert.ToString(new bllMaster().ValidateProject(task.Project));
                    if (projectCode != "0")
                    {
                        string employeeCode = bll.GetCodeFromEmployeeId(Convert.ToString(userId), clientOrderNo, task.Project);
                        string hasRights = new bllMaster().ValidateUserProjectRights(employeeCode, projectCode);
                        if (hasRights == "0")
                            return ApiResponse.Fail(task.Project + " Project is not assigned to you. Please contact your Reporting Manager/Project Manager.");
                    }

                    var ht = new Hashtable();
                    ht["TaskId"] = task.TaskId;
                    ht["TaskStatus"] = statusId;
                    ht["TaskAssignedId"] = 0;
                    ht["Remark"] = input.Remark ?? String.Empty;
                    int result = bll.UpdateTaskStatusAndDate(ht);
                    if (result > 0) updated++;
                }

                if (updated == 0) return ApiResponse.Fail("Unable to complete the selected task(s).");

                string safeProcess = MakeSafeFolderName(input.ProcessName);
                string root = HttpContext.Current.Server.MapPath("~/OSTAttachment/");
                string folder = Path.Combine(root, safeProcess, DateTime.Now.ToString("dd-MMM-yyyy"), input.OrderId.ToString());
                Directory.CreateDirectory(folder);
                string safeFileName = Path.GetFileName(input.FileName);
                string physicalPath = Path.Combine(folder, safeFileName);
                File.WriteAllBytes(physicalPath, Convert.FromBase64String(input.FileBase64));
                string virtualPath = "~\\OSTAttachment\\" + safeProcess + "\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + input.OrderId + "\\" + safeFileName;

                new bllVendors().InsertOSTAttachment(input.OrderId, input.ProcessId, 0, virtualPath, "Process Completed", userId);
                new bllVendors().InsertComment(input.OrderId, input.ProcessId, "Auto", input.ProcessName + " Process Completed", userId);

                if (action == "cancel")
                    new bllVendors().InsertComment(input.OrderId, input.ProcessId, "Auto", "Order is Cancelled by User", userId);
                else if (action == "hold")
                    new bllVendors().InsertComment(input.OrderId, input.ProcessId, "Auto", "Order is on Hold", userId);
                else if (action == "partial")
                    new bllVendors().InsertComment(input.OrderId, input.ProcessId, "Auto", "Order is Partial Done by User", userId);

                if (action == "dispatch")
                {
                    var dispatch = new Hashtable();
                    dispatch["OrderId"] = input.OrderId;
                    dispatch["TaskTemplateid"] = 0;
                    dispatch["TaskAssignedId"] = userId;
                    dispatch["Remark"] = input.Remark ?? String.Empty;
                    dispatch["AdddedBy"] = userId;
                    int dispatched = bll.DispatchOrderTask(dispatch);
                    if (dispatched <= 0) return ApiResponse.Fail("Process completed, but the order was not dispatched.");
                    new bllVendors().InsertComment(input.OrderId, 6, "Auto", "Order is Dispatched", userId);
                }

                if (input.ProcessId == 2)
                {
                    if (input.NoError)
                    {
                        var feedback = new Hashtable();
                        feedback["OrderNo"] = clientOrderNo;
                        feedback["ProjectName"] = input.Tasks[0].Project;
                        feedback["ProcessName"] = input.ProcessName;
                        feedback["AddedBy"] = userId;
                        feedback["OrderId"] = input.OrderId;
                        int feedbackResult = bll.FeedBackOrders(feedback);
                        if (feedbackResult <= 0) return ApiResponse.Fail("Process completed, but feedback could not be added.");
                    }
                    else
                    {
                        string redirect = VirtualPathUtility.ToAbsolute("~/OST/AddFeedbackForSearchProject.aspx") +
                            "?ProcessFeedbak=" + HttpUtility.UrlEncode(clientOrderNo) +
                            "&ProjectName=" + HttpUtility.UrlEncode(input.Tasks[0].Project);
                        return ApiResponse.Ok(new { RedirectUrl = redirect }, "Process completed successfully. Please add feedback.");
                    }
                }

                return ApiResponse.Ok(null, action == "dispatch" ? "Order dispatched successfully." : "Process completed successfully.");
            }
            catch (FormatException)
            {
                return ApiResponse.Fail("The uploaded file data is invalid.");
            }
            catch (Exception ex)
            {
                return ApiResponse.Fail(ex.Message);
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static FileResponse DownloadAttachment(string virtualPath)
        {
            try
            {
                if (String.IsNullOrWhiteSpace(virtualPath)) return FileResponse.Fail("Attachment path is empty.");
                string normalized = virtualPath.Replace("\\", "/");
                if (!normalized.StartsWith("~/OSTAttachment/", StringComparison.OrdinalIgnoreCase))
                    return FileResponse.Fail("Invalid attachment path.");
                string physical = HttpContext.Current.Server.MapPath(normalized);
                if (!File.Exists(physical)) return FileResponse.Fail("Attachment was not found.");
                return FileResponse.Ok(Path.GetFileName(physical), MimeMapping.GetMimeMapping(physical), Convert.ToBase64String(File.ReadAllBytes(physical)));
            }
            catch (Exception ex)
            {
                return FileResponse.Fail(ex.Message);
            }
        }

        private static int CurrentUserId()
        {
            int userId;
            if (!Int32.TryParse(HttpContext.Current.User.Identity.Name, out userId))
                throw new InvalidOperationException("Unable to identify the logged-in user.");
            return userId;
        }

        private static int StatusFromAction(string action)
        {
            switch (action)
            {
                case "cancel": return 5;
                case "hold": return 4;
                case "partial": return 7;
                default: return 2;
            }
        }

        private static string MakeSafeFolderName(string value)
        {
            string result = String.IsNullOrWhiteSpace(value) ? "Process" : value.Trim();
            foreach (char c in Path.GetInvalidFileNameChars()) result = result.Replace(c, '_');
            return result;
        }

        private static string GetColumnValue(DataRow row, params string[] names)
        {
            foreach (string name in names)
                if (row.Table.Columns.Contains(name)) return Convert.ToString(row[name]);
            return String.Empty;
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow row in table.Rows)
            {
                var item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn col in table.Columns)
                    item[col.ColumnName] = row[col] == DBNull.Value ? null : row[col];
                rows.Add(item);
            }
            return rows;
        }

        public sealed class LookupItem
        {
            public string Value { get; set; }
            public string Text { get; set; }
        }

        public sealed class ProcessInput
        {
            public int OrderId { get; set; }
            public int ProcessId { get; set; }
            public string ProcessName { get; set; }
            public string Action { get; set; }
            public string Remark { get; set; }
            public bool NoError { get; set; }
            public string FileName { get; set; }
            public string FileBase64 { get; set; }
            public List<ProcessTaskInput> Tasks { get; set; }
        }

        public sealed class ProcessTaskInput
        {
            public int TaskId { get; set; }
            public int DocId { get; set; }
            public string Project { get; set; }
            public string ClientOrderNo { get; set; }
        }

        public sealed class ApiResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public object Orders { get; set; }
            public object ProcessId { get; set; }
            public object ProcessName { get; set; }
            public object Remark { get; set; }
            public object Tasks { get; set; }
            public object History { get; set; }
            public string RedirectUrl { get; set; }

            public static ApiResponse Ok(object data, string message = "")
            {
                var r = new ApiResponse { Success = true, Message = message };
                if (data != null)
                {
                    var props = data.GetType().GetProperties();
                    foreach (var p in props)
                    {
                        var target = typeof(ApiResponse).GetProperty(p.Name);
                        if (target != null) target.SetValue(r, p.GetValue(data, null), null);
                    }
                }
                return r;
            }

            public static ApiResponse Fail(string message)
            {
                return new ApiResponse { Success = false, Message = message };
            }
        }

        public sealed class FileResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public string FileName { get; set; }
            public string ContentType { get; set; }
            public string FileBase64 { get; set; }
            public static FileResponse Ok(string name, string type, string data) { return new FileResponse { Success = true, FileName = name, ContentType = type, FileBase64 = data }; }
            public static FileResponse Fail(string message) { return new FileResponse { Success = false, Message = message }; }
        }
    }
}