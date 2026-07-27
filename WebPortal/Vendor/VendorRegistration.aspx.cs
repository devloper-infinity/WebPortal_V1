using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Vendor
{
    public partial class VendorRegistration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static List<LookupItem> GetReportingManagers()
        {
            DataTable table = new bllVendors().GetAllReportingManger();
            List<LookupItem> result = new List<LookupItem>();

            foreach (DataRow row in table.Rows)
            {
                result.Add(new LookupItem
                {
                    Value = Convert.ToString(row["VendorID"]),
                    Text = Convert.ToString(row["Fullname"])
                });
            }
            return result;
        }

        [WebMethod]
        public static string ValidateCode(string firstname, string middlename, string lastname, string EmployeeType)
        {
            return new CodeGeneration().genrateCode_Vendor(
                firstname ?? string.Empty,
                middlename ?? string.Empty,
                lastname ?? string.Empty,
                EmployeeType ?? string.Empty);
        }

        [WebMethod]
        public static List<Dictionary<string, object>> GetVendors()
        {
            DataTable table = new bllVendors().GetAllVendorRegistration();
            return ToRows(table);
        }

        [WebMethod]
        public static Dictionary<string, object> GetVendor(int vendorId)
        {
            DataTable table = new bllVendors().GetAllVendorRegistrationInfoByID(vendorId);
            if (table == null || table.Rows.Count == 0)
                return new Dictionary<string, object>();

            return ToRow(table.Rows[0]);
        }

        [WebMethod]
        public static ApiResult SaveVendor(VendorInput input)
        {
            try
            {
                if (input == null)
                    return ApiResult.Fail("Vendor details are required.");

                string validationMessage = ValidateInput(input);
                if (!string.IsNullOrEmpty(validationMessage))
                    return ApiResult.Fail(validationMessage);

                int addedBy;
                if (!int.TryParse(HttpContext.Current.User.Identity.Name, out addedBy))
                    return ApiResult.Fail("Unable to identify the logged-in user.");

                Hashtable parameters = new Hashtable();
                parameters["VendorID"] = input.VendorID;
                parameters["VendorCode"] = Safe(input.VendorCode).ToUpperInvariant();
                parameters["Title"] = Safe(input.Title);
                parameters["FirstName"] = Safe(input.FirstName).ToUpperInvariant();
                parameters["MiddleName"] = Safe(input.MiddleName).ToUpperInvariant();
                parameters["LastName"] = Safe(input.LastName).ToUpperInvariant();
                parameters["VendorType"] = Safe(input.VendorType);
                parameters["ReportingManager"] = input.VendorType == "Admin" ? "0" : Safe(input.ReportingManager);
                parameters["CompanyName"] = Safe(input.CompanyName);
                parameters["Address"] = Safe(input.Address);
                parameters["Contact1"] = Safe(input.Contact1);
                parameters["Contact2"] = Safe(input.Contact2);
                parameters["Extension"] = Safe(input.Extension);
                parameters["Mobile"] = Safe(input.Mobile);
                parameters["Fax"] = Safe(input.Fax);
                parameters["EmaiID"] = Safe(input.EmailID); // Existing BLL parameter spelling retained.
                parameters["AddedBy"] = addedBy;

                int returnValue;
                if (input.VendorID > 0)
                {
                    returnValue = new bllVendors().UpdateVendorRegistration(parameters);
                    return returnValue > 0
                        ? ApiResult.Ok("Vendor registration updated successfully.")
                        : ApiResult.Fail("Unable to update vendor registration.");
                }

                returnValue = new bllVendors().InsertVendorRegistration(parameters);
                return returnValue > 0
                    ? ApiResult.Ok("Vendor registration saved successfully.")
                    : ApiResult.Fail("Vendor registration already exists or could not be saved.");
            }
            catch (Exception ex)
            {
                return ApiResult.Fail(ex.Message);
            }
        }

        private static string ValidateInput(VendorInput input)
        {
            if (string.IsNullOrWhiteSpace(input.VendorCode)) return "Vendor code is required.";
            if (string.IsNullOrWhiteSpace(input.Title)) return "Title is required.";
            if (string.IsNullOrWhiteSpace(input.FirstName)) return "First name is required.";
            if (string.IsNullOrWhiteSpace(input.LastName)) return "Last name is required.";
            if (string.IsNullOrWhiteSpace(input.VendorType)) return "Vendor type is required.";
            if (input.VendorType != "Admin" && (string.IsNullOrWhiteSpace(input.ReportingManager) || input.ReportingManager == "0"))
                return "Reporting manager is required.";
            if (string.IsNullOrWhiteSpace(input.CompanyName)) return "Company name is required.";
            if (string.IsNullOrWhiteSpace(input.Address)) return "Address is required.";
            if (string.IsNullOrWhiteSpace(input.Contact1)) return "Contact number is required.";
            if (string.IsNullOrWhiteSpace(input.Extension)) return "Extension is required.";
            if (string.IsNullOrWhiteSpace(input.Fax)) return "Fax number is required.";
            if (string.IsNullOrWhiteSpace(input.EmailID)) return "Email address is required.";
            return string.Empty;
        }

        private static string Safe(string value)
        {
            return (value ?? string.Empty).Trim();
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;

            foreach (DataRow row in table.Rows)
                rows.Add(ToRow(row));

            return rows;
        }

        private static Dictionary<string, object> ToRow(DataRow row)
        {
            Dictionary<string, object> item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
            foreach (DataColumn column in row.Table.Columns)
                item[column.ColumnName] = row[column] == DBNull.Value ? null : row[column];
            return item;
        }

        public class LookupItem
        {
            public string Value { get; set; }
            public string Text { get; set; }
        }

        public class VendorInput
        {
            public int VendorID { get; set; }
            public string VendorCode { get; set; }
            public string Title { get; set; }
            public string FirstName { get; set; }
            public string MiddleName { get; set; }
            public string LastName { get; set; }
            public string VendorType { get; set; }
            public string ReportingManager { get; set; }
            public string CompanyName { get; set; }
            public string Address { get; set; }
            public string Contact1 { get; set; }
            public string Contact2 { get; set; }
            public string Extension { get; set; }
            public string Mobile { get; set; }
            public string Fax { get; set; }
            public string EmailID { get; set; }
        }

        public class ApiResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }

            public static ApiResult Ok(string message)
            {
                return new ApiResult { Success = true, Message = message };
            }

            public static ApiResult Fail(string message)
            {
                return new ApiResult { Success = false, Message = message };
            }
        }
    }
}