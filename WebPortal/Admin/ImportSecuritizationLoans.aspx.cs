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
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ImportSecuritizationLoans : System.Web.UI.Page
    {
        static DataTable dtImport = new DataTable();
        static string NewFileName = "";
        static string FileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static Workbook book = new Workbook();
        static Worksheet wksheet = null;
        static int ProjectId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = "C:\\Securitization";

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

                string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;

                // File_Name = FolderPath + "\\" + FileName.Substring(FileName.LastIndexOf("\\") + 1);
                GUIDFile = file_Name;

                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
            }
            catch { }
        }

        [WebMethod]
        public static int ReadExcel(int DealNo, string Remark)
        {
            int ReturnValue = 0;
            string File_Name = "";

            try
            {
                if (NewFileName != "")
                {
                    if (!Directory.Exists(FolderPath))
                    {
                        Directory.CreateDirectory(FolderPath);
                    }

                    File_Name = FolderPath + "\\" + FileName.Substring(FileName.LastIndexOf("\\") + 1);

                    //File.Copy(NewFileName, File_Name);
                    File.Copy(NewFileName, FolderPath + "\\" + GUIDFile);

                    string Extn = NewFileName.Substring(NewFileName.LastIndexOf(".") + 1);

                    if (Extn == "xlsx")
                    {
                        DataTable Dt = new DataTable();

                        Dt = ReadExcelFile(NewFileName);

                        if (Dt.Rows.Count > 0)
                        {
                            ReturnValue = 1;

                            Dt.Columns.Add("Remark");
                            Dt.Columns.Add("SrNo");

                            for (int i = 0; i < Dt.Rows.Count; i++)
                            {
                                Dt.Rows[i]["SrNo"] = i + 1;

                                Hashtable htVerify = new Hashtable();

                                ProjectId = Convert.ToInt32(new bllMaster().GetprojectId(Convert.ToString(Dt.Rows[i]["Project #"])));

                                htVerify.Add("SecureID", DealNo);
                                htVerify.Add("ProjectID", ProjectId);
                                htVerify.Add("DealNo", Convert.ToString(Dt.Rows[i]["Deal #"]));
                                htVerify.Add("LoanNo1", Convert.ToString(Dt.Rows[i]["Loan #1"]));
                                htVerify.Add("LoanNo2", Convert.ToString(Dt.Rows[i]["Loan #2"]));
                                htVerify.Add("ReceivedDate", Convert.ToString(Dt.Rows[i]["Received Date"]));
                                htVerify.Add("DeliveredDate", Convert.ToString(Dt.Rows[i]["Delivered Date"]));
                                htVerify.Add("Source", Convert.ToString(Dt.Rows[i]["Source"]));

                                ReturnValue = new bllMaster().VeriftyData(htVerify);
                            }
                        }
                        else
                            ReturnValue = 0;
                    }
                    else
                    {
                        ReturnValue = -1;
                    }
                }
            }
            catch (Exception ex)
            {
                ReturnValue = -1;
            }
            //File.Delete(File_Name);

            return ReturnValue;
        }

        [WebMethod]
        public static int ImportData(int SecuritizationID)
        {
            int ReturnValue = 0;

            DataTable Dt = dtImport;

            int truncateTempData = new bllMaster().TruncatetempSecRelLoansList();

            if (Dt != null && truncateTempData > 0)
            {
                string con = "";
                SqlConnection sqlConnection = new SqlConnection();
                sqlConnection.ConnectionString = "Data Source=23.111.175.186;Initial Catalog=InfinityERP;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192";
                SqlBulkCopy objbulk = new SqlBulkCopy(sqlConnection);

                //assigning Destination table name
                objbulk.DestinationTableName = "dbo.SecRelLoansList";
                string destTableQuery = "Select top 1 * from dbo.SecRelLoansList";
                SqlCommand cmd = new SqlCommand(destTableQuery);
                sqlConnection.Open();
                cmd.Connection = sqlConnection;

                // i use sql helper for executing query you can use corde sw
                DataTable dtDest = SQLHelper.ExecuteDataSetCmd(cmd).Tables[0];

                Dt.Columns.Add("SecuritizationID", typeof(string));
                Dt.Columns.Add("ProjectID", typeof(int));
                Dt.Columns.Add("AddedBy", typeof(int));
                Dt.Columns.Add("AddedDate", typeof(DateTime));

                Dt.AsEnumerable().ToList().ForEach(row => row["SecuritizationID"] = SecuritizationID);
                Dt.AsEnumerable().ToList().ForEach(row => row["ProjectID"] = ProjectId);
                Dt.AsEnumerable().ToList().ForEach(row => row["AddedDate"] = DateTime.Now);
                Dt.AsEnumerable().ToList().ForEach(row => row["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                using (SqlBulkCopy bulk = new SqlBulkCopy(sqlConnection))
                {
                    objbulk.ColumnMappings.Clear();
                    objbulk.ColumnMappings.Add("SecuritizationID", "SecuritizationID");
                    objbulk.ColumnMappings.Add("ProjectID", "ProjectID");
                    objbulk.ColumnMappings.Add("Deal #", "DealNo");
                    objbulk.ColumnMappings.Add("Loan #1", "LoanNo");
                    objbulk.ColumnMappings.Add("Loan #2", "LoanNo2");
                    objbulk.ColumnMappings.Add("Received Date", "ReceivedDate");
                    objbulk.ColumnMappings.Add("Delivered Date", "DeliveredDate");
                    objbulk.ColumnMappings.Add("AddedBy", "AddedBy");
                    objbulk.ColumnMappings.Add("AddedDate", "AddedDate");
                    objbulk.ColumnMappings.Add("Source", "Source");

                    objbulk.WriteToServer(Dt);
                    sqlConnection.Close();

                    ReturnValue = dtImport.Rows.Count;
                    dtImport = null;
                }
            }
            else
            {
                ReturnValue = -1;
            }

            return ReturnValue;
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

        [WebMethod]
        public static string GetAllDealsFromProjectTracking()
        {
            DataTable dt1 = new bllMaster().GetAllDealsFromProjectTracking_Revised1();

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
        public static string GetExistingLoanList()
        {
            DataTable dt1 = new bllMaster().GetExistingLoanList();

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
        public static string GetNewLoanDetails()
        {
            DataTable dt1 = dtImport;

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
        public static string VerifySecRelLoans()
        {
            DataTable dt1 = new bllMaster().VerifySecRelLoans();
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
        public static int ClearLoanList()
        {
            dtImport = null;
            return new bllMaster().ClearLoanList();
        }
    }
}