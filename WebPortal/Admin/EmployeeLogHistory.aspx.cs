using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class EmployeeLogHistory : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            string code = Convert.ToString(Request.QueryString["Code"]).Trim();
            if (string.IsNullOrWhiteSpace(code))
            {
                Response.Redirect("EmployeeInformation.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            BindEmployee(code);
            BindCycles(code);
        }

        private void BindEmployee(string code)
        {
            txtCode.Text = code;
            int employeeId = new bllMaster().GetEmployeeIdFromCode(code);
            DataTable employee = new bllLogin().GetUserInformation(employeeId);
            if (employee != null && employee.Rows.Count > 0)
                txtName.Text = Convert.ToString(employee.Rows[0]["FullName"]);
        }

        private void BindCycles(string code)
        {
            DataTable cycles = ExecuteHistoryQuery(@"
WITH History AS
(
 SELECT [Date],P_Day,1 SourcePriority FROM infinityus.dbo.Salary_Detail WITH (NOLOCK) WHERE User_Code=@Code
 UNION ALL SELECT [Date],P_Day,2 FROM infinityus.dbo.last_Salary_Detail WITH (NOLOCK) WHERE User_Code=@Code
 UNION ALL SELECT [Date],P_Day,3 FROM infinityus.dbo.last_last_Salary_Detail WITH (NOLOCK) WHERE User_Code=@Code
), ValidHistory AS
(
 SELECT CONVERT(datetime,[Date]) AttendanceDate,P_Day,ROW_NUMBER() OVER(PARTITION BY CONVERT(datetime,[Date]) ORDER BY SourcePriority) RowNo
 FROM History WHERE ISDATE([Date])=1
), Cycles AS
(
 SELECT DATEADD(day,24,DATEADD(month,DATEDIFF(month,0,CASE WHEN DAY(AttendanceDate)>=26 THEN DATEADD(month,1,AttendanceDate) ELSE AttendanceDate END),0)) CycleEnd,
 MAX(CASE WHEN ISNULL(P_Day,0)>0 THEN AttendanceDate END) LastPresentDate
 FROM ValidHistory WHERE RowNo=1
 GROUP BY DATEADD(day,24,DATEADD(month,DATEDIFF(month,0,CASE WHEN DAY(AttendanceDate)>=26 THEN DATEADD(month,1,AttendanceDate) ELSE AttendanceDate END),0))
)
SELECT CycleEnd,LastPresentDate FROM Cycles ORDER BY CycleEnd DESC;", code);

            ddlSalaryCycle.Items.Clear();
            DateTime? preferredCycle = null;
            foreach (DataRow row in cycles.Rows)
            {
                DateTime cycleEnd = Convert.ToDateTime(row["CycleEnd"]);
                DateTime cycleStart = cycleEnd.AddMonths(-1).AddDays(1);
                ddlSalaryCycle.Items.Add(new ListItem(cycleStart.ToString("dd-MMM-yyyy") + " to " + cycleEnd.ToString("dd-MMM-yyyy"), cycleEnd.ToString("yyyy-MM")));
                if (!preferredCycle.HasValue && row["LastPresentDate"] != DBNull.Value) preferredCycle = cycleEnd;
            }
            if (preferredCycle.HasValue && ddlSalaryCycle.Items.FindByValue(preferredCycle.Value.ToString("yyyy-MM")) != null)
                ddlSalaryCycle.SelectedValue = preferredCycle.Value.ToString("yyyy-MM");
        }

        [WebMethod]
        public static string GetLogs(string Code, string Cycle)
        {
            DateTime cycleEnd;
            if (string.IsNullOrWhiteSpace(Code) || !DateTime.TryParseExact(Cycle + "-25", "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out cycleEnd)) return "[]";
            DateTime cycleStart = cycleEnd.AddMonths(-1).AddDays(1);
            DataTable logs = ExecuteHistoryQuery(@"
WITH History AS
(
 SELECT User_Code,[Date],In_Time,Out_Time2,Total_hrs,Extra_Hours,Let_Mark,P_Day,Remark,Remark_Admin,1 SourcePriority FROM infinityus.dbo.Salary_Detail WITH (NOLOCK) WHERE User_Code=@Code
 UNION ALL SELECT User_Code,[Date],In_Time,Out_Time2,Total_hrs,Extra_Hours,Let_Mark,P_Day,Remark,Remark_Admin,2 FROM infinityus.dbo.last_Salary_Detail WITH (NOLOCK) WHERE User_Code=@Code
 UNION ALL SELECT User_Code,[Date],In_Time,Out_Time2,Total_hrs,Extra_Hours,Let_Mark,P_Day,Remark,Remark_Admin,3 FROM infinityus.dbo.last_last_Salary_Detail WITH (NOLOCK) WHERE User_Code=@Code
), Ranked AS
(
 SELECT User_Code,CONVERT(datetime,[Date]) AttendanceDate,In_Time,Out_Time2,Total_hrs,Extra_Hours,Let_Mark,P_Day,Remark,Remark_Admin,
        ROW_NUMBER() OVER(PARTITION BY CONVERT(datetime,[Date]) ORDER BY SourcePriority) RowNo
 FROM History WHERE ISDATE([Date])=1 AND CONVERT(datetime,[Date]) BETWEEN @FromDate AND @ToDate
), Calendar AS
(
 SELECT CONVERT(datetime,@FromDate) AttendanceDate
 UNION ALL
 SELECT DATEADD(day,1,AttendanceDate) FROM Calendar WHERE AttendanceDate<@ToDate
)
SELECT @Code Code,
       CONVERT(varchar(11),c.AttendanceDate,106) [Date],
       ISNULL(CONVERT(nvarchar(50),r.In_Time),'') [In Time],
       ISNULL(CONVERT(nvarchar(50),r.Out_Time2),'') [Out Time],
       ISNULL(CONVERT(nvarchar(50),r.Total_hrs),'') [Total Hours],
       ISNULL(CONVERT(nvarchar(50),r.Extra_Hours),'') [Extra Hours],
       ISNULL(CONVERT(nvarchar(50),r.Let_Mark),'') [Latemark],
       ISNULL(CONVERT(nvarchar(50),r.P_Day),'') [Partial],
       ISNULL(CONVERT(nvarchar(500),r.Remark),'') [Shift Remark],
       ISNULL(CONVERT(nvarchar(500),r.Remark_Admin),'') [PM/ System Remark]
FROM Calendar c
LEFT JOIN Ranked r ON r.AttendanceDate=c.AttendanceDate AND r.RowNo=1
ORDER BY c.AttendanceDate
OPTION (MAXRECURSION 40);", Code, cycleStart, cycleEnd);

            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow dr in logs.Rows)
            {
                var row = new Dictionary<string, object>();
                foreach (DataColumn col in logs.Columns) row[col.ColumnName] = dr[col] == DBNull.Value ? "" : dr[col];
                rows.Add(row);
            }
            return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(rows);
        }

        private static DataTable ExecuteHistoryQuery(string sql, string code, DateTime? fromDate = null, DateTime? toDate = null)
        {
            var result = new DataTable();
            using (var connection = new SqlConnection(SQLHelper.ConnectionString))
            using (var command = new SqlCommand(sql, connection))
            using (var adapter = new SqlDataAdapter(command))
            {
                command.Parameters.Add("@Code", SqlDbType.NVarChar, 20).Value = code;
                if (fromDate.HasValue) command.Parameters.Add("@FromDate", SqlDbType.Date).Value = fromDate.Value.Date;
                if (toDate.HasValue) command.Parameters.Add("@ToDate", SqlDbType.Date).Value = toDate.Value.Date;
                adapter.Fill(result);
            }
            return result;
        }
    }
}
