using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WebPortal.App_Code.DAL
{
    public class dalTracking
    {
        public DataTable GetFTEDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetFTEDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetProjectandDatewiseTrackingSheetData(int ProjectID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getProjectandDatewiseTrackingData");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertFTEDetails(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_insertFTEConfiguration");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedFTECount", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ApprovedFTECount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillableStandardHours", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["BillableStandardHours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingType", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["BillingType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WeekendAllowed", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["WeekendAllowed"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@USHolidayAllowed", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["USHolidayAllowed"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetAllFieldbyDomain(int DomainID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetAllFieldbyDomain");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, DomainID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDomainByConfigureField()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetAllDomainByConfigureField");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllProjectByDomainWise(int DomainId, int EmployeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetAllProjectByDomainWise");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, DomainId);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, EmployeeId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetFieldNameForProjectConfig(int DomainID, int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetFieldNameForProjectConfig");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, DomainID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllTrackingSheetsColumnsbyProject(int ProjectFieldId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllTrackingSheetsColumnsbyProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectFieldId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectFieldId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetSequenceNoByProject(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetSequenceNo");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertNewColumn(int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_InsertColumn");
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertColumnMapping(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_InsertColumnMapping");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ColumnID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ColumnID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectFieldID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ProjectFieldID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ForBilling", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["ForBilling"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ForImport", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["ForImport"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isCreate", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["isCreate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isUnique", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["isUnique"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SequenceNo", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["SequenceNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Dateformat", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Dateformat"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FieldLength", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["FieldLength"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }


        public string CheckIsAutoColumnByID(int ProjectFieldID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_CheckIsAutoColumnByID");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectFieldID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectFieldID);
            string Return = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return Return;
        }


        public DataTable getAllColumnMappingDetails(int EmployeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_getAllColumnMappingDetails");//WBT_usp_getAllColumnMappingDetails_ICG
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, EmployeeId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDomainByConfigureField(int ProjectFieldId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetAllDomainByConfigureField");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectFieldId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectFieldId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        //public DataTable GetAllProject(int ProjectFieldId)
        //{
        //    SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProject");
        //    DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
        //    return dt;
        //}

        public int DeleteFieldByDomain(int ID, int DeletedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_DeleteFieldByDomain");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainFieldID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ID);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeletedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, DeletedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int UpdateDomainWiseField(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_UpdateFieldNameByDomain");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["DomainID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FieldName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["FieldName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainFieldID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["Id"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UpdatedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["UpdatedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertDomainWiseField(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_InserDomainWiseField");
            SQLHelper.AddParamToSQLCmd(cmd, "@FieldName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["FieldName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["DomainID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isNameColume", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["isNameColume"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isCreate", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["isCreate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int ValidateAutoColumn(int DomainID, string FieldName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_ValidateAutoCoumn");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, DomainID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FieldName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, FieldName);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int ValidateAutoColumnbyProjectConfiguration(int DomainID, int ProjectID, string FieldName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_ValidateAutoColumnbyProjectConfiguration");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, DomainID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FieldName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, FieldName);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public string CheckIsNameColumn(string FieldName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_CheckIsNameColumn");
            SQLHelper.AddParamToSQLCmd(cmd, "@FieldName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, FieldName);
            string Return = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return Return;
        }

        public int InsertProjectWiseField(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[WBT_usp_InsertProjectWiseField]");
            SQLHelper.AddParamToSQLCmd(cmd, "@FieldName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["FieldName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["ProjectId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["DomainId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isVisible", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["isVisible"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isEditable", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["isEditable"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int UpdateDomainAndProjectWiseField(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[WBT_usp_UpdateFieldNameByDomainAndProject]");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["DomainID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FieldName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["FieldName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectFieldId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["Id"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Visible", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["Visible"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Editable", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["Editable"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UpdatedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["UpdatedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int DeleteFieldByDomainAndProject(int ID, int DeletedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[WBT_usp_DeleteFieldByDomainAndProject]");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectFieldId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ID);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeletedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, DeletedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllFieldByProjectAndDomain(int DomainId, int EmployeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetAllFieldbyProjectAndDomain");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, DomainId);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, EmployeeId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public string GetDomainFiledId(string FieldName, int DomainID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetDomainFieldID");
            SQLHelper.AddParamToSQLCmd(cmd, "@FieldName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, FieldName);
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, DomainID);
            string DominID = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return DominID;
        }

        public DataTable GetAllProjectByDefineField(int EmployeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetAllProjectByDefineField");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllColumnByProject(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetAllColumnbyProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllFieldNameByProject(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetAllFieldNameByProject1");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public string getBillingPeriodByProject(string Project)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_getBillingPeriodByProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Project);
            string BillingCycle = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return BillingCycle;
        }

        public DataTable GetProcessDetails(string UserName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetProcessDetilsByUser"); 
            SQLHelper.AddParamToSQLCmd(cmd, "@UserCode", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, UserName);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }


        public int ValidateUserProcessTAT(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ValidateProcessTAT");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["OrderNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProjectId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UserCode", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["UserCode"]);


            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd_Underwriting(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;

        }
        
        public DataTable GetProcessDetailsForFeedbackUser(string UserName, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetProcessDetilsByUser_ForFeedback_User"); //usp_getuniquecolumn
            SQLHelper.AddParamToSQLCmd(cmd, "@UserCode", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, UserName);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetAllProjectFeedbackinERP(int ProjectId, string OrderNo, string Process, string FeedbackBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckFeedbackInERPByProjectId_New");
            SQLHelper.AddParamToSQLCmd(cmd, "@Projectid", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectId);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, OrderNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Process);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackBy", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, FeedbackBy);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable GetAllProjectFeedbackinERP_Servicing(int ProjectId, string OrderNo, string Process, string FeedbackBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckFeedbackInERPByProjectId_servicing");
            SQLHelper.AddParamToSQLCmd(cmd, "@Projectid", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectId);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, OrderNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Process);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackBy", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, FeedbackBy);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }


        public DataTable GetAllProjectDealNo_OrderNo_UW_Process(string ProcessName, string Reviewer, string Type)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllProjectDealNo_OrderNo_UW_Process]");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessName", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProcessName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reviewer", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Reviewer);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable getProcess(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetProcessBYProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public int InsertModifyUWOrderOC22(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_CompleteAllocateOrderToVendorInTrackingSheet_DISP_Allocation_KIP");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["OrderNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Review", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Review"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewEndTime", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ReviewEndTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProductType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBY", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["AddedBY"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertModifyUWOrderOC22Servicing(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_CompleteAllocateOrderToVendorInTrackingSheet_DISP_Allocation_Servicing");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProjectNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNumber", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["OrderNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Review", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Review"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReviewEndTime", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ReviewEndTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["ProductType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBY", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["AddedBY"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
        
        public int InsertFeedbackForNewOrderUnderwritingByTracking(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_InsertFeedbackForNewOrder_KRL");
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderNo", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["OrderNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OrderDate", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["OrderDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorDoneBy ", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["ErrorDoneBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackGivenBy ", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["FeedbackGivenBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy ", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
        }

        public int AddFeedbackForNewOrder(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_AddFeedbackForNewOrder_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@Feedback", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["Feedback"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorType", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["ErrorType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Fatal", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["Fatal"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorField", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["ErrorField"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Section", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["Section"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Field", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["Field"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Error", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["Error"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Shouldbe", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["Shouldbe"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackType", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["FeedbackType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackRecivedDate", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["FeedbackRecivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackerrorPath", SqlDbType.NVarChar, 10000, ParameterDirection.Input, htParam["FeedbackerrorPath"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
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

        public DataTable GetAllDealDispatchDate()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_BindDealDispatchDate]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertLoanDispatchDate(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateDealDispatchDatedate");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ProjectNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DueDate", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["DueDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DispatchDate", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["DispatchDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["LoanNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CreditQC", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["CreditQC"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@complianceQC", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["complianceQC"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public string getActualColumnName(string HeaderName, int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetColumnName");
            SQLHelper.AddParamToSQLCmd(cmd, "@HeaderName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, HeaderName);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectID);
            string Columnname = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return Columnname;
        }

        public DataTable GetIsUniqueColumnForHeader(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetIsUniqueColumnForHeader");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetTrackingsheetLoanForDispatchDate(string ProjectID, string DealNumber)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetTrackingsheetByProject_ForBillingData_DealWise_Dispatch");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNumber", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNumber);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetTrackingsheetLoanForDispatchDate_Servicing(string ProjectID, string DealNumber)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetTrackingsheetByProject_ForBillingData_DealWise_Dispatch_Servicing");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNumber", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNumber);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int GetEmployeePseudonameNew(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPsedonameforattendance_Validate");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Code);
            int ReturnValue = Convert.ToInt32(SQLHelper.ExecuteScalarCmd(cmd));
            return ReturnValue;
        }

        public DataTable GetProcessDetailsForFeedbackUserNew(string UserName, string DealNo, string Status)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetProcessDetilsByUser_ForFeedback_User_Type");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserCode", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, UserName);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Statuts", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Status);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetProcessDashbordDealPending(string DealNo, string Process)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_DashbordDealStatus");
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Process);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetProcessDetailsForFeedbackUserCompleted_New(string UserName, string DealNo, string Status)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetProcessDetilsByUser_ForFeedback_User_Completed_New");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserCode", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, UserName);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, DealNo);
            SQLHelper.AddParamToSQLCmd(cmd, "@Statuts", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Status);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetProcessDetailsForFeedbackUserCompleted(string UserName, string ToDate, string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetProcessDetilsByUser_ForFeedback_User_Completed");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserCode", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, UserName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Todate", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }
    }
}
