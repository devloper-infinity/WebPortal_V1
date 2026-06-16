using ClosedXML.Excel;
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
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class HoursSpent : System.Web.UI.Page
    {
        static DataSet ds = new DataSet();
        static DataTable dtProject = new DataTable();
        static DataTable dtPrjPrc = new DataTable();
        static DataTable dtUser = new DataTable();
        static DataTable dtprod = new DataTable();
        static Workbook book = new Workbook();
        static Worksheet sheet = null;
        static string FromDate1 = "";
        static string ToDate1 = "";

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string GetProjectWiseData(string FromDate, string ToDate)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;

            FromDate1 = FromDate;
            ToDate1 = ToDate;

            ds = new bllMaster().GetAllDataForHoursSpent(FromDate, ToDate);
            DataTable dt1 = dtProject = ds.Tables[0];
            dtPrjPrc = ds.Tables[1];
            dtUser = ds.Tables[2];
            dtprod = ds.Tables[3];

            if (dtProject != null)
            {
                foreach (DataRow dr in dtProject.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dtProject.Columns)
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
        public static string GetProjectProcessWiseData()
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;

            if (dtPrjPrc != null)
            {
                foreach (DataRow dr in dtPrjPrc.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dtPrjPrc.Columns)
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
        public static string GetProjectProcessUserWiseData()
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;

            if (dtUser != null)
            {
                foreach (DataRow dr in dtUser.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dtUser.Columns)
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
        public static string GetPrductionData()
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;

            if (dtprod != null)
            {
                foreach (DataRow dr in dtprod.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dtprod.Columns)
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

        protected void btnHoursSpent_Click(object sender, EventArgs e)
        {
            string FileName = Server.MapPath(@"~\ReportDocument\Hours_Spent_" + Convert.ToString(FromDate1) + "-" + Convert.ToString(ToDate1) + DateTime.Now.ToString("hhmmss") + ".xlsx");
            book = new Workbook();
            book.DefaultFontSize = 10;
            book.DefaultFontName = "Aptos Narrow";

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

            int sheetIndexToDelete = 1;

            using (var workbook = new XLWorkbook(filePath))
            {
                AddSheet(workbook, dtProject, "Project");
                AddSheet(workbook, dtPrjPrc, "Project_Process");
                AddSheet(workbook, dtUser, "Project_User_Process");
                AddSheet(workbook, dtprod, "Production_Data");

                if (sheetIndexToDelete >= 0 && sheetIndexToDelete < workbook.Worksheets.Count)
                {
                    var worksheet = workbook.Worksheet(1);

                    workbook.Worksheets.Delete(worksheet.Name);
                    worksheet = workbook.Worksheet(1);
                    workbook.Worksheets.Delete(worksheet.Name);
                    worksheet = workbook.Worksheet(1);
                    workbook.Worksheets.Delete(worksheet.Name);
                    worksheet = workbook.Worksheet(1);
                    workbook.Worksheets.Delete(worksheet.Name);
                }
                else
                {
                }

                workbook.SaveAs(outputPath);

                Response.Clear();
                Response.Buffer = false;
                Response.AppendHeader("Content-Type", "application/xlsx");
                Response.AppendHeader("Content-Transfer-Encoding", "binary");
                Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(FileName));
                Response.TransmitFile(FileName);
                Response.End();
            }
        }

        private static void AddSheet(XLWorkbook wb, DataTable dt, string sheetName)
        {
            if (dt == null || dt.Rows.Count == 0)
                return;

            var ws = wb.Worksheets.Add(sheetName);

            var table = ws.Cell(1, 1).InsertTable(dt, true);

            table.Theme = XLTableTheme.None;      // Plain grid
            table.ShowAutoFilter = true;

            table.RangeUsed().Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;

            var header = table.HeadersRow();
            header.Style.Fill.BackgroundColor = XLColor.LightGray;
            header.Style.Font.Bold = true;
            header.Style.Font.FontColor = XLColor.Black;
            header.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

            ws.Columns().AdjustToContents();
        }

    }
}