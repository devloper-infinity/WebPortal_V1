using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using ClosedXML.Excel;

namespace WebPortal.Admin
{
    public partial class DomainWiseEmployeeReport : System.Web.UI.Page
    {
        static DataTable dtExport = null;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string DomainWiseEmployeeCount(string Month, string Year)
        {
            try
            {
                DataTable dt = new bllMaster().DomainWiseEmployeeCount(Month, Year);

                if (dt != null && dt.Rows.Count > 0)
                {
                    dtExport = dt;
                    return JsonConvert.SerializeObject(dt);
                }

                // Return empty JSON array
                return "[]";
            }
            catch (Exception ex)
            {
                // Optional logging
                // ErrorLogs.Log(ex);

                return "[]";
            }
        }

        protected void core_btn_exportDomainWise_Click(object sender, EventArgs e)
        {
            try
            {
                // GET DATA
                DataTable dt = dtExport; // YOUR METHOD

                if (dt == null || dt.Rows.Count == 0)
                    return;

                using (XLWorkbook wb = new XLWorkbook())
                {
                    var ws = wb.Worksheets.Add("Domain Report");

                    int rowNo = 1;

                    // =========================================
                    // TITLE
                    // =========================================

                    ws.Cell(rowNo, 1).Value = "DOMAIN WISE EMPLOYEE REPORT";

                    ws.Range(rowNo, 1, rowNo, 10).Merge();

                    ws.Cell(rowNo, 1).Style.Font.Bold = true;
                    ws.Cell(rowNo, 1).Style.Font.FontSize = 16;
                    ws.Cell(rowNo, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    rowNo += 2;

                    // =========================================
                    // HEADER
                    // =========================================

                    ws.Cell(rowNo, 1).Value = "Sr No";
                    ws.Cell(rowNo, 2).Value = "Domain";
                    ws.Cell(rowNo, 3).Value = "SubDomain";
                    ws.Cell(rowNo, 4).Value = "Branch";
                    ws.Cell(rowNo, 5).Value = "Segment";
                    ws.Cell(rowNo, 6).Value = "Day";
                    ws.Cell(rowNo, 7).Value = "Night";
                    ws.Cell(rowNo, 8).Value = "Grand Total";
                    ws.Cell(rowNo, 9).Value = "Tenure < 1 Year";
                    ws.Cell(rowNo, 10).Value = "Tenure > 1 Year";

                    var headerRange = ws.Range(rowNo, 1, rowNo, 10);

                    headerRange.Style.Font.Bold = true;
                    headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#B3A27A");
                    headerRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                    headerRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    headerRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                    rowNo++;

                    // =========================================
                    // GROUPING LOGIC
                    // =========================================

                    var domainGroups = dt.AsEnumerable()
                                         .GroupBy(x => x["DomainName"].ToString());

                    int srNo = 1;

                    int finalDay = 0;
                    int finalNight = 0;
                    int finalGrand = 0;
                    int finalBelow = 0;
                    int finalAbove = 0;

                    foreach (var group in domainGroups)
                    {
                        string domain = group.Key;

                        int startRow = rowNo;

                        // DOMAIN TOTALS

                        int totalDay = group.Sum(x => Convert.ToInt32(x["DayCount"]));
                        int totalNight = group.Sum(x => Convert.ToInt32(x["NightCount"]));
                        int totalGrand = group.Sum(x => Convert.ToInt32(x["GrandTotal"]));
                        int totalBelow = group.Sum(x => Convert.ToInt32(x["TenureLessThan1Year"]));
                        int totalAbove = group.Sum(x => Convert.ToInt32(x["TenureAbove1Year"]));

                        // =========================================
                        // GROUP HEADER
                        // =========================================

                        ws.Cell(rowNo, 1).Value = "DOMAIN : " + domain;

                        ws.Range(rowNo, 1, rowNo, 5).Merge();

                        ws.Cell(rowNo, 6).Value = totalDay;
                        ws.Cell(rowNo, 7).Value = totalNight;
                        ws.Cell(rowNo, 8).Value = totalGrand;
                        ws.Cell(rowNo, 9).Value = totalBelow;
                        ws.Cell(rowNo, 10).Value = totalAbove;

                        var grpRange = ws.Range(rowNo, 1, rowNo, 10);

                        grpRange.Style.Font.Bold = true;
                        grpRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#E5DFD2");
                        grpRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                        grpRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                        rowNo++;

                        // =========================================
                        // DETAIL ROWS
                        // =========================================

                        int mergeStartRow = rowNo;
                        int mergeEndRow = rowNo + group.Count() - 1;

                        bool firstRow = true;

                        foreach (var item in group)
                        {
                            ws.Cell(rowNo, 1).Value = srNo;

                            // MERGED DOMAIN COLUMN
                            if (firstRow)
                            {
                                ws.Cell(rowNo, 2).Value = domain;

                                if (mergeStartRow != mergeEndRow)
                                {
                                    ws.Range(mergeStartRow, 2, mergeEndRow, 2).Merge();
                                }

                                ws.Cell(rowNo, 2).Style.Alignment.Vertical =
                                    XLAlignmentVerticalValues.Center;

                                firstRow = false;
                            }

                            //ws.Cell(rowNo, 3).Value = item["SubDomain"];
                            //ws.Cell(rowNo, 4).Value = item["BranchName"];
                            //ws.Cell(rowNo, 5).Value = item["Segment"];
                            //ws.Cell(rowNo, 6).Value = item["DayCount"];
                            //ws.Cell(rowNo, 7).Value = item["NightCount"];
                            //ws.Cell(rowNo, 8).Value = item["GrandTotal"];
                            //ws.Cell(rowNo, 9).Value = item["TenureLessThan1Year"];
                            //ws.Cell(rowNo, 10).Value = item["TenureAbove1Year"];

                            ws.Cell(rowNo, 3).Value = item["SubDomain"]?.ToString();

                            ws.Cell(rowNo, 4).Value = item["BranchName"]?.ToString();

                            ws.Cell(rowNo, 5).Value = item["Segment"]?.ToString();

                            ws.Cell(rowNo, 6).Value = Convert.ToInt32(item["DayCount"]);

                            ws.Cell(rowNo, 7).Value = Convert.ToInt32(item["NightCount"]);

                            ws.Cell(rowNo, 8).Value = Convert.ToInt32(item["GrandTotal"]);

                            ws.Cell(rowNo, 9).Value = Convert.ToInt32(item["TenureLessThan1Year"]);

                            ws.Cell(rowNo, 10).Value = Convert.ToInt32(item["TenureAbove1Year"]);

                            var dataRange = ws.Range(rowNo, 1, rowNo, 10);

                            dataRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                            dataRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                            rowNo++;
                            srNo++;
                        }

                        // FINAL TOTALS

                        finalDay += totalDay;
                        finalNight += totalNight;
                        finalGrand += totalGrand;
                        finalBelow += totalBelow;
                        finalAbove += totalAbove;
                    }

                    // =========================================
                    // GRAND TOTAL ROW
                    // =========================================

                    ws.Cell(rowNo, 1).Value = "TOTAL";

                    ws.Range(rowNo, 1, rowNo, 5).Merge();

                    ws.Cell(rowNo, 6).Value = finalDay;
                    ws.Cell(rowNo, 7).Value = finalNight;
                    ws.Cell(rowNo, 8).Value = finalGrand;
                    ws.Cell(rowNo, 9).Value = finalBelow;
                    ws.Cell(rowNo, 10).Value = finalAbove;

                    var totalRange = ws.Range(rowNo, 1, rowNo, 10);

                    totalRange.Style.Font.Bold = true;
                    totalRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#B3A27A");
                    totalRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    totalRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                    // =========================================
                    // AUTO FIT
                    // =========================================

                    ws.Columns().AdjustToContents();

                    // =========================================
                    // DOWNLOAD
                    // =========================================

                    Response.Clear();
                    Response.Buffer = true;

                    Response.ContentType =
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                    Response.AddHeader(
                        "content-disposition",
                        "attachment;filename=DomainWiseEmployeeReport.xlsx"
                    );

                    using (System.IO.MemoryStream ms = new System.IO.MemoryStream())
                    {
                        wb.SaveAs(ms);

                        ms.WriteTo(Response.OutputStream);
                        Response.Flush();
                        Response.End();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void btn_exportDomainWise_Click(object sender, EventArgs e)
        {
            try
            {
                DataTable dt = dtExport;

                if (dt == null || dt.Rows.Count == 0)
                    return;

                using (XLWorkbook wb = new XLWorkbook())
                {
                    var ws = wb.Worksheets.Add("Domain Report");

                    int rowNo = 1;

                    // ================= TITLE =================
                    ws.Cell(rowNo, 1).Value = "DOMAIN WISE EMPLOYEE REPORT";
                    ws.Range(rowNo, 1, rowNo, 10).Merge();

                    ws.Cell(rowNo, 1).Style.Font.Bold = true;
                    ws.Cell(rowNo, 1).Style.Font.FontSize = 16;
                    ws.Cell(rowNo, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    rowNo += 2;

                    // ================= HEADER =================
                    ws.Cell(rowNo, 1).Value = "Sr No";
                    ws.Cell(rowNo, 2).Value = "Domain"; // BAND LEVEL
                    ws.Cell(rowNo, 3).Value = "SubDomain";
                    ws.Cell(rowNo, 4).Value = "Branch";
                    ws.Cell(rowNo, 5).Value = "Segment";
                    ws.Cell(rowNo, 6).Value = "Day";
                    ws.Cell(rowNo, 7).Value = "Night";
                    ws.Cell(rowNo, 8).Value = "Grand Total";
                    ws.Cell(rowNo, 9).Value = "Tenure < 1 Year";
                    ws.Cell(rowNo, 10).Value = "Tenure > 1 Year";

                    var headerRange = ws.Range(rowNo, 1, rowNo, 10);

                    headerRange.Style.Font.Bold = true;
                    headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#B3A27A");
                    headerRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                    headerRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    headerRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                    rowNo++;

                    // ================= GROUPING =================

                    var domainGroups = dt.AsEnumerable()
                                          .GroupBy(x => x["DomainName"].ToString());

                    int srNo = 1;

                    int finalDay = 0;
                    int finalNight = 0;
                    int finalGrand = 0;
                    int finalBelow = 0;
                    int finalAbove = 0;

                    foreach (var group in domainGroups)
                    {
                        string domain = group.Key;

                        int totalDay = group.Sum(x => Convert.ToInt32(x["DayCount"] ?? 0));
                        int totalNight = group.Sum(x => Convert.ToInt32(x["NightCount"] ?? 0));
                        int totalGrand = group.Sum(x => Convert.ToInt32(x["GrandTotal"] ?? 0));
                        int totalBelow = group.Sum(x => Convert.ToInt32(x["TenureLessThan1Year"] ?? 0));
                        int totalAbove = group.Sum(x => Convert.ToInt32(x["TenureAbove1Year"] ?? 0));

                        // ================= GROUP HEADER =================
                        ws.Cell(rowNo, 1).Value = "DOMAIN : " + domain;

                        ws.Range(rowNo, 1, rowNo, 5).Merge();

                        ws.Cell(rowNo, 6).Value = totalDay;
                        ws.Cell(rowNo, 7).Value = totalNight;
                        ws.Cell(rowNo, 8).Value = totalGrand;
                        ws.Cell(rowNo, 9).Value = totalBelow;
                        ws.Cell(rowNo, 10).Value = totalAbove;

                        var grpRange = ws.Range(rowNo, 1, rowNo, 10);

                        grpRange.Style.Font.Bold = true;
                        grpRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#E5DFD2");
                        grpRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                        grpRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                        rowNo++;

                        // ================= DETAIL ROWS =================

                        int startMerge = rowNo;
                        int endMerge = rowNo + group.Count() - 1;

                        bool first = true;

                        foreach (var item in group)
                        {
                            ws.Cell(rowNo, 1).Value = srNo;

                            // DOMAIN MERGE (BAND COLUMN)
                            if (first)
                            {
                                ws.Cell(startMerge, 2).Value = domain;

                                if (startMerge < endMerge)
                                {
                                    ws.Range(startMerge, 2, endMerge, 2).Merge();
                                }

                                ws.Range(startMerge, 2, endMerge, 2).Style.Alignment.Horizontal =
                                    XLAlignmentHorizontalValues.Center;

                                ws.Range(startMerge, 2, endMerge, 2).Style.Alignment.Vertical =
                                    XLAlignmentVerticalValues.Center;

                                first = false;
                            }

                            ws.Cell(rowNo, 3).Value = item["SubDomain"]?.ToString();
                            ws.Cell(rowNo, 4).Value = item["BranchName"]?.ToString();
                            ws.Cell(rowNo, 5).Value = item["Segment"]?.ToString();

                            ws.Cell(rowNo, 6).Value = Convert.ToInt32(item["DayCount"] ?? 0);
                            ws.Cell(rowNo, 7).Value = Convert.ToInt32(item["NightCount"] ?? 0);
                            ws.Cell(rowNo, 8).Value = Convert.ToInt32(item["GrandTotal"] ?? 0);
                            ws.Cell(rowNo, 9).Value = Convert.ToInt32(item["TenureLessThan1Year"] ?? 0);
                            ws.Cell(rowNo, 10).Value = Convert.ToInt32(item["TenureAbove1Year"] ?? 0);

                            var dataRange = ws.Range(rowNo, 1, rowNo, 10);

                            dataRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                            dataRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                            rowNo++;
                            srNo++;
                        }

                        finalDay += totalDay;
                        finalNight += totalNight;
                        finalGrand += totalGrand;
                        finalBelow += totalBelow;
                        finalAbove += totalAbove;
                    }

                    // ================= GRAND TOTAL =================
                    ws.Cell(rowNo, 1).Value = "TOTAL";

                    ws.Range(rowNo, 1, rowNo, 5).Merge();

                    ws.Cell(rowNo, 6).Value = finalDay;
                    ws.Cell(rowNo, 7).Value = finalNight;
                    ws.Cell(rowNo, 8).Value = finalGrand;
                    ws.Cell(rowNo, 9).Value = finalBelow;
                    ws.Cell(rowNo, 10).Value = finalAbove;

                    var totalRange = ws.Range(rowNo, 1, rowNo, 10);

                    totalRange.Style.Font.Bold = true;
                    totalRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#B3A27A");

                    totalRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    totalRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;

                    ws.Columns().AdjustToContents();

                    // ================= DOWNLOAD =================
                    Response.Clear();
                    Response.Buffer = true;
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;filename=DomainWiseEmployeeReport.xlsx");

                    using (System.IO.MemoryStream ms = new System.IO.MemoryStream())
                    {
                        wb.SaveAs(ms);
                        ms.WriteTo(Response.OutputStream);

                        Response.Flush();
                        Response.End();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}