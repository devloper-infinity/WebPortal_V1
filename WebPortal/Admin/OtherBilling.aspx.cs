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
            HttpContext.Current.Server.ScriptTimeout = 600;
            try
            {
                System.Data.DataTable importedData = HttpContext.Current.Session["OtherBillingImportData"] as System.Data.DataTable;
                if (importedData == null || importedData.Rows.Count == 0)
                    return -2;
                if (Type != "Research" && Type != "Rebuttal")
                    return 0;

                System.Data.DataTable data = importedData.Copy();
                PrepareBillingData(data, ProjectID, DealNo);

                string destination = Type == "Research"
                    ? "dbo.InfinityBilling_ResearchBilling"
                    : "dbo.InfinityBilling_RebuttalBilling";
                string procedure = Type == "Research"
                    ? "usp_InsertResearchBilling_NewERP"
                    : "usp_InsertRebuttalBilling_NewERP";

                int returnValue;
                using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionStringUWBilling))
                {
                    connection.Open();
                    using (SqlTransaction transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            using (SqlBulkCopy bulk = new SqlBulkCopy(connection, SqlBulkCopyOptions.Default, transaction))
                            {
                                bulk.DestinationTableName = destination;
                                bulk.BulkCopyTimeout = 600;
                                AddBillingMappings(bulk, Type);
                                bulk.WriteToServer(data);
                            }

                            returnValue = FinalizeBilling(connection, transaction, procedure, ProjectID, DealNo);
                            transaction.Commit();
                        }
                        catch
                        {
                            transaction.Rollback();
                            throw;
                        }
                    }
                }

                if (returnValue > 0)
                {
                    dtImport = null;
                    HttpContext.Current.Session.Remove("OtherBillingImportData");
                }
                return returnValue;
            }
            catch (Exception ex)
            {
                HttpContext.Current.Trace.Warn("OtherBilling", "VerifyAndSubmitData failed.", ex);
                LogVerifyError(ex, Type, ProjectID, DealNo);
                return -4;
            }
        }

        private static void PrepareBillingData(System.Data.DataTable table, int projectId, string dealNo)
        {
            EnsureColumn(table, "BillingAddedDate", typeof(string));
            EnsureColumn(table, "BillingPeriod", typeof(string));
            EnsureColumn(table, "ProjectID", typeof(int));
            EnsureColumn(table, "IsVerify", typeof(bool));
            string addedDate = DateTime.Now.ToString("dd-MMM-yyyy");
            foreach (DataRow row in table.Rows)
            {
                row["BillingAddedDate"] = addedDate;
                row["BillingPeriod"] = dealNo;
                row["ProjectID"] = projectId;
                row["IsVerify"] = true;
            }
        }

        private static void AddBillingMappings(SqlBulkCopy bulk, string type)
        {
            bulk.ColumnMappings.Add("ProjectID", "ProjectId");
            bulk.ColumnMappings.Add("IsVerify", "IsVerify");
            bulk.ColumnMappings.Add("BillingPeriod", "BillingPeriod");
            bulk.ColumnMappings.Add("BillingAddedDate", "BillingAddedDate");
            if (type == "Research")
            {
                bulk.ColumnMappings.Add("Deal No", "Deal No");
                bulk.ColumnMappings.Add("Subject Line", "Subject Line");
                bulk.ColumnMappings.Add("Requested Docs/Tasks Performed", "Requested Docs/Tasks Performed");
                bulk.ColumnMappings.Add("No of Loans/Docs", "No of Docs Researched");
                bulk.ColumnMappings.Add("Total Time Taken (in Minutes)", "Total Time Taken (in Minutes)");
                bulk.ColumnMappings.Add("Request Received from", "Request Received from");
                bulk.ColumnMappings.Add("Request Received Date", "Request Received Date");
                bulk.ColumnMappings.Add("Documents Delivered Date", "Documents Delivered Date");
                bulk.ColumnMappings.Add("Remark", "Remark");
                bulk.ColumnMappings.Add("Time (In Hours)", "Time");
                bulk.ColumnMappings.Add("Deal Name", "PRP Deal Name");
                return;
            }
            bulk.ColumnMappings.Add("Deal Number", "Deal Number");
            bulk.ColumnMappings.Add("Loan Number", "Loan Number");
            bulk.ColumnMappings.Add("Condition", "Condition");
            bulk.ColumnMappings.Add("Client Rebuttal", "Clients Rebuttal");
            bulk.ColumnMappings.Add("Status", "Cleared (Yes/No)");
            bulk.ColumnMappings.Add("Rebuttal Received Date", "Start Date/Time");
            bulk.ColumnMappings.Add("Rebuttal Response Date", "End Date/Time");
            bulk.ColumnMappings.Add("Time", "Time");
            bulk.ColumnMappings.Add("Billing Type", "BillingType");
        }

        private static int FinalizeBilling(SqlConnection connection, SqlTransaction transaction, string procedure, int projectId, string dealNo)
        {
            using (SqlCommand command = new SqlCommand(procedure, connection, transaction))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 600;
                command.Parameters.Add("@ProjectID", SqlDbType.BigInt).Value = projectId;
                command.Parameters.Add("@BillingPeriod", SqlDbType.NVarChar, 500).Value = dealNo;
                command.Parameters.Add("@AddedBy", SqlDbType.BigInt).Value = Int32.Parse(HttpContext.Current.User.Identity.Name);
                SqlParameter result = command.Parameters.Add("@ReturnValue", SqlDbType.BigInt);
                result.Direction = ParameterDirection.ReturnValue;
                command.ExecuteNonQuery();
                return result.Value == DBNull.Value ? 0 : Convert.ToInt32(result.Value);
            }
        }

        private static void EnsureColumn(System.Data.DataTable table, string name, Type type)
        {
            if (!table.Columns.Contains(name))
                table.Columns.Add(name, type);
        }

        private static void LogVerifyError(Exception ex, string type, int projectId, string dealNo)
        {
            try
            {
                string directory = HttpContext.Current.Server.MapPath("~/App_Data");
                Directory.CreateDirectory(directory);
                string entry = Environment.NewLine + new string('=', 50) + Environment.NewLine
                    + "Date: " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss") + Environment.NewLine
                    + "Type: " + type + Environment.NewLine
                    + "ProjectID: " + projectId + Environment.NewLine
                    + "DealNo: " + dealNo + Environment.NewLine
                    + "Identity: " + HttpContext.Current.User.Identity.Name + Environment.NewLine
                    + "Exception: " + ex + Environment.NewLine;
                File.AppendAllText(Path.Combine(directory, "OtherBilling_Error.txt"), entry);
            }
            catch
            {
            }
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
