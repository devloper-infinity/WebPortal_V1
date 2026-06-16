using DocumentFormat.OpenXml.ExtendedProperties;
using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Interop;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class ConditionAnalysis : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {



        }


        [WebMethod]
        public static object ViewAllConditionClearingPending()
        {
            DataTable dt = new bllUS().ViewAllConditionClearingPending();

            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }

        [WebMethod]
        public static object ViewAllConditionClearingById(int ID)
        {
            DataTable dt = new bllUS().ViewAllConditionClearingById(ID);

            var data = dt.AsEnumerable().Select(row => dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => row[col]));

            return data;
        }

        [WebMethod]
        public static string UpdateConditionAnalysis(int ID, string ReviewDate, string Cleared, string InfinityResponse, string TotalTime, string InfinityCondition, string ReceivedDate, string ClientsRebuttal, string FinalExceptionGrade, string StartDateTime, string EndDateTime)
        {
            int ReturnValue = 0;
            string msg = "";

            try
            {
                Hashtable htparam = new Hashtable();
                htparam.Add("ReviewDate", ReviewDate);
                htparam.Add("InfinityResponse", InfinityResponse);
                htparam.Add("Cleared", Cleared);
                htparam.Add("TotalTime", TotalTime);
                htparam.Add("Id", ID);
                htparam.Add("Type", "Analysis");
                htparam.Add("ProjectId", "");
                htparam.Add("DealNo", "");
                htparam.Add("LoanNo", "");
                htparam.Add("InfinityCondition", InfinityCondition);
                htparam.Add("ClientsRebuttal", ClientsRebuttal);
                htparam.Add("ReceivedDate", ReceivedDate);
                htparam.Add("FinalExceptionGrade", FinalExceptionGrade);
                htparam.Add("Sdate", StartDateTime);
                htparam.Add("Edate", EndDateTime);
                htparam.Add("AddedBy", Convert.ToString(Convert.ToString(int.Parse(HttpContext.Current.User.Identity.Name.ToString()))));

                ReturnValue =  new bllUS().UpdateConditionClearing(htparam);

                if (ReturnValue > 0)
                    msg = "Data updated successfully.";
                else
                    msg = "Error updating data";
            }
            catch (Exception ex)
            {
                msg = ex.Message;
            }

            return msg;
        }
    }
}