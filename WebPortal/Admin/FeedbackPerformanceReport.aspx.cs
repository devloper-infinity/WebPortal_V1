using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web;
using System.Web.Services;

namespace WebPortal.Admin
{
    public partial class FeedbackPerformanceReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.Equals(Request.QueryString["action"], "download", StringComparison.OrdinalIgnoreCase))
                return;

            try
            {
                DateTime fromDate;
                DateTime toDate;
                GetMonthRange(Request.QueryString["month"], out fromDate, out toDate);
                FeedbackPerformanceExcelExporter.Download(fromDate, toDate);
            }
            catch (Exception ex)
            {
                Response.Clear();
                Response.StatusCode = 400;
                Response.ContentType = "text/plain";
                Response.Write(ex.Message);
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        [WebMethod]
        public static ApiResponse GetReportPreview(string month)
        {
            try
            {
                DateTime fromDate;
                DateTime toDate;
                GetMonthRange(month, out fromDate, out toDate);

                DataSet ds = FeedbackPerformanceExcelExporter.LoadReportData(fromDate, toDate);
                return ApiResponse.Ok(new
                {
                    Period = fromDate.ToString("MMMM yyyy", CultureInfo.InvariantCulture),
                    ReviewerPerformance = TableToRows(ds.Tables[0]),
                    QCerPerformance = TableToRows(ds.Tables[1]),
                    ReviewerExceptions = TableToRows(ds.Tables[2]),
                    QCerExceptions = TableToRows(ds.Tables[3]),
                    WeeklyTrend = TableToRows(ds.Tables[4])
                });
            }
            catch (Exception ex)
            {
                return ApiResponse.Fail(ex.Message);
            }
        }

        private static void GetMonthRange(string monthText, out DateTime fromDate, out DateTime toDate)
        {
            DateTime month;
            if (string.IsNullOrWhiteSpace(monthText) ||
                !DateTime.TryParseExact(monthText + "-01", "yyyy-MM-dd", CultureInfo.InvariantCulture,
                    DateTimeStyles.None, out month))
                throw new ArgumentException("Please select a valid month.");

            fromDate = new DateTime(month.Year, month.Month, 1);
            toDate = fromDate.AddMonths(1).AddDays(-1);
        }

        private static List<Dictionary<string, object>> TableToRows(DataTable table)
        {
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow dataRow in table.Rows)
            {
                var row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                {
                    object value = dataRow[column];
                    if (value == DBNull.Value)
                        value = null;
                    else if (value is DateTime)
                        value = ((DateTime)value).ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                    else if (value is decimal)
                        value = ((decimal)value).ToString("0.00", CultureInfo.InvariantCulture);

                    row[column.ColumnName] = value;
                }
                rows.Add(row);
            }
            return rows;
        }

        public class ApiResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public object Data { get; set; }

            public static ApiResponse Ok(object data)
            {
                return new ApiResponse { Success = true, Data = data, Message = string.Empty };
            }

            public static ApiResponse Fail(string message)
            {
                return new ApiResponse { Success = false, Data = null, Message = message };
            }
        }
    }
}