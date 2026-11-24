using System;
using System.Web.UI;
namespace WebPortal.Admin
{
    public partial class HousekeepingShell : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string consolidatedPage = HK_PageAccess.RequireShellPage();
            if (!String.IsNullOrEmpty(consolidatedPage))
                Response.Redirect(ResolveUrl(consolidatedPage), true);
        }
    }
}
