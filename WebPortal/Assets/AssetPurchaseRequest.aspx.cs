using System;
using System.Web;
using System.Web.Services;
using WebPortal.Assets.Classes;

namespace WebPortal.Assets
{
    public partial class AssetPurchaseRequest : System.Web.UI.Page
    {
        private static AssetBAL S => new AssetBAL();

        private static long U =>
            Convert.ToInt64(HttpContext.Current.User.Identity.Name.ToString());

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static object Lookup(string type, int? parentID)
        {
            return AssetBAL.Rows(S.Lookup(type, parentID));
        }

        [WebMethod]
        public static object List()
        {
            return AssetBAL.Rows(S.List("PurchaseRequest"));
        }

        [WebMethod]
        public static object Get(long id)
        {
            return AssetBAL.Sets(S.Detail("PurchaseRequest", id));
        }

        [WebMethod]
        public static ApiResult Save(PurchaseRequestInput x)
        {
            try
            {
                return ApiResult.Ok(
                    S.Save("usp_Assets_SavePurchaseRequest", x, U)
                );
            }
            catch (Exception ex)
            {
                return ApiResult.Fail(ex.Message);
            }
        }
    }
}