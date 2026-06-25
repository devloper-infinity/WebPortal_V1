using Microsoft.Office.Interop.Word;
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
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ViewBirthdayMessages : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllBirthdaysMessages(int EmployeeID)
        {
            if (EmployeeID == 0)
                EmployeeID = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            System.Data.DataTable dt1 = new bllMaster().GetAllBirthdayMessages(EmployeeID);
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
        public static int SendBirthdayWish(string message, int EmployeeID)
        {
            int ReturnValue;
            string senderCode = HttpContext.Current.User.Identity.Name;
            string Code = new dalMaster().GetCodeFromEmployeeId(EmployeeID);

            ReturnValue =  new bllMaster().InsertBirthdayMessage(message, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), Code);

            return ReturnValue;
        }
    }
}