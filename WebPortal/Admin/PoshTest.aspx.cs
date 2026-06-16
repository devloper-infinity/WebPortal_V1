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
    public partial class PoshTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetPoshQuestions()
        {
            DataTable dt1 = new bllMaster().GetPoshQuestions();
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
        public static string GetExistanceOfPoshTest()
        {
            DataTable dt1 = new bllMaster().GetExistanceofPoshTest();
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
        public static string GetPoshTestResult()
        {
            DataTable dt1 = new bllMaster().GetPoshTestResult();
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
        public static int InsertPoshTest(string Parameters)
        {
            int returnvalue = 0;
            string[] Param1 = Parameters.Split(':');
            foreach (string params1 in Param1)
            {
                if (params1 != "")
                {
                    string[] Param2 = params1.Split('~');
                    string id = Param2[0];
                    string value = Param2[1];
                    if (value != "")
                    {
                        int QuestionID = Convert.ToInt32(id.Replace("option_", ""));
                        returnvalue = new bllMaster().InsertPoshAnswer(int.Parse(HttpContext.Current.User.Identity.Name.ToString()), QuestionID, value);
                    }
                }
            }
            return returnvalue;
        }

        [WebMethod]
        public static int SetPoshRetest()
        {
            int returnvalue = 0;
            returnvalue = new bllMaster().SetPoshRetest();
            return returnvalue;
        }
    }
}