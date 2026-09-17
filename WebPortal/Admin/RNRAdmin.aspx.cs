using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Services;
using WebPortal.App_Code;

namespace WebPortal.Admin
{
    public partial class RNRAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { RnrSecurity.RequireHr(); }
        private static List<Dictionary<string, object>> Rows(DataTable t) { return t.Rows.Cast<DataRow>().Select(r => t.Columns.Cast<DataColumn>().ToDictionary(c => c.ColumnName, c => r[c] == DBNull.Value ? null : r[c])).ToList(); }
        [WebMethod] public static object Load() { RnrSecurity.RequireHr(); var s = new RnrFeedbackRepository().GetAdminData(); return new { Questionnaires = Rows(s.Tables[0]), Domains = Rows(s.Tables[1]), Locations = Rows(s.Tables[2]), Departments = Rows(s.Tables[3]) }; }
        [WebMethod] public static object GetQuestionnaire(int id) { RnrSecurity.RequireHr(); var s = new RnrFeedbackRepository().GetQuestionnaire(id); return new { Header = Rows(s.Tables[0]).FirstOrDefault(), Questions = Rows(s.Tables[1]), Options = Rows(s.Tables[2]) }; }
        [WebMethod] public static int Save(RnrQuestionnaireInput input) { RnrSecurity.RequireHr(); return new RnrFeedbackRepository().SaveQuestionnaire(input, RnrSecurity.EmployeeId, RnrSecurity.Ip); }
        [WebMethod] public static void SetActive(int questionnaireId, bool active) { RnrSecurity.RequireHr(); new RnrFeedbackRepository().SetActive(questionnaireId, active, RnrSecurity.EmployeeId, RnrSecurity.Ip); }
        [WebMethod] public static object Employees(string domain, int? location, int? department) { RnrSecurity.RequireHr(); return Rows(new RnrFeedbackRepository().Employees(domain, location.GetValueOrDefault(), department.GetValueOrDefault())); }
        [WebMethod] public static int Assign(int questionnaireId, int surveyYear, int quarterMask, List<int> employeeIds) { RnrSecurity.RequireHr(); return new RnrFeedbackRepository().Assign(questionnaireId, surveyYear, quarterMask, employeeIds, RnrSecurity.EmployeeId, RnrSecurity.Ip); }
    }
}
