using ClosedXML.Excel;
using Newtonsoft.Json;
using Spire.Xls;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class UserPerformanceHrReport : System.Web.UI.Page
    {
        static string FileName = "";
        static Workbook book = new Workbook();
        static Worksheet sheet;
        static string From_Date;
        static string To_Date;

        protected void Page_Load(object sender, EventArgs e)
        {

            //if (Request.QueryString["download"] == "1")
            //{
            //    byte[] fileBytes = (byte[])Session["ExcelFile"];

            //    Response.Clear();
            //    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            //    Response.AddHeader("content-disposition", "attachment; filename=HR_UserPerformance.xlsx");
            //    Response.BinaryWrite(fileBytes);
            //    Response.End();
            //}
        }

        private static int GetCurrentEmployeeId()
        {
            int employeeId;
            string identityName = Convert.ToString(HttpContext.Current.User.Identity.Name);

            if (int.TryParse(identityName, out employeeId))
                return employeeId;

            string localEmployeeId = ConfigurationManager.AppSettings["LocalEmployeeID"];

            if (int.TryParse(localEmployeeId, out employeeId))
                return employeeId;

            throw new InvalidOperationException("Current login identity is not a numeric employee id. Login through the application, or set LocalEmployeeID in Web.config for local debugging.");
        }

        private static string NormalizeReportDate(string value)
        {
            DateTime parsedDate;

            if (DateTime.TryParse(value, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsedDate))
                return parsedDate.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);

            return value;
        }

        private static List<Dictionary<string, object>> ToRows(DataTable dt)
        {
            if (dt == null)
                return new List<Dictionary<string, object>>();

            return dt.AsEnumerable()
                .Select(row => dt.Columns.Cast<DataColumn>()
                    .ToDictionary(col => col.ColumnName, col => row[col] == DBNull.Value ? null : row[col]))
                .ToList();
        }

        [WebMethod]
        public static object GetUserPerformanceFeedbackDetailsNonDD(string type, string tab, string FromDate, string EndDate)
        {
          DataTable  dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_NonDD(NormalizeReportDate(FromDate), NormalizeReportDate(EndDate), GetCurrentEmployeeId());

            return ToRows(dt);
        }

        [WebMethod]
        public static object GetUserPerformanceFeedbackDetailsCredit(string type, string tab, string FromDate, string EndDate)
        {
            DataTable dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Credit(NormalizeReportDate(FromDate), NormalizeReportDate(EndDate), GetCurrentEmployeeId());

            return ToRows(dt);
        }


        public class DataTableRequest
        {
            public int start { get; set; }
            public int length { get; set; }
            public int draw { get; set; }
            public string FromDate { get; set; }
            public string EndDate { get; set; }
            public string type { get; set; }
            public string tab { get; set; }
        }

        [WebMethod]
        public static string GetHRUserData_Server(DataTableRequest req)
        {
            try
            {
                int employeeId = GetCurrentEmployeeId();
                req.FromDate = NormalizeReportDate(req.FromDate);
                req.EndDate = NormalizeReportDate(req.EndDate);

                DataTable dt = new DataTable();// new bllMaster().GetUserPerformanceProdDetails_HR_NonDD(req.FromDate,req.EndDate,int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                if (req.type == "nondd")
                {
                    if (req.tab == "summary")
                        dt = new bllMaster().GetUserPerformanceReport_HR_NonDD(req.FromDate, req.EndDate, employeeId);

                    else if (req.tab == "production")
                        dt = new bllMaster().GetUserPerformanceProdDetails_HR_NonDD(req.FromDate, req.EndDate, employeeId);

                    else if (req.tab == "feedback")
                        dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_NonDD(req.FromDate, req.EndDate, employeeId);

                    else if (req.tab == "attendance")
                        //   dt = new bllMaster().GetUserPerformanceAttendanceDetails_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        dt = new bllMaster().GetUserPerformanceAttendanceDetails(req.FromDate, req.EndDate, employeeId);
                }

                else if (req.type == "credit")
                {
                    if (req.tab == "summary")
                        dt = new bllMaster().GetUserPerformanceReport_HR_Credit(req.FromDate, req.EndDate, employeeId);

                    else if (req.tab == "production")
                        dt = new bllMaster().GetUserPerformanceProdDetails_HR_Credit(req.FromDate, req.EndDate, employeeId);

                    else if (req.tab == "feedback")
                        dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Credit(req.FromDate, req.EndDate, employeeId);

                    else if (req.tab == "attendance")
                        //  dt = new bllMaster().GetUserPerformanceAttendanceDetails_HR_Credit(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        dt = new bllMaster().GetUserPerformanceAttendanceDetails(req.FromDate, req.EndDate,  employeeId);
                }

                else if (req.type == "servicing")
                {
                    if (req.tab == "summary")
                        dt = new bllMaster().GetUserPerformanceReport_HR_Servicing(req.FromDate, req.EndDate, employeeId);

                    else if (req.tab == "production")
                        dt = new bllMaster().GetUserPerformanceProdDetails_HR_Servicing(req.FromDate, req.EndDate, employeeId);

                    else if (req.tab == "feedback")
                        dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Servicing(req.FromDate, req.EndDate, employeeId);

                    else if (req.tab == "attendance")
                        dt = new bllMaster().GetUserPerformanceAttendanceDetails(req.FromDate, req.EndDate,  employeeId);
                                                                                                          // dt = new bllMaster().GetUserPerformanceAttendanceDetails_HR_Servicing(FromDate, EndDate, 7171);// int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                }


                if (dt == null)
                    dt = new DataTable();

                int totalRecords = dt.Rows.Count;

                var pagedData = dt.AsEnumerable().Skip(req.start).Take(req.length);

                var data = pagedData.Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

                var result = new
                {
                    draw = req.draw,
                    recordsTotal = totalRecords,
                    recordsFiltered = totalRecords,
                    data = data
                };

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { error = ex.Message });
            }
        }



        [WebMethod]
        public static object GetHRUserData(string type, string tab, string FromDate, string EndDate)
        {
            try
            {
                int employeeId = GetCurrentEmployeeId();
                FromDate = NormalizeReportDate(FromDate);
                EndDate = NormalizeReportDate(EndDate);

                DataTable dt = new DataTable();

                // 👉 Call your BLL based on tab
                if (type == "nondd")
                {
                    if (tab == "summary")
                        dt = new bllMaster().GetUserPerformanceReport_HR_NonDD(FromDate, EndDate, employeeId);

                    else if (tab == "production")
                        dt = new bllMaster().GetUserPerformanceProdDetails_HR_NonDD(FromDate, EndDate, employeeId);

                    else if (tab == "feedback")
                        dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_NonDD(FromDate, EndDate, employeeId);

                    else if (tab == "attendance")
                        //   dt = new bllMaster().GetUserPerformanceAttendanceDetails_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        dt = new bllMaster().GetUserPerformanceAttendanceDetails(FromDate, EndDate, employeeId);
                }

                else if (type == "credit")
                {
                    if (tab == "summary")
                        dt = new bllMaster().GetUserPerformanceReport_HR_Credit(FromDate, EndDate, employeeId);

                    else if (tab == "production")
                        dt = new bllMaster().GetUserPerformanceProdDetails_HR_Credit(FromDate, EndDate, employeeId);

                    else if (tab == "feedback")
                        dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Credit(FromDate, EndDate, employeeId);

                    else if (tab == "attendance")
                        //  dt = new bllMaster().GetUserPerformanceAttendanceDetails_HR_Credit(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                        dt = new bllMaster().GetUserPerformanceAttendanceDetails(FromDate, EndDate, employeeId);
                }

                else if (type == "servicing")
                {
                    if (tab == "summary")
                        dt = new bllMaster().GetUserPerformanceReport_HR_Servicing(FromDate, EndDate, employeeId);

                    else if (tab == "production")
                        dt = new bllMaster().GetUserPerformanceProdDetails_HR_Servicing(FromDate, EndDate, employeeId);

                    else if (tab == "feedback")
                        dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Servicing(FromDate, EndDate, employeeId);

                    else if (tab == "attendance")
                        dt = new bllMaster().GetUserPerformanceAttendanceDetails(FromDate, EndDate, employeeId);
                                                                                                          // dt = new bllMaster().GetUserPerformanceAttendanceDetails_HR_Servicing(FromDate, EndDate, 7171);// int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                }

                return ToRows(dt);

                //List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
                //Dictionary<string, object> row;
                //foreach (DataRow dr in dt.Rows)
                //{
                //    row = new Dictionary<string, object>();
                //    foreach (DataColumn col in dt.Columns)
                //    {
                //        row.Add(col.ColumnName, dr[col]);
                //    }
                //    rows.Add(row);
                //}
                //JavaScriptSerializer ser = new JavaScriptSerializer();
                //ser.MaxJsonLength = int.MaxValue;
                //return ser.Serialize(rows);
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }
        }
       
        [WebMethod]
        public static void StartExport(string FromDate, string ToDate)
        {
            HttpContext.Current.Session["ExportStep"] = 0;

            //HttpContext.Current.Session["FromDate"] = FromDate;
            //HttpContext.Current.Session["ToDate"] = ToDate;

            From_Date = NormalizeReportDate(FromDate);
            To_Date = NormalizeReportDate(ToDate);

            GenerateExcel();
        }

        [WebMethod]
        public static int GetExportProgress()
        {
           
            if (HttpContext.Current.Session["ExportStep"] != null)
                return Convert.ToInt32(HttpContext.Current.Session["ExportStep"]);
            else
                return 0;
        }

        public static void GenerateExcel()
        {
            XLWorkbook workbook = new XLWorkbook();

            // NonDD
            HttpContext.Current.Session["ExportStep"] = 1;
            GenerateNonDDSummary(workbook);

            HttpContext.Current.Session["ExportStep"] = 2;
            GenerateNonDDProduction(workbook);

            HttpContext.Current.Session["ExportStep"] = 3;
            GenerateNonDDFeedback(workbook);

            HttpContext.Current.Session["ExportStep"] = 4;
            GenerateNonDDAttendance(workbook);

            // Credit
            HttpContext.Current.Session["ExportStep"] = 5;
            GenerateCreditSummary(workbook);

            HttpContext.Current.Session["ExportStep"] = 6;
            GenerateCreditProduction(workbook);

            HttpContext.Current.Session["ExportStep"] = 7;
            GenerateCreditFeedback(workbook);

            HttpContext.Current.Session["ExportStep"] = 8;
            GenerateCreditAttendance(workbook);

            // Servicing
            HttpContext.Current.Session["ExportStep"] = 9;
            GenerateServicingSummary(workbook);

            HttpContext.Current.Session["ExportStep"] = 10;
            GenerateServicingProduction(workbook);

            HttpContext.Current.Session["ExportStep"] = 11;
            GenerateServicingFeedback(workbook);

            HttpContext.Current.Session["ExportStep"] = 12;
            GenerateServicingAttendance(workbook);

            // Final Save
            HttpContext.Current.Session["ExportStep"] = 13;
            SaveExcelFile(workbook);
        }

        public static void SaveExcelFile(XLWorkbook workbook)
        {
            using (MemoryStream memoryStream = new MemoryStream())
            {
                workbook.SaveAs(memoryStream);
                HttpContext.Current.Session["ExcelFile"] = memoryStream.ToArray();
            }
        }

        public static void GenerateNonDDSummary(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceReport_HR_NonDD(From_Date, To_Date, GetCurrentEmployeeId());

            var ws = workbook.Worksheets.Add("NonDD Summary");

            ws.Cell(1, 1).InsertTable(dt);

            ws.Columns().AdjustToContents();
        }

        public static void GenerateNonDDProduction(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceProdDetails_HR_NonDD(From_Date, To_Date, GetCurrentEmployeeId());

            var ws = workbook.Worksheets.Add("NonDD Production");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }

        public static void GenerateNonDDFeedback(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_NonDD(From_Date, To_Date, GetCurrentEmployeeId());

            var ws = workbook.Worksheets.Add("NonDD Feedback");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }

        public static void GenerateNonDDAttendance(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceAttendanceDetails(From_Date, To_Date, GetCurrentEmployeeId());
            //   dt = new bllMaster().GetUserPerformanceAttendanceDetails_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            var ws = workbook.Worksheets.Add("NonDD Attendance");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }

        public static void GenerateCreditSummary(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceReport_HR_Credit(From_Date, To_Date, GetCurrentEmployeeId());

            var ws = workbook.Worksheets.Add("Credit Summary");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }

        public static void GenerateCreditProduction(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceProdDetails_HR_Credit(From_Date, To_Date, GetCurrentEmployeeId());

            var ws = workbook.Worksheets.Add("Credit Production");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }

        public static void GenerateCreditFeedback(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Credit(From_Date, To_Date, GetCurrentEmployeeId());

            var ws = workbook.Worksheets.Add("Credit Feedback");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }

        public static void GenerateCreditAttendance(XLWorkbook workbook)
        {
            DataTable dt = //new bllMaster().GetUserPerformanceAttendanceDetails_HR_Credit(From_Date, To_Date, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            dt = new bllMaster().GetUserPerformanceAttendanceDetails(From_Date, To_Date, GetCurrentEmployeeId());

            var ws = workbook.Worksheets.Add("Credit Attendance");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }

        public static void GenerateServicingSummary(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceReport_HR_Servicing(
                From_Date, To_Date,
                GetCurrentEmployeeId()
            );

            var ws = workbook.Worksheets.Add("Servicing Summary");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }

        public static void GenerateServicingProduction(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceProdDetails_HR_Servicing(From_Date, To_Date, GetCurrentEmployeeId());

            var ws = workbook.Worksheets.Add("Servicing Production");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }

        public static void GenerateServicingFeedback(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Servicing(From_Date, To_Date, GetCurrentEmployeeId());

            var ws = workbook.Worksheets.Add("Servicing Feedback");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }

        public static void GenerateServicingAttendance(XLWorkbook workbook)
        {
            DataTable dt = new bllMaster().GetUserPerformanceAttendanceDetails(From_Date, To_Date, GetCurrentEmployeeId());
            //GetUserPerformanceAttendanceDetails_Servicing

            var ws = workbook.Worksheets.Add("Servicing Attendance");
            ws.Cell(1, 1).InsertTable(dt);
            ws.Columns().AdjustToContents();
        }


        #region Old DataTable  Methods

        /* ----------- Non-DD ----------- */
        [WebMethod]
        public static string GetUserPerformanceReport_NonDD(string FromDate, string EndDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceReport_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceProdDetails_NonDD(string FromDate, string EndDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceProdDetails_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceFeedbackDetails_NonDD(string FromDate, string EndDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceFeedbackDetails_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceAttendanceDetails_NonDD(string FromDate, string EndDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceAttendanceDetails_HR_NonDD(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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


        /* ----------- Credit ----------- */
        [WebMethod]
        public static string GetUserPerformanceReport_Credit(string FromDate, string EndDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceReport_HR_Credit(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceProdDetails_Credit(string FromDate, string EndDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceProdDetails_HR_Credit(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceFeedbackDetails_Credit(string FromDate, string EndDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Credit(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceAttendanceDetails_Credit(string FromDate, string EndDate)/*GetUserPerformanceAttendanceDetails_HR_Credit*/
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceAttendanceDetails(FromDate, EndDate, 7171);//(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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

        /* ----------- Servicing ----------- */
        [WebMethod]
        public static string GetUserPerformanceReport_Servicing(string FromDate, string EndDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceReport_HR_Servicing(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceProdDetails_Servicing(string FromDate, string EndDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceProdDetails_HR_Servicing(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceFeedbackDetails_Servicing(string FromDate, string EndDate)
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceFeedbackDetails_HR_Servicing(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetUserPerformanceAttendanceDetails_Servicing(string FromDate, string EndDate) /*GetUserPerformanceAttendanceDetails_HR_Servicing*/
        {
            DataTable dt1 = new bllMaster().GetUserPerformanceAttendanceDetails(FromDate, EndDate, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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

        #endregion
    }
}
