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
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class OtherTask : System.Web.UI.Page
    {
        static DataTable dtImport = new DataTable();

        static string NewFileName = "";
        static string FileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static Workbook book = new Workbook();
        static Worksheet wksheet = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = Server.MapPath(@"~\OtherTaskDocuments\");

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
        public static int VerifyAndSubmitData(int ProjectID, string Project, string ProcessID, string Process)
        {
            int ReturnValue = 0;

            if (dtImport.Rows.Count == 0)
                return ReturnValue = 0;

            try
            {
                DataTable Dt = dtImport;

                #region Insertion

                if (Dt != null)
                {
                    string con = "";
                    SqlConnection sqlConnection = new SqlConnection();
                    SqlBulkCopy objbulk = new SqlBulkCopy(SQLHelper.ConnectionString);

                    //assigning Destination table name
                    objbulk.DestinationTableName = "dbo.WBT_TrackingSheet_OtherTask";
                    string destTableQuery = "Select top 1 * from dbo.WBT_TrackingSheet_OtherTask";
                    SqlCommand cmd = new SqlCommand(destTableQuery);
                    sqlConnection.Open();
                    cmd.Connection = sqlConnection;

                    // i use sql helper for executing query you can use corde sw
                    DataTable dtDest = SQLHelper.ExecuteDataSetCmd_Underwriting(cmd).Tables[0];

                    Dt.Columns.Add("AddedBy", typeof(int));
                    Dt.Columns.Add("AddedDate", typeof(DateTime));
                    Dt.Columns.Add("Process", typeof(string));
                    Dt.Columns.Add("ProjectNo", typeof(string));

                    Dt.AsEnumerable().ToList().ForEach(row => row["Process"] = Process);
                    Dt.AsEnumerable().ToList().ForEach(row => row["ProjectNo"] = Project);
                    Dt.AsEnumerable().ToList().ForEach(row => row["AddedDate"] = DateTime.Now);
                    Dt.AsEnumerable().ToList().ForEach(row => row["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    for (int i = 0; i < dtDest.Columns.Count; i++)
                    {
                        string destinationColumnName = dtDest.Columns[i].Caption.ToString();
                        if (Dt.Columns.Contains(destinationColumnName))
                        {
                            //Once column matched get its index
                            int sourceColumnIndex = Dt.Columns.IndexOf(destinationColumnName);
                            string sourceColumnName = Dt.Columns[sourceColumnIndex].ToString();

                            // give column name of source table rather then destination table // so that it would avoid case sensitivity
                            SqlBulkCopyColumnMapping sqlBulkCopyColumnMapping = new SqlBulkCopyColumnMapping(sourceColumnName, destinationColumnName);
                            objbulk.ColumnMappings.Add(sourceColumnName, destinationColumnName);
                        }
                    }
                    objbulk.WriteToServer(Dt);
                    sqlConnection.Close();

                    ReturnValue = dtImport.Rows.Count;
                    dtImport = null;
                }

                #endregion
            }
            catch (Exception ex)
            {
                ReturnValue = 0;
            }

            return ReturnValue;
        }

        public static DataTable ReadExcelFile(string path)
        {
            DataTable dt = new DataTable();
            if (path != null)
            {
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
            }
            return dt;
        }

        [WebMethod]
        public static string GetExcelDataToBindGrid()
        {
            DataTable dt1 = ReadExcelFile(NewFileName);

            dtImport = dt1;

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
        public static int ClearData()
        {
            dtImport = null;
            NewFileName = null;
            return 1;
        }
    }
}
