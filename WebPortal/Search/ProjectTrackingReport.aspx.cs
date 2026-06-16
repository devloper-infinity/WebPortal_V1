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

namespace WebPortal.Search
{
    public partial class ProjectTrackingReport : System.Web.UI.Page
    {
        public static string path;
        static string NewFileName = "";
        static string FileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";

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
        public static string GetAllProjectNo()
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
        public static string GetAllOrderDetails(string FromDate, string ToDate, string ProjectNo)
        {
            DataTable dt1 = new bllOST().GetAllInfinityOrderTraking(FromDate, ToDate, ProjectNo);
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
        public static string GetOrderDetailsProcesswise(int OrderID)
        {
            DataTable dt1 = new bllOST().GetOrderDetailsProcesswise(OrderID);
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
        public static int InsertOrder(int OrderID, int ProjectID, string ProjectNo, string OrderPriority, string ExpectedTAT, string OnOffline, string Exhibit, string Transaction, string CustomerType, string State, string County, int Searcher, int Template,
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
                htparam["Path"] = FileName;
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

                ReturnValue = new bllOST().InsertInfinityOrder(htparam);

                if (ReturnValue > 0)
                {
                    ReturnValue = new bllOST().InsertCommentOrder(ReturnValue, 0, "Auto", "Order Updated", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                }
            }
            catch (Exception ex)
            {

            }
            return ReturnValue;
        }
    }
}