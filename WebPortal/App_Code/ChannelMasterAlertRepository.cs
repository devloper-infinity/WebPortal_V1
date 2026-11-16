using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using WebPortal.App_Code.DAL;

namespace WebPortal.App_Code
{
    internal sealed class ChannelMasterAlertRepository
    {
        internal List<string> MissingChannels(int projectId)
        {
            HashSet<string> configured = ReadValues(SQLHelper.ConnectionString, @"
SELECT DISTINCT LTRIM(RTRIM(value.FieldValue)) AS Channel
FROM dbo.OLTracking_ImportItemValue value
INNER JOIN dbo.WBT_ProjectTrackingFieldConfig field
    ON field.FieldConfigId=value.FieldConfigId
   AND field.ProjectID=@ProjectID
   AND field.IsDeleted=0
INNER JOIN dbo.OLTracking_Item item
    ON item.ItemID=value.ItemID
   AND item.ProjectID=@ProjectID
   AND item.IsDeleted=0
WHERE LTRIM(RTRIM(field.FieldName))='Channel'
  AND NULLIF(LTRIM(RTRIM(value.FieldValue)),'') IS NOT NULL;", projectId);

            HashSet<string> master = ReadValues(SQLHelper.ConnectionString_Underwriting, @"
SELECT DISTINCT LTRIM(RTRIM(Channel)) AS Channel
FROM dbo.InfinityBilling_ChannelMaster
WHERE NULLIF(LTRIM(RTRIM(Channel)),'') IS NOT NULL;", null);

            return configured.Where(channel => !master.Contains(channel)).OrderBy(channel => channel, StringComparer.OrdinalIgnoreCase).ToList();
        }

        private static HashSet<string> ReadValues(string connectionString, string sql, int? projectId)
        {
            HashSet<string> values = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(sql, connection))
            {
                if (projectId.HasValue) command.Parameters.Add("@ProjectID", SqlDbType.Int).Value = projectId.Value;
                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                    while (reader.Read())
                    {
                        string value = reader.IsDBNull(0) ? string.Empty : Convert.ToString(reader.GetValue(0)).Trim();
                        if (value.Length > 0) values.Add(value);
                    }
            }
            return values;
        }
    }
}
