using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebPortal.App_Code.BLL;

namespace WebPortal.App_Code.Class
{
    public class EmployeeInfo
    {

        //5ecu+ity@2026

        public int EmployeeID { get; set; }
        public string EmployeeName { get; set; }
        public string AppID { get; set; }
        public string Code { get; set; }
        public string Title { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string lastName { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public string GenderOld { get; set; }
        public string PresentAddress { get; set; }
        public string PermanentAddress { get; set; }
        public string EmailID { get; set; }
        public string Qualification { get; set; }
        public string CellNo { get; set; }
        public string ResTelNo { get; set; }
        public string DateOfBirth { get; set; }
        public string BloodGroup { get; set; }
        public string RequisitionID { get; set; }
        public string PAN { get; set; }
        public string JoiningDate { get; set; }
        public string Salary { get; set; }
        public string Company { get; set; }
        public string WorkingBranch { get; set; }
        public string WorkingBranchName { get; set; }
        public string Designation { get; set; }
        public string DesignationName { get; set; }
        public string Department { get; set; }
        public string DepartmentName { get; set; }
        public string AppointmentDate { get; set; }
        public string Project { get; set; }
        public string ProjectName { get; set; }
        public string ProcessName { get; set; }
        public string ProjectManager { get; set; }
        public string ProjectManagerName { get; set; }
        public string PMCode { get; set; }
        public string Shift { get; set; }
        public string ShiftOld { get; set; }
        public string CutOffTime { get; set; }
        public string WorkingHours { get; set; }
        public string WorkingHoursOld { get; set; }
        public string EmployeeRemark { get; set; }
        public string IsAgreement { get; set; }
        public string Period { get; set; }
        public string DateOfAgreement { get; set; }
        public string AgreementExpiraryDate { get; set; }
        public string OfficialEmailID { get; set; }
        public string BankName { get; set; }
        public string BankIFSC { get; set; }
        public string BankAccNo { get; set; }
        public string AadharNo { get; set; }
        public string UAN { get; set; }
        public string ESICNo { get; set; }
        public string PFNo { get; set; }
        public string WeeklyHoliday { get; set; }
        public string WeeklyHolidayName { get; set; }
        public string EmployeeType { get; set; }
        public string Domain { get; set; }
        public string DomainName { get; set; }
        public string SubDomain { get; set; }
        public string DailyTaskProductivity { get; set; }
        public string UWExp { get; set; }
        public string IncMonth { get; set; }
        public string IncYear { get; set; }
        public string IsPolicy { get; set; }
        public string JobType { get; set; }

        public static EmployeeInfo Current
        {
            get
            {
                if (HttpContext.Current.Session["EmployeeInfo"] == null)
                {
                    int empID = Convert.ToInt32(HttpContext.Current.User.Identity.Name);
                    LoadEmployeeInfo(empID);
                }

                return (EmployeeInfo)HttpContext.Current.Session["EmployeeInfo"];
            }
        }

        public static void LoadEmployeeInfo(int empID)
        {
            DataTable dtEmp = new bllLogin().GetUserInformation(empID);

            if (dtEmp != null && dtEmp.Rows.Count > 0)
            {
                DataRow row = dtEmp.Rows[0];

                string gender = GetValue(row, "Gender");

                HttpContext.Current.Session["EmployeeInfo"] = new EmployeeInfo
                {
                    EmployeeID = GetInt(row, "EmployeeID"),
                    EmployeeName = GetValue(row, "EmpName"),
                    AppID = GetValue(row, "ApplicationID"),
                    Code = GetValue(row, "Code"),
                    Title = GetValue(row, "Title"),
                    FirstName = GetValue(row, "FirstName"),
                    MiddleName = GetValue(row, "MiddleName"),
                    lastName = GetValue(row, "lastName"),
                    Name = GetValue(row, "EmpFullName"),
                    Gender = gender,
                 
                    PresentAddress = GetValue(row, "PresentAddress"),
                    PermanentAddress = GetValue(row, "PermenentAddress"),
                    EmailID = GetValue(row, "EmailID"),
                    Qualification = GetValue(row, "Qualification"),
                    CellNo = GetValue(row, "CellNo"),
                    ResTelNo = GetValue(row, "ResTelNo"),
                    DateOfBirth = GetValue(row, "DateOfBirth"),
                    BloodGroup = GetValue(row, "BloodGroup"),
                    RequisitionID = GetValue(row, "RequisitionID"),
                    PAN = GetValue(row, "PAN"),
                    JoiningDate = GetValue(row, "JoiningDate"),
                    Salary = GetValue(row, "Salary"),

                    Company = GetValue(row, "Company"),
                    WorkingBranch = GetValue(row, "WorkingBranch"),
                    WorkingBranchName = GetValue(row, "WorkingBranchName"),
                    Designation = GetValue(row, "Designation"),
                    DesignationName = GetValue(row, "DesignationName"),
                    Department = GetValue(row, "Department"),
                    DepartmentName = GetValue(row, "DepartmentName"),
                    AppointmentDate = GetValue(row, "AppointmentDate"),

                    Project = GetValue(row, "Project"),
                    ProjectName = GetValue(row, "ProjectName"),
                    ProcessName = GetValue(row, "ProcessName"),
                    ProjectManager = GetValue(row, "ProjectManager"),
                    ProjectManagerName = GetValue(row, "ReportingManager"),
                    PMCode = GetValue(row, "ReportingManagerCode"),

                    Shift = GetValue(row, "Shift"),
                    ShiftOld = GetValue(row, "ShiftName"),
                    CutOffTime = GetValue(row, "CutOffTime"),
                    WorkingHours = GetValue(row, "WorkingHours"),
                    WorkingHoursOld = GetValue(row, "WorkTime"),
                    EmployeeRemark = GetValue(row, "EmployeeRemark"),

                    IsAgreement = GetValue(row, "IsAgreement"),
                    Period = GetValue(row, "Period"),
                    DateOfAgreement = GetValue(row, "DateOfAgreement"),
                    AgreementExpiraryDate = GetValue(row, "AgreementExpiraryDate"),

                    OfficialEmailID = GetValue(row, "OfficialEmailID"),
                    BankName = GetValue(row, "BankName"),
                    BankIFSC = GetValue(row, "IFSCCode"),
                    BankAccNo = GetValue(row, "BankAccNo"),
                    AadharNo = GetValue(row, "AadharNo"),
                    UAN = GetValue(row, "UAN"),
                    ESICNo = GetValue(row, "ESICNo"),
                    PFNo = GetValue(row, "PFNo"),

                    WeeklyHoliday = GetValue(row, "WeeklyHoliday"),
                    WeeklyHolidayName = GetValue(row, "WeeklyHolidayName"),
                    EmployeeType = GetValue(row, "EmployeeType"),
                    Domain = GetValue(row, "Domain"),
                    DomainName = GetValue(row, "DomainName"),
                    SubDomain = GetValue(row, "SubDomain"),
                    DailyTaskProductivity = GetValue(row, "DailyTaskProductivity"),
                    UWExp = GetValue(row, "UWExp"),
                    IncMonth = GetValue(row, "IncMonth"),
                    IncYear = GetValue(row, "IncYear"),
                    IsPolicy = GetValue(row, "IsPolicy"),
                    JobType = GetValue(row, "JobType")
                };
            }
        }

        private static string GetValue(DataRow row, string columnName)
        {
            if (row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value)
            {
                return row[columnName].ToString();
            }

            return "";
        }

        private static int GetInt(DataRow row, string columnName)
        {
            int value = 0;

            if (row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value)
            {
                int.TryParse(row[columnName].ToString(), out value);
            }

            return value;
        }
    }
}
