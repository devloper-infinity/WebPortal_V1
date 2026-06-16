using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;


namespace WebPortal.Accounts
{
    public partial class USAssetMaster : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetUSEmployees()
        {
            DataTable dt = new bllUS().GetUSEmployees();

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
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

        [WebMethod]
        public static string GetAllUSAssets()
        {
            DataTable dt = new bllUS().GetAllUSAssets();

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
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


        [WebMethod]
        public static int InsertAssets(string UserName, string Brand, string SerialNo, string Status, string IssueDate, string Remark)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam["User"] = UserName;
            htParam["Brand"] = Brand;
            htParam["SerialNo"] = SerialNo;
            htParam["Status"] = Status;
            htParam["IssueDate"] = IssueDate;
            htParam["Remark"] = Remark;
            htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            ReturnValue = new bllUS().InsertUSAssets(htParam);

            return ReturnValue;
        }
    }
}