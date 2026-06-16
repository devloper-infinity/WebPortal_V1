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
    public partial class HRQuestionPaper : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetHRInductionQuestions()
        {
            DataTable dt1 = new bllMaster().getHRInductionQuestionPaper(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static int InsertHRTestAnswers(string Parameters)
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
                        Hashtable htParam = new Hashtable();
                        htParam.Add("QuestionId", QuestionID);
                        htParam.Add("Answer", value);
                        htParam.Add("Status", "Completed");
                        htParam.Add("EmployeeId", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        returnvalue = new bllMaster().InsertHRAnswerSet(htParam);
                    }
                }
            }
            return returnvalue;
        }
    }
}