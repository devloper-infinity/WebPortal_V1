using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllAsset
    {
        dalAsset dalAsset = new dalAsset();
        public int InsertAssetGroup(Hashtable htparam)
        {
            return dalAsset.InsertAssetGroup(htparam);
        }

        public DataTable GetAllAssetGroup()
        {
            return dalAsset.GetAllAssetGroup();
        }

        public int UpdateAssetGroup(Hashtable htparam)
        {
            return dalAsset.UpdateAssetGroup(htparam);
        }

        public int InsertAssetType(Hashtable htparam)
        {
            return dalAsset.InsertAssetType(htparam);
        }

        public int UpdateAssetType(Hashtable htparam)
        {
            return dalAsset.UpdateAssetType(htparam);
        }

        public DataTable GetAllAssetType()
        {
            return dalAsset.GetAllAssetType();
        }
        public DataTable GetAllBrand()
        {
            return dalAsset.GetAllBrand();
        }
        public int InsertBrand(Hashtable htparam)
        {
            return dalAsset.InsertBrand(htparam);
        }
        public int UpdateBrand(string Brand, int BrandID, int AddedBy)
        {
            return dalAsset.UpdateBrand(Brand, BrandID, AddedBy);
        }

        public DataTable GetAllVendor()
        {
            return dalAsset.GetAllVendor();
        }
        public DataTable GetAllAssets()
        {
            return dalAsset.GetAllAssets();
        }

        public DataTable GetAllAssetStatus()
        {
            return dalAsset.GetAllAssetStatus();
        }
        public DataTable BindAssetType(int AssetGroupId)
        {
            return dalAsset.BindAssetType(AssetGroupId);

        }
        public string GetAbbreviation(string AssetsTypeName)
        {
            return dalAsset.GetAbbreviation(AssetsTypeName);
        }
        public int CreateBarcode(int AssetType)
        {
            return dalAsset.CreateBarcode(AssetType);
        }
        public DataTable BindAssetVendor()
        {
            return dalAsset.BindAssetVendor();
        }
        public int InsertAsset(Hashtable htparam)
        {
            return dalAsset.InsertAsset(htparam);
        }
        public DataTable GetAllRequest(int EmployeeID)
        {
            return dalAsset.GetAllRequest(EmployeeID);
        }
        public DataTable GetAllTicketDepartmentwise(int EmployeeID)
        {
            return dalAsset.GetAllTicketDepartmentwise(EmployeeID);
        }

        public DataTable ViewRequestTicket(int TicketId)
        {
            return dalAsset.ViewRequestTicket(TicketId);
        }

        public DataTable GetDepartment(int RequestId)
        {
            return dalAsset.GetDepartment(RequestId);
        }

        public DataTable GetAllTicketForApproval(int Employee)
        {
            return dalAsset.GetAllTicketForApproval(Employee);
        }

        public DataTable GetTicketForApprval(int TicketId)
        {
            return dalAsset.GetTicketForApprval(TicketId);
        }

        public int InsertAssetStatus(Hashtable htparam)
        {
            return dalAsset.InsertAssetStatus(htparam);
        }

        public int UpdateAssetStatus(Hashtable htparam)
        {
            return dalAsset.UpdateAssetStatus(htparam);
        }

        public int InsertAseetRecovery(Hashtable htParam)
        {
            return dalAsset.InsertAseetRecovery(htParam);
        }

        public DataTable GetAllEmployeeDetailsbyPM(int EmployeeID)
        {
            return dalAsset.GetAllEmployeeDetailsbyPM(EmployeeID);
        }

        public DataTable GetAssetRecovery()
        {
            return dalAsset.GetAssetRecovery();
        }

        public int InsertHostingDetails(Hashtable htParam)
        {
            return dalAsset.InsertHostingDetails(htParam);
        }

        public DataTable GetHostingDetails(int HostID)
        {
            return dalAsset.GetHostingDetails(HostID);
        }

        public DataTable GetAllHostingDetails()
        {
            return dalAsset.GetAllHostingDetails();
        }

        public DataTable ViewStockDetailsReport()
        {
            return dalAsset.ViewStockDetailsReport();
        }

        public int InsertVendor(Hashtable htparam)
        {
            return dalAsset.InsertVendor(htparam);
        }

        public int UpdateVendor(Hashtable htVendor, int VendorID)
        {
            return dalAsset.UpdateVendor(htVendor, VendorID);
        }

        #region Ticket
        public int InsertTicketAssignTo(int AssignTo, int AssignedBy, int TicketID)
        {
            return dalAsset.InsertTicketAssignTo(AssignTo, AssignedBy, TicketID);
        }


        public int InsertTicketForSoftware(Hashtable htTicket)
        {
            return dalAsset.InsertTicketForSoftware(htTicket);
        }

        public int InsertTicket(Hashtable htTicket)
        {
            return dalAsset.InsertTicket(htTicket);
        }

        public int ReOpenTicket(Hashtable htParam)
        {
            return dalAsset.ReOpenTicket(htParam);
        }

        public int UpdateClosureRemark(Hashtable htParam)
        {
            return dalAsset.UpdateClosureRemark(htParam);
        }

        public int UpdateTicketRequestStatus(Hashtable htParam)
        {
            return dalAsset.UpdateTicketRequestStatus(htParam);
        }

        public int UpdateTicketRemark(Hashtable htTicket)
        {
            return dalAsset.UpdateTicketRemark(htTicket);
        }

        public int InsertRemark(Hashtable htParam)
        {
            return dalAsset.InsertRemark(htParam);
        }

        public int InsertTicketApproval(Hashtable HtTicket)
        {
            return dalAsset.InsertTicketApproval(HtTicket);
        }

        public DataTable GetAssignRemarkTicketwise(int TicketId)
        {
            return dalAsset.GetAssignRemarkTicketwise(TicketId);
        }

        public DataTable GetTicketNoSendMail(int TicketNo)
        {
            return dalAsset.GetTicketNoSendMail(TicketNo);
        }


        public DataTable GetTicketInfoByID(int TicketNo)
        {
            return dalAsset.GetTicketInfoByID(TicketNo);
        }

        public DataTable GetAllRemarkTicketwise(int TicketId)
        {
            return dalAsset.GetAllRemarkTicketwise(TicketId);
        }

        public DataTable GetClosedTicket(int TicketNo)
        {
            return dalAsset.GetClosedTicket(TicketNo);
        }

        public DataTable GetOfficialMailIdOfEmployee(int Code)
        {
            return dalAsset.GetOfficialMailIdOfEmployee(Code);
        }
        #endregion
    }
}