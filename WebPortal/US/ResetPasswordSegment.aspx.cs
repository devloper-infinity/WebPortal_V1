using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.US
{
    public partial class ResetPasswordSegment : Page
    {
        private static readonly string[] AllowedSegments =
        {
            "Compliance QC - Canopy",
            "Credit QC - Canopy",
            "Management"
        };

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetUSEmployees()
        {
            //return "SUCCESS";

            DataTable employees = new dalUS().GetUSEmployees_Onshore();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (employees != null)
            {
                foreach (DataRow dataRow in employees.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>
                    {
                        { "SrNo", GetEmployeeValue(dataRow, "SrNo") },
                        { "Code", GetEmployeeValue(dataRow, "Code", "EmployeeCode") },
                        { "FullName", GetEmployeeValue(dataRow,  "Name") },
                        { "ReportingManager", GetEmployeeValue(dataRow, "manager") },
                        //{ "DesignationName", GetEmployeeValue(dataRow, "DesignationName") },
                        //{ "DepartmentName", GetEmployeeValue(dataRow, "Department") },
                        { "Segment", GetEmployeeValue(dataRow, "Segment") }
                    };

                    rows.Add(row);
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer
            {
                MaxJsonLength = int.MaxValue
            };

            return serializer.Serialize(rows);
        }

        [WebMethod]
        public static string GeneratePassword()
        {
            string password;

            do
            {
                password = Membership.GeneratePassword(12, 2);
            }
            while (!IsValidPassword(password));

            return password;
        }

        [WebMethod]
        public static OperationResult ResetPassword(string code, string password)
        {
            code = (code ?? string.Empty).Trim();
            password = password ?? string.Empty;

            if (string.IsNullOrWhiteSpace(code))
            {
                return OperationResult.Failure("Please select a user.");
            }

            if (!IsValidPassword(password))
            {
                return OperationResult.Failure("The generated password does not satisfy the password policy. Please generate it again.");
            }

            if (!EmployeeExists(code))
            {
                return OperationResult.Failure("The selected employee is no longer available.");
            }

            int returnValue = new bllMaster().UpdateResetPassword(code, password);

            return returnValue > 0
                ? OperationResult.SuccessResult("Password reset successfully.")
                : OperationResult.Failure("Unable to reset the password. Please contact the administrator.");
        }

        [WebMethod(EnableSession = true)]
        public static OperationResult UpdateSegment(string code, string segment)
        {
            code = (code ?? string.Empty).Trim();
            segment = (segment ?? string.Empty).Trim();

            if (string.IsNullOrWhiteSpace(code))
            {
                return OperationResult.Failure("Please select a user.");
            }

            if (Array.IndexOf(AllowedSegments, segment) < 0)
            {
                return OperationResult.Failure("Please select a valid segment.");
            }

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            {
                connection.Open();

                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        int employeeId = 0;
                        string currentSegment = string.Empty;

                        using (SqlCommand currentCommand = new SqlCommand(
                            "SELECT TOP 1 EmployeeID, ISNULL(Segment, '') AS Segment FROM EmployeeInfo WHERE Code = @Code",
                            connection,
                            transaction))
                        {
                            currentCommand.Parameters.Add("@Code", SqlDbType.NVarChar, 10).Value = code;

                            using (SqlDataReader reader = currentCommand.ExecuteReader())
                            {
                                if (!reader.Read())
                                {
                                    employeeId = 0;
                                }
                                else
                                {
                                    employeeId = Convert.ToInt32(reader["EmployeeID"]);
                                    currentSegment = Convert.ToString(reader["Segment"]);
                                }
                            }
                        }

                        if (employeeId == 0)
                        {
                            transaction.Rollback();
                            return OperationResult.Failure("The selected employee is no longer available.");
                        }

                        if (string.Equals(currentSegment, segment, StringComparison.OrdinalIgnoreCase))
                        {
                            transaction.Commit();
                            return OperationResult.NoChange("The employee is already assigned to this segment.");
                        }

                        string changedBy = GetCurrentUserName();

                        using (SqlCommand historyCommand = new SqlCommand(@"
                            INSERT INTO EmployeeSegmentHistory
                                (EmployeeID, OldSegment, NewSegment, ChangedBy)
                            VALUES
                                (@EmployeeID, @OldSegment, @NewSegment, @ChangedBy)", connection, transaction))
                        {
                            historyCommand.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                            historyCommand.Parameters.Add("@OldSegment", SqlDbType.NVarChar, 200).Value = currentSegment;
                            historyCommand.Parameters.Add("@NewSegment", SqlDbType.NVarChar, 200).Value = segment;
                            historyCommand.Parameters.Add("@ChangedBy", SqlDbType.NVarChar, 100).Value = changedBy;
                            historyCommand.ExecuteNonQuery();
                        }

                        using (SqlCommand updateCommand = new SqlCommand(
                            "UPDATE EmployeeInfo SET Segment = @NewSegment WHERE EmployeeID = @EmployeeID",
                            connection,
                            transaction))
                        {
                            updateCommand.Parameters.Add("@NewSegment", SqlDbType.NVarChar, 200).Value = segment;
                            updateCommand.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;

                            if (updateCommand.ExecuteNonQuery() != 1)
                            {
                                transaction.Rollback();
                                return OperationResult.Failure("Unable to update the employee segment.");
                            }
                        }

                        transaction.Commit();
                        return OperationResult.SuccessResult("Segment updated successfully.");
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        private static bool IsValidPassword(string password)
        {
            return !string.IsNullOrWhiteSpace(password)
                && password.Length >= 8
                && Regex.IsMatch(password, "[A-Z]")
                && Regex.IsMatch(password, "[a-z]")
                && Regex.IsMatch(password, "[0-9]")
                && Regex.IsMatch(password, "[^a-zA-Z0-9]");
        }

        private static bool EmployeeExists(string code)
        {
            DataTable employees = new dalUS().GetUSEmployees_Onshore();

            if (employees == null || !employees.Columns.Contains("Code"))
            {
                return false;
            }

            foreach (DataRow employee in employees.Rows)
            {
                if (string.Equals(Convert.ToString(employee["Code"]), code, StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }
            }

            return false;
        }

        private static string GetEmployeeValue(DataRow employee, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
            {
                if (employee.Table.Columns.Contains(columnName) && employee[columnName] != DBNull.Value)
                {
                    return Convert.ToString(employee[columnName]);
                }
            }

            return string.Empty;
        }

        private static string GetCurrentUserName()
        {
            object sessionUser = HttpContext.Current.Session == null
                ? null
                : HttpContext.Current.Session["UserName"];

            if (sessionUser != null && !string.IsNullOrWhiteSpace(Convert.ToString(sessionUser)))
            {
                return Convert.ToString(sessionUser);
            }

            return HttpContext.Current.User != null
                ? Convert.ToString(HttpContext.Current.User.Identity.Name)
                : string.Empty;
        }

        public class OperationResult
        {
            public bool Success { get; set; }
            public bool Changed { get; set; }
            public string Message { get; set; }

            public static OperationResult SuccessResult(string message)
            {
                return new OperationResult { Success = true, Changed = true, Message = message };
            }

            public static OperationResult NoChange(string message)
            {
                return new OperationResult { Success = true, Changed = false, Message = message };
            }

            public static OperationResult Failure(string message)
            {
                return new OperationResult { Success = false, Changed = false, Message = message };
            }
        }
    }
}
