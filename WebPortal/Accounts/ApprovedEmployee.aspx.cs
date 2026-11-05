using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Accounts
{
    public partial class ApprovedEmployee : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod(EnableSession = true)]
        public static ApprovedEmployeeResult GetEmployee(string code)
        {
            code = (code ?? string.Empty).Trim();
            if (code.Length == 0) throw new ArgumentException("Employee code is required.");

            int employeeId = new bllMaster().GetEmployeeIdFromCode(code);
            DataTable details = new bllLogin().GetUserInformation(employeeId);
            if (details == null || details.Rows.Count == 0) throw new InvalidOperationException("Employee details were not found.");

            Dictionary<string, object> employee = ToRow(details.Rows[0]);
            string firstName = Convert.ToString(Value(details.Rows[0], "FirstName"));
            string lastName = Convert.ToString(Value(details.Rows[0], "LastName"));
            string birthDate = Convert.ToString(Value(details.Rows[0], "DateOfBirth"));
            DataTable matches = new bllSalary().CheckUserRejoinee(firstName, lastName, birthDate, code);
            return new ApprovedEmployeeResult { Employee = employee, Matches = ToRows(matches) };
        }

        [WebMethod(EnableSession = true)]
        public static ApprovalResult Approve(string code, string approvedDate, string remark, string joiningType, string oldCode, string[] answers)
        {
            code = (code ?? string.Empty).Trim();
            remark = (remark ?? string.Empty).Trim();
            joiningType = (joiningType ?? string.Empty).Trim();
            oldCode = (oldCode ?? string.Empty).Trim();
            answers = answers ?? new string[0];

            DateTime approvalDate;
            if (code.Length == 0) throw new ArgumentException("Employee code is required.");
            if (!DateTime.TryParseExact(approvedDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out approvalDate)) throw new ArgumentException("Select a valid approval date.");
            if (remark.Length == 0) throw new ArgumentException("Approval remark is required.");
            if (joiningType != "New" && joiningType != "Rejoining") throw new ArgumentException("Select a valid joining type.");
            if (answers.Any(x => (x ?? string.Empty).Length > 4000) || remark.Length > 4000) throw new ArgumentException("Remarks and answers cannot exceed 4000 characters.");

            int employeeId = new bllMaster().GetEmployeeIdFromCode(code);
            DataTable details = new bllLogin().GetUserInformation(employeeId);
            if (details == null || details.Rows.Count == 0) throw new InvalidOperationException("Employee details were not found.");

            DateTime joiningDate;
            if (DateTime.TryParse(Convert.ToString(Value(details.Rows[0], "JoiningDate")), out joiningDate) && approvalDate.Date < joiningDate.Date)
                throw new ArgumentException("Approval date cannot be earlier than the joining date.");

            string firstName = Convert.ToString(Value(details.Rows[0], "FirstName"));
            string lastName = Convert.ToString(Value(details.Rows[0], "LastName"));
            string birthDate = Convert.ToString(Value(details.Rows[0], "DateOfBirth"));
            DataTable matches = new bllSalary().CheckUserRejoinee(firstName, lastName, birthDate, code);
            if (matches != null && matches.Rows.Count > 0)
            {
                bool validOldCode = oldCode.Length > 0 && matches.AsEnumerable().Any(r => string.Equals(Convert.ToString(Value(r, "Code")), oldCode, StringComparison.OrdinalIgnoreCase));
                if (!validOldCode) throw new ArgumentException("Select a valid matching old employee code.");
                HttpContext.Current.Session["OldCode"] = oldCode;
            }

            if (joiningType == "Rejoining" && (answers.Length < 6 || answers.Take(6).Any(x => string.IsNullOrWhiteSpace(x))))
                throw new ArgumentException("Answer all rejoining questions.");

            int approvedBy;
            if (!int.TryParse(HttpContext.Current.User.Identity.Name, out approvedBy)) throw new InvalidOperationException("Your signed-in employee identity is invalid.");
            string[] a = Enumerable.Range(0, 6).Select(i => i < answers.Length ? (answers[i] ?? string.Empty).Trim() : string.Empty).ToArray();
            int result = new bllMaster().UpdateEmployeeInfoForApproved(code, approvalDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture), remark, approvedBy, joiningType, a[0], a[1], a[2], a[3], a[4], a[5]);
            if (result <= 0) throw new InvalidOperationException("The employee could not be approved. The record may already have been processed.");
            return new ApprovalResult { Success = true, Message = "Employee approved successfully." };
        }

        private static object Value(DataRow row, string column) { return row.Table.Columns.Contains(column) && row[column] != DBNull.Value ? row[column] : null; }
        private static Dictionary<string, object> ToRow(DataRow row)
        {
            var item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
            foreach (DataColumn column in row.Table.Columns)
            {
                object value = row[column];
                item[column.ColumnName] = value == DBNull.Value ? null : value is DateTime ? ((DateTime)value).ToString("dd-MMM-yyyy") : value;
            }
            string title = Convert.ToString(Value(row, "Title"));
            string first = Convert.ToString(Value(row, "FirstName"));
            string middle = Convert.ToString(Value(row, "MiddleName"));
            string last = Convert.ToString(Value(row, "LastName"));
            item["EmployeeName"] = string.Join(" ", new[] { title, first, middle, last }.Where(x => !string.IsNullOrWhiteSpace(x)));
            return item;
        }
        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            var rows = new List<Dictionary<string, object>>();
            if (table != null) foreach (DataRow row in table.Rows) rows.Add(ToRow(row));
            return rows;
        }
    }

    public class ApprovedEmployeeResult
    {
        public Dictionary<string, object> Employee { get; set; }
        public List<Dictionary<string, object>> Matches { get; set; }
    }
    public class ApprovalResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
    }
}
