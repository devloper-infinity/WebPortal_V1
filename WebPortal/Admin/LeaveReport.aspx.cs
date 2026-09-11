using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class LeaveReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetLeaveReport(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetLeaveDetails(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();/*GetLeaveReport*/
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }


        [WebMethod]
        public static string GetLeaveDetails_ByCode(string FromDate, string ToDate, string Code)
        {
            DataTable dt1 = new bllMaster().GetLeaveDetails_ByCode(FromDate, ToDate, Code);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }


        [WebMethod]
        public static string GetUserWiseLeaveDetails(string FromDate, string ToDate)
        {
            DataSet ds = new bllMaster().GetUserWiseLeaveDetails(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name));

            List<Dictionary<string, object>> table1Data = new List<Dictionary<string, object>>();
            if (ds != null && ds.Tables.Count > 0)
            {
                DataTable dt1 = ds.Tables[0];
                foreach (DataRow dr in dt1.Rows)
                {
                    var row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    table1Data.Add(row);
                }
            }

            List<Dictionary<string, object>> table2Data = new List<Dictionary<string, object>>();
            if (ds != null && ds.Tables.Count > 1)
            {
                DataTable dt2 = ds.Tables[1];

                List<string> distinctMonths = new List<string>();
                foreach (DataRow dr in dt2.Rows)
                {
                    string m = dr["Month"]?.ToString();
                    if (!string.IsNullOrEmpty(m) && !distinctMonths.Contains(m))
                    {
                        distinctMonths.Add(m);
                    }
                }
                distinctMonths = distinctMonths
                        .OrderBy(m => DateTime.TryParseExact("01-" + m, "dd-MMM-yy", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out DateTime dt) ? dt : DateTime.MinValue)
                        .ToList();
                List<string> distinctEmployees = new List<string>();
                foreach (DataRow dr in dt2.Rows)
                {
                    string emp = dr["Employee Name"]?.ToString();
                    if (!string.IsNullOrEmpty(emp) && !distinctEmployees.Contains(emp))
                    {
                        distinctEmployees.Add(emp);
                    }
                }

                foreach (string empName in distinctEmployees)
                {
                    var row = new Dictionary<string, object>();
                    row.Add("EmployeeName", empName);

                    foreach (string month in distinctMonths)
                    {
                        int totalLeave = 0;
                        int paidLeave = 0;
                        int unpaidLeave = 0;

                        foreach (DataRow dr in dt2.Rows)
                        {
                            if (dr["Employee Name"]?.ToString() == empName && dr["Month"]?.ToString() == month)
                            {
                                int.TryParse(dr["Total Leave"]?.ToString(), out totalLeave);
                                int.TryParse(dr["Paid"]?.ToString(), out paidLeave);
                                int.TryParse(dr["Unpaid"]?.ToString(), out unpaidLeave);
                                break;
                            }
                        }

                        var monthDetails = new Dictionary<string, int>();
                        monthDetails.Add("Total", totalLeave);
                        monthDetails.Add("Paid", paidLeave);
                        monthDetails.Add("Unpaid", unpaidLeave);

                        row.Add(month, monthDetails);
                    }

                    table2Data.Add(row);
                }
            }

            var result = new
            {
                table1 = table1Data,
                table2 = table2Data
            };

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(result);
        }
    }
}