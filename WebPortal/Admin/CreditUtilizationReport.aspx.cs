using ClosedXML.Excel;
using Spire.Xls;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.DAL;
using Excel = Microsoft.Office.Interop.Excel;

namespace WebPortal.Admin
{
    public partial class CreditUtilizationReport : System.Web.UI.Page
    {
        static string FileName = "";
        static Workbook book = null;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn1_Click(object sender, EventArgs e)
        {
            //waitingpanel.Style.Add("display", "");
            //FormatExcel_New(FileName);

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

        static string GetColumnName(int index)
        {
            const string letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

            var value = "";

            if (index >= letters.Length)
                value += letters[index / letters.Length - 1];

            value += letters[index % letters.Length];

            return value;
        }

        public static DataTable GetEmployeeWorkedHours(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetUtilizationReportAttendanceLog]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public static DataTable GetEmployeeNonProductionData(string Employee, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetnonProductiveData]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Employee", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Employee);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public static DataSet GetReportData_New(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetUtilizationReport]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        [WebMethod]
        public static int GenerateOutput(string Month, string Year)
        {
            FileName = HttpContext.Current.Server.MapPath(@"~\ReportDocument\Utilization_Report_" + Convert.ToString(HttpContext.Current.Request.Form["creditutil_month"]) + "-" + Convert.ToString(HttpContext.Current.Request.Form["creditutil_year"]) + DateTime.Now.ToString("hhmmss") + ".xlsx");
            book = new Workbook();
            DataSet dsResult = GetReportData_New(Month, Year);
            DataTable attendance = GetEmployeeWorkedHours(Month, Year);
            if (dsResult != null)
            {
                DataTable dt = dsResult.Tables[0];
                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        DataSet ds = new DataSet();
                        DataTable dtClone = dt.Clone();
                        Worksheet sheet;

                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            if (i > 0 && i != dt.Rows.Count - 1 && Convert.ToString(dt.Rows[i + 1]["Employee"]) != Convert.ToString(dt.Rows[i]["Employee"]))
                            {
                                //sheet = book.CreateEmptySheet(Convert.ToString(dt.Rows[i]["Employee"]));
                                DataRow dr = dt.Rows[i];
                                dtClone.Rows.Add(dr.ItemArray);
                                dtClone.TableName = Convert.ToString(dt.Rows[i]["Employee"]);
                                ds.Tables.Add(dtClone);
                                dtClone = null;
                                dtClone = dt.Clone();

                            }

                            else if (i >= 0)
                            {
                                DataRow dr = dt.Rows[i];
                                dtClone.Rows.Add(dr.ItemArray);

                                //sheet = book.CreateEmptySheet(Convert.ToString(dt.Rows[i]["Employee"]));
                            }
                            else
                            {
                                DataRow dr = dt.Rows[i];
                                dtClone.Rows.Add(dr.ItemArray);
                            }
                            if (i == dt.Rows.Count - 1)
                            {
                                dtClone.TableName = Convert.ToString(dt.Rows[i]["Employee"]);
                                ds.Tables.Add(dtClone);
                            }
                        }


                        int RowCount = 1;
                        int ColumnCount = 1;

                        string ColName = "";
                        CellRange range;

                        for (int k = 0; k < ds.Tables.Count; k++)
                        {
                            DataTable attcopy = null;
                            DataTable dtSheet = ds.Tables[k];
                            sheet = book.CreateEmptySheet(Convert.ToString(dtSheet.Rows[0]["Employee"]));
                            //dtSheet.Columns.RemoveAt(5);
                            //dtSheet.AcceptChanges();
                            //dtSheet.Columns.RemoveAt(5);
                            //dtSheet.AcceptChanges();
                            dtSheet.Columns.RemoveAt(0);
                            dtSheet.AcceptChanges();
                            sheet.InsertDataTable(dtSheet, true, 1, 1);
                            //range.BorderAround(LineStyleType.Thick, ExcelColors.Black);
                            RowCount = sheet.LastRow;
                            ColumnCount = sheet.LastColumn;

                            ColName = GetColumnName(ColumnCount - 1);

                            sheet.Range[RowCount + 1, 1].Value = "Points Per Day";
                            sheet.Range[RowCount + 1, 1, RowCount + 1, 4].Merge();
                            sheet.Range[RowCount + 1, 1, RowCount + 1, 4].Style.Color = Color.FromArgb(208, 206, 206);
                            sheet.Range[RowCount + 1, 1, RowCount + 1, 4].Style.Font.IsBold = true;
                            sheet.Range[RowCount + 2, 1].Value = "Actual Hours Worked";
                            sheet.Range[RowCount + 2, 1, RowCount + 2, 4].Style.Color = Color.FromArgb(208, 206, 206);
                            sheet.Range[RowCount + 2, 1, RowCount + 2, 4].Style.Font.IsBold = true;
                            sheet.Range[RowCount + 2, 1, RowCount + 2, 4].Merge();
                            sheet.Range[RowCount + 3, 1].Value = "Hours Worked (Adjusted as per day target)";
                            sheet.Range[RowCount + 3, 1, RowCount + 3, 4].Style.Color = Color.FromArgb(208, 206, 206);
                            sheet.Range[RowCount + 3, 1, RowCount + 3, 4].Style.Font.IsBold = true;
                            sheet.Range[RowCount + 3, 1, RowCount + 3, 4].Merge();
                            sheet.Range[RowCount + 4, 1].Value = "Approved PTO";
                            sheet.Range[RowCount + 4, 1, RowCount + 4, 4].Style.Color = Color.FromArgb(208, 206, 206);
                            sheet.Range[RowCount + 4, 1, RowCount + 4, 4].Style.Font.IsBold = true;
                            sheet.Range[RowCount + 4, 1, RowCount + 4, 4].Merge();
                            sheet.Range[RowCount + 5, 1].Value = "Producticity %";
                            sheet.Range[RowCount + 5, 1, RowCount + 5, 4].Style.Color = Color.FromArgb(250, 191, 143);
                            sheet.Range[RowCount + 5, 1, RowCount + 5, 4].Style.Font.IsBold = true;
                            sheet.Range[RowCount + 5, 1, RowCount + 5, 4].Merge();

                            StringBuilder strPointsPerDayFormula = new StringBuilder();
                            string formula = "=";
                            for (int j = 5; j <= sheet.LastColumn; j++)
                            {
                                string strD = "";
                                formula = "=";
                                string DateColumn = GetColumnName(j - 1);
                                string CompareDate = sheet.Range[DateColumn + "1"].Value;
                                strPointsPerDayFormula.Append("=");
                                string production = "";
                                string hoursperday = "";
                                for (int i = 1; i <= dtSheet.Rows.Count; i++)
                                {
                                    if (Convert.ToString(ds.Tables[k].TableName) == "Brent Vance")
                                    {
                                    }
                                    production = "";
                                    hoursperday = "";
                                    if (Convert.ToString(sheet.Range[(i + 1), j].Value) != "" && Convert.ToString(sheet.Range[(i + 1), j].Value) != "0")
                                    {
                                        //{
                                        //    sheet.Range[(i + 1), j].Value = sheet.Range[(i + 1), j].Value.Trim().ToString();
                                        //}
                                        production = GetColumnName(j - 1);
                                        hoursperday = GetColumnName(2);
                                        //if (i == dtSheet.Rows.Count)
                                        // formula = formula + "(" + production + (i + 1) + "*" + hoursperday + (i + 1) + ")";
                                        //formula = formula + "(" + production + (i + 1) + "*" + hoursperday + (i + 1) + ")";
                                        ////strPointsPerDayFormula.Append("(" + production + (i + 1) + "*" + hoursperday + (i + 1) + ")");
                                        // else
                                        formula = formula + "(" + production + (i + 1) + "*" + hoursperday + (i + 1) + ")+";
                                    }
                                }

                                formula = formula.Substring(0, formula.Length - 1);
                                attcopy = attendance.Copy();
                                try
                                {
                                    if (Convert.ToString(ds.Tables[k].TableName) == "Vincent Ford")
                                    {
                                    }
                                    int rowIndex = attcopy.Rows.IndexOf(attcopy.Select("Employee = '" + Convert.ToString(ds.Tables[k].TableName) + "' AND ProcessEndDate = '" + CompareDate + "'")[0]);
                                    strD = Convert.ToString(attcopy.Rows[rowIndex]["HoursWorked"]);
                                }
                                catch { strD = ""; }
                                attcopy = null;
                                if (formula != "")
                                    sheet.Range[RowCount + 1, j].Formula = formula;
                                else
                                    sheet.Range[RowCount + 1, j].Value = formula;
                                sheet.Range[RowCount + 1, j].Style.Color = Color.FromArgb(208, 206, 206);
                                sheet.Range[RowCount + 1, j].Style.Font.IsBold = true;
                                sheet.Range[RowCount + 2, j].Value = strD;
                                sheet.Range[RowCount + 2, j].Style.Color = Color.FromArgb(208, 206, 206);
                                sheet.Range[RowCount + 2, j].Style.Font.IsBold = true;
                                if (strD != "")
                                {
                                    string AdjustedHours = Convert.ToInt32(strD) > 9 ? "9" : strD;
                                    sheet.Range[RowCount + 3, j].Value = AdjustedHours;
                                }
                                if (sheet.Range[RowCount + 1, j].Value == "0")
                                    sheet.Range[RowCount + 1, j].Value = "";
                                sheet.Range[RowCount + 3, j].Style.Color = Color.FromArgb(208, 206, 206);
                                sheet.Range[RowCount + 3, j].Style.Font.IsBold = true;

                                string ForProd = GetColumnName(j - 1);// sheet.Range[RowCount + 1, j].Value;

                                sheet.Range[RowCount + 4, j].Value = "0";
                                sheet.Range[RowCount + 4, j].Style.Color = Color.FromArgb(208, 206, 206);
                                sheet.Range[RowCount + 4, j].Style.Font.IsBold = true;

                                if (sheet.Range[RowCount + 3, j].Value != "")
                                    sheet.Range[RowCount + 5, j].Formula = "=" + ForProd + (RowCount + 1) + "/" + ForProd + (RowCount + 3);
                                else
                                    sheet.Range[RowCount + 5, j].Value = "";
                                sheet.Range[RowCount + 5, j].Style.Color = Color.FromArgb(250, 191, 143);
                                sheet.Range[RowCount + 5, j].NumberFormat = "0%";
                                sheet.Range[RowCount + 5, j].Style.Font.IsBold = true;

                                strPointsPerDayFormula.Clear();

                            }
                            range = sheet.Range["A1:" + ColName + "1"];
                            range.Style.Borders.LineStyle = LineStyleType.Thin;
                            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                            range.Style.Color = Color.FromArgb(160, 183, 224);
                            range.Style.Font.IsBold = true;

                            range = sheet.Range["A1:" + ColName + "" + sheet.LastRow];
                            range.Style.Borders.LineStyle = LineStyleType.Thin;
                            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;

                            range = sheet.Range["B1:" + ColName + sheet.LastRow];
                            range.Style.HorizontalAlignment = HorizontalAlignType.Center;

                            string formatcol = GetColumnName(ColumnCount - 1);
                            range = sheet.Range["B2:" + formatcol + (RowCount)];
                            range.ConvertToNumber();

                            for (int row = 2; row < sheet.LastRow - 5; row++)
                            {
                                if (sheet.Range[row, 1].Value.Contains("LM - "))
                                {
                                    sheet.InsertRow(row, 1);
                                    break;
                                }
                            }

                            for (int row = 2; row < sheet.LastRow - 5; row++)
                            {
                                if (sheet.Range[row, 1].Value.Contains("Canopy - "))
                                {
                                    sheet.InsertRow(row, 1);
                                    break;
                                }
                            }

                            RowCount = sheet.LastRow;

                            sheet.Range[1, ColumnCount + 1].Value = "MTD Production";
                            sheet.Range[1, ColumnCount + 1, RowCount - 5, ColumnCount + 1].Merge();
                            sheet.Range[1, ColumnCount + 1, RowCount - 5, ColumnCount + 1].Style.HorizontalAlignment = HorizontalAlignType.Center;
                            sheet.Range[1, ColumnCount + 1, RowCount - 5, ColumnCount + 1].Style.Borders.LineStyle = LineStyleType.Thin;
                            sheet.Range[1, ColumnCount + 1, RowCount - 5, ColumnCount + 1].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                            sheet.Range[1, ColumnCount + 1, RowCount - 5, ColumnCount + 1].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                            sheet.Range[1, ColumnCount + 1, RowCount - 5, ColumnCount + 1].Style.Color = Color.FromArgb(208, 206, 206);
                            sheet.Range[1, ColumnCount + 1, RowCount - 5, ColumnCount + 1].Style.Font.IsBold = true;
                            sheet.Range[1, ColumnCount + 1, RowCount - 5, ColumnCount + 1].Style.VerticalAlignment = VerticalAlignType.Center;

                            ColName = GetColumnName(ColumnCount - 1);
                            sheet.Range[RowCount - 4, ColumnCount + 1].Formula = "=SUM(E" + (RowCount - 4) + ":" + ColName + "" + (RowCount - 4) + ")";
                            range = sheet.Range[RowCount - 4, ColumnCount + 1];
                            range.NumberFormat = "0.00";
                            range.Style.Color = Color.FromArgb(208, 206, 206);
                            ApplyFormattingFooterWithNumberFormat(range);

                            sheet.Range[RowCount - 3, ColumnCount + 1].Formula = "=SUM(E" + (RowCount - 3) + ":" + ColName + "" + (RowCount - 3) + ")";
                            range = sheet.Range[RowCount - 3, ColumnCount + 1];
                            range.Style.Color = Color.FromArgb(208, 206, 206);
                            ApplyFormattingFooterWithNumberFormat(range);

                            sheet.Range[RowCount - 2, ColumnCount + 1].Formula = "=SUM(E" + (RowCount - 2) + ":" + ColName + "" + (RowCount - 2) + ")";
                            range = sheet.Range[RowCount - 2, ColumnCount + 1];
                            range.Style.Color = Color.FromArgb(208, 206, 206);
                            ApplyFormattingFooterWithNumberFormat(range);

                            sheet.Range[RowCount - 1, ColumnCount + 1].Formula = "=SUM(E" + (RowCount - 1) + ":" + ColName + "" + (RowCount - 1) + ")";
                            range = sheet.Range[RowCount - 1, ColumnCount + 1];
                            range.Style.Color = Color.FromArgb(208, 206, 206);
                            ApplyFormattingFooterWithNumberFormat(range);

                            ColName = GetColumnName(ColumnCount);
                            sheet.Range[RowCount, ColumnCount + 1].Formula = "=" + ColName + "" + (RowCount - 4) + "/" + ColName + "" + (RowCount - 2) + "";
                            range = sheet.Range[RowCount, ColumnCount + 1];
                            range.NumberFormat = "0%";
                            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
                            range.Style.Borders.LineStyle = LineStyleType.Thin;
                            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                            range.Style.Font.IsBold = true;
                            range.Style.Color = Color.FromArgb(250, 191, 143);
                            //ApplyFormattingFooterWithNumberFormatPercentage(range);

                            range = sheet.Range[RowCount + 2, 1];
                            range.Value = "Unproductive Time Explanation";

                            sheet.Range[RowCount + 2, 1, RowCount + 2, 3].Merge();
                            ApplyFormattingFooterWithNumberFormat(sheet.Range[RowCount + 2, 1, RowCount + 2, 3]);
                            sheet.Range[RowCount + 3, 1].Value = "Date";
                            ApplyFormattingFooterWithNumberFormat(sheet.Range[RowCount + 3, 1]);
                            sheet.Range[RowCount + 3, 2].Value = "Reason";
                            ApplyFormattingFooterWithNumberFormat(sheet.Range[RowCount + 3, 2]);
                            sheet.Range[RowCount + 3, 3].Value = "Hours";
                            ApplyFormattingFooterWithNumberFormat(sheet.Range[RowCount + 3, 3]);
                            DataTable dtNon = GetEmployeeNonProductionData(ds.Tables[k].TableName, Month, Year);
                            if (dt != null)
                            {
                                sheet.InsertDataTable(dtNon, false, RowCount + 4, 1);
                            }
                            range = sheet.Range[RowCount + 2, 1, sheet.LastRow, 3];
                            range.Style.Borders.LineStyle = LineStyleType.Thin;
                            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;

                            sheet.AllocatedRange.Style.Font.FontName = "Calibri";
                            sheet.AllocatedRange.Style.Font.Size = 10;
                            sheet.AllocatedRange.AutoFitColumns();
                            sheet.AllocatedRange.AutoFitRows();


                        }

                        //Sumamry Sheet
                        #region Summary Sheet
                        string[] EmpNames = new string[book.Worksheets.Count];
                        for (int i = 0; i < book.Worksheets.Count; i++)
                        {
                            try
                            {
                                EmpNames[i] = book.Worksheets[i + 3].Name;
                            }
                            catch { }
                        }


                        sheet = book.CreateEmptySheet("Summary");
                        RowCount = 1;
                        ColumnCount = 1;

                        Worksheet sheet1 = book.Worksheets[EmpNames[0]];
                        int SCCount = sheet1.LastColumn;
                        CellRange sourceRange = sheet1.Range[1, 5, 1, SCCount];
                        CellRange DestRange = sheet.Range[1, 2, 1, SCCount - 3];
                        sheet1.Copy(sourceRange, DestRange);

                        sheet.Range[1, sheet.LastColumn].Value = "MTD Utilization";

                        CellRange range1 = sheet.Range["A1"];
                        range1.Value = "Employee";


                        for (int row = 0; row < EmpNames.Length; row++)
                        {
                            if (EmpNames[row] != null)
                            {
                                sheet.Range[row + 2, 1].Value = EmpNames[row];
                                Worksheet sourceSheet = book.Worksheets[row + 3];
                                SCCount = sourceSheet.LastColumn;
                                for (int s = 5; s <= SCCount; s++)
                                {
                                    string forColName = GetColumnName(s - 1);
                                    if (sourceSheet.Range[24, s].Value != "" && sourceSheet.Range[24, s].Value != "0")
                                    {
                                        sheet.Range[row + 2, s - 3].Formula = "='" + sourceSheet.Name + "'!" + forColName + "24/'" + sourceSheet.Name + "'!" + forColName + "26";
                                        sheet.Range[row + 2, s - 3].NumberFormat = "0%";
                                    }
                                }
                                //SCCount = book.Worksheets[row + 3].LastColumn;
                                //sourceRange = book.Worksheets[row + 3].Range[18, 5, 18, SCCount];
                                //DestRange = sheet.Range[row + 2, 2, row + 2, SCCount - 3];
                                //book.Worksheets[row + 3].Copy(sourceRange, DestRange, CopyRangeOptions.OnlyCopyFormulaValue);
                                //book.Worksheets[row + 3].CopyRow(sourceRange, sheet, row + 2, CopyRangeOptions.None);
                            }
                        }

                        CellRange range2 = sheet.Range[1, 1, 1, sheet.LastColumn];
                        range2.Style.Borders.LineStyle = LineStyleType.Thin;
                        range2.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        range2.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        range2.Style.Color = Color.FromArgb(160, 183, 224);
                        range2.Style.Font.IsBold = true;

                        range2 = sheet.Range[1, 1, sheet.LastRow, sheet.LastColumn];
                        range2.Style.Borders.LineStyle = LineStyleType.Thin;
                        range2.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        range2.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        range2.Style.HorizontalAlignment = HorizontalAlignType.Center;

                        sheet.AllocatedRange.Style.Font.FontName = "Calibri";
                        sheet.AllocatedRange.Style.Font.Size = 10;

                        sheet.AllocatedRange.AutoFitColumns();
                        sheet.AllocatedRange.AutoFitRows();


                        sheet = book.Worksheets["Summary"];
                        sheet.MoveWorksheet(3);

                        #endregion
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
            return 1;
            //book.Dispose();
        }

        public static void ApplyFormattingFooterWithNumberFormat(CellRange range)
        {

            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Color = Color.FromArgb(208, 206, 206);
            range.Style.Font.IsBold = true;
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.NumberFormat = "0";
        }

        public static void ApplyFormattingFooterWithNumberFormatPercentage(CellRange range)
        {

            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Color = Color.FromArgb(174, 170, 170);
            range.Style.Font.IsBold = true;
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.NumberFormat = "0%";
        }

       
    }
}