using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using WebPortal.App_Code.BLL;

namespace WebPortal.Admin
{
    public partial class HRDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetDashboardSnapshot(string Month, string Year)
        {
            string selectedMonth = string.IsNullOrEmpty(Month) ? DateTime.Now.ToString("MMMM") : Month;
            string selectedYear = string.IsNullOrEmpty(Year) ? DateTime.Now.Year.ToString() : Year;
            List<string> errors = new List<string>();
            bllMaster master = new bllMaster();

            DataTable manpowerAll = TryGetTable(delegate { return master.GetCurrentManpowerSummary("All"); }, errors, "Manpower");
            DataTable manpowerPresent = TryGetTable(delegate { return master.GetCurrentManpowerSummary("Present"); }, errors, "Attendance");
            DataTable manpowerLeave = TryGetTable(delegate { return master.GetCurrentManpowerSummary("Leave"); }, errors, "Leave");
            DataSet recruitment = TryGetDataSet(delegate { return master.GetRequisition(selectedMonth, selectedYear); }, errors, "Recruitment");
            DataSet hiring = TryGetDataSet(delegate { return master.GetHiring(selectedMonth, selectedYear); }, errors, "Hiring");
            DataSet attrition = TryGetDataSet(delegate { return master.GetAttritionReportForHRReport(selectedMonth, selectedYear); }, errors, "Attrition");
            DataTable newJoinees = TryGetTable(delegate { return master.GetAllNewJoineeReport_Revised(selectedMonth, selectedYear); }, errors, "New joinee");
            DataTable newJoineeFollowups = TryGetTable(delegate { return master.GetNewJoineeFollowUp(selectedMonth, selectedYear); }, errors, "New joinee follow-up");
            DataSet leaves = TryGetDataSet(delegate { return master.GetTotalLeaves_Revised(selectedMonth, selectedYear); }, errors, "Leave report");
            DataTable birthdays = TryGetTable(delegate { return master.GetBirthdayList(); }, errors, "Birthday");

            Dictionary<string, object> snapshot = new Dictionary<string, object>();
            snapshot.Add("Month", selectedMonth);
            snapshot.Add("Year", selectedYear);
            snapshot.Add("GeneratedOn", DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"));
            snapshot.Add("Kpis", BuildKpis(manpowerAll, manpowerPresent, manpowerLeave, recruitment, hiring, attrition, newJoinees, newJoineeFollowups, leaves, birthdays));
            snapshot.Add("DomainBreakdown", BuildGroupBreakdown(manpowerAll, "DomainGroupName", 8));
            snapshot.Add("BranchBreakdown", BuildBranchBreakdown(manpowerAll, 8));
            snapshot.Add("ActionQueue", BuildActionQueue(recruitment, attrition, newJoinees, newJoineeFollowups, leaves, birthdays));
            snapshot.Add("Errors", errors);

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(snapshot);
        }

        private static Dictionary<string, object> BuildKpis(DataTable manpowerAll, DataTable manpowerPresent, DataTable manpowerLeave, DataSet recruitment, DataSet hiring, DataSet attrition, DataTable newJoinees, DataTable newJoineeFollowups, DataSet leaves, DataTable birthdays)
        {
            decimal totalEmployees = SumColumn(manpowerAll, "Total");
            decimal onFloorEmployees = SumColumn(manpowerAll, "OnFloor");
            decimal resignedEmployees = SumColumn(manpowerAll, "Resigned");
            decimal abscondingEmployees = SumColumn(manpowerAll, "Absconding");
            decimal presentToday = SumColumn(manpowerPresent, "OnFloor", "Total");
            decimal onLeave = SumColumn(manpowerLeave, "OnFloor", "Total");
            int recruitmentRows = CountRows(recruitment, 0);
            int hiringRows = CountRows(hiring, 0);
            int attritionRows = CountRows(attrition, 0);
            int leaveRows = CountRows(leaves, 1);

            Dictionary<string, object> kpis = new Dictionary<string, object>();
            kpis.Add("TotalEmployees", totalEmployees);
            kpis.Add("OnFloorEmployees", onFloorEmployees);
            kpis.Add("ResignedEmployees", resignedEmployees);
            kpis.Add("AbscondingEmployees", abscondingEmployees);
            kpis.Add("PresentToday", presentToday);
            kpis.Add("OnLeave", onLeave);
            kpis.Add("HiringPipeline", recruitmentRows + hiringRows);
            kpis.Add("RecruitmentRecords", recruitmentRows);
            kpis.Add("HiringRecords", hiringRows);
            kpis.Add("NewJoinees", newJoinees.Rows.Count);
            kpis.Add("NewJoineeFollowups", newJoineeFollowups.Rows.Count);
            kpis.Add("LeaveRecords", leaveRows);
            kpis.Add("AttritionCases", attritionRows);
            kpis.Add("BirthdayCount", birthdays.Rows.Count);
            kpis.Add("AttendanceRate", Ratio(presentToday, totalEmployees));
            kpis.Add("LeaveRate", Ratio(onLeave, totalEmployees));
            kpis.Add("AttritionRate", Ratio(resignedEmployees, totalEmployees));
            return kpis;
        }

        private static List<Dictionary<string, object>> BuildActionQueue(DataSet recruitment, DataSet attrition, DataTable newJoinees, DataTable newJoineeFollowups, DataSet leaves, DataTable birthdays)
        {
            List<Dictionary<string, object>> queue = new List<Dictionary<string, object>>();
            queue.Add(ActionItem("Recruitment", "Open candidate and requisition activity for the selected period.", CountRows(recruitment, 0), "Requisition.aspx", "fas fa-user-plus"));
            queue.Add(ActionItem("Onboarding", "New joinee records and follow-up touchpoints requiring HR attention.", newJoinees.Rows.Count + newJoineeFollowups.Rows.Count, "NewJoineeHRFollowup.aspx", "fas fa-id-card"));
            queue.Add(ActionItem("Attendance & Leave", "Leave records and attendance-sensitive items to keep teams covered.", CountRows(leaves, 1), "AbscondingAndLeaveReport.aspx", "fas fa-calendar-check"));
            queue.Add(ActionItem("Employee Engagement", "Birthdays, recognition, and employee connection moments.", birthdays.Rows.Count, "RewardAndRecognition.aspx", "fas fa-award"));
            queue.Add(ActionItem("Exit Management", "Attrition and resignation activity for HR review.", CountRows(attrition, 0), "AllResignedEmployees.aspx", "fas fa-sign-out-alt"));
            queue.Add(ActionItem("Compliance", "HR induction, policy, POSH, KYC, and document health sections.", 0, "HRInduction.aspx", "fas fa-shield-alt"));
            return queue;
        }

        private static Dictionary<string, object> ActionItem(string title, string description, int count, string url, string icon)
        {
            Dictionary<string, object> item = new Dictionary<string, object>();
            item.Add("Title", title);
            item.Add("Description", description);
            item.Add("Count", count);
            item.Add("Url", url);
            item.Add("Icon", icon);
            return item;
        }

        private static List<Dictionary<string, object>> BuildGroupBreakdown(DataTable table, string groupColumn, int limit)
        {
            Dictionary<string, decimal> groups = new Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase);

            if (table != null && table.Columns.Contains(groupColumn))
            {
                foreach (DataRow row in table.Rows)
                {
                    string name = Convert.ToString(row[groupColumn]);
                    if (string.IsNullOrEmpty(name))
                    {
                        name = "Unassigned";
                    }

                    if (!groups.ContainsKey(name))
                    {
                        groups.Add(name, 0);
                    }

                    groups[name] += GetDecimal(row, "Total");
                }
            }

            return groups
                .OrderByDescending(x => x.Value)
                .Take(limit)
                .Select(x =>
                {
                    Dictionary<string, object> item = new Dictionary<string, object>();
                    item.Add("Name", x.Key);
                    item.Add("Total", x.Value);
                    return item;
                })
                .ToList();
        }

        private static List<Dictionary<string, object>> BuildBranchBreakdown(DataTable table, int limit)
        {
            Dictionary<string, Dictionary<string, object>> branches = new Dictionary<string, Dictionary<string, object>>(StringComparer.OrdinalIgnoreCase);

            if (table != null && table.Columns.Contains("BranchName"))
            {
                foreach (DataRow row in table.Rows)
                {
                    string name = Convert.ToString(row["BranchName"]);
                    if (string.IsNullOrEmpty(name))
                    {
                        name = "Unassigned";
                    }

                    if (!branches.ContainsKey(name))
                    {
                        Dictionary<string, object> branch = new Dictionary<string, object>();
                        branch.Add("Name", name);
                        branch.Add("Total", 0m);
                        branch.Add("OnFloor", 0m);
                        branch.Add("Resigned", 0m);
                        branch.Add("Absconding", 0m);
                        branches.Add(name, branch);
                    }

                    branches[name]["Total"] = ToDecimal(branches[name]["Total"]) + GetDecimal(row, "Total");
                    branches[name]["OnFloor"] = ToDecimal(branches[name]["OnFloor"]) + GetDecimal(row, "OnFloor");
                    branches[name]["Resigned"] = ToDecimal(branches[name]["Resigned"]) + GetDecimal(row, "Resigned");
                    branches[name]["Absconding"] = ToDecimal(branches[name]["Absconding"]) + GetDecimal(row, "Absconding");
                }
            }

            return branches.Values
                .OrderByDescending(x => ToDecimal(x["Total"]))
                .Take(limit)
                .ToList();
        }

        private static DataTable TryGetTable(Func<DataTable> loader, List<string> errors, string label)
        {
            try
            {
                DataTable table = loader();
                return table ?? new DataTable();
            }
            catch
            {
                errors.Add(label + " data could not be loaded.");
                return new DataTable();
            }
        }

        private static DataSet TryGetDataSet(Func<DataSet> loader, List<string> errors, string label)
        {
            try
            {
                DataSet dataSet = loader();
                return dataSet ?? new DataSet();
            }
            catch
            {
                errors.Add(label + " data could not be loaded.");
                return new DataSet();
            }
        }

        private static int CountRows(DataSet dataSet, int tableIndex)
        {
            if (dataSet == null || dataSet.Tables.Count <= tableIndex || dataSet.Tables[tableIndex] == null)
            {
                return 0;
            }

            return dataSet.Tables[tableIndex].Rows.Count;
        }

        private static decimal SumColumn(DataTable table, params string[] columnNames)
        {
            if (table == null || table.Rows.Count == 0)
            {
                return 0;
            }

            foreach (string columnName in columnNames)
            {
                if (!table.Columns.Contains(columnName))
                {
                    continue;
                }

                decimal total = 0;
                foreach (DataRow row in table.Rows)
                {
                    total += GetDecimal(row, columnName);
                }
                return total;
            }

            return 0;
        }

        private static decimal GetDecimal(DataRow row, string columnName)
        {
            if (row == null || row.Table == null || !row.Table.Columns.Contains(columnName) || row[columnName] == DBNull.Value)
            {
                return 0;
            }

            return ToDecimal(row[columnName]);
        }

        private static decimal ToDecimal(object value)
        {
            if (value == null || value == DBNull.Value)
            {
                return 0;
            }

            decimal parsed;
            return decimal.TryParse(Convert.ToString(value), out parsed) ? parsed : 0;
        }

        private static decimal Ratio(decimal value, decimal total)
        {
            if (total <= 0)
            {
                return 0;
            }

            return Math.Round((value / total) * 100, 1);
        }
    }
}
