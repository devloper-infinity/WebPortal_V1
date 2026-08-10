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
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Search
{
    public partial class ProjectTrackingReport : System.Web.UI.Page
    {
        public static string path;
        static string NewFileName = "";
        static string FileName = "";
        static string GUIDFile = "";
        static string FolderPath = "";
        static int AddedBy;


        protected void Page_Load(object sender, EventArgs e)
        {
            AddedBy = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

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
        public static string GetCommentData(int OrderID)
        {
            EnsureCommentPermission();
            ValidateCommentOrder(OrderID);

            DataTable orderDetails = GetCommentOrderDetails(OrderID);
            DataRow order = orderDetails != null && orderDetails.Rows.Count > 0 ? orderDetails.Rows[0] : null;

            Dictionary<string, object> response = new Dictionary<string, object>();
            response["OrderID"] = OrderID;
            response["OrderNo"] = DbString(order, "ClientOrderNo", "OrderNo");
            response["OrderDate"] = DbString(order, "OrderDateTime", "OrderDate");
            response["Comments"] = DataTableToRows(GetOrderComments(OrderID));
            return SerializeJson(response);
        }

        [WebMethod]
        public static string SaveComment(int OrderID, string Comment)
        {
            EnsureCommentPermission();
            ValidateCommentOrder(OrderID);

            string comment = (Comment ?? string.Empty).Trim();
            if (comment.Length == 0)
            {
                throw new ArgumentException("Please enter a comment.");
            }

            if (comment.Length > 10000)
            {
                throw new ArgumentException("Comment cannot exceed 10000 characters.");
            }

            int result = new bllOST().InsertCommentOrder(OrderID, 0, "Manual", comment, AddedBy);

            if (result <= 0)
            {
                throw new InvalidOperationException("Comment was not saved. Please try again.");
            }

            return SerializeJson(DataTableToRows(GetOrderComments(OrderID)));
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

        [WebMethod]
        public static string GetChangeOrderStatusInfo(int OrderID)
        {
            Dictionary<string, object> response = new Dictionary<string, object>();

            try
            {
                bllOST ost = new bllOST();
                DataTable dt = ost.GetOrderByID(OrderID);

                if (dt == null || dt.Rows.Count == 0)
                {
                    response["Success"] = false;
                    response["Message"] = "Order details were not found.";
                    response["Statuses"] = new List<Dictionary<string, string>>();
                    response["Users"] = new List<Dictionary<string, object>>();
                    return SerializeJson(response);
                }

                DataRow order = dt.Rows[0];
                int taskStatus = DbInt(order, "TaskStatus");
                string processStatus = DbString(order, "ProcessStatus");

                response["Success"] = true;
                response["OrderID"] = OrderID;
                response["ProjectNumber"] = DbString(order, "ProjectNumber");
                response["OrderNumber"] = DbString(order, "ClientOrderNo", "OrderNo");
                response["TaskStatus"] = taskStatus;
                response["ProcessStatus"] = processStatus;
                response["TaskProcessId"] = DbInt(order, "TaskProcessid", "TaskProcessId");
                response["ProductType"] = DbString(order, "ProductType");
                response["Statuses"] = BuildChangeOrderStatuses(taskStatus, processStatus);
                response["Users"] = BuildChangeStatusUsers(ost);
            }
            catch (Exception ex)
            {
                response["Success"] = false;
                response["Message"] = ex.Message;
                response["Statuses"] = new List<Dictionary<string, string>>();
                response["Users"] = new List<Dictionary<string, object>>();
            }

            return SerializeJson(response);
        }

        [WebMethod]
        public static string ChangeOrderStatus(int OrderID, string StatusAction, int ReallocateTo, string Remark, string CancelDecision, string CancelType)
        {
            Dictionary<string, object> response = new Dictionary<string, object>();
            response["Success"] = false;
            response["ReturnValue"] = 0;

            try
            {
                if (OrderID <= 0)
                {
                    response["Message"] = "Order is not selected.";
                    return SerializeJson(response);
                }

                if (string.IsNullOrWhiteSpace(StatusAction))
                {
                    response["Message"] = "Please select change order status.";
                    return SerializeJson(response);
                }

                bllOST ost = new bllOST();
                DataTable dt = ost.GetOrderByID(OrderID);

                if (dt == null || dt.Rows.Count == 0)
                {
                    response["Message"] = "Order details were not found.";
                    return SerializeJson(response);
                }

                DataRow order = dt.Rows[0];
                int addedBy = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
                int returnValue = 0;
                string message = string.Empty;

                switch (StatusAction)
                {
                    case "Re-Allocate Order":
                        if (ReallocateTo <= 0)
                        {
                            response["Message"] = "Please select user.";
                            return SerializeJson(response);
                        }

                        returnValue = ReAllocateOrder(ost, order, addedBy, ReallocateTo, Remark);
                        message = "Order reallocated successfully.";
                        break;

                    case "Reset Order":
                        returnValue = ResetOrder(ost, OrderID, addedBy, Remark);
                        message = "Order reset successfully.";
                        break;

                    case "Cancel Order":
                        returnValue = CancelOrder(ost, OrderID, addedBy, Remark, CancelDecision, CancelType);
                        message = string.Equals(CancelDecision, "Reject", StringComparison.OrdinalIgnoreCase)
                            ? "Cancel order request rejected successfully."
                            : "Order cancelled successfully.";
                        break;

                    case "Re-Open Hold Order":
                        returnValue = ReOpenHoldOrder(ost, order, addedBy, Remark);
                        message = "Order re-opened successfully.";
                        break;

                    case "Hold Order":
                        returnValue = HoldOrder(ost, OrderID, addedBy, Remark);
                        message = "Order held successfully.";
                        break;

                    default:
                        response["Message"] = "Selected status is not valid.";
                        return SerializeJson(response);
                }

                response["ReturnValue"] = returnValue;
                response["Success"] = returnValue > 0;
                response["Message"] = returnValue > 0 ? message : "Order status was not changed.";
            }
            catch (Exception ex)
            {
                response["Message"] = ex.Message;
            }

            return SerializeJson(response);
        }

        private static int ReAllocateOrder(bllOST ost, DataRow order, int addedBy, int assignTo, string remark)
        {
            int orderId = DbInt(order, "OrderID", "OrderId");
            int processId = DbInt(order, "TaskProcessid", "TaskProcessId");
            string project = DbString(order, "ProjectNumber");
            string product = DbString(order, "ProductType");
            int templateId = GetOrderTemplateId(ost, addedBy, project);

            Hashtable htparam = new Hashtable();
            htparam["OrderID"] = orderId;
            htparam["Remark"] = remark;
            htparam["TaskProcessid"] = processId;
            htparam["AddedBy"] = addedBy;

            int returnValue = ost.InsertReAllocation(htparam);

            if (returnValue > 0)
            {
                DataTable docs = ost.GetAllDocAndProductRelatedToProject(project, product);
                if (docs != null)
                {
                    foreach (DataRow doc in docs.Rows)
                    {
                        int docId = DbInt(doc, "ID", "DocID", "DocumentsID");
                        if (docId <= 0)
                        {
                            continue;
                        }

                        Hashtable htorder = new Hashtable();
                        htorder["Orderid"] = orderId;
                        htorder["ProductType"] = product;
                        htorder["TaskTemplateid"] = templateId;
                        htorder["TaskProcessid"] = processId;
                        htorder["OnOffLine"] = "Online";
                        htorder["Docid"] = docId;
                        htorder["TaskAssignedId"] = assignTo;
                        htorder["AllocateTo"] = "Searcher";
                        htorder["AddedBy"] = addedBy;

                        int taskId = ost.InsertOrderTask(htorder);
                        if (taskId > 0)
                        {
                            ost.UpdateTaskRemark(taskId, remark);
                        }
                    }
                }

                ost.InsertCommentOrder(orderId, 0, "Auto", "Order Re-Allocated:" + remark, addedBy);
            }

            return returnValue;
        }

        private static int ResetOrder(bllOST ost, int orderId, int addedBy, string remark)
        {
            Hashtable htparam = new Hashtable();
            htparam["OrderID"] = orderId;
            htparam["Remark"] = remark;

            int returnValue = ost.ResetOrder(htparam);
            if (returnValue > 0)
            {
                ost.InsertCommentOrder(orderId, 0, "Auto", "Order Reset:" + remark, addedBy);
            }

            return returnValue;
        }

        private static int CancelOrder(bllOST ost, int orderId, int addedBy, string remark, string cancelDecision, string cancelType)
        {
            string status = string.Equals(cancelDecision, "Reject", StringComparison.OrdinalIgnoreCase) ? "Reject" : "Approve";
            List<string> reasonParts = new List<string>();
            reasonParts.Add(Convert.ToString(addedBy));

            if (status == "Approve" && !string.IsNullOrWhiteSpace(cancelType))
            {
                reasonParts.Add(cancelType.Trim());
            }

            if (!string.IsNullOrWhiteSpace(remark))
            {
                reasonParts.Add(remark.Trim());
            }

            Hashtable htparam = new Hashtable();
            htparam["OrderID"] = orderId;
            htparam["Status"] = status;
            htparam["Reason"] = string.Join(",", reasonParts.ToArray());

            int returnValue = ost.CancelOrder(htparam);
            if (returnValue > 0)
            {
                string comment = status == "Approve" ? "Order is Cancelled by PM" : "Cancel Order Request Rejected by PM";
                ost.InsertCommentOrder(orderId, 0, "Auto", comment, addedBy);
            }

            return returnValue;
        }

        private static int ReOpenHoldOrder(bllOST ost, DataRow order, int addedBy, string remark)
        {
            int orderId = DbInt(order, "OrderID", "OrderId");
            int processId = DbInt(order, "TaskProcessid", "TaskProcessId");

            Hashtable htparam = new Hashtable();
            htparam["OrderID"] = orderId;
            htparam["ProcessID"] = processId;
            htparam["Remark"] = remark;

            int returnValue = ost.ReOpenHoldOrder(htparam);
            if (returnValue > 0)
            {
                ost.InsertCommentOrder(orderId, 0, "Auto", "Order Re-Open:" + remark, addedBy);
            }

            return returnValue;
        }

        private static int HoldOrder(bllOST ost, int orderId, int addedBy, string remark)
        {
            Hashtable htparam = new Hashtable();
            htparam["OrderID"] = orderId;
            htparam["Status"] = "Hold";
            htparam["Reason"] = remark;

            int returnValue = ost.HoldOrder(htparam);
            if (returnValue > 0)
            {
                ost.InsertCommentOrder(orderId, 0, "Auto", "Order Hold:" + remark, addedBy);
            }

            return returnValue;
        }

        private static int GetOrderTemplateId(bllOST ost, int userId, string projectNumber)
        {
            int projectId = 0;
            DataTable projects = ost.GetAllProject(userId);

            if (projects != null)
            {
                foreach (DataRow project in projects.Rows)
                {
                    if (string.Equals(DbString(project, "ProjectName"), projectNumber, StringComparison.OrdinalIgnoreCase))
                    {
                        projectId = DbInt(project, "ProjectID", "ProjectId", "ID");
                        break;
                    }
                }
            }

            if (projectId <= 0)
            {
                return 0;
            }

            DataTable templates = ost.GetAllProcessOnProjectTemplate(projectId);
            return templates != null && templates.Rows.Count > 0 ? DbInt(templates.Rows[0], "TemplateId", "TemplateID") : 0;
        }

        private static List<Dictionary<string, string>> BuildChangeOrderStatuses(int taskStatus, string processStatus)
        {
            List<Dictionary<string, string>> statuses = new List<Dictionary<string, string>>();
            bool isHold = string.Equals(processStatus, "Hold", StringComparison.OrdinalIgnoreCase);
            bool isCancel = string.Equals(processStatus, "Cancel", StringComparison.OrdinalIgnoreCase);

            if (taskStatus == 1)
            {
                AddChangeOrderStatus(statuses, "Re-Allocate Order");
            }

            if (taskStatus == 1 && isHold)
            {
                AddChangeOrderStatus(statuses, "Cancel Order");
                AddChangeOrderStatus(statuses, "Re-Open Hold Order");
            }

            if ((taskStatus == 1 || taskStatus == 2) && !isHold)
            {
                AddChangeOrderStatus(statuses, "Hold Order");
                AddChangeOrderStatus(statuses, "Cancel Order");
            }

            if (taskStatus == 0 && isHold)
            {
                AddChangeOrderStatus(statuses, "Re-Open Hold Order");
            }

            if (taskStatus != 0)
            {
                AddChangeOrderStatus(statuses, "Reset Order");
            }

            if (taskStatus == 5 && !isCancel)
            {
                AddChangeOrderStatus(statuses, "Cancel Order");
            }

            if (taskStatus == 4 && isHold)
            {
                AddChangeOrderStatus(statuses, "Re-Open Hold Order");
            }
            else if (taskStatus == 0)
            {
                AddChangeOrderStatus(statuses, "Cancel Order");
                AddChangeOrderStatus(statuses, "Hold Order");
            }

            return statuses;
        }

        private static void AddChangeOrderStatus(List<Dictionary<string, string>> statuses, string value)
        {
            if (statuses.Any(status => status["Value"] == value))
            {
                return;
            }

            Dictionary<string, string> item = new Dictionary<string, string>();
            item["Value"] = value;
            item["Text"] = value;
            statuses.Add(item);
        }

        private static List<Dictionary<string, object>> BuildChangeStatusUsers(bllOST ost)
        {
            List<Dictionary<string, object>> users = new List<Dictionary<string, object>>();
            AddChangeStatusUsers(users, ost.GetUsersOnUserType("Searcher"));
            AddChangeStatusUsers(users, ost.GetUsersOnUserType("Vendor"));
            return users;
        }

        private static void AddChangeStatusUsers(List<Dictionary<string, object>> users, DataTable dt)
        {
            if (dt == null)
            {
                return;
            }

            foreach (DataRow row in dt.Rows)
            {
                int employeeId = DbInt(row, "EmployeeID", "EmployeeId");
                if (employeeId <= 0 || users.Any(user => Convert.ToInt32(user["EmployeeID"]) == employeeId))
                {
                    continue;
                }

                string displayName = (DbString(row, "Code") + " : " + DbString(row, "FirstName") + " " + DbString(row, "MiddleName") + " " + DbString(row, "lastName", "LastName")).Trim();
                Dictionary<string, object> userItem = new Dictionary<string, object>();
                userItem["EmployeeID"] = employeeId;
                userItem["DisplayName"] = displayName;
                users.Add(userItem);
            }
        }

        private static string DbString(DataRow row, params string[] columns)
        {
            object value = DbValue(row, columns);
            return value == null || value == DBNull.Value ? string.Empty : Convert.ToString(value);
        }

        private static int DbInt(DataRow row, params string[] columns)
        {
            int value = 0;
            int.TryParse(DbString(row, columns), out value);
            return value;
        }

        private static object DbValue(DataRow row, params string[] columns)
        {
            if (row == null || row.Table == null)
            {
                return null;
            }

            foreach (string column in columns)
            {
                foreach (DataColumn existingColumn in row.Table.Columns)
                {
                    if (string.Equals(existingColumn.ColumnName, column, StringComparison.OrdinalIgnoreCase))
                    {
                        return row[existingColumn];
                    }
                }
            }

            return null;
        }

        private static string SerializeJson(object value)
        {
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(value);
        }

        private static DataTable GetOrderComments(int orderId)
        {
            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetAllCommentOrderwise");
            SQLHelper.AddParamToSQLCmd(command, "@OrderID", SqlDbType.BigInt, 0, ParameterDirection.Input, orderId);
            return SQLHelper.ExecuteDataTableCmd(command);
        }

        private static DataTable GetCommentOrderDetails(int orderId)
        {
            SqlCommand command = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllDetailsByOrderNo");
            SQLHelper.AddParamToSQLCmd(command, "@OrderNo", SqlDbType.NVarChar, 1000, ParameterDirection.Input, orderId.ToString());
            return SQLHelper.ExecuteDataTableCmd(command);
        }

        private static List<Dictionary<string, object>> DataTableToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null)
            {
                return rows;
            }

            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                {
                    row[column.ColumnName] = dataRow[column];
                }
                rows.Add(row);
            }
            return rows;
        }

        private static void EnsureCommentPermission()
        {
            int employeeId = AddedBy;
            if (employeeId != 369 && employeeId != 375)
            {
                throw new HttpException(403, "You do not have permission to manage order comments.");
            }
        }

        private static void ValidateCommentOrder(int orderId)
        {
            if (orderId <= 0)
            {
                throw new ArgumentException("Please select a valid order.");
            }
        }
    }
}
