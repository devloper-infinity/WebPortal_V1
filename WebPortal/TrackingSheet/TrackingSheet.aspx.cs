using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.Services;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.TrackingSheet
{
    public partial class TrackingSheetPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
        [WebMethod] public static string GetProjects() { return OLTrackingWeb.Json(new bllOLTracking().GetProjectsByUser(OLTrackingWeb.UserId)); }
        [WebMethod] public static string GetDeals(int projectId) { return OLTrackingWeb.Json(new bllOLTracking().GetSourceDeals(projectId, OLTrackingWeb.UserId)); }
        [WebMethod] public static string GetFlow(int projectId) { return OLTrackingWeb.Json(new bllOLTracking().GetProcessFlow(projectId)); }
        [WebMethod]
        public static AvailableLoanResult GetAvailableLoan(int projectId, string dealNumber, int processId, string processName)
        {
            System.Data.DataTable available = new bllOLTracking().GetAvailableLoan(projectId, dealNumber, processId, processName, OLTrackingWeb.UserId);
            if (available.Rows.Count == 0)
                return new AvailableLoanResult { LoanNumber = string.Empty, DealNumber = dealNumber ?? string.Empty };
            return new AvailableLoanResult
            {
                LoanNumber = Convert.ToString(available.Rows[0]["LoanNumber"]),
                DealNumber = Convert.ToString(available.Rows[0]["DealNumber"])
            };
        }
        [WebMethod]
        public static TrackingActionResult Allocate(int projectId, int processId, string loanNumber, string dealNumber)
        {
            try
            {
                int assignmentId = new bllOLTracking().AllocateLoan(projectId, processId, loanNumber, dealNumber, OLTrackingWeb.UserId);
                return new TrackingActionResult { Success = assignmentId > 0, Message = assignmentId > 0 ? "Loan allocated successfully." : "Unable to allocate the selected loan." };
            }
            catch (Exception exception)
            {
                return new TrackingActionResult { Success = false, Message = UserMessage(exception) };
            }
        }
        [WebMethod]
        public static string GetQueue()
        {
            bllOLTracking tracking = new bllOLTracking();
            return OLTrackingWeb.Json(AddProjectNames(tracking.GetTrackingQueue(OLTrackingWeb.UserId), tracking));
        }
        [WebMethod] public static string GetDailyProcesses() { return OLTrackingWeb.Json(new bllOLTracking().GetUserDailyProcesses(OLTrackingWeb.UserId)); }
        [WebMethod]
        public static TrackingActionResult StartLoan(long assignmentId)
        {
            try
            {
                new bllOLTracking().StartLoan(assignmentId, OLTrackingWeb.UserId);
                return new TrackingActionResult { Success = true, Message = "Loan marked In Process." };
            }
            catch (Exception exception)
            {
                return new TrackingActionResult { Success = false, Message = UserMessage(exception) };
            }
        }
        [WebMethod]
        public static TrackingActionResult HoldLoan(long assignmentId, string holdReason)
        {
            try
            {
                if (!IsValidHoldReason(holdReason))
                    return new TrackingActionResult { Success = false, Message = "Please select a valid hold reason." };
                new bllOLTracking().HoldLoan(assignmentId, holdReason, OLTrackingWeb.UserId);
                return new TrackingActionResult { Success = true, Message = "Loan placed on hold successfully." };
            }
            catch (Exception exception)
            {
                return new TrackingActionResult { Success = false, Message = UserMessage(exception) };
            }
        }
        [WebMethod]
        public static TrackingActionResult ResumeLoan(long assignmentId)
        {
            try
            {
                new bllOLTracking().ResumeLoan(assignmentId, OLTrackingWeb.UserId);
                return new TrackingActionResult { Success = true, Message = "Loan resumed successfully." };
            }
            catch (Exception exception)
            {
                return new TrackingActionResult { Success = false, Message = UserMessage(exception) };
            }
        }
        [WebMethod]
        public static TrackingActionResult CompleteLoan(long assignmentId, string remark, string[] feedbacks)
        {
            try
            {
                new bllOLTracking().CompleteLoan(assignmentId, remark, feedbacks, OLTrackingWeb.UserId);
                return new TrackingActionResult { Success = true, Message = "Loan completed successfully." };
            }
            catch (Exception exception)
            {
                return new TrackingActionResult { Success = false, Message = UserMessage(exception) };
            }
        }
        [WebMethod]
        public static string GetFeedbackDefaults(long assignmentId)
        {
            return OLTrackingWeb.Json(new bllOLTracking().GetFeedbackDefaults(assignmentId, OLTrackingWeb.UserId, EmployeeInfo.Current.PseudoName));
        }
        [WebMethod]
        public static List<FeedbackListItem> GetFeedbackCategories()
        {
            return FeedbackList("usp_WBT_TrackingSheet_ErrorCategory", null, "ErrorId", "Type");
        }
        [WebMethod]
        public static List<FeedbackListItem> GetFeedbackSubcategories(int categoryId)
        {
            SqlParameter parameter = new SqlParameter("@Id", SqlDbType.BigInt) { Value = categoryId };
            return FeedbackList("usp_WBT_TrackingSheet_ErrorSuvCategory", parameter, "ErrorSubId", "SubType");
        }
        [WebMethod]
        public static FeedbackSaveResult SaveFeedback(TrackingFeedbackModel model)
        {
            try
            {
                string validation = ValidateFeedback(model);
                if (validation.Length > 0) return new FeedbackSaveResult { Success = false, Message = validation };

                DataTable saved = new bllOLTracking().SaveFeedback(model.AssignmentID, model.MarkedTo, model.ErrorBy,
                    model.FeedbackBy, model.ErrorType, model.CategoryID, model.Category, model.SubcategoryID,
                    model.Subcategory, model.Severity, model.ErrorField, model.Screen, model.FeedbackType, model.Error,
                    model.ShouldBe, model.Remark, model.DateReviewed, OLTrackingWeb.UserId);
                return new FeedbackSaveResult
                {
                    Success = saved.Rows.Count > 0,
                    Message = "Feedback added successfully.",
                    FeedbackID = saved.Rows.Count == 0 ? 0 : Convert.ToInt64(saved.Rows[0]["FeedbackID"]),
                    FeedbackCount = saved.Rows.Count == 0 ? 0 : Convert.ToInt32(saved.Rows[0]["FeedbackCount"])
                };
            }
            catch (Exception exception)
            {
                return new FeedbackSaveResult { Success = false, Message = UserMessage(exception) };
            }
        }
        [WebMethod] public static string GetDailyStatus(int processId, string fromDate, string toDate)
        {
            DateTime parsed; DateTime? from = DateTime.TryParseExact(fromDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed) ? parsed : (DateTime?)null;
            DateTime? to = DateTime.TryParseExact(toDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed) ? parsed : (DateTime?)null;
            bllOLTracking tracking = new bllOLTracking();
            return OLTrackingWeb.Json(AddProjectNames(tracking.GetUserDailyStatus(OLTrackingWeb.UserId, processId, from, to), tracking));
        }

        private static DataTable AddProjectNames(DataTable rows, bllOLTracking tracking)
        {
            if (rows == null || !rows.Columns.Contains("ProjectID")) return rows;

            if (!rows.Columns.Contains("ProjectName"))
                rows.Columns.Add("ProjectName", typeof(string));

            DataTable projects = tracking.GetProjectsByUser(OLTrackingWeb.UserId);
            Dictionary<int, string> names = new Dictionary<int, string>();
            if (projects.Columns.Contains("ProjectID") && projects.Columns.Contains("ProjectName"))
            {
                foreach (DataRow project in projects.Rows)
                {
                    int projectId;
                    if (int.TryParse(Convert.ToString(project["ProjectID"]), out projectId))
                        names[projectId] = Convert.ToString(project["ProjectName"]);
                }
            }

            foreach (DataRow row in rows.Rows)
            {
                int projectId;
                string projectName;
                if (int.TryParse(Convert.ToString(row["ProjectID"]), out projectId) && names.TryGetValue(projectId, out projectName))
                    row["ProjectName"] = projectName;
                else
                    row["ProjectName"] = Convert.ToString(row["ProjectID"]);
            }
            return rows;
        }

        private static bool IsValidHoldReason(string holdReason)
        {
            switch ((holdReason ?? string.Empty).Trim())
            {
                case "PDF Issue":
                case "Audit Worksheet Not available in Box":
                case "Partially Review in Scienna":
                case "Wrongly pulled in ERP":
                case "Miscellaneous - Any other issue with comments":
                    return true;
                default:
                    return false;
            }
        }

        private static string UserMessage(Exception exception)
        {
            SqlException sqlException = exception as SqlException;
            if (sqlException == null)
                return "The requested action could not be completed. Please try again.";

            switch (sqlException.Number)
            {
                case 2812: return "The completion service is not installed. Please contact the administrator.";
                case 50110: return "You already have two Pending/In Process loans. Complete or place one on hold before allocating another.";
                case 50111: return "The selected process is no longer available in this project's process flow.";
                case 50112: return "This loan is already allocated or completed for the selected process.";
                case 50113: return "The required previous process has not been completed for this loan.";
                case 50120: return "This loan is no longer available in your Pending queue.";
                case 50121: return "A completion remark is required.";
                case 50122: return "This assignment is no longer available in your queue.";
                case 50123: return "Feedback is mandatory before completing this process.";
                case 50124: return "Feedback cannot be added because this loan is no longer in your queue.";
                case 50125: return "This loan is not currently on hold.";
                case 50126: return "A hold reason is required.";
                case 50127: return "Resume the loan before completing it.";
                case 50128: return "One or more selected loans are no longer eligible.";
                case 50129: return "You already have two Pending/In Process loans. Complete or hold one before resuming this loan.";
                case 50130: return "Select one or two loans.";
                case 50131: return "The selected user is not configured for this project.";
                default: return "The requested action could not be completed. Please refresh the page and try again.";
            }
        }

        private static List<FeedbackListItem> FeedbackList(string procedure, SqlParameter parameter, string valueColumn, string textColumn)
        {
            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, procedure);
            if (parameter != null) command.Parameters.Add(parameter);
            DataTable table = SQLHelper.ExecuteDataTableCmd(command);
            List<FeedbackListItem> result = new List<FeedbackListItem>();
            foreach (DataRow row in table.Rows)
                result.Add(new FeedbackListItem { Value = Convert.ToString(row[valueColumn]), Text = Convert.ToString(row[textColumn]) });
            return result;
        }

        private static string ValidateFeedback(TrackingFeedbackModel model)
        {
            if (model == null) return "Invalid feedback data.";
            if (string.IsNullOrWhiteSpace(model.MarkedTo)) return "Please select Marked to.";
            if (string.IsNullOrWhiteSpace(model.ErrorBy)) return "Please select Error By.";
            if (string.IsNullOrWhiteSpace(model.ErrorType)) return "Please enter Error Type.";
            if (model.CategoryID <= 0 || string.IsNullOrWhiteSpace(model.Category)) return "Please select Category.";
            if (model.SubcategoryID <= 0 || string.IsNullOrWhiteSpace(model.Subcategory)) return "Please select Subcategory.";
            if (string.IsNullOrWhiteSpace(model.Severity)) return "Please select Severity.";
            if (string.IsNullOrWhiteSpace(model.ErrorField)) return "Please enter Error Field.";
            if (string.IsNullOrWhiteSpace(model.FeedbackType)) return "Please enter Feedback Type.";
            if (string.IsNullOrWhiteSpace(model.Error)) return "Please enter Finding.";
            return string.Empty;
        }
    }

    public sealed class AvailableLoanResult
    {
        public string LoanNumber { get; set; }
        public string DealNumber { get; set; }
    }

    public class TrackingActionResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
    }

    public sealed class FeedbackListItem { public string Value { get; set; } public string Text { get; set; } }
    public sealed class FeedbackSaveResult : TrackingActionResult
    {
        public long FeedbackID { get; set; }
        public int FeedbackCount { get; set; }
    }
    public sealed class TrackingFeedbackModel
    {
        public long AssignmentID { get; set; }
        public string MarkedTo { get; set; }
        public string ErrorBy { get; set; }
        public string FeedbackBy { get; set; }
        public string ErrorType { get; set; }
        public int CategoryID { get; set; }
        public string Category { get; set; }
        public int SubcategoryID { get; set; }
        public string Subcategory { get; set; }
        public string Severity { get; set; }
        public string ErrorField { get; set; }
        public string Screen { get; set; }
        public string FeedbackType { get; set; }
        public string Error { get; set; }
        public string ShouldBe { get; set; }
        public string Remark { get; set; }
        public string DateReviewed { get; set; }
    }
}
