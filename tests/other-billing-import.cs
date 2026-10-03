using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Web;
using System.Web.SessionState;
using ClosedXML.Excel;
using WebPortal.Admin;

// No database calls: existing-deal imports exercise the real Excel reader and session handling.
class OtherBillingImportCheck
{
    static readonly List<string> uploads = new List<string>();

    static string Upload(byte[] bytes)
    {
        string path = Path.Combine(Path.GetTempPath(), "other-billing-test-" + Guid.NewGuid().ToString("N") + ".xlsx");
        File.WriteAllBytes(path, bytes);
        uploads.Add(path);
        return path;
    }

    static void Check(bool condition, string message)
    {
        if (!condition) throw new Exception(message);
    }

    static HttpContext Context(string sessionId)
    {
        var context = new HttpContext(new HttpRequest("", "http://localhost/Admin/OtherBilling.aspx", ""),
            new HttpResponse(new StringWriter()));
        SessionStateUtility.AddHttpSessionStateToContext(context,
            new HttpSessionStateContainer(sessionId, new SessionStateItemCollection(),
                new HttpStaticObjectsCollection(), 90, true, HttpCookieMode.UseCookies,
                SessionStateMode.InProc, false));
        HttpContext.Current = context;
        return context;
    }

    static byte[] Workbook(string value, bool empty)
    {
        using (var workbook = new XLWorkbook())
        using (var stream = new MemoryStream())
        {
            var sheet = workbook.Worksheets.Add("Billing");
            if (!empty)
            {
                sheet.Cell(1, 1).Value = "Deal No";
                sheet.Cell(1, 2).Value = "Remark";
                sheet.Cell(2, 1).Value = value;
                sheet.Cell(2, 2).Value = "Test";
            }
            workbook.SaveAs(stream);
            return stream.ToArray();
        }
    }

    [MethodImpl(MethodImplOptions.NoInlining)]
    static void Run()
    {
        var first = Context("first");
        Check(OtherBilling.ImportExcel(1, "existing", "Existing") == -2, "Missing upload must require re-upload.");
        first.Session["OtherBillingUploadPath"] = Upload(Workbook("FIRST", false));
        Check(OtherBilling.ImportExcel(1, "existing", "Existing") == 1, "Valid workbook should import.");
        Check(OtherBilling.GetExcelDataToBindGrid().Contains("FIRST"), "Grid should use imported session data.");
        Check(File.Exists((string)first.Session["OtherBillingUploadPath"]), "Imported file should remain saved.");

        var second = Context("second");
        Check(OtherBilling.GetExcelDataToBindGrid() == "[]", "Another user must not see the first import.");
        second.Session["OtherBillingUploadPath"] = Upload(Workbook("SECOND", false));
        Check(OtherBilling.ImportExcel(1, "existing", "Existing") == 1, "Second user should import independently.");
        HttpContext.Current = first;
        Check(OtherBilling.GetExcelDataToBindGrid().Contains("FIRST"), "Second import must not replace the first user's data.");

        first.Session["OtherBillingUploadPath"] = Upload(new byte[] { 1, 2, 3 });
        Check(OtherBilling.ImportExcel(1, "existing", "Existing") == -4, "Corrupt workbook should return a controlled failure.");
        Check(OtherBilling.GetExcelDataToBindGrid() == "[]", "Failed import must clear stale data.");
        first.Session["OtherBillingUploadPath"] = Upload(Workbook("", true));
        Check(OtherBilling.ImportExcel(1, "existing", "Existing") == 0, "Empty worksheet should return no rows.");
        first.Session["OtherBillingUploadPath"] = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString("N") + ".xlsx");
        Check(OtherBilling.ImportExcel(1, "existing", "Existing") == -2, "Missing saved file should require re-upload.");
        Console.WriteLine("PASS: valid import, missing upload, corrupt/empty workbook, grid data, and user isolation.");
    }

    static int Main(string[] args)
    {
        string bin = Path.GetFullPath(args[0]);
        AppDomain.CurrentDomain.AssemblyResolve += delegate(object sender, ResolveEventArgs e)
        {
            string path = Path.Combine(bin, new AssemblyName(e.Name).Name + ".dll");
            return File.Exists(path) ? Assembly.LoadFrom(path) : null;
        };
        try { Run(); return 0; }
        catch (Exception ex) { Console.Error.WriteLine(ex); return 1; }
        finally { foreach (string path in uploads) File.Delete(path); }
    }
}
