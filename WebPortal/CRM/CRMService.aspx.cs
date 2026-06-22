using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.CRM
{
    public partial class CRMService : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetDashboard()
        {
            DataSet ds = new bllCRM().GetDashboard(CurrentEmployeeID());
            return Serialize(DataSetToObject(ds, "Summary", "Pipeline", "Today", "FreshLeads", "Recent", "Reminders"));
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetReports()
        {
            DataSet ds = new bllCRM().GetReports(CurrentEmployeeID());
            return Serialize(DataSetToObject(ds, "Forecast", "LeadFunnel", "OwnerActivity"));
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetLookups()
        {
            DataSet ds = new bllCRM().GetLookups(CurrentEmployeeID());
            Dictionary<string, object> result = DataSetToObject(ds, "LeadSources", "LeadStatuses", "DealStages", "ActivityTypes", "ActivityStatuses", "Accounts", "Contacts", "Leads");
            result["Owners"] = EmployeeLookupRows();
            return Serialize(result);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetRecords(string entity, string searchText, string filterValue, int ownerId)
        {
            DataTable dt = new bllCRM().GetRecords(entity, searchText, filterValue, ownerId, CurrentEmployeeID());
            return Serialize(DataTableToRows(dt));
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetRecord(string entity, int recordId)
        {
            DataSet ds = new bllCRM().GetRecord(entity, recordId, CurrentEmployeeID());
            return Serialize(DataSetToObject(ds, "Record", "Notes", "Activities"));
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveRecord(string entity, string payloadJson)
        {
            Hashtable values = JsonToHashtable(payloadJson);
            values["AddedBy"] = CurrentEmployeeID();
            int result = new bllCRM().SaveRecord(entity, values);
            return Serialize(Result(result));
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveNote(string relatedEntity, int relatedRecordId, string noteTitle, string noteText)
        {
            Hashtable values = new Hashtable();
            values["NoteID"] = 0;
            values["RelatedEntity"] = relatedEntity;
            values["RelatedRecordID"] = relatedRecordId;
            values["NoteTitle"] = noteTitle;
            values["NoteText"] = noteText;
            values["AddedBy"] = CurrentEmployeeID();

            int result = new bllCRM().SaveRecord("Note", values);
            return Serialize(Result(result));
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteRecord(string entity, int recordId)
        {
            int result = new bllCRM().DeleteRecord(entity, recordId, CurrentEmployeeID());
            return Serialize(Result(result));
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string ConvertLead(int leadId, string dealName, string amount, string closeDate)
        {
            int result = new bllCRM().ConvertLead(leadId, dealName, amount, closeDate, CurrentEmployeeID());
            return Serialize(Result(result));
        }

        private static int CurrentEmployeeID()
        {
            int employeeId;
            string value = HttpContext.Current != null && HttpContext.Current.User != null && HttpContext.Current.User.Identity != null
                ? HttpContext.Current.User.Identity.Name
                : string.Empty;
            return int.TryParse(value, out employeeId) ? employeeId : 0;
        }

        private static Hashtable JsonToHashtable(string payloadJson)
        {
            Hashtable values = new Hashtable();
            if (string.IsNullOrWhiteSpace(payloadJson))
            {
                return values;
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            Dictionary<string, object> payload = serializer.Deserialize<Dictionary<string, object>>(payloadJson);
            if (payload == null)
            {
                return values;
            }

            foreach (KeyValuePair<string, object> item in payload)
            {
                values[item.Key] = item.Value == null ? string.Empty : item.Value.ToString();
            }

            return values;
        }

        private static Dictionary<string, object> Result(int result)
        {
            Dictionary<string, object> values = new Dictionary<string, object>();
            values["Result"] = result;
            values["Success"] = result > 0;
            return values;
        }

        private static Dictionary<string, object> DataSetToObject(DataSet ds, params string[] names)
        {
            Dictionary<string, object> result = new Dictionary<string, object>();
            for (int i = 0; i < names.Length; i++)
            {
                result[names[i]] = ds != null && ds.Tables.Count > i ? DataTableToRows(ds.Tables[i]) : new List<Dictionary<string, object>>();
            }
            return result;
        }

        private static List<Dictionary<string, object>> EmployeeLookupRows()
        {
            DataTable dt = new bllMaster().GetAllEmployeeDetails_Dynamic();
            List<Dictionary<string, object>> rows = DataTableToRows(dt);

            foreach (Dictionary<string, object> row in rows)
            {
                object id = FirstValue(row, "EmployeeID", "EMPID", "EmpID", "ID", "Id");
                object code = FirstValue(row, "Code", "EmployeeCode", "EmpCode");
                object name = FirstValue(row, "Name", "NAME", "EmployeeName", "UserName");

                row["EmployeeID"] = id == null ? 0 : id;
                row["Code"] = code == null ? string.Empty : code;
                row["DisplayName"] = (code == null || code.ToString() == string.Empty ? string.Empty : code + " : ") + (name == null ? string.Empty : name.ToString());
            }

            return rows;
        }

        private static object FirstValue(Dictionary<string, object> row, params string[] keys)
        {
            foreach (string key in keys)
            {
                if (row.ContainsKey(key))
                {
                    return row[key];
                }
            }

            return null;
        }

        private static List<Dictionary<string, object>> DataTableToRows(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (dt == null)
            {
                return rows;
            }

            foreach (DataRow dr in dt.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row[col.ColumnName] = dr[col] == DBNull.Value ? null : dr[col];
                }
                rows.Add(row);
            }

            return rows;
        }

        private static string Serialize(object value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(value);
        }
    }
}
