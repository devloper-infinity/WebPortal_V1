using System;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Security;
using System.Web;

namespace WebPortal.OperationsBulletin
{
    public class DocumentHandler : IHttpHandler
    {
        public bool IsReusable { get { return false; } }
        public void ProcessRequest(HttpContext context)
        {
            try { if (context.Request.HttpMethod == "POST") Upload(context); else Stream(context); }
            catch (SecurityException ex) { WriteError(context, 403, ex.Message); }
            catch (FileNotFoundException ex) { WriteError(context, 404, ex.Message); }
            catch (UnauthorizedAccessException ex)
            {
                Trace.TraceError("Operations Bulletin file access denied: " + ex);
                WriteError(context, 500, "Document file access denied: " + ex.Message);
            }
            catch (ArgumentException ex) { WriteError(context, 400, ex.Message); }
            catch (Exception ex)
            {
                Trace.TraceError("Operations Bulletin document error: " + ex);
                WriteError(context, 500, "Document processing failed: " + ex.Message);
            }
        }
        private static void WriteError(HttpContext context, int statusCode, string message)
        {
            context.Response.Clear();
            context.Response.StatusCode = statusCode;
            context.Response.TrySkipIisCustomErrors = true;
            context.Response.ContentType = "text/plain; charset=utf-8";
            context.Response.Write(message);
        }
        private static void Upload(HttpContext c)
        {
            int user = BulletinSecurity.EmployeeID; long folder; if (!long.TryParse(c.Request.Form["folderId"], out folder)) throw new ArgumentException("Folder is required.");
            if (c.Request.Files.Count != 1) throw new ArgumentException("Select one file."); HttpPostedFile file = c.Request.Files[0];
            long max = 25L * 1024 * 1024; if (file.ContentLength <= 0 || file.ContentLength > max) throw new ArgumentException("Maximum file size is 25 MB.");
            string ext = Path.GetExtension(file.FileName).ToLowerInvariant(); if (ext != ".docx" && ext != ".pdf") throw new ArgumentException("Only DOCX and PDF files are allowed.");
            byte[] header = new byte[4]; file.InputStream.Read(header, 0, 4); file.InputStream.Position = 0;
            if (ext == ".docx" && !(header[0] == 0x50 && header[1] == 0x4B)) throw new ArgumentException("Invalid DOCX content.");
            if (ext == ".pdf" && !(header[0] == 0x25 && header[1] == 0x50 && header[2] == 0x44 && header[3] == 0x46)) throw new ArgumentException("Invalid PDF content.");
            string stored = Guid.NewGuid().ToString("N") + ext, path = BulletinSecurity.SafePath(stored), pdf = null; file.SaveAs(path);
            long? bulletin = ParseLong(c.Request.Form["bulletinId"]), document = ParseLong(c.Request.Form["documentId"]);
            try { pdf = ext == ".docx" ? ConvertToPdf(path) : stored; long version = new BulletinRepository().SaveUpload(folder, bulletin, document, Path.GetFileName(file.FileName), stored, pdf, file.ContentType, file.ContentLength, BulletinRepository.Hash(path), user); c.Response.ContentType = "application/json"; c.Response.Write("{\"ok\":true,\"versionId\":" + version + ",\"previewAvailable\":" + (pdf != null ? "true" : "false") + "}"); }
            catch { SafeDelete(path); if (!string.IsNullOrWhiteSpace(pdf) && pdf != stored) SafeDelete(BulletinSecurity.SafePath(pdf)); throw; }
        }
        private static string ConvertToPdf(string source)
        {
            string executable = ConfigurationManager.AppSettings["OperationsBulletinLibreOfficePath"];
            if (string.IsNullOrWhiteSpace(executable) || !File.Exists(executable)) return null;
            string conversionRoot = Path.Combine(BulletinSecurity.StorageRoot, ".conversion");
            string temp = Path.Combine(conversionRoot, "bulletin-" + Guid.NewGuid().ToString("N")), profile = Path.Combine(temp, "profile");
            Directory.CreateDirectory(profile);
            try { string profileUri = new Uri(profile + Path.DirectorySeparatorChar).AbsoluteUri; string arguments = "-env:UserInstallation=" + profileUri + " --headless --nologo --nodefault --nolockcheck --nofirststartwizard --convert-to pdf --outdir \"" + temp + "\" \"" + source + "\""; using (var p = Process.Start(new ProcessStartInfo(executable, arguments) { UseShellExecute = false, CreateNoWindow = true, WindowStyle = ProcessWindowStyle.Hidden })) { if (!p.WaitForExit(60000)) { try { p.Kill(); } catch { } throw new InvalidOperationException("Word-to-PDF conversion timed out."); } if (p.ExitCode != 0) throw new InvalidOperationException("Word-to-PDF conversion failed."); } string generated = Path.Combine(temp, Path.GetFileNameWithoutExtension(source) + ".pdf"); if (!File.Exists(generated) || new FileInfo(generated).Length == 0) throw new InvalidOperationException("PDF was not generated."); string stored = Guid.NewGuid().ToString("N") + ".pdf"; File.Move(generated, BulletinSecurity.SafePath(stored)); return stored; }
            finally { try { Directory.Delete(temp, true); } catch { } }
        }
        private static void Stream(HttpContext c)
        {
            long version; if (!long.TryParse(c.Request.QueryString["version"], out version)) throw new ArgumentException("Invalid document."); DataRow row = new BulletinRepository().AuthorizedVersion(version, BulletinSecurity.EmployeeID);
            bool preview = c.Request.QueryString["mode"] == "preview";
            string pdfStored = Convert.ToString(row["PdfStoredFileName"]);
            bool originalIsPdf = Convert.ToString(row["ContentType"]).Equals("application/pdf", StringComparison.OrdinalIgnoreCase);
            bool pdfExists = false;
            if (!string.IsNullOrWhiteSpace(pdfStored))
            {
                try { pdfExists = File.Exists(BulletinSecurity.SafePath(pdfStored)); }
                catch (ArgumentException) { }
                catch (SecurityException) { }
            }
            if (preview && !originalIsPdf && !pdfExists)
            {
                string previousPdf = pdfStored;
                string originalPath = BulletinSecurity.SafePath(Convert.ToString(row["StoredFileName"]));
                if (File.Exists(originalPath))
                {
                    string generated = null;
                    try { generated = ConvertToPdf(originalPath); }
                    catch (InvalidOperationException) { }
                    catch (IOException) { }
                    if (!string.IsNullOrWhiteSpace(generated))
                    {
                        pdfStored = new BulletinRepository().SaveGeneratedPdf(version, generated, previousPdf);
                        if (!generated.Equals(pdfStored, StringComparison.OrdinalIgnoreCase)) SafeDelete(BulletinSecurity.SafePath(generated));
                    }
                }
                if (string.IsNullOrWhiteSpace(pdfStored))
                {
                    WritePreviewUnavailable(c, version, Convert.ToString(row["OriginalFileName"]));
                    return;
                }
            }
            string stored = preview && !string.IsNullOrWhiteSpace(pdfStored) ? pdfStored : Convert.ToString(row["StoredFileName"]); string path = BulletinSecurity.SafePath(stored);
            if (preview && !File.Exists(path) && !originalIsPdf)
            {
                WritePreviewUnavailable(c, version, Convert.ToString(row["OriginalFileName"]));
                return;
            }
            if (!File.Exists(path)) throw new FileNotFoundException("File not found.");
            string originalName = Path.GetFileName(Convert.ToString(row["OriginalFileName"]));
            string responseName = preview ? Path.GetFileNameWithoutExtension(originalName) + ".pdf" : originalName;
            string safeName = responseName.Replace("\"", "").Replace("\r", "").Replace("\n", "");
            c.Response.Clear();
            c.Response.ContentType = preview ? "application/pdf" : Convert.ToString(row["ContentType"]);
            c.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            c.Response.Cache.SetNoStore();
            c.Response.AddHeader("X-Content-Type-Options", "nosniff");
            c.Response.AddHeader("Content-Disposition", (preview ? "inline" : "attachment") + "; filename=\"" + safeName + "\"; filename*=UTF-8''" + Uri.EscapeDataString(responseName));
            c.Response.TransmitFile(path);
        }
        private static void WritePreviewUnavailable(HttpContext c, long version, string originalName)
        {
            string name = HttpUtility.HtmlEncode(Path.GetFileName(originalName));
            string downloadUrl = "DocumentHandler.ashx?version=" + version;
            c.Response.Clear();
            c.Response.StatusCode = 200;
            c.Response.ContentType = "text/html; charset=utf-8";
            c.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            c.Response.Cache.SetNoStore();
            c.Response.AddHeader("X-Content-Type-Options", "nosniff");
            c.Response.Write("<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><style>body{margin:0;font-family:Arial,sans-serif;color:#25364a;background:#f7f9fc}.message{max-width:560px;margin:64px auto;padding:28px;text-align:center;background:#fff;border:1px solid #dce3ed;border-radius:8px}.message h2{margin:0 0 12px;font-size:20px}.message p{line-height:1.5;color:#5c6b7a}.download{display:inline-block;margin-top:8px;padding:10px 18px;border-radius:4px;background:#1769aa;color:#fff;text-decoration:none;font-weight:600}</style></head><body><div class=\"message\"><h2>Preview unavailable</h2><p>" + name + " is a Word document and does not have a PDF preview. You can still open the original file.</p><a class=\"download\" href=\"" + downloadUrl + "\" target=\"_top\">Download document</a></div></body></html>");
        }
        private static long? ParseLong(string value) { long x; return long.TryParse(value, out x) ? x : (long?)null; }
        private static void SafeDelete(string path) { try { if (File.Exists(path) && Path.GetFullPath(path).StartsWith(BulletinSecurity.StorageRoot, StringComparison.OrdinalIgnoreCase)) File.Delete(path); } catch { } }
    }
}
