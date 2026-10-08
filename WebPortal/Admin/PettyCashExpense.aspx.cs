using System;
using System.Data;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Collections.Generic;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class PettyCashExpense : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
        private static long LoginId()
        {
            object v = System.Web.HttpContext.Current.Session["EmployeeID"];
            if (v == null || !long.TryParse(Convert.ToString(v), out long id)) throw new Exception("Session expired. Please login again.");
            return id;
        }
        private static string Json(DataTable dt)
        {
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow r in dt.Rows)
            {
                var d = new Dictionary<string, object>();
                foreach (DataColumn c in dt.Columns) d[c.ColumnName] = r[c] == DBNull.Value ? null : r[c];
                rows.Add(d);
            }
            return new JavaScriptSerializer().Serialize(rows);
        }

        [WebMethod(EnableSession = true)]
        public static string GetOpenRequests()
        {
            return Json(new bllMaster().GetExpenseOpenRequests(LoginId()));
        }


        [WebMethod(EnableSession = true)]
        public static string GetCategories()
        {
            return Json(new bllMaster().GetCategories(false));
        }

        [WebMethod(EnableSession = true)]
        public static string GetExpenses(long requestId)
        {
            return Json(new bllMaster().GetExpenses(requestId));
        }

        [WebMethod(EnableSession = true)]
        public static string SaveExpense(long requestId, string expenseDate, long categoryId, string vendorName, string invoiceNo, string description, decimal expenseAmount, decimal taxAmount, string paymentMode, string remark)
        {
            DateTime d; if (!DateTime.TryParse(expenseDate, out d)) throw new Exception("Invalid expense date."); if (requestId <= 0 || categoryId <= 0) throw new Exception("Request and Category are mandatory.");
            if (string.IsNullOrWhiteSpace(description)) throw new Exception("Description is mandatory."); if (expenseAmount <= 0 || taxAmount < 0) throw new Exception("Invalid amount.");
            return Json(new bllMaster().SaveExpense(requestId, d, categoryId, null, vendorName, invoiceNo, description.Trim(), expenseAmount, taxAmount, paymentMode, remark, LoginId()));
        }
    }
}
