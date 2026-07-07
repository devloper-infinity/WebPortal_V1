using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Feedback
{
    public partial class SectionAndFieldMaster : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetDomains()
        {
            return ToRows(new bllFeedback().GetAllDomain());
        }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetProjects(int domainId)
        {
            return ToRows(new bllFeedback().GetAllProjectByDomainWise(domainId, CurrentEmployeeId()));
        }

        [WebMethod(EnableSession = true)]
        public static List<Dictionary<string, object>> GetSectionFields()
        {
            return ToRows(new bllFeedback().GetFeedbackSectionAndField());
        }

        [WebMethod(EnableSession = true)]
        public static SectionFieldResult SaveSectionField(SectionFieldModel model)
        {
            if (model == null)
                return SectionFieldResult.Fail("Invalid section field data.");
            if (model.DomainID <= 0)
                return SectionFieldResult.Fail("Please select Domain.");
            if (model.ProjectID <= 0)
                return SectionFieldResult.Fail("Please select Project.");
            if (string.IsNullOrWhiteSpace(model.Section))
                return SectionFieldResult.Fail("Please enter Section.");
            if (string.IsNullOrWhiteSpace(model.FieldName))
                return SectionFieldResult.Fail("Please enter Field Name.");
            if (string.IsNullOrWhiteSpace(model.Weightage))
                return SectionFieldResult.Fail("Please enter Weightage.");

            Hashtable values = new Hashtable();
            values["DomainID"] = model.DomainID;
            values["ProjectID"] = model.ProjectID;
            values["Section"] = model.Section.Trim();
            values["Field"] = model.FieldName.Trim();
            values["Weightage"] = model.Weightage.Trim();

            bllFeedback bll = new bllFeedback();
            int result;
            if (model.SectionFieldID > 0)
            {
                values["ID"] = model.SectionFieldID;
                values["Domain"] = model.DomainID;
                values["Project"] = model.ProjectID;
                values["UpdatedBy"] = CurrentEmployeeId();
                result = bll.UpdateSectionAndField(values);
                return result > 0
                    ? SectionFieldResult.Ok("Section and Field updated successfully.")
                    : SectionFieldResult.Fail("Section and Field already exists.");
            }

            values["AddedBy"] = CurrentEmployeeId();
            result = bll.InsertSectionAndField(values);
            return result > 0
                ? SectionFieldResult.Ok("Section and Field added successfully.")
                : SectionFieldResult.Fail("Section and Field already added.");
        }

        [WebMethod(EnableSession = true)]
        public static SectionFieldResult DeleteSectionField(int id)
        {
            if (id <= 0)
                return SectionFieldResult.Fail("Invalid Section Field.");

            int result = new bllFeedback().DeleteSectionAndField(id, CurrentEmployeeId());
            return result > 0
                ? SectionFieldResult.Ok("Section and Field deleted successfully.")
                : SectionFieldResult.Fail("Unable to delete Section and Field.");
        }

        private static int CurrentEmployeeId()
        {
            int employeeId;
            return int.TryParse(Convert.ToString(HttpContext.Current.User.Identity.Name), out employeeId) ? employeeId : 0;
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;

            foreach (DataRow dataRow in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                    row[column.ColumnName] = dataRow[column] == DBNull.Value ? null : dataRow[column];
                rows.Add(row);
            }

            return rows;
        }
    }

    public class SectionFieldModel
    {
        public int SectionFieldID { get; set; }
        public int DomainID { get; set; }
        public int ProjectID { get; set; }
        public string Section { get; set; }
        public string FieldName { get; set; }
        public string Weightage { get; set; }
    }

    public class SectionFieldResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }

        public static SectionFieldResult Ok(string message)
        {
            return new SectionFieldResult { Success = true, Message = message };
        }

        public static SectionFieldResult Fail(string message)
        {
            return new SectionFieldResult { Success = false, Message = message };
        }
    }
}
