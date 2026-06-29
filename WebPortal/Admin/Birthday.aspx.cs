using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class Birthday : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetAllBirthdays()
        {
            DataTable dt = new bllMaster().GetAllBirthdays();
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetAllBirthdayMessages(int EmployeeID)
        {
            if (EmployeeID == 0)
            {
                EmployeeID = int.Parse(HttpContext.Current.User.Identity.Name);
            }

            DataTable dt = new bllMaster().GetAllBirthdayMessages(EmployeeID);
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static int SendBirthdayWish(string message, int EmployeeID)
        {
            if (EmployeeID == 0)
            {
                EmployeeID = int.Parse(HttpContext.Current.User.Identity.Name);
            }

            string code = new dalMaster().GetCodeFromEmployeeId(EmployeeID);
            return new bllMaster().InsertBirthdayMessage(
                message,
                int.Parse(HttpContext.Current.User.Identity.Name),
                code);
        }

        private static string SerializeDataTable(DataTable dt)
        {
            var rows = new List<Dictionary<string, object>>();

            foreach (DataRow dr in dt.Rows)
            {
                var row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }

            var serializer = new JavaScriptSerializer { MaxJsonLength = int.MaxValue };
            return serializer.Serialize(rows);
        }
    }
}
