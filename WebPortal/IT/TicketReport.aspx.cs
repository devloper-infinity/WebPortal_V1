using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.IT
{
    public partial class TicketReport : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetTickets(string fromDate, string toDate)
        {
            DateTime from;
            DateTime to;
            if (!DateTime.TryParseExact(fromDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out from) ||
                !DateTime.TryParseExact(toDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out to))
                throw new ArgumentException("Please select valid From and To dates.");
            if (from > to)
                throw new ArgumentException("From Date cannot be later than To Date.");

            int employeeId;
            if (HttpContext.Current.User == null || !HttpContext.Current.User.Identity.IsAuthenticated ||
                !Int32.TryParse(HttpContext.Current.User.Identity.Name, out employeeId))
                throw new HttpException(401, "Your session has expired. Please sign in again.");

            DataTable table = new bllAsset().GetDepartmentWiseTicketReport(
                employeeId,
                from.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture),
                to.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture));

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                    row[column.ColumnName] = dataRow[column] == DBNull.Value ? null : dataRow[column];
                rows.Add(row);
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
            return serializer.Serialize(rows);
        }

        [WebMethod]
        public static string GetTicketRemarks(int ticketId)
        {
            int employeeId;
            if (ticketId <= 0)
                throw new ArgumentException("Invalid ticket.");
            if (HttpContext.Current.User == null || !HttpContext.Current.User.Identity.IsAuthenticated ||
                !Int32.TryParse(HttpContext.Current.User.Identity.Name, out employeeId))
                throw new HttpException(401, "Your session has expired. Please sign in again.");

            DataTable table = new bllAsset().GetAllRemarkTicketwise(ticketId);
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                    row[column.ColumnName] = dataRow[column] == DBNull.Value ? null : dataRow[column];
                rows.Add(row);
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
            return serializer.Serialize(rows);
        }
    }
}
