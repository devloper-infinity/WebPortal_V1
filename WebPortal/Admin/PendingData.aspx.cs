using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code;

namespace WebPortal.Admin
{
    public partial class PendingData : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated) Response.Redirect("~/Login.aspx", false);
            int employeeId;
            if (Int32.TryParse(User.Identity.Name, out employeeId) && (employeeId == 277 || employeeId == 6823))
            {
                Response.Redirect("~/Admin/ProjectBillingDetails.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
        }

        private static int EmployeeID()
        {
            int id;
            if (HttpContext.Current.User == null || !HttpContext.Current.User.Identity.IsAuthenticated ||
                !Int32.TryParse(HttpContext.Current.User.Identity.Name, out id))
                throw new HttpException(401, "Your session has expired. Please sign in again.");
            return id;
        }

        private static List<Dictionary<string, object>> Rows(DataTable table)
        {
            var result = new List<Dictionary<string, object>>();
            foreach (DataRow row in table.Rows)
            {
                var item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                    item[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
                result.Add(item);
            }
            return result;
        }

        [WebMethod(EnableSession = true)]
        public static object LoadPending()
        {
            var rows = Rows(new PendingDataRepository().GetPending(EmployeeID()));
            return new { rows = rows, count = rows.Count };
        }

        [WebMethod(EnableSession = true)]
        public static object SaveRemark(PendingRemarkInput input)
        {
            int employeeId = EmployeeID();
            new PendingDataRepository().AddRemark(employeeId, input);
            var rows = Rows(new PendingDataRepository().GetPending(employeeId));
            return new { message = "Remark saved. The item is now temporarily pending.", rows = rows, count = rows.Count };
        }

        [WebMethod(EnableSession = true)]
        public static object LoadHistory(int projectId, string orderNo)
        {
            return Rows(new PendingDataRepository().GetHistory(EmployeeID(), projectId, orderNo));
        }
    }
}
