using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class SLATimeline : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string GetAllSLATimeline()
        {
            try
            {
                DataTable dt = new bllMaster().GetAllSLATimeline();

                if (dt != null && dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(dt);
                }

                // Return empty JSON array
                return "[]";
            }
            catch (Exception ex)
            {
                // Optional logging
                // ErrorLogs.Log(ex);

                return "[]";
            }
        }


        [WebMethod]
        public static int InsertSLATimeline(int Project, string Process, string Timeline, string TimelineType)
        {
            int ReturnValue = 0;

            try
            {
                Hashtable htParam = new Hashtable();
                htParam["Project"] = Project;
                htParam["Process"] = Process;
                htParam["Timeline"] = Timeline;
                htParam["TimelineType"] = TimelineType;
                htParam["DealNo"] = "";
                htParam["Month"] = DateTime.Now.ToString("MMMM");
                htParam["Year"] = DateTime.Now.Year;
                htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                ReturnValue = new bllMaster().InsertSLATimeline(htParam);
            }
            catch (Exception ex)
            {
                ReturnValue = 0;
            }

            return ReturnValue;
        }
    }
}