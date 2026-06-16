using ClosedXML.Excel;
using DocumentFormat.OpenXml.VariantTypes;
using Newtonsoft.Json;
using Spire.Xls;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;


namespace WebPortal.Admin
{
    public partial class SLAReport : System.Web.UI.Page
    {
        static DataTable dtExport = null;
        static DataTable dtNew = null;
        static string From_Date = "";
        static string To_Date = "";

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetSLAReport(string FromDate, string ToDate)
        {
            From_Date = FromDate;
            To_Date = ToDate;

            string data = string.Empty;
            try
            {
                dtExport = null;
                DataTable dt = new bllMaster().GetRecordsForSLAReport(FromDate, ToDate);
                dtExport = dt;
                if (dt.Rows.Count > 0)
                {
                    data = JsonConvert.SerializeObject(dt);
                }
            }
            catch (Exception ex)
            {
                return "";
            }

            return data;
        }

        protected void btn_ExportSLAReport_Click(object sender, EventArgs e)
        {
            ExportSLAReport(From_Date, To_Date);
            dtExport = null;
        }


        public static void core_ExportSLAReport(string fromDate, string toDate)
        {
            DataTable dt = dtExport; // your existing method

            using (XLWorkbook wb = new XLWorkbook())
            {
                var ws = wb.Worksheets.Add("SLA Report");

                // =========================
                // ✅ HEADER ROW 1
                // =========================
                ws.Cell("A1").Value = "Sr #";
                ws.Cell("B1").Value = "Deal #";
                ws.Cell("C1").Value = "Loan #";
                ws.Cell("D1").Value = "Received Date";
                ws.Cell("E1").Value = "Due Date";
                ws.Cell("F1").Value = "Elapsed Time";


                ws.Cell("G1").Value = "Loan Setup";
                ws.Range("G1:J1").Merge();

                ws.Cell("K1").Value = "Credit";
                ws.Range("K1:N1").Merge();

                ws.Cell("O1").Value = "Compliance";
                ws.Range("O1:V1").Merge();

                ws.Cell("W1").Value = "Dispatch Date";
                ws.Cell("X1").Value = "Total TAT";
                ws.Cell("Y1").Value = "Business Days";


                // =========================
                // ✅ HEADER ROW 2
                // =========================
                ws.Cell("G2").Value = "Setup";
                ws.Range("G2:J2").Merge();

                ws.Cell("K2").Value = "Process";
                ws.Range("K2:N2").Merge();

                ws.Cell("O2").Value = "Review";
                ws.Range("O2:R2").Merge();

                ws.Cell("S2").Value = "QC";
                ws.Range("S2:V2").Merge();


                // =========================
                // ✅ HEADER ROW 3
                // =========================
                string[] headers = {
                "User","Start Date","End Date","TAT",
                "User","Start Date","End Date","TAT",
                "Reviewer","Start Date","End Date","TAT",
                "QCier","Start Date","End Date","TAT"
            };

                int col = 7; // start from G (not F)
                foreach (var h in headers)
                {
                    ws.Cell(3, col++).Value = h;
                }

                // Merge vertical headers
                ws.Range("A1:A3").Merge();
                ws.Range("B1:B3").Merge();
                ws.Range("C1:C3").Merge();
                ws.Range("D1:D3").Merge();
                ws.Range("E1:E3").Merge();
                ws.Range("F1:F3").Merge(); // ✅ Elapsed Time

                ws.Range("W1:W3").Merge();
                ws.Range("X1:X3").Merge();
                ws.Range("Y1:Y3").Merge();

                // =========================
                // ✅ STYLING
                // =========================
                var mainHeader = ws.Range("A1:U1");
                mainHeader.Style.Font.Bold = true;
                mainHeader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                var subHeader_loanSetUp = ws.Range("G1:J3");
                //subHeader_loanSetUp.Style.Font.FontColor = XLColor.White;
                subHeader_loanSetUp.Style.Fill.BackgroundColor = XLColor.FromHtml("#cce5ff");
                subHeader_loanSetUp.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                var subHeader = ws.Range("K1:N3");
                //subHeader.Style.Font.FontColor = XLColor.White;
                subHeader.Style.Fill.BackgroundColor = XLColor.FromHtml("#99caff");
                subHeader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                var colHeader = ws.Range("O1:V3");
                //colHeader.Style.Font.FontColor = XLColor.White;
                colHeader.Style.Fill.BackgroundColor = XLColor.FromHtml("#66b0ff");
                colHeader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;


                // ✅ Apply font size to entire row
                ws.Range("A1:F1").Style.Font.FontSize = 11;
                ws.Range("A1:F1").Style.Font.Bold = true;
                ws.Range("A1:F1").Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                ws.Range("A1:F1").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                ws.Range("W1:Y1").Style.Font.FontSize = 11;
                ws.Range("W1:Y1").Style.Font.Bold = true;
                ws.Range("W1:Y1").Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                ws.Range("W1:Y1").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                ws.Range("G2:V2").Style.Font.FontSize = 11;
                ws.Range("G2:V2").Style.Font.Bold = true;
                ws.Range("G2:V2").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                ws.Range("G3:V3").Style.Font.FontSize = 9;
                ws.Range("G3:V3").Style.Font.Bold = true;
                ws.Range("G3:V3").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;


                // =========================
                // ✅ DATA (FIXED VERSION)
                // =========================
                int row = 4;
                int sr = 1;

                foreach (DataRow dr in dt.Rows)
                {
                    int c = 1;

                    ws.Cell(row, c++).Value = sr++;

                    ws.Cell(row, c++).Value = GetString(dr, "DealNo");
                    ws.Cell(row, c++).Value = GetString(dr, "LoanNo");

                    SetDate(ws, row, c++, dr, "OrderDate");
                    SetDate(ws, row, c++, dr, "DueDate");
                    ws.Cell(row, c++).Value = GetString(dr, "ElapsTime");

                    ws.Cell(row, c++).Value = GetString(dr, "Loan Setup");
                    SetDate(ws, row, c++, dr, "Loan Setup Start Date");
                    SetDate(ws, row, c++, dr, "Loan Setup End Date");
                    ws.Cell(row, c++).Value = GetString(dr, "Loan Setup TAT");

                    ws.Cell(row, c++).Value = GetString(dr, "Credit");
                    SetDate(ws, row, c++, dr, "Credit Start Date");
                    SetDate(ws, row, c++, dr, "Credit End Date");
                    ws.Cell(row, c++).Value = GetString(dr, "Credit TAT");

                    ws.Cell(row, c++).Value = GetString(dr, "ComplianceReview");
                    SetDate(ws, row, c++, dr, "ComplianceReview Start Date");
                    SetDate(ws, row, c++, dr, "ComplianceReview End Date");
                    ws.Cell(row, c++).Value = GetString(dr, "ComplianceReview TAT");

                    ws.Cell(row, c++).Value = GetString(dr, "Compliance QC");
                    SetDate(ws, row, c++, dr, "Compliance QC Start Date");
                    SetDate(ws, row, c++, dr, "Compliance QC End Date");
                    ws.Cell(row, c++).Value = GetString(dr, "Compliance QC TAT");

                    ws.Cell(row, c++).Value = GetString(dr, "AddedDate");
                    ws.Cell(row, c++).Value = GetString(dr, "TotalTAT_Format");
                    ws.Cell(row, c++).Value = GetString(dr, "OrderTAT_BusinessDays");


                    string elaps = (GetString(dr, "ElapsTime") ?? "").ToLower();

                    var match = System.Text.RegularExpressions.Regex.Match(elaps, @"\d+");
                    int? hrs = match.Success ? int.Parse(match.Value) : (int?)null;

                    if (!elaps.Contains("sent to client"))
                    {
                        if (elaps.Contains("left") && hrs != null)
                        {
                            if (hrs < 13)
                                ws.Row(row).Style.Fill.BackgroundColor = XLColor.FromHtml("#cce5ff");
                            else
                                ws.Row(row).Style.Font.Bold = true;
                        }
                        else if (elaps.Contains("overdue"))
                        {
                            ws.Row(row).Style.Font.FontColor = XLColor.FromHtml("#f00000");
                        }
                    }

                    row++;
                }

                // =========================
                // ✅ BORDERS + AUTO WIDTH
                // =========================
                ws.RangeUsed().Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws.RangeUsed().Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                ws.Columns().AdjustToContents();
                ws.Range("A4:X" + row).Style.Font.FontSize = 10;

                // =========================
                // ✅ FREEZE HEADER
                // =========================
                ws.SheetView.FreezeRows(3);

                // =========================
                // ✅ DOWNLOAD FILE
                // =========================
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);

                    HttpContext.Current.Response.Clear();
                    HttpContext.Current.Response.ContentType =
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                    HttpContext.Current.Response.AddHeader("content-disposition",
                        $"attachment;filename=SLA_Report_{fromDate}_to_{toDate}.xlsx");

                    HttpContext.Current.Response.BinaryWrite(ms.ToArray());
                    HttpContext.Current.Response.End();
                }
            }
        }



        public static void ExportSLAReport(string fromDate, string toDate)
        {
            DataTable dt = dtExport; // your existing method

            using (XLWorkbook wb = new XLWorkbook())
            {
                var ws = wb.Worksheets.Add("SLA Report");

                // =========================
                // ✅ HEADER ROW 1
                // =========================
                ws.Cell("A1").Value = "Sr #";
                ws.Cell("B1").Value = "Deal #";
                ws.Cell("C1").Value = "Loan #";
                ws.Cell("D1").Value = "Unique Loan #";   // NEW
                ws.Cell("E1").Value = "Received Date";
                ws.Cell("F1").Value = "Due Date";
                ws.Cell("G1").Value = "Elapsed Time";


                ws.Cell("H1").Value = "Loan Setup";
                ws.Range("H1:K1").Merge();

                ws.Cell("L1").Value = "Credit";
                ws.Range("L1:O1").Merge();

                ws.Cell("P1").Value = "Compliance";
                ws.Range("P1:W1").Merge();

                ws.Cell("X1").Value = "Dispatch Date";
                ws.Cell("Y1").Value = "Total TAT";
                ws.Cell("Z1").Value = "Business Days";


                // =========================
                // ✅ HEADER ROW 2
                // =========================
                ws.Cell("H2").Value = "Setup";
                ws.Range("H2:K2").Merge();

                ws.Cell("L2").Value = "Process";
                ws.Range("L2:O2").Merge();

                ws.Cell("P2").Value = "Review";
                ws.Range("P2:S2").Merge();

                ws.Cell("T2").Value = "QC";
                ws.Range("T2:W2").Merge();


                // =========================
                // ✅ HEADER ROW 3
                // =========================
                string[] headers = {
                "User","Start Date","End Date","TAT",
                "User","Start Date","End Date","TAT",
                "Reviewer","Start Date","End Date","TAT",
                "QCier","Start Date","End Date","TAT"
            };

                int col = 8; // start from H
                foreach (var h in headers)
                {
                    ws.Cell(3, col++).Value = h;
                }

                // Merge vertical headers
                ws.Range("A1:A3").Merge();
                ws.Range("B1:B3").Merge();
                ws.Range("C1:C3").Merge();
                ws.Range("D1:D3").Merge(); // UniqueLoanNo
                ws.Range("E1:E3").Merge(); // OrderDate
                ws.Range("F1:F3").Merge(); // DueDate
                ws.Range("G1:G3").Merge(); // Elapsed Time

               
                ws.Range("X1:X3").Merge();
                ws.Range("Y1:Y3").Merge();
                ws.Range("Z1:Z3").Merge();


                // =========================
                // ✅ STYLING
                // =========================
                var mainHeader = ws.Range("A1:Z1"); 
                mainHeader.Style.Font.Bold = true;
                mainHeader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                var subHeader_loanSetUp = ws.Range("H1:K3"); 
                subHeader_loanSetUp.Style.Fill.BackgroundColor = XLColor.FromHtml("#cce5ff");
                subHeader_loanSetUp.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                var subHeader = ws.Range("L1:O3"); 
                subHeader.Style.Fill.BackgroundColor = XLColor.FromHtml("#99caff");
                subHeader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                var colHeader = ws.Range("P1:W3"); 
                colHeader.Style.Fill.BackgroundColor = XLColor.FromHtml("#66b0ff");
                colHeader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;


                // ✅ Apply font size to entire row
                ws.Range("A1:G1").Style.Font.FontSize = 11; 
                ws.Range("A1:G1").Style.Font.Bold = true;
                ws.Range("A1:G1").Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                ws.Range("A1:G1").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                ws.Range("X1:Z1").Style.Font.FontSize = 11; 
                ws.Range("X1:Z1").Style.Font.Bold = true;
                ws.Range("X1:Z1").Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                ws.Range("X1:Z1").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                ws.Range("H2:W2").Style.Font.FontSize = 11; 
                ws.Range("H2:W2").Style.Font.Bold = true;
                ws.Range("H2:W2").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                ws.Range("H3:W3").Style.Font.FontSize = 9; 
                ws.Range("H3:W3").Style.Font.Bold = true;
                ws.Range("H3:W3").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;


                // =========================
                // ✅ DATA (FIXED VERSION)
                // =========================
                int row = 4;
                int sr = 1;

                foreach (DataRow dr in dt.Rows)
                {
                    int c = 1;

                    ws.Cell(row, c++).Value = sr++;

                    ws.Cell(row, c++).Value = GetString(dr, "DealNo");
                    ws.Cell(row, c++).Value = GetString(dr, "LoanNo");
                    ws.Cell(row, c++).Value = GetString(dr, "UniqueLoanNo"); // ✅ NEW

                    SetDate(ws, row, c++, dr, "OrderDate");
                    SetDate(ws, row, c++, dr, "DueDate");
                    ws.Cell(row, c++).Value = GetString(dr, "ElapsTime");

                    ws.Cell(row, c++).Value = GetString(dr, "Loan Setup");
                    SetDate(ws, row, c++, dr, "Loan Setup Start Date");
                    SetDate(ws, row, c++, dr, "Loan Setup End Date");
                    ws.Cell(row, c++).Value = GetString(dr, "Loan Setup TAT");

                    ws.Cell(row, c++).Value = GetString(dr, "Credit");
                    SetDate(ws, row, c++, dr, "Credit Start Date");
                    SetDate(ws, row, c++, dr, "Credit End Date");
                    ws.Cell(row, c++).Value = GetString(dr, "Credit TAT");

                    ws.Cell(row, c++).Value = GetString(dr, "ComplianceReview");
                    SetDate(ws, row, c++, dr, "ComplianceReview Start Date");
                    SetDate(ws, row, c++, dr, "ComplianceReview End Date");
                    ws.Cell(row, c++).Value = GetString(dr, "ComplianceReview TAT");

                    ws.Cell(row, c++).Value = GetString(dr, "Compliance QC");
                    SetDate(ws, row, c++, dr, "Compliance QC Start Date");
                    SetDate(ws, row, c++, dr, "Compliance QC End Date");
                    ws.Cell(row, c++).Value = GetString(dr, "Compliance QC TAT");

                    ws.Cell(row, c++).Value = GetString(dr, "AddedDate");
                    ws.Cell(row, c++).Value = GetString(dr, "TotalTAT_Format");
                    ws.Cell(row, c++).Value = GetString(dr, "OrderTAT_BusinessDays");

                    string elaps = (GetString(dr, "ElapsTime") ?? "").ToLower();

                    var match = System.Text.RegularExpressions.Regex.Match(elaps, @"\d+");
                    int? hrs = match.Success ? int.Parse(match.Value) : (int?)null;

                    if (!elaps.Contains("sent to client"))
                    {
                        if (elaps.Contains("left") && hrs != null)
                        {
                            if (hrs < 13)
                            {
                                // ✅ full row color #cce5ff
                                ws.Row(row).Style.Fill.BackgroundColor = XLColor.FromHtml("#d6d6d6");
                            }
                            else
                            {
                                // ✅ ONLY elapsed time column bold
                                ws.Cell(row, 7).Style.Font.Bold = true; // column G now 
                            }
                        }
                        else if (elaps.Contains("overdue"))
                        {
                            // ✅ full row red background (not font color)
                            ws.Row(row).Style.Fill.BackgroundColor = XLColor.FromHtml("#ffcccc");
                        }
                    }   

                    row++;
                }

                // =========================
                // ✅ BORDERS + AUTO WIDTH
                // =========================
                ws.RangeUsed().Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws.RangeUsed().Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                ws.Columns().AdjustToContents();
                ws.Range("A4:X" + row).Style.Font.FontSize = 10;

                // =========================
                // ✅ FREEZE HEADER
                // =========================
                ws.SheetView.FreezeRows(3);

                // =========================
                // ✅ DOWNLOAD FILE
                // =========================
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);

                    HttpContext.Current.Response.Clear();
                    HttpContext.Current.Response.ContentType =
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                    HttpContext.Current.Response.AddHeader("content-disposition",
                        $"attachment;filename=SLA_Report_{fromDate}_to_{toDate}.xlsx");

                    HttpContext.Current.Response.BinaryWrite(ms.ToArray());
                    HttpContext.Current.Response.End();
                }
            }
        }

        // =========================
        // ✅ HELPER METHODS (FIXES ERROR)
        // =========================
        private static string GetString(DataRow dr, string col)
        {
            return dr[col] == DBNull.Value ? "" : dr[col].ToString();
        }

        private static void SetDate(IXLWorksheet ws, int row, int col, DataRow dr, string columnName)
        {
            if (dr[columnName] != DBNull.Value)
            {
                if (Convert.ToString(dr[columnName]) != "")
                {
                    DateTime dt = Convert.ToDateTime(dr[columnName]);
                    ws.Cell(row, col).Value = dt;
                    ws.Cell(row, col).Style.DateFormat.Format = "mm-dd-yyyy";
                }
            }
            else
            {
                ws.Cell(row, col).Value = "";
            }
        }
    }
}