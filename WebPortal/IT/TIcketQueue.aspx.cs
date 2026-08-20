using System;
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
using ClosedXML.Excel;

namespace WebPortal.IT
{
    public partial class TIcketQueue : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string exportMode = Request.QueryString["export"];
            if (!IsPostBack && (exportMode == "department" || exportMode == "my"))
            {
                ExportTickets(exportMode == "my");
            }
        }

        private void ExportTickets(bool onlyMyQueue)
        {
            int loginEmp = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DataTable source = new bllAsset().GetAllTicketDepartmentwise(loginEmp);
            List<Dictionary<string, object>> rows = BuildTicketRows(source, loginEmp, onlyMyQueue);

            List<KeyValuePair<string, string[]>> columns = new List<KeyValuePair<string, string[]>>
            {
                new KeyValuePair<string, string[]>("Ticket No", new[] { "TicketNo", "Ticket" }),
                new KeyValuePair<string, string[]>("Ticket Raised On", new[] { "RequestDateTime", "RequestDate", "CreatedDate" }),
                new KeyValuePair<string, string[]>("Expected TAT", new[] { "ExpectedTAT", "TAT" }),
                new KeyValuePair<string, string[]>("Code", new[] { "Code", "EmployeeCode" }),
                new KeyValuePair<string, string[]>("Location", new[] { "WorkingBranch", "Location" }),
                new KeyValuePair<string, string[]>("Request Related To", new[] { "RequestB", "Request", "RequestRelatedTo" }),
                new KeyValuePair<string, string[]>("Priority", new[] { "Priority" }),
                new KeyValuePair<string, string[]>("Subject", new[] { "Subject" })
            };
            if (onlyMyQueue)
                columns.Add(new KeyValuePair<string, string[]>("Status", new[] { "Status" }));
            columns.Add(new KeyValuePair<string, string[]>("Elapsed Time", new[] { "ElapsedTime" }));

            using (XLWorkbook workbook = new XLWorkbook())
            {
                IXLWorksheet sheet = workbook.Worksheets.Add(onlyMyQueue ? "My Queue" : "Department Queue");
                for (int columnIndex = 0; columnIndex < columns.Count; columnIndex++)
                    sheet.Cell(1, columnIndex + 1).Value = columns[columnIndex].Key;

                for (int rowIndex = 0; rowIndex < rows.Count; rowIndex++)
                {
                    for (int columnIndex = 0; columnIndex < columns.Count; columnIndex++)
                    {
                        sheet.Cell(rowIndex + 2, columnIndex + 1).Value = GetExportValue(rows[rowIndex], columns[columnIndex].Value);
                    }
                }

                IXLRange exportRange = sheet.Range(1, 1, rows.Count + 1, columns.Count);
                IXLRange headerRange = sheet.Range(1, 1, 1, columns.Count);
                headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#2563EB");
                headerRange.Style.Font.Bold = true;
                headerRange.Style.Font.FontColor = XLColor.White;
                headerRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                headerRange.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                sheet.Row(1).Height = 24;
                exportRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                exportRange.SetAutoFilter();
                sheet.SheetView.FreezeRows(1);
                sheet.Columns().AdjustToContents();
                foreach (IXLColumn column in sheet.ColumnsUsed())
                {
                    if (column.Width < 12) column.Width = 12;
                    if (column.Width > 45) column.Width = 45;
                }
                sheet.Column(columns.FindIndex(c => c.Key == "Subject") + 1).Style.Alignment.WrapText = true;

                using (MemoryStream stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    byte[] file = stream.ToArray();
                    string queueName = onlyMyQueue ? "MyQueue" : "DepartmentQueue";
                    Response.Clear();
                    Response.Buffer = true;
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("Content-Disposition", "attachment; filename=TicketQueue_" + queueName + "_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx");
                    Response.AddHeader("Content-Length", file.Length.ToString());
                    Response.BinaryWrite(file);
                    Response.Flush();
                    Response.End();
                }
            }
        }

        private static string GetExportValue(Dictionary<string, object> row, IEnumerable<string> names)
        {
            foreach (string name in names)
            {
                object value;
                if (row.TryGetValue(name, out value) && value != null && value != DBNull.Value)
                {
                    string text = Convert.ToString(value);
                    if (!String.IsNullOrWhiteSpace(text)) return text;
                }
            }
            return String.Empty;
        }

        [WebMethod]
        public static string GetAllTickets()
        {
            int LoginEmp = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DataTable dt1 = new bllAsset().GetAllTicketDepartmentwise(LoginEmp);
            List<Dictionary<string, object>> rows = BuildTicketRows(dt1, LoginEmp, false);
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        private static List<Dictionary<string, object>> BuildTicketRows(DataTable dt, int LoginEmp, bool onlyMyQueue)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (dt == null) return rows;

            string[] possibleAssignedColumns = new string[] { "AssignTo", "AssignedTo", "AssignToId", "AssignedToId", "AssignedEmpId", "AssignedEmployeeId", "OwnerId", "TechnicianId", "AssigneeId", "AssignToEmpId" };
            string[] possibleAssignedNameColumns = new string[] { "AssignToName", "AssignedToName", "AssignedEmployee", "OwnerName", "TechnicianName", "AssigneeName" };

            foreach (DataRow dr in dt.Rows)
            {
                int assignedTo = 0;
                foreach (string col in possibleAssignedColumns)
                {
                    if (dt.Columns.Contains(col))
                    {
                        int.TryParse(Convert.ToString(dr[col]), out assignedTo);
                        if (assignedTo > 0) break;
                    }
                }

                string assignedName = "";
                foreach (string col in possibleAssignedNameColumns)
                {
                    if (dt.Columns.Contains(col))
                    {
                        assignedName = Convert.ToString(dr[col]);
                        if (!String.IsNullOrWhiteSpace(assignedName)) break;
                    }
                }

                bool isAssigned = assignedTo > 0 || !String.IsNullOrWhiteSpace(assignedName);
                bool isAssignedToMe = assignedTo > 0 && assignedTo == LoginEmp;
                bool canTakeAction = !isAssigned || isAssignedToMe;

                if (onlyMyQueue && !isAssignedToMe) continue;

                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row[col.ColumnName] = dr[col];
                }
                row["LoginEmp"] = LoginEmp;
                row["AssignedToUserId"] = assignedTo;
                row["AssignedToUserName"] = assignedName;
                row["IsAssigned"] = isAssigned;
                row["IsAssignedToMe"] = isAssignedToMe;
                row["CanTakeAction"] = canTakeAction;
                rows.Add(row);
            }
            return rows;
        }

        [WebMethod]
        public static string GetEmpsByDept()
        {
            DataTable dt = new bllLogin().GetUserInformation(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            DataTable dt1 = new bllMaster().GetEmpsByDept(Convert.ToInt32(dt.Rows[0]["Department"]));

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
        public static int AssignTicketToSelf(int TicketID)
        {
            int LoginEmp = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            return new bllAsset().InsertTicketAssignTo(LoginEmp, LoginEmp, TicketID);
        }

        [WebMethod]
        public static string GetMyQueue()
        {
            int LoginEmp = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
            DataTable dt1 = new bllAsset().GetAllTicketDepartmentwise(LoginEmp);
            List<Dictionary<string, object>> rows = BuildTicketRows(dt1, LoginEmp, true);
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static int InsertTicketAssignTo(int AssignTo, int TicketID)
        {
            int ReturnValue = 0;

            ReturnValue = new bllAsset().InsertTicketAssignTo(AssignTo, int.Parse(HttpContext.Current.User.Identity.Name.ToString()), TicketID);

            return ReturnValue;
        }
    }
}
