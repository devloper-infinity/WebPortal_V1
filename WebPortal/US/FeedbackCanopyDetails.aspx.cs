using ClosedXML.Excel;
using Microsoft.Vbe.Interop;
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
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class FeedbackCanopyDetails : System.Web.UI.Page
    {

        static string NewFileName = "";
        static string FileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";

        protected void Page_Load(object sender, EventArgs e)
        {

            FolderPath = Server.MapPath(@"~\USDocuments\Feedback\");

            try
            {
                HttpContext postedContext = HttpContext.Current;
                HttpPostedFile file = postedContext.Request.Files[0];

                string name = file.FileName;
                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0,
                (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;

                FileName = file.FileName;

                NewFileName = Server.MapPath("..//TempFiles//" + file.FileName);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
            }
            catch { }
        }

        [WebMethod]
        public static int InsertUSImportedFeedback_NewERP(string LoanNo, string Client, string UWName, string DateReviewed, string QCDate, string Finding, string Severity, string Source, string FeedbackReceivedDate, int ProcessID, int ProjectID)
        {
            if (!IsProcessAllowedForEmployee(ProjectID, ProcessID)) return -5;
            int ReturnValue = 0;

            Severity = (Severity ?? string.Empty).Trim();
            Finding = (Finding ?? string.Empty).Trim();
            if (string.IsNullOrEmpty(Severity) || (Severity != "No Error" && string.IsNullOrEmpty(Finding)))
            {
                return -1;
            }

            if (Severity == "No Error" && string.IsNullOrWhiteSpace(Finding))
            {
                Finding = "No Error";
            }

            string QCName = "";

            Hashtable htParam = new Hashtable();
            htParam.Add("LoanNo", LoanNo);
            htParam.Add("Client", Client);
            htParam.Add("UWName", UWName);
            htParam.Add("QCName", QCName);
            htParam.Add("DateReviewed", DateReviewed);
            htParam.Add("QCDate", QCDate);
            htParam.Add("Finding", Finding);
            htParam.Add("Severity", Severity);
            htParam.Add("Source", Source);
            htParam.Add("FeedbackReceivedDate", FeedbackReceivedDate);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("ProcessID", ProcessID);

            ReturnValue = new bllUS().InsertUSImportedFeedback_NewERP(htParam);

            return ReturnValue;
        }

        [WebMethod]
        public static string GetLoanDetailsbyLoanNo_Canopy(string DealNo, string LoanNo, string Script, string TaskName)
        {
            if (!string.IsNullOrWhiteSpace(TaskName) && !IsTaskAllowedForEmployee(TaskName)) return "[]";
            DataTable dt1 = new bllUS().GetLoanDetailsbyLoanNo_Canopy(DealNo, LoanNo, Script, TaskName);
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
        public static string GetLoggedInUser()
        {
            DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUSProcessTask(int ProjectID, string DealNo, string LoanNo, string Script, bool FromMyQueue)
        {
            DataTable dt1 = new bllUS().GetUSProcessList(ProjectID);
            DataTable statuses = new bllUS().GetCanopySearchProcessStatuses();
            HashSet<string> unavailableQc = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            HashSet<string> allowedTasks = GetAllowedCanopyTasks();
            string ownedStartedTask = "";
            int currentEmployeeId = int.Parse(HttpContext.Current.User.Identity.Name);
            foreach (DataRow status in statuses.Rows)
            {
                string process = Convert.ToString(status["ProcessName"]).Trim();
                if (string.Equals(Convert.ToString(status["DealNo"]).Trim(), (DealNo ?? "").Trim(), StringComparison.OrdinalIgnoreCase)
                    && string.Equals(Convert.ToString(status["LoanNo"]).Trim(), (LoanNo ?? "").Trim(), StringComparison.OrdinalIgnoreCase)
                    && string.Equals(Convert.ToString(status["Script"]).Trim(), (Script ?? "").Trim(), StringComparison.OrdinalIgnoreCase)
                    && (string.Equals(process, "Credit QC", StringComparison.OrdinalIgnoreCase)
                        || string.Equals(process, "Compliance QC", StringComparison.OrdinalIgnoreCase)))
                {
                    bool completed = string.Equals(Convert.ToString(status["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase);
                    int ownerId = Convert.ToInt32(status["ProcessEmployeeID"]);
                    if (completed || !FromMyQueue || ownerId != currentEmployeeId) unavailableQc.Add(process);
                    if (!completed && ownerId == currentEmployeeId && string.IsNullOrEmpty(ownedStartedTask)) ownedStartedTask = process;
                }
            }

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                string processName = dt1.Columns.Contains("ProcessName") ? Convert.ToString(dr["ProcessName"]).Trim() : "";
                if (!allowedTasks.Contains(processName) || unavailableQc.Contains(processName)
                    || (!string.IsNullOrEmpty(ownedStartedTask) && !string.Equals(processName, ownedStartedTask, StringComparison.OrdinalIgnoreCase))) continue;
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
        public static string GetATRDetails(int ProjectID, string DealNo, string LoanNo, string Type, int ProcessID, string Script)
        {
            if (!IsProcessAllowedForEmployee(ProjectID, ProcessID)) return "[]";
            DataTable dt1 = new bllUS().GetCanopyATRDetailsbyLoanNo(DealNo, LoanNo, Type, ProcessID, Script);
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
        public static int InsertOtherFeedbacks(int ProjectID, int ProcessID, string DealNo, string LoanNo, string Finding, string Severity, string Script)
        {
            if (!IsProcessAllowedForEmployee(ProjectID, ProcessID)) return -5;
            int returnvalue = 0;

            Finding = (Finding ?? string.Empty).Trim();
            Severity = (Severity ?? string.Empty).Trim();
            if (string.IsNullOrEmpty(Finding) || string.IsNullOrEmpty(Severity))
            {
                return -1;
            }

            DataTable existingFeedback = new bllUS().GetCanopyATRDetailsbyLoanNo(DealNo, LoanNo, "Other", ProcessID, Script);
            bool addingNoError = string.Equals(Severity, "No Error", StringComparison.OrdinalIgnoreCase);
            foreach (DataRow existing in existingFeedback.Rows)
            {
                bool existingNoError = existingFeedback.Columns.Contains("Severity")
                    && string.Equals(Convert.ToString(existing["Severity"]).Trim(), "No Error", StringComparison.OrdinalIgnoreCase);
                if (existingNoError) return -3;
                if (addingNoError) return -4;
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", ProjectID);
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("DealNo", DealNo);
            htParam.Add("LoanNo", LoanNo);
            htParam.Add("Script", Script);
            htParam.Add("Finding", Finding);
            htParam.Add("Severity", Severity);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name));

            if (!string.IsNullOrEmpty(NewFileName))
            {
                // Create date folder
                string destinationFolder = Path.Combine(FolderPath,DateTime.Now.ToString("dd-MMM-yyyy"));

                if (!Directory.Exists(destinationFolder))
                {
                    Directory.CreateDirectory(destinationFolder);
                }

                // Get original filename and extension
                string originalFileName = Path.GetFileNameWithoutExtension(NewFileName);
                string extension = Path.GetExtension(NewFileName);

                // Rename file as LoanNo_PreviousFileName.ext
                string renamedFile = LoanNo + "_" + originalFileName + extension;

                // Full destination path
                string destinationPath = Path.Combine(destinationFolder, renamedFile);

                // Copy file
                File.Copy(NewFileName, destinationPath, true);

                htParam.Add("Attachment", destinationPath);
            }
            else
            {
                htParam.Add("Attachment", "");
            }
            NewFileName = "";
            returnvalue = new bllUS().InsertOnShoreUSFeedbacksCanopy(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int InsertATRFeedbacks(int ProjectID, int ProcessID, string DealNo, string LoanNo, string Reviewer, string ReviewDate, string ATRSupported,
           string ReviewFindings, string SellerDisclosedDTIIssue, string NoOfBorrowers, string HighestBorrowerIncomeType, string NoOfSEBusiness,
           string NoOfRentalProperties, string Comments, string Script)
        {
            if (!IsProcessAllowedForEmployee(ProjectID, ProcessID)) return -5;
            int returnvalue = 0;
            bool isATRSupported = ATRSupported == "Yes" ? true : false;
            
            Hashtable htParam = new Hashtable();

            htParam.Add("ProjectID", ProjectID);
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("DealNo", DealNo);
            htParam.Add("LoanNo", LoanNo);
            htParam.Add("Script", Script);
            htParam.Add("Reviewer", Reviewer);
            htParam.Add("ReviewDate", ReviewDate);
            htParam.Add("isATRSupported", isATRSupported);
            htParam.Add("ReviewFindings", ReviewFindings);
            htParam.Add("SellerDisclosedDTIIssue", SellerDisclosedDTIIssue);
            htParam.Add("NoOfBorrowers", NoOfBorrowers);
            htParam.Add("HighestBorrowerIncomeType", HighestBorrowerIncomeType);
            htParam.Add("NoOfSEBusiness", NoOfSEBusiness);
            htParam.Add("NoOfRentalProperties", NoOfRentalProperties);
            htParam.Add("Comments", Comments);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue = new bllUS().InsertOnShoreUSATRFeedbacksCanopy(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int UpdateOtherFeedback(string FeedbackKey, int ProjectID, int ProcessID, string DealNo, string LoanNo, string Finding, string Severity, string Script)
        {
            if (!IsProcessAllowedForEmployee(ProjectID, ProcessID)) return -5;
            Finding = (Finding ?? "").Trim(); Severity = (Severity ?? "").Trim();
            if (string.IsNullOrWhiteSpace(FeedbackKey) || Finding.Length == 0 || Severity.Length == 0) return -1;
            Hashtable values = CanopyUpdateValues(FeedbackKey, ProjectID, ProcessID, DealNo, LoanNo, Script);
            values.Add("Finding", Finding); values.Add("Severity", Severity);
            return new bllUS().UpdateOnShoreUSFeedbacksCanopy(values);
        }

        [WebMethod]
        public static int DeleteOtherFeedback(string FeedbackKey, int ProjectID, int ProcessID, string DealNo, string LoanNo, string Client, string Finding, string Severity, string Script)
        {
            if (!IsProcessAllowedForEmployee(ProjectID, ProcessID)) return -5;
            if (string.IsNullOrWhiteSpace(FeedbackKey)) return -1;
            Hashtable values = CanopyUpdateValues(FeedbackKey, ProjectID, ProcessID, DealNo, LoanNo, Script);
            values.Add("Client", Client ?? ""); values.Add("QCName", "");
            values.Add("Finding", Finding ?? ""); values.Add("Severity", Severity ?? "");
            return new bllUS().DeleteOnShoreUSFeedbacksCanopy(values);
        }

        private static Hashtable CanopyUpdateValues(string feedbackKey, int projectID, int processID, string dealNo, string loanNo, string script)
        {
            Hashtable values = new Hashtable();
            values.Add("FeedbackKey", feedbackKey); values.Add("ProjectID", projectID); values.Add("ProcessID", processID);
            values.Add("DealNo", dealNo); values.Add("LoanNo", loanNo); values.Add("Script", script ?? "");
            values.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name));
            return values;
        }

        [WebMethod]
        public static int StartLoan(int ProcessID, string ProjectNumber, string DealNo, string OrderNumber, string OrderDate, string Process, string Review, string StartDatetime, string Script)
        {
            if (ProcessID <= 0 || !CanAccessCanopyTask(DealNo, OrderNumber, Script, Process))
            {
                return 0;
            }

            string startDateTime = NormalizeDateTime(StartDatetime);
            if (string.IsNullOrWhiteSpace(startDateTime))
            {
                startDateTime = DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss");
            }

            int ReturnValue = 0;
            try
            {
                ReturnValue = SaveLoanTiming(
                    ProjectNumber,
                    DealNo,
                    OrderNumber,
                    Process,
                    Review,
                    startDateTime,
                    "",
                    "Start",
                    "Pending"
                );
            }
            catch
            {
            }

            int trackReturnValue = SaveLoanProductionTrack(
                "Start",
                ProcessID,
                ProjectNumber,
                DealNo,
                OrderNumber,
                OrderDate,
                Process,
                Script,
                Review,
                startDateTime,
                ""
            );

            return trackReturnValue > 0 ? trackReturnValue : ReturnValue;
        }

        [WebMethod]
        public static int CompleteLoan(int ProcessID, string ProjectNumber, string DealNo, string OrderNumber, string OrderDate, string Process, string Review, string StartDatetime, string Script)
        {
            if (ProcessID <= 0 || !CanAccessCanopyTask(DealNo, OrderNumber, Script, Process))
            {
                return 0;
            }

            string feedbackType = string.Equals(Process, "ATR Review", StringComparison.OrdinalIgnoreCase) ? "ATR" : "Other";
            DataTable feedback = new bllUS().GetCanopyATRDetailsbyLoanNo(DealNo, OrderNumber, feedbackType, ProcessID, Script);
            if (feedback == null || feedback.Rows.Count == 0)
            {
                return -2;
            }

            string startDateTime = NormalizeDateTime(StartDatetime);
            if (string.IsNullOrWhiteSpace(startDateTime))
            {
                startDateTime = DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss");
            }

            string endDateTime = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss");
            string completedBy = HttpContext.Current.User.Identity.Name;
            DataTable user = new bllLogin().GetUserInformation(int.Parse(completedBy));
            if (user.Rows.Count > 0 && user.Columns.Contains("FullName") && !string.IsNullOrWhiteSpace(Convert.ToString(user.Rows[0]["FullName"])))
            {
                completedBy = Convert.ToString(user.Rows[0]["FullName"]).Trim();
            }

            int ReturnValue = 0;
            try
            {
                ReturnValue = SaveLoanTiming(
                    ProjectNumber,
                    DealNo,
                    OrderNumber,
                    Process,
                    Review,
                    startDateTime,
                    endDateTime,
                    "Complete",
                    "Completed"
                );
            }
            catch
            {
            }

            int trackReturnValue = SaveLoanProductionTrack(
                "Complete",
                ProcessID,
                ProjectNumber,
                DealNo,
                OrderNumber,
                OrderDate,
                Process,
                Script,
                completedBy,
                startDateTime,
                endDateTime
            );

            return trackReturnValue > 0 ? trackReturnValue : ReturnValue;
        }

        private static bool CanAccessCanopyTask(string dealNo, string loanNo, string script, string process)
        {
            if (!IsTaskAllowedForEmployee(process)) return false;
            int employeeId = int.Parse(HttpContext.Current.User.Identity.Name);
            foreach (DataRow status in new bllUS().GetCanopySearchProcessStatuses().Rows)
            {
                if (string.Equals(Convert.ToString(status["DealNo"]).Trim(), (dealNo ?? "").Trim(), StringComparison.OrdinalIgnoreCase)
                    && string.Equals(Convert.ToString(status["LoanNo"]).Trim(), (loanNo ?? "").Trim(), StringComparison.OrdinalIgnoreCase)
                    && string.Equals(Convert.ToString(status["Script"]).Trim(), (script ?? "").Trim(), StringComparison.OrdinalIgnoreCase))
                {
                    string existingProcess = Convert.ToString(status["ProcessName"]).Trim();
                    bool completed = string.Equals(Convert.ToString(status["ProcessStatus"]), "Completed", StringComparison.OrdinalIgnoreCase);
                    int ownerId = Convert.ToInt32(status["ProcessEmployeeID"]);
                    if (!completed && ownerId == employeeId
                        && (string.Equals(existingProcess, "Credit QC", StringComparison.OrdinalIgnoreCase)
                            || string.Equals(existingProcess, "Compliance QC", StringComparison.OrdinalIgnoreCase))
                        && !string.Equals(existingProcess, process, StringComparison.OrdinalIgnoreCase)) return false;
                    if (string.Equals(existingProcess, process, StringComparison.OrdinalIgnoreCase))
                        return !completed && ownerId == employeeId;
                }
            }
            return true;
        }

        private static bool IsProcessAllowedForEmployee(int projectID, int processID)
        {
            DataTable processes = new bllUS().GetUSProcessList(projectID);
            foreach (DataRow process in processes.Rows)
            {
                if (Convert.ToInt32(process["ProcessID"]) == processID)
                    return IsTaskAllowedForEmployee(Convert.ToString(process["ProcessName"]));
            }
            return false;
        }

        private static bool IsTaskAllowedForEmployee(string taskName)
        {
            return GetAllowedCanopyTasks().Contains((taskName ?? "").Trim());
        }

        private static HashSet<string> GetAllowedCanopyTasks()
        {
            HashSet<string> tasks = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            string segment = new bllLogin().GetEmployeeSegment(int.Parse(HttpContext.Current.User.Identity.Name));
            if (string.Equals(segment, "Credit QC - Canopy", StringComparison.OrdinalIgnoreCase) || string.Equals(segment, "Management", StringComparison.OrdinalIgnoreCase)) tasks.Add("Credit QC");
            if (string.Equals(segment, "Compliance QC - Canopy", StringComparison.OrdinalIgnoreCase) || string.Equals(segment, "Management", StringComparison.OrdinalIgnoreCase)) tasks.Add("Compliance QC");
            return tasks;
        }

        private static int SaveLoanTiming(string ProjectNumber, string DealNo, string OrderNumber, string Process, string Review, string StartTime, string EndTime, string ProductType, string Status)
        {
            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectNumber", ProjectNumber);
            htParam.Add("DealNo", DealNo);
            htParam.Add("OrderNumber", OrderNumber);
            htParam.Add("Process", Process);
            htParam.Add("Review", Review);
            htParam.Add("ReviewStartTime", StartTime);
            htParam.Add("ReviewEndTime", EndTime);
            htParam.Add("Type", "Default");
            htParam.Add("ProductType", ProductType);
            htParam.Add("Status", Status);
            htParam.Add("Remark", "online");
            htParam.Add("AddedBY", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            return new bllUS().InsertModifyUWOrderOC22Servicing_EndTime(htParam);
        }

        private static int SaveLoanProductionTrack(string Action, int ProcessID, string ProjectNumber, string DealNo, string LoanNo, string OrderDate, string Process, string Script, string Review, string StartDatetime, string EndDatetime)
        {
            try
            {
                int currentEmployeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
                Hashtable htParam = new Hashtable();
                htParam.Add("Action", Action);
                htParam.Add("ProcessID", ProcessID);
                htParam.Add("ProjectNumber", ProjectNumber);
                htParam.Add("DealNo", DealNo);
                htParam.Add("LoanNo", LoanNo);
                htParam.Add("OrderDate", OrderDate);
                htParam.Add("Process", Process);
                htParam.Add("Script", Script);
                htParam.Add("Review", Review);
                htParam.Add("StartDatetime", StartDatetime);
                htParam.Add("EndDatetime", EndDatetime);
                htParam.Add("SourcePage", "CanopySearch");
                htParam.Add("EmployeeID", currentEmployeeId);
                htParam.Add("AddedBy", currentEmployeeId);

                return new bllUS().SaveUSLoanProductionTrack(htParam);
            }
            catch
            {
                return 0;
            }
        }

        private static string NormalizeDateTime(string value)
        {
            DateTime parsed;
            return DateTime.TryParse(value, out parsed) ? parsed.ToString("yyyy-MM-ddTHH:mm:ss") : "";
        }
    }
}
