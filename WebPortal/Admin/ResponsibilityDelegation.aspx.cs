using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ResponsibilityDelegation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

             private static long LoginEmployeeID
        {
            get
            {
                long empId = 0;
                if (System.Web.HttpContext.Current != null &&
                    System.Web.HttpContext.Current.User != null &&
                    System.Web.HttpContext.Current.User.Identity != null)
                {
                    long.TryParse(System.Web.HttpContext.Current.User.Identity.Name, out empId);
                }
                return empId;
            }
        }

        [WebMethod]
        public static List<EmployeeDDL> GetEmployees()
        {
            List<EmployeeDDL> list = new List<EmployeeDDL>();

            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("usp_PMDelegation_GetEmployees", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        list.Add(new EmployeeDDL
                        {
                            EmployeeID = Convert.ToInt64(dr["EmployeeID"]),
                            Code = Convert.ToString(dr["Code"]),
                            EmployeeName = Convert.ToString(dr["EmployeeName"])
                        });
                    }
                }
            }

            return list;
        }

        [WebMethod]
        public static SaveResult SaveDelegation( long PMEmployeeID, long ActingEmployeeID, string FromDate, string ToDate, string Remark)/*long DelegationID,*/
        {
            SaveResult result = new SaveResult();

            if (PMEmployeeID <= 0)
                return new SaveResult { Success = false, Message = "Please select PM Name." };

            if (ActingEmployeeID <= 0)
                return new SaveResult { Success = false, Message = "Please select Acting PM Name." };

            if (PMEmployeeID == ActingEmployeeID)
                return new SaveResult { Success = false, Message = "PM and Acting PM cannot be same." };

            DateTime fromDt;
            DateTime toDt;

            if (!DateTime.TryParse(FromDate, out fromDt))
                return new SaveResult { Success = false, Message = "Please select valid From Date." };

            if (!DateTime.TryParse(ToDate, out toDt))
                return new SaveResult { Success = false, Message = "Please select valid To Date." };

            if (toDt.Date < fromDt.Date)
                return new SaveResult { Success = false, Message = "To Date cannot be less than From Date." };

            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("usp_PMDelegation_InsertUpdate", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                //cmd.Parameters.AddWithValue("@DelegationID", DelegationID);
                cmd.Parameters.AddWithValue("@PMEmployeeID", PMEmployeeID);
                cmd.Parameters.AddWithValue("@ActingEmployeeID", ActingEmployeeID);
                cmd.Parameters.AddWithValue("@FromDate", fromDt.Date);
                cmd.Parameters.AddWithValue("@ToDate", toDt.Date);
                cmd.Parameters.AddWithValue("@Remark", string.IsNullOrWhiteSpace(Remark) ? "" : Remark.Trim());
                cmd.Parameters.AddWithValue("@AddedBy", LoginEmployeeID);

                SqlParameter success = new SqlParameter("@Success", SqlDbType.Bit);
                success.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(success);

                SqlParameter message = new SqlParameter("@Message", SqlDbType.NVarChar, 300);
                message.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(message);

                con.Open();
                cmd.ExecuteNonQuery();

                result.Success = Convert.ToBoolean(success.Value);
                result.Message = Convert.ToString(message.Value);
            }

            return result;
        }

        [WebMethod]
        public static List<DelegationRow> GetDelegations()
        {
            List<DelegationRow> list = new List<DelegationRow>();

            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("usp_PMDelegation_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        list.Add(new DelegationRow
                        {
                            DelegationID = Convert.ToInt64(dr["DelegationID"]),
                            PMEmployeeID = Convert.ToInt64(dr["PMEmployeeID"]),
                            PMCode = Convert.ToString(dr["PMCode"]),
                            PMName = Convert.ToString(dr["PMName"]),
                            ActingEmployeeID = Convert.ToInt64(dr["ActingEmployeeID"]),
                            ActingCode = Convert.ToString(dr["ActingCode"]),
                            ActingName = Convert.ToString(dr["ActingName"]),
                            FromDate = Convert.ToString(dr["FromDateText"]),
                            ToDate = Convert.ToString(dr["ToDateText"]),
                            FromDateValue = Convert.ToDateTime(dr["FromDate"]).ToString("yyyy-MM-dd"),
                            ToDateValue = Convert.ToDateTime(dr["ToDate"]).ToString("yyyy-MM-dd"),
                            Remark = Convert.ToString(dr["Remark"]),
                            StatusText = Convert.ToString(dr["StatusText"]),
                            AddedByName = Convert.ToString(dr["AddedByName"]),
                            AddedDate = Convert.ToString(dr["AddedDateText"])
                        });
                    }
                }
            }

            return list;
        }

        [WebMethod]
        public static SaveResult DeactivateDelegation(long DelegationID)
        {
            if (DelegationID <= 0)
                return new SaveResult { Success = false, Message = "Invalid delegation selected." };

            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("usp_PMDelegation_Deactivate", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@DelegationID", DelegationID);
                cmd.Parameters.AddWithValue("@UpdatedBy", LoginEmployeeID);

                SqlParameter success = new SqlParameter("@Success", SqlDbType.Bit);
                success.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(success);

                SqlParameter message = new SqlParameter("@Message", SqlDbType.NVarChar, 300);
                message.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(message);

                con.Open();
                cmd.ExecuteNonQuery();

                return new SaveResult
                {
                    Success = Convert.ToBoolean(success.Value),
                    Message = Convert.ToString(message.Value)
                };
            }
        }

        public class EmployeeDDL
        {
            public long EmployeeID { get; set; }
            public string Code { get; set; }
            public string EmployeeName { get; set; }
        }

        public class SaveResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
        }

        public class DelegationRow
        {
            public long DelegationID { get; set; }
            public long PMEmployeeID { get; set; }
            public string PMCode { get; set; }
            public string PMName { get; set; }
            public long ActingEmployeeID { get; set; }
            public string ActingCode { get; set; }
            public string ActingName { get; set; }
            public string FromDate { get; set; }
            public string ToDate { get; set; }
            public string FromDateValue { get; set; }
            public string ToDateValue { get; set; }
            public string Remark { get; set; }
            public string StatusText { get; set; }
            public string AddedByName { get; set; }
            public string AddedDate { get; set; }
        }
    }
}