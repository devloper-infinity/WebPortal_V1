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
using WebPortal.App_Code.Class;

namespace WebPortal.Admin
{
    public partial class DropoutEmployeeReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            hdnEmpID.Value   = Convert.ToString(EmployeeInfo.Current.EmployeeID);
        }

        [WebMethod]
        public static string BindGrid()
        {
            DataTable dt1 = new bllMaster().GetDropoutEmployeeDetails("", "");
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
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