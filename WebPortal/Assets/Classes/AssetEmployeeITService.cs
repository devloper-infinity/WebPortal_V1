using System;
using System.Data;
using System.Data.SqlClient;

namespace WebPortal.Assets.Classes
{
    public sealed class AssetEmployeeITService
    {
        private readonly AssetDbHelper db = new AssetDbHelper();
        private static SqlParameter P(string name, object value) { return new SqlParameter(name, value ?? DBNull.Value); }

        public DataTable Fields(bool activeOnly)
        {
            return db.QueryText(@"SELECT FieldID,FieldLabel,FieldCode,FieldType,DisplayOrder,IsRequired,IsActive,IsSystem,IsReadOnly,EmployeeInfoColumn,DependsOnFieldCode,DependsOnValue
FROM dbo.AssetEmployeeITFieldMaster WHERE (@ActiveOnly=0 OR IsActive=1) ORDER BY DisplayOrder,FieldLabel", P("@ActiveOnly", activeOnly));
        }

        public long SaveField(EmployeeITFieldInput input, long userId)
        {
            if (input == null) throw new ArgumentNullException("input");
            if (string.IsNullOrWhiteSpace(input.FieldLabel)) throw new ArgumentException("Field label is required.");
            if (string.IsNullOrWhiteSpace(input.FieldCode)) throw new ArgumentException("Field code is required.");
            return Convert.ToInt64(db.Scalar("usp_Assets_SaveEmployeeITField", P("@FieldID", input.FieldID), P("@FieldLabel", input.FieldLabel.Trim()),
                P("@FieldCode", input.FieldCode.Trim().ToUpperInvariant()), P("@FieldType", input.FieldType), P("@DisplayOrder", input.DisplayOrder),
                P("@IsRequired", input.IsRequired), P("@IsActive", input.IsActive), P("@DependsOnFieldCode", input.DependsOnFieldCode),
                P("@DependsOnValue", input.DependsOnValue), P("@UserID", userId)));
        }

        public DataTable Profile(long employeeId)
        {
            return db.QueryText(@"SELECT f.FieldID,f.FieldLabel,f.FieldCode,f.FieldType,f.DisplayOrder,f.IsRequired,f.IsReadOnly,f.DependsOnFieldCode,f.DependsOnValue,
CASE WHEN f.EmployeeInfoColumn='OfficialEmailID' THEN ISNULL(e.OfficialEmailID,'') ELSE ISNULL(v.FieldValue,'') END FieldValue
FROM dbo.EmployeeInfo e CROSS JOIN dbo.AssetEmployeeITFieldMaster f
LEFT JOIN dbo.AssetEmployeeITValue v ON v.EmployeeID=e.EmployeeID AND v.FieldID=f.FieldID
WHERE e.EmployeeID=@EmployeeID AND f.IsActive=1 ORDER BY f.DisplayOrder,f.FieldLabel", P("@EmployeeID", employeeId));
        }
    }
}
