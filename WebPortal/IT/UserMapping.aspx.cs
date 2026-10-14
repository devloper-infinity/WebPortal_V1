using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.IT
{
    public partial class UserMapping : Page
    {
        public int HeaderID { get; private set; }
        public string Month { get; private set; }
        public string Year { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            HeaderID = 0;
            Month = (Request.QueryString["Month"] ?? string.Empty).Trim();
            Year = (Request.QueryString["Year"] ?? string.Empty).Trim();
            int headerID;
            if (!int.TryParse(Request.QueryString["HeaderID"], out headerID) || headerID <= 0)
            {
                SetLoadError("The invoice link does not contain a valid invoice ID.");
                return;
            }
            try
            {
                GetAuthorizedContext(headerID);
                HeaderID = headerID;
            }
            catch (UnauthorizedAccessException ex) { SetLoadError(ex.Message); }
            catch (InvalidOperationException ex) { SetLoadError(ex.Message); }
            catch (Exception ex) { SetLoadError("Invoice loading failed: " + ex.Message); }
        }

        private void SetLoadError(string message)
        {
            HeaderID = 0;
            string errorJson = new JavaScriptSerializer().Serialize(message ?? "Unable to load the selected invoice.");
            ScriptManager.RegisterStartupScript(this, GetType(), "umLoadError", "window.umLoadError=" + errorJson + ";", true);
        }

        private static int CurrentUserID()
        {
            HttpContext context = HttpContext.Current;
            int userID;
            if (context == null || context.User == null || context.User.Identity == null || !context.User.Identity.IsAuthenticated ||
                !int.TryParse(context.User.Identity.Name, out userID) || userID <= 0)
                throw new InvalidOperationException("Please sign in again.");
            return userID;
        }

        private static DataRow GetAuthorizedContext(int headerID)
        {
            int userID = CurrentUserID();
            DataTable context = new bllCCUserMapping().GetInvoiceContext(headerID);
            if (context == null || context.Rows.Count == 0)
            {
                HttpRequest request = HttpContext.Current.Request;
                string month = Clean(request.QueryString["Month"]);
                string year = Clean(request.QueryString["Year"]);
                if (month.Length == 0) month = "All";
                if (year.Length == 0) year = DateTime.Today.Year.ToString(CultureInfo.InvariantCulture);
                DataTable listedInvoices = new bllMaster().GetAllInvoiceHeaders(month, year, string.Empty);
                DataRow listedInvoice = listedInvoices == null || !listedInvoices.Columns.Contains("HeaderID") ? null :
                    listedInvoices.AsEnumerable().FirstOrDefault(row =>
                    {
                        int listedHeaderID;
                        return int.TryParse(Convert.ToString(row["HeaderID"]), out listedHeaderID) && listedHeaderID == headerID;
                    });
                if (listedInvoice == null) throw new InvalidOperationException("Invoice was not found in the selected billing period.");
                context = listedInvoices.Clone();
                context.ImportRow(listedInvoice);
            }
            DataRow invoice = context.Rows[0];
            int projectID = Convert.ToInt32(invoice["ProjectID"]);
            if (projectID <= 0) throw new InvalidOperationException("This invoice is not assigned to a project.");

            DataTable allowedProjects = new bllMaster().GetAllProjectByUserRights(userID.ToString(CultureInfo.InvariantCulture));
            bool allowed = false;
            if (allowedProjects != null && allowedProjects.Columns.Contains("ProjectID"))
                foreach (DataRow project in allowedProjects.Rows)
                    if (project["ProjectID"] != DBNull.Value && Convert.ToInt32(project["ProjectID"]) == projectID) { allowed = true; break; }
            if (!allowed) throw new UnauthorizedAccessException("You do not have access to this invoice.");
            return invoice;
        }

        private static string Json(DataTable table)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (table != null)
                foreach (DataRow source in table.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                    foreach (DataColumn column in table.Columns)
                    {
                        object value = source[column];
                        if (value == DBNull.Value) value = null;
                        else if (value is DateTime) value = ((DateTime)value).ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
                        row[column.ColumnName] = value;
                    }
                    rows.Add(row);
                }
            JavaScriptSerializer serializer = new JavaScriptSerializer { MaxJsonLength = int.MaxValue };
            return serializer.Serialize(rows);
        }

        private static DateTime ParseDate(string value, string label, bool required)
        {
            DateTime date;
            if (string.IsNullOrWhiteSpace(value) && !required) return DateTime.MinValue;
            if (!DateTime.TryParseExact(value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date))
                throw new InvalidOperationException("Enter a valid " + label + ".");
            return date.Date;
        }

        private static DateTime? ParseOptionalDate(string value, string label)
        {
            return string.IsNullOrWhiteSpace(value) ? (DateTime?)null : ParseDate(value, label, true);
        }

        private static string Clean(string value) { return (value ?? string.Empty).Trim(); }

        private static string FindEmployeeEmail(string code, bool requireEmployee)
        {
            DataTable employees = new bllMaster().GetAllUsers_1();
            if (employees == null || !employees.Columns.Contains("Code"))
            {
                if (requireEmployee) throw new InvalidOperationException("Unable to validate the employee selection.");
                return string.Empty;
            }
            DataRow employee = employees.AsEnumerable().FirstOrDefault(row => string.Equals(Clean(Convert.ToString(row["Code"])), code, StringComparison.OrdinalIgnoreCase));
            if (employee == null)
            {
                if (requireEmployee) throw new InvalidOperationException("Select an employee from the employee list.");
                return string.Empty;
            }
            string[] emailColumns = { "EmailAddress", "Email", "EmailID", "OfficialEmail" };
            string emailColumn = emailColumns.FirstOrDefault(employees.Columns.Contains);
            return emailColumn == null || employee[emailColumn] == DBNull.Value ? string.Empty : Clean(Convert.ToString(employee[emailColumn]));
        }

        private static void EnsureResourceAccess(DataRow invoice, int resourceID)
        {
            DataTable resources = new bllCCUserMapping().GetResources(Convert.ToInt32(invoice["ProjectID"]));
            if (resources == null || !resources.AsEnumerable().Any(row => Convert.ToInt32(row["ResourceID"]) == resourceID))
                throw new UnauthorizedAccessException("Corporate resource is not part of this invoice project.");
        }

        private static void EnsureMappingAccess(DataRow invoice, int mappingID)
        {
            DataTable resources = new bllCCUserMapping().GetResources(Convert.ToInt32(invoice["ProjectID"]));
            bool belongs = false;
            if (resources != null)
                foreach (DataRow resource in resources.Rows)
                {
                    DataTable mappings = new bllCCUserMapping().GetResourceMappings(Convert.ToInt32(resource["ResourceID"]));
                    if (mappings != null && mappings.AsEnumerable().Any(mapping => Convert.ToInt32(mapping["MappingID"]) == mappingID &&
                        (!mappings.Columns.Contains("IsHistory") || !Convert.ToBoolean(mapping["IsHistory"])) && Convert.ToBoolean(mapping["IsActive"])))
                    { belongs = true; break; }
                }
            if (!belongs) throw new UnauthorizedAccessException("Active employee mapping is not part of this invoice project.");
        }

        [WebMethod]
        public static string GetContext(int headerID)
        {
            DataRow row = GetAuthorizedContext(headerID);
            Dictionary<string, object> result = new Dictionary<string, object>();
            foreach (DataColumn column in row.Table.Columns)
            {
                object value = row[column];
                result[column.ColumnName] = value == DBNull.Value ? null : value;
            }
            return new JavaScriptSerializer().Serialize(result);
        }

        [WebMethod]
        public static string GetEmployees(int headerID)
        {
            GetAuthorizedContext(headerID);
            DataTable employees = new bllMaster().GetAllUsers_1();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            if (employees != null)
                foreach (DataRow employee in employees.Rows)
                {
                    string code = employees.Columns.Contains("Code") ? Clean(Convert.ToString(employee["Code"])) : string.Empty;
                    string name = employees.Columns.Contains("FullName") ? Clean(Convert.ToString(employee["FullName"])) : code;
                    if (code.Length == 0 || name.Length == 0) continue;
                    string email = string.Empty;
                    string[] emailColumns = { "EmailAddress", "Email", "EmailID", "OfficialEmail" };
                    string emailColumn = emailColumns.FirstOrDefault(employees.Columns.Contains);
                    if (emailColumn != null && employee[emailColumn] != DBNull.Value) email = Clean(Convert.ToString(employee[emailColumn]));
                    rows.Add(new Dictionary<string, object> { { "Code", code }, { "FullName", name }, { "EmailAddress", email } });
                }
            return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(rows);
        }

        [WebMethod]
        public static string GetInvoiceUsers(int headerID, string month, string year)
        {
            GetAuthorizedContext(headerID);
            return Json(new bllMaster().GetHeaderwiseDetailsRevised(headerID, Clean(month), Clean(year)));
        }

        [WebMethod]
        public static int AddInvoiceUser(int headerID, string code, string otherUser, string emailAddress, string effectiveDate)
        {
            GetAuthorizedContext(headerID);
            code = Clean(code); otherUser = Clean(otherUser); emailAddress = Clean(emailAddress);
            if (code.Length == 0 || code.Length > 200) throw new InvalidOperationException("Select a valid employee.");
            if (string.Equals(code, "Other", StringComparison.OrdinalIgnoreCase) && otherUser.Length == 0)
                throw new InvalidOperationException("Enter the other user name.");
            if (otherUser.Length > 200) throw new InvalidOperationException("Other user name is too long.");
            if (!string.Equals(code, "Other", StringComparison.OrdinalIgnoreCase)) emailAddress = FindEmployeeEmail(code, true);
            DateTime from = ParseDate(effectiveDate, "effective date", true);
            if (emailAddress.Length > 500) throw new InvalidOperationException("Email address is too long.");
            System.Collections.Hashtable values = new System.Collections.Hashtable();
            values.Add("HeaderID", headerID); values.Add("Code", code); values.Add("OtherUser", otherUser);
            values.Add("EmailAddress", emailAddress); values.Add("EffectiveDate", from.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture));
            return new bllMaster().InsertCCDetails(values);
        }

        [WebMethod]
        public static int EndInvoiceUser(int headerID, int invoiceUserID, string effectiveDate)
        {
            GetAuthorizedContext(headerID);
            DataTable existingUsers = new bllMaster().GetHeaderwiseDetails(headerID);
            if (existingUsers == null || !existingUsers.Columns.Contains("InvID") || !existingUsers.AsEnumerable().Any(row => Convert.ToInt32(row["InvID"]) == invoiceUserID))
                throw new InvalidOperationException("This user mapping does not belong to the selected invoice.");
            DateTime effectiveTo = ParseDate(effectiveDate, "effective date", true);
            System.Collections.Hashtable values = new System.Collections.Hashtable();
            values.Add("InvID", invoiceUserID); values.Add("EffectiveDate", effectiveTo.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture));
            return new bllMaster().RemoveCCUser(values);
        }

        [WebMethod]
        public static string GetProjects(int headerID)
        {
            GetAuthorizedContext(headerID);
            return Json(new bllMaster().GetAllProjectByUserRights(CurrentUserID().ToString(CultureInfo.InvariantCulture)));
        }

        [WebMethod]
        public static string GetDomains(int headerID)
        {
            GetAuthorizedContext(headerID);
            return Json(new bllMaster().GetInvoiceDomains());
        }

        [WebMethod]
        public static string GetResources(int headerID, int projectID)
        {
            DataRow invoice = GetAuthorizedContext(headerID);
            int invoiceProjectID = Convert.ToInt32(invoice["ProjectID"]);
            if (projectID != 0 && projectID != invoiceProjectID) throw new UnauthorizedAccessException("Corporate resources are limited to the selected invoice project.");
            projectID = invoiceProjectID;
            return Json(new bllCCUserMapping().GetResources(projectID));
        }

        private static bool ResourceTypeIsValid(string value)
        {
            string[] allowed = { "Shared Mailbox", "Microsoft Teams Resource", "Departmental Account", "Shared/Common Account", "Service Account", "Other" };
            return allowed.Contains(value, StringComparer.OrdinalIgnoreCase);
        }

        [WebMethod]
        public static int SaveResource(int headerID, int resourceID, string resourceName, string resourceType, string accountIdentifier,
            int projectID, string departmentDomain, string description, string effectiveFrom, string effectiveTo, bool isActive, string remark)
        {
            DataRow invoice = GetAuthorizedContext(headerID);
            resourceName = Clean(resourceName); resourceType = Clean(resourceType); accountIdentifier = Clean(accountIdentifier);
            departmentDomain = Clean(departmentDomain); description = Clean(description); remark = Clean(remark);
            if (resourceName.Length == 0 || resourceName.Length > 255) throw new InvalidOperationException("Resource name is required (up to 255 characters).");
            if (!ResourceTypeIsValid(resourceType)) throw new InvalidOperationException("Select a valid resource type.");
            if (accountIdentifier.Length > 255) throw new InvalidOperationException("Account identifier is too long.");
            if (accountIdentifier.Contains("@"))
            {
                try { MailAddress parsed = new MailAddress(accountIdentifier); if (!string.Equals(parsed.Address, accountIdentifier, StringComparison.OrdinalIgnoreCase)) throw new FormatException(); }
                catch { throw new InvalidOperationException("Enter a valid email address or account identifier."); }
            }
            DateTime from = ParseDate(effectiveFrom, "effective from date", true);
            DateTime? to = ParseOptionalDate(effectiveTo, "effective to date");
            if (to.HasValue && to.Value < from) throw new InvalidOperationException("Effective To cannot be earlier than Effective From.");
            int userID = CurrentUserID();
            DataTable projects = new bllMaster().GetAllProjectByUserRights(userID.ToString(CultureInfo.InvariantCulture));
            if (projects == null || !projects.Columns.Contains("ProjectID") || !projects.AsEnumerable().Any(r => Convert.ToInt32(r["ProjectID"]) == projectID))
                throw new UnauthorizedAccessException("Select a project you can access.");
            if (projectID != Convert.ToInt32(invoice["ProjectID"])) throw new InvalidOperationException("Corporate resources must belong to the invoice project.");
            if (resourceID > 0) EnsureResourceAccess(invoice, resourceID);
            return new bllCCUserMapping().SaveResource(resourceID, resourceName, resourceType, accountIdentifier, projectID,
                departmentDomain, description, from, to, isActive, remark, userID);
        }

        [WebMethod]
        public static int SetResourceStatus(int headerID, int resourceID, bool isActive)
        {
            DataRow invoice = GetAuthorizedContext(headerID);
            EnsureResourceAccess(invoice, resourceID);
            new bllCCUserMapping().SetResourceStatus(resourceID, isActive, CurrentUserID());
            return 1;
        }

        [WebMethod]
        public static string GetMappings(int headerID, int resourceID)
        {
            DataRow invoice = GetAuthorizedContext(headerID);
            EnsureResourceAccess(invoice, resourceID);
            return Json(new bllCCUserMapping().GetResourceMappings(resourceID));
        }

        [WebMethod]
        public static int SaveMappings(int headerID, int resourceID, string[] employeeCodes, string effectiveFrom, string effectiveTo)
        {
            DataRow invoice = GetAuthorizedContext(headerID);
            EnsureResourceAccess(invoice, resourceID);
            DateTime from = ParseDate(effectiveFrom, "mapping effective from date", true);
            DateTime? to = ParseOptionalDate(effectiveTo, "mapping effective to date");
            if (to.HasValue && to.Value < from) throw new InvalidOperationException("Mapping Effective To cannot be earlier than Effective From.");
            if (employeeCodes == null || employeeCodes.Length == 0) throw new InvalidOperationException("Select at least one employee.");
            DataTable employees = new bllMaster().GetAllUsers_1();
            HashSet<string> validCodes = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            if (employees != null && employees.Columns.Contains("Code"))
                foreach (DataRow row in employees.Rows) validCodes.Add(Clean(Convert.ToString(row["Code"])));
            List<string> codes = employeeCodes.Select(Clean).Where(c => c.Length > 0).Distinct(StringComparer.OrdinalIgnoreCase).ToList();
            if (codes.Count == 0 || codes.Any(c => !validCodes.Contains(c))) throw new InvalidOperationException("Select employees from the employee list.");
            new bllCCUserMapping().SaveMappings(resourceID, codes, from, to, CurrentUserID());
            return codes.Count;
        }

        [WebMethod]
        public static int EndMapping(int headerID, int mappingID, string effectiveTo)
        {
            DataRow invoice = GetAuthorizedContext(headerID);
            EnsureMappingAccess(invoice, mappingID);
            new bllCCUserMapping().EndMapping(mappingID, ParseDate(effectiveTo, "mapping end date", true), CurrentUserID());
            return 1;
        }

        [WebMethod]
        public static int UpdateMapping(int headerID, int mappingID, string effectiveFrom, string effectiveTo)
        {
            DataRow invoice = GetAuthorizedContext(headerID);
            EnsureMappingAccess(invoice, mappingID);
            DateTime from = ParseDate(effectiveFrom, "mapping effective from date", true);
            DateTime? to = ParseOptionalDate(effectiveTo, "mapping effective to date");
            if (to.HasValue && to.Value < from) throw new InvalidOperationException("Mapping Effective To cannot be earlier than Effective From.");
            new bllCCUserMapping().UpdateMapping(mappingID, from, to, CurrentUserID());
            return 1;
        }

        [WebMethod]
        public static int AssociateBilling(int headerID, string month, string year, int resourceID)
        {
            DataRow invoice = GetAuthorizedContext(headerID);
            month = Clean(month); year = Clean(year);
            DateTime period;
            if (!DateTime.TryParseExact("01 " + month + " " + year, "dd MMMM yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out period))
                throw new InvalidOperationException("A valid billing month and year are required.");
            DataTable resources = new bllCCUserMapping().GetResources(Convert.ToInt32(invoice["ProjectID"]));
            DataRow resource = resources == null ? null : resources.AsEnumerable().FirstOrDefault(r => Convert.ToInt32(r["ResourceID"]) == resourceID);
            if (resource == null || !Convert.ToBoolean(resource["IsActive"]))
                throw new InvalidOperationException("Select an active corporate resource for this invoice project.");
            DateTime periodEnd = period.AddMonths(1).AddDays(-1);
            DateTime resourceFrom = Convert.ToDateTime(resource["EffectiveFrom"]);
            DateTime? resourceTo = resource["EffectiveTo"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(resource["EffectiveTo"]);
            if (resourceFrom > periodEnd || (resourceTo.HasValue && resourceTo.Value < period))
                throw new InvalidOperationException("The corporate resource is not effective during this billing period.");
            new bllCCUserMapping().AssociateBilling(headerID, month, year, resourceID, CurrentUserID());
            return 1;
        }

        [WebMethod]
        public static string GetReport(int headerID, string month, string year, string recordType, int projectID, string departmentDomain,
            string resourceType, string status, string effectiveFrom, string effectiveTo)
        {
            GetAuthorizedContext(headerID);
            month = Clean(month); year = Clean(year); recordType = Clean(recordType); departmentDomain = Clean(departmentDomain); resourceType = Clean(resourceType); status = Clean(status);
            DateTime? from = ParseOptionalDate(effectiveFrom, "effective from filter");
            DateTime? to = ParseOptionalDate(effectiveTo, "effective to filter");
            if (from.HasValue && to.HasValue && to.Value < from.Value) throw new InvalidOperationException("Report date range is invalid.");
            List<Dictionary<string, object>> report = new List<Dictionary<string, object>>();
            if (recordType.Length == 0 || string.Equals(recordType, "Employee", StringComparison.OrdinalIgnoreCase))
            {
                string reportMonth = month.Length == 0 ? "All" : month;
                string reportYear = year.Length == 0 ? DateTime.Today.Year.ToString(CultureInfo.InvariantCulture) : year;
                DataTable headers = new bllMaster().GetAllInvoiceHeaders(reportMonth, reportYear, departmentDomain);
                if (headers != null && headers.Columns.Contains("HeaderID"))
                {
                    foreach (DataRow header in headers.Rows)
                    {
                        int currentHeader = Convert.ToInt32(header["HeaderID"]);
                        DataRow context;
                        try { context = GetAuthorizedContext(currentHeader); } catch { continue; }
                        int currentProject = Convert.ToInt32(context["ProjectID"]);
                        if (projectID > 0 && currentProject != projectID) continue;
                        DataTable users = new bllMaster().GetHeaderwiseDetailsRevised(currentHeader, reportMonth, reportYear);
                        if (users == null) continue;
                        foreach (DataRow user in users.Rows)
                        {
                            DateTime? eff = TryDate(user, "StartDate", "EffectiveFrom", "EffectiveDate");
                            if (!InRange(eff, from, to)) continue;
                            string userStatus = GetCell(user, "CurrentStatus", "Status");
                            if (status == "1" && IsInactive(userStatus) || status == "0" && !IsInactive(userStatus)) continue;
                            Dictionary<string, object> item = ReportRow("Employee", GetCell(user, "Name", "FullName"), GetCell(user, "Code"), "", GetCell(user, "Number", "EmailAddress"),
                                GetCell(context, "ProjectName"), GetCell(context, "DomainName"), GetCell(context, "DomainName"), "", reportMonth, reportYear,
                                GetCell(header, "BillingDate"), eff.HasValue ? eff.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) : "",
                                GetCell(user, "EndDate", "EffectiveTo"), GetCell(user, "Cost", "Amount"), userStatus, GetCell(header, "Remark"));
                            report.Add(item);
                        }
                    }
                }
            }
            if (recordType.Length == 0 || string.Equals(recordType, "Corporate Resource", StringComparison.OrdinalIgnoreCase))
            {
                DataTable associations = new bllCCUserMapping().GetBillingAssociations(month, year);
                if (associations != null)
                {
                    foreach (DataRow association in associations.Rows)
                    {
                        int currentProject = Convert.ToInt32(association["ProjectID"]);
                        if (projectID > 0 && currentProject != projectID) continue;
                        if (departmentDomain.Length > 0 && !string.Equals(departmentDomain, GetCell(association, "DepartmentDomain"), StringComparison.OrdinalIgnoreCase)) continue;
                        if (resourceType.Length > 0 && !string.Equals(resourceType, GetCell(association, "ResourceType"), StringComparison.OrdinalIgnoreCase)) continue;
                        bool active = Convert.ToBoolean(association["IsActive"]);
                        if (status == "1" && !active || status == "0" && active) continue;
                        DateTime? eff = TryDate(association, "EffectiveFrom");
                        if (!InRange(eff, from, to)) continue;
                        int resourceID = Convert.ToInt32(association["ResourceID"]);
                        string mapped = string.Empty;
                        DataTable mappings = new bllCCUserMapping().GetResourceMappings(resourceID);
                        DateTime billingPeriod;
                        List<string> mappedCodes = new List<string>();
                        if (mappings != null && DateTime.TryParseExact("01 " + GetCell(association, "BillingMonth") + " " + GetCell(association, "BillingYear"),
                            "dd MMMM yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out billingPeriod))
                        {
                            DateTime periodEnd = billingPeriod.AddMonths(1).AddDays(-1);
                            mappedCodes = mappings.AsEnumerable().Where(m =>
                                Convert.ToDateTime(m["EffectiveFrom"]) <= periodEnd &&
                                (m["EffectiveTo"] == DBNull.Value || Convert.ToDateTime(m["EffectiveTo"]) >= billingPeriod))
                                .Select(m => Convert.ToString(m["EmployeeCode"]).Trim()).Distinct(StringComparer.OrdinalIgnoreCase).ToList();
                        }
                        DataTable employeeDirectory = new bllMaster().GetAllUsers_1();
                        if (employeeDirectory != null && employeeDirectory.Columns.Contains("Code"))
                            mapped = string.Join(", ", mappedCodes.Select(code =>
                            {
                                DataRow employee = employeeDirectory.AsEnumerable().FirstOrDefault(r => string.Equals(Clean(Convert.ToString(r["Code"])), code, StringComparison.OrdinalIgnoreCase));
                                return employee != null && employeeDirectory.Columns.Contains("FullName") ? Convert.ToString(employee["FullName"]) : code;
                            }).ToArray());
                        else mapped = string.Join(", ", mappedCodes.ToArray());
                        DataRow invoice;
                        try { invoice = GetAuthorizedContext(Convert.ToInt32(association["HeaderID"])); }
                        catch (UnauthorizedAccessException) { continue; }
                        DataTable billing = new bllMaster().GetAllInvoiceHeaders(GetCell(association, "BillingMonth"), GetCell(association, "BillingYear"), string.Empty);
                        DataRow billRow = billing == null || !billing.Columns.Contains("HeaderID") ? null : billing.AsEnumerable().FirstOrDefault(r => Convert.ToInt32(r["HeaderID"]) == Convert.ToInt32(association["HeaderID"]));
                        string amount = billRow == null ? "" : GetCell(billRow, "InvoiceAmount", "ContractualCost1", "ContractualCost");
                        report.Add(ReportRow("Corporate Resource", GetCell(association, "ResourceName"), Convert.ToString(resourceID),
                            GetCell(association, "ResourceType"), GetCell(association, "AccountIdentifier"), GetCell(association, "ProjectName"),
                            GetCell(association, "DepartmentDomain"), GetCell(invoice, "DomainName"), mapped,
                            GetCell(association, "BillingMonth"), GetCell(association, "BillingYear"), billRow == null ? "" : GetCell(billRow, "BillingDate"),
                            GetCell(association, "EffectiveFrom"), GetCell(association, "EffectiveTo"), amount, active ? "Active" : "Deactivated", GetCell(association, "Remark")));
                    }
                }
            }
            return new JavaScriptSerializer { MaxJsonLength = int.MaxValue }.Serialize(report);
        }

        private static Dictionary<string, object> ReportRow(string type, string name, string code, string resourceType, string account,
            string project, string department, string domain, string mapped, string month, string year, string billingDate,
            string from, string to, string amount, string status, string remark)
        {
            return new Dictionary<string, object> { { "RecordType", type }, { "DisplayName", name }, { "Code", code }, { "ResourceType", resourceType },
                { "AccountIdentifier", account }, { "Project", project }, { "Department", department }, { "Domain", domain }, { "MappedEmployees", mapped },
                { "BillingMonth", month }, { "BillingYear", year }, { "BillingDate", billingDate }, { "EffectiveFrom", from }, { "EffectiveTo", to },
                { "BillingAmount", amount }, { "Status", status }, { "Remark", remark } };
        }

        private static string GetCell(DataRow row, params string[] names)
        {
            if (row == null) return string.Empty;
            foreach (string name in names) if (row.Table.Columns.Contains(name) && row[name] != DBNull.Value) return Convert.ToString(row[name]);
            return string.Empty;
        }

        private static DateTime? TryDate(DataRow row, params string[] names)
        {
            string value = GetCell(row, names); DateTime result;
            return DateTime.TryParse(value, CultureInfo.InvariantCulture, DateTimeStyles.None, out result) ? (DateTime?)result.Date : null;
        }

        private static bool InRange(DateTime? date, DateTime? from, DateTime? to)
        {
            if (from.HasValue && (!date.HasValue || date.Value < from.Value)) return false;
            if (to.HasValue && (!date.HasValue || date.Value > to.Value)) return false;
            return true;
        }

        private static bool IsInactive(string status)
        {
            return new[] { "inactive", "deactivated", "disabled", "ended", "0", "false" }.Contains(Clean(status), StringComparer.OrdinalIgnoreCase);
        }
    }
}
