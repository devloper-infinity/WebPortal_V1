using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Xml.Linq;
using WebPortal.App_Code.DAL;

namespace WebPortal.Accounts
{
    public partial class DiwaliExpenses : Page
    {
        private const int MaxUploadBytes = 10 * 1024 * 1024;
        private bool isImportRequest;
        private bool isExportRequest;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["export"] == "1")
            {
                isExportRequest = true;
                ExportWorkbook();
                return;
            }
            if (!string.Equals(Request.QueryString["action"], "import", StringComparison.OrdinalIgnoreCase)) return;
            isImportRequest = true;
            ImportWorkbook();
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (isImportRequest || isExportRequest) return;
            base.Render(writer);
        }

        private void ExportWorkbook()
        {
            int year;
            if (!int.TryParse(Request.QueryString["year"], out year) || year < 2000 || year > 2100)
            {
                Response.StatusCode = 400;
                Response.Write("A valid expense year is required.");
                return;
            }

            DataSet data = ExecuteGet(year);
            DataTable summary = TableAt(data, 1), items = TableAt(data, 2);
            using (XLWorkbook workbook = new XLWorkbook())
            {
                AddExportSheet(workbook, "Summary", summary, new[] { "SerialNo", "Particular", "Amount", "Remark" }, new[] { "Sr. No.", "Particular", "Amount", "Remark" });
                AddCategorySheet(workbook, items, "General Expense", "General Expenses", false);
                AddCategorySheet(workbook, items, "Food Arrangement", "Food", false);
                AddCategorySheet(workbook, items, "Sweet Boxes", "Sweets", false);
                AddCategorySheet(workbook, items, "Silver Coins", "Silver Coins", false);
                AddCategorySheet(workbook, items, "Senior Gifts", "Senior Gifts", false);
                AddCategorySheet(workbook, items, "Distribution Summary", "Distribution Summary", false);
                AddCategorySheet(workbook, items, "Employee Distribution", "Employee Distribution", true);

                using (MemoryStream stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("Content-Disposition", "attachment; filename=\"Diwali Expenses " + year + ".xlsx\"");
                    Response.BinaryWrite(stream.ToArray());
                }
            }
            Context.ApplicationInstance.CompleteRequest();
        }

        private static void AddCategorySheet(XLWorkbook workbook, DataTable source, string category, string sheetName, bool employeeSheet)
        {
            DataTable filtered = source.Clone();
            foreach (DataRow row in source.Rows) if (string.Equals(Convert.ToString(row["Category"]), category, StringComparison.OrdinalIgnoreCase)) filtered.ImportRow(row);
            if (employeeSheet)
                AddExportSheet(workbook, sheetName, filtered,
                    new[] { "SerialNo", "EmployeeCode", "EmployeeName", "Branch", "SweetBoxStatus", "GiftStatus", "SilverCoinStatus", "Remark" },
                    new[] { "Sr. No.", "Code", "Name", "Branch", "Sweet Box", "Gift", "Silver Coin", "Remark" });
            else if (category == "Distribution Summary")
                AddExportSheet(workbook, sheetName, filtered,
                    new[] { "Location", "Particular", "Quantity", "Rate", "Amount" },
                    new[] { "Branch", "Item", "Quantity", "Rate", "Amount" });
            else
                AddExportSheet(workbook, sheetName, filtered,
                    new[] { "SerialNo", "ExpenseDate", "Particular", "Location", "Quantity", "Rate", "Amount", "Remark" },
                    new[] { "Sr. No.", "Date", "Particular", "Location", "Count", "Rate", "Amount", "Remark" });
        }

        private static void AddExportSheet(XLWorkbook workbook, string sheetName, DataTable source, string[] columns, string[] headers)
        {
            IXLWorksheet sheet = workbook.Worksheets.Add(sheetName);
            for (int column = 0; column < headers.Length; column++) sheet.Cell(1, column + 1).Value = headers[column];
            for (int row = 0; row < source.Rows.Count; row++)
            {
                for (int column = 0; column < columns.Length; column++)
                {
                    object value = source.Columns.Contains(columns[column]) ? source.Rows[row][columns[column]] : DBNull.Value;
                    if (value != DBNull.Value) sheet.Cell(row + 2, column + 1).Value = XLCellValue.FromObject(value);
                }
            }
            int totalRow = source.Rows.Count + 2;
            sheet.Cell(totalRow, 1).Value = "Total";
            if (headers.Length > 1) sheet.Cell(totalRow, 2).Value = "Count: " + source.Rows.Count;
            int quantityColumn = Array.IndexOf(columns, "Quantity") + 1;
            int amountColumn = Array.IndexOf(columns, "Amount") + 1;
            if (quantityColumn > 0 && source.Rows.Count > 0) sheet.Cell(totalRow, quantityColumn).FormulaA1 = "SUM(" + sheet.Cell(2, quantityColumn).Address + ":" + sheet.Cell(totalRow - 1, quantityColumn).Address + ")";
            if (amountColumn > 0 && source.Rows.Count > 0)
            {
                DataRow grandTotal = source.AsEnumerable().FirstOrDefault(r =>
                {
                    string particular = source.Columns.Contains("Particular") ? Convert.ToString(r["Particular"]).Trim() : "";
                    return particular.Equals("Grand Total", StringComparison.OrdinalIgnoreCase) || particular.Equals("Total Diwali Expenses", StringComparison.OrdinalIgnoreCase);
                });
                sheet.Cell(totalRow, amountColumn).FormulaA1 = grandTotal == null
                    ? "SUM(" + sheet.Cell(2, amountColumn).Address + ":" + sheet.Cell(totalRow - 1, amountColumn).Address + ")"
                    : "=" + sheet.Cell(source.Rows.IndexOf(grandTotal) + 2, amountColumn).Address;
            }
            IXLRange used = sheet.RangeUsed();
            if (used != null)
            {
                used.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                used.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                sheet.Row(1).Style.Fill.BackgroundColor = XLColor.FromHtml("#5A78A8");
                sheet.Row(1).Style.Font.FontColor = XLColor.White;
                sheet.Row(1).Style.Font.Bold = true;
                sheet.Row(totalRow).Style.Fill.BackgroundColor = XLColor.FromHtml("#EAF0F8");
                sheet.Row(totalRow).Style.Font.Bold = true;
                if (amountColumn > 0) sheet.Column(amountColumn).Style.NumberFormat.Format = "#,##0.00";
                if (quantityColumn > 0) sheet.Column(quantityColumn).Style.NumberFormat.Format = "#,##0.00";
                sheet.Columns().AdjustToContents(1, 50);
                sheet.SheetView.FreezeRows(1);
            }
        }

        [WebMethod]
        public static List<int> GetYears()
        {
            DataSet data = ExecuteGet(null);
            return data.Tables.Count == 0 ? new List<int>() : data.Tables[0].AsEnumerable().Select(r => Convert.ToInt32(r["ExpenseYear"])).ToList();
        }

        [WebMethod]
        public static DiwaliExpenseResult GetExpenses(int year)
        {
            if (year < 2000 || year > 2100) throw new ArgumentException("Please select a valid year.");
            DataSet data = ExecuteGet(year);
            return new DiwaliExpenseResult
            {
                Summary = ToRows(TableAt(data, 1)),
                Items = ToRows(TableAt(data, 2))
            };
        }

        private void ImportWorkbook()
        {
            Response.Clear(); Response.ContentType = "application/json";
            try
            {
                int year;
                HttpPostedFile file = Request.Files.Count > 0 ? Request.Files[0] : null;
                if (!int.TryParse(Request.Form["year"], out year) || year < 2000 || year > 2100) throw new InvalidDataException("Enter a valid import year.");
                ValidateFile(file);
                DiwaliImportData import;
                using (Stream stream = file.InputStream) import = ReadWorkbook(stream, year);
                SaveImport(year, Path.GetFileName(file.FileName), import);
                WriteJson(new { success = true, message = "Diwali expenses for " + year + " were imported successfully." });
            }
            catch (InvalidDataException ex) { WriteJson(new { success = false, message = ex.Message }); }
            catch (Exception ex)
            {
                Trace.Warn("DiwaliExpenses", "Import failed.", ex);
                WriteJson(new { success = false, message = "The workbook could not be imported. Please contact the administrator with the time of this attempt." });
            }
            Context.ApplicationInstance.CompleteRequest();
        }

        private void WriteJson(object value) { Response.Write(new JavaScriptSerializer().Serialize(value)); }

        private static void ValidateFile(HttpPostedFile file)
        {
            if (file == null || file.ContentLength == 0) throw new InvalidDataException("Select a non-empty Excel workbook.");
            if (file.ContentLength > MaxUploadBytes) throw new InvalidDataException("The workbook must be 10 MB or smaller.");
            if (!string.Equals(Path.GetExtension(file.FileName), ".xlsx", StringComparison.OrdinalIgnoreCase)) throw new InvalidDataException("Only .xlsx workbooks are supported.");
        }

        private static DiwaliImportData ReadWorkbook(Stream stream, int year)
        {
            DiwaliImportData result = new DiwaliImportData();
            using (XLWorkbook workbook = new XLWorkbook(stream))
            {
                IXLWorksheet summary = FindSheet(workbook, "Summary");
                IXLWorksheet expense = FindSheet(workbook, "Diwali " + year);
                IXLWorksheet coins = FindSheetContaining(workbook, "Silver Coins");
                IXLWorksheet gifts = FindSheetContaining(workbook, "Gift for Seniors");
                IXLWorksheet employees = FindSheetContaining(workbook, "List of EMP");
                ValidateHeader(summary, 1, 1, "Sr No"); ValidateHeader(expense, 2, 3, "Particular"); ValidateHeader(employees, 1, 2, "Code");

                for (int row = 2; row <= summary.LastRowUsed().RowNumber(); row++)
                {
                    string particular = Text(summary.Cell(row, 2)); if (string.IsNullOrWhiteSpace(particular) || particular.StartsWith("Total", StringComparison.OrdinalIgnoreCase) || particular.StartsWith("Round", StringComparison.OrdinalIgnoreCase)) continue;
                    result.Summary.Add(new ImportSummary { SerialNo = NullableInt(summary.Cell(row, 1)), Particular = particular, Amount = Decimal(summary.Cell(row, 3)), Remark = Text(summary.Cell(row, 4)), SortOrder = row });
                }
                for (int row = 3; row <= expense.LastRowUsed().RowNumber(); row++)
                {
                    string particular = Text(expense.Cell(row, 3));
                    if (NullableInt(expense.Cell(row, 1)).HasValue && !string.IsNullOrWhiteSpace(particular)) result.Items.Add(ExpenseItem("General Expense", expense, row, 1, 2, 3, 4, 0, 0, 5));
                }
                AddSideTable(result.Items, expense, "Food Arrangement", 3, 4);
                AddSideTable(result.Items, expense, "Sweet Boxes", 8, 10);
                AddSimpleTable(result.Items, coins, "Silver Coins");
                AddSimpleTable(result.Items, gifts, "Senior Gifts");
                for (int row = 2; row <= employees.LastRowUsed().RowNumber(); row++)
                {
                    string name = Text(employees.Cell(row, 3)); if (string.IsNullOrWhiteSpace(name)) continue;
                    result.Items.Add(new ImportItem { Category="Employee Distribution", SerialNo=NullableInt(employees.Cell(row,1)), EmployeeCode=Text(employees.Cell(row,2)), EmployeeName=name, Branch=Text(employees.Cell(row,4)), SweetBoxStatus=Text(employees.Cell(row,5)), GiftStatus=Text(employees.Cell(row,6)), SilverCoinStatus=Text(employees.Cell(row,7)), Remark=JoinRemarks(Text(employees.Cell(row,8)),Text(employees.Cell(row,15))), SortOrder=row });
                }
            }
            if (result.Summary.Count == 0 || result.Items.Count == 0) throw new InvalidDataException("The workbook does not contain Diwali expense data in the expected format.");
            foreach (DateTime date in result.Items.Where(x => x.ExpenseDate.HasValue).Select(x => x.ExpenseDate.Value)) if (date.Year != year) throw new InvalidDataException("The workbook contains expense dates outside the selected import year.");
            return result;
        }

        private static void AddSideTable(List<ImportItem> items, IXLWorksheet sheet, string category, int firstRow, int lastRow)
        {
            for(int row=firstRow;row<=lastRow;row++){string particular=Text(sheet.Cell(row,10));if(string.IsNullOrWhiteSpace(particular)||particular.Equals("Total",StringComparison.OrdinalIgnoreCase))continue;items.Add(ExpenseItem(category,sheet,row,8,9,10,11,12,13,14));}
        }
        private static void AddSimpleTable(List<ImportItem> items, IXLWorksheet sheet, string category)
        {
            for(int row=2;row<=sheet.LastRowUsed().RowNumber();row++){string particular=Text(sheet.Cell(row,3));if(string.IsNullOrWhiteSpace(particular)||particular.Equals("Total",StringComparison.OrdinalIgnoreCase))continue;items.Add(ExpenseItem(category,sheet,row,1,2,3,0,0,0,4));}
        }
        private static ImportItem ExpenseItem(string category, IXLWorksheet sheet, int row, int serialCol, int dateCol, int particularCol, int locationCol, int quantityCol, int rateCol, int amountCol)
        {
            return new ImportItem { Category=category, SerialNo=NullableInt(sheet.Cell(row,serialCol)), ExpenseDate=Date(sheet.Cell(row,dateCol)), Particular=Text(sheet.Cell(row,particularCol)), Location=locationCol==0?null:Text(sheet.Cell(row,locationCol)), Quantity=quantityCol==0?null:NullableDecimal(sheet.Cell(row,quantityCol)), Rate=rateCol==0?null:NullableDecimal(sheet.Cell(row,rateCol)), Amount=Decimal(sheet.Cell(row,amountCol)), SortOrder=row };
        }

        private static IXLWorksheet FindSheet(XLWorkbook workbook, string name)
        {
            IXLWorksheet sheet = workbook.Worksheets.FirstOrDefault(x => x.Name.Trim().Equals(name, StringComparison.OrdinalIgnoreCase));
            if (sheet == null) throw new InvalidDataException("Missing required worksheet: " + name + "."); return sheet;
        }
        private static IXLWorksheet FindSheetContaining(XLWorkbook workbook, string name)
        {
            IXLWorksheet sheet = workbook.Worksheets.FirstOrDefault(x => x.Name.IndexOf(name, StringComparison.OrdinalIgnoreCase) >= 0);
            if (sheet == null) throw new InvalidDataException("Missing required worksheet containing: " + name + "."); return sheet;
        }
        private static void ValidateHeader(IXLWorksheet sheet,int row,int column,string expected){if(Text(sheet.Cell(row,column)).IndexOf(expected,StringComparison.OrdinalIgnoreCase)<0)throw new InvalidDataException("Worksheet '"+sheet.Name+"' is not in the expected format.");}
        private static string Text(IXLCell cell){return cell==null?null:cell.GetString().Trim();}
        private static int? NullableInt(IXLCell cell){int value;return int.TryParse(Text(cell),NumberStyles.Any,CultureInfo.InvariantCulture,out value)?value:(int?)null;}
        private static decimal? NullableDecimal(IXLCell cell){decimal value;return decimal.TryParse(Text(cell),NumberStyles.Any,CultureInfo.InvariantCulture,out value)?value:(decimal?)null;}
        private static decimal Decimal(IXLCell cell){decimal? value=NullableDecimal(cell);if(!value.HasValue)throw new InvalidDataException("Expected a numeric amount at "+cell.Worksheet.Name+"!"+cell.Address+".");return value.Value;}
        private static DateTime? Date(IXLCell cell){DateTime value;if(cell.TryGetValue<DateTime>(out value))return value;return DateTime.TryParse(Text(cell),out value)?value:(DateTime?)null;}
        private static string JoinRemarks(string first,string second){return string.Join("; ",new[]{first,second}.Where(x=>!string.IsNullOrWhiteSpace(x)));}

        private static void SaveImport(int year, string sourceFile, DiwaliImportData import)
        {
            XElement payload = new XElement("DiwaliExpense",
                new XElement("Summary", import.Summary.Select(x => new XElement("Row", Attr("SerialNo",x.SerialNo),Attr("Particular",x.Particular),Attr("Amount",x.Amount),Attr("Remark",x.Remark),Attr("SortOrder",x.SortOrder)))),
                new XElement("Items", import.Items.Select(x => new XElement("Row", Attr("Category",x.Category),Attr("SerialNo",x.SerialNo),Attr("ExpenseDate",x.ExpenseDate),Attr("Particular",x.Particular),Attr("Location",x.Location),Attr("Quantity",x.Quantity),Attr("Rate",x.Rate),Attr("Amount",x.Amount),Attr("EmployeeCode",x.EmployeeCode),Attr("EmployeeName",x.EmployeeName),Attr("Branch",x.Branch),Attr("SweetBoxStatus",x.SweetBoxStatus),Attr("GiftStatus",x.GiftStatus),Attr("SilverCoinStatus",x.SilverCoinStatus),Attr("Remark",x.Remark),Attr("SortOrder",x.SortOrder)))));
            int addedBy; int.TryParse(HttpContext.Current.User.Identity.Name, out addedBy);
            using(SqlConnection connection=new SqlConnection(SQLHelper.ConnectionString))using(SqlCommand command=new SqlCommand("usp_ImportDiwaliExpense",connection))
            {command.CommandType=CommandType.StoredProcedure;command.CommandTimeout=120;command.Parameters.Add("@Year",SqlDbType.Int).Value=year;command.Parameters.Add("@AddedBy",SqlDbType.Int).Value=addedBy;command.Parameters.Add("@SourceFileName",SqlDbType.NVarChar,260).Value=sourceFile;command.Parameters.Add("@Payload",SqlDbType.Xml).Value=payload.ToString(System.Xml.Linq.SaveOptions.DisableFormatting);connection.Open();command.ExecuteNonQuery();}
        }
        private static XAttribute Attr(string name,object value){return new XAttribute(name,value==null?string.Empty:(value is DateTime?((DateTime)value).ToString("yyyy-MM-dd",CultureInfo.InvariantCulture):Convert.ToString(value,CultureInfo.InvariantCulture)));}
        private static DataSet ExecuteGet(int? year){SqlCommand command=SQLHelper.GetCommand(CommandType.StoredProcedure,"usp_GetDiwaliExpense");command.Parameters.Add("@Year",SqlDbType.Int).Value=(object)year??DBNull.Value;return SQLHelper.ExecuteDataSetCmd(command);}
        private static DataTable TableAt(DataSet data,int index){return data!=null&&data.Tables.Count>index?data.Tables[index]:new DataTable();}
        private static List<Dictionary<string,object>> ToRows(DataTable table){var rows=new List<Dictionary<string,object>>();foreach(DataRow dr in table.Rows){var row=new Dictionary<string,object>();foreach(DataColumn col in table.Columns){object value=dr[col];row[col.ColumnName]=value==DBNull.Value?null:(value is DateTime?((DateTime)value).ToString("dd-MMM-yyyy"):value);}rows.Add(row);}return rows;}
    }

    public class DiwaliExpenseResult { public List<Dictionary<string,object>> Summary { get; set; } public List<Dictionary<string,object>> Items { get; set; } }
    internal class DiwaliImportData { public List<ImportSummary> Summary { get; private set; } = new List<ImportSummary>(); public List<ImportItem> Items { get; private set; } = new List<ImportItem>(); }
    internal class ImportSummary { public int? SerialNo { get; set; } public string Particular { get; set; } public decimal Amount { get; set; } public string Remark { get; set; } public int SortOrder { get; set; } }
    internal class ImportItem { public string Category { get; set; } public int? SerialNo { get; set; } public DateTime? ExpenseDate { get; set; } public string Particular { get; set; } public string Location { get; set; } public decimal? Quantity { get; set; } public decimal? Rate { get; set; } public decimal Amount { get; set; } public string EmployeeCode { get; set; } public string EmployeeName { get; set; } public string Branch { get; set; } public string SweetBoxStatus { get; set; } public string GiftStatus { get; set; } public string SilverCoinStatus { get; set; } public string Remark { get; set; } public int SortOrder { get; set; } }
}
