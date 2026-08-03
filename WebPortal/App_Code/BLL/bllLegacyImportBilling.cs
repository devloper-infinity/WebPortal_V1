using System.Data;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public sealed class bllLegacyImportBilling
    {
        private readonly dalLegacyImportBilling dal = new dalLegacyImportBilling();
        public DataTable GetHistory(int projectId, string billingPeriod) { return dal.GetHistory(projectId, billingPeriod); }
        public int Send(int projectId, string projectName, string billingPeriod, string billingCycle, int userId, DataTable rows) { return dal.Send(projectId, projectName, billingPeriod, billingCycle, userId, rows); }
    }
}
