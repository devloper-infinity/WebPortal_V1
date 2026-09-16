using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.Services;
using WebPortal.App_Code;
namespace WebPortal.Admin
{
 public partial class RNRReport:System.Web.UI.Page
 {
  protected void Page_Load(object sender,EventArgs e){RnrSecurity.RequireHr();if(Request.QueryString["export"]=="1")Export();}
  private static List<Dictionary<string,object>> Rows(DataTable t){return t.Rows.Cast<DataRow>().Select(r=>t.Columns.Cast<DataColumn>().ToDictionary(c=>c.ColumnName,c=>r[c]==DBNull.Value?null:r[c])).ToList();}
  private static DateTime? Date(string s){DateTime d;return DateTime.TryParse(s,out d)?d:(DateTime?)null;}
  [WebMethod] public static object Lookups(){RnrSecurity.RequireHr();var s=new RnrFeedbackRepository().GetAdminData();return new{Questionnaires=Rows(s.Tables[0]),Domains=Rows(s.Tables[1]),Locations=Rows(s.Tables[2])};}
  [WebMethod] public static object Report(int questionnaire,int domain,int location,int employee,string status,string from,string to){RnrSecurity.RequireHr();var s=new RnrFeedbackRepository().Report(questionnaire,domain,location,employee,status,Date(from),Date(to));return new{Rows=Rows(s.Tables[0]),Counts=Rows(s.Tables[1]).FirstOrDefault()};}
  [WebMethod] public static object Answers(long assignmentId){RnrSecurity.RequireHr();return Rows(new RnrFeedbackRepository().Answers(assignmentId));}
  private void Export(){int q=Int(Request["questionnaire"]),d=Int(Request["domain"]),l=Int(Request["location"]),e=Int(Request["employee"]);var table=new RnrFeedbackRepository().Report(q,d,l,e,Request["status"],Date(Request["from"]),Date(Request["to"])).Tables[0];using(var wb=new XLWorkbook()){wb.Worksheets.Add(table,"RNR Responses");using(var ms=new MemoryStream()){wb.SaveAs(ms);Response.Clear();Response.ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";Response.AddHeader("Content-Disposition","attachment; filename=RNR-Feedback-Report.xlsx");Response.BinaryWrite(ms.ToArray());Response.End();}}}
  private static int Int(string s){int n;return Int32.TryParse(s,out n)?n:0;}
 }
}
