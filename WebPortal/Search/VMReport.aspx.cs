using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Search
{
    public partial class VMReport : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string action = Request.QueryString["action"];
            if (string.IsNullOrWhiteSpace(action)) return;

            try
            {
                if (action.Equals("download", StringComparison.OrdinalIgnoreCase))
                {
                    int orderId;
                    int attachmentIndex;
                    if (int.TryParse(Request.QueryString["orderId"], out orderId) &&
                        int.TryParse(Request.QueryString["attachmentIndex"], out attachmentIndex))
                        DownloadTrackingAttachment(orderId, attachmentIndex);
                    else
                        DownloadAttachment(Request.QueryString["path"]);
                }
                else
                    throw new InvalidOperationException("Invalid VM report action.");
            }
            catch (Exception ex)
            {
                Response.StatusCode = 400;
                Response.ContentType = "text/plain";
                Response.Write(ex.Message);
                Context.ApplicationInstance.CompleteRequest();
            }
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
            return new
            {
                IsPM = new bllVendors().CheckIfPMVM(userId) == 1,
                Projects = Rows(new bllOST().GetAllProject(userId))
            };
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetBillingSummary(string project, string fromDate, string toDate)
        {
            DateTime from;
            DateTime to;
            ValidateReportFilters(project, fromDate, toDate, out from, out to);
            return Rows(ExecuteThreeParameterReport(
                "usp_OST_GetAllOrdersBilling_VM_Abstractor",
                project,
                from.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                to.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture)));
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetBillingDetails(string project, string fromDate, string toDate)
        {
            DateTime from;
            DateTime to;
            ValidateReportFilters(project, fromDate, toDate, out from, out to);
            return Rows(ExecuteThreeParameterReport(
                "usp_OST_GetAllOrdersBilling_VM",
                project,
                from.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                to.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture)));
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetTrackingOrders(
            string fromDate,
            string toDate,
            string project,
            bool showAll)
        {
            DateTime from = ParseDate(fromDate);
            DateTime to = ParseDate(toDate);
            if (from > to) throw new ArgumentException("From Date should be less than or equal to To Date.");

            int userId = CurrentUserId();
            bool isPm = new bllVendors().CheckIfPMVM(userId) == 1;
            DataTable table;

            if (showAll)
            {
                if (!isPm) throw new InvalidOperationException("Only a VM Project Manager can view the tracking sheet.");
                if (string.IsNullOrWhiteSpace(project) || project.Equals("Select", StringComparison.OrdinalIgnoreCase) ||
                    project.Equals("All", StringComparison.OrdinalIgnoreCase))
                    throw new ArgumentException("Please select a project.");

                table = ExecuteTrackingReport(
                    "usp_OST_GetInfinityOrders_VM_TrackingSheet",
                    from.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                    to.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                    project,
                    null);
            }
            else
            {
                table = ExecuteTrackingReport(
                    "usp_OST_GetInfinityOrders_User",
                    from.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                    to.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                    string.IsNullOrWhiteSpace(project) ? "All" : project,
                    userId);
            }

            AddTaskAssignedId(table);
            return Rows(table);
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetTrackingDetail(int orderId, string detailType)
        {
            if (orderId <= 0) throw new ArgumentException("Select a valid order.");
            string type = (detailType ?? string.Empty).Trim().ToLowerInvariant();

            if (type == "attachments")
                return Rows(ExecuteOrderReport("usp_OST_GetOrderDetailsProcesswise_VM", orderId));

            bllVendors vendors = new bllVendors();
            DataTable table;
            switch (type)
            {
                case "feedback":
                    table = vendors.BindOrderFeedback(orderId);
                    break;
                case "checklist":
                    table = vendors.BindOrderCheckList(orderId);
                    break;
                case "history":
                    table = vendors.GetAllOrderHistory(orderId);
                    break;
                case "costing":
                    table = vendors.GetAllorderCosing(orderId);
                    break;
                case "tax":
                    table = vendors.BindTaxDetails(orderId);
                    break;
                default:
                    throw new ArgumentException("Invalid order detail type.");
            }
            return Rows(table);
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetCommentData(int orderId)
        {
            if (orderId <= 0) throw new ArgumentException("Select a valid order.");
            bllVendors vendors = new bllVendors();
            Dictionary<string, object> order = First(vendors.GetOrderByID_VM(orderId));
            return new
            {
                OrderNo = Pick(order, "ClientOrderNo", "OrderNo", "OrderNumber"),
                OrderDate = Pick(order, "OrderDate", "Orderdate"),
                VM = Pick(order, "VM", "VMName"),
                Abstractor = Pick(order, "Abstractor", "AbstractorName"),
                Comments = Rows(vendors.GetAllCommentOrderwise_VM(orderId))
            };
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> SaveComment(int orderId, string type, string comment)
        {
            if (orderId <= 0) throw new ArgumentException("Select a valid order.");
            if (string.IsNullOrWhiteSpace(type) || type.Equals("Select", StringComparison.OrdinalIgnoreCase))
                throw new ArgumentException("Please select Type.");
            if (string.IsNullOrWhiteSpace(comment)) throw new ArgumentException("Please Enter Remark.");

            Hashtable values = new Hashtable();
            values["OrderId"] = orderId;
            values["Type"] = type.Trim();
            values["Comment"] = comment.Trim();
            values["AddedBy"] = CurrentUserId();

            bllVendors vendors = new bllVendors();
            if (vendors.InsertFollowUp(values) <= 0)
                throw new InvalidOperationException("Comment was not saved.");
            return Rows(vendors.GetAllCommentOrderwise_VM(orderId));
        }

        private static DataTable ExecuteThreeParameterReport(
            string procedure,
            string project,
            string fromDate,
            string toDate)
        {
            using (SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, procedure))
            {
                SQLHelper.AddParamToSQLCmd(command, "@ProjectNumber", SqlDbType.NVarChar, 1000,
                    ParameterDirection.Input, project);
                SQLHelper.AddParamToSQLCmd(command, "@CurrentDate", SqlDbType.NVarChar, 1000,
                    ParameterDirection.Input, fromDate);
                SQLHelper.AddParamToSQLCmd(command, "@ToDate", SqlDbType.NVarChar, 1000,
                    ParameterDirection.Input, toDate);
                return SQLHelper.ExecuteDataTableCmd(command);
            }
        }

        private static DataTable ExecuteTrackingReport(
            string procedure,
            string fromDate,
            string toDate,
            string project,
            int? userId)
        {
            using (SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, procedure))
            {
                SQLHelper.AddParamToSQLCmd(command, "@FromDate", SqlDbType.NVarChar, 1000,
                    ParameterDirection.Input, fromDate);
                SQLHelper.AddParamToSQLCmd(command, "@ToDate", SqlDbType.NVarChar, 1000,
                    ParameterDirection.Input, toDate);
                SQLHelper.AddParamToSQLCmd(command, "@ProjectNo", SqlDbType.NVarChar, 1000,
                    ParameterDirection.Input, project);
                if (userId.HasValue)
                    SQLHelper.AddParamToSQLCmd(command, "@UserId", SqlDbType.BigInt, 0,
                        ParameterDirection.Input, userId.Value);
                return SQLHelper.ExecuteDataTableCmd(command);
            }
        }

        private static DataTable ExecuteOrderReport(string procedure, int orderId)
        {
            using (SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, procedure))
            {
                SQLHelper.AddParamToSQLCmd(command, "@OrderID", SqlDbType.BigInt, 0,
                    ParameterDirection.Input, orderId);
                return SQLHelper.ExecuteDataTableCmd(command);
            }
        }

        private static void AddTaskAssignedId(DataTable table)
        {
            if (table == null) return;
            if (!table.Columns.Contains("TaskAssignedId"))
                table.Columns.Add("TaskAssignedId", typeof(int));

            bllVendors vendors = new bllVendors();
            foreach (DataRow row in table.Rows)
            {
                int orderId;
                if (!TryGetOrderId(row, out orderId)) continue;
                DataTable current = vendors.GetUserofCurrentProcess(orderId);
                if (current != null && current.Rows.Count > 0 && current.Columns.Contains("TaskAssignedId") &&
                    current.Rows[0]["TaskAssignedId"] != DBNull.Value)
                    row["TaskAssignedId"] = Convert.ToInt32(current.Rows[0]["TaskAssignedId"]);
            }
        }

        private static bool TryGetOrderId(DataRow row, out int orderId)
        {
            orderId = 0;
            string[] names = { "OrderId", "OrderID", "TaskId" };
            foreach (string name in names)
            {
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value &&
                    int.TryParse(Convert.ToString(row[name]), out orderId))
                    return true;
            }
            return false;
        }

        private static void ValidateReportFilters(
            string project,
            string fromDate,
            string toDate,
            out DateTime from,
            out DateTime to)
        {
            if (string.IsNullOrWhiteSpace(project) || project.Equals("Select", StringComparison.OrdinalIgnoreCase))
                throw new ArgumentException("Please select a project.");
            from = ParseDate(fromDate);
            to = ParseDate(toDate);
            if (from > to) throw new ArgumentException("From Date should be less than or equal to To Date.");
            if (to.Date > DateTime.Today) throw new ArgumentException("To Date cannot be greater than today.");
        }

        private static DateTime ParseDate(string value)
        {
            DateTime result;
            string[] formats = { "yyyy-MM-dd", "dd-MMM-yyyy", "dd/MM/yyyy", "MM/dd/yyyy" };
            if (!DateTime.TryParseExact(value, formats, CultureInfo.InvariantCulture,
                DateTimeStyles.AllowWhiteSpaces, out result))
                throw new ArgumentException("Please select valid From Date and To Date.");
            return result;
        }

        private static int CurrentUserId()
        {
            int userId;
            if (!int.TryParse(Convert.ToString(HttpContext.Current.User.Identity.Name), out userId))
                throw new InvalidOperationException("The logged-in employee could not be identified.");
            return userId;
        }

        private static List<Dictionary<string, object>> Rows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow source in table.Rows)
            {
                Dictionary<string, object> row =
                    new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                    row[column.ColumnName] = source[column] == DBNull.Value ? null : source[column];
                rows.Add(row);
            }
            return rows;
        }

        private static Dictionary<string, object> First(DataTable table)
        {
            List<Dictionary<string, object>> rows = Rows(table);
            return rows.Count == 0
                ? new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase)
                : rows[0];
        }

        private static object Pick(Dictionary<string, object> row, params string[] names)
        {
            foreach (string name in names)
                if (row.ContainsKey(name)) return row[name];
            return null;
        }

        private void DownloadAttachment(string suppliedPath)
        {
            if (string.IsNullOrWhiteSpace(suppliedPath))
                throw new InvalidOperationException("Attachment path is missing.");

            string filePath;
            if (Path.IsPathRooted(suppliedPath))
                filePath = Path.GetFullPath(suppliedPath);
            else
            {
                string normalized = suppliedPath.Replace('/', '\\');
                if (!normalized.StartsWith("~\\", StringComparison.OrdinalIgnoreCase))
                    normalized = "~\\" + normalized.TrimStart('\\');
                filePath = Path.GetFullPath(Server.MapPath(normalized));
            }

            string[] allowedRoots =
            {
                Path.GetFullPath(Server.MapPath("~/OSTAttachment")),
                Path.GetFullPath(Server.MapPath("~/Vendor")),
                Path.GetFullPath(Server.MapPath("~/Search"))
            };
            bool allowed = false;
            foreach (string root in allowedRoots)
            {
                if (filePath.StartsWith(root + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase))
                {
                    allowed = true;
                    break;
                }
            }
            if (!allowed || !File.Exists(filePath))
                throw new FileNotFoundException("Attachment was not found.");

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition",
                "attachment; filename=\"" + Path.GetFileName(filePath).Replace("\"", string.Empty) + "\"");
            Response.TransmitFile(filePath);
            Response.Flush();
            Context.ApplicationInstance.CompleteRequest();
        }

        private void DownloadTrackingAttachment(int orderId, int attachmentIndex)
        {
            if (orderId <= 0 || attachmentIndex < 0)
                throw new ArgumentException("Invalid attachment request.");

            DataTable attachments =
                ExecuteOrderReport("usp_OST_GetOrderDetailsProcesswise_VM", orderId);
            if (attachments == null || attachmentIndex >= attachments.Rows.Count ||
                !attachments.Columns.Contains("Path"))
                throw new FileNotFoundException("Attachment was not found.");

            DataRow attachment = attachments.Rows[attachmentIndex];
            string storedPath = Convert.ToString(attachment["Path"]);
            if (string.IsNullOrWhiteSpace(storedPath) && attachments.Columns.Contains("OrdersheetPath"))
                storedPath = Convert.ToString(attachment["OrdersheetPath"]);
            if (string.IsNullOrWhiteSpace(storedPath))
            {
                int processId = 0;
                if (attachments.Columns.Contains("ProcessId") && attachment["ProcessId"] != DBNull.Value)
                    int.TryParse(Convert.ToString(attachment["ProcessId"]), out processId);
                if (processId > 0)
                    storedPath = FindLatestProcessAttachment(orderId, processId);
            }
            if (string.IsNullOrWhiteSpace(storedPath))
                throw new FileNotFoundException("Attachment was not found.");

            string filePath;
            if (Path.IsPathRooted(storedPath))
                filePath = Path.GetFullPath(storedPath);
            else
            {
                string normalized = storedPath.Replace('/', '\\');
                if (!normalized.StartsWith("~\\", StringComparison.OrdinalIgnoreCase))
                    normalized = "~\\" + normalized.TrimStart('\\');
                filePath = Path.GetFullPath(Server.MapPath(normalized));
            }

            if (!File.Exists(filePath))
                throw new FileNotFoundException("Attachment was not found.");

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition",
                "attachment; filename=\"" + Path.GetFileName(filePath).Replace("\"", string.Empty) + "\"");
            Response.TransmitFile(filePath);
            Response.Flush();
            Context.ApplicationInstance.CompleteRequest();
        }

        private static string FindLatestProcessAttachment(int orderId, int processId)
        {
            using (SqlCommand command = SQLHelper.GetCommand(CommandType.Text,
                @"SELECT TOP (1) AttachmentPath
                    FROM
                    (
                        SELECT Path AS AttachmentPath, AddedDate
                        FROM dbo.TitleInternal_OrderAttachment
                        WHERE OrderId = @OrderId
                          AND (@ProcessId = 0 OR Process = @ProcessId)
                          AND NULLIF(LTRIM(RTRIM(Path)), '') IS NOT NULL

                        UNION ALL

                        SELECT Attachment AS AttachmentPath, AddedDate
                        FROM dbo.UploadAndDownloadSearch
                        WHERE OrderId = @OrderId
                          AND (@ProcessId = 0 OR Process = CONVERT(NVARCHAR(20), @ProcessId))
                          AND NULLIF(LTRIM(RTRIM(Attachment)), '') IS NOT NULL
                    ) AS AvailableAttachments
                    ORDER BY AddedDate DESC"))
            {
                SQLHelper.AddParamToSQLCmd(command, "@OrderId", SqlDbType.BigInt, 0,
                    ParameterDirection.Input, orderId);
                SQLHelper.AddParamToSQLCmd(command, "@ProcessId", SqlDbType.Int, 0,
                    ParameterDirection.Input, processId);
                DataTable table = SQLHelper.ExecuteDataTableCmd(command);
                return table.Rows.Count == 0
                    ? string.Empty
                    : Convert.ToString(table.Rows[0]["AttachmentPath"]);
            }
        }
    }
}
