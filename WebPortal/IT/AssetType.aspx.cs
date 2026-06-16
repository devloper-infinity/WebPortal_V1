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
    public partial class AssetType : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int InsertAssetType(int AssetGroupId, string AssetsTypeName, string Abbreviation)
        {
            int returnvalue = 0;
            Hashtable htparam = new Hashtable();
            htparam.Add("AssetGroupId", AssetGroupId);
            htparam.Add("AssetsTypeName", AssetsTypeName);
            htparam.Add("Abbreviation", Abbreviation);
            htparam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue =  new bllAsset().InsertAssetType(htparam);
            return returnvalue;
        }

        [WebMethod]
        public static int UpdateAssetType(int AssetsTypeId, string AssetsTypeName, string Abbreviation)
        {
            int returnvalue = 0;
            Hashtable htparam = new Hashtable();
            htparam.Add("AssetsTypeId", AssetsTypeId);
            htparam.Add("AssetsTypeName", AssetsTypeName);
            htparam.Add("IsAssetNo", true);
            htparam.Add("Abbreviation", Abbreviation);
            htparam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue =  new bllAsset().UpdateAssetType(htparam);
            return returnvalue;
        }

        [WebMethod]
        public static string GetAllAssetTypes()
        {
            DataTable dt1 = new bllAsset().GetAllAssetType();
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