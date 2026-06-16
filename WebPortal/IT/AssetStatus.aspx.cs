using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.IT
{
    public partial class AssetStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int InsertAssetStatus(string AssetStatus)
        {
            int ReturnValue = 0;

            Hashtable htparam = new Hashtable();
            htparam["AssetStatus"] = AssetStatus;
            htparam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            ReturnValue = new bllAsset().InsertAssetStatus(htparam);

            return ReturnValue;
        }

        [WebMethod]
        public static int UpdateAssetStatus(int StatusID, string AssetStatus)
        {
            int ReturnValue = 0;

            Hashtable htparam = new Hashtable();
            htparam["StatusId"] = StatusID;
            htparam["AssetStatus"] = AssetStatus;
            htparam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            ReturnValue = new bllAsset().UpdateAssetStatus(htparam);

            return ReturnValue;
        }

        [WebMethod]
        public static string GetAllAssetStatus()
        {
            DataTable dt1 = new bllAsset().GetAllAssetStatus();
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
    }
}