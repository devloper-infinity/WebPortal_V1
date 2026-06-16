using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.DAL;

namespace WebPortal.Accounts
{
    public partial class CompareReportDueSalary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetCompareDueReport(string CurrentMonth,string CurrentYear,string PreviousMonth,string PreviousYear)
        {
            DataTable dt = new DataTable();

            string conStr = SQLHelper.ConnectionString;

            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand("usp_getCompareReportDue_Display", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@CurrentMonth", CurrentMonth);
                    cmd.Parameters.AddWithValue("@CurrentYear", CurrentYear);
                    cmd.Parameters.AddWithValue("@PreviousMonth", PreviousMonth);
                    cmd.Parameters.AddWithValue("@PreviousYear", PreviousYear);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            return JsonConvert.SerializeObject(dt);
        }

        [WebMethod]
        public static string GetCompareNetReport(string CurrentMonth, string CurrentYear, string PreviousMonth, string PreviousYear)
        {
            DataTable dt = new DataTable();

            string conStr = SQLHelper.ConnectionString;

            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand("usp_getCompareReportNet_Display", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@CurrentMonth", CurrentMonth);
                    cmd.Parameters.AddWithValue("@CurrentYear", CurrentYear);
                    cmd.Parameters.AddWithValue("@PreviousMonth", PreviousMonth);
                    cmd.Parameters.AddWithValue("@PreviousYear", PreviousYear);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            return JsonConvert.SerializeObject(dt);
        }
    }
}