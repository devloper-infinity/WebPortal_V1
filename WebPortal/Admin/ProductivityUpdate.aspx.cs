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
    public partial class ProductivityUpdate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetProductivityForUpdate(string FromDate, string ToDate)
        {
            DataTable dt1 = new bllMaster().GetProductivityForUpdate(FromDate, ToDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static int UpdateVolumeData(string Code, string Project, string Process, string ProcessDate, string VolumeData, string Remark, string Type, bool Checked)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("Code", Code);
            htParam.Add("Project", Project);
            htParam.Add("Process", Process);
            htParam.Add("ProcessDate", ProcessDate);
            htParam.Add("VolumeData", VolumeData);
            htParam.Add("Checked", Checked);
            htParam.Add("Remark", Remark);
            htParam.Add("Type",Type);
            returnvalue = new bllMaster().InsertDailyProductionRemark(htParam);
            return returnvalue;
        }
    }
}