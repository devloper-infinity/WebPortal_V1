using System;
using System.Web;
using System.Web.Services;
using WebPortal.Assets.Classes;
namespace WebPortal.Assets { public partial class EmployeeITFieldMaster : System.Web.UI.Page { static AssetEmployeeITService S => new AssetEmployeeITService(); static long U => Convert.ToInt64(HttpContext.Current.User.Identity.Name); protected void Page_Load(object sender, EventArgs e) { } [WebMethod] public static object List() { return AssetBAL.Rows(S.Fields(false)); } [WebMethod] public static ApiResult Save(EmployeeITFieldInput x) { try { return ApiResult.Ok(S.SaveField(x, U), "Field saved successfully."); } catch (Exception ex) { return ApiResult.Fail(ex.Message); } } } }
