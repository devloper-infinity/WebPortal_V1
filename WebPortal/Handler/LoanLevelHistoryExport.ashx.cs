using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Web;
using WebPortal.App_Code.DAL;

namespace WebPortal.Handler
{
    public class LoanLevelHistoryExport : IHttpHandler
    {
        public bool IsReusable { get { return false; } }

        public void ProcessRequest(HttpContext context)
        {
            if (context.User == null || !context.User.Identity.IsAuthenticated)
            {
                context.Response.StatusCode = 401;
                return;
            }

            int projectId;
            if (!int.TryParse(context.Request.QueryString["ProjectID"], out projectId))
                projectId = 0;

            DateTime fromDate;
            DateTime toDate;
            if (!DateTime.TryParse(context.Request.QueryString["FromDate"], CultureInfo.InvariantCulture, DateTimeStyles.None, out fromDate)
                || !DateTime.TryParse(context.Request.QueryString["ToDate"], CultureInfo.InvariantCulture, DateTimeStyles.None, out toDate))
            {
                context.Response.StatusCode = 400;
                context.Response.Write("Invalid date range.");
                return;
            }

            context.Response.Clear();
            context.Response.BufferOutput = false;
            context.Response.ContentType = "text/csv";
            context.Response.ContentEncoding = new UTF8Encoding(true);
            context.Response.AddHeader("Content-Disposition", "attachment; filename=LoanTrackingHistory_"
                + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".csv");

            using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
            using (SqlCommand command = new SqlCommand("dbo.usp_GetLoanLevelSecRelTracking", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 0;
                command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                command.Parameters.Add("@FromDate", SqlDbType.NVarChar, 100).Value = fromDate.ToString("yyyy-MM-dd");
                command.Parameters.Add("@ToDate", SqlDbType.NVarChar, 100).Value = toDate.ToString("yyyy-MM-dd");
                command.Parameters.Add("@Start", SqlDbType.Int).Value = 0;
                command.Parameters.Add("@PageSize", SqlDbType.Int).Value = 10;
                command.Parameters.Add("@SearchValue", SqlDbType.NVarChar, 200).Value = context.Request.QueryString["SearchValue"] ?? string.Empty;
                command.Parameters.Add("@ExportAll", SqlDbType.Bit).Value = true;

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader(CommandBehavior.SequentialAccess))
                {
                    if (!reader.NextResult())
                        return;

                    WriteRow(context, reader, true);
                    while (reader.Read())
                        WriteRow(context, reader, false);
                }
            }
        }

        private static void WriteRow(HttpContext context, SqlDataReader reader, bool header)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (i > 0) context.Response.Write(",");
                string value = header ? reader.GetName(i) : Convert.ToString(reader.GetValue(i), CultureInfo.InvariantCulture);
                if (!header && value.Length > 0 && "=+-@".IndexOf(value[0]) >= 0)
                    value = "'" + value;
                context.Response.Write("\"" + value.Replace("\"", "\"\"") + "\"");
            }
            context.Response.Write("\r\n");
        }
    }
}
