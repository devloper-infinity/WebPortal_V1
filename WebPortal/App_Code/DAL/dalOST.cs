using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebPortal.App_Code.BLL;

namespace WebPortal.App_Code.DAL
{
    public class dalOST
    {
        public DataTable GetErpDailyProductivity(string Code, int ProjectId, int process, string CurrentDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetSeachTeamProductivity");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserName", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ProjectId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, process);
            SQLHelper.AddParamToSQLCmd(cmd, "@CurrnetDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, CurrentDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllProductRelatedToProject(string ProjectNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "ups_OST_GetAllProductRelatedToProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProjectNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetTempleteWiseOrders(string FromDate, string ToDate, string ProjectNumber)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetInfinityOrders_All_Test_New");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNo", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProjectNumber);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllProject(int UserId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OSTGetallProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, UserId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAbstractorCostingCoverage(int AbstractorID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetAbstractorCostingCoverage");
            SQLHelper.AddParamToSQLCmd(cmd, "@AbstractorID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AbstractorID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public int DeleteInfinityOrder(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_DeleteInfinityOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null); ;
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetAbstractorDocuments(int AbstractorID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetAbstractorDocuments");
            SQLHelper.AddParamToSQLCmd(cmd, "@AbstractorID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AbstractorID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllInfinityOrderTraking(string FromDate, string ToDate, string ProjectNumber)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetInfinityOrders_All_Test");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNo", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProjectNumber);
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


        public int InsertCommentOrder(int OrderId, int ProcessId, string ProcessName, string Comment, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_InsertCommentOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderId", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, OrderId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessId", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, ProcessId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, ProcessName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Comment", System.Data.SqlDbType.NVarChar, 10000, System.Data.ParameterDirection.Input, Comment);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertOrderTask(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_InsertOrderTask");
            SQLHelper.AddParamToSQLCmd(cmd, "@Orderid", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Orderid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskTemplateid", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["TaskTemplateid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ProductType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Docid", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Docid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskAssignedId", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["TaskAssignedId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskProcessid", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["TaskProcessid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OnOffLine", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OnOffLine"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AllocateTo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["AllocateTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetAllPendingOrders(int UserId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_BindOrderByEmployee_NewERP1");
            SQLHelper.AddParamToSQLCmd(cmd, "@Employee", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, UserId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllInfinityOrderByProjectAndUser(int UserId, int ProjectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetInfinityOrdersByProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, UserId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProjectId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable ViewReviewChainSheet(int OrderId, int ProcessId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_ViewReviewChainSheet");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProcessId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOrderByID(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderById");
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

        public DataTable GetCostingDetailsProcessWise(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderCostingProacessOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUsersOnUserType(string UserType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_OST_GetUsersOnUserType_KRL]"); // OLD  usp_OST_GetUsersOnUserType
            SQLHelper.AddParamToSQLCmd(cmd, "@UserType", System.Data.SqlDbType.NVarChar, 0, System.Data.ParameterDirection.Input, UserType);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable getBillingPeriodByProject(string Project)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_getBillingPeriodByProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Project);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllProcessOnProjectTemplate(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetAllProcessOnProjectTemplate");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllInfinityOrderbyEmpForComments(int EmpId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrdersForComment");
            SQLHelper.AddParamToSQLCmd(cmd, "@Employee", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmpId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllTemplate()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "ups_GetAllInfinityTemplate");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllTemplateProject(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllInfinityProjectTemplate");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }



        public DataTable GetAllInfinityOrderbyEmp(int EmpId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_BindOrderByEmployee");
            SQLHelper.AddParamToSQLCmd(cmd, "@Employee", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmpId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllInfinityOrderbyEmpAndProject(int EmpId, string ProjectNumber)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_BindOrderByEmployeeAndProjectID");
            SQLHelper.AddParamToSQLCmd(cmd, "@Employee", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmpId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, ProjectNumber);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllInfinityOrderbyEmpAndProject_UploadDoc(int EmpId, string ProjectNumber, string Date)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_BindOrderByEmployeeAndProjectID_UploadDoc");
            SQLHelper.AddParamToSQLCmd(cmd, "@Employee", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmpId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, ProjectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, Date);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCountyForState(string StateCode)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetCountyForState");
            SQLHelper.AddParamToSQLCmd(cmd, "@StateCode", System.Data.SqlDbType.NVarChar, 0, System.Data.ParameterDirection.Input, StateCode);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllState()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "ups_OST_GetAllState");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllCounty()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "ups_OST_GetAllCounty");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllStateCountyInfo()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetAllStateCountyInfo");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }



        public DataTable BindStateCountyInfo(string State, string County)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_BindStateCountyInfo");
            SQLHelper.AddParamToSQLCmd(cmd, "@State", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, State);
            SQLHelper.AddParamToSQLCmd(cmd, "@County", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, County);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllProductType()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "ups_OST_GetAllProductMaster");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDocType()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "ups_OST_GetAllDocTypeMaster");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public string GetUserTypeByEmployeeID(int EmployeeID, string UserType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetUserTypeByEmployeeID");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@UserType", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, UserType);
            string Columnname = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return Columnname;
        }

        public DataTable GetAllProcesswiseOrderForAllocationNew(int ProcessId, int UserId, string ProjectNumber, int PrevProcessId, string ProductType, string OrderDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetAllProcesswiseOrderNew");
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskProcessid", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProcessId);
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, UserId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, ProjectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@PrevProcessId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, PrevProcessId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProductType);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, OrderDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllProcesswiseOrder_Summary(int ProcessId, int UserId, string ProjectNumber, int PrevProcessId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetAllProcesswiseOrder_Summary");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, ProjectNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskProcessid", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProcessId);
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, UserId);
            SQLHelper.AddParamToSQLCmd(cmd, "@PrevProcessId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, PrevProcessId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetProjectWiseOrderDetailsForBilling_ForVerification(string ProjectNo, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TMM_GetProjectWiseOrderDetailsForBilling_ForVerification");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetSummaryProjectWise_Date(string ProjectNo, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetAllInfinityOrderStatus_DateWise_Billing");
            SQLHelper.AddParamToSQLCmd(cmd, "@CurrentDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNo", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProjectNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UpdateBillingRemark(int OrderID, string Remark, string Cost)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_UpdateBillingRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, OrderID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Cost);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }


        public int UpdateBillingInBillingDB(int ProjectID, string period, string BillingCycle, int BillingBy, string ProductionBillingDate, string BillingDate, bool isdelay, string remark, string BillingStatus)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_UpdateBillingDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Period", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, period);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingCycle", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, BillingCycle);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, BillingBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductionBillingDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProductionBillingDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingDate", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, BillingDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsDelay", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, isdelay);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingStatus", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, BillingStatus);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetProjectWiseOrderDetailsForBilling_ForVerification_Bill(string Project, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TMM_GetProjectWiseOrderDetailsForBilling_ForVerification_Bill");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Project);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int HoldOrdersPending(string Project, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_TMM_UpdateHoldOrders_Bill]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Project);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int VerifyOstOrdersForBilling(int OrderID, string Project, int AddedBy, string Remark)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_VerifyOstordersForBilling");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, OrderID);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Project);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable getBillingPeriod()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_getBillingPeriod_SearchAll");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable TMMGetProjectWiseOrderDetailsForBilling(string Project, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TMM_GetProjectWiseOrderDetailsForBilling");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Project);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDocAndProductRelatedToProject(string ProjectNo, string ProductType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "ups_OST_GetAllDocsProductRelatedToProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProjectNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProductType);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllAbsRegistration()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetAllAbstractorProfile");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetMaxOrderID()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetMaxOrderID");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertInfinityOrder(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_InsertInfinityOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OrderDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDateTime", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OrderDateTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientOrderNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ClientOrderNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["BName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@State", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["State"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@County", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["County"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ProductType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderTemplateId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["OrderTemplateId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ExpectedTime", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ExpectedTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OnOffLine", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OnOffLine"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Instruction", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Instruction"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.AddParamToSQLCmd(cmd, "@PropertyAddress", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["PropertyAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Path", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Path"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Transaction", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Transaction"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SalesPrice", System.Data.SqlDbType.Money, 0, System.Data.ParameterDirection.Input, htParam["SalesPrice"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SellerName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["SellerName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LegalDescription", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["LegalDescription"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Exhibit", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Exhibit"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientIDNew", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ClientIDNew"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CustomerType", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["CustomerType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderPriority", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["OrderPriority"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Pin", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["Pin"]);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }
    }
}