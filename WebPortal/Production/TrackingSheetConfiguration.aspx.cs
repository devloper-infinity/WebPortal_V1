using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;
using System.Text;
using System.Net.Mail;
using System.Data.SqlClient;

namespace WebPortal.Production
{
    public partial class TrackingSheetConfiguration : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        #region Domainwise Column Configuration

        [WebMethod]
        public static string GetDomain()
        {
            DataTable dt1 = new bllMaster().GetAllDomain();
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
        public static int InsertDomainWiseField(string FieldName, int DomainID, bool IsNameColume)
        {
            int ReturnValue = 0;
            Hashtable htParam = new Hashtable();

            string fieldname = FieldName;
            bool isNameColume = IsNameColume;
            bool isCreate = false;
            int check = -1;

            htParam.Add("DomainID", DomainID);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            if (IsNameColume == true)
            {
                String[] FinalArr = new String[] { "Final Status", "Final TAT" };
                for (int j = 0; j < FinalArr.Length; j++)
                {
                    check = new bllTracking().ValidateAutoColumn(DomainID, FinalArr[j]);
                    if (check == 1)
                    {
                        htParam.Remove("FieldName");
                        htParam.Remove("isNameColume");
                        htParam.Remove("isCreate");
                        htParam.Add("isNameColume", false);
                        htParam.Add("isCreate", true);
                        htParam.Add("FieldName", FinalArr[j]);
                        ReturnValue = new bllTracking().InsertDomainWiseField(htParam);
                    }
                }
                htParam.Remove("FieldName");
                htParam.Remove("isNameColume");
                htParam.Remove("isCreate");
                htParam.Add("isNameColume", isNameColume);
                htParam.Add("isCreate", isCreate);
                htParam.Add("FieldName", fieldname);
                ReturnValue = new bllTracking().InsertDomainWiseField(htParam);

                String[] myArr = new String[] { "Assign Date", "Start Time", "End Time", "Status", "TAT" };
                for (int i = 0; i < myArr.Length; i++)
                {
                    htParam.Remove("FieldName");
                    htParam.Remove("isNameColume");
                    htParam.Remove("isCreate");
                    htParam.Add("isNameColume", false);
                    htParam.Add("isCreate", true);
                    htParam.Add("FieldName", fieldname + ' ' + myArr[i]);
                    ReturnValue = new bllTracking().InsertDomainWiseField(htParam);
                }
            }
            else
            {
                htParam.Add("FieldName", FieldName);
                htParam.Add("isNameColume", IsNameColume);
                htParam.Add("isCreate", false);

                ReturnValue = new bllTracking().InsertDomainWiseField(htParam);
            }
            if (ReturnValue > 0)
            {

            }
            else
            {

            }
            return ReturnValue;
        }

        [WebMethod]
        public static int UpdateDomainWiseField(string DomainID, string FieldName, int Id)
        {
            int ReturnValue = 0;
            try
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("DomainID", DomainID);
                htParam.Add("FieldName", FieldName);
                htParam.Add("Id", Id);
                htParam.Add("UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                ReturnValue = new bllTracking().UpdateDomainWiseField(htParam);
            }
            catch (Exception ex)
            {

            }
            return ReturnValue;
        }

        [WebMethod]
        public static int DeleteFieldByDomain(int Id)
        {
            int ReturnValue = 0;
            try
            {
                ReturnValue = new bllTracking().DeleteFieldByDomain(Id, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            }
            catch (Exception ex)
            {

            }
            return ReturnValue;
        }

        #endregion


        #region Projectwise Column Configuration

        [WebMethod]
        public static string GetAllFieldByProjectAndDomain(int Domain)
        {
            DataTable dt1 = new bllTracking().GetAllFieldByProjectAndDomain(Domain, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetAllFieldbyDomain(int Domain)
        {
            DataTable dt1 = new bllTracking().GetAllFieldbyDomain(Domain);
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
        public static string GetAllDomainByConfigureField()
        {
            DataTable dt1 = new bllTracking().GetAllDomainByConfigureField();
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
        public static string GetAllProjectByDomainWise(int DomainID)
        {
            DataTable dt1 = new bllTracking().GetAllProjectByDomainWise(DomainID, Convert.ToInt32(HttpContext.Current.User.Identity.Name));
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
        public static string GetFieldNameForProjectConfig(int DomainID, int ProjectID)
        {
            DataTable dt1 = new bllTracking().GetFieldNameForProjectConfig(DomainID, ProjectID);
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
        public static string GetAllTrackingSheetsColumnsbyProject(int ProjectFieldID)
        {
            DataTable dt1 = new bllTracking().GetAllTrackingSheetsColumnsbyProject(ProjectFieldID);
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
        public static string GetAllProject()
        {
            DataTable dt1 = new bllMaster().GetAllProject();
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
        public static int InsertProjectWiseField(string FieldName, int DomainID, int ProjectID, bool IsVisible, bool IsEditable)
        {
            int ReturnValue = 0;

            Hashtable htParam = new Hashtable();
            htParam.Add("FieldName", FieldName);
            htParam.Add("ProjectId", ProjectID);
            htParam.Add("DomainId", DomainID);
            htParam.Add("isVisible", IsVisible);
            htParam.Add("isEditable", IsEditable);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            int check = -1;
            bool Check = Convert.ToBoolean(new bllTracking().CheckIsNameColumn(FieldName));
            if (Check == true)
            {
                String[] FinalArr = new String[] { "Final Status", "Final TAT" };
                for (int j = 0; j < FinalArr.Length; j++)
                {
                    check = new bllTracking().ValidateAutoColumnbyProjectConfiguration(DomainID, ProjectID, FinalArr[j]);
                    if (check > 1)
                    {
                        htParam.Remove("FieldName");
                        htParam.Remove("isVisible");
                        htParam.Remove("isEditable");
                        htParam.Add("isVisible", true);
                        htParam.Add("isEditable", false);
                        htParam.Add("FieldName", check);
                        ReturnValue = new bllTracking().InsertProjectWiseField(htParam);
                    }
                }
                if (check > 1)
                {
                    htParam.Remove("FieldName");
                    htParam.Remove("isVisible");
                    htParam.Remove("isEditable");
                    htParam.Add("isVisible", IsVisible);
                    htParam.Add("isEditable", IsEditable);
                    htParam.Add("FieldName", FieldName);
                }
                ReturnValue = new bllTracking().InsertProjectWiseField(htParam);
                for (int i = 1; i <= 5; i++)
                {
                    htParam.Remove("FieldName");
                    htParam.Remove("isVisible");
                    htParam.Remove("isEditable");
                    htParam.Add("FieldName", FieldName + i);
                    htParam.Add("isVisible", true);
                    if (i == 4)
                        htParam.Add("isEditable", true);
                    else
                        htParam.Add("isEditable", false);

                    ReturnValue = new bllTracking().InsertProjectWiseField(htParam);
                }
            }
            else
            {
                ReturnValue = new bllTracking().InsertProjectWiseField(htParam);
            }
            return ReturnValue;
        }

        [WebMethod]
        public static int UpdateDomainAndProjectWiseField(int DomainID, int ProjectID, int FieldID, string FieldName, int Id, bool Visible, bool Editable)
        {
            int ReturnValue = 0;
            try
            {
                if (FieldName != "")
                {
                    Hashtable htParam = new Hashtable();
                    htParam.Add("DomainID", DomainID);
                    htParam.Add("ProjectID", ProjectID);
                    htParam.Add("FieldName", FieldName);
                    htParam.Add("Id", Id);
                    htParam.Add("Visible", Visible);
                    htParam.Add("Editable", Editable);
                    htParam.Add("UpdatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    ReturnValue = new bllTracking().UpdateDomainAndProjectWiseField(htParam);
                    if (ReturnValue > 0)
                    {

                    }
                    else
                    {

                    }
                }
                else
                {
                }
            }
            catch (Exception ex)
            {

            }
            return ReturnValue;
        }

        [WebMethod]
        public static int DeleteFieldByDomainAndProject(int Id)
        {
            int ReturnValue = 0;
            try
            {
                ReturnValue = new bllTracking().DeleteFieldByDomainAndProject(Id, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            }
            catch (Exception ex)
            {

            }
            return ReturnValue;
        }

        #endregion

        #region Column Mapping

        [WebMethod]
        public static string GetAllColumnMappingDetails()
        {
            DataTable dt1 = new bllTracking().getAllColumnMappingDetails(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetAllProjectByDefineField()
        {
            DataTable dt1 = new bllTracking().GetAllProjectByDefineField(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetAllColumnByProject(int ProjectID)
        {
            DataTable dt1 = new bllTracking().GetAllColumnByProject(ProjectID);
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
        public static string GetAllFieldNameByProject(int ProjectID)
        {
            DataTable dt1 = new bllTracking().GetAllFieldNameByProject(ProjectID);
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
        public static string GetAllColumnMappingDetailsint()
        {
            DataTable dt1 = new bllTracking().getAllColumnMappingDetails(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
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
        public static string GetSequenceNoByProject(int ProjectID)
        {
            DataTable dt1 = new bllTracking().GetSequenceNoByProject(ProjectID);
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
        public static int InsertColumnMapping(int ProjectFieldID, int ProjectID, int ColumnID, int FieldID, bool ForBilling, bool ForImport, bool ForUnique, int Sequence, string DateFormat, int FieldLength)
        {
            int ReturnValue = 0;

            Hashtable htmap = new Hashtable();
            htmap.Add("ProjectID", ProjectID);
            htmap.Add("ColumnID", ColumnID);
            htmap.Add("ProjectFieldID", ProjectFieldID);
            htmap.Add("SequenceNo", Sequence);
            htmap.Add("ForBilling", ForBilling);
            htmap.Add("ForImport", ForImport);
            htmap.Add("isCreate", false);
            htmap.Add("isUnique", ForUnique);
            htmap.Add("Dateformat", DateFormat);
            htmap.Add("FieldLength", FieldLength);
            htmap.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            bool Check = Convert.ToBoolean(new bllTracking().CheckIsAutoColumnByID(FieldID));
            if (Check == true)
            {
                htmap.Remove("isCreate");
                htmap.Add("isCreate", true);
                ReturnValue = new bllTracking().InsertColumnMapping(htmap);
            }
            else
            {
                ReturnValue = new bllTracking().InsertColumnMapping(htmap);
            }

            return ReturnValue;
        }


        [WebMethod]
        public static int InsertNewColumn()
        {
            int ReturnValue = 0;
            try
            {
                ReturnValue = new bllTracking().InsertNewColumn(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            }
            catch (Exception ex)
            {

            }
            return ReturnValue;
        }

        #endregion
    }
}
