using System;
using System.Web;
using System.Web.UI;

namespace WebPortal.App_Code
{
    public class SoftwareRequestBasePage : Page
    {
        protected static int CurrentEmployeeID { get { int id; if(!Int32.TryParse(HttpContext.Current.User.Identity.Name,out id)) throw new UnauthorizedAccessException("Valid employee login required."); return id; } }
        protected override void OnInit(EventArgs e) { base.OnInit(e); if(Context.User==null||Context.User.Identity==null||!Context.User.Identity.IsAuthenticated) Response.Redirect("~/Login.aspx",true); }
    }
}
