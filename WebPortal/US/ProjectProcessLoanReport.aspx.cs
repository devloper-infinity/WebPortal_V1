using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class ProjectProcessLoanReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static string GetProjects() { return Serialize(new bllUS().GetAllProjectByUserRights(HttpContext.Current.User.Identity.Name)); }

        [WebMethod]
        public static string GetReport(int ProjectID, string ProjectNumber)
        {
            DataTable processTable = new bllUS().GetUSProcessList(ProjectID);
            DataTable data = new bllUS().GetProjectProcessLoanReport(ProjectNumber);
            var processes = new List<Dictionary<string, object>>();
            foreach (DataRow row in processTable.Rows) processes.Add(new Dictionary<string, object> { { "ProcessID", row["ProcessID"] }, { "ProcessName", row["ProcessName"] } });
            var loans = new Dictionary<string, Dictionary<string, object>>(StringComparer.OrdinalIgnoreCase);
            foreach (DataRow row in data.Rows)
            {
                string loan = Convert.ToString(row["LoanNo"]); Dictionary<string, object> item;
                if (!loans.TryGetValue(loan, out item)) { item = new Dictionary<string, object> { { "ProjectNumber", ProjectNumber }, { "LoanNo", loan }, { "Processes", new Dictionary<string, object>() } }; loans.Add(loan, item); }
                ((Dictionary<string, object>)item["Processes"])[Convert.ToString(row["ProcessName"])] = new Dictionary<string, object> { { "Employee", row["Employee"] }, { "StartDate", row["StartDate"] }, { "EndDate", row["EndDate"] }, { "Status", row["Status"] } };
            }
            return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(new Dictionary<string, object> { { "Processes", processes }, { "Rows", new List<Dictionary<string, object>>(loans.Values) } });
        }

        private static string Serialize(DataTable table) { var rows = new List<Dictionary<string, object>>(); foreach (DataRow dr in table.Rows) { var row = new Dictionary<string, object>(); foreach (DataColumn col in table.Columns) row[col.ColumnName] = dr[col] == DBNull.Value ? "" : dr[col]; rows.Add(row); } return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(rows); }
    }
}
