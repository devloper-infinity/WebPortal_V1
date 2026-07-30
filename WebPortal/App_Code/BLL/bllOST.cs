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
    public class bllOST
    {
        dalOST dalOst = new dalOST();
        public DataTable GetErpDailyProductivity(string Code, int ProjectId, int process, string CurrentDate)
        {
            return dalOst.GetErpDailyProductivity(Code, ProjectId, process, CurrentDate);
        }

        public DataTable GetAllProductRelatedToProject(string ProjectNumber)
        {
            return dalOst.GetAllProductRelatedToProject(ProjectNumber);
        }

        public DataTable GetAllProject(int UserId)
        {
            return dalOst.GetAllProject(UserId);
        }

        public DataTable GetAbstractorDocuments(int AbstractiorID)
        {
            return dalOst.GetAbstractorDocuments(AbstractiorID);
        }

        public int DeleteInfinityOrder(int OrderID)
        {
            return dalOst.DeleteInfinityOrder(OrderID);
        }

        public DataTable GetAbstractorCostingCoverage(int AbstractiorID)
        {
            return dalOst.GetAbstractorCostingCoverage(AbstractiorID);
        }

        public DataTable GetAllInfinityOrderTraking(string FromDate, string ToDate, string ProjectNumber)
        {
            return dalOst.GetAllInfinityOrderTraking(FromDate, ToDate, ProjectNumber);
        }

        public DataTable GetOrderDetailsProcesswise(int OrderID)
        {
            return dalOst.GetOrderDetailsProcesswise(OrderID);
        }

        public int InsertOrderTask(Hashtable htParam)
        {
            return dalOst.InsertOrderTask(htParam);
        }

        public int InsertCommentOrder(int OrderId, int ProcessId, string ProcessName, string Comment, int AddedBy)
        {
            return dalOst.InsertCommentOrder(OrderId, ProcessId, ProcessName, Comment, AddedBy);
        }


        public DataTable GetTempleteWiseOrders(string FromDate, string ToDate, string ProjectNumber)
        {
            return dalOst.GetTempleteWiseOrders(FromDate, ToDate, ProjectNumber);
        }

        public DataTable GetAllPendingOrders(int UserId)
        {
            return dalOst.GetAllPendingOrders(UserId);
        }

        public DataTable GetCurrentProcessOfUser(int OrderId, int TaskAssignedId)
        {
            return dalOst.GetCurrentProcessOfUser(OrderId, TaskAssignedId);
        }

        public DataTable GetOrdersOnProcessForUser(int OrderId, int TaskAssignedId, int ProcessId)
        {
            return dalOst.GetOrdersOnProcessForUser(OrderId, TaskAssignedId, ProcessId);
        }

        public int UpdateTaskStatusAndDate(Hashtable htParam)
        {
            return dalOst.UpdateTaskStatusAndDate(htParam);
        }

        public int ValidateCostingProcessWise(int OrderID, int Process)
        {
            return dalOst.ValidateCostingProcessWise(OrderID, Process);
        }

        public string GetCodeFromEmployeeId(string EmployeeId, string OrderNo, string ProjectName)
        {
            return dalOst.GetCodeFromEmployeeId(EmployeeId, OrderNo, ProjectName);
        }

        public int InsertOrderAttachment(Hashtable htParam)
        {
            return dalOst.InsertOrderAttachment(htParam);
        }

        public int DispatchOrderTask(Hashtable htParam)
        {
            return dalOst.DispatchOrderTask(htParam);
        }

        public int FeedBackOrders(Hashtable htParam)
        {
            return dalOst.FeedBackOrders(htParam);
        }

        public int InsertProductionManualCosting(Hashtable htParam)
        {
            return dalOst.InsertProductionManualCosting(htParam);
        }

        public DataTable GetOrderCostingForUpdate(int OrderId)
        {
            return dalOst.GetOrderCostingForUpdate(OrderId);
        }

        public DataTable GetOrderCostingByOrder(int OrderID)
        {
            return dalOst.GetOrderCostingByOrder(OrderID);
        }

        public DataTable GetAbstractorOrderCostingDetails(int OrderID)
        {
            return dalOst.GetAbstractorOrderCostingDetails(OrderID);
        }

        public int InsertAbstractorManualCosting(Hashtable htParam)
        {
            return dalOst.InsertAbstractorManualCosting(htParam);
        }

        public DataTable GetOrderCostingForCCUpdate(int OrderId)
        {
            return dalOst.GetOrderCostingForCCUpdate(OrderId);
        }

        public int InsertCreditCardPayInfoForCosting(Hashtable htParam)
        {
            return dalOst.InsertCreditCardPayInfoForCosting(htParam);
        }

        public DataTable getBillingPeriodByProject(string Project)
        {
            return dalOst.getBillingPeriodByProject(Project);
        }

        public DataTable GetAllProcessOnProjectTemplate(int ProjectID)
        {
            return dalOst.GetAllProcessOnProjectTemplate(ProjectID);
        }

        //public int InsertCommentOrder(Hashtable htParam)
        //{
        //    return dalOst.InsertCommentOrder(htParam);
        //}

        public DataTable GetAllState()
        {
            return dalOst.GetAllState();
        }

        public DataTable GetAllCounty()
        {
            return dalOst.GetAllCounty();
        }

        public DataTable GetAllStateCountyInfo()
        {
            return dalOst.GetAllStateCountyInfo();
        }

        public DataTable GetCountyForState(string StateCode)
        {
            return dalOst.GetCountyForState(StateCode);
        }

        public DataTable GetAllTemplate()
        {
            return dalOst.GetAllTemplate();
        }

        public DataTable GetAllTemplateProject(int ProjectID)
        {
            return dalOst.GetAllTemplateProject(ProjectID);
        }

        public int InsertInfinityOrder(Hashtable htParam)
        {
            return dalOst.InsertInfinityOrder(htParam);
        }

        //public int InsertCommentOrder(Hashtable htParam)
        //{
        //    return dalOst.InsertCommentOrder(htParam);
        //}

        public DataTable GetMaxOrderID()
        {
            return dalOst.GetMaxOrderID();
        }

        public DataTable GetAllDocAndProductRelatedToProject(string ProjectNo, string ProductType)
        {
            return dalOst.GetAllDocAndProductRelatedToProject(ProjectNo, ProductType);
        }

        public DataTable GetAllInfinityOrderbyEmpForComments(int EmpId)
        {
            return dalOst.GetAllInfinityOrderbyEmpForComments(EmpId);
        }

        public DataTable GetAllInfinityOrderbyEmp(int EmpId)
        {
            return dalOst.GetAllInfinityOrderbyEmp(EmpId);
        }

        public DataTable GetAllInfinityOrderbyEmpAndProject(int EmpId, string ProjectNumber)
        {
            return dalOst.GetAllInfinityOrderbyEmpAndProject(EmpId, ProjectNumber);
        }

        public DataTable GetUsersOnUserType(string UserType)
        {
            return dalOst.GetUsersOnUserType(UserType);
        }

        public DataTable ViewReviewChainSheet(int OrderId, int ProcessId)
        {
            return dalOst.ViewReviewChainSheet(OrderId, ProcessId);
        }

        public DataTable GetOrderByID(int OrderID)
        {
            return dalOst.GetOrderByID(OrderID);
        }

        public DataTable GetOrderByID_VM(int OrderID)
        {
            return dalOst.GetOrderByID_VM(OrderID);
        }

        public DataTable ViewSearchOrderForVM(int employeeId)
        {
            return dalOst.ViewSearchOrderForVM(employeeId);
        }

        public DataTable GetAbstractorCoverageDetails(int orderId)
        {
            return dalOst.GetAbstractorCoverageDetails(orderId);
        }

        public int InsertOrderTaskForAbstractor(Hashtable parameters)
        {
            return dalOst.InsertOrderTaskForAbstractor(parameters);
        }
        public DataTable GetCostingDetailsProcessWise(int OrderID)
        {
            return dalOst.GetCostingDetailsProcessWise(OrderID);
        }


        public DataTable GetAllInfinityOrderByProjectAndUser(int UserId, int ProjectId)
        {
            return dalOst.GetAllInfinityOrderByProjectAndUser(UserId, ProjectId);
        }

        public DataTable BindStateCountyInfo(string State, string County)
        {
            return dalOst.BindStateCountyInfo(State, County);
        }

        public DataTable GetAllProductType()
        {
            return dalOst.GetAllProductType();
        }

        public DataTable GetAllDocType()
        {
            return dalOst.GetAllDocType();
        }


        public string GetUserTypeByEmployeeID(int EmployeeID, string UserType)
        {
            return dalOst.GetUserTypeByEmployeeID(EmployeeID, UserType);
        }

        public DataTable GetAllProcesswiseOrder_Summary(int ProcessId, int UserId, string ProjectNumber, int prevProcessId)
        {
            return dalOst.GetAllProcesswiseOrder_Summary(ProcessId, UserId, ProjectNumber, prevProcessId);
        }

        public DataTable GetAllProcesswiseOrderForAllocationNew(int ProcessId, int UserId, string ProjectNumber, int prevProcessId, string ProductType, string OrderDate)
        {
            return dalOst.GetAllProcesswiseOrderForAllocationNew(ProcessId, UserId, ProjectNumber, prevProcessId, ProductType, OrderDate);
        }

        public DataTable getBillingPeriod()
        {
            return dalOst.getBillingPeriod();
        }

        public int VerifyOstOrdersForBilling(int OrderID, string Project, int AddedBy, string Remark)
        {
            return dalOst.VerifyOstOrdersForBilling(OrderID, Project, AddedBy, Remark);
        }

        public int UpdateBillingInBillingDB(int ProjectID, string period, string BillingCycle, int BillingBy, string ProductionBillingDate, string BillingDate, bool Isdelay, string remark, string BillingStatus)
        {
            return dalOst.UpdateBillingInBillingDB(ProjectID, period, BillingCycle, BillingBy, ProductionBillingDate, BillingDate, Isdelay, remark, BillingStatus);
        }


        public int UpdateBillingRemark(int OrderID, string Remark, string Cost)
        {
            return dalOst.UpdateBillingRemark(OrderID,  Remark,  Cost);
        }

        public DataTable GetProjectWiseOrderDetailsForBilling_ForVerification_Bill(string Project, string FromDate, string ToDate)
        {
            return dalOst.GetProjectWiseOrderDetailsForBilling_ForVerification_Bill(Project, FromDate, ToDate);
        }


        public int HoldOrdersPending(string Project, string FromDate, string ToDate)
        {
            return dalOst.HoldOrdersPending(Project, FromDate, ToDate);
        }

        public DataTable GetProjectWiseOrderDetailsForBilling_ForVerification(string ProjectNo, string FromDate, string ToDate)
        {
            return dalOst.GetProjectWiseOrderDetailsForBilling_ForVerification(ProjectNo, FromDate, ToDate);
        }

        public DataTable GetSummaryProjectWise_Date(string ProjectNo, string FromDate, string ToDate)
        {
            return dalOst.GetSummaryProjectWise_Date(ProjectNo, FromDate, ToDate);
        }

        public DataTable TMMGetProjectWiseOrderDetailsForBilling(string Project, string FromDate, string ToDate)
        {
            return dalOst.TMMGetProjectWiseOrderDetailsForBilling(Project, FromDate, ToDate);
        }

        public DataTable GetAllAbsRegistration()
        {
            return dalOst.GetAllAbsRegistration();
        }

        public int InsertReAllocation(Hashtable htParam)
        {
            return dalOst.InsertReAllocation(htParam);
        }

        public int UpdateTaskRemark(int TaskId, string Remark)
        {
            return dalOst.UpdateTaskRemark(TaskId, Remark);
        }

        public int CancelOrder(Hashtable htParam)
        {
            return dalOst.CancelOrder(htParam);
        }

        public int ResetOrder(Hashtable htParam)
        {
            return dalOst.ResetOrder(htParam);
        }

        public int ReOpenHoldOrder(Hashtable htParam)
        {
            return dalOst.ReOpenHoldOrder(htParam);
        }

        public int HoldOrder(Hashtable htParam)
        {
            return dalOst.HoldOrder(htParam);
        }

        public DataTable GetAllInfinityOrderStatus_UserWiseAllocatoin() { return dalOst.GetAllInfinityOrderStatus_UserWiseAllocatoin(); }
        public DataTable GetOrdersOnProject(int employeeId, string projectNumber) { return dalOst.GetOrdersOnProject(employeeId, projectNumber); }
        public DataTable GetAllInfinityOrderbyEmpAndProject_UploadDoc(int employeeId, string projectNumber, string orderDate) { return dalOst.GetAllInfinityOrderbyEmpAndProject_UploadDoc(employeeId, projectNumber, orderDate); }
        public DataTable GetCurrentProcessOfUserPM(int orderId) { return dalOst.GetCurrentProcessOfUserPM(orderId); }
        public DataTable GetOrdersOnProcess(int orderId, int processId) { return dalOst.GetOrdersOnProcess(orderId, processId); }
        public DataTable GetDetailsFromTask(int taskId) { return dalOst.GetDetailsFromTask(taskId); }
        public DataTable GetAllInfinityCaller() { return dalOst.GetAllInfinityCaller(); }
        public DataTable GetCurrentProcessOfUser_ForUploadDoc(int orderId, int taskAssignedId) { return dalOst.GetCurrentProcessOfUser_ForUploadDoc(orderId, taskAssignedId); }
        public DataTable GetAllUploadAndDownloadSearch(string orderNo) { return dalOst.GetAllUploadAndDownloadSearch(orderNo); }
        public DataTable TMMGetProjectWiseOrderDetailsForBilling_EditCosting(string project, string fromDate, string toDate) { return dalOst.TMMGetProjectWiseOrderDetailsForBilling_EditCosting(project, fromDate, toDate); }

    }
}
