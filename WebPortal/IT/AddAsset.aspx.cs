using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.Class;

namespace WebPortal.IT
{
    public partial class AddAsset : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static List<WebPortal.App_Code.Class.Branch> GetBranches()
        {
            DataTable dtBranch = null;
            dtBranch = new bllMaster().GetAllBranches();
            List<WebPortal.App_Code.Class.Branch> Bran = new List<WebPortal.App_Code.Class.Branch>();
            Bran = ConvertDataTable<WebPortal.App_Code.Class.Branch>(dtBranch);
            return Bran;
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
        public static string GetAllAssetsTypesByGroupID(int GroupID)
        {
            DataTable dt1 = new bllAsset().BindAssetType(GroupID);
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
        public static string GetAssetVendor()
        {
            DataTable dt1 = new bllAsset().BindAssetVendor();
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
        public static string GetAssetAbbreviation(string AssetTypes)
        {
            string dt1 = new bllAsset().GetAbbreviation(AssetTypes);

            return dt1;
        }
        [WebMethod]
        public static int GetAssetCount(int AssetTypeId)
        {
            int dt1 = new bllAsset().CreateBarcode(AssetTypeId);
            return dt1;
        }

        [WebMethod]
        public static List<Department> GetDepartment()
        {
            DataTable dtdept = new bllMaster().GetAllDepartment();

            List<Department> depart = new List<Department>();
            depart = ConvertDataTable<Department>(dtdept);
            return depart;
        }

        [WebMethod]
        public static int InsertAssets(string AssetName, int AssetType, string AssetSrNo, string Barcode, int CompanyId, int BrandId, int DeptId, int LocationId, string PurchaseCost, int VendorId, string AcqDate, string ExpDate, int AssetStatus, int GroupId, string Remark, string PONumber, string InvoiceNumber, string PurchaseDate, string TaxAmount)
        {
            int returnvalue = 0;
            Hashtable htParam = new Hashtable();
            htParam.Add("AssetName", AssetName);
            htParam.Add("AssetType", AssetType);
            htParam.Add("assetslno", AssetSrNo);
            htParam.Add("Barcode", Barcode);
            htParam.Add("CompanyId", CompanyId);
            htParam.Add("BrandId", BrandId);
            htParam.Add("DeptId", DeptId);
            htParam.Add("LocationId", LocationId);
            htParam.Add("PurchaseCost", PurchaseCost);
            htParam.Add("vendorId", VendorId);
            htParam.Add("Acqdate", AcqDate);
            htParam.Add("Expdate", ExpDate);
            htParam.Add("AssetStatus", AssetStatus);
            htParam.Add("GroupId", GroupId);
            htParam.Add("Remark", Remark);
            htParam.Add("PONumber", PONumber);
            htParam.Add("InvoiceNumber", InvoiceNumber);
            htParam.Add("OldBarcode", "");
            htParam.Add("PurchaseDate", PurchaseDate);
            htParam.Add("TaxAmount", TaxAmount);
            htParam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));
            returnvalue = new bllAsset().InsertAsset(htParam);
            return returnvalue;
        }
    }
}