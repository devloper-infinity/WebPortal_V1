using System;
using System.Web.Services;
using WebPortal.App_Code;
namespace WebPortal.SoftwareRequests
{
 public partial class NewRequest : SoftwareRequestBasePage
 {
  protected void Page_Load(object sender,EventArgs e){}
  [WebMethod] public static string GetBootstrap(){return Dashboard.GetBootstrap();}
  [WebMethod] public static string GetMyRequests(){return Dashboard.GetRequests("Mine","","","",0,0,0,"","");}
  [WebMethod] public static long CreateRequest(int requestTypeId,int applicationId,int moduleId,string title,string description,string justification,string requestedPriority,DateTime? requiredBy){return Dashboard.CreateRequest(requestTypeId,applicationId,moduleId,title,description,justification,requestedPriority,requiredBy,new SoftwareRequestRepository().EmployeeCode(CurrentEmployeeID),"");}
  [WebMethod] public static bool UploadAttachment(long requestId,string fileName,string contentType,string base64){return Dashboard.UploadAttachment(requestId,fileName,contentType,base64);}
 }
}
