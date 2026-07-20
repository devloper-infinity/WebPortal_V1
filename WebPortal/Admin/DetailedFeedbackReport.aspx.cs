using ClosedXML.Excel;
using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.ExtendedProperties;
using Spire.Xls;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class DetailedFeedbackReport : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string FileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static Workbook book = new Workbook();
        static Worksheet wksheet = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TruncateFeedbackImporttable");
                SQLHelper.ExecuteScalarCmd(cmd);
            }
            catch { }
            FolderPath = Server.MapPath(@"~\ReportDocument");
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


                string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
            }
            catch { }
        }

        static void releaseObject(object obj)
        {
            try
            {
                System.Runtime.InteropServices.Marshal.ReleaseComObject(obj);
                obj = null;
            }
            catch (Exception ex)
            {
                obj = null;
                throw ex;

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

        public static void HeaderFormat_Static(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Color = Color.FromArgb(113, 147, 209);
            range.Style.Font.Color = Color.White;
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.IsBold = true;
            range.Style.Font.FontName = "Aptos Narrow";
        }

        public static void HeaderFormat_Static_Green(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Color = Color.FromArgb(226, 240, 217);
            range.Style.Font.Color = Color.Black;
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            //range.Style.Font.IsBold = true;
            range.Style.Font.FontName = "Aptos Narrow";
        }
        public static void HeaderFormat_Static_Yellow(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Color = Color.FromArgb(255, 242, 204);
            range.Style.Font.Color = Color.Black;
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            //range.Style.Font.IsBold = true;
            range.Style.Font.FontName = "Aptos Narrow";
        }

        public static void HeaderFormat_Static_Red(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Color = Color.FromArgb(252, 228, 214);
            range.Style.Font.Color = Color.Black;
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            //range.Style.Font.IsBold = true;
            range.Style.Font.FontName = "Aptos Narrow";
        }

        public static void AllBorder_Static(CellRange range)
        {
            //try
            //{
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Font.FontName = "Aptos Narrow";
            //}
            //catch { }
        }

        public static void ContentCenter_Static(CellRange range)
        {
            //try
            //{
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.FontName = "Aptos Narrow";
            //}
            //catch { }
        }

        #region Old Code
        public static DataTable ReadExcelFile(string path)
        {
            DataTable dt = new DataTable();

            using (var workbook = new XLWorkbook(path))
            {
                var ws = workbook.Worksheet(1);
                var range = ws.RangeUsed();
                bool firstRow = true;

                foreach (var row in range.Rows())
                {
                    if (firstRow)
                    {
                        foreach (var cell in row.Cells())
                            dt.Columns.Add(cell.Value.ToString());
                        firstRow = false;
                    }
                    else
                    {
                        //dt.Rows.Add(row.Cells().Select(c => c.Value).ToArray());
                        dt.Rows.Add(row.Cells().Select(c => c.GetValue<string>() ?? "").ToArray());
                    }
                }
            }

            return dt;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
        public static int ImportExcel()
        {
            DataTable dtSheet = new DataTable();
            string SheetName = "";
            string StrSource = "C:\\AMS";

            if (NewFileName != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }

                FileName = FolderPath + "\\" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);
                File.Copy(NewFileName, FileName);
                string Extn = NewFileName.Substring(NewFileName.LastIndexOf(".") + 1);
                DataTable Dt = new DataTable();
                Dt = ReadExcelFile(FileName);
                DataView dw = Dt.DefaultView;
                dw.RowFilter = "[Loan Number] is not null";
                DataTable dtResult = dw.ToTable();
                if (Dt != null)
                {
                    string con = "";
                    SqlConnection sqlConnection = new SqlConnection();
                    sqlConnection.ConnectionString = "Data Source=23.111.175.186;Initial Catalog=InfinityERP;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=100; Connect Timeout=200; Packet Size=8192";
                    //assigning Destination table name
                    sqlConnection.Open();
                    using (SqlBulkCopy objbulk = new SqlBulkCopy(sqlConnection, SqlBulkCopyOptions.TableLock | SqlBulkCopyOptions.FireTriggers, null))
                    {
                        objbulk.DestinationTableName = "dbo.FeedbackImport";


                        objbulk.BulkCopyTimeout = 0;

                        objbulk.BatchSize = 5000;     // Commit 5k rows at a time
                        objbulk.NotifyAfter = 5000;

                        // Get destination structure
                        DataTable dtDest = new DataTable();
                        using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 * FROM dbo.FeedbackImport", sqlConnection))
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dtDest);
                        }

                        // Add column mappings
                        foreach (DataColumn col in dtDest.Columns)
                        {
                            if (dtResult.Columns.Contains(col.ColumnName))
                            {
                                objbulk.ColumnMappings.Add(col.ColumnName, col.ColumnName);
                            }
                        }

                        // 🚀 Bulk Upload
                        objbulk.WriteToServer(dtResult);
                    }
                    if (sqlConnection.State == ConnectionState.Open)
                        sqlConnection.Close();

                }
                // }
            }
            return 1;
        }

        [WebMethod]
        public static string ValidateExcelSheet()
        {
            DataTable dt = null;
            dt = new bllReport().ValidateQualityReportExcel();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
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
        public static int getWeeklyGraphicalView(string Type)
        {
            book.Version = ExcelVersion.Version2016;
            DataTable dt = null;
            if (Type == "QC Date")
                dt = new bllReport().WeeklyGraphicalView_QCDate();
            else
                dt = new bllReport().WeeklyGraphicalView_QCDate();

            wksheet = book.CreateEmptySheet("Weekly - Graphical View");
            int RCount = 1;
            int CCount = 1;
            DataRow dr1 = dt.NewRow();
            dr1[0] = "Average";
            //int TotalVolume1 = dt.AsEnumerable().Sum(row => row.Field<int>("Loan Qced"));
            decimal TotalVolume1 = (decimal)dt.Compute("Avg([Loan Qced])", "");
            decimal TotalCritical1 = (decimal)dt.Compute("Avg([NC/Loan-Internal])", "");
            decimal TotalNCritical1 = (decimal)dt.Compute("Avg([C/Loan-Internal])", "");
            decimal TotalCriticalReQC = (decimal)dt.Compute("Avg([NC/Loan-ReQC])", "");
            decimal TotalNCriticalReQC = (decimal)dt.Compute("Avg([C/Loan-ReQC])", "");
            decimal TotalCriticalClient = (decimal)dt.Compute("Avg([Non-Critical Errors-Client])", "");
            decimal TotalNCriticalClient = (decimal)dt.Compute("Avg([Critical Errors-Client])", "");
            decimal TotalCriticalAll = (decimal)dt.Compute("Avg([Total Critical])", "");
            decimal TotalNonCriticalAll = (decimal)dt.Compute("Avg([Total non Critical])", "");
            decimal NoErrorFiles = (decimal)dt.Compute("Avg([No Error Files])", "");
            decimal Erros1 = (decimal)dt.Compute("Avg([Error/Loan])", "");
            decimal PercNoErrorFiles = (decimal)dt.Compute("Avg([% No Error Files])", "");
            dr1[1] = Math.Round(TotalVolume1, 0).ToString();
            dr1[2] = Math.Round(TotalCritical1, 1).ToString();
            dr1[3] = Math.Round(TotalNCritical1, 1).ToString();
            dr1[4] = Math.Round(TotalCriticalReQC, 3).ToString();
            dr1[5] = Math.Round(TotalNCriticalReQC, 3).ToString();
            dr1[6] = Math.Round(TotalNCriticalClient, 3).ToString();
            dr1[7] = Math.Round(TotalNCriticalClient, 3).ToString();
            dr1[8] = Math.Round(TotalCriticalAll, 1).ToString();
            dr1[9] = Math.Round(TotalNonCriticalAll, 1).ToString();
            dr1[10] = Math.Round(Erros1, 1).ToString();
            dr1[11] = Math.Round(NoErrorFiles, 1).ToString();
            dr1[12] = Math.Round(PercNoErrorFiles, 1).ToString();
            dt.Rows.Add(dr1);
            dt.AcceptChanges();

            wksheet.InsertDataTable(dt, true, 2, 1);
            RCount = wksheet.LastRow;
            CCount = wksheet.LastColumn;

            wksheet.Range[1, 3].Value = "Internal";
            wksheet.Range[1, 3, 1, 4].Merge();
            HeaderFormat_Static(wksheet.Range[1, 3, 1, 4]);

            wksheet.Range[1, 5].Value = "ReQC";
            wksheet.Range[1, 5, 1, 6].Merge();
            HeaderFormat_Static(wksheet.Range[1, 5, 1, 6]);

            wksheet.Range[1, 7].Value = "Client";
            wksheet.Range[1, 7, 1, 8].Merge();
            HeaderFormat_Static(wksheet.Range[1, 7, 1, 8]);

            wksheet.Range[1, 9].Value = "Total";
            wksheet.Range[1, 9, 1, 10].Merge();
            HeaderFormat_Static(wksheet.Range[1, 9, 1, 10]);

            string CName1 = GetColumnName(CCount - 1);

            CellRange range12 = wksheet.Range["A" + Convert.ToString(dt.Rows.Count + 2) + ":" + CName1 + Convert.ToString(dt.Rows.Count + 2)];
            HeaderFormat_Static(range12);

            range12 = wksheet.Range["A2:" + CName1 + "2"];
            HeaderFormat_Static(range12);

            wksheet.Range["C2:C2"].Value = "Non-Critical";
            wksheet.Range["D2:D2"].Value = "Critical";
            wksheet.Range["E2:E2"].Value = "Non-Critical";
            wksheet.Range["F2:F2"].Value = "Critical";
            wksheet.Range["G2:G2"].Value = "Non-Critical";
            wksheet.Range["H2:H2"].Value = "Critical";
            wksheet.Range["I2:I2"].Value = "Non-Critical";
            wksheet.Range["J2:J2"].Value = "Critical";

            Chart chart1 = wksheet.Charts.Add(ExcelChartType.ColumnClustered);
            wksheet.Range.IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
            wksheet.Range.NumberFormat = "0.0";
            wksheet.Range["B3:B" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
            wksheet.Range["B3:B" + RCount].NumberFormat = "0";
            wksheet.Range["L3:L" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
            wksheet.Range["L3:L" + RCount].NumberFormat = "0";
            wksheet.Range["K3:K" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
            wksheet.Range["K3:K" + RCount].NumberFormat = "0.0";
            wksheet.Range["E3:H" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
            wksheet.Range["E3:H" + RCount].NumberFormat = "0.00";


            CName1 = GetColumnName(CCount - 1);
            range12 = wksheet.Range[CName1 + "3:" + CName1 + Convert.ToString(dt.Rows.Count + 2)];
            wksheet.Range.IgnoreErrorOptions = IgnoreErrorType.NumberAsText;

            for (int i = 1; i <= dt.Rows.Count; i++)
            {
                wksheet.Range["M" + (i + 2)].NumberFormat = "0";
                wksheet.Range["M" + (i + 2)].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range["M" + (i + 2)].Value = wksheet.Range["M" + (i + 2)].Value + "%";
            }
            wksheet.Range["M" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
            wksheet.Range["M" + RCount].NumberFormat = "0";

            for (int i = 3; i <= RCount; i++)
            {
                wksheet.Range["K" + (i)].Formula = "=SUM(C" + (i) + ":H" + (i) + ")";
            }
            wksheet.Range["K" + (dt.Rows.Count + 2)].Formula = "=AVERAGE(K3:K" + (dt.Rows.Count + 1) + ")";

            chart1.SeriesDataFromRange = false;
            //Chart border  
            chart1.ChartArea.Border.Weight = ChartLineWeightType.Medium;
            chart1.ChartArea.Border.Color = Color.SandyBrown;
            //Chart position  
            chart1.LeftColumn = CCount + 2;
            chart1.TopRow = 2;
            chart1.RightColumn = CCount + 13;
            chart1.BottomRow = RCount + 10;
            //Chart title  
            chart1.ChartTitle = "Weekly Volume and Error Analysis";
            chart1.ChartTitleArea.Font.FontName = "Aptos Narrow";
            chart1.ChartTitleArea.Font.Size = 11;
            chart1.ChartTitleArea.Font.IsBold = true;
            //Chart axis  
            chart1.PrimaryCategoryAxis.Title = "Week";
            chart1.PrimaryCategoryAxis.Font.Color = Color.Blue;
            chart1.PrimaryValueAxis.Title = "Volume";
            chart1.SecondaryValueAxisTitle = "Error/Loan";

            chart1.PrimaryValueAxis.HasMajorGridLines = false;
            //chart.PrimaryValueAxis.MaxValue = 100;
            chart1.PrimaryValueAxis.TitleArea.TextRotationAngle = 90;

            var cs11 = chart1.Series.Add("Volume", ExcelChartType.ColumnClustered);
            cs11.Values = wksheet.Range["B3:B" + Convert.ToString(RCount - 1)];
            wksheet.Range["B3:B" + Convert.ToString(RCount - 1)].ConvertToNumber();

            var cs21 = chart1.Series.Add("C/Loan", ExcelChartType.ScatterLineMarkers);
            cs21.Values = wksheet.Range["D3:D" + Convert.ToString(RCount - 1)];
            wksheet.Range["D3:D" + Convert.ToString(RCount - 1)].ConvertToNumber();

            var cs31 = chart1.Series.Add("NC/Loan", ExcelChartType.ScatterLineMarkers);
            cs31.Values = wksheet.Range["C3:C" + Convert.ToString(RCount - 1)];
            wksheet.Range["C3:C" + Convert.ToString(RCount - 1)].ConvertToNumber();

            var cs41 = chart1.Series.Add("Error/Loan", ExcelChartType.ScatterLineMarkers);
            cs41.Values = wksheet.Range["K3:K" + Convert.ToString(RCount - 1)];
            wksheet.Range["K3:K" + Convert.ToString(RCount - 1)].ConvertToNumber();

            cs21.UsePrimaryAxis = false;
            cs31.UsePrimaryAxis = false;
            cs41.UsePrimaryAxis = false;

            foreach (Spire.Xls.Charts.ChartSerie cs in chart1.Series)
            {
                cs.CategoryLabels = wksheet.Range["A3:A" + Convert.ToString(RCount - 1)];
                cs.DataPoints.DefaultDataPoint.DataLabels.HasValue = true;
            }
            chart1.Legend.Position = LegendPositionType.Bottom;

            wksheet.AllocatedRange.Style.HorizontalAlignment = HorizontalAlignType.Center;
            wksheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            wksheet.AllocatedRange.Style.Font.Size = 10;

            chart1 = null;
            wksheet.AllocatedRange.AutoFitColumns();
            wksheet.AllocatedRange.AutoFitRows();

            return 1;
        }

        [WebMethod]
        public static int ClientwiseErrorTrending1(string Type)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (Type == "QC Date")
                dt = new bllReport().ClientwiseErrorTrending_QCDate();
            else
                dt = new bllReport().ClientwiseErrorTrending_QCDate();

            wksheet = book.CreateEmptySheet("Client-wise Error Trending");
            wksheet.InsertDataTable(dt, true, 4, CCount);
            RCount = wksheet.LastRow;
            CCount = wksheet.LastColumn;

            int HCount = 3;
            while (HCount < CCount)
            {
                string hColName = GetColumnName(HCount - 1);
                wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "4"].Value.Replace("-Loan Count", "");
                wksheet.Range[1, HCount, 1, HCount + 11].Merge();
                HCount = HCount + 12;
                wksheet.Range[1, HCount + 11].Style.Borders[BordersLineType.EdgeRight].LineStyle = LineStyleType.Thick;
                wksheet.Range[1, HCount + 11].Style.Borders[BordersLineType.EdgeRight].Color = Color.Black;
            }
            wksheet.Range["A1:A1"].Value = "Sr. #";
            wksheet.Range["A1:A4"].Merge();
            wksheet.Range["B1:B4"].Merge();

            string[] InternalReqc = { "Internal", "ReQC" };

            HCount = 4;
            while (HCount < CCount)
            {
                string hColName = GetColumnName(HCount - 1);
                wksheet.Range[2, HCount].Value = InternalReqc[0];
                wksheet.Range[2, HCount, 2, HCount + 3].Merge();
                HCount = HCount + 4;
                wksheet.Range[2, HCount].Value = InternalReqc[1];
                wksheet.Range[2, HCount, 2, HCount + 3].Merge();
                wksheet.Range[2, HCount + 3].Style.Borders[BordersLineType.EdgeRight].LineStyle = LineStyleType.Thick;
                wksheet.Range[2, HCount + 3].Style.Borders[BordersLineType.EdgeRight].Color = Color.Black;
                HCount = HCount + 8;
            }
            HCount = 4;
            while (HCount < CCount)
            {
                string hColName = GetColumnName(HCount - 1);
                wksheet.Range[3, HCount].Value = "Error Count";
                wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                HCount = HCount + 2;
                wksheet.Range[3, HCount].Value = "Error/Loan";
                wksheet.Range[3, HCount, 3, HCount + 1].Merge();

                HCount = HCount + 2;
                hColName = GetColumnName(HCount - 1);
                wksheet.Range[3, HCount].Value = "Error Count";
                wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                HCount = HCount + 2;
                wksheet.Range[3, HCount].Value = "Error/Loan";
                wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                HCount = HCount + 2;
                wksheet.Range[2, HCount].Value = "Total";
                wksheet.Range[2, HCount, 3, HCount + 1].Merge();

                HCount = HCount + 4;
            }
            HCount = 3;
            HCount = 3;
            while (HCount < CCount)
            {
                wksheet.Range[2, HCount].Value = "Loan Count";
                wksheet.Range[2, HCount, 4, HCount].Merge();
                wksheet.Range[4, HCount + 1].Value = "Critical";
                wksheet.Range[4, HCount + 2].Value = "Non-Critical";
                wksheet.Range[4, HCount + 3].Value = "Critical";
                wksheet.Range[4, HCount + 4].Value = "Non-Critical";
                wksheet.Range[4, HCount + 5].Value = "Critical";
                wksheet.Range[4, HCount + 6].Value = "Non-Critical";
                wksheet.Range[4, HCount + 7].Value = "Critical";
                wksheet.Range[4, HCount + 8].Value = "Non-Critical";
                wksheet.Range[4, HCount + 9].Value = "Critical";
                wksheet.Range[4, HCount + 10].Value = "Non-Critical";
                wksheet.Range[2, HCount + 11].Value = "% No Error Files";

                wksheet.Range[2, HCount + 11, 4, HCount + 11].Merge();
                wksheet.Range[4, HCount + 1].Style.Borders[BordersLineType.EdgeRight].LineStyle = LineStyleType.Thick;
                wksheet.Range[4, HCount + 1].Style.Borders[BordersLineType.EdgeRight].Color = Color.Black;
                HCount = HCount + 12;
            }

            HCount = 14;
            while (HCount < CCount)
            {
                for (int i = 5; i < RCount + 1; i++)
                {
                    wksheet.Range[i, HCount].Value = wksheet.Range[i, HCount].Value + "%";
                    wksheet.Range[i, HCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    wksheet.Range[i, HCount].NumberFormat = "0";
                }
                HCount = HCount + 12;
            }

            for (int i = 5; i < RCount + 1; i++)
            {
                wksheet.Range[i, CCount].Value = wksheet.Range[i, HCount].Value + "%";
                wksheet.Range[i, CCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range[i, CCount].NumberFormat = "0";
            }

            string RevColName = GetColumnName(CCount - 1);

            HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "4"]);
            AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt.Rows.Count + 4)]);

            wksheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            wksheet.AllocatedRange.Style.HorizontalAlignment = HorizontalAlignType.Center;
            wksheet.AllocatedRange.Style.Font.Size = 10;
            wksheet.Range["A4:" + RevColName + "4"].AutoFitRows();

            wksheet.HideColumn(1);

            //wksheet.AllocatedRange.AutoFitColumns();
            //wksheet.AllocatedRange.AutoFitRows();

            return 1;
        }

        [WebMethod]
        public static int ReviewerFeedbackSummary1(string Type)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (Type == "QC Date")
                dt = new bllReport().ReviewerwiseErrorTrending_QCDate();
            else
                dt = new bllReport().ReviewerwiseErrorTrending_QCDate();

            wksheet = book.CreateEmptySheet("Reviewer - Feedback Summary");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 4, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                #region Commented
                string hColName = "";
                int HCount = 5;
                while (HCount < CCount)
                {
                    hColName = GetColumnName(HCount - 1);
                    wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "4"].Value.Replace("-Loan Count", "");
                    wksheet.Range[1, HCount, 1, HCount + 11].Merge();
                    HCount = HCount + 12;
                }
                wksheet.Range["A1:A1"].Value = "Sr. #";
                wksheet.Range["A1:A4"].Merge();
                wksheet.Range["B1:B4"].Merge();
                wksheet.Range["C1:C4"].Merge();
                wksheet.Range["D1:D4"].Merge();

                string[] InternalReqc = { "Internal", "ReQC" };

                HCount = 6;
                while (HCount < CCount)
                {
                    hColName = GetColumnName(HCount - 1);
                    wksheet.Range[2, HCount].Value = InternalReqc[0];
                    wksheet.Range[2, HCount, 2, HCount + 3].Merge();
                    HCount = HCount + 4;
                    wksheet.Range[2, HCount].Value = InternalReqc[1];
                    wksheet.Range[2, HCount, 2, HCount + 3].Merge();
                    HCount = HCount + 8;
                }
                HCount = 6;
                while (HCount < CCount)
                {
                    hColName = GetColumnName(HCount - 1);
                    wksheet.Range[3, HCount].Value = "Error Count";
                    wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[3, HCount].Value = "Error/Loan";
                    wksheet.Range[3, HCount, 3, HCount + 1].Merge();

                    HCount = HCount + 2;
                    hColName = GetColumnName(HCount - 1);
                    wksheet.Range[3, HCount].Value = "Error Count";
                    wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[3, HCount].Value = "Error/Loan";
                    wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[2, HCount].Value = "Total";
                    wksheet.Range[2, HCount, 3, HCount + 1].Merge();


                    //wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Internal-Critical", "");
                    //wksheet.Range[1, HCount, 1, HCount + 3].Merge();
                    HCount = HCount + 4;
                }
                HCount = 5;
                while (HCount < CCount)
                {
                    wksheet.Range[2, HCount].Value = "Loan Count";
                    wksheet.Range[2, HCount, 4, HCount].Merge();
                    wksheet.Range[4, HCount + 1].Value = "Critical";
                    wksheet.Range[4, HCount + 2].Value = "Non-Critical";
                    wksheet.Range[4, HCount + 3].Value = "Critical";
                    wksheet.Range[4, HCount + 4].Value = "Non-Critical";
                    wksheet.Range[4, HCount + 5].Value = "Critical";
                    wksheet.Range[4, HCount + 6].Value = "Non-Critical";
                    wksheet.Range[4, HCount + 7].Value = "Critical";
                    wksheet.Range[4, HCount + 8].Value = "Non-Critical";
                    wksheet.Range[4, HCount + 9].Value = "Critical";
                    wksheet.Range[4, HCount + 10].Value = "Non-Critical";
                    wksheet.Range[2, HCount + 11].Value = "% No Error Files";
                    wksheet.Range[2, HCount + 11, 4, HCount + 11].Merge();
                    HCount = HCount + 12;
                }
                #endregion

                HCount = 16;
                while (HCount < CCount)
                {
                    for (int i = 5; i < RCount + 1; i++)
                    {
                        wksheet.Range[i, HCount].Value = wksheet.Range[i, HCount].Value + "%";
                        wksheet.Range[i, HCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                        wksheet.Range[i, HCount].NumberFormat = "0";
                    }
                    HCount = HCount + 12;
                }

                for (int i = 5; i < RCount + 1; i++)
                {
                    wksheet.Range[i, CCount].Value = wksheet.Range[i, HCount].Value + "%";
                    wksheet.Range[i, CCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    wksheet.Range[i, CCount].NumberFormat = "0";
                }
                string RevColName = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "4"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt.Rows.Count + 4)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.Range["A4:" + RevColName + "4"].AutoFitRows();
                wksheet.HideColumn(1);

            }




            return 1;
        }

        [WebMethod]
        public static int ReviewerVsQcerErrorCount1(string Type)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (Type == "QC Date")
                dt = new bllReport().ReviewVsQCCount_QCDate();
            else
                dt = new bllReport().ReviewVsQCCount_QCDate();

            wksheet = book.CreateEmptySheet("Reviewer Vs Qcer Error Count");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

            }

            return 1;
        }

        [WebMethod]
        public static int NoErrorFileAnalysis1(string Type)
        {
            DataSet ds = null;
            int RCount = 1;
            int CCount = 1;
            if (Type == "QC Date")
                ds = new bllReport().GetNoErrorFileAnalysis_QCDate();
            else
                ds = new bllReport().GetNoErrorFileAnalysis_QCDate();
            wksheet = book.CreateEmptySheet("No Error Files Analysis");

            if (ds != null)
            {
                #region Category
                DataTable dt = ds.Tables[0];
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName = GetColumnName(CCount - 1);

                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt.Rows.Count + 2)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                #endregion

            }
            return 1;
        }

        [WebMethod]
        public static int Reviewerwiseclientwiseerror1(string Type)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (Type == "QC Date")
                dt = new bllReport().Reviewerwiseclientwiseerror_QCDate();
            else
                dt = new bllReport().Reviewerwiseclientwiseerror_QCDate();

            wksheet = book.CreateEmptySheet("Reviewer wise client wise error");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
                wksheet.HideColumn(1);
            }
            return 1;
        }

        [WebMethod]
        public static int ReviewerQCClientwiseerror1(string Type)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (Type == "QC Date")
                dt = new bllReport().Reviewerwiseqcwiseclientwiseerror_QCDate();
            else
                dt = new bllReport().Reviewerwiseqcwiseclientwiseerror_QCDate();

            wksheet = book.CreateEmptySheet("Reviewer, QC, Client wise error");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
                wksheet.HideColumn(1);

            }
            return 1;
        }

        [WebMethod]
        public static int QCerPerformance_Old(string Type)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (Type == "QC Date")
                dt = new bllReport().WeeklyQCerDetails_QCDate();
            else
                dt = new bllReport().WeeklyQCerDetails_QCDate();

            wksheet = book.CreateEmptySheet("QCer Performance");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 3, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                int HCount = 3;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "3"].Value.Replace("-File Qced", "");
                    wksheet.Range[1, HCount, 1, HCount + 8].Merge();
                    //wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Internal-Critical", "");
                    //wksheet.Range[1, HCount, 1, HCount + 3].Merge();
                    HCount = HCount + 9;
                }
                HCount = 5;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[2, HCount].Value = "ReQC";
                    wksheet.Range[2, HCount, 2, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[2, HCount].Value = "Client";
                    wksheet.Range[2, HCount, 2, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[2, HCount].Value = "Total";
                    wksheet.Range[2, HCount, 2, HCount + 1].Merge();
                    //wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Internal-Critical", "");
                    //wksheet.Range[1, HCount, 1, HCount + 3].Merge();
                    HCount = HCount + 7;
                }

                wksheet.Range["A1:A1"].Value = "Sr. #";
                wksheet.Range["A1:A3"].Merge();
                wksheet.Range["B1:B3"].Merge();

                string[] InternalReqc = { "File Qced", "Incorrect Errors", "Critical", "Non-Critical", "Critical", "Non-Critical", "Critical", "Non-Critical", "Error/Loan" };

                HCount = 3;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[3, HCount].Value = InternalReqc[0];
                    wksheet.Range[3, HCount + 1].Value = InternalReqc[1];
                    wksheet.Range[3, HCount + 2].Value = InternalReqc[2];
                    wksheet.Range[3, HCount + 3].Value = InternalReqc[3];
                    wksheet.Range[3, HCount + 4].Value = InternalReqc[4];
                    wksheet.Range[3, HCount + 5].Value = InternalReqc[5];
                    wksheet.Range[3, HCount + 6].Value = InternalReqc[6];
                    wksheet.Range[3, HCount + 7].Value = InternalReqc[7];
                    wksheet.Range[3, HCount + 8].Value = InternalReqc[8];
                    HCount = HCount + 9;
                }
                HCount = 3;

                string RevColName2 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName2 + "3"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName2 + "" + (dt.Rows.Count + 3)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.Range["A3:" + RevColName2 + "3"].AutoFitRows();

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                wksheet.HideColumn(1);
            }

            return 1;
        }

        [WebMethod]
        public static int QCerPerformance1(string Type)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (Type == "QC Date")
                dt = new bllReport().WeeklyQCerDetails_QCDate();
            else
                dt = new bllReport().WeeklyQCerDetails_QCDate();

            wksheet = book.CreateEmptySheet("QCer Performance");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 3, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                int HCount = 3;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "3"].Value.Replace("-File Qced", "");
                    wksheet.Range[1, HCount, 1, HCount + 10].Merge();
                    //wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Internal-Critical", "");
                    //wksheet.Range[1, HCount, 1, HCount + 3].Merge();
                    HCount = HCount + 11;
                }
                HCount = 7;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[2, HCount].Value = "ReQC";
                    wksheet.Range[2, HCount, 2, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[2, HCount].Value = "Client";
                    wksheet.Range[2, HCount, 2, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[2, HCount].Value = "Total";
                    wksheet.Range[2, HCount, 2, HCount + 1].Merge();
                    //wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Internal-Critical", "");
                    //wksheet.Range[1, HCount, 1, HCount + 3].Merge();
                    HCount = HCount + 7;
                }

                wksheet.Range["A1:A1"].Value = "Sr. #";
                wksheet.Range["A1:A3"].Merge();
                wksheet.Range["B1:B3"].Merge();

                string[] InternalReqc = { "File Qced", "Errors Found", "Error Finding Rate", "Incorrect Errors", "Critical", "Non-Critical", "Critical", "Non-Critical", "Critical", "Non-Critical", "Error/Loan" };

                HCount = 3;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[3, HCount].Value = InternalReqc[0];
                    wksheet.Range[3, HCount + 1].Value = InternalReqc[1];
                    wksheet.Range[3, HCount + 2].Value = InternalReqc[2];
                    wksheet.Range[3, HCount + 3].Value = InternalReqc[3];
                    wksheet.Range[3, HCount + 4].Value = InternalReqc[4];
                    wksheet.Range[3, HCount + 5].Value = InternalReqc[5];
                    wksheet.Range[3, HCount + 6].Value = InternalReqc[6];
                    wksheet.Range[3, HCount + 7].Value = InternalReqc[7];
                    wksheet.Range[3, HCount + 8].Value = InternalReqc[8];
                    wksheet.Range[3, HCount + 9].Value = InternalReqc[9];
                    wksheet.Range[3, HCount + 10].Value = InternalReqc[10];
                    HCount = HCount + 11;
                }
                HCount = 3;

                string RevColName2 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName2 + "3"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName2 + "" + (dt.Rows.Count + 3)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.Range["A3:" + RevColName2 + "3"].AutoFitRows();

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                wksheet.HideColumn(1);
            }

            return 1;
        }


        [WebMethod]
        public static int CategorySubCategory1(string Type)
        {
            DataSet ds = null;
            DataTable dt = null;
            DataTable dt2 = null;
            int RCount = 1;
            int CCount = 1;
            //if (Type == "QC Date")
            //    ds = new bllReport().GetCategorySubCategory_QCDate();
            //else
            //    ds = new bllReport().GetCategorySubCategory_QCDate();
            if (Type == "QC Date")
                dt = new bllReport().GetCategorySubCategory_QCDate();
            else
                dt = new bllReport().GetCategorySubCategory_QCDate();
            wksheet = book.CreateEmptySheet("Category");

            int HCount = 3;
            string RevColName = "";
            if (dt != null)
            {
                #region Category

                wksheet.InsertDataTable(dt, true, 2, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Total Errors", "");
                    wksheet.Range[1, HCount, 1, HCount + 1].Merge();
                    //wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Internal-Critical", "");
                    //wksheet.Range[1, HCount, 1, HCount + 3].Merge();
                    HCount = HCount + 2;
                }
                wksheet.Range["A1:A1"].Value = "Sr. #";
                wksheet.Range["A2:A2"].Merge();
                wksheet.Range["B1:B2"].Merge();

                string[] InternalReqc = { "Total Errors", "Error/Loan" };

                HCount = 3;
                while (HCount < CCount)
                {
                    wksheet.Range[2, HCount].Value = InternalReqc[0];
                    wksheet.Range[2, HCount + 1].Value = InternalReqc[1];
                    HCount = HCount + 2;
                }

                RevColName = GetColumnName(CCount - 1);

                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "2"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt.Rows.Count + 2)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.Range["C1:" + RevColName + "2"].AutoFitRows();
                wksheet.Range["B1:B1"].AutoFitColumns();

                wksheet.HideColumn(1);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                #endregion
            }
            #region SubCategory
            if (Type == "QC Date")
                dt2 = new bllReport().GetSubCategory_QCDate();
            else
                dt2 = new bllReport().GetSubCategory_QCDate();
            wksheet = book.CreateEmptySheet("Sub Category");
            if (dt2 != null)
            {

                RCount = 1;
                CCount = 1;
                wksheet.InsertDataTable(dt2, true, 2, CCount);

                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                HCount = 3;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Total Errors", "");
                    wksheet.Range[1, HCount, 1, HCount + 1].Merge();
                    //wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Internal-Critical", "");
                    //wksheet.Range[1, HCount, 1, HCount + 3].Merge();
                    HCount = HCount + 2;
                }
                wksheet.Range["A1:A1"].Value = "Sr. #";
                wksheet.Range["A2:A2"].Merge();
                wksheet.Range["B1:B2"].Merge();

                string[] InternalReqc1 = { "Total Errors", "Error/Loan" };

                HCount = 3;
                while (HCount < CCount)
                {
                    wksheet.Range[2, HCount].Value = InternalReqc1[0];
                    wksheet.Range[2, HCount + 1].Value = InternalReqc1[1];
                    HCount = HCount + 2;
                }

                RevColName = GetColumnName(CCount - 1);

                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "2"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt2.Rows.Count + 2)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.Range["C1:" + RevColName + "2"].AutoFitRows();
                wksheet.Range["B1:B1"].AutoFitColumns();

                wksheet.HideColumn(1);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();


            }
            #endregion
            return 1;
        }

        [WebMethod]
        public static int GetFeedback1(string Type)
        {
            DataSet ds = null;
            int RCount = 1;
            int CCount = 1;
            if (Type == "QC Date")
                ds = new bllReport().GetFeedbacks();
            else
                ds = new bllReport().GetFeedbacks();

            if (ds != null)
            {
                #region Internal Feedbacks
                wksheet = book.CreateEmptySheet("Internal feedbacks");
                DataTable dt = ds.Tables[0];
                DataTable dt2 = ds.Tables[1];
                DataTable dt3 = ds.Tables[2];
                DataTable dt4 = ds.Tables[3];
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName = GetColumnName(CCount - 1);

                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "1"]);
                //AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt.Rows.Count + 2)]);
                //ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                #endregion
                #region Client Feedbacks
                wksheet = book.CreateEmptySheet("Client feedbacks");
                RCount = 1;
                CCount = 1;
                wksheet.InsertDataTable(dt2, true, 1, CCount);

                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;
                RevColName = GetColumnName(CCount - 1);

                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "1"]);
                //AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt2.Rows.Count + 2)]);
                //ContentCenter_Static(wksheet.AllocatedRange);


                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                #endregion
                #region ReQC Feedbacks
                wksheet = book.CreateEmptySheet("ReQC feedbacks");
                RCount = 1;
                CCount = 1;
                wksheet.InsertDataTable(dt3, true, 1, CCount);

                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;
                RevColName = GetColumnName(CCount - 1);

                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "1"]);
                //AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt3.Rows.Count + 2)]);
                //ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                #endregion
                #region Rebuttal Feedbacks
                wksheet = book.CreateEmptySheet("Rebuttal feedbacks");
                RCount = 1;
                CCount = 1;
                wksheet.InsertDataTable(dt4, true, 1, CCount);

                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;
                RevColName = GetColumnName(CCount - 1);

                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "1"]);
                //AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt4.Rows.Count + 2)]);
                //ContentCenter_Static(wksheet.AllocatedRange);


                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                #endregion

            }
            return 1;
        }

        [WebMethod]
        public static int ClientQualityReport1(string Type)
        {
            DataSet ds = null;
            DataTable dt = null;
            DataTable dt2 = null;
            int RCount = 1;
            int CCount = 1;

            if (Type == "QC Date")
                dt = new bllReport().GetClientQualityReport_QCDate();
            else
                dt = new bllReport().GetClientQualityReport_QCDate();

            wksheet = book.CreateEmptySheet("Client Quality Report");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
            }
            book.SaveToFile(FileName, ExcelVersion.Version2010);
            return 1;
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
                    worksheet = workbook.Worksheet(16);
                    workbook.Worksheets.Delete(worksheet.Name);

                    //worksheet = workbook.Worksheet(sheetIndexToDelete + 1);
                    //workbook.Worksheets.Delete(worksheet.Name);
                    //worksheet = workbook.Worksheet(sheetIndexToDelete + 2);
                    //workbook.Worksheets.Delete(worksheet.Name);
                    //worksheet = workbook.Worksheet(sheetIndexToDelete + 1);
                    //workbook.Worksheets.Delete(worksheet.Name);
                }
                else
                {

                }

                // Save the updated workbook
                workbook.SaveAs(outputPath);
            }
            //Excel.Application xlApp = new Microsoft.Office.Interop.Excel.Application();
            //if (xlApp == null)
            //{
            //    return;
            //}
            //xlApp.DisplayAlerts = false;
            //Excel.Workbook xlWorkBook = xlApp.Workbooks.Open(FileName);
            //System.Threading.Thread.Sleep(1000);
            //Excel.Sheets worksheets = xlWorkBook.Worksheets;
            //worksheets[1].Delete();
            //worksheets[1].Delete();
            //worksheets[1].Delete();
            //worksheets[15].Delete();
            //worksheets[1].Select();
            //xlWorkBook.Save();
            //xlWorkBook.Close();
            //xlApp.Quit();

            //releaseObject(worksheets);
            //releaseObject(xlWorkBook);
            //releaseObject(xlApp);


            Response.Clear();
            Response.Buffer = false;
            Response.AppendHeader("Content-Type", "application/xlsx");
            Response.AppendHeader("Content-Transfer-Encoding", "binary");
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(FileName));
            Response.TransmitFile(FileName);
            Response.End();
        }

        #endregion

        #region new Code
        [WebMethod]
        public static int GetGraphicalView(string domain, string company)
        {
            int returnvalue = 1;
            FileName = FolderPath + "\\Quality Report_" + domain + "_" + company + "_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".xlsx";
            book = new Workbook();
            book.Version = ExcelVersion.Version2016;
            DataTable dt = null;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().WeeklyGraphicalView_Credit_Infinity();
                else
                    dt = new dalReport().WeeklyGraphicalView_Credit_Canopy();
            }
            else
                dt = new dalReport().WeeklyGraphicalView_Servicing_Infinity();
            if (dt != null)
            {
                wksheet = book.CreateEmptySheet("Weekly - Graphical View");
                int RCount = 1;
                int CCount = 1;
                DataRow dr1 = dt.NewRow();
                dr1[0] = "Average";
                //int TotalVolume1 = dt.AsEnumerable().Sum(row => row.Field<int>("Loan Qced"));
                decimal TotalVolume1 = (decimal)dt.Compute("Avg([Loan Qced])", "");
                decimal TotalCritical1 = (decimal)dt.Compute("Avg([NC/Loan-Internal])", "");
                decimal TotalNCritical1 = (decimal)dt.Compute("Avg([C/Loan-Internal])", "");
                decimal TotalCriticalReQC = (decimal)dt.Compute("Avg([NC/Loan-ReQC])", "");
                decimal TotalNCriticalReQC = (decimal)dt.Compute("Avg([C/Loan-ReQC])", "");
                decimal TotalCriticalClient = (decimal)dt.Compute("Avg([Non-Critical Errors-Client])", "");
                decimal TotalNCriticalClient = (decimal)dt.Compute("Avg([Critical Errors-Client])", "");
                decimal TotalCriticalAll = (decimal)dt.Compute("Avg([Total Critical])", "");
                decimal TotalNonCriticalAll = (decimal)dt.Compute("Avg([Total non Critical])", "");
                decimal NoErrorFiles = (decimal)dt.Compute("Avg([No Error Files])", "");
                decimal Erros1 = (decimal)dt.Compute("Avg([Error/Loan])", "");
                decimal PercNoErrorFiles = (decimal)dt.Compute("Avg([% No Error Files])", "");
                dr1[1] = Math.Round(TotalVolume1, 0).ToString();
                dr1[2] = Math.Round(TotalCritical1, 1).ToString();
                dr1[3] = Math.Round(TotalNCritical1, 1).ToString();
                dr1[4] = Math.Round(TotalCriticalReQC, 3).ToString();
                dr1[5] = Math.Round(TotalNCriticalReQC, 3).ToString();
                dr1[6] = Math.Round(TotalNCriticalClient, 3).ToString();
                dr1[7] = Math.Round(TotalNCriticalClient, 3).ToString();
                dr1[8] = Math.Round(TotalCriticalAll, 1).ToString();
                dr1[9] = Math.Round(TotalNonCriticalAll, 1).ToString();
                dr1[10] = Math.Round(Erros1, 1).ToString();
                dr1[11] = Math.Round(NoErrorFiles, 1).ToString();
                dr1[12] = Math.Round(PercNoErrorFiles, 1).ToString();
                dt.Rows.Add(dr1);
                dt.AcceptChanges();

                wksheet.InsertDataTable(dt, true, 2, 1);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                wksheet.Range[1, 3].Value = "Internal";
                wksheet.Range[1, 3, 1, 4].Merge();
                HeaderFormat_Static_Green(wksheet.Range[1, 3, 1, 4]);

                wksheet.Range[1, 5].Value = "ReQC";
                wksheet.Range[1, 5, 1, 6].Merge();
                HeaderFormat_Static_Yellow(wksheet.Range[1, 5, 1, 6]);

                wksheet.Range[1, 7].Value = "Client";
                wksheet.Range[1, 7, 1, 8].Merge();
                HeaderFormat_Static_Red(wksheet.Range[1, 7, 1, 8]);

                wksheet.Range[1, 9].Value = "Total";
                wksheet.Range[1, 9, 1, 10].Merge();
                HeaderFormat_Static(wksheet.Range[1, 9, 1, 10]);

                string CName1 = GetColumnName(CCount - 1);

                CellRange range12 = wksheet.Range["A" + Convert.ToString(dt.Rows.Count + 2) + ":" + CName1 + Convert.ToString(dt.Rows.Count + 2)];
                HeaderFormat_Static(range12);

                range12 = wksheet.Range["A2:" + CName1 + "2"];
                HeaderFormat_Static(range12);

                wksheet.Range["C2:C2"].Value = "Non-Critical";
                HeaderFormat_Static_Green(wksheet.Range["C2:C" + wksheet.LastRow]);
                wksheet.Range["D2:D2"].Value = "Critical";
                HeaderFormat_Static_Green(wksheet.Range["D2:D" + wksheet.LastRow]);
                wksheet.Range["E2:E2"].Value = "Non-Critical";
                HeaderFormat_Static_Yellow(wksheet.Range["E2:E" + wksheet.LastRow]);
                wksheet.Range["F2:F2"].Value = "Critical";
                HeaderFormat_Static_Yellow(wksheet.Range["F2:F"+ wksheet.LastRow]);
                wksheet.Range["G2:G2"].Value = "Non-Critical";
                HeaderFormat_Static_Red(wksheet.Range["G2:G" + wksheet.LastRow]);
                wksheet.Range["H2:H2"].Value = "Critical";
                HeaderFormat_Static_Red(wksheet.Range["H2:H" + wksheet.LastRow]);
                wksheet.Range["I2:I2"].Value = "Non-Critical";
                wksheet.Range["J2:J2"].Value = "Critical";

                Chart chart1 = wksheet.Charts.Add(ExcelChartType.ColumnClustered);
                wksheet.Range.IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range.NumberFormat = "0.0";
                //wksheet.Range["B3:B" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                //wksheet.Range["B3:B" + RCount].NumberFormat = "0";
                //wksheet.Range["L3:L" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                //wksheet.Range["L3:L" + RCount].NumberFormat = "0";
                //wksheet.Range["K3:K" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                //wksheet.Range["K3:K" + RCount].NumberFormat = "0.0";
                //wksheet.Range["E3:H" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                //wksheet.Range["E3:H" + RCount].NumberFormat = "0.00";

                wksheet.Range["B3:B" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range["B3:B" + RCount].NumberFormat = "0";
                wksheet.Range["L3:L" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range["L3:L" + RCount].NumberFormat = "0";
                wksheet.Range["K3:K" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range["K3:K" + RCount].NumberFormat = "0.00";
                wksheet.Range["E3:H" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range["E3:H" + RCount].NumberFormat = "0.00";
                wksheet.Range["C3:D" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range["C3:D" + RCount].NumberFormat = "0.00";
                wksheet.Range["I3:J" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range["I3:J" + RCount].NumberFormat = "0.00";

                CName1 = GetColumnName(CCount - 1);
                range12 = wksheet.Range[CName1 + "3:" + CName1 + Convert.ToString(dt.Rows.Count + 2)];
                wksheet.Range.IgnoreErrorOptions = IgnoreErrorType.NumberAsText;

                for (int i = 1; i <= dt.Rows.Count; i++)
                {
                    wksheet.Range["M" + (i + 2)].NumberFormat = "0";
                    wksheet.Range["M" + (i + 2)].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    wksheet.Range["M" + (i + 2)].Value = wksheet.Range["M" + (i + 2)].Value + "%";
                }
                wksheet.Range["M" + RCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range["M" + RCount].NumberFormat = "0";

                for (int i = 3; i <= RCount; i++)
                {
                    wksheet.Range["K" + (i)].Formula = "=SUM(C" + (i) + ":H" + (i) + ")";
                }
                wksheet.Range["K" + (dt.Rows.Count + 2)].Formula = "=AVERAGE(K3:K" + (dt.Rows.Count + 1) + ")";

                chart1.SeriesDataFromRange = false;
                //Chart border  
                chart1.ChartArea.Border.Weight = ChartLineWeightType.Medium;
                chart1.ChartArea.Border.Color = Color.SandyBrown;
                //Chart position  
                chart1.LeftColumn = CCount + 2;
                chart1.TopRow = 2;
                chart1.RightColumn = CCount + 13;
                chart1.BottomRow = RCount + 10;
                //Chart title  
                chart1.ChartTitle = "Weekly Volume and Error Analysis";
                chart1.ChartTitleArea.Font.FontName = "Aptos Narrow";
                chart1.ChartTitleArea.Font.Size = 11;
                chart1.ChartTitleArea.Font.IsBold = true;
                //Chart axis  
                chart1.PrimaryCategoryAxis.Title = "Week";
                chart1.PrimaryCategoryAxis.Font.Color = Color.Blue;
                chart1.PrimaryValueAxis.Title = "Volume";
                chart1.SecondaryValueAxisTitle = "Error/Loan";

                chart1.PrimaryValueAxis.HasMajorGridLines = false;
                //chart.PrimaryValueAxis.MaxValue = 100;
                chart1.PrimaryValueAxis.TitleArea.TextRotationAngle = 90;

                var cs11 = chart1.Series.Add("Volume", ExcelChartType.ColumnClustered);
                cs11.Values = wksheet.Range["B3:B" + Convert.ToString(RCount - 1)];
                wksheet.Range["B3:B" + Convert.ToString(RCount - 1)].ConvertToNumber();

                var cs21 = chart1.Series.Add("C/Loan", ExcelChartType.ScatterLineMarkers);
                cs21.Values = wksheet.Range["D3:D" + Convert.ToString(RCount - 1)];
                wksheet.Range["D3:D" + Convert.ToString(RCount - 1)].ConvertToNumber();

                var cs31 = chart1.Series.Add("NC/Loan", ExcelChartType.ScatterLineMarkers);
                cs31.Values = wksheet.Range["C3:C" + Convert.ToString(RCount - 1)];
                wksheet.Range["C3:C" + Convert.ToString(RCount - 1)].ConvertToNumber();

                var cs41 = chart1.Series.Add("Error/Loan", ExcelChartType.ScatterLineMarkers);
                cs41.Values = wksheet.Range["K3:K" + Convert.ToString(RCount - 1)];
                wksheet.Range["K3:K" + Convert.ToString(RCount - 1)].ConvertToNumber();

                cs21.UsePrimaryAxis = false;
                cs31.UsePrimaryAxis = false;
                cs41.UsePrimaryAxis = false;

                foreach (Spire.Xls.Charts.ChartSerie cs in chart1.Series)
                {
                    cs.CategoryLabels = wksheet.Range["A3:A" + Convert.ToString(RCount - 1)];
                    cs.DataPoints.DefaultDataPoint.DataLabels.HasValue = true;
                }
                chart1.Legend.Position = LegendPositionType.Bottom;

                wksheet.AllocatedRange.Style.HorizontalAlignment = HorizontalAlignType.Center;
                wksheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                wksheet.AllocatedRange.Style.Font.Size = 10;

                chart1 = null;
                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                returnvalue = 1;
            }
            return returnvalue;
        }

        [WebMethod]
        public static int CLientwiseErrorTrending(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().ClientwiseErrorTrending_Credit_Infinity();
                else
                    dt = new dalReport().ClientwiseErrorTrending_Credit_Canopy();
            }
            else
                dt = new dalReport().ClientwiseErrorTrending_Servicing_Infinity();
            wksheet = book.CreateEmptySheet("Client-wise Error Trending");
            wksheet.InsertDataTable(dt, true, 4, CCount);
            RCount = wksheet.LastRow;
            CCount = wksheet.LastColumn;

            int HCount = 3;
            while (HCount < CCount)
            {
                string hColName = GetColumnName(HCount - 1);
                wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "4"].Value.Replace("-Loan Count", "");
                wksheet.Range[1, HCount, 1, HCount + 11].Merge();
                HCount = HCount + 12;
                wksheet.Range[1, HCount + 11].Style.Borders[BordersLineType.EdgeRight].LineStyle = LineStyleType.Thick;
                wksheet.Range[1, HCount + 11].Style.Borders[BordersLineType.EdgeRight].Color = Color.Black;
            }
            wksheet.Range["A1:A1"].Value = "Sr. #";
            wksheet.Range["A1:A4"].Merge();
            wksheet.Range["B1:B4"].Merge();

            string[] InternalReqc = { "Internal", "ReQC" };

            HCount = 4;
            while (HCount < CCount)
            {
                string hColName = GetColumnName(HCount - 1);
                wksheet.Range[2, HCount].Value = InternalReqc[0];
                wksheet.Range[2, HCount, 2, HCount + 3].Merge();
                HCount = HCount + 4;
                wksheet.Range[2, HCount].Value = InternalReqc[1];
                wksheet.Range[2, HCount, 2, HCount + 3].Merge();
                wksheet.Range[2, HCount + 3].Style.Borders[BordersLineType.EdgeRight].LineStyle = LineStyleType.Thick;
                wksheet.Range[2, HCount + 3].Style.Borders[BordersLineType.EdgeRight].Color = Color.Black;
                HCount = HCount + 8;
            }
            HCount = 4;
            while (HCount < CCount)
            {
                string hColName = GetColumnName(HCount - 1);
                wksheet.Range[3, HCount].Value = "Error Count";
                wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                HCount = HCount + 2;
                wksheet.Range[3, HCount].Value = "Error/Loan";
                wksheet.Range[3, HCount, 3, HCount + 1].Merge();

                HCount = HCount + 2;
                hColName = GetColumnName(HCount - 1);
                wksheet.Range[3, HCount].Value = "Error Count";
                wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                HCount = HCount + 2;
                wksheet.Range[3, HCount].Value = "Error/Loan";
                wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                HCount = HCount + 2;
                wksheet.Range[2, HCount].Value = "Total";
                wksheet.Range[2, HCount, 3, HCount + 1].Merge();

                HCount = HCount + 4;
            }
            HCount = 3;
            HCount = 3;
            while (HCount < CCount)
            {
                wksheet.Range[2, HCount].Value = "Loan Count";
                wksheet.Range[2, HCount, 4, HCount].Merge();
                wksheet.Range[4, HCount + 1].Value = "Critical";
                wksheet.Range[4, HCount + 2].Value = "Non-Critical";
                wksheet.Range[4, HCount + 3].Value = "Critical";
                wksheet.Range[4, HCount + 4].Value = "Non-Critical";
                wksheet.Range[4, HCount + 5].Value = "Critical";
                wksheet.Range[4, HCount + 6].Value = "Non-Critical";
                wksheet.Range[4, HCount + 7].Value = "Critical";
                wksheet.Range[4, HCount + 8].Value = "Non-Critical";
                wksheet.Range[4, HCount + 9].Value = "Critical";
                wksheet.Range[4, HCount + 10].Value = "Non-Critical";
                wksheet.Range[2, HCount + 11].Value = "% No Error Files";

                wksheet.Range[2, HCount + 11, 4, HCount + 11].Merge();
                wksheet.Range[4, HCount + 1].Style.Borders[BordersLineType.EdgeRight].LineStyle = LineStyleType.Thick;
                wksheet.Range[4, HCount + 1].Style.Borders[BordersLineType.EdgeRight].Color = Color.Black;
                HCount = HCount + 12;
            }

            HCount = 14;
            while (HCount < CCount)
            {
                for (int i = 5; i < RCount + 1; i++)
                {
                    wksheet.Range[i, HCount].Value = wksheet.Range[i, HCount].Value + "%";
                    wksheet.Range[i, HCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    wksheet.Range[i, HCount].NumberFormat = "0";
                }
                HCount = HCount + 12;
            }

            for (int i = 5; i < RCount + 1; i++)
            {
                wksheet.Range[i, CCount].Value = wksheet.Range[i, HCount].Value + "%";
                wksheet.Range[i, CCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                wksheet.Range[i, CCount].NumberFormat = "0";
            }

            string RevColName = GetColumnName(CCount - 1);

            HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "4"]);
            AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt.Rows.Count + 4)]);

            wksheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            wksheet.AllocatedRange.Style.HorizontalAlignment = HorizontalAlignType.Center;
            wksheet.AllocatedRange.Style.Font.Size = 10;
            wksheet.Range["A4:" + RevColName + "4"].AutoFitRows();

            wksheet.HideColumn(1);


            return 1;
        }

        [WebMethod]
        public static int ReviewersFeedbackSummary(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().ReviewerwiseErrorTrending_Credit_Infinity();
                else
                    dt = new dalReport().ReviewerwiseErrorTrending_Credit_Canopy();
            }
            else
                dt = new dalReport().ReviewerwiseErrorTrending_Servicing_Infinity();
            wksheet = book.CreateEmptySheet("Reviewer - Feedback Summary");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 4, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                #region Commented
                string hColName = "";
                int HCount = 5;
                while (HCount < CCount)
                {
                    hColName = GetColumnName(HCount - 1);
                    wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "4"].Value.Replace("-Loan Count", "");
                    wksheet.Range[1, HCount, 1, HCount + 11].Merge();
                    HCount = HCount + 12;
                }
                wksheet.Range["A1:A1"].Value = "Sr. #";
                wksheet.Range["A1:A4"].Merge();
                wksheet.Range["B1:B4"].Merge();
                wksheet.Range["C1:C4"].Merge();
                wksheet.Range["D1:D4"].Merge();

                string[] InternalReqc = { "Internal", "ReQC" };

                HCount = 6;
                while (HCount < CCount)
                {
                    hColName = GetColumnName(HCount - 1);
                    wksheet.Range[2, HCount].Value = InternalReqc[0];
                    wksheet.Range[2, HCount, 2, HCount + 3].Merge();
                    HCount = HCount + 4;
                    wksheet.Range[2, HCount].Value = InternalReqc[1];
                    wksheet.Range[2, HCount, 2, HCount + 3].Merge();
                    HCount = HCount + 8;
                }
                HCount = 6;
                while (HCount < CCount)
                {
                    hColName = GetColumnName(HCount - 1);
                    wksheet.Range[3, HCount].Value = "Error Count";
                    wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[3, HCount].Value = "Error/Loan";
                    wksheet.Range[3, HCount, 3, HCount + 1].Merge();

                    HCount = HCount + 2;
                    hColName = GetColumnName(HCount - 1);
                    wksheet.Range[3, HCount].Value = "Error Count";
                    wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[3, HCount].Value = "Error/Loan";
                    wksheet.Range[3, HCount, 3, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[2, HCount].Value = "Total";
                    wksheet.Range[2, HCount, 3, HCount + 1].Merge();


                    //wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Internal-Critical", "");
                    //wksheet.Range[1, HCount, 1, HCount + 3].Merge();
                    HCount = HCount + 4;
                }
                HCount = 5;
                while (HCount < CCount)
                {
                    wksheet.Range[2, HCount].Value = "Loan Count";
                    wksheet.Range[2, HCount, 4, HCount].Merge();
                    wksheet.Range[4, HCount + 1].Value = "Critical";
                    wksheet.Range[4, HCount + 2].Value = "Non-Critical";
                    wksheet.Range[4, HCount + 3].Value = "Critical";
                    wksheet.Range[4, HCount + 4].Value = "Non-Critical";
                    wksheet.Range[4, HCount + 5].Value = "Critical";
                    wksheet.Range[4, HCount + 6].Value = "Non-Critical";
                    wksheet.Range[4, HCount + 7].Value = "Critical";
                    wksheet.Range[4, HCount + 8].Value = "Non-Critical";
                    wksheet.Range[4, HCount + 9].Value = "Critical";
                    wksheet.Range[4, HCount + 10].Value = "Non-Critical";
                    wksheet.Range[2, HCount + 11].Value = "% No Error Files";
                    wksheet.Range[2, HCount + 11, 4, HCount + 11].Merge();
                    HCount = HCount + 12;
                }
                #endregion

                HCount = 16;
                while (HCount < CCount)
                {
                    for (int i = 5; i < RCount + 1; i++)
                    {
                        wksheet.Range[i, HCount].Value = wksheet.Range[i, HCount].Value + "%";
                        wksheet.Range[i, HCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                        wksheet.Range[i, HCount].NumberFormat = "0";
                    }
                    HCount = HCount + 12;
                }

                for (int i = 5; i < RCount + 1; i++)
                {
                    wksheet.Range[i, CCount].Value = wksheet.Range[i, HCount].Value + "%";
                    wksheet.Range[i, CCount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    wksheet.Range[i, CCount].NumberFormat = "0";
                }
                string RevColName = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "4"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt.Rows.Count + 4)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.Range["A4:" + RevColName + "4"].AutoFitRows();
                wksheet.HideColumn(1);

            }




            return 1;
        }

        [WebMethod]
        public static int ReviewerVsQcerErrorCounts(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().ReviewerVsQcerErrorCounts_Credit_Infinity();
                else
                    dt = new dalReport().ReviewerVsQcerErrorCounts_Credit_Canopy();
            }
            else
                dt = new dalReport().ReviewerVsQcerErrorCounts_Servicing_Infinity();
            wksheet = book.CreateEmptySheet("Reviewer Vs Qcer Error Count");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

            }

            return 1;
        }

        [WebMethod]
        public static int NoErrorFilesAnalysis(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().NoErrorFilesAnalysis_Credit_Infinity();
                else
                    dt = new dalReport().NoErrorFilesAnalysis_Credit_Canopy();
            }
            else
                dt = new dalReport().NoErrorFilesAnalysis_Servicing_Infinity();
            wksheet = book.CreateEmptySheet("No Error Files Analysis");

            if (dt != null)
            {
                #region Category
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName = GetColumnName(CCount - 1);

                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt.Rows.Count + 2)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                #endregion

            }
            return 1;
        }

        [WebMethod]
        public static int Reviewerwiseclientwiseerrors(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().Reviewerwiseclientwiseerrors_Credit_Infinity();
                else
                    dt = new dalReport().Reviewerwiseclientwiseerrors_Credit_Canopy();
            }
            else
                dt = new dalReport().Reviewerwiseclientwiseerrors_Servicing_Infinity();
            wksheet = book.CreateEmptySheet("Reviewer wise client wise error");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
                wksheet.HideColumn(1);
            }
            return 1;
        }

        [WebMethod]
        public static int ReviewerQCClientwiseerrors(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().ReviewerQCClientwiseerrors_Credit_Infinity();
                else
                    dt = new dalReport().ReviewerQCClientwiseerrors_Credit_Canopy();
            }
            else
                dt = new dalReport().ReviewerQCClientwiseerrors_Servicing_Infinity();

            wksheet = book.CreateEmptySheet("Reviewer, QC, Client wise error");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
                // wksheet.HideColumn(1);

            }
            return 1;
        }
        [WebMethod]
        public static int QCersPerformance(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().QCersPerformance_Credit_Infinity();
                else
                    dt = new dalReport().QCersPerformance_Credit_Canopy();
            }
            else
                dt = new dalReport().QCersPerformance_Servicing_Infinity();

            wksheet = book.CreateEmptySheet("QCer Performance");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 3, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                int HCount = 3;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "3"].Value.Replace("-File Qced", "");
                    wksheet.Range[1, HCount, 1, HCount + 10].Merge();
                    //wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Internal-Critical", "");
                    //wksheet.Range[1, HCount, 1, HCount + 3].Merge();
                    HCount = HCount + 11;
                }
                HCount = 7;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[2, HCount].Value = "ReQC";
                    wksheet.Range[2, HCount, 2, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[2, HCount].Value = "Client";
                    wksheet.Range[2, HCount, 2, HCount + 1].Merge();
                    HCount = HCount + 2;
                    wksheet.Range[2, HCount].Value = "Total";
                    wksheet.Range[2, HCount, 2, HCount + 1].Merge();
                    //wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Internal-Critical", "");
                    //wksheet.Range[1, HCount, 1, HCount + 3].Merge();
                    HCount = HCount + 7;
                }

                wksheet.Range["A1:A1"].Value = "Sr. #";
                wksheet.Range["A1:A3"].Merge();
                wksheet.Range["B1:B3"].Merge();

                string[] InternalReqc = { "File Qced", "Errors Found", "Error Finding Rate", "Incorrect Errors", "Critical", "Non-Critical", "Critical", "Non-Critical", "Critical", "Non-Critical", "Error/Loan" };

                HCount = 3;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[3, HCount].Value = InternalReqc[0];
                    wksheet.Range[3, HCount + 1].Value = InternalReqc[1];
                    wksheet.Range[3, HCount + 2].Value = InternalReqc[2];
                    wksheet.Range[3, HCount + 3].Value = InternalReqc[3];
                    wksheet.Range[3, HCount + 4].Value = InternalReqc[4];
                    wksheet.Range[3, HCount + 5].Value = InternalReqc[5];
                    wksheet.Range[3, HCount + 6].Value = InternalReqc[6];
                    wksheet.Range[3, HCount + 7].Value = InternalReqc[7];
                    wksheet.Range[3, HCount + 8].Value = InternalReqc[8];
                    wksheet.Range[3, HCount + 9].Value = InternalReqc[9];
                    wksheet.Range[3, HCount + 10].Value = InternalReqc[10];
                    HCount = HCount + 11;
                }
                HCount = 3;

                string RevColName2 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName2 + "3"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName2 + "" + (dt.Rows.Count + 3)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.Range["A3:" + RevColName2 + "3"].AutoFitRows();

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                wksheet.HideColumn(1);
            }

            return 1;
        }

        [WebMethod]
        public static int CategorySheet(string domain, string company)
        {
            DataSet ds = null;
            DataTable dt = null;
            DataTable dt2 = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().CategorySheet_Credit_Infinity();
                else
                    dt = new dalReport().CategorySheet_Credit_Canopy();
            }
            else
                dt = new dalReport().CategorySheet_Servicing_Infinity();
            wksheet = book.CreateEmptySheet("Category");

            int HCount = 3;
            string RevColName = "";
            if (dt != null)
            {
                #region Category

                wksheet.InsertDataTable(dt, true, 2, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Total Errors", "");
                    wksheet.Range[1, HCount, 1, HCount + 1].Merge();
                    HCount = HCount + 2;
                }
                wksheet.Range["A1:A1"].Value = "Sr. #";
                wksheet.Range["A2:A2"].Merge();
                wksheet.Range["B1:B2"].Merge();

                string[] InternalReqc = { "Total Errors", "Error/Loan" };

                HCount = 3;
                while (HCount < CCount)
                {
                    wksheet.Range[2, HCount].Value = InternalReqc[0];
                    wksheet.Range[2, HCount + 1].Value = InternalReqc[1];
                    HCount = HCount + 2;
                }

                RevColName = GetColumnName(CCount - 1);

                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "2"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt.Rows.Count + 2)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.Range["C1:" + RevColName + "2"].AutoFitRows();
                wksheet.Range["B1:B1"].AutoFitColumns();

                wksheet.HideColumn(1);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();

                #endregion
            }

            return 1;
        }

        [WebMethod]
        public static int SubcategorySheet(string domain, string company)
        {
            DataSet ds = null;
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            int HCount = 3;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().SubCategorySheet_Credit_Infinity();
                else
                    dt = new dalReport().SubCategorySheet_Credit_Canopy();
            }
            else
                dt = new dalReport().SubCategorySheet_Servicing_Infinity();
            wksheet = book.CreateEmptySheet("Sub Category");
            if (dt != null)
            {

                RCount = 1;
                CCount = 1;
                wksheet.InsertDataTable(dt, true, 2, CCount);

                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                HCount = 3;
                while (HCount < CCount)
                {
                    string hColName = GetColumnName(HCount - 1);
                    wksheet.Range[1, HCount].Value = "'" + wksheet.Range[hColName + "2"].Value.Replace("-Total Errors", "");
                    wksheet.Range[1, HCount, 1, HCount + 1].Merge();
                    HCount = HCount + 2;
                }
                wksheet.Range["A1:A1"].Value = "Sr. #";
                wksheet.Range["A2:A2"].Merge();
                wksheet.Range["B1:B2"].Merge();

                string[] InternalReqc1 = { "Total Errors", "Error/Loan" };

                HCount = 3;
                while (HCount < CCount)
                {
                    wksheet.Range[2, HCount].Value = InternalReqc1[0];
                    wksheet.Range[2, HCount + 1].Value = InternalReqc1[1];
                    HCount = HCount + 2;
                }

                string RevColName = GetColumnName(CCount - 1);

                HeaderFormat_Static(wksheet.Range["A1:" + RevColName + "2"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName + "" + (dt.Rows.Count + 2)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.Range["C1:" + RevColName + "2"].AutoFitRows();
                wksheet.Range["B1:B1"].AutoFitColumns();

                wksheet.HideColumn(1);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
            }

            return 1;
        }

        [WebMethod]
        public static int getInternalFeedbacks(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().GetInternalFeedbacks_Credit_Infinity();
                else
                    dt = new dalReport().GetInternalFeedbacks_Credit_Canopy();
            }
            else
                dt = new dalReport().GetInternalFeedbacks_Servicing_Infinity();

            wksheet = book.CreateEmptySheet("Internal Feedbacks");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
                wksheet.HideColumn(1);
            }
            return 1;
        }

        [WebMethod]
        public static int getClientFeedbacks(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().GetClientFeedbacks_Credit_Infinity();
                else
                    dt = new dalReport().GetClientFeedbacks_Credit_Canopy();
            }
            else
                dt = new dalReport().GetClientFeedbacks_Servicing_Infinity();

            wksheet = book.CreateEmptySheet("Client Feedbacks");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
                wksheet.HideColumn(1);
            }
            return 1;
        }

        [WebMethod]
        public static int getReQCFeedbacks(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().GetReQCFeedbacks_Credit_Infinity();
                else
                    dt = new dalReport().GetReQCFeedbacks_Credit_Canopy();
            }
            else
                dt = new dalReport().GetReQCFeedbacks_Servicing_Infinity();

            wksheet = book.CreateEmptySheet("ReQC Feedbacks");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
                wksheet.HideColumn(1);
            }
            return 1;
        }

        [WebMethod]
        public static int getRebuttalFeedbacks(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().GetRebuttalFeedbacks_Credit_Infinity();
                else
                    dt = new dalReport().GetRebuttalFeedbacks_Credit_Canopy();
            }
            else
                dt = new dalReport().GetRebuttalFeedbacks_Servicing_Infinity();

            wksheet = book.CreateEmptySheet("Rebuttal Feedbacks");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
                wksheet.HideColumn(1);
            }
            return 1;
        }

        [WebMethod]
        public static int GetClientQualityReport(string domain, string company)
        {
            DataTable dt = null;
            int RCount = 1;
            int CCount = 1;
            if (domain == "Credit")
            {
                if (company == "Infinity")
                    dt = new dalReport().GetClientQualityReport_Credit_Infinity();
                else
                    dt = new dalReport().GetClientQualityReport_Credit_Canopy();
            }
            else
                dt = new dalReport().GetClientQualityReport_Servicing_Infinity();

            wksheet = book.CreateEmptySheet("Client Quality Report");
            if (dt != null)
            {
                wksheet.InsertDataTable(dt, true, 1, CCount);
                RCount = wksheet.LastRow;
                CCount = wksheet.LastColumn;

                string RevColName1 = GetColumnName(CCount - 1);
                HeaderFormat_Static(wksheet.Range["A1:" + RevColName1 + "1"]);
                AllBorder_Static(wksheet.Range["A1:" + RevColName1 + "" + (dt.Rows.Count + 1)]);
                ContentCenter_Static(wksheet.AllocatedRange);

                wksheet.AllocatedRange.AutoFitColumns();
                wksheet.AllocatedRange.AutoFitRows();
                wksheet.HideColumn(1);
            }
            book.SaveToFile(FileName, ExcelVersion.Version2010);
            return 1;
        }


        #endregion

        protected void fr_newdownload_Click(object sender, EventArgs e)
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
                    worksheet = workbook.Worksheet(workbook.Worksheets.Count);
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