using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebPortal
{
    public partial class LogoutNew : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static void DoLogout()
        {

            HttpContext.Current.Session.Clear();       // remove all session data
            HttpContext.Current.Session.Abandon();
            FormsAuthentication.SignOut();
            HttpContext.Current.Response.Cookies[FormsAuthentication.FormsCookieName].Expires = DateTime.Now.AddYears(-1);

            //HttpContext.Current.Session.Clear();
            //HttpContext.Current.Session.Abandon();

            //if (HttpContext.Current.Request.Cookies["ASP.NET_SessionId"] != null)
            //{
            //    HttpCookie cookie = new HttpCookie("ASP.NET_SessionId");
            //    cookie.Expires = DateTime.Now.AddDays(-1);
            //    HttpContext.Current.Response.Cookies.Add(cookie);
            //}
        }
    }
}