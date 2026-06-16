using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Interop;
using WebPortal.App_Code.BLL;

namespace WebPortal.Accounts
{
    public partial class IncentiveMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //-------- General --------


        [WebMethod]
        public static string GetAllUsers()
        {
            DataTable dt1 = new bllMaster().GetAllUsers();

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
        public static string GetAllIncentives(string Month, string Year)
        {
            DataTable dt1 = new bllSalary().GetAllIncentives(Month, Convert.ToInt32(Year));

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
        public static string GetAllIncentivesForReport(string Month, string Year)
        {
            DataTable dt1 = new bllSalary().GetAllIncentivesForReport(Month, Convert.ToInt32(Year));

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
        public static string SaveIncentive(int ID, string Code, string Month, string Year, int Amount, string Remark)
        {
            string msg = string.Empty;

            try
            {
                if (ID == 0)
                {
                    Hashtable htParam = new Hashtable();
                    htParam.Add("Code", Code);
                    htParam.Add("Month", Month);
                    htParam.Add("Year", Year);
                    htParam.Add("Amount", Amount);
                    htParam.Add("Remark", Remark);
                    htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    int ReturnValue =  new bllSalary().InsertIncentive(htParam);

                    if (ReturnValue > 0)
                    {
                        msg = "Incentive saved successfully!";
                    }
                    else if (ReturnValue > 0)
                    {
                        msg = "Incentive already added for " + Code;
                    }
                    else
                    {
                        msg = "Error saving data";
                    }
                }
                else if (ID > 0)
                {
                    int ReturnValue =  new bllSalary().UpdateIncentive(ID, Amount, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    if (ReturnValue > 0)
                    {
                        msg = "Incentive updated successfully!";
                    }
                    else
                    {
                        msg = "Error saving data";
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
            return msg;
        }


        [WebMethod]
        public static int DeleteIncentive(int ID)
        {
            int returnvalue = 0;
            returnvalue = new bllSalary().DeleteIncentive(ID, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            return returnvalue;
        }


        //-------- Production --------

        [WebMethod]
        public static string SaveIncentive_production(string Code, string Month, string Year, string Amount, string Remark)
        {
            string msg = string.Empty;
            try
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("Code", Code);
                htParam.Add("Month", Month);
                htParam.Add("Year", Year);
                htParam.Add("Amount", Amount);
                htParam.Add("Remark", Remark);
                htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                int ReturnValue = new bllSalary().InsertOtherSalary(htParam);

                if (ReturnValue > 0)
                {
                    msg = "Incentive saved successfully!";
                }
                else if (ReturnValue > 0)
                {
                    msg = "Incentive already added for " + Code;
                }
                else
                {
                    msg = "Error saving data";
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }

            return msg;
        }


        [WebMethod]
        public static string GetAllOtherSalaryDetails_Report(string Month, string Year)
        {
            DataTable dt1 = new bllSalary().GetAllOtherSalaryDetails_Report(Month, Convert.ToInt32(Year));

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
        public static string GetAllOtherSalaryDetails(string Month, string Year)
        {
            DataTable dt1 = new bllSalary().GetAllOtherSalaryDetails(Month, Convert.ToInt32(Year));

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
        public static string SaveIncentive_production(int ID, string Code, string Month, string Year, int Amount, string Remark)
        {
            string msg = string.Empty;

            try
            {
                if (ID == 0)
                {
                    Hashtable htParam = new Hashtable();
                    htParam.Add("Code", Code);
                    htParam.Add("Month", Month);
                    htParam.Add("Year", Year);
                    htParam.Add("Amount", Amount);
                    htParam.Add("Remark", Remark);
                    htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    int ReturnValue =  new bllSalary().InsertOtherSalary(htParam);

                    if (ReturnValue > 0)
                    {
                        msg = "Incentive saved successfully!";
                    }
                    else if (ReturnValue > 0)
                    {
                        msg = "Incentive already added for " + Code;
                    }
                    else
                    {
                        msg = "Error saving data";
                    }
                }
                else if (ID > 0)
                {
                    int ReturnValue =  new bllSalary().UpdateOtherSalary(ID, Amount, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                    if (ReturnValue > 0)
                    {
                        msg = "Incentive updated successfully!";
                    }
                    else
                    {
                        msg = "Error saving data";
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
            return msg;
        }


        [WebMethod]
        public static int DeleteIncentive_production(int ID)
        {
            int returnvalue = 0;
            returnvalue =  new bllSalary().DeleteOtherSalary(ID, int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            return returnvalue;
        }


    }
}