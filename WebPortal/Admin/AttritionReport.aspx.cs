using ClosedXML.Excel;
using Newtonsoft.Json;
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
    public partial class AttritionReport : System.Web.UI.Page
    {
        static DataTable dtMonth = new DataTable();
        static DataTable dtLocation = new DataTable();
        static DataTable dtDomain = new DataTable();
        static DataTable dtCategory = new DataTable();
        static DataTable dtDomainHead = new DataTable();
        static DataTable dtLocationHead = new DataTable();
        static DataTable dtExclude = new DataTable();

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string GetDomainsAsPerEmp()
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = new bllMaster().GetDomainsAsPerEmp(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetAttritionReport(string Month, string Year, int DomainID)
        {
            //usp_AttritionReport_ICG
            DataSet ds = new bllMaster().GetAttritionReport_ds(Month, Year, DomainID, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (ds != null)
            {
                DataTable dt1 = ds.Tables[0];
                dtMonth = ds.Tables[1];
                dtLocation = ds.Tables[2];
                dtDomain = ds.Tables[3];
                dtCategory = ds.Tables[4];
                dtDomainHead = ds.Tables[5];
                dtLocationHead = ds.Tables[6];
                dtExclude = ds.Tables[7];

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
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetAttritionSummary_Month(string Month, string Year, int DomainID)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = dtMonth.Copy();
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
        public static string GetDetailsForExcludeRemark(int EmployeeID)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = new bllMaster().GetDetailsForExcludeRemark(EmployeeID);
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
        public static string GetAttritionSummary_Location(string Month, string Year, int DomainID)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = dtLocation.Copy();
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
        public static string GetAttritionSummary_Domain(string Month, string Year, int DomainID)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = dtDomain.Copy();
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
        public static string GetAttritionSummary_Category(string Month, string Year, int DomainID)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = dtCategory.Copy();
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
        public static string GetAttritionSummary_DomainHead(string Month, string Year, int DomainID)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = dtDomainHead.Copy();
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
        public static string GetAttritionSummary_LocationHead(string Month, string Year, int DomainID)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = dtLocationHead.Copy();
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
        public static string GetAllExcludedEmployees(string Month, string Year, int DomainID)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            DataTable dt1 = dtExclude.Copy();
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
        public static int InsertAttritioNRemark(string Code, string Remark, string ResignationDate)
        {
            int returnvalue = 0;
            returnvalue = new bllMaster().InsertAttritioNRemark(Code, Remark, ResignationDate);
            return returnvalue;
        }

        protected void btn1_Click(object sender, EventArgs e)
        {
            string FromDate = "";
            string ToDate = "";
            string domain = "";
            FromDate = Convert.ToString(HttpContext.Current.Request.Form["attrition_from"]);
            ToDate = Convert.ToString(HttpContext.Current.Request.Form["attrition_to"]);
            domain = Convert.ToString(HttpContext.Current.Request.Form["attrition_domain"]);
            if (domain == "")
                domain = "0";
            string FileName = Server.MapPath(@"~\ReportDocument\Attrition_Report_" + Convert.ToString(FromDate) + "-" + Convert.ToString(ToDate) + DateTime.Now.ToString("hhmmss") + ".xlsx");
            Workbook book = new Workbook();
            //book.LoadFromFile(FileName);
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";

            int rowcount = 0;
            int colcount = 0;

            Worksheet sheet = book.Worksheets.Add("Summary");
            DataSet ds = new DataSet();
            ds = new bllMaster().GetAttritionReport_ds(Convert.ToString(FromDate), Convert.ToString(ToDate), Convert.ToInt32(domain), int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (ds != null)
            {
                DataTable dtDetails = ds.Tables[0];
                DataTable dtSummaryMonth = ds.Tables[1];
                DataTable dtSummaryLocation = ds.Tables[2];
                DataTable dtSummaryDomain = ds.Tables[3];
                DataTable dtSummaryCategory = ds.Tables[4];
                DataTable dtSummaryDH = ds.Tables[5];
                DataTable dtSummaryLH = ds.Tables[6];
                DataTable dtExclude = ds.Tables[7];

                sheet.InsertDataTable(dtSummaryMonth, true, 2, 1);
                string Col = GetColumnName(dtSummaryMonth.Columns.Count - 1);
                CellRange rangeHeader = sheet.Range["A1:" + Col + "1"];
                rangeHeader.Value = "Month wise Summary";
                rangeHeader.Merge();
                HeaderFormat(rangeHeader);
                CellRange range = sheet.Range["A2:" + Col + "2"];
                HeaderFormat(range);
                range = sheet.Range["A2:" + Col + (dtSummaryMonth.Rows.Count + 2)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertDataTable(dtSummaryLocation, true, rowcount + 3, 1);
                Col = GetColumnName(dtSummaryLocation.Columns.Count - 1);
                rangeHeader = sheet.Range["A" + (rowcount + 2) + ":" + Col + "" + (rowcount + 2)];
                rangeHeader.Value = "Location wise Summary";
                rangeHeader.Merge();
                HeaderFormat(rangeHeader);
                range = sheet.Range["A" + (rowcount + 3) + ":" + Col + "" + (rowcount + 3)];
                HeaderFormat(range);
                range = sheet.Range["A" + (rowcount + 3) + ":" + Col + (dtSummaryLocation.Rows.Count + 1 + rowcount + 3)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertDataTable(dtSummaryDomain, true, rowcount + 3, 1);
                Col = GetColumnName(dtSummaryDomain.Columns.Count - 1);
                rangeHeader = sheet.Range["A" + (rowcount + 2) + ":" + Col + "" + (rowcount + 2)];
                rangeHeader.Value = "Domain wise Summary";
                rangeHeader.Merge();
                HeaderFormat(rangeHeader);
                range = sheet.Range["A" + (rowcount + 3) + ":" + Col + "" + (rowcount + 3)];
                HeaderFormat(range);
                range = sheet.Range["A" + (rowcount + 3) + ":" + Col + (dtSummaryDomain.Rows.Count + 1 + rowcount + 3)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertDataTable(dtSummaryCategory, true, rowcount + 3, 1);
                Col = GetColumnName(dtSummaryCategory.Columns.Count - 1);
                rangeHeader = sheet.Range["A" + (rowcount + 2) + ":" + Col + "" + (rowcount + 2)];
                rangeHeader.Value = "Category wise Summary";
                rangeHeader.Merge();
                HeaderFormat(rangeHeader);
                range = sheet.Range["A" + (rowcount + 3) + ":" + Col + "" + (rowcount + 3)];
                HeaderFormat(range);
                range = sheet.Range["A" + (rowcount + 3) + ":" + Col + (dtSummaryCategory.Rows.Count + 1 + rowcount + 3)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertDataTable(dtSummaryDH, true, rowcount + 3, 1);
                Col = GetColumnName(dtSummaryDH.Columns.Count - 1);
                rangeHeader = sheet.Range["A" + (rowcount + 2) + ":" + Col + "" + (rowcount + 2)];
                rangeHeader.Value = "Domain Head wise Summary";
                rangeHeader.Merge();
                HeaderFormat(rangeHeader);
                range = sheet.Range["A" + (rowcount + 3) + ":" + Col + "" + (rowcount + 3)];
                HeaderFormat(range);
                range = sheet.Range["A" + (rowcount + 3) + ":" + Col + (dtSummaryDH.Rows.Count + 1 + rowcount + 3)];
                AllBorder(range);
                ContentCenter(range);
                rowcount = sheet.LastRow;
                colcount = sheet.LastColumn;

                sheet.InsertDataTable(dtSummaryLH, true, rowcount + 3, 1);
                Col = GetColumnName(dtSummaryLH.Columns.Count - 1);
                rangeHeader = sheet.Range["A" + (rowcount + 2) + ":" + Col + "" + (rowcount + 2)];
                rangeHeader.Value = "Location Head wise Summary";
                rangeHeader.Merge();
                HeaderFormat(rangeHeader);
                range = sheet.Range["A" + (rowcount + 3) + ":" + Col + "" + (rowcount + 3)];
                HeaderFormat(range);
                range = sheet.Range["A" + (rowcount + 3) + ":" + Col + (dtSummaryLH.Rows.Count + 1 + rowcount + 3)];
                AllBorder(range);
                ContentCenter(range);


                sheet.InsertRow(1, 3);
                CellRange rangeloss = sheet.Range["A2:G2"];
                rangeloss.Value = "Attrition Cost ::  Tenure: 0 to 3 months : 100% loss;  4 to 6 months : 50% loss;  7 to 18 months : 25% loss";
                rangeloss.Merge();
                rangeloss.Style.Borders.LineStyle = LineStyleType.Thin;
                rangeloss.Style.Borders[BordersLineType.DiagonalUp].LineStyle = LineStyleType.None;
                rangeloss.Style.Borders[BordersLineType.DiagonalDown].LineStyle = LineStyleType.None;
                rangeloss.Style.Color = Color.FromArgb(255, 255, 0);
                rangeloss.Style.Font.Color = Color.Black;
                rangeloss.Style.HorizontalAlignment = HorizontalAlignType.Center;
                rangeloss.Style.Font.IsBold = true;

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 11;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();


                dtDetails.Columns.Remove("Dates");
                dtDetails.Columns.Remove("EmployeeID");
                dtDetails.Columns.Remove("ShiftTime");
                dtDetails.Columns.Remove("CutOffTime");
                dtDetails.Columns.Remove("Salary");
                dtDetails.Columns.Remove("TenureInMonth");

                sheet = book.Worksheets.Add("Details");
                sheet.InsertDataTable(dtDetails, true, 1, 1);
                Col = GetColumnName(dtDetails.Columns.Count - 1);
                range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtDetails.Rows.Count + 1)];
                AllBorder(range);
                ContentCenter(range);

                sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                sheet.AllocatedRange.Style.Font.Size = 10;

                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();

                dtExclude.Columns.Remove("EmployeeID");
                dtExclude.Columns.Remove("ShiftTime");
                dtExclude.Columns.Remove("CutOffTime");
                dtExclude.Columns.Remove("Salary");
                dtExclude.Columns.Remove("TenureInMonth");

                sheet = book.Worksheets.Add("Excluded Employees");
                sheet.InsertDataTable(dtExclude, true, 1, 1);
                Col = GetColumnName(dtExclude.Columns.Count - 1);
                range = sheet.Range["A1:" + Col + "1"];
                HeaderFormat(range);
                range = sheet.Range["A1:" + Col + (dtExclude.Rows.Count + 1)];
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
    }
}