using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.FTE
{
    public partial class FTEConfiguration : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetAllProjectByUserRights()
        {
            DataTable dt = new bllMaster().GetAllProjectByUserRights(HttpContext.Current.User.Identity.Name);
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetProcessByProjectWise(int ProjectID)
        {
            bllMaster master = new bllMaster();
            string code = master.GetCodeFromEmployeeId(GetCurrentEmployeeId());
            DataTable dt = master.getProcessByProjectWise(ProjectID, code);
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetFTEDetails()
        {
            DataTable dt = new bllMaster().GetFTEDetails();
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static int InsertFTEDetails(
            int ProjectID,
            int ProcessID,
            string ApprovedFTECount,
            string BillableStandardHours,
            string BillingType,
            string WeekendAllowed,
            string USHolidayAllowed)
        {
            if (ProjectID <= 0 ||
                ProcessID <= 0 ||
                string.IsNullOrWhiteSpace(BillableStandardHours) ||
                string.IsNullOrWhiteSpace(BillingType) ||
                string.IsNullOrWhiteSpace(WeekendAllowed) ||
                string.IsNullOrWhiteSpace(USHolidayAllowed))
            {
                return 0;
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", ProjectID);
            htParam.Add("ProcessID", ProcessID);
            htParam.Add("ApprovedFTECount", ApprovedFTECount == null ? string.Empty : ApprovedFTECount.Trim());
            htParam.Add("BillableStandardHours", BillableStandardHours.Trim());
            htParam.Add("BillingType", BillingType.Trim());
            htParam.Add("WeekendAllowed", WeekendAllowed.Trim());
            htParam.Add("USHolidayAllowed", USHolidayAllowed.Trim());
            htParam.Add("AddedBy", GetCurrentEmployeeId());

            return new bllMaster().InsertFTEDetails(htParam);
        }

        private static int GetCurrentEmployeeId()
        {
            return int.Parse(HttpContext.Current.User.Identity.Name);
        }

        private static string SerializeDataTable(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();

                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }

                    rows.Add(row);
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(rows);
        }
    }
}
