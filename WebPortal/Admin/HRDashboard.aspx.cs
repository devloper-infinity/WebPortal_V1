using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class HRDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static object GetDashboardData()
        {
            int employeeId = Convert.ToInt32(HttpContext.Current.User.Identity.Name);
            string month = DateTime.Now.ToString("MMMM");
            string year = DateTime.Now.Year.ToString();
            var master = new bllMaster();
            var recruitment = new bllRequisition();
            DataTable req = Safe(() => recruitment.GetAllRecruitmentByUserID(employeeId));
            DataTable applicants = Safe(() => recruitment.GetApplicantListByEmployeeId(employeeId));
            DataTable joinees = Safe(() => master.GetAllNewJoineeReport_Revised(month, year));
            DataTable leaves = Safe(() => master.GetTotalLeaves(month, year));
            DataTable absconding = Safe(() => master.GetTotalAbscondingEmployees(month, year));
            DataTable step2 = Safe(() => master.GetResignedEmployeesForFinalize(employeeId));
            DataTable step3 = Safe(() => master.GetAllResignedEmployees(employeeId));
            return new
            {
                OpenPositions = SumOrCount(req, "NoOfPositions", "NumberOfPositions", "Positions", "RequiredCount"),
                Applicants = applicants.Rows.Count, Joinees = joinees.Rows.Count, Leaves = leaves.Rows.Count,
                Absconding = absconding.Rows.Count, Step2 = step2.Rows.Count, Step3 = step3.Rows.Count,
                Requisitions = Rows(req, 6), Recruitment = Rows(applicants, 6)
            };
        }

        private static DataTable Safe(Func<DataTable> load) { try { return load() ?? new DataTable(); } catch { return new DataTable(); } }
        private static int SumOrCount(DataTable table, params string[] names)
        {
            foreach (string name in names) if (table.Columns.Contains(name))
                return table.AsEnumerable().Sum(r => r[name] == DBNull.Value ? 0 : Convert.ToInt32(r[name]));
            return table.Rows.Count;
        }
        private static List<Dictionary<string, object>> Rows(DataTable table, int count)
        {
            return table.AsEnumerable().Take(count).Select(r => table.Columns.Cast<DataColumn>()
                .ToDictionary(c => c.ColumnName, c => r[c] == DBNull.Value ? null : r[c])).ToList();
        }
    }
}
