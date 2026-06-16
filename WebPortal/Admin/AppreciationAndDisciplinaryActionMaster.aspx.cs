using System;
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
    public partial class AppreciationAndDisciplinaryActionMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllAppreciationDisciplinary()
        {
            DataTable dt1 = new bllMaster().GetAllAppreciationDisciplinary();
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
        public static int InsertAppreciationDesceplinaryAction(string Type, string Title, string Description)
        {
            int returnvalue = 0;
            string MailFormat = Description;

            string stre = HttpUtility.HtmlEncode(Description);

            string str = Description;
            string str1 = HttpContext.Current.Server.HtmlEncode(str);
            string str2 = HttpContext.Current.Server.HtmlDecode(str);
            string s = str2;
            string NewDescription = "";
            if (s.Contains("<p>") || s.Contains("</p>") || s.Contains(" ") || s.Contains("\r\n\r\n"))
            {
                NewDescription = s.Replace("<p>", "");
                NewDescription = NewDescription.Replace("</p>", " ");
                NewDescription = NewDescription.Replace("\r\n\r\n", " ");
                NewDescription = NewDescription.Replace(" ", " ");
            }
            returnvalue = new bllMaster().InsertAppreciationDisciplinary(Type, Title, NewDescription, Description, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            return returnvalue;
        }
    }
}