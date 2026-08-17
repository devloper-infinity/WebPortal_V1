using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class ApproveSalaryStructure : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetPendingSalaryApprovals()
        {
            DataTable table = new bllMaster().GetAllEmployeeDetailsForApprovalofSalaryStructure();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                    row[column.ColumnName] = dataRow[column];
                rows.Add(row);
            }

            return rows;
        }

        [WebMethod]
        public static SalaryApprovalDetails GetSalaryApprovalDetails(string code)
        {
            SalaryApprovalDetails result = new SalaryApprovalDetails();
            if (String.IsNullOrWhiteSpace(code))
            {
                result.Message = "Employee code is required.";
                return result;
            }

            int employeeId = new bllMaster().GetEmployeeIdFromCode(code.Trim());
            DataTable employeeTable = new bllLogin().GetUserInformation(employeeId);
            if (employeeTable == null || employeeTable.Rows.Count == 0)
            {
                result.Message = "Employee information was not found.";
                return result;
            }

            DataRow employee = employeeTable.Rows[0];
            int salary = ToInt(employee["Salary"]);
            int basic = 0;
            int pf = 0;
            int esi = 0;
            int da = 0;
            int mr = 0;
            int ta = 0;
            int ea = 0;
            int ha = 0;
            int hra = 0;
            int professionalTax = 0;
            int netSalary = 0;
            int totalDeduction = 0;
            int daysInMonth = DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month);
            string employeeType = Text(employee, "EmployeeType");
            string gender = Text(employee, "Gender");
            bool statutoryApplicable = salary <= 21000;
            string daysDisplay = Convert.ToString(daysInMonth);

            if (salary <= 7911)
            {
                int salaryNew = 0;
                if (salary < 7911)
                {
                    salaryNew = 7911;
                }
                basic = (salary * 51) / 100;
                pf = employeeType == "Consultant" ? 0 : (basic * 12) / 100;
                esi = employeeType == "Consultant" ? 0 : Convert.ToInt32((Convert.ToDouble(salary) * 0.75) / 100);
                hra = salary - basic;
                professionalTax = GetProfessionalTax(salary, gender, employeeType);
                netSalary = (basic + da + hra + ta + mr + ha + ea) - (esi + pf + professionalTax);

                decimal revisedDays = Convert.ToDecimal(netSalary) /
                    (Convert.ToDecimal(7911) / Convert.ToDecimal(daysInMonth));
                daysDisplay += " (" + Convert.ToString(Math.Round(revisedDays, 2)) + ")";

                basic = (salaryNew * 51) / 100;
                if ((da + basic) < salaryNew)
                {
                    hra = salaryNew - basic;
                }
                totalDeduction = esi + pf + professionalTax;
            }
            else if (salary <= 21000)
            {
                basic = (salary * 51) / 100;
                pf = employeeType == "Consultant" ? 0 : (basic * 12) / 100;
                esi = employeeType == "Consultant" ? 0 : Convert.ToInt32((Convert.ToDouble(salary) * 0.75) / 100);
                hra = salary - basic;
                professionalTax = GetProfessionalTax(salary, gender, employeeType);
                netSalary = (basic + da + hra + ta + mr + ha + ea) - (esi + pf + professionalTax);
                totalDeduction = esi + pf + professionalTax;
            }
            else
            {
                basic = 16000;
                hra = salary - basic;
                professionalTax = GetProfessionalTax(salary, gender, employeeType);
                netSalary = (basic + da + hra + ta + mr + ha + ea) - professionalTax;
                totalDeduction = professionalTax;
            }

            bool nightBonusApplicable = false;
            int nightBonus = 0;
            try
            {
                nightBonusApplicable = Convert.ToInt32(Text(employee, "CutOffTime").Substring(0, 2)) >= 16 &&
                    Text(employee, "WorkingBranchName") == "AJ" && salary == 8000 &&
                    Text(employee, "DepartmentName") == "Production";
                nightBonus = nightBonusApplicable ? 1000 : 0;
            }
            catch
            {
                nightBonusApplicable = false;
                nightBonus = 0;
            }

            result.Success = true;
            result.EmployeeId = employeeId;
            result.Code = Text(employee, "Code");
            result.Name = (Text(employee, "FirstName") + " " + Text(employee, "middleName") + " " + Text(employee, "LastName")).Trim();
            result.EmployeeType = employeeType;
            result.Branch = Text(employee, "WorkingBranchName");
            result.Department = Text(employee, "DepartmentName");
            result.CutOffTime = Text(employee, "CutOffTime");
            result.ReportingManager = Text(employee, "ReportingManager");
            result.OriginalSalary = salary;
            result.GrossSalary = salary < 7911 ? 7911 : salary;
            result.Basic = basic;
            result.DA = da;
            result.MR = mr;
            result.TA = ta;
            result.EA = ea;
            result.HA = ha;
            result.HRA = hra;
            result.ESI = esi;
            result.PF = pf;
            result.ProfessionalTax = professionalTax;
            result.TotalDeduction = totalDeduction;
            result.NetSalary = netSalary;
            result.ESIApplicable = statutoryApplicable;
            result.PFApplicable = statutoryApplicable;
            result.NightBonusApplicable = nightBonusApplicable;
            result.NightBonus = nightBonus;
            result.DaysInMonth = daysDisplay;
            return result;
        }

        [WebMethod]
        public static SaveSalaryStructureResult SaveSalaryStructure(SalaryStructureRequest request)
        {
            SaveSalaryStructureResult result = new SaveSalaryStructureResult();
            if (request == null || String.IsNullOrWhiteSpace(request.Code))
            {
                result.Message = "Employee information is required.";
                return result;
            }

            if (request.Salary < 0 || request.Basic < 0 || request.HRA < 0 || request.ESIC < 0 ||
                request.PF < 0 || request.NightBonus < 0 || request.AttendanceBonus < 0 || request.QualityBonus < 0)
            {
                result.Message = "Salary values cannot be negative.";
                return result;
            }

            if (request.IsAttendanceBonusApplicable && String.IsNullOrWhiteSpace(request.AttendanceBonusType))
            {
                result.Message = "Select an attendance bonus type.";
                return result;
            }

            int employeeId = new bllMaster().GetEmployeeIdFromCode(request.Code.Trim());
            if (employeeId <= 0)
            {
                result.Message = "The selected employee could not be found.";
                return result;
            }

            Hashtable parameters = new Hashtable();
            parameters.Add("EmployeeId", employeeId);
            parameters.Add("Salary", request.Salary);
            parameters.Add("Basic", request.Basic);
            parameters.Add("DA", request.DA);
            parameters.Add("MR", request.MR);
            parameters.Add("TA", request.TA);
            parameters.Add("EA", request.EA);
            parameters.Add("HA", request.HA);
            parameters.Add("HRA", request.HRA);
            parameters.Add("Other", request.Other);
            parameters.Add("ProfTax", request.ProfTax);
            parameters.Add("isESIC", request.IsESIC);
            parameters.Add("ESIC", request.ESIC);
            parameters.Add("isPF", request.IsPF);
            parameters.Add("PF", request.PF);
            parameters.Add("isNightBonus", request.IsNightBonus);
            parameters.Add("NightBonus", request.IsNightBonus ? request.NightBonus : 0);
            parameters.Add("isExtra", request.IsExtra);
            parameters.Add("AttendanceBonusType", request.IsAttendanceBonusApplicable ? request.AttendanceBonusType : "");
            parameters.Add("AttendanceBonus", request.IsAttendanceBonusApplicable ? request.AttendanceBonus : 0);
            parameters.Add("isQualityBonusApplicable", request.IsQualityBonusApplicable);
            parameters.Add("QualityBonus", request.IsQualityBonusApplicable ? request.QualityBonus : 0);
            parameters.Add("AddedBy", Convert.ToInt32(HttpContext.Current.User.Identity.Name));

            int returnValue = new bllMaster().InsertSalaryStructure(parameters);
            result.ReturnValue = returnValue;
            result.Success = returnValue > 0;
            result.Message = result.Success
                ? "Salary structure approved successfully."
                : "Unable to approve the salary structure. Please contact the administrator.";
            return result;
        }

        private static int GetProfessionalTax(int salary, string gender, string employeeType)
        {
            if (gender == "Female")
                return salary <= 10000 ? 0 : 200;
            if (employeeType == "Consultant")
                return 0;
            if (salary <= 10000)
                return 175;
            return salary <= 1000000 ? 200 : 0;
        }

        private static int ToInt(object value)
        {
            return value == null || value == DBNull.Value ? 0 : Convert.ToInt32(value);
        }

        private static string Text(DataRow row, string column)
        {
            return row.Table.Columns.Contains(column) && row[column] != DBNull.Value
                ? Convert.ToString(row[column])
                : String.Empty;
        }

        public class SalaryApprovalDetails
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public int EmployeeId { get; set; }
            public string Code { get; set; }
            public string Name { get; set; }
            public string EmployeeType { get; set; }
            public string Branch { get; set; }
            public string Department { get; set; }
            public string CutOffTime { get; set; }
            public string ReportingManager { get; set; }
            public int OriginalSalary { get; set; }
            public int GrossSalary { get; set; }
            public int Basic { get; set; }
            public int DA { get; set; }
            public int MR { get; set; }
            public int TA { get; set; }
            public int EA { get; set; }
            public int HA { get; set; }
            public int HRA { get; set; }
            public int ESI { get; set; }
            public int PF { get; set; }
            public int ProfessionalTax { get; set; }
            public int TotalDeduction { get; set; }
            public int NetSalary { get; set; }
            public bool ESIApplicable { get; set; }
            public bool PFApplicable { get; set; }
            public bool NightBonusApplicable { get; set; }
            public int NightBonus { get; set; }
            public string DaysInMonth { get; set; }
        }

        public class SalaryStructureRequest
        {
            public string Code { get; set; }
            public int Salary { get; set; }
            public int Basic { get; set; }
            public int DA { get; set; }
            public int MR { get; set; }
            public int TA { get; set; }
            public int EA { get; set; }
            public int HA { get; set; }
            public int HRA { get; set; }
            public int Other { get; set; }
            public int ProfTax { get; set; }
            public bool IsESIC { get; set; }
            public int ESIC { get; set; }
            public bool IsPF { get; set; }
            public int PF { get; set; }
            public bool IsNightBonus { get; set; }
            public int NightBonus { get; set; }
            public bool IsExtra { get; set; }
            public bool IsAttendanceBonusApplicable { get; set; }
            public string AttendanceBonusType { get; set; }
            public int AttendanceBonus { get; set; }
            public bool IsQualityBonusApplicable { get; set; }
            public int QualityBonus { get; set; }
        }

        public class SaveSalaryStructureResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public int ReturnValue { get; set; }
        }
    }
}
