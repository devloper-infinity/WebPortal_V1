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
    public partial class LMSearchDetails : System.Web.UI.Page
    {

        static string lmsearchdetails_NewFileName = "";
        static string lmsearchdetails_FileName = "";
        static string lmsearchdetails_GUIDFile = "";
        static string lmsearchdetails_FolderPath = "";

        protected void Page_Load(object sender, EventArgs e)
        {

            lmsearchdetails_FolderPath = Server.MapPath(@"~\USDocuments\Feedback\");

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

                lmsearchdetails_FileName = file.FileName;

                lmsearchdetails_NewFileName = Server.MapPath("..//TempFiles//" + file.FileName);
                FileStream objfilestream = new FileStream(lmsearchdetails_NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
            }
            catch { }
        }

        [WebMethod]
        public static int InsertUSImportedFeedback_NewERP(string LoanID, string Client, string UWName, string DateReviewed, string QCDate, string Finding, string Severity, string Source, string FeedbackReceivedDate, int ProcessID)
        {
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
            htParam.Add("LoanNo", LoanID);
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
        public static string GetLoanDetailsbyLoanID_LauraMac(long RecordID, string Process, string TaskName)
        {
            if (!string.IsNullOrWhiteSpace(TaskName) && !IsTaskAllowedForEmployee(TaskName)) return "[]";
            DataTable dt1 = new bllUS().GetLoanDetailsbyLoanID_LauraMac(RecordID, Process, TaskName);
            if (!dt1.Columns.Contains("Client")) dt1.Columns.Add("Client", typeof(string));
            if (!dt1.Columns.Contains("LoanID")) dt1.Columns.Add("LoanID", typeof(string));
            foreach (DataRow lmsearchdetails_row in dt1.Rows)
            {
                if (string.IsNullOrWhiteSpace(Convert.ToString(lmsearchdetails_row["Client"])))
                    lmsearchdetails_row["Client"] = dt1.Columns.Contains("ProjectName") ? Convert.ToString(lmsearchdetails_row["ProjectName"]) : "";
                if (string.IsNullOrWhiteSpace(Convert.ToString(lmsearchdetails_row["LoanID"])))
                    lmsearchdetails_row["LoanID"] = "";
            }
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
        public static string GetUSProcessTask(string Client, string LoanID, string Process, string Script, bool FromMyQueue)
        {
            DataTable statuses = new bllUS().GetLauraMacSearchProcessStatuses();
            HashSet<string> unavailableQc = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            HashSet<string> allowedTasks = GetAllowedCanopyTasks();
            string ownedStartedTask = "";
            int currentEmployeeId = int.Parse(HttpContext.Current.User.Identity.Name);
            foreach (DataRow status in statuses.Rows)
            {
                string process = Convert.ToString(status["ProcessName"]).Trim();
                if (string.Equals(Convert.ToString(status["ProjectNumber"]).Trim(), (Client ?? "").Trim(), StringComparison.OrdinalIgnoreCase)
                    && string.Equals(Convert.ToString(status["LoanNo"]).Trim(), (LoanID ?? "").Trim(), StringComparison.OrdinalIgnoreCase)
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
            foreach (string processName in allowedTasks)
            {
                if (unavailableQc.Contains(processName)
                    || (!string.IsNullOrEmpty(ownedStartedTask) && !string.Equals(processName, ownedStartedTask, StringComparison.OrdinalIgnoreCase))) continue;
                row = new Dictionary<string, object>();
                row.Add("ProcessID", string.Equals(processName, "Credit QC", StringComparison.OrdinalIgnoreCase) ? 900001 : 900002);
                row.Add("ProcessName", processName);
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetATRDetails(string LoanID, string Type, int ProcessID, string Script)
        {
            DataTable dt1 = new bllUS().GetLauraMacFeedback(LoanID, Type, ProcessID, Script);
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
        public static int InsertOtherFeedbacks(int ProcessID, string LoanID, string Finding, string Severity, string Script)
        {
            int returnvalue = 0;

            Finding = (Finding ?? string.Empty).Trim();
            Severity = (Severity ?? string.Empty).Trim();
            if (string.IsNullOrEmpty(Finding) || string.IsNullOrEmpty(Severity))
            {
                return -1;
            }

            DataTable existingFeedback = new bllUS().GetLauraMacFeedback(LoanID, "Other", ProcessID, Script);
            bool addingNoError = string.Equals(Severity, "No Error", StringComparison.OrdinalIgnoreCase);
            foreach (DataRow existing in existingFeedback.Rows)
            {
                bool existingNoError = existingFeedback.Columns.Contains("Severity")
                    && string.Equals(Convert.ToString(existing["Severity"]).Trim(), "No Error", StringComparison.OrdinalIgnoreCase);
                if (existingNoError) return -3;
                if (addingNoError) return -4;
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("LoanID", LoanID);
            htParam.Add("Script", Script);
            htParam.Add("Finding", Finding);
            htParam.Add("Severity", Severity);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name));

            if (!string.IsNullOrEmpty(lmsearchdetails_NewFileName))
            {
                // Create date folder
                string destinationFolder = Path.Combine(lmsearchdetails_FolderPath,DateTime.Now.ToString("dd-MMM-yyyy"));

                if (!Directory.Exists(destinationFolder))
                {
                    Directory.CreateDirectory(destinationFolder);
                }

                // Get original filename and extension
                string originalFileName = Path.GetFileNameWithoutExtension(lmsearchdetails_NewFileName);
                string extension = Path.GetExtension(lmsearchdetails_NewFileName);

                // Rename file as LoanNo_PreviousFileName.ext
                string renamedFile = LoanID + "_" + originalFileName + extension;

                // Full destination path
                string destinationPath = Path.Combine(destinationFolder, renamedFile);

                // Copy file
                File.Copy(lmsearchdetails_NewFileName, destinationPath, true);

                htParam.Add("Attachment", destinationPath);
            }
            else
            {
                htParam.Add("Attachment", "");
            }
            lmsearchdetails_NewFileName = "";
            returnvalue = new bllUS().InsertLauraMacFeedback(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int InsertATRFeedbacks(int ProcessID, string LoanID, string Reviewer, string ReviewDate, string ATRSupported,
           string ReviewFindings, string SellerDisclosedDTIIssue, string NoOfBorrowers, string HighestBorrowerIncomeType, string NoOfSEBusiness,
           string NoOfRentalProperties, string Comments, string Script)
        {
            int returnvalue = 0;
            bool isATRSupported = ATRSupported == "Yes" ? true : false;
            
            Hashtable htParam = new Hashtable();

            htParam.Add("ProcessID", ProcessID);
            htParam.Add("LoanID", LoanID);
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

            returnvalue = new bllUS().InsertLauraMacATRFeedback(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int UpdateOtherFeedback(string FeedbackKey, int ProcessID, string LoanID, string Finding, string Severity, string Script)
        {
            Finding = (Finding ?? "").Trim(); Severity = (Severity ?? "").Trim();
            if (string.IsNullOrWhiteSpace(FeedbackKey) || Finding.Length == 0 || Severity.Length == 0) return -1;
            Hashtable values = lmsearchdetails_FeedbackValues(FeedbackKey, ProcessID, LoanID, Script);
            values.Add("Finding", Finding); values.Add("Severity", Severity);
            return new bllUS().UpdateLauraMacFeedback(values);
        }

        [WebMethod]
        public static int DeleteOtherFeedback(string FeedbackKey, int ProcessID, string LoanID, string Client, string Finding, string Severity, string Script)
        {
            if (string.IsNullOrWhiteSpace(FeedbackKey)) return -1;
            Hashtable values = lmsearchdetails_FeedbackValues(FeedbackKey, ProcessID, LoanID, Script);
            values.Add("Client", Client ?? ""); values.Add("QCName", "");
            values.Add("Finding", Finding ?? ""); values.Add("Severity", Severity ?? "");
            return new bllUS().DeleteLauraMacFeedback(values);
        }

        private static Hashtable lmsearchdetails_FeedbackValues(string feedbackKey, int processID, string loanID, string script)
        {
            Hashtable values = new Hashtable();
            values.Add("FeedbackKey", feedbackKey); values.Add("ProcessID", processID);
            values.Add("LoanID", loanID); values.Add("Script", script ?? "");
            values.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name));
            return values;
        }

        [WebMethod]
        public static int StartLoan(int ProcessID, string Client, string LoanID, string OrderDate, string Process, string Review, string StartDatetime, string Script)
        {
            if (!lmsearchdetails_CanAccessTask(Client, LoanID, Script, Process))
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
                    Client,
                    "",
                    LoanID,
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
                Client,
                "",
                LoanID,
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
        public static int CompleteLoan(int ProcessID, string Client, string LoanID, string OrderDate, string Process, string Review, string StartDatetime, string Script)
        {
            if (!lmsearchdetails_CanAccessTask(Client, LoanID, Script, Process))
            {
                return 0;
            }

            string feedbackType = string.Equals(Process, "ATR Review", StringComparison.OrdinalIgnoreCase) ? "ATR" : "Other";
            DataTable feedback = new bllUS().GetLauraMacFeedback(LoanID, feedbackType, ProcessID, Script);
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
                    Client,
                    "",
                    LoanID,
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
                Client,
                "",
                LoanID,
                OrderDate,
                Process,
                Script,
                completedBy,
                startDateTime,
                endDateTime
            );

            return trackReturnValue > 0 ? trackReturnValue : ReturnValue;
        }

        private static bool lmsearchdetails_CanAccessTask(string client, string loanID, string script, string process)
        {
            if (!IsTaskAllowedForEmployee(process)) return false;
            int employeeId = int.Parse(HttpContext.Current.User.Identity.Name);
            foreach (DataRow status in new bllUS().GetLauraMacSearchProcessStatuses().Rows)
            {
                if (string.Equals(Convert.ToString(status["ProjectNumber"]).Trim(), (client ?? "").Trim(), StringComparison.OrdinalIgnoreCase)
                    && string.Equals(Convert.ToString(status["LoanNo"]).Trim(), (loanID ?? "").Trim(), StringComparison.OrdinalIgnoreCase)
                    && string.Equals(Convert.ToString(status["ProcessName"]).Trim(), (process ?? "").Trim(), StringComparison.OrdinalIgnoreCase)
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
                htParam.Add("SourcePage", "LMSearch");
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


