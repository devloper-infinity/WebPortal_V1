using System.Collections;
using System.Data;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllHelpdesk
    {
        private readonly dalHelpdesk dal = new dalHelpdesk();

        public DataSet GetBootstrap(int employeeId) { return dal.GetBootstrap(employeeId); }
        public int CreateTicket(Hashtable values) { return dal.CreateTicket(values); }
        public DataTable GetMyTickets(int employeeId, string status) { return dal.GetMyTickets(employeeId, status); }
        public DataTable GetQueue(int employeeId, string scope, string status, string priority) { return dal.GetQueue(employeeId, scope, status, priority); }
        public DataTable GetAgents(int employeeId) { return dal.GetAgents(employeeId); }
        public DataSet GetTicket(int ticketId, int employeeId) { return dal.GetTicket(ticketId, employeeId); }
        public int AddMessage(int ticketId, int employeeId, string message, bool isInternal) { return dal.AddMessage(ticketId, employeeId, message, isInternal); }
        public int Assign(int ticketId, int agentEmployeeId, int assignedBy) { return dal.Assign(ticketId, agentEmployeeId, assignedBy); }
        public int Transition(int ticketId, int employeeId, string nextStatus, string comment) { return dal.Transition(ticketId, employeeId, nextStatus, comment); }
        public int DecideApproval(int ticketId, int approverId, string decision, string comment) { return dal.DecideApproval(ticketId, approverId, decision, comment); }
        public DataSet GetAdministration(int employeeId) { return dal.GetAdministration(employeeId); }
        public int SaveCategory(Hashtable values) { return dal.SaveCategory(values); }
        public int SaveSla(Hashtable values) { return dal.SaveSla(values); }
        public int SaveAgent(Hashtable values) { return dal.SaveAgent(values); }
    }
}
