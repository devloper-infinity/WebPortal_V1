using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WebPortal.App_Code.DAL
{
    public class dalAsset
    {
        public int InsertAssetGroup(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetInsertAssetGroup");
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetGroupName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["AssetGroupName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetAllAssetGroup()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetGetAssetGroup");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UpdateAssetGroup(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetUpdateAssetGroup");
            SQLHelper.AddParamToSQLCmd(cmd, "@GroupId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["GroupId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetGroupName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["AssetGroupName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertAssetType(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetInsertAssetType");
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetTypeName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["AssetsTypeName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Abbreviation", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Abbreviation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsAssetNo", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["IsAssetNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetGroupId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AssetGroupId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateAssetType(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetUpdateAssetTypeName");
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetsTypeId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AssetsTypeId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetsTypeName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["AssetsTypeName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Abbreviation", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Abbreviation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetAllAssetType()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetGetAssetType");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllBrand()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetGetAllBrand");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertBrand(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetInsertBrand");
            SQLHelper.AddParamToSQLCmd(cmd, "@Brandname", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Brandname"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateBrand(string Brand, int BrandID, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetUpdateBrand");
            SQLHelper.AddParamToSQLCmd(cmd, "@Brand", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, Brand);
            SQLHelper.AddParamToSQLCmd(cmd, "@BrandID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, BrandID);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetAllVendor()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetGetAllVendor");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllAssets()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllAssetsForReport");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllAssetStatus()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetGetAssetStatus");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable BindAssetType(int AssetGroupId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetGetAssetTypeList");
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetGroupId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AssetGroupId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public string GetAbbreviation(string AssetsTypeName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAbbreviation");
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetsTypeName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, AssetsTypeName);
            string dt = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return dt;
        }

        public int CreateBarcode(int AssetType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetCreateBarcode");
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetType", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AssetType);
            int dt = Convert.ToInt32(SQLHelper.ExecuteScalarCmd(cmd));
            return dt;
        }

        public DataTable BindAssetVendor()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetGetVendorList");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertAsset(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetInsetAsset");
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["AssetName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetType", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AssetType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@assetslno", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["assetslno"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Barcode", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Barcode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["CompanyId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BrandId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["BrandId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeptId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["DeptId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LocationId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["LocationId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PurchaseCost", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["PurchaseCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@vendorId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["vendorId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Acqdate", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Acqdate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Expdate", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Expdate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetStatus", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AssetStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@GroupId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["GroupId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PONumber", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["PONumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InvoiceNumber", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["InvoiceNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PurchaseDate", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["PurchaseDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaxAmount", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["TaxAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OldBarcode", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["OldBarcode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetAllRequest(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllRequest_New");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllTicketDepartmentwise(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TicketGetAllRequestDepartmentwise_delta");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDepartmentWiseTicketReport(int employeeId, string fromDate, string toDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UserTicketReprot_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, employeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, fromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, toDate);
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public DataTable ViewRequestTicket(int TicketId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ViewRequestDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, TicketId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDepartment(int RequestId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetDepartmentByRequest");
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, RequestId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllTicketForApproval(int Employee)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllTicketForApproval");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, Employee);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAssignRemarkTicketwise(int TicketId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TicketAssignRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, TicketId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllRemarkTicketwise(int TicketId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TicketGetAllRemarkTicketwise"); // usp_TicketGetAllRemarkTicketwise
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, TicketId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetTicketForApprval(int TicketId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTicketForApprval");
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, TicketId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetTicketNoSendMail(int TicketNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TicketGetTicketNoForSendMail");
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, TicketNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetTicketInfoByID(int TicketNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTicketInfoByID");
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, TicketNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetClosedTicket(int TicketNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TicketClosedForSendMail");
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, TicketNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOfficialMailIdOfEmployee(int Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TicketGetOfficialIdOfEmployee");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }



        public int InsertAssetStatus(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetInsertAssetStatus");
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetStatus", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["AssetStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateAssetStatus(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetUpdateAssetStatus");
            SQLHelper.AddParamToSQLCmd(cmd, "@StatusId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["StatusId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssetStatus", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["AssetStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }


        public int InsertAseetRecovery(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAssetVerificationWHF");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Asset", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Users"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OtherAsset", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["OtherAsset"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpStatus", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["EmpStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }


        public DataTable GetAllEmployeeDetailsbyPM(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAssetVerificationWHF]");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAssetRecovery()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_ViewAssetRecoveryWFH]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }


        public int InsertHostingDetails(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertHostingDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["DomainName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Provider", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Provider"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RenewedDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["RenewedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ExpiryDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["ExpiryDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RenewelPeriod", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["RenewelPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AdvanceRenewalDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["AdvanceRenewalDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CostPaid", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CostPaid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NextRenewalCost", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["NextRenewalCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AveragePerYear", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["AveragePerYear"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailID", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["EmailID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CreditCardNo", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CreditCardNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CPanelLink", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CPanelLink"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WebLink", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["WebLink"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetHostingDetails(int HostID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllHostingDetailsbyID");
            SQLHelper.AddParamToSQLCmd(cmd, "@HostID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, HostID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllHostingDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllHostingDetails");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable ViewStockDetailsReport()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetStockDetailsReport");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertVendor(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetInsertVendorsDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["VendorName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Contact_Person", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Contact_Person"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Address", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Address"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailId", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["EmailId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Phone", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Phone"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Fax", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Fax"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Web_url", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Web_url"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AcctHolderName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["AccountHolderName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["BankName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BranchNameAddr", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["BranchNameAddr"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AccountType", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["AccountType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AccountNum", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["AccountNum"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MICR", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["MICR"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IFSC", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["IFSC"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@GSTNo", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["GSTNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PANNo", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["PANNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateVendor(Hashtable htVendor, int VendorID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AssetUpdateVendor");
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["VendorName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@vendorId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, VendorID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Contact_Person", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["Contact_Person"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Address", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["Address"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailId", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["EmailId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Phone", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["Phone"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Fax", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["Fax"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Web_url", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["Web_url"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AccHolderName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["AccountHolderName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankName", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["BankName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BranchNameAddr", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["BranchNameAddr"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AcctType", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["AccountType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AcctNo", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["AccountNum"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MICR", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["MICR"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IFSC", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htVendor["IFSC"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htVendor["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        #region Ticket

        public int UpdateTicketRemark(Hashtable htTicket)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateTicketRemark_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htTicket["TicketID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestType", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["RequestType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Priority", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Priority"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NextState", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["NextState"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RemarkType", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["RemarkType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Days", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htTicket["Days"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Hours", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htTicket["Hours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Minutes", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htTicket["Minutes"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htTicket["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertTicketAssignTo(int AssignTo, int AssignedBy, int TicketID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertTicketAssignTo");
            SQLHelper.AddParamToSQLCmd(cmd, "@AssignTo", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AssignTo);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssignedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AssignedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, TicketID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertTicketForSoftware(Hashtable htTicket)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertTicketForSoftware");
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestBy", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["RequestBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeskNo", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["DeskNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subject", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Subject"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestOnBehalf", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["RequestOnBehalf"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReportingManager", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["ReportingManager"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Request", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Request"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Department", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Department"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SendToUsers", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Users"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@GroupUser", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["GroupName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Days", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htTicket["Days"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Hours", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htTicket["Hours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Minutes", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htTicket["Minutes"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertTicket(Hashtable htTicket)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertTicket");
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestBy", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["RequestBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeskNo", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["DeskNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subject", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Subject"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestOnBehalf", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["RequestOnBehalf"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Request", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Request"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Department", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Department"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SendToUsers", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["Users"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@GroupUser", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htTicket["GroupName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Days", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htTicket["Days"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Hours", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htTicket["Hours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Minutes", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htTicket["Minutes"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int ReOpenTicket(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_reOpenTicket");
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["TicketId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateClosureRemark(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateTicketAssignStatusClosed_RemarkNew");
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["TicketId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateTicketRequestStatus(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TicketUpdateRequestStatus");
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestType", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["RequestType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestTypeBy", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["RequestTypeBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Priority", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Priority"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam[" TicketId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Days", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htParam["Days"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Hours", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htParam["Hours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Minutes", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htParam["Minutes"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertRemark(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TicketInsertRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketId", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["TicketId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NextState", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["NextState"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Days", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["Days"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Hours", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["Hours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Minutes", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["Minutes"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RemarkType", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["RemarkType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertTicketApproval(Hashtable htTicket)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertTicketApproval");
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestType", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htTicket["RequestType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Severity", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htTicket["Severity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Priority", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htTicket["Priority"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsApproval", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htTicket["IsApproval"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@ExpCompDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htTicket["ExpCompDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htTicket["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htTicket["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TicketID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htTicket["TicketID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htTicket["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        #endregion
    }
}
