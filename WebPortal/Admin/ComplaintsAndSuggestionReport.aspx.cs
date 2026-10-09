using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class ComplaintsAndSuggestionReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static object GetReport()
        {
            DataTable data = new bllMaster().GetAllComplaintsAndSuggestions();
            var rows = new List<Dictionary<string, object>>();

            foreach (DataRow dataRow in data.Rows)
            {
                var row = new Dictionary<string, object>();
                foreach (string column in new[] { "Type", "Subject", "Description", "EmpName", "AddedDate" })
                    row[column] = data.Columns.Contains(column) && dataRow[column] != DBNull.Value ? dataRow[column] : "";
                rows.Add(row);
            }
            return rows;
        }
    }
}
