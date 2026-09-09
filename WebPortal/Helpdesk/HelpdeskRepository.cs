using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Web;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Helpdesk
{
    internal sealed class HelpdeskRepository
    {
        private static SqlCommand Command(string procedure)
        {
            var c = new SqlCommand(procedure) { CommandType = CommandType.StoredProcedure, CommandTimeout = 120 };
            return c;
        }
        private static void Add(SqlCommand c, string name, object value) { c.Parameters.AddWithValue(name, value ?? DBNull.Value); }
        private static DataSet Query(SqlCommand c)
        {
            var ds = new DataSet();
            using (var cn = new SqlConnection(SQLHelper.ConnectionString))
            using (c) { c.Connection = cn; using (var da = new SqlDataAdapter(c)) da.Fill(ds); }
            return ds;
        }
        private static int Execute(SqlCommand c)
        {
            using (var cn = new SqlConnection(SQLHelper.ConnectionString))
            using (c) { c.Connection = cn; cn.Open(); return c.ExecuteNonQuery(); }
        }
        public DataSet Masters(int employeeId) { var c = Command("IHMS_Master_Data"); Add(c,"@EmployeeID",employeeId); return Query(c); }
        public DataSet People()
        {
            var c = new SqlCommand(@"
SELECT DISTINCT CONVERT(int,e.EmployeeID) EmployeeID,
       LTRIM(RTRIM(ISNULL(e.Code,'') + ' : ' + ISNULL(e.FirstName,'') + ' ' + ISNULL(e.lastName,''))) DisplayName
FROM dbo.EmployeeInfo e
JOIN dbo.IHMS_UserRole r ON r.EmployeeID=e.EmployeeID AND r.IsActive=1
WHERE r.RoleCode IN ('ITUser','ITHead','HelpdeskAdmin')
ORDER BY DisplayName;
SELECT DISTINCT CONVERT(int,e.EmployeeID) EmployeeID,
       LTRIM(RTRIM(ISNULL(e.Code,'') + ' : ' + ISNULL(e.FirstName,'') + ' ' + ISNULL(e.lastName,''))) DisplayName
FROM dbo.EmployeeInfo e
WHERE e.EmployeeID IN (12,291,216)
ORDER BY DisplayName;
SELECT CONVERT(int,BranchID) BranchID,BranchName FROM dbo.Branch ORDER BY BranchName;") { CommandType = CommandType.Text };
            return Query(c);
        }
        public DataSet Dashboard(int employeeId) { var c = Command("IHMS_Dashboard"); Add(c,"@EmployeeID",employeeId); return Query(c); }
        public DataSet Ticket(long ticketId,int employeeId)
        {
            var c=Command("IHMS_Ticket_Get");Add(c,"@TicketID",ticketId);Add(c,"@EmployeeID",employeeId);
            var result=Query(c); var people=People(); var names=new Dictionary<string,string>();
            foreach(DataTable table in people.Tables) foreach(DataRow row in table.Rows)
                if(table.Columns.Contains("EmployeeID")&&table.Columns.Contains("DisplayName")) names[Convert.ToString(row["EmployeeID"])]=Convert.ToString(row["DisplayName"]);
            if(result.Tables.Count>1) foreach(DataRow row in result.Tables[1].Rows)
            {
                var actor=Convert.ToString(row["PerformedBy"]); if(String.IsNullOrWhiteSpace(Convert.ToString(row["PerformedName"]))&&names.ContainsKey(actor)) row["PerformedName"]=names[actor];
                if(Convert.ToString(row["ActivityType"])=="Assignment")
                {
                    var oldValue=Convert.ToString(row["OldValue"]); var newValue=Convert.ToString(row["NewValue"]);
                    if(names.ContainsKey(oldValue)) row["OldValue"]=names[oldValue]; if(names.ContainsKey(newValue)) row["NewValue"]=names[newValue];
                }
            }
            return result;
        }
        public DataTable Tickets(int employeeId,string scope,string status,string ticketNo,DateTime? from,DateTime? to,int? requestType,string priority,int? assigned,string source,string approval)
        { var c=Command("IHMS_Ticket_List");Add(c,"@EmployeeID",employeeId);Add(c,"@Scope",scope);Add(c,"@StatusCode",Empty(status));Add(c,"@TicketNo",Empty(ticketNo));Add(c,"@FromDate",from);Add(c,"@ToDate",to);Add(c,"@RequestTypeID",requestType);Add(c,"@PriorityCode",Empty(priority));Add(c,"@AssignedTo",assigned);Add(c,"@Source",Empty(source));Add(c,"@ApprovalStatus",Empty(approval));var table=Query(c).Tables[0];AddEmployeeDisplay(table,"AssignedToEmployeeID","AssignedEmployee");return table; }
        public DataTable Create(int employeeId,string name,string email,string department,string location,string deskNo,string subject,string description,int? requestType,string priority)
        { var c=Command("IHMS_Ticket_Create");Add(c,"@RequestorEmployeeID",employeeId);Add(c,"@RequestorName",name);Add(c,"@RequestorEmail",email);Add(c,"@Department",department);Add(c,"@Location",location);Add(c,"@DeskNo",deskNo);Add(c,"@Subject",subject);Add(c,"@Description",description);Add(c,"@RequestTypeID",requestType);Add(c,"@PriorityCode",priority);Add(c,"@Source","Portal");Add(c,"@CreatedBy",employeeId);var output=c.Parameters.Add("@TicketID",SqlDbType.BigInt);output.Direction=ParameterDirection.Output;return Query(c).Tables[0]; }
        public int Assign(long id,int to,int by){var c=Command("IHMS_Ticket_Assign");Add(c,"@TicketID",id);Add(c,"@ToEmployeeID",to);Add(c,"@ByEmployeeID",by);return Execute(c);}
        public int ChangeType(long id,int type,int employee){var c=Command("IHMS_Ticket_ChangeType");Add(c,"@TicketID",id);Add(c,"@RequestTypeID",type);Add(c,"@EmployeeID",employee);return Execute(c);}
        public int ChangeLocation(long id,string location,int employee){var c=Command("IHMS_Ticket_ChangeLocation");Add(c,"@TicketID",id);Add(c,"@Location",location);Add(c,"@EmployeeID",employee);return Execute(c);}
        public int Remark(long id,int employee,string name,string remark,bool internalNote){var c=Command("IHMS_Ticket_AddRemark");Add(c,"@TicketID",id);Add(c,"@EmployeeID",employee);Add(c,"@EmployeeName",name);Add(c,"@Remark",remark);Add(c,"@IsInternal",internalNote);return Execute(c);}
        public int Transition(long id,string status,int employee,string remark){var c=Command("IHMS_Ticket_Transition");Add(c,"@TicketID",id);Add(c,"@StatusCode",status);Add(c,"@EmployeeID",employee);Add(c,"@Remark",remark);return Execute(c);}
        public int RequestApproval(long id,int approver,int employee,string remark){var c=Command("IHMS_Approval_Request");Add(c,"@TicketID",id);Add(c,"@ApproverEmployeeID",approver);Add(c,"@EmployeeID",employee);Add(c,"@Remark",remark);return Execute(c);}
        public DataTable Approvals(int employee,string decision){var c=Command("IHMS_Approval_List");Add(c,"@EmployeeID",employee);Add(c,"@Decision",Empty(decision));return Query(c).Tables[0];}
        public int Decide(long approval,int employee,string decision,string remark){var c=Command("IHMS_Approval_Decide");Add(c,"@ApprovalID",approval);Add(c,"@EmployeeID",employee);Add(c,"@Decision",decision);Add(c,"@Remark",remark);return Execute(c);}
        public int SaveType(int id,string name,string description,bool approval,bool active,int order,int employee){var c=Command("IHMS_RequestType_Save");Add(c,"@RequestTypeID",id);Add(c,"@Name",name);Add(c,"@Description",description);Add(c,"@ApprovalRequired",approval);Add(c,"@IsActive",active);Add(c,"@DisplayOrder",order);Add(c,"@EmployeeID",employee);return Execute(c);}
        public int SaveSla(string priority,int first,int resolution,bool active,int employee){var c=Command("IHMS_SLA_Save");Add(c,"@PriorityCode",priority);Add(c,"@FirstResponseMinutes",first);Add(c,"@ResolutionMinutes",resolution);Add(c,"@IsActive",active);Add(c,"@EmployeeID",employee);return Execute(c);}
        public DataTable Performance(DateTime from,DateTime to,int? employee,int? type,string priority){var c=Command("IHMS_Performance");Add(c,"@FromDate",from);Add(c,"@ToDate",to);Add(c,"@EmployeeID",employee);Add(c,"@RequestTypeID",type);Add(c,"@PriorityCode",Empty(priority));var table=Query(c).Tables[0];AddEmployeeDisplay(table,"EmployeeID","Employee");return table;}
        private static void AddEmployeeDisplay(DataTable table,string idColumn,string displayColumn)
        {
            table.Columns.Add(displayColumn,typeof(string));
            using(var c=new SqlCommand("SELECT CONVERT(varchar(20),EmployeeID) EmployeeID,LTRIM(RTRIM(ISNULL(Code,'')+' : '+ISNULL(FirstName,'')+' '+ISNULL(lastName,''))) DisplayName FROM dbo.EmployeeInfo") { CommandType=CommandType.Text })
            {
                var names=Query(c).Tables[0].AsEnumerable().ToDictionary(r=>Convert.ToString(r["EmployeeID"]),r=>Convert.ToString(r["DisplayName"]));
                foreach(DataRow row in table.Rows){var id=Convert.ToString(row[idColumn]);row[displayColumn]=names.ContainsKey(id)?names[id]:(String.IsNullOrEmpty(id)?"Unassigned":id);}
            }
        }
        public long AddAttachment(long ticketId,int employee,string original,string stored,string contentType,long size,string path,bool internalNote)
        { using(var cn=new SqlConnection(SQLHelper.ConnectionString))using(var c=new SqlCommand("INSERT dbo.IHMS_TicketAttachment(TicketID,OriginalFileName,StoredFileName,ContentType,FileSize,StoragePath,IsInternal,UploadedBy) OUTPUT INSERTED.AttachmentID VALUES(@t,@o,@s,@c,@z,@p,@i,@u); INSERT dbo.IHMS_TicketActivity(TicketID,ActivityType,NewValue,IsInternal,PerformedBy) VALUES(@t,'Attachment',@o,@i,@u);",cn)){c.Parameters.AddWithValue("@t",ticketId);c.Parameters.AddWithValue("@o",original);c.Parameters.AddWithValue("@s",stored);c.Parameters.AddWithValue("@c",(object)contentType??DBNull.Value);c.Parameters.AddWithValue("@z",size);c.Parameters.AddWithValue("@p",path);c.Parameters.AddWithValue("@i",internalNote);c.Parameters.AddWithValue("@u",employee);cn.Open();return Convert.ToInt64(c.ExecuteScalar());}}
        private static object Empty(string value){return String.IsNullOrWhiteSpace(value)?null:(object)value.Trim();}
    }

    public abstract class HelpdeskPage : System.Web.UI.Page
    {
        protected static int UserId { get { int id; if(HttpContext.Current==null||HttpContext.Current.User==null||!Int32.TryParse(HttpContext.Current.User.Identity.Name,out id)) throw new HttpException(401,"Login required."); return id; } }
        protected static EmployeeInfo Employee { get { return EmployeeInfo.Current; } }
        protected static string Json(DataTable value){return HelpdeskJson.Serialize(value);}
        protected static string Json(DataSet value){return HelpdeskJson.Serialize(value);}
        protected static void Required(string value,string label,int max){if(String.IsNullOrWhiteSpace(value))throw new ArgumentException(label+" is required.");if(value.Length>max)throw new ArgumentException(label+" is too long.");}
    }
}
