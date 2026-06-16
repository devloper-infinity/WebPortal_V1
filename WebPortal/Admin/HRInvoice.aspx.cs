using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class HRInvoice : System.Web.UI.Page
    {

        static string NewFileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static StringBuilder filelist = new StringBuilder();

        protected void Page_Load(object sender, EventArgs e)
        {
            filelist = new StringBuilder();
            FolderPath = Server.MapPath(@"~\InvoiceDocuments");
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

                    string file_Name =  Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                    GUIDFile = file_Name;
                    NewFileName = file_Name; // FolderPath + "\\" + file_Name;
                    NewFileName = Server.MapPath("..//TempFiles//" + file_Name);
                    if (filelist.ToString() == "")
                        filelist.Append(NewFileName);
                    else
                        filelist.Append("," + NewFileName);
                    FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                    objfilestream.Write(binaryWriteArray, 0,
                    binaryWriteArray.Length);
                    objfilestream.Close();
                }
            }
            catch { }
        }


        [WebMethod]
        public static string GetDepartmentForInvoice()
        {
            System.Data.DataTable dt1 = new bllMaster().GetDepartmentForInvoice();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (System.Data.DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (System.Data.DataColumn col in dt1.Columns)
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
        public static string GetHRInvoice()
        {
            System.Data.DataTable dt1 = new bllMaster().GetHRInvoice();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (System.Data.DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (System.Data.DataColumn col in dt1.Columns)
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
        public static string SaveInvoice(int InvoiceID, int EmpID, string code, string location, string invoiceType, string invoiceNo, string consultancy, string accountNo,
                                    string circuitID, string fromDate, string toDate, string dueDate, string amount,
                                    string gstNo, string pan, string assignTo, string category, string remark,
                                    string contractCondition, string vendorPayment)
        {
            int ReturnValue = 0;
            string msg = string.Empty;

            if (!Directory.Exists(FolderPath))
            {
                Directory.CreateDirectory(FolderPath);
            }
            string SubPath = FolderPath + "\\" + invoiceNo;
            if (!Directory.Exists(SubPath))
            {
                Directory.CreateDirectory(SubPath);
            }

            string UniquePath = SubPath + "\\" + NewFileName.Substring(NewFileName.LastIndexOf("\\") + 1);
            
            if (UniquePath != "" || UniquePath != string.Empty || UniquePath != null)
                File.Copy(NewFileName, UniquePath);

            Hashtable htparam = new Hashtable();

            htparam["Code"] = EmpID;
            htparam["CompanyName"] = "Infinity Data Technologies Pvt. Ltd.";
            htparam["Location"] = location;
            htparam["Fromdate"] = fromDate;
            htparam["Todate"] = toDate;
            htparam["Status"] = "Pending";
            htparam["VendorName"] = consultancy;
            htparam["Invoiceno"] = invoiceNo;
            htparam["AccountNo"] = accountNo;
            htparam["CircuitId"] = circuitID;
            htparam["Duedate"] = dueDate;
            htparam["BillAMount"] = amount;
            htparam["AssignTo"] = assignTo;
            htparam["Remark"] = remark;
            htparam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            htparam["Category"] = category;
            htparam["PAN"] = pan;
            htparam["GSTNo"] = gstNo;
            htparam["InvoiceType"] = invoiceType;
            htparam["VendorConditions"] = contractCondition;
            htparam["PaymentConditions"] = vendorPayment;
            htparam["FileUploadPath"] = UniquePath;

            if (InvoiceID == 0)
            {
                ReturnValue = new bllMaster().InsertCompanyInvoice(htparam);
                if (ReturnValue > 0)
                    msg = "Invoice Created successfully!";  //   SendEmail.SendInvoiceForVerification(htparam);
                else if (ReturnValue == -1)
                    msg = "Invoice already exist!";
                else
                    msg = "Error while creating the invoice";
            }
            else if (InvoiceID > 0)
            {
                ReturnValue = new bllMaster().UpdateCompanyInvoice(htparam);
                if (ReturnValue > 0)
                    msg = "Invoice Updated Successfully.";
                else
                    msg = "Invoice already exists.";
            }

            NewFileName = "";
            UniquePath = "";
            return msg;
        }
    }
}