using ClosedXML.Excel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class SecuritizationBillingImport : Page
    {
        private const string UploadFolderPath = @"C:\Securitization";

        private static DataTable dtInfo = new DataTable();
        private static DataTable dtImport = new DataTable();
        private static string NewFileName = "";
        private static string GUIDFile = "";
        private static int ProjectId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            SavePostedFile();
        }

        private void SavePostedFile()
        {
            try
            {
                HttpFileCollection files = Request.Files;
                if (files == null || files.Count == 0)
                {
                    return;
                }

                HttpPostedFile file = files[0];
                if (file == null || file.ContentLength <= 0)
                {
                    return;
                }

                string ext = Path.GetExtension(file.FileName);
                GUIDFile = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;

                string tempFolder = Server.MapPath("..//TempFiles//");
                if (!Directory.Exists(tempFolder))
                {
                    Directory.CreateDirectory(tempFolder);
                }

                NewFileName = Path.Combine(tempFolder, GUIDFile);
                file.SaveAs(NewFileName);
            }
            catch
            {
            }
        }

        [WebMethod]
        public static string GetDealDetails(string DealNo)
        {
            DataSet ds = new bllMaster().GetDealDetails(DealNo);

            DataTable dt1 = ds.Tables[0];
            dtInfo = ds.Tables[1];

            GetSummaryDetails();

            return SerializeTable(dt1);
        }

        [WebMethod]
        public static string GetAllDealsFromProjectTracking_Billing()
        {
            DataTable dt1 = new bllMaster().GetAllDealsFromProjectTracking_Billing();
            return SerializeTable(dt1);
        }

        [WebMethod]
        public static string GetSummaryDetails()
        {
            return SerializeTable(dtInfo);
        }

        [WebMethod]
        public static int InsertSecuritizationRelianceLetter_Billing(string BillingType, string DealNo, string ProjectID, string ClientDealName, string ProjectName, string LoanCount, string AssociateHours, string Remark)
        {
            int returnvalue = 0;

            try
            {
                Hashtable htParam = new Hashtable();
                int loanCount = Convert.ToInt32(LoanCount);
                int hoursOrLoans = loanCount;
                string BillingPeriod = "";

                if (BillingType == "Securitization" && !string.IsNullOrWhiteSpace(AssociateHours))
                {
                    hoursOrLoans = Convert.ToInt32(AssociateHours);
                }

                if (loanCount == 1)
                    BillingPeriod = DealNo + "-" + ProjectName + "_" + ClientDealName + "_" + BillingType + "_" + loanCount + " Unbilled Loan";
                else
                    BillingPeriod = DealNo + "-" + ProjectName + "_" + ClientDealName + "_" + BillingType + "_" + loanCount + " Unbilled Loans";

                htParam.Add("BillingPeriod", BillingPeriod);
                htParam.Add("ProjectId", ProjectID);
                htParam.Add("Description", BillingPeriod);
                htParam.Add("BillingType", BillingType);
                htParam.Add("LoanCount", loanCount);
                htParam.Add("NoOfHoursLoans", 0);
                htParam.Add("AssociateRemark", "Unbilled Securitization Deals Loan List");
                htParam.Add("DealNo", DealNo);
                htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                returnvalue = new bllMaster().InsertSecuritizationRelLetterBilling_Unbilled(htParam);
            }
            catch
            {
                returnvalue = -1;
            }

            return returnvalue;
        }

        [WebMethod]
        public static int ReadExcel(int BillingId, string DealNo, string Remark)
        {
            int ReturnValue = 0;

            try
            {
                if (string.IsNullOrWhiteSpace(NewFileName))
                {
                    return 0;
                }

                if (!Directory.Exists(UploadFolderPath))
                {
                    Directory.CreateDirectory(UploadFolderPath);
                }

                File.Copy(NewFileName, Path.Combine(UploadFolderPath, GUIDFile), true);

                string Extn = Path.GetExtension(NewFileName).TrimStart('.').ToLowerInvariant();

                if (Extn == "xlsx")
                {
                    DataTable Dt = ReadExcelFile(NewFileName);

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

                            htVerify.Add("SecureID", BillingId);
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
                    {
                        ReturnValue = 0;
                    }
                }
                else
                {
                    ReturnValue = -1;
                }
            }
            catch
            {
                ReturnValue = -1;
            }

            return ReturnValue;
        }

        [WebMethod]
        public static int ImportData(int BillingId)
        {
            int ReturnValue = 0;

            DataTable Dt = dtImport;

            int truncateTempData = new bllMaster().TruncatetempSecRelLoansList();

            if (Dt != null && truncateTempData > 0)
            {
                string connectionString = SQLHelper.ConnectionString;// "Data Source=23.111.175.186;Initial Catalog=InfinityERP;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192";

                using (SqlConnection sqlConnection = new SqlConnection(connectionString))
                {
                    sqlConnection.Open();

                    if (!Dt.Columns.Contains("SecuritizationID"))
                        Dt.Columns.Add("SecuritizationID", typeof(string));
                    if (!Dt.Columns.Contains("ProjectID"))
                        Dt.Columns.Add("ProjectID", typeof(int));
                    if (!Dt.Columns.Contains("AddedBy"))
                        Dt.Columns.Add("AddedBy", typeof(int));
                    if (!Dt.Columns.Contains("AddedDate"))
                        Dt.Columns.Add("AddedDate", typeof(DateTime));

                    Dt.AsEnumerable().ToList().ForEach(row => row["SecuritizationID"] = BillingId);
                    Dt.AsEnumerable().ToList().ForEach(row => row["ProjectID"] = ProjectId);
                    Dt.AsEnumerable().ToList().ForEach(row => row["AddedDate"] = DateTime.Now);
                    Dt.AsEnumerable().ToList().ForEach(row => row["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    using (SqlBulkCopy objbulk = new SqlBulkCopy(sqlConnection))
                    {
                        objbulk.DestinationTableName = "dbo.SecRelLoansListUnbilled";
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
                    }
                }

                ReturnValue = dtImport.Rows.Count;
                dtImport = null;
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

            using (XLWorkbook workbook = new XLWorkbook(path))
            {
                IXLWorksheet ws = workbook.Worksheet(1);
                IXLRange range = ws.RangeUsed();

                if (range == null)
                {
                    return dt;
                }

                bool firstRow = true;

                foreach (IXLRangeRow row in range.Rows())
                {
                    if (firstRow)
                    {
                        foreach (IXLCell cell in row.Cells())
                            dt.Columns.Add(cell.Value.ToString());
                        firstRow = false;
                    }
                    else
                    {
                        dt.Rows.Add(row.Cells(1, dt.Columns.Count).Select(c => c.GetValue<string>() ?? "").ToArray());
                    }
                }
            }

            return dt;
        }

        [WebMethod]
        public static string GetExistingLoanList()
        {
            DataTable dt1 = new bllMaster().GetExistingLoanList_Unbilled();
            return SerializeTable(dt1);
        }

        [WebMethod]
        public static string GetNewLoanDetails()
        {
            return SerializeTable(dtImport);
        }

        [WebMethod]
        public static string VerifySecRelLoans()
        {
            DataTable dt1 = new bllMaster().VerifySecRelLoans();
            dtImport = dt1;
            return SerializeTable(dt1);
        }

        [WebMethod]
        public static int ClearLoanList()
        {
            dtImport = null;
            return new bllMaster().ClearLoanList();
        }

        private static string SerializeTable(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (table != null)
            {
                foreach (DataRow dr in table.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn col in table.Columns)
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
