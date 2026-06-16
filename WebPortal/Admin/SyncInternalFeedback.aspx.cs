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

namespace WebPortal.Admin
{
    public partial class SyncInternalFeedback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string SyncInternalFeedbacks(string FromDate, string ToDate, string Subdomain)
        {
            DataTable dt1 = new bllMaster().SyncInternalFeedbacks(FromDate, ToDate, Subdomain);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static int InsertSyncedInternalFeedbacks(string FromDate, string ToDate, string Subdomain)
        {
            int returnvalue = 0;
            returnvalue = new bllMaster().InsertSyncedInternalFeedbacks(FromDate, ToDate, Subdomain);
            return returnvalue;
        }
    }
}