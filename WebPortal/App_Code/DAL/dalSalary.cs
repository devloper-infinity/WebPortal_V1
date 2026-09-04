using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebPortal.App_Code.Class;

namespace WebPortal.App_Code.DAL
{
    public class dalSalary
    {
        public DataTable GetSalaryIncrementDue(string Month)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "getincrementDetails_New_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@MonthName", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Sal(cmd);
            return dt;
        }

        public DataTable GetEmployeeSalarySlip()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getEmployeeSalary_NewERP");  //usb_getEmployeeSalary
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCostperLoanSummaryReport(string year, string Domain)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getCostPerLoanReportYearly");
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, year);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Domain);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllSalaryLogs(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_SalaryLogReport_NIL_WebPortal");/*usp_SalaryLogReprot_NIL*/
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 50, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Sal(cmd);
            return dt;
        }

        public DataTable getSalaryDetails(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetSalaryDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetSalaryDetails_CurrentMonth(string Code, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetSalaryDetails_CurrentMonth");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetViewTDSDeclaration_OLD(string TaxYear, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TDS_GetManualTDSData_Revised_ForUser_1_22"); //usp_TDS_GetManualTDSData_ForUser//usp_GetViewAllTDSDeclaration
            SQLHelper.AddParamToSQLCmd(cmd, "@TaxYear", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, TaxYear);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetViewTDSDeclaration_NEW(string TaxYear, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_TDS_GetRevisedCalculation_ForDisplay]"); //usp_TDS_GetManualTDSData_ForUser//usp_GetViewAllTDSDeclaration
            SQLHelper.AddParamToSQLCmd(cmd, "@TaxYear", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, TaxYear);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetTaxSlab(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTaxSlab"); //usp_TDS_GetManualTDSData_ForUser//usp_GetViewAllTDSDeclaration
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int InsertTaxSlab(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertTaxSlab");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaxSlab", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["TaxSlab"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetViewTDSDeclaration(string TaxYear, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTDSForDisplay"); //usp_TDS_GetManualTDSData_ForUser//usp_GetViewAllTDSDeclaration
            SQLHelper.AddParamToSQLCmd(cmd, "@TaxYear", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, TaxYear);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllBonus(string Month, int year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllBonus");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllCategory()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCategory");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDocumentNameByCategory(string Category)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDocumentNameByCategoty");
            SQLHelper.AddParamToSQLCmd(cmd, "@Category", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Category);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAnnexure1Data(string Salary)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GenerateAnnexure");
            SQLHelper.AddParamToSQLCmd(cmd, "@Salary", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, Salary);
            System.Data.DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAnnexure1Data_Analyst(string Salary, string IncentiveAmount)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GenerateAnnexure_Analyst");
            SQLHelper.AddParamToSQLCmd(cmd, "@Salary", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, Salary);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncentiveAmount", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, IncentiveAmount);
            System.Data.DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAnnexure1Data_Docs(string Code, string IncentiveAmount)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Usp_GetAnnexureDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncentiveAmount", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, IncentiveAmount);
            System.Data.DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetEmployeeDetailsTransferCompany(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmployeeDetailsTransferCompany");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetEmployeeSalaryIncrementDetailsForLetter(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmployeeSalaryIncrementDetailsForLetter");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetDueForIncrementForStep1(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetIncrementDueReport_Revised_Merge");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int InsertProposedIncrementByPM(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertIncrementProposalForPM");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncrementPercentageByPM", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["IncrementPercentageByPM"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncrementAmount", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["IncrementAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PMRemark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["PMRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalaryAfterIncrement", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["SalaryAfterIncrement"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetAllIncrementDifferenceForReport(string Month, int year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetIncrementDefferenceCalculation");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int InsertBonus(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertBonus");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Amount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MachineIP", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["MachineIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertProposedIncrementByPM_UnderWriting(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertIncrementProposalForPM_UnderWriting");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncrementPercentageByPM", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["IncrementPercentageByPM"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncrementAmount", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["IncrementAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PMRemark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["PMRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalaryAfterIncrement", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["SalaryAfterIncrement"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertIncrementDue_Step1(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertIncrementDue_Step1");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertIncrement(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertIncrement");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CurrentSalary", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["CurrentSalary"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedIP", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["AddedIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovalOf", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ApprovalOf"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NextDueMonth", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["NextDueMonth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NextDueYear", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["NextDueYear"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttendanceBonusType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["AttendanBonusType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttendanceBonus", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AttendanBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@QualityBonus", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["QualityBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsRetentionBonusApplicable", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["IsRetentionBonusApplicable"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RetentionBonus", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, htParam["RetentionBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RetentionBonusPeriod", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["RetentionBonusPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RetentionBonusMonth", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["RetentionBonusMonth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RetentionBonusYear", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["RetentionBonusYear"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataSet GetCostperLoanReport(string Month, string year, string Domain)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getCostPerLoanReport_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, year);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Domain);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataTable GetTotalSalaryReport(string Code, string Period)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetTotalSalaryReport");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Period", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Period);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetTotalSalaryReport(string Period)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetTotalSalaryReportForAll");
            SQLHelper.AddParamToSQLCmd(cmd, "@Period", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Period);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllIncrementForReport(string Month, int year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllIncrementForReport");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetESIPFDeductionReport(string Month, string year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllSalaryDetails_01202017]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, year);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertIncentive(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertIncentive");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Amount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MachineIP", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["MachineIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int UpdateIncentive(int ID, int Amount, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateIncentive");
            SQLHelper.AddParamToSQLCmd(cmd, "@ID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, Amount);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }


        public int DeleteIncentive(int ID, int DeletedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_deleteIncentive");
            SQLHelper.AddParamToSQLCmd(cmd, "@ID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ID);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeletedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, DeletedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllIncentives(string Month, int year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllIncentives");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllIncentivesForReport(string Month, int year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllIncentivesForReport");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetAllIncentivesForApproval(string Month, int year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllIncentivesForApproval");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertOtherSalary(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertOtherSalary");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Amount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MachineIP", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["MachineIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllOtherSalaryDetails(string Month, int year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllOtherSalaryDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UpdateOtherSalary(int ID, int Amount, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateOtherSalary");
            SQLHelper.AddParamToSQLCmd(cmd, "@ID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, Amount);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int DeleteOtherSalary(int ID, int DeletedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_deleteOtherSalary");
            SQLHelper.AddParamToSQLCmd(cmd, "@ID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ID);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeletedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, DeletedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllOtherSalaryDetails_Report(string Month, int year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllOtherSalaryDetails_Report");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetUserInformation(int EmployeeID, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetUserInformationForSalary]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 50, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        //Bind Salary info to salary slip
        public DataTable GetSalaryInfoByEmployeeID(int EmployeeID, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "salary_usp_GetSalaryInfoByEmployeeID");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCompanyById(int CompanyID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCompanyById");
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, CompanyID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }



        public DataTable GetSalaryInfoByEmployeeID_NewERP(int EmployeeID, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "salary_usp_GetSalaryInfoByEmployeeID_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }



        public DataTable GetRegularSalary(string Month, int year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllCurrentMonthSalaryEmployees_Regular");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GenerateRegularBankFormat(string Month, string Year, string BankName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GenerateFormat_Bankwise"); //"usp_PrepareCheque_GetIncrementDifferenceRecords"
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankName", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, BankName);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GenerateOtherSalaryBankFormat(string Month, string Year, string BankName, string Type)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GenerateAxisBankFormatOtherThanSalary_Revised"); //"usp_PrepareCheque_GetIncrementDifferenceRecords"
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankName", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, BankName);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllHoldEmployees(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllHoldEmployees]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int InsertChequeDetails(string ChequeNo, decimal Amount, string SalMonth, string SalYear, int EmployeeId, int Addedby, string Ip)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usb_Insert_ChequeDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@ChequeNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ChequeNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, Amount);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalMonth", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, SalMonth);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalYear", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, SalYear);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Addedby", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, Addedby);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedIP", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, Ip);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertChequeDetails_Other(string ChequeNo, decimal Amount, string SalMonth, string SalYear, int EmployeeId, int Addedby, string Ip, string Type)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usb_Insert_ChequeDetails_Generalised");
            SQLHelper.AddParamToSQLCmd(cmd, "@ChequeNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ChequeNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, Amount);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalMonth", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, SalMonth);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalYear", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, SalYear);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Addedby", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, Addedby);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedIP", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, Ip);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetOtherThanSalaryRecords(string Month, string year, string Type)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_PrepareCheque_GetRecordTypeWise"); //"usp_PrepareCheque_GetIncrementDifferenceRecords"
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, year);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllAdvanceEntries()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllAdvanceEnties");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public int InsertAdvance(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAdvance");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AdvanceAmount", System.Data.SqlDbType.Int, 00, System.Data.ParameterDirection.Input, htParam["AdvanceAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@installment", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["installment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Balance", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Balance"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DoNotDeduct", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["DoNotDeduct"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int UpdateAdvance(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateAdvance");
            SQLHelper.AddParamToSQLCmd(cmd, "@AdvanceId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AdvanceId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@installment", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["installment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int DeleteAdvance(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_deleteAdvance");
            SQLHelper.AddParamToSQLCmd(cmd, "@AdvanceId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AdvanceId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }


        public DataTable GetAllIncrementForApproval(int ApprovalId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllIncrementForApproval");
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovalId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ApprovalId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetIncrementHistory(string code, DateTime? fromDate, DateTime? toDate, int? fromMonth, int? fromYear, int? toMonth, int? toYear, string status)
        {
            const string query = @"
                WITH IncrementHistory AS
                (
                    SELECT
                        im.IncrementID,
                        employee.Code,
                        LTRIM(RTRIM(ISNULL(employee.FirstName, '') + ' ' + ISNULL(employee.LastName, ''))) AS FullName,
                        im.BeforeSalary,
                        im.CurrentSalary,
                        im.Difference,
                        ISNULL(im.AttendanceBonus, 0) AS AttendanceBonus,
                        ISNULL(im.QualityBonus, 0) AS QualityBonus,
                        im.Month,
                        im.Year,
                        CAST((CAST(im.Difference AS DECIMAL(18, 2)) /
                            NULLIF(CAST(im.BeforeSalary AS DECIMAL(18, 2)), 0)) * 100 AS DECIMAL(18, 2)) AS Percentage,
                        im.Remark,
                        im.NextDueMonth,
                        im.NextDueYear,
                        ISNULL(im.RetentionBonus, 0) AS RetentionBonus,
                        CASE WHEN im.RetentionBonusPeriod = 'Select' THEN '' ELSE ISNULL(im.RetentionBonusPeriod, '') END AS RetentionBonusPeriod1,
                        CASE WHEN im.RetentionBonusMonth = 'Select' THEN '' ELSE ISNULL(im.RetentionBonusMonth, '') END AS RetentionBonusMonth1,
                        CASE WHEN im.RetentionBonusYear = 'Select' THEN '' ELSE ISNULL(im.RetentionBonusYear, '') END AS RetentionBonusYear1,
                        LTRIM(RTRIM(ISNULL(addedBy.FirstName, '') + ' ' + ISNULL(addedBy.LastName, ''))) AS AddedByName,
                        im.AddedDate,
                        CASE WHEN ISNULL(im.IsApproved, 0) = 1 THEN 'Approved' ELSE 'Pending' END AS ApprovalStatus,
                        LTRIM(RTRIM(ISNULL(approvedBy.FirstName, '') + ' ' + ISNULL(approvedBy.LastName, ''))) AS ApprovedByName,
                        im.ApprovedDate,
                        CASE LOWER(LTRIM(RTRIM(im.Month)))
                            WHEN 'january' THEN 1
                            WHEN 'february' THEN 2
                            WHEN 'march' THEN 3
                            WHEN 'april' THEN 4
                            WHEN 'may' THEN 5
                            WHEN 'june' THEN 6
                            WHEN 'july' THEN 7
                            WHEN 'august' THEN 8
                            WHEN 'september' THEN 9
                            WHEN 'october' THEN 10
                            WHEN 'november' THEN 11
                            WHEN 'december' THEN 12
                            ELSE 0
                        END AS EffectiveMonthNumber
                    FROM dbo.IncrementMaster im
                    INNER JOIN dbo.EmployeeInfo employee ON employee.EmployeeID = im.EmployeeID
                    LEFT JOIN dbo.EmployeeInfo addedBy ON addedBy.EmployeeID = im.AddedBy
                    LEFT JOIN dbo.EmployeeInfo approvedBy ON approvedBy.EmployeeID = im.ApprovedBy
                )
                SELECT
                    IncrementID, Code, FullName, BeforeSalary, CurrentSalary, Difference,
                    AttendanceBonus, QualityBonus, Month, Year, Percentage, Remark,
                    NextDueMonth, NextDueYear, RetentionBonus, RetentionBonusPeriod1,
                    RetentionBonusMonth1, RetentionBonusYear1, AddedByName, AddedDate,
                    ApprovalStatus, ApprovedByName, ApprovedDate
                FROM IncrementHistory
                WHERE (@Code = '' OR Code = @Code)
                  AND (@FromDate IS NULL OR AddedDate >= @FromDate)
                  AND (@ToDate IS NULL OR AddedDate < DATEADD(DAY, 1, @ToDate))
                  AND (@FromYear IS NULL OR
                       ((Year * 100) + EffectiveMonthNumber) >=
                       ((@FromYear * 100) + ISNULL(@FromMonth, 1)))
                  AND (@ToYear IS NULL OR
                       ((Year * 100) + EffectiveMonthNumber) <=
                       ((@ToYear * 100) + ISNULL(@ToMonth, 12)))
                  AND (@Status = '' OR ApprovalStatus = @Status)
                ORDER BY AddedDate DESC, IncrementID DESC";

            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.Text, query);
            cmd.Parameters.Add("@Code", SqlDbType.NVarChar, 50).Value = code ?? string.Empty;
            cmd.Parameters.Add("@FromDate", SqlDbType.DateTime).Value = (object)fromDate ?? DBNull.Value;
            cmd.Parameters.Add("@ToDate", SqlDbType.DateTime).Value = (object)toDate ?? DBNull.Value;
            cmd.Parameters.Add("@FromMonth", SqlDbType.Int).Value = (object)fromMonth ?? DBNull.Value;
            cmd.Parameters.Add("@FromYear", SqlDbType.Int).Value = (object)fromYear ?? DBNull.Value;
            cmd.Parameters.Add("@ToMonth", SqlDbType.Int).Value = (object)toMonth ?? DBNull.Value;
            cmd.Parameters.Add("@ToYear", SqlDbType.Int).Value = (object)toYear ?? DBNull.Value;
            cmd.Parameters.Add("@Status", SqlDbType.NVarChar, 20).Value = status ?? string.Empty;

            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetIncrementSummaryFilters()
        {
            const string query = @"
                SELECT DISTINCT
                    COALESCE(NULLIF(branch.BranchName, ''), 'Unassigned') AS Location,
                    COALESCE(NULLIF(domain.DomainName, ''), 'Unassigned') AS Domain,
                    COALESCE(NULLIF(NULLIF(LTRIM(RTRIM(employee.SubDomain)), 'Select'), ''), 'Unassigned') AS SubDomain
                FROM dbo.IncrementMaster increment
                INNER JOIN dbo.EmployeeInfo employee ON employee.EmployeeID = increment.EmployeeID
                LEFT JOIN dbo.Branch branch ON branch.BranchID = employee.WorkingBranch
                OUTER APPLY
                (
                    SELECT TOP 1 userDomain.DomainID
                    FROM dbo.UserDomain userDomain
                    WHERE userDomain.EmployeeID = employee.EmployeeID
                    ORDER BY userDomain.AddedDate DESC, userDomain.UserDomainID DESC
                ) latestDomain
                LEFT JOIN dbo.Domain domain ON domain.DomainId = ISNULL(latestDomain.DomainID, employee.Domain)
                ORDER BY Location, Domain, SubDomain";

            SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, query);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetIncrementSummary(int? fromMonth, int? fromYear, int? toMonth, int? toYear, string location, string domain, string subDomain, string status)
        {
            const string query = @"
                WITH IncrementBase AS
                (
                    SELECT
                        increment.IncrementID,
                        increment.EmployeeID,
                        CAST(ISNULL(increment.BeforeSalary, 0) AS DECIMAL(18, 2)) AS BeforeSalary,
                        CAST(ISNULL(increment.CurrentSalary, 0) AS DECIMAL(18, 2)) AS CurrentSalary,
                        CAST(ISNULL(increment.Difference, 0) AS DECIMAL(18, 2)) AS Difference,
                        increment.Month,
                        increment.Year,
                        CASE LOWER(LTRIM(RTRIM(increment.Month)))
                            WHEN 'january' THEN 1
                            WHEN 'february' THEN 2
                            WHEN 'march' THEN 3
                            WHEN 'april' THEN 4
                            WHEN 'may' THEN 5
                            WHEN 'june' THEN 6
                            WHEN 'july' THEN 7
                            WHEN 'august' THEN 8
                            WHEN 'september' THEN 9
                            WHEN 'october' THEN 10
                            WHEN 'november' THEN 11
                            WHEN 'december' THEN 12
                            ELSE 0
                        END AS MonthNumber,
                        COALESCE(NULLIF(branch.BranchName, ''), 'Unassigned') AS Location,
                        COALESCE(NULLIF(domain.DomainName, ''), 'Unassigned') AS Domain,
                        COALESCE(NULLIF(NULLIF(LTRIM(RTRIM(employee.SubDomain)), 'Select'), ''), 'Unassigned') AS SubDomain,
                        CASE WHEN ISNULL(increment.IsApproved, 0) = 1 THEN 'Approved' ELSE 'Pending' END AS ApprovalStatus
                    FROM dbo.IncrementMaster increment
                    INNER JOIN dbo.EmployeeInfo employee ON employee.EmployeeID = increment.EmployeeID
                    LEFT JOIN dbo.Branch branch ON branch.BranchID = employee.WorkingBranch
                    OUTER APPLY
                    (
                        SELECT TOP 1 userDomain.DomainID
                        FROM dbo.UserDomain userDomain
                        WHERE userDomain.EmployeeID = employee.EmployeeID
                        ORDER BY userDomain.AddedDate DESC, userDomain.UserDomainID DESC
                    ) latestDomain
                    LEFT JOIN dbo.Domain domain ON domain.DomainId = ISNULL(latestDomain.DomainID, employee.Domain)
                ),
                FilteredIncrements AS
                (
                    SELECT *
                    FROM IncrementBase
                    WHERE (@FromYear IS NULL OR
                           ((Year * 100) + MonthNumber) >=
                           ((@FromYear * 100) + ISNULL(@FromMonth, 1)))
                      AND (@ToYear IS NULL OR
                           ((Year * 100) + MonthNumber) <=
                           ((@ToYear * 100) + ISNULL(@ToMonth, 12)))
                      AND (@Location = '' OR Location = @Location)
                      AND (@Domain = '' OR Domain = @Domain)
                      AND (@SubDomain = '' OR SubDomain = @SubDomain)
                      AND (@Status = '' OR ApprovalStatus = @Status)
                ),
                SummaryRows AS
                (
                    SELECT
                        Year,
                        Month,
                        MonthNumber,
                        Location,
                        Domain,
                        SubDomain,
                        COUNT(DISTINCT EmployeeID) AS EmployeeCount,
                        COUNT(*) AS IncrementCount,
                        SUM(BeforeSalary) AS SalaryBefore,
                        SUM(CurrentSalary) AS SalaryAfter,
                        SUM(Difference) AS IncreaseAmount,
                        CAST((SUM(Difference) / NULLIF(SUM(BeforeSalary), 0)) * 100 AS DECIMAL(18, 2)) AS IncreasePercentage,
                        CAST(SUM(Difference) / NULLIF(COUNT(DISTINCT EmployeeID), 0) AS DECIMAL(18, 2)) AS AverageIncreasePerEmployee,
                        SUM(CASE WHEN ApprovalStatus = 'Approved' THEN 1 ELSE 0 END) AS ApprovedCount,
                        SUM(CASE WHEN ApprovalStatus = 'Pending' THEN 1 ELSE 0 END) AS PendingCount
                    FROM FilteredIncrements
                    GROUP BY Year, Month, MonthNumber, Location, Domain, SubDomain
                )
                SELECT
                    CAST(Month AS NVARCHAR(20)) + '-' + CAST(Year AS NVARCHAR(10)) AS MonthYear,
                    Location,
                    Domain,
                    SubDomain,
                    EmployeeCount,
                    IncrementCount,
                    SalaryBefore,
                    SalaryAfter,
                    IncreaseAmount,
                    IncreasePercentage,
                    AverageIncreasePerEmployee,
                    ApprovedCount,
                    PendingCount,
                    (SELECT COUNT(DISTINCT EmployeeID) FROM FilteredIncrements) AS TotalEmployees,
                    (SELECT COUNT(*) FROM FilteredIncrements) AS TotalIncrements,
                    (SELECT ISNULL(SUM(BeforeSalary), 0) FROM FilteredIncrements) AS TotalSalaryBefore,
                    (SELECT ISNULL(SUM(CurrentSalary), 0) FROM FilteredIncrements) AS TotalSalaryAfter,
                    (SELECT ISNULL(SUM(Difference), 0) FROM FilteredIncrements) AS TotalIncreaseAmount,
                    (SELECT CAST((SUM(Difference) / NULLIF(SUM(BeforeSalary), 0)) * 100 AS DECIMAL(18, 2))
                     FROM FilteredIncrements) AS TotalIncreasePercentage
                FROM SummaryRows
                ORDER BY Year DESC, MonthNumber DESC, Location, Domain, SubDomain";

            SqlCommand cmd = SQLHelper.GetCommand(CommandType.Text, query);
            cmd.Parameters.Add("@FromMonth", SqlDbType.Int).Value = (object)fromMonth ?? DBNull.Value;
            cmd.Parameters.Add("@FromYear", SqlDbType.Int).Value = (object)fromYear ?? DBNull.Value;
            cmd.Parameters.Add("@ToMonth", SqlDbType.Int).Value = (object)toMonth ?? DBNull.Value;
            cmd.Parameters.Add("@ToYear", SqlDbType.Int).Value = (object)toYear ?? DBNull.Value;
            cmd.Parameters.Add("@Location", SqlDbType.NVarChar, 200).Value = location ?? string.Empty;
            cmd.Parameters.Add("@Domain", SqlDbType.NVarChar, 200).Value = domain ?? string.Empty;
            cmd.Parameters.Add("@SubDomain", SqlDbType.NVarChar, 200).Value = subDomain ?? string.Empty;
            cmd.Parameters.Add("@Status", SqlDbType.NVarChar, 20).Value = status ?? string.Empty;

            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public int approveIncrement_New(int IncrementID, int ApprovedBy, string ApprovedIP, string currentSalary)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_approveIncrement_New");
            SQLHelper.AddParamToSQLCmd(cmd, "@IncrementID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, IncrementID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ApprovedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedIP", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ApprovedIP);
            SQLHelper.AddParamToSQLCmd(cmd, "@CurrentSalary", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, currentSalary);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetIncrementProposalSelected(int EmployeeID, bool isUnderwriting)
        {
            string procedureName = isUnderwriting ? "usp_InsertIncrementProposalData_UW_HVB_Local" : "usp_InsertIncrementProposalData_Revised1906";
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, procedureName);
            SQLHelper.AddParamToSQLCmd(cmd, "@UserID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetIncrementProposalFinal(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertIncrementProposalData_Final_HVB");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetIncrementProposalByCode(string Code, bool isUnderwriting)
        {
            string procedureName = isUnderwriting ? "usp_InsertIncrementProposalData_ByCode_UW" : "usp_InsertIncrementProposalData_ByCode";
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, procedureName);
            SQLHelper.AddParamToSQLCmd(cmd, "@UserCode", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetStandardIncrementOfUser(string Code, int ProposalID, bool isUnderwriting)
        {
            string procedureName = isUnderwriting ? "usp_GetStandardIncrementOfUser_UW" : "usp_GetStandardIncrementOfUser";
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, procedureName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProposalID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ProposalID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetIncrementProposalRemarkLog(string Code, int IncCounter, bool isUnderwriting)
        {
            string procedureName = isUnderwriting ? "usp_GetIncrementProposalRemarkLog_UnderWriting" : "usp_GetIncrementProposalRemarkLog";
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, procedureName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncCounter", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, IncCounter);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetIncrementPerformanceDocs(string Code, int IncCounter, bool isUnderwriting)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getIncrementPerformanceDocs_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            if (isUnderwriting)
            {
                SQLHelper.AddParamToSQLCmd(cmd, "@IncCount", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, IncCounter);
            }
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UploadIncrementPerformanceDoc(string Code, string FilePath, string Remark, int IncCounter)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UploadIncrementPerformanceDoc_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncCount", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, IncCounter);
            SQLHelper.AddParamToSQLCmd(cmd, "@FilePath", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, FilePath);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@UploadedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, HttpContext.Current.User.Identity.Name.ToString());
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertIncrementProposal(Hashtable htParam, bool isUnderwriting)
        {
            string procedureName = isUnderwriting ? "usp_InsertIncrementProposal_Underwriting_Revised" : "usp_InsertIncrementProposal";
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, procedureName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncrementPercentageByPM", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, htParam["IncrementPercentageByPM"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncrementAmount", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["IncrementAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PMRemark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["PMRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalaryAfterIncrement", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["SalaryAfterIncrement"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncYearType", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["IncYearType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NextDueMonth", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, htParam["NextDueMonth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NextDueYear", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["NextDueYear"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsAttnBonus", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["IsAttnBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttendanceBonusType", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, htParam["AttendanceBonusType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttendanceBonus", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AttendanceBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttendanceBonusMonth", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, htParam["AttendanceBonusMonth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttendanceBonusYear", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AttendanceBonusYear"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsNightBonus", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["IsNightBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NightBonus", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["NightBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MachineIP", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["MachineIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@QBonus", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["QBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProposalID", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, htParam["ProposalID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RetentionBonus", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["RetentionBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ForPeriod", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ForPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RetentionMonth", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["RetentionMonth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RetentionYear", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["RetentionYear"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateStandardIncrement(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateStandardIncrement");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncPercentageByPM", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["IncPercentageByPM"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncrementAmount", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["IncrementAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalaryAfterIncrement", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["SalaryAfterIncrement"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProposalID", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, htParam["ProposalID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int DeleteProposedIncrement(string Code, int IncCounter, bool isUnderwriting)
        {
            string procedureName = isUnderwriting ? "usp_DeleteIncrementProposal__UnderWriting" : "usp_DeleteIncrementProposal";
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, procedureName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncCounter", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, IncCounter);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int ProceedProposedIncrement(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ProceedProposedIncrement");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertIncrementFromIncProposal(int ProposalID, string AddedIP, int AddedBy, string Remark, string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertIncrementFromIncProposal");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProposalID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ProposalID);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedIP", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, AddedIP);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int ResetIncrementRecords(int ProposalID, int AddedBy, string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ResetIncrementRecords_UW");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProposalID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ProposalID);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }


    }
}
