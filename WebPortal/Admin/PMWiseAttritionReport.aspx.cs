using ClosedXML.Excel;
using Spire.Xls;
using System;
using System.Collections;
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
    public partial class PMWiseAttritionReport : System.Web.UI.Page
    {
        public static DataTable dtSummary = new DataTable();
        public static DataTable dtAbsconding = new DataTable();
        public static DataTable dtResigned = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetReportingManagerList()
        {
            DataTable dt1 = new bllMaster().GetReportingManagerList();
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
        public static string GetReportingManagerWiseAttrition(string FromDate, string ToDate, int PMID)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            Hashtable htParam = new Hashtable();
            htParam.Add("FromDate", FromDate);
            htParam.Add("ToDate", ToDate);
            htParam.Add("PMID", PMID);
            DataSet ds = new bllMaster().GetReportingManagerWiseAttrition(htParam);
            if (ds != null)
            {
                dtSummary = ds.Tables[0];
                dtAbsconding = ds.Tables[1];
                dtResigned = ds.Tables[2];

                foreach (DataRow dr in dtSummary.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dtSummary.Columns)
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
        public static string GetNewJoined()
        {
            DataTable dt1 = dtAbsconding.Copy();
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
        public static string GetResignedEmployees()
        {
            DataTable dt1 = dtResigned.Copy();
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
        protected void btn21_Click(object sender, EventArgs e)
        {
            string FromDate = "";
            string ToDate = "";
            string pm = "";
            FromDate = Convert.ToString(HttpContext.Current.Request.Form["pmatr_from"]);
            ToDate = Convert.ToString(HttpContext.Current.Request.Form["pmatr_to"]);
            pm = Convert.ToString(HttpContext.Current.Request.Form["pmatr_pm"]);
            Hashtable htParam = new Hashtable();
            htParam.Add("FromDate", FromDate);
            htParam.Add("ToDate", ToDate);
            htParam.Add("PMID", pm);
            string FileName = Server.MapPath(@"~\ReportDocument\PM_Attrition_Report_" + Convert.ToString(FromDate) + "-" + Convert.ToString(ToDate) + DateTime.Now.ToString("hhmmss") + ".xlsx");
            Workbook book = new Workbook();
            //book.LoadFromFile(FileName);
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";

            int rowcount = 0;
            int colcount = 0;

            Worksheet sheet = book.Worksheets.Add("Summary");
            DataSet ds = new DataSet();
            ds = new bllMaster().GetReportingManagerWiseAttrition(htParam);
            if (ds != null)
            {
                DataTable dtSummary = ds.Tables[0];
                DataTable dtNew = ds.Tables[1];
                DataTable dtRes = ds.Tables[2];

                sheet = book.Worksheets.Add("Summary");
                sheet.InsertDataTable(dtSummary, true, 1, 1);
                string Col = GetColumnName(dtSummary.Columns.Count - 1);
                CellRange range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtSummary.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();

                sheet = book.Worksheets.Add("New Joined");
                sheet.InsertDataTable(dtNew, true, 1, 1);
                Col = GetColumnName(dtNew.Columns.Count - 1);
                range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtNew.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();


                sheet = book.Worksheets.Add("Absconded & Resigned");
                sheet.InsertDataTable(dtRes, true, 1, 1);
                Col = GetColumnName(dtRes.Columns.Count - 1);
                range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtRes.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();

                if (File.Exists(FileName))
                {
                    try
                    {
                        File.Delete(FileName);
                    }
                    catch { }
                }
                book.SaveToFile(FileName, ExcelVersion.Version2010);
                book.Dispose();




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
                        worksheet = workbook.Worksheet(4);
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