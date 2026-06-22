using System.Collections;
using System.Data;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllCRM
    {
        private readonly dalCRM dalCRM = new dalCRM();

        public DataSet GetDashboard(int employeeId)
        {
            return dalCRM.GetDashboard(employeeId);
        }

        public DataSet GetReports(int employeeId)
        {
            return dalCRM.GetReports(employeeId);
        }

        public DataSet GetLookups(int employeeId)
        {
            return dalCRM.GetLookups(employeeId);
        }

        public DataTable GetRecords(string entity, string searchText, string filterValue, int ownerId, int employeeId)
        {
            return dalCRM.GetRecords(entity, searchText, filterValue, ownerId, employeeId);
        }

        public DataSet GetRecord(string entity, int recordId, int employeeId)
        {
            return dalCRM.GetRecord(entity, recordId, employeeId);
        }

        public int SaveRecord(string entity, Hashtable values)
        {
            switch ((entity ?? string.Empty).Trim().ToLower())
            {
                case "lead":
                    return dalCRM.SaveLead(values);
                case "account":
                    return dalCRM.SaveAccount(values);
                case "contact":
                    return dalCRM.SaveContact(values);
                case "deal":
                    return dalCRM.SaveDeal(values);
                case "activity":
                    return dalCRM.SaveActivity(values);
                case "note":
                    return dalCRM.SaveNote(values);
                default:
                    return -2;
            }
        }

        public int DeleteRecord(string entity, int recordId, int deletedBy)
        {
            return dalCRM.DeleteRecord(entity, recordId, deletedBy);
        }

        public int ConvertLead(int leadId, string dealName, string amount, string closeDate, int convertedBy)
        {
            return dalCRM.ConvertLead(leadId, dealName, amount, closeDate, convertedBy);
        }
    }
}
