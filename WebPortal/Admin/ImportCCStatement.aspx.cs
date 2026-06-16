using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class ImportCCStatement : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = Server.MapPath(@"~\Statements");
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
                string filename = Convert.ToString(Request.Files["import_attach"].FileName);
            }
            catch { }
        }

        [WebMethod]
        public static int VerifyAndImport(string Month, string Year)
        {
            //           string Month = Convert.ToString(HttpContext.Current.Request.Form["hr_month"]);
            int returnvalue = 0;
            if (!Directory.Exists(FolderPath))
            {
                Directory.CreateDirectory(FolderPath);
            }
            string SubPath = FolderPath + "\\" + Convert.ToString(DateTime.Now.ToString("dd-MMM-yyyy"));
            if (!Directory.Exists(SubPath))
            {
                Directory.CreateDirectory(SubPath);
            }
            string UniquePath = SubPath + "\\" + DateTime.Now.ToString("hhmmss");
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
                DataTable Dt = new DataTable("[Sheet1$]");
                using (OleDbConnection myExcelConnection = new OleDbConnection(ConExcel))
                {
                    //myExcelConnection.Open();

                    string sqlExcel = "";
                    sqlExcel = "Select * from [Sheet1$]";
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
                        for (int i = 0; i < Dt.Rows.Count; i++)
                        {
                            string Description = Convert.ToString(Dt.Rows[i]["Description"]);
                            decimal Amount = Convert.ToDecimal(Dt.Rows[i]["Amount"]);
                            // int returnv = new bllMaster().GetCCInvoiceImportDetails(Month, Year, Description, Amount);
                         //   int returnv = new bllMaster().GetCCInvoiceImportDetails(Month, Year, Description, Amount, CardNumber, TransactionDate);

                        }
                    }
                }
                returnvalue = 1;
            }
            return returnvalue;
        }

        [WebMethod]
        public static string GetCCDataForVerification(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetCCDataForVerification(Month, Year);
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