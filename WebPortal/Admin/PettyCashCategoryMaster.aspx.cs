using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class PettyCashCategoryMaster : Page
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
        [WebMethod(EnableSession = true)]
        public static string GetCategories()
        {
            return Json(new bllMaster().GetCategories(true));
        }

        [WebMethod(EnableSession = true)]
        public static string SaveCategory(long categoryId, string categoryName, string description, bool isActive)
        {
            if (string.IsNullOrWhiteSpace(categoryName)) throw new Exception("Category name is mandatory.");
            return Json(new bllMaster().SaveCategory(categoryId, categoryName.Trim(), description, isActive, LoginId()));
        }
    }
}
