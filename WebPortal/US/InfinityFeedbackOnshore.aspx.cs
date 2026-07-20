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

namespace WebPortal.US
{
    public partial class InfinityFeedbackOnshore : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllFeedbackByDateRange_NewFormatOnshore(string FromDate, string ToDate)
        {
            FromDate = (Convert.ToDateTime(FromDate)).ToString("dd-MMM-yyyy");
            ToDate = (Convert.ToDateTime(ToDate)).ToString("dd-MMM-yyyy");

            DataTable dt1 = new bllUS().GetAllFeedbackByDateRange_NewFormat_Onshore(FromDate, ToDate);

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
        public static string SaveInfinityOnshoreRemark(int FeedbackID, string Client, string Remark, string RebuttalStatus)
        {
            try
            {
                if (FeedbackID <= 0)
                {
                    return "Error: Feedback row is not valid.";
                }

                Remark = (Remark ?? string.Empty).Trim();
                if (Remark == string.Empty)
                {
                    return "Error: Please enter remark.";
                }

                int addedBy = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
                int result = new bllUS().SaveInfinityOnshoreRemark(FeedbackID, Client, Remark, RebuttalStatus, addedBy);

                if (result > 0)
                {
                    return "Remark saved successfully.";
                }

                return "Error: Remark not saved.";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string GetUserInfo()
        {
            DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
    }
}