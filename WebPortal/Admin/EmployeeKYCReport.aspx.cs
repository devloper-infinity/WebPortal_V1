using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class EmployeeKYCReport : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static List<Dictionary<string, object>> GetReport()
        {
            DataTable table = new bllMaster().GetAllEmployeeKYC();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow source in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                    row[column.ColumnName] = source[column] == DBNull.Value ? "" :
                        source[column] is DateTime ? ((DateTime)source[column]).ToString("dd-MMM-yyyy") : source[column];
                rows.Add(row);
            }
            return rows;
        }
    }
}
