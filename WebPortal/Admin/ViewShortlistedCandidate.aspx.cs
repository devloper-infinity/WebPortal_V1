using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class ViewShortlistedCandidate : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetCandidates()
        {
            if (HttpContext.Current.User == null || HttpContext.Current.User.Identity == null || !HttpContext.Current.User.Identity.IsAuthenticated)
                throw new HttpException(401, "Your session has expired. Please sign in again.");

            int employeeId;
            if (!int.TryParse(HttpContext.Current.User.Identity.Name, out employeeId))
                throw new HttpException(403, "The signed-in user is not valid.");

            DataTable table = new bllMaster().getViewShortlistedCandidate(employeeId);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null)
                return rows;

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
