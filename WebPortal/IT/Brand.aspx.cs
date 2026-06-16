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
    public partial class Brand : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int InsertBrand(string BrandName)
        {
            int returnvalue = 0;
            Hashtable htparam = new Hashtable();
            htparam.Add("Brandname", BrandName);
            htparam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllAsset().InsertBrand(htparam);
            return returnvalue;
        }

        [WebMethod]
        public static int UpdateBrand(int BrandID, string BrandName)
        {
            int returnvalue = 0;
            returnvalue = new bllAsset().UpdateBrand(BrandName, BrandID, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            return returnvalue;
        }

        [WebMethod]
        public static string GetAllBrand()
        {
            DataTable dt1 = new bllAsset().GetAllBrand();
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