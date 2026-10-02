using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Security;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using InfinityERP.UnderwritingBilling;
using WebPortal.App_Code.Class;
using WebPortal.App_Code.DAL;

namespace WebPortal.Admin
{
    public partial class ProjectBillingDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                for (int month = 1; month <= 12; month++)
                {
                    string name = CultureInfo.InvariantCulture.DateTimeFormat.GetMonthName(month);
                    ddlMonth.Items.Add(new ListItem(name, name));
                }
                DateTime applicableMonth = DateTime.Today.Day == 1 ? DateTime.Today.AddMonths(-1) : DateTime.Today;
                ddlMonth.SelectedValue = applicableMonth.ToString("MMMM", CultureInfo.InvariantCulture);
                int currentYear = DateTime.Today.Year;
                for (int year = currentYear + 1; year >= currentYear - 10; year--)
                    ddlYear.Items.Add(new ListItem(year.ToString(CultureInfo.InvariantCulture), year.ToString(CultureInfo.InvariantCulture)));
                ddlYear.SelectedValue = applicableMonth.Year.ToString(CultureInfo.InvariantCulture);
            }
        }

        [WebMethod(EnableSession = true)]
        public static BillingDetailsResponse GetBillingDetails(string month, int year)
        {
            try
            {
                DateTime parsed;
                if (!DateTime.TryParseExact(month, "MMMM", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed) || year < 2000 || year > DateTime.Today.Year + 1)
                    return BillingDetailsResponse.Failure("Please select a valid Month and Year.");
                DateTime billingMonth = new DateTime(year, parsed.Month, 1);
                DateTime monthEnd = billingMonth.AddMonths(1).AddDays(-1);
                DateTime periodTo = billingMonth >= new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1)
                    ? DateTime.Today.AddDays(-1)
                    : monthEnd;
                BillingValidationResult data = new UnderwritingBillingValidationService(SQLHelper.ConnectionString)
                    .GetPendingBillingData(EmployeeInfo.Current.EmployeeID, billingMonth, periodTo);
                return new BillingDetailsResponse
                {
                    Success = true,
                    Message = data.Projects.Count == 0 ? "No billing records found for selected Month and Year." : String.Empty,
                    Projects = data.Projects,
                    Summary = data.Summary,
                    BlankLoans = data.BlankLoans,
                    PendingLoans = data.PendingLoans
                };
            }
            catch (UnauthorizedAccessException ex) { return BillingDetailsResponse.Failure(ex.Message); }
            catch (Exception) { return BillingDetailsResponse.Failure("Unable to fetch billing details. Please try again or contact the administrator."); }
        }

        [WebMethod(EnableSession = true)]
        public static SaveRemarkResponse SaveBillingRemarks(List<BillingRemarkRequest> items, string remark)
        {
            try
            {
                remark = (remark ?? String.Empty).Trim();
                if (String.IsNullOrEmpty(remark)) return SaveRemarkResponse.Failure("Remark is mandatory.");
                if (remark.Length > 1000) return SaveRemarkResponse.Failure("Remark cannot exceed 1000 characters.");
                if (items == null || items.Count == 0) return SaveRemarkResponse.Failure("Select at least one loan.");
                int employeeId = EmployeeInfo.Current.EmployeeID;
                if (employeeId != 277 && employeeId != 6823) return SaveRemarkResponse.Failure("You are not authorized for Underwriting billing remarks.");
                int projectId = items[0].ProjectID;
                string dealNo = (items[0].DealNo ?? String.Empty).Trim();
                DateTime billingMonth;
                if (!DateTime.TryParseExact(items[0].BillingMonth, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out billingMonth))
                    return SaveRemarkResponse.Failure("Invalid billing month.");

                HashSet<string> loans = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                StringBuilder xml = new StringBuilder("<Loans>");
                foreach (BillingRemarkRequest item in items)
                {
                    string loan = (item.LoanNo ?? String.Empty).Trim();
                    if (item.ProjectID != projectId || !String.Equals((item.DealNo ?? "").Trim(), dealNo, StringComparison.OrdinalIgnoreCase) || item.BillingMonth != items[0].BillingMonth)
                        return SaveRemarkResponse.Failure("Bulk remarks can only be saved for the same Project, Deal and Billing Month.");
                    if (String.IsNullOrEmpty(loan) || !loans.Add(loan)) continue;
                    xml.Append("<Loan LoanNo=\"").Append(SecurityElement.Escape(loan)).Append("\" Signature=\"")
                       .Append(SecurityElement.Escape(item.PendingSignature ?? String.Empty)).Append("\" />");
                }
                xml.Append("</Loans>");
                if (loans.Count == 0) return SaveRemarkResponse.Failure("No valid loans were selected.");

                using (SqlConnection connection = new SqlConnection(SQLHelper.ConnectionString))
                using (SqlCommand command = new SqlCommand("dbo.usp_SaveProjectBillingRemarks", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@EmployeeID", SqlDbType.Int).Value = employeeId;
                    command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId;
                    command.Parameters.Add("@DealNo", SqlDbType.NVarChar, 200).Value = dealNo;
                    command.Parameters.Add("@BillingMonth", SqlDbType.Date).Value = billingMonth;
                    command.Parameters.Add("@Remark", SqlDbType.NVarChar, 1000).Value = remark;
                    command.Parameters.Add("@LoansXml", SqlDbType.Xml).Value = xml.ToString();
                    connection.Open();
                    int saved = Convert.ToInt32(command.ExecuteScalar(), CultureInfo.InvariantCulture);
                    return new SaveRemarkResponse { Success = true, SavedCount = saved, Message = saved + " remark(s) saved successfully." };
                }
            }
            catch (SqlException ex) { return SaveRemarkResponse.Failure(ex.Number == 50000 ? ex.Message : "Unable to save the remark. Please try again."); }
            catch (Exception) { return SaveRemarkResponse.Failure("Unable to save the remark. Please try again."); }
        }
    }

    public sealed class BillingDetailsResponse
    {
        public BillingDetailsResponse() { Projects = new List<InfinityERP.UnderwritingBilling.BillingProject>(); Summary = new List<InfinityERP.UnderwritingBilling.ProjectBillingSummary>(); BlankLoans = new List<InfinityERP.UnderwritingBilling.BlankBillingLoan>(); PendingLoans = new List<InfinityERP.UnderwritingBilling.BlankBillingLoan>(); }
        public bool Success { get; set; }
        public string Message { get; set; }
        public List<InfinityERP.UnderwritingBilling.BillingProject> Projects { get; set; }
        public List<InfinityERP.UnderwritingBilling.ProjectBillingSummary> Summary { get; set; }
        public List<InfinityERP.UnderwritingBilling.BlankBillingLoan> BlankLoans { get; set; }
        public List<InfinityERP.UnderwritingBilling.BlankBillingLoan> PendingLoans { get; set; }
        public static BillingDetailsResponse Failure(string message) { return new BillingDetailsResponse { Success = false, Message = message }; }
    }
    public sealed class BillingRemarkRequest { public int ProjectID { get; set; } public string DealNo { get; set; } public string LoanNo { get; set; } public string BillingMonth { get; set; } public string PendingSignature { get; set; } }
    public sealed class SaveRemarkResponse { public bool Success { get; set; } public string Message { get; set; } public int SavedCount { get; set; } public static SaveRemarkResponse Failure(string message) { return new SaveRemarkResponse { Success = false, Message = message }; } }
}
