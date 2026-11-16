using System;
using System.Web.UI;
namespace WebPortal.Chat { public partial class ChatPage : Page { protected void Page_Load(object sender,EventArgs e){if(!Request.IsAuthenticated)Response.Redirect("~/LoginNew.aspx?ReturnUrl="+Server.UrlEncode(Request.RawUrl));} } }
