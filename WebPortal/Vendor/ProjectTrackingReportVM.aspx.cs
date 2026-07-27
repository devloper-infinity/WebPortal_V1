using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Vendor
{
    public partial class ProjectTrackingReportVM : System.Web.UI.Page
    {
        protected int CurrentUserId
        {
            get { return Convert.ToInt32(HttpContext.Current.User.Identity.Name); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // No server controls or DevExpress binding is required.
            // All data is loaded through static WebMethods and jQuery AJAX.
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetCurrentUserAccess()
        {
            int employeeId = GetCurrentUserId();
            return new { IsPM = new bllVendors().CheckIfPMVM(employeeId) == 1 };
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetOrders(string fromDate, string toDate, string projectId, bool showAll)
        {
            DateTime from = ParseDate(fromDate);
            DateTime to = ParseDate(toDate);
            int userId = GetCurrentUserId();
            bllVendors ost = new bllVendors();
            bool isPM = ost.CheckIfPMVM(userId) == 1;
            DataTable dt;

            if (showAll && isPM)
            {
                dt = new bllVendors().GetAllInfinityOrderTraking_VM(
                    from.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                    to.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                    projectId);
            }
            else
            {
                Hashtable parameters = new Hashtable();
                parameters["FromDate"] = from.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                parameters["ToDate"] = to.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                parameters["ProjectNumber"] = projectId;
                parameters["UserId"] = userId;
                dt = ost.GetMyOrders_VM(parameters);
            }

            AddTaskAssignedId(dt, ost);
            return ToRows(dt);
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetOrderDetail(int orderId, string detailType)
        {
            bllVendors ost = new bllVendors();
            DataTable dt;

            switch ((detailType ?? string.Empty).Trim().ToLowerInvariant())
            {
                case "attachments": dt = ost.GetOrderDetailsProcesswise(orderId); break;
                case "checklist": dt = ost.BindOrderCheckList(orderId); break;
                case "history": dt = ost.GetAllOrderHistory(orderId); break;
                case "costing": dt = ost.GetAllorderCosing(orderId); break;
                case "feedback": dt = ost.BindOrderFeedback(orderId); break;
                case "tax": dt = ost.BindTaxDetails(orderId); break;
                default: throw new ArgumentException("Invalid detail type.");
            }

            return ToRows(dt);
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetCommentPopupData(int orderId)
        {
            bllVendors ost = new bllVendors();
            DataTable order = ost.GetOrderByID_VM(orderId);
            DataTable comments = ost.GetAllCommentOrderwise_VM(orderId);

            string orderNo = string.Empty;
            string vm = string.Empty;
            string abstractor = string.Empty;

            if (order.Rows.Count > 0)
            {
                orderNo = Convert.ToString(order.Rows[0]["ClientOrderNo"]);
                vm = Convert.ToString(order.Rows[0]["VM"]);
                abstractor = Convert.ToString(order.Rows[0]["Abstractor"]);
            }

            return new
            {
                OrderNo = orderNo,
                VM = vm,
                Abstractor = abstractor,
                Comments = ToRows(comments)
            };
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> SaveComment(int orderId, string type, string comment)
        {
            if (string.IsNullOrWhiteSpace(comment))
                throw new ArgumentException("Comment is required.");

            int addedBy = GetCurrentUserId();
            Hashtable htComment = new Hashtable();
            htComment["OrderId"] = orderId;
            htComment["Type"] = type;
            htComment["Comment"] = comment.Trim();
            htComment["AddedBy"] = addedBy;
            int ReturnValue = new bllVendors().InsertFollowUp(htComment);
            return ToRows(new bllVendors().GetAllCommentOrderwise_VM(orderId));
        }

        private static void AddTaskAssignedId(DataTable dt, bllVendors ost)
        {
            if (dt == null) return;
            if (!dt.Columns.Contains("TaskAssignedId"))
                dt.Columns.Add("TaskAssignedId", typeof(int));

            foreach (DataRow row in dt.Rows)
            {
                int orderId;
                if (!TryGetOrderId(row, out orderId)) continue;

                DataTable currentUser = ost.GetUserofCurrentProcess(orderId);
                if (currentUser.Rows.Count > 0 && currentUser.Columns.Contains("TaskAssignedId"))
                    row["TaskAssignedId"] = Convert.ToInt32(currentUser.Rows[0]["TaskAssignedId"]);
            }
        }

        private static bool TryGetOrderId(DataRow row, out int orderId)
        {
            orderId = 0;
            string[] names = { "OrderId", "OrderID", "TaskId" };
            foreach (string name in names)
            {
                if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value &&
                    int.TryParse(Convert.ToString(row[name]), out orderId))
                    return true;
            }
            return false;
        }

        private static DateTime ParseDate(string value)
        {
            DateTime result;
            string[] formats = { "dd-MMM-yyyy", "dd/MM/yyyy", "MM/dd/yyyy", "yyyy-MM-dd" };
            if (!DateTime.TryParseExact(value, formats, CultureInfo.InvariantCulture,
                DateTimeStyles.AllowWhiteSpaces, out result))
                throw new ArgumentException("Please enter a valid date in dd-MMM-yyyy format.");
            return result;
        }

        private static int GetCurrentUserId()
        {
            return Convert.ToInt32(HttpContext.Current.User.Identity.Name);
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;

            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                    row[column.ColumnName] = dataRow[column] == DBNull.Value ? null : dataRow[column];
                rows.Add(row);
            }
            return rows;
        }
    }
}