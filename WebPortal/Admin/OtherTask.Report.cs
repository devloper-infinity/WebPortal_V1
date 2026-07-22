using Newtonsoft.Json;
using System;
using System.Data;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class OtherTask : System.Web.UI.Page
    {
        [WebMethod]
        public static string BindOtherTaskReport(string FromDate, string ToDate)
        {
            int EmployeeID = 0;

            int IsPm = new bllMaster().CheckIfPM(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (IsPm == 1)
                EmployeeID = 0;
            else
                EmployeeID = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            string data = string.Empty;
            try
            {
                DataTable dt = new bllMaster().GetOtherTaskReport(FromDate, ToDate, EmployeeID);

                if (dt.Rows.Count > 0)
                {
                    data = JsonConvert.SerializeObject(dt);
                }
            }
            catch (Exception ex)
            {
                return "";
            }

            return data;
        }
    }
}
