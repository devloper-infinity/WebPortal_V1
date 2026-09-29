using ClosedXML.Excel;
using DocumentFormat.OpenXml.Bibliography;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.IO;
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

                DateTime effectiveStart, policyEnd;
                GetEmployeePolicyDates(employeeId, policyId, policyStartDate, policyPeriod, out effectiveStart, out policyEnd);
                decimal alreadyDeducted;
                int remainingMonths = GetRemainingDeductionMonths(effectiveStart, policyEnd, employeeId, policyId, out alreadyDeducted);
                decimal remainingEmployeeContribution = Math.Max(0, EmpYearly - alreadyDeducted);
                CompMonthly = remainingMonths == 0 ? 0 : Math.Round(CompYearly / remainingMonths, 2, MidpointRounding.AwayFromZero);
                EmpMonthly = remainingMonths == 0 ? 0 : Math.Round(remainingEmployeeContribution / remainingMonths, 2, MidpointRounding.AwayFromZero);

                Hashtable htParam = new Hashtable();

                htParam["GroupPolicyType"] = groupPolicyType;
                htParam["SumInsured"] = SumInsured;
                htParam["ApproxPremium"] = ApproxPremium;
                htParam["CompanyContributionMonthly"] = CompMonthly;
                htParam["CompanyContributionYearly"] = CompYearly;
                htParam["EmpApproxPremiumMonthly"] = EmpMonthly;
                // The deduction procedure uses yearly/monthly to decide how many rows to create.
                htParam["EmpApproxPremiumYearly"] = remainingEmployeeContribution;
                htParam["EmployeeID"] = employeeId;
                htParam["IsApplicable"] = isApplicable;
                htParam["ContributionCategory"] = contributionCategory;
                htParam["ContributionType"] = contributionType;
                htParam["PercFixAmount"] = percFixAmount;
                htParam["PolicyID"] = policyId;
                htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                ReturnValue = new bllMaster().InsertEmployeeGroupPolicy(htParam);
                if (ReturnValue > 0)
                {
                    UpdatePolicyYearlyContribution(employeeId, policyId, EmpYearly);
                    decimal familyEmployeeYearly = GetFamilyEmployeeContribution(policyId);
                    decimal totalDeductionMonthly = remainingMonths == 0 ? 0 : Math.Round(
                        Math.Max(0, EmpYearly + familyEmployeeYearly - alreadyDeducted) / remainingMonths,
                        2, MidpointRounding.AwayFromZero);
                    SyncPolicyDeductions(employeeId, effectiveStart, policyEnd, totalDeductionMonthly);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return ReturnValue;
        }

        [WebMethod]
        public static Dictionary<string, decimal> CalculateMonthlyContributions(int employeeId, int policyId, string policyStartDate, string policyPeriod, decimal employeeYearly, decimal companyYearly)
        {
            DateTime startDate, endDate;
            if (!DateTime.TryParse(policyStartDate, CultureInfo.GetCultureInfo("en-IN"), DateTimeStyles.None, out startDate))
                throw new Exception("Invalid employee Policy Start Date.");
            string endText = (policyPeriod ?? "").Split(new[] { " to " }, StringSplitOptions.None).Last().Trim();
            if (!DateTime.TryParse(endText, CultureInfo.GetCultureInfo("en-IN"), DateTimeStyles.None, out endDate))
                throw new Exception("Invalid Policy End Date.");

            decimal alreadyDeducted;
            int months = GetRemainingDeductionMonths(startDate, endDate, employeeId, policyId, out alreadyDeducted);
            return new Dictionary<string, decimal>
            {
                { "EmployeeMonthly", months == 0 ? 0 : Math.Round(Math.Max(0, employeeYearly - alreadyDeducted) / months, 2, MidpointRounding.AwayFromZero) },
                { "CompanyMonthly", months == 0 ? 0 : Math.Round(companyYearly / months, 2, MidpointRounding.AwayFromZero) }
            };
        }

        [WebMethod]
        public static Dictionary<string, decimal> CalculateFamilyMonthlyContributions(int employeeId, int policyId, string policyStartDate, string policyPeriod, decimal employeeYearly, decimal companyYearly)
        {
            DateTime startDate, endDate;
            if (!DateTime.TryParse(policyStartDate, CultureInfo.GetCultureInfo("en-IN"), DateTimeStyles.None, out startDate))
                throw new Exception("Invalid employee Policy Start Date.");
            string endText = (policyPeriod ?? "").Split(new[] { " to " }, StringSplitOptions.None).Last().Trim();
            if (!DateTime.TryParse(endText, CultureInfo.GetCultureInfo("en-IN"), DateTimeStyles.None, out endDate))
                throw new Exception("Invalid Policy End Date.");

            decimal ignored;
            int months = GetRemainingDeductionMonths(startDate, endDate, employeeId, policyId, out ignored);
            return new Dictionary<string, decimal>
            {
                { "EmployeeMonthly", months == 0 ? 0 : Math.Round(employeeYearly / months, 2, MidpointRounding.AwayFromZero) },
                { "CompanyMonthly", months == 0 ? 0 : Math.Round(companyYearly / months, 2, MidpointRounding.AwayFromZero) }
            };
        }

        private static int GetRemainingDeductionMonths(DateTime policyStartDate, DateTime policyEndDate, int employeeId, int policyId, out decimal alreadyDeducted)
        {
            alreadyDeducted = 0;
            DateTime firstMonth = new DateTime(policyStartDate.Year, policyStartDate.Month, 1);
            DateTime lastMonth = new DateTime(policyEndDate.Year, policyEndDate.Month, 1);
            if (firstMonth > lastMonth) return 0;

            HashSet<string> processed = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT [Month], [Year], ISNULL(PolicyPremium, 0) PolicyPremium
                FROM InfinitySalary
                WHERE EmployeeID = @EmployeeID", con))
            {
                cmd.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                    while (reader.Read())
                    {
                        DateTime month;
                        if (DateTime.TryParseExact("1 " + reader["Month"] + " " + reader["Year"], "d MMMM yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out month)
                            && month >= firstMonth && month <= lastMonth)
                        {
                            processed.Add(month.ToString("yyyyMM"));
                            alreadyDeducted += Convert.ToDecimal(reader["PolicyPremium"]);
                        }
                    }
            }

            int eligibleMonths = ((lastMonth.Year - firstMonth.Year) * 12) + lastMonth.Month - firstMonth.Month + 1;
            return Math.Max(0, eligibleMonths - processed.Count);
        }

        private static void GetEmployeePolicyDates(int employeeId, int policyId, string startText, string period, out DateTime startDate, out DateTime endDate)
        {
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("SELECT PolicyStartDate, PolicyPeriod FROM EmployeeGroupPolicy WHERE EmployeeID=@EmployeeID AND EmpGroupPolicyID=@PolicyID", con))
            {
                cmd.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                cmd.Parameters.Add("@PolicyID", SqlDbType.Int).Value = policyId;
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                    if (reader.Read())
                    {
                        startText = Convert.ToString(reader["PolicyStartDate"]);
                        period = Convert.ToString(reader["PolicyPeriod"]);
                    }
            }
            if (!DateTime.TryParse(startText, CultureInfo.GetCultureInfo("en-IN"), DateTimeStyles.None, out startDate))
                throw new Exception("Invalid employee Policy Start Date.");
            string endText = (period ?? "").Split(new[] { " to " }, StringSplitOptions.None).Last().Trim();
            if (!DateTime.TryParse(endText, CultureInfo.GetCultureInfo("en-IN"), DateTimeStyles.None, out endDate))
                throw new Exception("Invalid Policy End Date.");
        }

        private static void UpdatePolicyYearlyContribution(int employeeId, int policyId, decimal yearly)
        {
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("UPDATE EmployeeGroupPolicy SET EmpApproxPremiumYearly=@Yearly WHERE EmployeeID=@EmployeeID AND EmpGroupPolicyID=@PolicyID", con))
            {
                cmd.Parameters.Add("@Yearly", SqlDbType.Decimal).Value = yearly;
                cmd.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                cmd.Parameters.Add("@PolicyID", SqlDbType.Int).Value = policyId;
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private static decimal GetFamilyEmployeeContribution(int policyId)
        {
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(SUM(EmpApproxPremiumYearly),0) FROM GroupPolicyFamilyInfo WHERE EmpGroupPolicyID=@PolicyID", con))
            {
                cmd.Parameters.Add("@PolicyID", SqlDbType.Int).Value = policyId;
                con.Open();
                return Convert.ToDecimal(cmd.ExecuteScalar());
            }
        }

        private static void RefreshTotalPolicyDeduction(int policyId)
        {
            int employeeId;
            decimal employeeYearly;
            string startText, period;
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("SELECT EmployeeID,ISNULL(EmpApproxPremiumYearly,0),PolicyStartDate,PolicyPeriod FROM EmployeeGroupPolicy WHERE EmpGroupPolicyID=@PolicyID", con))
            {
                cmd.Parameters.Add("@PolicyID", SqlDbType.Int).Value = policyId;
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) return;
                    employeeId = Convert.ToInt32(reader[0]);
                    employeeYearly = Convert.ToDecimal(reader[1]);
                    startText = Convert.ToString(reader[2]);
                    period = Convert.ToString(reader[3]);
                }
            }

            DateTime startDate, endDate;
            GetEmployeePolicyDates(employeeId, policyId, startText, period, out startDate, out endDate);
            decimal alreadyDeducted;
            int months = GetRemainingDeductionMonths(startDate, endDate, employeeId, policyId, out alreadyDeducted);
            decimal monthly = months == 0 ? 0 : Math.Round(
                Math.Max(0, employeeYearly + GetFamilyEmployeeContribution(policyId) - alreadyDeducted) / months,
                2, MidpointRounding.AwayFromZero);
            SyncPolicyDeductions(employeeId, startDate, endDate, monthly);
        }

        private static void SyncPolicyDeductions(int employeeId, DateTime startDate, DateTime endDate, decimal monthlyAmount)
        {
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                DELETE D
                FROM DeductionMaster D JOIN EmployeeInfo E ON E.Code=D.Code
                WHERE E.EmployeeID=@EmployeeID AND D.Type='Policy' AND ISNULL(D.IsDeducted,0)=0
                  AND DATEFROMPARTS(D.[Year], CASE D.[Month]
                    WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3 WHEN 'April' THEN 4
                    WHEN 'May' THEN 5 WHEN 'June' THEN 6 WHEN 'July' THEN 7 WHEN 'August' THEN 8
                    WHEN 'September' THEN 9 WHEN 'October' THEN 10 WHEN 'November' THEN 11 WHEN 'December' THEN 12 END, 1) > @EndMonth;

                ;WITH D AS (
                    SELECT D.ID, ROW_NUMBER() OVER (PARTITION BY D.[Month], D.[Year] ORDER BY D.ID) RN
                    FROM DeductionMaster D JOIN EmployeeInfo E ON E.Code=D.Code
                    WHERE E.EmployeeID=@EmployeeID AND D.Type='Policy' AND ISNULL(D.IsDelete,0)=0
                      AND ISNULL(D.IsDeducted,0)=0
                )
                UPDATE DM SET IsDelete=1, DeletedBy=@AddedBy, DeletedDate=GETDATE()
                FROM DeductionMaster DM JOIN D ON D.ID=DM.ID
                WHERE D.RN>1 OR (DM.AddedDate >= CAST(GETDATE() AS date) AND DATEFROMPARTS(DM.[Year], CASE DM.[Month]
                    WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3 WHEN 'April' THEN 4
                    WHEN 'May' THEN 5 WHEN 'June' THEN 6 WHEN 'July' THEN 7 WHEN 'August' THEN 8
                    WHEN 'September' THEN 9 WHEN 'October' THEN 10 WHEN 'November' THEN 11 WHEN 'December' THEN 12 END, 1)
                    NOT BETWEEN @StartMonth AND @EndMonth)
                    OR EXISTS (SELECT 1 FROM InfinitySalary S WHERE S.EmployeeID=@EmployeeID
                        AND S.[Year]=CONVERT(nvarchar(4),DM.[Year]) AND S.[Month]=DM.[Month]);

                UPDATE D SET Amount=@Amount
                FROM DeductionMaster D JOIN EmployeeInfo E ON E.Code=D.Code
                WHERE E.EmployeeID=@EmployeeID AND D.Type='Policy' AND ISNULL(D.IsDelete,0)=0 AND ISNULL(D.IsDeducted,0)=0
                  AND DATEFROMPARTS(D.[Year], CASE D.[Month]
                    WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3 WHEN 'April' THEN 4
                    WHEN 'May' THEN 5 WHEN 'June' THEN 6 WHEN 'July' THEN 7 WHEN 'August' THEN 8
                    WHEN 'September' THEN 9 WHEN 'October' THEN 10 WHEN 'November' THEN 11 WHEN 'December' THEN 12 END, 1)
                    BETWEEN @StartMonth AND @EndMonth
                  AND NOT EXISTS (SELECT 1 FROM InfinitySalary S WHERE S.EmployeeID=@EmployeeID
                        AND S.[Year]=CONVERT(nvarchar(4),D.[Year]) AND S.[Month]=D.[Month]);

                ;WITH Months AS (
                    SELECT @StartMonth M
                    UNION ALL SELECT DATEADD(month,1,M) FROM Months WHERE M < @EndMonth
                )
                INSERT DeductionMaster (Code,[Month],[Year],Type,Amount,AddedBy,AddedDate,MachineIP,isApproved,ApprovedBy,ApprovedDate)
                SELECT E.Code,DATENAME(month,M),YEAR(M),'Policy',@Amount,@AddedBy,GETDATE(),'192.168.11.11',1,@AddedBy,GETDATE()
                FROM Months CROSS JOIN EmployeeInfo E
                WHERE E.EmployeeID=@EmployeeID AND @Amount>0
                  AND NOT EXISTS (SELECT 1 FROM InfinitySalary S WHERE S.EmployeeID=@EmployeeID
                        AND S.[Year]=CONVERT(nvarchar(4),YEAR(M)) AND S.[Month]=DATENAME(month,M))
                  AND NOT EXISTS (SELECT 1 FROM DeductionMaster D WHERE D.Code=E.Code AND D.Type='Policy'
                        AND ISNULL(D.IsDelete,0)=0 AND D.[Year]=YEAR(M) AND D.[Month]=DATENAME(month,M))
                OPTION (MAXRECURSION 120);", con))
            {
                cmd.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                cmd.Parameters.Add("@AddedBy", SqlDbType.Int).Value = int.Parse(HttpContext.Current.User.Identity.Name);
                cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = monthlyAmount;
                cmd.Parameters.Add("@StartMonth", SqlDbType.Date).Value = new DateTime(startDate.Year, startDate.Month, 1);
                cmd.Parameters.Add("@EndMonth", SqlDbType.Date).Value = new DateTime(endDate.Year, endDate.Month, 1);
                con.Open();
                cmd.ExecuteNonQuery();
            }
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
                cmd.CommandText = "SELECT EmpGroupPolicyID FROM GroupPolicyFamilyInfo WHERE GroupPolicyFamilyID=@GroupPolicyFamilyID";
                cmd.Parameters.AddWithValue("@GroupPolicyFamilyID", id);
                object policyValue = cmd.ExecuteScalar();
                int policyId = policyValue == null ? 0 : Convert.ToInt32(policyValue);

                cmd.CommandText = @"

            DELETE FROM GroupPolicyFamilyInfo
            WHERE GroupPolicyFamilyID = @GroupPolicyFamilyID

        ";

                cmd.ExecuteNonQuery();

                trans.Commit();

                if (policyId > 0) RefreshTotalPolicyDeduction(policyId);

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
            int policyId;
            int employeeId;
            using (SqlConnection lookupCon = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand lookupCmd = new SqlCommand(@"SELECT F.EmpGroupPolicyID,P.EmployeeID
                FROM GroupPolicyFamilyInfo F JOIN EmployeeGroupPolicy P ON P.EmpGroupPolicyID=F.EmpGroupPolicyID
                WHERE F.GroupPolicyFamilyID=@FamilyID", lookupCon))
            {
                lookupCmd.Parameters.Add("@FamilyID", SqlDbType.BigInt).Value = familyId;
                lookupCon.Open();
                using (SqlDataReader reader = lookupCmd.ExecuteReader())
                {
                    if (!reader.Read()) return "Family member not found.";
                    policyId = Convert.ToInt32(reader[0]);
                    employeeId = Convert.ToInt32(reader[1]);
                }
            }

            DateTime startDate, endDate;
            GetEmployeePolicyDates(employeeId, policyId, null, null, out startDate, out endDate);
            decimal ignored;
            int months = GetRemainingDeductionMonths(startDate, endDate, employeeId, policyId, out ignored);
            companyContributionMonthly = months == 0 ? 0 : Math.Round(companyContributionYearly / months, 2, MidpointRounding.AwayFromZero);
            empApproxPremiumMonthly = months == 0 ? 0 : Math.Round(empApproxPremiumYearly / months, 2, MidpointRounding.AwayFromZero);

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

                RefreshTotalPolicyDeduction(policyId);

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
        public static object GetManagementReport(string policy, string policyPeriod, string employee, string department, string location, string status, string contributionType, string fromDate, string toDate)
        {
            DataTable details = GetManagementReportData(policy, policyPeriod, employee, department, location, contributionType, fromDate, toDate);
            if (!string.IsNullOrEmpty(status))
                details = FilterManagementStatus(details, status);
            return BuildManagementReport(details);
        }

        [WebMethod]
        public static string ExportManagementReport(string policy, string policyPeriod, string employee, string department, string location, string status, string contributionType, string fromDate, string toDate)
        {
            DataTable details = GetManagementReportData(policy, policyPeriod, employee, department, location, contributionType, fromDate, toDate);
            if (!string.IsNullOrEmpty(status))
                details = FilterManagementStatus(details, status);
            Dictionary<string, object> report = BuildManagementReport(details);
            using (XLWorkbook wb = new XLWorkbook())
            using (MemoryStream ms = new MemoryStream())
            {
                AddReportSheet(wb, "Policy Summary", (List<Dictionary<string, object>>)report["PolicySummary"]);
                AddReportSheet(wb, "Employee Details", (List<Dictionary<string, object>>)report["EmployeeDetails"]);
                AddReportSheet(wb, "Late Enrollment", (List<Dictionary<string, object>>)report["LateEnrollment"]);
                AddReportSheet(wb, "Deduction Summary", (List<Dictionary<string, object>>)report["DeductionSummary"]);
                wb.SaveAs(ms);
                return Convert.ToBase64String(ms.ToArray());
            }
        }

        private static DataTable GetManagementReportData(string policy, string policyPeriod, string employee, string department, string location, string contributionType, string fromDate, string toDate)
        {
            const string sql = @"
;WITH P0 AS (
 SELECT P.*,CASE WHEN ISDATE(P.PolicyStartDate)=1 THEN CONVERT(date,P.PolicyStartDate) END EmployeeStart,
 CASE WHEN T.StartToken LIKE '%/%' THEN DATEFROMPARTS(CONVERT(int,PARSENAME(REPLACE(T.StartToken,'/','.'),1)),CONVERT(int,PARSENAME(REPLACE(T.StartToken,'/','.'),2)),CONVERT(int,PARSENAME(REPLACE(T.StartToken,'/','.'),3))) WHEN ISDATE(T.StartToken)=1 THEN CONVERT(date,T.StartToken) END PolicyStart,
 CASE WHEN T.EndToken LIKE '%/%' THEN DATEFROMPARTS(CONVERT(int,PARSENAME(REPLACE(T.EndToken,'/','.'),1)),CONVERT(int,PARSENAME(REPLACE(T.EndToken,'/','.'),2)),CONVERT(int,PARSENAME(REPLACE(T.EndToken,'/','.'),3))) WHEN ISDATE(T.EndToken)=1 THEN CONVERT(date,T.EndToken) END PolicyEnd,
 ROW_NUMBER() OVER(PARTITION BY P.EmployeeID,P.PolicyPeriod,P.GroupPolicyType,P.SumInsured ORDER BY P.EmpGroupPolicyID DESC) RN
 FROM EmployeeGroupPolicy P CROSS APPLY (SELECT LTRIM(RTRIM(LEFT(P.PolicyPeriod,CASE WHEN CHARINDEX(' to ',P.PolicyPeriod)>0 THEN CHARINDEX(' to ',P.PolicyPeriod)-1 ELSE 0 END))) StartToken,LTRIM(RTRIM(SUBSTRING(P.PolicyPeriod,CHARINDEX(' to ',P.PolicyPeriod)+4,50))) EndToken) T
 WHERE ISNULL(P.IsUpdated,0)=0 AND CHARINDEX(' to ',P.PolicyPeriod)>0
), F AS (
 SELECT EmpGroupPolicyID,SUM(ISNULL(ApproxPremium,0)) Premium,SUM(ISNULL(CompanyContributionYearly,0)) CompanyYearly,
 SUM(ISNULL(EmpApproxPremiumYearly,0)) EmployeeYearly,SUM(ISNULL(CompanyContributionMonthly,0)) CompanyMonthly,
 SUM(ISNULL(EmpApproxPremiumMonthly,0)) EmployeeMonthly FROM GroupPolicyFamilyInfo GROUP BY EmpGroupPolicyID
), S AS (
 SELECT EmployeeID,CASE WHEN ISDATE('1 '+[Month]+' '+[Year])=1 THEN CONVERT(date,'1 '+[Month]+' '+[Year]) END SalaryMonth,
 SUM(ISNULL(PolicyPremium,0)) Deducted FROM InfinitySalary GROUP BY EmployeeID,[Month],[Year]
), B AS (
 SELECT P.EmpGroupPolicyID,P.EmployeeID,E.Code EmployeeCode,LTRIM(RTRIM(ISNULL(E.FirstName,'')+' '+ISNULL(E.lastName,''))) EmployeeName,
 ISNULL(D.DepartmentName,'') Department,ISNULL(BR.BranchName,'') Location,P.GroupPolicyType PolicyName,
 P.EmployeeStart,P.PolicyStart,P.PolicyEnd,P.PolicyPeriod,ISNULL(P.ContributionType,'') ContributionType,
 ISNULL(P.ApproxPremium,0)+ISNULL(F.Premium,0) AnnualPremium,ISNULL(P.CompanyContributionYearly,0)+ISNULL(F.CompanyYearly,0) CompanyContribution,
 ISNULL(P.EmpApproxPremiumYearly,0)+ISNULL(F.EmployeeYearly,0) EmployeeContribution,
 ISNULL(P.CompanyContributionMonthly,0)+ISNULL(F.CompanyMonthly,0) MonthlyCompanyContribution,
 ISNULL(P.EmpApproxPremiumMonthly,0)+ISNULL(F.EmployeeMonthly,0) MonthlyEmployeeContribution,
 ISNULL(SUM(S.Deducted),0) AlreadyDeductedEmployeeAmount,COUNT(S.SalaryMonth) ProcessedMonths,MAX(S.SalaryMonth) LastDeductedMonth
 FROM P0 P JOIN EmployeeInfo E ON E.EmployeeID=P.EmployeeID LEFT JOIN Department D ON D.DepartmentID=E.Department
 LEFT JOIN Branch BR ON BR.BranchID=E.WorkingBranch LEFT JOIN F ON F.EmpGroupPolicyID=P.EmpGroupPolicyID
 LEFT JOIN S ON S.EmployeeID=P.EmployeeID AND S.SalaryMonth BETWEEN DATEFROMPARTS(YEAR(P.EmployeeStart),MONTH(P.EmployeeStart),1) AND DATEFROMPARTS(YEAR(P.PolicyEnd),MONTH(P.PolicyEnd),1)
 WHERE P.RN=1 AND (@Policy='' OR P.GroupPolicyType=@Policy) AND (@Period='' OR P.PolicyPeriod=@Period)
 AND (@Employee='' OR E.Code=@Employee) AND (@Department='' OR D.DepartmentName=@Department) AND (@Location='' OR BR.BranchName=@Location)
 AND (@ContributionType='' OR P.ContributionType=@ContributionType)
 AND (@FromDate IS NULL OR P.EmployeeStart>=@FromDate) AND (@ToDate IS NULL OR P.EmployeeStart<=@ToDate)
 GROUP BY P.EmpGroupPolicyID,P.EmployeeID,E.Code,E.FirstName,E.lastName,D.DepartmentName,BR.BranchName,P.GroupPolicyType,P.EmployeeStart,P.PolicyStart,P.PolicyEnd,P.PolicyPeriod,P.ContributionType,
 P.ApproxPremium,F.Premium,P.CompanyContributionYearly,F.CompanyYearly,P.EmpApproxPremiumYearly,F.EmployeeYearly,P.CompanyContributionMonthly,F.CompanyMonthly,P.EmpApproxPremiumMonthly,F.EmployeeMonthly
), R AS (
 SELECT *,CASE WHEN EmployeeStart IS NULL OR PolicyEnd IS NULL OR EmployeeStart>PolicyEnd THEN 0 ELSE
 CASE WHEN DATEDIFF(month,DATEFROMPARTS(YEAR(EmployeeStart),MONTH(EmployeeStart),1),DATEFROMPARTS(YEAR(PolicyEnd),MONTH(PolicyEnd),1))+1-ProcessedMonths<0 THEN 0
 ELSE DATEDIFF(month,DATEFROMPARTS(YEAR(EmployeeStart),MONTH(EmployeeStart),1),DATEFROMPARTS(YEAR(PolicyEnd),MONTH(PolicyEnd),1))+1-ProcessedMonths END END RemainingMonths
 FROM B
)
SELECT *,CAST(0 AS decimal(18,2)) AlreadyDeductedCompanyAmount,
 CASE WHEN EmployeeContribution-AlreadyDeductedEmployeeAmount<0 THEN 0 ELSE EmployeeContribution-AlreadyDeductedEmployeeAmount END RemainingEmployeeAmount,
 CompanyContribution RemainingCompanyAmount,DATENAME(month,EmployeeStart)+' '+CAST(YEAR(EmployeeStart) AS varchar(4)) DeductionStartMonth,
 CASE WHEN PolicyEnd<CAST(GETDATE() AS date) THEN 'Expired' WHEN EmployeeContribution>0 AND EmployeeContribution<=AlreadyDeductedEmployeeAmount THEN 'Completed'
 WHEN AlreadyDeductedEmployeeAmount>0 THEN 'Deduction In Progress' WHEN EmployeeStart>CAST(GETDATE() AS date) THEN 'Not Started'
 WHEN PolicyEnd<=DATEADD(day,30,CAST(GETDATE() AS date)) THEN 'Expiring Soon' ELSE 'Active' END Status,
 CASE WHEN DATEDIFF(day,CAST(GETDATE() AS date),PolicyEnd)<0 THEN 0 ELSE DATEDIFF(day,CAST(GETDATE() AS date),PolicyEnd) END RemainingDays,
 CASE WHEN EmployeeStart>PolicyStart THEN 1 ELSE 0 END IsLate,
 CASE WHEN EmployeeStart>PolicyStart THEN DATEDIFF(month,DATEFROMPARTS(YEAR(PolicyStart),MONTH(PolicyStart),1),DATEFROMPARTS(YEAR(EmployeeStart),MONTH(EmployeeStart),1)) ELSE 0 END MonthsElapsed
FROM R ORDER BY PolicyPeriod,PolicyName,EmployeeName;";
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.CommandTimeout = 120;
                cmd.Parameters.AddWithValue("@Policy", policy ?? ""); cmd.Parameters.AddWithValue("@Period", policyPeriod ?? "");
                cmd.Parameters.AddWithValue("@Employee", employee ?? ""); cmd.Parameters.AddWithValue("@Department", department ?? "");
                cmd.Parameters.AddWithValue("@Location", location ?? ""); cmd.Parameters.AddWithValue("@ContributionType", contributionType ?? "");
                DateTime d; cmd.Parameters.Add("@FromDate", SqlDbType.Date).Value = DateTime.TryParse(fromDate, out d) ? (object)d.Date : DBNull.Value;
                cmd.Parameters.Add("@ToDate", SqlDbType.Date).Value = DateTime.TryParse(toDate, out d) ? (object)d.Date : DBNull.Value;
                DataTable dt = new DataTable(); new SqlDataAdapter(cmd).Fill(dt); return dt;
            }
        }

        private static DataTable FilterManagementStatus(DataTable source, string status)
        {
            if (string.IsNullOrEmpty(status)) return source;
            DataTable result = source.Clone();
            foreach (DataRow row in source.Select("Status='" + status.Replace("'", "''") + "'")) result.ImportRow(row);
            return result;
        }

        private static Dictionary<string, object> BuildManagementReport(DataTable details)
        {
            List<Dictionary<string, object>> detailRows = ToReportRows(details);
            var groups = details.AsEnumerable().GroupBy(r => new
            {
                Name = Convert.ToString(r["PolicyName"]), Period = Convert.ToString(r["PolicyPeriod"]),
                Start = r["PolicyStart"], End = r["PolicyEnd"]
            });
            List<Dictionary<string, object>> policies = new List<Dictionary<string, object>>();
            List<Dictionary<string, object>> deductions = new List<Dictionary<string, object>>();
            foreach (var g in groups)
            {
                decimal premium = g.Sum(r => DecimalValue(r, "AnnualPremium"));
                decimal company = g.Sum(r => DecimalValue(r, "CompanyContribution"));
                decimal employee = g.Sum(r => DecimalValue(r, "EmployeeContribution"));
                decimal deducted = g.Sum(r => DecimalValue(r, "AlreadyDeductedEmployeeAmount"));
                decimal pending = Math.Max(0, employee - deducted);
                string policyStatus = GetGroupStatus(g.Select(r => Convert.ToString(r["Status"])).ToList());
                Dictionary<string, object> p = new Dictionary<string, object>();
                p["PolicyName"] = g.Key.Name; p["PolicyStartDate"] = DateText(g.Key.Start); p["PolicyEndDate"] = DateText(g.Key.End);
                p["TotalEmployees"] = g.Count(); p["OriginalEmployees"] = g.Count(r => Convert.ToInt32(r["IsLate"]) == 0); p["EmployeesAddedLater"] = g.Count(r => Convert.ToInt32(r["IsLate"]) == 1);
                p["TotalAnnualPremium"] = premium; p["CompanyContribution"] = company; p["EmployeeContribution"] = employee;
                p["MonthlyCompanyContribution"] = g.Sum(r => DecimalValue(r, "MonthlyCompanyContribution")); p["MonthlyEmployeeContribution"] = g.Sum(r => DecimalValue(r, "MonthlyEmployeeContribution"));
                p["TotalDeducted"] = deducted; p["RemainingDeduction"] = pending; p["PolicyStatus"] = policyStatus; p["RemainingDays"] = g.Max(r => Convert.ToInt32(r["RemainingDays"])); p["PolicyPeriod"] = g.Key.Period;
                policies.Add(p);

                Dictionary<string, object> d = new Dictionary<string, object>();
                d["Policy"] = g.Key.Name; d["TotalExpectedEmployeeContribution"] = employee; d["EmployeeContributionDeducted"] = deducted; d["EmployeeContributionPending"] = pending;
                d["TotalExpectedCompanyContribution"] = company; d["CompanyContributionProcessed"] = 0m; d["CompanyContributionPending"] = company;
                d["CompletionPercent"] = employee + company == 0 ? 0 : Math.Round(deducted / (employee + company) * 100, 2);
                deductions.Add(d);
            }

            List<Dictionary<string, object>> late = detailRows.Where(r => Convert.ToInt32(r["IsLate"]) == 1).Select(r => new Dictionary<string, object>
            {
                {"Employee", r["EmployeeCode"] + " - " + r["EmployeeName"]}, {"Policy",r["PolicyName"]}, {"OriginalPolicyStartDate",r["PolicyStart"]},
                {"EmployeeEffectiveStartDate",r["EmployeeStart"]}, {"MonthsElapsed",r["MonthsElapsed"]}, {"RemainingDeductionMonths",r["RemainingMonths"]},
                {"AnnualPremium",r["AnnualPremium"]}, {"EmployeeMonthlyContribution",r["MonthlyEmployeeContribution"]}, {"CompanyMonthlyContribution",r["MonthlyCompanyContribution"]}
            }).ToList();

            Dictionary<string, object> summary = new Dictionary<string, object>();
            summary["TotalPolicies"] = policies.Count; summary["TotalEnrolledEmployees"] = details.Rows.Count;
            summary["TotalAnnualPremium"] = details.AsEnumerable().Sum(r => DecimalValue(r, "AnnualPremium")); summary["TotalCompanyContribution"] = details.AsEnumerable().Sum(r => DecimalValue(r, "CompanyContribution"));
            summary["TotalEmployeeContribution"] = details.AsEnumerable().Sum(r => DecimalValue(r, "EmployeeContribution")); summary["TotalMonthlyCompanyDeduction"] = details.AsEnumerable().Sum(r => DecimalValue(r, "MonthlyCompanyContribution"));
            summary["TotalMonthlyEmployeeDeduction"] = details.AsEnumerable().Sum(r => DecimalValue(r, "MonthlyEmployeeContribution")); summary["LateEmployees"] = late.Count;
            summary["ActivePolicies"] = policies.Count(p => Convert.ToString(p["PolicyStatus"]) == "Active" || Convert.ToString(p["PolicyStatus"]) == "Deduction In Progress");
            summary["ExpiringSoon"] = policies.Count(p => Convert.ToString(p["PolicyStatus"]) == "Expiring Soon");

            return new Dictionary<string, object> { { "Summary", summary }, { "PolicySummary", policies }, { "EmployeeDetails", detailRows }, { "LateEnrollment", late }, { "DeductionSummary", deductions },
                { "Filters", new Dictionary<string, object> { { "Policies", Distinct(details,"PolicyName") }, { "Periods", Distinct(details,"PolicyPeriod") }, { "Employees", Distinct(details,"EmployeeCode") }, { "Departments", Distinct(details,"Department") }, { "Locations", Distinct(details,"Location") }, { "ContributionTypes", Distinct(details,"ContributionType") } } } };
        }

        private static List<Dictionary<string, object>> ToReportRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (DataRow dr in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in table.Columns) row[col.ColumnName] = dr[col] == DBNull.Value ? "" : (dr[col] is DateTime ? ((DateTime)dr[col]).ToString("dd-MMM-yyyy") : dr[col]);
                rows.Add(row);
            }
            return rows;
        }

        private static List<string> Distinct(DataTable table, string column) { return table.AsEnumerable().Select(r => Convert.ToString(r[column])).Where(v => v != "").Distinct().OrderBy(v => v).ToList(); }
        private static decimal DecimalValue(DataRow row, string column) { return row[column] == DBNull.Value ? 0 : Convert.ToDecimal(row[column]); }
        private static string DateText(object value) { return value == DBNull.Value ? "" : Convert.ToDateTime(value).ToString("dd-MMM-yyyy"); }
        private static string GetGroupStatus(List<string> values)
        {
            if (values.Contains("Expired")) return "Expired"; if (values.All(v => v == "Completed")) return "Completed";
            if (values.Contains("Expiring Soon")) return "Expiring Soon"; if (values.Contains("Deduction In Progress")) return "Deduction In Progress";
            if (values.All(v => v == "Not Started")) return "Not Started"; return "Active";
        }

        private static void AddReportSheet(XLWorkbook wb, string name, List<Dictionary<string, object>> rows)
        {
            var ws = wb.Worksheets.Add(name); if (rows.Count == 0) { ws.Cell(1, 1).Value = "No records"; return; }
            List<string> columns = rows[0].Keys.ToList();
            for (int c = 0; c < columns.Count; c++) ws.Cell(1, c + 1).Value = columns[c];
            for (int r = 0; r < rows.Count; r++) for (int c = 0; c < columns.Count; c++) ws.Cell(r + 2, c + 1).Value = Convert.ToString(rows[r][columns[c]]);
            ws.Row(1).Style.Font.Bold = true; ws.SheetView.FreezeRows(1); ws.Columns().AdjustToContents();
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
