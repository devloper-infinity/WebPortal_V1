using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Feedback
{
    public partial class AddFeedbackForSearchProject : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static AddFeedbackContext GetPageContext()
        {
            HttpRequest request = HttpContext.Current.Request;
            bllFeedback bll = new bllFeedback();
            AddFeedbackContext context = new AddFeedbackContext();
            context.Mode = "New";
            context.Today = DateTime.Now.ToString("dd-MMM-yyyy");
            context.CurrentUserCode = bll.GetUserCodeByEmployeeID(CurrentEmployee());
            if (string.IsNullOrWhiteSpace(context.CurrentUserCode))
                context.CurrentUserCode = CurrentEmployee();
            context.Projects = ToRows(bll.GetAllProjectByUserRights(CurrentEmployee()));
            context.NewOrders = ToRows(bll.ViewNewOrderFeedbackByOrderWise(CurrentEmployee()));
            context.BackUrl = "ViewAllFeedbackByUserWise.aspx";
            context.ButtonText = "ADD";

            if (!string.IsNullOrWhiteSpace(request.QueryString["PMWise"]))
            {
                context.Mode = "PMWise";
                context.ShowPM = true;
                context.IsReadOnly = true;
                context.BackUrl = "ViewAllFeedbackByPMWise.aspx";
                context.ButtonText = "Submit";
                context.Record = FirstRow(bll.ViewAllFeedbackByRecordWise(request.QueryString["PMWise"]));
                context.Total = context.Record == null ? 0 : 1;
                return context;
            }

            if (!string.IsNullOrWhiteSpace(request.QueryString["Edit"]))
            {
                context.Mode = "Edit";
                context.ShowPM = true;
                context.IsReadOnly = true;
                context.BackUrl = "ViewAllFeedbackByPMWise.aspx";
                context.ButtonText = "Update";
                context.Record = FirstRow(bll.ViewAllFeedbackByRecordWise(request.QueryString["Edit"]));
                context.Total = context.Record == null ? 0 : 1;
                return context;
            }

            if (!string.IsNullOrWhiteSpace(request.QueryString["OrderNo"]))
            {
                DataTable rows = bll.ViewFeedbackByOrderWise(request.QueryString["OrderNo"]);
                context.Mode = "Order";
                context.ShowEDB = true;
                context.IsReadOnly = true;
                context.OrderNo = request.QueryString["OrderNo"];
                context.ButtonText = rows != null && rows.Rows.Count > 1 ? "Next" : "Submit";
                context.Total = rows == null ? 0 : rows.Rows.Count;
                context.Record = FirstRow(rows);
                return context;
            }

            if (!string.IsNullOrWhiteSpace(request.QueryString["User"]))
            {
                DataTable rows = bll.ViewFeedbackByUserWise(request.QueryString["User"], request.QueryString["Fatal"]);
                context.Mode = "User";
                context.ShowEDB = true;
                context.IsReadOnly = true;
                context.SourceEmployeeID = request.QueryString["User"];
                context.Fatal = request.QueryString["Fatal"];
                context.ButtonText = rows != null && rows.Rows.Count > 1 ? "Next" : "Submit";
                context.Total = rows == null ? 0 : rows.Rows.Count;
                context.Record = FirstRow(rows);
                return context;
            }

            if (!string.IsNullOrWhiteSpace(request.QueryString["EmployeeID"]))
            {
                DataTable rows = bll.ViewFeedbackByPMWise(request.QueryString["EmployeeID"], request.QueryString["Fatal"]);
                context.Mode = "Employee";
                context.ShowPM = true;
                context.IsReadOnly = true;
                context.BackUrl = "ViewAllFeedbackByPMWise.aspx";
                context.SourceEmployeeID = request.QueryString["EmployeeID"];
                context.Fatal = request.QueryString["Fatal"];
                context.ButtonText = rows != null && rows.Rows.Count > 1 ? "Next" : "Submit";
                context.Total = rows == null ? 0 : rows.Rows.Count;
                context.Record = FirstRow(rows);
                return context;
            }

            if (!string.IsNullOrWhiteSpace(request.QueryString["ProcessFeedbak"]))
            {
                context.Mode = "Process";
                context.Record = BuildProcessRecord(request, bll);
            }

            return context;
        }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetProcesses(int projectId)
        {
            return ToRows(new bllFeedback().GetProcess(projectId));
        }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetSections(int projectId)
        {
            return ToRows(new bllFeedback().CheckProjectIsApplicableForSectionField(projectId));
        }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetFields(int projectId, string section)
        {
            return ToRows(new bllFeedback().GetFieldBySection(projectId, Safe(section)));
        }

        [WebMethod(EnableSession = true)]
        public static AddFeedbackResult SaveFeedback(FeedbackEntryModel model)
        {
            if (model == null)
                return AddFeedbackResult.Fail("Invalid feedback data.");

            if (IsStatusMode(model.Mode))
                return SaveStatus(model);

            string validation = ValidateNewFeedback(model);
            if (!string.IsNullOrEmpty(validation))
                return AddFeedbackResult.Fail(validation);

            bllFeedback bll = new bllFeedback();
            string projectRights = bll.ValidateUserProjectRights(model.ErrorDoneBy, Convert.ToString(model.ProjectID));
            if (projectRights == "0")
                return AddFeedbackResult.Fail("Error Done By is not assigned to selected project.");
            if (bll.ValidateEmployeeCode(model.ErrorDoneBy) == "0")
                return AddFeedbackResult.Fail("Error Done By is not valid.");
            if (bll.ValidateEmployeeCode(model.FeedbackGivenBy) == "0")
                return AddFeedbackResult.Fail("Feedback Given By is not valid.");

            Hashtable values = BuildFeedbackHashtable(model);
            int feedbackId = bll.InsertFeedbackForNewOrder(values);
            if (feedbackId <= 0)
                return AddFeedbackResult.Fail("Feedback already added or could not be saved.");

            values["Feedback"] = feedbackId;
            int detailResult = bll.AddFeedbackForNewOrder(values);
            return detailResult > 0
                ? AddFeedbackResult.Ok("New order added successfully.")
                : AddFeedbackResult.Fail("Feedback header was saved, but detail save failed.");
        }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetNewOrderRows()
        {
            return ToRows(new bllFeedback().ViewNewOrderFeedbackByOrderWise(CurrentEmployee()));
        }

        private static AddFeedbackResult SaveStatus(FeedbackEntryModel model)
        {
            if (model.FeedDetailsId <= 0)
                return AddFeedbackResult.Fail("Invalid feedback record.");

            Hashtable values = new Hashtable();
            values["FeedDetailsId"] = model.FeedDetailsId;
            values["AddedBy"] = CurrentEmployeeId();
            int result;
            bllFeedback bll = new bllFeedback();

            if (string.Equals(model.Mode, "Order", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(model.Mode, "User", StringComparison.OrdinalIgnoreCase))
            {
                if (string.IsNullOrWhiteSpace(model.EDBStatus) || model.EDBStatus == "Select")
                    return AddFeedbackResult.Fail("Please select Status.");
                if (model.EDBStatus == "Rejected" && string.IsNullOrWhiteSpace(model.EDBExplanation))
                    return AddFeedbackResult.Fail("Please enter Explanation.");

                values["EDBStatus"] = model.EDBStatus;
                values["EDBExplanation"] = Safe(model.EDBExplanation);
                result = bll.AddEDBStatusByOrderWise(values);
            }
            else
            {
                if (string.IsNullOrWhiteSpace(model.PMStatus) || model.PMStatus == "Select")
                    return AddFeedbackResult.Fail("Please select PM Status.");
                if (string.IsNullOrWhiteSpace(model.PMExplanation))
                    return AddFeedbackResult.Fail("Please enter PM Remark.");

                values["PMStatus"] = model.PMStatus;
                values["PMExplanation"] = Safe(model.PMExplanation);
                result = bll.AddPMStatusByOrderWise(values);
            }

            if (result <= 0)
                return AddFeedbackResult.Fail("Unable to update status.");

            DataTable rows = LoadModeRows(model, bll);
            int nextIndex = model.Index + 1;
            if (rows != null && nextIndex < rows.Rows.Count)
            {
                AddFeedbackResult next = AddFeedbackResult.Ok("Status added successfully.");
                next.Index = nextIndex;
                next.Total = rows.Rows.Count;
                next.Record = RowToDictionary(rows.Rows[nextIndex]);
                next.Message = "Status added successfully. Showing next feedback.";
                return next;
            }

            AddFeedbackResult done = AddFeedbackResult.Ok("Status added successfully.");
            done.RedirectUrl = BackUrlForMode(model.Mode);
            return done;
        }

        private static DataTable LoadModeRows(FeedbackEntryModel model, bllFeedback bll)
        {
            if (string.Equals(model.Mode, "Order", StringComparison.OrdinalIgnoreCase))
                return bll.ViewFeedbackByOrderWise(model.SourceOrderNo);
            if (string.Equals(model.Mode, "User", StringComparison.OrdinalIgnoreCase))
                return bll.ViewFeedbackByUserWise(model.SourceEmployeeID, model.Fatal);
            if (string.Equals(model.Mode, "Employee", StringComparison.OrdinalIgnoreCase))
                return bll.ViewFeedbackByPMWise(model.SourceEmployeeID, model.Fatal);
            return null;
        }

        private static Dictionary<string, object> BuildProcessRecord(HttpRequest request, bllFeedback bll)
        {
            Dictionary<string, object> record = new Dictionary<string, object>();
            string projectName = request.QueryString["ProjectName"];
            string processName = request.QueryString["Process"];
            string projectId = bll.ValidateProject(projectName);
            string processId = string.IsNullOrWhiteSpace(projectId) || projectId == "0"
                ? string.Empty
                : bll.ValidateProcess(projectId, processName);

            record["OrderNo"] = request.QueryString["ProcessFeedbak"];
            record["ProjectID"] = projectId;
            record["ProcessID"] = processId;
            record["OrderDate"] = DateTime.Now.ToString("dd-MMM-yyyy");
            record["FeedbackBy"] = bll.GetUserCodeByEmployeeID(CurrentEmployee());
            return record;
        }

        private static Hashtable BuildFeedbackHashtable(FeedbackEntryModel model)
        {
            Hashtable values = new Hashtable();
            values["OrderNo"] = Safe(model.OrderNo);
            values["DealNo"] = Safe(model.DealNo);
            values["OrderDate"] = Safe(model.OrderDate);
            values["ProjectID"] = model.ProjectID;
            values["ProcessID"] = model.ProcessID;
            values["ErrorDoneBy"] = Safe(model.ErrorDoneBy).ToUpper();
            values["FeedbackGivenBy"] = Safe(model.FeedbackGivenBy).ToUpper();
            values["ErrorType"] = Safe(model.ErrorType);
            values["Fatal"] = Safe(model.FatalType);
            values["ErrorField"] = Safe(model.ErrorField);
            values["Section"] = Safe(model.Section == "Select" ? string.Empty : model.Section);
            values["Field"] = Safe(model.Field == "Select" ? string.Empty : model.Field);
            values["Error"] = Safe(model.Error);
            values["Shouldbe"] = Safe(model.ShouldBe);
            values["FeedbackType"] = Safe(model.FeedbackType);
            values["FeedbackON"] = Safe(model.FeedbackType);
            values["FeedbackRecivedDate"] = Safe(model.FeedbackRecivedDate);
            values["Remark"] = Safe(model.Remark);
            values["FeedbackerrorPath"] = string.Empty;
            values["AddedBy"] = CurrentEmployeeId();
            return values;
        }

        private static string ValidateNewFeedback(FeedbackEntryModel model)
        {
            bool noFeedback = string.Equals(model.ErrorType, "NoFeedback", StringComparison.OrdinalIgnoreCase);
            if (model.ProjectID <= 0) return "Please select Project.";
            if (model.ProcessID <= 0) return "Please select Process.";
            if (string.IsNullOrWhiteSpace(model.OrderNo)) return "Please enter Order #.";
            if (string.IsNullOrWhiteSpace(model.OrderDate)) return "Please select Order Date.";
            if (string.IsNullOrWhiteSpace(model.ErrorDoneBy)) return "Please enter Error Done By.";
            if (string.IsNullOrWhiteSpace(model.FeedbackGivenBy)) return "Please enter Feedback given By.";
            if (string.Equals(Safe(model.ErrorDoneBy), Safe(model.FeedbackGivenBy), StringComparison.OrdinalIgnoreCase))
                return "Feedback Given By and Error Done By both are same is not valid, please check.";
            if (string.IsNullOrWhiteSpace(model.ErrorType) || model.ErrorType == "Select") return "Please select Error Type.";
            if (!noFeedback && (string.IsNullOrWhiteSpace(model.FatalType) || model.FatalType == "Select")) return "Please select Critical/Non-Critical.";
            if (!noFeedback && string.IsNullOrWhiteSpace(model.Error) ) return "Please enter Error.";
            if (!noFeedback && string.IsNullOrWhiteSpace(model.ShouldBe)) return "Please enter Should be.";
            if (string.IsNullOrWhiteSpace(model.FeedbackType) || model.FeedbackType == "Select") return "Please select Feedback Type.";
            if (model.FeedbackType == "Client" && string.IsNullOrWhiteSpace(model.FeedbackRecivedDate)) return "Please select Feedback Received Date.";
            return string.Empty;
        }

        private static bool IsStatusMode(string mode)
        {
            return string.Equals(mode, "Order", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(mode, "User", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(mode, "Employee", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(mode, "PMWise", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(mode, "Edit", StringComparison.OrdinalIgnoreCase);
        }

        private static string BackUrlForMode(string mode)
        {
            if (string.Equals(mode, "Employee", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(mode, "PMWise", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(mode, "Edit", StringComparison.OrdinalIgnoreCase))
                return "ViewAllFeedbackByPMWise.aspx";
            return "ViewAllFeedbackByUserWise.aspx";
        }

        private static string CurrentEmployee()
        {
            return Convert.ToString(HttpContext.Current.User.Identity.Name);
        }

        private static int CurrentEmployeeId()
        {
            int employeeId;
            return int.TryParse(CurrentEmployee(), out employeeId) ? employeeId : 0;
        }

        private static string Safe(string value)
        {
            return value == null ? string.Empty : value.Trim();
        }

        private static Dictionary<string, object> FirstRow(DataTable table)
        {
            return table != null && table.Rows.Count > 0 ? RowToDictionary(table.Rows[0]) : null;
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;

            foreach (DataRow dataRow in table.Rows)
                rows.Add(RowToDictionary(dataRow));
            return rows;
        }

        private static Dictionary<string, object> RowToDictionary(DataRow dataRow)
        {
            Dictionary<string, object> row = new Dictionary<string, object>();
            foreach (DataColumn column in dataRow.Table.Columns)
                row[column.ColumnName] = dataRow[column] == DBNull.Value ? null : dataRow[column];
            return row;
        }
    }

    public class AddFeedbackContext
    {
        public string Mode { get; set; }
        public string Today { get; set; }
        public string CurrentUserCode { get; set; }
        public string BackUrl { get; set; }
        public string ButtonText { get; set; }
        public string SourceEmployeeID { get; set; }
        public string Fatal { get; set; }
        public string OrderNo { get; set; }
        public bool ShowEDB { get; set; }
        public bool ShowPM { get; set; }
        public bool IsReadOnly { get; set; }
        public int Index { get; set; }
        public int Total { get; set; }
        public Dictionary<string, object> Record { get; set; }
        public List<Dictionary<string, object>> Projects { get; set; }
        public List<Dictionary<string, object>> NewOrders { get; set; }
    }

    public class FeedbackEntryModel
    {
        public string Mode { get; set; }
        public string SourceEmployeeID { get; set; }
        public string Fatal { get; set; }
        public string SourceOrderNo { get; set; }
        public int Index { get; set; }
        public int FeedDetailsId { get; set; }
        public string OrderNo { get; set; }
        public string DealNo { get; set; }
        public string OrderDate { get; set; }
        public int ProjectID { get; set; }
        public int ProcessID { get; set; }
        public string ErrorDoneBy { get; set; }
        public string FeedbackGivenBy { get; set; }
        public string ErrorType { get; set; }
        public string FatalType { get; set; }
        public string ErrorField { get; set; }
        public string Section { get; set; }
        public string Field { get; set; }
        public string Error { get; set; }
        public string ShouldBe { get; set; }
        public string FeedbackType { get; set; }
        public string FeedbackRecivedDate { get; set; }
        public string Remark { get; set; }
        public string EDBStatus { get; set; }
        public string EDBExplanation { get; set; }
        public string PMStatus { get; set; }
        public string PMExplanation { get; set; }
    }

    public class AddFeedbackResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string RedirectUrl { get; set; }
        public int Index { get; set; }
        public int Total { get; set; }
        public Dictionary<string, object> Record { get; set; }

        public static AddFeedbackResult Ok(string message)
        {
            return new AddFeedbackResult { Success = true, Message = message };
        }

        public static AddFeedbackResult Fail(string message)
        {
            return new AddFeedbackResult { Success = false, Message = message };
        }
    }
}
