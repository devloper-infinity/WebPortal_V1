using ClosedXML.Excel;
using Spire.Xls;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class UserPerformanceReport : System.Web.UI.Page
    {
        static string FileName = "";
        static Workbook book = new Workbook();
        static Worksheet sheet;
        
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }

        [WebMethod]
        public static string GetAllUsers()
        {
            DataTable dt1 = new bllMaster().GetAllUsersUnderPM(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceReport(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceReport(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceProdDetails(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceProdDetails(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceFeedbackDetails(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceFeedbackDetails(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceAttendanceDetails(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceAttendanceDetails(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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

        #region Static format
        static void releaseObject_Static(object obj)
        {
            try
            {
                System.Runtime.InteropServices.Marshal.ReleaseComObject(obj);
                obj = null;
            }
            catch
            {
            }
            finally
            {
                GC.Collect();
            }
        }

        static string GetColumnName_Static(int index)
        {
            const string letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

            var value = "";

            if (index >= letters.Length)
                value += letters[index / letters.Length - 1];

            value += letters[index % letters.Length];

            return value;
        }

        public static void HeaderFormat_Static(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Color = Color.FromArgb(113, 147, 209);
            range.Style.Font.Color = Color.White;
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.IsBold = true;
        }

        public static void AllBorder_Static(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }

        public static void ContentCenter_Static(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
        }

        public static void DashboardHeader_Static(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.Size = 12;
            range.Style.Font.IsBold = true;
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }

        public static void DashboardContent_Static(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.Size = 10;
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }
        #endregion

        static void releaseObject(object obj)
        {
            try
            {
                System.Runtime.InteropServices.Marshal.ReleaseComObject(obj);
                obj = null;
            }
            catch
            {
            }
            finally
            {
                GC.Collect();
            }
        }

        [WebMethod]
        public static int OverallSummary(string FromDate, string ToDate)
        {
            int returnvalue = 1;
            FileName = HttpContext.Current.Server.MapPath(@"~\ReportDocument\User_Performance_Report_" + Convert.ToString(FromDate) + " to " + Convert.ToString(ToDate) + DateTime.Now.ToString("hhmmss") + ".xlsx");

            book.DefaultFontSize = 9;
            book.DefaultFontName = "biome";

            int rowcount = 0;
            int colcount = 0;

            #region Summary

            sheet = null;
            sheet = book.Worksheets.Add("Summary");

            DataTable dt = new bllMaster().GetUserPerformanceReport(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString())); ;
            if (dt != null)
            {
                dt.Columns["Month"].SetOrdinal(0);
                dt.Columns["Year"].SetOrdinal(1);
                dt.Columns["Code"].SetOrdinal(2);
                dt.Columns["EmployeeName"].SetOrdinal(3);
                dt.Columns["EmployeeName"].Caption = "Name";
                dt.Columns["Employee"].SetOrdinal(4);
                dt.Columns["Employee"].Caption = "Psuedoname";
                dt.Columns["LoanCount"].SetOrdinal(5);
                dt.Columns["LoanCount"].Caption = "Production Count";
                dt.Columns["ProdPerc"].SetOrdinal(6);
                dt.Columns["ProdPerc"].Caption = "Production %";
                dt.Columns["QualityPerc"].SetOrdinal(7);
                dt.Columns["QualityPerc"].Caption = "Quality %";
                dt.Columns["AttPerc"].SetOrdinal(8);
                dt.Columns["AttPerc"].Caption = "Attendance %";
                dt.Columns["ProdGrade"].SetOrdinal(9);
                dt.Columns["ProdGrade"].Caption = "Production Grade";
                dt.Columns["QualGrade"].SetOrdinal(10);
                dt.Columns["QualGrade"].Caption = "Quality Grade";
                dt.Columns["AttnGrade"].SetOrdinal(11);
                dt.Columns["AttnGrade"].Caption = "Attendance Grade";
                dt.Columns.Remove(dt.Columns["Critical"]);
                dt.Columns.Remove(dt.Columns["NonCritical"]);
                dt.Columns.Remove(dt.Columns["TotalError"]);

                sheet.InsertDataTable(dt, true, 1, 1);
                string Col = GetColumnName_Static(dt.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dt.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Biome";
                sheet.AllocatedRange.Style.Font.Size = 9;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }

            #endregion

            return returnvalue;
        }

        [WebMethod]
        public static int ProductionDetails(string FromDate, string ToDate)
        {
            int returnvalue = 1;

            int rowcount = 0;
            int colcount = 0;

            #region Production Details
            sheet = null;
            sheet = book.Worksheets.Add("Production Details");
           
            DataTable dt = new bllMaster().GetUserPerformanceProdDetails(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString())); ;
            if (dt != null)
            {
                //dt.Columns["Code"].SetOrdinal(0);
                //dt.Columns["Employee"].SetOrdinal(1);
                //dt.Columns["ProjectName"].SetOrdinal(2);
                //dt.Columns["ProjectName"].Caption = "Project #";
                //dt.Columns["DealNo"].SetOrdinal(3);
                //dt.Columns["DealNo"].Caption = "Deal #";
                //dt.Columns["LoanNo"].SetOrdinal(4);
                //dt.Columns["LoanNo"].Caption = "Loan #";
                //dt.Columns["OrderDate"].SetOrdinal(5);
                //dt.Columns["OrderDate"].Caption = "Order Date";
                //dt.Columns["Process"].SetOrdinal(6);
                //dt.Columns["StartDate"].SetOrdinal(7);
                //dt.Columns["StartDate"].Caption = "Start Date";
                //dt.Columns["EndDate"].SetOrdinal(8);
                //dt.Columns["EndDate"].Caption = "End Date";
                //dt.Columns["Status"].SetOrdinal(9);
                //dt.Columns.Remove(dt.Columns["ProdID"]);
                //dt.Columns.Remove(dt.Columns["ProjectID"]);
                //dt.Columns.Remove(dt.Columns["DueDate"]);
                //dt.Columns.Remove(dt.Columns["DispatchDate"]);
                //dt.Columns.Remove(dt.Columns["FinalStatus"]);
                //dt.Columns.Remove(dt.Columns["SciennaID"]);
                //dt.Columns.Remove(dt.Columns["Target"]);
                //dt.Columns.Remove(dt.Columns["Flag"]);
                //dt.Columns.Remove(dt.Columns["TAT"]);
                //dt.Columns.Remove(dt.Columns["HstartDate"]);
                //dt.Columns.Remove(dt.Columns["HEndDate"]);

                sheet.InsertDataTable(dt, true, 1, 1);
                string Col = GetColumnName_Static(dt.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dt.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Biome";
                sheet.AllocatedRange.Style.Font.Size = 9;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int FeedbackDetails(string FromDate, string ToDate)
        {
            int returnvalue = 1;

            int rowcount = 0;
            int colcount = 0;

            #region Feedback Details
            sheet = null;
            sheet = book.Worksheets.Add("Feedback Details");
            DataTable dt = new bllMaster().GetUserPerformanceFeedbackDetails(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString())); ;
            if (dt != null)
            {
                dt.Columns["Month"].SetOrdinal(0);
                dt.Columns["Year"].SetOrdinal(1);
                dt.Columns["ProjectName"].SetOrdinal(2);
                dt.Columns["ProjectName"].Caption = "Project #";
                dt.Columns["DealNo"].SetOrdinal(3);
                dt.Columns["DealNo"].Caption = "Deal #";
                dt.Columns["OrderNo"].SetOrdinal(4);
                dt.Columns["OrderNo"].Caption = "Loan #";
                dt.Columns["ProcessName"].SetOrdinal(5);
                dt.Columns["ProcessName"].Caption = "Process";
                dt.Columns["OrderDate"].SetOrdinal(6);
                dt.Columns["OrderDate"].Caption = "Order Date";
                dt.Columns["ErrorDoneBy"].SetOrdinal(7);
                dt.Columns["ErrorDoneBy"].Caption = "Error Done By";
                dt.Columns["FeedbackBy"].SetOrdinal(8);
                dt.Columns["FeedbackBy"].Caption = "Feedback Given By";
                dt.Columns["ErrorType"].SetOrdinal(9);
                dt.Columns["ErrorType"].Caption = "Error Type";
                dt.Columns["Severity"].SetOrdinal(10);
                dt.Columns["FeildName"].SetOrdinal(11);
                dt.Columns["FeildName"].Caption = "Error Field";
                dt.Columns["Category"].SetOrdinal(12);
                dt.Columns["SubCategory"].SetOrdinal(13);
                dt.Columns["SubCategory"].Caption = "Sub Category";
                dt.Columns["Error"].SetOrdinal(14);
                dt.Columns["ShouldBe"].SetOrdinal(15);
                dt.Columns["ShouldBe"].Caption = "Should Be";
                dt.Columns["FeedbackType"].SetOrdinal(16);
                dt.Columns["FeedbackType"].Caption = "Feedback Type";
                dt.Columns["FeedbackRecivedDate"].SetOrdinal(17);
                dt.Columns["FeedbackRecivedDate"].Caption = "Feedback Date";
                dt.Columns["Remark"].SetOrdinal(18);
                dt.Columns["Status"].SetOrdinal(19);
                dt.Columns["Explaination"].SetOrdinal(20);
                dt.Columns["PMStatus"].SetOrdinal(21);
                dt.Columns["PMStatus"].Caption = "PM Status";
                dt.Columns["PMRemark"].SetOrdinal(22);
                dt.Columns["PMRemark"].Caption = "PM Remark";
                dt.Columns["AddedDate"].SetOrdinal(23);
                dt.Columns["AddedDate"].Caption = "Added Date";

                sheet.InsertDataTable(dt, true, 1, 1);
                string Col = GetColumnName_Static(dt.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dt.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Biome";
                sheet.AllocatedRange.Style.Font.Size = 9;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int AttendanceDetails(string FromDate, string ToDate)
        {
            int returnvalue = 1;

            int rowcount = 0;
            int colcount = 0;

            #region Attendance Details
            sheet = null;
            sheet = book.Worksheets.Add("Attendance Details");
            DataTable dt = new bllMaster().GetUserPerformanceAttendanceDetails(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString())); ;
            if (dt != null)
            {
                dt.Columns["Code"].SetOrdinal(0);
                dt.Columns["TotalCalenderDays"].SetOrdinal(1);
                dt.Columns["TotalCalenderDays"].Caption = "Total Days (Calender Days)";
                dt.Columns["AbsentDays"].SetOrdinal(2);
                dt.Columns["AbsentDays"].Caption = "Absent Days";
                dt.Columns["PartialCount"].SetOrdinal(3);
                dt.Columns["PartialCount"].Caption = "Partial Days";
                dt.Columns["PartialDays"].SetOrdinal(4);
                dt.Columns["PartialDays"].Caption = "Partial days (equivalent full days)";
                dt.Columns["TotalAbsentDays"].SetOrdinal(5);
                dt.Columns["TotalAbsentDays"].Caption = "Total Absents (Full day + Partial Days)";
                dt.Columns["SalaryPresentDays"].SetOrdinal(6);
                dt.Columns["SalaryPresentDays"].Caption = "Present Days (as per Final Salary Calculation)";
                dt.Columns["AttendancePercOnTotalDays"].SetOrdinal(7);
                dt.Columns["AttendancePercOnTotalDays"].Caption = "Attendance % on Total Days";
                dt.Columns["Latemarks"].SetOrdinal(8);
                dt.Columns["RemovedLatemarks"].SetOrdinal(9);
                dt.Columns["RemovedLatemarks"].Caption = "Removed Latemarks";
                dt.Columns["TotalLatemarks"].SetOrdinal(10);
                dt.Columns["TotalLatemarks"].Caption = "Total Latemarks";
                dt.Columns.Remove(dt.Columns["EmployeeID"]);
                dt.Columns.Remove(dt.Columns["Month"]);
                dt.Columns.Remove(dt.Columns["Year"]);
                dt.Columns.Remove(dt.Columns["TotalWorkingDays"]);
                dt.Columns.Remove(dt.Columns["AbsentDaysWOWeekOff"]);
                dt.Columns.Remove(dt.Columns["TotalPartialDays"]);
                dt.Columns.Remove(dt.Columns["TotalAbsentDaysWOWeeklyOff"]);
                dt.Columns.Remove(dt.Columns["AttendancePercOnWorkingDays"]);
                dt.Columns.Remove(dt.Columns["WeekOffCount"]);
                sheet.InsertDataTable(dt, true, 1, 1);
                string Col = GetColumnName_Static(dt.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dt.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Biome";
                sheet.AllocatedRange.Style.Font.Size = 9;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion

            if (File.Exists(FileName))
            {
                try
                {
                    File.Delete(FileName);
                }
                catch { }
            }

            book.SaveToFile(FileName, ExcelVersion.Version2010);

            return returnvalue;
        }


        [WebMethod]
        public static int ProductionOtherTask(string FromDate, string ToDate)
        {
            int returnvalue = 1;

            int rowcount = 0;
            int colcount = 0;

            #region Production Details
            sheet = null;
            sheet = book.Worksheets.Add("Production Other Task");

            DataTable dt = new bllMaster().GetUserPerformanceProdDetailsOther(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString())); ;
            if (dt != null)
            {
                sheet.InsertDataTable(dt, true, 1, 1);
                string Col = GetColumnName_Static(dt.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dt.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Biome";
                sheet.AllocatedRange.Style.Font.Size = 9;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            return returnvalue;
        }


        protected void btn1_Click(object sender, EventArgs e)
        {
            string filePath = FileName;
            string outputPath = FileName;

            // Zero-based index: e.g., index 0 = first sheet
            int sheetIndexToDelete = 1;

            using (var workbook = new XLWorkbook(filePath))
            {
                // Check if index is within bounds
                if (sheetIndexToDelete >= 0 && sheetIndexToDelete < workbook.Worksheets.Count)
                {
                    var worksheet = workbook.Worksheet(1);
                    workbook.Worksheets.Delete(worksheet.Name);
                    worksheet = workbook.Worksheet(1);
                    workbook.Worksheets.Delete(worksheet.Name);
                    worksheet = workbook.Worksheet(1);
                    workbook.Worksheets.Delete(worksheet.Name);
                    int cnt = workbook.Worksheets.Count;
                    worksheet = workbook.Worksheet(5);
                    workbook.Worksheets.Delete(worksheet.Name);
                }
                else
                {

                }

                // Save the updated workbook
                workbook.SaveAs(outputPath);

            }

            Response.Clear();
            Response.Buffer = false;
            Response.AppendHeader("Content-Type", "application/xlsx");
            Response.AppendHeader("Content-Transfer-Encoding", "binary");
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(FileName));
            Response.TransmitFile(FileName);
            Response.End();
        }
    }
}