using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Search
{
    public partial class ProcessOrders : System.Web.UI.Page
    {
        static string NewFileName = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                HttpContext postedContext = HttpContext.Current;
                if (string.Equals(
                    postedContext.Request.QueryString["action"],
                    "downloadOrderDetail",
                    StringComparison.OrdinalIgnoreCase))
                {
                    DownloadOrderDetailFile();
                    return;
                }

                if (string.Equals(
                    postedContext.Request.QueryString["action"],
                    "downloadProcessAttachment",
                    StringComparison.OrdinalIgnoreCase))
                {
                    DownloadProcessAttachmentFile();
                    return;
                }

                if (postedContext.Request.Files.Count == 0)
                {
                    return;
                }

                HttpPostedFile file = postedContext.Request.Files[0];
                if (file == null || file.ContentLength == 0)
                {
                    return;
                }

                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0, (int)file.InputStream.Length);

                FileInfo fileInfo = new FileInfo(file.FileName);
                string ext = fileInfo.Extension;
                string fileName = Guid.NewGuid() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;

                NewFileName = Server.MapPath("..//TempFiles//" + fileName);

                using (FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite))
                {
                    objfilestream.Write(binaryWriteArray, 0, binaryWriteArray.Length);
                }
            }
            catch
            {
            }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (string.Equals(
                Request.QueryString["action"],
                "downloadOrderDetail",
                StringComparison.OrdinalIgnoreCase) ||
                string.Equals(
                    Request.QueryString["action"],
                    "downloadProcessAttachment",
                    StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            base.Render(writer);
        }

        [WebMethod]
        public static string GetAllPendingOrders()
        {
            DataTable dt1 = new bllOST().GetAllPendingOrders(int.Parse(HttpContext.Current.User.Identity.Name));
            return SerializeDataTable(dt1);
        }

        [WebMethod]
        public static string GetOrderDetailsReport(int OrderID)
        {
            if (OrderID <= 0)
            {
                return "[]";
            }

            DataTable details = new bllOST().GetOrderDetailsProcesswise(OrderID);
            return SerializeDataTable(details);
        }

        [WebMethod]
        public static string GetOrdersOnProcessForUser(int OrderID)
        {
            if (OrderID <= 0)
            {
                return "[]";
            }

            int userId = int.Parse(HttpContext.Current.User.Identity.Name);
            bllOST ost = new bllOST();
            int processId = GetCurrentProcessId(ost, OrderID, userId);
            if (processId <= 0)
            {
                return "[]";
            }

            DataTable orders = ost.GetOrdersOnProcessForUser(OrderID, userId, processId);
            return SerializeDataTable(orders);
        }

        [WebMethod]
        public static string GetProcessOrderAttachments(int TaskID)
        {
            if (TaskID <= 0)
            {
                return "[]";
            }

            DataTable attachments = new bllOST().GetOrderDetailsProcesswiseAttachment(TaskID);
            return SerializeDataTable(attachments);
        }

        [WebMethod]
        public static string GetTaxDetails(int OrderID)
        {
            if (OrderID <= 0)
            {
                return "[]";
            }

            DataTable details = new bllVendors().BindTaxDetails(OrderID);
            return SerializeDataTable(details);
        }

        [WebMethod]
        public static ProcessOrderResponse SaveTaxDetails(TaxDetailsRequest request)
        {
            try
            {
                if (request == null || request.OrderID <= 0)
                {
                    return BuildResponse(false, "Please select a valid order.");
                }

                if (string.IsNullOrWhiteSpace(request.Remark))
                {
                    return BuildResponse(false, "Please enter remark.");
                }

                string validationMessage = ValidateTaxDetails(request);
                if (!string.IsNullOrEmpty(validationMessage))
                {
                    return BuildResponse(false, validationMessage);
                }

                Hashtable taxDetails = new Hashtable();
                taxDetails["OrderID"] = request.OrderID;
                taxDetails["FirstBaseAmount"] = CleanTaxValue(request.FirstBaseAmount);
                taxDetails["SecondBaseAmount"] = CleanTaxValue(request.SecondBaseAmount);
                taxDetails["ThirdBaseAmount"] = CleanTaxValue(request.ThirdBaseAmount);
                taxDetails["FourthBaseAmount"] = CleanTaxValue(request.FourthBaseAmount);
                taxDetails["FirstPaidAmount"] = CleanTaxValue(request.FirstPaidAmount);
                taxDetails["SecondPaidAmount"] = CleanTaxValue(request.SecondPaidAmount);
                taxDetails["ThirdPaidAmount"] = CleanTaxValue(request.ThirdPaidAmount);
                taxDetails["FourthPaidAmount"] = CleanTaxValue(request.FourthPaidAmount);
                taxDetails["FirstPaidDate"] = CleanTaxValue(request.FirstPaidDate);
                taxDetails["SecondPaidDate"] = CleanTaxValue(request.SecondPaidDate);
                taxDetails["ThirdPaidDate"] = CleanTaxValue(request.ThirdPaidDate);
                taxDetails["FourthPaidDate"] = CleanTaxValue(request.FourthPaidDate);
                taxDetails["FirstDueAmount"] = CleanTaxValue(request.FirstDueAmount);
                taxDetails["SecondDueAmount"] = CleanTaxValue(request.SecondDueAmount);
                taxDetails["ThirdDueAmount"] = CleanTaxValue(request.ThirdDueAmount);
                taxDetails["FourthDueAmount"] = CleanTaxValue(request.FourthDueAmount);
                taxDetails["FirstDueDate"] = CleanTaxValue(request.FirstDueDate);
                taxDetails["SecondDueDate"] = CleanTaxValue(request.SecondDueDate);
                taxDetails["ThirdDueDate"] = CleanTaxValue(request.ThirdDueDate);
                taxDetails["FourthDueDate"] = CleanTaxValue(request.FourthDueDate);
                taxDetails["FirstPenalty"] = CleanTaxValue(request.FirstPenalty);
                taxDetails["SecondPenalty"] = CleanTaxValue(request.SecondPenalty);
                taxDetails["ThirdPenalty"] = CleanTaxValue(request.ThirdPenalty);
                taxDetails["FourthPenalty"] = CleanTaxValue(request.FourthPenalty);
                taxDetails["FirstDelinquency"] = NormalizeDelinquency(request.FirstDelinquency);
                taxDetails["SecondDelinquency"] = NormalizeDelinquency(request.SecondDelinquency);
                taxDetails["ThirdDelinquency"] = NormalizeDelinquency(request.ThirdDelinquency);
                taxDetails["FourthDelinquency"] = NormalizeDelinquency(request.FourthDelinquency);
                taxDetails["Remark"] = request.Remark.Trim();
                taxDetails["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name);

                int returnValue = new bllOST().InsertInfinity_OST_TaxDetails(taxDetails);
                return returnValue > 0
                    ? BuildResponse(true, "Tax details saved successfully.", returnValue)
                    : BuildResponse(false, "Tax details were not saved.", returnValue);
            }
            catch (Exception ex)
            {
                return BuildResponse(false, "Tax details were not saved. " + ex.Message);
            }
        }

        [WebMethod]
        public static ProcessOrderResponse AddOrderCosting(int OrderID, string SearchEngineType, string SearchEngineLink, int NoOfSearches, decimal CostPerSearch, decimal TotalCost, string Remark)
        {
            try
            {
                if (OrderID <= 0)
                {
                    return BuildResponse(false, "Please select a valid order.");
                }

                if (string.IsNullOrWhiteSpace(SearchEngineType))
                {
                    return BuildResponse(false, "Please select search engine type.");
                }

                if (string.IsNullOrWhiteSpace(SearchEngineLink))
                {
                    return BuildResponse(false, "Please enter search engine link.");
                }

                int addedBy = int.Parse(HttpContext.Current.User.Identity.Name);
                bllOST ost = new bllOST();
                int processId = GetCurrentProcessId(ost, OrderID, addedBy);
                if (processId <= 0)
                {
                    return BuildResponse(false, "Unable to identify current process for selected order.");
                }

                decimal total = TotalCost > 0 ? TotalCost : (NoOfSearches * CostPerSearch);
                Hashtable htSheet = BuildDefaultCostingParameters();
                htSheet["OrderID"] = OrderID;
                htSheet["ProcessID"] = processId;
                htSheet["SearchEngineType"] = SearchEngineType.Trim();
                htSheet["SearchEngineLink"] = SearchEngineLink.Trim();
                htSheet["SearchCostNoOfSearches"] = NoOfSearches;
                htSheet["SearchCostCost"] = CostPerSearch;
                htSheet["SearchCostTotal"] = total;
                htSheet["ProductionCost"] = total;
                htSheet["TotalCost"] = total;
                htSheet["Remark"] = (Remark ?? string.Empty).Trim();
                htSheet["AddedBy"] = addedBy;

                int returnValue = ost.InsertProductionManualCosting(htSheet);
                return returnValue > 0
                    ? BuildResponse(true, "Order costing added successfully.", returnValue)
                    : BuildResponse(false, "Order costing not added.", returnValue);
            }
            catch (Exception ex)
            {
                return BuildResponse(false, "Order costing not added. " + ex.Message);
            }
        }

        [WebMethod]
        public static ProcessOrderResponse CompleteOrder(int OrderID, List<int> TaskIDs, string ClientOrderNo, string ProjectNumber, string ProcessName, string ActionStatus, string Remark, string AttachmentOriginalName, bool DispatchOrder, bool NoFeedback, bool TaxCalling, bool Audit, bool Offline)
        {
            try
            {
                if (OrderID <= 0)
                {
                    return BuildResponse(false, "Please select a valid order.");
                }

                if (TaskIDs == null || TaskIDs.Count == 0)
                {
                    return BuildResponse(false, "Please select at least one current process order.");
                }

                if (string.IsNullOrWhiteSpace(Remark))
                {
                    return BuildResponse(false, "Please enter remark.");
                }

                if (string.IsNullOrWhiteSpace(AttachmentOriginalName))
                {
                    return BuildResponse(false, "Please choose file.");
                }

                if (TaxCalling && Audit)
                {
                    return BuildResponse(false, "Unable to complete the process. It should be either Tax Calling or Audit Process.");
                }

                int addedBy = int.Parse(HttpContext.Current.User.Identity.Name);
                bllOST ost = new bllOST();
                bllMaster master = new bllMaster();

                DataTable currentProcess = ost.GetCurrentProcessOfUser(OrderID, addedBy);
                if (currentProcess == null || currentProcess.Rows.Count == 0)
                {
                    return BuildResponse(false, "Unable to identify current process for selected order.");
                }

                DataRow processRow = currentProcess.Rows[0];
                int processId = GetInt(processRow, "Processid", "ProcessId", "TaskProcessid", "TaskProcessID");
                string currentProcessName = FirstNotEmpty(GetString(processRow, "ProcessName", "Process"), ProcessName, processId.ToString());
                if (processId <= 0)
                {
                    return BuildResponse(false, "Unable to identify current process for selected order.");
                }

                if (!IsCostingExempt(ProjectNumber))
                {
                    int isCosting = ost.ValidateCostingProcessWise(OrderID, processId);
                    if (isCosting == 0)
                    {
                        return BuildResponse(false, "Unable to complete the process. Costing is pending.");
                    }
                }

                DataTable tasks = ost.GetOrdersOnProcessForUser(OrderID, addedBy, processId);
                if (tasks == null || tasks.Rows.Count == 0)
                {
                    return BuildResponse(false, "No task rows found for the selected order/process.");
                }

                HashSet<int> selectedTaskIds = new HashSet<int>(TaskIDs);

                int taskStatus = GetTaskStatus(ActionStatus);
                ValidateUploadedAttachment(ClientOrderNo, AttachmentOriginalName);
                int returnValue = -1;
                bool anyUpdated = false;

                foreach (DataRow task in tasks.Rows)
                {
                    int taskId = GetInt(task, "Taskid", "TaskId");
                    if (taskId <= 0 || !selectedTaskIds.Contains(taskId))
                    {
                        continue;
                    }

                    string projectName = FirstNotEmpty(GetString(task, "Project", "ProjectNumber"), ProjectNumber);
                    string projectId = master.ValidateProject(projectName);
                    if (projectId == "0")
                    {
                        continue;
                    }

                    string employeeCode = ost.GetCodeFromEmployeeId(addedBy.ToString(), ClientOrderNo, projectName);
                    string employeeHadProjectRights = master.ValidateUserProjectRights(employeeCode, projectId);
                    if (employeeHadProjectRights == "0")
                    {
                        return BuildResponse(false, projectName + " Project is not assigned to you. Please contact your Reporting Manager/Project Manager.");
                    }

                    Hashtable htParam = new Hashtable();
                    htParam["TaskId"] = taskId;
                    htParam["TaskStatus"] = taskStatus;
                    htParam["TaskAssignedId"] = 0;
                    htParam["Remark"] = Remark.Trim();
                    htParam["TaxProcess"] = ShouldSendTaxProcess(processId, TaxCalling) ? 1 : 0;
                    htParam["AuditProcess"] = processId == 2 && Audit ? 1 : 0;
                    htParam["OfflineProcess"] = (processId == 2 || processId == 11) && Offline ? 1 : 0;

                    returnValue = ost.UpdateTaskStatusAndDate(htParam);
                    anyUpdated = anyUpdated || returnValue > 0;
                }

                if (!anyUpdated)
                {
                    return BuildResponse(false, "Process was not completed. No task row was updated.", returnValue);
                }

                string attachmentPath = SaveUploadedAttachment(OrderID, ClientOrderNo, currentProcessName, AttachmentOriginalName);
                InsertCompletionComments(ost, OrderID, processId, currentProcessName, taskStatus, addedBy, TaxCalling, Audit, Offline);
                InsertAttachment(ost, OrderID, processId, taskStatus, attachmentPath, addedBy);

                if (DispatchOrder)
                {
                    DispatchCompletedOrder(ost, OrderID, Remark, addedBy);
                }

                if ((processId == 2 || processId == 11 || processId == 5) && NoFeedback)
                {
                    InsertNoFeedback(ost, OrderID, ClientOrderNo, ProjectNumber, processId.ToString(), addedBy);
                }

                ResetUploadedFile();
                return BuildResponse(true, "Process completed successfully.", returnValue);
            }
            catch (Exception ex)
            {
                return BuildResponse(false, "Process not completed. " + ex.Message);
            }
        }

        private static string ValidateTaxDetails(TaxDetailsRequest request)
        {
            string[] amountValues =
            {
                request.FirstBaseAmount, request.SecondBaseAmount, request.ThirdBaseAmount, request.FourthBaseAmount,
                request.FirstPaidAmount, request.SecondPaidAmount, request.ThirdPaidAmount, request.FourthPaidAmount,
                request.FirstDueAmount, request.SecondDueAmount, request.ThirdDueAmount, request.FourthDueAmount,
                request.FirstPenalty, request.SecondPenalty, request.ThirdPenalty, request.FourthPenalty
            };

            foreach (string amountValue in amountValues)
            {
                string value = CleanTaxValue(amountValue);
                if (string.IsNullOrEmpty(value))
                {
                    continue;
                }

                decimal amount;
                bool validAmount =
                    decimal.TryParse(value, NumberStyles.Number, CultureInfo.InvariantCulture, out amount) ||
                    decimal.TryParse(value, NumberStyles.Number, CultureInfo.CurrentCulture, out amount);
                if (!validAmount || amount < 0)
                {
                    return "Please enter valid non-negative tax amounts.";
                }
            }

            string[] dateValues =
            {
                request.FirstPaidDate, request.SecondPaidDate, request.ThirdPaidDate, request.FourthPaidDate,
                request.FirstDueDate, request.SecondDueDate, request.ThirdDueDate, request.FourthDueDate
            };

            foreach (string dateValue in dateValues)
            {
                string value = CleanTaxValue(dateValue);
                if (string.IsNullOrEmpty(value))
                {
                    continue;
                }

                DateTime parsedDate;
                if (!DateTime.TryParseExact(
                    value,
                    "dd-MMM-yyyy",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out parsedDate))
                {
                    return "Please enter tax dates in DD-MMM-YYYY format.";
                }
            }

            return string.Empty;
        }

        private static string CleanTaxValue(string value)
        {
            return (value ?? string.Empty).Trim();
        }

        private static string NormalizeDelinquency(string value)
        {
            string normalized = CleanTaxValue(value);
            return string.Equals(normalized, "Yes", StringComparison.OrdinalIgnoreCase)
                ? "Yes"
                : string.Equals(normalized, "No", StringComparison.OrdinalIgnoreCase)
                    ? "No"
                    : "Select";
        }

        private static string SerializeDataTable(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }

                    rows.Add(row);
                }
            }

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        private void DownloadOrderDetailFile()
        {
            int orderId;
            if (!int.TryParse(Request.QueryString["orderId"], out orderId) || orderId <= 0)
            {
                throw new InvalidOperationException("Invalid order.");
            }

            string columnName = Request.QueryString["column"];
            if (columnName != "Path" && columnName != "OrdersheetPath")
            {
                throw new InvalidOperationException("Invalid document type.");
            }

            string requestedPath = Request.QueryString["path"] ?? string.Empty;
            DataTable details = new bllOST().GetOrderDetailsProcesswise(orderId);
            bool pathBelongsToOrder = false;
            if (details != null && details.Columns.Contains(columnName))
            {
                foreach (DataRow row in details.Rows)
                {
                    if (string.Equals(
                        Convert.ToString(row[columnName]),
                        requestedPath,
                        StringComparison.OrdinalIgnoreCase))
                    {
                        pathBelongsToOrder = true;
                        break;
                    }
                }
            }

            if (!pathBelongsToOrder || string.IsNullOrWhiteSpace(requestedPath))
            {
                throw new FileNotFoundException("Document was not found for the selected order.");
            }

            string physicalPath;
            if (requestedPath.StartsWith("~"))
            {
                physicalPath = Server.MapPath(requestedPath.Replace('\\', '/'));
            }
            else if (Path.IsPathRooted(requestedPath))
            {
                physicalPath = requestedPath;
            }
            else
            {
                physicalPath = Server.MapPath(
                    "~/" + requestedPath.TrimStart('/', '\\').Replace('\\', '/'));
            }

            if (!File.Exists(physicalPath))
            {
                throw new FileNotFoundException("Document was not found on the server.");
            }

            Response.Clear();
            Response.ContentType = MimeMapping.GetMimeMapping(physicalPath);
            Response.AddHeader(
                "Content-Disposition",
                "attachment; filename=\"" + Path.GetFileName(physicalPath).Replace("\"", string.Empty) + "\"");
            Response.TransmitFile(physicalPath);
            Response.Flush();
            Context.ApplicationInstance.CompleteRequest();
        }

        private void DownloadProcessAttachmentFile()
        {
            int taskId;
            if (!int.TryParse(Request.QueryString["taskId"], out taskId) || taskId <= 0)
            {
                throw new InvalidOperationException("Invalid task.");
            }

            string requestedPath = Request.QueryString["path"] ?? string.Empty;
            DataTable attachments = new bllOST().GetOrderDetailsProcesswiseAttachment(taskId);
            bool pathBelongsToTask = false;
            if (attachments != null && attachments.Columns.Contains("Path"))
            {
                foreach (DataRow row in attachments.Rows)
                {
                    if (string.Equals(
                        Convert.ToString(row["Path"]),
                        requestedPath,
                        StringComparison.OrdinalIgnoreCase))
                    {
                        pathBelongsToTask = true;
                        break;
                    }
                }
            }

            if (!pathBelongsToTask || string.IsNullOrWhiteSpace(requestedPath))
            {
                throw new FileNotFoundException("Attachment was not found for the selected task.");
            }

            string physicalPath;
            if (requestedPath.StartsWith("~"))
            {
                physicalPath = Server.MapPath(requestedPath.Replace('\\', '/'));
            }
            else if (Path.IsPathRooted(requestedPath))
            {
                physicalPath = requestedPath;
            }
            else
            {
                physicalPath = Server.MapPath(
                    "~/" + requestedPath.TrimStart('/', '\\').Replace('\\', '/'));
            }

            if (!File.Exists(physicalPath))
            {
                throw new FileNotFoundException("Attachment was not found on the server.");
            }

            Response.Clear();
            Response.ContentType = MimeMapping.GetMimeMapping(physicalPath);
            Response.AddHeader(
                "Content-Disposition",
                "attachment; filename=\"" + Path.GetFileName(physicalPath).Replace("\"", string.Empty) + "\"");
            Response.TransmitFile(physicalPath);
            Response.Flush();
            Context.ApplicationInstance.CompleteRequest();
        }

        private static ProcessOrderResponse BuildResponse(bool success, string message, int returnValue = 0, string redirectUrl = "")
        {
            return new ProcessOrderResponse
            {
                Success = success,
                Message = message,
                ReturnValue = returnValue,
                RedirectUrl = redirectUrl
            };
        }

        private static int GetCurrentProcessId(bllOST ost, int orderId, int addedBy)
        {
            DataTable currentProcess = ost.GetCurrentProcessOfUser(orderId, addedBy);
            if (currentProcess == null || currentProcess.Rows.Count == 0)
            {
                return 0;
            }

            return GetInt(currentProcess.Rows[0], "Processid", "ProcessId", "TaskProcessid", "TaskProcessID");
        }

        private static Hashtable BuildDefaultCostingParameters()
        {
            Hashtable htSheet = new Hashtable();
            htSheet["OrderID"] = 0;
            htSheet["ProcessID"] = 0;
            htSheet["SearchEngineType"] = string.Empty;
            htSheet["SearchEngineLink"] = string.Empty;
            htSheet["SearchCostNoOfSearches"] = 0;
            htSheet["SearchCostCost"] = 0m;
            htSheet["SearchCostTotal"] = 0m;
            htSheet["SearchCopyCostPattern"] = string.Empty;
            htSheet["SearchCopyCostDocsType"] = string.Empty;
            htSheet["SearchCopyCostPagesDocsMain"] = 0;
            htSheet["SearchCopyCostCostMain"] = 0m;
            htSheet["SearchCopyCostTotalMain"] = 0m;
            htSheet["SearchCopyCostPagesDocs"] = 0;
            htSheet["SearchCopyCostCost"] = 0m;
            htSheet["SearchCopyCostTotal"] = 0m;
            htSheet["JudgmentSearchCostNoOfSeraches"] = 0;
            htSheet["JudgmentSearchCostCost"] = 0m;
            htSheet["JudgmentSearchCostTotal"] = 0m;
            htSheet["JudgmentCopyCostPattern"] = string.Empty;
            htSheet["JudgmentCopyCostDocsType"] = string.Empty;
            htSheet["JudgmentCopyCostPagesDocsMain"] = 0;
            htSheet["JudgmentCopyCostCostMain"] = 0m;
            htSheet["JudgmentCopyCostTotalMain"] = 0m;
            htSheet["JudgmentCopyCostPagesDocs"] = 0;
            htSheet["JudgmentCopyCostCost"] = 0m;
            htSheet["JudgmentCopyCostTotal"] = 0m;
            htSheet["JudgementSearchLink"] = string.Empty;
            htSheet["TaxChargesDescription"] = string.Empty;
            htSheet["TaxAmount"] = 0m;
            htSheet["OtherChargesDescription"] = string.Empty;
            htSheet["OtherChargesAmount"] = 0m;
            htSheet["ProductionCost"] = 0m;
            htSheet["Remark"] = string.Empty;
            htSheet["NoOfDocuments"] = 0;
            htSheet["NoOfPages"] = 0;
            htSheet["TaxInformation"] = string.Empty;
            htSheet["CalledTaxes"] = string.Empty;
            htSheet["Attachment"] = string.Empty;
            htSheet["SnippingTools"] = string.Empty;
            htSheet["PagesDeliverToClient"] = 0;
            htSheet["TotalCost"] = 0m;
            htSheet["AddedBy"] = 0;
            return htSheet;
        }

        private static int GetTaskStatus(string actionStatus)
        {
            if (string.Equals(actionStatus, "Cancel", StringComparison.OrdinalIgnoreCase))
            {
                return 5;
            }

            if (string.Equals(actionStatus, "Hold", StringComparison.OrdinalIgnoreCase))
            {
                return 4;
            }

            return 2;
        }

        private static bool ShouldSendTaxProcess(int processId, bool taxCalling)
        {
            return taxCalling && (processId == 1 || processId == 2 || processId == 11);
        }

        private static bool IsCostingExempt(string projectNumber)
        {
            string[] exemptProjects = { "415", "483", "380-001", "380-003", "591-003", "187", "574-003", "183-003" };
            foreach (string project in exemptProjects)
            {
                if (string.Equals(project, projectNumber, StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }
            }

            return false;
        }

        private static string SaveUploadedAttachment(int orderId, string clientOrderNo, string processName, string attachmentOriginalName)
        {
            ValidateUploadedAttachment(clientOrderNo, attachmentOriginalName);

            string originalFileName = Path.GetFileName(attachmentOriginalName);
            string processFolder = CleanPathSegment(processName);
            string dateFolder = DateTime.Now.ToString("dd-MMM-yyyy");
            string relativeFolder = "~\\OSTAttachment\\" + processFolder + "\\" + dateFolder + "\\" + orderId;
            string physicalFolder = HttpContext.Current.Server.MapPath(relativeFolder);
            Directory.CreateDirectory(physicalFolder);

            string destinationPath = Path.Combine(physicalFolder, originalFileName);
            File.Copy(NewFileName, destinationPath, true);
            return relativeFolder + "\\" + originalFileName;
        }

        private static void ValidateUploadedAttachment(string clientOrderNo, string attachmentOriginalName)
        {
            if (string.IsNullOrWhiteSpace(NewFileName) || !File.Exists(NewFileName))
            {
                throw new InvalidOperationException("Please choose file.");
            }

            string originalFileName = Path.GetFileName(attachmentOriginalName);
            if (string.IsNullOrWhiteSpace(originalFileName))
            {
                throw new InvalidOperationException("Please choose file.");
            }

            string originalOrderNo = Path.GetFileNameWithoutExtension(originalFileName);
            if (!string.Equals((clientOrderNo ?? string.Empty).Trim(), originalOrderNo, StringComparison.OrdinalIgnoreCase))
            {
                throw new InvalidOperationException("The selected file name does not match with the order no.");
            }
        }

        private static string CleanPathSegment(string value)
        {
            string safe = string.IsNullOrWhiteSpace(value) ? "Process" : value.Trim();
            foreach (char invalidChar in Path.GetInvalidFileNameChars())
            {
                safe = safe.Replace(invalidChar, '_');
            }

            return safe;
        }

        private static void InsertCompletionComments(bllOST ost, int orderId, int processId, string processName, int taskStatus, int addedBy, bool taxCalling, bool audit, bool offline)
        {
            string comment = processName + " Process Completed by User";
            ost.InsertCommentOrder(orderId, processId, "Auto", comment, addedBy);

            if (taskStatus == 5)
            {
                ost.InsertCommentOrder(orderId, processId, "Auto", "Order is Cancelled by User", addedBy);
            }

            if (taskStatus == 4)
            {
                ost.InsertCommentOrder(orderId, processId, "Auto", "Order is on Hold by User", addedBy);
            }

            if (taxCalling)
            {
                ost.InsertCommentOrder(orderId, processId, "Auto", "Order has been send to Tax Calling by User", addedBy);
            }

            if (offline)
            {
                ost.InsertCommentOrder(orderId, processId, "Auto", "Order has been send to Offline by User", addedBy);
            }

            if (audit)
            {
                ost.InsertCommentOrder(orderId, processId, "Auto", "Order has been send to Audit Process by User", addedBy);
            }
        }

        private static void InsertAttachment(bllOST ost, int orderId, int processId, int taskStatus, string attachmentPath, int addedBy)
        {
            if (string.IsNullOrWhiteSpace(attachmentPath))
            {
                return;
            }

            Hashtable htAttach = new Hashtable();
            htAttach["OrderId"] = orderId;
            htAttach["Process"] = processId;
            htAttach["DocId"] = taskStatus;
            htAttach["Path"] = attachmentPath;
            htAttach["PathFrom"] = "Process Completed";
            htAttach["AddedBy"] = addedBy;
            ost.InsertOrderAttachment(htAttach);
        }

        private static void DispatchCompletedOrder(bllOST ost, int orderId, string remark, int addedBy)
        {
            Hashtable htSheet = new Hashtable();
            htSheet["OrderId"] = orderId;
            htSheet["TaskTemplateid"] = 0;
            htSheet["TaskAssignedId"] = addedBy;
            htSheet["Remark"] = (remark ?? string.Empty).Trim();
            htSheet["AdddedBy"] = addedBy;

            int returnValue = ost.DispatchOrderTask(htSheet);
            if (returnValue > 0)
            {
                ost.InsertCommentOrder(orderId, 6, "Auto", "Order is Dispatched", addedBy);
            }
        }

        private static void InsertNoFeedback(bllOST ost, int orderId, string orderNo, string projectName, string processName, int addedBy)
        {
            Hashtable htSheet = new Hashtable();
            htSheet["OrderNo"] = orderNo;
            htSheet["ProjectName"] = projectName;
            htSheet["ProcessName"] = processName;
            htSheet["AddedBy"] = addedBy;
            htSheet["OrderId"] = orderId;
            ost.FeedBackOrders(htSheet);
        }

        private static void ResetUploadedFile()
        {
            NewFileName = string.Empty;
        }

        private static string GetString(DataRow row, params string[] columns)
        {
            foreach (string column in columns)
            {
                if (row.Table.Columns.Contains(column) && row[column] != DBNull.Value)
                {
                    return Convert.ToString(row[column]);
                }
            }

            return string.Empty;
        }

        private static int GetInt(DataRow row, params string[] columns)
        {
            foreach (string column in columns)
            {
                if (row.Table.Columns.Contains(column) && row[column] != DBNull.Value)
                {
                    int value;
                    if (int.TryParse(Convert.ToString(row[column]), out value))
                    {
                        return value;
                    }
                }
            }

            return 0;
        }

        private static string FirstNotEmpty(params string[] values)
        {
            foreach (string value in values)
            {
                if (!string.IsNullOrWhiteSpace(value))
                {
                    return value.Trim();
                }
            }

            return string.Empty;
        }

        public class ProcessOrderResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public int ReturnValue { get; set; }
            public string RedirectUrl { get; set; }
        }

        public class TaxDetailsRequest
        {
            public int OrderID { get; set; }
            public string FirstBaseAmount { get; set; }
            public string SecondBaseAmount { get; set; }
            public string ThirdBaseAmount { get; set; }
            public string FourthBaseAmount { get; set; }
            public string FirstPaidAmount { get; set; }
            public string SecondPaidAmount { get; set; }
            public string ThirdPaidAmount { get; set; }
            public string FourthPaidAmount { get; set; }
            public string FirstPaidDate { get; set; }
            public string SecondPaidDate { get; set; }
            public string ThirdPaidDate { get; set; }
            public string FourthPaidDate { get; set; }
            public string FirstDueAmount { get; set; }
            public string SecondDueAmount { get; set; }
            public string ThirdDueAmount { get; set; }
            public string FourthDueAmount { get; set; }
            public string FirstDueDate { get; set; }
            public string SecondDueDate { get; set; }
            public string ThirdDueDate { get; set; }
            public string FourthDueDate { get; set; }
            public string FirstPenalty { get; set; }
            public string SecondPenalty { get; set; }
            public string ThirdPenalty { get; set; }
            public string FourthPenalty { get; set; }
            public string FirstDelinquency { get; set; }
            public string SecondDelinquency { get; set; }
            public string ThirdDelinquency { get; set; }
            public string FourthDelinquency { get; set; }
            public string Remark { get; set; }
        }
    }
}
