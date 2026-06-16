using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class SegmentUpdates : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllEmployees()
        {
            DataTable dt1 = new bllMaster().GetAllEmployeeDetails();
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
        public static string GetAllSegments()
        {
            DataTable dt1 = new bllMaster().GetAllSegments();
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
        public static string UpdateSegmentBulk(List<int> empIds, string newSegment)
        {
            using (SqlConnection con = new SqlConnection(SQLHelper.ConnectionString))
            {
                con.Open();

                foreach (int empId in empIds)
                {
                    // 🔹 Get current segment
                    SqlCommand getCmd = new SqlCommand("SELECT Segment FROM EmployeeInfo WHERE EmployeeID=@EmpID", con);
                    getCmd.Parameters.AddWithValue("@EmpID", empId);

                    object oldSegObj = getCmd.ExecuteScalar();
                    string oldSegment = oldSegObj != null ? oldSegObj.ToString() : "";

                    // 🔹 Only update if changed
                    if (oldSegment != newSegment)
                    {
                        // 🔹 Insert history
                        SqlCommand histCmd = new SqlCommand(@"
                    INSERT INTO EmployeeSegmentHistory
                    (EmployeeID, OldSegment, NewSegment, ChangedBy)
                    VALUES (@EmpID, @OldSeg, @NewSeg, @User)", con);

                        histCmd.Parameters.AddWithValue("@EmpID", empId);
                        histCmd.Parameters.AddWithValue("@OldSeg", oldSegment);
                        histCmd.Parameters.AddWithValue("@NewSeg", newSegment);
                        histCmd.Parameters.AddWithValue("@User", HttpContext.Current.Session["UserName"]);

                        histCmd.ExecuteNonQuery();

                        // 🔹 Update main table
                        SqlCommand updCmd = new SqlCommand(@"
                                            UPDATE EmployeeInfo 
                                            SET Segment = @NewSeg 
                                            WHERE EmployeeID = @EmpID", con);

                        updCmd.Parameters.AddWithValue("@NewSeg", newSegment);
                        updCmd.Parameters.AddWithValue("@EmpID", empId);

                        updCmd.ExecuteNonQuery();
                    }
                }
            }

            return "Success";
        }
    }
}