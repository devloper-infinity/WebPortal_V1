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
    public partial class FeedbackDetails : System.Web.UI.Page
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
        public static string GetLoanDetailsbyLoanNo(string DealNo, string LoanNo)
        {
            DataTable dt1 = new bllUS().GetLoanDetailsbyLoanNo(DealNo, LoanNo);
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
        public static string GetUSProcessTask(int ProjectID)
        {
            DataTable dt1 = new bllUS().GetUSProcessList(ProjectID);
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
        public static string GetATRDetails(string DealNo, string LoanNo, string Type, int ProcessID)
        {
            DataTable dt1 = new bllUS().GetATRDetailsbyLoanNo(DealNo, LoanNo, Type, ProcessID);
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
        public static int InsertOtherFeedbacks(int ProjectID, int ProcessID, string DealNo, string LoanNo, string Finding, string Severity)
        {
            int returnvalue = 0;

            Finding = (Finding ?? string.Empty).Trim();
            Severity = (Severity ?? string.Empty).Trim();
            if (string.IsNullOrEmpty(Finding) || string.IsNullOrEmpty(Severity))
            {
                return -1;
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", ProjectID);
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("DealNo", DealNo);
            htParam.Add("LoanNo", LoanNo);
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
            returnvalue = new bllUS().InsertOnShoreUSFeedbacks(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int InsertATRFeedbacks(int ProjectID, int ProcessID, string DealNo, string LoanNo, string Reviewer, string ReviewDate, string ATRSupported,
           string ReviewFindings, string SellerDisclosedDTIIssue, string NoOfBorrowers, string HighestBorrowerIncomeType, string NoOfSEBusiness,
           string NoOfRentalProperties, string Comments)
        {
            int returnvalue = 0;
            bool isATRSupported = ATRSupported == "Yes" ? true : false;
            
            Hashtable htParam = new Hashtable();

            htParam.Add("ProjectID", ProjectID);
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("DealNo", DealNo);
            htParam.Add("LoanNo", LoanNo);
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

            returnvalue = new bllUS().InsertOnShoreUSATRFeedbacks(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static int StartLoan(int ProcessID, string ProjectNumber, string DealNo, string OrderNumber, string OrderDate, string Process, string Review, string StartDatetime)
        {
            if (ProcessID <= 0)
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
                Review,
                startDateTime,
                ""
            );

            return trackReturnValue > 0 ? trackReturnValue : ReturnValue;
        }

        [WebMethod]
        public static int CompleteLoan(int ProcessID, string ProjectNumber, string DealNo, string OrderNumber, string OrderDate, string Process, string Review, string StartDatetime)
        {
            if (ProcessID <= 0)
            {
                return 0;
            }

            string feedbackType = string.Equals(Process, "ATR Review", StringComparison.OrdinalIgnoreCase) ? "ATR" : "Other";
            DataTable feedback = new bllUS().GetATRDetailsbyLoanNo(DealNo, OrderNumber, feedbackType, ProcessID);
            if (feedback == null || feedback.Rows.Count == 0)
            {
                return -2;
            }

            string startDateTime = NormalizeDateTime(StartDatetime);
            if (string.IsNullOrWhiteSpace(startDateTime))
            {
                startDateTime = DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss");
            }

            string endDateTime = DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss");

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
                Review,
                startDateTime,
                endDateTime
            );

            return trackReturnValue > 0 ? trackReturnValue : ReturnValue;
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

        private static int SaveLoanProductionTrack(string Action, int ProcessID, string ProjectNumber, string DealNo, string LoanNo, string OrderDate, string Process, string Review, string StartDatetime, string EndDatetime)
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
                htParam.Add("Review", Review);
                htParam.Add("StartDatetime", StartDatetime);
                htParam.Add("EndDatetime", EndDatetime);
                htParam.Add("SourcePage", "GlobalSearch");
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
            return string.IsNullOrWhiteSpace(value) ? "" : value.Replace("T", " ");
        }
    }
}
