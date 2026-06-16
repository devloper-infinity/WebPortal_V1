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

namespace WebPortal.Admin
{
    public partial class MasterData : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetMasterData()
        {
            DataTable dt1 = new bllMaster().GetMastData();
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
            return ser.Serialize(new
            {
                Columns = dt1.Columns.Cast<DataColumn>().Select(col => col.ColumnName).ToList(),
                Rows = rows
            });
        }

        [WebMethod]
        public static int InsertStampPaperDetails(string Code, string Type, string Cost, string Version, string Duration, string AgreementDate, string ExpiryDate, int StampPapersUsed, string StampPaperNo, string FileNo, string SignedDate, string AckDate, string Remark, string PenaltyPseudoname)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("Code", Code);
            htParam.Add("Type", Type);
            htParam.Add("Cost", Cost);
            htParam.Add("Version", Version);
            htParam.Add("Duration", Duration);

            if (AgreementDate != "")
                AgreementDate = Convert.ToDateTime(AgreementDate).ToString("dd-MMM-yyyy");

            if (ExpiryDate != "")
                ExpiryDate = Convert.ToDateTime(ExpiryDate).ToString("dd-MMM-yyyy");

            htParam.Add("AgreementDate", AgreementDate);
            htParam.Add("ExpiryDate", ExpiryDate);
            htParam.Add("StampPapersUsed", StampPapersUsed);
            htParam.Add("StampPaperNo", StampPaperNo);
            htParam.Add("FileNo", FileNo);
            htParam.Add("SignedDate", SignedDate);
            htParam.Add("AcknowledgementDate", AckDate);
            htParam.Add("Remark", Remark);
            htParam.Add("PseudonameClause", PenaltyPseudoname);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllMaster().InsertStampPaperDetails(htParam);
            return ReturnValue;
        }

        [WebMethod]
        public static int InsertMasterDataDetails_FileNo(string Code, string Type, string FileNo, string VisaNo, string ValidTill, string ScannedCopy)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("Code", Code);
            htParam.Add("Type", Type);
            htParam.Add("FileNo", FileNo);
            htParam.Add("VisaNo", VisaNo);
            htParam.Add("ValidTill", ValidTill);
            htParam.Add("ScannedCopy", ScannedCopy);
            htParam.Add("Addedby", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            ReturnValue = new bllMaster().InsertMasterDataDetails_FileNo(htParam);
            return ReturnValue;
        }

        [WebMethod]
        public static int InsertStamppaperClause(string Code, string Type, string Version, string Clause, string ClauseNo, string Penalty)
        {
            int Returnvalue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("Code", Code);
            htParam.Add("Type", Type);
            htParam.Add("Version", Version);
            htParam.Add("Clause", Clause);
            htParam.Add("ClauseNo", ClauseNo);
            htParam.Add("Penalty", Penalty);
            htParam.Add("Addedby", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            Returnvalue = new bllMaster().InsertStampPaperClause(htParam);
            return Returnvalue;
        }

        [WebMethod]
        public static string GetStampPaperHistory(string Code, string Type)
        {
            DataTable dt1 = new bllMaster().GetStampPaperDetailsHistoryOfEmployee(Code, Type);
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
    }
}
