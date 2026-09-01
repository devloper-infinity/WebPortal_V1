using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class MonthlyBirthdays : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static string GetFilters()
        {
            EnsureAuthenticated();
            var master = new bllMaster();
            return Serialize(new { Branches = ToRows(master.GetAllBranches()), Domains = ToRows(master.GetAllDomain()) });
        }

        [WebMethod]
        public static string GetMonthlyBirthdayReport(int month, int branchId, int domainId)
        {
            EnsureAuthenticated();
            ValidateFilters(month, branchId, domainId);
            return Serialize(ToRows(new bllMaster().GetMonthlyBirthdays(month, branchId, domainId)));
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            int month;
            int branchId;
            int domainId;
            if (!int.TryParse(Request.Form["mb_month"], out month) ||
                !int.TryParse(Request.Form["mb_location"], out branchId) ||
                !int.TryParse(Request.Form["mb_domain"], out domainId))
                throw new ArgumentException("Invalid report filters.");

            ValidateFilters(month, branchId, domainId);
            DataTable source = new bllMaster().GetMonthlyBirthdays(month, branchId, domainId);
            DataTable export = source.Copy();
            export.Columns.Remove("BirthDay");

            using (var workbook = new XLWorkbook())
            using (var stream = new MemoryStream())
            {
                var sheet = workbook.Worksheets.Add(export, "Monthly Birthdays");
                sheet.SheetView.FreezeRows(1);
                sheet.Row(1).Style.Font.Bold = true;
                sheet.Row(1).Style.Fill.BackgroundColor = XLColor.FromHtml("#1F4E78");
                sheet.Row(1).Style.Font.FontColor = XLColor.White;
                sheet.Column(3).Style.DateFormat.Format = "dd-mmm-yyyy";
                sheet.Column(4).Style.DateFormat.Format = "dd-mmm-yyyy";
                sheet.Columns().AdjustToContents(10, 40);
                workbook.SaveAs(stream);

                byte[] fileBytes = stream.ToArray();

                Response.Clear();
                Response.ClearHeaders();
                Response.Buffer = true;
                Response.BufferOutput = true;
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition", "attachment;filename=Monthly_Birthdays_" + new DateTime(2000, month, 1).ToString("MMMM") + ".xlsx");
                Response.AddHeader("Content-Length", fileBytes.Length.ToString());
                Response.OutputStream.Write(fileBytes, 0, fileBytes.Length);
                Response.Flush();
                Response.End();
            }
        }

        private static void ValidateFilters(int month, int branchId, int domainId)
        {
            if (month < 1 || month > 12) throw new ArgumentException("Month is required.");
            if (branchId < 0 || domainId < 0) throw new ArgumentException("Invalid report filters.");
        }

        private static void EnsureAuthenticated()
        {
            if (HttpContext.Current.User == null || !HttpContext.Current.User.Identity.IsAuthenticated)
                throw new HttpException(401, "Authentication required.");
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow dataRow in table.Rows)
            {
                var row = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns) row[column.ColumnName] = dataRow[column];
                rows.Add(row);
            }
            return rows;
        }

        private static string Serialize(object value)
        {
            return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(value);
        }
    }
}
