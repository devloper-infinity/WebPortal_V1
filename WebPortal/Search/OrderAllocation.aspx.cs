using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Drawing;
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
    public partial class OrderAllocation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int InsertOrderUser(int OrderId, string ProductType, int TaskProcessId)
        {
            int returnvalue = 0;
            int DocId = 0;
            string OnOffLine = "Online";
            string AllocateTo = "Searcher";

            Hashtable htorder = new Hashtable();
            htorder["Orderid"] = OrderId;
            htorder["ProductType"] = ProductType;
            htorder["TaskTemplateid"] = TaskProcessId;
            htorder["Docid"] = DocId;
            htorder["TaskAssignedId"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            htorder["TaskProcessid"] = TaskProcessId;
            htorder["OnOffLine"] = OnOffLine;
            htorder["AllocateTo"] = AllocateTo;
            htorder["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            returnvalue = new bllOST().InsertOrderTask(htorder);

            if (returnvalue > 0)
            {
                string Comment = "Order Allocated by User";
                returnvalue = new bllOST().InsertCommentOrder(OrderId, TaskProcessId, "Auto", Comment, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            }

            return returnvalue;
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
        public static string GetProjectProcess(string ProjectId)
        {
            DataTable dt1 = new bllOST().GetAllProcessOnProjectTemplate(Convert.ToInt32(ProjectId));
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
        public static string GetAllProcessOnProjectTemplate(string ProjectId)
        {
            DataTable dt1 = new bllOST().GetAllProcessOnProjectTemplate(Convert.ToInt32(ProjectId));
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
        public static string GetAllOrderbyProcessNew(int ProcessId, int UserId, string ProjectNumber, int prevProcessId, string ProductType, string OrderDate)
        {
            DataTable dt1 = new bllOST().GetAllProcesswiseOrderForAllocationNew(ProcessId, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), ProjectNumber, prevProcessId, ProductType, OrderDate);
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
        public static string OrderSummary(string ProjectNumber, int TaskProcessid, int UserId, int PrevProcessId)
        {
            DataTable dt1 = new bllOST().GetAllProcesswiseOrder_Summary(TaskProcessid, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), ProjectNumber, PrevProcessId);
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
        public static int OrderAllocation_ToUser(string OrderIDs, int ProjectID, int ProcessID, string ProductType)
        {
            string[] arr_OrderiDS = OrderIDs.Split(',');
            int ReturnValue = 0;

            DataTable dt = new bllOST().GetAllProcessOnProjectTemplate(ProjectID);
            int TemplateID = Convert.ToInt32(dt.Rows[0]["TemplateId"]);

            int DocId = 0; string Comment = "";
            int AssignTo = int.Parse(HttpContext.Current.User.Identity.Name);
            int AddedBy = int.Parse(HttpContext.Current.User.Identity.Name);
            string AllocateTo = new bllOST().GetUserTypeByEmployeeID(Convert.ToInt32(HttpContext.Current.User.Identity.Name.ToString()), "Searcher"); //ddlAllocateTo.SelectedValue.ToString();

            try
            {
                foreach (string orderId in arr_OrderiDS)
                {
                    string id = orderId.Trim();

                    #region Insert into Order Task

                    Hashtable htorder = new Hashtable();
                    htorder["Orderid"] = id;
                    htorder["ProductType"] = ProductType;
                    htorder["TaskTemplateid"] = TemplateID;
                    htorder["Docid"] = DocId;
                    htorder["TaskAssignedId"] = AssignTo;
                    htorder["TaskProcessid"] = ProcessID;
                    htorder["OnOffLine"] = "Online";
                    htorder["AllocateTo"] = AllocateTo;
                    htorder["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                    ReturnValue = new bllOST().InsertOrderTask(htorder);

                    if (ReturnValue <= 0)
                        Comment = "Order Exception" + ' ' + "Error occurred while allocating the order. Please Confirm Process Orders before orders process..!!";
                    else
                        Comment = "Order Allocated by User";

                    ReturnValue = new bllOST().InsertCommentOrder(Convert.ToInt32(id), 0, "Auto", Comment, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    #endregion
                }
            }
            catch (Exception ex)
            {
                ex.Message.ToString();
            }
            return ReturnValue;
        }
    }
}
