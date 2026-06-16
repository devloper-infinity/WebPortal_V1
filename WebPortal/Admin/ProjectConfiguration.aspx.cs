using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ProjectConfiguration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Project Configuration
        [WebMethod]
        public static string GetAllDomainGroups()
        {
            DataTable dt1 = new bllMaster().GetAllDomain();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetSubdomains(int DomainGroupId)
        {
            DataTable dt1 = new bllRequisition().GetAllSubdomains(DomainGroupId);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetAllProjects()
        {
            DataTable dt1 = new bllMaster().GetAllProject();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string SaveProject(ProjectModel obj)
        {
            SqlConnection con = new SqlConnection(SQLHelper.ConnectionString);

            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;

            con.Open();

            SqlTransaction trans = con.BeginTransaction();

            cmd.Transaction = trans;

            try
            {
                int ProjectID = 0;

                /* =========================================
                   INSERT
                ========================================= */

                if (string.IsNullOrEmpty(obj.ProjectID)
                    || obj.ProjectID == "0")
                {

                    /* =========================
                       INSERT PROJECT MASTER
                    ========================= */

                    cmd.CommandText = @"

                INSERT INTO Project
                (
                    ProjectName,
                    AddedBy,
                    AddedDate,
                    Status,
                    IsDelete,
                    SubdomainID
                )

                VALUES
                (
                    @ProjectName,
                    @AddedBy,
                    GETDATE(),
                    1,
                    0,
                    @SubdomainID
                )

                SELECT SCOPE_IDENTITY()
            ";

                    cmd.Parameters.Clear();

                    cmd.Parameters.AddWithValue("@ProjectName", obj.ProjectName);

                    cmd.Parameters.AddWithValue("@AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    cmd.Parameters.AddWithValue("@SubdomainID",

                        string.IsNullOrEmpty(obj.SubdomainID)
                        ? (object)DBNull.Value
                        : obj.SubdomainID);

                    ProjectID = Convert.ToInt32(cmd.ExecuteScalar());



                    /* =========================
                       INSERT CONFIG TABLE
                    ========================= */

                    cmd.CommandText = @"

                INSERT INTO ClientFeedback
                (
                    ProjectId,
                    DomainId,
                    Process,
                    ProjectStartDate,
                    BillingCycle,
                    DueDays,
                    AddedBy,
                    AddedDate,
                    ProjectType,
                    Status,
                    Type,
                    Remark
                )

                VALUES
                (
                    @ProjectID,
                    @DomainID,
                    @Process,
                    @ProjectStartDate,
                    @BillingCycle,
                    @DueDays,
                    @AddedBy,
                    GETDATE(),
                    @ProjectType,
                    @Status,
                    @Type,
                    @Remark
                )
            ";

                    cmd.Parameters.Clear();

                    cmd.Parameters.AddWithValue("@ProjectID", ProjectID);

                    cmd.Parameters.AddWithValue("@DomainID", obj.DomainID);

                    cmd.Parameters.AddWithValue("@Process", obj.Process);

                    cmd.Parameters.AddWithValue("@ProjectStartDate",

                        string.IsNullOrEmpty(obj.ProjectStartDate)
                        ? (object)DBNull.Value
                        : Convert.ToDateTime(obj.ProjectStartDate));

                    cmd.Parameters.AddWithValue("@BillingCycle", obj.BillingCycle);

                    cmd.Parameters.AddWithValue("@DueDays",

                        string.IsNullOrEmpty(obj.DueDays)
                        ? (object)DBNull.Value
                        : obj.DueDays);

                    cmd.Parameters.AddWithValue("@AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    cmd.Parameters.AddWithValue("@ProjectType", obj.ProjectType);

                    cmd.Parameters.AddWithValue("@Status", obj.ProjectActiveStatus);

                    cmd.Parameters.AddWithValue("@Type", obj.Type);

                    cmd.Parameters.AddWithValue("@Remark", obj.Remark);

                    cmd.ExecuteNonQuery();
                }

                /* =========================================
                   UPDATE
                ========================================= */

                else
                {
                    ProjectID = Convert.ToInt32(obj.ProjectID);

                    /* =========================
                       UPDATE MASTER TABLE
                    ========================= */

                    cmd.CommandText = @"

                UPDATE Project
                SET

                    ProjectName = @ProjectName,
                    UpdatedBy = @UpdatedBy,
                    UpdatedDate = GETDATE(),
                    SubdomainID = @SubdomainID

                WHERE ProjectID = @ProjectID
            ";

                    cmd.Parameters.Clear();

                    cmd.Parameters.AddWithValue("@ProjectID", ProjectID);

                    cmd.Parameters.AddWithValue("@ProjectName", obj.ProjectName);

                    cmd.Parameters.AddWithValue("@UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    cmd.Parameters.AddWithValue("@SubdomainID",

                        string.IsNullOrEmpty(obj.SubdomainID)
                        ? (object)DBNull.Value
                        : obj.SubdomainID);

                    cmd.ExecuteNonQuery();



                    /* =========================
                       UPDATE CONFIG TABLE
                    ========================= */

                    cmd.CommandText = @"

                UPDATE ClientFeedback
                SET

                    DomainId = @DomainID,
                    Process = @Process,
                    ProjectStartDate = @ProjectStartDate,
                    BillingCycle = @BillingCycle,
                    DueDays = @DueDays,
                    ProjectType = @ProjectType,
                    Status = @Status,
                    Type = @Type,
                    Remark = @Remark

                WHERE ProjectId = @ProjectID
            ";

                    cmd.Parameters.Clear();

                    cmd.Parameters.AddWithValue("@ProjectID", ProjectID);

                    cmd.Parameters.AddWithValue("@DomainID", obj.DomainID);

                    cmd.Parameters.AddWithValue("@Process", obj.Process);

                    cmd.Parameters.AddWithValue("@ProjectStartDate",

                        string.IsNullOrEmpty(obj.ProjectStartDate)
                        ? (object)DBNull.Value
                        : Convert.ToDateTime(obj.ProjectStartDate));

                    cmd.Parameters.AddWithValue("@BillingCycle", obj.BillingCycle);

                    cmd.Parameters.AddWithValue("@DueDays",

                        string.IsNullOrEmpty(obj.DueDays)
                        ? (object)DBNull.Value
                        : obj.DueDays);

                    cmd.Parameters.AddWithValue("@ProjectType", obj.ProjectType);

                    cmd.Parameters.AddWithValue("@Status", obj.ProjectActiveStatus);

                    cmd.Parameters.AddWithValue("@Type", obj.Type);

                    cmd.Parameters.AddWithValue("@Remark", obj.Remark);


                    cmd.ExecuteNonQuery();
                }

                trans.Commit();

                return "Success";
            }
            catch (Exception ex)
            {
                trans.Rollback();

                return ex.Message;
            }
            finally
            {
                con.Close();
            }
        }

        #endregion

        #region Process Configuration
        [WebMethod]
        public static string GetAllProcess()
        {
            DataTable dt1 = new bllMaster().GetAllProcess();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string SaveProcess(ProcessModel obj)
        {
            SqlConnection con = new SqlConnection(SQLHelper.ConnectionString);

            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;

            con.Open();

            try
            {

                /* =========================
                   INSERT
                ========================= */

                if (string.IsNullOrEmpty(obj.ProcessID)
                    || obj.ProcessID == "0")
                {

                    cmd.CommandText = @"

                INSERT INTO Process
                (
                    ProjectID,
                    ProcessName,
                    AddedBy,
                    AddedDate
                )

                VALUES
                (
                    @ProjectID,
                    @ProcessName,
                    @AddedBy,
                    GETDATE()
                )
            ";
                }

                /* =========================
                   UPDATE
                ========================= */

                else
                {

                    cmd.CommandText = @"

                UPDATE Process
                SET

                    ProjectID = @ProjectID,
                    ProcessName = @ProcessName,
                    UpdatedBy = @UpdatedBy,
                    UpdatedDate = GETDATE()

                WHERE ProcessID = @ProcessID
            ";

                    cmd.Parameters.AddWithValue("@ProcessID", obj.ProcessID);

                    cmd.Parameters.AddWithValue("@UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                }

                cmd.Parameters.AddWithValue("@ProjectID", obj.ProjectID);

                cmd.Parameters.AddWithValue("@ProcessName", obj.ProcessName);

                cmd.Parameters.AddWithValue("@AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                cmd.ExecuteNonQuery();

                con.Close();

                return "Success";
            }
            catch (Exception ex)
            {
                con.Close();

                return ex.Message;
            }
        }
        #endregion


        #region Product Type Configuration
        [WebMethod]
        public static string GetProductTypeList()
        {
            DataTable dt1 = new bllMaster().GetProductTypeList();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetProcessByProject(int ProjectID)
        {
            DataTable dt1 = new bllMaster().getProcess(ProjectID);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string SaveProductType(ProductTypeModel obj)
        {
            SqlConnection con = new SqlConnection(SQLHelper.ConnectionString);

            con.Open();

            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;

            try
            {

                if (obj.ProductId == 0)
                {

                    cmd.CommandText = @"

                INSERT INTO Infinity_UW_Process_ProductType
                (
                    ProcessId,
                    ProjectId,
                    ProductType,
                    AddedBy,
                    AddedDate
                )

                VALUES
                (
                    @ProcessId,
                    @ProjectId,
                    @ProductType,
                    @AddedBy,
                    GETDATE()
                )
            ";
                }
                else
                {
                    cmd.CommandText = @"

                UPDATE Infinity_UW_Process_ProductType

                SET

                    ProcessId = @ProcessId,
                    ProjectId = @ProjectId,
                    ProductType = @ProductType

                WHERE ProductId = @ProductId
            ";
                    cmd.Parameters.AddWithValue("@ProductId", obj.ProductId);
                }

                cmd.Parameters.AddWithValue("@ProcessId", obj.ProcessId);
                cmd.Parameters.AddWithValue("@ProjectId", obj.ProjectId);
                cmd.Parameters.AddWithValue("@ProductType", obj.ProductType);
                cmd.Parameters.AddWithValue("@AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                cmd.ExecuteNonQuery();
                con.Close();

                return "Success";
            }
            catch (Exception ex)
            {
                con.Close();

                return ex.Message;
            }
        }
        #endregion

        #region Target Matrix Setup
        [WebMethod]
        public static string GetTargetMatrixSetup()
        {
            DataTable dt1 = new bllMaster().GetTargetMatrixSetup(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetTargetMatrixFoprProject(int projectId, int processId, int productId)
        {
            DataTable dt1 = new bllMaster().GetTargetMatrixForProject(projectId, processId, productId);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string SaveTargetMatrix(TargetMatrixModel obj)
        {
            SqlConnection con = new SqlConnection(SQLHelper.ConnectionString);

            con.Open();

            SqlTransaction trans = con.BeginTransaction();

            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;

            cmd.Transaction = trans;

            try
            {

                /* =========================================
                   CHECK EXISTING
                ========================================= */

                cmd.CommandText = @"

            SELECT COUNT(1)

            FROM TargetMatrixMaster

            WHERE ProjectID = @ProjectID
            AND ProcessID = @ProcessID
            AND ISNULL(ProductID,0)=ISNULL(@ProductID,0)
        ";

                cmd.Parameters.AddWithValue("@ProjectID", obj.ProjectID);

                cmd.Parameters.AddWithValue("@ProcessID", obj.ProcessID);

                cmd.Parameters.AddWithValue("@ProductID", obj.ProductID);

                int exists = Convert.ToInt32(cmd.ExecuteScalar());

                cmd.Parameters.Clear();



                /* =========================================
                   INSERT
                ========================================= */

                if (exists == 0)
                {

                    cmd.CommandText = @"

                INSERT INTO TargetMatrixMaster
                (
                    ProjectID,
                    ProcessID,
                    ProductID,

                    Month1,
                    Month2,
                    Month3,
                    Month4,
                    Month5,
                    Month6,
                    Month7,
                    Month8,
                    Month9,
                    Month10,
                    Month11,
                    Month12,
                    Month13,
                    Month14,
                    Month15,
                    Month16,
                    Month17,
                    Month18,
                    Month19,
                    Month20,
                    Month21,
                    Month22,
                    Month23,
                    Month24,
                    Month25,
                    Month26,
                    Month27,
                    Month28,
                    Month29,
                    Month30,
                    Month31,
                    Month32,
                    Month33,
                    Month34,
                    Month35,
                    Month36,

                    Maturity,

                    AddedBy,
                    AddedDate
                )

                VALUES
                (
                    @ProjectID,
                    @ProcessID,
                    @ProductID,

                    @Month1,
                    @Month2,
                    @Month3,
                    @Month4,
                    @Month5,
                    @Month6,
                    @Month7,
                    @Month8,
                    @Month9,
                    @Month10,
                    @Month11,
                    @Month12,
                    @Month13,
                    @Month14,
                    @Month15,
                    @Month16,
                    @Month17,
                    @Month18,
                    @Month19,
                    @Month20,
                    @Month21,
                    @Month22,
                    @Month23,
                    @Month24,
                    @Month25,
                    @Month26,
                    @Month27,
                    @Month28,
                    @Month29,
                    @Month30,
                    @Month31,
                    @Month32,
                    @Month33,
                    @Month34,
                    @Month35,
                    @Month36,

                    @Maturity,

                    @AddedBy,
                    GETDATE()
                )
            ";
                }

                /* =========================================
                   UPDATE
                ========================================= */

                else
                {

                    cmd.CommandText = @"

                UPDATE TargetMatrixMaster

                SET

                    Month1 = @Month1,
                    Month2 = @Month2,
                    Month3 = @Month3,
                    Month4 = @Month4,
                    Month5 = @Month5,
                    Month6 = @Month6,
                    Month7 = @Month7,
                    Month8 = @Month8,
                    Month9 = @Month9,
                    Month10 = @Month10,
                    Month11 = @Month11,
                    Month12 = @Month12,
                    Month13 = @Month13,
                    Month14 = @Month14,
                    Month15 = @Month15,
                    Month16 = @Month16,
                    Month17 = @Month17,
                    Month18 = @Month18,
                    Month19 = @Month19,
                    Month20 = @Month20,
                    Month21 = @Month21,
                    Month22 = @Month22,
                    Month23 = @Month23,
                    Month24 = @Month24,
                    Month25 = @Month25,
                    Month26 = @Month26,
                    Month27 = @Month27,
                    Month28 = @Month28,
                    Month29 = @Month29,
                    Month30 = @Month30,
                    Month31 = @Month31,
                    Month32 = @Month32,
                    Month33 = @Month33,
                    Month34 = @Month34,
                    Month35 = @Month35,
                    Month36 = @Month36,

                    Maturity = @Maturity,

                    UpdatedBy = @UpdatedBy,
                    UpdatedDate = GETDATE()

                WHERE ProjectID = @ProjectID
                AND ProcessID = @ProcessID
                AND ISNULL(ProductID,0)=ISNULL(@ProductID,0)
            ";
                }



                /* =========================================
                   COMMON PARAMETERS
                ========================================= */

                cmd.Parameters.AddWithValue("@ProjectID", obj.ProjectID);

                cmd.Parameters.AddWithValue("@ProcessID", obj.ProcessID);

                cmd.Parameters.AddWithValue("@ProductID", obj.ProductID);

                for (int i = 1; i <= 36; i++)
                {
                    var prop = obj.GetType().GetProperty("Month" + i);

                    var val = prop.GetValue(obj, null);

                    cmd.Parameters.AddWithValue(
                        "@Month" + i,

                        string.IsNullOrEmpty(Convert.ToString(val))
                        ? (object)DBNull.Value
                        : val
                    );
                }

                cmd.Parameters.AddWithValue("@Maturity",

                    string.IsNullOrEmpty(Convert.ToString(obj.Maturity))
                    ? (object)DBNull.Value
                    : obj.Maturity);

                cmd.Parameters.AddWithValue("@AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                cmd.Parameters.AddWithValue("@UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                cmd.ExecuteNonQuery();

                trans.Commit();

                return "Success";
            }
            catch (Exception ex)
            {
                trans.Rollback();

                return ex.Message;
            }
            finally
            {
                con.Close();
            }
        }

        #endregion

        #region Project Rights

        #region Project rights section
        [WebMethod]
        public static List<EmployeeModel> GetUsers()
        {
            List<EmployeeModel> list = new List<EmployeeModel>();

            string constr = SQLHelper.ConnectionString;

            using (SqlConnection con = new SqlConnection(constr))
            {
                string query = @"

            SELECT
                EmployeeID,
                Code,
                FirstName+' '+MiddleName+' '+lastName as EmployeeName

            FROM EmployeeInfo

            WHERE ( IsDelete = 0 OR IsDelete IS NULL)    

            ORDER BY Code

        ";

                SqlCommand cmd = new SqlCommand(query, con);

                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    list.Add(new EmployeeModel
                    {
                        EmployeeID = dr["EmployeeID"].ToString(),
                        Code = dr["Code"].ToString(),
                        EmployeeName = dr["EmployeeName"].ToString()
                    });
                }
            }

            return list;
        }

        [WebMethod]
        public static List<ProjectRightsModel> GetProjectRights(string EmployeeId)
        {
            List<ProjectRightsModel> list = new List<ProjectRightsModel>();

            string constr = SQLHelper.ConnectionString;

            using (SqlConnection con = new SqlConnection(constr))
            {
                string query = @"

        SELECT
            P.ProjectId,
            P.ProjectName,
            D.DomainName,

            CASE
                WHEN R.ProjectId IS NOT NULL
                THEN 1
                ELSE 0
            END AS IsAssigned

        FROM Project P
        inner join ClientFeedback C on C.ProjectID=P.ProjectID
        INNER JOIN Domain D
            ON D.DomainId = C.DomainId

        LEFT JOIN UserProjectConfiguration R
            ON R.ProjectId = P.ProjectId
            AND R.UserId = @EmployeeId

        ORDER BY P.ProjectName
        ";

                SqlCommand cmd = new SqlCommand(query, con);

                cmd.Parameters.AddWithValue("@EmployeeId", EmployeeId);

                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    list.Add(new ProjectRightsModel
                    {
                        ProjectId = Convert.ToInt32(dr["ProjectId"]),
                        ProjectName = dr["ProjectName"].ToString(),
                        DomainName = dr["DomainName"].ToString(),
                        IsAssigned = Convert.ToBoolean(dr["IsAssigned"])
                    });
                }
            }

            return list;
        }

        [WebMethod]
        public static string SaveProjectRights(string EmployeeId, List<string> ProjectIds)
        {
            string constr = SQLHelper.ConnectionString;

            using (SqlConnection con = new SqlConnection(constr))
            {
                con.Open();

                SqlTransaction trans = con.BeginTransaction();

                try
                {
                    // DELETE OLD RIGHTS
                    SqlCommand delCmd = new SqlCommand(@"
                DELETE FROM UserProjectConfiguration
                WHERE UserID = @EmployeeId
            ", con, trans);

                    delCmd.Parameters.AddWithValue("@EmployeeId", EmployeeId);

                    delCmd.ExecuteNonQuery();

                    // INSERT NEW RIGHTS
                    foreach (string projectId in ProjectIds)
                    {
                        SqlCommand insCmd = new SqlCommand(@"
                    INSERT INTO UserProjectConfiguration
                    (
                        ProjectID,
                        UserID,
                        AddedBy,
                        AddedDate
                    )
                    VALUES
                    (
                        @ProjectId,
                        @EmployeeId,
                        @AddedBy,
                        GETDATE()
                    )
                ", con, trans);

                        insCmd.Parameters.AddWithValue("@EmployeeId", EmployeeId);
                        insCmd.Parameters.AddWithValue("@ProjectId", projectId);
                        insCmd.Parameters.AddWithValue("@AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                        insCmd.ExecuteNonQuery();
                    }

                    trans.Commit();

                    return "Success";
                }
                catch (Exception ex)
                {
                    trans.Rollback();

                    return ex.Message;
                }
            }
        }

        #endregion
        #region Assign Special Target
        [WebMethod]
        public static string GetAssignedTargets()
        {
            DataTable dt1 = new bllMaster().GetAllAssignUserTargetByPm(HttpContext.Current.User.Identity.Name.ToString());
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetAllProjectByUser(string EmployeeID)
        {
            DataTable dt1 = new bllMaster().GetAllProjectByUserRights(EmployeeID);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetAssignedTargtetByProjectProcess(int ProjectID, int ProcessID)
        {
            DataTable dt1 = new bllMaster().GetTargetMatrixByprojectAndProcess(Convert.ToString(ProjectID), Convert.ToString(ProcessID));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static int SaveSpecialTarget(
    long? TID,
    string Code,
    string Month,
    string Remark,
    int ProjectID,
    int ProcessID)
        {
            int result = 0;

            try
            {
                using (SqlConnection con =
                    new SqlConnection(
                        SQLHelper.ConnectionString))
                {
                    using (SqlCommand cmd =
                        new SqlCommand(
                            "InsartAssignUserTaragt", con))
                    {
                        cmd.CommandType =
                            CommandType.StoredProcedure;
                        string Code1 = new bllMaster().GetCodeFromEmployeeId(int.Parse(Code));
                        cmd.Parameters.AddWithValue(
                            "@Code", Code1);

                        cmd.Parameters.AddWithValue(
                            "@Month", Month);

                        cmd.Parameters.AddWithValue(
                            "@Remark", Remark);

                        cmd.Parameters.AddWithValue(
                            "@AddedBy",int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                        cmd.Parameters.AddWithValue(
                            "@ProjectID", ProjectID);

                        cmd.Parameters.AddWithValue(
                            "@ProcessID", ProcessID);

                        // TID
                        if (TID.HasValue)
                        {
                            cmd.Parameters.AddWithValue(
                                "@TID", TID.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue(
                                "@TID", DBNull.Value);
                        }
                        SqlParameter returnParameter = new SqlParameter();

                        returnParameter.Direction =
                            ParameterDirection.ReturnValue;

                        cmd.Parameters.Add(returnParameter);
                        con.Open();
                        cmd.ExecuteNonQuery();

                        result = Convert.ToInt32(
                            returnParameter.Value);
                        //result = Convert.ToInt32(
                        //    cmd.ExecuteScalar());
                    }
                }
            }
            catch
            {
                result = -1;
            }

            return result;
        }

        [WebMethod]
        public static int DeleteTarget(int ID)
        {
            using (SqlConnection con =
                new SqlConnection(
                    SQLHelper.ConnectionString))
            {
                string query = @"

            UPDATE AssignUserTarget

            SET
                IsDelete = 1

            WHERE ID = @ID

        ";

                SqlCommand cmd =
                    new SqlCommand(query, con);

                cmd.Parameters.AddWithValue("@ID", ID);

                con.Open();

                return cmd.ExecuteNonQuery();
            }
        }
        #endregion
        #endregion


        public class ProjectModel
        {
            public string ProjectID { get; set; }
            public string ProjectName { get; set; }
            public string DomainID { get; set; }
            public string SubdomainID { get; set; }
            public string ProjectStartDate { get; set; }
            public string BillingCycle { get; set; }
            public string DueDays { get; set; }
            public string Process { get; set; }
            public string ProjectType { get; set; }
            public string ProjectActiveStatus { get; set; }
            public string Type { get; set; }
            public string Remark { get; set; }
        }

        public class ProcessModel
        {
            public string ProcessID { get; set; }

            public string ProjectID { get; set; }

            public string ProcessName { get; set; }
        }

        public class TargetMatrixModel
        {
            public int ProjectID { get; set; }

            public int ProcessID { get; set; }

            public int ProductID { get; set; }

            public decimal? Month1 { get; set; }
            public decimal? Month2 { get; set; }
            public decimal? Month3 { get; set; }
            public decimal? Month4 { get; set; }
            public decimal? Month5 { get; set; }
            public decimal? Month6 { get; set; }
            public decimal? Month7 { get; set; }
            public decimal? Month8 { get; set; }
            public decimal? Month9 { get; set; }
            public decimal? Month10 { get; set; }
            public decimal? Month11 { get; set; }
            public decimal? Month12 { get; set; }
            public decimal? Month13 { get; set; }
            public decimal? Month14 { get; set; }
            public decimal? Month15 { get; set; }
            public decimal? Month16 { get; set; }
            public decimal? Month17 { get; set; }
            public decimal? Month18 { get; set; }
            public decimal? Month19 { get; set; }
            public decimal? Month20 { get; set; }
            public decimal? Month21 { get; set; }
            public decimal? Month22 { get; set; }
            public decimal? Month23 { get; set; }
            public decimal? Month24 { get; set; }
            public decimal? Month25 { get; set; }
            public decimal? Month26 { get; set; }
            public decimal? Month27 { get; set; }
            public decimal? Month28 { get; set; }
            public decimal? Month29 { get; set; }
            public decimal? Month30 { get; set; }
            public decimal? Month31 { get; set; }
            public decimal? Month32 { get; set; }
            public decimal? Month33 { get; set; }
            public decimal? Month34 { get; set; }
            public decimal? Month35 { get; set; }
            public decimal? Month36 { get; set; }

            public decimal? Maturity { get; set; }
        }

        public class ProductTypeModel
        {
            public int ProductId { get; set; }

            public int ProjectId { get; set; }

            public int ProcessId { get; set; }

            public string ProductType { get; set; }
        }

        public class ProjectRightsModel
        {
            public int ProjectId { get; set; }

            public string ProjectName { get; set; }

            public string DomainName { get; set; }

            public bool IsAssigned { get; set; }
        }

        public class EmployeeModel
        {
            public string EmployeeID { get; set; }

            public string Code { get; set; }

            public string EmployeeName { get; set; }
        }
    }
}