using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using WebPortal.App_Code.BLL;

namespace WebPortal.Production
{
    public partial class ProjectTrackingSheet : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string GetProjects()
        {
            DataTable dt = new bllMaster().GetAllProject();
            return SerializeDataTable(dt);
        }

        [WebMethod]
        public static string GetSheet(int projectId, string fromDate, string toDate)
        {
            bllProjectTracking tracking = new bllProjectTracking();
            DataTable fieldTable = tracking.GetSheetFieldConfigurations(projectId);
            DataTable rowTable = tracking.GetProjectTrackingRows(projectId, fromDate, toDate);

            var rowsById = new Dictionary<int, TrackingRowDto>();
            var rows = new List<TrackingRowDto>();

            foreach (DataRow row in rowTable.Rows)
            {
                int rowId = Convert.ToInt32(row["RowId"]);

                if (!rowsById.ContainsKey(rowId))
                {
                    rowsById.Add(rowId, new TrackingRowDto
                    {
                        RowId = rowId,
                        EntryDate = Convert.ToString(row["EntryDate"]),
                        Values = new Dictionary<string, string>()
                    });
                    rows.Add(rowsById[rowId]);
                }

                if (row["FieldConfigId"] != DBNull.Value)
                {
                    string fieldConfigId = Convert.ToString(row["FieldConfigId"]);
                    rowsById[rowId].Values[fieldConfigId] = Convert.ToString(row["FieldValue"]);
                }
            }

            var sheet = new
            {
                Fields = ToFieldList(fieldTable),
                Rows = rows
            };

            return SerializeObject(sheet);
        }

        [WebMethod]
        public static int SaveRows(int projectId, List<TrackingRowSaveDto> rows)
        {
            if (rows == null || rows.Count == 0)
            {
                return 0;
            }

            int savedRows = 0;
            int userId = GetCurrentUserId();
            bllProjectTracking tracking = new bllProjectTracking();

            foreach (TrackingRowSaveDto row in rows)
            {
                DataTable values = CreateValueTable(row.Values);
                int rowId = tracking.SaveProjectTrackingRow(projectId, row.RowId, row.EntryDate, values, userId);

                if (rowId > 0)
                {
                    savedRows++;
                }
            }

            return savedRows;
        }

        [WebMethod]
        public static int DeleteRow(int rowId)
        {
            return new bllProjectTracking().DeleteProjectTrackingRow(rowId, GetCurrentUserId());
        }

        private static int GetCurrentUserId()
        {
            return int.Parse(HttpContext.Current.User.Identity.Name);
        }

        private static DataTable CreateValueTable(List<TrackingCellSaveDto> cells)
        {
            DataTable values = new DataTable();
            values.Columns.Add("FieldConfigId", typeof(int));
            values.Columns.Add("FieldValue", typeof(string));

            if (cells == null)
            {
                return values;
            }

            foreach (TrackingCellSaveDto cell in cells)
            {
                values.Rows.Add(cell.FieldConfigId, cell.FieldValue ?? string.Empty);
            }

            return values;
        }

        private static List<TrackingFieldDto> ToFieldList(DataTable fieldTable)
        {
            var fields = new List<TrackingFieldDto>();

            foreach (DataRow row in fieldTable.Rows)
            {
                fields.Add(new TrackingFieldDto
                {
                    FieldConfigId = Convert.ToInt32(row["FieldConfigId"]),
                    FieldName = Convert.ToString(row["FieldName"]),
                    DataType = Convert.ToString(row["DataType"]),
                    OptionsText = Convert.ToString(row["OptionsText"]),
                    DateFormat = row.Table.Columns.Contains("DateFormat") ? Convert.ToString(row["DateFormat"]) : string.Empty,
                    IsRequired = row.Table.Columns.Contains("IsRequired") ? Convert.ToBoolean(row["IsRequired"]) : false,
                    IsEditable = row.Table.Columns.Contains("IsEditable") ? Convert.ToBoolean(row["IsEditable"]) : true,
                    IsProcessColumn = row.Table.Columns.Contains("IsProcessColumn") ? Convert.ToBoolean(row["IsProcessColumn"]) : false,
                    IsSystemGenerated = row.Table.Columns.Contains("IsSystemGenerated") ? Convert.ToBoolean(row["IsSystemGenerated"]) : false,
                    ParentProcessFieldConfigId = row.Table.Columns.Contains("ParentProcessFieldConfigId") && row["ParentProcessFieldConfigId"] != DBNull.Value ? Convert.ToInt32(row["ParentProcessFieldConfigId"]) : 0,
                    ProcessChildType = row.Table.Columns.Contains("ProcessChildType") ? Convert.ToString(row["ProcessChildType"]) : string.Empty
                });
            }

            return fields;
        }

        private static string SerializeDataTable(DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }

            return SerializeObject(rows);
        }

        private static string SerializeObject(object value)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(value);
        }
    }

    public class TrackingFieldDto
    {
        public int FieldConfigId { get; set; }
        public string FieldName { get; set; }
        public string DataType { get; set; }
        public string OptionsText { get; set; }
        public string DateFormat { get; set; }
        public bool IsRequired { get; set; }
        public bool IsEditable { get; set; }
        public bool IsProcessColumn { get; set; }
        public bool IsSystemGenerated { get; set; }
        public int ParentProcessFieldConfigId { get; set; }
        public string ProcessChildType { get; set; }
    }

    public class TrackingRowDto
    {
        public int RowId { get; set; }
        public string EntryDate { get; set; }
        public Dictionary<string, string> Values { get; set; }
    }

    public class TrackingRowSaveDto
    {
        public int RowId { get; set; }
        public string EntryDate { get; set; }
        public List<TrackingCellSaveDto> Values { get; set; }
    }

    public class TrackingCellSaveDto
    {
        public int FieldConfigId { get; set; }
        public string FieldValue { get; set; }
    }
}
