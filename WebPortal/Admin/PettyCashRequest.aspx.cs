using System;
using System.Data;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Collections.Generic;

namespace WebPortal.Admin
{
    public partial class PettyCashRequest : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
        private static long LoginId()
        {
            object v = System.Web.HttpContext.Current.Session["EmployeeID"];
            if (v == null || !long.TryParse(Convert.ToString(v), out long id)) throw new Exception("Session expired. Please login again.");
            return id;
        }
        private static string Json(DataTable dt)
        {
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow r in dt.Rows)
            {
                var d = new Dictionary<string, object>();
                foreach (DataColumn c in dt.Columns) d[c.ColumnName] = r[c] == DBNull.Value ? null : r[c];
                rows.Add(d);
            }
            return new JavaScriptSerializer().Serialize(rows);
        }
        [WebMethod(EnableSession=true)] public static string GetRequests(){ return Json(new PettyCashBLL().GetRequests(LoginId(),null)); }
        [WebMethod(EnableSession=true)] public static string GetCategories(){ return Json(new PettyCashBLL().GetCategories(false)); }
        [WebMethod(EnableSession=true)] public static string GetEmployees(){ return Json(new PettyCashBLL().GetEmployees()); }
        [WebMethod(EnableSession=true)] public static string SaveRequest(long requestId,long employeeId,long categoryId,string requestDate,string requiredDate,string purpose,decimal amount,string priority,string remark,bool submit)
        {
            DateTime rd, reqd; if(!DateTime.TryParse(requestDate,out rd)||!DateTime.TryParse(requiredDate,out reqd)) throw new Exception("Invalid date.");
            if(employeeId<=0||categoryId<=0) throw new Exception("Employee and Category are mandatory."); if(string.IsNullOrWhiteSpace(purpose)) throw new Exception("Purpose is mandatory."); if(amount<=0) throw new Exception("Amount must be greater than zero."); if(reqd<rd) throw new Exception("Required Date cannot be before Request Date.");
            return Json(new PettyCashBLL().SaveRequest(requestId,employeeId,categoryId,null,rd,reqd,purpose.Trim(),amount,priority,remark,LoginId(),submit));
        }
    }
}
