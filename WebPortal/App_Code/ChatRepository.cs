using System;
using System.Data;
using System.Data.SqlClient;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code
{
    public sealed class ChatRepository
    {
        private static SqlConnection Open() { var c = new SqlConnection(SQLHelper.ConnectionString); c.Open(); return c; }
        private static void Add(SqlCommand c, string n, object v) { c.Parameters.AddWithValue(n, v ?? DBNull.Value); }
        private static DataSet Run(string procedure, Action<SqlCommand> bind)
        {
            using (var cn = Open()) using (var c = new SqlCommand(procedure, cn))
            { c.CommandType = CommandType.StoredProcedure; bind(c); var ds = new DataSet(); new SqlDataAdapter(c).Fill(ds); return ds; }
        }
        public DataSet Bootstrap(int actor, string search) { return Run("dbo.Chat_Bootstrap", c => { Add(c,"@ActorEmployeeID",actor); Add(c,"@Search",search ?? ""); }); }
        public DataSet History(int actor, long conversation, long before, int size, string search) { return Run("dbo.Chat_GetMessages", c => { Add(c,"@ActorEmployeeID",actor); Add(c,"@ConversationID",conversation); Add(c,"@BeforeMessageID",before == 0 ? (object)DBNull.Value : before); Add(c,"@PageSize",Math.Max(1,Math.Min(size,100))); Add(c,"@Search",search ?? ""); }); }
        public DataSet OpenDirect(int actor, int other) { return Run("dbo.Chat_OpenDirectConversation", c => { Add(c,"@ActorEmployeeID",actor); Add(c,"@OtherEmployeeID",other); }); }
        public DataSet CreateGroup(int actor, string name, string memberIds) { return Run("dbo.Chat_CreateGroup", c => { Add(c,"@ActorEmployeeID",actor); Add(c,"@Name",name); Add(c,"@MemberEmployeeIDs",memberIds ?? ""); }); }
        public DataSet Send(int actor, long conversation, string body, Guid? uploadToken) { return Run("dbo.Chat_SendMessage", c => { Add(c,"@ActorEmployeeID",actor); Add(c,"@ConversationID",conversation); Add(c,"@Body",body ?? ""); Add(c,"@UploadToken",uploadToken.HasValue ? (object)uploadToken.Value : DBNull.Value); }); }
        public DataSet MarkRead(int actor, long conversation, long message) { return Run("dbo.Chat_MarkRead", c => { Add(c,"@ActorEmployeeID",actor); Add(c,"@ConversationID",conversation); Add(c,"@ThroughMessageID",message); }); }
        public void StageAttachment(int actor, Guid token, string original, string stored, string type, long size) { Run("dbo.Chat_StageAttachment",c=>{Add(c,"@ActorEmployeeID",actor);Add(c,"@UploadToken",token);Add(c,"@OriginalFileName",original);Add(c,"@StoredFileName",stored);Add(c,"@ContentType",type);Add(c,"@FileSize",size);}); }
        public DataRow Attachment(int actor, long attachment) { var ds=Run("dbo.Chat_AuthorizeAttachment",c=>{Add(c,"@ActorEmployeeID",actor);Add(c,"@AttachmentID",attachment);}); return ds.Tables.Count>0&&ds.Tables[0].Rows.Count>0?ds.Tables[0].Rows[0]:null; }
    }
}
