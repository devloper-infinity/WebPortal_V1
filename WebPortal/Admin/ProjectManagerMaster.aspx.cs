using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class ProjectManagerMaster : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        public class PageData
        {
            public List<UserOption> Users { get; set; }
            public List<ProjectManagerRow> ProjectManagers { get; set; }
        }

        public class UserOption { public string Code { get; set; } public string DisplayName { get; set; } }
        public class ProjectManagerRow
        {
            public int ProjectManagerID { get; set; }
            public string PMName { get; set; }
            public string AddedByName { get; set; }
            public string AddedDate { get; set; }
        }

        [WebMethod]
        public static PageData GetPageData()
        {
            bllMaster master = new bllMaster();
            return new PageData { Users = MapUsers(master.GetAllUsers()), ProjectManagers = MapProjectManagers(master.GetAllProjectManager()) };
        }

        [WebMethod]
        public static int AddProjectManager(string projectManagerCode, bool restore)
        {
            if (string.IsNullOrWhiteSpace(projectManagerCode)) throw new ArgumentException("Project manager is required.");
            bllMaster master = new bllMaster();
            if (restore) return master.UpdateProjectManager(projectManagerCode.Trim(), 0);
            int addedBy;
            if (!int.TryParse(HttpContext.Current.User.Identity.Name, out addedBy)) throw new InvalidOperationException("Your user session is invalid. Please sign in again.");
            return master.InsertProjectManager(projectManagerCode.Trim(), addedBy);
        }

        [WebMethod]
        public static int DeleteProjectManager(int projectManagerId)
        {
            if (projectManagerId <= 0) throw new ArgumentOutOfRangeException("projectManagerId");
            return new bllMaster().DeleteProjectManager(projectManagerId);
        }

        private static List<UserOption> MapUsers(DataTable table)
        {
            List<UserOption> result = new List<UserOption>();
            if (table == null) return result;
            foreach (DataRow row in table.Rows)
            {
                string code = Convert.ToString(row["Code"]).Trim();
                string name = string.Join(" ", new[] { Convert.ToString(row["FirstName"]), Convert.ToString(row["MiddleName"]), Convert.ToString(row["lastName"]) }).Replace("  ", " ").Trim();
                if (code.Length > 0) result.Add(new UserOption { Code = code, DisplayName = code + " : " + name });
            }
            return result;
        }

        private static List<ProjectManagerRow> MapProjectManagers(DataTable table)
        {
            List<ProjectManagerRow> result = new List<ProjectManagerRow>();
            if (table == null) return result;
            foreach (DataRow row in table.Rows)
                result.Add(new ProjectManagerRow {
                    ProjectManagerID = Convert.ToInt32(row["ProjectManagerID"]), PMName = Convert.ToString(row["PMName"]),
                    AddedByName = Convert.ToString(row["AddedByName"]), AddedDate = FormatDate(row["AddedDate"])
                });
            return result;
        }

        private static string FormatDate(object value)
        {
            if (value == null || value == DBNull.Value) return string.Empty;
            DateTime date; return DateTime.TryParse(Convert.ToString(value), out date) ? date.ToString("dd-MMM-yyyy hh:mm tt") : Convert.ToString(value);
        }
    }
}
