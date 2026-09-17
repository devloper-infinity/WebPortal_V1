using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Services;
using WebPortal.App_Code;
namespace WebPortal.Admin
{
 public partial class RNRFeedback:System.Web.UI.Page
 {
  protected void Page_Load(object sender,EventArgs e){var id=RnrSecurity.EmployeeId;}
  private static List<Dictionary<string,object>> Rows(DataTable t){return t.Rows.Cast<DataRow>().Select(r=>t.Columns.Cast<DataColumn>().ToDictionary(c=>c.ColumnName,c=>r[c]==DBNull.Value?null:r[c])).ToList();}
  [WebMethod] public static object Load(){int employee=RnrSecurity.EmployeeId;var repository=new RnrFeedbackRepository();long assignment=repository.PendingAssignment(employee);if(assignment==0)return null;var data=repository.Form(assignment,employee);if(data.Tables[0].Rows.Count==0)return null;return new{Header=Rows(data.Tables[0])[0],Questions=Rows(data.Tables[1]),Options=Rows(data.Tables[2])};}
  [WebMethod] public static void Submit(long assignmentId,List<RnrAnswerInput> answers){new RnrFeedbackRepository().Submit(assignmentId,RnrSecurity.EmployeeId,answers,RnrSecurity.Ip);}
 }
}
