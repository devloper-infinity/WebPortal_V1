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
    public partial class AbscondingEmployeeFollowup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetFollowupRecords(string Month, string Year)
        {
            DataTable dt1 = new bllMaster().GetAbscondedEmployeesFollowup(Month, Year);
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
        public static int InsertAbscondedEmpsFollowUp(int ResignationID, int EmployeeID, string Remark, string Date)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("ResignationID", ResignationID);
            htParam.Add("EmployeeID", EmployeeID);
            htParam.Add("Remark", Remark);
            htParam.Add("Date", Convert.ToDateTime(Date).ToString("dd-MMM-yyyy"));
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertAbscondedEmpsFollowUp(htParam);
            return returnvalue;
        }


    }
}