using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

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
    }
}