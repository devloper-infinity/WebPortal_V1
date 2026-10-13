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

        public void DeleteField(long fieldId)
        {
            db.ExecText(@"IF EXISTS(SELECT 1 FROM dbo.AssetEmployeeITFieldMaster WHERE FieldID=@FieldID AND IsSystem=1)
    RAISERROR('System fields cannot be deleted.',16,1);
IF EXISTS(SELECT 1 FROM dbo.AssetEmployeeITValue WHERE FieldID=@FieldID)
    RAISERROR('This field has employee data and cannot be deleted.',16,1);
IF EXISTS(SELECT 1 FROM dbo.AssetEmployeeITFieldMaster d JOIN dbo.AssetEmployeeITFieldMaster f ON f.FieldID=@FieldID WHERE d.DependsOnFieldCode=f.FieldCode)
    RAISERROR('Another field depends on this field. Remove the dependency first.',16,1);
DELETE FROM dbo.AssetEmployeeITFieldMaster WHERE FieldID=@FieldID AND IsSystem=0;
IF @@ROWCOUNT=0 RAISERROR('Field not found.',16,1);", P("@FieldID", fieldId));
        }

        public DataTable Profile(long employeeId)
        {
            return db.QueryText(@"SELECT f.FieldID,f.FieldLabel,f.FieldCode,f.FieldType,f.DisplayOrder,f.IsRequired,f.IsReadOnly,f.DependsOnFieldCode,f.DependsOnValue,
CASE WHEN f.EmployeeInfoColumn='OfficialEmailID' THEN ISNULL(e.OfficialEmailID,'') ELSE ISNULL(v.FieldValue,'') END FieldValue
FROM dbo.EmployeeInfo e CROSS JOIN dbo.AssetEmployeeITFieldMaster f
LEFT JOIN dbo.AssetEmployeeITValue v ON v.EmployeeID=e.EmployeeID AND v.FieldID=f.FieldID
WHERE e.EmployeeID=@EmployeeID AND f.IsActive=1 ORDER BY f.DisplayOrder,f.FieldLabel", P("@EmployeeID", employeeId));
        }

        public DataSet MasterReport(string search)
        {
            var result = new DataSet();
            result.Tables.Add(db.QueryText(@"SELECT FieldCode,FieldLabel FROM dbo.AssetEmployeeITFieldMaster
WHERE IsActive=1 AND FieldCode NOT IN ('USER_NAME','EMPLOYEE_CODE','OFFICIAL_EMAIL','DOMAIN','WORK_FROM_HOME','OFFICE_BRANCH',
'LAPTOP','LAPTOP_SERIAL_NUMBER','LAPTOP_BARCODE','CPU_BRAND','CPU_SERIAL_NUMBER','CPU_BARCODE','MONITOR_BRAND','MONITOR_SERIAL_NUMBER','MONITOR_BARCODE',
'KEYBOARD_BRAND','KEYBOARD_SERIAL_NUMBER','KEYBOARD_BARCODE','MOUSE_BRAND','MOUSE_SERIAL_NUMBER','MOUSE_BARCODE','HEADPHONE')
ORDER BY DisplayOrder,FieldLabel"));
            result.Tables.Add(db.QueryText(@"SELECT e.EmployeeID,
LTRIM(RTRIM(ISNULL(e.FirstName,'')+' '+ISNULL(e.MiddleName,'')+' '+ISNULL(e.lastName,''))) UserName,
e.Code EmployeeCode,e.OfficialEmailID PrimaryEmailID,e.Domain
FROM dbo.EmployeeInfo e
WHERE ISNULL(e.IsDelete,0)=0
AND (EXISTS(SELECT 1 FROM dbo.AssetEmployeeITValue v WHERE v.EmployeeID=e.EmployeeID)
 OR EXISTS(SELECT 1 FROM dbo.AssetsAllocation a WHERE a.EmployeeID=e.EmployeeID AND a.IsDeleted=0 AND a.Status='Allocated'))
AND (@Search IS NULL OR e.Code LIKE '%'+@Search+'%' OR e.FirstName LIKE '%'+@Search+'%' OR e.lastName LIKE '%'+@Search+'%' OR e.OfficialEmailID LIKE '%'+@Search+'%')
ORDER BY e.FirstName,e.lastName", P("@Search", string.IsNullOrWhiteSpace(search) ? null : search.Trim())));
            result.Tables.Add(db.QueryText(@"SELECT a.EmployeeID,t.AssetTypeName,b.BrandName,m.SerialNumber,m.Barcode
FROM dbo.AssetsAllocation a
JOIN dbo.AssetsMaster m ON m.AssetID=a.AssetID AND m.IsDeleted=0
JOIN dbo.AssetTypeMaster t ON t.AssetTypeID=m.AssetTypeID
LEFT JOIN dbo.AssetBrandMaster b ON b.AssetBrandID=m.AssetBrandID
WHERE a.IsDeleted=0 AND a.Status='Allocated'
ORDER BY a.EmployeeID,t.AssetTypeName,m.AssetID"));
            result.Tables.Add(db.QueryText(@"SELECT v.EmployeeID,f.FieldCode,v.FieldValue
FROM dbo.AssetEmployeeITValue v JOIN dbo.AssetEmployeeITFieldMaster f ON f.FieldID=v.FieldID
WHERE f.IsActive=1"));
            return result;
        }
    }
}
