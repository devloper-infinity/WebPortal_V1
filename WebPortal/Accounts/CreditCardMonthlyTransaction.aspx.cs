using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Accounts
{
    public partial class CreditCardMonthlyTransaction : System.Web.UI.Page
    {
        static string NewFileName = "";
        static string GUIDFile = "";
        static string NewFileName_Cancel = "";
        static string GUIDFile_Cancel = "";
        static string FolderPath = "";
        static string FolderPath_Cancel = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            FolderPath = Server.MapPath(@"~\EmployeeDocuments\CreditCardInvoice");
            FolderPath_Cancel = Server.MapPath(@"~\EmployeeDocuments\CreditCardInvoice\Cancelled");
            try
            {
                for (int i = 0; i < HttpContext.Current.Request.Files.Count; i++)
                {
                    HttpContext postedContext = HttpContext.Current;
                    HttpPostedFile file = postedContext.Request.Files[i];

                    string name = file.FileName;
                    byte[] binaryWriteArray = new byte[file.InputStream.Length];
                    file.InputStream.Read(binaryWriteArray, 0,
                    (int)file.InputStream.Length);

                    FileInfo file_Info = new FileInfo(file.FileName);
                    string ext = file_Info.Extension;

                    string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                    GUIDFile = file_Name;
                    NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                    FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                    objfilestream.Write(binaryWriteArray, 0,
                    binaryWriteArray.Length);
                    objfilestream.Close();
                    string filename = Convert.ToString(Request.Files["addinvoice_attachment"].FileName);
                }
            }
            catch { }

            try
            {
                for (int i = 0; i < HttpContext.Current.Request.Files.Count; i++)
                {
                    HttpContext postedContext = HttpContext.Current;
                    HttpPostedFile file = postedContext.Request.Files[i];

                    string name = file.FileName;
                    byte[] binaryWriteArray = new byte[file.InputStream.Length];
                    file.InputStream.Read(binaryWriteArray, 0,
                    (int)file.InputStream.Length);

                    FileInfo file_Info = new FileInfo(file.FileName);
                    string ext = file_Info.Extension;

                    string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                    GUIDFile_Cancel = file_Name;
                    NewFileName_Cancel = Server.MapPath("..//TempFiles//" + file_Name);
                    FileStream objfilestream = new FileStream(NewFileName_Cancel, FileMode.Create, FileAccess.ReadWrite);
                    objfilestream.Write(binaryWriteArray, 0,
                    binaryWriteArray.Length);
                    objfilestream.Close();
                    string filename = Convert.ToString(Request.Files["cancelinvoice_pop_attachment"].FileName);
                }
            }
            catch { }
        }

        [WebMethod]
        public static int InsertCreditCardInvoice(int CardID, string UsedFor, string UsedBy, string InvoiceNo, string InvoiceDate, decimal Amount, string Currency, string PaidDate, string Remark)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("CardID", CardID);
            htParam.Add("UsedFor", UsedFor);
            htParam.Add("UsedBy", UsedBy);
            htParam.Add("InvoiceNo", InvoiceNo);
            htParam.Add("InvoiceDate", InvoiceDate);
            htParam.Add("Amount", Amount);
            htParam.Add("Currency", Currency);
            htParam.Add("PaidDate", PaidDate);
            htParam.Add("Remark", Remark);
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
                string UniquePath = SubPath + "\\" + DateTime.Now.ToString("hhmmss");
                if (!Directory.Exists(UniquePath))
                {
                    Directory.CreateDirectory(UniquePath);
                }
                File.Copy(NewFileName, UniquePath + "\\" + GUIDFile);
                htParam.Add("Attachment", UniquePath + "\\" + GUIDFile);
            }
            else
                htParam.Add("Attachment", "");
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertCreditCardInvoice(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static string GetCreditCardInvoice()
        {
            DataTable dt1 = new bllMaster().GetAllCreditCardInvoice();
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
        public static string GetCreditCardInvoice_cancel(int CardId, string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetAllCreditCardInvoice_cancel(CardId, FromDate, ToDate);
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
        public static string GetCreditCards()
        {
            DataTable dt1 = new bllMaster().GetAllCreditCards();
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
        public static int CancelCreditCardInvoice(int InvoiceID, decimal CreditAmount, decimal CancelAmount, string CancelRemark)
        {
            int returnvalue = 0;
            string Attachment = "";
            if (NewFileName_Cancel != "")
            {
                if (!Directory.Exists(FolderPath_Cancel))
                {
                    Directory.CreateDirectory(FolderPath_Cancel);
                }
                string SubPath = FolderPath_Cancel + "\\" + Convert.ToString(DateTime.Now.ToString("dd-MMM-yyyy"));
                if (!Directory.Exists(SubPath))
                {
                    Directory.CreateDirectory(SubPath);
                }
                string UniquePath = SubPath + "\\" + DateTime.Now.ToString("hhmmss");
                if (!Directory.Exists(UniquePath))
                {
                    Directory.CreateDirectory(UniquePath);
                }
                File.Copy(NewFileName_Cancel, UniquePath + "\\" + GUIDFile_Cancel);
                Attachment = UniquePath + "\\" + GUIDFile_Cancel;
            }
            returnvalue = new bllMaster().CancelCreditCardInvoice(InvoiceID, CreditAmount, CancelAmount, CancelRemark, Attachment);
            return returnvalue;
        }
    }
}