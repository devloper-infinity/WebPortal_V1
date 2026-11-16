using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(WebPortal.Chat.Startup))]
namespace WebPortal.Chat
{
    public sealed class Startup { public void Configuration(IAppBuilder app) { app.MapSignalR(); } }
}
