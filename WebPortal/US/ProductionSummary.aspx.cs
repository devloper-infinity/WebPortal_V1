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

namespace WebPortal.US
{
    public partial class ProductionSummary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetDatewiseOnShoreProduction_Monthly(string Month, string Year)
        {
            DataTable dt1 = new bllUS().GetDatewiseOnShoreProduction_Monthly(Month, Year);
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
        public static string GetDatewiseOnShoreProduction(string Date)
        {
            DataTable dt1 = new bllUS().GetDatewiseOnShoreProduction(Date);
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
        public static int InsertOnShoreProduction(int ProjectID, int ProcessID, string DealNo, string StartTime, string EndTime, string TotalTime,
            string TaskPerformed, string Target, int LoansReviewed, string TargetvsProduction, int TotalErrors, int Critical, int NonCritical, int IncorrectErrors,
            string ErrorFindRate, string CostPerLoan, string Comments)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", ProjectID);
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("DealNo", DealNo);
            htParam.Add("StartTime", StartTime);
            htParam.Add("EndTime", EndTime);
            htParam.Add("TotalTime", TotalTime);
            htParam.Add("TaskPerformed", TaskPerformed);
            htParam.Add("Target", Target);
            htParam.Add("LoansReviewed", LoansReviewed);
            htParam.Add("TargetvsProduction", TargetvsProduction);
            htParam.Add("TotalErrors", TotalErrors);
            htParam.Add("Critical", Critical);
            htParam.Add("NonCritical", NonCritical);
            htParam.Add("IncorrectErrors", IncorrectErrors);
            htParam.Add("ErrorFindingRate", ErrorFindRate);
            htParam.Add("CostPerLoan", CostPerLoan);
            htParam.Add("Comments", Comments);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllUS().InsertOnShoreProduction(htParam);
            return returnvalue;
        }

        [WebMethod]
        public static string SaveProductionSummary(List<ProductionSummaryDto> records)
        {
            foreach (var r in records)
            {
                InsertOnShoreProduction(r);
            }

            return "Success";
        }

        [WebMethod]
        public static int InsertOnShoreProduction(ProductionSummaryDto r)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", r.ProjectID);
            htParam.Add("ProcessID", r.ProcessID);
            htParam.Add("Date", r.Date);
            htParam.Add("DealNo", r.DealNo);
            htParam.Add("StartTime", r.StartTime);
            htParam.Add("EndTime", r.EndTime);
            htParam.Add("TotalTime", r.TotalTime);
            htParam.Add("TaskPerformed", r.TaskPerformed);
            htParam.Add("Target", r.Target);
            htParam.Add("LoansReviewed", r.LoansReviewed);
            htParam.Add("TargetvsProduction", r.TargetvsProduction);
            htParam.Add("TotalErrors", r.TotalErrors);
            htParam.Add("Critical", r.TotalCriticalErrors);
            htParam.Add("NonCritical", r.TotalNonCriticalErrors);
            htParam.Add("IncorrectErrors", r.IncorrectErrors);
            htParam.Add("ErrorFindingRate", r.ErrorFindingRate);
            htParam.Add("CostPerLoan", r.CostPerLoan);
            htParam.Add("Comments", r.Comments);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllUS().InsertOnShoreProduction(htParam);
            return returnvalue;
        }

        public class ProductionSummaryDto
        {
            public string Date { get; set; }
            public string StartTime { get; set; }
            public string EndTime { get; set; }
            public string TotalTime { get; set; }
            public int ProjectID { get; set; }
            public int ProcessID { get; set; }
            public string DealNo { get; set; }
            public string TaskPerformed { get; set; }
            public int LoansReviewed { get; set; }
            public string Target { get; set; }
            public string TargetvsProduction { get; set; }
            public int TotalErrors { get; set; }
            public int TotalCriticalErrors { get; set; }
            public int TotalNonCriticalErrors { get; set; }
            public int IncorrectErrors { get; set; }
            public decimal ErrorFindingRate { get; set; }
            public decimal CostPerLoan { get; set; }
            public string Comments { get; set; }
        }
    }
}