using ClosedXML.Excel;
using DocumentFormat.OpenXml.Drawing.Charts;
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
using WebPortal.App_Code.DAL;


namespace WebPortal.Admin
{
    public partial class OtherBilling : System.Web.UI.Page
    {
        static System.Data.DataTable dtImport = new System.Data.DataTable();

        static string NewFileName = "";
        static string FileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static Workbook book = new Workbook();
        static Worksheet wksheet = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = "C:\\BillingDocuments";

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

                // string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                NewFileName = Server.MapPath("..//TempFiles//" + file.FileName);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();


            }
            catch { }
        }

        [WebMethod(EnableSession = true)]
        public static int ImportExcel(int ProjectID, string DealNo, string deal_satus)
        {
            int ReturnValue = 0;
            string File_Name = "";

            try
            {
                HttpContext.Current.Session.Remove("OtherBillingImportData");
                if (deal_satus == "New")
                {
                    ReturnValue = new bllMaster().InsertDealInTracking(ProjectID, DealNo);

                    if (ReturnValue <= 0)
                    {
                        ReturnValue = -3;
                        return ReturnValue;
                    }
                }

                if (NewFileName != "")
                {
                    if (!Directory.Exists(FolderPath))
                    {
                        Directory.CreateDirectory(FolderPath);
                    }

                    File_Name = FolderPath + "\\" + FileName.Substring(FileName.LastIndexOf("\\") + 1);

                    File.Copy(NewFileName, File_Name);

                    string Extn = NewFileName.Substring(NewFileName.LastIndexOf(".") + 1);

                    if (Extn == "xlsx")
                    {
                        System.Data.DataTable Dt = new System.Data.DataTable();
                        Dt = ReadExcelFile(NewFileName);

                        dtImport = Dt;
                        HttpContext.Current.Session["OtherBillingImportData"] = Dt;

                        if (Dt.Rows.Count > 0)
                            ReturnValue = 1;
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

            File.Delete(File_Name);
            return ReturnValue;
        }

        [WebMethod(EnableSession = true)]
        public static int VerifyAndSubmitData(string Type, int ProjectID, string DealNo)
        {
            int ReturnValue = 0;
            HttpContext.Current.Server.ScriptTimeout = 600;

            try
            {
                System.Data.DataTable Dt = HttpContext.Current.Session["OtherBillingImportData"] as System.Data.DataTable;
                if (Dt == null || Dt.Rows.Count == 0)
                    return -2;

                if (Type == "Research")
                {
                    #region Research Insertion Code

                    if (Dt != null)
                    {
                        string con = "";
                        SqlConnection sqlConnection = new SqlConnection();
                        sqlConnection.ConnectionString = "Data Source=23.111.175.186;Initial Catalog=InfinityBilling_UW;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192";
                        SqlBulkCopy objbulk = new SqlBulkCopy(sqlConnection);
                        objbulk.BulkCopyTimeout = 600;

                        //assigning Destination table name
                        objbulk.DestinationTableName = "dbo.InfinityBilling_ResearchBilling";
                        string destTableQuery = "Select top 1 * from dbo.InfinityBilling_ResearchBilling";
                        SqlCommand cmd = new SqlCommand(destTableQuery);
                        cmd.CommandTimeout = 600;
                        sqlConnection.Open();
                        cmd.Connection = sqlConnection;

                        // i use sql helper for executing query you can use corde sw
                        System.Data.DataTable dtDest = SQLHelper.ExecuteDataSetCmd(cmd).Tables[0];

                        Dt.Columns.Add("BillingAddedDate", typeof(string));
                        Dt.Columns.Add("BillingPeriod", typeof(string));
                        Dt.Columns.Add("ProjectID", typeof(int));
                        Dt.Columns.Add("IsVerify", typeof(bool));

                        Dt.AsEnumerable().ToList().ForEach(row => row["BillingAddedDate"] = DateTime.Now.ToString("dd-MMM-yyyy"));
                        Dt.AsEnumerable().ToList().ForEach(row => row["BillingPeriod"] = DealNo);
                        Dt.AsEnumerable().ToList().ForEach(row => row["ProjectID"] = ProjectID);
                        Dt.AsEnumerable().ToList().ForEach(row => row["IsVerify"] = true);

                        using (SqlBulkCopy bulk = new SqlBulkCopy(sqlConnection))
                        {
                            objbulk.ColumnMappings.Clear();

                            objbulk.ColumnMappings.Add("ProjectID", "ProjectId");
                            objbulk.ColumnMappings.Add("IsVerify", "IsVerify");
                            objbulk.ColumnMappings.Add("Deal No", "Deal No");
                            objbulk.ColumnMappings.Add("BillingPeriod", "BillingPeriod");
                            objbulk.ColumnMappings.Add("BillingAddedDate", "BillingAddedDate");
                            objbulk.ColumnMappings.Add("Subject Line", "Subject Line");
                            objbulk.ColumnMappings.Add("Requested Docs/Tasks Performed", "Requested Docs/Tasks Performed");
                            objbulk.ColumnMappings.Add("No of Loans/Docs", "No of Docs Researched");
                            objbulk.ColumnMappings.Add("Total Time Taken (in Minutes)", "Total Time Taken (in Minutes)");
                            objbulk.ColumnMappings.Add("Request Received from", "Request Received from");
                            objbulk.ColumnMappings.Add("Request Received Date", "Request Received Date");
                            objbulk.ColumnMappings.Add("Documents Delivered Date", "Documents Delivered Date");
                            objbulk.ColumnMappings.Add("Remark", "Remark");
                            objbulk.ColumnMappings.Add("Time (In Hours)", "Time");
                            objbulk.ColumnMappings.Add("Deal Name", "PRP Deal Name");

                            objbulk.WriteToServer(Dt);
                            sqlConnection.Close();
                        }
                    }
                    if (Dt.Rows.Count > 0)
                    {
                        ReturnValue = 1;

                        ReturnValue = new bllMaster().InsertResearchBilling_NewERP(ProjectID, DealNo, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        dtImport = null;
                        HttpContext.Current.Session.Remove("OtherBillingImportData");
                    }
                    else
                        ReturnValue = 0;

                    #endregion
                }

                else if (Type == "Rebuttal")
                {
                    #region Rebuttal Insertion Code

                    if (Dt != null)
                    {
                        string con = "";
                        SqlConnection sqlConnection = new SqlConnection();
                        sqlConnection.ConnectionString = "Data Source=23.111.175.186;Initial Catalog=InfinityBilling_UW;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192";
                        SqlBulkCopy objbulk = new SqlBulkCopy(sqlConnection);
                        objbulk.BulkCopyTimeout = 600;

                        //assigning Destination table name
                        objbulk.DestinationTableName = "dbo.InfinityBilling_RebuttalBilling";
                        string destTableQuery = "Select top 1 * from dbo.InfinityBilling_RebuttalBilling";
                        SqlCommand cmd = new SqlCommand(destTableQuery);
                        cmd.CommandTimeout = 600;
                        sqlConnection.Open();
                        cmd.Connection = sqlConnection;

                        // i use sql helper for executing query you can use corde sw
                        System.Data.DataTable dtDest = SQLHelper.ExecuteDataSetCmd(cmd).Tables[0];

                        Dt.Columns.Add("BillingAddedDate", typeof(string));
                        Dt.Columns.Add("BillingPeriod", typeof(string));
                        Dt.Columns.Add("ProjectID", typeof(int));
                        Dt.Columns.Add("IsVerify", typeof(bool));

                        Dt.AsEnumerable().ToList().ForEach(row => row["BillingAddedDate"] = DateTime.Now.ToString("dd-MMM-yyyy"));
                        Dt.AsEnumerable().ToList().ForEach(row => row["BillingPeriod"] = DealNo);
                        Dt.AsEnumerable().ToList().ForEach(row => row["ProjectID"] = ProjectID);
                        Dt.AsEnumerable().ToList().ForEach(row => row["IsVerify"] = true);

                        using (SqlBulkCopy bulk = new SqlBulkCopy(sqlConnection))
                        {
                            objbulk.ColumnMappings.Clear();

                            objbulk.ColumnMappings.Add("ProjectID", "ProjectId");
                            objbulk.ColumnMappings.Add("IsVerify", "IsVerify");
                            objbulk.ColumnMappings.Add("BillingPeriod", "BillingPeriod");
                            objbulk.ColumnMappings.Add("BillingAddedDate", "BillingAddedDate");
                            objbulk.ColumnMappings.Add("Deal Number", "Deal Number");
                            objbulk.ColumnMappings.Add("Loan Number", "Loan Number");
                            objbulk.ColumnMappings.Add("Condition", "Condition");
                            objbulk.ColumnMappings.Add("Client Rebuttal", "Clients Rebuttal");
                            objbulk.ColumnMappings.Add("Status", "Cleared (Yes/No)");
                            objbulk.ColumnMappings.Add("Rebuttal Received Date", "Start Date/Time");
                            objbulk.ColumnMappings.Add("Rebuttal Response Date", "End Date/Time");
                            objbulk.ColumnMappings.Add("Time", "Time");
                            objbulk.ColumnMappings.Add("Billing Type", "BillingType");

                            objbulk.WriteToServer(Dt);
                            sqlConnection.Close();
                        }
                    }

                    if (Dt.Rows.Count > 0)
                    {
                        ReturnValue = 1;
                        dtImport = null;
                        HttpContext.Current.Session.Remove("OtherBillingImportData");

                        ReturnValue = new bllMaster().InsertRebuttalBilling_NewERP(ProjectID, DealNo, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                    }
                    else
                        ReturnValue = 0;

                    #endregion
                }
            }
            catch (Exception ex)
            {
                HttpContext.Current.Trace.Warn("OtherBilling", "VerifyAndSubmitData failed.", ex);
                ReturnValue = -4;
            }

            return ReturnValue;
        }

        public static System.Data.DataTable ReadExcelFile(string path)
        {
            System.Data.DataTable dt = new System.Data.DataTable();

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
        public static string GetExcelDataToBindGrid()
        {
            System.Data.DataTable dt1 = ReadExcelFile(NewFileName);

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
        public static string GetAllDealNumber(int ProjectID)
        {
            System.Data.DataTable dt1 = new bllMaster().GetAllDealNumber(ProjectID);

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
        public static string GetAllProjectByDomainWise(int DomainID)
        {
            System.Data.DataTable dt1 = new bllTracking().GetAllProjectByDomainWise(DomainID, Convert.ToInt32(HttpContext.Current.User.Identity.Name));
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
    }
}
