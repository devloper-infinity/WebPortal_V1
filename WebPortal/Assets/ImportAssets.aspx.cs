using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using WebPortal.Assets.Classes;

namespace WebPortal.Assets
{
    public partial class ImportAssets : System.Web.UI.Page
    {
        private static AssetBAL S { get { return new AssetBAL(); } }
        private static long U { get { return Convert.ToInt64(HttpContext.Current.User.Identity.Name); } }

        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static object Lookup(string type, int? parentID) { return AssetBAL.Rows(S.Lookup(type, parentID)); }

        [WebMethod]
        public static object List() { return AssetBAL.Rows(S.List("Import")); }

        [WebMethod]
        public static object Get(long id) { return AssetBAL.Rows(S.ImportDetail(id)); }

        protected void btnImport_Click(object sender, EventArgs e)
        {
            lblMessage.CssClass = "ml-2 text-danger";
            if (!fuAssets.HasFile)
            {
                lblMessage.Text = "Select a CSV file to import.";
                return;
            }
            if (!string.Equals(Path.GetExtension(fuAssets.FileName), ".csv", StringComparison.OrdinalIgnoreCase))
            {
                lblMessage.Text = "Only CSV files are supported. Use the downloadable template.";
                return;
            }
            if (fuAssets.PostedFile.ContentLength > 5 * 1024 * 1024)
            {
                lblMessage.Text = "The import file must be 5 MB or smaller.";
                return;
            }

            var errors = new List<string>();
            var imported = 0;
            try
            {
                var category = LookupMap("Category");
                var type = LookupMap("Type");
                var brand = LookupMap("Brand");
                var model = LookupMap("Model");
                var branch = LookupMap("Branch");
                int defaultBranchId;
                int.TryParse(Request.Form["branch"], out defaultBranchId);
                var lines = ReadCsv(fuAssets.PostedFile.InputStream);
                if (lines.Count < 2) throw new InvalidOperationException("The CSV contains no data rows.");

                var headers = lines[0].Select(x => x.Trim()).ToList();
                RequireColumns(headers, "AssetTagNumber", "Category", "AssetType");
                for (var rowIndex = 1; rowIndex < lines.Count; rowIndex++)
                {
                    if (lines[rowIndex].All(string.IsNullOrWhiteSpace)) continue;
                    try
                    {
                        var row = ToRow(headers, lines[rowIndex]);
                        var input = new AssetInput
                        {
                            AssetTagNumber = Required(row, "AssetTagNumber"),
                            SerialNumber = Value(row, "SerialNumber"),
                            AssetCategoryID = Resolve(category, Required(row, "Category"), "category"),
                            AssetTypeID = Resolve(type, Required(row, "AssetType"), "asset type"),
                            AssetBrandID = ResolveOptional(brand, Value(row, "Brand"), "brand"),
                            AssetModelID = ResolveOptional(model, Value(row, "Model"), "model"),
                            CurrentBranchID = string.IsNullOrWhiteSpace(Value(row, "Branch")) && defaultBranchId > 0 ? defaultBranchId : Resolve(branch, Required(row, "Branch"), "branch"),
                            PurchaseDate = DateOptional(Value(row, "PurchaseDate"), "PurchaseDate"),
                            PurchaseValue = DecimalOptional(Value(row, "PurchaseValue"), "PurchaseValue"),
                            InvoiceNumber = Value(row, "InvoiceNumber"),
                            WarrantyEndDate = DateOptional(Value(row, "WarrantyEndDate"), "WarrantyEndDate"),
                            AssetCondition = Value(row, "Condition"),
                            Remarks = Value(row, "Remarks")
                        };
                        S.SaveAsset(input, U);
                        imported++;
                    }
                    catch (Exception ex)
                    {
                        errors.Add("Row " + (rowIndex + 1) + ": " + ex.Message);
                    }
                }
            }
            catch (Exception ex)
            {
                errors.Add(ex.Message);
            }

            lblMessage.CssClass = errors.Count == 0 ? "ml-2 text-success" : "ml-2 text-warning";
            lblMessage.Text = imported + " asset(s) imported." + (errors.Count > 0 ? " " + errors.Count + " failed: " + string.Join("; ", errors.Take(5).ToArray()) : string.Empty);
        }

        private static Dictionary<string, int> LookupMap(string type)
        {
            return AssetBAL.Rows(S.Lookup(type)).Where(x => x.ContainsKey("ID") && x.ContainsKey("Name"))
                .ToDictionary(x => Convert.ToString(x["Name"]).Trim(), x => Convert.ToInt32(x["ID"]), StringComparer.OrdinalIgnoreCase);
        }

        private static int Resolve(Dictionary<string, int> map, string value, string label)
        {
            int id;
            if (!map.TryGetValue(value.Trim(), out id)) throw new InvalidOperationException("Unknown " + label + " '" + value + "'.");
            return id;
        }

        private static int? ResolveOptional(Dictionary<string, int> map, string value, string label)
        {
            return string.IsNullOrWhiteSpace(value) ? (int?)null : Resolve(map, value, label);
        }

        private static DateTime? DateOptional(string value, string label)
        {
            DateTime result;
            if (string.IsNullOrWhiteSpace(value)) return null;
            if (!DateTime.TryParseExact(value.Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out result))
                throw new InvalidOperationException(label + " must use yyyy-MM-dd format.");
            return result;
        }

        private static decimal DecimalOptional(string value, string label)
        {
            decimal result;
            if (string.IsNullOrWhiteSpace(value)) return 0;
            if (!decimal.TryParse(value, NumberStyles.Number, CultureInfo.InvariantCulture, out result))
                throw new InvalidOperationException(label + " is not a valid number.");
            return result;
        }

        private static string Required(Dictionary<string, string> row, string key)
        {
            var value = Value(row, key);
            if (string.IsNullOrWhiteSpace(value)) throw new InvalidOperationException(key + " is required.");
            return value.Trim();
        }

        private static string Value(Dictionary<string, string> row, string key)
        {
            string value;
            return row.TryGetValue(key, out value) ? value : string.Empty;
        }

        private static Dictionary<string, string> ToRow(IList<string> headers, IList<string> values)
        {
            var row = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            for (var i = 0; i < headers.Count; i++) row[headers[i]] = i < values.Count ? values[i].Trim() : string.Empty;
            return row;
        }

        private static void RequireColumns(IList<string> headers, params string[] required)
        {
            foreach (var name in required)
                if (!headers.Any(x => string.Equals(x, name, StringComparison.OrdinalIgnoreCase)))
                    throw new InvalidOperationException("Missing required column: " + name + ".");
        }

        private static List<List<string>> ReadCsv(Stream stream)
        {
            var rows = new List<List<string>>();
            using (var reader = new StreamReader(stream, Encoding.UTF8, true, 4096, true))
            {
                var row = new List<string>();
                var field = new StringBuilder();
                var quoted = false;
                while (true)
                {
                    var next = reader.Read();
                    if (next < 0)
                    {
                        if (quoted) throw new InvalidOperationException("The CSV has an unterminated quoted field.");
                        if (field.Length > 0 || row.Count > 0) { row.Add(field.ToString()); rows.Add(row); }
                        break;
                    }
                    var ch = (char)next;
                    if (ch == '"')
                    {
                        if (quoted && reader.Peek() == '"') { reader.Read(); field.Append('"'); }
                        else quoted = !quoted;
                    }
                    else if (ch == ',' && !quoted) { row.Add(field.ToString()); field.Clear(); }
                    else if ((ch == '\r' || ch == '\n') && !quoted)
                    {
                        if (ch == '\r' && reader.Peek() == '\n') reader.Read();
                        row.Add(field.ToString()); field.Clear(); rows.Add(row); row = new List<string>();
                    }
                    else field.Append(ch);
                }
            }
            return rows;
        }
    }
}
