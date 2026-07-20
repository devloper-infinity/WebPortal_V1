using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Description;
using WebPortal.Assets.Classes;
namespace WebPortal.Assets
{
    public partial class ViewPurchaseOrders : System.Web.UI.Page
    {
        static AssetBAL S => new AssetBAL();
        static long U => Convert.ToInt64(HttpContext.Current.User.Identity.Name.ToString());
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        [WebMethod]
        public static object Lookup(string type, int? parentID)
        {
            return AssetBAL.Rows(S.Lookup(type, parentID));
        }
        [WebMethod]
        public static object List(int? branchID, string status)
        {
            status = string.IsNullOrWhiteSpace(status) ? null : status.Trim();
            return AssetBAL.Rows(S.List("PurchaseOrder", null, branchID, status));
            //return AssetBAL.Rows(S.List("PurchaseOrder", null, branchID, status));
        }
    }
}