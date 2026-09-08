using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Salary
{
    public partial class DownloadForm16 : Page
    {
        private const string NotAvailableMessage = "Your Form 16 is not available in system please contact Account Department.";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.Equals(Request.QueryString["action"], "download", StringComparison.OrdinalIgnoreCase))
            {
                int employeeId;
                if (int.TryParse(Request.QueryString["employeeId"], out employeeId))
                {
                    DownloadPdf(employeeId);
                }
            }
        }

        [WebMethod]
        public static string GetEmployees()
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_getEmployeeSalary");
            DataTable dt = SQLHelper.ExecuteDataTableCmd(cmd);

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (DataRow dr in dt.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                row["EmployeeID"] = dr["EmployeeID"];
                row["EmpName"] = dr["EmpName"];
                rows.Add(row);
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(rows);
        }

        [WebMethod]
        public static DownloadResult GetDownloadStatus(int employeeId)
        {
            string filePath = GetForm16FilePath(employeeId);
            return new DownloadResult
            {
                Success = !string.IsNullOrEmpty(filePath),
                Message = string.IsNullOrEmpty(filePath) ? NotAvailableMessage : string.Empty
            };
        }

        private void DownloadPdf(int employeeId)
        {
            string filePath = GetForm16FilePath(employeeId);
            if (string.IsNullOrEmpty(filePath) || !File.Exists(filePath))
            {
                Response.StatusCode = 404;
                Response.ContentType = "text/plain";
                Response.Write(NotAvailableMessage);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            Response.Clear();
            Response.ClearHeaders();
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Disposition", "attachment; filename=\"" + Path.GetFileName(filePath) + "\"");
            Response.AddHeader("Content-Length", new FileInfo(filePath).Length.ToString());
            Response.TransmitFile(filePath);
            Response.Flush();
            Context.ApplicationInstance.CompleteRequest();
        }

        private static string GetForm16FilePath(int employeeId)
        {
            DataTable employee = new bllLogin().GetUserInformation(employeeId);
            if (employee == null || employee.Rows.Count == 0)
                return null;

            string pan = Convert.ToString(employee.Rows[0]["PAN"]).Trim();
            if (string.IsNullOrWhiteSpace(pan))
                return null;

            string form16Directory = HttpContext.Current.Server.MapPath("~/Admin/Form16");
            if (!Directory.Exists(form16Directory))
                return null;

            string[] files = Directory.GetFiles(form16Directory, "*.pdf", SearchOption.TopDirectoryOnly);
            foreach (string file in files)
            {
                if (Path.GetFileName(file).IndexOf(pan, StringComparison.OrdinalIgnoreCase) >= 0)
                    return file;
            }

            return null;
        }

        public class DownloadResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
        }
    }
}
