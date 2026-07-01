using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class MyQueue : Page
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
        }

        [WebMethod]
        public static string GetStartedLoans()
        {
            int employeeId = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DataTable dt = new bllUS().GetUSLoanProductionMyQueue(employeeId);
            return SerializeRows(dt);
        }

        private static string SerializeRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table != null)
            {
                foreach (DataRow dr in table.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn col in table.Columns)
                    {
                        row.Add(col.ColumnName, dr[col] == DBNull.Value ? string.Empty : dr[col]);
                    }
                    rows.Add(row);
                }
            }

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }
    }
}
