using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class PageAllocation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
                LoadMenuStructure();
            }
        }
        void LoadUsers()
        {
            // Your user table here
            DataTable dt = new bllMaster().GetAllUsers();
            lstUsers.DataSource = dt;
            lstUsers.DataTextField = "FullName";
            lstUsers.DataValueField = "EmployeeID";
            lstUsers.DataBind();
        }

        void LoadMenuStructure()
        {
            DataTable dt = new bllMaster().GetAllMenus();

            List<MenuItem> menus = dt.AsEnumerable().Select(r => new MenuItem
            {
                MenuId = r.Field<int>("MenuId"),
                MenuName = r.Field<string>("MenuName"),
                ParentMenuId = r.Field<int>("ParentMenuId"),
                Url = r.Field<string>("Url"),
                SectionName = r.Field<string>("SectionName"),
                SortOrder = r.Field<int>("SortOrder"),
            }).ToList();

            var tree = BuildTree(menus, 0);

            // ✅ GROUP BY SECTION
            var result = tree.Select(m => new MenuWrapper
            {
                MenuId = m.MenuId,
                MenuName = m.MenuName,

                Sections = m.Children
    .GroupBy(x => x.Children.Any() ? x.MenuName            // 3-level (HR Access)
                                   : (x.SectionName ?? "General")) // 2-level (Quick Links)
    .Select(g => new SectionGroup
    {
        SectionName = g.Key,

        Items = g.SelectMany(sec => sec.Children.Any()     // if section has children → use them
                              ? sec.Children               // HR Access
                              : new List<MenuItem> { sec } // Quick Links (self is item)
                     ).ToList()
    }).ToList()

            }).ToList();

            rptMenus.DataSource = result;
            rptMenus.DataBind();
        }

        protected void lstUsers_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadUserRights(Convert.ToInt32(lstUsers.SelectedValue));
        }

        void LoadUserRights(int userId)
        {
            DataTable dt = new bllMaster().GetMenuForUser(userId);
            var rights = dt.AsEnumerable().Select(r => r.Field<int>("MenuId")).ToList();

            foreach (RepeaterItem card in rptMenus.Items)
            {
                Repeater rptSub = (Repeater)card.FindControl("rptSub");

                foreach (RepeaterItem sec in rptSub.Items)
                {
                    Repeater rptItems = (Repeater)sec.FindControl("rptItems");

                    foreach (RepeaterItem item in rptItems.Items)
                    {
                        var chk = (CheckBox)item.FindControl("chkRight");
                        var hid = (HiddenField)item.FindControl("hfMenuId");

                        if (chk != null && hid != null)
                        {
                            int menuId = Convert.ToInt32(hid.Value);
                            chk.Checked = rights.Contains(menuId);
                        }
                    }
                }
            }
        }


        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (lstUsers.SelectedValue == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "saved",
                "alert('Please select user');", true);
                return;
            }
            int userId = Convert.ToInt32(lstUsers.SelectedValue);

            // Remove existing
            new bllMaster().DeleteRights(userId);

            // Insert new
            foreach (string id in Request.Form.GetValues("rights"))
            {
                new bllMaster().InsertRights(userId, Convert.ToInt32(id));
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "saved",
                "alert('Rights Updated Successfully');", true);
        }

        // Build hierarchy
        private static List<MenuItem> BuildTree(List<MenuItem> list, int parent)
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

        public class MenuWrapper
        {
            public int MenuId { get; set; }
            public string MenuName { get; set; }
            public List<SectionGroup> Sections { get; set; }
        }

        public class SectionGroup
        {
            public string SectionName { get; set; }
            public List<MenuItem> Items { get; set; }
        }

        public class MenuItem
        {
            public int MenuId { get; set; }
            public string MenuName { get; set; }
            public int ParentMenuId { get; set; }
            public string Url { get; set; }
            public string SectionName { get; set; }
            public int SortOrder { get; set; }
            public List<MenuItem> Children { get; set; } = new List<MenuItem>();
        }
    }
}