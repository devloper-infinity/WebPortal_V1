using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Accounts
{
    public partial class IncrementProposal : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !string.IsNullOrEmpty(Request.QueryString["downloadToken"]))
            {
                DownloadPerformanceDocument(Request.QueryString["downloadToken"]);
            }
        }

        [WebMethod]
        public static string GetPageConfiguration()
        {
            int userId = CurrentUserId();
            return Serialize(new
            {
                Workflow = UsesUnderwritingWorkflow(userId) ? "Underwriting" : "General",
                ShowSalary = !UsesUnderwritingWorkflow(userId) || userId == 7036,
                ShowResumeLinks = true
            });
        }

        [WebMethod]
        public static string GetDueForIncrement()
        {
            DataTable dt = new bllSalary().GetDueForIncrementForStep1(CurrentUserId());
            return Serialize(new { Rows = ToRows(dt, "Due"), Errors = new List<string>() });
        }

        [WebMethod]
        public static int InsertIncrementProposalRecord(string Codes)
        {
            int returnValue = 0;
            bool isUnderwriting = UsesUnderwritingWorkflow(CurrentUserId());
            bllSalary salary = new bllSalary();

            if (string.IsNullOrWhiteSpace(Codes))
            {
                return returnValue;
            }

            string[] codeList = Codes.Split(',');
            foreach (string item in codeList)
            {
                string code = Convert.ToString(item).Trim();
                if (string.IsNullOrEmpty(code))
                {
                    continue;
                }

                Hashtable htParam = new Hashtable();
                htParam["Code"] = code;
                htParam["AddedBy"] = CurrentUserId();

                returnValue = isUnderwriting
                    ? salary.InsertProposedIncrementByPM_UnderWriting(htParam)
                    : salary.InsertProposedIncrementByPM(htParam);
            }

            return returnValue;
        }

        [WebMethod]
        public static string GetSelectedForIncrement(string Mode)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            List<string> errors = new List<string>();
            string mode = AuthorizedWorkflow();
            bllSalary salary = new bllSalary();
            int userId = CurrentUserId();

            if (mode == "General")
            {
                try
                {
                    rows.AddRange(ToRows(salary.GetIncrementProposalSelected(userId, false), "General"));
                }
                catch (Exception ex)
                {
                    errors.Add("General proposal data: " + ex.Message);
                }
            }

            if (mode == "Underwriting")
            {
                try
                {
                    rows.AddRange(ToRows(salary.GetIncrementProposalSelected(userId, true), "Underwriting"));
                }
                catch (Exception ex)
                {
                    errors.Add("Underwriting proposal data: " + ex.Message);
                }
            }

            return Serialize(new { Rows = rows, Errors = errors });
        }

        [WebMethod]
        public static string GetProposalDetails(string Code, int ProposalID, int IncCounter, string Workflow)
        {
            EnsureAuthorizedWorkflow(Workflow);
            bool isUnderwriting = IsUnderwriting(Workflow);
            bllSalary salary = new bllSalary();
            List<string> errors = new List<string>();
            DataTable details = new DataTable();
            DataTable standard = new DataTable();
            DataTable remarks = new DataTable();
            DataTable documents = new DataTable();

            try
            {
                details = salary.GetIncrementProposalByCode(Code, isUnderwriting);
            }
            catch (Exception ex)
            {
                errors.Add("Proposal details: " + ex.Message);
            }

            try
            {
                standard = salary.GetStandardIncrementOfUser(Code, ProposalID, isUnderwriting);
            }
            catch (Exception ex)
            {
                errors.Add("Standard increment: " + ex.Message);
            }

            try
            {
                remarks = salary.GetIncrementProposalRemarkLog(Code, IncCounter, isUnderwriting);
            }
            catch (Exception ex)
            {
                errors.Add("Remark history: " + ex.Message);
            }

            try
            {
                documents = salary.GetIncrementPerformanceDocs(Code, IncCounter, isUnderwriting);
            }
            catch (Exception ex)
            {
                errors.Add("Documents: " + ex.Message);
            }

            return Serialize(new
            {
                Details = ToRows(details, Workflow),
                Standard = ToRows(standard, Workflow),
                Remarks = ToRows(remarks, Workflow),
                Documents = ToRows(documents, Workflow),
                Errors = errors
            });
        }

        [WebMethod]
        public static SaveResult SaveProposal(IncrementProposalRequest request)
        {
            SaveResult result = new SaveResult();

            try
            {
                if (request == null || string.IsNullOrWhiteSpace(request.Code))
                {
                    result.Message = "Employee code is required.";
                    return result;
                }

                EnsureAuthorizedWorkflow(request.Workflow);

                Hashtable htParam = BuildProposalParameters(request);
                int returnValue = new bllSalary().InsertIncrementProposal(htParam, IsUnderwriting(request.Workflow));

                result.Status = returnValue > 0 ? 1 : 0;
                result.ReturnValue = returnValue;
                result.Message = returnValue > 0 ? "Proposal saved successfully." : "Unable to save proposal.";
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
            }

            return result;
        }

        [WebMethod]
        public static SaveResult ApplyStandardIncrement(StandardIncrementRequest request)
        {
            SaveResult result = new SaveResult();

            try
            {
                if (request == null || string.IsNullOrWhiteSpace(request.Code))
                {
                    result.Message = "Employee code is required.";
                    return result;
                }

                Hashtable htParam = new Hashtable();
                htParam["Code"] = request.Code;
                htParam["ProposalID"] = request.ProposalID;
                htParam["IncPercentageByPM"] = NullSafe(request.IncPercentageByPM, "0");
                htParam["IncrementAmount"] = request.IncrementAmount;
                htParam["SalaryAfterIncrement"] = request.SalaryAfterIncrement;
                htParam["Month"] = NullSafe(request.Month, "");
                htParam["Year"] = NullSafe(request.Year, "0");
                htParam["AddedBy"] = CurrentUserId();

                int returnValue = new bllSalary().UpdateStandardIncrement(htParam);

                result.Status = returnValue > 0 ? 1 : 0;
                result.ReturnValue = returnValue;
                result.Message = returnValue > 0 ? "Standard increment criteria applied." : "Unable to apply standard increment criteria.";
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
            }

            return result;
        }

        [WebMethod]
        public static SaveResult RemoveProposal(string Code, int IncCounter, string Workflow)
        {
            SaveResult result = new SaveResult();

            try
            {
                EnsureAuthorizedWorkflow(Workflow);
                int returnValue = new bllSalary().DeleteProposedIncrement(Code, IncCounter, IsUnderwriting(Workflow));
                result.Status = returnValue > 0 ? 1 : 0;
                result.ReturnValue = returnValue;
                result.Message = returnValue > 0 ? "Proposal removed successfully." : "Unable to remove proposal.";
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
            }

            return result;
        }

        [WebMethod]
        public static SaveResult ResetProposal(string Code, int ProposalID, string Workflow)
        {
            SaveResult result = new SaveResult();

            try
            {
                EnsureAuthorizedWorkflow(Workflow);
                if (!IsUnderwriting(Workflow))
                {
                    result.Message = "Reset is available for underwriting proposal records.";
                    return result;
                }

                int returnValue = new bllSalary().ResetIncrementRecords(ProposalID, CurrentUserId(), Code);
                result.Status = returnValue > 0 ? 1 : 0;
                result.ReturnValue = returnValue;
                result.Message = returnValue > 0 ? "Proposal reset successfully." : "Unable to reset proposal.";
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
            }

            return result;
        }

        [WebMethod]
        public static SaveResult SetForApproval(List<ProposalSelectionRequest> Proposals)
        {
            SaveResult result = new SaveResult();

            try
            {
                if (Proposals == null || Proposals.Count == 0)
                {
                    result.Message = "Please select at least one employee.";
                    return result;
                }

                int count = 0;
                bllSalary salary = new bllSalary();

                foreach (ProposalSelectionRequest item in Proposals)
                {
                    if (item == null || string.IsNullOrWhiteSpace(item.Code))
                    {
                        continue;
                    }

                    EnsureAuthorizedWorkflow(item.Workflow);

                    int returnValue = salary.ProceedProposedIncrement(item.Code);
                    if (returnValue > 0)
                    {
                        count++;
                    }
                }

                result.Status = count > 0 ? 1 : 0;
                result.ReturnValue = count;
                result.Message = count > 0 ? "Selected proposal(s) moved to final report." : "No proposal was moved to final report.";
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
            }

            return result;
        }

        [WebMethod]
        public static SaveResult UploadDocument(UploadDocumentRequest request)
        {
            SaveResult result = new SaveResult();

            try
            {
                if (request == null || string.IsNullOrWhiteSpace(request.Code) || string.IsNullOrWhiteSpace(request.FileName) || string.IsNullOrWhiteSpace(request.FileData))
                {
                    result.Message = "Please choose a file and enter the document details.";
                    return result;
                }

                EnsureAuthorizedWorkflow(request.Workflow);

                string fileName = Path.GetFileName(request.FileName);
                string folderPath = HttpContext.Current.Server.MapPath("~/EmployeeDocuments/PerformanceDocs/" + request.Code);

                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                string storedFileName = Guid.NewGuid().ToString("N") + "_" + fileName;
                string physicalPath = Path.Combine(folderPath, storedFileName);
                string base64 = request.FileData;
                int commaIndex = base64.IndexOf(',');
                if (commaIndex >= 0)
                {
                    base64 = base64.Substring(commaIndex + 1);
                }

                File.WriteAllBytes(physicalPath, Convert.FromBase64String(base64));

                int returnValue = new bllSalary().UploadIncrementPerformanceDoc(request.Code, physicalPath, NullSafe(request.Remark, ""), request.IncCounter);
                result.Status = returnValue > 0 ? 1 : 0;
                result.ReturnValue = returnValue;
                result.Message = returnValue > 0 ? "Document uploaded successfully." : "Unable to save document information.";
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
            }

            return result;
        }

        [WebMethod]
        public static string GetDocuments(string Code, int IncCounter, string Workflow)
        {
            EnsureAuthorizedWorkflow(Workflow);
            DataTable dt = new bllSalary().GetIncrementPerformanceDocs(Code, IncCounter, IsUnderwriting(Workflow));
            return Serialize(new { Rows = ToRows(dt, Workflow), Errors = new List<string>() });
        }

        [WebMethod]
        public static string GetFinalProposals()
        {
            DataTable dt = new bllSalary().GetIncrementProposalFinal(CurrentUserId());
            return Serialize(new { Rows = ToRows(dt, "Final"), Errors = new List<string>() });
        }

        [WebMethod]
        public static SaveResult AddFinalToDatabase(List<FinalProposalRequest> Proposals)
        {
            SaveResult result = new SaveResult();

            try
            {
                if (Proposals == null || Proposals.Count == 0)
                {
                    result.Message = "Please select at least one proposal.";
                    return result;
                }

                int count = 0;
                string blockedCode = "";
                bllSalary salary = new bllSalary();
                string ip = GetClientIp();

                foreach (FinalProposalRequest item in Proposals)
                {
                    if (item == null)
                    {
                        continue;
                    }

                    string code = item.Code;
                    int proposalId = item.ProposalID;
                    ApplyCodeCounter(item.CodeCounter, ref code, ref proposalId);

                    if (string.IsNullOrWhiteSpace(code) || proposalId <= 0)
                    {
                        continue;
                    }

                    int returnValue = salary.InsertIncrementFromIncProposal(proposalId, ip, CurrentUserId(), "Final Discussion Done", code);
                    if (returnValue > 0)
                    {
                        count++;
                    }
                    else if (returnValue == -1)
                    {
                        blockedCode = code;
                        break;
                    }
                }

                result.Status = count > 0 && string.IsNullOrEmpty(blockedCode) ? 1 : 0;
                result.ReturnValue = count;
                result.Message = string.IsNullOrEmpty(blockedCode)
                    ? (count > 0 ? "Final proposal(s) saved in increment database." : "No final proposal was saved.")
                    : "Details of " + blockedCode + " were not added because increment percentage is zero.";
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
            }

            return result;
        }

        [WebMethod]
        public static string GetBonusAmount(string AttnBonusType, string IncrementAmount, string BonusPercentage)
        {
            decimal bonusAmount = 0;
            decimal incrementAmount = ToDecimal(IncrementAmount);
            decimal bonusPercentage = ToDecimal(BonusPercentage);

            if (AttnBonusType == "Percentage" && incrementAmount > 0 && bonusPercentage > 0)
            {
                bonusAmount = (incrementAmount / 100) * bonusPercentage;
            }
            else if (AttnBonusType == "Fix Amount" || AttnBonusType == "FixAmount")
            {
                bonusAmount = bonusPercentage;
            }

            return Convert.ToString(Math.Round(bonusAmount, 2));
        }

        private void DownloadPerformanceDocument(string token)
        {
            try
            {
                string filePath = Path.GetFullPath(DecodeToken(token));
                string documentRoot = Path.GetFullPath(Server.MapPath("~/EmployeeDocuments/PerformanceDocs/"));
                if (filePath.StartsWith(documentRoot, StringComparison.OrdinalIgnoreCase) && File.Exists(filePath))
                {
                    string fileName = Path.GetFileName(filePath);
                    Response.Clear();
                    Response.ContentType = MimeMapping.GetMimeMapping(fileName);
                    Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileName);
                    Response.TransmitFile(filePath);
                    Response.Flush();
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
            catch
            {
            }
        }

        private static Hashtable BuildProposalParameters(IncrementProposalRequest request)
        {
            Hashtable htParam = new Hashtable();
            htParam["Code"] = NullSafe(request.Code, "");
            htParam["ProposalID"] = request.ProposalID;
            htParam["IncrementPercentageByPM"] = request.IncrementPercentageByPM;
            htParam["IncrementAmount"] = request.IncrementAmount;
            htParam["Status"] = NullSafe(request.Status, "Negotiation Done");
            htParam["PMRemark"] = NullSafe(request.PMRemark, "");
            htParam["SalaryAfterIncrement"] = request.SalaryAfterIncrement;
            htParam["Month"] = NullSafe(request.Month, "");
            htParam["Year"] = NullSafe(request.Year, "0");
            htParam["AddedBy"] = CurrentUserId();
            htParam["IncYearType"] = request.IncYearType;
            htParam["NextDueMonth"] = NullSafe(request.NextDueMonth, "");
            htParam["NextDueYear"] = request.NextDueYear;
            htParam["IsAttnBonus"] = request.IsAttnBonus;
            htParam["AttendanceBonusType"] = NullSafe(request.AttendanceBonusType, "");
            htParam["AttendanceBonus"] = request.AttendanceBonus;
            htParam["AttendanceBonusMonth"] = NullSafe(request.AttendanceBonusMonth, "");
            htParam["AttendanceBonusYear"] = request.AttendanceBonusYear;
            htParam["IsNightBonus"] = request.IsNightBonus;
            htParam["NightBonus"] = request.NightBonus;
            htParam["MachineIP"] = GetClientIp();
            htParam["QBonus"] = NullSafe(request.QBonus, "0");
            htParam["RetentionBonus"] = NullSafe(request.RetentionBonus, "0");
            htParam["ForPeriod"] = NullSafe(request.ForPeriod, "");
            htParam["RetentionMonth"] = NullSafe(request.RetentionMonth, "");
            htParam["RetentionYear"] = NullSafe(request.RetentionYear, "");
            return htParam;
        }

        private static List<Dictionary<string, object>> ToRows(DataTable table, string workflow)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (table == null)
            {
                return rows;
            }

            foreach (DataRow dr in table.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn col in table.Columns)
                {
                    row[col.ColumnName] = dr[col];
                }

                row["ProposalWorkflow"] = workflow;
                row["UnifiedProposalID"] = FirstValue(row, "ProposalID", "ProposalUwID", "UnifiedProposalID");
                row["UnifiedDomain"] = FirstValue(row, "DomainName", "D_Name", "SubDomain", "Domain");
                row["UnifiedProductionGrade"] = FirstValue(row, "ProdGrade", "NewProdGrade", "ProductionGrade");
                row["UnifiedQualityGrade"] = FirstValue(row, "QAGrade", "NewQualityGrade", "QualityGrade");
                row["UnifiedAttendanceGrade"] = FirstValue(row, "AttendanceGrade", "NewAttendanceGrade");
                row["UnifiedMonth"] = FirstValue(row, "IncMonth", "Month");
                row["UnifiedSalaryAfterIncrement"] = FirstValue(row, "GrandTotal", "SalaryAfterIncrement", "SalaryAfterIncrement1", "IncrementedSalary");
                rows.Add(row);
            }

            return rows;
        }

        private static object FirstValue(Dictionary<string, object> row, params string[] keys)
        {
            foreach (string key in keys)
            {
                if (row.ContainsKey(key) && row[key] != null && row[key] != DBNull.Value && Convert.ToString(row[key]) != "")
                {
                    return row[key];
                }
            }

            return "";
        }

        private static string Serialize(object value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(value);
        }

        private static bool IsUnderwriting(string workflow)
        {
            return Convert.ToString(workflow).Equals("Underwriting", StringComparison.OrdinalIgnoreCase);
        }

        private static bool UsesUnderwritingWorkflow(int userId)
        {
            return userId == 12 || userId == 216 || userId == 8726;
        }

        private static string AuthorizedWorkflow()
        {
            return UsesUnderwritingWorkflow(CurrentUserId()) ? "Underwriting" : "General";
        }

        private static void EnsureAuthorizedWorkflow(string workflow)
        {
            if (!AuthorizedWorkflow().Equals(Convert.ToString(workflow), StringComparison.OrdinalIgnoreCase))
            {
                throw new HttpException(403, "The requested increment workflow is not available for this user.");
            }
        }

        private static string NormalizeMode(string mode)
        {
            string normalized = Convert.ToString(mode);
            if (normalized.Equals("General", StringComparison.OrdinalIgnoreCase))
            {
                return "General";
            }

            if (normalized.Equals("Underwriting", StringComparison.OrdinalIgnoreCase))
            {
                return "Underwriting";
            }

            return "All";
        }

        private static int CurrentUserId()
        {
            int employeeId;
            if (HttpContext.Current != null &&
                HttpContext.Current.User != null &&
                HttpContext.Current.User.Identity != null &&
                int.TryParse(HttpContext.Current.User.Identity.Name, out employeeId))
            {
                return employeeId;
            }

            return 0;
        }

        private static string GetClientIp()
        {
            string ipAddress = "";
            if (HttpContext.Current != null && HttpContext.Current.Request != null)
            {
                ipAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (string.IsNullOrEmpty(ipAddress))
                {
                    ipAddress = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
                }
            }

            return NullSafe(ipAddress, "");
        }

        private static void ApplyCodeCounter(string codeCounter, ref string code, ref int proposalId)
        {
            if (string.IsNullOrWhiteSpace(codeCounter) || !codeCounter.Contains(","))
            {
                return;
            }

            string[] parts = codeCounter.Split(',');
            if (parts.Length > 0 && string.IsNullOrWhiteSpace(code))
            {
                code = parts[0];
            }

            int parsedProposalId;
            if (parts.Length > 1 && int.TryParse(parts[1], out parsedProposalId))
            {
                proposalId = parsedProposalId;
            }
        }

        private static string NullSafe(string value, string defaultValue)
        {
            return string.IsNullOrWhiteSpace(value) ? defaultValue : value;
        }

        private static string DecodeToken(string token)
        {
            byte[] bytes = Convert.FromBase64String(token);
            return System.Text.Encoding.UTF8.GetString(bytes);
        }

        private static decimal ToDecimal(string value)
        {
            decimal parsed;
            return decimal.TryParse(Convert.ToString(value), out parsed) ? parsed : 0;
        }

        public class SaveResult
        {
            public int Status { get; set; }
            public int ReturnValue { get; set; }
            public string Message { get; set; }
        }

        public class ProposalSelectionRequest
        {
            public string Code { get; set; }
            public int ProposalID { get; set; }
            public int IncCounter { get; set; }
            public string Workflow { get; set; }
        }

        public class FinalProposalRequest
        {
            public string Code { get; set; }
            public int ProposalID { get; set; }
            public string CodeCounter { get; set; }
        }

        public class UploadDocumentRequest
        {
            public string Code { get; set; }
            public int IncCounter { get; set; }
            public string Workflow { get; set; }
            public string FileName { get; set; }
            public string FileData { get; set; }
            public string Remark { get; set; }
        }

        public class StandardIncrementRequest
        {
            public string Code { get; set; }
            public int ProposalID { get; set; }
            public string IncPercentageByPM { get; set; }
            public int IncrementAmount { get; set; }
            public int SalaryAfterIncrement { get; set; }
            public string Month { get; set; }
            public string Year { get; set; }
        }

        public class IncrementProposalRequest
        {
            public string Workflow { get; set; }
            public string Code { get; set; }
            public int ProposalID { get; set; }
            public decimal IncrementPercentageByPM { get; set; }
            public int IncrementAmount { get; set; }
            public string Status { get; set; }
            public string PMRemark { get; set; }
            public int SalaryAfterIncrement { get; set; }
            public string Month { get; set; }
            public string Year { get; set; }
            public int IncYearType { get; set; }
            public string NextDueMonth { get; set; }
            public int NextDueYear { get; set; }
            public bool IsAttnBonus { get; set; }
            public string AttendanceBonusType { get; set; }
            public int AttendanceBonus { get; set; }
            public string AttendanceBonusMonth { get; set; }
            public int AttendanceBonusYear { get; set; }
            public bool IsNightBonus { get; set; }
            public int NightBonus { get; set; }
            public string QBonus { get; set; }
            public string RetentionBonus { get; set; }
            public string ForPeriod { get; set; }
            public string RetentionMonth { get; set; }
            public string RetentionYear { get; set; }
        }
    }
}
