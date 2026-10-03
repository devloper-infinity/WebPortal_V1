using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Reflection;
using WebPortal.Admin;

// Runs the production batch inside one transaction and rolls back all test changes.
class ProjectRightsSaveCheck
{
    static void Check(bool ok, string message) { if (!ok) throw new Exception(message); }
    static int Scalar(SqlConnection con, SqlTransaction tx, string sql, int user)
    {
        using (var cmd = new SqlCommand(sql, con, tx))
        {
            cmd.Parameters.AddWithValue("@User", user);
            return Convert.ToInt32(cmd.ExecuteScalar());
        }
    }
    static void Save(SqlConnection con, SqlTransaction tx, string sql, int user, int addedBy, string projects)
    {
        using (var cmd = new SqlCommand(sql, con, tx))
        {
            cmd.CommandTimeout = 30;
            cmd.Parameters.Add("@EmployeeId", SqlDbType.Int).Value = user;
            cmd.Parameters.Add("@AddedBy", SqlDbType.Int).Value = addedBy;
            cmd.Parameters.Add("@Projects", SqlDbType.Xml).Value = projects;
            cmd.ExecuteNonQuery();
        }
    }
    static int Main()
    {
        try
        {
            string sql = (string)typeof(ProjectConfiguration).GetField("ProjectRightsSaveSql", BindingFlags.NonPublic | BindingFlags.Static).GetRawConstantValue();
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["MainCon"].ConnectionString))
            {
                con.Open();
                int user = Scalar(con, null, "SELECT TOP (1) e.EmployeeID FROM dbo.EmployeeInfo e WHERE NOT EXISTS (SELECT 1 FROM dbo.UserProjectConfiguration r WHERE r.UserID=e.EmployeeID) ORDER BY e.EmployeeID DESC", 0);
                int[] ids = new int[3];
                using (var cmd = new SqlCommand("SELECT TOP (3) ProjectID FROM dbo.Project ORDER BY ProjectID", con))
                using (var reader = cmd.ExecuteReader()) { int i = 0; while (reader.Read()) ids[i++] = reader.GetInt32(0); Check(i == 3, "Need three projects."); }
                string projects = "<projects><id>" + ids[0] + "</id><id>" + ids[1] + "</id><id>" + ids[2] + "</id></projects>";
                var watch = Stopwatch.StartNew();
                using (var tx = con.BeginTransaction())
                {
                    int trackingBefore = Scalar(con, tx, "SELECT COUNT(*) FROM OnlineTracking.dbo.UserProjectConfiguration WHERE UserID=@User", user);
                    Save(con, tx, sql, user, user, projects);
                    Check(Scalar(con, tx, "SELECT COUNT(*) FROM dbo.UserProjectConfiguration WHERE UserID=@User", user) == 3, "Expected three ERP rights.");
                    Check(Scalar(con, tx, "SELECT COUNT(*) FROM OnlineTracking.dbo.UserProjectConfiguration WHERE UserID=@User", user) == trackingBefore + 3, "Trigger did not replicate all three rights.");
                    int firstId = Scalar(con, tx, "SELECT MIN(UserProjectID) FROM dbo.UserProjectConfiguration WHERE UserID=@User", user);
                    Save(con, tx, sql, user, user, projects);
                    Check(Scalar(con, tx, "SELECT MIN(UserProjectID) FROM dbo.UserProjectConfiguration WHERE UserID=@User", user) == firstId, "Unchanged rights recreated.");
                    Check(Scalar(con, tx, "SELECT COUNT(*) FROM OnlineTracking.dbo.UserProjectConfiguration WHERE UserID=@User", user) == trackingBefore + 3, "Unchanged rights replicated again.");
                    Save(con, tx, sql, user, user, "<projects><id>" + ids[0] + "</id></projects>");
                    Check(Scalar(con, tx, "SELECT COUNT(*) FROM dbo.UserProjectConfiguration WHERE UserID=@User", user) == 1, "Removal failed.");
                    Save(con, tx, sql, user, user, "<projects/>");
                    Check(Scalar(con, tx, "SELECT COUNT(*) FROM dbo.UserProjectConfiguration WHERE UserID=@User", user) == 0, "Clear-all failed.");
                    tx.Rollback();
                    Check(Scalar(con, null, "SELECT COUNT(*) FROM dbo.UserProjectConfiguration WHERE UserID=@User", user) == 0, "Rollback failed.");
                }
                Console.WriteLine("PASS: three rights and three trigger copies; unchanged rights retained without duplicate copies; removal; clear-all; rolled back. Elapsed: " + watch.ElapsedMilliseconds + " ms.");
            }
            return 0;
        }
        catch (Exception ex) { Console.WriteLine("FAIL: " + ex.GetBaseException().Message); return 1; }
    }
}
