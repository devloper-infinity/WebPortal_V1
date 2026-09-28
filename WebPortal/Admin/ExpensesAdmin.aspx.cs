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

        //Submit Activity Category
        [WebMethod]
        public static string SaveExpenseActivityCategory(string AdminExp_ActivityCategory,int ActivityCategoryId)
        {
            string msg = string.Empty;
            try
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("ActivityCategoryId", ActivityCategoryId);
                htParam.Add("ActivityCategory", AdminExp_ActivityCategory);
                htParam.Add("CreatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                int ReturnValue = new bllMaster().SaveExpenseActivityCategory(htParam);

                if (ReturnValue > 0)
                {
                    msg = "Activity Category saved successfully!";
                }
                else if (ReturnValue == -1)
                {
                    msg = "Activity Category already exists!"; 
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

        //Get Activity Category for Update
        [WebMethod]
        public static string GetAdminExpActivityCategory()
        {
            DataTable dt1 = new bllMaster().GetAdminExpActivityCategory();
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
        // Activity Category Bind Dropdown
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
        [WebMethod]
        public static List<WebPortal.App_Code.Class.ActivityCategorycls> FetchAdminExpActivityCategory()
        {
            DataTable dtActivityCategory = null;
            dtActivityCategory = new bllMaster().GetAdminExpActivityCategory();
            List<WebPortal.App_Code.Class.ActivityCategorycls> RecreationActivity = new List<WebPortal.App_Code.Class.ActivityCategorycls>();
            RecreationActivity = ConvertDataTable<WebPortal.App_Code.Class.ActivityCategorycls>(dtActivityCategory);
            return RecreationActivity;
        }

        //Submit Activity 
        [WebMethod]
        public static string SaveExpenseActivity(int AdminExp_ActivityCategory,String AdminExp_Activity ,int activityId)
        {
            string msg = string.Empty;
            try
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("ActivityId", activityId);
                htParam.Add("ActivityCategoryId", AdminExp_ActivityCategory);
                htParam.Add("Activity", AdminExp_Activity);
                htParam.Add("CreatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                int ReturnValue = new bllMaster().SaveExpenseActivity(htParam);

                if (ReturnValue > 0)
                {
                    msg = "Activity saved successfully!";
                }
                else if (ReturnValue == -1)
                {
                    msg = "Activity already exists!";
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
        //Get Activity  for Update
        [WebMethod]
        public static string GetAdminExpActivity()
        {
            DataTable dt1 = new bllMaster().GetAdminExpActivity();
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
        //Fetch activities based on selected category
        [WebMethod]
        public static string GetActivitiesByCategory(int categoryId)
        {

            DataTable dt1 = new bllMaster().GetActivitiesByCategoryId(categoryId);

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
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
        public static string SaveYearlyBudget(int budgetId,int categoryId, int activityId, int locationId, int year, decimal budget)
        {
            string msg = string.Empty;
            try
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("ExpensesBugetId", budgetId);
                htParam.Add("ActivityCategoryId", categoryId);
                htParam.Add("ActivityId", activityId);
                htParam.Add("LocationId", locationId);
                htParam.Add("Year", year);
                htParam.Add("Budget", budget);
                htParam.Add("CreatedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                int ReturnValue = new bllMaster().SaveYearlyBudget(htParam);

                if (ReturnValue > 0)
                {
                    msg = "Budget saved successfully!";
                }
                else if (ReturnValue == -1)
                {
                    msg = "Budget for this year already exists!";
                }
                else
                {
                    msg = "Error saving budget data!";
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
            return msg;
        }

        [WebMethod]
        public static string GetAdminExpensesYearlyBudget()
        {
            DataTable dt1 = new bllMaster().GetAdminExpensesYearlyBudget();
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
        public static string SaveExpenseData(int expenseId, string LocationId, string RecreationActivity, string Quarter, string ActivitiesMonth, string CompletedDate, string ExpShift, string ActualExpense, string Status, string Remark)
        {
            string msg = string.Empty;
            try
            {
                Hashtable htParam = new Hashtable();
                htParam.Add("ExpenseId", expenseId);
                htParam.Add("Location", LocationId);
                htParam.Add("RecreationActivity", RecreationActivity);
                htParam.Add("Quarter", Quarter);
                htParam.Add("ActivitiesMonth", ActivitiesMonth);
                htParam.Add("CompletedDate", CompletedDate);
                htParam.Add("ExpShift", ExpShift);
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