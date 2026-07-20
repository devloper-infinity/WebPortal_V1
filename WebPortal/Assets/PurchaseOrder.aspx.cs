using System;
using System.Web;
using System.Web.Services;
using WebPortal.Assets.Classes;
namespace WebPortal.Assets
{
    public partial class PurchaseOrder : System.Web.UI.Page
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
        public static object List()
        {
            return AssetBAL.Rows(S.List("PurchaseOrder"));
        }

        [WebMethod]
        public static object Get(long id)
        {
            return AssetBAL.Sets(S.PurchaseOrderDetail(id));
        }
        [WebMethod]
        public static ApiResult Save(PurchaseOrderInput x)
        {
            try
            {
                return ApiResult.Ok(S.Save("usp_Assets_SavePurchaseOrder", x, U));
            }
            catch (Exception ex)
            {
                return ApiResult.Fail(ex.Message);
            }
        }
    }
}
