using ClosedXML.Excel;
using DocumentFormat.OpenXml.Bibliography;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class HealthInsurancePolicy : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetPolicyUsers()
        {
            DataTable dt1 = new bllMaster().GetEmployeeForGroupPolicy();
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
        public static string GetEmployeeInfo(int employeeId)
        {
            DataTable dt1 = new bllLogin().GetUserInformation(employeeId);
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
        public static string GetEmployeePolicyInfo(int employeeId, int policyId)
        {
            DataTable dt1 = new bllMaster().GetEmployeeGroupPolicyInfoByEmpID(employeeId, policyId);
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
        public static string GetFamilyInfo(int employeeId, int policyId)
        {
            DataTable dt1 = new bllMaster().GetFamilyInfoForGroupPolicy(employeeId, policyId);
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
        public static string GetPolicyAmounts()
        {
            DataTable dt1 = new bllMaster().GetAllPolicyAmount();
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
        public static int SavePolicyInfo(int policyId, int employeeId, string groupPolicyType, string sumInsured, string approxPremium, string companyContributionMonthly,
    string companyContributionYearly, string empApproxPremiumMonthly, string empApproxPremiumYearly, string isApplicable, string contributionCategory, string contributionType,
    string percFixAmount, string policyStartDate, string policyPeriod)
        {
            int ReturnValue = 0;

            try
            {
                decimal SumInsured = string.IsNullOrEmpty(sumInsured) ? 0 : Convert.ToDecimal(sumInsured);
                decimal ApproxPremium = string.IsNullOrEmpty(approxPremium) ? 0 : Convert.ToDecimal(approxPremium);
                decimal CompMonthly = string.IsNullOrEmpty(companyContributionMonthly) ? 0 : Convert.ToDecimal(companyContributionMonthly);
                decimal CompYearly = string.IsNullOrEmpty(companyContributionYearly) ? 0 : Convert.ToDecimal(companyContributionYearly);
                decimal EmpMonthly = string.IsNullOrEmpty(empApproxPremiumMonthly) ? 0 : Convert.ToDecimal(empApproxPremiumMonthly);
                decimal EmpYearly = string.IsNullOrEmpty(empApproxPremiumYearly) ? 0 : Convert.ToDecimal(empApproxPremiumYearly);
                int PercFixAmount = string.IsNullOrEmpty(percFixAmount) ? 0 : Convert.ToInt32(percFixAmount);

                Hashtable htParam = new Hashtable();

                htParam["GroupPolicyType"] = groupPolicyType;
                htParam["SumInsured"] = SumInsured;
                htParam["ApproxPremium"] = ApproxPremium;
                htParam["CompanyContributionMonthly"] = CompMonthly;
                htParam["CompanyContributionYearly"] = CompYearly;
                htParam["EmpApproxPremiumMonthly"] = EmpMonthly;
                htParam["EmpApproxPremiumYearly"] = EmpYearly;
                htParam["EmployeeID"] = employeeId;
                htParam["IsApplicable"] = isApplicable;
                htParam["ContributionCategory"] = contributionCategory;
                htParam["ContributionType"] = contributionType;
                htParam["PercFixAmount"] = percFixAmount;
                htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                ReturnValue =  new bllMaster().InsertEmployeeGroupPolicy(htParam);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return ReturnValue;
        }

        [WebMethod]
        public static int AddFamilyMember()
        {
            return 0;
            // Insert into family policy table
        }

        [WebMethod]
        public static string DeleteFamilyMember(long id)
        {
            SqlConnection con = new SqlConnection(SQLHelper.ConnectionString);

            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;

            con.Open();

            SqlTransaction trans = con.BeginTransaction();

            cmd.Transaction = trans;

            try
            {
                cmd.CommandText = @"

            DELETE FROM GroupPolicyFamilyInfo
            WHERE GroupPolicyFamilyID = @GroupPolicyFamilyID

        ";

                cmd.Parameters.Clear();

                cmd.Parameters.AddWithValue("@GroupPolicyFamilyID", id);

                cmd.ExecuteNonQuery();

                trans.Commit();

                return "Success";
            }
            catch (Exception ex)
            {
                trans.Rollback();

                return ex.Message;
            }
            finally
            {
                con.Close();
            }
        }
        [WebMethod]
        public static string GetActivePolicies()
        {
            return "";
            // return active policy assigned employees as JSON
        }

        [WebMethod]
        public static string GetDeletedEmployees()
        {
            return "";
            // return deleted employees from policy as JSON
        }

        [WebMethod]
        public static int ApplyPolicyToEmployees(List<int> employeeIds, string policyStartDate, string policyPeriod, decimal sumInsured, int PolicyId)
        {
            int returnValue = 0;

            foreach (int employeeId in employeeIds)
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("EmployeeID", employeeId);
                htParam.Add("IsApplicable", true);
                htParam.Add("PolicyStartDate", policyStartDate);
                htParam.Add("PolicyPeriod", policyPeriod);
                htParam.Add("AppliedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                htParam.Add("PolicyId", PolicyId);

                int ReturnValue = new bllMaster().ApplyEmployeeGroupPolicy(htParam);

                returnValue++;
            }

            return returnValue;
        }

        [WebMethod]
        public static string GetPolicyPeriods()
        {
            DataTable dt1 = new bllMaster().GetPolicyPeriods();
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
        public static string GetEmployeesByPolicyPeriod(string policyPeriod)
        {
            DataTable dt1 = new bllMaster().GetEmployeesByPolicyPeriod(policyPeriod);
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
        public static string getAmountDistribution(decimal Amount, decimal SumInsured, bool IsApplicable)
        {
            DataTable dt1 = new bllMaster().GetSumInsuredDistribution(Amount, SumInsured, IsApplicable);
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
        public static string getAge(string BirthDate)
        {
            DataTable dt1 = new bllMaster().GetAge(BirthDate);
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
        public static string UpdateFamilyContribution(long familyId, decimal approxPremium, decimal companyContributionMonthly, decimal companyContributionYearly, decimal empApproxPremiumMonthly, decimal empApproxPremiumYearly)
        {
            SqlConnection con = new SqlConnection(SQLHelper.ConnectionString);
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            con.Open();
            SqlTransaction trans = con.BeginTransaction();
            cmd.Transaction = trans;
            try
            {
                cmd.CommandText = @"
            UPDATE GroupPolicyFamilyInfo
            SET

                ApproxPremium = @ApproxPremium,
                CompanyContributionMonthly = @CompanyContributionMonthly,
                CompanyContributionYearly = @CompanyContributionYearly,
                EmpApproxPremiumMonthly = @EmpApproxPremiumMonthly,
                EmpApproxPremiumYearly = @EmpApproxPremiumYearly

            WHERE GroupPolicyFamilyID = @GroupPolicyFamilyID

        ";

                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@GroupPolicyFamilyID", familyId);
                cmd.Parameters.AddWithValue("@ApproxPremium", approxPremium);
                cmd.Parameters.AddWithValue("@CompanyContributionMonthly", companyContributionMonthly);
                cmd.Parameters.AddWithValue("@CompanyContributionYearly", companyContributionYearly);
                cmd.Parameters.AddWithValue("@EmpApproxPremiumMonthly", empApproxPremiumMonthly);
                cmd.Parameters.AddWithValue("@EmpApproxPremiumYearly", empApproxPremiumYearly);
                cmd.ExecuteNonQuery();
                trans.Commit();

                return "Success";
            }
            catch (Exception ex)
            {
                trans.Rollback();

                return ex.Message;
            }
            finally
            {
                con.Close();
            }
        }



        [WebMethod]
        public static int RemoveFromPolicyList(string Code)
        {
            int ReturnValue = 0;
            try
            {
                ReturnValue = new bllMaster().RemoveFromPolicyList(Code, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            }
            catch (Exception ex)
            {
                return 0;
            }

            return ReturnValue;
        }


        [WebMethod]
        public static string GetDashboardSummary(string policyPeriod)
        {
            SqlConnection con = new SqlConnection(SQLHelper.ConnectionString);
            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;

            cmd.CommandText = @"
        SELECT
            COUNT(*) AS TotalEmployees,
 SUM(CASE 
        WHEN EGP.GroupPolicyType = 'Family' THEN 1 
        ELSE 0 
    END) AS FamilyPolicy,

    SUM(CASE 
        WHEN EGP.GroupPolicyType = 'Individual' THEN 1 
        ELSE 0 
    END) AS IndividualPolicy,
            SUM(CASE WHEN ISNULL(IsApproved, 0) = 0 THEN 1 ELSE 0 END) AS PendingPolicyInfo,
            SUM(CASE WHEN ISNULL(IsApproved, 0) = 1 THEN 1 ELSE 0 END) AS PolicyApplied,
            SUM(CASE WHEN ISNULL(IsUpdated, 0) = 1 THEN 1 ELSE 0 END) AS DeletedEmployees,
              ISNULL((
        SELECT COUNT(*)
        FROM GroupPolicyFamilyInfo F
        INNER JOIN EmployeeGroupPolicy P
            ON P.EmpGroupPolicyID = F.EmpGroupPolicyID
        WHERE (@PolicyPeriod = '' OR P.PolicyPeriod = @PolicyPeriod)
    ), 0) AS FamilyMembers,

    ISNULL(SUM(ISNULL(EGP.ApproxPremium, 0)), 0)
    +
    ISNULL((
        SELECT SUM(ISNULL(F.ApproxPremium, 0))
        FROM GroupPolicyFamilyInfo F
        INNER JOIN EmployeeGroupPolicy P
            ON P.EmpGroupPolicyID = F.EmpGroupPolicyID
        WHERE (@PolicyPeriod = '' OR P.PolicyPeriod = @PolicyPeriod)
    ), 0) AS TotalApproxPremium
        FROM EmployeeGroupPolicy EGP
        WHERE
            (@PolicyPeriod = '' OR PolicyPeriod = @PolicyPeriod)
    ";

            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@PolicyPeriod", string.IsNullOrEmpty(policyPeriod) ? "" : policyPeriod);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            foreach (DataRow dr in dt.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();

                foreach (DataColumn col in dt.Columns)
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
        public static string GetApplicableEmployeeForGroupPolicy()
        {
            DataTable dt1 = new bllMaster().GetApplicableEmployeeForGroupPolicy();
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
        public static string GetNotApplicableEmployeeForGroupPolicy()
        {
            DataTable dt1 = new bllMaster().GetNotApplicableEmployeeForGroupPolicy();
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
    }
}