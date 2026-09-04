using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class EmployeeLogReport : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindEmployees();
            }
        }

        private void BindEmployees()
        {
            DataTable employees = new bllMaster().GetAllEmployeeDetails();
            List<ListItem> items = new List<ListItem>();

            if (employees != null)
            {
                foreach (DataRow row in employees.Rows)
                {
                    string code = Convert.ToString(row["Code"]).Trim();
                    if (code.Length == 0)
                    {
                        continue;
                    }

                    string firstName = Convert.ToString(row["CodeFullName"]).Trim();
                    //string lastName = Convert.ToString(row["lastName"]).Trim();
                    string fullName = (firstName).Trim();
                    items.Add(new ListItem(fullName, code));
                }
            }

            items.Sort(delegate(ListItem left, ListItem right)
            {
                return StringComparer.OrdinalIgnoreCase.Compare(left.Text, right.Text);
            });

            ddlEmployee.Items.Clear();
            ddlEmployee.Items.Add(new ListItem("-- Select Employee --", ""));
            ddlEmployee.Items.AddRange(items.ToArray());
        }

        [WebMethod]
        public static string BindLogDetails(string Code, string FromMonth, string ToMonth)
        {
            if (string.IsNullOrWhiteSpace(Code))
            {
                throw new ArgumentException("Employee is required.");
            }

            bool hasFrom = !string.IsNullOrWhiteSpace(FromMonth);
            bool hasTo = !string.IsNullOrWhiteSpace(ToMonth);
            if (hasFrom != hasTo)
            {
                throw new ArgumentException("Select both From Month-Year and To Month-Year, or leave both blank.");
            }

            DateTime from;
            DateTime to;
            if (!hasFrom)
            {
                to = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
                from = to.AddMonths(-2);
            }
            else
            {
                if (!DateTime.TryParseExact(FromMonth, "yyyy-MM", CultureInfo.InvariantCulture, DateTimeStyles.None, out from) ||
                    !DateTime.TryParseExact(ToMonth, "yyyy-MM", CultureInfo.InvariantCulture, DateTimeStyles.None, out to))
                {
                    throw new ArgumentException("Month-Year values are invalid.");
                }
                if (from > to)
                {
                    throw new ArgumentException("From Month-Year must be earlier than or equal to To Month-Year.");
                }
            }

            bllMaster master = new bllMaster();
            int employeeId = master.GetEmployeeIdFromCode(Code.Trim());
            if (employeeId <= 0)
            {
                throw new ArgumentException("The selected employee is invalid.");
            }

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            for (DateTime month = from; month <= to; month = month.AddMonths(1))
            {
                DataTable logs = master.GetAllDailyLogs_Monthwise(
                    employeeId,
                    month.ToString("MMMM", CultureInfo.InvariantCulture),
                    month.Year.ToString(CultureInfo.InvariantCulture));

                if (logs == null)
                {
                    continue;
                }

                foreach (DataRow dataRow in logs.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn column in logs.Columns)
                    {
                        row[column.ColumnName] = dataRow[column] == DBNull.Value ? "" : dataRow[column];
                    }
                    rows.Add(row);
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(rows);
        }
    }
}
