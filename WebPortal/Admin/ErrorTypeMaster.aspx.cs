using System; using System.Collections.Generic; using System.Data; using System.Web; using System.Web.Script.Serialization; using System.Web.Services; using System.Web.UI; using WebPortal.App_Code.BLL;
namespace WebPortal.Admin { public partial class ErrorTypeMaster : Page {
 protected void Page_Load(object sender,EventArgs e){}
 static void Check(int t){if(t<1||t>9)throw new ArgumentOutOfRangeException("ErrorType");}
 static string Json(DataTable t){var rows=new List<Dictionary<string,object>>();foreach(DataRow r in t.Rows){var x=new Dictionary<string,object>();foreach(DataColumn c in t.Columns)x[c.ColumnName]=r[c]==DBNull.Value?null:r[c];rows.Add(x);}return new JavaScriptSerializer{MaxJsonLength=int.MaxValue}.Serialize(rows);}
 [WebMethod] public static string GetErrorTypes(int ErrorType){Check(ErrorType);return Json(new bllInfinityFeedbackRca().GetAdminList(ErrorType));}
 [WebMethod] public static string GetParents(int ErrorType){Check(ErrorType);return Json(new bllInfinityFeedbackRca().GetAdminParents(ErrorType));}
 [WebMethod] public static int AddErrorType(int ErrorType,string Name,int ParentID,int DisplayOrder){Check(ErrorType);if(string.IsNullOrWhiteSpace(Name))throw new ArgumentException("Name is mandatory.");return new bllInfinityFeedbackRca().AddMaster(ErrorType,Name.Trim(),ParentID,DisplayOrder,int.Parse(HttpContext.Current.User.Identity.Name));}
 [WebMethod] public static int SetErrorTypeActive(int ErrorType,int ID,bool IsActive){Check(ErrorType);return new bllInfinityFeedbackRca().SetMasterActive(ErrorType,ID,IsActive);}
}}
