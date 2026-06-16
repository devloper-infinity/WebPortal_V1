using ClosedXML.Excel;
using Spire.Xls;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
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
using WebPortal.App_Code.DAL;

namespace WebPortal.US
{
    public partial class ReQcUtility : System.Web.UI.Page
    {
        static DataTable dtImport = new DataTable();
        static string NewFileName = "";
        static string FileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static Workbook book = new Workbook();
        static Worksheet wksheet = null;
        public static string path;

        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = Server.MapPath(@"~\USDocuments\");

            try
            {
                HttpContext postedContext = HttpContext.Current;
                HttpPostedFile file = postedContext.Request.Files[0];

                string name = file.FileName;
                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0,
                (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;

                FileName = file.FileName;

                NewFileName = Server.MapPath("..//TempFiles//" + file.FileName);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
            }
            catch { }
        }


        [WebMethod]
        public static string GetLoanDetails(int ReQc)
        {
            DataTable dt1 = new bllUS().GetAllTempReQC1(ReQc);
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
        public static string GetSummaryDetails(int ReQc)
        {
            DataTable dt1 = new bllUS().GetAllTempReQC2(ReQc);
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
        public static int ImportData()
        {
            try
            {
                DataTable dtdel = new bllUS().DeleteAllTempReQC1();

                if (string.IsNullOrEmpty(NewFileName))
                    return -3;

                if (!Directory.Exists(FolderPath))
                    Directory.CreateDirectory(FolderPath);


                string ext = Path.GetExtension(NewFileName);

                if (ext != ".xlsx")
                    return -2;

                DataTable dt = ReadExcelFile(NewFileName);
                dtImport = dt;

                if (dtImport == null)
                    return -1;

                if (dtImport != null)
                {
                    string con = "";
                    SqlConnection sqlConnection = new SqlConnection();
                    sqlConnection.ConnectionString = "Data Source=23.111.175.186;Initial Catalog=Underwriting;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192";
                    SqlBulkCopy objbulk = new SqlBulkCopy(sqlConnection);

                    //assigning Destination table name
                    objbulk.DestinationTableName = "dbo.TempReQc";
                    string destTableQuery = "Select top 1 * from dbo.TempReQc";
                    SqlCommand cmd = new SqlCommand(destTableQuery);
                    sqlConnection.Open();
                    cmd.Connection = sqlConnection;

                    // i use sql helper for executing query you can use corde sw
                    DataTable dtDest = SQLHelper.ExecuteDataSetCmd_Underwriting(cmd).Tables[0];


                    //  using (SqlConnection con = new SqlConnection("YOUR_CONN_STRING"))
                    using (SqlBulkCopy bulk = new SqlBulkCopy(con))
                    {
                        bulk.DestinationTableName = "dbo.TempReQc";
                        bulk.ColumnMappings.Add("DealNo", "DealNo");
                        bulk.ColumnMappings.Add("Loan #1", "LoanNo1");
                        bulk.ColumnMappings.Add("Loan #2", "LoanNo2");
                        bulk.ColumnMappings.Add("Reviewer", "Review");
                        bulk.ColumnMappings.Add("QCer", "QC");
                        bulk.ColumnMappings.Add("ReviewStatus", "ReviewStatus");

                        objbulk.WriteToServer(dtImport);
                        sqlConnection.Close();
                    }
                }
                return dtImport.Rows.Count; // <-- SUCCESS (370)
            }
            catch (Exception ex)
            {
                throw; // VERY IMPORTANT
            }
        }


        public static DataTable ReadExcelFile(string path)
        {

            DataTable dt = new DataTable();

            using (var workbook = new XLWorkbook(path))
            {
                var ws = workbook.Worksheet(1);
                var range = ws.RangeUsed();
                bool firstRow = true;

                foreach (var row in range.Rows())
                {
                    if (firstRow)
                    {
                        foreach (var cell in row.Cells())
                            dt.Columns.Add(cell.Value.ToString());
                        firstRow = false;
                    }
                    else
                    {
                        dt.Rows.Add(row.Cells().Select(c => c.GetValue<string>() ?? "").ToArray());
                    }
                }
            }
            return dt;
        }
    }
}