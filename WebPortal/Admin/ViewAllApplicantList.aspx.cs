using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.EL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebPortal.Admin
{
    public partial class ViewAllApplicantList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

            }
        }

        private static List<T> ConvertDataTable<T>(DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }

        private static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                        pro.SetValue(obj, dr[column.ColumnName], null);
                    else
                        continue;
                }
            }
            return obj;
        }

        [WebMethod]
        public static string GetApplicantListByEmployeeId()
        {
            DataTable dt1 = new bllRequisition().GetApplicantListByEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt1.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt1.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }

        [WebMethod]
        public static List<Domain> GetAllDomains()
        {
            DataTable dtdomain = new bllMaster().GetAllDomain();
            List<Domain> domains = new List<Domain>();
            domains = ConvertDataTable<Domain>(dtdomain);
            return domains;
        }

        public static List<Department> GetDepartment()
        {
            DataTable dtdept = new bllMaster().GetAllDepartment();

            List<Department> depart = new List<Department>();
            depart = ConvertDataTable<Department>(dtdept);
            return depart;
        }

        [WebMethod]
        public static List<WebPortal.App_Code.Class.Requisition> GetAllRequisitions()
        {
            DataTable dtRec = new bllRequisition().GetAllRequisition("OpenRemark");
            List<WebPortal.App_Code.Class.Requisition> Rec = new List<WebPortal.App_Code.Class.Requisition>();
            Rec = ConvertDataTable<WebPortal.App_Code.Class.Requisition>(dtRec);
            return Rec;
        }

        [WebMethod]
        public static List<WebPortal.App_Code.Class.Branch> GetBranches()
        {
            DataTable dtBranch = new bllMaster().GetAllBranches();
            List<WebPortal.App_Code.Class.Branch> Bra = new List<WebPortal.App_Code.Class.Branch>();
            Bra = ConvertDataTable<WebPortal.App_Code.Class.Branch>(dtBranch);
            return Bra;
        }

        [WebMethod]
        public static List<WebPortal.App_Code.Class.ProjectManager> GetProjectManagers()
        {
            DataTable dtPM = new bllMaster().GetAllProjectManager();
            List<WebPortal.App_Code.Class.ProjectManager> PM = new List<WebPortal.App_Code.Class.ProjectManager>();
            PM = ConvertDataTable<WebPortal.App_Code.Class.ProjectManager>(dtPM);
            return PM;
        }
    }
}