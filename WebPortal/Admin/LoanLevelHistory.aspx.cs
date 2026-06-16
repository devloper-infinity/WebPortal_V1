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
        public static string GetLoanTrackingHistory(
            string ProjectID,
            string FromDate,
            string ToDate)
        {
            try
            {
                Hashtable ht = new Hashtable();

                ht.Add("ProjectID", ProjectID);
                ht.Add("FromDate", FromDate);
                ht.Add("ToDate", ToDate);

                DataTable dt = new DataTable();
                dt = new bllMaster().GetLoanTrackingHistory(ht);
                /*
                 * KEEP SP NAME BLANK FOR NOW
                 *
                 * Example:
                 *
                
                 *
                 */
                return dt != null ? SerializeTable(dt) : "[]";
                //return SerializeDynamicTable(dt);
            }
            catch (Exception ex)
            {
                return "{}";
            }
        }

        #endregion

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