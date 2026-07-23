using System.Data;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllProjectTracking
    {
        private readonly dalProjectTracking dalProjectTracking = new dalProjectTracking();

        public DataTable GetFieldConfigurations(int projectId)
        {
            return dalProjectTracking.GetFieldConfigurations(projectId);
        }

        public DataTable GetSheetFieldConfigurations(int projectId)
        {
            return dalProjectTracking.GetSheetFieldConfigurations(projectId);
        }

        public void EnsureProjectBillingFields(int projectId, int userId)
        {
            dalProjectTracking.EnsureProjectBillingFields(projectId, userId);
        }

        public int SaveFieldConfiguration(int fieldConfigId, int projectId, string fieldName, string dataType, string optionsText, bool isRequired, bool isUniqueField, bool isVisible, bool isEditable, bool isForBilling, int displayOrder, bool isProcessColumn, string dateFormat, int userId)
        {
            return dalProjectTracking.SaveFieldConfiguration(fieldConfigId, projectId, fieldName, dataType, optionsText, isRequired, isUniqueField, isVisible, isEditable, isForBilling, displayOrder, isProcessColumn, dateFormat, userId);
        }


        public int SaveFieldConfiguration(int fieldConfigId, int projectId, string fieldName, string dataType, string optionsText, bool isRequired, bool isVisible, bool isEditable, bool isForBilling, int displayOrder, bool isProcessColumn, string dateFormat, int userId)
        {
            return SaveFieldConfiguration(fieldConfigId, projectId, fieldName, dataType, optionsText, isRequired, false, isVisible, isEditable, isForBilling, displayOrder, isProcessColumn, dateFormat, userId);
        }
        public int MoveFieldSequence(int projectId, int fieldConfigId, string direction, int userId)
        {
            return dalProjectTracking.MoveFieldSequence(projectId, fieldConfigId, direction, userId);
        }

        public int UpdateGeneratedStatusOptions(int fieldConfigId, string optionsText, int userId)
        {
            return dalProjectTracking.UpdateGeneratedStatusOptions(fieldConfigId, optionsText, userId);
        }

        public int CreateProjectConfigurationReplica(int sourceProjectId, int targetProjectId, int userId)
        {
            return dalProjectTracking.CreateProjectConfigurationReplica(sourceProjectId, targetProjectId, userId);
        }

        public int DeleteFieldConfiguration(int fieldConfigId, int userId)
        {
            return dalProjectTracking.DeleteFieldConfiguration(fieldConfigId, userId);
        }

        public DataTable GetProjectTrackingRows(int projectId, string fromDate, string toDate)
        {
            return dalProjectTracking.GetProjectTrackingRows(projectId, fromDate, toDate);
        }

        public int SaveProjectTrackingRow(int projectId, int rowId, string entryDate, DataTable values, int userId)
        {
            return dalProjectTracking.SaveProjectTrackingRow(projectId, rowId, entryDate, values, userId);
        }

        public int DeleteProjectTrackingRow(int rowId, int userId)
        {
            return dalProjectTracking.DeleteProjectTrackingRow(rowId, userId);
        }

        public DataTable GetReportFields(int projectId)
        {
            return dalProjectTracking.GetReportFields(projectId);
        }

        public DataTable GetProjectTrackingReportData(int projectId, string fromDate, string toDate)
        {
            return dalProjectTracking.GetProjectTrackingReportData(projectId, fromDate, toDate);
        }

        public DataTable GetProjectTrackingSummaryData(int projectId, string fromDate, string toDate)
        {
            return dalProjectTracking.GetProjectTrackingSummaryData(projectId, fromDate, toDate);
        }
    }
}
