using ClosedXML.Excel;
using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using DocumentFormat.OpenXml.Office2016.Excel;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using ICSharpCode.SharpZipLib.Zip;
using Microsoft.Office.Interop.Excel;
using Microsoft.Office.Interop.Word;
using Spire.Xls;
using Spire.Xls.Core;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Drawing;
using System.EnterpriseServices.Internal;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml;
using WebPortal.App_Code.BLL;
using Chart = Spire.Xls.Chart;
using DataTable = System.Data.DataTable;
using MailMessage = System.Net.Mail.MailMessage;
using PivotTable = Spire.Xls.PivotTable;

namespace WebPortal.Admin
{
    public partial class HRReport : System.Web.UI.Page
    {
        static string FileName = "";
        static string Month = "";
        static string Year = "";
        bllMaster bllMaster = new bllMaster();
        static Spire.Xls.Workbook book = new Spire.Xls.Workbook();
        static Spire.Xls.Worksheet sheet;
        protected void Page_Load(object sender, EventArgs e)
        {
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

        public void SendEmail(string FilePassword)
        {
            StringBuilder head = new StringBuilder();
            StringBuilder body = new StringBuilder();
            StringBuilder footer = new StringBuilder();
            head.Append("<html><head></head><body>");
            body.Append("<table style=\"width:802px;font-family:Verdana; font-size:12px; border-radius:10px;\"  bordercolor=\"Gray\" cellspacing=\"0\" cellpadding=\"0\"><tr bgcolor=\"CornflowerBlue\" style=\"height:70px;\" ><thead><th colspan=\"2\"><b style=\"color:White;font-size:22px; font-style:italic;\" >Infinity IPS</b></th></thead></tr></table>" +
                "<table border=\"0\" style=\"width:800px;font-family:Verdana; font-size:12px; border-radius:10px;\" bordercolor =\"Gray\" cellspacing=\"0\" cellpadding=\"10\">" +
                "<tr><td style=\"text-align:left; font-size:12px;\" colspan=\"2\"><b>Hello Team,<br /><br /></b></td></tr>");
            body.Append("<tr><td colspan=\"2\">Below is the system generated password for current generated file. Password will be valid for current file only.<br /><br />" + FilePassword + " </td></tr> ");
            body.Append("<tr><td style=\"text-align:left; font-size:13px;\" colspan=\"2\"><br /><br />Thanks,<br />Infinity</td></tr>" +
                    "<tr><td style=\"text-align:left; font-size:11px; border-top:none!important;\" colspan=\"2\"><br /><br /><br /><br /><br />This email was sent from a notification email address that cannot accept incoming email. Please do not reply to this message.</td></tr>" +
                    "</table>");
            footer.Append("</body></html>");

            string Pass = new bllMaster().GetPassword("ackdata");
            string ToAddress = string.Empty;
            string ToBCC = string.Empty;
            string ToCC = string.Empty;

            DataTable dtEmail = new bllLogin().GetUserPmDomainLocationEmailInfo(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), "HrReport");
            ToAddress = Convert.ToString(dtEmail.Rows[0]["To"]);
            ToCC = Convert.ToString(dtEmail.Rows[0]["CC"]);
            ToBCC = Convert.ToString(dtEmail.Rows[0]["BCC"]);

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("ack@infinity-data.com", "Confidential Information", System.Text.Encoding.UTF8);
            mail.To.Add(ToAddress);
            mail.To.Add(ToCC);
            mail.Bcc.Add(ToBCC);
            mail.Subject = "Infinity IPS - HR Report Key";
            mail.Body = head.ToString() + body.ToString() + footer.ToString();
            mail.IsBodyHtml = true;
            mail.Priority = System.Net.Mail.MailPriority.High;
            SmtpClient client = new SmtpClient();
            client.Credentials = new System.Net.NetworkCredential("ack@infinity-data.com", Pass);

            client.Host = "smtp.office365.com";  //Gmail works on Server Secured Layer
            client.Port = 587;
            client.EnableSsl = true;
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            try
            {
                client.Send(mail);
            }
            catch { }
        }

        protected void btn1_Click_Core(object sender, EventArgs e)
        {
            try
            {
                // 1️⃣ Generate File Password
                string filePassword = Membership.GeneratePassword(8, 1);

                // 2️⃣ Create File Name
                string fileName = Server.MapPath(@"~\ReportDocument\HR_Report_" + Convert.ToString(Month) + "-" + Convert.ToString(Year) + DateTime.Now.ToString("hhmmss") + ".xlsx");

                // 3️⃣ Generate Excel File
                FormatExcel(fileName);

                // 4️⃣ Open Workbook
                using (var workbook = new ClosedXML.Excel.XLWorkbook(fileName))
                {
                    // ✅ Delete first 3 sheets safely
                    for (int i = 0; i < 3; i++)
                    {
                        if (workbook.Worksheets.Count > 0)
                            workbook.Worksheet(1).Delete();
                    }

                    // ✅ Delete last sheet safely
                    if (workbook.Worksheets.Count > 0)
                        workbook.Worksheet(workbook.Worksheets.Count).Delete();

                    // ✅ Protect workbook with PASSWORD (not filepath!)
                    workbook.Protect(filePassword);

                    // ✅ Save file
                    workbook.Save();
                }

                // 5️⃣ Send Password by Email
                //   SendEmail(filePassword);

                // 6️⃣ Send File to Browser
                Response.Clear();
                Response.Buffer = true;
                Response.ContentType =
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition",
                    "attachment; filename=" + Path.GetFileName(fileName));
                Response.TransmitFile(fileName);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                // Optional: Log error properly in production
                throw ex;
            }
        }

        protected void btn1_Click(object sender, EventArgs e)
        {
            string FilePassword = Membership.GeneratePassword(8, 1);

            string filePath = FileName;
            string outputPath = FileName;

            string[] sheetsToDelete = { "Sheet1", "Sheet2", "Sheet3", "Evaluation Warning" };

            using (SpreadsheetDocument document = SpreadsheetDocument.Open(filePath, true))
            {
                WorkbookPart workbookPart = document.WorkbookPart;
                DocumentFormat.OpenXml.Spreadsheet.Sheets sheets = workbookPart.Workbook.Sheets;

                foreach (string sheetName in sheetsToDelete)
                {
                    Sheet sheet = sheets.Elements<Sheet>().FirstOrDefault(s => s.Name == sheetName);

                    if (sheet != null)
                    {
                        WorksheetPart worksheetPart =
                            (WorksheetPart)workbookPart.GetPartById(sheet.Id);

                        sheet.Remove();
                        workbookPart.DeletePart(worksheetPart);
                    }
                }

                workbookPart.Workbook.Save();
            }

            // Download Excel
            //Response.Clear();
            //Response.Buffer = true;

            //Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            //Response.AddHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(FileName));

            //Response.TransmitFile(FileName);
            //Response.Flush();
            //Response.End();


            System.Threading.Thread.Sleep(1000);

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(FileName));
            Response.BinaryWrite(File.ReadAllBytes(FileName));
            Response.Flush();
            Response.End();
        }

        protected void btn1_Click_Original(object sender, EventArgs e)
        {
            string FilePassword = Membership.GeneratePassword(8, 1);
            // workbook.Protect(FilePassword);
            //SendEmail(FilePassword);
            //FormatExcel(FileName);
            string filePath = FileName;
            string outputPath = FileName;

            // Zero-based index: e.g., index 0 = first sheet
            int sheetIndexToDelete = 1;
            string[] sheetsToDelete =
{
    "Sheet1",
    "Sheet2",
    "Sheet3",
    "Evaluation Warning"
};

            using (SpreadsheetDocument document = SpreadsheetDocument.Open(filePath, true))
            {
                WorkbookPart workbookPart = document.WorkbookPart;
                DocumentFormat.OpenXml.Spreadsheet.Sheets sheets = workbookPart.Workbook.Sheets;

                foreach (string sheetName in sheetsToDelete)
                {
                    Sheet sheet = sheets.Elements<Sheet>()
                                        .FirstOrDefault(s => s.Name == sheetName);

                    if (sheet != null)
                    {
                        WorksheetPart worksheetPart =
                            (WorksheetPart)workbookPart.GetPartById(sheet.Id);

                        sheet.Remove();
                        workbookPart.DeletePart(worksheetPart);
                    }
                }

                workbookPart.Workbook.Save();
            }
            //HideSheet(filePath);

            //using (var workbook = new XLWorkbook(filePath))
            //{
            //    // Check if index is within bounds
            //    if (sheetIndexToDelete >= 0 && sheetIndexToDelete < workbook.Worksheets.Count)
            //    {
            //        var worksheet = workbook.Worksheet(1);
            //        workbook.Worksheets.Delete(worksheet.Name);
            //        worksheet = workbook.Worksheet(1);
            //        workbook.Worksheets.Delete(worksheet.Name);
            //        worksheet = workbook.Worksheet(1);
            //        workbook.Worksheets.Delete(worksheet.Name);
            //        int cnt = workbook.Worksheets.Count;
            //        worksheet = workbook.Worksheet(cnt);
            //        workbook.Worksheets.Delete(worksheet.Name);
            //    }
            //    else
            //    {

            //    }

            //    // Save the updated workbook
            //    workbook.SaveAs(outputPath);

            //}
            ;

            Response.Clear();
            Response.Buffer = false;
            Response.AppendHeader("Content-Type", "application/xlsx");
            Response.AppendHeader("Content-Transfer-Encoding", "binary");
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(FileName));
            Response.TransmitFile(FileName);
            Response.End();

        }

        public static void HideSheet(string filePath)
        {
            string extractPath = @"D:\ExcelTemp\";

            using (ZipInputStream zipInput = new ZipInputStream(File.OpenRead(filePath)))
            {
                ZipEntry entry;

                while ((entry = zipInput.GetNextEntry()) != null)
                {
                    string fileName = Path.Combine(extractPath, entry.Name);
                    Directory.CreateDirectory(Path.GetDirectoryName(fileName));

                    using (FileStream streamWriter = File.Create(fileName))
                    {
                        byte[] buffer = new byte[4096];
                        int size;

                        while ((size = zipInput.Read(buffer, 0, buffer.Length)) > 0)
                        {
                            streamWriter.Write(buffer, 0, size);
                        }
                    }
                }
            }

            string workbookXml = Path.Combine(extractPath, @"xl\workbook.xml");

            XmlDocument doc = new XmlDocument();
            doc.Load(workbookXml);

            XmlNamespaceManager ns = new XmlNamespaceManager(doc.NameTable);
            ns.AddNamespace("d", "http://schemas.openxmlformats.org/spreadsheetml/2006/main");

            var sheets = doc.SelectNodes("//d:sheets/d:sheet", ns);

            foreach (XmlNode sheet in sheets)
            {
                if (sheet.Attributes["name"].Value == "Evaluation Warning")
                {
                    XmlAttribute stateAttr = doc.CreateAttribute("state");
                    stateAttr.Value = "hidden";   // or "veryHidden"

                    sheet.Attributes.Append(stateAttr);
                }
            }

            doc.Save(workbookXml);

            using (ZipOutputStream zipOutput = new ZipOutputStream(File.Create(filePath)))
            {
                zipOutput.SetLevel(9);

                string[] files = Directory.GetFiles(extractPath, "*.*", SearchOption.AllDirectories);

                foreach (string file in files)
                {
                    string entryName = file.Substring(extractPath.Length);
                    entryName = entryName.Replace("\\", "/");

                    ZipEntry entry = new ZipEntry(entryName);
                    zipOutput.PutNextEntry(entry);

                    byte[] buffer = File.ReadAllBytes(file);
                    zipOutput.Write(buffer, 0, buffer.Length);
                }

                zipOutput.Finish();
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

        public static void HeaderFormat(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
            range.Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
            range.Style.Font.Color = System.Drawing.Color.White;
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.IsBold = true;
        }

        public static void AllBorder(CellRange range)
        {
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }

        public static void ContentCenter(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
        }

        public static void DashboardHeader(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.Size = 12;
            range.Style.Font.IsBold = true;
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }

        public static void DashboardContent(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.Size = 10;
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }

        public void FormatExcel2(string FileName)
        {
            // mp1.Show();

            // mp1.Hide();
        }

        [WebMethod]
        public static int RecruitmentSummary(string MonthName, string YearNo)
        {
            int returnvalue = 1;
            int RecSumCount = 0;
            FileName = HttpContext.Current.Server.MapPath(@"~\ReportDocument\HR_Report_" + Convert.ToString(Month) + "-" + Convert.ToString(Year) + DateTime.Now.ToString("hhmmss") + ".xlsx");
            Month = MonthName;
            Year = YearNo;

            //book.LoadFromFile(FileName);
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";
            int rowcount = 0;
            int colcount = 0;

            #region Dashboard
            sheet = book.Worksheets.Add("Dashboard");
            #endregion

            #region Recruitment Summary
            //Worksheet sheet = book.Worksheets["Recruitment Summary"];
            sheet = book.Worksheets.Add("Recruitment Summary");

            DataSet dsRec = new bllMaster().GetRequisition(Month, Year);
            if (dsRec != null && dsRec.Tables.Count >= 2)
            {
                DataTable dtDetails = dsRec.Tables[0];
                DataTable dtDomain = dsRec.Tables[1];

                RecSumCount = dtDetails.Rows.Count;
                if (dtDetails.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtDomain, true, 1, 1);
                    string Col = GetColumnName(dtDomain.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtDomain.Rows.Count + 1)];
                    AllBorder(range);
                    ContentCenter(range);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    //sheet.InsertDataTable(dtSummary, true, rowcount + 2, 1);

                    //Col = GetColumnName(dtSummary.Columns.Count - 1);
                    //range = sheet.Range["A" + (rowcount + 2) + ":" + Col + "" + (rowcount + 2)];
                    //HeaderFormat(range);
                    //range = sheet.Range["A" + (rowcount + 2) + ":" + Col + (dtSummary.Rows.Count + 1 + rowcount + 2)];
                    //AllBorder(range);
                    //ContentCenter(range);
                    //rowcount = sheet.LastRow;
                    //colcount = sheet.LastColumn;
                    //int startrow = sheet.LastRow + 3;

                    sheet.InsertDataTable(dtDetails, true, 14, 1);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;
                    Col = GetColumnName(dtDetails.Columns.Count - 1);
                    range = sheet.Range["A14:" + Col + "14"];
                    HeaderFormat(range);
                    range = sheet.Range["A14:" + Col + (rowcount)];
                    AllBorder(range);
                    ContentCenter(range);

                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    CellRange dataRangeHiring = sheet.Range["A14:N" + sheet.LastRow];
                    Spire.Xls.PivotCache cacheHiring = book.PivotCaches.Add(dataRangeHiring);
                    PivotTable ptHiring = sheet.PivotTables.Add("Recruitment_Summary_Location", sheet.Range["A100"], cacheHiring);

                    var rHiring = ptHiring.PivotFields["Location"];
                    rHiring.Axis = AxisTypes.Row;
                    ptHiring.Options.RowHeaderCaption = "Location";

                    ptHiring.DataFields.Add(ptHiring.PivotFields["Closed"], "Employees", SubtotalTypes.Sum);

                    ptHiring.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptHiring.CalculateData();

                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    int totalrowindex = 0;
                    CellRange[] coderange1 = sheet.FindAllString("Grand Total", false, false);
                    foreach (CellRange ranges in coderange1)
                    {
                        totalrowindex = ranges.LastRow;
                    }

                    Chart chart = sheet.Charts.Add(ExcelChartType.ColumnClustered);

                    chart.SeriesDataFromRange = false;
                    //Chart border  
                    chart.ChartArea.Border.Weight = ChartLineWeightType.Medium;
                    chart.ChartArea.Border.Color = System.Drawing.Color.SandyBrown;
                    //Chart position  
                    chart.LeftColumn = 10;
                    chart.TopRow = 1;
                    chart.RightColumn = 13;
                    chart.BottomRow = 12;
                    //Chart title  
                    chart.ChartTitle = "";
                    chart.ChartTitleArea.Font.FontName = "Aptos Narrow";
                    chart.ChartTitleArea.Font.Size = 13;
                    chart.ChartTitleArea.Font.IsBold = true;
                    //Chart axis  
                    chart.PrimaryCategoryAxis.Title = "";
                    chart.PrimaryCategoryAxis.Font.Color = System.Drawing.Color.Blue;
                    chart.PrimaryValueAxis.Title = "";


                    chart.PrimaryValueAxis.HasMajorGridLines = false;
                    //chart.PrimaryValueAxis.MaxValue = 100;
                    chart.PrimaryValueAxis.TitleArea.TextRotationAngle = 90;

                    var cs1 = chart.Series.Add("Count", ExcelChartType.ColumnClustered);
                    cs1.Values = sheet.Range["B101:B" + Convert.ToString(totalrowindex - 1)];

                    sheet.Range["B101:B" + Convert.ToString(rowcount - 1)].ConvertToNumber();

                    foreach (Spire.Xls.Charts.ChartSerie cs in chart.Series)
                    {
                        cs.CategoryLabels = sheet.Range["A101:A" + Convert.ToString(totalrowindex - 1)];
                        cs.DataPoints.DefaultDataPoint.DataLabels.HasValue = true;
                    }
                    chart.Legend.Position = LegendPositionType.Bottom;
                    chart = null;
                }

            }
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            sheet.AllocatedRange.Style.Font.Size = 10;

            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion

            return returnvalue;
        }

        [WebMethod]
        public static int Hiring()
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;
            #region Hiring
            sheet = book.Worksheets.Add("Hiring");
            DataSet dsHiring = new bllMaster().GetHiring(Month, Year);
            if (dsHiring != null)
            {
                DataTable dtDetails = dsHiring.Tables[0];
                if (dtDetails != null)
                {
                    if (dtDetails.Rows.Count > 0)
                    {
                        using (DbDataReader dr = dtDetails.CreateDataReader())
                        {
                            dtDetails = dtDetails.Clone();
                            dtDetails.Columns.Add(new DataColumn("Sr. #")
                            {
                                AutoIncrement = true,
                                AllowDBNull = false,
                                AutoIncrementSeed = 1,
                                AutoIncrementStep = 1,
                                DataType = typeof(System.Int32),
                                Unique = true
                            });
                            // Change Auto Increment Column Ordinal Position to 0 (ie First Column)
                            dtDetails.Columns["Sr. #"].SetOrdinal(0);
                            // Re-load original Data
                            dtDetails.Load(dr);
                        }

                        sheet.InsertDataTable(dtDetails, true, 1, 1);
                        string Col = GetColumnName(dtDetails.Columns.Count - 1);
                        CellRange range = sheet.Range["A1:" + Col + "1"];
                        //HeaderFormat(range);
                        range = sheet.Range["A1:" + Col + (dtDetails.Rows.Count + 1)];
                        AllBorder(range);
                        ContentCenter(range);
                        rowcount = sheet.LastRow;
                        colcount = sheet.LastColumn;

                        sheet.InsertRow(1, 15);

                        CellRange dataRangeHiring = sheet.Range["A16:S" + sheet.LastRow];
                        Spire.Xls.PivotCache cacheHiring = book.PivotCaches.Add(dataRangeHiring);
                        PivotTable ptHiring = sheet.PivotTables.Add("Hiring_Branch", sheet.Range["A1"], cacheHiring);

                        var rHiring = ptHiring.PivotFields["Branch"];
                        rHiring.Axis = AxisTypes.Row;
                        ptHiring.Options.RowHeaderCaption = "Branch";

                        ptHiring.DataFields.Add(ptHiring.PivotFields["Code"], "Employees", SubtotalTypes.Count);
                        ptHiring.DataFields.Add(ptHiring.PivotFields["Salary"], "Salary", SubtotalTypes.Sum);

                        ptHiring.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                        ptHiring.CalculateData();

                        sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                        sheet.AllocatedRange.Style.Font.Size = 10;

                        PivotTable ptHiring1 = sheet.PivotTables.Add("Hiring_Domain", sheet.Range["E1"], cacheHiring);

                        rHiring = ptHiring1.PivotFields["Domain"];
                        rHiring.Axis = AxisTypes.Row;
                        ptHiring1.Options.RowHeaderCaption = "Domain";

                        ptHiring1.DataFields.Add(ptHiring1.PivotFields["Code"], "Employees", SubtotalTypes.Count);
                        ptHiring1.DataFields.Add(ptHiring1.PivotFields["Salary"], "Salary", SubtotalTypes.Sum);

                        ptHiring1.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                        ptHiring1.CalculateData();
                        sheet.AllocatedRange.Style.HorizontalAlignment = HorizontalAlignType.Center;

                        PivotTable ptHiring2 = sheet.PivotTables.Add("Hiring_DomainLocation", sheet.Range["I1"], cacheHiring);

                        rHiring = ptHiring2.PivotFields["Domain"];
                        rHiring.Axis = AxisTypes.Row;
                        ptHiring2.Options.RowHeaderCaption = "Domain";

                        var rHiring1 = ptHiring2.PivotFields["Branch"];
                        rHiring1.Axis = AxisTypes.Column;
                        ptHiring2.Options.ColumnHeaderCaption = "Branch";

                        ptHiring2.DataFields.Add(ptHiring2.PivotFields["Code"], "Employees", SubtotalTypes.Count);

                        ptHiring2.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                        ptHiring2.CalculateData();

                        sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                        sheet.AllocatedRange.Style.Font.Size = 10;

                        sheet.ListObjects.Create("Hiring", sheet.Range[16, 1, sheet.LastRow, sheet.LastColumn]);
                        sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                        sheet.ListObjects[0].DisplayTotalRow = true;
                        sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;
                        sheet.ListObjects[0].Columns[5].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    }
                }
            }
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            sheet.AllocatedRange.Style.Font.Size = 10;
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int Manpower()
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;
            #region Manpower
            sheet = book.Worksheets.Add("Manpower");
            DataSet dsmanpower = new bllMaster().Getmanpower(Month, Year);
            if (dsmanpower != null)
            {
                DataTable dtDetails = dsmanpower.Tables[0];
                if (dtDetails != null)
                {
                    if (dtDetails.Rows.Count > 0)
                    {
                        using (DbDataReader dr = dtDetails.CreateDataReader())
                        {
                            dtDetails = dtDetails.Clone();
                            dtDetails.Columns.Add(new DataColumn("Sr. #")
                            {
                                AutoIncrement = true,
                                AllowDBNull = false,
                                AutoIncrementSeed = 1,
                                AutoIncrementStep = 1,
                                DataType = typeof(System.Int32),
                                Unique = true
                            });

                            // Change Auto Increment Column Ordinal Position to 0 (ie First Column)
                            dtDetails.Columns["Sr. #"].SetOrdinal(0);

                            // Re-load original Data
                            dtDetails.Load(dr);
                        }

                        sheet.InsertDataTable(dtDetails, true, 1, 1);
                        string Col = GetColumnName(dtDetails.Columns.Count - 1);
                        CellRange range = sheet.Range["A1:" + Col + "1"];
                        range = sheet.Range["A1:" + Col + (dtDetails.Rows.Count + 1)];
                        AllBorder(range);
                        ContentCenter(range);
                        rowcount = sheet.LastRow;
                        colcount = sheet.LastColumn;

                        sheet.InsertRow(1, 15);

                        CellRange dataRangeManpower = sheet.Range["A16:S" + sheet.LastRow];
                        Spire.Xls.PivotCache cacheManpower = book.PivotCaches.Add(dataRangeManpower);
                        PivotTable ptManpower = sheet.PivotTables.Add("Manpower_Branch", sheet.Range["A1"], cacheManpower);

                        var rManpower = ptManpower.PivotFields["Branch"];
                        rManpower.Axis = AxisTypes.Row;
                        ptManpower.Options.RowHeaderCaption = "Branch";

                        ptManpower.DataFields.Add(ptManpower.PivotFields["Code"], "Employees", SubtotalTypes.Count);
                        ptManpower.DataFields.Add(ptManpower.PivotFields["Salary"], "Salary", SubtotalTypes.Sum);

                        ptManpower.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                        ptManpower.CalculateData();

                        sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                        sheet.AllocatedRange.Style.Font.Size = 10;

                        PivotTable ptManpower1 = sheet.PivotTables.Add("Manpower_Domain", sheet.Range["E1"], cacheManpower);

                        rManpower = ptManpower1.PivotFields["Domain"];
                        rManpower.Axis = AxisTypes.Row;
                        ptManpower1.Options.RowHeaderCaption = "Domain";

                        ptManpower1.DataFields.Add(ptManpower1.PivotFields["Code"], "Employees", SubtotalTypes.Count);
                        ptManpower1.DataFields.Add(ptManpower1.PivotFields["Salary"], "Salary", SubtotalTypes.Sum);

                        ptManpower1.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                        ptManpower1.CalculateData();
                        sheet.AllocatedRange.Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                        sheet.AllocatedRange.Style.Font.Size = 10;

                        PivotTable ptManpower2 = sheet.PivotTables.Add("Manpower_DomainLocation", sheet.Range["I1"], cacheManpower);
                        rManpower = ptManpower2.PivotFields["Domain"];
                        rManpower.Axis = AxisTypes.Row;
                        ptManpower.Options.RowHeaderCaption = "Domain";
                        var rManpower1 = ptManpower2.PivotFields["Branch"];
                        rManpower1.Axis = AxisTypes.Column;
                        ptManpower2.Options.ColumnHeaderCaption = "Branch";

                        ptManpower2.DataFields.Add(ptManpower2.PivotFields["Code"], "Employees", SubtotalTypes.Count);

                        ptManpower2.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                        ptManpower2.CalculateData();

                        sheet.AllocatedRange.Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                        sheet.AllocatedRange.Style.Font.Size = 10;

                        sheet.ListObjects.Create("Manpower", sheet.Range[16, 1, sheet.LastRow, sheet.LastColumn]);
                        sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                        sheet.ListObjects[0].DisplayTotalRow = true;
                        sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;
                        sheet.ListObjects[0].Columns[5].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    }
                }
            }
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            sheet.AllocatedRange.Style.Font.Size = 10;
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int SkipLevel()
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;
            #region Skip Level
            sheet = book.Worksheets.Add("Skip Level");
            DataTable dtDetailsSkip = new bllMaster().GetSkipLevelSummary(Month, Year);
            if (dtDetailsSkip != null)
            {
                if (dtDetailsSkip.Rows.Count > 0)
                {
                    using (DbDataReader dr = dtDetailsSkip.CreateDataReader())
                    {
                        dtDetailsSkip = dtDetailsSkip.Clone();
                        dtDetailsSkip.Columns.Add(new DataColumn("Sr. #")
                        {
                            AutoIncrement = true,
                            AllowDBNull = false,
                            AutoIncrementSeed = 1,
                            AutoIncrementStep = 1,
                            DataType = typeof(System.Int32),
                            Unique = true
                        });

                        // Change Auto Increment Column Ordinal Position to 0 (ie First Column)
                        dtDetailsSkip.Columns["Sr. #"].SetOrdinal(0);

                        // Re-load original Data
                        dtDetailsSkip.Load(dr);
                    }
                    dtDetailsSkip.Columns.Remove("NeedToContactAgain");
                    dtDetailsSkip.Columns.Remove("ActualContacted");
                    sheet.InsertDataTable(dtDetailsSkip, true, 1, 1);
                    sheet.Range["A1"].Value = "Sr. #";
                    sheet.Range["B1"].Value = "Branch";
                    sheet.Range["C1"].Value = "Total";
                    sheet.Range["D1"].Value = "Absconding/Resigned";
                    sheet.Range["E1"].Value = "OnFloor";
                    sheet.Range["F1"].Value = "NA (Managers)";
                    sheet.Range["G1"].Value = "Applicable To Contact";
                    sheet.Range["H1"].Value = "Discussion Completed";
                    sheet.Range["I1"].Value = "Pending";
                    string Col = GetColumnName(dtDetailsSkip.Columns.Count - 1);

                    sheet.ListObjects.Create("SkipLevel", sheet.Range[1, 1, sheet.LastRow, sheet.LastColumn]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[2].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    sheet.ListObjects[0].Columns[3].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    sheet.ListObjects[0].Columns[4].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    sheet.ListObjects[0].Columns[5].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    sheet.ListObjects[0].Columns[6].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    sheet.ListObjects[0].Columns[7].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    sheet.ListObjects[0].Columns[8].TotalsCalculation = ExcelTotalsCalculation.Sum;

                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;
                    CellRange range = sheet.Range["C1:" + Col + (sheet.LastRow)];
                    ContentCenter(range);
                }
            }
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            sheet.AllocatedRange.Style.Font.Size = 10;

            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int SkipLevelDetails()
        {
            int returnvalue = 1;
            #region PM-Skip Level
            sheet = book.Worksheets.Add("Skip - Ratings");
            DataSet dsSkip = new bllMaster().GetSkiplevelDetails(Month, Year);
            if (dsSkip != null)
            {

                int RowCount = 0;
                int ColumnCount = 0;
                DataTable dtProd = dsSkip.Tables[1];
                dtProd.Columns[0].Caption = "Branch";
                dtProd.AcceptChanges();
                DataTable dtQual = dsSkip.Tables[2];
                dtQual.Columns[0].Caption = "Branch";
                dtQual.AcceptChanges();
                DataTable dtAtt = dsSkip.Tables[2];
                dtAtt.Columns[0].Caption = "Branch";
                dtAtt.AcceptChanges();
                sheet.DeleteColumn(1, 10000);

                DataTable dtDetails = dsSkip.Tables[0];
                if (dtDetails.Rows.Count > 0)
                {
                    dtDetails.Columns.Remove(dtDetails.Columns["EmployeeID"]);
                    dtDetails.Columns.Remove(dtDetails.Columns["Status1"]);
                    dtDetails.Columns["Code"].SetOrdinal(0);
                    dtDetails.Columns["EmpName"].SetOrdinal(1);
                    dtDetails.Columns["EmpName"].Caption = "Name";
                    dtDetails.Columns["DomainName"].SetOrdinal(2);
                    dtDetails.Columns["DomainName"].Caption = "Domain";
                    dtDetails.Columns["BranchName"].SetOrdinal(3);
                    dtDetails.Columns["BranchName"].Caption = "Branch";
                    dtDetails.Columns["DepartmentName"].SetOrdinal(4);
                    dtDetails.Columns["DepartmentName"].Caption = "Department";
                    dtDetails.Columns["DesignationName"].SetOrdinal(5);
                    dtDetails.Columns["DesignationName"].Caption = "Designation";
                    dtDetails.Columns["ReportingManager"].SetOrdinal(6);
                    dtDetails.Columns["ReportingManager"].Caption = "Reporting Manager";
                    dtDetails.Columns["DomainHead"].SetOrdinal(7);
                    dtDetails.Columns["DomainHead"].Caption = "Domain Head";
                    dtDetails.Columns["CellNo"].SetOrdinal(8);
                    dtDetails.Columns["CellNo"].Caption = "Contact No.";
                    dtDetails.Columns["Category"].SetOrdinal(9);
                    dtDetails.Columns["CurrentStatus"].SetOrdinal(10);
                    dtDetails.Columns["CurrentStatus"].Caption = "Current Status";
                    dtDetails.Columns["DailyTaskProductivity"].SetOrdinal(11);
                    dtDetails.Columns["DailyTaskProductivity"].Caption = "Task/ Productive";
                    dtDetails.Columns["PGrade2"].SetOrdinal(12);
                    dtDetails.Columns["PGrade2"].Caption = "Production Grade 1";
                    dtDetails.Columns["QGrade2"].SetOrdinal(13);
                    dtDetails.Columns["QGrade2"].Caption = "Quality Grade 1";
                    dtDetails.Columns["AGrade2"].SetOrdinal(14);
                    dtDetails.Columns["AGrade2"].Caption = "Attendance Grade 1";
                    dtDetails.Columns["PGrade3"].SetOrdinal(15);
                    dtDetails.Columns["PGrade3"].Caption = "Production Grade 2";
                    dtDetails.Columns["QGrade3"].SetOrdinal(16);
                    dtDetails.Columns["QGrade3"].Caption = "Quality Grade 2";
                    dtDetails.Columns["AGrade3"].SetOrdinal(17);
                    dtDetails.Columns["AGrade3"].Caption = "Attendance Grade 2";
                    dtDetails.Columns["ProductionRemark"].SetOrdinal(18);
                    dtDetails.Columns["ProductionRemark"].Caption = "Production Status";
                    dtDetails.Columns["QualityRemark"].SetOrdinal(19);
                    dtDetails.Columns["QualityRemark"].Caption = "Quality Status";
                    dtDetails.Columns["AttendanceRemark"].SetOrdinal(20);
                    dtDetails.Columns["AttendanceRemark"].Caption = "Attendance Status";
                    dtDetails.AcceptChanges();

                    sheet.Range[1, 1].Value = "Basic Information";
                    sheet.Range[1, 1, 1, 12].Merge();
                    sheet.Range[1, 1, 1, 12].Style.Borders.LineStyle = LineStyleType.Thin;
                    sheet.Range[1, 1, 1, 12].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                    sheet.Range[1, 1, 1, 12].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                    sheet.Range[1, 1, 1, 12].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                    sheet.Range[1, 1, 1, 12].Style.Font.Color = System.Drawing.Color.White;
                    sheet.Range[1, 1, 1, 12].Style.HorizontalAlignment = HorizontalAlignType.Center;
                    sheet.Range[1, 1, 1, 12].Style.Font.IsBold = true;

                    if (Month == "April" || Month == "May" || Month == "June")
                    {
                        int Year1 = Convert.ToInt32(Year);
                        sheet.Range[1, 13].Value = "October ~ December - (" + (Year1 - 1).ToString() + ")";
                        sheet.Range[1, 13, 1, 15].Merge();
                        sheet.Range[1, 13, 1, 15].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[1, 13, 1, 15].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[1, 13, 1, 15].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[1, 13, 1, 15].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[1, 13, 1, 15].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[1, 13, 1, 15].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[1, 13, 1, 15].Style.Font.IsBold = true;
                        sheet.Range[1, 16].Value = "January ~ March - (" + (Year1).ToString() + ")";
                        sheet.Range[1, 16, 1, 18].Merge();
                        sheet.Range[1, 16, 1, 18].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[1, 16, 1, 18].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[1, 16, 1, 18].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[1, 16, 1, 18].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[1, 16, 1, 18].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[1, 16, 1, 18].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[1, 16, 1, 18].Style.Font.IsBold = true;
                    }
                    else if (Month == "July" || Month == "August" || Month == "September")
                    {
                        int Year1 = Convert.ToInt32(Year);
                        sheet.Range[1, 13].Value = "January ~ March - (" + Year1.ToString() + ")";
                        sheet.Range[1, 13, 1, 15].Merge();
                        sheet.Range[1, 13, 1, 15].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[1, 13, 1, 15].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[1, 13, 1, 15].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[1, 13, 1, 15].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[1, 13, 1, 15].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[1, 13, 1, 15].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[1, 13, 1, 15].Style.Font.IsBold = true;
                        sheet.Range[1, 16].Value = "April ~ June - (" + (Year1).ToString() + ")";
                        sheet.Range[1, 16, 1, 18].Merge();
                        sheet.Range[1, 16, 1, 18].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[1, 16, 1, 18].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[1, 16, 1, 18].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[1, 16, 1, 18].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[1, 16, 1, 18].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[1, 16, 1, 18].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[1, 16, 1, 18].Style.Font.IsBold = true;
                        sheet.Range[1, 19].Value = "April ~ June - (" + (Year1).ToString() + ")";
                    }
                    else if (Month == "October" || Month == "November" || Month == "December")
                    {
                        int Year1 = Convert.ToInt32(Year);
                        sheet.Range[1, 13].Value = "April ~ June - (" + (Year1).ToString() + ")";
                        sheet.Range[1, 13, 1, 15].Merge();
                        sheet.Range[1, 13, 1, 15].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[1, 13, 1, 15].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[1, 13, 1, 15].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[1, 13, 1, 15].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[1, 13, 1, 15].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[1, 13, 1, 15].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[1, 13, 1, 15].Style.Font.IsBold = true;
                        sheet.Range[1, 16].Value = "July ~ September - (" + (Year1).ToString() + ")";
                        sheet.Range[1, 16, 1, 18].Merge();
                        sheet.Range[1, 16, 1, 18].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[1, 16, 1, 18].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[1, 16, 1, 18].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[1, 16, 1, 18].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[1, 16, 1, 18].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[1, 16, 1, 18].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[1, 16, 1, 18].Style.Font.IsBold = true;
                    }
                    else if (Month == "January" || Month == "February" || Month == "March")
                    {
                        int Year1 = Convert.ToInt32(Year);
                        sheet.Range[1, 13].Value = "July ~ September - (" + (Year1 - 1).ToString() + ")";
                        sheet.Range[1, 13, 1, 15].Merge();
                        sheet.Range[1, 13, 1, 15].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[1, 13, 1, 15].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[1, 13, 1, 15].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[1, 13, 1, 15].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[1, 13, 1, 15].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[1, 13, 1, 15].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[1, 13, 1, 15].Style.Font.IsBold = true;
                        sheet.Range[1, 16].Value = "October ~ December - (" + (Year1 - 1).ToString() + ")";
                        sheet.Range[1, 16, 1, 18].Merge();
                        sheet.Range[1, 16, 1, 18].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[1, 16, 1, 18].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[1, 16, 1, 18].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[1, 16, 1, 18].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[1, 16, 1, 18].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[1, 16, 1, 18].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[1, 16, 1, 18].Style.Font.IsBold = true;
                    }

                    sheet.Range[1, 19].Value = "Status";
                    sheet.Range[1, 19, 1, 21].Merge();
                    sheet.Range[1, 19, 1, 21].Style.Borders.LineStyle = LineStyleType.Thin;
                    sheet.Range[1, 19, 1, 21].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                    sheet.Range[1, 19, 1, 21].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                    sheet.Range[1, 19, 1, 21].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                    sheet.Range[1, 19, 1, 21].Style.Font.Color = System.Drawing.Color.White;
                    sheet.Range[1, 19, 1, 21].Style.HorizontalAlignment = HorizontalAlignType.Center;
                    sheet.Range[1, 19, 1, 21].Style.Font.IsBold = true;

                    //int ColumnCountStart = sheet.LastColumn;
                    sheet.InsertDataTable(dtDetails, true, 2, 1);

                    sheet.Range[1, 1, sheet.LastRow, sheet.LastColumn].Style.Borders.LineStyle = LineStyleType.Thin;
                    sheet.Range[1, 1, sheet.LastRow, sheet.LastColumn].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                    sheet.Range[1, 1, sheet.LastRow, sheet.LastColumn].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;

                    string lastcolname = GetColumnName(sheet.LastColumn - 1);
                    sheet.Range["A2:" + lastcolname + "2"].Style.Borders.LineStyle = LineStyleType.Thin;
                    sheet.Range["A2:" + lastcolname + "2"].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                    sheet.Range["A2:" + lastcolname + "2"].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                    sheet.Range["A2:" + lastcolname + "2"].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                    sheet.Range["A2:" + lastcolname + "2"].Style.Font.Color = System.Drawing.Color.White;
                    sheet.Range["A2:" + lastcolname + "2"].Style.HorizontalAlignment = HorizontalAlignType.Center;
                    sheet.Range["A2:" + lastcolname + "2"].Style.Font.IsBold = true;

                    sheet.InsertRow(1, 33);

                    CellRange dataRangeProduction = sheet.Range["A35:" + lastcolname + "" + sheet.LastRow];
                    Spire.Xls.PivotCache cacheProduction = book.PivotCaches.Add(dataRangeProduction);
                    PivotTable ptProduction = sheet.PivotTables.Add("SkipDetails_Production", sheet.Range["B1"], cacheProduction);

                    var r13111 = ptProduction.PivotFields["Branch"];
                    r13111.Axis = AxisTypes.Row;
                    ptProduction.Options.RowHeaderCaption = "Branch";

                    var r1311 = ptProduction.PivotFields["Production Status"];
                    r1311.Axis = AxisTypes.Column;
                    ptProduction.Options.ColumnHeaderCaption = "Production Status";

                    ptProduction.DataFields.Add(ptProduction.PivotFields["Code"], "Production", SubtotalTypes.Count);
                    ptProduction.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptProduction.CalculateData();

                    CellRange dataRangeQuality = sheet.Range["A35:" + lastcolname + "" + sheet.LastRow];
                    Spire.Xls.PivotCache cacheQuality = book.PivotCaches.Add(dataRangeQuality);
                    PivotTable ptQuality = sheet.PivotTables.Add("SkipDetails_Quality", sheet.Range["B11"], cacheQuality);

                    var r131111 = ptQuality.PivotFields["Branch"];
                    r131111.Axis = AxisTypes.Row;
                    ptQuality.Options.RowHeaderCaption = "Branch";

                    var r1311222 = ptQuality.PivotFields["Quality Status"];
                    r1311222.Axis = AxisTypes.Column;
                    ptQuality.Options.ColumnHeaderCaption = "Quality Status";

                    ptQuality.DataFields.Add(ptQuality.PivotFields["Code"], "Quality", SubtotalTypes.Count);
                    ptQuality.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptQuality.CalculateData();

                    CellRange dataRangeAttendance = sheet.Range["A35:" + lastcolname + "" + sheet.LastRow];
                    Spire.Xls.PivotCache cacheAttendance = book.PivotCaches.Add(dataRangeAttendance);
                    PivotTable ptAttendance = sheet.PivotTables.Add("SkipDetails_Attendance", sheet.Range["B21"], cacheAttendance);

                    var r131111A = ptAttendance.PivotFields["Branch"];
                    r131111A.Axis = AxisTypes.Row;
                    ptAttendance.Options.RowHeaderCaption = "Branch";

                    var r1311222A = ptAttendance.PivotFields["Attendance Status"];
                    r1311222A.Axis = AxisTypes.Column;
                    ptAttendance.Options.ColumnHeaderCaption = "Attendance Status";

                    ptAttendance.DataFields.Add(ptAttendance.PivotFields["Code"], "Attendance", SubtotalTypes.Count);
                    ptAttendance.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptAttendance.CalculateData();


                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;
                }
            }
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int BackgroundVerification()
        {
            int returnvalue = 1;
            #region Background Verification
            sheet = book.Worksheets.Add("Background Verification");
            DataTable dtbg = new bllMaster().GetAllEmployeeVerificationRecords_Export(Month, Year);
            if (dtbg != null)
            {
                if (dtbg.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtbg, true, 1, 1);
                    sheet.InsertRow(1, 14);
                    sheet.ListObjects.Create("Details", sheet.Range["A15:O" + sheet.LastRow]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;

                    CellRange dataRange221 = sheet.Range["A15:O" + (sheet.LastRow - 1)];
                    Spire.Xls.PivotCache cache221 = book.PivotCaches.Add(dataRange221);
                    PivotTable pt221 = sheet.PivotTables.Add("BGV_Branch", sheet.Range["A1"], cache221);

                    var r131 = pt221.PivotFields[4];
                    r131.Axis = AxisTypes.Row;
                    pt221.Options.RowHeaderCaption = "Branch";

                    pt221.DataFields.Add(pt221.PivotFields[1], "Employees", SubtotalTypes.Count);

                    pt221.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    pt221.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;


                    dataRange221 = sheet.Range["A15:O" + (sheet.LastRow - 1)];
                    Spire.Xls.PivotCache cache2211212 = book.PivotCaches.Add(dataRange221);
                    pt221 = sheet.PivotTables.Add("BGV_Domain", sheet.Range["D1"], cache2211212);

                    var r1311212 = pt221.PivotFields[5];
                    r1311212.Axis = AxisTypes.Row;
                    pt221.Options.RowHeaderCaption = "Domain";

                    pt221.DataFields.Add(pt221.PivotFields[1], "Employees", SubtotalTypes.Count);

                    pt221.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    pt221.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    dataRange221 = sheet.Range["A15:O" + (sheet.LastRow - 1)];
                    Spire.Xls.PivotCache cache22112125 = book.PivotCaches.Add(dataRange221);
                    pt221 = sheet.PivotTables.Add("BGV_VerificationStatus", sheet.Range["G1"], cache22112125);

                    var r13112125 = pt221.PivotFields["Verification Status"];
                    r13112125.Axis = AxisTypes.Row;
                    pt221.Options.RowHeaderCaption = "Verification Status";

                    pt221.DataFields.Add(pt221.PivotFields[1], "Employees", SubtotalTypes.Count);

                    pt221.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    pt221.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                }
            }
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int Absconding()
        {
            int returnvalue = 1;
            #region Absconding
            sheet = book.Worksheets.Add("Absconding");

            DataSet dsAbsconding = new bllMaster().GetAbsocndingNewJoinedDetailsForExport_DS(Month, Year);
            if (dsAbsconding != null)
            {
                int RowCount = 0;
                int ColumnCount = 0;
                DataTable dtSummary = dsAbsconding.Tables[1];
                dtSummary.Columns[0].Caption = "Domain Head";
                dtSummary.Columns[1].Caption = "Employees";
                dtSummary.Columns[2].Caption = "Loss of Salaries";
                DataTable dtDetails = dsAbsconding.Tables[0];
                if (dtDetails.Rows.Count > 0)
                {
                    dtDetails.Columns["Code"].SetOrdinal(0);
                    dtDetails.Columns["Name"].SetOrdinal(1);
                    dtDetails.Columns["JoiningDate"].SetOrdinal(2);
                    dtDetails.Columns["JoiningDate"].Caption = "Joining Date";
                    dtDetails.Columns["TenureType"].SetOrdinal(3);
                    dtDetails.Columns["TenureType"].Caption = "Category";
                    dtDetails.Columns["Tenure"].SetOrdinal(4);
                    dtDetails.Columns["Tenure"].Caption = "Tenure From Joining";
                    dtDetails.Columns["Salary"].SetOrdinal(5);
                    dtDetails.Columns["Salary"].Caption = "Gross Salary";
                    dtDetails.Columns["LossOfSalary"].SetOrdinal(6);
                    dtDetails.Columns["LossOfSalary"].Caption = "Loss of Salary";
                    dtDetails.Columns["DomainName"].SetOrdinal(7);
                    dtDetails.Columns["DomainName"].Caption = "Domain";
                    dtDetails.Columns["BranchName"].SetOrdinal(8);
                    dtDetails.Columns["BranchName"].Caption = "Branch";
                    dtDetails.Columns["DepartmentName"].SetOrdinal(9);
                    dtDetails.Columns["DepartmentName"].Caption = "Department";
                    dtDetails.Columns["DesignationName"].SetOrdinal(10);
                    dtDetails.Columns["DesignationName"].Caption = "Designation";
                    dtDetails.Columns["ReportingManager"].SetOrdinal(11);
                    dtDetails.Columns["ReportingManager"].Caption = "Reporting Manager";
                    dtDetails.Columns["DomainHeadName"].SetOrdinal(12);
                    dtDetails.Columns["DomainHeadName"].Caption = "Domain Head";
                    dtDetails.Columns["ResignationType"].SetOrdinal(13);
                    dtDetails.Columns["ResignationType"].Caption = "Resignation Type";
                    dtDetails.Columns["ResignationDate"].SetOrdinal(14);
                    dtDetails.Columns["ResignationDate"].Caption = "Resignation Date";
                    dtDetails.Columns["LastWorkingDate"].SetOrdinal(15);
                    dtDetails.Columns["LastWorkingDate"].Caption = "Last Working Date";
                    dtDetails.Columns["PMRemark"].SetOrdinal(16);
                    dtDetails.Columns["PMRemark"].Caption = "PM/ System Remark";
                    dtDetails.Columns["FRemark"].SetOrdinal(17);
                    dtDetails.Columns["FRemark"].Caption = "HR Followup Remark";
                    dtDetails.Columns.Remove("EmployeeID");
                    dtDetails.AcceptChanges();

                    sheet.InsertDataTable(dtSummary, true, 1, 2);
                    RowCount = sheet.LastRow;
                    ColumnCount = sheet.LastColumn;

                    sheet.ListObjects.Create("Branchwise Summary", sheet.Range[1, 2, sheet.LastRow, sheet.LastColumn]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    sheet.ListObjects[0].Columns[2].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    int ColumnCountStart = sheet.LastColumn;

                    sheet.Range[RowCount + 3, 3].Value = "Note- 0 to 3 months : 100% loss;  4 to 6 months : 50% loss;  7 to 18 months : 25% loss;  18 months & Above : 6 months’ salary  is consider as loss";
                    sheet.Range[RowCount + 3, 3, RowCount + 3, 12].Merge();
                    sheet.Range[RowCount + 3, 3, RowCount + 3, 12].Style.Borders.LineStyle = LineStyleType.Thin;
                    sheet.Range[RowCount + 3, 3, RowCount + 3, 12].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                    sheet.Range[RowCount + 3, 3, RowCount + 3, 12].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                    sheet.Range[RowCount + 3, 3, RowCount + 3, 12].Style.Color = System.Drawing.Color.Yellow;
                    sheet.Range[RowCount + 3, 3, RowCount + 3, 12].Style.HorizontalAlignment = HorizontalAlignType.Center;
                    sheet.Range[RowCount + 3, 3, RowCount + 3, 12].Style.Font.IsBold = true;
                    sheet.Range[RowCount + 3, 3, RowCount + 3, 12].Style.Font.Size = 11;

                    sheet.InsertDataTable(dtDetails, true, RowCount + 4, 1);
                    sheet.ListObjects.Create("Al Details", sheet.Range[RowCount + 4, 1, sheet.LastRow, sheet.LastColumn]);
                    sheet.ListObjects[1].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[1].DisplayTotalRow = true;
                    sheet.ListObjects[1].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;
                    sheet.ListObjects[1].Columns[5].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    sheet.ListObjects[1].Columns[6].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    int rangeRowCount = RowCount + 3;
                    CellRange range1 = sheet.AllocatedRange;
                    range1.Style.Font.FontName = "Aptos Narrow";
                    range1.Style.Font.Size = 10;
                }
            }
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int Resigned()
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;
            #region Resigned
            sheet = book.Worksheets.Add("Resigned");

            DataSet dsResigned = new bllMaster().GetResignedEmployees_New(Month, Year);
            if (dsResigned != null)
            {
                int RowCount = 0;
                int ColumnCount = 0;
                DataTable dtSummary = dsResigned.Tables[1];
                DataTable dtDetails = dsResigned.Tables[0];
                if (dtDetails.Rows.Count > 0)
                {
                    dtDetails.Columns.Remove(dtDetails.Columns["EmployeeID"]);
                    dtDetails.Columns["Code"].SetOrdinal(0);
                    dtDetails.Columns["Name"].SetOrdinal(1);
                    dtDetails.Columns["JoiningDate"].SetOrdinal(2);
                    dtDetails.Columns["JoiningDate"].Caption = "Joining Date";
                    dtDetails.Columns["TenureType"].SetOrdinal(3);
                    dtDetails.Columns["TenureType"].Caption = "Category";
                    dtDetails.Columns["Tenure"].SetOrdinal(4);
                    dtDetails.Columns["Tenure"].Caption = "Tenure From Joining";
                    dtDetails.Columns["Salary"].SetOrdinal(5);
                    dtDetails.Columns["Salary"].Caption = "Gross Salary";
                    dtDetails.Columns["LossOfSalary"].SetOrdinal(6);
                    dtDetails.Columns["LossOfSalary"].Caption = "Loss of Salary";
                    dtDetails.Columns["DomainName"].SetOrdinal(7);
                    dtDetails.Columns["DomainName"].Caption = "Domain";
                    dtDetails.Columns["BranchName"].SetOrdinal(8);
                    dtDetails.Columns["BranchName"].Caption = "Branch";
                    dtDetails.Columns["DepartmentName"].SetOrdinal(9);
                    dtDetails.Columns["DepartmentName"].Caption = "Department";
                    dtDetails.Columns["DesignationName"].SetOrdinal(10);
                    dtDetails.Columns["DesignationName"].Caption = "Designation";
                    dtDetails.Columns["ReportingManager"].SetOrdinal(11);
                    dtDetails.Columns["ReportingManager"].Caption = "Reporting Manager";
                    dtDetails.Columns["DomainHead"].SetOrdinal(12);
                    dtDetails.Columns["DomainHead"].Caption = "Domain Head";
                    dtDetails.Columns["ResignationType"].SetOrdinal(13);
                    dtDetails.Columns["ResignationType"].Caption = "Resignation Type";
                    dtDetails.Columns["ResignationDate"].SetOrdinal(14);
                    dtDetails.Columns["ResignationDate"].Caption = "Resignation Date";
                    dtDetails.Columns["LastWorkingDate"].SetOrdinal(15);
                    dtDetails.Columns["LastWorkingDate"].Caption = "Last Working Date";
                    dtDetails.Columns["PMRemark"].SetOrdinal(16);
                    dtDetails.Columns["PMRemark"].Caption = "PM/ System Remark";

                    int ColumnCountStart = sheet.LastColumn;

                    sheet.Range[15, 3].Value = "Note- 0 to 3 months : 100% loss;  4 to 6 months : 50% loss;  7 to 18 months : 25% loss;  18 months & Above : 6 months’ salary  is consider as loss";
                    sheet.Range[15, 3, 15, 12].Merge();
                    sheet.Range[15, 3, 15, 12].Style.Borders.LineStyle = LineStyleType.Thin;
                    sheet.Range[15, 3, 15, 12].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                    sheet.Range[15, 3, 15, 12].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                    sheet.Range[15, 3, 15, 12].Style.Color = System.Drawing.Color.Yellow; ;
                    sheet.Range[15, 3, 15, 12].Style.HorizontalAlignment = HorizontalAlignType.Center;
                    sheet.Range[15, 3, 15, 12].Style.Font.IsBold = true;
                    sheet.Range[15, 3, 15, 12].Style.Font.Size = 11;

                    sheet.InsertDataTable(dtDetails, true, 16, 1);
                    sheet.ListObjects.Create("Details", sheet.Range[16, 1, sheet.LastRow, sheet.LastColumn]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;
                    sheet.ListObjects[0].Columns[5].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    sheet.ListObjects[0].Columns[6].TotalsCalculation = ExcelTotalsCalculation.Sum;
                    int rangeRowCount = RowCount + 3;
                    RowCount = sheet.LastRow;
                    ColumnCount = sheet.LastColumn;
                    string LastColName = GetColumnName(ColumnCount - 1);

                    CellRange dataRange = sheet.Range["A16:" + LastColName + "" + (16 + Convert.ToInt32((dtDetails.Rows.Count)))];
                    Spire.Xls.PivotCache cache = book.PivotCaches.Add(dataRange);
                    PivotTable pt = sheet.PivotTables.Add("Resigned_DomainHead", sheet.Range["B1"], cache);
                    var r1 = pt.PivotFields["Domain Head"];
                    r1.Axis = AxisTypes.Row;
                    pt.Options.RowHeaderCaption = "Domain Head";

                    var r2 = pt.PivotFields["Branch"];
                    r2.Axis = AxisTypes.Column;
                    pt.Options.ColumnHeaderCaption = "Branch";

                    pt.DataFields.Add(pt.PivotFields["Code"], "Employees", SubtotalTypes.Count);
                    pt.DataFields.Add(pt.PivotFields["Loss of Salary"], "Loss of Salaries", SubtotalTypes.Sum);

                    pt.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    pt.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    CellRange range1 = sheet.AllocatedRange;
                    range1.Style.Font.FontName = "Aptos Narrow";
                    range1.Style.Font.Size = 10;
                }
            }
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();

            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int FunFriday()
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;
            #region Fun Friday
            sheet = book.Worksheets.Add("Fun Friday");
            DataTable dtFunFriday = new bllMaster().GetFunFriday(Month, Year);
            if (dtFunFriday != null)
            {
                if (dtFunFriday.Rows.Count > 0)
                {
                    using (DbDataReader dr = dtFunFriday.CreateDataReader())
                    {
                        dtFunFriday = dtFunFriday.Clone();
                        dtFunFriday.Columns.Add(new DataColumn("Sr. #")
                        {
                            AutoIncrement = true,
                            AllowDBNull = false,
                            AutoIncrementSeed = 1,
                            AutoIncrementStep = 1,
                            DataType = typeof(System.Int32),
                            Unique = true
                        });

                        // Change Auto Increment Column Ordinal Position to 0 (ie First Column)
                        dtFunFriday.Columns["Sr. #"].SetOrdinal(0);

                        // Re-load original Data
                        dtFunFriday.Load(dr);
                    }
                    sheet.InsertDataTable(dtFunFriday, true, 1, 1);
                    sheet.Range["A1"].Value = "Sr. #";
                    sheet.Range["B1"].Value = "Date & Day";
                    sheet.Range["C1"].Value = "Activity";
                    sheet.Range["D1"].Value = "Location";
                    sheet.Range["E1"].Value = "Details";
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    string Col = GetColumnName(dtFunFriday.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtFunFriday.Rows.Count + 1)];
                    AllBorder(range);

                }
            }
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            sheet.AllocatedRange.Style.Font.Size = 10;

            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int FunFridaySnaps()
        {
            int returnvalue = 1;
            #region Fun Friday Snaps
            sheet = book.Worksheets.Add("Fun Friday Snaps");
            DataTable dtSnaps = new bllMaster().GetFunFridaySnaps(Month, Year);
            if (dtSnaps != null)
            {
                if (dtSnaps.Rows.Count > 0)
                {
                    sheet.DeleteColumn(1, 100);
                    int rowCount = 0; ;
                    for (int i = 0; i < dtSnaps.Rows.Count; i++)
                    {
                        string Date = "'" + Convert.ToString(dtSnaps.Rows[i]["Date"]);
                        sheet.Range[(rowCount + 1), 1].Value = Date;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Merge();
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.FontName = "Aptos Narrow";
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.Size = 14;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.IsBold = true;

                        rowCount++;

                        string Location = Convert.ToString(dtSnaps.Rows[i]["Location"]);
                        sheet.Range[(rowCount + 1), 1].Value = Location;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Merge();
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.FontName = "Aptos Narrow";
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.Size = 12;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.IsBold = true;

                        rowCount++;

                        string Activity = Convert.ToString(dtSnaps.Rows[i]["Activity"]);
                        sheet.Range[(rowCount + 1), 1].Value = Activity;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 10].Merge();
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 10].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 10].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 10].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 10].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 10].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 10].Style.HorizontalAlignment = HorizontalAlignType.Left;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 10].Style.Font.FontName = "Aptos Narrow";
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 10].Style.Font.Size = 12;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 10].Style.Font.IsBold = true;
                        string SnapsList = Convert.ToString(dtSnaps.Rows[i]["Snaps1"]);
                        //string SnapsList = Server.MapPath(Convert.ToString(dtSnaps.Rows[i]["Snaps"]));
                        string[] Snaps = SnapsList.Split(',');
                        int ColCountPic = 1;

                        //foreach (string snapshot in Snaps)
                        //{
                        //    if (snapshot != "")
                        //    {
                        //        ExcelPicture picture = sheet.Pictures.Add(rowCount + 4, ColCountPic, snapshot);
                        //        picture.Height = 350;
                        //        picture.Width = 350;
                        //        ColCountPic = ColCountPic + 6;
                        //    }
                        //}

                        rowCount = rowCount + 24;
                    }
                }
            }
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            sheet.AllocatedRange.Style.Font.Size = 10;
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int Naukri()
        {
            int returnvalue = 1;
            #region Naukri
            sheet = book.Worksheets.Add("Naukri");

            DataSet dsNaukri = new bllMaster().GetNaukri_New(Month, Year);
            if (dsNaukri != null)
            {
                int RowCount = 0;
                int ColumnCount = 0;

                DataTable dtDetails = dsNaukri.Tables[0];
                if (dtDetails.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtDetails, true, 16, 1);
                    sheet.ListObjects.Create("Detailsnaukri", sheet.Range[16, 1, sheet.LastRow, sheet.LastColumn]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;

                    int rangeRowCount = RowCount + 3;
                    RowCount = sheet.LastRow;
                    ColumnCount = sheet.LastColumn;
                    string LastColName = GetColumnName(ColumnCount - 1);

                    CellRange dataRange = sheet.Range["A16:" + LastColName + "" + (16 + Convert.ToInt32((dtDetails.Rows.Count)))];
                    Spire.Xls.PivotCache cache = book.PivotCaches.Add(dataRange);
                    PivotTable pt = sheet.PivotTables.Add("Naukri_Branch", sheet.Range["A1"], cache);

                    var r1 = pt.PivotFields["Branch"];
                    r1.Axis = AxisTypes.Row;
                    pt.Options.RowHeaderCaption = "Branch";

                    pt.DataFields.Add(pt.PivotFields["Code"], "Employees", SubtotalTypes.Count);

                    pt.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    pt.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;
                }
            }
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();

            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int LinkedIn()
        {
            int returnvalue = 1;
            #region LinkedIn
            sheet = book.Worksheets.Add("LinkedIn");

            DataSet dsLinkedIn = new bllMaster().GetLinkedIn_New(Month, Year);
            if (dsLinkedIn != null)
            {
                int RowCount = 0;
                int ColumnCount = 0;

                DataTable dtDetails = dsLinkedIn.Tables[0];
                if (dtDetails.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtDetails, true, 16, 1);
                    sheet.ListObjects.Create("DetailsLinkedIn", sheet.Range[16, 1, sheet.LastRow, sheet.LastColumn]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;
                    int rangeRowCount = RowCount + 3;
                    RowCount = sheet.LastRow;
                    ColumnCount = sheet.LastColumn;
                    string LastColName = GetColumnName(ColumnCount - 1);

                    CellRange dataRange = sheet.Range["A16:" + LastColName + "" + (16 + Convert.ToInt32((dtDetails.Rows.Count)))];
                    Spire.Xls.PivotCache cache = book.PivotCaches.Add(dataRange);
                    PivotTable pt = sheet.PivotTables.Add("LinkedIn_Branch", sheet.Range["A1"], cache);

                    var r1 = pt.PivotFields["Branch"];
                    r1.Axis = AxisTypes.Row;
                    pt.Options.RowHeaderCaption = "Branch";

                    pt.DataFields.Add(pt.PivotFields["Code"], "Employees", SubtotalTypes.Count);

                    pt.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    pt.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Cambria";
                    sheet.AllocatedRange.Style.Font.Size = 9;

                    CellRange range1 = sheet.AllocatedRange;
                    range1.Style.Font.FontName = "Cambria";
                    range1.Style.Font.Size = 9;
                }
            }
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            sheet.AllocatedRange.Style.Font.Size = 10;

            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();

            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int GlassdoorInfinity()
        {
            int retunvalue = 1;
            #region Glassdoor Infinity
            sheet = book.Worksheets.Add("Glassdoor Infinity");
            DataTable dtGlassInf = new bllMaster().GetGlassdoorReview(Month, Year);
            if (dtGlassInf != null)
            {
                if (dtGlassInf.Rows.Count > 0)
                {
                    using (DbDataReader dr = dtGlassInf.CreateDataReader())
                    {
                        dtGlassInf = dtGlassInf.Clone();
                        dtGlassInf.Columns.Add(new DataColumn("Sr. #")
                        {
                            AutoIncrement = true,
                            AllowDBNull = false,
                            AutoIncrementSeed = 1,
                            AutoIncrementStep = 1,
                            DataType = typeof(System.Int32),
                            Unique = true
                        });

                        // Change Auto Increment Column Ordinal Position to 0 (ie First Column)
                        dtGlassInf.Columns["Sr. #"].SetOrdinal(0);

                        // Re-load original Data
                        dtGlassInf.Load(dr);
                    }

                    dtGlassInf.Columns.Remove("GlassID");
                    dtGlassInf.Columns.Remove("Month");
                    dtGlassInf.Columns.Remove("Year");
                    dtGlassInf.Columns.Remove("NoOfReviews");
                    dtGlassInf.Columns.Remove("NegativeReviews");
                    dtGlassInf.Columns.Remove("AddedBy");
                    dtGlassInf.Columns.Remove("AddedDate");
                    dtGlassInf.Columns.Remove("Attachment");
                    dtGlassInf.Columns["Month1"].Caption = "Month";
                    dtGlassInf.Columns["Month1"].SetOrdinal(1);
                    dtGlassInf.Columns["CompanyRating"].Caption = "Company Rating(out of 5)";
                    dtGlassInf.Columns["CompanyRating"].SetOrdinal(2);

                    sheet.InsertDataTable(dtGlassInf, true, 1, 1);
                    int RCount = sheet.LastRow;
                    int CCount = sheet.LastColumn;
                    string Col = GetColumnName(dtGlassInf.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtGlassInf.Rows.Count + 1)];
                    AllBorder(range);
                    ContentCenter(range);
                    Chart chart = sheet.Charts.Add(ExcelChartType.ColumnClustered);


                    //chart.DataRange = sheet.Range["B2:B" + Convert.ToString(RowCount)];
                    sheet.Range.IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    sheet.Range.NumberFormat = "0.0";

                    chart.SeriesDataFromRange = false;
                    //Chart border  
                    chart.ChartArea.Border.Weight = ChartLineWeightType.Medium;
                    chart.ChartArea.Border.Color = System.Drawing.Color.SandyBrown;
                    //Chart position  
                    chart.LeftColumn = 5;
                    chart.TopRow = 3;
                    chart.RightColumn = sheet.LastColumn + 16;
                    chart.BottomRow = 25;
                    //Chart title  
                    chart.ChartTitle = "Company Rating (out of 5)";
                    chart.ChartTitleArea.Font.FontName = "Aptos Narrow";
                    chart.ChartTitleArea.Font.Size = 13;
                    chart.ChartTitleArea.Font.IsBold = true;
                    //Chart axis  
                    chart.PrimaryCategoryAxis.Title = "Month";
                    chart.PrimaryCategoryAxis.Font.Color = System.Drawing.Color.Blue;
                    chart.PrimaryValueAxis.Title = "Rating";


                    chart.PrimaryValueAxis.HasMajorGridLines = false;
                    //chart.PrimaryValueAxis.MaxValue = 100;
                    chart.PrimaryValueAxis.TitleArea.TextRotationAngle = 90;

                    var cs1 = chart.Series.Add("Rating", ExcelChartType.ColumnClustered);
                    cs1.Values = sheet.Range["C2:C" + Convert.ToString(RCount)];
                    sheet.Range["C2:C" + Convert.ToString(RCount)].ConvertToNumber();

                    foreach (Spire.Xls.Charts.ChartSerie cs in chart.Series)
                    {
                        cs.CategoryLabels = sheet.Range["B2:B" + Convert.ToString(RCount)];
                        cs.DataPoints.DefaultDataPoint.DataLabels.HasValue = true;
                    }
                    chart.Legend.Position = LegendPositionType.Bottom;
                    chart = null;
                }

            }
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            sheet.AllocatedRange.Style.Font.Size = 10;

            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return retunvalue;
        }

        [WebMethod]
        public static int GlassdoorCompetitors()
        {
            int returnvalue = 1;
            #region Glassdoor Competitiors
            sheet = book.Worksheets.Add("Glassdoor Competitiors");
            DataTable dtGlassCom = new bllMaster().GetGlassdoorReviewComp(Month, Year);
            if (dtGlassCom != null)
            {
                if (dtGlassCom.Rows.Count > 0)
                {
                    dtGlassCom.Columns["CompetitorName"].Caption = "Competitor Name";
                    dtGlassCom.Columns["CompetitorName"].SetOrdinal(0);

                    sheet.InsertDataTable(dtGlassCom, true, 1, 1);
                    int RCount = sheet.LastRow;
                    int CCount = sheet.LastColumn;
                    string Col = GetColumnName(dtGlassCom.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtGlassCom.Rows.Count + 1)];
                    AllBorder(range);
                    ContentCenter(range);

                    Chart chart = sheet.Charts.Add(ExcelChartType.ColumnClustered);


                    //chart.DataRange = sheet.Range["B2:B" + Convert.ToString(RowCount)];
                    sheet.Range.IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    sheet.Range.NumberFormat = "0.0";

                    chart.SeriesDataFromRange = false;
                    //Chart border  
                    chart.ChartArea.Border.Weight = ChartLineWeightType.Medium;
                    chart.ChartArea.Border.Color = System.Drawing.Color.SandyBrown;
                    //Chart position  
                    chart.LeftColumn = 6;
                    chart.TopRow = 3;
                    chart.RightColumn = sheet.LastColumn + 16;
                    chart.BottomRow = 25;
                    //Chart title  
                    chart.ChartTitle = "Infinity's Competitors Glass Door Ratings";
                    chart.ChartTitleArea.Font.FontName = "Aptos Narrow";
                    chart.ChartTitleArea.Font.Size = 13;
                    chart.ChartTitleArea.Font.IsBold = true;
                    //Chart axis  
                    chart.PrimaryCategoryAxis.Title = "Competitors";
                    chart.PrimaryCategoryAxis.Font.Color = System.Drawing.Color.Blue;
                    chart.PrimaryValueAxis.Title = "Rating";


                    chart.PrimaryValueAxis.HasMajorGridLines = false;
                    //chart.PrimaryValueAxis.MaxValue = 100;
                    chart.PrimaryValueAxis.TitleArea.TextRotationAngle = 90;

                    var cs2 = chart.Series.Add(sheet.Range["B1"].Value, ExcelChartType.ColumnClustered);
                    cs2.Values = sheet.Range["B2:B" + Convert.ToString(RCount)];
                    sheet.Range["B2:B" + Convert.ToString(RCount)].ConvertToNumber();

                    var cs3 = chart.Series.Add(sheet.Range["C1"].Value, ExcelChartType.ColumnClustered);
                    cs3.Values = sheet.Range["C2:C" + Convert.ToString(RCount)];
                    sheet.Range["C2:C" + Convert.ToString(RCount)].ConvertToNumber();

                    var cs4 = chart.Series.Add(sheet.Range["D1"].Value, ExcelChartType.ScatterLine);
                    cs4.Values = sheet.Range["D2:D" + Convert.ToString(RCount)];
                    sheet.Range["D2:D" + Convert.ToString(RCount)].ConvertToNumber();

                    cs4.UsePrimaryAxis = false;

                    foreach (Spire.Xls.Charts.ChartSerie cs in chart.Series)
                    {
                        cs.CategoryLabels = sheet.Range["A2:A" + Convert.ToString(RCount - 1)];
                        cs.DataPoints.DefaultDataPoint.DataLabels.HasValue = true;
                    }
                    chart.Legend.Position = LegendPositionType.Bottom;
                    chart = null;
                }
            }
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            sheet.AllocatedRange.Style.Font.Size = 10;
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int RnR()
        {
            int returnvalue = 1;
            #region R & R
            sheet = book.Worksheets.Add("R&R");
            DataTable dtRR = new bllMaster().GetRnR();
            if (dtRR != null)
            {
                if (dtRR.Rows.Count > 0)
                {
                    dtRR.Columns.Remove("tableID");
                    dtRR.Columns.Remove("EmployeeID");
                    dtRR.Columns.Remove("Tenure");
                    dtRR.Columns["Code"].SetOrdinal(0);
                    dtRR.Columns["Name"].SetOrdinal(1);
                    dtRR.Columns["Name"].Caption = "Employee Name";
                    dtRR.Columns["JoiningDate"].SetOrdinal(2);
                    dtRR.Columns["JoiningDate"].Caption = "Joining Date";
                    dtRR.Columns["DateofBirth"].SetOrdinal(3);
                    dtRR.Columns["DateofBirth"].Caption = "Date Of Birth";
                    dtRR.Columns["Quarter"].SetOrdinal(4);
                    dtRR.Columns["Branch"].SetOrdinal(5);
                    dtRR.Columns["Domain"].SetOrdinal(6);
                    dtRR.Columns["Subdomain"].SetOrdinal(7);
                    dtRR.Columns["Department"].SetOrdinal(8);
                    dtRR.Columns["Designation"].SetOrdinal(9);
                    dtRR.Columns["ReportingManager"].SetOrdinal(10);
                    dtRR.Columns["ReportingManager"].Caption = "Reporting Manager";
                    dtRR.Columns["CurrentStatus"].SetOrdinal(11);
                    dtRR.Columns["CurrentStatus"].Caption = "Current Status";
                    dtRR.Columns["LatestLoginDate"].SetOrdinal(12);
                    dtRR.Columns["LatestLoginDate"].Caption = "Latest Login Date";
                    dtRR.Columns["DailyTaskProductivity"].SetOrdinal(13);
                    dtRR.Columns["DailyTaskProductivity"].Caption = "Productivity/Task";
                    dtRR.Columns["FinalStatus"].SetOrdinal(14);
                    dtRR.Columns["FinalStatus"].Caption = "Final Status";

                    sheet.InsertDataTable(dtRR, true, 1, 1);

                    string Col = GetColumnName(dtRR.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtRR.Rows.Count + 1)];
                    AllBorder(range);
                    ContentCenter(range);

                    sheet.InsertRow(1, 25);
                    CellRange dataRangeRR = sheet.Range["A26:O" + sheet.LastRow];
                    Spire.Xls.PivotCache cacheRR = book.PivotCaches.Add(dataRangeRR);
                    PivotTable ptRR = sheet.PivotTables.Add("RnR_Branch", sheet.Range["B1"], cacheRR);

                    var rRR = ptRR.PivotFields["Quarter"];
                    rRR.Axis = AxisTypes.Row;
                    ptRR.Options.RowHeaderCaption = "Quarter";

                    var yRR = ptRR.PivotFields["Branch"];
                    yRR.Axis = AxisTypes.Column;
                    ptRR.Options.ColumnHeaderCaption = "Branch";


                    ptRR.DataFields.Add(ptRR.PivotFields["Code"], "Quarter Wise Report", SubtotalTypes.Count);
                    ptRR.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptRR.CalculateData();

                    int PCount = sheet.LastRow;

                    PivotTable ptRR1 = sheet.PivotTables.Add("RnR_Final_Status", sheet.Range["B10"], cacheRR);

                    var rRR1 = ptRR1.PivotFields["Quarter"];
                    rRR1.Axis = AxisTypes.Row;
                    ptRR1.Options.RowHeaderCaption = "Quarter";

                    var yRR1 = ptRR1.PivotFields["Final Status"];
                    yRR1.Axis = AxisTypes.Column;
                    ptRR1.Options.ColumnHeaderCaption = "Final Status";


                    ptRR1.DataFields.Add(ptRR1.PivotFields["Code"], "Final Status Wise Report", SubtotalTypes.Count);
                    ptRR1.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptRR1.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;
                }
            }
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int RnRSnaps()
        {
            int returnvalue = 1;
            #region R & R Snaps
            sheet = book.Worksheets.Add("R&R Snaps");

            DataTable dtRnRSnap = new bllMaster().GetRRSnaps();
            if (dtRnRSnap != null)
            {
                if (dtRnRSnap.Rows.Count > 0)
                {
                    sheet.DeleteColumn(1, 100);
                    int rowCount = 0; ;
                    for (int i = 0; i < dtRnRSnap.Rows.Count; i++)
                    {
                        string Date = "'" + Convert.ToString(dtRnRSnap.Rows[i]["Year"]);
                        sheet.Range[(rowCount + 1), 1].Value = Date;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Merge();
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.FontName = "Aptos Narrow";
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.Size = 13;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.IsBold = true;

                        rowCount++;

                        string Location = Convert.ToString(dtRnRSnap.Rows[i]["Quarter"]);
                        sheet.Range[(rowCount + 1), 1].Value = Location;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Merge();
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders.LineStyle = LineStyleType.Thin;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.Color = System.Drawing.Color.White;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.HorizontalAlignment = HorizontalAlignType.Center;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.FontName = "Aptos Narrow";
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.Size = 12;
                        sheet.Range[(rowCount + 1), 1, (rowCount + 1), 5].Style.Font.IsBold = true;
                        string SnapsList = Convert.ToString(dtRnRSnap.Rows[i]["Snaps"]);
                        string[] Snaps = SnapsList.Split(',');
                        int ColCountPic = 1;

                        //foreach (string snapshot in Snaps)
                        //{
                        //    if (snapshot != "")
                        //    {
                        //        ExcelPicture picture = sheet.Pictures.Add(rowCount + 4, ColCountPic, snapshot);
                        //        picture.Height = 350;
                        //        picture.Width = 350;
                        //        ColCountPic = ColCountPic + 6;
                        //    }
                        //}

                        rowCount = rowCount + 24;
                    }
                }
            }
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
            sheet.AllocatedRange.Style.Font.Size = 10;
            //sheet.AllocatedRange.AutoFitColumns();
            //sheet.AllocatedRange.AutoFitRows();

            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int StamppaperPurchase()
        {
            int returnvalue = 1;
            #region Stamp Paper Purchase

            sheet = book.Worksheets.Add("Stamp Paper Purchase");
            DataTable dtInvoice = new bllMaster().getInvoiceData_Report(Month, Year);
            if (dtInvoice != null)
            {
                if (dtInvoice.Rows.Count > 0)
                {
                    using (DbDataReader dr = dtInvoice.CreateDataReader())
                    {
                        dtInvoice = dtInvoice.Clone();
                        dtInvoice.Columns.Add(new DataColumn("Sr. #")
                        {
                            AutoIncrement = true,
                            AllowDBNull = false,
                            AutoIncrementSeed = 1,
                            AutoIncrementStep = 1,
                            DataType = typeof(System.Int32),
                            Unique = true
                        });

                        // Change Auto Increment Column Ordinal Position to 0 (ie First Column)
                        dtInvoice.Columns["Sr. #"].SetOrdinal(0);

                        // Re-load original Data
                        dtInvoice.Load(dr);
                    }

                    dtInvoice.Columns.Remove("Remark");
                    dtInvoice.Columns["BranchName"].SetOrdinal(1);
                    dtInvoice.Columns["BranchName"].Caption = "Branch";
                    dtInvoice.Columns["Code"].SetOrdinal(2);
                    dtInvoice.Columns["Name"].SetOrdinal(3);
                    dtInvoice.Columns["Remark1"].SetOrdinal(4);
                    dtInvoice.Columns["Remark1"].Caption = "Remark";
                    dtInvoice.Columns["Agreement"].SetOrdinal(5);
                    dtInvoice.Columns["Addendum"].SetOrdinal(6);
                    dtInvoice.Columns["undertaking"].SetOrdinal(7);
                    dtInvoice.Columns["undertaking"].Caption = "Undertaking";
                    dtInvoice.Columns["StampPapersUsed"].SetOrdinal(8);
                    dtInvoice.Columns["StampPapersUsed"].Caption = "No. of Stamps Used";
                    dtInvoice.Columns["Cost"].SetOrdinal(9);
                    dtInvoice.Columns["Dept/Desg"].SetOrdinal(10);
                    dtInvoice.Columns["Dept/Desg"].Caption = "Dept./Design";
                    dtInvoice.Columns["Version"].SetOrdinal(11);
                    dtInvoice.Columns["StampPaperNo"].SetOrdinal(12);
                    dtInvoice.Columns["StampPaperNo"].Caption = "Stamp Paper #";
                    dtInvoice.Columns["ReceivedDate"].SetOrdinal(13);
                    dtInvoice.Columns["ReceivedDate"].Caption = "Date of Purchase";

                    sheet.InsertDataTable(dtInvoice, true, 1, 1);

                    sheet.InsertRow(1, 15);
                    sheet.ListObjects.Create("Details", sheet.Range["A16:N" + sheet.LastRow]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[2].TotalsCalculation = ExcelTotalsCalculation.Count;

                    sheet.Range[15, 6].Value = "Joining";
                    sheet.Range[15, 6, 15, 7].Merge();
                    sheet.Range[15, 6, 15, 7].Style.Borders.LineStyle = LineStyleType.Thin;
                    sheet.Range[15, 6, 15, 7].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                    sheet.Range[15, 6, 15, 7].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                    sheet.Range[15, 6, 15, 7].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                    sheet.Range[15, 6, 15, 7].Style.Font.Color = System.Drawing.Color.White;
                    sheet.Range[15, 6, 15, 7].Style.HorizontalAlignment = HorizontalAlignType.Center;
                    sheet.Range[15, 6, 15, 7].Style.Font.IsBold = true;

                    sheet.Range[15, 8].Value = "Exit";
                    sheet.Range[15, 8].Style.Borders.LineStyle = LineStyleType.Thin;
                    sheet.Range[15, 8].Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                    sheet.Range[15, 8].Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                    sheet.Range[15, 8].Style.Color = System.Drawing.Color.FromArgb(113, 147, 209);
                    sheet.Range[15, 8].Style.Font.Color = System.Drawing.Color.White;
                    sheet.Range[15, 8].Style.HorizontalAlignment = HorizontalAlignType.Center;
                    sheet.Range[15, 8].Style.Font.IsBold = true;

                    sheet.Range["J17:J" + sheet.LastRow].ConvertToNumber();
                    sheet.Range["J17:J" + sheet.LastRow].NumberFormat = "0";

                    CellRange dataRange2211 = sheet.Range["A16:N" + (sheet.LastRow - 1)];
                    Spire.Xls.PivotCache cache2211 = book.PivotCaches.Add(dataRange2211);
                    PivotTable pt2211 = sheet.PivotTables.Add("Stamp_Branch", sheet.Range["C1"], cache2211);

                    var r1311 = pt2211.PivotFields["Branch"];
                    r1311.Axis = AxisTypes.Row;
                    pt2211.Options.RowHeaderCaption = "Branch";

                    pt2211.DataFields.Add(pt2211.PivotFields["Code"], "Employees", SubtotalTypes.Count);
                    pt2211.DataFields.Add(pt2211.PivotFields["Cost"], "Total Cost", SubtotalTypes.Sum);
                    pt2211.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    pt2211.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;


                    //dataRange2211 = sheet.Range["A16:N" + sheet.LastRow];
                    Spire.Xls.PivotCache cache22112 = book.PivotCaches.Add(dataRange2211);
                    PivotTable pt22113 = sheet.PivotTables.Add("Stamp_Document", sheet.Range["G1"], cache22112);

                    var r13112 = pt22113.PivotFields["Remark"];
                    r13112.Axis = AxisTypes.Row;
                    pt22113.Options.RowHeaderCaption = "Document";

                    pt22113.DataFields.Add(pt22113.PivotFields["Code"], "Employees", SubtotalTypes.Count);
                    pt22113.DataFields.Add(pt22113.PivotFields["Cost"], "Total Cost", SubtotalTypes.Sum);

                    pt22113.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    pt22113.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                }
            }
            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int MasterData()
        {
            int returnvalue = 1;
            #region DD Master
            sheet = book.Worksheets.Add("DD Master");
            DataTable dtMaster = new bllMaster().GetMastDataFrHRReport();
            dtMaster.Columns.Remove("tableID");
            dtMaster.Columns.Remove("Addendum 1 Reason");
            dtMaster.Columns.Remove("Addendum 2 Reason");
            dtMaster.Columns.Remove("Addendum 2.5 Reason");
            dtMaster.Columns.Remove("Client List Signed Date");
            dtMaster.Columns["ScannedCopy"].SetOrdinal(95);
            dtMaster.Columns["ScannedCopy"].Caption = "Scanned Copy?";

            DataView dw = dtMaster.DefaultView;
            dw.RowFilter = "Domain='Underwriting'";
            DataTable dtDD = dw.ToTable();
            if (dtDD != null)
            {
                if (dtDD.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtDD, true, 2, 1);
                    string Col = GetColumnName(dtDD.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "2"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtDD.Rows.Count + 2)];
                    AllBorder(range);
                    for (int i = 1; i <= 23; i++)
                    {
                        string ColMerge = GetColumnName(i - 1);
                        sheet.Range[ColMerge + "1:" + ColMerge + "2"].Merge();
                    }

                    ////Agreement 2017
                    int loopcol = 24;
                    string Header = GetColumnName(loopcol - 1);
                    string Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2017";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";

                    ////Agreement 2018
                    loopcol = 28;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2018";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";

                    ////Agreement 2018
                    loopcol = 32;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2019";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";

                    ////Agreement 1.1
                    loopcol = 36;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 1.1";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";

                    ////Agreement 2.0
                    loopcol = 40;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2.0";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";

                    ////Agreement 2.8.5
                    loopcol = 44;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2.8.5";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Agreement 2.9
                    loopcol = 51;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2.9";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Agreement 3.0
                    loopcol = 58;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 3.0";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Addendum 1.0
                    loopcol = 65;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Addendum 1.0";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Signed Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Addendum 2.0
                    loopcol = 71;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Addendum 2.0";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Signed Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Addendum 2.50
                    loopcol = 77;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Addendum 2.5";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Signed Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Client List
                    loopcol = 83;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Client List";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Status";

                    ////Psuedoname
                    loopcol = 85;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Pseudo name";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Pseudo name";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Status";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Acknowledgement Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Penalty for Breach – Psudoname Undertaking";

                    ////Undertaking
                    loopcol = 89;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Undertaking";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Signed Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Cost";

                    ////File Tracker
                    loopcol = 93;
                    Header = GetColumnName(loopcol - 1);
                    //Header2 = GetColumnName(loopcol + 2);
                    //sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1"].Value = "File Tracker";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "File #";

                    ////US Visa
                    loopcol = 94;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "US Visa";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Visa #";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Valid Till";

                    ////Scanned Copy
                    loopcol = 96;
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "" + "1" + ":" + Header + "2"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header + "2"].Value = "Scanned Copy?";


                    //sheet.InsertRow(1, 14);

                    //int RowCnt = sheet.LastRow;
                    //int ColCnt = sheet.LastColumn;
                    //string LastColName1 = GetColumnName(sheet.LastColumn - 1);


                    //CellRange dataRange22 = sheet.Range["A15:L" + (sheet.LastRow - 1)];
                    //Spire.Xls.PivotCache cache22 = book.PivotCaches.Add(dataRange22);
                    //PivotTable pt22 = sheet.PivotTables.Add("Branch", sheet.Range["C1"], cache22);

                    //var r13 = pt22.PivotFields[6];
                    //r13.Axis = AxisTypes.Row;
                    //pt22.Options.RowHeaderCaption = "Branch";

                    //pt22.DataFields.Add(pt22.PivotFields[1], "Employees", SubtotalTypes.Count);

                    //pt22.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    //pt22.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }
            #endregion

            #region Non DD Master

            sheet = book.Worksheets.Add("Non DD Master");
            dw = null;
            dw = dtMaster.DefaultView;
            dw.RowFilter = "Domain not in ('Underwriting')";
            DataTable dtNonDD = dw.ToTable();
            if (dtNonDD != null)
            {
                if (dtNonDD.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtNonDD, true, 1, 1);
                    string Col = GetColumnName(dtNonDD.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "2"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtNonDD.Rows.Count + 2)];
                    AllBorder(range);
                    for (int i = 1; i <= 23; i++)
                    {
                        string ColMerge = GetColumnName(i - 1);
                        sheet.Range[ColMerge + "1:" + ColMerge + "2"].Merge();
                    }

                    ////Agreement 2017
                    int loopcol = 24;
                    string Header = GetColumnName(loopcol - 1);
                    string Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2017";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";

                    ////Agreement 2018
                    loopcol = 28;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2018";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";

                    ////Agreement 2018
                    loopcol = 32;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2019";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";

                    ////Agreement 1.1
                    loopcol = 36;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 1.1";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";

                    ////Agreement 2.0
                    loopcol = 40;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2.0";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";

                    ////Agreement 2.8.5
                    loopcol = 44;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2.8.5";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Agreement 2.9
                    loopcol = 51;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 2.9";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Agreement 3.0
                    loopcol = 58;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Agreement 3.0";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Expiry Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 5);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Addendum 1.0
                    loopcol = 65;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Addendum 1.0";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Signed Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Addendum 2.0
                    loopcol = 71;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Addendum 2.0";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Signed Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Addendum 2.50
                    loopcol = 77;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Addendum 2.5";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Signed Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Clause Name";
                    Header = GetColumnName(loopcol + 3);
                    sheet.Range[Header + "2"].Value = "Clause #";
                    Header = GetColumnName(loopcol + 4);
                    sheet.Range[Header + "2"].Value = "Penalty for breaching clause";

                    ////Client List
                    loopcol = 83;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Client List";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Status";

                    ////Psuedoname
                    loopcol = 85;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Pseudo name";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Pseudo name";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Agreement Status";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Acknowledgement Date";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Penalty for Breach – Psudoname Undertaking";

                    ////Undertaking
                    loopcol = 89;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "Undertaking";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Version";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Signed Date";
                    Header = GetColumnName(loopcol + 1);
                    sheet.Range[Header + "2"].Value = "Stamp Paper #";
                    Header = GetColumnName(loopcol + 2);
                    sheet.Range[Header + "2"].Value = "Cost";

                    ////File Tracker
                    loopcol = 93;
                    Header = GetColumnName(loopcol - 1);
                    //Header2 = GetColumnName(loopcol + 2);
                    //sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1"].Value = "File Tracker";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "File #";

                    ////US Visa
                    loopcol = 94;
                    Header = GetColumnName(loopcol - 1);
                    Header2 = GetColumnName(loopcol);
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header2 + "1"].Value = "US Visa";
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "2"].Value = "Visa #";
                    Header = GetColumnName(loopcol);
                    sheet.Range[Header + "2"].Value = "Valid Till";

                    ////Scanned Copy
                    loopcol = 96;
                    Header = GetColumnName(loopcol - 1);
                    sheet.Range[Header + "" + "1" + ":" + Header + "2"].Merge();
                    sheet.Range[Header + "" + "1" + ":" + Header + "2"].Value = "Scanned Copy?";


                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }

            #endregion

            return returnvalue;
        }

        [WebMethod]
        public static int HRInductionReport()
        {
            int returnvalue = 1;
            #region HR Induction Report
            sheet = book.Worksheets.Add("HR Induction Report");
            DataTable dtHR = new bllMaster().GetHRCheckQuestionPaper_Report(Month, Year);
            if (dtHR != null)
            {
                if (dtHR.Rows.Count > 0)
                {
                    dtHR.Columns.Remove("EmployeeID");
                    dtHR.AcceptChanges();
                    sheet.InsertDataTable(dtHR, true, 1, 1);
                    string Col = GetColumnName(dtHR.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtHR.Rows.Count + 1)];
                    AllBorder(range);

                    sheet.InsertRow(1, 15);

                    sheet.ListObjects.Create("Details", sheet.Range["A16:O" + sheet.LastRow]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;

                    CellRange dataRangeInduction = sheet.Range["A16:O" + (sheet.LastRow - 1)];
                    Spire.Xls.PivotCache cacheInduction = book.PivotCaches.Add(dataRangeInduction);
                    PivotTable ptInduction = sheet.PivotTables.Add("HRInduction_Branch", sheet.Range["C1"], cacheInduction);


                    var rInduction = ptInduction.PivotFields["Branch"];
                    rInduction.Axis = AxisTypes.Row;
                    ptInduction.Options.RowHeaderCaption = "Branch";

                    var yInduction = ptInduction.PivotFields["Result"];
                    yInduction.Axis = AxisTypes.Column;
                    ptInduction.Options.ColumnHeaderCaption = "Result";


                    ptInduction.DataFields.Add(ptInduction.PivotFields["Code"], "Summary", SubtotalTypes.Count);
                    ptInduction.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptInduction.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int NewJoineeFollowUp()
        {
            int returnvalue = 1;
            #region New Joinee Followup
            sheet = book.Worksheets.Add("New Joinee Followup");
            DataTable dtfol = new bllMaster().GetNewJoineeFollowUp(Month, Year);
            if (dtfol != null)
            {
                if (dtfol.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtfol, true, 1, 1);
                    string Col = GetColumnName(dtfol.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtfol.Rows.Count + 1)];
                    AllBorder(range);

                    sheet.InsertRow(1, 14);
                    sheet.ListObjects.Create("Details", sheet.Range["A15:K" + sheet.LastRow]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;

                    CellRange dataRangeFollowup = sheet.Range["A15:K" + (sheet.LastRow - 1)];
                    Spire.Xls.PivotCache cacheFollowup = book.PivotCaches.Add(dataRangeFollowup);
                    PivotTable ptFollowup = sheet.PivotTables.Add("NewJoinee_Branch", sheet.Range["C1"], cacheFollowup);

                    var rFollowup = ptFollowup.PivotFields["Branch"];
                    rFollowup.Axis = AxisTypes.Row;
                    ptFollowup.Options.RowHeaderCaption = "Branch";

                    ptFollowup.DataFields.Add(ptFollowup.PivotFields["Code"], "Employees", SubtotalTypes.Count);

                    ptFollowup.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptFollowup.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Cambria";
                    sheet.AllocatedRange.Style.Font.Size = 9;


                    //dataRangeFollowup = sheet.Range["A15:L" + sheet.LastRow];
                    //Spire.Xls.PivotCache cacheFollow = book.PivotCaches.Add(dataRange221);
                    ptFollowup = sheet.PivotTables.Add("NewJoinee_Domain", sheet.Range["G1"], cacheFollowup);

                    rFollowup = ptFollowup.PivotFields["Domain"];
                    rFollowup.Axis = AxisTypes.Row;
                    ptFollowup.Options.RowHeaderCaption = "Domain";

                    ptFollowup.DataFields.Add(ptFollowup.PivotFields["Code"], "Employees", SubtotalTypes.Count);

                    ptFollowup.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptFollowup.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }
            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int AddressVerification()
        {
            int returnvalue = 1;
            #region Address Verification
            sheet = book.Worksheets.Add("Address Verification");
            DataTable dtadd = new bllMaster().GetAddressVerification(Month, Year);
            if (dtadd != null)
            {
                if (dtadd.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtadd, true, 1, 1);
                    string Col = GetColumnName(dtadd.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtadd.Rows.Count + 1)];
                    AllBorder(range);

                    sheet.InsertRow(1, 14);
                    sheet.ListObjects.Create("Details", sheet.Range["A15:J" + sheet.LastRow]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;

                    CellRange dataRangeAV = sheet.Range["A15:J" + (sheet.LastRow - 1)];
                    Spire.Xls.PivotCache cacheAV = book.PivotCaches.Add(dataRangeAV);
                    PivotTable ptAV = sheet.PivotTables.Add("AddressVerification_Branch", sheet.Range["C1"], cacheAV);

                    var rAV = ptAV.PivotFields["Branch"];
                    rAV.Axis = AxisTypes.Row;
                    ptAV.Options.RowHeaderCaption = "Branch";

                    ptAV.DataFields.Add(ptAV.PivotFields["Code"], "Employees", SubtotalTypes.Count);

                    ptAV.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptAV.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }

            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int ExitEmployees()
        {
            int returnvalue = 1;
            #region Exit Employees
            sheet = book.Worksheets.Add("Exit Employees");
            DataTable dtExit = new bllMaster().GetEmployeesForExit();
            if (dtExit != null)
            {
                if (dtExit.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtExit, true, 1, 1);
                    string Col = GetColumnName(dtExit.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtExit.Rows.Count + 1)];
                    AllBorder(range);

                    sheet.InsertRow(1, 14);
                    sheet.ListObjects.Create("Details", sheet.Range["A15:P" + sheet.LastRow]);
                    sheet.ListObjects[0].BuiltInTableStyle = TableBuiltInStyles.TableStyleLight9;
                    sheet.ListObjects[0].DisplayTotalRow = true;
                    sheet.ListObjects[0].Columns[1].TotalsCalculation = ExcelTotalsCalculation.Count;

                    CellRange dataRangeExit = sheet.Range["A15:P" + (sheet.LastRow - 1)];
                    Spire.Xls.PivotCache cacheExit = book.PivotCaches.Add(dataRangeExit);
                    PivotTable ptExit = sheet.PivotTables.Add("Exit_Branch", sheet.Range["C1"], cacheExit);

                    var rExit = ptExit.PivotFields["Branch"];
                    rExit.Axis = AxisTypes.Row;
                    ptExit.Options.RowHeaderCaption = "Branch";

                    ptExit.DataFields.Add(ptExit.PivotFields["Code"], "Employees", SubtotalTypes.Count);

                    ptExit.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptExit.CalculateData();

                    CellRange dataRangeExitRemark = sheet.Range["A15:P" + (sheet.LastRow - 1)];
                    Spire.Xls.PivotCache cacheExitRemark = book.PivotCaches.Add(dataRangeExitRemark);
                    PivotTable ptExitRemark = sheet.PivotTables.Add("Exit_Remark", sheet.Range["F1"], cacheExitRemark);

                    var rExitRemark = ptExitRemark.PivotFields["Branch"];
                    rExitRemark.Axis = AxisTypes.Row;
                    ptExitRemark.Options.RowHeaderCaption = "Branch";

                    var rExitRemark1 = ptExitRemark.PivotFields["Remark"];
                    rExitRemark1.Axis = AxisTypes.Column;
                    ptExitRemark.Options.ColumnHeaderCaption = "Remark";

                    ptExitRemark.DataFields.Add(ptExitRemark.PivotFields["Code"], "Remark wise details", SubtotalTypes.Count);

                    ptExitRemark.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptExitRemark.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }

            #endregion
            return returnvalue;
        }

        [WebMethod]
        public static int TicketReport()
        {
            int returnvalue = 1;
            #region Ticket Report
            sheet = book.Worksheets.Add("Ticket Report");
            DataTable dtTicket = new bllMaster().GetHR_TicketReport(Month, Year);
            if (dtTicket != null)
            {
                if (dtTicket.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtTicket, true, 1, 1);
                    string Col = GetColumnName(dtTicket.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtTicket.Rows.Count + 1)];
                    AllBorder(range);

                    sheet.InsertRow(1, 14);

                    CellRange dataRangeExit = sheet.Range["A15:G" + (sheet.LastRow)];
                    Spire.Xls.PivotCache cacheExit = book.PivotCaches.Add(dataRangeExit);
                    PivotTable ptExit = sheet.PivotTables.Add("Ticket_Branch", sheet.Range["B1"], cacheExit);

                    var rExit = ptExit.PivotFields["Status"];
                    rExit.Axis = AxisTypes.Row;
                    ptExit.Options.RowHeaderCaption = "Status";

                    ptExit.DataFields.Add(ptExit.PivotFields["Ticket #"], "Count of Ticket #", SubtotalTypes.Count);

                    ptExit.BuiltInStyle = PivotBuiltInStyles.PivotStyleLight16;
                    ptExit.CalculateData();

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();

                    //if (File.Exists(FileName))
                    //{
                    //    try
                    //    {
                    //        File.Delete(FileName);
                    //    }
                    //    catch { }
                    //}
                    //book.SaveToFile(FileName, ExcelVersion.Version2010);
                }
            }
            #endregion
            return returnvalue;
        }


        [WebMethod]
        public static int EditDashboard()
        {
            int returnvalue = 1;
            int RecSumCount = 0;
            #region Edit in Dashboard

            sheet = book.Worksheets["Dashboard"];

            sheet.Pictures.Add(3, 1, 5, 2, (HttpContext.Current.Server.MapPath("../images/logo.png")));
            sheet.Pictures.Add(2, 9, 7, 9, (HttpContext.Current.Server.MapPath("../images/HRReportHeaderImage.png")));
            ITextBoxShape shp = sheet.TextBoxes.AddTextBox(3, 3, 50, 400);
            shp.Text = "HR Report " + Month + "'" + Year.Substring(2, 2);
            shp.Fill.FillType = ShapeFillType.NoFill;
            shp.Line.Visible = false;
            shp.HAlignment = CommentHAlignType.Center;

            ExcelFont font = book.CreateFont();
            font.FontName = "Aptos Narrow";
            font.Size = 32;
            font.IsBold = true;
            font.Color = System.Drawing.Color.FromArgb(119, 147, 60);
            font.IsItalic = true;
            (new RichText(shp.RichText)).SetFont(0, shp.Text.Length - 1, font);

            sheet.Range["A1:J7"].Merge();
            //AllBorder(sheet.Range["A1:J7"]);

            //Header - Dashboard
            sheet.Range["A9"].Value = "Dashboard";
            sheet.Range["A9"].Style.HorizontalAlignment = HorizontalAlignType.Center;
            sheet.Range["A9"].Style.Font.Size = 24;
            sheet.Range["A9"].Style.Font.IsBold = true;
            sheet.Range["A9"].Style.Font.IsItalic = true;
            sheet.Range["A9:J9"].Merge();
            AllBorder(sheet.Range["A9:J9"]);
            HeaderFormat(sheet.Range["A9:J9"]);
            sheet.Range["A9:J9"].Style.Color = System.Drawing.Color.FromArgb(54, 96, 146);


            //Header - Options
            sheet.Range["A10"].Value = "Sr. #";
            sheet.Range["B10"].Value = "Particulars";
            sheet.Range["C10"].Value = "Link";
            sheet.Range["D10"].Value = "Status";
            sheet.Range["E10"].Value = "Target";
            sheet.Range["F10"].Value = "Completed";
            sheet.Range["G10"].Value = "Pending";
            sheet.Range["H10"].Value = "% Done";
            sheet.Range["I10"].Value = "Fixed Cost (In Rs.)";
            sheet.Range["J10"].Value = "Remarks";
            DashboardHeader(sheet.Range["A10:J10"]);
            HeaderFormat(sheet.Range["A10:J10"]);

            //Content - 1st Line
            sheet.Range["A11"].Value = "1";
            sheet.Range["B11"].Value = "Recruitment Summary";
            CellRange pertrange = sheet.Range["C11"];
            Spire.Xls.HyperLink lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Recruitment Summary";
            lnk.Address = "'Recruitment Summary'!A1";
            sheet.Range["D11"].Value = "Completed";
            //Details
            Spire.Xls.Worksheet recsheet = book.Worksheets["Recruitment Summary"];
            CellRange recRange = recsheet.Range["A15:A" + (recsheet.LastRow - 1)];
            int rectarget = recRange.CellsCount;
            sheet.Range["E11"].Value = "" + RecSumCount;
            sheet.Range["F11"].Value = "" + RecSumCount;
            sheet.Range["G11"].Value = "0";
            sheet.Range["H11"].Formula = "=ROUND(F11/E11*100,0)";
            sheet.Range["I11"].Value = "=SUM('Recruitment Summary'!N15:N" + (recsheet.LastRow - 1) + ")";
            sheet.Range["J11"].Value = "";

            //Content - 2nd Line
            sheet.Range["A12"].Value = "2";
            sheet.Range["B12"].Value = "Hiring";
            pertrange = sheet.Range["C12"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Hiring";
            lnk.Address = "Hiring!A1";
            sheet.Range["D12"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["Hiring"];
            recRange = recsheet.Range["A17:A" + (recsheet.LastRow - 1)];
            rectarget = recRange.CellsCount;
            sheet.Range["E12"].Value = "" + rectarget;
            sheet.Range["F12"].Value = "" + rectarget;
            sheet.Range["G12"].Value = "0";
            sheet.Range["H12"].Formula = "=ROUND(F12/E12*100,0)";
            sheet.Range["I12"].Value = "=SUM('Hiring'!F17:F" + (recsheet.LastRow - 1) + ")";
            sheet.Range["J12"].Value = "";

            //Content - 3rd Line
            sheet.Range["A13"].Value = "3";
            sheet.Range["B13"].Value = "Manpower";
            pertrange = sheet.Range["C13"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Manpower";
            lnk.Address = "Manpower!A1";
            sheet.Range["D13"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["Manpower"];
            recRange = recsheet.Range["A17:A" + (recsheet.LastRow - 1)];
            rectarget = recRange.CellsCount;
            sheet.Range["E13"].Value = "" + rectarget;
            sheet.Range["F13"].Value = "" + rectarget;
            sheet.Range["G13"].Value = "0";
            sheet.Range["H13"].Formula = "=ROUND(F13/E13*100,0)";
            sheet.Range["I13"].Value = "=SUM('Manpower'!F17:F" + (recsheet.LastRow - 1) + ")";
            sheet.Range["J13"].Value = "";

            //Content - 4th Line
            sheet.Range["A14"].Value = "4";
            sheet.Range["B14"].Value = "Skip Level";
            pertrange = sheet.Range["C14"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Skip Level";
            lnk.Address = "'Skip Level'!A1";
            sheet.Range["D14"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["Skip Level"];
            string rec1target = "";
            string reccompleted = "";
            string recpending = "";
            sheet.Range["E14"].Formula = "=SUBTOTAL(109,'Skip Level'!G2:G" + (recsheet.LastRow - 1) + ")";
            sheet.Range["F14"].Formula = "=SUBTOTAL(109,'Skip Level'!H2:H" + (recsheet.LastRow - 1) + ")";
            sheet.Range["G14"].Formula = "=SUBTOTAL(109,'Skip Level'!I2:I" + (recsheet.LastRow - 1) + ")";
            sheet.Range["H14"].Formula = "=ROUND(F14/E14*100,0)";
            sheet.Range["I14"].Value = "";
            sheet.Range["J14"].Value = "";

            //Content - 5th Line
            sheet.Range["A15"].Value = "5";
            sheet.Range["B15"].Value = "Skip - Ratings";
            pertrange = sheet.Range["C15"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Skip - Ratings";
            lnk.Address = "'Skip - Ratings'!A1";
            sheet.Range["D15"].Value = "Completed";
            sheet.Range["E15"].Value = "";
            sheet.Range["F15"].Value = "";
            sheet.Range["G15"].Value = "";
            sheet.Range["H15"].Value = "";
            sheet.Range["I15"].Value = "";
            sheet.Range["J15"].Value = "";


            //Content - 6th Line
            sheet.Range["A16"].Value = "6";
            sheet.Range["B16"].Value = "Background Verification";
            pertrange = sheet.Range["C16"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Background Verification";
            lnk.Address = "'Background Verification'!A1";
            sheet.Range["D16"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["Background Verification"];
            rec1target = recsheet.Range["A16:A" + (recsheet.LastRow - 2)].CellsCount.ToString();
            sheet.Range["E16"].Value = "" + rec1target;

            try
            {
                sheet.Range["F16"].Value = "=COUNTIF('Background Verification'!L16:L" + (recsheet.LastRow - 1) + ",\"Verified\")+COUNTIF('Background Verification'!L16:L" + (recsheet.LastRow - 1) + ",\"N/A\")";
            }
            catch { sheet.Range["F16"].Value = ""; }
            try
            {
                sheet.Range["G16"].Value = "=COUNTIF('Background Verification'!L16:L" + (recsheet.LastRow - 1) + ",\"Pending\")";
            }
            catch { sheet.Range["G16"].Value = ""; }

            sheet.Range["H16"].Formula = "=ROUND(F16/E16*100,0)";
            sheet.Range["I16"].Value = "";
            sheet.Range["J16"].Value = "";


            //Content - 7th Line
            sheet.Range["A17"].Value = "7";
            sheet.Range["B17"].Value = "Absconding";
            pertrange = sheet.Range["C17"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Absconding";
            lnk.Address = "'Absconding'!A1";
            sheet.Range["D17"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["Absconding"];
            CellRange[] coderange = recsheet.FindAllString("Code", false, false);
            int firstrow = 0;
            foreach (CellRange ranges in coderange)
            {
                firstrow = ranges.LastRow;
            }
            rec1target = recsheet.Range["A" + (firstrow) + ":A" + (recsheet.LastRow - 2)].CellsCount.ToString();
            sheet.Range["E17"].Value = "" + rec1target;
            sheet.Range["F17"].Value = "" + rec1target;
            sheet.Range["G17"].Value = "0";
            sheet.Range["H17"].Formula = "=ROUND(F17/E17*100,0)";
            sheet.Range["I17"].Value = "=SUM('Absconding'!G" + (firstrow) + ":G" + (recsheet.LastRow - 1) + ")";
            sheet.Range["J17"].Value = "";

            //Content - 8th Line
            sheet.Range["A18"].Value = "8";
            sheet.Range["B18"].Value = "Resigned";
            pertrange = sheet.Range["C18"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Resigned";
            lnk.Address = "'Resigned'!A1";
            sheet.Range["D18"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["Resigned"];
            rec1target = recsheet.Range["A16:A" + (recsheet.LastRow - 2)].CellsCount.ToString();
            sheet.Range["E18"].Value = "" + rec1target;
            sheet.Range["F18"].Value = "" + rec1target;
            sheet.Range["G18"].Value = "0";
            sheet.Range["H18"].Formula = "=ROUND(F17/E17*100,0)";
            sheet.Range["I18"].Value = "=SUM('Resigned'!G17:G" + (recsheet.LastRow - 1) + ")";
            sheet.Range["J18"].Value = "";

            //Content - 9th Line
            sheet.Range["A19"].Value = "9";
            sheet.Range["B19"].Value = "Fun Friday";
            pertrange = sheet.Range["C19"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Fun Friday";
            lnk.Address = "'Fun Friday'!A1";
            sheet.Range["D19"].Value = "Completed";
            sheet.Range["E19"].Value = "";
            sheet.Range["F19"].Value = "";
            sheet.Range["G19"].Value = "";
            sheet.Range["H19"].Value = "";
            sheet.Range["I19"].Value = "";
            sheet.Range["J19"].Value = "";

            //Content - 10th Line
            sheet.Range["A20"].Value = "10";
            sheet.Range["B20"].Value = "Fun Friday Snaps";
            pertrange = sheet.Range["C20"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Fun Friday Snaps";
            lnk.Address = "'Fun Friday Snaps'!A1";
            sheet.Range["D20"].Value = "Completed";
            sheet.Range["E20"].Value = "";
            sheet.Range["F20"].Value = "";
            sheet.Range["G20"].Value = "";
            sheet.Range["H20"].Value = "";
            sheet.Range["I20"].Value = "";
            sheet.Range["J20"].Value = "";


            //Content - 11th Line
            sheet.Range["A21"].Value = "11";
            sheet.Range["B21"].Value = "Naukri";
            pertrange = sheet.Range["C21"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Naukri";
            lnk.Address = "'Naukri'!A1";
            sheet.Range["D21"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["Naukri"];
            rec1target = recsheet.Range["A17:A" + (recsheet.LastRow - 1)].CellsCount.ToString();
            sheet.Range["E21"].Value = "" + rec1target;
            sheet.Range["F21"].Value = "" + rec1target;
            sheet.Range["G21"].Value = "0";
            sheet.Range["H21"].Formula = "=ROUND(F21/E21*100,0)";
            sheet.Range["I21"].Value = "";
            sheet.Range["J21"].Value = "";

            //Content - 12th Line
            sheet.Range["A22"].Value = "12";
            sheet.Range["B22"].Value = "LinkedIn";
            pertrange = sheet.Range["C22"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "LinkedIn";
            lnk.Address = "'LinkedIn'!A1";
            sheet.Range["D22"].Value = "Completed";
            //Details
            try
            {
                recsheet = book.Worksheets["LinkedIn"];
                rec1target = recsheet.Range["A17:A" + (recsheet.LastRow - 1)].CellsCount.ToString();
                sheet.Range["E22"].Value = "" + rec1target;
                sheet.Range["F22"].Value = "" + rec1target;
                sheet.Range["G22"].Value = "0";
                sheet.Range["H22"].Formula = "=ROUND(F22/E22*100,0)";
                sheet.Range["I22"].Value = "";
                sheet.Range["J22"].Value = "";
            }
            catch
            {
                recsheet = book.Worksheets["LinkedIn"];
                sheet.Range["E22"].Value = "";
                sheet.Range["F22"].Value = "";
                sheet.Range["G22"].Value = "0";
                sheet.Range["H22"].Value = "";
                sheet.Range["I22"].Value = "";
                sheet.Range["J22"].Value = "";
            }

            //Content - 13th Line
            sheet.Range["A23"].Value = "13";
            sheet.Range["B23"].Value = "Glassdoor Infinity";
            pertrange = sheet.Range["C23"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Glassdoor Infinity";
            lnk.Address = "'Glassdoor Infinity'!A1";
            sheet.Range["D23"].Value = "Completed";
            //Details
            sheet.Range["E23"].Value = "";
            sheet.Range["F23"].Value = "";
            sheet.Range["G23"].Value = "";
            sheet.Range["H23"].Value = "";
            sheet.Range["I23"].Value = "";
            sheet.Range["J23"].Value = "";

            //Content - 14th Line
            sheet.Range["A24"].Value = "14";
            sheet.Range["B24"].Value = "Glassdoor Competitiors";
            pertrange = sheet.Range["C24"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Glassdoor Competitiors";
            lnk.Address = "'Glassdoor Competitiors'!A1";
            sheet.Range["D24"].Value = "Completed";
            //Details
            sheet.Range["E24"].Value = "";
            sheet.Range["F24"].Value = "";
            sheet.Range["G24"].Value = "";
            sheet.Range["H24"].Value = "";
            sheet.Range["I24"].Value = "";
            sheet.Range["J24"].Value = "";

            //Content - 15th Line
            sheet.Range["A25"].Value = "15";
            sheet.Range["B25"].Value = "R&R";
            pertrange = sheet.Range["C25"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "R&R";
            lnk.Address = "'R&R'!A1";
            sheet.Range["D25"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["R&R"];
            rec1target = recsheet.Range["A27:A" + (recsheet.LastRow)].CellsCount.ToString();
            sheet.Range["E25"].Value = "" + rec1target;
            sheet.Range["F25"].Value = "" + rec1target;
            sheet.Range["G25"].Value = "0";
            sheet.Range["H25"].Formula = "=ROUND(F25/E25*100,0)";
            sheet.Range["I25"].Value = "";
            sheet.Range["J25"].Value = "";

            //Content - 16th Line
            sheet.Range["A26"].Value = "16";
            sheet.Range["B26"].Value = "R&R Snaps";
            pertrange = sheet.Range["C26"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "R&R Snaps";
            lnk.Address = "'R&R Snaps'!A1";
            sheet.Range["D26"].Value = "Completed";
            //Details
            sheet.Range["E26"].Value = "";
            sheet.Range["F26"].Value = "";
            sheet.Range["G26"].Value = "";
            sheet.Range["H26"].Value = "";
            sheet.Range["I26"].Value = "";
            sheet.Range["J26"].Value = "";


            //Content - 17th Line
            sheet.Range["A27"].Value = "17";
            sheet.Range["B27"].Value = "Stamp Paper Purchase Report";
            pertrange = sheet.Range["C27"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Stamp Paper Purchase";
            lnk.Address = "'Stamp Paper Purchase'!A1";
            sheet.Range["D27"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["Stamp Paper Purchase"];
            recRange = recsheet.Range["A17:A" + (recsheet.LastRow - 1)];
            rectarget = recRange.CellsCount;
            sheet.Range["E27"].Value = "" + rectarget;
            sheet.Range["F27"].Value = "" + rectarget;
            sheet.Range["G27"].Value = "0";
            sheet.Range["H27"].Formula = "=ROUND(F27/E27*100,0)";
            sheet.Range["I27"].Value = "=SUM('Stamp Paper Purchase'!J17:J" + (recsheet.LastRow - 1) + ")";
            sheet.Range["J27"].Value = "";

            //Content - 18th Line
            sheet.Range["A28"].Value = "18";
            sheet.Range["B28"].Value = "DD Master";
            pertrange = sheet.Range["C28"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "DD Master";
            lnk.Address = "'DD Master'!A1";
            sheet.Range["D28"].Value = "Completed";
            //Details
            sheet.Range["E28"].Value = "";
            sheet.Range["F28"].Value = "";
            sheet.Range["G28"].Value = "";
            sheet.Range["H28"].Value = "";
            sheet.Range["I28"].Value = "";
            sheet.Range["J28"].Value = "";

            //Content - 19th Line
            sheet.Range["A29"].Value = "19";
            sheet.Range["B29"].Value = "Non DD Master";
            pertrange = sheet.Range["C29"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Non DD Master";
            lnk.Address = "'Non DD Master'!A1";
            sheet.Range["D29"].Value = "Completed";
            //Details
            sheet.Range["E29"].Value = "";
            sheet.Range["F29"].Value = "";
            sheet.Range["G29"].Value = "";
            sheet.Range["H29"].Value = "";
            sheet.Range["I29"].Value = "";
            sheet.Range["J29"].Value = "";


            //Content - 20th Line
            sheet.Range["A30"].Value = "20";
            sheet.Range["B30"].Value = "HR Induction Report";
            pertrange = sheet.Range["C30"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "HR Induction Report";
            lnk.Address = "'HR Induction Report'!A1";
            sheet.Range["D30"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["HR Induction Report"];
            rec1target = recsheet.Range["A17:A" + (recsheet.LastRow - 1)].CellsCount.ToString();
            sheet.Range["E30"].Value = "" + rec1target;

            try
            {
                sheet.Range["F30"].Value = "=COUNTIF('HR Induction Report'!O17:O" + (recsheet.LastRow - 1) + ",\"Pass\")+COUNTIF('HR Induction Report'!O16:O" + (recsheet.LastRow - 1) + ",\"Fail\")";
            }
            catch { sheet.Range["F30"].Value = ""; }
            try
            {
                sheet.Range["G30"].Value = "=COUNTIF('HR Induction Report'!O17:O" + (recsheet.LastRow - 1) + ",\"Pending\")";
            }
            catch { sheet.Range["G30"].Value = ""; }

            sheet.Range["H30"].Formula = "=ROUND(F30/E30*100,0)";
            sheet.Range["I30"].Value = "";
            sheet.Range["J30"].Value = "";

            //Content - 21th Line
            sheet.Range["A31"].Value = "21";
            sheet.Range["B31"].Value = "New Joinee Followup";
            pertrange = sheet.Range["C31"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "New Joinee Followup";
            lnk.Address = "'New Joinee Followup'!A1";
            sheet.Range["D31"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["New Joinee Followup"];
            recRange = recsheet.Range["A16:A" + (recsheet.LastRow - 1)];
            rectarget = recRange.CellsCount;
            sheet.Range["E31"].Value = "" + rectarget;
            try
            {
                sheet.Range["F31"].Value = "=COUNTIF('New Joinee Followup'!I16:I" + (recsheet.LastRow - 1) + ",\"<>\")";
            }
            catch { sheet.Range["F31"].Value = ""; }
            try
            {
                sheet.Range["G31"].Value = "=COUNTIF('New Joinee Followup'!I16:I" + (recsheet.LastRow - 1) + ",\"\")";
            }
            catch { sheet.Range["G31"].Value = ""; }
            sheet.Range["H31"].Formula = "=ROUND(F31/E31*100,0)";
            sheet.Range["I31"].Value = "";
            sheet.Range["J31"].Value = "";

            //Content - 22th Line
            sheet.Range["A32"].Value = "22";
            sheet.Range["B32"].Value = "Address Verification";
            pertrange = sheet.Range["C32"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Address Verification";
            lnk.Address = "'Address Verification'!A1";
            sheet.Range["D32"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["Address Verification"];
            recRange = recsheet.Range["A16:A" + (recsheet.LastRow - 1)];
            rectarget = recRange.CellsCount;
            sheet.Range["E32"].Value = "" + rectarget;
            try
            {
                sheet.Range["F32"].Value = "=COUNTIF('Address Verification'!H16:H" + (recsheet.LastRow - 1) + ",\"<>\")";
            }
            catch { sheet.Range["F32"].Value = ""; }
            try
            {
                sheet.Range["G32"].Value = "=COUNTIF('Address Verification'!H16:H" + (recsheet.LastRow - 1) + ",\"\")";
            }
            catch { sheet.Range["G32"].Value = ""; }
            sheet.Range["H32"].Formula = "=ROUND(F32/E32*100,0)";
            sheet.Range["I32"].Value = "";
            sheet.Range["J32"].Value = "";

            //Content - 23th Line
            sheet.Range["A33"].Value = "23";
            sheet.Range["B33"].Value = "Exit Formality Status";
            pertrange = sheet.Range["C33"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Exit Employees";
            lnk.Address = "'Exit Employees'!A1";
            sheet.Range["D33"].Value = "Completed";
            //Details
            sheet.Range["E33"].Value = "";
            sheet.Range["F33"].Value = "";
            sheet.Range["G33"].Value = "";
            sheet.Range["H33"].Value = "";
            sheet.Range["I33"].Value = "";
            sheet.Range["J33"].Value = "";

            // Content - 24th Line
            sheet.Range["A34"].Value = "24";
            sheet.Range["B34"].Value = "Ticket Report";
            pertrange = sheet.Range["C34"];
            lnk = sheet.HyperLinks.Add(pertrange);
            lnk.Type = HyperLinkType.Workbook;
            lnk.TextToDisplay = "Ticket Report";
            lnk.Address = "'Ticket Report'!A1";
            sheet.Range["D34"].Value = "Completed";
            //Details
            recsheet = book.Worksheets["Ticket Report"];
            recRange = recsheet.Range["A16:A" + (recsheet.LastRow)];
            rectarget = recRange.CellsCount;
            sheet.Range["E34"].Value = "" + rectarget;
            try
            {
                sheet.Range["F34"].Value = "=COUNTIF('Ticket Report'!E16:E" + (recsheet.LastRow) + ",\"Closed\")";
            }
            catch { sheet.Range["F34"].Value = ""; }
            try
            {
                sheet.Range["G34"].Value = "=COUNTIF('Ticket Report'!E16:E" + (recsheet.LastRow) + ",\"Open\")";
            }
            catch { sheet.Range["G34"].Value = ""; }
            sheet.Range["H34"].Formula = "=ROUND(F34/E34*100,0)";
            sheet.Range["I34"].Value = "";
            sheet.Range["J34"].Value = "";
            DashboardContent(sheet.Range["A11:J34"]);
            sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";

            sheet.AllocatedRange.AutoFitColumns();
            sheet.AllocatedRange.AutoFitRows();



            #endregion
            return returnvalue;
        }


        [WebMethod]
        public static int AttritionReport()
        {
            //book.LoadFromFile(FileName);
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";
            int ReturnValue = 0;
            int AtrSumCount = 0;
            int rowcount = 0;
            int colcount = 0;

            //#region Dashboard
            //sheet = book.Worksheets.Add("Dashboard");
            //#endregion

            sheet = book.Worksheets.Add("Attrition Report");

            DataSet dsAtr = new bllMaster().GetAttritionReportForHRReport(Month, Year);

            if (dsAtr != null)
            {
                DataTable dtMonth = dsAtr.Tables[0];
                DataTable dtDomain = dsAtr.Tables[1];

                AtrSumCount = dtMonth.Rows.Count;

                if (dtMonth.Rows.Count > 0)
                {
                    sheet.InsertDataTable(dtMonth, true, 1, 1);
                    string Col = GetColumnName(dtMonth.Columns.Count - 1);
                    CellRange range = sheet.Range["A1:" + Col + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + Col + (dtMonth.Rows.Count + 1)];
                    AllBorder(range);
                    ContentCenter(range);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    int startrow = sheet.LastRow + 3;

                    Chart chart1 = sheet.Charts.Add(ExcelChartType.ColumnClustered);
                    chart1.SeriesDataFromRange = false;
                    //Chart border  
                    chart1.ChartArea.Border.Weight = ChartLineWeightType.Medium;
                    chart1.ChartArea.Border.Color = System.Drawing.Color.SandyBrown;
                    //Chart position  
                    chart1.LeftColumn = 11;
                    chart1.TopRow = 1;
                    chart1.RightColumn = 21;
                    chart1.BottomRow = rowcount + 10;
                    //Chart title  
                    chart1.ChartTitle = "Monthly Analysis";
                    chart1.ChartTitleArea.Font.FontName = "Aptos Narrow";
                    chart1.ChartTitleArea.Font.Size = 11;
                    chart1.ChartTitleArea.Font.IsBold = true;
                    //Chart axis  
                    chart1.PrimaryCategoryAxis.Title = "Month";
                    chart1.PrimaryCategoryAxis.Font.Color = System.Drawing.Color.Blue;
                    chart1.PrimaryValueAxis.Title = "Count";

                    chart1.PrimaryValueAxis.HasMajorGridLines = false;
                    //chart.PrimaryValueAxis.MaxValue = 100;
                    chart1.PrimaryValueAxis.TitleArea.TextRotationAngle = 90;

                    var cs11 = chart1.Series.Add("Count", ExcelChartType.ColumnClustered);
                    cs11.Values = sheet.Range["I2:I" + Convert.ToString(rowcount)];
                    sheet.Range["I2:I" + rowcount].IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                    sheet.Range["I2:I" + rowcount].NumberFormat = "0";
                    sheet.Range["I2:I" + Convert.ToString(rowcount)].ConvertToNumber();

                    foreach (Spire.Xls.Charts.ChartSerie cs in chart1.Series)
                    {
                        cs.CategoryLabels = sheet.Range["A2:A" + Convert.ToString(rowcount)];
                        cs.DataPoints.DefaultDataPoint.DataLabels.HasValue = true;
                    }
                    chart1.Legend.Position = LegendPositionType.Bottom;

                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    sheet.InsertDataTable(dtDomain, true, rowcount + 2, 1);

                    Col = GetColumnName(dtDomain.Columns.Count - 1);
                    range = sheet.Range["A" + (rowcount + 2) + ":" + Col + "" + (rowcount + 2)];
                    HeaderFormat(range);
                    range = sheet.Range["A" + (rowcount + 2) + ":" + Col + (dtDomain.Rows.Count + 1 + rowcount + 2)];
                    AllBorder(range);
                    ContentCenter(range);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    sheet.AllocatedRange.Style.HorizontalAlignment = HorizontalAlignType.Center;
                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    chart1 = null;
                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
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
            return ReturnValue;
        }


        public void FormatExcel(string FileName)
        {
            //Month = Convert.ToString(Request.Form["hr_month"]);
            //Year = Convert.ToString(Request.Form["hr_year"]);
            //int RecSumCount = 0;
            //Workbook book = new Workbook();
            ////book.LoadFromFile(FileName);
            //book.DefaultFontSize = 10;
            //book.DefaultFontName = "Aptos Narrow";
            //int rowcount = 0;
            //int colcount = 0;


            ////ClientScript.RegisterStartupScript(this.GetType(), "alert", "$('#waitingpanel').modal('hide');", true);


            ////book.Dispose();




        }
    }
}