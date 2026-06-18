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
    public partial class ProjectHolidaysMaster : Page
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
        public static string GetClientHoliday()
        {
            DataTable dt = new bllMaster().GetClientHoliday();
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static int InsertClientHoliday(int ProjectID, string HolidayDate)
        {
            if (ProjectID <= 0 || string.IsNullOrWhiteSpace(HolidayDate))
            {
                return 0;
            }

            Hashtable htParam = new Hashtable();
            htParam.Add("ProjectID", ProjectID);
            htParam.Add("Date", HolidayDate.Trim());
            htParam.Add("AddedBy", GetCurrentEmployeeId());

            return new bllMaster().InsertClientHoliday(htParam);
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
