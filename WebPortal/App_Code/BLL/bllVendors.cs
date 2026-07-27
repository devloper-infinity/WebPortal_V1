using DocumentFormat.OpenXml.ExtendedProperties;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllVendors
    {
        private readonly dalVendors _dll;

        public bllVendors()
        {
            _dll = new dalVendors();
        }

        public DataTable GetFromDate()
        {
            return _dll.GetFromDate();
        }

        public DataTable GetPQASummary()
        {
            return _dll.GetPQASummary();
        }

        public DataTable GetPQAPendingSummary()
        {
            return _dll.GetPQAPendingSummary();
        }

        public DataTable GetPQAPendingSummaryFile()
        {
            return _dll.GetPQAPendingSummaryFile();
        }


        public int GenerateBillingPeriod(DateTime fromDate, DateTime toDate, string status, long addedBy)
        {
            if (toDate < fromDate)
                throw new ArgumentException("To Date cannot be earlier than From Date.");

            return _dll.GenerateBillingPeriod(fromDate, toDate, status, addedBy);
        }
        public DataTable GetVendorWiseProjectDetails(string vendorCode, int invoiceId)
        {
            if (string.IsNullOrWhiteSpace(vendorCode))
                throw new ArgumentException("Vendor Code is required.", "vendorCode");
            if (invoiceId <= 0)
                throw new ArgumentException("Valid Invoice ID is required.", "invoiceId");

            return new dalVendors().GetVendorWiseProjectDetails(vendorCode.Trim(), invoiceId);
        }
        public DataTable GetVerifyUnVerifyCount(string vendorCode, int invoiceId, string projectNumber)
        {
            return new dalVendors().GetVerifyUnVerifyCount(vendorCode, invoiceId, projectNumber);
        }

        public DataTable GetVerifyUnVerifyFiles(string vendorCode, int invoiceId, string projectNumber, string type)
        {
            return new dalVendors().GetVerifyUnVerifyFiles(vendorCode, invoiceId, projectNumber, type);
        }

        public DataTable CompleteInCompleteFile(string vendorCode,
                                                int invoiceId,
                                                string projectNumber,
                                                string action,
                                                long employeeId)
        {
            return new dalVendors().CompleteInCompleteFile(vendorCode,
                                              invoiceId,
                                              projectNumber,
                                              action,
                                              employeeId);
        }

        public int InsertVendorRegistration(Hashtable htParam)
        {
            return new dalVendors().InsertVendorRegistration(htParam);
        }
        public int UpdateVendorRegistration(Hashtable htParam)
        {
            return new dalVendors().UpdateVendorRegistration(htParam);
        }
        public DataTable GetAllVendorRegistration()
        {
            return new dalVendors().GetAllVendorRegistration();
        }
        public DataTable GetVendorInformation(int VendorID)
        {
            return new dalVendors().GetVendorInformation(VendorID);
        }
        public DataTable GetAllVendorRegistrationInfoByID(int VendorID)
        {
            return new dalVendors().GetAllVendorRegistrationInfoByID(VendorID);
        }
        public DataTable GetEmailDetailsRelatedToAbstractor(string Company)
        {
            return new dalVendors().GetEmailDetailsRelatedToAbstractor(Company);
        }
        public DataTable GetAllReportingManger()
        {
            return new dalVendors().GetAllReportingManger();
        }
        public DataTable GetprojectByPM(string EmployeeID)
        {
            return new dalVendors().GetprojectByPM(EmployeeID);
        }
        public DataTable GetAllProcesswiseOrder_ForAllocation(string ProjectNumber)
        {
            return new dalVendors().GetAllProcesswiseOrder_ForAllocation(ProjectNumber);
        }
        public DataTable GetAllOrderDetaisByProjectAndOrderDate(string ProjectNumber, string OrderDate, string strProcess)
        {
            return new dalVendors().GetAllOrderDetaisByProjectAndOrderDate(ProjectNumber, OrderDate, strProcess);
        }
        public DataTable GetAllOrderDetaisByProjectAndOrderDate(string ProjectNumber, string OrderDate)
        {
            return new dalVendors().GetAllOrderDetaisByProjectAndOrderDate(ProjectNumber, OrderDate);
        }
        public int InsertAllocatedOrderInTrackingSheet(string ProjectNumber, string OrderNumber, string VendorCode, string OrderDate, string OriginalOrderNumber, int AddedBy, string strProcess)
        {
            return new dalVendors().InsertAllocatedOrderInTrackingSheet(ProjectNumber, OrderNumber, VendorCode, OrderDate, OriginalOrderNumber, AddedBy, strProcess);
        }
        public int InsertAllocatedOrderInTrackingSheet(string ProjectNumber, string OrderNumber, string VendorCode, string OrderDate, string OriginalOrderNumber, int AddedBy)
        {
            return new dalVendors().InsertAllocatedOrderInTrackingSheet(ProjectNumber, OrderNumber, VendorCode, OrderDate, OriginalOrderNumber, AddedBy);
        }
        public DataTable GetInputFile_Vendor_ERPWBT(string ProjectNumber, string OrderNumber, string OrderDate)
        {
            return new dalVendors().GetInputFile_Vendor_ERPWBT(ProjectNumber, OrderNumber, OrderDate);
        }
        public int InsertFileForOrder(Hashtable ht, int length)
        {
            return new dalVendors().InsertFileForOrder(ht, length);
        }
        public int CheckIfPMVM(int EmployeeId)
        {
            return new dalVendors().CheckIfPMVM(EmployeeId);
        }
        public DataTable GetAllInfinityOrderTraking_VM(string FromDate, string ToDate, string ProjectNumber)
        {
            return new dalVendors().GetAllInfinityOrderTraking_VM(FromDate, ToDate, ProjectNumber);
        }
        public DataTable GetMyOrders_VM(Hashtable htParam)
        {
            return new dalVendors().GetMyOrders_VM(htParam);
        }
        public DataTable GetOrderDetailsProcesswise(int OrderID)
        {
            return new dalVendors().GetOrderDetailsProcesswise(OrderID);
        }
        public DataTable BindOrderCheckList(int OrderID)
        {
            return new dalVendors().BindOrderCheckList(OrderID);
        }
        public DataTable BindOrderFeedback(int OrderID)
        {
            return new dalVendors().BindOrderFeedback(OrderID);
        }
        public DataTable BindTaxDetails(int OrderID)
        {
            return new dalVendors().BindTaxDetails(OrderID);
        }
        public DataTable GetAllorderCosing(int OrderID)
        {
            return new dalVendors().GetAllorderCosing(OrderID);
        }
        public DataTable GetAllOrderHistory(int OrderID)
        {
            return new dalVendors().GetAllOrderHistory(OrderID);
        }
        public DataTable GetOrderByID_VM(int OrderID)
        {
            return new dalVendors().GetOrderByID_VM(OrderID);
        }

        public DataTable GetOrderByID_VM_Popup(int OrderID)
        {
            return new dalVendors().GetOrderByID_VM_Popup(OrderID);
        }
        public DataTable GetAllCommentOrderwise_VM(int OrderID)
        {
            return new dalVendors().GetAllCommentOrderwise_VM(OrderID);
        }
        public int InsertFollowUp(Hashtable htParam)
        {
            return new dalVendors().InsertFollowUp(htParam);
        }
        public DataTable GetUserofCurrentProcess(int OrderId)
        {
            return new dalVendors().GetUserofCurrentProcess(OrderId);
        }
        public DataTable BindChangeOrderStatus(string UserType)
        {
            return new dalVendors().BindChangeOrderStatus(UserType);
        }
        public int UpdateTaskStatusDateForAbstractor(Hashtable htParam)
        {
            return new dalVendors().UpdateTaskStatusDateForAbstractor(htParam);
        }
        public int UpdateTaskStatusDateForAbstractor(string OrderID, string Remark, int AddedBy)
        {
            return new dalVendors().UpdateTaskStatusDateForAbstractor(OrderID, Remark, AddedBy);
        }
        public int UpdateTaskStatusAbstractorFile(Hashtable htParam, int length)
        {
            return new dalVendors().UpdateTaskStatusAbstractorFile(htParam, length);
        }
        public int CompleteAllocateOrderToVendorInTrackingSheet(string ProjectNumber, string OrderNumber, string OrderDate, int UpdatedBy)
        {
            return new dalVendors().CompleteAllocateOrderToVendorInTrackingSheet(ProjectNumber, OrderNumber, OrderDate, UpdatedBy);
        }
        public int CompleteAllocateOrderToVendorInTrackingSheet(string ProjectNumber, string OrderNumber, string OrderDate, int UpdatedBy, string strProcess)
        {
            return new dalVendors().CompleteAllocateOrderToVendorInTrackingSheet(ProjectNumber, OrderNumber, OrderDate, UpdatedBy, strProcess);
        }
        public int InsertChangeOrderStatus(Hashtable htParam)
        {
            return new dalVendors().InsertChangeOrderStatus(htParam);
        }
        public int InsertOrderAttachment(Hashtable htParam)
        {
            return new dalVendors().InsertOrderAttachment(htParam);
        }
        public int InsertCommentOrder(Hashtable htParam)
        {
            return new dalVendors().InsertCommentOrder(htParam);
        }
        public DataTable GetAllInfinityOrderbyEmp(int EmpId)
        {
            return new dalVendors().GetAllInfinityOrderbyEmp(EmpId);
        }
        public DataTable GetAllStatus()
        {
            return new dalVendors().GetAllStatus();
        }
        public DataTable GetAllInfinityCaller()
        {
            return new dalVendors().GetAllInfinityCaller();
        }
        public DataTable GetCurrentProcessOfUser(int OrderId, int TaskAssignedId)
        {
            return new dalVendors().GetCurrentProcessOfUser(OrderId, TaskAssignedId);
        }
        public DataTable GetAllProcess()
        {
            return new dalVendors().GetAllProcess();
        }
        public DataTable GetOrdersOnProcessForUser(int OrderId, int TaskAssignedId, int ProcessId)
        {
            return new dalVendors().GetOrdersOnProcessForUser(OrderId, TaskAssignedId, ProcessId);
        }
        public DataTable GetDetailsFromTask(int TaskId)
        {
            return new dalVendors().GetDetailsFromTask(TaskId);
        }
        public int UpdateTaskStatusAndDate(Hashtable htParam)
        {
            return new dalVendors().UpdateTaskStatusAndDate(htParam);
        }
        public int DispatchOrderTask(Hashtable htParam)
        {
            return new dalVendors().DispatchOrderTask(htParam);
        }
        public string GetCodeFromEmployeeId(string EmployeeId, string OrderNo, string ProjectName)
        {
            return new dalVendors().GetCodeFromEmployeeId(EmployeeId, OrderNo, ProjectName);
        }
        public int FeedBackOrders(Hashtable htParam)
        {
            return new dalVendors().FeedBackOrders(htParam);
        }
        public DataTable GetAllVendorCompanies()
        {
            return new dalVendors().GetAllVendorDetails();
        }
        public DataTable GetAllVendorCompanies(string Type)
        {
            return new dalVendors().GetAllVendorCompanies(Type);
        }
        public DataTable GetAllState()
        {
            return new dalVendors().GetAllState();
        }
        public DataTable GetAllProductType()
        {
            return new dalVendors().GetAllProductType();
        }
        public DataTable GetAllRegistredUser(string UserType)
        {
            return new dalVendors().GetAllRegistredUser(UserType);
        }
        public DataTable GetAllVendorInfoByID(int ApplicationId)
        {
            return new dalVendors().GetAllVendorInfoByID(ApplicationId);
        }
        public DataTable GetSelectedRegUser(int RId)
        {
            return new dalVendors().GetSelectedRegUser(RId);
        }
        public int DeleteVendorDetails(int ApplicationId)
        {
            return new dalVendors().DeleteVendorDetails(ApplicationId);
        }
        public int CheckUserExist(string Code)
        {
            return new dalVendors().CheckUserExist(Code);
        }
        public int InsertInfinityUserRegistration(Hashtable htParam)
        {
            return new dalVendors().InsertInfinityUserRegistration(htParam);
        }
        public int InsertAbstractorCostInformation(Hashtable htParam)
        {
            return new dalVendors().InsertAbstractorCostInformation(htParam);
        }
        public DataTable GetAbstractorCosting(int AbstractiorID)
        {
            return new dalVendors().GetAbstractorCosting(AbstractiorID);
        }
        public int InsertAbstractorDocuments(Hashtable htParam)
        {
            return new dalVendors().InsertAbstractorDocuments(htParam);
        }
        public DataTable GetAbstractorDocuments(int AbstractiorID)
        {
            return new dalVendors().GetAbstractorDocuments(AbstractiorID);
        }
    }
}