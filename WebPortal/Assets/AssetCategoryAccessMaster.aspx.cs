using System;
using System.Web;
using System.Web.Services;
using WebPortal.Assets.Classes;

namespace WebPortal.Assets
{
    public partial class AssetCategoryAccessMaster : System.Web.UI.Page
    {
        private static readonly AssetCategoryAccessService Access = new AssetCategoryAccessService();
        private static long CurrentUserID { get { return Convert.ToInt64(HttpContext.Current.User.Identity.Name); } }
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod] public static object Users() { return AssetBAL.Rows(Access.Users()); }
        [WebMethod] public static object Get(long userID) { return AssetBAL.Rows(Access.UserCategories(userID)); }
        [WebMethod]
        public static ApiResult Save(CategoryAccessInput input)
        {
            try
            {
                if (input == null || input.UserID <= 0) return ApiResult.Fail("Employee is required.");
                Access.Save(input.UserID, input.CategoryIDs, CurrentUserID);
                return ApiResult.Ok(null, "Category access saved successfully.");
            }
            catch (Exception ex) { return ApiResult.Fail(ex.Message); }
        }
    }
}
