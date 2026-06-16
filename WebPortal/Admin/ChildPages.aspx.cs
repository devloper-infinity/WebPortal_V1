using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.DynamicData;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class ChildPages : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public class MenuModel
        {
            public string MenuName { get; set; }
            public int ParentMenuId { get; set; }
            public string Url { get; set; }
            public string SectionName { get; set; }
            public int SortOrder { get; set; }
        }

        [WebMethod]
        public static List<object> GetParentMenus()
        {
            DataTable dt = new bllMaster().GetAllMasters();

            List<object> list = new List<object>();

            foreach (DataRow dr in dt.Rows)
            {
                list.Add(new
                {
                    MenuId = dr["MenuId"],
                    MenuName = dr["MenuName"]
                });
            }

            return list;
        }

        [WebMethod]
        public static void InsertMenu(MenuModel menu)
        {
            new bllMaster().InsertMenu(menu);
        }
    }
}