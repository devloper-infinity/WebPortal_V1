using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class AssignGroupMenus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGroups();
                BindMenuTree();

               
            }
        }

        private void LoadGroups()
        {
            DataTable dt = new dalMaster().GroupList();
            ddlGroups.DataSource = dt;
            ddlGroups.DataTextField = "GroupName";
            ddlGroups.DataValueField = "GroupId";
            ddlGroups.DataBind();
            ddlGroups.Items.Insert(0, new ListItem("-- Select Group --", "0"));
        }

        void BindMenuTree()
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
                Children = new List<MenuItem>()
            }).ToList();

            var tree = BuildTree(menus, 0);

            // UNIVERSAL SECTION BUILDER (2-level + 3-level support)
            var result = tree.Select(m => new MenuWrapper
            {
                MenuId = m.MenuId,
                MenuName = m.MenuName,

                Sections = m.Children
                    .GroupBy(x => x.Children.Any() ? x.MenuName : (x.SectionName ?? "General"))
                    .Select(g => new SectionGroup
                    {
                        SectionName = g.Key,
                        Items = g.SelectMany(sec =>
                                sec.Children.Any() ? sec.Children : new List<MenuItem> { sec }
                        ).ToList()
                    }).ToList()

            }).ToList();

            rptMenus.DataSource = result;
            rptMenus.DataBind();
        }



        protected void ddlGroups_SelectedIndexChanged1(object sender, EventArgs e)
        {
            if (ddlGroups.SelectedIndex <= 0) return;

            int groupId = Convert.ToInt32(ddlGroups.SelectedValue);
            DataTable dt = new dalMaster().GroupMenuList(groupId);
            var assigned = dt.AsEnumerable().Select(r => r.Field<int>("MenuId")).ToHashSet();

            foreach (RepeaterItem card in rptMenus.Items)
            {
                Repeater rptSub = (Repeater)card.FindControl("rptSub");

                foreach (RepeaterItem sec in rptSub.Items)
                {
                    Repeater rptItems = (Repeater)sec.FindControl("rptItems");

                    foreach (RepeaterItem item in rptItems.Items)
                    {
                        HiddenField hf = (HiddenField)item.FindControl("hfMenuId");
                        HtmlInputCheckBox chk = (HtmlInputCheckBox)item.FindControl("chkMenu");

                        if (hf != null && chk != null)
                            chk.Checked = assigned.Contains(Convert.ToInt32(hf.Value));
                    }
                }
            }
        }

        protected void ddlGroups_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlGroups.SelectedIndex == 0)
                return;

            int groupId = Convert.ToInt32(ddlGroups.SelectedValue);

            // Load menu IDs assigned to this group
            DataTable dt = new dalMaster().GroupMenuList(groupId);

            var ids = dt.AsEnumerable()
                        .Select(r => r.Field<int>("MenuId"))
                        .ToList();

            // Push to hidden field
            hfSelectedMenus.Value =
                new JavaScriptSerializer().Serialize(ids);

            // Trigger client script to check items
            ScriptManager.RegisterStartupScript(
                this, this.GetType(), "loadChecks",
                "loadSelectedMenus();", true
            );
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (ddlGroups.SelectedIndex == 0)
                return;

            int groupId = Convert.ToInt32(ddlGroups.SelectedValue);

            // remove existing
            new dalMaster().DeleteGroupMenus(groupId);
            var posted = Request.Form.GetValues("menus");
            string csv = (posted == null) ? "" : string.Join(",", posted);

            new dalMaster().GroupMenuSave(groupId, csv);

            ScriptManager.RegisterStartupScript(this, GetType(), "msg",
                "alert('Menus assigned to group successfully');", true);
        }

        // Tree builder
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
            public List<MenuItem> Children { get; set; }
        }
    }
}