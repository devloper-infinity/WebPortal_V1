using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class BranchAndDateWiseAttendanceReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetBranchAndDateWiseAttendanceReport(string Month, string Year)
        {
            DataTable dt = new bllMaster().GetBranchAndDateWiseAttendance(Month, Year);
            return SerializeResult(dt);
        }

        private static string SerializeResult(DataTable dt)
        {
            AttendanceReportResult result = new AttendanceReportResult();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt != null)
            {
                foreach (DataColumn col in dt.Columns)
                {
                    result.Columns.Add(col.ColumnName);
                }

                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();

                    foreach (DataColumn col in dt.Columns)
                    {
                        object value = dr[col];

                        if (value == DBNull.Value)
                        {
                            row.Add(col.ColumnName, "");
                        }
                        else if (value is DateTime)
                        {
                            row.Add(col.ColumnName, ((DateTime)value).ToString("dd-MMM-yyyy"));
                        }
                        else
                        {
                            row.Add(col.ColumnName, value);
                        }
                    }

                    rows.Add(row);
                }
            }

            result.Rows = rows;

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(result);
        }

        private class AttendanceReportResult
        {
            public AttendanceReportResult()
            {
                Columns = new List<string>();
                Rows = new List<Dictionary<string, object>>();
            }

            public List<string> Columns { get; set; }
            public List<Dictionary<string, object>> Rows { get; set; }
        }
    }
}
