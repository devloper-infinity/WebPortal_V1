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
using WebPortal.App_Code.Class;
using Excel = Microsoft.Office.Interop.Excel;

namespace WebPortal.Admin
{
    public partial class SkipLevelMeeting : System.Web.UI.Page
    {
        string FileName = "";
        string Quarter = "";
        string Year = "";
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetUserName(int EmployeeID)
        {
            DataTable dt1 = new bllLogin().GetUserInformation(EmployeeID);
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
        public static string GetAllEmployees()
        {
            DataTable dt1 = new bllMaster().GetAllUsers();
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
        public static string GetLastFourGrading(string Quarter, int Year, string Code)
        {
            DataTable dt1 = new bllMaster().GetLastFourYearGrading(Quarter, Year, Code);
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
        public static string GetPreviousSkipRemarks(int EmployeeID)
        {
            DataTable dt1 = new bllMaster().GetAllPreviousFeedback(EmployeeID);
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
        public static int InsertSkipLevelMeeting(int EmployeeID, string Date, string Remark, string Quarter, int Year, string Status)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("EmployeeID", EmployeeID);
            htParam.Add("Date", Date);
            htParam.Add("Remark", Remark);
            htParam.Add("Quarter", Quarter);
            htParam.Add("Year", Convert.ToString(Year));
            htParam.Add("Status", Status);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertSkipLevelMeeting(htParam);
            if (returnvalue > 0)
            {

            }
            return returnvalue;
        }

        [WebMethod]
        public static int InsertSkipLevelDetails(int MeetingId, int EmployeeID, string[] details)
        {
            int returnvalue = 0;
            foreach (string detail in details)
            {
                string[] det = detail.Split('~');
                string Type = det[0].Replace(" ", "");
                string Description = det[1].Replace(" ", "");
                Hashtable htParam = new Hashtable();
                htParam.Add("EmployeeID", EmployeeID);
                htParam.Add("MeetingId", MeetingId);
                htParam.Add("Type", Type);
                htParam.Add("Description", Description);
                htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                returnvalue = new bllMaster().InsertSkipLevelMeetingAction(htParam);
            }

            return returnvalue;
        }

        [WebMethod]
        public static string GetSummaryReport(string Quarter, string Year)
        {
            DataTable dt1 = new bllMaster().getSummaryReport(Year, Quarter);
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

        protected void btnExporttoExcel_Click(object sender, EventArgs e)
        {
            FileName = Server.MapPath(@"~\ReportDocument\Skip_Level_Meeting_Report_" + Convert.ToString(Quarter) + "-" + Convert.ToString(Year) + DateTime.Now.ToString("hhmmss") + ".xlsx");
            FormatExcel(FileName);
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
                    worksheet = workbook.Worksheet(7);
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
            Quarter = Convert.ToString(Request.Form["skip_quarterreport"]);
            Year = Convert.ToString(Request.Form["skip_yearreport"]);
            Workbook book = new Workbook();
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";
            int rowcount = 0;
            int colcount = 0;

            #region Overall Summary
            Worksheet sheet = book.Worksheets.Add("Branch wise Summary");
            DataTable dtSummary = new bllMaster().getSummaryReport(Year, Quarter);
            if (dtSummary != null)
            {
                if (dtSummary.Rows.Count > 0)
                {
                    dtSummary.Columns.Remove("NeedToContactAgain");
                    sheet.InsertDataTable(dtSummary, true, 1, 1);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;
                    sheet.Range["A1"].Value = "Branch";
                    sheet.Range["B1"].Value = "Total";
                    sheet.Range["C1"].Value = "Absconding";
                    sheet.Range["D1"].Value = "On Floor";
                    sheet.Range["E1"].Value = "NA";
                    sheet.Range["F1"].Value = "Applicable To Contact";
                    sheet.Range["G1"].Value = "Discussion Completed";
                    sheet.Range["H1"].Value = "Actual Contacted";
                    //sheet.Range["I1"].Value = "Need To Contact Again";
                    sheet.Range["I1"].Value = "Pending";
                    string ColName = GetColumnName(colcount - 1);
                    CellRange range = sheet.Range["A1:" + ColName + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + ColName + "" + rowcount];
                    AllBorder(range);
                    ContentCenter(range);

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }
            #endregion

            #region PM Wise Summary
            sheet = book.Worksheets.Add("PM wise summary");
            DataTable dtPMSummary = new bllMaster().GetPMSummary(Year, Quarter);
            if (dtPMSummary != null)
            {
                if (dtPMSummary.Rows.Count > 0)
                {
                    dtPMSummary.Columns.Remove("NeedToContactAgain");
                    sheet.InsertDataTable(dtPMSummary, true, 1, 1);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    sheet.Range["A1"].Value = "Branch";
                    sheet.Range["B1"].Value = "Reporting Manager";
                    sheet.Range["C1"].Value = "Total";
                    sheet.Range["D1"].Value = "Actual Contacted";
                    sheet.Range["E1"].Value = "Discussion Completed";
                    //sheet.Range["F1"].Value = "Need To Contact Again";
                    sheet.Range["F1"].Value = "Absconding";
                    sheet.Range["G1"].Value = "Pending";
                    string ColName = GetColumnName(colcount - 1);

                    CellRange range = sheet.Range["A1:" + ColName + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + ColName + "" + rowcount];
                    AllBorder(range);
                    ContentCenter(range);

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }
            #endregion

            #region Domain Head Wise Summary
            sheet = book.Worksheets.Add("Domain Head wise summary");
            DataTable dtDMSummary = new bllMaster().GetDMSummary(Year, Quarter);
            if (dtDMSummary != null)
            {
                if (dtDMSummary.Rows.Count > 0)
                {

                    dtDMSummary.Columns.Remove("NeedToContactAgain");
                    sheet.InsertDataTable(dtDMSummary, true, 1, 1);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;

                    sheet.Range["A1"].Value = "Branch";
                    sheet.Range["B1"].Value = "Reporting Manager";
                    sheet.Range["C1"].Value = "Total";
                    sheet.Range["D1"].Value = "Actual Contacted";
                    sheet.Range["E1"].Value = "Discussion Completed";
                    //sheet.Range["F1"].Value = "Need To Contact Again";
                    sheet.Range["F1"].Value = "Absconding";
                    sheet.Range["G1"].Value = "Pending";
                    string ColName = GetColumnName(colcount - 1);

                    CellRange range = sheet.Range["A1:" + ColName + "1"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + ColName + "" + rowcount];
                    AllBorder(range);
                    ContentCenter(range);

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }
            #endregion

            #region All Employee Details
            sheet = book.Worksheets.Add("All Employee Details");
            DataTable dtPMDetails = new bllMaster().GetPMDetails(Year, Quarter);
            if (dtPMDetails != null)
            {
                if (dtPMDetails.Rows.Count > 0)
                {
                    dtPMDetails.Columns["Code"].SetOrdinal(0);
                    dtPMDetails.Columns["EmpName"].SetOrdinal(1);
                    dtPMDetails.Columns["DomainName"].SetOrdinal(2);
                    dtPMDetails.Columns["BranchName"].SetOrdinal(3);
                    dtPMDetails.Columns["DepartmentName"].SetOrdinal(4);
                    dtPMDetails.Columns["DesignationName"].SetOrdinal(5);
                    dtPMDetails.Columns["ReportingManager"].SetOrdinal(6);
                    dtPMDetails.Columns["DomainHead"].SetOrdinal(7);
                    dtPMDetails.Columns["CellNo"].SetOrdinal(8);
                    dtPMDetails.Columns["DailyTaskProductivity"].SetOrdinal(9);
                    dtPMDetails.Columns["Category"].SetOrdinal(10);
                    dtPMDetails.Columns["CurrentStatus"].SetOrdinal(11);
                    dtPMDetails.Columns["PMRemark"].SetOrdinal(12);
                    dtPMDetails.Columns["PGrade2"].SetOrdinal(13);
                    dtPMDetails.Columns["QGrade2"].SetOrdinal(14);
                    dtPMDetails.Columns["AGrade2"].SetOrdinal(15);
                    dtPMDetails.Columns["PGrade3"].SetOrdinal(16);
                    dtPMDetails.Columns["QGrade3"].SetOrdinal(17);
                    dtPMDetails.Columns["AGrade3"].SetOrdinal(18);
                    dtPMDetails.AcceptChanges();
                    dtPMDetails.Columns.Remove("EmployeeID");

                    sheet.InsertDataTable(dtPMDetails, true, 2, 1);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;
                    sheet.Range["A1:L1"].Value = "Basic Information";
                    sheet.Range["A1:L1"].Merge();
                    if (Quarter == "January ~ March")
                    {
                        sheet.Range["M1:O1"].Value = "October ~ December - (" + (Convert.ToInt32(Year) - 1).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "January ~ March - (" + (Year).ToString() + ")";
                    }
                    else if (Quarter == "April ~ June")
                    {
                        sheet.Range["M1:O1"].Value = "January ~ March - (" + (Year).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "April ~ June - (" + (Year).ToString() + ")";
                    }
                    else if (Quarter == "July ~ September")
                    {
                        sheet.Range["M1:O1"].Value = "April ~ June - (" + (Year).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "July ~ September - (" + (Year).ToString() + ")";
                    }
                    else if (Quarter == "October ~ December")
                    {
                        sheet.Range["M1:O1"].Value = "July ~ September - (" + (Year).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "October ~ December - (" + (Year).ToString() + ")";
                    }

                    sheet.Range["M1:O1"].Merge();
                    sheet.Range["P1:R1"].Merge();

                    sheet.Range["A2"].Value = "Code";
                    sheet.Range["B2"].Value = "Name";
                    sheet.Range["C2"].Value = "Domain";
                    sheet.Range["D2"].Value = "Branch";
                    sheet.Range["E2"].Value = "Department";
                    sheet.Range["F2"].Value = "Designation";
                    sheet.Range["G2"].Value = "Reporting Manager";
                    sheet.Range["H2"].Value = "Domain Head";
                    sheet.Range["I2"].Value = "Contact #";
                    sheet.Range["J2"].Value = "Daily Task/ Productivity?";
                    sheet.Range["K2"].Value = "Category";
                    sheet.Range["L2"].Value = "Current Status";
                    sheet.Range["M2"].Value = "PM/ System Remark (Step 1)";
                    sheet.Range["N2"].Value = "Production Grade";
                    sheet.Range["O2"].Value = "Quality Grade";
                    sheet.Range["P2"].Value = "Attendance Grade";
                    sheet.Range["Q2"].Value = "Production Grade";
                    sheet.Range["R2"].Value = "Quality Grade";
                    sheet.Range["S2"].Value = "Attendance Grade";
                    string ColName = GetColumnName(colcount - 1);


                    CellRange range = sheet.Range["A1:" + ColName + "2"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + ColName + "" + rowcount];
                    AllBorder(range);
                    ContentCenter(range);

                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }
            #endregion

            #region PM wise Details
            sheet = book.Worksheets.Add("PM wise Details");
            //DataTable dtPMDetails = new bllMaster().GetPMDetails(Year, Quarter);
            if (dtPMDetails != null)
            {
                if (dtPMDetails.Rows.Count > 0)
                {
                    dtPMDetails.Columns["ReportingManager"].SetOrdinal(0);
                    dtPMDetails.Columns["Code"].SetOrdinal(1);
                    dtPMDetails.Columns["EmpName"].SetOrdinal(2);
                    dtPMDetails.Columns["DomainName"].SetOrdinal(3);
                    dtPMDetails.Columns["BranchName"].SetOrdinal(4);
                    dtPMDetails.Columns["DepartmentName"].SetOrdinal(5);
                    dtPMDetails.Columns["DesignationName"].SetOrdinal(6);
                    dtPMDetails.Columns["DomainHead"].SetOrdinal(7);
                    dtPMDetails.Columns["CellNo"].SetOrdinal(8);
                    dtPMDetails.Columns["DailyTaskProductivity"].SetOrdinal(9);
                    dtPMDetails.Columns["Category"].SetOrdinal(10);
                    dtPMDetails.Columns["CurrentStatus"].SetOrdinal(11);
                    dtPMDetails.Columns["PMRemark"].SetOrdinal(12);
                    dtPMDetails.Columns["PGrade2"].SetOrdinal(13);
                    dtPMDetails.Columns["QGrade2"].SetOrdinal(14);
                    dtPMDetails.Columns["AGrade2"].SetOrdinal(15);
                    dtPMDetails.Columns["PGrade3"].SetOrdinal(16);
                    dtPMDetails.Columns["QGrade3"].SetOrdinal(17);
                    dtPMDetails.Columns["AGrade3"].SetOrdinal(18);
                    dtPMDetails.AcceptChanges();

                    sheet.InsertDataTable(dtPMDetails, true, 2, 1);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;
                    sheet.Range["A1:L1"].Value = "Basic Information";
                    sheet.Range["A1:L1"].Merge();
                    if (Quarter == "January ~ March")
                    {
                        sheet.Range["M1:O1"].Value = "October ~ December - (" + (Convert.ToInt32(Year) - 1).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "January ~ March - (" + (Year).ToString() + ")";
                    }
                    else if (Quarter == "April ~ June")
                    {
                        sheet.Range["M1:O1"].Value = "January ~ March - (" + (Year).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "April ~ June - (" + (Year).ToString() + ")";
                    }
                    else if (Quarter == "July ~ September")
                    {
                        sheet.Range["M1:O1"].Value = "April ~ June - (" + (Year).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "July ~ September - (" + (Year).ToString() + ")";
                    }
                    else if (Quarter == "October ~ December")
                    {
                        sheet.Range["M1:O1"].Value = "July ~ September - (" + (Year).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "October ~ December - (" + (Year).ToString() + ")";
                    }

                    sheet.Range["M1:O1"].Merge();
                    sheet.Range["P1:R1"].Merge();

                    sheet.Range["A2"].Value = "Reporting Manager";
                    sheet.Range["B2"].Value = "Code";
                    sheet.Range["C2"].Value = "Name";
                    sheet.Range["D2"].Value = "Domain";
                    sheet.Range["E2"].Value = "Branch";
                    sheet.Range["F2"].Value = "Department";
                    sheet.Range["G2"].Value = "Designation";
                    sheet.Range["H2"].Value = "Domain Head";
                    sheet.Range["I2"].Value = "Contact #";
                    sheet.Range["J2"].Value = "Daily Task/ Productivity?";
                    sheet.Range["K2"].Value = "Category";
                    sheet.Range["L2"].Value = "Current Status";
                    sheet.Range["M2"].Value = "PM/ System Remark (Step 1)";
                    sheet.Range["N2"].Value = "Production Grade";
                    sheet.Range["O2"].Value = "Quality Grade";
                    sheet.Range["P2"].Value = "Attendance Grade";
                    sheet.Range["Q2"].Value = "Production Grade";
                    sheet.Range["R2"].Value = "Quality Grade";
                    sheet.Range["S2"].Value = "Attendance Grade";
                    string ColName = GetColumnName(colcount - 1);

                    //int start = 3;

                    //for (int i = 3; i < rowcount; i++)
                    //{
                    //    if (sheet.Range["S" + (i + 1)].Value == "")
                    //    {
                    //        sheet.GroupByRows(start, i, false);
                    //        break;
                    //    }
                    //    if (sheet.Range["S" + (i)].Value != sheet.Range["S" + (i + 1)].Value)
                    //    {
                    //        sheet.GroupByRows(start, i, false);
                    //        start = i + 1;
                    //    }
                    //}

                    CellRange range = sheet.Range["A1:" + ColName + "2"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + ColName + "" + rowcount];
                    AllBorder(range);
                    ContentCenter(range);
                    sheet.Subtotal(sheet.Range["A3:" + ColName + "" + rowcount], 0, new int[] { 1 }, SubtotalTypes.Count, true, false, true);



                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
            }
            #endregion

            #region Domain Head wise Details
            sheet = book.Worksheets.Add("Domain Head wise Details");
            //DataTable dtPMDetails = new bllMaster().GetPMDetails(Year, Quarter);
            if (dtPMDetails != null)
            {
                if (dtPMDetails.Rows.Count > 0)
                {
                    dtPMDetails.Columns["DomainHead"].SetOrdinal(0);
                    dtPMDetails.Columns["Code"].SetOrdinal(1);
                    dtPMDetails.Columns["EmpName"].SetOrdinal(2);
                    dtPMDetails.Columns["DomainName"].SetOrdinal(3);
                    dtPMDetails.Columns["BranchName"].SetOrdinal(4);
                    dtPMDetails.Columns["DepartmentName"].SetOrdinal(5);
                    dtPMDetails.Columns["DesignationName"].SetOrdinal(6);
                    dtPMDetails.Columns["ReportingManager"].SetOrdinal(7);
                    dtPMDetails.Columns["CellNo"].SetOrdinal(8);
                    dtPMDetails.Columns["DailyTaskProductivity"].SetOrdinal(9);
                    dtPMDetails.Columns["Category"].SetOrdinal(10);
                    dtPMDetails.Columns["CurrentStatus"].SetOrdinal(11);
                    dtPMDetails.Columns["PMRemark"].SetOrdinal(12);
                    dtPMDetails.Columns["PGrade2"].SetOrdinal(13);
                    dtPMDetails.Columns["QGrade2"].SetOrdinal(14);
                    dtPMDetails.Columns["AGrade2"].SetOrdinal(15);
                    dtPMDetails.Columns["PGrade3"].SetOrdinal(16);
                    dtPMDetails.Columns["QGrade3"].SetOrdinal(17);
                    dtPMDetails.Columns["AGrade3"].SetOrdinal(18);
                    dtPMDetails.AcceptChanges();

                    sheet.InsertDataTable(dtPMDetails, true, 2, 1);
                    rowcount = sheet.LastRow;
                    colcount = sheet.LastColumn;
                    sheet.Range["A1:L1"].Value = "Basic Information";
                    sheet.Range["A1:L1"].Merge();
                    if (Quarter == "January ~ March")
                    {
                        sheet.Range["M1:O1"].Value = "October ~ December - (" + (Convert.ToInt32(Year) - 1).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "January ~ March - (" + (Year).ToString() + ")";
                    }
                    else if (Quarter == "April ~ June")
                    {
                        sheet.Range["M1:O1"].Value = "January ~ March - (" + (Year).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "April ~ June - (" + (Year).ToString() + ")";
                    }
                    else if (Quarter == "July ~ September")
                    {
                        sheet.Range["M1:O1"].Value = "April ~ June - (" + (Year).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "July ~ September - (" + (Year).ToString() + ")";
                    }
                    else if (Quarter == "October ~ December")
                    {
                        sheet.Range["M1:O1"].Value = "July ~ September - (" + (Year).ToString() + ")";
                        sheet.Range["P1:R1"].Value = "October ~ December - (" + (Year).ToString() + ")";
                    }

                    sheet.Range["M1:O1"].Merge();
                    sheet.Range["P1:R1"].Merge();

                    sheet.Range["A2"].Value = "Domain Head";
                    sheet.Range["B2"].Value = "Code";
                    sheet.Range["C2"].Value = "Name";
                    sheet.Range["D2"].Value = "Domain";
                    sheet.Range["E2"].Value = "Branch";
                    sheet.Range["F2"].Value = "Department";
                    sheet.Range["G2"].Value = "Designation";
                    sheet.Range["H2"].Value = "Reporting Manager";
                    sheet.Range["I2"].Value = "Contact #";
                    sheet.Range["J2"].Value = "Daily Task/ Productivity?";
                    sheet.Range["K2"].Value = "Category";
                    sheet.Range["L2"].Value = "Current Status";
                    sheet.Range["M2"].Value = "PM/ System Remark (Step 1)";
                    sheet.Range["N2"].Value = "Production Grade";
                    sheet.Range["O2"].Value = "Quality Grade";
                    sheet.Range["P2"].Value = "Attendance Grade";
                    sheet.Range["Q2"].Value = "Production Grade";
                    sheet.Range["R2"].Value = "Quality Grade";
                    sheet.Range["S2"].Value = "Attendance Grade";
                    string ColName = GetColumnName(colcount - 1);

                    //int start = 3;

                    //for (int i = 3; i < rowcount; i++)
                    //{
                    //    if (sheet.Range["S" + (i + 1)].Value == "")
                    //    {
                    //        sheet.GroupByRows(start, i, false);
                    //        break;
                    //    }
                    //    if (sheet.Range["S" + (i)].Value != sheet.Range["S" + (i + 1)].Value)
                    //    {
                    //        sheet.GroupByRows(start, i, false);
                    //        start = i + 1;
                    //    }
                    //}

                    CellRange range = sheet.Range["A1:" + ColName + "2"];
                    HeaderFormat(range);
                    range = sheet.Range["A1:" + ColName + "" + rowcount];
                    AllBorder(range);
                    ContentCenter(range);
                    sheet.Subtotal(sheet.Range["A3:" + ColName + "" + rowcount], 0, new int[] { 1 }, SubtotalTypes.Count, true, false, true);



                    sheet.AllocatedRange.Style.Font.FontName = "Aptos Narrow";
                    sheet.AllocatedRange.Style.Font.Size = 10;

                    sheet.AllocatedRange.AutoFitColumns();
                    sheet.AllocatedRange.AutoFitRows();
                }
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
    }
}