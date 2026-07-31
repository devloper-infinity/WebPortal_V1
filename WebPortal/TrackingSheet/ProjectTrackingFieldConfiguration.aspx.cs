using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.TrackingSheet
{
    public partial class ProjectTrackingFieldConfiguration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetProjects()
        {
            return SerializeDataTable(new bllMaster().GetAllProject());
        }

        [WebMethod]
        public static string GetFields(int projectId)
        {
            bllProjectTracking tracking = new bllProjectTracking();
            tracking.EnsureProjectBillingFields(projectId, GetCurrentUserId());
            DataTable fields = tracking.GetFieldConfigurations(projectId);
            DataTable importFlags = new bllOLTrackingImport().GetImportFlags(projectId);
            fields.Columns.Add("IsForImport", typeof(bool));

            foreach (DataRow field in fields.Rows)
            {
                field["IsForImport"] = false;
                DataRow[] matches = importFlags.Select("FieldConfigId = " + Convert.ToInt32(field["FieldConfigId"]));
                if (matches.Length > 0)
                {
                    field["IsForImport"] = Convert.ToBoolean(matches[0]["IsForImport"]);
                }
            }
            return SerializeDataTable(fields);
        }

        [WebMethod]
        public static int SaveField(int fieldConfigId, int projectId, string fieldName, string dataType, string optionsText, bool isRequired, bool isUniqueField, bool isVisible, bool isEditable, bool isForBilling, bool isBillingParameter, bool isForImport, int displayOrder, bool isProcessColumn, string dateFormat)
        {
            int savedFieldId = new bllProjectTracking().SaveFieldConfiguration(
                fieldConfigId,
                projectId,
                fieldName,
                dataType,
                optionsText,
                isRequired,
                isUniqueField,
                isVisible,
                isEditable,
                isForBilling,
                isBillingParameter,
                displayOrder,
                isProcessColumn,
                dateFormat,
                GetCurrentUserId());

            if (savedFieldId > 0)
            {
                new bllOLTrackingImport().SaveImportFlag(savedFieldId, projectId, isForImport, GetCurrentUserId());
            }
            return savedFieldId;
        }

        [WebMethod]
        public static int MoveField(int projectId, int fieldConfigId, string direction)
        {
            return new bllProjectTracking().MoveFieldSequence(projectId, fieldConfigId, direction, GetCurrentUserId());
        }

        [WebMethod]
        public static int SaveStatusOptions(int fieldConfigId, string optionsText)
        {
            return new bllProjectTracking().UpdateGeneratedStatusOptions(fieldConfigId, optionsText, GetCurrentUserId());
        }

        [WebMethod]
        public static int CreateReplica(int sourceProjectId, int targetProjectId)
        {
            return new bllProjectTracking().CreateProjectConfigurationReplica(sourceProjectId, targetProjectId, GetCurrentUserId());
        }

        [WebMethod]
        public static int DeleteField(int fieldConfigId)
        {
            return new bllProjectTracking().DeleteFieldConfiguration(fieldConfigId, GetCurrentUserId());
        }

        private static int GetCurrentUserId()
        {
            return int.Parse(HttpContext.Current.User.Identity.Name);
        }

        private static string SerializeDataTable(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(rows);
        }
    }
}
