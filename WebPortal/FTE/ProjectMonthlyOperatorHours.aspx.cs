using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.App_Code.DAL;

namespace WebPortal.FTE
{
    public partial class ProjectMonthlyOperatorHours : System.Web.UI.Page
    {
        private readonly string cs = SQLHelper.ConnectionString;

        // Change this to your existing configuration table name.
        private const string ConfigTable = "FTEConfiguration";

        // Dropdown value is ProjectID. ProjectName is used only for display.

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindMonth();
                txtYear.Text = DateTime.Now.Year.ToString();
                BindProjects();
                LoadSelectedProjectConfig();
            }
        }

        private void BindMonth()
        {
            ddlMonth.Items.Clear();
            for (int i = 1; i <= 12; i++)
                ddlMonth.Items.Add(new ListItem(CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(i), i.ToString()));

            ddlMonth.SelectedValue = DateTime.Now.Month.ToString();
        }

        private void BindProjects()
        {
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("SELECT C.ProjectID, P.ProjectName FROM " + ConfigTable + " C inner join Project P on P.ProjectID=C.ProjectID ORDER BY P.ProjectName", con))
            {
                con.Open();
                ddlProject.DataSource = cmd.ExecuteReader();
                ddlProject.DataTextField = "ProjectName";
                ddlProject.DataValueField = "ProjectID";
                ddlProject.DataBind();
            }
            ddlProject.Items.Insert(0, new ListItem("-- Select Project --", ""));
        }

        protected void ddlProject_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadSelectedProjectConfig();
        }

        protected void btnLoadConfig_Click(object sender, EventArgs e)
        {
            LoadSelectedProjectConfig();
        }

        private DataRow GetProjectConfig(int projectId)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(@"
            SELECT TOP 1 C.ProjectID, ProjectName, ProcessName, ApprovedFTECount, BillableStandardHours, BillingType, WeekendAllowed, USHolidayAllowed
            FROM " + ConfigTable + @"
            C inner join Project P on P.ProjectID=C.ProjectID inner join Process Pr on Pr.ProcessID=C.ProcessID WHERE C.ProjectID = @ProjectID", con))
            {
                cmd.Parameters.AddWithValue("@ProjectID", projectId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            return dt.Rows.Count == 0 ? null : dt.Rows[0];
        }

        private void LoadSelectedProjectConfig()
        {
            ClearMessage();
            if (string.IsNullOrWhiteSpace(ddlProject.SelectedValue))
            {
                lblProject.Text = lblProcess.Text = lblFTE.Text = lblHours.Text = lblWeekend.Text = lblUSHoliday.Text = "-";
                return;
            }

            DataRow dr = GetProjectConfig(Convert.ToInt32(ddlProject.SelectedValue));
            if (dr == null)
            {
                ShowMessage("Project configuration not found.", false);
                return;
            }

            lblProject.Text = Convert.ToString(dr["ProjectName"]);
            lblProcess.Text = Convert.ToString(dr["ProcessName"]);
            lblFTE.Text = Convert.ToString(dr["ApprovedFTECount"]);
            lblHours.Text = Convert.ToString(dr["BillableStandardHours"]);
            lblWeekend.Text = Convert.ToString(dr["WeekendAllowed"]);
            lblUSHoliday.Text = Convert.ToString(dr["USHolidayAllowed"]);
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            ClearMessage();
            if (!ValidateSelection()) return;

            int headerId;
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("usp_GenerateProjectMonthlyHours", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ProjectID", Convert.ToInt32(ddlProject.SelectedValue));
                cmd.Parameters.AddWithValue("@MonthNo", Convert.ToInt32(ddlMonth.SelectedValue));
                cmd.Parameters.AddWithValue("@YearNo", Convert.ToInt32(txtYear.Text));
                cmd.Parameters.AddWithValue("@ExtraOperators", Convert.ToInt32(txtExtraOperators.Text));
                cmd.Parameters.AddWithValue("@CreatedBy", Convert.ToString(Session["UserName"] ?? User.Identity.Name ?? "System"));
                con.Open();
                headerId = Convert.ToInt32(cmd.ExecuteScalar());
            }

            hfHeaderId.Value = headerId.ToString();
            BindMonthlyGrid(headerId);
            LoadSelectedProjectConfig();
            ShowMessage("Monthly sheet generated successfully.", true);
        }

        private bool ValidateSelection()
        {
            int n;
            if (string.IsNullOrWhiteSpace(ddlProject.SelectedValue)) { ShowMessage("Please select project.", false); return false; }
            if (!int.TryParse(txtYear.Text, out n) || n < 2000) { ShowMessage("Please enter valid year.", false); return false; }
            if (!int.TryParse(txtExtraOperators.Text, out n) || n < 0 || n > 20) { ShowMessage("Please enter valid extra operator count.", false); return false; }
            return true;
        }

        private void BindMonthlyGrid(int headerId)
        {
            DataTable raw = new DataTable();
            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("usp_GetProjectMonthlyHours", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@HeaderId", headerId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(raw);
            }

            BuildGridColumns(raw);
            gvHours.DataSource = BuildPivotTable(raw);
            gvHours.DataBind();
        }

        private void BuildGridColumns(DataTable raw)
        {
            gvHours.Columns.Clear();
            gvHours.Columns.Add(new BoundField { HeaderText = "S.No", DataField = "SNo", ReadOnly = true });
            gvHours.Columns.Add(new BoundField { HeaderText = "Date", DataField = "WorkDateText", ReadOnly = true });

            int regularCount = GetMaxOperator(raw, "Regular");
            int extraCount = GetMaxOperator(raw, "Extra");

            for (int i = 1; i <= regularCount; i++)
                gvHours.Columns.Add(CreateTextColumn("Operator" + i + " (Hours)", "Regular_" + i));

            for (int i = 1; i <= extraCount; i++)
                gvHours.Columns.Add(CreateTextColumn("Extra Operator " + i + " (Hours)", "Extra_" + i));
        }

        private TemplateField CreateTextColumn(string header, string fieldName)
        {
            return new TemplateField
            {
                HeaderText = header,
                ItemTemplate = new TextBoxTemplate(fieldName)
            };
        }

        private int GetMaxOperator(DataTable raw, string type)
        {
            if (raw.Rows.Count == 0) return 0;
            var rows = raw.AsEnumerable().Where(r => Convert.ToString(r["OperatorType"]) == type);
            return rows.Any() ? rows.Max(r => Convert.ToInt32(r["OperatorNo"])) : 0;
        }

        private DataTable BuildPivotTable(DataTable raw)
        {
            DataTable grid = new DataTable();
            grid.Columns.Add("SNo", typeof(int));
            grid.Columns.Add("WorkDate", typeof(DateTime));
            grid.Columns.Add("WorkDateText", typeof(string));

            int regularCount = GetMaxOperator(raw, "Regular");
            int extraCount = GetMaxOperator(raw, "Extra");
            for (int i = 1; i <= regularCount; i++) grid.Columns.Add("Regular_" + i, typeof(string));
            for (int i = 1; i <= extraCount; i++) grid.Columns.Add("Extra_" + i, typeof(string));

            int sr = 1;
            foreach (var group in raw.AsEnumerable().GroupBy(r => Convert.ToDateTime(r["WorkDate"])).OrderBy(g => g.Key))
            {
                DataRow row = grid.NewRow();
                row["SNo"] = sr++;
                row["WorkDate"] = group.Key;
                row["WorkDateText"] = group.Key.ToString("d-MMM-yy");

                foreach (DataRow item in group)
                {
                    string col = Convert.ToString(item["OperatorType"]) + "_" + Convert.ToString(item["OperatorNo"]);
                    bool isHoliday = Convert.ToBoolean(item["IsHoliday"]);
                    row[col] = isHoliday ? "HOLIDAY" : FormatHours(item["Hours"]);
                }
                grid.Rows.Add(row);
            }
            return grid;
        }

        private string FormatHours(object value)
        {
            if (value == DBNull.Value || value == null) return "";
            decimal h = Convert.ToDecimal(value);
            return h.ToString("0.##");
        }

        protected void gvHours_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            for (int i = 2; i < e.Row.Cells.Count; i++)
            {
                TextBox txt = e.Row.Cells[i].FindControl("txtCell") as TextBox;
                if (txt != null && txt.Text.Equals("HOLIDAY", StringComparison.OrdinalIgnoreCase))
                    txt.CssClass = "holiday-box";
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            ClearMessage();
            int headerId;
            if (!int.TryParse(hfHeaderId.Value, out headerId))
            {
                ShowMessage("Please generate or load monthly sheet first.", false);
                return;
            }

            DataTable details = CreateDetailDataTable();

            foreach (GridViewRow row in gvHours.Rows)
            {
                DateTime workDate = DateTime.ParseExact(row.Cells[1].Text, "d-MMM-yy", CultureInfo.InvariantCulture);

                for (int c = 2; c < gvHours.Columns.Count; c++)
                {
                    string header = gvHours.Columns[c].HeaderText;
                    TextBox txt = row.Cells[c].FindControl("txtCell") as TextBox;
                    string value = txt == null ? "" : txt.Text.Trim();

                    string operatorType = header.StartsWith("Extra", StringComparison.OrdinalIgnoreCase) ? "Extra" : "Regular";
                    int operatorNo = ExtractOperatorNo(header);

                    DataRow dr = details.NewRow();
                    dr["WorkDate"] = workDate;
                    dr["OperatorNo"] = operatorNo;
                    dr["OperatorType"] = operatorType;

                    if (value.Equals("HOLIDAY", StringComparison.OrdinalIgnoreCase))
                    {
                        dr["Hours"] = DBNull.Value;
                        dr["IsHoliday"] = true;
                        dr["DisplayText"] = "HOLIDAY";
                    }
                    else if (string.IsNullOrWhiteSpace(value))
                    {
                        dr["Hours"] = DBNull.Value;
                        dr["IsHoliday"] = false;
                        dr["DisplayText"] = DBNull.Value;
                    }
                    else
                    {
                        decimal hours;
                        if (!decimal.TryParse(value, out hours))
                        {
                            ShowMessage("Invalid hours found on " + workDate.ToString("d-MMM-yy") + ". Use number or HOLIDAY.", false);
                            return;
                        }
                        dr["Hours"] = hours;
                        dr["IsHoliday"] = false;
                        dr["DisplayText"] = DBNull.Value;
                    }
                    details.Rows.Add(dr);
                }
            }

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("usp_SaveProjectMonthlyHours", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@HeaderId", headerId);
                SqlParameter tvp = cmd.Parameters.AddWithValue("@Details", details);
                tvp.SqlDbType = SqlDbType.Structured;
                tvp.TypeName = "ProjectMonthlyHoursType";
                con.Open();
                cmd.ExecuteNonQuery();
            }

            BindMonthlyGrid(headerId);
            ShowMessage("Draft saved successfully.", true);
        }

        private DataTable CreateDetailDataTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("WorkDate", typeof(DateTime));
            dt.Columns.Add("OperatorNo", typeof(int));
            dt.Columns.Add("OperatorType", typeof(string));
            dt.Columns.Add("Hours", typeof(decimal));
            dt.Columns.Add("IsHoliday", typeof(bool));
            dt.Columns.Add("DisplayText", typeof(string));
            return dt;
        }

        private int ExtractOperatorNo(string header)
        {
            string digits = new string(header.Where(char.IsDigit).ToArray());
            return string.IsNullOrWhiteSpace(digits) ? 1 : Convert.ToInt32(digits);
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = msg;
            lblMessage.ForeColor = success ? System.Drawing.Color.Green : System.Drawing.Color.Red;
        }

        private void ClearMessage()
        {
            lblMessage.Text = "";
        }

        public class TextBoxTemplate : ITemplate
        {
            private readonly string fieldName;
            public TextBoxTemplate(string fieldName) { this.fieldName = fieldName; }

            public void InstantiateIn(Control container)
            {
                TextBox txt = new TextBox();
                txt.ID = "txtCell";
                txt.DataBinding += delegate (object sender, EventArgs e)
                {
                    TextBox t = (TextBox)sender;
                    GridViewRow row = (GridViewRow)t.NamingContainer;
                    object value = DataBinder.Eval(row.DataItem, fieldName);
                    t.Text = value == null ? "" : value.ToString();
                };
                container.Controls.Add(txt);
            }
        }
    }
}