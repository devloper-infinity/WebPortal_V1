using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Hosting;
using System.Xml;
using WebPortal.App_Code.BLL;

namespace WebPortal.Infrastructure
{
    /// <summary>Central, deny-by-default authorization for ASPX pages and page WebMethods.</summary>
    public sealed class ErpAuthorizationModule : IHttpModule
    {
        private sealed class CacheEntry { public DateTime ExpiresUtc; public HashSet<string> Pages; }
        private static readonly ConcurrentDictionary<int, CacheEntry> PermissionCache = new ConcurrentDictionary<int, CacheEntry>();
        private static readonly object LogLock = new object();

        public void Init(HttpApplication application) { application.AuthorizeRequest += Authorize; }
        public void Dispose() { }

        private static void Authorize(object sender, EventArgs args)
        {
            HttpApplication app = (HttpApplication)sender;
            HttpContext context = app.Context;
            RequestTarget target;
            string failure;
            if (!TryTarget(context.Request, out target, out failure))
            {
                Deny(context, true, 400, "invalid-url:" + failure, null, target);
                return;
            }
            if (!target.IsAspx) return;

            Settings settings = Settings.Load();
            if (settings.PublicPages.Contains(target.Page)) return;

            bool authenticated = context.User != null && context.User.Identity != null &&
                                 context.User.Identity.IsAuthenticated;
            int employeeId = 0;
            bool validEmployee = authenticated && Int32.TryParse(context.User.Identity.Name, out employeeId) && employeeId > 0;
            if (!validEmployee)
            {
                // A Forms Authentication identity is created only after the configured MFA flow succeeds.
                Deny(context, target.IsWebMethod, target.IsWebMethod ? 401 : 302,
                    authenticated ? "invalid-employee-identity" : "authentication-required", null, target);
                return;
            }

            if (settings.CommonPages.Contains(target.Page)) return;

            string requiredPage;
            string endpoint = target.IsWebMethod ? target.Page + "/" + target.Method : target.Page;
            if (target.IsWebMethod && settings.CommonMethods.Contains(endpoint)) return;
            if (target.IsWebMethod && settings.MethodPermissions.TryGetValue(endpoint, out requiredPage)) { }
            else if (settings.PagePermissions.TryGetValue(target.Page, out requiredPage)) { }
            else requiredPage = target.Page;

            HashSet<string> allowed;
            try { allowed = GetPermissions(employeeId, settings.CacheSeconds); }
            catch (Exception ex)
            {
                Trace.TraceError("ERP authorization lookup failed for employee {0}: {1}", employeeId, ex);
                Deny(context, target.IsWebMethod, 503, "permission-lookup-failed", employeeId, target);
                return;
            }

            string[] requiredPages = requiredPage.Split(new[] { '|' }, StringSplitOptions.RemoveEmptyEntries);
            if (!requiredPages.Any(allowed.Contains))
                Deny(context, target.IsWebMethod, 403,
                    requiredPage == target.Page ? "page-not-assigned-or-unmapped" : "required-permission-not-assigned:" + requiredPage,
                    employeeId, target);
        }

        private static HashSet<string> GetPermissions(int employeeId, int cacheSeconds)
        {
            CacheEntry entry;
            DateTime now = DateTime.UtcNow;
            if (PermissionCache.TryGetValue(employeeId, out entry) && entry.ExpiresUtc > now) return entry.Pages;

            DataTable table = new bllMaster().GetMenuForUserFromGroup(employeeId);
            HashSet<string> pages = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            if (table.Columns.Contains("Url"))
                foreach (DataRow row in table.Rows)
                {
                    string page = NormalizeConfiguredUrl(Convert.ToString(row["Url"], CultureInfo.InvariantCulture));
                    if (page != null) pages.Add(page);
                }
            entry = new CacheEntry { ExpiresUtc = now.AddSeconds(cacheSeconds), Pages = pages };
            PermissionCache[employeeId] = entry;
            return pages;
        }

        private static void Deny(HttpContext context, bool ajax, int status, string reason, int? employeeId, RequestTarget target)
        {
            LogDenied(context, employeeId, target, reason);
            context.Response.Clear();
            context.Response.TrySkipIisCustomErrors = true;
            context.Response.SuppressFormsAuthenticationRedirect = true;
            if (status == 302 && !ajax)
            {
                string returnUrl = HttpUtility.UrlEncode(context.Request.RawUrl);
                context.Response.Redirect(VirtualPathUtility.ToAbsolute("~/Login.aspx") + "?ReturnUrl=" + returnUrl, false);
                context.Response.StatusCode = 302;
            }
            else
            {
                context.Response.StatusCode = status;
                context.Response.ContentType = ajax ? "application/json" : "text/html; charset=utf-8";
                context.Response.Write(ajax ? "{\"Message\":\"Access denied.\"}" : AccessDeniedHtml(status));
            }
            context.ApplicationInstance.CompleteRequest();
        }

        private static string AccessDeniedHtml(int status)
        {
            string title = status == 503 ? "Service temporarily unavailable" : "Access to this page is restricted";
            string message = status == 503
                ? "We could not verify your permissions right now. Please try again shortly."
                : "Your account does not have permission to view this page. If you believe this is a mistake, please contact your ERP administrator.";
            return "<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">" +
                "<title>Access Denied | Infinity ERP</title><style>" +
                "*{box-sizing:border-box}html,body{height:100%;margin:0}body{font-family:Segoe UI,Arial,sans-serif;color:#102447;background:linear-gradient(135deg,#f4f7fb 0%,#e8eef7 50%,#eef7f7 100%);display:grid;place-items:center;padding:24px}" +
                ".card{position:relative;width:min(680px,100%);overflow:hidden;text-align:center;background:#fff;border:1px solid rgba(16,36,71,.09);border-radius:22px;padding:58px 44px 46px;box-shadow:0 24px 65px rgba(16,36,71,.14)}" +
                ".card:before{content:\"\";position:absolute;inset:0 0 auto;height:7px;background:linear-gradient(90deg,#102447,#173b70 55%,#17838b)}" +
                ".mark{width:92px;height:92px;margin:0 auto 28px;border-radius:50%;display:grid;place-items:center;background:linear-gradient(145deg,#edf3fb,#e7f6f5);box-shadow:inset 0 0 0 1px rgba(23,131,139,.12)}" +
                ".mark svg{width:43px;height:43px;fill:none;stroke:#173b70;stroke-width:2.2;stroke-linecap:round;stroke-linejoin:round}" +
                ".eyebrow{margin:0 0 12px;color:#b28a32;font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase}" +
                "h1{margin:0;color:#102447;font-size:clamp(27px,5vw,38px);line-height:1.18;font-weight:700}p{max-width:520px;margin:18px auto 0;color:#5c6b82;font-size:16px;line-height:1.65}" +
                ".rule{width:54px;height:3px;margin:28px auto 0;border-radius:3px;background:#17838b}" +
                ".brand{margin-top:26px;color:#8793a6;font-size:12px;font-weight:600;letter-spacing:.7px}" +
                "@media(max-width:560px){.card{padding:48px 24px 38px;border-radius:18px}.mark{width:78px;height:78px}.mark svg{width:37px;height:37px}p{font-size:15px}}" +
                "</style></head><body><main class=\"card\" role=\"main\"><div class=\"mark\" aria-hidden=\"true\"><svg viewBox=\"0 0 24 24\"><rect x=\"4\" y=\"10\" width=\"16\" height=\"11\" rx=\"2\"/><path d=\"M8 10V7a4 4 0 0 1 8 0v3\"/><path d=\"M12 14v3\"/></svg></div>" +
                "<div class=\"eyebrow\">Infinity IPS · ERP</div><h1>" + title + "</h1><p>" + message + "</p><div class=\"rule\"></div><div class=\"brand\">SECURE ENTERPRISE ACCESS</div></main></body></html>";
        }

        private static void LogDenied(HttpContext context, int? employeeId, RequestTarget target, string reason)
        {
            string loggedUrl = target.Page + (target.IsWebMethod ? "/" + target.Method : "");
            string line = String.Format(CultureInfo.InvariantCulture, "{0:o}\tEmployeeID={1}\tURL={2}\tMethod={3}\tIP={4}\tReason={5}{6}",
                DateTime.UtcNow, employeeId.HasValue ? employeeId.Value.ToString(CultureInfo.InvariantCulture) : "anonymous",
                Safe(loggedUrl), Safe(context.Request.HttpMethod), Safe(context.Request.UserHostAddress), Safe(reason), Environment.NewLine);
            Trace.TraceWarning(line.TrimEnd());
            try
            {
                string path = context.Server.MapPath("~/App_Data/UnauthorizedAccess.log");
                lock (LogLock) File.AppendAllText(path, line, Encoding.UTF8);
            }
            catch (Exception ex) { Trace.TraceError("Could not write unauthorized-access log: {0}", ex.Message); }
        }

        private static string Safe(string value)
        {
            if (String.IsNullOrEmpty(value)) return "";
            return value.Replace("\r", "").Replace("\n", "").Replace("\t", " ");
        }

        private struct RequestTarget { public bool IsAspx, IsWebMethod; public string Page, Method; }

        private static bool TryTarget(HttpRequest request, out RequestTarget target, out string failure)
        {
            target = new RequestTarget(); failure = null;
            string raw = request.Url == null ? request.RawUrl : request.Url.AbsolutePath;
            if (String.IsNullOrWhiteSpace(raw)) { failure = "empty"; return false; }
            string decoded = raw;
            try
            {
                for (int i = 0; i < 3; i++) { string next = Uri.UnescapeDataString(decoded); if (next == decoded) break; decoded = next; }
            }
            catch { failure = "encoding"; return false; }
            decoded = decoded.Replace('\\', '/');
            if (decoded.IndexOf("//", StringComparison.Ordinal) >= 0 || decoded.Split('/').Any(x => x == "." || x == ".."))
            { failure = "path-segment"; return false; }
            int marker = decoded.IndexOf(".aspx", StringComparison.OrdinalIgnoreCase);
            if (marker < 0) return true;
            string suffix = decoded.Substring(marker + 5).Trim('/');
            if (suffix.IndexOf('/') >= 0) { failure = "method-path"; return false; }
            target.IsAspx = true;
            target.Page = NormalizeConfiguredUrl(decoded.Substring(0, marker + 5));
            if (target.Page == null) { failure = "page"; return false; }
            target.IsWebMethod = suffix.Length > 0;
            target.Method = suffix.ToLowerInvariant();
            return true;
        }

        private static string NormalizeConfiguredUrl(string value)
        {
            if (String.IsNullOrWhiteSpace(value) || value.Trim() == "#" || value.StartsWith("javascript:", StringComparison.OrdinalIgnoreCase)) return null;
            string path = value.Trim().Replace('\\', '/');
            int query = path.IndexOfAny(new[] { '?', '#' }); if (query >= 0) path = path.Substring(0, query);
            try { path = Uri.UnescapeDataString(path); } catch { return null; }
            while (path.StartsWith("../", StringComparison.Ordinal)) path = path.Substring(3);
            if (path.StartsWith("~/", StringComparison.Ordinal)) path = path.Substring(2);
            path = path.TrimStart('/');
            if (!path.EndsWith(".aspx", StringComparison.OrdinalIgnoreCase) || path.Split('/').Any(x => x == "." || x == "..")) return null;
            return path.ToLowerInvariant();
        }

        private sealed class Settings
        {
            public HashSet<string> PublicPages, CommonPages, CommonMethods;
            public Dictionary<string, string> PagePermissions, MethodPermissions;
            public int CacheSeconds;
            public static Settings Load()
            {
                int seconds; if (!Int32.TryParse(Read("Authorization.CacheSeconds"), out seconds)) seconds = 60;
                seconds = Math.Max(5, Math.Min(seconds, 300));
                return new Settings
                {
                    PublicPages = Set(Read("Authorization.PublicPages")),
                    CommonPages = Set(Read("Authorization.CommonPages")),
                    CommonMethods = MethodSet(Read("Authorization.CommonMethods")),
                    PagePermissions = Map(Read("Authorization.PagePermissions"), false),
                    MethodPermissions = Map(Read("Authorization.MethodPermissions"), true),
                    CacheSeconds = seconds
                };
            }
            private static string Read(string key)
            {
                try
                {
                    string path = HostingEnvironment.MapPath("~/Authorization.config");
                    if (!String.IsNullOrEmpty(path) && File.Exists(path))
                    {
                        var document = new XmlDocument();
                        document.Load(path);
                        XmlNode node = document.SelectSingleNode("/appSettings/add[@key=" + QuoteXPath(key) + "]");
                        if (node != null && node.Attributes != null && node.Attributes["value"] != null)
                            return node.Attributes["value"].Value;
                    }
                }
                catch (Exception ex) { Trace.TraceError("Could not read authorization configuration: {0}", ex.Message); }
                return ConfigurationManager.AppSettings[key];
            }
            private static string QuoteXPath(string value) { return "'" + value.Replace("'", "") + "'"; }
            private static HashSet<string> Set(string text) { return new HashSet<string>((text ?? "").Split(',').Select(NormalizeConfiguredUrl).Where(x => x != null), StringComparer.OrdinalIgnoreCase); }
            private static HashSet<string> MethodSet(string text)
            {
                return new HashSet<string>((text ?? "").Split(',').Select(x => x.Trim().Replace('\\', '/').TrimStart('~', '/').ToLowerInvariant()).Where(x => x.Contains(".aspx/")), StringComparer.OrdinalIgnoreCase);
            }
            private static Dictionary<string, string> Map(string text, bool method)
            {
                var result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                foreach (string item in (text ?? "").Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    int equals = item.IndexOf('='); if (equals <= 0) continue;
                    string key = item.Substring(0, equals).Trim().Replace('\\', '/').TrimStart('~', '/').ToLowerInvariant();
                    string value = String.Join("|", item.Substring(equals + 1).Split('|').Select(NormalizeConfiguredUrl).Where(x => x != null));
                    if (value.Length > 0 && (!method || key.Contains(".aspx/"))) result[key] = value;
                }
                return result;
            }
        }
    }
}
