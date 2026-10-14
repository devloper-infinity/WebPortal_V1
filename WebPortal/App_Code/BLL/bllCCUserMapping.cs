using System;
using System.Collections.Generic;
using System.Data;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code.BLL
{
    public class bllCCUserMapping
    {
        private readonly dalCCUserMapping data = new dalCCUserMapping();
        public DataTable GetInvoiceContext(int headerID) { return data.GetInvoiceContext(headerID); }
        public DataTable GetResources(int projectID) { return data.GetResources(projectID); }
        public int SaveResource(int resourceID, string name, string type, string identifier, int projectID, string departmentDomain,
            string description, DateTime from, DateTime? to, bool active, string remark, int userID)
        { return data.SaveResource(resourceID, name, type, identifier, projectID, departmentDomain, description, from, to, active, remark, userID); }
        public void SetResourceStatus(int resourceID, bool active, int userID) { data.SetResourceStatus(resourceID, active, userID); }
        public DataTable GetResourceMappings(int resourceID) { return data.GetResourceMappings(resourceID); }
        public void SaveMappings(int resourceID, IList<string> employeeCodes, DateTime from, DateTime? to, int userID)
        { data.SaveMappings(resourceID, employeeCodes, from, to, userID); }
        public void EndMapping(int mappingID, DateTime effectiveTo, int userID) { data.EndMapping(mappingID, effectiveTo, userID); }
        public void UpdateMapping(int mappingID, DateTime from, DateTime? to, int userID) { data.UpdateMapping(mappingID, from, to, userID); }
        public int AssociateBilling(int headerID, string month, string year, int resourceID, int userID)
        { return data.AssociateBilling(headerID, month, year, resourceID, userID); }
        public DataTable GetBillingAssociations(string month, string year) { return data.GetBillingAssociations(month, year); }
    }
}
