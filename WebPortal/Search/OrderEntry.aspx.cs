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

namespace WebPortal.Search
{
    public partial class OrderEntry : System.Web.UI.Page
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
            FolderPath = Server.MapPath(@"~\SearchDocuments\");

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
        public static string GetAllState()
        {
            DataTable dt1 = new bllOST().GetAllState();
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
        public static string GetCountyByState(string State)
        {
            DataTable dt1 = new bllOST().GetCountyForState(State);
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
        public static string GetAllTemplateProject(int ProjectID)
        {
            DataTable dt1 = new bllOST().GetAllTemplateProject(ProjectID);
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
        public static string GetAllUsers()
        {
            DataTable dt1 = new bllOST().GetUsersOnUserType("Searcher");
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
        public static string GetUserWiseProject()
        {
            DataTable dt1 = new bllOST().GetAllProject(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetAllProductRelatedToProject(string ProjectNo)
        {
            DataTable dt1 = new bllOST().GetAllProductRelatedToProject(ProjectNo);
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
        public static string GetAllInfinityOrderByProjectAndUser(int ProjectID)
        {
            DataTable dt1 = new bllOST().GetAllInfinityOrderByProjectAndUser(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), ProjectID);
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
        public static string GetOrderByID(int OrderID)
        {
            DataTable dt1 = new bllOST().GetOrderByID(OrderID);
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
        public static int InsertOrder(int ID)
        {
            return 0;
        }

      [WebMethod]
        public static int core_InsertOrder(int OrderID, int ProjectID, string ProjectNo, string OrderPriority, string ExpectedTAT, string OnOffline, string Exhibit, string Transaction, string CustomerType, string State, string County, int Searcher, int Template,
                                      string ProductType, string OrderDate, string ReceivedDate, string ClientOrderNo, string BorrowerName, string PropertyAddress, string SalesPrice, string SellerName, string ClientID, string PinNo, string Instruction, string LegalDescription)
        {
            int ReturnValue = 0;
            try
            {
                DataTable dt_1 = new bllOST().GetMaxOrderID();
                int MaxorderID = 0;
                if (dt_1.Rows.Count > 0)
                {
                    MaxorderID = Convert.ToInt32(dt_1.Rows[0]["OrderID"]);
                }
                int currentOrderID = MaxorderID + 1;

                string date = string.Empty;

                Hashtable htparam = new Hashtable();
                htparam["OrderID"] = OrderID;

                DateTime orderDateTime = Convert.ToDateTime(ReceivedDate.Trim());
                if (orderDateTime.TimeOfDay == TimeSpan.Zero)
                    date = Convert.ToDateTime(OrderDate).ToString("MM/dd/yyyy") + ' ' + DateTime.Now.ToString("HH:mm:ss");
                else
                    date = orderDateTime.ToString("MM/dd/yyyy HH:mm:ss");

                htparam["OrderDateTime"] = date;
                htparam["OrderDate"] = Convert.ToDateTime(OrderDate).ToString("dd-MMM-yyyy");
                htparam["ProjectNumber"] = ProjectNo;
                htparam["ClientOrderNo"] = ClientOrderNo;
                htparam["BName"] = BorrowerName;
                htparam["State"] = State;
                htparam["County"] = County;
                htparam["ProductType"] = ProductType;
                htparam["ExpectedTime"] = ExpectedTAT;
                htparam["PropertyAddress"] = PropertyAddress;
                htparam["LegalDescription"] = LegalDescription;
                htparam["OnOffLine"] = OnOffline;
                htparam["Instruction"] = Instruction;
                htparam["Exhibit"] = Exhibit;
                htparam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
                htparam["Path"] = path;
                htparam["Transaction"] = Transaction;
                htparam["OrderPriority"] = OrderPriority;

                if (Template > 0)
                    htparam["OrderTemplateId"] = Template;
                else
                    htparam["OrderTemplateId"] = 0;

                if (!string.IsNullOrEmpty(SalesPrice))
                    htparam["SalesPrice"] = SalesPrice;
                else
                    htparam["SalesPrice"] = 0.00;

                if (!string.IsNullOrEmpty(SellerName))
                    htparam["SellerName"] = SellerName;
                else
                    htparam["SellerName"] = string.Empty;

                if (!string.IsNullOrEmpty(ClientID))
                    htparam["ClientIDNew"] = ClientID;
                else
                    htparam["ClientIDNew"] = string.Empty;

                if (ProjectNo == "213-003")
                    htparam["CustomerType"] = CustomerType;
                else
                    htparam["CustomerType"] = "";

                if (ProjectNo == "591")
                    htparam["Pin"] = PinNo;
                else
                    htparam["Pin"] = "";

                ReturnValue =  new bllOST().InsertInfinityOrder(htparam);

                if (ReturnValue > 0)
                {
                    ReturnValue = new bllOST().InsertCommentOrder(ReturnValue, 0, "Auto", "Order Created", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                }

                #region Commented as Per Kedar's Suggestion

                //if (ReturnValue > 0)
                //{
                //    int taskTemplateID = 0;

                //    if (Searcher != 0)
                //    {
                //        if (ProjectID > 0)
                //        {
                //            DataTable dt1 = new bllOST().GetAllTemplateProject(Convert.ToInt32(ProjectID));
                //            if (dt1.Rows.Count > 0)
                //            {
                //                taskTemplateID = Convert.ToInt32(dt1.Rows[0]["TemplateID"]);
                //            }
                //        }

                //        #region No of Doc. in Project

                //        DataTable dt = new bllOST().GetAllDocAndProductRelatedToProject(ProjectNo, ProductType);
                //        if (dt.Rows.Count > 0)
                //        {
                //            for (int i = 0; i < dt.Rows.Count; i++)
                //            {
                //                Hashtable htorder = new Hashtable();
                //                htorder["Orderid"] = ReturnValue;
                //                htorder["ProductType"] = ProductType;
                //                htorder["TaskTemplateid"] = taskTemplateID;
                //                htorder["Docid"] = Convert.ToInt32(dt.Rows[i]["ID"]);
                //                htorder["TaskAssignedId"] = Searcher;
                //                htorder["TaskProcessid"] = 1;
                //                htorder["OnOffLine"] = OnOffline;
                //                htorder["AllocateTo"] = "Searcher";
                //                htorder["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                //                new bllOST().InsertOrderTask(htorder);// ReturnValue, Product, taskTemplateID, TaskProcessId, OnOff, DocId, AssignTo, "Searcher");
                //            }
                //        }

                //        #endregion
                //    }
                //}
                //else if (ReturnValue == 0)
                //{
                //    #region Add Attachment
                //    //string UpdatedAttachment = string.Empty;
                //    //if (fldOrderAttachment.HasFile)
                //    //{
                //    //    if (!Directory.Exists(Server.MapPath(@"~\OSTAttachment\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + OrderID)))
                //    //        Directory.CreateDirectory(Server.MapPath(@"~\OSTAttachment\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + OrderID));
                //    //    fldOrderAttachment.SaveAs(Server.MapPath(@"~\OSTAttachment\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + OrderID + "\\" + fldOrderAttachment.FileName));
                //    //    UpdatedAttachment = "~\\OSTAttachment\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + OrderID + "\\" + fldOrderAttachment.FileName;
                //    //    string Attachment1 = Server.MapPath(@"~\OSTAttachment\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + OrderID + "\\" + fldOrderAttachment.FileName);
                //    //}
                //    //else
                //    //{
                //    //    UpdatedAttachment = uploadedFile;
                //    //}

                //    htparam["OrderID"] = OrderID;
                //    htparam["Path"] = "";// UpdatedAttachment;
                //    new bllOST().InsertInfinityOrder(htparam);

                //    #endregion
                //}

                #endregion
            }
            catch (Exception ex)
            {

            }
            return ReturnValue;
        }


        [WebMethod]
        public static int DeleteOrder(int OrderID)
        {
            int returnvalue = new bllOST().DeleteInfinityOrder(Convert.ToInt32(OrderID));
            return returnvalue;
        }

        [WebMethod]
        public static int InsertOrder_662(string ReceivedDate, string ClientOrderNo, string BorrowerName, string PropertyAddress, string SellerName, string Instruction, string State, string County, string Transaction)
        {
            int ReturnValue = 0;

            try
            {
                int OrderID = 0;// Convert.ToInt32(Request.QueryString["OrderID"]);
                string date = string.Empty;
                DateTime OrderDate = DateTime.Now;
                string Attachment = string.Empty;

                Hashtable htparam = new Hashtable();
                htparam["OrderID"] = OrderID;

                DateTime orderDateTime = Convert.ToDateTime(ReceivedDate);

                if (orderDateTime.TimeOfDay == TimeSpan.Zero)
                {
                    date = "";// OrderDate; // Convert.ToDateTime(OrderDate.ToString("MM/dd/yyyy")) + ' ' + DateTime.Now.ToString("HH:mm:ss");
                }
                else
                {
                    date = orderDateTime.ToString("MM/dd/yyyy HH:mm:ss");
                }

                htparam["OrderDateTime"] = date;
                htparam["OrderDate"] = Convert.ToDateTime(ReceivedDate).ToString("dd-MMM-yyyy");

                htparam["OrderDateTime"] = date;
                htparam["OrderDate"] = Convert.ToDateTime(ReceivedDate).ToString("dd-MMM-yyyy");
                htparam["ProjectNumber"] = "662-002";
                htparam["ClientOrderNo"] = ClientOrderNo;
                htparam["BName"] = BorrowerName;
                htparam["State"] = State;
                htparam["County"] = County;
                htparam["ProductType"] = "NA";
                htparam["OrderTemplateId"] = 0;
                htparam["ExpectedTime"] = "1.30";
                htparam["PropertyAddress"] = PropertyAddress;
                htparam["LegalDescription"] = "";
                htparam["OnOffLine"] = "Online";
                htparam["SalesPrice"] = 0.00;
                htparam["SellerName"] = SellerName;
                htparam["ClientIDNew"] = string.Empty;
                htparam["CustomerType"] = "";
                htparam["Pin"] = "";
                htparam["OrderPriority"] = "Normal";
                htparam["Transaction"] = Transaction;
                htparam["Instruction"] = Instruction;
                htparam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                DataTable dt_1 = new bllOST().GetMaxOrderID();
                int MaxorderID = 0;
                if (dt_1.Rows.Count > 0)
                {
                    MaxorderID = Convert.ToInt32(dt_1.Rows[0]["OrderID"]);
                }
                int currentOrderID = MaxorderID + 1;

                #region Add Attachment

                //if (fldOrderAttachment.HasFile)
                //{
                //    if (!Directory.Exists(Server.MapPath(@"~\OSTAttachment\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + currentOrderID)))
                //        Directory.CreateDirectory(Server.MapPath(@"~\OSTAttachment\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + currentOrderID));
                //    fldOrderAttachment.SaveAs(Server.MapPath(@"~\OSTAttachment\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + currentOrderID + "\\" + fldOrderAttachment.FileName));
                //    Attachment = "~\\OSTAttachment\\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + currentOrderID + "\\" + fldOrderAttachment.FileName;
                //    string Attachment1 = Server.MapPath(@"~\OSTAttachment\" + DateTime.Now.ToString("dd-MMM-yyyy") + "\\" + currentOrderID + "\\" + fldOrderAttachment.FileName);
                //}
                //else
                //{
                //    Attachment = string.Empty;
                //}

                #endregion

                htparam["Path"] = Attachment;

                ReturnValue = new bllOST().InsertInfinityOrder(htparam);

                if (ReturnValue > 0)
                {
                    // txtOrderDate1.Text = DateTime.Now.ToString("dd-MMM-yyyy");

                    #region Add Comment

                    Hashtable htComment = new Hashtable();
                    htComment["OrderId"] = ReturnValue;
                    htComment["ProcessId"] = 0;
                    htComment["ProcessName"] = "Auto";
                    htComment["Comment"] = "Order Created.";
                    htComment["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                    ReturnValue = new bllOST().InsertCommentOrder(ReturnValue, 0, "Auto", "Order Created.", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    #endregion
                }
            }
            catch (Exception ex)
            {

            }
            return ReturnValue;
        }

        [WebMethod]
        public static int ImportData()
        {
            int ReturnValue = 0;

            string File_Name = "";

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
                    DataTable Dt = ReadExcelFile(NewFileName); // dtImport;

                    // int truncateTempData = new bllMaster().TruncatetempSecRelLoansList();

                    if (Dt != null)
                    {
                        string con = "";
                        SqlConnection sqlConnection = new SqlConnection();
                        sqlConnection.ConnectionString = "Data Source=23.111.175.186;Initial Catalog=InfinityERP;Persist Security Info=True;User ID=sa;Password=#Cl0ud^$ecure4; Pooling=true; Min Pool Size=1; Max Pool Size=10; Connect Timeout=200; Packet Size=8192";
                        SqlBulkCopy objbulk = new SqlBulkCopy(sqlConnection);

                        //assigning Destination table name
                        objbulk.DestinationTableName = "dbo.TitleInternal_Order";
                        string destTableQuery = "Select top 1 * from dbo.TitleInternal_Order";
                        SqlCommand cmd = new SqlCommand(destTableQuery);
                        sqlConnection.Open();
                        cmd.Connection = sqlConnection;

                        // i use sql helper for executing query you can use corde sw
                        DataTable dtDest = SQLHelper.ExecuteDataSetCmd(cmd).Tables[0];

                        //Dt.Columns.Add("SecuritizationID", typeof(string));
                        //Dt.Columns.Add("ProjectID", typeof(int));
                        //Dt.Columns.Add("AddedBy", typeof(int));
                        //Dt.Columns.Add("AddedDate", typeof(DateTime));

                        //Dt.AsEnumerable().ToList().ForEach(row => row["SecuritizationID"] = 1);//SecuritizationID)
                        //Dt.AsEnumerable().ToList().ForEach(row => row["ProjectID"] = 1);
                        //Dt.AsEnumerable().ToList().ForEach(row => row["AddedDate"] = DateTime.Now);
                        //Dt.AsEnumerable().ToList().ForEach(row => row["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                        using (SqlBulkCopy bulk = new SqlBulkCopy(sqlConnection))
                        {
                            //objbulk.ColumnMappings.Clear();
                            //objbulk.ColumnMappings.Add("SecuritizationID", "SecuritizationID");
                            //objbulk.ColumnMappings.Add("ProjectID", "ProjectID");
                            //objbulk.ColumnMappings.Add("Deal #", "DealNo");
                            //objbulk.ColumnMappings.Add("Loan #1", "LoanNo");
                            //objbulk.ColumnMappings.Add("Loan #2", "LoanNo2");
                            //objbulk.ColumnMappings.Add("Received Date", "ReceivedDate");
                            //objbulk.ColumnMappings.Add("Delivered Date", "DeliveredDate");
                            //objbulk.ColumnMappings.Add("AddedBy", "AddedBy");
                            //objbulk.ColumnMappings.Add("AddedDate", "AddedDate");
                            //objbulk.ColumnMappings.Add("Source", "Source");

                            //objbulk.WriteToServer(Dt);
                            //sqlConnection.Close();

                            //ReturnValue = dtImport.Rows.Count;
                            //dtImport = null;
                        }
                    }
                    else
                    {
                        ReturnValue = -1;
                    }
                }
                else
                {
                    ReturnValue = -2;
                }
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
    }
}
