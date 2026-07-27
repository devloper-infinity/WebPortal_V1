using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WebPortal.App_Code.DAL
{
    public class dalVendors
    {
        private const string SpGetFromDate = "InfinityWBT_GetBillingPeriodDetails";
        private const string SpGetPQASummary = "InfinityWBT_GetBillingPeriodDetails";
        private const string SpGetPQAPendingSummary = "InfinityWBT_VendorBilling_GetPeriodWiseSummaryReportPQAPending_Revised";
        private const string SpGetPQAPendingSummaryFile = "InfinityWBT_VendorBilling_GetVendorWiseProjectFilesCount";
        private const string SpGenerateBillingPeriod = "usp_VendorBilling_GenerateBillingPeriod";
        private const string SpGetVerifyUnVerifyCount =
    "InfintiyWBT_BillingGetVerifyAndUnverifyCount";

        private const string SpGetVerifyUnVerifyFiles =
            "InfinityWBT_VendorBilling_GetVerifiedFilesProjectWise";

        private const string SpCompleteInCompleteFile =
            "InfinityWBT_VendorBilling_CompleteFileInInvoiceDetails";

        private readonly string _connectionString;

        public dalVendors()
        {
            if (SQLHelper.ConnectionString == null || string.IsNullOrWhiteSpace(SQLHelper.ConnectionString))
                throw new ConfigurationErrorsException("Connection string 'constr' was not found in Web.config.");
            _connectionString = SQLHelper.ConnectionString;
        }

        public DataTable GetFromDate()
        {
            return ExecuteTable(SpGetFromDate);
        }

        public DataTable GetPQASummary()
        {
            return ExecuteTable(SpGetPQASummary);
        }

        public DataTable GetPQAPendingSummary()
        {
            return ExecuteTable(SpGetPQAPendingSummary);
        }

        public DataTable GetPQAPendingSummaryFile()
        {
            return ExecuteTable(SpGetPQAPendingSummaryFile);
        }

        public int GenerateBillingPeriod(DateTime fromDate, DateTime toDate, string status, long addedBy)
        {
            SqlParameter returnValue = new SqlParameter("@ReturnValue", SqlDbType.Int) { Direction = ParameterDirection.ReturnValue };
            SqlParameter result = new SqlParameter("@Result", SqlDbType.Int) { Direction = ParameterDirection.Output };

            ExecuteNonQuery(
                SpGenerateBillingPeriod,
                new SqlParameter("@FromDate", SqlDbType.DateTime) { Value = fromDate },
                new SqlParameter("@ToDate", SqlDbType.DateTime) { Value = toDate },
                new SqlParameter("@Status", SqlDbType.VarChar, 50) { Value = status },
                new SqlParameter("@AddedBy", SqlDbType.BigInt) { Value = addedBy },
                result,
                returnValue);

            if (result.Value != DBNull.Value && Convert.ToInt32(result.Value) != 0)
                return Convert.ToInt32(result.Value);
            return returnValue.Value == DBNull.Value ? 0 : Convert.ToInt32(returnValue.Value);
        }

        public DataTable GetVendorWiseProjectDetails(string vendorCode, int invoiceId)
        {
            return ExecuteTable(
                "InfinityWBT_VendorBilling_GetVendorProjectWiseFilesDetails",
                new SqlParameter("@VendorCode", SqlDbType.VarChar, 50) { Value = vendorCode },
                new SqlParameter("@InvoiceId", SqlDbType.Int) { Value = invoiceId });
        }

        private DataTable ExecuteTable(string procedureName, params SqlParameter[] parameters)
        {
            DataTable table = new DataTable();
            using (SqlConnection connection = new SqlConnection(_connectionString))
            using (SqlCommand command = new SqlCommand(procedureName, connection))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 120;
                if (parameters != null && parameters.Length > 0)
                    command.Parameters.AddRange(parameters);
                adapter.Fill(table);
            }
            return table;
        }

        private void ExecuteNonQuery(string procedureName, params SqlParameter[] parameters)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            using (SqlCommand command = new SqlCommand(procedureName, connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 120;
                if (parameters != null && parameters.Length > 0)
                    command.Parameters.AddRange(parameters);
                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        public DataTable GetVerifyUnVerifyCount(
    string vendorCode,
    int invoiceId,
    string projectNumber)
        {
            return ExecuteTable(
                SpGetVerifyUnVerifyCount,
                new SqlParameter("@VendorCode", SqlDbType.VarChar, 50)
                {
                    Value = vendorCode ?? string.Empty
                },
                new SqlParameter("@InvoiceId", SqlDbType.Int)
                {
                    Value = invoiceId
                },
                new SqlParameter("@ProjectName", SqlDbType.VarChar, 100)
                {
                    Value = projectNumber ?? string.Empty
                });
        }
        public DataTable GetVerifyUnVerifyFiles(
    string vendorCode,
    int invoiceId,
    string projectNumber,
    string type)
        {
            return ExecuteTable(
                SpGetVerifyUnVerifyFiles,
                new SqlParameter("@VenCode", SqlDbType.VarChar, 50)
                {
                    Value = vendorCode ?? string.Empty
                },
                new SqlParameter("@InvoiceId", SqlDbType.Int)
                {
                    Value = invoiceId
                },
                new SqlParameter("@ProjectName", SqlDbType.VarChar, 100)
                {
                    Value = projectNumber ?? string.Empty
                },
                new SqlParameter("@Status", SqlDbType.VarChar, 20)
                {
                    Value = type ?? string.Empty
                });
        }
        public DataTable CompleteInCompleteFile(
    string vendorCode,
    int invoiceId,
    string projectNumber,
    string action,
    long addedBy)
        {
            return ExecuteTable(
                SpCompleteInCompleteFile,
                new SqlParameter("@VenCode", SqlDbType.VarChar, 50)
                {
                    Value = vendorCode ?? string.Empty
                },
                new SqlParameter("@InvoiceId", SqlDbType.Int)
                {
                    Value = invoiceId
                },
                new SqlParameter("@ProName", SqlDbType.VarChar, 100)
                {
                    Value = projectNumber ?? string.Empty
                },
                new SqlParameter("@Status", SqlDbType.VarChar, 20)
                {
                    Value = action ?? string.Empty
                },
                new SqlParameter("@GenBy", SqlDbType.BigInt)
                {
                    Value = addedBy
                });
        }

        public int InsertVendorRegistration(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_WBT_InsertVendorProfile");
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorCode", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["VendorCode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Title", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Title"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FirstName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["FirstName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MiddleName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["MiddleName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LastName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["LastName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorType", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htParam["VendorType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReportingManager", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ReportingManager"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["CompanyName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Address", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Address"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContactNo1", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htParam["Contact1"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContactNo2", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htParam["Contact2"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Extension", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htParam["Extension"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MobileNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Mobile"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FaxNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Fax"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmaiID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["EmaiID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }
        public int UpdateVendorRegistration(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_UpdateVendorProfile");
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorCode", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["VendorCode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Title", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Title"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FirstName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["FirstName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MiddleName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["MiddleName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LastName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["LastName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorType", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htParam["VendorType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReportingManager", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htParam["ReportingManager"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["CompanyName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Address", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Address"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContactNo1", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htParam["Contact1"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContactNo2", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htParam["Contact2"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Extension", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htParam["Extension"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MobileNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Mobile"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FaxNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Fax"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmaiID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["EmaiID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetAllVendorRegistration()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_WBT_GetAllVendorProfile");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetVendorInformation(int VendorID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_WBT_GetVendorInformation]");
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorID", System.Data.SqlDbType.BigInt, 50, System.Data.ParameterDirection.Input, VendorID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllVendorRegistrationInfoByID(int VendorID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetVendorProfileInfoByID");
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, VendorID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetEmailDetailsRelatedToAbstractor(string Company)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetEmailDetailsRelatedToAbstractor");
            SQLHelper.AddParamToSQLCmd(cmd, "@Company", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, Company);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllReportingManger()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetAllReportingManger");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetprojectByPM(string EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OSTGetallProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllProcesswiseOrder_ForAllocation(string ProjectNumber)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOrdersFromWBT_ERP_Vendor");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, ProjectNumber);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllOrderDetaisByProjectAndOrderDate(string ProjectNumber, string OrderDate, string strProcess)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProject_GetFilesToAssign_WBTERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, ProjectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, OrderDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, strProcess);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllOrderDetaisByProjectAndOrderDate(string ProjectNumber, string OrderDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProject_GetFilesToAssign_WBTERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, ProjectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, OrderDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int InsertAllocatedOrderInTrackingSheet(string ProjectNumber, string OrderNumber, string VendorCode, string OrderDate, string OriginalOrderNumber, int AddedBy, string strProcess)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_AllocateOrderToVendorInTrackingSheet_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, ProjectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, OrderNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorCode", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, VendorCode);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, OrderDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@OriginalOrderNumber", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, OriginalOrderNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, strProcess);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
        public int InsertAllocatedOrderInTrackingSheet(string ProjectNumber, string OrderNumber, string VendorCode, string OrderDate, string OriginalOrderNumber, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_AllocateOrderToVendorInTrackingSheet");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, ProjectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, OrderNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorCode", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, VendorCode);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, OrderDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@OriginalOrderNumber", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, OriginalOrderNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
        public DataTable GetInputFile_Vendor_ERPWBT(string ProjectNumber, string OrderNumber, string OrderDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOrdersFromWBT_ERP_Vendor_InputFile");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, ProjectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, OrderNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, OrderDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int InsertFileForOrder(Hashtable htParam, int leng)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_InsertFileForOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OrderNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["OrderDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UserName", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["UserName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FileExtension", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["FileExtension"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@File", System.Data.SqlDbType.Binary, leng, System.Data.ParameterDirection.Input, htParam["File"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
        public int CheckIfPMVM(int EmployeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckPMVM");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
        public DataTable GetAllInfinityOrderTraking_VM(string FromDate, string ToDate, string ProjectNumber)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetAllVendorPendingOrders_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNo", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProjectNumber);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetMyOrders_VM(Hashtable htParam)
        {
            //usp_OST_GetInfinityOrders_VM_TrackingSheet
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetInfinityOrders_VM");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["FromDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["ToDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNo", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["UserId"]);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetOrderDetailsProcesswise(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderDetailsProcesswise");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable BindOrderCheckList(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderWiseCheckList");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }
        public DataTable BindOrderFeedback(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderWiseFeedback");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }
        public DataTable BindTaxDetails(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderWiseTaxDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }
        public DataTable GetAllorderCosing(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderWiseCosting");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }
        public DataTable GetAllOrderHistory(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrdersHistory");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }
        public DataTable GetOrderByID_VM(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetVMOrdersDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetOrderByID_VM_Popup(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_Vendor_GetVMOrdersDetails_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllCommentOrderwise_VM(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetAllCommentOrderwise_VM");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int InsertFollowUp(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_InsertCommentOrder_VM");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderId", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OrderId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Comment", System.Data.SqlDbType.NVarChar, 40000, System.Data.ParameterDirection.Input, htParam["Comment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }
        public DataTable GetUserofCurrentProcess(int OrderId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetUserofCurrentProcess");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable BindChangeOrderStatus(string UserType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_WBT_GetVendorChangeOrderStatus");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserType", System.Data.SqlDbType.NVarChar, 0, System.Data.ParameterDirection.Input, UserType);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int UpdateTaskStatusDateForAbstractor(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_Vendor_UpdateTaskStatusDateForAbstractor");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@CompleteFile", System.Data.SqlDbType.VarBinary, 4000, System.Data.ParameterDirection.Input, htParam["CompleteFile"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }
        public int UpdateTaskStatusDateForAbstractor(string OrderID, string Remark, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_Vendor_UpdateTaskStatusDateForAbstractor_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, OrderID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }
        public int UpdateTaskStatusAbstractorFile(Hashtable htParam, int length)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_Vendor_UpdateTaskStatusAbstractorFile");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompleteFile", System.Data.SqlDbType.Binary, length, System.Data.ParameterDirection.Input, htParam["CompleteFile"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }
        public int CompleteAllocateOrderToVendorInTrackingSheet(string ProjectNumber, string OrderNumber, string OrderDate, int UpdatedBy, string strProcess)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_CompleteAllocateOrderToVendorInTrackingSheet_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, ProjectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, OrderNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, OrderDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@UpdatedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, UpdatedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, strProcess);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
        public int CompleteAllocateOrderToVendorInTrackingSheet(string ProjectNumber, string OrderNumber, string OrderDate, int UpdatedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_CompleteAllocateOrderToVendorInTrackingSheet");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, ProjectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, OrderNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, OrderDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@UpdatedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, UpdatedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
        public int InsertChangeOrderStatus(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_Vendor_ChangeOrderTaskStatus");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OrderNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskAssignIdAbs", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["TaskAssignIdAbs"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
    }
}