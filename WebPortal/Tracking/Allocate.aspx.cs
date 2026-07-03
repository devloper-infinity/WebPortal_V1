using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;
using static WebPortal.Admin.ResponsibilityDelegation;
using DataTable = System.Data.DataTable;

namespace WebPortal.Tracking
{
    public partial class Allocate : System.Web.UI.Page
    {
        private static readonly string[] FeedbackImportHeaders =
        {
            "Deal No",
            "Loan 1 #",
            "Process",
            "Error Field",
            "Error Category",
            "Error Subcategory",
            "Error",
            "Should be",
            "Error Type",
            "Severity",
            "Feedback Type",
            "Remark"
        };

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string GetAllProjectByUser()
        {
            DataTable dt1 = new bllUS().GetAllProjectByUserRights(HttpContext.Current.User.Identity.Name.ToString());
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        
        [WebMethod]
        public static string GetProcessByProject(int ProjectID)
        {
            DataTable dt1 = new bllMaster().getProcess(ProjectID);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }


        [WebMethod]
        public static object GetLoansToAllocate(string ProcessName, string Type)
        {
            string Reviewer = EmployeeInfo.Current.Code;

            //DataTable dt = new bllUS().GetAllOrderNoByProjectWise(ProjectID, DealNo, "", "", "Allocation2");
            DataTable dt = new bllTracking().GetAllProjectDealNo_OrderNo_UW_Process(ProcessName, Reviewer, Type);
            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }


        [WebMethod]
        public static object GetUserLoans(string UserName)
        {
            DataTable dt = new bllMaster().GetAllProject(); //bllTracking().GetProcessDetails(UserName);
            dt = dt.AsEnumerable().Take(5).CopyToDataTable();
            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }


        [WebMethod]
        public static object GetUserOrders(string UserName, string FromDate, string ToDate)
        {
            DataTable dt = new bllTracking().GetProcessDetailsForFeedbackUser(UserName, FromDate, ToDate);

            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }


        [WebMethod]
        public static int AllocateOrders_Self(string Project, string DealNo, string OrderNo, string Process)
        {
            int ReturnValue = 0;
            DateTime dt = new DateTime();
            Hashtable htParam = new Hashtable();

            string Reviewer = EmployeeInfo.Current.Code;

            htParam.Add("ProjectNumber", Project);
            htParam.Add("DealNo", DealNo);
            htParam.Add("OrderNumber", OrderNo);
            htParam.Add("Review", Reviewer);
            htParam.Add("ReviewEndTime", DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss"));
            htParam.Add("Process", Process);
            htParam.Add("ProductType", "");
            htParam.Add("Status", "Pending");
            htParam.Add("Type", "Allocation");

            if (Project == "561" || Project == "667")
            {
                ReturnValue = new bllTracking().InsertModifyUWOrderOC22Servicing(htParam);
            }
            else
            {
                ReturnValue = new bllTracking().InsertModifyUWOrderOC22(htParam); /* created proc AllocateOrder_Self*/
            }

            return ReturnValue;
        }


        [WebMethod]
        public static int UpdateLoanStatus(string Project, string DealNo, string OrderNo, string Process, string ProjectID, string Status, string HoldRemark, string Remark, string ProductType, string UserName)
        {
            int ReturnValue = 0;
            Hashtable htParamValidate = new Hashtable();

            if (!string.IsNullOrWhiteSpace(Remark) && !HasFeedbackForLoan(ProjectID, OrderNo, Process, UserName))
                return -2;

            htParamValidate.Add("ProjectNumber", Project);
            htParamValidate.Add("DealNo", DealNo);
            htParamValidate.Add("OrderNumber", OrderNo);
            htParamValidate.Add("Process", Process);
            htParamValidate.Add("ProjectId", ProjectID);
            htParamValidate.Add("UserCode", UserName);

            ReturnValue = 10;// new bllTracking().ValidateUserProcessTAT(htParamValidate);
            return ReturnValue;
        }

        [WebMethod]
        public static bool HasTrackingFeedback(string ProjectID, string OrderNo, string Process, string UserName)
        {
            return HasFeedbackForLoan(ProjectID, OrderNo, Process, UserName);
        }

        [WebMethod(EnableSession = true)]
        public static AllocateFeedbackDefaultsResult GetTrackingFeedbackDefaults(AllocateFeedbackContext context)
        {
            try
            {
                AllocateFeedbackContext normalized = NormalizeContext(context);
                normalized.FeedbackBy = GetCurrentUserPseudoName();

                string errorBy = GetErrorByForContext(normalized.ProjectId, normalized.DealNo, normalized.Process, normalized.LoanNo);
                if (string.IsNullOrWhiteSpace(errorBy))
                    errorBy = normalized.ErrorBy;
                normalized.ErrorBy = errorBy;

                return new AllocateFeedbackDefaultsResult
                {
                    Success = true,
                    Context = normalized,
                    Processes = GetDefaultProcessList(),
                    Categories = ConvertCategoryTable(GetAllErrorCategory()),
                    ErrorByList = ToSingleItemList(errorBy, "Select")
                };
            }
            catch (Exception ex)
            {
                return new AllocateFeedbackDefaultsResult
                {
                    Success = false,
                    Message = ex.Message,
                    Context = NormalizeContext(context),
                    Processes = GetDefaultProcessList(),
                    Categories = new List<AllocateFeedbackListItem>(),
                    ErrorByList = new List<AllocateFeedbackListItem>()
                };
            }
        }

        [WebMethod(EnableSession = true)]
        public static List<AllocateFeedbackListItem> GetTrackingFeedbackSubCategories(int categoryId)
        {
            return ConvertSubCategoryTable(GetAllErrorSubCategory(categoryId));
        }

        [WebMethod(EnableSession = true)]
        public static AllocateFeedbackSaveResult SaveTrackingFeedback(AllocateTrackingFeedbackModel model)
        {
            try
            {
                return SaveTrackingFeedbackInternal(model, true);
            }
            catch (Exception ex)
            {
                return new AllocateFeedbackSaveResult { Success = false, Message = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public static AllocateFeedbackImportResult ImportTrackingFeedback(AllocateFeedbackImportRequest request)
        {
            AllocateFeedbackImportResult result = new AllocateFeedbackImportResult();

            try
            {
                if (request == null)
                    return FailImport("Invalid import request.");
                if (string.IsNullOrWhiteSpace(request.FileName) || string.IsNullOrWhiteSpace(request.ContentBase64))
                    return FailImport("Please select a feedback file.");

                string extension = Path.GetExtension(request.FileName).ToLowerInvariant();
                if (extension != ".xls" && extension != ".xlsx" && extension != ".csv")
                    return FailImport("Only .xls, .xlsx and .csv files are supported.");

                AllocateFeedbackContext context = NormalizeContext(request.Context);
                context.FeedbackBy = string.IsNullOrWhiteSpace(context.FeedbackBy) ? GetCurrentUserPseudoName() : context.FeedbackBy;

                string savedPath = SaveImportFile(request.FileName, request.ContentBase64);
                DataTable dt = extension == ".csv" ? ReadCsvTable(savedPath) : ReadExcelTable(savedPath);

                string headerError = ValidateImportHeaders(dt);
                if (!string.IsNullOrWhiteSpace(headerError))
                    return FailImport(headerError);

                result.TotalRows = dt.Rows.Count;

                foreach (DataRow row in dt.Rows)
                {
                    if (IsBlankImportRow(row))
                    {
                        result.NotAddedRows.Add(ToImportRow(row, "Blank row is added."));
                        continue;
                    }

                    AllocateTrackingFeedbackModel model = BuildFeedbackModelFromImportRow(row, context);
                    string validation = ValidateImportModel(model, context);
                    if (!string.IsNullOrWhiteSpace(validation))
                    {
                        result.NotAddedRows.Add(ToImportRow(row, validation));
                        continue;
                    }

                    AllocateFeedbackSaveResult saveResult = SaveTrackingFeedbackInternal(model, false);
                    if (saveResult.Success)
                        result.AddedRows.Add(ToImportRow(row, "Imported"));
                    else
                        result.NotAddedRows.Add(ToImportRow(row, saveResult.Message));
                }

                result.Success = true;
                result.AddedCount = result.AddedRows.Count;
                result.NotAddedCount = result.NotAddedRows.Count;
                result.Message = result.NotAddedCount == 0
                    ? "Feedback imported successfully."
                    : "Feedback import completed with validation messages.";

                return result;
            }
            catch (Exception ex)
            {
                return FailImport(ex.Message);
            }
        }

        private static AllocateFeedbackSaveResult SaveTrackingFeedbackInternal(AllocateTrackingFeedbackModel model, bool validateSameUser)
        {
            string validation = ValidateFeedback(model, validateSameUser);
            if (!string.IsNullOrWhiteSpace(validation))
                return new AllocateFeedbackSaveResult { Success = false, Message = validation };

            int projectId = ToInt(model.ProjectId);
            int processId = GetProcessId(projectId, model.MarkedTo);
            if (processId <= 0)
                return new AllocateFeedbackSaveResult { Success = false, Message = "Process is not valid." };

            int addedBy = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            string errorBy = (model.ErrorBy ?? string.Empty).Trim().ToUpperInvariant();
            string feedbackBy = (model.FeedbackBy ?? string.Empty).Trim().ToUpperInvariant();

            Hashtable htFeedback = new Hashtable();
            htFeedback["OrderNo"] = Clean(model.LoanNo);
            htFeedback["DealNo"] = Clean(model.DealNo);
            htFeedback["OrderDate"] = Clean(model.OrderDate);
            htFeedback["ProjectID"] = projectId;
            htFeedback["ProcessID"] = processId;
            htFeedback["ErrorDoneBy"] = errorBy;
            htFeedback["FeedbackGivenBy"] = feedbackBy;
            htFeedback["ErrorType"] = Clean(model.ErrorType);
            htFeedback["Fatal"] = Clean(model.Severity);
            htFeedback["ErrorField"] = Clean(model.ErrorField);
            htFeedback["Error"] = Clean(model.Error);
            htFeedback["Shouldbe"] = Clean(model.ShouldBe);
            htFeedback["FeedbackType"] = Clean(model.FeedbackType);
            htFeedback["FeedbackRecivedDate"] = string.Empty;
            htFeedback["Remark"] = Clean(model.Remark);
            htFeedback["AddedBy"] = addedBy;
            htFeedback["Section"] = Clean(model.Category);
            htFeedback["Field"] = Clean(model.SubCategory);
            htFeedback["FeedbackerrorPath"] = string.Empty;

            int feedbackId = new bllTracking().InsertFeedbackForNewOrderUnderwritingByTracking(htFeedback);
            if (feedbackId <= 0)
                return new AllocateFeedbackSaveResult { Success = false, Message = "Unable to add feedback." };

            htFeedback["Feedback"] = feedbackId;
            int addResult = new bllTracking().AddFeedbackForNewOrder(htFeedback);
            if (addResult <= 0)
                return new AllocateFeedbackSaveResult { Success = false, Message = "Unable to save feedback details." };

            UnderwritingTrackingSheetProcessStatusLog(model.ProjectNo, model.LoanNo, model.MarkedTo, model.FeedbackBy, GetServerTime());

            return new AllocateFeedbackSaveResult { Success = true, Message = "Feedback Added Sucessfully.", FeedbackId = feedbackId };
        }

        private static string ValidateFeedback(AllocateTrackingFeedbackModel model, bool validateSameUser)
        {
            if (model == null) return "Invalid feedback data.";

            bool noFeedback = IsNoFeedback(model.ErrorType);
            if (string.IsNullOrWhiteSpace(model.MarkedTo)) return "Please Select Marked to.";
            if (string.IsNullOrWhiteSpace(model.ErrorBy)) return "Please Select Error By.";
            if (string.IsNullOrWhiteSpace(model.ErrorType) || IsSelect(model.ErrorType)) return "Please Select Error Type.";
            if (string.IsNullOrWhiteSpace(model.Category) || IsSelect(model.Category)) return "Please Select Error Category.";
            if (string.IsNullOrWhiteSpace(model.SubCategory) || IsSelect(model.SubCategory)) return "Please Select Error Sub Category.";
            if (!noFeedback && (string.IsNullOrWhiteSpace(model.Severity) || IsSelect(model.Severity))) return "Please Select Severity.";
            if (!noFeedback && string.IsNullOrWhiteSpace(model.ErrorField)) return "Please Enter Error Field.";
            if (string.IsNullOrWhiteSpace(model.FeedbackType) || IsSelect(model.FeedbackType)) return "Please Select Feedback Type.";
            if (!noFeedback && string.IsNullOrWhiteSpace(model.Error)) return "Please Enter Error.";
            if (!noFeedback && string.IsNullOrWhiteSpace(model.ShouldBe)) return "Please Enter Should Be.";

            if (validateSameUser && SameText(model.FeedbackBy, model.ErrorBy))
                return "Feedback Given By and Error Done By both are same is not valid, please check!!.";

            return string.Empty;
        }

        private static string ValidateImportModel(AllocateTrackingFeedbackModel model, AllocateFeedbackContext context)
        {
            if (!SameText(context.DealNo, model.DealNo)) return "Deal # is not valid.";
            if (!SameText(context.LoanNo, model.LoanNo)) return "Loan # is not valid.";
            if (GetProcessId(ToInt(model.ProjectId), model.MarkedTo) <= 0) return "Process is not valid.";
            if (string.IsNullOrWhiteSpace(model.Category)) return "Error Category is compulsory.";
            if (string.IsNullOrWhiteSpace(model.SubCategory)) return "Error Subcategory is compulsory.";

            string validation = ValidateFeedback(model, false);
            return validation;
        }

        private static AllocateTrackingFeedbackModel BuildFeedbackModelFromImportRow(DataRow row, AllocateFeedbackContext context)
        {
            string process = GetCell(row, "Process");
            string errorBy = GetErrorByForContext(context.ProjectId, context.DealNo, process, context.LoanNo);
            if (string.IsNullOrWhiteSpace(errorBy))
                errorBy = context.ErrorBy;

            return new AllocateTrackingFeedbackModel
            {
                ProjectNo = context.ProjectNo,
                ProjectId = context.ProjectId,
                DealNo = GetCell(row, "Deal No"),
                LoanNo = GetCell(row, "Loan 1 #"),
                OrderDate = context.OrderDate,
                MarkedTo = process,
                ErrorBy = errorBy,
                FeedbackBy = context.FeedbackBy,
                ErrorField = IsNoFeedback(GetCell(row, "Error Type")) ? "NA" : GetCell(row, "Error Field"),
                Category = IsNoFeedback(GetCell(row, "Error Type")) ? "NA" : GetCell(row, "Error Category"),
                SubCategory = IsNoFeedback(GetCell(row, "Error Type")) ? "NA" : GetCell(row, "Error Subcategory"),
                Error = IsNoFeedback(GetCell(row, "Error Type")) ? "NA" : GetCell(row, "Error"),
                ShouldBe = IsNoFeedback(GetCell(row, "Error Type")) ? "NA" : GetCell(row, "Should be"),
                ErrorType = GetCell(row, "Error Type"),
                Severity = IsNoFeedback(GetCell(row, "Error Type")) ? string.Empty : GetCell(row, "Severity"),
                FeedbackType = GetCell(row, "Feedback Type"),
                Remark = IsNoFeedback(GetCell(row, "Error Type")) ? "NA" : GetCell(row, "Remark")
            };
        }

        private static AllocateFeedbackContext NormalizeContext(AllocateFeedbackContext context)
        {
            context = context ?? new AllocateFeedbackContext();
            context.ProjectNo = Clean(context.ProjectNo);
            context.ProjectId = Clean(context.ProjectId);
            context.DealNo = Clean(context.DealNo);
            context.LoanNo = Clean(context.LoanNo);
            context.OrderDate = Clean(context.OrderDate);
            context.Process = string.IsNullOrWhiteSpace(context.Process) ? "Loan Setup" : Clean(context.Process);
            context.ErrorBy = Clean(context.ErrorBy);
            context.FeedbackBy = Clean(context.FeedbackBy);
            return context;
        }

        private static List<AllocateFeedbackListItem> GetDefaultProcessList()
        {
            return new List<AllocateFeedbackListItem>
            {
                new AllocateFeedbackListItem { Value = "", Text = "Select" },
                new AllocateFeedbackListItem { Value = "Review", Text = "Review" },
                new AllocateFeedbackListItem { Value = "CNCReview", Text = "CNCReview" },
                new AllocateFeedbackListItem { Value = "SSReview", Text = "SSReview" },
                new AllocateFeedbackListItem { Value = "Loan Setup", Text = "Loan Setup" },
                new AllocateFeedbackListItem { Value = "Credit", Text = "Credit" },
                new AllocateFeedbackListItem { Value = "Compliance", Text = "Compliance" }
            };
        }

        private static List<AllocateFeedbackListItem> ToSingleItemList(string value, string emptyText)
        {
            List<AllocateFeedbackListItem> rows = new List<AllocateFeedbackListItem>();
            if (string.IsNullOrWhiteSpace(value))
                rows.Add(new AllocateFeedbackListItem { Value = "", Text = emptyText });
            else
                rows.Add(new AllocateFeedbackListItem { Value = value, Text = value });

            return rows;
        }

        private static List<AllocateFeedbackListItem> ConvertCategoryTable(DataTable dt)
        {
            List<AllocateFeedbackListItem> rows = new List<AllocateFeedbackListItem> { new AllocateFeedbackListItem { Value = "", Text = "Select" } };
            if (dt == null) return rows;

            foreach (DataRow dr in dt.Rows)
            {
                rows.Add(new AllocateFeedbackListItem
                {
                    Value = Convert.ToString(dr["ErrorId"]),
                    Text = Convert.ToString(dr["Type"])
                });
            }

            return rows;
        }

        private static List<AllocateFeedbackListItem> ConvertSubCategoryTable(DataTable dt)
        {
            List<AllocateFeedbackListItem> rows = new List<AllocateFeedbackListItem> { new AllocateFeedbackListItem { Value = "", Text = "Select" } };
            if (dt == null) return rows;

            foreach (DataRow dr in dt.Rows)
            {
                rows.Add(new AllocateFeedbackListItem
                {
                    Value = Convert.ToString(dr["ErrorSubId"]),
                    Text = Convert.ToString(dr["SubType"])
                });
            }

            return rows;
        }

        private static DataTable GetAllErrorCategory()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_WBT_TrackingSheet_ErrorCategory");
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        private static DataTable GetAllErrorSubCategory(int id)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_WBT_TrackingSheet_ErrorSuvCategory");
            SQLHelper.AddParamToSQLCmd(cmd, "@Id", SqlDbType.BigInt, 0, ParameterDirection.Input, id);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        private static string GetErrorByForContext(string projectId, string dealNo, string process, string loanNo)
        {
            if (string.IsNullOrWhiteSpace(projectId) || string.IsNullOrWhiteSpace(dealNo) || string.IsNullOrWhiteSpace(process) || string.IsNullOrWhiteSpace(loanNo))
                return string.Empty;

            string storedProcedure = projectId == "70" || projectId == "217"
                ? "usp_getTrakcinDataForConsolidatedReport_Revised_2_Servicing"
                : "usp_getTrakcinDataForConsolidatedReport_Revised_2";

            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, storedProcedure);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID2", SqlDbType.NVarChar, 500, ParameterDirection.Input, projectId);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo2", SqlDbType.NVarChar, 500, ParameterDirection.Input, dealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", SqlDbType.NVarChar, 500, ParameterDirection.Input, process);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo2", SqlDbType.NVarChar, 500, ParameterDirection.Input, loanNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);

            if (dt != null && dt.Rows.Count > 0 && dt.Columns.Contains("Employee"))
                return Convert.ToString(dt.Rows[0]["Employee"]);

            return string.Empty;
        }

        private static int GetProcessId(int projectId, string process)
        {
            if (projectId <= 0 || string.IsNullOrWhiteSpace(process))
                return 0;

            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetProcessDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", SqlDbType.BigInt, 0, ParameterDirection.Input, projectId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", SqlDbType.NVarChar, 4000, ParameterDirection.Input, process);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);

            if (dt != null && dt.Rows.Count > 0 && dt.Columns.Contains("ProcessId"))
                return ToInt(Convert.ToString(dt.Rows[0]["ProcessId"]));

            return 0;
        }

        private static string GetCurrentUserPseudoName()
        {
            string code = EmployeeInfo.Current.Code;

            if (string.IsNullOrWhiteSpace(code))
                return string.Empty;

            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "WBT_usp_GetCurrentUserPsudoName2");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", SqlDbType.NVarChar, 100, ParameterDirection.Input, code.ToUpperInvariant());
            string pseudoName = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));

            return string.IsNullOrWhiteSpace(pseudoName) ? code : pseudoName;
        }

        private static int UnderwritingTrackingSheetProcessStatusLog(string projectNo, string loanNo, string processName, string userCode, string processDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_WBT_UnderwritingTrackingSheet_ProcessStatusLog_UW");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", SqlDbType.NVarChar, 200, ParameterDirection.Input, Clean(projectNo));
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNo", SqlDbType.NVarChar, 200, ParameterDirection.Input, Clean(loanNo));
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", SqlDbType.NVarChar, 4000, ParameterDirection.Input, Clean(processName));
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", SqlDbType.NVarChar, 200, ParameterDirection.Input, Clean(userCode));
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessDate", SqlDbType.NVarChar, 200, ParameterDirection.Input, Clean(processDate));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return ToInt(Convert.ToString(cmd.Parameters["@ReturnValue"].Value));
        }

        private static bool HasFeedbackForLoan(string projectId, string orderNo, string process, string userName)
        {
            string cleanedProjectId = Clean(projectId);
            int parsedProjectId = ToInt(cleanedProjectId);
            string cleanedOrderNo = Clean(orderNo);
            string cleanedProcess = Clean(process);
            string feedbackBy = Clean(userName);

            if (parsedProjectId <= 0 || string.IsNullOrWhiteSpace(cleanedOrderNo) || string.IsNullOrWhiteSpace(cleanedProcess))
                return false;

            if (string.IsNullOrWhiteSpace(feedbackBy))
                feedbackBy = EmployeeInfo.Current.Code;

            bllTracking tracking = new bllTracking();
            DataTable dt = cleanedProjectId == "70" || cleanedProjectId == "217"
                ? tracking.GetAllProjectFeedbackinERP_Servicing(parsedProjectId, cleanedOrderNo, cleanedProcess, feedbackBy)
                : tracking.GetAllProjectFeedbackinERP(parsedProjectId, cleanedOrderNo, cleanedProcess, feedbackBy);

            return dt != null && dt.Rows.Count > 0;
        }

        private static string GetServerTime()
        {
            try
            {
                SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "WBT_usp_GetServerTime");
                string serverTime = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
                if (!string.IsNullOrWhiteSpace(serverTime))
                    return serverTime;
            }
            catch
            {
            }

            return DateTime.Now.ToString(CultureInfo.InvariantCulture);
        }

        private static string SaveImportFile(string fileName, string contentBase64)
        {
            string cleanedFileName = Path.GetFileName(fileName);
            foreach (char c in Path.GetInvalidFileNameChars())
                cleanedFileName = cleanedFileName.Replace(c, '_');

            int comma = contentBase64.IndexOf(',');
            if (comma >= 0)
                contentBase64 = contentBase64.Substring(comma + 1);

            byte[] bytes = Convert.FromBase64String(contentBase64);
            string directory = HttpContext.Current.Server.MapPath("~/Upload/TrackingFeedback/" + DateTime.Now.ToString("yyyyMMddHHmmssfff", CultureInfo.InvariantCulture));
            Directory.CreateDirectory(directory);
            string path = Path.Combine(directory, cleanedFileName);
            File.WriteAllBytes(path, bytes);
            return path;
        }

        private static DataTable ReadExcelTable(string path)
        {
            string extension = Path.GetExtension(path).ToLowerInvariant();
            string excelVersion = extension == ".xls" ? "Excel 8.0" : "Excel 12.0 Xml";
            string connectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Extended Properties=\"" + excelVersion + ";HDR=YES;IMEX=1\"";

            using (OleDbConnection connection = new OleDbConnection(connectionString))
            {
                connection.Open();
                DataTable schema = connection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                if (schema == null || schema.Rows.Count == 0)
                    throw new InvalidOperationException("No worksheet found in selected file.");

                string sheetName = schema.Rows.Cast<DataRow>()
                    .Select(r => Convert.ToString(r["TABLE_NAME"]))
                    .FirstOrDefault(n => !string.IsNullOrWhiteSpace(n) && n.EndsWith("$", StringComparison.OrdinalIgnoreCase));

                if (string.IsNullOrWhiteSpace(sheetName))
                    sheetName = Convert.ToString(schema.Rows[0]["TABLE_NAME"]);

                using (OleDbDataAdapter adapter = new OleDbDataAdapter("SELECT * FROM [" + sheetName.Replace("'", "''") + "]", connection))
                {
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    return dt;
                }
            }
        }

        private static DataTable ReadCsvTable(string path)
        {
            DataTable dt = new DataTable();
            string[] lines = File.ReadAllLines(path);
            if (lines.Length == 0)
                return dt;

            List<string> headers = ParseCsvLine(lines[0]);
            foreach (string header in headers)
                dt.Columns.Add(header);

            for (int i = 1; i < lines.Length; i++)
            {
                List<string> values = ParseCsvLine(lines[i]);
                DataRow row = dt.NewRow();
                for (int c = 0; c < dt.Columns.Count; c++)
                    row[c] = c < values.Count ? values[c] : string.Empty;
                dt.Rows.Add(row);
            }

            return dt;
        }

        private static List<string> ParseCsvLine(string line)
        {
            List<string> values = new List<string>();
            StringBuilder value = new StringBuilder();
            bool inQuotes = false;

            for (int i = 0; i < line.Length; i++)
            {
                char ch = line[i];
                if (ch == '"')
                {
                    if (inQuotes && i + 1 < line.Length && line[i + 1] == '"')
                    {
                        value.Append('"');
                        i++;
                    }
                    else
                    {
                        inQuotes = !inQuotes;
                    }
                }
                else if (ch == ',' && !inQuotes)
                {
                    values.Add(value.ToString());
                    value.Clear();
                }
                else
                {
                    value.Append(ch);
                }
            }

            values.Add(value.ToString());
            return values;
        }

        private static string ValidateImportHeaders(DataTable dt)
        {
            if (dt == null || dt.Columns.Count < FeedbackImportHeaders.Length)
                return "Please check excel column headre(s): " + string.Join(", ", FeedbackImportHeaders);

            for (int i = 0; i < FeedbackImportHeaders.Length; i++)
            {
                if (!SameText(dt.Columns[i].ColumnName, FeedbackImportHeaders[i]))
                    return "Please check excel column headre(s): " + string.Join(", ", FeedbackImportHeaders);
            }

            return string.Empty;
        }

        private static bool IsBlankImportRow(DataRow row)
        {
            foreach (string header in FeedbackImportHeaders)
            {
                if (!string.IsNullOrWhiteSpace(GetCell(row, header)))
                    return false;
            }

            return true;
        }

        private static AllocateFeedbackImportRow ToImportRow(DataRow row, string message)
        {
            return new AllocateFeedbackImportRow
            {
                DealNo = GetCell(row, "Deal No"),
                LoanNo = GetCell(row, "Loan 1 #"),
                Process = GetCell(row, "Process"),
                ErrorType = GetCell(row, "Error Type"),
                Message = message
            };
        }

        private static AllocateFeedbackImportResult FailImport(string message)
        {
            return new AllocateFeedbackImportResult { Success = false, Message = message };
        }

        private static string GetCell(DataRow row, string columnName)
        {
            if (row == null || row.Table == null || !row.Table.Columns.Contains(columnName))
                return string.Empty;

            return Clean(Convert.ToString(row[columnName]));
        }

        private static bool IsNoFeedback(string value)
        {
            return SameText(value, "NoFeedback");
        }

        private static bool IsSelect(string value)
        {
            return SameText(value, "Select");
        }

        private static bool SameText(string first, string second)
        {
            return string.Equals(Clean(first), Clean(second), StringComparison.OrdinalIgnoreCase);
        }

        private static string Clean(string value)
        {
            return (value ?? string.Empty).Trim();
        }

        private static int ToInt(string value)
        {
            int parsed;
            return int.TryParse(Clean(value), out parsed) ? parsed : 0;
        }
    }

    public class AllocateFeedbackContext
    {
        public string ProjectNo { get; set; }
        public string ProjectId { get; set; }
        public string DealNo { get; set; }
        public string LoanNo { get; set; }
        public string OrderDate { get; set; }
        public string Process { get; set; }
        public string ErrorBy { get; set; }
        public string FeedbackBy { get; set; }
    }

    public class AllocateTrackingFeedbackModel : AllocateFeedbackContext
    {
        public string MarkedTo { get; set; }
        public string ErrorType { get; set; }
        public string Category { get; set; }
        public string SubCategory { get; set; }
        public string Severity { get; set; }
        public string ErrorField { get; set; }
        public string Error { get; set; }
        public string ShouldBe { get; set; }
        public string Remark { get; set; }
        public string FeedbackType { get; set; }
    }

    public class AllocateFeedbackListItem
    {
        public string Value { get; set; }
        public string Text { get; set; }
    }

    public class AllocateFeedbackDefaultsResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public AllocateFeedbackContext Context { get; set; }
        public List<AllocateFeedbackListItem> Processes { get; set; }
        public List<AllocateFeedbackListItem> Categories { get; set; }
        public List<AllocateFeedbackListItem> ErrorByList { get; set; }
    }

    public class AllocateFeedbackSaveResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int FeedbackId { get; set; }
    }

    public class AllocateFeedbackImportRequest
    {
        public AllocateFeedbackContext Context { get; set; }
        public string FileName { get; set; }
        public string ContentBase64 { get; set; }
    }

    public class AllocateFeedbackImportResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int TotalRows { get; set; }
        public int AddedCount { get; set; }
        public int NotAddedCount { get; set; }
        public List<AllocateFeedbackImportRow> AddedRows { get; set; }
        public List<AllocateFeedbackImportRow> NotAddedRows { get; set; }

        public AllocateFeedbackImportResult()
        {
            AddedRows = new List<AllocateFeedbackImportRow>();
            NotAddedRows = new List<AllocateFeedbackImportRow>();
        }
    }

    public class AllocateFeedbackImportRow
    {
        public string DealNo { get; set; }
        public string LoanNo { get; set; }
        public string Process { get; set; }
        public string ErrorType { get; set; }
        public string Message { get; set; }
    }
}
