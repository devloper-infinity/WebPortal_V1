using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace WebPortal.Admin
{
    public partial class TDSSection : System.Web.UI.Page
    {
        static string NewFileName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string code = new bllMaster().GetCodeFromEmployeeId(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
                HttpContext postedContext = HttpContext.Current;
                HttpPostedFile file = postedContext.Request.Files[0];

                string name = file.FileName;
                byte[] binaryWriteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(binaryWriteArray, 0,
                (int)file.InputStream.Length);

                FileInfo file_Info = new FileInfo(file.FileName);
                string ext = file_Info.Extension;

                string file_Name = Guid.NewGuid().ToString() + "_" + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + ext;
                NewFileName = Server.MapPath("..//Images//" + file_Name);
                FileStream objfilestream = new FileStream(NewFileName, FileMode.Create, FileAccess.ReadWrite);
                objfilestream.Write(binaryWriteArray, 0,
                binaryWriteArray.Length);
                objfilestream.Close();
                string filename = Convert.ToString(Request.Files["attachment"].FileName);
            }
            catch { }
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

        [WebMethod]
        public static List<Tax> GetTaxSlab()
        {
            DataTable dtTax = new bllSalary().GetTaxSlab(int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            List<Tax> tx = new List<Tax>();
            tx = ConvertDataTable<Tax>(dtTax);
            return tx;
        }

        [WebMethod]
        public static string GetDeductionDetails(string TaxSlab)
        {
            string Code = new bllMaster().GetCodeFromEmployeeId(Convert.ToInt32(HttpContext.Current.User.Identity.Name));
            DataTable dt1;
            if (TaxSlab == "Old")
                dt1 = new bllSalary().GetViewTDSDeclaration_OLD("", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            else if (TaxSlab == "New")
                dt1 = new bllSalary().GetViewTDSDeclaration_NEW("", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            else
                dt1 = new bllSalary().GetViewTDSDeclaration("", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

            if (dt1 != null)
            {
                if (dt1.Rows.Count > 0)
                {
                    dt1.Columns.Add("Details");
                    dt1.Columns[0].ColumnName = "Description";
                    dt1.Columns[1].ColumnName = "Value";
                    for (int i = 0; i < dt1.Rows.Count; i++)
                    {
                        string Desc = Convert.ToString(dt1.Rows[i]["Description"]);
                        if (Desc == "Leave Encashment")
                        {
                            dt1.Rows[i][2] = "Approx leave encashment based on full attendance";
                        }
                        if (Desc == "Approx. Annual Salary")
                        {
                            dt1.Rows[i][2] = "Actual Calculated Net Salary till month + Approx gross salary of remaining months";
                        }
                        if (Desc == "Total Salary(Approx)")
                        {
                            dt1.Rows[i][2] = "(Approx. Annual Salary + Leave Encashment + Last Year Difference + Bonus + Incentive + Salary Difference)";
                        }
                        if (Desc == "Child Education Allowance")
                        {
                            dt1.Rows[i][2] = "Maximum Deduction Limit : 2400";
                        }
                        if (Desc == "Balance Salary")
                        {
                            dt1.Rows[i][2] = "(Total Salary(Approx) - Total Exemption)";
                        }
                        if (Desc == "Professional Tax")
                        {
                            dt1.Rows[i][2] = "Annual Professional Tax";
                        }
                        if (Desc == "Net Taxable Salary")
                        {
                            dt1.Rows[i][2] = "(Balance Salary - Professional Tax)";
                        }
                        if (Desc == "Housing Loan Interest")
                        {
                            dt1.Rows[i][2] = "Maximum Deduction Limit : 2,00,000";
                        }
                        if (Desc == "Gross Total Income")
                        {
                            dt1.Rows[i][2] = "(Net Total Income - Applicable Deduction for Interest on Housing Loan)";
                        }
                        if (Desc == "Employee contribution to PF")
                        {
                            dt1.Rows[i][2] = "Actual PF deducted till month+ Approx. PF deduction for remaining months";
                        }
                        if (Desc == "Total Eligible Deductions")
                        {
                            dt1.Rows[i][2] = "Maximum Deduction Limit : 1,50,000";
                        }
                        if (Desc == "Infrastructure Bonds-VIA")
                        {
                            dt1.Rows[i][2] = "Maximum Deduction Limit : 20,000";
                        }
                        if (Desc == "80D (Medical insurance premium, Self/Family)")
                        {
                            dt1.Rows[i][2] = "Maximum Deduction Limit : 25,000";
                        }
                        if (Desc == "80D (Medical insurance premium, Parents)")
                        {
                            dt1.Rows[i][2] = "Maximum Deduction Limit : 25,000";
                        }
                        if (Desc == "80U (Handicapped person)")
                        {
                            dt1.Rows[i][2] = "Maximum Deduction Limit : 75,000";
                        }
                        if (Desc == "80DD (50% Handicapped person)")
                        {
                            dt1.Rows[i][2] = "Maximum Deduction Limit : 75,000 or 1,20,000";
                        }
                        if (Desc == "Net Taxble Income")
                        {
                            dt1.Rows[i][2] = "(Gross Total Income - Total Eligible Deductions - Total Deduction 80D, 80E,80U, 80G)";
                        }
                        if (Desc == "Income Tax after rebate u/s 87A")
                        {
                            dt1.Rows[i][2] = "Please refer the link at the top of the page for example.";
                        }
                        if (Desc == "Health & Education Cess")
                        {
                            dt1.Rows[i][2] = "(Income Tax after rebate u/s 87A) * 4 %";
                        }
                        if (Desc == "Actual Total Tax Liability")
                        {
                            dt1.Rows[i][2] = "(Income Tax after rebate u/s 87A) + (Health & Education Cess)";
                        }
                        if (Desc == "Total Tax Liability")
                        {
                            dt1.Rows[i][2] = "(Actual Total Tax Liability) - (TDS Deducted till month)";
                        }
                        dt1.AcceptChanges();
                    }
                }
            }

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
        public static List<TDSCategory> GetCategories()
        {
            DataTable dtcat = new bllSalary().GetAllCategory();
            List<TDSCategory> cat = new List<TDSCategory>();
            cat = ConvertDataTable<TDSCategory>(dtcat);
            return cat;
        }

        [WebMethod]
        public static List<TDSDocuments> getDocumentList(string Category)
        {
            DataTable dtDoc = new bllSalary().GetAllDocumentNameByCategory(Category);
            List<TDSDocuments> doc = new List<TDSDocuments>();
            doc = ConvertDataTable<TDSDocuments>(dtDoc);
            return doc;
        }
    }
}