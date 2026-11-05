using ClosedXML.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using Spire.Xls;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Globalization;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Accounts
{
    public partial class PrepareCheques : System.Web.UI.Page
    {
        static string FileName;
        public static string ReportFileName = "";
        public static string ReportFilePath = "";
        static Spire.Xls.Workbook book = new Spire.Xls.Workbook();
        static Spire.Xls.Worksheet sheet;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Regular Salary
        [WebMethod]
        public static string getRegularSalary(string Month, string Year)
        {
            DataTable dt1 = new bllSalary().GetRegularSalary(Month, Convert.ToInt32(Year));
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
        public static int getRegularSalaryExport(string Month, string Year, string BankName, string ChequeDate)
        {
            int returnvalue = 1;
            DataTable dt = new bllSalary().GenerateRegularBankFormat(Month, Year, BankName);
            if (dt != null)
            {
                DateTime selectedChequeDate;
                if (!DateTime.TryParseExact(ChequeDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out selectedChequeDate))
                    throw new ArgumentException("Invalid cheque date.");

                DataColumn chequeDateColumn = dt.Columns.Cast<DataColumn>().FirstOrDefault(column =>
                    column.ColumnName.Equals("AddedDate", StringComparison.OrdinalIgnoreCase) ||
                    column.ColumnName.Equals("ChequeDate", StringComparison.OrdinalIgnoreCase) ||
                    column.ColumnName.Equals("ReleaseDate", StringComparison.OrdinalIgnoreCase));

                DataTable chequeMasterEmployees = new bllSalary().GetChequeMasterEmployeeCodes(Month, Year, selectedChequeDate);
                DataColumn bankEmployeeColumn = FindColumn(dt, "Code", "Employee Code", "EmployeeCode");

                if (bankEmployeeColumn == null)
                    throw new InvalidOperationException("The bank file data does not contain employee Code.");

                HashSet<string> selectedEmployees = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                if (chequeMasterEmployees != null)
                {
                    foreach (DataRow chequeRow in chequeMasterEmployees.Rows)
                    {
                        if (chequeRow["Code"] != DBNull.Value)
                            selectedEmployees.Add(Convert.ToString(chequeRow["Code"]).Trim());
                    }
                }

                DataTable filteredData = dt.Clone();
                foreach (DataRow bankRow in dt.Rows)
                {
                    if (selectedEmployees.Contains(Convert.ToString(bankRow[bankEmployeeColumn]).Trim()))
                        filteredData.ImportRow(bankRow);
                }
                dt = filteredData;

                if (dt.Rows.Count == 0)
                    throw new InvalidOperationException("No salary records were found for the selected cheque date.");

                try
                {
                    if (dt.Columns.Contains("Hold"))
                        dt.Columns.Remove("Hold");
                    if (dt.Columns.Contains("Department"))
                        dt.Columns.Remove("Department");
                    if (dt.Columns.Contains("Company"))
                        dt.Columns.Remove("Company");
                    if (dt.Columns.Contains("WorkingBranch"))
                        dt.Columns.Remove("WorkingBranch");
                    if (dt.Columns.Contains("BankName"))
                        dt.Columns.Remove("BankName");
                    if (dt.Columns.Contains("Code"))
                        dt.Columns.Remove("Code");
                    if (dt.Columns.Contains("Employee Code"))
                        dt.Columns.Remove("Employee Code");
                    if (chequeDateColumn != null && dt.Columns.Contains(chequeDateColumn.ColumnName))
                        dt.Columns.Remove(chequeDateColumn.ColumnName);
                }
                catch { }
                FileName = HttpContext.Current.Server.MapPath(@"~\ReportDocument\RegularSalary_BankFile_" + Month + "-" + Year + "-" + selectedChequeDate.ToString("dd-MMM-yyyy") + ".xlsx");
                book = new Spire.Xls.Workbook();
                book.DefaultFontSize = 9;
                book.DefaultFontName = "biome";

                int rowcount = 0;
                int colcount = 0;

                #region summary
                sheet = book.Worksheets.Add("Summary");
                sheet.InsertDataTable(dt, true, 1, 1);
                sheet.Range.NumberFormat = "@";
                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();

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
            return returnvalue;
        }

        private static DataColumn FindColumn(DataTable table, params string[] columnNames)
        {
            if (table == null)
                return null;

            return table.Columns.Cast<DataColumn>().FirstOrDefault(column =>
                columnNames.Any(columnName => column.ColumnName.Equals(columnName, StringComparison.OrdinalIgnoreCase)));
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
                    worksheet = workbook.Worksheet(2);
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

        #endregion

        #region Regular Salary
        [WebMethod]
        public static string GetAllHoldEmployees(string Month, string Year)
        {
            DataTable dt1 = new bllSalary().GetAllHoldEmployees(Month, Year);
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
        public static int InsertChequeDetails(string Params)
        {
            int returnvalue = 0;
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            List<HoldChequeDetail> chequeDetails = serializer.Deserialize<List<HoldChequeDetail>>(Params);

            foreach (HoldChequeDetail detail in chequeDetails)
            {
                returnvalue = new bllSalary().InsertChequeDetails(
                    detail.ChequeNo,
                    Convert.ToDecimal(detail.Salary),
                    detail.Month,
                    detail.Year,
                    detail.EmployeeID,
                    int.Parse(HttpContext.Current.User.Identity.Name.ToString()),
                    "23.111.175.186");
            }
            return returnvalue;
        }

        public class HoldChequeDetail
        {
            public int EmployeeID { get; set; }
            public string Salary { get; set; }
            public string ChequeNo { get; set; }
            public string Month { get; set; }
            public string Year { get; set; }
        }
        #endregion

        #region Regular Salary
        [WebMethod]
        public static string GetAllOtherThanSalaryEmployees(string Month, string Year, string Type)
        {
            DataTable dt1 = new bllSalary().GetOtherThanSalaryRecords(Month, Year, Type);
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
        public static int InsertChequeDetails_OtherThanSalary(string Params)
        {
            int returnvalue = 0;
            string[] OuterParams = Params.Split(',');
            foreach (string par in OuterParams)
            {
                if (par != "")
                {
                    string[] innerParams = par.Split('|');
                    int EmployeeID = Convert.ToInt32(innerParams[0]);
                    string Salary = Convert.ToString(innerParams[1]);
                    string Chequeno = Convert.ToString(innerParams[2]);
                    string Month = Convert.ToString(innerParams[3]);
                    string Year = Convert.ToString(innerParams[4]);
                    string Type = Convert.ToString(innerParams[5]);
                    returnvalue = new bllSalary().InsertChequeDetails_Other(Chequeno, Convert.ToDecimal(Salary), Month, Year, EmployeeID, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), "23.111.175.186", Type);
                }
            }
            return returnvalue;
        }

        [WebMethod]
        public static int getOtherSalaryExport(string Month, string Year, string BankName, string Type)
        {
            int returnvalue = 1;
            DataTable dt = new bllSalary().GenerateOtherSalaryBankFormat(Month, Year, BankName, Type);
            if (dt != null)
            {
                try
                {
                    if (dt.Columns.Contains("Hold"))
                        dt.Columns.Remove("Hold");
                    if (dt.Columns.Contains("Department"))
                        dt.Columns.Remove("Department");
                    if (dt.Columns.Contains("Company"))
                        dt.Columns.Remove("Company");
                    if (dt.Columns.Contains("WorkingBranch"))
                        dt.Columns.Remove("WorkingBranch");
                    if (dt.Columns.Contains("BankName"))
                        dt.Columns.Remove("BankName");
                    if (dt.Columns.Contains("Code"))
                        dt.Columns.Remove("Code");
                    if (dt.Columns.Contains("Employee Code"))
                        dt.Columns.Remove("Employee Code");
                }
                catch { }
                FileName = HttpContext.Current.Server.MapPath(@"~\ReportDocument\" + Type + "_BankFile_" + Month + "-" + Year + ".xlsx");
                book = new Spire.Xls.Workbook();
                book.DefaultFontSize = 9;
                book.DefaultFontName = "biome";

                int rowcount = 0;
                int colcount = 0;

                #region summary
                sheet = book.Worksheets.Add("Summary");
                sheet.InsertDataTable(dt, true, 1, 1);
                sheet.Range.NumberFormat = "@";
                sheet.AllocatedRange.AutoFitColumns();
                sheet.AllocatedRange.AutoFitRows();

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
            return returnvalue;
        }

        protected void btn2_Click(object sender, EventArgs e)
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
                    worksheet = workbook.Worksheet(2);
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
        #endregion

    }
}
