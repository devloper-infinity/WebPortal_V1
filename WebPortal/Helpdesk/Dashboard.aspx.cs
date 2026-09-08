using System;using System.Web.Services;namespace WebPortal.Helpdesk{public partial class Dashboard:HelpdeskPage{protected void Page_Load(object sender,EventArgs e){}[WebMethod]public static string Get(){return Json(new HelpdeskRepository().Dashboard(UserId));}}
}
