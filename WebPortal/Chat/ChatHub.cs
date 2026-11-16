using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNet.SignalR;
using WebPortal.App_Code;

namespace WebPortal.Chat
{
    [Authorize]
    public sealed class ChatHub : Hub
    {
        private static readonly ConcurrentDictionary<int,int> Connections = new ConcurrentDictionary<int,int>();
        private int Actor { get { int id; if(!Int32.TryParse(Context.User.Identity.Name,out id)) throw new HubException("Authentication required."); return id; } }
        private static string UserGroup(int id) { return "employee:"+id; }
        public override Task OnConnected() { int n=Connections.AddOrUpdate(Actor,1,(k,v)=>v+1); Groups.Add(Context.ConnectionId,UserGroup(Actor)); if(n==1) Presence(Actor,true); return base.OnConnected(); }
        public override Task OnDisconnected(bool stopCalled) { int n=Connections.AddOrUpdate(Actor,0,(k,v)=>Math.Max(0,v-1)); if(n==0) Presence(Actor,false); return base.OnDisconnected(stopCalled); }
        public void Typing(long conversationId, bool typing) { Clients.OthersInGroup("conversation:"+conversationId).typingChanged(conversationId,Actor,typing); }
        public void JoinConversation(long conversationId) { new ChatRepository().History(Actor,conversationId,0,1,""); Groups.Add(Context.ConnectionId,"conversation:"+conversationId); }
        public void LeaveConversation(long conversationId) { Groups.Remove(Context.ConnectionId,"conversation:"+conversationId); }
        internal static void Message(DataSet result) { if(result.Tables.Count<2||result.Tables[0].Rows.Count==0)return;var groups=result.Tables[1].Rows.Cast<DataRow>().Select(r=>UserGroup(Convert.ToInt32(r["EmployeeID"]))).ToList();GlobalHost.ConnectionManager.GetHubContext<ChatHub>().Clients.Groups(groups).messageReceived(ToDictionary(result.Tables[0].Rows[0])); }
        internal static void Read(DataSet result) { if(result.Tables.Count==0||result.Tables[0].Rows.Count==0)return;var r=result.Tables[0].Rows[0];GlobalHost.ConnectionManager.GetHubContext<ChatHub>().Clients.Group("conversation:"+r["ConversationID"]).readChanged(ToDictionary(r)); }
        private static void Presence(int actor,bool online){var ds=new ChatRepository().Bootstrap(actor,"");var groups=ds.Tables[0].Rows.Cast<DataRow>().Select(r=>UserGroup(Convert.ToInt32(r["EmployeeID"]))).ToList();groups.Add(UserGroup(actor));GlobalHost.ConnectionManager.GetHubContext<ChatHub>().Clients.Groups(groups).presenceChanged(actor,online);}
        private static IDictionary<string,object> ToDictionary(DataRow r){return r.Table.Columns.Cast<DataColumn>().ToDictionary(c=>c.ColumnName,c=>r[c]==DBNull.Value?null:r[c]);}
    }
}
