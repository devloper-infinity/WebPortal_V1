using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class InitiateResignationPage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static Dictionary<string, object> GetFinalizeDetails(int resignationId)
        {
            Dictionary<string, object> result = new Dictionary<string, object>();
            DataTable dt = new bllMaster().GetResignationDetails(resignationId);

            if (dt == null || dt.Rows.Count == 0)
            {
                result["Found"] = false;
                return result;
            }

            DataRow row = dt.Rows[0];
            foreach (DataColumn column in dt.Columns)
            {
                result[column.ColumnName] = row[column.ColumnName];
            }

            result["Found"] = true;
            result["ResignationId"] = resignationId;

            int employeeId = ToInt(GetFirst(result, "EmployeeID", "EmployeeId"));
            if (employeeId > 0)
            {
                DataTable employee = new bllLogin().GetUserInformation(employeeId);
                if (employee != null && employee.Rows.Count > 0)
                {
                    DataRow employeeRow = employee.Rows[0];
                    SetIfMissing(result, "Code", employeeRow, "Code");
                    SetIfMissing(result, "Name", employeeRow, "FullName");
                    SetIfMissing(result, "FullName", employeeRow, "FullName");
                    SetIfMissing(result, "JoiningDate", employeeRow, "JoiningDate");
                    SetIfMissing(result, "DepartmentName", employeeRow, "DepartmentName");
                    SetIfMissing(result, "DesignationName", employeeRow, "DesignationName");
                    SetIfMissing(result, "ReportingManager", employeeRow, "ReportingManager");
                    SetIfMissing(result, "LastLoginDate", employeeRow, "LastLoginDate");
                }
            }

            return result;
        }

        [WebMethod]
        public static int SubmitStep2(int resgnationid, string status, string unitheadremark, string attritioncategory, string resignationreceivedthrough)
        {
            return Resignation.SubmitStep2(resgnationid, status, unitheadremark, attritioncategory, resignationreceivedthrough);
        }

        private static object GetFirst(Dictionary<string, object> values, params string[] keys)
        {
            foreach (string key in keys)
            {
                if (values.ContainsKey(key) && values[key] != null && values[key] != DBNull.Value)
                {
                    return values[key];
                }
            }

            return null;
        }

        private static int ToInt(object value)
        {
            int parsed;
            return int.TryParse(Convert.ToString(value), out parsed) ? parsed : 0;
        }

        private static void SetIfMissing(Dictionary<string, object> values, string key, DataRow row, string columnName)
        {
            if (!row.Table.Columns.Contains(columnName))
            {
                return;
            }

            if (!values.ContainsKey(key) || values[key] == null || values[key] == DBNull.Value || string.IsNullOrWhiteSpace(Convert.ToString(values[key])))
            {
                values[key] = row[columnName];
            }
        }
    }
}
