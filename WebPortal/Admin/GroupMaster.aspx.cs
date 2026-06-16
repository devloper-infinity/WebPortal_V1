using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class GroupMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGroups();
            }
        }

        void LoadGroups()
        {
            DataTable dt = new dalMaster().GroupList();
            gvGroups.DataSource = dt;
            gvGroups.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int groupId = string.IsNullOrEmpty(hfGroupId.Value)
                ? 0
                : Convert.ToInt32(hfGroupId.Value);

            string name = txtGroupName.Text.Trim();
            string desc = txtDescription.Text.Trim();
            bool active = chkActive.Checked;

            if (name == "")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Group Name required');", true);
                return;
            }

            // Save (insert or update)
            int savedId = new dalMaster().GroupSave(groupId, name, desc, active);

            hfGroupId.Value = savedId.ToString();
            LoadGroups();

            ScriptManager.RegisterStartupScript(this, GetType(), "alertSaved",
                "alert('Group saved successfully');", true);
        }

        protected void btnNew_Click(object sender, EventArgs e)
        {
            hfGroupId.Value = "";
            txtGroupName.Text = "";
            txtDescription.Text = "";
            chkActive.Checked = true;
        }

        protected void gvGroups_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "editGroup")
            {
                int groupId = Convert.ToInt32(e.CommandArgument);

                DataTable dt = new dalMaster().GroupList();
                DataRow row = dt.Select("GroupId=" + groupId)[0];

                hfGroupId.Value = row["GroupId"].ToString();
                txtGroupName.Text = row["GroupName"].ToString();
                txtDescription.Text = row["Description"].ToString();
                chkActive.Checked = Convert.ToBoolean(row["IsActive"]);
            }
        }
    }
}