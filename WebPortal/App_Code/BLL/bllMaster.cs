using DocumentFormat.OpenXml.VariantTypes;
using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.DynamicData;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;
using WebPortal.Admin;
using static WebPortal.Admin.ChildPages;


namespace WebPortal.App_Code.BLL
{
    public class bllMaster
    {
        dalMaster dalMaster = new dalMaster();

        public DataTable GetMenuForUser(int UserID)
        {
            return dalMaster.GetMenuForUser(UserID);
        }

        public DataTable GetMenuForUserFromGroup(int UserID)
        {
            return dalMaster.GetMenuForUserFromGroup(UserID);
        }

        public DataTable GetAllMenus()
        {
            return dalMaster.GetAllMenus();
        }

        public int DeleteRights(int userId)
        {
            return dalMaster.DeleteRights(userId);
        }

        public int InsertRights(int userId, int menuId)
        {
            return dalMaster.InsertRights(userId, menuId);
        }

        public DataTable GetProductivityForUpdate(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetProductivityForUpdate(FromDate, ToDate, EmployeeID);
        }

        public int InsertDailyProductionRemark(Hashtable htparam)
        {
            return dalMaster.InsertDailyProductionRemark(htparam);
        }

        public DataTable GetAllSecuritizationData()
        {
            return dalMaster.GetAllSecuritizationData();
        }

        public int GetAttendanceRequestCount(string usercode)
        {
            return dalMaster.GetAttendanceRequestCount(usercode);

        }

        public int GetAttendanceRequestCount()
        {
            return dalMaster.GetAttendanceRequestCount();

        }

        public int InsertResearchBilling_NewERP(int ProjectID, string BillingPeriod, int AddedBy)
        {
            return dalMaster.InsertResearchBilling_NewERP(ProjectID, BillingPeriod, AddedBy);
        }

        public int VeriftyData(Hashtable htParam)
        {
            return dalMaster.VeriftyData(htParam);
        }

        public string GetUnitHeadEmail(int EmployeeId)
        {
            return dalMaster.GetUnitHeadEmail(EmployeeId);
        }

        public DataTable VerifySecRelLoans()
        {
            return dalMaster.VerifySecRelLoans();
        }

        public int InsertRebuttalBilling_NewERP(int ProjectID, string BillingPeriod, int AddedBy)
        {
            return dalMaster.InsertRebuttalBilling_NewERP(ProjectID, BillingPeriod, AddedBy);
        }

        public DataTable GetGridData_Research(int ProjectId, string DealNo)
        {
            return dalMaster.GetGridData_Research(ProjectId, DealNo);
        }

        public int TruncatetempSecRelLoansList()
        {
            return dalMaster.TruncatetempSecRelLoansList();
        }

        public int GetCCInvoiceImportDetails(string Month, string Year, string Description, decimal Amount, string CardNumber, string TransactionDate)
        {
            return dalMaster.GetCCInvoiceImportDetails(Month, Year, Description, Amount, CardNumber, TransactionDate);
        }

        public DataTable GetGridData_Rebuttal(int ProjectId, string DealNo)
        {
            return dalMaster.GetGridData_Rebuttal(ProjectId, DealNo);
        }

        public DataTable GetAllDealNumberForSentToBilling(int ProjectId)
        {
            return dalMaster.GetAllDealNumberForSentToBilling(ProjectId);
        }


        public DataTable GetAllDealsFromProjectTracking_Revised1()
        {
            return dalMaster.GetAllDealsFromProjectTracking_Revised1();
        }

        public DataTable GetAllDealsFromProjectTracking()
        {
            return dalMaster.GetAllDealsFromProjectTracking();
        }

        public DataTable GetAllDealsFromProjectTracking_Billing()
        {
            return dalMaster.GetAllDealsFromProjectTracking_Billing();
        }

        public int ClearLoanList()
        {
            return dalMaster.ClearLoanList();
        }

        public DataTable GetExistingLoanList()
        {
            return dalMaster.GetExistingLoanList();
        }

        public int GetprojectId(string ProjectName)
        {
            return dalMaster.GetprojectId(ProjectName);
        }

        public string GetCodeFromEmployeeId(int EmployeeId)
        {
            return dalMaster.GetCodeFromEmployeeId(EmployeeId);
        }

        public DataTable GetExistingLogin(string Code, string Date)
        {
            return dalMaster.GetExistingLogin(Code, Date);
        }

        public DataTable GetOverAllUserPerformance_UserPerfAck(int EmployeeID)
        {
            return dalMaster.GetOverAllUserPerformance_UserPerfAck(EmployeeID);
        }

        public DataTable GetOverAllUserPerformance_UserPerfAck_Report(int PerformanceID)
        {
            return dalMaster.GetOverAllUserPerformance_UserPerfAck_Report(PerformanceID);
        }

        public System.Data.DataTable GetUserInformation_KYC(int EmployeeID)
        {
            return dalMaster.GetUserInformation_KYC(EmployeeID);
        }

        public DataTable GetAllMonthlyUserPerformanceAck(string Month, string Year)
        {
            return dalMaster.GetAllMonthlyUserPerformanceAck(Month, Year);
        }

        public int AcknowledgeUserPerformance(int PerformanceID, string Code)
        {
            return dalMaster.AcknowledgeUserPerformance(PerformanceID, Code);
        }

        public DataTable GetAllEmployeeDetailsByIDsForProductivity(string Ids)
        {
            return dalMaster.GetAllEmployeeDetailsByIDsForProductivity(Ids);
        }


        public DataTable GetProductivityDetailsOf_OnlineLogin(int EmployeeID)
        {
            return dalMaster.GetProductivityDetailsOf_OnlineLogin(EmployeeID);
        }


        public DataTable BlockUserLogin(string Code)
        {
            return dalMaster.BlockUserLogin(Code);
        }

        public DataTable GetAllWorkingDetailsByCode(int EmployeeID)
        {
            return dalMaster.GetAllWorkingDetailsByCode(EmployeeID);
        }

        public DataTable GetProductivityforDashboard_Employee(string code)
        {
            return dalMaster.GetProductivityforDashboard_Employee(code);
        }

        public DataTable GetUserPageAndGroupWiseConfig(int UserId)
        {
            return dalMaster.GetUserPageAndGroupWiseConfig(UserId);
        }

        public int CheckPM(int EmployeeID)
        {
            return dalMaster.CheckPM(EmployeeID);
        }

        public int ChangePasswordNew(int EmployeeId, string OldPlainPassword, string OldPassword, string NewPassword, string PlainPassword)
        {
            return dalMaster.ChangePasswordNew(EmployeeId, OldPlainPassword, OldPassword, NewPassword, PlainPassword);
        }

        public DataTable GetEmployeePerformanceDetails()
        {
            return dalMaster.GetEmployeePerformanceDetails();
        }

        public DataTable GetDailyProducvityReport(string from, string to)
        {
            return dalMaster.GetDailyProducvityReport(from, to);
        }

        public DataSet GetTrackingProductionByUserWise_DomainWise(string Date, int EmployeeID, int DomainID)
        {
            return dalMaster.GetTrackingProductionByUserWise_DomainWise(Date, EmployeeID, DomainID);
        }

        public DataTable GetDailyProducvityReport_KPSummary(string from, string to)
        {
            return dalMaster.GetDailyProducvityReport_KPSummary(from, to);
        }

        public DataTable GetAllNotificationsByUserForDashboard(int EmployeeID)
        {
            return dalMaster.GetAllNotificationsByUserForDashboard(EmployeeID);
        }

        public DataTable GetAllStandardReasons()
        {
            return dalMaster.GetAllStandardReasons();
        }

        public DataTable GetEmployeeExtraHours(string Code)
        {
            return dalMaster.GetEmployeeExtraHours(Code);
        }

        public DataTable GetCodeDate(string Code, string Date)
        {
            return dalMaster.GetCodeDate(Code, Date);
        }

        public string CalculateTotalHoursForAttendance(string OutDateTime, string InDateTime)
        {
            return dalMaster.CalculateTotalHoursForAttendance(OutDateTime, InDateTime);
        }

        public int GetEmployeeIdFromCode(string Code)
        {
            return dalMaster.GetEmployeeIdFromCode(Code);
        }

        public DataTable GetAttendamceCorrectionDates(string Code)
        {
            return dalMaster.GetAttendamceCorrectionDates(Code);
        }

        public DataTable GetDateForConnectivityIssuePM(string Code)
        {
            return dalMaster.GetDateForConnectivityIssuePM(Code);
        }

        public DataTable GetLogoutDate(string Code)
        {
            return dalMaster.GetLogoutDate(Code);
        }

        public DataTable GetAlldateByAttendanceRequestLogoutDate(string Code)
        {
            return dalMaster.GetAlldateByAttendanceRequestLogoutDate(Code);
        }

        public int InsertAttendanceCorrectRequest(Hashtable htAttendance)
        {
            return dalMaster.InsertAttendanceCorrectRequest(htAttendance);
        }

        public DataTable GetDashboardPerform()
        {
            return dalMaster.GetDashboardPerform();
        }

        public DataTable GetDashboardProjPerform()
        {
            return dalMaster.GetDashboardProjPerform();
        }

        public DataTable GetDetailsForExcludeRemark(int EmployeeID)
        {
            return dalMaster.GetDetailsForExcludeRemark(EmployeeID);
        }

        public DataTable GetAllDate()
        {
            return dalMaster.GetAllDate();
        }

        public DataTable GetFunFridaySnapsByID(int FFID)
        {
            return dalMaster.GetFunFridaySnapsByID(FFID);
        }

        public DataTable GetSocialSiteVisitorByID(int VisitorID)
        {
            return dalMaster.GetSocialSiteVisitorByID(VisitorID);
        }

        public DataTable getTargetUserWise(string Code, string Project, string Process)
        {
            return dalMaster.getTargetUserWise(Code, Project, Process);
        }

        public DataTable GetAllProjectByUserRights(string EmployeeID)
        {
            return dalMaster.GetAllProjectByUserRights(EmployeeID);
        }

        public int InsertAttritioNRemark(string Code, string Remark, string ResignationDate)
        {
            return dalMaster.InsertAttritioNRemark(Code, Remark, ResignationDate);
        }

        public DataTable CalculateUptoTimeForProductivity(string Code)
        {
            return dalMaster.CalculateUptoTimeForProductivity(Code);
        }

        public DataTable CheckproductivityAcutalHoursIsEqualtimespent(string Code)
        {
            return dalMaster.CheckproductivityAcutalHoursIsEqualtimespent(Code);
        }

        public DataTable CheckproductivityAcutalHoursIsEqualtimespentForUpdate(string Code, string Date)
        {
            return dalMaster.CheckproductivityAcutalHoursIsEqualtimespentForUpdate(Code, Date);
        }

        public int InsertDailyProdcutvityInTempDailyProductivityTable(string Code)
        {
            return dalMaster.InsertDailyProdcutvityInTempDailyProductivityTable(Code);
        }

        public int UpdateDailyProdcutvityInTempDailyProductivityTable(string DailyProductvityID)
        {
            return dalMaster.UpdateDailyProdcutvityInTempDailyProductivityTable(DailyProductvityID);
        }

        public DataTable getTempDailyProductvity(int EmployeeID)
        {
            return dalMaster.getTempDailyProductvity(EmployeeID);
        }

        public DataTable getTempDailyProductvityNew(string Code, string from, string to)
        {
            return dalMaster.getTempDailyProductvityNew(Code, from, to);
        }

        public DataTable GetDailyProductvity(string Code)
        {
            return dalMaster.GetDailyProductvity(Code);
        }

        public DataTable getDailyProductvityForUpdate(string DailyProductvityID)
        {
            return dalMaster.getDailyProductvityForUpdate(DailyProductvityID);
        }

        public int CheckEmployeeisApplicableForAddPRoductivity(string Code, string Date)
        {
            return dalMaster.CheckEmployeeisApplicableForAddPRoductivity(Code, Date);
        }

        public int InsertDailyProdcutvity(Hashtable htDaily)
        {
            return dalMaster.InsertDailyProdcutvity(htDaily);
        }

        public int InsertDailyProdcutvityFor_OnlineTracking(Hashtable htDaily)
        {
            return dalMaster.InsertDailyProdcutvityFor_OnlineTracking(htDaily);
        }

        public int InsertRejectionRemarkFor_OnlineTracking(Hashtable htDaily)
        {
            return dalMaster.InsertRejectionRemarkFor_OnlineTracking(htDaily);
        }

        public int UpdateTempDailyProductivity(Hashtable htDaily)
        {
            return dalMaster.UpdateTempDailyProductivity(htDaily);
        }

        public DataSet getTrackingProductionByUserWise(string Date, int EmployeeID)
        {
            return dalMaster.getTrackingProductionByUserWise(Date, EmployeeID);
        }

        public DataTable GetTempDailyProductivity(string Code, string Date, string ProjectName, string ProcessName, string ProductionType)
        {
            return dalMaster.GetTempDailyProductivity(Code, Date, ProjectName, ProcessName, ProductionType);
        }

        public string ValidateProject(string Project)
        {
            return dalMaster.ValidateProject(Project);
        }

        public string ValidateProcess(string Project, string Process)
        {
            return dalMaster.ValidateProcess(Project, Process);
        }

        public string ValidateProductType(string Project, string Process, string ProductType)
        {
            return dalMaster.ValidateProductType(Project, Process, ProductType);
        }

        public string ValidateUserProjectRights(string EmployeeId, string ProjectId)
        {
            return dalMaster.ValidateUserProjectRights(EmployeeId, ProjectId);
        }

        public DataTable GetAllLeavesForPMLogin(int EmployeeID)
        {
            return dalMaster.GetAllLeavesForPMLogin(EmployeeID);
        }

        public DataTable GetUserLeavesbyCode(string Code)
        {
            return dalMaster.GetUserLeavesbyCode(Code);
        }

        public DataTable GetAllLeavesbyPM(int EmployeeID)
        {
            return dalMaster.GetAllLeavesbyPM(EmployeeID);
        }

        public DataTable GetLeaveDetails(string Code)
        {
            return dalMaster.GetLeaveDetails(Code);
        }

        public int InsertTeamLeavesByPM(Hashtable htTeamLeaves)
        {
            return dalMaster.InsertTeamLeavesByPM(htTeamLeaves);
        }

        public string GetLeavesToDate(string FromDate, int Days)
        {
            return dalMaster.GetLeavesToDate(FromDate, Days);
        }

        public int InsertPaidLeavePM(Hashtable htParam, int LeaveID, string PaidStatus)
        {
            return dalMaster.InsertPaidLeavePM(htParam, LeaveID, PaidStatus);
        }

        public DataTable GetAllUserByPM(string Code)
        {
            return dalMaster.GetAllUserByPM(Code);
        }

        public int InsertEmpAppointmentDate(Hashtable htparam)
        {
            return dalMaster.InsertEmpAppointmentDate(htparam);
        }

        public int CheckIfPM(int EmployeeId)
        {
            return dalMaster.CheckIfPM(EmployeeId);
        }

        public DataTable GetAllEmployeeDetailsbyPMForInitiate(int EmployeeID)
        {
            return dalMaster.GetAllEmployeeDetailsbyPMForInitiate(EmployeeID);
        }

        public DataTable GetAllEmployeeDetailsSolForInitiate()
        {
            return dalMaster.GetAllEmployeeDetailsSolForInitiate();
        }

        public DataTable GetAllEmployeeDetailsForInitiate()
        {
            return dalMaster.GetAllEmployeeDetailsForInitiate();
        }

        public DataTable GetAllProject()
        {
            return dalMaster.GetAllProject();
        }

        public DataTable getProcess(int ProjectID)
        {
            return dalMaster.getProcess(ProjectID);
        }

        public DataTable GetLastWorkingDate(string FormDate, string LastWorkinDate, string ResignationType)
        {
            return dalMaster.GetLastWorkingDate(FormDate, LastWorkinDate, ResignationType);
        }

        public string GetLastLoginDate(string Code)
        {
            return dalMaster.GetLastLoginDate(Code);
        }

        public DataTable GetAllDetailsOnCheckListForNewJoining(String Code)
        {
            return dalMaster.GetAllDetailsOnCheckListForNewJoining(Code);
        }

        public int InitiateResignation(Hashtable htParam)
        {
            return dalMaster.InitiateResignation(htParam);
        }

        public DataTable GetResignedEmployeesForFinalize(int EmployeeID)
        {
            return dalMaster.GetResignedEmployeesForFinalize(EmployeeID);
        }

        public int UpdateUserLeaves(int LeaveId, bool Status, int ApprovedBy, string Remark, string PaidStatus)
        {
            return dalMaster.UpdateUserLeaves(LeaveId, Status, ApprovedBy, Remark, PaidStatus);
        }

        public decimal GetPendingLeaveCount(string Code)
        {
            return dalMaster.GetPendingLeaveCount(Code);
        }

        public DataTable GetAllResignedEmployees(int EmpId)
        {
            return dalMaster.GetAllResignedEmployees(EmpId);
        }

        public DataTable GetAllDailyLogs(int EmployeeID)
        {
            return dalMaster.GetAllDailyLogs(EmployeeID);
        }

        public string GetPassword(string Username)
        {
            return dalMaster.GetPassword(Username);
        }

        public int UpdateResignation(Hashtable htParam)
        {
            return dalMaster.UpdateResignation(htParam);
        }

        public DataTable GetResignationDetails(int ResignationID)
        {
            return dalMaster.GetResignationDetails(ResignationID);
        }

        public DataTable GetResignationDetailsbyEmployeeID(int EmployeeID)
        {
            return dalMaster.GetResignationDetailsbyEmployeeID(EmployeeID);
        }

        public int UpdateExitFormalityRemark(Hashtable htParam)
        {
            return dalMaster.UpdateExitFormalityRemark(htParam);
        }

        public int ChangeResignationType(Hashtable htParam)
        {
            return dalMaster.ChangeResignationType(htParam);
        }

        public int ExtendShortenNoticePeriod(Hashtable htParam)
        {
            return dalMaster.ExtendShortenNoticePeriod(htParam);
        }

        public int CancelResignation(Hashtable htParam)
        {
            return dalMaster.CancelResignation(htParam);
        }

        public int DropOutUser(Hashtable htParam)
        {
            return dalMaster.DropOutUser(htParam);
        }

        public DataTable GetAllShift()
        {
            return dalMaster.GetAllShift();
        }

        public DataTable GetAllDepartment()
        {
            return dalMaster.GetAllDepartment();
        }

        public DataTable GetAllDomain()
        {
            return dalMaster.GetAllDomain();
        }

        public DataSet GetAllDataForHoursSpent(string FromDate, string ToDate)
        {
            return dalMaster.GetAllDataForHoursSpent(FromDate, ToDate);
        }

        public DataTable GetDomainsAsPerEmp(int EmpID)
        {
            return dalMaster.GetDomainsAsPerEmp(EmpID);
        }

        public DataTable GetAllDomainGroups()
        {
            return dalMaster.GetAllDomainGroups();
        }

        public DataTable GetAllBranches()
        {
            return dalMaster.GetAllBranches();
        }

        public DataTable GetAllProjectManager()
        {
            return dalMaster.GetAllProjectManager();
        }

        public DataTable GetAllDesignation()
        {
            return dalMaster.GetAllDesignation();
        }

        public DataTable ProjectManagerRelatedToDepartment(int EmpId)
        {
            return dalMaster.ProjectManagerRelatedToDepartment(EmpId);
        }

        public DataTable GetEmpsByDept(int DepartmentID)
        {
            return dalMaster.GetEmpsByDept(DepartmentID);
        }

        public DataTable GetAllWeeklyHoliday()
        {
            return dalMaster.GetAllWeeklyHoliday();
        }

        public DataTable GetDomainwiseSubdomain(int DomainID)
        {
            return dalMaster.GetDomainwiseSubdomain(DomainID);
        }

        public DataTable GetSubdomains()
        {
            return dalMaster.GetSubdomains();
        }

        public DataTable GetAllBankMasterDetails()
        {
            return dalMaster.GetAllBankMasterDetails();
        }

        public int CodeExists(string Code)
        {
            return dalMaster.CodeExists(Code);
        }

        public string GetCutOffTime(string shift)
        {
            return dalMaster.GetCutOffTime(shift);
        }

        public DataTable GetWeeklyHolidayByHours(int Hours)
        {
            return dalMaster.GetWeeklyHolidayByHours(Hours);
        }

        public DataTable ShowAllLogDetails(string Code, string Date)
        {
            return dalMaster.ShowAllLogDetails(Code, Date);
        }

        public int InsertEmployeeLogInHistory(string Code, bool Status, string Remark, int AddedBy)
        {
            return dalMaster.InsertEmployeeLogInHistory(Code, Status, Remark, AddedBy);
        }



        public string GetBlockedRemarkByCode(string Code)
        {
            return dalMaster.GetBlockedRemarkByCode(Code);
        }

        public DataTable GetAllDailyLogs_Monthwise(int EmployeeID, string Month, string Year)
        {
            return dalMaster.GetAllDailyLogs_Monthwise(EmployeeID, Month, Year);
        }

        public DataTable getTargetUserWise_Productivity(string Code, string Project, string Process, string ProductType)
        {
            return dalMaster.getTargetUserWise_Productivity(Code, Project, Process, ProductType);
        }

        public DataTable GetESIPFInformationForKYC(string Month, int Year)
        {
            return dalMaster.GetESIPFInformationForKYC(Month, Year);
        }

        public int InsertEmployeeKYC(Hashtable htKYC)
        {
            return dalMaster.InsertEmployeeKYC(htKYC);
        }

        public int DeleteTempDailyProductivity(int TempDailyProducvityID)
        {
            return dalMaster.DeleteTempDailyProductivity(TempDailyProducvityID);
        }

        public int InsertDailyProductivitySearching(Hashtable htDaily)
        {
            return dalMaster.InsertDailyProductivitySearching(htDaily);
        }

        public int UpdateTempDailyProductivitySearching(Hashtable htDaily)
        {
            return dalMaster.UpdateTempDailyProductivitySearching(htDaily);
        }

        public DataTable GetAllEmployeeDetails()
        {
            return dalMaster.GetAllEmployeeDetails();
        }

        public DataTable GetAllEmployeeDetails_Dynamic()
        {
            return dalMaster.GetAllEmployeeDetails_Dynamic();
        }

        public DataTable GetAllEmployeeDetailsOnViewProfile(String UserCode)
        {
            return dalMaster.GetAllEmployeeDetailsOnViewProfile(UserCode);
        }

        public int InsertBankAccountNo(Hashtable htBank)
        {
            return dalMaster.InsertBankAccountNo(htBank);
        }

        public DataTable GetAllEmployeeVerificationRecords(string Month, string Year)
        {
            return dalMaster.GetAllEmployeeVerificationRecords(Month, Year);
        }

        public DataTable GetAddressVerificationDataForSummary(string Month, string Year)
        {
            return dalMaster.GetAddressVerificationDataForSummary(Month, Year);
        }

        public DataTable GetResignedEmployeeSummary_MonthWise(string FromDate, string ToDate)
        {
            return dalMaster.GetResignedEmployeeSummary_MonthWise(FromDate, ToDate);
        }

        public int InsertAddressVerification(Hashtable htParam)
        {
            return dalMaster.InsertAddressVerification(htParam);
        }

        public int InsertAddressVerificationDocument(Hashtable htParam)
        {
            return dalMaster.InsertAddressVerificationDocument(htParam);
        }

        public DataTable GetExEmployerVerificationRecords(string Month, string Year)
        {
            return dalMaster.GetExEmployerVerificationRecords(Month, Year);
        }

        public int InsertIsVerificationRequried(Hashtable htParam)
        {
            return dalMaster.InsertIsVerificationRequried(htParam);
        }

        public int InsertEmployeePreVerificationInfo(Hashtable htVerify)
        {
            return dalMaster.InsertEmployeePreVerificationInfo(htVerify);
        }

        public DataTable GetEmployeeVerificationData(int EmployeeID)
        {
            return dalMaster.GetEmployeeVerificationData(EmployeeID);
        }

        public int InsertEmployeeVerificationEmailDetails(Hashtable htVerify)
        {
            return dalMaster.InsertEmployeeVerificationEmailDetails(htVerify);
        }

        public int GetVerificationIDFromEmployeeID(int EmployeeID)
        {
            return dalMaster.GetVerificationIDFromEmployeeID(EmployeeID);
        }

        public DataTable GetEmployeeVerificationRecordsByVerificationID(int verificationID)
        {
            return dalMaster.GetEmployeeVerificationRecordsByVerificationID(verificationID);
        }

        public int InsertEmployeeVerification(Hashtable htVerify)
        {
            return dalMaster.InsertEmployeeVerification(htVerify);
        }

        public DataTable GetFunFriday()
        {
            return dalMaster.GetFunFriday();
        }

        public DataTable GetAllRnRSnaps()
        {
            return dalMaster.GetAllRnRSnaps();
        }

        public int InsertFunFriday(Hashtable htParam)
        {
            return dalMaster.InsertFunFriday(htParam);
        }

        public DataTable GetAllEmployeeDetailsbyPM(string Month, string Year)
        {
            return dalMaster.GetAllEmployeeDetailsbyPM(Month, Year);
        }

        public int InsertFollowupRemark(Hashtable htParam)
        {
            return dalMaster.InsertFollowupRemark(htParam);
        }

        public DataTable GetAllUserCode()
        {
            return dalMaster.GetAllUserCode();
        }

        public int InsertLetterHeadCount(Hashtable htParm)
        {
            return dalMaster.InsertLetterHeadCount(htParm);
        }

        public DataTable GetLetterHEadsCount_Dates(string FromDate, string ToDate)
        {
            return dalMaster.GetLetterHEadsCount_Dates(FromDate, ToDate);
        }

        public DataTable GetAllReadUnreradDashboardAlert()
        {
            return dalMaster.GetAllReadUnreradDashboardAlert();
        }

        public int InsertLeave(Hashtable htParam)
        {
            return dalMaster.InsertLeave(htParam);
        }

        public int InsertPaidLeave(Hashtable htParam, int LeaveID)
        {
            return dalMaster.InsertPaidLeave(htParam, LeaveID);
        }

        public string GetUnitHeadName(int EmployeeId)
        {
            return dalMaster.GetUnitHeadName(EmployeeId);
        }

        public DataTable GetAllEmployeeForAttendancePercentage()
        {
            return dalMaster.GetAllEmployeeForAttendancePercentage();
        }

        public DataTable GetRnR()
        {
            return dalMaster.GetRnR();
        }

        public int InsertRnR(Hashtable htParam)
        {
            return dalMaster.InsertRnR(htParam);
        }

        public DataTable GetAllUsers()
        {
            return dalMaster.GetAllUsers();
        }

        public DataTable GetLastFourYearGrading(string Quarter, int Year, string Code)
        {
            return dalMaster.GetLastFourYearGrading(Quarter, Year, Code);
        }

        public DataTable GetAllPreviousFeedback(int EmployeeID)
        {
            return dalMaster.GetAllPreviousFeedback(EmployeeID);
        }

        public int InsertSkipLevelMeeting(Hashtable htParam)
        {
            return dalMaster.InsertSkipLevelMeeting(htParam);
        }

        public int InsertSkipLevelMeetingAction(Hashtable htParam)
        {
            return dalMaster.InsertSkipLevelMeetingAction(htParam);
        }

        public DataTable getSummaryReport(string Year, string Quarter)
        {
            return dalMaster.getSummaryReport(Year, Quarter);
        }

        public DataTable getInvoiceData(string FromDate, string ToDate)
        {
            return dalMaster.getInvoiceData(FromDate, ToDate);
        }

        public DataTable GetAllUsers_1()
        {
            return dalMaster.GetAllUsers_1();
        }

        public int InsertStampPaperInfo(Hashtable htParam)
        {
            return dalMaster.InsertStampPaperInfo(htParam);
        }

        public DataTable GetStampPaperInfo(string Code)
        {
            return dalMaster.GetStampPaperInfo(Code);
        }

        public int InsertBankName(string BankName, int AddedBy)
        {
            return dalMaster.InsertBankName(BankName, AddedBy);
        }

        public DataTable GetAllCode()
        {
            return dalMaster.GetAllCode();
        }
        public DataTable GetAllRomingBranch()
        {
            return dalMaster.GetAllRomingBranch();
        }

        public int InsertRomingBranch(string User, int BranchId, int AddedBy)
        {
            return dalMaster.InsertRomingBranch(User, BranchId, AddedBy);
        }

        public int deleteRomingBranch(int RomingBranchID)
        {
            return dalMaster.deleteRomingBranch(RomingBranchID);
        }

        public DataTable GetDirectDropoutEmployees()
        {
            return dalMaster.GetDirectDropoutEmployees();
        }

        public DataTable GetDropoutEmployeeDetails(string Month, string Year)
        {
            return dalMaster.GetDropoutEmployeeDetails(Month, Year);

        }

        public DataTable GetDropoutEmployeeDetailsForISO(string Month, string Year)
        {
            return dalMaster.GetDropoutEmployeeDetailsForISO(Month, Year);
        }

        public DataTable GetDropoutEmployeeDetailsForISO_Revised(string Month, string Year)
        {
            return dalMaster.GetDropoutEmployeeDetailsForISO_Revised(Month, Year);
        }
        public DataTable GetApprovedBankDetails()
        {
            return dalMaster.GetApprovedBankDetails();
        }

        public DataTable GetPendingBankDetails()
        {
            return dalMaster.GetPendingBankDetails();
        }

        public DataTable getAllSocialVisitors(Hashtable htParam)
        {
            return dalMaster.getAllSocialVisitors(htParam);
        }

        public int InsertSocialSiteVisitor(Hashtable htParam)
        {
            return dalMaster.InsertSocialSiteVisitor(htParam);
        }

        public int InsertGalssdoorReview(Hashtable htParam)
        {
            return dalMaster.InsertGalssdoorReview(htParam);
        }

        public DataTable getAllGlassDoors()
        {
            return dalMaster.getAllGlassDoors();
        }

        public DataTable getAllGlassDoorsComp()
        {
            return dalMaster.getAllGlassDoorsComp();
        }

        public int InsertGalssdoorReviewComp(Hashtable htParam)
        {
            return dalMaster.InsertGalssdoorReviewComp(htParam);
        }

        public DataTable GetAllCompetitors()
        {
            return dalMaster.GetAllCompetitors();
        }

        public DataTable GetAllGlassDoorCompetitors()
        {
            return dalMaster.GetAllGlassDoorCompetitors();
        }

        public DataTable getAllHRQuestion()
        {
            return dalMaster.getAllHRQuestion();
        }

        public int InsertHRQuestion(Hashtable htParam)
        {
            return dalMaster.InsertHRQuestion(htParam);
        }

        public int InsertCompetitor(Hashtable htParam)
        {
            return dalMaster.InsertCompetitor(htParam);
        }

        public DataTable GetHRCheckQuestionPaper(string Month, string Year)
        {
            return dalMaster.GetHRCheckQuestionPaper(Month, Year);
        }

        public DataTable GetHRCheckQuestionPaper_Report(string Month, string Year)
        {
            return dalMaster.GetHRCheckQuestionPaper_Report(Month, Year);
        }

        public DataTable BindHRInductionExamInfo(int EmployeeId)
        {
            return dalMaster.BindHRInductionExamInfo(EmployeeId);
        }

        public DataTable GetHRAnswerSheet(int EmployeeId)
        {
            return dalMaster.GetHRAnswerSheet(EmployeeId);
        }

        public DataSet GetHRCheckQuestionPaperReport(string Month, string Year)
        {
            return dalMaster.GetHRCheckQuestionPaperReport(Month, Year);
        }

        public DataTable GetDashboardAlertById(int AlertId)
        {
            return dalMaster.GetDashboardAlertById(AlertId);
        }

        public DataTable GetCurrentManpowerSummary(string Type)
        {
            return dalMaster.GetCurrentManpowerSummary(Type);
        }

        public DataTable GetCurrentManpowerSummaryDetails(string Type, int Branch, int Domain, string Subdomain, int Column)
        {
            return dalMaster.GetCurrentManpowerSummaryDetails(Type, Branch, Domain, Subdomain, Column);
        }

        public DataSet GetRequisition(string Month, string Year)
        {
            return dalMaster.GetRequisition(Month, Year);
        }

        public DataTable GetUserPerformanceProdDetailsOther(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceProdDetails(FromDate, ToDate, EmployeeID);
        }


        public DataSet GetAttritionReportForHRReport(string Month, string Year)
        {
            return dalMaster.GetAttritionReportForHRReport(Month, Year);
        }

        public DataSet GetHiring(string Month, string Year)
        {
            return dalMaster.GetHiring(Month, Year);
        }

        public DataSet Getmanpower(string Month, string Year)
        {
            return dalMaster.Getmanpower(Month, Year);
        }

        public DataTable GetSkipLevelSummary(string Month, string Year)
        {
            return dalMaster.GetSkipLevelSummary(Month, Year);
        }

        public DataTable GetAllEmployeeVerificationRecords_Export(string Month, string Year)
        {
            return dalMaster.GetAllEmployeeVerificationRecords_Export(Month, Year);
        }

        public DataSet GetAbsocndingNewJoinedDetailsForExport_DS(string Month, string Year)
        {
            return dalMaster.GetAbsocndingNewJoinedDetailsForExport_DS(Month, Year);
        }

        public DataSet GetResignedEmployees_New(string Month, string Year)
        {
            return dalMaster.GetResignedEmployees_New(Month, Year);
        }

        public DataTable GetFunFriday(string Month, string Year)
        {
            return dalMaster.GetFunFriday(Month, Year);
        }

        public DataTable GetFunFridaySnaps(string Month, string Year)
        {
            return dalMaster.GetFunFridaySnaps(Month, Year);
        }

        public DataSet GetNaukri_New(string Month, string Year)
        {
            return dalMaster.GetNaukri_New(Month, Year);
        }

        public DataSet GetLinkedIn_New(string Month, string Year)
        {
            return dalMaster.GetLinkedIn_New(Month, Year);
        }

        public DataTable GetGlassdoorReview(string Month, string Year)
        {
            return dalMaster.GetGlassdoorReview(Month, Year);
        }

        public DataTable GetGlassdoorReviewComp(string Month, string Year)
        {
            return dalMaster.GetGlassdoorReviewComp(Month, Year);
        }

        public DataTable GetRRSnaps()
        {
            return dalMaster.GetRRSnaps();
        }

        public DataTable getInvoiceData_Report(string FromDate, string ToDate)
        {
            return dalMaster.getInvoiceData_Report(FromDate, ToDate);
        }

        public DataTable GetMastDataFrHRReport()
        {
            return dalMaster.GetMastDataFrHRReport();
        }

        public DataTable GetMastData()
        {
            return dalMaster.GetMastData();
        }

        public DataTable GetAllBirthdays()
        {
            return dalMaster.GetAllBirthdays();
        }

        public DataTable GetAllBirthdayMessages(int EmployeeID)
        {
            return dalMaster.GetAllBirthdayMessages(EmployeeID);
        }

        public DataTable GetBankAccDetails()
        {
            return dalMaster.GetBankAccDetails();
        }

        public DataTable GetAllPsuedoName()
        {
            return dalMaster.GetAllPsuedoName();
        }

        public DataTable GetAllUsersUpdatePsuedoName()
        {
            return dalMaster.GetAllUsersUpdatePsuedoName();
        }

        public DataTable GetAllUsersUpdatePsuedoNamebyCode(string Code)
        {
            return dalMaster.GetAllUsersUpdatePsuedoNamebyCode(Code);
        }

        public int InseartPsuedoName(Hashtable htGroup)
        {
            return dalMaster.InseartPsuedoName(htGroup);
        }

        public int DeletePsuedoName(Hashtable htGroup)
        {
            return dalMaster.DeletePsuedoName(htGroup);
        }

        public DataTable GetDataForPendingToUpdateBankDetails(int EmployeeID)
        {
            return dalMaster.GetDataForPendingToUpdateBankDetails(EmployeeID);
        }

        public int ApproveBankAccountNo(Hashtable htBank)
        {
            return dalMaster.ApproveBankAccountNo(htBank);
        }

        public DataTable GetBankAttachmentByID(int ChangeID)
        {
            return dalMaster.GetBankAttachmentByID(ChangeID);
        }

        public DataTable GetNewJoineeFollowUp(string Month, string Year)
        {
            return dalMaster.GetNewJoineeFollowUp(Month, Year);
        }

        public DataTable GetAddressVerification(string Month, string Year)
        {
            return dalMaster.GetAddressVerification(Month, Year);
        }

        public DataTable GetEmployeesForExit()
        {
            return dalMaster.GetEmployeesForExit();
        }

        public DataSet GetSkiplevelDetails(string Month, string Year)
        {
            return dalMaster.GetSkiplevelDetails(Month, Year);
        }

        public int InsertStampPaperDetails(Hashtable htParam)
        {
            return dalMaster.InsertStampPaperDetails(htParam);
        }

        public int InsertMasterDataDetails_FileNo(Hashtable htParam)
        {
            return dalMaster.InsertMasterDataDetails_FileNo(htParam);
        }

        public DataTable GetStampPaperDetailsHistoryOfEmployee(string Code, string Type)
        {
            return dalMaster.GetStampPaperDetailsHistoryOfEmployee(Code, Type);
        }

        public int InsertStampPaperClause(Hashtable htParam)
        {
            return dalMaster.InsertStampPaperClause(htParam);
        }

        public DataTable GetHR_TicketReport(string Month, string Year)
        {
            return dalMaster.GetHR_TicketReport(Month, Year);
        }

        public DataTable GetClosedTicket(int TicketNo)
        {
            return dalMaster.GetClosedTicket(TicketNo);
        }

        public string GetFinalRemarkForSalary(int AppId)
        {
            return dalMaster.GetFinalRemarkForSalary(AppId);
        }

        public int InsertEmployeeInfo(Hashtable htProfile)
        {
            return dalMaster.InsertEmployeeInfo(htProfile);
        }

        public int UpdateEmployeeInfo(Hashtable htProfile)
        {
            return dalMaster.UpdateEmployeeInfo(htProfile);
        }

        public DataTable GetPMSummary(string Year, string Quarter)
        {
            return dalMaster.GetPMSummary(Year, Quarter);
        }

        public DataTable GetDMSummary(string Year, string Quarter)
        {
            return dalMaster.GetDMSummary(Year, Quarter);
        }

        public DataTable GetPMDetails(string Year, string Quarter)
        {
            return dalMaster.GetPMDetails(Year, Quarter);
        }

        public int InsertUWQuestion(Hashtable htParam)
        {
            return dalMaster.InsertUWQuestion(htParam);
        }

        public int InsertPOSHQuestion(Hashtable htParam)
        {
            return dalMaster.InsertPOSHQuestion(htParam);
        }

        public DataTable GetAllPOSHQuestion()
        {
            return dalMaster.GetAllPOSHQuestion();
        }

        public DataTable GetPOSHQuestionSection()
        {
            return dalMaster.GetPOSHQuestionSection();
        }

        public DataTable GetPOSHDataForSummary_MonthWise(string Month, string Year)
        {
            return dalMaster.GetPOSHDataForSummary_MonthWise(Month, Year);
        }

        public DataTable getAllCredit_UWQuestion()
        {
            return dalMaster.getAllCredit_UWQuestion();
        }

        public DataTable GetCredit_UWCheckQuestionPaper(string FromDate, string ToDate)
        {
            return dalMaster.GetCredit_UWCheckQuestionPaper(FromDate, ToDate);
        }

        public DataTable GetCredit_UWAnswerSheetHeader(int ApplicationID)
        {
            return dalMaster.GetCredit_UWAnswerSheetHeader(ApplicationID);
        }

        public DataTable GetCredit_UWAnswerSheet(int ApplicationID)
        {
            return dalMaster.GetCredit_UWAnswerSheet(ApplicationID);
        }

        public DataTable GetCredit_UWCandidateForSendMail(string FromDate, string ToDate)
        {
            return dalMaster.GetCredit_UWCandidateForSendMail(FromDate, ToDate);
        }

        public DataTable getAllServicing_UWQuestion()
        {
            return dalMaster.getAllServicing_UWQuestion();
        }

        public int InsertServicingUWQuestion(Hashtable htParam)
        {
            return dalMaster.InsertServicingUWQuestion(htParam);
        }

        public DataTable Getservicing_UWCheckQuestionPaper(string FromDate, string ToDate)
        {
            return dalMaster.Getservicing_UWCheckQuestionPaper(FromDate, ToDate);
        }

        public DataTable GetServicing_UWAnswerSheetHeader(int ApplicationID)
        {
            return dalMaster.GetServicing_UWAnswerSheetHeader(ApplicationID);
        }

        public DataTable GetServicing_UWAnswerSheet(int ApplicationID)
        {
            return dalMaster.GetServicing_UWAnswerSheet(ApplicationID);
        }

        public DataTable GetServicing_UWCandidateForSendMail(string FromDate, string ToDate)
        {
            return dalMaster.GetServicing_UWCandidateForSendMail(FromDate, ToDate);
        }

        public DataTable GetDropOutinfo(int EmployeeId)
        {
            return dalMaster.GetDropOutinfo(EmployeeId);
        }

        public DataTable GetAbscondedEmployeesFollowup(string FromDate, string ToDate)
        {
            return dalMaster.GetAbscondedEmployeesFollowup(FromDate, ToDate);
        }

        public int InsertAbscondedEmpsFollowUp(Hashtable htParam)
        {
            return dalMaster.InsertAbscondedEmpsFollowUp(htParam);
        }

        public DataTable GetAllNewJoineeReport(string Month, string Year)
        {
            return dalMaster.GetAllNewJoineeReport(Month, Year);
        }

        public DataTable GetAllNewJoineeReport_Revised(string Month, string Year)
        {
            return dalMaster.GetAllNewJoineeReport_Revised(Month, Year);
        }

        public DataTable GetAttritionReport(string Month, string Year, int DomainID)
        {
            return dalMaster.GetAttritionReport(Month, Year, DomainID);
        }

        public DataSet GetAttritionReport_ds(string Month, string Year, int DomainID, int EmpID)
        {
            return dalMaster.GetAttritionReport_ds(Month, Year, DomainID, EmpID);
        }

        public DataTable GetAllInvoiceHeaders(string Month, string Year)
        {
            return dalMaster.GetAllInvoiceHeaders(Month, Year);
        }

        public DataTable GetAllCCInvoiceHeaders_ByHeaderID(int HeaderID, string Month, string Year)
        {
            return dalMaster.GetAllCCInvoiceHeaders_ByHeaderID(HeaderID, Month, Year);
        }

        public DataTable GetHeaderwiseDetails(int HeaderID)
        {
            return dalMaster.GetHeaderwiseDetails(HeaderID);
        }

        public DataTable GetHeaderwiseDetailsRevised(int HeaderID, string Month, string Year)
        {
            return dalMaster.GetHeaderwiseDetailsRevised(HeaderID, Month, Year);
        }

        public DataTable GetCCDataForVerification(string Month, string Year)
        {
            return dalMaster.GetCCDataForVerification(Month, Year);
        }

        public int InsertCCInvoiceMonthlyData(Hashtable htParam)
        {
            return dalMaster.InsertCCInvoiceMonthlyData(htParam);
        }

        public DataTable GetAllInvoiceHeadersSummary(string Month, string Year)
        {
            return dalMaster.GetAllInvoiceHeadersSummary(Month, Year);
        }

        public DataTable DownloadInvoice(int HeaderID, string Month, string Year)
        {
            return dalMaster.DownloadInvoice(HeaderID, Month, Year);
        }

        public DataTable GetCanopyData(string FromDate, string ToDate)
        {
            return dalMaster.GetCanopyData(FromDate, ToDate);
        }

        public DataTable GetCanopyDataDetails(string FromDate, string ToDate)
        {
            return dalMaster.GetCanopyDataDetails(FromDate, ToDate);
        }

        public DataTable GetCanopyTask(int LoanID)
        {
            return dalMaster.GetCanopyTask(LoanID);
        }

        public int InsertCCDetails(Hashtable htParam)
        {
            return dalMaster.InsertCCDetails(htParam);
        }

        public int InsertCCInvoiceHeaders(Hashtable htParam)
        {
            return dalMaster.InsertCCInvoiceHeaders(htParam);
        }

        public int DisabledCCHeader(Hashtable htParam)
        {
            return dalMaster.DisabledCCHeader(htParam);
        }

        public int RemoveCCUser(Hashtable htParam)
        {
            return dalMaster.RemoveCCUser(htParam);
        }

        public int InsertCreditCardMaster(Hashtable htParam)
        {
            return dalMaster.InsertCreditCardMaster(htParam);
        }

        public DataTable GetAllCC_Master()
        {
            return dalMaster.GetAllCC_Master();
        }

        public int EditCreditCardMaster(Hashtable htParam)
        {
            return dalMaster.EditCreditCardMaster(htParam);
        }

        public int InsertCreditCardHeaderMaster(Hashtable htParam)
        {
            return dalMaster.InsertCreditCardHeaderMaster(htParam);
        }

        public int EditCreditCardHeaderMaster(Hashtable htParam)
        {
            return dalMaster.EditCreditCardHeaderMaster(htParam);
        }

        public DataTable GetAllCreditCardHeaderMaster()
        {
            return dalMaster.GetAllCreditCardHeaderMaster();
        }

        public DataTable GetAllCreditCardInvoice()
        {
            return dalMaster.GetAllCreditCardInvoice();
        }

        public DataTable GetAllCreditCardInvoice_cancel(int CardId, string FromDate, string ToDate)
        {
            return dalMaster.GetAllCreditCardInvoice_cancel(CardId, FromDate, ToDate);
        }

        public DataTable GetAllCreditCards()
        {
            return dalMaster.GetAllCreditCards();
        }

        public int InsertCreditCardInvoice(Hashtable htParam)
        {
            return dalMaster.InsertCreditCardInvoice(htParam);
        }

        public int CancelCreditCardInvoice(int InvoiceID, decimal CreditAmount, decimal CancelAmount, string CancelRemark, string Attachment)
        {
            return dalMaster.CancelCreditCardInvoice(InvoiceID, CreditAmount, CancelAmount, CancelRemark, Attachment);
        }

        public DataTable GetStatementDetailsByID(int VerID, string Month, string Year)
        {
            return dalMaster.GetStatementDetailsByID(VerID, Month, Year);
        }

        public int InsertAccountRemarkforCC(int VerID, string Remark, string PaidDate, string Month, string Year)
        {
            return dalMaster.InsertAccountRemarkforCC(VerID, Remark, PaidDate, Month, Year);
        }

        public int FinalVerifyCCStatement(string Month, string Year)
        {
            return dalMaster.FinalVerifyCCStatement(Month, Year);
        }

        public DataTable GetTotalAbscondingEmployees(string Month, string Year)
        {
            return dalMaster.GetTotalAbscondingEmployees(Month, Year);
        }

        public DataTable GetTotalLeaves(string Month, string Year)
        {
            return dalMaster.GetTotalLeaves(Month, Year);
        }

        public DataSet GetTotalLeaves_Revised(string Month, string Year)
        {
            return dalMaster.GetTotalLeaves_Revised(Month, Year);
        }

        public DataTable GetKYCInfoByEmployee(string Code)
        {
            return dalMaster.GetKYCInfoByEmployee(Code);
        }

        public int InsertEmployeeInfo_Old(Hashtable htParam)
        {
            return dalMaster.InsertEmployeeInfo_Old(htParam);
        }

        public DataTable GetDomainHeadInfo(int EmployeeID)
        {
            return dalMaster.GetDomainHeadInfo(EmployeeID);
        }

        public DataTable getEmailConfigrationInfo(string EmailType)
        {
            return dalMaster.getEmailConfigrationInfo(EmailType);
        }

        public int InsertEmployeeLogInHistory(string Code, bool Status, string Remark, int AddedBy, string LeaveStatus)
        {
            return dalMaster.InsertEmployeeLogInHistory(Code, Status, Remark, AddedBy, LeaveStatus);
        }

        public DataTable GetLocationHeadInfo(int EmployeeID)
        {
            return dalMaster.GetLocationHeadInfo(EmployeeID);
        }

        public DataTable GetPrimaryProject(int EmployeeID)
        {
            return dalMaster.GetPrimaryProject(EmployeeID);
        }

        public DataTable EmployeeDetailsByCode(string Code)
        {
            return dalMaster.EmployeeDetailsByCode(Code);
        }

        public DataTable GetAllAttendanceCorrectionRequest(string Code)
        {
            return dalMaster.GetAllAttendanceCorrectionRequest(Code);
        }

        public DataTable GetAllAttendanceCorrectionRequestForPM(int EmployeeID)
        {
            return dalMaster.GetAllAttendanceCorrectionRequestForPM(EmployeeID);
        }

        public DataTable GetAllFamilyInfo(int EmployeeID)
        {
            return dalMaster.GetAllFamilyInfo(EmployeeID);
        }

        public int ResetUserPassword(Hashtable htParam)
        {
            return dalMaster.ResetUserPassword(htParam);
        }

        public DataTable GetAllAppreciationDisciplinary()
        {
            return dalMaster.GetAllAppreciationDisciplinary();
        }

        public int InsertAppreciationDisciplinary(string Type, string Title, string Description, string DesignDescription, int AddedBy)
        {
            return dalMaster.InsertAppreciationDisciplinary(Type, Title, Description, DesignDescription, AddedBy);
        }

        public int InsertFamilyInfo(Hashtable htFamilyInsert)//(int EmployeeID, string Name, string Relation, string Profession, string Age, int AddedBy)
        {
            return dalMaster.InsertFamilyInfo(htFamilyInsert);
        }

        public int deleteFamilyInfo(int id)
        {
            return dalMaster.deleteFamilyInfo(id);
        }

        public DataTable GetAllTicket(int RequestBy)
        {
            return dalMaster.GetAllTicket(RequestBy);
        }

        public DataTable GetUWProjects()
        {
            return dalMaster.GetUWProjects();
        }

        public DataTable GetReportData()
        {
            return dalMaster.GetReportData();
        }

        public DataTable GetSecuritizationByID(int SecureID)
        {
            return dalMaster.GetSecuritizationByID(SecureID);
        }

        public DataTable GetAllDealNumber(int ProjectId)
        {
            return dalMaster.GetAllDealNumber(ProjectId);
        }

        public DataTable GetAllSentBilling()
        {
            return dalMaster.GetAllSentBilling();
        }

        public int InsertSecuritizationRelLetter(Hashtable htParam)
        {
            return dalMaster.InsertSecuritizationRelLetter(htParam);
        }

        public int InsertProjectInfo(Hashtable htParam)
        {
            return dalMaster.InsertProjectInfo(htParam);
        }

        public int InsertSecuritizationRelLetterBilling(Hashtable htParam)
        {
            return dalMaster.InsertSecuritizationRelLetterBilling(htParam);
        }

        public int UpdateSecuritizationRelLetter(Hashtable htParam)
        {
            return dalMaster.UpdateSecuritizationRelLetter(htParam);
        }

        public int InsertSecuritizationRelLetterBilling_Revised(Hashtable htParam)
        {
            return dalMaster.InsertSecuritizationRelLetterBilling_Revised(htParam);
        }

        public DataSet GetDealDetails(string DealNo)
        {
            return dalMaster.GetDealDetails(DealNo);
        }

        public DataTable GetRevisedBilling(int ProjectID, string DealNo)
        {
            return dalMaster.GetRevisedBilling(ProjectID, DealNo);
        }

        public int UpdateBillingRevised(int BillingID)
        {
            return dalMaster.UpdateBillingRevised(BillingID);
        }

        public DataTable GetAllUsersUnderPM(int EmployeeID)
        {
            return dalMaster.GetAllUsersUnderPM(EmployeeID);
        }

        public DataTable GetERpCutOffTimeExceptions(int EmployeeID)
        {
            return dalMaster.GetERpCutOffTimeExceptions(EmployeeID);
        }

        public DataTable GetUserPerformanceReport(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceReport(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceProdDetails(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceProdDetails(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceFeedbackDetails(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceFeedbackDetails(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceAttendanceDetails(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceAttendanceDetails(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceAttendanceDetails_KP(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceAttendanceDetails_KP(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetPoshQuestions()
        {
            return dalMaster.GetPoshQuestions();
        }

        public int InsertPoshAnswer(int EmployeeId, int QuestionID, string Answer)
        {
            return dalMaster.InsertPoshAnswer(EmployeeId, QuestionID, Answer);
        }

        public DataTable GetExistanceofPoshTest()
        {
            return dalMaster.GetExistanceofPoshTest();
        }

        public int GetPostTestStatus()
        {
            return dalMaster.GetPostTestStatus();
        }

        public DataTable GetPoshTestResult()
        {
            return dalMaster.GetPoshTestResult();
        }

        public int SetPoshRetest()
        {
            return dalMaster.SetPoshRetest();
        }

        public DataTable getSchedule1Data(int EmployeeID)
        {
            return dalMaster.getSchedule1Data(EmployeeID);
        }

        public DataTable GetAprreciationTitle(string AppreciationDiscplinary)
        {
            return dalMaster.GetAprreciationTitle(AppreciationDiscplinary);
        }

        public DataTable GetAprreciationDescription(string AppreciationDiscplinary, string Title)
        {
            return dalMaster.GetAprreciationDescription(AppreciationDiscplinary, Title);
        }

        public DataTable GetLeaveDetailsByID(int LeaveID)
        {
            return dalMaster.GetLeaveDetailsByID(LeaveID);
        }

        public int UpdateEmployeeLeaves(Hashtable htExtend)
        {
            return dalMaster.UpdateEmployeeLeaves(htExtend);
        }

        public DataTable GetExtendedAndShortenLeavesDetails(int LeaveId)
        {
            return dalMaster.GetExtendedAndShortenLeavesDetails(LeaveId);
        }

        public DataTable GetAllStandardReasonsForPM()
        {
            return dalMaster.GetAllStandardReasonsForPM();
        }

        public DataTable GetAllDateForAttendance(string Code)
        {
            return dalMaster.GetAllDateForAttendance(Code);
        }

        public DataTable GetAttendanceCorrectionByID(int ID)
        {
            return dalMaster.GetAttendanceCorrectionByID(ID);
        }

        public int InsertAttendanceCorrectRequestByPM(Hashtable htAttendance)
        {
            return dalMaster.InsertAttendanceCorrectRequestByPM(htAttendance);
        }

        public int UpdateAttendanceCorrection(Hashtable htUpdateAttendance)
        {
            return dalMaster.UpdateAttendanceCorrection(htUpdateAttendance);
        }

        public int InsertSetAppreciationDisplinaryAction(int AppreciationDisciplinaryID, int EmployeeID, string Type, string Title, string Description, string Remark, string Subject, int AddedBy, string Period)
        {
            return dalMaster.InsertSetAppreciationDisplinaryAction(AppreciationDisciplinaryID, EmployeeID, Type, Title, Description, Remark, Subject, AddedBy, Period);
        }

        public DataTable GetAppreciationDisplinaryStatus(int EmployeeID)
        {
            return dalMaster.GetAppreciationDisplinaryStatus(EmployeeID);
        }

        public DataTable GetPoshTestReport(string Month, string Year)
        {
            return dalMaster.GetPoshTestReport(Month, Year);
        }

        public DataTable GetPoshAnswerSheet(int EmployeeID)
        {
            return dalMaster.GetPoshAnswerSheet(EmployeeID);
        }

        public DataTable usp_GetAllAppreciationDescRecords_UserWise()
        {
            return dalMaster.usp_GetAllAppreciationDescRecords_UserWise();
        }

        public DataTable GetAllApprerciationandWarningReport()
        {
            return dalMaster.GetAllApprerciationandWarningReport();
        }

        public DataTable GetAllApprerciationandWarningByType(int EmployeeID, string Type)
        {
            return dalMaster.GetAllApprerciationandWarningByType(EmployeeID, Type);
        }

        public int InsertRnRSnaps(Hashtable htParam)
        {
            return dalMaster.InsertRnRSnaps(htParam);
        }

        #region Log Imported Feedback

        public DataTable GetAllFeedbackByDateRange_NewFormat(string FromDate, string ToDate, string SubDomain)
        {
            return dalMaster.GetAllFeedbackByDateRange_NewFormat(FromDate, ToDate, SubDomain);
        }

        public DataTable GetFeedbackDetailsByID_NewFormat(int FeedbackID, string Subdomain)
        {
            return dalMaster.GetFeedbackDetailsByID_NewFormat(FeedbackID, Subdomain);
        }

        public DataTable GetCreditAndServicingFeedbackHistory(int FeedbackID, string SubDomain)
        {
            return dalMaster.GetCreditAndServicingFeedbackHistory(FeedbackID, SubDomain);
        }

        public DataTable GetProductionDataForUpdateFeedback_NewFormat(string LoanNo)
        {
            return dalMaster.GetProductionDataForUpdateFeedback_NewFormat(LoanNo);
        }

        public int UpdateInfinityImportedFeedback_NewERP(Hashtable htParam)
        {
            return dalMaster.UpdateInfinityImportedFeedback_NewERP(htParam);
        }

        public int UpdateFinalStatusOfImporetdFeedback(Hashtable htParam)
        {
            return dalMaster.UpdateFinalStatusOfImporetdFeedback(htParam);
        }

        public int InsertInfinityImportedFeedback_NewERP(Hashtable htParam)
        {
            return dalMaster.InsertInfinityImportedFeedback_NewERP(htParam);
        }
        #endregion

        public int CheckifProjectExists(string ProjectName)
        {
            return dalMaster.CheckifProjectExists(ProjectName);
        }

        public int CheckifpsuedonameExists(string EmpName)
        {
            return dalMaster.CheckifpsuedonameExists(EmpName);
        }

        public DataTable GetValidatedFeedbacks()
        {
            return dalMaster.GetValidatedFeedbacks();
        }

        public DataTable ITCostReportYearly(string FromDate, string ToDate)
        {
            return dalMaster.ITCostReportYearly(FromDate, ToDate);
        }

        public DataTable ITCostReportYearlyDetail(string FromDate, string ToDate)
        {
            return dalMaster.ITCostReportYearlyDetail(FromDate, ToDate);
        }

        public DataTable ITCostReportYearly_CreditCardwise(string FromDate, string ToDate)
        {
            return dalMaster.ITCostReportYearly_CreditCardwise(FromDate, ToDate);
        }

        public DataTable ITCostReportYearly_CreditCardDeviation(string FromDate, string ToDate)
        {
            return dalMaster.ITCostReportYearly_CreditCardDeviation(FromDate, ToDate);
        }

        public DataTable GetAllEmployeeInformationForVerification()
        {
            return dalMaster.GetAllEmployeeInformationForVerification();
        }

        public DataTable GetEmpAllDocsForZip(string Code)
        {
            return dalMaster.GetEmpAllDocsForZip(Code);
        }

        public int UploadEmployeeDocument(Hashtable genrateInfo)
        {
            return dalMaster.UploadEmployeeDocument(genrateInfo);
        }

        public int InsertUpdateFeedbacks_Servicing()
        {
            return dalMaster.InsertUpdateFeedbacks_Servicing();
        }

        public int InsertUpdateFeedbacks_Credit()
        {
            return dalMaster.InsertUpdateFeedbacks_Credit(); ;
        }

        public DataTable GetValidatedFeedbacks_Servicing()
        {
            return dalMaster.GetValidatedFeedbacks_Servicing();
        }

        public DataTable GetValidatedFeedbacks_Credit()
        {
            return dalMaster.GetValidatedFeedbacks_Credit();
        }

        public DataTable SyncInternalFeedbacks(string FromDate, string ToDate, string Subdomain)
        {
            return dalMaster.SyncInternalFeedbacks(FromDate, ToDate, Subdomain);
        }

        public int InsertSyncedInternalFeedbacks(string FromDate, string ToDate, string Subdomain)
        {
            return dalMaster.InsertSyncedInternalFeedbacks(FromDate, ToDate, Subdomain);
        }

        public int InsertERPCutOffTimeException(string Code, string FromDate, string ToDate, string Reason)
        {
            return dalMaster.InsertERPCutOffTimeException(Code, FromDate, ToDate, Reason);
        }

        public DataTable GetSecurutizationSummary_Sec(string Month, string year)
        {
            return dalMaster.GetSecurutizationSummary_Sec(Month, year);
        }

        public DataTable GetReportingManagerList()
        {
            return dalMaster.GetReportingManagerList();
        }

        public DataTable GetSecurutizationSummary_RelLetter(string Month, string year)
        {
            return dalMaster.GetSecurutizationSummary_RelLetter(Month, year);
        }

        public DataSet GetReportingManagerWiseAttrition(Hashtable htParam)
        {
            return dalMaster.GetReportingManagerWiseAttrition(htParam);
        }

        public DataTable GetAllEmployeeWorkedHoliday(int EmployeeID)
        {
            return dalMaster.GetAllEmployeeWorkedHoliday(EmployeeID);
        }

        public DataTable GetUserWorkedHolidays(string Code)
        {
            return dalMaster.GetUserWorkedHolidays(Code);
        }

        public int ApprovedEmpWorkHoliday(string UserCode, string Remark, string Date, int ApprovedBy)
        {
            return dalMaster.ApprovedEmpWorkHoliday(UserCode, Remark, Date, ApprovedBy);
        }

        public DataTable GetLeaveDetails(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetLeaveDetails(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetLeaveReport(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetLeaveReport(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetLeaveDetails_ByCode(string FromDate, string ToDate, string Code)
        {
            return dalMaster.GetLeaveDetails_ByCode(FromDate, ToDate, Code);
        }

        public DataTable GetAllWorkedHolidayDates(int EmployeeID)
        {
            return dalMaster.GetAllWorkedHolidayDates(EmployeeID);
        }

        public DataTable GetUserAllCompOff(int EmployeeID)
        {
            return dalMaster.GetUserAllCompOff(EmployeeID);
        }

        public DataTable GetUserCompOff_forApproval(int EmployeeID)
        {
            return dalMaster.GetUserCompOff_forApproval(EmployeeID);
        }

        public int InsertUserCompOff(Hashtable htParam)
        {
            return dalMaster.InsertUserCompOff(htParam);
        }

        public int ApproveRejectCompOff(Hashtable htParam)
        {
            return dalMaster.ApproveRejectCompOff(htParam);
        }

        public int InsertAgreementVersionHistory(Hashtable htParam)
        {
            return dalMaster.InsertAgreementVersionHistory(htParam);
        }

        public int InsertAgreementTypeHistory(Hashtable htParam)
        {
            return dalMaster.InsertAgreementTypeHistory(htParam);
        }

        public int UpdateAgreementVersionHistory(Hashtable htParam)
        {
            return dalMaster.UpdateAgreementVersionHistory(htParam);
        }

        public DataTable GetAgreementVersionHistory()
        {
            return dalMaster.GetAgreementVersionHistory();
        }

        public DataTable GetAgreementTypeHistory()
        {
            return dalMaster.GetAgreementTypeHistory();
        }

        public DataTable GetAgreementVersionHistory_Report()
        {
            return dalMaster.GetAgreementVersionHistory_Report();
        }

        public DataTable GetAgreemnetTypeHistory_Report()
        {
            return dalMaster.GetAgreemnetTypeHistory_Report();
        }

        public int InsertFestiveData(Hashtable htParam)
        {
            return dalMaster.InsertFestiveData(htParam);
        }

        public DataTable GetFestivalMaster()
        {
            return dalMaster.GetFestivalMaster();
        }

        public int DeleteFestivalImages(int FestivalId, int DeletedBy)
        {
            return dalMaster.DeleteFestivalImages(FestivalId, DeletedBy);
        }

        public DataTable GetEmployeeComment()
        {
            return dalMaster.GetEmployeeComment();
        }

        public int InsertEmployeeComment(Hashtable htComment)
        {
            return dalMaster.InsertEmployeeComment(htComment);
        }

        public DataTable GetEmployeeCommentByID(int CommentID)
        {
            return dalMaster.GetEmployeeCommentByID(CommentID);
        }

        public DataTable GetHRInvoice()
        {
            return dalMaster.GetHRInvoice();
        }

        public int InsertCompanyInvoice(Hashtable htparam)
        {
            return dalMaster.InsertCompanyInvoice(htparam);
        }

        public int UpdateCompanyInvoice(Hashtable htparam)
        {
            return dalMaster.UpdateCompanyInvoice(htparam);
        }

        public DataTable Getunapprovedleavecount(int DomainID, string FromDate, string ToDate)
        {
            return dalMaster.Getunapprovedleavecount(DomainID, FromDate, ToDate);
        }

        public DataTable GetDepartmentForInvoice()
        {
            return dalMaster.GetDepartmentForInvoice();
        }

        public int CheckERPLoginExceptionExistance()
        {
            return dalMaster.CheckERPLoginExceptionExistance();
        }

        public string ValidateLogin(Hashtable htAttendance)
        {
            return dalMaster.ValidateLogin(htAttendance);
        }

        public string ValidateLogout(Hashtable htAttendance)
        {
            return dalMaster.ValidateLogout(htAttendance);
        }

        public void AdjustHolidays(Hashtable htAttendance)
        {
            dalMaster.AdjustHolidays(htAttendance);

        }

        public DataTable GetDashboardPerformanceDetails()
        {
            return dalMaster.GetDashboardPerformanceDetails();
        }

        public DataTable GetDetailedAttendancePercentageForDashboard(Hashtable htParam)
        {
            return dalMaster.GetDetailedAttendancePercentageForDashboard(htParam);
        }

        public int InsertBirthdayMessage(string Message, int AddedBy, string Code)
        {
            return dalMaster.InsertBirthdayMessage(Message, AddedBy, Code);
        }

        public DataTable GetTodaysBirthday()
        {
            return dalMaster.GetTodaysBirthday();
        }

        public DataTable GetAllMasters()
        {
            return dalMaster.GetAllMasters();
        }

        public void InsertMenu(MenuModel menu)
        {
            dalMaster.InsertMenu(menu);
        }

        public DataTable GetBirthdayList()
        {
            return dalMaster.GetBirthdayList();
        }

        public int InsertDashboardTour(string IsCheck)
        {
            return dalMaster.InsertDashboardTour(IsCheck);
        }

        public int UpdateProjectAlertReadStatus(Hashtable htParam)
        {
            return dalMaster.UpdateProjectAlertReadStatus(htParam);
        }

        public DataTable GetAllOSTNotifications()
        {
            return dalMaster.GetAllOSTNotifications();
        }

        public DataTable GetAllTodayAnniversaries()
        {
            return dalMaster.GetAllTodayAnniversaries();
        }

        public DataTable GetWorkAnniversary()
        {
            return dalMaster.GetWorkAnniversary();
        }


        public DataTable GetAllSegments()
        {
            return dalMaster.GetAllSegments();
        }

        public DataTable GetRecordsForSLAReport(string FromDate, string ToDate)
        {
            return dalMaster.GetRecordsForSLAReport(FromDate, ToDate);
        }

        public int InsertUserDomain(Hashtable htParam)
        {
            return dalMaster.InsertUserDomain(htParam);
        }

        public DataTable GetOtherTaskReport(string FromDate, string ToDate, int AddedBy)
        {
            return dalMaster.GetOtherTaskReport(FromDate, ToDate, AddedBy);
        }

        public DataTable GetAllDomain_Notifications(int DomainId)
        {
            return dalMaster.GetAllDomain_Notifications(DomainId);
        }
        public DataTable GetAllProjects_UserNotifications(int DomainId)
        {
            return dalMaster.GetAllProjects_UserNotifications(DomainId);
        }

        public DataTable GetAllUser_UserNotifications(string ProjectName, string Subdomain)
        {
            return dalMaster.GetAllUser_UserNotifications(ProjectName, Subdomain);
        }

        public int InsertProjectNotifications(Hashtable htParam)
        {
            return dalMaster.InsertProjectNotifications(htParam);
        }

        public int InsertSLATimeline(Hashtable htParam)
        {
            return dalMaster.InserSLATimeline(htParam);
        }

        public DataTable GetAllSLATimeline()
        {
            return dalMaster.GetAllSLATimeline();
        }

        public DataTable DomainWiseEmployeeCount(string Month, string Year)
        {
            return dalMaster.DomainWiseEmployeeCount(Month, Year);
        }


        public DataTable GetTargetMatrixSetup(int EmployeeID)
        {
            return dalMaster.GetTargetMatrixSetup(EmployeeID);
        }

        public DataTable GetTargetMatrixForProject(int ProjectID, int ProcessID, int ProductID)
        {
            return dalMaster.GetTargetMatrixForProject(ProjectID, ProcessID, ProductID);
        }

        public DataTable GetAllProcess()
        {
            return dalMaster.GetAllProcess();
        }

        public DataTable GetProductTypeList()
        {
            return dalMaster.GetProductTypeList();
        }
        public DataTable GetAllProductiveUsers()
        {
            return dalMaster.GetAllProductiveUsers();
        }
        public DataTable GetTargetMatrixByprojectAndProcess(string ProjectID, string ProcessID)
        {
            return dalMaster.GetTargetMatrixByprojectAndProcess(ProjectID, ProcessID);
        }

        public DataTable GetAllAssignUserTargetByPm(string EmployeeID)
        {
            return dalMaster.GetAllAssignUserTargetByPm(EmployeeID);
        }

        #region User Performance - HR

        /*NonDD*/
        public DataTable GetUserPerformanceReport_HR_NonDD(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceReport_HR_NonDD(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceProdDetails_HR_NonDD(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceProdDetails_HR_NonDD(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceFeedbackDetails_HR_NonDD(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceFeedbackDetails_HR_NonDD(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceAttendanceDetails_HR_NonDD(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceAttendanceDetails_HR_NonDD(FromDate, ToDate, EmployeeID);
        }


        /*  Credit */
        public DataTable GetUserPerformanceReport_HR_Credit(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceReport_HR_Credit(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceProdDetails_HR_Credit(string FromDate, string ToDate, int EmployeeID)  /*Done*/
        {
            return dalMaster.GetUserPerformanceProdDetails_HR_Credit(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceFeedbackDetails_HR_Credit(string FromDate, string ToDate, int EmployeeID)  /*Done*/
        {
            return dalMaster.GetUserPerformanceFeedbackDetails_HR_Credit(FromDate, ToDate, EmployeeID);

        }

        public DataTable GetUserPerformanceAttendanceDetails_HR_Credit(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceAttendanceDetails_HR_Credit(FromDate, ToDate, EmployeeID);
        }


        /*  Servicing */
        public DataTable GetUserPerformanceReport_HR_Servicing(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceReport_HR_Servicing(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceProdDetails_HR_Servicing(string FromDate, string ToDate, int EmployeeID) /*Done*/
        {
            return dalMaster.GetUserPerformanceProdDetails_HR_Servicing(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceFeedbackDetails_HR_Servicing(string FromDate, string ToDate, int EmployeeID)  /*Done*/
        {
            return dalMaster.GetUserPerformanceFeedbackDetails_HR_Servicing(FromDate, ToDate, EmployeeID);
        }

        public DataTable GetUserPerformanceAttendanceDetails_HR_Servicing(string FromDate, string ToDate, int EmployeeID)
        {
            return dalMaster.GetUserPerformanceAttendanceDetails_HR_Servicing(FromDate, ToDate, EmployeeID);
        }

        public int InsertEmpHoliday(int EmployeeID, string Date, string DepartmentName, string ShiftTime, string Remark, int AddedBy)
        {
            return dalMaster.InsertEmpHoliday(EmployeeID, Date, DepartmentName, ShiftTime, Remark, AddedBy);
        }

        public DataTable GetHolidayList()
        {
            return dalMaster.GetHolidayList();
        }

        public DataTable GetBranchAndDateWiseAttendance(string Month, string Year)
        {
            return dalMaster.GetBranchAndDateWiseAttendance(Month, Year);
        }

        #endregion

        #region FTE

        public int InsertFTEDetails(Hashtable htParam)
        {
            return dalMaster.InsertFTEDetails(htParam);
        }

        public DataTable GetFTEUserDetails()
        {
            return dalMaster.GetFTEUserDetails();
        }

        public int InsertFTEUserDetails(Hashtable htParam)
        {
            return dalMaster.InsertFTEUserDetails(htParam);
        }

        public DataTable getProcessByProjectWise(int ProjectID, string Code)
        {
            return dalMaster.getProcessByProjectWise(ProjectID, Code);
        }

        public DataTable GetFTEDetails()
        {
            return dalMaster.GetFTEDetails();
        }

        public DataTable GetAllEmployeeDetailsbyPM(int EmployeeID)
        {
            return dalMaster.GetAllEmployeeDetailsbyPM(EmployeeID);
        }

        public DataTable GetPseudoName(string Code)
        {
            return dalMaster.GetPseudoName(Code);
        }

        public DataTable GetClientHoliday()
        {
            return dalMaster.GetClientHoliday();
        }
        public DataTable GetTop50FTEEntry(int ProjectID, int ProcessID)
        {
            return dalMaster.GetTop50FTEEntry(ProjectID, ProcessID);
        }

        public DataTable GetBilligPeriodDates(string BillingCycle)
        {
            return dalMaster.GetBilligPeriodDates(BillingCycle);
        }

        public int InsertClientHoliday(Hashtable htParam)
        {
            return dalMaster.InsertClientHoliday(htParam);
        }

        public int InsertFTEEntry(Hashtable htParam)
        {
            return dalMaster.InsertFTEEntry(htParam);
        }

        public DataTable GetSegmentwiseManpower()
        {
            return dalMaster.GetSegmentwiseManpower();
        }

        public DataTable GetSegmentwiseManpowerList()
        {
            return dalMaster.GetSegmentwiseManpowerList();
        }

        public DataTable GetColumnsList()
        {
            return dalMaster.GetColumnsList();
        }

        public DataTable GetFiltersList()
        {
            return dalMaster.GetFiltersList();
        }

        public DataTable GetGroupByList()
        {
            return dalMaster.GetGroupByList();
        }
        #endregion

        #region Health Insurance
        public DataTable GetEmployeeForGroupPolicy()
        {
            return dalMaster.GetEmployeeForGroupPolicy();
        }
        public DataTable GetPolicyPeriods()
        {
            return dalMaster.GetPolicyPeriods();
        }
        public DataTable GetEmployeesByPolicyPeriod(string PolicyPeriod)
        {
            return dalMaster.GetEmployeesByPolicyPeriod(PolicyPeriod);
        }
        public DataTable GetEmployeeGroupPolicyInfoByEmpID(int EmployeeID, int PolicyID)
        {
            return dalMaster.GetEmployeeGroupPolicyInfoByEmpID(EmployeeID, PolicyID);
        }

        public DataTable GetApplicableEmployeeForGroupPolicy()
        {
            return dalMaster.GetApplicableEmployeeForGroupPolicy();
        }

        public DataTable GetNotApplicableEmployeeForGroupPolicy()
        {
            return dalMaster.GetNotApplicableEmployeeForGroupPolicy();
        }

        public int RemoveFromPolicyList(string Code, int DeletedBy)
        {
            return dalMaster.RemoveFromPolicyList(Code, DeletedBy);
        }


        public DataTable GetFamilyInfoForGroupPolicy(int EmployeeID, int PolicyID)
        {
            return dalMaster.GetFamilyInfoForGroupPolicy(EmployeeID, PolicyID);
        }
        public DataTable GetSumInsuredDistribution(decimal Amount, decimal SumInsured, bool IsApplicable)
        {
            return dalMaster.GetSumInsuredDistribution(Amount, SumInsured, IsApplicable);
        }
        public DataTable GetAge(string BithDate)
        {
            return dalMaster.GetAge(BithDate);
        }
        public DataTable GetAllPolicyAmount()
        {
            return dalMaster.GetAllPolicyAmount();
        }
        public int ApplyEmployeeGroupPolicy(Hashtable htParam)
        {
            return dalMaster.ApplyEmployeeGroupPolicy(htParam);
        }

        public int InsertEmployeeGroupPolicy(Hashtable htParm)
        {
            return dalMaster.InsertEmployeeGroupPolicy(htParm);
        }
        #endregion


        public HashSet<string> GetAllExistingCodes()
        {
            DataTable dt = new dalMaster().GetAllExistingCodes();

            HashSet<string> codes = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            foreach (DataRow row in dt.Rows)
            {
                codes.Add(row["Code"].ToString().Trim());
            }

            return codes;
        }


        public DataTable GetAllSetAppreciationDisplinaryActionReport(string Type, int EmployeeID)
        {
            return dalMaster.GetAllSetAppreciationDisplinaryActionReport(Type, EmployeeID);
        }
        public DataTable GetDashboardPerformanceDetailsLast12Months()
        {
            return dalMaster.GetDashboardPerformanceDetailsLast12Months();
        }
        public DataTable GetProductiveEmployeePerformanceLast12Months(int EmployeeID, string FromDate, string ToDate)
        {
            return dalMaster.GetProductiveEmployeePerformanceLast12Months(EmployeeID, FromDate, ToDate);
        }
        public DataTable GetUserPerformanceReport_DashboardDetails(string FromDate, string ToDate, string Code)
        {
            return dalMaster.GetUserPerformanceReport_DashboardDetails(FromDate, ToDate, Code);
        }
        public DataTable GetProjectProcesswiseProductivity(string Code, string FromDate, string ToDate)
        {
            return dalMaster.GetProjectProcesswiseProductivity(Code, FromDate, ToDate);
        }
        public int InsertSecuritizationRelLetterBilling_Unbilled(Hashtable htParam)
        {
            return dalMaster.InsertSecuritizationRelLetterBilling_Unbilled(htParam);
        }
        public DataTable GetExistingLoanList_Unbilled()
        {
            return dalMaster.GetExistingLoanList_Unbilled();
        }
        public DataTable GetLoanTrackingHistory(Hashtable ht)
        {
            return new dalMaster().GetLoanTrackingHistory(ht);
        }


        public DataTable CheckOtherTaskExistsOrNot(Hashtable htParam)
        {
            return dalMaster.CheckOtherTaskExistsOrNot(htParam);
        }

        public DataTable DeleteExistingOthertaskRecords(Hashtable htParam)
        {
            return dalMaster.DeleteExistingOthertaskRecords(htParam);
        }

        public DataTable GetProcessForOtherTask(int ProjectID)
        {
            return dalMaster.GetProcessForOtherTask(ProjectID);
        }


        public DataTable GetAllUserERPLoginDetails()
        {
            return dalMaster.GetAllUserERPLoginDetails();

        }
    }
}
