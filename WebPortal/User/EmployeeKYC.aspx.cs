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

namespace WebPortal.User
{
    public partial class EmployeeKYC : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string getEmployeeKYCInfo()
        {
            string Code = Convert.ToString(new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString())));
            DataTable dt1 = new bllMaster().GetKYCInfoByEmployee(Code);
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
        public static int InsertFamilyInfo(string Name, string Relation, string Occupation, string DOB)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("EmployeeID", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            htParam.Add("Name", Name.ToUpper());
            htParam.Add("Relation", Relation);
            htParam.Add("Profession", Occupation);
            htParam.Add("Age", DOB);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllMaster().InsertFamilyInfo(htParam);
            return returnvalue;
        }
        [WebMethod]
        public static int DeleteFamilyInfo(int familyInfoID)
        {
            int returnvalue = 0;
            returnvalue = new bllMaster().deleteFamilyInfo(familyInfoID);
            return returnvalue;
        }
    }
}