using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebPortal.Tracking
{
    public partial class AddFeedback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //hdnProjectNo.Value = Request.QueryString["ProjectNo"] ?? string.Empty;
                //hdnDealNo.Value = Request.QueryString["DealNo"] ?? string.Empty;
                //hdnLoanNo.Value = Request.QueryString["LoanNo"] ?? string.Empty;
                //hdnOrderDate.Value = Request.QueryString["OrderDate"] ?? string.Empty;
                //hdnProjectId.Value = Request.QueryString["ProjectId"] ?? string.Empty;
                //hdnProcess.Value = Request.QueryString["Process"] ?? string.Empty;
                //hdnErrorBy.Value = Request.QueryString["ErrorBy"] ?? string.Empty;
            }
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

                return new SaveResult { Success = true, Message = "Feedback Added Sucessfully." };
            }
            catch (Exception ex)
            {
                return new SaveResult { Success = false, Message = ex.Message };
            }
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