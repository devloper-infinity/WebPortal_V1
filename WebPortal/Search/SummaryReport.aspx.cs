using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Text;
using WebPortal.App_Code.BLL;

namespace WebPortal.Search
{
    public partial class SummaryReport : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetProjects()
        {
            int userId;
            if (!int.TryParse(HttpContext.Current.User.Identity.Name, out userId))
                throw new InvalidOperationException("Your session is invalid. Please sign in again.");

            return Serialize(new bllOST().GetAllProject(userId));
        }

        [WebMethod]
        public static string GetStatuses()
        {
            return Serialize(new bllOST().GetOSTStatuses());
        }

        [WebMethod]
        public static string GetTemplates(int projectId)
        {
            if (projectId <= 0)
                throw new ArgumentException("Select a valid project.");

            return Serialize(new bllOST().GetAllTemplateProject(projectId));
        }

        [WebMethod]
        public static string GetTemplateWiseReport(string fromDate, string toDate, string projectNo, int templateId)
        {
            DateRange range = ValidateDateRange(fromDate, toDate);
            Require(projectNo, "Project");
            if (templateId <= 0)
                throw new ArgumentException("Select a template.");

            // The legacy report requires a template selection, while its stored procedure filters by project/date.
            return Serialize(new bllOST().GetTempleteWiseOrders(range.From, range.To, projectNo.Trim()));
        }

        [WebMethod]
        public static string GetProjectPerformanceReport(string fromDate, string toDate, string projectNo)
        {
            DateRange range = ValidateDateRange(fromDate, toDate);
            Require(projectNo, "Project");
            return Serialize(new bllOST().GetOSTProjectPerformance(range.From, range.To, projectNo.Trim()));
        }

        [WebMethod]
        public static string GetProjectSummaryReport(string fromDate, string toDate)
        {
            DateRange range = ValidateDateRange(fromDate, toDate);
            return Serialize(new bllOST().GetOSTProjectSummary(range.From, range.To));
        }

        [WebMethod]
        public static string GetUserSummaryReport(string fromDate, string toDate)
        {
            DateRange range = ValidateDateRange(fromDate, toDate);
            return Serialize(new bllOST().GetOSTUserSummary(range.From, range.To, "Select"));
        }

        [WebMethod]
        public static string GetOrderStatusReport(string fromDate, string toDate, string projectNo, string status)
        {
            DateRange range = ValidateDateRange(fromDate, toDate);
            Require(projectNo, "Project");
            Require(status, "Status");
            return Serialize(new bllOST().GetOSTOrderStatus(projectNo.Trim(), range.From, range.To, status.Trim()));
        }

        [WebMethod]
        public static string GetCurrentStatusReport()
        {
            return Serialize(new bllOST().GetOSTCurrentStatus());
        }

        [WebMethod]
        public static string GetUserDetailReport(string fromDate, string toDate, string type, string userId)
        {
            DateRange range = ValidateDateRange(fromDate, toDate);
            Require(type, "Process");
            Require(userId, "User");
            DataTable table = new bllOST().GetOSTUserDetail(range.From, range.To, type.Trim(), userId.Trim());
            AddAttachmentTokens(table);
            return Serialize(table);
        }

        private static void AddAttachmentTokens(DataTable table)
        {
            if (table == null || !table.Columns.Contains("Path"))
                return;
            if (!table.Columns.Contains("AttachmentToken"))
                table.Columns.Add("AttachmentToken", typeof(string));

            foreach (DataRow row in table.Rows)
            {
                string path = Convert.ToString(row["Path"]);
                if (string.IsNullOrWhiteSpace(path))
                    continue;
                byte[] protectedValue = MachineKey.Protect(Encoding.UTF8.GetBytes(path), "OSTSummaryAttachment");
                row["AttachmentToken"] = HttpServerUtility.UrlTokenEncode(protectedValue);
            }
        }

        private static DateRange ValidateDateRange(string fromDate, string toDate)
        {
            DateTime from;
            DateTime to;
            if (!DateTime.TryParseExact(fromDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out from) ||
                !DateTime.TryParseExact(toDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out to))
                throw new ArgumentException("Enter a valid From Date and To Date.");
            if (from.Date > to.Date)
                throw new ArgumentException("From Date cannot be later than To Date.");

            return new DateRange
            {
                From = from.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                To = to.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture)
            };
        }

        private static void Require(string value, string fieldName)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("Select " + fieldName + ".");
        }

        private static string Serialize(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table != null)
            {
                foreach (DataRow dataRow in table.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                    foreach (DataColumn column in table.Columns)
                        row[column.ColumnName] = dataRow[column] == DBNull.Value ? null : dataRow[column];
                    rows.Add(row);
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer { MaxJsonLength = int.MaxValue };
            return serializer.Serialize(rows);
        }

        private sealed class DateRange
        {
            public string From { get; set; }
            public string To { get; set; }
        }
    }
}
