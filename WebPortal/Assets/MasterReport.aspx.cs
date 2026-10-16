using System;
using System.Web.Services;
using WebPortal.Assets.Classes;

namespace WebPortal.Assets
{
    public partial class MasterReport : System.Web.UI.Page
    {
        private static AssetEmployeeITService S { get { return new AssetEmployeeITService(); } }
        protected void Page_Load(object sender, EventArgs e) { }
        [WebMethod] public static object List(string search) { return AssetBAL.Sets(S.MasterReport(search)); }
    }
}
