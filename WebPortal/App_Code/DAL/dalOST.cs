using DocumentFormat.OpenXml.Office.Word;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

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

        public DataTable GetOrderDetailsProcesswiseAttachment(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderDetailsAdditionalOrders");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCurrentProcessOfUser(int OrderId, int TaskAssignedId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetCurrentProcessOfUser");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderId);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskAssignedId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, TaskAssignedId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOrdersOnProcessForUser(int OrderId, int TaskAssignedId, int ProcessId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_OST_GetOrdersOnProcessForUser]");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderId);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, TaskAssignedId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProcessId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int ValidateCostingProcessWise(int OrderID, int Process)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_ValidateCostingOrderWise");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, OrderID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, Process);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateTaskStatusAndDate(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_UpdateTaskStatusDate");
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskId", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["TaskId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskStatus", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["TaskStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskAssignedId", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["TaskAssignedId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 10000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaxProcess", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["TaxProcess"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AuditProcess", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AuditProcess"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OfflineProcess", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["OfflineProcess"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public string GetCodeFromEmployeeId(string EmployeeId, string OrderNo, string ProjectName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetCodeFromEmployeeId");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, EmployeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNo", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, OrderNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProjectName);
            string ReturnValue = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertOrderAttachment(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_InsertOrderAttachment");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["OrderId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DocId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["DocId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Path", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Path"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PathFrom", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["PathFrom"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int DispatchOrderTask(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_DispatchOrderTask");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["OrderId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskTemplateid", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["TaskTemplateid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskAssignedId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["TaskAssignedId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Addedby", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AdddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int FeedBackOrders(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertFeedbackOrderProcess");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNo", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htParam["OrderNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectName", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htParam["ProjectName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessName", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htParam["ProcessName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["OrderId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertProductionManualCosting(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_InsertProductionManualCosting");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchEngineType", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["SearchEngineType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchEngineLink", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htParam["SearchEngineLink"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCostNoOfSearches", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["SearchCostNoOfSearches"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCostCost", System.Data.SqlDbType.Decimal, 20, System.Data.ParameterDirection.Input, htParam["SearchCostCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCostTotal", System.Data.SqlDbType.Decimal, 50, System.Data.ParameterDirection.Input, htParam["SearchCostTotal"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCopyCostPattern", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["SearchCopyCostPattern"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCopyCostDocsType", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["SearchCopyCostDocsType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCopyCostPagesDocsMain", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["SearchCopyCostPagesDocsMain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCopyCostCostMain", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["SearchCopyCostCostMain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCopyCostTotalMain", System.Data.SqlDbType.Decimal, 20, System.Data.ParameterDirection.Input, htParam["SearchCopyCostTotalMain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCopyCostPagesDocs", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["SearchCopyCostPagesDocs"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCopyCostCost", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["SearchCopyCostCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchCopyCostTotal", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["SearchCopyCostTotal"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentSearchCostNoOfSeraches", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["JudgmentSearchCostNoOfSeraches"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentSearchCostCost", System.Data.SqlDbType.Decimal, 20, System.Data.ParameterDirection.Input, htParam["JudgmentSearchCostCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentSearchCostTotal", System.Data.SqlDbType.Decimal, 50, System.Data.ParameterDirection.Input, htParam["JudgmentSearchCostTotal"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentCopyCostPattern", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["JudgmentCopyCostPattern"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentCopyCostDocsType", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["JudgmentCopyCostDocsType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentCopyCostPagesDocsMain", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["JudgmentCopyCostPagesDocsMain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentCopyCostCostMain", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["JudgmentCopyCostCostMain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentCopyCostTotalMain", System.Data.SqlDbType.Decimal, 20, System.Data.ParameterDirection.Input, htParam["JudgmentCopyCostTotalMain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentCopyCostPagesDocs", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["JudgmentCopyCostPagesDocs"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentCopyCostCost", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["JudgmentCopyCostCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgmentCopyCostTotal", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["JudgmentCopyCostTotal"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JudgementSearchLink", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["JudgementSearchLink"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaxChargesDescription", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["TaxChargesDescription"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaxAmount", System.Data.SqlDbType.Decimal, 200, System.Data.ParameterDirection.Input, htParam["TaxAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OtherChargesDescription", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["OtherChargesDescription"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OtherChargesAmount", System.Data.SqlDbType.Decimal, 200, System.Data.ParameterDirection.Input, htParam["OtherChargesAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductionCost", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["ProductionCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfDocuments", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["NoOfDocuments"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfPages", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["NoOfPages"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaxInformation", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["TaxInformation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CalledTaxes", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["CalledTaxes"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SnippingTools", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["SnippingTools"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PagesDeliverToClient", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["PagesDeliverToClient"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TotalCost", System.Data.SqlDbType.Decimal, 20, System.Data.ParameterDirection.Input, htParam["TotalCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Addedby", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertInfinity_OST_TaxDetails(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_InsertInfinity_OST_TaxDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FirstBaseAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FirstBaseAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SecondBaseAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["SecondBaseAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ThirdBaseAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ThirdBaseAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FourthBaseAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FourthBaseAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FirstPaidAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FirstPaidAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SecondPaidAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["SecondPaidAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ThirdPaidAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ThirdPaidAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FourthPaidAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FourthPaidAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FirstPaidDate", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FirstPaidDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SecondPaidDate", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["SecondPaidDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ThirdPaidDate", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ThirdPaidDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FourthPaidDate", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FourthPaidDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FirstDueAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FirstDueAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SecondDueAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["SecondDueAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ThirdDueAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ThirdDueAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FourthDueAmount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FourthDueAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FirstDueDate", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FirstDueDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SecondDueDate", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["SecondDueDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ThirdDueDate", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ThirdDueDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FourthDueDate", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FourthDueDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FirstPenalty", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FirstPenalty"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SecondPenalty", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["SecondPenalty"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ThirdPenalty", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ThirdPenalty"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FourthPenalty", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FourthPenalty"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FirstDelinquency", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FirstDelinquency"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SecondDelinquency", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["SecondDelinquency"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ThirdDelinquency", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ThirdDelinquency"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FourthDelinquency", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FourthDelinquency"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Addedby", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int returnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return returnValue;
        }

        public DataTable GetOrderCostingForUpdate(int OrderId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderCostingForBindFields");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderId);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOrderCostingByOrder(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderCostingByOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAbstractorOrderCostingDetails(int OrderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TMM_GetAbstractorOrderCostingDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderID);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertAbstractorManualCosting(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_InsertAbstractorManualCosting");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchEngineType", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["SearchEngineType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchEngineLink", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htParam["SearchEngineLink"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AbstractorSearchCost", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["AbstractorSearchCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AbstractorCopyCostPages", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AbstractorCopyCostPages"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AbstractorCopyCostCostTotal", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["AbstractorCopyCostCostTotal"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OtherCostDescription", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["OtherCostDescription"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OtherCost", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["OtherCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AbstractorTotalCost", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htParam["AbstractorTotalCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Addedby", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetOrderCostingForCCUpdate(int OrderId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_GetOrderCostingForCCFields");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, OrderId);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertCreditCardPayInfoForCosting(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_InsertCreditCardPayInfoForCosting");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ValidFromDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["ValidFromDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ValidUpTo", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["ValidUpTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NameOfThePlant", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["NameOfThePlant"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NameOfTheCard", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["NameOfTheCard"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CreditCardNo", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["CreditCardNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SearchingAmount", System.Data.SqlDbType.Decimal, 20, System.Data.ParameterDirection.Input, htParam["SearchingAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DownloadingAmount", System.Data.SqlDbType.Decimal, 20, System.Data.ParameterDirection.Input, htParam["DownloadingAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Addedby", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
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

        public int InsertCostEmailDetails(Hashtable htDetails)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_Order_CostEmailDetails_Insert");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input,htDetails["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htDetails["BillingPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input,  htDetails["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CostDiff", System.Data.SqlDbType.Decimal, 0, System.Data.ParameterDirection.Input, htDetails["CostDiff"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailNote", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htDetails["EmailNote"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttachmentPath", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htDetails["AttachmentPath"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetCostEmailDetails(int projectId, string billingPeriod)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.Text,
                @"SELECT Project, BillingPeriod, OrderID, CostDifference AS CostDiff,
                         EmailNote AS EmailInput, AttachmentPath
                    FROM Order_CostEmailDetails
                   WHERE Project = @ProjectID
                     AND BillingPeriod = @BillingPeriod
                   ORDER BY OrderID");

            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, projectId);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, billingPeriod);
            return SQLHelper.ExecuteDataTableCmd(cmd);
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

        public DataTable GetOrdersForSentToAccounts(string ProjectNo, string BillingPeriod, string Remark)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOrdersForSentToAccounts");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, BillingPeriod);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Remark);
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

        public int InsertReAllocation(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_InsertReAllocationOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@Orderid", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 10000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskProcessid", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["TaskProcessid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateTaskRemark(int TaskId, string Remark)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_UpdateTaskRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskId", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, TaskId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 10000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int CancelOrder(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_CancelOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 4000, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reason", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Reason"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int ResetOrder(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_ResetOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 4000, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int ReOpenHoldOrder(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_ReOpenHoldOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int HoldOrder(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_OST_HoldOrder");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["OrderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reason", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Reason"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetAllInfinityOrderStatus_UserWiseAllocatoin()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetAllInfinityOrderStatus_UserWiseAllocatoin_WebPortal");
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetOrdersOnProject(int employeeId, string projectNumber)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetOrdersByProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpId", SqlDbType.BigInt, 0, ParameterDirection.Input, employeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNo", SqlDbType.NVarChar, 1000, ParameterDirection.Input, projectNumber);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetCurrentProcessOfUserPM(int orderId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetCurrentProcessOfUserPM");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", SqlDbType.BigInt, 0, ParameterDirection.Input, orderId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetOrdersOnProcess(int orderId, int processId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetOrdersOnProcess");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderId", SqlDbType.BigInt, 0, ParameterDirection.Input, orderId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessId", SqlDbType.Int, 0, ParameterDirection.Input, processId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetDetailsFromTask(int taskId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetDetailsFromTask");
            SQLHelper.AddParamToSQLCmd(cmd, "@Taskid", SqlDbType.BigInt, 0, ParameterDirection.Input, taskId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetAllInfinityCaller()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetAllInfinityCaller");
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetCurrentProcessOfUser_ForUploadDoc(int orderId, int taskAssignedId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetCurrentProcessOfUser_ForUploadDoc");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", SqlDbType.BigInt, 0, ParameterDirection.Input, orderId);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskAssignedId", SqlDbType.BigInt, 0, ParameterDirection.Input, taskAssignedId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetAllUploadAndDownloadSearch(string orderNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_GetAllUploadAndDownloadSearch");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNo", SqlDbType.NVarChar, 1000, ParameterDirection.Input, orderNo);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable TMMGetProjectWiseOrderDetailsForBilling_EditCosting(string project, string fromDate, string toDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_TMM_GetProjectWiseOrderDetailsForBilling_EditCosting");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", SqlDbType.NVarChar, 100, ParameterDirection.Input, project);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", SqlDbType.NVarChar, 100, ParameterDirection.Input, fromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", SqlDbType.NVarChar, 100, ParameterDirection.Input, toDate);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable ViewSearchOrderForVM(int employeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_ViewSearchOrderForVM");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpId", SqlDbType.BigInt, 0, ParameterDirection.Input, employeeId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetAbstractorCoverageDetails(int orderId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_GetAbstractorCoverageDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderID", SqlDbType.BigInt, 0, ParameterDirection.Input, orderId);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public int InsertOrderTaskForAbstractor(Hashtable parameters)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_OST_InsertOrderTaskForAbstractor");
            SQLHelper.AddParamToSQLCmd(cmd, "@Orderid", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["Orderid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskTemplateid", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["TaskTemplateid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["ProductType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Docid", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["Docid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskAssignIdAbs", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["TaskAssignedId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskProcessid", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["TaskProcessid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OnOffLine", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["OnOffLine"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailType", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["EmailType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ETATime", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["ETATime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.Int, 0, ParameterDirection.Input, parameters["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SeachCost", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["SeachCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CopyCost", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["CopyCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Total", SqlDbType.NVarChar, 4000, ParameterDirection.Input, parameters["Total"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int result = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return result;
        }
    }
}
