using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.FTE
{
    public partial class FTEUserConfiguration : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetAllProjectByUserRights()
        {
            DataTable dt = new bllMaster().GetAllProjectByUserRights(HttpContext.Current.User.Identity.Name);
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetProcessByProjectWise(int ProjectID)
        {
            bllMaster master = new bllMaster();
            string code = master.GetCodeFromEmployeeId(GetCurrentEmployeeId());
            DataTable dt = master.getProcessByProjectWise(ProjectID, code);
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetAllEmployeeDetailsbyPM()
        {
            DataTable dt = new bllMaster().GetAllEmployeeDetailsbyPM(GetCurrentEmployeeId());
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetPseudoName(string Code)
        {
            string employeeCode = Convert.ToString(Code);

            if (employeeCode.Length >= 3)
            {
                employeeCode = employeeCode.Substring(0, 3);
            }

            DataTable dt = new bllMaster().GetPseudoName(employeeCode);
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetFTEUserDetails()
        {
            DataTable dt = new bllMaster().GetFTEUserDetails();
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetFTEUserDetailsById(int ConfigID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetFTEUSerCOnfigurationByConfigId");
            SQLHelper.AddParamToSQLCmd(cmd, "@ConfigID", SqlDbType.Int, 10, ParameterDirection.Input, ConfigID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            cmd.Dispose();
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static int InsertFTEUserDetails(
            int ProjectID,
            int ProcessID,
            int EmployeeID,
            string Pseudoname,
            string EmployeeStatus,
            string EffectiveDate,
            string NoticePeriodDays)
        {
            if (ProjectID <= 0 ||
                ProcessID <= 0 ||
                EmployeeID <= 0 ||
                string.IsNullOrWhiteSpace(Pseudoname) ||
                string.IsNullOrWhiteSpace(EmployeeStatus) ||
                string.IsNullOrWhiteSpace(EffectiveDate))
            {
                return 0;
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", ProjectID);
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("EmployeeID", EmployeeID);
            htParam.Add("Pseudoname", Pseudoname.Trim());
            htParam.Add("EmployeeStatus", EmployeeStatus.Trim());
            htParam.Add("EffectiveDate", EffectiveDate.Trim());
            htParam.Add("NoticePeriodDays", NoticePeriodDays == null ? string.Empty : NoticePeriodDays.Trim());
            htParam.Add("AddedBy", GetCurrentEmployeeId());

            return new bllMaster().InsertFTEUserDetails(htParam);
        }

        [WebMethod]
        public static int DeleteUser(int ConfigId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_DeleteFTEUser");
            SQLHelper.AddParamToSQLCmd(cmd, "@ConfigId", SqlDbType.BigInt, 0, ParameterDirection.Input, ConfigId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int returnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return returnValue;
        }

        private static int GetCurrentEmployeeId()
        {
            return int.Parse(HttpContext.Current.User.Identity.Name);
        }

        private static string SerializeDataTable(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();

                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }

                    rows.Add(row);
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(rows);
        }
    }
}
