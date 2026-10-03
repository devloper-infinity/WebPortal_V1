using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Reflection;
using System.Security.Principal;
using System.Transactions;
using System.Web;
using WebPortal.Admin;
using WebPortal.App_Code.DAL;

// Integration check against the configured database. All test rows roll back.
class AgreementSingleFileCheck
{
    static void Check(bool condition, string message)
    {
        if (!condition) throw new Exception(message);
    }

    static int Count(SqlConnection connection, string table, string version)
    {
        using (var cmd = new SqlCommand("SELECT COUNT(*) FROM dbo." + table + " WHERE Version = @Version", connection))
        {
            cmd.Parameters.AddWithValue("@Version", version);
            return Convert.ToInt32(cmd.ExecuteScalar());
        }
    }

    static int DocumentCount(SqlConnection connection, string type, string version)
    {
        string table = type == "Version" ? "AgreementVersionHistory" : "AgreementTypeHistory";
        string key = type == "Version" ? "AgrChangeID" : "AgreementTypeID";
        using (var cmd = new SqlCommand("SELECT COUNT(*) FROM dbo.AgreementVersionDocs d JOIN dbo." + table +
            " h ON h." + key + " = d.ChangeID WHERE d.Type = @Type AND h.Version = @Version", connection))
        {
            cmd.Parameters.AddWithValue("@Type", type);
            cmd.Parameters.AddWithValue("@Version", version);
            return Convert.ToInt32(cmd.ExecuteScalar());
        }
    }

    static int Main()
    {
        string version = "UploadCheck-" + Guid.NewGuid().ToString("N");
        string cs = ConfigurationManager.ConnectionStrings["MainCon"].ConnectionString;
        string path = "~/AgreementVersions/2026-10-01/Check's agreement.pdf";
        try
        {
            int userId;
            using (var connection = new SqlConnection(cs))
            {
                connection.Open();
                using (var cmd = new SqlCommand("SELECT TOP (1) EmployeeID FROM dbo.EmployeeInfo ORDER BY EmployeeID", connection))
                    userId = Convert.ToInt32(cmd.ExecuteScalar());
            }
            HttpContext.Current = new HttpContext(new HttpRequest("", "http://localhost/", ""), new HttpResponse(new StringWriter()));
            HttpContext.Current.User = new GenericPrincipal(new GenericIdentity(userId.ToString(), "Test"), new string[0]);
            var dal = new dalMaster();
            var insertDocument = typeof(dalMaster).GetMethod("InsertAgreementVersionDocument", BindingFlags.NonPublic | BindingFlags.Instance);
            using (var scope = new TransactionScope(TransactionScopeOption.Required,
                new TransactionOptions { IsolationLevel = System.Transactions.IsolationLevel.Serializable, Timeout = TimeSpan.FromSeconds(60) }))
            {
                var clauses = new List<AgreementVersionControl.ClauseModel> {
                    new AgreementVersionControl.ClauseModel { ClauseNo = "1", ClauseDetails = version + " first clause" },
                    new AgreementVersionControl.ClauseModel { ClauseNo = "2", ClauseDetails = version + " second clause" },
                    new AgreementVersionControl.ClauseModel { ClauseNo = "3", ClauseDetails = version + " third clause" }
                };
                Check(AgreementVersionControl.SaveAgreement_Versions(version, "2026-10-01", clauses) == "Success", "Multiple clause save failed.");
                using (var connection = new SqlConnection(cs))
                {
                    connection.Open();
                    Check(Count(connection, "AgreementVersionHistory", version) == 3, "Expected three clauses.");
                    Check(DocumentCount(connection, "Version", version) == 0, "Clause loop inserted attachments.");
                    var values = new Hashtable { { "Type", "Version" }, { "Version", version }, { "Path", path }, { "AddedBy", userId } };
                    Check((int)insertDocument.Invoke(dal, new object[] { values, connection, null }) > 0, "Attachment save failed.");
                    Check((int)insertDocument.Invoke(dal, new object[] { values, connection, null }) == -1, "Duplicate attachment accepted.");
                    Check(DocumentCount(connection, "Version", version) == 1, "Expected one attachment for three clauses.");
                }
                // A duplicate must not prevent the following new clause from being inserted.
                Check(AgreementVersionControl.SaveAgreement_Versions(version, "2026-10-01", new List<AgreementVersionControl.ClauseModel> {
                    clauses[0], new AgreementVersionControl.ClauseModel { ClauseNo = "4", ClauseDetails = version + " fourth clause" }
                }) == "Success", "Duplicate clause stopped later insertion.");
                DataTable history = dal.GetAgreementVersionHistory();
                int matching = 0;
                foreach (DataRow row in history.Rows)
                    if (Convert.ToString(row["Version"]) == version)
                    {
                        matching++;
                        Check(Convert.ToString(row["FilePath"]) == path, "Shared download path mismatch.");
                    }
                Check(matching == 4, "Expected all four clauses in history.");
                var types = new List<AgreementVersionControl.TypeData> {
                    new AgreementVersionControl.TypeData { TypeText = "First", MinServicePeriod = "12 months" },
                    new AgreementVersionControl.TypeData { TypeText = "Second", MinServicePeriod = "24 months" }
                };
                Check(AgreementVersionControl.SaveAgreement_Types(version, "2026-10-01", types) == "Success", "Multiple type save failed.");
                using (var connection = new SqlConnection(cs))
                {
                    connection.Open();
                    var values = new Hashtable { { "Type", "Type" }, { "Version", version }, { "Path", path }, { "AddedBy", userId } };
                    Check((int)insertDocument.Invoke(dal, new object[] { values, connection, null }) > 0, "Type attachment failed.");
                    Check((int)insertDocument.Invoke(dal, new object[] { values, connection, null }) == -1, "Duplicate type attachment accepted.");
                    Check(Count(connection, "AgreementTypeHistory", version) == 2, "Expected two types.");
                    Check(DocumentCount(connection, "Type", version) == 1, "Expected one Type Version attachment.");
                }
                // Do not Complete: roll back every test insert.
            }
            using (var connection = new SqlConnection(cs))
            {
                connection.Open();
                Check(Count(connection, "AgreementVersionHistory", version) == 0, "Clause rollback failed.");
                Check(Count(connection, "AgreementTypeHistory", version) == 0, "Type rollback failed.");
            }
            Console.WriteLine("PASS: three clauses / one path; duplicate rejected; fourth clause added after duplicate; shared downloads; two types / one path; all test rows rolled back.");
            return 0;
        }
        catch (Exception ex)
        {
            Console.WriteLine("FAIL: " + ex.GetBaseException().Message);
            return 1;
        }
    }
}
