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
using WebPortal.App_Code.DAL;

namespace WebPortal.IT
{
    public partial class VendorMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAllVendors()
        {
            DataTable dt1 = new bllAsset().GetAllVendor();
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
        public static int InsertVendor(int VendorID, string VendorName, string Description, string ContactPerson, string Address, string EmailID, string Phone, string Fax,
            string WebUrl, string AcctHolderName, string BankName, string BranchNameAddr, string AccountType, string AccountNum, string MICR, string IFSC, string GstNo, string PANNo)
        {
            int ReturnValue;

            try
            {
                #region Parameters
                Hashtable htparam = new Hashtable();
                htparam["VendorName"] = VendorName;
                htparam["Description"] = Description;
                htparam["Contact_Person"] = ContactPerson;
                htparam["Address"] = Address;
                htparam["EmailId"] = EmailID;
                htparam["Phone"] = Phone;
                htparam["Fax"] = Fax;
                htparam["Web_url"] = WebUrl;
                htparam["AccountHolderName"] = AcctHolderName;
                htparam["BankName"] = BankName;
                htparam["BranchNameAddr"] = BranchNameAddr;
                htparam["AccountType"] = AccountType;
                htparam["AccountNum"] = AccountNum;
                htparam["MICR"] = MICR;
                htparam["IFSC"] = IFSC;
                htparam["GSTNo"] = GstNo;
                htparam["PANNo"] = PANNo;
                htparam.Add("AddedBy", int.Parse(HttpContext.Current.User.Identity.Name.ToString()));

                #endregion

                if (VendorID == 0)
                    ReturnValue =  new bllAsset().InsertVendor(htparam);
                else if (VendorID > 0)
                    ReturnValue =  new bllAsset().UpdateVendor(htparam, VendorID);
                else
                    ReturnValue = 0;
            }
            catch (Exception ex)
            {
                ReturnValue = 0;
            }
            return ReturnValue;
        }
    }
}