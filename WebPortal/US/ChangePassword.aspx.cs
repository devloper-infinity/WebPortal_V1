using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int ChangePasswords(string CurrentPassword, string NewPassword)
        {
            int returnvalue = 0;
            returnvalue = new bllMaster().ChangePasswordNew(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), CurrentPassword, new bllLogin().Encrypt(CurrentPassword), new bllLogin().Encrypt(NewPassword), NewPassword);
            return returnvalue;
        }
    }
}