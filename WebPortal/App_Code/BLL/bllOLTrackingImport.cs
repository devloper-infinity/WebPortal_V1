using System;
using System.Data;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public sealed class bllOLTrackingImport
    {
        private readonly dalOLTrackingImport dal = new dalOLTrackingImport();

        public DataTable GetImportFlags(int projectId)
        {
            return dal.GetImportFlags(projectId);
        }

        public DataTable GetImportFields(int projectId)
        {
            return dal.GetImportFields(projectId);
        }

        public DataTable GetBillingParameterFields(int projectId)
        {
            return dal.GetBillingParameterFields(projectId);
        }

        public DataTable GetTrackingReportFields(int projectId)
        {
            return dal.GetTrackingReportFields(projectId);
        }

        public DataTable GetTrackingReportRows(int projectId, DateTime fromDate, DateTime toDate)
        {
            return dal.GetTrackingReportRows(projectId, fromDate, toDate);
        }

        public void SaveImportFlag(int fieldConfigId, int projectId, bool isForImport, int userId)
        {
            dal.SaveImportFlag(fieldConfigId, projectId, isForImport, userId);
        }

        public long ImportRows(int projectId, string originalFileName, DataTable values, int userId)
        {
            return dal.ImportRows(projectId, originalFileName, values, userId);
        }

        public DataTable GetRecentImports(int userId)
        {
            return dal.GetRecentImports(userId);
        }
        public DataTable UpdateExistingBillingRows(
          int projectId,
          string originalFileName,
          DataTable values,
          int userId)
        {
            if (projectId <= 0)
                throw new ArgumentException("A valid project is required.", "projectId");

            if (userId <= 0)
                throw new ArgumentException("A valid user is required.", "userId");

            if (values == null || values.Rows.Count == 0)
                throw new ArgumentException("No billing parameter rows were supplied.", "values");

            string[] requiredColumns =
            {
                "ImportRowNumber", "ProjectID", "Project", "DealNo", "LoanNo",
                "OrderDate", "DispatchDate", "FieldConfigId", "FieldName", "FieldValue"
            };

            foreach (string columnName in requiredColumns)
            {
                if (!values.Columns.Contains(columnName))
                    throw new ArgumentException("The import table is missing column '" + columnName + "'.", "values");
            }

            foreach (DataRow row in values.Rows)
            {
                if (row["ProjectID"] == DBNull.Value || Convert.ToInt32(row["ProjectID"]) != projectId)
                    throw new InvalidOperationException("The uploaded data contains a row for a different project.");
            }

            return dal.UpdateExistingBillingRows(
                projectId,
                originalFileName,
                values,
                userId);
        }
    }
}
