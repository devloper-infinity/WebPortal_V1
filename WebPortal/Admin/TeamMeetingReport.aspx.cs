using System;
using System.Data;
using System.IO;
using System.Web.Services;
using ClosedXML.Excel;

namespace WebPortal.Admin
{
    public partial class TeamMeetingReport : TeamMeetingPageBase
    {
        protected void Page_Load(object sender, EventArgs e) { if (Request.QueryString["export"] == "1") Export(); }
        [WebMethod(EnableSession = true)] public static string Bootstrap() { return Json(Repo.Lookup(UserID)); }
        [WebMethod(EnableSession = true)] public static string Search(string fromDate, string toDate, string meetingType, int hostEmployeeId, int teamId) { return Json(Repo.Report(UserID, Date(fromDate), Date(toDate), meetingType, hostEmployeeId, teamId)); }
        private void Export()
        {
            var t = Repo.Report(UserID, Date(Request.QueryString["from"]), Date(Request.QueryString["to"]), Request.QueryString["type"], ParseInt(Request.QueryString["host"]), ParseInt(Request.QueryString["team"]));
            using (var workbook = new XLWorkbook())
            using (var stream = new MemoryStream())
            {
                var sheet = workbook.Worksheets.Add("Meeting History");
                sheet.Cell(1, 1).InsertTable(t, "MeetingHistory", true);
                sheet.SheetView.FreezeRows(1);
                sheet.Columns().AdjustToContents(10, 50);
                workbook.SaveAs(stream);
                Response.Clear();
                Response.Buffer = true;
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition", "attachment;filename=TeamMeetingReport_" + DateTime.Now.ToString("yyyyMMddHHmm") + ".xlsx");
                Response.BinaryWrite(stream.ToArray());
                Response.End();
            }
        }
        private static int ParseInt(string x) { int v; return Int32.TryParse(x, out v) ? v : 0; }
    }
}
