using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Search
{
    public partial class Costing : Page
    {
        static int AddedBy;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrWhiteSpace(Request.QueryString["downloadAttachment"]))
            {
                DownloadCostingAttachment(Request.QueryString["downloadAttachment"]);
                return;
            }

            if (string.Equals(Request.QueryString["uploadInvoice"], "1", StringComparison.OrdinalIgnoreCase))
            {
                UploadInvoiceAttachment();
            }

            AddedBy = Convert.ToInt32(EmployeeInfo.Current.EmployeeID);       
        }

        [WebMethod]
        public static CostingOrdersResponse GetOrders()
        {
            try
            {
                int employeeId = AddedBy;
                DataTable dt = new bllOST().GetAllInfinityOrderbyEmp(employeeId);
                List<CostingOrderOption> orders = new List<CostingOrderOption>();

                foreach (DataRow row in dt.Rows)
                {
                    string orderId = GetString(row, "OrderID", "OrderId");
                    string projectNumber = GetString(row, "ProjectNumber", "Project");
                    string clientOrderNo = GetString(row, "ClientOrderNo", "OrderNo");

                    orders.Add(new CostingOrderOption
                    {
                        Value = orderId,
                        Text = projectNumber + " : " + clientOrderNo,
                        OrderID = orderId,
                        ProjectNumber = projectNumber,
                        ClientOrderNo = clientOrderNo
                    });
                }

                return new CostingOrdersResponse
                {
                    Success = true,
                    Message = string.Empty,
                    Orders = orders
                };
            }
            catch (Exception ex)
            {
                return new CostingOrdersResponse
                {
                    Success = false,
                    Message = "Unable to load orders. " + ex.Message,
                    Orders = new List<CostingOrderOption>()
                };
            }
        }

        [WebMethod]
        public static CostingResponse LoadOrderCosting(int OrderID)
        {
            try
            {
                if (OrderID <= 0)
                {
                    return BuildResponse(false, "Please select order.");
                }

                return BuildResponse(true, string.Empty, 0, string.Empty, BuildCostingLoadData(OrderID));
            }
            catch (Exception ex)
            {
                return BuildResponse(false, "Unable to load costing details. " + ex.Message);
            }
        }

        [WebMethod]
        public static CostingResponse SaveProductionCosting(CostingProductionRequest request)
        {
            try
            {
                if (request == null)
                {
                    return BuildResponse(false, "Invalid costing details.");
                }

                string validationMessage = ValidateProductionRequest(request);
                if (!string.IsNullOrWhiteSpace(validationMessage))
                {
                    return BuildResponse(false, validationMessage);
                }

                int addedBy = AddedBy;
                bllOST ost = new bllOST();
                int processId = GetCurrentProcessId(ost, request.OrderID, addedBy);
                if (processId <= 0)
                {
                    return BuildResponse(false, "Unable to identify current process for selected order.");
                }

                NormalizeProductionTotals(request);

                Hashtable htSheet = BuildDefaultCostingParameters();
                htSheet["OrderID"] = request.OrderID;
                htSheet["ProcessID"] = processId;
                htSheet["SearchEngineType"] = TrimToEmpty(request.SearchEngineType);
                htSheet["SearchEngineLink"] = TrimToEmpty(request.SearchEngineLink);
                htSheet["JudgementSearchLink"] = TrimToEmpty(request.JudgementSearchLink);
                htSheet["SearchCostNoOfSearches"] = request.SearchCostNoOfSearches;
                htSheet["SearchCostCost"] = request.SearchCostCost;
                htSheet["SearchCostTotal"] = request.SearchCostTotal;
                htSheet["SearchCopyCostPattern"] = TrimToEmpty(request.SearchCopyCostPattern);

                if (IsVary(request.SearchCopyCostPattern))
                {
                    htSheet["SearchCopyCostDocsType"] = TrimToEmpty(request.VarySearchCopyCostDocsType);
                    htSheet["SearchCopyCostPagesDocs"] = request.VarySearchCopyCostPagesDocs;
                    htSheet["SearchCopyCostCost"] = request.VarySearchCopyCostCost;
                    htSheet["SearchCopyCostTotal"] = request.VarySearchCopyCostTotal;
                }
                else
                {
                    htSheet["SearchCopyCostDocsType"] = TrimToEmpty(request.SearchCopyCostDocsType);
                    htSheet["SearchCopyCostPagesDocs"] = 0;
                    htSheet["SearchCopyCostCost"] = 0m;
                    htSheet["SearchCopyCostTotal"] = 0m;
                }

                htSheet["SearchCopyCostPagesDocsMain"] = request.SearchCopyCostPagesDocsMain;
                htSheet["SearchCopyCostCostMain"] = request.SearchCopyCostCostMain;
                htSheet["SearchCopyCostTotalMain"] = request.SearchCopyCostTotalMain;
                htSheet["JudgmentSearchCostNoOfSeraches"] = request.JudgmentSearchCostNoOfSeraches;
                htSheet["JudgmentSearchCostCost"] = request.JudgmentSearchCostCost;
                htSheet["JudgmentSearchCostTotal"] = request.JudgmentSearchCostTotal;
                htSheet["JudgmentCopyCostPattern"] = TrimToEmpty(request.JudgmentCopyCostPattern);
                htSheet["JudgmentCopyCostDocsType"] = TrimToEmpty(request.JudgmentCopyCostDocsType);
                htSheet["JudgmentCopyCostPagesDocsMain"] = request.JudgmentCopyCostPagesDocsMain;
                htSheet["JudgmentCopyCostCostMain"] = request.JudgmentCopyCostCostMain;
                htSheet["JudgmentCopyCostTotalMain"] = request.JudgmentCopyCostTotalMain;

                if (IsVary(request.JudgmentCopyCostPattern))
                {
                    htSheet["JudgmentCopyCostPagesDocs"] = request.VaryJudgmentCopyCostPagesDocs;
                    htSheet["JudgmentCopyCostCost"] = request.VaryJudgmentCopyCostCost;
                    htSheet["JudgmentCopyCostTotal"] = request.VaryJudgmentCopyCostTotal;
                }
                else
                {
                    htSheet["JudgmentCopyCostPagesDocs"] = 0;
                    htSheet["JudgmentCopyCostCost"] = 0m;
                    htSheet["JudgmentCopyCostTotal"] = 0m;
                }

                htSheet["TaxChargesDescription"] = TrimToEmpty(request.TaxChargesDescription);
                htSheet["TaxAmount"] = request.TaxAmount;
                htSheet["OtherChargesDescription"] = TrimToEmpty(request.OtherChargesDescription);
                htSheet["OtherChargesAmount"] = request.OtherChargesAmount;
                htSheet["ProductionCost"] = request.ProductionCost;
                htSheet["Remark"] = TrimToEmpty(request.Remark);
                htSheet["NoOfDocuments"] = request.NoOfDocuments;
                htSheet["NoOfPages"] = request.NoOfPages;
                htSheet["TaxInformation"] = TrimToEmpty(request.TaxInformation);
                htSheet["CalledTaxes"] = TrimToEmpty(request.CalledTaxes);
                htSheet["Attachment"] = TrimToEmpty(request.AttachmentPath);
                htSheet["SnippingTools"] = TrimToEmpty(request.SnippingTools);
                htSheet["PagesDeliverToClient"] = request.PagesDeliverToClient;
                htSheet["TotalCost"] = request.TotalCost;
                htSheet["AddedBy"] = addedBy;

                int returnValue =  ost.InsertProductionManualCosting(htSheet);
                return returnValue > 0
                    ? BuildResponse(true, "Production costing added successfully.", returnValue, string.Empty, BuildCostingLoadData(request.OrderID))
                    : BuildResponse(false, "Order costing not added.", returnValue);
            }
            catch (Exception ex)
            {
                return BuildResponse(false, "Order costing not added. " + ex.Message);
            }
        }

        [WebMethod]
        public static CostingResponse SaveAbstractorCosting(CostingAbstractorRequest request)
        {
            try
            {
                if (request == null)
                {
                    return BuildResponse(false, "Invalid abstractor costing details.");
                }

                string validationMessage = ValidateAbstractorRequest(request);
                if (!string.IsNullOrWhiteSpace(validationMessage))
                {
                    return BuildResponse(false, validationMessage);
                }

                int addedBy = AddedBy;
                bllOST ost = new bllOST();
                int processId = GetCurrentProcessId(ost, request.OrderID, addedBy);
                if (processId <= 0)
                {
                    return BuildResponse(false, "Unable to identify current process for selected order.");
                }

                if (!IsAbstractorCostingEnabled(ost, request.OrderID))
                {
                    return BuildResponse(false, "Abstractor costing is only available for Offline or Online to Offline orders.");
                }

                decimal abstractorTotal = request.AbstractorTotalCost > 0
                    ? request.AbstractorTotalCost
                    : request.AbstractorSearchCost + request.AbstractorCopyCostCostTotal + request.OtherCost;

                Hashtable htSheet = new Hashtable();
                htSheet["OrderID"] = request.OrderID;
                htSheet["ProcessID"] = processId;
                htSheet["SearchEngineType"] = TrimToEmpty(request.SearchEngineType);
                htSheet["SearchEngineLink"] = TrimToEmpty(request.SearchEngineLink);
                htSheet["AbstractorSearchCost"] = request.AbstractorSearchCost;
                htSheet["AbstractorCopyCostPages"] = request.AbstractorCopyCostPages;
                htSheet["AbstractorCopyCostCost"] = request.AbstractorCopyCostCost;
                htSheet["AbstractorCopyCostCostTotal"] = request.AbstractorCopyCostCostTotal;
                htSheet["OtherCostDescription"] = TrimToEmpty(request.OtherCostDescription);
                htSheet["OtherCost"] = request.OtherCost;
                htSheet["AbstractorTotalCost"] = abstractorTotal;
                htSheet["AddedBy"] = addedBy;

                int returnValue = ost.InsertAbstractorManualCosting(htSheet);
                return returnValue > 0
                    ? BuildResponse(true, "Abstractor costing added successfully.", returnValue, string.Empty, BuildCostingLoadData(request.OrderID))
                    : BuildResponse(false, "Abstractor costing not added.", returnValue);
            }
            catch (Exception ex)
            {
                return BuildResponse(false, "Abstractor costing not added. " + ex.Message);
            }
        }

        [WebMethod]
        public static CostingResponse SaveCreditCardInfo(CostingCreditCardRequest request)
        {
            try
            {
                if (request == null || request.OrderID <= 0)
                {
                    return BuildResponse(false, "Please select order.");
                }

                int addedBy = AddedBy;
                bllOST ost = new bllOST();
                int processId = GetCurrentProcessId(ost, request.OrderID, addedBy);
                if (processId <= 0)
                {
                    return BuildResponse(false, "Unable to identify current process for selected order.");
                }

                Hashtable htSheet = new Hashtable();
                htSheet["OrderID"] = request.OrderID;
                htSheet["ProcessID"] = processId;
                htSheet["NameOfTheCard"] = TrimToEmpty(request.NameOfTheCard);
                htSheet["NameOfThePlant"] = TrimToEmpty(request.NameOfThePlant);
                htSheet["ValidUpTo"] = string.IsNullOrWhiteSpace(request.ValidUpTo)
                    ? DateTime.Now.ToString("MM-dd-yyyy")
                    : request.ValidUpTo.Trim();
                htSheet["ValidFromDate"] = DateTime.Now.ToString("MM-dd-yyyy");
                htSheet["SearchingAmount"] = request.SearchingAmount;
                htSheet["DownloadingAmount"] = request.DownloadingAmount;
                htSheet["CreditCardNo"] = string.IsNullOrWhiteSpace(request.CreditCardNo) ? "0" : request.CreditCardNo.Trim();
                htSheet["Balance"] = 0.00m;
                htSheet["AddedBy"] = addedBy;

                int returnValue = ost.InsertCreditCardPayInfoForCosting(htSheet);
                return returnValue > 0
                    ? BuildResponse(true, "Order costing added successfully.", returnValue, "ProcessOrders.aspx")
                    : BuildResponse(false, "Order costing not added.", returnValue);
            }
            catch (Exception ex)
            {
                return BuildResponse(false, "Order costing not added. " + ex.Message);
            }
        }

        private static CostingLoadData BuildCostingLoadData(int orderId)
        {
            int addedBy = AddedBy;
            bllOST ost = new bllOST();
            DataTable orderDetails = ost.GetOrderByID(orderId);
            DataTable currentProcess = ost.GetCurrentProcessOfUser(orderId, addedBy);
            DataTable productionForm = ost.GetOrderCostingForUpdate(orderId);
            DataTable productionRows = ost.GetOrderCostingByOrder(orderId);
            DataTable abstractorRows = ost.GetAbstractorOrderCostingDetails(orderId);
            DataTable creditCard = ost.GetOrderCostingForCCUpdate(orderId);

            Dictionary<string, string> order = FirstRow(orderDetails);
            Dictionary<string, string> process = FirstRow(currentProcess);

            return new CostingLoadData
            {
                Order = order,
                Process = process,
                ProcessID = GetInt(process, "Processid", "ProcessId", "TaskProcessid", "TaskProcessID"),
                ProductionForm = FirstRow(productionForm),
                ProductionRows = DataTableToRows(productionRows, true),
                AbstractorRows = DataTableToRows(abstractorRows, true),
                CreditCard = FirstRow(creditCard),
                AbstractorEnabled = IsOfflineOrder(order)
            };
        }

        private void UploadInvoiceAttachment()
        {
            Response.ContentType = "application/json";
            JavaScriptSerializer serializer = new JavaScriptSerializer();

            try
            {
                int orderId;
                if (!int.TryParse(Request.Form["OrderID"], out orderId) || orderId <= 0)
                {
                    Response.Write(serializer.Serialize(new UploadResult { Success = false, Message = "Please select order before uploading invoice." }));
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                if (Request.Files.Count == 0 || Request.Files[0] == null || Request.Files[0].ContentLength == 0)
                {
                    Response.Write(serializer.Serialize(new UploadResult { Success = true, Message = string.Empty, AttachmentPath = string.Empty, FileName = string.Empty }));
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                HttpPostedFile file = Request.Files[0];
                string originalFileName = Path.GetFileName(file.FileName);
                if (string.IsNullOrWhiteSpace(originalFileName))
                {
                    Response.Write(serializer.Serialize(new UploadResult { Success = false, Message = "Invalid invoice file." }));
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                string dateFolder = DateTime.Now.ToString("dd-MMM-yyyy");
                string relativeFolder = "~/OSTAttachment/InVoice/" + orderId + "/" + dateFolder + "/" + orderId;
                string physicalFolder = Server.MapPath(relativeFolder);
                Directory.CreateDirectory(physicalFolder);

                string physicalPath = Path.Combine(physicalFolder, originalFileName);
                file.SaveAs(physicalPath);

                Response.Write(serializer.Serialize(new UploadResult
                {
                    Success = true,
                    Message = string.Empty,
                    AttachmentPath = relativeFolder + "/" + originalFileName,
                    FileName = originalFileName
                }));
            }
            catch (Exception ex)
            {
                Response.Write(serializer.Serialize(new UploadResult { Success = false, Message = "Unable to upload invoice. " + ex.Message }));
            }

            Context.ApplicationInstance.CompleteRequest();
        }

        private void DownloadCostingAttachment(string attachmentPath)
        {
            string decodedPath = HttpUtility.UrlDecode(attachmentPath ?? string.Empty).Trim();
            if (string.IsNullOrWhiteSpace(decodedPath))
            {
                Response.StatusCode = 404;
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            string normalizedPath = decodedPath.Replace('\\', '/');
            if (!normalizedPath.StartsWith("~/OSTAttachment/", StringComparison.OrdinalIgnoreCase))
            {
                Response.StatusCode = 403;
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            string physicalPath = Server.MapPath(normalizedPath);
            if (!File.Exists(physicalPath))
            {
                Response.StatusCode = 404;
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment;filename=" + Path.GetFileName(physicalPath));
            Response.TransmitFile(physicalPath);
            Context.ApplicationInstance.CompleteRequest();
        }

        private static string ValidateProductionRequest(CostingProductionRequest request)
        {
            if (request.OrderID <= 0)
            {
                return "Please select order.";
            }

            if (IsSelectOrEmpty(request.SearchEngineType))
            {
                return "Please select search engine.";
            }

            if (string.IsNullOrWhiteSpace(request.SearchEngineLink))
            {
                return "Please enter search engine link.";
            }

            if (request.NoOfDocuments < 0 || request.NoOfPages < 0 || request.PagesDeliverToClient < 0)
            {
                return "Document and page counts cannot be negative.";
            }

            if (IsSelectOrEmpty(request.TaxInformation))
            {
                return "Please select tax information provided.";
            }

            if (IsSelectOrEmpty(request.CalledTaxes))
            {
                return "Please select called for taxes.";
            }

            if (IsSelectOrEmpty(request.SnippingTools))
            {
                return "Please select snipping tools.";
            }

            return string.Empty;
        }

        private static string ValidateAbstractorRequest(CostingAbstractorRequest request)
        {
            if (request.OrderID <= 0)
            {
                return "Please select order.";
            }

            if (!request.AbstractorSearchCostSpecified)
            {
                return "Please enter abstractor search cost.";
            }

            if (!request.AbstractorCopyCostPagesSpecified)
            {
                return "Please enter copy cost.";
            }

            if (request.AbstractorSearchCost < 0 || request.AbstractorCopyCostPages < 0 || request.AbstractorCopyCostCostTotal < 0 || request.OtherCost < 0)
            {
                return "Abstractor cost values cannot be negative.";
            }

            if (string.IsNullOrWhiteSpace(request.OtherCostDescription))
            {
                return "Please enter abstractor other cost description.";
            }

            return string.Empty;
        }

        private static void NormalizeProductionTotals(CostingProductionRequest request)
        {
            request.SearchCostTotal = request.SearchCostTotal > 0
                ? request.SearchCostTotal
                : request.SearchCostNoOfSearches * request.SearchCostCost;

            request.SearchCopyCostTotalMain = request.SearchCopyCostTotalMain > 0
                ? request.SearchCopyCostTotalMain
                : request.SearchCopyCostPagesDocsMain * request.SearchCopyCostCostMain;

            request.VarySearchCopyCostTotal = request.VarySearchCopyCostTotal > 0
                ? request.VarySearchCopyCostTotal
                : request.VarySearchCopyCostPagesDocs * request.VarySearchCopyCostCost;

            request.JudgmentSearchCostTotal = request.JudgmentSearchCostTotal > 0
                ? request.JudgmentSearchCostTotal
                : request.JudgmentSearchCostNoOfSeraches * request.JudgmentSearchCostCost;

            request.JudgmentCopyCostTotalMain = request.JudgmentCopyCostTotalMain > 0
                ? request.JudgmentCopyCostTotalMain
                : request.JudgmentCopyCostPagesDocsMain * request.JudgmentCopyCostCostMain;

            request.VaryJudgmentCopyCostTotal = request.VaryJudgmentCopyCostTotal > 0
                ? request.VaryJudgmentCopyCostTotal
                : request.VaryJudgmentCopyCostPagesDocs * request.VaryJudgmentCopyCostCost;

            decimal productionCost =
                request.SearchCostTotal +
                request.SearchCopyCostTotalMain +
                (IsVary(request.SearchCopyCostPattern) ? request.VarySearchCopyCostTotal : 0m) +
                request.JudgmentSearchCostTotal +
                request.JudgmentCopyCostTotalMain +
                (IsVary(request.JudgmentCopyCostPattern) ? request.VaryJudgmentCopyCostTotal : 0m) +
                request.TaxAmount +
                request.OtherChargesAmount;

            request.ProductionCost = request.ProductionCost > 0 ? request.ProductionCost : productionCost;
            request.TotalCost = request.TotalCost > 0 ? request.TotalCost : request.ProductionCost;
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

        private static int GetCurrentEmployeeId()
        {
            return int.Parse(HttpContext.Current.User.Identity.Name);
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

        private static bool IsAbstractorCostingEnabled(bllOST ost, int orderId)
        {
            DataTable orderDetails = ost.GetOrderByID(orderId);
            return orderDetails != null && orderDetails.Rows.Count > 0 && IsOfflineOrder(FirstRow(orderDetails));
        }

        private static bool IsOfflineOrder(Dictionary<string, string> order)
        {
            string status = GetValue(order, "OnOffline", "OnOffLine");
            return string.Equals(status, "Offline", StringComparison.OrdinalIgnoreCase)
                || string.Equals(status, "Online to Offline", StringComparison.OrdinalIgnoreCase);
        }

        private static bool IsVary(string value)
        {
            return string.Equals(value, "Vary", StringComparison.OrdinalIgnoreCase);
        }

        private static bool IsSelectOrEmpty(string value)
        {
            return string.IsNullOrWhiteSpace(value) || string.Equals(value.Trim(), "Select", StringComparison.OrdinalIgnoreCase);
        }

        private static string TrimToEmpty(string value)
        {
            return string.IsNullOrWhiteSpace(value) ? string.Empty : value.Trim();
        }

        private static CostingResponse BuildResponse(bool success, string message, int returnValue = 0, string redirectUrl = "", CostingLoadData data = null)
        {
            return new CostingResponse
            {
                Success = success,
                Message = message,
                ReturnValue = returnValue,
                RedirectUrl = redirectUrl,
                Data = data
            };
        }

        private static Dictionary<string, string> FirstRow(DataTable dt)
        {
            if (dt == null || dt.Rows.Count == 0)
            {
                return new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            }

            return DataRowToDictionary(dt.Rows[0], 0, false);
        }

        private static List<Dictionary<string, string>> DataTableToRows(DataTable dt, bool includeNumber)
        {
            List<Dictionary<string, string>> rows = new List<Dictionary<string, string>>();
            if (dt == null)
            {
                return rows;
            }

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                rows.Add(DataRowToDictionary(dt.Rows[i], i + 1, includeNumber));
            }

            return rows;
        }

        private static Dictionary<string, string> DataRowToDictionary(DataRow row, int number, bool includeNumber)
        {
            Dictionary<string, string> item = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (DataColumn column in row.Table.Columns)
            {
                item[column.ColumnName] = row[column] == DBNull.Value ? string.Empty : Convert.ToString(row[column]);
            }

            if (includeNumber && !item.ContainsKey("Number"))
            {
                item["Number"] = Convert.ToString(number);
            }

            return item;
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
            string value = GetString(row, columns);
            int result;
            return int.TryParse(value, out result) ? result : 0;
        }

        private static int GetInt(Dictionary<string, string> row, params string[] columns)
        {
            string value = GetValue(row, columns);
            int result;
            return int.TryParse(value, out result) ? result : 0;
        }

        private static string GetValue(Dictionary<string, string> row, params string[] columns)
        {
            if (row == null)
            {
                return string.Empty;
            }

            foreach (string column in columns)
            {
                string value;
                if (row.TryGetValue(column, out value))
                {
                    return value ?? string.Empty;
                }
            }

            return string.Empty;
        }

        public class CostingResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public int ReturnValue { get; set; }
            public string RedirectUrl { get; set; }
            public CostingLoadData Data { get; set; }
        }

        public class CostingOrdersResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public List<CostingOrderOption> Orders { get; set; }
        }

        public class CostingOrderOption
        {
            public string Value { get; set; }
            public string Text { get; set; }
            public string OrderID { get; set; }
            public string ProjectNumber { get; set; }
            public string ClientOrderNo { get; set; }
        }

        public class CostingLoadData
        {
            public Dictionary<string, string> Order { get; set; }
            public Dictionary<string, string> Process { get; set; }
            public int ProcessID { get; set; }
            public Dictionary<string, string> ProductionForm { get; set; }
            public List<Dictionary<string, string>> ProductionRows { get; set; }
            public List<Dictionary<string, string>> AbstractorRows { get; set; }
            public Dictionary<string, string> CreditCard { get; set; }
            public bool AbstractorEnabled { get; set; }
        }

        public class UploadResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public string AttachmentPath { get; set; }
            public string FileName { get; set; }
        }

        public class CostingProductionRequest
        {
            public int OrderID { get; set; }
            public string SearchEngineType { get; set; }
            public string SearchEngineLink { get; set; }
            public string JudgementSearchLink { get; set; }
            public int SearchCostNoOfSearches { get; set; }
            public decimal SearchCostCost { get; set; }
            public decimal SearchCostTotal { get; set; }
            public string SearchCopyCostPattern { get; set; }
            public string SearchCopyCostDocsType { get; set; }
            public int SearchCopyCostPagesDocsMain { get; set; }
            public decimal SearchCopyCostCostMain { get; set; }
            public decimal SearchCopyCostTotalMain { get; set; }
            public string VarySearchCopyCostDocsType { get; set; }
            public int VarySearchCopyCostPagesDocs { get; set; }
            public decimal VarySearchCopyCostCost { get; set; }
            public decimal VarySearchCopyCostTotal { get; set; }
            public int JudgmentSearchCostNoOfSeraches { get; set; }
            public decimal JudgmentSearchCostCost { get; set; }
            public decimal JudgmentSearchCostTotal { get; set; }
            public string JudgmentCopyCostPattern { get; set; }
            public string JudgmentCopyCostDocsType { get; set; }
            public int JudgmentCopyCostPagesDocsMain { get; set; }
            public decimal JudgmentCopyCostCostMain { get; set; }
            public decimal JudgmentCopyCostTotalMain { get; set; }
            public string VaryJudgmentCopyCostDocsType { get; set; }
            public int VaryJudgmentCopyCostPagesDocs { get; set; }
            public decimal VaryJudgmentCopyCostCost { get; set; }
            public decimal VaryJudgmentCopyCostTotal { get; set; }
            public string TaxChargesDescription { get; set; }
            public decimal TaxAmount { get; set; }
            public string OtherChargesDescription { get; set; }
            public decimal OtherChargesAmount { get; set; }
            public string Remark { get; set; }
            public int NoOfDocuments { get; set; }
            public int NoOfPages { get; set; }
            public string TaxInformation { get; set; }
            public string CalledTaxes { get; set; }
            public string SnippingTools { get; set; }
            public int PagesDeliverToClient { get; set; }
            public decimal ProductionCost { get; set; }
            public decimal TotalCost { get; set; }
            public string AttachmentPath { get; set; }
        }

        public class CostingAbstractorRequest
        {
            public int OrderID { get; set; }
            public string SearchEngineType { get; set; }
            public string SearchEngineLink { get; set; }
            public decimal AbstractorSearchCost { get; set; }
            public bool AbstractorSearchCostSpecified { get; set; }
            public int AbstractorCopyCostPages { get; set; }
            public bool AbstractorCopyCostPagesSpecified { get; set; }
            public decimal AbstractorCopyCostCost { get; set; }
            public decimal AbstractorCopyCostCostTotal { get; set; }
            public string OtherCostDescription { get; set; }
            public decimal OtherCost { get; set; }
            public decimal AbstractorTotalCost { get; set; }
        }

        public class CostingCreditCardRequest
        {
            public int OrderID { get; set; }
            public string NameOfTheCard { get; set; }
            public string CreditCardNo { get; set; }
            public string ValidUpTo { get; set; }
            public string NameOfThePlant { get; set; }
            public decimal SearchingAmount { get; set; }
            public decimal DownloadingAmount { get; set; }
        }
    }
}
