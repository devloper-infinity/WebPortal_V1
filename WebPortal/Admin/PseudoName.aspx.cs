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
    public partial class PseudoName : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllPsuedoName()
        {
            DataTable dt1 = new bllMaster().GetAllPsuedoName();
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
        public static string GetAllUsersUpdatePsuedoName()
        {
            DataTable dt1 = new bllMaster().GetAllUsersUpdatePsuedoName();
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
        public static int InseartPsuedoName(string Code, string Pname, string Company, string Location)
        {
            int ReturnValue = 0;
            Hashtable htuser = new Hashtable();
            DataTable dt = new bllMaster().GetAllUsersUpdatePsuedoNamebyCode(Code);
            if (dt.Rows.Count > 0)
            {
                string DataSource = Convert.ToString(dt.Rows[0]["DataSource"]);
                if (DataSource == "CUS")
                {
                    htuser["Code"] = "";
                    htuser["Name"] = dt.Rows[0]["FullName"];
                    htuser["EmployeeID"] = Code;
                }
                else
                {
                    htuser["Code"] = Code;
                    htuser["Name"] = dt.Rows[0]["FullName"];
                    htuser["EmployeeID"] = dt.Rows[0]["EmployeeID"];
                }

                htuser["PsuedoName"] = Pname;
                htuser["Location"] = Location;
                htuser["Company"] = Company;
                htuser["DataSource"] = DataSource;
                htuser["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                ReturnValue = new bllMaster().InseartPsuedoName(htuser);
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int DeletePsuedoName(int EmpConfigrationID)
        {
            int ReturnVal;
            Hashtable htuser = new Hashtable();
            htuser["EmpConfigrationID"] = EmpConfigrationID;
            htuser["DeletedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            ReturnVal = new bllMaster().DeletePsuedoName(htuser);
            return ReturnVal;
        }
    }
}