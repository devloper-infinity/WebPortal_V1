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
    public class dalUS
    {
        #region Get Data

        public DataTable GetUSEmployees()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSEmployees");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllUSAssets()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllUSAssets");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetLoanDetails_RemoteUW_REQC(int EmpID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLoanDetails_RemoteUW_REQC_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmpID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLoanDetails_RemoteUW_ByID(int ProcessID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLoanDetails_RemoteUW_ByID_ForNewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProcessID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDatewiseOnShoreProduction(string Date)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDatewiseOnShoreProduction");
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Date);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDatewiseOnShoreProduction_Monthly(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDatewiseOnShoreProduction_Monthly");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetDatewiseOnShoreProduction_Monthly_Report(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDatewiseOnShoreProduction_Monthly_Report");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDatewiseOnShoreProduction_Monthly_Report_Userwise(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDatewiseOnShoreProduction_Monthly_Report_Userwise");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet getLoansForGlobalSearch(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OnShoreGetallLoans_GlobalSearch");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataTable GetOverAllUserPerformance_credit_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformance_credit_Greg");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOverAllUserPerformance_Servicing_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformance_servicing_Greg");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOverAllUserPerformanceDetails_Credit_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformanceDetails_Credit_Greg");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetUSImportedFeedback_ByUser_NewERP(string LoanNo, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSImportedFeedback_ByUser_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, LoanNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOverAllUserPerformanceDetails_Servicing_Greg(int EmployeeID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformanceDetails_Servicing_Greg");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLoanDetailsbyLoanNo(string DealNo, string LoanNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSLoanDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, LoanNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetATRDetailsbyLoanNo(string DealNo, string LoanNo, string Type, int ProcessID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSATRFeedbacks");
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, LoanNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ProcessID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUSProcessList(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUSProcessList");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllTempReQC1(int ReQC)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TempReQC_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@ReQC", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ReQC);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetAllTempReQC2(int ReQC)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TempReQC_2");
            SQLHelper.AddParamToSQLCmd(cmd, "@ReQC", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ReQC);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }


        #endregion

        #region Insert/Update Data

        public int InsertUSImportedFeedback_NewERP(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUSImportedFeedback_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Client", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Client"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UWName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["UWName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@QCName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["QCName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DateReviewed", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["DateReviewed"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@QCDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["QCDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackReceivedDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["FeedbackReceivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Finding", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Finding"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Severity", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Severity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Source", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Source"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }


        // ********* for underwriting database
        public int InsertModifyUWOrderOC22Servicing(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_CompleteAllocateOrderToVendorInTrackingSheet_DISP_Allocation_Servicing_RW_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["OrderNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Review", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Review"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewStartTime", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ReviewStartTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewEndTime", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ReviewEndTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProductType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBY", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["AddedBY"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd_Underwriting(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertOnShoreUSFeedbacks(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertOnShoreUSFeedbaks");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Finding", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Finding"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Severity", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Severity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertOnShoreUSATRFeedbacks(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUSATRFeedback");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reviewer", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Reviewer"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ReviewDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isATRSupported", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["isATRSupported"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewFindings", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["ReviewFindings"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SellerDisclosedDTIIssue", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["SellerDisclosedDTIIssue"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfBorrowers", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NoOfBorrowers"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@HighestBorrowerIncomeType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["HighestBorrowerIncomeType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfSEBusiness", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NoOfSEBusiness"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfRentalProperties", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NoOfRentalProperties"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Comments", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Comments"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertOnShoreProduction(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertOnShoreProduction");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@StartTime", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["StartTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EndTime", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["EndTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TotalTime", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["TotalTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskPerformed", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["TaskPerformed"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Target", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, htParam["Target"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoansReviewed", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["LoansReviewed"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TargetvsProduction", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, htParam["TargetvsProduction"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TotalErrors", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["TotalErrors"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Critical", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["Critical"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NonCritical", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NonCritical"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncorrectErrors", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["IncorrectErrors"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorFindingRate", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, htParam["ErrorFindingRate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CostPerLoan", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, htParam["CostPerLoan"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Comments", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Comments"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }


        public int InsertUSAssets(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUSAssets");
            SQLHelper.AddParamToSQLCmd(cmd, "@User", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["User"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SerialNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["SerialNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Brand", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Brand"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IssueDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["IssueDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable DeleteAllTempReQC1()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TempReQC_11");
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        #endregion

        #region Condition Clearing


        public DataTable GetAllProjectByUserRights_ForAddFeedback(string EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[WBT_usp_GetAllProjectByUserRightsFor_OnlineTracking_ForAddFeedback]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable ViewAllConditionClearing()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_ViewAllConditionClearing]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable ViewAllConditionClearingById(int Id)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ViewAllConditionClearingbyId");
            SQLHelper.AddParamToSQLCmd(cmd, "@Id", SqlDbType.BigInt, 0, ParameterDirection.Input, Id);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetAllProjectDealNumberNew(int ProjectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllProjectDealNo_UW_new]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Projectid", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;

        }

        public DataTable GetAllOrderNoByProjectWise(int ProjectID, string DealNo, string ProcessName, string Review, string Type)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProjectDealNo_OrderNo_UW");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessName", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, ProcessName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Review", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Review);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Type);


            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public int InsertConditionClearing(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_Insert_ConditionClearing");
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ProjectId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InfinityCondition", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["InfinityCondition"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientsRebuttal", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ClientsRebuttal"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReceivedDate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ReceivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewDate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ReviewDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InfinityResponse", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["InfinityResponse"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Cleared", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Cleared"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TotalTime", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["TotalTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InitialExceptionGrade", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["InitialExceptionGrade"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable ViewAllConditionClearingPending()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_ViewAllConditionClearing_Pending_NewERP]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }


        public DataTable GetAllFeedbackByDateRange_NewFormat_Onshore(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllFeedbackByDateRange_NewFormat_OnShore");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllConditionClearing(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ViewAllConditionClearingReport");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UpdateConditionClearing(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_Update_ConditionClearing");
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Id", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["Id"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ProjectId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InfinityCondition", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["InfinityCondition"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientsRebuttal", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ClientsRebuttal"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReceivedDate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ReceivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewDate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["ReviewDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InfinityResponse", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["InfinityResponse"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Cleared", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Cleared"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TotalTime", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["TotalTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Sdate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Sdate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Edate", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["Edate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FinalExceptionGrade", SqlDbType.NVarChar, 4000, ParameterDirection.Input, htParam["FinalExceptionGrade"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }


        #endregion

    }
}