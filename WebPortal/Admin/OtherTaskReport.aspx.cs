using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;




namespace WebPortal.Admin
{
    public partial class OtherTaskReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string BindOtherTaskReport(string FromDate, string ToDate)
        {
            int EmployeeID = 0;

            int IsPm = new bllMaster().CheckIfPM(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            if (IsPm == 1)
                EmployeeID = 0;
            else
                EmployeeID = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

            string data = string.Empty;
            try
            {
                DataTable dt = new bllMaster().GetOtherTaskReport(FromDate, ToDate, EmployeeID);

                var rows = new List<Dictionary<string, object>>();

                foreach (DataRow dataRow in dt.Rows)
                {
                    var row = new Dictionary<string, object>();

                    foreach (DataColumn column in dt.Columns)
                    {
                        row[column.ColumnName] = dataRow[column] == DBNull.Value ? "" : dataRow[column];
                    }

                    rows.Add(row);
                }

                return new JavaScriptSerializer().Serialize(rows);
            }
            catch (Exception ex)
            {
                throw new Exception("Unable to load Other Task Report: " + ex.Message);
            }

        }
    }
}