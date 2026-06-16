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
        
        public DataTable GetProcessDetailsForFeedbackUser(string UserName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "WBT_usp_GetProcessDetilsByUser_ForFeedback_User"); //usp_getuniquecolumn
            SQLHelper.AddParamToSQLCmd(cmd, "@UserCode", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, UserName);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }
    }
}