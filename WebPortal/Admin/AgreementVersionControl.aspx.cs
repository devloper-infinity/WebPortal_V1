using ClosedXML.Excel;
using Spire.Xls;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class AgreementVersionControl : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public class ClauseModel
        {
            public string ClauseNo { get; set; }
            public string ClauseDetails { get; set; }
        }

        public class TypeData
        {
            public string TypeText { get; set; }
            public string MinServicePeriod { get; set; }
        }

        [WebMethod]
        public static string SaveAgreement_Versions(string version, string versionDate, List<ClauseModel> clauses)
        {
            int ReturnValue = 0;
            string msg = "";
            try
            {

                foreach (var clause in clauses)
                {
                    Hashtable htParam = new Hashtable();
                    htParam["Version"] = version;
                    htParam["VersionDate"] = versionDate;
                    htParam["ClauseNo"] = clause.ClauseNo;
                    htParam["Clause"] = clause.ClauseDetails;
                    htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                    ReturnValue =  new bllMaster().InsertAgreementVersionHistory(htParam);
                }

                if (ReturnValue > 0)
                    msg = "Success";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }

            return msg;
        }


        [WebMethod]
        public static string SaveAgreement_Types(string version, string versionDate, List<TypeData> typeList)
        {
            int ReturnValue = 0;
            string msg = "";
            try
            {
                // Debug check
                if (typeList == null || typeList.Count == 0)
                {
                    return "Type list is empty";
                }

                foreach (var item in typeList)
                {
                    Hashtable htParam = new Hashtable();
                    htParam["Version"] = version;
                    htParam["VersionDate"] = versionDate;
                    htParam["AgreementType"] = item.TypeText;
                    htParam["MinServPeriod"] = item.MinServicePeriod;
                    htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                    ReturnValue =  new bllMaster().InsertAgreementTypeHistory(htParam);
                }

                if (ReturnValue > 0)
                    msg = "Success";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }

            return msg;
        }


        [WebMethod]
        public static int UpdateAgreementVersionHistory(int AgrChangeID, string ClauseNo, string ClauseDetails)
        {
            int ReturnValue = 0;

            try
            {
                Hashtable htParam = new Hashtable();

                htParam["AgrChangeID"] = AgrChangeID;
                htParam["ClauseNo"] = ClauseNo;
                htParam["Clause"] = ClauseDetails;
                htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                ReturnValue = new bllMaster().UpdateAgreementVersionHistory(htParam);

            }
            catch (Exception ex)
            {
                ReturnValue = 0;
            }
            return ReturnValue;
        }


        [WebMethod]
        public static string GetAgreementVersionHistory()
        {
            DataTable dt1 = new bllMaster().GetAgreementVersionHistory();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }


        [WebMethod]
        public static string GetAgreementTypeHistory()
        {
            DataTable dt1 = new bllMaster().GetAgreementTypeHistory();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt1.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(rows);
        }
    }
}