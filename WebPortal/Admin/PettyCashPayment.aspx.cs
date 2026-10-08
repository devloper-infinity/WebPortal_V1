using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class PettyCashPayment : Page
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
        public static string GetApprovedRequests()
        {
            return Json(new bllMaster().GetApprovedRequests());
        }

        [WebMethod(EnableSession = true)]
        public static string GetEmployees()
        {
            return Json(new bllMaster().GetEmployees());
        }

        [WebMethod(EnableSession = true)]
        public static string GetPayments()
        {
            return Json(new bllMaster().GetPayments());
        }

        [WebMethod(EnableSession = true)]
        public static string IssuePayment(long requestId, string paymentDate, string paymentMode, string referenceNo, decimal amountPaid, long receiverId, string remark)
        {
            DateTime d;
            if (!DateTime.TryParse(paymentDate, out d)) throw new Exception("Invalid payment date."); if (requestId <= 0 || receiverId <= 0) throw new Exception("Request and Receiver are mandatory."); if (amountPaid <= 0) throw new Exception("Amount must be greater than zero."); if (paymentMode != "Cash" && string.IsNullOrWhiteSpace(referenceNo)) throw new Exception("Reference No is mandatory for non-cash payments."); return Json(new bllMaster().IssuePayment(requestId, d, paymentMode, referenceNo, amountPaid, LoginId(), receiverId, remark));
        }
    }
}
