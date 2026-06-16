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
using Excel = Microsoft.Office.Interop.Excel;

namespace WebPortal.Admin
{
    public partial class AllResignedEmployees : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllResignedEmployees(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetDropoutEmployeeDetailsForISO_Revised(Month, Year);
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
        public static string GetResignedEmployeeSummary_MonthWise(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetResignedEmployeeSummary_MonthWise(Convert.ToDateTime(FromDate).ToString("dd-MMM-yyyy"), Convert.ToDateTime(ToDate).ToString("dd-MMM-yyyy"));
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

        protected void btn31_Click(object sender, EventArgs e)
        {
            string FromDate = Convert.ToString(Request.Form["allresigned_from"]);
            string ToDate = Convert.ToString(Request.Form["allresigned_to"]);
            string FileName = Server.MapPath(@"~\ReportDocument\All_Resigned_Employees_" + Convert.ToString(FromDate) + " to " + Convert.ToString(ToDate) + "_" + DateTime.Now.ToString("hhmmss") + ".xlsx");
            Workbook book = new Workbook();
            //book.LoadFromFile(FileName);
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";
            int rowcount = 0;
            int colcount = 0;

            DataTable dt = new bllMaster().GetDropoutEmployeeDetailsForISO_Revised(FromDate, ToDate);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    Worksheet sheet = book.Worksheets.Add("Summary");
                    sheet = book.Worksheets.Add("Details");
                    sheet.InsertDataTable(dt, true, 1, 1);
                    string Col = GetColumnName(dt.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dt.Rows.Count + 1)];
                    AllBorder(range);
                    ContentCenter(range);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    sheet.Range["A1"].Value = "Code";
                    sheet.Range["B1"].Value = "Name";
                    sheet.Range["C1"].Value = "Joining Date";
                    sheet.Range["D1"].Value = "Date Of Birth";
                    sheet.Range["E1"].Value = "Branch";
                    sheet.Range["F1"].Value = "Department";
                    sheet.Range["G1"].Value = "Designation";
                    sheet.Range["H1"].Value = "Domain";
                    sheet.Range["I1"].Value = "Subdomain";
                    sheet.Range["J1"].Value = "Reporting Manager";
                    sheet.Range["K1"].Value = "Domain Head";                    
                    sheet.Range["L1"].Value = "Latest Login Date";
                    sheet.Range["M1"].Value = "Resignation Type";
                    sheet.Range["N1"].Value = "Resignation Date";
                    sheet.Range["O1"].Value = "Last Working Date";
                    sheet.Range["P1"].Value = "Step 1 Remark";
                    sheet.Range["Q1"].Value = "Step 2 Remark";
                    sheet.Range["R1"].Value = "Step 3 Remark";

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();

                    sheet = book.Worksheets["Summary"];
                    CellRange dataRangeHiring = book.Worksheets["Details"].Range["A1:L" + book.Worksheets["Details"].LastRow];
                    PivotCache cacheHiring = book.PivotCaches.Add(dataRangeHiring);
                    PivotTable ptHiring = sheet.PivotTables.Add("Domain", sheet.Range["A1"], cacheHiring);

                    var rHiring = ptHiring.PivotFields["Domain"];
                    rHiring.Axis = AxisTypes.Row;
                    ptHiring.Options.RowHeaderCaption = "Domain";

                    var rHiring1 = ptHiring.PivotFields["Branch"];
                    rHiring1.Axis = AxisTypes.Column;
                    ptHiring.Options.ColumnHeaderCaption = "Branch";

                    ptHiring.DataFields.Add(ptHiring.PivotFields["Code"], "Employees", SubtotalTypes.Count);

                    ptHiring.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptHiring.CalculateData();

                    dataRangeHiring = book.Worksheets["Details"].Range["A1:L" + book.Worksheets["Details"].LastRow];
                    cacheHiring = book.PivotCaches.Add(dataRangeHiring);
                    ptHiring = sheet.PivotTables.Add("Branch", sheet.Range["A" + (sheet.LastRow + 2)], cacheHiring);

                    rHiring = ptHiring.PivotFields["Domain Head"];
                    rHiring.Axis = AxisTypes.Row;
                    ptHiring.Options.RowHeaderCaption = "Domain Head";

                    rHiring1 = ptHiring.PivotFields["Branch"];
                    rHiring1.Axis = AxisTypes.Column;
                    ptHiring.Options.ColumnHeaderCaption = "Branch";

                    ptHiring.DataFields.Add(ptHiring.PivotFields["Code"], "Employees", SubtotalTypes.Count);

                    ptHiring.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;

                    ptHiring.CalculateData();
                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;
                    sheet.AllocatedRange.Style.HorizontalAlignment = HorizontalAlignType.Center;
                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();

                    book.Worksheets["Summary"].Activate();

                    if (File.Exists(FileName))
                    {
                        try
                        {
                            File.Delete(FileName);
                        }
                        catch { }
                    }
                    book.SaveToFile(FileName, ExcelVersion.Version2010);


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
                            worksheet = workbook.Worksheet(cnt);
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
    }
}