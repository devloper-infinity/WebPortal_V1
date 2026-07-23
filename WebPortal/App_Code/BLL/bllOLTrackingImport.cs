using System.Data;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public sealed class bllOLTrackingImport
    {
        private readonly dalOLTrackingImport dal = new dalOLTrackingImport();

        public DataTable GetImportFlags(int projectId) { return dal.GetImportFlags(projectId); }
        public DataTable GetImportFields(int projectId) { return dal.GetImportFields(projectId); }
        public void SaveImportFlag(int fieldConfigId, int projectId, bool isForImport, int userId) 
        { 
            dal.SaveImportFlag(fieldConfigId, projectId, isForImport, userId); 
        }
        public long ImportRows(int projectId, string originalFileName, DataTable values, int userId)
        {
            return dal.ImportRows(projectId, originalFileName, values, userId);
        }
        public DataTable GetRecentImports(int userId) { return dal.GetRecentImports(userId); }
    }
}
