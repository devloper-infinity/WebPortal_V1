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
    public partial class LoanLevelHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string GetProjects()
        {
            try
            {
                DataTable dt = new bllMaster().GetAllProjectByUserRights(HttpContext.Current.User.Identity.Name.ToString());

                return SerializeTable(dt);
            }
            catch (Exception ex)
            {
                return "[]";
            }
        }


        #region Loan Tracking History

        [WebMethod]
        public static object GetLoanTrackingHistory(
            string ProjectID,
            string FromDate,
            string ToDate,
            int draw,
            int start,
            int length,
            string searchValue)
        {
            try
            {
                start = Math.Max(0, start);
                length = Math.Max(10, Math.Min(length, 500));

                Hashtable ht = new Hashtable();

                ht.Add("ProjectID", ProjectID);
                ht.Add("FromDate", FromDate);
                ht.Add("ToDate", ToDate);
                ht.Add("Start", start);
                ht.Add("PageSize", length);
                ht.Add("SearchValue", searchValue ?? string.Empty);

                DataSet ds = new bllMaster().GetLoanTrackingHistory(ht);
                DataTable countTable = ds != null && ds.Tables.Count > 0 ? ds.Tables[0] : null;
                DataTable pageTable = ds != null && ds.Tables.Count > 1 ? ds.Tables[1] : null;
                int totalRecords = countTable != null && countTable.Rows.Count > 0
                    ? Convert.ToInt32(countTable.Rows[0]["TotalRecords"])
                    : 0;

                return new
                {
                    draw = draw,
                    recordsTotal = totalRecords,
                    recordsFiltered = totalRecords,
                    columns = pageTable == null
                        ? new List<string>()
                        : pageTable.Columns.Cast<DataColumn>().Select(c => c.ColumnName).ToList(),
                    data = ToRows(pageTable)
                };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Loan tracking history failed: {0}", ex);
                return new
                {
                    draw = draw,
                    recordsTotal = 0,
                    recordsFiltered = 0,
                    columns = new List<string>(),
                    data = new List<Dictionary<string, object>>(),
                    error = "Unable to load loan tracking history."
                };
            }
        }

        #endregion

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            if (table == null)
                return new List<Dictionary<string, object>>();

            return table.AsEnumerable()
                .Select(row => table.Columns.Cast<DataColumn>().ToDictionary(
                    column => column.ColumnName,
                    column => row[column] == DBNull.Value ? null : row[column]))
                .ToList();
        }

        #region Dynamic Table Serializer

        private static string SerializeDynamicTable(DataTable dt)
        {
            JavaScriptSerializer js = new JavaScriptSerializer();
            js.MaxJsonLength = Int32.MaxValue;

            var result = new
            {
                Columns = dt.Columns
                            .Cast<DataColumn>()
                            .Select(c => c.ColumnName)
                            .ToList(),

                Data = dt.AsEnumerable()
                         .Select(row =>
                            dt.Columns.Cast<DataColumn>()
                              .ToDictionary(
                                    col => col.ColumnName,
                                    col => row[col]))
                         .ToList()
            };

            return js.Serialize(result);
        }

        #endregion

        #region Standard Serializer

        private static string SerializeTable(DataTable table)
        {
            List<Dictionary<string, object>> rows =
                new List<Dictionary<string, object>>();

            if (table != null)
            {
                foreach (DataRow dr in table.Rows)
                {
                    Dictionary<string, object> row =
                        new Dictionary<string, object>();

                    foreach (DataColumn col in table.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }

                    rows.Add(row);
                }
            }

            JavaScriptSerializer ser =
                new JavaScriptSerializer();

            ser.MaxJsonLength = int.MaxValue;

            return ser.Serialize(rows);
        }

        #endregion
    }
}
