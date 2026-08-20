using DocumentFormat.OpenXml.VariantTypes;
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
        static DataTable dt_Export;


        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllFeedbackByDateRange_NewFormat_OLD(string FromDate, string ToDate, string SubDomain)
        {
            FromDate = (Convert.ToDateTime(FromDate)).ToString("dd-MMM-yyyy");
            ToDate = (Convert.ToDateTime(ToDate)).ToString("dd-MMM-yyyy");

            From_Date = FromDate;
            To_Date = ToDate;
            Sub_Domain = SubDomain;
            DataTable dt1 = null;
            DataTable dt = new bllMaster().GetAllFeedbackByDateRange_NewFormat(FromDate, ToDate, SubDomain);

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            JavaScriptSerializer ser = new JavaScriptSerializer();


            if (dt.Rows.Count > 0)
            {
                dt_Export = dt;
                try
                {
                    dt1 = dt.AsEnumerable().Where(r => !string.Equals(Convert.ToString(r["Severity"]).Trim(), "No Error", StringComparison.OrdinalIgnoreCase)).CopyToDataTable();

                    if (dt1 != null && dt1.Rows.Count > 0)
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

                        ser.MaxJsonLength = int.MaxValue;
                    }
                }
                catch
                {



                    if (dt1 != null && dt1.Rows.Count > 0)
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

                        ser.MaxJsonLength = int.MaxValue;



                    }
                }
            }
            return ser.Serialize(rows);
        }


        [WebMethod(EnableSession = true)]
        public static object GetAllFeedbackByDateRange_NewFormat(
    string FromDate,
    string ToDate,
    string SubDomain)
        {
            try
            {
                string formattedFromDate = Convert.ToDateTime(FromDate).ToString("dd-MMM-yyyy");
                string formattedToDate = Convert.ToDateTime(ToDate).ToString("dd-MMM-yyyy");

                From_Date = formattedFromDate;
                To_Date = formattedToDate;
                Sub_Domain = SubDomain;

                DataTable dt = new bllMaster().GetAllFeedbackByDateRange_NewFormat(formattedFromDate,formattedToDate,SubDomain);

                List<Dictionary<string, object>> gridRows = new List<Dictionary<string, object>>();

                int exportRecordCount = 0;
                int gridRecordCount = 0;

                if (dt != null && dt.Rows.Count > 0)
                {
                    exportRecordCount = dt.Rows.Count;

                    /*
                     * This table contains all records, including No Error records.
                     * It can be used by the server-side Excel export.
                     */
                    dt_Export = dt.Copy();

                    DataRow[] filteredRows = dt.AsEnumerable().Where(r => !string.Equals(Convert.ToString(r["Severity"]).Trim(), "No Error", StringComparison.OrdinalIgnoreCase)).ToArray();

                    gridRecordCount = filteredRows.Length;

                    foreach (DataRow dr in filteredRows)
                    {
                        Dictionary<string, object> row = new Dictionary<string, object>();

                        foreach (DataColumn column in dt.Columns)
                        {
                            object value = dr[column];

                            row[column.ColumnName] = value == DBNull.Value ? null : value;
                        }

                        gridRows.Add(row);
                    }
                }
                else
                {
                    dt_Export = null;
                }

                bool hasExportData = exportRecordCount > 0;
                bool hasGridData = gridRecordCount > 0;

                string message = "";

                if (!hasExportData)
                {
                    message = "No feedback records are available for the selected criteria.";
                }
                else if (!hasGridData)
                {
                    message = "Records are available, but they are not displayed in the grid because all records have Severity as 'No Error'. You can generate the Excel report to view those records.";
                }

                return new
                {
                    Success = true,
                    GridData = gridRows,
                    HasGridData = hasGridData,
                    HasExportData = hasExportData,
                    GridRecordCount = gridRecordCount,
                    ExportRecordCount = exportRecordCount,
                    Message = message
                };
            }
            catch (Exception ex)
            {
                return new
                {
                    Success = false,
                    GridData = new List<object>(),
                    HasGridData = false,
                    HasExportData = false,
                    GridRecordCount = 0,
                    ExportRecordCount = 0,
                    Message = "An error occurred while loading feedback records.",
                    Error = ex.Message
                };
            }
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

            if (From_Date == null && To_Date == null && Sub_Domain == null)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "NoData", "Swal.fire({icon:'warning',title:'Warning',text:'Please select From Date, To Date and Domain.'});", true);
                return;
            }

            try
            {
                // Call the same method used to load feedback data.
                DataTable dt = dt_Export;// new bllMaster().GetAllFeedbackByDateRange_NewFormat(From_Date, To_Date, Sub_Domain);

                if (dt == null || dt.Rows.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "NoData", "Swal.fire({icon:'warning',title:'No Data',text:'No records are available to export.'});", true);
                    return;
                }

                // Remove columns that should not be exported.
                //RemoveColumnIfExists(dt, "FeedbackID");

                ExportDataTableToExcel(dt, "Feedback_Details");

                dt_Export = null;
            }
            catch (Exception ex)
            {
                string message = ex.Message.Replace("'", "\\'");

                ScriptManager.RegisterStartupScript(this, GetType(), "ExportError", "Swal.fire({icon:'error',title:'Export Failed',text:'" + message + "'});", true);
            }
        }

        private void ExportDataTableToExcel(DataTable dt, string fileName)
        {
            if (dt == null || dt.Rows.Count == 0)
            {
                return;
            }

            GridView gvExport = new GridView();

            gvExport.AllowPaging = false;
            gvExport.AllowSorting = false;
            gvExport.AutoGenerateColumns = false;
            gvExport.GridLines = GridLines.Both;

            // Match Excel headers with table_InfinityFeedback headers
            AddExportColumn(gvExport, "FeedbackID", "FeedbackID");
            AddExportColumn(gvExport, "LoanNumber", "Loan Number");
            AddExportColumn(gvExport, "Client", "Client");
            AddExportColumn(gvExport, "UWName", "UW Name");
            AddExportColumn(gvExport, "QCName", "QC Name");
            AddExportColumn(gvExport, "DateReviewed", "Date Reviewed");
            AddExportColumn(gvExport, "QCDate", "QC Date");
            AddExportColumn(gvExport, "Category", "Category");
            AddExportColumn(gvExport, "Subcategory", "Sub category");
            AddExportColumn(gvExport, "ErrorField", "Error Field");
            AddExportColumn(gvExport, "Screen", "Screen");
            AddExportColumn(gvExport, "ErrorType", "Error Type");
            AddExportColumn(gvExport, "Finding", "Finding");
            AddExportColumn(gvExport, "FeedbackType", "Feedback Type");
            AddExportColumn(gvExport, "Severity", "Severity");
            AddExportColumn(gvExport, "FindingStatus", "Feedback Status");
            AddExportColumn(gvExport, "RCA", "RCARCA/Rebuttal Comments");
            AddExportColumn(gvExport, "RebuttalStatus", "Onshore Rebuttal Response");
            AddExportColumn(gvExport, "RebuttalRemark", "Onshore Rebuttal Comments");
            AddExportColumn(gvExport, "FinalStatus", "Manager Final Status");
            AddExportColumn(gvExport, "FinalComments", "Manager Final Comments");
            AddExportColumn(gvExport, "Source", "Source");
            AddExportColumn(gvExport, "FeedbackReceivedDate", "Feedback Received Date");

            gvExport.DataSource = dt;
            gvExport.DataBind();

            // Header styling
            gvExport.HeaderStyle.Font.Bold = true;
            gvExport.HeaderStyle.BackColor = System.Drawing.Color.FromArgb(10, 122, 155);
            gvExport.HeaderStyle.ForeColor = System.Drawing.Color.White;
            gvExport.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;

            // Cell styling
            gvExport.RowStyle.VerticalAlign = VerticalAlign.Middle;
            gvExport.RowStyle.HorizontalAlign = HorizontalAlign.Left;
            gvExport.RowStyle.Font.Size = 10;

            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.ContentType = "application/vnd.ms-excel";

            string exportFileName = fileName + "_" + DateTime.Now.ToString("ddMMyyyy_HHmmss") + ".xls";

            Response.AddHeader("content-disposition", "attachment;filename=" + exportFileName);
            Response.Write("<html>");
            Response.Write("<head>");
            Response.Write("<meta charset='UTF-8' />");

            Response.Write(@"
        <style>
            table {
                border-collapse: collapse;
                font-family: Arial, sans-serif;
                font-size: 11pt;
            }

            th {
                background-color: #edf3f6;
                font-weight: bold;
                text-align: center;
                white-space: nowrap;
                border: 1px solid #808080;
                padding: 6px;
            }

            td {
                white-space: nowrap;
                border: 1px solid #b7b7b7;
                padding: 7px;
                font-size :10px;
                text-align:left;
                vertical-align: middle;
            }
        </style>
    ");

            Response.Write("</head>");
            Response.Write("<body>");

            using (StringWriter stringWriter = new StringWriter())
            {
                using (HtmlTextWriter htmlWriter =
                       new HtmlTextWriter(stringWriter))
                {
                    gvExport.RenderControl(htmlWriter);
                    Response.Write(stringWriter.ToString());
                }
            }

            Response.Write("</body>");
            Response.Write("</html>");

            Response.Flush();
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }

        private void RemoveColumnIfExists(DataTable dt, string columnName)
        {
            if (dt.Columns.Contains(columnName))
            {
                dt.Columns.Remove(columnName);
            }
        }

        private void AddExportColumn(GridView gridView, string dataField, string headerText)
        {
            BoundField column = new BoundField();

            column.DataField = dataField;
            column.HeaderText = headerText;
            column.HtmlEncode = false;

            gridView.Columns.Add(column);
        }
    }
}