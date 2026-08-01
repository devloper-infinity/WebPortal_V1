using System;
using System.Data;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public sealed class bllOLMonthlyBilling
    {
        private readonly dalOLMonthlyBilling dal = new dalOLMonthlyBilling();
        public DataTable GetFields(int projectId) { return dal.GetFields(projectId); }
        public DataTable GetRows(int projectId, int month, int year, bool sentHistory) { return dal.GetRows(projectId, month, year, sentHistory); }
        public int Verify(int projectId, int month, int year, DataTable selections, int userId) { return dal.Verify(projectId, month, year, selections, userId); }
        public int SendToAccounts(int projectId, int month, int year, int userId) { return dal.SendToAccounts(projectId, month, year, userId); }
    }
}
