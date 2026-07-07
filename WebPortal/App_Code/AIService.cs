using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web.Script.Serialization;

namespace WebPortal.App_Code
{
    public class AIService
    {
        private static readonly string OllamaUrl = GetSetting("OllamaGenerateUrl", "http://localhost:11434/api/generate");
        private static readonly string ModelName = GetSetting("OllamaModel", "qwen2.5:7b");
        private static readonly int OllamaTimeoutMs = GetIntSetting("OllamaTimeoutMs", 45000);

        public static string AskCopilot(string question, IEnumerable<string> allowedMenuLines)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(question))
                {
                    return "Please type what you want to find or do in ERP.";
                }

                string systemPrompt =
@"You are ERP Copilot for internal ERP users.
Help users find ERP menus, report pages, and common workflow guidance.
Use only the allowed menu/report list given below for navigation answers.
Never mention menu pages that are not present in the allowed list.
Do not write raw SQL, do not expose passwords, server paths, database credentials, or sensitive employee data.
If the user asks for a report, find the best allowed report page and provide the page URL.
If the exact page is unclear, suggest the closest allowed options and ask one short follow-up question.
Keep answers short and practical.";

                string fullPrompt = systemPrompt
                    + "\n\nAllowed menu/report pages for this logged-in user:\n"
                    + BuildMenuContext(allowedMenuLines)
                    + "\n\nUser Question: " + question.Trim()
                    + "\n\nAnswer with page names and internal URLs when relevant.";

                var payload = new
                {
                    model = ModelName,
                    prompt = fullPrompt,
                    stream = false,
                    options = new
                    {
                        temperature = 0.2,
                        num_ctx = 2048,
                        num_predict = 220
                    }
                };

                string json = new JavaScriptSerializer().Serialize(payload);

                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(OllamaUrl);
                request.Method = "POST";
                request.ContentType = "application/json";
                request.Timeout = OllamaTimeoutMs;
                request.ReadWriteTimeout = OllamaTimeoutMs;

                byte[] data = Encoding.UTF8.GetBytes(json);
                request.ContentLength = data.Length;

                using (Stream stream = request.GetRequestStream())
                {
                    stream.Write(data, 0, data.Length);
                }

                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    string result = reader.ReadToEnd();
                    dynamic obj = new JavaScriptSerializer().DeserializeObject(result);

                    if (obj.ContainsKey("response"))
                    {
                        return obj["response"].ToString();
                    }

                    return "AI response received, but no answer was returned.";
                }
            }
            catch (Exception ex)
            {
                if (ex is WebException && ((WebException)ex).Status == WebExceptionStatus.Timeout)
                {
                    return "AI service timed out. Menu and report search will still work instantly; for general AI answers, try a shorter question or use a smaller Ollama model.";
                }

                return "AI service is currently unavailable. Error: " + ex.Message;
            }
        }

        private static string BuildMenuContext(IEnumerable<string> allowedMenuLines)
        {
            if (allowedMenuLines == null)
            {
                return "No allowed menu pages were found for this user.";
            }

            List<string> lines = allowedMenuLines
                .Where(x => !string.IsNullOrWhiteSpace(x))
                .Take(120)
                .ToList();

            if (lines.Count == 0)
            {
                return "No allowed menu pages were found for this user.";
            }

            return string.Join("\n", lines);
        }

        private static string GetSetting(string key, string fallback)
        {
            string value = ConfigurationManager.AppSettings[key];
            return string.IsNullOrWhiteSpace(value) ? fallback : value;
        }

        private static int GetIntSetting(string key, int fallback)
        {
            int value;
            return int.TryParse(ConfigurationManager.AppSettings[key], out value) && value > 0
                ? value
                : fallback;
        }
    }
}
