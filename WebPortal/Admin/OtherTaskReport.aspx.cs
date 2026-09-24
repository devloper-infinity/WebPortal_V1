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
        public static object BindOtherTaskReport(string FromDate, string ToDate)
        {
            int currentEmployeeId = int.Parse(HttpContext.Current.User.Identity.Name);

            int IsPm = new bllMaster().CheckIfPM(currentEmployeeId);

            int EmployeeID = IsPm == 1 ? 0 : currentEmployeeId;

            try
            {
                DataTable dt = new bllMaster().GetOtherTaskReport(FromDate,ToDate,EmployeeID);

                var rows = new List<Dictionary<string, object>>();

                foreach (DataRow dataRow in dt.Rows)
                {
                    var row =new Dictionary<string, object>();

                    foreach (DataColumn column in dt.Columns)
                    {
                        row[column.ColumnName] =dataRow[column] == DBNull.Value? "": dataRow[column];
                    }

                    rows.Add(row);
                }

                return rows;
            }
            catch (Exception ex)
            {
                throw new Exception("Unable to load Other Task Report: "+ ex.Message);
            }
        }
    }
}