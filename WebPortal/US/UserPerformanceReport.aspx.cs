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

namespace WebPortal.US
{
    public partial class UserPerformanceReport : System.Web.UI.Page
    {
        static string FileName = "";
        static string outputPath = "";
        static Workbook book = new Workbook();
        static Worksheet sheet;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Excel Generation

        protected void btnUWDetails_Click(object sender, EventArgs e)
        {

            Microsoft.Office.Interop.Excel.Application xlApp = new Microsoft.Office.Interop.Excel.Application();
            if (xlApp == null)
            {
                return;
            }
            xlApp.DisplayAlerts = false;
            Microsoft.Office.Interop.Excel.Workbook xlWorkBook = xlApp.Workbooks.Open(FileName);
            System.Threading.Thread.Sleep(1000);
            Microsoft.Office.Interop.Excel.Sheets worksheets = xlWorkBook.Worksheets;
            worksheets[1].Delete();
            worksheets[1].Delete();
            worksheets[1].Delete();
            worksheets[5].Delete();
            worksheets[1].Select();
            xlWorkBook.Save();
            xlWorkBook.Close();
            xlApp.Quit();

            releaseObject(worksheets);
            releaseObject(xlWorkBook);
            releaseObject(xlApp);

            Response.Clear();
            Response.Buffer = false;
            Response.AppendHeader("Content-Type", "application/xlsx");
            Response.AppendHeader("Content-Transfer-Encoding", "binary");
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(FileName));
            Response.TransmitFile(FileName);
            Response.End();
        }

        [WebMethod]
        public static int Credit_Summary(string FromDate, string ToDate)
        {
            int returnvalue = 1;
            FileName = HttpContext.Current.Server.MapPath(@"~\ReportDocument\User_Performance_Report_Greg" + Convert.ToString(FromDate) + " to " + Convert.ToString(ToDate) + DateTime.Now.ToString("hhmmss") + ".xlsx");

            book.DefaultFontSize = 9;
            book.DefaultFontName = "biome";

            int rowcount = 0;
            int colcount = 0;

            #region Summary

            sheet = null;
            sheet = book.Worksheets.Add("CreditSummary");

            DataTable dt = new bllUS().GetOverAllUserPerformance_credit_Greg(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), FromDate, ToDate);

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
        public static int Servicing_Summary(string FromDate, string ToDate)
        {
            int returnvalue = 1;

            int rowcount = 0;
            int colcount = 0;

            #region Servicing Summary

            sheet = null;
            sheet = book.Worksheets.Add("Servicing Summary");

            DataTable dt = new bllUS().GetOverAllUserPerformance_Servicing_Greg(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), FromDate, ToDate);

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
            }

            #endregion

            return returnvalue;
        }

        [WebMethod]
        public static int Credit_ProductionDetails(string FromDate, string ToDate)
        {
            int returnvalue = 1;

            int rowcount = 0;
            int colcount = 0;

            #region Production Details
            sheet = null;
            sheet = book.Worksheets.Add("Credit Production Details");

            DataTable dt = new bllUS().GetOverAllUserPerformanceDetails_Credit_Greg(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), FromDate, ToDate);

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
        public static int Servicing_ProductionDetails(string FromDate, string ToDate)
        {
            int returnvalue = 1;

            int rowcount = 0;
            int colcount = 0;

            #region Production Details
            sheet = null;
            sheet = book.Worksheets.Add("Servicing Production Details");

            DataTable dt = new bllUS().GetOverAllUserPerformanceDetails_Servicing_Greg(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), FromDate, ToDate);

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

            if (File.Exists(FileName))
            {
                try
                {
                    File.Delete(FileName);
                }
                catch { }
            }

            book.SaveToFile(FileName, ExcelVersion.Version2010);

            ////Response.ContentType = "application/msword";
            ////Response.AppendHeader("Content-Disposition", "attachment; filename=" + FileName);
            ////Response.TransmitFile(outputPath);
            ////Response.End();

            ////FileName = HttpContext.Current.Server.MapPath(@"~\ReportDocument\User_Performance_Report_Greg" + Convert.ToString(FromDate) + " to " + Convert.ToString(ToDate) + DateTime.Now.ToString("hhmmss") + ".xlsx");

            //Response.ContentType = "application/msword";
            //Response.AppendHeader("Content-Disposition", "attachment; filename=" + Convert.ToString(dtAnex.Rows[0]["EmployeeID"]) + "-" + Convert.ToString(dtAnex.Rows[0]["Code"]) + "-Annexure.docx");
            //Response.TransmitFile(outputPath);
            //Response.End();
            
            return returnvalue;
        }

        #endregion

        #region Datatable Method

        [WebMethod]
        public static string GetUserPerformanceReport_Credit(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllUS().GetOverAllUserPerformance_credit_Greg(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), FromDate, ToDate);
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
        public static string GetUserPerformanceReport_Servicing(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllUS().GetOverAllUserPerformance_Servicing_Greg(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), FromDate, ToDate);
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
        public static string GetOverAllUserPerformanceDetails_Credit_Greg(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllUS().GetOverAllUserPerformanceDetails_Credit_Greg(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), FromDate, ToDate);
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
        public static string GetOverAllUserPerformanceDetails_Servicing_Greg(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllUS().GetOverAllUserPerformanceDetails_Servicing_Greg(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), FromDate, ToDate);
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

        #endregion

        #region Supportive Method

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

        #endregion
    }
}