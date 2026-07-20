using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Admin
{
    public partial class InfinityFeedback : System.Web.UI.Page
    {
        static string From_Date;
        static string To_Date;
        static string Sub_Domain;


        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllFeedbackByDateRange_NewFormat(string FromDate, string ToDate, string SubDomain)
        {
            FromDate = (Convert.ToDateTime(FromDate)).ToString("dd-MMM-yyyy");
            ToDate = (Convert.ToDateTime(ToDate)).ToString("dd-MMM-yyyy");

            From_Date = FromDate;
            To_Date = ToDate;
            Sub_Domain = SubDomain;

            DataTable dt1 = new bllMaster().GetAllFeedbackByDateRange_NewFormat(FromDate, ToDate, SubDomain);

            List<Dictionary<string, object>> columns = new List<Dictionary<string, object>>();
            Dictionary<string, object> column;

            if (dt1 != null)
            {
                foreach (DataColumn dc in dt1.Columns)
                {
                    column = new Dictionary<string, object>();
                }
            }

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static string GetUserInfo()
        {
            DataTable dt1 = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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


        protected void btnExportFeedback_Click(object sender, EventArgs e)
        {
            try
            {
                // Call the same method used to load feedback data.
                DataTable dt = new bllMaster().GetAllFeedbackByDateRange_NewFormat(From_Date, To_Date, Sub_Domain);

                if (dt == null || dt.Rows.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "NoData", "Swal.fire({icon:'warning',title:'No Data',text:'No records are available to export.'});", true);
                    return;
                }

                // Remove columns that should not be exported.
                RemoveColumnIfExists(dt, "FeedbackID");

                ExportDataTableToExcel(dt, "Feedback_Details");
            }
            catch (Exception ex)
            {
                string message = ex.Message.Replace("'", "\\'");

                ScriptManager.RegisterStartupScript(this, GetType(), "ExportError", "Swal.fire({icon:'error',title:'Export Failed',text:'" + message + "'});", true);
            }
        }

        private void ExportDataTableToExcel(DataTable dt, string fileName)
        {
            GridView gvExport = new GridView();

            gvExport.AllowPaging = false;
            gvExport.AllowSorting = false;
            gvExport.AutoGenerateColumns = true;
            gvExport.DataSource = dt;
            gvExport.DataBind();

            gvExport.HeaderStyle.Font.Bold = true;
            gvExport.HeaderStyle.BackColor = System.Drawing.Color.LightGray;

            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.ContentType = "application/vnd.ms-excel";

            Response.AddHeader(
                "content-disposition",
                "attachment;filename=" +
                fileName +
                "_" +
                DateTime.Now.ToString("ddMMyyyy_HHmmss") +
                ".xls"
            );

            using (StringWriter stringWriter = new StringWriter())
            {
                using (HtmlTextWriter htmlWriter = new HtmlTextWriter(stringWriter))
                {
                    gvExport.RenderControl(htmlWriter);
                    Response.Write(stringWriter.ToString());
                    Response.Flush();
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
            }
        }

        private void RemoveColumnIfExists(DataTable dt, string columnName)
        {
            if (dt.Columns.Contains(columnName))
            {
                dt.Columns.Remove(columnName);
            }
        }
    }
}