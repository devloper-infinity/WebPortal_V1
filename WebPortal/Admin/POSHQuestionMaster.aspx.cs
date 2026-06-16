using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class POSHQuestionMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int InsertQuestionSet_POSH(string Question, string Section, string Weightage, string Option1, string Option2, string Option3, string Option4, string CorrectAnswer)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("Question", Question);
            htParam.Add("Section", Section);
            htParam.Add("Weightage", Weightage);
            htParam.Add("Answer1", Option1);
            htParam.Add("Answer2", Option2);
            htParam.Add("Answer3", Option3);
            htParam.Add("Answer4", Option4);
            htParam.Add("CorrectAnswer", CorrectAnswer);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            returnvalue = new bllMaster().InsertPOSHQuestion(htParam);

            return returnvalue;
        }

        [WebMethod]
        public static string GetAllPOSHQuestion()
        {
            DataTable dt1 = new bllMaster().GetAllPOSHQuestion();
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
        public static string GetPOSHQuestionSection()
        {
            DataTable dt1 = new bllMaster().GetPOSHQuestionSection();
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
    }
}