using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
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
    public partial class ImportFeedback : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = Server.MapPath(@"~\ReportDocument");
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

                string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
            }
            catch { }
        }

        [WebMethod]
        public static string GetUserInfo()
        {
            DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string getValidatedFeedbacks(string Type)
        {
            DataTable dt1 = null;
            if (Type == "Credit" || Type == "Securitizaton")
                dt1 = new bllMaster().GetValidatedFeedbacks_Credit();
            else
                dt1 = new bllMaster().GetValidatedFeedbacks_Servicing();
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
                        //dt.Rows.Add(row.Cells().Select(c => c.Value).ToArray());
                        dt.Rows.Add(row.Cells().Select(c => c.GetValue<string>() ?? "").ToArray());
                    }
                }
            }

            return dt;
        }

        [WebMethod]
        public static string ImportFile(string Subdomain)
        {
            try
            {
                SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_deletetempimportedfeedbacks_Revised");
                SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Subdomain);
                SQLHelper.ExecuteScalarCmd(cmd);
            }
            catch { }
            string returnvalue = "";
            DataTable dtSheet = new DataTable();
            string SheetName = "";
            if (NewFileName != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                string SubPath = FolderPath + "\\" + Convert.ToString(DateTime.Now.ToString("dd-MMM-yyyy"));
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                string UniquePath = SubPath + "\\" + DateTime.Now.ToString("Feedback");
                if (!Directory.Exists(UniquePath))
                {
                    Directory.CreateDirectory(UniquePath);
                }
                string FileName = UniquePath + "\\" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);
                File.Copy(NewFileName, FileName);

                string Extn = FileName.Substring(FileName.LastIndexOf(".") + 1);
                string ConExcel;
                if (Extn == "xls" | Extn == "xlsx")
                {

                    DataTable Dt = new DataTable();
                    //Dt.Columns[0].DataType = typeof(long);
                    Dt = ReadExcelFile(FileName);
                    if (Dt != null)
                    {
                        if (Dt.Rows.Count > 0)
                        {
                            #region Columns validations
                            SqlConnection sqlConnection = new SqlConnection();
                            sqlConnection.ConnectionString = "Data Source=23.111.175.186;Initial Catalog=InfinityERP;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192";
                            SqlBulkCopy objbulk = new SqlBulkCopy(sqlConnection);
                            //assigning Destination table name
                            if (Subdomain == "Credit")
                                objbulk.DestinationTableName = "dbo.ImportedFeedbacks_Temp_New_Credit";
                            else
                                objbulk.DestinationTableName = "dbo.ImportedFeedbacks_Temp_New_Servicing";
                            string destTableQuery = "";
                            if (Subdomain == "Credit")
                                destTableQuery = "Select top 1 FeedbackID, [Loan Number], Client, [UW Name], [QC Name], Category, [Sub category], [Error Field], Screen, [Error Type], Finding, [Feedback Type], Severity, RCA, Source, [Feedback Received Date], [Emp Status] from dbo.ImportedFeedbacks";
                            else
                                destTableQuery = "Select top 1 FeedbackID, [Loan Number], Client, [UW Name], [QC Name], Category, [Sub category], [Error Field], Screen, [Error Type], Finding, [Feedback Type], Severity, RCA, Source, [Feedback Received Date], [Emp Status] from dbo.ImportedFeedbacks_Servicing";
                            //destTableQuery = "select top 1 FeedbackID,[Loan Number],Client,[UW Name],[UW Process],[QC Name],[QC Process],Category,[Sub category],[Error Field],Screen,Error Type,Finding,[Feedback Type],Severity,RCA,Comments,Source,[Feedback Received Date]";
                            SqlCommand cmd = new SqlCommand(destTableQuery);
                            sqlConnection.Open();
                            cmd.Connection = sqlConnection;
                            // i use sql helper for executing query you can use corde sw
                            DataTable dtDest = SQLHelper.ExecuteDataTableCmd(cmd);

                            for (int i = 0; i < dtDest.Columns.Count; i++)
                            {
                                string destinationColumnName = dtDest.Columns[i].Caption.ToString();
                                if (Dt.Columns.Contains(destinationColumnName))
                                {
                                    //Once column matched get its index
                                    int sourceColumnIndex = Dt.Columns.IndexOf(destinationColumnName);
                                    string sourceColumnName = Dt.Columns[sourceColumnIndex].ToString();
                                    // give column name of source table rather then destination table 
                                    // so that it would avoid case sensitivity
                                    SqlBulkCopyColumnMapping sqlBulkCopyColumnMapping = new SqlBulkCopyColumnMapping(sourceColumnName, destinationColumnName);
                                    objbulk.ColumnMappings.Add(sourceColumnName, destinationColumnName);
                                }
                            }
                            objbulk.ColumnMappings.Add("UW Process", "UW Process");
                            objbulk.ColumnMappings.Add("QC Process", "QC Process");

                            objbulk.WriteToServer(Dt);
                            sqlConnection.Close();
                            returnvalue = "Excel validated Successfully.";

                            //for (int i = 0; i < Dt.Rows.Count; i++)
                            //{
                            //    int checkexistance = new bllMaster().CheckifProjectExists(Convert.ToString(Dt.Rows[i]["Client"]));
                            //    if (checkexistance == 0)
                            //    {
                            //        returnvalue = "Project #: <span style='color:red;'>" + Convert.ToString(Dt.Rows[i]["Client"]) + "</span> does not exists in ERP. Please check line # " + (i + 2) + " and column 2~-2";
                            //        return returnvalue;
                            //    }
                            //    int uwexists = new bllMaster().CheckifpsuedonameExists(Convert.ToString(Dt.Rows[i]["UW Name"]));
                            //    if (uwexists == 0)
                            //    {
                            //        returnvalue = "UW Name: <span style='color:red;'>" + Convert.ToString(Dt.Rows[i]["UW Name"]) + "</span> does not exists in ERP. Please check line # " + (i + 2) + " and column 3~-2";
                            //        return returnvalue;
                            //    }
                            //    int qcexists = new bllMaster().CheckifpsuedonameExists(Convert.ToString(Dt.Rows[i]["QC Name"]));
                            //    if (qcexists == 0)
                            //    {
                            //        returnvalue = "QC Name: <span style='color:red;'>" + Convert.ToString(Dt.Rows[i]["QC Name"]) + "</span> does not exists in ERP. Please check line # " + (i + 2) + " and column 4~-2";
                            //        return returnvalue;
                            //    }
                            //}
                            #endregion
                        }
                    }
                }
            }
            return returnvalue;
        }

        [WebMethod]
        public static int ImportExceldata()
        {
            int returnvalue = 0;
            DataTable dtSheet = new DataTable();
            string SheetName = "";
            if (NewFileName != "")
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }
                string SubPath = FolderPath + "\\" + Convert.ToString(DateTime.Now.ToString("dd-MMM-yyyy"));
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                string UniquePath = SubPath + "\\" + DateTime.Now.ToString("Feedback");
                if (!Directory.Exists(UniquePath))
                {
                    Directory.CreateDirectory(UniquePath);
                }
                string FileName = UniquePath + "\\" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);
                File.Copy(NewFileName, FileName);

                string Extn = FileName.Substring(FileName.LastIndexOf(".") + 1);
                string ConExcel;
                if (Extn == "xls" | Extn == "xlsx")
                {
                    if (Extn.Contains("xlsx"))
                    {
                        ConExcel = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + FileName + "; Extended Properties=\"Excel 12.0;HDR=YES;IMEX=1\"";
                    }
                    else
                    {
                        ConExcel = "Provider=Microsoft.Jet.OLEDB.4.0;" + "Data Source=" + FileName + "; Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\"";
                    }
                    DataSet dsExcel = new DataSet();
                    OleDbConnection sheet = new OleDbConnection(ConExcel);
                    sheet.Open();
                    dtSheet = sheet.GetSchema("Tables");
                    if (dtSheet.Rows.Count > 0)
                    {
                        if (dtSheet.Rows[0]["TABLE_NAME"].ToString().Contains("FilterD"))
                        {
                            dtSheet.Rows[0].Delete();
                            dtSheet.AcceptChanges();
                        }
                        SheetName = dtSheet.Rows[0]["TABLE_NAME"].ToString();
                    }
                    dtSheet.Clear();
                    dtSheet.Dispose();
                    DataTable Dt = new DataTable();
                    try
                    {
                        using (OleDbConnection myExcelConnection = new OleDbConnection(ConExcel))
                        {
                            string sqlExcel = "";
                            sqlExcel = "Select * from [" + SheetName + "]";
                            OleDbDataAdapter daExcel = new OleDbDataAdapter(sqlExcel, myExcelConnection);
                            daExcel.Fill(dsExcel);
                            daExcel.Dispose();
                            Dt = dsExcel.Tables[0];
                            if (myExcelConnection.State == ConnectionState.Open)
                            {
                                myExcelConnection.Close();
                            }
                        }

                        if (Dt != null)
                        {
                            if (Dt.Rows.Count > 0)
                            {
                            }
                        }
                        returnvalue = 0;
                    }
                    catch(Exception ex)
                    {
                        returnvalue = 0;
                    }
                }
            }
            return returnvalue;
        }

        [WebMethod]
        public static int InserUpdateFeedbacks(string Subdomain)
        {
            int returnvalue = 0;
            if (Subdomain == "Servicing")
                returnvalue = new bllMaster().InsertUpdateFeedbacks_Servicing();
            else
                returnvalue = new bllMaster().InsertUpdateFeedbacks_Credit();
            return returnvalue;
        }
    }
}