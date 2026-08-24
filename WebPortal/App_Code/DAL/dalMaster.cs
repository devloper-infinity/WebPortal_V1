//using DocumentFormat.OpenXml.Office.Word;
//using DocumentFormat.OpenXml.VariantTypes;
//using DocumentFormat.OpenXml.Wordprocessing;
using System;
//using System.Activities.Statements;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
//using System.Linq;
using System.Web;
using System.Web.DynamicData;
using WebPortal.Admin;
using WebPortal.App_Code.Class;
using static WebPortal.Admin.ChildPages;
using static WebPortal.Admin.ResponsibilityDelegation;


namespace WebPortal.App_Code.DAL
{
    public class dalMaster
    {
        public DataTable GetMenuForUser(int UserID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetUserMenus");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, UserID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetMenuForUserFromGroup(int UserID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetMenusForUser");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, UserID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllMenus()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getAllMenus");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int DeleteRights(int userId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.Text, "DELETE FROM UserRights WHERE UserId = " + userId);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return 1;
        }

        public int InsertRights(int userId, int menuId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.Text, "INSERT INTO UserRights (UserId, MenuId) VALUES (" + userId + "," + menuId + ")");
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return 1;
        }

        public DataTable GroupList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Group_List");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int GroupSave(int groupId, string name, string desc, bool isActive)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Group_Save");
            SQLHelper.AddParamToSQLCmd(cmd, "@GroupId", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, groupId);
            SQLHelper.AddParamToSQLCmd(cmd, "@GroupName", System.Data.SqlDbType.NVarChar, 150, System.Data.ParameterDirection.Input, name);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, desc);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsActive", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, isActive);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GroupMenuList(int groupId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Group_Menu_List");
            SQLHelper.AddParamToSQLCmd(cmd, "@GroupId", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, groupId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public void DeleteGroupMenus(int groupId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "DELETE FROM GroupMenuMapping WHERE GroupId = " + groupId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

        }

        public int GroupMenuSave(int groupId, string menuIdsCsv)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Group_Menu_Save");
            SQLHelper.AddParamToSQLCmd(cmd, "@GroupId", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, groupId);
            SQLHelper.AddParamToSQLCmd(cmd, "@MenuIdsCsv", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, (object)menuIdsCsv ?? string.Empty);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable UserGroupList(int userId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "User_Group_List");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, userId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UserGroupSave(int userId, string groupIdsCsv)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "User_Group_Save");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, userId);
            SQLHelper.AddParamToSQLCmd(cmd, "@GroupIdsCsv", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, (object)groupIdsCsv ?? string.Empty);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable MenusForUserViaGroups(int userId, bool includeLegacy = true)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Menus_For_User_Via_Groups");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, userId);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncludeLegacyUserRights", System.Data.SqlDbType.Bit, 100, System.Data.ParameterDirection.Input, includeLegacy);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetProductivityForUpdate(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDailyProducitonForUpdate ");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllSecuritizationData()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllSecuritizationRel_New]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertDailyProductionRemark(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertDailyProductionRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htparam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htparam["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htparam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htparam["ProcessDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VolumeData", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htparam["VolumeData"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htparam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htparam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Checked", System.Data.SqlDbType.Bit, 100, System.Data.ParameterDirection.Input, htparam["Checked"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int GetAttendanceRequestCount(string usercode)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAttendanceRequestCount");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, usercode);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=User Not Exist, 0=Invalid Password, >0=Success
        }

        public int GetAttendanceRequestCount()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAttendanceRequestCountByEmployeeID");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=User Not Exist, 0=Invalid Password, >0=Success
        }

        public string GetCodeFromEmployeeId(int EmployeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCodeFromEmployeeId");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            string ReturnValue = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetExistingLogin(string Code, string Date)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[checkIfUserLoggedIn]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@date", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Date);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOverAllUserPerformance_UserPerfAck(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformance_UserPerfAck");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public System.Data.DataTable GetUserInformation_KYC(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUserInformation_KYC");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 50, System.Data.ParameterDirection.Input, EmployeeID);
            System.Data.DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetOverAllUserPerformance_UserPerfAck_Report(int PerformanceID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformance_UserPerfAck_Report");
            SQLHelper.AddParamToSQLCmd(cmd, "@PerformanceID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, PerformanceID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int CheckAcknowledgeUserPerformance(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_CheckAcknowledgeUserPerformance]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetAllMonthlyUserPerformanceAck(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllMonthlyUserPerformanceAck");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int AcknowledgeUserPerformance(int PerformanceID, string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AcknowledgeUserPerformance");
            SQLHelper.AddParamToSQLCmd(cmd, "@PerformanceID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, PerformanceID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetDailyProducvityReport(string from, string to)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetDaliyProdcuvityReport_Marketing");
            SQLHelper.AddParamToSQLCmd(cmd, "@From", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, from);
            SQLHelper.AddParamToSQLCmd(cmd, "@To", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, to);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDailyProducvityReport_KPSummary(string from, string to)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUserProductivity_New_Summary_1_KP");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, from);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, to);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllEmployeeDetailsByIDsForProductivity(string Ids)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllEmployeeDetailsByCodes_Productivity]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Ids);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetProductivityDetailsOf_OnlineLogin(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllEmployeeDetailsByCodes_Productivity_ICG]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable BlockUserLogin(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_BlockUserLogin");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllWorkingDetailsByCode(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllWorkingDetailsByCode");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetProductivityforDashboard_Employee(string code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetProductivityPerc_Dashboard_KRL");//GetProductivityPerc_Dashboard
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 3, System.Data.ParameterDirection.Input, code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPageAndGroupWiseConfig(int UserId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUserPageAndGroupWiseConfig");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserId", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, UserId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int CheckPM(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckPM");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int ChangePasswordNew(int EmployeeId, string OldPlainPassword, string OldPassword, string NewPassword, string PlainPassword)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_updateUserPasswordNew_ICG");//usp_updateUserPasswordNew
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@OldPassword", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, OldPassword);
            SQLHelper.AddParamToSQLCmd(cmd, "@OldPlainPassword", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, OldPlainPassword);
            SQLHelper.AddParamToSQLCmd(cmd, "@NewPassword", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, NewPassword);
            SQLHelper.AddParamToSQLCmd(cmd, "@PlainPassword", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, PlainPassword);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetEmployeePerformanceDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetSecondTabDetailsForIncrementProposal_ForDashboard");
            SQLHelper.AddParamToSQLCmd(cmd, "@Employees", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, (HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllNotificationsByUserForDashboard(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllNotificationsByUser_1");//usp_GetAllNotificationsByUser_11
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllStandardReasons()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllStandardReasons");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetEmployeeExtraHours(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmployeeExtraHours_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCodeDate(string Code, string Date)
        {
            // SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCodeDate");usp_GetCodeDateTest
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCodeDateRND");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@date", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, Date);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public string CalculateTotalHoursForAttendance(string OutDateTime, string InDateTime)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CalculateTotalHoursForAttendance1");
            SQLHelper.AddParamToSQLCmd(cmd, "@OutDateTime", System.Data.SqlDbType.VarChar, 70, System.Data.ParameterDirection.Input, OutDateTime);
            SQLHelper.AddParamToSQLCmd(cmd, "@InDateTime", System.Data.SqlDbType.VarChar, 70, System.Data.ParameterDirection.Input, InDateTime);
            string ReturnValue = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            cmd.Dispose();
            return ReturnValue;
        }

        public int GetEmployeeIdFromCode(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmployeeIdFromCode");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetAttendamceCorrectionDates(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetAlldateByAttendanceRequest_Absent");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDateForConnectivityIssuePM(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDateForConnectivityIssuePM");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLogoutDate(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLogoutDate");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAlldateByAttendanceRequestLogoutDate(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetAlldateByAttendanceRequest_LogoutDate");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertAttendanceCorrectRequest(Hashtable htAttendance)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_InsertAttendanceCorrectRequest_Revised]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["InDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InTime", System.Data.SqlDbType.NVarChar, 8, System.Data.ParameterDirection.Input, htAttendance["InTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OutDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["OutDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OutTime", System.Data.SqlDbType.NVarChar, 8, System.Data.ParameterDirection.Input, htAttendance["OutTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakOutDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["BreakOutDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakOutTime", System.Data.SqlDbType.NVarChar, 8, System.Data.ParameterDirection.Input, htAttendance["BreakOutTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakInDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["BreakInDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakInTime", System.Data.SqlDbType.NVarChar, 8, System.Data.ParameterDirection.Input, htAttendance["BreakInTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reason", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, htAttendance["Reason"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReasonType", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, htAttendance["ReasonType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htAttendance["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;

        }

        public DataTable GetDashboardPerform()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDashboardProduQualityAttendance");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDashboardProjPerform()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTopPerformProjects");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetDetailsForExcludeRemark(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDetailsForExcludeRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable ds = SQLHelper.ExecuteDataTableCmd(cmd);
            return ds;
        }

        public DataTable GetAllDate()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllDate");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getTargetUserWise(string Code, string Project, string Process)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTargetuserwise_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Project);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Process);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllProjectByUserRights(string EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllProjectByUserRights]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertAttritioNRemark(string Code, string Remark, string ResignationDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAttritionReportEmployees");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ResignationDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable CheckproductivityAcutalHoursIsEqualtimespent(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckTimeSpentAndWorkingHoursEqual");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable CalculateUptoTimeForProductivity(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CalculateUptoTimeForProductivity");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable CheckproductivityAcutalHoursIsEqualtimespentForUpdate(string Code, string Date)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckTimeSpentAndWorkingHoursEqualForUpdate");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date1", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Date);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertDailyProdcutvityInTempDailyProductivityTable(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertDailyProductivityInTempDeailyProductvityTable");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int UpdateDailyProdcutvityInTempDailyProductivityTable(string DailyProductvityID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateDailyProductivityInTempDeailyProductvityTable");
            SQLHelper.AddParamToSQLCmd(cmd, "@DailyProductvityID ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DailyProductvityID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable getTempDailyProductvity(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[GetTempdailyProductvity_NewERP]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getTempDailyProductvityNew(string Code, string from, string to)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[GetTempdailyProductvityNew_1]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@From", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, from);
            SQLHelper.AddParamToSQLCmd(cmd, "@To", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, to);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDailyProductvity(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetdailyProductvity_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet GetTrackingProductionByUserWise_DomainWise(string Date, int EmployeeID, int DomainID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetALLUserDailyProductivity_NewComm_Nil_KIP_DoaminWise]"); // [WBT_usp_GetUserDailyProductvityInOnlineTrackingSheet_KRL_ShowUser_Productivity_KRL1] //WBT_usp_GetUserDailyProductvityInOnlineTrackingSheet_KRL_ShowUser_Productivity
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainIDNew", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, DomainID);
            SQLHelper.AddParamToSQLCmd(cmd, "@TodayDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Date);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataTable getDailyProductvityForUpdate(string DailyProductvityID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[GetdailyProductvityForUpdate]");
            SQLHelper.AddParamToSQLCmd(cmd, "@DailyProductvityID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DailyProductvityID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int CheckEmployeeisApplicableForAddPRoductivity(string Code, string Date)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckEmployeeisApplicable_For_AddPRoductivity");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, Date);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertDailyProdcutvity(Hashtable htDaily)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[InsartDailyProductivity_KRL]"); //old  InsartDailyProductivity_1
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 120, System.Data.ParameterDirection.Input, htDaily["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientOrderDate", System.Data.SqlDbType.NVarChar, 120, System.Data.ParameterDirection.Input, htDaily["ClientOrderDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htDaily["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Product", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Product"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Target", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Target"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Production", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["Prduction"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductionType", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["ProductionType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TimeSpent", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["TimeSpane"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htDaily["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htDaily["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InIP", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htDaily["InIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
        public int InsertDailyProdcutvityFor_OnlineTracking(Hashtable htDaily)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[InsartDailyProductivity_For_OnlineTracking_KRL]"); //InsartDailyProductivity_For_OnlineTracking
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 120, System.Data.ParameterDirection.Input, htDaily["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientOrderDate", System.Data.SqlDbType.NVarChar, 120, System.Data.ParameterDirection.Input, htDaily["ClientOrderDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htDaily["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Target", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Target"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Production", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["Production"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductionType", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["ProductionType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TimeSpent", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["TimeSpent"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htDaily["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htDaily["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InIP", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htDaily["InIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["ProductType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ID", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["TrackingProdcutionID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertRejectionRemarkFor_OnlineTracking(Hashtable htDaily)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_InsertOnlineTrackingReajectionRemark]");
            SQLHelper.AddParamToSQLCmd(cmd, "@ID", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htDaily["ID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RejectionRemark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htDaily["RejectionRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htDaily["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int UpdateTempDailyProductivity(Hashtable htDaily)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[UpdateTempDailyProductivity_KRL]");//UpdateTempDailyProductivity
            SQLHelper.AddParamToSQLCmd(cmd, "@Code ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date ", System.Data.SqlDbType.NVarChar, 120, System.Data.ParameterDirection.Input, htDaily["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientOrderDate ", System.Data.SqlDbType.NVarChar, 120, System.Data.ParameterDirection.Input, htDaily["ClientOrderDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project ", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htDaily["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Process"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@New ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["New"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@Update ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Update"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@PenHuntNew ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["PenHuntNew"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@PenHuntNewUpdate ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["PenHuntNewUpdate"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@Addendum ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Addendum"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Target ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Target"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Production ", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["Prduction"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductionType ", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["ProductionType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TimeSpent  ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["TimeSpane"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark  ", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htDaily["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy  ", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htDaily["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InIP  ", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htDaily["InIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataSet getTrackingProductionByUserWise(string Date, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetALLUserDailyProductivity]"); // [WBT_usp_GetUserDailyProductvityInOnlineTrackingSheet_KRL_ShowUser_Productivity_KRL1] //WBT_usp_GetUserDailyProductvityInOnlineTrackingSheet_KRL_ShowUser_Productivity
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@TodayDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Date);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataTable GetTempDailyProductivity(string Code, string Date, string ProjectName, string ProcessName, string ProductionType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTempDailyProductivity");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Date);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectName", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectName);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessName", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProcessName);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductionType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProductionType);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public string ValidateProject(string Project)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ValidateProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, Project);
            string returnValue = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return returnValue;
        }

        public string ValidateProcess(string Project, string Process)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ValidateProcess");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, Project);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.VarChar, 200, System.Data.ParameterDirection.Input, Process);
            string returnValue = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return returnValue;
        }

        public string ValidateProductType(string Project, string Process, string ProductType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ValidateProductType");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, Project);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.VarChar, 200, System.Data.ParameterDirection.Input, Process);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductType", System.Data.SqlDbType.VarChar, 200, System.Data.ParameterDirection.Input, ProductType);
            string returnValue = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return returnValue;
        }

        public string ValidateUserProjectRights(string EmployeeId, string ProjectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ValidateUserProjectRights");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, EmployeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, ProjectId);
            string returnValue = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return returnValue;
        }

        public DataTable GetAllLeavesForPMLogin(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllLeavesForPMLogin");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserLeavesbyCode(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getUserLeavesbyCode");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllLeavesbyPM(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllLeavesbyPM_Pending");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLeaveDetails(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUserLeaveDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertTeamLeavesByPM(Hashtable htTeamLeaves)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertTeamLeavesByPM");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htTeamLeaves["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ForDays", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htTeamLeaves["ForDays"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UserFromDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htTeamLeaves["LeaveFrom"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UserToDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htTeamLeaves["LeaveTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReasonForLeave", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htTeamLeaves["ReasonForLeave"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InformType", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htTeamLeaves["InformType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htTeamLeaves["ApprovedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htTeamLeaves["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public string GetLeavesToDate(string FromDate, int Days)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLeavesToDate");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@Days", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, Days);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            string ReturnValue = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertPaidLeavePM(Hashtable htParam, int LeaveID, string PaidStatus)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertPaidLeaves_PM");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LeaveFrom"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LeaveTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reason", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["ReasonForLeave"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LeaveID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, LeaveID);
            SQLHelper.AddParamToSQLCmd(cmd, "@PaidStatus", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, PaidStatus);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllUserByPM(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ShowUserByPM");
            SQLHelper.AddParamToSQLCmd(cmd, "@NewCode", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int CheckIfPM(int EmployeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckPM");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllEmployeeDetailsbyPMForInitiate(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_ShowUserByPM_For_Initiate]"); // old Procedure  usp_GetAllEmployeeDetailsByPM_For_Initiate
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public DataTable GetAllEmployeeDetailsSolForInitiate()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllEmployeeDetails1_For_Initiate]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllEmployeeDetailsForInitiate()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllEmployeeDetails_For_Initiate]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllProject()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProject");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getProcess(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetProcessBYProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLastWorkingDate(string FormDate, string LastWorkinDate, string ResignationType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLastWorkingDate_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FormDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@LastWorkingDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, LastWorkinDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ResignationType);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public string GetLastLoginDate(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getLastLoginDate");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            string LastLogin = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return LastLogin;
        }

        public DataTable GetAllDetailsOnCheckListForNewJoining(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllDetailsOnCheckListForNewJoining");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InitiateResignation(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InitiateResignation_Only");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["EmployeeId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContactNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ContactNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ResignationType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ResignationDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LastWorkingDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LastWorkingDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reasontoterminate", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Reasontoterminate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@status", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttritionCategory", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["AttritionCategory"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UnitHeadRemark", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["UnitHeadRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UnitHead", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["UnitHead"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationRecivedTrough", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["ResignationRecivedTrough"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetResignedEmployeesForFinalize(int EmplyeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getallResignedEmployeesForStep2");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmplyeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UpdateUserLeaves(int LeaveId, bool Status, int ApprovedBy, string Remark, string PaidStatus)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateUserLeaves_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@LeaveId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, LeaveId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, Status);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ApprovedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@PaidStatus", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, PaidStatus);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public decimal GetPendingLeaveCount(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "getPendingLeaves");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            decimal LeaveCount = (decimal)SQLHelper.ExecuteScalarCmd(cmd);
            return LeaveCount;
        }

        public DataTable GetAllResignedEmployees(int EmpId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllResignedEmployees");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmpId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDailyLogs(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllDailyLogs");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public string GetPassword(string Username)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmailPassword");
            SQLHelper.AddParamToSQLCmd(cmd, "@Username", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Username);
            string Password = (string)SQLHelper.ExecuteScalarCmd(cmd);
            return Password;
        }

        public int UpdateResignation(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateResignation");
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ResignationID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttritionCategory", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["AttritionCategory"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UnitHeadRemark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["UnitHeadRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationReceivedThrough", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ResignationReceivedThrough"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetResignationDetails(int ResignationID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetResignationDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationID", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, ResignationID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public string GetUnitHeadEmail(int EmployeeId)
        {
            string EmailAddress = "";
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUnitHeadEmail");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, EmployeeId);
            EmailAddress = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return EmailAddress;
        }

        public DataTable GetResignationDetailsbyEmployeeID(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetResignationDetailsbyEmployeeID");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UpdateExitFormalityRemark(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateExitFormalityRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["ResignationID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int ChangeResignationType(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ChangeResignationType");
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ResignationId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ResignationType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ResignationDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LastWorkingDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LastWorkingDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReasonType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ReasonType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReasonRemark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ReasonRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reasontoterminate", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Reasontoterminate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int ExtendShortenNoticePeriod(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ExtendShortenNoticePeriod");
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ResignationId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ResignationType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ResignationDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LastWorkingDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LastWorkingDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RevisedDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["RevisedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int CancelResignation(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CancelResignation");
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ResignationId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int DropOutUser(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_DropoutEmployee");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignedDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ResignedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reason", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Reason"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@HRRemark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["HRRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DropOutDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DropOutDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignedType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ResignedType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LastWorkingDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LastWorkingDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DropOutBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["DropOutBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsExitFormalities", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["IsExitFormalities"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllShift()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllShift");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDepartment()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllDepartment");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDomain()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllDomain");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet GetAllDataForHoursSpent(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_Hoursspent_UW");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataSet ds = SQLHelper.ExecuteDataSetCmd(cmd);
            return ds;
        }

        public DataTable GetDomainsAsPerEmp(int EmpID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDomainsAsPerEmp");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmpID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDomainGroups()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllDomainGroup");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllBranches()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllBranches");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllProjectManager()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProjectManager");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDesignation()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllDesignation");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable ProjectManagerRelatedToDepartment(int EmpId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ReportingManagerRelatedToDepartment");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmpId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetEmpsByDept(int DepartmentID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmpsByDept");
            SQLHelper.AddParamToSQLCmd(cmd, "@DepartmentID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, DepartmentID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllWeeklyHoliday()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllWeeklyHoliday");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDomainwiseSubdomain(int DomainID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDomainwiseSbdomains");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DomainID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetSubdomains()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllSubdomainsForProfile");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllBankMasterDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllBankMasterDetails");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int CodeExists(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllCheckCode");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }


        public DataTable GetAllExistingCodes()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllExistingCodes");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public string GetCutOffTime(string shift)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "getCutoffTimneByShift");
            SQLHelper.AddParamToSQLCmd(cmd, "@Shift", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, shift);
            string cutofftime = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return cutofftime;
        }

        public DataTable GetWeeklyHolidayByHours(int Hours)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetWeeklyHolidayByHours");
            SQLHelper.AddParamToSQLCmd(cmd, "@Hours", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, Hours);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable ShowAllLogDetails(string Code, string Date)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ShowAllLogDetails_Updated");//"usp_ShowAllLogDetails_HVB" usp_ShowAllLogDetails); 
            SQLHelper.AddParamToSQLCmd(cmd, "@PMCode", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Date);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertEmployeeLogInHistory(string Code, bool Status, string Remark, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertEmployeeLogInHistory");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, Status);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public string GetBlockedRemarkByCode(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetBlockRemarkByEmployee");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            string BLockedRemark = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return BLockedRemark;
        }

        public DataTable GetAllDailyLogs_Monthwise(int EmployeeID, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllDailyLogs_Monthwise]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 50, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getTargetUserWise_Productivity(string Code, string Project, string Process, string ProductType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTargetuserwise_1_Searching");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Project);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Process);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProductType);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int DeleteTempDailyProductivity(int TempDailyProducvityID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_DeleteTempDailyProductivity]"); //old  InsartDailyProductivity_1
            SQLHelper.AddParamToSQLCmd(cmd, "@TempDailyProducvityID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, TempDailyProducvityID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertDailyProductivitySearching(Hashtable htDaily)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[InsartDailyProductivity_Searching]"); //old  InsartDailyProductivity_1
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 120, System.Data.ParameterDirection.Input, htDaily["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientOrderDate", System.Data.SqlDbType.NVarChar, 120, System.Data.ParameterDirection.Input, htDaily["ClientOrderDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htDaily["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htDaily["ProductID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Product", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Product"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Target", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Target"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Production", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["Prduction"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductionType", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["ProductionType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TimeSpent", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["TimeSpent"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htDaily["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htDaily["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InIP", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htDaily["InIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int UpdateTempDailyProductivitySearching(Hashtable htDaily)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[UpdateTempDailyProductivity_Searching]");//UpdateTempDailyProductivity
            SQLHelper.AddParamToSQLCmd(cmd, "@Code ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date ", System.Data.SqlDbType.NVarChar, 120, System.Data.ParameterDirection.Input, htDaily["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientOrderDate ", System.Data.SqlDbType.NVarChar, 120, System.Data.ParameterDirection.Input, htDaily["ClientOrderDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project ", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htDaily["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htDaily["ProductID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Target ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["Target"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Production ", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["Prduction"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductionType ", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htDaily["ProductionType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TimeSpent  ", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htDaily["TimeSpane"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark  ", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htDaily["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy  ", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htDaily["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InIP  ", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htDaily["InIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllEmployeeDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllEmployees]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllEmployeeDetails_Dynamic()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllEmployees_Dynamic]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllEmployeeDetailsOnViewProfile(String UserCode)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllEmployeeDetailsOnViewProfile");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, UserCode);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertBankAccountNo(Hashtable htBank)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertBankAccountNo");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htBank["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankName", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htBank["BankName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AccountNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htBank["BankAccNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IFSCCode", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htBank["BankIFSC"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htBank["UpdatedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htBank["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllEmployeeVerificationRecords(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getAddressVerificationRecords");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAddressVerificationDataForSummary(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAddressVerificationDataForSummary");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetResignedEmployeeSummary_MonthWise(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetResignedEmployeeSummary_MonthWise");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertAddressVerification(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAddressVerification");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerificationDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["VerificationDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CourierNo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["CourierNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 50, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertAddressVerificationDocument(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAddressVerificationDocument");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerificationDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["VerificationDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CourierNo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["CourierNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 50, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetExEmployerVerificationRecords(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllEmployeeVerificationRecords_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertIsVerificationRequried(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateBGVRequired");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["VerificationID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BGVRequired", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["BGVRequired"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 50, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertEmployeePreVerificationInfo(Hashtable htVerify)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertEmployeePreVerificationInfo_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CandidateName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["CandidateName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeCode", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["EmployeeCode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["CompanyName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmploymentPeriod", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["EmploymentPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LastDesignation", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["LastDesignation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Salary", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["Salary"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReportingPersonName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["ReportingPersonName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReportingPersonDesignation", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["ReportingPersonDesignation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReportingPersonContact", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["ReportingPersonContact"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReasonForLiving", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["ReasonForLiving"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PendingExitFormalities", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["PendingExitFormalities"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EligibilityToRehire", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["EligibilityToRehire"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedBy", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htVerify["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedFromName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedFromName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@HRName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["HRName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@HRContact", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["HRContact"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DutiesAndResponsibilitiesl", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["DutiesAndResponsibilitiesl"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetEmployeeVerificationData(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetEmployeeVerificationData]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertEmployeeVerificationEmailDetails(Hashtable htVerify)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateVerificationEmailFlag");
            SQLHelper.AddParamToSQLCmd(cmd, "@VerificationID", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerificationID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SenderID", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["SenderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MailSendBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htVerify["MailSendBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int GetVerificationIDFromEmployeeID(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getVerificationIDfromEmpID");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
        public DataTable GetEmployeeVerificationRecordsByVerificationID(int verificationID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPriorEmployeeVerificationDetailsByVerificationID");
            SQLHelper.AddParamToSQLCmd(cmd, "@VerificationID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, verificationID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertEmployeeVerification(Hashtable htVerify)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertEmployeeVerification_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedCandidateName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedCandidateName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedEmployeeCode", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedEmployeeCode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedCompanyName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedCompanyName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedEmploymentPeriod", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedEmploymentPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedLastDesignation", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedLastDesignation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedSalary", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedSalary"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedReportingPersonName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedReportingPersonName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedReportingPersonDesignation", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedReportingPersonDesignation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedReportingPersonContact", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedReportingPersonContact"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedReasonForLiving", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedReasonForLiving"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedPendingExitFormalities", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedPendingExitFormalities"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedDutiesAndResponsibilitiesl", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedDutiesAndResponsibilitiesl"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WorkPerformance", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["WorkPerformance"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedWorkPerformance", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedWorkPerformance"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttitudePersonalReputation", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["AttitudePersonalReputation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedAttitudePersonalReputation", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedAttitudePersonalReputation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EligibilityForRehire", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["EligibilityForRehire"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedEligibilityForRehire", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedEligibilityForRehire"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RelevantInformation", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["RelevantInformation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IntigrityAndDisciplinaryIssue", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["IntegrityDisciplinaryIssue"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedFromDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedFromDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AlternateVerifiedFromEmailID", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["AlternateVerifiedFromEmailID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedHRName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedHRName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedBy", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedByVerified", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedByVerified"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedHRContact", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["VerifiedHRContact"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Document", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htVerify["Document"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htVerify["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetFunFriday()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetFunFriday]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllRnRSnaps()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllRnRSnaps]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetFunFridaySnapsByID(int FFID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetFunFridaySnapsByID]");
            SQLHelper.AddParamToSQLCmd(cmd, "@FFID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, FFID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertFunFriday(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertFunFriday");
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Activity", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Activity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Location", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["Location"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Details", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Details"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Snaps", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Snaps"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);


            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllEmployeeDetailsbyPM(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_getAllNewJoinedEmployees]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public int InsertFollowupRemark(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertNewJoineeFollowUpRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);


            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllUserCode()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Usp_GetAllCode_All");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertLetterHeadCount(Hashtable htParm)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "InsertLetterHeadCount");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParm["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParm["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reason", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParm["Reason"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Count", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParm["Count"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParm["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetLetterHEadsCount()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLetterHeadsCount");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLetterHEadsCount_Dates(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLetterHeadsCount_Dates");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllReadUnreradDashboardAlert()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllReadUnreadDashboardAlertByUser");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertPaidLeave(Hashtable htParam, int LeaveID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertPaidLeaves");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LeaveFrom"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LeaveTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reason", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["ReasonForLeave"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LeaveID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, LeaveID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertEmpAppointmentDate(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertEmpAppointmentDate");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htparam["EmpId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AppointMentDate", System.Data.SqlDbType.DateTime, 0, System.Data.ParameterDirection.Input, htparam["AppointMentDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertLeave(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertLeave");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LeaveType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LeaveType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ForDays", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["ForDays"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LeaveFrom", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["LeaveFrom"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LeaveTo", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["LeaveTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReasonForLeave", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["ReasonForLeave"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsApproved", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["IsApproved"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ApprovedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);


            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public string GetUnitHeadName(int EmployeeId)
        {
            string EmailAddress = "";
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDomainHeadName");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, EmployeeId);
            EmailAddress = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return EmailAddress;
        }

        public DataTable GetAllEmployeeForAttendancePercentage()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllEmployeeForAttendancePercentage");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetRnR()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetRnR_1");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertRnR(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertRnR_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Quarter", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Quarter"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FinalStatus", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["FinalStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Employees", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Employees"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetAllUsers()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllUsers_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLastFourYearGrading(string Quarter, int Year, string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLastFourQuarterGrading");
            SQLHelper.AddParamToSQLCmd(cmd, "@Quarter", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Quarter);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllPreviousFeedback(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getPreviousSkipFeedback");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertSkipLevelMeeting(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertSkipLevelMeeting");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Quarter", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Quarter"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertSkipLevelMeetingAction(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertSkipLevelMeetingAction");
            SQLHelper.AddParamToSQLCmd(cmd, "@MeetingId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["MeetingId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable getSummaryReport(string Year, string Quarter)
        {
            //SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_SkipMeetingSummary_Revised_1]");
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_SkipMeetingSummary_Revised_2]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@Quarter", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Quarter);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getInvoiceData(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetStamppaperInvoice]");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllUsers_1()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllUsers");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertStampPaperInfo(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertStampPaperInfo");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PaperType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["PaperType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@StampPaperNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["StampPaperNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@StampPaperCost", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["StampPaperCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Version", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Version"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@StampPaperUsed", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["StampPaperUsed"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReceivedDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ReceivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReceivedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ReceivedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetStampPaperInfo(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetStampPaperInfo");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertBankName(string BankName, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertBankName");
            SQLHelper.AddParamToSQLCmd(cmd, "@BankName", System.Data.SqlDbType.VarChar, 500, System.Data.ParameterDirection.Input, BankName);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetAllCode()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllCode");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllRomingBranch()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllRomingBranch");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertRomingBranch(string User, int BranchId, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertRomingBranch");
            SQLHelper.AddParamToSQLCmd(cmd, "@User", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, User);
            SQLHelper.AddParamToSQLCmd(cmd, "@BranchId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, BranchId);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int deleteRomingBranch(int RomingBranchID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_deleteRomingBranch");
            SQLHelper.AddParamToSQLCmd(cmd, "@RomingBranchID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, RomingBranchID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetDirectDropoutEmployees()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAbscondingEmployeesForDirectDropout");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDropoutEmployeeDetails(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDropoutEmployeeDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDropoutEmployeeDetailsForISO(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetResignedEmployeesForISO");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDropoutEmployeeDetailsForISO_Revised(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetResignedEmployeesForISO_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetApprovedBankDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetApprovedBankDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPendingBankDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPendingBankDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getAllSocialVisitors(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllSocialSiteVisitor");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetSocialSiteVisitorByID(int VisitorID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetSocialSiteVisitorByID]");
            SQLHelper.AddParamToSQLCmd(cmd, "@VisitorID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, VisitorID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertSocialSiteVisitor(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_InsertSocialSiteVisitor]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SocialSite", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["SocialSite"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DateVisited", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DateVisited"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertGalssdoorReview(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_InsertGalssdoorReview]");
            //SQLHelper.AddParamToSQLCmd(cmd, "@NoOfReviews", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NoOfReviews"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@NegativeReviews", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NegativeReviews"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyRating", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, htParam["CompanyRating"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable getAllGlassDoors()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllGlassDoorRating");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getAllGlassDoorsComp()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllGlassDoorRatingComp");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertGalssdoorReviewComp(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_InsertGalssdoorReviewComp]");
            //SQLHelper.AddParamToSQLCmd(cmd, "@NoOfReviews", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["NoOfReviews"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyName", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["CompanyName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyRating", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, htParam["CompanyRating"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetAllCompetitors()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetGlassDoorCompetitors");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllGlassDoorCompetitors()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllGlassDoorCompetitors");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getAllHRQuestion()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllHRQuestionBy");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertCompetitor(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_InsertGlassDoorCompetitors]");
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyName", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["CompanyName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertHRQuestion(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertHRQuestion");
            SQLHelper.AddParamToSQLCmd(cmd, "@Question", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Question"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@QueAttachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["QueAttachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@QuestionType", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["QuestionType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer1", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer1"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer2", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer2"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer3", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer3"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer4", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer4"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CorrectAnswer", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CorrectAnswer"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Weightage", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Weightage"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetHRCheckQuestionPaper(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetHRCheckQuestionPaper]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceProdDetailsOther(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformanceDetailsOther");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetHRCheckQuestionPaper_Report(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetHRCheckQuestionPaper_Report]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable BindHRInductionExamInfo(int EmployeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_BindHRExamDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetHRAnswerSheet(int EmpId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_HRCheckQuestionPaper]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmpId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet GetHRCheckQuestionPaperReport(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetHRCheckQuestionPaperReport_1]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataTable GetDashboardAlertById(int AlertId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllDashboardAlertById");
            SQLHelper.AddParamToSQLCmd(cmd, "@AlertId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, AlertId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCurrentManpowerSummary(string Type)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_dasboardCurrentManpowerSummary");
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCurrentManpowerSummaryDetails(string Type, int Branch, int Domain, string Subdomain, int Column)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getdashboardSummaryDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            SQLHelper.AddParamToSQLCmd(cmd, "@WorkingBranch", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, Branch);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, Domain);
            SQLHelper.AddParamToSQLCmd(cmd, "@SubDomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Subdomain);
            SQLHelper.AddParamToSQLCmd(cmd, "@Column", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, Column);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet GetRequisition(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_getRecruitmentDetailsForHRReport]"); //usp_getRequisitionSummaryExport
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }


        public DataSet GetAttritionReportForHRReport(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAttritionReportForHRReport]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }


        public DataSet GetHiring(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetHiringSummaryandDetails_Beta]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataSet Getmanpower(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetManpowerSummaryandDetails_Beta]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataTable GetSkipLevelSummary(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_SkipMeetingSummary_ForHRReport]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllEmployeeVerificationRecords_Export(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllEmployeeVerificationRecords_ExportHR_Report");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet GetAbsocndingNewJoinedDetailsForExport_DS(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAbscondingAttritionEmployeeDetailsForExport_Beta");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataSet GetResignedEmployees_New(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAttritionEmployeeDetailsForExport_New");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataTable GetFunFriday(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetFunFriday_Report]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public DataTable GetFunFridaySnaps(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetFunFridaySnaps]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public DataSet GetNaukri_New(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetNaukriRecruitmentDetails_New]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataSet GetLinkedIn_New(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetLinkedInRecruitmentDetails_New]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataTable GetGlassdoorReview(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetGlassdoorReview_New]");
            //SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            //SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetGlassdoorReviewComp(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetGlassdoorReviewComp]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetRRSnaps()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetRRSnaps]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public DataTable getInvoiceData_Report(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetStamppaperInvoice_New]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetMastData()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetERPMasterData_4]");//usp_GetERPMasterData_3, usp_GetERPMasterData_3_ICG ,usp_GetERPMasterData_4
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetMastDataFrHRReport()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetERPMasterData_1_ICG]");/*usp_GetERPMasterData_1*/
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllBirthdays()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetBithdayWiseListForAll]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllBirthdayMessages(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_getAllWishListByEmployee]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetBankAccDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetBankAccDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllPsuedoName()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllPsuedoName]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllUsersUpdatePsuedoName()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllUsersUpdatePsuedoName");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDataForPendingToUpdateBankDetails(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDataForPendingToUpdateBankDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int ApproveBankAccountNo(Hashtable htBank)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ApproveBankAccountNo");
            SQLHelper.AddParamToSQLCmd(cmd, "@IsVerify", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htBank["IsVerify"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htBank["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AccNoChangeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htBank["AccNoChangeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VerifiedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htBank["VerifiedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htBank["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InseartPsuedoName(Hashtable htGroup)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InseartPsuedoName");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htGroup["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Name", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htGroup["Name"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htGroup["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PsuedoName", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htGroup["PsuedoName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DataSource", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htGroup["DataSource"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Location", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htGroup["Location"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Company", System.Data.SqlDbType.NVarChar, 400, System.Data.ParameterDirection.Input, htGroup["Company"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htGroup["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int DeletePsuedoName(Hashtable htGroup)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_DeletePsuedoName");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpConfigrationID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htGroup["EmpConfigrationID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeletedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htGroup["DeletedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllUsersUpdatePsuedoNamebyCode(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllUsersUpdatePsuedoNamebyCode");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetBankAttachmentByID(int ChangeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetBankAttachmentPath");
            SQLHelper.AddParamToSQLCmd(cmd, "@AccNoChangeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ChangeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetNewJoineeFollowUp(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_getAllNewJoinedEmployees_Report]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public DataTable GetAddressVerification(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getAddressVerificationRecords_Report");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetEmployeesForExit()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetEmployeesForExit_Report]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet GetSkiplevelDetails(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetExportDetailsForSkipMeeting_ForHRReport_Beta_ICG]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public int InsertStampPaperDetails(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertStampPaperDetails_Revised_ICG"); //usp_InsertStampPaperDetails_Revised_1
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Cost", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Cost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Version", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Version"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Duration", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htParam["Duration"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AgreementDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["AgreementDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ExpiryDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["ExpiryDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SignedDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["SignedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@StampPapersUsed", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["StampPapersUsed"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@StampPaperNo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["StampPaperNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FileNo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["FileNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AcknowledgementDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["AcknowledgementDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PseudonameClause", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["PseudonameClause"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertMasterDataDetails_FileNo(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertMasterDataDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FileNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["FileNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VisaNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["VisaNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ValidTill", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ValidTill"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ScannedCopy", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ScannedCopy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Addedby"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetStampPaperDetailsHistoryOfEmployee(string Code, string Type)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetStampPaperDetailsHistoryOfEmployee");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertStampPaperClause(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAddendumClause");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Type"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Version", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Version"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Clause", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Clause"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClauseNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ClauseNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Penalty", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Penalty"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Addedby", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Addedby"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }


        public DataTable GetHR_TicketReport(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetTicketReportforHRReport]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
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

        public string GetFinalRemarkForSalary(int AppId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetFinalRemark");
            SQLHelper.AddParamToSQLCmd(cmd, "@AppId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AppId);
            string returnValue = Convert.ToString(SQLHelper.ExecuteScalarCmd(cmd));
            return returnValue;
        }

        public int InsertEmployeeInfo(Hashtable htProfile)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertEmployeeInfo");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Title", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["Title"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@lastName", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["lastName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Firstname", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["FirstName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MiddleName", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["MiddleName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Gender", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["Gender"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PresentAddress", System.Data.SqlDbType.VarChar, 3000, System.Data.ParameterDirection.Input, htProfile["PresentAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PermanentAddress", System.Data.SqlDbType.VarChar, 3000, System.Data.ParameterDirection.Input, htProfile["PermanentAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailID", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["EmailID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Qualification", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["Qualification"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CellNo", System.Data.SqlDbType.VarChar, 15, System.Data.ParameterDirection.Input, htProfile["CellNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResTelNo", System.Data.SqlDbType.VarChar, 20, System.Data.ParameterDirection.Input, htProfile["ResTelNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DateOfBirth", System.Data.SqlDbType.VarChar, 15, System.Data.ParameterDirection.Input, htProfile["DateOfBirth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BloodGroup", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["BloodGroup"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PAN", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["PAN"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JoiningDate", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["JoiningDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Salary", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htProfile["Salary"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Company", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["Company"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WorkingBranch", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["WorkingBranch"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Designation", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["Designation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Department", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["Department"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htProfile["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectManager", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["ProjectManager"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Shift", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["Shift"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CutOffTime", System.Data.SqlDbType.VarChar, 12, System.Data.ParameterDirection.Input, htProfile["CutOffTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WorkingHours", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["WorkingHours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsAgreement", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htProfile["IsAgreement"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Period", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["Period"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DateOfAgreement", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["DateOfAgreement"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AgreementExpiraryDate", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["AgreementExpiraryDate"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@IsBond", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htProfile["IsAgreement"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@BondPeriod", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["BondPeriod"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@DateOfBond", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["DateOfBond"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@BondExpiraryDate", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["BondExpiraryDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OfficialEmailID", System.Data.SqlDbType.VarChar, 200, System.Data.ParameterDirection.Input, htProfile["OfficialEmailID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankName", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["BankName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankAccNo", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["BankAccNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AadharNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htProfile["AadharNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UAN", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["UAN"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ESICNo", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["ESICNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PFNo", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["PFNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WeeklyHoliday", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["WeeklyHoliday"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeType", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["EmployeeType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UpdatedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["UpdatedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AppID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htProfile["AppID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RequisitionID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htProfile["RequisitionID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htProfile["Domain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SubDomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htProfile["SubDomain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UWExp", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htProfile["UWExp"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DailyTaskProductivity", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["DailyTaskProductivity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeRemark", System.Data.SqlDbType.VarChar, 5000, System.Data.ParameterDirection.Input, htProfile["EmployeeRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IFSCCode", System.Data.SqlDbType.VarChar, 5000, System.Data.ParameterDirection.Input, htProfile["BankIFSC"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncMonth", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["IncMonth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncYear", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["IncYear"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AppointmentDate", System.Data.SqlDbType.DateTime, 0, System.Data.ParameterDirection.Input, htProfile["AppointmentDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsVerificationRequired", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htProfile["IsVerificationRequired"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htProfile["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsPolicy", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htProfile["IsPolicy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JobType", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["JobType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            try
            {
                SQLHelper.ExecuteNonQueryCmd(cmd);
            }

            catch (Exception)
            {

            }

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;

        }

        public int UpdateEmployeeInfo(Hashtable htProfile)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateEmployeeInfo");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Title", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["Title"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@lastName", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["lastName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Firstname", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["FirstName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MiddleName", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["MiddleName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Gender", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["Gender"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PresentAddress", System.Data.SqlDbType.VarChar, 500, System.Data.ParameterDirection.Input, htProfile["PresentAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PermanentAddress", System.Data.SqlDbType.VarChar, 500, System.Data.ParameterDirection.Input, htProfile["PermanentAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailID", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["EmailID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Qualification", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["Qualification"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CellNo", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["CellNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ResTelNo", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["ResTelNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DateOfBirth", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["DateOfBirth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BloodGroup", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["BloodGroup"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PAN", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["PAN"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JoiningDate", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["JoiningDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Salary", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htProfile["Salary"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WorkingBranch", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["WorkingBranch"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Designation", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["Designation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Department", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["Department"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htProfile["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectManager", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["ProjectManager"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Shift", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["Shift"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CutOffTime", System.Data.SqlDbType.VarChar, 12, System.Data.ParameterDirection.Input, htProfile["CutOffTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WorkingHours", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["WorkingHours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsAgreement", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htProfile["IsAgreement"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Period", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["Period"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DateOfAgreement", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["DateOfAgreement"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AgreementExpiraryDate", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["AgreementExpiraryDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OfficialEmailID", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["OfficialEmailID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankName", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["BankName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankAccNo", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["BankAccNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UAN", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["UAN"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ESICNo", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["ESICNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PFNo", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["PFNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WeeklyHoliday", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["WeeklyHoliday"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeType", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, htProfile["EmployeeType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RequisitionID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htProfile["RequisitionID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htProfile["Domain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SubDomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htProfile["SubDomain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UWExp", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htProfile["UWExp"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UpdatedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["UpdatedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DailyTaskProductivity", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["DailyTaskProductivity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeRemark", System.Data.SqlDbType.VarChar, 5000, System.Data.ParameterDirection.Input, htProfile["EmployeeRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IFSCCode", System.Data.SqlDbType.VarChar, 5000, System.Data.ParameterDirection.Input, htProfile["BankIFSC"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncMonth", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["IncMonth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IncYear", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htProfile["IncYear"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AppointmentDate", System.Data.SqlDbType.DateTime, 0, System.Data.ParameterDirection.Input, htProfile["AppointmentDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsPolicy", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htProfile["IsPolicy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AadharNo", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htProfile["AadharNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@JobType", System.Data.SqlDbType.VarChar, 50, System.Data.ParameterDirection.Input, htProfile["JobType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            try
            {
                SQLHelper.ExecuteNonQueryCmd(cmd);
            }
            catch (Exception)
            {

            }

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetPMSummary(string Year, string Quarter)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_SkipMeetingSummary_PMWise_Revised_1]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@Quarter", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Quarter);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDMSummary(string Year, string Quarter)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_SkipMeetingSummary_DMWise_Revised_1]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@Quarter", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Quarter);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPMDetails(string Year, string Quarter)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetExportDetailsForSkipMeeting_2]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@Quarter", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Quarter);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertUWQuestion(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUWQuestion");
            SQLHelper.AddParamToSQLCmd(cmd, "@Question", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Question"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@QuestionType", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["QuestionType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer1", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer1"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer2", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer2"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer3", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer3"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer4", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer4"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CorrectAnswer", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CorrectAnswer"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Weightage", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Weightage"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertPOSHQuestion(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertPOSHQuestion");
            SQLHelper.AddParamToSQLCmd(cmd, "@Question", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Question"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Section", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Section"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer1", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer1"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer2", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer2"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer3", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer3"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer4", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer4"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CorrectAnswer", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CorrectAnswer"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Weightage", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Weightage"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllPOSHQuestion()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllPOSHQuestion");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPOSHQuestionSection()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPOSHQuestionSection");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPOSHDataForSummary_MonthWise(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPOSHDataForSummary_MonthWise");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getAllCredit_UWQuestion()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllUWQuestionBy");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCredit_UWCheckQuestionPaper(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetUWCheckQuestionPaper]");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EndDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCredit_UWAnswerSheetHeader(int ApplicationID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UWUserQuePaperDetailsForCheckTest");
            SQLHelper.AddParamToSQLCmd(cmd, "@ApplicationID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ApplicationID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCredit_UWAnswerSheet(int ApplicationID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_UWCheckQuestionPape]");
            SQLHelper.AddParamToSQLCmd(cmd, "@ApplicationID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ApplicationID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCredit_UWCandidateForSendMail(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetUWCheckQuestionPaperReportToAssign]");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EndDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getAllServicing_UWQuestion()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllUWQuestionBy_Servicing");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertServicingUWQuestion(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUWQuestion_Servicing");
            SQLHelper.AddParamToSQLCmd(cmd, "@Question", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Question"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer1", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer1"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer2", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer2"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer3", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer3"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer4", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Answer4"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CorrectAnswer", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CorrectAnswer"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Weightage", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Weightage"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable Getservicing_UWCheckQuestionPaper(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetUWCheckQuestionPaper_Servicing]");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EndDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetServicing_UWAnswerSheetHeader(int ApplicationID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UWUserQuePaperDetailsForCheckTest_Servicing");
            SQLHelper.AddParamToSQLCmd(cmd, "@ApplicationID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ApplicationID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetServicing_UWAnswerSheet(int ApplicationID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_UWCheckQuestionPaper_Servicing]");
            SQLHelper.AddParamToSQLCmd(cmd, "@ApplicationID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ApplicationID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetServicing_UWCandidateForSendMail(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetUWCheckQuestionPaperReportToAssign_Servicing]");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EndDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDropOutinfo(int EmployeeId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDropOutInfobyEmpId");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, EmployeeId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAbscondedEmployeesFollowup(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAbscondedEmployees");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertAbscondedEmpsFollowUp(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAbscondedEmpsFollowUp");
            SQLHelper.AddParamToSQLCmd(cmd, "@ResignationID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ResignationID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllNewJoineeReport(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllNewJoineeReport");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllNewJoineeReport_Revised(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllNewJoineeReport_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAttritionReport(string Month, string Year, int DomainID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDatewiseAttritionReport_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, DomainID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet GetAttritionReport_ds(string Month, string Year, int DomainID, int EmpID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDatewiseAttritionReport");// usp_GetDatewiseAttritionReport_ICG1
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, DomainID);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmpID);
            DataSet ds = SQLHelper.ExecuteDataSetCmd(cmd);
            return ds;
        }

        public DataTable GetAllInvoiceHeaders(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllCCInvoiceHeaders");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllInvoiceHeadersSummary(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCreditCardSummaryforInvoice");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetHeaderwiseDetails(int HeaderID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetInvoiceHeaderwiseDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@HeaderID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, HeaderID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetHeaderwiseDetailsRevised(int HeaderID, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetInvoiceHeaderwiseDetailsRevised");
            SQLHelper.AddParamToSQLCmd(cmd, "@HeaderID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, HeaderID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCCDataForVerification(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCCDataForVerification");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable DownloadInvoice(int HeaderID, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAttachmentforInvoice");
            SQLHelper.AddParamToSQLCmd(cmd, "@HeaderID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, HeaderID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertCCInvoiceMonthlyData(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertInvoiceMonthlyData");
            SQLHelper.AddParamToSQLCmd(cmd, "@HeaderID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["HeaderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InvoiceNo", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["InvoiceNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Difference", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Difference"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Utilization", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Utilization"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InvoiceAmount", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["InvoiceAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetCanopyData(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCanopyData");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCanopyDataDetails(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCanopyLoanandTaskkDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCanopyTask(int LoanID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCanopyTaskDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, LoanID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertCCDetails(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertCCUserDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@HeaderID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["HeaderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailAddress", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["EmailAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OtherUser", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["OtherUser"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@StartDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["EffectiveDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertCCInvoiceHeaders(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertCCInvoiceHeaders");
            SQLHelper.AddParamToSQLCmd(cmd, "@Header", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Header"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Domain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Product", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Product"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subscription", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Subscription"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CostType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["CostType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PayTo", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["PayTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EffectiveDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["EffectiveDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContQuantity", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["ContQuantity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContPerUnitCost", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, htParam["ContPerUnitCost"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ChargeableAmt", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, htParam["ChargeableAmt"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int DisabledCCHeader(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_DisabledCCHeader");
            SQLHelper.AddParamToSQLCmd(cmd, "@HeaderID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["HeaderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsDisable", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["IsDisable"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DisabledRemark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["DisabledRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DisabledBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htParam["DisabledBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllCCInvoiceHeaders_ByHeaderID(int HeaderID, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllCCInvoiceHeaders_ByHeaderID");
            SQLHelper.AddParamToSQLCmd(cmd, "@HeaderID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, HeaderID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int RemoveCCUser(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_RemoveCCUser");
            SQLHelper.AddParamToSQLCmd(cmd, "@InvID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["InvID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EffectiveDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["EffectiveDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int GetCCInvoiceImportDetails(string Month, string Year, string Description, decimal Amount, string CardNumber, string TransactionDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCCInvoieDetails");//usp_GetCCInvoieDetails_ForMDKDetails
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Description);
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, Amount);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@TransactionDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, TransactionDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@CardNumber", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, CardNumber);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertCreditCardMaster(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertCC_master");
            SQLHelper.AddParamToSQLCmd(cmd, "@CardName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CardName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CardNo", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CardNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingFrom", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["BillingFrom"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingTo", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["BillingTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllCC_Master()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllCC_Master");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int EditCreditCardMaster(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_EditCreditCardMaster");
            SQLHelper.AddParamToSQLCmd(cmd, "@MasterID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["MasterID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CardName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CardName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CardNo", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["CardNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingFrom", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["BillingFrom"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingTo", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["BillingTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertCreditCardHeaderMaster(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InserCreditcardHeaderMaster");
            SQLHelper.AddParamToSQLCmd(cmd, "@Header", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Header"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int EditCreditCardHeaderMaster(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_EditCreditcardHeaderMaster");
            SQLHelper.AddParamToSQLCmd(cmd, "@HeaderID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["HeaderID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Header", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Header"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllCreditCardHeaderMaster()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCreditCardHeaderMaster");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllCreditCardInvoice()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getCreditCardInvoice");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllCreditCardInvoice_cancel(int CardId, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getCreditCardInvoice_cancel");
            SQLHelper.AddParamToSQLCmd(cmd, "@CardId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, CardId);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllCreditCards()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllCreditCards");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertCreditCardInvoice(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_AddCreditCardInvoice");
            SQLHelper.AddParamToSQLCmd(cmd, "@CardID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["CardID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UsedFor", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["UsedFor"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UsedBy", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["UsedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InvoiceNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["InvoiceNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InvoiceDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["InvoiceDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, htParam["Amount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Currency", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Currency"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PaidDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["PaidDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int CancelCreditCardInvoice(int InvoiceID, decimal CreditAmount, decimal CancelAmount, string CancelRemark, string Attachment)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CancelCreditCardInvoice");
            SQLHelper.AddParamToSQLCmd(cmd, "@InvoiceID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, InvoiceID);
            SQLHelper.AddParamToSQLCmd(cmd, "@CreditAmount", System.Data.SqlDbType.Decimal, 100, System.Data.ParameterDirection.Input, CreditAmount);
            SQLHelper.AddParamToSQLCmd(cmd, "@CancelAmount", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, CancelAmount);
            SQLHelper.AddParamToSQLCmd(cmd, "@CancelRemark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, CancelRemark);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Attachment);
            SQLHelper.AddParamToSQLCmd(cmd, "@CancelBy", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetStatementDetailsByID(int VerID, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetStatementDetailsByID");
            SQLHelper.AddParamToSQLCmd(cmd, "@VerID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, VerID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertAccountRemarkforCC(int VerID, string Remark, string PaidDate, string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAccountRemarkforCC");
            SQLHelper.AddParamToSQLCmd(cmd, "@VerID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, VerID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@PaidDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, PaidDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int FinalVerifyCCStatement(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_VerifyCCStatement");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Year);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetTotalAbscondingEmployees(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTotalAbscondingReportMOnthwise");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetTotalLeaves(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTotalLeavesReportMOnthwise");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet GetTotalLeaves_Revised(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTotalLeavesReportMOnthwise_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Year);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public DataTable GetKYCInfoByEmployee(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetKYCInfoByEmployee");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertEmployeeInfo_Old(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CreateProfile");
            SQLHelper.AddParamToSQLCmd(cmd, "@Name", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Name"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Gender", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["GenderOld"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Phone", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["CellNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Address", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["PresentAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PerAdd", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["PermanentAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EMail", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["EmailID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Shift", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ShiftOld"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DOB", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["DateOfBirth"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DOJ", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["JoiningDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@COT", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["CutOffTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Salary", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Salary"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@jobtime", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["WorkingHoursOld"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, "PER");
            SQLHelper.AddParamToSQLCmd(cmd, "@WH", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["WeeklyHolidayName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@branch", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["WorkingBranchName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DEPT", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DepartmentName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@desig", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["OldDesignationName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Projectno", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ProjectName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Qual", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Qualification"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Log_Late", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, "Allow Late Mark");
            SQLHelper.AddParamToSQLCmd(cmd, "@Log_Extra", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, "No Extra Hours");
            SQLHelper.AddParamToSQLCmd(cmd, "@PMCode", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["PMCode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Night_Bonus", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, "0");
            SQLHelper.AddParamToSQLCmd(cmd, "@Incentive", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, "0");
            SQLHelper.AddParamToSQLCmd(cmd, "@acc_no", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["BankAccNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ho5", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["WorkingBranchName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PseudoName", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, "0");
            SQLHelper.AddParamToSQLCmd(cmd, "@OfficeEmail", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["OfficialEmailID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BGroup", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["BloodGroup"]);
            //SQLHelper.AddParamToSQLCmd(cmd, "@AadharNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["AadharNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PAN", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["PAN"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ESICNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ESICNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PFNO", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["PFNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Period", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Period"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DOA", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["DateOfAgreement"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DOAE", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["AgreementExpiraryDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DOBN", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["DateOfBond"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DOBNE", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["BondExpiraryDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            try
            {
                SQLHelper.ExecuteNonQueryCmd_Sal(cmd);
            }

            catch (Exception)
            {

            }

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetDomainHeadInfo(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDomainHeadInfo");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 50, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable getEmailConfigrationInfo(string EmailType)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetEmailConfigration");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailType", System.Data.SqlDbType.NVarChar, 10000, System.Data.ParameterDirection.Input, EmailType);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertEmployeeLogInHistory(string Code, bool Status, string Remark, int AddedBy, string LeaveStatus)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertEmployeeLogInHistory");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, Status);
            SQLHelper.AddParamToSQLCmd(cmd, "@LeavesStatus", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, LeaveStatus);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetLocationHeadInfo(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLocationHeadDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 50, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPrimaryProject(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPrimaryProject");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 50, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable EmployeeDetailsByCode(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllEmployeeInformationByCode");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllAttendanceCorrectionRequest(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllAttendanceCorrectionRequest");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllAttendanceCorrectionRequestForPM(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllAttendanceRequestsForPM]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllFamilyInfo(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllFamilyInfo]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public int ResetUserPassword(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ResetUserPassword");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetAllAppreciationDisciplinary()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllAppreciationDisciplinary");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertAppreciationDisciplinary(string Type, string Title, string Description, string DesignDescription, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAppreciationDisciplinary");
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.VarChar, 100, System.Data.ParameterDirection.Input, Type);
            SQLHelper.AddParamToSQLCmd(cmd, "@Title", System.Data.SqlDbType.VarChar, 5000, System.Data.ParameterDirection.Input, Title);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.VarChar, 5000, System.Data.ParameterDirection.Input, Description);
            SQLHelper.AddParamToSQLCmd(cmd, "@DesignDescription", System.Data.SqlDbType.VarChar, 5000, System.Data.ParameterDirection.Input, DesignDescription);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertFamilyInfo(Hashtable htFamilyInsert)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertFamilyInfo");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htFamilyInsert["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Name", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htFamilyInsert["Name"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Relation", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htFamilyInsert["Relation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Age", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htFamilyInsert["Age"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Profession", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htFamilyInsert["Profession"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htFamilyInsert["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int deleteFamilyInfo(int FamilyInfoID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_DeletefamilyInfo");
            SQLHelper.AddParamToSQLCmd(cmd, "@FamilyInfoID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, FamilyInfoID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;

        }

        public DataTable GetAllTicket(int RequestBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllTickets");
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestBy", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, RequestBy);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDealsFromProjectTracking_Revised1()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllDealsFromTracking_Revised1]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDealsFromProjectTracking()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllDealsFromTracking_Sec]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUWProjects()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllUWProjects_1]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetReportData()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllSecuritizationRel]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetSecuritizationByID(int SecureID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetSecuritizationDetailsByID]");
            SQLHelper.AddParamToSQLCmd(cmd, "@SecureID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, SecureID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllSentBilling()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllSecuritizationBillingSent]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDealNumber(int ProjectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetDealNoForBilling]");
            SQLHelper.AddParamToSQLCmd(cmd, "@projectId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertSecuritizationRelLetterBilling(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertSecuritizationRelianceLetterBilling");// usp_InsertFeedbackForNewOrder_ForClientFeedback// usp_InsertFeedbackForNewOrder
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["BillingPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["ProjectId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanCount", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["LoanCount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfHoursLoans", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["NoOfHoursLoans"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssociateRemark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["AssociateRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["BillingType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertSecuritizationRelLetter(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertSecuritizationRelianceLetter");// usp_InsertFeedbackForNewOrder_ForClientFeedback// usp_InsertFeedbackForNewOrder
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["Projectid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ClientName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientDealName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ClientDealName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OriginalRequestDate", System.Data.SqlDbType.Date, 100, System.Data.ParameterDirection.Input, htParam["OriginalRequestDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanCount", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["LoanCount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["TaskName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestedDate", System.Data.SqlDbType.Date, 100, System.Data.ParameterDirection.Input, htParam["RequestedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SLADeliveryDate", System.Data.SqlDbType.Date, 100, System.Data.ParameterDirection.Input, htParam["SLADeliveryDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ActualDeliveredDate", System.Data.SqlDbType.Date, 100, System.Data.ParameterDirection.Input, htParam["ActualDeliveredDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SLADeliveryDays", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["SLADeliveryDays"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RLSigned", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["RLSigned"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingHours", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["BillingHours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientNameAddress", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ClientNameAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RecipientNameAddress", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["RecipientNameAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AgencyNameAddress", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["AgencyNameAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }


        public int InsertProjectInfo(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertProjectInfo");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Company", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Company"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContactPerson", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ContactPerson"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContactNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ContactNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailID", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["EmailID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Website", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Website"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Address", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Address"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }


        public int UpdateSecuritizationRelLetter(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateSecuritizationRelianceLetter");//
            SQLHelper.AddParamToSQLCmd(cmd, "@SecureID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["SecureID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["Projectid"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientDealName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ClientDealName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OriginalDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["OriginalRequestDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanCount", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["LoanCount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TaskName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["TaskName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RequestedDate", System.Data.SqlDbType.Date, 100, System.Data.ParameterDirection.Input, htParam["RequestedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SLADeliveryDate", System.Data.SqlDbType.Date, 100, System.Data.ParameterDirection.Input, htParam["SLADeliveryDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ActualDeliveredDate", System.Data.SqlDbType.Date, 100, System.Data.ParameterDirection.Input, htParam["ActualDeliveredDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SLADeliveryDays", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["SLADeliveryDays"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RLSigned", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["RLSigned"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingHours", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["BillingHours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClientNameAddress", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ClientNameAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RecipientNameAddress", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["RecipientNameAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AgencyNameAddress", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["AgencyNameAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertSecuritizationRelLetterBilling_Revised(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InserRevisedSecBilling");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["BillingPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BllingAddedDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["BllingAddedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfLoans", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["NoOfLoans"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoofHours", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["NoofHours"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataSet GetDealDetails(string DealNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetDealWiseSecuritizationDetails]");
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }

        public int InsertResearchBilling_NewERP(int ProjectID, string BillingPeriod, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertResearchBilling_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, BillingPeriod);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd_UWBilling(cmd); 

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertRebuttalBilling_NewERP(int ProjectID, string BillingPeriod, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertRebuttalBilling_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, BillingPeriod);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd_UWBilling(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int VeriftyData(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_PreviousBilledEntriesandExistance");// usp_InsertFeedbackForNewOrder_ForClientFeedback// usp_InsertFeedbackForNewOrder
            SQLHelper.AddParamToSQLCmd(cmd, "@SecureID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["SecureID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNumber", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNumber", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LoanNo1"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNumber2", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["LoanNo2"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReceivedDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ReceivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeliveredDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DeliveredDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Source", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Source"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllDealNumberForSentToBilling(int ProjectId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetDealNoForBillingForBilling]");
            SQLHelper.AddParamToSQLCmd(cmd, "@projectId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectId);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetGridData_Research(int ProjectId, string DealNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetSentToBillingDetails_Research]");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectId);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_UWBilling(cmd);
            return dt;
        }

        public DataTable GetGridData_Rebuttal(int ProjectId, string DealNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetSentToBillingDetails_Rebuttal]");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, ProjectId);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_UWBilling(cmd);
            return dt;
        }

        public DataTable GetExistingLoanList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetSecRelBilledLoanList]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int ClearLoanList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ClearTempSecLoanList");// usp_InsertFeedbackForNewOrder_ForClientFeedback// usp_InsertFeedbackForNewOrder
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllDealsFromProjectTracking_Billing()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllDealsFromTracking_Sec]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable VerifySecRelLoans()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_VerifySecRelLoans]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int GetprojectId(string ProjectName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetProjectId_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectName", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, ProjectName);
            int ProjectId = Convert.ToInt32(SQLHelper.ExecuteScalarCmd(cmd));
            return ProjectId;
        }

        public DataTable GetRevisedBilling(int ProjectID, string DealNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_getSecuritizationBilling_Revised]");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, DealNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UpdateBillingRevised(int BillingID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateBillingSecuritization_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, BillingID);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAllUsersUnderPM(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllHierarchicalData]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetERpCutOffTimeExceptions(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetERPCutOffTimeExceptions]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceReport(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformance");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceProdDetails(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformanceDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceFeedbackDetails(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserFeedbackDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceAttendanceDetails(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserAttendanceDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@PM", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceAttendanceDetails_KP(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserAttendanceDetails_KP");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@PM", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPoshQuestions()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllPOSHQuestions");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetExistanceofPoshTest()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckforExistingPoshTest");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPoshTestResult()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPoshTestResult");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertPoshAnswer(int EmployeeId, int QuestionID, string Answer)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertPoshAnswerSet");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeId);
            SQLHelper.AddParamToSQLCmd(cmd, "@QuestionID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, QuestionID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Answer", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, Answer);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int GetPostTestStatus()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPoshTestStatus_WebPortal");/*usp_GetPoshTestStatus*/
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int SetPoshRetest()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ResetPoshTest");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int TruncatetempSecRelLoansList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_TruncatetempSecRelLoansList");
            SQLHelper.ExecuteNonQueryCmd(cmd);
            return 1;
        }

        public DataTable getSchedule1Data(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getEmployeesRolesAndResponsibilities");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAprreciationTitle(string AppreciationDiscplinary)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAprreciationTitle");
            SQLHelper.AddParamToSQLCmd(cmd, "@AppreciationDiscplinary", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, AppreciationDiscplinary);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAprreciationDescription(string AppreciationDiscplinary, string Title)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAprreciationDescription");
            SQLHelper.AddParamToSQLCmd(cmd, "@AppreciationDiscplinary", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, AppreciationDiscplinary);
            SQLHelper.AddParamToSQLCmd(cmd, "@Title", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, Title);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLeaveDetailsByID(int LeaveID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLeaveDetailsByID");
            SQLHelper.AddParamToSQLCmd(cmd, "@LeaveID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, LeaveID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UpdateEmployeeLeaves(Hashtable htExtend)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateEmployeeLeaves");
            SQLHelper.AddParamToSQLCmd(cmd, "@LeaveID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htExtend["LeaveID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LeaveStatus", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htExtend["LeaveStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htExtend["FromDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htExtend["ToDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Days", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htExtend["Days"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htExtend["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UpdatedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htExtend["UpdatedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetExtendedAndShortenLeavesDetails(int LeaveID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetExtendedAndShortenLeavesDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@LeaveID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, LeaveID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllStandardReasonsForPM()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllStandardReasonsForPM_Revised1]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllDateForAttendance(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllDateByCode");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAttendanceCorrectionByID(int AttendanceCorrectRequestID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAttendanceCorrectionByID");
            SQLHelper.AddParamToSQLCmd(cmd, "@AttendanceCorrectRequestID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AttendanceCorrectRequestID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertAttendanceCorrectRequestByPM(Hashtable htAttendance)
        {

            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAttendanceCorrectRequestByPM");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["InDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InTime", System.Data.SqlDbType.NVarChar, 8, System.Data.ParameterDirection.Input, htAttendance["InTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OutDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["OutDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OutTime", System.Data.SqlDbType.NVarChar, 8, System.Data.ParameterDirection.Input, htAttendance["OutTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakOutDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["BreakOutDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakOutTime", System.Data.SqlDbType.NVarChar, 8, System.Data.ParameterDirection.Input, htAttendance["BreakOutTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakInDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["BreakInDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakInTime", System.Data.SqlDbType.NVarChar, 8, System.Data.ParameterDirection.Input, htAttendance["BreakInTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reason", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, htAttendance["Reason"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReasonType", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, htAttendance["ReasonType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PrevDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["PrevDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IpAddress", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htAttendance["IpAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htAttendance["ApprovedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int UpdateAttendanceCorrection(Hashtable htUpdateAttendance)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateAttendanceCorrection");
            SQLHelper.AddParamToSQLCmd(cmd, "@AttendanceCorrectRequestID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htUpdateAttendance["AttendanceCorrectRequestID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htUpdateAttendance["InDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InTime", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htUpdateAttendance["InTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OutDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htUpdateAttendance["OutDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@OutTime", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htUpdateAttendance["OutTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakOutDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htUpdateAttendance["BreakOutDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakOutTime", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htUpdateAttendance["BreakOutTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakInDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htUpdateAttendance["BreakInDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BreakInTime", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htUpdateAttendance["BreakInTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, htUpdateAttendance["RequestRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UpdationIP", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htUpdateAttendance["UpdationIP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@UpdatedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htUpdateAttendance["UpdatedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsApproved", System.Data.SqlDbType.Bit, 1, System.Data.ParameterDirection.Input, htUpdateAttendance["IsApproved"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertSetAppreciationDisplinaryAction(int AppreciationDisciplinaryID, int EmployeeID, string Type, string Title, string Description, string Remark, string Subject, int AddedBy, string Period)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertSetAppreciationDisplinaryAction");
            SQLHelper.AddParamToSQLCmd(cmd, "@AppreciationDisciplinaryID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AppreciationDisciplinaryID);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Description);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, Type);
            SQLHelper.AddParamToSQLCmd(cmd, "@Title", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Title);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subject", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Subject);
            SQLHelper.AddParamToSQLCmd(cmd, "@Period", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Period);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAppreciationDisplinaryStatus(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAppreciationDisplinaryStatus");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPoshTestReport(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getPoshTestResultReport");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPoshAnswerSheet(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPoshAnswerSheet");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllApprerciationandWarningReport()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllAppreciationDescRecords");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable usp_GetAllAppreciationDescRecords_UserWise()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllAppreciationDescRecords_UserWise");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllApprerciationandWarningByType(int EmployeeID, string Type)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllAppWarningbyType");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertRnRSnaps(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_InsertRnRSnaps]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Quarter", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Quarter"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Location", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["Location"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Snaps", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Snaps"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        #region Log Imported Feedback

        public DataTable GetAllFeedbackByDateRange_NewFormat(string FromDate, string ToDate, string SubDomain)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllFeedbackByDateRange_NewFormat");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@SubDomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, SubDomain);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetCreditAndServicingFeedbackHistory(int FeedbackID, string SubDomain)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetCreditAndServicingFeedbackHistory");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, FeedbackID);
            SQLHelper.AddParamToSQLCmd(cmd, "@SubDomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, SubDomain);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetFeedbackDetailsByID_NewFormat(int FeedbackID, string Subdomain)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetFeedbackDetailsByID_NewFormat_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, FeedbackID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", System.Data.SqlDbType.NVarChar, 0, System.Data.ParameterDirection.Input, Subdomain);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);

            if (dt != null && dt.Rows.Count > 0)
            {
                SqlCommand statusCmd = SQLHelper.GetCommand(System.Data.CommandType.Text,
                    "IF @Subdomain IN (N'C', N'Credit') " +
                    "SELECT ISNULL([Finding Status], N'') FROM dbo.ImportedFeedbacks WHERE FeedbackID = @FeedbackID; " +
                    "ELSE " +
                    "SELECT ISNULL([Finding Status], N'') FROM dbo.ImportedFeedbacks_Servicing WHERE FeedbackID = @FeedbackID;");
                SQLHelper.AddParamToSQLCmd(statusCmd, "@FeedbackID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, FeedbackID);
                SQLHelper.AddParamToSQLCmd(statusCmd, "@Subdomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Subdomain);

                object feedbackStatus = SQLHelper.ExecuteScalarCmd(statusCmd);
                if (!dt.Columns.Contains("FeedbackStatus"))
                    dt.Columns.Add("FeedbackStatus", typeof(string));

                dt.Rows[0]["FeedbackStatus"] = feedbackStatus == null || feedbackStatus == DBNull.Value
                    ? string.Empty
                    : feedbackStatus.ToString();
            }

            return dt;
        }

        public DataTable GetProductionDataForUpdateFeedback_NewFormat(string LoanNo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetProductionDataForUpdateFeedback_NewFormat");
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanNo", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, LoanNo);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UpdateInfinityImportedFeedback_NewERP(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateInfinityImportedFeedback_NewERP_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["FeedbackID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Category", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Category"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subcategory", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Subcategory"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorField", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["ErrorField"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Screen", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Screen"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ErrorType", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["ErrorType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Finding", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Finding"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackType", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["FeedbackType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Severity", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Severity"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@RCA", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["RCA"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Source", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Source"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackReceivedDate", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["FeedbackReceivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsDisplayInERP", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["IsDisplayInERP"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Subdomain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackStatus", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["FeedbackStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();

            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InsertInfinityImportedFeedback_NewERP(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertInfinityImportedFeedback_NewERP_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["FeedbackID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Source", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Source"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProdID", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["ProdID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Subdomain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }


        public int UpdateFinalStatusOfImporetdFeedback(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateFinalStatusOfImporetdFeedback");
            SQLHelper.AddParamToSQLCmd(cmd, "@FeedbackID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["FeedbackID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FinalStatus", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["FinalStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FinalComments", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["FinalComments"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Subdomain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FinalStatusUpdatedBy", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["FinalStatusUpdatedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }


        #endregion

        public int CheckifProjectExists(string ProjectName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckProjectExists");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectName", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, ProjectName);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int CheckifpsuedonameExists(string EmpName)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckPsuedonameExists");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpName", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, EmpName);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetValidatedFeedbacks()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getValidateimportedfeedbacks");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable ITCostReportYearly(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ITCostReportYearly");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable ITCostReportYearlyDetail(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ITCostReportYearly_Detail");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable ITCostReportYearly_CreditCardwise(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ITCostReportYearly_CreditCardwise");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable ITCostReportYearly_CreditCardDeviation(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ITCostReportYearly_CreditCardDeviation");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllEmployeeInformationForVerification()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllEmployeeInformationForVerfication_Revised");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetEmpAllDocsForZip(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmpAllDocsForZip");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int UploadEmployeeDocument(Hashtable genrateInfo)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "UploadEmployeeDocument");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, genrateInfo["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DocumentType", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, genrateInfo["DocumentType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DocumentPath", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, genrateInfo["DocumentPath"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Addedby", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, genrateInfo["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertUpdateFeedbacks_Servicing()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUpdateServicingFeedbacks");
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertUpdateFeedbacks_Credit()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUpdateCreditFeedbacks");
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetValidatedFeedbacks_Servicing()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getValidateimportedfeedbacks_Revised_Servicing");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetValidatedFeedbacks_Credit()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getValidateimportedfeedbacks_Revised_Credit");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetESIPFInformationForKYC(string Month, int Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetESIPFInformationForKYC"); //usp_GetESIPFInformationForKYC_OfAllEmployee
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.Int, 20, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable SyncInternalFeedbacks(string FromDate, string ToDate, string Subdomain)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_SyncInternalFeedbacks");
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Subdomain);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertSyncedInternalFeedbacks(string FromDate, string ToDate, string Subdomain)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertSyncedInternalFeedbacks");
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Subdomain);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertERPCutOffTimeException(string Code, string FromDate, string ToDate, string Reason)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertERPCutoffTimeExceptions");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@Reason", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Reason);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertEmployeeKYC(Hashtable htKYC)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertEmployeeKYC");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htKYC["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FullName", System.Data.SqlDbType.NVarChar, 150, System.Data.ParameterDirection.Input, htKYC["FullName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Gender", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htKYC["Gender"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MStatus", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htKYC["MStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FahterName", System.Data.SqlDbType.NVarChar, 150, System.Data.ParameterDirection.Input, htKYC["FahterName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DOJ", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, htKYC["DOJ"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DOB", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, htKYC["DOB"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DocName", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htKYC["DocName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DocNumber", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htKYC["DocNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IFSCCode", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htKYC["IFSCCode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ExpDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, htKYC["ExpDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Qual", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htKYC["Qual"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PH", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htKYC["PH"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PHC", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htKYC["PHC"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Nominee", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, htKYC["Nominee"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NAddress", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htKYC["NAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NRelation", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htKYC["NRelation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NDOB", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, htKYC["NDOB"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContactNo", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htKYC["ContactNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PresentAddress", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htKYC["PresentAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PermanentAddress", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htKYC["PermanentAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankName", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Input, htKYC["BankName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BankAccNO", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htKYC["BankAccNO"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PAN", System.Data.SqlDbType.NVarChar, 150, System.Data.ParameterDirection.Input, htKYC["PAN"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AadharCardNo", System.Data.SqlDbType.NVarChar, 150, System.Data.ParameterDirection.Input, htKYC["AadharCardNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NContactNo", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htKYC["NContactNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MarriageDate", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, htKYC["MarriageDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htKYC["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsAadharCard", System.Data.SqlDbType.Bit, 1, System.Data.ParameterDirection.Input, htKYC["IsAadharCard"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsPan", System.Data.SqlDbType.Bit, 1, System.Data.ParameterDirection.Input, htKYC["IsPan"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetSecurutizationSummary_Sec(string Month, string year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetSucuritizationSummary_Sec");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetSecurutizationSummary_RelLetter(string Month, string year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetSucuritizationSummary_RelLetter");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetReportingManagerList()//, string PaperSet)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getReportingManagerList");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataSet GetReportingManagerWiseAttrition(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetPMWiseAttrition");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["FromDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ToDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PMID", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, htParam["PMID"]);
            DataSet dt = SQLHelper.ExecuteDataSetCmd(cmd);
            return dt;
        }


        public DataTable GetSegmentwiseManpower()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetSegmentwiseManpower");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetSegmentwiseManpowerList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getsegmentwisemanpowerList");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetColumnsList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[us_GetColumnsList]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetFiltersList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[us_GetFiltersList]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetGroupByList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[us_GetGroupByList]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllEmployeeWorkedHoliday(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllEmployeeWorkedHoliday_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserWorkedHolidays(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmployeeWorkedHoliday");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int ApprovedEmpWorkHoliday(string UserCode, string Remark, string Date, int ApprovedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ApprovedEmpWorkHoliday");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, UserCode);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, Date);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ApprovedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetLeaveDetails(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLeaveDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLeaveReport(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLeaveReport_NewERP");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetLeaveDetails_ByCode(string FromDate, string ToDate, string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLeaveDetails_ByCode");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserAllCompOff(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUserAllCompOff");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllWorkedHolidayDates(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetAllWorkedHolidayDates");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserCompOff_forApproval(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetUserCompOff_forApproval");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertUserCompOff(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUserCompOff");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WorkedHolidayDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["WorkedHolidayDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompOffDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["CompOffDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsApproved", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["IsApproved"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ApprovedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedDate", System.Data.SqlDbType.DateTime, 100, System.Data.ParameterDirection.Input, htParam["ApprovedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovalRemark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["ApprovalRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int ApproveRejectCompOff(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ApproveRejectCompOff");
            SQLHelper.AddParamToSQLCmd(cmd, "@CompOffID", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["CompOffDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsApproved", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["IsApproved"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["ApprovedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedDate", System.Data.SqlDbType.DateTime, 100, System.Data.ParameterDirection.Input, htParam["ApprovedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int InsertAgreementVersionHistory(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAgreementVersionHistory");
            SQLHelper.AddParamToSQLCmd(cmd, "@Version", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Version"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VersionDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, htParam["VersionDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AgreementType", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["AgreementType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MinServPeriod", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["MinServPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClauseNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ClauseNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Clause", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Clause"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }


        public int InsertAgreementTypeHistory(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertAgreementTypeHistory");
            SQLHelper.AddParamToSQLCmd(cmd, "@Version", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Version"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VersionDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, htParam["VersionDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AgreementType", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["AgreementType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MinServPeriod", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["MinServPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }


        public int UpdateAgreementVersionHistory(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateAgreementVersionHistory");
            SQLHelper.AddParamToSQLCmd(cmd, "@AgrChangeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AgrChangeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ClauseNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ClauseNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Clause", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Clause"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetAgreementVersionHistory()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAgreementVersionHistory");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAgreementTypeHistory()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAgreemnetType_History");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAgreementVersionHistory_Report()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAgreementVersionHistory_Report");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAgreemnetTypeHistory_Report()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAgreemnetTypeHistory");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetEmployeeComment()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmployeeComments");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertEmployeeComment(Hashtable htComment)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertEmployeeComment");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htComment["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subject", System.Data.SqlDbType.VarChar, 5000, System.Data.ParameterDirection.Input, htComment["Subject"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Comment", System.Data.SqlDbType.VarChar, 5000, System.Data.ParameterDirection.Input, htComment["Comment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.VarChar, 5000, System.Data.ParameterDirection.Input, htComment["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htComment["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable Getunapprovedleavecount(int DomainID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetUnapprovedLeaveCount]");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, DomainID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetEmployeeCommentByID(int CommentID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmployeeCommentsByCommentID");
            SQLHelper.AddParamToSQLCmd(cmd, "@CommentID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, CommentID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetHRInvoice()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetHRInvoice");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertCompanyInvoice(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertHRInvoice");

            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Companyname", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["CompanyName"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@Location", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Location"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Fromdate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Todate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Status", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Vendorname", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["VendorName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InvoiceNo", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Invoiceno"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AccountNo", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["AccountNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Duedate", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Duedate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillAmount", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["BillAMount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssignToDept", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["AssignTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@circuitNo", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["CircuitId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FileUploadPath", System.Data.SqlDbType.NVarChar, 1000, System.Data.ParameterDirection.Input, htparam["FileUploadPath"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssignUser", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AssignUser"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Category", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Category"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PAN", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["PAN"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@GSTNO", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["GSTNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@HRInvoiceType", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["InvoiceType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorConditions", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htparam["VendorConditions"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PaymentConditions", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htparam["PaymentConditions"]);

            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateCompanyInvoice(Hashtable htparam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_updateInvoicedetails");

            SQLHelper.AddParamToSQLCmd(cmd, "@companyname", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["CompanyName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InvoiceId", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["InvoiceId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@location", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Location"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Fromdate", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Fromdate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Todate", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Todate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@status", System.Data.SqlDbType.VarChar, 2000, System.Data.ParameterDirection.Input, htparam["Status"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@vendorname", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["VendorName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@invoiceno", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Invoiceno"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@accno", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["AccountNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@duedate", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Duedate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillAmt", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["BillAMount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssignTo", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["AssignTo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Remark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssignUser", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, htparam["AssignUser"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Category", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["Category"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@circuitno", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["CircuitId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PAN", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["PAN"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@GSTNo", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["GSTNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InvoiceType", System.Data.SqlDbType.NVarChar, 2000, System.Data.ParameterDirection.Input, htparam["InvoiceType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int InsertFestiveData(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertFestiveData");
            SQLHelper.AddParamToSQLCmd(cmd, "@Title", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, htParam["Title"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MessageHtml", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["MessageHtml"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ImagePath", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["ImagePath"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@StartDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, htParam["StartDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EndDate", System.Data.SqlDbType.NVarChar, 15, System.Data.ParameterDirection.Input, htParam["EndDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsPopup", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["IsPopup"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsActive", System.Data.SqlDbType.Bit, 10, System.Data.ParameterDirection.Input, htParam["IsActive"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CreatedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Branch", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Branch"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Designation", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Designation"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Department", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Department"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Users", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Users"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Gender", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Gender"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public int DeleteFestivalImages(int FestivalId, int DeletedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_DeleteFestivalImages");
            SQLHelper.AddParamToSQLCmd(cmd, "@FestivalId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, FestivalId);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeletedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, DeletedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetFestivalMaster()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetFestivalMaster");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDepartmentForInvoice()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDepartmentforInvoice");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int CheckERPLoginExceptionExistance()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckERPLoginExceptionExists");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 50, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=User Not Exist, 0=Invalid Password, >0=Success

        }

        public string ValidateLogin(Hashtable htAttendance)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Validate_Login");
            SQLHelper.AddParamToSQLCmd(cmd, "@UCode", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ULDate", System.Data.SqlDbType.DateTime, 100, System.Data.ParameterDirection.Input, htAttendance["InTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MachineIP", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htAttendance["IpAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReMsg", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Output, null);

            SQLHelper.ExecuteNonQueryCmd_Sal(cmd);

            string ReturnValue = Convert.ToString(cmd.Parameters["@ReMsg"].Value);
            return ReturnValue;
        }

        public string ValidateLogout(Hashtable htAttendance)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Validate_LogOut");
            SQLHelper.AddParamToSQLCmd(cmd, "@UCode", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ULDate", System.Data.SqlDbType.DateTime, 100, System.Data.ParameterDirection.Input, htAttendance["InTime"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MachineIP", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htAttendance["IpAddress"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReMsg", System.Data.SqlDbType.NVarChar, 300, System.Data.ParameterDirection.Output, null);

            SQLHelper.ExecuteNonQueryCmd_Sal(cmd);

            string ReturnValue = Convert.ToString(cmd.Parameters["@ReMsg"].Value);
            return ReturnValue;
        }

        public void AdjustHolidays(Hashtable htAttendance)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "pro_adjust_holiday");
            SQLHelper.AddParamToSQLCmd(cmd, "@InCode", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htAttendance["Code"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@InDate", System.Data.SqlDbType.DateTime, 100, System.Data.ParameterDirection.Input, DateTime.Now.AddDays(-1));
            SQLHelper.AddParamToSQLCmd(cmd, "@SalDet", System.Data.SqlDbType.Int, 100, System.Data.ParameterDirection.Input, 1);

            SQLHelper.ExecuteNonQueryCmd_Sal(cmd);


        }

        public DataTable GetDashboardPerformanceDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetSecondTabDetailsForIncrementProposal_ForDashboard");
            SQLHelper.AddParamToSQLCmd(cmd, "@Employees", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, (HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetDetailedAttendancePercentageForDashboard(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAttendancePercentageWithDetails_Final_MOnthwise_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@UserCode", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["UserCode"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["FromDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["ToDate"]);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertBirthdayMessage(string Message, int AddedBy, string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertBirthdayMessageFromUser");
            SQLHelper.AddParamToSQLCmd(cmd, "@Message", System.Data.SqlDbType.VarChar, 4000, System.Data.ParameterDirection.Input, Message);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetTodaysBirthday()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTodayBirthday");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllMasters()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllMasters_Revised");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public void InsertMenu(MenuModel menu)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "InsertMenu_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@MenuName", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, menu.MenuName);
            SQLHelper.AddParamToSQLCmd(cmd, "@ParentMenuId", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, menu.ParentMenuId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Url", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, menu.Url);
            //SQLHelper.AddParamToSQLCmd(cmd, "@SortOrder", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, menu.SortOrder);

            SQLHelper.ExecuteNonQueryCmd(cmd);

        }

        public int InsertEmpHoliday(int EmployeeID, string Date, string DepartmentName, string ShiftTime, string Remark, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertEmpHoliday");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Date);
            SQLHelper.AddParamToSQLCmd(cmd, "@Department", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, DepartmentName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Shift", System.Data.SqlDbType.NVarChar, 50, System.Data.ParameterDirection.Input, ShiftTime);
            SQLHelper.AddParamToSQLCmd(cmd, "@Remark", System.Data.SqlDbType.NVarChar, 3000, System.Data.ParameterDirection.Input, Remark);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, AddedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }

        public DataTable GetBirthdayList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getBirthdayListOnDashboard");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertDashboardTour(string IsCheck)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertDashbardTour");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            SQLHelper.AddParamToSQLCmd(cmd, "@IsCheck", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, IsCheck);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public int UpdateProjectAlertReadStatus(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UpdateOSTNotificationsReadStatus");
            SQLHelper.AddParamToSQLCmd(cmd, "@AlertID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AlertID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable GetAllOSTNotifications()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllOSTNotificationsByUser");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllTodayAnniversaries()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetTodayAnniversaries");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetWorkAnniversary()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetWorkAnniversary");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllSegments()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllSegments");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetRecordsForSLAReport(string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetRecordsForSLAReport");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertUserDomain(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertUserDomain");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.BigInt, 200, System.Data.ParameterDirection.Input, htParam["Domain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SubDomain", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["SubDomain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.BigInt, 200, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 200, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetOtherTaskReport(string FromDate, string ToDate, int AddedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOtherTask_Report");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, AddedBy);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetAllDomain_Notifications(int DomainId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllDomain_UserNotifications");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, DomainId);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllProjects_UserNotifications(int DomainId)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProjects_UserNotifications");
            SQLHelper.AddParamToSQLCmd(cmd, "@DomainID", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, DomainId);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllUser_UserNotifications(string ProjectName, string Subdomain)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllUser_UserNotifications_Test");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectName", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, ProjectName);
            SQLHelper.AddParamToSQLCmd(cmd, "@Subdomain", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, Subdomain);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertProjectNotifications(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertOSTUserNotifications");
            SQLHelper.AddParamToSQLCmd(cmd, "@Subject", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Subject"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Message", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Message"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Duration", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, "0");
            SQLHelper.AddParamToSQLCmd(cmd, "@EffectiveDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["EffectiveDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DisplayTo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, "");
            SQLHelper.AddParamToSQLCmd(cmd, "@Users", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Users"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Attachment", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Attachment"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Domain", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Domain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SubDomain", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["SubDomain"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public int InserSLATimeline(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "Insert_SLA_Timeline");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, htParam["Month"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Year"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Timeline", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["Timeline"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TimelineType", System.Data.SqlDbType.NVarChar, 40, System.Data.ParameterDirection.Input, htParam["TimelineType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }


        public DataTable GetAllSLATimeline()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllSLATimeline");
            SQLHelper.ExecuteNonQueryCmd(cmd);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable DomainWiseEmployeeCount(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_DomainWiseEmployeeCount");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 20, System.Data.ParameterDirection.Input, Year);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllProcess()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProcess");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetTargetMatrixSetup(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetTargetMatrixSetup]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public DataTable GetTargetMatrixForProject(int ProjectID, int ProcessID, int ProductID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetTargetMatrixForProject]");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, ProcessID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProductID", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, ProductID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public DataTable GetProductTypeList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetAllProductType]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public DataTable GetAllProductiveUsers()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllProductiveUsers");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetTargetMatrixByprojectAndProcess(string ProjectID, string ProcessID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getTargetaginestProjectAndProcess");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProcessID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;

        }

        public DataTable GetAllAssignUserTargetByPm(string EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllAsssignTarget");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        #region User Performance - HR

        /*NonDD*/
        public DataTable GetUserPerformanceReport_HR_NonDD(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformance_NonDD");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceProdDetails_HR_NonDD(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformanceDetails_HR_NonDD");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceFeedbackDetails_HR_NonDD(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserFeedbackDetails_HR_NonDD");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceAttendanceDetails_HR_NonDD(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserAttendanceDetails_NonDD");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@PM", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        /*  Credit */
        public DataTable GetUserPerformanceReport_HR_Credit(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformance_Credit");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceProdDetails_HR_Credit(string FromDate, string ToDate, int EmployeeID)  /*Done*/
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformanceDetails_Credit");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceFeedbackDetails_HR_Credit(string FromDate, string ToDate, int EmployeeID)  /*Done*/
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserFeedbackDetails_Credit");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceAttendanceDetails_HR_Credit(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserAttendanceDetails_Credit");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@PM", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        /*  Servicing */
        public DataTable GetUserPerformanceReport_HR_Servicing(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformance_Servicing");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceProdDetails_HR_Servicing(string FromDate, string ToDate, int EmployeeID) /*Done*/
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformanceDetails_Servicing");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceFeedbackDetails_HR_Servicing(string FromDate, string ToDate, int EmployeeID)  /*Done*/
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserFeedbackDetails_Servicing");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable GetHolidayList()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetHolidays");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceAttendanceDetails_HR_Servicing(string FromDate, string ToDate, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserAttendanceDetails_Servicing");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@PM", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetBranchAndDateWiseAttendance(string Month, string Year)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetDateWiseAttendance_ICG_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@Month", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Month);
            SQLHelper.AddParamToSQLCmd(cmd, "@Year", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Year);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Sal(cmd);
            return dt;
        }

        #endregion

        #region FTE

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

        public int InsertFTEUserDetails(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertFTEUserConfigurtion");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Pseudoname", System.Data.SqlDbType.NVarChar, 500, System.Data.ParameterDirection.Input, htParam["Pseudoname"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeStatus", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["EmployeeStatus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EffectiveDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["EffectiveDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoticePeriodDays", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["NoticePeriodDays"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        public DataTable getProcessByProjectWise(int ProjectID, string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetProcessByProjectWise");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetFTEDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetFTEDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetFTEUserDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetFTEUSerCOnfiguration");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllEmployeeDetailsbyPM(int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_ShowUserForSkipMeeting]");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPseudoName(string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetPseudoName]");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetClientHoliday()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetProjectHolidays");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetTop50FTEEntry(int ProjectID, int ProcessID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GtTop50FTEEntry");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, ProjectID);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, ProcessID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetBilligPeriodDates(string BillingCycle)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetBilligPeriodDates");
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingCycle", System.Data.SqlDbType.NVarChar, 30, System.Data.ParameterDirection.Input, BillingCycle);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int InsertClientHoliday(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertProjectHolidays");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }



        public int InsertFTEEntry(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "up_InsertFTEEntry");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProcessID", System.Data.SqlDbType.BigInt, 10, System.Data.ParameterDirection.Input, htParam["ProcessID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApprovedCount", System.Data.SqlDbType.Decimal, 18, System.Data.ParameterDirection.Input, htParam["ApprovedCount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Date", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, htParam["Date"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ActualCount", System.Data.SqlDbType.Decimal, 18, System.Data.ParameterDirection.Input, htParam["ActualCount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue; //-1=Exist, 0=Fail, >0=Success
        }

        #endregion

        #region Health Insurance
        public DataTable GetEmployeeForGroupPolicy()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmployeeForGroupPolicy");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetPolicyPeriods()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getUniquePolicyPeriod");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetEmployeesByPolicyPeriod(string PolicyPeriod)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_getEmployeesByPolicyPeriod");
            SQLHelper.AddParamToSQLCmd(cmd, "@PolicyPeriod", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, PolicyPeriod);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetEmployeeGroupPolicyInfoByEmpID(int EmployeeID, int PolicyID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmployeeGroupPolicyInfoByEmpID_1");
            SQLHelper.AddParamToSQLCmd(cmd, "EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "PolicyID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, PolicyID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetApplicableEmployeeForGroupPolicy()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetApplicableEmployeeForGroupPolicy");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetNotApplicableEmployeeForGroupPolicy()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetNotApplicableEmployeeForGroupPolicy");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public int RemoveFromPolicyList(string Code, int DeletedBy)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_RemoveFromPolicyList");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@DeletedBy", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.Input, DeletedBy);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }

        public DataTable GetFamilyInfoForGroupPolicy(int EmployeeID, int PolicyID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetFamilyInfoForGroupPolicy_1");
            SQLHelper.AddParamToSQLCmd(cmd, "EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "PolicyID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, PolicyID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetSumInsuredDistribution(decimal Amount, decimal SumInsured, bool IsApplicable)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetSumInsuredDistribution");
            SQLHelper.AddParamToSQLCmd(cmd, "@Amount", System.Data.SqlDbType.Decimal, 00, System.Data.ParameterDirection.Input, Amount);
            SQLHelper.AddParamToSQLCmd(cmd, "@SumInsured", System.Data.SqlDbType.Decimal, 00, System.Data.ParameterDirection.Input, SumInsured);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsApplicable", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, IsApplicable);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAge(string BithDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAge");
            SQLHelper.AddParamToSQLCmd(cmd, "@BirthDate", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, BithDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetAllPolicyAmount()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllPolicies");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int ApplyEmployeeGroupPolicy(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_ApplyEmployeeGroupPolicy_Revised1");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsApplicable", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParam["IsApplicable"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AppliedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AppliedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PolicyId", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["PolicyId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PolicyStartDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["PolicyStartDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PolicyPeriod", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["PolicyPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }


        public int InsertEmployeeGroupPolicy(Hashtable htParm)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertEmployeeGroupPolicy_Revised_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 200, System.Data.ParameterDirection.Input, htParm["EmployeeID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@GroupPolicyType", System.Data.SqlDbType.NVarChar, 200, System.Data.ParameterDirection.Input, htParm["GroupPolicyType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@SumInsured", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, htParm["SumInsured"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ApproxPremium", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, htParm["ApproxPremium"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyContributionMonthly", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, htParm["CompanyContributionMonthly"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyContributionYearly", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, htParm["CompanyContributionYearly"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpApproxPremiumMonthly", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, htParm["EmpApproxPremiumMonthly"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmpApproxPremiumYearly", System.Data.SqlDbType.Decimal, 10, System.Data.ParameterDirection.Input, htParm["EmpApproxPremiumYearly"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@IsApplicable", System.Data.SqlDbType.Bit, 0, System.Data.ParameterDirection.Input, htParm["IsApplicable"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContributionCategory", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParm["ContributionCategory"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContributionType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParm["ContributionType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PercFixAmount", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParm["PercFixAmount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParm["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PolicyID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParm["PolicyID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return ReturnValue;
        }


        #endregion


        public DataTable GetAllSetAppreciationDisplinaryActionReport(string Type, int EmployeeID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllSetAppreciationDisplinaryActionReport");
            SQLHelper.AddParamToSQLCmd(cmd, "@Type", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, Type);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, EmployeeID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetDashboardPerformanceDetailsLast12Months()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetEmployeePerformanceLast12Months");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, (HttpContext.Current.User.Identity.Name.ToString()));
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetProductiveEmployeePerformanceLast12Months(int EmployeeID, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetOverAllUserPerformanceDetails_IndividualEmployee");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, EmployeeID);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetUserPerformanceReport_DashboardDetails(string FromDate, string ToDate, string Code)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UserPerformanceReportForIncrementProposal_1");
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, ToDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetProjectProcesswiseProductivity(string Code, string FromDate, string ToDate)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_UserPerformanceReportForIncrementProposal_ProjectWise_New");
            SQLHelper.AddParamToSQLCmd(cmd, "@Code", System.Data.SqlDbType.NVarChar, 10, System.Data.ParameterDirection.Input, Code);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, FromDate);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 12, System.Data.ParameterDirection.Input, ToDate);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public int InsertSecuritizationRelLetterBilling_Unbilled(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_InsertSecuritizationRelianceLetterBilling_Unbilled");
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingPeriod", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["BillingPeriod"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectId", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["ProjectId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Description", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["Description"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@LoanCount", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["LoanCount"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoOfHoursLoans", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["NoOfHoursLoans"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssociateRemark", System.Data.SqlDbType.NVarChar, 4000, System.Data.ParameterDirection.Input, htParam["AssociateRemark"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@BillingType", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["BillingType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DealNo", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["DealNo"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", System.Data.SqlDbType.BigInt, 0, System.Data.ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);

            int ReturnValue = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            return ReturnValue;
        }
        public DataTable GetExistingLoanList_Unbilled()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "[usp_GetSecRelBilledLoanList_Unbilled]");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
        public DataTable GetLoanTrackingHistory(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetLoanLevelSecRelTracking");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 10, System.Data.ParameterDirection.Input, htParam["ProjectID"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@FromDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["FromDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ToDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["ToDate"]);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }


        public DataTable CheckOtherTaskExistsOrNot(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_CheckOtherTaskExistsOrNot");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Loans", System.Data.SqlDbType.NVarChar, 5000, System.Data.ParameterDirection.Input, htParam["Loans"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssignedDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["AssignedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }


        public DataTable DeleteExistingOthertaskRecords(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_DeleteExistingOthertaskRecords");
            SQLHelper.AddParamToSQLCmd(cmd, "@Project", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Project"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Process", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Process"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Loans", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["Loans"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AssignedDate", System.Data.SqlDbType.NVarChar, 100, System.Data.ParameterDirection.Input, htParam["AssignedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, htParam["AddedBy"]);
            DataTable dt = SQLHelper.ExecuteDataTableCmd_Underwriting(cmd);
            return dt;
        }

        public DataTable GetProcessForOtherTask(int ProjectID)
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "GetProcessBYProject_OtherTask");
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectID", System.Data.SqlDbType.Int, 0, System.Data.ParameterDirection.Input, ProjectID);
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }

        public DataTable GetAllEmployeeDetailsForApprovalofSalaryStructure()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "[usp_GetAllEmployeeDetailsForApprovalofNewProfile]");
            return SQLHelper.ExecuteDataTableCmd(cmd);
        }

        public int InsertSalaryStructure(Hashtable htParam)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_InsertSalaryStructure_Revised");
            SQLHelper.AddParamToSQLCmd(cmd, "@EmployeeId", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["EmployeeId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Salary", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["Salary"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Basic", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["Basic"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@DA", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["DA"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@MR", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["MR"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@TA", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["TA"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EA", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["EA"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@HA", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["HA"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@HRA", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["HRA"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Other", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["Other"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProfTax", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["ProfTax"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isESIC", SqlDbType.Bit, 0, ParameterDirection.Input, htParam["isESIC"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ESIC", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["ESIC"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isPF", SqlDbType.Bit, 0, ParameterDirection.Input, htParam["isPF"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@PF", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["PF"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isNightBonus", SqlDbType.Bit, 0, ParameterDirection.Input, htParam["isNightBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NightBonus", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["NightBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isExtra", SqlDbType.Bit, 0, ParameterDirection.Input, htParam["isExtra"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttendanceBonusType", SqlDbType.NVarChar, 100, ParameterDirection.Input, htParam["AttendanceBonusType"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AttendanceBonus", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["AttendanceBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@isQualityBonusApplicable", SqlDbType.Bit, 0, ParameterDirection.Input, htParam["isQualityBonusApplicable"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@QualityBonus", SqlDbType.BigInt, 0, ParameterDirection.Input, htParam["QualityBonus"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);

            SQLHelper.ExecuteNonQueryCmd(cmd);
            return Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
        }

        public DataTable GetAllUserERPLoginDetails()
        {
            SqlCommand cmd = SQLHelper.GetCommand(System.Data.CommandType.StoredProcedure, "usp_GetAllUserERPLoginDetails");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);
            return dt;
        }
    }
}
