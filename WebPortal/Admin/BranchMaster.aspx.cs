using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class BranchMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod] public static object GetBranches() { return ToRows(new bllMaster().GetAllBranches()); }

        [WebMethod]
        public static int SaveBranch(int branchId, string branchName)
        {
            branchName = (branchName ?? "").Trim();
            if (branchName.Length == 0 || !System.Text.RegularExpressions.Regex.IsMatch(branchName, "^[a-zA-Z ]+$")) return 0;
            int userId = int.Parse(HttpContext.Current.User.Identity.Name);
            return branchId == 0 ? new bllMaster().InsertBranch(branchName, userId) : new bllMaster().UpdateBranch(branchName, branchId, userId);
        }

        [WebMethod] public static int RestoreBranch(string branchName) { return new bllMaster().UpdateBranch((branchName ?? "").Trim(), 0, int.Parse(HttpContext.Current.User.Identity.Name)); }
        [WebMethod] public static int DeleteBranch(int branchId) { return new bllMaster().DeleteBranch(branchId, int.Parse(HttpContext.Current.User.Identity.Name)); }

        private static object ToRows(DataTable data)
        {
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow dataRow in data.Rows)
            {
                var row = new Dictionary<string, object>();
                foreach (DataColumn column in data.Columns) row[column.ColumnName] = dataRow[column] == DBNull.Value ? "" : dataRow[column];
                rows.Add(row);
            }
            return rows;
        }
    }
}
