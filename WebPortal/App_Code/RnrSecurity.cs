using System;
using System.Security;
using System.Web;

namespace WebPortal.App_Code
{
    public static class RnrSecurity
    {
        public static int EmployeeId
        {
            get { int id; if (HttpContext.Current.User == null || !HttpContext.Current.User.Identity.IsAuthenticated || !Int32.TryParse(HttpContext.Current.User.Identity.Name, out id)) throw new SecurityException("Authentication is required."); return id; }
        }
        public static void RequireHr()
        {
            if (HttpContext.Current.User == null || !HttpContext.Current.User.Identity.IsAuthenticated || !HttpContext.Current.User.IsInRole("Admin")) throw new SecurityException("HR authorization is required.");
        }
        public static string Ip { get { return (HttpContext.Current.Request.UserHostAddress ?? String.Empty).Substring(0, Math.Min(45, (HttpContext.Current.Request.UserHostAddress ?? String.Empty).Length)); } }
    }
}
