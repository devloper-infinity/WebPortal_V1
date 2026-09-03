using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.FTE
{
    public partial class FTEEntry : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetTop50FTEEntry(int ProjectID, int ProcessID)
        {
            DataTable dt1 = new bllMaster().GetTop50FTEEntry(ProjectID, ProcessID);

            List<Dictionary<string, object>> columns = new List<Dictionary<string, object>>();
            Dictionary<string, object> column;

            if (dt1 != null)
            {
                foreach (DataColumn dc in dt1.Columns)
                {
                    column = new Dictionary<string, object>();
                }
            }

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetApprovedFTECount(int ProjectID, int ProcessID)
        {
            if (ProjectID <= 0 || ProcessID <= 0)
            {
                return string.Empty;
            }

            DataTable dt = new bllMaster().GetFTEDetails();

            if (dt == null)
            {
                return string.Empty;
            }

            foreach (DataRow row in dt.Rows)
            {
                int rowProjectID = ToInt(GetColumnValue(row, "ProjectID", "ProjectId"));
                int rowProcessID = ToInt(GetColumnValue(row, "ProcessID", "ProcessId"));

                if (rowProjectID == ProjectID && rowProcessID == ProcessID)
                {
                    return Convert.ToString(GetColumnValue(row, "ApprovedFTECount", "ApprovedCount"));
                }
            }

            return string.Empty;
        }

        [WebMethod]
        public static int InsertFTEEntry(int ProjectID, int ProcessID, string ApprovedFTECount, string Date, string ActualTotalFteCnt, string AverageFTE)
        {
            int ReturnValue = 0;

            if (ProjectID <= 0 || ProcessID <= 0 || string.IsNullOrWhiteSpace(ApprovedFTECount) || string.IsNullOrWhiteSpace(Date) || string.IsNullOrWhiteSpace(ActualTotalFteCnt))
            {
                return ReturnValue;
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", ProjectID);
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("ApprovedCount", ApprovedFTECount);
            htParam.Add("Date", Date);
            htParam.Add("ActualCount", ActualTotalFteCnt);
            decimal averageFte;
            htParam.Add("AverageFTE", decimal.TryParse(AverageFTE, out averageFte) ? (object)averageFte : DBNull.Value);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllMaster().InsertFTEEntry(htParam);
            if (ReturnValue > 0)
            {

            }
            return ReturnValue;
        }

        private static object GetColumnValue(DataRow row, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
            {
                if (row.Table.Columns.Contains(columnName) && row[columnName] != DBNull.Value)
                {
                    return row[columnName];
                }
            }

            return null;
        }

        private static int ToInt(object value)
        {
            int result;
            return int.TryParse(Convert.ToString(value), out result) ? result : 0;
        }
    }
}
