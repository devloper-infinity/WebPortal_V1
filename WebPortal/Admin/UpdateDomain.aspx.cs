using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Admin
{
    public partial class UpdateDomain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int ChangeDomain(string EmployeeIDs, int DomainID, string SubDomain, string Process)
        {
            int ReturnValue = 0;

            string[] arr_EmpIds = EmployeeIDs.Split(',').Distinct().ToArray(); ;

            try
            {
                foreach (string empId in arr_EmpIds)
                {
                    string id = empId.Trim();

                    Hashtable htParam = new Hashtable();
                    htParam["EmployeeID"] = id;
                    htParam["Domain"] = DomainID;
                    htParam["SubDomain"] = SubDomain;
                    htParam["Process"] = Process;
                    htParam["Month"] = DateTime.Now.ToString("MMMM"); 
                    htParam["Year"] = DateTime.Now.Year;
                    htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                    ReturnValue =  new bllMaster().InsertUserDomain(htParam); 
                }
            }
            catch (Exception ex)
            {
                ex.Message.ToString();
            }

            return ReturnValue;
        }
    }
}