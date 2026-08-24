using System;
using System.Text.RegularExpressions;
using System.Web;

namespace WebPortal.App_Code.Class
{
    public static class SelfLeavesEmailTemplate
    {
        public static string Apply(string existingHtml, string emailTitle)
        {
            return Apply(existingHtml, emailTitle, false);
        }

        public static string Apply(string existingHtml, string emailTitle, bool preserveContentStyles)
        {
            string content = ExtractBody(existingHtml ?? String.Empty);

            // Remove only legacy branding and notification rows. Page-specific text
            // and data rows remain unchanged.
            content = Regex.Replace(content,
                @"(?is)^\s*<table(?=[^>]*(?:width\s*:\s*802px|CornflowerBlue))[^>]*>.*?Infinity IPS.*?</table>\s*",
                String.Empty);
            content = Regex.Replace(content,
                @"(?is)<tr[^>]*>\s*<td[^>]*colspan\s*=\s*[""']?2[""']?[^>]*>(?:(?!</td>).)*?(?:Thanks|Regards),\s*<br\s*/?>\s*(?:<[^>]+>)*\s*Infinity IPS(?:(?!</td>).)*?</td>\s*</tr>",
                String.Empty);
            content = Regex.Replace(content,
                @"(?is)<tr[^>]*>\s*<td[^>]*colspan\s*=\s*[""']?2[""']?[^>]*>(?:(?!</td>).)*?This email was sent from a notification email address that cannot accept incoming email\. Please do not reply to this message\.(?:(?!</td>).)*?</td>\s*</tr>",
                String.Empty);

            // Outlook depends on inline styles, so normalize the legacy layout inline.
            content = Regex.Replace(content, @"(?i)width\s*:\s*(800|802)px", "width:100%");
            content = Regex.Replace(content, @"(?i)width\s*=\s*[""']?(800|802)[""']?", "width=\"100%\"");
            content = Regex.Replace(content, @"(?i)font-family\s*:\s*(verdana|biome)", "font-family:Arial,'Helvetica Neue',sans-serif");
            content = Regex.Replace(content, @"(?i)border\s*:\s*solid\s+1px\s+Gray\s*;?", "border:1px solid #e2e8f0;");
            content = Regex.Replace(content, @"(?i)bordercolor\s*=\s*[""']?Gray[""']?", String.Empty);
            content = Regex.Replace(content, @"(?i)cellpadding\s*=\s*[""']10[""']", "cellpadding=\"0\"");
            content = Regex.Replace(content, @"(?i)<table(?![^>]*role=)", "<table role=\"presentation\"");

            string title = HttpUtility.HtmlEncode(String.IsNullOrWhiteSpace(emailTitle) ? "HRMS notification" : emailTitle.Trim());
            string contentClass = preserveContentStyles ? "content-pad" : "content-pad email-content";

            return "<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">" +
                "<style>body,table,td{font-family:Arial,'Helvetica Neue',sans-serif!important;text-align:left}.email-content table{width:100%!important;max-width:100%!important;border-collapse:separate!important}.email-content td{padding:11px 14px!important;color:#1e293b!important;font-size:13px!important;line-height:19px!important;vertical-align:top!important}.email-content td:first-child:not([colspan]){width:34%!important;color:#64748b!important;font-size:12px!important;font-weight:700!important}.email-content tr:last-child td{border-bottom:0!important}@media only screen and (max-width:620px){.email-shell{width:100%!important}.outer-pad{padding:10px!important}.content-pad{padding:20px 16px!important}.email-content td:first-child:not([colspan]){width:38%!important}}</style>" +
                "</head><body style=\"margin:0;padding:0;background-color:#f1f5f9;color:#1e293b;text-align:left;\">" +
                "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;background-color:#f1f5f9;text-align:left;\"><tr><td class=\"outer-pad\" align=\"left\" style=\"padding:20px 16px;text-align:left;\">" +
                "<table role=\"presentation\" class=\"email-shell\" width=\"680\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;max-width:680px;background-color:#ffffff;border:1px solid #e2e8f0;border-radius:16px;overflow:hidden;\">" +
                "<tr><td bgcolor=\"#173b70\" style=\"padding:15px 24px;background-color:#173b70;border-bottom:3px solid #2f80ed;text-align:left;\"><table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;background-color:#173b70;\"><tr><td bgcolor=\"#173b70\" style=\"color:#bfdbfe;font-size:10px;font-weight:700;line-height:14px;letter-spacing:1.2px;text-transform:uppercase;mso-line-height-rule:exactly;\">INFINITY IPS &nbsp;/&nbsp; HRMS</td></tr><tr><td height=\"4\" bgcolor=\"#173b70\" style=\"height:4px;font-size:0;line-height:4px;mso-line-height-rule:exactly;\">&nbsp;</td></tr><tr><td bgcolor=\"#173b70\" style=\"color:#ffffff;font-size:22px;font-weight:700;line-height:27px;mso-line-height-rule:exactly;\">" + title + "</td></tr></table></td></tr>" +
                "<tr><td class=\"" + contentClass + "\" style=\"padding:24px;text-align:left;\">" + content +
                "<p style=\"margin:26px 0 0;color:#475569;font-size:13px;line-height:20px;\">Regards,<br><strong style=\"color:#0f172a;\">Infinity IPS</strong></p>" +
                "</td></tr><tr><td style=\"padding:18px 32px;background-color:#f8fafc;border-top:1px solid #e2e8f0;color:#94a3b8;font-size:11px;line-height:17px;text-align:center;\">This is an automated notification from HRMS. Please do not reply to this email.</td></tr>" +
                "</table></td></tr></table></body></html>";
        }

        private static string ExtractBody(string html)
        {
            Match body = Regex.Match(html, @"(?is)<body\b[^>]*>(?<content>.*?)</body\s*>");
            return body.Success ? body.Groups["content"].Value : html;
        }
    }
}
