using ClosedXML.Excel;
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

namespace WebPortal.Feedback
{
    public partial class ImportFeedback : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.Equals(Request.QueryString["handler"], "Upload", StringComparison.OrdinalIgnoreCase))
            {
                WriteJson(HandleUpload());
                Response.End();
            }
        }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetProjects()
        {
            return ToRows(new bllFeedback().GetAllProjectByUserRights(CurrentEmployee()));
        }

        private ImportFeedbackResult HandleUpload()
        {
            try
            {
                if (Request.Files.Count == 0)
                    return ImportFeedbackResult.Fail("Please select Excel file.");

                HttpPostedFile file = Request.Files[0];
                string extension = Path.GetExtension(file.FileName);
                if (!string.Equals(extension, ".xls", StringComparison.OrdinalIgnoreCase) &&
                    !string.Equals(extension, ".xlsx", StringComparison.OrdinalIgnoreCase))
                    return ImportFeedbackResult.Fail("Please select only .xls or .xlsx file.");

                DataTable table = ReadExcel(file);
                if (table == null || table.Rows.Count == 0)
                    return ImportFeedbackResult.Fail("Excel file does not contain feedback rows.");

                ImportOptions options = new ImportOptions();
                options.Mode = Safe(Request.QueryString["mode"]);
                options.ProjectID = ToInt(Request.Form["ProjectID"]);
                options.DealNo = Safe(Request.Form["DealNo"]);
                options.OrderNo = Safe(Request.Form["OrderNo"]);
                return ImportRows(table, options);
            }
            catch (Exception ex)
            {
                return ImportFeedbackResult.Fail(ex.Message);
            }
        }

        private static ImportFeedbackResult ImportRows(DataTable table, ImportOptions options)
        {
            ImportFeedbackResult result = new ImportFeedbackResult { Success = true, Message = "Feedback import completed." };
            bllFeedback bll = new bllFeedback();

            foreach (DataRow row in table.Rows)
            {
                Dictionary<string, object> rowValues = RowToDictionary(row);
                result.TotalCount++;

                string errorMessage = ValidateAndSaveRow(row, rowValues, options, bll);
                if (string.IsNullOrWhiteSpace(errorMessage))
                {
                    result.AddedCount++;
                    result.AddedRows.Add(rowValues);
                }
                else
                {
                    result.RejectedCount++;
                    rowValues["ErrorMSG"] = errorMessage;
                    result.RejectedRows.Add(rowValues);
                }
            }

            if (result.RejectedCount > 0 && result.AddedCount == 0)
                result.Message = "No feedback rows were added. Please review rejected rows.";
            else if (result.RejectedCount > 0)
                result.Message = "Feedback import completed with rejected rows.";

            return result;
        }

        private static string ValidateAndSaveRow(DataRow row, Dictionary<string, object> rowValues, ImportOptions options, bllFeedback bll)
        {
            string orderNo = FirstCell(row, "Order #", "Order No", "Loan No", "Loan 1 #");
            string dealNo = FirstCell(row, "Deal No", "DealNo");
            string orderDate = FirstCell(row, "Order Date", "OrderDate");
            string projectName = FirstCell(row, "Project #", "Project", "Project Name", "Client");
            string processName = FirstCell(row, "Process", "Process Name");
            string errorDoneBy = FirstCell(row, "Error Done By", "UW Name", "ErrorDoneBy");
            string feedbackBy = FirstCell(row, "Feedback given By", "Feedback By", "QC Name", "FeedbackBy");
            string errorField = FirstCell(row, "Error Field", "FeildName");
            string section = FirstCell(row, "Section");
            string field = FirstCell(row, "Field", "Field Name");
            string error = FirstCell(row, "Error", "Finding");
            string shouldBe = FirstCell(row, "Should be", "ShouldBe", "RCA");
            string errorType = FirstCell(row, "Error Type", "ErrorType");
            string fatal = FirstCell(row, "Fatal/Non-Fatal", "Critical/Non-Critical", "Severity", "Fatal");
            string feedbackType = FirstCell(row, "Feedback Type", "FeedbackType");
            string feedbackReceivedDate = FirstCell(row, "Feedback Received Date", "FeedbackRecivedDate");
            string remark = FirstCell(row, "Remark", "Comments");

            if (string.IsNullOrWhiteSpace(orderNo))
                orderNo = options.OrderNo;
            if (string.IsNullOrWhiteSpace(dealNo))
                dealNo = options.DealNo;
            if (string.IsNullOrWhiteSpace(orderDate))
                orderDate = DateTime.Now.ToString("dd-MMM-yyyy");

            int projectId = options.ProjectID;
            if (projectId <= 0)
            {
                string projectValue = bll.ValidateProject(projectName);
                projectId = ToInt(projectValue);
            }

            if (projectId <= 0)
                return "Project does not exist.";

            int processId = ToInt(bll.ValidateProcess(Convert.ToString(projectId), processName));
            if (processId <= 0)
                return "Process does not exist for project.";
            if (string.IsNullOrWhiteSpace(orderNo))
                return "Order # is required.";
            if (string.IsNullOrWhiteSpace(errorDoneBy))
                return "Error Done By is required.";
            if (string.IsNullOrWhiteSpace(feedbackBy))
                return "Feedback given By is required.";
            if (string.Equals(errorDoneBy.Trim(), feedbackBy.Trim(), StringComparison.OrdinalIgnoreCase))
                return "Feedback Given By and Error Done By both are same.";
            if (bll.ValidateEmployeeCode(errorDoneBy) == "0")
                return "Error Done By is not valid.";
            if (bll.ValidateEmployeeCode(feedbackBy) == "0")
                return "Feedback given By is not valid.";
            if (bll.ValidateUserProjectRights(errorDoneBy, Convert.ToString(projectId)) == "0")
                return "Error Done By is not assigned to selected project.";

            bool noFeedback = string.Equals(errorType, "NoFeedback", StringComparison.OrdinalIgnoreCase);
            if (string.IsNullOrWhiteSpace(errorType))
                return "Error Type is required.";
            if (!noFeedback && string.IsNullOrWhiteSpace(fatal))
                return "Fatal/Non-Fatal is required.";
            if (!noFeedback && string.IsNullOrWhiteSpace(error))
                return "Error is required.";
            if (!noFeedback && string.IsNullOrWhiteSpace(shouldBe))
                return "Should be is required.";
            if (string.IsNullOrWhiteSpace(feedbackType))
                return "Feedback Type is required.";
            if (string.Equals(feedbackType, "Client", StringComparison.OrdinalIgnoreCase) && string.IsNullOrWhiteSpace(feedbackReceivedDate))
                return "Feedback Received Date is required for Client feedback.";

            int sectionFieldRequired = ToInt(bll.ValidateSectionAndFieldByProject(Convert.ToString(projectId)));
            if (!noFeedback && sectionFieldRequired > 0)
            {
                if (string.IsNullOrWhiteSpace(section))
                    return "Section is required.";
                if (string.IsNullOrWhiteSpace(field))
                    return "Field is required.";
                if (bll.ValidateSection(Convert.ToString(projectId), section) == "0")
                    return "Section is not valid for project.";
                if (bll.ValidateFieldName(Convert.ToString(projectId), section, field) == "0")
                    return "Field is not valid for project section.";
                errorField = string.Empty;
            }

            Hashtable values = new Hashtable();
            values["OrderNo"] = orderNo.Trim();
            values["DealNo"] = dealNo.Trim();
            values["OrderDate"] = orderDate.Trim();
            values["ProjectID"] = projectId;
            values["ProcessID"] = processId;
            values["ErrorDoneBy"] = errorDoneBy.Trim().ToUpper();
            values["FeedbackGivenBy"] = feedbackBy.Trim().ToUpper();
            values["ErrorType"] = errorType.Trim();
            values["Fatal"] = fatal.Trim();
            values["ErrorField"] = errorField.Trim();
            values["Section"] = section.Trim();
            values["Field"] = field.Trim();
            values["Error"] = error.Trim();
            values["Shouldbe"] = shouldBe.Trim();
            values["FeedbackType"] = feedbackType.Trim();
            values["FeedbackON"] = feedbackType.Trim();
            values["FeedbackRecivedDate"] = feedbackReceivedDate.Trim();
            values["Remark"] = remark.Trim();
            values["FeedbackerrorPath"] = string.Empty;
            values["AddedBy"] = CurrentEmployeeId();

            int feedbackId = bll.InsertFeedbackForNewOrder(values);
            if (feedbackId <= 0)
                return "Feedback already added or could not be saved.";

            values["Feedback"] = feedbackId;
            int detailResult = bll.AddFeedbackForNewOrder(values);
            return detailResult > 0 ? string.Empty : "Feedback detail could not be saved.";
        }

        private static DataTable ReadExcel(HttpPostedFile file)
        {
            DataTable table = new DataTable();
            using (XLWorkbook workbook = new XLWorkbook(file.InputStream))
            {
                IXLWorksheet worksheet = workbook.Worksheets.First();
                IXLRange range = worksheet.RangeUsed();
                if (range == null) return table;

                bool header = true;
                foreach (IXLRangeRow row in range.Rows())
                {
                    if (header)
                    {
                        foreach (IXLCell cell in row.Cells())
                        {
                            string columnName = cell.GetString().Trim();
                            table.Columns.Add(UniqueColumnName(table, columnName));
                            //table.Columns.Add(UniqueColumnName(table, Convert.ToString(cell.Value).Trim()));
                        }
                        header = false;
                    }
                    else
                    {
                        DataRow dataRow = table.NewRow();
                        int index = 0;
                        foreach (IXLCell cell in row.Cells(1, table.Columns.Count))
                            dataRow[index++] = cell.GetValue<string>();
                        table.Rows.Add(dataRow);
                    }
                }
            }

            return table;
        }

        private static string UniqueColumnName(DataTable table, string columnName)
        {
            if (string.IsNullOrWhiteSpace(columnName))
                columnName = "Column" + (table.Columns.Count + 1);

            string unique = columnName;
            int counter = 1;
            while (table.Columns.Contains(unique))
                unique = columnName + "_" + counter++;
            return unique;
        }

        private void WriteJson(object value)
        {
            Response.Clear();
            Response.ContentType = "application/json";
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            Response.Write(serializer.Serialize(value));
        }

        private static string FirstCell(DataRow row, params string[] columns)
        {
            foreach (string column in columns)
            {
                if (row.Table.Columns.Contains(column))
                    return Convert.ToString(row[column]).Trim();
            }

            return string.Empty;
        }

        private static string CurrentEmployee()
        {
            return Convert.ToString(HttpContext.Current.User.Identity.Name);
        }

        private static int CurrentEmployeeId()
        {
            return ToInt(CurrentEmployee());
        }

        private static string Safe(string value)
        {
            return value == null ? string.Empty : value.Trim();
        }

        private static int ToInt(object value)
        {
            int result;
            return value != null && int.TryParse(Convert.ToString(value), out result) ? result : 0;
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

    public class ImportOptions
    {
        public string Mode { get; set; }
        public int ProjectID { get; set; }
        public string DealNo { get; set; }
        public string OrderNo { get; set; }
    }

    public class ImportFeedbackResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int TotalCount { get; set; }
        public int AddedCount { get; set; }
        public int RejectedCount { get; set; }
        public List<Dictionary<string, object>> AddedRows { get; set; }
        public List<Dictionary<string, object>> RejectedRows { get; set; }

        public ImportFeedbackResult()
        {
            AddedRows = new List<Dictionary<string, object>>();
            RejectedRows = new List<Dictionary<string, object>>();
        }

        public static ImportFeedbackResult Fail(string message)
        {
            return new ImportFeedbackResult { Success = false, Message = message };
        }
    }
}
