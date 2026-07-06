using Spire.Xls;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ClientHolidayMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetUsersByFilters(List<int> domainIds, List<int> locationIds, List<int> departmentIds, List<string> shiftIds)
        {
            return GetUsersFromDB(domainIds, locationIds, departmentIds, shiftIds);
        }

        public static List<Dictionary<string, object>> GetUsersFromDB(List<int> domainIds, List<int> locationIds, List<int> departmentIds, List<string> shiftIds)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            string domain = string.Join(",", domainIds);
            string location = string.Join(",", locationIds);
            string department = string.Join(",", departmentIds);
            string shift = string.Join(",", shiftIds);

            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("GetUsersByFilters", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@DomainIds", domain);
                    cmd.Parameters.AddWithValue("@LocationIds", location);
                    cmd.Parameters.AddWithValue("@DepartmentIds", department);
                    cmd.Parameters.AddWithValue("@ShiftIds", shift);

                    con.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Dictionary<string, object> row = new Dictionary<string, object>();

                            for (int i = 0; i < dr.FieldCount; i++)
                            {
                                row.Add(dr.GetName(i), dr[i]);
                            }

                            rows.Add(row);
                        }
                    }
                }
            }

            return rows;
        }


        [WebMethod]
        public static string GetHolidayList()
        {
            DataTable dt1 = new bllMaster().GetHolidayList();
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
        public static string SaveHolidayData(List<int> EmpIDs, string Date, string Remark)
        {
            try
            {
                int ReturnValue = 0;
                string msg = "";

                foreach (int empId in EmpIDs)
                {
                    ReturnValue = new bllMaster().InsertEmpHoliday(empId, Date, "", "", Remark, int.Parse(HttpContext.Current.User.Identity.Name));
                }

                if (ReturnValue > 0)
                    msg = "Holiday apply successfully!";
                else
                    msg = "Error while applying holiday.";

                return msg;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }


        public static void SaveToDatabase(List<int> empIds, string date, string remark)
        {
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            {
                con.Open();

                foreach (var empId in empIds)
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO HolidayMaster (EmployeeID, HolidayDate, Remark) VALUES (@EmpId, @Date, @Remark)", con);

                    cmd.Parameters.AddWithValue("@EmpId", empId);
                    cmd.Parameters.AddWithValue("@Date", Convert.ToDateTime(date));
                    cmd.Parameters.AddWithValue("@Remark", remark);

                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}