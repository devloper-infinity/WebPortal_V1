using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Accounts
{
    public partial class ProfileApproval : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetPendingProfiles()
        {
            int employeeId;
            if (!int.TryParse(HttpContext.Current.User.Identity.Name, out employeeId))
                throw new InvalidOperationException("Your signed-in employee identity is invalid.");
            return ToRows(new bllMaster().GetAllEmployeeDetailsForApproved(employeeId));
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            var rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow dataRow in table.Rows)
            {
                var row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in table.Columns)
                {
                    object value = dataRow[column];
                    row[column.ColumnName] = value == DBNull.Value ? null : value is DateTime ? ((DateTime)value).ToString("dd-MMM-yyyy") : value;
                }
                rows.Add(row);
            }
            return rows;
        }
    }
}
