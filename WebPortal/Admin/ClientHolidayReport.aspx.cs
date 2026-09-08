using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ClientHolidayReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetClientHolidayReport(string HolidayFor, string Year)
        {
            int yearNo;
            if (!int.TryParse(Year, out yearNo) || yearNo < 1900 || yearNo > 2100)
                throw new ArgumentException("Please select a valid year.");
            if (string.IsNullOrWhiteSpace(HolidayFor) || HolidayFor.Length > 500)
                throw new ArgumentException("Please select a valid holiday.");

            DataTable table = new DataTable();
            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand("usp_GetEmployeeHolidaysList", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Holiday", SqlDbType.NVarChar, 500).Value = HolidayFor;
                command.Parameters.Add("@Year", SqlDbType.NVarChar, 5).Value = yearNo.ToString(CultureInfo.InvariantCulture);
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    adapter.Fill(table);
                }
            }

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                row.Add("SrNo", rows.Count + 1);
                foreach (DataColumn column in table.Columns)
                {
                    object value = dataRow[column];
                    row.Add(column.ColumnName, value == DBNull.Value ? "" :
                        value is DateTime ? ((DateTime)value).ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) : value);
                }
                rows.Add(row);
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(rows);
        }
    }
}
