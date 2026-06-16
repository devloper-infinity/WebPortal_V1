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
    public partial class AssetGroup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int InsertAssetGroup(string AssetGroupName)
        {
            int returnvalue = 0;
            Hashtable htparam = new Hashtable();
            htparam.Add("AssetGroupName", AssetGroupName);
            htparam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllAsset().InsertAssetGroup(htparam);
            return returnvalue;
        }


        [WebMethod]
        public static int UpdateAssetGroup(int AssetGroupID, string AssetGroupName)
        {
            int returnvalue = 0;
            Hashtable htparam = new Hashtable();
            htparam.Add("GroupId", AssetGroupID);
            htparam.Add("AssetGroupName", AssetGroupName);
            htparam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllAsset().UpdateAssetGroup(htparam);
            return returnvalue;
        }


        [WebMethod]
        public static int DeleteAssetGroup(int AssetGroupID, string AssetGroupName)
        {
            int returnvalue = 10;

            return returnvalue;
        }


        [WebMethod]
        public static string GetAllAssetGroups()
        {
            DataTable dt1 = new bllAsset().GetAllAssetGroup();
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