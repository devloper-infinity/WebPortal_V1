using ClosedXML.Excel;
using Spire.Xls;
using Spire.Xls.Core;
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
using Excel = Microsoft.Office.Interop.Excel;

namespace WebPortal.Admin
{
    public partial class AbscondingAndLeaveReport : System.Web.UI.Page
    {
        string FileName = "";
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetTotalAbsconingEmployees(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetTotalAbscondingEmployees(Month, Year);
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
        public static string GetTotalLeaves(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetTotalLeaves(Month, Year);
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

        static string GetColumnName(int index)
        {
            const string letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

            var value = "";

            if (index >= letters.Length)
                value += letters[index / letters.Length - 1];

            value += letters[index % letters.Length];

            return value;
        }

        public void HeaderFormat(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Color = Color.FromArgb(113, 147, 209);
            range.Style.Font.Color = Color.White;
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.IsBold = true;
        }

        public void AllBorder(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }
        public void ContentCenter(CellRange range)
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

        protected void btn1_Click(object sender, EventArgs e)
        {
            string Month = Convert.ToString(Request.Form["ableave_month"]);
            string Year = Convert.ToString(Request.Form["ableave_year"]);
            FileName = Server.MapPath(@"~\ReportDocument\Absconding_And_Leaves_Report_" + Convert.ToString(Month) + "-" + Convert.ToString(Year) + DateTime.Now.ToString("hhmmss") + ".xlsx");
            FormatExcel(FileName, Month, Year);
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
                    worksheet = workbook.Worksheet(6);
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

        public void FormatExcel(string FileName, string Month, string Year)
        {
            Workbook book = new Workbook();
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";

            Worksheet detailSheet = book.Worksheets.Add("Absconding Details");
            Worksheet summarySheet = book.Worksheets.Add("Absconding Summary");

            DataTable dt = new bllMaster().GetTotalAbscondingEmployees(Month, Year);

            if (dt == null || dt.Rows.Count == 0)
                return;

            // Ensure AbscondedDate is DateTime
            foreach (DataRow row in dt.Rows)
            {
                if (row["AbscondedDate"] != DBNull.Value)
                    row["AbscondedDate"] = Convert.ToDateTime(row["AbscondedDate"]);
            }

            // 🔥 Create Month-Year Column manually
            if (!dt.Columns.Contains("MonthYear"))
                dt.Columns.Add("MonthYear", typeof(string));

            foreach (DataRow row in dt.Rows)
            {
                if (row["AbscondedDate"] != DBNull.Value)
                {
                    DateTime d = Convert.ToDateTime(row["AbscondedDate"]);
                    row["MonthYear"] = d.ToString("MMM-yy");
                }
            }

            // 🔥 Get latest 4 months
            var lastFourMonths = dt.AsEnumerable()
                .Where(r => r["AbscondedDate"] != DBNull.Value)
                .OrderByDescending(r => Convert.ToDateTime(r["AbscondedDate"]))
                .Select(r => Convert.ToDateTime(r["AbscondedDate"]).ToString("MMM-yy"))
                .Distinct()
                .Take(4)
                .ToList();

            DataTable filteredDt = dt.AsEnumerable()
                .Where(r => lastFourMonths.Contains(r["MonthYear"].ToString()))
                .CopyToDataTable();

            filteredDt.Columns.Remove("EmployeeID");

            // Insert details
            detailSheet.InsertDataTable(filteredDt, true, 1, 1);

            detailSheet.AllocatedRange.AutoFitColumns();
            detailSheet.AllocatedRange.AutoFitRows();

            int lastRow = detailSheet.LastRow;
            int lastCol = detailSheet.LastColumn;
            string lastColLetter = GetColumnName(lastCol);

            // =====================================================
            // DOMAIN WISE PIVOT
            // =====================================================

            CellRange dataRange = detailSheet.Range["A1:" + lastColLetter + lastRow];
            PivotCache cache = book.PivotCaches.Add(dataRange);

            PivotTable pt = summarySheet.PivotTables.Add("DomainWise",
                            summarySheet.Range["A1"], cache);

            // Row = Domain
            var rowField = pt.PivotFields["Domain"];
            rowField.Axis = AxisTypes.Row;

            // Column = MonthYear (manual column)
            var colField = pt.PivotFields["MonthYear"];
            colField.Axis = AxisTypes.Column;

            // Values
            pt.DataFields.Add(pt.PivotFields["Code"],"Employee Count",SubtotalTypes.Count);

            pt.BuiltInStyle = PivotBuiltInStyles.PivotStyleMedium9;
            pt.CalculateData();

            // =====================================================
            // PROFESSIONAL FORMATTING
            // =====================================================

            summarySheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            summarySheet.AllocatedRange.Style.Font.Size = 10;
            summarySheet.AllocatedRange.Style.HorizontalAlignment = HorizontalAlignType.Center;

            CellRange header = summarySheet.Range["A1:" +
                GetColumnName(summarySheet.LastColumn) + "1"];

            header.Style.Color = System.Drawing.Color.FromArgb(47, 85, 151);
            header.Style.Font.Color = System.Drawing.Color.White;
            header.Style.Font.IsBold = true;

            summarySheet.AllocatedRange.AutoFitColumns();
            summarySheet.AllocatedRange.AutoFitRows();

            summarySheet.FreezePanes(2, 1);

            // =====================================================
            // SAVE
            // =====================================================

            if (File.Exists(FileName))
            {
                try { File.Delete(FileName); }
                catch { }
            }

            book.SaveToFile(FileName, ExcelVersion.Version2010);
        }


        public void FormatExcel_Core(string FileName, string Month, string Year)
        {
            Workbook book = new Workbook();
            //book.LoadFromFile(FileName);
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";
            int rowcount = 0;
            int mainrowcount = 0;
            int colcount = 0;
            Worksheet sheet = book.Worksheets.Add("Absconding Summary");
            sheet = book.Worksheets.Add("Absconding Details");
            
            DataTable dt = new bllMaster().GetTotalAbscondingEmployees(Month, Year);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    dt.Columns.Remove("EmployeeID");
                    sheet.InsertDataTable(dt, true, 1, 1);
                    string Col = GetColumnName(dt.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dt.Rows.Count + 1)];
                    AllBorder(range);
                    ContentCenter(range);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;
                    mainrowcount = sheet.LastRow;

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();

                    sheet = book.Worksheets["Absconding Summary"];
                    #region Domain wise
                    CellRange dataRangeHiring = book.Worksheets["Absconding Details"].Range["A1:" + Col + (mainrowcount)];
                    PivotCache cacheHiring = book.PivotCaches.Add(dataRangeHiring);
                    PivotTable ptHiring = sheet.PivotTables.Add("Domain", sheet.Range["A1"], cacheHiring);

                    var rHiring = ptHiring.PivotFields["Domain"];
                    rHiring.Axis = AxisTypes.Row;
                    ptHiring.Options.RowHeaderCaption = "Domain";

                    ptHiring.DataFields.Add(ptHiring.PivotFields["Code"], "Employee Count", SubtotalTypes.Count);

                    ptHiring.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptHiring.CalculateData();
                    #endregion

                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    #region Location wise
                    dataRangeHiring = book.Worksheets["Absconding Details"].Range["A1:" + Col + (mainrowcount)];
                    cacheHiring = book.PivotCaches.Add(dataRangeHiring);
                    ptHiring = sheet.PivotTables.Add("Branch", sheet.Range["A" + (rowcount)], cacheHiring);

                    rHiring = ptHiring.PivotFields["Branch"];
                    rHiring.Axis = AxisTypes.Row;
                    ptHiring.Options.RowHeaderCaption = "Location";

                    ptHiring.DataFields.Add(ptHiring.PivotFields["Code"], "Employee Count", SubtotalTypes.Count);

                    ptHiring.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptHiring.CalculateData();

                    #endregion

                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    #region Domain and Location wise
                    string Col1 = GetColumnName(colcount - 4);
                    dataRangeHiring = book.Worksheets["Absconding Details"].Range["A1:" + Col + (mainrowcount)];
                    cacheHiring = book.PivotCaches.Add(dataRangeHiring);
                    ptHiring = sheet.PivotTables.Add("Domain Head", sheet.Range[Col1 + "1"], cacheHiring);

                    rHiring = ptHiring.PivotFields["DomainHead"];
                    rHiring.Axis = AxisTypes.Row;
                    ptHiring.Options.RowHeaderCaption = "Domain Head";

                    var rHiring1 = ptHiring.PivotFields["Branch"];
                    rHiring1.Axis = AxisTypes.Column;
                    ptHiring.Options.ColumnHeaderCaption = "Location";

                    ptHiring.DataFields.Add(ptHiring.PivotFields["Code"], "Employee Count", SubtotalTypes.Count);

                    ptHiring.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptHiring.CalculateData();

                    #endregion

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }

            sheet = book.Worksheets.Add("Leave Summary");
            sheet = book.Worksheets.Add("Leave Details");

            //DataTable dt1 = new bllMaster().GetTotalLeaves(Month, Year);
            DataSet ds = new bllMaster().GetTotalLeaves_Revised(Month, Year);
            if (ds != null)
            {
                if (ds.Tables.Count > 0)
                {
                    DataTable dt1 = ds.Tables[0];
                    DataTable dt2 = ds.Tables[1];

                    if (dt1 != null)
                    {
                        if (dt1.Rows.Count > 0)
                        {
                            sheet.InsertDataTable(dt1, true, 1, 1);
                            string Col = GetColumnName(dt1.Columns.Count - 1);
                            CellRange range = sheet.Range["A1:" + Col + "1"];
                            HeaderFormat(range);
                            range = sheet.Range["A1:" + Col + (dt1.Rows.Count + 1)];
                            AllBorder(range);
                            ContentCenter(range);
                            rowcount = sheet.LastRow;
                            colcount = sheet.LastColumn;
                            mainrowcount = sheet.LastRow;

                            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                            sheet.AllocatedRange.Style.Font.Size = 10;

                            sheet.AllocatedRange.AutoFitColumns();
                            sheet.AllocatedRange.AutoFitRows();
                            
                            sheet = book.Worksheets.Add("Previous Month Leave Details");
                            sheet.InsertDataTable(dt2, true, 1, 1);
                            Col = GetColumnName(dt2.Columns.Count - 1);
                            range = sheet.Range["A1:" + Col + "1"];
                            HeaderFormat(range);
                            range = sheet.Range["A1:" + Col + (dt2.Rows.Count + 1)];
                            AllBorder(range);
                            ContentCenter(range);

                            sheet = book.Worksheets["Leave Summary"];
                            #region Domain wise
                            CellRange dataRangeHiring = book.Worksheets["Leave Details"].Range["A1:" + Col + (mainrowcount)];
                            PivotCache cacheHiring = book.PivotCaches.Add(dataRangeHiring);
                            PivotTable ptHiring = sheet.PivotTables.Add("Domain", sheet.Range["A1"], cacheHiring);

                            var rHiring = ptHiring.PivotFields["Domain"];
                            rHiring.Axis = AxisTypes.Row;
                            ptHiring.Options.RowHeaderCaption = "Domain";

                            ptHiring.DataFields.Add(ptHiring.PivotFields["Code"], "Employee Count", SubtotalTypes.Count);
                            ptHiring.DataFields.Add(ptHiring.PivotFields["ForDays"], "For Days", SubtotalTypes.Sum);

                            ptHiring.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                            ptHiring.CalculateData();
                            #endregion

                            rowcount = sheet.LastRow;
                            colcount = sheet.LastColumn;

                            #region Location wise
                            dataRangeHiring = book.Worksheets["Leave Details"].Range["A1:" + Col + (mainrowcount)];
                            cacheHiring = book.PivotCaches.Add(dataRangeHiring);
                            ptHiring = sheet.PivotTables.Add("Branch", sheet.Range["A" + (rowcount)], cacheHiring);

                            rHiring = ptHiring.PivotFields["Branch"];
                            rHiring.Axis = AxisTypes.Row;
                            ptHiring.Options.RowHeaderCaption = "Location";

                            ptHiring.DataFields.Add(ptHiring.PivotFields["Code"], "Employee Count", SubtotalTypes.Count);
                            ptHiring.DataFields.Add(ptHiring.PivotFields["ForDays"], "For Days", SubtotalTypes.Sum);

                            ptHiring.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                            ptHiring.CalculateData();

                            #endregion

                            rowcount = sheet.LastRow;
                            colcount = sheet.LastColumn;

                            #region Domain and Location wise
                            string Col1 = GetColumnName(colcount - 4);
                            dataRangeHiring = book.Worksheets["Leave Details"].Range["A1:" + Col + (mainrowcount)];
                            cacheHiring = book.PivotCaches.Add(dataRangeHiring);
                            ptHiring = sheet.PivotTables.Add("Domain Head", sheet.Range[Col1 + "1"], cacheHiring);

                            rHiring = ptHiring.PivotFields["DomainHead"];
                            rHiring.Axis = AxisTypes.Row;
                            ptHiring.Options.RowHeaderCaption = "Domain Head";

                            var rHiring1 = ptHiring.PivotFields["Branch"];
                            rHiring1.Axis = AxisTypes.Column;
                            ptHiring.Options.ColumnHeaderCaption = "Location";

                            ptHiring.DataFields.Add(ptHiring.PivotFields["Code"], "Employee Count", SubtotalTypes.Count);
                            ptHiring.DataFields.Add(ptHiring.PivotFields["ForDays"], "For Days", SubtotalTypes.Sum);

                            ptHiring.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                            ptHiring.CalculateData();

                            #endregion

                            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                            sheet.AllocatedRange.Style.Font.Size = 10;

                            sheet.AllocatedRange.AutoFitColumns();
                            sheet.AllocatedRange.AutoFitRows();

                            sheet = book.Worksheets.Add("Leave Summary");
                            sheet = book.Worksheets.Add("Leave Details");
                        }
                    }
                }
            }

            if (File.Exists(FileName))
            {
                try
                {
                    File.Delete(FileName);
                }
                catch { }
            }
            book.SaveToFile(FileName, ExcelVersion.Version2010);

        }
    }
}