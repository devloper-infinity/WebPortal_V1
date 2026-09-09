using System;
using System.IO;
using System.Web;
using System.Web.Services;

namespace WebPortal.Helpdesk
{
    public partial class TicketDetails : HelpdeskPage
    {
        protected void Page_Load(object sender, EventArgs e) { if (Request.QueryString["upload"] == "1") Upload(); }
        private void Upload()
        {
            try
            {
                long id;
                if (!Int64.TryParse(Request.Form["ticketId"], out id) || Request.Files.Count != 1) throw new ArgumentException("A ticket and one file are required.");
                var file = Request.Files[0];
                if (file.ContentLength <= 0 || file.ContentLength > 20 * 1024 * 1024) throw new ArgumentException("File must be between 1 byte and 20 MB.");
                var original = Path.GetFileName(file.FileName); var extension = Path.GetExtension(original);
                var blocked = new[] { ".exe", ".dll", ".cmd", ".bat", ".ps1", ".js", ".vbs", ".aspx", ".config" };
                if (Array.IndexOf(blocked, extension.ToLowerInvariant()) >= 0) throw new ArgumentException("That file type is not allowed.");
                var relative = "~/App_Data/IHMS/" + DateTime.UtcNow.ToString("yyyy/MM/"); var folder = Server.MapPath(relative); Directory.CreateDirectory(folder);
                var stored = Guid.NewGuid().ToString("N") + extension; file.SaveAs(Path.Combine(folder, stored));
                new HelpdeskRepository().AddAttachment(id, UserId, original, stored, file.ContentType, file.ContentLength, relative + stored, String.Equals(Request.Form["internalNote"], "true", StringComparison.OrdinalIgnoreCase));
                Response.ContentType = "text/plain"; Response.Write("OK"); Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex) { Response.StatusCode = 400; Response.TrySkipIisCustomErrors = true; Response.Write(ex.Message); Context.ApplicationInstance.CompleteRequest(); }
        }
        [WebMethod] public static string Get(long ticketId) { return Json(new HelpdeskRepository().Ticket(ticketId, UserId)); }
        [WebMethod] public static string Masters() { return Json(new HelpdeskRepository().Masters(UserId)); }
        [WebMethod] public static string People() { return Json(new HelpdeskRepository().People()); }
        [WebMethod] public static int Assign(long ticketId, int employeeId) { return new HelpdeskRepository().Assign(ticketId, employeeId, UserId); }
        [WebMethod] public static int ChangeType(long ticketId, int requestTypeId) { return new HelpdeskRepository().ChangeType(ticketId, requestTypeId, UserId); }
        [WebMethod] public static int ChangeLocation(long ticketId, string location) { Required(location, "Branch", 150); return new HelpdeskRepository().ChangeLocation(ticketId, location, UserId); }
        [WebMethod] public static int AddRemark(long ticketId, string remark, bool internalNote) { Required(remark, "Remark", 10000); return new HelpdeskRepository().Remark(ticketId, UserId, Employee.EmployeeName, remark, internalNote); }
        [WebMethod] public static int Transition(long ticketId, string status, string remark) { Required(status, "Status", 30); return new HelpdeskRepository().Transition(ticketId, status, UserId, remark); }
        [WebMethod] public static int RequestApproval(long ticketId, int approverId, string remark) { if (approverId <= 0) throw new ArgumentException("Approver is required."); return new HelpdeskRepository().RequestApproval(ticketId, approverId, UserId, remark); }
    }
}
