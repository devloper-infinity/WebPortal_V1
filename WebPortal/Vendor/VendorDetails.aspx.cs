using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using WebPortal.App_Code;
using WebPortal.App_Code.BLL;
using WebPortal.App_Code.DAL;

namespace WebPortal.Vendor
{
    public partial class VendorDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            HtmlGenericControl h1 = Master.FindControl("header") as HtmlGenericControl;
            HtmlGenericControl li = Master.FindControl("brdcrm") as HtmlGenericControl;
            if (h1 != null) h1.InnerText = "Vendor Details";
            if (li != null) li.InnerText = "Vendor Details";
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetInitialData()
        {
            try
            {
                bllVendors wbt = new bllVendors();
                DataTable vendors = wbt.GetAllVendorCompanies();
                DataTable companies = wbt.GetAllVendorCompanies("US");
                DataTable states = wbt.GetAllState();
                DataTable products = wbt.GetAllProductType();
                DataTable users = wbt.GetAllRegistredUser("Abstractor");

                Dictionary<string, object> selectedVendor = null;
                Dictionary<string, object> selectedUser = null;
                int id;
                if (Int32.TryParse(HttpContext.Current.Request.QueryString["AbstractorID"], out id) && id > 0)
                {
                    DataTable dt = wbt.GetAllVendorInfoByID(id);
                    if (dt.Rows.Count > 0) selectedVendor = RowToDictionary(dt.Rows[0]);
                }
                if (Int32.TryParse(HttpContext.Current.Request.QueryString["RegId"], out id) && id > 0)
                {
                    DataTable dt = wbt.GetSelectedRegUser(id);
                    if (dt.Rows.Count > 0) selectedUser = RowToDictionary(dt.Rows[0]);
                }

                return ApiResponse.Ok(new
                {
                    Vendors = ToRows(vendors),
                    Companies = ToRows(companies),
                    States = ToRows(states),
                    Products = ToRows(products),
                    Users = ToRows(users),
                    SelectedVendor = selectedVendor,
                    SelectedUser = selectedUser
                });
            }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse SaveVendor(VendorInput input)
        {
            try
            {
                if (input == null) return ApiResponse.Fail("Invalid request.");
                if (String.IsNullOrWhiteSpace(input.CompanyName)) return ApiResponse.Fail("Please enter Company Name.");
                if (String.IsNullOrWhiteSpace(input.EmailId)) return ApiResponse.Fail("Please enter Email Address.");

                Hashtable ht = new Hashtable();
                ht["CompanyName"] = input.CompanyName;
                ht["VendorName"] = input.VendorName;
                ht["NoofSeat"] = input.NoofSeat;
                ht["CellNumber"] = input.CellNumber;
                ht["ContactNumber1"] = input.ContactNumber1;
                ht["Address"] = input.Address;
                ht["State"] = input.State;
                ht["EmailId"] = input.EmailId;
                ht["WebSite"] = input.WebSite;
                ht["Working"] = input.Working;
                ht["ReceivedDate"] = input.ReceivedDate;
                ht["ProjectDescription"] = input.ProjectDescription;
                ht["AddedBy"] = CurrentUserId();

                int vendorId = InsertVendorDetails(ht);
                if (vendorId <= 0) return ApiResponse.Fail(vendorId == -1 ? "Vendor details already exist." : "Unable to save vendor details.");

                if (!String.IsNullOrWhiteSpace(input.FileName) && !String.IsNullOrWhiteSpace(input.FileBase64))
                {
                    string folder = HttpContext.Current.Server.MapPath("~/EmployeeDocuments/VendorDocs/" + vendorId);
                    Directory.CreateDirectory(folder);
                    string fileName = Path.GetFileName(input.FileName);
                    string physicalPath = Path.Combine(folder, fileName);
                    File.WriteAllBytes(physicalPath, Convert.FromBase64String(input.FileBase64));
                    UpdateVendorAttachment(vendorId, physicalPath);
                }
                return ApiResponse.Ok(null, "Vendor details saved successfully.");
            }
            catch (FormatException) { return ApiResponse.Fail("The uploaded attachment data is invalid."); }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse DeleteVendor(int applicationId)
        {
            try
            {
                int result = new bllVendors().DeleteVendorDetails(applicationId);
                return result == 1 ? ApiResponse.Ok(null, "Vendor deleted successfully.") : ApiResponse.Fail("Unable to delete the vendor.");
            }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse CheckUserExist(string code)
        {
            try
            {
                string result = new CodeGeneration().CheckUserExist((code ?? String.Empty).ToUpperInvariant());
                return ApiResponse.Ok(new { Exists = result == "2" || result == "3" });
            }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse SaveUser(UserInput input)
        {
            try
            {
                if (input == null || input.AbstractorID <= 0) return ApiResponse.Fail("Please select Company Name.");
                if (String.IsNullOrWhiteSpace(input.UserCode)) return ApiResponse.Fail("Please enter User Code.");
                if (input.Password != input.ConfirmPassword) return ApiResponse.Fail("Password and Confirm Password do not match.");
                Hashtable ht = new Hashtable();
                ht["UserType"] = "Abstractor";
                ht["UserCode"] = input.UserCode.ToUpperInvariant();
                ht["Password"] = input.Password;
                ht["ConfirmPassword"] = input.ConfirmPassword;
                ht["AbstractorID"] = input.AbstractorID;
                ht["RoleId"] = 3;
                ht["Activate"] = input.Activate;
                ht["AddedBy"] = CurrentUserId();
                int result = new bllVendors().InsertInfinityUserRegistration(ht);
                return ApiResponse.Ok(null, result > 0 ? "User registration saved successfully." : "User registration updated successfully.");
            }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetCounties(string stateCode)
        {
            try { return ApiResponse.Ok(new { Rows = ToRows(new bllOST().GetCountyForState(stateCode)) }); }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse SaveCosting(CostingInput input)
        {
            try
            {
                if (input == null || input.AbstractorID <= 0 || input.CountyId <= 0 || input.ProductId <= 0)
                    return ApiResponse.Fail("Please select Company, County and Product.");
                Hashtable ht = new Hashtable();
                ht["AbstractorID"] = input.AbstractorID;
                ht["CountyId"] = input.CountyId;
                ht["ProductId"] = input.ProductId;
                ht["MinTAT"] = input.MinTAT;
                ht["MaxTAT"] = input.MaxTAT;
                ht["ProductFees"] = input.ProductFees;
                ht["NofFreeCopies"] = input.NofFreeCopies;
                ht["FirstPageCharges"] = input.FirstPageCharges;
                ht["SubPageCharges"] = input.SubPageCharges;
                ht["CancellationTime"] = input.CancellationTime;
                ht["CancellationCharges"] = input.CancellationCharges;
                ht["Remark"] = input.Remark;
                ht["AddedBy"] = CurrentUserId();
                int result = new bllVendors().InsertAbstractorCostInformation(ht);
                if (result == -1) return ApiResponse.Fail("Costing already exists.");
                if (result == 0) return ApiResponse.Fail("Unable to add costing.");
                return ApiResponse.Ok(null, "Costing added successfully.");
            }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetCostings(int abstractorId)
        {
            try { return ApiResponse.Ok(new { Rows = ToRows(new bllVendors().GetAbstractorCosting(abstractorId)) }); }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse UploadDocument(DocumentInput input)
        {
            try
            {
                if (input == null || input.AbstractorID <= 0) return ApiResponse.Fail("Please select Company Name.");
                if (String.IsNullOrWhiteSpace(input.DocumentName)) return ApiResponse.Fail("Please select Document.");
                if (String.IsNullOrWhiteSpace(input.FileName) || String.IsNullOrWhiteSpace(input.FileBase64)) return ApiResponse.Fail("Please choose a file.");

                string folder = HttpContext.Current.Server.MapPath("~/EmployeeDocuments/AbstractorDocs/" + input.AbstractorID);
                Directory.CreateDirectory(folder);
                string fileName = Path.GetFileName(input.FileName);
                string physical = Path.Combine(folder, fileName);
                File.WriteAllBytes(physical, Convert.FromBase64String(input.FileBase64));
                string virtualPath = "~/EmployeeDocuments/AbstractorDocs/" + input.AbstractorID + "/" + fileName;

                Hashtable ht = new Hashtable();
                ht["AbstractorID"] = input.AbstractorID;
                ht["DocumentName"] = input.DocumentName;
                ht["UploadedBy"] = CurrentUserId();
                ht["Path"] = virtualPath;
                int result = new bllVendors().InsertAbstractorDocuments(ht);
                if (result == -1) return ApiResponse.Fail("Document already exists.");
                if (result == 0) return ApiResponse.Fail("Unable to upload document.");
                return ApiResponse.Ok(null, "Document uploaded successfully.");
            }
            catch (FormatException) { return ApiResponse.Fail("The uploaded file data is invalid."); }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetDocuments(int abstractorId)
        {
            try { return ApiResponse.Ok(new { Rows = ToRows(new bllVendors().GetAbstractorDocuments(abstractorId)) }); }
            catch (Exception ex) { return ApiResponse.Fail(ex.Message); }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static FileResponse DownloadFile(string path)
        {
            try
            {
                if (String.IsNullOrWhiteSpace(path)) return FileResponse.Fail("Document path is empty.");
                string physical;
                if (Path.IsPathRooted(path)) physical = path;
                else physical = HttpContext.Current.Server.MapPath(path.Replace("\\", "/"));
                string vendorRoot = Path.GetFullPath(HttpContext.Current.Server.MapPath("~/EmployeeDocuments/VendorDocs/"));
                string abstractorRoot = Path.GetFullPath(HttpContext.Current.Server.MapPath("~/EmployeeDocuments/AbstractorDocs/"));
                physical = Path.GetFullPath(physical);
                if (!physical.StartsWith(vendorRoot, StringComparison.OrdinalIgnoreCase) && !physical.StartsWith(abstractorRoot, StringComparison.OrdinalIgnoreCase))
                    return FileResponse.Fail("Invalid document path.");
                if (!File.Exists(physical)) return FileResponse.Fail("Document was not found.");
                return FileResponse.Ok(Path.GetFileName(physical), MimeMapping.GetMimeMapping(physical), Convert.ToBase64String(File.ReadAllBytes(physical)));
            }
            catch (Exception ex) { return FileResponse.Fail(ex.Message); }
        }

        private static int InsertVendorDetails(Hashtable ht)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_WBT_InsertVendorDetails");
            SQLHelper.AddParamToSQLCmd(cmd, "@CompanyName", SqlDbType.NVarChar, 1000, ParameterDirection.Input, ht["CompanyName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorName", SqlDbType.NVarChar, 4000, ParameterDirection.Input, ht["VendorName"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@NoofSeat", SqlDbType.NVarChar, 1000, ParameterDirection.Input, ht["NoofSeat"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@CellNumber", SqlDbType.NVarChar, 300, ParameterDirection.Input, ht["CellNumber"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ContactNumber1", SqlDbType.NVarChar, 300, ParameterDirection.Input, ht["ContactNumber1"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Address", SqlDbType.NVarChar, 300, ParameterDirection.Input, ht["Address"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@State", SqlDbType.NVarChar, 100, ParameterDirection.Input, ht["State"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@EmailId", SqlDbType.NVarChar, 100, ParameterDirection.Input, ht["EmailId"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@WebSite", SqlDbType.NVarChar, 100, ParameterDirection.Input, ht["WebSite"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@Working", SqlDbType.NVarChar, 100, ParameterDirection.Input, ht["Working"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReceivedDate", SqlDbType.NVarChar, 100, ParameterDirection.Input, ht["ReceivedDate"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ProjectDescription", SqlDbType.NVarChar, 5000, ParameterDirection.Input, ht["ProjectDescription"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@AddedBy", SqlDbType.Int, 0, ParameterDirection.Input, ht["AddedBy"]);
            SQLHelper.AddParamToSQLCmd(cmd, "@ReturnValue", SqlDbType.BigInt, 0, ParameterDirection.ReturnValue, null);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            int value = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            cmd.Dispose();
            return value;
        }

        private static void UpdateVendorAttachment(int vendorId, string path)
        {
            SqlCommand cmd = SQLHelper.GetCommand(CommandType.StoredProcedure, "usp_UpdateVendorAttachment");
            SQLHelper.AddParamToSQLCmd(cmd, "@VendorId", SqlDbType.BigInt, 0, ParameterDirection.Input, vendorId);
            SQLHelper.AddParamToSQLCmd(cmd, "@Path", SqlDbType.NVarChar, 4000, ParameterDirection.Input, path);
            SQLHelper.ExecuteNonQueryCmd(cmd);
            cmd.Dispose();
        }

        private static int CurrentUserId()
        {
            int id;
            if (!Int32.TryParse(HttpContext.Current.User.Identity.Name, out id)) throw new InvalidOperationException("Unable to identify the logged-in user.");
            return id;
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table == null) return rows;
            foreach (DataRow row in table.Rows) rows.Add(RowToDictionary(row));
            return rows;
        }

        private static Dictionary<string, object> RowToDictionary(DataRow row)
        {
            Dictionary<string, object> item = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
            foreach (DataColumn col in row.Table.Columns) item[col.ColumnName] = row[col] == DBNull.Value ? null : row[col];
            return item;
        }

        public sealed class VendorInput
        {
            public string CompanyName { get; set; }
            public string VendorName { get; set; }
            public string NoofSeat { get; set; }
            public string CellNumber { get; set; }
            public string ContactNumber1 { get; set; }
            public string Address { get; set; }
            public string State { get; set; }
            public string EmailId { get; set; }
            public string WebSite { get; set; }
            public string Working { get; set; }
            public string ReceivedDate { get; set; }
            public string ProjectDescription { get; set; }
            public string FileName { get; set; }
            public string FileBase64 { get; set; }
        }
        public sealed class UserInput { public int AbstractorID { get; set; } public string UserCode { get; set; } public string Password { get; set; } public string ConfirmPassword { get; set; } public bool Activate { get; set; } }
        public sealed class CostingInput
        {
            public int AbstractorID { get; set; }
            public int CountyId { get; set; }
            public int ProductId { get; set; }
            public string MinTAT { get; set; }
            public string MaxTAT { get; set; }
            public string ProductFees { get; set; }
            public string NofFreeCopies { get; set; }
            public string FirstPageCharges { get; set; }
            public string SubPageCharges { get; set; }
            public string CancellationTime { get; set; }
            public string CancellationCharges { get; set; }
            public string Remark { get; set; }
        }
        public sealed class DocumentInput { public int AbstractorID { get; set; } public string DocumentName { get; set; } public string FileName { get; set; } public string FileBase64 { get; set; } }

        public sealed class ApiResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public object Vendors { get; set; }
            public object Companies { get; set; }
            public object States { get; set; }
            public object Products { get; set; }
            public object Users { get; set; }
            public object SelectedVendor { get; set; }
            public object SelectedUser { get; set; }
            public object Rows { get; set; }
            public object Exists { get; set; }
            public static ApiResponse Ok(object data, string message = "")
            {
                ApiResponse r = new ApiResponse { Success = true, Message = message };
                if (data != null)
                {
                    foreach (System.Reflection.PropertyInfo p in data.GetType().GetProperties())
                    {
                        System.Reflection.PropertyInfo target = typeof(ApiResponse).GetProperty(p.Name);
                        if (target != null) target.SetValue(r, p.GetValue(data, null), null);
                    }
                }
                return r;
            }
            public static ApiResponse Fail(string message) { return new ApiResponse { Success = false, Message = message }; }
        }

        public sealed class FileResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public string FileName { get; set; }
            public string ContentType { get; set; }
            public string FileBase64 { get; set; }
            public static FileResponse Ok(string name, string type, string data) { return new FileResponse { Success = true, FileName = name, ContentType = type, FileBase64 = data }; }
            public static FileResponse Fail(string message) { return new FileResponse { Success = false, Message = message }; }
        }
    }
}