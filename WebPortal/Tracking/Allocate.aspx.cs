using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.Tracking
{
    public partial class Allocate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetProcessByProject(int ProjectID)
        {
            DataTable dt1 = new bllMaster().getProcess(ProjectID);
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
        public static object GetLoans(int ProjectID, string DealNo)
        {
            DataTable dt = new bllUS().GetAllOrderNoByProjectWise(ProjectID, DealNo, "", "", "Allocation2");

            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }

        [WebMethod]
        public static object GetUserLoans(string UserName)
        {
            DataTable dt = new bllMaster().GetAllProject(); //bllTracking().GetProcessDetails(UserName);
            dt = dt.AsEnumerable().Take(5).CopyToDataTable();
            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }



        [WebMethod]
        public static object GetProcessDetailsForFeedbackUser(string UserName)
        {
            DataTable dt = new bllTracking().GetProcessDetailsForFeedbackUser(UserName);

            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }

            [WebMethod]
        public static int UpdateLoanStatus(string Project, string DealNo, string OrderNo, string Process, string ProjectID, string Status, string HoldRemark, string Remark, string ProductType, string UserName)
        {
            int ReturnValue = 0;
            Hashtable htParamValidate = new Hashtable();

            htParamValidate.Add("ProjectNumber", Project);
            htParamValidate.Add("DealNo", DealNo);
            htParamValidate.Add("OrderNumber", OrderNo);
            htParamValidate.Add("Process", Process);
            htParamValidate.Add("ProjectId", ProjectID);
            htParamValidate.Add("UserCode", UserName);

            ReturnValue = 10;// new bllTracking().ValidateUserProcessTAT(htParamValidate);
            return ReturnValue;
        }
    }
}