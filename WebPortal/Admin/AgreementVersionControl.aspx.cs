using ClosedXML.Excel;
using Spire.Xls;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class AgreementVersionControl : System.Web.UI.Page
    {
        private const string AgreementRoot = "~/AgreementVersions/";
        protected string AgreementUploadToken { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["download"] != null)
            {
                DownloadAgreement();
                Response.End();
                return;
            }
            if (Request.HttpMethod == "POST" && Request.QueryString["upload"] == "1")
            {
                SaveUploadedAgreement();
                Response.End();
                return;
            }
            if (Session["AgreementUploadToken"] == null)
                Session["AgreementUploadToken"] = Guid.NewGuid().ToString("N");
            AgreementUploadToken = (string)Session["AgreementUploadToken"];
        }

        private void SaveUploadedAgreement()
        {
            string physicalPath = null;
            bool created = false;
            string result;
            try
            {
                if (!Request.IsAuthenticated || Session["AgreementUploadToken"] == null ||
                    Request.Form["token"] != (string)Session["AgreementUploadToken"])
                    throw new InvalidOperationException("Your session has expired. Refresh the page and try again.");

                string tab = Request.Form["tab"];
                string version = Request.Form["version"];
                string versionDate = Request.Form["versionDate"];
                if ((tab != "Version" && tab != "Type") || string.IsNullOrWhiteSpace(version) || string.IsNullOrWhiteSpace(versionDate))
                    throw new InvalidOperationException("Please enter Version and Version Date.");
                var serializer = new JavaScriptSerializer();
                var clauses = tab == "Version" ? serializer.Deserialize<List<ClauseModel>>(Request.Form["rows"]) : null;
                var types = tab == "Type" ? serializer.Deserialize<List<TypeData>>(Request.Form["rows"]) : null;
                if (tab == "Version" && (clauses == null || clauses.Count == 0 || clauses.Any(c => c == null || string.IsNullOrWhiteSpace(c.ClauseNo) || string.IsNullOrWhiteSpace(c.ClauseDetails))))
                    throw new InvalidOperationException("Please enter at least one complete clause.");
                if (tab == "Type" && (types == null || types.Count == 0 || types.Any(t => t == null || string.IsNullOrWhiteSpace(t.TypeText) || string.IsNullOrWhiteSpace(t.MinServicePeriod))))
                    throw new InvalidOperationException("Please enter at least one complete Type.");

                HttpPostedFile file = Request.Files["file"];
                if (file == null || file.ContentLength == 0)
                    throw new InvalidOperationException("Please select a non-empty file.");
                if (file.ContentLength > 10 * 1024 * 1024)
                    throw new InvalidOperationException("The file must be 10 MB or smaller.");
                string name = Path.GetFileName(file.FileName);
                string[] extensions = { ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".txt", ".rtf", ".csv", ".png", ".jpg", ".jpeg", ".zip" };
                if (string.IsNullOrWhiteSpace(name) || name.IndexOfAny(Path.GetInvalidFileNameChars()) >= 0 ||
                    name.EndsWith(".") || name.EndsWith(" ") || !extensions.Contains(Path.GetExtension(name).ToLowerInvariant()))
                    throw new InvalidOperationException("Please choose a valid document, image, or ZIP file.");
                string savedPath = AgreementRoot + DateTime.Now.ToString("yyyy-MM-dd") + "/" + name;
                physicalPath = GetAgreementPhysicalPath(savedPath);
                Directory.CreateDirectory(Path.GetDirectoryName(physicalPath));
                // CreateNew preserves the original name without overwriting an earlier upload.
                using (var output = new FileStream(physicalPath, FileMode.CreateNew, FileAccess.Write))
                {
                    created = true;
                    file.InputStream.CopyTo(output);
                }
                result = tab == "Version" ? SaveAgreement_Versions(version, versionDate, clauses) : SaveAgreement_Types(version, versionDate, types);
                if (result == "Success")
                {
                    var document = new Hashtable
                    {
                        { "Type", tab }, { "Version", version }, { "Path", savedPath },
                        { "AddedBy", int.Parse(User.Identity.Name) }
                    };
                    // One attachment call after all clauses/types have been processed.
                    int documentId = new bllMaster().InsertAgreementVersionDocs(document);
                    if (documentId > 0) Context.Items["AgreementUploadSaved"] = true;
                    else result = "Details saved. This Version already has an uploaded file; the existing file has been kept.";
                }
                else if (string.IsNullOrEmpty(result))
                    result = "No new details were saved. These records may already exist; review the history before retrying.";
            }
            catch (InvalidOperationException ex) { result = ex.Message; }
            catch (IOException) { result = "Unable to store the file. A file with this name may already exist today. Rename it and try again."; }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Agreement upload failed: {0}", ex);
                result = "Unable to save the upload. Please review the history before trying again.";
            }
            finally
            {
                // Keep only the file whose single Version attachment was saved.
                if (created && Context.Items["AgreementUploadSaved"] == null)
                {
                    try { File.Delete(physicalPath); }
                    catch (Exception ex) { System.Diagnostics.Trace.TraceError("Agreement upload cleanup failed: {0}", ex); }
                }
            }
            Response.Clear();
            Response.ContentType = "application/json";
            Response.Write(new JavaScriptSerializer().Serialize(new { d = result }));
        }

        private string GetAgreementPhysicalPath(string savedPath)
        {
            if (string.IsNullOrWhiteSpace(savedPath) || !savedPath.StartsWith(AgreementRoot, StringComparison.Ordinal))
                throw new InvalidOperationException("Invalid agreement file path.");
            string relative = savedPath.Substring(AgreementRoot.Length);
            string[] parts = relative.Split('/');
            DateTime folderDate;
            if (parts.Length != 2 || !DateTime.TryParseExact(parts[0], "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture,
                System.Globalization.DateTimeStyles.None, out folderDate) || string.IsNullOrWhiteSpace(parts[1]) ||
                parts[1].IndexOfAny(Path.GetInvalidFileNameChars()) >= 0 || parts[1] == "." || parts[1] == "..")
                throw new InvalidOperationException("Invalid agreement file path.");
            string root = Path.GetFullPath(Server.MapPath(AgreementRoot)).TrimEnd(Path.DirectorySeparatorChar) + Path.DirectorySeparatorChar;
            string path = Path.GetFullPath(Path.Combine(root, parts[0], parts[1]));
            if (!path.StartsWith(root, StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException("Invalid agreement file path.");
            return path;
        }

        private void DownloadAgreement()
        {
            try
            {
                if (!Request.IsAuthenticated) { DownloadError(403, "Please sign in to download this file."); return; }
                long id;
                string tab = Request.QueryString["tab"];
                if (!long.TryParse(Request.QueryString["download"], out id) || id <= 0 || (tab != "Version" && tab != "Type"))
                { DownloadError(400, "Invalid download request."); return; }
                // Resolve only a saved database path, never a client-supplied file path.
                DataTable history = tab == "Version" ? new bllMaster().GetAgreementVersionHistory() : new bllMaster().GetAgreementTypeHistory();
                string key = tab == "Version" ? "AgrChangeID" : "AgreementTypeID";
                DataRow row = history == null ? null : history.AsEnumerable().FirstOrDefault(r => Convert.ToInt64(r[key]) == id);
                if (row == null || !history.Columns.Contains("FilePath") || string.IsNullOrWhiteSpace(Convert.ToString(row["FilePath"])))
                { DownloadError(404, "No file is attached to this record."); return; }
                string path = GetAgreementPhysicalPath(Convert.ToString(row["FilePath"]));
                if (!File.Exists(path)) { DownloadError(404, "The uploaded file is no longer available."); return; }
                Response.Clear();
                Response.ContentType = "application/octet-stream";
                Response.Cache.SetCacheability(HttpCacheability.Private);
                Response.Cache.SetNoStore();
                Response.AddHeader("X-Content-Type-Options", "nosniff");
                Response.AddHeader("Content-Disposition", "attachment; filename*=UTF-8''" + Uri.EscapeDataString(Path.GetFileName(path)));
                Response.TransmitFile(path);
            }
            catch (InvalidOperationException) { DownloadError(400, "Invalid agreement file path."); }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Agreement download failed: {0}", ex);
                DownloadError(500, "Unable to download this file. Please try again later.");
            }
        }

        private void DownloadError(int status, string message)
        {
            Response.Clear();
            Response.StatusCode = status;
            Response.TrySkipIisCustomErrors = true;
            Response.ContentType = "text/plain";
            Response.Write(message);
        }

        public class ClauseModel
        {
            public string ClauseNo { get; set; }
            public string ClauseDetails { get; set; }
        }

        public class TypeData
        {
            public string TypeText { get; set; }
            public string MinServicePeriod { get; set; }
        }

        [WebMethod]
        public static string SaveAgreement_Versions(string version, string versionDate, List<ClauseModel> clauses)
        {
            int ReturnValue = 0;
            string msg = "";
            try
            {

                foreach (var clause in clauses)
                {
                    Hashtable htParam = new Hashtable();
                    htParam["Version"] = version;
                    htParam["VersionDate"] = versionDate;
                    htParam["ClauseNo"] = clause.ClauseNo;
                    htParam["Clause"] = clause.ClauseDetails;
                    htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());
                    ReturnValue = new bllMaster().InsertAgreementVersionHistory(htParam);
                }

                if (ReturnValue > 0)
                    msg = "Success";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Agreement version save failed: {0}", ex);
                return "Unable to save the agreement version and attachment. Please check the server log and review the history before retrying.";
            }

            return msg;
        }


        [WebMethod]
        public static string SaveAgreement_Types(string version, string versionDate, List<TypeData> typeList)
        {
            int ReturnValue = 0;
            string msg = "";
            try
            {
                // Debug check
                if (typeList == null || typeList.Count == 0)
                {
                    return "Type list is empty";
                }

                foreach (var item in typeList)
                {
                    Hashtable htParam = new Hashtable();
                    htParam["Version"] = version;
                    htParam["VersionDate"] = versionDate;
                    htParam["AgreementType"] = item.TypeText;
                    htParam["MinServPeriod"] = item.MinServicePeriod;
                    htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                    ReturnValue =  new bllMaster().InsertAgreementTypeHistory(htParam);
                }

                if (ReturnValue > 0)
                    msg = "Success";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Agreement type save failed: {0}", ex);
                return "Unable to save the agreement type and attachment. Please check the server log and review the history before retrying.";
            }

            return msg;
        }


        [WebMethod]
        public static int UpdateAgreementVersionHistory(int AgrChangeID, string ClauseNo, string ClauseDetails)
        {
            int ReturnValue = 0;

            try
            {
                Hashtable htParam = new Hashtable();

                htParam["AgrChangeID"] = AgrChangeID;
                htParam["ClauseNo"] = ClauseNo;
                htParam["Clause"] = ClauseDetails;
                htParam["AddedBy"] = int.Parse(HttpContext.Current.User.Identity.Name.ToString());

                ReturnValue = new bllMaster().UpdateAgreementVersionHistory(htParam);

            }
            catch (Exception ex)
            {
                ReturnValue = 0;
            }
            return ReturnValue;
        }


        [WebMethod]
        public static string GetAgreementVersionHistory()
        {
            DataTable dt1 = new bllMaster().GetAgreementVersionHistory();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
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
        public static string GetAgreementTypeHistory()
        {
            DataTable dt1 = new bllMaster().GetAgreementTypeHistory();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt1 != null)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    row = new Dictionary<string, object>();
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
    }
}
