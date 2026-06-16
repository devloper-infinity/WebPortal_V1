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
    public partial class LoanDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetLoanDetails_RemoteUW_REQC()
        {
            DataTable dt1 = new bllUS().GetLoanDetails_RemoteUW_REQC(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

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
        public static int InsertModifyUWOrderOC22Servicing(string ProjectNumber, string DealNo, string OrderNumber, string Process, string Review, string StartTime, string EndTime)
        {
            int ReturnValue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectNumber", ProjectNumber);
            htParam.Add("DealNo", DealNo);
            htParam.Add("OrderNumber", OrderNumber);
            htParam.Add("Process", Process);
            htParam.Add("Review", Review);
            htParam.Add("ReviewStartTime", StartTime.Replace("T", " "));
            htParam.Add("ReviewEndTime", EndTime.Replace("T", " "));
            htParam.Add("Type", "Default");
            htParam.Add("ProductType", "Complete");
            htParam.Add("Status", "Completed");
            htParam.Add("Remark", "online");
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue =  new bllUS().InsertModifyUWOrderOC22Servicing(htParam);

            return ReturnValue;
        }

    }
}