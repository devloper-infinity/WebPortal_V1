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

namespace WebPortal.Reports
{
    public partial class CreditConsolidatedReport : System.Web.UI.Page
    {
        static string FileName = "";
        static Workbook book = new Workbook();
        static Worksheet sheet;
        //book.LoadFromFile(FileName);

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetProjectInflow(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetProjectInflow_Credit(Month, Year);
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
        public static string GetProjectQ(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetProjectQ_Credit(Month, Year);
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
        public static string GetAvgSalaryQ(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetAvgSalary_Credit(Month, Year);
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
        public static string GetIndividualalary(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetIndividualPerformance_Credit(Month, Year);
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
        public static string GetProductionReport(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetProductionReport_Credit(Month, Year);
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
        public static string GetFeedbackDump(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetFeedbackdump_Credit(Month, Year);
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
        public static string GetReviewerQ(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetReviewerQ_Credit(Month, Year);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                dt1.Columns.Remove("ResultID");
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
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
        public static string GetQualityQ(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetQualityQ_Credit(Month, Year);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                dt1.Columns.Remove("ResultID");
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
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
        public static string GetErrorTrendingAll(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetErrorTrendingAll_Credit(Month, Year);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
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
        public static string GetErrorTrendingUser(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetErrorTrendingUser_Credit(Month, Year);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
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
        public static string GetWeeklyTrending(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetWeeklyTrending_Credit(Month, Year);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
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
        public static string GetSegmentQ(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetSegmentQ_Credit(Month, Year);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
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
        public static string GetMonthlyTrending(string Month, string Year)
        {
            DataTable dt1 = new bllReport().GetMonthlyTrending_Credit(Month, Year);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
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

        protected void btn1_Click(object sender, EventArgs e)
        {
            string Month = Convert.ToString(Request.Form["creditcons_month"]);
            string Year = Convert.ToString(Request.Form["creditcons_year"]);
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
                    int cnt = workbook.Worksheets.Count;
                    worksheet = workbook.Worksheet(14);
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

        public void FormatExcel(string FileName)
        {
            string Month = Convert.ToString(Request.Form["creditcons_month"]);
            string Year = Convert.ToString(Request.Form["creditcons_year"]);

            Workbook book = new Workbook();
            //book.LoadFromFile(FileName);
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";
            int rowcount = 0;
            int colcount = 0;

            #region Project Inflow
            Worksheet sheet = book.Worksheets.Add("Project Inflow");
            DataTable dtInflow = new bllReport().GetProjectInflow_Credit(Month, Year);
            if (dtInflow != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Project Inflow summary with chart";
                sheet.InsertDataTable(dtInflow, true, 1, 1);
                string Col = GetColumnName(dtInflow.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtInflow.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Project Q
            sheet = book.Worksheets.Add("Project Q");
            DataTable dtProject = new bllReport().GetProjectQ_Credit(Month, Year);
            if (dtProject != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Project Q sheet";
                sheet.InsertDataTable(dtProject, true, 1, 1);
                string Col = GetColumnName(dtProject.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range.IsWrapText = true;
                range = sheet.Range["A1:" + Col + (dtProject.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertRow(1, 1);

                range = sheet.Range["A2:" + Col + "2"];
                range.IsWrapText = true;

                string SCol = GetColumnName(3);
                sheet.Range[SCol + "2"].Value = Month + " Del";

                SCol = GetColumnName(4);
                string ECol = GetColumnName(6);
                range = sheet.Range[SCol + "1:" + ECol + "1"];
                range.Value = "Critical";
                range.Merge();
                HeaderFormat(range);
                ContentCenter(range);
                AllBorder(range);

                SCol = GetColumnName(7);
                ECol = GetColumnName(9);
                range = sheet.Range[SCol + "1:" + ECol + "1"];
                range.Value = "Non-Critical";
                range.Merge();
                HeaderFormat(range);
                ContentCenter(range);
                AllBorder(range);


                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.Range["C1:C" + (dtProject.Rows.Count + 2)].IsWrapText = false;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Segment Q
            sheet = book.Worksheets.Add("Segment Q");
            DataTable dtSeg = new bllReport().GetSegmentQ_Credit(Month, Year);
            if (dtSeg != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Segment Q sheet";
                sheet.InsertDataTable(dtSeg, true, 1, 1);
                string Col = GetColumnName(dtSeg.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtSeg.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }

            #endregion
            #region Reviewer Q
            sheet = book.Worksheets.Add("Reviewer Q");
            DataTable dtreviewQ = new bllReport().GetReviewerQ_Credit(Month, Year);
            if (dtreviewQ != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Reviewer Q sheet";
                dtreviewQ.Columns.Remove("ResultID");
                sheet.InsertDataTable(dtreviewQ, true, 1, 1);
                string Col = GetColumnName(dtreviewQ.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtreviewQ.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);
                sheet.InsertRow(1, 1);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B2"].AutoFitRows();
                sheet.Range["B2"].AutoFitRows();
                int mergecount = 2;
                while (mergecount < dtreviewQ.Columns.Count)
                {
                    string SCol = GetColumnName(mergecount);
                    string ECol = GetColumnName(mergecount + 13);
                    range = sheet.Range[SCol + "1:" + ECol + "1"];
                    string ValueToUpdate = sheet.Range[SCol + "2"].Value;
                    ValueToUpdate = ValueToUpdate.Replace("-Loan Count", "");
                    range.Value = ValueToUpdate;
                    range.Merge();
                    HeaderFormat(range);
                    AllBorder(range);

                    for (int i = mergecount; i <= mergecount + 13; i++)
                    {
                        string colname = GetColumnName(i);
                        sheet.Range[colname + "2"].Value = sheet.Range[colname + "2"].Value.Replace(ValueToUpdate + "-", "");
                    }

                    mergecount = mergecount + 14;
                }







                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                //sheet.AllocatedRange.AutoFitColumns();
                //sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Quality Q
            sheet = book.Worksheets.Add("Quality Q");
            DataTable dtQualityQ = new bllReport().GetQualityQ_Credit(Month, Year);
            if (dtQualityQ != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Quality Q sheet";
                dtQualityQ.Columns.Remove("ResultID");
                sheet.InsertDataTable(dtQualityQ, true, 1, 1);
                string Col = GetColumnName(dtQualityQ.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtQualityQ.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);
                sheet.InsertRow(1, 1);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B2"].AutoFitRows();
                sheet.Range["B2"].AutoFitRows();
                int mergecount = 2;
                while (mergecount < dtQualityQ.Columns.Count)
                {
                    string SCol = GetColumnName(mergecount);
                    string ECol = GetColumnName(mergecount + 15);
                    range = sheet.Range[SCol + "1:" + ECol + "1"];
                    string ValueToUpdate = sheet.Range[SCol + "2"].Value;
                    ValueToUpdate = ValueToUpdate.Replace("-Loan Count", "");
                    range.Value = ValueToUpdate;
                    range.Merge();
                    HeaderFormat(range);
                    AllBorder(range);

                    for (int i = mergecount; i <= mergecount + 15; i++)
                    {
                        string colname = GetColumnName(i);
                        sheet.Range[colname + "2"].Value = sheet.Range[colname + "2"].Value.Replace(ValueToUpdate + "-", "");
                    }

                    mergecount = mergecount + 16;
                }







                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                //sheet.AllocatedRange.AutoFitColumns();
                //sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Segment wise Utilisation
            sheet = book.Worksheets.Add("Segment wise Utilisation");
            DataTable dtSegUtil = new bllReport().GetAvgSalary_Credit(Month, Year);
            if (dtSegUtil != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Segment wise utilisation";
                dtSegUtil.Columns.Remove("Months");
                sheet.InsertDataTable(dtSegUtil, true, 1, 1);
                string Col = GetColumnName(dtSegUtil.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtSegUtil.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Individual Performance
            sheet = book.Worksheets.Add("Individual Performance");
            DataTable dtIndPer = new bllReport().GetIndividualPerformance_Credit(Month, Year);
            if (dtIndPer != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Individual performance";
                dtIndPer.Columns.Remove("Salary");
                dtIndPer.Columns.Remove("Month");
                dtIndPer.Columns.Remove("TotalOpprtinities");
                dtIndPer.Columns.Remove("MissedOpportunities");
                dtIndPer.Columns["ProductivityPercentage"].Caption = "Utilisation %";
                dtIndPer.Columns["QualPerc"].Caption = "Quality %";
                sheet.InsertDataTable(dtIndPer, true, 1, 1);
                string Col = GetColumnName(dtIndPer.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtIndPer.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Production Report
            sheet = book.Worksheets.Add("Production Report");
            DataTable dtProd = new bllReport().GetProductionReport_Credit(Month, Year);
            if (dtProd != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Production report";
                dtProd.Columns.Remove("ProdID");
                dtProd.Columns.Remove("ProjectID");
                dtProd.Columns.Remove("DueDate");
                dtProd.Columns.Remove("DispatchDate");
                dtProd.Columns.Remove("FinalStatus");
                dtProd.Columns.Remove("SciennaID");
                dtProd.Columns.Remove("Status");
                dtProd.Columns.Remove("Target");
                dtProd.Columns.Remove("Flag");
                dtProd.Columns.Remove("TAT");
                dtProd.Columns.Remove("HstartDate");
                dtProd.Columns.Remove("HEndDate");
                dtProd.Columns.Remove("Process");
                dtProd.Columns["Code"].SetOrdinal(0);
                dtProd.Columns["Employee"].SetOrdinal(1);
                dtProd.Columns["Projectname"].SetOrdinal(2);
                dtProd.Columns["Projectname"].Caption = "Project #";
                dtProd.Columns["DealNo"].SetOrdinal(3);
                dtProd.Columns["DealNo"].Caption = "Deal #";
                dtProd.Columns["LoanNo"].SetOrdinal(4);
                dtProd.Columns["LoanNo"].Caption = "Loan #";
                dtProd.Columns["OrderDate"].SetOrdinal(5);
                dtProd.Columns["OrderDate"].Caption = "Received Date";
                dtProd.Columns["Process1"].SetOrdinal(6);
                dtProd.Columns["Process1"].Caption = "Process";
                dtProd.Columns["Date"].SetOrdinal(7);
                dtProd.Columns["Date"].Caption = "Process Date";
                dtProd.Columns["StartDate"].SetOrdinal(8);
                dtProd.Columns["StartDate"].Caption = "Start Time";
                dtProd.Columns["EndDate"].SetOrdinal(9);
                dtProd.Columns["EndDate"].Caption = "End Time";
                sheet.InsertDataTable(dtProd, true, 1, 1);
                string Col = GetColumnName(dtProd.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtProd.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Feedback Dump
            sheet = book.Worksheets.Add("Feedback Dump");
            DataTable dtfeedback = new bllReport().GetFeedbackdump_Credit(Month, Year);
            if (dtfeedback != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Feedback dump";
                sheet.InsertDataTable(dtfeedback, true, 1, 1);
                string Col = GetColumnName(dtfeedback.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtfeedback.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Weekly Trending Report
            sheet = book.Worksheets.Add("Weekly Trending Report");
            DataTable dtweekly = new bllReport().GetWeeklyTrending_Credit(Month, Year);
            if (dtweekly != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Weekly trending";
                sheet.InsertDataTable(dtweekly, true, 1, 1);
                string Col = GetColumnName(dtweekly.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtweekly.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertRow(1, 1);
                int startmerge = 3;
                for (int cl = 3; cl < dtweekly.Columns.Count; cl++)
                {
                    string MergeCol = GetColumnName(startmerge);
                    string Cols = GetColumnName(cl);
                    string PrevCols = GetColumnName(cl - 1);
                    //Current Header
                    string Headers = Convert.ToString(sheet.Range[Cols + "2"].Value);
                    string[] splitheader = Headers.Split(':');
                    string week = Convert.ToString(splitheader[0]);
                    string MainHeader = Convert.ToString(splitheader[1]);

                    //Previous Header
                    string PRevHeader = sheet.Range[PrevCols + "1"].Value;

                    sheet.Range[Cols + "1"].Value = MainHeader;
                    sheet.Range[Cols + "2"].Value = week.Trim();
                    if (cl > 3 && PRevHeader != MainHeader)
                    {
                        string tillMergeCol = GetColumnName(cl - 1);
                        sheet.Range[MergeCol + "1:" + tillMergeCol + "1"].Merge();
                        startmerge = cl;
                    }
                    if (cl == dtweekly.Columns.Count - 1)
                    {
                        string tillMergeCol = GetColumnName(cl);
                        sheet.Range[MergeCol + "1:" + tillMergeCol + "1"].Merge();
                        startmerge = cl;
                    }
                }
                string LastCol = GetColumnName(dtweekly.Columns.Count - 1);
                sheet.Range["A2:" + LastCol + "2"].IsWrapText = true;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

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

        public void DashboardHeader(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.Size = 12;
            range.Style.Font.IsBold = true;
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
        }

        public void DashboardContent(CellRange range)
        {
            range.Style.HorizontalAlignment = HorizontalAlignType.Center;
            range.Style.Font.Size = 10;
            range.Style.Borders.LineStyle = LineStyleType.Thin;
            range.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
            range.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
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

        [WebMethod]
        public static int FormatExcel_static(string Month, string Year)
        {
            int returnvalue = 1;
            //string Month = Convert.ToString(Request.Form["creditcons_month"]);
            //string Year = Convert.ToString(Request.Form["creditcons_year"]);


            //string Month = Convert.ToString(HttpContext.Current.Request.Form["creditcons_month"]);
            //string Year = Convert.ToString(HttpContext.Current.Request.Form["creditcons_year"]);

            FileName = HttpContext.Current.Server.MapPath(@"~\ReportDocument\Credit_Consolidated_Report_" + Convert.ToString(Month) + "-" + Convert.ToString(Year) + DateTime.Now.ToString("hhmmss") + ".xlsx");

            Workbook book = new Workbook();
            //book.LoadFromFile(FileName);
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";
            int rowcount = 0;
            int colcount = 0;

            #region Project Inflow
            Worksheet sheet = book.Worksheets.Add("Project Inflow");
            DataTable dtInflow = new bllReport().GetProjectInflow_Credit(Month, Year);
            if (dtInflow != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Project Inflow summary with chart";
                sheet.InsertDataTable(dtInflow, true, 1, 1);
                string Col = GetColumnName(dtInflow.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtInflow.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Project Q
            sheet = book.Worksheets.Add("Project Q");
            DataTable dtProject = new bllReport().GetProjectQ_Credit(Month, Year);
            if (dtProject != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Project Q sheet";
                sheet.InsertDataTable(dtProject, true, 1, 1);
                string Col = GetColumnName(dtProject.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range.IsWrapText = true;
                range = sheet.Range["A1:" + Col + (dtProject.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertRow(1, 1);

                range = sheet.Range["A2:" + Col + "2"];
                range.IsWrapText = true;

                string SCol = GetColumnName(3);
                sheet.Range[SCol + "2"].Value = Month + " Del";

                SCol = GetColumnName(4);
                string ECol = GetColumnName(6);
                range = sheet.Range[SCol + "1:" + ECol + "1"];
                range.Value = "Critical";
                range.Merge();
                HeaderFormat_Static(range);
                ContentCenter_Static(range);
                AllBorder_Static(range);

                SCol = GetColumnName(7);
                ECol = GetColumnName(9);
                range = sheet.Range[SCol + "1:" + ECol + "1"];
                range.Value = "Non-Critical";
                range.Merge();
                HeaderFormat_Static(range);
                ContentCenter_Static(range);
                AllBorder_Static(range);


                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.Range["C1:C" + (dtProject.Rows.Count + 2)].IsWrapText = false;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Segment Q
            sheet = book.Worksheets.Add("Segment Q");
            DataTable dtSeg = new bllReport().GetSegmentQ_Credit(Month, Year);
            if (dtSeg != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Segment Q sheet";
                sheet.InsertDataTable(dtSeg, true, 1, 1);
                string Col = GetColumnName(dtSeg.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtSeg.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }

            #endregion
            #region Reviewer Q
            sheet = book.Worksheets.Add("Reviewer Q");
            DataTable dtreviewQ = new bllReport().GetReviewerQ_Credit(Month, Year);
            if (dtreviewQ != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Reviewer Q sheet";
                dtreviewQ.Columns.Remove("ResultID");
                sheet.InsertDataTable(dtreviewQ, true, 1, 1);
                string Col = GetColumnName(dtreviewQ.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtreviewQ.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                sheet.InsertRow(1, 1);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B2"].AutoFitRows();
                sheet.Range["B2"].AutoFitRows();
                int mergecount = 2;
                while (mergecount < dtreviewQ.Columns.Count)
                {
                    string SCol = GetColumnName(mergecount);
                    string ECol = GetColumnName(mergecount + 13);
                    range = sheet.Range[SCol + "1:" + ECol + "1"];
                    string ValueToUpdate = sheet.Range[SCol + "2"].Value;
                    ValueToUpdate = ValueToUpdate.Replace("-Loan Count", "");
                    range.Value = ValueToUpdate;
                    range.Merge();
                    HeaderFormat_Static(range);
                    AllBorder_Static(range);

                    for (int i = mergecount; i <= mergecount + 13; i++)
                    {
                        string colname = GetColumnName(i);
                        sheet.Range[colname + "2"].Value = sheet.Range[colname + "2"].Value.Replace(ValueToUpdate + "-", "");
                    }

                    mergecount = mergecount + 14;
                }







                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                //sheet.AllocatedRange.AutoFitColumns();
                //sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Quality Q
            sheet = book.Worksheets.Add("Quality Q");
            DataTable dtQualityQ = new bllReport().GetQualityQ_Credit(Month, Year);
            if (dtQualityQ != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Quality Q sheet";
                dtQualityQ.Columns.Remove("ResultID");
                sheet.InsertDataTable(dtQualityQ, true, 1, 1);
                string Col = GetColumnName(dtQualityQ.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtQualityQ.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                sheet.InsertRow(1, 1);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B2"].AutoFitRows();
                sheet.Range["B2"].AutoFitRows();
                int mergecount = 2;
                while (mergecount < dtQualityQ.Columns.Count)
                {
                    string SCol = GetColumnName(mergecount);
                    string ECol = GetColumnName(mergecount + 15);
                    range = sheet.Range[SCol + "1:" + ECol + "1"];
                    string ValueToUpdate = sheet.Range[SCol + "2"].Value;
                    ValueToUpdate = ValueToUpdate.Replace("-Loan Count", "");
                    range.Value = ValueToUpdate;
                    range.Merge();
                    HeaderFormat_Static(range);
                    AllBorder_Static(range);

                    for (int i = mergecount; i <= mergecount + 15; i++)
                    {
                        string colname = GetColumnName(i);
                        sheet.Range[colname + "2"].Value = sheet.Range[colname + "2"].Value.Replace(ValueToUpdate + "-", "");
                    }

                    mergecount = mergecount + 16;
                }







                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                //sheet.AllocatedRange.AutoFitColumns();
                //sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Segment wise Utilisation
            sheet = book.Worksheets.Add("Segment wise Utilisation");
            DataTable dtSegUtil = new bllReport().GetAvgSalary_Credit(Month, Year);
            if (dtSegUtil != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Segment wise utilisation";
                dtSegUtil.Columns.Remove("Months");
                sheet.InsertDataTable(dtSegUtil, true, 1, 1);
                string Col = GetColumnName(dtSegUtil.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtSegUtil.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Individual Performance
            sheet = book.Worksheets.Add("Individual Performance");
            DataTable dtIndPer = new bllReport().GetIndividualPerformance_Credit(Month, Year);
            if (dtIndPer != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Individual performance";
                dtIndPer.Columns.Remove("Salary");
                dtIndPer.Columns.Remove("Month");
                dtIndPer.Columns.Remove("TotalOpprtinities");
                dtIndPer.Columns.Remove("MissedOpportunities");
                dtIndPer.Columns["ProductivityPercentage"].Caption = "Utilisation %";
                dtIndPer.Columns["QualPerc"].Caption = "Quality %";
                sheet.InsertDataTable(dtIndPer, true, 1, 1);
                string Col = GetColumnName(dtIndPer.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtIndPer.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Production Report
            sheet = book.Worksheets.Add("Production Report");
            DataTable dtProd = new bllReport().GetProductionReport_Credit(Month, Year);
            if (dtProd != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Production report";
                dtProd.Columns.Remove("ProdID");
                dtProd.Columns.Remove("ProjectID");
                dtProd.Columns.Remove("DueDate");
                dtProd.Columns.Remove("DispatchDate");
                dtProd.Columns.Remove("FinalStatus");
                dtProd.Columns.Remove("SciennaID");
                dtProd.Columns.Remove("Status");
                dtProd.Columns.Remove("Target");
                dtProd.Columns.Remove("Flag");
                dtProd.Columns.Remove("TAT");
                dtProd.Columns.Remove("HstartDate");
                dtProd.Columns.Remove("HEndDate");
                dtProd.Columns.Remove("Process");
                dtProd.Columns["Code"].SetOrdinal(0);
                dtProd.Columns["Employee"].SetOrdinal(1);
                dtProd.Columns["Projectname"].SetOrdinal(2);
                dtProd.Columns["Projectname"].Caption = "Project #";
                dtProd.Columns["DealNo"].SetOrdinal(3);
                dtProd.Columns["DealNo"].Caption = "Deal #";
                dtProd.Columns["LoanNo"].SetOrdinal(4);
                dtProd.Columns["LoanNo"].Caption = "Loan #";
                dtProd.Columns["OrderDate"].SetOrdinal(5);
                dtProd.Columns["OrderDate"].Caption = "Received Date";
                dtProd.Columns["Process1"].SetOrdinal(6);
                dtProd.Columns["Process1"].Caption = "Process";
                dtProd.Columns["Date"].SetOrdinal(7);
                dtProd.Columns["Date"].Caption = "Process Date";
                dtProd.Columns["StartDate"].SetOrdinal(8);
                dtProd.Columns["StartDate"].Caption = "Start Time";
                dtProd.Columns["EndDate"].SetOrdinal(9);
                dtProd.Columns["EndDate"].Caption = "End Time";
                sheet.InsertDataTable(dtProd, true, 1, 1);
                string Col = GetColumnName(dtProd.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtProd.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Feedback Dump
            sheet = book.Worksheets.Add("Feedback Dump");
            DataTable dtfeedback = new bllReport().GetFeedbackdump_Credit(Month, Year);
            if (dtfeedback != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Feedback dump";
                sheet.InsertDataTable(dtfeedback, true, 1, 1);
                string Col = GetColumnName(dtfeedback.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtfeedback.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion
            #region Weekly Trending Report
            sheet = book.Worksheets.Add("Weekly Trending Report");
            DataTable dtweekly = new bllReport().GetWeeklyTrending_Credit(Month, Year);
            if (dtweekly != null)
            {
                HttpContext.Current.Request.Form["spntext"] = "Preparing Weekly trending";
                sheet.InsertDataTable(dtweekly, true, 1, 1);
                string Col = GetColumnName(dtweekly.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtweekly.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertRow(1, 1);
                int startmerge = 3;
                for (int cl = 3; cl < dtweekly.Columns.Count; cl++)
                {
                    string MergeCol = GetColumnName(startmerge);
                    string Cols = GetColumnName(cl);
                    string PrevCols = GetColumnName(cl - 1);
                    //Current Header
                    string Headers = Convert.ToString(sheet.Range[Cols + "2"].Value);
                    string[] splitheader = Headers.Split(':');
                    string week = Convert.ToString(splitheader[0]);
                    string MainHeader = Convert.ToString(splitheader[1]);

                    //Previous Header
                    string PRevHeader = sheet.Range[PrevCols + "1"].Value;

                    sheet.Range[Cols + "1"].Value = MainHeader;
                    sheet.Range[Cols + "2"].Value = week.Trim();
                    if (cl > 3 && PRevHeader != MainHeader)
                    {
                        string tillMergeCol = GetColumnName(cl - 1);
                        sheet.Range[MergeCol + "1:" + tillMergeCol + "1"].Merge();
                        startmerge = cl;
                    }
                    if (cl == dtweekly.Columns.Count - 1)
                    {
                        string tillMergeCol = GetColumnName(cl);
                        sheet.Range[MergeCol + "1:" + tillMergeCol + "1"].Merge();
                        startmerge = cl;
                    }
                }
                string LastCol = GetColumnName(dtweekly.Columns.Count - 1);
                sheet.Range["A2:" + LastCol + "2"].IsWrapText = true;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

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
        public static int CreateProjectInflow(string Month, string Year)
        {
            int returnvalue = 1;
            //string Month = Convert.ToString(Request.Form["creditcons_month"]);
            //string Year = Convert.ToString(Request.Form["creditcons_year"]);


            //string Month = Convert.ToString(HttpContext.Current.Request.Form["creditcons_month"]);
            //string Year = Convert.ToString(HttpContext.Current.Request.Form["creditcons_year"]);

            FileName = HttpContext.Current.Server.MapPath(@"~\ReportDocument\Credit_Consolidated_Report_" + Convert.ToString(Month) + "-" + Convert.ToString(Year) + DateTime.Now.ToString("hhmmss") + ".xlsx");

            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";

            int rowcount = 0;
            int colcount = 0;

            #region Project Inflow
            sheet = book.Worksheets.Add("Project Inflow");
            DataTable dtInflow = new bllReport().GetProjectInflow_Credit(Month, Year);
            if (dtInflow != null)
            {

                sheet.InsertDataTable(dtInflow, true, 1, 1);
                string Col = GetColumnName(dtInflow.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtInflow.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion

            return returnvalue;
        }

        [WebMethod]
        public static int ProjectQ(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;

            #region Project Q
            sheet = book.Worksheets.Add("Project Q");
            DataTable dtProject = new bllReport().GetProjectQ_Credit(Month, Year);
            if (dtProject != null)
            {
                sheet.InsertDataTable(dtProject, true, 1, 1);
                string Col = GetColumnName(dtProject.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range.IsWrapText = true;
                range = sheet.Range["A1:" + Col + (dtProject.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertRow(1, 1);

                range = sheet.Range["A2:" + Col + "2"];
                range.IsWrapText = true;

                string SCol = GetColumnName(3);
                sheet.Range[SCol + "2"].Value = Month + " Del";

                SCol = GetColumnName(4);
                string ECol = GetColumnName(6);
                range = sheet.Range[SCol + "1:" + ECol + "1"];
                range.Value = "Critical";
                range.Merge();
                HeaderFormat_Static(range);
                ContentCenter_Static(range);
                AllBorder_Static(range);

                SCol = GetColumnName(7);
                ECol = GetColumnName(9);
                range = sheet.Range[SCol + "1:" + ECol + "1"];
                range.Value = "Non-Critical";
                range.Merge();
                HeaderFormat_Static(range);
                ContentCenter_Static(range);
                AllBorder_Static(range);


                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.Range["C1:C" + (dtProject.Rows.Count + 2)].IsWrapText = false;

                // Chart display
                Chart chart = sheet.Charts.Add(ExcelChartType.LineMarkers);

                chart.DataRange = sheet.Range["N3:Q" + Convert.ToString(rowcount + 1)];
                sheet.Range.IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                sheet.Range.NumberFormat = "0";

                chart.SeriesDataFromRange = false;
                //Chart border  
                chart.ChartArea.Border.Weight = ChartLineWeightType.Medium;
                chart.ChartArea.Border.Color = Color.SandyBrown;
                //Chart position  
                chart.LeftColumn = 2;
                chart.TopRow = rowcount + 3;
                chart.RightColumn = 12;
                chart.BottomRow = 25;
                //Chart title  
                chart.ChartTitle = "Project Quality";
                chart.ChartTitleArea.Font.FontName = "Aptos Narrow";
                chart.ChartTitleArea.Font.Size = 13;
                chart.ChartTitleArea.Font.IsBold = true;
                //Chart axis  
                chart.PrimaryCategoryAxis.Title = "Project";
                chart.PrimaryCategoryAxis.Font.Color = Color.Blue;
                chart.PrimaryValueAxis.Title = "Percentage";
                chart.PrimaryValueAxis.HasMajorGridLines = false;
                chart.PrimaryValueAxis.MaxValue = 100;
                chart.PrimaryValueAxis.TitleArea.TextRotationAngle = 90;


                foreach (Spire.Xls.Charts.ChartSerie cs in chart.Series)
                {
                    cs.CategoryLabels = sheet.Range["A3:A" + Convert.ToString(rowcount + 1)];
                }
                chart.Series[0].Name = "Review";
                chart.Series[1].Name = "QC";
                chart.Series[2].Name = "ReQC";
                chart.Series[3].Name = "Client";

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion

            return returnvalue;
        }

        [WebMethod]
        public static int SegmentQ(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;
            #region Segment Q
            sheet = book.Worksheets.Add("Segment Q");
            DataTable dtSeg = new bllReport().GetSegmentQ_Credit(Month, Year);
            if (dtSeg != null)
            {
                sheet.InsertDataTable(dtSeg, true, 1, 1);
                string Col = GetColumnName(dtSeg.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtSeg.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();

                Chart chart = sheet.Charts.Add(ExcelChartType.ScatterLineMarkers);
                int ColCount = sheet.LastColumn;
                string ColName = GetColumnName(ColCount - 1);
                chart.DataRange = sheet.Range["B2:" + Convert.ToString(Col) + Convert.ToString(rowcount + 1)];
                sheet.Range.IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                sheet.Range.NumberFormat = "0.0";

                chart.SeriesDataFromRange = false;
                //Chart border  
                chart.ChartArea.Border.Weight = ChartLineWeightType.Medium;
                chart.ChartArea.Border.Color = Color.SandyBrown;
                //Chart position  
                chart.LeftColumn = 1;
                chart.TopRow = rowcount + 3;
                chart.RightColumn = 6;
                chart.BottomRow = 20;
                //Chart title  
                chart.ChartTitle = "Segment Quality";
                chart.ChartTitleArea.Font.FontName = "Aptos Narrow";
                chart.ChartTitleArea.Font.Size = 13;
                chart.ChartTitleArea.Font.IsBold = true;
                //Chart axis  
                chart.PrimaryCategoryAxis.Title = "Segment";
                chart.PrimaryCategoryAxis.Font.Color = Color.Blue;
                chart.PrimaryValueAxis.Title = "Percentage";

                chart.PrimaryValueAxis.HasMajorGridLines = false;
                //chart.PrimaryValueAxis.MaxValue = 100;
                chart.PrimaryValueAxis.TitleArea.TextRotationAngle = 90;

                foreach (Spire.Xls.Charts.ChartSerie cs in chart.Series)
                {
                    cs.CategoryLabels = sheet.Range["A2:A" + Convert.ToString(rowcount + 1)];
                }
                for (int i = 1; i < ColCount - 1; i++)
                {
                    chart.Series[i - 1].Name = sheet.Range[GetColumnName(i) + "1:" + GetColumnName(i) + "1"].Value;

                }
                //Chart legend  
                chart.Legend.Position = LegendPositionType.Right;
            }

            #endregion


            return returnvalue;
        }
        [WebMethod]
        public static int ReviewerQ(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;

            #region Reviewer Q
            sheet = book.Worksheets.Add("Reviewer Q");
            DataTable dtreviewQ = new bllReport().GetReviewerQ_Credit(Month, Year);
            if (dtreviewQ != null)
            {
                dtreviewQ.Columns.Remove("ResultID");
                sheet.InsertDataTable(dtreviewQ, true, 1, 1);
                string Col = GetColumnName(dtreviewQ.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtreviewQ.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                sheet.InsertRow(1, 1);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B2"].AutoFitRows();
                sheet.Range["B2"].AutoFitRows();
                int mergecount = 2;
                while (mergecount < dtreviewQ.Columns.Count)
                {
                    string SCol = GetColumnName(mergecount);
                    string ECol = GetColumnName(mergecount + 13);
                    range = sheet.Range[SCol + "1:" + ECol + "1"];
                    string ValueToUpdate = sheet.Range[SCol + "2"].Value;
                    ValueToUpdate = ValueToUpdate.Replace("-Loan Count", "");
                    range.Value = ValueToUpdate;
                    range.Merge();
                    HeaderFormat_Static(range);
                    AllBorder_Static(range);

                    for (int i = mergecount; i <= mergecount + 13; i++)
                    {
                        string colname = GetColumnName(i);
                        sheet.Range[colname + "2"].Value = sheet.Range[colname + "2"].Value.Replace(ValueToUpdate + "-", "");
                    }

                    mergecount = mergecount + 14;
                }







                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion



            return returnvalue;
        }
        [WebMethod]
        public static int QualityQ(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;

            #region Quality Q
            sheet = book.Worksheets.Add("Quality Q");
            DataTable dtQualityQ = new bllReport().GetQualityQ_Credit(Month, Year);
            if (dtQualityQ != null)
            {
                dtQualityQ.Columns.Remove("ResultID");
                sheet.InsertDataTable(dtQualityQ, true, 1, 1);
                string Col = GetColumnName(dtQualityQ.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtQualityQ.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                sheet.InsertRow(1, 1);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["A2:" + Col + "2"].IsWrapText = true;
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B1"].AutoFitColumns();
                sheet.Range["B2"].AutoFitRows();
                sheet.Range["B2"].AutoFitRows();
                int mergecount = 2;
                while (mergecount < dtQualityQ.Columns.Count)
                {
                    string SCol = GetColumnName(mergecount);
                    string ECol = GetColumnName(mergecount + 15);
                    range = sheet.Range[SCol + "1:" + ECol + "1"];
                    string ValueToUpdate = sheet.Range[SCol + "2"].Value;
                    ValueToUpdate = ValueToUpdate.Replace("-Loan Count", "");
                    range.Value = ValueToUpdate;
                    range.Merge();
                    HeaderFormat_Static(range);
                    AllBorder_Static(range);

                    for (int i = mergecount; i <= mergecount + 15; i++)
                    {
                        string colname = GetColumnName(i);
                        sheet.Range[colname + "2"].Value = sheet.Range[colname + "2"].Value.Replace(ValueToUpdate + "-", "");
                    }

                    mergecount = mergecount + 16;
                }







                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion


            return returnvalue;
        }
        [WebMethod]
        public static int SegmentwiseUtilisation(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;

            #region Segment wise Utilisation
            sheet = book.Worksheets.Add("Segment wise Utilisation");
            DataTable dtSegUtil = new bllReport().GetAvgSalary_Credit(Month, Year);
            if (dtSegUtil != null)
            {
                dtSegUtil.Columns.Remove("Months");
                dtSegUtil.Columns.Remove("TotalSalary");
                dtSegUtil.Columns.Remove("AvgSalary");
                sheet.InsertDataTable(dtSegUtil, true, 1, 1);
                string Col = GetColumnName(dtSegUtil.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtSegUtil.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();

                Chart chart = sheet.Charts.Add(ExcelChartType.ColumnClustered);
                //chart.DataRange = sheet.Range["B2:D" + Convert.ToString(RowCount)];
                sheet.Range.IgnoreErrorOptions = IgnoreErrorType.NumberAsText;
                sheet.Range.NumberFormat = "0";

                chart.SeriesDataFromRange = false;
                //Chart border  
                chart.ChartArea.Border.Weight = ChartLineWeightType.Medium;
                chart.ChartArea.Border.Color = Color.SandyBrown;
                //Chart position  
                chart.LeftColumn = 1;
                chart.TopRow = rowcount + 2;
                chart.RightColumn = 10;
                chart.BottomRow = 28;
                //Chart title  
                chart.ChartTitle = "Segment wise utilisation";
                chart.ChartTitleArea.Font.FontName = "Aptos Narrow";
                chart.ChartTitleArea.Font.Size = 13;
                chart.ChartTitleArea.Font.IsBold = true;
                //Chart axis  
                chart.PrimaryCategoryAxis.Title = "Project";
                chart.PrimaryCategoryAxis.Font.Color = Color.Blue;
                chart.PrimaryValueAxis.Title = "Average Production";
                chart.PrimaryValueAxis.HasMajorGridLines = false;
                //chart.PrimaryValueAxis.MaxValue = 100;
                chart.PrimaryValueAxis.TitleArea.TextRotationAngle = 90;

                var cs3 = chart.Series.Add("Average Production", ExcelChartType.ColumnClustered);
                cs3.Values = sheet.Range["E3:E" + Convert.ToString(rowcount)];
                var cs4 = chart.Series.Add("Utilisation", ExcelChartType.LineMarkers);
                cs4.Values = sheet.Range["H3:H" + Convert.ToString(rowcount)];

                cs4.UsePrimaryAxis = false;

                foreach (Spire.Xls.Charts.ChartSerie cs in chart.Series)
                {
                    cs.CategoryLabels = sheet.Range["B3:B" + Convert.ToString(rowcount)];

                }

                //Chart legend  
                chart.Legend.Position = LegendPositionType.Bottom;
            }
            #endregion



            return returnvalue;
        }

        [WebMethod]
        public static int IndividualPerformance(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;

            #region Individual Performance
            sheet = book.Worksheets.Add("Individual Performance");
            DataTable dtIndPer = new bllReport().GetIndividualPerformance_Credit(Month, Year);
            if (dtIndPer != null)
            {
                dtIndPer.Columns.Remove("Salary");
                dtIndPer.Columns.Remove("Month");
                dtIndPer.Columns.Remove("TotalOpprtinities");
                dtIndPer.Columns.Remove("MissedOpportunities");
                dtIndPer.Columns["ProductivityPercentage"].Caption = "Utilisation %";
                dtIndPer.Columns["QualPerc"].Caption = "Quality %";
                sheet.InsertDataTable(dtIndPer, true, 1, 1);
                string Col = GetColumnName(dtIndPer.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtIndPer.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion

            return returnvalue;
        }
        [WebMethod]
        public static int ProductionReport(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;

            #region Production Report
            sheet = book.Worksheets.Add("Production Report");
            DataTable dtProd = new bllReport().GetProductionReport_Credit(Month, Year);
            if (dtProd != null)
            {
                dtProd.Columns.Remove("ProdID");
                dtProd.Columns.Remove("ProjectID");
                dtProd.Columns.Remove("DueDate");
                dtProd.Columns.Remove("DispatchDate");
                dtProd.Columns.Remove("FinalStatus");
                dtProd.Columns.Remove("SciennaID");
                dtProd.Columns.Remove("Status");
                dtProd.Columns.Remove("Target");
                dtProd.Columns.Remove("Flag");
                dtProd.Columns.Remove("TAT");
                dtProd.Columns.Remove("HstartDate");
                dtProd.Columns.Remove("HEndDate");
                dtProd.Columns.Remove("Process");
                dtProd.Columns["Code"].SetOrdinal(0);
                dtProd.Columns["Employee"].SetOrdinal(1);
                dtProd.Columns["Projectname"].SetOrdinal(2);
                dtProd.Columns["Projectname"].Caption = "Project #";
                dtProd.Columns["DealNo"].SetOrdinal(3);
                dtProd.Columns["DealNo"].Caption = "Deal #";
                dtProd.Columns["LoanNo"].SetOrdinal(4);
                dtProd.Columns["LoanNo"].Caption = "Loan #";
                dtProd.Columns["OrderDate"].SetOrdinal(5);
                dtProd.Columns["OrderDate"].Caption = "Received Date";
                dtProd.Columns["Process1"].SetOrdinal(6);
                dtProd.Columns["Process1"].Caption = "Process";
                dtProd.Columns["Date"].SetOrdinal(7);
                dtProd.Columns["Date"].Caption = "Process Date";
                dtProd.Columns["StartDate"].SetOrdinal(8);
                dtProd.Columns["StartDate"].Caption = "Start Time";
                dtProd.Columns["EndDate"].SetOrdinal(9);
                dtProd.Columns["EndDate"].Caption = "End Time";
                sheet.InsertDataTable(dtProd, true, 1, 1);
                string Col = GetColumnName(dtProd.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtProd.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion

            return returnvalue;
        }
        [WebMethod]
        public static int FeedbackDump(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;

            #region Feedback Dump
            sheet = book.Worksheets.Add("Feedback Dump");
            DataTable dtfeedback = new bllReport().GetFeedbackdump_Credit(Month, Year);
            if (dtfeedback != null)
            {
                sheet.InsertDataTable(dtfeedback, true, 1, 1);
                string Col = GetColumnName(dtfeedback.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtfeedback.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion


            return returnvalue;
        }
        [WebMethod]
        public static int WeeklyTrendingReport(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;
            #region Weekly Trending Report
            sheet = book.Worksheets.Add("Weekly Trending Report");
            DataTable dtweekly = new bllReport().GetWeeklyTrending_Credit(Month, Year);
            if (dtweekly != null)
            {
                sheet.InsertDataTable(dtweekly, true, 1, 1);
                string Col = GetColumnName(dtweekly.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtweekly.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertRow(1, 1);
                int startmerge = 3;
                for (int cl = 3; cl < dtweekly.Columns.Count; cl++)
                {
                    string MergeCol = GetColumnName(startmerge);
                    string Cols = GetColumnName(cl);
                    string PrevCols = GetColumnName(cl - 1);
                    //Current Header
                    string Headers = Convert.ToString(sheet.Range[Cols + "2"].Value);
                    string[] splitheader = Headers.Split(':');
                    string week = Convert.ToString(splitheader[0]);
                    string MainHeader = Convert.ToString(splitheader[1]);

                    //Previous Header
                    string PRevHeader = sheet.Range[PrevCols + "1"].Value;

                    sheet.Range[Cols + "1"].Value = MainHeader;
                    sheet.Range[Cols + "2"].Value = week.Trim();
                    if (cl > 3 && PRevHeader != MainHeader)
                    {
                        string tillMergeCol = GetColumnName(cl - 1);
                        sheet.Range[MergeCol + "1:" + tillMergeCol + "1"].Merge();
                        startmerge = cl;
                    }
                    if (cl == dtweekly.Columns.Count - 1)
                    {
                        string tillMergeCol = GetColumnName(cl);
                        sheet.Range[MergeCol + "1:" + tillMergeCol + "1"].Merge();
                        startmerge = cl;
                    }
                }
                string LastCol = GetColumnName(dtweekly.Columns.Count - 1);
                sheet.Range["A2:" + LastCol + "2"].IsWrapText = true;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion


            return returnvalue;
        }

        [WebMethod]
        public static int MonthlyTrendingReport(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;
            #region Weekly Trending Report
            sheet = book.Worksheets.Add("Monthly Trending Report");
            DataTable dtmonthly = new bllReport().GetMonthlyTrending_Credit(Month, Year);
            if (dtmonthly != null)
            {
                sheet.InsertDataTable(dtmonthly, true, 1, 1);
                string Col = GetColumnName(dtmonthly.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtmonthly.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                //sheet.InsertRow(1, 1);
                //int startmerge = 3;
                //for (int cl = 3; cl < dtmonthly.Columns.Count; cl++)
                //{
                //    string MergeCol = GetColumnName(startmerge);
                //    string Cols = GetColumnName(cl);
                //    string PrevCols = GetColumnName(cl - 1);
                //    //Current Header
                //    string Headers = Convert.ToString(sheet.Range[Cols + "2"].Value);
                //    string[] splitheader = Headers.Split(':');
                //    string week = Convert.ToString(splitheader[0]);
                //    string MainHeader = Convert.ToString(splitheader[1]);

                //    //Previous Header
                //    string PRevHeader = sheet.Range[PrevCols + "1"].Value;

                //    sheet.Range[Cols + "1"].Value = MainHeader;
                //    sheet.Range[Cols + "2"].Value = week.Trim();
                //    if (cl > 3 && PRevHeader != MainHeader)
                //    {
                //        string tillMergeCol = GetColumnName(cl - 1);
                //        sheet.Range[MergeCol + "1:" + tillMergeCol + "1"].Merge();
                //        startmerge = cl;
                //    }
                //    if (cl == dtmonthly.Columns.Count - 1)
                //    {
                //        string tillMergeCol = GetColumnName(cl);
                //        sheet.Range[MergeCol + "1:" + tillMergeCol + "1"].Merge();
                //        startmerge = cl;
                //    }
                //}

                //string LastCol = GetColumnName(dtmonthly.Columns.Count - 1);
                //sheet.Range["A2:" + LastCol + "2"].IsWrapText = true;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion


            return returnvalue;
        }

        [WebMethod]
        public static int ErrorTrendingAll(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;
            #region Weekly Trending Report
            sheet = book.Worksheets.Add("Error Trending - All");
            DataTable dtErrorTrendingAll = new bllReport().GetErrorTrendingAll_Credit(Month, Year);
            if (dtErrorTrendingAll != null)
            {
                sheet.InsertDataTable(dtErrorTrendingAll, true, 1, 1);
                string Col = GetColumnName(dtErrorTrendingAll.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtErrorTrendingAll.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();
            }
            #endregion

            return returnvalue;
        }

        [WebMethod]
        public static int ErrorTrendingUser(string Month, string Year)
        {
            int returnvalue = 1;
            int rowcount = 0;
            int colcount = 0;
            #region Weekly Trending Report
            sheet = book.Worksheets.Add("Error Trending - User");
            DataTable dtErrorTrendingAll = new bllReport().GetErrorTrendingUser_Credit(Month, Year);
            if (dtErrorTrendingAll != null)
            {
                sheet.InsertDataTable(dtErrorTrendingAll, true, 1, 1);
                string Col = GetColumnName(dtErrorTrendingAll.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat_Static(range);
                range = sheet.Range["A1:" + Col + (dtErrorTrendingAll.Rows.Count + 1)];
                AllBorder_Static(range);
                ContentCenter_Static(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

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
    }
}