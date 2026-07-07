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

        public DataSet GetAutomationCenter(int employeeId)
        {
            return dalCRM.GetAutomationCenter(employeeId);
        }

        public DataSet GetNotifications(int employeeId)
        {
            return dalCRM.GetNotifications(employeeId);
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

        public int SaveAutomationItem(string entity, Hashtable values)
        {
            switch ((entity ?? string.Empty).Trim().ToLower())
            {
                case "emailsettings":
                    return dalCRM.SaveEmailSettings(values);
                case "notificationsettings":
                    return dalCRM.SaveNotificationSettings(values);
                case "emailtemplate":
                    return dalCRM.SaveEmailTemplate(values);
                case "assignmentrule":
                    return dalCRM.SaveAssignmentRule(values);
                case "slapolicy":
                    return dalCRM.SaveSlaPolicy(values);
                default:
                    return -2;
            }
        }

        public int DeleteAutomationItem(string entity, int recordId, int deletedBy)
        {
            return dalCRM.DeleteAutomationItem(entity, recordId, deletedBy);
        }

        public int QueueAutomationEvent(string entity, int recordId, string eventName, int employeeId)
        {
            return dalCRM.QueueAutomationEvent(entity, recordId, eventName, employeeId);
        }

        public int MarkNotificationsRead(int employeeId)
        {
            return dalCRM.MarkNotificationsRead(employeeId);
        }

        public DataSet RunAutomationDueJobs(int employeeId)
        {
            return dalCRM.RunAutomationDueJobs(employeeId);
        }

        public DataSet GetAutomationDispatchBatch(int batchSize)
        {
            return dalCRM.GetAutomationDispatchBatch(batchSize);
        }

        public int UpdateEmailOutboxStatus(int emailOutboxId, string status, string errorMessage)
        {
            return dalCRM.UpdateEmailOutboxStatus(emailOutboxId, status, errorMessage);
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
