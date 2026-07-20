using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace WebPortal.App_Code.Class
{
    /// <summary>
    /// Adds one stable cache version to local JavaScript URLs for the lifetime of
    /// the deployed application. A new build or updated application script
    /// produces a new token.
    /// </summary>
    public static class AssetVersion
    {
        private const string VersionParameterName = "v";

        public static readonly string Current = CreateVersion();

        public static string AddToScriptUrl(string url)
        {
            if (!IsLocalJavaScript(url))
            {
                return url;
            }

            string fragment = string.Empty;
            int fragmentIndex = url.IndexOf('#');
            if (fragmentIndex >= 0)
            {
                fragment = url.Substring(fragmentIndex);
                url = url.Substring(0, fragmentIndex);
            }

            int queryIndex = url.IndexOf('?');
            string path = queryIndex >= 0 ? url.Substring(0, queryIndex) : url;
            string query = queryIndex >= 0 ? url.Substring(queryIndex + 1) : string.Empty;
            var retainedParameters = new List<string>();

            if (!string.IsNullOrWhiteSpace(query))
            {
                foreach (string parameter in query.Split('&'))
                {
                    if (string.IsNullOrWhiteSpace(parameter))
                    {
                        continue;
                    }

                    int equalsIndex = parameter.IndexOf('=');
                    string name = equalsIndex >= 0 ? parameter.Substring(0, equalsIndex) : parameter;
                    name = HttpUtility.UrlDecode(name);

                    if (!string.Equals(name, VersionParameterName, StringComparison.OrdinalIgnoreCase))
                    {
                        retainedParameters.Add(parameter);
                    }
                }
            }

            retainedParameters.Add(VersionParameterName + "=" + Current);
            return path + "?" + string.Join("&", retainedParameters) + fragment;
        }

        public static void ApplyTo(ScriptManager scriptManager)
        {
            if (scriptManager == null)
            {
                return;
            }

            ApplyTo(scriptManager.Scripts);

            if (scriptManager.CompositeScript != null)
            {
                ApplyTo(scriptManager.CompositeScript.Scripts);
            }
        }

        private static void ApplyTo(IEnumerable<ScriptReference> scripts)
        {
            if (scripts == null)
            {
                return;
            }

            foreach (ScriptReference script in scripts)
            {
                if (script != null && !string.IsNullOrWhiteSpace(script.Path))
                {
                    script.Path = AddToScriptUrl(script.Path);
                }
            }
        }

        private static bool IsLocalJavaScript(string url)
        {
            if (string.IsNullOrWhiteSpace(url))
            {
                return false;
            }

            string value = url.Trim();
            if (value.StartsWith("//", StringComparison.Ordinal)
                || value.StartsWith("http://", StringComparison.OrdinalIgnoreCase)
                || value.StartsWith("https://", StringComparison.OrdinalIgnoreCase)
                || value.StartsWith("data:", StringComparison.OrdinalIgnoreCase))
            {
                return false;
            }

            int queryIndex = value.IndexOf('?');
            string path = queryIndex >= 0 ? value.Substring(0, queryIndex) : value;
            return path.EndsWith(".js", StringComparison.OrdinalIgnoreCase);
        }

        private static string CreateVersion()
        {
            var seed = new StringBuilder(
                typeof(AssetVersion).Assembly.ManifestModule.ModuleVersionId.ToString("N"));
            string applicationRoot = GetApplicationRoot();

            AppendLatestScriptTimestamp(seed, applicationRoot, "Scripts");
            AppendLatestScriptTimestamp(seed, applicationRoot, Path.Combine("assets", "js"));

            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] hash = sha256.ComputeHash(Encoding.UTF8.GetBytes(seed.ToString()));
                return BitConverter.ToString(hash).Replace("-", string.Empty).Substring(0, 12).ToLowerInvariant();
            }
        }

        private static string GetApplicationRoot()
        {
            try
            {
                return HttpRuntime.AppDomainAppPath;
            }
            catch (ArgumentNullException)
            {
                return null;
            }
        }

        private static void AppendLatestScriptTimestamp(StringBuilder seed, string applicationRoot, string relativePath)
        {
            long latestTimestamp = 0;

            if (!string.IsNullOrWhiteSpace(applicationRoot))
            {
                try
                {
                    string scriptDirectory = Path.Combine(applicationRoot, relativePath);
                    if (Directory.Exists(scriptDirectory))
                    {
                        foreach (string scriptPath in Directory.EnumerateFiles(
                            scriptDirectory, "*.js", SearchOption.AllDirectories))
                        {
                            latestTimestamp = Math.Max(
                                latestTimestamp,
                                File.GetLastWriteTimeUtc(scriptPath).Ticks);
                        }
                    }
                }
                catch (IOException)
                {
                    // The assembly token still provides safe cache invalidation.
                }
                catch (UnauthorizedAccessException)
                {
                    // The assembly token still provides safe cache invalidation.
                }
            }

            seed.Append('|').Append(latestTimestamp.ToString("x"));
        }
    }

    [DefaultProperty("Src")]
    [ParseChildren(false)]
    [PersistChildren(true)]
    public sealed class VersionedScript : HtmlGenericControl
    {
        public VersionedScript()
            : base("script")
        {
        }

        public VersionedScript(string tagName)
            : base("script")
        {
            // ASP.NET supplies the registered server-control tag name here.
            // The browser must always receive a real HTML script element.
        }

        public string Src
        {
            get { return Attributes["src"] ?? string.Empty; }
            set { Attributes["src"] = value; }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            if (!string.IsNullOrWhiteSpace(Src))
            {
                Attributes["src"] = ResolveClientUrl(AssetVersion.AddToScriptUrl(Src));
            }
        }
    }
}
