using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Tracking
{
    public partial class AddFeedback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string ProcessID = Server.UrlDecode(Request.QueryString["ProcessID"]);
                af_processID.Value = ProcessID;
                af_loginPseudoName.Value = EmployeeInfo.Current.PseudoName;

                       }
        }


        [WebMethod]
        public static string GetLoanDetailsByProcessID(int ProcessID)
        {
            DataTable dt1 = new bllTracking().GetLoanDetailsByProcessID(ProcessID);
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
        public static int AddFeddback(string Project, string DealNo, string LoanNo, string DateReviewed, string ErrorBy, string FeedbackBy, string ErrorType, string Category, string SubCategory, string ErrorField, string Severity, string FeedbackType, string Shouldbe, string ShouldBe, string Remark)
        {
            int ReturnValue = 0;

            int addedBy = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            string feedbackBy = EmployeeInfo.Current.PseudoName;

            Hashtable htFeedback = new Hashtable();
            htFeedback["LoanNumber"] = LoanNo;
            htFeedback["DealNo"] = DealNo;
            htFeedback["DateReviewed"] = DateReviewed;
            htFeedback["Client"] = Project;
            htFeedback["ErrorBy"] = ErrorBy;
            htFeedback["FeedbackBy"] = FeedbackBy;
            htFeedback["ErrorType"] = ErrorType;
            htFeedback["Category"] = Category;
            htFeedback["SubCategory"] = SubCategory;
            htFeedback["Severity"] = Severity;
            htFeedback["ErrorField"] = ErrorField;
            htFeedback["FeedbackType"] = FeedbackType;
            htFeedback["Shouldbe"] = ShouldBe;
            htFeedback["Comments"] = Remark;
            htFeedback["AddedBy"] = addedBy;

            if (Project == "561")

                ReturnValue = new bllTracking().InsertImportedFeedback_Servicing(htFeedback);

            else
                ReturnValue = new bllTracking().InsertImportedFeedback_Credit(htFeedback);

            return ReturnValue;
        }



        [WebMethod(EnableSession = true)]
        public static PageDefaultModel GetPageDefaults()
        {
            HttpContext ctx = HttpContext.Current;
            var p = new PageDefaultModel
            {
                ProjectNo = ctx.Request.QueryString["ProjectNo"] ?? string.Empty,
                DealNo = ctx.Request.QueryString["DealNo"] ?? string.Empty,
                LoanNo = ctx.Request.QueryString["LoanNo"] ?? string.Empty,
                OrderDate = ctx.Request.QueryString["OrderDate"] ?? string.Empty,
                ProjectId = ctx.Request.QueryString["ProjectId"] ?? string.Empty,
                Process = ctx.Request.QueryString["Process"] ?? string.Empty,
                ErrorBy = ctx.Request.QueryString["ErrorBy"] ?? string.Empty,
                FeedbackBy = Convert.ToString(ctx.Session["CurrentUserPseudoName"] ?? ctx.Session["CurrentUser"] ?? string.Empty)
            };

            if (!string.IsNullOrWhiteSpace(p.ErrorBy))
                p.ErrorByList.Add(new ListItemModel { Value = p.ErrorBy, Text = p.ErrorBy });
            else
                p.ErrorByList.Add(new ListItemModel { Value = "", Text = "Select" });

            return p;
        }

        [WebMethod(EnableSession = true)]
        public static List<ErrorCategoryModel> GetCategories()
        {
            // Replace this sample block with your existing ERP Tracking call:
            // DataTable dt = new Tracking().GetAllErrorCategory();
            // return ConvertCategoryTable(dt);
            return new List<ErrorCategoryModel>
            {
                new ErrorCategoryModel { ErrorId = 0, Type = "Select" },
                new ErrorCategoryModel { ErrorId = -1, Type = "NA" }
            };
        }

        [WebMethod(EnableSession = true)]
        public static List<ErrorSubCategoryModel> GetSubCategories(int categoryId)
        {
            // Replace this sample block with your existing ERP Tracking call:
            // DataTable dt = new Tracking().GetAllErrorSubCategory(categoryId);
            // return ConvertSubCategoryTable(dt);
            return new List<ErrorSubCategoryModel>
            {
                new ErrorSubCategoryModel { ErrorSubId = 0, SubType = "Select" },
                new ErrorSubCategoryModel { ErrorSubId = -1, SubType = "NA" }
            };
        }

        [WebMethod(EnableSession = true)]
        public static PageDefaultModel GetErrorByForProcess(string process)
        {
            var p = new PageDefaultModel();
            string errorBy = "Adam Doe";

            // Replace with Windows source logic adapted for web:
            // if (projectId == 70 || projectId == 217)
            //     dt = new Tracking().GetLoanDetails_Servicing(projectId.ToString(), dealNo, process, loanNo);
            // else
            //     dt = new Tracking().GetLoanDetails(projectId.ToString(), dealNo, process, loanNo);
            // if (dt.Rows.Count > 0) errorBy = Convert.ToString(dt.Rows[0]["Employee"]);

            p.ErrorBy = errorBy;
            p.ErrorByList.Add(new ListItemModel { Value = errorBy, Text = errorBy });
            return p;
        }

        [WebMethod(EnableSession = true)]
        public static SaveResult SaveFeedback(FeedbackModel model)
        {
            string validation = Validate(model);
            if (!string.IsNullOrEmpty(validation))
                return new SaveResult { Success = false, Message = validation };

            try
            {
                // Plug your live Tracking class here. The Hashtable keys match the WinForms source.
                Hashtable htFeedback = new Hashtable();
                htFeedback["OrderNo"] = model.LoanNo;
                htFeedback["DealNo"] = model.DealNo;
                htFeedback["OrderDate"] = model.OrderDate;
                htFeedback["ProjectID"] = model.ProjectId;
                htFeedback["ProcessID"] = model.MarkedTo; // Replace with GetProcess(projectId, MarkedTo) ProcessId.
                htFeedback["ErrorDoneBy"] = (model.ErrorBy ?? string.Empty).Trim().ToUpper();
                htFeedback["FeedbackGivenBy"] = (model.FeedbackBy ?? string.Empty).Trim().ToUpper();
                htFeedback["ErrorType"] = model.ErrorType;
                htFeedback["Fatal"] = model.Severity;
                htFeedback["ErrorField"] = model.ErrorField;
                htFeedback["Error"] = model.Error;
                htFeedback["Shouldbe"] = model.ShouldBe;
                htFeedback["FeedbackType"] = model.FeedbackType;
                htFeedback["FeedbackRecivedDate"] = string.Empty;
                htFeedback["Remark"] = model.Remark;
                htFeedback["Section"] = model.Category;
                htFeedback["Field"] = model.SubCategory;
                htFeedback["FeedbackerrorPath"] = string.Empty;

                // Expected live flow from WinForms:
                // int processId = Convert.ToInt32(new Tracking().GetProcess(Convert.ToInt32(model.ProjectId), model.MarkedTo).Rows[0]["ProcessId"]);
                // int empId = new Tracking().GetEmployeeId(Convert.ToString(HttpContext.Current.Session["CurrentUser"]));
                // htFeedback["ProcessID"] = processId.ToString();
                // htFeedback["AddedBy"] = empId.ToString();
                // int feedbackId = new Tracking().InsertFeedbackForNewOrder_Underwriting_ByTracking(htFeedback);
                // htFeedback["Feedback"] = feedbackId;
                // int result = new Tracking().AddFeedbackForNewOrder(htFeedback);
                // new Tracking().UnderwritingTrackingSheet_ProcessStatusLog_UW(model.ProjectNo, model.LoanNo, model.MarkedTo, model.FeedbackBy, new Tracking().GetServerTime().ToString());

                RememberFeedback(model);
                return new SaveResult { Success = true, Message = "Feedback Added Sucessfully." };
            }
            catch (Exception ex)
            {
                return new SaveResult { Success = false, Message = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public static FeedbackRecordResult GetFeedbackRecords(FeedbackRecordRequest request)
        {
            FeedbackRecordResult result = new FeedbackRecordResult { Success = true };
            request = request ?? new FeedbackRecordRequest();

            string projectId = Clean(request.ProjectId);
            string loanNo = Clean(request.LoanNo);
            string process = Clean(request.Process);
            string feedbackBy = Clean(request.FeedbackBy);

            if (string.IsNullOrWhiteSpace(feedbackBy))
                feedbackBy = GetCurrentUser();

            int parsedProjectId;
            if (int.TryParse(projectId, out parsedProjectId) && parsedProjectId > 0 && !string.IsNullOrWhiteSpace(loanNo) && !string.IsNullOrWhiteSpace(process))
            {
                try
                {
                    bllTracking tracking = new bllTracking();
                    DataTable dt = projectId == "70" || projectId == "217"
                        ? tracking.GetAllProjectFeedbackinERP_Servicing(parsedProjectId, loanNo, process, feedbackBy)
                        : tracking.GetAllProjectFeedbackinERP(parsedProjectId, loanNo, process, feedbackBy);

                    if (dt != null)
                    {
                        foreach (DataRow row in dt.Rows)
                        {
                            Dictionary<string, string> item = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                            foreach (DataColumn column in dt.Columns)
                                item[column.ColumnName] = Convert.ToString(row[column]);
                            result.Rows.Add(item);
                        }
                    }
                }
                catch
                {
                    // Keep the page usable when the ERP feedback lookup is unavailable.
                }
            }

            foreach (FeedbackRecordModel row in GetSessionFeedbackRows(projectId, loanNo, feedbackBy, false))
            {
                result.Rows.Add(new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
                {
                    { "Process", row.Process },
                    { "ErrorBy", row.ErrorBy },
                    { "ErrorType", row.ErrorType },
                    { "Category", row.Category },
                    { "SubCategory", row.SubCategory },
                    { "Severity", row.Severity },
                    { "FeedbackType", row.FeedbackType },
                    { "Remark", row.Remark },
                    { "AddedOn", row.AddedOn }
                });
            }

            return result;
        }

        [WebMethod(EnableSession = true)]
        public static bool HasTrackingFeedback(string projectId, string orderNo, string process, string userName)
        {
            return HasFeedbackForLoan(projectId, orderNo, process, userName);
        }

        [WebMethod(EnableSession = true)]
        public static StatusUpdateResult UpdateLoanStatus(StatusUpdateRequest request)
        {
            if (request == null)
                return new StatusUpdateResult { Success = false, Code = 0, Message = "Invalid status update request." };

            if (string.IsNullOrWhiteSpace(request.Status))
                return new StatusUpdateResult { Success = false, Code = 0, Message = "Please select Status." };

            if (string.Equals(request.Status, "Hold", StringComparison.OrdinalIgnoreCase) && string.IsNullOrWhiteSpace(request.HoldRemark))
                return new StatusUpdateResult { Success = false, Code = 0, Message = "Hold Reason is mandatory when Status is Hold." };

            if (!string.IsNullOrWhiteSpace(request.Remark) && !HasFeedbackForLoan(request.ProjectId, request.OrderNo, request.Process, request.UserName))
            {
                return new StatusUpdateResult
                {
                    Success = false,
                    Code = -2,
                    Message = "Please add Feedback before updating Remark."
                };
            }

            try
            {
                Hashtable parameters = new Hashtable();
                parameters["ProjectNumber"] = Clean(request.Project);
                parameters["DealNo"] = Clean(request.DealNo);
                parameters["OrderNumber"] = Clean(request.OrderNo);
                parameters["Process"] = Clean(request.Process);
                parameters["ProjectId"] = Clean(request.ProjectId);
                parameters["UserCode"] = string.IsNullOrWhiteSpace(request.UserName) ? GetCurrentUser() : Clean(request.UserName);

                int returnValue = new bllTracking().ValidateUserProcessTAT(parameters);
                if (returnValue < 0)
                {
                    return new StatusUpdateResult
                    {
                        Success = false,
                        Code = returnValue,
                        Message = "You cannot complete the order before the required process time."
                    };
                }

                return new StatusUpdateResult
                {
                    Success = true,
                    Code = returnValue,
                    Message = "Loan status updated successfully."
                };
            }
            catch (Exception ex)
            {
                return new StatusUpdateResult { Success = false, Code = 0, Message = ex.Message };
            }
        }

        private static void RememberFeedback(FeedbackModel model)
        {
            if (model == null) return;

            string feedbackBy = string.IsNullOrWhiteSpace(model.FeedbackBy) ? GetCurrentUser() : model.FeedbackBy;
            List<FeedbackRecordModel> rows = GetSessionFeedbackRows(model.ProjectId, model.LoanNo, feedbackBy, true);
            rows.Insert(0, new FeedbackRecordModel
            {
                Process = Clean(model.MarkedTo),
                ErrorBy = Clean(model.ErrorBy),
                ErrorType = Clean(model.ErrorType),
                Category = Clean(model.Category),
                SubCategory = Clean(model.SubCategory),
                Severity = Clean(model.Severity),
                FeedbackType = Clean(model.FeedbackType),
                Remark = Clean(model.Remark),
                AddedOn = DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss")
            });
        }

        private static bool HasFeedbackForLoan(string projectId, string orderNo, string process, string userName)
        {
            string cleanedProjectId = Clean(projectId);
            string cleanedOrderNo = Clean(orderNo);
            string cleanedProcess = Clean(process);
            string feedbackBy = string.IsNullOrWhiteSpace(userName) ? GetCurrentUser() : Clean(userName);

            if (GetSessionFeedbackRows(cleanedProjectId, cleanedOrderNo, feedbackBy, false).Count > 0)
                return true;

            int parsedProjectId;
            if (!int.TryParse(cleanedProjectId, out parsedProjectId) || parsedProjectId <= 0 || string.IsNullOrWhiteSpace(cleanedOrderNo) || string.IsNullOrWhiteSpace(cleanedProcess))
                return false;

            try
            {
                bllTracking tracking = new bllTracking();
                DataTable dt = cleanedProjectId == "70" || cleanedProjectId == "217"
                    ? tracking.GetAllProjectFeedbackinERP_Servicing(parsedProjectId, cleanedOrderNo, cleanedProcess, feedbackBy)
                    : tracking.GetAllProjectFeedbackinERP(parsedProjectId, cleanedOrderNo, cleanedProcess, feedbackBy);
                return dt != null && dt.Rows.Count > 0;
            }
            catch
            {
                return false;
            }
        }

        private static List<FeedbackRecordModel> GetSessionFeedbackRows(string projectId, string loanNo, string feedbackBy, bool create)
        {
            HttpSessionStateBase session = new HttpSessionStateWrapper(HttpContext.Current.Session);
            string key = BuildFeedbackSessionKey(projectId, loanNo, feedbackBy);
            List<FeedbackRecordModel> rows = session[key] as List<FeedbackRecordModel>;

            if (rows == null)
            {
                rows = new List<FeedbackRecordModel>();
                if (create) session[key] = rows;
            }

            return rows;
        }

        private static string BuildFeedbackSessionKey(string projectId, string loanNo, string feedbackBy)
        {
            return "AddFeedback.Rows."
                + Clean(projectId).ToUpperInvariant() + "."
                + Clean(loanNo).ToUpperInvariant() + "."
                + Clean(feedbackBy).ToUpperInvariant();
        }

        private static string GetCurrentUser()
        {
            HttpContext context = HttpContext.Current;
            return Clean(Convert.ToString(context.Session["CurrentUserPseudoName"] ?? context.Session["CurrentUser"]));
        }

        private static string Clean(string value)
        {
            return (value ?? string.Empty).Trim();
        }

        private static string Validate(FeedbackModel m)
        {
            if (m == null) return "Invalid feedback data.";
            bool noFeedback = string.Equals(m.ErrorType, "NoFeedback", StringComparison.OrdinalIgnoreCase);

            if (string.IsNullOrWhiteSpace(m.MarkedTo)) return "Please Select Marked to.";
            if (string.IsNullOrWhiteSpace(m.ErrorBy)) return "Please Select Error By.";
            if (string.IsNullOrWhiteSpace(m.ErrorType) || m.ErrorType == "Select") return "Please Select Error Type.";
            if (string.IsNullOrWhiteSpace(m.Category) || m.Category == "Select") return "Please Select Error Category.";
            if (string.IsNullOrWhiteSpace(m.SubCategory) || m.SubCategory == "Select") return "Please Select Error Sub Category.";
            if (!noFeedback && (string.IsNullOrWhiteSpace(m.Severity) || m.Severity == "Select")) return "Please Select Severity.";
            if (!noFeedback && string.IsNullOrWhiteSpace(m.ErrorField)) return "Please Enter Error Field.";
            if (string.IsNullOrWhiteSpace(m.FeedbackType) || m.FeedbackType == "Select") return "Please Select Feedback Type.";
            if (!noFeedback && string.IsNullOrWhiteSpace(m.Error)) return "Please Enter Error.";
            if (!noFeedback && string.IsNullOrWhiteSpace(m.ShouldBe)) return "Please Enter Should Be.";
            if (string.Equals((m.FeedbackBy ?? string.Empty).Trim(), (m.ErrorBy ?? string.Empty).Trim(), StringComparison.OrdinalIgnoreCase))
                return "Feedback Given By and Error Done By both are same is not valid, please check!!.";

            return string.Empty;
        }

        private static List<ErrorCategoryModel> ConvertCategoryTable(DataTable dt)
        {
            var rows = new List<ErrorCategoryModel> { new ErrorCategoryModel { ErrorId = 0, Type = "Select" } };
            if (dt == null) return rows;
            foreach (DataRow dr in dt.Rows)
                rows.Add(new ErrorCategoryModel { ErrorId = Convert.ToInt32(dr["ErrorId"]), Type = Convert.ToString(dr["Type"]) });
            return rows;
        }

        private static List<ErrorSubCategoryModel> ConvertSubCategoryTable(DataTable dt)
        {
            var rows = new List<ErrorSubCategoryModel> { new ErrorSubCategoryModel { ErrorSubId = 0, SubType = "Select" } };
            if (dt == null) return rows;
            foreach (DataRow dr in dt.Rows)
                rows.Add(new ErrorSubCategoryModel { ErrorSubId = Convert.ToInt32(dr["ErrorSubId"]), SubType = Convert.ToString(dr["SubType"]) });
            return rows;
        }




        [WebMethod]
        public static string GetProcessByProject(int ProjectID)
        {
            DataTable dt1 = new bllTracking().getProcess(ProjectID);
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

        public class FeedbackModel
        {
            public string ProjectNo { get; set; }
            public string ProjectId { get; set; }
            public string DealNo { get; set; }
            public string LoanNo { get; set; }
            public string OrderDate { get; set; }
            public string MarkedTo { get; set; }
            public string ErrorBy { get; set; }
            public string FeedbackBy { get; set; }
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

        public class SaveResult { public bool Success { get; set; } public string Message { get; set; } }
        public class FeedbackRecordRequest
        {
            public string ProjectId { get; set; }
            public string LoanNo { get; set; }
            public string Process { get; set; }
            public string FeedbackBy { get; set; }
        }

        public class FeedbackRecordResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public List<Dictionary<string, string>> Rows { get; set; }

            public FeedbackRecordResult()
            {
                Rows = new List<Dictionary<string, string>>();
            }
        }

        public class FeedbackRecordModel
        {
            public string Process { get; set; }
            public string ErrorBy { get; set; }
            public string ErrorType { get; set; }
            public string Category { get; set; }
            public string SubCategory { get; set; }
            public string Severity { get; set; }
            public string FeedbackType { get; set; }
            public string Remark { get; set; }
            public string AddedOn { get; set; }
        }

        public class StatusUpdateRequest
        {
            public string Project { get; set; }
            public string ProjectId { get; set; }
            public string DealNo { get; set; }
            public string OrderNo { get; set; }
            public string Process { get; set; }
            public string Status { get; set; }
            public string HoldRemark { get; set; }
            public string Remark { get; set; }
            public string ProductType { get; set; }
            public string UserName { get; set; }
        }

        public class StatusUpdateResult
        {
            public bool Success { get; set; }
            public int Code { get; set; }
            public string Message { get; set; }
        }
        public class ErrorCategoryModel { public int ErrorId { get; set; } public string Type { get; set; } }
        public class ErrorSubCategoryModel { public int ErrorSubId { get; set; } public string SubType { get; set; } }
        public class ListItemModel { public string Value { get; set; } public string Text { get; set; } }

        public class PageDefaultModel
        {
            public string ProjectNo { get; set; }
            public string DealNo { get; set; }
            public string LoanNo { get; set; }
            public string OrderDate { get; set; }
            public string ProjectId { get; set; }
            public string Process { get; set; }
            public string ErrorBy { get; set; }
            public string FeedbackBy { get; set; }
            public List<ListItemModel> ErrorByList { get; set; }

            public PageDefaultModel()
            {
                ErrorByList = new List<ListItemModel>();
            }
        }
    }
}
