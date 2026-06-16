using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class AssignUserGroups : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
                LoadGroups();
            }
        }

        private void LoadUsers()
        {
            DataTable dt = new bllMaster().GetAllUsers();
            lstUsers.DataSource = dt;
            lstUsers.DataTextField = "FullName";
            lstUsers.DataValueField = "EmployeeID";
            lstUsers.DataBind();
        }

        private void LoadGroups()
        {
            DataTable dt = new dalMaster().GroupList();
            cblGroups.DataSource = dt;
            cblGroups.DataTextField = "GroupName";
            cblGroups.DataValueField = "GroupId";
            cblGroups.DataBind();
        }

        protected void lstUsers_SelectedIndexChanged(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(lstUsers.SelectedValue);
            DataTable dt = new dalMaster().UserGroupList(userId);
            var assigned = dt.AsEnumerable().Select(r => r.Field<int>("GroupId")).ToHashSet();

            foreach (ListItem li in cblGroups.Items)
                li.Selected = assigned.Contains(Convert.ToInt32(li.Value));
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(lstUsers.SelectedValue);

            string csv = string.Join(",",
                cblGroups.Items.Cast<ListItem>().Where(li => li.Selected).Select(li => li.Value)
            );

            new dalMaster().UserGroupSave(userId, csv);

            ScriptManager.RegisterStartupScript(this, GetType(), "msg",
                "alert('Groups assigned to user successfully');", true);
        }
    }
}