using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices.ComTypes;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Interop;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ExpensesAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //Submit Recreation Activity
        [WebMethod]
        public static string SaveExpenseRecreationActivity(string RecreationActivity)
        {
            string msg = string.Empty;
            try
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("RecreationActivity", RecreationActivity);
                htParam.Add("CreatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                int ReturnValue = new bllMaster().SaveExpenseRecreationActivity(htParam);

                if (ReturnValue > 0)
                {
                    msg = "Recreation Activity saved successfully!";
                }
                else if (ReturnValue == -1)
                {
                    msg = "Recreation Activity already exists!"; 
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


        private static List<T> ConvertDataTable<T>(DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }
        private static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                        pro.SetValue(obj, dr[column.ColumnName], null);
                    else
                        continue;
                }
            }
            return obj;
        }

        //Fetch Recreation Activity
        [WebMethod]
        public static List<WebPortal.App_Code.Class.RecreationActivitycls> GetRecreationActivity()
        {
            DataTable dtRecreationActivity = null;
            dtRecreationActivity = new bllMaster().GetRecreationActivity();
            List<WebPortal.App_Code.Class.RecreationActivitycls> RecreationActivity = new List<WebPortal.App_Code.Class.RecreationActivitycls>();
            RecreationActivity = ConvertDataTable<WebPortal.App_Code.Class.RecreationActivitycls>(dtRecreationActivity);
            return RecreationActivity;
        }



        [WebMethod]
        public static string SaveExpenseData(int expenseId,string Location, string OtherActivity, string Date, string CompletedDate, string ActualExpense, string Status, string Remark)
        {
            string msg = string.Empty;
            try
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("ExpenseId", expenseId);
                htParam.Add("Location", Location);
                htParam.Add("OtherActivity", OtherActivity);
                htParam.Add("Date", Date);
                htParam.Add("CompletedDate", CompletedDate);
                htParam.Add("ActualExpense", ActualExpense);
                htParam.Add("Status", Status);
                htParam.Add("Remark", Remark);
                htParam.Add("CreatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));


                int ReturnValue = new bllMaster().InsertAdminExpensesData(htParam);

                if (ReturnValue > 0)
                {
                    msg = "Data saved successfully!";
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
        public static string GetAdminExpenseData()
        {
            DataTable dt1 = new bllMaster().GetAdminExpenseData();
            List<string> columnNames = new List<string>();
            foreach (DataColumn col in dt1.Columns)
            {
                columnNames.Add(col.ColumnName);
            }
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            foreach (DataRow dr in dt1.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
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
        public static string GetAdminExpenseDataForReport(string FromDate, string ToDate)
        {
            DataSet ds = new bllMaster().GetAdminExpenseDataForReport(FromDate, ToDate);
            Func<DataTable, List<Dictionary<string, object>>> convertTableToList = (dt) => {
                var rows = new List<Dictionary<string, object>>();
                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        var row = new Dictionary<string, object>();
                        foreach (DataColumn col in dt.Columns)
                        {
                            row.Add(col.ColumnName, dr[col]);
                        }
                        rows.Add(row);
                    }
                }
                return rows;
            };

            var resultData = new Dictionary<string, object>();
            resultData["details"] = (ds.Tables.Count > 0) ? convertTableToList(ds.Tables[0]) : new List<Dictionary<string, object>>();
            resultData["summary"] = (ds.Tables.Count > 1) ? convertTableToList(ds.Tables[1]) : new List<Dictionary<string, object>>();
            resultData["locationSummary"] = (ds.Tables.Count > 2) ? convertTableToList(ds.Tables[2]) : new List<Dictionary<string, object>>();
            resultData["activitySummary"] = (ds.Tables.Count > 3) ? convertTableToList(ds.Tables[3]) : new List<Dictionary<string, object>>();

            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            return ser.Serialize(resultData);
        }
    }
}