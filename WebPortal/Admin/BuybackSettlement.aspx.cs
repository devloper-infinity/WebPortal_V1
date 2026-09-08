using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class BuybackSettlement : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !string.IsNullOrWhiteSpace(Request.QueryString["download"])) DownloadAttachment();
        }

        [WebMethod] public static List<Dictionary<string, object>> GetEmployees() { return ToRows(new bllMaster().GetAllUsers(), false); }
        [WebMethod] public static List<Dictionary<string, object>> GetSettlements() { return ToRows(new bllMaster().GetBuybackSettlements(), true); }

        [WebMethod]
        public static BuybackSaveResult SaveSettlement(BuybackSettlementRequest request)
        {
            try
            {
                if (request == null || request.EmployeeID <= 0 || Blank(request.ActualNoticePeriod) || Blank(request.BuybackNoticePeriod) || Blank(request.OriginalSalary) || Blank(request.BuybackAmount) || Blank(request.InfinityPaidAmount) || Blank(request.InfinityPaidDate))
                    return BuybackSaveResult.Fail("Please complete all required fields.");
                DateTime paidDate;
                if (!DateTime.TryParse(request.InfinityPaidDate, CultureInfo.InvariantCulture, DateTimeStyles.None, out paidDate)) return BuybackSaveResult.Fail("Please enter a valid Infinity paid date.");
                string salaryPath = SaveAttachment(request.EmployeeID, request.SalarySlipName, request.SalarySlipBase64);
                string amountPath = SaveAttachment(request.EmployeeID, request.AmountFileName, request.AmountFileBase64);
                Hashtable values = new Hashtable { {"EmployeeID",request.EmployeeID},{"ActualNoticePeriod",request.ActualNoticePeriod.Trim()},{"BuybackNoticePeriod",request.BuybackNoticePeriod.Trim()},{"OriginalSalary",request.OriginalSalary.Trim()},{"BuybackAmount",request.BuybackAmount.Trim()},{"InfinityPaidAmount",request.InfinityPaidAmount.Trim()},{"InfinityPaidDate",paidDate.ToString("dd-MMM-yyyy")},{"Remark",(request.Remark??"").Trim()},{"SalarySlipPath",salaryPath},{"AmountPath",amountPath},{"AddedBy",Convert.ToInt32(HttpContext.Current.User.Identity.Name)} };
                int result = new bllMaster().SaveBuybackSettlement(values);
                return result > 0 ? BuybackSaveResult.Ok("Details updated successfully.") : BuybackSaveResult.Fail("Error updating details.");
            }
            catch (Exception) { return BuybackSaveResult.Fail("Unable to save settlement details."); }
        }

        private void DownloadAttachment()
        {
            int employeeId; if (!int.TryParse(Request.QueryString["employeeId"], out employeeId) || employeeId <= 0) return;
            DataTable table = new bllMaster().GetBuybackSettlementForEmployee(employeeId); if (table.Rows.Count == 0) return;
            string column = Request.QueryString["download"] == "salary" ? "SalarySlipPath" : Request.QueryString["download"] == "amount" ? "AmountPath" : ""; if (column == "" || !table.Columns.Contains(column)) return;
            string path = Convert.ToString(table.Rows[0][column]); if (string.IsNullOrWhiteSpace(path) || !File.Exists(path)) { Response.StatusCode=404; Response.End(); return; }
            Response.Clear(); Response.ContentType="application/octet-stream"; Response.AddHeader("Content-Disposition","attachment; filename=\""+Path.GetFileName(path).Replace("\"","")+"\""); Response.TransmitFile(path); Response.End();
        }

        private static string SaveAttachment(int employeeId, string name, string base64)
        {
            if (Blank(name) || Blank(base64)) return null; byte[] bytes=Convert.FromBase64String(base64); if(bytes.Length>5*1024*1024)throw new InvalidOperationException();
            string safeName=Path.GetFileName(name); string ext=Path.GetExtension(safeName).ToLowerInvariant(); string allowed=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.jpeg,.png,.txt,.msg"; if(Array.IndexOf(allowed.Split(','),ext)<0)throw new InvalidOperationException();
            string folder=HttpContext.Current.Server.MapPath("~/EmployeeDocuments/"+employeeId); Directory.CreateDirectory(folder); string path=Path.Combine(folder,DateTime.Now.ToString("yyyyMMddHHmmssfff")+"_"+safeName); File.WriteAllBytes(path,bytes); return path;
        }
        private static bool Blank(string value) { return string.IsNullOrWhiteSpace(value); }
        private static List<Dictionary<string, object>> ToRows(DataTable table, bool settlement)
        {
            List<Dictionary<string,object>> rows=new List<Dictionary<string,object>>(); foreach(DataRow dr in table.Rows){Dictionary<string,object> row=new Dictionary<string,object>();foreach(DataColumn col in table.Columns){if(settlement&&(col.ColumnName=="SalarySlipPath"||col.ColumnName=="AmountPath"))continue;object value=dr[col];row[col.ColumnName]=value==DBNull.Value?null:value is DateTime?((DateTime)value).ToString("dd-MMM-yyyy"):value;}if(settlement){row["HasSalarySlip"]=table.Columns.Contains("SalarySlipPath")&&!Blank(Convert.ToString(dr["SalarySlipPath"]));row["HasAmountAttachment"]=table.Columns.Contains("AmountPath")&&!Blank(Convert.ToString(dr["AmountPath"]));DateTime date;row["InfinityPaidDateInput"]=table.Columns.Contains("InfinityPaidDate")&&DateTime.TryParse(Convert.ToString(dr["InfinityPaidDate"]),out date)?date.ToString("yyyy-MM-dd"):"";}rows.Add(row);}return rows;
        }
    }
    public class BuybackSettlementRequest { public int EmployeeID{get;set;} public string ActualNoticePeriod{get;set;} public string BuybackNoticePeriod{get;set;} public string OriginalSalary{get;set;} public string BuybackAmount{get;set;} public string InfinityPaidAmount{get;set;} public string InfinityPaidDate{get;set;} public string Remark{get;set;} public string SalarySlipName{get;set;} public string SalarySlipBase64{get;set;} public string AmountFileName{get;set;} public string AmountFileBase64{get;set;} }
    public class BuybackSaveResult { public bool Success{get;set;} public string Message{get;set;} public static BuybackSaveResult Ok(string m){return new BuybackSaveResult{Success=true,Message=m};} public static BuybackSaveResult Fail(string m){return new BuybackSaveResult{Success=false,Message=m};} }
}
