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
    public partial class PettyCashApproval : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
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
        [WebMethod(EnableSession = true)] public static string GetApprovalRequests(string status) { return Json(new bllMaster().GetApprovalRequests(status)); }

        [WebMethod(EnableSession = true)]
        public static string ActionRequest(long requestId, string action, decimal? approvedAmount, string remark)
        {
            if (requestId <= 0) throw new InvalidOperationException("Invalid request.");
            int approverId;
            if (System.Web.HttpContext.Current == null || System.Web.HttpContext.Current.User == null ||
                !int.TryParse(System.Web.HttpContext.Current.User.Identity.Name, out approverId) || approverId <= 0)
                throw new InvalidOperationException("Your login session has expired. Please sign in again.");
            return Json(new bllMaster().ActionRequest(requestId, action, approverId, approvedAmount, remark));
        }
    }
}
