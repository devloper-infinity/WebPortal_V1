using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using WebPortal.App_Code.BLL;

namespace WebPortal.App_Code.Class
{
    public class Employee
    {
        public Int64 EmployeeID { get; set; }
        public int EMPID { get; set; }
        public string Code { get; set; }
        public string Code1 { get; set; }
        public string NAME { get; set; }
        public string Name { get; set; }
        public string WorkingHours { get; set; }
        public string CurrentLogin { get; set; }
        public string UptoTime { get; set; }
        public string JoiningDate { get; set; }
        public string FullName { get; set; }
        public string DateOfBirth { get; set; }
        public string TaskProductive { get; set; }

        public Employee()
        {
            DataTable dtEmp = new bllLogin().GetUserInformation(Convert.ToInt32(HttpContext.Current.User.Identity.Name));

            if (dtEmp != null && dtEmp.Rows.Count > 0)
            {
                EmployeeID = Convert.ToInt64(dtEmp.Rows[0]["EmployeeID"]);
                EMPID = Convert.ToInt32(dtEmp.Rows[0]["EMPID"]);
                Code = dtEmp.Rows[0]["Code"].ToString();
                Name = dtEmp.Rows[0]["Name"].ToString();
                FullName = dtEmp.Rows[0]["FullName"].ToString();
                JoiningDate = dtEmp.Rows[0]["JoiningDate"].ToString();
                // assign other fields as required
            }
        }
    }
}