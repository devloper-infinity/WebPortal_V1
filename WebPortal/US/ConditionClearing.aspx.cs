using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.US
{
    public partial class ConditionClearing : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static object GetProjects()
        {
            DataTable dt = new bllUS().GetAllProjectByUserRights_ForAddFeedback(HttpContext.Current.User.Identity.Name.ToString());

            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }


        [WebMethod]
        public static object GetDeals(int ProjectID)
        {
            DataTable dt = new bllUS().GetAllProjectDealNumberNew(ProjectID);

            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }


        [WebMethod]
        public static object GetDealFromLoan(string LoanNo)
        {
            DataTable dt = new bllUS().GetDealFromLoan(LoanNo);

            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }


        [WebMethod]
        public static object GetLoans(int ProjectID, string DealNo)
        {
            DataTable dt = new bllUS().GetAllOrderNoByProjectWise(ProjectID, DealNo, "", "", "Allocation2");

            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }


        [WebMethod]
        public static object ViewAllConditionClearing()
        {
            DataTable dt = new bllUS().ViewAllConditionClearing();

            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }


        [WebMethod]
        public static string InsertConditionClearing(int ProjectID, string DealNo, string LoanNo, string InfinityCondition, string ClientsRebuttal, string ReceivedDate, string ExcpGrade, string Process)
        {
            string msg = "";

            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectId", ProjectID);
            htParam.Add("DealNo", DealNo);
            htParam.Add("LoanNo", LoanNo);
            htParam.Add("InfinityCondition", InfinityCondition);
            htParam.Add("ClientsRebuttal", ClientsRebuttal);
            htParam.Add("ReceivedDate", ReceivedDate);
            htParam.Add("ReviewDate", "");
            htParam.Add("InfinityResponse", "");
            htParam.Add("Cleared", "");
            htParam.Add("TotalTime", "");
            htParam.Add("Process", Process);
            htParam.Add("InitialExceptionGrade", ExcpGrade);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            int ReturnValue = new bllUS().InsertConditionClearing(htParam);

            if (ReturnValue > 0)
                msg = "Data inserted successfully.";
            else
                msg = "Error saving data";

            return msg;
        }
    }
}