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
            catch (SecurityException ex) { context.Response.StatusCode = 403; context.Response.Write(ex.Message); }
            catch (Exception ex) { context.Response.StatusCode = 400; context.Response.Write(ex.Message); }
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
            string temp = Path.Combine(Path.GetTempPath(), "bulletin-" + Guid.NewGuid().ToString("N")); Directory.CreateDirectory(temp);
            try { using (var p = Process.Start(new ProcessStartInfo(executable, "--headless --convert-to pdf --outdir \"" + temp + "\" \"" + source + "\"") { UseShellExecute = false, CreateNoWindow = true, WindowStyle = ProcessWindowStyle.Hidden })) { if (!p.WaitForExit(60000) || p.ExitCode != 0) throw new InvalidOperationException("Word-to-PDF conversion failed."); } string generated = Path.Combine(temp, Path.GetFileNameWithoutExtension(source) + ".pdf"); if (!File.Exists(generated)) throw new InvalidOperationException("PDF was not generated."); string stored = Guid.NewGuid().ToString("N") + ".pdf"; File.Move(generated, BulletinSecurity.SafePath(stored)); return stored; }
            finally { try { Directory.Delete(temp, true); } catch { } }
        }
        private static void Stream(HttpContext c)
        {
            long version; if (!long.TryParse(c.Request.QueryString["version"], out version)) throw new ArgumentException("Invalid document."); DataRow row = new BulletinRepository().AuthorizedVersion(version, BulletinSecurity.EmployeeID);
            bool preview = c.Request.QueryString["mode"] == "preview"; if (preview && string.IsNullOrWhiteSpace(Convert.ToString(row["PdfStoredFileName"])) && !Convert.ToString(row["ContentType"]).Equals("application/pdf", StringComparison.OrdinalIgnoreCase)) throw new InvalidOperationException("PDF preview is unavailable. Download the original Word document, or configure LibreOffice on the server."); string stored = preview && !string.IsNullOrWhiteSpace(Convert.ToString(row["PdfStoredFileName"])) ? Convert.ToString(row["PdfStoredFileName"]) : Convert.ToString(row["StoredFileName"]); string path = BulletinSecurity.SafePath(stored); if (!File.Exists(path)) throw new FileNotFoundException("File not found.");
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
        private static long? ParseLong(string value) { long x; return long.TryParse(value, out x) ? x : (long?)null; }
        private static void SafeDelete(string path) { try { if (File.Exists(path) && Path.GetFullPath(path).StartsWith(BulletinSecurity.StorageRoot, StringComparison.OrdinalIgnoreCase)) File.Delete(path); } catch { } }
    }
}
