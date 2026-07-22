using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal
{
    public partial class MenuService : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<MenuItem> LoadMenu()
        {
            int userId = Convert.ToInt32(
                HttpContext.Current.User.Identity.Name.ToString()
            );

            // Load all menus for complete parent-child hierarchy
            DataTable dtAll = new bllMaster().GetAllMenus();

            List<MenuItem> allMenus = dtAll.AsEnumerable()
                .Select(r => new MenuItem
                {
                    MenuId = r.Field<int>("MenuId"),
                    MenuName = r.Field<string>("MenuName"),
                    ParentMenuId = r.Field<int>("ParentMenuId"),
                    Url = r.Field<string>("Url"),
                    SectionName = r.Field<string>("SectionName"),
                    SortOrder = r.Field<int>("SortOrder"),
                    Children = new List<MenuItem>()
                })
                .ToList();

            // Load user-specific menus and dynamic URLs
            DataTable dtRights = new bllMaster()
                .GetMenuForUserFromGroup(userId);

            List<int> allowed = dtRights.AsEnumerable()
                .Select(r => r.Field<int>("MenuId"))
                .ToList();

            // Replace default URL with user-specific URL returned by procedure
            Dictionary<int, string> userMenuUrls = dtRights.AsEnumerable()
                .Where(r => !r.IsNull("Url"))
                .GroupBy(r => r.Field<int>("MenuId"))
                .ToDictionary(
                    g => g.Key,
                    g => g.First().Field<string>("Url")
                );

            foreach (MenuItem menu in allMenus)
            {
                string userSpecificUrl;

                if (userMenuUrls.TryGetValue(
                    menu.MenuId,
                    out userSpecificUrl))
                {
                    menu.Url = userSpecificUrl;
                }
            }

            // Build complete tree
            var fullTree = BuildTree(allMenus, 0);

            // Filter tree based on user rights
            return FilterTree(fullTree, allowed);
        }
        public static List<MenuItem> LoadMenu_OLD()
        {
            int userId = Convert.ToInt32(HttpContext.Current.User.Identity.Name.ToString());

            // ✅ Load ALL menu items
            DataTable dtAll = new bllMaster().GetAllMenus();
            List<MenuItem> allMenus = dtAll.AsEnumerable().Select(r => new MenuItem
            {
                MenuId = r.Field<int>("MenuId"),
                MenuName = r.Field<string>("MenuName"),
                ParentMenuId = r.Field<int>("ParentMenuId"),
                Url = r.Field<string>("Url"),
                SectionName = r.Field<string>("SectionName"),
                SortOrder = r.Field<int>("SortOrder"),
                Children = new List<MenuItem>()
            }).ToList();

            // ✅ Load rights
            //DataTable dtRights = new bllMaster().GetMenuForUser(userId);
            DataTable dtRights = new bllMaster().GetMenuForUserFromGroup(userId);
            List<int> allowed = dtRights.AsEnumerable()
                                        .Select(r => r.Field<int>("MenuId"))
                                        .ToList();

            // ✅ Build complete tree
            var fullTree = BuildTree(allMenus, 0);

            // ✅ Filter tree
            return FilterTree(fullTree, allowed);
        }

        private static List<MenuItem> FilterTree(List<MenuItem> list, List<int> allowed)
        {
            List<MenuItem> result = new List<MenuItem>();

            foreach (var item in list)
            {
                // recursively filter children first
                item.Children = FilterTree(item.Children, allowed);

                // include if:
                if (allowed.Contains(item.MenuId) || item.Children.Count > 0)
                {
                    result.Add(item);
                }
            }
            return result;
        }


        [WebMethod]
        public static string LoadMenu1()
        {
            int userId = Convert.ToInt32(HttpContext.Current.User.Identity.Name.ToString());

            DataTable dt1 = new bllMaster().GetMenuForUser(userId);

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

        public class MenuItem
        {
            public int MenuId { get; set; }
            public string MenuName { get; set; }
            public int ParentMenuId { get; set; }
            public string Url { get; set; }
            public string SectionName { get; set; }
            public int SortOrder { get; set; }
            public System.Collections.Generic.List<MenuItem> Children { get; set; }
                = new System.Collections.Generic.List<MenuItem>();
        }

        private static System.Collections.Generic.List<MenuItem> BuildTree(
            System.Collections.Generic.List<MenuItem> list, int parent)
        {
            return list.Where(x => x.ParentMenuId == parent)
                       .OrderBy(x => x.SortOrder)
                       .Select(x => new MenuItem
                       {
                           MenuId = x.MenuId,
                           MenuName = x.MenuName,
                           ParentMenuId = x.ParentMenuId,
                           Url = x.Url,
                           SectionName = x.SectionName,
                           SortOrder = x.SortOrder,
                           Children = BuildTree(list, x.MenuId)
                       }).ToList();
        }
    }
}