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
    public partial class StampPaperInformation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllEmployees()
        {
            DataTable dt1 = new bllMaster().GetAllUsers_1();
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
        public static string BindStampPaperInformation()
        {
            DataTable dt1 = new bllMaster().GetStampPaperInfo("");
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
        public static int InsertStampPaperInfo(string Code, string PaperType, string StampPaperNo, string StampPaperCost, string Version, int StampPaperUsed, string ReceivedDate, string Remark)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("Code", Code.Substring(0, 3));
            htParam.Add("PaperType", PaperType);
            htParam.Add("StampPaperNo", StampPaperNo);
            htParam.Add("StampPaperCost", StampPaperCost);
            htParam.Add("Version", Version);
            htParam.Add("StampPaperUsed", StampPaperUsed);
            htParam.Add("ReceivedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("ReceivedDate", Convert.ToDateTime(ReceivedDate).ToString("dd-MMM-yyyy"));
            htParam.Add("Remark", Remark);
            returnvalue = new bllMaster().InsertStampPaperInfo(htParam);
            return returnvalue;
        }
    }
}