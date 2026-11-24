using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
namespace WebPortal.Admin
{
    public partial class HK_StaffMaster : Page
    {
        [WebMethod(EnableSession = true), ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<Dictionary<string, object>> GetEmpsByDept(int DepartmentID)
        {
            if (HttpContext.Current == null || HttpContext.Current.User == null || !HttpContext.Current.User.Identity.IsAuthenticated)
                throw new UnauthorizedAccessException("Sign in to continue.");

            DataTable employees = new bllMaster().GetEmpsByDept(DepartmentID);
            return employees.AsEnumerable()
                .Select(row => employees.Columns.Cast<DataColumn>()
                    .ToDictionary(column => column.ColumnName, column => row.IsNull(column) ? null : row[column]))
                .ToList();
        }
    }
}
