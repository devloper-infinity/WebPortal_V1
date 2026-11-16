using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using WebPortal.App_Code;

namespace WebPortal.Chat
{
    public sealed class ChatApi : IHttpHandler
    {
        private const int MaxBytes=10*1024*1024;
        private static readonly string[] Allowed={".pdf",".xls",".xlsx",".doc",".docx",".png",".jpg",".jpeg",".gif",".txt"};
        public bool IsReusable { get { return false; } }
        public void ProcessRequest(HttpContext x)
        {
            x.Response.ContentType="application/json"; x.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            int actor; if(x.User==null||!x.User.Identity.IsAuthenticated||!Int32.TryParse(x.User.Identity.Name,out actor)){Fail(x,401,"Authentication required.");return;}
            try { var r=new ChatRepository(); string a=(x.Request["action"]??"").ToLowerInvariant(); DataSet ds;
                if(a=="bootstrap") ds=r.Bootstrap(actor,x.Request["q"]);
                else if(a=="history") ds=r.History(actor,L(x,"conversationId"),L(x,"before"),I(x,"size",40),x.Request["q"]);
                else if(a=="direct") ds=r.OpenDirect(actor,I(x,"employeeId",0));
                else if(a=="group") ds=r.CreateGroup(actor,x.Request["name"],x.Request["members"]);
                else if(a=="send") { ds=r.Send(actor,L(x,"conversationId"),x.Request["body"],GuidValue(x.Request["uploadToken"])); ChatHub.Message(ds); }
                else if(a=="read") { ds=r.MarkRead(actor,L(x,"conversationId"),L(x,"messageId")); ChatHub.Read(ds); }
                else if(a=="upload") { Upload(x,actor,r); return; }
                else if(a=="download") { Download(x,actor,r); return; }
                else { Fail(x,400,"Unknown action.");return; }
                x.Response.Write(new JavaScriptSerializer{MaxJsonLength=2097152}.Serialize(ds.Tables.Cast<DataTable>().Select(Table).ToArray()));
            } catch(Exception e){Fail(x,400,e.Message);}
        }
        private static object Table(DataTable t){return t.Rows.Cast<DataRow>().Select(row=>t.Columns.Cast<DataColumn>().ToDictionary(c=>c.ColumnName,c=>row[c]==DBNull.Value?null:row[c])).ToArray();}
        private static int I(HttpContext x,string n,int d){int v;return Int32.TryParse(x.Request[n],out v)?v:d;} private static long L(HttpContext x,string n){long v;if(!Int64.TryParse(x.Request[n],out v))throw new ArgumentException("Invalid "+n);return v;}
        private static Guid? GuidValue(string s){Guid g;return Guid.TryParse(s,out g)?g:(Guid?)null;}
        private static void Upload(HttpContext x,int actor,ChatRepository r){if(x.Request.Files.Count!=1)throw new ArgumentException("Select one attachment.");var f=x.Request.Files[0];if(f==null||f.ContentLength<1||f.ContentLength>MaxBytes)throw new ArgumentException("Attachment must be between 1 byte and 10 MB.");string ext=Path.GetExtension(f.FileName).ToLowerInvariant();if(!Allowed.Contains(ext))throw new ArgumentException("File type is not permitted.");Guid token=Guid.NewGuid();string stored=token.ToString("N")+ext,dir=x.Server.MapPath("~/App_Data/ChatUploads/Pending");Directory.CreateDirectory(dir);string path=Path.Combine(dir,stored);f.SaveAs(path);try{r.StageAttachment(actor,token,Path.GetFileName(f.FileName),stored,String.IsNullOrWhiteSpace(f.ContentType)?"application/octet-stream":f.ContentType,f.ContentLength);}catch{File.Delete(path);throw;}x.Response.Write(new JavaScriptSerializer().Serialize(new{uploadToken=token,fileName=Path.GetFileName(f.FileName),size=f.ContentLength}));}
        private static void Download(HttpContext x,int actor,ChatRepository r){long id=L(x,"attachmentId");var row=r.Attachment(actor,id);if(row==null){Fail(x,404,"Attachment not found.");return;}string root=x.Server.MapPath("~/App_Data/ChatUploads/Pending"),path=Path.Combine(root,Convert.ToString(row["StoredFileName"]));if(!File.Exists(path)){Fail(x,404,"Attachment file not found.");return;}x.Response.Clear();x.Response.ContentType=Convert.ToString(row["ContentType"]);x.Response.AddHeader("Content-Disposition","attachment; filename=\""+Path.GetFileName(Convert.ToString(row["OriginalFileName"])).Replace("\"","")+"\"");x.Response.TransmitFile(path);}
        private static void Fail(HttpContext x,int status,string message){x.Response.StatusCode=status;x.Response.TrySkipIisCustomErrors=true;x.Response.Write(new JavaScriptSerializer().Serialize(new{error=message}));}
    }
}
