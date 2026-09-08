using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Accounts
{
    public partial class BranchwiseSalaryAnalysis : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["export"] == "1") ExportWorkbook();
        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetBranches()
        {
            return ToRows(new bllMaster().GetAllBranches());
        }

        [WebMethod]
        public static BranchwiseSalaryAnalysisResult GetAnalysis(int branchId)
        {
            if (branchId <= 0) throw new ArgumentException("Please select a valid branch.");
            return BuildResult(new bllSalary().GetBranchwiseSalaryAnalysis(branchId));
        }

        private void ExportWorkbook()
        {
            int branchId;
            if (!int.TryParse(Request.QueryString["branchId"], out branchId) || branchId <= 0) return;
            DataTable branches = new bllMaster().GetAllBranches();
            DataRow branch = branches.AsEnumerable().FirstOrDefault(r => Convert.ToInt32(r["BranchID"]) == branchId);
            if (branch == null) return;
            DataSet data = new bllSalary().GetBranchwiseSalaryAnalysis(branchId);
            BranchwiseSalaryAnalysisResult result = BuildResult(data);
            using (XLWorkbook workbook = new XLWorkbook())
            {
                AddPivotSheet(workbook, "Summary", result.SummaryTable, "Domain");
                AddPivotSheet(workbook, "Summary - Underwriting", result.CreditSummaryTable, "Subdomain");
                AddDetailSheet(workbook, "Non DD", result.NonDDTable);
                AddDetailSheet(workbook, "DD", result.DDTable);
                using (MemoryStream stream = new MemoryStream())
                {
                    workbook.SaveAs(stream); Response.Clear(); Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    string name = Convert.ToString(branch["BranchName"]) + " DD Non-DD Employee Salary Analysis.xlsx";
                    Response.AddHeader("Content-Disposition", "attachment; filename=\"" + name.Replace("\"", "") + "\""); Response.BinaryWrite(stream.ToArray()); Response.End();
                }
            }
        }

        private static BranchwiseSalaryAnalysisResult BuildResult(DataSet data)
        {
            DataTable summary = TableAt(data, 0), employees = TableAt(data, 1), credit = TableAt(data, 2);
            DataTable dd = employees.Clone(), nonDD = employees.Clone();
            foreach (DataRow row in employees.Rows)
            {
                string domain = Convert.ToString(row["Domain"]);
                (domain.Equals("Underwriting", StringComparison.OrdinalIgnoreCase) ? dd : nonDD).ImportRow(row);
            }
            if (dd.Columns.Contains("Code")) dd.DefaultView.Sort = "Code";
            if (nonDD.Columns.Contains("Code")) nonDD.DefaultView.Sort = "Code";
            dd = dd.DefaultView.ToTable(); nonDD = nonDD.DefaultView.ToTable();
            return new BranchwiseSalaryAnalysisResult { Summary=ToRows(summary), CreditSummary=ToRows(credit), DD=ToRows(dd), NonDD=ToRows(nonDD), SummaryTable=summary, CreditSummaryTable=credit, DDTable=dd, NonDDTable=nonDD };
        }

        private static DataTable TableAt(DataSet data, int index) { return data != null && data.Tables.Count > index ? data.Tables[index] : new DataTable(); }
        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (DataRow dr in table.Rows) { Dictionary<string, object> row = new Dictionary<string, object>(); foreach (DataColumn col in table.Columns) { object value = dr[col]; row[col.ColumnName] = value == DBNull.Value ? null : (value is DateTime ? ((DateTime)value).ToString("dd-MMM-yyyy") : value); } rows.Add(row); } return rows;
        }
        private static void AddDetailSheet(XLWorkbook wb, string name, DataTable table)
        {
            DataTable export = table.Copy(); export.Columns.Add("Sr. No.", typeof(int)).SetOrdinal(0); for(int i=0;i<export.Rows.Count;i++) export.Rows[i][0]=i+1;
            IXLWorksheet ws=wb.Worksheets.Add(name); ws.Cell(1,1).InsertTable(export); StyleSheet(ws);
        }
        private static void AddPivotSheet(XLWorkbook wb, string name, DataTable source, string rowField)
        {
            IXLWorksheet ws=wb.Worksheets.Add(name); if(!source.Columns.Contains(rowField)||!source.Columns.Contains("SalaryRange")||!source.Columns.Contains("EmpCount")){ws.Cell(1,1).Value="No data available";return;}
            if (source.Rows.Count == 0) { ws.Cell(1, 1).Value = "No data available"; return; }
            List<string> ranges=source.AsEnumerable().Select(r=>Convert.ToString(r["SalaryRange"])).Distinct().ToList(); List<string> names=source.AsEnumerable().Select(r=>Convert.ToString(r[rowField])).Distinct().ToList();
            ws.Cell(1,1).Value=rowField; for(int c=0;c<ranges.Count;c++)ws.Cell(1,c+2).Value=ranges[c]; ws.Cell(1,ranges.Count+2).Value="Grand Total";
            for(int r=0;r<names.Count;r++){ws.Cell(r+2,1).Value=names[r];decimal rt=0;for(int c=0;c<ranges.Count;c++){decimal v=source.AsEnumerable().Where(x=>Convert.ToString(x[rowField])==names[r]&&Convert.ToString(x["SalaryRange"])==ranges[c]).Sum(x=>Convert.ToDecimal(x["EmpCount"]));ws.Cell(r+2,c+2).Value=v;rt+=v;}ws.Cell(r+2,ranges.Count+2).Value=rt;}
            int totalRow=names.Count+2;ws.Cell(totalRow,1).Value="Grand Total";for(int c=0;c<ranges.Count;c++)ws.Cell(totalRow,c+2).FormulaA1="SUM("+ws.Cell(2,c+2).Address+":"+ws.Cell(totalRow-1,c+2).Address+")";ws.Cell(totalRow,ranges.Count+2).FormulaA1="SUM("+ws.Cell(2,ranges.Count+2).Address+":"+ws.Cell(totalRow-1,ranges.Count+2).Address+")";StyleSheet(ws);
        }
        private static void StyleSheet(IXLWorksheet ws) { IXLRange used=ws.RangeUsed(); if(used==null)return;used.Style.Border.OutsideBorder=XLBorderStyleValues.Thin;used.Style.Border.InsideBorder=XLBorderStyleValues.Thin;ws.Row(1).Style.Fill.BackgroundColor=XLColor.FromHtml("#5A78A8");ws.Row(1).Style.Font.FontColor=XLColor.White;ws.Row(1).Style.Font.Bold=true;ws.Columns().AdjustToContents(1,40);ws.SheetView.FreezeRows(1); }
    }

    public class BranchwiseSalaryAnalysisResult
    {
        public List<Dictionary<string, object>> Summary { get; set; }
        public List<Dictionary<string, object>> CreditSummary { get; set; }
        public List<Dictionary<string, object>> NonDD { get; set; }
        public List<Dictionary<string, object>> DD { get; set; }
        internal DataTable SummaryTable { get; set; }
        internal DataTable CreditSummaryTable { get; set; }
        internal DataTable NonDDTable { get; set; }
        internal DataTable DDTable { get; set; }
    }
}
