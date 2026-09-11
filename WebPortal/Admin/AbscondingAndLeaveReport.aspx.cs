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


        //Arti Changes

        [WebMethod]
        public static string GetYearWiseTotalLeaves(string Year)
        {
            DataTable dt1 = new bllMaster().GetYearWiseTotalLeaves(Year);
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
        public static string GetYearWiseAbscondingEmployees(string Year)
        {
            DataTable dt1 = new bllMaster().GetYearWiseAbscondingEmployees(Year);
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
        public static string GetYearWiseTotalLeavesSummary(string Year)
        {
            DataSet ds = new bllMaster().GetYearWiseTotalLeavesSummary(Year);

            var allTablesData = new List<List<Dictionary<string, object>>>();

            foreach (DataTable dt in ds.Tables)
            {
                Dictionary<string, Dictionary<string, object>> tableMap = new Dictionary<string, Dictionary<string, object>>();

                foreach (DataRow dr in dt.Rows)
                {
                    string rowKey = dr[0].ToString();
                    string monthName = dr["LeaveMonth"].ToString();

                    if (!tableMap.ContainsKey(rowKey))
                    {
                        tableMap[rowKey] = new Dictionary<string, object>();
                        tableMap[rowKey]["RowName"] = rowKey;
                    }

                    tableMap[rowKey][monthName + "_EmployeeCount"] = dr[2];
                    tableMap[rowKey][monthName + "_ForDays"] = dr[3];
                }

                allTablesData.Add(new List<Dictionary<string, object>>(tableMap.Values));
            }

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(allTablesData);
        }

        [WebMethod]
        public static string GetYearWiseAbscondingEmployeesSummary(string Year)
        {
            DataSet ds = new bllMaster().GetYearWiseAbscondingEmployeesSummary(Year);

            var allTablesData = new List<List<Dictionary<string, object>>>();

            for (int t = 0; t < ds.Tables.Count; t++)
            {
                DataTable dt = ds.Tables[t];
                Dictionary<string, Dictionary<string, object>> tableMap = new Dictionary<string, Dictionary<string, object>>();

                foreach (DataRow dr in dt.Rows)
                {
                    string rowKey = dr[0].ToString();

                    if (t == 2)
                    {
                        string monthName = dr["Month"].ToString();
                        string locationName = dr["Location"].ToString();
                        string dynamicKey = monthName + "_" + locationName + "_AbscondingCount";

                        if (!tableMap.ContainsKey(rowKey))
                        {
                            tableMap[rowKey] = new Dictionary<string, object>();
                            tableMap[rowKey]["RowName"] = rowKey;
                        }
                        tableMap[rowKey][dynamicKey] = dr["AbscondingCount"];
                    }
                    else
                    {
                        string monthName = dr["Month"].ToString();
                        if (!tableMap.ContainsKey(rowKey))
                        {
                            tableMap[rowKey] = new Dictionary<string, object>();
                            tableMap[rowKey]["RowName"] = rowKey;
                        }
                        tableMap[rowKey][monthName + "_AbscondingCount"] = dr["AbscondingCount"];
                    }
                }

                allTablesData.Add(new List<Dictionary<string, object>>(tableMap.Values));
            }

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(allTablesData);
        }

        static string GetColumnName(int index)
        {
            // Jar index 1-based asel (1 = A, 2 = B...) tr hya formula madhe 1 kami kara:
            index = index - 1;

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

        protected void btn1_Click(object sender, EventArgs e)
        {
            string Month = Convert.ToString(Request.Form["ableave_month"]);
            string Year = Convert.ToString(Request.Form["ableave_year"]);
            Year = Year.Replace(",", "");

            FileName = Server.MapPath(@"~\ReportDocument\Absconding_And_Leaves_Report_" + Convert.ToString(Month) + "-" + Convert.ToString(Year) + DateTime.Now.ToString("hhmmss") + ".xlsx");

            FormatExcel_Core(FileName, Month, Year);

            Response.Clear();
            Response.Buffer = false;
            Response.AppendHeader("Content-Type", "application/xlsx");
            Response.AppendHeader("Content-Transfer-Encoding", "binary");
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(FileName));
            using (var workbook = new ClosedXML.Excel.XLWorkbook(FileName))
            {
                var evalSheet = workbook.Worksheets.FirstOrDefault(w => w.Name.IndexOf("Evaluation", StringComparison.OrdinalIgnoreCase) >= 0);

                if (evalSheet != null)
                {
                    workbook.Worksheets.Delete(evalSheet.Name);
                    workbook.Save();
                }
            }
            Response.TransmitFile(FileName);
            Response.End();
        }
        public void FormatExcel_Core(string FileName, string Month, string Year)
        {
            Workbook book = new Workbook();
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";

            book.Worksheets.Clear();

            Worksheet sheetAbsDetails = book.Worksheets.Add("Absconding Details");
            Worksheet sheetAbsSummary = book.Worksheets.Add("Absconding Summary");
            Worksheet sheetLeaveDetails = book.Worksheets.Add("Leave Details");
            Worksheet sheetLeaveSummary = book.Worksheets.Add("Leave Summary");

            int mainrowcount = 0;

            #region 1. Absconding Data & Summary
            DataTable dt = new bllMaster().GetTotalAbscondingEmployees(Month, Year);
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Columns.Contains("EmployeeID"))
                    dt.Columns.Remove("EmployeeID");

                sheetAbsDetails.InsertDataTable(dt, true, 1, 1);

                string Col = GetColumnName(dt.Columns.Count);

                CellRange range = sheetAbsDetails.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheetAbsDetails.Range["A1:" + Col + (dt.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);

                mainrowcount = sheetAbsDetails.LastRow;

                sheetAbsDetails.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheetAbsDetails.AllocatedRange.Style.Font.Size = 10;
                sheetAbsDetails.AllocatedRange.AutoFitColumns();
                sheetAbsDetails.AllocatedRange.AutoFitRows();

                // Absconding Summary (Pivot Tables)
                #region Domain wise
                CellRange dataRange = sheetAbsDetails.Range["A1:" + Col + mainrowcount];
                PivotCache cache = book.PivotCaches.Add(dataRange);
                PivotTable pt = sheetAbsSummary.PivotTables.Add("Domain", sheetAbsSummary.Range["A1"], cache);

                var rField = pt.PivotFields["Domain"];
                rField.Axis = AxisTypes.Row;
                pt.Options.RowHeaderCaption = "Domain";
                pt.DataFields.Add(pt.PivotFields["Code"], "Employee Count", SubtotalTypes.Count);
                pt.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                pt.CalculateData();
                #endregion

                int rowcount = sheetAbsSummary.LastRow + 2;

                #region Location wise
                pt = sheetAbsSummary.PivotTables.Add("Branch", sheetAbsSummary.Range["A" + rowcount], cache);
                rField = pt.PivotFields["Branch"];
                rField.Axis = AxisTypes.Row;
                pt.Options.RowHeaderCaption = "Location";
                pt.DataFields.Add(pt.PivotFields["Code"], "Employee Count", SubtotalTypes.Count);
                pt.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                pt.CalculateData();
                #endregion

                sheetAbsSummary.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheetAbsSummary.AllocatedRange.Style.Font.Size = 10;
                sheetAbsSummary.AllocatedRange.AutoFitColumns();
                sheetAbsSummary.AllocatedRange.AutoFitRows();
            }
            #endregion

            #region 2. Leave Data & Summary
            DataSet ds = new bllMaster().GetTotalLeaves_Revised(Month, Year);
            if (ds != null && ds.Tables.Count > 0)
            {
                DataTable dt1 = ds.Tables[0];
                if (dt1 != null && dt1.Rows.Count > 0)
                {
                    sheetLeaveDetails.InsertDataTable(dt1, true, 1, 1);
                    string ColLeave = GetColumnName(dt1.Columns.Count);

                    CellRange range = sheetLeaveDetails.Range["A1:" + ColLeave + "1"];
                    HeaderFormat(range);
                    range = sheetLeaveDetails.Range["A1:" + ColLeave + (dt1.Rows.Count + 1)];
                    AllBorder(range);
                    ContentCenter(range);

                    int leaveMainRow = sheetLeaveDetails.LastRow;

                    sheetLeaveDetails.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheetLeaveDetails.AllocatedRange.Style.Font.Size = 10;
                    sheetLeaveDetails.AllocatedRange.AutoFitColumns();
                    sheetLeaveDetails.AllocatedRange.AutoFitRows();

                    // Leave Summary (Pivot Tables)
                    #region Leave Domain wise
                    CellRange leaveDataRange = sheetLeaveDetails.Range["A1:" + ColLeave + leaveMainRow];
                    PivotCache leaveCache = book.PivotCaches.Add(leaveDataRange);
                    PivotTable ptLeave = sheetLeaveSummary.PivotTables.Add("Domain", sheetLeaveSummary.Range["A1"], leaveCache);

                    var leaveField = ptLeave.PivotFields["Domain"];
                    leaveField.Axis = AxisTypes.Row;
                    ptLeave.Options.RowHeaderCaption = "Domain";
                    ptLeave.DataFields.Add(ptLeave.PivotFields["Code"], "Employee Count", SubtotalTypes.Count);
                    ptLeave.DataFields.Add(ptLeave.PivotFields["ForDays"], "For Days", SubtotalTypes.Sum);
                    ptLeave.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptLeave.CalculateData();
                    #endregion

                    int leaveRowcount = sheetLeaveSummary.LastRow + 2;

                    #region Leave Location wise
                    ptLeave = sheetLeaveSummary.PivotTables.Add("Branch", sheetLeaveSummary.Range["A" + leaveRowcount], leaveCache);
                    leaveField = ptLeave.PivotFields["Branch"];
                    leaveField.Axis = AxisTypes.Row;
                    ptLeave.Options.RowHeaderCaption = "Location";
                    ptLeave.DataFields.Add(ptLeave.PivotFields["Code"], "Employee Count", SubtotalTypes.Count);
                    ptLeave.DataFields.Add(ptLeave.PivotFields["ForDays"], "For Days", SubtotalTypes.Sum);
                    ptLeave.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptLeave.CalculateData();
                    #endregion

                    sheetLeaveSummary.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheetLeaveSummary.AllocatedRange.Style.Font.Size = 10;
                    sheetLeaveSummary.AllocatedRange.AutoFitColumns();
                    sheetLeaveSummary.AllocatedRange.AutoFitRows();
                }
            }
            #endregion

            if (File.Exists(FileName))
            {
                try { File.Delete(FileName); } catch { }
            }

            book.SaveToFile(FileName, ExcelVersion.Version2010);

        }
    }
}