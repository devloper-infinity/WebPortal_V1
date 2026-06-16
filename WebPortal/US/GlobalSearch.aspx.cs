using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class GlobalSearch : System.Web.UI.Page
    {
        static DataSet ds = null;
        static DataTable dtOrders = null;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string getLoansForGlobalSearch()
        {
            ds = new bllUS().getLoansForGlobalSearch(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (ds != null)
            {
                dtOrders = ds.Tables[0];
                foreach (DataRow dr in dtOrders.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dtOrders.Columns)
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
    }
}