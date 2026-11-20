using System;
using System.Web.UI;
namespace WebPortal.Admin
{
    public partial class HousekeepingShell : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Context.User == null || !Context.User.Identity.IsAuthenticated)
                Response.Redirect("~/Login.aspx", true);
        }
    }
}
