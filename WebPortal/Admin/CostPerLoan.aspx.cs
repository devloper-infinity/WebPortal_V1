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
    public partial class CostPerLoan : System.Web.UI.Page
    {
        static DataSet ds = null;
        static DataTable dtSum = null;
        static DataTable dtProd = null;
        static string FileName;
        public static string ReportFileName = "";
        public static string ReportFilePath = "";
        static Workbook book = new Workbook();
        static Worksheet sheet;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetCostperLoanReport(string Month, string Year, string Domain)
        {
            ds = new bllSalary().GetCostperLoanReport(Month, Year, Domain);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (ds != null)
            {
                dtSum = ds.Tables[1];
                foreach (DataRow dr in dtSum.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dtSum.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetCostperLoanReportProduction(string Month, string Year)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            dtProd = ds.Tables[0];
            foreach (DataRow dr in dtProd.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dtProd.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
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

        [WebMethod]
        public static int GetCostperLoanReportExport(string Month, string Year, string Domain)
        {
            int returnvalue = 1;
            DataSet ds1 = new bllSalary().GetCostperLoanReport(Month, Year, Domain);
            if (ds1 != null)
            {
                FileName = HttpContext.Current.Server.MapPath(@"~\ReportDocument\CostPerLoan_" + Domain + "-" + Month + "-" + Year + ".xlsx");
                DataTable dtsum = ds1.Tables[1];
                DataTable dprod = ds1.Tables[0];
                book = new Workbook();
                book.DefaultFontSize = 9;
                book.DefaultFontName = "biome";

                int rowcount = 0;
                int colcount = 0;

                #region summary
                sheet = book.Worksheets.Add("Summary");
                sheet.InsertDataTable(dtsum, true, 1, 1);
                string Col = GetColumnName_Static(dtsum.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtsum.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);

                for (int i = 2; i <= sheet.LastRow; i++)
                {
                    sheet.Range["O" + (i)].Formula = "=(N" + (i) + "/L" + (i) + ")";
                    sheet.Range["O" + (i)].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    sheet.Range["O" + (i)].NumberFormat = "0.00";
                    sheet.Range["P" + (i)].Formula = "=(O" + (i) + "*M" + (i) + ")";
                    sheet.Range["P" + (i)].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    sheet.Range["P" + (i)].NumberFormat = "0.00";
                    sheet.Range["R" + (i)].Formula = "=(P" + (i) + "/Q" + (i) + ")";
                    sheet.Range["R" + (i)].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    sheet.Range["R" + (i)].NumberFormat = "0.00";
                    sheet.Range["S" + (i)].Formula = "=(R" + (i) + "*N" + (i) + ")";
                    sheet.Range["S" + (i)].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    sheet.Range["S" + (i)].NumberFormat = "0.00";
                    sheet.Range["T" + (i)].Formula = "=(N" + (i) + "-Q" + (i) + ")";
                    sheet.Range["T" + (i)].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    sheet.Range["T" + (i)].NumberFormat = "0.00";
                    sheet.Range["V" + (i)].Formula = "=Round(((S" + (i) + "/N" + (i) + ")*100),0)";
                    sheet.Range["V" + (i)].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    sheet.Range["V" + (i)].NumberFormat = "0";
                    sheet.Range["Z" + (i)].Formula = "=(((H" + (i) + "/M" + (i) + ")*V" + (i) + ")/100)";
                    sheet.Range["Z" + (i)].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    sheet.Range["Z" + (i)].NumberFormat = "0.00";
                }
                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();

                #endregion
                #region summary
                sheet = book.Worksheets.Add("Actual Production");
                sheet.InsertDataTable(dprod, true, 1, 1);
                Col = GetColumnName_Static(dprod.Columns.Count - 1);
                range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dprod.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);



                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();

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

            }
            return returnvalue;
        }

        protected void btn1_Click(object sender, EventArgs e)
        {
            //FileName = Server.MapPath(@"~\ReportDocument\Credit_Consolidated_Report_" + Convert.ToString(Month) + "-" + Convert.ToString(Year) + DateTime.Now.ToString("hhmmss") + ".xlsx");
            // FormatExcel(FileName);

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
                    worksheet = workbook.Worksheet(3);
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